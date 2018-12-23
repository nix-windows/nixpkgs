{ stdenv
, fetchPypi
, python
, wrapPython
, unzip
}:

# Should use buildPythonPackage here somehow
stdenv.mkDerivation rec {
  pname = "setuptools";
  version = "40.6.3";
  name = "${python.libPrefix}-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1y085dnk574sxw9aymdng9gijvrsbw86hsv9hqnhv7y4d6nlsirv";
  };

  nativeBuildInputs = stdenv.lib.optionals (!stdenv.hostPlatform.isMicrosoft) [ wrapPython unzip ];
  buildInputs = [ python ];
  doCheck = false;  # requires pytest
  installPhase = if stdenv.hostPlatform.isMicrosoft then ''
      # copy-paste from msvc-build-launcher.cmd
      system('cl /D "GUI=0" /D "WIN32_LEAN_AND_MEAN" launcher.c /O2 /link /MACHINE:x64 /SUBSYSTEM:CONSOLE /out:setuptools/cli-64.exe');
      system('cl /D "GUI=1" /D "WIN32_LEAN_AND_MEAN" launcher.c /O2 /link /MACHINE:x64 /SUBSYSTEM:WINDOWS /out:setuptools/gui-64.exe');
      copy 'setuptools/cli-32.exe', 'setuptools/cli.exe';
      copy 'setuptools/gui-32.exe', 'setuptools/gui.exe';

      make_path "$ENV{out}/${python.sitePackages}";
      $ENV{PYTHONPATH}="$ENV{out}/${python.sitePackages};$ENV{PYTHONPATH}";
      system("${python.interpreter} setup.py install --prefix=$ENV{out}");

      # poor man's wrapPythonPrograms (until it is clear what wrapPythonPrograms should do on Windows)
      my @extrapaths = ("$ENV{out}/${python.sitePackages}");
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
  '' else ''
      dst=$out/${python.sitePackages}
      mkdir -p $dst
      export PYTHONPATH="$dst:$PYTHONPATH"
      ${python.interpreter} setup.py install --prefix=$out
      wrapPythonPrograms
  '';

  pythonPath = [];

  meta = with stdenv.lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = https://pypi.python.org/pypi/setuptools;
    license = with licenses; [ psfl zpl20 ];
    platforms = python.meta.platforms;
    priority = 10;
  };
}
