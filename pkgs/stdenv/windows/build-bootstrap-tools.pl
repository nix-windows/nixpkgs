#!perl

# This is to be run on Windows where Visual Studio, ActivePerl and 7zip are installed; Nix is not needed

use strict;
use warnings;
use Cwd;
use Math::BigInt;
use Digest::SHA             qw(sha256_hex);
use Digest::file            qw(digest_file_hex);
use File::Copy              qw(copy move);
use File::Path              qw(make_path remove_tree);
use File::Fetch;

sub dircopy {
  my ($from, $to) = @_;
  return system('robocopy', $from =~ s|/|\\|gr, $to =~ s|/|\\|gr, '/E', '/SL', '/LOG:nul') == 0;
}

unless (-f '7z.exe' && digest_file_hex('7z.exe', "SHA-256") eq '47462483fe54776e01d8ceb8ff9fd5bf2c3f1f01d852a54d878914f62f98f2d3') {
  File::Fetch->new(uri => "https://github.com/volth/nixpkgs/releases/download/windows-0.3/7z.exe")->fetch(to=>"./");
}
die unless -f '7z.exe' && digest_file_hex('7z.exe', "SHA-256") eq '47462483fe54776e01d8ceb8ff9fd5bf2c3f1f01d852a54d878914f62f98f2d3';

my $msvc_version = "14.16.27023";
my $redist_version = "14.16.27012";
my $sdk_8_1_version = "8.1";
my $sdk_10_version = "10.0.17763.0";
my $msbuild_version = "15.0";

# there seems to be no simple way to compress a directory to a nar file
# copy-pasted from Absalon's unnar.pl;
sub writeNar {
  my ($output, $storePath, $algo) = @_;
  my $narSize = 0;
  my $sha = Digest::SHA->new($algo);

  open my $nar, $output or die $!;
  binmode $nar;

  my $writeInt64 = sub {
    my $x = Math::BigInt->new(shift);
    my $data = pack("LL", $x&0xFFFFFFFF, ($x>>32)&0xFFFFFFFF);
    $narSize += length($data);
    $sha->add($data);
    print $nar $data;
  };

  my $writeString = sub {
    my ($data) = @_;
    &$writeInt64(length($data));
    $data .= "\0" x (-length($data) & 7);
    $narSize += length($data);
    $sha->add($data);
    print $nar $data;
  };

  my $packFile = sub {
    my ($path) = @_;
    my $len = -s $path;
    &$writeInt64($len);
    open my $fh, "<$path" or die $!;
    binmode $fh;
    my $chunkSize = 0x100000;
    for (my $i=0; $i<$len; $i+=$chunkSize) {
      $chunkSize = $len-$i if $chunkSize > $len-$i;
      read($fh, my $data, $chunkSize);
      length($data) == $chunkSize or die;
      $data .= "\0" x (-length($data) & 7);
      $sha->add($data);
      print $nar $data;
      $narSize += length($data);
    }
    close $fh;
  };

  my $writeNode;
  $writeNode = sub {
    my ($path) = @_;
    &$writeString("(");
    &$writeString("type");
    if (-l $path) {
      &$writeString("symlink");
      &$writeString("target");
      my $target = readlink($path);
#     print STDERR "SYM  $path -> $target\n";
      &$writeString($target);
    } elsif (-d $path) {
#     print STDERR "DIR  $path\n";
      &$writeString("directory");
      opendir(my $dh, $path) or die $!;
      for my $p (sort readdir($dh)) {
        unless ($p eq "." || $p eq "..") {
          &$writeString("entry");
          &$writeString("(");
          &$writeString("name");
          &$writeString($p);
          &$writeString("node");
          &$writeNode("$path/$p");
          &$writeString(")");
        }
      }
      closedir $dh;
    } elsif (-f $path) {
#     print STDERR "FILE $path\n";
      &$writeString("regular");
      if ($^O ne 'MSWin32' && -x $path) {
        &$writeString("executable");
        &$writeString("");
      }
      &$writeString("contents");
      &$packFile($path);
    } else {
      die;
    }
    &$writeString(")");
  };

  &$writeString("nix-archive-1");
  &$writeNode($storePath);
  close $nar;
  return { NarHash => $sha->hexdigest, NarSize => $narSize };
}

my $wd = getcwd();
#my $compression = '-mx1'; # fast
my $compression = '';

unless (-d "msvc-$msvc_version.nar.xz") {
    remove_tree("msvc");
    make_path("msvc");
    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/VC/Tools/MSVC/${msvc_version}/atlmfc",  "msvc/atlmfc" ) or die "$!";
    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/VC/Tools/MSVC/${msvc_version}/bin",     "msvc/bin"    ) or die "$!";
    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/VC/Tools/MSVC/${msvc_version}/include", "msvc/include") or die "$!";
    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/VC/Tools/MSVC/${msvc_version}/lib",     "msvc/lib"    ) or die "$!";
    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/VC/Tools/MSVC/${msvc_version}/vcperf",  "msvc/vcperf" ) or die "$!";
    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/VC/Tools/MSVC/${msvc_version}/crt",     "msvc/crt"    ) or die "$!";

    my $msvc_nar    = writeNar("| 7z a $compression -si msvc-$msvc_version.nar.xz",       "msvc",    "sha256");
    print qq[
      msvc = (import <nix/fetchurl.nix> {
        name = "msvc-\${msvc-version}";
        url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/msvc-\${msvc-version}.nar.xz";
        #url = "file://$wd/msvc-\${msvc-version}.nar.xz";
        unpack = true;
        sha256 = "$msvc_nar->{NarHash}";
      }) // {
        version = "$msvc_version";
      };
    ];
}

