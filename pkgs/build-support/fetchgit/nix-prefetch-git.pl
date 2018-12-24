print("I am nix-prefetch-git.pl ".(join ' ', @ARGV)."\n");

#$ENV{GIT_TRACE}='1';
#$ENV{GIT_TRANSPORT_HELPER_DEBUG}='1';
#$ENV{GIT_TRANSLOOP_DEBUG}='1';
#$ENV{PATH} = "C:/msys64/home/User/t/git-2.19.1/bin;$ENV{PATH}";
#$ENV{PATH} = "C:/Git/bin;$ENV{PATH}";


use Cwd;
use File::Path qw(remove_tree);
use File::Find qw(find);
use File::Basename qw(basename);

my $url     = '';
my $rev     = '';
my $expHash = '';
my $hashType        = $ENV{NIX_HASH_ALGO} || '';
my $deepClone       = $ENV{NIX_PREFETCH_GIT_DEEP_CLONE}    ? 1 : 0;
my $leaveDotGit     = $ENV{NIX_PREFETCH_GIT_LEAVE_DOT_GIT} ? 1 : 0;
my $fetchSubmodules = 0;
my $builder         = 0;
my $QUIET           = 0;
my $branchName      = $ENV{NIX_PREFETCH_GIT_BRANCH_NAME} || '';

# ENV params
my $out        = $ENV{out} || '';
my $http_proxy = $ENV{http_proxy} || '';

# populated by clone_user_rev()
my $fullRev              = '';
my $humanReadableRev     = '';
my $commitDate           = '';
my $commitDateStrict8601 = '';


sub usage {
  print STDERR "syntax: nix-prefetch-git [options] [URL [REVISION [EXPECTED-HASH]]]

Options:
      --out path      Path where the output would be stored.
      --url url       Any url understood by 'git clone'.
      --rev ref       Any sha1 or references (such as refs/heads/master)
      --hash h        Expected hash.
      --deepClone     Clone the entire repository.
      --no-deepClone  Make a shallow clone of just the required ref.
      --leave-dotGit  Keep the .git directories.
      --fetch-submodules Fetch submodules.
      --builder       Clone as fetchgit does, but url, rev, and out option are mandatory.
      --quiet         Only print the final json summary.
";
  exit(1);
}

while (@ARGV) {
  my $cmd = shift @ARGV;
       if ($cmd eq '--out'             ) { $out             = shift @ARGV;
  } elsif ($cmd eq '--url'             ) { $url             = shift @ARGV;
  } elsif ($cmd eq '--rev'             ) { $rev             = shift @ARGV;
  } elsif ($cmd eq '--hash'            ) { $hashType        = shift @ARGV;
  } elsif ($cmd eq '--branch-name'     ) { $branchName      = shift @ARGV;
  } elsif ($cmd eq '--deepClone'       ) { $deepClone       = 1;
  } elsif ($cmd eq '--quiet'           ) { $QUIET           = 1;
  } elsif ($cmd eq '--no-deepClone'    ) { $deepClone       = 0;
  } elsif ($cmd eq '--leave-dotGit'    ) { $leaveDotGit     = 1;
  } elsif ($cmd eq '--fetch-submodules') { $fetchSubmodules = 1;
  } elsif ($cmd eq '--builder'         ) { $builder         = 1;
  } elsif ($cmd eq '--help'            ) { usage();
  } elsif (@ARGS == 1                  ) { $url             = shift @ARGV;
  } elsif (@ARGS == 2                  ) { $url             = shift @ARGV;
                                           $rev             = shift @ARGV;
  } elsif (@ARGS == 3                  ) { $url             = shift @ARGV;
                                           $rev             = shift @ARGV;
                                           $expHash         = shift @ARGV;
  } else                                 { usage();
  }
}

usage() unless $url;


sub init_remote {
  my ($url) = @_;
  system("git init"                             ) == 0 or die;
  system("git remote add origin \"$url\""       ) == 0 or die;
  system("git config http.proxy \"$http_proxy\"") == 0 or die if $http_proxy;
}

