{ stdenvNoCC, buildPackages }:

assert stdenvNoCC.isShellPerl;
let
  inherit (stdenvNoCC) lib;
  msblobs = (import ./msvc-2017-blobs.nix { inherit stdenvNoCC; });
  inherit (msblobs) redist sdk msbuild vc1;

  msvc = if false then
    # kind of sandbox:
    # remove compilers irrelevant to the (stdenvNoCC.hostPlatform, stdenvNoCC.targetPlatform) pair
    # otherwise msbuild can always cross-compile .vcxproj files, even on non-cross `stdenv` (check x96dbg.exe of pkgs.x64dbg)
    # perhaps it is desirable but let turn it off for a while
    stdenvNoCC.mkDerivation {
      name = "${msblobs.msvc.name}-${stdenvNoCC.hostPlatform.parsed.cpu.name}+${stdenvNoCC.targetPlatform.parsed.cpu.name}";
      phases = ["installPhase"];
      installPhase = let
        host   = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.  hostPlatform.config};
        target = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.targetPlatform.config};
      in ''
        dircopy('${msblobs.msvc}', $ENV{out});
        for my $binpath ("$ENV{out}/bin/HostX86/x86", "$ENV{out}/bin/HostX64/x86", "$ENV{out}/bin/HostX86/x64", "$ENV{out}/bin/HostX64/x64") {
          next if lc($binpath) eq lc("$ENV{out}/bin/Host${host}/${target}");
          for my $name ("cl.exe", "lib.exe", "link.exe") {
            attribL('-r', "$binpath/$name") or die "attribL $binpath/$name: $!";
            unlinkL(      "$binpath/$name") or die "unlinkL $binpath/$name: $!";
          }
        }
      '';
      passthru = { inherit (msblobs.msvc) PATH INCLUDE LIB LIBPATH CLEXE version; };
    }
  else
    msblobs.msvc;

  # this has references to nix store, depends on nix store location and might have problems being fixed-output derivation
  vc = stdenvNoCC.mkDerivation {
    name = "vc-${msbuild.version}";
    buildInputs = [ vc1 ];
    buildCommand = ''
      #
      dircopy("${vc1}", $ENV{out}) or die "dircopy(${vc1}, $ENV{out}): $!";

      for my $filename (glob("$ENV{out}/VCTargets/*.props"), glob("$ENV{out}/VCTargets/*.targets")) {
        changeFile {
          s|>(\$\(Registry:HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows Kits\\Installed Roots\@KitsRoot10\))|>${sdk}/<!-- $1 -->|g;
          s|>(\$\(Registry:HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v10.0\@InstallationFolder\))|>${sdk}/<!-- $1 -->|g;
          s|\$\(VCToolsInstallDir_150\)|${msvc}/|g;
          s|>(\$\(Registry:[^)]+\))|><!-- $1 -->|g;
          $_;
        } $filename;
      }
    '';
  };

  makeWrapper =
    if buildPackages != null then
      buildPackages.makeWrapper
#   else if stdenvNoCC.isShellCmdExe then # TODO: no need?
#     stdenvNoCC.mkDerivation rec {
#       name         = "makeWrapper";
#       INCLUDE      = "${(msvc).INCLUDE};${(sdk).INCLUDE}";
#       LIB          = "${(msvc).LIB};${(sdk).LIB}";
#       PATH         = "${(msvc).PATH};${(sdk).PATH}";
#       builder      = lib.concatStringsSep " & " [ ''md %out%\bin''
#                                                   ''cl /O2 /MT /EHsc /Fe:%out%\bin\makeWrapper.exe /DINCLUDE=${INCLUDE} /DLIB=${LIB} /DCC=${(msvc).CLEXE} ${./makeWrapper.cpp}'' ];
#     }
    else if stdenvNoCC.isShellPerl then
      stdenvNoCC.mkDerivation rec {
        name         = "makeWrapper";
        INCLUDE      = "${(msvc).INCLUDE};${(sdk).INCLUDE}";
        LIB          = "${(msvc).LIB};${(sdk).LIB}";
        PATH         = "${(msvc).PATH};${(sdk).PATH}";
        buildCommand = ''
          make_pathL("$ENV{out}/bin") or die $!;
          system('cl', '/O2', '/MT', '/EHsc',
                 "/Fe:$ENV{out}\\bin\\makeWrapper.exe",
                 '${lib.escapeWindowsArg "/DINCLUDE=${INCLUDE}"}',
                 '${lib.escapeWindowsArg "/DLIB=${LIB}"}',
                 '${lib.escapeWindowsArg "/DCC=${(msvc).CLEXE}"}',
                 '${./makeWrapper.cpp}') == 0 or die;
        '';
      }
    else throw "???";
in
  stdenvNoCC.mkDerivation {
    name = "${msvc.name}+${sdk.name}+${msbuild.name}-${stdenvNoCC.buildPlatform.parsed.cpu.name}+${stdenvNoCC.hostPlatform.parsed.cpu.name}+${stdenvNoCC.targetPlatform.parsed.cpu.name}";
    buildInputs = [ msvc sdk msbuild vc ];
    buildCommand = ''
      make_pathL("$ENV{out}/bin", "$ENV{out}/VC/Tools/MSVC") or die "make_pathL: $!";

      for my $name ('cl', 'ml', 'ml64', 'lib', 'link', 'nmake', 'mc', 'mt', 'rc', 'dumpbin', 'editbin', 'csc', 'msbuild') {
        my $target;
        for my $path (split /;/, '${msvc.PATH};${sdk.PATH};${msbuild.PATH}') {
          die unless $path;
          if (-f "$path/$name.exe") {
            $target = "$path/$name.exe";
            last;
          }
        }
        if ($target) {
          system( "${makeWrapper}/bin/makeWrapper.exe", $target, "$ENV{out}/bin/$name.exe"
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
        } else {
          print "no target $name.exe on PATH\n";
        }
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
      INCLUDE = "${msvc.INCLUDE};${sdk.INCLUDE}";  # TODO: a hook should set them
      LIB     = "${msvc.LIB};${sdk.LIB}";
      PATH    = "${msvc.PATH};${sdk.PATH}";
      LIBPATH = "${msvc.LIBPATH};${sdk.LIBPATH}";
    };
  }
