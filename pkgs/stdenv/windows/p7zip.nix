{ stdenvNoCC }:

let
# 7z.{exe,dll} from https://github.com/mcmilk/7-Zip-zstd/releases/download/19.00-v1.4.5-R3/7z19.00-zstd-x32.exe work too, but it is a GUI SFX erchive
# exe = C:/work/nix-windows/7z/7z.exe;
# dll = C:/work/nix-windows/7z/7z.dll;
  exe = stdenvNoCC.fetchurlBoot {
    url    = "https://github.com/volth/nixpkgs/releases/download/windows-0.5/7z.exe"; # "${pkgsMsvc2019.pkgsi686Windows.p7zip.override{winver=0x0501;}}/bin/7z.exe"
    sha256 = "1x594hdsfm9isf9dxzid99pdalij18ayrz1jqh4y6cgq7p82jr7b";
  };
  dll = stdenvNoCC.fetchurlBoot {
    url    = "https://github.com/volth/nixpkgs/releases/download/windows-0.5/7z.dll"; # "${pkgsMsvc2019.pkgsi686Windows.p7zip.override{winver=0x0501;}}/bin/7z.dll"
    sha256 = "1z4cpw2v8l0bkxsc8b14g5fw8aldqnym9md8rysxlq4vsqmjnapi";
  };
in if stdenvNoCC.isShellCmdExe then
  stdenvNoCC.mkDerivation {
    name    = "7z-19.00-i686";
    builder = stdenvNoCC.lib.concatStringsSep " & " [
      ''md %out%\bin''
      ''copy ${stdenvNoCC.lib.replaceStrings ["/"] ["\\"] "${exe}"} %out%\bin\7z.exe''
      ''copy ${stdenvNoCC.lib.replaceStrings ["/"] ["\\"] "${dll}"} %out%\bin\7z.dll''
    ];
  }
else if stdenvNoCC.isShellPerl then
  stdenvNoCC.mkDerivation {
    name    = "7z-19.00-i686";
    buildCommand = ''
      make_pathL("$ENV{out}/bin");
      copyL('${exe}' => "$ENV{out}/bin/7z.exe");
      copyL('${dll}' => "$ENV{out}/bin/7z.dll");
    '';
  }
else
  throw "stdenvNoCC.shell=${stdenvNoCC.shell}"
