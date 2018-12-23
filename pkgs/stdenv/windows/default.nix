{ lib
, localSystem, crossSystem, config, overlays
}:

assert crossSystem == null;

let
  msvc-version = "14.16.27023";
  sdk-version = "10.0.17763.0";
  msbuild-version = "15.0";

  msvc = import <nix/fetchurl.nix> {
    name = "msvc-${msvc-version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/msvc-${msvc-version}.nar.xz";
    unpack = true;
    sha256 = "2c3307db0c7f9b6f2a93f147da22960440aec9070a8916dfac7d5651b0e700da";
  };

  sdk = import <nix/fetchurl.nix> {
    name = "sdk-${sdk-version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/sdk-${sdk-version}.nar.xz";
    unpack = true;
    sha256 = "ae43ffd01f53bef2ef6f2056dd87da30e46f02fdbcd2719dc382292106279369";
  };

  msbuild = import <nix/fetchurl.nix> {
    name = "msbuild-${msbuild-version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/msbuild-${msbuild-version}.nar.xz";
    unpack = true;
    sha256 = "59538ff87dff578642f606f38325813bf18ea051786954bb6fa3c5a4dd9f9c41";
  };

  vc1 = import <nix/fetchurl.nix> {
    name = "vc1-${msbuild-version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/vc1-${msbuild-version}.nar.xz";
    unpack = true;
    sha256 = "0d861aeb29a9d88746a70c9d89007639c7d9107cfba8fa1139f68ee21ddf744b";
  };

  msvc-INCLUDE = "${msvc}/include;${msvc}/atlmfc/include;${sdk}/include/${sdk-version}/ucrt;${sdk}/include/${sdk-version}/shared;${sdk}/include/${sdk-version}/um;${sdk}/include/${sdk-version}/winrt;${sdk}/include/${sdk-version}/cppwinrt";
  msvc-LIB     = "${msvc}/lib/x64;${msvc}/atlmfc/lib/x64;${sdk}/lib/${sdk-version}/ucrt/x64;${sdk}/lib/${sdk-version}/um/x64";
  msvc-PATH    = "${msvc}/bin/HostX64/x64;${sdk}/bin/${sdk-version}/x64;${sdk}/bin/x64";
in

