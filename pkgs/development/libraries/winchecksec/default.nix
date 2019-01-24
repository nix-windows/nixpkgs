{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "winchecksec-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "winchecksec";
    rev = version;
    sha256 = "0jlpvdfya4ap64802rmq9s0q315y66agsd2n5a0dn1mb17ykgb2f";
  };

  nativeBuildInputs = [ cmake ];

  configurePhase = ''
    mkdirL("build");                                                            # -\
    chdir("build");                                                             #   >- TODO: cmake setup hook should handle this
    system("cmake -DCMAKE_BUILD_TYPE=Release $ENV{cmakeFlags} ..") == 0 or die; # -/
  '';

  buildPhase = ''
    system("cmake --build .") == 0 or die;
  '';

  installPhase = ''
    make_pathL("$ENV{out}/bin") or die;
    copyL("winchecksec.exe", "$ENV{out}/bin/winchecksec.exe") or die;
  '';

  meta = with lib; {
    description = "Checksec, but for Windows";
    homepage = https://blog.trailofbits.com/2018/09/26/effortless-security-feature-detection-with-winchecksec/;
    license = licenses.mit;
    platforms = platforms.windows;
  };
}