# Return the reference of an hash if it exists on the remote repository.
sub ref_from_hash {
  my ($hash) = @_;
  return $1 if `git ls-remote origin` =~ /^$hash\s+(.+)$/m;
  return '';
}

# Return the hash of a reference if it exists on the remote repository.
sub hash_from_ref {
  my ($ref) = @_;
  return $1 if `git ls-remote origin` =~ /^(.+)\s+\Q$ref\E$/m;
  return '';
}

# Returns a name based on the url and reference
#
# This function needs to be in sync with nix's fetchgit implementation
# of urlToName() to re-use the same nix store paths.
sub url_to_name {
  my ($url, $ref) = @_;
  my $base = basename($url, '.git'); # | cut -d: -f2)
  $base =~ s/[^:]+:([^:]+)/\1/;

  return $ref =~ /^[a-z0-9]+$/ ? "$base-".($ref =~ s/^([a-z0-9]{1,7}).*/\1/r) : $base;
}

# Fetch everything and checkout the right sha1
sub checkout_hash {
  my ($hash, $ref) = @_;
  $hash = hash_from_ref($ref) unless $hash;

  print("checkout_hash($hash, $ref)\n");

  if (system("git fetch -t".($builder ? ' --progress' : '')." origin") != 0) { print STDERR "git fetch    failed\n\n\n"; return 1; }
  if (system("git checkout -b \"$branchName\" \"$hash\""             ) != 0) { print STDERR "git checkout failed\n\n\n"; return 1; }
  return 0;
}

# Fetch only a branch/tag and checkout it.
sub checkout_ref {
  my ($hash, $ref) = @_;

  if ($deepClone) {
    # The caller explicitly asked for a deep clone.  Deep clones
    # allow "git describe" and similar tools to work.  See
    # http://thread.gmane.org/gmane.linux.distributions.nixos/3569
    # for a discussion.
    return 1;
  }

  $ref = ref_from_hash($hash) unless $ref;
  print("checkout_ref($hash, $ref)\n");

  return 1 unless $ref;

  # --depth option is ignored on http repository.
  if (system("git fetch".($builder ? ' --progress' : '')." --depth 1 origin \"+$ref\"") != 0) { print STDERR "git fetch    failed\n\n\n"; exit(1); return 1; }
  if (system("git checkout -b \"$branchName\" FETCH_HEAD"                             ) != 0) { print STDERR "git checkout failed\n\n\n"; return 1; }
  return 0;
}

# Update submodules TODO: git-submodule is written in bash
sub init_submodules {
  # Add urls into .git/config file
#  system("git submodule init") == 0 or die $!;
#
#  my $dump = `git submodule status`;
#
#  if ($dump) {
#    print("dump4='$dump'\n");
#    die 'todo: init_submodules';
#  }

##  # list submodule directories and their hashes
##  git submodule status |
##  while read -r l; do
##      local hash
##      local dir
##      local name
##      local url
##
##      # checkout each submodule
##      hash=$(echo "$l" | awk '{print $1}' | tr -d '-')
##      dir=$(echo "$l" | sed -n 's/^.[0-9a-f]\+ \(.*[^)]*\)\( (.*)\)\?$/\1/p')
##      name=$(
##          git config -f .gitmodules --get-regexp submodule\..*\.path |
##          sed -n "s,^\(.*\)\.path $dir\$,\\1,p")
##      url=$(git config --get "${name}.url")
##
##      clone "$dir" "$url" "$hash" ""
##  done
}

