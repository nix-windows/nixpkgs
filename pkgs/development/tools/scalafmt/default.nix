{ stdenv, jdk, jre, fetchMavenArtifact, makeWrapper, gnugrep }:

let
  support = (import ./support.nix) fetchMavenArtifact;
in
stdenv.mkDerivation rec {
  version = support.scalafmtVersion;
  baseName = "scalafmt";
  name = "${baseName}-${version}";

  src = support.scalafmt.jar;

  buildInputs = [ jdk makeWrapper ] ++ support.deps;

  checkInputs = [ gnugrep ];

  doCheck = true;

  phases = [ "installPhase" "checkPhase" ];

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"
    cp ${src} "$out/lib/${name}.jar"
    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-cp $CLASSPATH:$out/lib/${name}.jar org.scalafmt.cli.Cli"
  '';

  checkPhase = ''
    $out/bin/${baseName} --version | grep -q "${version}"
  '';

  meta = with stdenv.lib; {
    description = "Opinionated code formatter for Scala";
    homepage = http://scalafmt.org;
    license = licenses.asl20;
    maintainers = [ maintainers.markus1189 ];
  };
}
