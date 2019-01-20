{ stdenvNoCC }:

let
  host   = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.  hostPlatform.config};
  target = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenvNoCC.targetPlatform.config};
in rec {
  msvc = (import <nix/fetchurl.nix> {
    name = "msvc-${msvc.version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/msvc-${msvc.version}.nar.xz";
    unpack = true;
    sha256 = "2c3307db0c7f9b6f2a93f147da22960440aec9070a8916dfac7d5651b0e700da";
  }) // {
    version = "14.16.27023";
    INCLUDE = "${msvc}/include;${msvc}/atlmfc/include";
    LIB     = "${msvc}/lib/${target};${msvc}/atlmfc/lib/${target}";
    LIBPATH = "${msvc}/lib/${target};${msvc}/atlmfc/lib/${target};${msvc}/lib/x86/store/references";
    PATH    = "${msvc}/bin/Host${host}/${target};${msvc}/bin/Host${host}/${host}";
    CLEXE   = "${msvc}/bin/Host${host}/${target}/cl.exe";
  };

  redist = (import <nix/fetchurl.nix> {
    name = "redist-${redist.version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/redist-${redist.version}.nar.xz";
    unpack = true;
    sha256 = "3b2027f80fb32ddc8896ae0350064e2abda085c65a4ef807d3892f2c928ae339";
  }) // {
    version = "14.16.27012";
  };

# # Windows XP
# sdk_7_1 = throw "todo: SDK 7.1";
#
# # Windows 7 (it has no UCRT (<stdio.h> etc) so is not usable yet)
# sdk_8_1 = (import <nix/fetchurl.nix> {
#   name = "sdk-${sdk_8_1.version}";
#   url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/sdk-${sdk_8_1.version}.nar.xz";
#   unpack = true;
#   sha256 = "d1299b8399ad22fdb2303ca38f2a51fea5b94577b0de8bd7c238291c8d76d877";
# }) // {
#   version = "8.1";
#   INCLUDE = "${sdk_8_1}/include/shared;${sdk_8_1}/include/um;${sdk_8_1}/include/winrt";
#   LIB     = "${sdk_8_1}/Lib/winv6.3/um";
#   LIBPATH = "";
#   PATH    = "${sdk_8_1}/bin/x64";
# };

  # Windows 10
  sdk = /*let
    sdk =*/ import <nix/fetchurl.nix> {
      name = "sdk-${sdk.version}";
      url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/sdk-${sdk.version}.nar.xz";
      unpack = true;
      sha256 = "ae43ffd01f53bef2ef6f2056dd87da30e46f02fdbcd2719dc382292106279369";
    } // {
      version = "10.0.17763.0";
#    };
#  in sdk // {
    INCLUDE = "${sdk}/include/${sdk.version}/ucrt;${sdk}/include/${sdk.version}/shared;${sdk}/include/${sdk.version}/um;${sdk}/include/${sdk.version}/winrt;${sdk}/include/${sdk.version}/cppwinrt";
    LIB     = "${sdk}/lib/${sdk.version}/ucrt/${target};${sdk}/lib/${sdk.version}/um/${target}";
    LIBPATH = "${sdk}/UnionMetadata/${sdk.version};${sdk}/References/${sdk.version}";
    PATH    = "${sdk}/bin/${sdk.version}/${host};${sdk}/bin/${host}";
  };

  msbuild = (import <nix/fetchurl.nix> {
    name = "msbuild-${msbuild.version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/msbuild-${msbuild.version}.nar.xz";
    unpack = true;
    sha256 = "032e6343d55762df6d5c9650d10e125946b7b8e85cc32e126b10b89a7be338ba";
  }) // {
    version = "15.0";
    PATH    = "${msbuild}/${msbuild.version}/bin/Roslyn;${msbuild}/${msbuild.version}/bin";
  };

  vc1 = import <nix/fetchurl.nix> {
    name = "vc1-${msbuild.version}";
    url = "https://github.com/volth/nixpkgs/releases/download/windows-0.3/vc1-${msbuild.version}.nar.xz";
    unpack = true;
    sha256 = "0d861aeb29a9d88746a70c9d89007639c7d9107cfba8fa1139f68ee21ddf744b";
  };
}
