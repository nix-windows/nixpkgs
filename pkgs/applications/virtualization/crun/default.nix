{ stdenv, lib, fetchFromGitHub, autoreconfHook, git, go-md2man, pkgconfig
, libcap, libseccomp, python3, systemd, yajl }:

stdenv.mkDerivation rec {
  pname = "crun";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = version;
    sha256 = "1yw1g1w4hg9kh6s0lgyi1i9pxaqq4wxsmjnjdcvsgw2nxbj68nnq";
    deepClone = true;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook git go-md2man pkgconfig python3 ];

  buildInputs = [ libcap libseccomp systemd yajl ];

  enableParallelBuilding = true;

  # the tests require additional permissions
  doCheck = false;

  meta = with lib; {
    description = "A fast and lightweight fully featured OCI runtime and C library for running containers";
    license = licenses.gpl3;
    platforms = platforms.linux;
    inherit (src.meta) homepage;
  };
}
