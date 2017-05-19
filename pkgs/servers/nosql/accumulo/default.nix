{ stdenv, fetchurl, makeWrapper, jdk, which, jre, bash, coreutils, numactl }:

let
  common = { version, sha256 }:
    stdenv.mkDerivation {
      name = "accumulo-${version}";

      src = fetchurl {
        url = "mirror://apache/accumulo/${version}/accumulo-${version}-bin.tar.gz";
        inherit sha256;
      };

      nativeBuildInputs = [ makeWrapper jdk ];

      buildPhase = "bin/build_native_library.sh";

      installPhase = ''
        mkdir -p $out
        cp -dpR * $out/

        for n in $out/bin/*; do
          # do not wrap config.sh and config-server.sh
          [[ $n = *config* ]] || wrapProgram $n \
            --prefix PATH : "${stdenv.lib.makeBinPath [ which jre bash coreutils numactl ]}" \
            --set JAVA_HOME "${jre}" \
            --set ACCUMULO_HOME "$out"
        done
      '';

      meta = with stdenv.lib; {
        homepage = http://accumulo.apache.org/;
        description = "Key/value store based on the design of Google's BigTable";
        license = licenses.asl20;
        maintainers = with maintainers; [ volth ];
        platforms = [ "x86_64-linux" ];
      };
    };
in {
  accumulo_1_7 = common {
    version = "1.7.3";
    sha256 = "1nl0jjy8c75b0dgawdgv0kw5s92wrskdbv0cx1l4n5mw7wgjykr9";
  };
  accumulo_1_8 = common {
    version = "1.8.1";
    sha256 = "1x1pya8r3g8b4rz9qsb12cwbjs2ar1cvvhm73s8afp4k4glbz8zb";
  };
}