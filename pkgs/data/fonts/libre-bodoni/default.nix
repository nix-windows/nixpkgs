{ lib, fetchFromGitHub }:

fetchFromGitHub rec {
  name = "libre-bodoni-2.000";

  owner = "impallari";
  repo = "Libre-Bodoni";
  rev = "995a40e8d6b95411d660cbc5bb3f726ffd080c7d";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/opentype $out/share/doc/${name}
    cp */OTF/*.otf            $out/share/fonts/opentype
    cp README.md FONTLOG.txt  $out/share/doc/${name}
  '';

  sha256 = "0pnb1xydpvcl9mkz095f566kz7yj061wbf40rwrbwmk706f6bsiw";

  meta = with lib; {
    description = "Bodoni fonts adapted for today's web requirements";
    longDescription = ''
      The Libre Bodoni fonts are based on the 19th century Morris Fuller
      Benton's ATF design, but specifically adapted for today's web
      requirements.

      They are a perfect choice for everything related to elegance, style,
      luxury and fashion.

      Libre Bodoni currently features four styles: Regular, Italic, Bold and
      Bold Italic.
    '';
    homepage = https://github.com/impallari/Libre-Bodoni;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
