{ stdenv, fetchurl, cmake, fetchFromGitHub }:

if stdenv.hostPlatform.isMicrosoft then

stdenv.mkDerivation rec {
  name = "expat-2.2.6";

  src = fetchFromGitHub {
    owner = "libexpat";
    repo = "libexpat";
    rev = "R_2_2_6";
    sha256 = "0jfp38d84p6ysl5pb0v28j766g1psxc42s0aagl3i5p2rw1kgba2";
  };

  nativeBuildInputs = [ cmake ];
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
