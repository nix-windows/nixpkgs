{ stdenv, fetchzip, mkfontdir, mkfontscale }:

fetchzip rec {
  name = "envypn-font-1.7.1";

  url = "https://ywstd.fr/files/p/envypn-font/${name}.tar.gz";

  postFetch = ''
    tar -xzf $downloadedFile --strip-components=1

    # install the pcf fonts (for xorg applications)
    fontDir="$out/share/fonts/envypn"
    mkdir -p "$fontDir"
    mv *.pcf.gz "$fontDir"

    cd "$fontDir"
    ${mkfontdir}/bin/mkfontdir
    ${mkfontscale}/bin/mkfontscale
  '';

  sha256 = "04sjxfrlvjc2f0679cy4w366mpzbn3fp6gnrjb8vy12vjd1ffnc1";

  meta = with stdenv.lib; {
    description = ''
      Readable bitmap font inspired by Envy Code R
    '';
    homepage = "http://ywstd.fr/p/pj/#envypn";
    license = licenses.miros;
    platforms = platforms.linux;
  };
}
