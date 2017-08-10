{stdenv, fetchurl, fontforge, python2, libfaketime}:

let
  inherit (python2.pkgs) fonttools;

  common =
    {version, url, sha256, buildInputs, outputHash}:
    stdenv.mkDerivation rec {
      name = "liberation-fonts-${version}";
      src = fetchurl {
        inherit url sha256;
      };

      inherit buildInputs;

      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp -v $( find . -name '*.ttf') $out/share/fonts/truetype

        mkdir -p "$out/share/doc/${name}"
        cp -v AUTHORS ChangeLog COPYING License.txt README "$out/share/doc/${name}" || true
      '';

      LD_PRELOAD = "${libfaketime}/lib/libfaketime.so.1";
      FAKETIME = "1970-01-01 00:00:01";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      inherit outputHash;

      meta = with stdenv.lib; {
        description = "Liberation Fonts, replacements for Times New Roman, Arial, and Courier New";
        longDescription = ''
          The Liberation Fonts are intended to be replacements for the three most
          commonly used fonts on Microsoft systems: Times New Roman, Arial, and
          Courier New. Since 2012 they are based on croscore fonts.

          There are three sets: Sans (a substitute for Arial, Albany, Helvetica,
          Nimbus Sans L, and Bitstream Vera Sans), Serif (a substitute for Times
          New Roman, Thorndale, Nimbus Roman, and Bitstream Vera Serif) and Mono
          (a substitute for Courier New, Cumberland, Courier, Nimbus Mono L, and
          Bitstream Vera Sans Mono).
        '';

        license = licenses.ofl;
        homepage = https://pagure.io/liberation-fonts/;
        maintainers = [
          maintainers.raskin
        ];
        platforms = platforms.unix;
      };
    };

in {
  liberation_ttf_v1_from_source = common rec {
    version = "1.07.4";
    url = "https://releases.pagure.org/liberation-fonts/liberation-fonts-${version}.tar.gz";
    sha256 = "01jlg88q2s6by7qv6fmnrlx0lwjarrjrpxv811zjz6f2im4vg65d";
    buildInputs = [ fontforge fonttools ];
    outputHash = "1h7zsrvs7chh07s104fym1j58fz2dykapagk99wi52xln123jvzx";
  };
  liberation_ttf_v1_binary = common rec {
    version = "1.07.4";
    url = "https://releases.pagure.org/liberation-fonts/liberation-fonts-ttf-${version}.tar.gz";
    sha256 = "0p7frz29pmjlk2d0j2zs5kfspygwdnpzxkb2hwzcfhrafjvf59v1";
    buildInputs = [ ];
    outputHash = "12gwb9b4ij9d93ky4c9ykgp03fqr62axy37pds88q7y6zgciwkab";
  };
  liberation_ttf_v2_from_source = common rec {
    version = "2.00.1";
    url = "https://releases.pagure.org/liberation-fonts/liberation-fonts-${version}.tar.gz";
    sha256 = "1ymryvd2nw4jmw4w5y1i3ll2dn48rpkqzlsgv7994lk6qc9cdjvs";
    buildInputs = [ fontforge fonttools ];
    outputHash = "1mg3pfj6q8ww9kr8kxn2nb965ldq2sh2vl9dpkxj0an0z6jdnlxp";
  };
  liberation_ttf_v2_binary = common rec {
    version = "2.00.1";
    url = "https://releases.pagure.org/liberation-fonts/liberation-fonts-ttf-${version}.tar.gz";
    sha256 = "010m4zfqan4w04b6bs9pm3gapn9hsb18bmwwgp2p6y6idj52g43q";
    buildInputs = [ ];
    outputHash = "19jky9li345zsig9pcb0rnlsjqqclh7r60vbi4pwh16f14850gpk";
  };
}
