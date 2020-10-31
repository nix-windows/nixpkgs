{ stdenv, fetchurl, cmake, fetchFromGitHub, static ? false }:

if stdenv.hostPlatform.isWindows then

stdenv.mkDerivation rec {
  name = "expat-2.2.6";

  src = fetchFromGitHub {
    owner = "libexpat";
    repo = "libexpat";
    rev = "R_2_2_6";
    sha256 = "0jfp38d84p6ysl5pb0v28j766g1psxc42s0aagl3i5p2rw1kgba2";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-DBUILD_shared=${if static then "OFF" else "ON"}" ];
  buildPhase = ''
    mkdir('build');
    chdir('build');
    system("cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ENV{out} $ENV{cmakeFlags} ../expat") == 0 or die;
    system("nmake") == 0 or die;
  '';
  doCheck = true;
  checkPhase = ''
    system("nmake test") == 0 or die;
  '';
  installPhase = ''
    system("nmake install") == 0 or die;
  '' + stdenv.lib.optionalString static ''
    changeFile { "#define XML_STATIC 1\n".$_ } "$ENV{out}/include/expat_external.h";
  '';
}

else

stdenv.mkDerivation rec {
  name = "expat-2.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/expat/${name}.tar.bz2";
    sha256 = "1wl1x93b5w457ddsdgj0lh7yjq4q6l7wfbgwhagkc8fm2qkkrd0p";
  };

  outputs = [ "out" "dev" ]; # TODO: fix referrers
  outputBin = "dev";

  configureFlags = stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  outputMan = "dev"; # tiny page for a dev tool

  doCheck = true; # not cross;

  preCheck = ''
    patchShebangs ./run.sh
    patchShebangs ./test-driver-wrapper.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://www.libexpat.org/;
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
  };
}
