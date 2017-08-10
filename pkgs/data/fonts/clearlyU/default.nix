{ stdenv, fetchzip, mkfontdir, mkfontscale }:

fetchzip {
  name = "clearlyU-12-1.9";

  url = http://www.math.nmsu.edu/~mleisher/Software/cu/cu12-1.9.tgz;

  postFetch = ''
    mkdir -p $out/share/fonts
    cd $out/share/fonts
    tar -xzvf $downloadedFile --strip-components=1
    ${mkfontdir}/bin/mkfontdir
    ${mkfontscale}/bin/mkfontscale
  '';

  sha256 = "127zrg65s90ksj99kr9hxny40rbxvpai62mf5nqk853hcd1bzpr6";

  meta = {
    description = "A Unicode font";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
