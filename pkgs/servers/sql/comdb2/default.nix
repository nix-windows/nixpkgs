{ stdenv, fetchFromGitHub, which, protobufc, tcl, byacc, flex, openssl, lz4, zlib, libuuid, sqlite, readline, libunwind }:

stdenv.mkDerivation rec {
  name = "comdb2-${version}";
  version = "7.0.unstable-2017-06-26";

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "comdb2";
    rev = "206dd26";
    sha256 = "0najrzri3j7l9w44x2gjv9d06bh0rpqsx8nwdgshk9d95vibg95d";
  };

  nativeBuildInputs = [ which protobufc tcl byacc flex ];
  buildInputs = [ openssl lz4 zlib libuuid sqlite readline libunwind ];

  preBuild = ''
    patchShebangs berkdb/dist/
    patchShebangs bdb/
    patchShebangs db/
    substituteInPlace main.mk --replace "-ltermcap" ""
  '';

  makeFlags = "LEX=flex DESTDIR=$(out) PREFIX=";
  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  postInstall = ''
    mv $out/usr/local/lib/pkgconfig $out/lib/
    rm -rf $out/{etc,tmp,usr,var,lib/systemd}
  '';

  meta = with stdenv.lib; {
    description = "Clustered RDBMS built on Optimistic Concurrency Control techniques";
    homepage = http://bloomberg.github.io/comdb2;
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainer = with maintainers; [ volth ];
  };
}
