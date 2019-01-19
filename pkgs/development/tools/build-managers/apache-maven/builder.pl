require "$ENV{stdenv}/setup.pm";

unpackPhase();

dircopy($ENV{name}, "$ENV{out}/maven");

# better make a .exe wrapper
if (0) {
  writeFile("$ENV{out}/bin/mvn.cmd", "set JAVA_HOME=$ENV{jdk}\r\n$ENV{out}\\maven\\bin\\mvn.cmd %*\r\n");
} else {
  make_pathL("$ENV{out}/bin");
  system("makeWrapper", "$ENV{out}/maven/bin/mvn.cmd", "$ENV{out}/bin/mvn.exe", "--set", "JAVA_HOME", $ENV{jdk});
}

## Add the maven-axis and JIRA plugin by default when using maven 1.x
#if [ -e $out/maven/bin/maven ]
#then
#  export OLD_HOME=$HOME
#  export HOME=.
#  $out/maven/bin/maven plugin:download -DgroupId=maven-plugins -DartifactId=maven-axis-plugin -Dversion=0.7
#  export HOME=OLD_HOME
#fi
