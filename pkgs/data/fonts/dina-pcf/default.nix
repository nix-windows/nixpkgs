{stdenv, fetchzip, bdftopcf, mkfontdir, mkfontscale}:

let
  version = "2.92";
in fetchzip rec {
  name = "dina-font-pcf-${version}";

  url = "http://www.donationcoder.com/Software/Jibz/Dina/downloads/Dina.zip";

  postFetch = ''
    unzip -j $downloadedFile

    sed -i 's/microsoft-cp1252/ISO8859-1/' *.bdf

    _get_font_size() {
      _pt=$\{1%.bdf}
      _pt=$\{_pt#*-}
      echo $_pt
    }

    for i in Dina_i400-*.bdf; do
        ${bdftopcf}/bin/bdftopcf -t -o DinaItalic$(_get_font_size $i).pcf $i
    done
    for i in Dina_i700-*.bdf; do
        ${bdftopcf}/bin/bdftopcf -t -o DinaBoldItalic$(_get_font_size $i).pcf $i
    done
    for i in Dina_r400-*.bdf; do
        ${bdftopcf}/bin/bdftopcf -t -o DinaMedium$(_get_font_size $i).pcf $i
    done
    for i in Dina_r700-*.bdf; do
        ${bdftopcf}/bin/bdftopcf -t -o DinaBold$(_get_font_size $i).pcf $i
    done
    gzip -n *.pcf

    fontDir="$out/share/fonts/misc"
    mkdir -p "$fontDir"
    mv *.pcf.gz "$fontDir"

    cd "$fontDir"
    ${mkfontdir}/bin/mkfontdir
    ${mkfontscale}/bin/mkfontscale
  '';

  sha256 = "0v0qn5zwq4j1yx53ypg6w6mqx6dk8l1xix0188b0k4z3ivgnflyb";

  meta = with stdenv.lib; {
    description = "A monospace bitmap font aimed at programmers";
    longDescription = ''
      Dina is a monospace bitmap font, primarily aimed at programmers. It is
      relatively compact to allow a lot of code on screen, while (hopefully)
      clear enough to remain readable even at high resolutions.
    '';
    homepage = https://www.donationcoder.com/Software/Jibz/Dina/;
    downloadPage = https://www.donationcoder.com/Software/Jibz/Dina/;
    license = licenses.free;
    maintainers = [ maintainers.prikhi ];
    platforms = platforms.unix;
  };
}
