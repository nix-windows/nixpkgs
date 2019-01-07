{ lib
, localSystem, crossSystem, config, overlays
}:

assert crossSystem == null;
assert localSystem.config == "x86_64-pc-windows-msvc";

let
  msvc_2017 = (import <nix/fetchurl.nix> {
    name = "msvc-${msvc_2017.version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/msvc-${msvc_2017.version}.nar.xz";
    unpack = true;
    sha256 = "2c3307db0c7f9b6f2a93f147da22960440aec9070a8916dfac7d5651b0e700da";
  }) // {
    version = "14.16.27023";
    INCLUDE = "${msvc_2017}/include;${msvc_2017}/atlmfc/include";
    LIB     = "${msvc_2017}/lib/x64;${msvc_2017}/atlmfc/lib/x64";
    LIBPATH = "${msvc_2017}/lib/x64;${msvc_2017}/atlmfc/lib/x64;${msvc_2017}/lib/x86/store/references";
    PATH    = "${msvc_2017}/bin/HostX64/x64";
  };

  # TODO: include VCRUNTIME140D.dll and MSVCP140D.dll and add redist to stdenv.cc's $PATH (boost makes /MDd binaries during configuration phase)
  redist = (import <nix/fetchurl.nix> {
    name = "redist-${redist.version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/redist-${redist.version}.nar.xz";
    unpack = true;
    sha256 = "5efca79f200c6a0795e3fd00544723aee42c2e502f77fe74edc7ecd77ac61578";
  }) // {
    version = "14.16.27012";
  };

# # Windows XP
# sdk_7_1 = throw "todo: SDK 7.1";
#
# # Windows 7 (it has no UCRT (<stdio.h> etc) so is not usable yet)
# sdk_8_1 = (import <nix/fetchurl.nix> {
#   name = "sdk-${sdk_8_1.version}";
#   url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/sdk-${sdk_8_1.version}.nar.xz";
#   unpack = true;
#   sha256 = "d1299b8399ad22fdb2303ca38f2a51fea5b94577b0de8bd7c238291c8d76d877";
# }) // {
#   version = "8.1";
#   INCLUDE = "${sdk_8_1}/include/shared;${sdk_8_1}/include/um;${sdk_8_1}/include/winrt";
#   LIB     = "${sdk_8_1}/Lib/winv6.3/um";
#   LIBPATH = "";
#   PATH    = "${sdk_8_1}/bin/x64";
# };

  # Windows 10
  sdk_10 = (import <nix/fetchurl.nix> {
    name = "sdk-${sdk_10.version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/sdk-${sdk_10.version}.nar.xz";
    unpack = true;
    sha256 = "ae43ffd01f53bef2ef6f2056dd87da30e46f02fdbcd2719dc382292106279369";
  }) // {
    version = "10.0.17763.0";
    INCLUDE = "${sdk_10}/include/${sdk_10.version}/ucrt;${sdk_10}/include/${sdk_10.version}/shared;${sdk_10}/include/${sdk_10.version}/um;${sdk_10}/include/${sdk_10.version}/winrt;${sdk_10}/include/${sdk_10.version}/cppwinrt";
    LIB     = "${sdk_10}/lib/${sdk_10.version}/ucrt/x64;${sdk_10}/lib/${sdk_10.version}/um/x64";
    LIBPATH = "${sdk_10}/UnionMetadata/${sdk_10.version};${sdk_10}/References/${sdk_10.version}";
    PATH    = "${sdk_10}/bin/${sdk_10.version}/x64;${sdk_10}/bin/x64";
  };

  msbuild = (import <nix/fetchurl.nix> {
    name = "msbuild-${msbuild.version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/msbuild-${msbuild.version}.nar.xz";
    unpack = true;
    sha256 = "032e6343d55762df6d5c9650d10e125946b7b8e85cc32e126b10b89a7be338ba";
  }) // {
    version = "15.0";
    PATH    = "${msbuild}/${msbuild.version}/bin/Roslyn;${msbuild}/${msbuild.version}/bin";
  };

  vc1 = import <nix/fetchurl.nix> {
    name = "vc1-${msbuild.version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/vc1-${msbuild.version}.nar.xz";
    unpack = true;
    sha256 = "0d861aeb29a9d88746a70c9d89007639c7d9107cfba8fa1139f68ee21ddf744b";
  };

in

