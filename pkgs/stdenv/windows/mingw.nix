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

    p7zip-i686 = import ./p7zip.nix { stdenvNoCC = stdenv; };
  })


  (prevStage: rec {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-windows-boot-2";
      inherit config;
      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform fetchurlBoot cc shell;

      initialPath = [ prevStage.p7zip-i686 ];
    };


    # here is no $out\bin because I do not know how to make them sing only cmd.exe as a shell
    msysPacmanNoBin  = import (../../development/mingw-modules/msys-pacman- + (if stdenv.buildPlatform.is64bit then "x86_64.nix" else "i686.nix")) { # <- no need, it is always nobin
                         stdenvNoCC = stdenv; # with 7z.exe
                         fetchurl = stdenv.fetchurlBoot;
                         msysPacman = mingwPacmanNoBin;
                         mingwPacman = mingwPacmanNoBin;
                       };
    mingwPacmanNoBin = import (../../development/mingw-modules/mingw-pacman- + (if stdenv.buildPlatform.is64bit then "x86_64.nix" else "i686.nix")) {
                         stdenvNoCC = stdenv; # with 7z.exe
                         fetchurl = stdenv.fetchurlBoot;
                         msysPacman = mingwPacmanNoBin;
                         mingwPacman = mingwPacmanNoBin;
                       };

    perl-for-stdenv-shell = let
      # useful libs not included by default
      cpan-Capture-Tiny = stdenv.fetchurlBoot {
        url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz";
        sha256 = "069yrikrrb4vqzc3hrkkfj96apsh7q0hg8lhihq97lxshwz128vc";
      };
      cpan-Data-Dump = stdenv.fetchurlBoot {
        url = "mirror://cpan/authors/id/G/GA/GAAS/Data-Dump-1.23.tar.gz";
        sha256 = "0r9ba52b7p8nnn6nw0ygm06lygi8g68piri78jmlqyrqy5gb0lxg";
      };
      cpan-Win32-LongPath = stdenv.fetchurlBoot {
        url = "mirror://cpan/authors/id/R/RB/RBOISVERT/Win32-LongPath-1.0.tar.gz";
        sha256 = "1wnfy43i3h5c9xq4lw47qalgfi5jq5z01sv6sb6r3qcb75y3zflx";
      };
      version = "5.32.0";
    in stdenv.mkDerivation {
      name = "perl-for-stdenv-shell-${version}";
      src = stdenv.fetchurlBoot {
        url = "mirror://cpan/src/5.0/perl-${version}.tar.gz";
        sha256 = "1d6001cjnpxfv79000bx00vmv2nvdz7wrnyas451j908y7hirszg";
      };
      PATH    = lib.concatStringsSep ";" [ "${prevStage.p7zip-i686}/bin"
                                           "${msysPacmanNoBin .patch}/usr/bin"
                                           "${msysPacmanNoBin .gawk }/usr/bin"
                                           "${mingwPacmanNoBin.make }/mingw32/bin"
                                           "${mingwPacmanNoBin.grep }/mingw32/bin"
                                           "${mingwPacmanNoBin.sed  }/mingw32/bin"
                                           "${mingwPacmanNoBin.gcc  }/mingw32/bin"
                                         ];
      PERL_USE_UNSAFE_INC = "1"; # env var needed to build Win32-LongPath-1.0
      builder = lib.concatStringsSep " & " [ ''echo %PATH%''
                                             ''7z x %src%                         -so  |  7z x -aoa -si -ttar''
                                             ''7z x ${cpan-Capture-Tiny}          -so  |  7z x -aoa -si -ttar -operl-${version}\cpan''
                                             ''7z x ${cpan-Data-Dump}             -so  |  7z x -aoa -si -ttar -operl-${version}\cpan''

                                             ''cd perl-${version}''
                                             ''patch.exe -p1 < ${./perl-on-gcc10.patch}''

                                             ''cd win32''
                                             ''mingw32-make.exe -j%NIX_BUILD_CORES% -f GNUmakefile install PLMAKE=mingw32-make.exe INST_TOP=%out% CCTYPE=GCC ${if stdenv.is64bit then "WIN64=define GCCTARGET=x86_64-w64-mingw32" else "WIN64=undef GCCTARGET=i686-w64-mingw32"}''

                                             ''copy ${lib.replaceStrings ["/"] ["\\"] "${mingwPacmanNoBin.gcc}/mingw32/bin/libgcc_s_dw2*.dll" } %out%\bin\''     # TODO: hardlink
                                             ''copy ${lib.replaceStrings ["/"] ["\\"] "${mingwPacmanNoBin.gcc}/mingw32/bin/libstdc*.dll"      } %out%\bin\''     # TODO: hardlink
                                             ''copy ${lib.replaceStrings ["/"] ["\\"] "${mingwPacmanNoBin.gcc}/mingw32/bin/libwinpthread*.dll"} %out%\bin\''     # TODO: hardlink


                                           # ''nmake install INST_TOP=%out% CCTYPE=${assert lib.versionAtLeast msblobs.msvc.version "14.20" && lib.versionOlder msblobs.msvc.version "14.30"; "MSVC142"} ${if stdenv.is64bit then "WIN64=define PROCESSOR_ARCHITECTURE=AMD64" else "WIN64=undef PROCESSOR_ARCHITECTURE=X86"}''
                                           # # it does not built being copied to \cpan or \ext
                                             ''7z x ${cpan-Win32-LongPath}        -so  |  7z x -aoa -si -ttar''
                                             ''cd Win32-LongPath-1.0''
                                             ''patch.exe -p1 < ${./Win32-LongPath.patch}'' # FIX https://github.com/rdboisvert/Win32-LongPath/issues/8
                                             ''%out%\bin\perl.exe Makefile.PL''
                                             ''mingw32-make.exe -j%NIX_BUILD_CORES%''
                                             ''mingw32-make.exe -j%NIX_BUILD_CORES% test''
                                             ''mingw32-make.exe -j%NIX_BUILD_CORES% install''
                                           # #
                                             ''copy ${lib.replaceStrings ["/"] ["\\"] "${./Utils.pm}"} %out%\site\lib\Win32\Utils.pm''
                                           ];
      passthru = { inherit mingwPacmanNoBin msysPacmanNoBin; };
    };
  })


  (prevStage: rec {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-windows-boot-3";
      inherit config;
      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform fetchurlBoot;

      initialPath = prevStage.stdenv.initialPath ++ [ /*prevStage.curl-static*/ /*prevStage.gnu-utils*/ ];
      cc = null;
      shell = "${prevStage.perl-for-stdenv-shell}/bin/perl.exe";
    };
    inherit (prevStage) perl-for-stdenv-shell;

    msysPacman       = import (../../development/mingw-modules/msys-pacman- + (if stdenv.buildPlatform.is64bit then "x86_64.nix" else "i686.nix")) {
                         stdenvNoCC = stdenv; # with 7z.exe and perl shell
                         fetchurl = stdenv.fetchurlBoot;
                         inherit msysPacman mingwPacman;
                       };
    mingwPacman      = import (../../development/mingw-modules/mingw-pacman- + (if stdenv.buildPlatform.is64bit then "x86_64.nix" else "i686.nix")) {
                         stdenvNoCC = stdenv; # with 7z.exe and perl shell
                         fetchurl = stdenv.fetchurlBoot;
                         inherit msysPacman mingwPacman;
                       };
  })


  (prevStage: {
    inherit config overlays;
    stdenv = import ../generic {
      name = "stdenv";
      inherit config;

      initialPath = with prevStage; stdenv.initialPath ++ [
        mingwPacman.make mingwPacman.grep mingwPacman.sed
        # FIXME: so far msysPacman.patch and msysPacman.gawk have no /bin/ and cannot get not to path, there is a workawound in gcc-wrapper
      ];

      inherit (prevStage.stdenv) buildPlatform targetPlatform hostPlatform shell fetchurlBoot;
      cc = ( import ./gcc-wrapper.nix {
               stdenvNoCC = prevStage.stdenv;
#              buildPackages = null;
               lib = prevStage.stdenv.lib;
               inherit (prevStage) msysPacman mingwPacman;
             }) // { inherit (prevStage) perl-for-stdenv-shell; };
      extraNativeBuildInputs = [];
    };
  })

]
