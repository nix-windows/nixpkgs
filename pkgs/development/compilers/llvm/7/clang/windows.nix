{ stdenv, fetch, cmake, libxml2, llvm, version, clang-tools-extra_src, python, zlib, ninja }:

let
  src = fetch "cfe" "067lwggnbg0w1dfrps790r5l6k8n5zwhlsw7zb6zvmfpwpfn4nx4";
  self = stdenv.mkDerivation ({
    name = "clang-${version}";

    unpackPhase = ''
      unpackFile '${src}';
      move('cfe-${version}.src',               'clang'                       ) or die "move(cfe-${version}.src, clang): $!";
      $ENV{sourceRoot} = getcwd()."/clang";
      unpackFile '${clang-tools-extra_src}';
      move('clang-tools-extra-${version}.src', "$ENV{sourceRoot}/tools/extra") or die "move(clang-tools-extra-${version}.src, $ENV{sourceRoot}/tools/extra): $!";
    '';

    nativeBuildInputs = [ cmake python ninja ];

    buildInputs = [ libxml2 llvm ];

    cmakeFlags = [
      "-DHAVE_CXX_ATOMICS64_WITHOUT_LIB=True" # msvc-only, ${llvm}/lib/cmake/llvm/CheckAtomic.cmake should set it but never included
    ];

    # use ninja instead of nmake for multicore build
    # $ENV{CMAKE_PREFIX_PATH} = "${llvm}";                                                # TODO: setup hook should handle this (cmake knowns about llvm and llvm on $PATH is enough for it)
    # $ENV{INCLUDE} = "${llvm}/include;${zlib}/include;${libxml2}/include;$ENV{INCLUDE}"; # TODO: setup hook should handle this (zlib is propagated)
    # $ENV{LIB}     = "${llvm}/lib;${zlib}/lib;${libxml2}/lib;$ENV{LIB}";                 # TODO: setup hook should handle this
    configurePhase = ''
      mkdir("build");                                                                                                                 # -\
      chdir("build");                                                                                                                 #   >- TODO: cmake setup hook should handle this
      system("cmake -GNinja -Thost=x64 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ENV{out} $ENV{cmakeFlags} ..") == 0 or die; # -/
    '';

    buildPhase = ''
      system("ninja") == 0 or die;
    '';

    installPhase = ''
      system("ninja install") == 0 or die;
      copy('${libxml2}/bin/libxml2.dll', "$ENV{out}/bin/");                              # TODO: setup hook should handle this
    '';
    passthru = {
      isClang = true;
      inherit llvm src;
    };

    meta = {
      description = "A c, c++, objective-c, and objective-c++ frontend for the llvm compiler";
      homepage    = http://llvm.org/;
      license     = stdenv.lib.licenses.ncsa;
      platforms   = stdenv.lib.platforms.all;
    };
  });
in self
