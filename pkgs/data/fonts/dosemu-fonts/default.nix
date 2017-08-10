{ stdenv, fetchzip, bdftopcf, mkfontdir, mkfontscale }:

let
  version = "1.4.0";
in fetchzip {
  name = "dosemu-fonts-${version}";

  url = "mirror://sourceforge/dosemu/dosemu-${version}.tgz";

  postFetch = ''
    tar xf "$downloadedFile" --anchored --wildcards '*/etc/*.bdf' '*/etc/dosemu.alias'
    fontPath="$out/share/fonts/X11/misc/dosemu"
    mkdir -p "$fontPath"
    for i in */etc/*.bdf; do
      fontOut="$out/share/fonts/X11/misc/dosemu/$(basename "$i" .bdf).pcf.gz"
      echo -n "Installing font $fontOut..." >&2
      ${bdftopcf}/bin/bdftopcf $i | gzip -c -9 -n > "$fontOut"
      echo " done." >&2
    done
    cp */etc/dosemu.alias "$fontPath/fonts.alias"
    cd "$fontPath"
    ${mkfontdir}/bin/mkfontdir
    ${mkfontscale}/bin/mkfontscale
  '';

  sha256 = "1miqv0ral5vazx721wildjlzvji5r7pbgm39c0cpj5ywafaikxr8";

  meta = {
    description = "Various fonts from the DOSEmu project";
    platforms = stdenv.lib.platforms.linux;
  };
}
