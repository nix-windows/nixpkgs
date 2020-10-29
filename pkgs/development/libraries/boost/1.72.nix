{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.72_0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_72_0.tar.bz2";
    sha256 = "08h7cv61fd0lzb4z50xanfqn0pdgvizjrpd1kcdgj725pisb5jar";
  };
})