sub clone {
  my ($dir, $url, $hash, $ref) = @_;
  my $top = getcwd();

  chdir($dir);

  # Initialize the repository.
  init_remote($url);

    # Download data from the repository.
  if (checkout_ref($hash, $ref) != 0) {
    if (checkout_hash($hash, $ref) != 0) {
      die "Unable to checkout $hash$ref from $url.";
    }
  }

  # Checkout linked sources.
  init_submodules() if $fetchSubmodules;

  if (!$builder && -f '.topdeps') {
    die 'todo: TopGit';
##      if tg help &>/dev/null; then
##          echo "populating TopGit branches..."
##          tg remote --populate origin
##      else
##          echo "WARNING: would populate TopGit branches but TopGit is not available" >&2
##          echo "WARNING: install TopGit to fix the problem" >&2
##      fi
  }

  chdir($top);
}

# Remove all remote branches, remove tags not reachable from HEAD, do a full
# repack and then garbage collect unreferenced objects.
sub make_deterministic_repo {
  my ($repo) = @_;

  die("todo: make_deterministic_repo $repo\n");
##  # run in sub-shell to not touch current working directory
##  (
##  cd "$repo"
##  # Remove files that contain timestamps or otherwise have non-deterministic
##  # properties.
##  rm -rf .git/logs/ .git/hooks/ .git/index .git/FETCH_HEAD .git/ORIG_HEAD \
##      .git/refs/remotes/origin/HEAD .git/config
##
##  # Remove all remote branches.
##  git branch -r | while read -r branch; do
##      git branch -rD "$branch" >&2
##  done
##
##  # Remove tags not reachable from HEAD. If we're exactly on a tag, don't
##  # delete it.
##  maybe_tag=$(git tag --points-at HEAD)
##  git tag --contains HEAD | while read -r tag; do
##      if [ "$tag" != "$maybe_tag" ]; then
##          git tag -d "$tag" >&2
##      fi
##  done
##
##  # Do a full repack. Must run single-threaded, or else we lose determinism.
##  git config pack.threads 1
##  git repack -A -d -f
##  rm -f .git/config
##
##  # Garbage collect unreferenced objects.
##  git gc --prune=all
##  )
}


sub _clone_user_rev {
  my ($dir, $url, $rev) = @_;
  $rev ||= 'HEAD';

  # Perform the checkout.
  if ($rev =~ /^HEAD$|^refs\//) {
     clone($dir, $url, "", $rev); # 1>&2
  } elsif ($rev =~ /^[0-9a-f]{7,40}$/) {
     clone($dir, $url, $rev, ""); # 1>&2
  } else {
     # if revision is not hexadecimal it might be a tag
     clone($dir, $url, "", "refs/tags/$rev"); #1>&2
  }

  {
    my $top = getcwd();
    chdir($dir);

    if (system("git rev-parse \"$rev\"") == 0) {
      $fullRev = `git rev-parse "$rev"`;
    } elsif (system("git rev-parse \"refs/heads/$branchName\"") == 0) {
      $fullRev = `git rev-parse "refs/heads/$branchName"`;
    } else {
      die 'unable to get $fullRev';
    }
    chomp($fullRev);
    die "fullRev=$fullRev" if $fullRev =~ /\n/;
    if (system("git describe \"$fullRev\"") == 0) {
      $humanReadableRev = `git describe \"$fullRev\"`;
    } elsif (system("git describe --tags \"$fullRev\"") == 0) {
      $humanReadableRev = `git describe --tags \"$fullRev\"`;
    } else {
      $humanReadableRev = '-- none --';
    }
    $commitDate           = `git show -1 --no-patch --pretty=%ci "$fullRev"`;
    $commitDateStrict8601 = `git show -1 --no-patch --pretty=%cI "$fullRev"`;

    chdir($top);
  }

##  # Allow doing additional processing before .git removal
##  eval "$NIX_PREFETCH_GIT_CHECKOUT_HOOK"

  if (!$leaveDotGit) {
    print STDERR "removing \`.git'...\n";
    sub process1 { if ($_ =~ /\/\.git$/) { print STDERR "removing $_\n";                   remove_tree($_);                            } };
    find({ wanted => \&process1, no_chdir => 1}, $dir);
  } else {
    sub process2 { if ($_ =~ /\/\.git$/) { print STDERR "make_deterministic_repo $_/..\n"; make_deterministic_repo(readlink("$_/..")); } };
    find({ wanted => \&process2, no_chdir => 1}, $dir);
  }
}

