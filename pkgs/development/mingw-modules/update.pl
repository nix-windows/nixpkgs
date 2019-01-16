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
  my ($out, $subsystem, $arch, $repo) = @_;
  die unless $subsystem eq 'msys' || $subsystem eq 'mingw';
  die unless $arch eq 'i686' || $arch eq 'x86_64';
  my $baseUrl = "http://repo.msys2.org/$subsystem/$arch";

  #my $isMsys = exists($repo->{'msys2-runtime'}) ? 'true' : 'false';
print $out
qq[ # GENERATED FILE
{stdenvNoCC, fetchurl, mingwPackages, msysPackages}:

let
  fetch = { pname, version, srcs, buildInputs ? [], broken ? false }:
    if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
      stdenvNoCC.mkDerivation {
        inherit version buildInputs;
        name = "\${pname}-\${version}";
        srcs = map ({filename, sha256}:
                    fetchurl {
                      url = "$baseUrl/\${filename}";
                      inherit sha256;
                    }) srcs;
        PATH = stdenvNoCC.lib.concatMapStringsSep ";" (x: "\${x}\\\\bin") stdenvNoCC.initialPath; # it adds 7z.exe to PATH
        builder = stdenvNoCC.lib.concatStringsSep " & " ( assert (builtins.length srcs == 1);
                                                          [ ''echo PATH=%PATH%''
                                                            ''7z x %srcs% -so  |  7z x -aoa -si -ttar -o%out%''
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
      inherit version buildInputs;
      name = "\${pname}-\${version}";
      srcs = map ({filename, sha256}:
                  fetchurl {
                    url = "$baseUrl/\${filename}";
                    inherit sha256;
                  }) srcs;
      sourceRoot = ".";
      buildPhase = if stdenvNoCC.isShellPerl /* on native windows */ then
        ''
          dircopy('.', \$ENV{out}) or die "dircopy(., \$ENV{out}): \$!";
          \${ stdenvNoCC.lib.concatMapStringsSep "\\n" (dep:
                ''symtree_link(\$ENV{out}, '\${dep}', \$ENV{out});''
              ) buildInputs }
          chdir(\$ENV{out});
          \${ stdenvNoCC.lib.optionalString (!(].($subsystem eq 'msys' ? 'true' : 'false').qq[ && builtins.elem pname ["msys2-runtime" "bash" "coreutils" "gmp" "libiconv" "gcc-libs" "libintl"])) ''
                if (-f ".INSTALL") {
                  \$ENV{PATH} = '\${msysPackages.bash}/usr/bin;\${msysPackages.coreutils}/usr/bin';
                  system("bash -c \\"ls -la ; . .INSTALL ; if command -v post_install; then post_install; else true; fi\\"") == 0 or die;
                }
              '' }
          unlinkL ".BUILDINFO";
          unlinkL ".INSTALL";
          unlinkL ".MTREE";
          unlinkL ".PKGINFO";

          # make symlinks in /bin, mingw does not need it, it is only for nixpkgs convenience, to have the executables in \$derivation/bin
          symtree_reify(\$ENV{out}, "bin/_");
          for my \$file (glob("\$ENV{out}/mingw].($arch eq 'x86_64' ? 64 : 32).qq[/bin/*.exe"),
                         glob("\$ENV{out}/mingw].($arch eq 'x86_64' ? 64 : 32).qq[/bin/*.dll"),
                         glob("\$ENV{out}/usr/bin/*.exe"),
                         glob("\$ENV{out}/usr/bin/*.dll")) {
            if (!testL('l', \$file)) { # symlinks are likely already in bin/ after symtree_link()
              symlinkL(\$file => "\$ENV{out}/bin/".basename(\$file)) or die \$!;
            }
          }
        ''
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

  my $one = sub {
    my ($pname, $version, $filenames, $sha256s, $depends) = @_;
    print $out
qq<
  "$pname" = fetch {
    pname       = "$pname";
    version     = "$version";
    srcs        = [> . join("", map { "{ filename = \"@{$filenames}[$_]\"; sha256 = \"@{$sha256s}[$_]\"; }" } (0 .. scalar(@{$filenames})-1)) . qq<];
>;
    if ($depends) {
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
#                                   print STDERR "broken dependency $name -> $dep\n";
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
                               } @{$depends}).
                 " ];\n";
    }
    my $reason = isBroken($repo, $pname);
    print $out "    broken      = true; # $reason\n" if $reason;
    print $out "  };\n";
  };

for my $pname (sort (keys %$repo)) {
# next unless $name =~ /^perl-HTTP-M/;
  my %desc = %{$repo->{$pname}};
  my $version = $desc{VERSION} =~ s/-\d+$//r;

  # freetype and harfbuzz are mutable deps
  if ($pname eq 'freetype' || $pname eq 'harfbuzz') {
    print $out  "  $pname = freetype-and-harfbuzz;\n";
#   print $out  "  $pname = freetype-and-harfbuzz // { name = \"$pname-$version\"; version = \"$version\"; };\n";
  } else {
    &$one($desc{NAME}, $version, [$desc{FILENAME}], [$desc{SHA256SUM}], $desc{DEPENDS});
  }
}

# freetype and harfbuzz are mutable deps
if (exists($repo->{freetype}) && exists($repo->{harfbuzz})) {
  &$one(  'freetype-and-harfbuzz'
       ,   $repo->{freetype}->{VERSION}."+".$repo->{harfbuzz}->{VERSION}
       , [ $repo->{freetype}->{FILENAME},   $repo->{harfbuzz}->{FILENAME}  ]
       , [ $repo->{freetype}->{SHA256SUM},  $repo->{harfbuzz}->{SHA256SUM} ]
       , [ grep { ! /^freetype|harfbuzz$/ } (@{$repo->{freetype}->{DEPENDS}}, @{$repo->{harfbuzz}->{DEPENDS}}) ]
       );
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
  emitNix($out, 'msys', $arch, \%msys_repo);
  close($out);


  my %mingw64db_repo = parseDB(File::Fetch->new(uri => "http://repo.msys2.org/mingw/$arch/mingw".($arch eq 'x86_64' ? 64 : 32).".db")->fetch(to => $ENV{TMP}));
  #my %mingw64db_repo = parseDB('mingw64.db');
  open(my $out, ">mingw-packages-$arch.nix") or die $!;
  binmode $out;
  emitNix($out, 'mingw', $arch, \%mingw64db_repo);
  close($out);
}