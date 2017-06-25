{ stdenv, fetchgit, autoconf, automake, libtool, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "aerospike-server-${version}";
  version = "3.14.0.1";

  src = fetchgit {
    url = https://github.com/aerospike/aerospike-server;
    rev = "refs/tags/${version}";
    sha256 = "1kzkwvir9j9jdlwp8gi9p3wkv3qhbrn62x1mb1xlnrdc7rk32kyn";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ openssl zlib ];

  preBuild = ''
    patchShebangs build/gen_version
    substituteInPlace build/gen_version --replace 'git describe' 'echo ${version}'
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/udf
    cp      target/Linux-x86_64/bin/asd $out/bin/asd
    cp -dpR modules/lua-core/src        $out/share/udf/lua
  '';

  meta = with stdenv.lib; {
    description = "Flash-optimized, in-memory, NoSQL database";
    homepage = http://aerospike.com/;
    license = licenses.agpl3;
    platforms = [ "x86_64-linux" ];
    maintainer = with maintainers; [ volth ];
  };
}
