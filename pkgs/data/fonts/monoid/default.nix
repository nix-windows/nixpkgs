{ stdenv, fetchFromGitHub, python, fontforge, libfaketime }:

stdenv.mkDerivation rec {
  name = "monoid-${version}";
  version = "2016-07-21";

  src = fetchFromGitHub {
    owner = "larsenwork";
    repo = "monoid";
    rev = "e9d77ec18c337dc78ceae787a673328615f0b120";
    sha256 = "07h5q6cn6jjpmxp9vyag1bxx481waz344sr2kfs7d37bba8yjydj";
  };

  nativeBuildInputs = [ python fontforge ];

  enableParallelBuilding = true;

  buildPhase = ''
    local _d=""
    local _l=""
    for _d in {Monoisome,Source}/*.sfdir; do
      _l="''${_d##*/}.log"
      echo "Building $_d (log at $_l)"
      python Scripts/build.py ${if enableParallelBuilding then "$NIX_BUILD_CORES" else "1"} 0 $_d > $_l
    done
  '';

  installPhase = ''
    mkdir -p $out/share/{doc,fonts/truetype}
    cp -va _release/* $out/share/fonts/truetype
    cp -va Readme.md $out/share/doc
  '';

  LD_PRELOAD = "${libfaketime}/lib/libfaketime.so.1";
  FAKETIME = "1970-01-01 00:00:01";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "09n3d79i4izphniadmrrk2bvaln8g6wwxxzg86c0rzr40s0s5p3p";

  meta = with stdenv.lib; {
    homepage = http://larsenwork.com/monoid;
    description = "Customisable coding font with alternates, ligatures and contextual positioning";
    license = [ licenses.ofl licenses.mit ];
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
