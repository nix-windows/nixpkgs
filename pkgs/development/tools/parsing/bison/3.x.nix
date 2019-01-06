{ stdenv, fetchurl, m4, perl, help2man }:

if stdenv.hostPlatform.isMicrosoft then

# anyway bison binary is required to build bison, so let's stick with the MSYS binary for a while
stdenv.mkDerivation rec {
  name = "bison-3.2";
  unpackPhase = "";
# buildPhase = "";
  installPhase = ''
    make_pathL("$ENV{out}/bin");
    copyL('C:/msys64/usr/bin/bison.exe',        "$ENV{out}/bin/bison.exe"       );
    copyL('C:/msys64/usr/bin/msys-2.0.dll',     "$ENV{out}/bin/msys-2.0.dll"    );
    copyL('C:/msys64/usr/bin/msys-intl-8.dll',  "$ENV{out}/bin/msys-intl-8.dll" );
    copyL('C:/msys64/usr/bin/msys-iconv-2.dll', "$ENV{out}/bin/msys-iconv-2.dll");
  '';
}

else

stdenv.mkDerivation rec {
  name = "bison-3.1";

  src = fetchurl {
    url = "mirror://gnu/bison/${name}.tar.gz";
    sha256 = "0ip9krjf0lw57pk3wfbxgjhif1i18hm3vh35d1ifrvhnafskdjx7";
  };

  patches = []; # remove on another rebuild

  nativeBuildInputs = [ m4 perl ] ++ stdenv.lib.optional stdenv.isSunOS help2man;
  propagatedBuildInputs = [ m4 ];

  doCheck = false; # fails
  doInstallCheck = false; # fails

  meta = {
    homepage = http://www.gnu.org/software/bison/;
    description = "Yacc-compatible parser generator";
    license = stdenv.lib.licenses.gpl3Plus;

    longDescription = ''
      Bison is a general-purpose parser generator that converts an
      annotated context-free grammar into an LALR(1) or GLR parser for
      that grammar.  Once you are proficient with Bison, you can use
      it to develop a wide range of language parsers, from those used
      in simple desk calculators to complex programming languages.

      Bison is upward compatible with Yacc: all properly-written Yacc
      grammars ought to work with Bison with no change.  Anyone
      familiar with Yacc should be able to use Bison with little
      trouble.  You need to be fluent in C or C++ programming in order
      to use Bison.
    '';

    platforms = stdenv.lib.platforms.unix;
  };

  passthru = { glrSupport = true; };
}
