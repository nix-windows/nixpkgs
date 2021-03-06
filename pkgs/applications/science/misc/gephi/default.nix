{ stdenv, fetchFromGitHub, jdk, maven, javaPackages }:

let
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "gephi";
    repo = "gephi";
    rev = "v${version}";
    sha256 = if stdenv.hostPlatform.isWindows then
               "1x01qikc968yql2mrl8cdqd51gsa7g7iwyc76bpn6iaasimv088z" # ignoring executable bit
             else
               "0kqp2nvnsb55j1axb6hk0mlw5alyaiyb70z0mdybhpqqxyw2da2r";
  };

  # perform fake build to make a fixed-output derivation out of the files downloaded from maven central (120MB)
  deps = stdenv.mkDerivation {
    name = "gephi-${version}-deps";
    inherit src;
    buildInputs = [ jdk maven ];
    buildPhase = if stdenv.isShellPerl then ''
      while(system("mvn package -Dmaven.repo.local=$ENV{out}/.m2 -Dmaven.wagon.rto=5000") == 1) {
        print("timeout, restart maven to continue downloading\n");
      }
    '' else ''
      while mvn package -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
        echo "timeout, restart maven to continue downloading"
      done
    '';
    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = if stdenv.isShellPerl then ''
      findL { unlinkL($_) if -f $_ && /\.lastUpdated$|resolver-status\.properties$|_remote\.repositories$/; } "$ENV{out}/.m2"
    '' else ''
      find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "1p7yf97dn0nvr005cbs6vdk3i341s8fya4kfccj8qqad2qgxflif";
  };
in
stdenv.mkDerivation rec {
  name = "gephi-${version}";

  inherit src;

  buildInputs = [ jdk maven ];

  buildPhase = if stdenv.isShellPerl then ''
    system("mvn package --offline -Dmaven.repo.local=${deps}/.m2") == 0 or die;
  '' else ''
    # 'maven.repo.local' must be writable so copy it out of nix store
    mvn package --offline -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
  '';

  installPhase = if stdenv.isShellPerl then ''
    dircopy('modules/application/target/gephi', $ENV{out});
    findL { unlinkL($_) if /\.lastModified$/ } $ENV{out};
    changeFile { $_."\njdkhome=${jdk}" } "$ENV{out}/etc/gephi.conf";
    ${ if stdenv.is64bit then ''copyL("$ENV{out}/bin/gephi64.exe", "$ENV{out}/bin/gephi.exe");'' else ''unlinkL("$ENV{out}/bin/gephi64.exe");'' }
  '' else ''
    cp -r modules/application/target/gephi $out

    # remove garbage
    find $out -type f -name  .lastModified -delete
    find $out -type f -regex '.+\.exe'     -delete

    # use self-compiled JOGL to avoid patchelf'ing .so inside jars
    rm $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-{jogl,gluegen}/*.jar
    cp ${javaPackages.jogl_2_3_2}/share/java/jogl*.jar $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-jogl/
    cp ${javaPackages.jogl_2_3_2}/share/java/glue*.jar $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-gluegen/

    echo "jdkhome=${jdk}" >> $out/etc/gephi.conf
  '';

  passthru.deps = deps;

  meta = with stdenv.lib; {
    description = "A platform for visualizing and manipulating large graphs";
    homepage = https://gephi.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.taeer ];
    platforms = [ "x86_64-linux" "x86_64-windows" "i686-windows" ];
  };
}
