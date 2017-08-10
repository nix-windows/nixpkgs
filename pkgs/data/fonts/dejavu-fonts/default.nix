{fetchFromGitHub, stdenv, fontforge, perl, FontTTF, libfaketime}:

let
  version = "2.37";
  full = stdenv.mkDerivation {
    name = "dejavu-fonts-full-${version}";
    buildInputs = [fontforge perl FontTTF];

    src = fetchFromGitHub {
      owner = "dejavu-fonts";
      repo = "dejavu-fonts";
      rev = "version_${stdenv.lib.replaceStrings ["."] ["_"] version}";
      sha256 = "1xknlg2h287dx34v2n5r33bpcl4biqf0cv7nak657rjki7s0k4bk";
    };

    buildFlags = "full-ttf";

    preBuild = "patchShebangs scripts";

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp build/*.ttf $out/share/fonts/truetype/
    '';

    LD_PRELOAD = "${libfaketime}/lib/libfaketime.so.1";
    FAKETIME = "1970-01-01 00:00:01";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0rhkfx2fin2k9wi000s2f8cgmb8yp5f3372fvb0d1nz137rl7sqk";

    meta = {
      description = "A typeface family based on the Bitstream Vera fonts";
      longDescription = ''
        The DejaVu fonts are TrueType fonts based on the BitStream Vera fonts,
        providing more styles and with greater coverage of Unicode.

        This package includes DejaVu Sans, DejaVu Serif, DejaVu Sans Mono, and
        the TeX Gyre DejaVu Math font.
      '';
      homepage = http://dejavu-fonts.org/wiki/Main_Page;

      # Copyright (c) 2003 by Bitstream, Inc. All Rights Reserved.
      # Copyright (c) 2006 by Tavmjong Bah. All Rights Reserved.
      # DejaVu changes are in public domain
      # See http://dejavu-fonts.org/wiki/License for details
      license = stdenv.lib.licenses.free;

      platforms = stdenv.lib.platforms.unix;
    };
  };

  minimal = stdenv.mkDerivation {
    name = "dejavu-fonts-minimal-${version}";
    buildCommand = ''
      install -D ${full}/share/fonts/truetype/DejaVuSans.ttf $out/share/fonts/truetype/DejaVuSans.ttf
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0p0zb6ia9qfxck5zqlr0n7c6yn80fcqgflxiqbhvc0fk5i3d8dpw";
  };
in stdenv.mkDerivation {
  name = "dejavu-fonts-${version}";
  buildCommand = ''
    mkdir -p $out/share/fonts/truetype
    cp ${full}/share/fonts/truetype/*.ttf $out/share/fonts/truetype/
    ln -s --force ${minimal}/share/fonts/truetype/DejaVuSans.ttf $out/share/fonts/truetype/DejaVuSans.ttf
  '';
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1dc1l4zm36qjpfm2b6licpv67967c24gisailcx4nf2snfxf4w4f";

  passthru.full = full;
  passthru.minimal = minimal;
}
