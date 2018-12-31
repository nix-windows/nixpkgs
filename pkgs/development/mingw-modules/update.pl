use warnings;
use strict;
use File::Fetch;
use Data::Dump;
use Archive::Tar;

sub parseDesc {
  my %chunks = shift =~ /%([A-Z0-9]+)%\n(.*?)\n\n/gs;
  $chunks{NAME}        =~ s/^mingw-w64-x86_64-//                                                if $chunks{NAME};
  $chunks{DEPENDS}     = [(map { s/^mingw-w64-x86_64-//r } (split /\n/, $chunks{DEPENDS}    ))] if $chunks{DEPENDS};
  $chunks{MAKEDEPENDS} = [(map { s/^mingw-w64-x86_64-//r } (split /\n/, $chunks{MAKEDEPENDS}))] if $chunks{MAKEDEPENDS};
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
    return 0;
  }
  my $seen2 = { %$seen }; # copy
  $seen2->{$name} = 1;

# my %desc = %{$repo{$name}};
  if ($repo->{$name}->{broken}) {
#   print("cached $name\n");
    return 1;
  }

  for (@{$repo->{$name}->{DEPENDS}}) {
    my $dep = /([^>]+)(>=|=)([^>]+)/ ? $1 : $_;
#   print("check $name->$dep\n");
    if ($dep eq 'sh' || $dep eq 'awk' || $dep eq 'libjpeg') {
    } elsif (exists($repo->{$dep})) {
      if (isBroken($repo, $dep, $seen2)) {
        $repo->{$name}->{broken} = 1;
        return 1;
      }
    } elsif (exists($repo->{"$dep-git"})) {
      $dep = "$dep-git";
      if (isBroken($repo, $dep, $seen2)) {
        $repo->{$name}->{broken} = 1;
        return 1;
      }
    } else {
      print STDERR "broken dependency $name -> $dep\n";
      $repo->{$name}->{broken} = 1;
      return 1;
    }
  }
  return 0;
}


sub emitNix {
  my ($out, $baseUrl, $repo) = @_;
print $out
qq[ # GENERATED FILE
{config, lib, stdenvNoCC, fetchurl}:

let
  fetch = { name, version, filename, sha256, buildInputs ? [], broken ? false }:
    stdenvNoCC.mkDerivation {
      inherit name version buildInputs;
      src = fetchurl {
        url = "$baseUrl/\${filename}";
        inherit sha256;
      };
      sourceRoot = ".";
      buildPhase = if stdenvNoCC.isShellPerl /* on native windows */ then
        ''
          dircopy '.',       "\$ENV{out}";
          unlink "\$ENV{out}/.BUILDINFO";
          unlink "\$ENV{out}/.INSTALL";
          unlink "\$ENV{out}/.MTREE";
          unlink "\$ENV{out}/.PKGINFO";
          use File::Find qw(find);
        '' + lib.concatMapStringsSep "\\n" (dep: ''
              sub process {
                my \$src = \$_;
                die "bad src: '\$src'" unless \$src =~ /\\/[0-9a-df-np-sv-z]{32}-[^\\/]+(.*)/;
                my \$rel = \$1;
                my \$tgt = "\$ENV{out}\$rel";
                print("\$src -> \$tgt\\n");
                if (-d \$src) {
                  make_path(\$tgt);
                } else {
                  system('mklink', \$tgt =~ s|/|\\\\|gr, \$src =~ s|/|\\\\|gr);
                }
              };
              find({ wanted => \\&process, no_chdir => 1}, '\${dep}');
            '') buildInputs
      else if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
        ''
          echo yay
          exit 1
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

  print $out  "  sh = bash;\n"                if !exists($repo->{sh})      && exists($repo->{bash});
  print $out  "  awk = gawk;\n"               if !exists($repo->{awk})     && exists($repo->{gawk});
  print $out  "  libjpeg = libjpeg-turbo;\n"  if !exists($repo->{libjpeg}) && exists($repo->{'libjpeg-turbo'});

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

                               if ($dep =~ /([^>]+)(>=|=)([^>]+)/) {
                                 $dep = $1;
                                 $op = $2;
                                 $ver = $3 =~ s/-\d+$//r;
                               }

                               if ($dep eq 'sh' || $dep eq 'awk' || $dep eq 'libjpeg') {
                               } elsif (exists($repo->{$dep})) {
                               } elsif (exists($repo->{"$dep-git"})) {
                                 $dep = "$dep-git";
                               } else {
#                                 print STDERR "broken dependency $name -> $dep\n";
                               }

                               my $refdep = okName($dep) ? $dep : "self.\"$dep\"";

                               if ($op eq '>=') { # todo: check version right here
                                 "(assert lib.versionAtLeast $refdep.version \"$version\"; $refdep)";
                               } elsif ($op eq '=') {
                                 "(assert $refdep.version==\"$version\"; $refdep)";
                               } elsif ($op eq '') {
                                 $refdep;
                               } else {
                                 die;
                               }
                             } @{$desc{DEPENDS}}).
               " ];\n";
  }
  print $out "    broken      = true;\n" if isBroken($repo, $name);
  print $out "  };\n";
}


print $out
qq<
}; in self
>;
}


my %msys_repo = parseDB(File::Fetch->new(uri => "http://repo.msys2.org/msys/x86_64/msys.db")->fetch(to => $ENV{TMP}));
#my %msys_repo = parseDB('msys.db');
open(my $out, ">msys-packages.nix") or die $!;
binmode $out;
emitNix($out, "http://repo.msys2.org/msys/x86_64", \%msys_repo);
close($out);


my %mingw64db_repo = parseDB(File::Fetch->new(uri => "http://repo.msys2.org/mingw/x86_64/mingw64.db")->fetch(to => $ENV{TMP}));
#my %mingw64db_repo = parseDB('mingw64.db');
open(my $out, ">mingw-packages.nix") or die $!;
binmode $out;
emitNix($out, "http://repo.msys2.org/mingw/x86_64", \%mingw64db_repo);
close($out);
