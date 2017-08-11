{ stdenv, fetchFromGitHub, fetchpatch, lib
, autoconf, automake, gnum4, libtool, perl, gnulib, uthash, pkgconfig, gettext
, python, freetype, zlib, glib, libungif, libpng, libjpeg, libtiff, libxml2, pango
, withSpiro ? false, libspiro
, withGTK ? false, gtk2
, withPython ? true
, Carbon ? null, Cocoa ? null
}:

stdenv.mkDerivation rec {
  name = "fontforge-${version}";
  version = "20170730";
#  versionModtime = "1459728000"; # unix timestamp of ${version}
#  versionModtimeStr = "00:00 UTC 04-Apr-2016";

#  src = /etc/nixos/nixpkgs/pkgs/top-level/fontforgesrc;
  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "fontforge";
    rev = version;
    sha256 = {
      "20160404" = "15nacq84n9gvlzp3slpmfrrbh57kfb6lbdlc46i7aqgci4qv6fg0";
      "20161012" = "08wla17r8rldbax1gkf6093qkwq0q663pzkjrffkc92cn6f2kc1w";
      "20170730" = "15k6x97383p8l40jvcivalhwgbbcdg5vciyjz6m9r0lrlnjqkv99";
     }.${version};
  };

#  prePatch = ''
#    chmod u+w -R *
#  '';

  patches = [(fetchpatch {
    name = "use-system-uthash.patch";
    url = "http://pkgs.fedoraproject.org/cgit/fontforge.git/plain/"
      + "fontforge-20140813-use-system-uthash.patch?id=8bdf933";
    sha256 = "0n8i62qv2ygfii535rzp09vvjx4qf9zp5qq7qirrbzm1l9gykcjy";
  })];
  patchFlags = "-p0";

#  # fontforge's compilation timestamp leaks to font files it creates
#  # 1970-01-01 won't work here because font build scripts may check if fontforge is too old
#  # (yes, what they actually check is when fontforge was compiled)
#  postPatch = ''
#    sed -i -r 's@^FONTFORGE_VERSIONDATE=.+$@FONTFORGE_VERSIONDATE="${version}"@'           configure.ac
#    sed -i -r 's@^FONTFORGE_MODTIME=.+$@FONTFORGE_MODTIME="${versionModtime}"@'            configure.ac
#    sed -i -r 's@^FONTFORGE_MODTIME_STR=.+$@FONTFORGE_MODTIME_STR="${versionModtimeStr}"@' configure.ac
#  '';

  buildInputs = [
    autoconf automake gnum4 libtool perl pkgconfig gettext uthash
    python freetype zlib glib libungif libpng libjpeg libtiff libxml2
  ]
    ++ lib.optionals withSpiro [libspiro]
    ++ lib.optionals withGTK [ gtk2 pango ]
    ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ];

  configureFlags =
    lib.optionals (!withPython) [ "--disable-python-scripting" "--disable-python-extension" ]
    ++ lib.optional withGTK "--enable-gtk2-use"
    ++ lib.optional (!withGTK) "--without-x";

  # work-around: git isn't really used, but configuration fails without it
  preConfigure = ''
    export GIT="$(type -P true)"
    cp -r "${gnulib}" ./gnulib
    chmod +w -R ./gnulib
    ./bootstrap --skip-git --gnulib-srcdir=./gnulib
  '';

  postInstall =
    # get rid of the runtime dependency on python
    lib.optionalString (!withPython) ''
      rm -r "$out/share/fontforge/python"
    '';

  enableParallelBuilding = true;

  meta = {
    description = "A font editor";
    homepage = http://fontforge.github.io;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
  };
}
