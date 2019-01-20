{ stdenvNoCC }:

let
  host   = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.  hostPlatform.config};
  target = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.targetPlatform.config};

  ewdk1809-iso = import <nix/fetchurl.nix> {
    name = "ewdk1809.iso";
    # https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk
    url = "https://software-download.microsoft.com/download/pr/EWDK_rs5_release_17763_180914-1434.iso";
#   url = file://C:/Users/User/Downloads/EWDK_rs5_release_17763_180914-1434.iso;
    sha256 = "15hz222saddhbzvcf3yl8warv8rkp8j8zpxs1a1lr0hy0fvxkp4a";
  };

  p7zip-i686 = import ../../../stdenv/windows/p7zip.nix { inherit stdenvNoCC; };
in rec {
  ewdk = derivation {
    name = "ewdk1809";
    system = builtins.currentSystem;
    builder = builtins.getEnv "COMSPEC";
    args = ["/c" ''${p7zip-i686}\bin\7z.exe x -o%out% ${ewdk1809-iso}''];

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "0gyyv8sqwsfa2qg64nsfmd03lysmwpnavzc6yy60ha9nsgdmnhp3";
  };

  # exactly as in ./msvc-2017-blobs.nix
  msvc   .version = "14.15.26726";
  msvc   .outPath = "${ewdk}/Program Files/Microsoft Visual Studio/2017/BuildTools/VC/Tools/MSVC/${msvc.version}";
  sdk    .version = "10.0.17763.0";
  sdk    .outPath = "${ewdk}/Program Files/Windows Kits/10";
  msbuild.version = "15.0";
  msbuild.outPath = "${ewdk}/Program Files/Microsoft Visual Studio/2017/BuildTools/MSBuild";
  vc     .outPath = "${ewdk}/Program Files/Microsoft Visual Studio/2017/BuildTools/Common7/IDE/VC";

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

  # as in ./msvc-2017-make-blobs.bat
  redist = stdenvNoCC.mkDerivation rec {
    version = "14.15.26706";
    name = "redist-${redist.version}";
    buildCommand = ''
      dircopy("${ewdk}/Program Files/Microsoft Visual Studio/2017/BuildTools/VC/Redist/MSVC/${version}/x86",                 "$ENV{out}/x86"                             ) or die "$!";
      dircopy("${ewdk}/Program Files/Microsoft Visual Studio/2017/BuildTools/VC/Redist/MSVC/${version}/x64",                 "$ENV{out}/x64"                             ) or die "$!";
      dircopy("${ewdk}/Program Files/Microsoft Visual Studio/2017/BuildTools/VC/Redist/MSVC/${version}/debug_nonredist/x86", "$ENV{out}/x86"                             ) or die "$!";
      dircopy("${ewdk}/Program Files/Microsoft Visual Studio/2017/BuildTools/VC/Redist/MSVC/${version}/debug_nonredist/x64", "$ENV{out}/x64"                             ) or die "$!";
      # ucrtbased.dll
      dircopy("${ewdk}/Program Files/Windows Kits/10/bin/${sdk.version}/x86/ucrt",                                           "$ENV{out}/x86/Microsoft.UniversalCRT.Debug") or die "$!";
      dircopy("${ewdk}/Program Files/Windows Kits/10/bin/${sdk.version}/x64/ucrt",                                           "$ENV{out}/x64/Microsoft.UniversalCRT.Debug") or die "$!";
      # ucrtbase.dll and api-*.dll
      dircopy("${ewdk}/Program Files/Windows Kits/10/Redist/${sdk.version}/ucrt/DLLs/x86",                                   "$ENV{out}/x86/Microsoft.UniversalCRT"      ) or die "$!";
      dircopy("${ewdk}/Program Files/Windows Kits/10/Redist/${sdk.version}/ucrt/DLLs/x64",                                   "$ENV{out}/x64/Microsoft.UniversalCRT"      ) or die "$!";
    '';
  };
}
