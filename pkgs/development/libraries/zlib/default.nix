{ stdenv
, fetchurl
, staticRuntime ? false # false for /MD, true for /MT
, static ? false
, mingwPacman
}:

let
  version = "1.2.11";

  src = fetchurl {
    urls =
      [ "https://www.zlib.net/fossils/zlib-${version}.tar.gz"  # stable archive path
        "mirror://sourceforge/libpng/zlib/${version}/zlib-${version}.tar.gz"
      ];
    sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1";
  };

in

if stdenv.hostPlatform.isWindows && stdenv.cc.isMSVC then

stdenv.mkDerivation rec {
  name = "zlib-${if static then "lib" else "dll"}-${if staticRuntime then "mt" else "md"}-${version}";
  inherit version src;
  dontConfigure = true;
  buildPhase = stdenv.lib.optionalString staticRuntime ''
    changeFile { s|MD|MT|gr; } 'win32/Makefile.msc';
  '' + ''
    system('nmake -f win32/Makefile.msc') == 0 or die;
  '';
  installPhase = if static then ''
    make_pathL("$ENV{out}/include", "$ENV{out}/lib")                  or die $!;
    copyL('zlib.h',    "$ENV{out}/include/zlib.h" )                   or die $!;
    copyL('zconf.h',   "$ENV{out}/include/zconf.h")                   or die $!;
    copyL('zlib.lib',  "$ENV{out}/lib/zlib.lib"   )                   or die $!;
  '' else ''
    make_pathL("$ENV{out}/bin", "$ENV{out}/include", "$ENV{out}/lib") or die $!;
    copyL('zlib1.dll', "$ENV{out}/bin/zlib1.dll"  )                   or die $!;
    copyL('zlib.h',    "$ENV{out}/include/zlib.h" )                   or die $!;
    copyL('zconf.h',   "$ENV{out}/include/zconf.h")                   or die $!;
    copyL('zdll.lib',  "$ENV{out}/lib/zdll.lib"   )                   or die $!;
  '';
  passthru.static        = static;
  passthru.staticRuntime = staticRuntime;
}

else if stdenv.hostPlatform.isWindows && stdenv.cc.isGNU then

mingwPacman.zlib
/*
stdenv.mkDerivation rec {
  name = "zlib-${if static then "lib" else "dll"}-${if staticRuntime then "mt" else "md"}-${version}";
  inherit version src;
  dontConfigure = true;
  buildPhase = stdenv.lib.optionalString staticRuntime ''
  #  changeFile { s|MD|MT|gr; } 'win32/Makefile.msc';
  #'' + ''
  #  system('nmake -f win32/Makefile.msc') == 0 or die;
  '';
  installPhase = if static then ''
    #make_pathL("$ENV{out}/include", "$ENV{out}/lib")                  or die $!;
    #copyL('zlib.h',    "$ENV{out}/include/zlib.h" )                   or die $!;
    #copyL('zconf.h',   "$ENV{out}/include/zconf.h")                   or die $!;
    #copyL('zlib.lib',  "$ENV{out}/lib/zlib.lib"   )                   or die $!;
  '' else ''
    #make_pathL("$ENV{out}/bin", "$ENV{out}/include", "$ENV{out}/lib") or die $!;
    #copyL('zlib1.dll', "$ENV{out}/bin/zlib1.dll"  )                   or die $!;
    #copyL('zlib.h',    "$ENV{out}/include/zlib.h" )                   or die $!;
    #copyL('zconf.h',   "$ENV{out}/include/zconf.h")                   or die $!;
    #copyL('zdll.lib',  "$ENV{out}/lib/zdll.lib"   )                   or die $!;
  '';
  passthru.static        = static;
  passthru.staticRuntime = staticRuntime;
}
*/
else
 throw "xxx"
/*
stdenv.mkDerivation (rec {
  inherit name version src;

  patches = stdenv.lib.optional stdenv.hostPlatform.isCygwin ./disable-cygwin-widechar.patch;

  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure \
      --replace '/usr/bin/libtool' 'ar' \
      --replace 'AR="libtool"' 'AR="ar"' \
      --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  outputs = [ "out" "dev" "static" ];
  setOutputFlags = false;
  outputDoc = "dev"; # single tiny man3 page

  configureFlags = stdenv.lib.optional (!static) "--shared";

  postInstall = ''
    moveToOutput lib/libz.a "$static"
  ''
    # jww (2015-01-06): Sometimes this library install as a .so, even on
    # Darwin; others time it installs as a .dylib.  I haven't yet figured out
    # what causes this difference.
  + stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
    for file in $out/lib/*.so* $out/lib/*.dylib* ; do
      ${stdenv.cc.bintools.targetPrefix}install_name_tool -id "$file" $file
    done
  ''
    # Non-typical naming confuses libtool which then refuses to use zlib's DLL
    # in some cases, e.g. when compiling libpng.
  + stdenv.lib.optionalString (stdenv.hostPlatform.libc == "msvcrt") ''
    ln -s zlib1.dll $out/bin/libz.dll
  '';

  # As zlib takes part in the stdenv building, we don't want references
  # to the bootstrap-tools libgcc (as uses to happen on arm/mips)
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (!stdenv.hostPlatform.isDarwin) "-static-libgcc";

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform && static;
  configurePlatforms = [];

  installFlags = stdenv.lib.optionals (stdenv.hostPlatform.libc == "msvcrt") [
    "BINARY_PATH=$(out)/bin"
    "INCLUDE_PATH=$(dev)/include"
    "LIBRARY_PATH=$(out)/lib"
  ];

  makeFlags = [
    "PREFIX=${stdenv.cc.targetPrefix}"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform.libc == "msvcrt") [
    "-f" "win32/Makefile.gcc"
  ] ++ stdenv.lib.optionals (!static) [
    "SHARED_MODE=1"
  ];

  passthru = {
    inherit version;
  };

  meta = with stdenv.lib; {
    homepage = https://zlib.net;
    description = "Lossless data-compression library";
    license = licenses.zlib;
    platforms = platforms.all;
  };
} // stdenv.lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform) {
  preConfigure = ''
    export CHOST=${stdenv.hostPlatform.config}
  '';
} // stdenv.lib.optionalAttrs (stdenv.hostPlatform.libc == "msvcrt") {
  configurePhase = ":";
})
*/