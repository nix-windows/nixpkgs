{ stdenv, targetPackages }:

assert stdenv.isShellPerl;

let
  inherit (stdenv) lib;
in
stdenv.mkDerivation rec {
  # pkgsCross.windows32.buildPackages.makeWrapper -> x86_64+x86_64+i686
  # pkgsCross.windows32.makeWrapper               -> x86_64+i686+i686
  # pkgsi686Windows.makeWrapper                   -> i686+i686+i686
  name         = "makeWrapper-${stdenv.buildPlatform.parsed.cpu.name}+${stdenv.hostPlatform.parsed.cpu.name}+${stdenv.targetPlatform.parsed.cpu.name}";
  buildCommand = ''
    make_pathL("$ENV{out}/bin") or die $!;
    system('cl', '/O2', '/MT', '/EHsc',
           "/Fe:$ENV{out}\\bin\\makeWrapper.exe",
           '${lib.escapeWindowsArg "/DINCLUDE=${targetPackages.stdenv.cc.INCLUDE}"}',
           '${lib.escapeWindowsArg "/DLIB=${targetPackages.stdenv.cc.LIB}"}',
           '${lib.escapeWindowsArg "/DCC=${targetPackages.stdenv.cc}/bin/cl.exe"}',
           '${./makeWrapper.cpp}') == 0 or die;
  '';
  meta.platforms = lib.platforms.windows;
}
