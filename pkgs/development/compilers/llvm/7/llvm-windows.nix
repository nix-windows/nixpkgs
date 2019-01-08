{ stdenv
, lib
, fetch
, cmake
, python
, ninja
, libffi
#, libbfd
#, libpfm
, libxml2
#, ncurses
, version
, zlib
, debugVersion ? false
#, enableManpages ? false
#, enableSharedLibraries ? true
, enableWasm ? true
#, enablePFM ? !stdenv.isDarwin
, buildType
}:

let
  buildTargets = { llvm  = [ "llc" "lld" "lli" "llvm-lib" "llvm-ar" /* more?*/ ];
                   clang = [ "clang" ];
                   lld   = [ "lld" ];
                   lldb  = [ "lldb" ];
                   all   = [ "all" ];
                 }.${buildType};
in stdenv.mkDerivation rec {
  name = "llvm-${buildType}-${version}";

  src = let
    llvm_src              = fetch "llvm"              "16s196wqzdw4pmri15hadzqgdi926zln3an2viwyq0kini6zr3d3";
    lld_src               = fetch "lld"               "0ca0qygrk87lhjk6cpv1wbmdfnficqqjsda3k7b013idvnralsc8";
    lldb_src              = fetch "lldb"              "10k9lyk3i72j9hca523r9pz79qp7d8q7jqnjy0i3saj1bgknpd3n";
    clang_src             = fetch "cfe"               "067lwggnbg0w1dfrps790r5l6k8n5zwhlsw7zb6zvmfpwpfn4nx4";
    clang-tools-extra_src = fetch "clang-tools-extra" "1v9vc7id1761qm7mywlknsp810232iwyz8rd4y5km4h7pg9cg4sc";
    compiler-rt_src       = fetch "compiler-rt"       "065ybd8fsc4h2hikbdyricj6pyv4r7r7kpcikhb2y5zf370xybkq";
    libunwind_src         = fetch "libunwind"         "04jrifbpl1czdqavgfjbyp8dfyn6ac5w2nlxrbdpk4px3ncm5j49";
    libcxxabi_src         = fetch "libcxxabi"         "1n6yx0949l9bprh75dffchahn8wplkm79ffk4f2ap9vw2lx90s41";
    libcxx_src            = fetch "libcxx"            "1wdrxg365ig0kngx52pd0n820sncp24blb0zpalc579iidhh4002";
    openmp_src            = fetch "openmp"            "030dkg5cypd7j9hq0mcqb5gs31lxwmzfq52j81l7v9ldcy5bf5mz";
  in stdenv.mkDerivation {
    name = "${name}-src";
    buildCommand = ''
      unpackFile '${llvm_src             }';
      unpackFile '${lld_src              }';
      unpackFile '${lldb_src             }';
      unpackFile '${clang_src            }';
      unpackFile '${clang-tools-extra_src}';
      unpackFile '${compiler-rt_src      }';
      unpackFile '${libunwind_src        }';
      unpackFile '${libcxxabi_src        }';
      unpackFile '${libcxx_src           }';
      unpackFile '${openmp_src           }';

      # 1: lldb-${version}.src/tools/lldb/test/testcases is a directory symlink to '..\packages\Python\lldbsuite\test'
      #    7z wrongly unpacks it as a file symlink (https://sourceforge.net/p/sevenzip/bugs/2174/)
      # 2: Perl's unlink() is unable to delete symlink
      system('del       lldb-${version}.src\test\testcases'                                                                           ) == 0 or die "unlink: $!";
      system('mklink /D lldb-${version}.src\test\testcases ..\packages\Python\lldbsuite\test'                                         ) == 0 or die "mklink: $!";

      # https://sourceforge.net/p/sevenzip/bugs/2174/ workaround
      system('del       libcxx-${version}.src\test\std\input.output\filesystems\Inputs\static_test_env\symlink_to_dir'                ) == 0 or die "unlink: $!";
      system('mklink /D libcxx-${version}.src\test\std\input.output\filesystems\Inputs\static_test_env\symlink_to_dir dir1'           ) == 0 or die "mklink: $!";

      system('del       libcxx-${version}.src\test\std\input.output\filesystems\Inputs\static_test_env\dir1\dir2\symlink_to_dir3'     ) == 0 or die "unlink: $!";
      system('mklink /D libcxx-${version}.src\test\std\input.output\filesystems\Inputs\static_test_env\dir1\dir2\symlink_to_dir3 dir3') == 0 or die "mklink: $!";

      move('llvm-${version}.src',              "$ENV{out}"                        ) or die "move: $!";
      move('lld-${version}.src',               "$ENV{out}/tools/lld"              ) or die "move: $!";
      move('lldb-${version}.src',              "$ENV{out}/tools/lldb"             ) or die "move: $!";
      move('cfe-${version}.src',               "$ENV{out}/tools/clang"            ) or die "move: $!";
      move('clang-tools-extra-${version}.src', "$ENV{out}/tools/clang/tools/extra") or die "move: $!";
      move('compiler-rt-${version}.src',       "$ENV{out}/projects/compiler-rt"   ) or die "move: $!";
      move('libunwind-${version}.src',         "$ENV{out}/projects/libunwind"     ) or die "move: $!";
      move('libcxxabi-${version}.src',         "$ENV{out}/projects/libcxxabi"     ) or die "move: $!";
      move('libcxx-${version}.src',            "$ENV{out}/projects/libcxx"        ) or die "move: $!";
      move('openmp-${version}.src',            "$ENV{out}/projects/openmp"        ) or die "move: $!";
    '';
  };

  nativeBuildInputs = [ cmake python ninja ];

  buildInputs = [ libxml2 /* dll */
                  zlib    /* static lib */ ]
    ++ lib.optional (libffi != null) libffi
    /*++ lib.optional enablePFM libpfm*/; # exegesis

  # use ninja instead of nmake for multicore build
  configurePhase = ''
    $ENV{INCLUDE} = "${zlib}/include;${libxml2}/include;$ENV{INCLUDE}"; # TODO: setup hook should handle this
    $ENV{LIB}     = "${zlib}/lib;${libxml2}/lib;$ENV{LIB}";             # TODO: setup hook should handle this
    mkdirL("build");                                                                                                     # -\
    chdirL("build");                                                                                                     #   >- TODO: cmake setup hook should handle this
    system("cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ENV{out} $ENV{cmakeFlags} ..") == 0 or die; # -/
  '';

  buildPhase = ''
    system("ninja ${lib.concatStringsSep " " buildTargets}") == 0 or die;
  '';

  doCheck = false; # it needs coreutils&findutils (cp, touch, chmod, rm, find, ...)
  checkPhase = ''
    system("ninja ${lib.concatMapStringsSep " " (x: "check-${x}") buildTargets}") == 0 or die;
  '';

  installPhase = ''
    system("ninja ${lib.concatMapStringsSep " " (x: if x == "all" then "install" else "install-${x}") buildTargets}") == 0 or die;
    copyL('${zlib}/bin/zlib1.dll',      "$ENV{out}/bin/zlib1.dll"   ) or die "copyL(zlib1.dll): $!";    # TODO: setup hook should handle this
    copyL('${libxml2}/bin/libxml2.dll', "$ENV{out}/bin/libxml2.dll" ) or die "copyL(libxml2.dll): $!";  # TODO: setup hook should handle this
  '' + lib.optionalString (libffi != null) ''
    copyL('${libffi}/bin/libffi-7.dll', "$ENV{out}/bin/libffi-7.dll") or die "copyL(libffi.dll): $!";   # TODO: setup hook should handle this
  '';

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DLLVM_ENABLE_RTTI=ON"

    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.hostPlatform.config}"
    "-DTARGET_TRIPLE=${stdenv.hostPlatform.config}"

    "-DLLVM_TARGETS_WITH_JIT=X86"
    "-DLLVM_ALL_TARGETS=X86"
    "-DLLVM_TARGETS_TO_BUILD=X86"

    "-DLLVM_ENABLE_DUMP=ON"
  ]
  ++ lib.optionals (libffi != null) [
    "-DLLVM_ENABLE_FFI=ON"
    "-DFFI_INCLUDE_DIR=${libffi}/include" # TODO: $ENV{INCLUDE} / $ENV{LIB} is not enough
    "-DFFI_LIBRARY_DIR=${libffi}/lib"
  ]
  ++ lib.optionals enableWasm [
   "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly"
  ];

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ lovek323 raskin dtzWill ];
    platforms   = lib.platforms.all;
  };
}