sub clone_user_rev {
  my ($dir, $url, $rev) = @_;
##unless ($QUIET) {
    _clone_user_rev($dir, $url, $rev);
##} else {
##  errfile="$(mktemp "${TMPDIR:-/tmp}/git-checkout-err-XXXXXXXX")"
##  # shellcheck disable=SC2064
##  trap "rm -rf \"$errfile\"" EXIT
##  _clone_user_rev "$@" 2> "$errfile" || (
##      status="$?"
##      cat "$errfile" >&2
##      exit "$status"
##  )
##}
}

sub json_escape {
  my ($s) = @_;
  $s =~ s,\\,\\\\,g;
  $s =~ s,",\\",g;
  $s =~ s,\b,\\b,g;
  $s =~ s,\f,\\f,g;
  $s =~ s,\n,\\n,g;
  $s =~ s,\r,\\r,g;
  $s =~ s,\t,\\t,g;
  return $s;
}

sub print_results {
  my ($hash) = @_;
##unless ($QUIET) {
    print STDERR "\n";
    print STDERR "git revision is $fullRev\n";
    print STDERR "path is $finalPath\n" if $finalPath;
    print STDERR "git human-readable version is $humanReadableRev\n";
    print STDERR "Commit date is $commitDate\n";
    print STDERR "hash is $hash\n" if $hash;
##fi
  if ($hash) {
    print "{\n";
    print "  \"url\": \"".(json_escape $url)."\",\n";
    print "  \"rev\": \"".(json_escape $fullRev)."\",\n";
    print "  \"date\": \"".(json_escape $commitDateStrict8601)."\",\n";
    print "  \"".(json_escape $hashType)."\": \"".(json_escape $hash)."\",\n";
    print "  \"fetchSubmodules\": ".($fetchSubmodules ? 'true' : 'false')."\n";
    print "}\n";
  }
}


$branchName = 'fetchgit' unless $branchName;

if ($builder) {
  usage() unless $out && $url && $rev;
  if (-e $out) {
      remove_tree($out); sleep(1);
  }
  mkdir($out) or die "mkdir($out): $!";
  clone_user_rev($out, $url, $rev);
} else {
  $hashType = 'sha256' unless $hashType;

  die 'todo !$builder';

  # If the hash was given, a file with that hash may already be in the
  # store.
  if ($expHash) {
##    finalPath=$(nix-store --print-fixed-path --recursive "$hashType" "$expHash" "$(url_to_name "$url" "$rev")")
##    if ! nix-store --check-validity "$finalPath" 2> /dev/null; then
##        finalPath=
##    fi
##    hash=$expHash
  }

  # If we don't know the hash or a path with that hash doesn't exist,
  # download the file and add it to the store.
  unless ($finalPath) {

##    tmpPath="$(mktemp -d "${TMPDIR:-/tmp}/git-checkout-tmp-XXXXXXXX")"
##    # shellcheck disable=SC2064
##    trap "rm -rf \"$tmpPath\"" EXIT
##
##    tmpFile="$tmpPath/$(url_to_name "$url" "$rev")"
##    mkdir -p "$tmpFile"
##
##    # Perform the checkout.
##    clone_user_rev "$tmpFile" "$url" "$rev"
##
##    # Compute the hash.
##    hash=$(nix-hash --type $hashType --base32 "$tmpFile")
##
##    # Add the downloaded file to the Nix store.
##    finalPath=$(nix-store --add-fixed --recursive "$hashType" "$tmpFile")
##
##    if test -n "$expHash" -a "$expHash" != "$hash"; then
##        echo "hash mismatch for URL \`$url'. Got \`$hash'; expected \`$expHash'." >&2
##        exit 1
##    fi
  }

  print_results($hash);

  print "$finalPath\n" if $ENV{PRINT_PATH};
}
