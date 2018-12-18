{ lib, stdenv
#, fetchurl, fetchFromGitHub, fetchpatch
, perl, curl, bzip2, sqlite
, openssl, xz
, writeTextFile
, boehmgc
#, perlPackages, libsodium, brotli
, boost
#, bison, flex
, storeDir ? (if stdenv.hostPlatform.isMicrosoft then "C:/nix/store" else "/nix/store")
, stateDir ? (if stdenv.hostPlatform.isMicrosoft then "C:/nix/var"   else "/nix/var"  )
#, confDir ? "/etc"
}:

let
  version = "2.1.2";
  config-h = writeTextFile {
    name = "config.h";
    text = ''
      #define HAVE_BZLIB_H 1
      #define HAVE_MEMORY_H 1
      //#define HAVE_SODIUM 1
      #define HAVE_STDINT_H 1
      #define HAVE_STDLIB_H 1
      #define HAVE_STRING_H 1
      #define PACKAGE_NAME "nix"
      #define PACKAGE_STRING "nix ${version}"
      #define PACKAGE_TARNAME "nix"
      #define PACKAGE_VERSION "${version}"
      #define SYSTEM "x86_64-windows"
      #define YY_NO_UNISTD_H 1

      #define NIX_STORE_DIR    "${storeDir}"
      #define NIX_LOG_DIR      "${stateDir}/log/nix"
      #define NIX_STATE_DIR    "${stateDir}/nix"
    '';
  };
  config-nix = writeTextFile {
    name = "config.nix";
    text = ''
      let
        fromEnv = var: def:
          let val = builtins.getEnv var; in
          if val != "" then val else def;
      in rec {
        #shell = "${perl}/bin/perl.exe";
        #coreutils = throw "config.coreutils?";
        #bzip2 = "${bzip2}/bin/bzip2.exe";
        #gzip = throw "config.gzip?";
        #xz = throw "config.xz?";
        #tar = throw "config.tar?";
        #tarFlags = throw "config.tarFlags?";
        #tr = throw "config.tr?";
        ##nixBinDir = fromEnv "NIX_BIN_DIR" "/usr/bin";
        ##nixPrefix = fromEnv "NIX_PREFIX" "/usr";
        ##nixLibexecDir = fromEnv "NIX_LIBEXEC_DIR" "/usr/libexec";
        ##nixLocalstateDir = "/nix/var";
        ##nixSysconfDir = "/usr/etc";
        ##nixStoreDir = fromEnv "NIX_STORE_DIR" "${storeDir}";

        # If Nix is installed in the Nix store, then automatically add it as
        # a dependency to the core packages. This ensures that they work
        # properly in a chroot.
        #chrootDeps =
        #  if dirOf nixPrefix == builtins.storeDir then
        #    [ (builtins.storePath nixPrefix) ]
        #  else
        #    [ ];
      }
    '';
  };
