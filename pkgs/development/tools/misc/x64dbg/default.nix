{ stdenv, lib, fetchFromGitHub, mingwPacman, pkgsCross }:

stdenv.mkDerivation {
  name = "x64dbg-2019-01-10";
  src = fetchFromGitHub {
    owner = "x64dbg";
    repo = "x64dbg";
    rev = "223ea586bb5240439ec554d0c3d61643afbecd37"; # 2019-01-10
    sha256 = "0dha7l6xw5n6nxp171zc54bdwjrbqpr71byhwkh22ih32dn60v3a";
    fetchSubmodules = true;
  };

# nativeBuildInputs = [ mingwPacman.tools-git /* genlib.exe */ ];

  # TODO: use qt from nixpkgs
  QT32PATH      = lib.optionalString (!stdenv.is64bit) "C:/Qt/Qt5.12.0/5.12.0/msvc2017/bin";
  QT64PATH      = lib.optionalString stdenv.is64bit "C:/Qt/Qt5.12.0/5.12.0/msvc2017_64/bin";
  QTCREATORPATH = "C:/Qt/Qt5.12.0/Tools/QtCreator/bin";
  VSVARSALLPATH = "${stdenv.cc}/VC/vcvarsall.bat";

  configurePhase = ''
    findL {
      my $filename = $_;
      if ($filename =~ /\.vcxproj$/) {
        changeFile {
          s|ToolsVersion="[^"]+"|ToolsVersion="${stdenv.cc.msbuild.version}"|g;
          s|<PlatformToolset>v120_xp</PlatformToolset>|<PlatformToolset>v141</PlatformToolset>|g;
          s|(<PropertyGroup Label="Globals">)|$1<WindowsTargetPlatformVersion>${stdenv.cc.sdk.version}</WindowsTargetPlatformVersion>|g unless /WindowsTargetPlatformVersion/;
          s|<WindowsTargetPlatformVersion>[^<]+<|<WindowsTargetPlatformVersion>${stdenv.cc.sdk.version}<|g;
          $_;
        } $filename;
      }
    } '.';

    changeFile { s|#error unDNameEx|//|gr; } 'src/dbg/symbolundecorator.h';
  '';

  buildPhase = if !stdenv.is64bit then ''
    system("build.bat x32");
  '' else ''
    system("build.bat x64");
  '';

  installPhase = if !stdenv.is64bit then ''
    system("release.bat");
    dircopy('release/release', "$ENV{out}/bin");
    for my $name ('Qt5Core.dll', 'Qt5Widgets.dll', 'Qt5Gui.dll', 'Qt5Network.dll') {
      copyL("$ENV{QT32PATH}/$name", "$ENV{out}/bin/x32/$name");
    }
    remove_treeL("$ENV{out}/bin/x64"); # delete binary dlls from $src/deps/x64
  '' + lib.optionalString (pkgsCross != null) ''
    dircopy('${pkgsCross.windows64.x64dbg.override{pkgsCross = null; /* prevent infinite recursion */} }/bin/x64' => "$ENV{out}/bin/x64");
  '' else ''
    system("release.bat");
    dircopy('release/release', "$ENV{out}/bin");
    for my $name ('Qt5Core.dll', 'Qt5Widgets.dll', 'Qt5Gui.dll', 'Qt5Network.dll') {
      copyL("$ENV{QT64PATH}/$name", "$ENV{out}/bin/x64/$name");
    }
    remove_treeL("$ENV{out}/bin/x32");
  '' + lib.optionalString (pkgsCross != null) ''
    dircopy('${pkgsCross.windows32.x64dbg.override{pkgsCross = null; /* prevent infinite recursion */} }/bin/x32' => "$ENV{out}/bin/x32");
  '';
}
