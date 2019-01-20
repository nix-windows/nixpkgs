# https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk

{ stdenvNoCC }:

let
# host   = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.  hostPlatform.config};
# target = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.targetPlatform.config};
in rec {
  ewdk1809-iso = import <nix/fetchurl.nix> {
    name = "ewdk1809.iso";
#   url = "https://software-download.microsoft.com/download/pr/EWDK_rs5_release_17763_180914-1434.iso";
    url = "file://C:/Users/User/Downloads/EWDK_rs5_release_17763_180914-1434.iso";
    sha256 = "15hz222saddhbzvcf3yl8warv8rkp8j8zpxs1a1lr0hy0fvxkp4a";
  };

  p7zip-i686 = import ../../../stdenv/windows/p7zip.nix { inherit stdenvNoCC; };

  ewdk = derivation {
    name = "ewdk1809";
    system = builtins.currentSystem;
    builder = builtins.getEnv "COMSPEC";
    args = ["/c" ''${p7zip-i686}\bin\7z.exe x -o%out% ${ewdk1809-iso}''];

    outputHashAlgo = "sha256";
    outputHash = "00009f87ba503f3dfad96266ca79de7bfe3092dc6a58c0fe0438f7d4b19f0bbd";
    outputHashMode = "recursive";
  };
}
