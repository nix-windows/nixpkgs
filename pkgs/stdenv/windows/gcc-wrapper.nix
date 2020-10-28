# https://wasm.in/threads/kollekcija-platform-sdk.17874/

{ stdenvNoCC, lib, /*buildPackages,*/ msysPacman, mingwPacman }:

let
  makeWrapper =
    assert stdenvNoCC.isShellPerl;
    stdenvNoCC.mkDerivation rec {
      name         = "makeWrapper";
      PATH         = "${mingwPacman.gcc}/mingw${if stdenvNoCC.is64bit then "64" else "32"}/bin"; # for cc1plus.exe to find dlls
      buildCommand = ''
        make_pathL("$ENV{out}/bin") or die $!;
        print("PATH=$ENV{PATH}\n");
        system('c++.exe',
               '-static',
               '-o', "$ENV{out}/bin/makeWrapper.exe",
               '-municode',
               '-Wl,-subsystem:console',
               '${lib.escapeWindowsArg "-DPATH=${PATH}"}',        # for cc1plus.exe to find dlls
               '${lib.escapeWindowsArg "-DCC=${PATH}/c++.exe"}',
               '${../../development/compilers/msvc/makeWrapper.cpp}');

      '';
    };
in
  stdenvNoCC.mkDerivation {
    name = "gcc-wrapper-${stdenvNoCC.buildPlatform.parsed.cpu.name}+${stdenvNoCC.hostPlatform.parsed.cpu.name}+${stdenvNoCC.targetPlatform.parsed.cpu.name}";
    buildCommand = ''
      make_pathL("$ENV{out}/bin") or die "make_pathL: $!";

      for my $name ('cc', 'gcc', 'c++', 'ld', 'cpp', 'nm', 'as', 'ar', 'make') {
        my $target;
        for my $path ('${mingwPacman.gcc }/mingw${if stdenvNoCC.is64bit then "64" else "32"}/bin',
                      '${mingwPacman.make}/mingw${if stdenvNoCC.is64bit then "64" else "32"}/bin') {
          die unless $path;
          if (-f "$path/$name.exe") {
            $target = "$path/$name.exe";
            last;
          }
        }
        if ($target) {
          print("wrapping $target\n");
          system( "${makeWrapper}/bin/makeWrapper.exe", $target, "$ENV{out}/bin/$name.exe"
                , '--prefix', 'PATH',               ';', '${mingwPacman.gcc}/mingw${if stdenvNoCC.is64bit then "64" else "32"}/bin'                               # for cc1plus.exe to find dlls
              # , '--suffix', 'INCLUDE',            ';', '${mingwPacman.gcc}/mingw${if stdenvNoCC.is64bit then "64/x86_64" else "32/i686"}-w64-mingw32/include'   # needless?
              # , '--suffix', 'LIB',                ';', '${mingwPacman.gcc}/mingw${if stdenvNoCC.is64bit then "64/x86_64" else "32/i686"}-w64-mingw32/lib'       # needless?
                ) == 0 or die "makeWrapper failed: $!";
        } else {
          print "no target $name.exe on PATH\n";
        }
      }
    '';

    passthru = {
      isMSVC  = false;
      isClang = false;
      isGNU   = true;
      cc = mingwPacman.gcc;
#     makeWrapper = makeWrapper;
      redist = mingwPacman.gcc; # TODO: where `fixupPhase` hook will find runtimes dlls
#     INCLUDE = "${mingwPacman.gcc}/mingw${if stdenvNoCC.is64bit then "64/x86_64" else "32/i686"}-w64-mingw32/include";
#     LIB     = "${mingwPacman.gcc}/mingw${if stdenvNoCC.is64bit then "64/x86_64" else "32/i686"}-w64-mingw32/lib";
#     PATH    = "${mingwPacman.gcc}/mingw${if stdenvNoCC.is64bit then "64" else "32"}/bin";
    };
  }
