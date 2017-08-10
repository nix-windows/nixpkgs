{ stdenv, fetchzip, mkfontdir, mkfontscale }:

fetchzip {
  name = "uni-vga";

  url = http://www.inp.nsk.su/~bolkhov/files/fonts/univga/uni-vga.tgz;

  postFetch = ''
    tar -xzf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts
    cp *.bdf $out/share/fonts
    cd $out/share/fonts
    ${mkfontdir}/bin/mkfontdir
    ${mkfontscale}/bin/mkfontscale
  '';

  sha256 = "0rfly7r6blr2ykxlv0f6my2w41vvxcw85chspljd2p1fxlr28jd7";

  meta = {
    description = "Unicode VGA font";
    maintainers = [stdenv.lib.maintainers.ftrvxmtrx];
    homepage = http://www.inp.nsk.su/~bolkhov/files/fonts/univga/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
