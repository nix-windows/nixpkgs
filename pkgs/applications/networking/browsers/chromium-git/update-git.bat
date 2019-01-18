@rem = '--*-Perl-*--
@echo off
set NIX=C:\nix-windows
set NIX_STORE_DIR=C:\nix\store
set NIX_PATH=nixpkgs=..\..\..\..\..

for /f %%i in ('%NIX%\bin\nix-build.exe --no-out-link -E "(import <nixpkgs> { }).git"'                                     ) do set GIT=%%i
for /f %%i in ('%NIX%\bin\nix-build.exe --no-out-link -E "(import <nixpkgs> { }).stdenv.cc.perl-for-stdenv-shell"'         ) do set PERL=%%i
for /f %%i in ('%NIX%\bin\nix-build.exe --no-out-link -E "(import <nixpkgs> { }).python27.withPackages (p: [ p.pywin32 ])"') do set PYTHON2=%%i
echo NIX=%NIX%
echo GIT=%GIT%
echo PERL=%PERL%
echo PYTHON2=%PYTHON2%

%PERL%\bin\perl.exe -x -S %0 %*

if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!/usr/bin/perl
#line 22

use strict;
use warnings;
use Cwd;
use File::Path qw(remove_tree make_path);
use File::Basename  qw(dirname basename);
use Win32::Utils    qw(readFile writeFile changeFile escapeWindowsArg dircopy readlink_f relsymlink uncsymlink symtree_reify symtree_link make_pathL remove_treeL findL);


my $nix              = "$ENV{NIX}/bin/nix.exe";         die "no nix"     unless -f $nix;
my $git              = "$ENV{GIT}/bin/git.exe";         die "no git"     unless -f $git;
my $perl             = "$ENV{PERL}/bin/perl.exe";       die "no perl"    unless -f $perl;
my $python2          = "$ENV{PYTHON2}/bin/python.exe";  die "no python2" unless -f $python2;
my $nix_prefetch_url = File::Spec->rel2abs("$0/../../../../../build-support/fetchgit/nix-prefetch-git.pl"); die "no nix-prefetch-git.pl at $nix_prefetch_url" unless -f $nix_prefetch_url;

my $version = $ARGV[0];                        die "bad version `$version'" unless defined($version) && $version =~ /^\d+(\.\d+)+$/;
my $basedir = "c:/tmp"; # short dir to avoid "filename too long" error

# gclient.py and nix-prefetch-git.pl expect git on patch
$ENV{PATH} = dirname($git) . ';' . $ENV{PATH};

sub checkout {
  my ($url, $rev, $dir) = @_;
  $dir ||= "$basedir/$rev";

  die "already exist $dir" if -e $dir;

  system($perl, $nix_prefetch_url,
         '--builder',
         '--url', $url,
         '--out', $dir,
         '--rev', $rev,
         '--fetch-submodules') == 0 or die;

  my $hash = `$nix hash-path --base32 --type sha256 $dir` =~ s|\s+$||r;
  die "bad hash `$hash'" unless $hash =~ /^[0-9a-z]{52}$/;
  return $hash;
}

# first checkout depot_tools for gclient.py which will help to produce list of deps
unless (-d "$basedir/depot_tools") {
  checkout("https://chromium.googlesource.com/chromium/tools/depot_tools", "db0055dc786a71fe81e720bad2b1acb0e133a291", "$basedir/depot_tools") eq "0hsjq4lbylff194bz96dkyxahql7pq59bipbfv1fb32afwfr0vya" or die;
  # patch as there is no git.bat
  changeFile { s/git\.bat/git/gr } "$basedir/depot_tools/git_cache.py";
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
    if (readFile(".git/FETCH_HEAD") =~ /tag '\Q$version\E' of/) {
      print("already at $version\n");
    } else {
      print("$git fetch --progress --depth 1 origin \"+$version\"\n");
      system("$git fetch --progress --depth 1 origin \"+$version\""                         ) == 0 or die;
      system("$git checkout FETCH_HEAD"                                                     ) == 0 or die;
    }
  }
  chdir($top);
}


sub parsedeps {
  my $need_another_iteration;
  my %deps;
  do {
    $need_another_iteration = 0;
    my $top = getcwd();
    chdir($basedir);

    # flatten fail because of duplicate valiable names, so rename them
    if (-f 'src\third_party\angle\buildtools\DEPS') {
      changeFile {
        s/\blibcxx_revision\b/libcxx_revision2/g;
        s/\blibcxxabi_revision\b/libcxxabi_revision2/g;
        $_;
      } 'src\third_party\angle\buildtools\DEPS';
    }

    system("$python2 depot_tools/gclient.py config https://chromium.googlesource.com/chromium/src.git") == 0 or die;
    system("$python2 depot_tools/gclient.py flatten --pin-all-deps > flat"                            ) == 0 or die;

    my $content = readFile('flat');
    while ($content =~ /"([^"]+)":\s*\{\s*"url":\s*"(.+)@(.+)"/gm) {
      my $url = $2;
      my $rev = $3;
      my $path = $1 =~ s|\\|/|gr;
      next if $url =~ /chrome-internal\.googlesource\.com/; # access denied to this domain
      if (!exists($deps{$path})) {
        print("path=$path url=$url rev=$rev\n");
        my $hash;
        if (-e "$basedir/$rev" && -e "$basedir/$rev.sha256") { # memoize $hash in "$basedir/$rev.sha256"
          $hash = readFile("$basedir/$rev.sha256");
        } else {
          remove_treeL("$basedir/$rev", "$basedir/$rev.sha256");
          $hash = checkout($url, $rev, "$basedir/$rev");
          writeFile("$basedir/$rev.sha256", $hash);
        }
        if ($path ne 'src') {
          die "$basedir/$rev does not exist" unless -d "$basedir/$rev";
          if (-e "$basedir/$path") { # do not let `symtree_link` to do merge
            remove_treeL("$basedir/$path") or die $!;
          }
          symtree_link("$basedir/src", "$basedir/$rev" => "$basedir/$path") or die;
        }
        if (-f "$basedir/$rev/DEPS") {  # new DEPS file appeared after checkout
          print("need_another_iteration\n");
          $need_another_iteration = 1;
        }
        $deps{$path} = { rev => $rev, hash => $hash, path => $path, url => $url };
      }
    }
    chdir($top);
  } while ($need_another_iteration);

  open(my $sources_nix, ">sources-$version.nix") or die;
  binmode $sources_nix;
  print $sources_nix "# GENERATED FILE\n";
  print $sources_nix "{fetchgit}:\n";
  print $sources_nix "{\n";
  for my $k (sort (keys %deps)) {
    my $dep = $deps{$k};
    printf $sources_nix "  %-64s = fetchgit { url = %-128s; rev = \"$dep->{rev}\"; sha256 = \"$dep->{hash}\"; };\n", "\"$dep->{path}\"", "\"$dep->{url}\"";
  }
  print $sources_nix "}\n";
}

parsedeps();

__END__
:endofperl