[

  ({}: rec {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-windows-boot-0";
      inherit config;
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;

      initialPath = [];

      cc = null;
      fetchurlBoot = null;
      shell = builtins.getEnv "COMSPEC"; # "C:/Windows/System32/cmd.exe"; TODO: download some command-interpreter? maybe perl-static.exe?
    };

    fetchurlBoot = import ../../build-support/fetchurl/boot.nix {
      system = localSystem;
    };

    p7zip-static = stdenv.mkDerivation {
      name = "7z-18.05-static";
      src = fetchurlBoot {
       #url = "file://C:/Program%20Files/7-Zip/7z.exe";
        url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/7z.exe";
        sha256 = "1lzjk0pzc549hx6salnq04gkyb5zsngzzf6fv00nwxslzs1j8ij7";
      };
      builder = lib.concatStringsSep " & " [ ''md %out%\bin''
                                             ''copy %src% %out%\bin\7z.exe'' ];
    };

    # it uses Windows's SSL libs, not openssl
    curl-static = stdenv.mkDerivation rec {
      name = "curl-7.62.0";
      src = fetchurlBoot {
        url = "https://curl.haxx.se/download/${name}.tar.bz2";
        sha256 = "084niy7cin13ba65p8x38w2xcyc54n3fgzbin40fa2shfr0ca0kq";
      };
      INCLUDE = msvc-INCLUDE;
      LIB     = msvc-LIB;
      PATH    = "${msvc-PATH};${p7zip-static}/bin";
      builder = lib.concatStringsSep " & " [ ''7z x %src% -so  |  7z x -aoa -si -ttar''
                                             ''cd ${name}\winbuild''
                                             ''nmake /f Makefile.vc mode=static VC=15''
                                             ''xcopy /E/I ..\builds\libcurl-vc15-x64-release-static-ipv6-sspi-winssl\bin %out%\bin'' ];
    };

    perl-for-stdenv-shell = let
      # useful libs not included by default
      perl-CaptureTiny-src = fetchurlBoot {
        url = "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz";
        sha256 = "069yrikrrb4vqzc3hrkkfj96apsh7q0hg8lhihq97lxshwz128vc";
      };
      # File::Copy::Recursive is not able to copy Windows symlinks!
      perl-FileCopyRecursive-src = fetchurlBoot {
        url = "https://cpan.metacpan.org/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.44.tar.gz";
        sha256 = "1r3frbl61kr7ig9bzd60fka772cd504v3kx9kgnwvcy1inss06df";
      };
      version = "5.28.1";
    in stdenv.mkDerivation {
      name = "perl-for-stdenv-shell-${version}";
      src = fetchurlBoot {
        url = "https://www.cpan.org/src/5.0/perl-${version}.tar.gz";
        sha256 = "0iy3as4hnbjfyws4in3j9d6zhhjxgl5m95i5n9jy2bnzcpz8bgry";
      };
      INCLUDE = msvc-INCLUDE;
      LIB     = msvc-LIB;
      PATH    = "${msvc-PATH};${p7zip-static}/bin";
      builder = lib.concatStringsSep " & " [ ''7z x %src%                         -so  |  7z x -aoa -si -ttar''
                                             ''7z x ${perl-CaptureTiny-src}       -so  |  7z x -aoa -si -ttar -operl-${version}\ext''
                                             ''7z x ${perl-FileCopyRecursive-src} -so  |  7z x -aoa -si -ttar -operl-${version}\ext''
                                             ''cd perl-${version}\win32''
                                             ''nmake install INST_TOP=%out% CCTYPE=MSVC141${if stdenv.is64bit then " WIN64=define" else ""}'' ];
    };

    makeWrapper = stdenv.mkDerivation rec {
      name = "makeWrapper";
      INCLUDE = msvc-INCLUDE;
      LIB     = msvc-LIB;
      PATH    = msvc-PATH;
      builder = lib.concatStringsSep " & " [ ''md %out%\bin''
                                             ''cl /O2 /MT /EHsc /Fe:%out%\bin\makeWrapper.exe /DINCLUDE=${INCLUDE} /DLIB=${LIB} /DCC=${msvc}/bin/HostX64/x64/cl.exe ${./makeWrapper.cpp}'' ];
    };
  })


  (prevStage: rec {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-windows-boot-1";
      inherit config;
      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform;

      initialPath = [ prevStage.makeWrapper prevStage.p7zip-static ];
      cc = null;
      fetchurlBoot = null;
      shell = "${prevStage.perl-for-stdenv-shell}/bin/perl.exe";
    };

    fetchurl = import ../../build-support/fetchurl {
      inherit lib;
      stdenvNoCC = stdenv; # with perl as .shell
      curl = prevStage.curl-static;
    };

    cc = let
      # this has references to nix store, depends on nix store location and might have problems being fixed-output derivation
      vc = stdenv.mkDerivation {
        name = "vc-${msbuild-version}";
        buildCommand = ''
          dircopy("${vc1}", $ENV{out}) or die "$!";

          # so far there is no `substituteInPlace`
          for my $filename (glob("$ENV{out}/VCTargets/*.props"), glob("$ENV{out}/VCTargets/*.targets")) {
            open(my $in, $filename)         or die "open($filename): $!";
            open(my $out, ">$filename.new") or die "open(>$filename.new): $!";
            for my $line (<$in>) {
              $line =~ s|>(\$\(Registry:HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows Kits\\Installed Roots\@KitsRoot10\))|>${sdk}/<!-- $1 -->|g;
              $line =~ s|>(\$\(Registry:HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v10.0\@InstallationFolder\))|>${sdk}/<!-- $1 -->|g;
              $line =~ s|\$\(VCToolsInstallDir_150\)|${msvc}/|g;
              $line =~ s|>(\$\(Registry:[^)]+\))|><!-- $1 -->|g;
              print $out $line;
            }
            close($in);
            close($out);
            unlink($filename) or die "unlink($filename): $!";
            move("$filename.new", $filename) or die "move($filename.new, $filename): $!";
          }
        '';
      };

      cc-wrapper = stdenv.mkDerivation {
        name = "${msvc.name}+${sdk.name}+${msbuild.name}";
        buildCommand = ''
          make_path("$ENV{out}/bin", "$ENV{out}/VC/Tools/MSVC") or die "make_path: $!";

          for my $name ('cl', 'ml64', 'lib', 'link', 'nmake', 'mc', 'mt', 'rc', 'dumpbin', 'csc', 'msbuild') {
            my $target;
            $target = "${msvc}/bin/HostX64/x64/$name.exe"                   if !$target && -f "${msvc}/bin/HostX64/x64/$name.exe";
            $target = "${sdk}/bin/${sdk-version}/x64/$name.exe"             if !$target && -f "${sdk}/bin/${sdk-version}/x64/$name.exe";
            $target = "${sdk}/bin/x64/$name.exe"                            if !$target && -f "${sdk}/bin/x64/$name.exe";
            $target = "${msbuild}/${msbuild-version}/bin/Roslyn/$name.exe"  if !$target && -f "${msbuild}/${msbuild-version}/bin/Roslyn/$name.exe";
            $target = "${msbuild}/${msbuild-version}/bin/$name.exe"         if !$target && -f "${msbuild}/${msbuild-version}/bin/$name.exe";
            die "no target $target"                                         if !$target;

            system( "makeWrapper.exe", $target, "$ENV{out}/bin/$name.exe"
                  , '--prefix', 'PATH',             ';', '${msvc-PATH};${msbuild}/${msbuild-version}/bin/Roslyn;${msbuild}/${msbuild-version}/bin'
                  , '--suffix', 'INCLUDE',          ';', '${msvc-INCLUDE}'
                  , '--suffix', 'LIB',              ';', '${msvc-LIB}'
                  , '--suffix', 'LIBPATH',          ';', '${msvc}/lib/x64;${msvc}/lib/x86/store/references;${sdk}/UnionMetadata/${sdk-version};${sdk}/References/${sdk-version}'
                  , '--suffix', 'WindowsLibPath',   ';', '${sdk}/UnionMetadata/${sdk-version};${sdk}/References/${sdk-version}'
                  , '--set',    'WindowsSDKLibVersion',  '${sdk-version}'
                  , '--set',    'WindowsSDKVersion',     '${sdk-version}'
                  , '--set',    'WindowsSdkVerBinPath',  '${sdk}/bin/${sdk-version}'
                  , '--set',    'WindowsSdkBinPath',     '${sdk}/bin'
                  , '--set',    'WindowsSdkDir',         '${sdk}'
                  , '--set',    'VCToolsVersion',        '${msvc-version}'
                  , '--set',    'VCToolsInstallDir',     '${msvc}'
                  , '--set',    'VCToolsRedistDir',      '${msvc}'
                  , '--set',    'VCTargetsPath',         '${vc}/VCTargets'
                  , '--set',    'UCRTVersion',           '${sdk-version}'
                  , '--set',    'UniversalCRTSdkDir',    '${sdk}/'
                  ) == 0 or die "makeWrapper failed: $!";
          }

          # for those who want to deal with vcvarsall.bat (chromium, boost, ...)
          open(my $fh, ">$ENV{out}/VC/vcvarsall.bat") or die $!;
          my $content = 'PATH'                  ."=${msvc-PATH};${msbuild}/${msbuild-version}/bin/Roslyn;${msbuild}/${msbuild-version}/bin;%PATH%\n".
                    'set INCLUDE'               ."=%INCLUDE%;${msvc-INCLUDE}\n".
                    'set LIB'                   ."=%LIB%;${msvc-LIB}\n".
                    'set LIBPATH'               ."=%LIBPATH%;${msvc}/lib/x64;${msvc}/lib/x86/store/references;${sdk}/UnionMetadata/${sdk-version};${sdk}/References/${sdk-version}\n".
                    'set WindowsLibPath'        ."=${sdk}/UnionMetadata/${sdk-version};${sdk}/References/${sdk-version}\n".
                    'set WindowsSDKLibVersion'  ."=${sdk-version}\n".
                    'set WindowsSDKVersion'     ."=${sdk-version}\n".
                    'set WindowsSdkVerBinPath'  ."=${sdk}/bin/${sdk-version}\n".
                    'set WindowsSdkBinPath'     ."=${sdk}/bin\n".
                    'set WindowsSdkDir'         ."=${sdk}\n".
                    'set VCToolsVersion'        ."=${msvc-version}\n".
                    'set VCToolsInstallDir'     ."=${msvc}\n".
                    'set VCToolsRedistDir'      ."=${msvc}\n".
                    'set VCTargetsPath'         ."=${vc}/VCTargets\n".
                    'set UCRTVersion'           ."=${sdk-version}\n".
                    'set UniversalCRTSdkDir'    ."=${sdk}/\n";
          print $fh ($content =~ s|/|\\|gr);
          close($fh);

          # make symlinks to help chromium builder which expects a particular directory structure (todo: move to chromium.nix)
          system('mklink /D '.escapeWindowsArg("$ENV{out}/DIA SDK"                       =~ s|/|\\|gr).' '.escapeWindowsArg('${sdk}/DIA SDK' =~ s|/|\\|gr)) == 0 or die;
          system('mklink /D '.escapeWindowsArg("$ENV{out}/VC/Tools/MSVC/${msvc-version}" =~ s|/|\\|gr).' '.escapeWindowsArg('${msvc}'        =~ s|/|\\|gr)) == 0 or die;
        '';

        passthru = {
          targetPrefix = "";
          isClang = false;
          isGNU = false;
          inherit msvc sdk msbuild msvc-version sdk-version msbuild-version vc /*vc1*/ /*perl-for-stdenv-shell*/;
          makeWrapper = prevStage.makeWrapper;
#         perl-for-stdenv-shell = prevStage.perl-for-stdenv-shell;
#         p7zip-static = prevStage.p7zip-static;
#         curl = prevStage.curl-static;
        };
      };
    in cc-wrapper;
  })


  (prevStage: {
    inherit config overlays;
    stdenv = import ../generic {
      name = "stdenv-windows-boot-3";
      inherit config;

      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform initialPath shell;
      cc = prevStage.cc;
      fetchurlBoot = prevStage.fetchurl;
    };
  })

]
