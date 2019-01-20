{ stdenv, lib, fetchFromGitHub, perl, jdk8, ant, cmake }:

let
  colorer-schemes = stdenv.mkDerivation rec {
    version = "2019-01-07";
    name = "colorer-schemes-${version}";
    src = fetchFromGitHub {
      owner = "colorer";
      repo = "colorer-schemes";
      rev = "7f02d76568513772da44163a4ee6926a08aba115";
      sha256 = "1yq89sb7fn4m9vpng73bf5d28f4lbk2dk6yimkcv968m432bfhdl";
    };
    nativeBuildInputs = [ perl jdk8 ant ];
    buildPhase   = ''system('build.cmd base.far');'';
    installPhase = ''dircopy('build/basefar', $ENV{out});'';
  };

  colorer = stdenv.mkDerivation rec {
    version = "1.2.9.1";
    name = "farcolorer-${version}";
    src = fetchFromGitHub {
      owner = "colorer";
      repo = "farcolorer";
      rev = version;
      sha256 = "0y70p4nzx9mdjailifljxqr61rciqjhcmk70br7ph4srwi428c5p";
      fetchSubmodules = true;
    };
    nativeBuildInputs = [ cmake ];
    buildPhase = ''
      mkdir('build');
      chdir('build');
      system("cmake -G \"NMake Makefiles\" -DCMAKE_BUILD_TYPE=Release ..\\src") == 0 or die;
      system("nmake") == 0 or die;
      chdir('..');
    '';
    installPhase = ''
      dircopy('misc', "$ENV{out}/bin");
      copyL('build/colorer.dll',   "$ENV{out}/bin/colorer.dll") or die $!;
      copyL('build/colorer.map',   "$ENV{out}/bin/colorer.map") or die $!;
      copyL('README.md',           "$ENV{out}/README.md"      ) or die $!;
      copyL('LICENSE',             "$ENV{out}/LICENSE"        ) or die $!;
      copyL('docs/history.ru.txt', "$ENV{out}/history.ru.txt" ) or die $!;
    '';
  };

  netbox = stdenv.mkDerivation rec {
    version = "2018-08-01";
    name = "farnetbox-${version}";
    src = fetchFromGitHub {
      owner = "michaellukashov";
      repo = "Far-NetBox";
      rev = "82b9ecd2f10ddf4c784f0e09be6ff790fbd94507"; # far3 branch
      sha256 = "0mxnrp2fw5nr06j80dc4pbqx2s5x3ps6yb2p0pxkwsclcl73mrg8";
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
  version = "3.0.5354.738"; # update feed: https://github.com/FarGroup/FarManager/releases
  name = "far-${version}";

  src = fetchFromGitHub {
    owner = "FarGroup";
    repo = "FarManager";
    rev = "v${version}";
    sha256 = "1dl8yvr6axc2a6w0327y1b3ns44n0d3cv0r0zkdsdv0j9wjzbpl8";
  };

  # do not use `makeFlags`, nmake.exe does read %MAKEFLAGS% and interprets it in unexpected way
  nmakeFlags = lib.optional stdenv.is64bit "CPU=AMD64";

  buildPhase = ''
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
