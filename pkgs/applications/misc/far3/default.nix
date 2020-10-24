{ stdenv, lib, fetchFromGitHub, perl, jdk8, ant, cmake }:

let
  colorer-schemes = stdenv.mkDerivation rec {
    version = "2020-10-21";
    name = "colorer-schemes-${version}";
    src = fetchFromGitHub {
      owner = "colorer";
      repo = "colorer-schemes";
      rev = "f5ee9f028fcff1111802ddadd33f6b9c75bc91da";
      sha256 = "0h5sbffkh6s3cf4k5fr3c1bzgi2wp23v8jkxla1hzdhfa34ny1i7";
    };
    nativeBuildInputs = [ perl jdk8 ant ];
    buildPhase   = ''system('build.cmd base.far');'';
    installPhase = ''dircopy('build/basefar', $ENV{out});'';
  };

  colorer = stdenv.mkDerivation rec {
    version = "1.3.22";
    name = "farcolorer-${version}";
    src = fetchFromGitHub {
      owner = "colorer";
      repo = "farcolorer";
      rev = version;
      sha256 = "044y3wqfmm5jab9jp35iym1817v5lrp08p4g4a9f68pcjlfr9zg2";
      fetchSubmodules = true;
    };
    nativeBuildInputs = [ cmake ];
    buildPhase = ''
      chdir('scripts');
      system("cmake -G \"NMake Makefiles\" -DCMAKE_BUILD_TYPE=Release ..") == 0 or die;
      system("nmake") == 0 or die;
      chdir('..');
    '';

    installPhase = ''
      dircopy('misc', "$ENV{out}/bin");
      copyL('scripts/src/colorer.dll', "$ENV{out}/bin/colorer.dll") or die $!;
      copyL('scripts/src/colorer.map', "$ENV{out}/bin/colorer.map") or die $!;
      copyL('README.md',               "$ENV{out}/README.md"      ) or die $!;
      copyL('LICENSE',                 "$ENV{out}/LICENSE"        ) or die $!;
      copyL('docs/history.ru.txt',     "$ENV{out}/history.ru.txt" ) or die $!;
    '';
  };

  netbox = stdenv.mkDerivation rec {
    version = "2020-03-30";
    name = "farnetbox-${version}";
    src = fetchFromGitHub {
      owner = "michaellukashov";
      repo = "Far-NetBox";
      rev = "f27f64f0c81091d91316a61317671492e218b82a"; # far3 branch
      sha256 = "0rplxfp78xk1hkg62zyqzj49r61bxf9mzhh4zly9yzs72j70yn62";
    };
    nativeBuildInputs = [ cmake ];
    buildPhase = ''
      mkdir('build');
      chdir('build');
      system("cmake -G \"NMake Makefiles\" -DCMAKE_BUILD_TYPE=Release -DFAR_VERSION=Far3 ..\\src\\NetBox") == 0 or die;
      system("nmake") == 0 or die;
      chdir('..');
    '';
    installPhase = ''
      dircopy('Far3_x64/Plugins/NetBox', "$ENV{out}/bin");
      copyL('LICENSE.txt',  "$ENV{out}/LICENSE.txt" );
      copyL('README.md',    "$ENV{out}/README.md"   );
      copyL('README.RU.md', "$ENV{out}/README.RU.md");
    '';
    meta.homepage = "https://github.com/michaellukashov/Far-NetBox/tree/far3";
  };

in
stdenv.mkDerivation rec {
  version = "3.0.5687.1751"; # update feed: https://github.com/FarGroup/FarManager/releases
  name = "far-${version}";

  src = fetchFromGitHub {
    owner = "FarGroup";
    repo = "FarManager";
    rev = "ci/v${version}";
    sha256 = "1qphn2rrzndhxjz87iq9zw7n6ahdb5ky6q8mpcmf6n9x9vz5sqws";
  };

  # do not use `makeFlags`, nmake.exe does read %MAKEFLAGS% and interprets it in unexpected way
  nmakeFlags = lib.optional stdenv.is64bit "CPU=AMD64";

  buildPhase = ''
    # stdenv compiler is a bit older but still good enough
    changeFile { s|#error Visual C\+\+ 2017.+required||gr } 'far/headers.hpp';

    chdir("far");
    system("nmake -f makefile_vc         $ENV{nmakeFlags}"                                                 ) == 0 or die;
    system("nmake -f makefile_vc install $ENV{nmakeFlags} INSTALLDIR=..\\out"                              ) == 0 or die;
    chdir("..");

    chdir("plugins");
    system("nmake -f makefile_all_vc     $ENV{nmakeFlags} INSTALL=..\\out\\Plugins FAR_WORKDIR=..\\..\\out") == 0 or die;
    chdir("..");
  '';

  installPhase = ''
    dircopy('out',                "$ENV{out}/bin"                        ) or die $!;
    dircopy('${colorer}',         "$ENV{out}/bin/Plugins/FarColorer"     ) or die $!;
    dircopy('${colorer-schemes}', "$ENV{out}/bin/Plugins/FarColorer/base") or die $!;
    dircopy('${netbox}',          "$ENV{out}/bin/Plugins/NetBox"         ) or die $!;
  '';

  passthru = { inherit colorer-schemes colorer netbox; };

  meta = {
    description = "An orthodox file manager";
    homepage = https://www.farmanager.com/;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.volth ];
    platforms = lib.platforms.windows;
  };
}
