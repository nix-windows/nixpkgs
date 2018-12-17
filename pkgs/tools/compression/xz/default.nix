{ stdenv, fetchurl, enableStatic ? false }:

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

stdenv.mkDerivation rec {
  inherit name src meta;

  dontConfigure = true;
  buildPhase = ''
    for my $filename (glob('windows/vs2017/*.vcxproj')) {
      open(my $in, $filename) or die $!;
      open(my $out, ">$filename.new") or die $!;
      for my $line (<$in>) {
        $line =~ s|<WindowsTargetPlatformVersion>10\.[0-9.]+<|<WindowsTargetPlatformVersion>${stdenv.cc.sdk.version}<|g;
        print $out $line;
      }
      close($in);
      close($out);
      move("$filename.new", $filename) or die $!;
    }
    system('msbuild windows\vs2017\xz_win.sln /p:Configuration=Release /p:Platform=x64') == 0 or die;
  '';

  installPhase = ''
    mkdir($ENV{out});
    mkdir("$ENV{out}/lib");
    mkdir("$ENV{out}/include");
    ${if enableStatic then ''
        copy("windows/vs2017/Release/x64/liblzma/liblzma.lib",     "$ENV{out}/lib") or die $!; # static lib

        open (my $in, "src/liblzma/api/lzma.h") or die $!;
        open (my $out, ">$ENV{out}/include/lzma.h") or die $!;
        print $out "#define LZMA_API_STATIC 1\n";
        for my $line (<$in>) {
          print $out $line;
        }
        close($in) or die $!;
        close($out) or die $!;
      '' else ''
        mkdir("$ENV{out}/bin");
        copy("windows/vs2017/Release/x64/liblzma_dll/liblzma.dll", "$ENV{out}/bin") or die $!;
        copy("windows/vs2017/Release/x64/liblzma_dll/liblzma.lib", "$ENV{out}/lib") or die $!;
        copy("src/liblzma/api/lzma.h",                             "$ENV{out}/include") or die $!;
      ''}
    dircopy("src/liblzma/api/lzma", "$ENV{out}/include/lzma") or die $!;
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
