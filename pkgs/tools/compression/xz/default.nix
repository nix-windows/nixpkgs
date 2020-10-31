{ stdenv, fetchurl
, staticRuntime ? false # false for /MD, true for /MT
, static ? false
}:

let
  version = "5.2.5";

  src = fetchurl {
    url = "https://tukaani.org/xz/xz-${version}.tar.bz2";
    sha256 = "1ps2i8i212n0f4xpq6clp7h13q7m1y8slqvxha9i8d0bj0qgj5si";
  };

  meta = with stdenv.lib; {
    homepage = https://tukaani.org/xz/;
    description = "XZ, general-purpose data compression software, successor of LZMA";

    longDescription =
      '' XZ Utils is free general-purpose data compression software with high
         compression ratio.  XZ Utils were written for POSIX-like systems,
         but also work on some not-so-POSIX systems.  XZ Utils are the
         successor to LZMA Utils.

         The core of the XZ Utils compression code is based on LZMA SDK, but
         it has been modified quite a lot to be suitable for XZ Utils.  The
         primary compression algorithm is currently LZMA2, which is used
         inside the .xz container format.  With typical files, XZ Utils
         create 30 % smaller output than gzip and 15 % smaller output than
         bzip2.
      '';

    license = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
  };
in

if stdenv.hostPlatform.isWindows then

let
  platform      = if stdenv.is64bit then "x64" else "Win32";
  configuration = if staticRuntime then "ReleaseMT" else "Release";
  toolset       = if stdenv.cc.isMSVC && stdenv.lib.versionAtLeast stdenv.cc.msvc.version "14.10" && stdenv.lib.versionOlder stdenv.cc.msvc.version "14.20" then
                    "vs2017"
                  else if stdenv.cc.isMSVC && stdenv.lib.versionAtLeast stdenv.cc.msvc.version "14.20" && stdenv.lib.versionOlder stdenv.cc.msvc.version "14.30" then
                    "vs2019"
                  else
                    throw "???";
in stdenv.mkDerivation rec {
  name = "xz-${if static then "lib" else "dll"}-${if staticRuntime then "mt" else "md"}-${version}";
  inherit src meta;

  dontConfigure = true;
  buildPhase = ''
    for my $filename (glob('windows/${toolset}/*.vcxproj')) {
      changeFile { s|<WindowsTargetPlatformVersion>10\.[0-9.]+<|<WindowsTargetPlatformVersion>${stdenv.cc.sdk.version}<|gr } $filename;
    }
    system('msbuild windows\${toolset}\xz_win.sln /p:Configuration=${configuration} /p:Platform=${platform}') == 0 or die;
  '';

  installPhase = ''
    make_pathL("$ENV{out}/lib", "$ENV{out}/include") or die $!;
    ${if static then ''
        copyL("windows/${toolset}/${configuration}/${platform}/liblzma/liblzma.lib",      "$ENV{out}/lib/liblzma.lib") or die $!; # static lib
        copyL("src/liblzma/api/lzma.h",                                                   "$ENV{out}/include/lzma.h" ) or die $!; # static lib
        changeFile { "#define LZMA_API_STATIC 1\n".$_ }                                   "$ENV{out}/include/lzma.h";
      '' else ''
        make_pathL("$ENV{out}/bin") or die $!;
        copyL("windows/${toolset}/${configuration}/${platform}/liblzma_dll/liblzma.dll",  "$ENV{out}/bin/liblzma.dll") or die $!;
        copyL("windows/${toolset}/${configuration}/${platform}/liblzma_dll/liblzma.lib",  "$ENV{out}/lib/liblzma.lib") or die $!;
        copyL("src/liblzma/api/lzma.h",                                                   "$ENV{out}/include/lzma.h" ) or die $!;
      ''}
    dircopy("src/liblzma/api/lzma", "$ENV{out}/include/lzma") or die "dircopy(src/liblzma/api/lzma, $ENV{out}/include/lzma): $!";
  '';
  passthru.static        = static;
  passthru.staticRuntime = staticRuntime;
}

else
  throw "xxx"
/*
stdenv.mkDerivation rec {
  inherit name src meta;

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  configureFlags = stdenv.lib.optional static "--disable-shared";

  doCheck = true;

  preCheck = ''
    # Tests have a /bin/sh dependency...
    patchShebangs tests
  '';

  # In stdenv-linux, prevent a dependency on bootstrap-tools.
  preConfigure = "CONFIG_SHELL=/bin/sh";

  postInstall = "rm -rf $out/share/doc";
}
*/