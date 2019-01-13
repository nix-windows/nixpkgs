 # GENERATED FILE
{stdenvNoCC, fetchurl, mingwPackages, msysPackages}:

let
  fetch = { name, version, filename, sha256, buildInputs ? [], broken ? false }:
    if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
      stdenvNoCC.mkDerivation {
        inherit name version buildInputs;
        src = fetchurl {
          url = "http://repo.msys2.org/mingw/i686/${filename}";
          inherit sha256;
        };
        PATH = stdenvNoCC.lib.concatMapStringsSep ";" (x: "${x}\\bin") stdenvNoCC.initialPath; # it adds 7z.exe to PATH
        builder = stdenvNoCC.lib.concatStringsSep " & " ( [ ''echo PATH=%PATH%''
                                                            ''7z x %src% -so  |  7z x -aoa -si -ttar -o%out%''
                                                            ''pushd %out%''
                                                            ''del .BUILDINFO .INSTALL .MTREE .PKGINFO''
                                                          ]
                                                       ++ stdenvNoCC.lib.concatMap (dep: let
                                                            tgt = stdenvNoCC.lib.replaceStrings ["/"] ["\\"] "${dep}";
                                                          in [
#                                                           ''FOR /R ${tgt} %G in (*) DO (set localname=%G???? if not exist %localname% mklink %localname% ${tgt})''
                                                            ''xcopy /E/H/B/F/I/Y ${tgt} .''
                                                          ]) buildInputs
                                                       ++ [ ''popd'' ]
                                                        );
      }
    else
    stdenvNoCC.mkDerivation {
      inherit name version buildInputs;
      src = fetchurl {
        url = "http://repo.msys2.org/mingw/i686/${filename}";
        inherit sha256;
      };
      sourceRoot = ".";
      buildPhase = if stdenvNoCC.isShellPerl /* on native windows */ then
        ''
          dircopy('.', $ENV{out}) or die "dircopy(., $ENV{out}): $!";
          unlinkL "$ENV{out}/.BUILDINFO";
          unlinkL "$ENV{out}/.INSTALL";
          unlinkL "$ENV{out}/.MTREE";
          unlinkL "$ENV{out}/.PKGINFO";
        '' + stdenvNoCC.lib.concatMapStringsSep "\n" (dep:
               ''symtree_link($ENV{out}, '${dep}', $ENV{out});''
             ) buildInputs
      else /* on mingw or linux */
        throw "todo";
      meta.broken = broken;
    };
  self = _self;
  _self = with self;
{
  callPackage = pkgs.newScope self;
  bash = msysPackages.bash;
  winpty = msysPackages.winpty;
  python3 = mingwPackages.python3;

  "mingw-w64-i686-3proxy" = fetch {
    name        = "mingw-w64-i686-3proxy";
    version     = "0.8.12";
    filename    = "mingw-w64-i686-3proxy-0.8.12-1-any.pkg.tar.xz";
    sha256      = "c52347418b7e88351a352534df79ef44badeb2afcac4fd1a4496c2de8625d29b";
  };

  "mingw-w64-i686-4th" = fetch {
    name        = "mingw-w64-i686-4th";
    version     = "3.62.5";
    filename    = "mingw-w64-i686-4th-3.62.5-1-any.pkg.tar.xz";
    sha256      = "ca5f028d55ba7b17df2aa8578c5fde29111f2f6484860467733ebe57e895ceda";
  };

  "mingw-w64-i686-MinHook" = fetch {
    name        = "mingw-w64-i686-MinHook";
    version     = "1.3.3";
    filename    = "mingw-w64-i686-MinHook-1.3.3-1-any.pkg.tar.xz";
    sha256      = "1d3bdd393ca9a6e7ad1d777dd6b665110ad28fe134f3ca43c4f10de5afc4a844";
  };

  "mingw-w64-i686-OpenSceneGraph" = fetch {
    name        = "mingw-w64-i686-OpenSceneGraph";
    version     = "3.6.3";
    filename    = "mingw-w64-i686-OpenSceneGraph-3.6.3-3-any.pkg.tar.xz";
    sha256      = "bcf522ed5c4f85c31a7d5bf41cd911d7c09c26544fbff8acd3ae33a2b7cf638f";
    buildInputs = [ mingw-w64-i686-angleproject-git mingw-w64-i686-boost mingw-w64-i686-collada-dom-svn mingw-w64-i686-curl mingw-w64-i686-ffmpeg mingw-w64-i686-fltk mingw-w64-i686-freetype mingw-w64-i686-gcc-libs mingw-w64-i686-gdal mingw-w64-i686-giflib mingw-w64-i686-gstreamer mingw-w64-i686-gtk2 mingw-w64-i686-gtkglext mingw-w64-i686-jasper mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-libvncserver mingw-w64-i686-libxml2 mingw-w64-i686-lua mingw-w64-i686-SDL mingw-w64-i686-SDL2 mingw-w64-i686-poppler mingw-w64-i686-python3 mingw-w64-i686-wxWidgets mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-OpenSceneGraph-debug" = fetch {
    name        = "mingw-w64-i686-OpenSceneGraph-debug";
    version     = "3.6.3";
    filename    = "mingw-w64-i686-OpenSceneGraph-debug-3.6.3-3-any.pkg.tar.xz";
    sha256      = "fb2ab7c2b0b2ea382ea5934d7094b92acee0379bf087ed80a266aa6a58f683c6";
    buildInputs = [ (assert mingw-w64-i686-OpenSceneGraph.version=="3.6.3"; mingw-w64-i686-OpenSceneGraph) ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-SDL" = fetch {
    name        = "mingw-w64-i686-SDL";
    version     = "1.2.15";
    filename    = "mingw-w64-i686-SDL-1.2.15-8-any.pkg.tar.xz";
    sha256      = "8ad9ec75014a2fe529f639b67e5bcc5277b0fd6adc4946b3965f7cc5be3f6470";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-SDL2" = fetch {
    name        = "mingw-w64-i686-SDL2";
    version     = "2.0.9";
    filename    = "mingw-w64-i686-SDL2-2.0.9-1-any.pkg.tar.xz";
    sha256      = "e8512f5d7ccc13ad06d8930aa20deb3119587d15b6a99065b706cbf0573a47e0";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libiconv mingw-w64-i686-vulkan ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-SDL2_gfx" = fetch {
    name        = "mingw-w64-i686-SDL2_gfx";
    version     = "1.0.4";
    filename    = "mingw-w64-i686-SDL2_gfx-1.0.4-1-any.pkg.tar.xz";
    sha256      = "41aa14e123af35c87ccf95e6ea8337233da4995fe89bd53851e6a863a188259a";
    buildInputs = [ mingw-w64-i686-SDL2 ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-SDL2_image" = fetch {
    name        = "mingw-w64-i686-SDL2_image";
    version     = "2.0.4";
    filename    = "mingw-w64-i686-SDL2_image-2.0.4-1-any.pkg.tar.xz";
    sha256      = "0c9f055e08032e995444e6a6502160c25d7a822905fdbccf0fa783c2a7dbd235";
    buildInputs = [ mingw-w64-i686-SDL2 mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libwebp ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-SDL2_mixer" = fetch {
    name        = "mingw-w64-i686-SDL2_mixer";
    version     = "2.0.4";
    filename    = "mingw-w64-i686-SDL2_mixer-2.0.4-1-any.pkg.tar.xz";
    sha256      = "2689f5d03227b4ad65dda669dd72a83559db6deefdd34ef119f05c00cf31abdf";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-SDL2 mingw-w64-i686-flac mingw-w64-i686-fluidsynth mingw-w64-i686-libvorbis mingw-w64-i686-libmodplug mingw-w64-i686-mpg123 mingw-w64-i686-opusfile ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-SDL2_net" = fetch {
    name        = "mingw-w64-i686-SDL2_net";
    version     = "2.0.1";
    filename    = "mingw-w64-i686-SDL2_net-2.0.1-1-any.pkg.tar.xz";
    sha256      = "4dc37d68ddaf1a1fb33da8613e226df2adb5aef207c2bf4f7a2e89038aaddc4b";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-SDL2 ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-SDL2_ttf" = fetch {
    name        = "mingw-w64-i686-SDL2_ttf";
    version     = "2.0.14";
    filename    = "mingw-w64-i686-SDL2_ttf-2.0.14-1-any.pkg.tar.xz";
    sha256      = "08ea6ef36545b9b99fd43023a922845c07b67fa9beb6359138f46839d16394b3";
    buildInputs = [ mingw-w64-i686-SDL2 mingw-w64-i686-freetype ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-SDL_gfx" = fetch {
    name        = "mingw-w64-i686-SDL_gfx";
    version     = "2.0.26";
    filename    = "mingw-w64-i686-SDL_gfx-2.0.26-1-any.pkg.tar.xz";
    sha256      = "84048cd1d619843f24a7006a6663cfaef8d7c136eea02b68ddf81ad8d099df14";
    buildInputs = [ mingw-w64-i686-SDL ];
  };

  "mingw-w64-i686-SDL_image" = fetch {
    name        = "mingw-w64-i686-SDL_image";
    version     = "1.2.12";
    filename    = "mingw-w64-i686-SDL_image-1.2.12-6-any.pkg.tar.xz";
    sha256      = "c6a5a6bd56cea1cfeb81c101fdc057626a38a0af577f7eaf09fe6577cf0fd39e";
    buildInputs = [ mingw-w64-i686-SDL mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-libwebp mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-SDL_mixer" = fetch {
    name        = "mingw-w64-i686-SDL_mixer";
    version     = "1.2.12";
    filename    = "mingw-w64-i686-SDL_mixer-1.2.12-6-any.pkg.tar.xz";
    sha256      = "713a32a690bb5bdd5215bc4b9e59706849d46264e9b8220278da3d3019f1229a";
    buildInputs = [ mingw-w64-i686-SDL mingw-w64-i686-libvorbis mingw-w64-i686-libmikmod mingw-w64-i686-libmad mingw-w64-i686-flac ];
  };

  "mingw-w64-i686-SDL_net" = fetch {
    name        = "mingw-w64-i686-SDL_net";
    version     = "1.2.8";
    filename    = "mingw-w64-i686-SDL_net-1.2.8-2-any.pkg.tar.xz";
    sha256      = "3968125e2bd1882b30027280ec56c1eae7c3e2c93535e4afc48f98ef9b45a4fc";
    buildInputs = [ mingw-w64-i686-SDL ];
  };

  "mingw-w64-i686-SDL_ttf" = fetch {
    name        = "mingw-w64-i686-SDL_ttf";
    version     = "2.0.11";
    filename    = "mingw-w64-i686-SDL_ttf-2.0.11-5-any.pkg.tar.xz";
    sha256      = "9a2b1c5d12107f9786a44c7a2ad26355d661f9c42c2969e1b05437ac286c3361";
    buildInputs = [ mingw-w64-i686-SDL mingw-w64-i686-freetype ];
  };

  "mingw-w64-i686-a52dec" = fetch {
    name        = "mingw-w64-i686-a52dec";
    version     = "0.7.4";
    filename    = "mingw-w64-i686-a52dec-0.7.4-4-any.pkg.tar.xz";
    sha256      = "d73c4eb92801c9069c2a40ebbe48464042dde401cd71c4788fec914937c742d0";
  };

  "mingw-w64-i686-adns" = fetch {
    name        = "mingw-w64-i686-adns";
    version     = "1.4.g10.7";
    filename    = "mingw-w64-i686-adns-1.4.g10.7-1-any.pkg.tar.xz";
    sha256      = "a16b45a41c850cf6ada155b7bdaa795438b3da60b15f65a3777712b816c8a8d0";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-adwaita-icon-theme" = fetch {
    name        = "mingw-w64-i686-adwaita-icon-theme";
    version     = "3.30.1";
    filename    = "mingw-w64-i686-adwaita-icon-theme-3.30.1-1-any.pkg.tar.xz";
    sha256      = "c8d46320740ffdbcb6e5805de15ed929408adcc02781988c1d26aef040309daf";
    buildInputs = [ mingw-w64-i686-hicolor-icon-theme mingw-w64-i686-librsvg ];
  };

  "mingw-w64-i686-ag" = fetch {
    name        = "mingw-w64-i686-ag";
    version     = "2.1.0.r1975.d83e205";
    filename    = "mingw-w64-i686-ag-2.1.0.r1975.d83e205-1-any.pkg.tar.xz";
    sha256      = "873c53dcd29125d98833bc454f356ea03b4aef7c9bdd06639c2fa29e50f110c7";
    buildInputs = [ mingw-w64-i686-pcre mingw-w64-i686-xz mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-alembic" = fetch {
    name        = "mingw-w64-i686-alembic";
    version     = "1.7.10";
    filename    = "mingw-w64-i686-alembic-1.7.10-1-any.pkg.tar.xz";
    sha256      = "999d626f1c03b7842af12336ff47930eb9b6bd638f93c51f29651d918a6ab81c";
    buildInputs = [ mingw-w64-i686-openexr mingw-w64-i686-boost mingw-w64-i686-hdf5 mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-allegro" = fetch {
    name        = "mingw-w64-i686-allegro";
    version     = "5.2.4";
    filename    = "mingw-w64-i686-allegro-5.2.4-2-any.pkg.tar.xz";
    sha256      = "c4acbbf5936e9bb518a5a449516f4fcd71e4373c7fba945e869361660ca59d2e";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-alure" = fetch {
    name        = "mingw-w64-i686-alure";
    version     = "1.2";
    filename    = "mingw-w64-i686-alure-1.2-1-any.pkg.tar.xz";
    sha256      = "16899b9c9642c51fd8c745695a843adee88f1c3024b71f95be8fe10b5266283b";
    buildInputs = [ mingw-w64-i686-openal ];
  };

  "mingw-w64-i686-amtk" = fetch {
    name        = "mingw-w64-i686-amtk";
    version     = "5.0.0";
    filename    = "mingw-w64-i686-amtk-5.0.0-1-any.pkg.tar.xz";
    sha256      = "958814ca43ba487f6f3427e6a834b39e73abd4d6a785a319743044da96e688b2";
    buildInputs = [ mingw-w64-i686-gtk3 ];
  };

  "mingw-w64-i686-angleproject-git" = fetch {
    name        = "mingw-w64-i686-angleproject-git";
    version     = "2.1.r8842";
    filename    = "mingw-w64-i686-angleproject-git-2.1.r8842-1-any.pkg.tar.xz";
    sha256      = "bf2f9c6df1bfc97eb9c0a06956325f95675784ae55ae87021f4c7ff08e135d2c";
    buildInputs = [  ];
  };

  "mingw-w64-i686-ansicon-git" = fetch {
    name        = "mingw-w64-i686-ansicon-git";
    version     = "1.70.r65.3acc7a9";
    filename    = "mingw-w64-i686-ansicon-git-1.70.r65.3acc7a9-2-any.pkg.tar.xz";
    sha256      = "9de19536afa7968807150b96dc3c7104e7315db0938a695034288ee3cfe82bfb";
  };

  "mingw-w64-i686-antiword" = fetch {
    name        = "mingw-w64-i686-antiword";
    version     = "0.37";
    filename    = "mingw-w64-i686-antiword-0.37-2-any.pkg.tar.xz";
    sha256      = "b8dfcf3dde2a65d62941dacaad3cdc49c6f9ca4080144118c9d46207022d39b1";
  };

  "mingw-w64-i686-antlr3" = fetch {
    name        = "mingw-w64-i686-antlr3";
    version     = "3.5.2";
    filename    = "mingw-w64-i686-antlr3-3.5.2-1-any.pkg.tar.xz";
    sha256      = "6ba14d0882f7e2f241fe02945126545103ec53eea452c73226bc600afbef618e";
  };

  "mingw-w64-i686-antlr4-runtime-cpp" = fetch {
    name        = "mingw-w64-i686-antlr4-runtime-cpp";
    version     = "4.7.1";
    filename    = "mingw-w64-i686-antlr4-runtime-cpp-4.7.1-1-any.pkg.tar.xz";
    sha256      = "a2ac881e4e4721fae4415e288e245c9615384cca1ba532f388cca5fc4d564fcf";
  };

  "mingw-w64-i686-aom" = fetch {
    name        = "mingw-w64-i686-aom";
    version     = "1.0.0";
    filename    = "mingw-w64-i686-aom-1.0.0-1-any.pkg.tar.xz";
    sha256      = "771697a9aac997c7cca457cf94152128508107e571a2412d6bfdb6fb6a2e62e0";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-apr" = fetch {
    name        = "mingw-w64-i686-apr";
    version     = "1.6.5";
    filename    = "mingw-w64-i686-apr-1.6.5-1-any.pkg.tar.xz";
    sha256      = "9d7e35df629448874ee8c40f327153b07c21b7a9414c64c6fdb0d65f040b827a";
  };

  "mingw-w64-i686-apr-util" = fetch {
    name        = "mingw-w64-i686-apr-util";
    version     = "1.6.1";
    filename    = "mingw-w64-i686-apr-util-1.6.1-1-any.pkg.tar.xz";
    sha256      = "3b12b43e93d89b718398cf5e7d3923ce488a1c126445240760567108cf41239b";
    buildInputs = [ mingw-w64-i686-apr mingw-w64-i686-expat mingw-w64-i686-sqlite3 ];
  };

  "mingw-w64-i686-argon2" = fetch {
    name        = "mingw-w64-i686-argon2";
    version     = "20171227";
    filename    = "mingw-w64-i686-argon2-20171227-3-any.pkg.tar.xz";
    sha256      = "9fc14b8b72f8a2292d10eeb1e1d4732dc233b90932cea5ebfe5f533679714cf4";
  };

  "mingw-w64-i686-aria2" = fetch {
    name        = "mingw-w64-i686-aria2";
    version     = "1.34.0";
    filename    = "mingw-w64-i686-aria2-1.34.0-2-any.pkg.tar.xz";
    sha256      = "85dfff3f7610dd21ec1395ac289b7cb8d43de04f32224b4886347bc197e68612";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext mingw-w64-i686-c-ares mingw-w64-i686-cppunit mingw-w64-i686-libiconv mingw-w64-i686-libssh2 mingw-w64-i686-libuv mingw-w64-i686-libxml2 mingw-w64-i686-openssl mingw-w64-i686-sqlite3 mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-aribb24" = fetch {
    name        = "mingw-w64-i686-aribb24";
    version     = "1.0.3";
    filename    = "mingw-w64-i686-aribb24-1.0.3-3-any.pkg.tar.xz";
    sha256      = "aeb49b3ff7aeb13193344f2ba6966e9b0c295a1f8337063c3616e9d5dee7d14f";
    buildInputs = [ mingw-w64-i686-libpng ];
  };

  "mingw-w64-i686-armadillo" = fetch {
    name        = "mingw-w64-i686-armadillo";
    version     = "9.200.6";
    filename    = "mingw-w64-i686-armadillo-9.200.6-1-any.pkg.tar.xz";
    sha256      = "4d21615cf30e0ab1496e4092d51bfb375adc54c9fc42190670c76bb6747d46a8";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-arpack mingw-w64-i686-openblas ];
  };

  "mingw-w64-i686-arpack" = fetch {
    name        = "mingw-w64-i686-arpack";
    version     = "3.6.3";
    filename    = "mingw-w64-i686-arpack-3.6.3-1-any.pkg.tar.xz";
    sha256      = "eb3d9c39a55e8f8a3e1d06ba28cb3fb388debb92d74775d56b16a1a645220afc";
    buildInputs = [ mingw-w64-i686-gcc-libgfortran mingw-w64-i686-openblas ];
  };

  "mingw-w64-i686-arrow" = fetch {
    name        = "mingw-w64-i686-arrow";
    version     = "0.11.1";
    filename    = "mingw-w64-i686-arrow-0.11.1-1-any.pkg.tar.xz";
    sha256      = "2085215f4e585e44bfe9ee4cd4c17a1ffca6d085ab841cd008d9f9565f1ec786";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-brotli mingw-w64-i686-flatbuffers mingw-w64-i686-gobject-introspection mingw-w64-i686-lz4 mingw-w64-i686-protobuf mingw-w64-i686-python3-numpy mingw-w64-i686-snappy mingw-w64-i686-zlib mingw-w64-i686-zstd ];
  };

  "mingw-w64-i686-asciidoctor" = fetch {
    name        = "mingw-w64-i686-asciidoctor";
    version     = "1.5.8";
    filename    = "mingw-w64-i686-asciidoctor-1.5.8-1-any.pkg.tar.xz";
    sha256      = "a7097858c8f722f234cb7946637a98ce0e3accb2e9c8cc6a7b75e8fe5ead69de";
    buildInputs = [ mingw-w64-i686-ruby ];
  };

  "mingw-w64-i686-aspell" = fetch {
    name        = "mingw-w64-i686-aspell";
    version     = "0.60.7.rc1";
    filename    = "mingw-w64-i686-aspell-0.60.7.rc1-1-any.pkg.tar.xz";
    sha256      = "59ed9512dbc9703d74e947373eeeabc8d61a358121a38dfddf02b29a34d2985d";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libiconv mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-aspell-de" = fetch {
    name        = "mingw-w64-i686-aspell-de";
    version     = "20161207";
    filename    = "mingw-w64-i686-aspell-de-20161207-1-any.pkg.tar.xz";
    sha256      = "20b45394e95953183d71a8eadc0a97331033b8acd3d3c9143be4286210479439";
    buildInputs = [ mingw-w64-i686-aspell ];
  };

  "mingw-w64-i686-aspell-en" = fetch {
    name        = "mingw-w64-i686-aspell-en";
    version     = "2018.04.16";
    filename    = "mingw-w64-i686-aspell-en-2018.04.16-1-any.pkg.tar.xz";
    sha256      = "a746cc6638796f5a0a9cebe9935bad508837579563b417a2fe1411f0bf2f5b2c";
    buildInputs = [ mingw-w64-i686-aspell ];
  };

  "mingw-w64-i686-aspell-es" = fetch {
    name        = "mingw-w64-i686-aspell-es";
    version     = "1.11.2";
    filename    = "mingw-w64-i686-aspell-es-1.11.2-1-any.pkg.tar.xz";
    sha256      = "1ec62c48a35657fff3a54795a4b5b2d1d6b9e52e0ee30c0894ef49b1a524d724";
    buildInputs = [ mingw-w64-i686-aspell ];
  };

  "mingw-w64-i686-aspell-fr" = fetch {
    name        = "mingw-w64-i686-aspell-fr";
    version     = "0.50.3";
    filename    = "mingw-w64-i686-aspell-fr-0.50.3-1-any.pkg.tar.xz";
    sha256      = "73bd4b0a651f153ae5877d5455c5d08755b4c467f052c756e4c17a18b4300b1a";
    buildInputs = [ mingw-w64-i686-aspell ];
  };

  "mingw-w64-i686-aspell-ru" = fetch {
    name        = "mingw-w64-i686-aspell-ru";
    version     = "0.99f7.1";
    filename    = "mingw-w64-i686-aspell-ru-0.99f7.1-1-any.pkg.tar.xz";
    sha256      = "b847731c943babba48f940448198a46fbeb830d13d4dd4a31d1ed4c4458dca79";
    buildInputs = [ mingw-w64-i686-aspell ];
  };

  "mingw-w64-i686-assimp" = fetch {
    name        = "mingw-w64-i686-assimp";
    version     = "4.1.0";
    filename    = "mingw-w64-i686-assimp-4.1.0-2-any.pkg.tar.xz";
    sha256      = "cdf5495417fcf10bf01b44e2005fc0407c271c514a7287dc6b3dc311ee688909";
    buildInputs = [ mingw-w64-i686-minizip mingw-w64-i686-zziplib mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-astyle" = fetch {
    name        = "mingw-w64-i686-astyle";
    version     = "3.1";
    filename    = "mingw-w64-i686-astyle-3.1-1-any.pkg.tar.xz";
    sha256      = "83639f9828d919c89148ff88bb12b29a57ba3815b3e74202e1096186898f357a";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-atk" = fetch {
    name        = "mingw-w64-i686-atk";
    version     = "2.30.0";
    filename    = "mingw-w64-i686-atk-2.30.0-1-any.pkg.tar.xz";
    sha256      = "8c7d1f4ecaf6832d90277d6bbbffa4a249c44f0cf907aac00b98ba64d655357e";
    buildInputs = [ mingw-w64-i686-gcc-libs (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-glib2.version "2.46.0"; mingw-w64-i686-glib2) ];
  };

  "mingw-w64-i686-atkmm" = fetch {
    name        = "mingw-w64-i686-atkmm";
    version     = "2.28.0";
    filename    = "mingw-w64-i686-atkmm-2.28.0-1-any.pkg.tar.xz";
    sha256      = "d9bf262b7541261b75f04575c15c5ce46ae6a27fbc879504d67798a4a209e2b3";
    buildInputs = [ mingw-w64-i686-atk mingw-w64-i686-gcc-libs mingw-w64-i686-glibmm self."mingw-w64-i686-libsigc++" ];
  };

  "mingw-w64-i686-attica-qt5" = fetch {
    name        = "mingw-w64-i686-attica-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-attica-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "38c9e3d448273422799e409a4854edb6d8333b4feae337281eba1bd2f9fa81c9";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-avrdude" = fetch {
    name        = "mingw-w64-i686-avrdude";
    version     = "6.3";
    filename    = "mingw-w64-i686-avrdude-6.3-2-any.pkg.tar.xz";
    sha256      = "67d63a0fc6e4434ffc413b2c07fdcc289501ee77c4d33c7525b603c5c3e8db6b";
    buildInputs = [ mingw-w64-i686-libftdi mingw-w64-i686-libusb mingw-w64-i686-libusb-compat-git mingw-w64-i686-libelf ];
  };

  "mingw-w64-i686-aztecgen" = fetch {
    name        = "mingw-w64-i686-aztecgen";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-aztecgen-1.0.1-1-any.pkg.tar.xz";
    sha256      = "6eab6ec81927b8efe391727de9fef738b22eb102c222d91e7d91179cf7677acc";
  };

  "mingw-w64-i686-babl" = fetch {
    name        = "mingw-w64-i686-babl";
    version     = "0.1.60";
    filename    = "mingw-w64-i686-babl-0.1.60-1-any.pkg.tar.xz";
    sha256      = "cf78f2a0861281c80935536c0c2bee69110be2e1d976850bffe91f46b57bf7a7";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-badvpn" = fetch {
    name        = "mingw-w64-i686-badvpn";
    version     = "1.999.130";
    filename    = "mingw-w64-i686-badvpn-1.999.130-2-any.pkg.tar.xz";
    sha256      = "d65842dbf8483d1e4db63ec697b940bd7bf027801d5b482f328dfa087c8ec658";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-nspr mingw-w64-i686-nss mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-bcunit" = fetch {
    name        = "mingw-w64-i686-bcunit";
    version     = "3.0.2";
    filename    = "mingw-w64-i686-bcunit-3.0.2-1-any.pkg.tar.xz";
    sha256      = "a3271a76a26f9485d34c6dd280da3cf977948a243ff699671ac7157c66d3d21c";
  };

  "mingw-w64-i686-benchmark" = fetch {
    name        = "mingw-w64-i686-benchmark";
    version     = "1.4.1";
    filename    = "mingw-w64-i686-benchmark-1.4.1-1-any.pkg.tar.xz";
    sha256      = "02c75aab15b9a3f44c6286d8fb325465a791544f974b8a1afa92d336a185d508";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-binaryen" = fetch {
    name        = "mingw-w64-i686-binaryen";
    version     = "55";
    filename    = "mingw-w64-i686-binaryen-55-1-any.pkg.tar.xz";
    sha256      = "d413efb5f753fe6d830136ad4db7c87e1c26e4a2b1c30d69fdace0cbf85e0c60";
  };

  "mingw-w64-i686-binutils" = fetch {
    name        = "mingw-w64-i686-binutils";
    version     = "2.30";
    filename    = "mingw-w64-i686-binutils-2.30-5-any.pkg.tar.xz";
    sha256      = "e674a1bc62ceb9cb62b84191123c3c2a630ed883bcfeaa3757d1cb48b7ea8c9d";
    buildInputs = [ mingw-w64-i686-libiconv mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-blender" = fetch {
    name        = "mingw-w64-i686-blender";
    version     = "2.79.b";
    filename    = "mingw-w64-i686-blender-2.79.b-6-any.pkg.tar.xz";
    sha256      = "c8d913f94e336482cc81a59ddd5a322c12ae8b880259e3f9d2b2f61cf6a2f97c";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-llvm mingw-w64-i686-eigen3 mingw-w64-i686-glew mingw-w64-i686-ffmpeg mingw-w64-i686-fftw mingw-w64-i686-freetype mingw-w64-i686-libpng mingw-w64-i686-libsndfile mingw-w64-i686-libtiff mingw-w64-i686-lzo2 mingw-w64-i686-openexr mingw-w64-i686-openal mingw-w64-i686-opencollada-git mingw-w64-i686-opencolorio-git mingw-w64-i686-openimageio mingw-w64-i686-openshadinglanguage mingw-w64-i686-pugixml mingw-w64-i686-python3 mingw-w64-i686-python3-numpy mingw-w64-i686-SDL2 mingw-w64-i686-wintab-sdk ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-blosc" = fetch {
    name        = "mingw-w64-i686-blosc";
    version     = "1.15.1";
    filename    = "mingw-w64-i686-blosc-1.15.1-1-any.pkg.tar.xz";
    sha256      = "2a8b32e343d604f17730256a893a1ade27ddfe2f4b262521cb39ceaccb007607";
    buildInputs = [ mingw-w64-i686-snappy mingw-w64-i686-zstd mingw-w64-i686-zlib mingw-w64-i686-lz4 ];
  };

  "mingw-w64-i686-boost" = fetch {
    name        = "mingw-w64-i686-boost";
    version     = "1.69.0";
    filename    = "mingw-w64-i686-boost-1.69.0-2-any.pkg.tar.xz";
    sha256      = "5486ddf969b304cff308beb5541ae76757ab445a433fc8249a76f94626b93bff";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-bzip2 mingw-w64-i686-icu mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-bower" = fetch {
    name        = "mingw-w64-i686-bower";
    version     = "1.8.4";
    filename    = "mingw-w64-i686-bower-1.8.4-1-any.pkg.tar.xz";
    sha256      = "7d30a94b588cda4e960c2ca471c052ada82e294d7643b98a912362e103561c47";
    buildInputs = [ mingw-w64-i686-nodejs ];
  };

  "mingw-w64-i686-box2d" = fetch {
    name        = "mingw-w64-i686-box2d";
    version     = "2.3.1";
    filename    = "mingw-w64-i686-box2d-2.3.1-2-any.pkg.tar.xz";
    sha256      = "f2e11ecf0d9438121c880d83b2dd21a4a7d5538081befabf4ccb58a2fe06ed13";
  };

  "mingw-w64-i686-breakpad-git" = fetch {
    name        = "mingw-w64-i686-breakpad-git";
    version     = "r1680.70914b2d";
    filename    = "mingw-w64-i686-breakpad-git-r1680.70914b2d-1-any.pkg.tar.xz";
    sha256      = "d0e1988e2268bfa036a56164d57e496b5a30660b69b7deca9dac25861d5c9be3";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-breeze-icons-qt5" = fetch {
    name        = "mingw-w64-i686-breeze-icons-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-breeze-icons-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "6d70fc0809d2cc68d5debd25e13f6bb519bb3bdbcb94429cf694859d6085209b";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-brotli" = fetch {
    name        = "mingw-w64-i686-brotli";
    version     = "1.0.7";
    filename    = "mingw-w64-i686-brotli-1.0.7-1-any.pkg.tar.xz";
    sha256      = "96c843fe9fa3315d57abbf7de59ac1dadbcbda9945f0b6ffff293e4c1f06dc89";
    buildInputs = [  ];
  };

  "mingw-w64-i686-brotli-testdata" = fetch {
    name        = "mingw-w64-i686-brotli-testdata";
    version     = "1.0.7";
    filename    = "mingw-w64-i686-brotli-testdata-1.0.7-1-any.pkg.tar.xz";
    sha256      = "2b755922abacf63650758eb9e744b562141bea262f8ee7fde32d345cc6178744";
    buildInputs = [ mingw-w64-i686-brotli ];
  };

  "mingw-w64-i686-bsdfprocessor" = fetch {
    name        = "mingw-w64-i686-bsdfprocessor";
    version     = "1.1.6";
    filename    = "mingw-w64-i686-bsdfprocessor-1.1.6-1-any.pkg.tar.xz";
    sha256      = "5c361d68f022ca099eb485993aa72e216c6f215a9613c6fdfc6d3e13d05b564e";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-qt5 mingw-w64-i686-OpenSceneGraph ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-bullet" = fetch {
    name        = "mingw-w64-i686-bullet";
    version     = "2.87";
    filename    = "mingw-w64-i686-bullet-2.87-1-any.pkg.tar.xz";
    sha256      = "f41ac067977cf45bebe427f2a9064e571b8fb292d0934f07de9799aa0eccc888";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-freeglut mingw-w64-i686-openvr ];
  };

  "mingw-w64-i686-bullet-debug" = fetch {
    name        = "mingw-w64-i686-bullet-debug";
    version     = "2.87";
    filename    = "mingw-w64-i686-bullet-debug-2.87-1-any.pkg.tar.xz";
    sha256      = "3d17f4558a6144a965a218003ef1aa8e84a944d5006f314a9f2f6d06d18ecfdd";
    buildInputs = [ (assert mingw-w64-i686-bullet.version=="2.87"; mingw-w64-i686-bullet) ];
  };

  "mingw-w64-i686-bwidget" = fetch {
    name        = "mingw-w64-i686-bwidget";
    version     = "1.9.12";
    filename    = "mingw-w64-i686-bwidget-1.9.12-1-any.pkg.tar.xz";
    sha256      = "f172e9bb092f0ca72766b9adf02c690fc93bef7a32680a09605c48fe753339e0";
    buildInputs = [ mingw-w64-i686-tk ];
  };

  "mingw-w64-i686-bzip2" = fetch {
    name        = "mingw-w64-i686-bzip2";
    version     = "1.0.6";
    filename    = "mingw-w64-i686-bzip2-1.0.6-6-any.pkg.tar.xz";
    sha256      = "13d945e5714485c9a2710c0ad6838a5617fecc6b50554040ee5ad98ce5d80a6b";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-c-ares" = fetch {
    name        = "mingw-w64-i686-c-ares";
    version     = "1.15.0";
    filename    = "mingw-w64-i686-c-ares-1.15.0-1-any.pkg.tar.xz";
    sha256      = "efa45e7980e3372150c38269d7ba7e90650dbf710a6b05f73f6c6a024751855e";
    buildInputs = [  ];
  };

  "mingw-w64-i686-c99-to-c89-git" = fetch {
    name        = "mingw-w64-i686-c99-to-c89-git";
    version     = "r169.b3d496d";
    filename    = "mingw-w64-i686-c99-to-c89-git-r169.b3d496d-1-any.pkg.tar.xz";
    sha256      = "bb951699836d5e4ccf70d95e1ee159e62756ab65ed381fae1d3242f1a4375b6a";
    buildInputs = [ mingw-w64-i686-clang ];
  };

  "mingw-w64-i686-ca-certificates" = fetch {
    name        = "mingw-w64-i686-ca-certificates";
    version     = "20180409";
    filename    = "mingw-w64-i686-ca-certificates-20180409-1-any.pkg.tar.xz";
    sha256      = "f4bc34f1b07bff014cc8fecb2c32b892f39b9dd0d3daf850337a0d07dec63269";
    buildInputs = [ mingw-w64-i686-p11-kit ];
  };

  "mingw-w64-i686-cairo" = fetch {
    name        = "mingw-w64-i686-cairo";
    version     = "1.16.0";
    filename    = "mingw-w64-i686-cairo-1.16.0-1-any.pkg.tar.xz";
    sha256      = "84e6ee664eefc6b3e9ba1f35476d31e83fd8c7e7ba5edcdb4dd74a44df964566";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-freetype mingw-w64-i686-fontconfig mingw-w64-i686-lzo2 mingw-w64-i686-pixman mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-cairomm" = fetch {
    name        = "mingw-w64-i686-cairomm";
    version     = "1.12.2";
    filename    = "mingw-w64-i686-cairomm-1.12.2-2-any.pkg.tar.xz";
    sha256      = "86b66ec2e620d172f10db3416ddfbba80a414972dbf29d354ac59cc0ab96fd06";
    buildInputs = [ self."mingw-w64-i686-libsigc++" mingw-w64-i686-cairo ];
  };

  "mingw-w64-i686-capstone" = fetch {
    name        = "mingw-w64-i686-capstone";
    version     = "4.0";
    filename    = "mingw-w64-i686-capstone-4.0-1-any.pkg.tar.xz";
    sha256      = "7a67855cb904996c38f220abd96b7b8c05b0932b42a0c0f4209ee27217a17b81";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-catch" = fetch {
    name        = "mingw-w64-i686-catch";
    version     = "1.6.0";
    filename    = "mingw-w64-i686-catch-1.6.0-1-any.pkg.tar.xz";
    sha256      = "23478123bc6171ed0ebda0fec76e2c354a4accb91748059703c0dcb57733c964";
  };

  "mingw-w64-i686-ccache" = fetch {
    name        = "mingw-w64-i686-ccache";
    version     = "3.5";
    filename    = "mingw-w64-i686-ccache-3.5-1-any.pkg.tar.xz";
    sha256      = "242b7de24d96d2ba3d7135c6c25140bd536f2318441aa0138b48041868caa947";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-cccl" = fetch {
    name        = "mingw-w64-i686-cccl";
    version     = "1.0";
    filename    = "mingw-w64-i686-cccl-1.0-1-any.pkg.tar.xz";
    sha256      = "4821c594f85d151695684e932e6d82cd2835fc08c16d1be4e43c3e4559934cde";
  };

  "mingw-w64-i686-cego" = fetch {
    name        = "mingw-w64-i686-cego";
    version     = "2.42.16";
    filename    = "mingw-w64-i686-cego-2.42.16-1-any.pkg.tar.xz";
    sha256      = "1a8f9ee27d8b11ccc79d50c50c0fe82362237b67bfed1921753b9bf7487edb1d";
    buildInputs = [ mingw-w64-i686-readline mingw-w64-i686-lfcbase mingw-w64-i686-lfcxml ];
  };

  "mingw-w64-i686-cegui" = fetch {
    name        = "mingw-w64-i686-cegui";
    version     = "0.8.7";
    filename    = "mingw-w64-i686-cegui-0.8.7-1-any.pkg.tar.xz";
    sha256      = "782946ca7dd546dfa0c2e79af477ef51e61caf364f0b6fb7ae83cc2a680b6265";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-devil mingw-w64-i686-expat mingw-w64-i686-FreeImage mingw-w64-i686-freetype mingw-w64-i686-fribidi mingw-w64-i686-glew mingw-w64-i686-glfw mingw-w64-i686-glm mingw-w64-i686-irrlicht mingw-w64-i686-libepoxy mingw-w64-i686-libxml2 mingw-w64-i686-libiconv mingw-w64-i686-lua51 mingw-w64-i686-ogre3d mingw-w64-i686-ois-git mingw-w64-i686-openexr mingw-w64-i686-pcre mingw-w64-i686-python2 mingw-w64-i686-SDL2 mingw-w64-i686-SDL2_image mingw-w64-i686-tinyxml mingw-w64-i686-xerces-c mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-cegui -> mingw-w64-i686-FreeImage
  };

  "mingw-w64-i686-celt" = fetch {
    name        = "mingw-w64-i686-celt";
    version     = "0.11.3";
    filename    = "mingw-w64-i686-celt-0.11.3-4-any.pkg.tar.xz";
    sha256      = "0e62b1c678e1faa178b5a6731abd3bc790de26b189bd8322951144934d61f825";
    buildInputs = [ mingw-w64-i686-libogg ];
  };

  "mingw-w64-i686-cereal" = fetch {
    name        = "mingw-w64-i686-cereal";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-cereal-1.2.2-1-any.pkg.tar.xz";
    sha256      = "e48f4df8345f4e73cada4005f1928b5812db5f880af78cedbef9dab5eb64dedc";
    buildInputs = [ mingw-w64-i686-boost ];
  };

  "mingw-w64-i686-ceres-solver" = fetch {
    name        = "mingw-w64-i686-ceres-solver";
    version     = "1.14.0";
    filename    = "mingw-w64-i686-ceres-solver-1.14.0-3-any.pkg.tar.xz";
    sha256      = "bf871c19cbf0736ae508e810e8f71139d53f18f97df63f68fa939b40d9172fef";
    buildInputs = [ mingw-w64-i686-eigen3 mingw-w64-i686-glog mingw-w64-i686-suitesparse ];
  };

  "mingw-w64-i686-cfitsio" = fetch {
    name        = "mingw-w64-i686-cfitsio";
    version     = "3.450";
    filename    = "mingw-w64-i686-cfitsio-3.450-1-any.pkg.tar.xz";
    sha256      = "ade5a6dc405ff2d2c782769fd3acb7f0233531f3a9455f4d9d55bc8b865a0af8";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-cgal" = fetch {
    name        = "mingw-w64-i686-cgal";
    version     = "4.13";
    filename    = "mingw-w64-i686-cgal-4.13-1-any.pkg.tar.xz";
    sha256      = "a6177dd3cd71ee910f369c3d3037e0eb3d2b11464562cf861e5585c8cb08a5d4";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-boost mingw-w64-i686-gmp mingw-w64-i686-mpfr ];
  };

  "mingw-w64-i686-cgns" = fetch {
    name        = "mingw-w64-i686-cgns";
    version     = "3.3.1";
    filename    = "mingw-w64-i686-cgns-3.3.1-1-any.pkg.tar.xz";
    sha256      = "fbb4eb7a214aad5d547cf4c90ef32253adbc251fcff98aee1c2101e8c7102fab";
    buildInputs = [ mingw-w64-i686-hdf5 ];
  };

  "mingw-w64-i686-check" = fetch {
    name        = "mingw-w64-i686-check";
    version     = "0.12.0";
    filename    = "mingw-w64-i686-check-0.12.0-1-any.pkg.tar.xz";
    sha256      = "50d76ea2540c4c12ec04083c0227992bf166dba3a184505ac7812e51451d8f98";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-chipmunk" = fetch {
    name        = "mingw-w64-i686-chipmunk";
    version     = "7.0.2";
    filename    = "mingw-w64-i686-chipmunk-7.0.2-1-any.pkg.tar.xz";
    sha256      = "8f4b78accc5b9a35ade38146094b50b1fb4878eb75d6551b4be99dd2da1c12f0";
  };

  "mingw-w64-i686-chromaprint" = fetch {
    name        = "mingw-w64-i686-chromaprint";
    version     = "1.4.3";
    filename    = "mingw-w64-i686-chromaprint-1.4.3-1-any.pkg.tar.xz";
    sha256      = "8b60b50719971d53f1736f20fe19ffca76cfba75b6124a383f7ba13f1b8781f0";
  };

  "mingw-w64-i686-clang" = fetch {
    name        = "mingw-w64-i686-clang";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-clang-7.0.1-1-any.pkg.tar.xz";
    sha256      = "bda93129f81f969bc892f133085d117d5a2679e8d2d74941fe283b91267143ef";
    buildInputs = [ (assert mingw-w64-i686-llvm.version=="7.0.1"; mingw-w64-i686-llvm) mingw-w64-i686-gcc mingw-w64-i686-z3 ];
  };

  "mingw-w64-i686-clang-analyzer" = fetch {
    name        = "mingw-w64-i686-clang-analyzer";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-clang-analyzer-7.0.1-1-any.pkg.tar.xz";
    sha256      = "bac6ea3d94514a208d3e5040c9c48262a475c150013ae5eba868d11879bc03c1";
    buildInputs = [ (assert mingw-w64-i686-clang.version=="7.0.1"; mingw-w64-i686-clang) mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-clang-tools-extra" = fetch {
    name        = "mingw-w64-i686-clang-tools-extra";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-clang-tools-extra-7.0.1-1-any.pkg.tar.xz";
    sha256      = "458fa4d72ac4d134c15ddc812bd404c96eafd1431ef1d82e89849fca30961ac2";
    buildInputs = [ mingw-w64-i686-gcc ];
  };

  "mingw-w64-i686-clucene" = fetch {
    name        = "mingw-w64-i686-clucene";
    version     = "2.3.3.4";
    filename    = "mingw-w64-i686-clucene-2.3.3.4-1-any.pkg.tar.xz";
    sha256      = "716ab5f7d550885f5f85a50b8747ae6dcaa92ca090c14058ff6270fba2ad224c";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-clutter" = fetch {
    name        = "mingw-w64-i686-clutter";
    version     = "1.26.2";
    filename    = "mingw-w64-i686-clutter-1.26.2-1-any.pkg.tar.xz";
    sha256      = "bcd25842c0dd969706dff468533326eea4497e7548ee05617f6648998f1d1b20";
    buildInputs = [ mingw-w64-i686-atk mingw-w64-i686-cogl mingw-w64-i686-json-glib mingw-w64-i686-gobject-introspection-runtime mingw-w64-i686-gtk3 ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-clutter-gst" = fetch {
    name        = "mingw-w64-i686-clutter-gst";
    version     = "3.0.26";
    filename    = "mingw-w64-i686-clutter-gst-3.0.26-1-any.pkg.tar.xz";
    sha256      = "f3f339a8f8d672d7388bc2d1bcb63bd6b1038c88c3939912eff5d5fd19adcdc5";
    buildInputs = [ mingw-w64-i686-gobject-introspection mingw-w64-i686-clutter mingw-w64-i686-gstreamer mingw-w64-i686-gst-plugins-base ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-clutter-gtk" = fetch {
    name        = "mingw-w64-i686-clutter-gtk";
    version     = "1.8.4";
    filename    = "mingw-w64-i686-clutter-gtk-1.8.4-1-any.pkg.tar.xz";
    sha256      = "82ac78fd5ac0e56087e661d327c9544ff3913d1db5a658e3d09fa007925f105f";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-clutter ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-cmake" = fetch {
    name        = "mingw-w64-i686-cmake";
    version     = "3.12.4";
    filename    = "mingw-w64-i686-cmake-3.12.4-1-any.pkg.tar.xz";
    sha256      = "6a97409f3e3ed549efe744e95737bbaddbd4cb1e7e328e945b4e044f3c49835a";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-curl mingw-w64-i686-expat mingw-w64-i686-jsoncpp mingw-w64-i686-libarchive mingw-w64-i686-libuv mingw-w64-i686-rhash mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-cmake-doc-qt" = fetch {
    name        = "mingw-w64-i686-cmake-doc-qt";
    version     = "3.12.4";
    filename    = "mingw-w64-i686-cmake-doc-qt-3.12.4-1-any.pkg.tar.xz";
    sha256      = "da9d1faa925b2f2d21c2331954f65e1effa2714bf8ffaaacd6cbf5b71f0a4c30";
  };

  "mingw-w64-i686-cmark" = fetch {
    name        = "mingw-w64-i686-cmark";
    version     = "0.28.3";
    filename    = "mingw-w64-i686-cmark-0.28.3-1-any.pkg.tar.xz";
    sha256      = "ac8e31606d88da0067f6f6b25cbb34ea551ce80a99c64359d267c7737a12e900";
  };

  "mingw-w64-i686-cmocka" = fetch {
    name        = "mingw-w64-i686-cmocka";
    version     = "1.1.3";
    filename    = "mingw-w64-i686-cmocka-1.1.3-2-any.pkg.tar.xz";
    sha256      = "241a83bd995d05de928be8aaac6c28e379e7bf8e418edc09226f73b20f980164";
  };

  "mingw-w64-i686-codelite-git" = fetch {
    name        = "mingw-w64-i686-codelite-git";
    version     = "12.0.656.g3349d0f7d";
    filename    = "mingw-w64-i686-codelite-git-12.0.656.g3349d0f7d-1-any.pkg.tar.xz";
    sha256      = "a3bf62f96eb86418c6e5bf3d3064af1f3eca435dfddcc951c70da25551c4fdcd";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-hunspell mingw-w64-i686-libssh mingw-w64-i686-drmingw mingw-w64-i686-clang mingw-w64-i686-wxWidgets mingw-w64-i686-sqlite3 ];
  };

  "mingw-w64-i686-cogl" = fetch {
    name        = "mingw-w64-i686-cogl";
    version     = "1.22.2";
    filename    = "mingw-w64-i686-cogl-1.22.2-1-any.pkg.tar.xz";
    sha256      = "31d417d1effc2c5469196470b37095155a9d7c13d4191eaae70258ad46e0537f";
    buildInputs = [ mingw-w64-i686-pango mingw-w64-i686-gdk-pixbuf2 mingw-w64-i686-gstreamer mingw-w64-i686-gst-plugins-base ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-coin3d-hg" = fetch {
    name        = "mingw-w64-i686-coin3d-hg";
    version     = "r11819+.c0999df53040+";
    filename    = "mingw-w64-i686-coin3d-hg-r11819+.c0999df53040+-1-any.pkg.tar.xz";
    sha256      = "2be655bc6078f58ecd35e2d02573ddf1ebe6ba493e47ee059e1639915bafbfa0";
    buildInputs = [ mingw-w64-i686-simage mingw-w64-i686-bzip2 mingw-w64-i686-expat mingw-w64-i686-openal mingw-w64-i686-superglu mingw-w64-i686-freetype mingw-w64-i686-fontconfig mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-coin3d-hg -> mingw-w64-i686-simage
  };

  "mingw-w64-i686-collada-dom-svn" = fetch {
    name        = "mingw-w64-i686-collada-dom-svn";
    version     = "2.4.1.r889";
    filename    = "mingw-w64-i686-collada-dom-svn-2.4.1.r889-7-any.pkg.tar.xz";
    sha256      = "41f453341f70c352a79c322ce7400af1405b8cf8999e0be9a5e79ca51ae9d139";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-boost mingw-w64-i686-libxml2 mingw-w64-i686-pcre mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-compiler-rt" = fetch {
    name        = "mingw-w64-i686-compiler-rt";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-compiler-rt-7.0.1-1-any.pkg.tar.xz";
    sha256      = "bc4aee21ea4a3567f224d9fa30bf0db5a5a4ced3feba5dbb83464b637b8a1ce4";
    buildInputs = [ (assert mingw-w64-i686-llvm.version=="7.0.1"; mingw-w64-i686-llvm) ];
  };

  "mingw-w64-i686-confuse" = fetch {
    name        = "mingw-w64-i686-confuse";
    version     = "3.2.2";
    filename    = "mingw-w64-i686-confuse-3.2.2-1-any.pkg.tar.xz";
    sha256      = "501c555965b1ef2cce39e68b039e705966d51afc4d8de68bbbc4b71b5a9379c6";
    buildInputs = [ mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-connect" = fetch {
    name        = "mingw-w64-i686-connect";
    version     = "1.105";
    filename    = "mingw-w64-i686-connect-1.105-1-any.pkg.tar.xz";
    sha256      = "ef92b2908b0fce9a1429b30597210f16cbf7c3bfd7e6dfe63922471151d264b0";
  };

  "mingw-w64-i686-cotire" = fetch {
    name        = "mingw-w64-i686-cotire";
    version     = "1.8.0_3.12";
    filename    = "mingw-w64-i686-cotire-1.8.0_3.12-2-any.pkg.tar.xz";
    sha256      = "4e3c5be165478e442f094ace04f7cf1b9a167084dd75bfc1dabfdeb285dde547";
  };

  "mingw-w64-i686-cppcheck" = fetch {
    name        = "mingw-w64-i686-cppcheck";
    version     = "1.86";
    filename    = "mingw-w64-i686-cppcheck-1.86-1-any.pkg.tar.xz";
    sha256      = "874a6b1a9be4c7e6af26667b2ed9e7f31e79d7fa20ad0bcbd16da3c730b5ade4";
    buildInputs = [ mingw-w64-i686-pcre ];
  };

  "mingw-w64-i686-cppreference-qt" = fetch {
    name        = "mingw-w64-i686-cppreference-qt";
    version     = "20181028";
    filename    = "mingw-w64-i686-cppreference-qt-20181028-1-any.pkg.tar.xz";
    sha256      = "d66202f1423dbf0fed89fa6eced7c5464e5e892cb22d4ffd72a613d36bb5ac38";
  };

  "mingw-w64-i686-cpptest" = fetch {
    name        = "mingw-w64-i686-cpptest";
    version     = "1.1.2";
    filename    = "mingw-w64-i686-cpptest-1.1.2-2-any.pkg.tar.xz";
    sha256      = "e537273efbef813f604de0ac62a5ace2de301ea198a85e2a3f03bf0698883438";
  };

  "mingw-w64-i686-cppunit" = fetch {
    name        = "mingw-w64-i686-cppunit";
    version     = "1.14.0";
    filename    = "mingw-w64-i686-cppunit-1.14.0-1-any.pkg.tar.xz";
    sha256      = "0d9f9246d4ddcc8f7faa3b804f8098dfa8a32ee158bc624796fe6cd573fae29c";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-creduce" = fetch {
    name        = "mingw-w64-i686-creduce";
    version     = "2.8.0";
    filename    = "mingw-w64-i686-creduce-2.8.0-1-any.pkg.tar.xz";
    sha256      = "85a76386a21c2b044e5d0eb552365f4acd04f17819a842c8e06e110fde46affd";
    buildInputs = [ perl-Benchmark-Timer perl-Exporter-Lite perl-File-Which perl-Getopt-Tabular perl-Regexp-Common perl-Sys-CPU mingw-w64-i686-astyle mingw-w64-i686-indent mingw-w64-i686-clang ];
    broken      = true; # broken dependency mingw-w64-i686-creduce -> perl-Benchmark-Timer
  };

  "mingw-w64-i686-crt-git" = fetch {
    name        = "mingw-w64-i686-crt-git";
    version     = "7.0.0.5285.7b2baaf8";
    filename    = "mingw-w64-i686-crt-git-7.0.0.5285.7b2baaf8-1-any.pkg.tar.xz";
    sha256      = "796f649e9fcff3300754018791d2a92a57b6ab617c6c43c166d1fb1c291a3efb";
    buildInputs = [ mingw-w64-i686-headers-git ];
  };

  "mingw-w64-i686-crypto++" = fetch {
    name        = "mingw-w64-i686-crypto++";
    version     = "7.0.0";
    filename    = "mingw-w64-i686-crypto++-7.0.0-1-any.pkg.tar.xz";
    sha256      = "8aad0ef471b039ff57cdc6c394d141a4d86c6e940bb7c8ac9731148e57b3c3c6";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-csfml" = fetch {
    name        = "mingw-w64-i686-csfml";
    version     = "2.5";
    filename    = "mingw-w64-i686-csfml-2.5-1-any.pkg.tar.xz";
    sha256      = "e9ae0abde77aa6c05f705e059d68f75465de28978ace6becba84aa41cb077857";
    buildInputs = [ mingw-w64-i686-sfml ];
    broken      = true; # broken dependency mingw-w64-i686-sfml -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-ctags" = fetch {
    name        = "mingw-w64-i686-ctags";
    version     = "5.8";
    filename    = "mingw-w64-i686-ctags-5.8-5-any.pkg.tar.xz";
    sha256      = "15c74d48ad9a33a13ae5a088dea004ed710f3e8f0e11590a53606f8853629523";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-ctpl-git" = fetch {
    name        = "mingw-w64-i686-ctpl-git";
    version     = "0.3.3.391.6dd5c14";
    filename    = "mingw-w64-i686-ctpl-git-0.3.3.391.6dd5c14-1-any.pkg.tar.xz";
    sha256      = "12139f316f696e6ae7a18b9b8e22cadc24e132e473ecd44205bf0706eda78af5";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-cunit" = fetch {
    name        = "mingw-w64-i686-cunit";
    version     = "2.1.3";
    filename    = "mingw-w64-i686-cunit-2.1.3-3-any.pkg.tar.xz";
    sha256      = "742db796b52e0b80854262e1c661b4dda26e2f18a1e624eb2ae591747a581395";
  };

  "mingw-w64-i686-curl" = fetch {
    name        = "mingw-w64-i686-curl";
    version     = "7.63.0";
    filename    = "mingw-w64-i686-curl-7.63.0-2-any.pkg.tar.xz";
    sha256      = "4fac1443425e1f2cb202ea02ed5d87e30e3324e30c95fe01feccbde4cd5737e0";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-c-ares mingw-w64-i686-brotli mingw-w64-i686-libidn2 mingw-w64-i686-libmetalink mingw-w64-i686-libpsl mingw-w64-i686-libssh2 mingw-w64-i686-zlib mingw-w64-i686-ca-certificates mingw-w64-i686-openssl mingw-w64-i686-nghttp2 ];
  };

  "mingw-w64-i686-cvode" = fetch {
    name        = "mingw-w64-i686-cvode";
    version     = "3.2.1";
    filename    = "mingw-w64-i686-cvode-3.2.1-1-any.pkg.tar.xz";
    sha256      = "f89e1a67ddb4bca0962c8a23afd5a247128bee5dd2805231419e6ad102e4b4e9";
  };

  "mingw-w64-i686-cyrus-sasl" = fetch {
    name        = "mingw-w64-i686-cyrus-sasl";
    version     = "2.1.27.rc8";
    filename    = "mingw-w64-i686-cyrus-sasl-2.1.27.rc8-1-any.pkg.tar.xz";
    sha256      = "5ec034c4f58da55fe7401f699c58ff1c392c92255d042f8bb8c7e862c597c1cd";
    buildInputs = [ mingw-w64-i686-gdbm mingw-w64-i686-openssl mingw-w64-i686-sqlite3 ];
  };

  "mingw-w64-i686-cython" = fetch {
    name        = "mingw-w64-i686-cython";
    version     = "0.29.2";
    filename    = "mingw-w64-i686-cython-0.29.2-1-any.pkg.tar.xz";
    sha256      = "cd165df2ae7f170cacb1070f0a6230a051d5bb40e906a9e20d887a8d785a03e2";
    buildInputs = [ mingw-w64-i686-python3-setuptools ];
  };

  "mingw-w64-i686-cython2" = fetch {
    name        = "mingw-w64-i686-cython2";
    version     = "0.29.2";
    filename    = "mingw-w64-i686-cython2-0.29.2-1-any.pkg.tar.xz";
    sha256      = "e6d1c075df2b1210d99c4c3feb16be6ca7059100d110dde5502531e4a2a51417";
    buildInputs = [ mingw-w64-i686-python2-setuptools ];
  };

  "mingw-w64-i686-d-feet" = fetch {
    name        = "mingw-w64-i686-d-feet";
    version     = "0.3.14";
    filename    = "mingw-w64-i686-d-feet-0.3.14-1-any.pkg.tar.xz";
    sha256      = "bec071b2fbc6049fa3d5e1cd42d7f0315bc9c647e937a5cd15aaf5c0271d6e67";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-python3-gobject mingw-w64-i686-hicolor-icon-theme ];
  };

  "mingw-w64-i686-daala-git" = fetch {
    name        = "mingw-w64-i686-daala-git";
    version     = "r1505.52bbd43";
    filename    = "mingw-w64-i686-daala-git-r1505.52bbd43-1-any.pkg.tar.xz";
    sha256      = "bf621212534ff31f9c2118d0a26d0296e755401f96f23d1c3693275011e88e07";
    buildInputs = [ mingw-w64-i686-libogg mingw-w64-i686-libpng mingw-w64-i686-libjpeg-turbo mingw-w64-i686-SDL2 ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-db" = fetch {
    name        = "mingw-w64-i686-db";
    version     = "6.0.19";
    filename    = "mingw-w64-i686-db-6.0.19-3-any.pkg.tar.xz";
    sha256      = "697ee9a850215a361b85a3b330d1d3ec110e21ba653c96ef84901bfd3be360f6";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-dbus" = fetch {
    name        = "mingw-w64-i686-dbus";
    version     = "1.12.12";
    filename    = "mingw-w64-i686-dbus-1.12.12-1-any.pkg.tar.xz";
    sha256      = "f3022d2304f009af1304fca08e27af84c1b111799b10db5dc04a51bf5fb81798";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-expat ];
  };

  "mingw-w64-i686-dbus-c++" = fetch {
    name        = "mingw-w64-i686-dbus-c++";
    version     = "0.9.0";
    filename    = "mingw-w64-i686-dbus-c++-0.9.0-1-any.pkg.tar.xz";
    sha256      = "8347bdbb0730468a70fc9834b927f1c1b1706a7afe6256fb057acb782aed9359";
    buildInputs = [ mingw-w64-i686-dbus ];
  };

  "mingw-w64-i686-dbus-glib" = fetch {
    name        = "mingw-w64-i686-dbus-glib";
    version     = "0.110";
    filename    = "mingw-w64-i686-dbus-glib-0.110-1-any.pkg.tar.xz";
    sha256      = "8a1382afd27e39bab76d705c77370705ac04539f989bc15872162776232202b0";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-dbus mingw-w64-i686-expat ];
  };

  "mingw-w64-i686-dcadec" = fetch {
    name        = "mingw-w64-i686-dcadec";
    version     = "0.2.0";
    filename    = "mingw-w64-i686-dcadec-0.2.0-2-any.pkg.tar.xz";
    sha256      = "db8c66b5b508acd0456927a4067d172a45dc77c4b54bc68ec15d8b96003d7c38";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-desktop-file-utils" = fetch {
    name        = "mingw-w64-i686-desktop-file-utils";
    version     = "0.23";
    filename    = "mingw-w64-i686-desktop-file-utils-0.23-1-any.pkg.tar.xz";
    sha256      = "8b4c1a3dbd5916571f1aff2063f6b9dff39c69a490365daaaa5741326ed13dec";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gtk3 mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-devcon-git" = fetch {
    name        = "mingw-w64-i686-devcon-git";
    version     = "r233.8b17cf3";
    filename    = "mingw-w64-i686-devcon-git-r233.8b17cf3-1-any.pkg.tar.xz";
    sha256      = "74c514ee965c361ab0b2eba285910678a4e084f329d453746e44a550788b12cc";
  };

  "mingw-w64-i686-devhelp" = fetch {
    name        = "mingw-w64-i686-devhelp";
    version     = "3.8.2";
    filename    = "mingw-w64-i686-devhelp-3.8.2-2-any.pkg.tar.xz";
    sha256      = "23d10605b1d7b46683ff48dec182339372d4baac583756dda2a52be1602624cc";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-adwaita-icon-theme mingw-w64-i686-webkitgtk3 mingw-w64-i686-png2ico mingw-w64-i686-python2 ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-devil" = fetch {
    name        = "mingw-w64-i686-devil";
    version     = "1.8.0";
    filename    = "mingw-w64-i686-devil-1.8.0-4-any.pkg.tar.xz";
    sha256      = "514fe00a30a3e81131b37d691a521517f12e7f695b22347a6149a117b3610a95";
    buildInputs = [ mingw-w64-i686-freeglut mingw-w64-i686-jasper mingw-w64-i686-lcms2 mingw-w64-i686-libmng mingw-w64-i686-libpng mingw-w64-i686-libsquish mingw-w64-i686-libtiff mingw-w64-i686-openexr mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-diffutils" = fetch {
    name        = "mingw-w64-i686-diffutils";
    version     = "3.6";
    filename    = "mingw-w64-i686-diffutils-3.6-2-any.pkg.tar.xz";
    sha256      = "fdd544ed90b4923e63913304b0be68db2c4e377ba5bca3692dc011eceec9bad3";
    buildInputs = [ mingw-w64-i686-libsigsegv mingw-w64-i686-libwinpthread-git mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-discount" = fetch {
    name        = "mingw-w64-i686-discount";
    version     = "2.2.4";
    filename    = "mingw-w64-i686-discount-2.2.4-1-any.pkg.tar.xz";
    sha256      = "f4af3faf7631855f40ad6c134ac83d7c947d36c14a670fbc7ba8369aad5737c6";
  };

  "mingw-w64-i686-distorm" = fetch {
    name        = "mingw-w64-i686-distorm";
    version     = "3.4.1";
    filename    = "mingw-w64-i686-distorm-3.4.1-1-any.pkg.tar.xz";
    sha256      = "75a0f99795e68c906fd6f154f0aae2fb3c88c353cdb4152c3a53f968ed4b00ce";
  };

  "mingw-w64-i686-djview" = fetch {
    name        = "mingw-w64-i686-djview";
    version     = "4.10.6";
    filename    = "mingw-w64-i686-djview-4.10.6-1-any.pkg.tar.xz";
    sha256      = "7f09112afffcdb81e4db9cb4387270dbb5a20447ecd28f7d5dd6a7bcd2896538";
    buildInputs = [ mingw-w64-i686-djvulibre mingw-w64-i686-gcc-libs mingw-w64-i686-qt5 mingw-w64-i686-libtiff ];
    broken      = true; # broken dependency mingw-w64-i686-djvulibre -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-djvulibre" = fetch {
    name        = "mingw-w64-i686-djvulibre";
    version     = "3.5.27";
    filename    = "mingw-w64-i686-djvulibre-3.5.27-3-any.pkg.tar.xz";
    sha256      = "4084261c9d071317d8d61993a42c0567b353d0b6691dbf7182c581b6091d6d68";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libjpeg mingw-w64-i686-libiconv mingw-w64-i686-libtiff mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-djvulibre -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-dlfcn" = fetch {
    name        = "mingw-w64-i686-dlfcn";
    version     = "1.1.2";
    filename    = "mingw-w64-i686-dlfcn-1.1.2-1-any.pkg.tar.xz";
    sha256      = "be1c4b2dc1b4a368b8a8bfc61314489d791a71fd7b71a95a71837010492ced82";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-dlib" = fetch {
    name        = "mingw-w64-i686-dlib";
    version     = "19.16";
    filename    = "mingw-w64-i686-dlib-19.16-2-any.pkg.tar.xz";
    sha256      = "67401574702820e743f0f2acf91b53669c760986f9c6cab66ddab29492be4d23";
    buildInputs = [ mingw-w64-i686-lapack mingw-w64-i686-giflib mingw-w64-i686-libpng mingw-w64-i686-libjpeg-turbo mingw-w64-i686-openblas mingw-w64-i686-lapack mingw-w64-i686-fftw mingw-w64-i686-sqlite3 ];
  };

  "mingw-w64-i686-dmake" = fetch {
    name        = "mingw-w64-i686-dmake";
    version     = "4.12.2.2";
    filename    = "mingw-w64-i686-dmake-4.12.2.2-1-any.pkg.tar.xz";
    sha256      = "82296f7f3e1b452590f664363d3e22f69cfa5ac194fb4ad3719dd20e080d6df6";
  };

  "mingw-w64-i686-dnscrypt-proxy" = fetch {
    name        = "mingw-w64-i686-dnscrypt-proxy";
    version     = "1.6.0";
    filename    = "mingw-w64-i686-dnscrypt-proxy-1.6.0-2-any.pkg.tar.xz";
    sha256      = "69087e524315044a10ac33edda723b97dfb5aa0f4640c059c0244bd0f50ba742";
    buildInputs = [ mingw-w64-i686-libsodium mingw-w64-i686-ldns ];
  };

  "mingw-w64-i686-docbook-dsssl" = fetch {
    name        = "mingw-w64-i686-docbook-dsssl";
    version     = "1.79";
    filename    = "mingw-w64-i686-docbook-dsssl-1.79-1-any.pkg.tar.xz";
    sha256      = "5ae88a8e71dbefe7b6fd568a480b0a81b19f8121ccfdd649b3967e00a4e2ae37";
    buildInputs = [ mingw-w64-i686-sgml-common perl ];
    broken      = true; # broken dependency mingw-w64-i686-docbook-dsssl -> perl
  };

  "mingw-w64-i686-docbook-mathml" = fetch {
    name        = "mingw-w64-i686-docbook-mathml";
    version     = "1.1CR1";
    filename    = "mingw-w64-i686-docbook-mathml-1.1CR1-1-any.pkg.tar.xz";
    sha256      = "c36c875d0fc3798b1b9d144b2d08961d2f7e68683823c18bdeb73c5c2f36fad6";
    buildInputs = [ mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-docbook-sgml" = fetch {
    name        = "mingw-w64-i686-docbook-sgml";
    version     = "4.5";
    filename    = "mingw-w64-i686-docbook-sgml-4.5-1-any.pkg.tar.xz";
    sha256      = "773869f96d499a8b8d4f751fe93f0b48299cefb41dcae4b15f807b89f6e64900";
    buildInputs = [ mingw-w64-i686-sgml-common ];
  };

  "mingw-w64-i686-docbook-sgml31" = fetch {
    name        = "mingw-w64-i686-docbook-sgml31";
    version     = "3.1";
    filename    = "mingw-w64-i686-docbook-sgml31-3.1-1-any.pkg.tar.xz";
    sha256      = "9d1d61b1ede7831eed75271d32c90a06107964bf6884f2ed13f70890c267c0f4";
    buildInputs = [ mingw-w64-i686-sgml-common ];
  };

  "mingw-w64-i686-docbook-xml" = fetch {
    name        = "mingw-w64-i686-docbook-xml";
    version     = "5.0";
    filename    = "mingw-w64-i686-docbook-xml-5.0-1-any.pkg.tar.xz";
    sha256      = "1fba26476c0df49078c68f7a731099a43fae53a091b2eb572c80b3bf3d5570e9";
    buildInputs = [ mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-docbook-xsl" = fetch {
    name        = "mingw-w64-i686-docbook-xsl";
    version     = "1.79.2";
    filename    = "mingw-w64-i686-docbook-xsl-1.79.2-3-any.pkg.tar.xz";
    sha256      = "9faa2e076ffd2ada984cdc85d675112308d6fc78cf3f405965c5789eb97f0d2a";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-docbook-xml ];
  };

  "mingw-w64-i686-double-conversion" = fetch {
    name        = "mingw-w64-i686-double-conversion";
    version     = "3.1.1";
    filename    = "mingw-w64-i686-double-conversion-3.1.1-1-any.pkg.tar.xz";
    sha256      = "bf42bf6e7454395cfce177b7fdbe76bbc55b0c15edecb4ada2015ed83d90959a";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-doxygen" = fetch {
    name        = "mingw-w64-i686-doxygen";
    version     = "1.8.14";
    filename    = "mingw-w64-i686-doxygen-1.8.14-3-any.pkg.tar.xz";
    sha256      = "9842a91f27170706e9f7139bf44fa8afe2a62f20eb12c899cbd514ba2846bb65";
    buildInputs = [ mingw-w64-i686-clang mingw-w64-i686-gcc-libs mingw-w64-i686-libiconv mingw-w64-i686-sqlite3 mingw-w64-i686-xapian-core ];
  };

  "mingw-w64-i686-dragon" = fetch {
    name        = "mingw-w64-i686-dragon";
    version     = "1.5.2";
    filename    = "mingw-w64-i686-dragon-1.5.2-1-any.pkg.tar.xz";
    sha256      = "41df20c5fffc47de45acc3c66d009eed923e6a03c39d83abdcd3069d866d7555";
    buildInputs = [ mingw-w64-i686-lfcbase ];
  };

  "mingw-w64-i686-drmingw" = fetch {
    name        = "mingw-w64-i686-drmingw";
    version     = "0.8.2";
    filename    = "mingw-w64-i686-drmingw-0.8.2-1-any.pkg.tar.xz";
    sha256      = "684812be9051d8087170ade80d532e68a9d38934986c6daca39d31ac71454d40";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-dsdp" = fetch {
    name        = "mingw-w64-i686-dsdp";
    version     = "5.8";
    filename    = "mingw-w64-i686-dsdp-5.8-1-any.pkg.tar.xz";
    sha256      = "285528b2812432838dfeb48860737b73cb215d88857bf6ea95dde10ab8ba632d";
    buildInputs = [ mingw-w64-i686-openblas ];
  };

  "mingw-w64-i686-dumb" = fetch {
    name        = "mingw-w64-i686-dumb";
    version     = "2.0.3";
    filename    = "mingw-w64-i686-dumb-2.0.3-1-any.pkg.tar.xz";
    sha256      = "2b81c4dbb58c8b0e46c875c67ba82289af1169e3812810209a362c0c68004bd7";
  };

  "mingw-w64-i686-editorconfig-core-c" = fetch {
    name        = "mingw-w64-i686-editorconfig-core-c";
    version     = "0.12.3";
    filename    = "mingw-w64-i686-editorconfig-core-c-0.12.3-1-any.pkg.tar.xz";
    sha256      = "685ed42790d47c5491f1e198041e6d86eb249f0a2ebfd462403c97cde55c0e8d";
    buildInputs = [ mingw-w64-i686-pcre ];
  };

  "mingw-w64-i686-editrights" = fetch {
    name        = "mingw-w64-i686-editrights";
    version     = "1.03";
    filename    = "mingw-w64-i686-editrights-1.03-3-any.pkg.tar.xz";
    sha256      = "326c611b22b77a624229c93a67e7294256fbe225c9aaf185c7e1139c5bed10cf";
  };

  "mingw-w64-i686-eigen3" = fetch {
    name        = "mingw-w64-i686-eigen3";
    version     = "3.3.7";
    filename    = "mingw-w64-i686-eigen3-3.3.7-1-any.pkg.tar.xz";
    sha256      = "a49b48c2382909859fd00265bdbe579fb5cb56daa063b5c38a76675aa5e46a95";
    buildInputs = [  ];
  };

  "mingw-w64-i686-emacs" = fetch {
    name        = "mingw-w64-i686-emacs";
    version     = "26.1";
    filename    = "mingw-w64-i686-emacs-26.1-1-any.pkg.tar.xz";
    sha256      = "b91054998135c2536eb27af17ca02b33ac583caa122a62bda088099055beae1a";
    buildInputs = [ mingw-w64-i686-ctags mingw-w64-i686-zlib mingw-w64-i686-xpm-nox mingw-w64-i686-dbus mingw-w64-i686-gnutls mingw-w64-i686-imagemagick mingw-w64-i686-libwinpthread-git ];
    broken      = true; # broken dependency mingw-w64-i686-djvulibre -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-enca" = fetch {
    name        = "mingw-w64-i686-enca";
    version     = "1.19";
    filename    = "mingw-w64-i686-enca-1.19-1-any.pkg.tar.xz";
    sha256      = "e7002fb62441bfbf9fa9e84e62c86b0e687204c7808f105cd99f49fa4a9ebb1d";
    buildInputs = [ mingw-w64-i686-recode ];
  };

  "mingw-w64-i686-enchant" = fetch {
    name        = "mingw-w64-i686-enchant";
    version     = "2.2.3";
    filename    = "mingw-w64-i686-enchant-2.2.3-3-any.pkg.tar.xz";
    sha256      = "80141b40cf3de8be450623d54ae645301320f0073e3ce0cbd67ec52cbbf58e95";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-glib2 mingw-w64-i686-aspell mingw-w64-i686-hunspell mingw-w64-i686-libvoikko ];
  };

  "mingw-w64-i686-enet" = fetch {
    name        = "mingw-w64-i686-enet";
    version     = "1.3.13";
    filename    = "mingw-w64-i686-enet-1.3.13-2-any.pkg.tar.xz";
    sha256      = "38b53a6641947627af96d72d94ed27a0876e5fd7dc80f2a777d37af0ce866ee6";
  };

  "mingw-w64-i686-eog" = fetch {
    name        = "mingw-w64-i686-eog";
    version     = "3.16.3";
    filename    = "mingw-w64-i686-eog-3.16.3-1-any.pkg.tar.xz";
    sha256      = "43c48ba410e55377cc9fba0cd86c662f53edd2476d37e4a7569833ca79e9abbe";
    buildInputs = [ mingw-w64-i686-adwaita-icon-theme mingw-w64-i686-gettext mingw-w64-i686-gtk3 mingw-w64-i686-gdk-pixbuf2 mingw-w64-i686-gobject-introspection-runtime mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-zlib mingw-w64-i686-libexif mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libpeas mingw-w64-i686-librsvg mingw-w64-i686-libxml2 mingw-w64-i686-shared-mime-info ];
  };

  "mingw-w64-i686-eog-plugins" = fetch {
    name        = "mingw-w64-i686-eog-plugins";
    version     = "3.16.3";
    filename    = "mingw-w64-i686-eog-plugins-3.16.3-1-any.pkg.tar.xz";
    sha256      = "3ed4155d330f096c1db3373433e7ddcee817e4f1899a7bbfcacf2c98e1478ff9";
    buildInputs = [ mingw-w64-i686-eog mingw-w64-i686-libchamplain mingw-w64-i686-libexif mingw-w64-i686-libgdata mingw-w64-i686-postr mingw-w64-i686-python2 ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-evince" = fetch {
    name        = "mingw-w64-i686-evince";
    version     = "3.28.2";
    filename    = "mingw-w64-i686-evince-3.28.2-3-any.pkg.tar.xz";
    sha256      = "3dfa6ef309ca07fe558c4e297888c8e594c7bd9868a7a6ea59d4f0a26eb65a86";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-cairo mingw-w64-i686-djvulibre mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-gtk3 mingw-w64-i686-libgxps mingw-w64-i686-libspectre mingw-w64-i686-libtiff mingw-w64-i686-poppler mingw-w64-i686-gst-plugins-base mingw-w64-i686-nss ];
    broken      = true; # broken dependency mingw-w64-i686-djvulibre -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-exiv2" = fetch {
    name        = "mingw-w64-i686-exiv2";
    version     = "0.26";
    filename    = "mingw-w64-i686-exiv2-0.26-3-any.pkg.tar.xz";
    sha256      = "9046184bf66ef773c93b90f9e6768758e3c7c232da83512e5459d11566bbb028";
    buildInputs = [ mingw-w64-i686-expat mingw-w64-i686-gettext mingw-w64-i686-curl mingw-w64-i686-libssh2 mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-expat" = fetch {
    name        = "mingw-w64-i686-expat";
    version     = "2.2.6";
    filename    = "mingw-w64-i686-expat-2.2.6-1-any.pkg.tar.xz";
    sha256      = "1a04398f813c993f503f47494c4c3c2c7ab3b1ff3919076f4424d0caf385045b";
    buildInputs = [  ];
  };

  "mingw-w64-i686-extra-cmake-modules" = fetch {
    name        = "mingw-w64-i686-extra-cmake-modules";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-extra-cmake-modules-5.50.0-1-any.pkg.tar.xz";
    sha256      = "17d56dff015fac6c3e3368d2bfab74e87489c38c84c443745847920f6216645d";
    buildInputs = [ mingw-w64-i686-cmake mingw-w64-i686-png2ico ];
  };

  "mingw-w64-i686-f2c" = fetch {
    name        = "mingw-w64-i686-f2c";
    version     = "1.0";
    filename    = "mingw-w64-i686-f2c-1.0-1-any.pkg.tar.xz";
    sha256      = "8d3996f10ec782f27f53adcdaf86697bbf4b83c07ec5c4fae805e90e2a4f4c31";
  };

  "mingw-w64-i686-faac" = fetch {
    name        = "mingw-w64-i686-faac";
    version     = "1.29.9.2";
    filename    = "mingw-w64-i686-faac-1.29.9.2-1-any.pkg.tar.xz";
    sha256      = "0ed7e5807f78eac0d82426ef38e13e3925858c0aa38c0fd740c69da1e9527634";
  };

  "mingw-w64-i686-faad2" = fetch {
    name        = "mingw-w64-i686-faad2";
    version     = "2.8.8";
    filename    = "mingw-w64-i686-faad2-2.8.8-1-any.pkg.tar.xz";
    sha256      = "48a3fc7b3818351c475090b9db7f0ed35dfc0660c2ca85d741f5fcfecab10fc2";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-fann" = fetch {
    name        = "mingw-w64-i686-fann";
    version     = "2.2.0";
    filename    = "mingw-w64-i686-fann-2.2.0-2-any.pkg.tar.xz";
    sha256      = "67eadf7fab8f599db8ff27c254d6eae2355ab4103b9d27cb50338d6a928d78f3";
  };

  "mingw-w64-i686-farstream" = fetch {
    name        = "mingw-w64-i686-farstream";
    version     = "0.2.8";
    filename    = "mingw-w64-i686-farstream-0.2.8-2-any.pkg.tar.xz";
    sha256      = "dc3718ed0b144a28cd8be575ce08238f8bcb32362aca667db896248db323e33b";
    buildInputs = [ mingw-w64-i686-gst-plugins-base mingw-w64-i686-libnice ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-fastjar" = fetch {
    name        = "mingw-w64-i686-fastjar";
    version     = "0.98";
    filename    = "mingw-w64-i686-fastjar-0.98-1-any.pkg.tar.xz";
    sha256      = "42992b23107e40f6f959cd5120313641eee29af65c34cdc916544bd0f5ccae9e";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-fcrackzip" = fetch {
    name        = "mingw-w64-i686-fcrackzip";
    version     = "1.0";
    filename    = "mingw-w64-i686-fcrackzip-1.0-1-any.pkg.tar.xz";
    sha256      = "4fee468f8a10c72a11017684705fae76a70ff8765633532baf762123c72a356d";
  };

  "mingw-w64-i686-fdk-aac" = fetch {
    name        = "mingw-w64-i686-fdk-aac";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-fdk-aac-2.0.0-1-any.pkg.tar.xz";
    sha256      = "bef11f85d43a0aaaeed48a46239be0e752c5b18d773dbb49b415b1a02bfc62f7";
  };

  "mingw-w64-i686-ffcall" = fetch {
    name        = "mingw-w64-i686-ffcall";
    version     = "2.1";
    filename    = "mingw-w64-i686-ffcall-2.1-1-any.pkg.tar.xz";
    sha256      = "368d1a4f33c22c9b5b8ea1a6a811f6075cc4076b0851a6becde38333e0032fab";
  };

  "mingw-w64-i686-ffmpeg" = fetch {
    name        = "mingw-w64-i686-ffmpeg";
    version     = "4.1";
    filename    = "mingw-w64-i686-ffmpeg-4.1-1-any.pkg.tar.xz";
    sha256      = "f9ef4b4180387a789ffff9b5280846e0571a5e8b1ea6f6d7d472f4721ea6f2d3";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-celt mingw-w64-i686-fontconfig mingw-w64-i686-gnutls mingw-w64-i686-gsm mingw-w64-i686-lame mingw-w64-i686-libass mingw-w64-i686-libbluray mingw-w64-i686-libcaca mingw-w64-i686-libmodplug mingw-w64-i686-libtheora mingw-w64-i686-libvorbis mingw-w64-i686-libvpx mingw-w64-i686-libwebp mingw-w64-i686-openal mingw-w64-i686-opencore-amr mingw-w64-i686-openjpeg2 mingw-w64-i686-opus mingw-w64-i686-rtmpdump-git mingw-w64-i686-SDL2 mingw-w64-i686-speex mingw-w64-i686-wavpack mingw-w64-i686-x264-git mingw-w64-i686-x265 mingw-w64-i686-xvidcore mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-ffms2" = fetch {
    name        = "mingw-w64-i686-ffms2";
    version     = "2.23";
    filename    = "mingw-w64-i686-ffms2-2.23-1-any.pkg.tar.xz";
    sha256      = "c80534a8b8e70032f774997bff66bbfbfc2a2c3007eacae3b2c04a83c351cae6";
    buildInputs = [ mingw-w64-i686-ffmpeg ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-fftw" = fetch {
    name        = "mingw-w64-i686-fftw";
    version     = "3.3.8";
    filename    = "mingw-w64-i686-fftw-3.3.8-1-any.pkg.tar.xz";
    sha256      = "8033db3846eae2640e5ca5c3b67a11449bd613c80245dbb0f950c0230a700664";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-fgsl" = fetch {
    name        = "mingw-w64-i686-fgsl";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-fgsl-1.2.0-2-any.pkg.tar.xz";
    sha256      = "028cc1cc1c4e6575b9ce92db5880e5ce282c056926494faf249cc74595c3b059";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gcc-libgfortran (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-gsl.version "2.3"; mingw-w64-i686-gsl) ];
  };

  "mingw-w64-i686-field3d" = fetch {
    name        = "mingw-w64-i686-field3d";
    version     = "1.7.2";
    filename    = "mingw-w64-i686-field3d-1.7.2-6-any.pkg.tar.xz";
    sha256      = "3cbf7a23f9497fff028f995f7c9295fb69c4cab25a56cb68f003a6060e097869";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-hdf5 mingw-w64-i686-openexr ];
  };

  "mingw-w64-i686-file" = fetch {
    name        = "mingw-w64-i686-file";
    version     = "5.35";
    filename    = "mingw-w64-i686-file-5.35-1-any.pkg.tar.xz";
    sha256      = "9998d5f1c5870390852965bf45b1bd9225e33fc2833abbfdc35115eb373ce441";
    buildInputs = [ mingw-w64-i686-libsystre ];
  };

  "mingw-w64-i686-firebird2-git" = fetch {
    name        = "mingw-w64-i686-firebird2-git";
    version     = "2.5.9.27107.8f69580de5";
    filename    = "mingw-w64-i686-firebird2-git-2.5.9.27107.8f69580de5-1-any.pkg.tar.xz";
    sha256      = "53b974da45ec7585cd7bca3ed1631eeb81dcc7feda736afe85826b161b4c1fc5";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-icu mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-flac" = fetch {
    name        = "mingw-w64-i686-flac";
    version     = "1.3.2";
    filename    = "mingw-w64-i686-flac-1.3.2-1-any.pkg.tar.xz";
    sha256      = "617caddfeb365c20330262971b570298bdfdcf17bc129d9c60c4c089eff3cfad";
    buildInputs = [ mingw-w64-i686-libogg mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-flatbuffers" = fetch {
    name        = "mingw-w64-i686-flatbuffers";
    version     = "1.10.0";
    filename    = "mingw-w64-i686-flatbuffers-1.10.0-1-any.pkg.tar.xz";
    sha256      = "d410a5a37678911f2e945680dbbfeb62715446514b0483e281250af12a6b1b23";
    buildInputs = [ mingw-w64-i686-libsystre ];
  };

  "mingw-w64-i686-flexdll" = fetch {
    name        = "mingw-w64-i686-flexdll";
    version     = "0.34";
    filename    = "mingw-w64-i686-flexdll-0.34-2-any.pkg.tar.xz";
    sha256      = "9e91bdabf874ad728827acd408d18454aef05b77a6e88e261fa8a5e30934fdaf";
  };

  "mingw-w64-i686-flickcurl" = fetch {
    name        = "mingw-w64-i686-flickcurl";
    version     = "1.26";
    filename    = "mingw-w64-i686-flickcurl-1.26-2-any.pkg.tar.xz";
    sha256      = "9b3c40cfdb75f7940a92301236194d640046721834cbfa8e16febd76f32628cb";
    buildInputs = [ mingw-w64-i686-curl mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-flif" = fetch {
    name        = "mingw-w64-i686-flif";
    version     = "0.3";
    filename    = "mingw-w64-i686-flif-0.3-1-any.pkg.tar.xz";
    sha256      = "739981420fcb3d61ed4c7574967d3d1dc77398add07b4d1820847eeceb6c7567";
    buildInputs = [ mingw-w64-i686-zlib mingw-w64-i686-libpng mingw-w64-i686-SDL2 ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-fltk" = fetch {
    name        = "mingw-w64-i686-fltk";
    version     = "1.3.4.2";
    filename    = "mingw-w64-i686-fltk-1.3.4.2-1-any.pkg.tar.xz";
    sha256      = "a9bdeb4224618343ac66fe8061182c78efb29d7b7e32b30aa5fe56cf1d47b0b9";
    buildInputs = [ mingw-w64-i686-expat mingw-w64-i686-gcc-libs mingw-w64-i686-gettext mingw-w64-i686-libiconv mingw-w64-i686-libpng mingw-w64-i686-libjpeg-turbo mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-fluidsynth" = fetch {
    name        = "mingw-w64-i686-fluidsynth";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-fluidsynth-2.0.0-1-any.pkg.tar.xz";
    sha256      = "2cac9c374c182831ffa1171ddbd0a0c15ac3ba0f6ef672690399a2c87f40d60f";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-glib2 mingw-w64-i686-libsndfile mingw-w64-i686-portaudio ];
  };

  "mingw-w64-i686-fmt" = fetch {
    name        = "mingw-w64-i686-fmt";
    version     = "5.3.0";
    filename    = "mingw-w64-i686-fmt-5.3.0-1-any.pkg.tar.xz";
    sha256      = "6df60d910c2b630e4ff2e1fde373f9fbea4517c6fb14b265fbf1cc9f914b5f66";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-fontconfig" = fetch {
    name        = "mingw-w64-i686-fontconfig";
    version     = "2.13.1";
    filename    = "mingw-w64-i686-fontconfig-2.13.1-1-any.pkg.tar.xz";
    sha256      = "9aacd2d38a7a739e0168f4688f4fb5ab4ebdaab0b80a2d098349f073f602bcb2";
    buildInputs = [ mingw-w64-i686-gcc-libs (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-expat.version "2.1.0"; mingw-w64-i686-expat) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-freetype.version "2.3.11"; mingw-w64-i686-freetype) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-bzip2.version "1.0.6"; mingw-w64-i686-bzip2) mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-fossil" = fetch {
    name        = "mingw-w64-i686-fossil";
    version     = "2.6";
    filename    = "mingw-w64-i686-fossil-2.6-2-any.pkg.tar.xz";
    sha256      = "789d2391e2775537faef91814ff12ad59432331409bc936feb131853dd2312fc";
    buildInputs = [ mingw-w64-i686-openssl mingw-w64-i686-readline mingw-w64-i686-sqlite3 mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-fox" = fetch {
    name        = "mingw-w64-i686-fox";
    version     = "1.6.57";
    filename    = "mingw-w64-i686-fox-1.6.57-1-any.pkg.tar.xz";
    sha256      = "f7a5f444a726b4b23387065c92e97b0481a60f6721cada5af88267c8736dbe5d";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libtiff mingw-w64-i686-zlib mingw-w64-i686-libpng mingw-w64-i686-libjpeg-turbo ];
  };

  "mingw-w64-i686-freealut" = fetch {
    name        = "mingw-w64-i686-freealut";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-freealut-1.1.0-1-any.pkg.tar.xz";
    sha256      = "7c9d4e1d40ece6c505b391833b70bcdf1647469a8799366efe677299b333ce89";
    buildInputs = [ mingw-w64-i686-openal ];
  };

  "mingw-w64-i686-freeglut" = fetch {
    name        = "mingw-w64-i686-freeglut";
    version     = "3.0.0";
    filename    = "mingw-w64-i686-freeglut-3.0.0-4-any.pkg.tar.xz";
    sha256      = "8ef4b641cd7b093fe6caf93ad11a1522bf05c05518ef525682730982af96ac42";
    buildInputs = [  ];
  };

  "mingw-w64-i686-freeimage" = fetch {
    name        = "mingw-w64-i686-freeimage";
    version     = "3.18.0";
    filename    = "mingw-w64-i686-freeimage-3.18.0-2-any.pkg.tar.xz";
    sha256      = "12bc6707cb4f1a6a1a9b239775f01c069e7a137f336f6c02bae03c9b010255ab";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-jxrlib mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-libraw mingw-w64-i686-libwebp mingw-w64-i686-openjpeg2 mingw-w64-i686-openexr ];
  };

  "mingw-w64-i686-freetds" = fetch {
    name        = "mingw-w64-i686-freetds";
    version     = "1.00.98";
    filename    = "mingw-w64-i686-freetds-1.00.98-1-any.pkg.tar.xz";
    sha256      = "8bbb5b13d8eb78b2f6c752eef8f1507535af803dff45098dd28acadcafb45521";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-openssl mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-freetype" = fetch {
    name        = "mingw-w64-i686-freetype";
    version     = "2.9.1";
    filename    = "mingw-w64-i686-freetype-2.9.1-1-any.pkg.tar.xz";
    sha256      = "e8df4eb86c7914b0edefe18949bffbf94bc4d1d2715b9d475b2a61f5905c4647";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-bzip2 mingw-w64-i686-harfbuzz mingw-w64-i686-libpng mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-fribidi" = fetch {
    name        = "mingw-w64-i686-fribidi";
    version     = "1.0.5";
    filename    = "mingw-w64-i686-fribidi-1.0.5-1-any.pkg.tar.xz";
    sha256      = "cd9cf00efb92f8bebac8a3290696ab96701abc3106cd83e9ac64ead7d1020280";
    buildInputs = [  ];
  };

  "mingw-w64-i686-ftgl" = fetch {
    name        = "mingw-w64-i686-ftgl";
    version     = "2.1.3rc5";
    filename    = "mingw-w64-i686-ftgl-2.1.3rc5-2-any.pkg.tar.xz";
    sha256      = "556b4a7bccc1bc9a997b9ed46412d299030008267660a77822bc10c15da6d5ed";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-freetype ];
  };

  "mingw-w64-i686-gavl" = fetch {
    name        = "mingw-w64-i686-gavl";
    version     = "1.4.0";
    filename    = "mingw-w64-i686-gavl-1.4.0-1-any.pkg.tar.xz";
    sha256      = "7e0890c13a63ff0a4da7757705506e177bf7d467a188864f2d832335b937f423";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libpng ];
  };

  "mingw-w64-i686-gc" = fetch {
    name        = "mingw-w64-i686-gc";
    version     = "7.6.8";
    filename    = "mingw-w64-i686-gc-7.6.8-1-any.pkg.tar.xz";
    sha256      = "369ed5ff5eeedbbac892d95b38646b5fad48d18b5ff5053f1cc7aaa7fb13addd";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libatomic_ops ];
  };

  "mingw-w64-i686-gcc" = fetch {
    name        = "mingw-w64-i686-gcc";
    version     = "7.4.0";
    filename    = "mingw-w64-i686-gcc-7.4.0-1-any.pkg.tar.xz";
    sha256      = "8ff5c08f0b56a4aa595e98da212af402817b51a7800ae5f8f0b9de37842d8098";
    buildInputs = [ mingw-w64-i686-binutils mingw-w64-i686-crt-git mingw-w64-i686-headers-git mingw-w64-i686-isl mingw-w64-i686-libiconv mingw-w64-i686-mpc (assert mingw-w64-i686-gcc-libs.version=="7.4.0"; mingw-w64-i686-gcc-libs) mingw-w64-i686-windows-default-manifest mingw-w64-i686-winpthreads-git mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-gcc-ada" = fetch {
    name        = "mingw-w64-i686-gcc-ada";
    version     = "7.4.0";
    filename    = "mingw-w64-i686-gcc-ada-7.4.0-1-any.pkg.tar.xz";
    sha256      = "6c54a1b541363b868a55a753e7c85ebbcb68411bdb7ea2750195fb658b6a009d";
    buildInputs = [ (assert mingw-w64-i686-gcc.version=="7.4.0"; mingw-w64-i686-gcc) ];
  };

  "mingw-w64-i686-gcc-fortran" = fetch {
    name        = "mingw-w64-i686-gcc-fortran";
    version     = "7.4.0";
    filename    = "mingw-w64-i686-gcc-fortran-7.4.0-1-any.pkg.tar.xz";
    sha256      = "5d3965dfecd02612bb65329e4afd170ea1e1a590b3fffed01aa835d7e1b2e904";
    buildInputs = [ (assert mingw-w64-i686-gcc.version=="7.4.0"; mingw-w64-i686-gcc) (assert mingw-w64-i686-gcc-libgfortran.version=="7.4.0"; mingw-w64-i686-gcc-libgfortran) ];
  };

  "mingw-w64-i686-gcc-libgfortran" = fetch {
    name        = "mingw-w64-i686-gcc-libgfortran";
    version     = "7.4.0";
    filename    = "mingw-w64-i686-gcc-libgfortran-7.4.0-1-any.pkg.tar.xz";
    sha256      = "72686c314c4aec7ee20b01c4acf8578e95190b3598913c7a982aa0b8ad1def51";
    buildInputs = [ (assert mingw-w64-i686-gcc-libs.version=="7.4.0"; mingw-w64-i686-gcc-libs) ];
  };

  "mingw-w64-i686-gcc-libs" = fetch {
    name        = "mingw-w64-i686-gcc-libs";
    version     = "7.4.0";
    filename    = "mingw-w64-i686-gcc-libs-7.4.0-1-any.pkg.tar.xz";
    sha256      = "10f83a7bf788879ee8dabfb1827c2bc44b85dfbbad61ea2764286e2550db3d8c";
    buildInputs = [ mingw-w64-i686-gmp mingw-w64-i686-mpc mingw-w64-i686-mpfr mingw-w64-i686-libwinpthread-git ];
  };

  "mingw-w64-i686-gcc-objc" = fetch {
    name        = "mingw-w64-i686-gcc-objc";
    version     = "7.4.0";
    filename    = "mingw-w64-i686-gcc-objc-7.4.0-1-any.pkg.tar.xz";
    sha256      = "e1729c50f2458b738da085c93e6e70f4645f125504d3f4a968e76cfa7a2db51a";
    buildInputs = [ (assert mingw-w64-i686-gcc.version=="7.4.0"; mingw-w64-i686-gcc) ];
  };

  "mingw-w64-i686-gd" = fetch {
    name        = "mingw-w64-i686-gd";
    version     = "2.2.5";
    filename    = "mingw-w64-i686-gd-2.2.5-3-any.pkg.tar.xz";
    sha256      = "5d4eb70a061d557eeae109b7ecd35e71248a261dc3a7cd4ca14bd55566e75989";
    buildInputs = [ mingw-w64-i686-fontconfig mingw-w64-i686-libiconv mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-libvpx mingw-w64-i686-xpm-nox ];
    broken      = true; # broken dependency mingw-w64-i686-gd -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-gdal" = fetch {
    name        = "mingw-w64-i686-gdal";
    version     = "2.4.0";
    filename    = "mingw-w64-i686-gdal-2.4.0-2-any.pkg.tar.xz";
    sha256      = "10c47296191c17463300968124170a5a945536c971577ee500038479b3aa52b6";
    buildInputs = [ mingw-w64-i686-cfitsio self."mingw-w64-i686-crypto++" mingw-w64-i686-curl mingw-w64-i686-expat mingw-w64-i686-geos mingw-w64-i686-giflib mingw-w64-i686-hdf5 mingw-w64-i686-jasper mingw-w64-i686-json-c mingw-w64-i686-libfreexl mingw-w64-i686-libgeotiff mingw-w64-i686-libiconv mingw-w64-i686-libjpeg mingw-w64-i686-libkml mingw-w64-i686-libpng mingw-w64-i686-libspatialite mingw-w64-i686-libtiff mingw-w64-i686-libwebp mingw-w64-i686-libxml2 mingw-w64-i686-netcdf mingw-w64-i686-openjpeg2 mingw-w64-i686-pcre mingw-w64-i686-poppler mingw-w64-i686-postgresql mingw-w64-i686-proj mingw-w64-i686-qhull-git mingw-w64-i686-sqlite3 mingw-w64-i686-xerces-c mingw-w64-i686-xz ];
    broken      = true; # broken dependency mingw-w64-i686-libgeotiff -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-gdb" = fetch {
    name        = "mingw-w64-i686-gdb";
    version     = "8.2.1";
    filename    = "mingw-w64-i686-gdb-8.2.1-1-any.pkg.tar.xz";
    sha256      = "3ec805947f318e398deffa08c14360016206691d6b0869d8d050c1ef285005d8";
    buildInputs = [ mingw-w64-i686-expat mingw-w64-i686-libiconv mingw-w64-i686-python3 mingw-w64-i686-readline mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-gdbm" = fetch {
    name        = "mingw-w64-i686-gdbm";
    version     = "1.18.1";
    filename    = "mingw-w64-i686-gdbm-1.18.1-1-any.pkg.tar.xz";
    sha256      = "ac0001152b3eb2b50d9980609bbc6a916b40ee06a4c6535c53a5a7395006cec2";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-gdcm" = fetch {
    name        = "mingw-w64-i686-gdcm";
    version     = "2.8.8";
    filename    = "mingw-w64-i686-gdcm-2.8.8-3-any.pkg.tar.xz";
    sha256      = "28aa29fbbb1ebbf41a611960522dea5ded069c04d9ec0c531733efcb48d70c83";
    buildInputs = [ mingw-w64-i686-expat mingw-w64-i686-gcc-libs mingw-w64-i686-lcms2 mingw-w64-i686-libxml2 mingw-w64-i686-json-c mingw-w64-i686-openssl mingw-w64-i686-poppler mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-poppler -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-gdk-pixbuf2" = fetch {
    name        = "mingw-w64-i686-gdk-pixbuf2";
    version     = "2.38.0";
    filename    = "mingw-w64-i686-gdk-pixbuf2-2.38.0-2-any.pkg.tar.xz";
    sha256      = "03ec32809c30f20690b10c74f7f443103ce7d8b0e612fa79a663b30c17c1a38a";
    buildInputs = [ mingw-w64-i686-gcc-libs (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-glib2.version "2.37.2"; mingw-w64-i686-glib2) mingw-w64-i686-jasper mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libpng mingw-w64-i686-libtiff ];
  };

  "mingw-w64-i686-gdl" = fetch {
    name        = "mingw-w64-i686-gdl";
    version     = "3.28.0";
    filename    = "mingw-w64-i686-gdl-3.28.0-1-any.pkg.tar.xz";
    sha256      = "58a46c9a88633c5252178e677e33a229373cdb0b5f8ba6af4ef5e4fcf2b884a3";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-gdl2" = fetch {
    name        = "mingw-w64-i686-gdl2";
    version     = "2.31.2";
    filename    = "mingw-w64-i686-gdl2-2.31.2-2-any.pkg.tar.xz";
    sha256      = "eed4c980a0b5f311c3c207835b47feafbcf136c81a50baf3dc08e665b9eb7098";
    buildInputs = [ mingw-w64-i686-gtk2 mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-gdlmm2" = fetch {
    name        = "mingw-w64-i686-gdlmm2";
    version     = "2.30.0";
    filename    = "mingw-w64-i686-gdlmm2-2.30.0-2-any.pkg.tar.xz";
    sha256      = "83a9e715ad71f611265e05db0eb514c7825d589ce2a9564deddb1cdb226df678";
    buildInputs = [ mingw-w64-i686-gtk2 mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-geany" = fetch {
    name        = "mingw-w64-i686-geany";
    version     = "1.34.0";
    filename    = "mingw-w64-i686-geany-1.34.0-1-any.pkg.tar.xz";
    sha256      = "e8d80bddc46fd0aaf055259058c6eaf7a4680a34da5ec3c5f747a0c08ec2bee7";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-adwaita-icon-theme ];
  };

  "mingw-w64-i686-geany-plugins" = fetch {
    name        = "mingw-w64-i686-geany-plugins";
    version     = "1.34.0";
    filename    = "mingw-w64-i686-geany-plugins-1.34.0-1-any.pkg.tar.xz";
    sha256      = "7a8989ea9613baa1bbe55f274231be9d2db9ae07f83c847279c663f67045a0ef";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-geany.version "1.34.0"; mingw-w64-i686-geany) mingw-w64-i686-discount mingw-w64-i686-gtkspell3 mingw-w64-i686-webkitgtk3 mingw-w64-i686-ctpl-git mingw-w64-i686-gpgme mingw-w64-i686-lua51 mingw-w64-i686-gtk3 mingw-w64-i686-hicolor-icon-theme mingw-w64-i686-python2 ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-gedit" = fetch {
    name        = "mingw-w64-i686-gedit";
    version     = "3.30.2";
    filename    = "mingw-w64-i686-gedit-3.30.2-1-any.pkg.tar.xz";
    sha256      = "672e49effda1fdedfe4b73a01f1c864ba6f7310419e3714ab216a7ecd01f6033";
    buildInputs = [ mingw-w64-i686-adwaita-icon-theme mingw-w64-i686-enchant mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-gtksourceview3 mingw-w64-i686-iso-codes mingw-w64-i686-libpeas mingw-w64-i686-python3-gobject mingw-w64-i686-gspell ];
  };

  "mingw-w64-i686-gedit-plugins" = fetch {
    name        = "mingw-w64-i686-gedit-plugins";
    version     = "3.30.1";
    filename    = "mingw-w64-i686-gedit-plugins-3.30.1-1-any.pkg.tar.xz";
    sha256      = "99d049f2db99b005d5676b05eb405442d8568db5127ff6a185eb93d8fd58e1a8";
    buildInputs = [ mingw-w64-i686-gedit mingw-w64-i686-libgit2-glib ];
  };

  "mingw-w64-i686-gegl" = fetch {
    name        = "mingw-w64-i686-gegl";
    version     = "0.4.12";
    filename    = "mingw-w64-i686-gegl-0.4.12-1-any.pkg.tar.xz";
    sha256      = "44f99cd35e7e97d2a66a140970a32121019aa4d96e66f775209211c6d898656c";
    buildInputs = [ mingw-w64-i686-babl mingw-w64-i686-cairo mingw-w64-i686-exiv2 mingw-w64-i686-gcc-libs mingw-w64-i686-gdk-pixbuf2 mingw-w64-i686-gettext mingw-w64-i686-glib2 mingw-w64-i686-gtk2 mingw-w64-i686-jasper mingw-w64-i686-json-glib mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-LibRaw mingw-w64-i686-librsvg mingw-w64-i686-libspiro mingw-w64-i686-libwebp mingw-w64-i686-lcms mingw-w64-i686-lensfun mingw-w64-i686-openexr mingw-w64-i686-pango mingw-w64-i686-SDL mingw-w64-i686-suitesparse ];
    broken      = true; # broken dependency mingw-w64-i686-gegl -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-geoclue" = fetch {
    name        = "mingw-w64-i686-geoclue";
    version     = "0.12.99";
    filename    = "mingw-w64-i686-geoclue-0.12.99-3-any.pkg.tar.xz";
    sha256      = "82c9ef565bf568b3449c2447176442544b51dc0b1869732c49de105979817584";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gtk2 mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-dbus-glib ];
  };

  "mingw-w64-i686-geocode-glib" = fetch {
    name        = "mingw-w64-i686-geocode-glib";
    version     = "3.26.0";
    filename    = "mingw-w64-i686-geocode-glib-3.26.0-1-any.pkg.tar.xz";
    sha256      = "7b3f264601604408781308f42af73c16b956925097b64fed62e6671cd135e0d5";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-json-glib mingw-w64-i686-libsoup ];
  };

  "mingw-w64-i686-geoip" = fetch {
    name        = "mingw-w64-i686-geoip";
    version     = "1.6.12";
    filename    = "mingw-w64-i686-geoip-1.6.12-1-any.pkg.tar.xz";
    sha256      = "28ecc2751578272468cd2c5fa99946e99f3d7f2cd51e8269b1dcbd3862f17a25";
    buildInputs = [ mingw-w64-i686-geoip2-database mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-geoip2-database" = fetch {
    name        = "mingw-w64-i686-geoip2-database";
    version     = "20180522";
    filename    = "mingw-w64-i686-geoip2-database-20180522-1-any.pkg.tar.xz";
    sha256      = "f548b392f105ad6d8298118e46c270a49e24d2722fa09969046e9d0376fa5f8b";
    buildInputs = [  ];
  };

  "mingw-w64-i686-geos" = fetch {
    name        = "mingw-w64-i686-geos";
    version     = "3.7.1";
    filename    = "mingw-w64-i686-geos-3.7.1-1-any.pkg.tar.xz";
    sha256      = "a3b484fc8bafebe0ead33793d6e2904311d8024d635ddc0170ac55fd89104ea2";
    buildInputs = [  ];
  };

  "mingw-w64-i686-gettext" = fetch {
    name        = "mingw-w64-i686-gettext";
    version     = "0.19.8.1";
    filename    = "mingw-w64-i686-gettext-0.19.8.1-7-any.pkg.tar.xz";
    sha256      = "2d8358b9e24bddbdf67f37bc35538185869ec63274dc1dba6f634b6e7cd559fe";
    buildInputs = [ mingw-w64-i686-expat mingw-w64-i686-gcc-libs mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-gexiv2" = fetch {
    name        = "mingw-w64-i686-gexiv2";
    version     = "0.10.9";
    filename    = "mingw-w64-i686-gexiv2-0.10.9-1-any.pkg.tar.xz";
    sha256      = "717405656d07ad887f0516024a21e166ffaec2cdbf0f4cae1739c41eeac42902";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-exiv2 mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-gflags" = fetch {
    name        = "mingw-w64-i686-gflags";
    version     = "2.2.2";
    filename    = "mingw-w64-i686-gflags-2.2.2-1-any.pkg.tar.xz";
    sha256      = "b7b46700f725c2b598e48e216d49c3db7e5cf13bb9b4ac763e382e338013971a";
    buildInputs = [  ];
  };

  "mingw-w64-i686-ghex" = fetch {
    name        = "mingw-w64-i686-ghex";
    version     = "3.18.3";
    filename    = "mingw-w64-i686-ghex-3.18.3-1-any.pkg.tar.xz";
    sha256      = "a3b606b3a9ceccffe39ef869e46477a2bc1d7f759428223f716d129f57289fd8";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-adwaita-icon-theme ];
  };

  "mingw-w64-i686-ghostscript" = fetch {
    name        = "mingw-w64-i686-ghostscript";
    version     = "9.26";
    filename    = "mingw-w64-i686-ghostscript-9.26-1-any.pkg.tar.xz";
    sha256      = "3179dab5d1fa9e7e87f4b755b6e6b9ea234ce708ed4e18edde6b34ca2d1dac55";
    buildInputs = [ mingw-w64-i686-dbus mingw-w64-i686-freetype mingw-w64-i686-fontconfig mingw-w64-i686-gdk-pixbuf2 mingw-w64-i686-libiconv mingw-w64-i686-libidn mingw-w64-i686-libpaper mingw-w64-i686-libpng mingw-w64-i686-libjpeg mingw-w64-i686-libtiff mingw-w64-i686-lcms2 mingw-w64-i686-openjpeg2 mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-ghostscript -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-giflib" = fetch {
    name        = "mingw-w64-i686-giflib";
    version     = "5.1.4";
    filename    = "mingw-w64-i686-giflib-5.1.4-2-any.pkg.tar.xz";
    sha256      = "140942fd1c0a373c8d9f7402c43281d974899d73df40244f40597fb59bcbaafa";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-gimp" = fetch {
    name        = "mingw-w64-i686-gimp";
    version     = "2.10.8";
    filename    = "mingw-w64-i686-gimp-2.10.8-3-any.pkg.tar.xz";
    sha256      = "05b40460b251dc97a6c45f683e55af43351ff76528141649f39aec54816cb505";
    buildInputs = [ mingw-w64-i686-babl mingw-w64-i686-curl mingw-w64-i686-dbus-glib mingw-w64-i686-drmingw mingw-w64-i686-gegl mingw-w64-i686-gexiv2 mingw-w64-i686-ghostscript mingw-w64-i686-hicolor-icon-theme mingw-w64-i686-jasper mingw-w64-i686-lcms2 mingw-w64-i686-libexif mingw-w64-i686-libmng mingw-w64-i686-libmypaint mingw-w64-i686-librsvg mingw-w64-i686-libwmf mingw-w64-i686-mypaint-brushes mingw-w64-i686-openexr mingw-w64-i686-poppler mingw-w64-i686-python2-pygtk mingw-w64-i686-python2-gobject mingw-w64-i686-xpm-nox ];
    broken      = true; # broken dependency mingw-w64-i686-gegl -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-gimp-ufraw" = fetch {
    name        = "mingw-w64-i686-gimp-ufraw";
    version     = "0.22";
    filename    = "mingw-w64-i686-gimp-ufraw-0.22-1-any.pkg.tar.xz";
    sha256      = "a3568c20ef986469795bc0d4420166fabe3ed89d72d177ad6472102e988e15e3";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-cfitsio mingw-w64-i686-exiv2 mingw-w64-i686-gtkimageview mingw-w64-i686-lcms mingw-w64-i686-lensfun ];
  };

  "mingw-w64-i686-git-lfs" = fetch {
    name        = "mingw-w64-i686-git-lfs";
    version     = "2.2.1";
    filename    = "mingw-w64-i686-git-lfs-2.2.1-1-any.pkg.tar.xz";
    sha256      = "c0b9e96c72d5b18e2ec8a201f4065203c66274c03a7eb064e9ee218ef67179eb";
    buildInputs = [ git ];
    broken      = true; # broken dependency mingw-w64-i686-git-lfs -> git
  };

  "mingw-w64-i686-git-repo" = fetch {
    name        = "mingw-w64-i686-git-repo";
    version     = "0.4.20";
    filename    = "mingw-w64-i686-git-repo-0.4.20-1-any.pkg.tar.xz";
    sha256      = "16f53560007670c53539d12a16e88c5922fe0e8471cd5e1e6cc448e92a19ba25";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-gitg" = fetch {
    name        = "mingw-w64-i686-gitg";
    version     = "3.30.1";
    filename    = "mingw-w64-i686-gitg-3.30.1-2-any.pkg.tar.xz";
    sha256      = "ac8692689bc0721ac03c389f60861fc4af9bbed5260f57589c258c2e5cfc6544";
    buildInputs = [ mingw-w64-i686-adwaita-icon-theme mingw-w64-i686-gtksourceview3 mingw-w64-i686-libpeas mingw-w64-i686-enchant mingw-w64-i686-iso-codes mingw-w64-i686-python3-gobject mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-libsoup mingw-w64-i686-libsecret mingw-w64-i686-gtkspell3 mingw-w64-i686-libgit2-glib mingw-w64-i686-libgee ];
  };

  "mingw-w64-i686-gl2ps" = fetch {
    name        = "mingw-w64-i686-gl2ps";
    version     = "1.4.0";
    filename    = "mingw-w64-i686-gl2ps-1.4.0-1-any.pkg.tar.xz";
    sha256      = "22c0aaf39b8c3c3c766b681e3ac3fd31579f7edf88e2cafbc081f9bbbf502030";
    buildInputs = [ mingw-w64-i686-libpng ];
  };

  "mingw-w64-i686-glade" = fetch {
    name        = "mingw-w64-i686-glade";
    version     = "3.22.1";
    filename    = "mingw-w64-i686-glade-3.22.1-1-any.pkg.tar.xz";
    sha256      = "516f1d982e8cdeb8ab927b8d8c25faa740e42e436506d25b7f5bd1a79074be2f";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-libxml2 mingw-w64-i686-adwaita-icon-theme ];
  };

  "mingw-w64-i686-glade3" = fetch {
    name        = "mingw-w64-i686-glade3";
    version     = "3.8.6";
    filename    = "mingw-w64-i686-glade3-3.8.6-1-any.pkg.tar.xz";
    sha256      = "181314499235716f7571f892672d89a193b08021f44b53919665f1cdc1dce1be";
    buildInputs = [ mingw-w64-i686-gtk2 mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-glbinding" = fetch {
    name        = "mingw-w64-i686-glbinding";
    version     = "3.0.2";
    filename    = "mingw-w64-i686-glbinding-3.0.2-2-any.pkg.tar.xz";
    sha256      = "9c4f99ce6f778dd96c0a4f34fd705e1104760e8bfa98ac73bb8f66ec529a86f0";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-glew" = fetch {
    name        = "mingw-w64-i686-glew";
    version     = "2.1.0";
    filename    = "mingw-w64-i686-glew-2.1.0-1-any.pkg.tar.xz";
    sha256      = "3ec0aa501c921845440503c7ae57787b02a45746effc11ced5c34d3aabfc8039";
    buildInputs = [  ];
  };

  "mingw-w64-i686-glfw" = fetch {
    name        = "mingw-w64-i686-glfw";
    version     = "3.2.1";
    filename    = "mingw-w64-i686-glfw-3.2.1-2-any.pkg.tar.xz";
    sha256      = "55c8262810e87de8b608725d8b0092277600583312610294f8c73a64f7e3d08b";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-glib-networking" = fetch {
    name        = "mingw-w64-i686-glib-networking";
    version     = "2.58.0";
    filename    = "mingw-w64-i686-glib-networking-2.58.0-2-any.pkg.tar.xz";
    sha256      = "3ed3a6676aead6f73df955273d6ef75e86fbad7cf0841dbad946d9edbe620e25";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext mingw-w64-i686-glib2 mingw-w64-i686-gnutls ];
  };

  "mingw-w64-i686-glib-openssl" = fetch {
    name        = "mingw-w64-i686-glib-openssl";
    version     = "2.50.8";
    filename    = "mingw-w64-i686-glib-openssl-2.50.8-2-any.pkg.tar.xz";
    sha256      = "c49b91790c9268202ddc65bb25dd9f9d9d028aabaf2cfff14adb1bf4cb211789";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-glib2" = fetch {
    name        = "mingw-w64-i686-glib2";
    version     = "2.58.2";
    filename    = "mingw-w64-i686-glib2-2.58.2-1-any.pkg.tar.xz";
    sha256      = "a433c78f095d948da0afd67398d1653280ae245398ef976f8b826932f2768ebc";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext mingw-w64-i686-pcre mingw-w64-i686-libffi mingw-w64-i686-zlib mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-glibmm" = fetch {
    name        = "mingw-w64-i686-glibmm";
    version     = "2.58.0";
    filename    = "mingw-w64-i686-glibmm-2.58.0-1-any.pkg.tar.xz";
    sha256      = "04b9bcc46a3e469a1fb2866bfec4d57a22d67daaba0e1a0eb943c21e3cd4ca68";
    buildInputs = [ self."mingw-w64-i686-libsigc++" mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-glm" = fetch {
    name        = "mingw-w64-i686-glm";
    version     = "0.9.9.3";
    filename    = "mingw-w64-i686-glm-0.9.9.3-2-any.pkg.tar.xz";
    sha256      = "0586a85cc0fc8b2349cb47d768ad306a5802fcd627a7f1eb524b8191333a1eed";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-global" = fetch {
    name        = "mingw-w64-i686-global";
    version     = "6.6.2";
    filename    = "mingw-w64-i686-global-6.6.2-2-any.pkg.tar.xz";
    sha256      = "9cc95bd10560af7fef24fee2eb7273583f9fcfd73c9341802fd9251d087b57c5";
  };

  "mingw-w64-i686-globjects" = fetch {
    name        = "mingw-w64-i686-globjects";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-globjects-1.1.0-1-any.pkg.tar.xz";
    sha256      = "41a71b45b0ca7427356fa142461b088790f207dfbd39899974a796efefefc525";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-glbinding mingw-w64-i686-glm ];
  };

  "mingw-w64-i686-glog" = fetch {
    name        = "mingw-w64-i686-glog";
    version     = "0.3.5";
    filename    = "mingw-w64-i686-glog-0.3.5-1-any.pkg.tar.xz";
    sha256      = "82eaaa38f95acc12f35fa080876c9b0993a1bd197db4efbdbb260ade7bd9c330";
    buildInputs = [ mingw-w64-i686-gflags ];
  };

  "mingw-w64-i686-glpk" = fetch {
    name        = "mingw-w64-i686-glpk";
    version     = "4.65";
    filename    = "mingw-w64-i686-glpk-4.65-1-any.pkg.tar.xz";
    sha256      = "65d8294d9d8ca04a8372866171995867dd6a470b5bb1fdd0e04e3ac2cb2d7cfa";
    buildInputs = [ mingw-w64-i686-gmp ];
  };

  "mingw-w64-i686-glsl-optimizer-git" = fetch {
    name        = "mingw-w64-i686-glsl-optimizer-git";
    version     = "r66914.9a2852138d";
    filename    = "mingw-w64-i686-glsl-optimizer-git-r66914.9a2852138d-1-any.pkg.tar.xz";
    sha256      = "bab09eca3f1bf427158ec8d3961982fa36520676efbfb8a6fb38c699ae9aa12c";
  };

  "mingw-w64-i686-glslang" = fetch {
    name        = "mingw-w64-i686-glslang";
    version     = "7.10.2984";
    filename    = "mingw-w64-i686-glslang-7.10.2984-1-any.pkg.tar.xz";
    sha256      = "2e7a275634659223c1423b6dfbcd7aa12a4d8099362248ab19437c13dc92db98";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-gmime" = fetch {
    name        = "mingw-w64-i686-gmime";
    version     = "3.2.2";
    filename    = "mingw-w64-i686-gmime-3.2.2-1-any.pkg.tar.xz";
    sha256      = "09f0e4aef9f5a1239ba8a6986e2799ef652f240f5dfdb07817099f7feb9d20fb";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-gmp" = fetch {
    name        = "mingw-w64-i686-gmp";
    version     = "6.1.2";
    filename    = "mingw-w64-i686-gmp-6.1.2-1-any.pkg.tar.xz";
    sha256      = "e9500a94beffd8517621821787c35ee207cc638f9f17ba07ffa7f7d1a3fba777";
    buildInputs = [  ];
  };

  "mingw-w64-i686-gnome-calculator" = fetch {
    name        = "mingw-w64-i686-gnome-calculator";
    version     = "3.16.2";
    filename    = "mingw-w64-i686-gnome-calculator-3.16.2-1-any.pkg.tar.xz";
    sha256      = "f97bbb54ff104b17ed6127fb777b845bbb753a7db931e2d0912950d914959bbf";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gtk3 mingw-w64-i686-gtksourceview3 mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-libxml2 mingw-w64-i686-mpfr ];
  };

  "mingw-w64-i686-gnome-common" = fetch {
    name        = "mingw-w64-i686-gnome-common";
    version     = "3.18.0";
    filename    = "mingw-w64-i686-gnome-common-3.18.0-1-any.pkg.tar.xz";
    sha256      = "e782a790331591237a2364daf903ab4a92d374c24c456156b5ccd1ba7930b1c2";
  };

  "mingw-w64-i686-gnome-latex" = fetch {
    name        = "mingw-w64-i686-gnome-latex";
    version     = "3.28.1";
    filename    = "mingw-w64-i686-gnome-latex-3.28.1-2-any.pkg.tar.xz";
    sha256      = "c810422790572d2d0c8517539a770c0a30b69d3f442d62c7927b8937298fb9a1";
    buildInputs = [ mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-gtk3 mingw-w64-i686-gtksourceview4 mingw-w64-i686-gspell mingw-w64-i686-tepl4 mingw-w64-i686-libgee ];
  };

  "mingw-w64-i686-gnu-cobol-svn" = fetch {
    name        = "mingw-w64-i686-gnu-cobol-svn";
    version     = "2.0.r1454";
    filename    = "mingw-w64-i686-gnu-cobol-svn-2.0.r1454-1-any.pkg.tar.xz";
    sha256      = "e22c01d48a9e4b87eddb649eeddb361c77b08185356d3b962223f80e25ac65c0";
    buildInputs = [ mingw-w64-i686-db mingw-w64-i686-gmp mingw-w64-i686-ncurses ];
  };

  "mingw-w64-i686-gnucobol" = fetch {
    name        = "mingw-w64-i686-gnucobol";
    version     = "3.0rc1";
    filename    = "mingw-w64-i686-gnucobol-3.0rc1-0-any.pkg.tar.xz";
    sha256      = "983eb56675ad9420766e883df8f542706e906454333e93018c63901280fdf48c";
    buildInputs = [ mingw-w64-i686-gcc mingw-w64-i686-gmp mingw-w64-i686-gettext mingw-w64-i686-ncurses mingw-w64-i686-db ];
  };

  "mingw-w64-i686-gnupg" = fetch {
    name        = "mingw-w64-i686-gnupg";
    version     = "2.2.12";
    filename    = "mingw-w64-i686-gnupg-2.2.12-1-any.pkg.tar.xz";
    sha256      = "24f57845061643845170c596e7114c34485352ea0311558c9465932bbb3d3fce";
    buildInputs = [ mingw-w64-i686-adns mingw-w64-i686-bzip2 mingw-w64-i686-curl mingw-w64-i686-gnutls mingw-w64-i686-libksba mingw-w64-i686-libgcrypt mingw-w64-i686-libassuan mingw-w64-i686-libsystre mingw-w64-i686-libusb-compat-git mingw-w64-i686-npth mingw-w64-i686-readline mingw-w64-i686-sqlite3 mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-gnuplot" = fetch {
    name        = "mingw-w64-i686-gnuplot";
    version     = "5.2.5";
    filename    = "mingw-w64-i686-gnuplot-5.2.5-1-any.pkg.tar.xz";
    sha256      = "00bfe67fb7baaaf3e15f46b9d63b63a49f7fe9505022cbad30d1a01f2b37ba20";
    buildInputs = [ mingw-w64-i686-cairo mingw-w64-i686-gnutls mingw-w64-i686-libcaca mingw-w64-i686-libcerf mingw-w64-i686-libgd mingw-w64-i686-pango mingw-w64-i686-readline mingw-w64-i686-wxWidgets ];
    broken      = true; # broken dependency mingw-w64-i686-libgd -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-gnutls" = fetch {
    name        = "mingw-w64-i686-gnutls";
    version     = "3.6.5";
    filename    = "mingw-w64-i686-gnutls-3.6.5-2-any.pkg.tar.xz";
    sha256      = "83b604b74e5b75f8e4c36828265b8a3cfea643a4f52d29c4cfa9810d456155d5";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gmp mingw-w64-i686-libidn2 mingw-w64-i686-libsystre mingw-w64-i686-libtasn1 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-nettle.version "3.1"; mingw-w64-i686-nettle) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-p11-kit.version "0.23.1"; mingw-w64-i686-p11-kit) mingw-w64-i686-libunistring mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-go" = fetch {
    name        = "mingw-w64-i686-go";
    version     = "1.11.4";
    filename    = "mingw-w64-i686-go-1.11.4-1-any.pkg.tar.xz";
    sha256      = "1a4685f455f8fe11261a4b54c7bf54d12951c95039fc43feee67ce0aea65e2e7";
  };

  "mingw-w64-i686-gobject-introspection" = fetch {
    name        = "mingw-w64-i686-gobject-introspection";
    version     = "1.58.2";
    filename    = "mingw-w64-i686-gobject-introspection-1.58.2-1-any.pkg.tar.xz";
    sha256      = "8f924f2759a7a69c83e9d237a0f9d3421271c839a995d0c9d22e266bf7217b09";
    buildInputs = [ (assert mingw-w64-i686-gobject-introspection-runtime.version=="1.58.2"; mingw-w64-i686-gobject-introspection-runtime) mingw-w64-i686-pkg-config mingw-w64-i686-python3 mingw-w64-i686-python3-mako ];
  };

  "mingw-w64-i686-gobject-introspection-runtime" = fetch {
    name        = "mingw-w64-i686-gobject-introspection-runtime";
    version     = "1.58.2";
    filename    = "mingw-w64-i686-gobject-introspection-runtime-1.58.2-1-any.pkg.tar.xz";
    sha256      = "ca0fe6d2ec54617a70816dac68ebe5c832a81df9e7a6c5db3c5d9e967e607069";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-goocanvas" = fetch {
    name        = "mingw-w64-i686-goocanvas";
    version     = "2.0.4";
    filename    = "mingw-w64-i686-goocanvas-2.0.4-1-any.pkg.tar.xz";
    sha256      = "3cdb2e3b8fedd7f5c8bd98d31a6655854b279027df2389d87c54c40b8ca36abe";
    buildInputs = [ mingw-w64-i686-gtk3 ];
  };

  "mingw-w64-i686-googletest-git" = fetch {
    name        = "mingw-w64-i686-googletest-git";
    version     = "r975.aa148eb";
    filename    = "mingw-w64-i686-googletest-git-r975.aa148eb-1-any.pkg.tar.xz";
    sha256      = "1f72550ccb01138352ce5b170a985329888c3422fb0084ab90ab5fb2e8d254cd";
  };

  "mingw-w64-i686-gperf" = fetch {
    name        = "mingw-w64-i686-gperf";
    version     = "3.1";
    filename    = "mingw-w64-i686-gperf-3.1-1-any.pkg.tar.xz";
    sha256      = "24d7ad4995528201c35c6ec68a431f6963bc45d79149ad8f92d33cc2653b7971";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-gpgme" = fetch {
    name        = "mingw-w64-i686-gpgme";
    version     = "1.12.0";
    filename    = "mingw-w64-i686-gpgme-1.12.0-1-any.pkg.tar.xz";
    sha256      = "2ee44525734ba4eca8661002eb0cda33a9043b7079702f9d2eba8ed4ab53e4f7";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gnupg mingw-w64-i686-libassuan mingw-w64-i686-libgpg-error mingw-w64-i686-npth ];
  };

  "mingw-w64-i686-gphoto2" = fetch {
    name        = "mingw-w64-i686-gphoto2";
    version     = "2.5.20";
    filename    = "mingw-w64-i686-gphoto2-2.5.20-1-any.pkg.tar.xz";
    sha256      = "ccdb71cd12ed57770b0c816a380fde9fc906b8d6a4b21a4cadfb8d7cc77be070";
    buildInputs = [ mingw-w64-i686-libgphoto2 mingw-w64-i686-popt ];
    broken      = true; # broken dependency mingw-w64-i686-libgphoto2 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-gplugin" = fetch {
    name        = "mingw-w64-i686-gplugin";
    version     = "0.27.0";
    filename    = "mingw-w64-i686-gplugin-0.27.0-1-any.pkg.tar.xz";
    sha256      = "89cfaf23db1de7c8eb8bbbcc46d310fa8258ad1f9bf0c471969fa20bd4a53cfe";
    buildInputs = [ mingw-w64-i686-gtk3 ];
  };

  "mingw-w64-i686-gprbuild-bootstrap-git" = fetch {
    name        = "mingw-w64-i686-gprbuild-bootstrap-git";
    version     = "r3206.f95f0c68";
    filename    = "mingw-w64-i686-gprbuild-bootstrap-git-r3206.f95f0c68-1-any.pkg.tar.xz";
    sha256      = "2b519837bc38defca74e9e28b802ddacac13dea107eff79c550a220432794568";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-graphene" = fetch {
    name        = "mingw-w64-i686-graphene";
    version     = "1.8.2";
    filename    = "mingw-w64-i686-graphene-1.8.2-1-any.pkg.tar.xz";
    sha256      = "0730542fb3f936b1cb9b4465371a14f85df1ec517c08fdccf40e7850f8f8c272";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-graphicsmagick" = fetch {
    name        = "mingw-w64-i686-graphicsmagick";
    version     = "1.3.31";
    filename    = "mingw-w64-i686-graphicsmagick-1.3.31-1-any.pkg.tar.xz";
    sha256      = "1b3171e97559e4e15f7792ad8695afe23e6b5b9cddcb8aa2bb480677f1e0d3cc";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-gcc-libs mingw-w64-i686-glib2 mingw-w64-i686-jbigkit mingw-w64-i686-lcms2 mingw-w64-i686-libtool mingw-w64-i686-libwinpthread-git mingw-w64-i686-xz mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-graphite2" = fetch {
    name        = "mingw-w64-i686-graphite2";
    version     = "1.3.13";
    filename    = "mingw-w64-i686-graphite2-1.3.13-1-any.pkg.tar.xz";
    sha256      = "e8e9576feeda7f02b5ba8a89ef0e6fee98b84ba93c4d744a6c70379985dcccb7";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-graphviz" = fetch {
    name        = "mingw-w64-i686-graphviz";
    version     = "2.40.1";
    filename    = "mingw-w64-i686-graphviz-2.40.1-5-any.pkg.tar.xz";
    sha256      = "0437f4eebb16c4b15518d9312802043bed8d3658fb599e5626f775ffe25b0bd0";
    buildInputs = [ mingw-w64-i686-cairo mingw-w64-i686-devil mingw-w64-i686-expat mingw-w64-i686-freetype mingw-w64-i686-glib2 mingw-w64-i686-gtk2 mingw-w64-i686-gtkglext mingw-w64-i686-fontconfig mingw-w64-i686-freeglut mingw-w64-i686-libglade mingw-w64-i686-libgd mingw-w64-i686-libpng mingw-w64-i686-libsystre mingw-w64-i686-libwebp mingw-w64-i686-pango mingw-w64-i686-poppler mingw-w64-i686-zlib mingw-w64-i686-libtool ];
    broken      = true; # broken dependency mingw-w64-i686-libgd -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-grpc" = fetch {
    name        = "mingw-w64-i686-grpc";
    version     = "1.17.2";
    filename    = "mingw-w64-i686-grpc-1.17.2-1-any.pkg.tar.xz";
    sha256      = "b57f2dd1e922c84b9eae6806f0aac3a116f79d8b6b265b7258887a43ba18e87d";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-c-ares mingw-w64-i686-gflags mingw-w64-i686-openssl (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-protobuf.version "3.5.0"; mingw-w64-i686-protobuf) mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-gsasl" = fetch {
    name        = "mingw-w64-i686-gsasl";
    version     = "1.8.0";
    filename    = "mingw-w64-i686-gsasl-1.8.0-4-any.pkg.tar.xz";
    sha256      = "cdebb9efc65c51b088b0f021f2e91d6fe12f164ac2552aecfa0b54f06f6c646d";
    buildInputs = [ mingw-w64-i686-gss mingw-w64-i686-gnutls mingw-w64-i686-libidn mingw-w64-i686-libgcrypt mingw-w64-i686-libntlm mingw-w64-i686-readline ];
  };

  "mingw-w64-i686-gsettings-desktop-schemas" = fetch {
    name        = "mingw-w64-i686-gsettings-desktop-schemas";
    version     = "3.28.1";
    filename    = "mingw-w64-i686-gsettings-desktop-schemas-3.28.1-1-any.pkg.tar.xz";
    sha256      = "6647a1efca204f93e2319b612a4d298288c6d2c502d2602b121c3c851273e377";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-gsfonts" = fetch {
    name        = "mingw-w64-i686-gsfonts";
    version     = "20180524";
    filename    = "mingw-w64-i686-gsfonts-20180524-1-any.pkg.tar.xz";
    sha256      = "6605f5854ad8e51797cc22a96b43c5d3928971af98724d3ccdbfefa65b67ae7a";
  };

  "mingw-w64-i686-gsl" = fetch {
    name        = "mingw-w64-i686-gsl";
    version     = "2.5";
    filename    = "mingw-w64-i686-gsl-2.5-1-any.pkg.tar.xz";
    sha256      = "3366823c59ac2a959a0a08584d6fa6c17212e55c5f804381d75dc70a9969b255";
    buildInputs = [  ];
  };

  "mingw-w64-i686-gsm" = fetch {
    name        = "mingw-w64-i686-gsm";
    version     = "1.0.18";
    filename    = "mingw-w64-i686-gsm-1.0.18-1-any.pkg.tar.xz";
    sha256      = "d3663919021d774eb5bb17d30f01d31aaef487c226ce29d9220d4b461104da6f";
    buildInputs = [  ];
  };

  "mingw-w64-i686-gsoap" = fetch {
    name        = "mingw-w64-i686-gsoap";
    version     = "2.8.74";
    filename    = "mingw-w64-i686-gsoap-2.8.74-1-any.pkg.tar.xz";
    sha256      = "e31eb51489546a6d1d04ad8bcec8a62a388fe56da94ffcdccc9c3f9dd429375c";
  };

  "mingw-w64-i686-gspell" = fetch {
    name        = "mingw-w64-i686-gspell";
    version     = "1.8.1";
    filename    = "mingw-w64-i686-gspell-1.8.1-1-any.pkg.tar.xz";
    sha256      = "b7c1060cb502c8505724b3ca0811530bf44f991bd930a2f859b05c6bbce0294e";
    buildInputs = [ mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-gtk3 mingw-w64-i686-gtksourceview3 mingw-w64-i686-iso-codes mingw-w64-i686-enchant mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-gss" = fetch {
    name        = "mingw-w64-i686-gss";
    version     = "1.0.3";
    filename    = "mingw-w64-i686-gss-1.0.3-1-any.pkg.tar.xz";
    sha256      = "abaef426e612be0388cc31ba8164a9a2998dcf44534cf3d158992f658bb1a7c8";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-shishi-git ];
  };

  "mingw-w64-i686-gst-editing-services" = fetch {
    name        = "mingw-w64-i686-gst-editing-services";
    version     = "1.14.4";
    filename    = "mingw-w64-i686-gst-editing-services-1.14.4-1-any.pkg.tar.xz";
    sha256      = "c4101249586adc6d2ffac67c9fa8f58ee391b651de632939a83f2c142025dae3";
    buildInputs = [ mingw-w64-i686-gst-plugins-base ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-gst-libav" = fetch {
    name        = "mingw-w64-i686-gst-libav";
    version     = "1.14.4";
    filename    = "mingw-w64-i686-gst-libav-1.14.4-1-any.pkg.tar.xz";
    sha256      = "8d2b3494da4431c16a41998d89af95e3f3de05772b0bed8797658a1c29a8267d";
    buildInputs = [ mingw-w64-i686-gst-plugins-base ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-gst-plugins-bad" = fetch {
    name        = "mingw-w64-i686-gst-plugins-bad";
    version     = "1.14.4";
    filename    = "mingw-w64-i686-gst-plugins-bad-1.14.4-3-any.pkg.tar.xz";
    sha256      = "48c6e57beea30c4c32bdcb31c61ed5c96151ea0310816f27a24e3d9dc414413f";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-cairo mingw-w64-i686-chromaprint mingw-w64-i686-curl mingw-w64-i686-daala-git mingw-w64-i686-faad2 mingw-w64-i686-faac mingw-w64-i686-fdk-aac mingw-w64-i686-fluidsynth mingw-w64-i686-gsm mingw-w64-i686-gst-plugins-base mingw-w64-i686-gtk3 mingw-w64-i686-ladspa-sdk mingw-w64-i686-lcms2 mingw-w64-i686-libass mingw-w64-i686-libbs2b mingw-w64-i686-libdca mingw-w64-i686-libdvdnav mingw-w64-i686-libdvdread mingw-w64-i686-libexif mingw-w64-i686-libgme mingw-w64-i686-libjpeg mingw-w64-i686-libmodplug mingw-w64-i686-libmpeg2-git mingw-w64-i686-libnice mingw-w64-i686-librsvg mingw-w64-i686-libsndfile mingw-w64-i686-libsrtp mingw-w64-i686-libssh2 mingw-w64-i686-libwebp mingw-w64-i686-libxml2 mingw-w64-i686-nettle mingw-w64-i686-openal mingw-w64-i686-opencv mingw-w64-i686-openexr mingw-w64-i686-openh264 mingw-w64-i686-openjpeg2 mingw-w64-i686-openssl mingw-w64-i686-opus mingw-w64-i686-orc mingw-w64-i686-pango mingw-w64-i686-rtmpdump-git mingw-w64-i686-soundtouch mingw-w64-i686-srt mingw-w64-i686-vo-amrwbenc mingw-w64-i686-x265 mingw-w64-i686-zbar ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-gst-plugins-base" = fetch {
    name        = "mingw-w64-i686-gst-plugins-base";
    version     = "1.14.4";
    filename    = "mingw-w64-i686-gst-plugins-base-1.14.4-1-any.pkg.tar.xz";
    sha256      = "35101f8be32e74f207f49c045e122356eec06bc8c06e2f50386e88d8ed8875d3";
    buildInputs = [ mingw-w64-i686-graphene mingw-w64-i686-gstreamer mingw-w64-i686-libogg mingw-w64-i686-libtheora mingw-w64-i686-libvorbis mingw-w64-i686-libvorbisidec mingw-w64-i686-opus mingw-w64-i686-orc mingw-w64-i686-pango mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-gst-plugins-good" = fetch {
    name        = "mingw-w64-i686-gst-plugins-good";
    version     = "1.14.4";
    filename    = "mingw-w64-i686-gst-plugins-good-1.14.4-1-any.pkg.tar.xz";
    sha256      = "18ff8a4d1cbd51e27ff695fb112fe09f1f589a85f66e39c9d791b52fe19eabc0";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-cairo mingw-w64-i686-flac mingw-w64-i686-gdk-pixbuf2 mingw-w64-i686-gst-plugins-base mingw-w64-i686-gtk3 mingw-w64-i686-lame mingw-w64-i686-libcaca mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libshout mingw-w64-i686-libsoup mingw-w64-i686-libvpx mingw-w64-i686-mpg123 mingw-w64-i686-speex mingw-w64-i686-taglib mingw-w64-i686-twolame mingw-w64-i686-wavpack mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-gst-plugins-ugly" = fetch {
    name        = "mingw-w64-i686-gst-plugins-ugly";
    version     = "1.14.4";
    filename    = "mingw-w64-i686-gst-plugins-ugly-1.14.4-1-any.pkg.tar.xz";
    sha256      = "a41b5d2138e1d57240eb76767e4aab12bb7d706ee9653166ab7f174aed22c75e";
    buildInputs = [ mingw-w64-i686-a52dec mingw-w64-i686-gst-plugins-base mingw-w64-i686-libcdio mingw-w64-i686-libdvdread mingw-w64-i686-libmpeg2-git mingw-w64-i686-opencore-amr mingw-w64-i686-x264-git ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-gst-python" = fetch {
    name        = "mingw-w64-i686-gst-python";
    version     = "1.14.4";
    filename    = "mingw-w64-i686-gst-python-1.14.4-1-any.pkg.tar.xz";
    sha256      = "4d391dcf863fb40f7b2e9323fb0fd0eaf90e1e7c7edac679bbed9aaa4ffa0e85";
    buildInputs = [ mingw-w64-i686-gstreamer mingw-w64-i686-python3-gobject ];
  };

  "mingw-w64-i686-gst-python2" = fetch {
    name        = "mingw-w64-i686-gst-python2";
    version     = "1.14.4";
    filename    = "mingw-w64-i686-gst-python2-1.14.4-1-any.pkg.tar.xz";
    sha256      = "9994664219f81f6bed33d4f4f947e490d8c00339a093be81ec3c0fe7bf3e9270";
    buildInputs = [ mingw-w64-i686-gstreamer mingw-w64-i686-python2-gobject ];
  };

  "mingw-w64-i686-gst-rtsp-server" = fetch {
    name        = "mingw-w64-i686-gst-rtsp-server";
    version     = "1.14.4";
    filename    = "mingw-w64-i686-gst-rtsp-server-1.14.4-1-any.pkg.tar.xz";
    sha256      = "b0e463bb94f7bcaf90f603b6d82b8b7ddcc6e9673bb623f433852f2e90823ecf";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-glib2 mingw-w64-i686-gettext mingw-w64-i686-gstreamer mingw-w64-i686-gst-plugins-base mingw-w64-i686-gst-plugins-good mingw-w64-i686-gst-plugins-ugly mingw-w64-i686-gst-plugins-bad ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-gstreamer" = fetch {
    name        = "mingw-w64-i686-gstreamer";
    version     = "1.14.4";
    filename    = "mingw-w64-i686-gstreamer-1.14.4-1-any.pkg.tar.xz";
    sha256      = "8cb5661be292b41e1aeb9f832753d729a1956dbce1dce3555f291ab8b59d766e";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libxml2 mingw-w64-i686-glib2 mingw-w64-i686-gettext mingw-w64-i686-gmp mingw-w64-i686-gsl ];
  };

  "mingw-w64-i686-gtef" = fetch {
    name        = "mingw-w64-i686-gtef";
    version     = "2.0.1";
    filename    = "mingw-w64-i686-gtef-2.0.1-1-any.pkg.tar.xz";
    sha256      = "f47ce6cbcbf83f2c93aa46655e538c0ec4d2ecf420a2c57cbe4cfe2b777c1c8f";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gtk3 mingw-w64-i686-gtksourceview3 mingw-w64-i686-uchardet mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-gtest" = fetch {
    name        = "mingw-w64-i686-gtest";
    version     = "1.8.1";
    filename    = "mingw-w64-i686-gtest-1.8.1-2-any.pkg.tar.xz";
    sha256      = "e910d1ae883b72c23c61bcb493b30a9a66359a9778988fdcbac7d24783b35bde";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-gtk-doc" = fetch {
    name        = "mingw-w64-i686-gtk-doc";
    version     = "1.29";
    filename    = "mingw-w64-i686-gtk-doc-1.29-1-any.pkg.tar.xz";
    sha256      = "76565d9ff8514acdc12c8c53bbd62a49897b4d86a2e649738d58933bff5a1b9b";
    buildInputs = [ mingw-w64-i686-docbook-xsl mingw-w64-i686-docbook-xml mingw-w64-i686-libxslt mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-gtk-engine-murrine" = fetch {
    name        = "mingw-w64-i686-gtk-engine-murrine";
    version     = "0.98.2";
    filename    = "mingw-w64-i686-gtk-engine-murrine-0.98.2-2-any.pkg.tar.xz";
    sha256      = "8991d38e45163856112712efe9a1fb45692958365380406749a91aa632424683";
    buildInputs = [ mingw-w64-i686-gtk2 ];
  };

  "mingw-w64-i686-gtk-engines" = fetch {
    name        = "mingw-w64-i686-gtk-engines";
    version     = "2.21.0";
    filename    = "mingw-w64-i686-gtk-engines-2.21.0-2-any.pkg.tar.xz";
    sha256      = "c85a75b2caf33a4b4a519764aff439eb6940bc41738cc844ce3dc14073cb5a93";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-gtk2.version "2.22.0"; mingw-w64-i686-gtk2) ];
  };

  "mingw-w64-i686-gtk-vnc" = fetch {
    name        = "mingw-w64-i686-gtk-vnc";
    version     = "0.9.0";
    filename    = "mingw-w64-i686-gtk-vnc-0.9.0-1-any.pkg.tar.xz";
    sha256      = "301de6ff66e21fe070dedf2aaa57f6b5fe9dd93b432064df30c91fc25b6d8891";
    buildInputs = [ mingw-w64-i686-cyrus-sasl mingw-w64-i686-gnutls mingw-w64-i686-gtk3 mingw-w64-i686-libgcrypt mingw-w64-i686-libgpg-error mingw-w64-i686-libview mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-gtk2" = fetch {
    name        = "mingw-w64-i686-gtk2";
    version     = "2.24.32";
    filename    = "mingw-w64-i686-gtk2-2.24.32-3-any.pkg.tar.xz";
    sha256      = "bc8c8a8286bebbf65fef61c771f53b7c08e77b5491d9b672db9872f6b04aa5cf";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-adwaita-icon-theme (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-atk.version "1.29.2"; mingw-w64-i686-atk) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-cairo.version "1.6"; mingw-w64-i686-cairo) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-gdk-pixbuf2.version "2.21.0"; mingw-w64-i686-gdk-pixbuf2) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-glib2.version "2.28.0"; mingw-w64-i686-glib2) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-pango.version "1.20"; mingw-w64-i686-pango) mingw-w64-i686-shared-mime-info ];
  };

  "mingw-w64-i686-gtk3" = fetch {
    name        = "mingw-w64-i686-gtk3";
    version     = "3.24.2";
    filename    = "mingw-w64-i686-gtk3-3.24.2-1-any.pkg.tar.xz";
    sha256      = "3aa142ec2ab5dab8e9a1b586551a857a935237c941303ba7bdd39cd7afa2f407";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-adwaita-icon-theme mingw-w64-i686-atk mingw-w64-i686-cairo mingw-w64-i686-gdk-pixbuf2 mingw-w64-i686-glib2 mingw-w64-i686-json-glib mingw-w64-i686-libepoxy mingw-w64-i686-pango mingw-w64-i686-shared-mime-info ];
  };

  "mingw-w64-i686-gtkglext" = fetch {
    name        = "mingw-w64-i686-gtkglext";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-gtkglext-1.2.0-3-any.pkg.tar.xz";
    sha256      = "00683a439a025da4ceb27c91f7232aca39573d680726fb406b0c3c46ba2204d6";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gtk2 mingw-w64-i686-gdk-pixbuf2 ];
  };

  "mingw-w64-i686-gtkimageview" = fetch {
    name        = "mingw-w64-i686-gtkimageview";
    version     = "1.6.4";
    filename    = "mingw-w64-i686-gtkimageview-1.6.4-3-any.pkg.tar.xz";
    sha256      = "024a3351c87d4d3869d7f8bf09cd7d5249ebc587b91bb2a1f7e0f99c9f317597";
    buildInputs = [ mingw-w64-i686-gtk2 ];
  };

  "mingw-w64-i686-gtkmm" = fetch {
    name        = "mingw-w64-i686-gtkmm";
    version     = "2.24.5";
    filename    = "mingw-w64-i686-gtkmm-2.24.5-2-any.pkg.tar.xz";
    sha256      = "25e1dc076835c7dd6220ab0cacd8b10ea52e2f75fc28d89063d9696624b3ad47";
    buildInputs = [ mingw-w64-i686-atkmm mingw-w64-i686-pangomm mingw-w64-i686-gtk2 ];
  };

  "mingw-w64-i686-gtkmm3" = fetch {
    name        = "mingw-w64-i686-gtkmm3";
    version     = "3.24.0";
    filename    = "mingw-w64-i686-gtkmm3-3.24.0-1-any.pkg.tar.xz";
    sha256      = "a101ec8711745f1e08f0588b531a822406eef07c0c92ac57f050a9ed96a8eef3";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-atkmm mingw-w64-i686-pangomm mingw-w64-i686-gtk3 ];
  };

  "mingw-w64-i686-gtksourceview2" = fetch {
    name        = "mingw-w64-i686-gtksourceview2";
    version     = "2.10.5";
    filename    = "mingw-w64-i686-gtksourceview2-2.10.5-3-any.pkg.tar.xz";
    sha256      = "c92a789e32c2f4eb7b6a75b268f3f026d21a321e961994693e49f311f74fbe0c";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-gtk2.version "2.22.0"; mingw-w64-i686-gtk2) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-libxml2.version "2.7.7"; mingw-w64-i686-libxml2) ];
  };

  "mingw-w64-i686-gtksourceview3" = fetch {
    name        = "mingw-w64-i686-gtksourceview3";
    version     = "3.24.9";
    filename    = "mingw-w64-i686-gtksourceview3-3.24.9-1-any.pkg.tar.xz";
    sha256      = "db0afe8540b286ec533fc0fc528e57be08601076069ad2910cc631aff4059990";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-gtksourceview4" = fetch {
    name        = "mingw-w64-i686-gtksourceview4";
    version     = "4.0.3";
    filename    = "mingw-w64-i686-gtksourceview4-4.0.3-1-any.pkg.tar.xz";
    sha256      = "fbe7d4914d656bc13244f92d3b020cd1d9d041f64db54e43b611c70a98f04743";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-gtksourceviewmm2" = fetch {
    name        = "mingw-w64-i686-gtksourceviewmm2";
    version     = "2.10.3";
    filename    = "mingw-w64-i686-gtksourceviewmm2-2.10.3-2-any.pkg.tar.xz";
    sha256      = "36c224e5d09e771689aaeeb80aa236d877849fa74b8b8e6c51aee6be88cb6c7d";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-gtk2.version "2.22.0"; mingw-w64-i686-gtk2) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-libxml2.version "2.7.7"; mingw-w64-i686-libxml2) ];
  };

  "mingw-w64-i686-gtksourceviewmm3" = fetch {
    name        = "mingw-w64-i686-gtksourceviewmm3";
    version     = "3.21.3";
    filename    = "mingw-w64-i686-gtksourceviewmm3-3.21.3-2-any.pkg.tar.xz";
    sha256      = "3379233b9a0026d86b36f4c5bfc1bcd4353e34291897f943381283d10152a8ba";
    buildInputs = [ mingw-w64-i686-gtksourceview3 mingw-w64-i686-gtkmm3 ];
  };

  "mingw-w64-i686-gtkspell" = fetch {
    name        = "mingw-w64-i686-gtkspell";
    version     = "2.0.16";
    filename    = "mingw-w64-i686-gtkspell-2.0.16-7-any.pkg.tar.xz";
    sha256      = "52778f82a4a6a5eb1b912c17f915cbb0ab620ce6667585202d65566901a4f80a";
    buildInputs = [ mingw-w64-i686-gtk2 mingw-w64-i686-enchant ];
  };

  "mingw-w64-i686-gtkspell3" = fetch {
    name        = "mingw-w64-i686-gtkspell3";
    version     = "3.0.10";
    filename    = "mingw-w64-i686-gtkspell3-3.0.10-1-any.pkg.tar.xz";
    sha256      = "729085b2984ff00cbc1d3079ec3856cf9bd731dc6c4c0d8a54a03eb7f93df68f";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-gtk2 mingw-w64-i686-enchant ];
  };

  "mingw-w64-i686-gtkwave" = fetch {
    name        = "mingw-w64-i686-gtkwave";
    version     = "3.3.79";
    filename    = "mingw-w64-i686-gtkwave-3.3.79-1-any.pkg.tar.xz";
    sha256      = "ce0c1c574364b0fc0960847fb77bba0825ebd89833b9138fcf0764fecac32eda";
    buildInputs = [ mingw-w64-i686-gtk2 mingw-w64-i686-tk mingw-w64-i686-tklib mingw-w64-i686-tcl mingw-w64-i686-tcllib mingw-w64-i686-adwaita-icon-theme ];
  };

  "mingw-w64-i686-gts" = fetch {
    name        = "mingw-w64-i686-gts";
    version     = "0.7.6";
    filename    = "mingw-w64-i686-gts-0.7.6-1-any.pkg.tar.xz";
    sha256      = "f039fd0a555b6b0fc3dd2dd6d1213c0fd943a531cf1c3c562f1beb9840a0531d";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-gumbo-parser" = fetch {
    name        = "mingw-w64-i686-gumbo-parser";
    version     = "0.10.1";
    filename    = "mingw-w64-i686-gumbo-parser-0.10.1-1-any.pkg.tar.xz";
    sha256      = "c79f466543b66009e9378ebb7c9362e32f78c0e0463c9cb1858ffb7220d51d95";
  };

  "mingw-w64-i686-gxml" = fetch {
    name        = "mingw-w64-i686-gxml";
    version     = "0.16.3";
    filename    = "mingw-w64-i686-gxml-0.16.3-1-any.pkg.tar.xz";
    sha256      = "16ced0205f0802a48be9e83e312057a0ee343c415b49d8493506900d48a5d330";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-glib2.version "2.34.0"; mingw-w64-i686-glib2) mingw-w64-i686-libgee mingw-w64-i686-libxml2 mingw-w64-i686-xz mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-harfbuzz" = fetch {
    name        = "mingw-w64-i686-harfbuzz";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-harfbuzz-2.3.0-1-any.pkg.tar.xz";
    sha256      = "c18830b82bbbfccd6dc22649fa9e5bf901c9cc6976ee26eb2758f73e7d3e8aff";
    buildInputs = [ mingw-w64-i686-freetype mingw-w64-i686-gcc-libs mingw-w64-i686-glib2 mingw-w64-i686-graphite2 ];
  };

  "mingw-w64-i686-hclient-git" = fetch {
    name        = "mingw-w64-i686-hclient-git";
    version     = "233.8b17cf3";
    filename    = "mingw-w64-i686-hclient-git-233.8b17cf3-1-any.pkg.tar.xz";
    sha256      = "1d2f63b7fb505786ea97006a13fc251016582d9932c2f87930a9fc7f916715f9";
  };

  "mingw-w64-i686-hdf4" = fetch {
    name        = "mingw-w64-i686-hdf4";
    version     = "4.2.14";
    filename    = "mingw-w64-i686-hdf4-4.2.14-1-any.pkg.tar.xz";
    sha256      = "f0c109636c3ff9ac4c6e9112100d170d20503d1129fb29089c2defe51d0aaef3";
    buildInputs = [ mingw-w64-i686-libjpeg-turbo mingw-w64-i686-gcc-libgfortran mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-hdf5" = fetch {
    name        = "mingw-w64-i686-hdf5";
    version     = "1.8.21";
    filename    = "mingw-w64-i686-hdf5-1.8.21-1-any.pkg.tar.xz";
    sha256      = "ead377716f1911e4c5f20092bd05ce6e35f7273865f33032c107a16085c706f3";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gcc-libgfortran mingw-w64-i686-szip mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-headers-git" = fetch {
    name        = "mingw-w64-i686-headers-git";
    version     = "7.0.0.5285.7b2baaf8";
    filename    = "mingw-w64-i686-headers-git-7.0.0.5285.7b2baaf8-1-any.pkg.tar.xz";
    sha256      = "5d5c5dc81292dc4310278957cb45618b697c58ad071d44279c76f0dfc388ae13";
    buildInputs = [  ];
  };

  "mingw-w64-i686-hicolor-icon-theme" = fetch {
    name        = "mingw-w64-i686-hicolor-icon-theme";
    version     = "0.17";
    filename    = "mingw-w64-i686-hicolor-icon-theme-0.17-1-any.pkg.tar.xz";
    sha256      = "bcf0068c88eb771339f01238319657cbafb179805db382f588e2e6e7e8601ef3";
    buildInputs = [  ];
  };

  "mingw-w64-i686-hidapi" = fetch {
    name        = "mingw-w64-i686-hidapi";
    version     = "0.8.0rc1";
    filename    = "mingw-w64-i686-hidapi-0.8.0rc1-4-any.pkg.tar.xz";
    sha256      = "7d502caa8c3e2fee2efd713089fec323c8cbaaf3cf3617eb1e80d8b40536610e";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-hlsl2glsl-git" = fetch {
    name        = "mingw-w64-i686-hlsl2glsl-git";
    version     = "r848.957cd20";
    filename    = "mingw-w64-i686-hlsl2glsl-git-r848.957cd20-1-any.pkg.tar.xz";
    sha256      = "2b254cb4f84e6271a35dd9b10570519910b7862197f02dc2b97a87d17c7518cc";
  };

  "mingw-w64-i686-http-parser" = fetch {
    name        = "mingw-w64-i686-http-parser";
    version     = "2.8.1";
    filename    = "mingw-w64-i686-http-parser-2.8.1-1-any.pkg.tar.xz";
    sha256      = "c483ada87d2322447c6b8fb96abfb7b9cada0defd7203e111937cf426e1c25e6";
    buildInputs = [  ];
  };

  "mingw-w64-i686-hunspell" = fetch {
    name        = "mingw-w64-i686-hunspell";
    version     = "1.7.0";
    filename    = "mingw-w64-i686-hunspell-1.7.0-1-any.pkg.tar.xz";
    sha256      = "a3ac7270c6ddb324d75113e36bbb42b20c08cfd83e28335aa9b942bbe773f8d4";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext mingw-w64-i686-ncurses mingw-w64-i686-readline ];
  };

  "mingw-w64-i686-hunspell-en" = fetch {
    name        = "mingw-w64-i686-hunspell-en";
    version     = "2018.04.16";
    filename    = "mingw-w64-i686-hunspell-en-2018.04.16-1-any.pkg.tar.xz";
    sha256      = "f89613e42e4feb779a975e75a7f3e9e4dcece583405d4d7723c3a2d14674c7e9";
  };

  "mingw-w64-i686-hyphen" = fetch {
    name        = "mingw-w64-i686-hyphen";
    version     = "2.8.8";
    filename    = "mingw-w64-i686-hyphen-2.8.8-1-any.pkg.tar.xz";
    sha256      = "2ecebe0cda7b9f9a79d22dbaae7d3d1c725498a71f456ac4a164f20950d04b38";
  };

  "mingw-w64-i686-hyphen-en" = fetch {
    name        = "mingw-w64-i686-hyphen-en";
    version     = "2.8.8";
    filename    = "mingw-w64-i686-hyphen-en-2.8.8-1-any.pkg.tar.xz";
    sha256      = "8e772b67ed127f1d357df1855f4c1aaadc07d6bf88f4f3228f85f687eaa2e2bd";
  };

  "mingw-w64-i686-icon-naming-utils" = fetch {
    name        = "mingw-w64-i686-icon-naming-utils";
    version     = "0.8.90";
    filename    = "mingw-w64-i686-icon-naming-utils-0.8.90-2-any.pkg.tar.xz";
    sha256      = "aa6f8457b12201bcc647cb1f676dac2aa8c6d4a75d23263d912afaf74d8c23ac";
    buildInputs = [ perl-XML-Simple ];
    broken      = true; # broken dependency mingw-w64-i686-icon-naming-utils -> perl-XML-Simple
  };

  "mingw-w64-i686-iconv" = fetch {
    name        = "mingw-w64-i686-iconv";
    version     = "1.15";
    filename    = "mingw-w64-i686-iconv-1.15-3-any.pkg.tar.xz";
    sha256      = "a3d0e19f5a27b19d6e0d77bc537c0835c3f76ae8fe01535f430397901fbf5832";
    buildInputs = [ (assert mingw-w64-i686-libiconv.version=="1.15"; mingw-w64-i686-libiconv) mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-icoutils" = fetch {
    name        = "mingw-w64-i686-icoutils";
    version     = "0.32.3";
    filename    = "mingw-w64-i686-icoutils-0.32.3-1-any.pkg.tar.xz";
    sha256      = "4d931c4db117f1cf5c0ccc4352a96dc1508cbb966d477b7d5a0d5d28258e4c78";
    buildInputs = [ mingw-w64-i686-libpng ];
  };

  "mingw-w64-i686-icu" = fetch {
    name        = "mingw-w64-i686-icu";
    version     = "62.1";
    filename    = "mingw-w64-i686-icu-62.1-1-any.pkg.tar.xz";
    sha256      = "5d88d96fa9e108f0a379cf720db8a01aefda8d6ed370205cf93ee61939719f72";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-icu-debug-libs" = fetch {
    name        = "mingw-w64-i686-icu-debug-libs";
    version     = "62.1";
    filename    = "mingw-w64-i686-icu-debug-libs-62.1-1-any.pkg.tar.xz";
    sha256      = "f4c1baaffa4fc715c37255f98e8d26f5989d1593112f7bb26991c61fe754fba2";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-id3lib" = fetch {
    name        = "mingw-w64-i686-id3lib";
    version     = "3.8.3";
    filename    = "mingw-w64-i686-id3lib-3.8.3-2-any.pkg.tar.xz";
    sha256      = "223729f02fe92fc9e0a9f374365ad7c3290615d828a94764ab72865fc85832c1";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-ilmbase" = fetch {
    name        = "mingw-w64-i686-ilmbase";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-ilmbase-2.3.0-1-any.pkg.tar.xz";
    sha256      = "26a0ad8f30d67e2a6599e26600bde6ab5b22af4818363a402cfa4ff702e8dfa9";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-imagemagick" = fetch {
    name        = "mingw-w64-i686-imagemagick";
    version     = "7.0.8.14";
    filename    = "mingw-w64-i686-imagemagick-7.0.8.14-1-any.pkg.tar.xz";
    sha256      = "00eaa86687b9201445a357bf12e79753c939bf3efbba04150793ab62d301373a";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-djvulibre mingw-w64-i686-flif mingw-w64-i686-fftw mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-glib2 mingw-w64-i686-gsfonts mingw-w64-i686-jasper mingw-w64-i686-jbigkit mingw-w64-i686-lcms2 mingw-w64-i686-liblqr mingw-w64-i686-libpng mingw-w64-i686-libraqm mingw-w64-i686-libtiff mingw-w64-i686-libtool mingw-w64-i686-libwebp mingw-w64-i686-libxml2 mingw-w64-i686-openjpeg2 mingw-w64-i686-ttf-dejavu mingw-w64-i686-xz mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-djvulibre -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-indent" = fetch {
    name        = "mingw-w64-i686-indent";
    version     = "2.2.12";
    filename    = "mingw-w64-i686-indent-2.2.12-1-any.pkg.tar.xz";
    sha256      = "582315fcacc3c411ca4e70d536655d71b6fcd8e77dbab0cbc3b3a0c805ed3700";
  };

  "mingw-w64-i686-inkscape" = fetch {
    name        = "mingw-w64-i686-inkscape";
    version     = "0.92.3";
    filename    = "mingw-w64-i686-inkscape-0.92.3-7-any.pkg.tar.xz";
    sha256      = "5a94a5dafafbc999d392f5fbdb47897e7160eee915436721ae8466ce3c2e8e27";
    buildInputs = [ mingw-w64-i686-aspell mingw-w64-i686-gc mingw-w64-i686-ghostscript mingw-w64-i686-gsl mingw-w64-i686-gtkmm mingw-w64-i686-gtkspell mingw-w64-i686-hicolor-icon-theme mingw-w64-i686-imagemagick mingw-w64-i686-lcms2 mingw-w64-i686-libcdr mingw-w64-i686-libvisio mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-libwpg mingw-w64-i686-poppler mingw-w64-i686-popt mingw-w64-i686-potrace mingw-w64-i686-python2 ];
    broken      = true; # broken dependency mingw-w64-i686-ghostscript -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-innoextract" = fetch {
    name        = "mingw-w64-i686-innoextract";
    version     = "1.7";
    filename    = "mingw-w64-i686-innoextract-1.7-1-any.pkg.tar.xz";
    sha256      = "465ff9dc705204f419410aece3a40d26a76825395fd867a08edcddc39439a356";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-boost mingw-w64-i686-bzip2 mingw-w64-i686-libiconv mingw-w64-i686-xz mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-intel-tbb" = fetch {
    name        = "mingw-w64-i686-intel-tbb";
    version     = "1~2019_20181003";
    filename    = "mingw-w64-i686-intel-tbb-1~2019_20181003-1-any.pkg.tar.xz";
    sha256      = "0199096d0574a1e9cb2df31920d1b171fcfbbfb968a135cefa09238ab4c7914e";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-irrlicht" = fetch {
    name        = "mingw-w64-i686-irrlicht";
    version     = "1.8.4";
    filename    = "mingw-w64-i686-irrlicht-1.8.4-1-any.pkg.tar.xz";
    sha256      = "adfd44870e46aa18226e4f2b72c4f3cd5bffe4c43f4bde433db93b99fc62e856";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-isl" = fetch {
    name        = "mingw-w64-i686-isl";
    version     = "0.19";
    filename    = "mingw-w64-i686-isl-0.19-1-any.pkg.tar.xz";
    sha256      = "456e65e17efe9e652fa28d9def47ea726fbbc1079cb4abaac5b420e2d47fb65c";
    buildInputs = [  ];
  };

  "mingw-w64-i686-iso-codes" = fetch {
    name        = "mingw-w64-i686-iso-codes";
    version     = "4.1";
    filename    = "mingw-w64-i686-iso-codes-4.1-1-any.pkg.tar.xz";
    sha256      = "80e390a769b4a0f417eea8ca5ec8b0dce72500a708325ec6eb7a2f8f816ddfc8";
    buildInputs = [  ];
  };

  "mingw-w64-i686-itk" = fetch {
    name        = "mingw-w64-i686-itk";
    version     = "4.13.1";
    filename    = "mingw-w64-i686-itk-4.13.1-1-any.pkg.tar.xz";
    sha256      = "20714317a0b096a310bbbb52fb94cc9254ce4273bcc5b6f06d1aec694433a156";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-expat mingw-w64-i686-fftw mingw-w64-i686-gdcm mingw-w64-i686-hdf5 mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-poppler -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-jansson" = fetch {
    name        = "mingw-w64-i686-jansson";
    version     = "2.12";
    filename    = "mingw-w64-i686-jansson-2.12-1-any.pkg.tar.xz";
    sha256      = "f2314453c35eee30f6692ceb24edb9929175dd934b3931dcfd148e90cbab8ec1";
    buildInputs = [  ];
  };

  "mingw-w64-i686-jasper" = fetch {
    name        = "mingw-w64-i686-jasper";
    version     = "2.0.14";
    filename    = "mingw-w64-i686-jasper-2.0.14-1-any.pkg.tar.xz";
    sha256      = "948dec05bc2b8d9e9e57aaa579c253867df48510cffd7e02bbad3dd1a36f51d2";
    buildInputs = [ mingw-w64-i686-freeglut mingw-w64-i686-libjpeg-turbo ];
  };

  "mingw-w64-i686-jbigkit" = fetch {
    name        = "mingw-w64-i686-jbigkit";
    version     = "2.1";
    filename    = "mingw-w64-i686-jbigkit-2.1-4-any.pkg.tar.xz";
    sha256      = "a68955c6c7fa8907a0605bb6b7a90ae598b6131afd0243a4fdb953bcb7a53f61";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-jemalloc" = fetch {
    name        = "mingw-w64-i686-jemalloc";
    version     = "5.1.0";
    filename    = "mingw-w64-i686-jemalloc-5.1.0-3-any.pkg.tar.xz";
    sha256      = "2e7eb7c2b2cdb80e15103a9bccc41f027288d1c70ef80f6e92690a5c5a0ef7db";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-jpegoptim" = fetch {
    name        = "mingw-w64-i686-jpegoptim";
    version     = "1.4.6";
    filename    = "mingw-w64-i686-jpegoptim-1.4.6-1-any.pkg.tar.xz";
    sha256      = "3b56b3432769077eb4cd38bbfa41368bead3a2c1e2393b0adbf4fec061e6e516";
    buildInputs = [ mingw-w64-i686-libjpeg-turbo ];
  };

  "mingw-w64-i686-jq" = fetch {
    name        = "mingw-w64-i686-jq";
    version     = "1.6";
    filename    = "mingw-w64-i686-jq-1.6-1-any.pkg.tar.xz";
    sha256      = "982012aa49fe14f21fc7482f081efb133838f39468824b67d0492b0c7c89939c";
    buildInputs = [ mingw-w64-i686-oniguruma ];
  };

  "mingw-w64-i686-json-c" = fetch {
    name        = "mingw-w64-i686-json-c";
    version     = "0.13.1_20180305";
    filename    = "mingw-w64-i686-json-c-0.13.1_20180305-1-any.pkg.tar.xz";
    sha256      = "4df4f09aae52b89426bf0cd5d8b324568f381a86e7475385aa524c4c3c3e19ae";
    buildInputs = [  ];
  };

  "mingw-w64-i686-json-glib" = fetch {
    name        = "mingw-w64-i686-json-glib";
    version     = "1.4.4";
    filename    = "mingw-w64-i686-json-glib-1.4.4-1-any.pkg.tar.xz";
    sha256      = "3dc69467c948e6ecc2c858ea62dbe19f3d586354a5e577328c0631287a5e49fa";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-jsoncpp" = fetch {
    name        = "mingw-w64-i686-jsoncpp";
    version     = "1.8.4";
    filename    = "mingw-w64-i686-jsoncpp-1.8.4-3-any.pkg.tar.xz";
    sha256      = "0fbc531b7adf429674c34ea7124b0e8e863cf687ebf23ee42b10fde944e07956";
    buildInputs = [  ];
  };

  "mingw-w64-i686-jsonrpc-glib" = fetch {
    name        = "mingw-w64-i686-jsonrpc-glib";
    version     = "3.30.1";
    filename    = "mingw-w64-i686-jsonrpc-glib-3.30.1-1-any.pkg.tar.xz";
    sha256      = "9d53bcf29eeeec29a412ea8a023f05c386a8be7a44bbd6d9704f51df3f915c35";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-json-glib ];
  };

  "mingw-w64-i686-jxrlib" = fetch {
    name        = "mingw-w64-i686-jxrlib";
    version     = "1.1";
    filename    = "mingw-w64-i686-jxrlib-1.1-3-any.pkg.tar.xz";
    sha256      = "a7f3f113f62e01f2d7e0cb51b226070448d40c7cb8731e24ff773b3c6da03802";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-kactivities-qt5" = fetch {
    name        = "mingw-w64-i686-kactivities-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kactivities-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "d3f8bb3407304d489f7951ba7f00cb41597637f15aa58943c16a80a6e03c09b9";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcoreaddons-qt5.version "5.50.0"; mingw-w64-i686-kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kconfig-qt5.version "5.50.0"; mingw-w64-i686-kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kwindowsystem-qt5.version "5.50.0"; mingw-w64-i686-kwindowsystem-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-karchive-qt5" = fetch {
    name        = "mingw-w64-i686-karchive-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-karchive-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "11702e75d4dddfd00cc92f41d4957a79d17ff8a8a67de8ca89c0271037735c69";
    buildInputs = [ mingw-w64-i686-zlib mingw-w64-i686-bzip2 mingw-w64-i686-xz mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kate" = fetch {
    name        = "mingw-w64-i686-kate";
    version     = "18.08.1";
    filename    = "mingw-w64-i686-kate-18.08.1-2-any.pkg.tar.xz";
    sha256      = "4ced4b617d3b76d19411c5e2880d4f4259fe068b22423f44223eb5d6f12965cf";
    buildInputs = [ mingw-w64-i686-knewstuff-qt5 mingw-w64-i686-ktexteditor-qt5 mingw-w64-i686-threadweaver-qt5 mingw-w64-i686-kitemmodels-qt5 mingw-w64-i686-kactivities-qt5 mingw-w64-i686-plasma-framework-qt5 mingw-w64-i686-hicolor-icon-theme ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kauth-qt5" = fetch {
    name        = "mingw-w64-i686-kauth-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kauth-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "797615f9ddaaf992c1963d7e4acaaa156c6dbe6e0995ed9c657f4b56df4bbdfe";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcoreaddons-qt5.version "5.50.0"; mingw-w64-i686-kcoreaddons-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kbookmarks-qt5" = fetch {
    name        = "mingw-w64-i686-kbookmarks-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kbookmarks-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "bb4a2c97abb869622ace4a89bb817aeec36b1cb1fd5b8ab81407903437f4df3b";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kxmlgui-qt5.version "5.50.0"; mingw-w64-i686-kxmlgui-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kcmutils-qt5" = fetch {
    name        = "mingw-w64-i686-kcmutils-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kcmutils-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "d747c0a5da10802a60365490cd3e43b7a728fe5a34c9740f3e0fd54238a861ac";
    buildInputs = [ mingw-w64-i686-kdeclarative-qt5 mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kcodecs-qt5" = fetch {
    name        = "mingw-w64-i686-kcodecs-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kcodecs-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "003e11c3178277ec9efee4dd348210c75e7985b69b7c70031d8b7d544d485586";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kcompletion-qt5" = fetch {
    name        = "mingw-w64-i686-kcompletion-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kcompletion-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "4b63ea9d2e55fbfd85425923b86d95e79bdfa6a83c1be54f912b6385de3d7009";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kconfig-qt5.version "5.50.0"; mingw-w64-i686-kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kwidgetsaddons-qt5.version "5.50.0"; mingw-w64-i686-kwidgetsaddons-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kconfig-qt5" = fetch {
    name        = "mingw-w64-i686-kconfig-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kconfig-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "874038ed7b8033e3f76d81390f3b1041480590ac23c4e03283bed584a6a0d808";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kconfigwidgets-qt5" = fetch {
    name        = "mingw-w64-i686-kconfigwidgets-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kconfigwidgets-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "5886fca6e3951818ed0db32eeeb819a3ff9334f0aa060a5e2e2f5a8f41edf77e";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kauth-qt5.version "5.50.0"; mingw-w64-i686-kauth-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcoreaddons-qt5.version "5.50.0"; mingw-w64-i686-kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcodecs-qt5.version "5.50.0"; mingw-w64-i686-kcodecs-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kconfig-qt5.version "5.50.0"; mingw-w64-i686-kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kguiaddons-qt5.version "5.50.0"; mingw-w64-i686-kguiaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-ki18n-qt5.version "5.50.0"; mingw-w64-i686-ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kwidgetsaddons-qt5.version "5.50.0"; mingw-w64-i686-kwidgetsaddons-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kcoreaddons-qt5" = fetch {
    name        = "mingw-w64-i686-kcoreaddons-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kcoreaddons-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "9c03c54c49b8cb8801f55716d9a1ae0375ab22c77e8e4daa3dd680c7c7ad6fe0";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kcrash-qt5" = fetch {
    name        = "mingw-w64-i686-kcrash-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kcrash-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "3e27297408bf881b8b341dc819a5aed2546920d2f6da5cb088d3018438bbdfc0";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcoreaddons-qt5.version "5.50.0"; mingw-w64-i686-kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kwindowsystem-qt5.version "5.50.0"; mingw-w64-i686-kwindowsystem-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kdbusaddons-qt5" = fetch {
    name        = "mingw-w64-i686-kdbusaddons-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kdbusaddons-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "4d2f057e21ee940920a11d146f555dbe9dddf943c2248e72ab0ef5568bc693e7";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kdeclarative-qt5" = fetch {
    name        = "mingw-w64-i686-kdeclarative-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kdeclarative-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "7139b10636ca16185c7bd873d17dc591d4832a690dd1372c0cfaea3028ac7e58";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-kio-qt5 mingw-w64-i686-kpackage-qt5 mingw-w64-i686-libepoxy ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kdewebkit-qt5" = fetch {
    name        = "mingw-w64-i686-kdewebkit-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kdewebkit-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "c38dcc7ca872ca82270f2f04f91413fd175eaf7c4569975409da20d81194336c";
    buildInputs = [ mingw-w64-i686-kparts-qt5 mingw-w64-i686-qtwebkit ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kdnssd-qt5" = fetch {
    name        = "mingw-w64-i686-kdnssd-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kdnssd-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "b4c314d27c3a1c640e4c98443c7e380d123fc02a5bdfc0c6bc1420b443ece62f";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kdoctools-qt5" = fetch {
    name        = "mingw-w64-i686-kdoctools-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kdoctools-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "ae207ebd2ae9513bc32795e661494a2b69540087c3d553691e83eb2b64d4377a";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-libxslt mingw-w64-i686-docbook-xsl (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-ki18n-qt5.version "5.50.0"; mingw-w64-i686-ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-karchive-qt5.version "5.50.0"; mingw-w64-i686-karchive-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kfilemetadata-qt5" = fetch {
    name        = "mingw-w64-i686-kfilemetadata-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kfilemetadata-qt5-5.50.0-4-any.pkg.tar.xz";
    sha256      = "7eee5becad621408f8658a8f2fa811d280109f7d904cc8acff88445c529de73b";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-ki18n-qt5.version "5.50.0"; mingw-w64-i686-ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-karchive-qt5.version "5.50.0"; mingw-w64-i686-karchive-qt5) mingw-w64-i686-exiv2 mingw-w64-i686-poppler mingw-w64-i686-taglib mingw-w64-i686-ffmpeg ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kglobalaccel-qt5" = fetch {
    name        = "mingw-w64-i686-kglobalaccel-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kglobalaccel-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "571f336e9727a267efa82b1d4fcc02378bd9a5be8d66150ae5cf9ce3bd3fe6f4";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kconfig-qt5.version "5.50.0"; mingw-w64-i686-kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcrash-qt5.version "5.50.0"; mingw-w64-i686-kcrash-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kdbusaddons-qt5.version "5.50.0"; mingw-w64-i686-kdbusaddons-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kguiaddons-qt5" = fetch {
    name        = "mingw-w64-i686-kguiaddons-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kguiaddons-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "63ee3e585efea015a175fffcb9389cd3d2b3be43ac6a461c757b1933599c30b5";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kholidays-qt5" = fetch {
    name        = "mingw-w64-i686-kholidays-qt5";
    version     = "1~5.50.0";
    filename    = "mingw-w64-i686-kholidays-qt5-1~5.50.0-1-any.pkg.tar.xz";
    sha256      = "d9998c84e1e03a317efecb999db532067da79adbc19c6a7cbd8e32e6f257a0c6";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-ki18n-qt5" = fetch {
    name        = "mingw-w64-i686-ki18n-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-ki18n-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "457d4d67a46811629da76f293eb7e09998819f5e2cfbd31878ae09d82c1f377e";
    buildInputs = [ mingw-w64-i686-gettext mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kicad" = fetch {
    name        = "mingw-w64-i686-kicad";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-5.0.2-1-any.pkg.tar.xz";
    sha256      = "dab969ed6e6726e7a5dc6327e69edd527c6a95a3a44a28cab78be6b6c187d016";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-cairo mingw-w64-i686-curl mingw-w64-i686-glew mingw-w64-i686-ngspice mingw-w64-i686-oce mingw-w64-i686-openssl mingw-w64-i686-wxPython mingw-w64-i686-wxWidgets ];
  };

  "mingw-w64-i686-kicad-doc-ca" = fetch {
    name        = "mingw-w64-i686-kicad-doc-ca";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-ca-5.0.2-1-any.pkg.tar.xz";
    sha256      = "337cbf2ad7efe89cf3890dbf13753a2e3d5b1a5b718274d6b5405939b670b0f1";
  };

  "mingw-w64-i686-kicad-doc-de" = fetch {
    name        = "mingw-w64-i686-kicad-doc-de";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-de-5.0.2-1-any.pkg.tar.xz";
    sha256      = "3d5e3d2976c0b6e3cbb95632483eb16637357ca669b2c737c5ab789156b17934";
  };

  "mingw-w64-i686-kicad-doc-en" = fetch {
    name        = "mingw-w64-i686-kicad-doc-en";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-en-5.0.2-1-any.pkg.tar.xz";
    sha256      = "2ea691ae858eed7425cf71de5e3609f54517a6f915b45180d2441b9258b83344";
  };

  "mingw-w64-i686-kicad-doc-es" = fetch {
    name        = "mingw-w64-i686-kicad-doc-es";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-es-5.0.2-1-any.pkg.tar.xz";
    sha256      = "47855eb833380cdb785f6ecc9eedf85f2abf68c298f91b86728dd30fea2211bf";
  };

  "mingw-w64-i686-kicad-doc-fr" = fetch {
    name        = "mingw-w64-i686-kicad-doc-fr";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-fr-5.0.2-1-any.pkg.tar.xz";
    sha256      = "0592a44f4ce13de4935f1df34c8dbb4bf8f57b365928d07b2bf1dc372f179e9a";
  };

  "mingw-w64-i686-kicad-doc-id" = fetch {
    name        = "mingw-w64-i686-kicad-doc-id";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-id-5.0.2-1-any.pkg.tar.xz";
    sha256      = "fd440b26039441fd87a628427cb1692f00a7fa53f4d378f6dbfa41ffea450d87";
  };

  "mingw-w64-i686-kicad-doc-it" = fetch {
    name        = "mingw-w64-i686-kicad-doc-it";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-it-5.0.2-1-any.pkg.tar.xz";
    sha256      = "6e1ef1e811bc526b6e26d489e7423056eab89b84958046694c333b7bd6d1b98d";
  };

  "mingw-w64-i686-kicad-doc-ja" = fetch {
    name        = "mingw-w64-i686-kicad-doc-ja";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-ja-5.0.2-1-any.pkg.tar.xz";
    sha256      = "57a27f978490087e5345824e98f2558c88755a5ca028f894a2e393f9d5fa9326";
  };

  "mingw-w64-i686-kicad-doc-nl" = fetch {
    name        = "mingw-w64-i686-kicad-doc-nl";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-nl-5.0.2-1-any.pkg.tar.xz";
    sha256      = "10f5afaaeee64da157b953720fbe4d7422844599143e06b0d2c5bc9480daf11b";
  };

  "mingw-w64-i686-kicad-doc-pl" = fetch {
    name        = "mingw-w64-i686-kicad-doc-pl";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-pl-5.0.2-1-any.pkg.tar.xz";
    sha256      = "c2f3a762dc781e02bfe22041eb2cb1ad1cac12c881be23a6f8730363fbdf6a22";
  };

  "mingw-w64-i686-kicad-doc-ru" = fetch {
    name        = "mingw-w64-i686-kicad-doc-ru";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-ru-5.0.2-1-any.pkg.tar.xz";
    sha256      = "0aff85593cfc39934f99bdb2d1c2239eb7dda4017819eeb05cf09cc18573c033";
  };

  "mingw-w64-i686-kicad-doc-zh" = fetch {
    name        = "mingw-w64-i686-kicad-doc-zh";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-doc-zh-5.0.2-1-any.pkg.tar.xz";
    sha256      = "c9e82756b5169ee3f8c4814784b09e6daa25f33656cf4ec3f31c6d15f664c737";
  };

  "mingw-w64-i686-kicad-footprints" = fetch {
    name        = "mingw-w64-i686-kicad-footprints";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-footprints-5.0.2-1-any.pkg.tar.xz";
    sha256      = "dbb82bdaa12e2c40d8a03adfe27fd50596a263ed481279d8f5088ce09608883a";
  };

  "mingw-w64-i686-kicad-meta" = fetch {
    name        = "mingw-w64-i686-kicad-meta";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-meta-5.0.2-1-any.pkg.tar.xz";
    sha256      = "1b5b775ab54d23274d792868647d84faa5a5d7a866c882ceb158bfd9272f49f1";
    buildInputs = [ mingw-w64-i686-kicad mingw-w64-i686-kicad-footprints mingw-w64-i686-kicad-symbols mingw-w64-i686-kicad-templates mingw-w64-i686-kicad-packages3D ];
  };

  "mingw-w64-i686-kicad-packages3D" = fetch {
    name        = "mingw-w64-i686-kicad-packages3D";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-packages3D-5.0.2-1-any.pkg.tar.xz";
    sha256      = "4ff98ca791b2984faa5523d39fbe7db656bdd15e658f0cac632c13fc41f481f3";
    buildInputs = [  ];
  };

  "mingw-w64-i686-kicad-symbols" = fetch {
    name        = "mingw-w64-i686-kicad-symbols";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-symbols-5.0.2-1-any.pkg.tar.xz";
    sha256      = "bacca691da63040ddb5aa119d74792a0cdd264ee525f4c6d36cf7115c01ff523";
    buildInputs = [  ];
  };

  "mingw-w64-i686-kicad-templates" = fetch {
    name        = "mingw-w64-i686-kicad-templates";
    version     = "5.0.2";
    filename    = "mingw-w64-i686-kicad-templates-5.0.2-1-any.pkg.tar.xz";
    sha256      = "08fad76e436a171186e61b8cff396dacff55e0b991badc0da8970d281146de0d";
    buildInputs = [  ];
  };

  "mingw-w64-i686-kiconthemes-qt5" = fetch {
    name        = "mingw-w64-i686-kiconthemes-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kiconthemes-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "a027f687555c3a407cd9e3edc93c01a7bcf53566e4857c89000c97cbd5c46aad";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kconfigwidgets-qt5.version "5.50.0"; mingw-w64-i686-kconfigwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kitemviews-qt5.version "5.50.0"; mingw-w64-i686-kitemviews-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-karchive-qt5.version "5.50.0"; mingw-w64-i686-karchive-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kidletime-qt5" = fetch {
    name        = "mingw-w64-i686-kidletime-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kidletime-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "d3d2ad0ac31a17e0a16b40289df09c68620379f3522c5a4f581435363fcf0a91";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kimageformats-qt5" = fetch {
    name        = "mingw-w64-i686-kimageformats-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kimageformats-qt5-5.50.0-3-any.pkg.tar.xz";
    sha256      = "dcbe90d899681ea62bbf0cf5fbf000c11b859c3c8ba6d54be79beb292709017b";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-openexr (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-karchive-qt5.version "5.50.0"; mingw-w64-i686-karchive-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kinit-qt5" = fetch {
    name        = "mingw-w64-i686-kinit-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kinit-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "50e69e4037d57d9b8f0599765edd3b7950151e713573903f65439175ee525928";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kio-qt5.version "5.50.0"; mingw-w64-i686-kio-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kio-qt5" = fetch {
    name        = "mingw-w64-i686-kio-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kio-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "531b73ba1a84a7f119f1f58109057122073ed53662b513a1f1ae5dcd18c31a00";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-solid-qt5.version "5.50.0"; mingw-w64-i686-solid-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kjobwidgets-qt5.version "5.50.0"; mingw-w64-i686-kjobwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kbookmarks-qt5.version "5.50.0"; mingw-w64-i686-kbookmarks-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kwallet-qt5.version "5.50.0"; mingw-w64-i686-kwallet-qt5) mingw-w64-i686-libxslt ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kirigami2-qt5" = fetch {
    name        = "mingw-w64-i686-kirigami2-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kirigami2-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "f32aeff1a93eecb1e51e0a0d6cb619b7e5794b23decf0d6b36cf87027bf8744b";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kiss_fft" = fetch {
    name        = "mingw-w64-i686-kiss_fft";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-kiss_fft-1.3.0-2-any.pkg.tar.xz";
    sha256      = "c9aa73612cb09611d5dd0207f33b80a053940e433563382d8d924910652d616e";
  };

  "mingw-w64-i686-kitemmodels-qt5" = fetch {
    name        = "mingw-w64-i686-kitemmodels-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kitemmodels-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "3db46db366bfa7d4aab667fc5f5af6e9c44faa88585321c4c1d94a673e1988d7";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kitemviews-qt5" = fetch {
    name        = "mingw-w64-i686-kitemviews-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kitemviews-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "b12af8ebba3d3b9ea4bee03e62a65a940fa1e3c66d445380e64501e24dbd5962";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kjobwidgets-qt5" = fetch {
    name        = "mingw-w64-i686-kjobwidgets-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kjobwidgets-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "1c88a5795aa61bd1ce6128057db7103f53b829600ffe6139baf965fd0c2b19dc";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcoreaddons-qt5.version "5.50.0"; mingw-w64-i686-kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kwidgetsaddons-qt5.version "5.50.0"; mingw-w64-i686-kwidgetsaddons-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kjs-qt5" = fetch {
    name        = "mingw-w64-i686-kjs-qt5";
    version     = "5.42.0";
    filename    = "mingw-w64-i686-kjs-qt5-5.42.0-1-any.pkg.tar.xz";
    sha256      = "2822c94479f0a1ab621364d039cf0b124059ebb43b5dc7a2b8588bbf3645faeb";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-bzip2 mingw-w64-i686-pcre (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kdoctools-qt5.version "5.42.0"; mingw-w64-i686-kdoctools-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-knewstuff-qt5" = fetch {
    name        = "mingw-w64-i686-knewstuff-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-knewstuff-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "c5cef7e89f68cf5b391997999d7204355ee113d21a297545495edc8d495a4b6d";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kio-qt5.version "5.50.0"; mingw-w64-i686-kio-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-knotifications-qt5" = fetch {
    name        = "mingw-w64-i686-knotifications-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-knotifications-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "221be261bc291f30f76f7d82a847c4430fc3928b73dee7eefe3d09d4631d9e89";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-phonon-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcodecs-qt5.version "5.50.0"; mingw-w64-i686-kcodecs-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kconfig-qt5.version "5.50.0"; mingw-w64-i686-kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcoreaddons-qt5.version "5.50.0"; mingw-w64-i686-kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kwindowsystem-qt5.version "5.50.0"; mingw-w64-i686-kwindowsystem-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kpackage-qt5" = fetch {
    name        = "mingw-w64-i686-kpackage-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kpackage-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "93b89dde7f9aff374d43366422ccd43de3624a6e2de9a4f04049bf3d37132898";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-karchive-qt5.version "5.50.0"; mingw-w64-i686-karchive-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-ki18n-qt5.version "5.50.0"; mingw-w64-i686-ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcoreaddons-qt5.version "5.50.0"; mingw-w64-i686-kcoreaddons-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kparts-qt5" = fetch {
    name        = "mingw-w64-i686-kparts-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kparts-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "d8751b6ae224d9d71274de393e44181ec4b8eee1c9dbce60eb7450add3e1b836";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kio-qt5.version "5.50.0"; mingw-w64-i686-kio-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kplotting-qt5" = fetch {
    name        = "mingw-w64-i686-kplotting-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kplotting-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "5056f45841dec79c5480a0b6b5927492f628a28754ae97f4b2e18ee0dc26a3d7";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kqoauth-qt4" = fetch {
    name        = "mingw-w64-i686-kqoauth-qt4";
    version     = "0.98";
    filename    = "mingw-w64-i686-kqoauth-qt4-0.98-3-any.pkg.tar.xz";
    sha256      = "851b90b63408e180a4b7961c660bfa8dda1bb27eecef2852fee9c9e75fa3d062";
    buildInputs = [ mingw-w64-i686-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-kservice-qt5" = fetch {
    name        = "mingw-w64-i686-kservice-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kservice-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "108bbdc2dfd4ae2b3c6127feeb92e11bb87d23a6d7ff29a711a4420c08bc922a";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-ki18n-qt5.version "5.50.0"; mingw-w64-i686-ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kconfig-qt5.version "5.50.0"; mingw-w64-i686-kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcrash-qt5.version "5.50.0"; mingw-w64-i686-kcrash-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kdbusaddons-qt5.version "5.50.0"; mingw-w64-i686-kdbusaddons-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-ktexteditor-qt5" = fetch {
    name        = "mingw-w64-i686-ktexteditor-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-ktexteditor-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "0d4c1cd7fba1e69f4fdf4f05d5e630d1c43dad1c6e813467228a182bc62b7bd8";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kparts-qt5.version "5.50.0"; mingw-w64-i686-kparts-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-syntax-highlighting-qt5.version "5.50.0"; mingw-w64-i686-syntax-highlighting-qt5) mingw-w64-i686-libgit2 mingw-w64-i686-editorconfig-core-c ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-ktextwidgets-qt5" = fetch {
    name        = "mingw-w64-i686-ktextwidgets-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-ktextwidgets-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "fb76f33614a3ede16dfbc5c2ed30f1bc35562b612776c22f6262202a908c479c";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcompletion-qt5.version "5.50.0"; mingw-w64-i686-kcompletion-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kservice-qt5.version "5.50.0"; mingw-w64-i686-kservice-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kiconthemes-qt5.version "5.50.0"; mingw-w64-i686-kiconthemes-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-sonnet-qt5.version "5.50.0"; mingw-w64-i686-sonnet-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kunitconversion-qt5" = fetch {
    name        = "mingw-w64-i686-kunitconversion-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kunitconversion-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "5458a6b1c425e8bb338346166534287e2ce83f691b1e450c73c0e6832f320475";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-ki18n-qt5.version "5.50.0"; mingw-w64-i686-ki18n-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kvazaar" = fetch {
    name        = "mingw-w64-i686-kvazaar";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-kvazaar-1.2.0-1-any.pkg.tar.xz";
    sha256      = "c7d03214b10b245a44765290b68846deeeaed1d90c71a8060b8d026e75189b59";
    buildInputs = [ mingw-w64-i686-gcc-libs self."mingw-w64-i686-crypto++" ];
  };

  "mingw-w64-i686-kwallet-qt5" = fetch {
    name        = "mingw-w64-i686-kwallet-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kwallet-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "d88335771c1488a540815b897f3e378490a32531d7f2265a4ce2f8dd6524d2b0";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-knotifications-qt5.version "5.50.0"; mingw-w64-i686-knotifications-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kiconthemes-qt5.version "5.50.0"; mingw-w64-i686-kiconthemes-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kservice-qt5.version "5.50.0"; mingw-w64-i686-kservice-qt5) mingw-w64-i686-gpgme ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kwidgetsaddons-qt5" = fetch {
    name        = "mingw-w64-i686-kwidgetsaddons-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kwidgetsaddons-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "b3a9eb22bce3a0a5e8800878d39ac58aaaaece43ab90d3209c64b9bfb5727851";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kwindowsystem-qt5" = fetch {
    name        = "mingw-w64-i686-kwindowsystem-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kwindowsystem-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "c63c5c746aed911c183ba8b51a7b91c2e78c8c1740c17100b13fb1cb12eead46";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-kxmlgui-qt5" = fetch {
    name        = "mingw-w64-i686-kxmlgui-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-kxmlgui-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "4c58562bfef485d595e74822f160266bfd87dbfde9c8b8a9851766ac9ca75716";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kglobalaccel-qt5.version "5.50.0"; mingw-w64-i686-kglobalaccel-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-ktextwidgets-qt5.version "5.50.0"; mingw-w64-i686-ktextwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-attica-qt5.version "5.50.0"; mingw-w64-i686-attica-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-l-smash" = fetch {
    name        = "mingw-w64-i686-l-smash";
    version     = "2.14.5";
    filename    = "mingw-w64-i686-l-smash-2.14.5-1-any.pkg.tar.xz";
    sha256      = "bd339007ad2ac6d9bfd58c88de34e6e7e91bd97c9680b144fee3bf7a930f39ca";
  };

  "mingw-w64-i686-ladspa-sdk" = fetch {
    name        = "mingw-w64-i686-ladspa-sdk";
    version     = "1.13";
    filename    = "mingw-w64-i686-ladspa-sdk-1.13-2-any.pkg.tar.xz";
    sha256      = "dd8cf0979a516357aa039fb329351483127451a082b2f7ec475098b4420bbb82";
  };

  "mingw-w64-i686-lame" = fetch {
    name        = "mingw-w64-i686-lame";
    version     = "3.100";
    filename    = "mingw-w64-i686-lame-3.100-1-any.pkg.tar.xz";
    sha256      = "c1045d291d3ab739c487600323b3e2d1de2d32f778a3e5ae65f489bfc39cbfd9";
    buildInputs = [ mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-lapack" = fetch {
    name        = "mingw-w64-i686-lapack";
    version     = "3.8.0";
    filename    = "mingw-w64-i686-lapack-3.8.0-3-any.pkg.tar.xz";
    sha256      = "71c94a5bfe350b1be1491a76ab3417162ee86f038517a51bc38a7f35d9cb0c75";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gcc-libgfortran ];
  };

  "mingw-w64-i686-lasem" = fetch {
    name        = "mingw-w64-i686-lasem";
    version     = "0.4.3";
    filename    = "mingw-w64-i686-lasem-0.4.3-2-any.pkg.tar.xz";
    sha256      = "19a572659892bacf4e5a757dae9956aa098b09af3f8af1de93386eda51e5a567";
  };

  "mingw-w64-i686-laszip" = fetch {
    name        = "mingw-w64-i686-laszip";
    version     = "3.2.9";
    filename    = "mingw-w64-i686-laszip-3.2.9-1-any.pkg.tar.xz";
    sha256      = "5295278afaadb7f945d360b52d2341dcee2156072770ef2d76853a86ccc073bf";
  };

  "mingw-w64-i686-lcms" = fetch {
    name        = "mingw-w64-i686-lcms";
    version     = "1.19";
    filename    = "mingw-w64-i686-lcms-1.19-6-any.pkg.tar.xz";
    sha256      = "84a9d8ed48a4b6b3b1f0b4844bf23e6cfff91f82f7258b0ccb24a87f3a31bf57";
    buildInputs = [ mingw-w64-i686-libtiff ];
  };

  "mingw-w64-i686-lcms2" = fetch {
    name        = "mingw-w64-i686-lcms2";
    version     = "2.9";
    filename    = "mingw-w64-i686-lcms2-2.9-1-any.pkg.tar.xz";
    sha256      = "11f8dcb85817f423c88aa2ab86e63f74e913f2d7b808db8fab159833be9d3106";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libtiff ];
  };

  "mingw-w64-i686-lcov" = fetch {
    name        = "mingw-w64-i686-lcov";
    version     = "1.13";
    filename    = "mingw-w64-i686-lcov-1.13-2-any.pkg.tar.xz";
    sha256      = "3dea59b0ee6dd6578cb3e6301a0fb69ede2e354bd5a2faaea6ca2975d73d6c3e";
    buildInputs = [ mingw-w64-i686-perl ];
  };

  "mingw-w64-i686-ldns" = fetch {
    name        = "mingw-w64-i686-ldns";
    version     = "1.7.0";
    filename    = "mingw-w64-i686-ldns-1.7.0-3-any.pkg.tar.xz";
    sha256      = "29c7286a3dfed97d5532b2c290a95c53e0bd654bb25b89edb5139cb11e0b899e";
    buildInputs = [ mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-lensfun" = fetch {
    name        = "mingw-w64-i686-lensfun";
    version     = "0.3.95";
    filename    = "mingw-w64-i686-lensfun-0.3.95-1-any.pkg.tar.xz";
    sha256      = "86909b09802433758898ab5b892c293c5202a7c206f9f86c8ff423e4b72d5463";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-libpng mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-leptonica" = fetch {
    name        = "mingw-w64-i686-leptonica";
    version     = "1.77.0";
    filename    = "mingw-w64-i686-leptonica-1.77.0-1-any.pkg.tar.xz";
    sha256      = "e6bce338af07c577dccfb14cbe4a1a9f83bbf5d4c831855d4e2025f15638cb7f";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-giflib mingw-w64-i686-libtiff mingw-w64-i686-libpng mingw-w64-i686-libwebp mingw-w64-i686-openjpeg2 mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-lfcbase" = fetch {
    name        = "mingw-w64-i686-lfcbase";
    version     = "1.12.5";
    filename    = "mingw-w64-i686-lfcbase-1.12.5-1-any.pkg.tar.xz";
    sha256      = "c2f094a6d97ecd08ab985efbb627e0baeb41e026d1a3d26314d3d51836b8c3b4";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-ncurses ];
  };

  "mingw-w64-i686-lfcxml" = fetch {
    name        = "mingw-w64-i686-lfcxml";
    version     = "1.2.10";
    filename    = "mingw-w64-i686-lfcxml-1.2.10-1-any.pkg.tar.xz";
    sha256      = "7465891c74b744f59ee7164f76a7a762503abec68e635f2d96dee257d7ec1b55";
    buildInputs = [ mingw-w64-i686-lfcbase ];
  };

  "mingw-w64-i686-libaacs" = fetch {
    name        = "mingw-w64-i686-libaacs";
    version     = "0.9.0";
    filename    = "mingw-w64-i686-libaacs-0.9.0-1-any.pkg.tar.xz";
    sha256      = "d0950a4824d4c0164f0e095eda19fb32581941f23c18c2803c47bb8880e21599";
    buildInputs = [ mingw-w64-i686-libgcrypt ];
  };

  "mingw-w64-i686-libao" = fetch {
    name        = "mingw-w64-i686-libao";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-libao-1.2.2-1-any.pkg.tar.xz";
    sha256      = "93d17e663b7eb80ac58788592df98c8b287e1404eb5e7e10542c9c0427315fd7";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libarchive" = fetch {
    name        = "mingw-w64-i686-libarchive";
    version     = "3.3.3";
    filename    = "mingw-w64-i686-libarchive-3.3.3-2-any.pkg.tar.xz";
    sha256      = "aba721446e56ae0dadb30df567125c26ec7f043b8f80330b0f44ab0ee8b8fa8d";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-bzip2 mingw-w64-i686-expat mingw-w64-i686-libiconv mingw-w64-i686-lz4 mingw-w64-i686-lzo2 mingw-w64-i686-libsystre mingw-w64-i686-nettle mingw-w64-i686-openssl mingw-w64-i686-xz mingw-w64-i686-zlib mingw-w64-i686-zstd ];
  };

  "mingw-w64-i686-libart_lgpl" = fetch {
    name        = "mingw-w64-i686-libart_lgpl";
    version     = "2.3.21";
    filename    = "mingw-w64-i686-libart_lgpl-2.3.21-2-any.pkg.tar.xz";
    sha256      = "75977ad77c2be5118371d2adca18580e4e35c5fb4dbeaed9f5be7264ec0ae118";
  };

  "mingw-w64-i686-libass" = fetch {
    name        = "mingw-w64-i686-libass";
    version     = "0.14.0";
    filename    = "mingw-w64-i686-libass-0.14.0-1-any.pkg.tar.xz";
    sha256      = "d0d9d9a7eb4a976b659ada4a49cd2ffe9ee2974a6579c3bdc1d3dcb985b8e398";
    buildInputs = [ mingw-w64-i686-fribidi mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-harfbuzz ];
  };

  "mingw-w64-i686-libassuan" = fetch {
    name        = "mingw-w64-i686-libassuan";
    version     = "2.5.2";
    filename    = "mingw-w64-i686-libassuan-2.5.2-1-any.pkg.tar.xz";
    sha256      = "877d727681aaa46d1ae83f3eca227ed89d90ab084497089fea6e21554dda21f3";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libgpg-error ];
  };

  "mingw-w64-i686-libatomic_ops" = fetch {
    name        = "mingw-w64-i686-libatomic_ops";
    version     = "7.6.8";
    filename    = "mingw-w64-i686-libatomic_ops-7.6.8-1-any.pkg.tar.xz";
    sha256      = "4d3addf3d468ebfce48bb4f7d1104322c523d5c9d7e01e62183f45789383a065";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libbdplus" = fetch {
    name        = "mingw-w64-i686-libbdplus";
    version     = "0.1.2";
    filename    = "mingw-w64-i686-libbdplus-0.1.2-1-any.pkg.tar.xz";
    sha256      = "64fc5d0c4ece6410c88fc671a55a562d430a818caf0971ddf86b3b669f8d1e6f";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-libaacs.version "0.7.0"; mingw-w64-i686-libaacs) mingw-w64-i686-libgpg-error ];
  };

  "mingw-w64-i686-libblocksruntime" = fetch {
    name        = "mingw-w64-i686-libblocksruntime";
    version     = "0.4.1";
    filename    = "mingw-w64-i686-libblocksruntime-0.4.1-1-any.pkg.tar.xz";
    sha256      = "d7ef7df6320bce13fe011183cc950b999024ba5c7b27a91508fa9f089b5bdd61";
    buildInputs = [ mingw-w64-i686-clang ];
  };

  "mingw-w64-i686-libbluray" = fetch {
    name        = "mingw-w64-i686-libbluray";
    version     = "1.0.2";
    filename    = "mingw-w64-i686-libbluray-1.0.2-1-any.pkg.tar.xz";
    sha256      = "6548f814f494c683d97c7dd2031e846d19573e1625d2623eee863703e1627d69";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-freetype ];
  };

  "mingw-w64-i686-libbotan" = fetch {
    name        = "mingw-w64-i686-libbotan";
    version     = "2.8.0";
    filename    = "mingw-w64-i686-libbotan-2.8.0-1-any.pkg.tar.xz";
    sha256      = "b46a53861bf1aa7bf49250eada72a2c146662cbd13e904ec2c7e0fc23d582abf";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-boost mingw-w64-i686-bzip2 mingw-w64-i686-sqlite3 mingw-w64-i686-zlib mingw-w64-i686-xz ];
  };

  "mingw-w64-i686-libbs2b" = fetch {
    name        = "mingw-w64-i686-libbs2b";
    version     = "3.1.0";
    filename    = "mingw-w64-i686-libbs2b-3.1.0-1-any.pkg.tar.xz";
    sha256      = "1a974aa46bd3de2515f47911804938afaac8a4d7bc9b657b8627510aef44875a";
    buildInputs = [ mingw-w64-i686-libsndfile ];
  };

  "mingw-w64-i686-libbsdf" = fetch {
    name        = "mingw-w64-i686-libbsdf";
    version     = "0.9.4";
    filename    = "mingw-w64-i686-libbsdf-0.9.4-1-any.pkg.tar.xz";
    sha256      = "d45a6acb33950f2e6d191683cdab11975060eb4eebaa00eb7141f5575c09d963";
  };

  "mingw-w64-i686-libc++" = fetch {
    name        = "mingw-w64-i686-libc++";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-libc++-7.0.1-1-any.pkg.tar.xz";
    sha256      = "153f38231e753cd735433ea41eee05ccd0b95f4d0a4021a9da4d789317640ba5";
    buildInputs = [ mingw-w64-i686-gcc ];
  };

  "mingw-w64-i686-libc++abi" = fetch {
    name        = "mingw-w64-i686-libc++abi";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-libc++abi-7.0.1-1-any.pkg.tar.xz";
    sha256      = "8160722922164aa493a05d5da9305496d8d469e6c530c3e1d2adb7488792ca69";
    buildInputs = [ mingw-w64-i686-gcc ];
  };

  "mingw-w64-i686-libcaca" = fetch {
    name        = "mingw-w64-i686-libcaca";
    version     = "0.99.beta19";
    filename    = "mingw-w64-i686-libcaca-0.99.beta19-4-any.pkg.tar.xz";
    sha256      = "c48811f09d037b80b7d193d4a2713be2619b0dd79ca6f5307e05fcf950e24f63";
    buildInputs = [ mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libcddb" = fetch {
    name        = "mingw-w64-i686-libcddb";
    version     = "1.3.2";
    filename    = "mingw-w64-i686-libcddb-1.3.2-4-any.pkg.tar.xz";
    sha256      = "f41df9f1588c678b78e1b345354b65e57c48e4f64198b2b0e466604b362018e7";
    buildInputs = [ mingw-w64-i686-libsystre ];
  };

  "mingw-w64-i686-libcdio" = fetch {
    name        = "mingw-w64-i686-libcdio";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-libcdio-2.0.0-1-any.pkg.tar.xz";
    sha256      = "e4030d3915ae1dcc45a70180350ad95bb252f4e37959397f0533f015ea2f8f91";
    buildInputs = [ mingw-w64-i686-libiconv mingw-w64-i686-libcddb ];
  };

  "mingw-w64-i686-libcdio-paranoia" = fetch {
    name        = "mingw-w64-i686-libcdio-paranoia";
    version     = "10.2+0.94+2";
    filename    = "mingw-w64-i686-libcdio-paranoia-10.2+0.94+2-2-any.pkg.tar.xz";
    sha256      = "36ea5f9253dbc991d8f4e8365bf9b249742235a981564a5748d054a1838cc4a2";
    buildInputs = [ mingw-w64-i686-libcdio ];
  };

  "mingw-w64-i686-libcdr" = fetch {
    name        = "mingw-w64-i686-libcdr";
    version     = "0.1.4";
    filename    = "mingw-w64-i686-libcdr-0.1.4-3-any.pkg.tar.xz";
    sha256      = "91c2b1025f44ad37bb7e71b2c6cdf2d6d025ba61ab68acf756bf7050360b6573";
    buildInputs = [ mingw-w64-i686-icu mingw-w64-i686-lcms2 mingw-w64-i686-librevenge mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libcerf" = fetch {
    name        = "mingw-w64-i686-libcerf";
    version     = "1.11";
    filename    = "mingw-w64-i686-libcerf-1.11-1-any.pkg.tar.xz";
    sha256      = "10e1c5e57290e4ff69720d24a83d7932fbb1db2ed3236c43ab81a5bac1933f6a";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libchamplain" = fetch {
    name        = "mingw-w64-i686-libchamplain";
    version     = "0.12.16";
    filename    = "mingw-w64-i686-libchamplain-0.12.16-1-any.pkg.tar.xz";
    sha256      = "484b3132e78ffa93e04eb74697005333dd05cadf1bcbd7adb8fef81aaa2d7c8d";
    buildInputs = [ mingw-w64-i686-clutter mingw-w64-i686-clutter-gtk mingw-w64-i686-cairo mingw-w64-i686-libsoup mingw-w64-i686-memphis mingw-w64-i686-sqlite3 ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-libconfig" = fetch {
    name        = "mingw-w64-i686-libconfig";
    version     = "1.7.2";
    filename    = "mingw-w64-i686-libconfig-1.7.2-1-any.pkg.tar.xz";
    sha256      = "53ba95caf85272e6e40fd946c34386c3b88cb93816e8b4056e9490402d48dc23";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libcroco" = fetch {
    name        = "mingw-w64-i686-libcroco";
    version     = "0.6.12";
    filename    = "mingw-w64-i686-libcroco-0.6.12-1-any.pkg.tar.xz";
    sha256      = "b04bf097c6b496815b147147cc31c02845e09f575f3251b045e68cb65b6778a9";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-libcue" = fetch {
    name        = "mingw-w64-i686-libcue";
    version     = "2.2.1";
    filename    = "mingw-w64-i686-libcue-2.2.1-1-any.pkg.tar.xz";
    sha256      = "9a7c0aacf7c12c84ab7cd2bfa3ea5e6df30602d01bc80895ec5204f4746432a0";
  };

  "mingw-w64-i686-libdatrie" = fetch {
    name        = "mingw-w64-i686-libdatrie";
    version     = "0.2.12";
    filename    = "mingw-w64-i686-libdatrie-0.2.12-1-any.pkg.tar.xz";
    sha256      = "059e047a9b9a9f6023bf5723edbe3efe5ba2994515cb4c91af89e10002ef8ad1";
    buildInputs = [ mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-libdca" = fetch {
    name        = "mingw-w64-i686-libdca";
    version     = "0.0.6";
    filename    = "mingw-w64-i686-libdca-0.0.6-1-any.pkg.tar.xz";
    sha256      = "5da9dddbcc95e0bf13010eeff0cdc8b70e101f83252e6aac5c54e434da935cf6";
  };

  "mingw-w64-i686-libdiscid" = fetch {
    name        = "mingw-w64-i686-libdiscid";
    version     = "0.6.2";
    filename    = "mingw-w64-i686-libdiscid-0.6.2-1-any.pkg.tar.xz";
    sha256      = "7572a06a524c9adbcd2df668cdda6d191013dc3f22b55b1cfdf786e167bf0fd0";
  };

  "mingw-w64-i686-libdsm" = fetch {
    name        = "mingw-w64-i686-libdsm";
    version     = "0.3.0";
    filename    = "mingw-w64-i686-libdsm-0.3.0-1-any.pkg.tar.xz";
    sha256      = "0867315d431e42b0956918ec7fb1c5d258976b168dee0ee5ff9ab8ac10e6c0a6";
    buildInputs = [ mingw-w64-i686-libtasn1 ];
  };

  "mingw-w64-i686-libdvbpsi" = fetch {
    name        = "mingw-w64-i686-libdvbpsi";
    version     = "1.3.2";
    filename    = "mingw-w64-i686-libdvbpsi-1.3.2-1-any.pkg.tar.xz";
    sha256      = "b59a3a1ef0e7341d1f3bacf85a795ea3ccaf0b45366b4f358356b0af3d87073f";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libdvdcss" = fetch {
    name        = "mingw-w64-i686-libdvdcss";
    version     = "1.4.2";
    filename    = "mingw-w64-i686-libdvdcss-1.4.2-1-any.pkg.tar.xz";
    sha256      = "aaa6459a08267e925da9b521f90c2c6f35c328a30a71b42e152b0d90e3e4690b";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libdvdnav" = fetch {
    name        = "mingw-w64-i686-libdvdnav";
    version     = "6.0.0";
    filename    = "mingw-w64-i686-libdvdnav-6.0.0-1-any.pkg.tar.xz";
    sha256      = "68fe0caaba9b611862123dc9047037ab0ecf36840b98a26c7c19ce6581e24f47";
    buildInputs = [ mingw-w64-i686-libdvdread ];
  };

  "mingw-w64-i686-libdvdread" = fetch {
    name        = "mingw-w64-i686-libdvdread";
    version     = "6.0.0";
    filename    = "mingw-w64-i686-libdvdread-6.0.0-1-any.pkg.tar.xz";
    sha256      = "5fed5ebfe7534bb416a81c17bda06fd1bf98c35918ca9aac3978d29e0a197829";
    buildInputs = [ mingw-w64-i686-libdvdcss ];
  };

  "mingw-w64-i686-libebml" = fetch {
    name        = "mingw-w64-i686-libebml";
    version     = "1.3.6";
    filename    = "mingw-w64-i686-libebml-1.3.6-1-any.pkg.tar.xz";
    sha256      = "9416c81fb501f6827e8ac6be4bcaf6adfa80822a74f56037ef0740326397bbbd";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libelf" = fetch {
    name        = "mingw-w64-i686-libelf";
    version     = "0.8.13";
    filename    = "mingw-w64-i686-libelf-0.8.13-4-any.pkg.tar.xz";
    sha256      = "a7bdd1876f445d6fa22e44d1402b7247c42c254525c01336f0ce683f5c8ad610";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libepoxy" = fetch {
    name        = "mingw-w64-i686-libepoxy";
    version     = "1.5.3";
    filename    = "mingw-w64-i686-libepoxy-1.5.3-1-any.pkg.tar.xz";
    sha256      = "b3fdbb83241044385cc3d0b4d9f57a4ff852231e6468f1240e8fd67ada3d954a";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libevent" = fetch {
    name        = "mingw-w64-i686-libevent";
    version     = "2.1.8";
    filename    = "mingw-w64-i686-libevent-2.1.8-1-any.pkg.tar.xz";
    sha256      = "3d3a3657aae3db878bd5ab4c606ad5f834d5e3445c40cd307e082eedfcd53331";
  };

  "mingw-w64-i686-libexif" = fetch {
    name        = "mingw-w64-i686-libexif";
    version     = "0.6.21";
    filename    = "mingw-w64-i686-libexif-0.6.21-4-any.pkg.tar.xz";
    sha256      = "084920fa665385c19337fdca407375b346ded30e2a9413b1ae3cc41e20a67270";
    buildInputs = [ mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-libffi" = fetch {
    name        = "mingw-w64-i686-libffi";
    version     = "3.2.1";
    filename    = "mingw-w64-i686-libffi-3.2.1-4-any.pkg.tar.xz";
    sha256      = "d690987f8aff2cb5db45f3963c839be6c80f091fe966782115cf82be4b82ec91";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libfilezilla" = fetch {
    name        = "mingw-w64-i686-libfilezilla";
    version     = "0.15.1";
    filename    = "mingw-w64-i686-libfilezilla-0.15.1-1-any.pkg.tar.xz";
    sha256      = "54a4f12365d8f48fea4f524bf649beb8b0da274fe29f4261a5a12a0ff41c1fd3";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-nettle ];
  };

  "mingw-w64-i686-libfreexl" = fetch {
    name        = "mingw-w64-i686-libfreexl";
    version     = "1.0.5";
    filename    = "mingw-w64-i686-libfreexl-1.0.5-1-any.pkg.tar.xz";
    sha256      = "23482d5ccb42ce1d4cccb7e8519f0dc16088eabb9021ea1489677ba554d7e152";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libftdi" = fetch {
    name        = "mingw-w64-i686-libftdi";
    version     = "1.4";
    filename    = "mingw-w64-i686-libftdi-1.4-2-any.pkg.tar.xz";
    sha256      = "6657fc479bdae91e310723b890ca361bd5ce5d9bb0f46091f44f1204f72d9d3c";
    buildInputs = [ mingw-w64-i686-libusb mingw-w64-i686-confuse mingw-w64-i686-gettext mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-libgadu" = fetch {
    name        = "mingw-w64-i686-libgadu";
    version     = "1.12.2";
    filename    = "mingw-w64-i686-libgadu-1.12.2-1-any.pkg.tar.xz";
    sha256      = "23c30c8b842054a721057907f2cbcaee4bc02986e244b8ed977cac9d82a666bc";
    buildInputs = [ mingw-w64-i686-gnutls mingw-w64-i686-protobuf-c ];
  };

  "mingw-w64-i686-libgcrypt" = fetch {
    name        = "mingw-w64-i686-libgcrypt";
    version     = "1.8.4";
    filename    = "mingw-w64-i686-libgcrypt-1.8.4-1-any.pkg.tar.xz";
    sha256      = "a1e036bb80f9ea9efaae550a9833d14261ed3058f408b5cff9a031495120074b";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libgpg-error ];
  };

  "mingw-w64-i686-libgd" = fetch {
    name        = "mingw-w64-i686-libgd";
    version     = "2.2.5";
    filename    = "mingw-w64-i686-libgd-2.2.5-1-any.pkg.tar.xz";
    sha256      = "4bb6c42b8f89a7539d585115b52613d2e66d91ad2674d4ac1c599af4d5019eca";
    buildInputs = [ mingw-w64-i686-libpng mingw-w64-i686-libiconv mingw-w64-i686-libjpeg mingw-w64-i686-libtiff mingw-w64-i686-freetype mingw-w64-i686-fontconfig mingw-w64-i686-libimagequant mingw-w64-i686-libwebp mingw-w64-i686-xpm-nox mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-libgd -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-libgda" = fetch {
    name        = "mingw-w64-i686-libgda";
    version     = "5.2.4";
    filename    = "mingw-w64-i686-libgda-5.2.4-1-any.pkg.tar.xz";
    sha256      = "4d1d88d778c5823aafa05e7da19a43a4dd27dec6d8c4731d57f451c80269944a";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-gtksourceview3 mingw-w64-i686-goocanvas mingw-w64-i686-iso-codes mingw-w64-i686-json-glib mingw-w64-i686-libsoup mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-glade ];
  };

  "mingw-w64-i686-libgdata" = fetch {
    name        = "mingw-w64-i686-libgdata";
    version     = "0.17.9";
    filename    = "mingw-w64-i686-libgdata-0.17.9-1-any.pkg.tar.xz";
    sha256      = "d0baba61b7be3c9dad14563ca84963086b1484706a820fdb3d4023735be57705";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gtk3 mingw-w64-i686-gdk-pixbuf2 mingw-w64-i686-json-glib mingw-w64-i686-liboauth mingw-w64-i686-libsoup mingw-w64-i686-libxml2 mingw-w64-i686-uhttpmock ];
  };

  "mingw-w64-i686-libgdiplus" = fetch {
    name        = "mingw-w64-i686-libgdiplus";
    version     = "5.6";
    filename    = "mingw-w64-i686-libgdiplus-5.6-1-any.pkg.tar.xz";
    sha256      = "278fb5a37c0c58852dc8577fbbf1a098bf8b3f72d3bb14c8c89db7a874bafbfc";
    buildInputs = [ mingw-w64-i686-libtiff mingw-w64-i686-cairo mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-giflib mingw-w64-i686-glib2 mingw-w64-i686-libexif mingw-w64-i686-libpng mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libgee" = fetch {
    name        = "mingw-w64-i686-libgee";
    version     = "0.20.1";
    filename    = "mingw-w64-i686-libgee-0.20.1-1-any.pkg.tar.xz";
    sha256      = "ce29c169cd12e1c876185ee3593e960bf7a8ed331d3e29682f1baddb239a6615";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-libgeotiff" = fetch {
    name        = "mingw-w64-i686-libgeotiff";
    version     = "1.4.3";
    filename    = "mingw-w64-i686-libgeotiff-1.4.3-1-any.pkg.tar.xz";
    sha256      = "b73bc5130ab5d836fb5324711ab1fbf0e04c26558334791be8c71d36df7f0ca5";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libtiff mingw-w64-i686-libjpeg mingw-w64-i686-proj mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-libgeotiff -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-libgit2" = fetch {
    name        = "mingw-w64-i686-libgit2";
    version     = "0.27.7";
    filename    = "mingw-w64-i686-libgit2-0.27.7-1-any.pkg.tar.xz";
    sha256      = "88646187dcd8c1eba631d142076b9e7df75992d58df31cd32b11bbae620f8a8b";
    buildInputs = [ mingw-w64-i686-curl mingw-w64-i686-http-parser mingw-w64-i686-libssh2 mingw-w64-i686-openssl mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libgit2-glib" = fetch {
    name        = "mingw-w64-i686-libgit2-glib";
    version     = "0.27.7";
    filename    = "mingw-w64-i686-libgit2-glib-0.27.7-1-any.pkg.tar.xz";
    sha256      = "15abdc35633f291c175392403f2d3afea8c86984a9a30f933d48760bddeefd2a";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-libgit2.version "0.23"; mingw-w64-i686-libgit2) mingw-w64-i686-libssh2 mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-libglade" = fetch {
    name        = "mingw-w64-i686-libglade";
    version     = "2.6.4";
    filename    = "mingw-w64-i686-libglade-2.6.4-5-any.pkg.tar.xz";
    sha256      = "0bc64775c9da63a5778724fdd80e78aa0efabc6b9d5dfe42ecfe9de7c566869f";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-gtk2.version "2.16.0"; mingw-w64-i686-gtk2) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-libxml2.version "2.7.3"; mingw-w64-i686-libxml2) ];
  };

  "mingw-w64-i686-libgme" = fetch {
    name        = "mingw-w64-i686-libgme";
    version     = "0.6.2";
    filename    = "mingw-w64-i686-libgme-0.6.2-1-any.pkg.tar.xz";
    sha256      = "2aeb2b38c505393916aa3d41d3dee1a310af9bfb85dff5e3f447cd03e5cae89a";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libgnomecanvas" = fetch {
    name        = "mingw-w64-i686-libgnomecanvas";
    version     = "2.30.3";
    filename    = "mingw-w64-i686-libgnomecanvas-2.30.3-3-any.pkg.tar.xz";
    sha256      = "f9627cc3e435f113575932afa27a784dc99d1e370dfd3be68bb1d682ce3efced";
    buildInputs = [ mingw-w64-i686-gtk2 mingw-w64-i686-gettext mingw-w64-i686-libart_lgpl mingw-w64-i686-libglade ];
  };

  "mingw-w64-i686-libgoom2" = fetch {
    name        = "mingw-w64-i686-libgoom2";
    version     = "2k4";
    filename    = "mingw-w64-i686-libgoom2-2k4-3-any.pkg.tar.xz";
    sha256      = "6a2aa8cbf1ee5f1f195bca8fa788e85482bc467b1f49a1195f7f71b931a39299";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libgpg-error" = fetch {
    name        = "mingw-w64-i686-libgpg-error";
    version     = "1.33";
    filename    = "mingw-w64-i686-libgpg-error-1.33-1-any.pkg.tar.xz";
    sha256      = "f1169c1aa82fe568788eb20cab98b29a1c78529d762c9b58e98bd8fae168cb10";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-libgphoto2" = fetch {
    name        = "mingw-w64-i686-libgphoto2";
    version     = "2.5.21";
    filename    = "mingw-w64-i686-libgphoto2-2.5.21-1-any.pkg.tar.xz";
    sha256      = "3a3cebeebc5bde289c916eb9e097100810120d785e65695acc9bb7bd38e3133c";
    buildInputs = [ mingw-w64-i686-libsystre mingw-w64-i686-libjpeg mingw-w64-i686-libxml2 mingw-w64-i686-libgd mingw-w64-i686-libexif mingw-w64-i686-libusb ];
    broken      = true; # broken dependency mingw-w64-i686-libgphoto2 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-libgsf" = fetch {
    name        = "mingw-w64-i686-libgsf";
    version     = "1.14.45";
    filename    = "mingw-w64-i686-libgsf-1.14.45-1-any.pkg.tar.xz";
    sha256      = "162b2dabe247db237aa1b23037332b2c6f8bc93c900000a04e8019f201ae8095";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gdk-pixbuf2 mingw-w64-i686-libxml2 mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libguess" = fetch {
    name        = "mingw-w64-i686-libguess";
    version     = "1.2";
    filename    = "mingw-w64-i686-libguess-1.2-3-any.pkg.tar.xz";
    sha256      = "a289467fa311deba5f363a26a20a615101884eb88d2442dd7ac0fc490a45f22b";
    buildInputs = [ mingw-w64-i686-libmowgli ];
  };

  "mingw-w64-i686-libgusb" = fetch {
    name        = "mingw-w64-i686-libgusb";
    version     = "0.2.11";
    filename    = "mingw-w64-i686-libgusb-0.2.11-1-any.pkg.tar.xz";
    sha256      = "8289db3e82239ae8ab93a279ccc0a2fbfef87cb5454fced27f058b9053f06b75";
    buildInputs = [ mingw-w64-i686-libusb mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-libgweather" = fetch {
    name        = "mingw-w64-i686-libgweather";
    version     = "3.28.2";
    filename    = "mingw-w64-i686-libgweather-3.28.2-1-any.pkg.tar.xz";
    sha256      = "51749602a6be32f365b0449cf7bdd2905231b3f593d79c49c60bb23f034449bd";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-libsoup mingw-w64-i686-libsystre mingw-w64-i686-libxml2 mingw-w64-i686-geocode-glib ];
  };

  "mingw-w64-i686-libgxps" = fetch {
    name        = "mingw-w64-i686-libgxps";
    version     = "0.3.1";
    filename    = "mingw-w64-i686-libgxps-0.3.1-1-any.pkg.tar.xz";
    sha256      = "ad733c0627719cb63c290651d03dbc722885be5591ae49053715725076c4dead";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gtk3 mingw-w64-i686-cairo mingw-w64-i686-lcms2 mingw-w64-i686-libarchive mingw-w64-i686-libjpeg mingw-w64-i686-libxslt mingw-w64-i686-libpng ];
    broken      = true; # broken dependency mingw-w64-i686-libgxps -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-libharu" = fetch {
    name        = "mingw-w64-i686-libharu";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-libharu-2.3.0-2-any.pkg.tar.xz";
    sha256      = "ae6a4182e460f663a205440136699370197ef4556cee33523ee511bf95b5d734";
    buildInputs = [ mingw-w64-i686-libpng ];
  };

  "mingw-w64-i686-libical" = fetch {
    name        = "mingw-w64-i686-libical";
    version     = "3.0.4";
    filename    = "mingw-w64-i686-libical-3.0.4-1-any.pkg.tar.xz";
    sha256      = "d0f6977e88661041d6fd8e3d40fc504c80b0e5b003b31aa7164d723a006c891c";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-icu mingw-w64-i686-glib2 mingw-w64-i686-gobject-introspection mingw-w64-i686-libxml2 mingw-w64-i686-db ];
  };

  "mingw-w64-i686-libiconv" = fetch {
    name        = "mingw-w64-i686-libiconv";
    version     = "1.15";
    filename    = "mingw-w64-i686-libiconv-1.15-3-any.pkg.tar.xz";
    sha256      = "a8e73e531344cd3a699cc70f5e98ad24f7a6416b77847ad14956102e5f53d1e9";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libidl2" = fetch {
    name        = "mingw-w64-i686-libidl2";
    version     = "0.8.14";
    filename    = "mingw-w64-i686-libidl2-0.8.14-1-any.pkg.tar.xz";
    sha256      = "fcb98c60fe41d202a98e4dfb3ea725edb4ae49d20d1422781e9548f0c4105e31";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-libidn" = fetch {
    name        = "mingw-w64-i686-libidn";
    version     = "1.35";
    filename    = "mingw-w64-i686-libidn-1.35-1-any.pkg.tar.xz";
    sha256      = "05db89998887bea39fe85716670cc0eca3d7a2a914a0fd0c702edd4e8667376a";
    buildInputs = [ mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-libidn2" = fetch {
    name        = "mingw-w64-i686-libidn2";
    version     = "2.1.0";
    filename    = "mingw-w64-i686-libidn2-2.1.0-1-any.pkg.tar.xz";
    sha256      = "5dffc707e83d065c8ccd7aa98390c48de2f734fe113c4bee34c20b85b60c4df0";
    buildInputs = [ mingw-w64-i686-gettext mingw-w64-i686-libunistring ];
  };

  "mingw-w64-i686-libilbc" = fetch {
    name        = "mingw-w64-i686-libilbc";
    version     = "2.0.2";
    filename    = "mingw-w64-i686-libilbc-2.0.2-1-any.pkg.tar.xz";
    sha256      = "9c448f259edf1cae1db449efbbf2a9ed90b4161300341c57cc327bca30cc991b";
  };

  "mingw-w64-i686-libimagequant" = fetch {
    name        = "mingw-w64-i686-libimagequant";
    version     = "2.12.2";
    filename    = "mingw-w64-i686-libimagequant-2.12.2-1-any.pkg.tar.xz";
    sha256      = "e5c5c0e0b1b03a59be9e582a1c31ad3b3015d33148dc3fcd64d3e8ee1c58886e";
  };

  "mingw-w64-i686-libimobiledevice" = fetch {
    name        = "mingw-w64-i686-libimobiledevice";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-libimobiledevice-1.2.0-1-any.pkg.tar.xz";
    sha256      = "2d3443795bfc23a2c795640b34d9fa3b9b1f0e5ed4e3ff1e3d71430770687939";
    buildInputs = [ mingw-w64-i686-libusbmuxd mingw-w64-i686-libplist mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-libjpeg-turbo" = fetch {
    name        = "mingw-w64-i686-libjpeg-turbo";
    version     = "2.0.1";
    filename    = "mingw-w64-i686-libjpeg-turbo-2.0.1-1-any.pkg.tar.xz";
    sha256      = "db32b9d1f52c97b7cab452d959bf6559948e814644c887e48b0ed4690403272f";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libkml" = fetch {
    name        = "mingw-w64-i686-libkml";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-libkml-1.3.0-5-any.pkg.tar.xz";
    sha256      = "2626c08fa523dc0a3a6096b7707535b1376e97b60981da0bc18a03174c204e4a";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-minizip mingw-w64-i686-uriparser mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-libkml -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-libksba" = fetch {
    name        = "mingw-w64-i686-libksba";
    version     = "1.3.5";
    filename    = "mingw-w64-i686-libksba-1.3.5-1-any.pkg.tar.xz";
    sha256      = "22aba63244eb4acfb97748bd0d76318b3c180823fe9160c1c793095decb5ee3f";
    buildInputs = [ mingw-w64-i686-libgpg-error ];
  };

  "mingw-w64-i686-liblas" = fetch {
    name        = "mingw-w64-i686-liblas";
    version     = "1.8.1";
    filename    = "mingw-w64-i686-liblas-1.8.1-1-any.pkg.tar.xz";
    sha256      = "476ad7968f49fed1e96ef5d3bbca93f970deb8a894ad9a269393fd2b483ceaf6";
    buildInputs = [ mingw-w64-i686-gdal mingw-w64-i686-laszip ];
    broken      = true; # broken dependency mingw-w64-i686-libgeotiff -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-liblastfm" = fetch {
    name        = "mingw-w64-i686-liblastfm";
    version     = "1.0.9";
    filename    = "mingw-w64-i686-liblastfm-1.0.9-2-any.pkg.tar.xz";
    sha256      = "08cefaa608316ac7f77301114be950e7fdbfed91f07d9e78326838553fae8cd3";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-fftw mingw-w64-i686-libsamplerate ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-liblastfm-qt4" = fetch {
    name        = "mingw-w64-i686-liblastfm-qt4";
    version     = "1.0.9";
    filename    = "mingw-w64-i686-liblastfm-qt4-1.0.9-1-any.pkg.tar.xz";
    sha256      = "2e378890cf50eded33edb4a2189a2c8b4874fc7feb316e116735849f8c42254b";
    buildInputs = [ mingw-w64-i686-qt4 mingw-w64-i686-fftw mingw-w64-i686-libsamplerate ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-liblqr" = fetch {
    name        = "mingw-w64-i686-liblqr";
    version     = "0.4.2";
    filename    = "mingw-w64-i686-liblqr-0.4.2-4-any.pkg.tar.xz";
    sha256      = "080a3650b88e743430baab0548f267ed3738986e7b5a455212f59c79599279ce";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-libmad" = fetch {
    name        = "mingw-w64-i686-libmad";
    version     = "0.15.1b";
    filename    = "mingw-w64-i686-libmad-0.15.1b-4-any.pkg.tar.xz";
    sha256      = "172c51cabb87e762454f0b1573984bbf743eee659e8e37d6e73b5f57081fdda8";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libmangle-git" = fetch {
    name        = "mingw-w64-i686-libmangle-git";
    version     = "7.0.0.5230.69c8fad6";
    filename    = "mingw-w64-i686-libmangle-git-7.0.0.5230.69c8fad6-1-any.pkg.tar.xz";
    sha256      = "38fb3eeac014b16166f9b596755c56b9b86db2fcaba72e8b49ae0b8da7b3b00e";
  };

  "mingw-w64-i686-libmariadbclient" = fetch {
    name        = "mingw-w64-i686-libmariadbclient";
    version     = "2.3.7";
    filename    = "mingw-w64-i686-libmariadbclient-2.3.7-1-any.pkg.tar.xz";
    sha256      = "6c2e94d3cddf7cc3d5250653456b2f44c4cce2f24fdd179bcfa8f2a1304f5e6c";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-openssl mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libmatroska" = fetch {
    name        = "mingw-w64-i686-libmatroska";
    version     = "1.4.9";
    filename    = "mingw-w64-i686-libmatroska-1.4.9-2-any.pkg.tar.xz";
    sha256      = "f1c1a7b5a870d1cf38f833eb9a751b40e81e448394c42a89902d74352c00e94a";
    buildInputs = [ mingw-w64-i686-libebml ];
  };

  "mingw-w64-i686-libmaxminddb" = fetch {
    name        = "mingw-w64-i686-libmaxminddb";
    version     = "1.3.2";
    filename    = "mingw-w64-i686-libmaxminddb-1.3.2-1-any.pkg.tar.xz";
    sha256      = "7db4133f04d2cf286b66c33e9fd776d6f44b0e1251d4970497246a387e6eb35a";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-geoip2-database ];
  };

  "mingw-w64-i686-libmetalink" = fetch {
    name        = "mingw-w64-i686-libmetalink";
    version     = "0.1.3";
    filename    = "mingw-w64-i686-libmetalink-0.1.3-3-any.pkg.tar.xz";
    sha256      = "6abbb39400f04f8c90cbd6b366a15df7228ddda7c9430314968e2d9118bd14ba";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-expat ];
  };

  "mingw-w64-i686-libmfx" = fetch {
    name        = "mingw-w64-i686-libmfx";
    version     = "1.25";
    filename    = "mingw-w64-i686-libmfx-1.25-1-any.pkg.tar.xz";
    sha256      = "6c1727331b72c4dd778401d47e854ab12966dd18c39ad938fbdd8692ad079b52";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libmicrodns" = fetch {
    name        = "mingw-w64-i686-libmicrodns";
    version     = "0.0.10";
    filename    = "mingw-w64-i686-libmicrodns-0.0.10-1-any.pkg.tar.xz";
    sha256      = "7328b4783d4cc827edebac39279e622b3033e0e4491ac90fd99e415685501a3c";
    buildInputs = [ mingw-w64-i686-libtasn1 ];
  };

  "mingw-w64-i686-libmicrohttpd" = fetch {
    name        = "mingw-w64-i686-libmicrohttpd";
    version     = "0.9.62";
    filename    = "mingw-w64-i686-libmicrohttpd-0.9.62-1-any.pkg.tar.xz";
    sha256      = "3ca114e146debb3591ed00a27014da2ea491aed9edbe32064e1a52b05655ce89";
    buildInputs = [ mingw-w64-i686-gnutls ];
  };

  "mingw-w64-i686-libmicroutils" = fetch {
    name        = "mingw-w64-i686-libmicroutils";
    version     = "4.3.0";
    filename    = "mingw-w64-i686-libmicroutils-4.3.0-1-any.pkg.tar.xz";
    sha256      = "fa146f157b4cf85164bcfc8ca9ae1695562f51cd47d6d17746bbd8e7aef49800";
    buildInputs = [ mingw-w64-i686-libsystre ];
  };

  "mingw-w64-i686-libmikmod" = fetch {
    name        = "mingw-w64-i686-libmikmod";
    version     = "3.3.11.1";
    filename    = "mingw-w64-i686-libmikmod-3.3.11.1-1-any.pkg.tar.xz";
    sha256      = "19ea219ca201cea5c51bb64dba37080b0f88ce4853a1830d7c6fdce20c4f6ffa";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-openal ];
  };

  "mingw-w64-i686-libmimic" = fetch {
    name        = "mingw-w64-i686-libmimic";
    version     = "1.0.4";
    filename    = "mingw-w64-i686-libmimic-1.0.4-3-any.pkg.tar.xz";
    sha256      = "c9605e2b87bf834264bf71073ea684c288d77e967a6b6c031dac5c24928d1c96";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-libmng" = fetch {
    name        = "mingw-w64-i686-libmng";
    version     = "2.0.3";
    filename    = "mingw-w64-i686-libmng-2.0.3-4-any.pkg.tar.xz";
    sha256      = "77056da7beeae784c46d92f0425da9bbef3a12fe9333c58d567e78696cb1817b";
    buildInputs = [ mingw-w64-i686-libjpeg-turbo mingw-w64-i686-lcms2 mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libmodbus-git" = fetch {
    name        = "mingw-w64-i686-libmodbus-git";
    version     = "658.0e2f470";
    filename    = "mingw-w64-i686-libmodbus-git-658.0e2f470-1-any.pkg.tar.xz";
    sha256      = "3977f5f5817950ada9341adb2ceb4d214978370bda19155cbe5b362601324051";
  };

  "mingw-w64-i686-libmodplug" = fetch {
    name        = "mingw-w64-i686-libmodplug";
    version     = "0.8.9.0";
    filename    = "mingw-w64-i686-libmodplug-0.8.9.0-1-any.pkg.tar.xz";
    sha256      = "0d9f118056139340c2b1dbc9ba44ac95631172608cc92dd3360a90741bc0aaf4";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libmongoose" = fetch {
    name        = "mingw-w64-i686-libmongoose";
    version     = "6.4";
    filename    = "mingw-w64-i686-libmongoose-6.4-1-any.pkg.tar.xz";
    sha256      = "b819d785fc857735b01deb96499a588d9995a95dcde99558ec77d9472891473e";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libmongoose-git" = fetch {
    name        = "mingw-w64-i686-libmongoose-git";
    version     = "r1793.41b405d";
    filename    = "mingw-w64-i686-libmongoose-git-r1793.41b405d-3-any.pkg.tar.xz";
    sha256      = "94dd7f4bcf48b138383896c49cf643896d7485f4d5ca3d07dd42b2d5607bf37a";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libmowgli" = fetch {
    name        = "mingw-w64-i686-libmowgli";
    version     = "2.1.3";
    filename    = "mingw-w64-i686-libmowgli-2.1.3-3-any.pkg.tar.xz";
    sha256      = "93b089caca7782c639c67e061a25c2614923cbb3abd4f25c3564a92781f6dd57";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libmpack" = fetch {
    name        = "mingw-w64-i686-libmpack";
    version     = "1.0.5";
    filename    = "mingw-w64-i686-libmpack-1.0.5-1-any.pkg.tar.xz";
    sha256      = "f7fabbe9a67f9133290084d279576c85d3de9e9be8e77047cc37a2b246d83738";
  };

  "mingw-w64-i686-libmpcdec" = fetch {
    name        = "mingw-w64-i686-libmpcdec";
    version     = "1.2.6";
    filename    = "mingw-w64-i686-libmpcdec-1.2.6-3-any.pkg.tar.xz";
    sha256      = "8032ff97fd278deaa5cb712b7f5d1e7b265848ab78438e7792bd59caac377db3";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libmpeg2-git" = fetch {
    name        = "mingw-w64-i686-libmpeg2-git";
    version     = "r1108.946bf4b";
    filename    = "mingw-w64-i686-libmpeg2-git-r1108.946bf4b-1-any.pkg.tar.xz";
    sha256      = "b57c4cd284f316ce691335d21551c7900a2e1139029ce402ef452c03facbbcd2";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libmypaint" = fetch {
    name        = "mingw-w64-i686-libmypaint";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-libmypaint-1.3.0-4-any.pkg.tar.xz";
    sha256      = "3fd0174a31ad54d332533ecbbce75ac9253383baf40cc4d25783bf736ec84aed";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-glib2 mingw-w64-i686-json-c ];
  };

  "mingw-w64-i686-libmysofa" = fetch {
    name        = "mingw-w64-i686-libmysofa";
    version     = "0.6";
    filename    = "mingw-w64-i686-libmysofa-0.6-1-any.pkg.tar.xz";
    sha256      = "bb402cb23c6f7bfe5385d137ead44514de66709cfc41b9317a71a483acc64b55";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libnfs" = fetch {
    name        = "mingw-w64-i686-libnfs";
    version     = "3.0.0";
    filename    = "mingw-w64-i686-libnfs-3.0.0-1-any.pkg.tar.xz";
    sha256      = "2c1d1b12a061f6252d45eaa53cadaa07e309c18f44693161fc2c2cefc3172b5c";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libnice" = fetch {
    name        = "mingw-w64-i686-libnice";
    version     = "0.1.14";
    filename    = "mingw-w64-i686-libnice-0.1.14-1-any.pkg.tar.xz";
    sha256      = "c9fd3c0b2de5aa497e44c792eebf7a49ea05f555721714a1895694c4545a9879";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-libnotify" = fetch {
    name        = "mingw-w64-i686-libnotify";
    version     = "0.7.7";
    filename    = "mingw-w64-i686-libnotify-0.7.7-1-any.pkg.tar.xz";
    sha256      = "e4d42f74ce2f7ae9afcb865815137a2b18d5970f1f10317739703498fe8e1dcc";
    buildInputs = [ mingw-w64-i686-gdk-pixbuf2 ];
  };

  "mingw-w64-i686-libnova" = fetch {
    name        = "mingw-w64-i686-libnova";
    version     = "0.15.0";
    filename    = "mingw-w64-i686-libnova-0.15.0-1-any.pkg.tar.xz";
    sha256      = "4c46157bad4cffbfee94f7cc173f31bc40364df49571d99b8738ae2d21a4f392";
  };

  "mingw-w64-i686-libntlm" = fetch {
    name        = "mingw-w64-i686-libntlm";
    version     = "1.5";
    filename    = "mingw-w64-i686-libntlm-1.5-1-any.pkg.tar.xz";
    sha256      = "5b74084b45bac8dc2ffc856e2e717355b5a2b2a4805468a21e5809dffd54f983";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libnumbertext" = fetch {
    name        = "mingw-w64-i686-libnumbertext";
    version     = "1.0.5";
    filename    = "mingw-w64-i686-libnumbertext-1.0.5-1-any.pkg.tar.xz";
    sha256      = "ff6c42b4d8c3d014aade7cb587465f7460b62c16e1f044815555b3fbc8d8b7e8";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-liboauth" = fetch {
    name        = "mingw-w64-i686-liboauth";
    version     = "1.0.3";
    filename    = "mingw-w64-i686-liboauth-1.0.3-6-any.pkg.tar.xz";
    sha256      = "6f1ca63318b18e286a6cbf3d71ebbe739abca3a8ebe17ac2aca52f21bd41c9ce";
    buildInputs = [ mingw-w64-i686-curl mingw-w64-i686-nss ];
  };

  "mingw-w64-i686-libodfgen" = fetch {
    name        = "mingw-w64-i686-libodfgen";
    version     = "0.1.7";
    filename    = "mingw-w64-i686-libodfgen-0.1.7-1-any.pkg.tar.xz";
    sha256      = "6d07baedcaec60648ba27a98c7dcee928f9577d013e9c4f5fd47ded804cfad2d";
    buildInputs = [ mingw-w64-i686-librevenge ];
  };

  "mingw-w64-i686-libogg" = fetch {
    name        = "mingw-w64-i686-libogg";
    version     = "1.3.3";
    filename    = "mingw-w64-i686-libogg-1.3.3-1-any.pkg.tar.xz";
    sha256      = "81cf98d0d5fa5faa1af3fb514e6ff77f98d52ebe6035ac9b7aaad5fccfb3d752";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libopusenc" = fetch {
    name        = "mingw-w64-i686-libopusenc";
    version     = "0.2.1";
    filename    = "mingw-w64-i686-libopusenc-0.2.1-1-any.pkg.tar.xz";
    sha256      = "00cade8b795e547e9a4abd2c922023416286acf2ec7f73788cbc8e2c5d7f360b";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-opus ];
  };

  "mingw-w64-i686-libosmpbf-git" = fetch {
    name        = "mingw-w64-i686-libosmpbf-git";
    version     = "1.3.3.13.g4edb4f0";
    filename    = "mingw-w64-i686-libosmpbf-git-1.3.3.13.g4edb4f0-1-any.pkg.tar.xz";
    sha256      = "e309fa2f2875a95da870ab3284f0cbf4b82f29df2b6c1f3fcbd43f13e5d9671c";
    buildInputs = [ mingw-w64-i686-protobuf ];
  };

  "mingw-w64-i686-libotr" = fetch {
    name        = "mingw-w64-i686-libotr";
    version     = "4.1.1";
    filename    = "mingw-w64-i686-libotr-4.1.1-2-any.pkg.tar.xz";
    sha256      = "a0a1e844eb74c80eaedd280c97c76ac24e3b4ad9795e3c96e6f78dfd4ac1f281";
    buildInputs = [ mingw-w64-i686-libgcrypt ];
  };

  "mingw-w64-i686-libpaper" = fetch {
    name        = "mingw-w64-i686-libpaper";
    version     = "1.1.24";
    filename    = "mingw-w64-i686-libpaper-1.1.24-2-any.pkg.tar.xz";
    sha256      = "34a2d6eff048e327619f3fa7308756916d754cdaf523b73328e4ef34f0501b64";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libpeas" = fetch {
    name        = "mingw-w64-i686-libpeas";
    version     = "1.22.0";
    filename    = "mingw-w64-i686-libpeas-1.22.0-3-any.pkg.tar.xz";
    sha256      = "321651328989c766da6a36a24ef1740cf1dfdf2297f5feedc5fec6f60732eaa5";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gtk3 mingw-w64-i686-adwaita-icon-theme ];
  };

  "mingw-w64-i686-libplacebo" = fetch {
    name        = "mingw-w64-i686-libplacebo";
    version     = "1.7.0";
    filename    = "mingw-w64-i686-libplacebo-1.7.0-1-any.pkg.tar.xz";
    sha256      = "aab6502ee6e6b6a035866a67097f1a74446ab4675b4913aa5a99bc84ec4933bd";
    buildInputs = [ mingw-w64-i686-vulkan ];
    broken      = true; # broken dependency mingw-w64-i686-libplacebo -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-libplist" = fetch {
    name        = "mingw-w64-i686-libplist";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-libplist-2.0.0-3-any.pkg.tar.xz";
    sha256      = "cdc289a0a5a6debd449eb612af6f07d2e3739a28c7cad77f1b8923280aaa8298";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-cython ];
  };

  "mingw-w64-i686-libpng" = fetch {
    name        = "mingw-w64-i686-libpng";
    version     = "1.6.36";
    filename    = "mingw-w64-i686-libpng-1.6.36-1-any.pkg.tar.xz";
    sha256      = "74bbdbbfb90ecf886c254a45cf6f1896876d898749c945134cbe29ae76450f9f";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libproxy" = fetch {
    name        = "mingw-w64-i686-libproxy";
    version     = "0.4.15";
    filename    = "mingw-w64-i686-libproxy-0.4.15-2-any.pkg.tar.xz";
    sha256      = "8b509849d083579f12506a22d948c6cdc8794d5425554ccfa6ee428b418a3949";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libpsl" = fetch {
    name        = "mingw-w64-i686-libpsl";
    version     = "0.20.2";
    filename    = "mingw-w64-i686-libpsl-0.20.2-2-any.pkg.tar.xz";
    sha256      = "e34afb562b306355adacb21261a50d7ddd1393beb04c83d0504ab9fb2f41562a";
    buildInputs = [ mingw-w64-i686-libidn2 mingw-w64-i686-libunistring mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-libraqm" = fetch {
    name        = "mingw-w64-i686-libraqm";
    version     = "0.5.0";
    filename    = "mingw-w64-i686-libraqm-0.5.0-1-any.pkg.tar.xz";
    sha256      = "589a56cc85072d0faa4e4f37e7cd67c17e2baf73046ff6ff6f829f718de53485";
    buildInputs = [ mingw-w64-i686-freetype mingw-w64-i686-glib2 mingw-w64-i686-harfbuzz mingw-w64-i686-fribidi ];
  };

  "mingw-w64-i686-libraw" = fetch {
    name        = "mingw-w64-i686-libraw";
    version     = "0.19.2";
    filename    = "mingw-w64-i686-libraw-0.19.2-1-any.pkg.tar.xz";
    sha256      = "85573b2dd234862ee2f04faced0be6ee66ee9e8b5be7fdb45761499368f49cd7";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-lcms2 mingw-w64-i686-jasper ];
  };

  "mingw-w64-i686-librescl" = fetch {
    name        = "mingw-w64-i686-librescl";
    version     = "0.3.3";
    filename    = "mingw-w64-i686-librescl-0.3.3-1-any.pkg.tar.xz";
    sha256      = "347c5cfd4d5dd1183e68495999804bd62e7170bc39287684ca26522aebad107c";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-glib2.version "2.34.0"; mingw-w64-i686-glib2) mingw-w64-i686-gobject-introspection mingw-w64-i686-gxml mingw-w64-i686-libgee mingw-w64-i686-libxml2 mingw-w64-i686-vala mingw-w64-i686-xz mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-libgd -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-libressl" = fetch {
    name        = "mingw-w64-i686-libressl";
    version     = "2.8.2";
    filename    = "mingw-w64-i686-libressl-2.8.2-1-any.pkg.tar.xz";
    sha256      = "ca1b7e4d8c25094a12f0931934d6345a38882f6c024e3267f52d93f99832c3cd";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-librest" = fetch {
    name        = "mingw-w64-i686-librest";
    version     = "0.8.1";
    filename    = "mingw-w64-i686-librest-0.8.1-1-any.pkg.tar.xz";
    sha256      = "d33bdb734d52d267433c772efba166c7b23a6d94406889f65108d3ebf930bf3c";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-libsoup mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-librevenge" = fetch {
    name        = "mingw-w64-i686-librevenge";
    version     = "0.0.4";
    filename    = "mingw-w64-i686-librevenge-0.0.4-2-any.pkg.tar.xz";
    sha256      = "3508a3f5c6bd53476983fd66075e2b859da4cfb93020c67f7f8eae037eada5dd";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-boost mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-librsvg" = fetch {
    name        = "mingw-w64-i686-librsvg";
    version     = "2.40.20";
    filename    = "mingw-w64-i686-librsvg-2.40.20-1-any.pkg.tar.xz";
    sha256      = "4e8fed09db19acbc22fba15b816c1915bf86b0b58dc17f34b09fa694daf72fc4";
    buildInputs = [ mingw-w64-i686-gdk-pixbuf2 mingw-w64-i686-pango mingw-w64-i686-libcroco ];
  };

  "mingw-w64-i686-librsync" = fetch {
    name        = "mingw-w64-i686-librsync";
    version     = "2.0.2";
    filename    = "mingw-w64-i686-librsync-2.0.2-1-any.pkg.tar.xz";
    sha256      = "7104cbd13508316ddc4f40ab68bbb4f726711b92e848aa6d1ccc86b128260016";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-popt ];
  };

  "mingw-w64-i686-libsamplerate" = fetch {
    name        = "mingw-w64-i686-libsamplerate";
    version     = "0.1.9";
    filename    = "mingw-w64-i686-libsamplerate-0.1.9-1-any.pkg.tar.xz";
    sha256      = "173b951f1ebed1ab5b99500d33913e2f43819a164d386cc894a00b2b43152137";
    buildInputs = [ mingw-w64-i686-libsndfile mingw-w64-i686-fftw ];
  };

  "mingw-w64-i686-libsass" = fetch {
    name        = "mingw-w64-i686-libsass";
    version     = "3.5.5";
    filename    = "mingw-w64-i686-libsass-3.5.5-1-any.pkg.tar.xz";
    sha256      = "aa420c5e3b60fc8176c71ebbb378d3df07b138b18ed34352c7b62eb282e28d99";
  };

  "mingw-w64-i686-libsbml" = fetch {
    name        = "mingw-w64-i686-libsbml";
    version     = "5.17.0";
    filename    = "mingw-w64-i686-libsbml-5.17.0-1-any.pkg.tar.xz";
    sha256      = "e1cace4341e9a93e5aaaecd6cffacfbf71bb51bd9aa050e7fb5a82bb7ad1bd00";
    buildInputs = [ mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-libsecret" = fetch {
    name        = "mingw-w64-i686-libsecret";
    version     = "0.18";
    filename    = "mingw-w64-i686-libsecret-0.18-5-any.pkg.tar.xz";
    sha256      = "21320479ed3307de4717d07ce58754d7f8050078d8831ed07d86514d68df6d26";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-glib2 mingw-w64-i686-libgcrypt ];
  };

  "mingw-w64-i686-libshout" = fetch {
    name        = "mingw-w64-i686-libshout";
    version     = "2.4.1";
    filename    = "mingw-w64-i686-libshout-2.4.1-2-any.pkg.tar.xz";
    sha256      = "99fb058bcb8c3fe9a351d4c274cbae621396c1d57aac53b9d58c7ceb69733921";
    buildInputs = [ mingw-w64-i686-libvorbis mingw-w64-i686-libtheora mingw-w64-i686-openssl mingw-w64-i686-speex ];
  };

  "mingw-w64-i686-libsigc++" = fetch {
    name        = "mingw-w64-i686-libsigc++";
    version     = "2.10.1";
    filename    = "mingw-w64-i686-libsigc++-2.10.1-1-any.pkg.tar.xz";
    sha256      = "739358e9edebe1a6d34aa6debac663efac774f211b06b083876505fa9ac8dfc4";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libsigc++3" = fetch {
    name        = "mingw-w64-i686-libsigc++3";
    version     = "2.99.11";
    filename    = "mingw-w64-i686-libsigc++3-2.99.11-1-any.pkg.tar.xz";
    sha256      = "cc8d64402f12367f3b57f24b4f3c85af8904207736b26da949ceb86dc75deacf";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libsignal-protocol-c-git" = fetch {
    name        = "mingw-w64-i686-libsignal-protocol-c-git";
    version     = "r34.16bfd04";
    filename    = "mingw-w64-i686-libsignal-protocol-c-git-r34.16bfd04-1-any.pkg.tar.xz";
    sha256      = "fa17aa734fdc03e4b9a6fa89c2b76da55fb4a46728a99ca90f1ac9ecc5083702";
  };

  "mingw-w64-i686-libsigsegv" = fetch {
    name        = "mingw-w64-i686-libsigsegv";
    version     = "2.12";
    filename    = "mingw-w64-i686-libsigsegv-2.12-1-any.pkg.tar.xz";
    sha256      = "d84885c2020d7a4ac66be912196cb2a244e7e27c1b48b9258954d5fbd29a03b7";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libsndfile" = fetch {
    name        = "mingw-w64-i686-libsndfile";
    version     = "1.0.28";
    filename    = "mingw-w64-i686-libsndfile-1.0.28-1-any.pkg.tar.xz";
    sha256      = "a4b40652a12e30e8ef41ed9fa12f6c2baa7b0e3794e07aacf2bf29df05250db7";
    buildInputs = [ mingw-w64-i686-flac mingw-w64-i686-libvorbis mingw-w64-i686-speex ];
  };

  "mingw-w64-i686-libsodium" = fetch {
    name        = "mingw-w64-i686-libsodium";
    version     = "1.0.17";
    filename    = "mingw-w64-i686-libsodium-1.0.17-1-any.pkg.tar.xz";
    sha256      = "784c7128e66ea926916d9dce36450b284ac3462984317b4c2ea704615108935a";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libsoup" = fetch {
    name        = "mingw-w64-i686-libsoup";
    version     = "2.64.2";
    filename    = "mingw-w64-i686-libsoup-2.64.2-1-any.pkg.tar.xz";
    sha256      = "758814798f0774f9e4eaccc6746638c848a822e7ac327f4fd60a67ecb2448671";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-glib2 mingw-w64-i686-glib-networking mingw-w64-i686-libxml2 mingw-w64-i686-libpsl mingw-w64-i686-sqlite3 ];
  };

  "mingw-w64-i686-libsoxr" = fetch {
    name        = "mingw-w64-i686-libsoxr";
    version     = "0.1.3";
    filename    = "mingw-w64-i686-libsoxr-0.1.3-1-any.pkg.tar.xz";
    sha256      = "57ee74d102c9089a1ba063757c37e8bc2a3de680fad2c85f85d546adc800d25a";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libspatialite" = fetch {
    name        = "mingw-w64-i686-libspatialite";
    version     = "4.3.0.a";
    filename    = "mingw-w64-i686-libspatialite-4.3.0.a-3-any.pkg.tar.xz";
    sha256      = "f52d7dbf195708e6d7cc51f848f1668e441b1d67aa0142816b711281211286c4";
    buildInputs = [ mingw-w64-i686-geos mingw-w64-i686-libfreexl mingw-w64-i686-libxml2 mingw-w64-i686-proj mingw-w64-i686-sqlite3 mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-libspectre" = fetch {
    name        = "mingw-w64-i686-libspectre";
    version     = "0.2.8";
    filename    = "mingw-w64-i686-libspectre-0.2.8-2-any.pkg.tar.xz";
    sha256      = "a0f0ad5bbce7198e7433582f806ffa1d293095f17927680a1952a222df40846f";
    buildInputs = [ mingw-w64-i686-ghostscript mingw-w64-i686-cairo ];
    broken      = true; # broken dependency mingw-w64-i686-ghostscript -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-libspiro" = fetch {
    name        = "mingw-w64-i686-libspiro";
    version     = "1~0.5.20150702";
    filename    = "mingw-w64-i686-libspiro-1~0.5.20150702-2-any.pkg.tar.xz";
    sha256      = "c6b0a3b351e10abf86617768f12cb3f06efb43ef98f9253062a828bc8707df0b";
  };

  "mingw-w64-i686-libsquish" = fetch {
    name        = "mingw-w64-i686-libsquish";
    version     = "1.15";
    filename    = "mingw-w64-i686-libsquish-1.15-1-any.pkg.tar.xz";
    sha256      = "36232d849895fa9c5cb04d5ddc2bf7ce422ae33f4fc542b1c99d8fed8d2ae27c";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libsrtp" = fetch {
    name        = "mingw-w64-i686-libsrtp";
    version     = "2.2.0";
    filename    = "mingw-w64-i686-libsrtp-2.2.0-2-any.pkg.tar.xz";
    sha256      = "1631f7e8d002b5d97e98caebb87a7dc7a8448316e957d2556c12d16a740bd85c";
    buildInputs = [ mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-libssh" = fetch {
    name        = "mingw-w64-i686-libssh";
    version     = "0.8.6";
    filename    = "mingw-w64-i686-libssh-0.8.6-1-any.pkg.tar.xz";
    sha256      = "f8f2c02f7b710e48a11eee1d11fc903072a35cc5638e6e9e56f42079f2ebdb14";
    buildInputs = [ mingw-w64-i686-openssl mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libssh2" = fetch {
    name        = "mingw-w64-i686-libssh2";
    version     = "1.8.0";
    filename    = "mingw-w64-i686-libssh2-1.8.0-3-any.pkg.tar.xz";
    sha256      = "237b40d5f8530750832ef25c7f6df35f4c26b6217e188419fcab4dd585293571";
    buildInputs = [ mingw-w64-i686-openssl mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libswift" = fetch {
    name        = "mingw-w64-i686-libswift";
    version     = "1.0.0";
    filename    = "mingw-w64-i686-libswift-1.0.0-2-any.pkg.tar.xz";
    sha256      = "0aa6a4d19fc4a674c948d17e19f57e96d37611dc5621c7971fc51f37ab7a185b";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-bzip2 mingw-w64-i686-libiconv mingw-w64-i686-libpng mingw-w64-i686-freetype mingw-w64-i686-glfw mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libsystre" = fetch {
    name        = "mingw-w64-i686-libsystre";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-libsystre-1.0.1-4-any.pkg.tar.xz";
    sha256      = "3a400210f7f366c63d000d910203257643b4de1409d09d12da86e76acb4dd407";
    buildInputs = [ mingw-w64-i686-libtre-git ];
  };

  "mingw-w64-i686-libtasn1" = fetch {
    name        = "mingw-w64-i686-libtasn1";
    version     = "4.13";
    filename    = "mingw-w64-i686-libtasn1-4.13-1-any.pkg.tar.xz";
    sha256      = "f94133b4feae54f1787f0454dfb3f654730ac465d4f9de88a73a27481e3c893b";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libthai" = fetch {
    name        = "mingw-w64-i686-libthai";
    version     = "0.1.28";
    filename    = "mingw-w64-i686-libthai-0.1.28-2-any.pkg.tar.xz";
    sha256      = "9ca5ce1b9eed1be47273623df8da6e7cb27eb321d328b27e32b5962c8c3ec285";
    buildInputs = [ mingw-w64-i686-libdatrie ];
  };

  "mingw-w64-i686-libtheora" = fetch {
    name        = "mingw-w64-i686-libtheora";
    version     = "1.1.1";
    filename    = "mingw-w64-i686-libtheora-1.1.1-4-any.pkg.tar.xz";
    sha256      = "17fd504e293820cbb44e7553d53603fc5e3519e235f00505831b1a090ab984f4";
    buildInputs = [ mingw-w64-i686-libpng mingw-w64-i686-libogg mingw-w64-i686-libvorbis ];
  };

  "mingw-w64-i686-libtiff" = fetch {
    name        = "mingw-w64-i686-libtiff";
    version     = "4.0.10";
    filename    = "mingw-w64-i686-libtiff-4.0.10-1-any.pkg.tar.xz";
    sha256      = "3600dcc53d7a53e5f8f6444027c74770cc3d018afef433cd61fb33879dbdb651";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libjpeg-turbo mingw-w64-i686-xz mingw-w64-i686-zlib mingw-w64-i686-zstd ];
  };

  "mingw-w64-i686-libtimidity" = fetch {
    name        = "mingw-w64-i686-libtimidity";
    version     = "0.2.6";
    filename    = "mingw-w64-i686-libtimidity-0.2.6-1-any.pkg.tar.xz";
    sha256      = "ce6de1d406715e26310ce342a60b946158dd73e6377e84ac30110111050402f0";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libtommath" = fetch {
    name        = "mingw-w64-i686-libtommath";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-libtommath-1.0.1-1-any.pkg.tar.xz";
    sha256      = "5b12b13ab95fceb977d2b319c911c7fa3fcb2224126fa6ea0f3584e7981d5200";
  };

  "mingw-w64-i686-libtool" = fetch {
    name        = "mingw-w64-i686-libtool";
    version     = "2.4.6";
    filename    = "mingw-w64-i686-libtool-2.4.6-13-any.pkg.tar.xz";
    sha256      = "3cd1f869d26aff2b4aa9114995070a624a4323ebcfb55e50cedf079cfc2c344f";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libtorrent-rasterbar" = fetch {
    name        = "mingw-w64-i686-libtorrent-rasterbar";
    version     = "1.1.11";
    filename    = "mingw-w64-i686-libtorrent-rasterbar-1.1.11-2-any.pkg.tar.xz";
    sha256      = "3959a4c1257254d81ffd02e546084d44a8ad3ce55bcc8dc5ac80b62888bc0f61";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-libtre-git" = fetch {
    name        = "mingw-w64-i686-libtre-git";
    version     = "r128.6fb7206";
    filename    = "mingw-w64-i686-libtre-git-r128.6fb7206-2-any.pkg.tar.xz";
    sha256      = "cc8ec470688c20d7b6da4ccc5dbaa275edb20242a058041b3b62a1b795ab8048";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-libunistring" = fetch {
    name        = "mingw-w64-i686-libunistring";
    version     = "0.9.10";
    filename    = "mingw-w64-i686-libunistring-0.9.10-1-any.pkg.tar.xz";
    sha256      = "d0fc32b0453932376650b5bf2a0f3fd7c6679096cfc5711ace918c8edca473ec";
    buildInputs = [ mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-libunwind" = fetch {
    name        = "mingw-w64-i686-libunwind";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-libunwind-7.0.1-1-any.pkg.tar.xz";
    sha256      = "e93393187e8e3260805588c47408b8ad8ef2dd3dfc446722744ad6ae36330cc3";
    buildInputs = [ mingw-w64-i686-gcc ];
  };

  "mingw-w64-i686-libusb" = fetch {
    name        = "mingw-w64-i686-libusb";
    version     = "1.0.22";
    filename    = "mingw-w64-i686-libusb-1.0.22-1-any.pkg.tar.xz";
    sha256      = "488e57dd5893de780cde5216fcb25d690f148ffeb034caa622d8fd49608c3ea2";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libusb-compat-git" = fetch {
    name        = "mingw-w64-i686-libusb-compat-git";
    version     = "r72.92deb38";
    filename    = "mingw-w64-i686-libusb-compat-git-r72.92deb38-1-any.pkg.tar.xz";
    sha256      = "e096c802b5d4fd79595c4d94f32b13a4d1765e642d48bd11350c8fa2d748441e";
    buildInputs = [ mingw-w64-i686-libusb ];
  };

  "mingw-w64-i686-libusbmuxd" = fetch {
    name        = "mingw-w64-i686-libusbmuxd";
    version     = "1.0.10";
    filename    = "mingw-w64-i686-libusbmuxd-1.0.10-3-any.pkg.tar.xz";
    sha256      = "42abff0b8bf893763da35009ccdb0075a5c3b78acad362825a6d0aa503baf699";
    buildInputs = [ mingw-w64-i686-libplist ];
  };

  "mingw-w64-i686-libuv" = fetch {
    name        = "mingw-w64-i686-libuv";
    version     = "1.24.1";
    filename    = "mingw-w64-i686-libuv-1.24.1-1-any.pkg.tar.xz";
    sha256      = "08bae4da0de03ba9d9711a0e83e9bff73b883bafc6f1c7618355aefb7c85433d";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libview" = fetch {
    name        = "mingw-w64-i686-libview";
    version     = "0.6.6";
    filename    = "mingw-w64-i686-libview-0.6.6-4-any.pkg.tar.xz";
    sha256      = "0de7b3f1b77bf2ef42ef6790fa59299ef0753f1582f08896a54afbd72e2792ce";
    buildInputs = [ mingw-w64-i686-gtk2 mingw-w64-i686-gtkmm ];
  };

  "mingw-w64-i686-libvirt" = fetch {
    name        = "mingw-w64-i686-libvirt";
    version     = "4.7.0";
    filename    = "mingw-w64-i686-libvirt-4.7.0-1-any.pkg.tar.xz";
    sha256      = "705add15bcd541545e0d5e2c6f53fb5e09d5eaab0d691aa35dbceb9ea7ba3d4a";
    buildInputs = [ mingw-w64-i686-curl mingw-w64-i686-gnutls mingw-w64-i686-gettext mingw-w64-i686-libgcrypt mingw-w64-i686-libgpg-error mingw-w64-i686-libxml2 mingw-w64-i686-portablexdr mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-libvirt-glib" = fetch {
    name        = "mingw-w64-i686-libvirt-glib";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-libvirt-glib-2.0.0-1-any.pkg.tar.xz";
    sha256      = "36f879d9c449b41d3b92ffa9d3ddb12167a6abdcac53d28d80bcccd812f66ba4";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-libxml2 mingw-w64-i686-libvirt ];
  };

  "mingw-w64-i686-libvisio" = fetch {
    name        = "mingw-w64-i686-libvisio";
    version     = "0.1.6";
    filename    = "mingw-w64-i686-libvisio-0.1.6-3-any.pkg.tar.xz";
    sha256      = "13775ffeeabba5abcc299f11dbf1c508df40cae556eab385ec9f82036752b80e";
    buildInputs = [ mingw-w64-i686-icu mingw-w64-i686-libxml2 mingw-w64-i686-librevenge ];
  };

  "mingw-w64-i686-libvmime-git" = fetch {
    name        = "mingw-w64-i686-libvmime-git";
    version     = "r1129.a9b8221";
    filename    = "mingw-w64-i686-libvmime-git-r1129.a9b8221-1-any.pkg.tar.xz";
    sha256      = "64421b2a8ca4a99edd48c40f33eddb28fdb075325946a529cc78788e1e00cd55";
    buildInputs = [ mingw-w64-i686-icu mingw-w64-i686-gnutls mingw-w64-i686-gsasl mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-libvncserver" = fetch {
    name        = "mingw-w64-i686-libvncserver";
    version     = "0.9.11";
    filename    = "mingw-w64-i686-libvncserver-0.9.11-2-any.pkg.tar.xz";
    sha256      = "90bae61a938dd987c80bad079917f59acd29177e348d1b7fbb55a362c7aae662";
    buildInputs = [ mingw-w64-i686-libpng mingw-w64-i686-libjpeg mingw-w64-i686-gnutls mingw-w64-i686-libgcrypt mingw-w64-i686-openssl mingw-w64-i686-gcc-libs ];
    broken      = true; # broken dependency mingw-w64-i686-libvncserver -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-libvoikko" = fetch {
    name        = "mingw-w64-i686-libvoikko";
    version     = "4.2";
    filename    = "mingw-w64-i686-libvoikko-4.2-1-any.pkg.tar.xz";
    sha256      = "16e5ffcf0ab2f95d04d2ef0c98294ab178a976a877a0cf9c47ab470940dd4e97";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libvorbis" = fetch {
    name        = "mingw-w64-i686-libvorbis";
    version     = "1.3.6";
    filename    = "mingw-w64-i686-libvorbis-1.3.6-1-any.pkg.tar.xz";
    sha256      = "9c0812f95cca372128f0754dd4f5f5eb5e4c677622635be9f8c4cb8b2e5eea02";
    buildInputs = [ mingw-w64-i686-libogg mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-libvorbisidec-svn" = fetch {
    name        = "mingw-w64-i686-libvorbisidec-svn";
    version     = "r19643";
    filename    = "mingw-w64-i686-libvorbisidec-svn-r19643-1-any.pkg.tar.xz";
    sha256      = "b53d7cbe5f94ae2588441156e6fbe9b974df484cb0f63d6653cd46e0b3be600f";
    buildInputs = [ mingw-w64-i686-libogg ];
  };

  "mingw-w64-i686-libvpx" = fetch {
    name        = "mingw-w64-i686-libvpx";
    version     = "1.7.0";
    filename    = "mingw-w64-i686-libvpx-1.7.0-1-any.pkg.tar.xz";
    sha256      = "677b8332833d0dc81a11881eda2ca59ad683198ae03add9a6a21af808f926a50";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libwebp" = fetch {
    name        = "mingw-w64-i686-libwebp";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-libwebp-1.0.1-1-any.pkg.tar.xz";
    sha256      = "7fa17a5904830d0a45bacf99630196043df53dca75a2d7e6432c86052fb9eabe";
    buildInputs = [ mingw-w64-i686-giflib mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libpng mingw-w64-i686-libtiff ];
  };

  "mingw-w64-i686-libwebsockets" = fetch {
    name        = "mingw-w64-i686-libwebsockets";
    version     = "3.1.0";
    filename    = "mingw-w64-i686-libwebsockets-3.1.0-1-any.pkg.tar.xz";
    sha256      = "4df96fa06369c817532932320ee0993c2e35f37c0edd83d280d106a867fcedfc";
    buildInputs = [ mingw-w64-i686-zlib mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-libwinpthread-git" = fetch {
    name        = "mingw-w64-i686-libwinpthread-git";
    version     = "7.0.0.5273.3e5acf5d";
    filename    = "mingw-w64-i686-libwinpthread-git-7.0.0.5273.3e5acf5d-1-any.pkg.tar.xz";
    sha256      = "41258dfa01288605865c9a8b9d011d330ae51d25c77d910224939b69b987b64d";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libwmf" = fetch {
    name        = "mingw-w64-i686-libwmf";
    version     = "0.2.10";
    filename    = "mingw-w64-i686-libwmf-0.2.10-1-any.pkg.tar.xz";
    sha256      = "6c21125aeee48125aebc65fa99d6770655ce7cf9569f1f90d35776cc605b7cac";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-freetype mingw-w64-i686-gdk-pixbuf2 mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libxml2 mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-libwmf -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-libwpd" = fetch {
    name        = "mingw-w64-i686-libwpd";
    version     = "0.10.2";
    filename    = "mingw-w64-i686-libwpd-0.10.2-1-any.pkg.tar.xz";
    sha256      = "8bb009f3428cc0454da448d738a9179459b0c567572faded98c8a24bf783a2fc";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-librevenge mingw-w64-i686-xz mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libwpg" = fetch {
    name        = "mingw-w64-i686-libwpg";
    version     = "0.3.2";
    filename    = "mingw-w64-i686-libwpg-0.3.2-1-any.pkg.tar.xz";
    sha256      = "ddc3467774f5eac1edb32fd8c99807c409140755adabaa40de762a4d550d1111";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-librevenge mingw-w64-i686-libwpd ];
  };

  "mingw-w64-i686-libxlsxwriter" = fetch {
    name        = "mingw-w64-i686-libxlsxwriter";
    version     = "0.8.4";
    filename    = "mingw-w64-i686-libxlsxwriter-0.8.4-1-any.pkg.tar.xz";
    sha256      = "3fb59e42fbfecb32116bc499c51f9f5be6af26275920eb7ae7dfc25fd3707a05";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libxml++" = fetch {
    name        = "mingw-w64-i686-libxml++";
    version     = "3.0.1";
    filename    = "mingw-w64-i686-libxml++-3.0.1-1-any.pkg.tar.xz";
    sha256      = "7ef325e5c451ce42815483f725ca7e04b4465d836ce7e6c881fca047c382f2c7";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libxml2 mingw-w64-i686-glibmm ];
  };

  "mingw-w64-i686-libxml++2.6" = fetch {
    name        = "mingw-w64-i686-libxml++2.6";
    version     = "2.40.1";
    filename    = "mingw-w64-i686-libxml++2.6-2.40.1-1-any.pkg.tar.xz";
    sha256      = "ec3551fe190deb5629b7569906494853e8b30b2cf9da839ce2ad43791ffa8253";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libxml2 mingw-w64-i686-glibmm ];
  };

  "mingw-w64-i686-libxml2" = fetch {
    name        = "mingw-w64-i686-libxml2";
    version     = "2.9.8";
    filename    = "mingw-w64-i686-libxml2-2.9.8-1-any.pkg.tar.xz";
    sha256      = "21f9a09c6f0a87941e122e2428edc9e56e7d0159b29c27ef78b7b5803c8db525";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext mingw-w64-i686-xz mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-libxslt" = fetch {
    name        = "mingw-w64-i686-libxslt";
    version     = "1.1.33";
    filename    = "mingw-w64-i686-libxslt-1.1.33-1-any.pkg.tar.xz";
    sha256      = "d583cd3b360c71b41c02cb226f15e95e9d5d6e6eacfe68d7861b119646cf287d";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libxml2 mingw-w64-i686-libgcrypt ];
  };

  "mingw-w64-i686-libyaml" = fetch {
    name        = "mingw-w64-i686-libyaml";
    version     = "0.2.1";
    filename    = "mingw-w64-i686-libyaml-0.2.1-1-any.pkg.tar.xz";
    sha256      = "0865f1fea0ec97501085c4746d95c8b336e59dd0cb0d5f821b5481c2788b166f";
    buildInputs = [  ];
  };

  "mingw-w64-i686-libzip" = fetch {
    name        = "mingw-w64-i686-libzip";
    version     = "1.5.1";
    filename    = "mingw-w64-i686-libzip-1.5.1-1-any.pkg.tar.xz";
    sha256      = "a6581f853129182ca3a53bf2ae269763d497d4860b98ca1c03d90141111857d4";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-gnutls mingw-w64-i686-nettle mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-live-media" = fetch {
    name        = "mingw-w64-i686-live-media";
    version     = "2018.10.17";
    filename    = "mingw-w64-i686-live-media-2018.10.17-1-any.pkg.tar.xz";
    sha256      = "705a95dd0e617fad93f6f2a525aace8755013b6646a2d449879c6188c635f17a";
    buildInputs = [ mingw-w64-i686-gcc ];
  };

  "mingw-w64-i686-lld" = fetch {
    name        = "mingw-w64-i686-lld";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-lld-7.0.1-1-any.pkg.tar.xz";
    sha256      = "e6c9f26fd645c415d5cc2e8d315a1f734a9a92cd168bcd3ed4c58361a5db1fb6";
    buildInputs = [ mingw-w64-i686-gcc ];
  };

  "mingw-w64-i686-lldb" = fetch {
    name        = "mingw-w64-i686-lldb";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-lldb-7.0.1-1-any.pkg.tar.xz";
    sha256      = "08c73ef65dc5e8fad2e0390cff0573c0b9984da3d4ef2ef6e6a3ae9bded41ee1";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-llvm mingw-w64-i686-python2 mingw-w64-i686-readline mingw-w64-i686-swig ];
  };

  "mingw-w64-i686-llvm" = fetch {
    name        = "mingw-w64-i686-llvm";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-llvm-7.0.1-1-any.pkg.tar.xz";
    sha256      = "845f9f16ba63ee92be9157f7af0d8a91603d1a847810cf0332fd566116da1923";
    buildInputs = [ mingw-w64-i686-libffi mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-lmdb" = fetch {
    name        = "mingw-w64-i686-lmdb";
    version     = "0.9.23";
    filename    = "mingw-w64-i686-lmdb-0.9.23-1-any.pkg.tar.xz";
    sha256      = "9e7e6277ad892bfb04beb4e1ce35b8b772ac775fa6a4a797419fab31580bf148";
  };

  "mingw-w64-i686-lmdbxx" = fetch {
    name        = "mingw-w64-i686-lmdbxx";
    version     = "0.9.14.0";
    filename    = "mingw-w64-i686-lmdbxx-0.9.14.0-1-any.pkg.tar.xz";
    sha256      = "0512366ec19fb39cee7c2c10b86329e7f2f8a2af7e7c0f31404a6a228d35f5e0";
    buildInputs = [ mingw-w64-i686-lmdb ];
  };

  "mingw-w64-i686-lpsolve" = fetch {
    name        = "mingw-w64-i686-lpsolve";
    version     = "5.5.2.5";
    filename    = "mingw-w64-i686-lpsolve-5.5.2.5-1-any.pkg.tar.xz";
    sha256      = "12c6348eb1c5480e7b0f8ffaac0c9dd0c24984198b5fd5a7010e90214c7891a9";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-lua" = fetch {
    name        = "mingw-w64-i686-lua";
    version     = "5.3.5";
    filename    = "mingw-w64-i686-lua-5.3.5-1-any.pkg.tar.xz";
    sha256      = "82d788d66635151fb64a695daae79b536c99c51a7e37cf96d5bf332dd5d18016";
    buildInputs = [ winpty ];
  };

  "mingw-w64-i686-lua-lpeg" = fetch {
    name        = "mingw-w64-i686-lua-lpeg";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-lua-lpeg-1.0.1-1-any.pkg.tar.xz";
    sha256      = "d3c456de4434f2d60760ddfc175cf484ce3ee7f73f0321e9e687cec7c6101893";
    buildInputs = [ mingw-w64-i686-lua ];
  };

  "mingw-w64-i686-lua-mpack" = fetch {
    name        = "mingw-w64-i686-lua-mpack";
    version     = "1.0.7";
    filename    = "mingw-w64-i686-lua-mpack-1.0.7-1-any.pkg.tar.xz";
    sha256      = "9cb2a7e92749e6a6894eb470cf89cc98998aaabbfdc1bed856656ac9779eebc2";
    buildInputs = [ mingw-w64-i686-lua mingw-w64-i686-libmpack ];
  };

  "mingw-w64-i686-lua51" = fetch {
    name        = "mingw-w64-i686-lua51";
    version     = "5.1.5";
    filename    = "mingw-w64-i686-lua51-5.1.5-4-any.pkg.tar.xz";
    sha256      = "40ff1207db193d5d987c40ea95a354296c9fd30bc03690b0419dbf1f52533fde";
    buildInputs = [ winpty ];
  };

  "mingw-w64-i686-lua51-bitop" = fetch {
    name        = "mingw-w64-i686-lua51-bitop";
    version     = "1.0.2";
    filename    = "mingw-w64-i686-lua51-bitop-1.0.2-1-any.pkg.tar.xz";
    sha256      = "fc4ce61a5cf603e2a2934b754934d701d4182d3aa3b8a627c86a11c34e6fe239";
    buildInputs = [ mingw-w64-i686-lua51 ];
  };

  "mingw-w64-i686-lua51-lgi" = fetch {
    name        = "mingw-w64-i686-lua51-lgi";
    version     = "0.9.2";
    filename    = "mingw-w64-i686-lua51-lgi-0.9.2-1-any.pkg.tar.xz";
    sha256      = "9b2f481dda6aa3b44f07313bf9b040620d7f0893254ada1d6976a26496f3cee8";
    buildInputs = [ mingw-w64-i686-lua51 mingw-w64-i686-gtk3 mingw-w64-i686-gobject-introspection ];
  };

  "mingw-w64-i686-lua51-lpeg" = fetch {
    name        = "mingw-w64-i686-lua51-lpeg";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-lua51-lpeg-1.0.1-1-any.pkg.tar.xz";
    sha256      = "aa1f7757d09a2bb72c47bf318feb855a0be20f0b3bd7ae4fe90342e80dfa277a";
    buildInputs = [ mingw-w64-i686-lua51 ];
  };

  "mingw-w64-i686-lua51-lsqlite3" = fetch {
    name        = "mingw-w64-i686-lua51-lsqlite3";
    version     = "0.9.3";
    filename    = "mingw-w64-i686-lua51-lsqlite3-0.9.3-1-any.pkg.tar.xz";
    sha256      = "e73afc881b036ef2dbe305c5071c5a9b3766af6bcc615287bfe40a287cc7f725";
    buildInputs = [ mingw-w64-i686-lua51 mingw-w64-i686-sqlite3 ];
  };

  "mingw-w64-i686-lua51-luarocks" = fetch {
    name        = "mingw-w64-i686-lua51-luarocks";
    version     = "2.4.4";
    filename    = "mingw-w64-i686-lua51-luarocks-2.4.4-1-any.pkg.tar.xz";
    sha256      = "a3bf61ddc9b053efd5b8f25883784ee17e33f48f91a6dc0c750cf96034ff4ab2";
    buildInputs = [ mingw-w64-i686-lua51 ];
  };

  "mingw-w64-i686-lua51-mpack" = fetch {
    name        = "mingw-w64-i686-lua51-mpack";
    version     = "1.0.7";
    filename    = "mingw-w64-i686-lua51-mpack-1.0.7-1-any.pkg.tar.xz";
    sha256      = "3f93ed09ecad97c229c48ae849c9a5df44f1e5f6b70799c405af067f7f5fb11a";
    buildInputs = [ mingw-w64-i686-lua51 mingw-w64-i686-libmpack ];
  };

  "mingw-w64-i686-lua51-winapi" = fetch {
    name        = "mingw-w64-i686-lua51-winapi";
    version     = "1.4.2";
    filename    = "mingw-w64-i686-lua51-winapi-1.4.2-1-any.pkg.tar.xz";
    sha256      = "9dfd4e98949ad4bd834b7d0891ef12f0e5292bcf0e28b1998c9f0dade046d772";
    buildInputs = [ mingw-w64-i686-lua51 ];
  };

  "mingw-w64-i686-luabind-git" = fetch {
    name        = "mingw-w64-i686-luabind-git";
    version     = "0.9.1.144.ge414c57";
    filename    = "mingw-w64-i686-luabind-git-0.9.1.144.ge414c57-1-any.pkg.tar.xz";
    sha256      = "f7462af4008040fc686d5b8e4a1f81ac0fd15e5608b02bf157eb23ac02d7883b";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-lua51 ];
  };

  "mingw-w64-i686-luajit-git" = fetch {
    name        = "mingw-w64-i686-luajit-git";
    version     = "2.0.4.49.ga68c411";
    filename    = "mingw-w64-i686-luajit-git-2.0.4.49.ga68c411-1-any.pkg.tar.xz";
    sha256      = "b7dc7925bf60e5446530ab4133e7957101e8de4ce2ccd845cdd20a1c22d73fbf";
    buildInputs = [ winpty ];
  };

  "mingw-w64-i686-lz4" = fetch {
    name        = "mingw-w64-i686-lz4";
    version     = "1.8.3";
    filename    = "mingw-w64-i686-lz4-1.8.3-1-any.pkg.tar.xz";
    sha256      = "0b563a8a6b47f1ea8f515da863bd6c80773f44c0b6cc3eb999d7739da50e3e6d";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-lzo2" = fetch {
    name        = "mingw-w64-i686-lzo2";
    version     = "2.10";
    filename    = "mingw-w64-i686-lzo2-2.10-1-any.pkg.tar.xz";
    sha256      = "767a867762fd70c47d60fe8b97bdc17b65b77b05efd7ef66747f496b04694498";
    buildInputs = [  ];
  };

  "mingw-w64-i686-make" = fetch {
    name        = "mingw-w64-i686-make";
    version     = "4.2.1";
    filename    = "mingw-w64-i686-make-4.2.1-2-any.pkg.tar.xz";
    sha256      = "5e789eadba35c2031e3d3abc9ab29f3fbd1ba0851dbade0350d984fa5fd3d7d2";
    buildInputs = [ mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-mathgl" = fetch {
    name        = "mingw-w64-i686-mathgl";
    version     = "2.4.2";
    filename    = "mingw-w64-i686-mathgl-2.4.2-1-any.pkg.tar.xz";
    sha256      = "5b19700f6aa934d08f975ada42e920b961f75aaa971ad613ba78dcea31d634e2";
    buildInputs = [ mingw-w64-i686-hdf5 mingw-w64-i686-fltk mingw-w64-i686-libharu mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libpng mingw-w64-i686-giflib mingw-w64-i686-qt5 mingw-w64-i686-freeglut mingw-w64-i686-wxWidgets ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-matio" = fetch {
    name        = "mingw-w64-i686-matio";
    version     = "1.5.13";
    filename    = "mingw-w64-i686-matio-1.5.13-1-any.pkg.tar.xz";
    sha256      = "af0d70927cb34af8db3b6ef1abd6ab7fa08ad7ab24e910043567c17fd1c87ab3";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib mingw-w64-i686-hdf5 ];
  };

  "mingw-w64-i686-mbedtls" = fetch {
    name        = "mingw-w64-i686-mbedtls";
    version     = "2.16.0";
    filename    = "mingw-w64-i686-mbedtls-2.16.0-1-any.pkg.tar.xz";
    sha256      = "c8f90c57f426773965e8334d6fd71cce11ea7192cd9eee247d636f74b4cc9377";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-mcpp" = fetch {
    name        = "mingw-w64-i686-mcpp";
    version     = "2.7.2";
    filename    = "mingw-w64-i686-mcpp-2.7.2-2-any.pkg.tar.xz";
    sha256      = "9392590dcd5db6dc6831aca47735d0acacb901f6a65c9a7f4fe5dfee2131b3b3";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-meanwhile" = fetch {
    name        = "mingw-w64-i686-meanwhile";
    version     = "1.0.2";
    filename    = "mingw-w64-i686-meanwhile-1.0.2-4-any.pkg.tar.xz";
    sha256      = "49dda3e64b2f584ae60a4a1b29e4214704e8791243bf2223aae1497377d78eb9";
    buildInputs = [ mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-meld3" = fetch {
    name        = "mingw-w64-i686-meld3";
    version     = "3.20.0";
    filename    = "mingw-w64-i686-meld3-3.20.0-1-any.pkg.tar.xz";
    sha256      = "5a3b946994ace5780a79d257a2ef36823b14f3970f0667e4f74e6e5d8a124f89";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-gtksourceview3 mingw-w64-i686-adwaita-icon-theme mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-python3-gobject ];
  };

  "mingw-w64-i686-memphis" = fetch {
    name        = "mingw-w64-i686-memphis";
    version     = "0.2.3";
    filename    = "mingw-w64-i686-memphis-0.2.3-4-any.pkg.tar.xz";
    sha256      = "5ad740e1d854774989d79a9333c3d3b85e0ceed1b643d40c815690e18dd56339";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-cairo mingw-w64-i686-expat ];
  };

  "mingw-w64-i686-mesa" = fetch {
    name        = "mingw-w64-i686-mesa";
    version     = "18.3.1";
    filename    = "mingw-w64-i686-mesa-18.3.1-1-any.pkg.tar.xz";
    sha256      = "95e602b12bf0da1c95b179cc8cfcd8b2df0317845cc3a11a56362fb551ef3e67";
  };

  "mingw-w64-i686-meson" = fetch {
    name        = "mingw-w64-i686-meson";
    version     = "0.49.0";
    filename    = "mingw-w64-i686-meson-0.49.0-1-any.pkg.tar.xz";
    sha256      = "4311cbc5cf119afda9d95e324a383e5740b4a5da24beda14719493ea13e77beb";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-setuptools mingw-w64-i686-ninja ];
  };

  "mingw-w64-i686-metis" = fetch {
    name        = "mingw-w64-i686-metis";
    version     = "5.1.0";
    filename    = "mingw-w64-i686-metis-5.1.0-2-any.pkg.tar.xz";
    sha256      = "82bb8af55a1118340e1958cdd6d2ae31f9a427ea499b6150d1459688017a0e51";
    buildInputs = [  ];
  };

  "mingw-w64-i686-mhook" = fetch {
    name        = "mingw-w64-i686-mhook";
    version     = "r7.a159eed";
    filename    = "mingw-w64-i686-mhook-r7.a159eed-1-any.pkg.tar.xz";
    sha256      = "860147a8a8e216ff3fee1f9afe6f285334164e8db8770bb2c95235042fdc79e9";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-minisign" = fetch {
    name        = "mingw-w64-i686-minisign";
    version     = "0.8";
    filename    = "mingw-w64-i686-minisign-0.8-1-any.pkg.tar.xz";
    sha256      = "9f4b6a801eb1a96e131831aff8d4cf8f4c979aa5da08ab4f30bf099680dc2d02";
    buildInputs = [ mingw-w64-i686-libsodium ];
  };

  "mingw-w64-i686-miniupnpc" = fetch {
    name        = "mingw-w64-i686-miniupnpc";
    version     = "2.1";
    filename    = "mingw-w64-i686-miniupnpc-2.1-2-any.pkg.tar.xz";
    sha256      = "d26b7addce20fd364d20c16c9a2f5fd707ba8fd0a4692b944e0c9f69a5abffbe";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-minizip2" = fetch {
    name        = "mingw-w64-i686-minizip2";
    version     = "2.7.0";
    filename    = "mingw-w64-i686-minizip2-2.7.0-1-any.pkg.tar.xz";
    sha256      = "0fa32c42b7672dd1f58f43215382854e5fc813d0175ad3135dd42066bbe09144";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-mlpack" = fetch {
    name        = "mingw-w64-i686-mlpack";
    version     = "1.0.12";
    filename    = "mingw-w64-i686-mlpack-1.0.12-2-any.pkg.tar.xz";
    sha256      = "782615ac87eb0280b5d6bf4b0aed79d69112e68d86e027897f40b5ec7763aa59";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-armadillo mingw-w64-i686-boost mingw-w64-i686-libxml2 ];
  };

  "mingw-w64-i686-mono" = fetch {
    name        = "mingw-w64-i686-mono";
    version     = "5.4.1.7";
    filename    = "mingw-w64-i686-mono-5.4.1.7-2-any.pkg.tar.xz";
    sha256      = "9768b94c6fee4a0e77935e28ac6a42e61082e78dc97a04b8e77c724fa5d35567";
    buildInputs = [ mingw-w64-i686-zlib mingw-w64-i686-gcc-libs mingw-w64-i686-winpthreads-git mingw-w64-i686-libgdiplus mingw-w64-i686-python3 mingw-w64-i686-ca-certificates ];
  };

  "mingw-w64-i686-mono-basic" = fetch {
    name        = "mingw-w64-i686-mono-basic";
    version     = "4.6";
    filename    = "mingw-w64-i686-mono-basic-4.6-1-any.pkg.tar.xz";
    sha256      = "45b30e2fb33ca4d3ef07146943fa185df457dd7121189ce628fe4cc1c37c10d8";
    buildInputs = [ mingw-w64-i686-mono ];
  };

  "mingw-w64-i686-mpc" = fetch {
    name        = "mingw-w64-i686-mpc";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-mpc-1.1.0-1-any.pkg.tar.xz";
    sha256      = "599a0276820e3d342d1c494c4506aaf79fbbbc2843bbec7aae5f22a1b71da284";
    buildInputs = [ mingw-w64-i686-mpfr ];
  };

  "mingw-w64-i686-mpdecimal" = fetch {
    name        = "mingw-w64-i686-mpdecimal";
    version     = "2.4.2";
    filename    = "mingw-w64-i686-mpdecimal-2.4.2-1-any.pkg.tar.xz";
    sha256      = "5c1c64552a680b6e222751a732b724e62de5ee7b511190e81b2dd252c64807df";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-mpfr" = fetch {
    name        = "mingw-w64-i686-mpfr";
    version     = "4.0.1";
    filename    = "mingw-w64-i686-mpfr-4.0.1-2-any.pkg.tar.xz";
    sha256      = "c5ac46f3df381a38e60909fedbb86f6d79d20675f50b4e11f73e872bde197f75";
    buildInputs = [ mingw-w64-i686-gmp ];
  };

  "mingw-w64-i686-mpg123" = fetch {
    name        = "mingw-w64-i686-mpg123";
    version     = "1.25.10";
    filename    = "mingw-w64-i686-mpg123-1.25.10-1-any.pkg.tar.xz";
    sha256      = "e2f32f85f9196151955c1317359988fdf54735b1874fa4e64e556c8906fb8e90";
    buildInputs = [ mingw-w64-i686-libtool mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-mpv" = fetch {
    name        = "mingw-w64-i686-mpv";
    version     = "0.29.1";
    filename    = "mingw-w64-i686-mpv-0.29.1-1-any.pkg.tar.xz";
    sha256      = "840c8a555830a1710e44905ecadf5f3dfdf1bd19c3f0921703599a51e55e2cea";
    buildInputs = [ mingw-w64-i686-angleproject-git mingw-w64-i686-ffmpeg mingw-w64-i686-lcms2 mingw-w64-i686-libarchive mingw-w64-i686-libass mingw-w64-i686-libbluray mingw-w64-i686-libcaca mingw-w64-i686-libcdio mingw-w64-i686-libcdio-paranoia mingw-w64-i686-libdvdnav mingw-w64-i686-libdvdread mingw-w64-i686-libjpeg-turbo mingw-w64-i686-lua51 mingw-w64-i686-rubberband mingw-w64-i686-uchardet mingw-w64-i686-vapoursynth mingw-w64-i686-vulkan winpty ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-mruby" = fetch {
    name        = "mingw-w64-i686-mruby";
    version     = "1.4.1";
    filename    = "mingw-w64-i686-mruby-1.4.1-1-any.pkg.tar.xz";
    sha256      = "e1fa683984d026df14b2f7e7b64d91ad4a3f0cef03f11468b371bca92e319f4c";
  };

  "mingw-w64-i686-mscgen" = fetch {
    name        = "mingw-w64-i686-mscgen";
    version     = "0.20";
    filename    = "mingw-w64-i686-mscgen-0.20-1-any.pkg.tar.xz";
    sha256      = "b87275ec63764e103fe61d808f7a71338b51bdda4c77039cee2c6739ee9f3ed0";
    buildInputs = [ mingw-w64-i686-libgd ];
    broken      = true; # broken dependency mingw-w64-i686-libgd -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-msgpack-c" = fetch {
    name        = "mingw-w64-i686-msgpack-c";
    version     = "3.1.1";
    filename    = "mingw-w64-i686-msgpack-c-3.1.1-1-any.pkg.tar.xz";
    sha256      = "9ede9e3da0d5fc54d707a6857a3cd18cbe530f2b5ac4fd7ee8a3802fb02dfb42";
  };

  "mingw-w64-i686-msmtp" = fetch {
    name        = "mingw-w64-i686-msmtp";
    version     = "1.8.1";
    filename    = "mingw-w64-i686-msmtp-1.8.1-1-any.pkg.tar.xz";
    sha256      = "f926056a229ae629c6f0e541edaf66f36a8c11d1a2f7667d6dd7aa7556b7234d";
    buildInputs = [ mingw-w64-i686-gettext mingw-w64-i686-gnutls mingw-w64-i686-gsasl mingw-w64-i686-libffi mingw-w64-i686-libidn mingw-w64-i686-libwinpthread-git ];
  };

  "mingw-w64-i686-mtex2MML" = fetch {
    name        = "mingw-w64-i686-mtex2MML";
    version     = "1.3.1";
    filename    = "mingw-w64-i686-mtex2MML-1.3.1-1-any.pkg.tar.xz";
    sha256      = "ece38a8de2a2f3482c52394933281ac8cfb23cc7f66f73c7a7ef9ed8943cc707";
  };

  "mingw-w64-i686-muparser" = fetch {
    name        = "mingw-w64-i686-muparser";
    version     = "2.2.6";
    filename    = "mingw-w64-i686-muparser-2.2.6-1-any.pkg.tar.xz";
    sha256      = "45330bf898f0f59980e8e885cc0ab34be8bdc0e7fb112452a9742045d8d6c06f";
  };

  "mingw-w64-i686-mypaint" = fetch {
    name        = "mingw-w64-i686-mypaint";
    version     = "1.2.1";
    filename    = "mingw-w64-i686-mypaint-1.2.1-1-any.pkg.tar.xz";
    sha256      = "ab01d7d9a4990a73c56e9e83676e02c680ba70ea4837c0608448b8d4de988f7e";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-python2-numpy mingw-w64-i686-json-c mingw-w64-i686-lcms2 mingw-w64-i686-python2-cairo mingw-w64-i686-python2-gobject mingw-w64-i686-adwaita-icon-theme mingw-w64-i686-librsvg mingw-w64-i686-gcc-libs mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-hicolor-icon-theme ];
  };

  "mingw-w64-i686-mypaint-brushes" = fetch {
    name        = "mingw-w64-i686-mypaint-brushes";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-mypaint-brushes-1.3.0-1-any.pkg.tar.xz";
    sha256      = "f2aef651fb442e768ac1cdb664ce5a1f95bbe2b1dc8b5e89fa432199c467e919";
    buildInputs = [ mingw-w64-i686-libmypaint ];
  };

  "mingw-w64-i686-mypaint-brushes2" = fetch {
    name        = "mingw-w64-i686-mypaint-brushes2";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-mypaint-brushes2-2.0.0-1-any.pkg.tar.xz";
    sha256      = "29748bfaed1e2f858872bfb86722b4ab4e9f65b2e25ed2353429fb35c62a94db";
  };

  "mingw-w64-i686-nanodbc" = fetch {
    name        = "mingw-w64-i686-nanodbc";
    version     = "2.12.4";
    filename    = "mingw-w64-i686-nanodbc-2.12.4-2-any.pkg.tar.xz";
    sha256      = "5046e4b99438d4fea34b7f2aeb7d57083ec83bd55e8a9575198eec9e1da0bea3";
  };

  "mingw-w64-i686-nanovg-git" = fetch {
    name        = "mingw-w64-i686-nanovg-git";
    version     = "r259.6ae0873";
    filename    = "mingw-w64-i686-nanovg-git-r259.6ae0873-1-any.pkg.tar.xz";
    sha256      = "3e3a9c1bb742531cb17f36a0ae76d0eb657af0eef2b4811894c632c92f83ea7f";
  };

  "mingw-w64-i686-nasm" = fetch {
    name        = "mingw-w64-i686-nasm";
    version     = "2.14.01";
    filename    = "mingw-w64-i686-nasm-2.14.01-1-any.pkg.tar.xz";
    sha256      = "728c48863e80f20d74c70747d69c970ec651bfc8a6b1d6bfafd953b43c0c2e53";
  };

  "mingw-w64-i686-ncurses" = fetch {
    name        = "mingw-w64-i686-ncurses";
    version     = "6.1.20180908";
    filename    = "mingw-w64-i686-ncurses-6.1.20180908-1-any.pkg.tar.xz";
    sha256      = "9ad38936f2f2ddae01625cd7b2cc7ae1a5188c7db2c3bbe9600af17404113c22";
    buildInputs = [ mingw-w64-i686-libsystre ];
  };

  "mingw-w64-i686-netcdf" = fetch {
    name        = "mingw-w64-i686-netcdf";
    version     = "4.6.2";
    filename    = "mingw-w64-i686-netcdf-4.6.2-1-any.pkg.tar.xz";
    sha256      = "8b8bce84de9584a5155b3288fcb36c17ffbd27b4f62267395b409a3e8acd940a";
    buildInputs = [ mingw-w64-i686-hdf5 ];
  };

  "mingw-w64-i686-nettle" = fetch {
    name        = "mingw-w64-i686-nettle";
    version     = "3.4.1";
    filename    = "mingw-w64-i686-nettle-3.4.1-1-any.pkg.tar.xz";
    sha256      = "85a67ddee4a0e7a76c36c198993b062efe79f458f908b463ea8697195590f136";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gmp ];
  };

  "mingw-w64-i686-nghttp2" = fetch {
    name        = "mingw-w64-i686-nghttp2";
    version     = "1.35.1";
    filename    = "mingw-w64-i686-nghttp2-1.35.1-1-any.pkg.tar.xz";
    sha256      = "c82f9d541c2b8b9fad45e41abc504c34305fd546430231a39578d2171a823ce1";
    buildInputs = [ mingw-w64-i686-jansson mingw-w64-i686-jemalloc mingw-w64-i686-openssl mingw-w64-i686-c-ares ];
  };

  "mingw-w64-i686-ngraph-gtk" = fetch {
    name        = "mingw-w64-i686-ngraph-gtk";
    version     = "6.08.00";
    filename    = "mingw-w64-i686-ngraph-gtk-6.08.00-1-any.pkg.tar.xz";
    sha256      = "8e85b570e81b167d45c34b49a4434f4dea4ad32b190d223f924c5500887395fa";
    buildInputs = [ mingw-w64-i686-adwaita-icon-theme mingw-w64-i686-gsettings-desktop-schemas mingw-w64-i686-gtk3 mingw-w64-i686-gtksourceview3 mingw-w64-i686-readline mingw-w64-i686-gsl mingw-w64-i686-ruby ];
  };

  "mingw-w64-i686-ngspice" = fetch {
    name        = "mingw-w64-i686-ngspice";
    version     = "29";
    filename    = "mingw-w64-i686-ngspice-29-1-any.pkg.tar.xz";
    sha256      = "085af3df9174f795bc0ea743df18af9e4eea6a3a80c2db7f646e313a37e8d81f";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-nim" = fetch {
    name        = "mingw-w64-i686-nim";
    version     = "0.19.0";
    filename    = "mingw-w64-i686-nim-0.19.0-3-any.pkg.tar.xz";
    sha256      = "c57449a4a53928f81e664a2a19b16ce43ba5972d03c9a354d658dc388173ba63";
  };

  "mingw-w64-i686-nimble" = fetch {
    name        = "mingw-w64-i686-nimble";
    version     = "0.9.0";
    filename    = "mingw-w64-i686-nimble-0.9.0-1-any.pkg.tar.xz";
    sha256      = "ee31aa9cdc47d825a50de8c48cb5e70d2cc383e3493754cfd64aa09f58b24f82";
  };

  "mingw-w64-i686-ninja" = fetch {
    name        = "mingw-w64-i686-ninja";
    version     = "1.8.2";
    filename    = "mingw-w64-i686-ninja-1.8.2-3-any.pkg.tar.xz";
    sha256      = "e37efb22863fd13900cdf03cf85fc8cc95c86c60294338f7557b9241aba68158";
    buildInputs = [  ];
  };

  "mingw-w64-i686-nlopt" = fetch {
    name        = "mingw-w64-i686-nlopt";
    version     = "2.5.0";
    filename    = "mingw-w64-i686-nlopt-2.5.0-1-any.pkg.tar.xz";
    sha256      = "0f776a7c5e082df96eb7be21c11b58bd188131dc9e7903da21a9f0a9d487e1da";
  };

  "mingw-w64-i686-nodejs" = fetch {
    name        = "mingw-w64-i686-nodejs";
    version     = "8.11.1";
    filename    = "mingw-w64-i686-nodejs-8.11.1-5-any.pkg.tar.xz";
    sha256      = "b96a59d8c0bd648868383e4e0967ebea2836bd29c245785f1c573638e70d2244";
    buildInputs = [ mingw-w64-i686-c-ares mingw-w64-i686-http-parser mingw-w64-i686-icu mingw-w64-i686-libuv mingw-w64-i686-openssl mingw-w64-i686-zlib winpty ];
  };

  "mingw-w64-i686-npth" = fetch {
    name        = "mingw-w64-i686-npth";
    version     = "1.6";
    filename    = "mingw-w64-i686-npth-1.6-1-any.pkg.tar.xz";
    sha256      = "123a2ac722ad936e066220bd12e165960feb3ab0a267e62aab88687b6a7c6f0c";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-nsis" = fetch {
    name        = "mingw-w64-i686-nsis";
    version     = "3.04";
    filename    = "mingw-w64-i686-nsis-3.04-1-any.pkg.tar.xz";
    sha256      = "e4605157a694d9f631186f4ba24cc4b66814f74c22c9082419da2d690527f39d";
    buildInputs = [ mingw-w64-i686-zlib mingw-w64-i686-gcc-libs mingw-w64-i686-libwinpthread-git ];
  };

  "mingw-w64-i686-nsis-nsisunz" = fetch {
    name        = "mingw-w64-i686-nsis-nsisunz";
    version     = "1.0";
    filename    = "mingw-w64-i686-nsis-nsisunz-1.0-1-any.pkg.tar.xz";
    sha256      = "6ab117e6379a41d56301912f9da96a64a6e735b26913f179e41c510eff6e56d2";
    buildInputs = [ mingw-w64-i686-nsis ];
  };

  "mingw-w64-i686-nspr" = fetch {
    name        = "mingw-w64-i686-nspr";
    version     = "4.20";
    filename    = "mingw-w64-i686-nspr-4.20-1-any.pkg.tar.xz";
    sha256      = "d1ed2cb8daa811f58f0aff8d771b5a349be151325b6edce92fc60710fc9eabc2";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-nss" = fetch {
    name        = "mingw-w64-i686-nss";
    version     = "3.41";
    filename    = "mingw-w64-i686-nss-3.41-1-any.pkg.tar.xz";
    sha256      = "d08026059f031decdb7b92baeedcc381f1fd5b105cbf3baa83a72fe24577fc70";
    buildInputs = [ mingw-w64-i686-nspr mingw-w64-i686-sqlite3 mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-ntldd-git" = fetch {
    name        = "mingw-w64-i686-ntldd-git";
    version     = "r15.e7622f6";
    filename    = "mingw-w64-i686-ntldd-git-r15.e7622f6-2-any.pkg.tar.xz";
    sha256      = "361d19deeaaa9be4f8a32bd40bebed4e4965c6f0ec7c2f4529c5930e986a1c22";
  };

  "mingw-w64-i686-ocaml" = fetch {
    name        = "mingw-w64-i686-ocaml";
    version     = "4.04.0";
    filename    = "mingw-w64-i686-ocaml-4.04.0-1-any.pkg.tar.xz";
    sha256      = "4d48f73ec4f6b9278f50095acea9be53b736d287da50f11bcc4987dae8974af2";
    buildInputs = [ mingw-w64-i686-flexdll ];
  };

  "mingw-w64-i686-ocaml-findlib" = fetch {
    name        = "mingw-w64-i686-ocaml-findlib";
    version     = "1.7.1";
    filename    = "mingw-w64-i686-ocaml-findlib-1.7.1-1-any.pkg.tar.xz";
    sha256      = "23775672cfa7734d0b3897f60e824fade43e74c23d563e12966954a730e0a2ca";
    buildInputs = [ mingw-w64-i686-ocaml msys2-runtime ];
    broken      = true; # broken dependency mingw-w64-i686-ocaml-findlib -> msys2-runtime
  };

  "mingw-w64-i686-oce" = fetch {
    name        = "mingw-w64-i686-oce";
    version     = "0.18.3";
    filename    = "mingw-w64-i686-oce-0.18.3-1-any.pkg.tar.xz";
    sha256      = "cbca8a65a6286be6e3179d304a99e40865b02f3c52358a7758dfb1a366446a77";
    buildInputs = [ mingw-w64-i686-freetype ];
  };

  "mingw-w64-i686-octopi-git" = fetch {
    name        = "mingw-w64-i686-octopi-git";
    version     = "r941.6df0f8a";
    filename    = "mingw-w64-i686-octopi-git-r941.6df0f8a-1-any.pkg.tar.xz";
    sha256      = "9258b5333beb815ae5b95a7771ad1ca2aabc07cfe0d485dd89d825c69abb9291";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-odt2txt" = fetch {
    name        = "mingw-w64-i686-odt2txt";
    version     = "0.5";
    filename    = "mingw-w64-i686-odt2txt-0.5-2-any.pkg.tar.xz";
    sha256      = "133a5ad172cef84fc5c796301ec4d6ebdfd9848bd96f5ad3c0610653bac141b5";
    buildInputs = [ mingw-w64-i686-libiconv mingw-w64-i686-libzip mingw-w64-i686-pcre ];
  };

  "mingw-w64-i686-ogitor-git" = fetch {
    name        = "mingw-w64-i686-ogitor-git";
    version     = "r816.cf42232";
    filename    = "mingw-w64-i686-ogitor-git-r816.cf42232-1-any.pkg.tar.xz";
    sha256      = "c67e032729a028625f8ef484303f1c94e7408e77fdfc28bc1928624c0ed27d53";
    buildInputs = [ mingw-w64-i686-libwinpthread-git mingw-w64-i686-ogre3d mingw-w64-i686-boost mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-ogre3d -> mingw-w64-i686-FreeImage
  };

  "mingw-w64-i686-ogre3d" = fetch {
    name        = "mingw-w64-i686-ogre3d";
    version     = "1.11.1";
    filename    = "mingw-w64-i686-ogre3d-1.11.1-1-any.pkg.tar.xz";
    sha256      = "9ed74b8fa3b7f3170d7d22e150c39cf3b40f1976be5b997ec552efccf49ad360";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-cppunit mingw-w64-i686-FreeImage mingw-w64-i686-freetype mingw-w64-i686-glsl-optimizer-git mingw-w64-i686-hlsl2glsl-git mingw-w64-i686-intel-tbb mingw-w64-i686-openexr mingw-w64-i686-SDL2 mingw-w64-i686-python2 mingw-w64-i686-tinyxml mingw-w64-i686-winpthreads-git mingw-w64-i686-zlib mingw-w64-i686-zziplib ];
    broken      = true; # broken dependency mingw-w64-i686-ogre3d -> mingw-w64-i686-FreeImage
  };

  "mingw-w64-i686-ois-git" = fetch {
    name        = "mingw-w64-i686-ois-git";
    version     = "1.4.0.124.564dd81";
    filename    = "mingw-w64-i686-ois-git-1.4.0.124.564dd81-1-any.pkg.tar.xz";
    sha256      = "63c0864d9d962af22f2acc5e7cb23ff6d048545dbe01d7bf7ea7e539f1390604";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-oniguruma" = fetch {
    name        = "mingw-w64-i686-oniguruma";
    version     = "6.9.1";
    filename    = "mingw-w64-i686-oniguruma-6.9.1-1-any.pkg.tar.xz";
    sha256      = "8c488fa1ea7e37ca16e0c0b2230cce13cafa121ccfe2f900dfe59b8b96c77c03";
    buildInputs = [  ];
  };

  "mingw-w64-i686-openal" = fetch {
    name        = "mingw-w64-i686-openal";
    version     = "1.19.1";
    filename    = "mingw-w64-i686-openal-1.19.1-1-any.pkg.tar.xz";
    sha256      = "4a7e8c335fc397bac5987c0b302ab6533dc9bdedf703910e4186791193c579ea";
    buildInputs = [  ];
  };

  "mingw-w64-i686-openblas" = fetch {
    name        = "mingw-w64-i686-openblas";
    version     = "0.3.5";
    filename    = "mingw-w64-i686-openblas-0.3.5-1-any.pkg.tar.xz";
    sha256      = "ea5fbeb5b718b64098e8e8ef54bd8ac689d4de8855bc9797921419ca24d5e6a3";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gcc-libgfortran mingw-w64-i686-libwinpthread-git ];
  };

  "mingw-w64-i686-opencl-headers" = fetch {
    name        = "mingw-w64-i686-opencl-headers";
    version     = "2~2.2.20170516";
    filename    = "mingw-w64-i686-opencl-headers-2~2.2.20170516-1-any.pkg.tar.xz";
    sha256      = "644bdf83d38ef7409bef1f3cd136d9d4d7a71bcef5c846d5e48b4ebc21e6df95";
  };

  "mingw-w64-i686-opencollada-git" = fetch {
    name        = "mingw-w64-i686-opencollada-git";
    version     = "r1687.d826fd08";
    filename    = "mingw-w64-i686-opencollada-git-r1687.d826fd08-1-any.pkg.tar.xz";
    sha256      = "846172dcb86559cd4cc450fbd8d38c80786b8f3af642cc871ed46ac299111b86";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-pcre ];
  };

  "mingw-w64-i686-opencolorio-git" = fetch {
    name        = "mingw-w64-i686-opencolorio-git";
    version     = "815.15e96c1f";
    filename    = "mingw-w64-i686-opencolorio-git-815.15e96c1f-1-any.pkg.tar.xz";
    sha256      = "70f3cec3102a1a1ab3df14c6192a7e04b8050f5f36b3e5928a56d78cd3f8a917";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-glew mingw-w64-i686-lcms2 mingw-w64-i686-python3 mingw-w64-i686-tinyxml mingw-w64-i686-yaml-cpp ];
  };

  "mingw-w64-i686-opencore-amr" = fetch {
    name        = "mingw-w64-i686-opencore-amr";
    version     = "0.1.5";
    filename    = "mingw-w64-i686-opencore-amr-0.1.5-1-any.pkg.tar.xz";
    sha256      = "33ac0d1b31850ce14795b1ef091d61487fe2980085790414cd443478c1cbf045";
    buildInputs = [  ];
  };

  "mingw-w64-i686-opencsg" = fetch {
    name        = "mingw-w64-i686-opencsg";
    version     = "1.4.2";
    filename    = "mingw-w64-i686-opencsg-1.4.2-1-any.pkg.tar.xz";
    sha256      = "79397bf6d1315882c425d229e385159f332e88c14f7306a8a7f4dbbe81c22416";
    buildInputs = [ mingw-w64-i686-glew ];
  };

  "mingw-w64-i686-opencv" = fetch {
    name        = "mingw-w64-i686-opencv";
    version     = "4.0.1";
    filename    = "mingw-w64-i686-opencv-4.0.1-1-any.pkg.tar.xz";
    sha256      = "cb1c2febd5994903d4ea01c4a9fdccc25d2cbbf788b4cbb994bb9b474e868237";
    buildInputs = [ mingw-w64-i686-intel-tbb mingw-w64-i686-jasper mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-libwebp mingw-w64-i686-openblas mingw-w64-i686-openexr mingw-w64-i686-protobuf mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-opencv -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-openexr" = fetch {
    name        = "mingw-w64-i686-openexr";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-openexr-2.3.0-1-any.pkg.tar.xz";
    sha256      = "b34997428399cb5abd3af5bf4dcf97175e05cd98365086c1f6d12e7c8399c225";
    buildInputs = [ (assert mingw-w64-i686-ilmbase.version=="2.3.0"; mingw-w64-i686-ilmbase) mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-openh264" = fetch {
    name        = "mingw-w64-i686-openh264";
    version     = "1.8.0";
    filename    = "mingw-w64-i686-openh264-1.8.0-1-any.pkg.tar.xz";
    sha256      = "b0cab1628d4b93c7d3466c41eb074852b593d0dc1e347b94d75d0a733600bf32";
  };

  "mingw-w64-i686-openimageio" = fetch {
    name        = "mingw-w64-i686-openimageio";
    version     = "1.8.17";
    filename    = "mingw-w64-i686-openimageio-1.8.17-1-any.pkg.tar.xz";
    sha256      = "0f5a110551d08b1dbe5b386c6538fa51daaf1481d51782b3b93a8c239c471ad8";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-field3d mingw-w64-i686-freetype mingw-w64-i686-jasper mingw-w64-i686-giflib mingw-w64-i686-glew mingw-w64-i686-hdf5 mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-LibRaw mingw-w64-i686-libwebp mingw-w64-i686-libtiff mingw-w64-i686-opencolorio-git mingw-w64-i686-opencv mingw-w64-i686-openexr mingw-w64-i686-openjpeg mingw-w64-i686-openssl mingw-w64-i686-ptex mingw-w64-i686-pugixml mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-openimageio -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-openjpeg" = fetch {
    name        = "mingw-w64-i686-openjpeg";
    version     = "1.5.2";
    filename    = "mingw-w64-i686-openjpeg-1.5.2-7-any.pkg.tar.xz";
    sha256      = "1435b1222bc1e93ae1e8e82e00930e5ef7df8af36b2cc7690285c46f4cf7252a";
    buildInputs = [ mingw-w64-i686-lcms2 mingw-w64-i686-libtiff mingw-w64-i686-libpng mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-openjpeg2" = fetch {
    name        = "mingw-w64-i686-openjpeg2";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-openjpeg2-2.3.0-2-any.pkg.tar.xz";
    sha256      = "c7bc640e8aeb57084e8b8e5ccfbc9faecba3089e953afb2df287f949ee1c0e8b";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-lcms2 mingw-w64-i686-libtiff mingw-w64-i686-libpng mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-openldap" = fetch {
    name        = "mingw-w64-i686-openldap";
    version     = "2.4.46";
    filename    = "mingw-w64-i686-openldap-2.4.46-1-any.pkg.tar.xz";
    sha256      = "74a1d71798b81d33ecbc90d3b7ed3e5dd83a1d060fbff5bb0094ae3baab1a86f";
    buildInputs = [ mingw-w64-i686-cyrus-sasl mingw-w64-i686-icu mingw-w64-i686-libtool mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-openlibm" = fetch {
    name        = "mingw-w64-i686-openlibm";
    version     = "0.6.0";
    filename    = "mingw-w64-i686-openlibm-0.6.0-1-any.pkg.tar.xz";
    sha256      = "cef52935bdc7f03bf2606db7126c692f0d56e90c076215edb754b287d6697e3b";
  };

  "mingw-w64-i686-openocd" = fetch {
    name        = "mingw-w64-i686-openocd";
    version     = "0.10.0";
    filename    = "mingw-w64-i686-openocd-0.10.0-1-any.pkg.tar.xz";
    sha256      = "01ac85ddb3e2ff29a6228ddfaac2221741611cb1260071fce75b5b2b4d392fd9";
    buildInputs = [ mingw-w64-i686-hidapi mingw-w64-i686-libusb mingw-w64-i686-libusb-compat-git mingw-w64-i686-libftdi ];
  };

  "mingw-w64-i686-openocd-git" = fetch {
    name        = "mingw-w64-i686-openocd-git";
    version     = "0.9.0.r2.g79fdeb3";
    filename    = "mingw-w64-i686-openocd-git-0.9.0.r2.g79fdeb3-1-any.pkg.tar.xz";
    sha256      = "1ce6a7e6312394a1e38f2f7bb8291d931ba4c1759c5b94f6970a170db2ce7b6b";
    buildInputs = [ mingw-w64-i686-hidapi mingw-w64-i686-libusb mingw-w64-i686-libusb-compat-git ];
  };

  "mingw-w64-i686-openscad" = fetch {
    name        = "mingw-w64-i686-openscad";
    version     = "2015.03";
    filename    = "mingw-w64-i686-openscad-2015.03-2-any.pkg.tar.xz";
    sha256      = "df2e22c313dff430ba31a59b76e1b101a0da7c2a90586dd1229331cca4730d09";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-boost mingw-w64-i686-cgal mingw-w64-i686-opencsg mingw-w64-i686-qscintilla mingw-w64-i686-shared-mime-info ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-openshadinglanguage" = fetch {
    name        = "mingw-w64-i686-openshadinglanguage";
    version     = "1.8.15";
    filename    = "mingw-w64-i686-openshadinglanguage-1.8.15-3-any.pkg.tar.xz";
    sha256      = "5a289a03bfc78bd451b8a2b827c5ab0a7048b5ede3762c8b192535e1a19aaab2";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-clang mingw-w64-i686-freetype mingw-w64-i686-glew mingw-w64-i686-ilmbase mingw-w64-i686-intel-tbb mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-openexr mingw-w64-i686-openimageio mingw-w64-i686-pugixml ];
    broken      = true; # broken dependency mingw-w64-i686-openimageio -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-openssl" = fetch {
    name        = "mingw-w64-i686-openssl";
    version     = "1.1.1.a";
    filename    = "mingw-w64-i686-openssl-1.1.1.a-1-any.pkg.tar.xz";
    sha256      = "35f6cf9ebc3192bd5057ff320c6e0528dde88d66fd5559f6bfb71b72303fa981";
    buildInputs = [ mingw-w64-i686-ca-certificates mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-openvr" = fetch {
    name        = "mingw-w64-i686-openvr";
    version     = "1.0.16";
    filename    = "mingw-w64-i686-openvr-1.0.16-1-any.pkg.tar.xz";
    sha256      = "05b5b0898516ab75b4dad4a033f5bf04242becc72ddc64cf8a226f8a84212d4a";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-optipng" = fetch {
    name        = "mingw-w64-i686-optipng";
    version     = "0.7.7";
    filename    = "mingw-w64-i686-optipng-0.7.7-1-any.pkg.tar.xz";
    sha256      = "b63b560c30465c09a44cbdda762b3d5b5467923175b46655ae6ccb4d982a0697";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libpng mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-opus" = fetch {
    name        = "mingw-w64-i686-opus";
    version     = "1.3";
    filename    = "mingw-w64-i686-opus-1.3-1-any.pkg.tar.xz";
    sha256      = "c9d638283032169a341c9ecd53bd322341bda6e67870b4659e7c9902b61ff8e1";
    buildInputs = [  ];
  };

  "mingw-w64-i686-opus-tools" = fetch {
    name        = "mingw-w64-i686-opus-tools";
    version     = "0.2";
    filename    = "mingw-w64-i686-opus-tools-0.2-1-any.pkg.tar.xz";
    sha256      = "bae2a5cd38fc54698f9f7012dfff2ecadd2cc586af589d12bb1fdc58f6a7d817";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-flac mingw-w64-i686-libogg mingw-w64-i686-opus mingw-w64-i686-opusfile mingw-w64-i686-libopusenc ];
  };

  "mingw-w64-i686-opusfile" = fetch {
    name        = "mingw-w64-i686-opusfile";
    version     = "0.11";
    filename    = "mingw-w64-i686-opusfile-0.11-2-any.pkg.tar.xz";
    sha256      = "f6cbe5b87055638b15093a36962062d3bb4e4451f5d88a70e8411db4e96f772f";
    buildInputs = [ mingw-w64-i686-libogg mingw-w64-i686-openssl mingw-w64-i686-opus ];
  };

  "mingw-w64-i686-orc" = fetch {
    name        = "mingw-w64-i686-orc";
    version     = "0.4.28";
    filename    = "mingw-w64-i686-orc-0.4.28-1-any.pkg.tar.xz";
    sha256      = "3808b4302f97edec0e6823936be10bfc5af9b51f5289823cb0987c53e8ece13d";
  };

  "mingw-w64-i686-osgQt" = fetch {
    name        = "mingw-w64-i686-osgQt";
    version     = "3.5.7";
    filename    = "mingw-w64-i686-osgQt-3.5.7-6-any.pkg.tar.xz";
    sha256      = "56a06b692fe814fbb2041e8bbbd211520342d885ec27a2f39d1e968ab6ff4ba5";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-OpenSceneGraph ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-osgQt-debug" = fetch {
    name        = "mingw-w64-i686-osgQt-debug";
    version     = "3.5.7";
    filename    = "mingw-w64-i686-osgQt-debug-3.5.7-6-any.pkg.tar.xz";
    sha256      = "132a56ffb3f761669cd77e166426505444724951be5c67b11e9cf5a20ebf0674";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-OpenSceneGraph-debug ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-osgQtQuick-debug-git" = fetch {
    name        = "mingw-w64-i686-osgQtQuick-debug-git";
    version     = "2.0.0.r172";
    filename    = "mingw-w64-i686-osgQtQuick-debug-git-2.0.0.r172-4-any.pkg.tar.xz";
    sha256      = "9a6e5b4d693f84a34c42a5266744a92d367c6ed9a62db22f65b50022ee3e9adf";
    buildInputs = [ mingw-w64-i686-osgQt-debug mingw-w64-i686-qt5 (assert mingw-w64-i686-osgQtQuick-git.version=="2.0.0.r172"; mingw-w64-i686-osgQtQuick-git) mingw-w64-i686-OpenSceneGraph-debug ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-osgQtQuick-git" = fetch {
    name        = "mingw-w64-i686-osgQtQuick-git";
    version     = "2.0.0.r172";
    filename    = "mingw-w64-i686-osgQtQuick-git-2.0.0.r172-4-any.pkg.tar.xz";
    sha256      = "7edd3ab4cf457d35ea841cd8bc49a230286d0409c4ca1d5b5e3cf80ae6ebaaaf";
    buildInputs = [ mingw-w64-i686-osgQt mingw-w64-i686-qt5 mingw-w64-i686-OpenSceneGraph ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-osgbullet-debug-git" = fetch {
    name        = "mingw-w64-i686-osgbullet-debug-git";
    version     = "3.0.0.265";
    filename    = "mingw-w64-i686-osgbullet-debug-git-3.0.0.265-1-any.pkg.tar.xz";
    sha256      = "301bdabd3bb71f45fc7763f69b3f5e8bb493ffc19fe01778f8e5349f015253fb";
    buildInputs = [ (assert mingw-w64-i686-osgbullet-git.version=="3.0.0.265"; mingw-w64-i686-osgbullet-git) mingw-w64-i686-OpenSceneGraph-debug mingw-w64-i686-osgworks-debug-git ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-osgbullet-git" = fetch {
    name        = "mingw-w64-i686-osgbullet-git";
    version     = "3.0.0.265";
    filename    = "mingw-w64-i686-osgbullet-git-3.0.0.265-1-any.pkg.tar.xz";
    sha256      = "4014f581540b544384403d278d74d4a140dec7bf41fa7ecf9f5e046888ce3184";
    buildInputs = [ mingw-w64-i686-bullet mingw-w64-i686-OpenSceneGraph mingw-w64-i686-osgworks-git ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-osgearth" = fetch {
    name        = "mingw-w64-i686-osgearth";
    version     = "2.10";
    filename    = "mingw-w64-i686-osgearth-2.10-1-any.pkg.tar.xz";
    sha256      = "71b1171072fc3894534ecfce69c03a857fd5d406b64b91275d2f6ef68b5387e4";
    buildInputs = [ mingw-w64-i686-OpenSceneGraph mingw-w64-i686-OpenSceneGraph-debug mingw-w64-i686-osgQt mingw-w64-i686-osgQt-debug mingw-w64-i686-curl mingw-w64-i686-gdal mingw-w64-i686-geos mingw-w64-i686-poco mingw-w64-i686-protobuf mingw-w64-i686-rocksdb mingw-w64-i686-sqlite3 mingw-w64-i686-OpenSceneGraph ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-osgearth-debug" = fetch {
    name        = "mingw-w64-i686-osgearth-debug";
    version     = "2.10";
    filename    = "mingw-w64-i686-osgearth-debug-2.10-1-any.pkg.tar.xz";
    sha256      = "cce9b011f21f80a87a6592fd94e773ccf1bd1eef1c202943c42b4f12a0f486b1";
    buildInputs = [ mingw-w64-i686-OpenSceneGraph mingw-w64-i686-OpenSceneGraph-debug mingw-w64-i686-osgQt mingw-w64-i686-osgQt-debug mingw-w64-i686-curl mingw-w64-i686-gdal mingw-w64-i686-geos mingw-w64-i686-poco mingw-w64-i686-protobuf mingw-w64-i686-rocksdb mingw-w64-i686-sqlite3 mingw-w64-i686-OpenSceneGraph-debug ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-osgocean-debug-git" = fetch {
    name        = "mingw-w64-i686-osgocean-debug-git";
    version     = "1.0.1.r161";
    filename    = "mingw-w64-i686-osgocean-debug-git-1.0.1.r161-1-any.pkg.tar.xz";
    sha256      = "d9b69b4771cfc217b378931f7b8cb150dda5668994ae1c1727d717de79f8da3a";
    buildInputs = [ (assert mingw-w64-i686-osgocean-git.version=="1.0.1.r161"; mingw-w64-i686-osgocean-git) mingw-w64-i686-OpenSceneGraph-debug ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-osgocean-git" = fetch {
    name        = "mingw-w64-i686-osgocean-git";
    version     = "1.0.1.r161";
    filename    = "mingw-w64-i686-osgocean-git-1.0.1.r161-1-any.pkg.tar.xz";
    sha256      = "c63067cd62e703a8a5f0ad64750bfef93bfb76608c4cfd039092cd1848020b78";
    buildInputs = [ mingw-w64-i686-fftw mingw-w64-i686-OpenSceneGraph ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-osgworks-debug-git" = fetch {
    name        = "mingw-w64-i686-osgworks-debug-git";
    version     = "3.1.0.444";
    filename    = "mingw-w64-i686-osgworks-debug-git-3.1.0.444-3-any.pkg.tar.xz";
    sha256      = "f5b7e1150de904f70f54e7b7d25aecb3f523f3cdb9bfa9fbebc5ac336f58246e";
    buildInputs = [ (assert mingw-w64-i686-osgworks-git.version=="3.1.0.444"; mingw-w64-i686-osgworks-git) mingw-w64-i686-OpenSceneGraph-debug ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-osgworks-git" = fetch {
    name        = "mingw-w64-i686-osgworks-git";
    version     = "3.1.0.444";
    filename    = "mingw-w64-i686-osgworks-git-3.1.0.444-3-any.pkg.tar.xz";
    sha256      = "c90d3ed1c2505888e1600415811974d0eed104435fe891b5cd36b6ab35b8b8c2";
    buildInputs = [ mingw-w64-i686-OpenSceneGraph mingw-w64-i686-vrpn ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-osl" = fetch {
    name        = "mingw-w64-i686-osl";
    version     = "0.9.2";
    filename    = "mingw-w64-i686-osl-0.9.2-1-any.pkg.tar.xz";
    sha256      = "22e797c7d41f56b83e4ba194152a77ef5284d6aa3a726ceec7e6dd3c4b41f4bd";
    buildInputs = [ mingw-w64-i686-gmp ];
  };

  "mingw-w64-i686-osm-gps-map" = fetch {
    name        = "mingw-w64-i686-osm-gps-map";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-osm-gps-map-1.1.0-2-any.pkg.tar.xz";
    sha256      = "47560af1e6f6142300ef426cc2d02da903b3aa32f8e4b20f8044f8e92a879099";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-libsoup mingw-w64-i686-python2 mingw-w64-i686-gtk3 mingw-w64-i686-python2-gobject2 mingw-w64-i686-python2-cairo mingw-w64-i686-python2-pygtk mingw-w64-i686-gobject-introspection ];
  };

  "mingw-w64-i686-osmgpsmap-git" = fetch {
    name        = "mingw-w64-i686-osmgpsmap-git";
    version     = "r443.c24d08d";
    filename    = "mingw-w64-i686-osmgpsmap-git-r443.c24d08d-1-any.pkg.tar.xz";
    sha256      = "4ece08a9dd43b4c5cca91c258450ca0e620684f8724d84eed557f0bc2ae3fe33";
    buildInputs = [ mingw-w64-i686-gtk3 mingw-w64-i686-libsoup mingw-w64-i686-python2-gobject mingw-w64-i686-gobject-introspection ];
  };

  "mingw-w64-i686-osslsigncode" = fetch {
    name        = "mingw-w64-i686-osslsigncode";
    version     = "1.7.1";
    filename    = "mingw-w64-i686-osslsigncode-1.7.1-4-any.pkg.tar.xz";
    sha256      = "6928ed865274210781b2b3fada438c21d4cc38448c8eef0f6642df3d245740cf";
    buildInputs = [ mingw-w64-i686-curl mingw-w64-i686-libgsf mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-p11-kit" = fetch {
    name        = "mingw-w64-i686-p11-kit";
    version     = "0.23.14";
    filename    = "mingw-w64-i686-p11-kit-0.23.14-1-any.pkg.tar.xz";
    sha256      = "456cfb440fc4eb31604af9a701ec232882df734297b0b61b79ce694d6feee8d8";
    buildInputs = [ mingw-w64-i686-libtasn1 mingw-w64-i686-libffi mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-paho.mqtt.c" = fetch {
    name        = "mingw-w64-i686-paho.mqtt.c";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-paho.mqtt.c-1.1.0-1-any.pkg.tar.xz";
    sha256      = "2bb39a3a84f53d1570094cfa579028b63e1625aa85ed3f81b1dd171e2adbd1df";
  };

  "mingw-w64-i686-pango" = fetch {
    name        = "mingw-w64-i686-pango";
    version     = "1.43.0";
    filename    = "mingw-w64-i686-pango-1.43.0-1-any.pkg.tar.xz";
    sha256      = "b457aaedd6fc3c1e5d707ddd37393aa202a6bc626b68f12a4be3ef221930499f";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-cairo mingw-w64-i686-freetype mingw-w64-i686-fontconfig mingw-w64-i686-glib2 mingw-w64-i686-harfbuzz mingw-w64-i686-fribidi mingw-w64-i686-libthai ];
  };

  "mingw-w64-i686-pangomm" = fetch {
    name        = "mingw-w64-i686-pangomm";
    version     = "2.42.0";
    filename    = "mingw-w64-i686-pangomm-2.42.0-1-any.pkg.tar.xz";
    sha256      = "0d43af60af9cd504353f7ebc81a4b4b7597edd33c0cb53c54e6be3b7226741f9";
    buildInputs = [ mingw-w64-i686-cairomm mingw-w64-i686-glibmm mingw-w64-i686-pango ];
  };

  "mingw-w64-i686-pcre" = fetch {
    name        = "mingw-w64-i686-pcre";
    version     = "8.42";
    filename    = "mingw-w64-i686-pcre-8.42-1-any.pkg.tar.xz";
    sha256      = "dab2536d002bff301b775f3cdda62ac519c9dc7bbd42f7b586fe053b23ee0069";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-bzip2 mingw-w64-i686-wineditline mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-pcre2" = fetch {
    name        = "mingw-w64-i686-pcre2";
    version     = "10.32";
    filename    = "mingw-w64-i686-pcre2-10.32-1-any.pkg.tar.xz";
    sha256      = "8c52a83ab933a05644720ed87b74111690134c3b0a2541a7bf71082e43896253";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-bzip2 mingw-w64-i686-wineditline mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-pdcurses" = fetch {
    name        = "mingw-w64-i686-pdcurses";
    version     = "3.6";
    filename    = "mingw-w64-i686-pdcurses-3.6-2-any.pkg.tar.xz";
    sha256      = "b896b5f8e27a6299a0a1907bd96b87b97a69a84e3736dfa7cdbf1a9d8eaa5a55";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-pdf2djvu" = fetch {
    name        = "mingw-w64-i686-pdf2djvu";
    version     = "0.9.12";
    filename    = "mingw-w64-i686-pdf2djvu-0.9.12-1-any.pkg.tar.xz";
    sha256      = "2e1828f8ef97d4e546359b7120ed5365ffe20bb3d6e098d0f525061269f666a3";
    buildInputs = [ mingw-w64-i686-poppler mingw-w64-i686-gcc-libs mingw-w64-i686-djvulibre mingw-w64-i686-exiv2 mingw-w64-i686-gettext mingw-w64-i686-graphicsmagick mingw-w64-i686-libiconv ];
    broken      = true; # broken dependency mingw-w64-i686-poppler -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-pdf2svg" = fetch {
    name        = "mingw-w64-i686-pdf2svg";
    version     = "0.2.3";
    filename    = "mingw-w64-i686-pdf2svg-0.2.3-7-any.pkg.tar.xz";
    sha256      = "4a8ab63c9d298af7daa2b397eb9bfa964777fa1cd0524a72c73e3c38ac6e1798";
    buildInputs = [ mingw-w64-i686-poppler ];
    broken      = true; # broken dependency mingw-w64-i686-poppler -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-pegtl" = fetch {
    name        = "mingw-w64-i686-pegtl";
    version     = "2.7.1";
    filename    = "mingw-w64-i686-pegtl-2.7.1-1-any.pkg.tar.xz";
    sha256      = "1e884274a276cbf3d052f66aa4ee0fbb035ff1f8f1729a4ed328f0b25e644c3a";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-perl" = fetch {
    name        = "mingw-w64-i686-perl";
    version     = "5.28.0";
    filename    = "mingw-w64-i686-perl-5.28.0-1-any.pkg.tar.xz";
    sha256      = "6186059a3533d3634b445247785f608c1e5d6fe9fc075d63f2088203d6a1b42c";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-winpthreads-git mingw-w64-i686-make ];
  };

  "mingw-w64-i686-perl-doc" = fetch {
    name        = "mingw-w64-i686-perl-doc";
    version     = "5.28.0";
    filename    = "mingw-w64-i686-perl-doc-5.28.0-1-any.pkg.tar.xz";
    sha256      = "905f5f93267984a039afe0b070c954e5c3b2c8f8732dc4cecb04947f74f9fe95";
  };

  "mingw-w64-i686-phodav" = fetch {
    name        = "mingw-w64-i686-phodav";
    version     = "2.2";
    filename    = "mingw-w64-i686-phodav-2.2-1-any.pkg.tar.xz";
    sha256      = "0939239611c6ca4f836a3539cbe215db45aaea839151616234685aaafe18799e";
    buildInputs = [ mingw-w64-i686-libsoup ];
  };

  "mingw-w64-i686-phonon-qt5" = fetch {
    name        = "mingw-w64-i686-phonon-qt5";
    version     = "4.10.1";
    filename    = "mingw-w64-i686-phonon-qt5-4.10.1-1-any.pkg.tar.xz";
    sha256      = "e089c2167fb2683c61ad8cb43efffbb7747aa3b4757fbb6f0e5677ebe931a821";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-glib2 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-physfs" = fetch {
    name        = "mingw-w64-i686-physfs";
    version     = "3.0.1";
    filename    = "mingw-w64-i686-physfs-3.0.1-1-any.pkg.tar.xz";
    sha256      = "f144439a822ed0ab0bf65c38320926bed1cff456cc2fd58102d46a36159a176d";
    buildInputs = [ mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-pidgin++" = fetch {
    name        = "mingw-w64-i686-pidgin++";
    version     = "15.1";
    filename    = "mingw-w64-i686-pidgin++-15.1-2-any.pkg.tar.xz";
    sha256      = "17a722e8d262d9480cd8617f18d0cb77d9f8cc94691d79fe4b6e02b98173d692";
    buildInputs = [ mingw-w64-i686-adwaita-icon-theme mingw-w64-i686-ca-certificates mingw-w64-i686-drmingw mingw-w64-i686-freetype mingw-w64-i686-fontconfig mingw-w64-i686-gettext mingw-w64-i686-gnutls mingw-w64-i686-gsasl mingw-w64-i686-gst-plugins-base mingw-w64-i686-gst-plugins-good mingw-w64-i686-gtk2 mingw-w64-i686-gtkspell mingw-w64-i686-libgadu mingw-w64-i686-libidn mingw-w64-i686-meanwhile mingw-w64-i686-nss mingw-w64-i686-ncurses mingw-w64-i686-silc-toolkit mingw-w64-i686-winsparkle mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-pidgin-hg" = fetch {
    name        = "mingw-w64-i686-pidgin-hg";
    version     = "r37207.e666f49a3e86";
    filename    = "mingw-w64-i686-pidgin-hg-r37207.e666f49a3e86-1-any.pkg.tar.xz";
    sha256      = "0c5687e8b7d994b8086741fb1b2dc93461e47342a07757def16fe56c7bb4e91e";
    buildInputs = [ mingw-w64-i686-adwaita-icon-theme mingw-w64-i686-ca-certificates mingw-w64-i686-farstream mingw-w64-i686-freetype mingw-w64-i686-fontconfig mingw-w64-i686-gettext mingw-w64-i686-gnutls mingw-w64-i686-gplugin mingw-w64-i686-gsasl mingw-w64-i686-gtk3 mingw-w64-i686-gtkspell mingw-w64-i686-libgadu mingw-w64-i686-libidn mingw-w64-i686-nss mingw-w64-i686-ncurses mingw-w64-i686-webkitgtk3 mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-pinentry" = fetch {
    name        = "mingw-w64-i686-pinentry";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-pinentry-1.1.0-1-any.pkg.tar.xz";
    sha256      = "25aa94b4ab14e631bca988a73c51ab446cf24ac294b33e206984bf858c233cc4";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-libsecret mingw-w64-i686-libassuan ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-pixman" = fetch {
    name        = "mingw-w64-i686-pixman";
    version     = "0.36.0";
    filename    = "mingw-w64-i686-pixman-0.36.0-1-any.pkg.tar.xz";
    sha256      = "06135ff08edbf80bd6d11d14a4433e4e1bc6e0a4c89cb8e1c1ace9c38f30ee1b";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-pkg-config" = fetch {
    name        = "mingw-w64-i686-pkg-config";
    version     = "0.29.2";
    filename    = "mingw-w64-i686-pkg-config-0.29.2-1-any.pkg.tar.xz";
    sha256      = "39e07e61d739ba8f066605a109a19db397be6f7ddd81e5172f49ed253fdbe49f";
    buildInputs = [ mingw-w64-i686-libwinpthread-git ];
  };

  "mingw-w64-i686-plasma-framework-qt5" = fetch {
    name        = "mingw-w64-i686-plasma-framework-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-plasma-framework-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "e374b93fb7aca44e653f9c164a43783adedafcf9d46ccbc189e7c45e6caf2388";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-kactivities-qt5 mingw-w64-i686-kdeclarative-qt5 mingw-w64-i686-kirigami2-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-plplot" = fetch {
    name        = "mingw-w64-i686-plplot";
    version     = "5.13.0";
    filename    = "mingw-w64-i686-plplot-5.13.0-3-any.pkg.tar.xz";
    sha256      = "67f422242b91fa0bb3f0dd195d8f43e81e3008c1a7daed9ba43f442152cd42d7";
    buildInputs = [ mingw-w64-i686-cairo mingw-w64-i686-gcc-libs mingw-w64-i686-gcc-libgfortran mingw-w64-i686-freetype mingw-w64-i686-libharu mingw-w64-i686-lua mingw-w64-i686-python2 mingw-w64-i686-python2-numpy mingw-w64-i686-shapelib mingw-w64-i686-tk mingw-w64-i686-wxWidgets ];
  };

  "mingw-w64-i686-png2ico" = fetch {
    name        = "mingw-w64-i686-png2ico";
    version     = "2002.12.08";
    filename    = "mingw-w64-i686-png2ico-2002.12.08-2-any.pkg.tar.xz";
    sha256      = "30b38ada9bd1bb5141e956d0ba0306f2a60ed2746b4ac54c56c0a8874b65ee2a";
    buildInputs = [  ];
  };

  "mingw-w64-i686-pngcrush" = fetch {
    name        = "mingw-w64-i686-pngcrush";
    version     = "1.8.13";
    filename    = "mingw-w64-i686-pngcrush-1.8.13-1-any.pkg.tar.xz";
    sha256      = "27062b33489149b0fc5a17a3fe4e7526ddbf9e1cf68c57847ac511012b3ca22a";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libpng mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-pngnq" = fetch {
    name        = "mingw-w64-i686-pngnq";
    version     = "1.1";
    filename    = "mingw-w64-i686-pngnq-1.1-2-any.pkg.tar.xz";
    sha256      = "d27d2c69fcf0a5151384cdb2a5b97be7cf17f5d47d5cf95742b0e9a6a192cab2";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libpng mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-poco" = fetch {
    name        = "mingw-w64-i686-poco";
    version     = "1.9.0";
    filename    = "mingw-w64-i686-poco-1.9.0-1-any.pkg.tar.xz";
    sha256      = "a4f362f6e86c672b12ff1c9ed508b1024c38621c0cb2f80f3333c01c63a2af0e";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-expat mingw-w64-i686-libmariadbclient mingw-w64-i686-openssl mingw-w64-i686-pcre mingw-w64-i686-sqlite3 mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-podofo" = fetch {
    name        = "mingw-w64-i686-podofo";
    version     = "0.9.6";
    filename    = "mingw-w64-i686-podofo-0.9.6-1-any.pkg.tar.xz";
    sha256      = "de7607d5a1264b5af1d12a573aefa56cdaa85b301baae6e61216da8a44269d91";
    buildInputs = [ mingw-w64-i686-fontconfig mingw-w64-i686-libtiff mingw-w64-i686-libidn mingw-w64-i686-libjpeg-turbo mingw-w64-i686-lua mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-polipo" = fetch {
    name        = "mingw-w64-i686-polipo";
    version     = "1.1.1";
    filename    = "mingw-w64-i686-polipo-1.1.1-1-any.pkg.tar.xz";
    sha256      = "90445206dbc4b497720efdb02606f7056d00d280b0c6f8e32b8a7ebc65a7387d";
  };

  "mingw-w64-i686-polly" = fetch {
    name        = "mingw-w64-i686-polly";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-polly-7.0.1-1-any.pkg.tar.xz";
    sha256      = "ba889176a6d3e4d5c57081eb05ee3fcc4d57df2ad693f4e832c2a56e2fcc62a8";
    buildInputs = [ (assert mingw-w64-i686-llvm.version=="7.0.1"; mingw-w64-i686-llvm) ];
  };

  "mingw-w64-i686-poppler" = fetch {
    name        = "mingw-w64-i686-poppler";
    version     = "0.73.0";
    filename    = "mingw-w64-i686-poppler-0.73.0-1-any.pkg.tar.xz";
    sha256      = "53c138f9cd3672db2f9ef843cc86cba42626346416546fee0ca167bbf2ab0276";
    buildInputs = [ mingw-w64-i686-cairo mingw-w64-i686-curl mingw-w64-i686-freetype mingw-w64-i686-icu mingw-w64-i686-lcms2 mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-nss mingw-w64-i686-openjpeg2 mingw-w64-i686-poppler-data mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-poppler -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-poppler-data" = fetch {
    name        = "mingw-w64-i686-poppler-data";
    version     = "0.4.9";
    filename    = "mingw-w64-i686-poppler-data-0.4.9-1-any.pkg.tar.xz";
    sha256      = "6b1d212660be9466eb760cf7db9542056e48e6063636ff053b464f9045aab753";
  };

  "mingw-w64-i686-poppler-qt4" = fetch {
    name        = "mingw-w64-i686-poppler-qt4";
    version     = "0.36.0";
    filename    = "mingw-w64-i686-poppler-qt4-0.36.0-1-any.pkg.tar.xz";
    sha256      = "8b9a9f09d2869b27e784b34f658b1384c9e01c2181cd6535bd96b88a8ec737e2";
    buildInputs = [ mingw-w64-i686-cairo mingw-w64-i686-curl mingw-w64-i686-freetype mingw-w64-i686-icu mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-openjpeg mingw-w64-i686-poppler-data mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-poppler-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-popt" = fetch {
    name        = "mingw-w64-i686-popt";
    version     = "1.16";
    filename    = "mingw-w64-i686-popt-1.16-1-any.pkg.tar.xz";
    sha256      = "5560dbe8508eac9e20a5e5254373cfcd3934c8fcb07e5d4c2a48eb009aaad76f";
    buildInputs = [ mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-port-scanner" = fetch {
    name        = "mingw-w64-i686-port-scanner";
    version     = "1.3";
    filename    = "mingw-w64-i686-port-scanner-1.3-2-any.pkg.tar.xz";
    sha256      = "fa04ea693495a4fa1ccac36d194c85a33106e1a6750bab7aed80fe660a628897";
  };

  "mingw-w64-i686-portablexdr" = fetch {
    name        = "mingw-w64-i686-portablexdr";
    version     = "4.9.2.r27.94fb83c";
    filename    = "mingw-w64-i686-portablexdr-4.9.2.r27.94fb83c-2-any.pkg.tar.xz";
    sha256      = "00ce17d810107c13621a2bcf19bd49bd29ca107b6a0d32505f4dde6c22660b5b";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-portaudio" = fetch {
    name        = "mingw-w64-i686-portaudio";
    version     = "190600_20161030";
    filename    = "mingw-w64-i686-portaudio-190600_20161030-3-any.pkg.tar.xz";
    sha256      = "ec13d7af871a27228c17a8a6b0b583cdf49d130440c224be515e313e44a06064";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-portmidi" = fetch {
    name        = "mingw-w64-i686-portmidi";
    version     = "217";
    filename    = "mingw-w64-i686-portmidi-217-2-any.pkg.tar.xz";
    sha256      = "d8b490c771b8c80d459e8ae4ba3634351b32715aff05d3819d731a728cf60b01";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-postgis" = fetch {
    name        = "mingw-w64-i686-postgis";
    version     = "2.5.1";
    filename    = "mingw-w64-i686-postgis-2.5.1-1-any.pkg.tar.xz";
    sha256      = "b0a4f0648ab45d17f4d47f375060bf713fe01616765166bb8ac0232b37a0d594";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gdal mingw-w64-i686-geos mingw-w64-i686-gettext mingw-w64-i686-json-c mingw-w64-i686-libxml2 mingw-w64-i686-postgresql mingw-w64-i686-proj ];
    broken      = true; # broken dependency mingw-w64-i686-libgeotiff -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-postgresql" = fetch {
    name        = "mingw-w64-i686-postgresql";
    version     = "11.1";
    filename    = "mingw-w64-i686-postgresql-11.1-1-any.pkg.tar.xz";
    sha256      = "cf9732b303591454d44659671ecf4fd8b85e95da0a877805248a3cd01619550d";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-openssl mingw-w64-i686-python2 mingw-w64-i686-tcl mingw-w64-i686-zlib winpty ];
  };

  "mingw-w64-i686-postr" = fetch {
    name        = "mingw-w64-i686-postr";
    version     = "0.13.1";
    filename    = "mingw-w64-i686-postr-0.13.1-1-any.pkg.tar.xz";
    sha256      = "fdd646f377fc6773c52d2edf2b13e096f8a6d71b1586e0183308f6503122d39b";
    buildInputs = [ mingw-w64-i686-python2-pygtk ];
  };

  "mingw-w64-i686-potrace" = fetch {
    name        = "mingw-w64-i686-potrace";
    version     = "1.15";
    filename    = "mingw-w64-i686-potrace-1.15-2-any.pkg.tar.xz";
    sha256      = "c613138337aa42281d1f9691d6c2a3692eed9f2cb24cbe33bd815a9120c166dc";
  };

  "mingw-w64-i686-premake" = fetch {
    name        = "mingw-w64-i686-premake";
    version     = "4.3";
    filename    = "mingw-w64-i686-premake-4.3-2-any.pkg.tar.xz";
    sha256      = "3c9da70d22bf010300aea91b10033a0106cdbf43e348d0f45e352e784b16f8f7";
  };

  "mingw-w64-i686-proj" = fetch {
    name        = "mingw-w64-i686-proj";
    version     = "5.2.0";
    filename    = "mingw-w64-i686-proj-5.2.0-1-any.pkg.tar.xz";
    sha256      = "bc3cc401a4f1b3e1f93156ad43be99ede00a14a6ab33287a644ce2e1dadfe678";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-protobuf" = fetch {
    name        = "mingw-w64-i686-protobuf";
    version     = "3.6.1.3";
    filename    = "mingw-w64-i686-protobuf-3.6.1.3-1-any.pkg.tar.xz";
    sha256      = "dba419c2182abfb70699c09077e6f0720d135901d4f727bd8a11090a9668b059";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-protobuf-c" = fetch {
    name        = "mingw-w64-i686-protobuf-c";
    version     = "1.3.1";
    filename    = "mingw-w64-i686-protobuf-c-1.3.1-1-any.pkg.tar.xz";
    sha256      = "fd4d586b1b68eeab627873e049b2ffb51beebbc943f93ad6578dfe96f8d44967";
    buildInputs = [ mingw-w64-i686-protobuf ];
  };

  "mingw-w64-i686-ptex" = fetch {
    name        = "mingw-w64-i686-ptex";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-ptex-2.3.0-1-any.pkg.tar.xz";
    sha256      = "6f3b43b4ea3945e2b539ba45bec29f6c2024984f0f1f99a39c4343375a5a8e16";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib mingw-w64-i686-winpthreads-git ];
  };

  "mingw-w64-i686-pugixml" = fetch {
    name        = "mingw-w64-i686-pugixml";
    version     = "1.9";
    filename    = "mingw-w64-i686-pugixml-1.9-1-any.pkg.tar.xz";
    sha256      = "610c254e1830ad34d4a08f27bc8480299bb478602e9d843208450fb9956ef9e8";
  };

  "mingw-w64-i686-pupnp" = fetch {
    name        = "mingw-w64-i686-pupnp";
    version     = "1.6.25";
    filename    = "mingw-w64-i686-pupnp-1.6.25-1-any.pkg.tar.xz";
    sha256      = "a41a4f970b05fc5e5b7490e2fb90f25dff84f2884806fb616eb286be7b2f1341";
  };

  "mingw-w64-i686-purple-facebook" = fetch {
    name        = "mingw-w64-i686-purple-facebook";
    version     = "20160907.66ee773.bf8ed95";
    filename    = "mingw-w64-i686-purple-facebook-20160907.66ee773.bf8ed95-1-any.pkg.tar.xz";
    sha256      = "dd486b50007fafe5a471f07d877b36f154653c7914116d72094c6fcbb7814984";
    buildInputs = [ mingw-w64-i686-libpurple mingw-w64-i686-json-glib mingw-w64-i686-glib2 mingw-w64-i686-zlib mingw-w64-i686-gettext mingw-w64-i686-gcc-libs ];
    broken      = true; # broken dependency mingw-w64-i686-purple-facebook -> mingw-w64-i686-libpurple
  };

  "mingw-w64-i686-purple-hangouts-hg" = fetch {
    name        = "mingw-w64-i686-purple-hangouts-hg";
    version     = "r287+.574c112aa35c+";
    filename    = "mingw-w64-i686-purple-hangouts-hg-r287+.574c112aa35c+-1-any.pkg.tar.xz";
    sha256      = "ca542909f72fd9bf50482dc80144a1b98cecac3c92825ebb59de91a7dae0a751";
    buildInputs = [ mingw-w64-i686-libpurple mingw-w64-i686-protobuf-c mingw-w64-i686-json-glib mingw-w64-i686-glib2 mingw-w64-i686-zlib mingw-w64-i686-gettext mingw-w64-i686-gcc-libs ];
    broken      = true; # broken dependency mingw-w64-i686-purple-hangouts-hg -> mingw-w64-i686-libpurple
  };

  "mingw-w64-i686-purple-skypeweb" = fetch {
    name        = "mingw-w64-i686-purple-skypeweb";
    version     = "1.1";
    filename    = "mingw-w64-i686-purple-skypeweb-1.1-1-any.pkg.tar.xz";
    sha256      = "6dabfd5f4ef053fdfabc678352508d6069a1f4571fcd53f212edfc00d268fed5";
    buildInputs = [ mingw-w64-i686-libpurple mingw-w64-i686-json-glib mingw-w64-i686-glib2 mingw-w64-i686-zlib mingw-w64-i686-gettext mingw-w64-i686-gcc-libs ];
    broken      = true; # broken dependency mingw-w64-i686-purple-skypeweb -> mingw-w64-i686-libpurple
  };

  "mingw-w64-i686-putty" = fetch {
    name        = "mingw-w64-i686-putty";
    version     = "0.70";
    filename    = "mingw-w64-i686-putty-0.70-1-any.pkg.tar.xz";
    sha256      = "050b0856c32d6abc05f2e5dc2b2b46287d2e5b5e26b8563ff55f42d8de21aaa6";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-putty-ssh" = fetch {
    name        = "mingw-w64-i686-putty-ssh";
    version     = "0.0";
    filename    = "mingw-w64-i686-putty-ssh-0.0-3-any.pkg.tar.xz";
    sha256      = "86176423007f5314f3981c9dc86a343ec6af95ee34c89b68816ce2d46da432ec";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-putty ];
  };

  "mingw-w64-i686-pybind11" = fetch {
    name        = "mingw-w64-i686-pybind11";
    version     = "2.2.4";
    filename    = "mingw-w64-i686-pybind11-2.2.4-1-any.pkg.tar.xz";
    sha256      = "000c9ab34ec9bfc792d4343ad034d4a71375718f9e81f35aa3ac4736ef5897ce";
  };

  "mingw-w64-i686-pygobject-devel" = fetch {
    name        = "mingw-w64-i686-pygobject-devel";
    version     = "3.30.4";
    filename    = "mingw-w64-i686-pygobject-devel-3.30.4-1-any.pkg.tar.xz";
    sha256      = "a8eba64f64d6172033798c73b186b523e6dcd80b6e1bcc7c9d6b51251192f4f6";
    buildInputs = [  ];
  };

  "mingw-w64-i686-pygobject2-devel" = fetch {
    name        = "mingw-w64-i686-pygobject2-devel";
    version     = "2.28.7";
    filename    = "mingw-w64-i686-pygobject2-devel-2.28.7-1-any.pkg.tar.xz";
    sha256      = "ef2132dcee91cf74e2daea558088246f03fc3d99084578a6f253956a518dc643";
    buildInputs = [  ];
  };

  "mingw-w64-i686-pyilmbase" = fetch {
    name        = "mingw-w64-i686-pyilmbase";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-pyilmbase-2.3.0-1-any.pkg.tar.xz";
    sha256      = "72e14b564f90959f279db5510448e99cad992c15cd5abd0915638dc9c734b8a4";
    buildInputs = [ (assert mingw-w64-i686-openexr.version=="2.3.0"; mingw-w64-i686-openexr) mingw-w64-i686-boost mingw-w64-i686-python2-numpy ];
  };

  "mingw-w64-i686-pyqt4-common" = fetch {
    name        = "mingw-w64-i686-pyqt4-common";
    version     = "4.11.4";
    filename    = "mingw-w64-i686-pyqt4-common-4.11.4-2-any.pkg.tar.xz";
    sha256      = "48ace31b39e67aeea3b0cba37a62e868a57f4c879298a0b0069894f2fb27410f";
    buildInputs = [ mingw-w64-i686-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-pyqt5-common" = fetch {
    name        = "mingw-w64-i686-pyqt5-common";
    version     = "5.11.3";
    filename    = "mingw-w64-i686-pyqt5-common-5.11.3-1-any.pkg.tar.xz";
    sha256      = "6b47bfb21dc0547645fe6edb68f1f4efd6690fab42306879da1042b3a7a0bf23";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-qtwebkit ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-pyrex" = fetch {
    name        = "mingw-w64-i686-pyrex";
    version     = "0.9.9";
    filename    = "mingw-w64-i686-pyrex-0.9.9-1-any.pkg.tar.xz";
    sha256      = "b7a5ede82d2b5a45e0e7561b80535686c1b89fe4d4e2041ac13270bc7205269b";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-pyside-common-qt4" = fetch {
    name        = "mingw-w64-i686-pyside-common-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-pyside-common-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "25a6e46c5cbb0d3c4187361e637e699c5b74ba8975d9debb421e47ed3d0862fa";
  };

  "mingw-w64-i686-pyside-tools-common-qt4" = fetch {
    name        = "mingw-w64-i686-pyside-tools-common-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-pyside-tools-common-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "dc3a19951196885b0278a7899c9d1be8fd1b1d24fc3425906389a61f6877760e";
    buildInputs = [ mingw-w64-i686-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python-lxml-docs" = fetch {
    name        = "mingw-w64-i686-python-lxml-docs";
    version     = "4.3.0";
    filename    = "mingw-w64-i686-python-lxml-docs-4.3.0-1-any.pkg.tar.xz";
    sha256      = "6d7aeed08d15c6da25c3d423dfce83749167bc77f31f26358c6b7f86d000bc1b";
  };

  "mingw-w64-i686-python-qscintilla-common" = fetch {
    name        = "mingw-w64-i686-python-qscintilla-common";
    version     = "2.10.8";
    filename    = "mingw-w64-i686-python-qscintilla-common-2.10.8-1-any.pkg.tar.xz";
    sha256      = "d8e813300f517ae705155f599d58fc3e45af23182cfc87086b39bee6069abdad";
    buildInputs = [ mingw-w64-i686-qscintilla ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-python2" = fetch {
    name        = "mingw-w64-i686-python2";
    version     = "2.7.15";
    filename    = "mingw-w64-i686-python2-2.7.15-3-any.pkg.tar.xz";
    sha256      = "4a2aec2864e9191d18f16a8f17c4c14e9559b46fc0388d9699073ac48e7e4f9d";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-expat mingw-w64-i686-bzip2 mingw-w64-i686-libffi mingw-w64-i686-ncurses mingw-w64-i686-openssl mingw-w64-i686-readline mingw-w64-i686-tcl mingw-w64-i686-tk mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-python2-PyOpenGL" = fetch {
    name        = "mingw-w64-i686-python2-PyOpenGL";
    version     = "3.1.0";
    filename    = "mingw-w64-i686-python2-PyOpenGL-3.1.0-1-any.pkg.tar.xz";
    sha256      = "e45e1f1c520dec3c1714aa260ccf981340b1951cc7b1f9da12d2bfc6a56651b6";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-alembic" = fetch {
    name        = "mingw-w64-i686-python2-alembic";
    version     = "1.0.5";
    filename    = "mingw-w64-i686-python2-alembic-1.0.5-1-any.pkg.tar.xz";
    sha256      = "6bf66fcac8ba39acfcafe28f542b83d26276ea9ff8462c35b86a9008eabd942d";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-mako mingw-w64-i686-python2-sqlalchemy mingw-w64-i686-python2-editor mingw-w64-i686-python2-dateutil ];
  };

  "mingw-w64-i686-python2-apipkg" = fetch {
    name        = "mingw-w64-i686-python2-apipkg";
    version     = "1.5";
    filename    = "mingw-w64-i686-python2-apipkg-1.5-1-any.pkg.tar.xz";
    sha256      = "23b1bc86821f3c4f246534279187b71e159757dba9632ccc27a5668f0b2038fc";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-appdirs" = fetch {
    name        = "mingw-w64-i686-python2-appdirs";
    version     = "1.4.3";
    filename    = "mingw-w64-i686-python2-appdirs-1.4.3-3-any.pkg.tar.xz";
    sha256      = "17cd4c2db6b95187cbb540bf007f0bbd98f3ead4114f31c87d62541c8281f5b0";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-argh" = fetch {
    name        = "mingw-w64-i686-python2-argh";
    version     = "0.26.2";
    filename    = "mingw-w64-i686-python2-argh-0.26.2-1-any.pkg.tar.xz";
    sha256      = "5b235609b367664b94db48cff650ef51553d58fb83602440ddf87d8b2275e3b2";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-argon2_cffi" = fetch {
    name        = "mingw-w64-i686-python2-argon2_cffi";
    version     = "18.3.0";
    filename    = "mingw-w64-i686-python2-argon2_cffi-18.3.0-1-any.pkg.tar.xz";
    sha256      = "68601a1122b05094c29853ea4b8cb4e0fd7273e9570ea61d5a0b3fb0bdce0fd0";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-cffi mingw-w64-i686-python2-enum mingw-w64-i686-python2-setuptools mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-asn1crypto" = fetch {
    name        = "mingw-w64-i686-python2-asn1crypto";
    version     = "0.24.0";
    filename    = "mingw-w64-i686-python2-asn1crypto-0.24.0-2-any.pkg.tar.xz";
    sha256      = "2059daa6422f0f7e00d055c0bc0696d688b6c89b135a08c5b3ca200d9813dd68";
    buildInputs = [ mingw-w64-i686-python2-pycparser ];
  };

  "mingw-w64-i686-python2-astroid" = fetch {
    name        = "mingw-w64-i686-python2-astroid";
    version     = "1.6.5";
    filename    = "mingw-w64-i686-python2-astroid-1.6.5-2-any.pkg.tar.xz";
    sha256      = "71f259868e77b9e0c5245b5cea13a3cd2af3bb14cc9802a0308e4856c5586a55";
    buildInputs = [ mingw-w64-i686-python2-six mingw-w64-i686-python2-lazy-object-proxy mingw-w64-i686-python2-wrapt mingw-w64-i686-python2-singledispatch mingw-w64-i686-python2-enum34 self."mingw-w64-i686-python2-backports.functools_lru_cache" ];
  };

  "mingw-w64-i686-python2-atomicwrites" = fetch {
    name        = "mingw-w64-i686-python2-atomicwrites";
    version     = "1.2.1";
    filename    = "mingw-w64-i686-python2-atomicwrites-1.2.1-1-any.pkg.tar.xz";
    sha256      = "71611a507f1d5d5bd517339f41d3a21dc051a3dcacdddebc26759e0103169cba";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-attrs" = fetch {
    name        = "mingw-w64-i686-python2-attrs";
    version     = "18.2.0";
    filename    = "mingw-w64-i686-python2-attrs-18.2.0-1-any.pkg.tar.xz";
    sha256      = "aa7f43093b9f645e87f4cc074aaef934b6482f92ecffcd0f3b76486a2e475bc6";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-babel" = fetch {
    name        = "mingw-w64-i686-python2-babel";
    version     = "2.6.0";
    filename    = "mingw-w64-i686-python2-babel-2.6.0-3-any.pkg.tar.xz";
    sha256      = "0063c897dec7a3b057647e538141d01039d7ae525de55a50085eaf97627435f1";
    buildInputs = [ mingw-w64-i686-python2-pytz ];
  };

  "mingw-w64-i686-python2-backcall" = fetch {
    name        = "mingw-w64-i686-python2-backcall";
    version     = "0.1.0";
    filename    = "mingw-w64-i686-python2-backcall-0.1.0-2-any.pkg.tar.xz";
    sha256      = "e5c9ed86a1d1053ce272ff3f23a8383c8d0f0bb96ea1fe8ab98888aecd32e16f";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-backports" = fetch {
    name        = "mingw-w64-i686-python2-backports";
    version     = "1.0";
    filename    = "mingw-w64-i686-python2-backports-1.0-1-any.pkg.tar.xz";
    sha256      = "09b6c9cb87bb30612613775248b46155c53232180a29ba97105a9d315173cddd";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-backports-abc" = fetch {
    name        = "mingw-w64-i686-python2-backports-abc";
    version     = "0.5";
    filename    = "mingw-w64-i686-python2-backports-abc-0.5-1-any.pkg.tar.xz";
    sha256      = "2a8eb9fc7285ac57e6d147fece84eaff9a617f128f2d853e7e70c352a7ecdb9f";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-backports.functools_lru_cache" = fetch {
    name        = "mingw-w64-i686-python2-backports.functools_lru_cache";
    version     = "1.5";
    filename    = "mingw-w64-i686-python2-backports.functools_lru_cache-1.5-1-any.pkg.tar.xz";
    sha256      = "89c9dff78760af6b9478f40ae395e6bd2a99fdb173be2a8aadf4b8a38441b426";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-backports.os" = fetch {
    name        = "mingw-w64-i686-python2-backports.os";
    version     = "0.1.1";
    filename    = "mingw-w64-i686-python2-backports.os-0.1.1-1-any.pkg.tar.xz";
    sha256      = "e951590b21040258da46c9b002c519b539a3b8bec8b9017bdfa27aaa86106c8e";
    buildInputs = [ mingw-w64-i686-python2-backports mingw-w64-i686-python2-future ];
  };

  "mingw-w64-i686-python2-backports.shutil_get_terminal_size" = fetch {
    name        = "mingw-w64-i686-python2-backports.shutil_get_terminal_size";
    version     = "1.0.0";
    filename    = "mingw-w64-i686-python2-backports.shutil_get_terminal_size-1.0.0-1-any.pkg.tar.xz";
    sha256      = "0f7fd97240b675a26b9eb552f6baa2fd57e0b6cf144cec30e0b46cb13f9f9e50";
    buildInputs = [ mingw-w64-i686-python2-backports ];
  };

  "mingw-w64-i686-python2-backports.ssl_match_hostname" = fetch {
    name        = "mingw-w64-i686-python2-backports.ssl_match_hostname";
    version     = "3.5.0.1";
    filename    = "mingw-w64-i686-python2-backports.ssl_match_hostname-3.5.0.1-1-any.pkg.tar.xz";
    sha256      = "70df5ec4247fcde3f7752bdac95c79993eb234c8f539c28cceb9038a157e01b0";
    buildInputs = [ mingw-w64-i686-python2-backports ];
  };

  "mingw-w64-i686-python2-bcrypt" = fetch {
    name        = "mingw-w64-i686-python2-bcrypt";
    version     = "3.1.5";
    filename    = "mingw-w64-i686-python2-bcrypt-3.1.5-1-any.pkg.tar.xz";
    sha256      = "5091f44b1d21810a35c44ec63731ff2810dc026725d777107c3ed37806b00cd7";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-beaker" = fetch {
    name        = "mingw-w64-i686-python2-beaker";
    version     = "1.10.0";
    filename    = "mingw-w64-i686-python2-beaker-1.10.0-2-any.pkg.tar.xz";
    sha256      = "264efdb76fb10549289064040a00912d5fd7b2fca00ae365742f1bc639169fe3";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-beautifulsoup3" = fetch {
    name        = "mingw-w64-i686-python2-beautifulsoup3";
    version     = "3.2.1";
    filename    = "mingw-w64-i686-python2-beautifulsoup3-3.2.1-2-any.pkg.tar.xz";
    sha256      = "f1e60ad24db56d38a8566b05586fe27a54fee165f2ec8ea6b3203b3cd4bf73a0";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-beautifulsoup4" = fetch {
    name        = "mingw-w64-i686-python2-beautifulsoup4";
    version     = "4.7.0";
    filename    = "mingw-w64-i686-python2-beautifulsoup4-4.7.0-1-any.pkg.tar.xz";
    sha256      = "63e96b4cf8f4ba07fdb6efe8d8f6618292a4eda26e2b4f137bb39fd94c65ab40";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-soupsieve ];
  };

  "mingw-w64-i686-python2-biopython" = fetch {
    name        = "mingw-w64-i686-python2-biopython";
    version     = "1.73";
    filename    = "mingw-w64-i686-python2-biopython-1.73-1-any.pkg.tar.xz";
    sha256      = "109efec3acd0161edaf0af741e6acdb7e0117793101d43351b0e0b749f10988e";
    buildInputs = [ mingw-w64-i686-python2-numpy ];
  };

  "mingw-w64-i686-python2-bleach" = fetch {
    name        = "mingw-w64-i686-python2-bleach";
    version     = "3.0.2";
    filename    = "mingw-w64-i686-python2-bleach-3.0.2-1-any.pkg.tar.xz";
    sha256      = "049b5d536f25420755bdc81b167658de4a015301519de02f1ee2eababc3916f7";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-html5lib ];
  };

  "mingw-w64-i686-python2-breathe" = fetch {
    name        = "mingw-w64-i686-python2-breathe";
    version     = "4.11.1";
    filename    = "mingw-w64-i686-python2-breathe-4.11.1-1-any.pkg.tar.xz";
    sha256      = "20aa6a2edff638edbb4ce338ddb95266824016e25feae6880d18d3ee192da4bc";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-brotli" = fetch {
    name        = "mingw-w64-i686-python2-brotli";
    version     = "1.0.7";
    filename    = "mingw-w64-i686-python2-brotli-1.0.7-1-any.pkg.tar.xz";
    sha256      = "f8907329617d59dadc64bcdcd251a5e49a02e10c1131c8981217f9780c95b2dc";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-libwinpthread-git ];
  };

  "mingw-w64-i686-python2-bsddb3" = fetch {
    name        = "mingw-w64-i686-python2-bsddb3";
    version     = "6.1.0";
    filename    = "mingw-w64-i686-python2-bsddb3-6.1.0-3-any.pkg.tar.xz";
    sha256      = "aa7ff2aec20b2a24b15ff4140149458eeaf64410184043da836912e3dbfb8dd6";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-db ];
  };

  "mingw-w64-i686-python2-cachecontrol" = fetch {
    name        = "mingw-w64-i686-python2-cachecontrol";
    version     = "0.12.5";
    filename    = "mingw-w64-i686-python2-cachecontrol-0.12.5-1-any.pkg.tar.xz";
    sha256      = "115b68e48c840b3f93979a425d1cd20839fe5415c85bc4c44675020e7f31f20b";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-msgpack mingw-w64-i686-python2-requests ];
  };

  "mingw-w64-i686-python2-cairo" = fetch {
    name        = "mingw-w64-i686-python2-cairo";
    version     = "1.18.0";
    filename    = "mingw-w64-i686-python2-cairo-1.18.0-1-any.pkg.tar.xz";
    sha256      = "66c41b4ce7b2e86df16805f914a5dcd1fd24fccea8987008fa063715a83a453f";
    buildInputs = [ mingw-w64-i686-cairo mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-can" = fetch {
    name        = "mingw-w64-i686-python2-can";
    version     = "3.0.0";
    filename    = "mingw-w64-i686-python2-can-3.0.0-1-any.pkg.tar.xz";
    sha256      = "f63220a778d5683012fc53d6ad1b32ddeb33db388cb93263fae69aecd62d7fba";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-python_ics mingw-w64-i686-python2-pyserial ];
  };

  "mingw-w64-i686-python2-capstone" = fetch {
    name        = "mingw-w64-i686-python2-capstone";
    version     = "4.0";
    filename    = "mingw-w64-i686-python2-capstone-4.0-1-any.pkg.tar.xz";
    sha256      = "c34108e40e110ed8274840dd15cd96c81fec437862be3d5647ddf61d96c67b27";
    buildInputs = [ mingw-w64-i686-capstone mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-certifi" = fetch {
    name        = "mingw-w64-i686-python2-certifi";
    version     = "2018.11.29";
    filename    = "mingw-w64-i686-python2-certifi-2018.11.29-2-any.pkg.tar.xz";
    sha256      = "940ffba6577c30773442a2239680bb1632c756848e4b4e6c6bb56485b0c6b78a";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-cffi" = fetch {
    name        = "mingw-w64-i686-python2-cffi";
    version     = "1.11.5";
    filename    = "mingw-w64-i686-python2-cffi-1.11.5-2-any.pkg.tar.xz";
    sha256      = "2d06957ef27085a1424b9c92640eb482f9409c424755b401ae785b71c089334e";
    buildInputs = [ mingw-w64-i686-python2-pycparser ];
  };

  "mingw-w64-i686-python2-characteristic" = fetch {
    name        = "mingw-w64-i686-python2-characteristic";
    version     = "14.3.0";
    filename    = "mingw-w64-i686-python2-characteristic-14.3.0-3-any.pkg.tar.xz";
    sha256      = "19fbabafa9d6b6ba1b30a3bcfdad8040af26b09fdae2fe0f88e15a619c650020";
  };

  "mingw-w64-i686-python2-chardet" = fetch {
    name        = "mingw-w64-i686-python2-chardet";
    version     = "3.0.4";
    filename    = "mingw-w64-i686-python2-chardet-3.0.4-2-any.pkg.tar.xz";
    sha256      = "62a34c11a22d61d28839166a0e30b4a104bcc5abd2e308daafacfa082c93983d";
    buildInputs = [ mingw-w64-i686-python2-setuptools ];
  };

  "mingw-w64-i686-python2-cjson" = fetch {
    name        = "mingw-w64-i686-python2-cjson";
    version     = "1.2.1";
    filename    = "mingw-w64-i686-python2-cjson-1.2.1-1-any.pkg.tar.xz";
    sha256      = "49643ec6a055529aea94853b34bd364b3ff80d97464f784ef2df27c10cd5029f";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-cliff" = fetch {
    name        = "mingw-w64-i686-python2-cliff";
    version     = "2.14.0";
    filename    = "mingw-w64-i686-python2-cliff-2.14.0-1-any.pkg.tar.xz";
    sha256      = "eb688d2372bacbba257d4f9787c0637d78849b9ce3668c552faf25bae8f0fa43";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-pbr mingw-w64-i686-python2-cmd2 mingw-w64-i686-python2-prettytable mingw-w64-i686-python2-pyparsing mingw-w64-i686-python2-stevedore mingw-w64-i686-python2-unicodecsv mingw-w64-i686-python2-yaml ];
  };

  "mingw-w64-i686-python2-cmd2" = fetch {
    name        = "mingw-w64-i686-python2-cmd2";
    version     = "0.8.9";
    filename    = "mingw-w64-i686-python2-cmd2-0.8.9-1-any.pkg.tar.xz";
    sha256      = "dcf25aaf58ea38e8fc74b2c51038cb9474bb025b78a20603751ce1c0f2d9ae59";
    buildInputs = [ mingw-w64-i686-python2-pyparsing mingw-w64-i686-python2-pyperclip mingw-w64-i686-python2-colorama mingw-w64-i686-python2-contextlib2 mingw-w64-i686-python2-enum34 mingw-w64-i686-python2-wcwidth mingw-w64-i686-python2-subprocess32 ];
  };

  "mingw-w64-i686-python2-colorama" = fetch {
    name        = "mingw-w64-i686-python2-colorama";
    version     = "0.4.1";
    filename    = "mingw-w64-i686-python2-colorama-0.4.1-1-any.pkg.tar.xz";
    sha256      = "e0af8fd42e7ee077c0bc93ee0e428434753071ba61bedaa9c1aedd74bfa2c841";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-colorspacious" = fetch {
    name        = "mingw-w64-i686-python2-colorspacious";
    version     = "1.1.2";
    filename    = "mingw-w64-i686-python2-colorspacious-1.1.2-2-any.pkg.tar.xz";
    sha256      = "da404ff0c59520f4dfd483467fdbbc30c878317335bc502ba355b17a5e2d4c9a";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-colour" = fetch {
    name        = "mingw-w64-i686-python2-colour";
    version     = "0.3.11";
    filename    = "mingw-w64-i686-python2-colour-0.3.11-1-any.pkg.tar.xz";
    sha256      = "5511ece62cb221623f5cec7ec4f546b0a4a522333724fc061ee894f144db3f4e";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-comtypes" = fetch {
    name        = "mingw-w64-i686-python2-comtypes";
    version     = "1.1.7";
    filename    = "mingw-w64-i686-python2-comtypes-1.1.7-1-any.pkg.tar.xz";
    sha256      = "62c126c3a80a7ea80a5555b0321f116a1c705588c36531ef3d8981c87cad4c35";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-configparser" = fetch {
    name        = "mingw-w64-i686-python2-configparser";
    version     = "3.5.0";
    filename    = "mingw-w64-i686-python2-configparser-3.5.0-3-any.pkg.tar.xz";
    sha256      = "4dd758e1ec2b6582b07831dbd0555bab13c4fff9f9353c1767db010fcae21fc1";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-backports ];
  };

  "mingw-w64-i686-python2-contextlib2" = fetch {
    name        = "mingw-w64-i686-python2-contextlib2";
    version     = "0.5.5";
    filename    = "mingw-w64-i686-python2-contextlib2-0.5.5-1-any.pkg.tar.xz";
    sha256      = "274b187b630ea8fd2b7b969c5986b113b510fd2be7e6d5da4be52d08d0cb81e7";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-coverage" = fetch {
    name        = "mingw-w64-i686-python2-coverage";
    version     = "4.5.2";
    filename    = "mingw-w64-i686-python2-coverage-4.5.2-1-any.pkg.tar.xz";
    sha256      = "19db8ad7795c377f0f3f52d8a18721df909731cad2e686ca90912213e92be4ca";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-crcmod" = fetch {
    name        = "mingw-w64-i686-python2-crcmod";
    version     = "1.7";
    filename    = "mingw-w64-i686-python2-crcmod-1.7-2-any.pkg.tar.xz";
    sha256      = "8ce4c01178980201a2fea349925c114f40ac7ba96f5dd641f47141d510b11441";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-cryptography" = fetch {
    name        = "mingw-w64-i686-python2-cryptography";
    version     = "2.4.2";
    filename    = "mingw-w64-i686-python2-cryptography-2.4.2-1-any.pkg.tar.xz";
    sha256      = "e174b714090d39494bd42debfb319b4cb4f8b89c47f37dee3c203bf02247a180";
    buildInputs = [ mingw-w64-i686-python2-cffi mingw-w64-i686-python2-pyasn1 mingw-w64-i686-python2-idna mingw-w64-i686-python2-asn1crypto ];
  };

  "mingw-w64-i686-python2-cssselect" = fetch {
    name        = "mingw-w64-i686-python2-cssselect";
    version     = "1.0.3";
    filename    = "mingw-w64-i686-python2-cssselect-1.0.3-2-any.pkg.tar.xz";
    sha256      = "7d0cd90de3093ee080336e95f0b65a3e395022a3af86cd2409d878a0607c91ab";
    buildInputs = [ mingw-w64-i686-python2 ];
    broken      = true; # broken dependency mingw-w64-i686-python2-cssselect -> mingw-w64-i686-python2>
  };

  "mingw-w64-i686-python2-cvxopt" = fetch {
    name        = "mingw-w64-i686-python2-cvxopt";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-python2-cvxopt-1.2.2-1-any.pkg.tar.xz";
    sha256      = "f716b2d29d54e1735c9e542f691a6dcb9f7b85c4ca474564b678cd2e5cb91a32";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-cx_Freeze" = fetch {
    name        = "mingw-w64-i686-python2-cx_Freeze";
    version     = "5.1.1";
    filename    = "mingw-w64-i686-python2-cx_Freeze-5.1.1-3-any.pkg.tar.xz";
    sha256      = "8c4ffc4b83fde9b3f6def6ffaf5a7a58afd1bcdcea7ac18d7fd42ecaa8b1db40";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-cycler" = fetch {
    name        = "mingw-w64-i686-python2-cycler";
    version     = "0.10.0";
    filename    = "mingw-w64-i686-python2-cycler-0.10.0-3-any.pkg.tar.xz";
    sha256      = "4c580e94a7606b5faca1a8ca159784d24283ee0b0b8bc55d9f6ec1c6c4114275";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-dateutil" = fetch {
    name        = "mingw-w64-i686-python2-dateutil";
    version     = "2.7.5";
    filename    = "mingw-w64-i686-python2-dateutil-2.7.5-1-any.pkg.tar.xz";
    sha256      = "8400eea01ebd5d8f45e22e1ad21137fcc4c492a715cf7efb6f06c6f842cd165e";
    buildInputs = [ mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-ddt" = fetch {
    name        = "mingw-w64-i686-python2-ddt";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-python2-ddt-1.2.0-1-any.pkg.tar.xz";
    sha256      = "4930a774c5244f0b4d784203e319e88cf8e152ec796421e1af53b29f0f56ec2c";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-debtcollector" = fetch {
    name        = "mingw-w64-i686-python2-debtcollector";
    version     = "1.20.0";
    filename    = "mingw-w64-i686-python2-debtcollector-1.20.0-1-any.pkg.tar.xz";
    sha256      = "c8d73f7bbee8b5bc92b252a0e4f7f95c61b70b3528ca4620aa562b2aad35c61a";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-pbr mingw-w64-i686-python2-babel mingw-w64-i686-python2-wrapt ];
  };

  "mingw-w64-i686-python2-decorator" = fetch {
    name        = "mingw-w64-i686-python2-decorator";
    version     = "4.3.1";
    filename    = "mingw-w64-i686-python2-decorator-4.3.1-1-any.pkg.tar.xz";
    sha256      = "c6f4480110b244a2556d392f557acfaeb050cff4f1890a3f84afff40c1f549a2";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-defusedxml" = fetch {
    name        = "mingw-w64-i686-python2-defusedxml";
    version     = "0.5.0";
    filename    = "mingw-w64-i686-python2-defusedxml-0.5.0-1-any.pkg.tar.xz";
    sha256      = "abce05a645f1608e3ff0c2233a9b4da92b4463da64f7c33be8527dbe3c9fad95";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-distlib" = fetch {
    name        = "mingw-w64-i686-python2-distlib";
    version     = "0.2.8";
    filename    = "mingw-w64-i686-python2-distlib-0.2.8-1-any.pkg.tar.xz";
    sha256      = "dfcf1ddd26c20850171b88c8f5246be35ea5aaa6ad932e56ae68422db95d795b";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-distutils-extra" = fetch {
    name        = "mingw-w64-i686-python2-distutils-extra";
    version     = "2.39";
    filename    = "mingw-w64-i686-python2-distutils-extra-2.39-4-any.pkg.tar.xz";
    sha256      = "7d767e43d992b5c40416433027db4a4ca47cabb3a3ed92a6617bde6d96b7450b";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python2.version "2.7"; mingw-w64-i686-python2) intltool ];
    broken      = true; # broken dependency mingw-w64-i686-python2-distutils-extra -> intltool
  };

  "mingw-w64-i686-python2-django" = fetch {
    name        = "mingw-w64-i686-python2-django";
    version     = "1.11.13";
    filename    = "mingw-w64-i686-python2-django-1.11.13-2-any.pkg.tar.xz";
    sha256      = "0a8e93b83fc9a062672b1ba0369617b9e69ddd72f3602ef4bd54d0edfbc7928b";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-pytz ];
  };

  "mingw-w64-i686-python2-dnspython" = fetch {
    name        = "mingw-w64-i686-python2-dnspython";
    version     = "1.16.0";
    filename    = "mingw-w64-i686-python2-dnspython-1.16.0-1-any.pkg.tar.xz";
    sha256      = "333253d4838c54550671e5f22a2c54309a79e6b2cb308054fe37fe6b7674145c";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-docutils" = fetch {
    name        = "mingw-w64-i686-python2-docutils";
    version     = "0.14";
    filename    = "mingw-w64-i686-python2-docutils-0.14-3-any.pkg.tar.xz";
    sha256      = "96050b6f9d2bba1ae4bbf04fc37dcd5186c65d31a994df48885bfda2f2a8d26a";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-editor" = fetch {
    name        = "mingw-w64-i686-python2-editor";
    version     = "1.0.3";
    filename    = "mingw-w64-i686-python2-editor-1.0.3-1-any.pkg.tar.xz";
    sha256      = "a556abbb7fd52593de4b539f9f964dc4478766e63ad942f81fa6aa104d020660";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-email-validator" = fetch {
    name        = "mingw-w64-i686-python2-email-validator";
    version     = "1.0.3";
    filename    = "mingw-w64-i686-python2-email-validator-1.0.3-1-any.pkg.tar.xz";
    sha256      = "8894a671f987c36f3e98b3f565635210001454e1d5130d53ab72b630c005bf06";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-dnspython mingw-w64-i686-python2-idna ];
  };

  "mingw-w64-i686-python2-enum" = fetch {
    name        = "mingw-w64-i686-python2-enum";
    version     = "0.4.6";
    filename    = "mingw-w64-i686-python2-enum-0.4.6-1-any.pkg.tar.xz";
    sha256      = "9f4a20c56c41087a2e6c654a35972a59c2c80eabfe0aedc12fb053c91e06a7a9";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-enum34" = fetch {
    name        = "mingw-w64-i686-python2-enum34";
    version     = "1.1.6";
    filename    = "mingw-w64-i686-python2-enum34-1.1.6-1-any.pkg.tar.xz";
    sha256      = "68e64e9a8571b67bb0d636790cf822f7a1566145304eabe49f2fb45aee3c2b9f";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-et-xmlfile" = fetch {
    name        = "mingw-w64-i686-python2-et-xmlfile";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python2-et-xmlfile-1.0.1-3-any.pkg.tar.xz";
    sha256      = "fe11bf1e4c225e9337df0865d0d4e25f3628ebc7e3ed7960aebef311244022eb";
    buildInputs = [ mingw-w64-i686-python2-lxml ];
  };

  "mingw-w64-i686-python2-eventlet" = fetch {
    name        = "mingw-w64-i686-python2-eventlet";
    version     = "0.24.1";
    filename    = "mingw-w64-i686-python2-eventlet-0.24.1-1-any.pkg.tar.xz";
    sha256      = "55fe21e87e1ce61c31488a23c5c2488623a39c41b382580f4766698200f689e4";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-greenlet mingw-w64-i686-python2-monotonic ];
  };

  "mingw-w64-i686-python2-execnet" = fetch {
    name        = "mingw-w64-i686-python2-execnet";
    version     = "1.5.0";
    filename    = "mingw-w64-i686-python2-execnet-1.5.0-1-any.pkg.tar.xz";
    sha256      = "f1f3478d0337e574caf6dae845bdb1220008883e826eb613881831c629f7cc3e";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-apipkg ];
  };

  "mingw-w64-i686-python2-extras" = fetch {
    name        = "mingw-w64-i686-python2-extras";
    version     = "1.0.0";
    filename    = "mingw-w64-i686-python2-extras-1.0.0-1-any.pkg.tar.xz";
    sha256      = "bf5344d3b8258f41ea8a02c3c39504b5a12877df0faf612baf938bf36c955e6a";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-faker" = fetch {
    name        = "mingw-w64-i686-python2-faker";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python2-faker-1.0.1-1-any.pkg.tar.xz";
    sha256      = "5aea370b85312ad9dd684d8fd26973d977e4a4fa08fda50a80cfafccdf2fd78c";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-dateutil mingw-w64-i686-python2-ipaddress mingw-w64-i686-python2-six mingw-w64-i686-python2-text-unidecode ];
  };

  "mingw-w64-i686-python2-fasteners" = fetch {
    name        = "mingw-w64-i686-python2-fasteners";
    version     = "0.14.1";
    filename    = "mingw-w64-i686-python2-fasteners-0.14.1-1-any.pkg.tar.xz";
    sha256      = "99f67dba3c50303b37cf2b133b868d622eb3ff3a5956c0827083e872812ba1cd";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-monotonic ];
  };

  "mingw-w64-i686-python2-filelock" = fetch {
    name        = "mingw-w64-i686-python2-filelock";
    version     = "3.0.10";
    filename    = "mingw-w64-i686-python2-filelock-3.0.10-1-any.pkg.tar.xz";
    sha256      = "d17836c6a713ff35ba0e79edd2ff3858b69b97e4a360df7c80fd1159f01bc249";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-fixtures" = fetch {
    name        = "mingw-w64-i686-python2-fixtures";
    version     = "3.0.0";
    filename    = "mingw-w64-i686-python2-fixtures-3.0.0-2-any.pkg.tar.xz";
    sha256      = "21da4e7776cf4b8d0d5302e96d9ac8ee46735a1b744d4b2259a4d1365bc6dfd2";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-pbr mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-flake8" = fetch {
    name        = "mingw-w64-i686-python2-flake8";
    version     = "3.6.0";
    filename    = "mingw-w64-i686-python2-flake8-3.6.0-1-any.pkg.tar.xz";
    sha256      = "7dc3c1bd0ef4283a0b0f3803746553d2fee85c0c06c6a5f6ef920fc407b47c97";
    buildInputs = [ mingw-w64-i686-python2-pyflakes mingw-w64-i686-python2-mccabe mingw-w64-i686-python2-pycodestyle mingw-w64-i686-python2-enum34 mingw-w64-i686-python2-configparser ];
  };

  "mingw-w64-i686-python2-flaky" = fetch {
    name        = "mingw-w64-i686-python2-flaky";
    version     = "3.4.0";
    filename    = "mingw-w64-i686-python2-flaky-3.4.0-2-any.pkg.tar.xz";
    sha256      = "02ba5396a67d2fdc1053e6da9f1e3549267eac06101ab8bf32ff3f4e58da33bf";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-flexmock" = fetch {
    name        = "mingw-w64-i686-python2-flexmock";
    version     = "0.10.2";
    filename    = "mingw-w64-i686-python2-flexmock-0.10.2-1-any.pkg.tar.xz";
    sha256      = "5f9c4929b45ccbe04117c9afaeb5df66d673f88c6c6d961abd7f721c86ff6d1e";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-fonttools" = fetch {
    name        = "mingw-w64-i686-python2-fonttools";
    version     = "3.30.0";
    filename    = "mingw-w64-i686-python2-fonttools-3.30.0-1-any.pkg.tar.xz";
    sha256      = "18c238a3a6d47fe69ab231e2a8ac181d2e6614ab7a9c223edd2cae95f679799e";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-numpy ];
  };

  "mingw-w64-i686-python2-freezegun" = fetch {
    name        = "mingw-w64-i686-python2-freezegun";
    version     = "0.3.11";
    filename    = "mingw-w64-i686-python2-freezegun-0.3.11-1-any.pkg.tar.xz";
    sha256      = "7a05fbae456560443fa88732b1c15603cac45aab6e61ce947343e6cbb841c6b9";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-dateutil ];
  };

  "mingw-w64-i686-python2-funcsigs" = fetch {
    name        = "mingw-w64-i686-python2-funcsigs";
    version     = "1.0.2";
    filename    = "mingw-w64-i686-python2-funcsigs-1.0.2-2-any.pkg.tar.xz";
    sha256      = "267a23b2664b65e8b4d5bb110307199718a709a6bcde651c36411bede9fa65f8";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-functools32" = fetch {
    name        = "mingw-w64-i686-python2-functools32";
    version     = "3.2.3_2";
    filename    = "mingw-w64-i686-python2-functools32-3.2.3_2-1-any.pkg.tar.xz";
    sha256      = "2bab23016c9bcee258492e11399bede2dc8382308fcc88b8ef3563da6a42a238";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-future" = fetch {
    name        = "mingw-w64-i686-python2-future";
    version     = "0.17.1";
    filename    = "mingw-w64-i686-python2-future-0.17.1-1-any.pkg.tar.xz";
    sha256      = "451b266a08511a3c2250cb5a65fd8b722f1deb8a6a039b2cfaab7f17e80db0fb";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-futures" = fetch {
    name        = "mingw-w64-i686-python2-futures";
    version     = "3.2.0";
    filename    = "mingw-w64-i686-python2-futures-3.2.0-1-any.pkg.tar.xz";
    sha256      = "babf5dec08c12215311ee7d7bb591e59411e0f950c64ddee868f65372a6cdef3";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-genty" = fetch {
    name        = "mingw-w64-i686-python2-genty";
    version     = "1.3.2";
    filename    = "mingw-w64-i686-python2-genty-1.3.2-2-any.pkg.tar.xz";
    sha256      = "a1122a3c9cd9f6cd1217099421660a9d6cfb03252f041a5c0d25321b17f2202c";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-gmpy2" = fetch {
    name        = "mingw-w64-i686-python2-gmpy2";
    version     = "2.1.0a4";
    filename    = "mingw-w64-i686-python2-gmpy2-2.1.0a4-1-any.pkg.tar.xz";
    sha256      = "c96041cb9f2c0399269293af46263696cf5e02cf66137a05d5f0a4eadbadc266";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-mpc ];
  };

  "mingw-w64-i686-python2-gobject" = fetch {
    name        = "mingw-w64-i686-python2-gobject";
    version     = "3.30.4";
    filename    = "mingw-w64-i686-python2-gobject-3.30.4-1-any.pkg.tar.xz";
    sha256      = "338fc2167fb747b2de10ca8b0882062f3bdd21fd358c45ab1a904f29591503b1";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-python2-cairo mingw-w64-i686-libffi mingw-w64-i686-gobject-introspection-runtime (assert mingw-w64-i686-pygobject-devel.version=="3.30.4"; mingw-w64-i686-pygobject-devel) ];
  };

  "mingw-w64-i686-python2-gobject2" = fetch {
    name        = "mingw-w64-i686-python2-gobject2";
    version     = "2.28.7";
    filename    = "mingw-w64-i686-python2-gobject2-2.28.7-1-any.pkg.tar.xz";
    sha256      = "6d849fee8a314d9fa0c291d16cefbee5a5eba09e6e31fcb61841d46b3478aa95";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-libffi mingw-w64-i686-gobject-introspection-runtime (assert mingw-w64-i686-pygobject2-devel.version=="2.28.7"; mingw-w64-i686-pygobject2-devel) ];
  };

  "mingw-w64-i686-python2-greenlet" = fetch {
    name        = "mingw-w64-i686-python2-greenlet";
    version     = "0.4.15";
    filename    = "mingw-w64-i686-python2-greenlet-0.4.15-1-any.pkg.tar.xz";
    sha256      = "17c2615a9e776089cfd6c6c887d91606610f081876320611899489b98a2e82cf";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-h5py" = fetch {
    name        = "mingw-w64-i686-python2-h5py";
    version     = "2.9.0";
    filename    = "mingw-w64-i686-python2-h5py-2.9.0-1-any.pkg.tar.xz";
    sha256      = "489a34eedf554cb27d415dc36a190fa056c7d35c476a15ead5e0c78dbcacab6b";
    buildInputs = [ mingw-w64-i686-python2-numpy mingw-w64-i686-python2-six mingw-w64-i686-hdf5 ];
  };

  "mingw-w64-i686-python2-hacking" = fetch {
    name        = "mingw-w64-i686-python2-hacking";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python2-hacking-1.1.0-1-any.pkg.tar.xz";
    sha256      = "d840c8e0086d126254ddacd2393c71423428b542d83739f71d0ca518d8910706";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-html5lib" = fetch {
    name        = "mingw-w64-i686-python2-html5lib";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python2-html5lib-1.0.1-3-any.pkg.tar.xz";
    sha256      = "15acc2b2f4412743c1df804a08b7f537a8f31615306639efa755da1d3c8f497c";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-webencodings ];
  };

  "mingw-w64-i686-python2-httplib2" = fetch {
    name        = "mingw-w64-i686-python2-httplib2";
    version     = "0.12.0";
    filename    = "mingw-w64-i686-python2-httplib2-0.12.0-1-any.pkg.tar.xz";
    sha256      = "c908b3274f15d39237608d2a2555da61ff39cb4fd2f128a9d61d9824896056ee";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-certifi mingw-w64-i686-ca-certificates ];
  };

  "mingw-w64-i686-python2-hypothesis" = fetch {
    name        = "mingw-w64-i686-python2-hypothesis";
    version     = "3.84.4";
    filename    = "mingw-w64-i686-python2-hypothesis-3.84.4-1-any.pkg.tar.xz";
    sha256      = "e045397933483d099ab82d3cdccf5b3ee09f9e5cbb057baba558669ab6b8e1e3";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-attrs mingw-w64-i686-python2-coverage mingw-w64-i686-python2-enum34 ];
  };

  "mingw-w64-i686-python2-icu" = fetch {
    name        = "mingw-w64-i686-python2-icu";
    version     = "2.2";
    filename    = "mingw-w64-i686-python2-icu-2.2-1-any.pkg.tar.xz";
    sha256      = "ac7b5c0d95d2deea2258f4665518ec3eb62e56081f669700fd2e97b75c7e370b";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-icu ];
  };

  "mingw-w64-i686-python2-idna" = fetch {
    name        = "mingw-w64-i686-python2-idna";
    version     = "2.8";
    filename    = "mingw-w64-i686-python2-idna-2.8-1-any.pkg.tar.xz";
    sha256      = "12e6083157de1088458119ded2c00741ece2a4edac4963cc2a0c9a3f481cc07b";
    buildInputs = [  ];
  };

  "mingw-w64-i686-python2-ifaddr" = fetch {
    name        = "mingw-w64-i686-python2-ifaddr";
    version     = "0.1.6";
    filename    = "mingw-w64-i686-python2-ifaddr-0.1.6-1-any.pkg.tar.xz";
    sha256      = "4ee2d14353a93421b4c64acdb6cb8b82ba50f6deeab64e2237d96d43e55ae708";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-ipaddress ];
  };

  "mingw-w64-i686-python2-imagesize" = fetch {
    name        = "mingw-w64-i686-python2-imagesize";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python2-imagesize-1.1.0-1-any.pkg.tar.xz";
    sha256      = "b1e526b5b82b1c2a18259fc53d179486a3118d80e0475ca7c3ecbc332d918e33";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-importlib-metadata" = fetch {
    name        = "mingw-w64-i686-python2-importlib-metadata";
    version     = "0.7";
    filename    = "mingw-w64-i686-python2-importlib-metadata-0.7-1-any.pkg.tar.xz";
    sha256      = "eaa17227452ad51087ea8bfeb91b0b774ae3c456f17d618fbf28f5e0131cf97a";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-contextlib2 mingw-w64-i686-python2-pathlib2 ];
  };

  "mingw-w64-i686-python2-importlib_resources" = fetch {
    name        = "mingw-w64-i686-python2-importlib_resources";
    version     = "1.0.2";
    filename    = "mingw-w64-i686-python2-importlib_resources-1.0.2-1-any.pkg.tar.xz";
    sha256      = "9d264d409d51b0f51a4080713be11ee9d19f07369801ff5648bd056555cd213e";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-typing mingw-w64-i686-python2-pathlib2 ];
  };

  "mingw-w64-i686-python2-iniconfig" = fetch {
    name        = "mingw-w64-i686-python2-iniconfig";
    version     = "1.0.0";
    filename    = "mingw-w64-i686-python2-iniconfig-1.0.0-2-any.pkg.tar.xz";
    sha256      = "657225753e05454ea2ebb2ca40cfe18b95d9a1b2154c20b2da0cb63f15e1c5ee";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-iocapture" = fetch {
    name        = "mingw-w64-i686-python2-iocapture";
    version     = "0.1.2";
    filename    = "mingw-w64-i686-python2-iocapture-0.1.2-1-any.pkg.tar.xz";
    sha256      = "15ca1b8f601a92b7a381f88525b6a3d5a8e1d5c03e88febb906cc7ac19efb6ea";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-ipaddress" = fetch {
    name        = "mingw-w64-i686-python2-ipaddress";
    version     = "1.0.22";
    filename    = "mingw-w64-i686-python2-ipaddress-1.0.22-1-any.pkg.tar.xz";
    sha256      = "9bbbbfcf88c54f36ffb4812f79495ca58ec42af7313c2f1601da8c81dd79e94c";
    buildInputs = [  ];
  };

  "mingw-w64-i686-python2-ipykernel" = fetch {
    name        = "mingw-w64-i686-python2-ipykernel";
    version     = "4.9.0";
    filename    = "mingw-w64-i686-python2-ipykernel-4.9.0-2-any.pkg.tar.xz";
    sha256      = "90b661aae214f4fb4e3d7ad7f79a06c082d71384b3b51b92840c9e72b671f7c4";
    buildInputs = [ mingw-w64-i686-python2 self."mingw-w64-i686-python2-backports.shutil_get_terminal_size" mingw-w64-i686-python2-pathlib2 mingw-w64-i686-python2-pyzmq mingw-w64-i686-python2-ipython ];
  };

  "mingw-w64-i686-python2-ipython" = fetch {
    name        = "mingw-w64-i686-python2-ipython";
    version     = "5.3.0";
    filename    = "mingw-w64-i686-python2-ipython-5.3.0-8-any.pkg.tar.xz";
    sha256      = "89b88488c882a8928e5afeb965b801cacb9efc6954afb26f979b116872dd25fe";
    buildInputs = [ winpty mingw-w64-i686-sqlite3 mingw-w64-i686-python2-traitlets mingw-w64-i686-python2-simplegeneric mingw-w64-i686-python2-pickleshare mingw-w64-i686-python2-prompt_toolkit self."mingw-w64-i686-python2-backports.shutil_get_terminal_size" mingw-w64-i686-python2-jedi mingw-w64-i686-python2-win_unicode_console ];
  };

  "mingw-w64-i686-python2-ipython_genutils" = fetch {
    name        = "mingw-w64-i686-python2-ipython_genutils";
    version     = "0.2.0";
    filename    = "mingw-w64-i686-python2-ipython_genutils-0.2.0-2-any.pkg.tar.xz";
    sha256      = "f90ea21b174005fe6cbe34cebb6dd9bf39240ed298a798510508fa19b2d0c0a3";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-ipywidgets" = fetch {
    name        = "mingw-w64-i686-python2-ipywidgets";
    version     = "7.4.2";
    filename    = "mingw-w64-i686-python2-ipywidgets-7.4.2-1-any.pkg.tar.xz";
    sha256      = "708e7b118b4d88e10fd121e9c98473965766a0583d871ecaca01aa347f286bb1";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-iso8601" = fetch {
    name        = "mingw-w64-i686-python2-iso8601";
    version     = "0.1.12";
    filename    = "mingw-w64-i686-python2-iso8601-0.1.12-1-any.pkg.tar.xz";
    sha256      = "d237a6158346ed9d7c244f3fe49bbc34a7989b1ed34215cdc99d1ef7aa9f8b67";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-isort" = fetch {
    name        = "mingw-w64-i686-python2-isort";
    version     = "4.3.4";
    filename    = "mingw-w64-i686-python2-isort-4.3.4-1-any.pkg.tar.xz";
    sha256      = "6719dcfa62c2f878d6d6c30e848c3503ca01949228308e498d4bed24e34d7301";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-futures ];
  };

  "mingw-w64-i686-python2-jdcal" = fetch {
    name        = "mingw-w64-i686-python2-jdcal";
    version     = "1.4";
    filename    = "mingw-w64-i686-python2-jdcal-1.4-2-any.pkg.tar.xz";
    sha256      = "5cdf2649d0c70bd261b0040090b0a555034a7b62834651dd499718561356e0e5";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-jedi" = fetch {
    name        = "mingw-w64-i686-python2-jedi";
    version     = "0.13.1";
    filename    = "mingw-w64-i686-python2-jedi-0.13.1-1-any.pkg.tar.xz";
    sha256      = "9833b0baff17f6719e82ce3dcb1db0cb83e37704911e0fe0e00af2e6ad14d799";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-parso ];
  };

  "mingw-w64-i686-python2-jinja" = fetch {
    name        = "mingw-w64-i686-python2-jinja";
    version     = "2.10";
    filename    = "mingw-w64-i686-python2-jinja-2.10-2-any.pkg.tar.xz";
    sha256      = "84f8966777043b8798f1553271f7b38e1217da88ab510dffb237841de0c6c31b";
    buildInputs = [ mingw-w64-i686-python2-setuptools mingw-w64-i686-python2-markupsafe ];
  };

  "mingw-w64-i686-python2-json-rpc" = fetch {
    name        = "mingw-w64-i686-python2-json-rpc";
    version     = "1.11.1";
    filename    = "mingw-w64-i686-python2-json-rpc-1.11.1-1-any.pkg.tar.xz";
    sha256      = "ff7f4db2027ddc8327fda92b5aa32e9a7d04aef09d1f3510fb1bfc85a3f28ad9";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-jsonschema" = fetch {
    name        = "mingw-w64-i686-python2-jsonschema";
    version     = "2.6.0";
    filename    = "mingw-w64-i686-python2-jsonschema-2.6.0-5-any.pkg.tar.xz";
    sha256      = "5ec492141e6012ffa25d51380dfe831289e402a3c8ee4bb3dc620ef614a9faac";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-functools32 ];
  };

  "mingw-w64-i686-python2-jupyter_client" = fetch {
    name        = "mingw-w64-i686-python2-jupyter_client";
    version     = "5.2.4";
    filename    = "mingw-w64-i686-python2-jupyter_client-5.2.4-1-any.pkg.tar.xz";
    sha256      = "1b8518aca48bd634d32591befc065615b5d3c5346be4f6a989b2574c037f3675";
    buildInputs = [ mingw-w64-i686-python2-ipykernel mingw-w64-i686-python2-jupyter_core mingw-w64-i686-python2-pyzmq ];
  };

  "mingw-w64-i686-python2-jupyter_console" = fetch {
    name        = "mingw-w64-i686-python2-jupyter_console";
    version     = "5.2.0";
    filename    = "mingw-w64-i686-python2-jupyter_console-5.2.0-3-any.pkg.tar.xz";
    sha256      = "f2dd796ebc1d997402174cf7ce3b00d3f34be41bc8c56b077cd8d78c18bd9bb4";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-jupyter_core mingw-w64-i686-python2-jupyter_client mingw-w64-i686-python2-colorama ];
  };

  "mingw-w64-i686-python2-jupyter_core" = fetch {
    name        = "mingw-w64-i686-python2-jupyter_core";
    version     = "4.4.0";
    filename    = "mingw-w64-i686-python2-jupyter_core-4.4.0-3-any.pkg.tar.xz";
    sha256      = "52e38ea73860fba620d2389cc06fd4752f40c2e6e22e6fb901fd312d6a9c107b";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-kiwisolver" = fetch {
    name        = "mingw-w64-i686-python2-kiwisolver";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python2-kiwisolver-1.0.1-2-any.pkg.tar.xz";
    sha256      = "0f5d7c10371d8b8c616eaad781f38eaf00cd9f76b9c2c5ec80fbfc02f0d0b635";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-lazy-object-proxy" = fetch {
    name        = "mingw-w64-i686-python2-lazy-object-proxy";
    version     = "1.3.1";
    filename    = "mingw-w64-i686-python2-lazy-object-proxy-1.3.1-2-any.pkg.tar.xz";
    sha256      = "375cfbb7d56bc36a5f3548dfc11c5b06c0d34a4cca0d3b37819864bd5893784e";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-ldap" = fetch {
    name        = "mingw-w64-i686-python2-ldap";
    version     = "3.1.0";
    filename    = "mingw-w64-i686-python2-ldap-3.1.0-1-any.pkg.tar.xz";
    sha256      = "a3ac3c9e42fbe211d5f176a005277ab1e0011010a2e1f5937a93aed179d48048";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-ldap3" = fetch {
    name        = "mingw-w64-i686-python2-ldap3";
    version     = "2.5.1";
    filename    = "mingw-w64-i686-python2-ldap3-2.5.1-1-any.pkg.tar.xz";
    sha256      = "eac89d53ada5186f3dc7d673d7f76e697fa1efb40374df09f6274342bb5e50b7";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-lhafile" = fetch {
    name        = "mingw-w64-i686-python2-lhafile";
    version     = "0.2.1";
    filename    = "mingw-w64-i686-python2-lhafile-0.2.1-3-any.pkg.tar.xz";
    sha256      = "e3ea7ecd3e7ac2a74cf21a6d40482f511160b9d7aa832f3da6b17cb0fdf95073";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-linecache2" = fetch {
    name        = "mingw-w64-i686-python2-linecache2";
    version     = "1.0.0";
    filename    = "mingw-w64-i686-python2-linecache2-1.0.0-1-any.pkg.tar.xz";
    sha256      = "5221ef5a4c8fa4561c0b7f780c0ce81f16e853945db420f91dcda8ae434e0206";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-lockfile" = fetch {
    name        = "mingw-w64-i686-python2-lockfile";
    version     = "0.12.2";
    filename    = "mingw-w64-i686-python2-lockfile-0.12.2-1-any.pkg.tar.xz";
    sha256      = "c47fd3405c1e759f2990285d548b4d3ed46d91a22e101034ff395f0a1a4ff450";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-lxml" = fetch {
    name        = "mingw-w64-i686-python2-lxml";
    version     = "4.3.0";
    filename    = "mingw-w64-i686-python2-lxml-4.3.0-1-any.pkg.tar.xz";
    sha256      = "5a3cd37e2000317bf3c76424d38d7f8f4be0c5dc06bca9fcfddfdf3e3f6e2e7d";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-mako" = fetch {
    name        = "mingw-w64-i686-python2-mako";
    version     = "1.0.7";
    filename    = "mingw-w64-i686-python2-mako-1.0.7-3-any.pkg.tar.xz";
    sha256      = "84ddd32a8286ebfa75a76fe478e3d9a3e96db58c63d2a2c023c6d22dd4436a4a";
    buildInputs = [ mingw-w64-i686-python2-markupsafe mingw-w64-i686-python2-beaker ];
  };

  "mingw-w64-i686-python2-markdown" = fetch {
    name        = "mingw-w64-i686-python2-markdown";
    version     = "3.0.1";
    filename    = "mingw-w64-i686-python2-markdown-3.0.1-1-any.pkg.tar.xz";
    sha256      = "548c014df2fd64306875d282446d905b62a48296306c1dccb6f111e3fab85211";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-markupsafe" = fetch {
    name        = "mingw-w64-i686-python2-markupsafe";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python2-markupsafe-1.1.0-1-any.pkg.tar.xz";
    sha256      = "7d735add2c58b6ec03e16387b223128935cbe9987610f9d33176ba01d28a7984";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-matplotlib" = fetch {
    name        = "mingw-w64-i686-python2-matplotlib";
    version     = "2.2.3";
    filename    = "mingw-w64-i686-python2-matplotlib-2.2.3-4-any.pkg.tar.xz";
    sha256      = "c52e8a83490527809c23581a38786a809f932f48b06a16db6d9d6b86224ecfc2";
    buildInputs = [ mingw-w64-i686-python2-pytz mingw-w64-i686-python2-numpy mingw-w64-i686-python2-cairo mingw-w64-i686-python2-cycler mingw-w64-i686-python2-pyqt5 mingw-w64-i686-python2-dateutil mingw-w64-i686-python2-pyparsing mingw-w64-i686-python2-kiwisolver self."mingw-w64-i686-python2-backports.functools_lru_cache" mingw-w64-i686-freetype mingw-w64-i686-libpng ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-python2-mccabe" = fetch {
    name        = "mingw-w64-i686-python2-mccabe";
    version     = "0.6.1";
    filename    = "mingw-w64-i686-python2-mccabe-0.6.1-1-any.pkg.tar.xz";
    sha256      = "b55ae72cda562aa39be29e1c3a62ebef6ff32a6c1d00ad99a7f2a66194c73e9e";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-mimeparse" = fetch {
    name        = "mingw-w64-i686-python2-mimeparse";
    version     = "1.6.0";
    filename    = "mingw-w64-i686-python2-mimeparse-1.6.0-1-any.pkg.tar.xz";
    sha256      = "fc4da6e908fe81f7a88711c69b2b60589568c683125f934d9b2077e5d6994398";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-mistune" = fetch {
    name        = "mingw-w64-i686-python2-mistune";
    version     = "0.8.4";
    filename    = "mingw-w64-i686-python2-mistune-0.8.4-1-any.pkg.tar.xz";
    sha256      = "7296d4f2df19996b9893f75f4dad781a45d647763ba00dcba7a5c94321036f54";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-mock" = fetch {
    name        = "mingw-w64-i686-python2-mock";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-python2-mock-2.0.0-3-any.pkg.tar.xz";
    sha256      = "83f46f2e9e57fb2c962bef61317fd69751c6539c87f71a4cf0ffece4204db5c2";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python3-pbr ];
  };

  "mingw-w64-i686-python2-monotonic" = fetch {
    name        = "mingw-w64-i686-python2-monotonic";
    version     = "1.5";
    filename    = "mingw-w64-i686-python2-monotonic-1.5-1-any.pkg.tar.xz";
    sha256      = "da21e9dcc103e16d81c4e2d31a1ad33a530c0dc08962345139d104cbe3658b3c";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-more-itertools" = fetch {
    name        = "mingw-w64-i686-python2-more-itertools";
    version     = "4.3.1";
    filename    = "mingw-w64-i686-python2-more-itertools-4.3.1-1-any.pkg.tar.xz";
    sha256      = "c4ba9a584edd7e6b073aea83b54cc9e332d71a02dd0080a6f34fd709066490e7";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-mox3" = fetch {
    name        = "mingw-w64-i686-python2-mox3";
    version     = "0.26.0";
    filename    = "mingw-w64-i686-python2-mox3-0.26.0-1-any.pkg.tar.xz";
    sha256      = "9913d1635908c7287de6255a7faa91ede1cc8b733c15c575d48423b2b8f1eb6d";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-pbr mingw-w64-i686-python2-fixtures ];
  };

  "mingw-w64-i686-python2-mpmath" = fetch {
    name        = "mingw-w64-i686-python2-mpmath";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python2-mpmath-1.1.0-1-any.pkg.tar.xz";
    sha256      = "a6c7976e602da22131b91a93730b4b8f20eb7903568728b452eb46caeb65c951";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-gmpy2 ];
  };

  "mingw-w64-i686-python2-msgpack" = fetch {
    name        = "mingw-w64-i686-python2-msgpack";
    version     = "0.5.6";
    filename    = "mingw-w64-i686-python2-msgpack-0.5.6-1-any.pkg.tar.xz";
    sha256      = "2d37e5e615c6166004ad4842961b3ed353a835195ec265ad60fa6e3fcb038926";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-mysql" = fetch {
    name        = "mingw-w64-i686-python2-mysql";
    version     = "1.2.5";
    filename    = "mingw-w64-i686-python2-mysql-1.2.5-2-any.pkg.tar.xz";
    sha256      = "c51bbc4c42884baf51c8337190c25a1ac1d41adb116df7a9bcb394fd652e18eb";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-libmariadbclient ];
  };

  "mingw-w64-i686-python2-ndg-httpsclient" = fetch {
    name        = "mingw-w64-i686-python2-ndg-httpsclient";
    version     = "0.5.1";
    filename    = "mingw-w64-i686-python2-ndg-httpsclient-0.5.1-1-any.pkg.tar.xz";
    sha256      = "630c521003a9cfe6e58ab66a7836c4e575633dad636b347073982be2026a0850";
    buildInputs = [ mingw-w64-i686-python2-pyopenssl mingw-w64-i686-python2-pyasn1 ];
  };

  "mingw-w64-i686-python2-netaddr" = fetch {
    name        = "mingw-w64-i686-python2-netaddr";
    version     = "0.7.19";
    filename    = "mingw-w64-i686-python2-netaddr-0.7.19-1-any.pkg.tar.xz";
    sha256      = "1c40440b16976a58ed60bb6566f45372ea204f56bea07c61e3b136a81eb5067c";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-netifaces" = fetch {
    name        = "mingw-w64-i686-python2-netifaces";
    version     = "0.10.9";
    filename    = "mingw-w64-i686-python2-netifaces-0.10.9-1-any.pkg.tar.xz";
    sha256      = "f0b0f859cb1a3b6c6c4d4e314039428825a2991be02a8aa42035a7eee8df1e48";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-networkx" = fetch {
    name        = "mingw-w64-i686-python2-networkx";
    version     = "2.2";
    filename    = "mingw-w64-i686-python2-networkx-2.2-1-any.pkg.tar.xz";
    sha256      = "0937a47228914fa3403ee9bac26e1ea80d7cf16ebe0f8c4535d94a99bb28513f";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-decorator ];
  };

  "mingw-w64-i686-python2-nose" = fetch {
    name        = "mingw-w64-i686-python2-nose";
    version     = "1.3.7";
    filename    = "mingw-w64-i686-python2-nose-1.3.7-8-any.pkg.tar.xz";
    sha256      = "4b50ff5a58375972914fc6d44b610d2b255971aebd9bb7fd609e9c0d82d17706";
    buildInputs = [ mingw-w64-i686-python2-setuptools ];
  };

  "mingw-w64-i686-python2-nuitka" = fetch {
    name        = "mingw-w64-i686-python2-nuitka";
    version     = "0.6.0.6";
    filename    = "mingw-w64-i686-python2-nuitka-0.6.0.6-1-any.pkg.tar.xz";
    sha256      = "987fb4b78d54c380ab98841f23e6d5a8abd07f6d03ab7f99f1e7029f73cab6b9";
    buildInputs = [ mingw-w64-i686-python2-setuptools ];
  };

  "mingw-w64-i686-python2-numexpr" = fetch {
    name        = "mingw-w64-i686-python2-numexpr";
    version     = "2.6.9";
    filename    = "mingw-w64-i686-python2-numexpr-2.6.9-1-any.pkg.tar.xz";
    sha256      = "819c9d03a7ece5522f89426a2d8bd95cc77341b81cef8e1a7971e35c485567e7";
    buildInputs = [ mingw-w64-i686-python2-numpy ];
  };

  "mingw-w64-i686-python2-numpy" = fetch {
    name        = "mingw-w64-i686-python2-numpy";
    version     = "1.15.4";
    filename    = "mingw-w64-i686-python2-numpy-1.15.4-1-any.pkg.tar.xz";
    sha256      = "53a3eb2f8b9cbf37b524822076850ab565c36659319d2ea003f6ce612d3ebf45";
    buildInputs = [ mingw-w64-i686-openblas mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-olefile" = fetch {
    name        = "mingw-w64-i686-python2-olefile";
    version     = "0.46";
    filename    = "mingw-w64-i686-python2-olefile-0.46-1-any.pkg.tar.xz";
    sha256      = "316c8bec887442e07216682eb3d378fcc4686f795321f4a385fd753dd4b75e7a";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-openmdao" = fetch {
    name        = "mingw-w64-i686-python2-openmdao";
    version     = "2.5.0";
    filename    = "mingw-w64-i686-python2-openmdao-2.5.0-1-any.pkg.tar.xz";
    sha256      = "4e83dc3c8714c90dab583548149688c0d279e348f5ef0fddd3a34debcd122fad";
    buildInputs = [ mingw-w64-i686-python2-numpy mingw-w64-i686-python2-scipy mingw-w64-i686-python2-networkx mingw-w64-i686-python2-sqlitedict mingw-w64-i686-python2-pyparsing mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-openpyxl" = fetch {
    name        = "mingw-w64-i686-python2-openpyxl";
    version     = "2.5.12";
    filename    = "mingw-w64-i686-python2-openpyxl-2.5.12-1-any.pkg.tar.xz";
    sha256      = "fde3d160533f07a477bad46bd16c1fe6c575fa41c8f67ad359aa483785e0d0af";
    buildInputs = [ mingw-w64-i686-python2-jdcal mingw-w64-i686-python2-et-xmlfile ];
  };

  "mingw-w64-i686-python2-oslo-concurrency" = fetch {
    name        = "mingw-w64-i686-python2-oslo-concurrency";
    version     = "3.29.0";
    filename    = "mingw-w64-i686-python2-oslo-concurrency-3.29.0-1-any.pkg.tar.xz";
    sha256      = "73e00af6d4cf0ceddc34d7971d9dd77fa5c2fc076057604b8cd4381e521d7377";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-pbr mingw-w64-i686-python2-oslo-config mingw-w64-i686-python2-oslo-i18n mingw-w64-i686-python2-oslo-utils mingw-w64-i686-python2-fasteners mingw-w64-i686-python2-enum34 ];
  };

  "mingw-w64-i686-python2-oslo-config" = fetch {
    name        = "mingw-w64-i686-python2-oslo-config";
    version     = "6.7.0";
    filename    = "mingw-w64-i686-python2-oslo-config-6.7.0-1-any.pkg.tar.xz";
    sha256      = "9dff48de279abac9aa58d0568014ecc6edb980ce4b6c19f7f4965327da4f97d8";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-netaddr mingw-w64-i686-python2-stevedore mingw-w64-i686-python2-debtcollector mingw-w64-i686-python2-oslo-i18n mingw-w64-i686-python2-rfc3986 mingw-w64-i686-python2-yaml mingw-w64-i686-python2-enum34 ];
  };

  "mingw-w64-i686-python2-oslo-context" = fetch {
    name        = "mingw-w64-i686-python2-oslo-context";
    version     = "2.22.0";
    filename    = "mingw-w64-i686-python2-oslo-context-2.22.0-1-any.pkg.tar.xz";
    sha256      = "07b656467629efd082865e979ded36864a9414e42fdccc08893c0af39dd94f5a";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-pbr mingw-w64-i686-python2-debtcollector ];
  };

  "mingw-w64-i686-python2-oslo-db" = fetch {
    name        = "mingw-w64-i686-python2-oslo-db";
    version     = "4.42.0";
    filename    = "mingw-w64-i686-python2-oslo-db-4.42.0-1-any.pkg.tar.xz";
    sha256      = "eeaae1fc03e54dda7c4dc9ffac0e4472ad543b973ca9523a07e137888df20722";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-pbr mingw-w64-i686-python2-alembic mingw-w64-i686-python2-debtcollector mingw-w64-i686-python2-oslo-i18n mingw-w64-i686-python2-oslo-config mingw-w64-i686-python2-oslo-utils mingw-w64-i686-python2-sqlalchemy mingw-w64-i686-python2-sqlalchemy-migrate mingw-w64-i686-python2-stevedore ];
  };

  "mingw-w64-i686-python2-oslo-i18n" = fetch {
    name        = "mingw-w64-i686-python2-oslo-i18n";
    version     = "3.23.0";
    filename    = "mingw-w64-i686-python2-oslo-i18n-3.23.0-1-any.pkg.tar.xz";
    sha256      = "e4266a0c229533ba59ace0f3916476c502cbcf01b179a27dc780c1daf7ac7687";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-pbr mingw-w64-i686-python2-babel ];
  };

  "mingw-w64-i686-python2-oslo-log" = fetch {
    name        = "mingw-w64-i686-python2-oslo-log";
    version     = "3.42.1";
    filename    = "mingw-w64-i686-python2-oslo-log-3.42.1-1-any.pkg.tar.xz";
    sha256      = "148a23d17d546df1b242c242e2d5ace47608a345e022ce610077efa39cae643d";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-pbr mingw-w64-i686-python2-oslo-config mingw-w64-i686-python2-oslo-context mingw-w64-i686-python2-oslo-i18n mingw-w64-i686-python2-oslo-utils mingw-w64-i686-python2-oslo-serialization mingw-w64-i686-python2-debtcollector mingw-w64-i686-python2-dateutil mingw-w64-i686-python2-monotonic ];
  };

  "mingw-w64-i686-python2-oslo-serialization" = fetch {
    name        = "mingw-w64-i686-python2-oslo-serialization";
    version     = "2.28.1";
    filename    = "mingw-w64-i686-python2-oslo-serialization-2.28.1-1-any.pkg.tar.xz";
    sha256      = "b2afc295b7e2d45818a26face843c8737d0236d7a844372a3fb61b0ab9a30315";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-pbr mingw-w64-i686-python2-babel mingw-w64-i686-python2-msgpack mingw-w64-i686-python2-oslo-utils mingw-w64-i686-python2-pytz ];
  };

  "mingw-w64-i686-python2-oslo-utils" = fetch {
    name        = "mingw-w64-i686-python2-oslo-utils";
    version     = "3.39.0";
    filename    = "mingw-w64-i686-python2-oslo-utils-3.39.0-1-any.pkg.tar.xz";
    sha256      = "30c06267a818f3d96bf71dc442042ac090c4b6a314c887aed8aa7abbe081cd5b";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-oslosphinx" = fetch {
    name        = "mingw-w64-i686-python2-oslosphinx";
    version     = "4.18.0";
    filename    = "mingw-w64-i686-python2-oslosphinx-4.18.0-1-any.pkg.tar.xz";
    sha256      = "59d01586eb7a7d40857fc907f3060f3bebcddef4c9ee5bf7bae555cf624ee502";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-requests ];
  };

  "mingw-w64-i686-python2-oslotest" = fetch {
    name        = "mingw-w64-i686-python2-oslotest";
    version     = "3.7.0";
    filename    = "mingw-w64-i686-python2-oslotest-3.7.0-1-any.pkg.tar.xz";
    sha256      = "cc2ac14bef9368a22e65b026f47308f05d3bc099f6b346a1aa5f9627199147e5";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-packaging" = fetch {
    name        = "mingw-w64-i686-python2-packaging";
    version     = "18.0";
    filename    = "mingw-w64-i686-python2-packaging-18.0-1-any.pkg.tar.xz";
    sha256      = "0a7588578158ace5b7889ca1a03346c5e69d342e2438dac39697230401bc1f5a";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-pyparsing mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-pandas" = fetch {
    name        = "mingw-w64-i686-python2-pandas";
    version     = "0.23.4";
    filename    = "mingw-w64-i686-python2-pandas-0.23.4-1-any.pkg.tar.xz";
    sha256      = "1426b4df047d97bb4a4db6cd7353d7e722bab527c9534b301705259930b6ac7b";
    buildInputs = [ mingw-w64-i686-python2-numpy mingw-w64-i686-python2-pytz mingw-w64-i686-python2-dateutil mingw-w64-i686-python2-setuptools ];
  };

  "mingw-w64-i686-python2-pandocfilters" = fetch {
    name        = "mingw-w64-i686-python2-pandocfilters";
    version     = "1.4.2";
    filename    = "mingw-w64-i686-python2-pandocfilters-1.4.2-2-any.pkg.tar.xz";
    sha256      = "f8cf955226c8f5d9a78e2c62d3d40ee8c615f7bc7b4b48e1ed1864b7111834e9";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-paramiko" = fetch {
    name        = "mingw-w64-i686-python2-paramiko";
    version     = "2.4.2";
    filename    = "mingw-w64-i686-python2-paramiko-2.4.2-1-any.pkg.tar.xz";
    sha256      = "9e7149c5cf5a1c8fc2abee557d83b694aa2da8c1cdab417bc41f8624889936ba";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-parso" = fetch {
    name        = "mingw-w64-i686-python2-parso";
    version     = "0.3.1";
    filename    = "mingw-w64-i686-python2-parso-0.3.1-1-any.pkg.tar.xz";
    sha256      = "acf6c15038a0f34515aeb149254ad4410af33aef4508197540a52c8048ec5685";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-path" = fetch {
    name        = "mingw-w64-i686-python2-path";
    version     = "11.5.0";
    filename    = "mingw-w64-i686-python2-path-11.5.0-1-any.pkg.tar.xz";
    sha256      = "064e047ff3071031c72f491f71ce4033351d5acf6664d59080539f648da6eb8d";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-importlib-metadata self."mingw-w64-i686-python2-backports.os" ];
  };

  "mingw-w64-i686-python2-pathlib" = fetch {
    name        = "mingw-w64-i686-python2-pathlib";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python2-pathlib-1.0.1-1-any.pkg.tar.xz";
    sha256      = "016e06b23e76871f4774ffdd64c12876f4588872bf2fe1e8b14f760113397455";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pathlib2" = fetch {
    name        = "mingw-w64-i686-python2-pathlib2";
    version     = "2.3.3";
    filename    = "mingw-w64-i686-python2-pathlib2-2.3.3-1-any.pkg.tar.xz";
    sha256      = "ef9480b29b586e1a08a59673637687146daa9c983d7686be05ae9c1db17256aa";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-scandir ];
  };

  "mingw-w64-i686-python2-pathtools" = fetch {
    name        = "mingw-w64-i686-python2-pathtools";
    version     = "0.1.2";
    filename    = "mingw-w64-i686-python2-pathtools-0.1.2-1-any.pkg.tar.xz";
    sha256      = "919cf5e4a39bea7c3b7549a1b3af1b6bada5dcd97c467764d3118c0bfc585e6e";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-patsy" = fetch {
    name        = "mingw-w64-i686-python2-patsy";
    version     = "0.5.1";
    filename    = "mingw-w64-i686-python2-patsy-0.5.1-1-any.pkg.tar.xz";
    sha256      = "73f80c3e76918e7ca14045dd05e58355fbc5c8cda6c19f3d953b96a2bffb2b0e";
    buildInputs = [ mingw-w64-i686-python2-numpy ];
  };

  "mingw-w64-i686-python2-pbr" = fetch {
    name        = "mingw-w64-i686-python2-pbr";
    version     = "5.1.1";
    filename    = "mingw-w64-i686-python2-pbr-5.1.1-2-any.pkg.tar.xz";
    sha256      = "d5085804b2b41bcf08f273a3dfb27c30f5d7af36672724578ae2b43cdc0c1681";
    buildInputs = [ mingw-w64-i686-python2-setuptools ];
  };

  "mingw-w64-i686-python2-pdfrw" = fetch {
    name        = "mingw-w64-i686-python2-pdfrw";
    version     = "0.4";
    filename    = "mingw-w64-i686-python2-pdfrw-0.4-2-any.pkg.tar.xz";
    sha256      = "dd279293250a36e1c4750cdd322b2915b9598891dcef4b515f9345d16b62079a";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pep517" = fetch {
    name        = "mingw-w64-i686-python2-pep517";
    version     = "0.5.0";
    filename    = "mingw-w64-i686-python2-pep517-0.5.0-1-any.pkg.tar.xz";
    sha256      = "fccf593e21a35f11b7a7e5b42ddba6c28ae124b1b27ce410cfc59442705dc626";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pexpect" = fetch {
    name        = "mingw-w64-i686-python2-pexpect";
    version     = "4.6.0";
    filename    = "mingw-w64-i686-python2-pexpect-4.6.0-1-any.pkg.tar.xz";
    sha256      = "39ca391527291debe812f5a44c3e3564bb63d4632d618bcca2d130c39aa5b940";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-ptyprocess ];
  };

  "mingw-w64-i686-python2-pgen2" = fetch {
    name        = "mingw-w64-i686-python2-pgen2";
    version     = "0.1.0";
    filename    = "mingw-w64-i686-python2-pgen2-0.1.0-3-any.pkg.tar.xz";
    sha256      = "5eaf492b782e3f75cecf4fbb25f6d84d6baf161fd1d6583e159c055aab16d215";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pickleshare" = fetch {
    name        = "mingw-w64-i686-python2-pickleshare";
    version     = "0.7.5";
    filename    = "mingw-w64-i686-python2-pickleshare-0.7.5-1-any.pkg.tar.xz";
    sha256      = "d7cdb971e759ccdddaef7a0496585ebd02feb929bdfb79c013066d54c3ffda35";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python2-path.version "8.1"; mingw-w64-i686-python2-path) ];
  };

  "mingw-w64-i686-python2-pillow" = fetch {
    name        = "mingw-w64-i686-python2-pillow";
    version     = "5.3.0";
    filename    = "mingw-w64-i686-python2-pillow-5.3.0-1-any.pkg.tar.xz";
    sha256      = "9758525c46dfc0e8cefbf149b43f3d97995b7a39bfe159d475a42058cedefe8b";
    buildInputs = [ mingw-w64-i686-freetype mingw-w64-i686-lcms2 mingw-w64-i686-libjpeg mingw-w64-i686-libtiff mingw-w64-i686-libwebp mingw-w64-i686-openjpeg2 mingw-w64-i686-zlib mingw-w64-i686-python2 mingw-w64-i686-python2-olefile ];
    broken      = true; # broken dependency mingw-w64-i686-python2-pillow -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python2-pip" = fetch {
    name        = "mingw-w64-i686-python2-pip";
    version     = "18.1";
    filename    = "mingw-w64-i686-python2-pip-18.1-2-any.pkg.tar.xz";
    sha256      = "a780289f0cc9a2ccaa2796e0631dd25950a76cd27c4660951d54ba94ec41aef2";
    buildInputs = [ mingw-w64-i686-python2-setuptools mingw-w64-i686-python2-appdirs mingw-w64-i686-python2-cachecontrol mingw-w64-i686-python2-colorama mingw-w64-i686-python2-distlib mingw-w64-i686-python2-html5lib mingw-w64-i686-python2-lockfile mingw-w64-i686-python2-msgpack mingw-w64-i686-python2-packaging mingw-w64-i686-python2-pep517 mingw-w64-i686-python2-progress mingw-w64-i686-python2-pyparsing mingw-w64-i686-python2-pytoml mingw-w64-i686-python2-requests mingw-w64-i686-python2-retrying mingw-w64-i686-python2-six mingw-w64-i686-python2-webencodings mingw-w64-i686-python2-ipaddress ];
  };

  "mingw-w64-i686-python2-pkginfo" = fetch {
    name        = "mingw-w64-i686-python2-pkginfo";
    version     = "1.4.2";
    filename    = "mingw-w64-i686-python2-pkginfo-1.4.2-1-any.pkg.tar.xz";
    sha256      = "7187d05c74d83346260065f49e46b11036822d5f062d8acb8b8ec8744fb81508";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pluggy" = fetch {
    name        = "mingw-w64-i686-python2-pluggy";
    version     = "0.8.0";
    filename    = "mingw-w64-i686-python2-pluggy-0.8.0-2-any.pkg.tar.xz";
    sha256      = "f4f1d454b81867028329e6238d310be232be42dc82cd38ca147cbf5303872bdd";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-ply" = fetch {
    name        = "mingw-w64-i686-python2-ply";
    version     = "3.11";
    filename    = "mingw-w64-i686-python2-ply-3.11-2-any.pkg.tar.xz";
    sha256      = "ae48074b6868a2632b1de8dce857c33b3042f8fa7565cfeea639d66505e0eb82";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pptx" = fetch {
    name        = "mingw-w64-i686-python2-pptx";
    version     = "0.6.10";
    filename    = "mingw-w64-i686-python2-pptx-0.6.10-1-any.pkg.tar.xz";
    sha256      = "27bd2ee5f7af6483752822d2003df9e0dda777974c9a5aaf044df40bd490d125";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python2-lxml.version "3.1.0"; mingw-w64-i686-python2-lxml) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python2-pillow.version "2.6.1"; mingw-w64-i686-python2-pillow) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python2-xlsxwriter.version "0.5.7"; mingw-w64-i686-python2-xlsxwriter) ];
    broken      = true; # broken dependency mingw-w64-i686-python2-pillow -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python2-pretend" = fetch {
    name        = "mingw-w64-i686-python2-pretend";
    version     = "1.0.9";
    filename    = "mingw-w64-i686-python2-pretend-1.0.9-2-any.pkg.tar.xz";
    sha256      = "cc1b2f2d72a9948164304e826613ea43537e349c3b73661aee88e78e40264c05";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-prettytable" = fetch {
    name        = "mingw-w64-i686-python2-prettytable";
    version     = "0.7.2";
    filename    = "mingw-w64-i686-python2-prettytable-0.7.2-2-any.pkg.tar.xz";
    sha256      = "ad2ff63160d977b6c4b44a5bb4d52d8bc3fe8229602b522b831a9fe51bbc92bf";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-progress" = fetch {
    name        = "mingw-w64-i686-python2-progress";
    version     = "1.4";
    filename    = "mingw-w64-i686-python2-progress-1.4-3-any.pkg.tar.xz";
    sha256      = "9b4a9780cef59df8a02ca95df41ecda56fc97e8ec7cd23dc86ccef13300ba641";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-prometheus-client" = fetch {
    name        = "mingw-w64-i686-python2-prometheus-client";
    version     = "0.2.0";
    filename    = "mingw-w64-i686-python2-prometheus-client-0.2.0-1-any.pkg.tar.xz";
    sha256      = "0a14f4aaea47310aee4c8c5586fb8e5f24488a32bf92489b0d5ca2aaa3f3cf4a";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-prompt_toolkit" = fetch {
    name        = "mingw-w64-i686-python2-prompt_toolkit";
    version     = "1.0.15";
    filename    = "mingw-w64-i686-python2-prompt_toolkit-1.0.15-2-any.pkg.tar.xz";
    sha256      = "ba410090294512c008f24f00422269cf02dafb0242458d3c58d1dd0eab3d5794";
    buildInputs = [ mingw-w64-i686-python2-pygments mingw-w64-i686-python2-six mingw-w64-i686-python2-wcwidth ];
  };

  "mingw-w64-i686-python2-psutil" = fetch {
    name        = "mingw-w64-i686-python2-psutil";
    version     = "5.4.8";
    filename    = "mingw-w64-i686-python2-psutil-5.4.8-1-any.pkg.tar.xz";
    sha256      = "5b52cb81856f7f57b74031e1fd9945d2c03a933ce59cd9072a0716ae657e0deb";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-psycopg2" = fetch {
    name        = "mingw-w64-i686-python2-psycopg2";
    version     = "2.7.6.1";
    filename    = "mingw-w64-i686-python2-psycopg2-2.7.6.1-1-any.pkg.tar.xz";
    sha256      = "dac3963dfdb6a21ae47596a1403d18236fe00bc7725158abe05b08f74d5af2d3";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-ptyprocess" = fetch {
    name        = "mingw-w64-i686-python2-ptyprocess";
    version     = "0.6.0";
    filename    = "mingw-w64-i686-python2-ptyprocess-0.6.0-1-any.pkg.tar.xz";
    sha256      = "15dd6a77c56662b50f8738f93cf9b0b2f6183abb634739fde65df13fc01afd1d";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-py" = fetch {
    name        = "mingw-w64-i686-python2-py";
    version     = "1.7.0";
    filename    = "mingw-w64-i686-python2-py-1.7.0-1-any.pkg.tar.xz";
    sha256      = "1abb9250e660879daad3ae67e25fd4d65e095deaa30316a5799dbe2147af7e6b";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-py-cpuinfo" = fetch {
    name        = "mingw-w64-i686-python2-py-cpuinfo";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-python2-py-cpuinfo-4.0.0-1-any.pkg.tar.xz";
    sha256      = "5ffc82901d3a9cb06d1e2fce16663ae97560c4ffc093181167a3f3904b7bb7e1";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pyamg" = fetch {
    name        = "mingw-w64-i686-python2-pyamg";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-python2-pyamg-4.0.0-1-any.pkg.tar.xz";
    sha256      = "64c1e5eab1262944fc44594c20ebc41fb42fa20ede200c6db662c4331e1ec6f3";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-scipy mingw-w64-i686-python2-numpy ];
  };

  "mingw-w64-i686-python2-pyasn1" = fetch {
    name        = "mingw-w64-i686-python2-pyasn1";
    version     = "0.4.4";
    filename    = "mingw-w64-i686-python2-pyasn1-0.4.4-1-any.pkg.tar.xz";
    sha256      = "b48849fde5f1bf631e0e7659b110e8c0948001d9a220eea57b7bb09076e6b325";
    buildInputs = [  ];
  };

  "mingw-w64-i686-python2-pyasn1-modules" = fetch {
    name        = "mingw-w64-i686-python2-pyasn1-modules";
    version     = "0.2.2";
    filename    = "mingw-w64-i686-python2-pyasn1-modules-0.2.2-1-any.pkg.tar.xz";
    sha256      = "09901dc9e52d8de759c6abaa24c362c6b4b9f7c952f67c02942474a9ba505c41";
  };

  "mingw-w64-i686-python2-pycodestyle" = fetch {
    name        = "mingw-w64-i686-python2-pycodestyle";
    version     = "2.4.0";
    filename    = "mingw-w64-i686-python2-pycodestyle-2.4.0-1-any.pkg.tar.xz";
    sha256      = "b5d828756f92c34b45f10a90fa04bd40f41aca5e65d88e01ae5984ea0c670c64";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pycparser" = fetch {
    name        = "mingw-w64-i686-python2-pycparser";
    version     = "2.19";
    filename    = "mingw-w64-i686-python2-pycparser-2.19-1-any.pkg.tar.xz";
    sha256      = "27c20c49f1b5fd2d205b65278765a3b708b55410fb36c372940d5327a3e2c1a3";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-ply ];
  };

  "mingw-w64-i686-python2-pyflakes" = fetch {
    name        = "mingw-w64-i686-python2-pyflakes";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-python2-pyflakes-2.0.0-2-any.pkg.tar.xz";
    sha256      = "eafb0cb19c3ff51c7ee0bb45dbe526fa9ce090d6d4616198fc2cab1030788887";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pyglet" = fetch {
    name        = "mingw-w64-i686-python2-pyglet";
    version     = "1.3.2";
    filename    = "mingw-w64-i686-python2-pyglet-1.3.2-1-any.pkg.tar.xz";
    sha256      = "4b708b8cc4ad01088b7622b5eb982894a6ad96c2739d1be50cbf86381f31f031";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-future ];
  };

  "mingw-w64-i686-python2-pygments" = fetch {
    name        = "mingw-w64-i686-python2-pygments";
    version     = "2.3.1";
    filename    = "mingw-w64-i686-python2-pygments-2.3.1-1-any.pkg.tar.xz";
    sha256      = "bc01c01bca431952c29bab666b70b6c7650989fdd1501396c9d057a022f44bf5";
    buildInputs = [ mingw-w64-i686-python2-setuptools ];
  };

  "mingw-w64-i686-python2-pygtk" = fetch {
    name        = "mingw-w64-i686-python2-pygtk";
    version     = "2.24.0";
    filename    = "mingw-w64-i686-python2-pygtk-2.24.0-6-any.pkg.tar.xz";
    sha256      = "106e457d50b2c9f58c8f04a9bd59161503fbc2752a739ccf1d212d25f168fbf9";
    buildInputs = [ mingw-w64-i686-python2-cairo mingw-w64-i686-python2-gobject2 mingw-w64-i686-libglade ];
  };

  "mingw-w64-i686-python2-pylint" = fetch {
    name        = "mingw-w64-i686-python2-pylint";
    version     = "1.9.2";
    filename    = "mingw-w64-i686-python2-pylint-1.9.2-1-any.pkg.tar.xz";
    sha256      = "267429f1ffff502b901f3864fc99ce77a357c6fb146f88065d3dd9716d91ce96";
    buildInputs = [ mingw-w64-i686-python2-astroid self."mingw-w64-i686-python2-backports.functools_lru_cache" mingw-w64-i686-python2-colorama mingw-w64-i686-python2-configparser mingw-w64-i686-python2-isort mingw-w64-i686-python2-mccabe mingw-w64-i686-python2-setuptools mingw-w64-i686-python2-singledispatch mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-pynacl" = fetch {
    name        = "mingw-w64-i686-python2-pynacl";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-python2-pynacl-1.3.0-1-any.pkg.tar.xz";
    sha256      = "c935f0be523b524394e603507f61c776fcb637209bc7eca93a32277040ecabe8";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pyopenssl" = fetch {
    name        = "mingw-w64-i686-python2-pyopenssl";
    version     = "18.0.0";
    filename    = "mingw-w64-i686-python2-pyopenssl-18.0.0-3-any.pkg.tar.xz";
    sha256      = "eb3d418a5aef5860933f4c7be289e33cc041496fcb5af6eb3a28bbd227a7fced";
    buildInputs = [ mingw-w64-i686-openssl mingw-w64-i686-python2-cryptography mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-pyparsing" = fetch {
    name        = "mingw-w64-i686-python2-pyparsing";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-python2-pyparsing-2.3.0-1-any.pkg.tar.xz";
    sha256      = "101cdd7b3045d4615bdbe64890f09ddfc14c5d419f96c6580e1fd916dbb0e877";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pyperclip" = fetch {
    name        = "mingw-w64-i686-python2-pyperclip";
    version     = "1.7.0";
    filename    = "mingw-w64-i686-python2-pyperclip-1.7.0-1-any.pkg.tar.xz";
    sha256      = "58a351120f2435a95a02fc7bf17a93a49f1b07dd6b2e387b2f9ff307044acc89";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pyqt4" = fetch {
    name        = "mingw-w64-i686-python2-pyqt4";
    version     = "4.11.4";
    filename    = "mingw-w64-i686-python2-pyqt4-4.11.4-2-any.pkg.tar.xz";
    sha256      = "87875e3f098780798799e532a338378d5eb8912d8e8786fb99a0c4417c177f73";
    buildInputs = [ mingw-w64-i686-python2-sip mingw-w64-i686-pyqt4-common mingw-w64-i686-python2 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python2-pyqt5" = fetch {
    name        = "mingw-w64-i686-python2-pyqt5";
    version     = "5.11.3";
    filename    = "mingw-w64-i686-python2-pyqt5-5.11.3-1-any.pkg.tar.xz";
    sha256      = "4ee81f6a604b30c3e7725fa12f6403f2192796e0770a775da3b1a5d0d34add9f";
    buildInputs = [ mingw-w64-i686-python2-sip mingw-w64-i686-pyqt5-common mingw-w64-i686-python2 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-python2-pyreadline" = fetch {
    name        = "mingw-w64-i686-python2-pyreadline";
    version     = "2.1";
    filename    = "mingw-w64-i686-python2-pyreadline-2.1-1-any.pkg.tar.xz";
    sha256      = "b6c4d3312e5b4fb6a82920eb0ab47b55804b3c2fa747570b0a906bdf4afcb58a";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pyrsistent" = fetch {
    name        = "mingw-w64-i686-python2-pyrsistent";
    version     = "0.14.9";
    filename    = "mingw-w64-i686-python2-pyrsistent-0.14.9-1-any.pkg.tar.xz";
    sha256      = "37cd00cceb70fa4d7e2b185ca53006cc868a01417630389c960a57e4e13609c2";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-pyserial" = fetch {
    name        = "mingw-w64-i686-python2-pyserial";
    version     = "3.4";
    filename    = "mingw-w64-i686-python2-pyserial-3.4-1-any.pkg.tar.xz";
    sha256      = "c2c4e6b1f95911916a76ef36bb193a9524553113dc1842a7176e6aee3883a263";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pyside-qt4" = fetch {
    name        = "mingw-w64-i686-python2-pyside-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-python2-pyside-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "4c9b988ec2ffc56a75b3b6433aab0d9280e98e03ac57c0c534347ce3131d0c77";
    buildInputs = [ mingw-w64-i686-pyside-common-qt4 mingw-w64-i686-python2 mingw-w64-i686-python2-shiboken-qt4 mingw-w64-i686-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python2-pyside-tools-qt4" = fetch {
    name        = "mingw-w64-i686-python2-pyside-tools-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-python2-pyside-tools-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "f9cc15b2d6e994a373c32d502b14101820b5e1129780ce46db08fc57f3ffb7aa";
    buildInputs = [ mingw-w64-i686-pyside-tools-common-qt4 mingw-w64-i686-python2-pyside-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python2-pysocks" = fetch {
    name        = "mingw-w64-i686-python2-pysocks";
    version     = "1.6.8";
    filename    = "mingw-w64-i686-python2-pysocks-1.6.8-1-any.pkg.tar.xz";
    sha256      = "7f1a2ae89684106e7c8e681591289709d1ab4cea3e5e0d9841dc8d518853cb64";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-win_inet_pton ];
  };

  "mingw-w64-i686-python2-pystemmer" = fetch {
    name        = "mingw-w64-i686-python2-pystemmer";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-python2-pystemmer-1.3.0-2-any.pkg.tar.xz";
    sha256      = "fdf41c81bf67d6e00252c713f38a2c650414f8b021411ce88bed32b66f83cdd7";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pytest" = fetch {
    name        = "mingw-w64-i686-python2-pytest";
    version     = "4.0.2";
    filename    = "mingw-w64-i686-python2-pytest-4.0.2-1-any.pkg.tar.xz";
    sha256      = "0794a22867684a579686dc592f7a07a72dbe1beda0168085ebf510262a1076b5";
    buildInputs = [ mingw-w64-i686-python2-py mingw-w64-i686-python2-pluggy mingw-w64-i686-python2-setuptools mingw-w64-i686-python2-colorama mingw-w64-i686-python2-funcsigs mingw-w64-i686-python2-six mingw-w64-i686-python2-atomicwrites mingw-w64-i686-python2-more-itertools mingw-w64-i686-python2-pathlib2 mingw-w64-i686-python2-attrs ];
  };

  "mingw-w64-i686-python2-pytest-benchmark" = fetch {
    name        = "mingw-w64-i686-python2-pytest-benchmark";
    version     = "3.2.0";
    filename    = "mingw-w64-i686-python2-pytest-benchmark-3.2.0-1-any.pkg.tar.xz";
    sha256      = "4c71bad3c5b84bab53bbfa2b387d569058792a5153014e7f9affd9f07afab9c7";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-py-cpuinfo mingw-w64-i686-python2-statistics mingw-w64-i686-python2-pathlib mingw-w64-i686-python2-pytest ];
  };

  "mingw-w64-i686-python2-pytest-cov" = fetch {
    name        = "mingw-w64-i686-python2-pytest-cov";
    version     = "2.6.0";
    filename    = "mingw-w64-i686-python2-pytest-cov-2.6.0-1-any.pkg.tar.xz";
    sha256      = "e00b197de095e6cece3aaf9759eaeedbe34b187a3605a1ff642ac8eb876e7907";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-coverage mingw-w64-i686-python2-pytest ];
  };

  "mingw-w64-i686-python2-pytest-expect" = fetch {
    name        = "mingw-w64-i686-python2-pytest-expect";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python2-pytest-expect-1.1.0-1-any.pkg.tar.xz";
    sha256      = "37487cdecf09a9822d5b68f6fbddd452f8fffaddfe37f1c3d663d68fbe14cf6b";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-pytest mingw-w64-i686-python2-u-msgpack ];
  };

  "mingw-w64-i686-python2-pytest-forked" = fetch {
    name        = "mingw-w64-i686-python2-pytest-forked";
    version     = "0.2";
    filename    = "mingw-w64-i686-python2-pytest-forked-0.2-1-any.pkg.tar.xz";
    sha256      = "f36f8c09fc1c116a5b726a85d7513627a0a8ffa5cb7df7468213a6dc60e742a5";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-pytest ];
  };

  "mingw-w64-i686-python2-pytest-runner" = fetch {
    name        = "mingw-w64-i686-python2-pytest-runner";
    version     = "4.2";
    filename    = "mingw-w64-i686-python2-pytest-runner-4.2-4-any.pkg.tar.xz";
    sha256      = "fdd007ca4c33cf75b74ddc2ea002792669c10a0ad2353d32d320acb298fd643f";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-pytest ];
  };

  "mingw-w64-i686-python2-pytest-xdist" = fetch {
    name        = "mingw-w64-i686-python2-pytest-xdist";
    version     = "1.25.0";
    filename    = "mingw-w64-i686-python2-pytest-xdist-1.25.0-1-any.pkg.tar.xz";
    sha256      = "c9e6ef93525b3414ff29920226da5e31e390ca527416b172aab6a8a54406ba84";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-pytest-forked mingw-w64-i686-python2-execnet ];
  };

  "mingw-w64-i686-python2-python_ics" = fetch {
    name        = "mingw-w64-i686-python2-python_ics";
    version     = "2.15";
    filename    = "mingw-w64-i686-python2-python_ics-2.15-1-any.pkg.tar.xz";
    sha256      = "5f82c9fec06c90615091343559d4c2c6a6cdec21f5d695b1e1da77037c80ac49";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pytoml" = fetch {
    name        = "mingw-w64-i686-python2-pytoml";
    version     = "0.1.20";
    filename    = "mingw-w64-i686-python2-pytoml-0.1.20-1-any.pkg.tar.xz";
    sha256      = "551890fada3523d7b373fd2f923bb21483e767a1d048235b03f363cb6ad99083";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pytz" = fetch {
    name        = "mingw-w64-i686-python2-pytz";
    version     = "2018.9";
    filename    = "mingw-w64-i686-python2-pytz-2018.9-1-any.pkg.tar.xz";
    sha256      = "e11aeea74884bea2c64ddcbf82ac2d64a7c0fd3d26d938c7c3cf756761a32314";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pyu2f" = fetch {
    name        = "mingw-w64-i686-python2-pyu2f";
    version     = "0.1.4";
    filename    = "mingw-w64-i686-python2-pyu2f-0.1.4-1-any.pkg.tar.xz";
    sha256      = "b4da2ea0862df9bfb8091460b0bb8c7e087815d5b8ba20210d920d399ed1d87c";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pywavelets" = fetch {
    name        = "mingw-w64-i686-python2-pywavelets";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python2-pywavelets-1.0.1-1-any.pkg.tar.xz";
    sha256      = "3438304d17423c5739219dfe9d3ee79302b1bf51dcd9030fb45081b837d6d3a5";
    buildInputs = [ mingw-w64-i686-python2-numpy mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-pyzmq" = fetch {
    name        = "mingw-w64-i686-python2-pyzmq";
    version     = "17.1.2";
    filename    = "mingw-w64-i686-python2-pyzmq-17.1.2-1-any.pkg.tar.xz";
    sha256      = "35fca5832fca6205b0772ae7e0fc82d8fd9ad4dd938fe6d769d696eec234cf69";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-zeromq ];
  };

  "mingw-w64-i686-python2-pyzopfli" = fetch {
    name        = "mingw-w64-i686-python2-pyzopfli";
    version     = "0.1.4";
    filename    = "mingw-w64-i686-python2-pyzopfli-0.1.4-1-any.pkg.tar.xz";
    sha256      = "1744736036080904781b2c7cab075d7e4a50cfd804de6f0316106eb117411305";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-qscintilla" = fetch {
    name        = "mingw-w64-i686-python2-qscintilla";
    version     = "2.10.8";
    filename    = "mingw-w64-i686-python2-qscintilla-2.10.8-1-any.pkg.tar.xz";
    sha256      = "25ba7ded5de519b8ba6b0f9b9f560856821a83c30ef8fd4874aa14ca4ef7a19d";
    buildInputs = [ mingw-w64-i686-python-qscintilla-common mingw-w64-i686-python2-pyqt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-python2-qtconsole" = fetch {
    name        = "mingw-w64-i686-python2-qtconsole";
    version     = "4.4.1";
    filename    = "mingw-w64-i686-python2-qtconsole-4.4.1-1-any.pkg.tar.xz";
    sha256      = "d1066c9ab1fb42eaacfc76b8df9a8440a03645128209c76f77104ea5d2c5d32f";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-jupyter_core mingw-w64-i686-python2-jupyter_client mingw-w64-i686-python2-pyqt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-python2-rencode" = fetch {
    name        = "mingw-w64-i686-python2-rencode";
    version     = "1.0.6";
    filename    = "mingw-w64-i686-python2-rencode-1.0.6-1-any.pkg.tar.xz";
    sha256      = "605d90046343fe43be1025f5ca03afdc90fcfd24be8c3d8bd8c19594319f7e19";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-reportlab" = fetch {
    name        = "mingw-w64-i686-python2-reportlab";
    version     = "3.5.12";
    filename    = "mingw-w64-i686-python2-reportlab-3.5.12-1-any.pkg.tar.xz";
    sha256      = "c066e7d86121df9223a4f19874f622a0fd3707ffc5bf8a6d2f2404b79720f23f";
    buildInputs = [ mingw-w64-i686-freetype mingw-w64-i686-python2-pip mingw-w64-i686-python2-Pillow ];
    broken      = true; # broken dependency mingw-w64-i686-python2-reportlab -> mingw-w64-i686-python2-Pillow
  };

  "mingw-w64-i686-python2-requests" = fetch {
    name        = "mingw-w64-i686-python2-requests";
    version     = "2.21.0";
    filename    = "mingw-w64-i686-python2-requests-2.21.0-1-any.pkg.tar.xz";
    sha256      = "148144e07d07b5bc09ab8f2f9053c3a2509901e7710c6c16df1739e14b96634e";
    buildInputs = [ mingw-w64-i686-python2-urllib3 mingw-w64-i686-python2-chardet mingw-w64-i686-python2-idna ];
  };

  "mingw-w64-i686-python2-requests-kerberos" = fetch {
    name        = "mingw-w64-i686-python2-requests-kerberos";
    version     = "0.12.0";
    filename    = "mingw-w64-i686-python2-requests-kerberos-0.12.0-1-any.pkg.tar.xz";
    sha256      = "e759e788d783a4a8ba997417997959beb9af46adfa1afa1f610ff9520e652a2c";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-cryptography mingw-w64-i686-python2-winkerberos ];
  };

  "mingw-w64-i686-python2-retrying" = fetch {
    name        = "mingw-w64-i686-python2-retrying";
    version     = "1.3.3";
    filename    = "mingw-w64-i686-python2-retrying-1.3.3-1-any.pkg.tar.xz";
    sha256      = "dca23f4b8ec39013e6ad74d37cd645c472264f836169a8d285f1def498382fc8";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-rfc3986" = fetch {
    name        = "mingw-w64-i686-python2-rfc3986";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-python2-rfc3986-1.2.0-1-any.pkg.tar.xz";
    sha256      = "380cf7d151b4191e5308c5f17cc82fb0aca6ee81508e535ad69f338d6cac408d";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-rfc3987" = fetch {
    name        = "mingw-w64-i686-python2-rfc3987";
    version     = "1.3.8";
    filename    = "mingw-w64-i686-python2-rfc3987-1.3.8-1-any.pkg.tar.xz";
    sha256      = "bb5aa8ae6517167b036c32ec1dc28c239e547b3b36fab5120b9cbcaacff0d121";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-rst2pdf" = fetch {
    name        = "mingw-w64-i686-python2-rst2pdf";
    version     = "0.93";
    filename    = "mingw-w64-i686-python2-rst2pdf-0.93-4-any.pkg.tar.xz";
    sha256      = "bbb2c93e522fbb555321f95a599d7a83691ad703e38d79ab3f66c77f31e781c6";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-docutils mingw-w64-i686-python2-pdfrw mingw-w64-i686-python2-pygments (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python2-reportlab.version "2.4"; mingw-w64-i686-python2-reportlab) mingw-w64-i686-python2-setuptools ];
    broken      = true; # broken dependency mingw-w64-i686-python2-reportlab -> mingw-w64-i686-python2-Pillow
  };

  "mingw-w64-i686-python2-scandir" = fetch {
    name        = "mingw-w64-i686-python2-scandir";
    version     = "1.9.0";
    filename    = "mingw-w64-i686-python2-scandir-1.9.0-1-any.pkg.tar.xz";
    sha256      = "9681d21c9a54f60434bd377a3ea2c265be76a356513cbdd5f212d771765f267a";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-scikit-learn" = fetch {
    name        = "mingw-w64-i686-python2-scikit-learn";
    version     = "0.20.2";
    filename    = "mingw-w64-i686-python2-scikit-learn-0.20.2-1-any.pkg.tar.xz";
    sha256      = "3da74b84e1aac652a883c9d60437e80c126bc0eb2721481d5f0524ecfd72e528";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-scipy ];
  };

  "mingw-w64-i686-python2-scipy" = fetch {
    name        = "mingw-w64-i686-python2-scipy";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-python2-scipy-1.2.0-1-any.pkg.tar.xz";
    sha256      = "ca2a75d55823cdef037ff37906a5c3f5d30a89f4ece4e77397b0dfda5f56db53";
    buildInputs = [ mingw-w64-i686-gcc-libgfortran mingw-w64-i686-openblas mingw-w64-i686-python2-numpy ];
  };

  "mingw-w64-i686-python2-send2trash" = fetch {
    name        = "mingw-w64-i686-python2-send2trash";
    version     = "1.5.0";
    filename    = "mingw-w64-i686-python2-send2trash-1.5.0-2-any.pkg.tar.xz";
    sha256      = "1e081efdc4fbb20e52d227d8cf66372442be098df941514893e41b92271bfcd6";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-setproctitle" = fetch {
    name        = "mingw-w64-i686-python2-setproctitle";
    version     = "1.1.10";
    filename    = "mingw-w64-i686-python2-setproctitle-1.1.10-1-any.pkg.tar.xz";
    sha256      = "2c4b45403fbcf431b1a31697f678acd6047b82430206319ce418fa71cea7c321";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-setuptools" = fetch {
    name        = "mingw-w64-i686-python2-setuptools";
    version     = "40.6.3";
    filename    = "mingw-w64-i686-python2-setuptools-40.6.3-1-any.pkg.tar.xz";
    sha256      = "f9a466c5d23db411cf5f8313bb8e400f517d1c6c20247916f0d7096c2425e5d3";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python2.version "2.7"; mingw-w64-i686-python2) mingw-w64-i686-python2-packaging mingw-w64-i686-python2-pyparsing mingw-w64-i686-python2-appdirs mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-setuptools-git" = fetch {
    name        = "mingw-w64-i686-python2-setuptools-git";
    version     = "1.2";
    filename    = "mingw-w64-i686-python2-setuptools-git-1.2-1-any.pkg.tar.xz";
    sha256      = "fc9fc8db647c22a4d7ebc8ab05953235936bb5c8eaa21e74dfd1da841e357a6b";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-setuptools git ];
    broken      = true; # broken dependency mingw-w64-i686-python2-setuptools-git -> git
  };

  "mingw-w64-i686-python2-setuptools-scm" = fetch {
    name        = "mingw-w64-i686-python2-setuptools-scm";
    version     = "3.1.0";
    filename    = "mingw-w64-i686-python2-setuptools-scm-3.1.0-1-any.pkg.tar.xz";
    sha256      = "d94674efa17be5577930013b6b0f06ed6e77e1a3c6a459b6d9a40a5aaa749e42";
    buildInputs = [ mingw-w64-i686-python2-setuptools ];
  };

  "mingw-w64-i686-python2-shiboken-qt4" = fetch {
    name        = "mingw-w64-i686-python2-shiboken-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-python2-shiboken-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "cf0663489d3b9bb409dbde62f2c511b365f09deafdc48f4b0ef2c69a19027237";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-python2 mingw-w64-i686-shiboken-qt4 mingw-w64-i686-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python2-simplegeneric" = fetch {
    name        = "mingw-w64-i686-python2-simplegeneric";
    version     = "0.8.1";
    filename    = "mingw-w64-i686-python2-simplegeneric-0.8.1-4-any.pkg.tar.xz";
    sha256      = "e96b232e25e78fbe293ceab98f7544c0dd95f7fcb11c4dea2a41b649c6f0c9d7";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-singledispatch" = fetch {
    name        = "mingw-w64-i686-python2-singledispatch";
    version     = "3.4.0.3";
    filename    = "mingw-w64-i686-python2-singledispatch-3.4.0.3-1-any.pkg.tar.xz";
    sha256      = "de54c2fc5bacdb6365b378f6f31d6e0408c6e64c1673768ed7db2670a53bac8f";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-sip" = fetch {
    name        = "mingw-w64-i686-python2-sip";
    version     = "4.19.13";
    filename    = "mingw-w64-i686-python2-sip-4.19.13-2-any.pkg.tar.xz";
    sha256      = "3e5b40e1cccae4ef7d1df1104e148f57246b23b367e834d3a7a70377abfee166";
    buildInputs = [ mingw-w64-i686-sip mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-six" = fetch {
    name        = "mingw-w64-i686-python2-six";
    version     = "1.12.0";
    filename    = "mingw-w64-i686-python2-six-1.12.0-1-any.pkg.tar.xz";
    sha256      = "2bfe47bbe83669a150b8c74bb057cd40da127bedc148a23bff3c4b68c52b3b3f";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-snowballstemmer" = fetch {
    name        = "mingw-w64-i686-python2-snowballstemmer";
    version     = "1.2.1";
    filename    = "mingw-w64-i686-python2-snowballstemmer-1.2.1-3-any.pkg.tar.xz";
    sha256      = "8adfd067fe1b95920885ac1ff8d13afa554cab118ef85bd8e74080082fa79bac";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-soupsieve" = fetch {
    name        = "mingw-w64-i686-python2-soupsieve";
    version     = "1.6.2";
    filename    = "mingw-w64-i686-python2-soupsieve-1.6.2-1-any.pkg.tar.xz";
    sha256      = "405bed0c05c77ab1772ae5a5b763068865178e3437b2a7696b39c7e4b59e0d08";
    buildInputs = [ mingw-w64-i686-python2 self."mingw-w64-i686-python2-backports.functools_lru_cache" ];
  };

  "mingw-w64-i686-python2-sphinx" = fetch {
    name        = "mingw-w64-i686-python2-sphinx";
    version     = "1.8.3";
    filename    = "mingw-w64-i686-python2-sphinx-1.8.3-1-any.pkg.tar.xz";
    sha256      = "807a89378fe64bd975f3ff4a42a823be9318fe6753460c3f94641af5f6a1b8af";
    buildInputs = [ mingw-w64-i686-python2-babel mingw-w64-i686-python2-certifi mingw-w64-i686-python2-colorama mingw-w64-i686-python2-chardet mingw-w64-i686-python2-docutils mingw-w64-i686-python2-idna mingw-w64-i686-python2-imagesize mingw-w64-i686-python2-jinja mingw-w64-i686-python2-packaging mingw-w64-i686-python2-pygments mingw-w64-i686-python2-requests mingw-w64-i686-python2-sphinx_rtd_theme mingw-w64-i686-python2-snowballstemmer mingw-w64-i686-python2-sphinx-alabaster-theme mingw-w64-i686-python2-sphinxcontrib-websupport mingw-w64-i686-python2-six mingw-w64-i686-python2-sqlalchemy mingw-w64-i686-python2-urllib3 mingw-w64-i686-python2-whoosh mingw-w64-i686-python2-typing ];
  };

  "mingw-w64-i686-python2-sphinx-alabaster-theme" = fetch {
    name        = "mingw-w64-i686-python2-sphinx-alabaster-theme";
    version     = "0.7.11";
    filename    = "mingw-w64-i686-python2-sphinx-alabaster-theme-0.7.11-1-any.pkg.tar.xz";
    sha256      = "53b99c8823146b947e32a0124ee88db25c95ff1a37d4646236d000921865b55e";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-sphinx_rtd_theme" = fetch {
    name        = "mingw-w64-i686-python2-sphinx_rtd_theme";
    version     = "0.4.1";
    filename    = "mingw-w64-i686-python2-sphinx_rtd_theme-0.4.1-1-any.pkg.tar.xz";
    sha256      = "6099e4203d80713714344acd4e6414214b97ea6632292d6ab218326234767056";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-sphinxcontrib-websupport" = fetch {
    name        = "mingw-w64-i686-python2-sphinxcontrib-websupport";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python2-sphinxcontrib-websupport-1.1.0-2-any.pkg.tar.xz";
    sha256      = "f4d169dd375b14cf1a5ef9cbbd137a0acf33118de3ae56df20cc90ec496b728c";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-sqlalchemy" = fetch {
    name        = "mingw-w64-i686-python2-sqlalchemy";
    version     = "1.2.15";
    filename    = "mingw-w64-i686-python2-sqlalchemy-1.2.15-1-any.pkg.tar.xz";
    sha256      = "c5ffc03f41f35b7a8d1101d1dc1dc380849fdcfebec88c795b2766092840e874";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-sqlalchemy-migrate" = fetch {
    name        = "mingw-w64-i686-python2-sqlalchemy-migrate";
    version     = "0.11.0";
    filename    = "mingw-w64-i686-python2-sqlalchemy-migrate-0.11.0-1-any.pkg.tar.xz";
    sha256      = "9bb3b9f3d8cdde082745e5b9722a49c4d5b466f89fcae665c561b00a62330ee2";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six mingw-w64-i686-python2-pbr mingw-w64-i686-python2-sqlalchemy mingw-w64-i686-python2-decorator mingw-w64-i686-python2-sqlparse mingw-w64-i686-python2-tempita ];
  };

  "mingw-w64-i686-python2-sqlitedict" = fetch {
    name        = "mingw-w64-i686-python2-sqlitedict";
    version     = "1.6.0";
    filename    = "mingw-w64-i686-python2-sqlitedict-1.6.0-1-any.pkg.tar.xz";
    sha256      = "0317a3f8704693d667e345b0b26a10718f42ee98151c55549c1dfbdefc0093aa";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-sqlite3 ];
  };

  "mingw-w64-i686-python2-sqlparse" = fetch {
    name        = "mingw-w64-i686-python2-sqlparse";
    version     = "0.2.4";
    filename    = "mingw-w64-i686-python2-sqlparse-0.2.4-1-any.pkg.tar.xz";
    sha256      = "21f127702fa8cf27671199ee22bc1dbfcbcd3c2bdec53f70f171b6dc36ff8da1";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-statistics" = fetch {
    name        = "mingw-w64-i686-python2-statistics";
    version     = "1.0.3.5";
    filename    = "mingw-w64-i686-python2-statistics-1.0.3.5-1-any.pkg.tar.xz";
    sha256      = "fc8fec64aaaa7191816be2676b7a552c9462e1b8626a7aae3c4a0634d89b4eaa";
    buildInputs = [ mingw-w64-i686-python2-docutils ];
  };

  "mingw-w64-i686-python2-statsmodels" = fetch {
    name        = "mingw-w64-i686-python2-statsmodels";
    version     = "0.9.0";
    filename    = "mingw-w64-i686-python2-statsmodels-0.9.0-1-any.pkg.tar.xz";
    sha256      = "4a2ab0e6b0d87a63d83433470095c0711cadf4c220b5053a0fc9d6f82f3449f4";
    buildInputs = [ mingw-w64-i686-python2-scipy mingw-w64-i686-python2-pandas mingw-w64-i686-python2-patsy ];
  };

  "mingw-w64-i686-python2-stestr" = fetch {
    name        = "mingw-w64-i686-python2-stestr";
    version     = "2.2.0";
    filename    = "mingw-w64-i686-python2-stestr-2.2.0-1-any.pkg.tar.xz";
    sha256      = "7965fe53fdbe1d0f5ff494dcc05d8d0c92e5f9cd5d8bce00096a5f966fa5049f";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-cliff mingw-w64-i686-python2-fixtures mingw-w64-i686-python2-future mingw-w64-i686-python2-pbr mingw-w64-i686-python2-six mingw-w64-i686-python2-subunit mingw-w64-i686-python2-testtools mingw-w64-i686-python2-voluptuous mingw-w64-i686-python2-yaml ];
  };

  "mingw-w64-i686-python2-stevedore" = fetch {
    name        = "mingw-w64-i686-python2-stevedore";
    version     = "1.30.0";
    filename    = "mingw-w64-i686-python2-stevedore-1.30.0-1-any.pkg.tar.xz";
    sha256      = "4fe0f56d79cac36acfaecfd0587db20552bedd0a82166232c92363da545de2a4";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-strict-rfc3339" = fetch {
    name        = "mingw-w64-i686-python2-strict-rfc3339";
    version     = "0.7";
    filename    = "mingw-w64-i686-python2-strict-rfc3339-0.7-1-any.pkg.tar.xz";
    sha256      = "b68de6f68d1b4224d856ee8978ba326eec3afb3671895165c3fe4ac5768380e1";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-subprocess32" = fetch {
    name        = "mingw-w64-i686-python2-subprocess32";
    version     = "3.5.3";
    filename    = "mingw-w64-i686-python2-subprocess32-3.5.3-1-any.pkg.tar.xz";
    sha256      = "d633d6bd692c20ce565fb96065eb5df0c41f2aabbe482edb109bab7e7e4fb158";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-subunit" = fetch {
    name        = "mingw-w64-i686-python2-subunit";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-python2-subunit-1.3.0-2-any.pkg.tar.xz";
    sha256      = "eec71f050a7e42100831e8fde0ede2b3fe080dc26ca76deb62263aec2a3f612a";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-extras mingw-w64-i686-python2-testtools ];
  };

  "mingw-w64-i686-python2-sympy" = fetch {
    name        = "mingw-w64-i686-python2-sympy";
    version     = "1.3";
    filename    = "mingw-w64-i686-python2-sympy-1.3-1-any.pkg.tar.xz";
    sha256      = "891347a785f8d21eeb5865ebac6fc4a62d9093499e7b00790148a486c65595a3";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-mpmath ];
  };

  "mingw-w64-i686-python2-tempita" = fetch {
    name        = "mingw-w64-i686-python2-tempita";
    version     = "0.5.3dev20170202";
    filename    = "mingw-w64-i686-python2-tempita-0.5.3dev20170202-1-any.pkg.tar.xz";
    sha256      = "629a4740b837992b3a4605ba5c9c0cdd90ea32e78d36913ef790b475aec7c254";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-terminado" = fetch {
    name        = "mingw-w64-i686-python2-terminado";
    version     = "0.8.1";
    filename    = "mingw-w64-i686-python2-terminado-0.8.1-2-any.pkg.tar.xz";
    sha256      = "805aae56fd2e456e1d31a436a1a98bddef5a91443f5615a8051f91acf6dbd68b";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-tornado mingw-w64-i686-python2-ptyprocess ];
  };

  "mingw-w64-i686-python2-testrepository" = fetch {
    name        = "mingw-w64-i686-python2-testrepository";
    version     = "0.0.20";
    filename    = "mingw-w64-i686-python2-testrepository-0.0.20-1-any.pkg.tar.xz";
    sha256      = "f322a041f1e9b3d38bec284aeae1647084bfb590620a843a628761cdfbbd5040";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-testresources" = fetch {
    name        = "mingw-w64-i686-python2-testresources";
    version     = "2.0.1";
    filename    = "mingw-w64-i686-python2-testresources-2.0.1-1-any.pkg.tar.xz";
    sha256      = "fa426d050f7ccc287aeee5c17b6a5a50ae4b011676cab9cef9aaeb0301f6357c";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-testscenarios" = fetch {
    name        = "mingw-w64-i686-python2-testscenarios";
    version     = "0.5.0";
    filename    = "mingw-w64-i686-python2-testscenarios-0.5.0-1-any.pkg.tar.xz";
    sha256      = "692340d8f42598d252ee204c123cc2ff1ab0d7d47f808e7e587e01d133f637d5";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-testtools" = fetch {
    name        = "mingw-w64-i686-python2-testtools";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-python2-testtools-2.3.0-1-any.pkg.tar.xz";
    sha256      = "d200a3dc1a4c504b90a857bb78d9724f78cb8f075c63683e0625990e9603a488";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-pbr mingw-w64-i686-python2-extras mingw-w64-i686-python2-fixtures mingw-w64-i686-python2-pyrsistent mingw-w64-i686-python2-mimeparse mingw-w64-i686-python2-unittest2 mingw-w64-i686-python2-traceback2 ];
  };

  "mingw-w64-i686-python2-text-unidecode" = fetch {
    name        = "mingw-w64-i686-python2-text-unidecode";
    version     = "1.2";
    filename    = "mingw-w64-i686-python2-text-unidecode-1.2-1-any.pkg.tar.xz";
    sha256      = "d6de404ff3a5c7ec22c20a0638a2c76c5573ae639590656aa9764a35891cc531";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-toml" = fetch {
    name        = "mingw-w64-i686-python2-toml";
    version     = "0.10.0";
    filename    = "mingw-w64-i686-python2-toml-0.10.0-1-any.pkg.tar.xz";
    sha256      = "3a3d3e0d5acb3a1f52b934104b7d8e318bd969124171cb3582950784717cdb89";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-tornado" = fetch {
    name        = "mingw-w64-i686-python2-tornado";
    version     = "5.1.1";
    filename    = "mingw-w64-i686-python2-tornado-5.1.1-2-any.pkg.tar.xz";
    sha256      = "1dd7b2fe1015f87ae6822462b4f4e9c06f453d2a72e0ea253e7249c46e9130d2";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-futures mingw-w64-i686-python2-backports-abc mingw-w64-i686-python2-setuptools mingw-w64-i686-python2-singledispatch ];
  };

  "mingw-w64-i686-python2-tox" = fetch {
    name        = "mingw-w64-i686-python2-tox";
    version     = "3.6.1";
    filename    = "mingw-w64-i686-python2-tox-3.6.1-1-any.pkg.tar.xz";
    sha256      = "ebc6e8d07b8ddc423dd6dbffaed784306310063dfe30c51f05a169495f336546";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-py mingw-w64-i686-python2-six mingw-w64-i686-python2-virtualenv mingw-w64-i686-python2-setuptools mingw-w64-i686-python2-setuptools-scm mingw-w64-i686-python2-filelock mingw-w64-i686-python2-toml mingw-w64-i686-python2-pluggy ];
  };

  "mingw-w64-i686-python2-traceback2" = fetch {
    name        = "mingw-w64-i686-python2-traceback2";
    version     = "1.4.0";
    filename    = "mingw-w64-i686-python2-traceback2-1.4.0-4-any.pkg.tar.xz";
    sha256      = "0b59cbbd644bba8108bf12b71fbeabf72c81311e547c53b997d714d8dc8cf891";
    buildInputs = [ mingw-w64-i686-python2-linecache2 mingw-w64-i686-python2-six ];
  };

  "mingw-w64-i686-python2-traitlets" = fetch {
    name        = "mingw-w64-i686-python2-traitlets";
    version     = "4.3.2";
    filename    = "mingw-w64-i686-python2-traitlets-4.3.2-3-any.pkg.tar.xz";
    sha256      = "412baeab18350a53cac6fc5e393f8757544df345da247b44790e3dbf2e22d7ce";
    buildInputs = [ mingw-w64-i686-python2-ipython_genutils mingw-w64-i686-python2-decorator ];
  };

  "mingw-w64-i686-python2-typing" = fetch {
    name        = "mingw-w64-i686-python2-typing";
    version     = "3.6.6";
    filename    = "mingw-w64-i686-python2-typing-3.6.6-1-any.pkg.tar.xz";
    sha256      = "affa1afb9056ed191595df2beb897e3648dc959926e4fcd1ee350e628302c505";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-u-msgpack" = fetch {
    name        = "mingw-w64-i686-python2-u-msgpack";
    version     = "2.5.0";
    filename    = "mingw-w64-i686-python2-u-msgpack-2.5.0-1-any.pkg.tar.xz";
    sha256      = "eb55be0205b784b9cf3f2565ed4bd03376e4544e10f325d48fb88f18528e5150";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-ukpostcodeparser" = fetch {
    name        = "mingw-w64-i686-python2-ukpostcodeparser";
    version     = "1.1.2";
    filename    = "mingw-w64-i686-python2-ukpostcodeparser-1.1.2-1-any.pkg.tar.xz";
    sha256      = "4d59005c0de47cfca862fc88dabd95eb0795a400c901f0672dc46cb1058511fa";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-unicodecsv" = fetch {
    name        = "mingw-w64-i686-python2-unicodecsv";
    version     = "0.14.1";
    filename    = "mingw-w64-i686-python2-unicodecsv-0.14.1-3-any.pkg.tar.xz";
    sha256      = "9de206cdafaab622c577b58328c2e28cf5b488b5f97a5f2b2bf5b904b77e82e7";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-unicodedata2" = fetch {
    name        = "mingw-w64-i686-python2-unicodedata2";
    version     = "11.0.0";
    filename    = "mingw-w64-i686-python2-unicodedata2-11.0.0-1-any.pkg.tar.xz";
    sha256      = "6f2ac2e573f95533899b4749a8931525542d07ec75c43f65dd92e1e95c0bea6c";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-unicorn" = fetch {
    name        = "mingw-w64-i686-python2-unicorn";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python2-unicorn-1.0.1-3-any.pkg.tar.xz";
    sha256      = "92d738a4f6e78493f13856e90a25e204c11f208df2a05ef4c1cd297e7345258b";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-unicorn ];
  };

  "mingw-w64-i686-python2-unittest2" = fetch {
    name        = "mingw-w64-i686-python2-unittest2";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python2-unittest2-1.1.0-1-any.pkg.tar.xz";
    sha256      = "35713530b23b704af2c8f2a31e6839f6bc4c7341620b2227355280f0d38d492b";
    buildInputs = [ mingw-w64-i686-python2-six mingw-w64-i686-python2-traceback2 ];
  };

  "mingw-w64-i686-python2-urllib3" = fetch {
    name        = "mingw-w64-i686-python2-urllib3";
    version     = "1.24.1";
    filename    = "mingw-w64-i686-python2-urllib3-1.24.1-1-any.pkg.tar.xz";
    sha256      = "3b35aac203392ba71ee6386e805862e5ca7e20444bb24aff5cea95332dcd9609";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-certifi mingw-w64-i686-python2-idna ];
  };

  "mingw-w64-i686-python2-virtualenv" = fetch {
    name        = "mingw-w64-i686-python2-virtualenv";
    version     = "16.0.0";
    filename    = "mingw-w64-i686-python2-virtualenv-16.0.0-1-any.pkg.tar.xz";
    sha256      = "eaee1a4ee7a169f3729e104e828f756a05aff8967395156a2b42236f9a8b3c92";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-voluptuous" = fetch {
    name        = "mingw-w64-i686-python2-voluptuous";
    version     = "0.11.5";
    filename    = "mingw-w64-i686-python2-voluptuous-0.11.5-1-any.pkg.tar.xz";
    sha256      = "d74c1e0bad72c58bbd4c2b9d66fa5730ad34907697b1ed9aa53729c876db7d64";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-watchdog" = fetch {
    name        = "mingw-w64-i686-python2-watchdog";
    version     = "0.9.0";
    filename    = "mingw-w64-i686-python2-watchdog-0.9.0-1-any.pkg.tar.xz";
    sha256      = "7fca6ec3ae2dd22d8c6b21522837639916b733adb79efcd44d6aca94c4b94906";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-wcwidth" = fetch {
    name        = "mingw-w64-i686-python2-wcwidth";
    version     = "0.1.7";
    filename    = "mingw-w64-i686-python2-wcwidth-0.1.7-3-any.pkg.tar.xz";
    sha256      = "889407be07cc19c9d4900a1e64ef3296a2475142336a6cbe5b43accaa1b1565e";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-webcolors" = fetch {
    name        = "mingw-w64-i686-python2-webcolors";
    version     = "1.8.1";
    filename    = "mingw-w64-i686-python2-webcolors-1.8.1-1-any.pkg.tar.xz";
    sha256      = "27d1ae99db6d4577a7f3cad3360963788dff9311f8aded624bc56713fdc79b4e";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-webencodings" = fetch {
    name        = "mingw-w64-i686-python2-webencodings";
    version     = "0.5.1";
    filename    = "mingw-w64-i686-python2-webencodings-0.5.1-3-any.pkg.tar.xz";
    sha256      = "c4fef35a761edea17748f792f16917f1d152a28129dbbc9c36ec1455ce457630";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-websocket-client" = fetch {
    name        = "mingw-w64-i686-python2-websocket-client";
    version     = "0.54.0";
    filename    = "mingw-w64-i686-python2-websocket-client-0.54.0-2-any.pkg.tar.xz";
    sha256      = "93e935cf6879a3c63edfd5f7d7c06e4e70a550aa31acf970a7f5a6014251cc7a";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-six self."mingw-w64-i686-python2-backports.ssl_match_hostname" ];
  };

  "mingw-w64-i686-python2-wheel" = fetch {
    name        = "mingw-w64-i686-python2-wheel";
    version     = "0.32.3";
    filename    = "mingw-w64-i686-python2-wheel-0.32.3-1-any.pkg.tar.xz";
    sha256      = "7536628be2effc519f7594407df5f671856ecd8f8fdee93210184827d5a0dd9e";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-whoosh" = fetch {
    name        = "mingw-w64-i686-python2-whoosh";
    version     = "2.7.4";
    filename    = "mingw-w64-i686-python2-whoosh-2.7.4-2-any.pkg.tar.xz";
    sha256      = "eaf321a58d91fabd4db8087b676793742ff4fb143d4c1e8dcd530948cfa65a1c";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-win_inet_pton" = fetch {
    name        = "mingw-w64-i686-python2-win_inet_pton";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python2-win_inet_pton-1.0.1-1-any.pkg.tar.xz";
    sha256      = "dc0829edfdf29df8c60a4b999b247934ac578f97435de7306e2961b1823e9da4";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-win_unicode_console" = fetch {
    name        = "mingw-w64-i686-python2-win_unicode_console";
    version     = "0.5";
    filename    = "mingw-w64-i686-python2-win_unicode_console-0.5-3-any.pkg.tar.xz";
    sha256      = "7f0a5a60826d6aa2f8537ea11557607531d896a94510ed5919968d4f222eac10";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-wincertstore" = fetch {
    name        = "mingw-w64-i686-python2-wincertstore";
    version     = "0.2";
    filename    = "mingw-w64-i686-python2-wincertstore-0.2-1-any.pkg.tar.xz";
    sha256      = "5d6e04aff12bba53ee81c35999410a626e2ba0cb2603c5cdf672993841e0d7a8";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-winkerberos" = fetch {
    name        = "mingw-w64-i686-python2-winkerberos";
    version     = "0.7.0";
    filename    = "mingw-w64-i686-python2-winkerberos-0.7.0-1-any.pkg.tar.xz";
    sha256      = "03f6a2838f7b1962d9c19c41e7b196e0481190a72c9a29f1232468216e05a902";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-wrapt" = fetch {
    name        = "mingw-w64-i686-python2-wrapt";
    version     = "1.10.11";
    filename    = "mingw-w64-i686-python2-wrapt-1.10.11-3-any.pkg.tar.xz";
    sha256      = "226cd6d267af917434d6b060bc9822bcafd17fe862a29de3fd0bd3d7c66daf23";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-xdg" = fetch {
    name        = "mingw-w64-i686-python2-xdg";
    version     = "0.26";
    filename    = "mingw-w64-i686-python2-xdg-0.26-2-any.pkg.tar.xz";
    sha256      = "3500151c3af008275b74227fd36964fee06d1893def920974c0d6ee3755ca13f";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-xlrd" = fetch {
    name        = "mingw-w64-i686-python2-xlrd";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-python2-xlrd-1.2.0-1-any.pkg.tar.xz";
    sha256      = "4756481d86dbfa554ee1da52c15799931e8318b7426e2fbb7c1c15ea4d29e309";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-xlsxwriter" = fetch {
    name        = "mingw-w64-i686-python2-xlsxwriter";
    version     = "1.1.2";
    filename    = "mingw-w64-i686-python2-xlsxwriter-1.1.2-1-any.pkg.tar.xz";
    sha256      = "21536e69e7dec6f10579aa018834f8d1e8039910e12e43a585b0e8f48dcc4091";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-xlwt" = fetch {
    name        = "mingw-w64-i686-python2-xlwt";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-python2-xlwt-1.3.0-1-any.pkg.tar.xz";
    sha256      = "9a8a25ae010090efa1f7fcffea0f3180ca186fcd896337e5178c2f63b18d39c0";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-python2-yaml" = fetch {
    name        = "mingw-w64-i686-python2-yaml";
    version     = "3.13";
    filename    = "mingw-w64-i686-python2-yaml-3.13-1-any.pkg.tar.xz";
    sha256      = "990e84acf5df379b82095ea5953e853ebf854570fb40ab752e3421e3bbe57776";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-libyaml ];
  };

  "mingw-w64-i686-python2-zeroconf" = fetch {
    name        = "mingw-w64-i686-python2-zeroconf";
    version     = "0.21.3";
    filename    = "mingw-w64-i686-python2-zeroconf-0.21.3-2-any.pkg.tar.xz";
    sha256      = "b920e3fe8d2dd6cc90e05ee56d01eca7e1aa587f8dfbccc859b6eb7ea696ff93";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-python2-ifaddr mingw-w64-i686-python2-typing ];
  };

  "mingw-w64-i686-python2-zope.event" = fetch {
    name        = "mingw-w64-i686-python2-zope.event";
    version     = "4.4";
    filename    = "mingw-w64-i686-python2-zope.event-4.4-1-any.pkg.tar.xz";
    sha256      = "00eca8190a4335ae123e839aaac9cda5e3c2090c4621e01b2f1d7e5e05dea3e9";
  };

  "mingw-w64-i686-python2-zope.interface" = fetch {
    name        = "mingw-w64-i686-python2-zope.interface";
    version     = "4.6.0";
    filename    = "mingw-w64-i686-python2-zope.interface-4.6.0-1-any.pkg.tar.xz";
    sha256      = "3135b069f8666e4cb1a5c82e49651ac63ff816e407001017ebc160b595af7a73";
  };

  "mingw-w64-i686-python3" = fetch {
    name        = "mingw-w64-i686-python3";
    version     = "3.7.2";
    filename    = "mingw-w64-i686-python3-3.7.2-1-any.pkg.tar.xz";
    sha256      = "11ef5305ec2fc6a9b0b10a11a6bddc24a6d3dd15f9f7ac06917648a0245fc1bf";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-expat mingw-w64-i686-bzip2 mingw-w64-i686-libffi mingw-w64-i686-mpdecimal mingw-w64-i686-ncurses mingw-w64-i686-openssl mingw-w64-i686-tcl mingw-w64-i686-tk mingw-w64-i686-zlib mingw-w64-i686-xz mingw-w64-i686-sqlite3 ];
  };

  "mingw-w64-i686-python3-PyOpenGL" = fetch {
    name        = "mingw-w64-i686-python3-PyOpenGL";
    version     = "3.1.0";
    filename    = "mingw-w64-i686-python3-PyOpenGL-3.1.0-1-any.pkg.tar.xz";
    sha256      = "029913b53d617753e381a90abbdd3d55fd9c92f1c08c8d248a9bccfd7a55a8e8";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-alembic" = fetch {
    name        = "mingw-w64-i686-python3-alembic";
    version     = "1.0.5";
    filename    = "mingw-w64-i686-python3-alembic-1.0.5-1-any.pkg.tar.xz";
    sha256      = "f19a4303853b8354a0544630d045d39b260c906cefeaed80b0f95e33d476498d";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-mako mingw-w64-i686-python3-sqlalchemy mingw-w64-i686-python3-editor mingw-w64-i686-python3-dateutil ];
  };

  "mingw-w64-i686-python3-apipkg" = fetch {
    name        = "mingw-w64-i686-python3-apipkg";
    version     = "1.5";
    filename    = "mingw-w64-i686-python3-apipkg-1.5-1-any.pkg.tar.xz";
    sha256      = "76ab7692706df88218858215221aab76695da9c4853c066af2a6a1909ce627b4";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-appdirs" = fetch {
    name        = "mingw-w64-i686-python3-appdirs";
    version     = "1.4.3";
    filename    = "mingw-w64-i686-python3-appdirs-1.4.3-3-any.pkg.tar.xz";
    sha256      = "9c8358e68311efae9e8a593166c6f015c766dbd2a5a9de1e2c520a5eb807411c";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-argh" = fetch {
    name        = "mingw-w64-i686-python3-argh";
    version     = "0.26.2";
    filename    = "mingw-w64-i686-python3-argh-0.26.2-1-any.pkg.tar.xz";
    sha256      = "4ea034ba5543bf2dc6018b7dcc4bd8cb46aa642aa099a0f3ba0c2bfdf5dc7501";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-argon2_cffi" = fetch {
    name        = "mingw-w64-i686-python3-argon2_cffi";
    version     = "18.3.0";
    filename    = "mingw-w64-i686-python3-argon2_cffi-18.3.0-1-any.pkg.tar.xz";
    sha256      = "df36a73d6cbef026dd2cf1711182e56ca90ac06358784d8ddf76a2dc88acc27b";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-cffi mingw-w64-i686-python3-setuptools mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-asn1crypto" = fetch {
    name        = "mingw-w64-i686-python3-asn1crypto";
    version     = "0.24.0";
    filename    = "mingw-w64-i686-python3-asn1crypto-0.24.0-2-any.pkg.tar.xz";
    sha256      = "95dcbf2186bbc708a967fd30d5d662e1cd08b0d4a299f5b49262ef082bf991e8";
    buildInputs = [ mingw-w64-i686-python3-pycparser ];
  };

  "mingw-w64-i686-python3-astroid" = fetch {
    name        = "mingw-w64-i686-python3-astroid";
    version     = "2.1.0";
    filename    = "mingw-w64-i686-python3-astroid-2.1.0-1-any.pkg.tar.xz";
    sha256      = "16555b694211590c964d401d55ea2cd0b691f370a9ed34f6e8f890bcb5680620";
    buildInputs = [ mingw-w64-i686-python3-six mingw-w64-i686-python3-lazy-object-proxy mingw-w64-i686-python3-wrapt ];
  };

  "mingw-w64-i686-python3-atomicwrites" = fetch {
    name        = "mingw-w64-i686-python3-atomicwrites";
    version     = "1.2.1";
    filename    = "mingw-w64-i686-python3-atomicwrites-1.2.1-1-any.pkg.tar.xz";
    sha256      = "cb11ae0c4bded4e7469a3380fbeee6df8b436afc89f1803862d144a9681759a1";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-attrs" = fetch {
    name        = "mingw-w64-i686-python3-attrs";
    version     = "18.2.0";
    filename    = "mingw-w64-i686-python3-attrs-18.2.0-1-any.pkg.tar.xz";
    sha256      = "402b26500106fba2940e4cc8a05b6c1fb2c8d8cf783724cde864fa496d014d76";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-babel" = fetch {
    name        = "mingw-w64-i686-python3-babel";
    version     = "2.6.0";
    filename    = "mingw-w64-i686-python3-babel-2.6.0-3-any.pkg.tar.xz";
    sha256      = "2195e13a64a5547f3f2d89ed512d0190e34ab9cde0618b7b54a4811943236599";
    buildInputs = [ mingw-w64-i686-python3-pytz ];
  };

  "mingw-w64-i686-python3-backcall" = fetch {
    name        = "mingw-w64-i686-python3-backcall";
    version     = "0.1.0";
    filename    = "mingw-w64-i686-python3-backcall-0.1.0-2-any.pkg.tar.xz";
    sha256      = "2429fec7c823da964d8f5b0f3589cf0c52f6e354a6030200f7acef63aeb0a0ad";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-bcrypt" = fetch {
    name        = "mingw-w64-i686-python3-bcrypt";
    version     = "3.1.5";
    filename    = "mingw-w64-i686-python3-bcrypt-3.1.5-1-any.pkg.tar.xz";
    sha256      = "b7d134d83d6ccd52b402acf013289eda5c508e47c8dfc2fad882c936ea09d483";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-beaker" = fetch {
    name        = "mingw-w64-i686-python3-beaker";
    version     = "1.10.0";
    filename    = "mingw-w64-i686-python3-beaker-1.10.0-2-any.pkg.tar.xz";
    sha256      = "6c52e0a46d01e9cd1a70a849b6f8a127c0a6ab1b66df9a194306e03404137acc";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-beautifulsoup4" = fetch {
    name        = "mingw-w64-i686-python3-beautifulsoup4";
    version     = "4.7.0";
    filename    = "mingw-w64-i686-python3-beautifulsoup4-4.7.0-1-any.pkg.tar.xz";
    sha256      = "1c0467fab79f94032cd9519c97c1139bba7ea3a2b09a87073c155b4dd5a94a5f";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-soupsieve ];
  };

  "mingw-w64-i686-python3-binwalk" = fetch {
    name        = "mingw-w64-i686-python3-binwalk";
    version     = "2.1.1";
    filename    = "mingw-w64-i686-python3-binwalk-2.1.1-2-any.pkg.tar.xz";
    sha256      = "94743278072e615e0e43e639420a2c39fc511b9989df73ad4e3e6276015cd2ce";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-libsystre mingw-w64-i686-xz mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-python3-biopython" = fetch {
    name        = "mingw-w64-i686-python3-biopython";
    version     = "1.73";
    filename    = "mingw-w64-i686-python3-biopython-1.73-1-any.pkg.tar.xz";
    sha256      = "20581c1aaab5162bb9fe26847f12e02fbff6cedbfa59d025537296922eb3c373";
    buildInputs = [ mingw-w64-i686-python3-numpy ];
  };

  "mingw-w64-i686-python3-bleach" = fetch {
    name        = "mingw-w64-i686-python3-bleach";
    version     = "3.0.2";
    filename    = "mingw-w64-i686-python3-bleach-3.0.2-1-any.pkg.tar.xz";
    sha256      = "3b429fe164bb8a1761b65764046b28e469b82c814b14128582afac0b21310313";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-html5lib ];
  };

  "mingw-w64-i686-python3-breathe" = fetch {
    name        = "mingw-w64-i686-python3-breathe";
    version     = "4.11.1";
    filename    = "mingw-w64-i686-python3-breathe-4.11.1-1-any.pkg.tar.xz";
    sha256      = "ee4f7a2a63bc0c5f8e90629f16689ce826c03111c26f36ecbb30d25039a836ba";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-brotli" = fetch {
    name        = "mingw-w64-i686-python3-brotli";
    version     = "1.0.7";
    filename    = "mingw-w64-i686-python3-brotli-1.0.7-1-any.pkg.tar.xz";
    sha256      = "d131e5864819cf9c32e2b321b0c6d0e35121899715439e2ca19ce358037bd0e0";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-libwinpthread-git ];
  };

  "mingw-w64-i686-python3-bsddb3" = fetch {
    name        = "mingw-w64-i686-python3-bsddb3";
    version     = "6.1.0";
    filename    = "mingw-w64-i686-python3-bsddb3-6.1.0-3-any.pkg.tar.xz";
    sha256      = "852c731e86d926808677d0a790325f4a5d398cf1eba39c450a734f95829034af";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-db ];
  };

  "mingw-w64-i686-python3-cachecontrol" = fetch {
    name        = "mingw-w64-i686-python3-cachecontrol";
    version     = "0.12.5";
    filename    = "mingw-w64-i686-python3-cachecontrol-0.12.5-1-any.pkg.tar.xz";
    sha256      = "52cb707f33ae9d6f08d7a44b677b80ee72396d9e3b3edf15b15f0770fd2e6303";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-msgpack mingw-w64-i686-python3-requests ];
  };

  "mingw-w64-i686-python3-cairo" = fetch {
    name        = "mingw-w64-i686-python3-cairo";
    version     = "1.18.0";
    filename    = "mingw-w64-i686-python3-cairo-1.18.0-1-any.pkg.tar.xz";
    sha256      = "8f4c79766597f11b31911f5e1e1fb1b0247e08fb64d8bb6257355c52daf75b15";
    buildInputs = [ mingw-w64-i686-cairo mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-can" = fetch {
    name        = "mingw-w64-i686-python3-can";
    version     = "3.0.0";
    filename    = "mingw-w64-i686-python3-can-3.0.0-1-any.pkg.tar.xz";
    sha256      = "6b486d78e64e67a3df1366ef02a7d8d1e118c75b639a6c3d8011b5b2db3583e4";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-python_ics mingw-w64-i686-python3-pyserial ];
  };

  "mingw-w64-i686-python3-capstone" = fetch {
    name        = "mingw-w64-i686-python3-capstone";
    version     = "4.0";
    filename    = "mingw-w64-i686-python3-capstone-4.0-1-any.pkg.tar.xz";
    sha256      = "38bdc8945fb366b7eba934aa2708801f9d3b810a31035d03a8ca9e5abb3aaa0e";
    buildInputs = [ mingw-w64-i686-capstone mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-certifi" = fetch {
    name        = "mingw-w64-i686-python3-certifi";
    version     = "2018.11.29";
    filename    = "mingw-w64-i686-python3-certifi-2018.11.29-2-any.pkg.tar.xz";
    sha256      = "dde8490c36838935e717603dc9a540154c22fb2906980d43000d6e640a13ced3";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-cffi" = fetch {
    name        = "mingw-w64-i686-python3-cffi";
    version     = "1.11.5";
    filename    = "mingw-w64-i686-python3-cffi-1.11.5-2-any.pkg.tar.xz";
    sha256      = "e45f3c317c09b2d960690b9f89e3525e15c3697be4bc613d82b96a33344e7db5";
    buildInputs = [ mingw-w64-i686-python3-pycparser ];
  };

  "mingw-w64-i686-python3-characteristic" = fetch {
    name        = "mingw-w64-i686-python3-characteristic";
    version     = "14.3.0";
    filename    = "mingw-w64-i686-python3-characteristic-14.3.0-3-any.pkg.tar.xz";
    sha256      = "47d10ff66b0a6988bb56105dc42a3c100d4b6f02f00af28a03cf889337e34a85";
  };

  "mingw-w64-i686-python3-chardet" = fetch {
    name        = "mingw-w64-i686-python3-chardet";
    version     = "3.0.4";
    filename    = "mingw-w64-i686-python3-chardet-3.0.4-2-any.pkg.tar.xz";
    sha256      = "19ffc7cc76da3b84d56e474fd15179f846a86df99ed2d1940d8fa8eaffdbf658";
    buildInputs = [ mingw-w64-i686-python3-setuptools ];
  };

  "mingw-w64-i686-python3-cliff" = fetch {
    name        = "mingw-w64-i686-python3-cliff";
    version     = "2.14.0";
    filename    = "mingw-w64-i686-python3-cliff-2.14.0-1-any.pkg.tar.xz";
    sha256      = "59b7fab53d7302129fa67c2b3903da7d4b9b11aec24800c494e238af114d32eb";
    buildInputs = [ mingw-w64-i686-python3-six mingw-w64-i686-python3-pbr mingw-w64-i686-python3-cmd2 mingw-w64-i686-python3-prettytable mingw-w64-i686-python3-pyparsing mingw-w64-i686-python3-stevedore mingw-w64-i686-python3-yaml ];
  };

  "mingw-w64-i686-python3-cmd2" = fetch {
    name        = "mingw-w64-i686-python3-cmd2";
    version     = "0.9.6";
    filename    = "mingw-w64-i686-python3-cmd2-0.9.6-1-any.pkg.tar.xz";
    sha256      = "87055de6dabba43e4a49e640e7aafb953ed7bcabd53c9676f3e920de4394f749";
    buildInputs = [ mingw-w64-i686-python3-attrs mingw-w64-i686-python3-pyparsing mingw-w64-i686-python3-pyperclip mingw-w64-i686-python3-pyreadline mingw-w64-i686-python3-colorama mingw-w64-i686-python3-wcwidth ];
  };

  "mingw-w64-i686-python3-colorama" = fetch {
    name        = "mingw-w64-i686-python3-colorama";
    version     = "0.4.1";
    filename    = "mingw-w64-i686-python3-colorama-0.4.1-1-any.pkg.tar.xz";
    sha256      = "819ad9dc2597bdd7d9bdf9aadca291869a7b23816a4de5db75fa052d739ec6c6";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-colorspacious" = fetch {
    name        = "mingw-w64-i686-python3-colorspacious";
    version     = "1.1.2";
    filename    = "mingw-w64-i686-python3-colorspacious-1.1.2-2-any.pkg.tar.xz";
    sha256      = "b40a26aad1b3a572ed48c6d827a69d58f60fd06a2b623cf14355aa2d6c76e056";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-colour" = fetch {
    name        = "mingw-w64-i686-python3-colour";
    version     = "0.3.11";
    filename    = "mingw-w64-i686-python3-colour-0.3.11-1-any.pkg.tar.xz";
    sha256      = "0730e704aaa0182e2db38712e52ac32ca9cec38c83c3f54a05f9da1c95c78f57";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-comtypes" = fetch {
    name        = "mingw-w64-i686-python3-comtypes";
    version     = "1.1.7";
    filename    = "mingw-w64-i686-python3-comtypes-1.1.7-1-any.pkg.tar.xz";
    sha256      = "1b26aae549f546e48e3f96bb383a546b1ab00beda138c22feec91d85d7801c03";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-coverage" = fetch {
    name        = "mingw-w64-i686-python3-coverage";
    version     = "4.5.2";
    filename    = "mingw-w64-i686-python3-coverage-4.5.2-1-any.pkg.tar.xz";
    sha256      = "1ce973f7209216d2a1ee1c207e21a46c300a97e4ae1b1a38702e49b32e933152";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-crcmod" = fetch {
    name        = "mingw-w64-i686-python3-crcmod";
    version     = "1.7";
    filename    = "mingw-w64-i686-python3-crcmod-1.7-2-any.pkg.tar.xz";
    sha256      = "4b348f37f10bb074f28bb3f4c991ad09d39fb70706e03cb03d2676c4cde7ed13";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-cryptography" = fetch {
    name        = "mingw-w64-i686-python3-cryptography";
    version     = "2.4.2";
    filename    = "mingw-w64-i686-python3-cryptography-2.4.2-1-any.pkg.tar.xz";
    sha256      = "e6fb1d31452f88b4a7f74b8a631a8533d61026ee2c82229eb0f390d3958790d4";
    buildInputs = [ mingw-w64-i686-python3-cffi mingw-w64-i686-python3-pyasn1 mingw-w64-i686-python3-idna mingw-w64-i686-python3-asn1crypto ];
  };

  "mingw-w64-i686-python3-cssselect" = fetch {
    name        = "mingw-w64-i686-python3-cssselect";
    version     = "1.0.3";
    filename    = "mingw-w64-i686-python3-cssselect-1.0.3-2-any.pkg.tar.xz";
    sha256      = "cedb68028c440296693711b72c8829b79692660751d5c3025291c02bdcac1a31";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-cvxopt" = fetch {
    name        = "mingw-w64-i686-python3-cvxopt";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-python3-cvxopt-1.2.2-1-any.pkg.tar.xz";
    sha256      = "1dba7328933ea8678d2fdcdc004443df30db742e50b50946bd0a3d66cd4ac837";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-cx_Freeze" = fetch {
    name        = "mingw-w64-i686-python3-cx_Freeze";
    version     = "5.1.1";
    filename    = "mingw-w64-i686-python3-cx_Freeze-5.1.1-3-any.pkg.tar.xz";
    sha256      = "2c57bf6eb083e99dcf26578366fce208f90d2d056c2daf05d3c720a34b7aef18";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-cycler" = fetch {
    name        = "mingw-w64-i686-python3-cycler";
    version     = "0.10.0";
    filename    = "mingw-w64-i686-python3-cycler-0.10.0-3-any.pkg.tar.xz";
    sha256      = "00b1ce044b625abd768f339fe4d5df30646cb7cf4ef9d46e54eeaa363867c2e2";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-dateutil" = fetch {
    name        = "mingw-w64-i686-python3-dateutil";
    version     = "2.7.5";
    filename    = "mingw-w64-i686-python3-dateutil-2.7.5-1-any.pkg.tar.xz";
    sha256      = "4d71883aad5f59773563ce7afc6eeab37dcfcb2b01150510870ac1a912bd8beb";
    buildInputs = [ mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-ddt" = fetch {
    name        = "mingw-w64-i686-python3-ddt";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-python3-ddt-1.2.0-1-any.pkg.tar.xz";
    sha256      = "dcac41fd05af5483c10059013ca4c0babb1ce0dd14980784436f5da2404c5fdc";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-debtcollector" = fetch {
    name        = "mingw-w64-i686-python3-debtcollector";
    version     = "1.20.0";
    filename    = "mingw-w64-i686-python3-debtcollector-1.20.0-1-any.pkg.tar.xz";
    sha256      = "9204bc8af471a12f1584e8c72b7aeabe6b6d0fb4518eb175a671347042dd079f";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-pbr mingw-w64-i686-python3-babel mingw-w64-i686-python3-wrapt ];
  };

  "mingw-w64-i686-python3-decorator" = fetch {
    name        = "mingw-w64-i686-python3-decorator";
    version     = "4.3.1";
    filename    = "mingw-w64-i686-python3-decorator-4.3.1-1-any.pkg.tar.xz";
    sha256      = "19b5df602c5ff2a07281f545e06bfd12f7d5abefd52a46e88960e1c7676eec4b";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-defusedxml" = fetch {
    name        = "mingw-w64-i686-python3-defusedxml";
    version     = "0.5.0";
    filename    = "mingw-w64-i686-python3-defusedxml-0.5.0-1-any.pkg.tar.xz";
    sha256      = "1b425afcd051bd4fcb61193a01fdedfc7938ee97761b9615fc538b3391f7dff8";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-distlib" = fetch {
    name        = "mingw-w64-i686-python3-distlib";
    version     = "0.2.8";
    filename    = "mingw-w64-i686-python3-distlib-0.2.8-1-any.pkg.tar.xz";
    sha256      = "8e575781dcfa5a25478949884e34ea138d948967cd06b965316eb70ff3076212";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-distutils-extra" = fetch {
    name        = "mingw-w64-i686-python3-distutils-extra";
    version     = "2.39";
    filename    = "mingw-w64-i686-python3-distutils-extra-2.39-4-any.pkg.tar.xz";
    sha256      = "6573f3f89fdaed5adeb914d4713e490d300256d4d637e22739c6c7cde83a2f72";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python3.version "3.3"; mingw-w64-i686-python3) intltool ];
    broken      = true; # broken dependency mingw-w64-i686-python3-distutils-extra -> intltool
  };

  "mingw-w64-i686-python3-django" = fetch {
    name        = "mingw-w64-i686-python3-django";
    version     = "2.1.4";
    filename    = "mingw-w64-i686-python3-django-2.1.4-2-any.pkg.tar.xz";
    sha256      = "052b237e9a6c5277249dc3ee24602b41c34c38d1ec440650963f4384be1e048d";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pytz ];
  };

  "mingw-w64-i686-python3-dnspython" = fetch {
    name        = "mingw-w64-i686-python3-dnspython";
    version     = "1.16.0";
    filename    = "mingw-w64-i686-python3-dnspython-1.16.0-1-any.pkg.tar.xz";
    sha256      = "444765a2a5b317543ac33fdf9d8dc1240c712643f6ab0f4aea43b0790eafbaa0";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-docutils" = fetch {
    name        = "mingw-w64-i686-python3-docutils";
    version     = "0.14";
    filename    = "mingw-w64-i686-python3-docutils-0.14-3-any.pkg.tar.xz";
    sha256      = "c122cceeaf5f31537b54af835e448f450d1028ff843e6ac69e80748065bd20d2";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-editor" = fetch {
    name        = "mingw-w64-i686-python3-editor";
    version     = "1.0.3";
    filename    = "mingw-w64-i686-python3-editor-1.0.3-1-any.pkg.tar.xz";
    sha256      = "541a53ce07f73008c454ba1bd7eeb0c2fa69193b6978a7b1f88e175f978ff8c3";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-email-validator" = fetch {
    name        = "mingw-w64-i686-python3-email-validator";
    version     = "1.0.3";
    filename    = "mingw-w64-i686-python3-email-validator-1.0.3-1-any.pkg.tar.xz";
    sha256      = "d56b1fc58e250aabd1ae3e110283899a6f19047b97576bba1911bac3b96547ec";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python2-dnspython mingw-w64-i686-python2-idna ];
  };

  "mingw-w64-i686-python3-entrypoints" = fetch {
    name        = "mingw-w64-i686-python3-entrypoints";
    version     = "0.2.3";
    filename    = "mingw-w64-i686-python3-entrypoints-0.2.3-4-any.pkg.tar.xz";
    sha256      = "1f76a5182a43c4b3ff4d789e799c61e8fc5b8612c7c643258c157a098a5506fd";
  };

  "mingw-w64-i686-python3-et-xmlfile" = fetch {
    name        = "mingw-w64-i686-python3-et-xmlfile";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python3-et-xmlfile-1.0.1-3-any.pkg.tar.xz";
    sha256      = "cece714a896874f4ec6268dd6ac34e421bea8ecfd48e7088f4917e2265436fff";
    buildInputs = [ mingw-w64-i686-python3-lxml ];
  };

  "mingw-w64-i686-python3-eventlet" = fetch {
    name        = "mingw-w64-i686-python3-eventlet";
    version     = "0.24.1";
    filename    = "mingw-w64-i686-python3-eventlet-0.24.1-1-any.pkg.tar.xz";
    sha256      = "3786d9213ffa325dc10ba5956614b68d26fb1e799ea9c34dee86931cd0fac00c";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-greenlet mingw-w64-i686-python3-monotonic ];
  };

  "mingw-w64-i686-python3-execnet" = fetch {
    name        = "mingw-w64-i686-python3-execnet";
    version     = "1.5.0";
    filename    = "mingw-w64-i686-python3-execnet-1.5.0-1-any.pkg.tar.xz";
    sha256      = "eba98709d34b6f60b6f17fa816756e80b1e4dacacea08b27e7da665a3082d290";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-apipkg ];
  };

  "mingw-w64-i686-python3-extras" = fetch {
    name        = "mingw-w64-i686-python3-extras";
    version     = "1.0.0";
    filename    = "mingw-w64-i686-python3-extras-1.0.0-1-any.pkg.tar.xz";
    sha256      = "3361d2fc703819ba539638172225e8d485c38cacc6eca1ca516dcb954c547903";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-faker" = fetch {
    name        = "mingw-w64-i686-python3-faker";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python3-faker-1.0.1-1-any.pkg.tar.xz";
    sha256      = "36f61e8aa0ae9eeaa3d92f341f8a77d5da626ceded3b224b47795049cecaf1d4";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-dateutil mingw-w64-i686-python3-six mingw-w64-i686-python3-text-unidecode ];
  };

  "mingw-w64-i686-python3-fasteners" = fetch {
    name        = "mingw-w64-i686-python3-fasteners";
    version     = "0.14.1";
    filename    = "mingw-w64-i686-python3-fasteners-0.14.1-1-any.pkg.tar.xz";
    sha256      = "589c749872289c69a1a1b135d753412c51e20376a2f7a17fecbac18a978bcb90";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-monotonic ];
  };

  "mingw-w64-i686-python3-filelock" = fetch {
    name        = "mingw-w64-i686-python3-filelock";
    version     = "3.0.10";
    filename    = "mingw-w64-i686-python3-filelock-3.0.10-1-any.pkg.tar.xz";
    sha256      = "6b102d80819fcdd780f22cb053ab563d03ffd6d32a930bd46cc829001d6ce51b";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-fixtures" = fetch {
    name        = "mingw-w64-i686-python3-fixtures";
    version     = "3.0.0";
    filename    = "mingw-w64-i686-python3-fixtures-3.0.0-2-any.pkg.tar.xz";
    sha256      = "a1d7ad06821ae068b69abfc2d12f1016bd251d83dc3070b48cb51a67ccb38951";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pbr mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-flake8" = fetch {
    name        = "mingw-w64-i686-python3-flake8";
    version     = "3.6.0";
    filename    = "mingw-w64-i686-python3-flake8-3.6.0-1-any.pkg.tar.xz";
    sha256      = "876fc5f4febc44e6d873d790d6b2d35e427ae5e325c386af1a7dde62de7941e5";
    buildInputs = [ mingw-w64-i686-python3-pyflakes mingw-w64-i686-python3-mccabe mingw-w64-i686-python3-pycodestyle ];
  };

  "mingw-w64-i686-python3-flaky" = fetch {
    name        = "mingw-w64-i686-python3-flaky";
    version     = "3.4.0";
    filename    = "mingw-w64-i686-python3-flaky-3.4.0-2-any.pkg.tar.xz";
    sha256      = "6020ab8af7a05fdbd4f33ed7b2f5686bfd28782b3f9436791c5e084d62e1be50";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-flexmock" = fetch {
    name        = "mingw-w64-i686-python3-flexmock";
    version     = "0.10.2";
    filename    = "mingw-w64-i686-python3-flexmock-0.10.2-1-any.pkg.tar.xz";
    sha256      = "edd4e898a882565b65a247dd566bd2534474b0fa4326388de8e1a33aea542063";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-fonttools" = fetch {
    name        = "mingw-w64-i686-python3-fonttools";
    version     = "3.30.0";
    filename    = "mingw-w64-i686-python3-fonttools-3.30.0-1-any.pkg.tar.xz";
    sha256      = "223952ccd589ef5dd520f14881a199391d0808fd79d2026e357f2f3eeae78cdb";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-numpy ];
  };

  "mingw-w64-i686-python3-freezegun" = fetch {
    name        = "mingw-w64-i686-python3-freezegun";
    version     = "0.3.11";
    filename    = "mingw-w64-i686-python3-freezegun-0.3.11-1-any.pkg.tar.xz";
    sha256      = "871224f7d51bf700496fd6a86d345c487b3ab72fe196fb3b4efbc71720271794";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-dateutil ];
  };

  "mingw-w64-i686-python3-funcsigs" = fetch {
    name        = "mingw-w64-i686-python3-funcsigs";
    version     = "1.0.2";
    filename    = "mingw-w64-i686-python3-funcsigs-1.0.2-2-any.pkg.tar.xz";
    sha256      = "0a5aaadfe3b3d74dc50953c52eee7cfb3c6b8beb8eff851b0593e611cb78d97e";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-future" = fetch {
    name        = "mingw-w64-i686-python3-future";
    version     = "0.17.1";
    filename    = "mingw-w64-i686-python3-future-0.17.1-1-any.pkg.tar.xz";
    sha256      = "4a21af63666465e77c64d3891b148218204826d131d3ad7def65aa2c22bd7ba2";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-genty" = fetch {
    name        = "mingw-w64-i686-python3-genty";
    version     = "1.3.2";
    filename    = "mingw-w64-i686-python3-genty-1.3.2-2-any.pkg.tar.xz";
    sha256      = "efdbd794794699302cd6c03caf499f1fb0ce8e54af7dae2e8658706ea6e32d94";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-gmpy2" = fetch {
    name        = "mingw-w64-i686-python3-gmpy2";
    version     = "2.1.0a4";
    filename    = "mingw-w64-i686-python3-gmpy2-2.1.0a4-1-any.pkg.tar.xz";
    sha256      = "42fbd779cdda1d87060d44093d58dbc66297f2510f4a81b335889e5a0f0a8c2b";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-mpc ];
  };

  "mingw-w64-i686-python3-gobject" = fetch {
    name        = "mingw-w64-i686-python3-gobject";
    version     = "3.30.4";
    filename    = "mingw-w64-i686-python3-gobject-3.30.4-1-any.pkg.tar.xz";
    sha256      = "5efe3161cd4996e3c803a907384ee9384139489be6005c3a010753df42e122e3";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-python3-cairo mingw-w64-i686-libffi mingw-w64-i686-gobject-introspection-runtime (assert mingw-w64-i686-pygobject-devel.version=="3.30.4"; mingw-w64-i686-pygobject-devel) ];
  };

  "mingw-w64-i686-python3-gobject2" = fetch {
    name        = "mingw-w64-i686-python3-gobject2";
    version     = "2.28.7";
    filename    = "mingw-w64-i686-python3-gobject2-2.28.7-1-any.pkg.tar.xz";
    sha256      = "e7798b4789d474a5a3552fa5accf82402d77b74a982a4071b26b9136fb9d62c1";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-libffi mingw-w64-i686-gobject-introspection-runtime (assert mingw-w64-i686-pygobject2-devel.version=="2.28.7"; mingw-w64-i686-pygobject2-devel) ];
  };

  "mingw-w64-i686-python3-greenlet" = fetch {
    name        = "mingw-w64-i686-python3-greenlet";
    version     = "0.4.15";
    filename    = "mingw-w64-i686-python3-greenlet-0.4.15-1-any.pkg.tar.xz";
    sha256      = "37ef178e7b379cbfbfca407204478059039b897a2c6aa2c99e56c1398f4f89a2";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-h5py" = fetch {
    name        = "mingw-w64-i686-python3-h5py";
    version     = "2.9.0";
    filename    = "mingw-w64-i686-python3-h5py-2.9.0-1-any.pkg.tar.xz";
    sha256      = "29c77791c41df7e5d27c98663cf2a486203c3c6e91aca607796f1a6c3d13d889";
    buildInputs = [ mingw-w64-i686-python3-numpy mingw-w64-i686-python3-six mingw-w64-i686-hdf5 ];
  };

  "mingw-w64-i686-python3-hacking" = fetch {
    name        = "mingw-w64-i686-python3-hacking";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python3-hacking-1.1.0-1-any.pkg.tar.xz";
    sha256      = "2e8be43387d1075b678b62f9313833137f8ab021310e65d71c7384ec7ae0a1af";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-html5lib" = fetch {
    name        = "mingw-w64-i686-python3-html5lib";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python3-html5lib-1.0.1-3-any.pkg.tar.xz";
    sha256      = "969d6889c02a2e0239025dd8cc3ba15ef57d33be1216b095618e6cf204c2b3c5";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-webencodings ];
  };

  "mingw-w64-i686-python3-httplib2" = fetch {
    name        = "mingw-w64-i686-python3-httplib2";
    version     = "0.12.0";
    filename    = "mingw-w64-i686-python3-httplib2-0.12.0-1-any.pkg.tar.xz";
    sha256      = "7bcc0ea6dda2c5065aab846226e089e4d4104d0a49012209170a7cc93a975e80";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-certifi mingw-w64-i686-ca-certificates ];
  };

  "mingw-w64-i686-python3-hypothesis" = fetch {
    name        = "mingw-w64-i686-python3-hypothesis";
    version     = "3.84.4";
    filename    = "mingw-w64-i686-python3-hypothesis-3.84.4-1-any.pkg.tar.xz";
    sha256      = "bdace9ca09a75677f592c6225b465b9aac40f07317e81a0f240f54c42890f699";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-attrs mingw-w64-i686-python3-coverage ];
  };

  "mingw-w64-i686-python3-icu" = fetch {
    name        = "mingw-w64-i686-python3-icu";
    version     = "2.2";
    filename    = "mingw-w64-i686-python3-icu-2.2-1-any.pkg.tar.xz";
    sha256      = "397c49e4792fc26082a4e6f3bfbc7c1dc41193cee983248c96432f9ce834da1c";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-icu ];
  };

  "mingw-w64-i686-python3-idna" = fetch {
    name        = "mingw-w64-i686-python3-idna";
    version     = "2.8";
    filename    = "mingw-w64-i686-python3-idna-2.8-1-any.pkg.tar.xz";
    sha256      = "01c8519bc7deff96e1991b8aeebe8355a66c416513285108a7b082d5d0de390b";
    buildInputs = [  ];
  };

  "mingw-w64-i686-python3-ifaddr" = fetch {
    name        = "mingw-w64-i686-python3-ifaddr";
    version     = "0.1.6";
    filename    = "mingw-w64-i686-python3-ifaddr-0.1.6-1-any.pkg.tar.xz";
    sha256      = "0e0dc22cf3dba0f038e5de8a67524cf7d896c49085906c761f9bd569ba55c5a5";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-imagesize" = fetch {
    name        = "mingw-w64-i686-python3-imagesize";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python3-imagesize-1.1.0-1-any.pkg.tar.xz";
    sha256      = "f9cf95850358926a4ad7a12d0a795572362132406900d150f44adad56c27f9ca";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-imbalanced-learn" = fetch {
    name        = "mingw-w64-i686-python3-imbalanced-learn";
    version     = "0.4.3";
    filename    = "mingw-w64-i686-python3-imbalanced-learn-0.4.3-1-any.pkg.tar.xz";
    sha256      = "66064c5d47936e06f4cc1de2cd1c1479915f4855f5d45b1e44210be26497e4dc";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-numpy mingw-w64-i686-python3-scipy ];
  };

  "mingw-w64-i686-python3-importlib-metadata" = fetch {
    name        = "mingw-w64-i686-python3-importlib-metadata";
    version     = "0.7";
    filename    = "mingw-w64-i686-python3-importlib-metadata-0.7-1-any.pkg.tar.xz";
    sha256      = "7c5eaa5e55eb9ea2c702543993cd210e0cb4bcf1fb8ca3ae1db21380f9abd9e8";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-iniconfig" = fetch {
    name        = "mingw-w64-i686-python3-iniconfig";
    version     = "1.0.0";
    filename    = "mingw-w64-i686-python3-iniconfig-1.0.0-2-any.pkg.tar.xz";
    sha256      = "67e4926cd4de5f25f084b0b1506a5cd58fd1232af74dffa16e530b5da3609f08";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-iocapture" = fetch {
    name        = "mingw-w64-i686-python3-iocapture";
    version     = "0.1.2";
    filename    = "mingw-w64-i686-python3-iocapture-0.1.2-1-any.pkg.tar.xz";
    sha256      = "8e4ce6c2a5ae917688d54a4be7c9dc809a9b444857d11ae00522aadad75754a8";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-ipykernel" = fetch {
    name        = "mingw-w64-i686-python3-ipykernel";
    version     = "5.1.0";
    filename    = "mingw-w64-i686-python3-ipykernel-5.1.0-1-any.pkg.tar.xz";
    sha256      = "bbf45996cd8a8fb53a8ef2f9f3fbf92425ff25140f56ee9652208b347d0f2d9f";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pathlib2 mingw-w64-i686-python3-pyzmq mingw-w64-i686-python3-ipython ];
  };

  "mingw-w64-i686-python3-ipython" = fetch {
    name        = "mingw-w64-i686-python3-ipython";
    version     = "7.1.1";
    filename    = "mingw-w64-i686-python3-ipython-7.1.1-1-any.pkg.tar.xz";
    sha256      = "a5b1af2ade71de8f1af3d800231aecf6d77018bdb821e44cf7c8bae75ff1167f";
    buildInputs = [ winpty mingw-w64-i686-sqlite3 mingw-w64-i686-python3-jedi mingw-w64-i686-python3-decorator mingw-w64-i686-python3-pickleshare mingw-w64-i686-python3-simplegeneric mingw-w64-i686-python3-traitlets (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python3-prompt_toolkit.version "2.0"; mingw-w64-i686-python3-prompt_toolkit) mingw-w64-i686-python3-pygments mingw-w64-i686-python3-simplegeneric mingw-w64-i686-python3-backcall mingw-w64-i686-python3-pexpect mingw-w64-i686-python3-colorama mingw-w64-i686-python3-win_unicode_console ];
  };

  "mingw-w64-i686-python3-ipython_genutils" = fetch {
    name        = "mingw-w64-i686-python3-ipython_genutils";
    version     = "0.2.0";
    filename    = "mingw-w64-i686-python3-ipython_genutils-0.2.0-2-any.pkg.tar.xz";
    sha256      = "cf8bd93c079eb1dfd40cf929fe7c109f00b7e5eb5fbbdb824fea5424ebda43fe";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-ipywidgets" = fetch {
    name        = "mingw-w64-i686-python3-ipywidgets";
    version     = "7.4.2";
    filename    = "mingw-w64-i686-python3-ipywidgets-7.4.2-1-any.pkg.tar.xz";
    sha256      = "6c50e368e370b071e1f04d8d8c5bbf8b6bf212d2a67a9ebb80ebc8dd815557f3";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-iso8601" = fetch {
    name        = "mingw-w64-i686-python3-iso8601";
    version     = "0.1.12";
    filename    = "mingw-w64-i686-python3-iso8601-0.1.12-1-any.pkg.tar.xz";
    sha256      = "5cee9dd41c51cc199dede262711e51b3c57e0593191707d67f12348e5abc4413";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-isort" = fetch {
    name        = "mingw-w64-i686-python3-isort";
    version     = "4.3.4";
    filename    = "mingw-w64-i686-python3-isort-4.3.4-1-any.pkg.tar.xz";
    sha256      = "637036860751d5a4eb07c120fcfffa8000cdbd88f047b45b5da87aaa6c14680f";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-jdcal" = fetch {
    name        = "mingw-w64-i686-python3-jdcal";
    version     = "1.4";
    filename    = "mingw-w64-i686-python3-jdcal-1.4-2-any.pkg.tar.xz";
    sha256      = "7fd7f06a6ea64e27ac755c1d3d1adb5fcfe156ff3bc05d1646beea8a7b1e1770";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-jedi" = fetch {
    name        = "mingw-w64-i686-python3-jedi";
    version     = "0.13.1";
    filename    = "mingw-w64-i686-python3-jedi-0.13.1-1-any.pkg.tar.xz";
    sha256      = "03c4de707b058db5970b041cc865e005738db132181a629d72a888b570e6bef2";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-parso ];
  };

  "mingw-w64-i686-python3-jinja" = fetch {
    name        = "mingw-w64-i686-python3-jinja";
    version     = "2.10";
    filename    = "mingw-w64-i686-python3-jinja-2.10-2-any.pkg.tar.xz";
    sha256      = "892e21a8d3308e244e5525b2fd49e5c883c3729ac70ff8844cdf8400e9f23c59";
    buildInputs = [ mingw-w64-i686-python3-setuptools mingw-w64-i686-python3-markupsafe ];
  };

  "mingw-w64-i686-python3-json-rpc" = fetch {
    name        = "mingw-w64-i686-python3-json-rpc";
    version     = "1.11.1";
    filename    = "mingw-w64-i686-python3-json-rpc-1.11.1-1-any.pkg.tar.xz";
    sha256      = "7f39847bdc3ee85f45a377b5ac4041dfe1dfc61bd54e20ced6a5afb3f59498dd";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-jsonschema" = fetch {
    name        = "mingw-w64-i686-python3-jsonschema";
    version     = "2.6.0";
    filename    = "mingw-w64-i686-python3-jsonschema-2.6.0-5-any.pkg.tar.xz";
    sha256      = "fcb9b07ffa3da7c372ff4756c91ec391b2424884cfa00f73a28541b45689d8b3";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-jupyter-nbconvert" = fetch {
    name        = "mingw-w64-i686-python3-jupyter-nbconvert";
    version     = "5.4";
    filename    = "mingw-w64-i686-python3-jupyter-nbconvert-5.4-2-any.pkg.tar.xz";
    sha256      = "c83f429cfc377cf6fb7604a432306ec10b56f272fd10315baa9ff54a6ce6912b";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-defusedxml mingw-w64-i686-python3-jupyter_client mingw-w64-i686-python3-jupyter-nbformat mingw-w64-i686-python3-pygments mingw-w64-i686-python3-mistune mingw-w64-i686-python3-jinja mingw-w64-i686-python3-entrypoints mingw-w64-i686-python3-traitlets mingw-w64-i686-python3-pandocfilters mingw-w64-i686-python3-bleach mingw-w64-i686-python3-testpath ];
  };

  "mingw-w64-i686-python3-jupyter-nbformat" = fetch {
    name        = "mingw-w64-i686-python3-jupyter-nbformat";
    version     = "4.4.0";
    filename    = "mingw-w64-i686-python3-jupyter-nbformat-4.4.0-2-any.pkg.tar.xz";
    sha256      = "793bdf25b4511fdce0b4b85cb778546d146710e8878c45a15376aac0b8356fef";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-traitlets mingw-w64-i686-python3-jsonschema mingw-w64-i686-python3-jupyter_core ];
  };

  "mingw-w64-i686-python3-jupyter_client" = fetch {
    name        = "mingw-w64-i686-python3-jupyter_client";
    version     = "5.2.4";
    filename    = "mingw-w64-i686-python3-jupyter_client-5.2.4-1-any.pkg.tar.xz";
    sha256      = "8ddad23729ec4c4daa5c54013fceb0f014374905d658f32eae358bd073911341";
    buildInputs = [ mingw-w64-i686-python3-ipykernel mingw-w64-i686-python3-jupyter_core mingw-w64-i686-python3-pyzmq ];
  };

  "mingw-w64-i686-python3-jupyter_console" = fetch {
    name        = "mingw-w64-i686-python3-jupyter_console";
    version     = "6.0.0";
    filename    = "mingw-w64-i686-python3-jupyter_console-6.0.0-1-any.pkg.tar.xz";
    sha256      = "c1b035f23a0ba9fa647dde3eb601fcaa17cca8eb3c20d4658fd7f81ae996af82";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-jupyter_core mingw-w64-i686-python3-jupyter_client mingw-w64-i686-python3-colorama ];
  };

  "mingw-w64-i686-python3-jupyter_core" = fetch {
    name        = "mingw-w64-i686-python3-jupyter_core";
    version     = "4.4.0";
    filename    = "mingw-w64-i686-python3-jupyter_core-4.4.0-3-any.pkg.tar.xz";
    sha256      = "63f8c8ec3af6f5a25b084b8e4795f8816eefc1d4e8eed652388083cccf6b2b4d";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-kiwisolver" = fetch {
    name        = "mingw-w64-i686-python3-kiwisolver";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python3-kiwisolver-1.0.1-2-any.pkg.tar.xz";
    sha256      = "f10427d458821ee7def436a5c12e0f47c39ae18655691584c5254b384d7eeaa8";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-lazy-object-proxy" = fetch {
    name        = "mingw-w64-i686-python3-lazy-object-proxy";
    version     = "1.3.1";
    filename    = "mingw-w64-i686-python3-lazy-object-proxy-1.3.1-2-any.pkg.tar.xz";
    sha256      = "1e7c062f0dc9339a17f1843793440a4152a3cd90e09bccc703cd7c029bd45e2f";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-ldap" = fetch {
    name        = "mingw-w64-i686-python3-ldap";
    version     = "3.1.0";
    filename    = "mingw-w64-i686-python3-ldap-3.1.0-1-any.pkg.tar.xz";
    sha256      = "952d50637b27a3f60dbef6ebadcc431f7b734fdfe4d9c12817b960ea86842232";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-ldap3" = fetch {
    name        = "mingw-w64-i686-python3-ldap3";
    version     = "2.5.1";
    filename    = "mingw-w64-i686-python3-ldap3-2.5.1-1-any.pkg.tar.xz";
    sha256      = "afd2f9e37c6e12fc8823af6acb2a13d3a437c6857e49c55714216106ca94c2db";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-lhafile" = fetch {
    name        = "mingw-w64-i686-python3-lhafile";
    version     = "0.2.1";
    filename    = "mingw-w64-i686-python3-lhafile-0.2.1-3-any.pkg.tar.xz";
    sha256      = "c4790c78374464906f75301043438a9b83f9ee2451bf120bd26c2315cf152053";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-lockfile" = fetch {
    name        = "mingw-w64-i686-python3-lockfile";
    version     = "0.12.2";
    filename    = "mingw-w64-i686-python3-lockfile-0.12.2-1-any.pkg.tar.xz";
    sha256      = "c921505bc710bd3031ac64e2aa034fcc71151a72ad946e7df1a483defc60b4be";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-lxml" = fetch {
    name        = "mingw-w64-i686-python3-lxml";
    version     = "4.3.0";
    filename    = "mingw-w64-i686-python3-lxml-4.3.0-1-any.pkg.tar.xz";
    sha256      = "ad30cb3362f409acb2ef12c8adbab0d5f7e8539e04d3867c9e6a1b36e6938909";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-mako" = fetch {
    name        = "mingw-w64-i686-python3-mako";
    version     = "1.0.7";
    filename    = "mingw-w64-i686-python3-mako-1.0.7-3-any.pkg.tar.xz";
    sha256      = "ba0d5cb24aaaa63794f0f29550201c8db5ea7620bf922bc49cc990222a4d126e";
    buildInputs = [ mingw-w64-i686-python3-markupsafe mingw-w64-i686-python3-beaker ];
  };

  "mingw-w64-i686-python3-markdown" = fetch {
    name        = "mingw-w64-i686-python3-markdown";
    version     = "3.0.1";
    filename    = "mingw-w64-i686-python3-markdown-3.0.1-1-any.pkg.tar.xz";
    sha256      = "360557c41ad9578753f198f746378c30127693099fd84e67d9063237922b37ed";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-markupsafe" = fetch {
    name        = "mingw-w64-i686-python3-markupsafe";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python3-markupsafe-1.1.0-1-any.pkg.tar.xz";
    sha256      = "0eca8bf4e51314845564378e69b28dae173c1bd5e1cb3517ea857d27c3aac1a9";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-matplotlib" = fetch {
    name        = "mingw-w64-i686-python3-matplotlib";
    version     = "3.0.2";
    filename    = "mingw-w64-i686-python3-matplotlib-3.0.2-1-any.pkg.tar.xz";
    sha256      = "d2e668e8a48e371ea0202d8edec3c13ae52aa742ec7100e48f882b48bc0e1800";
    buildInputs = [ mingw-w64-i686-python3-pytz mingw-w64-i686-python3-numpy mingw-w64-i686-python3-cycler mingw-w64-i686-python3-dateutil mingw-w64-i686-python3-pyparsing mingw-w64-i686-python3-kiwisolver mingw-w64-i686-freetype mingw-w64-i686-libpng ];
  };

  "mingw-w64-i686-python3-mccabe" = fetch {
    name        = "mingw-w64-i686-python3-mccabe";
    version     = "0.6.1";
    filename    = "mingw-w64-i686-python3-mccabe-0.6.1-1-any.pkg.tar.xz";
    sha256      = "449d3899499c9c8e8e1d7bc68c17735c259111373e0febc13d1fe0cc96a2bdd0";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-mimeparse" = fetch {
    name        = "mingw-w64-i686-python3-mimeparse";
    version     = "1.6.0";
    filename    = "mingw-w64-i686-python3-mimeparse-1.6.0-1-any.pkg.tar.xz";
    sha256      = "112cc7b8c4e581c193abcf8a32c3c93ab28b90a2c174e9cae3bae0b1629fa117";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-mistune" = fetch {
    name        = "mingw-w64-i686-python3-mistune";
    version     = "0.8.4";
    filename    = "mingw-w64-i686-python3-mistune-0.8.4-1-any.pkg.tar.xz";
    sha256      = "c67b12b296e3f30d694b18105672523a5691d61373121ce88c01dbd49cbc9cc3";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-mock" = fetch {
    name        = "mingw-w64-i686-python3-mock";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-python3-mock-2.0.0-3-any.pkg.tar.xz";
    sha256      = "da15911d4a038135c3c9ace4adc507d215f13c5f6642df223525fe8a109651a1";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-pbr ];
  };

  "mingw-w64-i686-python3-monotonic" = fetch {
    name        = "mingw-w64-i686-python3-monotonic";
    version     = "1.5";
    filename    = "mingw-w64-i686-python3-monotonic-1.5-1-any.pkg.tar.xz";
    sha256      = "907266d5bd7776527971608faede54c1df044a3cf929e3615b605d25f744adce";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-more-itertools" = fetch {
    name        = "mingw-w64-i686-python3-more-itertools";
    version     = "4.3.1";
    filename    = "mingw-w64-i686-python3-more-itertools-4.3.1-1-any.pkg.tar.xz";
    sha256      = "58a15eda8000ace3d27bbc62ebedd5f0c8b6d6771c65870f22b52259184d931f";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-mox3" = fetch {
    name        = "mingw-w64-i686-python3-mox3";
    version     = "0.26.0";
    filename    = "mingw-w64-i686-python3-mox3-0.26.0-1-any.pkg.tar.xz";
    sha256      = "b38eda716ade4ca40308ca2f02adf45ff50ee9ed7f00bc0aa437e015ec783881";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pbr mingw-w64-i686-python3-fixtures ];
  };

  "mingw-w64-i686-python3-mpmath" = fetch {
    name        = "mingw-w64-i686-python3-mpmath";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python3-mpmath-1.1.0-1-any.pkg.tar.xz";
    sha256      = "e78179bbda3ea2999668688e4af137d6cb758fe71e584c00ae49b64653b50bdd";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-gmpy2 ];
  };

  "mingw-w64-i686-python3-msgpack" = fetch {
    name        = "mingw-w64-i686-python3-msgpack";
    version     = "0.5.6";
    filename    = "mingw-w64-i686-python3-msgpack-0.5.6-1-any.pkg.tar.xz";
    sha256      = "25e738dc796f313caeeead754dd9cd2d3ec802b080c1fd903b89e5fba886421c";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-ndg-httpsclient" = fetch {
    name        = "mingw-w64-i686-python3-ndg-httpsclient";
    version     = "0.5.1";
    filename    = "mingw-w64-i686-python3-ndg-httpsclient-0.5.1-1-any.pkg.tar.xz";
    sha256      = "0e569730405520ff77b87d4bd04a7259e3f2aece2f9bacaafd9c98a1070dce7d";
    buildInputs = [ mingw-w64-i686-python3-pyopenssl mingw-w64-i686-python3-pyasn1 ];
  };

  "mingw-w64-i686-python3-netaddr" = fetch {
    name        = "mingw-w64-i686-python3-netaddr";
    version     = "0.7.19";
    filename    = "mingw-w64-i686-python3-netaddr-0.7.19-1-any.pkg.tar.xz";
    sha256      = "a8417e94fe567eb859b644c864d596f7634e9d3d67a0f7767be2681c50f08783";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-netifaces" = fetch {
    name        = "mingw-w64-i686-python3-netifaces";
    version     = "0.10.9";
    filename    = "mingw-w64-i686-python3-netifaces-0.10.9-1-any.pkg.tar.xz";
    sha256      = "151e0d6d373e1e3dc2b4ff34de44bf7ba6e818d351b61f45757be9043ed6ef5e";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-networkx" = fetch {
    name        = "mingw-w64-i686-python3-networkx";
    version     = "2.2";
    filename    = "mingw-w64-i686-python3-networkx-2.2-1-any.pkg.tar.xz";
    sha256      = "9dc96601d0666545a0f346351c35a73f0921a0b407d03e7a4427a3e3e9913d46";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-decorator ];
  };

  "mingw-w64-i686-python3-nose" = fetch {
    name        = "mingw-w64-i686-python3-nose";
    version     = "1.3.7";
    filename    = "mingw-w64-i686-python3-nose-1.3.7-8-any.pkg.tar.xz";
    sha256      = "82f0b291afe0c2ff23a8750f8330a39a608b76ada4b76a94f7131fa95d9e1e69";
    buildInputs = [ mingw-w64-i686-python3-setuptools ];
  };

  "mingw-w64-i686-python3-notebook" = fetch {
    name        = "mingw-w64-i686-python3-notebook";
    version     = "5.6.0";
    filename    = "mingw-w64-i686-python3-notebook-5.6.0-1-any.pkg.tar.xz";
    sha256      = "b331916f9ec354b3a3ba53f233d00ad32b4d69a10906e638a334bcab186588b8";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-jupyter_core mingw-w64-i686-python3-jupyter_client mingw-w64-i686-python3-jupyter-nbformat mingw-w64-i686-python3-jupyter-nbconvert mingw-w64-i686-python3-ipywidgets mingw-w64-i686-python3-jinja mingw-w64-i686-python3-traitlets mingw-w64-i686-python3-tornado mingw-w64-i686-python3-terminado mingw-w64-i686-python3-send2trash mingw-w64-i686-python3-prometheus-client ];
  };

  "mingw-w64-i686-python3-nuitka" = fetch {
    name        = "mingw-w64-i686-python3-nuitka";
    version     = "0.6.0.6";
    filename    = "mingw-w64-i686-python3-nuitka-0.6.0.6-1-any.pkg.tar.xz";
    sha256      = "741701453f424ba8659e720200b976537eb57eba82d907f3a276c7a893692474";
    buildInputs = [ mingw-w64-i686-python3-setuptools ];
  };

  "mingw-w64-i686-python3-numexpr" = fetch {
    name        = "mingw-w64-i686-python3-numexpr";
    version     = "2.6.9";
    filename    = "mingw-w64-i686-python3-numexpr-2.6.9-1-any.pkg.tar.xz";
    sha256      = "a1755c7cfcc353833ee00d4379f3356365e646cc5b41ed0f58f20c2b2cf45482";
    buildInputs = [ mingw-w64-i686-python3-numpy ];
  };

  "mingw-w64-i686-python3-numpy" = fetch {
    name        = "mingw-w64-i686-python3-numpy";
    version     = "1.15.4";
    filename    = "mingw-w64-i686-python3-numpy-1.15.4-1-any.pkg.tar.xz";
    sha256      = "b755869960bab3bb6f601458903b6e976e0829759795847d3cc4acd8f8411bb1";
    buildInputs = [ mingw-w64-i686-openblas mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-olefile" = fetch {
    name        = "mingw-w64-i686-python3-olefile";
    version     = "0.46";
    filename    = "mingw-w64-i686-python3-olefile-0.46-1-any.pkg.tar.xz";
    sha256      = "f5fcc68e40b9646a7ad274e3c1a8410aa71f9d63b92d6a02cf10d0fdf4da7bda";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-openmdao" = fetch {
    name        = "mingw-w64-i686-python3-openmdao";
    version     = "2.5.0";
    filename    = "mingw-w64-i686-python3-openmdao-2.5.0-1-any.pkg.tar.xz";
    sha256      = "0b67a6c425a5c575e52698c7cbac43b0a01b4ce09e4acacc26d5adce5e9f07e2";
    buildInputs = [ mingw-w64-i686-python3-numpy mingw-w64-i686-python3-scipy mingw-w64-i686-python3-networkx mingw-w64-i686-python3-sqlitedict mingw-w64-i686-python3-pyparsing mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-openpyxl" = fetch {
    name        = "mingw-w64-i686-python3-openpyxl";
    version     = "2.5.12";
    filename    = "mingw-w64-i686-python3-openpyxl-2.5.12-1-any.pkg.tar.xz";
    sha256      = "9d053ffae68a4db63c07a31a7b026a00e1cd8ba6123f584b1d20b4d46e3ceeed";
    buildInputs = [ mingw-w64-i686-python3-jdcal mingw-w64-i686-python3-et-xmlfile ];
  };

  "mingw-w64-i686-python3-oslo-concurrency" = fetch {
    name        = "mingw-w64-i686-python3-oslo-concurrency";
    version     = "3.29.0";
    filename    = "mingw-w64-i686-python3-oslo-concurrency-3.29.0-1-any.pkg.tar.xz";
    sha256      = "b2bba7729c7a3dcd48b97edbb7630f676151b97279ca71e1116659550c7c61e3";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-pbr mingw-w64-i686-python3-oslo-config mingw-w64-i686-python3-oslo-i18n mingw-w64-i686-python3-oslo-utils mingw-w64-i686-python3-fasteners ];
  };

  "mingw-w64-i686-python3-oslo-config" = fetch {
    name        = "mingw-w64-i686-python3-oslo-config";
    version     = "6.7.0";
    filename    = "mingw-w64-i686-python3-oslo-config-6.7.0-1-any.pkg.tar.xz";
    sha256      = "f3ec5bdb5679b3054e4f82902f35c4aa759e41e3ee9c782596260fbb993879f3";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-netaddr mingw-w64-i686-python3-stevedore mingw-w64-i686-python3-debtcollector mingw-w64-i686-python3-oslo-i18n mingw-w64-i686-python3-rfc3986 mingw-w64-i686-python3-yaml ];
  };

  "mingw-w64-i686-python3-oslo-context" = fetch {
    name        = "mingw-w64-i686-python3-oslo-context";
    version     = "2.22.0";
    filename    = "mingw-w64-i686-python3-oslo-context-2.22.0-1-any.pkg.tar.xz";
    sha256      = "b63b6ed75d79316be526e9c4ea7cc77f5d5b5d485c7b3f3363eb13086568dfa8";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pbr mingw-w64-i686-python3-debtcollector ];
  };

  "mingw-w64-i686-python3-oslo-db" = fetch {
    name        = "mingw-w64-i686-python3-oslo-db";
    version     = "4.42.0";
    filename    = "mingw-w64-i686-python3-oslo-db-4.42.0-1-any.pkg.tar.xz";
    sha256      = "8fee25254b772a92f048f55221a9b24412ac1eb364d818300c04ffa066eb928a";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-pbr mingw-w64-i686-python3-alembic mingw-w64-i686-python3-debtcollector mingw-w64-i686-python3-oslo-i18n mingw-w64-i686-python3-oslo-config mingw-w64-i686-python3-oslo-utils mingw-w64-i686-python3-sqlalchemy mingw-w64-i686-python3-sqlalchemy-migrate mingw-w64-i686-python3-stevedore ];
  };

  "mingw-w64-i686-python3-oslo-i18n" = fetch {
    name        = "mingw-w64-i686-python3-oslo-i18n";
    version     = "3.23.0";
    filename    = "mingw-w64-i686-python3-oslo-i18n-3.23.0-1-any.pkg.tar.xz";
    sha256      = "2802db005e918070911239f29a1276a4b626bcec06205839ea07c22d29247eef";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-pbr mingw-w64-i686-python3-babel ];
  };

  "mingw-w64-i686-python3-oslo-log" = fetch {
    name        = "mingw-w64-i686-python3-oslo-log";
    version     = "3.42.1";
    filename    = "mingw-w64-i686-python3-oslo-log-3.42.1-1-any.pkg.tar.xz";
    sha256      = "ee90bed00db2131ad5eedab6fdb681590dba3a6be247177fa3571d944427ed26";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-pbr mingw-w64-i686-python3-oslo-config mingw-w64-i686-python3-oslo-context mingw-w64-i686-python3-oslo-i18n mingw-w64-i686-python3-oslo-utils mingw-w64-i686-python3-oslo-serialization mingw-w64-i686-python3-debtcollector mingw-w64-i686-python3-dateutil mingw-w64-i686-python3-monotonic ];
  };

  "mingw-w64-i686-python3-oslo-serialization" = fetch {
    name        = "mingw-w64-i686-python3-oslo-serialization";
    version     = "2.28.1";
    filename    = "mingw-w64-i686-python3-oslo-serialization-2.28.1-1-any.pkg.tar.xz";
    sha256      = "fdba5b436e8cc4f4894f6500436905f4de7fb3d45fe37cf545f34f91c42e1470";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-pbr mingw-w64-i686-python3-babel mingw-w64-i686-python3-msgpack mingw-w64-i686-python3-oslo-utils mingw-w64-i686-python3-pytz ];
  };

  "mingw-w64-i686-python3-oslo-utils" = fetch {
    name        = "mingw-w64-i686-python3-oslo-utils";
    version     = "3.39.0";
    filename    = "mingw-w64-i686-python3-oslo-utils-3.39.0-1-any.pkg.tar.xz";
    sha256      = "a1c6d75d16c6f8dba0c7dc03ddbaa69d6bb6e5adc457c0b66aac481826185ae2";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-oslosphinx" = fetch {
    name        = "mingw-w64-i686-python3-oslosphinx";
    version     = "4.18.0";
    filename    = "mingw-w64-i686-python3-oslosphinx-4.18.0-1-any.pkg.tar.xz";
    sha256      = "2697147b42d98b7b150f638ee35a9d6b0319f51743333288f5c8b6abaaf67675";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-requests ];
  };

  "mingw-w64-i686-python3-oslotest" = fetch {
    name        = "mingw-w64-i686-python3-oslotest";
    version     = "3.7.0";
    filename    = "mingw-w64-i686-python3-oslotest-3.7.0-1-any.pkg.tar.xz";
    sha256      = "0a650577b54289dea4d4ceb244bcb8114617baaff67e48c512dcf1743f572b80";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-packaging" = fetch {
    name        = "mingw-w64-i686-python3-packaging";
    version     = "18.0";
    filename    = "mingw-w64-i686-python3-packaging-18.0-1-any.pkg.tar.xz";
    sha256      = "50d1d2de11799c8108eb7e8c06a09aac70c3bca8aa9e8babe206ffea78689a3d";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pyparsing mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-pandas" = fetch {
    name        = "mingw-w64-i686-python3-pandas";
    version     = "0.23.4";
    filename    = "mingw-w64-i686-python3-pandas-0.23.4-1-any.pkg.tar.xz";
    sha256      = "81dcf25ab660cfe12228653c8d1130c130539397d1edc093f7f4403083a299d4";
    buildInputs = [ mingw-w64-i686-python3-numpy mingw-w64-i686-python3-pytz mingw-w64-i686-python3-dateutil mingw-w64-i686-python3-setuptools ];
  };

  "mingw-w64-i686-python3-pandocfilters" = fetch {
    name        = "mingw-w64-i686-python3-pandocfilters";
    version     = "1.4.2";
    filename    = "mingw-w64-i686-python3-pandocfilters-1.4.2-2-any.pkg.tar.xz";
    sha256      = "38c1831a1ee6711a0134373a698ee2d7264df78f8515b7888ae8b001550faf49";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-paramiko" = fetch {
    name        = "mingw-w64-i686-python3-paramiko";
    version     = "2.4.2";
    filename    = "mingw-w64-i686-python3-paramiko-2.4.2-1-any.pkg.tar.xz";
    sha256      = "eec89a519e36df966f3ea64c7dbcefa143fff97df6588a74a73979f259426f9c";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-parso" = fetch {
    name        = "mingw-w64-i686-python3-parso";
    version     = "0.3.1";
    filename    = "mingw-w64-i686-python3-parso-0.3.1-1-any.pkg.tar.xz";
    sha256      = "e70185f2c918a9e18bbd499c920926a071c4780ade9edd1402820b9a5ff57091";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-path" = fetch {
    name        = "mingw-w64-i686-python3-path";
    version     = "11.5.0";
    filename    = "mingw-w64-i686-python3-path-11.5.0-1-any.pkg.tar.xz";
    sha256      = "99c6338c8b89fc3dbb36fdc24effcb2e6e0a97282e6fb2592ef5e35740b921ef";
    buildInputs = [ mingw-w64-i686-python3-importlib-metadata ];
  };

  "mingw-w64-i686-python3-pathlib2" = fetch {
    name        = "mingw-w64-i686-python3-pathlib2";
    version     = "2.3.3";
    filename    = "mingw-w64-i686-python3-pathlib2-2.3.3-1-any.pkg.tar.xz";
    sha256      = "abe7bcd524cf44fca4d82b1c9c50f14baf64de2f4e7b7ad9e502f83769cf593a";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-scandir ];
  };

  "mingw-w64-i686-python3-pathtools" = fetch {
    name        = "mingw-w64-i686-python3-pathtools";
    version     = "0.1.2";
    filename    = "mingw-w64-i686-python3-pathtools-0.1.2-1-any.pkg.tar.xz";
    sha256      = "ea39cede1a4cc22c79f3a822b09562ed44ce7c4c8a229c03b9d460a0e1de671e";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-patsy" = fetch {
    name        = "mingw-w64-i686-python3-patsy";
    version     = "0.5.1";
    filename    = "mingw-w64-i686-python3-patsy-0.5.1-1-any.pkg.tar.xz";
    sha256      = "f110ef8f7dc5b9006ec9a3186f2270ff3f6ce24f8fe4ca182e458aa1da6e8a42";
    buildInputs = [ mingw-w64-i686-python3-numpy ];
  };

  "mingw-w64-i686-python3-pbr" = fetch {
    name        = "mingw-w64-i686-python3-pbr";
    version     = "5.1.1";
    filename    = "mingw-w64-i686-python3-pbr-5.1.1-2-any.pkg.tar.xz";
    sha256      = "e75a2470c15a2d7f9e6677903f5dd5edde0ec9ac28e476ac4f022defd1837c88";
    buildInputs = [ mingw-w64-i686-python3-setuptools ];
  };

  "mingw-w64-i686-python3-pdfrw" = fetch {
    name        = "mingw-w64-i686-python3-pdfrw";
    version     = "0.4";
    filename    = "mingw-w64-i686-python3-pdfrw-0.4-2-any.pkg.tar.xz";
    sha256      = "fdc39f72e43ff5275e274f4562730c50d0f2941992fb96e9aab161a098e8d3e3";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pep517" = fetch {
    name        = "mingw-w64-i686-python3-pep517";
    version     = "0.5.0";
    filename    = "mingw-w64-i686-python3-pep517-0.5.0-1-any.pkg.tar.xz";
    sha256      = "c02ca7a720209ea3ecf451d1cc465fe6a120da7636a898ae95cf488991abdad1";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pexpect" = fetch {
    name        = "mingw-w64-i686-python3-pexpect";
    version     = "4.6.0";
    filename    = "mingw-w64-i686-python3-pexpect-4.6.0-1-any.pkg.tar.xz";
    sha256      = "76b7a1d255d33525ec8e7d9da43c8c72efbd4c138d831e77a5fb254ba4b4a867";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-ptyprocess ];
  };

  "mingw-w64-i686-python3-pgen2" = fetch {
    name        = "mingw-w64-i686-python3-pgen2";
    version     = "0.1.0";
    filename    = "mingw-w64-i686-python3-pgen2-0.1.0-3-any.pkg.tar.xz";
    sha256      = "d02da45b572e746f4c52a2a8b066191ff3c33cb0b9826040c238bbb6d9c13e19";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pickleshare" = fetch {
    name        = "mingw-w64-i686-python3-pickleshare";
    version     = "0.7.5";
    filename    = "mingw-w64-i686-python3-pickleshare-0.7.5-1-any.pkg.tar.xz";
    sha256      = "4799a8cf1caa5f8034c5e0987f912cee0f4a370c75506fac2f4bc35df99be30c";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python3-path.version "8.1"; mingw-w64-i686-python3-path) ];
  };

  "mingw-w64-i686-python3-pillow" = fetch {
    name        = "mingw-w64-i686-python3-pillow";
    version     = "5.3.0";
    filename    = "mingw-w64-i686-python3-pillow-5.3.0-1-any.pkg.tar.xz";
    sha256      = "08ab42446c1fedd9f96821ff2bea9dc2b80a6d67e7af23e08a7af285283f43c3";
    buildInputs = [ mingw-w64-i686-freetype mingw-w64-i686-lcms2 mingw-w64-i686-libjpeg mingw-w64-i686-libtiff mingw-w64-i686-libwebp mingw-w64-i686-openjpeg2 mingw-w64-i686-zlib mingw-w64-i686-python3 mingw-w64-i686-python3-olefile ];
    broken      = true; # broken dependency mingw-w64-i686-python3-pillow -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python3-pip" = fetch {
    name        = "mingw-w64-i686-python3-pip";
    version     = "18.1";
    filename    = "mingw-w64-i686-python3-pip-18.1-2-any.pkg.tar.xz";
    sha256      = "f1167670d1dfd9d7fede46384ee6ef7a0feb83f7ff5deb6a4816c36f91a55e9f";
    buildInputs = [ mingw-w64-i686-python3-setuptools mingw-w64-i686-python3-appdirs mingw-w64-i686-python3-cachecontrol mingw-w64-i686-python3-colorama mingw-w64-i686-python3-distlib mingw-w64-i686-python3-html5lib mingw-w64-i686-python3-lockfile mingw-w64-i686-python3-msgpack mingw-w64-i686-python3-packaging mingw-w64-i686-python3-pep517 mingw-w64-i686-python3-progress mingw-w64-i686-python3-pyparsing mingw-w64-i686-python3-pytoml mingw-w64-i686-python3-requests mingw-w64-i686-python3-retrying mingw-w64-i686-python3-six mingw-w64-i686-python3-webencodings ];
  };

  "mingw-w64-i686-python3-pkginfo" = fetch {
    name        = "mingw-w64-i686-python3-pkginfo";
    version     = "1.4.2";
    filename    = "mingw-w64-i686-python3-pkginfo-1.4.2-1-any.pkg.tar.xz";
    sha256      = "5c41774936f32bd58523b774459acfc00078a481fab2ffe90104bce811c0b6d1";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pluggy" = fetch {
    name        = "mingw-w64-i686-python3-pluggy";
    version     = "0.8.0";
    filename    = "mingw-w64-i686-python3-pluggy-0.8.0-2-any.pkg.tar.xz";
    sha256      = "bdb05be48e18665f44db3d6be273816e3230115d888fed2437139f117c3b6ad1";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-ply" = fetch {
    name        = "mingw-w64-i686-python3-ply";
    version     = "3.11";
    filename    = "mingw-w64-i686-python3-ply-3.11-2-any.pkg.tar.xz";
    sha256      = "6fc0e465e45cbd6c6707989366189428dfb6f4a710516c79b82b202350b74952";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pptx" = fetch {
    name        = "mingw-w64-i686-python3-pptx";
    version     = "0.6.10";
    filename    = "mingw-w64-i686-python3-pptx-0.6.10-1-any.pkg.tar.xz";
    sha256      = "451aea8d43f4a2b3ccc4a9710ca64f3152b1a59dbd321bb1e2f393f6bc462dc0";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python3-lxml.version "3.1.0"; mingw-w64-i686-python3-lxml) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python3-pillow.version "2.6.1"; mingw-w64-i686-python3-pillow) (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python3-xlsxwriter.version "0.5.7"; mingw-w64-i686-python3-xlsxwriter) ];
    broken      = true; # broken dependency mingw-w64-i686-python3-pillow -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python3-pretend" = fetch {
    name        = "mingw-w64-i686-python3-pretend";
    version     = "1.0.9";
    filename    = "mingw-w64-i686-python3-pretend-1.0.9-2-any.pkg.tar.xz";
    sha256      = "e67893cfb9e2c78f6c9903cc4cc643d8bf9a1f966e6f1fa1d4f12ecbb8971609";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-prettytable" = fetch {
    name        = "mingw-w64-i686-python3-prettytable";
    version     = "0.7.2";
    filename    = "mingw-w64-i686-python3-prettytable-0.7.2-2-any.pkg.tar.xz";
    sha256      = "2faffb0fe0d7274f612a245e254cb68ab624938dda2304e2f86eb2a28b8c00de";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-progress" = fetch {
    name        = "mingw-w64-i686-python3-progress";
    version     = "1.4";
    filename    = "mingw-w64-i686-python3-progress-1.4-3-any.pkg.tar.xz";
    sha256      = "eb3890380c2c6c01b7a873d686cd639d44ba0ac3e69aee79267d507d06c87983";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-prometheus-client" = fetch {
    name        = "mingw-w64-i686-python3-prometheus-client";
    version     = "0.2.0";
    filename    = "mingw-w64-i686-python3-prometheus-client-0.2.0-1-any.pkg.tar.xz";
    sha256      = "db9353ff1a724a062ceca256f4a0f0ca265623fb976d09da29d765d4000d7470";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-prompt_toolkit" = fetch {
    name        = "mingw-w64-i686-python3-prompt_toolkit";
    version     = "2.0.7";
    filename    = "mingw-w64-i686-python3-prompt_toolkit-2.0.7-1-any.pkg.tar.xz";
    sha256      = "25c8afe447f944160d25aefa9d848b006d07d085d20d3ec6ccdb9f78d0cb5a5f";
    buildInputs = [ mingw-w64-i686-python3-pygments mingw-w64-i686-python3-six mingw-w64-i686-python3-wcwidth ];
  };

  "mingw-w64-i686-python3-psutil" = fetch {
    name        = "mingw-w64-i686-python3-psutil";
    version     = "5.4.8";
    filename    = "mingw-w64-i686-python3-psutil-5.4.8-1-any.pkg.tar.xz";
    sha256      = "adba6f28adc1428730f4e4dc1e8fab21b19d97cfe1620ae7bae04ba46dbff1d8";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-psycopg2" = fetch {
    name        = "mingw-w64-i686-python3-psycopg2";
    version     = "2.7.6.1";
    filename    = "mingw-w64-i686-python3-psycopg2-2.7.6.1-1-any.pkg.tar.xz";
    sha256      = "f6cacc78710b0193c3cd8b47f7ce34f0871e61f1ca3a44c64c5008f8a182e4bf";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-ptyprocess" = fetch {
    name        = "mingw-w64-i686-python3-ptyprocess";
    version     = "0.6.0";
    filename    = "mingw-w64-i686-python3-ptyprocess-0.6.0-1-any.pkg.tar.xz";
    sha256      = "11238107eda57fb5463d6143188ea9d3a100bc87790f68bae3436b22f7831877";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-py" = fetch {
    name        = "mingw-w64-i686-python3-py";
    version     = "1.7.0";
    filename    = "mingw-w64-i686-python3-py-1.7.0-1-any.pkg.tar.xz";
    sha256      = "246bb3d38a9e6a7eedd46a1e10bbda2d89a2e8249fc0f4f33ad398fa098bbffb";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-py-cpuinfo" = fetch {
    name        = "mingw-w64-i686-python3-py-cpuinfo";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-python3-py-cpuinfo-4.0.0-1-any.pkg.tar.xz";
    sha256      = "1fdb2d351b755fbeeeb6845c40f86d67d90dbeff5ca895b0a265df0806bdd185";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pyamg" = fetch {
    name        = "mingw-w64-i686-python3-pyamg";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-python3-pyamg-4.0.0-1-any.pkg.tar.xz";
    sha256      = "4a1a2903a61041a260973d512726a40adc670bcc87b261568447d9657b348afb";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-scipy mingw-w64-i686-python3-numpy ];
  };

  "mingw-w64-i686-python3-pyasn1" = fetch {
    name        = "mingw-w64-i686-python3-pyasn1";
    version     = "0.4.4";
    filename    = "mingw-w64-i686-python3-pyasn1-0.4.4-1-any.pkg.tar.xz";
    sha256      = "c81c357aa5a00461c7e63488028b9ec2bcdd4ecc34c022cc8d1dcd219e9d7668";
    buildInputs = [  ];
  };

  "mingw-w64-i686-python3-pyasn1-modules" = fetch {
    name        = "mingw-w64-i686-python3-pyasn1-modules";
    version     = "0.2.2";
    filename    = "mingw-w64-i686-python3-pyasn1-modules-0.2.2-1-any.pkg.tar.xz";
    sha256      = "8535f68bd4535fe2bc2c254b808e1ac03076e39bc7dd7953d838f47fdae6e89e";
  };

  "mingw-w64-i686-python3-pycodestyle" = fetch {
    name        = "mingw-w64-i686-python3-pycodestyle";
    version     = "2.4.0";
    filename    = "mingw-w64-i686-python3-pycodestyle-2.4.0-1-any.pkg.tar.xz";
    sha256      = "753e87cf96c95295ba638217c8cbdfa9f33d1ad6f7fabea8c247cc85fef2ba8a";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pycparser" = fetch {
    name        = "mingw-w64-i686-python3-pycparser";
    version     = "2.19";
    filename    = "mingw-w64-i686-python3-pycparser-2.19-1-any.pkg.tar.xz";
    sha256      = "59e704957891abe7de39d693ff40d139bc408a80f317a1c01f5ddb8e3430998e";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-ply ];
  };

  "mingw-w64-i686-python3-pyflakes" = fetch {
    name        = "mingw-w64-i686-python3-pyflakes";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-python3-pyflakes-2.0.0-2-any.pkg.tar.xz";
    sha256      = "30730c781a01fcc56ed8a4df6aadf36a47a278157c0604c873648364f69dd1d0";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pyglet" = fetch {
    name        = "mingw-w64-i686-python3-pyglet";
    version     = "1.3.2";
    filename    = "mingw-w64-i686-python3-pyglet-1.3.2-1-any.pkg.tar.xz";
    sha256      = "dc23312d2e36c1ed671baa54317ee635aeec16f08a5339bbbc0f9df5ba49ef42";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-future ];
  };

  "mingw-w64-i686-python3-pygments" = fetch {
    name        = "mingw-w64-i686-python3-pygments";
    version     = "2.3.1";
    filename    = "mingw-w64-i686-python3-pygments-2.3.1-1-any.pkg.tar.xz";
    sha256      = "3ad8c085da96e18db70e0dbdc372da2f617c8deb30db0617365a405294ae7f2a";
    buildInputs = [ mingw-w64-i686-python3-setuptools ];
  };

  "mingw-w64-i686-python3-pylint" = fetch {
    name        = "mingw-w64-i686-python3-pylint";
    version     = "2.2.2";
    filename    = "mingw-w64-i686-python3-pylint-2.2.2-1-any.pkg.tar.xz";
    sha256      = "dba74aa59b8e41300473e2235a29a29e4ea5d6b5b89c4409b5e6b373eb0369b4";
    buildInputs = [ mingw-w64-i686-python3-astroid mingw-w64-i686-python3-colorama mingw-w64-i686-python3-mccabe mingw-w64-i686-python3-isort ];
  };

  "mingw-w64-i686-python3-pynacl" = fetch {
    name        = "mingw-w64-i686-python3-pynacl";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-python3-pynacl-1.3.0-1-any.pkg.tar.xz";
    sha256      = "9d47296a324ae7db47de87d23d0f0651061d2fab49b187e65ee55de16e2034bc";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pyopenssl" = fetch {
    name        = "mingw-w64-i686-python3-pyopenssl";
    version     = "18.0.0";
    filename    = "mingw-w64-i686-python3-pyopenssl-18.0.0-3-any.pkg.tar.xz";
    sha256      = "831cda4deb864021efbfc8081a35f2dd2d7d467c720d4c01242c463c63f8b645";
    buildInputs = [ mingw-w64-i686-openssl mingw-w64-i686-python3-cryptography mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-pyparsing" = fetch {
    name        = "mingw-w64-i686-python3-pyparsing";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-python3-pyparsing-2.3.0-1-any.pkg.tar.xz";
    sha256      = "a386a2d1cc4801541d70404bf4d8d73f9f5e4ca2778e168e5f465c27ce5bd435";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pyperclip" = fetch {
    name        = "mingw-w64-i686-python3-pyperclip";
    version     = "1.7.0";
    filename    = "mingw-w64-i686-python3-pyperclip-1.7.0-1-any.pkg.tar.xz";
    sha256      = "249fa9fca192a2ebe4a0b0ef9f251f5c7100ecda989f7170c2cf850250a281f8";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pyqt4" = fetch {
    name        = "mingw-w64-i686-python3-pyqt4";
    version     = "4.11.4";
    filename    = "mingw-w64-i686-python3-pyqt4-4.11.4-2-any.pkg.tar.xz";
    sha256      = "5d02156800c845d151cee8f17a2551fb78d8f652df0305f5bb1d42f9a8365da6";
    buildInputs = [ mingw-w64-i686-python3-sip mingw-w64-i686-pyqt4-common mingw-w64-i686-python3 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python3-pyqt5" = fetch {
    name        = "mingw-w64-i686-python3-pyqt5";
    version     = "5.11.3";
    filename    = "mingw-w64-i686-python3-pyqt5-5.11.3-1-any.pkg.tar.xz";
    sha256      = "5c1705f2ef58af177bc029fbfe40fdea1096b727b1fb64e0fdd498043627c3d6";
    buildInputs = [ mingw-w64-i686-python3-sip mingw-w64-i686-pyqt5-common mingw-w64-i686-python3 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-python3-pyreadline" = fetch {
    name        = "mingw-w64-i686-python3-pyreadline";
    version     = "2.1";
    filename    = "mingw-w64-i686-python3-pyreadline-2.1-1-any.pkg.tar.xz";
    sha256      = "dec1442a0d28a7aa0e26c03cf5fbabc24d883e723b9f7ed733831f23ce5d5fc2";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pyrsistent" = fetch {
    name        = "mingw-w64-i686-python3-pyrsistent";
    version     = "0.14.9";
    filename    = "mingw-w64-i686-python3-pyrsistent-0.14.9-1-any.pkg.tar.xz";
    sha256      = "8696752443651da79ac4c8eabdc907a61551f89499609fcae45ec068ca527ee8";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-pyserial" = fetch {
    name        = "mingw-w64-i686-python3-pyserial";
    version     = "3.4";
    filename    = "mingw-w64-i686-python3-pyserial-3.4-1-any.pkg.tar.xz";
    sha256      = "fe92ebde2eb410a98e74ae4414f35ded2ebc2fc7ebbab6a272b3b866d1ba603b";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pyside-qt4" = fetch {
    name        = "mingw-w64-i686-python3-pyside-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-python3-pyside-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "2364f2bf3c5870a6ad0af1b549856a5af287285c5c798faf6d45c33f2be6811b";
    buildInputs = [ mingw-w64-i686-pyside-common-qt4 mingw-w64-i686-python3 mingw-w64-i686-python3-shiboken-qt4 mingw-w64-i686-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python3-pyside-tools-qt4" = fetch {
    name        = "mingw-w64-i686-python3-pyside-tools-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-python3-pyside-tools-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "0c75e29a3449dcfc3cb2d33edd31eac4b155b2c078035106fa7e09192b74599d";
    buildInputs = [ mingw-w64-i686-pyside-tools-common-qt4 mingw-w64-i686-python3-pyside-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python3-pysocks" = fetch {
    name        = "mingw-w64-i686-python3-pysocks";
    version     = "1.6.8";
    filename    = "mingw-w64-i686-python3-pysocks-1.6.8-1-any.pkg.tar.xz";
    sha256      = "9309c515ef48c0aada5b560a3e0cc98b62e767aae945c3fedf87f05f51246d0e";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-win_inet_pton ];
  };

  "mingw-w64-i686-python3-pystemmer" = fetch {
    name        = "mingw-w64-i686-python3-pystemmer";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-python3-pystemmer-1.3.0-2-any.pkg.tar.xz";
    sha256      = "226f0b80084bd34147b321e982b18bbf4cff178814b82d4551636e6132a34f38";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pytest" = fetch {
    name        = "mingw-w64-i686-python3-pytest";
    version     = "4.0.2";
    filename    = "mingw-w64-i686-python3-pytest-4.0.2-1-any.pkg.tar.xz";
    sha256      = "f28ce8d20b87a73ee97f10d30715dd04d78cf695c91c2042ca5078119effa763";
    buildInputs = [ mingw-w64-i686-python3-py mingw-w64-i686-python3-pluggy mingw-w64-i686-python3-setuptools mingw-w64-i686-python3-colorama mingw-w64-i686-python3-six mingw-w64-i686-python3-atomicwrites mingw-w64-i686-python3-more-itertools mingw-w64-i686-python3-attrs ];
  };

  "mingw-w64-i686-python3-pytest-benchmark" = fetch {
    name        = "mingw-w64-i686-python3-pytest-benchmark";
    version     = "3.2.0";
    filename    = "mingw-w64-i686-python3-pytest-benchmark-3.2.0-1-any.pkg.tar.xz";
    sha256      = "8b81eb6c9dc024ab99ba75c5a9ee270eacb19fbacbfce8444f15aba0feda429a";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-py-cpuinfo mingw-w64-i686-python3-pytest ];
  };

  "mingw-w64-i686-python3-pytest-cov" = fetch {
    name        = "mingw-w64-i686-python3-pytest-cov";
    version     = "2.6.0";
    filename    = "mingw-w64-i686-python3-pytest-cov-2.6.0-1-any.pkg.tar.xz";
    sha256      = "edf119f944d4a3ef46732bd0e0753fe4eb2230fec27e92944db513c08e5f8ec6";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-coverage mingw-w64-i686-python3-pytest ];
  };

  "mingw-w64-i686-python3-pytest-expect" = fetch {
    name        = "mingw-w64-i686-python3-pytest-expect";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python3-pytest-expect-1.1.0-1-any.pkg.tar.xz";
    sha256      = "25e09552286d466d3fd8c00679d4792e936547b67e4356edde20ef06c66e32e7";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pytest mingw-w64-i686-python3-u-msgpack ];
  };

  "mingw-w64-i686-python3-pytest-forked" = fetch {
    name        = "mingw-w64-i686-python3-pytest-forked";
    version     = "0.2";
    filename    = "mingw-w64-i686-python3-pytest-forked-0.2-1-any.pkg.tar.xz";
    sha256      = "8bbb423e30cc0db7f71d7fff26cede449b1d9c1798120e85d0422534110a78d5";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pytest ];
  };

  "mingw-w64-i686-python3-pytest-runner" = fetch {
    name        = "mingw-w64-i686-python3-pytest-runner";
    version     = "4.2";
    filename    = "mingw-w64-i686-python3-pytest-runner-4.2-4-any.pkg.tar.xz";
    sha256      = "a9f87994384566a19cd3c4f4273a18cebd25f6228c16447b0248afe078a8eb08";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pytest ];
  };

  "mingw-w64-i686-python3-pytest-xdist" = fetch {
    name        = "mingw-w64-i686-python3-pytest-xdist";
    version     = "1.25.0";
    filename    = "mingw-w64-i686-python3-pytest-xdist-1.25.0-1-any.pkg.tar.xz";
    sha256      = "154cb5b7c554e5b9f2748def89e292182c74ce192853e7ae5287fe448c1eb04e";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pytest-forked mingw-w64-i686-python3-execnet ];
  };

  "mingw-w64-i686-python3-python_ics" = fetch {
    name        = "mingw-w64-i686-python3-python_ics";
    version     = "2.15";
    filename    = "mingw-w64-i686-python3-python_ics-2.15-1-any.pkg.tar.xz";
    sha256      = "08716e3266e905b37890457709e2de1f55c079f82439235aa0279cd87bfa36da";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pytoml" = fetch {
    name        = "mingw-w64-i686-python3-pytoml";
    version     = "0.1.20";
    filename    = "mingw-w64-i686-python3-pytoml-0.1.20-1-any.pkg.tar.xz";
    sha256      = "df82ca81733eb8ac2def52609e5f38d3ad0430b01904c3227537c9eefb48f1cd";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pytz" = fetch {
    name        = "mingw-w64-i686-python3-pytz";
    version     = "2018.9";
    filename    = "mingw-w64-i686-python3-pytz-2018.9-1-any.pkg.tar.xz";
    sha256      = "df1e7c59d8cdea153c22d645eaf8386a5f9f7a44a5f81d381fc35d02c304dc34";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pyu2f" = fetch {
    name        = "mingw-w64-i686-python3-pyu2f";
    version     = "0.1.4";
    filename    = "mingw-w64-i686-python3-pyu2f-0.1.4-1-any.pkg.tar.xz";
    sha256      = "7aebb364eb2508707a8d932ef7b64730ccc21a5ed3bf28cd93fb7ec1200ea6cd";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pywavelets" = fetch {
    name        = "mingw-w64-i686-python3-pywavelets";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python3-pywavelets-1.0.1-1-any.pkg.tar.xz";
    sha256      = "4681f8aae76e8e54dd2aa2c27e27614e8cead41cffa874689e574e50ab3bc599";
    buildInputs = [ mingw-w64-i686-python3-numpy mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-pyzmq" = fetch {
    name        = "mingw-w64-i686-python3-pyzmq";
    version     = "17.1.2";
    filename    = "mingw-w64-i686-python3-pyzmq-17.1.2-1-any.pkg.tar.xz";
    sha256      = "0a5b51946cb3f6ebba92f9206e1a7a43f3da67925a963ecd317425a4003a2bee";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-zeromq ];
  };

  "mingw-w64-i686-python3-pyzopfli" = fetch {
    name        = "mingw-w64-i686-python3-pyzopfli";
    version     = "0.1.4";
    filename    = "mingw-w64-i686-python3-pyzopfli-0.1.4-1-any.pkg.tar.xz";
    sha256      = "320fe4a82cf8915a1f6126d4b8ba342251bf39d072ac223d8d11c0630e199b86";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-qscintilla" = fetch {
    name        = "mingw-w64-i686-python3-qscintilla";
    version     = "2.10.8";
    filename    = "mingw-w64-i686-python3-qscintilla-2.10.8-1-any.pkg.tar.xz";
    sha256      = "71d5feb7fc038734b6a231fa90e6958eebdd8f96c6b83d3f3dea7a92e49dc9ab";
    buildInputs = [ mingw-w64-i686-python-qscintilla-common mingw-w64-i686-python3-pyqt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-python3-qtconsole" = fetch {
    name        = "mingw-w64-i686-python3-qtconsole";
    version     = "4.4.1";
    filename    = "mingw-w64-i686-python3-qtconsole-4.4.1-1-any.pkg.tar.xz";
    sha256      = "ba91f52103eb9acaf3bf4e48b7f3c9508baf2859b21778a704f92dfbe66c8824";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-jupyter_core mingw-w64-i686-python3-jupyter_client mingw-w64-i686-python3-pyqt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-python3-rencode" = fetch {
    name        = "mingw-w64-i686-python3-rencode";
    version     = "1.0.6";
    filename    = "mingw-w64-i686-python3-rencode-1.0.6-1-any.pkg.tar.xz";
    sha256      = "3ebd66e3d62973e0853f7013cb02e9bcea2ffc0156b8c1f8f185408a4547a403";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-reportlab" = fetch {
    name        = "mingw-w64-i686-python3-reportlab";
    version     = "3.5.12";
    filename    = "mingw-w64-i686-python3-reportlab-3.5.12-1-any.pkg.tar.xz";
    sha256      = "b1a5a0aa8ecafc9a70dd404435dcb0be5b6ae06b3b666de78e14b798e4f7c3cc";
    buildInputs = [ mingw-w64-i686-freetype mingw-w64-i686-python3-pip mingw-w64-i686-python3-Pillow ];
    broken      = true; # broken dependency mingw-w64-i686-python3-reportlab -> mingw-w64-i686-python3-Pillow
  };

  "mingw-w64-i686-python3-requests" = fetch {
    name        = "mingw-w64-i686-python3-requests";
    version     = "2.21.0";
    filename    = "mingw-w64-i686-python3-requests-2.21.0-1-any.pkg.tar.xz";
    sha256      = "c0b1071ed9af280b77a26893202529ffb0b4654a148446664a6e492902086c15";
    buildInputs = [ mingw-w64-i686-python3-urllib3 mingw-w64-i686-python3-chardet mingw-w64-i686-python3-idna ];
  };

  "mingw-w64-i686-python3-requests-kerberos" = fetch {
    name        = "mingw-w64-i686-python3-requests-kerberos";
    version     = "0.12.0";
    filename    = "mingw-w64-i686-python3-requests-kerberos-0.12.0-1-any.pkg.tar.xz";
    sha256      = "354ae454e79871a07a4f7c7255c01e8093687fe986d6fa4202ad88cc9d3b4061";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-cryptography mingw-w64-i686-python3-winkerberos ];
  };

  "mingw-w64-i686-python3-retrying" = fetch {
    name        = "mingw-w64-i686-python3-retrying";
    version     = "1.3.3";
    filename    = "mingw-w64-i686-python3-retrying-1.3.3-1-any.pkg.tar.xz";
    sha256      = "f0d0bf12190206e87bc458d315f29fba62fc709a7dda2a2c40d578a1b4353690";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-rfc3986" = fetch {
    name        = "mingw-w64-i686-python3-rfc3986";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-python3-rfc3986-1.2.0-1-any.pkg.tar.xz";
    sha256      = "6f764c657c1a78494ca1b5c43520e20bc6d31b260b5ad6df77ff028e5c2a5f50";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-rfc3987" = fetch {
    name        = "mingw-w64-i686-python3-rfc3987";
    version     = "1.3.8";
    filename    = "mingw-w64-i686-python3-rfc3987-1.3.8-1-any.pkg.tar.xz";
    sha256      = "2093d4e07df16212adf1f2c0b64f8661f7a5bc12fb8bd59f55756623d1bc253f";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-rst2pdf" = fetch {
    name        = "mingw-w64-i686-python3-rst2pdf";
    version     = "0.93";
    filename    = "mingw-w64-i686-python3-rst2pdf-0.93-4-any.pkg.tar.xz";
    sha256      = "535e45364363779eed3860bca8b63cbadc952fb4be746483159116c4467a2541";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-docutils mingw-w64-i686-python3-pdfrw mingw-w64-i686-python3-pygments (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python3-reportlab.version "2.4"; mingw-w64-i686-python3-reportlab) mingw-w64-i686-python3-setuptools ];
    broken      = true; # broken dependency mingw-w64-i686-python3-reportlab -> mingw-w64-i686-python3-Pillow
  };

  "mingw-w64-i686-python3-scandir" = fetch {
    name        = "mingw-w64-i686-python3-scandir";
    version     = "1.9.0";
    filename    = "mingw-w64-i686-python3-scandir-1.9.0-1-any.pkg.tar.xz";
    sha256      = "a36cc3482b0173b6c1523c9affe292649a4a176c68ae643b90f3678e0b292b32";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-scikit-learn" = fetch {
    name        = "mingw-w64-i686-python3-scikit-learn";
    version     = "0.20.2";
    filename    = "mingw-w64-i686-python3-scikit-learn-0.20.2-1-any.pkg.tar.xz";
    sha256      = "b20dd5b8f414aee5b4867f05ad1e4f4bc814373c67a8965c4f03c758ae7c59fa";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-scipy ];
  };

  "mingw-w64-i686-python3-scipy" = fetch {
    name        = "mingw-w64-i686-python3-scipy";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-python3-scipy-1.2.0-1-any.pkg.tar.xz";
    sha256      = "937d592c05a327c65e5e106b75d9646cf1d1ca9c0ca4dbceab2c8ae792235441";
    buildInputs = [ mingw-w64-i686-gcc-libgfortran mingw-w64-i686-openblas mingw-w64-i686-python3-numpy ];
  };

  "mingw-w64-i686-python3-send2trash" = fetch {
    name        = "mingw-w64-i686-python3-send2trash";
    version     = "1.5.0";
    filename    = "mingw-w64-i686-python3-send2trash-1.5.0-2-any.pkg.tar.xz";
    sha256      = "b75f587cc942275d7c4b6c37f895a123280b721aa00051072cb142482bcdcfba";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-setproctitle" = fetch {
    name        = "mingw-w64-i686-python3-setproctitle";
    version     = "1.1.10";
    filename    = "mingw-w64-i686-python3-setproctitle-1.1.10-1-any.pkg.tar.xz";
    sha256      = "37c1cea1a1d79565e786446e182eddb6980ce31901ce19f1a183ed64eb7fc9c8";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-setuptools" = fetch {
    name        = "mingw-w64-i686-python3-setuptools";
    version     = "40.6.3";
    filename    = "mingw-w64-i686-python3-setuptools-40.6.3-1-any.pkg.tar.xz";
    sha256      = "66150cea6158fe1116932d351e18e04589e59c8f9dc63ed5f29d801990c11dcd";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-python3.version "3.3"; mingw-w64-i686-python3) mingw-w64-i686-python3-packaging mingw-w64-i686-python3-pyparsing mingw-w64-i686-python3-appdirs mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-setuptools-git" = fetch {
    name        = "mingw-w64-i686-python3-setuptools-git";
    version     = "1.2";
    filename    = "mingw-w64-i686-python3-setuptools-git-1.2-1-any.pkg.tar.xz";
    sha256      = "58988256773543688ba5c79e8ca1082a8c55eae45b34399fd6fdbed5e27a6081";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-setuptools git ];
    broken      = true; # broken dependency mingw-w64-i686-python3-setuptools-git -> git
  };

  "mingw-w64-i686-python3-setuptools-scm" = fetch {
    name        = "mingw-w64-i686-python3-setuptools-scm";
    version     = "3.1.0";
    filename    = "mingw-w64-i686-python3-setuptools-scm-3.1.0-1-any.pkg.tar.xz";
    sha256      = "d25054e65df59f6a98af24254c4265e3c8c24a5b2ba5a2f4ddd03d026e6b70a0";
    buildInputs = [ mingw-w64-i686-python3-setuptools ];
  };

  "mingw-w64-i686-python3-shiboken-qt4" = fetch {
    name        = "mingw-w64-i686-python3-shiboken-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-python3-shiboken-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "07fe678ccce67902a8c11243f25f125d1042d2a0d64679ce5a776e11d325fd25";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-python3 mingw-w64-i686-shiboken-qt4 mingw-w64-i686-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-python3-simplegeneric" = fetch {
    name        = "mingw-w64-i686-python3-simplegeneric";
    version     = "0.8.1";
    filename    = "mingw-w64-i686-python3-simplegeneric-0.8.1-4-any.pkg.tar.xz";
    sha256      = "4a6971955d9ae8bcb6e00e69ad65aeadfb6a5723a1017e821b9653f164c7fdd5";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-sip" = fetch {
    name        = "mingw-w64-i686-python3-sip";
    version     = "4.19.13";
    filename    = "mingw-w64-i686-python3-sip-4.19.13-2-any.pkg.tar.xz";
    sha256      = "9d2fd9e10bbf8d1568498a5e22d0d8cdcfa81c8086f6ba5e2e0cf131fdaec1cb";
    buildInputs = [ mingw-w64-i686-sip mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-six" = fetch {
    name        = "mingw-w64-i686-python3-six";
    version     = "1.12.0";
    filename    = "mingw-w64-i686-python3-six-1.12.0-1-any.pkg.tar.xz";
    sha256      = "9e319fc670a1023f0f237185d799a246b4a3d3d40ee3dcbf68b6bd8ec49db541";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-snowballstemmer" = fetch {
    name        = "mingw-w64-i686-python3-snowballstemmer";
    version     = "1.2.1";
    filename    = "mingw-w64-i686-python3-snowballstemmer-1.2.1-3-any.pkg.tar.xz";
    sha256      = "99ad54f898a1f8966cb5974dc0b6a4f8a14680f8bbed223196a53be2b3bb1128";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-soupsieve" = fetch {
    name        = "mingw-w64-i686-python3-soupsieve";
    version     = "1.6.2";
    filename    = "mingw-w64-i686-python3-soupsieve-1.6.2-1-any.pkg.tar.xz";
    sha256      = "6f6313117ecdb3ff3b6533fffe1b58abc5a4cf67907637d78a7538fddc068cec";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-sphinx" = fetch {
    name        = "mingw-w64-i686-python3-sphinx";
    version     = "1.8.3";
    filename    = "mingw-w64-i686-python3-sphinx-1.8.3-1-any.pkg.tar.xz";
    sha256      = "660784a3656099f8712082cf8285d329bf4d731bb9a9867ca96f54711740451f";
    buildInputs = [ mingw-w64-i686-python3-babel mingw-w64-i686-python3-certifi mingw-w64-i686-python3-chardet mingw-w64-i686-python3-colorama mingw-w64-i686-python3-docutils mingw-w64-i686-python3-idna mingw-w64-i686-python3-imagesize mingw-w64-i686-python3-jinja mingw-w64-i686-python3-packaging mingw-w64-i686-python3-pygments mingw-w64-i686-python3-requests mingw-w64-i686-python3-sphinx_rtd_theme mingw-w64-i686-python3-snowballstemmer mingw-w64-i686-python3-sphinx-alabaster-theme mingw-w64-i686-python3-sphinxcontrib-websupport mingw-w64-i686-python3-six mingw-w64-i686-python3-sqlalchemy mingw-w64-i686-python3-urllib3 mingw-w64-i686-python3-whoosh ];
  };

  "mingw-w64-i686-python3-sphinx-alabaster-theme" = fetch {
    name        = "mingw-w64-i686-python3-sphinx-alabaster-theme";
    version     = "0.7.11";
    filename    = "mingw-w64-i686-python3-sphinx-alabaster-theme-0.7.11-1-any.pkg.tar.xz";
    sha256      = "4db79e7a9baf6dc2e8f311fb78236409c676f521c04bbd010885f0a0fcca4537";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-sphinx_rtd_theme" = fetch {
    name        = "mingw-w64-i686-python3-sphinx_rtd_theme";
    version     = "0.4.1";
    filename    = "mingw-w64-i686-python3-sphinx_rtd_theme-0.4.1-1-any.pkg.tar.xz";
    sha256      = "a1f3e382029946fe531a4695b05770add90da4aca0fc1d2f9d00a26ab839e046";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-sphinxcontrib-websupport" = fetch {
    name        = "mingw-w64-i686-python3-sphinxcontrib-websupport";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-python3-sphinxcontrib-websupport-1.1.0-2-any.pkg.tar.xz";
    sha256      = "20bb10f54d40010e5ea0316df8ef03119085cd1bca0fd019605fd7dc20511bce";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-sqlalchemy" = fetch {
    name        = "mingw-w64-i686-python3-sqlalchemy";
    version     = "1.2.15";
    filename    = "mingw-w64-i686-python3-sqlalchemy-1.2.15-1-any.pkg.tar.xz";
    sha256      = "ae612f7607b8cfc8e59bf953b07520794a6a3a8d69a39d2b19123557e5b4a9ef";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-sqlalchemy-migrate" = fetch {
    name        = "mingw-w64-i686-python3-sqlalchemy-migrate";
    version     = "0.11.0";
    filename    = "mingw-w64-i686-python3-sqlalchemy-migrate-0.11.0-1-any.pkg.tar.xz";
    sha256      = "e18d8977a0d75c828b1f5036fac2d687ec9cf2825df802e68e4ab0efe86a85ed";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six mingw-w64-i686-python3-pbr mingw-w64-i686-python3-sqlalchemy mingw-w64-i686-python3-decorator mingw-w64-i686-python3-sqlparse mingw-w64-i686-python3-tempita ];
  };

  "mingw-w64-i686-python3-sqlitedict" = fetch {
    name        = "mingw-w64-i686-python3-sqlitedict";
    version     = "1.6.0";
    filename    = "mingw-w64-i686-python3-sqlitedict-1.6.0-1-any.pkg.tar.xz";
    sha256      = "72c14f2820c102c2816b36f03ce7f4712cb32c1d013016bcb0912b4f9ad399cf";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-sqlite3 ];
  };

  "mingw-w64-i686-python3-sqlparse" = fetch {
    name        = "mingw-w64-i686-python3-sqlparse";
    version     = "0.2.4";
    filename    = "mingw-w64-i686-python3-sqlparse-0.2.4-1-any.pkg.tar.xz";
    sha256      = "0d897434ab798a41f77a1b84d79f1c5955c85f44c5abfdfce766e36e96db753a";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-statsmodels" = fetch {
    name        = "mingw-w64-i686-python3-statsmodels";
    version     = "0.9.0";
    filename    = "mingw-w64-i686-python3-statsmodels-0.9.0-1-any.pkg.tar.xz";
    sha256      = "85af3bb28661e5c5291c95661b9f2067a49272df02d7b8981e8718116996eaa1";
    buildInputs = [ mingw-w64-i686-python3-scipy mingw-w64-i686-python3-pandas mingw-w64-i686-python3-patsy ];
  };

  "mingw-w64-i686-python3-stestr" = fetch {
    name        = "mingw-w64-i686-python3-stestr";
    version     = "2.2.0";
    filename    = "mingw-w64-i686-python3-stestr-2.2.0-1-any.pkg.tar.xz";
    sha256      = "4ce0aedf41928a98099b483131683858481d6037cff5c9b835290ddaf7916a57";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-cliff mingw-w64-i686-python3-fixtures mingw-w64-i686-python3-future mingw-w64-i686-python3-pbr mingw-w64-i686-python3-six mingw-w64-i686-python3-subunit mingw-w64-i686-python3-testtools mingw-w64-i686-python3-voluptuous mingw-w64-i686-python3-yaml ];
  };

  "mingw-w64-i686-python3-stevedore" = fetch {
    name        = "mingw-w64-i686-python3-stevedore";
    version     = "1.30.0";
    filename    = "mingw-w64-i686-python3-stevedore-1.30.0-1-any.pkg.tar.xz";
    sha256      = "d96f45bed8129e41b1bf8985e57c6ead10224a19ec33c02e9770b54703d54bf5";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-strict-rfc3339" = fetch {
    name        = "mingw-w64-i686-python3-strict-rfc3339";
    version     = "0.7";
    filename    = "mingw-w64-i686-python3-strict-rfc3339-0.7-1-any.pkg.tar.xz";
    sha256      = "91f446735267273482a358393c3fd6c14d5706b7f84511d038cfce05c7bb2cb1";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-subunit" = fetch {
    name        = "mingw-w64-i686-python3-subunit";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-python3-subunit-1.3.0-2-any.pkg.tar.xz";
    sha256      = "60e42e2da4e83f75f351d2a932751e2f05f26a1c116399fde930947453b9ebe2";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-extras mingw-w64-i686-python3-testtools ];
  };

  "mingw-w64-i686-python3-sympy" = fetch {
    name        = "mingw-w64-i686-python3-sympy";
    version     = "1.3";
    filename    = "mingw-w64-i686-python3-sympy-1.3-1-any.pkg.tar.xz";
    sha256      = "da73527cb1df85cec5066dccc23fd8db7ef76c2f6b8b9e8a26c977708efe7ae9";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-mpmath ];
  };

  "mingw-w64-i686-python3-tempita" = fetch {
    name        = "mingw-w64-i686-python3-tempita";
    version     = "0.5.3dev20170202";
    filename    = "mingw-w64-i686-python3-tempita-0.5.3dev20170202-1-any.pkg.tar.xz";
    sha256      = "8ab22d03850cacd015b8908df9e6cc69559153886dd0913410891fe4efa0cd0d";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-terminado" = fetch {
    name        = "mingw-w64-i686-python3-terminado";
    version     = "0.8.1";
    filename    = "mingw-w64-i686-python3-terminado-0.8.1-2-any.pkg.tar.xz";
    sha256      = "3f0261ecea7a305b8c8865a617ab2b66156e116399d616602811542521cd6a4b";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-tornado mingw-w64-i686-python3-ptyprocess ];
  };

  "mingw-w64-i686-python3-testpath" = fetch {
    name        = "mingw-w64-i686-python3-testpath";
    version     = "0.4.2";
    filename    = "mingw-w64-i686-python3-testpath-0.4.2-1-any.pkg.tar.xz";
    sha256      = "be064a81c7b525c27edbe8a208822169c6e81b1a10c654e2f1b7f572cc5ff223";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-testrepository" = fetch {
    name        = "mingw-w64-i686-python3-testrepository";
    version     = "0.0.20";
    filename    = "mingw-w64-i686-python3-testrepository-0.0.20-1-any.pkg.tar.xz";
    sha256      = "d49ff2f4c085d70740c4ef4077fd785e81ef708054c001aab709eb9d697fe7e6";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-testresources" = fetch {
    name        = "mingw-w64-i686-python3-testresources";
    version     = "2.0.1";
    filename    = "mingw-w64-i686-python3-testresources-2.0.1-1-any.pkg.tar.xz";
    sha256      = "f4edb5d3a601b7bd36b22a5f25bd614123903aec45cb7f80a46667163e64910a";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-testscenarios" = fetch {
    name        = "mingw-w64-i686-python3-testscenarios";
    version     = "0.5.0";
    filename    = "mingw-w64-i686-python3-testscenarios-0.5.0-1-any.pkg.tar.xz";
    sha256      = "da0b729baf5563963df08f913ad2e3e8c9af4354dbc6de37d7f901342259e354";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-testtools" = fetch {
    name        = "mingw-w64-i686-python3-testtools";
    version     = "2.3.0";
    filename    = "mingw-w64-i686-python3-testtools-2.3.0-1-any.pkg.tar.xz";
    sha256      = "e10fb210a4c3c67ffc8d18154b97a9274e20ed8416e1aeee9443ae6ad3d860c0";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-pbr mingw-w64-i686-python3-extras mingw-w64-i686-python3-fixtures mingw-w64-i686-python3-pyrsistent mingw-w64-i686-python3-mimeparse ];
  };

  "mingw-w64-i686-python3-text-unidecode" = fetch {
    name        = "mingw-w64-i686-python3-text-unidecode";
    version     = "1.2";
    filename    = "mingw-w64-i686-python3-text-unidecode-1.2-1-any.pkg.tar.xz";
    sha256      = "6319cb20084a14a7826b598884bedc2c710a7d8cb2d086275fc6179836777f1f";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-toml" = fetch {
    name        = "mingw-w64-i686-python3-toml";
    version     = "0.10.0";
    filename    = "mingw-w64-i686-python3-toml-0.10.0-1-any.pkg.tar.xz";
    sha256      = "cc231b1901fc64e68ecf0f249659c64a7cab7cc6a94bca67929abf0607e54f49";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-tornado" = fetch {
    name        = "mingw-w64-i686-python3-tornado";
    version     = "5.1.1";
    filename    = "mingw-w64-i686-python3-tornado-5.1.1-2-any.pkg.tar.xz";
    sha256      = "ad8699600b076598c2ce4a3b92ffcf4bfe99ec7af90f25456b252ec7836e77d6";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-tox" = fetch {
    name        = "mingw-w64-i686-python3-tox";
    version     = "3.6.1";
    filename    = "mingw-w64-i686-python3-tox-3.6.1-1-any.pkg.tar.xz";
    sha256      = "255472511c3cc871c4e146b01c412140e57cea691a78419b5fa2953514131d99";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-py mingw-w64-i686-python2-six mingw-w64-i686-python3-virtualenv mingw-w64-i686-python3-setuptools mingw-w64-i686-python3-setuptools-scm mingw-w64-i686-python3-filelock mingw-w64-i686-python3-toml mingw-w64-i686-python3-pluggy ];
  };

  "mingw-w64-i686-python3-traitlets" = fetch {
    name        = "mingw-w64-i686-python3-traitlets";
    version     = "4.3.2";
    filename    = "mingw-w64-i686-python3-traitlets-4.3.2-3-any.pkg.tar.xz";
    sha256      = "86fa09f52f80e2619c7d945c3349d70d4f634e9ddf3126cd4789c81732b4ef44";
    buildInputs = [ mingw-w64-i686-python3-ipython_genutils mingw-w64-i686-python3-decorator ];
  };

  "mingw-w64-i686-python3-u-msgpack" = fetch {
    name        = "mingw-w64-i686-python3-u-msgpack";
    version     = "2.5.0";
    filename    = "mingw-w64-i686-python3-u-msgpack-2.5.0-1-any.pkg.tar.xz";
    sha256      = "fcf2914b955b76da8232540c5c554cd2b2b285254802995fdbf4f1bffb43d357";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-udsoncan" = fetch {
    name        = "mingw-w64-i686-python3-udsoncan";
    version     = "1.6";
    filename    = "mingw-w64-i686-python3-udsoncan-1.6-1-any.pkg.tar.xz";
    sha256      = "72edf7f23231fa6f2e2adf4d67e39b4fcbe9ffe484134c9d972d19de433cb5b2";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-ukpostcodeparser" = fetch {
    name        = "mingw-w64-i686-python3-ukpostcodeparser";
    version     = "1.1.2";
    filename    = "mingw-w64-i686-python3-ukpostcodeparser-1.1.2-1-any.pkg.tar.xz";
    sha256      = "78b135db41bffa4f6ef900de6c1b2f416eeaf75369d426684d00cd306fe7f0ef";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-unicorn" = fetch {
    name        = "mingw-w64-i686-python3-unicorn";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python3-unicorn-1.0.1-3-any.pkg.tar.xz";
    sha256      = "ace688a81bd3f6fd59ced2bb7252958732623741c78519e50ddd436746e3866a";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-unicorn ];
  };

  "mingw-w64-i686-python3-urllib3" = fetch {
    name        = "mingw-w64-i686-python3-urllib3";
    version     = "1.24.1";
    filename    = "mingw-w64-i686-python3-urllib3-1.24.1-1-any.pkg.tar.xz";
    sha256      = "a6bdf579391fce42971f4b71c67a6d3a0ffd25fd41489b33cea3b18b3fe71fbb";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-certifi mingw-w64-i686-python3-idna ];
  };

  "mingw-w64-i686-python3-virtualenv" = fetch {
    name        = "mingw-w64-i686-python3-virtualenv";
    version     = "16.0.0";
    filename    = "mingw-w64-i686-python3-virtualenv-16.0.0-1-any.pkg.tar.xz";
    sha256      = "325cf0bf3784fd932757ba86ada8d45dcf27e60fdafd3d51684599a42fe53689";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-voluptuous" = fetch {
    name        = "mingw-w64-i686-python3-voluptuous";
    version     = "0.11.5";
    filename    = "mingw-w64-i686-python3-voluptuous-0.11.5-1-any.pkg.tar.xz";
    sha256      = "8a59616e86f83d85dc42d7bc8ecac0b420e1302658ca16f337d8940bee5550f9";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-watchdog" = fetch {
    name        = "mingw-w64-i686-python3-watchdog";
    version     = "0.9.0";
    filename    = "mingw-w64-i686-python3-watchdog-0.9.0-1-any.pkg.tar.xz";
    sha256      = "b103fe8293575a90a407337302eefb3bf8417ca580929bddf4c38669e198cce2";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-wcwidth" = fetch {
    name        = "mingw-w64-i686-python3-wcwidth";
    version     = "0.1.7";
    filename    = "mingw-w64-i686-python3-wcwidth-0.1.7-3-any.pkg.tar.xz";
    sha256      = "eee151ae39bdd0a1fe004d0651b681cd1bde23849553143a43ee15871a78988c";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-webcolors" = fetch {
    name        = "mingw-w64-i686-python3-webcolors";
    version     = "1.8.1";
    filename    = "mingw-w64-i686-python3-webcolors-1.8.1-1-any.pkg.tar.xz";
    sha256      = "bdaf8bc92bc9f90943b6155578159c30de587f9c46b87aece65be8cdaed74560";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-webencodings" = fetch {
    name        = "mingw-w64-i686-python3-webencodings";
    version     = "0.5.1";
    filename    = "mingw-w64-i686-python3-webencodings-0.5.1-3-any.pkg.tar.xz";
    sha256      = "593c5c74991f75855d0a037bfe08b46089066b8ef6d52e1c33ced4cdc5a8a44c";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-websocket-client" = fetch {
    name        = "mingw-w64-i686-python3-websocket-client";
    version     = "0.54.0";
    filename    = "mingw-w64-i686-python3-websocket-client-0.54.0-2-any.pkg.tar.xz";
    sha256      = "cec7541e5d0450fa91df6026e9368f24ec702fd633dbed49e94c1be44efb63d1";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-six ];
  };

  "mingw-w64-i686-python3-wheel" = fetch {
    name        = "mingw-w64-i686-python3-wheel";
    version     = "0.32.3";
    filename    = "mingw-w64-i686-python3-wheel-0.32.3-1-any.pkg.tar.xz";
    sha256      = "5b65983b578ac24e1bea11c6a1d3cad742705fe70abd95221fc7f9d65038e99e";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-whoosh" = fetch {
    name        = "mingw-w64-i686-python3-whoosh";
    version     = "2.7.4";
    filename    = "mingw-w64-i686-python3-whoosh-2.7.4-2-any.pkg.tar.xz";
    sha256      = "53207e3ec1380a412ad595b00c312992121e045e2510b08bd713d41f50d15f4b";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-win_inet_pton" = fetch {
    name        = "mingw-w64-i686-python3-win_inet_pton";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-python3-win_inet_pton-1.0.1-1-any.pkg.tar.xz";
    sha256      = "3d0b4a305173d9340e6e6740c230711f7d3f9c5437db9e9a23d003a629444d33";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-win_unicode_console" = fetch {
    name        = "mingw-w64-i686-python3-win_unicode_console";
    version     = "0.5";
    filename    = "mingw-w64-i686-python3-win_unicode_console-0.5-3-any.pkg.tar.xz";
    sha256      = "5aae13e01903172ee33cd477c8ab0714ecbf39df1619ed87071f7f3ccef615bf";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-wincertstore" = fetch {
    name        = "mingw-w64-i686-python3-wincertstore";
    version     = "0.2";
    filename    = "mingw-w64-i686-python3-wincertstore-0.2-1-any.pkg.tar.xz";
    sha256      = "a8db620fd6bda84c5e2f4abb24ce991e5a0af1b39060e046268509c5ec88f1fa";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-winkerberos" = fetch {
    name        = "mingw-w64-i686-python3-winkerberos";
    version     = "0.7.0";
    filename    = "mingw-w64-i686-python3-winkerberos-0.7.0-1-any.pkg.tar.xz";
    sha256      = "93481b7948692dcbe312ac8fb8319829a81702a727d531000633fb2bd2281947";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-wrapt" = fetch {
    name        = "mingw-w64-i686-python3-wrapt";
    version     = "1.10.11";
    filename    = "mingw-w64-i686-python3-wrapt-1.10.11-3-any.pkg.tar.xz";
    sha256      = "b7f27094561397d859b6739237dd8f58bb8031499df6dc04fcc965960cfefc73";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-xdg" = fetch {
    name        = "mingw-w64-i686-python3-xdg";
    version     = "0.26";
    filename    = "mingw-w64-i686-python3-xdg-0.26-2-any.pkg.tar.xz";
    sha256      = "93d4227a9277cba03e6fec716e0b36bf0ae461104b9adb42c4501683cb57136f";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-xlrd" = fetch {
    name        = "mingw-w64-i686-python3-xlrd";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-python3-xlrd-1.2.0-1-any.pkg.tar.xz";
    sha256      = "def3ea946a46bf2cc3409110bec4055355cb44915005c8143cad6810e94ca7c4";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-xlsxwriter" = fetch {
    name        = "mingw-w64-i686-python3-xlsxwriter";
    version     = "1.1.2";
    filename    = "mingw-w64-i686-python3-xlsxwriter-1.1.2-1-any.pkg.tar.xz";
    sha256      = "be5fc60c98978c3aabcc4c10571b536b147cb0b209fcf0502d089295a558dfc4";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-xlwt" = fetch {
    name        = "mingw-w64-i686-python3-xlwt";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-python3-xlwt-1.3.0-1-any.pkg.tar.xz";
    sha256      = "154105e9bbb94be9a6e4cf3af8bb0df31ba386b52ed5ca87723f40a035a1eed2";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-python3-yaml" = fetch {
    name        = "mingw-w64-i686-python3-yaml";
    version     = "3.13";
    filename    = "mingw-w64-i686-python3-yaml-3.13-1-any.pkg.tar.xz";
    sha256      = "bf1e30d7781b203e89369f5d24edcd928fb4deee9d3498f23ddb4b4342477a9a";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-libyaml ];
  };

  "mingw-w64-i686-python3-zeroconf" = fetch {
    name        = "mingw-w64-i686-python3-zeroconf";
    version     = "0.21.3";
    filename    = "mingw-w64-i686-python3-zeroconf-0.21.3-2-any.pkg.tar.xz";
    sha256      = "4d3d3eccd6f7f3da55183ba190ad3d1b38cc78d6bc3542211c132770fe6959f7";
    buildInputs = [ mingw-w64-i686-python3 mingw-w64-i686-python3-ifaddr ];
  };

  "mingw-w64-i686-python3-zope.event" = fetch {
    name        = "mingw-w64-i686-python3-zope.event";
    version     = "4.4";
    filename    = "mingw-w64-i686-python3-zope.event-4.4-1-any.pkg.tar.xz";
    sha256      = "21a2e75ac4b395eebe0feea4c008971f6fee41faa023acd0ebc16f83a1b88f0e";
  };

  "mingw-w64-i686-python3-zope.interface" = fetch {
    name        = "mingw-w64-i686-python3-zope.interface";
    version     = "4.6.0";
    filename    = "mingw-w64-i686-python3-zope.interface-4.6.0-1-any.pkg.tar.xz";
    sha256      = "03ad371d3c24c956afec51a9755fa533740a3a3b9c70656795eda0dd51c17a5d";
  };

  "mingw-w64-i686-qbittorrent" = fetch {
    name        = "mingw-w64-i686-qbittorrent";
    version     = "4.1.5";
    filename    = "mingw-w64-i686-qbittorrent-4.1.5-1-any.pkg.tar.xz";
    sha256      = "6db47e29336d8dbc3a1c3680a7b3238c75aceef33a602c29d796df19fd0c84d3";
    buildInputs = [ mingw-w64-i686-boost mingw-w64-i686-qt5 mingw-w64-i686-libtorrent-rasterbar mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qbs" = fetch {
    name        = "mingw-w64-i686-qbs";
    version     = "1.12.2";
    filename    = "mingw-w64-i686-qbs-1.12.2-1-any.pkg.tar.xz";
    sha256      = "234be1f9370818d0a959cd5f726b1f0f49eaf2ac51f6011e6e49127fbd1de7fc";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qca-qt4-git" = fetch {
    name        = "mingw-w64-i686-qca-qt4-git";
    version     = "2220.66b9754";
    filename    = "mingw-w64-i686-qca-qt4-git-2220.66b9754-1-any.pkg.tar.xz";
    sha256      = "64a4d6a7eeae63e3c071032d18b09583620d1c74cf45f2ca8cf78823c659db3d";
    buildInputs = [ mingw-w64-i686-ca-certificates mingw-w64-i686-cyrus-sasl mingw-w64-i686-doxygen mingw-w64-i686-gnupg mingw-w64-i686-libgcrypt mingw-w64-i686-nss mingw-w64-i686-openssl mingw-w64-i686-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-qca-qt5-git" = fetch {
    name        = "mingw-w64-i686-qca-qt5-git";
    version     = "2277.98eead0";
    filename    = "mingw-w64-i686-qca-qt5-git-2277.98eead0-1-any.pkg.tar.xz";
    sha256      = "8ef9098903755459387556c4dc6f803aac88449cc0befeb77d52b88880379f0e";
    buildInputs = [ mingw-w64-i686-ca-certificates mingw-w64-i686-cyrus-sasl mingw-w64-i686-doxygen mingw-w64-i686-gnupg mingw-w64-i686-libgcrypt mingw-w64-i686-nss mingw-w64-i686-openssl mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qemu" = fetch {
    name        = "mingw-w64-i686-qemu";
    version     = "3.1.0";
    filename    = "mingw-w64-i686-qemu-3.1.0-1-any.pkg.tar.xz";
    sha256      = "836a612c7b7e0b736c0162c4228d82e7714f7e719c5786b9db7064fe0618efab";
    buildInputs = [ mingw-w64-i686-capstone mingw-w64-i686-curl mingw-w64-i686-cyrus-sasl mingw-w64-i686-glib2 mingw-w64-i686-gnutls mingw-w64-i686-gtk3 mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libssh2 mingw-w64-i686-libusb mingw-w64-i686-lzo2 mingw-w64-i686-pixman mingw-w64-i686-snappy mingw-w64-i686-SDL2 mingw-w64-i686-usbredir ];
    broken      = true; # broken dependency mingw-w64-i686-qemu -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-qhttpengine" = fetch {
    name        = "mingw-w64-i686-qhttpengine";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-qhttpengine-1.0.1-1-any.pkg.tar.xz";
    sha256      = "2a41f4fb5e694c8651d58931bad6540fdfb891907fff806bad4a80c3c4f1a8b1";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-qt5.version "5.4"; mingw-w64-i686-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qhull-git" = fetch {
    name        = "mingw-w64-i686-qhull-git";
    version     = "r166.f1f8b42";
    filename    = "mingw-w64-i686-qhull-git-r166.f1f8b42-1-any.pkg.tar.xz";
    sha256      = "879517cfaaf0ee26f910c974a1aead003ba5a8968bdc5100f9580110603ea087";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-qjson-qt4" = fetch {
    name        = "mingw-w64-i686-qjson-qt4";
    version     = "0.8.1";
    filename    = "mingw-w64-i686-qjson-qt4-0.8.1-3-any.pkg.tar.xz";
    sha256      = "9d8b01fc59f6cf2eee275aa272add3615b3dadd7b9878e45e18e9f3626a02c6c";
    buildInputs = [ mingw-w64-i686-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-qmdnsengine" = fetch {
    name        = "mingw-w64-i686-qmdnsengine";
    version     = "0.1.0";
    filename    = "mingw-w64-i686-qmdnsengine-0.1.0-1-any.pkg.tar.xz";
    sha256      = "d8024defb241de7e2ff9a4a5d069de1391abfdd8c60219f84444a718708bcbcc";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-qt5.version "5.4"; mingw-w64-i686-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qpdf" = fetch {
    name        = "mingw-w64-i686-qpdf";
    version     = "8.3.0";
    filename    = "mingw-w64-i686-qpdf-8.3.0-1-any.pkg.tar.xz";
    sha256      = "bf1d2700dcc7d840fed204617287b7dd45fe57ed28b26045dd56e5dcf658cbc0";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libjpeg mingw-w64-i686-pcre mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-qpdf -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-qrencode" = fetch {
    name        = "mingw-w64-i686-qrencode";
    version     = "4.0.2";
    filename    = "mingw-w64-i686-qrencode-4.0.2-1-any.pkg.tar.xz";
    sha256      = "2b2ef4ab1be9ce1a216668a234d36f2a737516aae13fcfc901ce91704739157d";
    buildInputs = [ mingw-w64-i686-libpng ];
  };

  "mingw-w64-i686-qrupdate-svn" = fetch {
    name        = "mingw-w64-i686-qrupdate-svn";
    version     = "r28";
    filename    = "mingw-w64-i686-qrupdate-svn-r28-4-any.pkg.tar.xz";
    sha256      = "512c6a4f742f8427a1756cdd49e31ecca76785d662efde9fc645cf902065be0d";
    buildInputs = [ mingw-w64-i686-openblas ];
  };

  "mingw-w64-i686-qscintilla" = fetch {
    name        = "mingw-w64-i686-qscintilla";
    version     = "2.10.8";
    filename    = "mingw-w64-i686-qscintilla-2.10.8-1-any.pkg.tar.xz";
    sha256      = "6bc334bb56074488d701db0faae5555db63039280d7226a9fd63f0ff8d3e9403";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qt-creator" = fetch {
    name        = "mingw-w64-i686-qt-creator";
    version     = "4.8.0";
    filename    = "mingw-w64-i686-qt-creator-4.8.0-1-any.pkg.tar.xz";
    sha256      = "9e53c0681061d50e7a0dbb34ede936606b1370331d8e14d5bceaaa264eec7560";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-gcc mingw-w64-i686-make mingw-w64-i686-qbs ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qt-installer-framework-git" = fetch {
    name        = "mingw-w64-i686-qt-installer-framework-git";
    version     = "r3068.55c191ed";
    filename    = "mingw-w64-i686-qt-installer-framework-git-r3068.55c191ed-1-any.pkg.tar.xz";
    sha256      = "776320110bb35dd2e2e73b70cc0c1a4fa9dccad9e3a3d94d285d78369bc73697";
  };

  "mingw-w64-i686-qt4" = fetch {
    name        = "mingw-w64-i686-qt4";
    version     = "4.8.7";
    filename    = "mingw-w64-i686-qt4-4.8.7-4-any.pkg.tar.xz";
    sha256      = "7c3e8755ad047a6317f7ad5513e3f6e31e5f3f67d53b4bfe59de8c25677b8f67";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-dbus mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-libiconv mingw-w64-i686-libjpeg mingw-w64-i686-libmng mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-libwebp mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-openssl mingw-w64-i686-pcre mingw-w64-i686-qtbinpatcher mingw-w64-i686-sqlite3 mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-qt5" = fetch {
    name        = "mingw-w64-i686-qt5";
    version     = "5.12.0";
    filename    = "mingw-w64-i686-qt5-5.12.0-1-any.pkg.tar.xz";
    sha256      = "3e32f759968f72df817b2efc1e39a72ec6907454b5f6bca777fae1c73fbb7692";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-qtbinpatcher mingw-w64-i686-z3 mingw-w64-i686-assimp mingw-w64-i686-dbus mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-harfbuzz mingw-w64-i686-jasper mingw-w64-i686-libjpeg mingw-w64-i686-libmng mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-libwebp mingw-w64-i686-openssl mingw-w64-i686-openal mingw-w64-i686-pcre2 mingw-w64-i686-sqlite3 mingw-w64-i686-vulkan mingw-w64-i686-xpm-nox mingw-w64-i686-zlib mingw-w64-i686-icu mingw-w64-i686-icu-debug-libs ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qt5-static" = fetch {
    name        = "mingw-w64-i686-qt5-static";
    version     = "5.12.0";
    filename    = "mingw-w64-i686-qt5-static-5.12.0-1-any.pkg.tar.xz";
    sha256      = "f5524a87b5f43a9bdee855c974e2722d134373c3e213abf877e4457487358785";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-qtbinpatcher mingw-w64-i686-z3 mingw-w64-i686-icu mingw-w64-i686-icu-debug-libs ];
  };

  "mingw-w64-i686-qtbinpatcher" = fetch {
    name        = "mingw-w64-i686-qtbinpatcher";
    version     = "2.2.0";
    filename    = "mingw-w64-i686-qtbinpatcher-2.2.0-2-any.pkg.tar.xz";
    sha256      = "a647fd1c1ab2b74509ad437d51829d35e975bdc64c36b4d189278bab24309dc0";
    buildInputs = [  ];
  };

  "mingw-w64-i686-qtwebkit" = fetch {
    name        = "mingw-w64-i686-qtwebkit";
    version     = "5.212.0alpha2";
    filename    = "mingw-w64-i686-qtwebkit-5.212.0alpha2-5-any.pkg.tar.xz";
    sha256      = "d6784a4b94a89d23b79fc03327b07ea0de27177068febab583c68727bbe41b98";
    buildInputs = [ mingw-w64-i686-icu mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-libwebp mingw-w64-i686-fontconfig mingw-w64-i686-sqlite3 mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-quantlib" = fetch {
    name        = "mingw-w64-i686-quantlib";
    version     = "1.14";
    filename    = "mingw-w64-i686-quantlib-1.14-1-any.pkg.tar.xz";
    sha256      = "baca3fc8e554e33a31f8daf2a3f5ba7292532eb79541cc45dac2cc746294fa88";
    buildInputs = [ mingw-w64-i686-boost ];
  };

  "mingw-w64-i686-quarter-hg" = fetch {
    name        = "mingw-w64-i686-quarter-hg";
    version     = "r507+.4040ac7a14cf+";
    filename    = "mingw-w64-i686-quarter-hg-r507+.4040ac7a14cf+-1-any.pkg.tar.xz";
    sha256      = "01e846615340d1b7c209c87078b0063c266d9cf2ecb9e50f141cb4ac077fcb8e";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-coin3d ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-quassel" = fetch {
    name        = "mingw-w64-i686-quassel";
    version     = "0.13.0";
    filename    = "mingw-w64-i686-quassel-0.13.0-1-any.pkg.tar.xz";
    sha256      = "5df6b4775be3a933f43496a11df5e72f12fcd156aaf7808da9aa6b6db4fcc594";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-qca-qt5-git mingw-w64-i686-Snorenotify ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-quazip" = fetch {
    name        = "mingw-w64-i686-quazip";
    version     = "0.7.6";
    filename    = "mingw-w64-i686-quazip-0.7.6-1-any.pkg.tar.xz";
    sha256      = "db3d07c2a830174d34fa7b59122b9a23b6b817890569b6266544c62b3ec593d1";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qwt-qt4" = fetch {
    name        = "mingw-w64-i686-qwt-qt4";
    version     = "6.1.2";
    filename    = "mingw-w64-i686-qwt-qt4-6.1.2-2-any.pkg.tar.xz";
    sha256      = "7bbf44d95d9d28c39af0471484de7ce3423df45a79400d145cbc0d8990040561";
    buildInputs = [ mingw-w64-i686-qt4 ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-qwt-qt5" = fetch {
    name        = "mingw-w64-i686-qwt-qt5";
    version     = "6.1.3";
    filename    = "mingw-w64-i686-qwt-qt5-6.1.3-1-any.pkg.tar.xz";
    sha256      = "da4657d793caa146dfc0beed7b6e80250b05d6453ca4fd54963cd8fd02867c2b";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qxmpp" = fetch {
    name        = "mingw-w64-i686-qxmpp";
    version     = "1.0.0";
    filename    = "mingw-w64-i686-qxmpp-1.0.0-1-any.pkg.tar.xz";
    sha256      = "f5770b51739d33e131c57a2d39606aede3d63249989a4bd068cf57bbb20efecb";
    buildInputs = [ mingw-w64-i686-libtheora mingw-w64-i686-libvpx mingw-w64-i686-opus mingw-w64-i686-qt5 mingw-w64-i686-speex ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-qxmpp-qt4" = fetch {
    name        = "mingw-w64-i686-qxmpp-qt4";
    version     = "0.8.3";
    filename    = "mingw-w64-i686-qxmpp-qt4-0.8.3-2-any.pkg.tar.xz";
    sha256      = "582b48ab0073553d675bf6dcbdb4ea90851b58708cb4ed4a5b05743ccbc3828a";
    buildInputs = [ mingw-w64-i686-libtheora mingw-w64-i686-libvpx mingw-w64-i686-qt4 mingw-w64-i686-speex ];
    broken      = true; # broken dependency mingw-w64-i686-qt4 -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-rabbitmq-c" = fetch {
    name        = "mingw-w64-i686-rabbitmq-c";
    version     = "0.9.0";
    filename    = "mingw-w64-i686-rabbitmq-c-0.9.0-2-any.pkg.tar.xz";
    sha256      = "b118cc11885bf5877ea8d9c3fba55b3410ef74981d6f3487d593228219ae89b7";
    buildInputs = [ mingw-w64-i686-openssl mingw-w64-i686-popt ];
  };

  "mingw-w64-i686-ragel" = fetch {
    name        = "mingw-w64-i686-ragel";
    version     = "6.10";
    filename    = "mingw-w64-i686-ragel-6.10-1-any.pkg.tar.xz";
    sha256      = "d4639e3a5d3ed9b273d9916523bb980a864742044cb02217f8ac8f217c5c387f";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-rapidjson" = fetch {
    name        = "mingw-w64-i686-rapidjson";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-rapidjson-1.1.0-1-any.pkg.tar.xz";
    sha256      = "5a8530ca5246a8d045e91cdd08b82763c74f8610f30018e9e032f0cd462dab63";
  };

  "mingw-w64-i686-readline" = fetch {
    name        = "mingw-w64-i686-readline";
    version     = "7.0.005";
    filename    = "mingw-w64-i686-readline-7.0.005-1-any.pkg.tar.xz";
    sha256      = "dbe8121625bb2d16d7aaa8d1a5dd40b59421a9dd12f01298f8a2c5ece605c39c";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-termcap ];
  };

  "mingw-w64-i686-readosm" = fetch {
    name        = "mingw-w64-i686-readosm";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-readosm-1.1.0-1-any.pkg.tar.xz";
    sha256      = "a0694669eff6082caa770fbe8b19f593457318d6dc5b82d4d0519efbe80a1495";
    buildInputs = [ mingw-w64-i686-expat mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-recode" = fetch {
    name        = "mingw-w64-i686-recode";
    version     = "3.7.1";
    filename    = "mingw-w64-i686-recode-3.7.1-1-any.pkg.tar.xz";
    sha256      = "d9efddefa1b512b353440590c3c4dea40e239055a108a6a81a6a4a27ffea10eb";
    buildInputs = [ mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-rhash" = fetch {
    name        = "mingw-w64-i686-rhash";
    version     = "1.3.7";
    filename    = "mingw-w64-i686-rhash-1.3.7-1-any.pkg.tar.xz";
    sha256      = "3849d177dec03e0d792806b25265c1f09fd2cae523a602a877808eb8c923fbf6";
    buildInputs = [ mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-rocksdb" = fetch {
    name        = "mingw-w64-i686-rocksdb";
    version     = "5.17.2";
    filename    = "mingw-w64-i686-rocksdb-5.17.2-1-any.pkg.tar.xz";
    sha256      = "bc3307c8f7f3592fb6a5e12d4145582aa4eab70acc6753860e7ba9f084940864";
    buildInputs = [ mingw-w64-i686-bzip2 mingw-w64-i686-intel-tbb mingw-w64-i686-lz4 mingw-w64-i686-snappy mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-rtmpdump-git" = fetch {
    name        = "mingw-w64-i686-rtmpdump-git";
    version     = "r512.fa8646d";
    filename    = "mingw-w64-i686-rtmpdump-git-r512.fa8646d-3-any.pkg.tar.xz";
    sha256      = "00d693981fa8aabb638dd0950b5471f66e1484ed87ac7c5f875f45acb499143a";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gmp mingw-w64-i686-gnutls mingw-w64-i686-nettle mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-rubberband" = fetch {
    name        = "mingw-w64-i686-rubberband";
    version     = "1.8.2";
    filename    = "mingw-w64-i686-rubberband-1.8.2-1-any.pkg.tar.xz";
    sha256      = "a44187d375bb3d627b05422066594bedc56c115553cfa235b3bd43d5b2e6e787";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-fftw mingw-w64-i686-libsamplerate mingw-w64-i686-libsndfile mingw-w64-i686-ladspa-sdk mingw-w64-i686-vamp-plugin-sdk ];
  };

  "mingw-w64-i686-ruby" = fetch {
    name        = "mingw-w64-i686-ruby";
    version     = "2.6.0";
    filename    = "mingw-w64-i686-ruby-2.6.0-1-any.pkg.tar.xz";
    sha256      = "3f5b0a669f26af9a08ee1ad48c0d39a69b3f9b204df641dc7b2484dd4abbde06";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gdbm mingw-w64-i686-libyaml mingw-w64-i686-libffi mingw-w64-i686-ncurses mingw-w64-i686-openssl mingw-w64-i686-tk ];
  };

  "mingw-w64-i686-ruby-cairo" = fetch {
    name        = "mingw-w64-i686-ruby-cairo";
    version     = "1.16.2";
    filename    = "mingw-w64-i686-ruby-cairo-1.16.2-1-any.pkg.tar.xz";
    sha256      = "19b9ab8d64234da36cb936f1e59dfb378c5f1f518614840b432617c8f743083b";
    buildInputs = [ mingw-w64-i686-ruby mingw-w64-i686-cairo mingw-w64-i686-ruby-pkg-config ];
  };

  "mingw-w64-i686-ruby-dbus" = fetch {
    name        = "mingw-w64-i686-ruby-dbus";
    version     = "0.15.0";
    filename    = "mingw-w64-i686-ruby-dbus-0.15.0-1-any.pkg.tar.xz";
    sha256      = "54a2748f117869435dce721380ef40e6d23db5a55bac1c76a2b1e9e9cdfaf8a4";
    buildInputs = [ mingw-w64-i686-ruby ];
  };

  "mingw-w64-i686-ruby-native-package-installer" = fetch {
    name        = "mingw-w64-i686-ruby-native-package-installer";
    version     = "1.0.6";
    filename    = "mingw-w64-i686-ruby-native-package-installer-1.0.6-1-any.pkg.tar.xz";
    sha256      = "c31a0470f87d45cb5cba4d13fcd14afe0e78d2ee1c28edcd4e40357d47b74630";
    buildInputs = [ mingw-w64-i686-ruby ];
  };

  "mingw-w64-i686-ruby-pkg-config" = fetch {
    name        = "mingw-w64-i686-ruby-pkg-config";
    version     = "1.3.1";
    filename    = "mingw-w64-i686-ruby-pkg-config-1.3.1-1-any.pkg.tar.xz";
    sha256      = "35fdf4f234223cbba78b7584b62934cd3afecb9762b99729f208b7c1204d39b5";
    buildInputs = [ mingw-w64-i686-ruby ];
  };

  "mingw-w64-i686-rust" = fetch {
    name        = "mingw-w64-i686-rust";
    version     = "1.29.2";
    filename    = "mingw-w64-i686-rust-1.29.2-1-any.pkg.tar.xz";
    sha256      = "845c2a147fd8bf050a1f13765434988a14187586ad938a8f8e96d807602ea61f";
    buildInputs = [ mingw-w64-i686-gcc ];
  };

  "mingw-w64-i686-rxspencer" = fetch {
    name        = "mingw-w64-i686-rxspencer";
    version     = "alpha3.8.g7";
    filename    = "mingw-w64-i686-rxspencer-alpha3.8.g7-1-any.pkg.tar.xz";
    sha256      = "398a876c46165bf5044c2272858bc1f163d535adb0ae33aeb4f68d69c7a57e3d";
  };

  "mingw-w64-i686-sassc" = fetch {
    name        = "mingw-w64-i686-sassc";
    version     = "3.5.0";
    filename    = "mingw-w64-i686-sassc-3.5.0-1-any.pkg.tar.xz";
    sha256      = "ddf520626e7dc47644a57f7d4c32687e27fcc2559d1e47dc438560f6aac44101";
    buildInputs = [ mingw-w64-i686-libsass ];
  };

  "mingw-w64-i686-schroedinger" = fetch {
    name        = "mingw-w64-i686-schroedinger";
    version     = "1.0.11";
    filename    = "mingw-w64-i686-schroedinger-1.0.11-4-any.pkg.tar.xz";
    sha256      = "392e0cd947c84e3ff1e94c4b17a85be316707d63072fbc94897cc0e85d7d86f9";
    buildInputs = [ mingw-w64-i686-orc ];
  };

  "mingw-w64-i686-scite" = fetch {
    name        = "mingw-w64-i686-scite";
    version     = "4.1.2";
    filename    = "mingw-w64-i686-scite-4.1.2-1-any.pkg.tar.xz";
    sha256      = "f3ceca12d4accb983ea1c0a56477306a83ea3526c98d9b5c825fe7fdd890dfe2";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gtk3 ];
  };

  "mingw-w64-i686-scite-defaults" = fetch {
    name        = "mingw-w64-i686-scite-defaults";
    version     = "4.1.2";
    filename    = "mingw-w64-i686-scite-defaults-4.1.2-1-any.pkg.tar.xz";
    sha256      = "1b15339c3548c85abe27f15b6fa2003d0191858afdc78b0131a5ec52861ee980";
    buildInputs = [ (assert mingw-w64-i686-scite.version=="4.1.2"; mingw-w64-i686-scite) ];
  };

  "mingw-w64-i686-scummvm" = fetch {
    name        = "mingw-w64-i686-scummvm";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-scummvm-2.0.0-1-any.pkg.tar.xz";
    sha256      = "a2c9453c308782f857fd419914b4dc064c0b1872ddc0c6282c9708db2e4bc6a6";
    buildInputs = [ mingw-w64-i686-faad2 mingw-w64-i686-freetype mingw-w64-i686-flac mingw-w64-i686-fluidsynth mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libogg mingw-w64-i686-libvorbis mingw-w64-i686-libmad mingw-w64-i686-libmpeg2-git mingw-w64-i686-libtheora mingw-w64-i686-libpng mingw-w64-i686-nasm mingw-w64-i686-readline mingw-w64-i686-SDL2 mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-seexpr" = fetch {
    name        = "mingw-w64-i686-seexpr";
    version     = "2.11";
    filename    = "mingw-w64-i686-seexpr-2.11-1-any.pkg.tar.xz";
    sha256      = "5b61f4f425432cb84bbf760f1dca8e7598bb14f89270947642c61ec02b9d5da7";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-sfml" = fetch {
    name        = "mingw-w64-i686-sfml";
    version     = "2.5.1";
    filename    = "mingw-w64-i686-sfml-2.5.1-2-any.pkg.tar.xz";
    sha256      = "4398b8908b3ccf9fe968a0793ccb091d7bac8f2eb83ec68f49b3ff060a32ae93";
    buildInputs = [ mingw-w64-i686-flac mingw-w64-i686-freetype mingw-w64-i686-libjpeg mingw-w64-i686-libvorbis mingw-w64-i686-openal ];
    broken      = true; # broken dependency mingw-w64-i686-sfml -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-sgml-common" = fetch {
    name        = "mingw-w64-i686-sgml-common";
    version     = "0.6.3";
    filename    = "mingw-w64-i686-sgml-common-0.6.3-1-any.pkg.tar.xz";
    sha256      = "815ba9b4ec1991a7185216ac33cda72d1f515bd8894c40131c6d240ecfe0d670";
    buildInputs = [ sh ];
  };

  "mingw-w64-i686-shapelib" = fetch {
    name        = "mingw-w64-i686-shapelib";
    version     = "1.4.1";
    filename    = "mingw-w64-i686-shapelib-1.4.1-1-any.pkg.tar.xz";
    sha256      = "cdf9787413cc299f246bf73bcbe0f4a986c7f61ad0590ba547562a3b1bfbd471";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-proj ];
  };

  "mingw-w64-i686-shared-mime-info" = fetch {
    name        = "mingw-w64-i686-shared-mime-info";
    version     = "1.10";
    filename    = "mingw-w64-i686-shared-mime-info-1.10-1-any.pkg.tar.xz";
    sha256      = "60fc1f68d37b58e26a0086f0b1e73676adcfa9b534e3762a09951a24a44a9db6";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-glib2 ];
  };

  "mingw-w64-i686-shiboken-qt4" = fetch {
    name        = "mingw-w64-i686-shiboken-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-i686-shiboken-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "ba3013f7117c99abad13f0f0cd7d72bf96da590fceb5e8e0581aa81ea23ca06f";
    buildInputs = [  ];
  };

  "mingw-w64-i686-shine" = fetch {
    name        = "mingw-w64-i686-shine";
    version     = "3.1.1";
    filename    = "mingw-w64-i686-shine-3.1.1-1-any.pkg.tar.xz";
    sha256      = "329e17389305952eda173001faf11be5cf89c7fc90fc8f434e52967422fd234f";
  };

  "mingw-w64-i686-shishi-git" = fetch {
    name        = "mingw-w64-i686-shishi-git";
    version     = "r3586.6fa08895";
    filename    = "mingw-w64-i686-shishi-git-r3586.6fa08895-1-any.pkg.tar.xz";
    sha256      = "040967be22fdc45704fd398792e810bbaa1e117a083ecff03357e701996fff75";
    buildInputs = [ mingw-w64-i686-gnutls mingw-w64-i686-libidn mingw-w64-i686-libgcrypt mingw-w64-i686-libgpg-error mingw-w64-i686-libtasn1 ];
  };

  "mingw-w64-i686-silc-toolkit" = fetch {
    name        = "mingw-w64-i686-silc-toolkit";
    version     = "1.1.12";
    filename    = "mingw-w64-i686-silc-toolkit-1.1.12-3-any.pkg.tar.xz";
    sha256      = "eb33ee3a81690192576221ad647341fbe2cf19235b922c45e9bf578a8a61ad81";
    buildInputs = [ mingw-w64-i686-libsystre ];
  };

  "mingw-w64-i686-simage-hg" = fetch {
    name        = "mingw-w64-i686-simage-hg";
    version     = "r748+.194ff9c6293e+";
    filename    = "mingw-w64-i686-simage-hg-r748+.194ff9c6293e+-1-any.pkg.tar.xz";
    sha256      = "bb13b99863edda85d580a3218063a6d121edbd003432561143d1584fa58fa6da";
    buildInputs = [ mingw-w64-i686-giflib mingw-w64-i686-jasper mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libpng mingw-w64-i686-libsndfile mingw-w64-i686-libtiff mingw-w64-i686-libvorbis mingw-w64-i686-qt5 mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-sip" = fetch {
    name        = "mingw-w64-i686-sip";
    version     = "4.19.13";
    filename    = "mingw-w64-i686-sip-4.19.13-2-any.pkg.tar.xz";
    sha256      = "653499512eefd0b355a7cab0f9c0defa3c99a9f901b21cd27f4c29c3d2547a61";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-smpeg" = fetch {
    name        = "mingw-w64-i686-smpeg";
    version     = "0.4.5";
    filename    = "mingw-w64-i686-smpeg-0.4.5-2-any.pkg.tar.xz";
    sha256      = "2dd5fd201939a20dbd3593660b7b220a07bf1b61fdea8fedbe2cef12e270a1db";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-SDL ];
  };

  "mingw-w64-i686-smpeg2" = fetch {
    name        = "mingw-w64-i686-smpeg2";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-smpeg2-2.0.0-5-any.pkg.tar.xz";
    sha256      = "85d4e3d6cfe0d50d9278ee97bdbadcc0ae0b107ce699a147a46dcd844e0759f5";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-SDL2 ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-snappy" = fetch {
    name        = "mingw-w64-i686-snappy";
    version     = "1.1.7";
    filename    = "mingw-w64-i686-snappy-1.1.7-1-any.pkg.tar.xz";
    sha256      = "6bc1ad7c5423b34b55b436b19b00b92bad89546f08447de0646a699052b45b97";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-snoregrowl" = fetch {
    name        = "mingw-w64-i686-snoregrowl";
    version     = "0.5.0";
    filename    = "mingw-w64-i686-snoregrowl-0.5.0-1-any.pkg.tar.xz";
    sha256      = "46a6c363d4490ddfeeb2895096c90e2f728e0f93b16772a88551029330316fe4";
  };

  "mingw-w64-i686-snorenotify" = fetch {
    name        = "mingw-w64-i686-snorenotify";
    version     = "0.7.0";
    filename    = "mingw-w64-i686-snorenotify-0.7.0-2-any.pkg.tar.xz";
    sha256      = "a48854ef1effc18b0e3522e65004857c232e9f1975fd477531c9b22a0851390e";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-snoregrowl ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-soci" = fetch {
    name        = "mingw-w64-i686-soci";
    version     = "3.2.3";
    filename    = "mingw-w64-i686-soci-3.2.3-1-any.pkg.tar.xz";
    sha256      = "14769b7a6708fc38a87dda39592e82e931223e0fb16593538e0f90fb15d8c3a6";
    buildInputs = [ mingw-w64-i686-boost ];
  };

  "mingw-w64-i686-solid-qt5" = fetch {
    name        = "mingw-w64-i686-solid-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-solid-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "6aac11d087eb8d96a79bcad857aa1569d517590876e4c765acd0828fe4dc16d7";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-sonnet-qt5" = fetch {
    name        = "mingw-w64-i686-sonnet-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-sonnet-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "917030e2e3939ae44f3cb28b16fdffbb83148c6e5398620f4524f037592b6f52";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-soqt-hg" = fetch {
    name        = "mingw-w64-i686-soqt-hg";
    version     = "r1962+.6719cfeef271+";
    filename    = "mingw-w64-i686-soqt-hg-r1962+.6719cfeef271+-1-any.pkg.tar.xz";
    sha256      = "c2ad5a69a65d82ae1be609bbb49a58cce74b59d6cccc153f45c78a3de9f6678f";
    buildInputs = [ mingw-w64-i686-coin3d mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-soqt-hg -> mingw-w64-i686-coin3d
  };

  "mingw-w64-i686-soundtouch" = fetch {
    name        = "mingw-w64-i686-soundtouch";
    version     = "2.1.2";
    filename    = "mingw-w64-i686-soundtouch-2.1.2-1-any.pkg.tar.xz";
    sha256      = "4d90bc1a994800dd12b5a4efcd375f1eb6dcbb34313f7481a2f0ab2a185dacfa";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-source-highlight" = fetch {
    name        = "mingw-w64-i686-source-highlight";
    version     = "3.1.8";
    filename    = "mingw-w64-i686-source-highlight-3.1.8-1-any.pkg.tar.xz";
    sha256      = "cb17cf81b89c4dc342308925840e8faecb71f44ed020be93f2d87dd98d4af821";
    buildInputs = [ bash mingw-w64-i686-boost ];
  };

  "mingw-w64-i686-sparsehash" = fetch {
    name        = "mingw-w64-i686-sparsehash";
    version     = "2.0.3";
    filename    = "mingw-w64-i686-sparsehash-2.0.3-1-any.pkg.tar.xz";
    sha256      = "9c84f43692b5f52e2fe625beb8d1535cf13ecb1352a7f9719e6b7ca07323d31d";
  };

  "mingw-w64-i686-spatialite-tools" = fetch {
    name        = "mingw-w64-i686-spatialite-tools";
    version     = "4.3.0";
    filename    = "mingw-w64-i686-spatialite-tools-4.3.0-2-any.pkg.tar.xz";
    sha256      = "80b0ded223c2492ebd84f64f7fea64d24b9dd0b73a7f424ac3663183d080c3da";
    buildInputs = [ mingw-w64-i686-libspatialite mingw-w64-i686-readosm mingw-w64-i686-libiconv ];
  };

  "mingw-w64-i686-spdylay" = fetch {
    name        = "mingw-w64-i686-spdylay";
    version     = "1.4.0";
    filename    = "mingw-w64-i686-spdylay-1.4.0-1-any.pkg.tar.xz";
    sha256      = "49dd04ae49f8a2eeab8820e3546c01cdc1a538515606e98e53ec06e814be8001";
  };

  "mingw-w64-i686-speex" = fetch {
    name        = "mingw-w64-i686-speex";
    version     = "1.2.0";
    filename    = "mingw-w64-i686-speex-1.2.0-1-any.pkg.tar.xz";
    sha256      = "4b8f760db85b18ef84e47fcc4cb1567191d29db3829115c9aabb742c6ffad4cb";
    buildInputs = [ mingw-w64-i686-libogg mingw-w64-i686-speexdsp ];
  };

  "mingw-w64-i686-speexdsp" = fetch {
    name        = "mingw-w64-i686-speexdsp";
    version     = "1.2rc3";
    filename    = "mingw-w64-i686-speexdsp-1.2rc3-3-any.pkg.tar.xz";
    sha256      = "ddef418231253e1a4c8e571c2bade5c082b40d7a55721e4c300f244f1d3e31dc";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-spice-gtk" = fetch {
    name        = "mingw-w64-i686-spice-gtk";
    version     = "0.35";
    filename    = "mingw-w64-i686-spice-gtk-0.35-3-any.pkg.tar.xz";
    sha256      = "5e1c4e9d14803c337a0774048c62e61e40b546610f316225a08d53abf34d7567";
    buildInputs = [ mingw-w64-i686-cyrus-sasl mingw-w64-i686-dbus-glib mingw-w64-i686-gobject-introspection mingw-w64-i686-gstreamer mingw-w64-i686-gst-plugins-base mingw-w64-i686-gtk3 mingw-w64-i686-libjpeg-turbo mingw-w64-i686-lz4 mingw-w64-i686-openssl mingw-w64-i686-phodav mingw-w64-i686-pixman mingw-w64-i686-spice-protocol mingw-w64-i686-usbredir mingw-w64-i686-vala ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-spice-protocol" = fetch {
    name        = "mingw-w64-i686-spice-protocol";
    version     = "0.12.14";
    filename    = "mingw-w64-i686-spice-protocol-0.12.14-1-any.pkg.tar.xz";
    sha256      = "fd49f861c975b0fa2880d59fcc929fd684dc3d2569cea081c604f18c07c91a8c";
  };

  "mingw-w64-i686-spirv-tools" = fetch {
    name        = "mingw-w64-i686-spirv-tools";
    version     = "2018.6";
    filename    = "mingw-w64-i686-spirv-tools-2018.6-1-any.pkg.tar.xz";
    sha256      = "f2b5a427b90e718dce9196c7b90334cfcb14bd6edf546e9b7190feb179ffed84";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-sqlcipher" = fetch {
    name        = "mingw-w64-i686-sqlcipher";
    version     = "4.0.1";
    filename    = "mingw-w64-i686-sqlcipher-4.0.1-1-any.pkg.tar.xz";
    sha256      = "78ca32dad9fb8c5fbd8f0848f1e9c6d19ba5a1e82c7c6346682d199f4002a05c";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-openssl mingw-w64-i686-readline ];
  };

  "mingw-w64-i686-sqlheavy" = fetch {
    name        = "mingw-w64-i686-sqlheavy";
    version     = "0.1.1";
    filename    = "mingw-w64-i686-sqlheavy-0.1.1-2-any.pkg.tar.xz";
    sha256      = "9bf07d1efbdd8f5a012c1ef660b0646a603aa13c3088a1159520cec108aefaee";
    buildInputs = [ mingw-w64-i686-gtk2 mingw-w64-i686-sqlite3 mingw-w64-i686-vala mingw-w64-i686-libxml2 ];
    broken      = true; # broken dependency mingw-w64-i686-libgd -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-sqlite-analyzer" = fetch {
    name        = "mingw-w64-i686-sqlite-analyzer";
    version     = "3.16.1";
    filename    = "mingw-w64-i686-sqlite-analyzer-3.16.1-1-any.pkg.tar.xz";
    sha256      = "76ec619309b6d16162568ef22d3fad16f7f619a1df7d135876e6c9a528cbe6c9";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-tcl ];
  };

  "mingw-w64-i686-sqlite3" = fetch {
    name        = "mingw-w64-i686-sqlite3";
    version     = "3.26.0";
    filename    = "mingw-w64-i686-sqlite3-3.26.0-1-any.pkg.tar.xz";
    sha256      = "f0c079be572b0367f66e6d492a132e63393e7ebe7b1f87e3f5de55a14d7cc24f";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-ncurses mingw-w64-i686-readline ];
  };

  "mingw-w64-i686-srt" = fetch {
    name        = "mingw-w64-i686-srt";
    version     = "1.3.1";
    filename    = "mingw-w64-i686-srt-1.3.1-3-any.pkg.tar.xz";
    sha256      = "879e418a75add87a8435a7a32e02ff810acc26c9e4bd475ef2f93f8da33bcc2b";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libwinpthread-git mingw-w64-i686-openssl ];
  };

  "mingw-w64-i686-stxxl-git" = fetch {
    name        = "mingw-w64-i686-stxxl-git";
    version     = "1.4.1.343.gf7389c7";
    filename    = "mingw-w64-i686-stxxl-git-1.4.1.343.gf7389c7-2-any.pkg.tar.xz";
    sha256      = "a4d5a270846f85d00e9cc432a19679166b65887301d56f2b1a472b5e78864b92";
  };

  "mingw-w64-i686-styrene" = fetch {
    name        = "mingw-w64-i686-styrene";
    version     = "0.3.0";
    filename    = "mingw-w64-i686-styrene-0.3.0-2-any.pkg.tar.xz";
    sha256      = "22ef54f4668dcc226084392e229452ab191ea492f806108fcdf9a348388cd193";
    buildInputs = [ zip mingw-w64-i686-python3 mingw-w64-i686-gcc mingw-w64-i686-binutils mingw-w64-i686-nsis ];
    broken      = true; # broken dependency mingw-w64-i686-styrene -> zip
  };

  "mingw-w64-i686-suitesparse" = fetch {
    name        = "mingw-w64-i686-suitesparse";
    version     = "6.0.0";
    filename    = "mingw-w64-i686-suitesparse-6.0.0-2-any.pkg.tar.xz";
    sha256      = "32f4a9aff4f54595a4c2b437b4e3d0b0af7f3f99af05f3161168db1719162e6f";
    buildInputs = [ mingw-w64-i686-openblas mingw-w64-i686-metis ];
  };

  "mingw-w64-i686-superglu-hg" = fetch {
    name        = "mingw-w64-i686-superglu-hg";
    version     = "r79.16efd99583f2";
    filename    = "mingw-w64-i686-superglu-hg-r79.16efd99583f2-1-any.pkg.tar.xz";
    sha256      = "6e18b4d07cd14433eda46c5ee3fa4ad9372fb73b6a5879e809ef5f07fa0a28d5";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-swig" = fetch {
    name        = "mingw-w64-i686-swig";
    version     = "3.0.12";
    filename    = "mingw-w64-i686-swig-3.0.12-1-any.pkg.tar.xz";
    sha256      = "92c190c67308f65dd5f3e5595fc12fbe56557d642cf78742944a81b4effeadd9";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-pcre ];
  };

  "mingw-w64-i686-syndication-qt5" = fetch {
    name        = "mingw-w64-i686-syndication-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-syndication-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "0ea837aee3203c74378c4777f07360ae55c3de8128d4b5a77f3875f35fe5d996";
    buildInputs = [ mingw-w64-i686-qt5 (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-kcodecs-qt5.version "5.50.0"; mingw-w64-i686-kcodecs-qt5) ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-syntax-highlighting-qt5" = fetch {
    name        = "mingw-w64-i686-syntax-highlighting-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-syntax-highlighting-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "366e5665bb1f07cf56b946b5491ffb7279ac7c893ac114a552c5a1d95de54867";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-szip" = fetch {
    name        = "mingw-w64-i686-szip";
    version     = "2.1.1";
    filename    = "mingw-w64-i686-szip-2.1.1-2-any.pkg.tar.xz";
    sha256      = "58b5efe1420a2bfd6e92cf94112d29b03ec588f54f4a995a1b26034076f0d369";
    buildInputs = [  ];
  };

  "mingw-w64-i686-taglib" = fetch {
    name        = "mingw-w64-i686-taglib";
    version     = "1.11.1";
    filename    = "mingw-w64-i686-taglib-1.11.1-1-any.pkg.tar.xz";
    sha256      = "a23f5d55663ab060f5988da38864724204990751f3fb3316fb17045aa9dfe68d";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-tcl" = fetch {
    name        = "mingw-w64-i686-tcl";
    version     = "8.6.9";
    filename    = "mingw-w64-i686-tcl-8.6.9-2-any.pkg.tar.xz";
    sha256      = "8960084b5caaeb2349f4d927d2fdb8bbdf6eab9fdb33160acd12492075aaed7d";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-tcl-nsf" = fetch {
    name        = "mingw-w64-i686-tcl-nsf";
    version     = "2.1.0";
    filename    = "mingw-w64-i686-tcl-nsf-2.1.0-1-any.pkg.tar.xz";
    sha256      = "5cadaaeebb387576af6cedce2ad55ced1d9adef9909ff9f162c901f772734779";
    buildInputs = [ mingw-w64-i686-tcl ];
  };

  "mingw-w64-i686-tcllib" = fetch {
    name        = "mingw-w64-i686-tcllib";
    version     = "1.19";
    filename    = "mingw-w64-i686-tcllib-1.19-1-any.pkg.tar.xz";
    sha256      = "64f8b57b811300952687a53aa65f473783e5b537ad6ff7ab3ddb761d68fc6630";
    buildInputs = [ mingw-w64-i686-tcl ];
  };

  "mingw-w64-i686-tclvfs-cvs" = fetch {
    name        = "mingw-w64-i686-tclvfs-cvs";
    version     = "20130425";
    filename    = "mingw-w64-i686-tclvfs-cvs-20130425-3-any.pkg.tar.xz";
    sha256      = "51cc95c9d04743fb4190a3495b7bc0705f41beac24722bdb314f6fa7df9a5000";
    buildInputs = [ mingw-w64-i686-tcl ];
  };

  "mingw-w64-i686-tclx" = fetch {
    name        = "mingw-w64-i686-tclx";
    version     = "8.4.1";
    filename    = "mingw-w64-i686-tclx-8.4.1-3-any.pkg.tar.xz";
    sha256      = "4135d614c2011ff158592119092da5b695e3050fed1050eca086f1b16b28fb68";
    buildInputs = [ mingw-w64-i686-tcl ];
  };

  "mingw-w64-i686-template-glib" = fetch {
    name        = "mingw-w64-i686-template-glib";
    version     = "3.30.0";
    filename    = "mingw-w64-i686-template-glib-3.30.0-1-any.pkg.tar.xz";
    sha256      = "8cfcb870ddae996e302c800cd62fd261da5d5d31d7d2a7301e31bb890aa53929";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gobject-introspection ];
  };

  "mingw-w64-i686-tepl4" = fetch {
    name        = "mingw-w64-i686-tepl4";
    version     = "4.2.0";
    filename    = "mingw-w64-i686-tepl4-4.2.0-1-any.pkg.tar.xz";
    sha256      = "36f1de4dff7b71afa296dda12a6d29aa8beec59439b37a5798e8ce8296c75623";
    buildInputs = [ mingw-w64-i686-amtk mingw-w64-i686-gtksourceview4 mingw-w64-i686-uchardet ];
  };

  "mingw-w64-i686-termcap" = fetch {
    name        = "mingw-w64-i686-termcap";
    version     = "1.3.1";
    filename    = "mingw-w64-i686-termcap-1.3.1-3-any.pkg.tar.xz";
    sha256      = "cf1e1b2bc3e9d2d454edd1796995ff12969abae90d065970a0bd2a0c105185f8";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-tesseract-data-afr" = fetch {
    name        = "mingw-w64-i686-tesseract-data-afr";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-afr-4.0.0-1-any.pkg.tar.xz";
    sha256      = "dbb7129b0cce770a71d670ce38fc84755739c128010341ca251164a20dc3ebc0";
  };

  "mingw-w64-i686-tesseract-data-amh" = fetch {
    name        = "mingw-w64-i686-tesseract-data-amh";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-amh-4.0.0-1-any.pkg.tar.xz";
    sha256      = "8a8abd15695048c1db917fd7f7e644b083fe8c36bd2b88b05f5d7f19efaa817c";
  };

  "mingw-w64-i686-tesseract-data-ara" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ara";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ara-4.0.0-1-any.pkg.tar.xz";
    sha256      = "0af1c20c98fe8eac6c2a89e964f3130a886e28511120a064efe43eb2ab5b8257";
  };

  "mingw-w64-i686-tesseract-data-asm" = fetch {
    name        = "mingw-w64-i686-tesseract-data-asm";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-asm-4.0.0-1-any.pkg.tar.xz";
    sha256      = "b9843341bab2bf890a0826be48e25217dd7cc4f0dd9c273679f5dccf233a214e";
  };

  "mingw-w64-i686-tesseract-data-aze" = fetch {
    name        = "mingw-w64-i686-tesseract-data-aze";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-aze-4.0.0-1-any.pkg.tar.xz";
    sha256      = "a2abc502bdd03123343fab8ca68a0375c6805203587cde95d3a40663beee4f13";
  };

  "mingw-w64-i686-tesseract-data-aze_cyrl" = fetch {
    name        = "mingw-w64-i686-tesseract-data-aze_cyrl";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-aze_cyrl-4.0.0-1-any.pkg.tar.xz";
    sha256      = "7e96b46f014d7cabd9428a8c00caf7d7e40077523ea235155ea6e25bcb4e79e9";
  };

  "mingw-w64-i686-tesseract-data-bel" = fetch {
    name        = "mingw-w64-i686-tesseract-data-bel";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-bel-4.0.0-1-any.pkg.tar.xz";
    sha256      = "8fc72571ff1e1ba0f64b26e4e2be7f9ce9cf64f423176243096700d6a6c694ac";
  };

  "mingw-w64-i686-tesseract-data-ben" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ben";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ben-4.0.0-1-any.pkg.tar.xz";
    sha256      = "058e09d5f8104fe7644bc8f34b26191eaae147e78205fc4f2d205645f698e0f3";
  };

  "mingw-w64-i686-tesseract-data-bod" = fetch {
    name        = "mingw-w64-i686-tesseract-data-bod";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-bod-4.0.0-1-any.pkg.tar.xz";
    sha256      = "bc67d88f4a11b956296b08cc5b0ac9b45ee09e23fd488946cc236b42613c05c7";
  };

  "mingw-w64-i686-tesseract-data-bos" = fetch {
    name        = "mingw-w64-i686-tesseract-data-bos";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-bos-4.0.0-1-any.pkg.tar.xz";
    sha256      = "a44162b788366d38e59a695e4de123e0ee01b594c4c4f86be7569cb172dc3004";
  };

  "mingw-w64-i686-tesseract-data-bul" = fetch {
    name        = "mingw-w64-i686-tesseract-data-bul";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-bul-4.0.0-1-any.pkg.tar.xz";
    sha256      = "7c290679313a2a84ff5a0005f01de0a0192648c4f8b04f2775b478cbd195cbf0";
  };

  "mingw-w64-i686-tesseract-data-cat" = fetch {
    name        = "mingw-w64-i686-tesseract-data-cat";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-cat-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ff6f6986fd15952d95db779d1301f6bf8f6ebc094af4ed66bc5fe78cb63966c0";
  };

  "mingw-w64-i686-tesseract-data-ceb" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ceb";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ceb-4.0.0-1-any.pkg.tar.xz";
    sha256      = "68daf6a512063e86065c9db866d58cea91a0596a18ac0d4b1054e1017b7654ed";
  };

  "mingw-w64-i686-tesseract-data-ces" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ces";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ces-4.0.0-1-any.pkg.tar.xz";
    sha256      = "e694bcecb8ffd7cb96092ff57e45deaa634946bb95c14d004fe2c8aaf1d71a65";
  };

  "mingw-w64-i686-tesseract-data-chi_sim" = fetch {
    name        = "mingw-w64-i686-tesseract-data-chi_sim";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-chi_sim-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ed6dbcfc7022e8c2298ce7d7090107176e3fae3521ffd99ed5b5b5d8a490c8cb";
  };

  "mingw-w64-i686-tesseract-data-chi_tra" = fetch {
    name        = "mingw-w64-i686-tesseract-data-chi_tra";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-chi_tra-4.0.0-1-any.pkg.tar.xz";
    sha256      = "7b492ef2858f368336f0cb06e555d54501fc6a308f59dcf1166b65dbfa12b6d8";
  };

  "mingw-w64-i686-tesseract-data-chr" = fetch {
    name        = "mingw-w64-i686-tesseract-data-chr";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-chr-4.0.0-1-any.pkg.tar.xz";
    sha256      = "d2e1aa8208d917bd13f125d29b09b5f6662ee6a1301ab3c59e24b02fbc68357c";
  };

  "mingw-w64-i686-tesseract-data-cym" = fetch {
    name        = "mingw-w64-i686-tesseract-data-cym";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-cym-4.0.0-1-any.pkg.tar.xz";
    sha256      = "c24429b25cdb2ecd1985b518733ab0fac052f4b38cbb5acce8eaebe01cddc351";
  };

  "mingw-w64-i686-tesseract-data-dan" = fetch {
    name        = "mingw-w64-i686-tesseract-data-dan";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-dan-4.0.0-1-any.pkg.tar.xz";
    sha256      = "a728260c9ee77bddcd9e6bff13b436e4ddb5eea173767ac473af5a7a246c6108";
  };

  "mingw-w64-i686-tesseract-data-dan_frak" = fetch {
    name        = "mingw-w64-i686-tesseract-data-dan_frak";
    version     = "3.04.00";
    filename    = "mingw-w64-i686-tesseract-data-dan_frak-3.04.00-1-any.pkg.tar.xz";
    sha256      = "b7a057292214578200efdd6a9e8458404f67842c3a88cea79824d3d520acc1e9";
  };

  "mingw-w64-i686-tesseract-data-deu" = fetch {
    name        = "mingw-w64-i686-tesseract-data-deu";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-deu-4.0.0-1-any.pkg.tar.xz";
    sha256      = "461d55ec0e0b0975ffc3988187c086f09025711d3bffac1d56759e810cbd39c8";
  };

  "mingw-w64-i686-tesseract-data-deu_frak" = fetch {
    name        = "mingw-w64-i686-tesseract-data-deu_frak";
    version     = "3.04.00";
    filename    = "mingw-w64-i686-tesseract-data-deu_frak-3.04.00-1-any.pkg.tar.xz";
    sha256      = "83fe1ea43069d81b2ac0666d2d279ddfc7f730b065ab799bb0a2c3ddebfb70d0";
  };

  "mingw-w64-i686-tesseract-data-dzo" = fetch {
    name        = "mingw-w64-i686-tesseract-data-dzo";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-dzo-4.0.0-1-any.pkg.tar.xz";
    sha256      = "265c038094b62234f27d16a557c57965750c56012086c7e6a6098f141634ab54";
  };

  "mingw-w64-i686-tesseract-data-ell" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ell";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ell-4.0.0-1-any.pkg.tar.xz";
    sha256      = "6234757ae06770b05585bbb99dfed3b6f1df44ef1e7e122fef857da95cb06d0d";
  };

  "mingw-w64-i686-tesseract-data-eng" = fetch {
    name        = "mingw-w64-i686-tesseract-data-eng";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-eng-4.0.0-1-any.pkg.tar.xz";
    sha256      = "1e7d9af728776ca0d322651d37d463686aa869adb9edbb1d3d3a153a2b46c771";
  };

  "mingw-w64-i686-tesseract-data-enm" = fetch {
    name        = "mingw-w64-i686-tesseract-data-enm";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-enm-4.0.0-1-any.pkg.tar.xz";
    sha256      = "2fff4dd170b10fd9e536ae1986a0f62325a048a2452deb9a86a99b6768615902";
  };

  "mingw-w64-i686-tesseract-data-epo" = fetch {
    name        = "mingw-w64-i686-tesseract-data-epo";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-epo-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ef7a39654edba77737d4bbca8b82bf0c05b7b3e935fe23bf8b58cc74989e90ef";
  };

  "mingw-w64-i686-tesseract-data-equ" = fetch {
    name        = "mingw-w64-i686-tesseract-data-equ";
    version     = "3.04.00";
    filename    = "mingw-w64-i686-tesseract-data-equ-3.04.00-1-any.pkg.tar.xz";
    sha256      = "c4d4e67f640f5d56efffa04624fe00e145badccdbcb51408e49d188637f9a9fc";
  };

  "mingw-w64-i686-tesseract-data-est" = fetch {
    name        = "mingw-w64-i686-tesseract-data-est";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-est-4.0.0-1-any.pkg.tar.xz";
    sha256      = "13d0cbd7a40fb21bc199f8ed58cb5109b942de803c9ba1a0885e6d1015de3dfe";
  };

  "mingw-w64-i686-tesseract-data-eus" = fetch {
    name        = "mingw-w64-i686-tesseract-data-eus";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-eus-4.0.0-1-any.pkg.tar.xz";
    sha256      = "2ec5fe4953cc720a3689b32afa01ab96cf877aabffacc1f98d5c44ffda3f5b74";
  };

  "mingw-w64-i686-tesseract-data-fas" = fetch {
    name        = "mingw-w64-i686-tesseract-data-fas";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-fas-4.0.0-1-any.pkg.tar.xz";
    sha256      = "68c7607b5550c84f3a532cb9dba30dd9fa283448feb9ceda27ed8a047e7398e8";
  };

  "mingw-w64-i686-tesseract-data-fin" = fetch {
    name        = "mingw-w64-i686-tesseract-data-fin";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-fin-4.0.0-1-any.pkg.tar.xz";
    sha256      = "83a1b179b74524c5b134c203eec9bff87ed138f3a54b605e86d0edc8d6016a2b";
  };

  "mingw-w64-i686-tesseract-data-fra" = fetch {
    name        = "mingw-w64-i686-tesseract-data-fra";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-fra-4.0.0-1-any.pkg.tar.xz";
    sha256      = "15dab5e9905e72539c2e522e3095e2d4f113ee9959343949fbc10b76fce943de";
  };

  "mingw-w64-i686-tesseract-data-frk" = fetch {
    name        = "mingw-w64-i686-tesseract-data-frk";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-frk-4.0.0-1-any.pkg.tar.xz";
    sha256      = "5ccf9466ed303cb44d4ee0ab287442a17b84d70fe388c06062ae11efe93e14c9";
  };

  "mingw-w64-i686-tesseract-data-frm" = fetch {
    name        = "mingw-w64-i686-tesseract-data-frm";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-frm-4.0.0-1-any.pkg.tar.xz";
    sha256      = "c8939570ae2ee3fe2c11962c984de2f490bab9610ef3289ad8741f6676ff1925";
  };

  "mingw-w64-i686-tesseract-data-gle" = fetch {
    name        = "mingw-w64-i686-tesseract-data-gle";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-gle-4.0.0-1-any.pkg.tar.xz";
    sha256      = "33dd441ed2602e024044e4724baa27e68121988e5aad9725aeb6c7268bf6b75a";
  };

  "mingw-w64-i686-tesseract-data-glg" = fetch {
    name        = "mingw-w64-i686-tesseract-data-glg";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-glg-4.0.0-1-any.pkg.tar.xz";
    sha256      = "60db3c5048aefeac427a46cf9349eb8ccfdffa5d9d340ca770896b9ffc6fb6e6";
  };

  "mingw-w64-i686-tesseract-data-grc" = fetch {
    name        = "mingw-w64-i686-tesseract-data-grc";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-grc-4.0.0-1-any.pkg.tar.xz";
    sha256      = "3caf63c105895494c82d8eae12dbf88b3d9caab8e3c27330d01a82f3cc427e54";
  };

  "mingw-w64-i686-tesseract-data-guj" = fetch {
    name        = "mingw-w64-i686-tesseract-data-guj";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-guj-4.0.0-1-any.pkg.tar.xz";
    sha256      = "73e4a832a734334b38112ce63135033c1c4710414a862e84eb8825283f95da3c";
  };

  "mingw-w64-i686-tesseract-data-hat" = fetch {
    name        = "mingw-w64-i686-tesseract-data-hat";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-hat-4.0.0-1-any.pkg.tar.xz";
    sha256      = "92dd48d724a2743cfa1e81594dc70329a3bdcbb29dda360255a874c94e4fdef9";
  };

  "mingw-w64-i686-tesseract-data-heb" = fetch {
    name        = "mingw-w64-i686-tesseract-data-heb";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-heb-4.0.0-1-any.pkg.tar.xz";
    sha256      = "6c272e63daaf192862c031564a195a99a6cb57638e878f66b6e3749abba11f16";
  };

  "mingw-w64-i686-tesseract-data-hin" = fetch {
    name        = "mingw-w64-i686-tesseract-data-hin";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-hin-4.0.0-1-any.pkg.tar.xz";
    sha256      = "0da128841f62de9f8642215a2fe0d3322eed7d1819637ead4fd4629203cedda4";
  };

  "mingw-w64-i686-tesseract-data-hrv" = fetch {
    name        = "mingw-w64-i686-tesseract-data-hrv";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-hrv-4.0.0-1-any.pkg.tar.xz";
    sha256      = "101a5ff7ee035ee21de2833bdb1c939d707dd0dff6e671c8cea3b768213dcaec";
  };

  "mingw-w64-i686-tesseract-data-hun" = fetch {
    name        = "mingw-w64-i686-tesseract-data-hun";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-hun-4.0.0-1-any.pkg.tar.xz";
    sha256      = "b9b8c5aad2e105ff72509d05746f4c8184821fe0c7f6bf60b8b14115ada22bd5";
  };

  "mingw-w64-i686-tesseract-data-iku" = fetch {
    name        = "mingw-w64-i686-tesseract-data-iku";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-iku-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f5914b822608d7bcdceb1d3491f709d0780fe3939da7f9bcfc6ab11a2702ec7c";
  };

  "mingw-w64-i686-tesseract-data-ind" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ind";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ind-4.0.0-1-any.pkg.tar.xz";
    sha256      = "1b4aa2d3570452997a40fed903d3665ee7a90a47ccf52d540c2a00384b5b64dd";
  };

  "mingw-w64-i686-tesseract-data-isl" = fetch {
    name        = "mingw-w64-i686-tesseract-data-isl";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-isl-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f473ab10a11d9f8285fbc53d4aaa1da13d0ff3b5dc03e1599c51d07c7fb7cb85";
  };

  "mingw-w64-i686-tesseract-data-ita" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ita";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ita-4.0.0-1-any.pkg.tar.xz";
    sha256      = "434678eb10596eafed9e5f815da80a6e325847d61992c85459dd309ec0a4278b";
  };

  "mingw-w64-i686-tesseract-data-ita_old" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ita_old";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ita_old-4.0.0-1-any.pkg.tar.xz";
    sha256      = "5c07286986a33c58398debff958a0d859f86eb7b1e426797c208993031636847";
  };

  "mingw-w64-i686-tesseract-data-jav" = fetch {
    name        = "mingw-w64-i686-tesseract-data-jav";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-jav-4.0.0-1-any.pkg.tar.xz";
    sha256      = "3efff2f6f82a17858b7c38422ec47a291bdeb5e0e5b308f5d0bf2c931319910c";
  };

  "mingw-w64-i686-tesseract-data-jpn" = fetch {
    name        = "mingw-w64-i686-tesseract-data-jpn";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-jpn-4.0.0-1-any.pkg.tar.xz";
    sha256      = "841bc6c0d68cd98159ed6d4c9e1649827d996d577389260c502549858f28ca53";
  };

  "mingw-w64-i686-tesseract-data-kan" = fetch {
    name        = "mingw-w64-i686-tesseract-data-kan";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-kan-4.0.0-1-any.pkg.tar.xz";
    sha256      = "d813d2153d0390895f66cc9d4de31a4e6a8f82f6e555808285071479b5de785e";
  };

  "mingw-w64-i686-tesseract-data-kat" = fetch {
    name        = "mingw-w64-i686-tesseract-data-kat";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-kat-4.0.0-1-any.pkg.tar.xz";
    sha256      = "e5ac31c69047cbf88cc1a71598a2046387745623deceb5d2e88f8e87c925c541";
  };

  "mingw-w64-i686-tesseract-data-kat_old" = fetch {
    name        = "mingw-w64-i686-tesseract-data-kat_old";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-kat_old-4.0.0-1-any.pkg.tar.xz";
    sha256      = "141ab7fb125d6730f45c5b60875c2b5c6bcd82fe702b2b85679216a324edea7d";
  };

  "mingw-w64-i686-tesseract-data-kaz" = fetch {
    name        = "mingw-w64-i686-tesseract-data-kaz";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-kaz-4.0.0-1-any.pkg.tar.xz";
    sha256      = "aa1dc65871279de4c31867266da610675f4d619236421c567be7d3f5ebfe35a8";
  };

  "mingw-w64-i686-tesseract-data-khm" = fetch {
    name        = "mingw-w64-i686-tesseract-data-khm";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-khm-4.0.0-1-any.pkg.tar.xz";
    sha256      = "083295ff24219ac85072a8c09711f20dfc911d6a965ca9da28a9353c465cbd4f";
  };

  "mingw-w64-i686-tesseract-data-kir" = fetch {
    name        = "mingw-w64-i686-tesseract-data-kir";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-kir-4.0.0-1-any.pkg.tar.xz";
    sha256      = "cdffa9d630e7b1c36a902d6d2ad3b43e272fcdcd085cfbcb5c3569b706dd5b03";
  };

  "mingw-w64-i686-tesseract-data-kor" = fetch {
    name        = "mingw-w64-i686-tesseract-data-kor";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-kor-4.0.0-1-any.pkg.tar.xz";
    sha256      = "2f4cf3791036a006910b335010865df66a30b4fdabd1e1fd66a01aaa84d2671f";
  };

  "mingw-w64-i686-tesseract-data-kur" = fetch {
    name        = "mingw-w64-i686-tesseract-data-kur";
    version     = "3.04.00";
    filename    = "mingw-w64-i686-tesseract-data-kur-3.04.00-1-any.pkg.tar.xz";
    sha256      = "8590f531ce56b66f56edae4bf0c47744f31d822e1596208b947c0393cda437a3";
  };

  "mingw-w64-i686-tesseract-data-lao" = fetch {
    name        = "mingw-w64-i686-tesseract-data-lao";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-lao-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f4eecc3f0e1c9f614e6bdb958a7e39f259be27439e958aab6b8df241ba6dc4a7";
  };

  "mingw-w64-i686-tesseract-data-lat" = fetch {
    name        = "mingw-w64-i686-tesseract-data-lat";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-lat-4.0.0-1-any.pkg.tar.xz";
    sha256      = "b6020b4d58ecd4e826a443b7e656ded8cd00c71e1775537c17aeafeeeb70c8b1";
  };

  "mingw-w64-i686-tesseract-data-lav" = fetch {
    name        = "mingw-w64-i686-tesseract-data-lav";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-lav-4.0.0-1-any.pkg.tar.xz";
    sha256      = "57e1cd8abb1979f9cd0ee5053056fc781bfebdae20e31616c507fae7236a73d0";
  };

  "mingw-w64-i686-tesseract-data-lit" = fetch {
    name        = "mingw-w64-i686-tesseract-data-lit";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-lit-4.0.0-1-any.pkg.tar.xz";
    sha256      = "067c2bdbaf1c5501ab9a8bae7b93fb9f8ab2406d3114a3d0aeea0baa9f0c2637";
  };

  "mingw-w64-i686-tesseract-data-mal" = fetch {
    name        = "mingw-w64-i686-tesseract-data-mal";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-mal-4.0.0-1-any.pkg.tar.xz";
    sha256      = "e295bea2903eb983dcf5fedd91662662aee3da00ff429b5007e832feaa9ecd5d";
  };

  "mingw-w64-i686-tesseract-data-mar" = fetch {
    name        = "mingw-w64-i686-tesseract-data-mar";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-mar-4.0.0-1-any.pkg.tar.xz";
    sha256      = "8c8341a639a3fb9bffe3cba2958b3a8bd866a56bdd8271043352f8c2b3198cc9";
  };

  "mingw-w64-i686-tesseract-data-mkd" = fetch {
    name        = "mingw-w64-i686-tesseract-data-mkd";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-mkd-4.0.0-1-any.pkg.tar.xz";
    sha256      = "be6053a3ae68a7c0d248a930bfdcbcc4bb45ce0586c03e241b91e1b88465e6da";
  };

  "mingw-w64-i686-tesseract-data-mlt" = fetch {
    name        = "mingw-w64-i686-tesseract-data-mlt";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-mlt-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ff9541625e8e45a7047536d4984085bcbb7938e5902e47919260a04315ba54ec";
  };

  "mingw-w64-i686-tesseract-data-msa" = fetch {
    name        = "mingw-w64-i686-tesseract-data-msa";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-msa-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f7d273614dd057121f919ea8b056d378aaf9f0945b23f8a3f44a2c1513018665";
  };

  "mingw-w64-i686-tesseract-data-mya" = fetch {
    name        = "mingw-w64-i686-tesseract-data-mya";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-mya-4.0.0-1-any.pkg.tar.xz";
    sha256      = "d1d7a6a621eb24f4022e3c81804bd86cef266ac724d60f299f47071681207605";
  };

  "mingw-w64-i686-tesseract-data-nep" = fetch {
    name        = "mingw-w64-i686-tesseract-data-nep";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-nep-4.0.0-1-any.pkg.tar.xz";
    sha256      = "b579a2210e2618abdd8c3c9201fd7b6f32a9be14c76845ecf4f162800021a44d";
  };

  "mingw-w64-i686-tesseract-data-nld" = fetch {
    name        = "mingw-w64-i686-tesseract-data-nld";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-nld-4.0.0-1-any.pkg.tar.xz";
    sha256      = "78cd737ee98c8e96dab8891a9bcb2dac9a1b7f12677c8fb55e134e4113133906";
  };

  "mingw-w64-i686-tesseract-data-nor" = fetch {
    name        = "mingw-w64-i686-tesseract-data-nor";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-nor-4.0.0-1-any.pkg.tar.xz";
    sha256      = "525dc0a5b53aaa8170ea35a6cf2d63f4363b9ef2958a044b8e6d003728c3e5b1";
  };

  "mingw-w64-i686-tesseract-data-ori" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ori";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ori-4.0.0-1-any.pkg.tar.xz";
    sha256      = "4128cdbbd5aac8973097f5162e8abe2bcce2f6bbd191ecfce9d763d39be28504";
  };

  "mingw-w64-i686-tesseract-data-pan" = fetch {
    name        = "mingw-w64-i686-tesseract-data-pan";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-pan-4.0.0-1-any.pkg.tar.xz";
    sha256      = "222b0d3fab27e6e7a51a3a0ddc5df24d044c330f18d94707223afe3f3be9e237";
  };

  "mingw-w64-i686-tesseract-data-pol" = fetch {
    name        = "mingw-w64-i686-tesseract-data-pol";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-pol-4.0.0-1-any.pkg.tar.xz";
    sha256      = "601834120f2d927ed115ea413fe0c861d614a9cb17a0c2f074bbb705c840401d";
  };

  "mingw-w64-i686-tesseract-data-por" = fetch {
    name        = "mingw-w64-i686-tesseract-data-por";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-por-4.0.0-1-any.pkg.tar.xz";
    sha256      = "796e5de9c06fa5d8087289a91fbf4f1429289f7363fc617e9cd7257c2d8f660f";
  };

  "mingw-w64-i686-tesseract-data-pus" = fetch {
    name        = "mingw-w64-i686-tesseract-data-pus";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-pus-4.0.0-1-any.pkg.tar.xz";
    sha256      = "35a6d04e9448b0134b168726e7fd2ce8a7eb7d2994d6feb60eb036955aa8ed02";
  };

  "mingw-w64-i686-tesseract-data-ron" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ron";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ron-4.0.0-1-any.pkg.tar.xz";
    sha256      = "c411710e0dd4dfefb749fd108ec0761474e7c3258506bf5b5ba44422896e48ef";
  };

  "mingw-w64-i686-tesseract-data-rus" = fetch {
    name        = "mingw-w64-i686-tesseract-data-rus";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-rus-4.0.0-1-any.pkg.tar.xz";
    sha256      = "a91186977c9b099e103b2bb3624dc570b3daeb4d12ca892fa931ba299808a333";
  };

  "mingw-w64-i686-tesseract-data-san" = fetch {
    name        = "mingw-w64-i686-tesseract-data-san";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-san-4.0.0-1-any.pkg.tar.xz";
    sha256      = "12e3eee85f166dcf82b528eee49486f3c1617ca2f6b1f9db67b916e97ab24c13";
  };

  "mingw-w64-i686-tesseract-data-sin" = fetch {
    name        = "mingw-w64-i686-tesseract-data-sin";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-sin-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f4366c80f93438afac7166691840977fdf1dc6acb98f60d41b038cb6e57d37ad";
  };

  "mingw-w64-i686-tesseract-data-slk" = fetch {
    name        = "mingw-w64-i686-tesseract-data-slk";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-slk-4.0.0-1-any.pkg.tar.xz";
    sha256      = "0a0e166eb29d1db6fd61ac7e48cb36d32700920150033be1c5c456d21acf8a6a";
  };

  "mingw-w64-i686-tesseract-data-slk_frak" = fetch {
    name        = "mingw-w64-i686-tesseract-data-slk_frak";
    version     = "3.04.00";
    filename    = "mingw-w64-i686-tesseract-data-slk_frak-3.04.00-1-any.pkg.tar.xz";
    sha256      = "2685aaf7ce7062f3a89fdbcbc53c99a528c1f836e872b1cc789159ba0c18f047";
  };

  "mingw-w64-i686-tesseract-data-slv" = fetch {
    name        = "mingw-w64-i686-tesseract-data-slv";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-slv-4.0.0-1-any.pkg.tar.xz";
    sha256      = "6b2e2797898982a2f38d003ba04be84fc0f34e7adc5595eaab4bda6e0bf71af6";
  };

  "mingw-w64-i686-tesseract-data-spa" = fetch {
    name        = "mingw-w64-i686-tesseract-data-spa";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-spa-4.0.0-1-any.pkg.tar.xz";
    sha256      = "3b8023be3aa933f10f65c72de2b735b320d7f5776e63035857b14ff18accc50d";
  };

  "mingw-w64-i686-tesseract-data-spa_old" = fetch {
    name        = "mingw-w64-i686-tesseract-data-spa_old";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-spa_old-4.0.0-1-any.pkg.tar.xz";
    sha256      = "9f22e091e4dd86609851ffae3d8831fe87ace9cf25d635816c18a60dad3bcd76";
  };

  "mingw-w64-i686-tesseract-data-sqi" = fetch {
    name        = "mingw-w64-i686-tesseract-data-sqi";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-sqi-4.0.0-1-any.pkg.tar.xz";
    sha256      = "3534468433e7bda23e4f6f1a0ba56d8304a7cb3d77fb5cbce21d09b3fce9d3c5";
  };

  "mingw-w64-i686-tesseract-data-srp" = fetch {
    name        = "mingw-w64-i686-tesseract-data-srp";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-srp-4.0.0-1-any.pkg.tar.xz";
    sha256      = "7b8fa67bb7de20373ae344a41f24fc85358ec500efbfe93330e26ddb42213aac";
  };

  "mingw-w64-i686-tesseract-data-srp_latn" = fetch {
    name        = "mingw-w64-i686-tesseract-data-srp_latn";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-srp_latn-4.0.0-1-any.pkg.tar.xz";
    sha256      = "cec84e2273f2320399b377786f470c7cb7c770d5d75b62990a408d56e13b5c5e";
  };

  "mingw-w64-i686-tesseract-data-swa" = fetch {
    name        = "mingw-w64-i686-tesseract-data-swa";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-swa-4.0.0-1-any.pkg.tar.xz";
    sha256      = "bca9d9336d09d0f0e086c2c994608a987f209d6d420ecc30f3d32c31f2bff1db";
  };

  "mingw-w64-i686-tesseract-data-swe" = fetch {
    name        = "mingw-w64-i686-tesseract-data-swe";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-swe-4.0.0-1-any.pkg.tar.xz";
    sha256      = "10e62b2e423769019b304cffc7f10d1d2406ff4cccbd509af38bd09f36d395fe";
  };

  "mingw-w64-i686-tesseract-data-syr" = fetch {
    name        = "mingw-w64-i686-tesseract-data-syr";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-syr-4.0.0-1-any.pkg.tar.xz";
    sha256      = "39ff4f5671e00804465dccb06506f00b6d079617bd7ac4be8566311ef29dd441";
  };

  "mingw-w64-i686-tesseract-data-tam" = fetch {
    name        = "mingw-w64-i686-tesseract-data-tam";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-tam-4.0.0-1-any.pkg.tar.xz";
    sha256      = "2218ec2dda184fd92c4c617903000a4d080e85c0807bb5dd6fd83d9cb837dddc";
  };

  "mingw-w64-i686-tesseract-data-tel" = fetch {
    name        = "mingw-w64-i686-tesseract-data-tel";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-tel-4.0.0-1-any.pkg.tar.xz";
    sha256      = "5822d7cb3459329a4cf8d602dff2343ade7d2203b9ce6cdef26ac9c95707d552";
  };

  "mingw-w64-i686-tesseract-data-tgk" = fetch {
    name        = "mingw-w64-i686-tesseract-data-tgk";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-tgk-4.0.0-1-any.pkg.tar.xz";
    sha256      = "cd38e308e6572aa53c8df90cfda9503c400b39a899257025f652793f3a4e8a45";
  };

  "mingw-w64-i686-tesseract-data-tgl" = fetch {
    name        = "mingw-w64-i686-tesseract-data-tgl";
    version     = "3.04.00";
    filename    = "mingw-w64-i686-tesseract-data-tgl-3.04.00-1-any.pkg.tar.xz";
    sha256      = "f842bdd8ae986118c5e24a0c61fb128603ce65be61fa6a6ec23d56bd43736491";
  };

  "mingw-w64-i686-tesseract-data-tha" = fetch {
    name        = "mingw-w64-i686-tesseract-data-tha";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-tha-4.0.0-1-any.pkg.tar.xz";
    sha256      = "b0877d326d94987fbb3b9cf0f21fbb8c5e76e21f130bcc188fd7cf6b927d6e1a";
  };

  "mingw-w64-i686-tesseract-data-tir" = fetch {
    name        = "mingw-w64-i686-tesseract-data-tir";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-tir-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ce7c9034ebb87d183eef15238eae1e847d60e6ab244aebd9f70778c3ddc82859";
  };

  "mingw-w64-i686-tesseract-data-tur" = fetch {
    name        = "mingw-w64-i686-tesseract-data-tur";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-tur-4.0.0-1-any.pkg.tar.xz";
    sha256      = "6900130757f9dd88ad1f8da6110e50405471240def3244606df0b60bbc8b2b09";
  };

  "mingw-w64-i686-tesseract-data-uig" = fetch {
    name        = "mingw-w64-i686-tesseract-data-uig";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-uig-4.0.0-1-any.pkg.tar.xz";
    sha256      = "5c4931218fb2acfe18a5896d264ec2f592a212935efa6678f6668273b23381e2";
  };

  "mingw-w64-i686-tesseract-data-ukr" = fetch {
    name        = "mingw-w64-i686-tesseract-data-ukr";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-ukr-4.0.0-1-any.pkg.tar.xz";
    sha256      = "4fec3733fec88da1009e5d9e8b42f3d9d2c513ede0bed0a4da48df7c487c8846";
  };

  "mingw-w64-i686-tesseract-data-urd" = fetch {
    name        = "mingw-w64-i686-tesseract-data-urd";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-urd-4.0.0-1-any.pkg.tar.xz";
    sha256      = "57af610f98106ae0fab6a9fe675824790240fcd3108777fe3581b8cf2edc86b4";
  };

  "mingw-w64-i686-tesseract-data-uzb" = fetch {
    name        = "mingw-w64-i686-tesseract-data-uzb";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-uzb-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ad9d2dece6381ea3f79c3d0b33c9b206d674a6bb9f143d6794c7c14a52857683";
  };

  "mingw-w64-i686-tesseract-data-uzb_cyrl" = fetch {
    name        = "mingw-w64-i686-tesseract-data-uzb_cyrl";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-uzb_cyrl-4.0.0-1-any.pkg.tar.xz";
    sha256      = "0f17d36411edffc83986d743721492d836088bbf0367f9ed7fca8e6ad6208761";
  };

  "mingw-w64-i686-tesseract-data-vie" = fetch {
    name        = "mingw-w64-i686-tesseract-data-vie";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-vie-4.0.0-1-any.pkg.tar.xz";
    sha256      = "7b3c1a7188a86d497848e453089d032be474d358af86d9012ed22cd008c40fac";
  };

  "mingw-w64-i686-tesseract-data-yid" = fetch {
    name        = "mingw-w64-i686-tesseract-data-yid";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-data-yid-4.0.0-1-any.pkg.tar.xz";
    sha256      = "c50ca093706869a413d889d519acf293f1f579258989c35a32141fe0f246e885";
  };

  "mingw-w64-i686-tesseract-ocr" = fetch {
    name        = "mingw-w64-i686-tesseract-ocr";
    version     = "4.0.0";
    filename    = "mingw-w64-i686-tesseract-ocr-4.0.0-1-any.pkg.tar.xz";
    sha256      = "3eacbd5ec6a3917fbe2caeea41a3d47c1528f04eff9ec2d7b061cf5dda5617b0";
    buildInputs = [ mingw-w64-i686-cairo mingw-w64-i686-gcc-libs mingw-w64-i686-icu mingw-w64-i686-leptonica mingw-w64-i686-pango mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-threadweaver-qt5" = fetch {
    name        = "mingw-w64-i686-threadweaver-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-i686-threadweaver-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "da5e00c6e0f24b4d3526bf9bada235857af39d6d8579068d2de66124aeee1fc0";
    buildInputs = [ mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-thrift-git" = fetch {
    name        = "mingw-w64-i686-thrift-git";
    version     = "1.0.r5327.a92358054";
    filename    = "mingw-w64-i686-thrift-git-1.0.r5327.a92358054-1-any.pkg.tar.xz";
    sha256      = "2f7a41476bedb5852272d288390c940964624aafa3d521df12dfb1d5753c5d1d";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-boost mingw-w64-i686-openssl mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-tidy" = fetch {
    name        = "mingw-w64-i686-tidy";
    version     = "5.7.16";
    filename    = "mingw-w64-i686-tidy-5.7.16-1-any.pkg.tar.xz";
    sha256      = "2cc9ca62fc5457890dcdcb3e2aa768f19d665e51a9851e1d59d68df7af5f9267";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-tiny-dnn" = fetch {
    name        = "mingw-w64-i686-tiny-dnn";
    version     = "1.0.0a3";
    filename    = "mingw-w64-i686-tiny-dnn-1.0.0a3-2-any.pkg.tar.xz";
    sha256      = "6e88077371f7febc7643d00ace3f8c2c7843bf9f847a9bacf084e644ad88e29d";
    buildInputs = [ mingw-w64-i686-intel-tbb mingw-w64-i686-protobuf ];
  };

  "mingw-w64-i686-tinyformat" = fetch {
    name        = "mingw-w64-i686-tinyformat";
    version     = "2.1.0";
    filename    = "mingw-w64-i686-tinyformat-2.1.0-1-any.pkg.tar.xz";
    sha256      = "8ca4f665608fb55152f1377806ae445e43ff09eec3f29e2956896a2e6478b888";
  };

  "mingw-w64-i686-tinyxml" = fetch {
    name        = "mingw-w64-i686-tinyxml";
    version     = "2.6.2";
    filename    = "mingw-w64-i686-tinyxml-2.6.2-4-any.pkg.tar.xz";
    sha256      = "14f67ae4e9790dcc55bd0fca5e5605d16a246ad8940659cea5fd3ef13d71d5ac";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-tinyxml2" = fetch {
    name        = "mingw-w64-i686-tinyxml2";
    version     = "7.0.1";
    filename    = "mingw-w64-i686-tinyxml2-7.0.1-1-any.pkg.tar.xz";
    sha256      = "be427d8219b5a63d239ab8f9aea49531ac2d1dae8651824dbc2e519388f148fe";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-tk" = fetch {
    name        = "mingw-w64-i686-tk";
    version     = "8.6.9.1";
    filename    = "mingw-w64-i686-tk-8.6.9.1-1-any.pkg.tar.xz";
    sha256      = "846b90c5cceb12089dfbf8710f4e42a9de03c11681febd3833270ad9ed81a0fe";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mingw-w64-i686-tcl.version "8.6.9"; mingw-w64-i686-tcl) ];
  };

  "mingw-w64-i686-tkimg" = fetch {
    name        = "mingw-w64-i686-tkimg";
    version     = "1.4.2";
    filename    = "mingw-w64-i686-tkimg-1.4.2-3-any.pkg.tar.xz";
    sha256      = "b627534c2a9ffd7ea3d5dfa65532a6e1e60f7784aef10e74e659686e386600b8";
    buildInputs = [ mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-tk mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-tkimg -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-tklib" = fetch {
    name        = "mingw-w64-i686-tklib";
    version     = "0.6";
    filename    = "mingw-w64-i686-tklib-0.6-5-any.pkg.tar.xz";
    sha256      = "e650b2c23254d465b3caa2a3fc42c54335e3571ba07051cffb9caaa6ab3ac8ac";
    buildInputs = [ mingw-w64-i686-tk mingw-w64-i686-tcllib ];
  };

  "mingw-w64-i686-tktable" = fetch {
    name        = "mingw-w64-i686-tktable";
    version     = "2.10";
    filename    = "mingw-w64-i686-tktable-2.10-4-any.pkg.tar.xz";
    sha256      = "79ea5a3c7aad0573fec1d3eaeddec2de26804877f10a13ec24080d97d8235689";
    buildInputs = [ mingw-w64-i686-tk ];
  };

  "mingw-w64-i686-tolua" = fetch {
    name        = "mingw-w64-i686-tolua";
    version     = "5.2.4";
    filename    = "mingw-w64-i686-tolua-5.2.4-3-any.pkg.tar.xz";
    sha256      = "21d88b751613ff353acbbd68bcdae258aa672ced0504487c4046a8131f874b28";
    buildInputs = [ mingw-w64-i686-lua ];
  };

  "mingw-w64-i686-tools-git" = fetch {
    name        = "mingw-w64-i686-tools-git";
    version     = "7.0.0.5272.d66350ea";
    filename    = "mingw-w64-i686-tools-git-7.0.0.5272.d66350ea-1-any.pkg.tar.xz";
    sha256      = "704f8c3edac6ca93d199c1363ba02923c717d4d9ccc49f3d10c43752de40734e";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-tor" = fetch {
    name        = "mingw-w64-i686-tor";
    version     = "0.3.3.6";
    filename    = "mingw-w64-i686-tor-0.3.3.6-1-any.pkg.tar.xz";
    sha256      = "2ade4ceb161ad15b4a7709d1f00df2ec01689393d5aecb9ce12bd911da99f98a";
    buildInputs = [ mingw-w64-i686-libevent mingw-w64-i686-openssl mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-totem-pl-parser" = fetch {
    name        = "mingw-w64-i686-totem-pl-parser";
    version     = "3.26.1";
    filename    = "mingw-w64-i686-totem-pl-parser-3.26.1-1-any.pkg.tar.xz";
    sha256      = "17408fc7a4aa457d58e63afed9707d3e53308af0f96e304b42e2a6dc8519806e";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-gmime mingw-w64-i686-libsoup mingw-w64-i686-libarchive mingw-w64-i686-libgcrypt ];
  };

  "mingw-w64-i686-transmission" = fetch {
    name        = "mingw-w64-i686-transmission";
    version     = "2.94";
    filename    = "mingw-w64-i686-transmission-2.94-2-any.pkg.tar.xz";
    sha256      = "c0504657594244a4266cde46b24406afe9d42c635266a2d67eee1888f153fa3f";
    buildInputs = [ mingw-w64-i686-openssl mingw-w64-i686-libevent mingw-w64-i686-gtk3 mingw-w64-i686-curl mingw-w64-i686-zlib mingw-w64-i686-miniupnpc ];
  };

  "mingw-w64-i686-trompeloeil" = fetch {
    name        = "mingw-w64-i686-trompeloeil";
    version     = "31";
    filename    = "mingw-w64-i686-trompeloeil-31-1-any.pkg.tar.xz";
    sha256      = "5eb1f0303fba53c74c7a1653daa07c1e94b89410cb39b7db94d4369de3f39af5";
  };

  "mingw-w64-i686-ttf-dejavu" = fetch {
    name        = "mingw-w64-i686-ttf-dejavu";
    version     = "2.37";
    filename    = "mingw-w64-i686-ttf-dejavu-2.37-1-any.pkg.tar.xz";
    sha256      = "bcc4fd261cf2b2aee572c8c78b0810b84c31f1ef921d0daed6f3c10d6315cf54";
    buildInputs = [ mingw-w64-i686-fontconfig ];
  };

  "mingw-w64-i686-tulip" = fetch {
    name        = "mingw-w64-i686-tulip";
    version     = "5.2.1";
    filename    = "mingw-w64-i686-tulip-5.2.1-1-any.pkg.tar.xz";
    sha256      = "f17f9433c719d7556acfba6ba0d70959197588f4985712bdc453e98c5e5d658c";
    buildInputs = [ mingw-w64-i686-freetype mingw-w64-i686-glew mingw-w64-i686-libpng mingw-w64-i686-libjpeg mingw-w64-i686-python3 mingw-w64-i686-qhull-git mingw-w64-i686-qt5 mingw-w64-i686-qtwebkit mingw-w64-i686-quazip mingw-w64-i686-yajl ];
    broken      = true; # broken dependency mingw-w64-i686-tulip -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-twolame" = fetch {
    name        = "mingw-w64-i686-twolame";
    version     = "0.3.13";
    filename    = "mingw-w64-i686-twolame-0.3.13-3-any.pkg.tar.xz";
    sha256      = "ee3a820b3875f0ca93b6ec2e05ca49e1d3476f4254eeceb5acee5c17cd958aff";
    buildInputs = [ mingw-w64-i686-libsndfile ];
  };

  "mingw-w64-i686-uchardet" = fetch {
    name        = "mingw-w64-i686-uchardet";
    version     = "0.0.6";
    filename    = "mingw-w64-i686-uchardet-0.0.6-1-any.pkg.tar.xz";
    sha256      = "0e278dcd7b31e38449cf70db2ab6974ab2b1cac5fc3fad7ecfadcd23aae0b46e";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-ucl" = fetch {
    name        = "mingw-w64-i686-ucl";
    version     = "1.03";
    filename    = "mingw-w64-i686-ucl-1.03-1-any.pkg.tar.xz";
    sha256      = "d584dbadcc761eb53712d439d1dde59d0e9a1192bc7f4b3f6486022996e6be6e";
  };

  "mingw-w64-i686-udis86" = fetch {
    name        = "mingw-w64-i686-udis86";
    version     = "1.7.2";
    filename    = "mingw-w64-i686-udis86-1.7.2-1-any.pkg.tar.xz";
    sha256      = "dfa19f3797455b5406cedcae0fad1a8bb67eab4754cbc231a0216e6016eaccb0";
    buildInputs = [ mingw-w64-i686-python2 ];
  };

  "mingw-w64-i686-uhttpmock" = fetch {
    name        = "mingw-w64-i686-uhttpmock";
    version     = "0.5.1";
    filename    = "mingw-w64-i686-uhttpmock-0.5.1-1-any.pkg.tar.xz";
    sha256      = "f601ee99e831cc5c95fb473a0cc4dc9f02ebc0526eaa8c7f5afac6645e9ae3ef";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-libsoup ];
  };

  "mingw-w64-i686-unbound" = fetch {
    name        = "mingw-w64-i686-unbound";
    version     = "1.8.3";
    filename    = "mingw-w64-i686-unbound-1.8.3-1-any.pkg.tar.xz";
    sha256      = "4b9da0812a5d8e63273d14fbb18e6651a9845563721e7fa274595d04024c2b94";
    buildInputs = [ mingw-w64-i686-openssl mingw-w64-i686-expat mingw-w64-i686-ldns ];
  };

  "mingw-w64-i686-unibilium" = fetch {
    name        = "mingw-w64-i686-unibilium";
    version     = "2.0.0";
    filename    = "mingw-w64-i686-unibilium-2.0.0-1-any.pkg.tar.xz";
    sha256      = "9f011509e68f0a9013d023865c69e76cd2607c287560773e9089530359d2e08d";
  };

  "mingw-w64-i686-unicorn" = fetch {
    name        = "mingw-w64-i686-unicorn";
    version     = "1.0.1";
    filename    = "mingw-w64-i686-unicorn-1.0.1-3-any.pkg.tar.xz";
    sha256      = "3787d2c770336b6cc6bcb783ded9cf088799aa2f03e925eba5a6720fd1857b51";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-universal-ctags-git" = fetch {
    name        = "mingw-w64-i686-universal-ctags-git";
    version     = "r6369.5728abe4";
    filename    = "mingw-w64-i686-universal-ctags-git-r6369.5728abe4-1-any.pkg.tar.xz";
    sha256      = "94ffb8c80447e895dae49cbfc93caeb5ebad0ec6f0c6154b88657fffbda24213";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-jansson mingw-w64-i686-libiconv mingw-w64-i686-libxml2 mingw-w64-i686-libyaml ];
  };

  "mingw-w64-i686-unixodbc" = fetch {
    name        = "mingw-w64-i686-unixodbc";
    version     = "2.3.7";
    filename    = "mingw-w64-i686-unixodbc-2.3.7-1-any.pkg.tar.xz";
    sha256      = "763d4dcfc184b3b391fe2c35336c5c4dd975ec767f57d92c107542eec94f49b4";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-readline mingw-w64-i686-libtool ];
  };

  "mingw-w64-i686-uriparser" = fetch {
    name        = "mingw-w64-i686-uriparser";
    version     = "0.9.1";
    filename    = "mingw-w64-i686-uriparser-0.9.1-1-any.pkg.tar.xz";
    sha256      = "b5a81b69327210101c0690a1f9a24773ef272ac8bd9f26857ca99daab54060e7";
  };

  "mingw-w64-i686-usbredir" = fetch {
    name        = "mingw-w64-i686-usbredir";
    version     = "0.8.0";
    filename    = "mingw-w64-i686-usbredir-0.8.0-1-any.pkg.tar.xz";
    sha256      = "66ac7d2b7fc39c6cd9f8e5506839bf320398fcaa40dd70ebce4b5cac99af962f";
    buildInputs = [ mingw-w64-i686-libusb ];
  };

  "mingw-w64-i686-usbview-git" = fetch {
    name        = "mingw-w64-i686-usbview-git";
    version     = "42.c4ba9c6";
    filename    = "mingw-w64-i686-usbview-git-42.c4ba9c6-1-any.pkg.tar.xz";
    sha256      = "160ca679d083ad407f45d672b94a26fd8ffcdf37d30a3d288310f79888d3b79b";
  };

  "mingw-w64-i686-usql" = fetch {
    name        = "mingw-w64-i686-usql";
    version     = "0.8.1";
    filename    = "mingw-w64-i686-usql-0.8.1-1-any.pkg.tar.xz";
    sha256      = "7ae7a0623d92cdbd1e53984aaf50f9d46e63982c94550de4fc10ae3b7dd85d85";
    buildInputs = [ mingw-w64-i686-antlr3 ];
  };

  "mingw-w64-i686-usrsctp" = fetch {
    name        = "mingw-w64-i686-usrsctp";
    version     = "0.9.3.0";
    filename    = "mingw-w64-i686-usrsctp-0.9.3.0-1-any.pkg.tar.xz";
    sha256      = "50c5634cacc28197f6ff48005921ca4c11facb64559d0c74528796426d5b5247";
  };

  "mingw-w64-i686-vala" = fetch {
    name        = "mingw-w64-i686-vala";
    version     = "0.42.4";
    filename    = "mingw-w64-i686-vala-0.42.4-1-any.pkg.tar.xz";
    sha256      = "c4cd42f75eca3fcf9dfa2858e300aefeab97cd8880b6341e5dbaa72f8002f5af";
    buildInputs = [ mingw-w64-i686-glib2 mingw-w64-i686-graphviz ];
    broken      = true; # broken dependency mingw-w64-i686-libgd -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-vamp-plugin-sdk" = fetch {
    name        = "mingw-w64-i686-vamp-plugin-sdk";
    version     = "2.7.1";
    filename    = "mingw-w64-i686-vamp-plugin-sdk-2.7.1-1-any.pkg.tar.xz";
    sha256      = "4946d284509c1d76de0648f7f944008f91432c09f9ff1500d02b8e4300722883";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-libsndfile ];
  };

  "mingw-w64-i686-vapoursynth" = fetch {
    name        = "mingw-w64-i686-vapoursynth";
    version     = "45.1";
    filename    = "mingw-w64-i686-vapoursynth-45.1-1-any.pkg.tar.xz";
    sha256      = "e4e45b59dd056a6623b9e65b80a22e822ad48b21209cd1cbe5177afeebe0f915";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-cython mingw-w64-i686-ffmpeg mingw-w64-i686-imagemagick mingw-w64-i686-libass mingw-w64-i686-libxml2 mingw-w64-i686-python3 mingw-w64-i686-tesseract-ocr mingw-w64-i686-zimg ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-vcdimager" = fetch {
    name        = "mingw-w64-i686-vcdimager";
    version     = "2.0.1";
    filename    = "mingw-w64-i686-vcdimager-2.0.1-1-any.pkg.tar.xz";
    sha256      = "54febeb2464d5069b8dfebe08b69a78a8ac6982c35b2670f6d2efddf846eeda4";
    buildInputs = [ mingw-w64-i686-libcdio mingw-w64-i686-libxml2 mingw-w64-i686-popt ];
  };

  "mingw-w64-i686-verilator" = fetch {
    name        = "mingw-w64-i686-verilator";
    version     = "4.004";
    filename    = "mingw-w64-i686-verilator-4.004-1-any.pkg.tar.xz";
    sha256      = "80d888ab0b869adff53ff172118cb7dee897032e0f9a58eaa18877b042089b7d";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-vid.stab" = fetch {
    name        = "mingw-w64-i686-vid.stab";
    version     = "1.1";
    filename    = "mingw-w64-i686-vid.stab-1.1-1-any.pkg.tar.xz";
    sha256      = "d81e34cb8bd3cc391e43cf9daed05660dff316827850f30d7f3b9e08850d480b";
  };

  "mingw-w64-i686-vigra" = fetch {
    name        = "mingw-w64-i686-vigra";
    version     = "1.11.1";
    filename    = "mingw-w64-i686-vigra-1.11.1-2-any.pkg.tar.xz";
    sha256      = "6620671a0d8a2b751fb4bf719a9afb8bc53067b0844d4e7706afb192e4f9772a";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-boost mingw-w64-i686-fftw mingw-w64-i686-hdf5 mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-openexr mingw-w64-i686-python2-numpy mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-virt-viewer" = fetch {
    name        = "mingw-w64-i686-virt-viewer";
    version     = "7.0";
    filename    = "mingw-w64-i686-virt-viewer-7.0-1-any.pkg.tar.xz";
    sha256      = "0fa1b91ac29b5559c72e98b34b56a9a433e7457a2c022e7ea8b839ccb627431d";
    buildInputs = [ mingw-w64-i686-spice-gtk mingw-w64-i686-gtk-vnc mingw-w64-i686-libxml2 mingw-w64-i686-opus ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-vlc" = fetch {
    name        = "mingw-w64-i686-vlc";
    version     = "3.0.5";
    filename    = "mingw-w64-i686-vlc-3.0.5-1-any.pkg.tar.xz";
    sha256      = "e00d7f156256a313bce7c7d37b24164ef0cbb1ed931cb97a0810f0cb96907d64";
    buildInputs = [ mingw-w64-i686-a52dec mingw-w64-i686-aribb24 mingw-w64-i686-chromaprint mingw-w64-i686-faad2 mingw-w64-i686-ffmpeg mingw-w64-i686-flac mingw-w64-i686-fluidsynth mingw-w64-i686-fribidi mingw-w64-i686-gnutls mingw-w64-i686-gsm mingw-w64-i686-libass mingw-w64-i686-libbluray mingw-w64-i686-libcaca mingw-w64-i686-libcddb mingw-w64-i686-libcdio mingw-w64-i686-libdca mingw-w64-i686-libdsm mingw-w64-i686-libdvdcss mingw-w64-i686-libdvdnav mingw-w64-i686-libdvbpsi mingw-w64-i686-libgme mingw-w64-i686-libgoom2 mingw-w64-i686-libmad mingw-w64-i686-libmatroska mingw-w64-i686-libmicrodns mingw-w64-i686-libmpcdec mingw-w64-i686-libmpeg2-git mingw-w64-i686-libmysofa mingw-w64-i686-libnfs mingw-w64-i686-libplacebo mingw-w64-i686-libproxy mingw-w64-i686-librsvg mingw-w64-i686-libsamplerate mingw-w64-i686-libshout mingw-w64-i686-libssh2 mingw-w64-i686-libtheora mingw-w64-i686-libvpx mingw-w64-i686-libxml2 mingw-w64-i686-lua51 mingw-w64-i686-opencv mingw-w64-i686-opus mingw-w64-i686-portaudio mingw-w64-i686-protobuf mingw-w64-i686-pupnp mingw-w64-i686-schroedinger mingw-w64-i686-speex mingw-w64-i686-srt mingw-w64-i686-taglib mingw-w64-i686-twolame mingw-w64-i686-vcdimager mingw-w64-i686-x264-git mingw-w64-i686-x265 mingw-w64-i686-xpm-nox mingw-w64-i686-qt5 ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-vlfeat" = fetch {
    name        = "mingw-w64-i686-vlfeat";
    version     = "0.9.21";
    filename    = "mingw-w64-i686-vlfeat-0.9.21-1-any.pkg.tar.xz";
    sha256      = "7b5539b8e9b6a9f91ca942ce3c378c2a255c1f2d63d58952dcb8a6b8f5477b22";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-vo-amrwbenc" = fetch {
    name        = "mingw-w64-i686-vo-amrwbenc";
    version     = "0.1.3";
    filename    = "mingw-w64-i686-vo-amrwbenc-0.1.3-1-any.pkg.tar.xz";
    sha256      = "b7eeb05009156701809860e0eb22f4627e5fe4cace45323d1a5efdac3168bf57";
  };

  "mingw-w64-i686-vrpn" = fetch {
    name        = "mingw-w64-i686-vrpn";
    version     = "7.34";
    filename    = "mingw-w64-i686-vrpn-7.34-3-any.pkg.tar.xz";
    sha256      = "e6760ea42f30730ef1f5c6c745e330ef7787cd4aed432b9ba93f41ef9c625d8a";
    buildInputs = [ mingw-w64-i686-hidapi mingw-w64-i686-jsoncpp mingw-w64-i686-libusb mingw-w64-i686-python3 mingw-w64-i686-swig ];
  };

  "mingw-w64-i686-vtk" = fetch {
    name        = "mingw-w64-i686-vtk";
    version     = "8.1.2";
    filename    = "mingw-w64-i686-vtk-8.1.2-1-any.pkg.tar.xz";
    sha256      = "1e41441dae5e32fe87b670ba9a2e57e478b1eafcac1cae7204ca2837ed547807";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-expat mingw-w64-i686-ffmpeg mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-hdf5 mingw-w64-i686-intel-tbb mingw-w64-i686-jsoncpp mingw-w64-i686-libjpeg mingw-w64-i686-libharu mingw-w64-i686-libpng mingw-w64-i686-libogg mingw-w64-i686-libtheora mingw-w64-i686-libtiff mingw-w64-i686-libxml2 mingw-w64-i686-lz4 mingw-w64-i686-qt5 mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-SDL2 -> mingw-w64-i686-vulkan
  };

  "mingw-w64-i686-vulkan-headers" = fetch {
    name        = "mingw-w64-i686-vulkan-headers";
    version     = "1.1.92";
    filename    = "mingw-w64-i686-vulkan-headers-1.1.92-1-any.pkg.tar.xz";
    sha256      = "e403ac8754342c36e5ec08fd3ce25cce45e82c7b17f1700267b1827bfaba58fd";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-vulkan-loader" = fetch {
    name        = "mingw-w64-i686-vulkan-loader";
    version     = "1.1.92";
    filename    = "mingw-w64-i686-vulkan-loader-1.1.92-1-any.pkg.tar.xz";
    sha256      = "052cd9cf1b613842d7d23a0392c3cc1738a97fb310976e5541b00a04d56b9adf";
    buildInputs = [ mingw-w64-i686-vulkan-headers ];
  };

  "mingw-w64-i686-waf" = fetch {
    name        = "mingw-w64-i686-waf";
    version     = "2.0.12";
    filename    = "mingw-w64-i686-waf-2.0.12-1-any.pkg.tar.xz";
    sha256      = "19f78ccf82210550ef5d1341da7280a4b1233d980749fa5e511c64501dbc211c";
    buildInputs = [ mingw-w64-i686-python3 ];
  };

  "mingw-w64-i686-wavpack" = fetch {
    name        = "mingw-w64-i686-wavpack";
    version     = "5.1.0";
    filename    = "mingw-w64-i686-wavpack-5.1.0-1-any.pkg.tar.xz";
    sha256      = "25320de952b33987c604d768dc8729b211617f37f72b4e4e2994f01b4ac843e6";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-webkitgtk2" = fetch {
    name        = "mingw-w64-i686-webkitgtk2";
    version     = "2.4.11";
    filename    = "mingw-w64-i686-webkitgtk2-2.4.11-6-any.pkg.tar.xz";
    sha256      = "630d927abde41345396a8bcdb82340fc56d23a1af537d18f627cb84ac7ea1a2d";
    buildInputs = [ mingw-w64-i686-angleproject-git mingw-w64-i686-cairo mingw-w64-i686-enchant mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-glib2 mingw-w64-i686-gst-plugins-base mingw-w64-i686-gstreamer mingw-w64-i686-geoclue mingw-w64-i686-harfbuzz mingw-w64-i686-icu mingw-w64-i686-libidn mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libsoup mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-libwebp mingw-w64-i686-pango mingw-w64-i686-sqlite3 mingw-w64-i686-xz mingw-w64-i686-gtk2 ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-webkitgtk3" = fetch {
    name        = "mingw-w64-i686-webkitgtk3";
    version     = "2.4.11";
    filename    = "mingw-w64-i686-webkitgtk3-2.4.11-6-any.pkg.tar.xz";
    sha256      = "a318811e44cfa40568d879741e0711786de0610aea87fa999ee252c982da85b6";
    buildInputs = [ mingw-w64-i686-angleproject-git mingw-w64-i686-cairo mingw-w64-i686-enchant mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-glib2 mingw-w64-i686-gst-plugins-base mingw-w64-i686-gstreamer mingw-w64-i686-geoclue mingw-w64-i686-harfbuzz mingw-w64-i686-icu mingw-w64-i686-libidn mingw-w64-i686-libjpeg mingw-w64-i686-libpng mingw-w64-i686-libsoup mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-libwebp mingw-w64-i686-pango mingw-w64-i686-sqlite3 mingw-w64-i686-xz mingw-w64-i686-gtk3 ];
    broken      = true; # broken dependency mingw-w64-i686-gst-plugins-base -> mingw-w64-i686-libvorbisidec
  };

  "mingw-w64-i686-wget" = fetch {
    name        = "mingw-w64-i686-wget";
    version     = "1.20.1";
    filename    = "mingw-w64-i686-wget-1.20.1-1-any.pkg.tar.xz";
    sha256      = "b1c92413c5704ce4cf1b9979fccebd32c41ad29019f6ca2dc7707af488141498";
    buildInputs = [ mingw-w64-i686-pcre2 mingw-w64-i686-libidn2 mingw-w64-i686-openssl mingw-w64-i686-c-ares mingw-w64-i686-gpgme ];
  };

  "mingw-w64-i686-win7appid" = fetch {
    name        = "mingw-w64-i686-win7appid";
    version     = "1.1";
    filename    = "mingw-w64-i686-win7appid-1.1-3-any.pkg.tar.xz";
    sha256      = "f6305255a17f74993e47fca885a950c26f11aa6b864bb772eb755c668dcaf72d";
  };

  "mingw-w64-i686-windows-default-manifest" = fetch {
    name        = "mingw-w64-i686-windows-default-manifest";
    version     = "6.4";
    filename    = "mingw-w64-i686-windows-default-manifest-6.4-3-any.pkg.tar.xz";
    sha256      = "56323bc39c7de0ff727915c09c4aaa25b8396efc0d7eda0006d5951bb6a6b983";
    buildInputs = [  ];
  };

  "mingw-w64-i686-wined3d" = fetch {
    name        = "mingw-w64-i686-wined3d";
    version     = "3.8";
    filename    = "mingw-w64-i686-wined3d-3.8-1-any.pkg.tar.xz";
    sha256      = "26be5d3589012a5e71ea97758d83d62918ad2547a4a7a7b10d0fec722df11c9e";
  };

  "mingw-w64-i686-wineditline" = fetch {
    name        = "mingw-w64-i686-wineditline";
    version     = "2.205";
    filename    = "mingw-w64-i686-wineditline-2.205-1-any.pkg.tar.xz";
    sha256      = "41af7321b85c1fe5c53413d8ec6d03cf466ff34750e92c64088ee45ca02f1c4e";
    buildInputs = [  ];
  };

  "mingw-w64-i686-winico" = fetch {
    name        = "mingw-w64-i686-winico";
    version     = "0.6";
    filename    = "mingw-w64-i686-winico-0.6-2-any.pkg.tar.xz";
    sha256      = "27e2b286fdd9604f923277428beb833a3d7c48cd45abc11a0aa1d9ac7694c49c";
    buildInputs = [ mingw-w64-i686-tk ];
  };

  "mingw-w64-i686-winpthreads-git" = fetch {
    name        = "mingw-w64-i686-winpthreads-git";
    version     = "7.0.0.5273.3e5acf5d";
    filename    = "mingw-w64-i686-winpthreads-git-7.0.0.5273.3e5acf5d-1-any.pkg.tar.xz";
    sha256      = "760d7dcd964d1543c28d6026e704621804c80f85fe969615ba36cc524ad2414b";
    buildInputs = [ mingw-w64-i686-crt-git (assert mingw-w64-i686-libwinpthread-git.version=="7.0.0.5273.3e5acf5d"; mingw-w64-i686-libwinpthread-git) ];
  };

  "mingw-w64-i686-winsparkle" = fetch {
    name        = "mingw-w64-i686-winsparkle";
    version     = "0.5.2";
    filename    = "mingw-w64-i686-winsparkle-0.5.2-1-any.pkg.tar.xz";
    sha256      = "62af31dc2b47d6f05f3afe52b586957b19faa233ad3708e8c7d4393d422e5378";
    buildInputs = [ mingw-w64-i686-expat mingw-w64-i686-wxWidgets ];
  };

  "mingw-w64-i686-winstorecompat-git" = fetch {
    name        = "mingw-w64-i686-winstorecompat-git";
    version     = "7.0.0.5230.69c8fad6";
    filename    = "mingw-w64-i686-winstorecompat-git-7.0.0.5230.69c8fad6-1-any.pkg.tar.xz";
    sha256      = "d9e629a2cf0008d8052fa1b4e1449bf56d75ab70f34603964f802545fe5317ae";
  };

  "mingw-w64-i686-wintab-sdk" = fetch {
    name        = "mingw-w64-i686-wintab-sdk";
    version     = "1.4";
    filename    = "mingw-w64-i686-wintab-sdk-1.4-2-any.pkg.tar.xz";
    sha256      = "8425c5de8fda04d236bd6b452c495eb1fecd92e3b826123c8dffa7bc3c2830e5";
  };

  "mingw-w64-i686-wkhtmltopdf-git" = fetch {
    name        = "mingw-w64-i686-wkhtmltopdf-git";
    version     = "0.13.r1049.51f9658";
    filename    = "mingw-w64-i686-wkhtmltopdf-git-0.13.r1049.51f9658-1-any.pkg.tar.xz";
    sha256      = "8742f92ff41dd38be606f7019ca3ef4d1ac4e7d9ead0aaa00d1ac89214f50b42";
    buildInputs = [ mingw-w64-i686-qt5 mingw-w64-i686-qtwebkit ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-woff2" = fetch {
    name        = "mingw-w64-i686-woff2";
    version     = "1.0.2";
    filename    = "mingw-w64-i686-woff2-1.0.2-1-any.pkg.tar.xz";
    sha256      = "729d47eb94e2747bc39596c69a15826809799574ca9e6f0ad0ca0c1a64db5a7e";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-brotli ];
  };

  "mingw-w64-i686-wslay" = fetch {
    name        = "mingw-w64-i686-wslay";
    version     = "1.1.0";
    filename    = "mingw-w64-i686-wslay-1.1.0-1-any.pkg.tar.xz";
    sha256      = "cf268ab0e4438d54221f8c3b43f9636498c7d0c2e32be2b527211585c65815c9";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-wxPython" = fetch {
    name        = "mingw-w64-i686-wxPython";
    version     = "3.0.2.0";
    filename    = "mingw-w64-i686-wxPython-3.0.2.0-8-any.pkg.tar.xz";
    sha256      = "83b0404b520738c1acf9100d3fac3148efc5de8bdedaba8bd5317f56786becba";
    buildInputs = [ mingw-w64-i686-python2 mingw-w64-i686-wxWidgets ];
  };

  "mingw-w64-i686-wxWidgets" = fetch {
    name        = "mingw-w64-i686-wxWidgets";
    version     = "3.0.4";
    filename    = "mingw-w64-i686-wxWidgets-3.0.4-2-any.pkg.tar.xz";
    sha256      = "30b9e673546fa1441073f71fcdd7cb2a4b5b2567cd50aceae7975cf21a1e1c88";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-expat mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-xz mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-x264-git" = fetch {
    name        = "mingw-w64-i686-x264-git";
    version     = "r2901.7d0ff22e";
    filename    = "mingw-w64-i686-x264-git-r2901.7d0ff22e-1-any.pkg.tar.xz";
    sha256      = "9a3b5e3696cc07dffb989288b923739df925104011eeae85cc08e889a55fd5ac";
    buildInputs = [ mingw-w64-i686-libwinpthread-git mingw-w64-i686-l-smash ];
  };

  "mingw-w64-i686-x265" = fetch {
    name        = "mingw-w64-i686-x265";
    version     = "2.9";
    filename    = "mingw-w64-i686-x265-2.9-1-any.pkg.tar.xz";
    sha256      = "be64b7af6e0840c2fa1300990b096771fb5ade1d41a317fd35cced83c695535d";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-xalan-c" = fetch {
    name        = "mingw-w64-i686-xalan-c";
    version     = "1.11";
    filename    = "mingw-w64-i686-xalan-c-1.11-7-any.pkg.tar.xz";
    sha256      = "7c5932a5445882e173fc3fd25aded507bddeb92142877b4a3fa83847b18585fb";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-xerces-c ];
  };

  "mingw-w64-i686-xapian-core" = fetch {
    name        = "mingw-w64-i686-xapian-core";
    version     = "1~1.4.9";
    filename    = "mingw-w64-i686-xapian-core-1~1.4.9-1-any.pkg.tar.xz";
    sha256      = "30e2afbe56926adf848397b965cf81862a7e243e2e239a43ba7a6941da9021c6";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-zlib ];
  };

  "mingw-w64-i686-xavs" = fetch {
    name        = "mingw-w64-i686-xavs";
    version     = "0.1.55";
    filename    = "mingw-w64-i686-xavs-0.1.55-1-any.pkg.tar.xz";
    sha256      = "f770ddfda505ee16f7cebe2c8adcbd43570cbd948daaffe0bc37407229060d35";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-xerces-c" = fetch {
    name        = "mingw-w64-i686-xerces-c";
    version     = "3.2.2";
    filename    = "mingw-w64-i686-xerces-c-3.2.2-1-any.pkg.tar.xz";
    sha256      = "3116718f174d75e7c6896e55149bb36cd3e41f498ef6a1dfd019811a533fa1dc";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-icu ];
  };

  "mingw-w64-i686-xlnt" = fetch {
    name        = "mingw-w64-i686-xlnt";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-xlnt-1.3.0-1-any.pkg.tar.xz";
    sha256      = "640dfdb139efc4d89f557cf71104287c0c7bfe6e0fbc77d2265152f47890f2e8";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-xmlsec" = fetch {
    name        = "mingw-w64-i686-xmlsec";
    version     = "1.2.27";
    filename    = "mingw-w64-i686-xmlsec-1.2.27-1-any.pkg.tar.xz";
    sha256      = "c15a02dc5732e73792e8f59be24844a3b3e95b8ab1284d003b945aecf908e008";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-libxslt mingw-w64-i686-openssl mingw-w64-i686-gnutls ];
  };

  "mingw-w64-i686-xmlstarlet-git" = fetch {
    name        = "mingw-w64-i686-xmlstarlet-git";
    version     = "r678.9a470e3";
    filename    = "mingw-w64-i686-xmlstarlet-git-r678.9a470e3-2-any.pkg.tar.xz";
    sha256      = "988e39273bd2e2ffe46e9e7feb4abe2aa711be77744220e86b4547c4fd42f0a9";
    buildInputs = [ mingw-w64-i686-libxml2 mingw-w64-i686-libxslt ];
  };

  "mingw-w64-i686-xpdf" = fetch {
    name        = "mingw-w64-i686-xpdf";
    version     = "4.00";
    filename    = "mingw-w64-i686-xpdf-4.00-1-any.pkg.tar.xz";
    sha256      = "e7d2526ff8d55e1904eca29f96d8d5a98943da56a73efa46a170dd8cef81f141";
    buildInputs = [ mingw-w64-i686-freetype mingw-w64-i686-libjpeg-turbo mingw-w64-i686-libpaper mingw-w64-i686-libpng mingw-w64-i686-libtiff mingw-w64-i686-qt5 mingw-w64-i686-zlib ];
    broken      = true; # broken dependency mingw-w64-i686-assimp -> mingw-w64-i686-minizip
  };

  "mingw-w64-i686-xpm-nox" = fetch {
    name        = "mingw-w64-i686-xpm-nox";
    version     = "4.2.0";
    filename    = "mingw-w64-i686-xpm-nox-4.2.0-5-any.pkg.tar.xz";
    sha256      = "28c5a3b200cbc3db6e3e2ebc3a9c953d43c80ede2a6d8a21ad1db5b7da3a2a01";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-xvidcore" = fetch {
    name        = "mingw-w64-i686-xvidcore";
    version     = "1.3.5";
    filename    = "mingw-w64-i686-xvidcore-1.3.5-1-any.pkg.tar.xz";
    sha256      = "fe6f47c5eebad75a1523951fda87453b45f35c9eb5105418e565b99cd9264be0";
  };

  "mingw-w64-i686-xxhash" = fetch {
    name        = "mingw-w64-i686-xxhash";
    version     = "0.6.5";
    filename    = "mingw-w64-i686-xxhash-0.6.5-1-any.pkg.tar.xz";
    sha256      = "bc6656a794c2747fb193ddf21c748ce0c3045abc36c80f99c1ad6535e4c65956";
  };

  "mingw-w64-i686-xz" = fetch {
    name        = "mingw-w64-i686-xz";
    version     = "5.2.4";
    filename    = "mingw-w64-i686-xz-5.2.4-1-any.pkg.tar.xz";
    sha256      = "da238fc44727076823b56898337bef2a5187dc97d58de1d2750e75dc2723cedb";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-yajl" = fetch {
    name        = "mingw-w64-i686-yajl";
    version     = "2.1.0";
    filename    = "mingw-w64-i686-yajl-2.1.0-1-any.pkg.tar.xz";
    sha256      = "4a368dc6bcc3cb8632ae51d2d427f644d03cd9bd1a13f12ebe283ef833191d64";
  };

  "mingw-w64-i686-yaml-cpp" = fetch {
    name        = "mingw-w64-i686-yaml-cpp";
    version     = "0.6.2";
    filename    = "mingw-w64-i686-yaml-cpp-0.6.2-1-any.pkg.tar.xz";
    sha256      = "9ac5ef18705d75a87f0fd6a73c265d536b34df4f205feb3a4dd3ee619c462c84";
    buildInputs = [  ];
  };

  "mingw-w64-i686-yaml-cpp0.3" = fetch {
    name        = "mingw-w64-i686-yaml-cpp0.3";
    version     = "0.3.0";
    filename    = "mingw-w64-i686-yaml-cpp0.3-0.3.0-2-any.pkg.tar.xz";
    sha256      = "778a22a9bdaf40133a50551ff1c9a20f383a954423a5b22e47cdd7d38ca874db";
  };

  "mingw-w64-i686-yarn" = fetch {
    name        = "mingw-w64-i686-yarn";
    version     = "1.13.0";
    filename    = "mingw-w64-i686-yarn-1.13.0-1-any.pkg.tar.xz";
    sha256      = "47949ecc013a4a3c55093d2725160cbdee4912c6d9c5707db9b2cf0ec22fc822";
    buildInputs = [ mingw-w64-i686-nodejs ];
  };

  "mingw-w64-i686-yasm" = fetch {
    name        = "mingw-w64-i686-yasm";
    version     = "1.3.0";
    filename    = "mingw-w64-i686-yasm-1.3.0-3-any.pkg.tar.xz";
    sha256      = "e82a2442129df51e404ae5abc4cf6ec5ba075f40cf5e32bfb0cc1e4823b0e963";
    buildInputs = [ mingw-w64-i686-gettext ];
  };

  "mingw-w64-i686-z3" = fetch {
    name        = "mingw-w64-i686-z3";
    version     = "4.8.4";
    filename    = "mingw-w64-i686-z3-4.8.4-1-any.pkg.tar.xz";
    sha256      = "24c2b46e9c0280a91de7eaac85da926b6b5613fd92d241a177cf1f8c050815f5";
    buildInputs = [  ];
  };

  "mingw-w64-i686-zbar" = fetch {
    name        = "mingw-w64-i686-zbar";
    version     = "0.20";
    filename    = "mingw-w64-i686-zbar-0.20-1-any.pkg.tar.xz";
    sha256      = "73d874034ec47898553059ac74d6640820110945bec04268a18ec3990039f9a5";
    buildInputs = [ mingw-w64-i686-imagemagick ];
    broken      = true; # broken dependency mingw-w64-i686-djvulibre -> mingw-w64-i686-libjpeg
  };

  "mingw-w64-i686-zeromq" = fetch {
    name        = "mingw-w64-i686-zeromq";
    version     = "4.3.0";
    filename    = "mingw-w64-i686-zeromq-4.3.0-1-any.pkg.tar.xz";
    sha256      = "34b39ef85250d2f75925f6d631e38606c718c8aa924fd966ab2242b3ebee3564";
    buildInputs = [ mingw-w64-i686-libsodium ];
  };

  "mingw-w64-i686-zimg" = fetch {
    name        = "mingw-w64-i686-zimg";
    version     = "2.8";
    filename    = "mingw-w64-i686-zimg-2.8-2-any.pkg.tar.xz";
    sha256      = "2629c741ca6d53cec8f3423c79ee1d22427ce9fe5603044d4d8be2835f9a4405";
    buildInputs = [ mingw-w64-i686-gcc-libs mingw-w64-i686-winpthreads-git ];
  };

  "mingw-w64-i686-zlib" = fetch {
    name        = "mingw-w64-i686-zlib";
    version     = "1.2.11";
    filename    = "mingw-w64-i686-zlib-1.2.11-5-any.pkg.tar.xz";
    sha256      = "4c718bcb6a1f6b7a7c30792ae5a141f3b9996c20a6eabb2926af7319789c864e";
    buildInputs = [ mingw-w64-i686-bzip2 ];
  };

  "mingw-w64-i686-zopfli" = fetch {
    name        = "mingw-w64-i686-zopfli";
    version     = "1.0.2";
    filename    = "mingw-w64-i686-zopfli-1.0.2-2-any.pkg.tar.xz";
    sha256      = "1571e1309e1cebed7c76b323e6da99e616381c745c2b67ff9d27e8076a706569";
    buildInputs = [ mingw-w64-i686-gcc-libs ];
  };

  "mingw-w64-i686-zstd" = fetch {
    name        = "mingw-w64-i686-zstd";
    version     = "1.3.8";
    filename    = "mingw-w64-i686-zstd-1.3.8-1-any.pkg.tar.xz";
    sha256      = "9225c044362a722d27174830c0309c9ca5a20341d8ef062adbe6793fe2771adb";
    buildInputs = [  ];
  };

  "mingw-w64-i686-zziplib" = fetch {
    name        = "mingw-w64-i686-zziplib";
    version     = "0.13.69";
    filename    = "mingw-w64-i686-zziplib-0.13.69-1-any.pkg.tar.xz";
    sha256      = "03c2d76db1e25af6c079f7d32452cd061f286d93deed3ad4d79ccae1d6ebc7a7";
    buildInputs = [ mingw-w64-i686-zlib ];
  };

}; in self
