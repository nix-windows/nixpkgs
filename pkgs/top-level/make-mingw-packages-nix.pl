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

#my $path = File::Fetch->new(uri => "http://repo.msys2.org/mingw/x86_64/mingw64.db")->fetch(to => $ENV{TMP});
#print("$path\n");
my %repo = parseDB('mingw64.db');


sub isBroken {
  my $name = shift;
  my $seen = shift;

  if ($seen->{$name}) {
    print("seen $name\n");
    return 0;
  }
  my $seen2 = { %$seen }; # copy
  $seen2->{$name} = 1;

# my %desc = %{$repo{$name}};
  if ($repo{$name}->{broken}) {
    print("cached $name\n");
    return 1;
  }

  for my $dep (@{$repo{$name}->{DEPENDS}}) {
    $dep = $1 if $dep =~ /([^>]+)(>=|=)([^>]+)/;
#   print("check $name->$dep\n");
    if (exists($repo{$dep})) {
      if (isBroken($dep, $seen2)) {
        $repo{$name}->{broken} = 1;
        return 1;
      }
    } elsif (exists($repo{"$dep-git"})) {
      $dep = "$dep-git";
      if (isBroken($dep, $seen2)) {
        $repo{$name}->{broken} = 1;
        return 1;
      }
    } else {
      print STDERR "broken dependency $name -> $dep\n";
      $repo{$name}->{broken} = 1;
      return 1;
    }
  }
  return 0;
}


open(my $out, ">mingw-packages.nix") or die $!;
binmode $out;
print $out
qq< # GENERATED FILE
{config, lib, stdenvNoCC, fetchurl}:

let
  fetch = { name, version, filename, sha256, buildInputs ? [], broken ? false }:
    stdenvNoCC.mkDerivation {
      inherit name version buildInputs;
      src = fetchurl {
        url = "http://repo.msys2.org/mingw/x86_64/\${filename}";
        inherit sha256;
      };
      sourceRoot = ".";
      buildPhase = ''
        move    'mingw64', "\$ENV{out}";
        dircopy '.',       "\$ENV{out}/";
      '' +
      lib.concatMapStringsSep "\\n" (dep: ''
        for my \$dll (glob('\${dep}/bin/*.dll')) {
          #copy \$dll, "\$ENV{out}/bin/";
          system('mklink', ("\$ENV{out}/bin/".basename(\$dll)) =~ s|/|\\\\|gr, \$dll =~ s|/|\\\\|gr);
        }
      '') buildInputs;
      meta.broken = broken;
    };
  self = _self;
  _self = with self;
{
  callPackage = pkgs.newScope self;
>;

for my $name (sort (keys %repo)) {
# next unless $name =~ /^curl/;
  my %desc = %{$repo{$name}};
  my $version = $desc{VERSION} =~ s/-\d+$//r;
#  $name = "\"$name\"" unless okName($name);
# dd \%desc;

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

                               if (/([^>]+)(>=|=)([^>]+)/) {
                                 $dep = $1;
                                 $op = $2;
                                 $ver = $3 =~ s/-\d+$//r;
                               }

                               unless (exists($repo{$dep})) {
                                 if (exists($repo{"$dep-git"})) {
                                   $dep = "$dep-git";
#                                } elsif ($dep eq 'libjpeg' && exists($repo{"$name-turbo"})) {
#                                  $dep = "$dep-turbo";
                                 } else {
                                   print STDERR "broken dependency $name -> $dep\n";
                                 }
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
  print $out "    broken      = true;\n" if isBroken($name);
  print $out "  };\n";
}


print $out
qq<
}; in self
>;
close($out);