in rec {
  nixStable = nix;

  nix = stdenv.mkDerivation /*rec*/ {
    inherit version;
    name = "nix-${version}";
    src = "C:/msys64/home/User/nix";

    buildInputs = [ curl openssl sqlite xz bzip2 boost ]; # libsodium, brotli

#   propagatedBuildInputs = [ boehmgc ];

    # TODO: '${boost}/include' '${openssl}/include'  are to be handled by a hook
    buildPhase = ''
      use Digest::MD5 qw(md5_hex);
      sub readFile {
        my ($filename) = @_;
        local $/ = undef;
        open my $fh, $filename or die "readFile($filename) failed: $!";
        binmode $fh;
        my $data = <$fh>;
        close $fh;
        return $data;
      }
      sub mkexe {
        my ($exename, $srcwildcards) = @_;
        my @cfiles = map {glob $_} (split ' ', $srcwildcards);
        my %hashfiles = ();
        #print("exename=$exename srcwildcards=$srcwildcards cfiles=@cfiles\n");
        for my $cfile (@cfiles) {
          my @cmd = ('-nologo', '-c', '-std:c++latest', '-EHsc', '-MD',
                     '-Zi', '-Fdc:/varcache/vc141.pdb',
                     '-I${boost}/include', '-I${openssl}/include', '-I${xz}/include', '-I${bzip2}/include', '-I${curl}/include', '-I${sqlite}/include',
                     '-DNIX_PREFIX="""'      . 'c:/dummy"""',             # '-DNIX_PREFIX="""'      . ($ENV{out} =~ s,\\,/,gr) . '"""',
                     '-DNIX_BIN_DIR="""'     . 'c:/dummy/bin"""',         # '-DNIX_BIN_DIR="""'     . ($ENV{out} =~ s,\\,/,gr) . '/bin"""',
                     '-DNIX_CONF_DIR="""'    . 'c:/dummy/etc"""',         # '-DNIX_CONF_DIR="""'    . ($ENV{out} =~ s,\\,/,gr) . '/etc"""',
                     '-DNIX_LIBEXEC_DIR="""' . 'c:/dummy/libexec"""',     # '-DNIX_LIBEXEC_DIR="""' . ($ENV{out} =~ s,\\,/,gr) . '/libexec"""',
                     '-DNIX_MAN_DIR="""'     . 'c:/dummy/share/man"""',   # '-DNIX_MAN_DIR="""'     . ($ENV{out} =~ s,\\,/,gr) . '/share/man"""',
                     '-DNIX_DATA_DIR="""'    . 'c:/dummy/share"""',       # '-DNIX_DATA_DIR="""'    . ($ENV{out} =~ s,\\,/,gr) . '/share"""',
                     '-FI${config-h}',
                     '-I.', '-Isrc', '-Isrc/libstore', '-Isrc/libutil', '-Isrc/libmain', '-Isrc/libexpr');
          my $content = readFile($cfile);
          my $hashfile = "c:/varcache/". md5_hex(join(' ', $content, @cmd)) . ".obj";
          $hashfiles{$hashfile} = 1;
          print ('cl', "-Fo$hashfile", @cmd, $cfile, "\n");
          system('cl', "-Fo$hashfile", @cmd, $cfile) unless -e $hashfile;
          die "$hashfile not built"                  unless -e $hashfile;
        }
        print ('link', '/NOLOGO', "/OUT:$exename.exe", '/LIBPATH:'.('${boost}/lib' =~ s|/|\\|rg), keys %hashfiles, "\n");
        system('link', '/NOLOGO', "/OUT:$exename.exe", '/DEBUG',
               '/LIBPATH:${boost}/lib',
               '${openssl}/lib/libeay32.lib', '${openssl}/lib/ssleay32.lib',
               '${xz}/lib/liblzma.lib',
               '${bzip2}/lib/libbz2.lib',
               '${curl}/lib/libcurl.lib',
               '${sqlite}/lib/winsqlite3.lib',
               keys %hashfiles) == 0 or die "link";
      }
      for my $name ('nix', 'nix-build', 'nix-instantiate', 'nix-store', 'nix-prefetch-url', 'nix-collect-garbage') {
        mkexe($name, "src/libexpr/*.cc src/libexpr/primops/*.cc src/libmain/*.cc src/libutil/*.cc src/libstore/*.cc src/libstore/builtins/*.cc src/linenoise/*.cpp src/$name/*.cc");
      }


    '';

    # wrappers are not really needed, only for .obj cache to work, for the hashes not be depended on $ENV{out}
    installPhase = ''
      mkdir("$ENV{out}");
      mkdir("$ENV{out}/libexec");
      mkdir("$ENV{out}/bin");
      mkdir("$ENV{out}/etc");
      mkdir("$ENV{out}/share");
      mkdir("$ENV{out}/share/man");
      mkdir("$ENV{out}/share/bin");
      mkdir("$ENV{out}/share/nix");
      mkdir("$ENV{out}/share/nix/corepkgs");

      open(my $nixconf, ">$ENV{out}/etc/nix.conf");
      print $nixconf "\n";
      close($nixconf);

      #copy("${config-h}",                   "$ENV{out}/config.h"  ) or die $!;

      copy("${openssl}/bin/libeay32.dll",   "$ENV{out}/share/bin/LIBEAY32.dll"  ) or die $!;
      copy("${openssl}/bin/ssleay32.dll",   "$ENV{out}/share/bin/SSLEAY32.dll"  ) or die $!;
      copy("${xz}/bin/liblzma.dll",         "$ENV{out}/share/bin/liblzma.dll"   ) or die $!;
      copy("${curl}/bin/libcurl.dll",       "$ENV{out}/share/bin/libcurl.dll"   ) or die $!;
      copy("${sqlite}/bin/winsqlite3.dll",  "$ENV{out}/share/bin/winsqlite3.dll") or die $!;

      for my $name ('nix', 'nix-build', 'nix-instantiate', 'nix-store', 'nix-prefetch-url', 'nix-collect-garbage') {
        copy("$name.exe", "$ENV{out}/share/bin/$name.exe") or die $!;
        copy("$name.pdb", "$ENV{out}/share/bin/$name.pdb") or die $!;
        system("makeWrapper", "$ENV{out}/share/bin/$name.exe", "$ENV{out}/bin/$name.exe",
               '--set',    'NIX_PREFIX',      "$ENV{out}",
               '--set',    'NIX_BIN_DIR',     "$ENV{out}/bin",
               '--set',    'NIX_CONF_DIR',    "$ENV{out}/etc",
               '--set',    'NIX_LIBEXEC_DIR', "$ENV{out}/libexec",
               '--set',    'NIX_MAN_DIR',     "$ENV{out}/share/man",
               '--set',    'NIX_DATA_DIR',    "$ENV{out}/share",
              ) == 0 or die "makeWrapper failed: $!";
      }

       copy("${config-nix}",                            "$ENV{out}/share/nix/corepkgs/") or die $!;
      #copy("corepkgs/config.nix",                      "$ENV{out}/share/nix/corepkgs/") or die $!;
       copy("corepkgs/imported-drv-to-derivation.nix",  "$ENV{out}/share/nix/corepkgs/") or die $!;
       copy("corepkgs/fetchurl.nix",                    "$ENV{out}/share/nix/corepkgs/") or die $!;
       copy("corepkgs/derivation.nix",                  "$ENV{out}/share/nix/corepkgs/") or die $!;
      #copy("corepkgs/unpack-channel.nix",              "$ENV{out}/share/nix/corepkgs/") or die $!;
       copy("corepkgs/buildenv.nix",                    "$ENV{out}/share/nix/corepkgs/") or die $!;
    '';
    passthru = {
    # fromGit = false;
      inherit config-h;
    };
  };

# perl-bindings = { nix, needsBoost ? false }: stdenv.mkDerivation {
#   name = "nix-perl-" + nix.version;
#
#   inherit (nix) src;
#
#   postUnpack = "sourceRoot=$sourceRoot/perl";
#
#   # This is not cross-compile safe, don't have time to fix right now
#   # but noting for future travellers.
#   nativeBuildInputs =
#     [ perl pkgconfig curl nix libsodium ]
#     ++ lib.optionals nix.fromGit [ autoreconfHook autoconf-archive ]
#     ++ lib.optional needsBoost boost;
#
#   configureFlags =
#     [ "--with-dbi=${perlPackages.DBI}/${perl.libPrefix}"
#       "--with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}"
#     ];
#
#   preConfigure = "export NIX_STATE_DIR=$TMPDIR";
#
#   preBuild = "unset NIX_INDENT_MAKE";
# };
}
