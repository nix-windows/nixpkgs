{ stdenv, fetchurl }:

if stdenv.hostPlatform.isMicrosoft then

let
  platform = { "x86_64-pc-windows-msvc" = "x64"; "i686-pc-windows-msvc" = "x86"; }.${stdenv.hostPlatform.config};
in stdenv.mkDerivation rec {
  version = "18.06";
  name = "p7zip-${version}";

  src = fetchurl {
    url = https://www.7-zip.org/a/7z1806-src.7z;
    sha256 = "1fccqa2f0biy1wbh2m7y3jx8k0vj8kbxy32713ym2g6523i05z40";
  };

  sourceRoot = ".";
  dontConfigure = true;
  buildPhase = ''
    chdir('CPP/7zip');
    system("nmake PLATFORM=${platform}") == 0 or die $!;
    chdir('../..');
  '';
  installPhase = ''
    make_pathL("$ENV{out}/bin")                                                    or die $!;
    copyL("CPP/7zip/UI/Console/${platform}/7z.exe",        "$ENV{out}/bin/7z.exe") or die $!;
    copyL("CPP/7zip/Bundles/Format7zF/${platform}/7z.dll", "$ENV{out}/bin/7z.dll") or die $!;
  '';
}

else

stdenv.mkDerivation rec {
  name = "p7zip-${version}";
  version = "16.02";

  src = fetchurl {
    url = "mirror://sourceforge/p7zip/p7zip_${version}_src_all.tar.bz2";
    sha256 = "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f";
  };

  patches = [
    ./12-CVE-2016-9296.patch
    ./13-CVE-2017-17969.patch
  ];

  # Default makefile is full of impurities on Darwin. The patch doesn't hurt Linux so I'm leaving it unconditional
  postPatch = ''
    sed -i '/CC=\/usr/d' makefile.macosx_llvm_64bits

    # I think this is a typo and should be CXX? Either way let's kill it
    sed -i '/XX=\/usr/d' makefile.macosx_llvm_64bits
  '' + stdenv.lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace makefile.machine \
      --replace 'CC=gcc'  'CC=${stdenv.cc.targetPrefix}gcc' \
      --replace 'CXX=g++' 'CXX=${stdenv.cc.targetPrefix}g++'
  '';

  preConfigure = ''
    makeFlagsArray=(DEST_HOME=$out)
    buildFlags=all3
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    cp makefile.macosx_llvm_64bits makefile.machine
  '';

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://p7zip.sourceforge.net/;
    description = "A port of the 7-zip archiver";
    # license = stdenv.lib.licenses.lgpl21Plus; + "unRAR restriction"
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
