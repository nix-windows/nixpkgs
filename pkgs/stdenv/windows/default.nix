{ lib
, localSystem, crossSystem, config, overlays
}:

assert localSystem.config == "x86_64-pc-windows-msvc" || localSystem.config == "i686-pc-windows-msvc";
assert crossSystem == null;

[
  ({}: rec {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-windows-boot-1";
      inherit config;
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = /*if crossSystem == null then*/ localSystem /*else crossSystem*/;

      initialPath = [];

      cc = null;
      fetchurlBoot = import ../../build-support/fetchurl/boot.nix {
        system = localSystem;
      };
      shell = builtins.getEnv "COMSPEC"; # "C:/Windows/System32/cmd.exe"; TODO: download some command-interpreter? maybe perl-static.exe?
    };

    p7zip-static = stdenv.mkDerivation {
      name = "7za-18.06-static";
      src = stdenv.fetchurlBoot {
        # 32-bit version from https://www.7-zip.org/a/7z1806-extra.7z
        url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/7za.exe";
        sha256 = "8e679f87ba503f3dfad96266ca79de7bfe3092dc6a58c0fe0438f7d4b19f0bbd";
      };
      builder = lib.concatStringsSep " & " [ ''md %out%\bin''
                                             ''copy %src% %out%\bin\7z.exe'' ];
    };
  })


  (prevStage: rec {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-windows-boot-2";
      inherit config;
      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform fetchurlBoot cc shell;

      initialPath = [ prevStage.p7zip-static ];
    };

    msblobs = import ../../../pkgs/development/compilers/msvc/2017-blobs.nix { stdenvNoCC = stdenv; };

#   # it uses Windows's SSL libs, not openssl
#   curl-static = stdenv.mkDerivation rec {
#     name = "curl-7.62.0";
#     src = stdenv.fetchurlBoot {
#       url = "https://curl.haxx.se/download/${name}.tar.bz2";
#       sha256 = "084niy7cin13ba65p8x38w2xcyc54n3fgzbin40fa2shfr0ca0kq";
#     };
#     INCLUDE = "${(msblobs.msvc).INCLUDE};${(msblobs.sdk).INCLUDE}";
#     LIB     = "${(msblobs.msvc).LIB};${(msblobs.sdk).LIB}";
#     PATH    = "${(msblobs.msvc).PATH};${(msblobs.sdk).PATH};${prevStage.p7zip-static}/bin"; # initialPath does not work because it is set up in setup.pm which is not involved here
#     builder = lib.concatStringsSep " & " [ ''7z x %src% -so  |  7z x -aoa -si -ttar''
#                                            ''cd ${name}\winbuild''
#                                            ''nmake /f Makefile.vc mode=static VC=15''
#                                            ''xcopy /E/I ..\builds\libcurl-vc15-${if stdenv.buildPlatform.is64bit then "x64" else "x86"}-release-static-ipv6-sspi-winssl\bin %out%\bin'' ];
#   };

    # TODO: build from source
    gnu-utils = let
      msysPackages  = import (../../development/mingw-modules/msys-packages- + (if stdenv.buildPlatform.is64bit then "x86_64.nix" else "i686.nix")) {
                        stdenvNoCC = stdenv; # with 7z.exe
                        fetchurl = stdenv.fetchurlBoot;
                        inherit msysPackages mingwPackages;
                      };
      mingwPackages = import (../../development/mingw-modules/mingw- + (if stdenv.buildPlatform.is64bit then "x86_64.nix" else "i686.nix")) {
                        stdenvNoCC = stdenv; # with 7z.exe
                        fetchurl = stdenv.fetchurlBoot;
                        inherit msysPackages mingwPackages;
                      };
      inherit (msysPackages) patch grep gawk sed;
    in stdenv.mkDerivation {
      name = "gnu-utils";
      buildInputs = [ patch grep sed gawk ];
      builder = lib.concatStringsSep " & " [ ''md %out%\bin''
                                             ''xcopy /E/H/B/F/I/Y ${lib.replaceStrings ["/"] ["\\"] "${sed  }/usr/bin/sed.exe  "} %out%\bin''
                                             ''xcopy /E/H/B/F/I/Y ${lib.replaceStrings ["/"] ["\\"] "${grep }/usr/bin/grep.exe "} %out%\bin''
                                             ''xcopy /E/H/B/F/I/Y ${lib.replaceStrings ["/"] ["\\"] "${gawk }/usr/bin/gawk.exe "} %out%\bin''
                                             ''xcopy /E/H/B/F/I/Y ${lib.replaceStrings ["/"] ["\\"] "${patch}/usr/bin/patch.exe"} %out%\bin''
                                             ''xcopy /E/H/B/F/I/Y ${lib.replaceStrings ["/"] ["\\"] "${sed  }/usr/bin/*.dll"    } %out%\bin''
                                             ''xcopy /E/H/B/F/I/Y ${lib.replaceStrings ["/"] ["\\"] "${grep }/usr/bin/*.dll"    } %out%\bin''
                                             ''xcopy /E/H/B/F/I/Y ${lib.replaceStrings ["/"] ["\\"] "${gawk }/usr/bin/*.dll"    } %out%\bin''
                                             ''xcopy /E/H/B/F/I/Y ${lib.replaceStrings ["/"] ["\\"] "${patch}/usr/bin/*.dll"    } %out%\bin''
                                           ];
      passthru = { inherit (msysPackages) patch grep gawk sed; };
    };

    perl-for-stdenv-shell = let
      # useful libs not included by default
      cpan-Capture-Tiny = stdenv.fetchurlBoot {
        url = "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz";
        sha256 = "069yrikrrb4vqzc3hrkkfj96apsh7q0hg8lhihq97lxshwz128vc";
      };
      cpan-Data-Dump = stdenv.fetchurlBoot {
        url = "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Data-Dump-1.23.tar.gz";
        sha256 = "0r9ba52b7p8nnn6nw0ygm06lygi8g68piri78jmlqyrqy5gb0lxg";
      };
      cpan-Win32-LongPath = stdenv.fetchurlBoot {
        url = "https://cpan.metacpan.org/authors/id/R/RB/RBOISVERT/Win32-LongPath-1.0.tar.gz";
        sha256 = "1wnfy43i3h5c9xq4lw47qalgfi5jq5z01sv6sb6r3qcb75y3zflx";
      };
      version = "5.28.1";
    in stdenv.mkDerivation {
      name = "perl-for-stdenv-shell-${version}";
      src = stdenv.fetchurlBoot {
        url = "https://www.cpan.org/src/5.0/perl-${version}.tar.gz";
        sha256 = "0iy3as4hnbjfyws4in3j9d6zhhjxgl5m95i5n9jy2bnzcpz8bgry";
      };
      INCLUDE = "${(msblobs.msvc).INCLUDE};${(msblobs.sdk).INCLUDE}";
      LIB     = "${(msblobs.msvc).LIB};${(msblobs.sdk).LIB}";
      PATH    = "${(msblobs.msvc).PATH};${(msblobs.sdk).PATH};${prevStage.p7zip-static}/bin"; # initialPath does not work because it is set up in setup.pm which is not involved here
      PERL_USE_UNSAFE_INC = "1"; # env var needed to build Win32-LongPath-1.0
      builder = lib.concatStringsSep " & " [ ''7z x %src%                         -so  |  7z x -aoa -si -ttar''
                                             ''7z x ${cpan-Capture-Tiny}          -so  |  7z x -aoa -si -ttar -operl-${version}\cpan''
                                             ''7z x ${cpan-Data-Dump}             -so  |  7z x -aoa -si -ttar -operl-${version}\cpan''
                                             ''cd perl-${version}\win32''
                                             ''nmake install INST_TOP=%out% CCTYPE=MSVC141 WIN64=${if stdenv.buildPlatform.is64bit then "define" else "undef"}''
                                             # it does not built being copied to \cpan or \ext
                                             ''7z x ${cpan-Win32-LongPath}        -so  |  7z x -aoa -si -ttar''
                                             ''cd Win32-LongPath-1.0''
                                             ''${gnu-utils}\bin\patch.exe -p1 < ${./Win32-LongPath.patch}'' # FIX https://github.com/rdboisvert/Win32-LongPath/issues/8
                                             ''%out%\bin\perl Makefile.PL''
                                             ''nmake''
                                             ''nmake test''
                                             ''nmake install''
                                             #
                                             ''copy ${lib.replaceStrings ["/"] ["\\"] "${./Utils.pm}"} %out%\site\lib\Win32\Utils.pm''
                                           ];
    };
  })


  (prevStage: rec {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-windows-boot-3";
      inherit config;
      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform fetchurlBoot;

      initialPath = prevStage.stdenv.initialPath ++ [ /*prevStage.curl-static*/ prevStage.gnu-utils ];
      cc = null;
      shell = "${prevStage.perl-for-stdenv-shell}/bin/perl.exe";
    };
    inherit (prevStage) perl-for-stdenv-shell;

#   fetchurl-curl-static = import ../../build-support/fetchurl {
#     inherit lib;
#     stdenvNoCC = stdenv; # with perl as .shell
#     curl = prevStage.curl-static;
#   };
  })


  (prevStage: {
    inherit config overlays;
    stdenv = import ../generic {
      name = "stdenv";
      inherit config;

      inherit (prevStage.stdenv) buildPlatform targetPlatform hostPlatform shell initialPath fetchurlBoot;
      cc = (import ../../../pkgs/development/compilers/msvc/2017.nix {
              stdenvNoCC = prevStage.stdenv;
              buildPackages = null;
            }) // { inherit (prevStage) perl-for-stdenv-shell; };
#     fetchurlBoot = prevStage.fetchurl-curl-static;
      extraNativeBuildInputs = [];
    };
  })

]
