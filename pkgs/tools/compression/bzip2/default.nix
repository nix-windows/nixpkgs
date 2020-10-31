{ stdenv, fetchurl
, staticRuntime ? false # false for /MD, true for /MT
, static ? (stdenv.hostPlatform.system == "i686-cygwin" || stdenv.hostPlatform.isWindows)
}:

let
  version = "1.0.6.0.2";

  /* We use versions patched to use autotools style properly,
      saving lots of trouble. */
  src = fetchurl {
    urls = map
      (prefix: prefix + "/people/sbrabec/bzip2/tarballs/bzip2-${version}.tar.gz")
      [
        "http://ftp.uni-kl.de/pub/linux/suse"
        "ftp://ftp.hs.uni-hamburg.de/pub/mirrors/suse"
        "ftp://ftp.mplayerhq.hu/pub/linux/suse"
        "http://ftp.suse.com/pub" # the original patched version but slow
      ];
    sha256 = "1c65cmvf6bvwg4phsph7y43xq74kllh618nfwhfyy78f5qvp0y0n";
  };

  meta = with stdenv.lib; {
    description = "High-quality data compression program";
    license = licenses.bsdOriginal;
    platforms = platforms.all;
    maintainers = [];
  };
in

if stdenv.hostPlatform.isWindows then

assert static;
stdenv.mkDerivation rec {
  name = "bzip2-${if static then "lib" else "dll"}-${if staticRuntime then "mt" else "md"}-${version}";
  inherit version src meta;
  buildPhase = stdenv.lib.optionalString staticRuntime ''
    changeFile { s|MD|MT|gr; } 'makefile.msc';
  '' + ''
    system("nmake -f makefile.msc") == 0 or die $!;
  '';
  installPhase = ''
    make_pathL("$ENV{out}/bin", "$ENV{out}/include", "$ENV{out}/lib") or die $!;
    copyL('bzip2.exe',         "$ENV{out}/bin/bzip2.exe"        )     or die $!;
    copyL('bzip2recover.exe',  "$ENV{out}/bin/bzip2recover.exe" )     or die $!;
    copyL('bzlib.h',           "$ENV{out}/include/bzlib.h"      )     or die $!;
    copyL('libbz2.lib',        "$ENV{out}/lib/libbz2.lib"       )     or die $!;
  '';
  passthru.static        = static;
  passthru.staticRuntime = staticRuntime;
}

else
  throw "xxx"
/*
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
    stdenv.lib.optionals static [ "--enable-static" "--disable-shared" ];
}
*/