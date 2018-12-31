{ stdenv
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
, release_version
, zlib
, debugVersion ? false
#, enableManpages ? false
#, enableSharedLibraries ? true
, enableWasm ? true
#, enablePFM ? !stdenv.isDarwin
}:


let
  src = fetch "llvm" "16s196wqzdw4pmri15hadzqgdi926zln3an2viwyq0kini6zr3d3";
in
  stdenv.mkDerivation (rec {
  name = "llvm-${version}";

  inherit src;
  unpackPhase = ''
    unpackFile $ENV{src};
    move('llvm-${version}.src', 'llvm') or die "move('llvm-${version}.src', 'llvm'): $!";
    $ENV{sourceRoot} = getcwd()."/llvm";
  '';

  nativeBuildInputs = [ cmake python ninja ];

  buildInputs = [ libxml2 libffi ]
    /*++ stdenv.lib.optional enablePFM libpfm*/; # exegesis

  propagatedBuildInputs = [ zlib ];

  # use ninja instead of nmake for multicore build
  configurePhase = ''
    $ENV{INCLUDE} = "${zlib}/include;${libxml2}/include;$ENV{INCLUDE}"; # TODO: setup hook should handle this
    $ENV{LIB}     = "${zlib}/lib;${libxml2}/lib;$ENV{LIB}";             # TODO: setup hook should handle this
    mkdir("build");                                                                                                                 # -\
    chdir("build");                                                                                                                 #   >- TODO: cmake setup hook should handle this
    system("cmake -GNinja -Thost=x64 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ENV{out} $ENV{cmakeFlags} ..") == 0 or die; # -/
  '';

  buildPhase = ''
    system("ninja") == 0 or die;
  '';

  installPhase = ''
    system("ninja install") == 0 or die;
  '';

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_RTTI=ON"

    "-DLLVM_ENABLE_FFI=ON"
    "-DFFI_INCLUDE_DIR=${libffi}/include" # TODO: a setup hook should handle this
    "-DFFI_LIBRARY_DIR=${libffi}/lib"

    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.hostPlatform.config}"
    "-DTARGET_TRIPLE=${stdenv.hostPlatform.config}"

    "-DLLVM_TARGETS_WITH_JIT=X86"
    "-DLLVM_ALL_TARGETS=X86"
    "-DLLVM_TARGETS_TO_BUILD=X86"

    "-DLLVM_ENABLE_DUMP=ON"
  ]
  ++ stdenv.lib.optional enableWasm
   "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly"
  ;

  passthru.src = src;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin dtzWill ];
    platforms   = stdenv.lib.platforms.all;
  };
})
