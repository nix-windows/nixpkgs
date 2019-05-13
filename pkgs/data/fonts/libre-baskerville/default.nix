{ lib, fetchFromGitHub }:

fetchFromGitHub rec {
  name = "libre-baskerville-1.000";

  owner = "impallari";
  repo = "Libre-Baskerville";
  rev = "2fba7c8e0a8f53f86efd3d81bc4c63674b0c613f";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/truetype $out/share/doc/${name}
    cp *.ttf                 $out/share/fonts/truetype
    cp README.md FONTLOG.txt $out/share/doc/${name}
  '';

  sha256 = "0arlq89b3vmpw3n4wbllsdvqblhz6p09dm19z1cndicmcgk26w2a";

  meta = with lib; {
    description = "A webfont family optimized for body text";
    longDescription = ''
      Libre Baskerville is a webfont family optimized for body text. It's Based
      on 1941 ATF Baskerville Specimens but it has a taller x-height, wider
      counters and less contrast that allow it to work on small sizes in any
      screen.
    '';
    homepage = http://www.impallari.com/projects/overview/libre-baskerville;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