unless (-d "redist-$redist_version.nar.xz") {
    remove_tree("redist");
    make_path("redist");
    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/VC/Redist/MSVC/${redist_version}/x86",  "redist/x86"  ) or die "$!";
    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/VC/Redist/MSVC/${redist_version}/x64",  "redist/x64"  ) or die "$!";

    my $redist_nar    = writeNar("| 7z a $compression -si redist-$redist_version.nar.xz",       "redist",    "sha256");
    print qq[
      redist = (import <nix/fetchurl.nix> {
        name = "redist-\${redist-version}";
        url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/redist-\${redist-version}.nar.xz";
        #url = "file://$wd/redist-\${redist-version}.nar.xz";
        unpack = true;
        sha256 = "$redist_nar->{NarHash}";
      }) // {
        version = "$redist_version";
      };
    ];
}

unless (-f "sdk-$sdk_8_1_version.nar.xz") {
    remove_tree("sdk_8_1");
    make_path("sdk_8_1");

    dircopy("C:/Program Files (x86)/Windows Kits/8.1",                                  "sdk_8_1") or die "$!";

    my $sdk_nar     = writeNar("| 7z a $compression -si sdk-$sdk_8_1_version.nar.xz",   "sdk_8_1",     "sha256");
    print qq[
      sdk_8_1 = (import <nix/fetchurl.nix> {
        name = "sdk-\${sdk_8_1.version}";
        url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/sdk-\${sdk_8_1.version}.nar.xz";
        #url = "file://$wd/sdk-\${sdk_8_1.version}.nar.xz";
        unpack = true;
        sha256 = "$sdk_nar->{NarHash}";
      }) // {
        version = "$sdk_8_1_version";
      };
    ];
}

unless (-f "sdk-$sdk_10_version.nar.xz") {
    remove_tree("sdk_10");
    make_path("sdk_10");

    dircopy("C:/Program Files (x86)/Windows Kits/10",                                   "sdk_10") or die "$!";
    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/DIA SDK", "sdk_10/DIA SDK") or die "$!"; # for chromium?

    # so far there is no `substituteInPlace`
    for my $filename (glob("sdk_10/DesignTime/CommonConfiguration/Neutral/*.props")) {
        open(my $in, $filename) or die $!;
        open(my $out, ">$filename.new") or die $!;
        for my $line (<$in>) {
            $line =~ s|\$\(Registry:HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows Kits\\Installed Roots\@KitsRoot10\)|\$([MSBUILD]::GetDirectoryNameOfFileAbove('\$(MSBUILDTHISFILEDIRECTORY)', 'sdkmanifest.xml'))\\|g;
            $line =~ s|(\$\(Registry:[^)]+\))|<!-- $1 -->|g;
            print $out $line;
        }
        close($in);
        close($out);
        move("$filename.new", $filename) or die $!;
    }

    my $sdk_nar     = writeNar("| 7z a $compression -si sdk-$sdk_10_version.nar.xz",    "sdk_10",     "sha256");
    print qq[
      sdk_10 = (import <nix/fetchurl.nix> {
        name = "sdk-\${sdk_10.version}";
        url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/sdk-\${sdk_10.version}.nar.xz";
        #url = "file://$wd/sdk-\${sdk_10.version}.nar.xz";
        unpack = true;
        sha256 = "$sdk_nar->{NarHash}";
      }) // {
        version = "$sdk_10_version";
      };
    ];
}

unless (-f "msbuild-$msbuild_version.nar.xz") {
    remove_tree("msbuild");
    make_path("msbuild");

    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/MSBuild", "msbuild") or die "$!";

    # other files refer to this one so msbuild might be unhappy if there is no file
    unless(-f 'msbuild/15.0/bin/Microsoft/WindowsXaml/v15.0/Microsoft.Windows.UI.Xaml.Cpp.targets') {
      make_path('msbuild/15.0/bin/Microsoft/WindowsXaml/v15.0');
      open(my $fh, '>msbuild/15.0/bin/Microsoft/WindowsXaml/v15.0/Microsoft.Windows.UI.Xaml.Cpp.targets') or die $!;
      print $fh "<Project xmlns=\"http://schemas.microsoft.com/developer/msbuild/2003\">\n";
      print $fh "</Project>\n";
      close($fh);
    }

    my $msbuild_nar = writeNar("| 7z a $compression -si msbuild-$msbuild_version.nar.xz", "msbuild", "sha256");
    print qq[
      msbuild = (import <nix/fetchurl.nix> {
        name = "msbuild-\${msbuild-version}";
        url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/msbuild-\${msbuild-version}.nar.xz";
        #url = "file://$wd/msbuild-\${msbuild-version}.nar.xz";
        unpack = true;
        sha256 = "$msbuild_nar->{NarHash}";
      }) // {
        version = "$msbuild_version";
      };
    ];
}

unless (-f "vc1-$msbuild_version.nar.xz") {
    remove_tree("vc1");
    make_path("vc1");

    dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/Common7/IDE/VC", "vc1") or die "$!";

    my $vc1_nar     = writeNar("| 7z a $compression -si vc1-$msbuild_version.nar.xz",     "vc1",     "sha256");
    print qq[
      vc1 = import <nix/fetchurl.nix> {
        name = "vc1-\${msbuild-version}";
        url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/vc1-\${msbuild-version}.nar.xz";
        #url = "file://$wd/vc1-\${msbuild-version}.nar.xz";
        unpack = true;
        sha256 = "$vc1_nar->{NarHash}";
      };
    ];
}
