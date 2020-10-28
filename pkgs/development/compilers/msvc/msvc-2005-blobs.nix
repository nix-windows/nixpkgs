{ stdenvNoCC }:

let
  # Visual C++ 2005 Express Edition
  vc-iso = import <nix/fetchurl.nix> {
    name = "vc.iso";
    url = "http://go.microsoft.com/fwlink/?linkid=57034";
    sha256 = "0icmzwiay5k990pdggk30cjwsd2nkzfcfa1qy9nyr52x53801rss";
  };

  # Visual C# 2005 Express Edition
  vcs-iso = import <nix/fetchurl.nix> {
    name = "vcs.iso";
    url = "http://go.microsoft.com/fwlink/?linkid=57035";
    sha256 = "0j2dzkj4cmyxlcw5j9q4kvnamza4ykl8na2qb3fvgij381fl6xh4";
  };

  masm8-setup = import <nix/fetchurl.nix> {
    name = "MASMsetup.exe";
    url = "https://download.microsoft.com/download/7/4/0/740977da-3ad4-46a1-ad41-92758be79b01/MASMsetup.EXE";
    sha256 = "0px34735sj0rcbvzjx31plfbvp01k3fj2apwnlq9ay3wsfl33sn0";
  };

  p7zip-i686 = import ../../../stdenv/windows/p7zip.nix { inherit stdenvNoCC; };
in rec {
  msvc = derivation {
    name = "msvc";
    system = builtins.currentSystem;
    builder = builtins.getEnv "COMSPEC";
    args = [ "/c"
             (stdenvNoCC.lib.concatStringsSep " & " [ ''${p7zip-i686}\bin\7z.exe x -o%out% ${ ./Microsoft_Visual_Studio_8.7z /* TODO: produce this from vc-iso */ }''
                                                      ''copy %out%\Common7\IDE\ms* %out%\VC\bin\''
                                                    # ''${p7zip-i686}\bin\7z.exe x ${ masm8-setup }''
                                                    # ''${p7zip-i686}\bin\7z.exe x setup.exe''
                                                    # ''${p7zip-i686}\bin\7z.exe x vc_masm1.cab''
                                                    # ''copy FL_ml_exe_____X86.3643236F_FC70_11D3_A536_0090278A1BB8 %out%\VC\bin\ml.exe''
                                                    ])
           ];
#   outputHashMode = "recursive";
#   outputHashAlgo = "sha256";
#   outputHash     = "178lwdbg1z8slbjly7d7m4m4j4irj5c2wkcv74820ina6vrlmcj4";
  } // {
    version = "8.00.50727.42"; /* cl.exe reports as 14.00.50727.42, lib.exe and link.exe are mote honest */
    INCLUDE = "${msvc}/VC/include";
    LIB     = "${msvc}/VC/lib;${msvc}/SDK/v2.0/lib";
    PATH    = "${msvc}/VC/bin/";
    CLEXE   = "${msvc}/VC/bin/cl.exe";
  };

# # it has no mt.exe needed to build perl
# sdk = derivation {
#   name = "sdk";
#   system = builtins.currentSystem;
#   builder = builtins.getEnv "COMSPEC";
#   args = ["/c" ''${p7zip-i686}\bin\7z.exe x -o%out% ${ ./Microsoft_Platform_SDK_for_Windows_XP_SP2.7z }''];
#
#   outputHashMode = "recursive";
#   outputHashAlgo = "sha256";
#   outputHash     = "1y6myv20lx6288s66iwa6vy6lhwx1mm64cgkxizhb4fa1n2fg2is";
# } // {
#   INCLUDE = "${sdk}/Include";
#   LIB     = "${sdk}/Lib";
#   PATH    = "${sdk}/bin/WinNT;${sdk}/bin";
# };

  # it has no mt.exe needed to build perl
  sdk = derivation {
    name = "sdk";
    system = builtins.currentSystem;
    builder = builtins.getEnv "COMSPEC";
    args = ["/c" ''${p7zip-i686}\bin\7z.exe x -o%out% ${ ./5.2.3790.2075.51.7z }''];

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "124yzciv65q056r7i30qmhmbnwqc035r7cfll12nm4sfj7kpxh55";
  } // {
    version = "5.2.3790.2075.51";
    INCLUDE = "${sdk}/Include";
    LIB     = "${sdk}/Lib";
    PATH    = "${sdk}/bin/WinNT;${sdk}/bin";
  };

/*
  # first steps on unpacking vs.iso

  Ixpvc = derivation {
    name = "Ixpvc";
    system = builtins.currentSystem;
    builder = builtins.getEnv "COMSPEC";
    args = ["/c" ''${p7zip-i686}\bin\7z.exe x -o%out% ${vc-iso} Ixpvc.exe''];
  };

  vcsetup1 = derivation {
    name = "xxx";
    system = builtins.currentSystem;
    builder = builtins.getEnv "COMSPEC";
    args = ["/c" ''${p7zip-i686}\bin\7z.exe x -o%out% ${Ixpvc} vcsetup1.cab''];
  };

  xxx = derivation {
    name = "xxx";
    system = builtins.currentSystem;
    builder = builtins.getEnv "COMSPEC";
    args = ["/c" ''${p7zip-i686}\bin\7z.exe x -o%out% ${vcsetup1}''];
  };
*/
}
