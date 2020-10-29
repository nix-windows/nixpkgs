{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.70_0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_70_0.tar.bz2";
    sha256 = "0y47nc7w0arwgj4x1phadxbvl7wyfcgknbz5kv8lzpl98wsyh2j3";
  };
})
