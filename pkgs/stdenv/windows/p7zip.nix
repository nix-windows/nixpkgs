{ stdenvNoCC }:

let
  exe = stdenvNoCC.fetchurlBoot {
    url    = "https://github.com/volth/nixpkgs/releases/download/windows-0.4/7z.exe"; # ${pkgs.p7zip}/bin/7z.exe
    sha256 = "15jp6s2plpbfrh97pm1l8cq42s3s8wi9zckrcha1b5yp4f2yj1h0";
  };
  dll = stdenvNoCC.fetchurlBoot {
    url    = "https://github.com/volth/nixpkgs/releases/download/windows-0.4/7z.dll"; # ${pkgs.p7zip}/bin/7z.dll
    sha256 = "17m0a800pv45nn1djw35c6n3q99y2k5b0dldd1daxa00hlbbc02c";
  };
in if stdenvNoCC.isShellCmdExe then
  stdenvNoCC.mkDerivation {
    name    = "7z-19.00";
    builder = stdenvNoCC.lib.concatStringsSep " & " [
      ''md %out%\bin''
      ''copy ${stdenvNoCC.lib.replaceStrings ["/"] ["\\"] "${exe}"} %out%\bin\7z.exe''
      ''copy ${stdenvNoCC.lib.replaceStrings ["/"] ["\\"] "${dll}"} %out%\bin\7z.dll''
    ];
  }
else if stdenvNoCC.isShellPerl then
  stdenvNoCC.mkDerivation {
    name    = "7z-19.00";
    buildCommand = ''
      make_pathL("$ENV{out}/bin");
      copyL('${exe}' => "$ENV{out}/bin/7z.exe");
      copyL('${dll}' => "$ENV{out}/bin/7z.dll");
    '';
  }
else throw "stdenvNoCC.shell=${stdenvNoCC.shell}"
