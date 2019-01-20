{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "processhacker-2019-01-16";

  src = fetchFromGitHub {
    owner  = "processhacker";
    repo   = "processhacker";
    rev    = "12098ac7a7c1c6c56ac2a6f6bdbb21d9ea0581f7";
    sha256 = "1ysw71gaivwn2b29is1zppv29lhnh4nfgqimcjzj3fcw2vbpj4g1";
  };

  postPatch = ''
    writeFile('build\build_sdk.cmd', ""); # it wants COM object 177F0C4A-1CD3-4DE7-A32C-71DBBB9FA36D
  '';

  buildPhase = ''
    system('msbuild ProcessHacker.sln                 /p:Configuration=Release /p:Platform=${if stdenv.is64bit then "x64" else "Win32"}') == 0 or die;
    system('msbuild kProcessHacker\kProcessHacker.sln /p:Configuration=Release /p:Platform=${if stdenv.is64bit then "x64" else "Win32"}') == 0 or die;
  '';

  installPhase = ''
    make_pathL("$ENV{out}/bin");
    copyL('bin/Release${if stdenv.is64bit then "64" else "32"}/ProcessHacker.exe',                 "$ENV{out}/bin/ProcessHacker.exe" ) or die;
    copyL('bin/Release${if stdenv.is64bit then "64" else "32"}/peview.exe',                        "$ENV{out}/bin/peview.exe"        ) or die;
    copyL('KProcessHacker/bin/Release${if stdenv.is64bit then "64" else "32"}/kprocesshacker.sys', "$ENV{out}/bin/kprocesshacker.sys") or die;
  '';

  meta.platforms = [ "x86_64-windows" "i686-windows" ];
}
