{ stdenvNoCC }:

let
  exe = stdenvNoCC.fetchurlBoot {
    url    = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/7z.exe";
    sha256 = "1pk8fg65f02dh1ygdq6qgjic7w6w6lzfvvpp0zi8d8y4bfx0baik";
  };
  dll = stdenvNoCC.fetchurlBoot {
    url    = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/7z.dll";
    sha256 = "0m6x1p6lrnbhlihnn72ir3qqzssaj1gvzg63z5d8mv47a5n39csk";
  };
in if stdenvNoCC.isShellCmdExe then
  stdenvNoCC.mkDerivation {
    name    = "7z-18.06-i686";
    builder = stdenvNoCC.lib.concatStringsSep " & " [
      ''md %out%\bin''
      ''copy ${stdenvNoCC.lib.replaceStrings ["/"] ["\\"] "${exe}"} %out%\bin\7z.exe''
      ''copy ${stdenvNoCC.lib.replaceStrings ["/"] ["\\"] "${dll}"} %out%\bin\7z.dll''
    ];
  }
else if stdenvNoCC.isShellPerl then
  stdenvNoCC.mkDerivation {
    name    = "7z-18.06-i686";
    buildCommand = ''
      make_pathL("$ENV{out}/bin");
      copyL('${exe}' => "$ENV{out}/bin/7z.exe");
      copyL('${dll}' => "$ENV{out}/bin/7z.dll");
    '';
  }
else throw "stdenvNoCC.shell=${stdenvNoCC.shell}"
