{ stdenv, fetchurl, fetchFromGitHub, msysPacman
, supportWindowsXP ? false # Sacrifice multithread compression for Windows XP compatibility; for unpackers which have to run everywhere
}:

if stdenv.hostPlatform.isWindows && stdenv.cc.isMSVC then
  let
    platform = if stdenv.is64bit then "x64" else "x86";
  in stdenv.mkDerivation rec {
    version = "19.00";
    name = "p7zip-zstd-${version}";
#   src = ../../../../../nix-windows/wqwq/7-Zip-zstd;
    src = fetchurl {
      url = https://github.com/mcmilk/7-Zip-zstd/archive/19.00-v1.4.5-R3.zip;
      sha256 = "1rll0lv9c8yhaam0hsm1af950657ninivddd5zs8m9nymc20x32r";
    };

    patchPhase = stdenv.lib.optionalString supportWindowsXP ''
      changeFile { s/-DFL2_7ZIP_BUILD/-DFL2_7ZIP_BUILD -DFL2_SINGLETHREAD/gr } 'CPP/7zip/7zip.mak';
    '';

    dontConfigure = true;

    buildPhase = ''
      $ENV{VC}='16.0';
      $ENV{SUBSYS}='${if stdenv.is64bit then "5.02" else "5.01"}';
      $ENV{PLATFORM}='${platform}';
      chdir('CPP');
      system("build-it.cmd") == 0 or die $!;
    '';
    installPhase = ''
      dircopy('/bin-16.0-${platform}', "$ENV{out}/bin") or die $!;
    '';
#   passthru.masm9 = masm9;
  }

else throw "???"
/*
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
*/
