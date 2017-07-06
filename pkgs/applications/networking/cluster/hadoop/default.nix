{ stdenv, fetchurl, makeWrapper, pkgconfig, which, maven, cmake, jre, bash, coreutils, glibc, protobuf2_5, fuse, snappy, zlib, bzip2, openssl }:


let
  common = { version, tomcat-version, src-sha256, maven-dependencies-sha256, tomcat-sha256 }:
    let
      # compile the hadoop tarball from sources, it requires some patches
      binary-distributon = stdenv.mkDerivation rec {
        name = "hadoop-${version}-bin";
        src = fetchurl {
          url = "mirror://apache/hadoop/common/hadoop-${version}/hadoop-${version}-src.tar.gz";
          sha256 = src-sha256;
        };
        tomcat-tar-gz = fetchurl {
          url = "mirror://apache/tomcat/tomcat-6/v${tomcat-version}/bin/apache-tomcat-${tomcat-version}.tar.gz";
          sha256 = tomcat-sha256;
        };

        # perform fake build to make a fixed-output derivation of dependencies downloaded from maven central (~100Mb in ~3000 files)
        fetched-maven-deps = stdenv.mkDerivation {
          name = "hadoop-${version}-maven-deps";
          inherit src nativeBuildInputs buildInputs configurePhase mavenFlags;
          buildPhase = ''
            while timeout --kill-after=21m 20m mvn package -Dmaven.repo.local=$out/.m2 ${mavenFlags}; [ $? = 124 ]; do
              echo "maven hangs while downloading :("
            done
          '';
          installPhase = ''find $out/.m2 -type f \! -regex '.+\(pom\|jar\|xml\|sha1\)' -delete''; # delete files with lastModified timestamps inside
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
          outputHash = maven-dependencies-sha256;
        };

        nativeBuildInputs = [ maven cmake pkgconfig ];
        buildInputs = [ fuse snappy zlib bzip2 openssl protobuf2_5 ];
        # assume that bash and coreutils are on $PATH
        postPatch = ''
          substituteInPlace hadoop-common-project/hadoop-common/src/main/java/org/apache/hadoop/fs/HardLink.java \
            --replace '/usr/bin/stat' 'stat'
          substituteInPlace hadoop-common-project/hadoop-common/src/main/java/org/apache/hadoop/util/Shell.java \
            --replace '/bin/bash'     'bash' \
            --replace '/bin/ls'       'ls'
          substituteInPlace hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-nodemanager/src/main/java/org/apache/hadoop/yarn/server/nodemanager/DefaultContainerExecutor.java \
            --replace '/bin/bash'     'bash' \
            --replace '/bin/mv'       'mv'
          substituteInPlace hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-nodemanager/src/main/java/org/apache/hadoop/yarn/server/nodemanager/containermanager/launcher/ContainerLaunch.java \
            --replace '/bin/bash'     'bash'
          substituteInPlace hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-nodemanager/src/main/java/org/apache/hadoop/yarn/server/nodemanager/DefaultContainerExecutor.java \
            --replace '/bin/mv'       'mv'
          substituteInPlace hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-nodemanager/src/main/java/org/apache/hadoop/yarn/server/nodemanager/DockerContainerExecutor.java \
            --replace '/bin/mv'       'mv'
          substituteInPlace hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-core/src/main/java/org/apache/hadoop/mapreduce/MRJobConfig.java \
            --replace '/bin/bash'     'bash'
        '';
        configurePhase = "true"; # do not trigger cmake hook
        mavenFlags = "-Drequire.snappy -Drequire.bzip2 -DskipTests -Pdist,native -e";
        buildPhase = ''
          # prevent download tomcat during the build
          install -D ${tomcat-tar-gz} hadoop-hdfs-project/hadoop-hdfs-httpfs/downloads/apache-tomcat-${tomcat-version}.tar.gz
          install -D ${tomcat-tar-gz} hadoop-common-project/hadoop-kms/downloads/apache-tomcat-${tomcat-version}.tar.gz
          # 'maven.repo.local' must be writable
          mvn package --offline -Dmaven.repo.local=$(cp -dpR ${fetched-maven-deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2 ${mavenFlags}
          # remove runtime dependency on $jdk/jre/lib/amd64/server/libjvm.so
          patchelf --set-rpath ${stdenv.lib.makeLibraryPath [glibc]} hadoop-dist/target/hadoop-${version}/lib/native/libhadoop.so.1.0.0
          patchelf --set-rpath ${stdenv.lib.makeLibraryPath [glibc]} hadoop-dist/target/hadoop-${version}/lib/native/libhdfs.so.0.0.0
        '';
        installPhase = "mv hadoop-dist/target/hadoop-${version} $out";
      };
    in
      stdenv.mkDerivation rec {
        name = "hadoop-${version}";

        src = binary-distributon;

        nativeBuildInputs = [ makeWrapper ];

        installPhase = ''
          mkdir -p $out/share/doc/hadoop/
          cp -dpR * $out/
          mv $out/*.txt $out/share/doc/hadoop/

          for n in $out/bin/*; do
            wrapProgram $n \
              --prefix PATH : "${stdenv.lib.makeBinPath [ which jre bash coreutils ]}" \
              --prefix JAVA_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ openssl snappy zlib bzip2 ]}" \
              --set JAVA_HOME "${jre}" \
              --set HADOOP_PREFIX "$out"
          done
        '';

        meta = with stdenv.lib; {
          homepage = "http://hadoop.apache.org/";
          description = "Framework for distributed processing of large data sets across clusters of computers";
          license = licenses.asl20;

          longDescription = ''
            The Apache Hadoop software library is a framework that allows for
            the distributed processing of large data sets across clusters of
            computers using a simple programming model. It is designed to
            scale up from single servers to thousands of machines, each
            offering local computation and storage. Rather than rely on
            hardware to deliver high-avaiability, the library itself is
            designed to detect and handle failures at the application layer,
            so delivering a highly-availabile service on top of a cluster of
            computers, each of which may be prone to failures.
          '';
          maintainers = with maintainers; [ volth ];
          platforms = [ "x86_64-linux" ];
        };
      };
in {
  hadoop_2_7 = common {
    version = "2.7.3";
    tomcat-version = "6.0.44";
    src-sha256 = "0m1hps3czp8v1a8h371wf04s4y4hs02v74s3sv7zhviydvf8axr2";
    maven-dependencies-sha256 = {
      "apache-maven-3.5.0" = "0rkfzc1qka0m61akikg3g6qy53agqchw03vrm1cv6ssxbrmy5686"; # dependencies include Maven plugins so the hash depends on Maven version
    }.${maven.name};
    tomcat-sha256 = "0942f0ss6w9k23xg94nir2dbbkqrqp5k628jflk51ikm5qr95dxa";
  };
  hadoop_2_8 = common {
    version = "2.8.0";
    tomcat-version = "6.0.48";
    src-sha256 = "1m68i01l5jv3bkjwc3sjpav1xpycnkzc6lxdkdm00jijy6jskdkp";
    maven-dependencies-sha256 = {
      "apache-maven-3.5.0" = "1cpk2jacmxwcq7rm32y7znlx97nwakf5jivx73v0wafir7cf2hvw"; # dependencies include Maven plugins so the hash depends on Maven version
    }.${maven.name};
    tomcat-sha256 = "1w4jf28g8p25fmijixw6b02iqlagy2rvr57y3n90hvz341kb0bbc";
  };
}