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
  { lib, stdenv, fetchurl, fetchpatch, perl, curl, bzip2, sqlite, openssl ? null, xz
  , bash, coreutils, gzip, gnutar
  , pkgconfig, boehmgc, libsodium, brotli, boost, editline, nlohmann_json
  , autoreconfHook, autoconf-archive, bison, flex, libxml2, libxslt, docbook5, docbook_xsl_ns
  , jq, libarchive, rustc, cargo
  , busybox-sandbox-shell
  , storeDir
  , stateDir
  , confDir
  , withLibseccomp ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) libseccomp.meta.platforms, libseccomp
  , withAWS ? false, aws-sdk-cpp

  , name, suffix ? "", src, crates ? null, fromGit ? false

  }:
  let
     sh = busybox-sandbox-shell;
     nix = stdenv.mkDerivation rec {
      inherit name src;
      version = lib.getVersion name;

      is24 = lib.versionAtLeast version "2.4pre";
      isExactly23 = lib.versionAtLeast version "2.3" && lib.versionOlder version "2.4";

      patches = [
        # https://github.com/NixOS/nix/pull/3036
        ./nix-shell.patch

        (fetchurl {
          url    = "https://github.com/NixOS/nix/pull/3092.patch";  # lexer: fix \r
          sha256 = "0qa6wi4z5svwbjn3hqvz3v3f3hgmfhmayncgp7ipf6vkpwb9qxap";
        })
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

      VERSION_SUFFIX = suffix;

      outputs = [ "out" "dev" "man" "doc" ];

      nativeBuildInputs =
        [ bison flex pkgconfig ]
        ++ lib.optionals fromGit [ autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook_xsl_ns jq ]
        ++ lib.optionals is24 [ autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook_xsl_ns jq ];

      buildInputs =
        [ curl openssl sqlite xz bzip2 nlohmann_json
          brotli boost editline
        ]
        ++ lib.optional (stdenv.isLinux || stdenv.isDarwin) libsodium
        ++ lib.optionals is24 [ libarchive rustc cargo ]
        ++ lib.optional withLibseccomp libseccomp
        ++ lib.optional withAWS
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
      NIX_LDFLAGS = lib.optionalString (stdenv.hostPlatform.system == "armv5tel-linux" || stdenv.hostPlatform.system == "armv6l-linux") "-latomic";

      preConfigure =
        # Copy libboost_context so we don't get all of Boost in our closure.
        # https://github.com/NixOS/nixpkgs/issues/45462
        ''
          mkdir -p $out/lib
          cp -pd ${boost}/lib/{libboost_context*,libboost_thread*,libboost_system*} $out/lib
          rm -f $out/lib/*.a
          ${lib.optionalString stdenv.isLinux ''
            chmod u+w $out/lib/*.so.*
            patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib $out/lib/libboost_thread.so.*
          ''}
        '' +
        # Unpack the Rust crates.
        lib.optionalString is24 ''
          tar xvf ${crates} -C nix-rust/
          mv nix-rust/nix-vendored-crates* nix-rust/vendor
        '' +
        # For Nix-2.3, patch around an issue where the Nix configure step pulls in the
        # build system's bash and other utilities when cross-compiling
        lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform && isExactly23) ''
          mkdir tmp/
          substitute corepkgs/config.nix.in tmp/config.nix.in \
            --subst-var-by bash ${bash}/bin/bash \
            --subst-var-by coreutils ${coreutils}/bin \
            --subst-var-by bzip2 ${bzip2}/bin/bzip2 \
            --subst-var-by gzip ${gzip}/bin/gzip \
            --subst-var-by xz ${xz}/bin/xz \
            --subst-var-by tar ${gnutar}/bin/tar \
            --subst-var-by tr ${coreutils}/bin/tr
          mv tmp/config.nix.in corepkgs/config.nix.in
          '';

      configureFlags =
        [ "--with-store-dir=${storeDir}"
          "--localstatedir=${stateDir}"
          "--sysconfdir=${confDir}"
          "--disable-init-state"
          "--enable-gc"
        ]
        ++ lib.optionals stdenv.isLinux [
          "--with-sandbox-shell=${sh}/bin/busybox"
        ]
        ++ lib.optional (
            stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform ? nix && stdenv.hostPlatform.nix ? system
        ) ''--with-system=${stdenv.hostPlatform.nix.system}''
           # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
        ++ lib.optional (!withLibseccomp) "--disable-seccomp-sandboxing";

      makeFlags = [ "profiledir=$(out)/etc/profile.d" ];

      installFlags = [ "sysconfdir=$(out)/etc" ];

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
        platforms = stdenv.lib.platforms.unix;
        outputsToInstall = [ "out" "man" ];
      };

      passthru = {
<<<<<<< HEAD
        inherit fromGit;

        perl-bindings = perl.pkgs.toPerlModule(stdenv.mkDerivation {
          pname = "nix-perl";
          inherit version;

          inherit src;

          postUnpack = "sourceRoot=$sourceRoot/perl";

          # This is not cross-compile safe, don't have time to fix right now
          # but noting for future travellers.
          nativeBuildInputs =
            [ perl pkgconfig curl nix libsodium boost autoreconfHook autoconf-archive ];

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

  nixStable = callPackage common (rec {
    name = "nix-2.3.4";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "1c626a0de0acc69830b1891ec4d3c96aabe673b2a9fd04cef84f2304d05ad00d";
    };

    inherit storeDir stateDir confDir boehmgc;
  } // stdenv.lib.optionalAttrs stdenv.cc.isClang {
    stdenv = llvmPackages_6.stdenv;
  });

  nixUnstable = lib.lowPrio (callPackage common rec {
    name = "nix-2.4${suffix}";
    suffix = "pre7346_5e7ccdc9";

    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "5e7ccdc9e3ddd61dc85e20c898001345bfb497a5";
      sha256 = "10jg0rq92xbigbbri7harn4b75blqaf6rjgq4hhvlnggf2w9iprg";
    };

    crates = fetchurl {
      url = https://hydra.nixos.org/build/115942497/download/1/nix-vendored-crates-2.4pre20200403_3473b19.tar.xz;
      sha256 = "a83785553bb4bc5b28220562153e201ec555a00171466ac08b716f0c97aee45a";
    };

    inherit storeDir stateDir confDir boehmgc;
  });

  nixFlakes = lib.lowPrio (callPackage common rec {
    name = "nix-2.4${suffix}";
    suffix = "pre20200403_3473b19";

    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "3473b1950a90d596a3baa080fdfdb080f55a5cc0";
      sha256 = "1bb7a8a5lzmb3pzq80zxd3s9y3qv757q7032s5wvp75la9wgvmvr";
    };

    crates = fetchurl {
      url = https://hydra.nixos.org/build/115942497/download/1/nix-vendored-crates-2.4pre20200403_3473b19.tar.xz;
      sha256 = "a83785553bb4bc5b28220562153e201ec555a00171466ac08b716f0c97aee45a";
    };

    inherit storeDir stateDir confDir boehmgc;
  });

}
