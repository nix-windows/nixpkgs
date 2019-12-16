{ lib, fetchurl, fetchFromGitHub, callPackage
, perl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
, boehmgc
, stdenv, llvmPackages_6
}:

let

common =
  { lib, stdenv, fetchurl, fetchpatch, perl, curl_7_67, bzip2, sqlite, openssl ? null, xz
  , pkgconfig, boehmgc, libsodium, brotli, boost, editline
  , autoreconfHook, autoconf-archive, bison, flex, libxml2, libxslt, docbook5, docbook_xsl_ns, jq
  , busybox-sandbox-shell
  , storeDir
  , stateDir
  , confDir
  , withLibseccomp ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) libseccomp.meta.platforms, libseccomp
  , withAWS ? false, aws-sdk-cpp

  , name, suffix ? "", src, fromGit ? false

  }:
  let
     sh = busybox-sandbox-shell;
     nix = stdenv.mkDerivation rec {
      inherit name src;
      version = lib.getVersion name;

      is20 = lib.versionAtLeast version "2.0pre";

      patches = [
  # canBuildLocally: check for features
  (fetchurl {
    url    = "https://github.com/NixOS/nix/pull/2710.patch";  # merged
    sha256 = "0zrlrl38fybn9mk1rbcwgw7wcb98p2fjkj4nsjpm1x52nlsn5xgi";
  })
  # https://github.com/NixOS/nix/pull/3036
  # https://github.com/NixOS/nix/pull/3038
  /nix/store/9hqiik14d7lr23iqz078fqhwnmia76av-nix-shell.patch
  (fetchurl {
    url    = "https://github.com/NixOS/nix/commit/e07ec8d27e08bf23eccab079b044a6f1b37f3ac9.patch";  # merged, fix allowSubstitutes
    sha256 = "07an1lyz3g55vgdyz4dshrf9j178wyifmzhz4h6hkyxgxawvvk0p";
  })

  (fetchurl {
    url    = "https://github.com/NixOS/nix/pull/3092.patch";  # lexer: fix \r
    sha256 = "0qa6wi4z5svwbjn3hqvz3v3f3hgmfhmayncgp7ipf6vkpwb9qxap";
  })

  
# (fetchurl {
#   name   = "restrict-escapes.patch";
#   url    = "https://github.com/NixOS/nix/compare/e8f4b06c7135da819cb7d10232439a6526e3697d~2..e8f4b06c7135da819cb7d10232439a6526e3697d.patch";  # lexer: restrict escapes (hard error)
#   sha256 = "1xilbsp15w5rr9d140mnv5jlggd64wd1gsslaapkdm9qypw62m9i";
# })
];

postPatch = ''
  # do not emit ANSI-code https://github.com/NixOS/nix/issues/2648
  find . -type f -name '*.cc' -exec sed -r -i 's,isatty\([A-Z_]+\),0,g' {} +

  # allow self-signed https certificates on substituers
  substituteInPlace src/libstore/download.cc \
    --replace 'if (request.verifyTLS) {' \
              'if (false) {'

  substituteInPlace src/libexpr/primops.cc \
    --replace 'if (drvs.empty()) return;' \
              'if (drvs.empty()) return;

               for (auto & drv : drvs)
                  printError(format("realize IFD: %1%") % drv);
              '

  # force alloc remote terminal to kill remote processes on connection abort
  substituteInPlace src/libstore/ssh.cc \
    --replace '"-M",' '"-M", "-t", "-t",'

  # suppress too talkalive message
  substituteInPlace src/libstore/optimise-store.cc \
    --replace "printMsg(lvlTalkative, format(\"linking '%1%' to '%2%'\") % path % linkPath);" ""
'';

VERSION_SUFFIX =
 lib.optionalString fromGit suffix;

      outputs = [ "out" "dev" "man" "doc" ];

      nativeBuildInputs =
        [ bison flex pkgconfig ]
        ++ lib.optionals (!is20) [ curl_7_67 perl ]
        ++ lib.optionals fromGit [ autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook_xsl_ns jq ];

      buildInputs = [ curl_7_67 openssl sqlite xz bzip2 ]
        ++ lib.optional (stdenv.isLinux || stdenv.isDarwin) libsodium
        ++ lib.optionals is20 [ brotli boost editline ]
        ++ lib.optional withLibseccomp libseccomp
        ++ lib.optional (withAWS && is20)
            ((aws-sdk-cpp.override {
              apis = ["s3" "transfer"];
              customMemoryManagement = false;
            }).overrideDerivation (args: {
              patches = args.patches or [] ++ [(fetchpatch {
                url = https://github.com/edolstra/aws-sdk-cpp/commit/7d58e303159b2fb343af9a1ec4512238efa147c7.patch;
                sha256 = "103phn6kyvs1yc7fibyin3lgxz699qakhw671kl207484im55id1";
              })];
            }));

      propagatedBuildInputs = [ boehmgc ];

      # Seems to be required when using std::atomic with 64-bit types
      NIX_LDFLAGS = lib.optionalString (stdenv.hostPlatform.system == "armv6l-linux") "-latomic";

      preConfigure =
        # Copy libboost_context so we don't get all of Boost in our closure.
        # https://github.com/NixOS/nixpkgs/issues/45462
        if is20 then ''
          mkdir -p $out/lib
          cp ${boost}/lib/libboost_context* $out/lib
        '' else ''
          configureFlagsArray+=(BDW_GC_LIBS="-lgc -lgccpp")
        '';

      configureFlags =
        [ "--with-store-dir=${storeDir}"
          "--localstatedir=${stateDir}"
          "--sysconfdir=${confDir}"
          "--disable-init-state"
          "--enable-gc"
        ]
        ++ lib.optionals (!is20) [
          "--with-dbi=${perl.pkgs.DBI}/${perl.libPrefix}"
          "--with-dbd-sqlite=${perl.pkgs.DBDSQLite}/${perl.libPrefix}"
          "--with-www-curl=${perl.pkgs.WWWCurl}/${perl.libPrefix}"
        ] ++ lib.optionals (is20 && stdenv.isLinux) [
          "--with-sandbox-shell=${sh}/bin/busybox"
        ]
        ++ lib.optional (
            stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform ? nix && stdenv.hostPlatform.nix ? system
        ) ''--with-system=${stdenv.hostPlatform.nix.system}''
           # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
        ++ lib.optional (!withLibseccomp) "--disable-seccomp-sandboxing";

      makeFlags = "profiledir=$(out)/etc/profile.d";

      installFlags = "sysconfdir=$(out)/etc";

      doInstallCheck = true; # not cross

      # socket path becomes too long otherwise
      preInstallCheck = lib.optional stdenv.isDarwin ''
        export TMPDIR=$NIX_BUILD_TOP
      '';

      separateDebugInfo = stdenv.isLinux;

      enableParallelBuilding = true;

      meta = {
        description = "Powerful package manager that makes package management reliable and reproducible";
        longDescription = ''
          Nix is a powerful package manager for Linux and other Unix systems that
          makes package management reliable and reproducible. It provides atomic
          upgrades and rollbacks, side-by-side installation of multiple versions of
          a package, multi-user package management and easy setup of build
          environments.
        '';
        homepage = https://nixos.org/;
        license = stdenv.lib.licenses.lgpl2Plus;
        maintainers = [ stdenv.lib.maintainers.eelco ];
        platforms = stdenv.lib.platforms.all;
        outputsToInstall = [ "out" "man" ];
      };

      passthru = {
        inherit fromGit;

        perl-bindings = if perl.pkgs.hasPerlModule nix then
                          nix    # Nix1 has the perl bindings by default, so no need to build the manually.
                        else
                          perl.pkgs.toPerlModule(stdenv.mkDerivation {
          name = "nix-perl-${version}";

          inherit src;

          postUnpack = "sourceRoot=$sourceRoot/perl";

          # This is not cross-compile safe, don't have time to fix right now
          # but noting for future travellers.
          nativeBuildInputs =
            [ perl pkgconfig curl_7_67 nix libsodium ]
            ++ lib.optionals fromGit [ autoreconfHook autoconf-archive ]
            ++ lib.optional is20 boost;

          configureFlags =
            [ "--with-dbi=${perl.pkgs.DBI}/${perl.libPrefix}"
              "--with-dbd-sqlite=${perl.pkgs.DBDSQLite}/${perl.libPrefix}"
            ];

          preConfigure = "export NIX_STATE_DIR=$TMPDIR";

          preBuild = "unset NIX_INDENT_MAKE";
        });
      };
    };
  in nix;

