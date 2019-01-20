# https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk

{ stdenvNoCC, buildPackages }:

let
  inherit (stdenvNoCC) lib;
# host   = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.  hostPlatform.config};
# target = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.targetPlatform.config};

  msblobs = (import ./ewdk-1809-blobs.nix { inherit stdenvNoCC; });
  inherit (msblobs) redist sdk msbuild msvc ewdk vc;

  makeWrapper =
    if buildPackages != null then
      buildPackages.makeWrapper
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
    name = "${ewdk.name}-${stdenvNoCC.buildPlatform.parsed.cpu.name}+${stdenvNoCC.hostPlatform.parsed.cpu.name}+${stdenvNoCC.targetPlatform.parsed.cpu.name}";
    buildInputs = [ ewdk ];
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
                , '--prefix', 'PATH',               ';', '${msvc.PATH};${sdk.PATH};${msbuild.PATH}'
                , '--suffix', 'INCLUDE',            ';', '${msvc.INCLUDE};${sdk.INCLUDE}'
                , '--suffix', 'LIB',                ';', '${msvc.LIB};${sdk.LIB}'
                , '--suffix', 'LIBPATH',            ';', '${msvc.LIBPATH};${sdk.LIBPATH}'
                , '--suffix', 'WindowsLibPath',     ';', '${sdk}/UnionMetadata/${sdk.version};${sdk}/References/${sdk.version}'
                , '--set',    'WindowsSDKLibVersion',    '${sdk.version}'
                , '--set',    'WindowsSDKVersion',       '${sdk.version}'
                , '--set',    'WindowsSdkVerBinPath',    '${sdk}/bin/${sdk.version}/'
                , '--set',    'WindowsSdkBinPath',       '${sdk}/bin/'
                , '--set',    'WindowsSdkDir',           '${sdk}/'
                , '--set',    'VCToolsVersion',          '${msvc.version}'
                , '--set',    'VCToolsInstallDir',       '${msvc}/'
                , '--set',    'VCToolsRedistDir',        '${msvc}/'
                , '--set',    'VCTargetsPath',           '${vc}/VCTargets/'
                , '--set',    'UCRTVersion',             '${sdk.version}'
                , '--set',    'UniversalCRTSdkDir',      '${sdk}/'
                # EWDK-specific (as there is DisableRegistryUse and no patch of *.props and *.tatgets; TODO: do the same for msvc2017)
                , '--set',    'EnterpriseWDK',           'True'
                , '--set',    'DisableRegistryUse',      'True'
                , '--set',    'SpectreMitigation',       'False'
                , '--set',    'WindowsSdkDir_10',        '${sdk}/'
               #, '--set',    'VCInstallDir',            '${msvc}/../../../'
               #, '--set',    'VCInstallDir_150',        '${msvc}/../../../'
                , '--set',    'VCToolsInstallDir_150',   '${msvc}/'
                , '--set',    'UCRTContentRoot',         '${sdk}/'
                , '--set',    'UniversalCRTSdkDir_10',   '${sdk}/'
                , '--set',    'WSKContentRoot',          '${sdk}/'
                , '--set',    'WDKContentRoot',          '${sdk}/'
                , '--set',    'WDK_CURRENT_KIT_VERSION', '10'
                ) == 0 or die "makeWrapper failed: $!";
        } else {
          print "no target $name.exe on PATH\n";
        }
      }

      # for those who want to deal with (execute or even parse) vcvarsall.bat (chromium, boost, ...)
      writeFile("$ENV{out}/VC/vcvarsall.bat",
                   ('PATH'                    ."=${msvc.PATH};${sdk.PATH};${msbuild.PATH};%PATH%\n".
                'set INCLUDE'                 ."=%INCLUDE%;${msvc.INCLUDE};${sdk.INCLUDE}\n".
                'set LIB'                     ."=%LIB%;${msvc.LIB};${sdk.LIB}\n".
                'set LIBPATH'                 ."=%LIBPATH%;${msvc.LIBPATH};${sdk.LIBPATH}\n".
                'set WindowsLibPath'          ."=${sdk}/UnionMetadata/${sdk.version};${sdk}/References/${sdk.version}\n".
                'set WindowsSDKLibVersion'    ."=${sdk.version}\n".
                'set WindowsSDKVersion'       ."=${sdk.version}\n".
                'set WindowsSdkVerBinPath'    ."=${sdk}/bin/${sdk.version}/\n".
                'set WindowsSdkBinPath'       ."=${sdk}/bin/\n".
                'set WindowsSdkDir'           ."=${sdk}/\n".
                'set VCToolsVersion'          ."=${msvc.version}\n".
                'set VCToolsInstallDir'       ."=${msvc}/\n".
                'set VCToolsRedistDir'        ."=${msvc}/\n".
                'set VCTargetsPath'           ."=${vc}/VCTargets/\n".
                'set UCRTVersion'             ."=${sdk.version}\n".
                'set UniversalCRTSdkDir'      ."=${sdk}/\n".
                # EWDK-specific (as there is DisableRegistryUse and no patch of *.props and *.tatgets; TODO: do the same for msvc2017)
                'set EnterpriseWDK'           ."=True\n".
                'set DisableRegistryUse'      ."=True\n".
                'set SpectreMitigation'       ."=False\n".
               #'set VCInstallDir'            ."=${msvc}/../../../\n".
               #'set VCInstallDir_150'        ."=${msvc}/../../../\n".
                'set VCToolsInstallDir_150'   ."=${msvc}/\n".
                'set WindowsSdkDir_10'        ."=${sdk}/\n".
                'set UCRTContentRoot'         ."=${sdk}/\n".
                'set UniversalCRTSdkDir_10'   ."=${sdk}/\n".
                'set WSKContentRoot'          ."=${sdk}/\n".
                'set WDKContentRoot'          ."=${sdk}/\n".
                'set WDK_CURRENT_KIT_VERSION' ."=10\n"
               ) =~ s|/|\\|gr);

      # make symlinks to help chromium builder which expects a particular directory structure (todo: move to chromium.nix)
      uncsymlink('${ewdk}/Program Files/Microsoft Visual Studio/2017/BuildTools/DIA SDK' => "$ENV{out}/DIA SDK"                      ) or die $!;
      uncsymlink('${msvc}'                                                               => "$ENV{out}/VC/Tools/MSVC/${msvc.version}") or die $!;
    '';

    passthru = {
      targetPrefix = "";
      isClang = false;
      isGNU = false;
      inherit msvc redist sdk msbuild /*vc*/ ewdk;
      INCLUDE = "${msvc.INCLUDE};${sdk.INCLUDE}";  # TODO: a hook should set them
      LIB     = "${msvc.LIB};${sdk.LIB}";
      PATH    = "${msvc.PATH};${sdk.PATH}";
      LIBPATH = "${msvc.LIBPATH};${sdk.LIBPATH}";
    };
  }
