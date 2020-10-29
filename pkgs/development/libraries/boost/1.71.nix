{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.71_0";

  src = fetchurl {
    urls = [
      "https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.bz2"
      "mirror://sourceforge/boost/boost_1_71_0.tar.bz2" # 404
    ];
    sha256 = "1vi40mcair6xgm9k8rsavyhcia3ia28q8k0blknwgy4b3sh8sfnp";
  };
})
