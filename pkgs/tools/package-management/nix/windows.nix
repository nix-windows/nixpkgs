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
  nmakeFlags = lib.replaceStrings ["\\"] ["\\\\"] (lib.concatStringsSep " " [
    "-f" "Makefile.win"
    "VERSION=${version}"
    "STDENV_CC=${stdenv.cc}"
    "BOOST=${boost}"
    "OPENSSL=${openssl}"
    "XZ=${xz}"
    "BZIP2=${bzip2}"
    "CURL=${curl}"
    "SQLITE=${sqlite}"
    "NIX_BIN_DIR=$ENV{out}/bin"
    "NIX_CONF_DIR=$ENV{out}/etc"
    "NIX_DATA_DIR=$ENV{out}/share"
    "NIX_STORE_DIR=${storeDir}"
    "NIX_LOG_DIR=${stateDir}/log/nix"
    "NIX_STATE_DIR=${stateDir}/nix"
  ]);

in rec {
  nixStable = nix;

  nix = stdenv.mkDerivation /*rec*/ {
    inherit version;
    name = "nix-${version}";
#   src = "C:/msys64/home/User/nix";
    src = "C:/msys64/home/User/nix";

    buildInputs = [ curl openssl sqlite xz bzip2 boost ]; # libsodium brotli

#   propagatedBuildInputs = [ boehmgc ];

    buildPhase = ''
      system("nmake ${nmakeFlags}") == 0 or die;
    '';

    # wrappers are not really needed, only for .obj cache to work, for the hashes not be depended on $ENV{out}
    installPhase = ''
      system("nmake ${nmakeFlags} install") == 0 or die;
      copyL("${config-nix}", "$ENV{out}/share/nix/corepkgs/config.nix") or die "copyL(config.nix) $!";
    '';
    passthru = {
    # fromGit = false;
      inherit config-nix;
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
