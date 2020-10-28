{ stdenv, lib, targetPackages }:

stdenv.mkDerivation rec {
  # pkgsCross.windows32.buildPackages.makeWrapper -> x86_64+x86_64+i686
  # pkgsCross.windows32.makeWrapper               -> x86_64+i686+i686
  # pkgsi686Windows.makeWrapper                   -> i686+i686+i686
  name         = "makeWrapper-${stdenv.buildPlatform.parsed.cpu.name}+${stdenv.hostPlatform.parsed.cpu.name}+${stdenv.targetPlatform.parsed.cpu.name}";
  buildCommand =
    if stdenv.isShellPerl && stdenv.cc.isMSVC && targetPackages.stdenv.cc.isMSVC then ''
      make_pathL("$ENV{out}/bin") or die $!;
      system('cl', '/O2', '/MT', '/EHsc',
             "/Fe$ENV{out}\\bin\\makeWrapper.exe",
             '${lib.escapeWindowsArg "/DINCLUDE=${targetPackages.stdenv.cc.INCLUDE}"}',
             '${lib.escapeWindowsArg "/DLIB=${targetPackages.stdenv.cc.LIB}"}',
             '${lib.escapeWindowsArg "/DCC=${targetPackages.stdenv.cc}/bin/cl.exe"}',
             '${./makeWrapper.cpp}') == 0 or die;
    '' else if stdenv.isShellPerl && stdenv.cc.isGNU && targetPackages.stdenv.cc.isGNU then ''
      make_pathL("$ENV{out}/bin") or die $!;
      system('c++',
             '-static',
             '-o', "$ENV{out}/bin/makeWrapper.exe",
             '-municode',
             '-Wl,-subsystem:console',
             '${lib.escapeWindowsArg "-DPATH=${targetPackages.stdenv.cc}/mingw${if targetPackages.stdenv.cc.is64bit then "64" else "32"}/bin"}', # for cc1plus.exe to find dlls
             '${lib.escapeWindowsArg "-DCC=${targetPackages.stdenv.cc}/mingw${if targetPackages.stdenv.cc.is64bit then "64" else "32"}/bin"}/bin/c++.exe"}',
             '${./makeWrapper.cpp}') == 0 or die;
    '' else throw "???";
  meta.platforms = lib.platforms.windows;
}
