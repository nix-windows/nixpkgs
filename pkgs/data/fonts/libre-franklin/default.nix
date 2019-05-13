{ lib, fetchFromGitHub }:

fetchFromGitHub rec {
  name = "libre-franklin-1.014";

  owner = "impallari";
  repo = "Libre-Franklin";
  rev = "006293f34c47bd752fdcf91807510bc3f91a0bd3";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/opentype $out/share/doc/${name}
    cp */OTF/*.otf            $out/share/fonts/opentype
    cp README.md FONTLOG.txt  $out/share/doc/${name}
  '';

  sha256 = "1rkjp8x62cn4alw3lp7m45q34bih81j2hg15kg5c1nciyqq1qz0z";

  meta = with lib; {
    description = "A reinterpretation and expansion based on the 1912 Morris Fuller Benton’s classic.";
    homepage = https://github.com/impallari/Libre-Franklin;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