in rec {

  nix = nixStable;

  nix1 = perl.pkgs.toPerlModule(callPackage common rec {
    name = "nix-1.11.16";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "0ca5782fc37d62238d13a620a7b4bff6a200bab1bd63003709249a776162357c";
    };

    inherit storeDir stateDir confDir boehmgc;
  });

  nixStable = callPackage common (rec {
    name = "nix-2.2.2";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "f80a1b4f9837a8d33209f0b7769d5038335459ff4303eccf3e9217a9eca8594c";
    };

    inherit storeDir stateDir confDir boehmgc;
  } // stdenv.lib.optionalAttrs stdenv.cc.isClang {
    stdenv = llvmPackages_6.stdenv;
  });

  nixUnstable = lib.lowPrio (callPackage common rec {
    name = "nix-2.3${suffix}";
    suffix = "pre6779_324a5dc9";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "324a5dc92f8e50e6b637c5e67dea48c80be10837";
      sha256 = "1g8gbam585q4kx8ilbx23ip64jw0r829i374qy0l8kvr8mhvj55r";
    };
    fromGit = true;

    inherit storeDir stateDir confDir boehmgc;
  });

  nixFlakes = lib.lowPrio (callPackage common rec {
    name = "nix-2.3${suffix}";
    suffix = "pre20190712_aa82f8b";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "aa82f8b2d2a2c42f0d713e8404b668cef1a4b108";
      hash = "sha256-MRY2CCjnTPSWIv0/aguZcg5U+DA+ODLKl9vjB/qXFpU=";
    };
    fromGit = true;

    inherit storeDir stateDir confDir boehmgc;
  });

}
