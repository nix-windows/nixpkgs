{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.69_0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_69_0.tar.bz2";
    sha256 = "01j4n142dz20lcgqji8d8hspp04p1nv7m8i6dz8w5lchfdhx8clg";
  };
})
