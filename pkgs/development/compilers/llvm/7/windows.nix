{ lowPrio, newScope, pkgs, stdenv, cmake, libstdcxxHook, fetchzip, perl
, libxml2, python, isl, fetchurl#, fetchFromGitHub, overrideCC, wrapCCWith
#, buildLlvmTools # tools, but from the previous stage, for cross
#, targetLlvmLibraries # libraries, but from the next stage, for cross
}:

let
  version = "7.0.1";

  fetch = name: sha256: fetchurl {
    url = "https://releases.llvm.org/${version}/${name}-${version}.src.tar.xz";
    inherit sha256;
  };

  tools = stdenv.lib.makeExtensible (tools: let
    callPackage = newScope (tools // { inherit stdenv cmake libxml2 python isl version fetch; });
#   mkExtraBuildCommands = cc: ''
#     rsrc="$out/resource-root"
#     mkdir "$rsrc"
#     ln -s "${cc}/lib/clang/${release_version}/include" "$rsrc"
#     ln -s "${targetLlvmLibraries.compiler-rt.out}/lib" "$rsrc/lib"
#     echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
#   '' + stdenv.lib.optionalString stdenv.targetPlatform.isLinux ''
#     echo "--gcc-toolchain=${tools.clang-unwrapped.gcc}" >> $out/nix-support/cc-cflags
#   '';
  in rec {

    # These binaries include Clang, LLD, compiler-rt, various LLVM tools, etc. varying slightly between platforms.
    llvm-bin = stdenv.mkDerivation {
      name = "llvm-bin-${version}";
      src = fetchurl {
        url = "http://releases.llvm.org/${version}/LLVM-${version}-win64.exe"; # SFX-archive 7z can unpack
        sha256 = "0mzz5fh6149r58imfk7galhsr21x51giwpzcz2lshhv51m14qbk7";
      };
      buildInputs = [ perl ];
      unpackPhase = ''
        system("7z x -o$ENV{out} $ENV{src}");
      '';
      installPhase = ''
        remove_treeL("$ENV{out}/\$PLUGINSDIR", "$ENV{out}/Uninstall.exe");
        changeFile { s|^perl| "${perl}/bin/perl.exe" =~ s,/,\\,gr |gre } "$ENV{out}/libexec/c++-analyzer.bat", "$ENV{out}/libexec/ccc-analyzer.bat";
      '';
    };


    llvm-all = callPackage ./llvm-windows.nix { buildType = "all"; };

    llvm = llvm-all; # callPackage ./llvm-windows.nix { buildType = "llvm"; };

    clang-unwrapped = llvm-all; # callPackage ./llvm-windows.nix { buildType = "clang"; };

#    clang-unwrapped = callPackage ./clang/windows.nix {
#     inherit clang-tools-extra_src;
#    };
#
#   llvm-manpages = lowPrio (tools.llvm.override {
#     enableManpages = true;
#     python = pkgs.python;  # don't use python-boot
#   });
#
#   clang-manpages = lowPrio (tools.clang-unwrapped.override {
#     enableManpages = true;
#     python = pkgs.python;  # don't use python-boot
#   });
#
#   libclang = tools.clang-unwrapped.lib;
#
#   clang = if stdenv.cc.isGNU then tools.libstdcxxClang else tools.libcxxClang;
#
#   libstdcxxClang = wrapCCWith rec {
#     cc = tools.clang-unwrapped;
#     extraPackages = [
#       libstdcxxHook
#       targetLlvmLibraries.compiler-rt
#     ];
#     extraBuildCommands = mkExtraBuildCommands cc;
#   };
#
#   libcxxClang = wrapCCWith rec {
#     cc = tools.clang-unwrapped;
#     extraPackages = [
#       targetLlvmLibraries.libcxx
#       targetLlvmLibraries.libcxxabi
#       targetLlvmLibraries.compiler-rt
#     ];
#     extraBuildCommands = mkExtraBuildCommands cc;
#   };
#
#   lld = callPackage ./lld.nix {};
#
#   lldb = callPackage ./lldb.nix {};
  });

# libraries = stdenv.lib.makeExtensible (libraries: let
#   callPackage = newScope (libraries // buildLlvmTools // { inherit stdenv cmake libxml2 python isl version fetch; });
# in {
#
#   compiler-rt = callPackage ./compiler-rt.nix {};
#
#   stdenv = overrideCC stdenv buildLlvmTools.clang;
#
#   libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;
#
#   libcxx = callPackage ./libc++ {};
#
#   libcxxabi = callPackage ./libc++abi.nix {};
#
#   openmp = callPackage ./openmp.nix {};
# });

in { inherit tools /*libraries*/; } /* // libraries*/ // tools
