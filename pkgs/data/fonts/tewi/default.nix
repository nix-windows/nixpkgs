{stdenv, fetchzip, bdftopcf, mkfontdir, mkfontscale}:

let
  date = "2015-06-07";
in fetchzip rec {
  name = "tewi-font-${date}";

  url = "https://github.com/lucy/tewi-font/archive/ff930e66ae471da4fdc226ffe65fd1ccd13d4a69.zip";

  postFetch = ''
    unzip -j $downloadedFile

    for i in *.bdf; do
       ${bdftopcf}/bin/bdftopcf -o ''${i/bdf/pcf} $i
    done

    gzip -n *.pcf

    fontDir="$out/share/fonts/misc"
    mkdir -p "$fontDir"
    mv *.pcf.gz "$fontDir"

    cd "$fontDir"
    ${mkfontdir}/bin/mkfontdir
    ${mkfontscale}/bin/mkfontscale
  '';

  sha256 = "14dv3m1svahjyb9c1x1570qrmlnynzg0g36b10bqqs8xvhix34yq";

  meta = with stdenv.lib; {
    description = "A nice bitmap font, readable even at small sizes";
    longDescription = ''
      Tewi is a bitmap font, readable even at very small font sizes. This is
      particularily useful while programming, to fit a lot of code on your
      screen.
    '';
    homepage = "https://github.com/lucy/tewi-font";
    license = {
      fullName = "GNU General Public License with a font exception";
      url = "https://www.gnu.org/licenses/gpl-faq.html#FontException";
    };
    maintainers = [ maintainers.fro_ozen ];
    platforms = platforms.unix;
  };
}
