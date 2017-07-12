{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gotags-${version}";
  version = "20150803-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "be986a34e20634775ac73e11a5b55916085c48e7";

  goPackagePath = "github.com/jstemmer/gotags";

  src = fetchFromGitHub {
    inherit rev;
    owner = "jstemmer";
    repo = "gotags";
    sha256 = "071wyq90b06xlb3bb0l4qjz1gf4nnci4bcngiddfcxf2l41w1vja";
  };
}
