{ lib
, localSystem, crossSystem, config, overlays
}:

assert crossSystem == null;

let
  msvc-version = "14.16.27023";
  sdk-version = "10.0.17134.0";
  msbuild-version = "15.0";

  msvc = import <nix/fetchurl.nix> {
    name = "msvc-14.16.27023";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.2/msvc-14.16.27023.nar.xz";
    unpack = true;
    outputHash = "7a38bb78963a97ff164330d2dc3dd936971e5aa07394afdd72aa9a92eeac8318";
  };

  sdk = import <nix/fetchurl.nix> {
    name = "sdk-10.0.17134.0";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.2/sdk-10.0.17134.0.nar.xz";
    unpack = true;
    sha256 = "48df3897cfd793eec97751c6d434b0878c306512cf83fd8c5d2d3d0b3f2b5325";
  };

  msbuild = import <nix/fetchurl.nix> {
    name = "msbuild-15.0";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.2/msbuild-15.0.nar.xz";
    unpack = true;
    outputHash = "45988cf191783ec9defb712d5e46121a882fa7cff3532a99dbfd4445e96d83a8";
  };

  vc1 = import <nix/fetchurl.nix> {
    name = "vc1-15.0";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.2/vc1-15.0.nar.xz";
    unpack = true;
    outputHash = "4ed6209890cd73bf701d65489dc54dddd75b988770cd68dee64ca93d24d45760";
  };

  msvc-INCLUDE = "${msvc}/include;${sdk}/include/${sdk-version}/ucrt;${sdk}/include/${sdk-version}/shared;${sdk}/include/${sdk-version}/um;${sdk}/include/${sdk-version}/winrt;${sdk}/include/${sdk-version}/cppwinrt";
  msvc-LIB     = "${msvc}/lib/x64;${sdk}/lib/${sdk-version}/ucrt/x64;${sdk}/lib/${sdk-version}/um/x64";
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

    # TODO: build from sources
    p7zip-static = stdenv.mkDerivation {
      name = "7z-18.05-static";
      src = fetchurlBoot {
       #url = "file://C:/Program%20Files/7-Zip/7z.exe";
        url = "https://github.com/volth/nixpkgs/releases/download/windows-0.2/7z.exe";
        sha256 = "1lzjk0pzc549hx6salnq04gkyb5zsngzzf6fv00nwxslzs1j8ij7";
      };
      builder = lib.concatStringsSep " & " [ ''md %out%\bin''
                                             ''copy %src% %out%\bin\7z.exe'' ];
    };

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
      # an useful lib not included by default
      perl-FileCopyRecursive-src = fetchurlBoot {
        url = "https://cpan.metacpan.org/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.44.tar.gz";
        sha256 = "1r3frbl61kr7ig9bzd60fka772cd504v3kx9kgnwvcy1inss06df";
      };
    in stdenv.mkDerivation rec {
      name = "perl-5.28.1";
      src = fetchurlBoot {
        url = "https://www.cpan.org/src/5.0/${name}.tar.gz";
        sha256 = "0iy3as4hnbjfyws4in3j9d6zhhjxgl5m95i5n9jy2bnzcpz8bgry";
      };
      INCLUDE = msvc-INCLUDE;
      LIB     = msvc-LIB;
      PATH    = "${msvc-PATH};${p7zip-static}/bin";
      builder = lib.concatStringsSep " & " [ ''7z x %src% -so                          |  7z x -aoa -si -ttar''
                                             ''7z x ${perl-FileCopyRecursive-src} -so  |  7z x -aoa -si -ttar -o${name}\ext''
                                             ''cd ${name}\win32''
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
          make_path("$ENV{out}/bin") or die "make_path $ENV{out}/bin: $!";

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
