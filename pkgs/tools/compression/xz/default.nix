{ stdenv, fetchurl
, staticRuntime ? false # false for /MD, true for /MT
, enableStatic ? false }:

let
  name = "xz-5.2.4";

  src = fetchurl {
    url = "https://tukaani.org/xz/${name}.tar.bz2";
    sha256 = "1gxpayfagb4v7xfhs2w6h7k56c6hwwav1rk48bj8hggljlmgs4rk";
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

if stdenv.hostPlatform.isMicrosoft then

let
  platform      = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenv.hostPlatform.config};
  configuration = if staticRuntime then "ReleaseMT" else "Release";
in stdenv.mkDerivation rec {
  inherit name src meta;

  dontConfigure = true;
  buildPhase = ''
    for my $filename (glob('windows/vs2017/*.vcxproj')) {
      changeFile { s|<WindowsTargetPlatformVersion>10\.[0-9.]+<|<WindowsTargetPlatformVersion>${stdenv.cc.sdk.version}<|gr } $filename;
    }
    system('msbuild windows\vs2017\xz_win.sln /p:Configuration=${configuration} /p:Platform=${platform}') == 0 or die;
  '';

  installPhase = ''
    make_pathL("$ENV{out}/lib", "$ENV{out}/include") or die $!;
    ${if enableStatic then ''
        copyL("windows/vs2017/${configuration}/x64/liblzma/liblzma.lib",      "$ENV{out}/lib/liblzma.lib") or die $!; # static lib
        copyL("src/liblzma/api/lzma.h",                                       "$ENV{out}/include/lzma.h" ) or die $!; # static lib
        changeFile { "#define LZMA_API_STATIC 1\n".$_ }                       "$ENV{out}/include/lzma.h";
      '' else ''
        make_pathL("$ENV{out}/bin") or die $!;
        copyL("windows/vs2017/${configuration}/x64/liblzma_dll/liblzma.dll",  "$ENV{out}/bin/liblzma.dll") or die $!;
        copyL("windows/vs2017/${configuration}/x64/liblzma_dll/liblzma.lib",  "$ENV{out}/lib/liblzma.lib") or die $!;
        copyL("src/liblzma/api/lzma.h",                                       "$ENV{out}/include/lzma.h" ) or die $!;
      ''}
    dircopy("src/liblzma/api/lzma", "$ENV{out}/include/lzma") or die "dircopy(src/liblzma/api/lzma, $ENV{out}/include/lzma): $!";
  '';
}

else

stdenv.mkDerivation rec {
  inherit name src meta;

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  configureFlags = stdenv.lib.optional enableStatic "--disable-shared";

  doCheck = true;

  preCheck = ''
    # Tests have a /bin/sh dependency...
    patchShebangs tests
  '';

  # In stdenv-linux, prevent a dependency on bootstrap-tools.
  preConfigure = "CONFIG_SHELL=/bin/sh";

  postInstall = "rm -rf $out/share/doc";
}
