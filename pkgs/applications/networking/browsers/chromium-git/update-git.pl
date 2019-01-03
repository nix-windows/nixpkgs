use strict;
use warnings;
use Cwd;
use File::Path qw(remove_tree make_path);
use File::Basename qw(dirname);

my $nix     = "$ENV{NIX}/bin/nix.exe";         die "no nix"     unless -f $nix;
my $git     = "$ENV{GIT}/bin/git.exe";         die "no git"     unless -f $git;
my $perl    = "$ENV{PERL}/bin/perl.exe";       die "no perl"    unless -f $perl;
my $python2 = "$ENV{PYTHON2}/bin/python.exe";  die "no python2" unless -f $python2;

my $version = $ARGV[0];                        die "bad version `$version'" unless defined($version) && $version =~ /^\d+(\.\d+)+$/;
my $basedir = "c:/tmp"; # short dir to avoid "filename too long" error

sub checkout {
  my ($url, $rev, $dir) = @_;
  $dir ||= "$basedir/$rev";

  if (-d $dir) {
    print("already exist $dir\n");
  } else {
    make_path($dir) or die "make_path: $!";
    my $top = getcwd();
    chdir($dir);
    system("$git init"                                       ) == 0 or die;
    system("$git remote add origin \"$url\""                 ) == 0 or die;
    system("$git fetch --progress --depth 1 origin \"+$rev\"") == 0 or die;
    system("$git checkout -b \"fetchgit\" FETCH_HEAD"        ) == 0 or die;
    remove_tree(".git");
    chdir($top);
  }

  my $hash = `$nix hash-path --base32 --type sha256 $dir` =~ s|\s+$||r;
  die "bad hash `$hash'" unless $hash =~ /^[0-9a-z]{52}$/;
  return $hash;
}

unless (-d "$basedir/depot_tools") {
  checkout("https://chromium.googlesource.com/chromium/tools/depot_tools", "db0055dc786a71fe81e720bad2b1acb0e133a291", "$basedir/depot_tools") eq "0hsjq4lbylff194bz96dkyxahql7pq59bipbfv1fb32afwfr0vya" or die;
  # patch as there is no git.bat
  open(my $fh, "$basedir/depot_tools/git_cache.py") or die;
  open(my $ou, ">$basedir/depot_tools/git_cache.py.new") or die;
  print $ou (map { s/git\.bat/git/gr } <$fh>);
  close($fh);
  close($ou);
  rename("$basedir/depot_tools/git_cache.py.new", "$basedir/depot_tools/git_cache.py");
}

# like checkout() but do not delete .git (gclient expects it) and do not compute hash
# this subdirectory must have "src" name in order gclient.py to recognise it
if (1) {
  my $top = getcwd();
  unless (-d "$basedir/src/.git") {
    make_path("$basedir/src") or die "make_path: $!";
    chdir("$basedir/src");
    system("$git init"                                                                    ) == 0 or die;
    system("$git remote add origin \"https://chromium.googlesource.com/chromium/src.git\"") == 0 or die;
    system("$git fetch --progress --depth 1 origin \"+$version\""                         ) == 0 or die;
    system("$git checkout FETCH_HEAD"                                                     ) == 0 or die;
  } else {
    chdir("$basedir/src");
    if (! -f "$basedir/src/.git/FETCH_HEAD") {
      open(my $fh, "$basedir/src/.git/FETCH_HEAD") or die "open($basedir/src/.git/FETCH_HEAD): $!";
      if (<$fh> !~ /tag '\Q$version\E' of/) { # already at $version
        system("$git fetch --progress --depth 1 origin \"+$version\""                         ) == 0 or die;
        system("$git checkout FETCH_HEAD"                                                     ) == 0 or die;
      }
      close($fh);
    }
  }
  chdir($top);
}

sub parsedeps {
  open(my $sources_nix, ">sources-$version.nix") or die;
  binmode $sources_nix;
  print $sources_nix "# GENARATED FILE\n";
  print $sources_nix "{fetchgit}:\n";
  print $sources_nix "{\n";

  my $top = getcwd();
  chdir($basedir);
  $ENV{PATH} = dirname($git) . ';' . $ENV{PATH};
  system("$python2 depot_tools/gclient.py config https://chromium.googlesource.com/chromium/src.git") == 0 or die;
  system("$python2 depot_tools/gclient.py flatten --pin-all-deps > flat"                            ) == 0 or die;

  open(my $fh, 'flat') or die;
  local $/ = undef;
  my $content = <$fh>;
  while ($content =~ /"([^"]+)":\s*\{\s*"url":\s*"(.+)@(.+)"/gm) {
    my $url = $2;
    my $rev = $3;
    my $path = $1 =~ s|\\|/|gr;
    next if $url =~ /chrome-internal\.googlesource\.com/; # access denied to this domain
    print("rem $path $url $rev\n");
    my $hash = checkout($url, $rev, "$basedir/$rev");
    #print("git clone $url $path\n");
    #print("pushd $path\n");
    #print("git checkout $rev\n");
    #print("popd\n");
    printf $sources_nix "  %-64s = fetchgit { url = %-128s; rev = \"$rev\"; sha256 = \"$hash\"; };\n", "\"$path\"", "\"$url\"";
  }
  print $sources_nix "}\n";

  chdir($top);
}

parsedeps();

exit(1);
=cut

#..\..\..\..\build-support\fetchgit\nix-prefetch-git.pl  --builder --url https://chromium.googlesource.com/chromium/tools/depot_tools.git --out .\tmp --rev db0055dc786a71fe81e720bad2b1acb0e133a291 --fetch-submodules

#git clone https://chromium.googlesource.com/chromium/tools/depot_tools
#git clone https://chromium.googlesource.com/chromium/src.git
#pushd src & git checkout 73.0.3659.1 & popd

#C:\nix\store\15viai4ccpr2yfcdvfyar4rwfsxz8xvz-perl-for-stdenv-shell-5.28.1\bin\perl.exe ..\..\..\..\build-support\fetchgit\nix-prefetch-git.pl  --builder --url https://chromium.googlesource.com/chromium/tools/depot_tools.git --out .\tmp --rev db0055dc786a71fe81e720bad2b1acb0e133a291 --fetch-submodules
#C:\nix-windows\bin\nix.exe hash-path --base32 --type sha256 tmp



#C:\nix\store\hlbxsrw1l2c3q152z4bmih3zfmdmhfi4-python-2.7.15\bin\python.exe depot_tools\gclient.py config https://chromium.googlesource.com/chromium/src.git
#C:\nix\store\hlbxsrw1l2c3q152z4bmih3zfmdmhfi4-python-2.7.15\bin\python.exe depot_tools\gclient.py flatten --pin-all-deps > flat

sub xxx {
  local $/ = undef;
  open(my $fh, 'flat') or die;
  my $content = <$fh>;
  while ($content =~ /"([^"]+)":\s*\{\s*"url":\s*"(.+)@(.+)"/gm) {
    my $url = $2;
    my $rev = $3;
    my $path = $1 =~ s|/|\\|gr;
    next if $url =~ /chrome-internal\.googlesource\.com/;
    #print("rem $path $url $rev\n");
    print("git clone $url $path\n");
    print("pushd $path\n");
    print("git checkout $rev\n");
    print("popd\n");

  }
}

xxx();