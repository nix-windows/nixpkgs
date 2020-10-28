# https://wasm.in/threads/kollekcija-platform-sdk.17874/

{ stdenvNoCC, lib, buildPackages }:

let
# inherit (stdenvNoCC) lib;

  msblobs = (import ./msvc-2005-blobs.nix { inherit stdenvNoCC; });
  inherit (msblobs) msvc sdk;

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
          print($ENV{PATH});
          system('cl', '/O2', '/MT', '/EHsc',
                 "/Fe$ENV{out}\\bin\\makeWrapper.exe",
                 '${lib.escapeWindowsArg "/DINCLUDE=${INCLUDE}"}',
                 '${lib.escapeWindowsArg "/DLIB=${LIB}"}',
                 '${lib.escapeWindowsArg "/DCC=${(msvc).CLEXE}"}',
                 '${./makeWrapper.cpp}');
        '';
      }
    else throw "???";
in
  stdenvNoCC.mkDerivation {
    name = "${msvc.name}-${sdk.name}-${stdenvNoCC.buildPlatform.parsed.cpu.name}+${stdenvNoCC.hostPlatform.parsed.cpu.name}+${stdenvNoCC.targetPlatform.parsed.cpu.name}";
    buildInputs = [ msvc sdk ];
    buildCommand = ''
      make_pathL("$ENV{out}/bin") or die "make_pathL: $!";

      for my $name ('cl', 'ml', 'ml64', 'lib', 'link', 'nmake', 'mc', 'mt', 'rc', 'dumpbin', 'editbin', 'csc', 'msbuild') {
        my $target;
        for my $path (split /;/, '${msvc.PATH};${sdk.PATH}') {
          die unless $path;
          if (-f "$path/$name.exe") {
            $target = "$path/$name.exe";
            last;
          }
        }
        if ($target) {
          print("wrapping $target\n");
          system( "${makeWrapper}/bin/makeWrapper.exe", $target, "$ENV{out}/bin/$name.exe"
                , '--prefix', 'PATH',               ';', '${msvc.PATH};${sdk.PATH}'
                , '--suffix', 'INCLUDE',            ';', '${msvc.INCLUDE};${sdk.INCLUDE}'
                , '--suffix', 'LIB',                ';', '${msvc.LIB};${sdk.LIB}'
                ) == 0 or die "makeWrapper failed: $!";
        } else {
          print "no target $name.exe on PATH\n";
        }
      }

      # for those who want to deal with (execute or even parse) vcvarsall.bat (chromium, boost, ...)
      writeFile("$ENV{out}/VC/vcvarsall.bat",
                   ('PATH'                    ."=${msvc.PATH};${sdk.PATH};%PATH%\n".
                'set INCLUDE'                 ."=%INCLUDE%;${msvc.INCLUDE};${sdk.INCLUDE}\n".
                'set LIB'                     ."=%LIB%;${msvc.LIB};${sdk.LIB}\n"
                   ) =~ s|/|\\|gr);
    '';

    passthru = {
      isMSVC  = true;
      isClang = false;
      isGNU   = false;
      inherit msvc sdk;# redist msbuild ewdk
      INCLUDE = "${msvc.INCLUDE};${sdk.INCLUDE}";  # TODO: a hook should set them
      LIB     = "${msvc.LIB};${sdk.LIB}";
      PATH    = "${msvc.PATH};${sdk.PATH}";
    };
  }
