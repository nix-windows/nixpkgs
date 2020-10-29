{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.73_0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_73_0.tar.bz2";
    sha256 = "00mlrfgwwg96m333h3k966j5pqss7drwhdb26hsxq9ml8babicsf";
  };
})
