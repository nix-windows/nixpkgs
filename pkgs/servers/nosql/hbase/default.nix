{ stdenv, fetchurl, jre, makeWrapper, which, coreutils }:

let
  common = { version, sha256 }:
    stdenv.mkDerivation {
      name = "hbase-${version}";

      src = fetchurl {
        url = "mirror://apache/hbase/${version}/hbase-${version}-bin.tar.gz";
        inherit sha256;
      };

      buildInputs = [ makeWrapper ];
      installPhase = ''
        mkdir -p $out
        cp -R * $out/

        for n in $out/bin/*; do
          if [[ $n = *.rb ]]; then
            sed -r -i "1s|.+|#!$out/bin/hbase-jruby|" $n
          fi
          # do not wrap include files
          [[ $n = *hbase-config.sh ]] || [[ $n = *hbase-common.sh ]] || (
            wrapProgram $n \
              --prefix PATH : "${stdenv.lib.makeBinPath [ which coreutils ]}" \
              --set HBASE_HOME "$out" \
              --set JAVA_HOME "${jre}" \
              --set HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP "true"
          )
        done
      '';

      meta = with stdenv.lib; {
        description = "A distributed, scalable, big data store";
        homepage = https://hbase.apache.org;
        license = licenses.asl20;
        maintainers = with maintainers; [ volth ];
        platforms = platforms.linux;
      };
    };
in {
  hbase_1_2 = common {
    version = "1.2.6";
    sha256 = "1sl547xfim32m7nk7rcf1ksrss3y8w9zxnf691kddwm7fciw5yx0";
  };
  hbase_1_3 = common {
    version = "1.3.1";
    sha256 = "1q02d74amdilj16hlhkwyyv4xsmbmjlnla2x54vklkn4fv2z6vlj";
  };
}
