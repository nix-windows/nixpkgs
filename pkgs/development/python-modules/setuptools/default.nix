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
      #chmod 0666, 'setuptools/msvc.py'          or die $!;
      #utime undef, undef, 'setuptools\msvc.py'  or die $!; # touch to make timestamp newer than 1980
  installPhase = if stdenv.hostPlatform.isMicrosoft then ''

      # no need to read the registry, we know which compiler has been used to build python.exe
      my $content = readFile('${./msvc.py}');
      $content =~ s|\@\@cc\@\@|${               builtins.replaceStrings [''/'' ''\''] [''\\'' ''\\''] "${stdenv.cc}"}|g;
      $content =~ s|\@\@msvc\@\@|${             builtins.replaceStrings [''/'' ''\''] [''\\'' ''\\''] "${stdenv.cc.msvc}"}|g;
      $content =~ s|\@\@msvc-version\@\@|${     builtins.replaceStrings [''/'' ''\''] [''\\'' ''\\''] "${stdenv.cc.msvc.version}"}|g;
      $content =~ s|\@\@sdk\@\@|${              builtins.replaceStrings [''/'' ''\''] [''\\'' ''\\''] "${stdenv.cc.sdk}"}|g;
      $content =~ s|\@\@sdk-version\@\@|${      builtins.replaceStrings [''/'' ''\''] [''\\'' ''\\''] "${stdenv.cc.sdk.version}"}|g;
      $content =~ s|\@\@msbuild\@\@|${          builtins.replaceStrings [''/'' ''\''] [''\\'' ''\\''] "${stdenv.cc.msbuild}"}|g;
      $content =~ s|\@\@msbuild-version\@\@|${  builtins.replaceStrings [''/'' ''\''] [''\\'' ''\\''] "${stdenv.cc.msbuild.version}"}|g;
      $content =~ s|\@\@buildplatform\@\@|${ if stdenv.buildPlatform.is64bit then "x64" else "x86"}|g;
      $content =~ s|\@\@hostplatform\@\@|${  if stdenv.hostPlatform.is64bit  then "x64" else "x86"}|g;
      writeFile('setuptools/msvc.py', $content);


      # copy-paste from msvc-build-launcher.cmd
      system('cl /D "GUI=0" /D "WIN32_LEAN_AND_MEAN" launcher.c /O2 /link /MACHINE:x64 /SUBSYSTEM:CONSOLE /out:setuptools/cli-64.exe');
      system('cl /D "GUI=1" /D "WIN32_LEAN_AND_MEAN" launcher.c /O2 /link /MACHINE:x64 /SUBSYSTEM:WINDOWS /out:setuptools/gui-64.exe');
      copyL 'setuptools/cli-32.exe', 'setuptools/cli.exe';
      copyL 'setuptools/gui-32.exe', 'setuptools/gui.exe';

      make_pathL "$ENV{out}/${python.sitePackages}";
      $ENV{PYTHONPATH}="$ENV{out}/${python.sitePackages};$ENV{PYTHONPATH}";
      system("${python.interpreter} setup.py install --prefix=$ENV{out}") == 0 or die;


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
