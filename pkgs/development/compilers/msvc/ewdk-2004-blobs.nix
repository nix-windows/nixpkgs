{ stdenvNoCC }:

let
  host   = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.  hostPlatform.config};
  target = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.targetPlatform.config};

  # EWDK for Windows 10, version 2004 with Visual Studio Build Tools 16.3
  ewdk2004-iso = import <nix/fetchurl.nix> {
    name = "ewdk2004.iso";
    # https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk
    url = "https://software-download.microsoft.com/download/pr/EWDK_vb_release_19041_191206-1406.iso";
    sha256 = "0zp69c00xigmp2x90c9962qqimfxrx3zybq9wdm7pqi013bxq3r3";
  };

  p7zip-i686 = import ../../../stdenv/windows/p7zip.nix { inherit stdenvNoCC; };
in rec {
  ewdk = derivation {
    name = "ewdk2004";
    system = builtins.currentSystem;
    builder = builtins.getEnv "COMSPEC";
    args = ["/c" ''${p7zip-i686}\bin\7z.exe x -o%out% ${ewdk2004-iso}''];

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "12yk6p52zskabmzp2iq96gm2z4h28njw1zkgmnas64vrzf5sy9qh";
  };

  msvc   .version = "14.23.28105"; # cl.exe reports as 19.23.28105.4, link.exe and lib.exe are more honest
  msvc   .outPath = "${ewdk}/Program Files/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/${msvc.version}";
  sdk    .version = "10.0.19041.0";
  sdk    .outPath = "${ewdk}/Program Files/Windows Kits/10";
  msbuild.version = "16.3.0+0f4c62fea";
  msbuild.outPath = "${ewdk}/Program Files/Microsoft Visual Studio/2019/BuildTools/MSBuild";
  vc     .outPath = "${ewdk}/Program Files/Microsoft Visual Studio/2019/BuildTools/Common7/IDE/VC";

  msvc   .INCLUDE = "${msvc}/include;${msvc}/atlmfc/include";
  msvc   .LIB     = "${msvc}/lib/${target};${msvc}/atlmfc/lib/${target}";
  msvc   .LIBPATH = "${msvc}/lib/${target};${msvc}/atlmfc/lib/${target};${msvc}/lib/x86/store/references";
  msvc   .PATH    = "${msvc}/bin/Host${host}/${target};${msvc}/bin/Host${host}/${host}";
  msvc   .CLEXE   = "${msvc}/bin/Host${host}/${target}/cl.exe";
  sdk    .INCLUDE = "${sdk}/include/${sdk.version}/ucrt;${sdk}/include/${sdk.version}/shared;${sdk}/include/${sdk.version}/um;${sdk}/include/${sdk.version}/winrt;${sdk}/include/${sdk.version}/cppwinrt";
  sdk    .LIB     = "${sdk}/lib/${sdk.version}/ucrt/${target};${sdk}/lib/${sdk.version}/um/${target}";
  sdk    .LIBPATH = "${sdk}/UnionMetadata/${sdk.version};${sdk}/References/${sdk.version}";
  sdk    .PATH    = "${sdk}/bin/${sdk.version}/${host};${sdk}/bin/${host}";
  msbuild.PATH    = "${msbuild}/${msbuild.version}/bin/Roslyn;${msbuild}/${msbuild.version}/bin";

  redist = stdenvNoCC.mkDerivation rec {
    version = "14.23.27820";
    name = "redist-${redist.version}";
    buildCommand = ''
      dircopy("${ewdk}/Program Files/Microsoft Visual Studio/2019/BuildTools/VC/Redist/MSVC/${version}/x86",                 "$ENV{out}/x86"                             ) or die "$!";
      dircopy("${ewdk}/Program Files/Microsoft Visual Studio/2019/BuildTools/VC/Redist/MSVC/${version}/x64",                 "$ENV{out}/x64"                             ) or die "$!";
      dircopy("${ewdk}/Program Files/Microsoft Visual Studio/2019/BuildTools/VC/Redist/MSVC/${version}/debug_nonredist/x86", "$ENV{out}/x86"                             ) or die "$!";
      dircopy("${ewdk}/Program Files/Microsoft Visual Studio/2019/BuildTools/VC/Redist/MSVC/${version}/debug_nonredist/x64", "$ENV{out}/x64"                             ) or die "$!";
      # ucrtbased.dll
      dircopy("${ewdk}/Program Files/Windows Kits/10/bin/${sdk.version}/x86/ucrt",                                           "$ENV{out}/x86/Microsoft.UniversalCRT.Debug") or die "$!";
      dircopy("${ewdk}/Program Files/Windows Kits/10/bin/${sdk.version}/x64/ucrt",                                           "$ENV{out}/x64/Microsoft.UniversalCRT.Debug") or die "$!";
      # ucrtbase.dll and api-*.dll
      dircopy("${ewdk}/Program Files/Windows Kits/10/Redist/${sdk.version}/ucrt/DLLs/x86",                                   "$ENV{out}/x86/Microsoft.UniversalCRT"      ) or die "$!";
      dircopy("${ewdk}/Program Files/Windows Kits/10/Redist/${sdk.version}/ucrt/DLLs/x64",                                   "$ENV{out}/x64/Microsoft.UniversalCRT"      ) or die "$!";
    '';
  };
}
