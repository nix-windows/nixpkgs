{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.74_0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_74_0.tar.bz2";
    sha256 = "1c8nw4jz17zy2y27h7p554a5jza1ymz8phkz71p9181ifx8c3gw3";
  };
})
