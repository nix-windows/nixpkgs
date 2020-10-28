{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.74_0";

# patches = [ (fetchpatch {
#   url = "https://github.com/boostorg/lockfree/commit/12726cda009a855073b9bedbdce57b6ce7763da2.patch";
#   sha256 = "0x65nkwzv8fdacj8sw5njl3v63jj19dirrpklbwy6qpsncw7fc7h";
#   stripLen = 1;
# })];

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_74_0.tar.bz2";
    sha256 = "1c8nw4jz17zy2y27h7p554a5jza1ymz8phkz71p9181ifx8c3gw3";
  };
})
