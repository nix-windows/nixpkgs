{ stdenv, fetchurl
, linkStatic ? (stdenv.hostPlatform.system == "i686-cygwin")
}:

let
  name = "bzip2-${version}";
  version = "1.0.6.0.1";

  /* We use versions patched to use autotools style properly,
      saving lots of trouble. */
  src = fetchurl {
    urls = map
      (prefix: prefix + "/people/sbrabec/bzip2/tarballs/${name}.tar.gz")
      [
        "http://ftp.uni-kl.de/pub/linux/suse"
        "ftp://ftp.hs.uni-hamburg.de/pub/mirrors/suse"
        "ftp://ftp.mplayerhq.hu/pub/linux/suse"
        "http://ftp.suse.com/pub" # the original patched version but slow
      ];
    sha256 = "0b5b5p8c7bslc6fslcr1nj9136412v3qcvbg6yxi9argq9g72v8c";
  };

  meta = with stdenv.lib; {
    description = "High-quality data compression program";
    license = licenses.bsdOriginal;
    platforms = platforms.all;
    maintainers = [];
  };
in

if stdenv.hostPlatform.isMicrosoft then

stdenv.mkDerivation rec {
  inherit name version src meta;
  buildPhase = ''
    system("nmake -f makefile.msc") == 0 or die $!;
  '';
  installPhase = ''
    mkpath("$ENV{out}/bin", "$ENV{out}/include", "$ENV{out}/lib") or die $!;
    copy('bzip2.exe',         "$ENV{out}/bin"    )                or die $!;
    copy('bzip2recover.exe',  "$ENV{out}/bin"    )                or die $!;
    copy('bzlib.h',           "$ENV{out}/include")                or die $!;
    copy('libbz2.lib',        "$ENV{out}/lib"    )                or die $!;
  '';
}

else

stdenv.mkDerivation rec {
  inherit name version src meta;

  patches = [
    ./CVE-2016-3189.patch
  ];


  postPatch = ''
    sed -i -e '/<sys\\stat\.h>/s|\\|/|' bzip2.c
  '';


  outputs = [ "bin" "dev" "out" "man" ];

  configureFlags =
    stdenv.lib.optionals linkStatic [ "--enable-static" "--disable-shared" ];
}
