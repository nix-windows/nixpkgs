# TODO: qt needs post-install patch. pacman does it. without the patch qt apps do not work (test case: kate)

use warnings;
use strict;
use File::Fetch;
use Archive::Tar;

sub parseDesc {
  my %chunks = shift =~ /%([A-Z0-9]+)%\n(.*?)\n\n/gs;
  $chunks{NAME}        =~ s/^mingw-w64-(x86_64|i686)-//                                                if $chunks{NAME};
  $chunks{DEPENDS}     = [(map { s/^mingw-w64-(x86_64|i686)-//r } (split /\n/, $chunks{DEPENDS}    ))] if $chunks{DEPENDS};
  $chunks{MAKEDEPENDS} = [(map { s/^mingw-w64-(x86_64|i686)-//r } (split /\n/, $chunks{MAKEDEPENDS}))] if $chunks{MAKEDEPENDS};
# dd \%chunks;
  return %chunks;
}

sub parseDB {
  my %repo;
  my $tar = Archive::Tar->new(shift);
  for my $file ($tar->get_files()) {
    next unless $file->is_file && $file->full_path =~ /\/desc$/;
    my $content = $file->get_content;
    my %desc = parseDesc($content);
    $repo{$desc{NAME}} = \%desc;
  }
  return %repo;
}

sub okName {
  return shift =~ /^[a-zA-Z_][a-zA-Z_0-9-]*$/;
}


sub isBroken {
  my $repo = shift;
  my $name = shift;
  my $seen = shift;

  if ($seen->{$name}) {
#   print("seen $name\n");
    return '';
  }
  my $seen2 = { %$seen }; # copy
  $seen2->{$name} = 1;

# my %desc = %{$repo{$name}};
  if ($repo->{$name}->{broken}) {
#   print("cached $name\n");
    return $repo->{$name}->{broken};
  }

  for (@{$repo->{$name}->{DEPENDS}}) {
    my $dep = /([^>]+)(>=|=)([^>]+)/ ? $1 : $_;
#   print("check $name->$dep\n");
    if ($dep eq 'sh' || $dep eq 'awk' || $dep eq 'libjpeg' || $dep eq 'bash' || $dep eq 'winpty' || $dep eq 'minizip' || $dep eq 'python3' || $dep eq 'vulkan') { # aliases

    } elsif (exists($repo->{$dep})) {
      my $reason = isBroken($repo, $dep, $seen2);
      if ($reason) {
        $repo->{$name}->{broken} = $reason;
        return $reason;
      }
    } elsif (exists($repo->{"$dep-git"})) {
      $dep = "$dep-git";
      my $reason = isBroken($repo, $dep, $seen2);
      if ($reason) {
        $repo->{$name}->{broken} = $reason;
        return $reason;
      }
    } else {
#     print STDERR "broken dependency $name -> $dep\n";
      my $reason = "broken dependency $name -> $dep";
      $repo->{$name}->{broken} = $reason;
      return $reason;
    }
  }
  return '';
}


sub emitNix {
  my ($out, $baseUrl, $repo) = @_;
print $out
qq[ # GENERATED FILE
{stdenvNoCC, fetchurl, mingwPackages, msysPackages}:

let
  fetch = { name, version, filename, sha256, buildInputs ? [], broken ? false }:
    if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
      stdenvNoCC.mkDerivation {
        inherit name version buildInputs;
        src = fetchurl {
          url = "$baseUrl/\${filename}";
          inherit sha256;
        };
        PATH = stdenvNoCC.lib.concatMapStringsSep ";" (x: "\${x}\\\\bin") stdenvNoCC.initialPath; # it adds 7z.exe to PATH
        builder = stdenvNoCC.lib.concatStringsSep " & " ( [ ''echo PATH=%PATH%''
                                                            ''7z x %src% -so  |  7z x -aoa -si -ttar -o%out%''
                                                            ''pushd %out%''
                                                            ''del .BUILDINFO .INSTALL .MTREE .PKGINFO''
                                                          ]
                                                       ++ stdenvNoCC.lib.concatMap (dep: let
                                                            tgt = stdenvNoCC.lib.replaceStrings ["/"] ["\\\\"] "\${dep}";
                                                          in [
#                                                           ''FOR /R \${tgt} %G in (*) DO (set localname=%G???? if not exist %localname% mklink %localname% \${tgt})''
                                                            ''xcopy /E/H/B/F/I/Y \${tgt} .''
                                                          ]) buildInputs
                                                       ++ [ ''popd'' ]
                                                        );
      }
    else
    stdenvNoCC.mkDerivation {
      inherit name version buildInputs;
      src = fetchurl {
        url = "$baseUrl/\${filename}";
        inherit sha256;
      };
      sourceRoot = ".";
      buildPhase = if stdenvNoCC.isShellPerl /* on native windows */ then
        ''
          dircopy('.', \$ENV{out}) or die "dircopy(., \$ENV{out}): \$!";
          unlinkL "\$ENV{out}/.BUILDINFO";
          unlinkL "\$ENV{out}/.INSTALL";
          unlinkL "\$ENV{out}/.MTREE";
          unlinkL "\$ENV{out}/.PKGINFO";
        '' + stdenvNoCC.lib.concatMapStringsSep "\\n" (dep:
               ''symtree_link(\$ENV{out}, '\${dep}', \$ENV{out});''
             ) buildInputs
      else /* on mingw or linux */
        throw "todo";
      meta.broken = broken;
    };
  self = _self;
  _self = with self;
{
  callPackage = pkgs.newScope self;
];

  # aliases
  print $out  "  sh = bash;\n"                       if !exists($repo->{sh})      && exists($repo->{bash});
  print $out  "  awk = gawk;\n"                      if !exists($repo->{awk})     && exists($repo->{gawk});
  print $out  "  libjpeg = libjpeg-turbo;\n"         if !exists($repo->{libjpeg}) && exists($repo->{'libjpeg-turbo'});
  print $out  "  minizip = minizip2;\n"              if !exists($repo->{minizip}) && exists($repo->{minizip2});
  print $out  "  vulkan = vulkan-loader;\n"          if !exists($repo->{vulkan})  && exists($repo->{'vulkan-loader'});
  print $out  "  bash = msysPackages.bash;\n"        if !exists($repo->{bash});
  print $out  "  winpty = msysPackages.winpty;\n"    if !exists($repo->{winpty});
  print $out  "  python3 = mingwPackages.python3;\n" if !exists($repo->{python3});

for my $name (sort (keys %$repo)) {
# next unless $name =~ /^perl-HTTP-M/;
  my %desc = %{$repo->{$name}};
  my $version = $desc{VERSION} =~ s/-\d+$//r;

# dd \%desc if $name =~ /^perl-HTTP-M/;

  print $out
qq<
  "$name" = fetch {
    name        = "$desc{NAME}";
    version     = "$version";
    filename    = "$desc{FILENAME}";
    sha256      = "$desc{SHA256SUM}";
>;
  if ($desc{DEPENDS}) {
    print $out qq<    buildInputs = [ >.
               join(' ', map { my $dep = $_;
                               my $op = '';
                               my $ver;

                               $dep =~ s/>$//; # python2-cssselect depends on "python2>". it must be a typo
                               if ($dep =~ /^([^>]+)(>=|=)([^>]+)$/) {
                                 $dep = $1;
                                 $op = $2;
                                 $ver = $3 =~ s/-\d+$//r;
                               }
                               die "bad dep='$dep'" if $dep =~ /[<>=]/;

                               if ($dep eq 'sh' || $dep eq 'awk' || $dep eq 'libjpeg') {
                               } elsif (exists($repo->{$dep})) {
                               } elsif (exists($repo->{"$dep-git"})) {
                                 $dep = "$dep-git";
                               } else {
#                                 print STDERR "broken dependency $name -> $dep\n";
                               }

                               my $refdep = okName($dep) ? $dep : "self.\"$dep\"";

                               if ($op eq '>=') { # todo: check version right here
                                 "(assert stdenvNoCC.lib.versionAtLeast $refdep.version \"$ver\"; $refdep)";
                               } elsif ($op eq '=') {
                                 "(assert $refdep.version==\"$ver\"; $refdep)";
                               } elsif ($op eq '') {
                                 $refdep;
                               } else {
                                 die;
                               }
                             } @{$desc{DEPENDS}}).
               " ];\n";
  }
  my $reason = isBroken($repo, $name);
  print $out "    broken      = true; # $reason\n" if $reason;
  print $out "  };\n";
}


print $out
qq<
}; in self
>;
}

for my $arch ('i686', 'x86_64') {
  my %msys_repo = parseDB(File::Fetch->new(uri => "http://repo.msys2.org/msys/$arch/msys.db")->fetch(to => $ENV{TMP}));
  #my %msys_repo = parseDB('msys.db');
  open(my $out, ">msys-packages-$arch.nix") or die $!;
  binmode $out;
  emitNix($out, "http://repo.msys2.org/msys/$arch", \%msys_repo);
  close($out);


  my %mingw64db_repo = parseDB(File::Fetch->new(uri => "http://repo.msys2.org/mingw/$arch/mingw".($arch eq 'x86_64' ? 64 : 32).".db")->fetch(to => $ENV{TMP}));
  #my %mingw64db_repo = parseDB('mingw64.db');
  open(my $out, ">mingw-packages-$arch.nix") or die $!;
  binmode $out;
  emitNix($out, "http://repo.msys2.org/mingw/$arch", \%mingw64db_repo);
  close($out);
}