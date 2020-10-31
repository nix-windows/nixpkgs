{ stdenvNoCC }:

let
# 7z.{exe,dll} from https://github.com/mcmilk/7-Zip-zstd/releases/download/19.00-v1.4.5-R3/7z19.00-zstd-x32.exe work too, but it is a GUI SFX erchive
# exe = C:/work/nix-windows/7z/7z.exe;
# dll = C:/work/nix-windows/7z/7z.dll;
  exe = stdenvNoCC.fetchurlBoot {
    url    = "https://github.com/volth/nixpkgs/releases/download/windows-0.5/7z.exe"; # "${pkgsMsvc2019.pkgsi686Windows.p7zip.override{supportWindowsXP=true;}}/bin/7z.exe"
    sha256 = "11bbcz77yv0iy0p0ldf3jmglzqvs92qprcnsm6ba2mkifl8k42fk";
  };
  dll = stdenvNoCC.fetchurlBoot {
    url    = "https://github.com/volth/nixpkgs/releases/download/windows-0.5/7z.dll"; # "${pkgsMsvc2019.pkgsi686Windows.p7zip.override{supportWindowsXP=true;}}/bin/7z.dll"
    sha256 = "1d7ni2i10xx2nrbc18ihr1a9yjg9ad98jz6bwaaj1lxkfrrn8828";
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
