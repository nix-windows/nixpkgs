{ lib, stdenv, fetchFromGitHub, cmake, eigen, suitesparse, libGLU, qt5
, libsForQt5, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "g2o";
  version = "unstable-2019-04-07";

  src = fetchFromGitHub {
    owner = "RainerKuemmerle";
    repo = pname;
    rev = "9b41a4ea5ade8e1250b9c1b279f3a9c098811b5a";
    sha256 = "1rgrz6zxiinrik3lgwgvsmlww1m2fnpjmvcx1mf62xi1s2ma5w2i";
  };

  # Removes a reference to gcc that is only used in a debug message
  patches = [ ./remove-compiler-reference.patch ];

  separateDebugInfo = true;

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ eigen suitesparse libGLU qt5.qtbase libsForQt5.libqglviewer ];

  # Silence noisy warning
  CXXFLAGS = "-Wno-deprecated-copy";

  cmakeFlags = [
    # Detection script is broken
    "-DQGLVIEWER_INCLUDE_DIR=${libsForQt5.libqglviewer}/include/QGLViewer"
    "-DG2O_BUILD_EXAMPLES=OFF"
  ] ++ lib.optionals stdenv.isx86_64 [
    "-DDO_SSE_AUTODETECT=OFF"
    "-DDISABLE_SSE3=${  if stdenv.hostPlatform.sse3Support   then "OFF" else "ON"}"
    "-DDISABLE_SSE4_1=${if stdenv.hostPlatform.sse4_1Support then "OFF" else "ON"}"
    "-DDISABLE_SSE4_2=${if stdenv.hostPlatform.sse4_2Support then "OFF" else "ON"}"
    "-DDISABLE_SSE4_A=${if stdenv.hostPlatform.sse4_aSupport then "OFF" else "ON"}"
  ];

  postInstall = ''
    wrapProgram $out/bin/g2o_viewer \
      --prefix QT_PLUGIN_PATH : "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}"
  '';

  meta = {
    description = "A General Framework for Graph Optimization";
    homepage = "https://github.com/RainerKuemmerle/g2o";
    license = with lib.licenses; [ bsd3 lgpl3 gpl3 ];
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.all;
  };
}
