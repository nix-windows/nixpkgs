 # GENERATED FILE
{stdenvNoCC, fetchurl, mingwPackages, msysPackages}:

let
  fetch = { pname, version, srcs, buildInputs ? [], broken ? false }:
    if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
      stdenvNoCC.mkDerivation {
        inherit version buildInputs;
        name = "${pname}-${version}";
        srcs = map ({filename, sha256}:
                    fetchurl {
                      url = "http://repo.msys2.org/mingw/i686/${filename}";
                      inherit sha256;
                    }) srcs;
        PATH = stdenvNoCC.lib.concatMapStringsSep ";" (x: "${x}\\bin") stdenvNoCC.initialPath; # it adds 7z.exe to PATH
        builder = stdenvNoCC.lib.concatStringsSep " & " ( assert (builtins.length srcs == 1);
                                                          [ ''echo PATH=%PATH%''
                                                            ''7z x %srcs% -so  |  7z x -aoa -si -ttar -o%out%''
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
      inherit version buildInputs;
      name = "${pname}-${version}";
      srcs = map ({filename, sha256}:
                  fetchurl {
                    url = "http://repo.msys2.org/mingw/i686/${filename}";
                    inherit sha256;
                  }) srcs;
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
  libjpeg = libjpeg-turbo;
  minizip = minizip2;
  vulkan = vulkan-loader;
  bash = msysPackages.bash;
  winpty = msysPackages.winpty;

  "3proxy" = fetch {
    pname       = "3proxy";
    version     = "0.8.12";
    srcs        = [{ filename = "mingw-w64-i686-3proxy-0.8.12-1-any.pkg.tar.xz"; sha256 = "c52347418b7e88351a352534df79ef44badeb2afcac4fd1a4496c2de8625d29b"; }];
  };

  "4th" = fetch {
    pname       = "4th";
    version     = "3.62.5";
    srcs        = [{ filename = "mingw-w64-i686-4th-3.62.5-1-any.pkg.tar.xz"; sha256 = "ca5f028d55ba7b17df2aa8578c5fde29111f2f6484860467733ebe57e895ceda"; }];
  };

  "MinHook" = fetch {
    pname       = "MinHook";
    version     = "1.3.3";
    srcs        = [{ filename = "mingw-w64-i686-MinHook-1.3.3-1-any.pkg.tar.xz"; sha256 = "1d3bdd393ca9a6e7ad1d777dd6b665110ad28fe134f3ca43c4f10de5afc4a844"; }];
  };

  "OpenSceneGraph" = fetch {
    pname       = "OpenSceneGraph";
    version     = "3.6.3";
    srcs        = [{ filename = "mingw-w64-i686-OpenSceneGraph-3.6.3-3-any.pkg.tar.xz"; sha256 = "bcf522ed5c4f85c31a7d5bf41cd911d7c09c26544fbff8acd3ae33a2b7cf638f"; }];
    buildInputs = [ angleproject-git boost collada-dom-svn curl ffmpeg fltk freetype gcc-libs gdal giflib gstreamer gtk2 gtkglext jasper libjpeg libpng libtiff libvncserver libxml2 lua SDL SDL2 poppler python3 wxWidgets zlib ];
  };

  "OpenSceneGraph-debug" = fetch {
    pname       = "OpenSceneGraph-debug";
    version     = "3.6.3";
    srcs        = [{ filename = "mingw-w64-i686-OpenSceneGraph-debug-3.6.3-3-any.pkg.tar.xz"; sha256 = "fb2ab7c2b0b2ea382ea5934d7094b92acee0379bf087ed80a266aa6a58f683c6"; }];
    buildInputs = [ (assert OpenSceneGraph.version=="3.6.3"; OpenSceneGraph) ];
  };

  "SDL" = fetch {
    pname       = "SDL";
    version     = "1.2.15";
    srcs        = [{ filename = "mingw-w64-i686-SDL-1.2.15-8-any.pkg.tar.xz"; sha256 = "8ad9ec75014a2fe529f639b67e5bcc5277b0fd6adc4946b3965f7cc5be3f6470"; }];
    buildInputs = [ gcc-libs libiconv ];
  };

  "SDL2" = fetch {
    pname       = "SDL2";
    version     = "2.0.9";
    srcs        = [{ filename = "mingw-w64-i686-SDL2-2.0.9-1-any.pkg.tar.xz"; sha256 = "e8512f5d7ccc13ad06d8930aa20deb3119587d15b6a99065b706cbf0573a47e0"; }];
    buildInputs = [ gcc-libs libiconv vulkan ];
  };

  "SDL2_gfx" = fetch {
    pname       = "SDL2_gfx";
    version     = "1.0.4";
    srcs        = [{ filename = "mingw-w64-i686-SDL2_gfx-1.0.4-1-any.pkg.tar.xz"; sha256 = "41aa14e123af35c87ccf95e6ea8337233da4995fe89bd53851e6a863a188259a"; }];
    buildInputs = [ SDL2 ];
  };

  "SDL2_image" = fetch {
    pname       = "SDL2_image";
    version     = "2.0.4";
    srcs        = [{ filename = "mingw-w64-i686-SDL2_image-2.0.4-1-any.pkg.tar.xz"; sha256 = "0c9f055e08032e995444e6a6502160c25d7a822905fdbccf0fa783c2a7dbd235"; }];
    buildInputs = [ SDL2 libpng libtiff libjpeg-turbo libwebp ];
  };

  "SDL2_mixer" = fetch {
    pname       = "SDL2_mixer";
    version     = "2.0.4";
    srcs        = [{ filename = "mingw-w64-i686-SDL2_mixer-2.0.4-1-any.pkg.tar.xz"; sha256 = "2689f5d03227b4ad65dda669dd72a83559db6deefdd34ef119f05c00cf31abdf"; }];
    buildInputs = [ gcc-libs SDL2 flac fluidsynth libvorbis libmodplug mpg123 opusfile ];
  };

  "SDL2_net" = fetch {
    pname       = "SDL2_net";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-i686-SDL2_net-2.0.1-1-any.pkg.tar.xz"; sha256 = "4dc37d68ddaf1a1fb33da8613e226df2adb5aef207c2bf4f7a2e89038aaddc4b"; }];
    buildInputs = [ gcc-libs SDL2 ];
  };

  "SDL2_ttf" = fetch {
    pname       = "SDL2_ttf";
    version     = "2.0.14";
    srcs        = [{ filename = "mingw-w64-i686-SDL2_ttf-2.0.14-1-any.pkg.tar.xz"; sha256 = "08ea6ef36545b9b99fd43023a922845c07b67fa9beb6359138f46839d16394b3"; }];
    buildInputs = [ SDL2 freetype ];
  };

  "SDL_gfx" = fetch {
    pname       = "SDL_gfx";
    version     = "2.0.26";
    srcs        = [{ filename = "mingw-w64-i686-SDL_gfx-2.0.26-1-any.pkg.tar.xz"; sha256 = "84048cd1d619843f24a7006a6663cfaef8d7c136eea02b68ddf81ad8d099df14"; }];
    buildInputs = [ SDL ];
  };

  "SDL_image" = fetch {
    pname       = "SDL_image";
    version     = "1.2.12";
    srcs        = [{ filename = "mingw-w64-i686-SDL_image-1.2.12-6-any.pkg.tar.xz"; sha256 = "c6a5a6bd56cea1cfeb81c101fdc057626a38a0af577f7eaf09fe6577cf0fd39e"; }];
    buildInputs = [ SDL libjpeg-turbo libpng libtiff libwebp zlib ];
  };

  "SDL_mixer" = fetch {
    pname       = "SDL_mixer";
    version     = "1.2.12";
    srcs        = [{ filename = "mingw-w64-i686-SDL_mixer-1.2.12-6-any.pkg.tar.xz"; sha256 = "713a32a690bb5bdd5215bc4b9e59706849d46264e9b8220278da3d3019f1229a"; }];
    buildInputs = [ SDL libvorbis libmikmod libmad flac ];
  };

  "SDL_net" = fetch {
    pname       = "SDL_net";
    version     = "1.2.8";
    srcs        = [{ filename = "mingw-w64-i686-SDL_net-1.2.8-2-any.pkg.tar.xz"; sha256 = "3968125e2bd1882b30027280ec56c1eae7c3e2c93535e4afc48f98ef9b45a4fc"; }];
    buildInputs = [ SDL ];
  };

  "SDL_ttf" = fetch {
    pname       = "SDL_ttf";
    version     = "2.0.11";
    srcs        = [{ filename = "mingw-w64-i686-SDL_ttf-2.0.11-5-any.pkg.tar.xz"; sha256 = "9a2b1c5d12107f9786a44c7a2ad26355d661f9c42c2969e1b05437ac286c3361"; }];
    buildInputs = [ SDL freetype ];
  };

  "a52dec" = fetch {
    pname       = "a52dec";
    version     = "0.7.4";
    srcs        = [{ filename = "mingw-w64-i686-a52dec-0.7.4-4-any.pkg.tar.xz"; sha256 = "d73c4eb92801c9069c2a40ebbe48464042dde401cd71c4788fec914937c742d0"; }];
  };

  "adns" = fetch {
    pname       = "adns";
    version     = "1.4.g10.7";
    srcs        = [{ filename = "mingw-w64-i686-adns-1.4.g10.7-1-any.pkg.tar.xz"; sha256 = "a16b45a41c850cf6ada155b7bdaa795438b3da60b15f65a3777712b816c8a8d0"; }];
    buildInputs = [ gcc-libs ];
  };

  "adwaita-icon-theme" = fetch {
    pname       = "adwaita-icon-theme";
    version     = "3.30.1";
    srcs        = [{ filename = "mingw-w64-i686-adwaita-icon-theme-3.30.1-1-any.pkg.tar.xz"; sha256 = "c8d46320740ffdbcb6e5805de15ed929408adcc02781988c1d26aef040309daf"; }];
    buildInputs = [ hicolor-icon-theme librsvg ];
  };

  "ag" = fetch {
    pname       = "ag";
    version     = "2.1.0.r1975.d83e205";
    srcs        = [{ filename = "mingw-w64-i686-ag-2.1.0.r1975.d83e205-1-any.pkg.tar.xz"; sha256 = "873c53dcd29125d98833bc454f356ea03b4aef7c9bdd06639c2fa29e50f110c7"; }];
    buildInputs = [ pcre xz zlib ];
  };

  "alembic" = fetch {
    pname       = "alembic";
    version     = "1.7.10";
    srcs        = [{ filename = "mingw-w64-i686-alembic-1.7.10-1-any.pkg.tar.xz"; sha256 = "999d626f1c03b7842af12336ff47930eb9b6bd638f93c51f29651d918a6ab81c"; }];
    buildInputs = [ openexr boost hdf5 zlib ];
  };

  "allegro" = fetch {
    pname       = "allegro";
    version     = "5.2.4";
    srcs        = [{ filename = "mingw-w64-i686-allegro-5.2.4-2-any.pkg.tar.xz"; sha256 = "c4acbbf5936e9bb518a5a449516f4fcd71e4373c7fba945e869361660ca59d2e"; }];
    buildInputs = [ gcc-libs ];
  };

  "alure" = fetch {
    pname       = "alure";
    version     = "1.2";
    srcs        = [{ filename = "mingw-w64-i686-alure-1.2-1-any.pkg.tar.xz"; sha256 = "16899b9c9642c51fd8c745695a843adee88f1c3024b71f95be8fe10b5266283b"; }];
    buildInputs = [ openal ];
  };

  "amtk" = fetch {
    pname       = "amtk";
    version     = "5.0.0";
    srcs        = [{ filename = "mingw-w64-i686-amtk-5.0.0-1-any.pkg.tar.xz"; sha256 = "958814ca43ba487f6f3427e6a834b39e73abd4d6a785a319743044da96e688b2"; }];
    buildInputs = [ gtk3 ];
  };

  "angleproject-git" = fetch {
    pname       = "angleproject-git";
    version     = "2.1.r8842";
    srcs        = [{ filename = "mingw-w64-i686-angleproject-git-2.1.r8842-1-any.pkg.tar.xz"; sha256 = "bf2f9c6df1bfc97eb9c0a06956325f95675784ae55ae87021f4c7ff08e135d2c"; }];
    buildInputs = [  ];
  };

  "ansicon-git" = fetch {
    pname       = "ansicon-git";
    version     = "1.70.r65.3acc7a9";
    srcs        = [{ filename = "mingw-w64-i686-ansicon-git-1.70.r65.3acc7a9-2-any.pkg.tar.xz"; sha256 = "9de19536afa7968807150b96dc3c7104e7315db0938a695034288ee3cfe82bfb"; }];
  };

  "antiword" = fetch {
    pname       = "antiword";
    version     = "0.37";
    srcs        = [{ filename = "mingw-w64-i686-antiword-0.37-2-any.pkg.tar.xz"; sha256 = "b8dfcf3dde2a65d62941dacaad3cdc49c6f9ca4080144118c9d46207022d39b1"; }];
  };

  "antlr3" = fetch {
    pname       = "antlr3";
    version     = "3.5.2";
    srcs        = [{ filename = "mingw-w64-i686-antlr3-3.5.2-1-any.pkg.tar.xz"; sha256 = "6ba14d0882f7e2f241fe02945126545103ec53eea452c73226bc600afbef618e"; }];
  };

  "antlr4-runtime-cpp" = fetch {
    pname       = "antlr4-runtime-cpp";
    version     = "4.7.1";
    srcs        = [{ filename = "mingw-w64-i686-antlr4-runtime-cpp-4.7.1-1-any.pkg.tar.xz"; sha256 = "a2ac881e4e4721fae4415e288e245c9615384cca1ba532f388cca5fc4d564fcf"; }];
  };

  "aom" = fetch {
    pname       = "aom";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-i686-aom-1.0.0-1-any.pkg.tar.xz"; sha256 = "771697a9aac997c7cca457cf94152128508107e571a2412d6bfdb6fb6a2e62e0"; }];
    buildInputs = [ gcc-libs ];
  };

  "apr" = fetch {
    pname       = "apr";
    version     = "1.6.5";
    srcs        = [{ filename = "mingw-w64-i686-apr-1.6.5-1-any.pkg.tar.xz"; sha256 = "9d7e35df629448874ee8c40f327153b07c21b7a9414c64c6fdb0d65f040b827a"; }];
  };

  "apr-util" = fetch {
    pname       = "apr-util";
    version     = "1.6.1";
    srcs        = [{ filename = "mingw-w64-i686-apr-util-1.6.1-1-any.pkg.tar.xz"; sha256 = "3b12b43e93d89b718398cf5e7d3923ce488a1c126445240760567108cf41239b"; }];
    buildInputs = [ apr expat sqlite3 ];
  };

  "argon2" = fetch {
    pname       = "argon2";
    version     = "20171227";
    srcs        = [{ filename = "mingw-w64-i686-argon2-20171227-3-any.pkg.tar.xz"; sha256 = "9fc14b8b72f8a2292d10eeb1e1d4732dc233b90932cea5ebfe5f533679714cf4"; }];
  };

  "aria2" = fetch {
    pname       = "aria2";
    version     = "1.34.0";
    srcs        = [{ filename = "mingw-w64-i686-aria2-1.34.0-2-any.pkg.tar.xz"; sha256 = "85dfff3f7610dd21ec1395ac289b7cb8d43de04f32224b4886347bc197e68612"; }];
    buildInputs = [ gcc-libs gettext c-ares cppunit libiconv libssh2 libuv libxml2 openssl sqlite3 zlib ];
  };

  "aribb24" = fetch {
    pname       = "aribb24";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-i686-aribb24-1.0.3-3-any.pkg.tar.xz"; sha256 = "aeb49b3ff7aeb13193344f2ba6966e9b0c295a1f8337063c3616e9d5dee7d14f"; }];
    buildInputs = [ libpng ];
  };

  "armadillo" = fetch {
    pname       = "armadillo";
    version     = "9.200.6";
    srcs        = [{ filename = "mingw-w64-i686-armadillo-9.200.6-1-any.pkg.tar.xz"; sha256 = "4d21615cf30e0ab1496e4092d51bfb375adc54c9fc42190670c76bb6747d46a8"; }];
    buildInputs = [ gcc-libs arpack openblas ];
  };

  "arpack" = fetch {
    pname       = "arpack";
    version     = "3.6.3";
    srcs        = [{ filename = "mingw-w64-i686-arpack-3.6.3-1-any.pkg.tar.xz"; sha256 = "eb3d9c39a55e8f8a3e1d06ba28cb3fb388debb92d74775d56b16a1a645220afc"; }];
    buildInputs = [ gcc-libgfortran openblas ];
  };

  "arrow" = fetch {
    pname       = "arrow";
    version     = "0.11.1";
    srcs        = [{ filename = "mingw-w64-i686-arrow-0.11.1-1-any.pkg.tar.xz"; sha256 = "2085215f4e585e44bfe9ee4cd4c17a1ffca6d085ab841cd008d9f9565f1ec786"; }];
    buildInputs = [ boost brotli flatbuffers gobject-introspection lz4 protobuf python3-numpy snappy zlib zstd ];
  };

  "asciidoctor" = fetch {
    pname       = "asciidoctor";
    version     = "1.5.8";
    srcs        = [{ filename = "mingw-w64-i686-asciidoctor-1.5.8-1-any.pkg.tar.xz"; sha256 = "a7097858c8f722f234cb7946637a98ce0e3accb2e9c8cc6a7b75e8fe5ead69de"; }];
    buildInputs = [ ruby ];
  };

  "aspell" = fetch {
    pname       = "aspell";
    version     = "0.60.7.rc1";
    srcs        = [{ filename = "mingw-w64-i686-aspell-0.60.7.rc1-1-any.pkg.tar.xz"; sha256 = "59ed9512dbc9703d74e947373eeeabc8d61a358121a38dfddf02b29a34d2985d"; }];
    buildInputs = [ gcc-libs libiconv gettext ];
  };

  "aspell-de" = fetch {
    pname       = "aspell-de";
    version     = "20161207";
    srcs        = [{ filename = "mingw-w64-i686-aspell-de-20161207-1-any.pkg.tar.xz"; sha256 = "20b45394e95953183d71a8eadc0a97331033b8acd3d3c9143be4286210479439"; }];
    buildInputs = [ aspell ];
  };

  "aspell-en" = fetch {
    pname       = "aspell-en";
    version     = "2018.04.16";
    srcs        = [{ filename = "mingw-w64-i686-aspell-en-2018.04.16-1-any.pkg.tar.xz"; sha256 = "a746cc6638796f5a0a9cebe9935bad508837579563b417a2fe1411f0bf2f5b2c"; }];
    buildInputs = [ aspell ];
  };

  "aspell-es" = fetch {
    pname       = "aspell-es";
    version     = "1.11.2";
    srcs        = [{ filename = "mingw-w64-i686-aspell-es-1.11.2-1-any.pkg.tar.xz"; sha256 = "1ec62c48a35657fff3a54795a4b5b2d1d6b9e52e0ee30c0894ef49b1a524d724"; }];
    buildInputs = [ aspell ];
  };

  "aspell-fr" = fetch {
    pname       = "aspell-fr";
    version     = "0.50.3";
    srcs        = [{ filename = "mingw-w64-i686-aspell-fr-0.50.3-1-any.pkg.tar.xz"; sha256 = "73bd4b0a651f153ae5877d5455c5d08755b4c467f052c756e4c17a18b4300b1a"; }];
    buildInputs = [ aspell ];
  };

  "aspell-ru" = fetch {
    pname       = "aspell-ru";
    version     = "0.99f7.1";
    srcs        = [{ filename = "mingw-w64-i686-aspell-ru-0.99f7.1-1-any.pkg.tar.xz"; sha256 = "b847731c943babba48f940448198a46fbeb830d13d4dd4a31d1ed4c4458dca79"; }];
    buildInputs = [ aspell ];
  };

  "assimp" = fetch {
    pname       = "assimp";
    version     = "4.1.0";
    srcs        = [{ filename = "mingw-w64-i686-assimp-4.1.0-2-any.pkg.tar.xz"; sha256 = "cdf5495417fcf10bf01b44e2005fc0407c271c514a7287dc6b3dc311ee688909"; }];
    buildInputs = [ minizip zziplib zlib ];
  };

  "astyle" = fetch {
    pname       = "astyle";
    version     = "3.1";
    srcs        = [{ filename = "mingw-w64-i686-astyle-3.1-1-any.pkg.tar.xz"; sha256 = "83639f9828d919c89148ff88bb12b29a57ba3815b3e74202e1096186898f357a"; }];
    buildInputs = [ gcc-libs ];
  };

  "atk" = fetch {
    pname       = "atk";
    version     = "2.30.0";
    srcs        = [{ filename = "mingw-w64-i686-atk-2.30.0-1-any.pkg.tar.xz"; sha256 = "8c7d1f4ecaf6832d90277d6bbbffa4a249c44f0cf907aac00b98ba64d655357e"; }];
    buildInputs = [ gcc-libs (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.46.0"; glib2) ];
  };

  "atkmm" = fetch {
    pname       = "atkmm";
    version     = "2.28.0";
    srcs        = [{ filename = "mingw-w64-i686-atkmm-2.28.0-1-any.pkg.tar.xz"; sha256 = "d9bf262b7541261b75f04575c15c5ce46ae6a27fbc879504d67798a4a209e2b3"; }];
    buildInputs = [ atk gcc-libs glibmm self."libsigc++" ];
  };

  "attica-qt5" = fetch {
    pname       = "attica-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-attica-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "38c9e3d448273422799e409a4854edb6d8333b4feae337281eba1bd2f9fa81c9"; }];
    buildInputs = [ qt5 ];
  };

  "avrdude" = fetch {
    pname       = "avrdude";
    version     = "6.3";
    srcs        = [{ filename = "mingw-w64-i686-avrdude-6.3-2-any.pkg.tar.xz"; sha256 = "67d63a0fc6e4434ffc413b2c07fdcc289501ee77c4d33c7525b603c5c3e8db6b"; }];
    buildInputs = [ libftdi libusb libusb-compat-git libelf ];
  };

  "aztecgen" = fetch {
    pname       = "aztecgen";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-aztecgen-1.0.1-1-any.pkg.tar.xz"; sha256 = "6eab6ec81927b8efe391727de9fef738b22eb102c222d91e7d91179cf7677acc"; }];
  };

  "babl" = fetch {
    pname       = "babl";
    version     = "0.1.60";
    srcs        = [{ filename = "mingw-w64-i686-babl-0.1.60-1-any.pkg.tar.xz"; sha256 = "cf78f2a0861281c80935536c0c2bee69110be2e1d976850bffe91f46b57bf7a7"; }];
    buildInputs = [ gcc-libs ];
  };

  "badvpn" = fetch {
    pname       = "badvpn";
    version     = "1.999.130";
    srcs        = [{ filename = "mingw-w64-i686-badvpn-1.999.130-2-any.pkg.tar.xz"; sha256 = "d65842dbf8483d1e4db63ec697b940bd7bf027801d5b482f328dfa087c8ec658"; }];
    buildInputs = [ glib2 nspr nss openssl ];
  };

  "bcunit" = fetch {
    pname       = "bcunit";
    version     = "3.0.2";
    srcs        = [{ filename = "mingw-w64-i686-bcunit-3.0.2-1-any.pkg.tar.xz"; sha256 = "a3271a76a26f9485d34c6dd280da3cf977948a243ff699671ac7157c66d3d21c"; }];
  };

  "benchmark" = fetch {
    pname       = "benchmark";
    version     = "1.4.1";
    srcs        = [{ filename = "mingw-w64-i686-benchmark-1.4.1-1-any.pkg.tar.xz"; sha256 = "02c75aab15b9a3f44c6286d8fb325465a791544f974b8a1afa92d336a185d508"; }];
    buildInputs = [ gcc-libs ];
  };

  "binaryen" = fetch {
    pname       = "binaryen";
    version     = "55";
    srcs        = [{ filename = "mingw-w64-i686-binaryen-55-1-any.pkg.tar.xz"; sha256 = "d413efb5f753fe6d830136ad4db7c87e1c26e4a2b1c30d69fdace0cbf85e0c60"; }];
  };

  "binutils" = fetch {
    pname       = "binutils";
    version     = "2.30";
    srcs        = [{ filename = "mingw-w64-i686-binutils-2.30-5-any.pkg.tar.xz"; sha256 = "e674a1bc62ceb9cb62b84191123c3c2a630ed883bcfeaa3757d1cb48b7ea8c9d"; }];
    buildInputs = [ libiconv zlib ];
  };

  "blender" = fetch {
    pname       = "blender";
    version     = "2.79.b";
    srcs        = [{ filename = "mingw-w64-i686-blender-2.79.b-6-any.pkg.tar.xz"; sha256 = "c8d913f94e336482cc81a59ddd5a322c12ae8b880259e3f9d2b2f61cf6a2f97c"; }];
    buildInputs = [ boost llvm eigen3 glew ffmpeg fftw freetype libpng libsndfile libtiff lzo2 openexr openal opencollada-git opencolorio-git openimageio openshadinglanguage pugixml python3 python3-numpy SDL2 wintab-sdk ];
    broken      = true; # broken dependency openimageio -> LibRaw
  };

  "blosc" = fetch {
    pname       = "blosc";
    version     = "1.15.1";
    srcs        = [{ filename = "mingw-w64-i686-blosc-1.15.1-1-any.pkg.tar.xz"; sha256 = "2a8b32e343d604f17730256a893a1ade27ddfe2f4b262521cb39ceaccb007607"; }];
    buildInputs = [ snappy zstd zlib lz4 ];
  };

  "boost" = fetch {
    pname       = "boost";
    version     = "1.69.0";
    srcs        = [{ filename = "mingw-w64-i686-boost-1.69.0-2-any.pkg.tar.xz"; sha256 = "5486ddf969b304cff308beb5541ae76757ab445a433fc8249a76f94626b93bff"; }];
    buildInputs = [ gcc-libs bzip2 icu zlib ];
  };

  "bower" = fetch {
    pname       = "bower";
    version     = "1.8.4";
    srcs        = [{ filename = "mingw-w64-i686-bower-1.8.4-1-any.pkg.tar.xz"; sha256 = "7d30a94b588cda4e960c2ca471c052ada82e294d7643b98a912362e103561c47"; }];
    buildInputs = [ nodejs ];
  };

  "box2d" = fetch {
    pname       = "box2d";
    version     = "2.3.1";
    srcs        = [{ filename = "mingw-w64-i686-box2d-2.3.1-2-any.pkg.tar.xz"; sha256 = "f2e11ecf0d9438121c880d83b2dd21a4a7d5538081befabf4ccb58a2fe06ed13"; }];
  };

  "breakpad-git" = fetch {
    pname       = "breakpad-git";
    version     = "r1680.70914b2d";
    srcs        = [{ filename = "mingw-w64-i686-breakpad-git-r1680.70914b2d-1-any.pkg.tar.xz"; sha256 = "d0e1988e2268bfa036a56164d57e496b5a30660b69b7deca9dac25861d5c9be3"; }];
    buildInputs = [ gcc-libs ];
  };

  "breeze-icons-qt5" = fetch {
    pname       = "breeze-icons-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-breeze-icons-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "6d70fc0809d2cc68d5debd25e13f6bb519bb3bdbcb94429cf694859d6085209b"; }];
    buildInputs = [ qt5 ];
  };

  "brotli" = fetch {
    pname       = "brotli";
    version     = "1.0.7";
    srcs        = [{ filename = "mingw-w64-i686-brotli-1.0.7-1-any.pkg.tar.xz"; sha256 = "96c843fe9fa3315d57abbf7de59ac1dadbcbda9945f0b6ffff293e4c1f06dc89"; }];
    buildInputs = [  ];
  };

  "brotli-testdata" = fetch {
    pname       = "brotli-testdata";
    version     = "1.0.7";
    srcs        = [{ filename = "mingw-w64-i686-brotli-testdata-1.0.7-1-any.pkg.tar.xz"; sha256 = "2b755922abacf63650758eb9e744b562141bea262f8ee7fde32d345cc6178744"; }];
    buildInputs = [ brotli ];
  };

  "bsdfprocessor" = fetch {
    pname       = "bsdfprocessor";
    version     = "1.1.6";
    srcs        = [{ filename = "mingw-w64-i686-bsdfprocessor-1.1.6-1-any.pkg.tar.xz"; sha256 = "5c361d68f022ca099eb485993aa72e216c6f215a9613c6fdfc6d3e13d05b564e"; }];
    buildInputs = [ gcc-libs qt5 OpenSceneGraph ];
  };

  "bullet" = fetch {
    pname       = "bullet";
    version     = "2.87";
    srcs        = [{ filename = "mingw-w64-i686-bullet-2.87-1-any.pkg.tar.xz"; sha256 = "f41ac067977cf45bebe427f2a9064e571b8fb292d0934f07de9799aa0eccc888"; }];
    buildInputs = [ gcc-libs freeglut openvr ];
  };

  "bullet-debug" = fetch {
    pname       = "bullet-debug";
    version     = "2.87";
    srcs        = [{ filename = "mingw-w64-i686-bullet-debug-2.87-1-any.pkg.tar.xz"; sha256 = "3d17f4558a6144a965a218003ef1aa8e84a944d5006f314a9f2f6d06d18ecfdd"; }];
    buildInputs = [ (assert bullet.version=="2.87"; bullet) ];
  };

  "bwidget" = fetch {
    pname       = "bwidget";
    version     = "1.9.12";
    srcs        = [{ filename = "mingw-w64-i686-bwidget-1.9.12-1-any.pkg.tar.xz"; sha256 = "f172e9bb092f0ca72766b9adf02c690fc93bef7a32680a09605c48fe753339e0"; }];
    buildInputs = [ tk ];
  };

  "bzip2" = fetch {
    pname       = "bzip2";
    version     = "1.0.6";
    srcs        = [{ filename = "mingw-w64-i686-bzip2-1.0.6-6-any.pkg.tar.xz"; sha256 = "13d945e5714485c9a2710c0ad6838a5617fecc6b50554040ee5ad98ce5d80a6b"; }];
    buildInputs = [ gcc-libs ];
  };

  "c-ares" = fetch {
    pname       = "c-ares";
    version     = "1.15.0";
    srcs        = [{ filename = "mingw-w64-i686-c-ares-1.15.0-1-any.pkg.tar.xz"; sha256 = "efa45e7980e3372150c38269d7ba7e90650dbf710a6b05f73f6c6a024751855e"; }];
    buildInputs = [  ];
  };

  "c99-to-c89-git" = fetch {
    pname       = "c99-to-c89-git";
    version     = "r169.b3d496d";
    srcs        = [{ filename = "mingw-w64-i686-c99-to-c89-git-r169.b3d496d-1-any.pkg.tar.xz"; sha256 = "bb951699836d5e4ccf70d95e1ee159e62756ab65ed381fae1d3242f1a4375b6a"; }];
    buildInputs = [ clang ];
  };

  "ca-certificates" = fetch {
    pname       = "ca-certificates";
    version     = "20180409";
    srcs        = [{ filename = "mingw-w64-i686-ca-certificates-20180409-1-any.pkg.tar.xz"; sha256 = "f4bc34f1b07bff014cc8fecb2c32b892f39b9dd0d3daf850337a0d07dec63269"; }];
    buildInputs = [ p11-kit ];
  };

  "cairo" = fetch {
    pname       = "cairo";
    version     = "1.16.0";
    srcs        = [{ filename = "mingw-w64-i686-cairo-1.16.0-1-any.pkg.tar.xz"; sha256 = "84e6ee664eefc6b3e9ba1f35476d31e83fd8c7e7ba5edcdb4dd74a44df964566"; }];
    buildInputs = [ gcc-libs freetype fontconfig lzo2 pixman zlib ];
  };

  "cairomm" = fetch {
    pname       = "cairomm";
    version     = "1.12.2";
    srcs        = [{ filename = "mingw-w64-i686-cairomm-1.12.2-2-any.pkg.tar.xz"; sha256 = "86b66ec2e620d172f10db3416ddfbba80a414972dbf29d354ac59cc0ab96fd06"; }];
    buildInputs = [ self."libsigc++" cairo ];
  };

  "capstone" = fetch {
    pname       = "capstone";
    version     = "4.0";
    srcs        = [{ filename = "mingw-w64-i686-capstone-4.0-1-any.pkg.tar.xz"; sha256 = "7a67855cb904996c38f220abd96b7b8c05b0932b42a0c0f4209ee27217a17b81"; }];
    buildInputs = [ gcc-libs ];
  };

  "catch" = fetch {
    pname       = "catch";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-i686-catch-1.6.0-1-any.pkg.tar.xz"; sha256 = "23478123bc6171ed0ebda0fec76e2c354a4accb91748059703c0dcb57733c964"; }];
  };

  "ccache" = fetch {
    pname       = "ccache";
    version     = "3.5";
    srcs        = [{ filename = "mingw-w64-i686-ccache-3.5-1-any.pkg.tar.xz"; sha256 = "242b7de24d96d2ba3d7135c6c25140bd536f2318441aa0138b48041868caa947"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "cccl" = fetch {
    pname       = "cccl";
    version     = "1.0";
    srcs        = [{ filename = "mingw-w64-i686-cccl-1.0-1-any.pkg.tar.xz"; sha256 = "4821c594f85d151695684e932e6d82cd2835fc08c16d1be4e43c3e4559934cde"; }];
  };

  "cego" = fetch {
    pname       = "cego";
    version     = "2.42.16";
    srcs        = [{ filename = "mingw-w64-i686-cego-2.42.16-1-any.pkg.tar.xz"; sha256 = "1a8f9ee27d8b11ccc79d50c50c0fe82362237b67bfed1921753b9bf7487edb1d"; }];
    buildInputs = [ readline lfcbase lfcxml ];
  };

  "cegui" = fetch {
    pname       = "cegui";
    version     = "0.8.7";
    srcs        = [{ filename = "mingw-w64-i686-cegui-0.8.7-1-any.pkg.tar.xz"; sha256 = "782946ca7dd546dfa0c2e79af477ef51e61caf364f0b6fb7ae83cc2a680b6265"; }];
    buildInputs = [ boost devil expat FreeImage freetype fribidi glew glfw glm irrlicht libepoxy libxml2 libiconv lua51 ogre3d ois-git openexr pcre python2 SDL2 SDL2_image tinyxml xerces-c zlib ];
    broken      = true; # broken dependency cegui -> FreeImage
  };

  "celt" = fetch {
    pname       = "celt";
    version     = "0.11.3";
    srcs        = [{ filename = "mingw-w64-i686-celt-0.11.3-4-any.pkg.tar.xz"; sha256 = "0e62b1c678e1faa178b5a6731abd3bc790de26b189bd8322951144934d61f825"; }];
    buildInputs = [ libogg ];
  };

  "cereal" = fetch {
    pname       = "cereal";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-cereal-1.2.2-1-any.pkg.tar.xz"; sha256 = "e48f4df8345f4e73cada4005f1928b5812db5f880af78cedbef9dab5eb64dedc"; }];
    buildInputs = [ boost ];
  };

  "ceres-solver" = fetch {
    pname       = "ceres-solver";
    version     = "1.14.0";
    srcs        = [{ filename = "mingw-w64-i686-ceres-solver-1.14.0-3-any.pkg.tar.xz"; sha256 = "bf871c19cbf0736ae508e810e8f71139d53f18f97df63f68fa939b40d9172fef"; }];
    buildInputs = [ eigen3 glog suitesparse ];
  };

  "cfitsio" = fetch {
    pname       = "cfitsio";
    version     = "3.450";
    srcs        = [{ filename = "mingw-w64-i686-cfitsio-3.450-1-any.pkg.tar.xz"; sha256 = "ade5a6dc405ff2d2c782769fd3acb7f0233531f3a9455f4d9d55bc8b865a0af8"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "cgal" = fetch {
    pname       = "cgal";
    version     = "4.13";
    srcs        = [{ filename = "mingw-w64-i686-cgal-4.13-1-any.pkg.tar.xz"; sha256 = "a6177dd3cd71ee910f369c3d3037e0eb3d2b11464562cf861e5585c8cb08a5d4"; }];
    buildInputs = [ gcc-libs boost gmp mpfr ];
  };

  "cgns" = fetch {
    pname       = "cgns";
    version     = "3.3.1";
    srcs        = [{ filename = "mingw-w64-i686-cgns-3.3.1-1-any.pkg.tar.xz"; sha256 = "fbb4eb7a214aad5d547cf4c90ef32253adbc251fcff98aee1c2101e8c7102fab"; }];
    buildInputs = [ hdf5 ];
  };

  "check" = fetch {
    pname       = "check";
    version     = "0.12.0";
    srcs        = [{ filename = "mingw-w64-i686-check-0.12.0-1-any.pkg.tar.xz"; sha256 = "50d76ea2540c4c12ec04083c0227992bf166dba3a184505ac7812e51451d8f98"; }];
    buildInputs = [ gcc-libs ];
  };

  "chipmunk" = fetch {
    pname       = "chipmunk";
    version     = "7.0.2";
    srcs        = [{ filename = "mingw-w64-i686-chipmunk-7.0.2-1-any.pkg.tar.xz"; sha256 = "8f4b78accc5b9a35ade38146094b50b1fb4878eb75d6551b4be99dd2da1c12f0"; }];
  };

  "chromaprint" = fetch {
    pname       = "chromaprint";
    version     = "1.4.3";
    srcs        = [{ filename = "mingw-w64-i686-chromaprint-1.4.3-1-any.pkg.tar.xz"; sha256 = "8b60b50719971d53f1736f20fe19ffca76cfba75b6124a383f7ba13f1b8781f0"; }];
  };

  "clang" = fetch {
    pname       = "clang";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-clang-7.0.1-1-any.pkg.tar.xz"; sha256 = "bda93129f81f969bc892f133085d117d5a2679e8d2d74941fe283b91267143ef"; }];
    buildInputs = [ (assert llvm.version=="7.0.1"; llvm) gcc z3 ];
  };

  "clang-analyzer" = fetch {
    pname       = "clang-analyzer";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-clang-analyzer-7.0.1-1-any.pkg.tar.xz"; sha256 = "bac6ea3d94514a208d3e5040c9c48262a475c150013ae5eba868d11879bc03c1"; }];
    buildInputs = [ (assert clang.version=="7.0.1"; clang) python2 ];
  };

  "clang-tools-extra" = fetch {
    pname       = "clang-tools-extra";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-clang-tools-extra-7.0.1-1-any.pkg.tar.xz"; sha256 = "458fa4d72ac4d134c15ddc812bd404c96eafd1431ef1d82e89849fca30961ac2"; }];
    buildInputs = [ gcc ];
  };

  "clucene" = fetch {
    pname       = "clucene";
    version     = "2.3.3.4";
    srcs        = [{ filename = "mingw-w64-i686-clucene-2.3.3.4-1-any.pkg.tar.xz"; sha256 = "716ab5f7d550885f5f85a50b8747ae6dcaa92ca090c14058ff6270fba2ad224c"; }];
    buildInputs = [ boost zlib ];
  };

  "clutter" = fetch {
    pname       = "clutter";
    version     = "1.26.2";
    srcs        = [{ filename = "mingw-w64-i686-clutter-1.26.2-1-any.pkg.tar.xz"; sha256 = "bcd25842c0dd969706dff468533326eea4497e7548ee05617f6648998f1d1b20"; }];
    buildInputs = [ atk cogl json-glib gobject-introspection-runtime gtk3 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "clutter-gst" = fetch {
    pname       = "clutter-gst";
    version     = "3.0.26";
    srcs        = [{ filename = "mingw-w64-i686-clutter-gst-3.0.26-1-any.pkg.tar.xz"; sha256 = "f3f339a8f8d672d7388bc2d1bcb63bd6b1038c88c3939912eff5d5fd19adcdc5"; }];
    buildInputs = [ gobject-introspection clutter gstreamer gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "clutter-gtk" = fetch {
    pname       = "clutter-gtk";
    version     = "1.8.4";
    srcs        = [{ filename = "mingw-w64-i686-clutter-gtk-1.8.4-1-any.pkg.tar.xz"; sha256 = "82ac78fd5ac0e56087e661d327c9544ff3913d1db5a658e3d09fa007925f105f"; }];
    buildInputs = [ gtk3 clutter ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "cmake" = fetch {
    pname       = "cmake";
    version     = "3.12.4";
    srcs        = [{ filename = "mingw-w64-i686-cmake-3.12.4-1-any.pkg.tar.xz"; sha256 = "6a97409f3e3ed549efe744e95737bbaddbd4cb1e7e328e945b4e044f3c49835a"; }];
    buildInputs = [ gcc-libs curl expat jsoncpp libarchive libuv rhash zlib ];
  };

  "cmake-doc-qt" = fetch {
    pname       = "cmake-doc-qt";
    version     = "3.12.4";
    srcs        = [{ filename = "mingw-w64-i686-cmake-doc-qt-3.12.4-1-any.pkg.tar.xz"; sha256 = "da9d1faa925b2f2d21c2331954f65e1effa2714bf8ffaaacd6cbf5b71f0a4c30"; }];
  };

  "cmark" = fetch {
    pname       = "cmark";
    version     = "0.28.3";
    srcs        = [{ filename = "mingw-w64-i686-cmark-0.28.3-1-any.pkg.tar.xz"; sha256 = "ac8e31606d88da0067f6f6b25cbb34ea551ce80a99c64359d267c7737a12e900"; }];
  };

  "cmocka" = fetch {
    pname       = "cmocka";
    version     = "1.1.3";
    srcs        = [{ filename = "mingw-w64-i686-cmocka-1.1.3-2-any.pkg.tar.xz"; sha256 = "241a83bd995d05de928be8aaac6c28e379e7bf8e418edc09226f73b20f980164"; }];
  };

  "codelite-git" = fetch {
    pname       = "codelite-git";
    version     = "12.0.656.g3349d0f7d";
    srcs        = [{ filename = "mingw-w64-i686-codelite-git-12.0.656.g3349d0f7d-1-any.pkg.tar.xz"; sha256 = "a3bf62f96eb86418c6e5bf3d3064af1f3eca435dfddcc951c70da25551c4fdcd"; }];
    buildInputs = [ gcc-libs hunspell libssh drmingw clang wxWidgets sqlite3 ];
  };

  "cogl" = fetch {
    pname       = "cogl";
    version     = "1.22.2";
    srcs        = [{ filename = "mingw-w64-i686-cogl-1.22.2-1-any.pkg.tar.xz"; sha256 = "31d417d1effc2c5469196470b37095155a9d7c13d4191eaae70258ad46e0537f"; }];
    buildInputs = [ pango gdk-pixbuf2 gstreamer gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "coin3d-hg" = fetch {
    pname       = "coin3d-hg";
    version     = "r11819+.c0999df53040+";
    srcs        = [{ filename = "mingw-w64-i686-coin3d-hg-r11819+.c0999df53040+-1-any.pkg.tar.xz"; sha256 = "2be655bc6078f58ecd35e2d02573ddf1ebe6ba493e47ee059e1639915bafbfa0"; }];
    buildInputs = [ simage bzip2 expat openal superglu freetype fontconfig zlib ];
    broken      = true; # broken dependency coin3d-hg -> simage
  };

  "collada-dom-svn" = fetch {
    pname       = "collada-dom-svn";
    version     = "2.4.1.r889";
    srcs        = [{ filename = "mingw-w64-i686-collada-dom-svn-2.4.1.r889-7-any.pkg.tar.xz"; sha256 = "41f453341f70c352a79c322ce7400af1405b8cf8999e0be9a5e79ca51ae9d139"; }];
    buildInputs = [ bzip2 boost libxml2 pcre zlib ];
  };

  "compiler-rt" = fetch {
    pname       = "compiler-rt";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-compiler-rt-7.0.1-1-any.pkg.tar.xz"; sha256 = "bc4aee21ea4a3567f224d9fa30bf0db5a5a4ced3feba5dbb83464b637b8a1ce4"; }];
    buildInputs = [ (assert llvm.version=="7.0.1"; llvm) ];
  };

  "confuse" = fetch {
    pname       = "confuse";
    version     = "3.2.2";
    srcs        = [{ filename = "mingw-w64-i686-confuse-3.2.2-1-any.pkg.tar.xz"; sha256 = "501c555965b1ef2cce39e68b039e705966d51afc4d8de68bbbc4b71b5a9379c6"; }];
    buildInputs = [ gettext ];
  };

  "connect" = fetch {
    pname       = "connect";
    version     = "1.105";
    srcs        = [{ filename = "mingw-w64-i686-connect-1.105-1-any.pkg.tar.xz"; sha256 = "ef92b2908b0fce9a1429b30597210f16cbf7c3bfd7e6dfe63922471151d264b0"; }];
  };

  "cotire" = fetch {
    pname       = "cotire";
    version     = "1.8.0_3.12";
    srcs        = [{ filename = "mingw-w64-i686-cotire-1.8.0_3.12-2-any.pkg.tar.xz"; sha256 = "4e3c5be165478e442f094ace04f7cf1b9a167084dd75bfc1dabfdeb285dde547"; }];
  };

  "cppcheck" = fetch {
    pname       = "cppcheck";
    version     = "1.86";
    srcs        = [{ filename = "mingw-w64-i686-cppcheck-1.86-1-any.pkg.tar.xz"; sha256 = "874a6b1a9be4c7e6af26667b2ed9e7f31e79d7fa20ad0bcbd16da3c730b5ade4"; }];
    buildInputs = [ pcre ];
  };

  "cppreference-qt" = fetch {
    pname       = "cppreference-qt";
    version     = "20181028";
    srcs        = [{ filename = "mingw-w64-i686-cppreference-qt-20181028-1-any.pkg.tar.xz"; sha256 = "d66202f1423dbf0fed89fa6eced7c5464e5e892cb22d4ffd72a613d36bb5ac38"; }];
  };

  "cpptest" = fetch {
    pname       = "cpptest";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-i686-cpptest-1.1.2-2-any.pkg.tar.xz"; sha256 = "e537273efbef813f604de0ac62a5ace2de301ea198a85e2a3f03bf0698883438"; }];
  };

  "cppunit" = fetch {
    pname       = "cppunit";
    version     = "1.14.0";
    srcs        = [{ filename = "mingw-w64-i686-cppunit-1.14.0-1-any.pkg.tar.xz"; sha256 = "0d9f9246d4ddcc8f7faa3b804f8098dfa8a32ee158bc624796fe6cd573fae29c"; }];
    buildInputs = [ gcc-libs ];
  };

  "creduce" = fetch {
    pname       = "creduce";
    version     = "2.8.0";
    srcs        = [{ filename = "mingw-w64-i686-creduce-2.8.0-1-any.pkg.tar.xz"; sha256 = "85a76386a21c2b044e5d0eb552365f4acd04f17819a842c8e06e110fde46affd"; }];
    buildInputs = [ perl-Benchmark-Timer perl-Exporter-Lite perl-File-Which perl-Getopt-Tabular perl-Regexp-Common perl-Sys-CPU astyle indent clang ];
    broken      = true; # broken dependency creduce -> perl-Benchmark-Timer
  };

  "crt-git" = fetch {
    pname       = "crt-git";
    version     = "7.0.0.5285.7b2baaf8";
    srcs        = [{ filename = "mingw-w64-i686-crt-git-7.0.0.5285.7b2baaf8-1-any.pkg.tar.xz"; sha256 = "796f649e9fcff3300754018791d2a92a57b6ab617c6c43c166d1fb1c291a3efb"; }];
    buildInputs = [ headers-git ];
  };

  "crypto++" = fetch {
    pname       = "crypto++";
    version     = "7.0.0";
    srcs        = [{ filename = "mingw-w64-i686-crypto++-7.0.0-1-any.pkg.tar.xz"; sha256 = "8aad0ef471b039ff57cdc6c394d141a4d86c6e940bb7c8ac9731148e57b3c3c6"; }];
    buildInputs = [ gcc-libs ];
  };

  "csfml" = fetch {
    pname       = "csfml";
    version     = "2.5";
    srcs        = [{ filename = "mingw-w64-i686-csfml-2.5-1-any.pkg.tar.xz"; sha256 = "e9ae0abde77aa6c05f705e059d68f75465de28978ace6becba84aa41cb077857"; }];
    buildInputs = [ sfml ];
  };

  "ctags" = fetch {
    pname       = "ctags";
    version     = "5.8";
    srcs        = [{ filename = "mingw-w64-i686-ctags-5.8-5-any.pkg.tar.xz"; sha256 = "15c74d48ad9a33a13ae5a088dea004ed710f3e8f0e11590a53606f8853629523"; }];
    buildInputs = [ gcc-libs ];
  };

  "ctpl-git" = fetch {
    pname       = "ctpl-git";
    version     = "0.3.3.391.6dd5c14";
    srcs        = [{ filename = "mingw-w64-i686-ctpl-git-0.3.3.391.6dd5c14-1-any.pkg.tar.xz"; sha256 = "12139f316f696e6ae7a18b9b8e22cadc24e132e473ecd44205bf0706eda78af5"; }];
    buildInputs = [ glib2 ];
  };

  "cunit" = fetch {
    pname       = "cunit";
    version     = "2.1.3";
    srcs        = [{ filename = "mingw-w64-i686-cunit-2.1.3-3-any.pkg.tar.xz"; sha256 = "742db796b52e0b80854262e1c661b4dda26e2f18a1e624eb2ae591747a581395"; }];
  };

  "curl" = fetch {
    pname       = "curl";
    version     = "7.63.0";
    srcs        = [{ filename = "mingw-w64-i686-curl-7.63.0-2-any.pkg.tar.xz"; sha256 = "4fac1443425e1f2cb202ea02ed5d87e30e3324e30c95fe01feccbde4cd5737e0"; }];
    buildInputs = [ gcc-libs c-ares brotli libidn2 libmetalink libpsl libssh2 zlib ca-certificates openssl nghttp2 ];
  };

  "cvode" = fetch {
    pname       = "cvode";
    version     = "3.2.1";
    srcs        = [{ filename = "mingw-w64-i686-cvode-3.2.1-1-any.pkg.tar.xz"; sha256 = "f89e1a67ddb4bca0962c8a23afd5a247128bee5dd2805231419e6ad102e4b4e9"; }];
  };

  "cyrus-sasl" = fetch {
    pname       = "cyrus-sasl";
    version     = "2.1.27.rc8";
    srcs        = [{ filename = "mingw-w64-i686-cyrus-sasl-2.1.27.rc8-1-any.pkg.tar.xz"; sha256 = "5ec034c4f58da55fe7401f699c58ff1c392c92255d042f8bb8c7e862c597c1cd"; }];
    buildInputs = [ gdbm openssl sqlite3 ];
  };

  "cython" = fetch {
    pname       = "cython";
    version     = "0.29.2";
    srcs        = [{ filename = "mingw-w64-i686-cython-0.29.2-1-any.pkg.tar.xz"; sha256 = "cd165df2ae7f170cacb1070f0a6230a051d5bb40e906a9e20d887a8d785a03e2"; }];
    buildInputs = [ python3-setuptools ];
  };

  "cython2" = fetch {
    pname       = "cython2";
    version     = "0.29.2";
    srcs        = [{ filename = "mingw-w64-i686-cython2-0.29.2-1-any.pkg.tar.xz"; sha256 = "e6d1c075df2b1210d99c4c3feb16be6ca7059100d110dde5502531e4a2a51417"; }];
    buildInputs = [ python2-setuptools ];
  };

  "d-feet" = fetch {
    pname       = "d-feet";
    version     = "0.3.14";
    srcs        = [{ filename = "mingw-w64-i686-d-feet-0.3.14-1-any.pkg.tar.xz"; sha256 = "bec071b2fbc6049fa3d5e1cd42d7f0315bc9c647e937a5cd15aaf5c0271d6e67"; }];
    buildInputs = [ gtk3 python3-gobject hicolor-icon-theme ];
  };

  "daala-git" = fetch {
    pname       = "daala-git";
    version     = "r1505.52bbd43";
    srcs        = [{ filename = "mingw-w64-i686-daala-git-r1505.52bbd43-1-any.pkg.tar.xz"; sha256 = "bf621212534ff31f9c2118d0a26d0296e755401f96f23d1c3693275011e88e07"; }];
    buildInputs = [ libogg libpng libjpeg-turbo SDL2 ];
  };

  "db" = fetch {
    pname       = "db";
    version     = "6.0.19";
    srcs        = [{ filename = "mingw-w64-i686-db-6.0.19-3-any.pkg.tar.xz"; sha256 = "697ee9a850215a361b85a3b330d1d3ec110e21ba653c96ef84901bfd3be360f6"; }];
    buildInputs = [ gcc-libs ];
  };

  "dbus" = fetch {
    pname       = "dbus";
    version     = "1.12.12";
    srcs        = [{ filename = "mingw-w64-i686-dbus-1.12.12-1-any.pkg.tar.xz"; sha256 = "f3022d2304f009af1304fca08e27af84c1b111799b10db5dc04a51bf5fb81798"; }];
    buildInputs = [ glib2 expat ];
  };

  "dbus-c++" = fetch {
    pname       = "dbus-c++";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-i686-dbus-c++-0.9.0-1-any.pkg.tar.xz"; sha256 = "8347bdbb0730468a70fc9834b927f1c1b1706a7afe6256fb057acb782aed9359"; }];
    buildInputs = [ dbus ];
  };

  "dbus-glib" = fetch {
    pname       = "dbus-glib";
    version     = "0.110";
    srcs        = [{ filename = "mingw-w64-i686-dbus-glib-0.110-1-any.pkg.tar.xz"; sha256 = "8a1382afd27e39bab76d705c77370705ac04539f989bc15872162776232202b0"; }];
    buildInputs = [ glib2 dbus expat ];
  };

  "dcadec" = fetch {
    pname       = "dcadec";
    version     = "0.2.0";
    srcs        = [{ filename = "mingw-w64-i686-dcadec-0.2.0-2-any.pkg.tar.xz"; sha256 = "db8c66b5b508acd0456927a4067d172a45dc77c4b54bc68ec15d8b96003d7c38"; }];
    buildInputs = [ gcc-libs ];
  };

  "desktop-file-utils" = fetch {
    pname       = "desktop-file-utils";
    version     = "0.23";
    srcs        = [{ filename = "mingw-w64-i686-desktop-file-utils-0.23-1-any.pkg.tar.xz"; sha256 = "8b4c1a3dbd5916571f1aff2063f6b9dff39c69a490365daaaa5741326ed13dec"; }];
    buildInputs = [ glib2 gtk3 libxml2 ];
  };

  "devcon-git" = fetch {
    pname       = "devcon-git";
    version     = "r233.8b17cf3";
    srcs        = [{ filename = "mingw-w64-i686-devcon-git-r233.8b17cf3-1-any.pkg.tar.xz"; sha256 = "74c514ee965c361ab0b2eba285910678a4e084f329d453746e44a550788b12cc"; }];
  };

  "devhelp" = fetch {
    pname       = "devhelp";
    version     = "3.8.2";
    srcs        = [{ filename = "mingw-w64-i686-devhelp-3.8.2-2-any.pkg.tar.xz"; sha256 = "23d10605b1d7b46683ff48dec182339372d4baac583756dda2a52be1602624cc"; }];
    buildInputs = [ gtk3 gsettings-desktop-schemas adwaita-icon-theme webkitgtk3 png2ico python2 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "devil" = fetch {
    pname       = "devil";
    version     = "1.8.0";
    srcs        = [{ filename = "mingw-w64-i686-devil-1.8.0-4-any.pkg.tar.xz"; sha256 = "514fe00a30a3e81131b37d691a521517f12e7f695b22347a6149a117b3610a95"; }];
    buildInputs = [ freeglut jasper lcms2 libmng libpng libsquish libtiff openexr zlib ];
  };

  "diffutils" = fetch {
    pname       = "diffutils";
    version     = "3.6";
    srcs        = [{ filename = "mingw-w64-i686-diffutils-3.6-2-any.pkg.tar.xz"; sha256 = "fdd544ed90b4923e63913304b0be68db2c4e377ba5bca3692dc011eceec9bad3"; }];
    buildInputs = [ libsigsegv libwinpthread-git gettext ];
  };

  "discount" = fetch {
    pname       = "discount";
    version     = "2.2.4";
    srcs        = [{ filename = "mingw-w64-i686-discount-2.2.4-1-any.pkg.tar.xz"; sha256 = "f4af3faf7631855f40ad6c134ac83d7c947d36c14a670fbc7ba8369aad5737c6"; }];
  };

  "distorm" = fetch {
    pname       = "distorm";
    version     = "3.4.1";
    srcs        = [{ filename = "mingw-w64-i686-distorm-3.4.1-1-any.pkg.tar.xz"; sha256 = "75a0f99795e68c906fd6f154f0aae2fb3c88c353cdb4152c3a53f968ed4b00ce"; }];
  };

  "djview" = fetch {
    pname       = "djview";
    version     = "4.10.6";
    srcs        = [{ filename = "mingw-w64-i686-djview-4.10.6-1-any.pkg.tar.xz"; sha256 = "7f09112afffcdb81e4db9cb4387270dbb5a20447ecd28f7d5dd6a7bcd2896538"; }];
    buildInputs = [ djvulibre gcc-libs qt5 libtiff ];
  };

  "djvulibre" = fetch {
    pname       = "djvulibre";
    version     = "3.5.27";
    srcs        = [{ filename = "mingw-w64-i686-djvulibre-3.5.27-3-any.pkg.tar.xz"; sha256 = "4084261c9d071317d8d61993a42c0567b353d0b6691dbf7182c581b6091d6d68"; }];
    buildInputs = [ gcc-libs libjpeg libiconv libtiff zlib ];
  };

  "dlfcn" = fetch {
    pname       = "dlfcn";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-i686-dlfcn-1.1.2-1-any.pkg.tar.xz"; sha256 = "be1c4b2dc1b4a368b8a8bfc61314489d791a71fd7b71a95a71837010492ced82"; }];
    buildInputs = [ gcc-libs ];
  };

  "dlib" = fetch {
    pname       = "dlib";
    version     = "19.16";
    srcs        = [{ filename = "mingw-w64-i686-dlib-19.16-2-any.pkg.tar.xz"; sha256 = "67401574702820e743f0f2acf91b53669c760986f9c6cab66ddab29492be4d23"; }];
    buildInputs = [ lapack giflib libpng libjpeg-turbo openblas lapack fftw sqlite3 ];
  };

  "dmake" = fetch {
    pname       = "dmake";
    version     = "4.12.2.2";
    srcs        = [{ filename = "mingw-w64-i686-dmake-4.12.2.2-1-any.pkg.tar.xz"; sha256 = "82296f7f3e1b452590f664363d3e22f69cfa5ac194fb4ad3719dd20e080d6df6"; }];
  };

  "dnscrypt-proxy" = fetch {
    pname       = "dnscrypt-proxy";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-i686-dnscrypt-proxy-1.6.0-2-any.pkg.tar.xz"; sha256 = "69087e524315044a10ac33edda723b97dfb5aa0f4640c059c0244bd0f50ba742"; }];
    buildInputs = [ libsodium ldns ];
  };

  "docbook-dsssl" = fetch {
    pname       = "docbook-dsssl";
    version     = "1.79";
    srcs        = [{ filename = "mingw-w64-i686-docbook-dsssl-1.79-1-any.pkg.tar.xz"; sha256 = "5ae88a8e71dbefe7b6fd568a480b0a81b19f8121ccfdd649b3967e00a4e2ae37"; }];
    buildInputs = [ sgml-common perl ];
  };

  "docbook-mathml" = fetch {
    pname       = "docbook-mathml";
    version     = "1.1CR1";
    srcs        = [{ filename = "mingw-w64-i686-docbook-mathml-1.1CR1-1-any.pkg.tar.xz"; sha256 = "c36c875d0fc3798b1b9d144b2d08961d2f7e68683823c18bdeb73c5c2f36fad6"; }];
    buildInputs = [ libxml2 ];
  };

  "docbook-sgml" = fetch {
    pname       = "docbook-sgml";
    version     = "4.5";
    srcs        = [{ filename = "mingw-w64-i686-docbook-sgml-4.5-1-any.pkg.tar.xz"; sha256 = "773869f96d499a8b8d4f751fe93f0b48299cefb41dcae4b15f807b89f6e64900"; }];
    buildInputs = [ sgml-common ];
  };

  "docbook-sgml31" = fetch {
    pname       = "docbook-sgml31";
    version     = "3.1";
    srcs        = [{ filename = "mingw-w64-i686-docbook-sgml31-3.1-1-any.pkg.tar.xz"; sha256 = "9d1d61b1ede7831eed75271d32c90a06107964bf6884f2ed13f70890c267c0f4"; }];
    buildInputs = [ sgml-common ];
  };

  "docbook-xml" = fetch {
    pname       = "docbook-xml";
    version     = "5.0";
    srcs        = [{ filename = "mingw-w64-i686-docbook-xml-5.0-1-any.pkg.tar.xz"; sha256 = "1fba26476c0df49078c68f7a731099a43fae53a091b2eb572c80b3bf3d5570e9"; }];
    buildInputs = [ libxml2 ];
  };

  "docbook-xsl" = fetch {
    pname       = "docbook-xsl";
    version     = "1.79.2";
    srcs        = [{ filename = "mingw-w64-i686-docbook-xsl-1.79.2-3-any.pkg.tar.xz"; sha256 = "9faa2e076ffd2ada984cdc85d675112308d6fc78cf3f405965c5789eb97f0d2a"; }];
    buildInputs = [ libxml2 libxslt docbook-xml ];
  };

  "double-conversion" = fetch {
    pname       = "double-conversion";
    version     = "3.1.1";
    srcs        = [{ filename = "mingw-w64-i686-double-conversion-3.1.1-1-any.pkg.tar.xz"; sha256 = "bf42bf6e7454395cfce177b7fdbe76bbc55b0c15edecb4ada2015ed83d90959a"; }];
    buildInputs = [ gcc-libs ];
  };

  "doxygen" = fetch {
    pname       = "doxygen";
    version     = "1.8.14";
    srcs        = [{ filename = "mingw-w64-i686-doxygen-1.8.14-3-any.pkg.tar.xz"; sha256 = "9842a91f27170706e9f7139bf44fa8afe2a62f20eb12c899cbd514ba2846bb65"; }];
    buildInputs = [ clang gcc-libs libiconv sqlite3 xapian-core ];
  };

  "dragon" = fetch {
    pname       = "dragon";
    version     = "1.5.2";
    srcs        = [{ filename = "mingw-w64-i686-dragon-1.5.2-1-any.pkg.tar.xz"; sha256 = "41df20c5fffc47de45acc3c66d009eed923e6a03c39d83abdcd3069d866d7555"; }];
    buildInputs = [ lfcbase ];
  };

  "drmingw" = fetch {
    pname       = "drmingw";
    version     = "0.8.2";
    srcs        = [{ filename = "mingw-w64-i686-drmingw-0.8.2-1-any.pkg.tar.xz"; sha256 = "684812be9051d8087170ade80d532e68a9d38934986c6daca39d31ac71454d40"; }];
    buildInputs = [ gcc-libs ];
  };

  "dsdp" = fetch {
    pname       = "dsdp";
    version     = "5.8";
    srcs        = [{ filename = "mingw-w64-i686-dsdp-5.8-1-any.pkg.tar.xz"; sha256 = "285528b2812432838dfeb48860737b73cb215d88857bf6ea95dde10ab8ba632d"; }];
    buildInputs = [ openblas ];
  };

  "dumb" = fetch {
    pname       = "dumb";
    version     = "2.0.3";
    srcs        = [{ filename = "mingw-w64-i686-dumb-2.0.3-1-any.pkg.tar.xz"; sha256 = "2b81c4dbb58c8b0e46c875c67ba82289af1169e3812810209a362c0c68004bd7"; }];
  };

  "editorconfig-core-c" = fetch {
    pname       = "editorconfig-core-c";
    version     = "0.12.3";
    srcs        = [{ filename = "mingw-w64-i686-editorconfig-core-c-0.12.3-1-any.pkg.tar.xz"; sha256 = "685ed42790d47c5491f1e198041e6d86eb249f0a2ebfd462403c97cde55c0e8d"; }];
    buildInputs = [ pcre ];
  };

  "editrights" = fetch {
    pname       = "editrights";
    version     = "1.03";
    srcs        = [{ filename = "mingw-w64-i686-editrights-1.03-3-any.pkg.tar.xz"; sha256 = "326c611b22b77a624229c93a67e7294256fbe225c9aaf185c7e1139c5bed10cf"; }];
  };

  "eigen3" = fetch {
    pname       = "eigen3";
    version     = "3.3.7";
    srcs        = [{ filename = "mingw-w64-i686-eigen3-3.3.7-1-any.pkg.tar.xz"; sha256 = "a49b48c2382909859fd00265bdbe579fb5cb56daa063b5c38a76675aa5e46a95"; }];
    buildInputs = [  ];
  };

  "emacs" = fetch {
    pname       = "emacs";
    version     = "26.1";
    srcs        = [{ filename = "mingw-w64-i686-emacs-26.1-1-any.pkg.tar.xz"; sha256 = "b91054998135c2536eb27af17ca02b33ac583caa122a62bda088099055beae1a"; }];
    buildInputs = [ ctags zlib xpm-nox dbus gnutls imagemagick libwinpthread-git ];
  };

  "enca" = fetch {
    pname       = "enca";
    version     = "1.19";
    srcs        = [{ filename = "mingw-w64-i686-enca-1.19-1-any.pkg.tar.xz"; sha256 = "e7002fb62441bfbf9fa9e84e62c86b0e687204c7808f105cd99f49fa4a9ebb1d"; }];
    buildInputs = [ recode ];
  };

  "enchant" = fetch {
    pname       = "enchant";
    version     = "2.2.3";
    srcs        = [{ filename = "mingw-w64-i686-enchant-2.2.3-3-any.pkg.tar.xz"; sha256 = "80141b40cf3de8be450623d54ae645301320f0073e3ce0cbd67ec52cbbf58e95"; }];
    buildInputs = [ gcc-libs glib2 aspell hunspell libvoikko ];
  };

  "enet" = fetch {
    pname       = "enet";
    version     = "1.3.13";
    srcs        = [{ filename = "mingw-w64-i686-enet-1.3.13-2-any.pkg.tar.xz"; sha256 = "38b53a6641947627af96d72d94ed27a0876e5fd7dc80f2a777d37af0ce866ee6"; }];
  };

  "eog" = fetch {
    pname       = "eog";
    version     = "3.16.3";
    srcs        = [{ filename = "mingw-w64-i686-eog-3.16.3-1-any.pkg.tar.xz"; sha256 = "43c48ba410e55377cc9fba0cd86c662f53edd2476d37e4a7569833ca79e9abbe"; }];
    buildInputs = [ adwaita-icon-theme gettext gtk3 gdk-pixbuf2 gobject-introspection-runtime gsettings-desktop-schemas zlib libexif libjpeg-turbo libpeas librsvg libxml2 shared-mime-info ];
  };

  "eog-plugins" = fetch {
    pname       = "eog-plugins";
    version     = "3.16.3";
    srcs        = [{ filename = "mingw-w64-i686-eog-plugins-3.16.3-1-any.pkg.tar.xz"; sha256 = "3ed4155d330f096c1db3373433e7ddcee817e4f1899a7bbfcacf2c98e1478ff9"; }];
    buildInputs = [ eog libchamplain libexif libgdata postr python2 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "evince" = fetch {
    pname       = "evince";
    version     = "3.28.2";
    srcs        = [{ filename = "mingw-w64-i686-evince-3.28.2-3-any.pkg.tar.xz"; sha256 = "3dfa6ef309ca07fe558c4e297888c8e594c7bd9868a7a6ea59d4f0a26eb65a86"; }];
    buildInputs = [ glib2 cairo djvulibre gsettings-desktop-schemas gtk3 libgxps libspectre libtiff poppler gst-plugins-base nss ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "exiv2" = fetch {
    pname       = "exiv2";
    version     = "0.26";
    srcs        = [{ filename = "mingw-w64-i686-exiv2-0.26-3-any.pkg.tar.xz"; sha256 = "9046184bf66ef773c93b90f9e6768758e3c7c232da83512e5459d11566bbb028"; }];
    buildInputs = [ expat gettext curl libssh2 zlib ];
  };

  "expat" = fetch {
    pname       = "expat";
    version     = "2.2.6";
    srcs        = [{ filename = "mingw-w64-i686-expat-2.2.6-1-any.pkg.tar.xz"; sha256 = "1a04398f813c993f503f47494c4c3c2c7ab3b1ff3919076f4424d0caf385045b"; }];
    buildInputs = [  ];
  };

  "extra-cmake-modules" = fetch {
    pname       = "extra-cmake-modules";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-extra-cmake-modules-5.50.0-1-any.pkg.tar.xz"; sha256 = "17d56dff015fac6c3e3368d2bfab74e87489c38c84c443745847920f6216645d"; }];
    buildInputs = [ cmake png2ico ];
  };

  "f2c" = fetch {
    pname       = "f2c";
    version     = "1.0";
    srcs        = [{ filename = "mingw-w64-i686-f2c-1.0-1-any.pkg.tar.xz"; sha256 = "8d3996f10ec782f27f53adcdaf86697bbf4b83c07ec5c4fae805e90e2a4f4c31"; }];
  };

  "faac" = fetch {
    pname       = "faac";
    version     = "1.29.9.2";
    srcs        = [{ filename = "mingw-w64-i686-faac-1.29.9.2-1-any.pkg.tar.xz"; sha256 = "0ed7e5807f78eac0d82426ef38e13e3925858c0aa38c0fd740c69da1e9527634"; }];
  };

  "faad2" = fetch {
    pname       = "faad2";
    version     = "2.8.8";
    srcs        = [{ filename = "mingw-w64-i686-faad2-2.8.8-1-any.pkg.tar.xz"; sha256 = "48a3fc7b3818351c475090b9db7f0ed35dfc0660c2ca85d741f5fcfecab10fc2"; }];
    buildInputs = [ gcc-libs ];
  };

  "fann" = fetch {
    pname       = "fann";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-i686-fann-2.2.0-2-any.pkg.tar.xz"; sha256 = "67eadf7fab8f599db8ff27c254d6eae2355ab4103b9d27cb50338d6a928d78f3"; }];
  };

  "farstream" = fetch {
    pname       = "farstream";
    version     = "0.2.8";
    srcs        = [{ filename = "mingw-w64-i686-farstream-0.2.8-2-any.pkg.tar.xz"; sha256 = "dc3718ed0b144a28cd8be575ce08238f8bcb32362aca667db896248db323e33b"; }];
    buildInputs = [ gst-plugins-base libnice ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "fastjar" = fetch {
    pname       = "fastjar";
    version     = "0.98";
    srcs        = [{ filename = "mingw-w64-i686-fastjar-0.98-1-any.pkg.tar.xz"; sha256 = "42992b23107e40f6f959cd5120313641eee29af65c34cdc916544bd0f5ccae9e"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "fcrackzip" = fetch {
    pname       = "fcrackzip";
    version     = "1.0";
    srcs        = [{ filename = "mingw-w64-i686-fcrackzip-1.0-1-any.pkg.tar.xz"; sha256 = "4fee468f8a10c72a11017684705fae76a70ff8765633532baf762123c72a356d"; }];
  };

  "fdk-aac" = fetch {
    pname       = "fdk-aac";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-fdk-aac-2.0.0-1-any.pkg.tar.xz"; sha256 = "bef11f85d43a0aaaeed48a46239be0e752c5b18d773dbb49b415b1a02bfc62f7"; }];
  };

  "ffcall" = fetch {
    pname       = "ffcall";
    version     = "2.1";
    srcs        = [{ filename = "mingw-w64-i686-ffcall-2.1-1-any.pkg.tar.xz"; sha256 = "368d1a4f33c22c9b5b8ea1a6a811f6075cc4076b0851a6becde38333e0032fab"; }];
  };

  "ffmpeg" = fetch {
    pname       = "ffmpeg";
    version     = "4.1";
    srcs        = [{ filename = "mingw-w64-i686-ffmpeg-4.1-1-any.pkg.tar.xz"; sha256 = "f9ef4b4180387a789ffff9b5280846e0571a5e8b1ea6f6d7d472f4721ea6f2d3"; }];
    buildInputs = [ bzip2 celt fontconfig gnutls gsm lame libass libbluray libcaca libmodplug libtheora libvorbis libvpx libwebp openal opencore-amr openjpeg2 opus rtmpdump-git SDL2 speex wavpack x264-git x265 xvidcore zlib ];
  };

  "ffms2" = fetch {
    pname       = "ffms2";
    version     = "2.23";
    srcs        = [{ filename = "mingw-w64-i686-ffms2-2.23-1-any.pkg.tar.xz"; sha256 = "c80534a8b8e70032f774997bff66bbfbfc2a2c3007eacae3b2c04a83c351cae6"; }];
    buildInputs = [ ffmpeg ];
  };

  "fftw" = fetch {
    pname       = "fftw";
    version     = "3.3.8";
    srcs        = [{ filename = "mingw-w64-i686-fftw-3.3.8-1-any.pkg.tar.xz"; sha256 = "8033db3846eae2640e5ca5c3b67a11449bd613c80245dbb0f950c0230a700664"; }];
    buildInputs = [ gcc-libs ];
  };

  "fgsl" = fetch {
    pname       = "fgsl";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-fgsl-1.2.0-2-any.pkg.tar.xz"; sha256 = "028cc1cc1c4e6575b9ce92db5880e5ce282c056926494faf249cc74595c3b059"; }];
    buildInputs = [ gcc-libs gcc-libgfortran (assert stdenvNoCC.lib.versionAtLeast gsl.version "2.3"; gsl) ];
  };

  "field3d" = fetch {
    pname       = "field3d";
    version     = "1.7.2";
    srcs        = [{ filename = "mingw-w64-i686-field3d-1.7.2-6-any.pkg.tar.xz"; sha256 = "3cbf7a23f9497fff028f995f7c9295fb69c4cab25a56cb68f003a6060e097869"; }];
    buildInputs = [ boost hdf5 openexr ];
  };

  "file" = fetch {
    pname       = "file";
    version     = "5.35";
    srcs        = [{ filename = "mingw-w64-i686-file-5.35-1-any.pkg.tar.xz"; sha256 = "9998d5f1c5870390852965bf45b1bd9225e33fc2833abbfdc35115eb373ce441"; }];
    buildInputs = [ libsystre ];
  };

  "firebird2-git" = fetch {
    pname       = "firebird2-git";
    version     = "2.5.9.27107.8f69580de5";
    srcs        = [{ filename = "mingw-w64-i686-firebird2-git-2.5.9.27107.8f69580de5-1-any.pkg.tar.xz"; sha256 = "53b974da45ec7585cd7bca3ed1631eeb81dcc7feda736afe85826b161b4c1fc5"; }];
    buildInputs = [ gcc-libs icu zlib ];
  };

  "flac" = fetch {
    pname       = "flac";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-i686-flac-1.3.2-1-any.pkg.tar.xz"; sha256 = "617caddfeb365c20330262971b570298bdfdcf17bc129d9c60c4c089eff3cfad"; }];
    buildInputs = [ libogg gcc-libs ];
  };

  "flatbuffers" = fetch {
    pname       = "flatbuffers";
    version     = "1.10.0";
    srcs        = [{ filename = "mingw-w64-i686-flatbuffers-1.10.0-1-any.pkg.tar.xz"; sha256 = "d410a5a37678911f2e945680dbbfeb62715446514b0483e281250af12a6b1b23"; }];
    buildInputs = [ libsystre ];
  };

  "flexdll" = fetch {
    pname       = "flexdll";
    version     = "0.34";
    srcs        = [{ filename = "mingw-w64-i686-flexdll-0.34-2-any.pkg.tar.xz"; sha256 = "9e91bdabf874ad728827acd408d18454aef05b77a6e88e261fa8a5e30934fdaf"; }];
  };

  "flickcurl" = fetch {
    pname       = "flickcurl";
    version     = "1.26";
    srcs        = [{ filename = "mingw-w64-i686-flickcurl-1.26-2-any.pkg.tar.xz"; sha256 = "9b3c40cfdb75f7940a92301236194d640046721834cbfa8e16febd76f32628cb"; }];
    buildInputs = [ curl libxml2 ];
  };

  "flif" = fetch {
    pname       = "flif";
    version     = "0.3";
    srcs        = [{ filename = "mingw-w64-i686-flif-0.3-1-any.pkg.tar.xz"; sha256 = "739981420fcb3d61ed4c7574967d3d1dc77398add07b4d1820847eeceb6c7567"; }];
    buildInputs = [ zlib libpng SDL2 ];
  };

  "fltk" = fetch {
    pname       = "fltk";
    version     = "1.3.4.2";
    srcs        = [{ filename = "mingw-w64-i686-fltk-1.3.4.2-1-any.pkg.tar.xz"; sha256 = "a9bdeb4224618343ac66fe8061182c78efb29d7b7e32b30aa5fe56cf1d47b0b9"; }];
    buildInputs = [ expat gcc-libs gettext libiconv libpng libjpeg-turbo zlib ];
  };

  "fluidsynth" = fetch {
    pname       = "fluidsynth";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-fluidsynth-2.0.0-1-any.pkg.tar.xz"; sha256 = "2cac9c374c182831ffa1171ddbd0a0c15ac3ba0f6ef672690399a2c87f40d60f"; }];
    buildInputs = [ gcc-libs glib2 libsndfile portaudio ];
  };

  "fmt" = fetch {
    pname       = "fmt";
    version     = "5.3.0";
    srcs        = [{ filename = "mingw-w64-i686-fmt-5.3.0-1-any.pkg.tar.xz"; sha256 = "6df60d910c2b630e4ff2e1fde373f9fbea4517c6fb14b265fbf1cc9f914b5f66"; }];
    buildInputs = [ gcc-libs ];
  };

  "fontconfig" = fetch {
    pname       = "fontconfig";
    version     = "2.13.1";
    srcs        = [{ filename = "mingw-w64-i686-fontconfig-2.13.1-1-any.pkg.tar.xz"; sha256 = "9aacd2d38a7a739e0168f4688f4fb5ab4ebdaab0b80a2d098349f073f602bcb2"; }];
    buildInputs = [ gcc-libs (assert stdenvNoCC.lib.versionAtLeast expat.version "2.1.0"; expat) (assert stdenvNoCC.lib.versionAtLeast freetype.version "2.3.11"; freetype) (assert stdenvNoCC.lib.versionAtLeast bzip2.version "1.0.6"; bzip2) libiconv ];
  };

  "fossil" = fetch {
    pname       = "fossil";
    version     = "2.6";
    srcs        = [{ filename = "mingw-w64-i686-fossil-2.6-2-any.pkg.tar.xz"; sha256 = "789d2391e2775537faef91814ff12ad59432331409bc936feb131853dd2312fc"; }];
    buildInputs = [ openssl readline sqlite3 zlib ];
  };

  "fox" = fetch {
    pname       = "fox";
    version     = "1.6.57";
    srcs        = [{ filename = "mingw-w64-i686-fox-1.6.57-1-any.pkg.tar.xz"; sha256 = "f7a5f444a726b4b23387065c92e97b0481a60f6721cada5af88267c8736dbe5d"; }];
    buildInputs = [ gcc-libs libtiff zlib libpng libjpeg-turbo ];
  };

  "freealut" = fetch {
    pname       = "freealut";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-freealut-1.1.0-1-any.pkg.tar.xz"; sha256 = "7c9d4e1d40ece6c505b391833b70bcdf1647469a8799366efe677299b333ce89"; }];
    buildInputs = [ openal ];
  };

  "freeglut" = fetch {
    pname       = "freeglut";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-i686-freeglut-3.0.0-4-any.pkg.tar.xz"; sha256 = "8ef4b641cd7b093fe6caf93ad11a1522bf05c05518ef525682730982af96ac42"; }];
    buildInputs = [  ];
  };

  "freeimage" = fetch {
    pname       = "freeimage";
    version     = "3.18.0";
    srcs        = [{ filename = "mingw-w64-i686-freeimage-3.18.0-2-any.pkg.tar.xz"; sha256 = "12bc6707cb4f1a6a1a9b239775f01c069e7a137f336f6c02bae03c9b010255ab"; }];
    buildInputs = [ gcc-libs jxrlib libjpeg-turbo libpng libtiff libraw libwebp openjpeg2 openexr ];
  };

  "freetds" = fetch {
    pname       = "freetds";
    version     = "1.00.98";
    srcs        = [{ filename = "mingw-w64-i686-freetds-1.00.98-1-any.pkg.tar.xz"; sha256 = "8bbb5b13d8eb78b2f6c752eef8f1507535af803dff45098dd28acadcafb45521"; }];
    buildInputs = [ gcc-libs openssl libiconv ];
  };

  "freetype" = fetch {
    pname       = "freetype";
    version     = "2.9.1";
    srcs        = [{ filename = "mingw-w64-i686-freetype-2.9.1-1-any.pkg.tar.xz"; sha256 = "e8df4eb86c7914b0edefe18949bffbf94bc4d1d2715b9d475b2a61f5905c4647"; }];
    buildInputs = [ gcc-libs bzip2 harfbuzz libpng zlib ];
  };

  "fribidi" = fetch {
    pname       = "fribidi";
    version     = "1.0.5";
    srcs        = [{ filename = "mingw-w64-i686-fribidi-1.0.5-1-any.pkg.tar.xz"; sha256 = "cd9cf00efb92f8bebac8a3290696ab96701abc3106cd83e9ac64ead7d1020280"; }];
    buildInputs = [  ];
  };

  "ftgl" = fetch {
    pname       = "ftgl";
    version     = "2.1.3rc5";
    srcs        = [{ filename = "mingw-w64-i686-ftgl-2.1.3rc5-2-any.pkg.tar.xz"; sha256 = "556b4a7bccc1bc9a997b9ed46412d299030008267660a77822bc10c15da6d5ed"; }];
    buildInputs = [ gcc-libs freetype ];
  };

  "gavl" = fetch {
    pname       = "gavl";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-i686-gavl-1.4.0-1-any.pkg.tar.xz"; sha256 = "7e0890c13a63ff0a4da7757705506e177bf7d467a188864f2d832335b937f423"; }];
    buildInputs = [ gcc-libs libpng ];
  };

  "gc" = fetch {
    pname       = "gc";
    version     = "7.6.8";
    srcs        = [{ filename = "mingw-w64-i686-gc-7.6.8-1-any.pkg.tar.xz"; sha256 = "369ed5ff5eeedbbac892d95b38646b5fad48d18b5ff5053f1cc7aaa7fb13addd"; }];
    buildInputs = [ gcc-libs libatomic_ops ];
  };

  "gcc" = fetch {
    pname       = "gcc";
    version     = "7.4.0";
    srcs        = [{ filename = "mingw-w64-i686-gcc-7.4.0-1-any.pkg.tar.xz"; sha256 = "8ff5c08f0b56a4aa595e98da212af402817b51a7800ae5f8f0b9de37842d8098"; }];
    buildInputs = [ binutils crt-git headers-git isl libiconv mpc (assert gcc-libs.version=="7.4.0"; gcc-libs) windows-default-manifest winpthreads-git zlib ];
  };

  "gcc-ada" = fetch {
    pname       = "gcc-ada";
    version     = "7.4.0";
    srcs        = [{ filename = "mingw-w64-i686-gcc-ada-7.4.0-1-any.pkg.tar.xz"; sha256 = "6c54a1b541363b868a55a753e7c85ebbcb68411bdb7ea2750195fb658b6a009d"; }];
    buildInputs = [ (assert gcc.version=="7.4.0"; gcc) ];
  };

  "gcc-fortran" = fetch {
    pname       = "gcc-fortran";
    version     = "7.4.0";
    srcs        = [{ filename = "mingw-w64-i686-gcc-fortran-7.4.0-1-any.pkg.tar.xz"; sha256 = "5d3965dfecd02612bb65329e4afd170ea1e1a590b3fffed01aa835d7e1b2e904"; }];
    buildInputs = [ (assert gcc.version=="7.4.0"; gcc) (assert gcc-libgfortran.version=="7.4.0"; gcc-libgfortran) ];
  };

  "gcc-libgfortran" = fetch {
    pname       = "gcc-libgfortran";
    version     = "7.4.0";
    srcs        = [{ filename = "mingw-w64-i686-gcc-libgfortran-7.4.0-1-any.pkg.tar.xz"; sha256 = "72686c314c4aec7ee20b01c4acf8578e95190b3598913c7a982aa0b8ad1def51"; }];
    buildInputs = [ (assert gcc-libs.version=="7.4.0"; gcc-libs) ];
  };

  "gcc-libs" = fetch {
    pname       = "gcc-libs";
    version     = "7.4.0";
    srcs        = [{ filename = "mingw-w64-i686-gcc-libs-7.4.0-1-any.pkg.tar.xz"; sha256 = "10f83a7bf788879ee8dabfb1827c2bc44b85dfbbad61ea2764286e2550db3d8c"; }];
    buildInputs = [ gmp mpc mpfr libwinpthread-git ];
  };

  "gcc-objc" = fetch {
    pname       = "gcc-objc";
    version     = "7.4.0";
    srcs        = [{ filename = "mingw-w64-i686-gcc-objc-7.4.0-1-any.pkg.tar.xz"; sha256 = "e1729c50f2458b738da085c93e6e70f4645f125504d3f4a968e76cfa7a2db51a"; }];
    buildInputs = [ (assert gcc.version=="7.4.0"; gcc) ];
  };

  "gd" = fetch {
    pname       = "gd";
    version     = "2.2.5";
    srcs        = [{ filename = "mingw-w64-i686-gd-2.2.5-3-any.pkg.tar.xz"; sha256 = "5d4eb70a061d557eeae109b7ecd35e71248a261dc3a7cd4ca14bd55566e75989"; }];
    buildInputs = [ fontconfig libiconv libjpeg libpng libtiff libvpx xpm-nox ];
  };

  "gdal" = fetch {
    pname       = "gdal";
    version     = "2.4.0";
    srcs        = [{ filename = "mingw-w64-i686-gdal-2.4.0-2-any.pkg.tar.xz"; sha256 = "10c47296191c17463300968124170a5a945536c971577ee500038479b3aa52b6"; }];
    buildInputs = [ cfitsio self."crypto++" curl expat geos giflib hdf5 jasper json-c libfreexl libgeotiff libiconv libjpeg libkml libpng libspatialite libtiff libwebp libxml2 netcdf openjpeg2 pcre poppler postgresql proj qhull-git sqlite3 xerces-c xz ];
  };

  "gdb" = fetch {
    pname       = "gdb";
    version     = "8.2.1";
    srcs        = [{ filename = "mingw-w64-i686-gdb-8.2.1-1-any.pkg.tar.xz"; sha256 = "3ec805947f318e398deffa08c14360016206691d6b0869d8d050c1ef285005d8"; }];
    buildInputs = [ expat libiconv python3 readline zlib ];
  };

  "gdbm" = fetch {
    pname       = "gdbm";
    version     = "1.18.1";
    srcs        = [{ filename = "mingw-w64-i686-gdbm-1.18.1-1-any.pkg.tar.xz"; sha256 = "ac0001152b3eb2b50d9980609bbc6a916b40ee06a4c6535c53a5a7395006cec2"; }];
    buildInputs = [ gcc-libs gettext libiconv ];
  };

  "gdcm" = fetch {
    pname       = "gdcm";
    version     = "2.8.8";
    srcs        = [{ filename = "mingw-w64-i686-gdcm-2.8.8-3-any.pkg.tar.xz"; sha256 = "28aa29fbbb1ebbf41a611960522dea5ded069c04d9ec0c531733efcb48d70c83"; }];
    buildInputs = [ expat gcc-libs lcms2 libxml2 json-c openssl poppler zlib ];
  };

  "gdk-pixbuf2" = fetch {
    pname       = "gdk-pixbuf2";
    version     = "2.38.0";
    srcs        = [{ filename = "mingw-w64-i686-gdk-pixbuf2-2.38.0-2-any.pkg.tar.xz"; sha256 = "03ec32809c30f20690b10c74f7f443103ce7d8b0e612fa79a663b30c17c1a38a"; }];
    buildInputs = [ gcc-libs (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.37.2"; glib2) jasper libjpeg-turbo libpng libtiff ];
  };

  "gdl" = fetch {
    pname       = "gdl";
    version     = "3.28.0";
    srcs        = [{ filename = "mingw-w64-i686-gdl-3.28.0-1-any.pkg.tar.xz"; sha256 = "58a46c9a88633c5252178e677e33a229373cdb0b5f8ba6af4ef5e4fcf2b884a3"; }];
    buildInputs = [ gtk3 libxml2 ];
  };

  "gdl2" = fetch {
    pname       = "gdl2";
    version     = "2.31.2";
    srcs        = [{ filename = "mingw-w64-i686-gdl2-2.31.2-2-any.pkg.tar.xz"; sha256 = "eed4c980a0b5f311c3c207835b47feafbcf136c81a50baf3dc08e665b9eb7098"; }];
    buildInputs = [ gtk2 libxml2 ];
  };

  "gdlmm2" = fetch {
    pname       = "gdlmm2";
    version     = "2.30.0";
    srcs        = [{ filename = "mingw-w64-i686-gdlmm2-2.30.0-2-any.pkg.tar.xz"; sha256 = "83a9e715ad71f611265e05db0eb514c7825d589ce2a9564deddb1cdb226df678"; }];
    buildInputs = [ gtk2 libxml2 ];
  };

  "geany" = fetch {
    pname       = "geany";
    version     = "1.34.0";
    srcs        = [{ filename = "mingw-w64-i686-geany-1.34.0-1-any.pkg.tar.xz"; sha256 = "e8d80bddc46fd0aaf055259058c6eaf7a4680a34da5ec3c5f747a0c08ec2bee7"; }];
    buildInputs = [ gtk3 adwaita-icon-theme ];
  };

  "geany-plugins" = fetch {
    pname       = "geany-plugins";
    version     = "1.34.0";
    srcs        = [{ filename = "mingw-w64-i686-geany-plugins-1.34.0-1-any.pkg.tar.xz"; sha256 = "7a8989ea9613baa1bbe55f274231be9d2db9ae07f83c847279c663f67045a0ef"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast geany.version "1.34.0"; geany) discount gtkspell3 webkitgtk3 ctpl-git gpgme lua51 gtk3 hicolor-icon-theme python2 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gedit" = fetch {
    pname       = "gedit";
    version     = "3.30.2";
    srcs        = [{ filename = "mingw-w64-i686-gedit-3.30.2-1-any.pkg.tar.xz"; sha256 = "672e49effda1fdedfe4b73a01f1c864ba6f7310419e3714ab216a7ecd01f6033"; }];
    buildInputs = [ adwaita-icon-theme enchant gsettings-desktop-schemas gtksourceview3 iso-codes libpeas python3-gobject gspell ];
  };

  "gedit-plugins" = fetch {
    pname       = "gedit-plugins";
    version     = "3.30.1";
    srcs        = [{ filename = "mingw-w64-i686-gedit-plugins-3.30.1-1-any.pkg.tar.xz"; sha256 = "99d049f2db99b005d5676b05eb405442d8568db5127ff6a185eb93d8fd58e1a8"; }];
    buildInputs = [ gedit libgit2-glib ];
  };

  "gegl" = fetch {
    pname       = "gegl";
    version     = "0.4.12";
    srcs        = [{ filename = "mingw-w64-i686-gegl-0.4.12-1-any.pkg.tar.xz"; sha256 = "44f99cd35e7e97d2a66a140970a32121019aa4d96e66f775209211c6d898656c"; }];
    buildInputs = [ babl cairo exiv2 gcc-libs gdk-pixbuf2 gettext glib2 gtk2 jasper json-glib libjpeg libpng LibRaw librsvg libspiro libwebp lcms lensfun openexr pango SDL suitesparse ];
    broken      = true; # broken dependency gegl -> LibRaw
  };

  "geoclue" = fetch {
    pname       = "geoclue";
    version     = "0.12.99";
    srcs        = [{ filename = "mingw-w64-i686-geoclue-0.12.99-3-any.pkg.tar.xz"; sha256 = "82c9ef565bf568b3449c2447176442544b51dc0b1869732c49de105979817584"; }];
    buildInputs = [ glib2 gtk2 libxml2 libxslt dbus-glib ];
  };

  "geocode-glib" = fetch {
    pname       = "geocode-glib";
    version     = "3.26.0";
    srcs        = [{ filename = "mingw-w64-i686-geocode-glib-3.26.0-1-any.pkg.tar.xz"; sha256 = "7b3f264601604408781308f42af73c16b956925097b64fed62e6671cd135e0d5"; }];
    buildInputs = [ glib2 json-glib libsoup ];
  };

  "geoip" = fetch {
    pname       = "geoip";
    version     = "1.6.12";
    srcs        = [{ filename = "mingw-w64-i686-geoip-1.6.12-1-any.pkg.tar.xz"; sha256 = "28ecc2751578272468cd2c5fa99946e99f3d7f2cd51e8269b1dcbd3862f17a25"; }];
    buildInputs = [ geoip2-database zlib ];
  };

  "geoip2-database" = fetch {
    pname       = "geoip2-database";
    version     = "20180522";
    srcs        = [{ filename = "mingw-w64-i686-geoip2-database-20180522-1-any.pkg.tar.xz"; sha256 = "f548b392f105ad6d8298118e46c270a49e24d2722fa09969046e9d0376fa5f8b"; }];
    buildInputs = [  ];
  };

  "geos" = fetch {
    pname       = "geos";
    version     = "3.7.1";
    srcs        = [{ filename = "mingw-w64-i686-geos-3.7.1-1-any.pkg.tar.xz"; sha256 = "a3b484fc8bafebe0ead33793d6e2904311d8024d635ddc0170ac55fd89104ea2"; }];
    buildInputs = [  ];
  };

  "gettext" = fetch {
    pname       = "gettext";
    version     = "0.19.8.1";
    srcs        = [{ filename = "mingw-w64-i686-gettext-0.19.8.1-7-any.pkg.tar.xz"; sha256 = "2d8358b9e24bddbdf67f37bc35538185869ec63274dc1dba6f634b6e7cd559fe"; }];
    buildInputs = [ expat gcc-libs libiconv ];
  };

  "gexiv2" = fetch {
    pname       = "gexiv2";
    version     = "0.10.9";
    srcs        = [{ filename = "mingw-w64-i686-gexiv2-0.10.9-1-any.pkg.tar.xz"; sha256 = "717405656d07ad887f0516024a21e166ffaec2cdbf0f4cae1739c41eeac42902"; }];
    buildInputs = [ glib2 exiv2 python2 ];
  };

  "gflags" = fetch {
    pname       = "gflags";
    version     = "2.2.2";
    srcs        = [{ filename = "mingw-w64-i686-gflags-2.2.2-1-any.pkg.tar.xz"; sha256 = "b7b46700f725c2b598e48e216d49c3db7e5cf13bb9b4ac763e382e338013971a"; }];
    buildInputs = [  ];
  };

  "ghex" = fetch {
    pname       = "ghex";
    version     = "3.18.3";
    srcs        = [{ filename = "mingw-w64-i686-ghex-3.18.3-1-any.pkg.tar.xz"; sha256 = "a3b606b3a9ceccffe39ef869e46477a2bc1d7f759428223f716d129f57289fd8"; }];
    buildInputs = [ gtk3 adwaita-icon-theme ];
  };

  "ghostscript" = fetch {
    pname       = "ghostscript";
    version     = "9.26";
    srcs        = [{ filename = "mingw-w64-i686-ghostscript-9.26-1-any.pkg.tar.xz"; sha256 = "3179dab5d1fa9e7e87f4b755b6e6b9ea234ce708ed4e18edde6b34ca2d1dac55"; }];
    buildInputs = [ dbus freetype fontconfig gdk-pixbuf2 libiconv libidn libpaper libpng libjpeg libtiff lcms2 openjpeg2 zlib ];
  };

  "giflib" = fetch {
    pname       = "giflib";
    version     = "5.1.4";
    srcs        = [{ filename = "mingw-w64-i686-giflib-5.1.4-2-any.pkg.tar.xz"; sha256 = "140942fd1c0a373c8d9f7402c43281d974899d73df40244f40597fb59bcbaafa"; }];
    buildInputs = [ gcc-libs ];
  };

  "gimp" = fetch {
    pname       = "gimp";
    version     = "2.10.8";
    srcs        = [{ filename = "mingw-w64-i686-gimp-2.10.8-3-any.pkg.tar.xz"; sha256 = "05b40460b251dc97a6c45f683e55af43351ff76528141649f39aec54816cb505"; }];
    buildInputs = [ babl curl dbus-glib drmingw gegl gexiv2 ghostscript hicolor-icon-theme jasper lcms2 libexif libmng libmypaint librsvg libwmf mypaint-brushes openexr poppler python2-pygtk python2-gobject xpm-nox ];
    broken      = true; # broken dependency gegl -> LibRaw
  };

  "gimp-ufraw" = fetch {
    pname       = "gimp-ufraw";
    version     = "0.22";
    srcs        = [{ filename = "mingw-w64-i686-gimp-ufraw-0.22-1-any.pkg.tar.xz"; sha256 = "a3568c20ef986469795bc0d4420166fabe3ed89d72d177ad6472102e988e15e3"; }];
    buildInputs = [ bzip2 cfitsio exiv2 gtkimageview lcms lensfun ];
  };

  "git-lfs" = fetch {
    pname       = "git-lfs";
    version     = "2.2.1";
    srcs        = [{ filename = "mingw-w64-i686-git-lfs-2.2.1-1-any.pkg.tar.xz"; sha256 = "c0b9e96c72d5b18e2ec8a201f4065203c66274c03a7eb064e9ee218ef67179eb"; }];
    buildInputs = [ git ];
    broken      = true; # broken dependency git-lfs -> git
  };

  "git-repo" = fetch {
    pname       = "git-repo";
    version     = "0.4.20";
    srcs        = [{ filename = "mingw-w64-i686-git-repo-0.4.20-1-any.pkg.tar.xz"; sha256 = "16f53560007670c53539d12a16e88c5922fe0e8471cd5e1e6cc448e92a19ba25"; }];
    buildInputs = [ python3 ];
  };

  "gitg" = fetch {
    pname       = "gitg";
    version     = "3.30.1";
    srcs        = [{ filename = "mingw-w64-i686-gitg-3.30.1-2-any.pkg.tar.xz"; sha256 = "ac8692689bc0721ac03c389f60861fc4af9bbed5260f57589c258c2e5cfc6544"; }];
    buildInputs = [ adwaita-icon-theme gtksourceview3 libpeas enchant iso-codes python3-gobject gsettings-desktop-schemas libsoup libsecret gtkspell3 libgit2-glib libgee ];
  };

  "gl2ps" = fetch {
    pname       = "gl2ps";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-i686-gl2ps-1.4.0-1-any.pkg.tar.xz"; sha256 = "22c0aaf39b8c3c3c766b681e3ac3fd31579f7edf88e2cafbc081f9bbbf502030"; }];
    buildInputs = [ libpng ];
  };

  "glade" = fetch {
    pname       = "glade";
    version     = "3.22.1";
    srcs        = [{ filename = "mingw-w64-i686-glade-3.22.1-1-any.pkg.tar.xz"; sha256 = "516f1d982e8cdeb8ab927b8d8c25faa740e42e436506d25b7f5bd1a79074be2f"; }];
    buildInputs = [ gtk3 libxml2 adwaita-icon-theme ];
  };

  "glade3" = fetch {
    pname       = "glade3";
    version     = "3.8.6";
    srcs        = [{ filename = "mingw-w64-i686-glade3-3.8.6-1-any.pkg.tar.xz"; sha256 = "181314499235716f7571f892672d89a193b08021f44b53919665f1cdc1dce1be"; }];
    buildInputs = [ gtk2 libxml2 ];
  };

  "glbinding" = fetch {
    pname       = "glbinding";
    version     = "3.0.2";
    srcs        = [{ filename = "mingw-w64-i686-glbinding-3.0.2-2-any.pkg.tar.xz"; sha256 = "9c4f99ce6f778dd96c0a4f34fd705e1104760e8bfa98ac73bb8f66ec529a86f0"; }];
    buildInputs = [ gcc-libs ];
  };

  "glew" = fetch {
    pname       = "glew";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-i686-glew-2.1.0-1-any.pkg.tar.xz"; sha256 = "3ec0aa501c921845440503c7ae57787b02a45746effc11ced5c34d3aabfc8039"; }];
    buildInputs = [  ];
  };

  "glfw" = fetch {
    pname       = "glfw";
    version     = "3.2.1";
    srcs        = [{ filename = "mingw-w64-i686-glfw-3.2.1-2-any.pkg.tar.xz"; sha256 = "55c8262810e87de8b608725d8b0092277600583312610294f8c73a64f7e3d08b"; }];
    buildInputs = [ gcc-libs ];
  };

  "glib-networking" = fetch {
    pname       = "glib-networking";
    version     = "2.58.0";
    srcs        = [{ filename = "mingw-w64-i686-glib-networking-2.58.0-2-any.pkg.tar.xz"; sha256 = "3ed3a6676aead6f73df955273d6ef75e86fbad7cf0841dbad946d9edbe620e25"; }];
    buildInputs = [ gcc-libs gettext glib2 gnutls ];
  };

  "glib-openssl" = fetch {
    pname       = "glib-openssl";
    version     = "2.50.8";
    srcs        = [{ filename = "mingw-w64-i686-glib-openssl-2.50.8-2-any.pkg.tar.xz"; sha256 = "c49b91790c9268202ddc65bb25dd9f9d9d028aabaf2cfff14adb1bf4cb211789"; }];
    buildInputs = [ glib2 openssl ];
  };

  "glib2" = fetch {
    pname       = "glib2";
    version     = "2.58.2";
    srcs        = [{ filename = "mingw-w64-i686-glib2-2.58.2-1-any.pkg.tar.xz"; sha256 = "a433c78f095d948da0afd67398d1653280ae245398ef976f8b826932f2768ebc"; }];
    buildInputs = [ gcc-libs gettext pcre libffi zlib python3 ];
  };

  "glibmm" = fetch {
    pname       = "glibmm";
    version     = "2.58.0";
    srcs        = [{ filename = "mingw-w64-i686-glibmm-2.58.0-1-any.pkg.tar.xz"; sha256 = "04b9bcc46a3e469a1fb2866bfec4d57a22d67daaba0e1a0eb943c21e3cd4ca68"; }];
    buildInputs = [ self."libsigc++" glib2 ];
  };

  "glm" = fetch {
    pname       = "glm";
    version     = "0.9.9.3";
    srcs        = [{ filename = "mingw-w64-i686-glm-0.9.9.3-2-any.pkg.tar.xz"; sha256 = "0586a85cc0fc8b2349cb47d768ad306a5802fcd627a7f1eb524b8191333a1eed"; }];
    buildInputs = [ gcc-libs ];
  };

  "global" = fetch {
    pname       = "global";
    version     = "6.6.2";
    srcs        = [{ filename = "mingw-w64-i686-global-6.6.2-2-any.pkg.tar.xz"; sha256 = "9cc95bd10560af7fef24fee2eb7273583f9fcfd73c9341802fd9251d087b57c5"; }];
  };

  "globjects" = fetch {
    pname       = "globjects";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-globjects-1.1.0-1-any.pkg.tar.xz"; sha256 = "41a71b45b0ca7427356fa142461b088790f207dfbd39899974a796efefefc525"; }];
    buildInputs = [ gcc-libs glbinding glm ];
  };

  "glog" = fetch {
    pname       = "glog";
    version     = "0.3.5";
    srcs        = [{ filename = "mingw-w64-i686-glog-0.3.5-1-any.pkg.tar.xz"; sha256 = "82eaaa38f95acc12f35fa080876c9b0993a1bd197db4efbdbb260ade7bd9c330"; }];
    buildInputs = [ gflags ];
  };

  "glpk" = fetch {
    pname       = "glpk";
    version     = "4.65";
    srcs        = [{ filename = "mingw-w64-i686-glpk-4.65-1-any.pkg.tar.xz"; sha256 = "65d8294d9d8ca04a8372866171995867dd6a470b5bb1fdd0e04e3ac2cb2d7cfa"; }];
    buildInputs = [ gmp ];
  };

  "glsl-optimizer-git" = fetch {
    pname       = "glsl-optimizer-git";
    version     = "r66914.9a2852138d";
    srcs        = [{ filename = "mingw-w64-i686-glsl-optimizer-git-r66914.9a2852138d-1-any.pkg.tar.xz"; sha256 = "bab09eca3f1bf427158ec8d3961982fa36520676efbfb8a6fb38c699ae9aa12c"; }];
  };

  "glslang" = fetch {
    pname       = "glslang";
    version     = "7.10.2984";
    srcs        = [{ filename = "mingw-w64-i686-glslang-7.10.2984-1-any.pkg.tar.xz"; sha256 = "2e7a275634659223c1423b6dfbcd7aa12a4d8099362248ab19437c13dc92db98"; }];
    buildInputs = [ gcc-libs ];
  };

  "gmime" = fetch {
    pname       = "gmime";
    version     = "3.2.2";
    srcs        = [{ filename = "mingw-w64-i686-gmime-3.2.2-1-any.pkg.tar.xz"; sha256 = "09f0e4aef9f5a1239ba8a6986e2799ef652f240f5dfdb07817099f7feb9d20fb"; }];
    buildInputs = [ glib2 libiconv ];
  };

  "gmp" = fetch {
    pname       = "gmp";
    version     = "6.1.2";
    srcs        = [{ filename = "mingw-w64-i686-gmp-6.1.2-1-any.pkg.tar.xz"; sha256 = "e9500a94beffd8517621821787c35ee207cc638f9f17ba07ffa7f7d1a3fba777"; }];
    buildInputs = [  ];
  };

  "gnome-calculator" = fetch {
    pname       = "gnome-calculator";
    version     = "3.16.2";
    srcs        = [{ filename = "mingw-w64-i686-gnome-calculator-3.16.2-1-any.pkg.tar.xz"; sha256 = "f97bbb54ff104b17ed6127fb777b845bbb753a7db931e2d0912950d914959bbf"; }];
    buildInputs = [ glib2 gtk3 gtksourceview3 gsettings-desktop-schemas libxml2 mpfr ];
  };

  "gnome-common" = fetch {
    pname       = "gnome-common";
    version     = "3.18.0";
    srcs        = [{ filename = "mingw-w64-i686-gnome-common-3.18.0-1-any.pkg.tar.xz"; sha256 = "e782a790331591237a2364daf903ab4a92d374c24c456156b5ccd1ba7930b1c2"; }];
  };

  "gnome-latex" = fetch {
    pname       = "gnome-latex";
    version     = "3.28.1";
    srcs        = [{ filename = "mingw-w64-i686-gnome-latex-3.28.1-2-any.pkg.tar.xz"; sha256 = "c810422790572d2d0c8517539a770c0a30b69d3f442d62c7927b8937298fb9a1"; }];
    buildInputs = [ gsettings-desktop-schemas gtk3 gtksourceview4 gspell tepl4 libgee ];
  };

  "gnu-cobol-svn" = fetch {
    pname       = "gnu-cobol-svn";
    version     = "2.0.r1454";
    srcs        = [{ filename = "mingw-w64-i686-gnu-cobol-svn-2.0.r1454-1-any.pkg.tar.xz"; sha256 = "e22c01d48a9e4b87eddb649eeddb361c77b08185356d3b962223f80e25ac65c0"; }];
    buildInputs = [ db gmp ncurses ];
  };

  "gnucobol" = fetch {
    pname       = "gnucobol";
    version     = "3.0rc1";
    srcs        = [{ filename = "mingw-w64-i686-gnucobol-3.0rc1-0-any.pkg.tar.xz"; sha256 = "983eb56675ad9420766e883df8f542706e906454333e93018c63901280fdf48c"; }];
    buildInputs = [ gcc gmp gettext ncurses db ];
  };

  "gnupg" = fetch {
    pname       = "gnupg";
    version     = "2.2.12";
    srcs        = [{ filename = "mingw-w64-i686-gnupg-2.2.12-1-any.pkg.tar.xz"; sha256 = "24f57845061643845170c596e7114c34485352ea0311558c9465932bbb3d3fce"; }];
    buildInputs = [ adns bzip2 curl gnutls libksba libgcrypt libassuan libsystre libusb-compat-git npth readline sqlite3 zlib ];
  };

  "gnuplot" = fetch {
    pname       = "gnuplot";
    version     = "5.2.5";
    srcs        = [{ filename = "mingw-w64-i686-gnuplot-5.2.5-1-any.pkg.tar.xz"; sha256 = "00bfe67fb7baaaf3e15f46b9d63b63a49f7fe9505022cbad30d1a01f2b37ba20"; }];
    buildInputs = [ cairo gnutls libcaca libcerf libgd pango readline wxWidgets ];
  };

  "gnutls" = fetch {
    pname       = "gnutls";
    version     = "3.6.5";
    srcs        = [{ filename = "mingw-w64-i686-gnutls-3.6.5-2-any.pkg.tar.xz"; sha256 = "83b604b74e5b75f8e4c36828265b8a3cfea643a4f52d29c4cfa9810d456155d5"; }];
    buildInputs = [ gcc-libs gmp libidn2 libsystre libtasn1 (assert stdenvNoCC.lib.versionAtLeast nettle.version "3.1"; nettle) (assert stdenvNoCC.lib.versionAtLeast p11-kit.version "0.23.1"; p11-kit) libunistring zlib ];
  };

  "go" = fetch {
    pname       = "go";
    version     = "1.11.4";
    srcs        = [{ filename = "mingw-w64-i686-go-1.11.4-1-any.pkg.tar.xz"; sha256 = "1a4685f455f8fe11261a4b54c7bf54d12951c95039fc43feee67ce0aea65e2e7"; }];
  };

  "gobject-introspection" = fetch {
    pname       = "gobject-introspection";
    version     = "1.58.2";
    srcs        = [{ filename = "mingw-w64-i686-gobject-introspection-1.58.2-1-any.pkg.tar.xz"; sha256 = "8f924f2759a7a69c83e9d237a0f9d3421271c839a995d0c9d22e266bf7217b09"; }];
    buildInputs = [ (assert gobject-introspection-runtime.version=="1.58.2"; gobject-introspection-runtime) pkg-config python3 python3-mako ];
  };

  "gobject-introspection-runtime" = fetch {
    pname       = "gobject-introspection-runtime";
    version     = "1.58.2";
    srcs        = [{ filename = "mingw-w64-i686-gobject-introspection-runtime-1.58.2-1-any.pkg.tar.xz"; sha256 = "ca0fe6d2ec54617a70816dac68ebe5c832a81df9e7a6c5db3c5d9e967e607069"; }];
    buildInputs = [ glib2 ];
  };

  "goocanvas" = fetch {
    pname       = "goocanvas";
    version     = "2.0.4";
    srcs        = [{ filename = "mingw-w64-i686-goocanvas-2.0.4-1-any.pkg.tar.xz"; sha256 = "3cdb2e3b8fedd7f5c8bd98d31a6655854b279027df2389d87c54c40b8ca36abe"; }];
    buildInputs = [ gtk3 ];
  };

  "googletest-git" = fetch {
    pname       = "googletest-git";
    version     = "r975.aa148eb";
    srcs        = [{ filename = "mingw-w64-i686-googletest-git-r975.aa148eb-1-any.pkg.tar.xz"; sha256 = "1f72550ccb01138352ce5b170a985329888c3422fb0084ab90ab5fb2e8d254cd"; }];
  };

  "gperf" = fetch {
    pname       = "gperf";
    version     = "3.1";
    srcs        = [{ filename = "mingw-w64-i686-gperf-3.1-1-any.pkg.tar.xz"; sha256 = "24d7ad4995528201c35c6ec68a431f6963bc45d79149ad8f92d33cc2653b7971"; }];
    buildInputs = [ gcc-libs ];
  };

  "gpgme" = fetch {
    pname       = "gpgme";
    version     = "1.12.0";
    srcs        = [{ filename = "mingw-w64-i686-gpgme-1.12.0-1-any.pkg.tar.xz"; sha256 = "2ee44525734ba4eca8661002eb0cda33a9043b7079702f9d2eba8ed4ab53e4f7"; }];
    buildInputs = [ glib2 gnupg libassuan libgpg-error npth ];
  };

  "gphoto2" = fetch {
    pname       = "gphoto2";
    version     = "2.5.20";
    srcs        = [{ filename = "mingw-w64-i686-gphoto2-2.5.20-1-any.pkg.tar.xz"; sha256 = "ccdb71cd12ed57770b0c816a380fde9fc906b8d6a4b21a4cadfb8d7cc77be070"; }];
    buildInputs = [ libgphoto2 popt ];
  };

  "gplugin" = fetch {
    pname       = "gplugin";
    version     = "0.27.0";
    srcs        = [{ filename = "mingw-w64-i686-gplugin-0.27.0-1-any.pkg.tar.xz"; sha256 = "89cfaf23db1de7c8eb8bbbcc46d310fa8258ad1f9bf0c471969fa20bd4a53cfe"; }];
    buildInputs = [ gtk3 ];
  };

  "gprbuild-bootstrap-git" = fetch {
    pname       = "gprbuild-bootstrap-git";
    version     = "r3206.f95f0c68";
    srcs        = [{ filename = "mingw-w64-i686-gprbuild-bootstrap-git-r3206.f95f0c68-1-any.pkg.tar.xz"; sha256 = "2b519837bc38defca74e9e28b802ddacac13dea107eff79c550a220432794568"; }];
    buildInputs = [ gcc-libs ];
  };

  "graphene" = fetch {
    pname       = "graphene";
    version     = "1.8.2";
    srcs        = [{ filename = "mingw-w64-i686-graphene-1.8.2-1-any.pkg.tar.xz"; sha256 = "0730542fb3f936b1cb9b4465371a14f85df1ec517c08fdccf40e7850f8f8c272"; }];
    buildInputs = [ glib2 ];
  };

  "graphicsmagick" = fetch {
    pname       = "graphicsmagick";
    version     = "1.3.31";
    srcs        = [{ filename = "mingw-w64-i686-graphicsmagick-1.3.31-1-any.pkg.tar.xz"; sha256 = "1b3171e97559e4e15f7792ad8695afe23e6b5b9cddcb8aa2bb480677f1e0d3cc"; }];
    buildInputs = [ bzip2 fontconfig freetype gcc-libs glib2 jbigkit lcms2 libtool libwinpthread-git xz zlib ];
  };

  "graphite2" = fetch {
    pname       = "graphite2";
    version     = "1.3.13";
    srcs        = [{ filename = "mingw-w64-i686-graphite2-1.3.13-1-any.pkg.tar.xz"; sha256 = "e8e9576feeda7f02b5ba8a89ef0e6fee98b84ba93c4d744a6c70379985dcccb7"; }];
    buildInputs = [ gcc-libs ];
  };

  "graphviz" = fetch {
    pname       = "graphviz";
    version     = "2.40.1";
    srcs        = [{ filename = "mingw-w64-i686-graphviz-2.40.1-5-any.pkg.tar.xz"; sha256 = "0437f4eebb16c4b15518d9312802043bed8d3658fb599e5626f775ffe25b0bd0"; }];
    buildInputs = [ cairo devil expat freetype glib2 gtk2 gtkglext fontconfig freeglut libglade libgd libpng libsystre libwebp pango poppler zlib libtool ];
  };

  "grpc" = fetch {
    pname       = "grpc";
    version     = "1.17.2";
    srcs        = [{ filename = "mingw-w64-i686-grpc-1.17.2-1-any.pkg.tar.xz"; sha256 = "b57f2dd1e922c84b9eae6806f0aac3a116f79d8b6b265b7258887a43ba18e87d"; }];
    buildInputs = [ gcc-libs c-ares gflags openssl (assert stdenvNoCC.lib.versionAtLeast protobuf.version "3.5.0"; protobuf) zlib ];
  };

  "gsasl" = fetch {
    pname       = "gsasl";
    version     = "1.8.0";
    srcs        = [{ filename = "mingw-w64-i686-gsasl-1.8.0-4-any.pkg.tar.xz"; sha256 = "cdebb9efc65c51b088b0f021f2e91d6fe12f164ac2552aecfa0b54f06f6c646d"; }];
    buildInputs = [ gss gnutls libidn libgcrypt libntlm readline ];
  };

  "gsettings-desktop-schemas" = fetch {
    pname       = "gsettings-desktop-schemas";
    version     = "3.28.1";
    srcs        = [{ filename = "mingw-w64-i686-gsettings-desktop-schemas-3.28.1-1-any.pkg.tar.xz"; sha256 = "6647a1efca204f93e2319b612a4d298288c6d2c502d2602b121c3c851273e377"; }];
    buildInputs = [ glib2 ];
  };

  "gsfonts" = fetch {
    pname       = "gsfonts";
    version     = "20180524";
    srcs        = [{ filename = "mingw-w64-i686-gsfonts-20180524-1-any.pkg.tar.xz"; sha256 = "6605f5854ad8e51797cc22a96b43c5d3928971af98724d3ccdbfefa65b67ae7a"; }];
    buildInputs = [  ];
  };

  "gsl" = fetch {
    pname       = "gsl";
    version     = "2.5";
    srcs        = [{ filename = "mingw-w64-i686-gsl-2.5-1-any.pkg.tar.xz"; sha256 = "3366823c59ac2a959a0a08584d6fa6c17212e55c5f804381d75dc70a9969b255"; }];
    buildInputs = [  ];
  };

  "gsm" = fetch {
    pname       = "gsm";
    version     = "1.0.18";
    srcs        = [{ filename = "mingw-w64-i686-gsm-1.0.18-1-any.pkg.tar.xz"; sha256 = "d3663919021d774eb5bb17d30f01d31aaef487c226ce29d9220d4b461104da6f"; }];
    buildInputs = [  ];
  };

  "gsoap" = fetch {
    pname       = "gsoap";
    version     = "2.8.74";
    srcs        = [{ filename = "mingw-w64-i686-gsoap-2.8.74-1-any.pkg.tar.xz"; sha256 = "e31eb51489546a6d1d04ad8bcec8a62a388fe56da94ffcdccc9c3f9dd429375c"; }];
  };

  "gspell" = fetch {
    pname       = "gspell";
    version     = "1.8.1";
    srcs        = [{ filename = "mingw-w64-i686-gspell-1.8.1-1-any.pkg.tar.xz"; sha256 = "b7c1060cb502c8505724b3ca0811530bf44f991bd930a2f859b05c6bbce0294e"; }];
    buildInputs = [ gsettings-desktop-schemas gtk3 gtksourceview3 iso-codes enchant libxml2 ];
  };

  "gss" = fetch {
    pname       = "gss";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-i686-gss-1.0.3-1-any.pkg.tar.xz"; sha256 = "abaef426e612be0388cc31ba8164a9a2998dcf44534cf3d158992f658bb1a7c8"; }];
    buildInputs = [ gcc-libs shishi-git ];
  };

  "gst-editing-services" = fetch {
    pname       = "gst-editing-services";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-i686-gst-editing-services-1.14.4-1-any.pkg.tar.xz"; sha256 = "c4101249586adc6d2ffac67c9fa8f58ee391b651de632939a83f2c142025dae3"; }];
    buildInputs = [ gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-libav" = fetch {
    pname       = "gst-libav";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-i686-gst-libav-1.14.4-1-any.pkg.tar.xz"; sha256 = "8d2b3494da4431c16a41998d89af95e3f3de05772b0bed8797658a1c29a8267d"; }];
    buildInputs = [ gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-bad" = fetch {
    pname       = "gst-plugins-bad";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-i686-gst-plugins-bad-1.14.4-3-any.pkg.tar.xz"; sha256 = "48c6e57beea30c4c32bdcb31c61ed5c96151ea0310816f27a24e3d9dc414413f"; }];
    buildInputs = [ bzip2 cairo chromaprint curl daala-git faad2 faac fdk-aac fluidsynth gsm gst-plugins-base gtk3 ladspa-sdk lcms2 libass libbs2b libdca libdvdnav libdvdread libexif libgme libjpeg libmodplug libmpeg2-git libnice librsvg libsndfile libsrtp libssh2 libwebp libxml2 nettle openal opencv openexr openh264 openjpeg2 openssl opus orc pango rtmpdump-git soundtouch srt vo-amrwbenc x265 zbar ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-base" = fetch {
    pname       = "gst-plugins-base";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-i686-gst-plugins-base-1.14.4-1-any.pkg.tar.xz"; sha256 = "35101f8be32e74f207f49c045e122356eec06bc8c06e2f50386e88d8ed8875d3"; }];
    buildInputs = [ graphene gstreamer libogg libtheora libvorbis libvorbisidec opus orc pango zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-good" = fetch {
    pname       = "gst-plugins-good";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-i686-gst-plugins-good-1.14.4-1-any.pkg.tar.xz"; sha256 = "18ff8a4d1cbd51e27ff695fb112fe09f1f589a85f66e39c9d791b52fe19eabc0"; }];
    buildInputs = [ bzip2 cairo flac gdk-pixbuf2 gst-plugins-base gtk3 lame libcaca libjpeg libpng libshout libsoup libvpx mpg123 speex taglib twolame wavpack zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-ugly" = fetch {
    pname       = "gst-plugins-ugly";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-i686-gst-plugins-ugly-1.14.4-1-any.pkg.tar.xz"; sha256 = "a41b5d2138e1d57240eb76767e4aab12bb7d706ee9653166ab7f174aed22c75e"; }];
    buildInputs = [ a52dec gst-plugins-base libcdio libdvdread libmpeg2-git opencore-amr x264-git ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-python" = fetch {
    pname       = "gst-python";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-i686-gst-python-1.14.4-1-any.pkg.tar.xz"; sha256 = "4d391dcf863fb40f7b2e9323fb0fd0eaf90e1e7c7edac679bbed9aaa4ffa0e85"; }];
    buildInputs = [ gstreamer python3-gobject ];
  };

  "gst-python2" = fetch {
    pname       = "gst-python2";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-i686-gst-python2-1.14.4-1-any.pkg.tar.xz"; sha256 = "9994664219f81f6bed33d4f4f947e490d8c00339a093be81ec3c0fe7bf3e9270"; }];
    buildInputs = [ gstreamer python2-gobject ];
  };

  "gst-rtsp-server" = fetch {
    pname       = "gst-rtsp-server";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-i686-gst-rtsp-server-1.14.4-1-any.pkg.tar.xz"; sha256 = "b0e463bb94f7bcaf90f603b6d82b8b7ddcc6e9673bb623f433852f2e90823ecf"; }];
    buildInputs = [ gcc-libs glib2 gettext gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gstreamer" = fetch {
    pname       = "gstreamer";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-i686-gstreamer-1.14.4-1-any.pkg.tar.xz"; sha256 = "8cb5661be292b41e1aeb9f832753d729a1956dbce1dce3555f291ab8b59d766e"; }];
    buildInputs = [ gcc-libs libxml2 glib2 gettext gmp gsl ];
  };

  "gtef" = fetch {
    pname       = "gtef";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-i686-gtef-2.0.1-1-any.pkg.tar.xz"; sha256 = "f47ce6cbcbf83f2c93aa46655e538c0ec4d2ecf420a2c57cbe4cfe2b777c1c8f"; }];
    buildInputs = [ glib2 gtk3 gtksourceview3 uchardet libxml2 ];
  };

  "gtest" = fetch {
    pname       = "gtest";
    version     = "1.8.1";
    srcs        = [{ filename = "mingw-w64-i686-gtest-1.8.1-2-any.pkg.tar.xz"; sha256 = "e910d1ae883b72c23c61bcb493b30a9a66359a9778988fdcbac7d24783b35bde"; }];
    buildInputs = [ gcc-libs ];
  };

  "gtk-doc" = fetch {
    pname       = "gtk-doc";
    version     = "1.29";
    srcs        = [{ filename = "mingw-w64-i686-gtk-doc-1.29-1-any.pkg.tar.xz"; sha256 = "76565d9ff8514acdc12c8c53bbd62a49897b4d86a2e649738d58933bff5a1b9b"; }];
    buildInputs = [ docbook-xsl docbook-xml libxslt python3 ];
  };

  "gtk-engine-murrine" = fetch {
    pname       = "gtk-engine-murrine";
    version     = "0.98.2";
    srcs        = [{ filename = "mingw-w64-i686-gtk-engine-murrine-0.98.2-2-any.pkg.tar.xz"; sha256 = "8991d38e45163856112712efe9a1fb45692958365380406749a91aa632424683"; }];
    buildInputs = [ gtk2 ];
  };

  "gtk-engines" = fetch {
    pname       = "gtk-engines";
    version     = "2.21.0";
    srcs        = [{ filename = "mingw-w64-i686-gtk-engines-2.21.0-2-any.pkg.tar.xz"; sha256 = "c85a75b2caf33a4b4a519764aff439eb6940bc41738cc844ce3dc14073cb5a93"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) ];
  };

  "gtk-vnc" = fetch {
    pname       = "gtk-vnc";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-i686-gtk-vnc-0.9.0-1-any.pkg.tar.xz"; sha256 = "301de6ff66e21fe070dedf2aaa57f6b5fe9dd93b432064df30c91fc25b6d8891"; }];
    buildInputs = [ cyrus-sasl gnutls gtk3 libgcrypt libgpg-error libview zlib ];
  };

  "gtk2" = fetch {
    pname       = "gtk2";
    version     = "2.24.32";
    srcs        = [{ filename = "mingw-w64-i686-gtk2-2.24.32-3-any.pkg.tar.xz"; sha256 = "bc8c8a8286bebbf65fef61c771f53b7c08e77b5491d9b672db9872f6b04aa5cf"; }];
    buildInputs = [ gcc-libs adwaita-icon-theme (assert stdenvNoCC.lib.versionAtLeast atk.version "1.29.2"; atk) (assert stdenvNoCC.lib.versionAtLeast cairo.version "1.6"; cairo) (assert stdenvNoCC.lib.versionAtLeast gdk-pixbuf2.version "2.21.0"; gdk-pixbuf2) (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.28.0"; glib2) (assert stdenvNoCC.lib.versionAtLeast pango.version "1.20"; pango) shared-mime-info ];
  };

  "gtk3" = fetch {
    pname       = "gtk3";
    version     = "3.24.2";
    srcs        = [{ filename = "mingw-w64-i686-gtk3-3.24.2-1-any.pkg.tar.xz"; sha256 = "3aa142ec2ab5dab8e9a1b586551a857a935237c941303ba7bdd39cd7afa2f407"; }];
    buildInputs = [ gcc-libs adwaita-icon-theme atk cairo gdk-pixbuf2 glib2 json-glib libepoxy pango shared-mime-info ];
  };

  "gtkglext" = fetch {
    pname       = "gtkglext";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-gtkglext-1.2.0-3-any.pkg.tar.xz"; sha256 = "00683a439a025da4ceb27c91f7232aca39573d680726fb406b0c3c46ba2204d6"; }];
    buildInputs = [ gcc-libs gtk2 gdk-pixbuf2 ];
  };

  "gtkimageview" = fetch {
    pname       = "gtkimageview";
    version     = "1.6.4";
    srcs        = [{ filename = "mingw-w64-i686-gtkimageview-1.6.4-3-any.pkg.tar.xz"; sha256 = "024a3351c87d4d3869d7f8bf09cd7d5249ebc587b91bb2a1f7e0f99c9f317597"; }];
    buildInputs = [ gtk2 ];
  };

  "gtkmm" = fetch {
    pname       = "gtkmm";
    version     = "2.24.5";
    srcs        = [{ filename = "mingw-w64-i686-gtkmm-2.24.5-2-any.pkg.tar.xz"; sha256 = "25e1dc076835c7dd6220ab0cacd8b10ea52e2f75fc28d89063d9696624b3ad47"; }];
    buildInputs = [ atkmm pangomm gtk2 ];
  };

  "gtkmm3" = fetch {
    pname       = "gtkmm3";
    version     = "3.24.0";
    srcs        = [{ filename = "mingw-w64-i686-gtkmm3-3.24.0-1-any.pkg.tar.xz"; sha256 = "a101ec8711745f1e08f0588b531a822406eef07c0c92ac57f050a9ed96a8eef3"; }];
    buildInputs = [ gcc-libs atkmm pangomm gtk3 ];
  };

  "gtksourceview2" = fetch {
    pname       = "gtksourceview2";
    version     = "2.10.5";
    srcs        = [{ filename = "mingw-w64-i686-gtksourceview2-2.10.5-3-any.pkg.tar.xz"; sha256 = "c92a789e32c2f4eb7b6a75b268f3f026d21a321e961994693e49f311f74fbe0c"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.7"; libxml2) ];
  };

  "gtksourceview3" = fetch {
    pname       = "gtksourceview3";
    version     = "3.24.9";
    srcs        = [{ filename = "mingw-w64-i686-gtksourceview3-3.24.9-1-any.pkg.tar.xz"; sha256 = "db0afe8540b286ec533fc0fc528e57be08601076069ad2910cc631aff4059990"; }];
    buildInputs = [ gtk3 libxml2 ];
  };

  "gtksourceview4" = fetch {
    pname       = "gtksourceview4";
    version     = "4.0.3";
    srcs        = [{ filename = "mingw-w64-i686-gtksourceview4-4.0.3-1-any.pkg.tar.xz"; sha256 = "fbe7d4914d656bc13244f92d3b020cd1d9d041f64db54e43b611c70a98f04743"; }];
    buildInputs = [ gtk3 libxml2 ];
  };

  "gtksourceviewmm2" = fetch {
    pname       = "gtksourceviewmm2";
    version     = "2.10.3";
    srcs        = [{ filename = "mingw-w64-i686-gtksourceviewmm2-2.10.3-2-any.pkg.tar.xz"; sha256 = "36c224e5d09e771689aaeeb80aa236d877849fa74b8b8e6c51aee6be88cb6c7d"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.7"; libxml2) ];
  };

  "gtksourceviewmm3" = fetch {
    pname       = "gtksourceviewmm3";
    version     = "3.21.3";
    srcs        = [{ filename = "mingw-w64-i686-gtksourceviewmm3-3.21.3-2-any.pkg.tar.xz"; sha256 = "3379233b9a0026d86b36f4c5bfc1bcd4353e34291897f943381283d10152a8ba"; }];
    buildInputs = [ gtksourceview3 gtkmm3 ];
  };

  "gtkspell" = fetch {
    pname       = "gtkspell";
    version     = "2.0.16";
    srcs        = [{ filename = "mingw-w64-i686-gtkspell-2.0.16-7-any.pkg.tar.xz"; sha256 = "52778f82a4a6a5eb1b912c17f915cbb0ab620ce6667585202d65566901a4f80a"; }];
    buildInputs = [ gtk2 enchant ];
  };

  "gtkspell3" = fetch {
    pname       = "gtkspell3";
    version     = "3.0.10";
    srcs        = [{ filename = "mingw-w64-i686-gtkspell3-3.0.10-1-any.pkg.tar.xz"; sha256 = "729085b2984ff00cbc1d3079ec3856cf9bd731dc6c4c0d8a54a03eb7f93df68f"; }];
    buildInputs = [ gtk3 gtk2 enchant ];
  };

  "gtkwave" = fetch {
    pname       = "gtkwave";
    version     = "3.3.79";
    srcs        = [{ filename = "mingw-w64-i686-gtkwave-3.3.79-1-any.pkg.tar.xz"; sha256 = "ce0c1c574364b0fc0960847fb77bba0825ebd89833b9138fcf0764fecac32eda"; }];
    buildInputs = [ gtk2 tk tklib tcl tcllib adwaita-icon-theme ];
  };

  "gts" = fetch {
    pname       = "gts";
    version     = "0.7.6";
    srcs        = [{ filename = "mingw-w64-i686-gts-0.7.6-1-any.pkg.tar.xz"; sha256 = "f039fd0a555b6b0fc3dd2dd6d1213c0fd943a531cf1c3c562f1beb9840a0531d"; }];
    buildInputs = [ glib2 ];
  };

  "gumbo-parser" = fetch {
    pname       = "gumbo-parser";
    version     = "0.10.1";
    srcs        = [{ filename = "mingw-w64-i686-gumbo-parser-0.10.1-1-any.pkg.tar.xz"; sha256 = "c79f466543b66009e9378ebb7c9362e32f78c0e0463c9cb1858ffb7220d51d95"; }];
  };

  "gxml" = fetch {
    pname       = "gxml";
    version     = "0.16.3";
    srcs        = [{ filename = "mingw-w64-i686-gxml-0.16.3-1-any.pkg.tar.xz"; sha256 = "16ced0205f0802a48be9e83e312057a0ee343c415b49d8493506900d48a5d330"; }];
    buildInputs = [ gcc-libs gettext (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.34.0"; glib2) libgee libxml2 xz zlib ];
  };

  "harfbuzz" = fetch {
    pname       = "harfbuzz";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-harfbuzz-2.3.0-1-any.pkg.tar.xz"; sha256 = "c18830b82bbbfccd6dc22649fa9e5bf901c9cc6976ee26eb2758f73e7d3e8aff"; }];
    buildInputs = [ freetype gcc-libs glib2 graphite2 ];
  };

  "hclient-git" = fetch {
    pname       = "hclient-git";
    version     = "233.8b17cf3";
    srcs        = [{ filename = "mingw-w64-i686-hclient-git-233.8b17cf3-1-any.pkg.tar.xz"; sha256 = "1d2f63b7fb505786ea97006a13fc251016582d9932c2f87930a9fc7f916715f9"; }];
  };

  "hdf4" = fetch {
    pname       = "hdf4";
    version     = "4.2.14";
    srcs        = [{ filename = "mingw-w64-i686-hdf4-4.2.14-1-any.pkg.tar.xz"; sha256 = "f0c109636c3ff9ac4c6e9112100d170d20503d1129fb29089c2defe51d0aaef3"; }];
    buildInputs = [ libjpeg-turbo gcc-libgfortran zlib ];
  };

  "hdf5" = fetch {
    pname       = "hdf5";
    version     = "1.8.21";
    srcs        = [{ filename = "mingw-w64-i686-hdf5-1.8.21-1-any.pkg.tar.xz"; sha256 = "ead377716f1911e4c5f20092bd05ce6e35f7273865f33032c107a16085c706f3"; }];
    buildInputs = [ gcc-libs gcc-libgfortran szip zlib ];
  };

  "headers-git" = fetch {
    pname       = "headers-git";
    version     = "7.0.0.5285.7b2baaf8";
    srcs        = [{ filename = "mingw-w64-i686-headers-git-7.0.0.5285.7b2baaf8-1-any.pkg.tar.xz"; sha256 = "5d5c5dc81292dc4310278957cb45618b697c58ad071d44279c76f0dfc388ae13"; }];
    buildInputs = [  ];
  };

  "hicolor-icon-theme" = fetch {
    pname       = "hicolor-icon-theme";
    version     = "0.17";
    srcs        = [{ filename = "mingw-w64-i686-hicolor-icon-theme-0.17-1-any.pkg.tar.xz"; sha256 = "bcf0068c88eb771339f01238319657cbafb179805db382f588e2e6e7e8601ef3"; }];
    buildInputs = [  ];
  };

  "hidapi" = fetch {
    pname       = "hidapi";
    version     = "0.8.0rc1";
    srcs        = [{ filename = "mingw-w64-i686-hidapi-0.8.0rc1-4-any.pkg.tar.xz"; sha256 = "7d502caa8c3e2fee2efd713089fec323c8cbaaf3cf3617eb1e80d8b40536610e"; }];
    buildInputs = [ gcc-libs ];
  };

  "hlsl2glsl-git" = fetch {
    pname       = "hlsl2glsl-git";
    version     = "r848.957cd20";
    srcs        = [{ filename = "mingw-w64-i686-hlsl2glsl-git-r848.957cd20-1-any.pkg.tar.xz"; sha256 = "2b254cb4f84e6271a35dd9b10570519910b7862197f02dc2b97a87d17c7518cc"; }];
  };

  "http-parser" = fetch {
    pname       = "http-parser";
    version     = "2.8.1";
    srcs        = [{ filename = "mingw-w64-i686-http-parser-2.8.1-1-any.pkg.tar.xz"; sha256 = "c483ada87d2322447c6b8fb96abfb7b9cada0defd7203e111937cf426e1c25e6"; }];
    buildInputs = [  ];
  };

  "hunspell" = fetch {
    pname       = "hunspell";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-i686-hunspell-1.7.0-1-any.pkg.tar.xz"; sha256 = "a3ac7270c6ddb324d75113e36bbb42b20c08cfd83e28335aa9b942bbe773f8d4"; }];
    buildInputs = [ gcc-libs gettext ncurses readline ];
  };

  "hunspell-en" = fetch {
    pname       = "hunspell-en";
    version     = "2018.04.16";
    srcs        = [{ filename = "mingw-w64-i686-hunspell-en-2018.04.16-1-any.pkg.tar.xz"; sha256 = "f89613e42e4feb779a975e75a7f3e9e4dcece583405d4d7723c3a2d14674c7e9"; }];
  };

  "hyphen" = fetch {
    pname       = "hyphen";
    version     = "2.8.8";
    srcs        = [{ filename = "mingw-w64-i686-hyphen-2.8.8-1-any.pkg.tar.xz"; sha256 = "2ecebe0cda7b9f9a79d22dbaae7d3d1c725498a71f456ac4a164f20950d04b38"; }];
  };

  "hyphen-en" = fetch {
    pname       = "hyphen-en";
    version     = "2.8.8";
    srcs        = [{ filename = "mingw-w64-i686-hyphen-en-2.8.8-1-any.pkg.tar.xz"; sha256 = "8e772b67ed127f1d357df1855f4c1aaadc07d6bf88f4f3228f85f687eaa2e2bd"; }];
  };

  "icon-naming-utils" = fetch {
    pname       = "icon-naming-utils";
    version     = "0.8.90";
    srcs        = [{ filename = "mingw-w64-i686-icon-naming-utils-0.8.90-2-any.pkg.tar.xz"; sha256 = "aa6f8457b12201bcc647cb1f676dac2aa8c6d4a75d23263d912afaf74d8c23ac"; }];
    buildInputs = [ perl-XML-Simple ];
    broken      = true; # broken dependency icon-naming-utils -> perl-XML-Simple
  };

  "iconv" = fetch {
    pname       = "iconv";
    version     = "1.15";
    srcs        = [{ filename = "mingw-w64-i686-iconv-1.15-3-any.pkg.tar.xz"; sha256 = "a3d0e19f5a27b19d6e0d77bc537c0835c3f76ae8fe01535f430397901fbf5832"; }];
    buildInputs = [ (assert libiconv.version=="1.15"; libiconv) gettext ];
  };

  "icoutils" = fetch {
    pname       = "icoutils";
    version     = "0.32.3";
    srcs        = [{ filename = "mingw-w64-i686-icoutils-0.32.3-1-any.pkg.tar.xz"; sha256 = "4d931c4db117f1cf5c0ccc4352a96dc1508cbb966d477b7d5a0d5d28258e4c78"; }];
    buildInputs = [ libpng ];
  };

  "icu" = fetch {
    pname       = "icu";
    version     = "62.1";
    srcs        = [{ filename = "mingw-w64-i686-icu-62.1-1-any.pkg.tar.xz"; sha256 = "5d88d96fa9e108f0a379cf720db8a01aefda8d6ed370205cf93ee61939719f72"; }];
    buildInputs = [ gcc-libs ];
  };

  "icu-debug-libs" = fetch {
    pname       = "icu-debug-libs";
    version     = "62.1";
    srcs        = [{ filename = "mingw-w64-i686-icu-debug-libs-62.1-1-any.pkg.tar.xz"; sha256 = "f4c1baaffa4fc715c37255f98e8d26f5989d1593112f7bb26991c61fe754fba2"; }];
    buildInputs = [ gcc-libs ];
  };

  "id3lib" = fetch {
    pname       = "id3lib";
    version     = "3.8.3";
    srcs        = [{ filename = "mingw-w64-i686-id3lib-3.8.3-2-any.pkg.tar.xz"; sha256 = "223729f02fe92fc9e0a9f374365ad7c3290615d828a94764ab72865fc85832c1"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "ilmbase" = fetch {
    pname       = "ilmbase";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-ilmbase-2.3.0-1-any.pkg.tar.xz"; sha256 = "26a0ad8f30d67e2a6599e26600bde6ab5b22af4818363a402cfa4ff702e8dfa9"; }];
    buildInputs = [ gcc-libs ];
  };

  "imagemagick" = fetch {
    pname       = "imagemagick";
    version     = "7.0.8.14";
    srcs        = [{ filename = "mingw-w64-i686-imagemagick-7.0.8.14-1-any.pkg.tar.xz"; sha256 = "00eaa86687b9201445a357bf12e79753c939bf3efbba04150793ab62d301373a"; }];
    buildInputs = [ bzip2 djvulibre flif fftw fontconfig freetype glib2 gsfonts jasper jbigkit lcms2 liblqr libpng libraqm libtiff libtool libwebp libxml2 openjpeg2 ttf-dejavu xz zlib ];
  };

  "indent" = fetch {
    pname       = "indent";
    version     = "2.2.12";
    srcs        = [{ filename = "mingw-w64-i686-indent-2.2.12-1-any.pkg.tar.xz"; sha256 = "582315fcacc3c411ca4e70d536655d71b6fcd8e77dbab0cbc3b3a0c805ed3700"; }];
  };

  "inkscape" = fetch {
    pname       = "inkscape";
    version     = "0.92.3";
    srcs        = [{ filename = "mingw-w64-i686-inkscape-0.92.3-7-any.pkg.tar.xz"; sha256 = "5a94a5dafafbc999d392f5fbdb47897e7160eee915436721ae8466ce3c2e8e27"; }];
    buildInputs = [ aspell gc ghostscript gsl gtkmm gtkspell hicolor-icon-theme imagemagick lcms2 libcdr libvisio libxml2 libxslt libwpg poppler popt potrace python2 ];
  };

  "innoextract" = fetch {
    pname       = "innoextract";
    version     = "1.7";
    srcs        = [{ filename = "mingw-w64-i686-innoextract-1.7-1-any.pkg.tar.xz"; sha256 = "465ff9dc705204f419410aece3a40d26a76825395fd867a08edcddc39439a356"; }];
    buildInputs = [ gcc-libs boost bzip2 libiconv xz zlib ];
  };

  "intel-tbb" = fetch {
    pname       = "intel-tbb";
    version     = "1~2019_20181003";
    srcs        = [{ filename = "mingw-w64-i686-intel-tbb-1~2019_20181003-1-any.pkg.tar.xz"; sha256 = "0199096d0574a1e9cb2df31920d1b171fcfbbfb968a135cefa09238ab4c7914e"; }];
    buildInputs = [ gcc-libs ];
  };

  "irrlicht" = fetch {
    pname       = "irrlicht";
    version     = "1.8.4";
    srcs        = [{ filename = "mingw-w64-i686-irrlicht-1.8.4-1-any.pkg.tar.xz"; sha256 = "adfd44870e46aa18226e4f2b72c4f3cd5bffe4c43f4bde433db93b99fc62e856"; }];
    buildInputs = [ gcc-libs ];
  };

  "isl" = fetch {
    pname       = "isl";
    version     = "0.19";
    srcs        = [{ filename = "mingw-w64-i686-isl-0.19-1-any.pkg.tar.xz"; sha256 = "456e65e17efe9e652fa28d9def47ea726fbbc1079cb4abaac5b420e2d47fb65c"; }];
    buildInputs = [  ];
  };

  "iso-codes" = fetch {
    pname       = "iso-codes";
    version     = "4.1";
    srcs        = [{ filename = "mingw-w64-i686-iso-codes-4.1-1-any.pkg.tar.xz"; sha256 = "80e390a769b4a0f417eea8ca5ec8b0dce72500a708325ec6eb7a2f8f816ddfc8"; }];
    buildInputs = [  ];
  };

  "itk" = fetch {
    pname       = "itk";
    version     = "4.13.1";
    srcs        = [{ filename = "mingw-w64-i686-itk-4.13.1-1-any.pkg.tar.xz"; sha256 = "20714317a0b096a310bbbb52fb94cc9254ce4273bcc5b6f06d1aec694433a156"; }];
    buildInputs = [ gcc-libs expat fftw gdcm hdf5 libjpeg libpng libtiff zlib ];
  };

  "jansson" = fetch {
    pname       = "jansson";
    version     = "2.12";
    srcs        = [{ filename = "mingw-w64-i686-jansson-2.12-1-any.pkg.tar.xz"; sha256 = "f2314453c35eee30f6692ceb24edb9929175dd934b3931dcfd148e90cbab8ec1"; }];
    buildInputs = [  ];
  };

  "jasper" = fetch {
    pname       = "jasper";
    version     = "2.0.14";
    srcs        = [{ filename = "mingw-w64-i686-jasper-2.0.14-1-any.pkg.tar.xz"; sha256 = "948dec05bc2b8d9e9e57aaa579c253867df48510cffd7e02bbad3dd1a36f51d2"; }];
    buildInputs = [ freeglut libjpeg-turbo ];
  };

  "jbigkit" = fetch {
    pname       = "jbigkit";
    version     = "2.1";
    srcs        = [{ filename = "mingw-w64-i686-jbigkit-2.1-4-any.pkg.tar.xz"; sha256 = "a68955c6c7fa8907a0605bb6b7a90ae598b6131afd0243a4fdb953bcb7a53f61"; }];
    buildInputs = [ gcc-libs ];
  };

  "jemalloc" = fetch {
    pname       = "jemalloc";
    version     = "5.1.0";
    srcs        = [{ filename = "mingw-w64-i686-jemalloc-5.1.0-3-any.pkg.tar.xz"; sha256 = "2e7eb7c2b2cdb80e15103a9bccc41f027288d1c70ef80f6e92690a5c5a0ef7db"; }];
    buildInputs = [ gcc-libs ];
  };

  "jpegoptim" = fetch {
    pname       = "jpegoptim";
    version     = "1.4.6";
    srcs        = [{ filename = "mingw-w64-i686-jpegoptim-1.4.6-1-any.pkg.tar.xz"; sha256 = "3b56b3432769077eb4cd38bbfa41368bead3a2c1e2393b0adbf4fec061e6e516"; }];
    buildInputs = [ libjpeg-turbo ];
  };

  "jq" = fetch {
    pname       = "jq";
    version     = "1.6";
    srcs        = [{ filename = "mingw-w64-i686-jq-1.6-1-any.pkg.tar.xz"; sha256 = "982012aa49fe14f21fc7482f081efb133838f39468824b67d0492b0c7c89939c"; }];
    buildInputs = [ oniguruma ];
  };

  "json-c" = fetch {
    pname       = "json-c";
    version     = "0.13.1_20180305";
    srcs        = [{ filename = "mingw-w64-i686-json-c-0.13.1_20180305-1-any.pkg.tar.xz"; sha256 = "4df4f09aae52b89426bf0cd5d8b324568f381a86e7475385aa524c4c3c3e19ae"; }];
    buildInputs = [  ];
  };

  "json-glib" = fetch {
    pname       = "json-glib";
    version     = "1.4.4";
    srcs        = [{ filename = "mingw-w64-i686-json-glib-1.4.4-1-any.pkg.tar.xz"; sha256 = "3dc69467c948e6ecc2c858ea62dbe19f3d586354a5e577328c0631287a5e49fa"; }];
    buildInputs = [ glib2 ];
  };

  "jsoncpp" = fetch {
    pname       = "jsoncpp";
    version     = "1.8.4";
    srcs        = [{ filename = "mingw-w64-i686-jsoncpp-1.8.4-3-any.pkg.tar.xz"; sha256 = "0fbc531b7adf429674c34ea7124b0e8e863cf687ebf23ee42b10fde944e07956"; }];
    buildInputs = [  ];
  };

  "jsonrpc-glib" = fetch {
    pname       = "jsonrpc-glib";
    version     = "3.30.1";
    srcs        = [{ filename = "mingw-w64-i686-jsonrpc-glib-3.30.1-1-any.pkg.tar.xz"; sha256 = "9d53bcf29eeeec29a412ea8a023f05c386a8be7a44bbd6d9704f51df3f915c35"; }];
    buildInputs = [ glib2 json-glib ];
  };

  "jxrlib" = fetch {
    pname       = "jxrlib";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-i686-jxrlib-1.1-3-any.pkg.tar.xz"; sha256 = "a7f3f113f62e01f2d7e0cb51b226070448d40c7cb8731e24ff773b3c6da03802"; }];
    buildInputs = [ gcc-libs ];
  };

  "kactivities-qt5" = fetch {
    pname       = "kactivities-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kactivities-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "d3f8bb3407304d489f7951ba7f00cb41597637f15aa58943c16a80a6e03c09b9"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.50.0"; kwindowsystem-qt5) ];
  };

  "karchive-qt5" = fetch {
    pname       = "karchive-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-karchive-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "11702e75d4dddfd00cc92f41d4957a79d17ff8a8a67de8ca89c0271037735c69"; }];
    buildInputs = [ zlib bzip2 xz qt5 ];
  };

  "kate" = fetch {
    pname       = "kate";
    version     = "18.08.1";
    srcs        = [{ filename = "mingw-w64-i686-kate-18.08.1-2-any.pkg.tar.xz"; sha256 = "4ced4b617d3b76d19411c5e2880d4f4259fe068b22423f44223eb5d6f12965cf"; }];
    buildInputs = [ knewstuff-qt5 ktexteditor-qt5 threadweaver-qt5 kitemmodels-qt5 kactivities-qt5 plasma-framework-qt5 hicolor-icon-theme ];
  };

  "kauth-qt5" = fetch {
    pname       = "kauth-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kauth-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "797615f9ddaaf992c1963d7e4acaaa156c6dbe6e0995ed9c657f4b56df4bbdfe"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) ];
  };

  "kbookmarks-qt5" = fetch {
    pname       = "kbookmarks-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kbookmarks-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "bb4a2c97abb869622ace4a89bb817aeec36b1cb1fd5b8ab81407903437f4df3b"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kxmlgui-qt5.version "5.50.0"; kxmlgui-qt5) ];
  };

  "kcmutils-qt5" = fetch {
    pname       = "kcmutils-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kcmutils-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "d747c0a5da10802a60365490cd3e43b7a728fe5a34c9740f3e0fd54238a861ac"; }];
    buildInputs = [ kdeclarative-qt5 qt5 ];
  };

  "kcodecs-qt5" = fetch {
    pname       = "kcodecs-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kcodecs-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "003e11c3178277ec9efee4dd348210c75e7985b69b7c70031d8b7d544d485586"; }];
    buildInputs = [ qt5 ];
  };

  "kcompletion-qt5" = fetch {
    pname       = "kcompletion-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kcompletion-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "4b63ea9d2e55fbfd85425923b86d95e79bdfa6a83c1be54f912b6385de3d7009"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.50.0"; kwidgetsaddons-qt5) ];
  };

  "kconfig-qt5" = fetch {
    pname       = "kconfig-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kconfig-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "874038ed7b8033e3f76d81390f3b1041480590ac23c4e03283bed584a6a0d808"; }];
    buildInputs = [ qt5 ];
  };

  "kconfigwidgets-qt5" = fetch {
    pname       = "kconfigwidgets-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kconfigwidgets-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "5886fca6e3951818ed0db32eeeb819a3ff9334f0aa060a5e2e2f5a8f41edf77e"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kauth-qt5.version "5.50.0"; kauth-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kcodecs-qt5.version "5.50.0"; kcodecs-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kguiaddons-qt5.version "5.50.0"; kguiaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.50.0"; kwidgetsaddons-qt5) ];
  };

  "kcoreaddons-qt5" = fetch {
    pname       = "kcoreaddons-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kcoreaddons-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "9c03c54c49b8cb8801f55716d9a1ae0375ab22c77e8e4daa3dd680c7c7ad6fe0"; }];
    buildInputs = [ qt5 ];
  };

  "kcrash-qt5" = fetch {
    pname       = "kcrash-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kcrash-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "3e27297408bf881b8b341dc819a5aed2546920d2f6da5cb088d3018438bbdfc0"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.50.0"; kwindowsystem-qt5) ];
  };

  "kdbusaddons-qt5" = fetch {
    pname       = "kdbusaddons-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kdbusaddons-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "4d2f057e21ee940920a11d146f555dbe9dddf943c2248e72ab0ef5568bc693e7"; }];
    buildInputs = [ qt5 ];
  };

  "kdeclarative-qt5" = fetch {
    pname       = "kdeclarative-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kdeclarative-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "7139b10636ca16185c7bd873d17dc591d4832a690dd1372c0cfaea3028ac7e58"; }];
    buildInputs = [ qt5 kio-qt5 kpackage-qt5 libepoxy ];
  };

  "kdewebkit-qt5" = fetch {
    pname       = "kdewebkit-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kdewebkit-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "c38dcc7ca872ca82270f2f04f91413fd175eaf7c4569975409da20d81194336c"; }];
    buildInputs = [ kparts-qt5 qtwebkit ];
  };

  "kdnssd-qt5" = fetch {
    pname       = "kdnssd-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kdnssd-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "b4c314d27c3a1c640e4c98443c7e380d123fc02a5bdfc0c6bc1420b443ece62f"; }];
    buildInputs = [ qt5 ];
  };

  "kdoctools-qt5" = fetch {
    pname       = "kdoctools-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kdoctools-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "ae207ebd2ae9513bc32795e661494a2b69540087c3d553691e83eb2b64d4377a"; }];
    buildInputs = [ qt5 libxslt docbook-xsl (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.50.0"; karchive-qt5) ];
  };

  "kfilemetadata-qt5" = fetch {
    pname       = "kfilemetadata-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kfilemetadata-qt5-5.50.0-4-any.pkg.tar.xz"; sha256 = "7eee5becad621408f8658a8f2fa811d280109f7d904cc8acff88445c529de73b"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.50.0"; karchive-qt5) exiv2 poppler taglib ffmpeg ];
  };

  "kglobalaccel-qt5" = fetch {
    pname       = "kglobalaccel-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kglobalaccel-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "571f336e9727a267efa82b1d4fcc02378bd9a5be8d66150ae5cf9ce3bd3fe6f4"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcrash-qt5.version "5.50.0"; kcrash-qt5) (assert stdenvNoCC.lib.versionAtLeast kdbusaddons-qt5.version "5.50.0"; kdbusaddons-qt5) ];
  };

  "kguiaddons-qt5" = fetch {
    pname       = "kguiaddons-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kguiaddons-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "63ee3e585efea015a175fffcb9389cd3d2b3be43ac6a461c757b1933599c30b5"; }];
    buildInputs = [ qt5 ];
  };

  "kholidays-qt5" = fetch {
    pname       = "kholidays-qt5";
    version     = "1~5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kholidays-qt5-1~5.50.0-1-any.pkg.tar.xz"; sha256 = "d9998c84e1e03a317efecb999db532067da79adbc19c6a7cbd8e32e6f257a0c6"; }];
    buildInputs = [ qt5 ];
  };

  "ki18n-qt5" = fetch {
    pname       = "ki18n-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-ki18n-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "457d4d67a46811629da76f293eb7e09998819f5e2cfbd31878ae09d82c1f377e"; }];
    buildInputs = [ gettext qt5 ];
  };

  "kicad" = fetch {
    pname       = "kicad";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-5.0.2-1-any.pkg.tar.xz"; sha256 = "dab969ed6e6726e7a5dc6327e69edd527c6a95a3a44a28cab78be6b6c187d016"; }];
    buildInputs = [ boost cairo curl glew ngspice oce openssl wxPython wxWidgets ];
  };

  "kicad-doc-ca" = fetch {
    pname       = "kicad-doc-ca";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-ca-5.0.2-1-any.pkg.tar.xz"; sha256 = "337cbf2ad7efe89cf3890dbf13753a2e3d5b1a5b718274d6b5405939b670b0f1"; }];
  };

  "kicad-doc-de" = fetch {
    pname       = "kicad-doc-de";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-de-5.0.2-1-any.pkg.tar.xz"; sha256 = "3d5e3d2976c0b6e3cbb95632483eb16637357ca669b2c737c5ab789156b17934"; }];
  };

  "kicad-doc-en" = fetch {
    pname       = "kicad-doc-en";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-en-5.0.2-1-any.pkg.tar.xz"; sha256 = "2ea691ae858eed7425cf71de5e3609f54517a6f915b45180d2441b9258b83344"; }];
  };

  "kicad-doc-es" = fetch {
    pname       = "kicad-doc-es";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-es-5.0.2-1-any.pkg.tar.xz"; sha256 = "47855eb833380cdb785f6ecc9eedf85f2abf68c298f91b86728dd30fea2211bf"; }];
  };

  "kicad-doc-fr" = fetch {
    pname       = "kicad-doc-fr";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-fr-5.0.2-1-any.pkg.tar.xz"; sha256 = "0592a44f4ce13de4935f1df34c8dbb4bf8f57b365928d07b2bf1dc372f179e9a"; }];
  };

  "kicad-doc-id" = fetch {
    pname       = "kicad-doc-id";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-id-5.0.2-1-any.pkg.tar.xz"; sha256 = "fd440b26039441fd87a628427cb1692f00a7fa53f4d378f6dbfa41ffea450d87"; }];
  };

  "kicad-doc-it" = fetch {
    pname       = "kicad-doc-it";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-it-5.0.2-1-any.pkg.tar.xz"; sha256 = "6e1ef1e811bc526b6e26d489e7423056eab89b84958046694c333b7bd6d1b98d"; }];
  };

  "kicad-doc-ja" = fetch {
    pname       = "kicad-doc-ja";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-ja-5.0.2-1-any.pkg.tar.xz"; sha256 = "57a27f978490087e5345824e98f2558c88755a5ca028f894a2e393f9d5fa9326"; }];
  };

  "kicad-doc-nl" = fetch {
    pname       = "kicad-doc-nl";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-nl-5.0.2-1-any.pkg.tar.xz"; sha256 = "10f5afaaeee64da157b953720fbe4d7422844599143e06b0d2c5bc9480daf11b"; }];
  };

  "kicad-doc-pl" = fetch {
    pname       = "kicad-doc-pl";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-pl-5.0.2-1-any.pkg.tar.xz"; sha256 = "c2f3a762dc781e02bfe22041eb2cb1ad1cac12c881be23a6f8730363fbdf6a22"; }];
  };

  "kicad-doc-ru" = fetch {
    pname       = "kicad-doc-ru";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-ru-5.0.2-1-any.pkg.tar.xz"; sha256 = "0aff85593cfc39934f99bdb2d1c2239eb7dda4017819eeb05cf09cc18573c033"; }];
  };

  "kicad-doc-zh" = fetch {
    pname       = "kicad-doc-zh";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-doc-zh-5.0.2-1-any.pkg.tar.xz"; sha256 = "c9e82756b5169ee3f8c4814784b09e6daa25f33656cf4ec3f31c6d15f664c737"; }];
  };

  "kicad-footprints" = fetch {
    pname       = "kicad-footprints";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-footprints-5.0.2-1-any.pkg.tar.xz"; sha256 = "dbb82bdaa12e2c40d8a03adfe27fd50596a263ed481279d8f5088ce09608883a"; }];
  };

  "kicad-meta" = fetch {
    pname       = "kicad-meta";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-meta-5.0.2-1-any.pkg.tar.xz"; sha256 = "1b5b775ab54d23274d792868647d84faa5a5d7a866c882ceb158bfd9272f49f1"; }];
    buildInputs = [ kicad kicad-footprints kicad-symbols kicad-templates kicad-packages3D ];
  };

  "kicad-packages3D" = fetch {
    pname       = "kicad-packages3D";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-packages3D-5.0.2-1-any.pkg.tar.xz"; sha256 = "4ff98ca791b2984faa5523d39fbe7db656bdd15e658f0cac632c13fc41f481f3"; }];
    buildInputs = [  ];
  };

  "kicad-symbols" = fetch {
    pname       = "kicad-symbols";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-symbols-5.0.2-1-any.pkg.tar.xz"; sha256 = "bacca691da63040ddb5aa119d74792a0cdd264ee525f4c6d36cf7115c01ff523"; }];
    buildInputs = [  ];
  };

  "kicad-templates" = fetch {
    pname       = "kicad-templates";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-i686-kicad-templates-5.0.2-1-any.pkg.tar.xz"; sha256 = "08fad76e436a171186e61b8cff396dacff55e0b991badc0da8970d281146de0d"; }];
    buildInputs = [  ];
  };

  "kiconthemes-qt5" = fetch {
    pname       = "kiconthemes-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kiconthemes-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "a027f687555c3a407cd9e3edc93c01a7bcf53566e4857c89000c97cbd5c46aad"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfigwidgets-qt5.version "5.50.0"; kconfigwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast kitemviews-qt5.version "5.50.0"; kitemviews-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.50.0"; karchive-qt5) ];
  };

  "kidletime-qt5" = fetch {
    pname       = "kidletime-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kidletime-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "d3d2ad0ac31a17e0a16b40289df09c68620379f3522c5a4f581435363fcf0a91"; }];
    buildInputs = [ qt5 ];
  };

  "kimageformats-qt5" = fetch {
    pname       = "kimageformats-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kimageformats-qt5-5.50.0-3-any.pkg.tar.xz"; sha256 = "dcbe90d899681ea62bbf0cf5fbf000c11b859c3c8ba6d54be79beb292709017b"; }];
    buildInputs = [ qt5 openexr (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.50.0"; karchive-qt5) ];
  };

  "kinit-qt5" = fetch {
    pname       = "kinit-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kinit-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "50e69e4037d57d9b8f0599765edd3b7950151e713573903f65439175ee525928"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.50.0"; kio-qt5) ];
  };

  "kio-qt5" = fetch {
    pname       = "kio-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kio-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "531b73ba1a84a7f119f1f58109057122073ed53662b513a1f1ae5dcd18c31a00"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast solid-qt5.version "5.50.0"; solid-qt5) (assert stdenvNoCC.lib.versionAtLeast kjobwidgets-qt5.version "5.50.0"; kjobwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast kbookmarks-qt5.version "5.50.0"; kbookmarks-qt5) (assert stdenvNoCC.lib.versionAtLeast kwallet-qt5.version "5.50.0"; kwallet-qt5) libxslt ];
  };

  "kirigami2-qt5" = fetch {
    pname       = "kirigami2-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kirigami2-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "f32aeff1a93eecb1e51e0a0d6cb619b7e5794b23decf0d6b36cf87027bf8744b"; }];
    buildInputs = [ qt5 ];
  };

  "kiss_fft" = fetch {
    pname       = "kiss_fft";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-kiss_fft-1.3.0-2-any.pkg.tar.xz"; sha256 = "c9aa73612cb09611d5dd0207f33b80a053940e433563382d8d924910652d616e"; }];
  };

  "kitemmodels-qt5" = fetch {
    pname       = "kitemmodels-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kitemmodels-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "3db46db366bfa7d4aab667fc5f5af6e9c44faa88585321c4c1d94a673e1988d7"; }];
    buildInputs = [ qt5 ];
  };

  "kitemviews-qt5" = fetch {
    pname       = "kitemviews-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kitemviews-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "b12af8ebba3d3b9ea4bee03e62a65a940fa1e3c66d445380e64501e24dbd5962"; }];
    buildInputs = [ qt5 ];
  };

  "kjobwidgets-qt5" = fetch {
    pname       = "kjobwidgets-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kjobwidgets-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "1c88a5795aa61bd1ce6128057db7103f53b829600ffe6139baf965fd0c2b19dc"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.50.0"; kwidgetsaddons-qt5) ];
  };

  "kjs-qt5" = fetch {
    pname       = "kjs-qt5";
    version     = "5.42.0";
    srcs        = [{ filename = "mingw-w64-i686-kjs-qt5-5.42.0-1-any.pkg.tar.xz"; sha256 = "2822c94479f0a1ab621364d039cf0b124059ebb43b5dc7a2b8588bbf3645faeb"; }];
    buildInputs = [ qt5 bzip2 pcre (assert stdenvNoCC.lib.versionAtLeast kdoctools-qt5.version "5.42.0"; kdoctools-qt5) ];
  };

  "knewstuff-qt5" = fetch {
    pname       = "knewstuff-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-knewstuff-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "c5cef7e89f68cf5b391997999d7204355ee113d21a297545495edc8d495a4b6d"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.50.0"; kio-qt5) ];
  };

  "knotifications-qt5" = fetch {
    pname       = "knotifications-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-knotifications-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "221be261bc291f30f76f7d82a847c4430fc3928b73dee7eefe3d09d4631d9e89"; }];
    buildInputs = [ qt5 phonon-qt5 (assert stdenvNoCC.lib.versionAtLeast kcodecs-qt5.version "5.50.0"; kcodecs-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.50.0"; kwindowsystem-qt5) ];
  };

  "kpackage-qt5" = fetch {
    pname       = "kpackage-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kpackage-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "93b89dde7f9aff374d43366422ccd43de3624a6e2de9a4f04049bf3d37132898"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.50.0"; karchive-qt5) (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) ];
  };

  "kparts-qt5" = fetch {
    pname       = "kparts-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kparts-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "d8751b6ae224d9d71274de393e44181ec4b8eee1c9dbce60eb7450add3e1b836"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.50.0"; kio-qt5) ];
  };

  "kplotting-qt5" = fetch {
    pname       = "kplotting-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kplotting-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "5056f45841dec79c5480a0b6b5927492f628a28754ae97f4b2e18ee0dc26a3d7"; }];
    buildInputs = [ qt5 ];
  };

  "kqoauth-qt4" = fetch {
    pname       = "kqoauth-qt4";
    version     = "0.98";
    srcs        = [{ filename = "mingw-w64-i686-kqoauth-qt4-0.98-3-any.pkg.tar.xz"; sha256 = "851b90b63408e180a4b7961c660bfa8dda1bb27eecef2852fee9c9e75fa3d062"; }];
    buildInputs = [ qt4 ];
  };

  "kservice-qt5" = fetch {
    pname       = "kservice-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kservice-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "108bbdc2dfd4ae2b3c6127feeb92e11bb87d23a6d7ff29a711a4420c08bc922a"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcrash-qt5.version "5.50.0"; kcrash-qt5) (assert stdenvNoCC.lib.versionAtLeast kdbusaddons-qt5.version "5.50.0"; kdbusaddons-qt5) ];
  };

  "ktexteditor-qt5" = fetch {
    pname       = "ktexteditor-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-ktexteditor-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "0d4c1cd7fba1e69f4fdf4f05d5e630d1c43dad1c6e813467228a182bc62b7bd8"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kparts-qt5.version "5.50.0"; kparts-qt5) (assert stdenvNoCC.lib.versionAtLeast syntax-highlighting-qt5.version "5.50.0"; syntax-highlighting-qt5) libgit2 editorconfig-core-c ];
  };

  "ktextwidgets-qt5" = fetch {
    pname       = "ktextwidgets-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-ktextwidgets-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "fb76f33614a3ede16dfbc5c2ed30f1bc35562b612776c22f6262202a908c479c"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcompletion-qt5.version "5.50.0"; kcompletion-qt5) (assert stdenvNoCC.lib.versionAtLeast kservice-qt5.version "5.50.0"; kservice-qt5) (assert stdenvNoCC.lib.versionAtLeast kiconthemes-qt5.version "5.50.0"; kiconthemes-qt5) (assert stdenvNoCC.lib.versionAtLeast sonnet-qt5.version "5.50.0"; sonnet-qt5) ];
  };

  "kunitconversion-qt5" = fetch {
    pname       = "kunitconversion-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kunitconversion-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "5458a6b1c425e8bb338346166534287e2ce83f691b1e450c73c0e6832f320475"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) ];
  };

  "kvazaar" = fetch {
    pname       = "kvazaar";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-kvazaar-1.2.0-1-any.pkg.tar.xz"; sha256 = "c7d03214b10b245a44765290b68846deeeaed1d90c71a8060b8d026e75189b59"; }];
    buildInputs = [ gcc-libs self."crypto++" ];
  };

  "kwallet-qt5" = fetch {
    pname       = "kwallet-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kwallet-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "d88335771c1488a540815b897f3e378490a32531d7f2265a4ce2f8dd6524d2b0"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast knotifications-qt5.version "5.50.0"; knotifications-qt5) (assert stdenvNoCC.lib.versionAtLeast kiconthemes-qt5.version "5.50.0"; kiconthemes-qt5) (assert stdenvNoCC.lib.versionAtLeast kservice-qt5.version "5.50.0"; kservice-qt5) gpgme ];
  };

  "kwidgetsaddons-qt5" = fetch {
    pname       = "kwidgetsaddons-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kwidgetsaddons-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "b3a9eb22bce3a0a5e8800878d39ac58aaaaece43ab90d3209c64b9bfb5727851"; }];
    buildInputs = [ qt5 ];
  };

  "kwindowsystem-qt5" = fetch {
    pname       = "kwindowsystem-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kwindowsystem-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "c63c5c746aed911c183ba8b51a7b91c2e78c8c1740c17100b13fb1cb12eead46"; }];
    buildInputs = [ qt5 ];
  };

  "kxmlgui-qt5" = fetch {
    pname       = "kxmlgui-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-kxmlgui-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "4c58562bfef485d595e74822f160266bfd87dbfde9c8b8a9851766ac9ca75716"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kglobalaccel-qt5.version "5.50.0"; kglobalaccel-qt5) (assert stdenvNoCC.lib.versionAtLeast ktextwidgets-qt5.version "5.50.0"; ktextwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast attica-qt5.version "5.50.0"; attica-qt5) ];
  };

  "l-smash" = fetch {
    pname       = "l-smash";
    version     = "2.14.5";
    srcs        = [{ filename = "mingw-w64-i686-l-smash-2.14.5-1-any.pkg.tar.xz"; sha256 = "bd339007ad2ac6d9bfd58c88de34e6e7e91bd97c9680b144fee3bf7a930f39ca"; }];
    buildInputs = [  ];
  };

  "ladspa-sdk" = fetch {
    pname       = "ladspa-sdk";
    version     = "1.13";
    srcs        = [{ filename = "mingw-w64-i686-ladspa-sdk-1.13-2-any.pkg.tar.xz"; sha256 = "dd8cf0979a516357aa039fb329351483127451a082b2f7ec475098b4420bbb82"; }];
  };

  "lame" = fetch {
    pname       = "lame";
    version     = "3.100";
    srcs        = [{ filename = "mingw-w64-i686-lame-3.100-1-any.pkg.tar.xz"; sha256 = "c1045d291d3ab739c487600323b3e2d1de2d32f778a3e5ae65f489bfc39cbfd9"; }];
    buildInputs = [ libiconv ];
  };

  "lapack" = fetch {
    pname       = "lapack";
    version     = "3.8.0";
    srcs        = [{ filename = "mingw-w64-i686-lapack-3.8.0-3-any.pkg.tar.xz"; sha256 = "71c94a5bfe350b1be1491a76ab3417162ee86f038517a51bc38a7f35d9cb0c75"; }];
    buildInputs = [ gcc-libs gcc-libgfortran ];
  };

  "lasem" = fetch {
    pname       = "lasem";
    version     = "0.4.3";
    srcs        = [{ filename = "mingw-w64-i686-lasem-0.4.3-2-any.pkg.tar.xz"; sha256 = "19a572659892bacf4e5a757dae9956aa098b09af3f8af1de93386eda51e5a567"; }];
  };

  "laszip" = fetch {
    pname       = "laszip";
    version     = "3.2.9";
    srcs        = [{ filename = "mingw-w64-i686-laszip-3.2.9-1-any.pkg.tar.xz"; sha256 = "5295278afaadb7f945d360b52d2341dcee2156072770ef2d76853a86ccc073bf"; }];
  };

  "lcms" = fetch {
    pname       = "lcms";
    version     = "1.19";
    srcs        = [{ filename = "mingw-w64-i686-lcms-1.19-6-any.pkg.tar.xz"; sha256 = "84a9d8ed48a4b6b3b1f0b4844bf23e6cfff91f82f7258b0ccb24a87f3a31bf57"; }];
    buildInputs = [ libtiff ];
  };

  "lcms2" = fetch {
    pname       = "lcms2";
    version     = "2.9";
    srcs        = [{ filename = "mingw-w64-i686-lcms2-2.9-1-any.pkg.tar.xz"; sha256 = "11f8dcb85817f423c88aa2ab86e63f74e913f2d7b808db8fab159833be9d3106"; }];
    buildInputs = [ gcc-libs libtiff ];
  };

  "lcov" = fetch {
    pname       = "lcov";
    version     = "1.13";
    srcs        = [{ filename = "mingw-w64-i686-lcov-1.13-2-any.pkg.tar.xz"; sha256 = "3dea59b0ee6dd6578cb3e6301a0fb69ede2e354bd5a2faaea6ca2975d73d6c3e"; }];
    buildInputs = [ perl ];
  };

  "ldns" = fetch {
    pname       = "ldns";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-i686-ldns-1.7.0-3-any.pkg.tar.xz"; sha256 = "29c7286a3dfed97d5532b2c290a95c53e0bd654bb25b89edb5139cb11e0b899e"; }];
    buildInputs = [ openssl ];
  };

  "lensfun" = fetch {
    pname       = "lensfun";
    version     = "0.3.95";
    srcs        = [{ filename = "mingw-w64-i686-lensfun-0.3.95-1-any.pkg.tar.xz"; sha256 = "86909b09802433758898ab5b892c293c5202a7c206f9f86c8ff423e4b72d5463"; }];
    buildInputs = [ glib2 libpng zlib ];
  };

  "leptonica" = fetch {
    pname       = "leptonica";
    version     = "1.77.0";
    srcs        = [{ filename = "mingw-w64-i686-leptonica-1.77.0-1-any.pkg.tar.xz"; sha256 = "e6bce338af07c577dccfb14cbe4a1a9f83bbf5d4c831855d4e2025f15638cb7f"; }];
    buildInputs = [ gcc-libs giflib libtiff libpng libwebp openjpeg2 zlib ];
  };

  "lfcbase" = fetch {
    pname       = "lfcbase";
    version     = "1.12.5";
    srcs        = [{ filename = "mingw-w64-i686-lfcbase-1.12.5-1-any.pkg.tar.xz"; sha256 = "c2f094a6d97ecd08ab985efbb627e0baeb41e026d1a3d26314d3d51836b8c3b4"; }];
    buildInputs = [ gcc-libs ncurses ];
  };

  "lfcxml" = fetch {
    pname       = "lfcxml";
    version     = "1.2.10";
    srcs        = [{ filename = "mingw-w64-i686-lfcxml-1.2.10-1-any.pkg.tar.xz"; sha256 = "7465891c74b744f59ee7164f76a7a762503abec68e635f2d96dee257d7ec1b55"; }];
    buildInputs = [ lfcbase ];
  };

  "libaacs" = fetch {
    pname       = "libaacs";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-i686-libaacs-0.9.0-1-any.pkg.tar.xz"; sha256 = "d0950a4824d4c0164f0e095eda19fb32581941f23c18c2803c47bb8880e21599"; }];
    buildInputs = [ libgcrypt ];
  };

  "libao" = fetch {
    pname       = "libao";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-libao-1.2.2-1-any.pkg.tar.xz"; sha256 = "93d17e663b7eb80ac58788592df98c8b287e1404eb5e7e10542c9c0427315fd7"; }];
    buildInputs = [ gcc-libs ];
  };

  "libarchive" = fetch {
    pname       = "libarchive";
    version     = "3.3.3";
    srcs        = [{ filename = "mingw-w64-i686-libarchive-3.3.3-2-any.pkg.tar.xz"; sha256 = "aba721446e56ae0dadb30df567125c26ec7f043b8f80330b0f44ab0ee8b8fa8d"; }];
    buildInputs = [ gcc-libs bzip2 expat libiconv lz4 lzo2 libsystre nettle openssl xz zlib zstd ];
  };

  "libart_lgpl" = fetch {
    pname       = "libart_lgpl";
    version     = "2.3.21";
    srcs        = [{ filename = "mingw-w64-i686-libart_lgpl-2.3.21-2-any.pkg.tar.xz"; sha256 = "75977ad77c2be5118371d2adca18580e4e35c5fb4dbeaed9f5be7264ec0ae118"; }];
  };

  "libass" = fetch {
    pname       = "libass";
    version     = "0.14.0";
    srcs        = [{ filename = "mingw-w64-i686-libass-0.14.0-1-any.pkg.tar.xz"; sha256 = "d0d9d9a7eb4a976b659ada4a49cd2ffe9ee2974a6579c3bdc1d3dcb985b8e398"; }];
    buildInputs = [ fribidi fontconfig freetype harfbuzz ];
  };

  "libassuan" = fetch {
    pname       = "libassuan";
    version     = "2.5.2";
    srcs        = [{ filename = "mingw-w64-i686-libassuan-2.5.2-1-any.pkg.tar.xz"; sha256 = "877d727681aaa46d1ae83f3eca227ed89d90ab084497089fea6e21554dda21f3"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libatomic_ops" = fetch {
    pname       = "libatomic_ops";
    version     = "7.6.8";
    srcs        = [{ filename = "mingw-w64-i686-libatomic_ops-7.6.8-1-any.pkg.tar.xz"; sha256 = "4d3addf3d468ebfce48bb4f7d1104322c523d5c9d7e01e62183f45789383a065"; }];
    buildInputs = [  ];
  };

  "libbdplus" = fetch {
    pname       = "libbdplus";
    version     = "0.1.2";
    srcs        = [{ filename = "mingw-w64-i686-libbdplus-0.1.2-1-any.pkg.tar.xz"; sha256 = "64fc5d0c4ece6410c88fc671a55a562d430a818caf0971ddf86b3b669f8d1e6f"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libaacs.version "0.7.0"; libaacs) libgpg-error ];
  };

  "libblocksruntime" = fetch {
    pname       = "libblocksruntime";
    version     = "0.4.1";
    srcs        = [{ filename = "mingw-w64-i686-libblocksruntime-0.4.1-1-any.pkg.tar.xz"; sha256 = "d7ef7df6320bce13fe011183cc950b999024ba5c7b27a91508fa9f089b5bdd61"; }];
    buildInputs = [ clang ];
  };

  "libbluray" = fetch {
    pname       = "libbluray";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-i686-libbluray-1.0.2-1-any.pkg.tar.xz"; sha256 = "6548f814f494c683d97c7dd2031e846d19573e1625d2623eee863703e1627d69"; }];
    buildInputs = [ libxml2 freetype ];
  };

  "libbotan" = fetch {
    pname       = "libbotan";
    version     = "2.8.0";
    srcs        = [{ filename = "mingw-w64-i686-libbotan-2.8.0-1-any.pkg.tar.xz"; sha256 = "b46a53861bf1aa7bf49250eada72a2c146662cbd13e904ec2c7e0fc23d582abf"; }];
    buildInputs = [ gcc-libs boost bzip2 sqlite3 zlib xz ];
  };

  "libbs2b" = fetch {
    pname       = "libbs2b";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-i686-libbs2b-3.1.0-1-any.pkg.tar.xz"; sha256 = "1a974aa46bd3de2515f47911804938afaac8a4d7bc9b657b8627510aef44875a"; }];
    buildInputs = [ libsndfile ];
  };

  "libbsdf" = fetch {
    pname       = "libbsdf";
    version     = "0.9.4";
    srcs        = [{ filename = "mingw-w64-i686-libbsdf-0.9.4-1-any.pkg.tar.xz"; sha256 = "d45a6acb33950f2e6d191683cdab11975060eb4eebaa00eb7141f5575c09d963"; }];
  };

  "libc++" = fetch {
    pname       = "libc++";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-libc++-7.0.1-1-any.pkg.tar.xz"; sha256 = "153f38231e753cd735433ea41eee05ccd0b95f4d0a4021a9da4d789317640ba5"; }];
    buildInputs = [ gcc ];
  };

  "libc++abi" = fetch {
    pname       = "libc++abi";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-libc++abi-7.0.1-1-any.pkg.tar.xz"; sha256 = "8160722922164aa493a05d5da9305496d8d469e6c530c3e1d2adb7488792ca69"; }];
    buildInputs = [ gcc ];
  };

  "libcaca" = fetch {
    pname       = "libcaca";
    version     = "0.99.beta19";
    srcs        = [{ filename = "mingw-w64-i686-libcaca-0.99.beta19-4-any.pkg.tar.xz"; sha256 = "c48811f09d037b80b7d193d4a2713be2619b0dd79ca6f5307e05fcf950e24f63"; }];
    buildInputs = [ fontconfig freetype zlib ];
  };

  "libcddb" = fetch {
    pname       = "libcddb";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-i686-libcddb-1.3.2-4-any.pkg.tar.xz"; sha256 = "f41df9f1588c678b78e1b345354b65e57c48e4f64198b2b0e466604b362018e7"; }];
    buildInputs = [ libsystre ];
  };

  "libcdio" = fetch {
    pname       = "libcdio";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-libcdio-2.0.0-1-any.pkg.tar.xz"; sha256 = "e4030d3915ae1dcc45a70180350ad95bb252f4e37959397f0533f015ea2f8f91"; }];
    buildInputs = [ libiconv libcddb ];
  };

  "libcdio-paranoia" = fetch {
    pname       = "libcdio-paranoia";
    version     = "10.2+0.94+2";
    srcs        = [{ filename = "mingw-w64-i686-libcdio-paranoia-10.2+0.94+2-2-any.pkg.tar.xz"; sha256 = "36ea5f9253dbc991d8f4e8365bf9b249742235a981564a5748d054a1838cc4a2"; }];
    buildInputs = [ libcdio ];
  };

  "libcdr" = fetch {
    pname       = "libcdr";
    version     = "0.1.4";
    srcs        = [{ filename = "mingw-w64-i686-libcdr-0.1.4-3-any.pkg.tar.xz"; sha256 = "91c2b1025f44ad37bb7e71b2c6cdf2d6d025ba61ab68acf756bf7050360b6573"; }];
    buildInputs = [ icu lcms2 librevenge zlib ];
  };

  "libcerf" = fetch {
    pname       = "libcerf";
    version     = "1.11";
    srcs        = [{ filename = "mingw-w64-i686-libcerf-1.11-1-any.pkg.tar.xz"; sha256 = "10e1c5e57290e4ff69720d24a83d7932fbb1db2ed3236c43ab81a5bac1933f6a"; }];
    buildInputs = [  ];
  };

  "libchamplain" = fetch {
    pname       = "libchamplain";
    version     = "0.12.16";
    srcs        = [{ filename = "mingw-w64-i686-libchamplain-0.12.16-1-any.pkg.tar.xz"; sha256 = "484b3132e78ffa93e04eb74697005333dd05cadf1bcbd7adb8fef81aaa2d7c8d"; }];
    buildInputs = [ clutter clutter-gtk cairo libsoup memphis sqlite3 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "libconfig" = fetch {
    pname       = "libconfig";
    version     = "1.7.2";
    srcs        = [{ filename = "mingw-w64-i686-libconfig-1.7.2-1-any.pkg.tar.xz"; sha256 = "53ba95caf85272e6e40fd946c34386c3b88cb93816e8b4056e9490402d48dc23"; }];
    buildInputs = [ gcc-libs ];
  };

  "libcroco" = fetch {
    pname       = "libcroco";
    version     = "0.6.12";
    srcs        = [{ filename = "mingw-w64-i686-libcroco-0.6.12-1-any.pkg.tar.xz"; sha256 = "b04bf097c6b496815b147147cc31c02845e09f575f3251b045e68cb65b6778a9"; }];
    buildInputs = [ glib2 libxml2 ];
  };

  "libcue" = fetch {
    pname       = "libcue";
    version     = "2.2.1";
    srcs        = [{ filename = "mingw-w64-i686-libcue-2.2.1-1-any.pkg.tar.xz"; sha256 = "9a7c0aacf7c12c84ab7cd2bfa3ea5e6df30602d01bc80895ec5204f4746432a0"; }];
  };

  "libdatrie" = fetch {
    pname       = "libdatrie";
    version     = "0.2.12";
    srcs        = [{ filename = "mingw-w64-i686-libdatrie-0.2.12-1-any.pkg.tar.xz"; sha256 = "059e047a9b9a9f6023bf5723edbe3efe5ba2994515cb4c91af89e10002ef8ad1"; }];
    buildInputs = [ libiconv ];
  };

  "libdca" = fetch {
    pname       = "libdca";
    version     = "0.0.6";
    srcs        = [{ filename = "mingw-w64-i686-libdca-0.0.6-1-any.pkg.tar.xz"; sha256 = "5da9dddbcc95e0bf13010eeff0cdc8b70e101f83252e6aac5c54e434da935cf6"; }];
  };

  "libdiscid" = fetch {
    pname       = "libdiscid";
    version     = "0.6.2";
    srcs        = [{ filename = "mingw-w64-i686-libdiscid-0.6.2-1-any.pkg.tar.xz"; sha256 = "7572a06a524c9adbcd2df668cdda6d191013dc3f22b55b1cfdf786e167bf0fd0"; }];
  };

  "libdsm" = fetch {
    pname       = "libdsm";
    version     = "0.3.0";
    srcs        = [{ filename = "mingw-w64-i686-libdsm-0.3.0-1-any.pkg.tar.xz"; sha256 = "0867315d431e42b0956918ec7fb1c5d258976b168dee0ee5ff9ab8ac10e6c0a6"; }];
    buildInputs = [ libtasn1 ];
  };

  "libdvbpsi" = fetch {
    pname       = "libdvbpsi";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-i686-libdvbpsi-1.3.2-1-any.pkg.tar.xz"; sha256 = "b59a3a1ef0e7341d1f3bacf85a795ea3ccaf0b45366b4f358356b0af3d87073f"; }];
    buildInputs = [ gcc-libs ];
  };

  "libdvdcss" = fetch {
    pname       = "libdvdcss";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-i686-libdvdcss-1.4.2-1-any.pkg.tar.xz"; sha256 = "aaa6459a08267e925da9b521f90c2c6f35c328a30a71b42e152b0d90e3e4690b"; }];
    buildInputs = [ gcc-libs ];
  };

  "libdvdnav" = fetch {
    pname       = "libdvdnav";
    version     = "6.0.0";
    srcs        = [{ filename = "mingw-w64-i686-libdvdnav-6.0.0-1-any.pkg.tar.xz"; sha256 = "68fe0caaba9b611862123dc9047037ab0ecf36840b98a26c7c19ce6581e24f47"; }];
    buildInputs = [ libdvdread ];
  };

  "libdvdread" = fetch {
    pname       = "libdvdread";
    version     = "6.0.0";
    srcs        = [{ filename = "mingw-w64-i686-libdvdread-6.0.0-1-any.pkg.tar.xz"; sha256 = "5fed5ebfe7534bb416a81c17bda06fd1bf98c35918ca9aac3978d29e0a197829"; }];
    buildInputs = [ libdvdcss ];
  };

  "libebml" = fetch {
    pname       = "libebml";
    version     = "1.3.6";
    srcs        = [{ filename = "mingw-w64-i686-libebml-1.3.6-1-any.pkg.tar.xz"; sha256 = "9416c81fb501f6827e8ac6be4bcaf6adfa80822a74f56037ef0740326397bbbd"; }];
    buildInputs = [ gcc-libs ];
  };

  "libelf" = fetch {
    pname       = "libelf";
    version     = "0.8.13";
    srcs        = [{ filename = "mingw-w64-i686-libelf-0.8.13-4-any.pkg.tar.xz"; sha256 = "a7bdd1876f445d6fa22e44d1402b7247c42c254525c01336f0ce683f5c8ad610"; }];
    buildInputs = [  ];
  };

  "libepoxy" = fetch {
    pname       = "libepoxy";
    version     = "1.5.3";
    srcs        = [{ filename = "mingw-w64-i686-libepoxy-1.5.3-1-any.pkg.tar.xz"; sha256 = "b3fdbb83241044385cc3d0b4d9f57a4ff852231e6468f1240e8fd67ada3d954a"; }];
    buildInputs = [ gcc-libs ];
  };

  "libevent" = fetch {
    pname       = "libevent";
    version     = "2.1.8";
    srcs        = [{ filename = "mingw-w64-i686-libevent-2.1.8-1-any.pkg.tar.xz"; sha256 = "3d3a3657aae3db878bd5ab4c606ad5f834d5e3445c40cd307e082eedfcd53331"; }];
  };

  "libexif" = fetch {
    pname       = "libexif";
    version     = "0.6.21";
    srcs        = [{ filename = "mingw-w64-i686-libexif-0.6.21-4-any.pkg.tar.xz"; sha256 = "084920fa665385c19337fdca407375b346ded30e2a9413b1ae3cc41e20a67270"; }];
    buildInputs = [ gettext ];
  };

  "libffi" = fetch {
    pname       = "libffi";
    version     = "3.2.1";
    srcs        = [{ filename = "mingw-w64-i686-libffi-3.2.1-4-any.pkg.tar.xz"; sha256 = "d690987f8aff2cb5db45f3963c839be6c80f091fe966782115cf82be4b82ec91"; }];
    buildInputs = [  ];
  };

  "libfilezilla" = fetch {
    pname       = "libfilezilla";
    version     = "0.15.1";
    srcs        = [{ filename = "mingw-w64-i686-libfilezilla-0.15.1-1-any.pkg.tar.xz"; sha256 = "54a4f12365d8f48fea4f524bf649beb8b0da274fe29f4261a5a12a0ff41c1fd3"; }];
    buildInputs = [ gcc-libs nettle ];
  };

  "libfreexl" = fetch {
    pname       = "libfreexl";
    version     = "1.0.5";
    srcs        = [{ filename = "mingw-w64-i686-libfreexl-1.0.5-1-any.pkg.tar.xz"; sha256 = "23482d5ccb42ce1d4cccb7e8519f0dc16088eabb9021ea1489677ba554d7e152"; }];
    buildInputs = [  ];
  };

  "libftdi" = fetch {
    pname       = "libftdi";
    version     = "1.4";
    srcs        = [{ filename = "mingw-w64-i686-libftdi-1.4-2-any.pkg.tar.xz"; sha256 = "6657fc479bdae91e310723b890ca361bd5ce5d9bb0f46091f44f1204f72d9d3c"; }];
    buildInputs = [ libusb confuse gettext libiconv ];
  };

  "libgadu" = fetch {
    pname       = "libgadu";
    version     = "1.12.2";
    srcs        = [{ filename = "mingw-w64-i686-libgadu-1.12.2-1-any.pkg.tar.xz"; sha256 = "23c30c8b842054a721057907f2cbcaee4bc02986e244b8ed977cac9d82a666bc"; }];
    buildInputs = [ gnutls protobuf-c ];
  };

  "libgcrypt" = fetch {
    pname       = "libgcrypt";
    version     = "1.8.4";
    srcs        = [{ filename = "mingw-w64-i686-libgcrypt-1.8.4-1-any.pkg.tar.xz"; sha256 = "a1e036bb80f9ea9efaae550a9833d14261ed3058f408b5cff9a031495120074b"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libgd" = fetch {
    pname       = "libgd";
    version     = "2.2.5";
    srcs        = [{ filename = "mingw-w64-i686-libgd-2.2.5-1-any.pkg.tar.xz"; sha256 = "4bb6c42b8f89a7539d585115b52613d2e66d91ad2674d4ac1c599af4d5019eca"; }];
    buildInputs = [ libpng libiconv libjpeg libtiff freetype fontconfig libimagequant libwebp xpm-nox zlib ];
  };

  "libgda" = fetch {
    pname       = "libgda";
    version     = "5.2.4";
    srcs        = [{ filename = "mingw-w64-i686-libgda-5.2.4-1-any.pkg.tar.xz"; sha256 = "4d1d88d778c5823aafa05e7da19a43a4dd27dec6d8c4731d57f451c80269944a"; }];
    buildInputs = [ gtk3 gtksourceview3 goocanvas iso-codes json-glib libsoup libxml2 libxslt glade ];
  };

  "libgdata" = fetch {
    pname       = "libgdata";
    version     = "0.17.9";
    srcs        = [{ filename = "mingw-w64-i686-libgdata-0.17.9-1-any.pkg.tar.xz"; sha256 = "d0baba61b7be3c9dad14563ca84963086b1484706a820fdb3d4023735be57705"; }];
    buildInputs = [ glib2 gtk3 gdk-pixbuf2 json-glib liboauth libsoup libxml2 uhttpmock ];
  };

  "libgdiplus" = fetch {
    pname       = "libgdiplus";
    version     = "5.6";
    srcs        = [{ filename = "mingw-w64-i686-libgdiplus-5.6-1-any.pkg.tar.xz"; sha256 = "278fb5a37c0c58852dc8577fbbf1a098bf8b3f72d3bb14c8c89db7a874bafbfc"; }];
    buildInputs = [ libtiff cairo fontconfig freetype giflib glib2 libexif libpng zlib ];
  };

  "libgee" = fetch {
    pname       = "libgee";
    version     = "0.20.1";
    srcs        = [{ filename = "mingw-w64-i686-libgee-0.20.1-1-any.pkg.tar.xz"; sha256 = "ce29c169cd12e1c876185ee3593e960bf7a8ed331d3e29682f1baddb239a6615"; }];
    buildInputs = [ glib2 ];
  };

  "libgeotiff" = fetch {
    pname       = "libgeotiff";
    version     = "1.4.3";
    srcs        = [{ filename = "mingw-w64-i686-libgeotiff-1.4.3-1-any.pkg.tar.xz"; sha256 = "b73bc5130ab5d836fb5324711ab1fbf0e04c26558334791be8c71d36df7f0ca5"; }];
    buildInputs = [ gcc-libs libtiff libjpeg proj zlib ];
  };

  "libgit2" = fetch {
    pname       = "libgit2";
    version     = "0.27.7";
    srcs        = [{ filename = "mingw-w64-i686-libgit2-0.27.7-1-any.pkg.tar.xz"; sha256 = "88646187dcd8c1eba631d142076b9e7df75992d58df31cd32b11bbae620f8a8b"; }];
    buildInputs = [ curl http-parser libssh2 openssl zlib ];
  };

  "libgit2-glib" = fetch {
    pname       = "libgit2-glib";
    version     = "0.27.7";
    srcs        = [{ filename = "mingw-w64-i686-libgit2-glib-0.27.7-1-any.pkg.tar.xz"; sha256 = "15abdc35633f291c175392403f2d3afea8c86984a9a30f933d48760bddeefd2a"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libgit2.version "0.23"; libgit2) libssh2 glib2 ];
  };

  "libglade" = fetch {
    pname       = "libglade";
    version     = "2.6.4";
    srcs        = [{ filename = "mingw-w64-i686-libglade-2.6.4-5-any.pkg.tar.xz"; sha256 = "0bc64775c9da63a5778724fdd80e78aa0efabc6b9d5dfe42ecfe9de7c566869f"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.16.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.3"; libxml2) ];
  };

  "libgme" = fetch {
    pname       = "libgme";
    version     = "0.6.2";
    srcs        = [{ filename = "mingw-w64-i686-libgme-0.6.2-1-any.pkg.tar.xz"; sha256 = "2aeb2b38c505393916aa3d41d3dee1a310af9bfb85dff5e3f447cd03e5cae89a"; }];
    buildInputs = [ gcc-libs ];
  };

  "libgnomecanvas" = fetch {
    pname       = "libgnomecanvas";
    version     = "2.30.3";
    srcs        = [{ filename = "mingw-w64-i686-libgnomecanvas-2.30.3-3-any.pkg.tar.xz"; sha256 = "f9627cc3e435f113575932afa27a784dc99d1e370dfd3be68bb1d682ce3efced"; }];
    buildInputs = [ gtk2 gettext libart_lgpl libglade ];
  };

  "libgoom2" = fetch {
    pname       = "libgoom2";
    version     = "2k4";
    srcs        = [{ filename = "mingw-w64-i686-libgoom2-2k4-3-any.pkg.tar.xz"; sha256 = "6a2aa8cbf1ee5f1f195bca8fa788e85482bc467b1f49a1195f7f71b931a39299"; }];
    buildInputs = [ gcc-libs ];
  };

  "libgpg-error" = fetch {
    pname       = "libgpg-error";
    version     = "1.33";
    srcs        = [{ filename = "mingw-w64-i686-libgpg-error-1.33-1-any.pkg.tar.xz"; sha256 = "f1169c1aa82fe568788eb20cab98b29a1c78529d762c9b58e98bd8fae168cb10"; }];
    buildInputs = [ gcc-libs gettext ];
  };

  "libgphoto2" = fetch {
    pname       = "libgphoto2";
    version     = "2.5.21";
    srcs        = [{ filename = "mingw-w64-i686-libgphoto2-2.5.21-1-any.pkg.tar.xz"; sha256 = "3a3cebeebc5bde289c916eb9e097100810120d785e65695acc9bb7bd38e3133c"; }];
    buildInputs = [ libsystre libjpeg libxml2 libgd libexif libusb ];
  };

  "libgsf" = fetch {
    pname       = "libgsf";
    version     = "1.14.45";
    srcs        = [{ filename = "mingw-w64-i686-libgsf-1.14.45-1-any.pkg.tar.xz"; sha256 = "162b2dabe247db237aa1b23037332b2c6f8bc93c900000a04e8019f201ae8095"; }];
    buildInputs = [ glib2 gdk-pixbuf2 libxml2 zlib ];
  };

  "libguess" = fetch {
    pname       = "libguess";
    version     = "1.2";
    srcs        = [{ filename = "mingw-w64-i686-libguess-1.2-3-any.pkg.tar.xz"; sha256 = "a289467fa311deba5f363a26a20a615101884eb88d2442dd7ac0fc490a45f22b"; }];
    buildInputs = [ libmowgli ];
  };

  "libgusb" = fetch {
    pname       = "libgusb";
    version     = "0.2.11";
    srcs        = [{ filename = "mingw-w64-i686-libgusb-0.2.11-1-any.pkg.tar.xz"; sha256 = "8289db3e82239ae8ab93a279ccc0a2fbfef87cb5454fced27f058b9053f06b75"; }];
    buildInputs = [ libusb glib2 ];
  };

  "libgweather" = fetch {
    pname       = "libgweather";
    version     = "3.28.2";
    srcs        = [{ filename = "mingw-w64-i686-libgweather-3.28.2-1-any.pkg.tar.xz"; sha256 = "51749602a6be32f365b0449cf7bdd2905231b3f593d79c49c60bb23f034449bd"; }];
    buildInputs = [ gtk3 libsoup libsystre libxml2 geocode-glib ];
  };

  "libgxps" = fetch {
    pname       = "libgxps";
    version     = "0.3.1";
    srcs        = [{ filename = "mingw-w64-i686-libgxps-0.3.1-1-any.pkg.tar.xz"; sha256 = "ad733c0627719cb63c290651d03dbc722885be5591ae49053715725076c4dead"; }];
    buildInputs = [ glib2 gtk3 cairo lcms2 libarchive libjpeg libxslt libpng ];
  };

  "libharu" = fetch {
    pname       = "libharu";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-libharu-2.3.0-2-any.pkg.tar.xz"; sha256 = "ae6a4182e460f663a205440136699370197ef4556cee33523ee511bf95b5d734"; }];
    buildInputs = [ libpng ];
  };

  "libical" = fetch {
    pname       = "libical";
    version     = "3.0.4";
    srcs        = [{ filename = "mingw-w64-i686-libical-3.0.4-1-any.pkg.tar.xz"; sha256 = "d0f6977e88661041d6fd8e3d40fc504c80b0e5b003b31aa7164d723a006c891c"; }];
    buildInputs = [ gcc-libs icu glib2 gobject-introspection libxml2 db ];
  };

  "libiconv" = fetch {
    pname       = "libiconv";
    version     = "1.15";
    srcs        = [{ filename = "mingw-w64-i686-libiconv-1.15-3-any.pkg.tar.xz"; sha256 = "a8e73e531344cd3a699cc70f5e98ad24f7a6416b77847ad14956102e5f53d1e9"; }];
    buildInputs = [  ];
  };

  "libidl2" = fetch {
    pname       = "libidl2";
    version     = "0.8.14";
    srcs        = [{ filename = "mingw-w64-i686-libidl2-0.8.14-1-any.pkg.tar.xz"; sha256 = "fcb98c60fe41d202a98e4dfb3ea725edb4ae49d20d1422781e9548f0c4105e31"; }];
    buildInputs = [ glib2 ];
  };

  "libidn" = fetch {
    pname       = "libidn";
    version     = "1.35";
    srcs        = [{ filename = "mingw-w64-i686-libidn-1.35-1-any.pkg.tar.xz"; sha256 = "05db89998887bea39fe85716670cc0eca3d7a2a914a0fd0c702edd4e8667376a"; }];
    buildInputs = [ gettext ];
  };

  "libidn2" = fetch {
    pname       = "libidn2";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-i686-libidn2-2.1.0-1-any.pkg.tar.xz"; sha256 = "5dffc707e83d065c8ccd7aa98390c48de2f734fe113c4bee34c20b85b60c4df0"; }];
    buildInputs = [ gettext libunistring ];
  };

  "libilbc" = fetch {
    pname       = "libilbc";
    version     = "2.0.2";
    srcs        = [{ filename = "mingw-w64-i686-libilbc-2.0.2-1-any.pkg.tar.xz"; sha256 = "9c448f259edf1cae1db449efbbf2a9ed90b4161300341c57cc327bca30cc991b"; }];
  };

  "libimagequant" = fetch {
    pname       = "libimagequant";
    version     = "2.12.2";
    srcs        = [{ filename = "mingw-w64-i686-libimagequant-2.12.2-1-any.pkg.tar.xz"; sha256 = "e5c5c0e0b1b03a59be9e582a1c31ad3b3015d33148dc3fcd64d3e8ee1c58886e"; }];
    buildInputs = [  ];
  };

  "libimobiledevice" = fetch {
    pname       = "libimobiledevice";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-libimobiledevice-1.2.0-1-any.pkg.tar.xz"; sha256 = "2d3443795bfc23a2c795640b34d9fa3b9b1f0e5ed4e3ff1e3d71430770687939"; }];
    buildInputs = [ libusbmuxd libplist openssl ];
  };

  "libjpeg-turbo" = fetch {
    pname       = "libjpeg-turbo";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-i686-libjpeg-turbo-2.0.1-1-any.pkg.tar.xz"; sha256 = "db32b9d1f52c97b7cab452d959bf6559948e814644c887e48b0ed4690403272f"; }];
    buildInputs = [ gcc-libs ];
  };

  "libkml" = fetch {
    pname       = "libkml";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-libkml-1.3.0-5-any.pkg.tar.xz"; sha256 = "2626c08fa523dc0a3a6096b7707535b1376e97b60981da0bc18a03174c204e4a"; }];
    buildInputs = [ boost minizip uriparser zlib ];
  };

  "libksba" = fetch {
    pname       = "libksba";
    version     = "1.3.5";
    srcs        = [{ filename = "mingw-w64-i686-libksba-1.3.5-1-any.pkg.tar.xz"; sha256 = "22aba63244eb4acfb97748bd0d76318b3c180823fe9160c1c793095decb5ee3f"; }];
    buildInputs = [ libgpg-error ];
  };

  "liblas" = fetch {
    pname       = "liblas";
    version     = "1.8.1";
    srcs        = [{ filename = "mingw-w64-i686-liblas-1.8.1-1-any.pkg.tar.xz"; sha256 = "476ad7968f49fed1e96ef5d3bbca93f970deb8a894ad9a269393fd2b483ceaf6"; }];
    buildInputs = [ gdal laszip ];
  };

  "liblastfm" = fetch {
    pname       = "liblastfm";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-i686-liblastfm-1.0.9-2-any.pkg.tar.xz"; sha256 = "08cefaa608316ac7f77301114be950e7fdbfed91f07d9e78326838553fae8cd3"; }];
    buildInputs = [ qt5 fftw libsamplerate ];
  };

  "liblastfm-qt4" = fetch {
    pname       = "liblastfm-qt4";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-i686-liblastfm-qt4-1.0.9-1-any.pkg.tar.xz"; sha256 = "2e378890cf50eded33edb4a2189a2c8b4874fc7feb316e116735849f8c42254b"; }];
    buildInputs = [ qt4 fftw libsamplerate ];
  };

  "liblqr" = fetch {
    pname       = "liblqr";
    version     = "0.4.2";
    srcs        = [{ filename = "mingw-w64-i686-liblqr-0.4.2-4-any.pkg.tar.xz"; sha256 = "080a3650b88e743430baab0548f267ed3738986e7b5a455212f59c79599279ce"; }];
    buildInputs = [ glib2 ];
  };

  "libmad" = fetch {
    pname       = "libmad";
    version     = "0.15.1b";
    srcs        = [{ filename = "mingw-w64-i686-libmad-0.15.1b-4-any.pkg.tar.xz"; sha256 = "172c51cabb87e762454f0b1573984bbf743eee659e8e37d6e73b5f57081fdda8"; }];
    buildInputs = [  ];
  };

  "libmangle-git" = fetch {
    pname       = "libmangle-git";
    version     = "7.0.0.5230.69c8fad6";
    srcs        = [{ filename = "mingw-w64-i686-libmangle-git-7.0.0.5230.69c8fad6-1-any.pkg.tar.xz"; sha256 = "38fb3eeac014b16166f9b596755c56b9b86db2fcaba72e8b49ae0b8da7b3b00e"; }];
  };

  "libmariadbclient" = fetch {
    pname       = "libmariadbclient";
    version     = "2.3.7";
    srcs        = [{ filename = "mingw-w64-i686-libmariadbclient-2.3.7-1-any.pkg.tar.xz"; sha256 = "6c2e94d3cddf7cc3d5250653456b2f44c4cce2f24fdd179bcfa8f2a1304f5e6c"; }];
    buildInputs = [ gcc-libs openssl zlib ];
  };

  "libmatroska" = fetch {
    pname       = "libmatroska";
    version     = "1.4.9";
    srcs        = [{ filename = "mingw-w64-i686-libmatroska-1.4.9-2-any.pkg.tar.xz"; sha256 = "f1c1a7b5a870d1cf38f833eb9a751b40e81e448394c42a89902d74352c00e94a"; }];
    buildInputs = [ libebml ];
  };

  "libmaxminddb" = fetch {
    pname       = "libmaxminddb";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-i686-libmaxminddb-1.3.2-1-any.pkg.tar.xz"; sha256 = "7db4133f04d2cf286b66c33e9fd776d6f44b0e1251d4970497246a387e6eb35a"; }];
    buildInputs = [ gcc-libs geoip2-database ];
  };

  "libmetalink" = fetch {
    pname       = "libmetalink";
    version     = "0.1.3";
    srcs        = [{ filename = "mingw-w64-i686-libmetalink-0.1.3-3-any.pkg.tar.xz"; sha256 = "6abbb39400f04f8c90cbd6b366a15df7228ddda7c9430314968e2d9118bd14ba"; }];
    buildInputs = [ gcc-libs expat ];
  };

  "libmfx" = fetch {
    pname       = "libmfx";
    version     = "1.25";
    srcs        = [{ filename = "mingw-w64-i686-libmfx-1.25-1-any.pkg.tar.xz"; sha256 = "6c1727331b72c4dd778401d47e854ab12966dd18c39ad938fbdd8692ad079b52"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmicrodns" = fetch {
    pname       = "libmicrodns";
    version     = "0.0.10";
    srcs        = [{ filename = "mingw-w64-i686-libmicrodns-0.0.10-1-any.pkg.tar.xz"; sha256 = "7328b4783d4cc827edebac39279e622b3033e0e4491ac90fd99e415685501a3c"; }];
    buildInputs = [ libtasn1 ];
  };

  "libmicrohttpd" = fetch {
    pname       = "libmicrohttpd";
    version     = "0.9.62";
    srcs        = [{ filename = "mingw-w64-i686-libmicrohttpd-0.9.62-1-any.pkg.tar.xz"; sha256 = "3ca114e146debb3591ed00a27014da2ea491aed9edbe32064e1a52b05655ce89"; }];
    buildInputs = [ gnutls ];
  };

  "libmicroutils" = fetch {
    pname       = "libmicroutils";
    version     = "4.3.0";
    srcs        = [{ filename = "mingw-w64-i686-libmicroutils-4.3.0-1-any.pkg.tar.xz"; sha256 = "fa146f157b4cf85164bcfc8ca9ae1695562f51cd47d6d17746bbd8e7aef49800"; }];
    buildInputs = [ libsystre ];
  };

  "libmikmod" = fetch {
    pname       = "libmikmod";
    version     = "3.3.11.1";
    srcs        = [{ filename = "mingw-w64-i686-libmikmod-3.3.11.1-1-any.pkg.tar.xz"; sha256 = "19ea219ca201cea5c51bb64dba37080b0f88ce4853a1830d7c6fdce20c4f6ffa"; }];
    buildInputs = [ gcc-libs openal ];
  };

  "libmimic" = fetch {
    pname       = "libmimic";
    version     = "1.0.4";
    srcs        = [{ filename = "mingw-w64-i686-libmimic-1.0.4-3-any.pkg.tar.xz"; sha256 = "c9605e2b87bf834264bf71073ea684c288d77e967a6b6c031dac5c24928d1c96"; }];
    buildInputs = [ glib2 ];
  };

  "libmng" = fetch {
    pname       = "libmng";
    version     = "2.0.3";
    srcs        = [{ filename = "mingw-w64-i686-libmng-2.0.3-4-any.pkg.tar.xz"; sha256 = "77056da7beeae784c46d92f0425da9bbef3a12fe9333c58d567e78696cb1817b"; }];
    buildInputs = [ libjpeg-turbo lcms2 zlib ];
  };

  "libmodbus-git" = fetch {
    pname       = "libmodbus-git";
    version     = "658.0e2f470";
    srcs        = [{ filename = "mingw-w64-i686-libmodbus-git-658.0e2f470-1-any.pkg.tar.xz"; sha256 = "3977f5f5817950ada9341adb2ceb4d214978370bda19155cbe5b362601324051"; }];
  };

  "libmodplug" = fetch {
    pname       = "libmodplug";
    version     = "0.8.9.0";
    srcs        = [{ filename = "mingw-w64-i686-libmodplug-0.8.9.0-1-any.pkg.tar.xz"; sha256 = "0d9f118056139340c2b1dbc9ba44ac95631172608cc92dd3360a90741bc0aaf4"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmongoose" = fetch {
    pname       = "libmongoose";
    version     = "6.4";
    srcs        = [{ filename = "mingw-w64-i686-libmongoose-6.4-1-any.pkg.tar.xz"; sha256 = "b819d785fc857735b01deb96499a588d9995a95dcde99558ec77d9472891473e"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmongoose-git" = fetch {
    pname       = "libmongoose-git";
    version     = "r1793.41b405d";
    srcs        = [{ filename = "mingw-w64-i686-libmongoose-git-r1793.41b405d-3-any.pkg.tar.xz"; sha256 = "94dd7f4bcf48b138383896c49cf643896d7485f4d5ca3d07dd42b2d5607bf37a"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmowgli" = fetch {
    pname       = "libmowgli";
    version     = "2.1.3";
    srcs        = [{ filename = "mingw-w64-i686-libmowgli-2.1.3-3-any.pkg.tar.xz"; sha256 = "93b089caca7782c639c67e061a25c2614923cbb3abd4f25c3564a92781f6dd57"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmpack" = fetch {
    pname       = "libmpack";
    version     = "1.0.5";
    srcs        = [{ filename = "mingw-w64-i686-libmpack-1.0.5-1-any.pkg.tar.xz"; sha256 = "f7fabbe9a67f9133290084d279576c85d3de9e9be8e77047cc37a2b246d83738"; }];
  };

  "libmpcdec" = fetch {
    pname       = "libmpcdec";
    version     = "1.2.6";
    srcs        = [{ filename = "mingw-w64-i686-libmpcdec-1.2.6-3-any.pkg.tar.xz"; sha256 = "8032ff97fd278deaa5cb712b7f5d1e7b265848ab78438e7792bd59caac377db3"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmpeg2-git" = fetch {
    pname       = "libmpeg2-git";
    version     = "r1108.946bf4b";
    srcs        = [{ filename = "mingw-w64-i686-libmpeg2-git-r1108.946bf4b-1-any.pkg.tar.xz"; sha256 = "b57c4cd284f316ce691335d21551c7900a2e1139029ce402ef452c03facbbcd2"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmypaint" = fetch {
    pname       = "libmypaint";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-libmypaint-1.3.0-4-any.pkg.tar.xz"; sha256 = "3fd0174a31ad54d332533ecbbce75ac9253383baf40cc4d25783bf736ec84aed"; }];
    buildInputs = [ gcc-libs glib2 json-c ];
  };

  "libmysofa" = fetch {
    pname       = "libmysofa";
    version     = "0.6";
    srcs        = [{ filename = "mingw-w64-i686-libmysofa-0.6-1-any.pkg.tar.xz"; sha256 = "bb402cb23c6f7bfe5385d137ead44514de66709cfc41b9317a71a483acc64b55"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "libnfs" = fetch {
    pname       = "libnfs";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-i686-libnfs-3.0.0-1-any.pkg.tar.xz"; sha256 = "2c1d1b12a061f6252d45eaa53cadaa07e309c18f44693161fc2c2cefc3172b5c"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnice" = fetch {
    pname       = "libnice";
    version     = "0.1.14";
    srcs        = [{ filename = "mingw-w64-i686-libnice-0.1.14-1-any.pkg.tar.xz"; sha256 = "c9fd3c0b2de5aa497e44c792eebf7a49ea05f555721714a1895694c4545a9879"; }];
    buildInputs = [ glib2 ];
  };

  "libnotify" = fetch {
    pname       = "libnotify";
    version     = "0.7.7";
    srcs        = [{ filename = "mingw-w64-i686-libnotify-0.7.7-1-any.pkg.tar.xz"; sha256 = "e4d42f74ce2f7ae9afcb865815137a2b18d5970f1f10317739703498fe8e1dcc"; }];
    buildInputs = [ gdk-pixbuf2 ];
  };

  "libnova" = fetch {
    pname       = "libnova";
    version     = "0.15.0";
    srcs        = [{ filename = "mingw-w64-i686-libnova-0.15.0-1-any.pkg.tar.xz"; sha256 = "4c46157bad4cffbfee94f7cc173f31bc40364df49571d99b8738ae2d21a4f392"; }];
  };

  "libntlm" = fetch {
    pname       = "libntlm";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-i686-libntlm-1.5-1-any.pkg.tar.xz"; sha256 = "5b74084b45bac8dc2ffc856e2e717355b5a2b2a4805468a21e5809dffd54f983"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnumbertext" = fetch {
    pname       = "libnumbertext";
    version     = "1.0.5";
    srcs        = [{ filename = "mingw-w64-i686-libnumbertext-1.0.5-1-any.pkg.tar.xz"; sha256 = "ff6c42b4d8c3d014aade7cb587465f7460b62c16e1f044815555b3fbc8d8b7e8"; }];
    buildInputs = [ gcc-libs ];
  };

  "liboauth" = fetch {
    pname       = "liboauth";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-i686-liboauth-1.0.3-6-any.pkg.tar.xz"; sha256 = "6f1ca63318b18e286a6cbf3d71ebbe739abca3a8ebe17ac2aca52f21bd41c9ce"; }];
    buildInputs = [ curl nss ];
  };

  "libodfgen" = fetch {
    pname       = "libodfgen";
    version     = "0.1.7";
    srcs        = [{ filename = "mingw-w64-i686-libodfgen-0.1.7-1-any.pkg.tar.xz"; sha256 = "6d07baedcaec60648ba27a98c7dcee928f9577d013e9c4f5fd47ded804cfad2d"; }];
    buildInputs = [ librevenge ];
  };

  "libogg" = fetch {
    pname       = "libogg";
    version     = "1.3.3";
    srcs        = [{ filename = "mingw-w64-i686-libogg-1.3.3-1-any.pkg.tar.xz"; sha256 = "81cf98d0d5fa5faa1af3fb514e6ff77f98d52ebe6035ac9b7aaad5fccfb3d752"; }];
    buildInputs = [  ];
  };

  "libopusenc" = fetch {
    pname       = "libopusenc";
    version     = "0.2.1";
    srcs        = [{ filename = "mingw-w64-i686-libopusenc-0.2.1-1-any.pkg.tar.xz"; sha256 = "00cade8b795e547e9a4abd2c922023416286acf2ec7f73788cbc8e2c5d7f360b"; }];
    buildInputs = [ gcc-libs opus ];
  };

  "libosmpbf-git" = fetch {
    pname       = "libosmpbf-git";
    version     = "1.3.3.13.g4edb4f0";
    srcs        = [{ filename = "mingw-w64-i686-libosmpbf-git-1.3.3.13.g4edb4f0-1-any.pkg.tar.xz"; sha256 = "e309fa2f2875a95da870ab3284f0cbf4b82f29df2b6c1f3fcbd43f13e5d9671c"; }];
    buildInputs = [ protobuf ];
  };

  "libotr" = fetch {
    pname       = "libotr";
    version     = "4.1.1";
    srcs        = [{ filename = "mingw-w64-i686-libotr-4.1.1-2-any.pkg.tar.xz"; sha256 = "a0a1e844eb74c80eaedd280c97c76ac24e3b4ad9795e3c96e6f78dfd4ac1f281"; }];
    buildInputs = [ libgcrypt ];
  };

  "libpaper" = fetch {
    pname       = "libpaper";
    version     = "1.1.24";
    srcs        = [{ filename = "mingw-w64-i686-libpaper-1.1.24-2-any.pkg.tar.xz"; sha256 = "34a2d6eff048e327619f3fa7308756916d754cdaf523b73328e4ef34f0501b64"; }];
    buildInputs = [  ];
  };

  "libpeas" = fetch {
    pname       = "libpeas";
    version     = "1.22.0";
    srcs        = [{ filename = "mingw-w64-i686-libpeas-1.22.0-3-any.pkg.tar.xz"; sha256 = "321651328989c766da6a36a24ef1740cf1dfdf2297f5feedc5fec6f60732eaa5"; }];
    buildInputs = [ gcc-libs gtk3 adwaita-icon-theme ];
  };

  "libplacebo" = fetch {
    pname       = "libplacebo";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-i686-libplacebo-1.7.0-1-any.pkg.tar.xz"; sha256 = "aab6502ee6e6b6a035866a67097f1a74446ab4675b4913aa5a99bc84ec4933bd"; }];
    buildInputs = [ vulkan ];
  };

  "libplist" = fetch {
    pname       = "libplist";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-libplist-2.0.0-3-any.pkg.tar.xz"; sha256 = "cdc289a0a5a6debd449eb612af6f07d2e3739a28c7cad77f1b8923280aaa8298"; }];
    buildInputs = [ libxml2 cython ];
  };

  "libpng" = fetch {
    pname       = "libpng";
    version     = "1.6.36";
    srcs        = [{ filename = "mingw-w64-i686-libpng-1.6.36-1-any.pkg.tar.xz"; sha256 = "74bbdbbfb90ecf886c254a45cf6f1896876d898749c945134cbe29ae76450f9f"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "libproxy" = fetch {
    pname       = "libproxy";
    version     = "0.4.15";
    srcs        = [{ filename = "mingw-w64-i686-libproxy-0.4.15-2-any.pkg.tar.xz"; sha256 = "8b509849d083579f12506a22d948c6cdc8794d5425554ccfa6ee428b418a3949"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpsl" = fetch {
    pname       = "libpsl";
    version     = "0.20.2";
    srcs        = [{ filename = "mingw-w64-i686-libpsl-0.20.2-2-any.pkg.tar.xz"; sha256 = "e34afb562b306355adacb21261a50d7ddd1393beb04c83d0504ab9fb2f41562a"; }];
    buildInputs = [ libidn2 libunistring gettext ];
  };

  "libraqm" = fetch {
    pname       = "libraqm";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-i686-libraqm-0.5.0-1-any.pkg.tar.xz"; sha256 = "589a56cc85072d0faa4e4f37e7cd67c17e2baf73046ff6ff6f829f718de53485"; }];
    buildInputs = [ freetype glib2 harfbuzz fribidi ];
  };

  "libraw" = fetch {
    pname       = "libraw";
    version     = "0.19.2";
    srcs        = [{ filename = "mingw-w64-i686-libraw-0.19.2-1-any.pkg.tar.xz"; sha256 = "85573b2dd234862ee2f04faced0be6ee66ee9e8b5be7fdb45761499368f49cd7"; }];
    buildInputs = [ gcc-libs lcms2 jasper ];
  };

  "librescl" = fetch {
    pname       = "librescl";
    version     = "0.3.3";
    srcs        = [{ filename = "mingw-w64-i686-librescl-0.3.3-1-any.pkg.tar.xz"; sha256 = "347c5cfd4d5dd1183e68495999804bd62e7170bc39287684ca26522aebad107c"; }];
    buildInputs = [ gcc-libs gettext (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.34.0"; glib2) gobject-introspection gxml libgee libxml2 vala xz zlib ];
  };

  "libressl" = fetch {
    pname       = "libressl";
    version     = "2.8.2";
    srcs        = [{ filename = "mingw-w64-i686-libressl-2.8.2-1-any.pkg.tar.xz"; sha256 = "ca1b7e4d8c25094a12f0931934d6345a38882f6c024e3267f52d93f99832c3cd"; }];
    buildInputs = [ gcc-libs ];
  };

  "librest" = fetch {
    pname       = "librest";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-i686-librest-0.8.1-1-any.pkg.tar.xz"; sha256 = "d33bdb734d52d267433c772efba166c7b23a6d94406889f65108d3ebf930bf3c"; }];
    buildInputs = [ glib2 libsoup libxml2 ];
  };

  "librevenge" = fetch {
    pname       = "librevenge";
    version     = "0.0.4";
    srcs        = [{ filename = "mingw-w64-i686-librevenge-0.0.4-2-any.pkg.tar.xz"; sha256 = "3508a3f5c6bd53476983fd66075e2b859da4cfb93020c67f7f8eae037eada5dd"; }];
    buildInputs = [ gcc-libs boost zlib ];
  };

  "librsvg" = fetch {
    pname       = "librsvg";
    version     = "2.40.20";
    srcs        = [{ filename = "mingw-w64-i686-librsvg-2.40.20-1-any.pkg.tar.xz"; sha256 = "4e8fed09db19acbc22fba15b816c1915bf86b0b58dc17f34b09fa694daf72fc4"; }];
    buildInputs = [ gdk-pixbuf2 pango libcroco ];
  };

  "librsync" = fetch {
    pname       = "librsync";
    version     = "2.0.2";
    srcs        = [{ filename = "mingw-w64-i686-librsync-2.0.2-1-any.pkg.tar.xz"; sha256 = "7104cbd13508316ddc4f40ab68bbb4f726711b92e848aa6d1ccc86b128260016"; }];
    buildInputs = [ gcc-libs popt ];
  };

  "libsamplerate" = fetch {
    pname       = "libsamplerate";
    version     = "0.1.9";
    srcs        = [{ filename = "mingw-w64-i686-libsamplerate-0.1.9-1-any.pkg.tar.xz"; sha256 = "173b951f1ebed1ab5b99500d33913e2f43819a164d386cc894a00b2b43152137"; }];
    buildInputs = [ libsndfile fftw ];
  };

  "libsass" = fetch {
    pname       = "libsass";
    version     = "3.5.5";
    srcs        = [{ filename = "mingw-w64-i686-libsass-3.5.5-1-any.pkg.tar.xz"; sha256 = "aa420c5e3b60fc8176c71ebbb378d3df07b138b18ed34352c7b62eb282e28d99"; }];
  };

  "libsbml" = fetch {
    pname       = "libsbml";
    version     = "5.17.0";
    srcs        = [{ filename = "mingw-w64-i686-libsbml-5.17.0-1-any.pkg.tar.xz"; sha256 = "e1cace4341e9a93e5aaaecd6cffacfbf71bb51bd9aa050e7fb5a82bb7ad1bd00"; }];
    buildInputs = [ libxml2 ];
  };

  "libsecret" = fetch {
    pname       = "libsecret";
    version     = "0.18";
    srcs        = [{ filename = "mingw-w64-i686-libsecret-0.18-5-any.pkg.tar.xz"; sha256 = "21320479ed3307de4717d07ce58754d7f8050078d8831ed07d86514d68df6d26"; }];
    buildInputs = [ gcc-libs glib2 libgcrypt ];
  };

  "libshout" = fetch {
    pname       = "libshout";
    version     = "2.4.1";
    srcs        = [{ filename = "mingw-w64-i686-libshout-2.4.1-2-any.pkg.tar.xz"; sha256 = "99fb058bcb8c3fe9a351d4c274cbae621396c1d57aac53b9d58c7ceb69733921"; }];
    buildInputs = [ libvorbis libtheora openssl speex ];
  };

  "libsigc++" = fetch {
    pname       = "libsigc++";
    version     = "2.10.1";
    srcs        = [{ filename = "mingw-w64-i686-libsigc++-2.10.1-1-any.pkg.tar.xz"; sha256 = "739358e9edebe1a6d34aa6debac663efac774f211b06b083876505fa9ac8dfc4"; }];
    buildInputs = [ gcc-libs ];
  };

  "libsigc++3" = fetch {
    pname       = "libsigc++3";
    version     = "2.99.11";
    srcs        = [{ filename = "mingw-w64-i686-libsigc++3-2.99.11-1-any.pkg.tar.xz"; sha256 = "cc8d64402f12367f3b57f24b4f3c85af8904207736b26da949ceb86dc75deacf"; }];
    buildInputs = [ gcc-libs ];
  };

  "libsignal-protocol-c-git" = fetch {
    pname       = "libsignal-protocol-c-git";
    version     = "r34.16bfd04";
    srcs        = [{ filename = "mingw-w64-i686-libsignal-protocol-c-git-r34.16bfd04-1-any.pkg.tar.xz"; sha256 = "fa17aa734fdc03e4b9a6fa89c2b76da55fb4a46728a99ca90f1ac9ecc5083702"; }];
  };

  "libsigsegv" = fetch {
    pname       = "libsigsegv";
    version     = "2.12";
    srcs        = [{ filename = "mingw-w64-i686-libsigsegv-2.12-1-any.pkg.tar.xz"; sha256 = "d84885c2020d7a4ac66be912196cb2a244e7e27c1b48b9258954d5fbd29a03b7"; }];
    buildInputs = [  ];
  };

  "libsndfile" = fetch {
    pname       = "libsndfile";
    version     = "1.0.28";
    srcs        = [{ filename = "mingw-w64-i686-libsndfile-1.0.28-1-any.pkg.tar.xz"; sha256 = "a4b40652a12e30e8ef41ed9fa12f6c2baa7b0e3794e07aacf2bf29df05250db7"; }];
    buildInputs = [ flac libvorbis speex ];
  };

  "libsodium" = fetch {
    pname       = "libsodium";
    version     = "1.0.17";
    srcs        = [{ filename = "mingw-w64-i686-libsodium-1.0.17-1-any.pkg.tar.xz"; sha256 = "784c7128e66ea926916d9dce36450b284ac3462984317b4c2ea704615108935a"; }];
    buildInputs = [ gcc-libs ];
  };

  "libsoup" = fetch {
    pname       = "libsoup";
    version     = "2.64.2";
    srcs        = [{ filename = "mingw-w64-i686-libsoup-2.64.2-1-any.pkg.tar.xz"; sha256 = "758814798f0774f9e4eaccc6746638c848a822e7ac327f4fd60a67ecb2448671"; }];
    buildInputs = [ gcc-libs glib2 glib-networking libxml2 libpsl sqlite3 ];
  };

  "libsoxr" = fetch {
    pname       = "libsoxr";
    version     = "0.1.3";
    srcs        = [{ filename = "mingw-w64-i686-libsoxr-0.1.3-1-any.pkg.tar.xz"; sha256 = "57ee74d102c9089a1ba063757c37e8bc2a3de680fad2c85f85d546adc800d25a"; }];
    buildInputs = [ gcc-libs ];
  };

  "libspatialite" = fetch {
    pname       = "libspatialite";
    version     = "4.3.0.a";
    srcs        = [{ filename = "mingw-w64-i686-libspatialite-4.3.0.a-3-any.pkg.tar.xz"; sha256 = "f52d7dbf195708e6d7cc51f848f1668e441b1d67aa0142816b711281211286c4"; }];
    buildInputs = [ geos libfreexl libxml2 proj sqlite3 libiconv ];
  };

  "libspectre" = fetch {
    pname       = "libspectre";
    version     = "0.2.8";
    srcs        = [{ filename = "mingw-w64-i686-libspectre-0.2.8-2-any.pkg.tar.xz"; sha256 = "a0f0ad5bbce7198e7433582f806ffa1d293095f17927680a1952a222df40846f"; }];
    buildInputs = [ ghostscript cairo ];
  };

  "libspiro" = fetch {
    pname       = "libspiro";
    version     = "1~0.5.20150702";
    srcs        = [{ filename = "mingw-w64-i686-libspiro-1~0.5.20150702-2-any.pkg.tar.xz"; sha256 = "c6b0a3b351e10abf86617768f12cb3f06efb43ef98f9253062a828bc8707df0b"; }];
  };

  "libsquish" = fetch {
    pname       = "libsquish";
    version     = "1.15";
    srcs        = [{ filename = "mingw-w64-i686-libsquish-1.15-1-any.pkg.tar.xz"; sha256 = "36232d849895fa9c5cb04d5ddc2bf7ce422ae33f4fc542b1c99d8fed8d2ae27c"; }];
    buildInputs = [  ];
  };

  "libsrtp" = fetch {
    pname       = "libsrtp";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-i686-libsrtp-2.2.0-2-any.pkg.tar.xz"; sha256 = "1631f7e8d002b5d97e98caebb87a7dc7a8448316e957d2556c12d16a740bd85c"; }];
    buildInputs = [ openssl ];
  };

  "libssh" = fetch {
    pname       = "libssh";
    version     = "0.8.6";
    srcs        = [{ filename = "mingw-w64-i686-libssh-0.8.6-1-any.pkg.tar.xz"; sha256 = "f8f2c02f7b710e48a11eee1d11fc903072a35cc5638e6e9e56f42079f2ebdb14"; }];
    buildInputs = [ openssl zlib ];
  };

  "libssh2" = fetch {
    pname       = "libssh2";
    version     = "1.8.0";
    srcs        = [{ filename = "mingw-w64-i686-libssh2-1.8.0-3-any.pkg.tar.xz"; sha256 = "237b40d5f8530750832ef25c7f6df35f4c26b6217e188419fcab4dd585293571"; }];
    buildInputs = [ openssl zlib ];
  };

  "libswift" = fetch {
    pname       = "libswift";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-i686-libswift-1.0.0-2-any.pkg.tar.xz"; sha256 = "0aa6a4d19fc4a674c948d17e19f57e96d37611dc5621c7971fc51f37ab7a185b"; }];
    buildInputs = [ gcc-libs bzip2 libiconv libpng freetype glfw zlib ];
  };

  "libsystre" = fetch {
    pname       = "libsystre";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-libsystre-1.0.1-4-any.pkg.tar.xz"; sha256 = "3a400210f7f366c63d000d910203257643b4de1409d09d12da86e76acb4dd407"; }];
    buildInputs = [ libtre-git ];
  };

  "libtasn1" = fetch {
    pname       = "libtasn1";
    version     = "4.13";
    srcs        = [{ filename = "mingw-w64-i686-libtasn1-4.13-1-any.pkg.tar.xz"; sha256 = "f94133b4feae54f1787f0454dfb3f654730ac465d4f9de88a73a27481e3c893b"; }];
    buildInputs = [ gcc-libs ];
  };

  "libthai" = fetch {
    pname       = "libthai";
    version     = "0.1.28";
    srcs        = [{ filename = "mingw-w64-i686-libthai-0.1.28-2-any.pkg.tar.xz"; sha256 = "9ca5ce1b9eed1be47273623df8da6e7cb27eb321d328b27e32b5962c8c3ec285"; }];
    buildInputs = [ libdatrie ];
  };

  "libtheora" = fetch {
    pname       = "libtheora";
    version     = "1.1.1";
    srcs        = [{ filename = "mingw-w64-i686-libtheora-1.1.1-4-any.pkg.tar.xz"; sha256 = "17fd504e293820cbb44e7553d53603fc5e3519e235f00505831b1a090ab984f4"; }];
    buildInputs = [ libpng libogg libvorbis ];
  };

  "libtiff" = fetch {
    pname       = "libtiff";
    version     = "4.0.10";
    srcs        = [{ filename = "mingw-w64-i686-libtiff-4.0.10-1-any.pkg.tar.xz"; sha256 = "3600dcc53d7a53e5f8f6444027c74770cc3d018afef433cd61fb33879dbdb651"; }];
    buildInputs = [ gcc-libs libjpeg-turbo xz zlib zstd ];
  };

  "libtimidity" = fetch {
    pname       = "libtimidity";
    version     = "0.2.6";
    srcs        = [{ filename = "mingw-w64-i686-libtimidity-0.2.6-1-any.pkg.tar.xz"; sha256 = "ce6de1d406715e26310ce342a60b946158dd73e6377e84ac30110111050402f0"; }];
    buildInputs = [ gcc-libs ];
  };

  "libtommath" = fetch {
    pname       = "libtommath";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-libtommath-1.0.1-1-any.pkg.tar.xz"; sha256 = "5b12b13ab95fceb977d2b319c911c7fa3fcb2224126fa6ea0f3584e7981d5200"; }];
  };

  "libtool" = fetch {
    pname       = "libtool";
    version     = "2.4.6";
    srcs        = [{ filename = "mingw-w64-i686-libtool-2.4.6-13-any.pkg.tar.xz"; sha256 = "3cd1f869d26aff2b4aa9114995070a624a4323ebcfb55e50cedf079cfc2c344f"; }];
    buildInputs = [  ];
  };

  "libtorrent-rasterbar" = fetch {
    pname       = "libtorrent-rasterbar";
    version     = "1.1.11";
    srcs        = [{ filename = "mingw-w64-i686-libtorrent-rasterbar-1.1.11-2-any.pkg.tar.xz"; sha256 = "3959a4c1257254d81ffd02e546084d44a8ad3ce55bcc8dc5ac80b62888bc0f61"; }];
    buildInputs = [ boost openssl ];
  };

  "libtre-git" = fetch {
    pname       = "libtre-git";
    version     = "r128.6fb7206";
    srcs        = [{ filename = "mingw-w64-i686-libtre-git-r128.6fb7206-2-any.pkg.tar.xz"; sha256 = "cc8ec470688c20d7b6da4ccc5dbaa275edb20242a058041b3b62a1b795ab8048"; }];
    buildInputs = [ gcc-libs gettext ];
  };

  "libunistring" = fetch {
    pname       = "libunistring";
    version     = "0.9.10";
    srcs        = [{ filename = "mingw-w64-i686-libunistring-0.9.10-1-any.pkg.tar.xz"; sha256 = "d0fc32b0453932376650b5bf2a0f3fd7c6679096cfc5711ace918c8edca473ec"; }];
    buildInputs = [ libiconv ];
  };

  "libunwind" = fetch {
    pname       = "libunwind";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-libunwind-7.0.1-1-any.pkg.tar.xz"; sha256 = "e93393187e8e3260805588c47408b8ad8ef2dd3dfc446722744ad6ae36330cc3"; }];
    buildInputs = [ gcc ];
  };

  "libusb" = fetch {
    pname       = "libusb";
    version     = "1.0.22";
    srcs        = [{ filename = "mingw-w64-i686-libusb-1.0.22-1-any.pkg.tar.xz"; sha256 = "488e57dd5893de780cde5216fcb25d690f148ffeb034caa622d8fd49608c3ea2"; }];
    buildInputs = [  ];
  };

  "libusb-compat-git" = fetch {
    pname       = "libusb-compat-git";
    version     = "r72.92deb38";
    srcs        = [{ filename = "mingw-w64-i686-libusb-compat-git-r72.92deb38-1-any.pkg.tar.xz"; sha256 = "e096c802b5d4fd79595c4d94f32b13a4d1765e642d48bd11350c8fa2d748441e"; }];
    buildInputs = [ libusb ];
  };

  "libusbmuxd" = fetch {
    pname       = "libusbmuxd";
    version     = "1.0.10";
    srcs        = [{ filename = "mingw-w64-i686-libusbmuxd-1.0.10-3-any.pkg.tar.xz"; sha256 = "42abff0b8bf893763da35009ccdb0075a5c3b78acad362825a6d0aa503baf699"; }];
    buildInputs = [ libplist ];
  };

  "libuv" = fetch {
    pname       = "libuv";
    version     = "1.24.1";
    srcs        = [{ filename = "mingw-w64-i686-libuv-1.24.1-1-any.pkg.tar.xz"; sha256 = "08bae4da0de03ba9d9711a0e83e9bff73b883bafc6f1c7618355aefb7c85433d"; }];
    buildInputs = [ gcc-libs ];
  };

  "libview" = fetch {
    pname       = "libview";
    version     = "0.6.6";
    srcs        = [{ filename = "mingw-w64-i686-libview-0.6.6-4-any.pkg.tar.xz"; sha256 = "0de7b3f1b77bf2ef42ef6790fa59299ef0753f1582f08896a54afbd72e2792ce"; }];
    buildInputs = [ gtk2 gtkmm ];
  };

  "libvirt" = fetch {
    pname       = "libvirt";
    version     = "4.7.0";
    srcs        = [{ filename = "mingw-w64-i686-libvirt-4.7.0-1-any.pkg.tar.xz"; sha256 = "705add15bcd541545e0d5e2c6f53fb5e09d5eaab0d691aa35dbceb9ea7ba3d4a"; }];
    buildInputs = [ curl gnutls gettext libgcrypt libgpg-error libxml2 portablexdr python2 ];
  };

  "libvirt-glib" = fetch {
    pname       = "libvirt-glib";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-libvirt-glib-2.0.0-1-any.pkg.tar.xz"; sha256 = "36f879d9c449b41d3b92ffa9d3ddb12167a6abdcac53d28d80bcccd812f66ba4"; }];
    buildInputs = [ glib2 libxml2 libvirt ];
  };

  "libvisio" = fetch {
    pname       = "libvisio";
    version     = "0.1.6";
    srcs        = [{ filename = "mingw-w64-i686-libvisio-0.1.6-3-any.pkg.tar.xz"; sha256 = "13775ffeeabba5abcc299f11dbf1c508df40cae556eab385ec9f82036752b80e"; }];
    buildInputs = [ icu libxml2 librevenge ];
  };

  "libvmime-git" = fetch {
    pname       = "libvmime-git";
    version     = "r1129.a9b8221";
    srcs        = [{ filename = "mingw-w64-i686-libvmime-git-r1129.a9b8221-1-any.pkg.tar.xz"; sha256 = "64421b2a8ca4a99edd48c40f33eddb28fdb075325946a529cc78788e1e00cd55"; }];
    buildInputs = [ icu gnutls gsasl libiconv ];
  };

  "libvncserver" = fetch {
    pname       = "libvncserver";
    version     = "0.9.11";
    srcs        = [{ filename = "mingw-w64-i686-libvncserver-0.9.11-2-any.pkg.tar.xz"; sha256 = "90bae61a938dd987c80bad079917f59acd29177e348d1b7fbb55a362c7aae662"; }];
    buildInputs = [ libpng libjpeg gnutls libgcrypt openssl gcc-libs ];
  };

  "libvoikko" = fetch {
    pname       = "libvoikko";
    version     = "4.2";
    srcs        = [{ filename = "mingw-w64-i686-libvoikko-4.2-1-any.pkg.tar.xz"; sha256 = "16e5ffcf0ab2f95d04d2ef0c98294ab178a976a877a0cf9c47ab470940dd4e97"; }];
    buildInputs = [ gcc-libs ];
  };

  "libvorbis" = fetch {
    pname       = "libvorbis";
    version     = "1.3.6";
    srcs        = [{ filename = "mingw-w64-i686-libvorbis-1.3.6-1-any.pkg.tar.xz"; sha256 = "9c0812f95cca372128f0754dd4f5f5eb5e4c677622635be9f8c4cb8b2e5eea02"; }];
    buildInputs = [ libogg gcc-libs ];
  };

  "libvorbisidec-svn" = fetch {
    pname       = "libvorbisidec-svn";
    version     = "r19643";
    srcs        = [{ filename = "mingw-w64-i686-libvorbisidec-svn-r19643-1-any.pkg.tar.xz"; sha256 = "b53d7cbe5f94ae2588441156e6fbe9b974df484cb0f63d6653cd46e0b3be600f"; }];
    buildInputs = [ libogg ];
  };

  "libvpx" = fetch {
    pname       = "libvpx";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-i686-libvpx-1.7.0-1-any.pkg.tar.xz"; sha256 = "677b8332833d0dc81a11881eda2ca59ad683198ae03add9a6a21af808f926a50"; }];
    buildInputs = [  ];
  };

  "libwebp" = fetch {
    pname       = "libwebp";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-libwebp-1.0.1-1-any.pkg.tar.xz"; sha256 = "7fa17a5904830d0a45bacf99630196043df53dca75a2d7e6432c86052fb9eabe"; }];
    buildInputs = [ giflib libjpeg-turbo libpng libtiff ];
  };

  "libwebsockets" = fetch {
    pname       = "libwebsockets";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-i686-libwebsockets-3.1.0-1-any.pkg.tar.xz"; sha256 = "4df96fa06369c817532932320ee0993c2e35f37c0edd83d280d106a867fcedfc"; }];
    buildInputs = [ zlib openssl ];
  };

  "libwinpthread-git" = fetch {
    pname       = "libwinpthread-git";
    version     = "7.0.0.5273.3e5acf5d";
    srcs        = [{ filename = "mingw-w64-i686-libwinpthread-git-7.0.0.5273.3e5acf5d-1-any.pkg.tar.xz"; sha256 = "41258dfa01288605865c9a8b9d011d330ae51d25c77d910224939b69b987b64d"; }];
    buildInputs = [  ];
  };

  "libwmf" = fetch {
    pname       = "libwmf";
    version     = "0.2.10";
    srcs        = [{ filename = "mingw-w64-i686-libwmf-0.2.10-1-any.pkg.tar.xz"; sha256 = "6c21125aeee48125aebc65fa99d6770655ce7cf9569f1f90d35776cc605b7cac"; }];
    buildInputs = [ gcc-libs freetype gdk-pixbuf2 libjpeg libpng libxml2 zlib ];
  };

  "libwpd" = fetch {
    pname       = "libwpd";
    version     = "0.10.2";
    srcs        = [{ filename = "mingw-w64-i686-libwpd-0.10.2-1-any.pkg.tar.xz"; sha256 = "8bb009f3428cc0454da448d738a9179459b0c567572faded98c8a24bf783a2fc"; }];
    buildInputs = [ gcc-libs librevenge xz zlib ];
  };

  "libwpg" = fetch {
    pname       = "libwpg";
    version     = "0.3.2";
    srcs        = [{ filename = "mingw-w64-i686-libwpg-0.3.2-1-any.pkg.tar.xz"; sha256 = "ddc3467774f5eac1edb32fd8c99807c409140755adabaa40de762a4d550d1111"; }];
    buildInputs = [ gcc-libs librevenge libwpd ];
  };

  "libxlsxwriter" = fetch {
    pname       = "libxlsxwriter";
    version     = "0.8.4";
    srcs        = [{ filename = "mingw-w64-i686-libxlsxwriter-0.8.4-1-any.pkg.tar.xz"; sha256 = "3fb59e42fbfecb32116bc499c51f9f5be6af26275920eb7ae7dfc25fd3707a05"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "libxml++" = fetch {
    pname       = "libxml++";
    version     = "3.0.1";
    srcs        = [{ filename = "mingw-w64-i686-libxml++-3.0.1-1-any.pkg.tar.xz"; sha256 = "7ef325e5c451ce42815483f725ca7e04b4465d836ce7e6c881fca047c382f2c7"; }];
    buildInputs = [ gcc-libs libxml2 glibmm ];
  };

  "libxml++2.6" = fetch {
    pname       = "libxml++2.6";
    version     = "2.40.1";
    srcs        = [{ filename = "mingw-w64-i686-libxml++2.6-2.40.1-1-any.pkg.tar.xz"; sha256 = "ec3551fe190deb5629b7569906494853e8b30b2cf9da839ce2ad43791ffa8253"; }];
    buildInputs = [ gcc-libs libxml2 glibmm ];
  };

  "libxml2" = fetch {
    pname       = "libxml2";
    version     = "2.9.8";
    srcs        = [{ filename = "mingw-w64-i686-libxml2-2.9.8-1-any.pkg.tar.xz"; sha256 = "21f9a09c6f0a87941e122e2428edc9e56e7d0159b29c27ef78b7b5803c8db525"; }];
    buildInputs = [ gcc-libs gettext xz zlib ];
  };

  "libxslt" = fetch {
    pname       = "libxslt";
    version     = "1.1.33";
    srcs        = [{ filename = "mingw-w64-i686-libxslt-1.1.33-1-any.pkg.tar.xz"; sha256 = "d583cd3b360c71b41c02cb226f15e95e9d5d6e6eacfe68d7861b119646cf287d"; }];
    buildInputs = [ gcc-libs libxml2 libgcrypt ];
  };

  "libyaml" = fetch {
    pname       = "libyaml";
    version     = "0.2.1";
    srcs        = [{ filename = "mingw-w64-i686-libyaml-0.2.1-1-any.pkg.tar.xz"; sha256 = "0865f1fea0ec97501085c4746d95c8b336e59dd0cb0d5f821b5481c2788b166f"; }];
    buildInputs = [  ];
  };

  "libzip" = fetch {
    pname       = "libzip";
    version     = "1.5.1";
    srcs        = [{ filename = "mingw-w64-i686-libzip-1.5.1-1-any.pkg.tar.xz"; sha256 = "a6581f853129182ca3a53bf2ae269763d497d4860b98ca1c03d90141111857d4"; }];
    buildInputs = [ bzip2 gnutls nettle zlib ];
  };

  "live-media" = fetch {
    pname       = "live-media";
    version     = "2018.10.17";
    srcs        = [{ filename = "mingw-w64-i686-live-media-2018.10.17-1-any.pkg.tar.xz"; sha256 = "705a95dd0e617fad93f6f2a525aace8755013b6646a2d449879c6188c635f17a"; }];
    buildInputs = [ gcc ];
  };

  "lld" = fetch {
    pname       = "lld";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-lld-7.0.1-1-any.pkg.tar.xz"; sha256 = "e6c9f26fd645c415d5cc2e8d315a1f734a9a92cd168bcd3ed4c58361a5db1fb6"; }];
    buildInputs = [ gcc ];
  };

  "lldb" = fetch {
    pname       = "lldb";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-lldb-7.0.1-1-any.pkg.tar.xz"; sha256 = "08c73ef65dc5e8fad2e0390cff0573c0b9984da3d4ef2ef6e6a3ae9bded41ee1"; }];
    buildInputs = [ libxml2 llvm python2 readline swig ];
  };

  "llvm" = fetch {
    pname       = "llvm";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-llvm-7.0.1-1-any.pkg.tar.xz"; sha256 = "845f9f16ba63ee92be9157f7af0d8a91603d1a847810cf0332fd566116da1923"; }];
    buildInputs = [ libffi gcc-libs ];
  };

  "lmdb" = fetch {
    pname       = "lmdb";
    version     = "0.9.23";
    srcs        = [{ filename = "mingw-w64-i686-lmdb-0.9.23-1-any.pkg.tar.xz"; sha256 = "9e7e6277ad892bfb04beb4e1ce35b8b772ac775fa6a4a797419fab31580bf148"; }];
  };

  "lmdbxx" = fetch {
    pname       = "lmdbxx";
    version     = "0.9.14.0";
    srcs        = [{ filename = "mingw-w64-i686-lmdbxx-0.9.14.0-1-any.pkg.tar.xz"; sha256 = "0512366ec19fb39cee7c2c10b86329e7f2f8a2af7e7c0f31404a6a228d35f5e0"; }];
    buildInputs = [ lmdb ];
  };

  "lpsolve" = fetch {
    pname       = "lpsolve";
    version     = "5.5.2.5";
    srcs        = [{ filename = "mingw-w64-i686-lpsolve-5.5.2.5-1-any.pkg.tar.xz"; sha256 = "12c6348eb1c5480e7b0f8ffaac0c9dd0c24984198b5fd5a7010e90214c7891a9"; }];
    buildInputs = [ gcc-libs ];
  };

  "lua" = fetch {
    pname       = "lua";
    version     = "5.3.5";
    srcs        = [{ filename = "mingw-w64-i686-lua-5.3.5-1-any.pkg.tar.xz"; sha256 = "82d788d66635151fb64a695daae79b536c99c51a7e37cf96d5bf332dd5d18016"; }];
    buildInputs = [ winpty ];
  };

  "lua-lpeg" = fetch {
    pname       = "lua-lpeg";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-lua-lpeg-1.0.1-1-any.pkg.tar.xz"; sha256 = "d3c456de4434f2d60760ddfc175cf484ce3ee7f73f0321e9e687cec7c6101893"; }];
    buildInputs = [ lua ];
  };

  "lua-mpack" = fetch {
    pname       = "lua-mpack";
    version     = "1.0.7";
    srcs        = [{ filename = "mingw-w64-i686-lua-mpack-1.0.7-1-any.pkg.tar.xz"; sha256 = "9cb2a7e92749e6a6894eb470cf89cc98998aaabbfdc1bed856656ac9779eebc2"; }];
    buildInputs = [ lua libmpack ];
  };

  "lua51" = fetch {
    pname       = "lua51";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-i686-lua51-5.1.5-4-any.pkg.tar.xz"; sha256 = "40ff1207db193d5d987c40ea95a354296c9fd30bc03690b0419dbf1f52533fde"; }];
    buildInputs = [ winpty ];
  };

  "lua51-bitop" = fetch {
    pname       = "lua51-bitop";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-i686-lua51-bitop-1.0.2-1-any.pkg.tar.xz"; sha256 = "fc4ce61a5cf603e2a2934b754934d701d4182d3aa3b8a627c86a11c34e6fe239"; }];
    buildInputs = [ lua51 ];
  };

  "lua51-lgi" = fetch {
    pname       = "lua51-lgi";
    version     = "0.9.2";
    srcs        = [{ filename = "mingw-w64-i686-lua51-lgi-0.9.2-1-any.pkg.tar.xz"; sha256 = "9b2f481dda6aa3b44f07313bf9b040620d7f0893254ada1d6976a26496f3cee8"; }];
    buildInputs = [ lua51 gtk3 gobject-introspection ];
  };

  "lua51-lpeg" = fetch {
    pname       = "lua51-lpeg";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-lua51-lpeg-1.0.1-1-any.pkg.tar.xz"; sha256 = "aa1f7757d09a2bb72c47bf318feb855a0be20f0b3bd7ae4fe90342e80dfa277a"; }];
    buildInputs = [ lua51 ];
  };

  "lua51-lsqlite3" = fetch {
    pname       = "lua51-lsqlite3";
    version     = "0.9.3";
    srcs        = [{ filename = "mingw-w64-i686-lua51-lsqlite3-0.9.3-1-any.pkg.tar.xz"; sha256 = "e73afc881b036ef2dbe305c5071c5a9b3766af6bcc615287bfe40a287cc7f725"; }];
    buildInputs = [ lua51 sqlite3 ];
  };

  "lua51-luarocks" = fetch {
    pname       = "lua51-luarocks";
    version     = "2.4.4";
    srcs        = [{ filename = "mingw-w64-i686-lua51-luarocks-2.4.4-1-any.pkg.tar.xz"; sha256 = "a3bf61ddc9b053efd5b8f25883784ee17e33f48f91a6dc0c750cf96034ff4ab2"; }];
    buildInputs = [ lua51 ];
  };

  "lua51-mpack" = fetch {
    pname       = "lua51-mpack";
    version     = "1.0.7";
    srcs        = [{ filename = "mingw-w64-i686-lua51-mpack-1.0.7-1-any.pkg.tar.xz"; sha256 = "3f93ed09ecad97c229c48ae849c9a5df44f1e5f6b70799c405af067f7f5fb11a"; }];
    buildInputs = [ lua51 libmpack ];
  };

  "lua51-winapi" = fetch {
    pname       = "lua51-winapi";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-i686-lua51-winapi-1.4.2-1-any.pkg.tar.xz"; sha256 = "9dfd4e98949ad4bd834b7d0891ef12f0e5292bcf0e28b1998c9f0dade046d772"; }];
    buildInputs = [ lua51 ];
  };

  "luabind-git" = fetch {
    pname       = "luabind-git";
    version     = "0.9.1.144.ge414c57";
    srcs        = [{ filename = "mingw-w64-i686-luabind-git-0.9.1.144.ge414c57-1-any.pkg.tar.xz"; sha256 = "f7462af4008040fc686d5b8e4a1f81ac0fd15e5608b02bf157eb23ac02d7883b"; }];
    buildInputs = [ boost lua51 ];
  };

  "luajit-git" = fetch {
    pname       = "luajit-git";
    version     = "2.0.4.49.ga68c411";
    srcs        = [{ filename = "mingw-w64-i686-luajit-git-2.0.4.49.ga68c411-1-any.pkg.tar.xz"; sha256 = "b7dc7925bf60e5446530ab4133e7957101e8de4ce2ccd845cdd20a1c22d73fbf"; }];
    buildInputs = [ winpty ];
  };

  "lz4" = fetch {
    pname       = "lz4";
    version     = "1.8.3";
    srcs        = [{ filename = "mingw-w64-i686-lz4-1.8.3-1-any.pkg.tar.xz"; sha256 = "0b563a8a6b47f1ea8f515da863bd6c80773f44c0b6cc3eb999d7739da50e3e6d"; }];
    buildInputs = [ gcc-libs ];
  };

  "lzo2" = fetch {
    pname       = "lzo2";
    version     = "2.10";
    srcs        = [{ filename = "mingw-w64-i686-lzo2-2.10-1-any.pkg.tar.xz"; sha256 = "767a867762fd70c47d60fe8b97bdc17b65b77b05efd7ef66747f496b04694498"; }];
    buildInputs = [  ];
  };

  "make" = fetch {
    pname       = "make";
    version     = "4.2.1";
    srcs        = [{ filename = "mingw-w64-i686-make-4.2.1-2-any.pkg.tar.xz"; sha256 = "5e789eadba35c2031e3d3abc9ab29f3fbd1ba0851dbade0350d984fa5fd3d7d2"; }];
    buildInputs = [ gettext ];
  };

  "mathgl" = fetch {
    pname       = "mathgl";
    version     = "2.4.2";
    srcs        = [{ filename = "mingw-w64-i686-mathgl-2.4.2-1-any.pkg.tar.xz"; sha256 = "5b19700f6aa934d08f975ada42e920b961f75aaa971ad613ba78dcea31d634e2"; }];
    buildInputs = [ hdf5 fltk libharu libjpeg-turbo libpng giflib qt5 freeglut wxWidgets ];
  };

  "matio" = fetch {
    pname       = "matio";
    version     = "1.5.13";
    srcs        = [{ filename = "mingw-w64-i686-matio-1.5.13-1-any.pkg.tar.xz"; sha256 = "af0d70927cb34af8db3b6ef1abd6ab7fa08ad7ab24e910043567c17fd1c87ab3"; }];
    buildInputs = [ gcc-libs zlib hdf5 ];
  };

  "mbedtls" = fetch {
    pname       = "mbedtls";
    version     = "2.16.0";
    srcs        = [{ filename = "mingw-w64-i686-mbedtls-2.16.0-1-any.pkg.tar.xz"; sha256 = "c8f90c57f426773965e8334d6fd71cce11ea7192cd9eee247d636f74b4cc9377"; }];
    buildInputs = [ gcc-libs ];
  };

  "mcpp" = fetch {
    pname       = "mcpp";
    version     = "2.7.2";
    srcs        = [{ filename = "mingw-w64-i686-mcpp-2.7.2-2-any.pkg.tar.xz"; sha256 = "9392590dcd5db6dc6831aca47735d0acacb901f6a65c9a7f4fe5dfee2131b3b3"; }];
    buildInputs = [ gcc-libs libiconv ];
  };

  "meanwhile" = fetch {
    pname       = "meanwhile";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-i686-meanwhile-1.0.2-4-any.pkg.tar.xz"; sha256 = "49dda3e64b2f584ae60a4a1b29e4214704e8791243bf2223aae1497377d78eb9"; }];
    buildInputs = [ glib2 ];
  };

  "meld3" = fetch {
    pname       = "meld3";
    version     = "3.20.0";
    srcs        = [{ filename = "mingw-w64-i686-meld3-3.20.0-1-any.pkg.tar.xz"; sha256 = "5a3b946994ace5780a79d257a2ef36823b14f3970f0667e4f74e6e5d8a124f89"; }];
    buildInputs = [ gtk3 gtksourceview3 adwaita-icon-theme gsettings-desktop-schemas python3-gobject ];
  };

  "memphis" = fetch {
    pname       = "memphis";
    version     = "0.2.3";
    srcs        = [{ filename = "mingw-w64-i686-memphis-0.2.3-4-any.pkg.tar.xz"; sha256 = "5ad740e1d854774989d79a9333c3d3b85e0ceed1b643d40c815690e18dd56339"; }];
    buildInputs = [ glib2 cairo expat ];
  };

  "mesa" = fetch {
    pname       = "mesa";
    version     = "18.3.1";
    srcs        = [{ filename = "mingw-w64-i686-mesa-18.3.1-1-any.pkg.tar.xz"; sha256 = "95e602b12bf0da1c95b179cc8cfcd8b2df0317845cc3a11a56362fb551ef3e67"; }];
  };

  "meson" = fetch {
    pname       = "meson";
    version     = "0.49.0";
    srcs        = [{ filename = "mingw-w64-i686-meson-0.49.0-1-any.pkg.tar.xz"; sha256 = "4311cbc5cf119afda9d95e324a383e5740b4a5da24beda14719493ea13e77beb"; }];
    buildInputs = [ python3 python3-setuptools ninja ];
  };

  "metis" = fetch {
    pname       = "metis";
    version     = "5.1.0";
    srcs        = [{ filename = "mingw-w64-i686-metis-5.1.0-2-any.pkg.tar.xz"; sha256 = "82bb8af55a1118340e1958cdd6d2ae31f9a427ea499b6150d1459688017a0e51"; }];
    buildInputs = [  ];
  };

  "mhook" = fetch {
    pname       = "mhook";
    version     = "r7.a159eed";
    srcs        = [{ filename = "mingw-w64-i686-mhook-r7.a159eed-1-any.pkg.tar.xz"; sha256 = "860147a8a8e216ff3fee1f9afe6f285334164e8db8770bb2c95235042fdc79e9"; }];
    buildInputs = [ gcc-libs ];
  };

  "minisign" = fetch {
    pname       = "minisign";
    version     = "0.8";
    srcs        = [{ filename = "mingw-w64-i686-minisign-0.8-1-any.pkg.tar.xz"; sha256 = "9f4b6a801eb1a96e131831aff8d4cf8f4c979aa5da08ab4f30bf099680dc2d02"; }];
    buildInputs = [ libsodium ];
  };

  "miniupnpc" = fetch {
    pname       = "miniupnpc";
    version     = "2.1";
    srcs        = [{ filename = "mingw-w64-i686-miniupnpc-2.1-2-any.pkg.tar.xz"; sha256 = "d26b7addce20fd364d20c16c9a2f5fd707ba8fd0a4692b944e0c9f69a5abffbe"; }];
    buildInputs = [ gcc-libs ];
  };

  "minizip2" = fetch {
    pname       = "minizip2";
    version     = "2.7.0";
    srcs        = [{ filename = "mingw-w64-i686-minizip2-2.7.0-1-any.pkg.tar.xz"; sha256 = "0fa32c42b7672dd1f58f43215382854e5fc813d0175ad3135dd42066bbe09144"; }];
    buildInputs = [ bzip2 gcc-libs zlib ];
  };

  "mlpack" = fetch {
    pname       = "mlpack";
    version     = "1.0.12";
    srcs        = [{ filename = "mingw-w64-i686-mlpack-1.0.12-2-any.pkg.tar.xz"; sha256 = "782615ac87eb0280b5d6bf4b0aed79d69112e68d86e027897f40b5ec7763aa59"; }];
    buildInputs = [ gcc-libs armadillo boost libxml2 ];
  };

  "mono" = fetch {
    pname       = "mono";
    version     = "5.4.1.7";
    srcs        = [{ filename = "mingw-w64-i686-mono-5.4.1.7-2-any.pkg.tar.xz"; sha256 = "9768b94c6fee4a0e77935e28ac6a42e61082e78dc97a04b8e77c724fa5d35567"; }];
    buildInputs = [ zlib gcc-libs winpthreads-git libgdiplus python3 ca-certificates ];
  };

  "mono-basic" = fetch {
    pname       = "mono-basic";
    version     = "4.6";
    srcs        = [{ filename = "mingw-w64-i686-mono-basic-4.6-1-any.pkg.tar.xz"; sha256 = "45b30e2fb33ca4d3ef07146943fa185df457dd7121189ce628fe4cc1c37c10d8"; }];
    buildInputs = [ mono ];
  };

  "mpc" = fetch {
    pname       = "mpc";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-mpc-1.1.0-1-any.pkg.tar.xz"; sha256 = "599a0276820e3d342d1c494c4506aaf79fbbbc2843bbec7aae5f22a1b71da284"; }];
    buildInputs = [ mpfr ];
  };

  "mpdecimal" = fetch {
    pname       = "mpdecimal";
    version     = "2.4.2";
    srcs        = [{ filename = "mingw-w64-i686-mpdecimal-2.4.2-1-any.pkg.tar.xz"; sha256 = "5c1c64552a680b6e222751a732b724e62de5ee7b511190e81b2dd252c64807df"; }];
    buildInputs = [ gcc-libs ];
  };

  "mpfr" = fetch {
    pname       = "mpfr";
    version     = "4.0.1";
    srcs        = [{ filename = "mingw-w64-i686-mpfr-4.0.1-2-any.pkg.tar.xz"; sha256 = "c5ac46f3df381a38e60909fedbb86f6d79d20675f50b4e11f73e872bde197f75"; }];
    buildInputs = [ gmp ];
  };

  "mpg123" = fetch {
    pname       = "mpg123";
    version     = "1.25.10";
    srcs        = [{ filename = "mingw-w64-i686-mpg123-1.25.10-1-any.pkg.tar.xz"; sha256 = "e2f32f85f9196151955c1317359988fdf54735b1874fa4e64e556c8906fb8e90"; }];
    buildInputs = [ libtool gcc-libs ];
  };

  "mpv" = fetch {
    pname       = "mpv";
    version     = "0.29.1";
    srcs        = [{ filename = "mingw-w64-i686-mpv-0.29.1-1-any.pkg.tar.xz"; sha256 = "840c8a555830a1710e44905ecadf5f3dfdf1bd19c3f0921703599a51e55e2cea"; }];
    buildInputs = [ angleproject-git ffmpeg lcms2 libarchive libass libbluray libcaca libcdio libcdio-paranoia libdvdnav libdvdread libjpeg-turbo lua51 rubberband uchardet vapoursynth vulkan winpty ];
  };

  "mruby" = fetch {
    pname       = "mruby";
    version     = "1.4.1";
    srcs        = [{ filename = "mingw-w64-i686-mruby-1.4.1-1-any.pkg.tar.xz"; sha256 = "e1fa683984d026df14b2f7e7b64d91ad4a3f0cef03f11468b371bca92e319f4c"; }];
  };

  "mscgen" = fetch {
    pname       = "mscgen";
    version     = "0.20";
    srcs        = [{ filename = "mingw-w64-i686-mscgen-0.20-1-any.pkg.tar.xz"; sha256 = "b87275ec63764e103fe61d808f7a71338b51bdda4c77039cee2c6739ee9f3ed0"; }];
    buildInputs = [ libgd ];
  };

  "msgpack-c" = fetch {
    pname       = "msgpack-c";
    version     = "3.1.1";
    srcs        = [{ filename = "mingw-w64-i686-msgpack-c-3.1.1-1-any.pkg.tar.xz"; sha256 = "9ede9e3da0d5fc54d707a6857a3cd18cbe530f2b5ac4fd7ee8a3802fb02dfb42"; }];
  };

  "msmtp" = fetch {
    pname       = "msmtp";
    version     = "1.8.1";
    srcs        = [{ filename = "mingw-w64-i686-msmtp-1.8.1-1-any.pkg.tar.xz"; sha256 = "f926056a229ae629c6f0e541edaf66f36a8c11d1a2f7667d6dd7aa7556b7234d"; }];
    buildInputs = [ gettext gnutls gsasl libffi libidn libwinpthread-git ];
  };

  "mtex2MML" = fetch {
    pname       = "mtex2MML";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-i686-mtex2MML-1.3.1-1-any.pkg.tar.xz"; sha256 = "ece38a8de2a2f3482c52394933281ac8cfb23cc7f66f73c7a7ef9ed8943cc707"; }];
  };

  "muparser" = fetch {
    pname       = "muparser";
    version     = "2.2.6";
    srcs        = [{ filename = "mingw-w64-i686-muparser-2.2.6-1-any.pkg.tar.xz"; sha256 = "45330bf898f0f59980e8e885cc0ab34be8bdc0e7fb112452a9742045d8d6c06f"; }];
  };

  "mypaint" = fetch {
    pname       = "mypaint";
    version     = "1.2.1";
    srcs        = [{ filename = "mingw-w64-i686-mypaint-1.2.1-1-any.pkg.tar.xz"; sha256 = "ab01d7d9a4990a73c56e9e83676e02c680ba70ea4837c0608448b8d4de988f7e"; }];
    buildInputs = [ gtk3 python2-numpy json-c lcms2 python2-cairo python2-gobject adwaita-icon-theme librsvg gcc-libs gsettings-desktop-schemas hicolor-icon-theme ];
  };

  "mypaint-brushes" = fetch {
    pname       = "mypaint-brushes";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-mypaint-brushes-1.3.0-1-any.pkg.tar.xz"; sha256 = "f2aef651fb442e768ac1cdb664ce5a1f95bbe2b1dc8b5e89fa432199c467e919"; }];
    buildInputs = [ libmypaint ];
  };

  "mypaint-brushes2" = fetch {
    pname       = "mypaint-brushes2";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-mypaint-brushes2-2.0.0-1-any.pkg.tar.xz"; sha256 = "29748bfaed1e2f858872bfb86722b4ab4e9f65b2e25ed2353429fb35c62a94db"; }];
  };

  "nanodbc" = fetch {
    pname       = "nanodbc";
    version     = "2.12.4";
    srcs        = [{ filename = "mingw-w64-i686-nanodbc-2.12.4-2-any.pkg.tar.xz"; sha256 = "5046e4b99438d4fea34b7f2aeb7d57083ec83bd55e8a9575198eec9e1da0bea3"; }];
  };

  "nanovg-git" = fetch {
    pname       = "nanovg-git";
    version     = "r259.6ae0873";
    srcs        = [{ filename = "mingw-w64-i686-nanovg-git-r259.6ae0873-1-any.pkg.tar.xz"; sha256 = "3e3a9c1bb742531cb17f36a0ae76d0eb657af0eef2b4811894c632c92f83ea7f"; }];
  };

  "nasm" = fetch {
    pname       = "nasm";
    version     = "2.14.01";
    srcs        = [{ filename = "mingw-w64-i686-nasm-2.14.01-1-any.pkg.tar.xz"; sha256 = "728c48863e80f20d74c70747d69c970ec651bfc8a6b1d6bfafd953b43c0c2e53"; }];
  };

  "ncurses" = fetch {
    pname       = "ncurses";
    version     = "6.1.20180908";
    srcs        = [{ filename = "mingw-w64-i686-ncurses-6.1.20180908-1-any.pkg.tar.xz"; sha256 = "9ad38936f2f2ddae01625cd7b2cc7ae1a5188c7db2c3bbe9600af17404113c22"; }];
    buildInputs = [ libsystre ];
  };

  "netcdf" = fetch {
    pname       = "netcdf";
    version     = "4.6.2";
    srcs        = [{ filename = "mingw-w64-i686-netcdf-4.6.2-1-any.pkg.tar.xz"; sha256 = "8b8bce84de9584a5155b3288fcb36c17ffbd27b4f62267395b409a3e8acd940a"; }];
    buildInputs = [ hdf5 ];
  };

  "nettle" = fetch {
    pname       = "nettle";
    version     = "3.4.1";
    srcs        = [{ filename = "mingw-w64-i686-nettle-3.4.1-1-any.pkg.tar.xz"; sha256 = "85a67ddee4a0e7a76c36c198993b062efe79f458f908b463ea8697195590f136"; }];
    buildInputs = [ gcc-libs gmp ];
  };

  "nghttp2" = fetch {
    pname       = "nghttp2";
    version     = "1.35.1";
    srcs        = [{ filename = "mingw-w64-i686-nghttp2-1.35.1-1-any.pkg.tar.xz"; sha256 = "c82f9d541c2b8b9fad45e41abc504c34305fd546430231a39578d2171a823ce1"; }];
    buildInputs = [ jansson jemalloc openssl c-ares ];
  };

  "ngraph-gtk" = fetch {
    pname       = "ngraph-gtk";
    version     = "6.08.00";
    srcs        = [{ filename = "mingw-w64-i686-ngraph-gtk-6.08.00-1-any.pkg.tar.xz"; sha256 = "8e85b570e81b167d45c34b49a4434f4dea4ad32b190d223f924c5500887395fa"; }];
    buildInputs = [ adwaita-icon-theme gsettings-desktop-schemas gtk3 gtksourceview3 readline gsl ruby ];
  };

  "ngspice" = fetch {
    pname       = "ngspice";
    version     = "29";
    srcs        = [{ filename = "mingw-w64-i686-ngspice-29-1-any.pkg.tar.xz"; sha256 = "085af3df9174f795bc0ea743df18af9e4eea6a3a80c2db7f646e313a37e8d81f"; }];
    buildInputs = [ gcc-libs ];
  };

  "nim" = fetch {
    pname       = "nim";
    version     = "0.19.0";
    srcs        = [{ filename = "mingw-w64-i686-nim-0.19.0-3-any.pkg.tar.xz"; sha256 = "c57449a4a53928f81e664a2a19b16ce43ba5972d03c9a354d658dc388173ba63"; }];
  };

  "nimble" = fetch {
    pname       = "nimble";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-i686-nimble-0.9.0-1-any.pkg.tar.xz"; sha256 = "ee31aa9cdc47d825a50de8c48cb5e70d2cc383e3493754cfd64aa09f58b24f82"; }];
  };

  "ninja" = fetch {
    pname       = "ninja";
    version     = "1.8.2";
    srcs        = [{ filename = "mingw-w64-i686-ninja-1.8.2-3-any.pkg.tar.xz"; sha256 = "e37efb22863fd13900cdf03cf85fc8cc95c86c60294338f7557b9241aba68158"; }];
    buildInputs = [  ];
  };

  "nlopt" = fetch {
    pname       = "nlopt";
    version     = "2.5.0";
    srcs        = [{ filename = "mingw-w64-i686-nlopt-2.5.0-1-any.pkg.tar.xz"; sha256 = "0f776a7c5e082df96eb7be21c11b58bd188131dc9e7903da21a9f0a9d487e1da"; }];
  };

  "nodejs" = fetch {
    pname       = "nodejs";
    version     = "8.11.1";
    srcs        = [{ filename = "mingw-w64-i686-nodejs-8.11.1-5-any.pkg.tar.xz"; sha256 = "b96a59d8c0bd648868383e4e0967ebea2836bd29c245785f1c573638e70d2244"; }];
    buildInputs = [ c-ares http-parser icu libuv openssl zlib winpty ];
  };

  "npth" = fetch {
    pname       = "npth";
    version     = "1.6";
    srcs        = [{ filename = "mingw-w64-i686-npth-1.6-1-any.pkg.tar.xz"; sha256 = "123a2ac722ad936e066220bd12e165960feb3ab0a267e62aab88687b6a7c6f0c"; }];
    buildInputs = [ gcc-libs ];
  };

  "nsis" = fetch {
    pname       = "nsis";
    version     = "3.04";
    srcs        = [{ filename = "mingw-w64-i686-nsis-3.04-1-any.pkg.tar.xz"; sha256 = "e4605157a694d9f631186f4ba24cc4b66814f74c22c9082419da2d690527f39d"; }];
    buildInputs = [ zlib gcc-libs libwinpthread-git ];
  };

  "nsis-nsisunz" = fetch {
    pname       = "nsis-nsisunz";
    version     = "1.0";
    srcs        = [{ filename = "mingw-w64-i686-nsis-nsisunz-1.0-1-any.pkg.tar.xz"; sha256 = "6ab117e6379a41d56301912f9da96a64a6e735b26913f179e41c510eff6e56d2"; }];
    buildInputs = [ nsis ];
  };

  "nspr" = fetch {
    pname       = "nspr";
    version     = "4.20";
    srcs        = [{ filename = "mingw-w64-i686-nspr-4.20-1-any.pkg.tar.xz"; sha256 = "d1ed2cb8daa811f58f0aff8d771b5a349be151325b6edce92fc60710fc9eabc2"; }];
    buildInputs = [ gcc-libs ];
  };

  "nss" = fetch {
    pname       = "nss";
    version     = "3.41";
    srcs        = [{ filename = "mingw-w64-i686-nss-3.41-1-any.pkg.tar.xz"; sha256 = "d08026059f031decdb7b92baeedcc381f1fd5b105cbf3baa83a72fe24577fc70"; }];
    buildInputs = [ nspr sqlite3 zlib ];
  };

  "ntldd-git" = fetch {
    pname       = "ntldd-git";
    version     = "r15.e7622f6";
    srcs        = [{ filename = "mingw-w64-i686-ntldd-git-r15.e7622f6-2-any.pkg.tar.xz"; sha256 = "361d19deeaaa9be4f8a32bd40bebed4e4965c6f0ec7c2f4529c5930e986a1c22"; }];
  };

  "ocaml" = fetch {
    pname       = "ocaml";
    version     = "4.04.0";
    srcs        = [{ filename = "mingw-w64-i686-ocaml-4.04.0-1-any.pkg.tar.xz"; sha256 = "4d48f73ec4f6b9278f50095acea9be53b736d287da50f11bcc4987dae8974af2"; }];
    buildInputs = [ flexdll ];
  };

  "ocaml-findlib" = fetch {
    pname       = "ocaml-findlib";
    version     = "1.7.1";
    srcs        = [{ filename = "mingw-w64-i686-ocaml-findlib-1.7.1-1-any.pkg.tar.xz"; sha256 = "23775672cfa7734d0b3897f60e824fade43e74c23d563e12966954a730e0a2ca"; }];
    buildInputs = [ ocaml msys2-runtime ];
    broken      = true; # broken dependency ocaml-findlib -> msys2-runtime
  };

  "oce" = fetch {
    pname       = "oce";
    version     = "0.18.3";
    srcs        = [{ filename = "mingw-w64-i686-oce-0.18.3-1-any.pkg.tar.xz"; sha256 = "cbca8a65a6286be6e3179d304a99e40865b02f3c52358a7758dfb1a366446a77"; }];
    buildInputs = [ freetype ];
  };

  "octopi-git" = fetch {
    pname       = "octopi-git";
    version     = "r941.6df0f8a";
    srcs        = [{ filename = "mingw-w64-i686-octopi-git-r941.6df0f8a-1-any.pkg.tar.xz"; sha256 = "9258b5333beb815ae5b95a7771ad1ca2aabc07cfe0d485dd89d825c69abb9291"; }];
    buildInputs = [ gcc-libs ];
  };

  "odt2txt" = fetch {
    pname       = "odt2txt";
    version     = "0.5";
    srcs        = [{ filename = "mingw-w64-i686-odt2txt-0.5-2-any.pkg.tar.xz"; sha256 = "133a5ad172cef84fc5c796301ec4d6ebdfd9848bd96f5ad3c0610653bac141b5"; }];
    buildInputs = [ libiconv libzip pcre ];
  };

  "ogitor-git" = fetch {
    pname       = "ogitor-git";
    version     = "r816.cf42232";
    srcs        = [{ filename = "mingw-w64-i686-ogitor-git-r816.cf42232-1-any.pkg.tar.xz"; sha256 = "c67e032729a028625f8ef484303f1c94e7408e77fdfc28bc1928624c0ed27d53"; }];
    buildInputs = [ libwinpthread-git ogre3d boost qt5 ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "ogre3d" = fetch {
    pname       = "ogre3d";
    version     = "1.11.1";
    srcs        = [{ filename = "mingw-w64-i686-ogre3d-1.11.1-1-any.pkg.tar.xz"; sha256 = "9ed74b8fa3b7f3170d7d22e150c39cf3b40f1976be5b997ec552efccf49ad360"; }];
    buildInputs = [ boost cppunit FreeImage freetype glsl-optimizer-git hlsl2glsl-git intel-tbb openexr SDL2 python2 tinyxml winpthreads-git zlib zziplib ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "ois-git" = fetch {
    pname       = "ois-git";
    version     = "1.4.0.124.564dd81";
    srcs        = [{ filename = "mingw-w64-i686-ois-git-1.4.0.124.564dd81-1-any.pkg.tar.xz"; sha256 = "63c0864d9d962af22f2acc5e7cb23ff6d048545dbe01d7bf7ea7e539f1390604"; }];
    buildInputs = [ gcc-libs ];
  };

  "oniguruma" = fetch {
    pname       = "oniguruma";
    version     = "6.9.1";
    srcs        = [{ filename = "mingw-w64-i686-oniguruma-6.9.1-1-any.pkg.tar.xz"; sha256 = "8c488fa1ea7e37ca16e0c0b2230cce13cafa121ccfe2f900dfe59b8b96c77c03"; }];
    buildInputs = [  ];
  };

  "openal" = fetch {
    pname       = "openal";
    version     = "1.19.1";
    srcs        = [{ filename = "mingw-w64-i686-openal-1.19.1-1-any.pkg.tar.xz"; sha256 = "4a7e8c335fc397bac5987c0b302ab6533dc9bdedf703910e4186791193c579ea"; }];
    buildInputs = [  ];
  };

  "openblas" = fetch {
    pname       = "openblas";
    version     = "0.3.5";
    srcs        = [{ filename = "mingw-w64-i686-openblas-0.3.5-1-any.pkg.tar.xz"; sha256 = "ea5fbeb5b718b64098e8e8ef54bd8ac689d4de8855bc9797921419ca24d5e6a3"; }];
    buildInputs = [ gcc-libs gcc-libgfortran libwinpthread-git ];
  };

  "opencl-headers" = fetch {
    pname       = "opencl-headers";
    version     = "2~2.2.20170516";
    srcs        = [{ filename = "mingw-w64-i686-opencl-headers-2~2.2.20170516-1-any.pkg.tar.xz"; sha256 = "644bdf83d38ef7409bef1f3cd136d9d4d7a71bcef5c846d5e48b4ebc21e6df95"; }];
  };

  "opencollada-git" = fetch {
    pname       = "opencollada-git";
    version     = "r1687.d826fd08";
    srcs        = [{ filename = "mingw-w64-i686-opencollada-git-r1687.d826fd08-1-any.pkg.tar.xz"; sha256 = "846172dcb86559cd4cc450fbd8d38c80786b8f3af642cc871ed46ac299111b86"; }];
    buildInputs = [ libxml2 pcre ];
  };

  "opencolorio-git" = fetch {
    pname       = "opencolorio-git";
    version     = "815.15e96c1f";
    srcs        = [{ filename = "mingw-w64-i686-opencolorio-git-815.15e96c1f-1-any.pkg.tar.xz"; sha256 = "70f3cec3102a1a1ab3df14c6192a7e04b8050f5f36b3e5928a56d78cd3f8a917"; }];
    buildInputs = [ boost glew lcms2 python3 tinyxml yaml-cpp ];
  };

  "opencore-amr" = fetch {
    pname       = "opencore-amr";
    version     = "0.1.5";
    srcs        = [{ filename = "mingw-w64-i686-opencore-amr-0.1.5-1-any.pkg.tar.xz"; sha256 = "33ac0d1b31850ce14795b1ef091d61487fe2980085790414cd443478c1cbf045"; }];
    buildInputs = [  ];
  };

  "opencsg" = fetch {
    pname       = "opencsg";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-i686-opencsg-1.4.2-1-any.pkg.tar.xz"; sha256 = "79397bf6d1315882c425d229e385159f332e88c14f7306a8a7f4dbbe81c22416"; }];
    buildInputs = [ glew ];
  };

  "opencv" = fetch {
    pname       = "opencv";
    version     = "4.0.1";
    srcs        = [{ filename = "mingw-w64-i686-opencv-4.0.1-1-any.pkg.tar.xz"; sha256 = "cb1c2febd5994903d4ea01c4a9fdccc25d2cbbf788b4cbb994bb9b474e868237"; }];
    buildInputs = [ intel-tbb jasper libjpeg libpng libtiff libwebp openblas openexr protobuf zlib ];
  };

  "openexr" = fetch {
    pname       = "openexr";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-openexr-2.3.0-1-any.pkg.tar.xz"; sha256 = "b34997428399cb5abd3af5bf4dcf97175e05cd98365086c1f6d12e7c8399c225"; }];
    buildInputs = [ (assert ilmbase.version=="2.3.0"; ilmbase) zlib ];
  };

  "openh264" = fetch {
    pname       = "openh264";
    version     = "1.8.0";
    srcs        = [{ filename = "mingw-w64-i686-openh264-1.8.0-1-any.pkg.tar.xz"; sha256 = "b0cab1628d4b93c7d3466c41eb074852b593d0dc1e347b94d75d0a733600bf32"; }];
  };

  "openimageio" = fetch {
    pname       = "openimageio";
    version     = "1.8.17";
    srcs        = [{ filename = "mingw-w64-i686-openimageio-1.8.17-1-any.pkg.tar.xz"; sha256 = "0f5a110551d08b1dbe5b386c6538fa51daaf1481d51782b3b93a8c239c471ad8"; }];
    buildInputs = [ boost field3d freetype jasper giflib glew hdf5 libjpeg libpng LibRaw libwebp libtiff opencolorio-git opencv openexr openjpeg openssl ptex pugixml zlib ];
    broken      = true; # broken dependency openimageio -> LibRaw
  };

  "openjpeg" = fetch {
    pname       = "openjpeg";
    version     = "1.5.2";
    srcs        = [{ filename = "mingw-w64-i686-openjpeg-1.5.2-7-any.pkg.tar.xz"; sha256 = "1435b1222bc1e93ae1e8e82e00930e5ef7df8af36b2cc7690285c46f4cf7252a"; }];
    buildInputs = [ lcms2 libtiff libpng zlib ];
  };

  "openjpeg2" = fetch {
    pname       = "openjpeg2";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-openjpeg2-2.3.0-2-any.pkg.tar.xz"; sha256 = "c7bc640e8aeb57084e8b8e5ccfbc9faecba3089e953afb2df287f949ee1c0e8b"; }];
    buildInputs = [ gcc-libs lcms2 libtiff libpng zlib ];
  };

  "openldap" = fetch {
    pname       = "openldap";
    version     = "2.4.46";
    srcs        = [{ filename = "mingw-w64-i686-openldap-2.4.46-1-any.pkg.tar.xz"; sha256 = "74a1d71798b81d33ecbc90d3b7ed3e5dd83a1d060fbff5bb0094ae3baab1a86f"; }];
    buildInputs = [ cyrus-sasl icu libtool openssl ];
  };

  "openlibm" = fetch {
    pname       = "openlibm";
    version     = "0.6.0";
    srcs        = [{ filename = "mingw-w64-i686-openlibm-0.6.0-1-any.pkg.tar.xz"; sha256 = "cef52935bdc7f03bf2606db7126c692f0d56e90c076215edb754b287d6697e3b"; }];
  };

  "openocd" = fetch {
    pname       = "openocd";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-i686-openocd-0.10.0-1-any.pkg.tar.xz"; sha256 = "01ac85ddb3e2ff29a6228ddfaac2221741611cb1260071fce75b5b2b4d392fd9"; }];
    buildInputs = [ hidapi libusb libusb-compat-git libftdi ];
  };

  "openocd-git" = fetch {
    pname       = "openocd-git";
    version     = "0.9.0.r2.g79fdeb3";
    srcs        = [{ filename = "mingw-w64-i686-openocd-git-0.9.0.r2.g79fdeb3-1-any.pkg.tar.xz"; sha256 = "1ce6a7e6312394a1e38f2f7bb8291d931ba4c1759c5b94f6970a170db2ce7b6b"; }];
    buildInputs = [ hidapi libusb libusb-compat-git ];
  };

  "openscad" = fetch {
    pname       = "openscad";
    version     = "2015.03";
    srcs        = [{ filename = "mingw-w64-i686-openscad-2015.03-2-any.pkg.tar.xz"; sha256 = "df2e22c313dff430ba31a59b76e1b101a0da7c2a90586dd1229331cca4730d09"; }];
    buildInputs = [ qt5 boost cgal opencsg qscintilla shared-mime-info ];
  };

  "openshadinglanguage" = fetch {
    pname       = "openshadinglanguage";
    version     = "1.8.15";
    srcs        = [{ filename = "mingw-w64-i686-openshadinglanguage-1.8.15-3-any.pkg.tar.xz"; sha256 = "5a289a03bfc78bd451b8a2b827c5ab0a7048b5ede3762c8b192535e1a19aaab2"; }];
    buildInputs = [ boost clang freetype glew ilmbase intel-tbb libpng libtiff openexr openimageio pugixml ];
    broken      = true; # broken dependency openimageio -> LibRaw
  };

  "openssl" = fetch {
    pname       = "openssl";
    version     = "1.1.1.a";
    srcs        = [{ filename = "mingw-w64-i686-openssl-1.1.1.a-1-any.pkg.tar.xz"; sha256 = "35f6cf9ebc3192bd5057ff320c6e0528dde88d66fd5559f6bfb71b72303fa981"; }];
    buildInputs = [ ca-certificates gcc-libs zlib ];
  };

  "openvr" = fetch {
    pname       = "openvr";
    version     = "1.0.16";
    srcs        = [{ filename = "mingw-w64-i686-openvr-1.0.16-1-any.pkg.tar.xz"; sha256 = "05b5b0898516ab75b4dad4a033f5bf04242becc72ddc64cf8a226f8a84212d4a"; }];
    buildInputs = [ gcc-libs ];
  };

  "optipng" = fetch {
    pname       = "optipng";
    version     = "0.7.7";
    srcs        = [{ filename = "mingw-w64-i686-optipng-0.7.7-1-any.pkg.tar.xz"; sha256 = "b63b560c30465c09a44cbdda762b3d5b5467923175b46655ae6ccb4d982a0697"; }];
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "opus" = fetch {
    pname       = "opus";
    version     = "1.3";
    srcs        = [{ filename = "mingw-w64-i686-opus-1.3-1-any.pkg.tar.xz"; sha256 = "c9d638283032169a341c9ecd53bd322341bda6e67870b4659e7c9902b61ff8e1"; }];
    buildInputs = [  ];
  };

  "opus-tools" = fetch {
    pname       = "opus-tools";
    version     = "0.2";
    srcs        = [{ filename = "mingw-w64-i686-opus-tools-0.2-1-any.pkg.tar.xz"; sha256 = "bae2a5cd38fc54698f9f7012dfff2ecadd2cc586af589d12bb1fdc58f6a7d817"; }];
    buildInputs = [ gcc-libs flac libogg opus opusfile libopusenc ];
  };

  "opusfile" = fetch {
    pname       = "opusfile";
    version     = "0.11";
    srcs        = [{ filename = "mingw-w64-i686-opusfile-0.11-2-any.pkg.tar.xz"; sha256 = "f6cbe5b87055638b15093a36962062d3bb4e4451f5d88a70e8411db4e96f772f"; }];
    buildInputs = [ libogg openssl opus ];
  };

  "orc" = fetch {
    pname       = "orc";
    version     = "0.4.28";
    srcs        = [{ filename = "mingw-w64-i686-orc-0.4.28-1-any.pkg.tar.xz"; sha256 = "3808b4302f97edec0e6823936be10bfc5af9b51f5289823cb0987c53e8ece13d"; }];
  };

  "osgQt" = fetch {
    pname       = "osgQt";
    version     = "3.5.7";
    srcs        = [{ filename = "mingw-w64-i686-osgQt-3.5.7-6-any.pkg.tar.xz"; sha256 = "56a06b692fe814fbb2041e8bbbd211520342d885ec27a2f39d1e968ab6ff4ba5"; }];
    buildInputs = [ qt5 OpenSceneGraph ];
  };

  "osgQt-debug" = fetch {
    pname       = "osgQt-debug";
    version     = "3.5.7";
    srcs        = [{ filename = "mingw-w64-i686-osgQt-debug-3.5.7-6-any.pkg.tar.xz"; sha256 = "132a56ffb3f761669cd77e166426505444724951be5c67b11e9cf5a20ebf0674"; }];
    buildInputs = [ qt5 OpenSceneGraph-debug ];
  };

  "osgQtQuick-debug-git" = fetch {
    pname       = "osgQtQuick-debug-git";
    version     = "2.0.0.r172";
    srcs        = [{ filename = "mingw-w64-i686-osgQtQuick-debug-git-2.0.0.r172-4-any.pkg.tar.xz"; sha256 = "9a6e5b4d693f84a34c42a5266744a92d367c6ed9a62db22f65b50022ee3e9adf"; }];
    buildInputs = [ osgQt-debug qt5 (assert osgQtQuick-git.version=="2.0.0.r172"; osgQtQuick-git) OpenSceneGraph-debug ];
  };

  "osgQtQuick-git" = fetch {
    pname       = "osgQtQuick-git";
    version     = "2.0.0.r172";
    srcs        = [{ filename = "mingw-w64-i686-osgQtQuick-git-2.0.0.r172-4-any.pkg.tar.xz"; sha256 = "7edd3ab4cf457d35ea841cd8bc49a230286d0409c4ca1d5b5e3cf80ae6ebaaaf"; }];
    buildInputs = [ osgQt qt5 OpenSceneGraph ];
  };

  "osgbullet-debug-git" = fetch {
    pname       = "osgbullet-debug-git";
    version     = "3.0.0.265";
    srcs        = [{ filename = "mingw-w64-i686-osgbullet-debug-git-3.0.0.265-1-any.pkg.tar.xz"; sha256 = "301bdabd3bb71f45fc7763f69b3f5e8bb493ffc19fe01778f8e5349f015253fb"; }];
    buildInputs = [ (assert osgbullet-git.version=="3.0.0.265"; osgbullet-git) OpenSceneGraph-debug osgworks-debug-git ];
  };

  "osgbullet-git" = fetch {
    pname       = "osgbullet-git";
    version     = "3.0.0.265";
    srcs        = [{ filename = "mingw-w64-i686-osgbullet-git-3.0.0.265-1-any.pkg.tar.xz"; sha256 = "4014f581540b544384403d278d74d4a140dec7bf41fa7ecf9f5e046888ce3184"; }];
    buildInputs = [ bullet OpenSceneGraph osgworks-git ];
  };

  "osgearth" = fetch {
    pname       = "osgearth";
    version     = "2.10";
    srcs        = [{ filename = "mingw-w64-i686-osgearth-2.10-1-any.pkg.tar.xz"; sha256 = "71b1171072fc3894534ecfce69c03a857fd5d406b64b91275d2f6ef68b5387e4"; }];
    buildInputs = [ OpenSceneGraph OpenSceneGraph-debug osgQt osgQt-debug curl gdal geos poco protobuf rocksdb sqlite3 OpenSceneGraph ];
  };

  "osgearth-debug" = fetch {
    pname       = "osgearth-debug";
    version     = "2.10";
    srcs        = [{ filename = "mingw-w64-i686-osgearth-debug-2.10-1-any.pkg.tar.xz"; sha256 = "cce9b011f21f80a87a6592fd94e773ccf1bd1eef1c202943c42b4f12a0f486b1"; }];
    buildInputs = [ OpenSceneGraph OpenSceneGraph-debug osgQt osgQt-debug curl gdal geos poco protobuf rocksdb sqlite3 OpenSceneGraph-debug ];
  };

  "osgocean-debug-git" = fetch {
    pname       = "osgocean-debug-git";
    version     = "1.0.1.r161";
    srcs        = [{ filename = "mingw-w64-i686-osgocean-debug-git-1.0.1.r161-1-any.pkg.tar.xz"; sha256 = "d9b69b4771cfc217b378931f7b8cb150dda5668994ae1c1727d717de79f8da3a"; }];
    buildInputs = [ (assert osgocean-git.version=="1.0.1.r161"; osgocean-git) OpenSceneGraph-debug ];
  };

  "osgocean-git" = fetch {
    pname       = "osgocean-git";
    version     = "1.0.1.r161";
    srcs        = [{ filename = "mingw-w64-i686-osgocean-git-1.0.1.r161-1-any.pkg.tar.xz"; sha256 = "c63067cd62e703a8a5f0ad64750bfef93bfb76608c4cfd039092cd1848020b78"; }];
    buildInputs = [ fftw OpenSceneGraph ];
  };

  "osgworks-debug-git" = fetch {
    pname       = "osgworks-debug-git";
    version     = "3.1.0.444";
    srcs        = [{ filename = "mingw-w64-i686-osgworks-debug-git-3.1.0.444-3-any.pkg.tar.xz"; sha256 = "f5b7e1150de904f70f54e7b7d25aecb3f523f3cdb9bfa9fbebc5ac336f58246e"; }];
    buildInputs = [ (assert osgworks-git.version=="3.1.0.444"; osgworks-git) OpenSceneGraph-debug ];
  };

  "osgworks-git" = fetch {
    pname       = "osgworks-git";
    version     = "3.1.0.444";
    srcs        = [{ filename = "mingw-w64-i686-osgworks-git-3.1.0.444-3-any.pkg.tar.xz"; sha256 = "c90d3ed1c2505888e1600415811974d0eed104435fe891b5cd36b6ab35b8b8c2"; }];
    buildInputs = [ OpenSceneGraph vrpn ];
  };

  "osl" = fetch {
    pname       = "osl";
    version     = "0.9.2";
    srcs        = [{ filename = "mingw-w64-i686-osl-0.9.2-1-any.pkg.tar.xz"; sha256 = "22e797c7d41f56b83e4ba194152a77ef5284d6aa3a726ceec7e6dd3c4b41f4bd"; }];
    buildInputs = [ gmp ];
  };

  "osm-gps-map" = fetch {
    pname       = "osm-gps-map";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-osm-gps-map-1.1.0-2-any.pkg.tar.xz"; sha256 = "47560af1e6f6142300ef426cc2d02da903b3aa32f8e4b20f8044f8e92a879099"; }];
    buildInputs = [ libxml2 libsoup python2 gtk3 python2-gobject2 python2-cairo python2-pygtk gobject-introspection ];
  };

  "osmgpsmap-git" = fetch {
    pname       = "osmgpsmap-git";
    version     = "r443.c24d08d";
    srcs        = [{ filename = "mingw-w64-i686-osmgpsmap-git-r443.c24d08d-1-any.pkg.tar.xz"; sha256 = "4ece08a9dd43b4c5cca91c258450ca0e620684f8724d84eed557f0bc2ae3fe33"; }];
    buildInputs = [ gtk3 libsoup python2-gobject gobject-introspection ];
  };

  "osslsigncode" = fetch {
    pname       = "osslsigncode";
    version     = "1.7.1";
    srcs        = [{ filename = "mingw-w64-i686-osslsigncode-1.7.1-4-any.pkg.tar.xz"; sha256 = "6928ed865274210781b2b3fada438c21d4cc38448c8eef0f6642df3d245740cf"; }];
    buildInputs = [ curl libgsf openssl ];
  };

  "p11-kit" = fetch {
    pname       = "p11-kit";
    version     = "0.23.14";
    srcs        = [{ filename = "mingw-w64-i686-p11-kit-0.23.14-1-any.pkg.tar.xz"; sha256 = "456cfb440fc4eb31604af9a701ec232882df734297b0b61b79ce694d6feee8d8"; }];
    buildInputs = [ libtasn1 libffi gettext ];
  };

  "paho.mqtt.c" = fetch {
    pname       = "paho.mqtt.c";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-paho.mqtt.c-1.1.0-1-any.pkg.tar.xz"; sha256 = "2bb39a3a84f53d1570094cfa579028b63e1625aa85ed3f81b1dd171e2adbd1df"; }];
  };

  "pango" = fetch {
    pname       = "pango";
    version     = "1.43.0";
    srcs        = [{ filename = "mingw-w64-i686-pango-1.43.0-1-any.pkg.tar.xz"; sha256 = "b457aaedd6fc3c1e5d707ddd37393aa202a6bc626b68f12a4be3ef221930499f"; }];
    buildInputs = [ gcc-libs cairo freetype fontconfig glib2 harfbuzz fribidi libthai ];
  };

  "pangomm" = fetch {
    pname       = "pangomm";
    version     = "2.42.0";
    srcs        = [{ filename = "mingw-w64-i686-pangomm-2.42.0-1-any.pkg.tar.xz"; sha256 = "0d43af60af9cd504353f7ebc81a4b4b7597edd33c0cb53c54e6be3b7226741f9"; }];
    buildInputs = [ cairomm glibmm pango ];
  };

  "pcre" = fetch {
    pname       = "pcre";
    version     = "8.42";
    srcs        = [{ filename = "mingw-w64-i686-pcre-8.42-1-any.pkg.tar.xz"; sha256 = "dab2536d002bff301b775f3cdda62ac519c9dc7bbd42f7b586fe053b23ee0069"; }];
    buildInputs = [ gcc-libs bzip2 wineditline zlib ];
  };

  "pcre2" = fetch {
    pname       = "pcre2";
    version     = "10.32";
    srcs        = [{ filename = "mingw-w64-i686-pcre2-10.32-1-any.pkg.tar.xz"; sha256 = "8c52a83ab933a05644720ed87b74111690134c3b0a2541a7bf71082e43896253"; }];
    buildInputs = [ gcc-libs bzip2 wineditline zlib ];
  };

  "pdcurses" = fetch {
    pname       = "pdcurses";
    version     = "3.6";
    srcs        = [{ filename = "mingw-w64-i686-pdcurses-3.6-2-any.pkg.tar.xz"; sha256 = "b896b5f8e27a6299a0a1907bd96b87b97a69a84e3736dfa7cdbf1a9d8eaa5a55"; }];
    buildInputs = [ gcc-libs ];
  };

  "pdf2djvu" = fetch {
    pname       = "pdf2djvu";
    version     = "0.9.12";
    srcs        = [{ filename = "mingw-w64-i686-pdf2djvu-0.9.12-1-any.pkg.tar.xz"; sha256 = "2e1828f8ef97d4e546359b7120ed5365ffe20bb3d6e098d0f525061269f666a3"; }];
    buildInputs = [ poppler gcc-libs djvulibre exiv2 gettext graphicsmagick libiconv ];
  };

  "pdf2svg" = fetch {
    pname       = "pdf2svg";
    version     = "0.2.3";
    srcs        = [{ filename = "mingw-w64-i686-pdf2svg-0.2.3-7-any.pkg.tar.xz"; sha256 = "4a8ab63c9d298af7daa2b397eb9bfa964777fa1cd0524a72c73e3c38ac6e1798"; }];
    buildInputs = [ poppler ];
  };

  "pegtl" = fetch {
    pname       = "pegtl";
    version     = "2.7.1";
    srcs        = [{ filename = "mingw-w64-i686-pegtl-2.7.1-1-any.pkg.tar.xz"; sha256 = "1e884274a276cbf3d052f66aa4ee0fbb035ff1f8f1729a4ed328f0b25e644c3a"; }];
    buildInputs = [ gcc-libs ];
  };

  "perl" = fetch {
    pname       = "perl";
    version     = "5.28.0";
    srcs        = [{ filename = "mingw-w64-i686-perl-5.28.0-1-any.pkg.tar.xz"; sha256 = "6186059a3533d3634b445247785f608c1e5d6fe9fc075d63f2088203d6a1b42c"; }];
    buildInputs = [ gcc-libs winpthreads-git make ];
  };

  "perl-doc" = fetch {
    pname       = "perl-doc";
    version     = "5.28.0";
    srcs        = [{ filename = "mingw-w64-i686-perl-doc-5.28.0-1-any.pkg.tar.xz"; sha256 = "905f5f93267984a039afe0b070c954e5c3b2c8f8732dc4cecb04947f74f9fe95"; }];
  };

  "phodav" = fetch {
    pname       = "phodav";
    version     = "2.2";
    srcs        = [{ filename = "mingw-w64-i686-phodav-2.2-1-any.pkg.tar.xz"; sha256 = "0939239611c6ca4f836a3539cbe215db45aaea839151616234685aaafe18799e"; }];
    buildInputs = [ libsoup ];
  };

  "phonon-qt5" = fetch {
    pname       = "phonon-qt5";
    version     = "4.10.1";
    srcs        = [{ filename = "mingw-w64-i686-phonon-qt5-4.10.1-1-any.pkg.tar.xz"; sha256 = "e089c2167fb2683c61ad8cb43efffbb7747aa3b4757fbb6f0e5677ebe931a821"; }];
    buildInputs = [ qt5 glib2 ];
  };

  "physfs" = fetch {
    pname       = "physfs";
    version     = "3.0.1";
    srcs        = [{ filename = "mingw-w64-i686-physfs-3.0.1-1-any.pkg.tar.xz"; sha256 = "f144439a822ed0ab0bf65c38320926bed1cff456cc2fd58102d46a36159a176d"; }];
    buildInputs = [ zlib ];
  };

  "pidgin++" = fetch {
    pname       = "pidgin++";
    version     = "15.1";
    srcs        = [{ filename = "mingw-w64-i686-pidgin++-15.1-2-any.pkg.tar.xz"; sha256 = "17a722e8d262d9480cd8617f18d0cb77d9f8cc94691d79fe4b6e02b98173d692"; }];
    buildInputs = [ adwaita-icon-theme ca-certificates drmingw freetype fontconfig gettext gnutls gsasl gst-plugins-base gst-plugins-good gtk2 gtkspell libgadu libidn meanwhile nss ncurses silc-toolkit winsparkle zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "pidgin-hg" = fetch {
    pname       = "pidgin-hg";
    version     = "r37207.e666f49a3e86";
    srcs        = [{ filename = "mingw-w64-i686-pidgin-hg-r37207.e666f49a3e86-1-any.pkg.tar.xz"; sha256 = "0c5687e8b7d994b8086741fb1b2dc93461e47342a07757def16fe56c7bb4e91e"; }];
    buildInputs = [ adwaita-icon-theme ca-certificates farstream freetype fontconfig gettext gnutls gplugin gsasl gtk3 gtkspell libgadu libidn nss ncurses webkitgtk3 zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "pinentry" = fetch {
    pname       = "pinentry";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-pinentry-1.1.0-1-any.pkg.tar.xz"; sha256 = "25aa94b4ab14e631bca988a73c51ab446cf24ac294b33e206984bf858c233cc4"; }];
    buildInputs = [ qt5 libsecret libassuan ];
  };

  "pixman" = fetch {
    pname       = "pixman";
    version     = "0.36.0";
    srcs        = [{ filename = "mingw-w64-i686-pixman-0.36.0-1-any.pkg.tar.xz"; sha256 = "06135ff08edbf80bd6d11d14a4433e4e1bc6e0a4c89cb8e1c1ace9c38f30ee1b"; }];
    buildInputs = [ gcc-libs ];
  };

  "pkg-config" = fetch {
    pname       = "pkg-config";
    version     = "0.29.2";
    srcs        = [{ filename = "mingw-w64-i686-pkg-config-0.29.2-1-any.pkg.tar.xz"; sha256 = "39e07e61d739ba8f066605a109a19db397be6f7ddd81e5172f49ed253fdbe49f"; }];
    buildInputs = [ libwinpthread-git ];
  };

  "plasma-framework-qt5" = fetch {
    pname       = "plasma-framework-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-plasma-framework-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "e374b93fb7aca44e653f9c164a43783adedafcf9d46ccbc189e7c45e6caf2388"; }];
    buildInputs = [ qt5 kactivities-qt5 kdeclarative-qt5 kirigami2-qt5 ];
  };

  "plplot" = fetch {
    pname       = "plplot";
    version     = "5.13.0";
    srcs        = [{ filename = "mingw-w64-i686-plplot-5.13.0-3-any.pkg.tar.xz"; sha256 = "67f422242b91fa0bb3f0dd195d8f43e81e3008c1a7daed9ba43f442152cd42d7"; }];
    buildInputs = [ cairo gcc-libs gcc-libgfortran freetype libharu lua python2 python2-numpy shapelib tk wxWidgets ];
  };

  "png2ico" = fetch {
    pname       = "png2ico";
    version     = "2002.12.08";
    srcs        = [{ filename = "mingw-w64-i686-png2ico-2002.12.08-2-any.pkg.tar.xz"; sha256 = "30b38ada9bd1bb5141e956d0ba0306f2a60ed2746b4ac54c56c0a8874b65ee2a"; }];
    buildInputs = [  ];
  };

  "pngcrush" = fetch {
    pname       = "pngcrush";
    version     = "1.8.13";
    srcs        = [{ filename = "mingw-w64-i686-pngcrush-1.8.13-1-any.pkg.tar.xz"; sha256 = "27062b33489149b0fc5a17a3fe4e7526ddbf9e1cf68c57847ac511012b3ca22a"; }];
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "pngnq" = fetch {
    pname       = "pngnq";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-i686-pngnq-1.1-2-any.pkg.tar.xz"; sha256 = "d27d2c69fcf0a5151384cdb2a5b97be7cf17f5d47d5cf95742b0e9a6a192cab2"; }];
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "poco" = fetch {
    pname       = "poco";
    version     = "1.9.0";
    srcs        = [{ filename = "mingw-w64-i686-poco-1.9.0-1-any.pkg.tar.xz"; sha256 = "a4f362f6e86c672b12ff1c9ed508b1024c38621c0cb2f80f3333c01c63a2af0e"; }];
    buildInputs = [ gcc-libs expat libmariadbclient openssl pcre sqlite3 zlib ];
  };

  "podofo" = fetch {
    pname       = "podofo";
    version     = "0.9.6";
    srcs        = [{ filename = "mingw-w64-i686-podofo-0.9.6-1-any.pkg.tar.xz"; sha256 = "de7607d5a1264b5af1d12a573aefa56cdaa85b301baae6e61216da8a44269d91"; }];
    buildInputs = [ fontconfig libtiff libidn libjpeg-turbo lua openssl ];
  };

  "polipo" = fetch {
    pname       = "polipo";
    version     = "1.1.1";
    srcs        = [{ filename = "mingw-w64-i686-polipo-1.1.1-1-any.pkg.tar.xz"; sha256 = "90445206dbc4b497720efdb02606f7056d00d280b0c6f8e32b8a7ebc65a7387d"; }];
  };

  "polly" = fetch {
    pname       = "polly";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-polly-7.0.1-1-any.pkg.tar.xz"; sha256 = "ba889176a6d3e4d5c57081eb05ee3fcc4d57df2ad693f4e832c2a56e2fcc62a8"; }];
    buildInputs = [ (assert llvm.version=="7.0.1"; llvm) ];
  };

  "poppler" = fetch {
    pname       = "poppler";
    version     = "0.73.0";
    srcs        = [{ filename = "mingw-w64-i686-poppler-0.73.0-1-any.pkg.tar.xz"; sha256 = "53c138f9cd3672db2f9ef843cc86cba42626346416546fee0ca167bbf2ab0276"; }];
    buildInputs = [ cairo curl freetype icu lcms2 libjpeg libpng libtiff nss openjpeg2 poppler-data zlib ];
  };

  "poppler-data" = fetch {
    pname       = "poppler-data";
    version     = "0.4.9";
    srcs        = [{ filename = "mingw-w64-i686-poppler-data-0.4.9-1-any.pkg.tar.xz"; sha256 = "6b1d212660be9466eb760cf7db9542056e48e6063636ff053b464f9045aab753"; }];
    buildInputs = [  ];
  };

  "poppler-qt4" = fetch {
    pname       = "poppler-qt4";
    version     = "0.36.0";
    srcs        = [{ filename = "mingw-w64-i686-poppler-qt4-0.36.0-1-any.pkg.tar.xz"; sha256 = "8b9a9f09d2869b27e784b34f658b1384c9e01c2181cd6535bd96b88a8ec737e2"; }];
    buildInputs = [ cairo curl freetype icu libjpeg libpng libtiff openjpeg poppler-data zlib ];
  };

  "popt" = fetch {
    pname       = "popt";
    version     = "1.16";
    srcs        = [{ filename = "mingw-w64-i686-popt-1.16-1-any.pkg.tar.xz"; sha256 = "5560dbe8508eac9e20a5e5254373cfcd3934c8fcb07e5d4c2a48eb009aaad76f"; }];
    buildInputs = [ gettext ];
  };

  "port-scanner" = fetch {
    pname       = "port-scanner";
    version     = "1.3";
    srcs        = [{ filename = "mingw-w64-i686-port-scanner-1.3-2-any.pkg.tar.xz"; sha256 = "fa04ea693495a4fa1ccac36d194c85a33106e1a6750bab7aed80fe660a628897"; }];
  };

  "portablexdr" = fetch {
    pname       = "portablexdr";
    version     = "4.9.2.r27.94fb83c";
    srcs        = [{ filename = "mingw-w64-i686-portablexdr-4.9.2.r27.94fb83c-2-any.pkg.tar.xz"; sha256 = "00ce17d810107c13621a2bcf19bd49bd29ca107b6a0d32505f4dde6c22660b5b"; }];
    buildInputs = [ gcc-libs ];
  };

  "portaudio" = fetch {
    pname       = "portaudio";
    version     = "190600_20161030";
    srcs        = [{ filename = "mingw-w64-i686-portaudio-190600_20161030-3-any.pkg.tar.xz"; sha256 = "ec13d7af871a27228c17a8a6b0b583cdf49d130440c224be515e313e44a06064"; }];
    buildInputs = [ gcc-libs ];
  };

  "portmidi" = fetch {
    pname       = "portmidi";
    version     = "217";
    srcs        = [{ filename = "mingw-w64-i686-portmidi-217-2-any.pkg.tar.xz"; sha256 = "d8b490c771b8c80d459e8ae4ba3634351b32715aff05d3819d731a728cf60b01"; }];
    buildInputs = [ gcc-libs ];
  };

  "postgis" = fetch {
    pname       = "postgis";
    version     = "2.5.1";
    srcs        = [{ filename = "mingw-w64-i686-postgis-2.5.1-1-any.pkg.tar.xz"; sha256 = "b0a4f0648ab45d17f4d47f375060bf713fe01616765166bb8ac0232b37a0d594"; }];
    buildInputs = [ gcc-libs gdal geos gettext json-c libxml2 postgresql proj ];
  };

  "postgresql" = fetch {
    pname       = "postgresql";
    version     = "11.1";
    srcs        = [{ filename = "mingw-w64-i686-postgresql-11.1-1-any.pkg.tar.xz"; sha256 = "cf9732b303591454d44659671ecf4fd8b85e95da0a877805248a3cd01619550d"; }];
    buildInputs = [ gcc-libs gettext libxml2 libxslt openssl python2 tcl zlib winpty ];
  };

  "postr" = fetch {
    pname       = "postr";
    version     = "0.13.1";
    srcs        = [{ filename = "mingw-w64-i686-postr-0.13.1-1-any.pkg.tar.xz"; sha256 = "fdd646f377fc6773c52d2edf2b13e096f8a6d71b1586e0183308f6503122d39b"; }];
    buildInputs = [ python2-pygtk ];
  };

  "potrace" = fetch {
    pname       = "potrace";
    version     = "1.15";
    srcs        = [{ filename = "mingw-w64-i686-potrace-1.15-2-any.pkg.tar.xz"; sha256 = "c613138337aa42281d1f9691d6c2a3692eed9f2cb24cbe33bd815a9120c166dc"; }];
    buildInputs = [  ];
  };

  "premake" = fetch {
    pname       = "premake";
    version     = "4.3";
    srcs        = [{ filename = "mingw-w64-i686-premake-4.3-2-any.pkg.tar.xz"; sha256 = "3c9da70d22bf010300aea91b10033a0106cdbf43e348d0f45e352e784b16f8f7"; }];
  };

  "proj" = fetch {
    pname       = "proj";
    version     = "5.2.0";
    srcs        = [{ filename = "mingw-w64-i686-proj-5.2.0-1-any.pkg.tar.xz"; sha256 = "bc3cc401a4f1b3e1f93156ad43be99ede00a14a6ab33287a644ce2e1dadfe678"; }];
    buildInputs = [ gcc-libs ];
  };

  "protobuf" = fetch {
    pname       = "protobuf";
    version     = "3.6.1.3";
    srcs        = [{ filename = "mingw-w64-i686-protobuf-3.6.1.3-1-any.pkg.tar.xz"; sha256 = "dba419c2182abfb70699c09077e6f0720d135901d4f727bd8a11090a9668b059"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "protobuf-c" = fetch {
    pname       = "protobuf-c";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-i686-protobuf-c-1.3.1-1-any.pkg.tar.xz"; sha256 = "fd4d586b1b68eeab627873e049b2ffb51beebbc943f93ad6578dfe96f8d44967"; }];
    buildInputs = [ protobuf ];
  };

  "ptex" = fetch {
    pname       = "ptex";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-ptex-2.3.0-1-any.pkg.tar.xz"; sha256 = "6f3b43b4ea3945e2b539ba45bec29f6c2024984f0f1f99a39c4343375a5a8e16"; }];
    buildInputs = [ gcc-libs zlib winpthreads-git ];
  };

  "pugixml" = fetch {
    pname       = "pugixml";
    version     = "1.9";
    srcs        = [{ filename = "mingw-w64-i686-pugixml-1.9-1-any.pkg.tar.xz"; sha256 = "610c254e1830ad34d4a08f27bc8480299bb478602e9d843208450fb9956ef9e8"; }];
  };

  "pupnp" = fetch {
    pname       = "pupnp";
    version     = "1.6.25";
    srcs        = [{ filename = "mingw-w64-i686-pupnp-1.6.25-1-any.pkg.tar.xz"; sha256 = "a41a4f970b05fc5e5b7490e2fb90f25dff84f2884806fb616eb286be7b2f1341"; }];
  };

  "purple-facebook" = fetch {
    pname       = "purple-facebook";
    version     = "20160907.66ee773.bf8ed95";
    srcs        = [{ filename = "mingw-w64-i686-purple-facebook-20160907.66ee773.bf8ed95-1-any.pkg.tar.xz"; sha256 = "dd486b50007fafe5a471f07d877b36f154653c7914116d72094c6fcbb7814984"; }];
    buildInputs = [ libpurple json-glib glib2 zlib gettext gcc-libs ];
    broken      = true; # broken dependency purple-facebook -> libpurple
  };

  "purple-hangouts-hg" = fetch {
    pname       = "purple-hangouts-hg";
    version     = "r287+.574c112aa35c+";
    srcs        = [{ filename = "mingw-w64-i686-purple-hangouts-hg-r287+.574c112aa35c+-1-any.pkg.tar.xz"; sha256 = "ca542909f72fd9bf50482dc80144a1b98cecac3c92825ebb59de91a7dae0a751"; }];
    buildInputs = [ libpurple protobuf-c json-glib glib2 zlib gettext gcc-libs ];
    broken      = true; # broken dependency purple-hangouts-hg -> libpurple
  };

  "purple-skypeweb" = fetch {
    pname       = "purple-skypeweb";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-i686-purple-skypeweb-1.1-1-any.pkg.tar.xz"; sha256 = "6dabfd5f4ef053fdfabc678352508d6069a1f4571fcd53f212edfc00d268fed5"; }];
    buildInputs = [ libpurple json-glib glib2 zlib gettext gcc-libs ];
    broken      = true; # broken dependency purple-skypeweb -> libpurple
  };

  "putty" = fetch {
    pname       = "putty";
    version     = "0.70";
    srcs        = [{ filename = "mingw-w64-i686-putty-0.70-1-any.pkg.tar.xz"; sha256 = "050b0856c32d6abc05f2e5dc2b2b46287d2e5b5e26b8563ff55f42d8de21aaa6"; }];
    buildInputs = [ gcc-libs ];
  };

  "putty-ssh" = fetch {
    pname       = "putty-ssh";
    version     = "0.0";
    srcs        = [{ filename = "mingw-w64-i686-putty-ssh-0.0-3-any.pkg.tar.xz"; sha256 = "86176423007f5314f3981c9dc86a343ec6af95ee34c89b68816ce2d46da432ec"; }];
    buildInputs = [ gcc-libs putty ];
  };

  "pybind11" = fetch {
    pname       = "pybind11";
    version     = "2.2.4";
    srcs        = [{ filename = "mingw-w64-i686-pybind11-2.2.4-1-any.pkg.tar.xz"; sha256 = "000c9ab34ec9bfc792d4343ad034d4a71375718f9e81f35aa3ac4736ef5897ce"; }];
  };

  "pygobject-devel" = fetch {
    pname       = "pygobject-devel";
    version     = "3.30.4";
    srcs        = [{ filename = "mingw-w64-i686-pygobject-devel-3.30.4-1-any.pkg.tar.xz"; sha256 = "a8eba64f64d6172033798c73b186b523e6dcd80b6e1bcc7c9d6b51251192f4f6"; }];
    buildInputs = [  ];
  };

  "pygobject2-devel" = fetch {
    pname       = "pygobject2-devel";
    version     = "2.28.7";
    srcs        = [{ filename = "mingw-w64-i686-pygobject2-devel-2.28.7-1-any.pkg.tar.xz"; sha256 = "ef2132dcee91cf74e2daea558088246f03fc3d99084578a6f253956a518dc643"; }];
    buildInputs = [  ];
  };

  "pyilmbase" = fetch {
    pname       = "pyilmbase";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-pyilmbase-2.3.0-1-any.pkg.tar.xz"; sha256 = "72e14b564f90959f279db5510448e99cad992c15cd5abd0915638dc9c734b8a4"; }];
    buildInputs = [ (assert openexr.version=="2.3.0"; openexr) boost python2-numpy ];
  };

  "pyqt4-common" = fetch {
    pname       = "pyqt4-common";
    version     = "4.11.4";
    srcs        = [{ filename = "mingw-w64-i686-pyqt4-common-4.11.4-2-any.pkg.tar.xz"; sha256 = "48ace31b39e67aeea3b0cba37a62e868a57f4c879298a0b0069894f2fb27410f"; }];
    buildInputs = [ qt4 ];
  };

  "pyqt5-common" = fetch {
    pname       = "pyqt5-common";
    version     = "5.11.3";
    srcs        = [{ filename = "mingw-w64-i686-pyqt5-common-5.11.3-1-any.pkg.tar.xz"; sha256 = "6b47bfb21dc0547645fe6edb68f1f4efd6690fab42306879da1042b3a7a0bf23"; }];
    buildInputs = [ qt5 qtwebkit ];
  };

  "pyrex" = fetch {
    pname       = "pyrex";
    version     = "0.9.9";
    srcs        = [{ filename = "mingw-w64-i686-pyrex-0.9.9-1-any.pkg.tar.xz"; sha256 = "b7a5ede82d2b5a45e0e7561b80535686c1b89fe4d4e2041ac13270bc7205269b"; }];
    buildInputs = [ python2 ];
  };

  "pyside-common-qt4" = fetch {
    pname       = "pyside-common-qt4";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-pyside-common-qt4-1.2.2-3-any.pkg.tar.xz"; sha256 = "25a6e46c5cbb0d3c4187361e637e699c5b74ba8975d9debb421e47ed3d0862fa"; }];
  };

  "pyside-tools-common-qt4" = fetch {
    pname       = "pyside-tools-common-qt4";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-pyside-tools-common-qt4-1.2.2-3-any.pkg.tar.xz"; sha256 = "dc3a19951196885b0278a7899c9d1be8fd1b1d24fc3425906389a61f6877760e"; }];
    buildInputs = [ qt4 ];
  };

  "python-lxml-docs" = fetch {
    pname       = "python-lxml-docs";
    version     = "4.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python-lxml-docs-4.3.0-1-any.pkg.tar.xz"; sha256 = "6d7aeed08d15c6da25c3d423dfce83749167bc77f31f26358c6b7f86d000bc1b"; }];
  };

  "python-qscintilla-common" = fetch {
    pname       = "python-qscintilla-common";
    version     = "2.10.8";
    srcs        = [{ filename = "mingw-w64-i686-python-qscintilla-common-2.10.8-1-any.pkg.tar.xz"; sha256 = "d8e813300f517ae705155f599d58fc3e45af23182cfc87086b39bee6069abdad"; }];
    buildInputs = [ qscintilla ];
  };

  "python2" = fetch {
    pname       = "python2";
    version     = "2.7.15";
    srcs        = [{ filename = "mingw-w64-i686-python2-2.7.15-3-any.pkg.tar.xz"; sha256 = "4a2aec2864e9191d18f16a8f17c4c14e9559b46fc0388d9699073ac48e7e4f9d"; }];
    buildInputs = [ gcc-libs expat bzip2 libffi ncurses openssl readline tcl tk zlib ];
  };

  "python2-PyOpenGL" = fetch {
    pname       = "python2-PyOpenGL";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-PyOpenGL-3.1.0-1-any.pkg.tar.xz"; sha256 = "e45e1f1c520dec3c1714aa260ccf981340b1951cc7b1f9da12d2bfc6a56651b6"; }];
    buildInputs = [ python2 ];
  };

  "python2-alembic" = fetch {
    pname       = "python2-alembic";
    version     = "1.0.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-alembic-1.0.5-1-any.pkg.tar.xz"; sha256 = "6bf66fcac8ba39acfcafe28f542b83d26276ea9ff8462c35b86a9008eabd942d"; }];
    buildInputs = [ python2 python2-mako python2-sqlalchemy python2-editor python2-dateutil ];
  };

  "python2-apipkg" = fetch {
    pname       = "python2-apipkg";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-apipkg-1.5-1-any.pkg.tar.xz"; sha256 = "23b1bc86821f3c4f246534279187b71e159757dba9632ccc27a5668f0b2038fc"; }];
    buildInputs = [ python2 ];
  };

  "python2-appdirs" = fetch {
    pname       = "python2-appdirs";
    version     = "1.4.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-appdirs-1.4.3-3-any.pkg.tar.xz"; sha256 = "17cd4c2db6b95187cbb540bf007f0bbd98f3ead4114f31c87d62541c8281f5b0"; }];
    buildInputs = [ python2 ];
  };

  "python2-argh" = fetch {
    pname       = "python2-argh";
    version     = "0.26.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-argh-0.26.2-1-any.pkg.tar.xz"; sha256 = "5b235609b367664b94db48cff650ef51553d58fb83602440ddf87d8b2275e3b2"; }];
    buildInputs = [ python2 ];
  };

  "python2-argon2_cffi" = fetch {
    pname       = "python2-argon2_cffi";
    version     = "18.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-argon2_cffi-18.3.0-1-any.pkg.tar.xz"; sha256 = "68601a1122b05094c29853ea4b8cb4e0fd7273e9570ea61d5a0b3fb0bdce0fd0"; }];
    buildInputs = [ python2 python2-cffi python2-enum python2-setuptools python2-six ];
  };

  "python2-asn1crypto" = fetch {
    pname       = "python2-asn1crypto";
    version     = "0.24.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-asn1crypto-0.24.0-2-any.pkg.tar.xz"; sha256 = "2059daa6422f0f7e00d055c0bc0696d688b6c89b135a08c5b3ca200d9813dd68"; }];
    buildInputs = [ python2-pycparser ];
  };

  "python2-astroid" = fetch {
    pname       = "python2-astroid";
    version     = "1.6.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-astroid-1.6.5-2-any.pkg.tar.xz"; sha256 = "71f259868e77b9e0c5245b5cea13a3cd2af3bb14cc9802a0308e4856c5586a55"; }];
    buildInputs = [ python2-six python2-lazy-object-proxy python2-wrapt python2-singledispatch python2-enum34 self."python2-backports.functools_lru_cache" ];
  };

  "python2-atomicwrites" = fetch {
    pname       = "python2-atomicwrites";
    version     = "1.2.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-atomicwrites-1.2.1-1-any.pkg.tar.xz"; sha256 = "71611a507f1d5d5bd517339f41d3a21dc051a3dcacdddebc26759e0103169cba"; }];
    buildInputs = [ python2 ];
  };

  "python2-attrs" = fetch {
    pname       = "python2-attrs";
    version     = "18.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-attrs-18.2.0-1-any.pkg.tar.xz"; sha256 = "aa7f43093b9f645e87f4cc074aaef934b6482f92ecffcd0f3b76486a2e475bc6"; }];
    buildInputs = [ python2 ];
  };

  "python2-babel" = fetch {
    pname       = "python2-babel";
    version     = "2.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-babel-2.6.0-3-any.pkg.tar.xz"; sha256 = "0063c897dec7a3b057647e538141d01039d7ae525de55a50085eaf97627435f1"; }];
    buildInputs = [ python2-pytz ];
  };

  "python2-backcall" = fetch {
    pname       = "python2-backcall";
    version     = "0.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-backcall-0.1.0-2-any.pkg.tar.xz"; sha256 = "e5c9ed86a1d1053ce272ff3f23a8383c8d0f0bb96ea1fe8ab98888aecd32e16f"; }];
    buildInputs = [ python2 ];
  };

  "python2-backports" = fetch {
    pname       = "python2-backports";
    version     = "1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-backports-1.0-1-any.pkg.tar.xz"; sha256 = "09b6c9cb87bb30612613775248b46155c53232180a29ba97105a9d315173cddd"; }];
    buildInputs = [ python2 ];
  };

  "python2-backports-abc" = fetch {
    pname       = "python2-backports-abc";
    version     = "0.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-backports-abc-0.5-1-any.pkg.tar.xz"; sha256 = "2a8eb9fc7285ac57e6d147fece84eaff9a617f128f2d853e7e70c352a7ecdb9f"; }];
    buildInputs = [ python2 ];
  };

  "python2-backports.functools_lru_cache" = fetch {
    pname       = "python2-backports.functools_lru_cache";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-backports.functools_lru_cache-1.5-1-any.pkg.tar.xz"; sha256 = "89c9dff78760af6b9478f40ae395e6bd2a99fdb173be2a8aadf4b8a38441b426"; }];
    buildInputs = [ python2 ];
  };

  "python2-backports.os" = fetch {
    pname       = "python2-backports.os";
    version     = "0.1.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-backports.os-0.1.1-1-any.pkg.tar.xz"; sha256 = "e951590b21040258da46c9b002c519b539a3b8bec8b9017bdfa27aaa86106c8e"; }];
    buildInputs = [ python2-backports python2-future ];
  };

  "python2-backports.shutil_get_terminal_size" = fetch {
    pname       = "python2-backports.shutil_get_terminal_size";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-backports.shutil_get_terminal_size-1.0.0-1-any.pkg.tar.xz"; sha256 = "0f7fd97240b675a26b9eb552f6baa2fd57e0b6cf144cec30e0b46cb13f9f9e50"; }];
    buildInputs = [ python2-backports ];
  };

  "python2-backports.ssl_match_hostname" = fetch {
    pname       = "python2-backports.ssl_match_hostname";
    version     = "3.5.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-backports.ssl_match_hostname-3.5.0.1-1-any.pkg.tar.xz"; sha256 = "70df5ec4247fcde3f7752bdac95c79993eb234c8f539c28cceb9038a157e01b0"; }];
    buildInputs = [ python2-backports ];
  };

  "python2-bcrypt" = fetch {
    pname       = "python2-bcrypt";
    version     = "3.1.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-bcrypt-3.1.5-1-any.pkg.tar.xz"; sha256 = "5091f44b1d21810a35c44ec63731ff2810dc026725d777107c3ed37806b00cd7"; }];
    buildInputs = [ python2 ];
  };

  "python2-beaker" = fetch {
    pname       = "python2-beaker";
    version     = "1.10.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-beaker-1.10.0-2-any.pkg.tar.xz"; sha256 = "264efdb76fb10549289064040a00912d5fd7b2fca00ae365742f1bc639169fe3"; }];
    buildInputs = [ python2 ];
  };

  "python2-beautifulsoup3" = fetch {
    pname       = "python2-beautifulsoup3";
    version     = "3.2.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-beautifulsoup3-3.2.1-2-any.pkg.tar.xz"; sha256 = "f1e60ad24db56d38a8566b05586fe27a54fee165f2ec8ea6b3203b3cd4bf73a0"; }];
    buildInputs = [ python2 ];
  };

  "python2-beautifulsoup4" = fetch {
    pname       = "python2-beautifulsoup4";
    version     = "4.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-beautifulsoup4-4.7.0-1-any.pkg.tar.xz"; sha256 = "63e96b4cf8f4ba07fdb6efe8d8f6618292a4eda26e2b4f137bb39fd94c65ab40"; }];
    buildInputs = [ python2 python2-soupsieve ];
  };

  "python2-biopython" = fetch {
    pname       = "python2-biopython";
    version     = "1.73";
    srcs        = [{ filename = "mingw-w64-i686-python2-biopython-1.73-1-any.pkg.tar.xz"; sha256 = "109efec3acd0161edaf0af741e6acdb7e0117793101d43351b0e0b749f10988e"; }];
    buildInputs = [ python2-numpy ];
  };

  "python2-bleach" = fetch {
    pname       = "python2-bleach";
    version     = "3.0.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-bleach-3.0.2-1-any.pkg.tar.xz"; sha256 = "049b5d536f25420755bdc81b167658de4a015301519de02f1ee2eababc3916f7"; }];
    buildInputs = [ python2 python2-html5lib ];
  };

  "python2-breathe" = fetch {
    pname       = "python2-breathe";
    version     = "4.11.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-breathe-4.11.1-1-any.pkg.tar.xz"; sha256 = "20aa6a2edff638edbb4ce338ddb95266824016e25feae6880d18d3ee192da4bc"; }];
    buildInputs = [ python2 ];
  };

  "python2-brotli" = fetch {
    pname       = "python2-brotli";
    version     = "1.0.7";
    srcs        = [{ filename = "mingw-w64-i686-python2-brotli-1.0.7-1-any.pkg.tar.xz"; sha256 = "f8907329617d59dadc64bcdcd251a5e49a02e10c1131c8981217f9780c95b2dc"; }];
    buildInputs = [ python2 libwinpthread-git ];
  };

  "python2-bsddb3" = fetch {
    pname       = "python2-bsddb3";
    version     = "6.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-bsddb3-6.1.0-3-any.pkg.tar.xz"; sha256 = "aa7ff2aec20b2a24b15ff4140149458eeaf64410184043da836912e3dbfb8dd6"; }];
    buildInputs = [ python2 db ];
  };

  "python2-cachecontrol" = fetch {
    pname       = "python2-cachecontrol";
    version     = "0.12.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-cachecontrol-0.12.5-1-any.pkg.tar.xz"; sha256 = "115b68e48c840b3f93979a425d1cd20839fe5415c85bc4c44675020e7f31f20b"; }];
    buildInputs = [ python2 python2-msgpack python2-requests ];
  };

  "python2-cairo" = fetch {
    pname       = "python2-cairo";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-cairo-1.18.0-1-any.pkg.tar.xz"; sha256 = "66c41b4ce7b2e86df16805f914a5dcd1fd24fccea8987008fa063715a83a453f"; }];
    buildInputs = [ cairo python2 ];
  };

  "python2-can" = fetch {
    pname       = "python2-can";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-can-3.0.0-1-any.pkg.tar.xz"; sha256 = "f63220a778d5683012fc53d6ad1b32ddeb33db388cb93263fae69aecd62d7fba"; }];
    buildInputs = [ python2 python2-python_ics python2-pyserial ];
  };

  "python2-capstone" = fetch {
    pname       = "python2-capstone";
    version     = "4.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-capstone-4.0-1-any.pkg.tar.xz"; sha256 = "c34108e40e110ed8274840dd15cd96c81fec437862be3d5647ddf61d96c67b27"; }];
    buildInputs = [ capstone python2 ];
  };

  "python2-certifi" = fetch {
    pname       = "python2-certifi";
    version     = "2018.11.29";
    srcs        = [{ filename = "mingw-w64-i686-python2-certifi-2018.11.29-2-any.pkg.tar.xz"; sha256 = "940ffba6577c30773442a2239680bb1632c756848e4b4e6c6bb56485b0c6b78a"; }];
    buildInputs = [ python2 ];
  };

  "python2-cffi" = fetch {
    pname       = "python2-cffi";
    version     = "1.11.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-cffi-1.11.5-2-any.pkg.tar.xz"; sha256 = "2d06957ef27085a1424b9c92640eb482f9409c424755b401ae785b71c089334e"; }];
    buildInputs = [ python2-pycparser ];
  };

  "python2-characteristic" = fetch {
    pname       = "python2-characteristic";
    version     = "14.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-characteristic-14.3.0-3-any.pkg.tar.xz"; sha256 = "19fbabafa9d6b6ba1b30a3bcfdad8040af26b09fdae2fe0f88e15a619c650020"; }];
  };

  "python2-chardet" = fetch {
    pname       = "python2-chardet";
    version     = "3.0.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-chardet-3.0.4-2-any.pkg.tar.xz"; sha256 = "62a34c11a22d61d28839166a0e30b4a104bcc5abd2e308daafacfa082c93983d"; }];
    buildInputs = [ python2-setuptools ];
  };

  "python2-cjson" = fetch {
    pname       = "python2-cjson";
    version     = "1.2.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-cjson-1.2.1-1-any.pkg.tar.xz"; sha256 = "49643ec6a055529aea94853b34bd364b3ff80d97464f784ef2df27c10cd5029f"; }];
    buildInputs = [ python2 ];
  };

  "python2-cliff" = fetch {
    pname       = "python2-cliff";
    version     = "2.14.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-cliff-2.14.0-1-any.pkg.tar.xz"; sha256 = "eb688d2372bacbba257d4f9787c0637d78849b9ce3668c552faf25bae8f0fa43"; }];
    buildInputs = [ python2 python2-six python2-pbr python2-cmd2 python2-prettytable python2-pyparsing python2-stevedore python2-unicodecsv python2-yaml ];
  };

  "python2-cmd2" = fetch {
    pname       = "python2-cmd2";
    version     = "0.8.9";
    srcs        = [{ filename = "mingw-w64-i686-python2-cmd2-0.8.9-1-any.pkg.tar.xz"; sha256 = "dcf25aaf58ea38e8fc74b2c51038cb9474bb025b78a20603751ce1c0f2d9ae59"; }];
    buildInputs = [ python2-pyparsing python2-pyperclip python2-colorama python2-contextlib2 python2-enum34 python2-wcwidth python2-subprocess32 ];
  };

  "python2-colorama" = fetch {
    pname       = "python2-colorama";
    version     = "0.4.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-colorama-0.4.1-1-any.pkg.tar.xz"; sha256 = "e0af8fd42e7ee077c0bc93ee0e428434753071ba61bedaa9c1aedd74bfa2c841"; }];
    buildInputs = [ python2 ];
  };

  "python2-colorspacious" = fetch {
    pname       = "python2-colorspacious";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-colorspacious-1.1.2-2-any.pkg.tar.xz"; sha256 = "da404ff0c59520f4dfd483467fdbbc30c878317335bc502ba355b17a5e2d4c9a"; }];
    buildInputs = [ python2 ];
  };

  "python2-colour" = fetch {
    pname       = "python2-colour";
    version     = "0.3.11";
    srcs        = [{ filename = "mingw-w64-i686-python2-colour-0.3.11-1-any.pkg.tar.xz"; sha256 = "5511ece62cb221623f5cec7ec4f546b0a4a522333724fc061ee894f144db3f4e"; }];
    buildInputs = [ python2 ];
  };

  "python2-comtypes" = fetch {
    pname       = "python2-comtypes";
    version     = "1.1.7";
    srcs        = [{ filename = "mingw-w64-i686-python2-comtypes-1.1.7-1-any.pkg.tar.xz"; sha256 = "62c126c3a80a7ea80a5555b0321f116a1c705588c36531ef3d8981c87cad4c35"; }];
    buildInputs = [ python2 ];
  };

  "python2-configparser" = fetch {
    pname       = "python2-configparser";
    version     = "3.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-configparser-3.5.0-3-any.pkg.tar.xz"; sha256 = "4dd758e1ec2b6582b07831dbd0555bab13c4fff9f9353c1767db010fcae21fc1"; }];
    buildInputs = [ python2 python2-backports ];
  };

  "python2-contextlib2" = fetch {
    pname       = "python2-contextlib2";
    version     = "0.5.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-contextlib2-0.5.5-1-any.pkg.tar.xz"; sha256 = "274b187b630ea8fd2b7b969c5986b113b510fd2be7e6d5da4be52d08d0cb81e7"; }];
    buildInputs = [ python2 ];
  };

  "python2-coverage" = fetch {
    pname       = "python2-coverage";
    version     = "4.5.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-coverage-4.5.2-1-any.pkg.tar.xz"; sha256 = "19db8ad7795c377f0f3f52d8a18721df909731cad2e686ca90912213e92be4ca"; }];
    buildInputs = [ python2 ];
  };

  "python2-crcmod" = fetch {
    pname       = "python2-crcmod";
    version     = "1.7";
    srcs        = [{ filename = "mingw-w64-i686-python2-crcmod-1.7-2-any.pkg.tar.xz"; sha256 = "8ce4c01178980201a2fea349925c114f40ac7ba96f5dd641f47141d510b11441"; }];
    buildInputs = [ python2 ];
  };

  "python2-cryptography" = fetch {
    pname       = "python2-cryptography";
    version     = "2.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-cryptography-2.4.2-1-any.pkg.tar.xz"; sha256 = "e174b714090d39494bd42debfb319b4cb4f8b89c47f37dee3c203bf02247a180"; }];
    buildInputs = [ python2-cffi python2-pyasn1 python2-idna python2-asn1crypto ];
  };

  "python2-cssselect" = fetch {
    pname       = "python2-cssselect";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-cssselect-1.0.3-2-any.pkg.tar.xz"; sha256 = "7d0cd90de3093ee080336e95f0b65a3e395022a3af86cd2409d878a0607c91ab"; }];
    buildInputs = [ python2 ];
    broken      = true; # broken dependency python2-cssselect -> python2>
  };

  "python2-cvxopt" = fetch {
    pname       = "python2-cvxopt";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-cvxopt-1.2.2-1-any.pkg.tar.xz"; sha256 = "f716b2d29d54e1735c9e542f691a6dcb9f7b85c4ca474564b678cd2e5cb91a32"; }];
    buildInputs = [ python2 ];
  };

  "python2-cx_Freeze" = fetch {
    pname       = "python2-cx_Freeze";
    version     = "5.1.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-cx_Freeze-5.1.1-3-any.pkg.tar.xz"; sha256 = "8c4ffc4b83fde9b3f6def6ffaf5a7a58afd1bcdcea7ac18d7fd42ecaa8b1db40"; }];
    buildInputs = [ python2 python2-six ];
  };

  "python2-cycler" = fetch {
    pname       = "python2-cycler";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-cycler-0.10.0-3-any.pkg.tar.xz"; sha256 = "4c580e94a7606b5faca1a8ca159784d24283ee0b0b8bc55d9f6ec1c6c4114275"; }];
    buildInputs = [ python2 python2-six ];
  };

  "python2-dateutil" = fetch {
    pname       = "python2-dateutil";
    version     = "2.7.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-dateutil-2.7.5-1-any.pkg.tar.xz"; sha256 = "8400eea01ebd5d8f45e22e1ad21137fcc4c492a715cf7efb6f06c6f842cd165e"; }];
    buildInputs = [ python2-six ];
  };

  "python2-ddt" = fetch {
    pname       = "python2-ddt";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-ddt-1.2.0-1-any.pkg.tar.xz"; sha256 = "4930a774c5244f0b4d784203e319e88cf8e152ec796421e1af53b29f0f56ec2c"; }];
    buildInputs = [ python2 ];
  };

  "python2-debtcollector" = fetch {
    pname       = "python2-debtcollector";
    version     = "1.20.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-debtcollector-1.20.0-1-any.pkg.tar.xz"; sha256 = "c8d73f7bbee8b5bc92b252a0e4f7f95c61b70b3528ca4620aa562b2aad35c61a"; }];
    buildInputs = [ python2 python2-six python2-pbr python2-babel python2-wrapt ];
  };

  "python2-decorator" = fetch {
    pname       = "python2-decorator";
    version     = "4.3.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-decorator-4.3.1-1-any.pkg.tar.xz"; sha256 = "c6f4480110b244a2556d392f557acfaeb050cff4f1890a3f84afff40c1f549a2"; }];
    buildInputs = [ python2 ];
  };

  "python2-defusedxml" = fetch {
    pname       = "python2-defusedxml";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-defusedxml-0.5.0-1-any.pkg.tar.xz"; sha256 = "abce05a645f1608e3ff0c2233a9b4da92b4463da64f7c33be8527dbe3c9fad95"; }];
    buildInputs = [ python2 ];
  };

  "python2-distlib" = fetch {
    pname       = "python2-distlib";
    version     = "0.2.8";
    srcs        = [{ filename = "mingw-w64-i686-python2-distlib-0.2.8-1-any.pkg.tar.xz"; sha256 = "dfcf1ddd26c20850171b88c8f5246be35ea5aaa6ad932e56ae68422db95d795b"; }];
    buildInputs = [ python2 ];
  };

  "python2-distutils-extra" = fetch {
    pname       = "python2-distutils-extra";
    version     = "2.39";
    srcs        = [{ filename = "mingw-w64-i686-python2-distutils-extra-2.39-4-any.pkg.tar.xz"; sha256 = "7d767e43d992b5c40416433027db4a4ca47cabb3a3ed92a6617bde6d96b7450b"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2.version "2.7"; python2) intltool ];
    broken      = true; # broken dependency python2-distutils-extra -> intltool
  };

  "python2-django" = fetch {
    pname       = "python2-django";
    version     = "1.11.13";
    srcs        = [{ filename = "mingw-w64-i686-python2-django-1.11.13-2-any.pkg.tar.xz"; sha256 = "0a8e93b83fc9a062672b1ba0369617b9e69ddd72f3602ef4bd54d0edfbc7928b"; }];
    buildInputs = [ python2 python2-pytz ];
  };

  "python2-dnspython" = fetch {
    pname       = "python2-dnspython";
    version     = "1.16.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-dnspython-1.16.0-1-any.pkg.tar.xz"; sha256 = "333253d4838c54550671e5f22a2c54309a79e6b2cb308054fe37fe6b7674145c"; }];
    buildInputs = [ python2 ];
  };

  "python2-docutils" = fetch {
    pname       = "python2-docutils";
    version     = "0.14";
    srcs        = [{ filename = "mingw-w64-i686-python2-docutils-0.14-3-any.pkg.tar.xz"; sha256 = "96050b6f9d2bba1ae4bbf04fc37dcd5186c65d31a994df48885bfda2f2a8d26a"; }];
    buildInputs = [ python2 ];
  };

  "python2-editor" = fetch {
    pname       = "python2-editor";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-editor-1.0.3-1-any.pkg.tar.xz"; sha256 = "a556abbb7fd52593de4b539f9f964dc4478766e63ad942f81fa6aa104d020660"; }];
    buildInputs = [ python2 ];
  };

  "python2-email-validator" = fetch {
    pname       = "python2-email-validator";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-email-validator-1.0.3-1-any.pkg.tar.xz"; sha256 = "8894a671f987c36f3e98b3f565635210001454e1d5130d53ab72b630c005bf06"; }];
    buildInputs = [ python2 python2-dnspython python2-idna ];
  };

  "python2-enum" = fetch {
    pname       = "python2-enum";
    version     = "0.4.6";
    srcs        = [{ filename = "mingw-w64-i686-python2-enum-0.4.6-1-any.pkg.tar.xz"; sha256 = "9f4a20c56c41087a2e6c654a35972a59c2c80eabfe0aedc12fb053c91e06a7a9"; }];
    buildInputs = [ python2 ];
  };

  "python2-enum34" = fetch {
    pname       = "python2-enum34";
    version     = "1.1.6";
    srcs        = [{ filename = "mingw-w64-i686-python2-enum34-1.1.6-1-any.pkg.tar.xz"; sha256 = "68e64e9a8571b67bb0d636790cf822f7a1566145304eabe49f2fb45aee3c2b9f"; }];
    buildInputs = [ python2 ];
  };

  "python2-et-xmlfile" = fetch {
    pname       = "python2-et-xmlfile";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-et-xmlfile-1.0.1-3-any.pkg.tar.xz"; sha256 = "fe11bf1e4c225e9337df0865d0d4e25f3628ebc7e3ed7960aebef311244022eb"; }];
    buildInputs = [ python2-lxml ];
  };

  "python2-eventlet" = fetch {
    pname       = "python2-eventlet";
    version     = "0.24.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-eventlet-0.24.1-1-any.pkg.tar.xz"; sha256 = "55fe21e87e1ce61c31488a23c5c2488623a39c41b382580f4766698200f689e4"; }];
    buildInputs = [ python2 python2-greenlet python2-monotonic ];
  };

  "python2-execnet" = fetch {
    pname       = "python2-execnet";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-execnet-1.5.0-1-any.pkg.tar.xz"; sha256 = "f1f3478d0337e574caf6dae845bdb1220008883e826eb613881831c629f7cc3e"; }];
    buildInputs = [ python2 python2-apipkg ];
  };

  "python2-extras" = fetch {
    pname       = "python2-extras";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-extras-1.0.0-1-any.pkg.tar.xz"; sha256 = "bf5344d3b8258f41ea8a02c3c39504b5a12877df0faf612baf938bf36c955e6a"; }];
    buildInputs = [ python2 ];
  };

  "python2-faker" = fetch {
    pname       = "python2-faker";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-faker-1.0.1-1-any.pkg.tar.xz"; sha256 = "5aea370b85312ad9dd684d8fd26973d977e4a4fa08fda50a80cfafccdf2fd78c"; }];
    buildInputs = [ python2 python2-dateutil python2-ipaddress python2-six python2-text-unidecode ];
  };

  "python2-fasteners" = fetch {
    pname       = "python2-fasteners";
    version     = "0.14.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-fasteners-0.14.1-1-any.pkg.tar.xz"; sha256 = "99f67dba3c50303b37cf2b133b868d622eb3ff3a5956c0827083e872812ba1cd"; }];
    buildInputs = [ python2 python2-six python2-monotonic ];
  };

  "python2-filelock" = fetch {
    pname       = "python2-filelock";
    version     = "3.0.10";
    srcs        = [{ filename = "mingw-w64-i686-python2-filelock-3.0.10-1-any.pkg.tar.xz"; sha256 = "d17836c6a713ff35ba0e79edd2ff3858b69b97e4a360df7c80fd1159f01bc249"; }];
    buildInputs = [ python2 ];
  };

  "python2-fixtures" = fetch {
    pname       = "python2-fixtures";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-fixtures-3.0.0-2-any.pkg.tar.xz"; sha256 = "21da4e7776cf4b8d0d5302e96d9ac8ee46735a1b744d4b2259a4d1365bc6dfd2"; }];
    buildInputs = [ python2 python2-pbr python2-six ];
  };

  "python2-flake8" = fetch {
    pname       = "python2-flake8";
    version     = "3.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-flake8-3.6.0-1-any.pkg.tar.xz"; sha256 = "7dc3c1bd0ef4283a0b0f3803746553d2fee85c0c06c6a5f6ef920fc407b47c97"; }];
    buildInputs = [ python2-pyflakes python2-mccabe python2-pycodestyle python2-enum34 python2-configparser ];
  };

  "python2-flaky" = fetch {
    pname       = "python2-flaky";
    version     = "3.4.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-flaky-3.4.0-2-any.pkg.tar.xz"; sha256 = "02ba5396a67d2fdc1053e6da9f1e3549267eac06101ab8bf32ff3f4e58da33bf"; }];
    buildInputs = [ python2 ];
  };

  "python2-flexmock" = fetch {
    pname       = "python2-flexmock";
    version     = "0.10.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-flexmock-0.10.2-1-any.pkg.tar.xz"; sha256 = "5f9c4929b45ccbe04117c9afaeb5df66d673f88c6c6d961abd7f721c86ff6d1e"; }];
    buildInputs = [ python2 ];
  };

  "python2-fonttools" = fetch {
    pname       = "python2-fonttools";
    version     = "3.30.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-fonttools-3.30.0-1-any.pkg.tar.xz"; sha256 = "18c238a3a6d47fe69ab231e2a8ac181d2e6614ab7a9c223edd2cae95f679799e"; }];
    buildInputs = [ python2 python2-numpy ];
  };

  "python2-freezegun" = fetch {
    pname       = "python2-freezegun";
    version     = "0.3.11";
    srcs        = [{ filename = "mingw-w64-i686-python2-freezegun-0.3.11-1-any.pkg.tar.xz"; sha256 = "7a05fbae456560443fa88732b1c15603cac45aab6e61ce947343e6cbb841c6b9"; }];
    buildInputs = [ python2 python2-dateutil ];
  };

  "python2-funcsigs" = fetch {
    pname       = "python2-funcsigs";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-funcsigs-1.0.2-2-any.pkg.tar.xz"; sha256 = "267a23b2664b65e8b4d5bb110307199718a709a6bcde651c36411bede9fa65f8"; }];
    buildInputs = [ python2 ];
  };

  "python2-functools32" = fetch {
    pname       = "python2-functools32";
    version     = "3.2.3_2";
    srcs        = [{ filename = "mingw-w64-i686-python2-functools32-3.2.3_2-1-any.pkg.tar.xz"; sha256 = "2bab23016c9bcee258492e11399bede2dc8382308fcc88b8ef3563da6a42a238"; }];
    buildInputs = [ python2 ];
  };

  "python2-future" = fetch {
    pname       = "python2-future";
    version     = "0.17.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-future-0.17.1-1-any.pkg.tar.xz"; sha256 = "451b266a08511a3c2250cb5a65fd8b722f1deb8a6a039b2cfaab7f17e80db0fb"; }];
    buildInputs = [ python2 ];
  };

  "python2-futures" = fetch {
    pname       = "python2-futures";
    version     = "3.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-futures-3.2.0-1-any.pkg.tar.xz"; sha256 = "babf5dec08c12215311ee7d7bb591e59411e0f950c64ddee868f65372a6cdef3"; }];
    buildInputs = [ python2 ];
  };

  "python2-genty" = fetch {
    pname       = "python2-genty";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-genty-1.3.2-2-any.pkg.tar.xz"; sha256 = "a1122a3c9cd9f6cd1217099421660a9d6cfb03252f041a5c0d25321b17f2202c"; }];
    buildInputs = [ python2 python2-six ];
  };

  "python2-gmpy2" = fetch {
    pname       = "python2-gmpy2";
    version     = "2.1.0a4";
    srcs        = [{ filename = "mingw-w64-i686-python2-gmpy2-2.1.0a4-1-any.pkg.tar.xz"; sha256 = "c96041cb9f2c0399269293af46263696cf5e02cf66137a05d5f0a4eadbadc266"; }];
    buildInputs = [ python2 mpc ];
  };

  "python2-gobject" = fetch {
    pname       = "python2-gobject";
    version     = "3.30.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-gobject-3.30.4-1-any.pkg.tar.xz"; sha256 = "338fc2167fb747b2de10ca8b0882062f3bdd21fd358c45ab1a904f29591503b1"; }];
    buildInputs = [ glib2 python2-cairo libffi gobject-introspection-runtime (assert pygobject-devel.version=="3.30.4"; pygobject-devel) ];
  };

  "python2-gobject2" = fetch {
    pname       = "python2-gobject2";
    version     = "2.28.7";
    srcs        = [{ filename = "mingw-w64-i686-python2-gobject2-2.28.7-1-any.pkg.tar.xz"; sha256 = "6d849fee8a314d9fa0c291d16cefbee5a5eba09e6e31fcb61841d46b3478aa95"; }];
    buildInputs = [ glib2 libffi gobject-introspection-runtime (assert pygobject2-devel.version=="2.28.7"; pygobject2-devel) ];
  };

  "python2-greenlet" = fetch {
    pname       = "python2-greenlet";
    version     = "0.4.15";
    srcs        = [{ filename = "mingw-w64-i686-python2-greenlet-0.4.15-1-any.pkg.tar.xz"; sha256 = "17c2615a9e776089cfd6c6c887d91606610f081876320611899489b98a2e82cf"; }];
    buildInputs = [ python2 ];
  };

  "python2-h5py" = fetch {
    pname       = "python2-h5py";
    version     = "2.9.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-h5py-2.9.0-1-any.pkg.tar.xz"; sha256 = "489a34eedf554cb27d415dc36a190fa056c7d35c476a15ead5e0c78dbcacab6b"; }];
    buildInputs = [ python2-numpy python2-six hdf5 ];
  };

  "python2-hacking" = fetch {
    pname       = "python2-hacking";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-hacking-1.1.0-1-any.pkg.tar.xz"; sha256 = "d840c8e0086d126254ddacd2393c71423428b542d83739f71d0ca518d8910706"; }];
    buildInputs = [ python2 ];
  };

  "python2-html5lib" = fetch {
    pname       = "python2-html5lib";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-html5lib-1.0.1-3-any.pkg.tar.xz"; sha256 = "15acc2b2f4412743c1df804a08b7f537a8f31615306639efa755da1d3c8f497c"; }];
    buildInputs = [ python2 python2-six python2-webencodings ];
  };

  "python2-httplib2" = fetch {
    pname       = "python2-httplib2";
    version     = "0.12.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-httplib2-0.12.0-1-any.pkg.tar.xz"; sha256 = "c908b3274f15d39237608d2a2555da61ff39cb4fd2f128a9d61d9824896056ee"; }];
    buildInputs = [ python2 python2-certifi ca-certificates ];
  };

  "python2-hypothesis" = fetch {
    pname       = "python2-hypothesis";
    version     = "3.84.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-hypothesis-3.84.4-1-any.pkg.tar.xz"; sha256 = "e045397933483d099ab82d3cdccf5b3ee09f9e5cbb057baba558669ab6b8e1e3"; }];
    buildInputs = [ python2 python2-attrs python2-coverage python2-enum34 ];
  };

  "python2-icu" = fetch {
    pname       = "python2-icu";
    version     = "2.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-icu-2.2-1-any.pkg.tar.xz"; sha256 = "ac7b5c0d95d2deea2258f4665518ec3eb62e56081f669700fd2e97b75c7e370b"; }];
    buildInputs = [ python2 icu ];
  };

  "python2-idna" = fetch {
    pname       = "python2-idna";
    version     = "2.8";
    srcs        = [{ filename = "mingw-w64-i686-python2-idna-2.8-1-any.pkg.tar.xz"; sha256 = "12e6083157de1088458119ded2c00741ece2a4edac4963cc2a0c9a3f481cc07b"; }];
    buildInputs = [  ];
  };

  "python2-ifaddr" = fetch {
    pname       = "python2-ifaddr";
    version     = "0.1.6";
    srcs        = [{ filename = "mingw-w64-i686-python2-ifaddr-0.1.6-1-any.pkg.tar.xz"; sha256 = "4ee2d14353a93421b4c64acdb6cb8b82ba50f6deeab64e2237d96d43e55ae708"; }];
    buildInputs = [ python2 python2-ipaddress ];
  };

  "python2-imagesize" = fetch {
    pname       = "python2-imagesize";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-imagesize-1.1.0-1-any.pkg.tar.xz"; sha256 = "b1e526b5b82b1c2a18259fc53d179486a3118d80e0475ca7c3ecbc332d918e33"; }];
    buildInputs = [ python2 ];
  };

  "python2-importlib-metadata" = fetch {
    pname       = "python2-importlib-metadata";
    version     = "0.7";
    srcs        = [{ filename = "mingw-w64-i686-python2-importlib-metadata-0.7-1-any.pkg.tar.xz"; sha256 = "eaa17227452ad51087ea8bfeb91b0b774ae3c456f17d618fbf28f5e0131cf97a"; }];
    buildInputs = [ python2 python2-contextlib2 python2-pathlib2 ];
  };

  "python2-importlib_resources" = fetch {
    pname       = "python2-importlib_resources";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-importlib_resources-1.0.2-1-any.pkg.tar.xz"; sha256 = "9d264d409d51b0f51a4080713be11ee9d19f07369801ff5648bd056555cd213e"; }];
    buildInputs = [ python2 python2-typing python2-pathlib2 ];
  };

  "python2-iniconfig" = fetch {
    pname       = "python2-iniconfig";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-iniconfig-1.0.0-2-any.pkg.tar.xz"; sha256 = "657225753e05454ea2ebb2ca40cfe18b95d9a1b2154c20b2da0cb63f15e1c5ee"; }];
    buildInputs = [ python2 ];
  };

  "python2-iocapture" = fetch {
    pname       = "python2-iocapture";
    version     = "0.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-iocapture-0.1.2-1-any.pkg.tar.xz"; sha256 = "15ca1b8f601a92b7a381f88525b6a3d5a8e1d5c03e88febb906cc7ac19efb6ea"; }];
    buildInputs = [ python2 ];
  };

  "python2-ipaddress" = fetch {
    pname       = "python2-ipaddress";
    version     = "1.0.22";
    srcs        = [{ filename = "mingw-w64-i686-python2-ipaddress-1.0.22-1-any.pkg.tar.xz"; sha256 = "9bbbbfcf88c54f36ffb4812f79495ca58ec42af7313c2f1601da8c81dd79e94c"; }];
    buildInputs = [  ];
  };

  "python2-ipykernel" = fetch {
    pname       = "python2-ipykernel";
    version     = "4.9.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-ipykernel-4.9.0-2-any.pkg.tar.xz"; sha256 = "90b661aae214f4fb4e3d7ad7f79a06c082d71384b3b51b92840c9e72b671f7c4"; }];
    buildInputs = [ python2 self."python2-backports.shutil_get_terminal_size" python2-pathlib2 python2-pyzmq python2-ipython ];
  };

  "python2-ipython" = fetch {
    pname       = "python2-ipython";
    version     = "5.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-ipython-5.3.0-8-any.pkg.tar.xz"; sha256 = "89b88488c882a8928e5afeb965b801cacb9efc6954afb26f979b116872dd25fe"; }];
    buildInputs = [ winpty sqlite3 python2-traitlets python2-simplegeneric python2-pickleshare python2-prompt_toolkit self."python2-backports.shutil_get_terminal_size" python2-jedi python2-win_unicode_console ];
  };

  "python2-ipython_genutils" = fetch {
    pname       = "python2-ipython_genutils";
    version     = "0.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-ipython_genutils-0.2.0-2-any.pkg.tar.xz"; sha256 = "f90ea21b174005fe6cbe34cebb6dd9bf39240ed298a798510508fa19b2d0c0a3"; }];
    buildInputs = [ python2 ];
  };

  "python2-ipywidgets" = fetch {
    pname       = "python2-ipywidgets";
    version     = "7.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-ipywidgets-7.4.2-1-any.pkg.tar.xz"; sha256 = "708e7b118b4d88e10fd121e9c98473965766a0583d871ecaca01aa347f286bb1"; }];
    buildInputs = [ python2 ];
  };

  "python2-iso8601" = fetch {
    pname       = "python2-iso8601";
    version     = "0.1.12";
    srcs        = [{ filename = "mingw-w64-i686-python2-iso8601-0.1.12-1-any.pkg.tar.xz"; sha256 = "d237a6158346ed9d7c244f3fe49bbc34a7989b1ed34215cdc99d1ef7aa9f8b67"; }];
    buildInputs = [ python2 ];
  };

  "python2-isort" = fetch {
    pname       = "python2-isort";
    version     = "4.3.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-isort-4.3.4-1-any.pkg.tar.xz"; sha256 = "6719dcfa62c2f878d6d6c30e848c3503ca01949228308e498d4bed24e34d7301"; }];
    buildInputs = [ python2 python2-futures ];
  };

  "python2-jdcal" = fetch {
    pname       = "python2-jdcal";
    version     = "1.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-jdcal-1.4-2-any.pkg.tar.xz"; sha256 = "5cdf2649d0c70bd261b0040090b0a555034a7b62834651dd499718561356e0e5"; }];
    buildInputs = [ python2 ];
  };

  "python2-jedi" = fetch {
    pname       = "python2-jedi";
    version     = "0.13.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-jedi-0.13.1-1-any.pkg.tar.xz"; sha256 = "9833b0baff17f6719e82ce3dcb1db0cb83e37704911e0fe0e00af2e6ad14d799"; }];
    buildInputs = [ python2 python2-parso ];
  };

  "python2-jinja" = fetch {
    pname       = "python2-jinja";
    version     = "2.10";
    srcs        = [{ filename = "mingw-w64-i686-python2-jinja-2.10-2-any.pkg.tar.xz"; sha256 = "84f8966777043b8798f1553271f7b38e1217da88ab510dffb237841de0c6c31b"; }];
    buildInputs = [ python2-setuptools python2-markupsafe ];
  };

  "python2-json-rpc" = fetch {
    pname       = "python2-json-rpc";
    version     = "1.11.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-json-rpc-1.11.1-1-any.pkg.tar.xz"; sha256 = "ff7f4db2027ddc8327fda92b5aa32e9a7d04aef09d1f3510fb1bfc85a3f28ad9"; }];
    buildInputs = [ python2 ];
  };

  "python2-jsonschema" = fetch {
    pname       = "python2-jsonschema";
    version     = "2.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-jsonschema-2.6.0-5-any.pkg.tar.xz"; sha256 = "5ec492141e6012ffa25d51380dfe831289e402a3c8ee4bb3dc620ef614a9faac"; }];
    buildInputs = [ python2 python2-functools32 ];
  };

  "python2-jupyter_client" = fetch {
    pname       = "python2-jupyter_client";
    version     = "5.2.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-jupyter_client-5.2.4-1-any.pkg.tar.xz"; sha256 = "1b8518aca48bd634d32591befc065615b5d3c5346be4f6a989b2574c037f3675"; }];
    buildInputs = [ python2-ipykernel python2-jupyter_core python2-pyzmq ];
  };

  "python2-jupyter_console" = fetch {
    pname       = "python2-jupyter_console";
    version     = "5.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-jupyter_console-5.2.0-3-any.pkg.tar.xz"; sha256 = "f2dd796ebc1d997402174cf7ce3b00d3f34be41bc8c56b077cd8d78c18bd9bb4"; }];
    buildInputs = [ python2 python2-jupyter_core python2-jupyter_client python2-colorama ];
  };

  "python2-jupyter_core" = fetch {
    pname       = "python2-jupyter_core";
    version     = "4.4.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-jupyter_core-4.4.0-3-any.pkg.tar.xz"; sha256 = "52e38ea73860fba620d2389cc06fd4752f40c2e6e22e6fb901fd312d6a9c107b"; }];
    buildInputs = [ python2 ];
  };

  "python2-kiwisolver" = fetch {
    pname       = "python2-kiwisolver";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-kiwisolver-1.0.1-2-any.pkg.tar.xz"; sha256 = "0f5d7c10371d8b8c616eaad781f38eaf00cd9f76b9c2c5ec80fbfc02f0d0b635"; }];
    buildInputs = [ python2 ];
  };

  "python2-lazy-object-proxy" = fetch {
    pname       = "python2-lazy-object-proxy";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-lazy-object-proxy-1.3.1-2-any.pkg.tar.xz"; sha256 = "375cfbb7d56bc36a5f3548dfc11c5b06c0d34a4cca0d3b37819864bd5893784e"; }];
    buildInputs = [ python2 ];
  };

  "python2-ldap" = fetch {
    pname       = "python2-ldap";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-ldap-3.1.0-1-any.pkg.tar.xz"; sha256 = "a3ac3c9e42fbe211d5f176a005277ab1e0011010a2e1f5937a93aed179d48048"; }];
    buildInputs = [ python2 ];
  };

  "python2-ldap3" = fetch {
    pname       = "python2-ldap3";
    version     = "2.5.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-ldap3-2.5.1-1-any.pkg.tar.xz"; sha256 = "eac89d53ada5186f3dc7d673d7f76e697fa1efb40374df09f6274342bb5e50b7"; }];
    buildInputs = [ python2 ];
  };

  "python2-lhafile" = fetch {
    pname       = "python2-lhafile";
    version     = "0.2.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-lhafile-0.2.1-3-any.pkg.tar.xz"; sha256 = "e3ea7ecd3e7ac2a74cf21a6d40482f511160b9d7aa832f3da6b17cb0fdf95073"; }];
    buildInputs = [ python2 python2-six ];
  };

  "python2-linecache2" = fetch {
    pname       = "python2-linecache2";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-linecache2-1.0.0-1-any.pkg.tar.xz"; sha256 = "5221ef5a4c8fa4561c0b7f780c0ce81f16e853945db420f91dcda8ae434e0206"; }];
    buildInputs = [ python2 ];
  };

  "python2-lockfile" = fetch {
    pname       = "python2-lockfile";
    version     = "0.12.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-lockfile-0.12.2-1-any.pkg.tar.xz"; sha256 = "c47fd3405c1e759f2990285d548b4d3ed46d91a22e101034ff395f0a1a4ff450"; }];
    buildInputs = [ python2 ];
  };

  "python2-lxml" = fetch {
    pname       = "python2-lxml";
    version     = "4.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-lxml-4.3.0-1-any.pkg.tar.xz"; sha256 = "5a3cd37e2000317bf3c76424d38d7f8f4be0c5dc06bca9fcfddfdf3e3f6e2e7d"; }];
    buildInputs = [ libxml2 libxslt python2 ];
  };

  "python2-mako" = fetch {
    pname       = "python2-mako";
    version     = "1.0.7";
    srcs        = [{ filename = "mingw-w64-i686-python2-mako-1.0.7-3-any.pkg.tar.xz"; sha256 = "84ddd32a8286ebfa75a76fe478e3d9a3e96db58c63d2a2c023c6d22dd4436a4a"; }];
    buildInputs = [ python2-markupsafe python2-beaker ];
  };

  "python2-markdown" = fetch {
    pname       = "python2-markdown";
    version     = "3.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-markdown-3.0.1-1-any.pkg.tar.xz"; sha256 = "548c014df2fd64306875d282446d905b62a48296306c1dccb6f111e3fab85211"; }];
    buildInputs = [ python2 ];
  };

  "python2-markupsafe" = fetch {
    pname       = "python2-markupsafe";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-markupsafe-1.1.0-1-any.pkg.tar.xz"; sha256 = "7d735add2c58b6ec03e16387b223128935cbe9987610f9d33176ba01d28a7984"; }];
    buildInputs = [ python2 ];
  };

  "python2-matplotlib" = fetch {
    pname       = "python2-matplotlib";
    version     = "2.2.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-matplotlib-2.2.3-4-any.pkg.tar.xz"; sha256 = "c52e8a83490527809c23581a38786a809f932f48b06a16db6d9d6b86224ecfc2"; }];
    buildInputs = [ python2-pytz python2-numpy python2-cairo python2-cycler python2-pyqt5 python2-dateutil python2-pyparsing python2-kiwisolver self."python2-backports.functools_lru_cache" freetype libpng ];
  };

  "python2-mccabe" = fetch {
    pname       = "python2-mccabe";
    version     = "0.6.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-mccabe-0.6.1-1-any.pkg.tar.xz"; sha256 = "b55ae72cda562aa39be29e1c3a62ebef6ff32a6c1d00ad99a7f2a66194c73e9e"; }];
    buildInputs = [ python2 ];
  };

  "python2-mimeparse" = fetch {
    pname       = "python2-mimeparse";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-mimeparse-1.6.0-1-any.pkg.tar.xz"; sha256 = "fc4da6e908fe81f7a88711c69b2b60589568c683125f934d9b2077e5d6994398"; }];
    buildInputs = [ python2 ];
  };

  "python2-mistune" = fetch {
    pname       = "python2-mistune";
    version     = "0.8.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-mistune-0.8.4-1-any.pkg.tar.xz"; sha256 = "7296d4f2df19996b9893f75f4dad781a45d647763ba00dcba7a5c94321036f54"; }];
    buildInputs = [ python2 ];
  };

  "python2-mock" = fetch {
    pname       = "python2-mock";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-mock-2.0.0-3-any.pkg.tar.xz"; sha256 = "83f46f2e9e57fb2c962bef61317fd69751c6539c87f71a4cf0ffece4204db5c2"; }];
    buildInputs = [ python2 python2-six python3-pbr ];
  };

  "python2-monotonic" = fetch {
    pname       = "python2-monotonic";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-monotonic-1.5-1-any.pkg.tar.xz"; sha256 = "da21e9dcc103e16d81c4e2d31a1ad33a530c0dc08962345139d104cbe3658b3c"; }];
    buildInputs = [ python2 ];
  };

  "python2-more-itertools" = fetch {
    pname       = "python2-more-itertools";
    version     = "4.3.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-more-itertools-4.3.1-1-any.pkg.tar.xz"; sha256 = "c4ba9a584edd7e6b073aea83b54cc9e332d71a02dd0080a6f34fd709066490e7"; }];
    buildInputs = [ python2 python2-six ];
  };

  "python2-mox3" = fetch {
    pname       = "python2-mox3";
    version     = "0.26.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-mox3-0.26.0-1-any.pkg.tar.xz"; sha256 = "9913d1635908c7287de6255a7faa91ede1cc8b733c15c575d48423b2b8f1eb6d"; }];
    buildInputs = [ python2 python2-pbr python2-fixtures ];
  };

  "python2-mpmath" = fetch {
    pname       = "python2-mpmath";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-mpmath-1.1.0-1-any.pkg.tar.xz"; sha256 = "a6c7976e602da22131b91a93730b4b8f20eb7903568728b452eb46caeb65c951"; }];
    buildInputs = [ python2 python2-gmpy2 ];
  };

  "python2-msgpack" = fetch {
    pname       = "python2-msgpack";
    version     = "0.5.6";
    srcs        = [{ filename = "mingw-w64-i686-python2-msgpack-0.5.6-1-any.pkg.tar.xz"; sha256 = "2d37e5e615c6166004ad4842961b3ed353a835195ec265ad60fa6e3fcb038926"; }];
    buildInputs = [ python2 ];
  };

  "python2-mysql" = fetch {
    pname       = "python2-mysql";
    version     = "1.2.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-mysql-1.2.5-2-any.pkg.tar.xz"; sha256 = "c51bbc4c42884baf51c8337190c25a1ac1d41adb116df7a9bcb394fd652e18eb"; }];
    buildInputs = [ python2 libmariadbclient ];
  };

  "python2-ndg-httpsclient" = fetch {
    pname       = "python2-ndg-httpsclient";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-ndg-httpsclient-0.5.1-1-any.pkg.tar.xz"; sha256 = "630c521003a9cfe6e58ab66a7836c4e575633dad636b347073982be2026a0850"; }];
    buildInputs = [ python2-pyopenssl python2-pyasn1 ];
  };

  "python2-netaddr" = fetch {
    pname       = "python2-netaddr";
    version     = "0.7.19";
    srcs        = [{ filename = "mingw-w64-i686-python2-netaddr-0.7.19-1-any.pkg.tar.xz"; sha256 = "1c40440b16976a58ed60bb6566f45372ea204f56bea07c61e3b136a81eb5067c"; }];
    buildInputs = [ python2 ];
  };

  "python2-netifaces" = fetch {
    pname       = "python2-netifaces";
    version     = "0.10.9";
    srcs        = [{ filename = "mingw-w64-i686-python2-netifaces-0.10.9-1-any.pkg.tar.xz"; sha256 = "f0b0f859cb1a3b6c6c4d4e314039428825a2991be02a8aa42035a7eee8df1e48"; }];
    buildInputs = [ python2 ];
  };

  "python2-networkx" = fetch {
    pname       = "python2-networkx";
    version     = "2.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-networkx-2.2-1-any.pkg.tar.xz"; sha256 = "0937a47228914fa3403ee9bac26e1ea80d7cf16ebe0f8c4535d94a99bb28513f"; }];
    buildInputs = [ python2 python2-decorator ];
  };

  "python2-nose" = fetch {
    pname       = "python2-nose";
    version     = "1.3.7";
    srcs        = [{ filename = "mingw-w64-i686-python2-nose-1.3.7-8-any.pkg.tar.xz"; sha256 = "4b50ff5a58375972914fc6d44b610d2b255971aebd9bb7fd609e9c0d82d17706"; }];
    buildInputs = [ python2-setuptools ];
  };

  "python2-nuitka" = fetch {
    pname       = "python2-nuitka";
    version     = "0.6.0.6";
    srcs        = [{ filename = "mingw-w64-i686-python2-nuitka-0.6.0.6-1-any.pkg.tar.xz"; sha256 = "987fb4b78d54c380ab98841f23e6d5a8abd07f6d03ab7f99f1e7029f73cab6b9"; }];
    buildInputs = [ python2-setuptools ];
  };

  "python2-numexpr" = fetch {
    pname       = "python2-numexpr";
    version     = "2.6.9";
    srcs        = [{ filename = "mingw-w64-i686-python2-numexpr-2.6.9-1-any.pkg.tar.xz"; sha256 = "819c9d03a7ece5522f89426a2d8bd95cc77341b81cef8e1a7971e35c485567e7"; }];
    buildInputs = [ python2-numpy ];
  };

  "python2-numpy" = fetch {
    pname       = "python2-numpy";
    version     = "1.15.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-numpy-1.15.4-1-any.pkg.tar.xz"; sha256 = "53a3eb2f8b9cbf37b524822076850ab565c36659319d2ea003f6ce612d3ebf45"; }];
    buildInputs = [ openblas python2 ];
  };

  "python2-olefile" = fetch {
    pname       = "python2-olefile";
    version     = "0.46";
    srcs        = [{ filename = "mingw-w64-i686-python2-olefile-0.46-1-any.pkg.tar.xz"; sha256 = "316c8bec887442e07216682eb3d378fcc4686f795321f4a385fd753dd4b75e7a"; }];
    buildInputs = [ python2 ];
  };

  "python2-openmdao" = fetch {
    pname       = "python2-openmdao";
    version     = "2.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-openmdao-2.5.0-1-any.pkg.tar.xz"; sha256 = "4e83dc3c8714c90dab583548149688c0d279e348f5ef0fddd3a34debcd122fad"; }];
    buildInputs = [ python2-numpy python2-scipy python2-networkx python2-sqlitedict python2-pyparsing python2-six ];
  };

  "python2-openpyxl" = fetch {
    pname       = "python2-openpyxl";
    version     = "2.5.12";
    srcs        = [{ filename = "mingw-w64-i686-python2-openpyxl-2.5.12-1-any.pkg.tar.xz"; sha256 = "fde3d160533f07a477bad46bd16c1fe6c575fa41c8f67ad359aa483785e0d0af"; }];
    buildInputs = [ python2-jdcal python2-et-xmlfile ];
  };

  "python2-oslo-concurrency" = fetch {
    pname       = "python2-oslo-concurrency";
    version     = "3.29.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-oslo-concurrency-3.29.0-1-any.pkg.tar.xz"; sha256 = "73e00af6d4cf0ceddc34d7971d9dd77fa5c2fc076057604b8cd4381e521d7377"; }];
    buildInputs = [ python2 python2-six python2-pbr python2-oslo-config python2-oslo-i18n python2-oslo-utils python2-fasteners python2-enum34 ];
  };

  "python2-oslo-config" = fetch {
    pname       = "python2-oslo-config";
    version     = "6.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-oslo-config-6.7.0-1-any.pkg.tar.xz"; sha256 = "9dff48de279abac9aa58d0568014ecc6edb980ce4b6c19f7f4965327da4f97d8"; }];
    buildInputs = [ python2 python2-six python2-netaddr python2-stevedore python2-debtcollector python2-oslo-i18n python2-rfc3986 python2-yaml python2-enum34 ];
  };

  "python2-oslo-context" = fetch {
    pname       = "python2-oslo-context";
    version     = "2.22.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-oslo-context-2.22.0-1-any.pkg.tar.xz"; sha256 = "07b656467629efd082865e979ded36864a9414e42fdccc08893c0af39dd94f5a"; }];
    buildInputs = [ python2 python2-pbr python2-debtcollector ];
  };

  "python2-oslo-db" = fetch {
    pname       = "python2-oslo-db";
    version     = "4.42.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-oslo-db-4.42.0-1-any.pkg.tar.xz"; sha256 = "eeaae1fc03e54dda7c4dc9ffac0e4472ad543b973ca9523a07e137888df20722"; }];
    buildInputs = [ python2 python2-six python2-pbr python2-alembic python2-debtcollector python2-oslo-i18n python2-oslo-config python2-oslo-utils python2-sqlalchemy python2-sqlalchemy-migrate python2-stevedore ];
  };

  "python2-oslo-i18n" = fetch {
    pname       = "python2-oslo-i18n";
    version     = "3.23.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-oslo-i18n-3.23.0-1-any.pkg.tar.xz"; sha256 = "e4266a0c229533ba59ace0f3916476c502cbcf01b179a27dc780c1daf7ac7687"; }];
    buildInputs = [ python2 python2-six python2-pbr python2-babel ];
  };

  "python2-oslo-log" = fetch {
    pname       = "python2-oslo-log";
    version     = "3.42.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-oslo-log-3.42.1-1-any.pkg.tar.xz"; sha256 = "148a23d17d546df1b242c242e2d5ace47608a345e022ce610077efa39cae643d"; }];
    buildInputs = [ python2 python2-six python2-pbr python2-oslo-config python2-oslo-context python2-oslo-i18n python2-oslo-utils python2-oslo-serialization python2-debtcollector python2-dateutil python2-monotonic ];
  };

  "python2-oslo-serialization" = fetch {
    pname       = "python2-oslo-serialization";
    version     = "2.28.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-oslo-serialization-2.28.1-1-any.pkg.tar.xz"; sha256 = "b2afc295b7e2d45818a26face843c8737d0236d7a844372a3fb61b0ab9a30315"; }];
    buildInputs = [ python2 python2-six python2-pbr python2-babel python2-msgpack python2-oslo-utils python2-pytz ];
  };

  "python2-oslo-utils" = fetch {
    pname       = "python2-oslo-utils";
    version     = "3.39.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-oslo-utils-3.39.0-1-any.pkg.tar.xz"; sha256 = "30c06267a818f3d96bf71dc442042ac090c4b6a314c887aed8aa7abbe081cd5b"; }];
    buildInputs = [ python2 ];
  };

  "python2-oslosphinx" = fetch {
    pname       = "python2-oslosphinx";
    version     = "4.18.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-oslosphinx-4.18.0-1-any.pkg.tar.xz"; sha256 = "59d01586eb7a7d40857fc907f3060f3bebcddef4c9ee5bf7bae555cf624ee502"; }];
    buildInputs = [ python2 python2-six python2-requests ];
  };

  "python2-oslotest" = fetch {
    pname       = "python2-oslotest";
    version     = "3.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-oslotest-3.7.0-1-any.pkg.tar.xz"; sha256 = "cc2ac14bef9368a22e65b026f47308f05d3bc099f6b346a1aa5f9627199147e5"; }];
    buildInputs = [ python2 ];
  };

  "python2-packaging" = fetch {
    pname       = "python2-packaging";
    version     = "18.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-packaging-18.0-1-any.pkg.tar.xz"; sha256 = "0a7588578158ace5b7889ca1a03346c5e69d342e2438dac39697230401bc1f5a"; }];
    buildInputs = [ python2 python2-pyparsing python2-six ];
  };

  "python2-pandas" = fetch {
    pname       = "python2-pandas";
    version     = "0.23.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-pandas-0.23.4-1-any.pkg.tar.xz"; sha256 = "1426b4df047d97bb4a4db6cd7353d7e722bab527c9534b301705259930b6ac7b"; }];
    buildInputs = [ python2-numpy python2-pytz python2-dateutil python2-setuptools ];
  };

  "python2-pandocfilters" = fetch {
    pname       = "python2-pandocfilters";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pandocfilters-1.4.2-2-any.pkg.tar.xz"; sha256 = "f8cf955226c8f5d9a78e2c62d3d40ee8c615f7bc7b4b48e1ed1864b7111834e9"; }];
    buildInputs = [ python2 ];
  };

  "python2-paramiko" = fetch {
    pname       = "python2-paramiko";
    version     = "2.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-paramiko-2.4.2-1-any.pkg.tar.xz"; sha256 = "9e7149c5cf5a1c8fc2abee557d83b694aa2da8c1cdab417bc41f8624889936ba"; }];
    buildInputs = [ python2 ];
  };

  "python2-parso" = fetch {
    pname       = "python2-parso";
    version     = "0.3.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-parso-0.3.1-1-any.pkg.tar.xz"; sha256 = "acf6c15038a0f34515aeb149254ad4410af33aef4508197540a52c8048ec5685"; }];
    buildInputs = [ python2 ];
  };

  "python2-path" = fetch {
    pname       = "python2-path";
    version     = "11.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-path-11.5.0-1-any.pkg.tar.xz"; sha256 = "064e047ff3071031c72f491f71ce4033351d5acf6664d59080539f648da6eb8d"; }];
    buildInputs = [ python2 python2-importlib-metadata self."python2-backports.os" ];
  };

  "python2-pathlib" = fetch {
    pname       = "python2-pathlib";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-pathlib-1.0.1-1-any.pkg.tar.xz"; sha256 = "016e06b23e76871f4774ffdd64c12876f4588872bf2fe1e8b14f760113397455"; }];
    buildInputs = [ python2 ];
  };

  "python2-pathlib2" = fetch {
    pname       = "python2-pathlib2";
    version     = "2.3.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-pathlib2-2.3.3-1-any.pkg.tar.xz"; sha256 = "ef9480b29b586e1a08a59673637687146daa9c983d7686be05ae9c1db17256aa"; }];
    buildInputs = [ python2 python2-scandir ];
  };

  "python2-pathtools" = fetch {
    pname       = "python2-pathtools";
    version     = "0.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pathtools-0.1.2-1-any.pkg.tar.xz"; sha256 = "919cf5e4a39bea7c3b7549a1b3af1b6bada5dcd97c467764d3118c0bfc585e6e"; }];
    buildInputs = [ python2 ];
  };

  "python2-patsy" = fetch {
    pname       = "python2-patsy";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-patsy-0.5.1-1-any.pkg.tar.xz"; sha256 = "73f80c3e76918e7ca14045dd05e58355fbc5c8cda6c19f3d953b96a2bffb2b0e"; }];
    buildInputs = [ python2-numpy ];
  };

  "python2-pbr" = fetch {
    pname       = "python2-pbr";
    version     = "5.1.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-pbr-5.1.1-2-any.pkg.tar.xz"; sha256 = "d5085804b2b41bcf08f273a3dfb27c30f5d7af36672724578ae2b43cdc0c1681"; }];
    buildInputs = [ python2-setuptools ];
  };

  "python2-pdfrw" = fetch {
    pname       = "python2-pdfrw";
    version     = "0.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-pdfrw-0.4-2-any.pkg.tar.xz"; sha256 = "dd279293250a36e1c4750cdd322b2915b9598891dcef4b515f9345d16b62079a"; }];
    buildInputs = [ python2 ];
  };

  "python2-pep517" = fetch {
    pname       = "python2-pep517";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pep517-0.5.0-1-any.pkg.tar.xz"; sha256 = "fccf593e21a35f11b7a7e5b42ddba6c28ae124b1b27ce410cfc59442705dc626"; }];
    buildInputs = [ python2 ];
  };

  "python2-pexpect" = fetch {
    pname       = "python2-pexpect";
    version     = "4.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pexpect-4.6.0-1-any.pkg.tar.xz"; sha256 = "39ca391527291debe812f5a44c3e3564bb63d4632d618bcca2d130c39aa5b940"; }];
    buildInputs = [ python2 python2-ptyprocess ];
  };

  "python2-pgen2" = fetch {
    pname       = "python2-pgen2";
    version     = "0.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pgen2-0.1.0-3-any.pkg.tar.xz"; sha256 = "5eaf492b782e3f75cecf4fbb25f6d84d6baf161fd1d6583e159c055aab16d215"; }];
    buildInputs = [ python2 ];
  };

  "python2-pickleshare" = fetch {
    pname       = "python2-pickleshare";
    version     = "0.7.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-pickleshare-0.7.5-1-any.pkg.tar.xz"; sha256 = "d7cdb971e759ccdddaef7a0496585ebd02feb929bdfb79c013066d54c3ffda35"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2-path.version "8.1"; python2-path) ];
  };

  "python2-pillow" = fetch {
    pname       = "python2-pillow";
    version     = "5.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pillow-5.3.0-1-any.pkg.tar.xz"; sha256 = "9758525c46dfc0e8cefbf149b43f3d97995b7a39bfe159d475a42058cedefe8b"; }];
    buildInputs = [ freetype lcms2 libjpeg libtiff libwebp openjpeg2 zlib python2 python2-olefile ];
  };

  "python2-pip" = fetch {
    pname       = "python2-pip";
    version     = "18.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-pip-18.1-2-any.pkg.tar.xz"; sha256 = "a780289f0cc9a2ccaa2796e0631dd25950a76cd27c4660951d54ba94ec41aef2"; }];
    buildInputs = [ python2-setuptools python2-appdirs python2-cachecontrol python2-colorama python2-distlib python2-html5lib python2-lockfile python2-msgpack python2-packaging python2-pep517 python2-progress python2-pyparsing python2-pytoml python2-requests python2-retrying python2-six python2-webencodings python2-ipaddress ];
  };

  "python2-pkginfo" = fetch {
    pname       = "python2-pkginfo";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pkginfo-1.4.2-1-any.pkg.tar.xz"; sha256 = "7187d05c74d83346260065f49e46b11036822d5f062d8acb8b8ec8744fb81508"; }];
    buildInputs = [ python2 ];
  };

  "python2-pluggy" = fetch {
    pname       = "python2-pluggy";
    version     = "0.8.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pluggy-0.8.0-2-any.pkg.tar.xz"; sha256 = "f4f1d454b81867028329e6238d310be232be42dc82cd38ca147cbf5303872bdd"; }];
    buildInputs = [ python2 ];
  };

  "python2-ply" = fetch {
    pname       = "python2-ply";
    version     = "3.11";
    srcs        = [{ filename = "mingw-w64-i686-python2-ply-3.11-2-any.pkg.tar.xz"; sha256 = "ae48074b6868a2632b1de8dce857c33b3042f8fa7565cfeea639d66505e0eb82"; }];
    buildInputs = [ python2 ];
  };

  "python2-pptx" = fetch {
    pname       = "python2-pptx";
    version     = "0.6.10";
    srcs        = [{ filename = "mingw-w64-i686-python2-pptx-0.6.10-1-any.pkg.tar.xz"; sha256 = "27bd2ee5f7af6483752822d2003df9e0dda777974c9a5aaf044df40bd490d125"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2-lxml.version "3.1.0"; python2-lxml) (assert stdenvNoCC.lib.versionAtLeast python2-pillow.version "2.6.1"; python2-pillow) (assert stdenvNoCC.lib.versionAtLeast python2-xlsxwriter.version "0.5.7"; python2-xlsxwriter) ];
  };

  "python2-pretend" = fetch {
    pname       = "python2-pretend";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-i686-python2-pretend-1.0.9-2-any.pkg.tar.xz"; sha256 = "cc1b2f2d72a9948164304e826613ea43537e349c3b73661aee88e78e40264c05"; }];
    buildInputs = [ python2 ];
  };

  "python2-prettytable" = fetch {
    pname       = "python2-prettytable";
    version     = "0.7.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-prettytable-0.7.2-2-any.pkg.tar.xz"; sha256 = "ad2ff63160d977b6c4b44a5bb4d52d8bc3fe8229602b522b831a9fe51bbc92bf"; }];
    buildInputs = [ python2 ];
  };

  "python2-progress" = fetch {
    pname       = "python2-progress";
    version     = "1.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-progress-1.4-3-any.pkg.tar.xz"; sha256 = "9b4a9780cef59df8a02ca95df41ecda56fc97e8ec7cd23dc86ccef13300ba641"; }];
    buildInputs = [ python2 ];
  };

  "python2-prometheus-client" = fetch {
    pname       = "python2-prometheus-client";
    version     = "0.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-prometheus-client-0.2.0-1-any.pkg.tar.xz"; sha256 = "0a14f4aaea47310aee4c8c5586fb8e5f24488a32bf92489b0d5ca2aaa3f3cf4a"; }];
    buildInputs = [ python2 ];
  };

  "python2-prompt_toolkit" = fetch {
    pname       = "python2-prompt_toolkit";
    version     = "1.0.15";
    srcs        = [{ filename = "mingw-w64-i686-python2-prompt_toolkit-1.0.15-2-any.pkg.tar.xz"; sha256 = "ba410090294512c008f24f00422269cf02dafb0242458d3c58d1dd0eab3d5794"; }];
    buildInputs = [ python2-pygments python2-six python2-wcwidth ];
  };

  "python2-psutil" = fetch {
    pname       = "python2-psutil";
    version     = "5.4.8";
    srcs        = [{ filename = "mingw-w64-i686-python2-psutil-5.4.8-1-any.pkg.tar.xz"; sha256 = "5b52cb81856f7f57b74031e1fd9945d2c03a933ce59cd9072a0716ae657e0deb"; }];
    buildInputs = [ python2 ];
  };

  "python2-psycopg2" = fetch {
    pname       = "python2-psycopg2";
    version     = "2.7.6.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-psycopg2-2.7.6.1-1-any.pkg.tar.xz"; sha256 = "dac3963dfdb6a21ae47596a1403d18236fe00bc7725158abe05b08f74d5af2d3"; }];
    buildInputs = [ python2 ];
  };

  "python2-ptyprocess" = fetch {
    pname       = "python2-ptyprocess";
    version     = "0.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-ptyprocess-0.6.0-1-any.pkg.tar.xz"; sha256 = "15dd6a77c56662b50f8738f93cf9b0b2f6183abb634739fde65df13fc01afd1d"; }];
    buildInputs = [ python2 ];
  };

  "python2-py" = fetch {
    pname       = "python2-py";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-py-1.7.0-1-any.pkg.tar.xz"; sha256 = "1abb9250e660879daad3ae67e25fd4d65e095deaa30316a5799dbe2147af7e6b"; }];
    buildInputs = [ python2 ];
  };

  "python2-py-cpuinfo" = fetch {
    pname       = "python2-py-cpuinfo";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-py-cpuinfo-4.0.0-1-any.pkg.tar.xz"; sha256 = "5ffc82901d3a9cb06d1e2fce16663ae97560c4ffc093181167a3f3904b7bb7e1"; }];
    buildInputs = [ python2 ];
  };

  "python2-pyamg" = fetch {
    pname       = "python2-pyamg";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyamg-4.0.0-1-any.pkg.tar.xz"; sha256 = "64c1e5eab1262944fc44594c20ebc41fb42fa20ede200c6db662c4331e1ec6f3"; }];
    buildInputs = [ python2 python2-scipy python2-numpy ];
  };

  "python2-pyasn1" = fetch {
    pname       = "python2-pyasn1";
    version     = "0.4.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyasn1-0.4.4-1-any.pkg.tar.xz"; sha256 = "b48849fde5f1bf631e0e7659b110e8c0948001d9a220eea57b7bb09076e6b325"; }];
    buildInputs = [  ];
  };

  "python2-pyasn1-modules" = fetch {
    pname       = "python2-pyasn1-modules";
    version     = "0.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyasn1-modules-0.2.2-1-any.pkg.tar.xz"; sha256 = "09901dc9e52d8de759c6abaa24c362c6b4b9f7c952f67c02942474a9ba505c41"; }];
  };

  "python2-pycodestyle" = fetch {
    pname       = "python2-pycodestyle";
    version     = "2.4.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pycodestyle-2.4.0-1-any.pkg.tar.xz"; sha256 = "b5d828756f92c34b45f10a90fa04bd40f41aca5e65d88e01ae5984ea0c670c64"; }];
    buildInputs = [ python2 ];
  };

  "python2-pycparser" = fetch {
    pname       = "python2-pycparser";
    version     = "2.19";
    srcs        = [{ filename = "mingw-w64-i686-python2-pycparser-2.19-1-any.pkg.tar.xz"; sha256 = "27c20c49f1b5fd2d205b65278765a3b708b55410fb36c372940d5327a3e2c1a3"; }];
    buildInputs = [ python2 python2-ply ];
  };

  "python2-pyflakes" = fetch {
    pname       = "python2-pyflakes";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyflakes-2.0.0-2-any.pkg.tar.xz"; sha256 = "eafb0cb19c3ff51c7ee0bb45dbe526fa9ce090d6d4616198fc2cab1030788887"; }];
    buildInputs = [ python2 ];
  };

  "python2-pyglet" = fetch {
    pname       = "python2-pyglet";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyglet-1.3.2-1-any.pkg.tar.xz"; sha256 = "4b708b8cc4ad01088b7622b5eb982894a6ad96c2739d1be50cbf86381f31f031"; }];
    buildInputs = [ python2 python2-future ];
  };

  "python2-pygments" = fetch {
    pname       = "python2-pygments";
    version     = "2.3.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-pygments-2.3.1-1-any.pkg.tar.xz"; sha256 = "bc01c01bca431952c29bab666b70b6c7650989fdd1501396c9d057a022f44bf5"; }];
    buildInputs = [ python2-setuptools ];
  };

  "python2-pygtk" = fetch {
    pname       = "python2-pygtk";
    version     = "2.24.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pygtk-2.24.0-6-any.pkg.tar.xz"; sha256 = "106e457d50b2c9f58c8f04a9bd59161503fbc2752a739ccf1d212d25f168fbf9"; }];
    buildInputs = [ python2-cairo python2-gobject2 libglade ];
  };

  "python2-pylint" = fetch {
    pname       = "python2-pylint";
    version     = "1.9.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pylint-1.9.2-1-any.pkg.tar.xz"; sha256 = "267429f1ffff502b901f3864fc99ce77a357c6fb146f88065d3dd9716d91ce96"; }];
    buildInputs = [ python2-astroid self."python2-backports.functools_lru_cache" python2-colorama python2-configparser python2-isort python2-mccabe python2-setuptools python2-singledispatch python2-six ];
  };

  "python2-pynacl" = fetch {
    pname       = "python2-pynacl";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pynacl-1.3.0-1-any.pkg.tar.xz"; sha256 = "c935f0be523b524394e603507f61c776fcb637209bc7eca93a32277040ecabe8"; }];
    buildInputs = [ python2 ];
  };

  "python2-pyopenssl" = fetch {
    pname       = "python2-pyopenssl";
    version     = "18.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyopenssl-18.0.0-3-any.pkg.tar.xz"; sha256 = "eb3d418a5aef5860933f4c7be289e33cc041496fcb5af6eb3a28bbd227a7fced"; }];
    buildInputs = [ openssl python2-cryptography python2-six ];
  };

  "python2-pyparsing" = fetch {
    pname       = "python2-pyparsing";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyparsing-2.3.0-1-any.pkg.tar.xz"; sha256 = "101cdd7b3045d4615bdbe64890f09ddfc14c5d419f96c6580e1fd916dbb0e877"; }];
    buildInputs = [ python2 ];
  };

  "python2-pyperclip" = fetch {
    pname       = "python2-pyperclip";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyperclip-1.7.0-1-any.pkg.tar.xz"; sha256 = "58a351120f2435a95a02fc7bf17a93a49f1b07dd6b2e387b2f9ff307044acc89"; }];
    buildInputs = [ python2 ];
  };

  "python2-pyqt4" = fetch {
    pname       = "python2-pyqt4";
    version     = "4.11.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyqt4-4.11.4-2-any.pkg.tar.xz"; sha256 = "87875e3f098780798799e532a338378d5eb8912d8e8786fb99a0c4417c177f73"; }];
    buildInputs = [ python2-sip pyqt4-common python2 ];
  };

  "python2-pyqt5" = fetch {
    pname       = "python2-pyqt5";
    version     = "5.11.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyqt5-5.11.3-1-any.pkg.tar.xz"; sha256 = "4ee81f6a604b30c3e7725fa12f6403f2192796e0770a775da3b1a5d0d34add9f"; }];
    buildInputs = [ python2-sip pyqt5-common python2 ];
  };

  "python2-pyreadline" = fetch {
    pname       = "python2-pyreadline";
    version     = "2.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyreadline-2.1-1-any.pkg.tar.xz"; sha256 = "b6c4d3312e5b4fb6a82920eb0ab47b55804b3c2fa747570b0a906bdf4afcb58a"; }];
    buildInputs = [ python2 ];
  };

  "python2-pyrsistent" = fetch {
    pname       = "python2-pyrsistent";
    version     = "0.14.9";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyrsistent-0.14.9-1-any.pkg.tar.xz"; sha256 = "37cd00cceb70fa4d7e2b185ca53006cc868a01417630389c960a57e4e13609c2"; }];
    buildInputs = [ python2 python2-six ];
  };

  "python2-pyserial" = fetch {
    pname       = "python2-pyserial";
    version     = "3.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyserial-3.4-1-any.pkg.tar.xz"; sha256 = "c2c4e6b1f95911916a76ef36bb193a9524553113dc1842a7176e6aee3883a263"; }];
    buildInputs = [ python2 ];
  };

  "python2-pyside-qt4" = fetch {
    pname       = "python2-pyside-qt4";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyside-qt4-1.2.2-3-any.pkg.tar.xz"; sha256 = "4c9b988ec2ffc56a75b3b6433aab0d9280e98e03ac57c0c534347ce3131d0c77"; }];
    buildInputs = [ pyside-common-qt4 python2 python2-shiboken-qt4 qt4 ];
  };

  "python2-pyside-tools-qt4" = fetch {
    pname       = "python2-pyside-tools-qt4";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyside-tools-qt4-1.2.2-3-any.pkg.tar.xz"; sha256 = "f9cc15b2d6e994a373c32d502b14101820b5e1129780ce46db08fc57f3ffb7aa"; }];
    buildInputs = [ pyside-tools-common-qt4 python2-pyside-qt4 ];
  };

  "python2-pysocks" = fetch {
    pname       = "python2-pysocks";
    version     = "1.6.8";
    srcs        = [{ filename = "mingw-w64-i686-python2-pysocks-1.6.8-1-any.pkg.tar.xz"; sha256 = "7f1a2ae89684106e7c8e681591289709d1ab4cea3e5e0d9841dc8d518853cb64"; }];
    buildInputs = [ python2 python2-win_inet_pton ];
  };

  "python2-pystemmer" = fetch {
    pname       = "python2-pystemmer";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pystemmer-1.3.0-2-any.pkg.tar.xz"; sha256 = "fdf41c81bf67d6e00252c713f38a2c650414f8b021411ce88bed32b66f83cdd7"; }];
    buildInputs = [ python2 ];
  };

  "python2-pytest" = fetch {
    pname       = "python2-pytest";
    version     = "4.0.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pytest-4.0.2-1-any.pkg.tar.xz"; sha256 = "0794a22867684a579686dc592f7a07a72dbe1beda0168085ebf510262a1076b5"; }];
    buildInputs = [ python2-py python2-pluggy python2-setuptools python2-colorama python2-funcsigs python2-six python2-atomicwrites python2-more-itertools python2-pathlib2 python2-attrs ];
  };

  "python2-pytest-benchmark" = fetch {
    pname       = "python2-pytest-benchmark";
    version     = "3.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pytest-benchmark-3.2.0-1-any.pkg.tar.xz"; sha256 = "4c71bad3c5b84bab53bbfa2b387d569058792a5153014e7f9affd9f07afab9c7"; }];
    buildInputs = [ python2 python2-py-cpuinfo python2-statistics python2-pathlib python2-pytest ];
  };

  "python2-pytest-cov" = fetch {
    pname       = "python2-pytest-cov";
    version     = "2.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pytest-cov-2.6.0-1-any.pkg.tar.xz"; sha256 = "e00b197de095e6cece3aaf9759eaeedbe34b187a3605a1ff642ac8eb876e7907"; }];
    buildInputs = [ python2 python2-coverage python2-pytest ];
  };

  "python2-pytest-expect" = fetch {
    pname       = "python2-pytest-expect";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pytest-expect-1.1.0-1-any.pkg.tar.xz"; sha256 = "37487cdecf09a9822d5b68f6fbddd452f8fffaddfe37f1c3d663d68fbe14cf6b"; }];
    buildInputs = [ python2 python2-pytest python2-u-msgpack ];
  };

  "python2-pytest-forked" = fetch {
    pname       = "python2-pytest-forked";
    version     = "0.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pytest-forked-0.2-1-any.pkg.tar.xz"; sha256 = "f36f8c09fc1c116a5b726a85d7513627a0a8ffa5cb7df7468213a6dc60e742a5"; }];
    buildInputs = [ python2 python2-pytest ];
  };

  "python2-pytest-runner" = fetch {
    pname       = "python2-pytest-runner";
    version     = "4.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pytest-runner-4.2-4-any.pkg.tar.xz"; sha256 = "fdd007ca4c33cf75b74ddc2ea002792669c10a0ad2353d32d320acb298fd643f"; }];
    buildInputs = [ python2 python2-pytest ];
  };

  "python2-pytest-xdist" = fetch {
    pname       = "python2-pytest-xdist";
    version     = "1.25.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-pytest-xdist-1.25.0-1-any.pkg.tar.xz"; sha256 = "c9e6ef93525b3414ff29920226da5e31e390ca527416b172aab6a8a54406ba84"; }];
    buildInputs = [ python2 python2-pytest-forked python2-execnet ];
  };

  "python2-python_ics" = fetch {
    pname       = "python2-python_ics";
    version     = "2.15";
    srcs        = [{ filename = "mingw-w64-i686-python2-python_ics-2.15-1-any.pkg.tar.xz"; sha256 = "5f82c9fec06c90615091343559d4c2c6a6cdec21f5d695b1e1da77037c80ac49"; }];
    buildInputs = [ python2 ];
  };

  "python2-pytoml" = fetch {
    pname       = "python2-pytoml";
    version     = "0.1.20";
    srcs        = [{ filename = "mingw-w64-i686-python2-pytoml-0.1.20-1-any.pkg.tar.xz"; sha256 = "551890fada3523d7b373fd2f923bb21483e767a1d048235b03f363cb6ad99083"; }];
    buildInputs = [ python2 ];
  };

  "python2-pytz" = fetch {
    pname       = "python2-pytz";
    version     = "2018.9";
    srcs        = [{ filename = "mingw-w64-i686-python2-pytz-2018.9-1-any.pkg.tar.xz"; sha256 = "e11aeea74884bea2c64ddcbf82ac2d64a7c0fd3d26d938c7c3cf756761a32314"; }];
    buildInputs = [ python2 ];
  };

  "python2-pyu2f" = fetch {
    pname       = "python2-pyu2f";
    version     = "0.1.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyu2f-0.1.4-1-any.pkg.tar.xz"; sha256 = "b4da2ea0862df9bfb8091460b0bb8c7e087815d5b8ba20210d920d399ed1d87c"; }];
    buildInputs = [ python2 ];
  };

  "python2-pywavelets" = fetch {
    pname       = "python2-pywavelets";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-pywavelets-1.0.1-1-any.pkg.tar.xz"; sha256 = "3438304d17423c5739219dfe9d3ee79302b1bf51dcd9030fb45081b837d6d3a5"; }];
    buildInputs = [ python2-numpy python2 ];
  };

  "python2-pyzmq" = fetch {
    pname       = "python2-pyzmq";
    version     = "17.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyzmq-17.1.2-1-any.pkg.tar.xz"; sha256 = "35fca5832fca6205b0772ae7e0fc82d8fd9ad4dd938fe6d769d696eec234cf69"; }];
    buildInputs = [ python2 zeromq ];
  };

  "python2-pyzopfli" = fetch {
    pname       = "python2-pyzopfli";
    version     = "0.1.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-pyzopfli-0.1.4-1-any.pkg.tar.xz"; sha256 = "1744736036080904781b2c7cab075d7e4a50cfd804de6f0316106eb117411305"; }];
    buildInputs = [ python2 ];
  };

  "python2-qscintilla" = fetch {
    pname       = "python2-qscintilla";
    version     = "2.10.8";
    srcs        = [{ filename = "mingw-w64-i686-python2-qscintilla-2.10.8-1-any.pkg.tar.xz"; sha256 = "25ba7ded5de519b8ba6b0f9b9f560856821a83c30ef8fd4874aa14ca4ef7a19d"; }];
    buildInputs = [ python-qscintilla-common python2-pyqt5 ];
  };

  "python2-qtconsole" = fetch {
    pname       = "python2-qtconsole";
    version     = "4.4.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-qtconsole-4.4.1-1-any.pkg.tar.xz"; sha256 = "d1066c9ab1fb42eaacfc76b8df9a8440a03645128209c76f77104ea5d2c5d32f"; }];
    buildInputs = [ python2 python2-jupyter_core python2-jupyter_client python2-pyqt5 ];
  };

  "python2-rencode" = fetch {
    pname       = "python2-rencode";
    version     = "1.0.6";
    srcs        = [{ filename = "mingw-w64-i686-python2-rencode-1.0.6-1-any.pkg.tar.xz"; sha256 = "605d90046343fe43be1025f5ca03afdc90fcfd24be8c3d8bd8c19594319f7e19"; }];
    buildInputs = [ python2 ];
  };

  "python2-reportlab" = fetch {
    pname       = "python2-reportlab";
    version     = "3.5.12";
    srcs        = [{ filename = "mingw-w64-i686-python2-reportlab-3.5.12-1-any.pkg.tar.xz"; sha256 = "c066e7d86121df9223a4f19874f622a0fd3707ffc5bf8a6d2f2404b79720f23f"; }];
    buildInputs = [ freetype python2-pip python2-Pillow ];
    broken      = true; # broken dependency python2-reportlab -> python2-Pillow
  };

  "python2-requests" = fetch {
    pname       = "python2-requests";
    version     = "2.21.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-requests-2.21.0-1-any.pkg.tar.xz"; sha256 = "148144e07d07b5bc09ab8f2f9053c3a2509901e7710c6c16df1739e14b96634e"; }];
    buildInputs = [ python2-urllib3 python2-chardet python2-idna ];
  };

  "python2-requests-kerberos" = fetch {
    pname       = "python2-requests-kerberos";
    version     = "0.12.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-requests-kerberos-0.12.0-1-any.pkg.tar.xz"; sha256 = "e759e788d783a4a8ba997417997959beb9af46adfa1afa1f610ff9520e652a2c"; }];
    buildInputs = [ python2 python2-cryptography python2-winkerberos ];
  };

  "python2-retrying" = fetch {
    pname       = "python2-retrying";
    version     = "1.3.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-retrying-1.3.3-1-any.pkg.tar.xz"; sha256 = "dca23f4b8ec39013e6ad74d37cd645c472264f836169a8d285f1def498382fc8"; }];
    buildInputs = [ python2 ];
  };

  "python2-rfc3986" = fetch {
    pname       = "python2-rfc3986";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-rfc3986-1.2.0-1-any.pkg.tar.xz"; sha256 = "380cf7d151b4191e5308c5f17cc82fb0aca6ee81508e535ad69f338d6cac408d"; }];
    buildInputs = [ python2 ];
  };

  "python2-rfc3987" = fetch {
    pname       = "python2-rfc3987";
    version     = "1.3.8";
    srcs        = [{ filename = "mingw-w64-i686-python2-rfc3987-1.3.8-1-any.pkg.tar.xz"; sha256 = "bb5aa8ae6517167b036c32ec1dc28c239e547b3b36fab5120b9cbcaacff0d121"; }];
    buildInputs = [ python2 ];
  };

  "python2-rst2pdf" = fetch {
    pname       = "python2-rst2pdf";
    version     = "0.93";
    srcs        = [{ filename = "mingw-w64-i686-python2-rst2pdf-0.93-4-any.pkg.tar.xz"; sha256 = "bbb2c93e522fbb555321f95a599d7a83691ad703e38d79ab3f66c77f31e781c6"; }];
    buildInputs = [ python2 python2-docutils python2-pdfrw python2-pygments (assert stdenvNoCC.lib.versionAtLeast python2-reportlab.version "2.4"; python2-reportlab) python2-setuptools ];
    broken      = true; # broken dependency python2-reportlab -> python2-Pillow
  };

  "python2-scandir" = fetch {
    pname       = "python2-scandir";
    version     = "1.9.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-scandir-1.9.0-1-any.pkg.tar.xz"; sha256 = "9681d21c9a54f60434bd377a3ea2c265be76a356513cbdd5f212d771765f267a"; }];
    buildInputs = [ python2 ];
  };

  "python2-scikit-learn" = fetch {
    pname       = "python2-scikit-learn";
    version     = "0.20.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-scikit-learn-0.20.2-1-any.pkg.tar.xz"; sha256 = "3da74b84e1aac652a883c9d60437e80c126bc0eb2721481d5f0524ecfd72e528"; }];
    buildInputs = [ python2 python2-scipy ];
  };

  "python2-scipy" = fetch {
    pname       = "python2-scipy";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-scipy-1.2.0-1-any.pkg.tar.xz"; sha256 = "ca2a75d55823cdef037ff37906a5c3f5d30a89f4ece4e77397b0dfda5f56db53"; }];
    buildInputs = [ gcc-libgfortran openblas python2-numpy ];
  };

  "python2-send2trash" = fetch {
    pname       = "python2-send2trash";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-send2trash-1.5.0-2-any.pkg.tar.xz"; sha256 = "1e081efdc4fbb20e52d227d8cf66372442be098df941514893e41b92271bfcd6"; }];
    buildInputs = [ python2 ];
  };

  "python2-setproctitle" = fetch {
    pname       = "python2-setproctitle";
    version     = "1.1.10";
    srcs        = [{ filename = "mingw-w64-i686-python2-setproctitle-1.1.10-1-any.pkg.tar.xz"; sha256 = "2c4b45403fbcf431b1a31697f678acd6047b82430206319ce418fa71cea7c321"; }];
    buildInputs = [ python2 ];
  };

  "python2-setuptools" = fetch {
    pname       = "python2-setuptools";
    version     = "40.6.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-setuptools-40.6.3-1-any.pkg.tar.xz"; sha256 = "f9a466c5d23db411cf5f8313bb8e400f517d1c6c20247916f0d7096c2425e5d3"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2.version "2.7"; python2) python2-packaging python2-pyparsing python2-appdirs python2-six ];
  };

  "python2-setuptools-git" = fetch {
    pname       = "python2-setuptools-git";
    version     = "1.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-setuptools-git-1.2-1-any.pkg.tar.xz"; sha256 = "fc9fc8db647c22a4d7ebc8ab05953235936bb5c8eaa21e74dfd1da841e357a6b"; }];
    buildInputs = [ python2 python2-setuptools git ];
    broken      = true; # broken dependency python2-setuptools-git -> git
  };

  "python2-setuptools-scm" = fetch {
    pname       = "python2-setuptools-scm";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-setuptools-scm-3.1.0-1-any.pkg.tar.xz"; sha256 = "d94674efa17be5577930013b6b0f06ed6e77e1a3c6a459b6d9a40a5aaa749e42"; }];
    buildInputs = [ python2-setuptools ];
  };

  "python2-shiboken-qt4" = fetch {
    pname       = "python2-shiboken-qt4";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-shiboken-qt4-1.2.2-3-any.pkg.tar.xz"; sha256 = "cf0663489d3b9bb409dbde62f2c511b365f09deafdc48f4b0ef2c69a19027237"; }];
    buildInputs = [ libxml2 libxslt python2 shiboken-qt4 qt4 ];
  };

  "python2-simplegeneric" = fetch {
    pname       = "python2-simplegeneric";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-simplegeneric-0.8.1-4-any.pkg.tar.xz"; sha256 = "e96b232e25e78fbe293ceab98f7544c0dd95f7fcb11c4dea2a41b649c6f0c9d7"; }];
    buildInputs = [ python2 ];
  };

  "python2-singledispatch" = fetch {
    pname       = "python2-singledispatch";
    version     = "3.4.0.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-singledispatch-3.4.0.3-1-any.pkg.tar.xz"; sha256 = "de54c2fc5bacdb6365b378f6f31d6e0408c6e64c1673768ed7db2670a53bac8f"; }];
    buildInputs = [ python2 ];
  };

  "python2-sip" = fetch {
    pname       = "python2-sip";
    version     = "4.19.13";
    srcs        = [{ filename = "mingw-w64-i686-python2-sip-4.19.13-2-any.pkg.tar.xz"; sha256 = "3e5b40e1cccae4ef7d1df1104e148f57246b23b367e834d3a7a70377abfee166"; }];
    buildInputs = [ sip python2 ];
  };

  "python2-six" = fetch {
    pname       = "python2-six";
    version     = "1.12.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-six-1.12.0-1-any.pkg.tar.xz"; sha256 = "2bfe47bbe83669a150b8c74bb057cd40da127bedc148a23bff3c4b68c52b3b3f"; }];
    buildInputs = [ python2 ];
  };

  "python2-snowballstemmer" = fetch {
    pname       = "python2-snowballstemmer";
    version     = "1.2.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-snowballstemmer-1.2.1-3-any.pkg.tar.xz"; sha256 = "8adfd067fe1b95920885ac1ff8d13afa554cab118ef85bd8e74080082fa79bac"; }];
    buildInputs = [ python2 ];
  };

  "python2-soupsieve" = fetch {
    pname       = "python2-soupsieve";
    version     = "1.6.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-soupsieve-1.6.2-1-any.pkg.tar.xz"; sha256 = "405bed0c05c77ab1772ae5a5b763068865178e3437b2a7696b39c7e4b59e0d08"; }];
    buildInputs = [ python2 self."python2-backports.functools_lru_cache" ];
  };

  "python2-sphinx" = fetch {
    pname       = "python2-sphinx";
    version     = "1.8.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-sphinx-1.8.3-1-any.pkg.tar.xz"; sha256 = "807a89378fe64bd975f3ff4a42a823be9318fe6753460c3f94641af5f6a1b8af"; }];
    buildInputs = [ python2-babel python2-certifi python2-colorama python2-chardet python2-docutils python2-idna python2-imagesize python2-jinja python2-packaging python2-pygments python2-requests python2-sphinx_rtd_theme python2-snowballstemmer python2-sphinx-alabaster-theme python2-sphinxcontrib-websupport python2-six python2-sqlalchemy python2-urllib3 python2-whoosh python2-typing ];
  };

  "python2-sphinx-alabaster-theme" = fetch {
    pname       = "python2-sphinx-alabaster-theme";
    version     = "0.7.11";
    srcs        = [{ filename = "mingw-w64-i686-python2-sphinx-alabaster-theme-0.7.11-1-any.pkg.tar.xz"; sha256 = "53b99c8823146b947e32a0124ee88db25c95ff1a37d4646236d000921865b55e"; }];
    buildInputs = [ python2 ];
  };

  "python2-sphinx_rtd_theme" = fetch {
    pname       = "python2-sphinx_rtd_theme";
    version     = "0.4.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-sphinx_rtd_theme-0.4.1-1-any.pkg.tar.xz"; sha256 = "6099e4203d80713714344acd4e6414214b97ea6632292d6ab218326234767056"; }];
    buildInputs = [ python2 ];
  };

  "python2-sphinxcontrib-websupport" = fetch {
    pname       = "python2-sphinxcontrib-websupport";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-sphinxcontrib-websupport-1.1.0-2-any.pkg.tar.xz"; sha256 = "f4d169dd375b14cf1a5ef9cbbd137a0acf33118de3ae56df20cc90ec496b728c"; }];
    buildInputs = [ python2 ];
  };

  "python2-sqlalchemy" = fetch {
    pname       = "python2-sqlalchemy";
    version     = "1.2.15";
    srcs        = [{ filename = "mingw-w64-i686-python2-sqlalchemy-1.2.15-1-any.pkg.tar.xz"; sha256 = "c5ffc03f41f35b7a8d1101d1dc1dc380849fdcfebec88c795b2766092840e874"; }];
    buildInputs = [ python2 ];
  };

  "python2-sqlalchemy-migrate" = fetch {
    pname       = "python2-sqlalchemy-migrate";
    version     = "0.11.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-sqlalchemy-migrate-0.11.0-1-any.pkg.tar.xz"; sha256 = "9bb3b9f3d8cdde082745e5b9722a49c4d5b466f89fcae665c561b00a62330ee2"; }];
    buildInputs = [ python2 python2-six python2-pbr python2-sqlalchemy python2-decorator python2-sqlparse python2-tempita ];
  };

  "python2-sqlitedict" = fetch {
    pname       = "python2-sqlitedict";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-sqlitedict-1.6.0-1-any.pkg.tar.xz"; sha256 = "0317a3f8704693d667e345b0b26a10718f42ee98151c55549c1dfbdefc0093aa"; }];
    buildInputs = [ python2 sqlite3 ];
  };

  "python2-sqlparse" = fetch {
    pname       = "python2-sqlparse";
    version     = "0.2.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-sqlparse-0.2.4-1-any.pkg.tar.xz"; sha256 = "21f127702fa8cf27671199ee22bc1dbfcbcd3c2bdec53f70f171b6dc36ff8da1"; }];
    buildInputs = [ python2 ];
  };

  "python2-statistics" = fetch {
    pname       = "python2-statistics";
    version     = "1.0.3.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-statistics-1.0.3.5-1-any.pkg.tar.xz"; sha256 = "fc8fec64aaaa7191816be2676b7a552c9462e1b8626a7aae3c4a0634d89b4eaa"; }];
    buildInputs = [ python2-docutils ];
  };

  "python2-statsmodels" = fetch {
    pname       = "python2-statsmodels";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-statsmodels-0.9.0-1-any.pkg.tar.xz"; sha256 = "4a2ab0e6b0d87a63d83433470095c0711cadf4c220b5053a0fc9d6f82f3449f4"; }];
    buildInputs = [ python2-scipy python2-pandas python2-patsy ];
  };

  "python2-stestr" = fetch {
    pname       = "python2-stestr";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-stestr-2.2.0-1-any.pkg.tar.xz"; sha256 = "7965fe53fdbe1d0f5ff494dcc05d8d0c92e5f9cd5d8bce00096a5f966fa5049f"; }];
    buildInputs = [ python2 python2-cliff python2-fixtures python2-future python2-pbr python2-six python2-subunit python2-testtools python2-voluptuous python2-yaml ];
  };

  "python2-stevedore" = fetch {
    pname       = "python2-stevedore";
    version     = "1.30.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-stevedore-1.30.0-1-any.pkg.tar.xz"; sha256 = "4fe0f56d79cac36acfaecfd0587db20552bedd0a82166232c92363da545de2a4"; }];
    buildInputs = [ python2 python2-six ];
  };

  "python2-strict-rfc3339" = fetch {
    pname       = "python2-strict-rfc3339";
    version     = "0.7";
    srcs        = [{ filename = "mingw-w64-i686-python2-strict-rfc3339-0.7-1-any.pkg.tar.xz"; sha256 = "b68de6f68d1b4224d856ee8978ba326eec3afb3671895165c3fe4ac5768380e1"; }];
    buildInputs = [ python2 ];
  };

  "python2-subprocess32" = fetch {
    pname       = "python2-subprocess32";
    version     = "3.5.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-subprocess32-3.5.3-1-any.pkg.tar.xz"; sha256 = "d633d6bd692c20ce565fb96065eb5df0c41f2aabbe482edb109bab7e7e4fb158"; }];
    buildInputs = [ python2 ];
  };

  "python2-subunit" = fetch {
    pname       = "python2-subunit";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-subunit-1.3.0-2-any.pkg.tar.xz"; sha256 = "eec71f050a7e42100831e8fde0ede2b3fe080dc26ca76deb62263aec2a3f612a"; }];
    buildInputs = [ python2 python2-extras python2-testtools ];
  };

  "python2-sympy" = fetch {
    pname       = "python2-sympy";
    version     = "1.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-sympy-1.3-1-any.pkg.tar.xz"; sha256 = "891347a785f8d21eeb5865ebac6fc4a62d9093499e7b00790148a486c65595a3"; }];
    buildInputs = [ python2 python2-mpmath ];
  };

  "python2-tempita" = fetch {
    pname       = "python2-tempita";
    version     = "0.5.3dev20170202";
    srcs        = [{ filename = "mingw-w64-i686-python2-tempita-0.5.3dev20170202-1-any.pkg.tar.xz"; sha256 = "629a4740b837992b3a4605ba5c9c0cdd90ea32e78d36913ef790b475aec7c254"; }];
    buildInputs = [ python2 ];
  };

  "python2-terminado" = fetch {
    pname       = "python2-terminado";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-terminado-0.8.1-2-any.pkg.tar.xz"; sha256 = "805aae56fd2e456e1d31a436a1a98bddef5a91443f5615a8051f91acf6dbd68b"; }];
    buildInputs = [ python2 python2-tornado python2-ptyprocess ];
  };

  "python2-testrepository" = fetch {
    pname       = "python2-testrepository";
    version     = "0.0.20";
    srcs        = [{ filename = "mingw-w64-i686-python2-testrepository-0.0.20-1-any.pkg.tar.xz"; sha256 = "f322a041f1e9b3d38bec284aeae1647084bfb590620a843a628761cdfbbd5040"; }];
    buildInputs = [ python2 ];
  };

  "python2-testresources" = fetch {
    pname       = "python2-testresources";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-testresources-2.0.1-1-any.pkg.tar.xz"; sha256 = "fa426d050f7ccc287aeee5c17b6a5a50ae4b011676cab9cef9aaeb0301f6357c"; }];
    buildInputs = [ python2 ];
  };

  "python2-testscenarios" = fetch {
    pname       = "python2-testscenarios";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-testscenarios-0.5.0-1-any.pkg.tar.xz"; sha256 = "692340d8f42598d252ee204c123cc2ff1ab0d7d47f808e7e587e01d133f637d5"; }];
    buildInputs = [ python2 ];
  };

  "python2-testtools" = fetch {
    pname       = "python2-testtools";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-testtools-2.3.0-1-any.pkg.tar.xz"; sha256 = "d200a3dc1a4c504b90a857bb78d9724f78cb8f075c63683e0625990e9603a488"; }];
    buildInputs = [ python2 python2-pbr python2-extras python2-fixtures python2-pyrsistent python2-mimeparse python2-unittest2 python2-traceback2 ];
  };

  "python2-text-unidecode" = fetch {
    pname       = "python2-text-unidecode";
    version     = "1.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-text-unidecode-1.2-1-any.pkg.tar.xz"; sha256 = "d6de404ff3a5c7ec22c20a0638a2c76c5573ae639590656aa9764a35891cc531"; }];
    buildInputs = [ python2 ];
  };

  "python2-toml" = fetch {
    pname       = "python2-toml";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-toml-0.10.0-1-any.pkg.tar.xz"; sha256 = "3a3d3e0d5acb3a1f52b934104b7d8e318bd969124171cb3582950784717cdb89"; }];
    buildInputs = [ python2 ];
  };

  "python2-tornado" = fetch {
    pname       = "python2-tornado";
    version     = "5.1.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-tornado-5.1.1-2-any.pkg.tar.xz"; sha256 = "1dd7b2fe1015f87ae6822462b4f4e9c06f453d2a72e0ea253e7249c46e9130d2"; }];
    buildInputs = [ python2 python2-futures python2-backports-abc python2-setuptools python2-singledispatch ];
  };

  "python2-tox" = fetch {
    pname       = "python2-tox";
    version     = "3.6.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-tox-3.6.1-1-any.pkg.tar.xz"; sha256 = "ebc6e8d07b8ddc423dd6dbffaed784306310063dfe30c51f05a169495f336546"; }];
    buildInputs = [ python2 python2-py python2-six python2-virtualenv python2-setuptools python2-setuptools-scm python2-filelock python2-toml python2-pluggy ];
  };

  "python2-traceback2" = fetch {
    pname       = "python2-traceback2";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-traceback2-1.4.0-4-any.pkg.tar.xz"; sha256 = "0b59cbbd644bba8108bf12b71fbeabf72c81311e547c53b997d714d8dc8cf891"; }];
    buildInputs = [ python2-linecache2 python2-six ];
  };

  "python2-traitlets" = fetch {
    pname       = "python2-traitlets";
    version     = "4.3.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-traitlets-4.3.2-3-any.pkg.tar.xz"; sha256 = "412baeab18350a53cac6fc5e393f8757544df345da247b44790e3dbf2e22d7ce"; }];
    buildInputs = [ python2-ipython_genutils python2-decorator ];
  };

  "python2-typing" = fetch {
    pname       = "python2-typing";
    version     = "3.6.6";
    srcs        = [{ filename = "mingw-w64-i686-python2-typing-3.6.6-1-any.pkg.tar.xz"; sha256 = "affa1afb9056ed191595df2beb897e3648dc959926e4fcd1ee350e628302c505"; }];
    buildInputs = [ python2 ];
  };

  "python2-u-msgpack" = fetch {
    pname       = "python2-u-msgpack";
    version     = "2.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-u-msgpack-2.5.0-1-any.pkg.tar.xz"; sha256 = "eb55be0205b784b9cf3f2565ed4bd03376e4544e10f325d48fb88f18528e5150"; }];
    buildInputs = [ python2 ];
  };

  "python2-ukpostcodeparser" = fetch {
    pname       = "python2-ukpostcodeparser";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-ukpostcodeparser-1.1.2-1-any.pkg.tar.xz"; sha256 = "4d59005c0de47cfca862fc88dabd95eb0795a400c901f0672dc46cb1058511fa"; }];
    buildInputs = [ python2 ];
  };

  "python2-unicodecsv" = fetch {
    pname       = "python2-unicodecsv";
    version     = "0.14.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-unicodecsv-0.14.1-3-any.pkg.tar.xz"; sha256 = "9de206cdafaab622c577b58328c2e28cf5b488b5f97a5f2b2bf5b904b77e82e7"; }];
    buildInputs = [ python2 ];
  };

  "python2-unicodedata2" = fetch {
    pname       = "python2-unicodedata2";
    version     = "11.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-unicodedata2-11.0.0-1-any.pkg.tar.xz"; sha256 = "6f2ac2e573f95533899b4749a8931525542d07ec75c43f65dd92e1e95c0bea6c"; }];
    buildInputs = [ python2 ];
  };

  "python2-unicorn" = fetch {
    pname       = "python2-unicorn";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-unicorn-1.0.1-3-any.pkg.tar.xz"; sha256 = "92d738a4f6e78493f13856e90a25e204c11f208df2a05ef4c1cd297e7345258b"; }];
    buildInputs = [ python2 unicorn ];
  };

  "python2-unittest2" = fetch {
    pname       = "python2-unittest2";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-unittest2-1.1.0-1-any.pkg.tar.xz"; sha256 = "35713530b23b704af2c8f2a31e6839f6bc4c7341620b2227355280f0d38d492b"; }];
    buildInputs = [ python2-six python2-traceback2 ];
  };

  "python2-urllib3" = fetch {
    pname       = "python2-urllib3";
    version     = "1.24.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-urllib3-1.24.1-1-any.pkg.tar.xz"; sha256 = "3b35aac203392ba71ee6386e805862e5ca7e20444bb24aff5cea95332dcd9609"; }];
    buildInputs = [ python2 python2-certifi python2-idna ];
  };

  "python2-virtualenv" = fetch {
    pname       = "python2-virtualenv";
    version     = "16.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-virtualenv-16.0.0-1-any.pkg.tar.xz"; sha256 = "eaee1a4ee7a169f3729e104e828f756a05aff8967395156a2b42236f9a8b3c92"; }];
    buildInputs = [ python2 ];
  };

  "python2-voluptuous" = fetch {
    pname       = "python2-voluptuous";
    version     = "0.11.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-voluptuous-0.11.5-1-any.pkg.tar.xz"; sha256 = "d74c1e0bad72c58bbd4c2b9d66fa5730ad34907697b1ed9aa53729c876db7d64"; }];
    buildInputs = [ python2 ];
  };

  "python2-watchdog" = fetch {
    pname       = "python2-watchdog";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-watchdog-0.9.0-1-any.pkg.tar.xz"; sha256 = "7fca6ec3ae2dd22d8c6b21522837639916b733adb79efcd44d6aca94c4b94906"; }];
    buildInputs = [ python2 ];
  };

  "python2-wcwidth" = fetch {
    pname       = "python2-wcwidth";
    version     = "0.1.7";
    srcs        = [{ filename = "mingw-w64-i686-python2-wcwidth-0.1.7-3-any.pkg.tar.xz"; sha256 = "889407be07cc19c9d4900a1e64ef3296a2475142336a6cbe5b43accaa1b1565e"; }];
    buildInputs = [ python2 ];
  };

  "python2-webcolors" = fetch {
    pname       = "python2-webcolors";
    version     = "1.8.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-webcolors-1.8.1-1-any.pkg.tar.xz"; sha256 = "27d1ae99db6d4577a7f3cad3360963788dff9311f8aded624bc56713fdc79b4e"; }];
    buildInputs = [ python2 ];
  };

  "python2-webencodings" = fetch {
    pname       = "python2-webencodings";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-webencodings-0.5.1-3-any.pkg.tar.xz"; sha256 = "c4fef35a761edea17748f792f16917f1d152a28129dbbc9c36ec1455ce457630"; }];
    buildInputs = [ python2 ];
  };

  "python2-websocket-client" = fetch {
    pname       = "python2-websocket-client";
    version     = "0.54.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-websocket-client-0.54.0-2-any.pkg.tar.xz"; sha256 = "93e935cf6879a3c63edfd5f7d7c06e4e70a550aa31acf970a7f5a6014251cc7a"; }];
    buildInputs = [ python2 python2-six self."python2-backports.ssl_match_hostname" ];
  };

  "python2-wheel" = fetch {
    pname       = "python2-wheel";
    version     = "0.32.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-wheel-0.32.3-1-any.pkg.tar.xz"; sha256 = "7536628be2effc519f7594407df5f671856ecd8f8fdee93210184827d5a0dd9e"; }];
    buildInputs = [ python2 ];
  };

  "python2-whoosh" = fetch {
    pname       = "python2-whoosh";
    version     = "2.7.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-whoosh-2.7.4-2-any.pkg.tar.xz"; sha256 = "eaf321a58d91fabd4db8087b676793742ff4fb143d4c1e8dcd530948cfa65a1c"; }];
    buildInputs = [ python2 ];
  };

  "python2-win_inet_pton" = fetch {
    pname       = "python2-win_inet_pton";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python2-win_inet_pton-1.0.1-1-any.pkg.tar.xz"; sha256 = "dc0829edfdf29df8c60a4b999b247934ac578f97435de7306e2961b1823e9da4"; }];
    buildInputs = [ python2 ];
  };

  "python2-win_unicode_console" = fetch {
    pname       = "python2-win_unicode_console";
    version     = "0.5";
    srcs        = [{ filename = "mingw-w64-i686-python2-win_unicode_console-0.5-3-any.pkg.tar.xz"; sha256 = "7f0a5a60826d6aa2f8537ea11557607531d896a94510ed5919968d4f222eac10"; }];
    buildInputs = [ python2 ];
  };

  "python2-wincertstore" = fetch {
    pname       = "python2-wincertstore";
    version     = "0.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-wincertstore-0.2-1-any.pkg.tar.xz"; sha256 = "5d6e04aff12bba53ee81c35999410a626e2ba0cb2603c5cdf672993841e0d7a8"; }];
    buildInputs = [ python2 ];
  };

  "python2-winkerberos" = fetch {
    pname       = "python2-winkerberos";
    version     = "0.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-winkerberos-0.7.0-1-any.pkg.tar.xz"; sha256 = "03f6a2838f7b1962d9c19c41e7b196e0481190a72c9a29f1232468216e05a902"; }];
    buildInputs = [ python2 ];
  };

  "python2-wrapt" = fetch {
    pname       = "python2-wrapt";
    version     = "1.10.11";
    srcs        = [{ filename = "mingw-w64-i686-python2-wrapt-1.10.11-3-any.pkg.tar.xz"; sha256 = "226cd6d267af917434d6b060bc9822bcafd17fe862a29de3fd0bd3d7c66daf23"; }];
    buildInputs = [ python2 ];
  };

  "python2-xdg" = fetch {
    pname       = "python2-xdg";
    version     = "0.26";
    srcs        = [{ filename = "mingw-w64-i686-python2-xdg-0.26-2-any.pkg.tar.xz"; sha256 = "3500151c3af008275b74227fd36964fee06d1893def920974c0d6ee3755ca13f"; }];
    buildInputs = [ python2 ];
  };

  "python2-xlrd" = fetch {
    pname       = "python2-xlrd";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-xlrd-1.2.0-1-any.pkg.tar.xz"; sha256 = "4756481d86dbfa554ee1da52c15799931e8318b7426e2fbb7c1c15ea4d29e309"; }];
    buildInputs = [ python2 ];
  };

  "python2-xlsxwriter" = fetch {
    pname       = "python2-xlsxwriter";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python2-xlsxwriter-1.1.2-1-any.pkg.tar.xz"; sha256 = "21536e69e7dec6f10579aa018834f8d1e8039910e12e43a585b0e8f48dcc4091"; }];
    buildInputs = [ python2 ];
  };

  "python2-xlwt" = fetch {
    pname       = "python2-xlwt";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-xlwt-1.3.0-1-any.pkg.tar.xz"; sha256 = "9a8a25ae010090efa1f7fcffea0f3180ca186fcd896337e5178c2f63b18d39c0"; }];
    buildInputs = [ python2 ];
  };

  "python2-yaml" = fetch {
    pname       = "python2-yaml";
    version     = "3.13";
    srcs        = [{ filename = "mingw-w64-i686-python2-yaml-3.13-1-any.pkg.tar.xz"; sha256 = "990e84acf5df379b82095ea5953e853ebf854570fb40ab752e3421e3bbe57776"; }];
    buildInputs = [ python2 libyaml ];
  };

  "python2-zeroconf" = fetch {
    pname       = "python2-zeroconf";
    version     = "0.21.3";
    srcs        = [{ filename = "mingw-w64-i686-python2-zeroconf-0.21.3-2-any.pkg.tar.xz"; sha256 = "b920e3fe8d2dd6cc90e05ee56d01eca7e1aa587f8dfbccc859b6eb7ea696ff93"; }];
    buildInputs = [ python2 python2-ifaddr python2-typing ];
  };

  "python2-zope.event" = fetch {
    pname       = "python2-zope.event";
    version     = "4.4";
    srcs        = [{ filename = "mingw-w64-i686-python2-zope.event-4.4-1-any.pkg.tar.xz"; sha256 = "00eca8190a4335ae123e839aaac9cda5e3c2090c4621e01b2f1d7e5e05dea3e9"; }];
  };

  "python2-zope.interface" = fetch {
    pname       = "python2-zope.interface";
    version     = "4.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python2-zope.interface-4.6.0-1-any.pkg.tar.xz"; sha256 = "3135b069f8666e4cb1a5c82e49651ac63ff816e407001017ebc160b595af7a73"; }];
  };

  "python3" = fetch {
    pname       = "python3";
    version     = "3.7.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-3.7.2-1-any.pkg.tar.xz"; sha256 = "11ef5305ec2fc6a9b0b10a11a6bddc24a6d3dd15f9f7ac06917648a0245fc1bf"; }];
    buildInputs = [ gcc-libs expat bzip2 libffi mpdecimal ncurses openssl tcl tk zlib xz sqlite3 ];
  };

  "python3-PyOpenGL" = fetch {
    pname       = "python3-PyOpenGL";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-PyOpenGL-3.1.0-1-any.pkg.tar.xz"; sha256 = "029913b53d617753e381a90abbdd3d55fd9c92f1c08c8d248a9bccfd7a55a8e8"; }];
    buildInputs = [ python3 ];
  };

  "python3-alembic" = fetch {
    pname       = "python3-alembic";
    version     = "1.0.5";
    srcs        = [{ filename = "mingw-w64-i686-python3-alembic-1.0.5-1-any.pkg.tar.xz"; sha256 = "f19a4303853b8354a0544630d045d39b260c906cefeaed80b0f95e33d476498d"; }];
    buildInputs = [ python3 python3-mako python3-sqlalchemy python3-editor python3-dateutil ];
  };

  "python3-apipkg" = fetch {
    pname       = "python3-apipkg";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-i686-python3-apipkg-1.5-1-any.pkg.tar.xz"; sha256 = "76ab7692706df88218858215221aab76695da9c4853c066af2a6a1909ce627b4"; }];
    buildInputs = [ python3 ];
  };

  "python3-appdirs" = fetch {
    pname       = "python3-appdirs";
    version     = "1.4.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-appdirs-1.4.3-3-any.pkg.tar.xz"; sha256 = "9c8358e68311efae9e8a593166c6f015c766dbd2a5a9de1e2c520a5eb807411c"; }];
    buildInputs = [ python3 ];
  };

  "python3-argh" = fetch {
    pname       = "python3-argh";
    version     = "0.26.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-argh-0.26.2-1-any.pkg.tar.xz"; sha256 = "4ea034ba5543bf2dc6018b7dcc4bd8cb46aa642aa099a0f3ba0c2bfdf5dc7501"; }];
    buildInputs = [ python3 ];
  };

  "python3-argon2_cffi" = fetch {
    pname       = "python3-argon2_cffi";
    version     = "18.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-argon2_cffi-18.3.0-1-any.pkg.tar.xz"; sha256 = "df36a73d6cbef026dd2cf1711182e56ca90ac06358784d8ddf76a2dc88acc27b"; }];
    buildInputs = [ python3 python3-cffi python3-setuptools python3-six ];
  };

  "python3-asn1crypto" = fetch {
    pname       = "python3-asn1crypto";
    version     = "0.24.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-asn1crypto-0.24.0-2-any.pkg.tar.xz"; sha256 = "95dcbf2186bbc708a967fd30d5d662e1cd08b0d4a299f5b49262ef082bf991e8"; }];
    buildInputs = [ python3-pycparser ];
  };

  "python3-astroid" = fetch {
    pname       = "python3-astroid";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-astroid-2.1.0-1-any.pkg.tar.xz"; sha256 = "16555b694211590c964d401d55ea2cd0b691f370a9ed34f6e8f890bcb5680620"; }];
    buildInputs = [ python3-six python3-lazy-object-proxy python3-wrapt ];
  };

  "python3-atomicwrites" = fetch {
    pname       = "python3-atomicwrites";
    version     = "1.2.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-atomicwrites-1.2.1-1-any.pkg.tar.xz"; sha256 = "cb11ae0c4bded4e7469a3380fbeee6df8b436afc89f1803862d144a9681759a1"; }];
    buildInputs = [ python3 ];
  };

  "python3-attrs" = fetch {
    pname       = "python3-attrs";
    version     = "18.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-attrs-18.2.0-1-any.pkg.tar.xz"; sha256 = "402b26500106fba2940e4cc8a05b6c1fb2c8d8cf783724cde864fa496d014d76"; }];
    buildInputs = [ python3 ];
  };

  "python3-babel" = fetch {
    pname       = "python3-babel";
    version     = "2.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-babel-2.6.0-3-any.pkg.tar.xz"; sha256 = "2195e13a64a5547f3f2d89ed512d0190e34ab9cde0618b7b54a4811943236599"; }];
    buildInputs = [ python3-pytz ];
  };

  "python3-backcall" = fetch {
    pname       = "python3-backcall";
    version     = "0.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-backcall-0.1.0-2-any.pkg.tar.xz"; sha256 = "2429fec7c823da964d8f5b0f3589cf0c52f6e354a6030200f7acef63aeb0a0ad"; }];
    buildInputs = [ python3 ];
  };

  "python3-bcrypt" = fetch {
    pname       = "python3-bcrypt";
    version     = "3.1.5";
    srcs        = [{ filename = "mingw-w64-i686-python3-bcrypt-3.1.5-1-any.pkg.tar.xz"; sha256 = "b7d134d83d6ccd52b402acf013289eda5c508e47c8dfc2fad882c936ea09d483"; }];
    buildInputs = [ python3 ];
  };

  "python3-beaker" = fetch {
    pname       = "python3-beaker";
    version     = "1.10.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-beaker-1.10.0-2-any.pkg.tar.xz"; sha256 = "6c52e0a46d01e9cd1a70a849b6f8a127c0a6ab1b66df9a194306e03404137acc"; }];
    buildInputs = [ python3 ];
  };

  "python3-beautifulsoup4" = fetch {
    pname       = "python3-beautifulsoup4";
    version     = "4.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-beautifulsoup4-4.7.0-1-any.pkg.tar.xz"; sha256 = "1c0467fab79f94032cd9519c97c1139bba7ea3a2b09a87073c155b4dd5a94a5f"; }];
    buildInputs = [ python3 python3-soupsieve ];
  };

  "python3-binwalk" = fetch {
    pname       = "python3-binwalk";
    version     = "2.1.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-binwalk-2.1.1-2-any.pkg.tar.xz"; sha256 = "94743278072e615e0e43e639420a2c39fc511b9989df73ad4e3e6276015cd2ce"; }];
    buildInputs = [ bzip2 libsystre xz zlib ];
  };

  "python3-biopython" = fetch {
    pname       = "python3-biopython";
    version     = "1.73";
    srcs        = [{ filename = "mingw-w64-i686-python3-biopython-1.73-1-any.pkg.tar.xz"; sha256 = "20581c1aaab5162bb9fe26847f12e02fbff6cedbfa59d025537296922eb3c373"; }];
    buildInputs = [ python3-numpy ];
  };

  "python3-bleach" = fetch {
    pname       = "python3-bleach";
    version     = "3.0.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-bleach-3.0.2-1-any.pkg.tar.xz"; sha256 = "3b429fe164bb8a1761b65764046b28e469b82c814b14128582afac0b21310313"; }];
    buildInputs = [ python3 python3-html5lib ];
  };

  "python3-breathe" = fetch {
    pname       = "python3-breathe";
    version     = "4.11.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-breathe-4.11.1-1-any.pkg.tar.xz"; sha256 = "ee4f7a2a63bc0c5f8e90629f16689ce826c03111c26f36ecbb30d25039a836ba"; }];
    buildInputs = [ python3 ];
  };

  "python3-brotli" = fetch {
    pname       = "python3-brotli";
    version     = "1.0.7";
    srcs        = [{ filename = "mingw-w64-i686-python3-brotli-1.0.7-1-any.pkg.tar.xz"; sha256 = "d131e5864819cf9c32e2b321b0c6d0e35121899715439e2ca19ce358037bd0e0"; }];
    buildInputs = [ python3 libwinpthread-git ];
  };

  "python3-bsddb3" = fetch {
    pname       = "python3-bsddb3";
    version     = "6.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-bsddb3-6.1.0-3-any.pkg.tar.xz"; sha256 = "852c731e86d926808677d0a790325f4a5d398cf1eba39c450a734f95829034af"; }];
    buildInputs = [ python3 db ];
  };

  "python3-cachecontrol" = fetch {
    pname       = "python3-cachecontrol";
    version     = "0.12.5";
    srcs        = [{ filename = "mingw-w64-i686-python3-cachecontrol-0.12.5-1-any.pkg.tar.xz"; sha256 = "52cb707f33ae9d6f08d7a44b677b80ee72396d9e3b3edf15b15f0770fd2e6303"; }];
    buildInputs = [ python3 python3-msgpack python3-requests ];
  };

  "python3-cairo" = fetch {
    pname       = "python3-cairo";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-cairo-1.18.0-1-any.pkg.tar.xz"; sha256 = "8f4c79766597f11b31911f5e1e1fb1b0247e08fb64d8bb6257355c52daf75b15"; }];
    buildInputs = [ cairo python3 ];
  };

  "python3-can" = fetch {
    pname       = "python3-can";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-can-3.0.0-1-any.pkg.tar.xz"; sha256 = "6b486d78e64e67a3df1366ef02a7d8d1e118c75b639a6c3d8011b5b2db3583e4"; }];
    buildInputs = [ python3 python3-python_ics python3-pyserial ];
  };

  "python3-capstone" = fetch {
    pname       = "python3-capstone";
    version     = "4.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-capstone-4.0-1-any.pkg.tar.xz"; sha256 = "38bdc8945fb366b7eba934aa2708801f9d3b810a31035d03a8ca9e5abb3aaa0e"; }];
    buildInputs = [ capstone python3 ];
  };

  "python3-certifi" = fetch {
    pname       = "python3-certifi";
    version     = "2018.11.29";
    srcs        = [{ filename = "mingw-w64-i686-python3-certifi-2018.11.29-2-any.pkg.tar.xz"; sha256 = "dde8490c36838935e717603dc9a540154c22fb2906980d43000d6e640a13ced3"; }];
    buildInputs = [ python3 ];
  };

  "python3-cffi" = fetch {
    pname       = "python3-cffi";
    version     = "1.11.5";
    srcs        = [{ filename = "mingw-w64-i686-python3-cffi-1.11.5-2-any.pkg.tar.xz"; sha256 = "e45f3c317c09b2d960690b9f89e3525e15c3697be4bc613d82b96a33344e7db5"; }];
    buildInputs = [ python3-pycparser ];
  };

  "python3-characteristic" = fetch {
    pname       = "python3-characteristic";
    version     = "14.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-characteristic-14.3.0-3-any.pkg.tar.xz"; sha256 = "47d10ff66b0a6988bb56105dc42a3c100d4b6f02f00af28a03cf889337e34a85"; }];
  };

  "python3-chardet" = fetch {
    pname       = "python3-chardet";
    version     = "3.0.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-chardet-3.0.4-2-any.pkg.tar.xz"; sha256 = "19ffc7cc76da3b84d56e474fd15179f846a86df99ed2d1940d8fa8eaffdbf658"; }];
    buildInputs = [ python3-setuptools ];
  };

  "python3-cliff" = fetch {
    pname       = "python3-cliff";
    version     = "2.14.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-cliff-2.14.0-1-any.pkg.tar.xz"; sha256 = "59b7fab53d7302129fa67c2b3903da7d4b9b11aec24800c494e238af114d32eb"; }];
    buildInputs = [ python3-six python3-pbr python3-cmd2 python3-prettytable python3-pyparsing python3-stevedore python3-yaml ];
  };

  "python3-cmd2" = fetch {
    pname       = "python3-cmd2";
    version     = "0.9.6";
    srcs        = [{ filename = "mingw-w64-i686-python3-cmd2-0.9.6-1-any.pkg.tar.xz"; sha256 = "87055de6dabba43e4a49e640e7aafb953ed7bcabd53c9676f3e920de4394f749"; }];
    buildInputs = [ python3-attrs python3-pyparsing python3-pyperclip python3-pyreadline python3-colorama python3-wcwidth ];
  };

  "python3-colorama" = fetch {
    pname       = "python3-colorama";
    version     = "0.4.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-colorama-0.4.1-1-any.pkg.tar.xz"; sha256 = "819ad9dc2597bdd7d9bdf9aadca291869a7b23816a4de5db75fa052d739ec6c6"; }];
    buildInputs = [ python3 ];
  };

  "python3-colorspacious" = fetch {
    pname       = "python3-colorspacious";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-colorspacious-1.1.2-2-any.pkg.tar.xz"; sha256 = "b40a26aad1b3a572ed48c6d827a69d58f60fd06a2b623cf14355aa2d6c76e056"; }];
    buildInputs = [ python3 ];
  };

  "python3-colour" = fetch {
    pname       = "python3-colour";
    version     = "0.3.11";
    srcs        = [{ filename = "mingw-w64-i686-python3-colour-0.3.11-1-any.pkg.tar.xz"; sha256 = "0730e704aaa0182e2db38712e52ac32ca9cec38c83c3f54a05f9da1c95c78f57"; }];
    buildInputs = [ python3 ];
  };

  "python3-comtypes" = fetch {
    pname       = "python3-comtypes";
    version     = "1.1.7";
    srcs        = [{ filename = "mingw-w64-i686-python3-comtypes-1.1.7-1-any.pkg.tar.xz"; sha256 = "1b26aae549f546e48e3f96bb383a546b1ab00beda138c22feec91d85d7801c03"; }];
    buildInputs = [ python3 ];
  };

  "python3-coverage" = fetch {
    pname       = "python3-coverage";
    version     = "4.5.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-coverage-4.5.2-1-any.pkg.tar.xz"; sha256 = "1ce973f7209216d2a1ee1c207e21a46c300a97e4ae1b1a38702e49b32e933152"; }];
    buildInputs = [ python3 ];
  };

  "python3-crcmod" = fetch {
    pname       = "python3-crcmod";
    version     = "1.7";
    srcs        = [{ filename = "mingw-w64-i686-python3-crcmod-1.7-2-any.pkg.tar.xz"; sha256 = "4b348f37f10bb074f28bb3f4c991ad09d39fb70706e03cb03d2676c4cde7ed13"; }];
    buildInputs = [ python3 ];
  };

  "python3-cryptography" = fetch {
    pname       = "python3-cryptography";
    version     = "2.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-cryptography-2.4.2-1-any.pkg.tar.xz"; sha256 = "e6fb1d31452f88b4a7f74b8a631a8533d61026ee2c82229eb0f390d3958790d4"; }];
    buildInputs = [ python3-cffi python3-pyasn1 python3-idna python3-asn1crypto ];
  };

  "python3-cssselect" = fetch {
    pname       = "python3-cssselect";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-cssselect-1.0.3-2-any.pkg.tar.xz"; sha256 = "cedb68028c440296693711b72c8829b79692660751d5c3025291c02bdcac1a31"; }];
    buildInputs = [ python3 ];
  };

  "python3-cvxopt" = fetch {
    pname       = "python3-cvxopt";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-cvxopt-1.2.2-1-any.pkg.tar.xz"; sha256 = "1dba7328933ea8678d2fdcdc004443df30db742e50b50946bd0a3d66cd4ac837"; }];
    buildInputs = [ python3 ];
  };

  "python3-cx_Freeze" = fetch {
    pname       = "python3-cx_Freeze";
    version     = "5.1.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-cx_Freeze-5.1.1-3-any.pkg.tar.xz"; sha256 = "2c57bf6eb083e99dcf26578366fce208f90d2d056c2daf05d3c720a34b7aef18"; }];
    buildInputs = [ python3 python3-six ];
  };

  "python3-cycler" = fetch {
    pname       = "python3-cycler";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-cycler-0.10.0-3-any.pkg.tar.xz"; sha256 = "00b1ce044b625abd768f339fe4d5df30646cb7cf4ef9d46e54eeaa363867c2e2"; }];
    buildInputs = [ python3 python3-six ];
  };

  "python3-dateutil" = fetch {
    pname       = "python3-dateutil";
    version     = "2.7.5";
    srcs        = [{ filename = "mingw-w64-i686-python3-dateutil-2.7.5-1-any.pkg.tar.xz"; sha256 = "4d71883aad5f59773563ce7afc6eeab37dcfcb2b01150510870ac1a912bd8beb"; }];
    buildInputs = [ python3-six ];
  };

  "python3-ddt" = fetch {
    pname       = "python3-ddt";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-ddt-1.2.0-1-any.pkg.tar.xz"; sha256 = "dcac41fd05af5483c10059013ca4c0babb1ce0dd14980784436f5da2404c5fdc"; }];
    buildInputs = [ python3 ];
  };

  "python3-debtcollector" = fetch {
    pname       = "python3-debtcollector";
    version     = "1.20.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-debtcollector-1.20.0-1-any.pkg.tar.xz"; sha256 = "9204bc8af471a12f1584e8c72b7aeabe6b6d0fb4518eb175a671347042dd079f"; }];
    buildInputs = [ python3 python3-six python3-pbr python3-babel python3-wrapt ];
  };

  "python3-decorator" = fetch {
    pname       = "python3-decorator";
    version     = "4.3.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-decorator-4.3.1-1-any.pkg.tar.xz"; sha256 = "19b5df602c5ff2a07281f545e06bfd12f7d5abefd52a46e88960e1c7676eec4b"; }];
    buildInputs = [ python3 ];
  };

  "python3-defusedxml" = fetch {
    pname       = "python3-defusedxml";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-defusedxml-0.5.0-1-any.pkg.tar.xz"; sha256 = "1b425afcd051bd4fcb61193a01fdedfc7938ee97761b9615fc538b3391f7dff8"; }];
    buildInputs = [ python3 ];
  };

  "python3-distlib" = fetch {
    pname       = "python3-distlib";
    version     = "0.2.8";
    srcs        = [{ filename = "mingw-w64-i686-python3-distlib-0.2.8-1-any.pkg.tar.xz"; sha256 = "8e575781dcfa5a25478949884e34ea138d948967cd06b965316eb70ff3076212"; }];
    buildInputs = [ python3 ];
  };

  "python3-distutils-extra" = fetch {
    pname       = "python3-distutils-extra";
    version     = "2.39";
    srcs        = [{ filename = "mingw-w64-i686-python3-distutils-extra-2.39-4-any.pkg.tar.xz"; sha256 = "6573f3f89fdaed5adeb914d4713e490d300256d4d637e22739c6c7cde83a2f72"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python3.version "3.3"; python3) intltool ];
    broken      = true; # broken dependency python3-distutils-extra -> intltool
  };

  "python3-django" = fetch {
    pname       = "python3-django";
    version     = "2.1.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-django-2.1.4-2-any.pkg.tar.xz"; sha256 = "052b237e9a6c5277249dc3ee24602b41c34c38d1ec440650963f4384be1e048d"; }];
    buildInputs = [ python3 python3-pytz ];
  };

  "python3-dnspython" = fetch {
    pname       = "python3-dnspython";
    version     = "1.16.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-dnspython-1.16.0-1-any.pkg.tar.xz"; sha256 = "444765a2a5b317543ac33fdf9d8dc1240c712643f6ab0f4aea43b0790eafbaa0"; }];
    buildInputs = [ python3 ];
  };

  "python3-docutils" = fetch {
    pname       = "python3-docutils";
    version     = "0.14";
    srcs        = [{ filename = "mingw-w64-i686-python3-docutils-0.14-3-any.pkg.tar.xz"; sha256 = "c122cceeaf5f31537b54af835e448f450d1028ff843e6ac69e80748065bd20d2"; }];
    buildInputs = [ python3 ];
  };

  "python3-editor" = fetch {
    pname       = "python3-editor";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-editor-1.0.3-1-any.pkg.tar.xz"; sha256 = "541a53ce07f73008c454ba1bd7eeb0c2fa69193b6978a7b1f88e175f978ff8c3"; }];
    buildInputs = [ python3 ];
  };

  "python3-email-validator" = fetch {
    pname       = "python3-email-validator";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-email-validator-1.0.3-1-any.pkg.tar.xz"; sha256 = "d56b1fc58e250aabd1ae3e110283899a6f19047b97576bba1911bac3b96547ec"; }];
    buildInputs = [ python3 python2-dnspython python2-idna ];
  };

  "python3-entrypoints" = fetch {
    pname       = "python3-entrypoints";
    version     = "0.2.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-entrypoints-0.2.3-4-any.pkg.tar.xz"; sha256 = "1f76a5182a43c4b3ff4d789e799c61e8fc5b8612c7c643258c157a098a5506fd"; }];
  };

  "python3-et-xmlfile" = fetch {
    pname       = "python3-et-xmlfile";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-et-xmlfile-1.0.1-3-any.pkg.tar.xz"; sha256 = "cece714a896874f4ec6268dd6ac34e421bea8ecfd48e7088f4917e2265436fff"; }];
    buildInputs = [ python3-lxml ];
  };

  "python3-eventlet" = fetch {
    pname       = "python3-eventlet";
    version     = "0.24.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-eventlet-0.24.1-1-any.pkg.tar.xz"; sha256 = "3786d9213ffa325dc10ba5956614b68d26fb1e799ea9c34dee86931cd0fac00c"; }];
    buildInputs = [ python3 python3-greenlet python3-monotonic ];
  };

  "python3-execnet" = fetch {
    pname       = "python3-execnet";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-execnet-1.5.0-1-any.pkg.tar.xz"; sha256 = "eba98709d34b6f60b6f17fa816756e80b1e4dacacea08b27e7da665a3082d290"; }];
    buildInputs = [ python3 python3-apipkg ];
  };

  "python3-extras" = fetch {
    pname       = "python3-extras";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-extras-1.0.0-1-any.pkg.tar.xz"; sha256 = "3361d2fc703819ba539638172225e8d485c38cacc6eca1ca516dcb954c547903"; }];
    buildInputs = [ python3 ];
  };

  "python3-faker" = fetch {
    pname       = "python3-faker";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-faker-1.0.1-1-any.pkg.tar.xz"; sha256 = "36f61e8aa0ae9eeaa3d92f341f8a77d5da626ceded3b224b47795049cecaf1d4"; }];
    buildInputs = [ python3 python3-dateutil python3-six python3-text-unidecode ];
  };

  "python3-fasteners" = fetch {
    pname       = "python3-fasteners";
    version     = "0.14.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-fasteners-0.14.1-1-any.pkg.tar.xz"; sha256 = "589c749872289c69a1a1b135d753412c51e20376a2f7a17fecbac18a978bcb90"; }];
    buildInputs = [ python3 python3-six python3-monotonic ];
  };

  "python3-filelock" = fetch {
    pname       = "python3-filelock";
    version     = "3.0.10";
    srcs        = [{ filename = "mingw-w64-i686-python3-filelock-3.0.10-1-any.pkg.tar.xz"; sha256 = "6b102d80819fcdd780f22cb053ab563d03ffd6d32a930bd46cc829001d6ce51b"; }];
    buildInputs = [ python3 ];
  };

  "python3-fixtures" = fetch {
    pname       = "python3-fixtures";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-fixtures-3.0.0-2-any.pkg.tar.xz"; sha256 = "a1d7ad06821ae068b69abfc2d12f1016bd251d83dc3070b48cb51a67ccb38951"; }];
    buildInputs = [ python3 python3-pbr python3-six ];
  };

  "python3-flake8" = fetch {
    pname       = "python3-flake8";
    version     = "3.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-flake8-3.6.0-1-any.pkg.tar.xz"; sha256 = "876fc5f4febc44e6d873d790d6b2d35e427ae5e325c386af1a7dde62de7941e5"; }];
    buildInputs = [ python3-pyflakes python3-mccabe python3-pycodestyle ];
  };

  "python3-flaky" = fetch {
    pname       = "python3-flaky";
    version     = "3.4.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-flaky-3.4.0-2-any.pkg.tar.xz"; sha256 = "6020ab8af7a05fdbd4f33ed7b2f5686bfd28782b3f9436791c5e084d62e1be50"; }];
    buildInputs = [ python3 ];
  };

  "python3-flexmock" = fetch {
    pname       = "python3-flexmock";
    version     = "0.10.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-flexmock-0.10.2-1-any.pkg.tar.xz"; sha256 = "edd4e898a882565b65a247dd566bd2534474b0fa4326388de8e1a33aea542063"; }];
    buildInputs = [ python3 ];
  };

  "python3-fonttools" = fetch {
    pname       = "python3-fonttools";
    version     = "3.30.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-fonttools-3.30.0-1-any.pkg.tar.xz"; sha256 = "223952ccd589ef5dd520f14881a199391d0808fd79d2026e357f2f3eeae78cdb"; }];
    buildInputs = [ python3 python3-numpy ];
  };

  "python3-freezegun" = fetch {
    pname       = "python3-freezegun";
    version     = "0.3.11";
    srcs        = [{ filename = "mingw-w64-i686-python3-freezegun-0.3.11-1-any.pkg.tar.xz"; sha256 = "871224f7d51bf700496fd6a86d345c487b3ab72fe196fb3b4efbc71720271794"; }];
    buildInputs = [ python3 python3-dateutil ];
  };

  "python3-funcsigs" = fetch {
    pname       = "python3-funcsigs";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-funcsigs-1.0.2-2-any.pkg.tar.xz"; sha256 = "0a5aaadfe3b3d74dc50953c52eee7cfb3c6b8beb8eff851b0593e611cb78d97e"; }];
    buildInputs = [ python3 ];
  };

  "python3-future" = fetch {
    pname       = "python3-future";
    version     = "0.17.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-future-0.17.1-1-any.pkg.tar.xz"; sha256 = "4a21af63666465e77c64d3891b148218204826d131d3ad7def65aa2c22bd7ba2"; }];
    buildInputs = [ python3 ];
  };

  "python3-genty" = fetch {
    pname       = "python3-genty";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-genty-1.3.2-2-any.pkg.tar.xz"; sha256 = "efdbd794794699302cd6c03caf499f1fb0ce8e54af7dae2e8658706ea6e32d94"; }];
    buildInputs = [ python3 python3-six ];
  };

  "python3-gmpy2" = fetch {
    pname       = "python3-gmpy2";
    version     = "2.1.0a4";
    srcs        = [{ filename = "mingw-w64-i686-python3-gmpy2-2.1.0a4-1-any.pkg.tar.xz"; sha256 = "42fbd779cdda1d87060d44093d58dbc66297f2510f4a81b335889e5a0f0a8c2b"; }];
    buildInputs = [ python3 mpc ];
  };

  "python3-gobject" = fetch {
    pname       = "python3-gobject";
    version     = "3.30.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-gobject-3.30.4-1-any.pkg.tar.xz"; sha256 = "5efe3161cd4996e3c803a907384ee9384139489be6005c3a010753df42e122e3"; }];
    buildInputs = [ glib2 python3-cairo libffi gobject-introspection-runtime (assert pygobject-devel.version=="3.30.4"; pygobject-devel) ];
  };

  "python3-gobject2" = fetch {
    pname       = "python3-gobject2";
    version     = "2.28.7";
    srcs        = [{ filename = "mingw-w64-i686-python3-gobject2-2.28.7-1-any.pkg.tar.xz"; sha256 = "e7798b4789d474a5a3552fa5accf82402d77b74a982a4071b26b9136fb9d62c1"; }];
    buildInputs = [ glib2 libffi gobject-introspection-runtime (assert pygobject2-devel.version=="2.28.7"; pygobject2-devel) ];
  };

  "python3-greenlet" = fetch {
    pname       = "python3-greenlet";
    version     = "0.4.15";
    srcs        = [{ filename = "mingw-w64-i686-python3-greenlet-0.4.15-1-any.pkg.tar.xz"; sha256 = "37ef178e7b379cbfbfca407204478059039b897a2c6aa2c99e56c1398f4f89a2"; }];
    buildInputs = [ python3 ];
  };

  "python3-h5py" = fetch {
    pname       = "python3-h5py";
    version     = "2.9.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-h5py-2.9.0-1-any.pkg.tar.xz"; sha256 = "29c77791c41df7e5d27c98663cf2a486203c3c6e91aca607796f1a6c3d13d889"; }];
    buildInputs = [ python3-numpy python3-six hdf5 ];
  };

  "python3-hacking" = fetch {
    pname       = "python3-hacking";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-hacking-1.1.0-1-any.pkg.tar.xz"; sha256 = "2e8be43387d1075b678b62f9313833137f8ab021310e65d71c7384ec7ae0a1af"; }];
    buildInputs = [ python3 ];
  };

  "python3-html5lib" = fetch {
    pname       = "python3-html5lib";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-html5lib-1.0.1-3-any.pkg.tar.xz"; sha256 = "969d6889c02a2e0239025dd8cc3ba15ef57d33be1216b095618e6cf204c2b3c5"; }];
    buildInputs = [ python3 python3-six python3-webencodings ];
  };

  "python3-httplib2" = fetch {
    pname       = "python3-httplib2";
    version     = "0.12.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-httplib2-0.12.0-1-any.pkg.tar.xz"; sha256 = "7bcc0ea6dda2c5065aab846226e089e4d4104d0a49012209170a7cc93a975e80"; }];
    buildInputs = [ python3 python3-certifi ca-certificates ];
  };

  "python3-hypothesis" = fetch {
    pname       = "python3-hypothesis";
    version     = "3.84.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-hypothesis-3.84.4-1-any.pkg.tar.xz"; sha256 = "bdace9ca09a75677f592c6225b465b9aac40f07317e81a0f240f54c42890f699"; }];
    buildInputs = [ python3 python3-attrs python3-coverage ];
  };

  "python3-icu" = fetch {
    pname       = "python3-icu";
    version     = "2.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-icu-2.2-1-any.pkg.tar.xz"; sha256 = "397c49e4792fc26082a4e6f3bfbc7c1dc41193cee983248c96432f9ce834da1c"; }];
    buildInputs = [ python3 icu ];
  };

  "python3-idna" = fetch {
    pname       = "python3-idna";
    version     = "2.8";
    srcs        = [{ filename = "mingw-w64-i686-python3-idna-2.8-1-any.pkg.tar.xz"; sha256 = "01c8519bc7deff96e1991b8aeebe8355a66c416513285108a7b082d5d0de390b"; }];
    buildInputs = [  ];
  };

  "python3-ifaddr" = fetch {
    pname       = "python3-ifaddr";
    version     = "0.1.6";
    srcs        = [{ filename = "mingw-w64-i686-python3-ifaddr-0.1.6-1-any.pkg.tar.xz"; sha256 = "0e0dc22cf3dba0f038e5de8a67524cf7d896c49085906c761f9bd569ba55c5a5"; }];
    buildInputs = [ python3 ];
  };

  "python3-imagesize" = fetch {
    pname       = "python3-imagesize";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-imagesize-1.1.0-1-any.pkg.tar.xz"; sha256 = "f9cf95850358926a4ad7a12d0a795572362132406900d150f44adad56c27f9ca"; }];
    buildInputs = [ python3 ];
  };

  "python3-imbalanced-learn" = fetch {
    pname       = "python3-imbalanced-learn";
    version     = "0.4.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-imbalanced-learn-0.4.3-1-any.pkg.tar.xz"; sha256 = "66064c5d47936e06f4cc1de2cd1c1479915f4855f5d45b1e44210be26497e4dc"; }];
    buildInputs = [ python3 python3-numpy python3-scipy ];
  };

  "python3-importlib-metadata" = fetch {
    pname       = "python3-importlib-metadata";
    version     = "0.7";
    srcs        = [{ filename = "mingw-w64-i686-python3-importlib-metadata-0.7-1-any.pkg.tar.xz"; sha256 = "7c5eaa5e55eb9ea2c702543993cd210e0cb4bcf1fb8ca3ae1db21380f9abd9e8"; }];
    buildInputs = [ python3 ];
  };

  "python3-iniconfig" = fetch {
    pname       = "python3-iniconfig";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-iniconfig-1.0.0-2-any.pkg.tar.xz"; sha256 = "67e4926cd4de5f25f084b0b1506a5cd58fd1232af74dffa16e530b5da3609f08"; }];
    buildInputs = [ python3 ];
  };

  "python3-iocapture" = fetch {
    pname       = "python3-iocapture";
    version     = "0.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-iocapture-0.1.2-1-any.pkg.tar.xz"; sha256 = "8e4ce6c2a5ae917688d54a4be7c9dc809a9b444857d11ae00522aadad75754a8"; }];
    buildInputs = [ python3 ];
  };

  "python3-ipykernel" = fetch {
    pname       = "python3-ipykernel";
    version     = "5.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-ipykernel-5.1.0-1-any.pkg.tar.xz"; sha256 = "bbf45996cd8a8fb53a8ef2f9f3fbf92425ff25140f56ee9652208b347d0f2d9f"; }];
    buildInputs = [ python3 python3-pathlib2 python3-pyzmq python3-ipython ];
  };

  "python3-ipython" = fetch {
    pname       = "python3-ipython";
    version     = "7.1.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-ipython-7.1.1-1-any.pkg.tar.xz"; sha256 = "a5b1af2ade71de8f1af3d800231aecf6d77018bdb821e44cf7c8bae75ff1167f"; }];
    buildInputs = [ winpty sqlite3 python3-jedi python3-decorator python3-pickleshare python3-simplegeneric python3-traitlets (assert stdenvNoCC.lib.versionAtLeast python3-prompt_toolkit.version "2.0"; python3-prompt_toolkit) python3-pygments python3-simplegeneric python3-backcall python3-pexpect python3-colorama python3-win_unicode_console ];
  };

  "python3-ipython_genutils" = fetch {
    pname       = "python3-ipython_genutils";
    version     = "0.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-ipython_genutils-0.2.0-2-any.pkg.tar.xz"; sha256 = "cf8bd93c079eb1dfd40cf929fe7c109f00b7e5eb5fbbdb824fea5424ebda43fe"; }];
    buildInputs = [ python3 ];
  };

  "python3-ipywidgets" = fetch {
    pname       = "python3-ipywidgets";
    version     = "7.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-ipywidgets-7.4.2-1-any.pkg.tar.xz"; sha256 = "6c50e368e370b071e1f04d8d8c5bbf8b6bf212d2a67a9ebb80ebc8dd815557f3"; }];
    buildInputs = [ python3 ];
  };

  "python3-iso8601" = fetch {
    pname       = "python3-iso8601";
    version     = "0.1.12";
    srcs        = [{ filename = "mingw-w64-i686-python3-iso8601-0.1.12-1-any.pkg.tar.xz"; sha256 = "5cee9dd41c51cc199dede262711e51b3c57e0593191707d67f12348e5abc4413"; }];
    buildInputs = [ python3 ];
  };

  "python3-isort" = fetch {
    pname       = "python3-isort";
    version     = "4.3.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-isort-4.3.4-1-any.pkg.tar.xz"; sha256 = "637036860751d5a4eb07c120fcfffa8000cdbd88f047b45b5da87aaa6c14680f"; }];
    buildInputs = [ python3 ];
  };

  "python3-jdcal" = fetch {
    pname       = "python3-jdcal";
    version     = "1.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-jdcal-1.4-2-any.pkg.tar.xz"; sha256 = "7fd7f06a6ea64e27ac755c1d3d1adb5fcfe156ff3bc05d1646beea8a7b1e1770"; }];
    buildInputs = [ python3 ];
  };

  "python3-jedi" = fetch {
    pname       = "python3-jedi";
    version     = "0.13.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-jedi-0.13.1-1-any.pkg.tar.xz"; sha256 = "03c4de707b058db5970b041cc865e005738db132181a629d72a888b570e6bef2"; }];
    buildInputs = [ python3 python3-parso ];
  };

  "python3-jinja" = fetch {
    pname       = "python3-jinja";
    version     = "2.10";
    srcs        = [{ filename = "mingw-w64-i686-python3-jinja-2.10-2-any.pkg.tar.xz"; sha256 = "892e21a8d3308e244e5525b2fd49e5c883c3729ac70ff8844cdf8400e9f23c59"; }];
    buildInputs = [ python3-setuptools python3-markupsafe ];
  };

  "python3-json-rpc" = fetch {
    pname       = "python3-json-rpc";
    version     = "1.11.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-json-rpc-1.11.1-1-any.pkg.tar.xz"; sha256 = "7f39847bdc3ee85f45a377b5ac4041dfe1dfc61bd54e20ced6a5afb3f59498dd"; }];
    buildInputs = [ python3 ];
  };

  "python3-jsonschema" = fetch {
    pname       = "python3-jsonschema";
    version     = "2.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-jsonschema-2.6.0-5-any.pkg.tar.xz"; sha256 = "fcb9b07ffa3da7c372ff4756c91ec391b2424884cfa00f73a28541b45689d8b3"; }];
    buildInputs = [ python3 ];
  };

  "python3-jupyter-nbconvert" = fetch {
    pname       = "python3-jupyter-nbconvert";
    version     = "5.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-jupyter-nbconvert-5.4-2-any.pkg.tar.xz"; sha256 = "c83f429cfc377cf6fb7604a432306ec10b56f272fd10315baa9ff54a6ce6912b"; }];
    buildInputs = [ python3 python3-defusedxml python3-jupyter_client python3-jupyter-nbformat python3-pygments python3-mistune python3-jinja python3-entrypoints python3-traitlets python3-pandocfilters python3-bleach python3-testpath ];
  };

  "python3-jupyter-nbformat" = fetch {
    pname       = "python3-jupyter-nbformat";
    version     = "4.4.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-jupyter-nbformat-4.4.0-2-any.pkg.tar.xz"; sha256 = "793bdf25b4511fdce0b4b85cb778546d146710e8878c45a15376aac0b8356fef"; }];
    buildInputs = [ python3 python3-traitlets python3-jsonschema python3-jupyter_core ];
  };

  "python3-jupyter_client" = fetch {
    pname       = "python3-jupyter_client";
    version     = "5.2.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-jupyter_client-5.2.4-1-any.pkg.tar.xz"; sha256 = "8ddad23729ec4c4daa5c54013fceb0f014374905d658f32eae358bd073911341"; }];
    buildInputs = [ python3-ipykernel python3-jupyter_core python3-pyzmq ];
  };

  "python3-jupyter_console" = fetch {
    pname       = "python3-jupyter_console";
    version     = "6.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-jupyter_console-6.0.0-1-any.pkg.tar.xz"; sha256 = "c1b035f23a0ba9fa647dde3eb601fcaa17cca8eb3c20d4658fd7f81ae996af82"; }];
    buildInputs = [ python3 python3-jupyter_core python3-jupyter_client python3-colorama ];
  };

  "python3-jupyter_core" = fetch {
    pname       = "python3-jupyter_core";
    version     = "4.4.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-jupyter_core-4.4.0-3-any.pkg.tar.xz"; sha256 = "63f8c8ec3af6f5a25b084b8e4795f8816eefc1d4e8eed652388083cccf6b2b4d"; }];
    buildInputs = [ python3 ];
  };

  "python3-kiwisolver" = fetch {
    pname       = "python3-kiwisolver";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-kiwisolver-1.0.1-2-any.pkg.tar.xz"; sha256 = "f10427d458821ee7def436a5c12e0f47c39ae18655691584c5254b384d7eeaa8"; }];
    buildInputs = [ python3 ];
  };

  "python3-lazy-object-proxy" = fetch {
    pname       = "python3-lazy-object-proxy";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-lazy-object-proxy-1.3.1-2-any.pkg.tar.xz"; sha256 = "1e7c062f0dc9339a17f1843793440a4152a3cd90e09bccc703cd7c029bd45e2f"; }];
    buildInputs = [ python3 ];
  };

  "python3-ldap" = fetch {
    pname       = "python3-ldap";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-ldap-3.1.0-1-any.pkg.tar.xz"; sha256 = "952d50637b27a3f60dbef6ebadcc431f7b734fdfe4d9c12817b960ea86842232"; }];
    buildInputs = [ python3 ];
  };

  "python3-ldap3" = fetch {
    pname       = "python3-ldap3";
    version     = "2.5.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-ldap3-2.5.1-1-any.pkg.tar.xz"; sha256 = "afd2f9e37c6e12fc8823af6acb2a13d3a437c6857e49c55714216106ca94c2db"; }];
    buildInputs = [ python3 ];
  };

  "python3-lhafile" = fetch {
    pname       = "python3-lhafile";
    version     = "0.2.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-lhafile-0.2.1-3-any.pkg.tar.xz"; sha256 = "c4790c78374464906f75301043438a9b83f9ee2451bf120bd26c2315cf152053"; }];
    buildInputs = [ python3 python3-six ];
  };

  "python3-lockfile" = fetch {
    pname       = "python3-lockfile";
    version     = "0.12.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-lockfile-0.12.2-1-any.pkg.tar.xz"; sha256 = "c921505bc710bd3031ac64e2aa034fcc71151a72ad946e7df1a483defc60b4be"; }];
    buildInputs = [ python3 ];
  };

  "python3-lxml" = fetch {
    pname       = "python3-lxml";
    version     = "4.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-lxml-4.3.0-1-any.pkg.tar.xz"; sha256 = "ad30cb3362f409acb2ef12c8adbab0d5f7e8539e04d3867c9e6a1b36e6938909"; }];
    buildInputs = [ libxml2 libxslt python3 ];
  };

  "python3-mako" = fetch {
    pname       = "python3-mako";
    version     = "1.0.7";
    srcs        = [{ filename = "mingw-w64-i686-python3-mako-1.0.7-3-any.pkg.tar.xz"; sha256 = "ba0d5cb24aaaa63794f0f29550201c8db5ea7620bf922bc49cc990222a4d126e"; }];
    buildInputs = [ python3-markupsafe python3-beaker ];
  };

  "python3-markdown" = fetch {
    pname       = "python3-markdown";
    version     = "3.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-markdown-3.0.1-1-any.pkg.tar.xz"; sha256 = "360557c41ad9578753f198f746378c30127693099fd84e67d9063237922b37ed"; }];
    buildInputs = [ python3 ];
  };

  "python3-markupsafe" = fetch {
    pname       = "python3-markupsafe";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-markupsafe-1.1.0-1-any.pkg.tar.xz"; sha256 = "0eca8bf4e51314845564378e69b28dae173c1bd5e1cb3517ea857d27c3aac1a9"; }];
    buildInputs = [ python3 ];
  };

  "python3-matplotlib" = fetch {
    pname       = "python3-matplotlib";
    version     = "3.0.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-matplotlib-3.0.2-1-any.pkg.tar.xz"; sha256 = "d2e668e8a48e371ea0202d8edec3c13ae52aa742ec7100e48f882b48bc0e1800"; }];
    buildInputs = [ python3-pytz python3-numpy python3-cycler python3-dateutil python3-pyparsing python3-kiwisolver freetype libpng ];
  };

  "python3-mccabe" = fetch {
    pname       = "python3-mccabe";
    version     = "0.6.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-mccabe-0.6.1-1-any.pkg.tar.xz"; sha256 = "449d3899499c9c8e8e1d7bc68c17735c259111373e0febc13d1fe0cc96a2bdd0"; }];
    buildInputs = [ python3 ];
  };

  "python3-mimeparse" = fetch {
    pname       = "python3-mimeparse";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-mimeparse-1.6.0-1-any.pkg.tar.xz"; sha256 = "112cc7b8c4e581c193abcf8a32c3c93ab28b90a2c174e9cae3bae0b1629fa117"; }];
    buildInputs = [ python3 ];
  };

  "python3-mistune" = fetch {
    pname       = "python3-mistune";
    version     = "0.8.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-mistune-0.8.4-1-any.pkg.tar.xz"; sha256 = "c67b12b296e3f30d694b18105672523a5691d61373121ce88c01dbd49cbc9cc3"; }];
    buildInputs = [ python3 ];
  };

  "python3-mock" = fetch {
    pname       = "python3-mock";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-mock-2.0.0-3-any.pkg.tar.xz"; sha256 = "da15911d4a038135c3c9ace4adc507d215f13c5f6642df223525fe8a109651a1"; }];
    buildInputs = [ python3 python3-six python3-pbr ];
  };

  "python3-monotonic" = fetch {
    pname       = "python3-monotonic";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-i686-python3-monotonic-1.5-1-any.pkg.tar.xz"; sha256 = "907266d5bd7776527971608faede54c1df044a3cf929e3615b605d25f744adce"; }];
    buildInputs = [ python3 ];
  };

  "python3-more-itertools" = fetch {
    pname       = "python3-more-itertools";
    version     = "4.3.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-more-itertools-4.3.1-1-any.pkg.tar.xz"; sha256 = "58a15eda8000ace3d27bbc62ebedd5f0c8b6d6771c65870f22b52259184d931f"; }];
    buildInputs = [ python3 python3-six ];
  };

  "python3-mox3" = fetch {
    pname       = "python3-mox3";
    version     = "0.26.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-mox3-0.26.0-1-any.pkg.tar.xz"; sha256 = "b38eda716ade4ca40308ca2f02adf45ff50ee9ed7f00bc0aa437e015ec783881"; }];
    buildInputs = [ python3 python3-pbr python3-fixtures ];
  };

  "python3-mpmath" = fetch {
    pname       = "python3-mpmath";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-mpmath-1.1.0-1-any.pkg.tar.xz"; sha256 = "e78179bbda3ea2999668688e4af137d6cb758fe71e584c00ae49b64653b50bdd"; }];
    buildInputs = [ python3 python3-gmpy2 ];
  };

  "python3-msgpack" = fetch {
    pname       = "python3-msgpack";
    version     = "0.5.6";
    srcs        = [{ filename = "mingw-w64-i686-python3-msgpack-0.5.6-1-any.pkg.tar.xz"; sha256 = "25e738dc796f313caeeead754dd9cd2d3ec802b080c1fd903b89e5fba886421c"; }];
    buildInputs = [ python3 ];
  };

  "python3-ndg-httpsclient" = fetch {
    pname       = "python3-ndg-httpsclient";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-ndg-httpsclient-0.5.1-1-any.pkg.tar.xz"; sha256 = "0e569730405520ff77b87d4bd04a7259e3f2aece2f9bacaafd9c98a1070dce7d"; }];
    buildInputs = [ python3-pyopenssl python3-pyasn1 ];
  };

  "python3-netaddr" = fetch {
    pname       = "python3-netaddr";
    version     = "0.7.19";
    srcs        = [{ filename = "mingw-w64-i686-python3-netaddr-0.7.19-1-any.pkg.tar.xz"; sha256 = "a8417e94fe567eb859b644c864d596f7634e9d3d67a0f7767be2681c50f08783"; }];
    buildInputs = [ python3 ];
  };

  "python3-netifaces" = fetch {
    pname       = "python3-netifaces";
    version     = "0.10.9";
    srcs        = [{ filename = "mingw-w64-i686-python3-netifaces-0.10.9-1-any.pkg.tar.xz"; sha256 = "151e0d6d373e1e3dc2b4ff34de44bf7ba6e818d351b61f45757be9043ed6ef5e"; }];
    buildInputs = [ python3 ];
  };

  "python3-networkx" = fetch {
    pname       = "python3-networkx";
    version     = "2.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-networkx-2.2-1-any.pkg.tar.xz"; sha256 = "9dc96601d0666545a0f346351c35a73f0921a0b407d03e7a4427a3e3e9913d46"; }];
    buildInputs = [ python3 python3-decorator ];
  };

  "python3-nose" = fetch {
    pname       = "python3-nose";
    version     = "1.3.7";
    srcs        = [{ filename = "mingw-w64-i686-python3-nose-1.3.7-8-any.pkg.tar.xz"; sha256 = "82f0b291afe0c2ff23a8750f8330a39a608b76ada4b76a94f7131fa95d9e1e69"; }];
    buildInputs = [ python3-setuptools ];
  };

  "python3-notebook" = fetch {
    pname       = "python3-notebook";
    version     = "5.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-notebook-5.6.0-1-any.pkg.tar.xz"; sha256 = "b331916f9ec354b3a3ba53f233d00ad32b4d69a10906e638a334bcab186588b8"; }];
    buildInputs = [ python3 python3-jupyter_core python3-jupyter_client python3-jupyter-nbformat python3-jupyter-nbconvert python3-ipywidgets python3-jinja python3-traitlets python3-tornado python3-terminado python3-send2trash python3-prometheus-client ];
  };

  "python3-nuitka" = fetch {
    pname       = "python3-nuitka";
    version     = "0.6.0.6";
    srcs        = [{ filename = "mingw-w64-i686-python3-nuitka-0.6.0.6-1-any.pkg.tar.xz"; sha256 = "741701453f424ba8659e720200b976537eb57eba82d907f3a276c7a893692474"; }];
    buildInputs = [ python3-setuptools ];
  };

  "python3-numexpr" = fetch {
    pname       = "python3-numexpr";
    version     = "2.6.9";
    srcs        = [{ filename = "mingw-w64-i686-python3-numexpr-2.6.9-1-any.pkg.tar.xz"; sha256 = "a1755c7cfcc353833ee00d4379f3356365e646cc5b41ed0f58f20c2b2cf45482"; }];
    buildInputs = [ python3-numpy ];
  };

  "python3-numpy" = fetch {
    pname       = "python3-numpy";
    version     = "1.15.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-numpy-1.15.4-1-any.pkg.tar.xz"; sha256 = "b755869960bab3bb6f601458903b6e976e0829759795847d3cc4acd8f8411bb1"; }];
    buildInputs = [ openblas python3 ];
  };

  "python3-olefile" = fetch {
    pname       = "python3-olefile";
    version     = "0.46";
    srcs        = [{ filename = "mingw-w64-i686-python3-olefile-0.46-1-any.pkg.tar.xz"; sha256 = "f5fcc68e40b9646a7ad274e3c1a8410aa71f9d63b92d6a02cf10d0fdf4da7bda"; }];
    buildInputs = [ python3 ];
  };

  "python3-openmdao" = fetch {
    pname       = "python3-openmdao";
    version     = "2.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-openmdao-2.5.0-1-any.pkg.tar.xz"; sha256 = "0b67a6c425a5c575e52698c7cbac43b0a01b4ce09e4acacc26d5adce5e9f07e2"; }];
    buildInputs = [ python3-numpy python3-scipy python3-networkx python3-sqlitedict python3-pyparsing python3-six ];
  };

  "python3-openpyxl" = fetch {
    pname       = "python3-openpyxl";
    version     = "2.5.12";
    srcs        = [{ filename = "mingw-w64-i686-python3-openpyxl-2.5.12-1-any.pkg.tar.xz"; sha256 = "9d053ffae68a4db63c07a31a7b026a00e1cd8ba6123f584b1d20b4d46e3ceeed"; }];
    buildInputs = [ python3-jdcal python3-et-xmlfile ];
  };

  "python3-oslo-concurrency" = fetch {
    pname       = "python3-oslo-concurrency";
    version     = "3.29.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-oslo-concurrency-3.29.0-1-any.pkg.tar.xz"; sha256 = "b2bba7729c7a3dcd48b97edbb7630f676151b97279ca71e1116659550c7c61e3"; }];
    buildInputs = [ python3 python3-six python3-pbr python3-oslo-config python3-oslo-i18n python3-oslo-utils python3-fasteners ];
  };

  "python3-oslo-config" = fetch {
    pname       = "python3-oslo-config";
    version     = "6.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-oslo-config-6.7.0-1-any.pkg.tar.xz"; sha256 = "f3ec5bdb5679b3054e4f82902f35c4aa759e41e3ee9c782596260fbb993879f3"; }];
    buildInputs = [ python3 python3-six python3-netaddr python3-stevedore python3-debtcollector python3-oslo-i18n python3-rfc3986 python3-yaml ];
  };

  "python3-oslo-context" = fetch {
    pname       = "python3-oslo-context";
    version     = "2.22.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-oslo-context-2.22.0-1-any.pkg.tar.xz"; sha256 = "b63b6ed75d79316be526e9c4ea7cc77f5d5b5d485c7b3f3363eb13086568dfa8"; }];
    buildInputs = [ python3 python3-pbr python3-debtcollector ];
  };

  "python3-oslo-db" = fetch {
    pname       = "python3-oslo-db";
    version     = "4.42.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-oslo-db-4.42.0-1-any.pkg.tar.xz"; sha256 = "8fee25254b772a92f048f55221a9b24412ac1eb364d818300c04ffa066eb928a"; }];
    buildInputs = [ python3 python3-six python3-pbr python3-alembic python3-debtcollector python3-oslo-i18n python3-oslo-config python3-oslo-utils python3-sqlalchemy python3-sqlalchemy-migrate python3-stevedore ];
  };

  "python3-oslo-i18n" = fetch {
    pname       = "python3-oslo-i18n";
    version     = "3.23.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-oslo-i18n-3.23.0-1-any.pkg.tar.xz"; sha256 = "2802db005e918070911239f29a1276a4b626bcec06205839ea07c22d29247eef"; }];
    buildInputs = [ python3 python3-six python3-pbr python3-babel ];
  };

  "python3-oslo-log" = fetch {
    pname       = "python3-oslo-log";
    version     = "3.42.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-oslo-log-3.42.1-1-any.pkg.tar.xz"; sha256 = "ee90bed00db2131ad5eedab6fdb681590dba3a6be247177fa3571d944427ed26"; }];
    buildInputs = [ python3 python3-six python3-pbr python3-oslo-config python3-oslo-context python3-oslo-i18n python3-oslo-utils python3-oslo-serialization python3-debtcollector python3-dateutil python3-monotonic ];
  };

  "python3-oslo-serialization" = fetch {
    pname       = "python3-oslo-serialization";
    version     = "2.28.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-oslo-serialization-2.28.1-1-any.pkg.tar.xz"; sha256 = "fdba5b436e8cc4f4894f6500436905f4de7fb3d45fe37cf545f34f91c42e1470"; }];
    buildInputs = [ python3 python3-six python3-pbr python3-babel python3-msgpack python3-oslo-utils python3-pytz ];
  };

  "python3-oslo-utils" = fetch {
    pname       = "python3-oslo-utils";
    version     = "3.39.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-oslo-utils-3.39.0-1-any.pkg.tar.xz"; sha256 = "a1c6d75d16c6f8dba0c7dc03ddbaa69d6bb6e5adc457c0b66aac481826185ae2"; }];
    buildInputs = [ python3 ];
  };

  "python3-oslosphinx" = fetch {
    pname       = "python3-oslosphinx";
    version     = "4.18.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-oslosphinx-4.18.0-1-any.pkg.tar.xz"; sha256 = "2697147b42d98b7b150f638ee35a9d6b0319f51743333288f5c8b6abaaf67675"; }];
    buildInputs = [ python3 python3-six python3-requests ];
  };

  "python3-oslotest" = fetch {
    pname       = "python3-oslotest";
    version     = "3.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-oslotest-3.7.0-1-any.pkg.tar.xz"; sha256 = "0a650577b54289dea4d4ceb244bcb8114617baaff67e48c512dcf1743f572b80"; }];
    buildInputs = [ python3 ];
  };

  "python3-packaging" = fetch {
    pname       = "python3-packaging";
    version     = "18.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-packaging-18.0-1-any.pkg.tar.xz"; sha256 = "50d1d2de11799c8108eb7e8c06a09aac70c3bca8aa9e8babe206ffea78689a3d"; }];
    buildInputs = [ python3 python3-pyparsing python3-six ];
  };

  "python3-pandas" = fetch {
    pname       = "python3-pandas";
    version     = "0.23.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-pandas-0.23.4-1-any.pkg.tar.xz"; sha256 = "81dcf25ab660cfe12228653c8d1130c130539397d1edc093f7f4403083a299d4"; }];
    buildInputs = [ python3-numpy python3-pytz python3-dateutil python3-setuptools ];
  };

  "python3-pandocfilters" = fetch {
    pname       = "python3-pandocfilters";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pandocfilters-1.4.2-2-any.pkg.tar.xz"; sha256 = "38c1831a1ee6711a0134373a698ee2d7264df78f8515b7888ae8b001550faf49"; }];
    buildInputs = [ python3 ];
  };

  "python3-paramiko" = fetch {
    pname       = "python3-paramiko";
    version     = "2.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-paramiko-2.4.2-1-any.pkg.tar.xz"; sha256 = "eec89a519e36df966f3ea64c7dbcefa143fff97df6588a74a73979f259426f9c"; }];
    buildInputs = [ python3 ];
  };

  "python3-parso" = fetch {
    pname       = "python3-parso";
    version     = "0.3.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-parso-0.3.1-1-any.pkg.tar.xz"; sha256 = "e70185f2c918a9e18bbd499c920926a071c4780ade9edd1402820b9a5ff57091"; }];
    buildInputs = [ python3 ];
  };

  "python3-path" = fetch {
    pname       = "python3-path";
    version     = "11.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-path-11.5.0-1-any.pkg.tar.xz"; sha256 = "99c6338c8b89fc3dbb36fdc24effcb2e6e0a97282e6fb2592ef5e35740b921ef"; }];
    buildInputs = [ python3-importlib-metadata ];
  };

  "python3-pathlib2" = fetch {
    pname       = "python3-pathlib2";
    version     = "2.3.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-pathlib2-2.3.3-1-any.pkg.tar.xz"; sha256 = "abe7bcd524cf44fca4d82b1c9c50f14baf64de2f4e7b7ad9e502f83769cf593a"; }];
    buildInputs = [ python3 python3-scandir ];
  };

  "python3-pathtools" = fetch {
    pname       = "python3-pathtools";
    version     = "0.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pathtools-0.1.2-1-any.pkg.tar.xz"; sha256 = "ea39cede1a4cc22c79f3a822b09562ed44ce7c4c8a229c03b9d460a0e1de671e"; }];
    buildInputs = [ python3 ];
  };

  "python3-patsy" = fetch {
    pname       = "python3-patsy";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-patsy-0.5.1-1-any.pkg.tar.xz"; sha256 = "f110ef8f7dc5b9006ec9a3186f2270ff3f6ce24f8fe4ca182e458aa1da6e8a42"; }];
    buildInputs = [ python3-numpy ];
  };

  "python3-pbr" = fetch {
    pname       = "python3-pbr";
    version     = "5.1.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-pbr-5.1.1-2-any.pkg.tar.xz"; sha256 = "e75a2470c15a2d7f9e6677903f5dd5edde0ec9ac28e476ac4f022defd1837c88"; }];
    buildInputs = [ python3-setuptools ];
  };

  "python3-pdfrw" = fetch {
    pname       = "python3-pdfrw";
    version     = "0.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-pdfrw-0.4-2-any.pkg.tar.xz"; sha256 = "fdc39f72e43ff5275e274f4562730c50d0f2941992fb96e9aab161a098e8d3e3"; }];
    buildInputs = [ python3 ];
  };

  "python3-pep517" = fetch {
    pname       = "python3-pep517";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pep517-0.5.0-1-any.pkg.tar.xz"; sha256 = "c02ca7a720209ea3ecf451d1cc465fe6a120da7636a898ae95cf488991abdad1"; }];
    buildInputs = [ python3 ];
  };

  "python3-pexpect" = fetch {
    pname       = "python3-pexpect";
    version     = "4.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pexpect-4.6.0-1-any.pkg.tar.xz"; sha256 = "76b7a1d255d33525ec8e7d9da43c8c72efbd4c138d831e77a5fb254ba4b4a867"; }];
    buildInputs = [ python3 python3-ptyprocess ];
  };

  "python3-pgen2" = fetch {
    pname       = "python3-pgen2";
    version     = "0.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pgen2-0.1.0-3-any.pkg.tar.xz"; sha256 = "d02da45b572e746f4c52a2a8b066191ff3c33cb0b9826040c238bbb6d9c13e19"; }];
    buildInputs = [ python3 ];
  };

  "python3-pickleshare" = fetch {
    pname       = "python3-pickleshare";
    version     = "0.7.5";
    srcs        = [{ filename = "mingw-w64-i686-python3-pickleshare-0.7.5-1-any.pkg.tar.xz"; sha256 = "4799a8cf1caa5f8034c5e0987f912cee0f4a370c75506fac2f4bc35df99be30c"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python3-path.version "8.1"; python3-path) ];
  };

  "python3-pillow" = fetch {
    pname       = "python3-pillow";
    version     = "5.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pillow-5.3.0-1-any.pkg.tar.xz"; sha256 = "08ab42446c1fedd9f96821ff2bea9dc2b80a6d67e7af23e08a7af285283f43c3"; }];
    buildInputs = [ freetype lcms2 libjpeg libtiff libwebp openjpeg2 zlib python3 python3-olefile ];
  };

  "python3-pip" = fetch {
    pname       = "python3-pip";
    version     = "18.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-pip-18.1-2-any.pkg.tar.xz"; sha256 = "f1167670d1dfd9d7fede46384ee6ef7a0feb83f7ff5deb6a4816c36f91a55e9f"; }];
    buildInputs = [ python3-setuptools python3-appdirs python3-cachecontrol python3-colorama python3-distlib python3-html5lib python3-lockfile python3-msgpack python3-packaging python3-pep517 python3-progress python3-pyparsing python3-pytoml python3-requests python3-retrying python3-six python3-webencodings ];
  };

  "python3-pkginfo" = fetch {
    pname       = "python3-pkginfo";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pkginfo-1.4.2-1-any.pkg.tar.xz"; sha256 = "5c41774936f32bd58523b774459acfc00078a481fab2ffe90104bce811c0b6d1"; }];
    buildInputs = [ python3 ];
  };

  "python3-pluggy" = fetch {
    pname       = "python3-pluggy";
    version     = "0.8.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pluggy-0.8.0-2-any.pkg.tar.xz"; sha256 = "bdb05be48e18665f44db3d6be273816e3230115d888fed2437139f117c3b6ad1"; }];
    buildInputs = [ python3 ];
  };

  "python3-ply" = fetch {
    pname       = "python3-ply";
    version     = "3.11";
    srcs        = [{ filename = "mingw-w64-i686-python3-ply-3.11-2-any.pkg.tar.xz"; sha256 = "6fc0e465e45cbd6c6707989366189428dfb6f4a710516c79b82b202350b74952"; }];
    buildInputs = [ python3 ];
  };

  "python3-pptx" = fetch {
    pname       = "python3-pptx";
    version     = "0.6.10";
    srcs        = [{ filename = "mingw-w64-i686-python3-pptx-0.6.10-1-any.pkg.tar.xz"; sha256 = "451aea8d43f4a2b3ccc4a9710ca64f3152b1a59dbd321bb1e2f393f6bc462dc0"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python3-lxml.version "3.1.0"; python3-lxml) (assert stdenvNoCC.lib.versionAtLeast python3-pillow.version "2.6.1"; python3-pillow) (assert stdenvNoCC.lib.versionAtLeast python3-xlsxwriter.version "0.5.7"; python3-xlsxwriter) ];
  };

  "python3-pretend" = fetch {
    pname       = "python3-pretend";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-i686-python3-pretend-1.0.9-2-any.pkg.tar.xz"; sha256 = "e67893cfb9e2c78f6c9903cc4cc643d8bf9a1f966e6f1fa1d4f12ecbb8971609"; }];
    buildInputs = [ python3 ];
  };

  "python3-prettytable" = fetch {
    pname       = "python3-prettytable";
    version     = "0.7.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-prettytable-0.7.2-2-any.pkg.tar.xz"; sha256 = "2faffb0fe0d7274f612a245e254cb68ab624938dda2304e2f86eb2a28b8c00de"; }];
    buildInputs = [ python3 ];
  };

  "python3-progress" = fetch {
    pname       = "python3-progress";
    version     = "1.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-progress-1.4-3-any.pkg.tar.xz"; sha256 = "eb3890380c2c6c01b7a873d686cd639d44ba0ac3e69aee79267d507d06c87983"; }];
    buildInputs = [ python3 ];
  };

  "python3-prometheus-client" = fetch {
    pname       = "python3-prometheus-client";
    version     = "0.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-prometheus-client-0.2.0-1-any.pkg.tar.xz"; sha256 = "db9353ff1a724a062ceca256f4a0f0ca265623fb976d09da29d765d4000d7470"; }];
    buildInputs = [ python3 ];
  };

  "python3-prompt_toolkit" = fetch {
    pname       = "python3-prompt_toolkit";
    version     = "2.0.7";
    srcs        = [{ filename = "mingw-w64-i686-python3-prompt_toolkit-2.0.7-1-any.pkg.tar.xz"; sha256 = "25c8afe447f944160d25aefa9d848b006d07d085d20d3ec6ccdb9f78d0cb5a5f"; }];
    buildInputs = [ python3-pygments python3-six python3-wcwidth ];
  };

  "python3-psutil" = fetch {
    pname       = "python3-psutil";
    version     = "5.4.8";
    srcs        = [{ filename = "mingw-w64-i686-python3-psutil-5.4.8-1-any.pkg.tar.xz"; sha256 = "adba6f28adc1428730f4e4dc1e8fab21b19d97cfe1620ae7bae04ba46dbff1d8"; }];
    buildInputs = [ python3 ];
  };

  "python3-psycopg2" = fetch {
    pname       = "python3-psycopg2";
    version     = "2.7.6.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-psycopg2-2.7.6.1-1-any.pkg.tar.xz"; sha256 = "f6cacc78710b0193c3cd8b47f7ce34f0871e61f1ca3a44c64c5008f8a182e4bf"; }];
    buildInputs = [ python3 ];
  };

  "python3-ptyprocess" = fetch {
    pname       = "python3-ptyprocess";
    version     = "0.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-ptyprocess-0.6.0-1-any.pkg.tar.xz"; sha256 = "11238107eda57fb5463d6143188ea9d3a100bc87790f68bae3436b22f7831877"; }];
    buildInputs = [ python3 ];
  };

  "python3-py" = fetch {
    pname       = "python3-py";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-py-1.7.0-1-any.pkg.tar.xz"; sha256 = "246bb3d38a9e6a7eedd46a1e10bbda2d89a2e8249fc0f4f33ad398fa098bbffb"; }];
    buildInputs = [ python3 ];
  };

  "python3-py-cpuinfo" = fetch {
    pname       = "python3-py-cpuinfo";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-py-cpuinfo-4.0.0-1-any.pkg.tar.xz"; sha256 = "1fdb2d351b755fbeeeb6845c40f86d67d90dbeff5ca895b0a265df0806bdd185"; }];
    buildInputs = [ python3 ];
  };

  "python3-pyamg" = fetch {
    pname       = "python3-pyamg";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyamg-4.0.0-1-any.pkg.tar.xz"; sha256 = "4a1a2903a61041a260973d512726a40adc670bcc87b261568447d9657b348afb"; }];
    buildInputs = [ python3 python3-scipy python3-numpy ];
  };

  "python3-pyasn1" = fetch {
    pname       = "python3-pyasn1";
    version     = "0.4.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyasn1-0.4.4-1-any.pkg.tar.xz"; sha256 = "c81c357aa5a00461c7e63488028b9ec2bcdd4ecc34c022cc8d1dcd219e9d7668"; }];
    buildInputs = [  ];
  };

  "python3-pyasn1-modules" = fetch {
    pname       = "python3-pyasn1-modules";
    version     = "0.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyasn1-modules-0.2.2-1-any.pkg.tar.xz"; sha256 = "8535f68bd4535fe2bc2c254b808e1ac03076e39bc7dd7953d838f47fdae6e89e"; }];
  };

  "python3-pycodestyle" = fetch {
    pname       = "python3-pycodestyle";
    version     = "2.4.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pycodestyle-2.4.0-1-any.pkg.tar.xz"; sha256 = "753e87cf96c95295ba638217c8cbdfa9f33d1ad6f7fabea8c247cc85fef2ba8a"; }];
    buildInputs = [ python3 ];
  };

  "python3-pycparser" = fetch {
    pname       = "python3-pycparser";
    version     = "2.19";
    srcs        = [{ filename = "mingw-w64-i686-python3-pycparser-2.19-1-any.pkg.tar.xz"; sha256 = "59e704957891abe7de39d693ff40d139bc408a80f317a1c01f5ddb8e3430998e"; }];
    buildInputs = [ python3 python3-ply ];
  };

  "python3-pyflakes" = fetch {
    pname       = "python3-pyflakes";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyflakes-2.0.0-2-any.pkg.tar.xz"; sha256 = "30730c781a01fcc56ed8a4df6aadf36a47a278157c0604c873648364f69dd1d0"; }];
    buildInputs = [ python3 ];
  };

  "python3-pyglet" = fetch {
    pname       = "python3-pyglet";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyglet-1.3.2-1-any.pkg.tar.xz"; sha256 = "dc23312d2e36c1ed671baa54317ee635aeec16f08a5339bbbc0f9df5ba49ef42"; }];
    buildInputs = [ python3 python3-future ];
  };

  "python3-pygments" = fetch {
    pname       = "python3-pygments";
    version     = "2.3.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-pygments-2.3.1-1-any.pkg.tar.xz"; sha256 = "3ad8c085da96e18db70e0dbdc372da2f617c8deb30db0617365a405294ae7f2a"; }];
    buildInputs = [ python3-setuptools ];
  };

  "python3-pylint" = fetch {
    pname       = "python3-pylint";
    version     = "2.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pylint-2.2.2-1-any.pkg.tar.xz"; sha256 = "dba74aa59b8e41300473e2235a29a29e4ea5d6b5b89c4409b5e6b373eb0369b4"; }];
    buildInputs = [ python3-astroid python3-colorama python3-mccabe python3-isort ];
  };

  "python3-pynacl" = fetch {
    pname       = "python3-pynacl";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pynacl-1.3.0-1-any.pkg.tar.xz"; sha256 = "9d47296a324ae7db47de87d23d0f0651061d2fab49b187e65ee55de16e2034bc"; }];
    buildInputs = [ python3 ];
  };

  "python3-pyopenssl" = fetch {
    pname       = "python3-pyopenssl";
    version     = "18.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyopenssl-18.0.0-3-any.pkg.tar.xz"; sha256 = "831cda4deb864021efbfc8081a35f2dd2d7d467c720d4c01242c463c63f8b645"; }];
    buildInputs = [ openssl python3-cryptography python3-six ];
  };

  "python3-pyparsing" = fetch {
    pname       = "python3-pyparsing";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyparsing-2.3.0-1-any.pkg.tar.xz"; sha256 = "a386a2d1cc4801541d70404bf4d8d73f9f5e4ca2778e168e5f465c27ce5bd435"; }];
    buildInputs = [ python3 ];
  };

  "python3-pyperclip" = fetch {
    pname       = "python3-pyperclip";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyperclip-1.7.0-1-any.pkg.tar.xz"; sha256 = "249fa9fca192a2ebe4a0b0ef9f251f5c7100ecda989f7170c2cf850250a281f8"; }];
    buildInputs = [ python3 ];
  };

  "python3-pyqt4" = fetch {
    pname       = "python3-pyqt4";
    version     = "4.11.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyqt4-4.11.4-2-any.pkg.tar.xz"; sha256 = "5d02156800c845d151cee8f17a2551fb78d8f652df0305f5bb1d42f9a8365da6"; }];
    buildInputs = [ python3-sip pyqt4-common python3 ];
  };

  "python3-pyqt5" = fetch {
    pname       = "python3-pyqt5";
    version     = "5.11.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyqt5-5.11.3-1-any.pkg.tar.xz"; sha256 = "5c1705f2ef58af177bc029fbfe40fdea1096b727b1fb64e0fdd498043627c3d6"; }];
    buildInputs = [ python3-sip pyqt5-common python3 ];
  };

  "python3-pyreadline" = fetch {
    pname       = "python3-pyreadline";
    version     = "2.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyreadline-2.1-1-any.pkg.tar.xz"; sha256 = "dec1442a0d28a7aa0e26c03cf5fbabc24d883e723b9f7ed733831f23ce5d5fc2"; }];
    buildInputs = [ python3 ];
  };

  "python3-pyrsistent" = fetch {
    pname       = "python3-pyrsistent";
    version     = "0.14.9";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyrsistent-0.14.9-1-any.pkg.tar.xz"; sha256 = "8696752443651da79ac4c8eabdc907a61551f89499609fcae45ec068ca527ee8"; }];
    buildInputs = [ python3 python3-six ];
  };

  "python3-pyserial" = fetch {
    pname       = "python3-pyserial";
    version     = "3.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyserial-3.4-1-any.pkg.tar.xz"; sha256 = "fe92ebde2eb410a98e74ae4414f35ded2ebc2fc7ebbab6a272b3b866d1ba603b"; }];
    buildInputs = [ python3 ];
  };

  "python3-pyside-qt4" = fetch {
    pname       = "python3-pyside-qt4";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyside-qt4-1.2.2-3-any.pkg.tar.xz"; sha256 = "2364f2bf3c5870a6ad0af1b549856a5af287285c5c798faf6d45c33f2be6811b"; }];
    buildInputs = [ pyside-common-qt4 python3 python3-shiboken-qt4 qt4 ];
  };

  "python3-pyside-tools-qt4" = fetch {
    pname       = "python3-pyside-tools-qt4";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyside-tools-qt4-1.2.2-3-any.pkg.tar.xz"; sha256 = "0c75e29a3449dcfc3cb2d33edd31eac4b155b2c078035106fa7e09192b74599d"; }];
    buildInputs = [ pyside-tools-common-qt4 python3-pyside-qt4 ];
  };

  "python3-pysocks" = fetch {
    pname       = "python3-pysocks";
    version     = "1.6.8";
    srcs        = [{ filename = "mingw-w64-i686-python3-pysocks-1.6.8-1-any.pkg.tar.xz"; sha256 = "9309c515ef48c0aada5b560a3e0cc98b62e767aae945c3fedf87f05f51246d0e"; }];
    buildInputs = [ python3 python3-win_inet_pton ];
  };

  "python3-pystemmer" = fetch {
    pname       = "python3-pystemmer";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pystemmer-1.3.0-2-any.pkg.tar.xz"; sha256 = "226f0b80084bd34147b321e982b18bbf4cff178814b82d4551636e6132a34f38"; }];
    buildInputs = [ python3 ];
  };

  "python3-pytest" = fetch {
    pname       = "python3-pytest";
    version     = "4.0.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pytest-4.0.2-1-any.pkg.tar.xz"; sha256 = "f28ce8d20b87a73ee97f10d30715dd04d78cf695c91c2042ca5078119effa763"; }];
    buildInputs = [ python3-py python3-pluggy python3-setuptools python3-colorama python3-six python3-atomicwrites python3-more-itertools python3-attrs ];
  };

  "python3-pytest-benchmark" = fetch {
    pname       = "python3-pytest-benchmark";
    version     = "3.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pytest-benchmark-3.2.0-1-any.pkg.tar.xz"; sha256 = "8b81eb6c9dc024ab99ba75c5a9ee270eacb19fbacbfce8444f15aba0feda429a"; }];
    buildInputs = [ python3 python3-py-cpuinfo python3-pytest ];
  };

  "python3-pytest-cov" = fetch {
    pname       = "python3-pytest-cov";
    version     = "2.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pytest-cov-2.6.0-1-any.pkg.tar.xz"; sha256 = "edf119f944d4a3ef46732bd0e0753fe4eb2230fec27e92944db513c08e5f8ec6"; }];
    buildInputs = [ python3 python3-coverage python3-pytest ];
  };

  "python3-pytest-expect" = fetch {
    pname       = "python3-pytest-expect";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pytest-expect-1.1.0-1-any.pkg.tar.xz"; sha256 = "25e09552286d466d3fd8c00679d4792e936547b67e4356edde20ef06c66e32e7"; }];
    buildInputs = [ python3 python3-pytest python3-u-msgpack ];
  };

  "python3-pytest-forked" = fetch {
    pname       = "python3-pytest-forked";
    version     = "0.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pytest-forked-0.2-1-any.pkg.tar.xz"; sha256 = "8bbb423e30cc0db7f71d7fff26cede449b1d9c1798120e85d0422534110a78d5"; }];
    buildInputs = [ python3 python3-pytest ];
  };

  "python3-pytest-runner" = fetch {
    pname       = "python3-pytest-runner";
    version     = "4.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pytest-runner-4.2-4-any.pkg.tar.xz"; sha256 = "a9f87994384566a19cd3c4f4273a18cebd25f6228c16447b0248afe078a8eb08"; }];
    buildInputs = [ python3 python3-pytest ];
  };

  "python3-pytest-xdist" = fetch {
    pname       = "python3-pytest-xdist";
    version     = "1.25.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-pytest-xdist-1.25.0-1-any.pkg.tar.xz"; sha256 = "154cb5b7c554e5b9f2748def89e292182c74ce192853e7ae5287fe448c1eb04e"; }];
    buildInputs = [ python3 python3-pytest-forked python3-execnet ];
  };

  "python3-python_ics" = fetch {
    pname       = "python3-python_ics";
    version     = "2.15";
    srcs        = [{ filename = "mingw-w64-i686-python3-python_ics-2.15-1-any.pkg.tar.xz"; sha256 = "08716e3266e905b37890457709e2de1f55c079f82439235aa0279cd87bfa36da"; }];
    buildInputs = [ python3 ];
  };

  "python3-pytoml" = fetch {
    pname       = "python3-pytoml";
    version     = "0.1.20";
    srcs        = [{ filename = "mingw-w64-i686-python3-pytoml-0.1.20-1-any.pkg.tar.xz"; sha256 = "df82ca81733eb8ac2def52609e5f38d3ad0430b01904c3227537c9eefb48f1cd"; }];
    buildInputs = [ python3 ];
  };

  "python3-pytz" = fetch {
    pname       = "python3-pytz";
    version     = "2018.9";
    srcs        = [{ filename = "mingw-w64-i686-python3-pytz-2018.9-1-any.pkg.tar.xz"; sha256 = "df1e7c59d8cdea153c22d645eaf8386a5f9f7a44a5f81d381fc35d02c304dc34"; }];
    buildInputs = [ python3 ];
  };

  "python3-pyu2f" = fetch {
    pname       = "python3-pyu2f";
    version     = "0.1.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyu2f-0.1.4-1-any.pkg.tar.xz"; sha256 = "7aebb364eb2508707a8d932ef7b64730ccc21a5ed3bf28cd93fb7ec1200ea6cd"; }];
    buildInputs = [ python3 ];
  };

  "python3-pywavelets" = fetch {
    pname       = "python3-pywavelets";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-pywavelets-1.0.1-1-any.pkg.tar.xz"; sha256 = "4681f8aae76e8e54dd2aa2c27e27614e8cead41cffa874689e574e50ab3bc599"; }];
    buildInputs = [ python3-numpy python3 ];
  };

  "python3-pyzmq" = fetch {
    pname       = "python3-pyzmq";
    version     = "17.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyzmq-17.1.2-1-any.pkg.tar.xz"; sha256 = "0a5b51946cb3f6ebba92f9206e1a7a43f3da67925a963ecd317425a4003a2bee"; }];
    buildInputs = [ python3 zeromq ];
  };

  "python3-pyzopfli" = fetch {
    pname       = "python3-pyzopfli";
    version     = "0.1.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-pyzopfli-0.1.4-1-any.pkg.tar.xz"; sha256 = "320fe4a82cf8915a1f6126d4b8ba342251bf39d072ac223d8d11c0630e199b86"; }];
    buildInputs = [ python3 ];
  };

  "python3-qscintilla" = fetch {
    pname       = "python3-qscintilla";
    version     = "2.10.8";
    srcs        = [{ filename = "mingw-w64-i686-python3-qscintilla-2.10.8-1-any.pkg.tar.xz"; sha256 = "71d5feb7fc038734b6a231fa90e6958eebdd8f96c6b83d3f3dea7a92e49dc9ab"; }];
    buildInputs = [ python-qscintilla-common python3-pyqt5 ];
  };

  "python3-qtconsole" = fetch {
    pname       = "python3-qtconsole";
    version     = "4.4.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-qtconsole-4.4.1-1-any.pkg.tar.xz"; sha256 = "ba91f52103eb9acaf3bf4e48b7f3c9508baf2859b21778a704f92dfbe66c8824"; }];
    buildInputs = [ python3 python3-jupyter_core python3-jupyter_client python3-pyqt5 ];
  };

  "python3-rencode" = fetch {
    pname       = "python3-rencode";
    version     = "1.0.6";
    srcs        = [{ filename = "mingw-w64-i686-python3-rencode-1.0.6-1-any.pkg.tar.xz"; sha256 = "3ebd66e3d62973e0853f7013cb02e9bcea2ffc0156b8c1f8f185408a4547a403"; }];
    buildInputs = [ python3 ];
  };

  "python3-reportlab" = fetch {
    pname       = "python3-reportlab";
    version     = "3.5.12";
    srcs        = [{ filename = "mingw-w64-i686-python3-reportlab-3.5.12-1-any.pkg.tar.xz"; sha256 = "b1a5a0aa8ecafc9a70dd404435dcb0be5b6ae06b3b666de78e14b798e4f7c3cc"; }];
    buildInputs = [ freetype python3-pip python3-Pillow ];
    broken      = true; # broken dependency python3-reportlab -> python3-Pillow
  };

  "python3-requests" = fetch {
    pname       = "python3-requests";
    version     = "2.21.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-requests-2.21.0-1-any.pkg.tar.xz"; sha256 = "c0b1071ed9af280b77a26893202529ffb0b4654a148446664a6e492902086c15"; }];
    buildInputs = [ python3-urllib3 python3-chardet python3-idna ];
  };

  "python3-requests-kerberos" = fetch {
    pname       = "python3-requests-kerberos";
    version     = "0.12.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-requests-kerberos-0.12.0-1-any.pkg.tar.xz"; sha256 = "354ae454e79871a07a4f7c7255c01e8093687fe986d6fa4202ad88cc9d3b4061"; }];
    buildInputs = [ python3 python3-cryptography python3-winkerberos ];
  };

  "python3-retrying" = fetch {
    pname       = "python3-retrying";
    version     = "1.3.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-retrying-1.3.3-1-any.pkg.tar.xz"; sha256 = "f0d0bf12190206e87bc458d315f29fba62fc709a7dda2a2c40d578a1b4353690"; }];
    buildInputs = [ python3 ];
  };

  "python3-rfc3986" = fetch {
    pname       = "python3-rfc3986";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-rfc3986-1.2.0-1-any.pkg.tar.xz"; sha256 = "6f764c657c1a78494ca1b5c43520e20bc6d31b260b5ad6df77ff028e5c2a5f50"; }];
    buildInputs = [ python3 ];
  };

  "python3-rfc3987" = fetch {
    pname       = "python3-rfc3987";
    version     = "1.3.8";
    srcs        = [{ filename = "mingw-w64-i686-python3-rfc3987-1.3.8-1-any.pkg.tar.xz"; sha256 = "2093d4e07df16212adf1f2c0b64f8661f7a5bc12fb8bd59f55756623d1bc253f"; }];
    buildInputs = [ python3 ];
  };

  "python3-rst2pdf" = fetch {
    pname       = "python3-rst2pdf";
    version     = "0.93";
    srcs        = [{ filename = "mingw-w64-i686-python3-rst2pdf-0.93-4-any.pkg.tar.xz"; sha256 = "535e45364363779eed3860bca8b63cbadc952fb4be746483159116c4467a2541"; }];
    buildInputs = [ python3 python3-docutils python3-pdfrw python3-pygments (assert stdenvNoCC.lib.versionAtLeast python3-reportlab.version "2.4"; python3-reportlab) python3-setuptools ];
    broken      = true; # broken dependency python3-reportlab -> python3-Pillow
  };

  "python3-scandir" = fetch {
    pname       = "python3-scandir";
    version     = "1.9.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-scandir-1.9.0-1-any.pkg.tar.xz"; sha256 = "a36cc3482b0173b6c1523c9affe292649a4a176c68ae643b90f3678e0b292b32"; }];
    buildInputs = [ python3 ];
  };

  "python3-scikit-learn" = fetch {
    pname       = "python3-scikit-learn";
    version     = "0.20.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-scikit-learn-0.20.2-1-any.pkg.tar.xz"; sha256 = "b20dd5b8f414aee5b4867f05ad1e4f4bc814373c67a8965c4f03c758ae7c59fa"; }];
    buildInputs = [ python3 python3-scipy ];
  };

  "python3-scipy" = fetch {
    pname       = "python3-scipy";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-scipy-1.2.0-1-any.pkg.tar.xz"; sha256 = "937d592c05a327c65e5e106b75d9646cf1d1ca9c0ca4dbceab2c8ae792235441"; }];
    buildInputs = [ gcc-libgfortran openblas python3-numpy ];
  };

  "python3-send2trash" = fetch {
    pname       = "python3-send2trash";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-send2trash-1.5.0-2-any.pkg.tar.xz"; sha256 = "b75f587cc942275d7c4b6c37f895a123280b721aa00051072cb142482bcdcfba"; }];
    buildInputs = [ python3 ];
  };

  "python3-setproctitle" = fetch {
    pname       = "python3-setproctitle";
    version     = "1.1.10";
    srcs        = [{ filename = "mingw-w64-i686-python3-setproctitle-1.1.10-1-any.pkg.tar.xz"; sha256 = "37c1cea1a1d79565e786446e182eddb6980ce31901ce19f1a183ed64eb7fc9c8"; }];
    buildInputs = [ python3 ];
  };

  "python3-setuptools" = fetch {
    pname       = "python3-setuptools";
    version     = "40.6.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-setuptools-40.6.3-1-any.pkg.tar.xz"; sha256 = "66150cea6158fe1116932d351e18e04589e59c8f9dc63ed5f29d801990c11dcd"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python3.version "3.3"; python3) python3-packaging python3-pyparsing python3-appdirs python3-six ];
  };

  "python3-setuptools-git" = fetch {
    pname       = "python3-setuptools-git";
    version     = "1.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-setuptools-git-1.2-1-any.pkg.tar.xz"; sha256 = "58988256773543688ba5c79e8ca1082a8c55eae45b34399fd6fdbed5e27a6081"; }];
    buildInputs = [ python3 python3-setuptools git ];
    broken      = true; # broken dependency python3-setuptools-git -> git
  };

  "python3-setuptools-scm" = fetch {
    pname       = "python3-setuptools-scm";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-setuptools-scm-3.1.0-1-any.pkg.tar.xz"; sha256 = "d25054e65df59f6a98af24254c4265e3c8c24a5b2ba5a2f4ddd03d026e6b70a0"; }];
    buildInputs = [ python3-setuptools ];
  };

  "python3-shiboken-qt4" = fetch {
    pname       = "python3-shiboken-qt4";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-shiboken-qt4-1.2.2-3-any.pkg.tar.xz"; sha256 = "07fe678ccce67902a8c11243f25f125d1042d2a0d64679ce5a776e11d325fd25"; }];
    buildInputs = [ libxml2 libxslt python3 shiboken-qt4 qt4 ];
  };

  "python3-simplegeneric" = fetch {
    pname       = "python3-simplegeneric";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-simplegeneric-0.8.1-4-any.pkg.tar.xz"; sha256 = "4a6971955d9ae8bcb6e00e69ad65aeadfb6a5723a1017e821b9653f164c7fdd5"; }];
    buildInputs = [ python3 ];
  };

  "python3-sip" = fetch {
    pname       = "python3-sip";
    version     = "4.19.13";
    srcs        = [{ filename = "mingw-w64-i686-python3-sip-4.19.13-2-any.pkg.tar.xz"; sha256 = "9d2fd9e10bbf8d1568498a5e22d0d8cdcfa81c8086f6ba5e2e0cf131fdaec1cb"; }];
    buildInputs = [ sip python3 ];
  };

  "python3-six" = fetch {
    pname       = "python3-six";
    version     = "1.12.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-six-1.12.0-1-any.pkg.tar.xz"; sha256 = "9e319fc670a1023f0f237185d799a246b4a3d3d40ee3dcbf68b6bd8ec49db541"; }];
    buildInputs = [ python3 ];
  };

  "python3-snowballstemmer" = fetch {
    pname       = "python3-snowballstemmer";
    version     = "1.2.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-snowballstemmer-1.2.1-3-any.pkg.tar.xz"; sha256 = "99ad54f898a1f8966cb5974dc0b6a4f8a14680f8bbed223196a53be2b3bb1128"; }];
    buildInputs = [ python3 ];
  };

  "python3-soupsieve" = fetch {
    pname       = "python3-soupsieve";
    version     = "1.6.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-soupsieve-1.6.2-1-any.pkg.tar.xz"; sha256 = "6f6313117ecdb3ff3b6533fffe1b58abc5a4cf67907637d78a7538fddc068cec"; }];
    buildInputs = [ python3 ];
  };

  "python3-sphinx" = fetch {
    pname       = "python3-sphinx";
    version     = "1.8.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-sphinx-1.8.3-1-any.pkg.tar.xz"; sha256 = "660784a3656099f8712082cf8285d329bf4d731bb9a9867ca96f54711740451f"; }];
    buildInputs = [ python3-babel python3-certifi python3-chardet python3-colorama python3-docutils python3-idna python3-imagesize python3-jinja python3-packaging python3-pygments python3-requests python3-sphinx_rtd_theme python3-snowballstemmer python3-sphinx-alabaster-theme python3-sphinxcontrib-websupport python3-six python3-sqlalchemy python3-urllib3 python3-whoosh ];
  };

  "python3-sphinx-alabaster-theme" = fetch {
    pname       = "python3-sphinx-alabaster-theme";
    version     = "0.7.11";
    srcs        = [{ filename = "mingw-w64-i686-python3-sphinx-alabaster-theme-0.7.11-1-any.pkg.tar.xz"; sha256 = "4db79e7a9baf6dc2e8f311fb78236409c676f521c04bbd010885f0a0fcca4537"; }];
    buildInputs = [ python3 ];
  };

  "python3-sphinx_rtd_theme" = fetch {
    pname       = "python3-sphinx_rtd_theme";
    version     = "0.4.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-sphinx_rtd_theme-0.4.1-1-any.pkg.tar.xz"; sha256 = "a1f3e382029946fe531a4695b05770add90da4aca0fc1d2f9d00a26ab839e046"; }];
    buildInputs = [ python3 ];
  };

  "python3-sphinxcontrib-websupport" = fetch {
    pname       = "python3-sphinxcontrib-websupport";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-sphinxcontrib-websupport-1.1.0-2-any.pkg.tar.xz"; sha256 = "20bb10f54d40010e5ea0316df8ef03119085cd1bca0fd019605fd7dc20511bce"; }];
    buildInputs = [ python3 ];
  };

  "python3-sqlalchemy" = fetch {
    pname       = "python3-sqlalchemy";
    version     = "1.2.15";
    srcs        = [{ filename = "mingw-w64-i686-python3-sqlalchemy-1.2.15-1-any.pkg.tar.xz"; sha256 = "ae612f7607b8cfc8e59bf953b07520794a6a3a8d69a39d2b19123557e5b4a9ef"; }];
    buildInputs = [ python3 ];
  };

  "python3-sqlalchemy-migrate" = fetch {
    pname       = "python3-sqlalchemy-migrate";
    version     = "0.11.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-sqlalchemy-migrate-0.11.0-1-any.pkg.tar.xz"; sha256 = "e18d8977a0d75c828b1f5036fac2d687ec9cf2825df802e68e4ab0efe86a85ed"; }];
    buildInputs = [ python3 python3-six python3-pbr python3-sqlalchemy python3-decorator python3-sqlparse python3-tempita ];
  };

  "python3-sqlitedict" = fetch {
    pname       = "python3-sqlitedict";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-sqlitedict-1.6.0-1-any.pkg.tar.xz"; sha256 = "72c14f2820c102c2816b36f03ce7f4712cb32c1d013016bcb0912b4f9ad399cf"; }];
    buildInputs = [ python3 sqlite3 ];
  };

  "python3-sqlparse" = fetch {
    pname       = "python3-sqlparse";
    version     = "0.2.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-sqlparse-0.2.4-1-any.pkg.tar.xz"; sha256 = "0d897434ab798a41f77a1b84d79f1c5955c85f44c5abfdfce766e36e96db753a"; }];
    buildInputs = [ python3 ];
  };

  "python3-statsmodels" = fetch {
    pname       = "python3-statsmodels";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-statsmodels-0.9.0-1-any.pkg.tar.xz"; sha256 = "85af3bb28661e5c5291c95661b9f2067a49272df02d7b8981e8718116996eaa1"; }];
    buildInputs = [ python3-scipy python3-pandas python3-patsy ];
  };

  "python3-stestr" = fetch {
    pname       = "python3-stestr";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-stestr-2.2.0-1-any.pkg.tar.xz"; sha256 = "4ce0aedf41928a98099b483131683858481d6037cff5c9b835290ddaf7916a57"; }];
    buildInputs = [ python3 python3-cliff python3-fixtures python3-future python3-pbr python3-six python3-subunit python3-testtools python3-voluptuous python3-yaml ];
  };

  "python3-stevedore" = fetch {
    pname       = "python3-stevedore";
    version     = "1.30.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-stevedore-1.30.0-1-any.pkg.tar.xz"; sha256 = "d96f45bed8129e41b1bf8985e57c6ead10224a19ec33c02e9770b54703d54bf5"; }];
    buildInputs = [ python3 python3-six ];
  };

  "python3-strict-rfc3339" = fetch {
    pname       = "python3-strict-rfc3339";
    version     = "0.7";
    srcs        = [{ filename = "mingw-w64-i686-python3-strict-rfc3339-0.7-1-any.pkg.tar.xz"; sha256 = "91f446735267273482a358393c3fd6c14d5706b7f84511d038cfce05c7bb2cb1"; }];
    buildInputs = [ python3 ];
  };

  "python3-subunit" = fetch {
    pname       = "python3-subunit";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-subunit-1.3.0-2-any.pkg.tar.xz"; sha256 = "60e42e2da4e83f75f351d2a932751e2f05f26a1c116399fde930947453b9ebe2"; }];
    buildInputs = [ python3 python3-extras python3-testtools ];
  };

  "python3-sympy" = fetch {
    pname       = "python3-sympy";
    version     = "1.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-sympy-1.3-1-any.pkg.tar.xz"; sha256 = "da73527cb1df85cec5066dccc23fd8db7ef76c2f6b8b9e8a26c977708efe7ae9"; }];
    buildInputs = [ python3 python3-mpmath ];
  };

  "python3-tempita" = fetch {
    pname       = "python3-tempita";
    version     = "0.5.3dev20170202";
    srcs        = [{ filename = "mingw-w64-i686-python3-tempita-0.5.3dev20170202-1-any.pkg.tar.xz"; sha256 = "8ab22d03850cacd015b8908df9e6cc69559153886dd0913410891fe4efa0cd0d"; }];
    buildInputs = [ python3 ];
  };

  "python3-terminado" = fetch {
    pname       = "python3-terminado";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-terminado-0.8.1-2-any.pkg.tar.xz"; sha256 = "3f0261ecea7a305b8c8865a617ab2b66156e116399d616602811542521cd6a4b"; }];
    buildInputs = [ python3 python3-tornado python3-ptyprocess ];
  };

  "python3-testpath" = fetch {
    pname       = "python3-testpath";
    version     = "0.4.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-testpath-0.4.2-1-any.pkg.tar.xz"; sha256 = "be064a81c7b525c27edbe8a208822169c6e81b1a10c654e2f1b7f572cc5ff223"; }];
    buildInputs = [ python3 ];
  };

  "python3-testrepository" = fetch {
    pname       = "python3-testrepository";
    version     = "0.0.20";
    srcs        = [{ filename = "mingw-w64-i686-python3-testrepository-0.0.20-1-any.pkg.tar.xz"; sha256 = "d49ff2f4c085d70740c4ef4077fd785e81ef708054c001aab709eb9d697fe7e6"; }];
    buildInputs = [ python3 ];
  };

  "python3-testresources" = fetch {
    pname       = "python3-testresources";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-testresources-2.0.1-1-any.pkg.tar.xz"; sha256 = "f4edb5d3a601b7bd36b22a5f25bd614123903aec45cb7f80a46667163e64910a"; }];
    buildInputs = [ python3 ];
  };

  "python3-testscenarios" = fetch {
    pname       = "python3-testscenarios";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-testscenarios-0.5.0-1-any.pkg.tar.xz"; sha256 = "da0b729baf5563963df08f913ad2e3e8c9af4354dbc6de37d7f901342259e354"; }];
    buildInputs = [ python3 ];
  };

  "python3-testtools" = fetch {
    pname       = "python3-testtools";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-testtools-2.3.0-1-any.pkg.tar.xz"; sha256 = "e10fb210a4c3c67ffc8d18154b97a9274e20ed8416e1aeee9443ae6ad3d860c0"; }];
    buildInputs = [ python3 python3-pbr python3-extras python3-fixtures python3-pyrsistent python3-mimeparse ];
  };

  "python3-text-unidecode" = fetch {
    pname       = "python3-text-unidecode";
    version     = "1.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-text-unidecode-1.2-1-any.pkg.tar.xz"; sha256 = "6319cb20084a14a7826b598884bedc2c710a7d8cb2d086275fc6179836777f1f"; }];
    buildInputs = [ python3 ];
  };

  "python3-toml" = fetch {
    pname       = "python3-toml";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-toml-0.10.0-1-any.pkg.tar.xz"; sha256 = "cc231b1901fc64e68ecf0f249659c64a7cab7cc6a94bca67929abf0607e54f49"; }];
    buildInputs = [ python3 ];
  };

  "python3-tornado" = fetch {
    pname       = "python3-tornado";
    version     = "5.1.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-tornado-5.1.1-2-any.pkg.tar.xz"; sha256 = "ad8699600b076598c2ce4a3b92ffcf4bfe99ec7af90f25456b252ec7836e77d6"; }];
    buildInputs = [ python3 ];
  };

  "python3-tox" = fetch {
    pname       = "python3-tox";
    version     = "3.6.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-tox-3.6.1-1-any.pkg.tar.xz"; sha256 = "255472511c3cc871c4e146b01c412140e57cea691a78419b5fa2953514131d99"; }];
    buildInputs = [ python3 python3-py python2-six python3-virtualenv python3-setuptools python3-setuptools-scm python3-filelock python3-toml python3-pluggy ];
  };

  "python3-traitlets" = fetch {
    pname       = "python3-traitlets";
    version     = "4.3.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-traitlets-4.3.2-3-any.pkg.tar.xz"; sha256 = "86fa09f52f80e2619c7d945c3349d70d4f634e9ddf3126cd4789c81732b4ef44"; }];
    buildInputs = [ python3-ipython_genutils python3-decorator ];
  };

  "python3-u-msgpack" = fetch {
    pname       = "python3-u-msgpack";
    version     = "2.5.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-u-msgpack-2.5.0-1-any.pkg.tar.xz"; sha256 = "fcf2914b955b76da8232540c5c554cd2b2b285254802995fdbf4f1bffb43d357"; }];
    buildInputs = [ python3 ];
  };

  "python3-udsoncan" = fetch {
    pname       = "python3-udsoncan";
    version     = "1.6";
    srcs        = [{ filename = "mingw-w64-i686-python3-udsoncan-1.6-1-any.pkg.tar.xz"; sha256 = "72edf7f23231fa6f2e2adf4d67e39b4fcbe9ffe484134c9d972d19de433cb5b2"; }];
    buildInputs = [ python3 ];
  };

  "python3-ukpostcodeparser" = fetch {
    pname       = "python3-ukpostcodeparser";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-ukpostcodeparser-1.1.2-1-any.pkg.tar.xz"; sha256 = "78b135db41bffa4f6ef900de6c1b2f416eeaf75369d426684d00cd306fe7f0ef"; }];
    buildInputs = [ python3 ];
  };

  "python3-unicorn" = fetch {
    pname       = "python3-unicorn";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-unicorn-1.0.1-3-any.pkg.tar.xz"; sha256 = "ace688a81bd3f6fd59ced2bb7252958732623741c78519e50ddd436746e3866a"; }];
    buildInputs = [ python3 unicorn ];
  };

  "python3-urllib3" = fetch {
    pname       = "python3-urllib3";
    version     = "1.24.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-urllib3-1.24.1-1-any.pkg.tar.xz"; sha256 = "a6bdf579391fce42971f4b71c67a6d3a0ffd25fd41489b33cea3b18b3fe71fbb"; }];
    buildInputs = [ python3 python3-certifi python3-idna ];
  };

  "python3-virtualenv" = fetch {
    pname       = "python3-virtualenv";
    version     = "16.0.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-virtualenv-16.0.0-1-any.pkg.tar.xz"; sha256 = "325cf0bf3784fd932757ba86ada8d45dcf27e60fdafd3d51684599a42fe53689"; }];
    buildInputs = [ python3 ];
  };

  "python3-voluptuous" = fetch {
    pname       = "python3-voluptuous";
    version     = "0.11.5";
    srcs        = [{ filename = "mingw-w64-i686-python3-voluptuous-0.11.5-1-any.pkg.tar.xz"; sha256 = "8a59616e86f83d85dc42d7bc8ecac0b420e1302658ca16f337d8940bee5550f9"; }];
    buildInputs = [ python3 ];
  };

  "python3-watchdog" = fetch {
    pname       = "python3-watchdog";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-watchdog-0.9.0-1-any.pkg.tar.xz"; sha256 = "b103fe8293575a90a407337302eefb3bf8417ca580929bddf4c38669e198cce2"; }];
    buildInputs = [ python3 ];
  };

  "python3-wcwidth" = fetch {
    pname       = "python3-wcwidth";
    version     = "0.1.7";
    srcs        = [{ filename = "mingw-w64-i686-python3-wcwidth-0.1.7-3-any.pkg.tar.xz"; sha256 = "eee151ae39bdd0a1fe004d0651b681cd1bde23849553143a43ee15871a78988c"; }];
    buildInputs = [ python3 ];
  };

  "python3-webcolors" = fetch {
    pname       = "python3-webcolors";
    version     = "1.8.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-webcolors-1.8.1-1-any.pkg.tar.xz"; sha256 = "bdaf8bc92bc9f90943b6155578159c30de587f9c46b87aece65be8cdaed74560"; }];
    buildInputs = [ python3 ];
  };

  "python3-webencodings" = fetch {
    pname       = "python3-webencodings";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-webencodings-0.5.1-3-any.pkg.tar.xz"; sha256 = "593c5c74991f75855d0a037bfe08b46089066b8ef6d52e1c33ced4cdc5a8a44c"; }];
    buildInputs = [ python3 ];
  };

  "python3-websocket-client" = fetch {
    pname       = "python3-websocket-client";
    version     = "0.54.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-websocket-client-0.54.0-2-any.pkg.tar.xz"; sha256 = "cec7541e5d0450fa91df6026e9368f24ec702fd633dbed49e94c1be44efb63d1"; }];
    buildInputs = [ python3 python3-six ];
  };

  "python3-wheel" = fetch {
    pname       = "python3-wheel";
    version     = "0.32.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-wheel-0.32.3-1-any.pkg.tar.xz"; sha256 = "5b65983b578ac24e1bea11c6a1d3cad742705fe70abd95221fc7f9d65038e99e"; }];
    buildInputs = [ python3 ];
  };

  "python3-whoosh" = fetch {
    pname       = "python3-whoosh";
    version     = "2.7.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-whoosh-2.7.4-2-any.pkg.tar.xz"; sha256 = "53207e3ec1380a412ad595b00c312992121e045e2510b08bd713d41f50d15f4b"; }];
    buildInputs = [ python3 ];
  };

  "python3-win_inet_pton" = fetch {
    pname       = "python3-win_inet_pton";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-python3-win_inet_pton-1.0.1-1-any.pkg.tar.xz"; sha256 = "3d0b4a305173d9340e6e6740c230711f7d3f9c5437db9e9a23d003a629444d33"; }];
    buildInputs = [ python3 ];
  };

  "python3-win_unicode_console" = fetch {
    pname       = "python3-win_unicode_console";
    version     = "0.5";
    srcs        = [{ filename = "mingw-w64-i686-python3-win_unicode_console-0.5-3-any.pkg.tar.xz"; sha256 = "5aae13e01903172ee33cd477c8ab0714ecbf39df1619ed87071f7f3ccef615bf"; }];
    buildInputs = [ python3 ];
  };

  "python3-wincertstore" = fetch {
    pname       = "python3-wincertstore";
    version     = "0.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-wincertstore-0.2-1-any.pkg.tar.xz"; sha256 = "a8db620fd6bda84c5e2f4abb24ce991e5a0af1b39060e046268509c5ec88f1fa"; }];
    buildInputs = [ python3 ];
  };

  "python3-winkerberos" = fetch {
    pname       = "python3-winkerberos";
    version     = "0.7.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-winkerberos-0.7.0-1-any.pkg.tar.xz"; sha256 = "93481b7948692dcbe312ac8fb8319829a81702a727d531000633fb2bd2281947"; }];
    buildInputs = [ python3 ];
  };

  "python3-wrapt" = fetch {
    pname       = "python3-wrapt";
    version     = "1.10.11";
    srcs        = [{ filename = "mingw-w64-i686-python3-wrapt-1.10.11-3-any.pkg.tar.xz"; sha256 = "b7f27094561397d859b6739237dd8f58bb8031499df6dc04fcc965960cfefc73"; }];
    buildInputs = [ python3 ];
  };

  "python3-xdg" = fetch {
    pname       = "python3-xdg";
    version     = "0.26";
    srcs        = [{ filename = "mingw-w64-i686-python3-xdg-0.26-2-any.pkg.tar.xz"; sha256 = "93d4227a9277cba03e6fec716e0b36bf0ae461104b9adb42c4501683cb57136f"; }];
    buildInputs = [ python3 ];
  };

  "python3-xlrd" = fetch {
    pname       = "python3-xlrd";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-xlrd-1.2.0-1-any.pkg.tar.xz"; sha256 = "def3ea946a46bf2cc3409110bec4055355cb44915005c8143cad6810e94ca7c4"; }];
    buildInputs = [ python3 ];
  };

  "python3-xlsxwriter" = fetch {
    pname       = "python3-xlsxwriter";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-i686-python3-xlsxwriter-1.1.2-1-any.pkg.tar.xz"; sha256 = "be5fc60c98978c3aabcc4c10571b536b147cb0b209fcf0502d089295a558dfc4"; }];
    buildInputs = [ python3 ];
  };

  "python3-xlwt" = fetch {
    pname       = "python3-xlwt";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-xlwt-1.3.0-1-any.pkg.tar.xz"; sha256 = "154105e9bbb94be9a6e4cf3af8bb0df31ba386b52ed5ca87723f40a035a1eed2"; }];
    buildInputs = [ python3 ];
  };

  "python3-yaml" = fetch {
    pname       = "python3-yaml";
    version     = "3.13";
    srcs        = [{ filename = "mingw-w64-i686-python3-yaml-3.13-1-any.pkg.tar.xz"; sha256 = "bf1e30d7781b203e89369f5d24edcd928fb4deee9d3498f23ddb4b4342477a9a"; }];
    buildInputs = [ python3 libyaml ];
  };

  "python3-zeroconf" = fetch {
    pname       = "python3-zeroconf";
    version     = "0.21.3";
    srcs        = [{ filename = "mingw-w64-i686-python3-zeroconf-0.21.3-2-any.pkg.tar.xz"; sha256 = "4d3d3eccd6f7f3da55183ba190ad3d1b38cc78d6bc3542211c132770fe6959f7"; }];
    buildInputs = [ python3 python3-ifaddr ];
  };

  "python3-zope.event" = fetch {
    pname       = "python3-zope.event";
    version     = "4.4";
    srcs        = [{ filename = "mingw-w64-i686-python3-zope.event-4.4-1-any.pkg.tar.xz"; sha256 = "21a2e75ac4b395eebe0feea4c008971f6fee41faa023acd0ebc16f83a1b88f0e"; }];
  };

  "python3-zope.interface" = fetch {
    pname       = "python3-zope.interface";
    version     = "4.6.0";
    srcs        = [{ filename = "mingw-w64-i686-python3-zope.interface-4.6.0-1-any.pkg.tar.xz"; sha256 = "03ad371d3c24c956afec51a9755fa533740a3a3b9c70656795eda0dd51c17a5d"; }];
  };

  "qbittorrent" = fetch {
    pname       = "qbittorrent";
    version     = "4.1.5";
    srcs        = [{ filename = "mingw-w64-i686-qbittorrent-4.1.5-1-any.pkg.tar.xz"; sha256 = "6db47e29336d8dbc3a1c3680a7b3238c75aceef33a602c29d796df19fd0c84d3"; }];
    buildInputs = [ boost qt5 libtorrent-rasterbar zlib ];
  };

  "qbs" = fetch {
    pname       = "qbs";
    version     = "1.12.2";
    srcs        = [{ filename = "mingw-w64-i686-qbs-1.12.2-1-any.pkg.tar.xz"; sha256 = "234be1f9370818d0a959cd5f726b1f0f49eaf2ac51f6011e6e49127fbd1de7fc"; }];
    buildInputs = [ qt5 ];
  };

  "qca-qt4-git" = fetch {
    pname       = "qca-qt4-git";
    version     = "2220.66b9754";
    srcs        = [{ filename = "mingw-w64-i686-qca-qt4-git-2220.66b9754-1-any.pkg.tar.xz"; sha256 = "64a4d6a7eeae63e3c071032d18b09583620d1c74cf45f2ca8cf78823c659db3d"; }];
    buildInputs = [ ca-certificates cyrus-sasl doxygen gnupg libgcrypt nss openssl qt4 ];
  };

  "qca-qt5-git" = fetch {
    pname       = "qca-qt5-git";
    version     = "2277.98eead0";
    srcs        = [{ filename = "mingw-w64-i686-qca-qt5-git-2277.98eead0-1-any.pkg.tar.xz"; sha256 = "8ef9098903755459387556c4dc6f803aac88449cc0befeb77d52b88880379f0e"; }];
    buildInputs = [ ca-certificates cyrus-sasl doxygen gnupg libgcrypt nss openssl qt5 ];
  };

  "qemu" = fetch {
    pname       = "qemu";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-i686-qemu-3.1.0-1-any.pkg.tar.xz"; sha256 = "836a612c7b7e0b736c0162c4228d82e7714f7e719c5786b9db7064fe0618efab"; }];
    buildInputs = [ capstone curl cyrus-sasl glib2 gnutls gtk3 libjpeg libpng libssh2 libusb lzo2 pixman snappy SDL2 usbredir ];
  };

  "qhttpengine" = fetch {
    pname       = "qhttpengine";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-qhttpengine-1.0.1-1-any.pkg.tar.xz"; sha256 = "2a41f4fb5e694c8651d58931bad6540fdfb891907fff806bad4a80c3c4f1a8b1"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast qt5.version "5.4"; qt5) ];
  };

  "qhull-git" = fetch {
    pname       = "qhull-git";
    version     = "r166.f1f8b42";
    srcs        = [{ filename = "mingw-w64-i686-qhull-git-r166.f1f8b42-1-any.pkg.tar.xz"; sha256 = "879517cfaaf0ee26f910c974a1aead003ba5a8968bdc5100f9580110603ea087"; }];
    buildInputs = [ gcc-libs ];
  };

  "qjson-qt4" = fetch {
    pname       = "qjson-qt4";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-i686-qjson-qt4-0.8.1-3-any.pkg.tar.xz"; sha256 = "9d8b01fc59f6cf2eee275aa272add3615b3dadd7b9878e45e18e9f3626a02c6c"; }];
    buildInputs = [ qt4 ];
  };

  "qmdnsengine" = fetch {
    pname       = "qmdnsengine";
    version     = "0.1.0";
    srcs        = [{ filename = "mingw-w64-i686-qmdnsengine-0.1.0-1-any.pkg.tar.xz"; sha256 = "d8024defb241de7e2ff9a4a5d069de1391abfdd8c60219f84444a718708bcbcc"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast qt5.version "5.4"; qt5) ];
  };

  "qpdf" = fetch {
    pname       = "qpdf";
    version     = "8.3.0";
    srcs        = [{ filename = "mingw-w64-i686-qpdf-8.3.0-1-any.pkg.tar.xz"; sha256 = "bf1d2700dcc7d840fed204617287b7dd45fe57ed28b26045dd56e5dcf658cbc0"; }];
    buildInputs = [ gcc-libs libjpeg pcre zlib ];
  };

  "qrencode" = fetch {
    pname       = "qrencode";
    version     = "4.0.2";
    srcs        = [{ filename = "mingw-w64-i686-qrencode-4.0.2-1-any.pkg.tar.xz"; sha256 = "2b2ef4ab1be9ce1a216668a234d36f2a737516aae13fcfc901ce91704739157d"; }];
    buildInputs = [ libpng ];
  };

  "qrupdate-svn" = fetch {
    pname       = "qrupdate-svn";
    version     = "r28";
    srcs        = [{ filename = "mingw-w64-i686-qrupdate-svn-r28-4-any.pkg.tar.xz"; sha256 = "512c6a4f742f8427a1756cdd49e31ecca76785d662efde9fc645cf902065be0d"; }];
    buildInputs = [ openblas ];
  };

  "qscintilla" = fetch {
    pname       = "qscintilla";
    version     = "2.10.8";
    srcs        = [{ filename = "mingw-w64-i686-qscintilla-2.10.8-1-any.pkg.tar.xz"; sha256 = "6bc334bb56074488d701db0faae5555db63039280d7226a9fd63f0ff8d3e9403"; }];
    buildInputs = [ qt5 ];
  };

  "qt-creator" = fetch {
    pname       = "qt-creator";
    version     = "4.8.0";
    srcs        = [{ filename = "mingw-w64-i686-qt-creator-4.8.0-1-any.pkg.tar.xz"; sha256 = "9e53c0681061d50e7a0dbb34ede936606b1370331d8e14d5bceaaa264eec7560"; }];
    buildInputs = [ qt5 gcc make qbs ];
  };

  "qt-installer-framework-git" = fetch {
    pname       = "qt-installer-framework-git";
    version     = "r3068.55c191ed";
    srcs        = [{ filename = "mingw-w64-i686-qt-installer-framework-git-r3068.55c191ed-1-any.pkg.tar.xz"; sha256 = "776320110bb35dd2e2e73b70cc0c1a4fa9dccad9e3a3d94d285d78369bc73697"; }];
  };

  "qt4" = fetch {
    pname       = "qt4";
    version     = "4.8.7";
    srcs        = [{ filename = "mingw-w64-i686-qt4-4.8.7-4-any.pkg.tar.xz"; sha256 = "7c3e8755ad047a6317f7ad5513e3f6e31e5f3f67d53b4bfe59de8c25677b8f67"; }];
    buildInputs = [ gcc-libs dbus fontconfig freetype libiconv libjpeg libmng libpng libtiff libwebp libxml2 libxslt openssl pcre qtbinpatcher sqlite3 zlib ];
  };

  "qt5" = fetch {
    pname       = "qt5";
    version     = "5.12.0";
    srcs        = [{ filename = "mingw-w64-i686-qt5-5.12.0-1-any.pkg.tar.xz"; sha256 = "3e32f759968f72df817b2efc1e39a72ec6907454b5f6bca777fae1c73fbb7692"; }];
    buildInputs = [ gcc-libs qtbinpatcher z3 assimp dbus fontconfig freetype harfbuzz jasper libjpeg libmng libpng libtiff libxml2 libxslt libwebp openssl openal pcre2 sqlite3 vulkan xpm-nox zlib icu icu-debug-libs ];
  };

  "qt5-static" = fetch {
    pname       = "qt5-static";
    version     = "5.12.0";
    srcs        = [{ filename = "mingw-w64-i686-qt5-static-5.12.0-1-any.pkg.tar.xz"; sha256 = "f5524a87b5f43a9bdee855c974e2722d134373c3e213abf877e4457487358785"; }];
    buildInputs = [ gcc-libs qtbinpatcher z3 icu icu-debug-libs ];
  };

  "qtbinpatcher" = fetch {
    pname       = "qtbinpatcher";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-i686-qtbinpatcher-2.2.0-2-any.pkg.tar.xz"; sha256 = "a647fd1c1ab2b74509ad437d51829d35e975bdc64c36b4d189278bab24309dc0"; }];
    buildInputs = [  ];
  };

  "qtwebkit" = fetch {
    pname       = "qtwebkit";
    version     = "5.212.0alpha2";
    srcs        = [{ filename = "mingw-w64-i686-qtwebkit-5.212.0alpha2-5-any.pkg.tar.xz"; sha256 = "d6784a4b94a89d23b79fc03327b07ea0de27177068febab583c68727bbe41b98"; }];
    buildInputs = [ icu libxml2 libxslt libwebp fontconfig sqlite3 qt5 ];
  };

  "quantlib" = fetch {
    pname       = "quantlib";
    version     = "1.14";
    srcs        = [{ filename = "mingw-w64-i686-quantlib-1.14-1-any.pkg.tar.xz"; sha256 = "baca3fc8e554e33a31f8daf2a3f5ba7292532eb79541cc45dac2cc746294fa88"; }];
    buildInputs = [ boost ];
  };

  "quarter-hg" = fetch {
    pname       = "quarter-hg";
    version     = "r507+.4040ac7a14cf+";
    srcs        = [{ filename = "mingw-w64-i686-quarter-hg-r507+.4040ac7a14cf+-1-any.pkg.tar.xz"; sha256 = "01e846615340d1b7c209c87078b0063c266d9cf2ecb9e50f141cb4ac077fcb8e"; }];
    buildInputs = [ qt5 coin3d ];
    broken      = true; # broken dependency quarter-hg -> coin3d
  };

  "quassel" = fetch {
    pname       = "quassel";
    version     = "0.13.0";
    srcs        = [{ filename = "mingw-w64-i686-quassel-0.13.0-1-any.pkg.tar.xz"; sha256 = "5df6b4775be3a933f43496a11df5e72f12fcd156aaf7808da9aa6b6db4fcc594"; }];
    buildInputs = [ qt5 qca-qt5-git Snorenotify ];
    broken      = true; # broken dependency quassel -> Snorenotify
  };

  "quazip" = fetch {
    pname       = "quazip";
    version     = "0.7.6";
    srcs        = [{ filename = "mingw-w64-i686-quazip-0.7.6-1-any.pkg.tar.xz"; sha256 = "db3d07c2a830174d34fa7b59122b9a23b6b817890569b6266544c62b3ec593d1"; }];
    buildInputs = [ qt5 zlib ];
  };

  "qwt-qt4" = fetch {
    pname       = "qwt-qt4";
    version     = "6.1.2";
    srcs        = [{ filename = "mingw-w64-i686-qwt-qt4-6.1.2-2-any.pkg.tar.xz"; sha256 = "7bbf44d95d9d28c39af0471484de7ce3423df45a79400d145cbc0d8990040561"; }];
    buildInputs = [ qt4 ];
  };

  "qwt-qt5" = fetch {
    pname       = "qwt-qt5";
    version     = "6.1.3";
    srcs        = [{ filename = "mingw-w64-i686-qwt-qt5-6.1.3-1-any.pkg.tar.xz"; sha256 = "da4657d793caa146dfc0beed7b6e80250b05d6453ca4fd54963cd8fd02867c2b"; }];
    buildInputs = [ qt5 ];
  };

  "qxmpp" = fetch {
    pname       = "qxmpp";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-i686-qxmpp-1.0.0-1-any.pkg.tar.xz"; sha256 = "f5770b51739d33e131c57a2d39606aede3d63249989a4bd068cf57bbb20efecb"; }];
    buildInputs = [ libtheora libvpx opus qt5 speex ];
  };

  "qxmpp-qt4" = fetch {
    pname       = "qxmpp-qt4";
    version     = "0.8.3";
    srcs        = [{ filename = "mingw-w64-i686-qxmpp-qt4-0.8.3-2-any.pkg.tar.xz"; sha256 = "582b48ab0073553d675bf6dcbdb4ea90851b58708cb4ed4a5b05743ccbc3828a"; }];
    buildInputs = [ libtheora libvpx qt4 speex ];
  };

  "rabbitmq-c" = fetch {
    pname       = "rabbitmq-c";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-i686-rabbitmq-c-0.9.0-2-any.pkg.tar.xz"; sha256 = "b118cc11885bf5877ea8d9c3fba55b3410ef74981d6f3487d593228219ae89b7"; }];
    buildInputs = [ openssl popt ];
  };

  "ragel" = fetch {
    pname       = "ragel";
    version     = "6.10";
    srcs        = [{ filename = "mingw-w64-i686-ragel-6.10-1-any.pkg.tar.xz"; sha256 = "d4639e3a5d3ed9b273d9916523bb980a864742044cb02217f8ac8f217c5c387f"; }];
    buildInputs = [ gcc-libs ];
  };

  "rapidjson" = fetch {
    pname       = "rapidjson";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-rapidjson-1.1.0-1-any.pkg.tar.xz"; sha256 = "5a8530ca5246a8d045e91cdd08b82763c74f8610f30018e9e032f0cd462dab63"; }];
  };

  "readline" = fetch {
    pname       = "readline";
    version     = "7.0.005";
    srcs        = [{ filename = "mingw-w64-i686-readline-7.0.005-1-any.pkg.tar.xz"; sha256 = "dbe8121625bb2d16d7aaa8d1a5dd40b59421a9dd12f01298f8a2c5ece605c39c"; }];
    buildInputs = [ gcc-libs termcap ];
  };

  "readosm" = fetch {
    pname       = "readosm";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-readosm-1.1.0-1-any.pkg.tar.xz"; sha256 = "a0694669eff6082caa770fbe8b19f593457318d6dc5b82d4d0519efbe80a1495"; }];
    buildInputs = [ expat zlib ];
  };

  "recode" = fetch {
    pname       = "recode";
    version     = "3.7.1";
    srcs        = [{ filename = "mingw-w64-i686-recode-3.7.1-1-any.pkg.tar.xz"; sha256 = "d9efddefa1b512b353440590c3c4dea40e239055a108a6a81a6a4a27ffea10eb"; }];
    buildInputs = [ gettext ];
  };

  "rhash" = fetch {
    pname       = "rhash";
    version     = "1.3.7";
    srcs        = [{ filename = "mingw-w64-i686-rhash-1.3.7-1-any.pkg.tar.xz"; sha256 = "3849d177dec03e0d792806b25265c1f09fd2cae523a602a877808eb8c923fbf6"; }];
    buildInputs = [ gettext ];
  };

  "rocksdb" = fetch {
    pname       = "rocksdb";
    version     = "5.17.2";
    srcs        = [{ filename = "mingw-w64-i686-rocksdb-5.17.2-1-any.pkg.tar.xz"; sha256 = "bc3307c8f7f3592fb6a5e12d4145582aa4eab70acc6753860e7ba9f084940864"; }];
    buildInputs = [ bzip2 intel-tbb lz4 snappy zlib ];
  };

  "rtmpdump-git" = fetch {
    pname       = "rtmpdump-git";
    version     = "r512.fa8646d";
    srcs        = [{ filename = "mingw-w64-i686-rtmpdump-git-r512.fa8646d-3-any.pkg.tar.xz"; sha256 = "00d693981fa8aabb638dd0950b5471f66e1484ed87ac7c5f875f45acb499143a"; }];
    buildInputs = [ gcc-libs gmp gnutls nettle zlib ];
  };

  "rubberband" = fetch {
    pname       = "rubberband";
    version     = "1.8.2";
    srcs        = [{ filename = "mingw-w64-i686-rubberband-1.8.2-1-any.pkg.tar.xz"; sha256 = "a44187d375bb3d627b05422066594bedc56c115553cfa235b3bd43d5b2e6e787"; }];
    buildInputs = [ gcc-libs fftw libsamplerate libsndfile ladspa-sdk vamp-plugin-sdk ];
  };

  "ruby" = fetch {
    pname       = "ruby";
    version     = "2.6.0";
    srcs        = [{ filename = "mingw-w64-i686-ruby-2.6.0-1-any.pkg.tar.xz"; sha256 = "3f5b0a669f26af9a08ee1ad48c0d39a69b3f9b204df641dc7b2484dd4abbde06"; }];
    buildInputs = [ gcc-libs gdbm libyaml libffi ncurses openssl tk ];
  };

  "ruby-cairo" = fetch {
    pname       = "ruby-cairo";
    version     = "1.16.2";
    srcs        = [{ filename = "mingw-w64-i686-ruby-cairo-1.16.2-1-any.pkg.tar.xz"; sha256 = "19b9ab8d64234da36cb936f1e59dfb378c5f1f518614840b432617c8f743083b"; }];
    buildInputs = [ ruby cairo ruby-pkg-config ];
  };

  "ruby-dbus" = fetch {
    pname       = "ruby-dbus";
    version     = "0.15.0";
    srcs        = [{ filename = "mingw-w64-i686-ruby-dbus-0.15.0-1-any.pkg.tar.xz"; sha256 = "54a2748f117869435dce721380ef40e6d23db5a55bac1c76a2b1e9e9cdfaf8a4"; }];
    buildInputs = [ ruby ];
  };

  "ruby-native-package-installer" = fetch {
    pname       = "ruby-native-package-installer";
    version     = "1.0.6";
    srcs        = [{ filename = "mingw-w64-i686-ruby-native-package-installer-1.0.6-1-any.pkg.tar.xz"; sha256 = "c31a0470f87d45cb5cba4d13fcd14afe0e78d2ee1c28edcd4e40357d47b74630"; }];
    buildInputs = [ ruby ];
  };

  "ruby-pkg-config" = fetch {
    pname       = "ruby-pkg-config";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-i686-ruby-pkg-config-1.3.1-1-any.pkg.tar.xz"; sha256 = "35fdf4f234223cbba78b7584b62934cd3afecb9762b99729f208b7c1204d39b5"; }];
    buildInputs = [ ruby ];
  };

  "rust" = fetch {
    pname       = "rust";
    version     = "1.29.2";
    srcs        = [{ filename = "mingw-w64-i686-rust-1.29.2-1-any.pkg.tar.xz"; sha256 = "845c2a147fd8bf050a1f13765434988a14187586ad938a8f8e96d807602ea61f"; }];
    buildInputs = [ gcc ];
  };

  "rxspencer" = fetch {
    pname       = "rxspencer";
    version     = "alpha3.8.g7";
    srcs        = [{ filename = "mingw-w64-i686-rxspencer-alpha3.8.g7-1-any.pkg.tar.xz"; sha256 = "398a876c46165bf5044c2272858bc1f163d535adb0ae33aeb4f68d69c7a57e3d"; }];
  };

  "sassc" = fetch {
    pname       = "sassc";
    version     = "3.5.0";
    srcs        = [{ filename = "mingw-w64-i686-sassc-3.5.0-1-any.pkg.tar.xz"; sha256 = "ddf520626e7dc47644a57f7d4c32687e27fcc2559d1e47dc438560f6aac44101"; }];
    buildInputs = [ libsass ];
  };

  "schroedinger" = fetch {
    pname       = "schroedinger";
    version     = "1.0.11";
    srcs        = [{ filename = "mingw-w64-i686-schroedinger-1.0.11-4-any.pkg.tar.xz"; sha256 = "392e0cd947c84e3ff1e94c4b17a85be316707d63072fbc94897cc0e85d7d86f9"; }];
    buildInputs = [ orc ];
  };

  "scite" = fetch {
    pname       = "scite";
    version     = "4.1.2";
    srcs        = [{ filename = "mingw-w64-i686-scite-4.1.2-1-any.pkg.tar.xz"; sha256 = "f3ceca12d4accb983ea1c0a56477306a83ea3526c98d9b5c825fe7fdd890dfe2"; }];
    buildInputs = [ glib2 gtk3 ];
  };

  "scite-defaults" = fetch {
    pname       = "scite-defaults";
    version     = "4.1.2";
    srcs        = [{ filename = "mingw-w64-i686-scite-defaults-4.1.2-1-any.pkg.tar.xz"; sha256 = "1b15339c3548c85abe27f15b6fa2003d0191858afdc78b0131a5ec52861ee980"; }];
    buildInputs = [ (assert scite.version=="4.1.2"; scite) ];
  };

  "scummvm" = fetch {
    pname       = "scummvm";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-scummvm-2.0.0-1-any.pkg.tar.xz"; sha256 = "a2c9453c308782f857fd419914b4dc064c0b1872ddc0c6282c9708db2e4bc6a6"; }];
    buildInputs = [ faad2 freetype flac fluidsynth libjpeg-turbo libogg libvorbis libmad libmpeg2-git libtheora libpng nasm readline SDL2 zlib ];
  };

  "seexpr" = fetch {
    pname       = "seexpr";
    version     = "2.11";
    srcs        = [{ filename = "mingw-w64-i686-seexpr-2.11-1-any.pkg.tar.xz"; sha256 = "5b61f4f425432cb84bbf760f1dca8e7598bb14f89270947642c61ec02b9d5da7"; }];
    buildInputs = [ gcc-libs ];
  };

  "sfml" = fetch {
    pname       = "sfml";
    version     = "2.5.1";
    srcs        = [{ filename = "mingw-w64-i686-sfml-2.5.1-2-any.pkg.tar.xz"; sha256 = "4398b8908b3ccf9fe968a0793ccb091d7bac8f2eb83ec68f49b3ff060a32ae93"; }];
    buildInputs = [ flac freetype libjpeg libvorbis openal ];
  };

  "sgml-common" = fetch {
    pname       = "sgml-common";
    version     = "0.6.3";
    srcs        = [{ filename = "mingw-w64-i686-sgml-common-0.6.3-1-any.pkg.tar.xz"; sha256 = "815ba9b4ec1991a7185216ac33cda72d1f515bd8894c40131c6d240ecfe0d670"; }];
    buildInputs = [ sh ];
  };

  "shapelib" = fetch {
    pname       = "shapelib";
    version     = "1.4.1";
    srcs        = [{ filename = "mingw-w64-i686-shapelib-1.4.1-1-any.pkg.tar.xz"; sha256 = "cdf9787413cc299f246bf73bcbe0f4a986c7f61ad0590ba547562a3b1bfbd471"; }];
    buildInputs = [ gcc-libs proj ];
  };

  "shared-mime-info" = fetch {
    pname       = "shared-mime-info";
    version     = "1.10";
    srcs        = [{ filename = "mingw-w64-i686-shared-mime-info-1.10-1-any.pkg.tar.xz"; sha256 = "60fc1f68d37b58e26a0086f0b1e73676adcfa9b534e3762a09951a24a44a9db6"; }];
    buildInputs = [ libxml2 glib2 ];
  };

  "shiboken-qt4" = fetch {
    pname       = "shiboken-qt4";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-i686-shiboken-qt4-1.2.2-3-any.pkg.tar.xz"; sha256 = "ba3013f7117c99abad13f0f0cd7d72bf96da590fceb5e8e0581aa81ea23ca06f"; }];
    buildInputs = [  ];
  };

  "shine" = fetch {
    pname       = "shine";
    version     = "3.1.1";
    srcs        = [{ filename = "mingw-w64-i686-shine-3.1.1-1-any.pkg.tar.xz"; sha256 = "329e17389305952eda173001faf11be5cf89c7fc90fc8f434e52967422fd234f"; }];
  };

  "shishi-git" = fetch {
    pname       = "shishi-git";
    version     = "r3586.6fa08895";
    srcs        = [{ filename = "mingw-w64-i686-shishi-git-r3586.6fa08895-1-any.pkg.tar.xz"; sha256 = "040967be22fdc45704fd398792e810bbaa1e117a083ecff03357e701996fff75"; }];
    buildInputs = [ gnutls libidn libgcrypt libgpg-error libtasn1 ];
  };

  "silc-toolkit" = fetch {
    pname       = "silc-toolkit";
    version     = "1.1.12";
    srcs        = [{ filename = "mingw-w64-i686-silc-toolkit-1.1.12-3-any.pkg.tar.xz"; sha256 = "eb33ee3a81690192576221ad647341fbe2cf19235b922c45e9bf578a8a61ad81"; }];
    buildInputs = [ libsystre ];
  };

  "simage-hg" = fetch {
    pname       = "simage-hg";
    version     = "r748+.194ff9c6293e+";
    srcs        = [{ filename = "mingw-w64-i686-simage-hg-r748+.194ff9c6293e+-1-any.pkg.tar.xz"; sha256 = "bb13b99863edda85d580a3218063a6d121edbd003432561143d1584fa58fa6da"; }];
    buildInputs = [ giflib jasper libjpeg-turbo libpng libsndfile libtiff libvorbis qt5 zlib ];
  };

  "sip" = fetch {
    pname       = "sip";
    version     = "4.19.13";
    srcs        = [{ filename = "mingw-w64-i686-sip-4.19.13-2-any.pkg.tar.xz"; sha256 = "653499512eefd0b355a7cab0f9c0defa3c99a9f901b21cd27f4c29c3d2547a61"; }];
    buildInputs = [ gcc-libs ];
  };

  "smpeg" = fetch {
    pname       = "smpeg";
    version     = "0.4.5";
    srcs        = [{ filename = "mingw-w64-i686-smpeg-0.4.5-2-any.pkg.tar.xz"; sha256 = "2dd5fd201939a20dbd3593660b7b220a07bf1b61fdea8fedbe2cef12e270a1db"; }];
    buildInputs = [ gcc-libs SDL ];
  };

  "smpeg2" = fetch {
    pname       = "smpeg2";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-smpeg2-2.0.0-5-any.pkg.tar.xz"; sha256 = "85d4e3d6cfe0d50d9278ee97bdbadcc0ae0b107ce699a147a46dcd844e0759f5"; }];
    buildInputs = [ gcc-libs SDL2 ];
  };

  "snappy" = fetch {
    pname       = "snappy";
    version     = "1.1.7";
    srcs        = [{ filename = "mingw-w64-i686-snappy-1.1.7-1-any.pkg.tar.xz"; sha256 = "6bc1ad7c5423b34b55b436b19b00b92bad89546f08447de0646a699052b45b97"; }];
    buildInputs = [ gcc-libs ];
  };

  "snoregrowl" = fetch {
    pname       = "snoregrowl";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-i686-snoregrowl-0.5.0-1-any.pkg.tar.xz"; sha256 = "46a6c363d4490ddfeeb2895096c90e2f728e0f93b16772a88551029330316fe4"; }];
  };

  "snorenotify" = fetch {
    pname       = "snorenotify";
    version     = "0.7.0";
    srcs        = [{ filename = "mingw-w64-i686-snorenotify-0.7.0-2-any.pkg.tar.xz"; sha256 = "a48854ef1effc18b0e3522e65004857c232e9f1975fd477531c9b22a0851390e"; }];
    buildInputs = [ qt5 snoregrowl ];
  };

  "soci" = fetch {
    pname       = "soci";
    version     = "3.2.3";
    srcs        = [{ filename = "mingw-w64-i686-soci-3.2.3-1-any.pkg.tar.xz"; sha256 = "14769b7a6708fc38a87dda39592e82e931223e0fb16593538e0f90fb15d8c3a6"; }];
    buildInputs = [ boost ];
  };

  "solid-qt5" = fetch {
    pname       = "solid-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-solid-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "6aac11d087eb8d96a79bcad857aa1569d517590876e4c765acd0828fe4dc16d7"; }];
    buildInputs = [ qt5 ];
  };

  "sonnet-qt5" = fetch {
    pname       = "sonnet-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-sonnet-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "917030e2e3939ae44f3cb28b16fdffbb83148c6e5398620f4524f037592b6f52"; }];
    buildInputs = [ qt5 ];
  };

  "soqt-hg" = fetch {
    pname       = "soqt-hg";
    version     = "r1962+.6719cfeef271+";
    srcs        = [{ filename = "mingw-w64-i686-soqt-hg-r1962+.6719cfeef271+-1-any.pkg.tar.xz"; sha256 = "c2ad5a69a65d82ae1be609bbb49a58cce74b59d6cccc153f45c78a3de9f6678f"; }];
    buildInputs = [ coin3d qt5 ];
    broken      = true; # broken dependency soqt-hg -> coin3d
  };

  "soundtouch" = fetch {
    pname       = "soundtouch";
    version     = "2.1.2";
    srcs        = [{ filename = "mingw-w64-i686-soundtouch-2.1.2-1-any.pkg.tar.xz"; sha256 = "4d90bc1a994800dd12b5a4efcd375f1eb6dcbb34313f7481a2f0ab2a185dacfa"; }];
    buildInputs = [ gcc-libs ];
  };

  "source-highlight" = fetch {
    pname       = "source-highlight";
    version     = "3.1.8";
    srcs        = [{ filename = "mingw-w64-i686-source-highlight-3.1.8-1-any.pkg.tar.xz"; sha256 = "cb17cf81b89c4dc342308925840e8faecb71f44ed020be93f2d87dd98d4af821"; }];
    buildInputs = [ bash boost ];
  };

  "sparsehash" = fetch {
    pname       = "sparsehash";
    version     = "2.0.3";
    srcs        = [{ filename = "mingw-w64-i686-sparsehash-2.0.3-1-any.pkg.tar.xz"; sha256 = "9c84f43692b5f52e2fe625beb8d1535cf13ecb1352a7f9719e6b7ca07323d31d"; }];
  };

  "spatialite-tools" = fetch {
    pname       = "spatialite-tools";
    version     = "4.3.0";
    srcs        = [{ filename = "mingw-w64-i686-spatialite-tools-4.3.0-2-any.pkg.tar.xz"; sha256 = "80b0ded223c2492ebd84f64f7fea64d24b9dd0b73a7f424ac3663183d080c3da"; }];
    buildInputs = [ libspatialite readosm libiconv ];
  };

  "spdylay" = fetch {
    pname       = "spdylay";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-i686-spdylay-1.4.0-1-any.pkg.tar.xz"; sha256 = "49dd04ae49f8a2eeab8820e3546c01cdc1a538515606e98e53ec06e814be8001"; }];
  };

  "speex" = fetch {
    pname       = "speex";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-i686-speex-1.2.0-1-any.pkg.tar.xz"; sha256 = "4b8f760db85b18ef84e47fcc4cb1567191d29db3829115c9aabb742c6ffad4cb"; }];
    buildInputs = [ libogg speexdsp ];
  };

  "speexdsp" = fetch {
    pname       = "speexdsp";
    version     = "1.2rc3";
    srcs        = [{ filename = "mingw-w64-i686-speexdsp-1.2rc3-3-any.pkg.tar.xz"; sha256 = "ddef418231253e1a4c8e571c2bade5c082b40d7a55721e4c300f244f1d3e31dc"; }];
    buildInputs = [ gcc-libs ];
  };

  "spice-gtk" = fetch {
    pname       = "spice-gtk";
    version     = "0.35";
    srcs        = [{ filename = "mingw-w64-i686-spice-gtk-0.35-3-any.pkg.tar.xz"; sha256 = "5e1c4e9d14803c337a0774048c62e61e40b546610f316225a08d53abf34d7567"; }];
    buildInputs = [ cyrus-sasl dbus-glib gobject-introspection gstreamer gst-plugins-base gtk3 libjpeg-turbo lz4 openssl phodav pixman spice-protocol usbredir vala ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "spice-protocol" = fetch {
    pname       = "spice-protocol";
    version     = "0.12.14";
    srcs        = [{ filename = "mingw-w64-i686-spice-protocol-0.12.14-1-any.pkg.tar.xz"; sha256 = "fd49f861c975b0fa2880d59fcc929fd684dc3d2569cea081c604f18c07c91a8c"; }];
  };

  "spirv-tools" = fetch {
    pname       = "spirv-tools";
    version     = "2018.6";
    srcs        = [{ filename = "mingw-w64-i686-spirv-tools-2018.6-1-any.pkg.tar.xz"; sha256 = "f2b5a427b90e718dce9196c7b90334cfcb14bd6edf546e9b7190feb179ffed84"; }];
    buildInputs = [ gcc-libs ];
  };

  "sqlcipher" = fetch {
    pname       = "sqlcipher";
    version     = "4.0.1";
    srcs        = [{ filename = "mingw-w64-i686-sqlcipher-4.0.1-1-any.pkg.tar.xz"; sha256 = "78ca32dad9fb8c5fbd8f0848f1e9c6d19ba5a1e82c7c6346682d199f4002a05c"; }];
    buildInputs = [ gcc-libs openssl readline ];
  };

  "sqlheavy" = fetch {
    pname       = "sqlheavy";
    version     = "0.1.1";
    srcs        = [{ filename = "mingw-w64-i686-sqlheavy-0.1.1-2-any.pkg.tar.xz"; sha256 = "9bf07d1efbdd8f5a012c1ef660b0646a603aa13c3088a1159520cec108aefaee"; }];
    buildInputs = [ gtk2 sqlite3 vala libxml2 ];
  };

  "sqlite-analyzer" = fetch {
    pname       = "sqlite-analyzer";
    version     = "3.16.1";
    srcs        = [{ filename = "mingw-w64-i686-sqlite-analyzer-3.16.1-1-any.pkg.tar.xz"; sha256 = "76ec619309b6d16162568ef22d3fad16f7f619a1df7d135876e6c9a528cbe6c9"; }];
    buildInputs = [ gcc-libs tcl ];
  };

  "sqlite3" = fetch {
    pname       = "sqlite3";
    version     = "3.26.0";
    srcs        = [{ filename = "mingw-w64-i686-sqlite3-3.26.0-1-any.pkg.tar.xz"; sha256 = "f0c079be572b0367f66e6d492a132e63393e7ebe7b1f87e3f5de55a14d7cc24f"; }];
    buildInputs = [ gcc-libs ncurses readline ];
  };

  "srt" = fetch {
    pname       = "srt";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-i686-srt-1.3.1-3-any.pkg.tar.xz"; sha256 = "879e418a75add87a8435a7a32e02ff810acc26c9e4bd475ef2f93f8da33bcc2b"; }];
    buildInputs = [ gcc-libs libwinpthread-git openssl ];
  };

  "stxxl-git" = fetch {
    pname       = "stxxl-git";
    version     = "1.4.1.343.gf7389c7";
    srcs        = [{ filename = "mingw-w64-i686-stxxl-git-1.4.1.343.gf7389c7-2-any.pkg.tar.xz"; sha256 = "a4d5a270846f85d00e9cc432a19679166b65887301d56f2b1a472b5e78864b92"; }];
  };

  "styrene" = fetch {
    pname       = "styrene";
    version     = "0.3.0";
    srcs        = [{ filename = "mingw-w64-i686-styrene-0.3.0-2-any.pkg.tar.xz"; sha256 = "22ef54f4668dcc226084392e229452ab191ea492f806108fcdf9a348388cd193"; }];
    buildInputs = [ zip python3 gcc binutils nsis ];
    broken      = true; # broken dependency styrene -> zip
  };

  "suitesparse" = fetch {
    pname       = "suitesparse";
    version     = "6.0.0";
    srcs        = [{ filename = "mingw-w64-i686-suitesparse-6.0.0-2-any.pkg.tar.xz"; sha256 = "32f4a9aff4f54595a4c2b437b4e3d0b0af7f3f99af05f3161168db1719162e6f"; }];
    buildInputs = [ openblas metis ];
  };

  "superglu-hg" = fetch {
    pname       = "superglu-hg";
    version     = "r79.16efd99583f2";
    srcs        = [{ filename = "mingw-w64-i686-superglu-hg-r79.16efd99583f2-1-any.pkg.tar.xz"; sha256 = "6e18b4d07cd14433eda46c5ee3fa4ad9372fb73b6a5879e809ef5f07fa0a28d5"; }];
    buildInputs = [ gcc-libs ];
  };

  "swig" = fetch {
    pname       = "swig";
    version     = "3.0.12";
    srcs        = [{ filename = "mingw-w64-i686-swig-3.0.12-1-any.pkg.tar.xz"; sha256 = "92c190c67308f65dd5f3e5595fc12fbe56557d642cf78742944a81b4effeadd9"; }];
    buildInputs = [ gcc-libs pcre ];
  };

  "syndication-qt5" = fetch {
    pname       = "syndication-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-syndication-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "0ea837aee3203c74378c4777f07360ae55c3de8128d4b5a77f3875f35fe5d996"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcodecs-qt5.version "5.50.0"; kcodecs-qt5) ];
  };

  "syntax-highlighting-qt5" = fetch {
    pname       = "syntax-highlighting-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-syntax-highlighting-qt5-5.50.0-2-any.pkg.tar.xz"; sha256 = "366e5665bb1f07cf56b946b5491ffb7279ac7c893ac114a552c5a1d95de54867"; }];
    buildInputs = [ qt5 ];
  };

  "szip" = fetch {
    pname       = "szip";
    version     = "2.1.1";
    srcs        = [{ filename = "mingw-w64-i686-szip-2.1.1-2-any.pkg.tar.xz"; sha256 = "58b5efe1420a2bfd6e92cf94112d29b03ec588f54f4a995a1b26034076f0d369"; }];
    buildInputs = [  ];
  };

  "taglib" = fetch {
    pname       = "taglib";
    version     = "1.11.1";
    srcs        = [{ filename = "mingw-w64-i686-taglib-1.11.1-1-any.pkg.tar.xz"; sha256 = "a23f5d55663ab060f5988da38864724204990751f3fb3316fb17045aa9dfe68d"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "tcl" = fetch {
    pname       = "tcl";
    version     = "8.6.9";
    srcs        = [{ filename = "mingw-w64-i686-tcl-8.6.9-2-any.pkg.tar.xz"; sha256 = "8960084b5caaeb2349f4d927d2fdb8bbdf6eab9fdb33160acd12492075aaed7d"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "tcl-nsf" = fetch {
    pname       = "tcl-nsf";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-i686-tcl-nsf-2.1.0-1-any.pkg.tar.xz"; sha256 = "5cadaaeebb387576af6cedce2ad55ced1d9adef9909ff9f162c901f772734779"; }];
    buildInputs = [ tcl ];
  };

  "tcllib" = fetch {
    pname       = "tcllib";
    version     = "1.19";
    srcs        = [{ filename = "mingw-w64-i686-tcllib-1.19-1-any.pkg.tar.xz"; sha256 = "64f8b57b811300952687a53aa65f473783e5b537ad6ff7ab3ddb761d68fc6630"; }];
    buildInputs = [ tcl ];
  };

  "tclvfs-cvs" = fetch {
    pname       = "tclvfs-cvs";
    version     = "20130425";
    srcs        = [{ filename = "mingw-w64-i686-tclvfs-cvs-20130425-3-any.pkg.tar.xz"; sha256 = "51cc95c9d04743fb4190a3495b7bc0705f41beac24722bdb314f6fa7df9a5000"; }];
    buildInputs = [ tcl ];
  };

  "tclx" = fetch {
    pname       = "tclx";
    version     = "8.4.1";
    srcs        = [{ filename = "mingw-w64-i686-tclx-8.4.1-3-any.pkg.tar.xz"; sha256 = "4135d614c2011ff158592119092da5b695e3050fed1050eca086f1b16b28fb68"; }];
    buildInputs = [ tcl ];
  };

  "template-glib" = fetch {
    pname       = "template-glib";
    version     = "3.30.0";
    srcs        = [{ filename = "mingw-w64-i686-template-glib-3.30.0-1-any.pkg.tar.xz"; sha256 = "8cfcb870ddae996e302c800cd62fd261da5d5d31d7d2a7301e31bb890aa53929"; }];
    buildInputs = [ glib2 gobject-introspection ];
  };

  "tepl4" = fetch {
    pname       = "tepl4";
    version     = "4.2.0";
    srcs        = [{ filename = "mingw-w64-i686-tepl4-4.2.0-1-any.pkg.tar.xz"; sha256 = "36f1de4dff7b71afa296dda12a6d29aa8beec59439b37a5798e8ce8296c75623"; }];
    buildInputs = [ amtk gtksourceview4 uchardet ];
  };

  "termcap" = fetch {
    pname       = "termcap";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-i686-termcap-1.3.1-3-any.pkg.tar.xz"; sha256 = "cf1e1b2bc3e9d2d454edd1796995ff12969abae90d065970a0bd2a0c105185f8"; }];
    buildInputs = [ gcc-libs ];
  };

  "tesseract-data-afr" = fetch {
    pname       = "tesseract-data-afr";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-afr-4.0.0-1-any.pkg.tar.xz"; sha256 = "dbb7129b0cce770a71d670ce38fc84755739c128010341ca251164a20dc3ebc0"; }];
  };

  "tesseract-data-amh" = fetch {
    pname       = "tesseract-data-amh";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-amh-4.0.0-1-any.pkg.tar.xz"; sha256 = "8a8abd15695048c1db917fd7f7e644b083fe8c36bd2b88b05f5d7f19efaa817c"; }];
  };

  "tesseract-data-ara" = fetch {
    pname       = "tesseract-data-ara";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ara-4.0.0-1-any.pkg.tar.xz"; sha256 = "0af1c20c98fe8eac6c2a89e964f3130a886e28511120a064efe43eb2ab5b8257"; }];
  };

  "tesseract-data-asm" = fetch {
    pname       = "tesseract-data-asm";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-asm-4.0.0-1-any.pkg.tar.xz"; sha256 = "b9843341bab2bf890a0826be48e25217dd7cc4f0dd9c273679f5dccf233a214e"; }];
  };

  "tesseract-data-aze" = fetch {
    pname       = "tesseract-data-aze";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-aze-4.0.0-1-any.pkg.tar.xz"; sha256 = "a2abc502bdd03123343fab8ca68a0375c6805203587cde95d3a40663beee4f13"; }];
  };

  "tesseract-data-aze_cyrl" = fetch {
    pname       = "tesseract-data-aze_cyrl";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-aze_cyrl-4.0.0-1-any.pkg.tar.xz"; sha256 = "7e96b46f014d7cabd9428a8c00caf7d7e40077523ea235155ea6e25bcb4e79e9"; }];
  };

  "tesseract-data-bel" = fetch {
    pname       = "tesseract-data-bel";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-bel-4.0.0-1-any.pkg.tar.xz"; sha256 = "8fc72571ff1e1ba0f64b26e4e2be7f9ce9cf64f423176243096700d6a6c694ac"; }];
  };

  "tesseract-data-ben" = fetch {
    pname       = "tesseract-data-ben";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ben-4.0.0-1-any.pkg.tar.xz"; sha256 = "058e09d5f8104fe7644bc8f34b26191eaae147e78205fc4f2d205645f698e0f3"; }];
  };

  "tesseract-data-bod" = fetch {
    pname       = "tesseract-data-bod";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-bod-4.0.0-1-any.pkg.tar.xz"; sha256 = "bc67d88f4a11b956296b08cc5b0ac9b45ee09e23fd488946cc236b42613c05c7"; }];
  };

  "tesseract-data-bos" = fetch {
    pname       = "tesseract-data-bos";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-bos-4.0.0-1-any.pkg.tar.xz"; sha256 = "a44162b788366d38e59a695e4de123e0ee01b594c4c4f86be7569cb172dc3004"; }];
  };

  "tesseract-data-bul" = fetch {
    pname       = "tesseract-data-bul";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-bul-4.0.0-1-any.pkg.tar.xz"; sha256 = "7c290679313a2a84ff5a0005f01de0a0192648c4f8b04f2775b478cbd195cbf0"; }];
  };

  "tesseract-data-cat" = fetch {
    pname       = "tesseract-data-cat";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-cat-4.0.0-1-any.pkg.tar.xz"; sha256 = "ff6f6986fd15952d95db779d1301f6bf8f6ebc094af4ed66bc5fe78cb63966c0"; }];
  };

  "tesseract-data-ceb" = fetch {
    pname       = "tesseract-data-ceb";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ceb-4.0.0-1-any.pkg.tar.xz"; sha256 = "68daf6a512063e86065c9db866d58cea91a0596a18ac0d4b1054e1017b7654ed"; }];
  };

  "tesseract-data-ces" = fetch {
    pname       = "tesseract-data-ces";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ces-4.0.0-1-any.pkg.tar.xz"; sha256 = "e694bcecb8ffd7cb96092ff57e45deaa634946bb95c14d004fe2c8aaf1d71a65"; }];
  };

  "tesseract-data-chi_sim" = fetch {
    pname       = "tesseract-data-chi_sim";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-chi_sim-4.0.0-1-any.pkg.tar.xz"; sha256 = "ed6dbcfc7022e8c2298ce7d7090107176e3fae3521ffd99ed5b5b5d8a490c8cb"; }];
  };

  "tesseract-data-chi_tra" = fetch {
    pname       = "tesseract-data-chi_tra";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-chi_tra-4.0.0-1-any.pkg.tar.xz"; sha256 = "7b492ef2858f368336f0cb06e555d54501fc6a308f59dcf1166b65dbfa12b6d8"; }];
  };

  "tesseract-data-chr" = fetch {
    pname       = "tesseract-data-chr";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-chr-4.0.0-1-any.pkg.tar.xz"; sha256 = "d2e1aa8208d917bd13f125d29b09b5f6662ee6a1301ab3c59e24b02fbc68357c"; }];
  };

  "tesseract-data-cym" = fetch {
    pname       = "tesseract-data-cym";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-cym-4.0.0-1-any.pkg.tar.xz"; sha256 = "c24429b25cdb2ecd1985b518733ab0fac052f4b38cbb5acce8eaebe01cddc351"; }];
  };

  "tesseract-data-dan" = fetch {
    pname       = "tesseract-data-dan";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-dan-4.0.0-1-any.pkg.tar.xz"; sha256 = "a728260c9ee77bddcd9e6bff13b436e4ddb5eea173767ac473af5a7a246c6108"; }];
  };

  "tesseract-data-dan_frak" = fetch {
    pname       = "tesseract-data-dan_frak";
    version     = "3.04.00";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-dan_frak-3.04.00-1-any.pkg.tar.xz"; sha256 = "b7a057292214578200efdd6a9e8458404f67842c3a88cea79824d3d520acc1e9"; }];
  };

  "tesseract-data-deu" = fetch {
    pname       = "tesseract-data-deu";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-deu-4.0.0-1-any.pkg.tar.xz"; sha256 = "461d55ec0e0b0975ffc3988187c086f09025711d3bffac1d56759e810cbd39c8"; }];
  };

  "tesseract-data-deu_frak" = fetch {
    pname       = "tesseract-data-deu_frak";
    version     = "3.04.00";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-deu_frak-3.04.00-1-any.pkg.tar.xz"; sha256 = "83fe1ea43069d81b2ac0666d2d279ddfc7f730b065ab799bb0a2c3ddebfb70d0"; }];
  };

  "tesseract-data-dzo" = fetch {
    pname       = "tesseract-data-dzo";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-dzo-4.0.0-1-any.pkg.tar.xz"; sha256 = "265c038094b62234f27d16a557c57965750c56012086c7e6a6098f141634ab54"; }];
  };

  "tesseract-data-ell" = fetch {
    pname       = "tesseract-data-ell";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ell-4.0.0-1-any.pkg.tar.xz"; sha256 = "6234757ae06770b05585bbb99dfed3b6f1df44ef1e7e122fef857da95cb06d0d"; }];
  };

  "tesseract-data-eng" = fetch {
    pname       = "tesseract-data-eng";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-eng-4.0.0-1-any.pkg.tar.xz"; sha256 = "1e7d9af728776ca0d322651d37d463686aa869adb9edbb1d3d3a153a2b46c771"; }];
  };

  "tesseract-data-enm" = fetch {
    pname       = "tesseract-data-enm";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-enm-4.0.0-1-any.pkg.tar.xz"; sha256 = "2fff4dd170b10fd9e536ae1986a0f62325a048a2452deb9a86a99b6768615902"; }];
  };

  "tesseract-data-epo" = fetch {
    pname       = "tesseract-data-epo";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-epo-4.0.0-1-any.pkg.tar.xz"; sha256 = "ef7a39654edba77737d4bbca8b82bf0c05b7b3e935fe23bf8b58cc74989e90ef"; }];
  };

  "tesseract-data-equ" = fetch {
    pname       = "tesseract-data-equ";
    version     = "3.04.00";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-equ-3.04.00-1-any.pkg.tar.xz"; sha256 = "c4d4e67f640f5d56efffa04624fe00e145badccdbcb51408e49d188637f9a9fc"; }];
  };

  "tesseract-data-est" = fetch {
    pname       = "tesseract-data-est";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-est-4.0.0-1-any.pkg.tar.xz"; sha256 = "13d0cbd7a40fb21bc199f8ed58cb5109b942de803c9ba1a0885e6d1015de3dfe"; }];
  };

  "tesseract-data-eus" = fetch {
    pname       = "tesseract-data-eus";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-eus-4.0.0-1-any.pkg.tar.xz"; sha256 = "2ec5fe4953cc720a3689b32afa01ab96cf877aabffacc1f98d5c44ffda3f5b74"; }];
  };

  "tesseract-data-fas" = fetch {
    pname       = "tesseract-data-fas";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-fas-4.0.0-1-any.pkg.tar.xz"; sha256 = "68c7607b5550c84f3a532cb9dba30dd9fa283448feb9ceda27ed8a047e7398e8"; }];
  };

  "tesseract-data-fin" = fetch {
    pname       = "tesseract-data-fin";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-fin-4.0.0-1-any.pkg.tar.xz"; sha256 = "83a1b179b74524c5b134c203eec9bff87ed138f3a54b605e86d0edc8d6016a2b"; }];
  };

  "tesseract-data-fra" = fetch {
    pname       = "tesseract-data-fra";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-fra-4.0.0-1-any.pkg.tar.xz"; sha256 = "15dab5e9905e72539c2e522e3095e2d4f113ee9959343949fbc10b76fce943de"; }];
  };

  "tesseract-data-frk" = fetch {
    pname       = "tesseract-data-frk";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-frk-4.0.0-1-any.pkg.tar.xz"; sha256 = "5ccf9466ed303cb44d4ee0ab287442a17b84d70fe388c06062ae11efe93e14c9"; }];
  };

  "tesseract-data-frm" = fetch {
    pname       = "tesseract-data-frm";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-frm-4.0.0-1-any.pkg.tar.xz"; sha256 = "c8939570ae2ee3fe2c11962c984de2f490bab9610ef3289ad8741f6676ff1925"; }];
  };

  "tesseract-data-gle" = fetch {
    pname       = "tesseract-data-gle";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-gle-4.0.0-1-any.pkg.tar.xz"; sha256 = "33dd441ed2602e024044e4724baa27e68121988e5aad9725aeb6c7268bf6b75a"; }];
  };

  "tesseract-data-glg" = fetch {
    pname       = "tesseract-data-glg";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-glg-4.0.0-1-any.pkg.tar.xz"; sha256 = "60db3c5048aefeac427a46cf9349eb8ccfdffa5d9d340ca770896b9ffc6fb6e6"; }];
  };

  "tesseract-data-grc" = fetch {
    pname       = "tesseract-data-grc";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-grc-4.0.0-1-any.pkg.tar.xz"; sha256 = "3caf63c105895494c82d8eae12dbf88b3d9caab8e3c27330d01a82f3cc427e54"; }];
  };

  "tesseract-data-guj" = fetch {
    pname       = "tesseract-data-guj";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-guj-4.0.0-1-any.pkg.tar.xz"; sha256 = "73e4a832a734334b38112ce63135033c1c4710414a862e84eb8825283f95da3c"; }];
  };

  "tesseract-data-hat" = fetch {
    pname       = "tesseract-data-hat";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-hat-4.0.0-1-any.pkg.tar.xz"; sha256 = "92dd48d724a2743cfa1e81594dc70329a3bdcbb29dda360255a874c94e4fdef9"; }];
  };

  "tesseract-data-heb" = fetch {
    pname       = "tesseract-data-heb";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-heb-4.0.0-1-any.pkg.tar.xz"; sha256 = "6c272e63daaf192862c031564a195a99a6cb57638e878f66b6e3749abba11f16"; }];
  };

  "tesseract-data-hin" = fetch {
    pname       = "tesseract-data-hin";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-hin-4.0.0-1-any.pkg.tar.xz"; sha256 = "0da128841f62de9f8642215a2fe0d3322eed7d1819637ead4fd4629203cedda4"; }];
  };

  "tesseract-data-hrv" = fetch {
    pname       = "tesseract-data-hrv";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-hrv-4.0.0-1-any.pkg.tar.xz"; sha256 = "101a5ff7ee035ee21de2833bdb1c939d707dd0dff6e671c8cea3b768213dcaec"; }];
  };

  "tesseract-data-hun" = fetch {
    pname       = "tesseract-data-hun";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-hun-4.0.0-1-any.pkg.tar.xz"; sha256 = "b9b8c5aad2e105ff72509d05746f4c8184821fe0c7f6bf60b8b14115ada22bd5"; }];
  };

  "tesseract-data-iku" = fetch {
    pname       = "tesseract-data-iku";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-iku-4.0.0-1-any.pkg.tar.xz"; sha256 = "f5914b822608d7bcdceb1d3491f709d0780fe3939da7f9bcfc6ab11a2702ec7c"; }];
  };

  "tesseract-data-ind" = fetch {
    pname       = "tesseract-data-ind";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ind-4.0.0-1-any.pkg.tar.xz"; sha256 = "1b4aa2d3570452997a40fed903d3665ee7a90a47ccf52d540c2a00384b5b64dd"; }];
  };

  "tesseract-data-isl" = fetch {
    pname       = "tesseract-data-isl";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-isl-4.0.0-1-any.pkg.tar.xz"; sha256 = "f473ab10a11d9f8285fbc53d4aaa1da13d0ff3b5dc03e1599c51d07c7fb7cb85"; }];
  };

  "tesseract-data-ita" = fetch {
    pname       = "tesseract-data-ita";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ita-4.0.0-1-any.pkg.tar.xz"; sha256 = "434678eb10596eafed9e5f815da80a6e325847d61992c85459dd309ec0a4278b"; }];
  };

  "tesseract-data-ita_old" = fetch {
    pname       = "tesseract-data-ita_old";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ita_old-4.0.0-1-any.pkg.tar.xz"; sha256 = "5c07286986a33c58398debff958a0d859f86eb7b1e426797c208993031636847"; }];
  };

  "tesseract-data-jav" = fetch {
    pname       = "tesseract-data-jav";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-jav-4.0.0-1-any.pkg.tar.xz"; sha256 = "3efff2f6f82a17858b7c38422ec47a291bdeb5e0e5b308f5d0bf2c931319910c"; }];
  };

  "tesseract-data-jpn" = fetch {
    pname       = "tesseract-data-jpn";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-jpn-4.0.0-1-any.pkg.tar.xz"; sha256 = "841bc6c0d68cd98159ed6d4c9e1649827d996d577389260c502549858f28ca53"; }];
  };

  "tesseract-data-kan" = fetch {
    pname       = "tesseract-data-kan";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-kan-4.0.0-1-any.pkg.tar.xz"; sha256 = "d813d2153d0390895f66cc9d4de31a4e6a8f82f6e555808285071479b5de785e"; }];
  };

  "tesseract-data-kat" = fetch {
    pname       = "tesseract-data-kat";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-kat-4.0.0-1-any.pkg.tar.xz"; sha256 = "e5ac31c69047cbf88cc1a71598a2046387745623deceb5d2e88f8e87c925c541"; }];
  };

  "tesseract-data-kat_old" = fetch {
    pname       = "tesseract-data-kat_old";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-kat_old-4.0.0-1-any.pkg.tar.xz"; sha256 = "141ab7fb125d6730f45c5b60875c2b5c6bcd82fe702b2b85679216a324edea7d"; }];
  };

  "tesseract-data-kaz" = fetch {
    pname       = "tesseract-data-kaz";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-kaz-4.0.0-1-any.pkg.tar.xz"; sha256 = "aa1dc65871279de4c31867266da610675f4d619236421c567be7d3f5ebfe35a8"; }];
  };

  "tesseract-data-khm" = fetch {
    pname       = "tesseract-data-khm";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-khm-4.0.0-1-any.pkg.tar.xz"; sha256 = "083295ff24219ac85072a8c09711f20dfc911d6a965ca9da28a9353c465cbd4f"; }];
  };

  "tesseract-data-kir" = fetch {
    pname       = "tesseract-data-kir";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-kir-4.0.0-1-any.pkg.tar.xz"; sha256 = "cdffa9d630e7b1c36a902d6d2ad3b43e272fcdcd085cfbcb5c3569b706dd5b03"; }];
  };

  "tesseract-data-kor" = fetch {
    pname       = "tesseract-data-kor";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-kor-4.0.0-1-any.pkg.tar.xz"; sha256 = "2f4cf3791036a006910b335010865df66a30b4fdabd1e1fd66a01aaa84d2671f"; }];
  };

  "tesseract-data-kur" = fetch {
    pname       = "tesseract-data-kur";
    version     = "3.04.00";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-kur-3.04.00-1-any.pkg.tar.xz"; sha256 = "8590f531ce56b66f56edae4bf0c47744f31d822e1596208b947c0393cda437a3"; }];
  };

  "tesseract-data-lao" = fetch {
    pname       = "tesseract-data-lao";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-lao-4.0.0-1-any.pkg.tar.xz"; sha256 = "f4eecc3f0e1c9f614e6bdb958a7e39f259be27439e958aab6b8df241ba6dc4a7"; }];
  };

  "tesseract-data-lat" = fetch {
    pname       = "tesseract-data-lat";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-lat-4.0.0-1-any.pkg.tar.xz"; sha256 = "b6020b4d58ecd4e826a443b7e656ded8cd00c71e1775537c17aeafeeeb70c8b1"; }];
  };

  "tesseract-data-lav" = fetch {
    pname       = "tesseract-data-lav";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-lav-4.0.0-1-any.pkg.tar.xz"; sha256 = "57e1cd8abb1979f9cd0ee5053056fc781bfebdae20e31616c507fae7236a73d0"; }];
  };

  "tesseract-data-lit" = fetch {
    pname       = "tesseract-data-lit";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-lit-4.0.0-1-any.pkg.tar.xz"; sha256 = "067c2bdbaf1c5501ab9a8bae7b93fb9f8ab2406d3114a3d0aeea0baa9f0c2637"; }];
  };

  "tesseract-data-mal" = fetch {
    pname       = "tesseract-data-mal";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-mal-4.0.0-1-any.pkg.tar.xz"; sha256 = "e295bea2903eb983dcf5fedd91662662aee3da00ff429b5007e832feaa9ecd5d"; }];
  };

  "tesseract-data-mar" = fetch {
    pname       = "tesseract-data-mar";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-mar-4.0.0-1-any.pkg.tar.xz"; sha256 = "8c8341a639a3fb9bffe3cba2958b3a8bd866a56bdd8271043352f8c2b3198cc9"; }];
  };

  "tesseract-data-mkd" = fetch {
    pname       = "tesseract-data-mkd";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-mkd-4.0.0-1-any.pkg.tar.xz"; sha256 = "be6053a3ae68a7c0d248a930bfdcbcc4bb45ce0586c03e241b91e1b88465e6da"; }];
  };

  "tesseract-data-mlt" = fetch {
    pname       = "tesseract-data-mlt";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-mlt-4.0.0-1-any.pkg.tar.xz"; sha256 = "ff9541625e8e45a7047536d4984085bcbb7938e5902e47919260a04315ba54ec"; }];
  };

  "tesseract-data-msa" = fetch {
    pname       = "tesseract-data-msa";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-msa-4.0.0-1-any.pkg.tar.xz"; sha256 = "f7d273614dd057121f919ea8b056d378aaf9f0945b23f8a3f44a2c1513018665"; }];
  };

  "tesseract-data-mya" = fetch {
    pname       = "tesseract-data-mya";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-mya-4.0.0-1-any.pkg.tar.xz"; sha256 = "d1d7a6a621eb24f4022e3c81804bd86cef266ac724d60f299f47071681207605"; }];
  };

  "tesseract-data-nep" = fetch {
    pname       = "tesseract-data-nep";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-nep-4.0.0-1-any.pkg.tar.xz"; sha256 = "b579a2210e2618abdd8c3c9201fd7b6f32a9be14c76845ecf4f162800021a44d"; }];
  };

  "tesseract-data-nld" = fetch {
    pname       = "tesseract-data-nld";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-nld-4.0.0-1-any.pkg.tar.xz"; sha256 = "78cd737ee98c8e96dab8891a9bcb2dac9a1b7f12677c8fb55e134e4113133906"; }];
  };

  "tesseract-data-nor" = fetch {
    pname       = "tesseract-data-nor";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-nor-4.0.0-1-any.pkg.tar.xz"; sha256 = "525dc0a5b53aaa8170ea35a6cf2d63f4363b9ef2958a044b8e6d003728c3e5b1"; }];
  };

  "tesseract-data-ori" = fetch {
    pname       = "tesseract-data-ori";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ori-4.0.0-1-any.pkg.tar.xz"; sha256 = "4128cdbbd5aac8973097f5162e8abe2bcce2f6bbd191ecfce9d763d39be28504"; }];
  };

  "tesseract-data-pan" = fetch {
    pname       = "tesseract-data-pan";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-pan-4.0.0-1-any.pkg.tar.xz"; sha256 = "222b0d3fab27e6e7a51a3a0ddc5df24d044c330f18d94707223afe3f3be9e237"; }];
  };

  "tesseract-data-pol" = fetch {
    pname       = "tesseract-data-pol";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-pol-4.0.0-1-any.pkg.tar.xz"; sha256 = "601834120f2d927ed115ea413fe0c861d614a9cb17a0c2f074bbb705c840401d"; }];
  };

  "tesseract-data-por" = fetch {
    pname       = "tesseract-data-por";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-por-4.0.0-1-any.pkg.tar.xz"; sha256 = "796e5de9c06fa5d8087289a91fbf4f1429289f7363fc617e9cd7257c2d8f660f"; }];
  };

  "tesseract-data-pus" = fetch {
    pname       = "tesseract-data-pus";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-pus-4.0.0-1-any.pkg.tar.xz"; sha256 = "35a6d04e9448b0134b168726e7fd2ce8a7eb7d2994d6feb60eb036955aa8ed02"; }];
  };

  "tesseract-data-ron" = fetch {
    pname       = "tesseract-data-ron";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ron-4.0.0-1-any.pkg.tar.xz"; sha256 = "c411710e0dd4dfefb749fd108ec0761474e7c3258506bf5b5ba44422896e48ef"; }];
  };

  "tesseract-data-rus" = fetch {
    pname       = "tesseract-data-rus";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-rus-4.0.0-1-any.pkg.tar.xz"; sha256 = "a91186977c9b099e103b2bb3624dc570b3daeb4d12ca892fa931ba299808a333"; }];
  };

  "tesseract-data-san" = fetch {
    pname       = "tesseract-data-san";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-san-4.0.0-1-any.pkg.tar.xz"; sha256 = "12e3eee85f166dcf82b528eee49486f3c1617ca2f6b1f9db67b916e97ab24c13"; }];
  };

  "tesseract-data-sin" = fetch {
    pname       = "tesseract-data-sin";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-sin-4.0.0-1-any.pkg.tar.xz"; sha256 = "f4366c80f93438afac7166691840977fdf1dc6acb98f60d41b038cb6e57d37ad"; }];
  };

  "tesseract-data-slk" = fetch {
    pname       = "tesseract-data-slk";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-slk-4.0.0-1-any.pkg.tar.xz"; sha256 = "0a0e166eb29d1db6fd61ac7e48cb36d32700920150033be1c5c456d21acf8a6a"; }];
  };

  "tesseract-data-slk_frak" = fetch {
    pname       = "tesseract-data-slk_frak";
    version     = "3.04.00";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-slk_frak-3.04.00-1-any.pkg.tar.xz"; sha256 = "2685aaf7ce7062f3a89fdbcbc53c99a528c1f836e872b1cc789159ba0c18f047"; }];
  };

  "tesseract-data-slv" = fetch {
    pname       = "tesseract-data-slv";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-slv-4.0.0-1-any.pkg.tar.xz"; sha256 = "6b2e2797898982a2f38d003ba04be84fc0f34e7adc5595eaab4bda6e0bf71af6"; }];
  };

  "tesseract-data-spa" = fetch {
    pname       = "tesseract-data-spa";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-spa-4.0.0-1-any.pkg.tar.xz"; sha256 = "3b8023be3aa933f10f65c72de2b735b320d7f5776e63035857b14ff18accc50d"; }];
  };

  "tesseract-data-spa_old" = fetch {
    pname       = "tesseract-data-spa_old";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-spa_old-4.0.0-1-any.pkg.tar.xz"; sha256 = "9f22e091e4dd86609851ffae3d8831fe87ace9cf25d635816c18a60dad3bcd76"; }];
  };

  "tesseract-data-sqi" = fetch {
    pname       = "tesseract-data-sqi";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-sqi-4.0.0-1-any.pkg.tar.xz"; sha256 = "3534468433e7bda23e4f6f1a0ba56d8304a7cb3d77fb5cbce21d09b3fce9d3c5"; }];
  };

  "tesseract-data-srp" = fetch {
    pname       = "tesseract-data-srp";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-srp-4.0.0-1-any.pkg.tar.xz"; sha256 = "7b8fa67bb7de20373ae344a41f24fc85358ec500efbfe93330e26ddb42213aac"; }];
  };

  "tesseract-data-srp_latn" = fetch {
    pname       = "tesseract-data-srp_latn";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-srp_latn-4.0.0-1-any.pkg.tar.xz"; sha256 = "cec84e2273f2320399b377786f470c7cb7c770d5d75b62990a408d56e13b5c5e"; }];
  };

  "tesseract-data-swa" = fetch {
    pname       = "tesseract-data-swa";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-swa-4.0.0-1-any.pkg.tar.xz"; sha256 = "bca9d9336d09d0f0e086c2c994608a987f209d6d420ecc30f3d32c31f2bff1db"; }];
  };

  "tesseract-data-swe" = fetch {
    pname       = "tesseract-data-swe";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-swe-4.0.0-1-any.pkg.tar.xz"; sha256 = "10e62b2e423769019b304cffc7f10d1d2406ff4cccbd509af38bd09f36d395fe"; }];
  };

  "tesseract-data-syr" = fetch {
    pname       = "tesseract-data-syr";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-syr-4.0.0-1-any.pkg.tar.xz"; sha256 = "39ff4f5671e00804465dccb06506f00b6d079617bd7ac4be8566311ef29dd441"; }];
  };

  "tesseract-data-tam" = fetch {
    pname       = "tesseract-data-tam";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-tam-4.0.0-1-any.pkg.tar.xz"; sha256 = "2218ec2dda184fd92c4c617903000a4d080e85c0807bb5dd6fd83d9cb837dddc"; }];
  };

  "tesseract-data-tel" = fetch {
    pname       = "tesseract-data-tel";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-tel-4.0.0-1-any.pkg.tar.xz"; sha256 = "5822d7cb3459329a4cf8d602dff2343ade7d2203b9ce6cdef26ac9c95707d552"; }];
  };

  "tesseract-data-tgk" = fetch {
    pname       = "tesseract-data-tgk";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-tgk-4.0.0-1-any.pkg.tar.xz"; sha256 = "cd38e308e6572aa53c8df90cfda9503c400b39a899257025f652793f3a4e8a45"; }];
  };

  "tesseract-data-tgl" = fetch {
    pname       = "tesseract-data-tgl";
    version     = "3.04.00";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-tgl-3.04.00-1-any.pkg.tar.xz"; sha256 = "f842bdd8ae986118c5e24a0c61fb128603ce65be61fa6a6ec23d56bd43736491"; }];
  };

  "tesseract-data-tha" = fetch {
    pname       = "tesseract-data-tha";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-tha-4.0.0-1-any.pkg.tar.xz"; sha256 = "b0877d326d94987fbb3b9cf0f21fbb8c5e76e21f130bcc188fd7cf6b927d6e1a"; }];
  };

  "tesseract-data-tir" = fetch {
    pname       = "tesseract-data-tir";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-tir-4.0.0-1-any.pkg.tar.xz"; sha256 = "ce7c9034ebb87d183eef15238eae1e847d60e6ab244aebd9f70778c3ddc82859"; }];
  };

  "tesseract-data-tur" = fetch {
    pname       = "tesseract-data-tur";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-tur-4.0.0-1-any.pkg.tar.xz"; sha256 = "6900130757f9dd88ad1f8da6110e50405471240def3244606df0b60bbc8b2b09"; }];
  };

  "tesseract-data-uig" = fetch {
    pname       = "tesseract-data-uig";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-uig-4.0.0-1-any.pkg.tar.xz"; sha256 = "5c4931218fb2acfe18a5896d264ec2f592a212935efa6678f6668273b23381e2"; }];
  };

  "tesseract-data-ukr" = fetch {
    pname       = "tesseract-data-ukr";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-ukr-4.0.0-1-any.pkg.tar.xz"; sha256 = "4fec3733fec88da1009e5d9e8b42f3d9d2c513ede0bed0a4da48df7c487c8846"; }];
  };

  "tesseract-data-urd" = fetch {
    pname       = "tesseract-data-urd";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-urd-4.0.0-1-any.pkg.tar.xz"; sha256 = "57af610f98106ae0fab6a9fe675824790240fcd3108777fe3581b8cf2edc86b4"; }];
  };

  "tesseract-data-uzb" = fetch {
    pname       = "tesseract-data-uzb";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-uzb-4.0.0-1-any.pkg.tar.xz"; sha256 = "ad9d2dece6381ea3f79c3d0b33c9b206d674a6bb9f143d6794c7c14a52857683"; }];
  };

  "tesseract-data-uzb_cyrl" = fetch {
    pname       = "tesseract-data-uzb_cyrl";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-uzb_cyrl-4.0.0-1-any.pkg.tar.xz"; sha256 = "0f17d36411edffc83986d743721492d836088bbf0367f9ed7fca8e6ad6208761"; }];
  };

  "tesseract-data-vie" = fetch {
    pname       = "tesseract-data-vie";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-vie-4.0.0-1-any.pkg.tar.xz"; sha256 = "7b3c1a7188a86d497848e453089d032be474d358af86d9012ed22cd008c40fac"; }];
  };

  "tesseract-data-yid" = fetch {
    pname       = "tesseract-data-yid";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-data-yid-4.0.0-1-any.pkg.tar.xz"; sha256 = "c50ca093706869a413d889d519acf293f1f579258989c35a32141fe0f246e885"; }];
  };

  "tesseract-ocr" = fetch {
    pname       = "tesseract-ocr";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-i686-tesseract-ocr-4.0.0-1-any.pkg.tar.xz"; sha256 = "3eacbd5ec6a3917fbe2caeea41a3d47c1528f04eff9ec2d7b061cf5dda5617b0"; }];
    buildInputs = [ cairo gcc-libs icu leptonica pango zlib ];
  };

  "threadweaver-qt5" = fetch {
    pname       = "threadweaver-qt5";
    version     = "5.50.0";
    srcs        = [{ filename = "mingw-w64-i686-threadweaver-qt5-5.50.0-1-any.pkg.tar.xz"; sha256 = "da5e00c6e0f24b4d3526bf9bada235857af39d6d8579068d2de66124aeee1fc0"; }];
    buildInputs = [ qt5 ];
  };

  "thrift-git" = fetch {
    pname       = "thrift-git";
    version     = "1.0.r5327.a92358054";
    srcs        = [{ filename = "mingw-w64-i686-thrift-git-1.0.r5327.a92358054-1-any.pkg.tar.xz"; sha256 = "2f7a41476bedb5852272d288390c940964624aafa3d521df12dfb1d5753c5d1d"; }];
    buildInputs = [ gcc-libs boost openssl zlib ];
  };

  "tidy" = fetch {
    pname       = "tidy";
    version     = "5.7.16";
    srcs        = [{ filename = "mingw-w64-i686-tidy-5.7.16-1-any.pkg.tar.xz"; sha256 = "2cc9ca62fc5457890dcdcb3e2aa768f19d665e51a9851e1d59d68df7af5f9267"; }];
    buildInputs = [ gcc-libs ];
  };

  "tiny-dnn" = fetch {
    pname       = "tiny-dnn";
    version     = "1.0.0a3";
    srcs        = [{ filename = "mingw-w64-i686-tiny-dnn-1.0.0a3-2-any.pkg.tar.xz"; sha256 = "6e88077371f7febc7643d00ace3f8c2c7843bf9f847a9bacf084e644ad88e29d"; }];
    buildInputs = [ intel-tbb protobuf ];
  };

  "tinyformat" = fetch {
    pname       = "tinyformat";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-i686-tinyformat-2.1.0-1-any.pkg.tar.xz"; sha256 = "8ca4f665608fb55152f1377806ae445e43ff09eec3f29e2956896a2e6478b888"; }];
  };

  "tinyxml" = fetch {
    pname       = "tinyxml";
    version     = "2.6.2";
    srcs        = [{ filename = "mingw-w64-i686-tinyxml-2.6.2-4-any.pkg.tar.xz"; sha256 = "14f67ae4e9790dcc55bd0fca5e5605d16a246ad8940659cea5fd3ef13d71d5ac"; }];
    buildInputs = [ gcc-libs ];
  };

  "tinyxml2" = fetch {
    pname       = "tinyxml2";
    version     = "7.0.1";
    srcs        = [{ filename = "mingw-w64-i686-tinyxml2-7.0.1-1-any.pkg.tar.xz"; sha256 = "be427d8219b5a63d239ab8f9aea49531ac2d1dae8651824dbc2e519388f148fe"; }];
    buildInputs = [ gcc-libs ];
  };

  "tk" = fetch {
    pname       = "tk";
    version     = "8.6.9.1";
    srcs        = [{ filename = "mingw-w64-i686-tk-8.6.9.1-1-any.pkg.tar.xz"; sha256 = "846b90c5cceb12089dfbf8710f4e42a9de03c11681febd3833270ad9ed81a0fe"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast tcl.version "8.6.9"; tcl) ];
  };

  "tkimg" = fetch {
    pname       = "tkimg";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-i686-tkimg-1.4.2-3-any.pkg.tar.xz"; sha256 = "b627534c2a9ffd7ea3d5dfa65532a6e1e60f7784aef10e74e659686e386600b8"; }];
    buildInputs = [ libjpeg libpng libtiff tk zlib ];
  };

  "tklib" = fetch {
    pname       = "tklib";
    version     = "0.6";
    srcs        = [{ filename = "mingw-w64-i686-tklib-0.6-5-any.pkg.tar.xz"; sha256 = "e650b2c23254d465b3caa2a3fc42c54335e3571ba07051cffb9caaa6ab3ac8ac"; }];
    buildInputs = [ tk tcllib ];
  };

  "tktable" = fetch {
    pname       = "tktable";
    version     = "2.10";
    srcs        = [{ filename = "mingw-w64-i686-tktable-2.10-4-any.pkg.tar.xz"; sha256 = "79ea5a3c7aad0573fec1d3eaeddec2de26804877f10a13ec24080d97d8235689"; }];
    buildInputs = [ tk ];
  };

  "tolua" = fetch {
    pname       = "tolua";
    version     = "5.2.4";
    srcs        = [{ filename = "mingw-w64-i686-tolua-5.2.4-3-any.pkg.tar.xz"; sha256 = "21d88b751613ff353acbbd68bcdae258aa672ced0504487c4046a8131f874b28"; }];
    buildInputs = [ lua ];
  };

  "tools-git" = fetch {
    pname       = "tools-git";
    version     = "7.0.0.5272.d66350ea";
    srcs        = [{ filename = "mingw-w64-i686-tools-git-7.0.0.5272.d66350ea-1-any.pkg.tar.xz"; sha256 = "704f8c3edac6ca93d199c1363ba02923c717d4d9ccc49f3d10c43752de40734e"; }];
    buildInputs = [ gcc-libs ];
  };

  "tor" = fetch {
    pname       = "tor";
    version     = "0.3.3.6";
    srcs        = [{ filename = "mingw-w64-i686-tor-0.3.3.6-1-any.pkg.tar.xz"; sha256 = "2ade4ceb161ad15b4a7709d1f00df2ec01689393d5aecb9ce12bd911da99f98a"; }];
    buildInputs = [ libevent openssl zlib ];
  };

  "totem-pl-parser" = fetch {
    pname       = "totem-pl-parser";
    version     = "3.26.1";
    srcs        = [{ filename = "mingw-w64-i686-totem-pl-parser-3.26.1-1-any.pkg.tar.xz"; sha256 = "17408fc7a4aa457d58e63afed9707d3e53308af0f96e304b42e2a6dc8519806e"; }];
    buildInputs = [ glib2 gmime libsoup libarchive libgcrypt ];
  };

  "transmission" = fetch {
    pname       = "transmission";
    version     = "2.94";
    srcs        = [{ filename = "mingw-w64-i686-transmission-2.94-2-any.pkg.tar.xz"; sha256 = "c0504657594244a4266cde46b24406afe9d42c635266a2d67eee1888f153fa3f"; }];
    buildInputs = [ openssl libevent gtk3 curl zlib miniupnpc ];
  };

  "trompeloeil" = fetch {
    pname       = "trompeloeil";
    version     = "31";
    srcs        = [{ filename = "mingw-w64-i686-trompeloeil-31-1-any.pkg.tar.xz"; sha256 = "5eb1f0303fba53c74c7a1653daa07c1e94b89410cb39b7db94d4369de3f39af5"; }];
  };

  "ttf-dejavu" = fetch {
    pname       = "ttf-dejavu";
    version     = "2.37";
    srcs        = [{ filename = "mingw-w64-i686-ttf-dejavu-2.37-1-any.pkg.tar.xz"; sha256 = "bcc4fd261cf2b2aee572c8c78b0810b84c31f1ef921d0daed6f3c10d6315cf54"; }];
    buildInputs = [ fontconfig ];
  };

  "tulip" = fetch {
    pname       = "tulip";
    version     = "5.2.1";
    srcs        = [{ filename = "mingw-w64-i686-tulip-5.2.1-1-any.pkg.tar.xz"; sha256 = "f17f9433c719d7556acfba6ba0d70959197588f4985712bdc453e98c5e5d658c"; }];
    buildInputs = [ freetype glew libpng libjpeg python3 qhull-git qt5 qtwebkit quazip yajl ];
  };

  "twolame" = fetch {
    pname       = "twolame";
    version     = "0.3.13";
    srcs        = [{ filename = "mingw-w64-i686-twolame-0.3.13-3-any.pkg.tar.xz"; sha256 = "ee3a820b3875f0ca93b6ec2e05ca49e1d3476f4254eeceb5acee5c17cd958aff"; }];
    buildInputs = [ libsndfile ];
  };

  "uchardet" = fetch {
    pname       = "uchardet";
    version     = "0.0.6";
    srcs        = [{ filename = "mingw-w64-i686-uchardet-0.0.6-1-any.pkg.tar.xz"; sha256 = "0e278dcd7b31e38449cf70db2ab6974ab2b1cac5fc3fad7ecfadcd23aae0b46e"; }];
    buildInputs = [ gcc-libs ];
  };

  "ucl" = fetch {
    pname       = "ucl";
    version     = "1.03";
    srcs        = [{ filename = "mingw-w64-i686-ucl-1.03-1-any.pkg.tar.xz"; sha256 = "d584dbadcc761eb53712d439d1dde59d0e9a1192bc7f4b3f6486022996e6be6e"; }];
  };

  "udis86" = fetch {
    pname       = "udis86";
    version     = "1.7.2";
    srcs        = [{ filename = "mingw-w64-i686-udis86-1.7.2-1-any.pkg.tar.xz"; sha256 = "dfa19f3797455b5406cedcae0fad1a8bb67eab4754cbc231a0216e6016eaccb0"; }];
    buildInputs = [ python2 ];
  };

  "uhttpmock" = fetch {
    pname       = "uhttpmock";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-i686-uhttpmock-0.5.1-1-any.pkg.tar.xz"; sha256 = "f601ee99e831cc5c95fb473a0cc4dc9f02ebc0526eaa8c7f5afac6645e9ae3ef"; }];
    buildInputs = [ glib2 libsoup ];
  };

  "unbound" = fetch {
    pname       = "unbound";
    version     = "1.8.3";
    srcs        = [{ filename = "mingw-w64-i686-unbound-1.8.3-1-any.pkg.tar.xz"; sha256 = "4b9da0812a5d8e63273d14fbb18e6651a9845563721e7fa274595d04024c2b94"; }];
    buildInputs = [ openssl expat ldns ];
  };

  "unibilium" = fetch {
    pname       = "unibilium";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-i686-unibilium-2.0.0-1-any.pkg.tar.xz"; sha256 = "9f011509e68f0a9013d023865c69e76cd2607c287560773e9089530359d2e08d"; }];
  };

  "unicorn" = fetch {
    pname       = "unicorn";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-i686-unicorn-1.0.1-3-any.pkg.tar.xz"; sha256 = "3787d2c770336b6cc6bcb783ded9cf088799aa2f03e925eba5a6720fd1857b51"; }];
    buildInputs = [ gcc-libs ];
  };

  "universal-ctags-git" = fetch {
    pname       = "universal-ctags-git";
    version     = "r6369.5728abe4";
    srcs        = [{ filename = "mingw-w64-i686-universal-ctags-git-r6369.5728abe4-1-any.pkg.tar.xz"; sha256 = "94ffb8c80447e895dae49cbfc93caeb5ebad0ec6f0c6154b88657fffbda24213"; }];
    buildInputs = [ gcc-libs jansson libiconv libxml2 libyaml ];
  };

  "unixodbc" = fetch {
    pname       = "unixodbc";
    version     = "2.3.7";
    srcs        = [{ filename = "mingw-w64-i686-unixodbc-2.3.7-1-any.pkg.tar.xz"; sha256 = "763d4dcfc184b3b391fe2c35336c5c4dd975ec767f57d92c107542eec94f49b4"; }];
    buildInputs = [ gcc-libs readline libtool ];
  };

  "uriparser" = fetch {
    pname       = "uriparser";
    version     = "0.9.1";
    srcs        = [{ filename = "mingw-w64-i686-uriparser-0.9.1-1-any.pkg.tar.xz"; sha256 = "b5a81b69327210101c0690a1f9a24773ef272ac8bd9f26857ca99daab54060e7"; }];
    buildInputs = [  ];
  };

  "usbredir" = fetch {
    pname       = "usbredir";
    version     = "0.8.0";
    srcs        = [{ filename = "mingw-w64-i686-usbredir-0.8.0-1-any.pkg.tar.xz"; sha256 = "66ac7d2b7fc39c6cd9f8e5506839bf320398fcaa40dd70ebce4b5cac99af962f"; }];
    buildInputs = [ libusb ];
  };

  "usbview-git" = fetch {
    pname       = "usbview-git";
    version     = "42.c4ba9c6";
    srcs        = [{ filename = "mingw-w64-i686-usbview-git-42.c4ba9c6-1-any.pkg.tar.xz"; sha256 = "160ca679d083ad407f45d672b94a26fd8ffcdf37d30a3d288310f79888d3b79b"; }];
  };

  "usql" = fetch {
    pname       = "usql";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-i686-usql-0.8.1-1-any.pkg.tar.xz"; sha256 = "7ae7a0623d92cdbd1e53984aaf50f9d46e63982c94550de4fc10ae3b7dd85d85"; }];
    buildInputs = [ antlr3 ];
  };

  "usrsctp" = fetch {
    pname       = "usrsctp";
    version     = "0.9.3.0";
    srcs        = [{ filename = "mingw-w64-i686-usrsctp-0.9.3.0-1-any.pkg.tar.xz"; sha256 = "50c5634cacc28197f6ff48005921ca4c11facb64559d0c74528796426d5b5247"; }];
  };

  "vala" = fetch {
    pname       = "vala";
    version     = "0.42.4";
    srcs        = [{ filename = "mingw-w64-i686-vala-0.42.4-1-any.pkg.tar.xz"; sha256 = "c4cd42f75eca3fcf9dfa2858e300aefeab97cd8880b6341e5dbaa72f8002f5af"; }];
    buildInputs = [ glib2 graphviz ];
  };

  "vamp-plugin-sdk" = fetch {
    pname       = "vamp-plugin-sdk";
    version     = "2.7.1";
    srcs        = [{ filename = "mingw-w64-i686-vamp-plugin-sdk-2.7.1-1-any.pkg.tar.xz"; sha256 = "4946d284509c1d76de0648f7f944008f91432c09f9ff1500d02b8e4300722883"; }];
    buildInputs = [ gcc-libs libsndfile ];
  };

  "vapoursynth" = fetch {
    pname       = "vapoursynth";
    version     = "45.1";
    srcs        = [{ filename = "mingw-w64-i686-vapoursynth-45.1-1-any.pkg.tar.xz"; sha256 = "e4e45b59dd056a6623b9e65b80a22e822ad48b21209cd1cbe5177afeebe0f915"; }];
    buildInputs = [ gcc-libs cython ffmpeg imagemagick libass libxml2 python3 tesseract-ocr zimg ];
  };

  "vcdimager" = fetch {
    pname       = "vcdimager";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-i686-vcdimager-2.0.1-1-any.pkg.tar.xz"; sha256 = "54febeb2464d5069b8dfebe08b69a78a8ac6982c35b2670f6d2efddf846eeda4"; }];
    buildInputs = [ libcdio libxml2 popt ];
  };

  "verilator" = fetch {
    pname       = "verilator";
    version     = "4.004";
    srcs        = [{ filename = "mingw-w64-i686-verilator-4.004-1-any.pkg.tar.xz"; sha256 = "80d888ab0b869adff53ff172118cb7dee897032e0f9a58eaa18877b042089b7d"; }];
    buildInputs = [ gcc-libs ];
  };

  "vid.stab" = fetch {
    pname       = "vid.stab";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-i686-vid.stab-1.1-1-any.pkg.tar.xz"; sha256 = "d81e34cb8bd3cc391e43cf9daed05660dff316827850f30d7f3b9e08850d480b"; }];
  };

  "vigra" = fetch {
    pname       = "vigra";
    version     = "1.11.1";
    srcs        = [{ filename = "mingw-w64-i686-vigra-1.11.1-2-any.pkg.tar.xz"; sha256 = "6620671a0d8a2b751fb4bf719a9afb8bc53067b0844d4e7706afb192e4f9772a"; }];
    buildInputs = [ gcc-libs boost fftw hdf5 libjpeg-turbo libpng libtiff openexr python2-numpy zlib ];
  };

  "virt-viewer" = fetch {
    pname       = "virt-viewer";
    version     = "7.0";
    srcs        = [{ filename = "mingw-w64-i686-virt-viewer-7.0-1-any.pkg.tar.xz"; sha256 = "0fa1b91ac29b5559c72e98b34b56a9a433e7457a2c022e7ea8b839ccb627431d"; }];
    buildInputs = [ spice-gtk gtk-vnc libxml2 opus ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "vlc" = fetch {
    pname       = "vlc";
    version     = "3.0.5";
    srcs        = [{ filename = "mingw-w64-i686-vlc-3.0.5-1-any.pkg.tar.xz"; sha256 = "e00d7f156256a313bce7c7d37b24164ef0cbb1ed931cb97a0810f0cb96907d64"; }];
    buildInputs = [ a52dec aribb24 chromaprint faad2 ffmpeg flac fluidsynth fribidi gnutls gsm libass libbluray libcaca libcddb libcdio libdca libdsm libdvdcss libdvdnav libdvbpsi libgme libgoom2 libmad libmatroska libmicrodns libmpcdec libmpeg2-git libmysofa libnfs libplacebo libproxy librsvg libsamplerate libshout libssh2 libtheora libvpx libxml2 lua51 opencv opus portaudio protobuf pupnp schroedinger speex srt taglib twolame vcdimager x264-git x265 xpm-nox qt5 ];
  };

  "vlfeat" = fetch {
    pname       = "vlfeat";
    version     = "0.9.21";
    srcs        = [{ filename = "mingw-w64-i686-vlfeat-0.9.21-1-any.pkg.tar.xz"; sha256 = "7b5539b8e9b6a9f91ca942ce3c378c2a255c1f2d63d58952dcb8a6b8f5477b22"; }];
    buildInputs = [ gcc-libs ];
  };

  "vo-amrwbenc" = fetch {
    pname       = "vo-amrwbenc";
    version     = "0.1.3";
    srcs        = [{ filename = "mingw-w64-i686-vo-amrwbenc-0.1.3-1-any.pkg.tar.xz"; sha256 = "b7eeb05009156701809860e0eb22f4627e5fe4cace45323d1a5efdac3168bf57"; }];
  };

  "vrpn" = fetch {
    pname       = "vrpn";
    version     = "7.34";
    srcs        = [{ filename = "mingw-w64-i686-vrpn-7.34-3-any.pkg.tar.xz"; sha256 = "e6760ea42f30730ef1f5c6c745e330ef7787cd4aed432b9ba93f41ef9c625d8a"; }];
    buildInputs = [ hidapi jsoncpp libusb python3 swig ];
  };

  "vtk" = fetch {
    pname       = "vtk";
    version     = "8.1.2";
    srcs        = [{ filename = "mingw-w64-i686-vtk-8.1.2-1-any.pkg.tar.xz"; sha256 = "1e41441dae5e32fe87b670ba9a2e57e478b1eafcac1cae7204ca2837ed547807"; }];
    buildInputs = [ gcc-libs expat ffmpeg fontconfig freetype hdf5 intel-tbb jsoncpp libjpeg libharu libpng libogg libtheora libtiff libxml2 lz4 qt5 zlib ];
  };

  "vulkan-headers" = fetch {
    pname       = "vulkan-headers";
    version     = "1.1.92";
    srcs        = [{ filename = "mingw-w64-i686-vulkan-headers-1.1.92-1-any.pkg.tar.xz"; sha256 = "e403ac8754342c36e5ec08fd3ce25cce45e82c7b17f1700267b1827bfaba58fd"; }];
    buildInputs = [ gcc-libs ];
  };

  "vulkan-loader" = fetch {
    pname       = "vulkan-loader";
    version     = "1.1.92";
    srcs        = [{ filename = "mingw-w64-i686-vulkan-loader-1.1.92-1-any.pkg.tar.xz"; sha256 = "052cd9cf1b613842d7d23a0392c3cc1738a97fb310976e5541b00a04d56b9adf"; }];
    buildInputs = [ vulkan-headers ];
  };

  "waf" = fetch {
    pname       = "waf";
    version     = "2.0.12";
    srcs        = [{ filename = "mingw-w64-i686-waf-2.0.12-1-any.pkg.tar.xz"; sha256 = "19f78ccf82210550ef5d1341da7280a4b1233d980749fa5e511c64501dbc211c"; }];
    buildInputs = [ python3 ];
  };

  "wavpack" = fetch {
    pname       = "wavpack";
    version     = "5.1.0";
    srcs        = [{ filename = "mingw-w64-i686-wavpack-5.1.0-1-any.pkg.tar.xz"; sha256 = "25320de952b33987c604d768dc8729b211617f37f72b4e4e2994f01b4ac843e6"; }];
    buildInputs = [ gcc-libs ];
  };

  "webkitgtk2" = fetch {
    pname       = "webkitgtk2";
    version     = "2.4.11";
    srcs        = [{ filename = "mingw-w64-i686-webkitgtk2-2.4.11-6-any.pkg.tar.xz"; sha256 = "630d927abde41345396a8bcdb82340fc56d23a1af537d18f627cb84ac7ea1a2d"; }];
    buildInputs = [ angleproject-git cairo enchant fontconfig freetype glib2 gst-plugins-base gstreamer geoclue harfbuzz icu libidn libjpeg libpng libsoup libxml2 libxslt libwebp pango sqlite3 xz gtk2 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "webkitgtk3" = fetch {
    pname       = "webkitgtk3";
    version     = "2.4.11";
    srcs        = [{ filename = "mingw-w64-i686-webkitgtk3-2.4.11-6-any.pkg.tar.xz"; sha256 = "a318811e44cfa40568d879741e0711786de0610aea87fa999ee252c982da85b6"; }];
    buildInputs = [ angleproject-git cairo enchant fontconfig freetype glib2 gst-plugins-base gstreamer geoclue harfbuzz icu libidn libjpeg libpng libsoup libxml2 libxslt libwebp pango sqlite3 xz gtk3 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "wget" = fetch {
    pname       = "wget";
    version     = "1.20.1";
    srcs        = [{ filename = "mingw-w64-i686-wget-1.20.1-1-any.pkg.tar.xz"; sha256 = "b1c92413c5704ce4cf1b9979fccebd32c41ad29019f6ca2dc7707af488141498"; }];
    buildInputs = [ pcre2 libidn2 openssl c-ares gpgme ];
  };

  "win7appid" = fetch {
    pname       = "win7appid";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-i686-win7appid-1.1-3-any.pkg.tar.xz"; sha256 = "f6305255a17f74993e47fca885a950c26f11aa6b864bb772eb755c668dcaf72d"; }];
  };

  "windows-default-manifest" = fetch {
    pname       = "windows-default-manifest";
    version     = "6.4";
    srcs        = [{ filename = "mingw-w64-i686-windows-default-manifest-6.4-3-any.pkg.tar.xz"; sha256 = "56323bc39c7de0ff727915c09c4aaa25b8396efc0d7eda0006d5951bb6a6b983"; }];
    buildInputs = [  ];
  };

  "wined3d" = fetch {
    pname       = "wined3d";
    version     = "3.8";
    srcs        = [{ filename = "mingw-w64-i686-wined3d-3.8-1-any.pkg.tar.xz"; sha256 = "26be5d3589012a5e71ea97758d83d62918ad2547a4a7a7b10d0fec722df11c9e"; }];
  };

  "wineditline" = fetch {
    pname       = "wineditline";
    version     = "2.205";
    srcs        = [{ filename = "mingw-w64-i686-wineditline-2.205-1-any.pkg.tar.xz"; sha256 = "41af7321b85c1fe5c53413d8ec6d03cf466ff34750e92c64088ee45ca02f1c4e"; }];
    buildInputs = [  ];
  };

  "winico" = fetch {
    pname       = "winico";
    version     = "0.6";
    srcs        = [{ filename = "mingw-w64-i686-winico-0.6-2-any.pkg.tar.xz"; sha256 = "27e2b286fdd9604f923277428beb833a3d7c48cd45abc11a0aa1d9ac7694c49c"; }];
    buildInputs = [ tk ];
  };

  "winpthreads-git" = fetch {
    pname       = "winpthreads-git";
    version     = "7.0.0.5273.3e5acf5d";
    srcs        = [{ filename = "mingw-w64-i686-winpthreads-git-7.0.0.5273.3e5acf5d-1-any.pkg.tar.xz"; sha256 = "760d7dcd964d1543c28d6026e704621804c80f85fe969615ba36cc524ad2414b"; }];
    buildInputs = [ crt-git (assert libwinpthread-git.version=="7.0.0.5273.3e5acf5d"; libwinpthread-git) ];
  };

  "winsparkle" = fetch {
    pname       = "winsparkle";
    version     = "0.5.2";
    srcs        = [{ filename = "mingw-w64-i686-winsparkle-0.5.2-1-any.pkg.tar.xz"; sha256 = "62af31dc2b47d6f05f3afe52b586957b19faa233ad3708e8c7d4393d422e5378"; }];
    buildInputs = [ expat wxWidgets ];
  };

  "winstorecompat-git" = fetch {
    pname       = "winstorecompat-git";
    version     = "7.0.0.5230.69c8fad6";
    srcs        = [{ filename = "mingw-w64-i686-winstorecompat-git-7.0.0.5230.69c8fad6-1-any.pkg.tar.xz"; sha256 = "d9e629a2cf0008d8052fa1b4e1449bf56d75ab70f34603964f802545fe5317ae"; }];
  };

  "wintab-sdk" = fetch {
    pname       = "wintab-sdk";
    version     = "1.4";
    srcs        = [{ filename = "mingw-w64-i686-wintab-sdk-1.4-2-any.pkg.tar.xz"; sha256 = "8425c5de8fda04d236bd6b452c495eb1fecd92e3b826123c8dffa7bc3c2830e5"; }];
  };

  "wkhtmltopdf-git" = fetch {
    pname       = "wkhtmltopdf-git";
    version     = "0.13.r1049.51f9658";
    srcs        = [{ filename = "mingw-w64-i686-wkhtmltopdf-git-0.13.r1049.51f9658-1-any.pkg.tar.xz"; sha256 = "8742f92ff41dd38be606f7019ca3ef4d1ac4e7d9ead0aaa00d1ac89214f50b42"; }];
    buildInputs = [ qt5 qtwebkit ];
  };

  "woff2" = fetch {
    pname       = "woff2";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-i686-woff2-1.0.2-1-any.pkg.tar.xz"; sha256 = "729d47eb94e2747bc39596c69a15826809799574ca9e6f0ad0ca0c1a64db5a7e"; }];
    buildInputs = [ gcc-libs brotli ];
  };

  "wslay" = fetch {
    pname       = "wslay";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-i686-wslay-1.1.0-1-any.pkg.tar.xz"; sha256 = "cf268ab0e4438d54221f8c3b43f9636498c7d0c2e32be2b527211585c65815c9"; }];
    buildInputs = [ gcc-libs ];
  };

  "wxPython" = fetch {
    pname       = "wxPython";
    version     = "3.0.2.0";
    srcs        = [{ filename = "mingw-w64-i686-wxPython-3.0.2.0-8-any.pkg.tar.xz"; sha256 = "83b0404b520738c1acf9100d3fac3148efc5de8bdedaba8bd5317f56786becba"; }];
    buildInputs = [ python2 wxWidgets ];
  };

  "wxWidgets" = fetch {
    pname       = "wxWidgets";
    version     = "3.0.4";
    srcs        = [{ filename = "mingw-w64-i686-wxWidgets-3.0.4-2-any.pkg.tar.xz"; sha256 = "30b9e673546fa1441073f71fcdd7cb2a4b5b2567cd50aceae7975cf21a1e1c88"; }];
    buildInputs = [ gcc-libs expat libjpeg-turbo libpng libtiff xz zlib ];
  };

  "x264-git" = fetch {
    pname       = "x264-git";
    version     = "r2901.7d0ff22e";
    srcs        = [{ filename = "mingw-w64-i686-x264-git-r2901.7d0ff22e-1-any.pkg.tar.xz"; sha256 = "9a3b5e3696cc07dffb989288b923739df925104011eeae85cc08e889a55fd5ac"; }];
    buildInputs = [ libwinpthread-git l-smash ];
  };

  "x265" = fetch {
    pname       = "x265";
    version     = "2.9";
    srcs        = [{ filename = "mingw-w64-i686-x265-2.9-1-any.pkg.tar.xz"; sha256 = "be64b7af6e0840c2fa1300990b096771fb5ade1d41a317fd35cced83c695535d"; }];
    buildInputs = [ gcc-libs ];
  };

  "xalan-c" = fetch {
    pname       = "xalan-c";
    version     = "1.11";
    srcs        = [{ filename = "mingw-w64-i686-xalan-c-1.11-7-any.pkg.tar.xz"; sha256 = "7c5932a5445882e173fc3fd25aded507bddeb92142877b4a3fa83847b18585fb"; }];
    buildInputs = [ gcc-libs xerces-c ];
  };

  "xapian-core" = fetch {
    pname       = "xapian-core";
    version     = "1~1.4.9";
    srcs        = [{ filename = "mingw-w64-i686-xapian-core-1~1.4.9-1-any.pkg.tar.xz"; sha256 = "30e2afbe56926adf848397b965cf81862a7e243e2e239a43ba7a6941da9021c6"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "xavs" = fetch {
    pname       = "xavs";
    version     = "0.1.55";
    srcs        = [{ filename = "mingw-w64-i686-xavs-0.1.55-1-any.pkg.tar.xz"; sha256 = "f770ddfda505ee16f7cebe2c8adcbd43570cbd948daaffe0bc37407229060d35"; }];
    buildInputs = [ gcc-libs ];
  };

  "xerces-c" = fetch {
    pname       = "xerces-c";
    version     = "3.2.2";
    srcs        = [{ filename = "mingw-w64-i686-xerces-c-3.2.2-1-any.pkg.tar.xz"; sha256 = "3116718f174d75e7c6896e55149bb36cd3e41f498ef6a1dfd019811a533fa1dc"; }];
    buildInputs = [ gcc-libs icu ];
  };

  "xlnt" = fetch {
    pname       = "xlnt";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-xlnt-1.3.0-1-any.pkg.tar.xz"; sha256 = "640dfdb139efc4d89f557cf71104287c0c7bfe6e0fbc77d2265152f47890f2e8"; }];
    buildInputs = [ gcc-libs ];
  };

  "xmlsec" = fetch {
    pname       = "xmlsec";
    version     = "1.2.27";
    srcs        = [{ filename = "mingw-w64-i686-xmlsec-1.2.27-1-any.pkg.tar.xz"; sha256 = "c15a02dc5732e73792e8f59be24844a3b3e95b8ab1284d003b945aecf908e008"; }];
    buildInputs = [ libxml2 libxslt openssl gnutls ];
  };

  "xmlstarlet-git" = fetch {
    pname       = "xmlstarlet-git";
    version     = "r678.9a470e3";
    srcs        = [{ filename = "mingw-w64-i686-xmlstarlet-git-r678.9a470e3-2-any.pkg.tar.xz"; sha256 = "988e39273bd2e2ffe46e9e7feb4abe2aa711be77744220e86b4547c4fd42f0a9"; }];
    buildInputs = [ libxml2 libxslt ];
  };

  "xpdf" = fetch {
    pname       = "xpdf";
    version     = "4.00";
    srcs        = [{ filename = "mingw-w64-i686-xpdf-4.00-1-any.pkg.tar.xz"; sha256 = "e7d2526ff8d55e1904eca29f96d8d5a98943da56a73efa46a170dd8cef81f141"; }];
    buildInputs = [ freetype libjpeg-turbo libpaper libpng libtiff qt5 zlib ];
  };

  "xpm-nox" = fetch {
    pname       = "xpm-nox";
    version     = "4.2.0";
    srcs        = [{ filename = "mingw-w64-i686-xpm-nox-4.2.0-5-any.pkg.tar.xz"; sha256 = "28c5a3b200cbc3db6e3e2ebc3a9c953d43c80ede2a6d8a21ad1db5b7da3a2a01"; }];
    buildInputs = [ gcc-libs ];
  };

  "xvidcore" = fetch {
    pname       = "xvidcore";
    version     = "1.3.5";
    srcs        = [{ filename = "mingw-w64-i686-xvidcore-1.3.5-1-any.pkg.tar.xz"; sha256 = "fe6f47c5eebad75a1523951fda87453b45f35c9eb5105418e565b99cd9264be0"; }];
    buildInputs = [  ];
  };

  "xxhash" = fetch {
    pname       = "xxhash";
    version     = "0.6.5";
    srcs        = [{ filename = "mingw-w64-i686-xxhash-0.6.5-1-any.pkg.tar.xz"; sha256 = "bc6656a794c2747fb193ddf21c748ce0c3045abc36c80f99c1ad6535e4c65956"; }];
  };

  "xz" = fetch {
    pname       = "xz";
    version     = "5.2.4";
    srcs        = [{ filename = "mingw-w64-i686-xz-5.2.4-1-any.pkg.tar.xz"; sha256 = "da238fc44727076823b56898337bef2a5187dc97d58de1d2750e75dc2723cedb"; }];
    buildInputs = [ gcc-libs gettext ];
  };

  "yajl" = fetch {
    pname       = "yajl";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-i686-yajl-2.1.0-1-any.pkg.tar.xz"; sha256 = "4a368dc6bcc3cb8632ae51d2d427f644d03cd9bd1a13f12ebe283ef833191d64"; }];
    buildInputs = [  ];
  };

  "yaml-cpp" = fetch {
    pname       = "yaml-cpp";
    version     = "0.6.2";
    srcs        = [{ filename = "mingw-w64-i686-yaml-cpp-0.6.2-1-any.pkg.tar.xz"; sha256 = "9ac5ef18705d75a87f0fd6a73c265d536b34df4f205feb3a4dd3ee619c462c84"; }];
    buildInputs = [  ];
  };

  "yaml-cpp0.3" = fetch {
    pname       = "yaml-cpp0.3";
    version     = "0.3.0";
    srcs        = [{ filename = "mingw-w64-i686-yaml-cpp0.3-0.3.0-2-any.pkg.tar.xz"; sha256 = "778a22a9bdaf40133a50551ff1c9a20f383a954423a5b22e47cdd7d38ca874db"; }];
  };

  "yarn" = fetch {
    pname       = "yarn";
    version     = "1.13.0";
    srcs        = [{ filename = "mingw-w64-i686-yarn-1.13.0-1-any.pkg.tar.xz"; sha256 = "47949ecc013a4a3c55093d2725160cbdee4912c6d9c5707db9b2cf0ec22fc822"; }];
    buildInputs = [ nodejs ];
  };

  "yasm" = fetch {
    pname       = "yasm";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-i686-yasm-1.3.0-3-any.pkg.tar.xz"; sha256 = "e82a2442129df51e404ae5abc4cf6ec5ba075f40cf5e32bfb0cc1e4823b0e963"; }];
    buildInputs = [ gettext ];
  };

  "z3" = fetch {
    pname       = "z3";
    version     = "4.8.4";
    srcs        = [{ filename = "mingw-w64-i686-z3-4.8.4-1-any.pkg.tar.xz"; sha256 = "24c2b46e9c0280a91de7eaac85da926b6b5613fd92d241a177cf1f8c050815f5"; }];
    buildInputs = [  ];
  };

  "zbar" = fetch {
    pname       = "zbar";
    version     = "0.20";
    srcs        = [{ filename = "mingw-w64-i686-zbar-0.20-1-any.pkg.tar.xz"; sha256 = "73d874034ec47898553059ac74d6640820110945bec04268a18ec3990039f9a5"; }];
    buildInputs = [ imagemagick ];
  };

  "zeromq" = fetch {
    pname       = "zeromq";
    version     = "4.3.0";
    srcs        = [{ filename = "mingw-w64-i686-zeromq-4.3.0-1-any.pkg.tar.xz"; sha256 = "34b39ef85250d2f75925f6d631e38606c718c8aa924fd966ab2242b3ebee3564"; }];
    buildInputs = [ libsodium ];
  };

  "zimg" = fetch {
    pname       = "zimg";
    version     = "2.8";
    srcs        = [{ filename = "mingw-w64-i686-zimg-2.8-2-any.pkg.tar.xz"; sha256 = "2629c741ca6d53cec8f3423c79ee1d22427ce9fe5603044d4d8be2835f9a4405"; }];
    buildInputs = [ gcc-libs winpthreads-git ];
  };

  "zlib" = fetch {
    pname       = "zlib";
    version     = "1.2.11";
    srcs        = [{ filename = "mingw-w64-i686-zlib-1.2.11-5-any.pkg.tar.xz"; sha256 = "4c718bcb6a1f6b7a7c30792ae5a141f3b9996c20a6eabb2926af7319789c864e"; }];
    buildInputs = [ bzip2 ];
  };

  "zopfli" = fetch {
    pname       = "zopfli";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-i686-zopfli-1.0.2-2-any.pkg.tar.xz"; sha256 = "1571e1309e1cebed7c76b323e6da99e616381c745c2b67ff9d27e8076a706569"; }];
    buildInputs = [ gcc-libs ];
  };

  "zstd" = fetch {
    pname       = "zstd";
    version     = "1.3.8";
    srcs        = [{ filename = "mingw-w64-i686-zstd-1.3.8-1-any.pkg.tar.xz"; sha256 = "9225c044362a722d27174830c0309c9ca5a20341d8ef062adbe6793fe2771adb"; }];
    buildInputs = [  ];
  };

  "zziplib" = fetch {
    pname       = "zziplib";
    version     = "0.13.69";
    srcs        = [{ filename = "mingw-w64-i686-zziplib-0.13.69-1-any.pkg.tar.xz"; sha256 = "03c2d76db1e25af6c079f7d32452cd061f286d93deed3ad4d79ccae1d6ebc7a7"; }];
    buildInputs = [ zlib ];
  };

}; in self
