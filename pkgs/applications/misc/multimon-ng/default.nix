{ stdenv, fetchFromGitHub, qt4, qmake4Hook, libpulseaudio }:
let
  version = "1.1.6";
in
stdenv.mkDerivation {
  name = "multimon-ng-${version}";

  src = fetchFromGitHub {
    owner = "EliasOenal";
    repo = "multimon-ng";
    rev = "${version}";
    sha256 = "1a166mh73x77yrrnhhhzk44qrkgwav26vpidv1547zj3x3m8p0bm";
  };

  buildInputs = [ qt4 libpulseaudio ];

  nativeBuildInputs = [ qmake4Hook ];

  qmakeFlags = [ "multimon-ng.pro" ];

  installPhase = ''
    mkdir -p $out/bin
    cp multimon-ng $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Multimon is a digital baseband audio protocol decoder";
    longDescription = ''
      multimon-ng a fork of multimon, a digital baseband audio
      protocol decoder for common signaling modes in commercial and
      amateur radio data services. It decodes the following digital
      transmission modes:

      POCSAG512 POCSAG1200 POCSAG2400 EAS UFSK1200 CLIPFSK AFSK1200
      AFSK2400 AFSK2400_2 AFSK2400_3 HAPN4800 FSK9600 DTMF ZVEI1 ZVEI2
      ZVEI3 DZVEI PZVEI EEA EIA CCIR MORSE CW
    '';
    homepage = https://github.com/EliasOenal/multimon-ng;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ the-kenny ];
  };
}
