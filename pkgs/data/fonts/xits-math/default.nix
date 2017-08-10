{ stdenv, fetchFromGitHub, python2Packages, libfaketime, fontforge }:

stdenv.mkDerivation rec {
  name = "xits-math-${version}";
  version = "1.108";

  src = fetchFromGitHub {
    owner = "khaledhosny";
    repo = "xits-math";
    rev = "v${version}";
    sha256 = "08nn676c41a7gmmhrzi8mm0g74z8aiaafjk48pqcwxvjj9av7xjg";
  };

  nativeBuildInputs = [ fontforge ] ++ (with python2Packages; [ python fonttools ]);

  postPatch = ''
    rm *.otf
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp *.otf $out/share/fonts/opentype
  '';

  LD_PRELOAD = "${libfaketime}/lib/libfaketime.so.1";
  FAKETIME = "1970-01-01 00:00:01";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0hxasv772mzbjn31i3ad0zd7bql6b6j8v9qf2sdma4a42qck6i8n";

  meta = with stdenv.lib; {
    homepage = "https://github.com/khaledhosny/xits-math";
    description = "OpenType implementation of STIX fonts with math support";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
