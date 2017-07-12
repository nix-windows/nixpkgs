{ stdenv, fetchFromGitHub, autoconf, automake, libtool, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "aerospike-server-${version}";
  version = "3.14.1.1";

  src = fetchFromGitHub {
    owner = "aerospike";
    repo = "aerospike-server";
    rev = version;
    sha256 = "14w3q8qnn4dc8hiwi6n7yifjprnk6rpmx8376nbdcp6pkxk0bmfc";
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
