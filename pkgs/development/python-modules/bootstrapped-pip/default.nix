{ stdenv, python, fetchPypi, makeWrapper, unzip, setuptools }:

if stdenv.hostPlatform.isMicrosoft then

stdenv.mkDerivation rec {
  pname = "pip";
  version = "18.1";
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "188fclay154s520n43s7cxxlhdaiysvxf19zk8vr1xbyjyyr58n0";
  };

# buildInputs = [ python ];

  installPhase = ''
    make_path "$ENV{out}/${python.sitePackages}";
    $ENV{PYTHONPATH}="$ENV{out}/${python.sitePackages};${setuptools}/${python.sitePackages};$ENV{PYTHONPATH}";
    system("${python.interpreter} setup.py install --prefix=$ENV{out}");

    # poor man's wrapPythonPrograms (until it is clear what wrapPythonPrograms should do on Windows)
    my @extrapaths = ("$ENV{out}/${python.sitePackages}", '${setuptools}/${python.sitePackages}');
    my $newline = "import site;import functools;functools.reduce(lambda k, p: site.addsitedir(p, k), ['".
                  join("','", map { s|\\|/|rg } @extrapaths).
                  "'], site._init_pathinfo());";
    for my $filename (glob("$ENV{out}/Scripts/*.py")) {
      open(my $fh, $filename);
      my @newlines = map { /^# EASY-INSTALL-ENTRY-SCRIPT/ ?  "$_\n$newline\n\n" : $_ } <$fh>;
      open(my $fh2, ">$filename");
      print $fh2 @newlines;
      close($fh2);
    }
  '';
}

else

let
  wheel_source = fetchPypi {
    pname = "wheel";
    version = "0.32.2";
    format = "wheel";
    sha256 = "1216licil12jjixfqvkb84xkync5zz0fdc2kgzhl362z3xqjsgn9";
  };
  setuptools_source = fetchPypi {
    pname = "setuptools";
    version = "40.6.3";
    format = "wheel";
    sha256 = "02yx9g0k48k20kfamwp8bjv8w05mramhl0gd65xcyd1ghfdcxhg2";
  };

in stdenv.mkDerivation rec {
  pname = "pip";
  version = "18.1";
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "7909d0a0932e88ea53a7014dfd14522ffef91a464daaaf5c573343852ef98550";
  };

  unpackPhase = ''
    mkdir -p $out/${python.sitePackages}
    unzip -d $out/${python.sitePackages} $src
    unzip -d $out/${python.sitePackages} ${setuptools_source}
    unzip -d $out/${python.sitePackages} ${wheel_source}
  '';

  patchPhase = ''
    mkdir -p $out/bin
  '';

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ python ];

  installPhase = ''

    # install pip binary
    echo '#!${python.interpreter}' > $out/bin/pip
    echo 'import sys;from pip._internal import main' >> $out/bin/pip
    echo 'sys.exit(main())' >> $out/bin/pip
    chmod +x $out/bin/pip

    # wrap binaries with PYTHONPATH
    for f in $out/bin/*; do
      wrapProgram $f --prefix PYTHONPATH ":" $out/${python.sitePackages}/
    done
  '';
}
