{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.68_0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_68_0.tar.bz2";
    sha256 = "0000000000005f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7";
  };
})
