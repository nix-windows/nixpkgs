{ lib
, localSystem, crossSystem, config, overlays
}:

assert crossSystem == null;

let
  inherit (localSystem) system;

  # bootstrap perl, binary distribution
  shell =
#   if system == "x86_64-windows" then /*"C:/Windows/System32/cmd.exe"*/
    "C:/Perl64/bin/perl.exe"
#   else if system == "i686-freebsd" || system == "x86_64-freebsd" then "/usr/local/bin/bash"
#   else "/bin/bash"
    ;

  path = [];
#   (if system == "i686-solaris" then [ "/usr/gnu" ] else []) ++
#   (if system == "i686-netbsd" then [ "/usr/pkg" ] else []) ++
#   (if system == "x86_64-solaris" then [ "/opt/local/gnu" ] else []) ++
#   ["/" "/usr" "/usr/local"];

# prehookBase = ''
#   # Disable purity tests; it's allowed (even needed) to link to
#   # libraries outside the Nix store (like the C library).
#   export NIX_ENFORCE_PURITY=
#   export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
# '';

# prehookFreeBSD = ''
#   ${prehookBase}
#
#   alias make=gmake
#   alias tar=gtar
#   alias sed=gsed
#   export MAKE=gmake
#   shopt -s expand_aliases
# '';

# prehookOpenBSD = ''
#   ${prehookBase}
#
#   alias make=gmake
#   alias grep=ggrep
#   alias mv=gmv
#   alias ln=gln
#   alias sed=gsed
#   alias tar=gtar
#
#   export MAKE=gmake
#   shopt -s expand_aliases
# '';

# prehookNetBSD = ''
#   ${prehookBase}
#
#   alias make=gmake
#   alias sed=gsed
#   alias tar=gtar
#   export MAKE=gmake
#   shopt -s expand_aliases
# '';
#
# # prevent libtool from failing to find dynamic libraries
# prehookCygwin = ''
#   ${prehookBase}
#
#   shopt -s expand_aliases
#   export lt_cv_deplibs_check_method=pass_all
# '';
#
# extraNativeBuildInputsCygwin = [
#   ../cygwin/all-buildinputs-as-runtimedep.sh
#   ../cygwin/wrap-exes-to-find-dlls.sh
# ] ++ (if system == "i686-cygwin" then [
#   ../cygwin/rebase-i686.sh
# ] else if system == "x86_64-cygwin" then [
#   ../cygwin/rebase-x86_64.sh
# ] else []);

  # A function that builds a "native" stdenv (one that uses tools in
  # /usr etc.).
  makeStdenv =
    { cc, fetchurl, extraPath ? [], overrides ? (self: super: { }) }:

    import ../generic {
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;

      preHook = "";
#       if system == "i686-freebsd" then prehookFreeBSD else
#       if system == "x86_64-freebsd" then prehookFreeBSD else
#       if system == "i686-openbsd" then prehookOpenBSD else
#       if system == "i686-netbsd" then prehookNetBSD else
#       if system == "i686-cygwin" then prehookCygwin else
#       if system == "x86_64-cygwin" then prehookCygwin else
#       prehookBase;

      extraNativeBuildInputs =
#       if system == "i686-cygwin" then extraNativeBuildInputsCygwin else
#       if system == "x86_64-cygwin" then extraNativeBuildInputsCygwin else
        [];

      initialPath = extraPath ++ path;

      fetchurlBoot = fetchurl;

      inherit shell cc overrides config;
    };

in

