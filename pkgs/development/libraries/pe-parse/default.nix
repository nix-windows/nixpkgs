{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "pe-parse-${version}";
  version = "2018-10-16";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pe-parse";
    rev = "724247d321598a50bb9223997c3f297c444228d7";
    sha256 = "08dqqk7k8i29am5m54a6plx0vsslx9y7j5gf4yzzgb3q4xv2irnj";
  };

  nativeBuildInputs = [ cmake ];

  buildPhase = ''
    mkdirL("build");                                                                                             # -\
    chdir("build");                                                                                              #   >- TODO: cmake setup hook should handle this
    system("cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ENV{out} $ENV{cmakeFlags} ..") == 0 or die; # -/
  '';

  installPhase = ''
    system("nmake install") == 0 or die;
  '';

  meta = with lib; {
    description = "Principled, lightweight C/C++ PE parser";
    homepage = https://github.com/trailofbits/pe-pasrse;
    license = licenses.mit;
    platforms = platforms.windows;
  };
}