[

  ({}: rec {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-windows-boot-1";
      inherit config;
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;

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
        # from https://www.7-zip.org/a/7z1806-extra.7z
        url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/7za.exe";
        sha256 = "1g8bkyqx9xrq0kzc0n3avj931zkvvrwwlrk2v7x3sgshpa3ryrwf";
      };
      builder = lib.concatStringsSep " & " [ ''md %out%\bin''
                                             ''copy %src% %out%\bin\7z.exe'' ];
    };

    makeWrapper = stdenv.mkDerivation rec {
      name = "makeWrapper";
      INCLUDE = "${msvc_2017.INCLUDE};${sdk_10.INCLUDE}";
      LIB     = "${msvc_2017.LIB};${sdk_10.LIB}";
      PATH    = "${msvc_2017.PATH};${sdk_10.PATH}";
      builder = lib.concatStringsSep " & " [ ''md %out%\bin''
                                             ''cl /O2 /MT /EHsc /Fe:%out%\bin\makeWrapper.exe /DINCLUDE=${INCLUDE} /DLIB=${LIB} /DCC=${msvc_2017}/bin/HostX64/x64/cl.exe ${./makeWrapper.cpp}'' ];
    };
  })


  (prevStage: rec {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-windows-boot-2";
      inherit config;
      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform fetchurlBoot cc shell;

      initialPath = [ prevStage.p7zip-static prevStage.makeWrapper ];
    };
    inherit prevStage;

    # it uses Windows's SSL libs, not openssl
    curl-static = stdenv.mkDerivation rec {
      name = "curl-7.62.0";
      src = stdenv.fetchurlBoot {
        url = "https://curl.haxx.se/download/${name}.tar.bz2";
        sha256 = "084niy7cin13ba65p8x38w2xcyc54n3fgzbin40fa2shfr0ca0kq";
      };
      INCLUDE = "${msvc_2017.INCLUDE};${sdk_10.INCLUDE}";
      LIB     = "${msvc_2017.LIB};${sdk_10.LIB}";
      PATH    = "${msvc_2017.PATH};${sdk_10.PATH};${prevStage.p7zip-static}/bin"; # initialPath does not work because it is set up in setup.pm which is not involved here
      builder = lib.concatStringsSep " & " [ ''7z x %src% -so  |  7z x -aoa -si -ttar''
                                             ''cd ${name}\winbuild''
                                             ''nmake /f Makefile.vc mode=static VC=15''
                                             ''xcopy /E/I ..\builds\libcurl-vc15-x64-release-static-ipv6-sspi-winssl\bin %out%\bin'' ];
    };

    # a symlink utility
    # not compatible with coreutils' ln !
    # not open-source :-(
    schinagl-ln = stdenv.mkDerivation rec {
      name = "ln-2.9.0.2";
      src = stdenv.fetchurlBoot {
        url = "http://www.schinagl.priv.at/nt/ln/ln.zip";
        sha256 = "1f9mx8q679i4abdmjk01hrzdyjwj08m229fp00mvj25q5xi030y1";
      };
      PATH    = "${prevStage.p7zip-static}/bin";
      builder = lib.concatStringsSep " & " [ ''7z x %src% ln.exe -o%out%\bin''
                                             ''xcopy /E/I ${lib.replaceStrings ["/"] ["\\"] "${redist}/x64/Microsoft.VC141.CRT/msvcp140.dll"    } %out%\bin''
                                             ''xcopy /E/I ${lib.replaceStrings ["/"] ["\\"] "${redist}/x64/Microsoft.VC141.CRT/vcruntime140.dll"} %out%\bin''
                                           ];
    };

    # TODO: build from source
    gnu-utils = let
      inherit (import <nixpkgs/pkgs/development/mingw-modules/msys-packages.nix> {
                 stdenvNoCC = stdenv; # with 7z.exe
                 fetchurl = stdenv.fetchurlBoot;
               }) patch grep gawk sed;
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
        # File::Copy::Recursive is not able to copy Windows symlinks!
        # ALSO: File::Path::remove_tree unable to remove dangling symlinks
        #(stdenv.fetchurlBoot {
        #  url = "https://cpan.metacpan.org/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.44.tar.gz";
        #  sha256 = "1r3frbl61kr7ig9bzd60fka772cd504v3kx9kgnwvcy1inss06df";
        #})
#       (stdenv.fetchurlBoot {
#         url = "https://cpan.metacpan.org/authors/id/J/JD/JDB/Win32-0.52.tar.gz";
#         sha256 = "0xsy52qi7glffznil5sxaccldxpn0fvcwz706lgdbcx80dw1jq7g";
#       })
#       (stdenv.fetchurlBoot {
#         url = "https://cpan.metacpan.org/authors/id/S/SH/SHAY/Win32-UTCFileTime-1.59.tar.gz";
#         sha256 = "1a3yn46pwcfna0z8pi288ayda8s0zgy30z7v7fan1pvgajdbmhh9";
#       })
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
      INCLUDE = "${msvc_2017.INCLUDE};${sdk_10.INCLUDE}";
      LIB     = "${msvc_2017.LIB};${sdk_10.LIB}";
      PATH    = "${msvc_2017.PATH};${sdk_10.PATH};${prevStage.p7zip-static}/bin";
      PERL_USE_UNSAFE_INC = "1"; # env var needed to build Win32-LongPath-1.0
      builder = lib.concatStringsSep " & " [ ''7z x %src%                         -so  |  7z x -aoa -si -ttar''
                                             ''7z x ${cpan-Capture-Tiny}          -so  |  7z x -aoa -si -ttar -operl-${version}\cpan''
                                             ''7z x ${cpan-Data-Dump}             -so  |  7z x -aoa -si -ttar -operl-${version}\cpan''
                                             ''cd perl-${version}\win32''
                                             ''nmake install INST_TOP=%out% CCTYPE=MSVC141${if stdenv.is64bit then " WIN64=define" else ""}''
                                             # it does not built being copied to \cpan or \ext
                                             ''7z x ${cpan-Win32-LongPath}        -so  |  7z x -aoa -si -ttar''
                                             ''cd Win32-LongPath-1.0''
                                             ''%out%\bin\perl Makefile.PL''
                                             ''nmake''
                                             ''nmake test''
                                             ''nmake install''
                                           ];
    };
  })


  (prevStage: rec {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-windows-boot-3";
      inherit config;
      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform;

      initialPath = prevStage.stdenv.initialPath ++ [ prevStage.curl-static prevStage.gnu-utils prevStage.schinagl-ln ];
      cc = null;
      fetchurlBoot = null;
      shell = "${prevStage.perl-for-stdenv-shell}/bin/perl.exe";
    };

    fetchurl-curl-static = import ../../build-support/fetchurl {
      inherit lib;
      stdenvNoCC = stdenv; # with perl as .shell
      curl = prevStage.curl-static;
    };

    cc2017 = let
      # this has references to nix store, depends on nix store location and might have problems being fixed-output derivation
      vc = stdenv.mkDerivation {
        name = "vc-${msbuild.version}";
        buildInputs = [ vc1 ];
        buildCommand = ''
          #
          dircopy("${vc1}", $ENV{out}) or die "dircopy(${vc1}, $ENV{out}): $!";

          # so far there is no `substituteInPlace`
          for my $filename (glob("$ENV{out}/VCTargets/*.props"), glob("$ENV{out}/VCTargets/*.targets")) {
            changeFile {
              s|>(\$\(Registry:HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows Kits\\Installed Roots\@KitsRoot10\))|>${sdk_10}/<!-- $1 -->|g;
              s|>(\$\(Registry:HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v10.0\@InstallationFolder\))|>${sdk_10}/<!-- $1 -->|g;
              s|\$\(VCToolsInstallDir_150\)|${msvc_2017}/|g;
              s|>(\$\(Registry:[^)]+\))|><!-- $1 -->|g;
              $_;
            } $filename;
          }
        '';
      };

      cc-wrapper = { msvc, sdk }: stdenv.mkDerivation {
        name = "${msvc.name}+${sdk.name}+${msbuild.name}";
        buildInputs = [ msvc sdk msbuild vc ];
        buildCommand = ''
          make_pathL("$ENV{out}/bin", "$ENV{out}/VC/Tools/MSVC") or die "make_pathL: $!";

          for my $name ('cl', 'ml64', 'lib', 'link', 'nmake', 'mc', 'mt', 'rc', 'dumpbin', 'csc', 'msbuild') {
            my $target;
            $target = "${msvc}/bin/HostX64/x64/$name.exe"                   if !$target && -f "${msvc}/bin/HostX64/x64/$name.exe";
            $target = "${sdk}/bin/${sdk.version}/x64/$name.exe"             if !$target && -f "${sdk}/bin/${sdk.version}/x64/$name.exe";
            $target = "${sdk}/bin/x64/$name.exe"                            if !$target && -f "${sdk}/bin/x64/$name.exe";
            $target = "${msbuild}/${msbuild.version}/bin/Roslyn/$name.exe"  if !$target && -f "${msbuild}/${msbuild.version}/bin/Roslyn/$name.exe";
            $target = "${msbuild}/${msbuild.version}/bin/$name.exe"         if !$target && -f "${msbuild}/${msbuild.version}/bin/$name.exe";
            die "no target $target"                                         if !$target;

            system( "makeWrapper.exe", $target, "$ENV{out}/bin/$name.exe"
                  , '--prefix', 'PATH',             ';', '${msvc.PATH};${sdk.PATH};${msbuild.PATH}'
                  , '--suffix', 'INCLUDE',          ';', '${msvc.INCLUDE};${sdk.INCLUDE}'
                  , '--suffix', 'LIB',              ';', '${msvc.LIB};${sdk.LIB}'
                  , '--suffix', 'LIBPATH',          ';', '${msvc.LIBPATH};${sdk.LIBPATH}'
                  , '--suffix', 'WindowsLibPath',   ';', '${sdk}/UnionMetadata/${sdk.version};${sdk}/References/${sdk.version}'
                  , '--set',    'WindowsSDKLibVersion',  '${sdk.version}'
                  , '--set',    'WindowsSDKVersion',     '${sdk.version}'
                  , '--set',    'WindowsSdkVerBinPath',  '${sdk}/bin/${sdk.version}/'
                  , '--set',    'WindowsSdkBinPath',     '${sdk}/bin/'
                  , '--set',    'WindowsSdkDir',         '${sdk}'
                  , '--set',    'VCToolsVersion',        '${msvc.version}'
                  , '--set',    'VCToolsInstallDir',     '${msvc}/'
                  , '--set',    'VCToolsRedistDir',      '${msvc}/'
                  , '--set',    'VCTargetsPath',         '${vc}/VCTargets/'
                  , '--set',    'UCRTVersion',           '${sdk.version}'
                  , '--set',    'UniversalCRTSdkDir',    '${sdk}/'
                  ) == 0 or die "makeWrapper failed: $!";
          }

          # for those who want to deal with (execute or even parse) vcvarsall.bat (chromium, boost, ...)
          writeFile("$ENV{out}/VC/vcvarsall.bat",
                       ('PATH'                  ."=${msvc.PATH};${sdk.PATH};${msbuild.PATH};%PATH%\n".
                    'set INCLUDE'               ."=%INCLUDE%;${msvc.INCLUDE};${sdk.INCLUDE}\n".
                    'set LIB'                   ."=%LIB%;${msvc.LIB};${sdk.LIB}\n".
                    'set LIBPATH'               ."=%LIBPATH%;${msvc.LIBPATH};${sdk.LIBPATH}\n".
                    'set WindowsLibPath'        ."=${sdk}/UnionMetadata/${sdk.version};${sdk}/References/${sdk.version}\n".
                    'set WindowsSDKLibVersion'  ."=${sdk.version}\n".
                    'set WindowsSDKVersion'     ."=${sdk.version}\n".
                    'set WindowsSdkVerBinPath'  ."=${sdk}/bin/${sdk.version}/\n".
                    'set WindowsSdkBinPath'     ."=${sdk}/bin/\n".
                    'set WindowsSdkDir'         ."=${sdk}\n".
                    'set VCToolsVersion'        ."=${msvc.version}\n".
                    'set VCToolsInstallDir'     ."=${msvc}/\n".
                    'set VCToolsRedistDir'      ."=${msvc}/\n".
                    'set VCTargetsPath'         ."=${vc}/VCTargets/\n".
                    'set UCRTVersion'           ."=${sdk.version}\n".
                    'set UniversalCRTSdkDir'    ."=${sdk}/\n") =~ s|/|\\|gr);

          # make symlinks to help chromium builder which expects a particular directory structure (todo: move to chromium.nix)
          uncsymlink('${sdk}/DIA SDK' => "$ENV{out}/DIA SDK"                      ) or die $!;
          uncsymlink('${msvc}'        => "$ENV{out}/VC/Tools/MSVC/${msvc.version}") or die $!;
        '';

        passthru = {
          targetPrefix = "";
          isClang = false;
          isGNU = false;
          inherit msvc redist sdk msbuild vc /*vc1*/;
#         INCLUDE = "${msvc.INCLUDE};${sdk.INCLUDE}";
#         LIB     = "${msvc.LIB};${sdk.LIB}";
#         PATH    = "${msvc.PATH};${sdk.PATH}";
#         p7zip-static = prevStage.prevStage.p7zip-static;
          makeWrapper = prevStage.prevStage.makeWrapper;
          perl-for-stdenv-shell = prevStage.perl-for-stdenv-shell;
          curl-static = prevStage.curl-static;
          gnu-utils = prevStage.gnu-utils;
          schinagl-ln = prevStage.schinagl-ln;
        };
      };
    in cc-wrapper { msvc = msvc_2017; sdk = sdk_10; };
  })


  (prevStage: {
    inherit config overlays;
    stdenv = import ../generic {
      name = "stdenv-windows-boot-4";
      inherit config;

      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform shell initialPath;
      cc = prevStage.cc2017;
      fetchurlBoot = prevStage.fetchurl-curl-static;
    };
  })

]
