{ lib, fetchFromGitHub }:

let
  pname = "office-code-pro";
  version = "1.004";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "nathco";
  repo = "Office-Code-Pro";
  rev = version;

  postFetch = ''
    tar xf $downloadedFile --strip=1
    fontDir=$out/share/fonts/opentype
    docDir=$out/share/doc/${name}
    mkdir -p $fontDir $docDir
    install -Dm644 README.md $docDir
    install -t $fontDir -m644 'Fonts/Office Code Pro/OTF/'*.otf
    install -t $fontDir -m644 'Fonts/Office Code Pro D/OTF/'*.otf
  '';
  sha256 = "1bagwcaicn6q8qkqazz6wb3x30y4apmkga0mkv8fh6890hfhywr9";

  meta = with lib; {
    description = "A customized version of Source Code Pro";
    longDescription = ''
      Office Code Pro is a customized version of Source Code Pro, the monospaced
      sans serif originally created by Paul D. Hunt for Adobe Systems
      Incorporated. The customizations were made specifically for text editors
      and coding environments, but are still very usable in other applications.
    '';
    homepage = https://github.com/nathco/Office-Code-Pro;
    license = licenses.ofl;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
