{ stdenvNoCC }:

let
# 7z.{exe,dll} from https://github.com/mcmilk/7-Zip-zstd/releases/download/19.00-v1.4.5-R3/7z19.00-zstd-x32.exe work too, but it is a GUI SFX erchive
# exe = C:/work/nix-windows/7z/7z.exe;
# dll = C:/work/nix-windows/7z/7z.dll;
  exe = stdenvNoCC.fetchurlBoot {
    url    = "https://github.com/volth/nixpkgs/releases/download/windows-0.4/7z.exe"; # ${pkgs.pkgsi686Windows.p7zip}/bin/7z.exe
    sha256 = "0iqrnfs4rs68v322hkg2sq4l8h1h84v9vy7p619ppb4c8q4y7asg";
  };
  dll = stdenvNoCC.fetchurlBoot {
    url    = "https://github.com/volth/nixpkgs/releases/download/windows-0.4/7z.dll"; # ${pkgs.pkgsi686Windows.p7zip}/bin/7z.dll
    sha256 = "0xkfxk7hsyflc11islj498f3cy84s4aacap4almklflm44xkafd0";
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
else throw "stdenvNoCC.shell=${stdenvNoCC.shell}"