[

  ({}: rec {
    __raw = true;

    stdenv = makeStdenv {
      cc = null;
      fetchurl = null;
    };
    stdenvNoCC = stdenv;

    cc = let
      msvc = stdenvNoCC.mkDerivation rec {
        version = "14.16.27023";
        name = "msvc-${version}";
        preferLocalBuild = true;
        dontBuild = true;
        dontConfigure = true;
        unpackPhase = "#";
        installPhase = ''
          use File::Copy::Recursive qw(dircopy);
          print("out='$ENV{out}'\n");
          dircopy("C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/VC/Tools/MSVC/14.16.27023", $ENV{out}) or die "$!";
        '';
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "16v8qsjajvym39yc0crg59hmwds4m42sgf95nz5v02fiysv78zqw";
      };
      sdk = stdenvNoCC.mkDerivation rec {
        version = "10.0.17134.0";
        name = "sdk-${version}";
        preferLocalBuild = true;
        dontBuild = true;
        dontConfigure = true;
        unpackPhase = "#";
        installPhase = ''
          use File::Copy::Recursive qw(dircopy);
          dircopy("C:/Program Files (x86)/Windows Kits/10", $ENV{out}) or die "$!";
        '';
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "0y8c2x9li690mvfx7prpkgqacs16mqyqf3simaisizjxzbmkm1hq";
      };
      gnumake = fetchurl/*Boot*/ {
        url = https://raw.githubusercontent.com/mbuilov/gnumake-windows/master/gnumake-4.2.1-x64.exe;
        sha256 = "0fly79df9330im0r4xr25d5yi46kr23p5s9mybjfz28v930n2zx5";
      };
      cc-wrapper = stdenvNoCC.mkDerivation {
        name = "${msvc.name}+${sdk.name}";
        preferLocalBuild = true;
        dontBuild = true;
        dontConfigure = true;
        unpackPhase = "#";
        installPhase = ''
          mkdir $ENV{out} or die;
          mkdir "$ENV{out}/bin" or die;

          for my $name ('cl', 'lib', 'link', 'nmake', 'mt', 'rc') {
            open(my $fh, ">$ENV{out}/bin/$name.cmd");
            print $fh "PATH=${msvc}/bin/HostX64/x64;${sdk}/bin/${sdk.version}/x64;${sdk}/bin/x64;%PATH%\n";
            # + C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community/MSBuild/15.0/bin/Roslyn;
            # + C:/Program Files (x86)/Microsoft Visual Studio/Preview/Community//MSBuild/15.0/bin;
            # + C:/Windows/Microsoft.NET/Framework64/v4.0.30319;
            print $fh "set INCLUDE=${msvc}/include;${sdk}/include/${sdk.version}/ucrt;${sdk}/include/${sdk.version}/shared;${sdk}/include/${sdk.version}/um;${sdk}/include/${sdk.version}/winrt;${sdk}/include/${sdk.version}/cppwinrt\n";
            print $fh "set LIB=${msvc}/lib/x64;${sdk}/lib/${sdk.version}/ucrt/x64;${sdk}/lib/${sdk.version}/um/x64\n";

            print $fh "set LIBPATH=${msvc}\lib\x64;${msvc}\lib\x86\store\references;${sdk}\UnionMetadata\${sdk.version};${sdk}\References\${sdk.version}\n";
            # + C:/Windows/Microsoft.NET/Framework64/v4.0.30319;
            print $fh "set WindowsLibPath=${sdk}/UnionMetadata/${sdk.version};${sdk}/References/${sdk.version}\n";

            print $fh "set WindowsSDKLibVersion=${sdk.version}\n";
            print $fh "set WindowsSDKVersion=${sdk.version}\n";
            print $fh "set WindowsSdkVerBinPath=${sdk}/bin/${sdk.version}\n";
            print $fh "set WindowsSdkBinPath=${sdk}/bin\n";
            print $fh "set WindowsSdkDir=${sdk}\n";

            print $fh "set VCToolsVersion=${msvc.version}\n";
            print $fh "set VCToolsInstallDir=${msvc}\n";
            print $fh "set VCToolsRedistDir=${msvc}\n";

            #print $fh "set VSCMD_ARG_HOST_ARCH=x64\n";
            #print $fh "set VSCMD_ARG_TGT_ARCH=x64\n";
            #print $fh "set VSCMD_VER=15.0\n";

            print $fh "set UCRTVersion=${sdk.version}\n";
            print $fh "set UniversalCRTSdkDir=${sdk}\n";

            print $fh "$name.exe %*\n";
            close($fh);
          }
          use File::Copy qw(copy);
          copy '${gnumake}', "$ENV{out}/bin/gmake.exe";
        '';
        passthru = {
          targetPrefix = "";
        };
      };
    in
      cc-wrapper;
#      else
#        let
#          nativePrefix = { # switch
#            "i686-solaris" = "/usr/gnu";
#            "x86_64-solaris" = "/opt/local/gcc47";
##           "x86_64-windows" = "/mingw64";
##           "x86_64-windows" = "/c/LLVM";
#          }.${system} /*or "/usr"*/;
#        in
#        import ../../build-support/cc-wrapper {
#          name = "cc-native";
#          nativeTools = true;
#          nativeLibc = true;
#          inherit nativePrefix;
#          bintools = import ../../build-support/bintools-wrapper {
#            name = "bintools";
#            inherit stdenvNoCC nativePrefix;
#            nativeTools = true;
#            nativeLibc = true;
#          };
#          inherit stdenvNoCC;
#        };

    fetchurl = import ../../build-support/fetchurl {
      inherit lib stdenvNoCC;
      # Curl should be in /usr/bin or so.
      curl = null;
    };

  })

   # First build a stdenv based only on tools outside the store.
   (prevStage: {
     inherit config overlays;
     stdenv = makeStdenv {
       inherit (prevStage) cc fetchurl;
     } // { inherit (prevStage) fetchurl; };
   })

   # Using that, build a stdenv that adds the ‘xz’ command (which most systems
   # don't have, so we mustn't rely on the native environment providing it).
#  (prevStage: {
#    inherit config overlays;
#    stdenv = makeStdenv {
#      inherit (prevStage.stdenv) cc fetchurl;
#      extraPath = [ prevStage.xz ];
#      overrides = self: super: { inherit (prevStage) xz; };
#    };
#  })

]
