{ stdenv, lib, fetchpatch, python, cmake, llvm, ocaml, findlib, ctypes }:

let
  version = lib.getVersion llvm;
  is37 = lib.hasPrefix "3.7." version;
  is39 = lib.hasPrefix "3.9." version;
in
assert is37 || is39;
stdenv.mkDerivation ({
  name = "ocaml-llvm-${version}";

  inherit (llvm) src;

  propagatedBuildInputs = [ llvm ];
  buildInputs = [ python ocaml findlib ctypes ] ++ lib.optional is39 cmake;

  meta = {
    inherit (llvm.meta) license homepage;
    platforms = ocaml.meta.platforms or [];
    description = "OCaml bindings distributed with LLVM";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };

} // lib.optionalAttrs is37 {

  # 3.7 support from https://raw.githubusercontent.com/NixOS/nixpkgs/4083964c6f8b8282043e028ac4ac4f1189f51cbe/pkgs/development/ocaml-modules/llvm/default.nix

  configurePhase = ''
    mkdir build
    cd build
    ../configure --disable-compiler-version-checks --prefix=$out \
    --disable-doxygen --disable-docs --with-ocaml-libdir=$OCAMLFIND_DESTDIR/llvm \
    --enable-static
    '';

  enableParallelBuilding = false;

  makeFlags = [ "-C bindings" "SYSTEM_LLVM_CONFIG=llvm-config" ];

  postInstall = ''
    mv $OCAMLFIND_DESTDIR/llvm/META{.llvm,}
  '';

} // lib.optionalAttrs is39 {

  patches = [ (fetchpatch {
    url = https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/llvm/llvm.3.9/files/cmake.patch;
    sha256 = "1fcc6ylfiw1npdhx7mrsj7h0dx7cym7i9664kpr76zqazb52ikm9";
  })];

  cmakeFlags = [ "-DLLVM_OCAML_OUT_OF_TREE=TRUE" ];

  buildFlags = "ocaml_all";

  installFlags = "-C bindings/ocaml";

  postInstall = ''
    mv $out/lib/ocaml $out/ocaml
    mkdir -p $OCAMLFIND_DESTDIR/
    mv $out/ocaml $OCAMLFIND_DESTDIR/llvm
    mv $OCAMLFIND_DESTDIR/llvm/META{.llvm,}
  '';
})
