 # GENERATED FILE
{stdenvNoCC, fetchurl}:

let
  fetch = { name, version, filename, sha256, buildInputs ? [], broken ? false }:
    if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
      stdenvNoCC.mkDerivation {
        inherit name version buildInputs;
        src = fetchurl {
          url = "http://repo.msys2.org/mingw/x86_64/${filename}";
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
        url = "http://repo.msys2.org/mingw/x86_64/${filename}";
        inherit sha256;
      };
      sourceRoot = ".";
      buildPhase = if stdenvNoCC.isShellPerl /* on native windows */ then
        ''
          dircopy '.',       "$ENV{out}";
          unlink "$ENV{out}/.BUILDINFO";
          unlink "$ENV{out}/.INSTALL";
          unlink "$ENV{out}/.MTREE";
          unlink "$ENV{out}/.PKGINFO";
          use File::Find qw(find);
        '' + stdenvNoCC.lib.concatMapStringsSep "\n" (dep: ''
              sub process {
                my $src = $_;
                die "bad src: '$src'" unless $src =~ /\/[0-9a-df-np-sv-z]{32}-[^\/]+(.*)/;
                my $rel = $1;
                my $tgt = "$ENV{out}$rel";
                unless (-e $tgt) {
                  print("$src -> $tgt\n");
                  if (-d $src) {
                    make_path($tgt) or die "$!";
                  } else {
                    symlink(readlink_f($src) => $tgt) or die "$!";
                  }
                }
              };
              find({ wanted => \&process, no_chdir => 1}, '${dep}');
            '') buildInputs
      else /* on mingw or linux */
        throw "todo";
      meta.broken = broken;
    };
  self = _self;
  _self = with self;
{
  callPackage = pkgs.newScope self;
  libjpeg = libjpeg-turbo;

  "3proxy" = fetch {
    name        = "3proxy";
    version     = "0.8.12";
    filename    = "mingw-w64-x86_64-3proxy-0.8.12-1-any.pkg.tar.xz";
    sha256      = "c7442af9080bf46a4705e788aba1993d67318706a0eccb30187e329c86ecffb8";
  };

  "4th" = fetch {
    name        = "4th";
    version     = "3.62.5";
    filename    = "mingw-w64-x86_64-4th-3.62.5-1-any.pkg.tar.xz";
    sha256      = "af283a192321ec5c7cc7feabe85fb9c80dbd20b2b384bb78c25563bc39ed1499";
  };

  "MinHook" = fetch {
    name        = "MinHook";
    version     = "1.3.3";
    filename    = "mingw-w64-x86_64-MinHook-1.3.3-1-any.pkg.tar.xz";
    sha256      = "a282497981bbefa4c14758bd6e88ba4e3886372b97fda0cb5224cfa5d378c747";
  };

  "OpenSceneGraph" = fetch {
    name        = "OpenSceneGraph";
    version     = "3.6.3";
    filename    = "mingw-w64-x86_64-OpenSceneGraph-3.6.3-3-any.pkg.tar.xz";
    sha256      = "332611cdaa685851a7ce97a035ded34505f14ad11595f7e276ada73b02d527d3";
    buildInputs = [ angleproject-git boost collada-dom-svn curl ffmpeg fltk freetype gcc-libs gdal giflib gstreamer gtk2 gtkglext jasper libjpeg libpng libtiff libvncserver libxml2 lua SDL SDL2 poppler python3 wxWidgets zlib ];
    broken      = true;
  };

  "OpenSceneGraph-debug" = fetch {
    name        = "OpenSceneGraph-debug";
    version     = "3.6.3";
    filename    = "mingw-w64-x86_64-OpenSceneGraph-debug-3.6.3-3-any.pkg.tar.xz";
    sha256      = "bc7a5bbc9cc14db8fe1d4c9cb29b5619b7bbb7f5337eb464e1a91d111b323de0";
    buildInputs = [ (assert OpenSceneGraph.version=="3.6.3"; OpenSceneGraph) ];
    broken      = true;
  };

  "SDL" = fetch {
    name        = "SDL";
    version     = "1.2.15";
    filename    = "mingw-w64-x86_64-SDL-1.2.15-8-any.pkg.tar.xz";
    sha256      = "5c085fdc62dfeb2b8afa53764008b3dcfb7b1ad96a974be9447c05a9ffe57e68";
    buildInputs = [ gcc-libs libiconv ];
  };

  "SDL2" = fetch {
    name        = "SDL2";
    version     = "2.0.9";
    filename    = "mingw-w64-x86_64-SDL2-2.0.9-1-any.pkg.tar.xz";
    sha256      = "9b1a4d994efcba179fac272683efffb75921b823579fea7850ee5e273d3d1592";
    buildInputs = [ gcc-libs libiconv vulkan ];
    broken      = true;
  };

  "SDL2_gfx" = fetch {
    name        = "SDL2_gfx";
    version     = "1.0.4";
    filename    = "mingw-w64-x86_64-SDL2_gfx-1.0.4-1-any.pkg.tar.xz";
    sha256      = "d006ee1dfaa82cefbc48795f2de78bf2f2b3f2bcdb2816f4e9656523f71e332e";
    buildInputs = [ SDL2 ];
    broken      = true;
  };

  "SDL2_image" = fetch {
    name        = "SDL2_image";
    version     = "2.0.4";
    filename    = "mingw-w64-x86_64-SDL2_image-2.0.4-1-any.pkg.tar.xz";
    sha256      = "d8ec1995a6fd4e4ef0a6c69e585acd11c5629dfa0a21026af951d4a8b8b46e62";
    buildInputs = [ SDL2 libpng libtiff libjpeg-turbo libwebp ];
    broken      = true;
  };

  "SDL2_mixer" = fetch {
    name        = "SDL2_mixer";
    version     = "2.0.4";
    filename    = "mingw-w64-x86_64-SDL2_mixer-2.0.4-1-any.pkg.tar.xz";
    sha256      = "cd2363302a95b27196e648cc12f614e668d2563c6c8023c7e97a969a24872958";
    buildInputs = [ gcc-libs SDL2 flac fluidsynth libvorbis libmodplug mpg123 opusfile ];
    broken      = true;
  };

  "SDL2_net" = fetch {
    name        = "SDL2_net";
    version     = "2.0.1";
    filename    = "mingw-w64-x86_64-SDL2_net-2.0.1-1-any.pkg.tar.xz";
    sha256      = "d2e7a04a8ce51071807c9a0b33d8241dd50ae8f6b75c7b2afcf1cca05b3c62be";
    buildInputs = [ gcc-libs SDL2 ];
    broken      = true;
  };

  "SDL2_ttf" = fetch {
    name        = "SDL2_ttf";
    version     = "2.0.14";
    filename    = "mingw-w64-x86_64-SDL2_ttf-2.0.14-1-any.pkg.tar.xz";
    sha256      = "a9a426ac7432316719f518efdfdb451c7adb098d5d76ed33dba42c93cf744191";
    buildInputs = [ SDL2 freetype ];
    broken      = true;
  };

  "SDL_gfx" = fetch {
    name        = "SDL_gfx";
    version     = "2.0.26";
    filename    = "mingw-w64-x86_64-SDL_gfx-2.0.26-1-any.pkg.tar.xz";
    sha256      = "74e6ebcdbab8e2ff0fa20315dba397c55c35ba0dcdb04ebe557a7c7a89256a78";
    buildInputs = [ SDL ];
  };

  "SDL_image" = fetch {
    name        = "SDL_image";
    version     = "1.2.12";
    filename    = "mingw-w64-x86_64-SDL_image-1.2.12-6-any.pkg.tar.xz";
    sha256      = "3c142e60d30d05b1c41b0d317418ecc6786529d0750fd5b0c6a4176f4765271b";
    buildInputs = [ SDL libjpeg-turbo libpng libtiff libwebp zlib ];
  };

  "SDL_mixer" = fetch {
    name        = "SDL_mixer";
    version     = "1.2.12";
    filename    = "mingw-w64-x86_64-SDL_mixer-1.2.12-6-any.pkg.tar.xz";
    sha256      = "478d1fc3b8a103d026cce4f4a81537a6d39ac4a59a94ed501fd9332f35d8ec7b";
    buildInputs = [ SDL libvorbis libmikmod libmad flac ];
  };

  "SDL_net" = fetch {
    name        = "SDL_net";
    version     = "1.2.8";
    filename    = "mingw-w64-x86_64-SDL_net-1.2.8-2-any.pkg.tar.xz";
    sha256      = "89dda2cc596e14442b9338bb9982fcfc65d9bcf25b1a9f0290a506d62185c78a";
    buildInputs = [ SDL ];
  };

  "SDL_ttf" = fetch {
    name        = "SDL_ttf";
    version     = "2.0.11";
    filename    = "mingw-w64-x86_64-SDL_ttf-2.0.11-5-any.pkg.tar.xz";
    sha256      = "33548e3113c015aee1473c471fa5654ff1238ea3a5d690dfa3a0af64fbbfd6d4";
    buildInputs = [ SDL freetype ];
  };

  "a52dec" = fetch {
    name        = "a52dec";
    version     = "0.7.4";
    filename    = "mingw-w64-x86_64-a52dec-0.7.4-4-any.pkg.tar.xz";
    sha256      = "ed79a259507f655a08dd7385b2285116e6826d25d41e168e4dddd66039c4f486";
  };

  "adns" = fetch {
    name        = "adns";
    version     = "1.4.g10.7";
    filename    = "mingw-w64-x86_64-adns-1.4.g10.7-1-any.pkg.tar.xz";
    sha256      = "c1c673566c5f770804b53b1913a0fe45d0f5b823527542c4e81456fde37259c2";
    buildInputs = [ gcc-libs ];
  };

  "adwaita-icon-theme" = fetch {
    name        = "adwaita-icon-theme";
    version     = "3.30.1";
    filename    = "mingw-w64-x86_64-adwaita-icon-theme-3.30.1-1-any.pkg.tar.xz";
    sha256      = "d74b22336ab349ff354aa30f46faff7e9cd7fd7a6f2ce42a1b0300becad6430b";
    buildInputs = [ hicolor-icon-theme librsvg ];
  };

  "ag" = fetch {
    name        = "ag";
    version     = "2.1.0.r1975.d83e205";
    filename    = "mingw-w64-x86_64-ag-2.1.0.r1975.d83e205-1-any.pkg.tar.xz";
    sha256      = "1778fbd5659b6a33233ddf556fdbd0af88913c50920f3d1d6f4920e2314c51a8";
    buildInputs = [ pcre xz zlib ];
  };

  "alembic" = fetch {
    name        = "alembic";
    version     = "1.7.10";
    filename    = "mingw-w64-x86_64-alembic-1.7.10-1-any.pkg.tar.xz";
    sha256      = "4f8c7f3107ec6c0b5c89a927cd5ffd0f3feaf890e5cce441a29961e81e1beaba";
    buildInputs = [ openexr boost hdf5 zlib ];
  };

  "allegro" = fetch {
    name        = "allegro";
    version     = "5.2.4";
    filename    = "mingw-w64-x86_64-allegro-5.2.4-2-any.pkg.tar.xz";
    sha256      = "8c3a3ab9b46a8c013265cd97a72913f2086fba65f2b3821430c0085a90966c79";
    buildInputs = [ gcc-libs ];
  };

  "alure" = fetch {
    name        = "alure";
    version     = "1.2";
    filename    = "mingw-w64-x86_64-alure-1.2-1-any.pkg.tar.xz";
    sha256      = "42367756a0ab46fdc8d5b7d8acf3105e06817f4b79c38574e7b6f2366c3d5b61";
    buildInputs = [ openal ];
  };

  "amtk" = fetch {
    name        = "amtk";
    version     = "5.0.0";
    filename    = "mingw-w64-x86_64-amtk-5.0.0-1-any.pkg.tar.xz";
    sha256      = "46f123d9b5c96d802c40c0b74239a3cc3063e5b3ce59e921ab4735dfadd36820";
    buildInputs = [ gtk3 ];
  };

  "angleproject-git" = fetch {
    name        = "angleproject-git";
    version     = "2.1.r8842";
    filename    = "mingw-w64-x86_64-angleproject-git-2.1.r8842-1-any.pkg.tar.xz";
    sha256      = "f94f2fccd9c0874b4cbf385d2b8ff28c68d00dafa14086a4aa115079a85f4f2f";
    buildInputs = [  ];
  };

  "ansicon-git" = fetch {
    name        = "ansicon-git";
    version     = "1.70.r65.3acc7a9";
    filename    = "mingw-w64-x86_64-ansicon-git-1.70.r65.3acc7a9-2-any.pkg.tar.xz";
    sha256      = "3615e8f60acb74525979129c53fcdbeab819ccf6be2d6128f655a4dbacac24c7";
  };

  "antiword" = fetch {
    name        = "antiword";
    version     = "0.37";
    filename    = "mingw-w64-x86_64-antiword-0.37-2-any.pkg.tar.xz";
    sha256      = "cae3a53a31a9abcc17f125d6b5ce3530b193070428e05e7b7546664a270e5c56";
  };

  "antlr3" = fetch {
    name        = "antlr3";
    version     = "3.5.2";
    filename    = "mingw-w64-x86_64-antlr3-3.5.2-1-any.pkg.tar.xz";
    sha256      = "f9d7aa7b08fe4777d0685df59784644cc6656367000968e67af849edbc642289";
  };

  "antlr4-runtime-cpp" = fetch {
    name        = "antlr4-runtime-cpp";
    version     = "4.7.1";
    filename    = "mingw-w64-x86_64-antlr4-runtime-cpp-4.7.1-1-any.pkg.tar.xz";
    sha256      = "ee590710aabc5724c1e1abca6ab32cd6d9081ae6ac739a3787c3cc6cdbf7a0f6";
  };

  "aom" = fetch {
    name        = "aom";
    version     = "1.0.0";
    filename    = "mingw-w64-x86_64-aom-1.0.0-1-any.pkg.tar.xz";
    sha256      = "461eba816697a3c6e6e3dc75a884cbfd44ae71f32b9491aa9bd69357c028abf5";
    buildInputs = [ gcc-libs ];
  };

  "apr" = fetch {
    name        = "apr";
    version     = "1.6.5";
    filename    = "mingw-w64-x86_64-apr-1.6.5-1-any.pkg.tar.xz";
    sha256      = "1d50b307c6041dd206e3ddf4c02b1aff0e484e4f7c3889567618bf91fc04d1d0";
  };

  "apr-util" = fetch {
    name        = "apr-util";
    version     = "1.6.1";
    filename    = "mingw-w64-x86_64-apr-util-1.6.1-1-any.pkg.tar.xz";
    sha256      = "6c904db567baa273fc8f6bb1b34d20f0bf1dadbb388d1134483711b04e24a86b";
    buildInputs = [ apr expat sqlite3 ];
  };

  "argon2" = fetch {
    name        = "argon2";
    version     = "20171227";
    filename    = "mingw-w64-x86_64-argon2-20171227-2-any.pkg.tar.xz";
    sha256      = "9b04d055ddd85f91923c4040b805f06575b8618c1a39b7e478874b3b53759c13";
  };

  "aria2" = fetch {
    name        = "aria2";
    version     = "1.34.0";
    filename    = "mingw-w64-x86_64-aria2-1.34.0-2-any.pkg.tar.xz";
    sha256      = "6baaab02ccd53b3b57114a652d8d6004bfe058b7ab05d2b7e910756e60484507";
    buildInputs = [ gcc-libs gettext c-ares cppunit libiconv libssh2 libuv libxml2 openssl sqlite3 zlib ];
  };

  "aribb24" = fetch {
    name        = "aribb24";
    version     = "1.0.3";
    filename    = "mingw-w64-x86_64-aribb24-1.0.3-3-any.pkg.tar.xz";
    sha256      = "e50af2f5de17f0638d969924aaaa16766f8b8386b077247622d73e4075101b3f";
    buildInputs = [ libpng ];
  };

  "armadillo" = fetch {
    name        = "armadillo";
    version     = "9.200.6";
    filename    = "mingw-w64-x86_64-armadillo-9.200.6-1-any.pkg.tar.xz";
    sha256      = "bb7c683e3754af4563f8bfe21b50baa14859735dd18c92abdd2ba1d58bf44d40";
    buildInputs = [ gcc-libs arpack openblas ];
  };

  "arpack" = fetch {
    name        = "arpack";
    version     = "3.6.3";
    filename    = "mingw-w64-x86_64-arpack-3.6.3-1-any.pkg.tar.xz";
    sha256      = "5ae54312a328c2a0af4fee70a597d29917de456010f0377225b0f25ca92eac2e";
    buildInputs = [ gcc-libgfortran openblas ];
  };

  "arrow" = fetch {
    name        = "arrow";
    version     = "0.11.1";
    filename    = "mingw-w64-x86_64-arrow-0.11.1-1-any.pkg.tar.xz";
    sha256      = "2ce00add3abaff2ae3f817f2e196d8da5cdd88cced40565b94689523c6e89784";
    buildInputs = [ boost brotli flatbuffers gobject-introspection lz4 protobuf python3-numpy snappy zlib zstd ];
  };

  "asciidoctor" = fetch {
    name        = "asciidoctor";
    version     = "1.5.8";
    filename    = "mingw-w64-x86_64-asciidoctor-1.5.8-1-any.pkg.tar.xz";
    sha256      = "a7ed6c1d67fb8fb9107b1d3c797fee391bd44fb55de61f5395a58b536ef95496";
    buildInputs = [ ruby ];
  };

  "aspell" = fetch {
    name        = "aspell";
    version     = "0.60.7.rc1";
    filename    = "mingw-w64-x86_64-aspell-0.60.7.rc1-1-any.pkg.tar.xz";
    sha256      = "89f6c3493a7cde1b69ca9db52e080a7c4ee52242b69d6a114b7132d4e71607cc";
    buildInputs = [ gcc-libs libiconv gettext ];
  };

  "aspell-de" = fetch {
    name        = "aspell-de";
    version     = "20161207";
    filename    = "mingw-w64-x86_64-aspell-de-20161207-1-any.pkg.tar.xz";
    sha256      = "a5346edb3e74eabe7a4527a4d43ec1e2be7eeb7f013adc41109b2eb1fb211e22";
    buildInputs = [ aspell ];
  };

  "aspell-en" = fetch {
    name        = "aspell-en";
    version     = "2018.04.16";
    filename    = "mingw-w64-x86_64-aspell-en-2018.04.16-1-any.pkg.tar.xz";
    sha256      = "97f115a5315257172d4b48f37df7ec1edf7938f0f3238a9e2c5f131a6960046a";
    buildInputs = [ aspell ];
  };

  "aspell-es" = fetch {
    name        = "aspell-es";
    version     = "1.11.2";
    filename    = "mingw-w64-x86_64-aspell-es-1.11.2-1-any.pkg.tar.xz";
    sha256      = "9b50cd391fc86f97167314b1b1c4c854f82112f6c355494535c04f4be20bfb26";
    buildInputs = [ aspell ];
  };

  "aspell-fr" = fetch {
    name        = "aspell-fr";
    version     = "0.50.3";
    filename    = "mingw-w64-x86_64-aspell-fr-0.50.3-1-any.pkg.tar.xz";
    sha256      = "6f53eee2ea24f06ca473c106083cc2b8d19280bb64566cab7f17b6970fc03498";
    buildInputs = [ aspell ];
  };

  "aspell-ru" = fetch {
    name        = "aspell-ru";
    version     = "0.99f7.1";
    filename    = "mingw-w64-x86_64-aspell-ru-0.99f7.1-1-any.pkg.tar.xz";
    sha256      = "9865e6efc725b8556a07081c2c5b36be098db51d58f13cae2829050ca955e2bf";
    buildInputs = [ aspell ];
  };

  "assimp" = fetch {
    name        = "assimp";
    version     = "4.1.0";
    filename    = "mingw-w64-x86_64-assimp-4.1.0-2-any.pkg.tar.xz";
    sha256      = "5e12a11e947194b82932f59078fb40285a750ec6dee2c6d4fb47226c8383f946";
    buildInputs = [ minizip zziplib zlib ];
    broken      = true;
  };

  "astyle" = fetch {
    name        = "astyle";
    version     = "3.1";
    filename    = "mingw-w64-x86_64-astyle-3.1-1-any.pkg.tar.xz";
    sha256      = "9bb2b976627d48694774d90165b79b7b4fa48f7a68676da57dbe2dfaa2478f88";
    buildInputs = [ gcc-libs ];
  };

  "atk" = fetch {
    name        = "atk";
    version     = "2.30.0";
    filename    = "mingw-w64-x86_64-atk-2.30.0-1-any.pkg.tar.xz";
    sha256      = "67ecf29d4d3b90c616222f0b9b3495935ab933bf0be3485d8b7e4f942c067433";
    buildInputs = [ gcc-libs (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.46.0"; glib2) ];
  };

  "atkmm" = fetch {
    name        = "atkmm";
    version     = "2.28.0";
    filename    = "mingw-w64-x86_64-atkmm-2.28.0-1-any.pkg.tar.xz";
    sha256      = "067f074d2652cb883994ddf93357e460d56ed620382bcd7f6757456b67b25b95";
    buildInputs = [ atk gcc-libs glibmm self."libsigc++" ];
  };

  "attica-qt5" = fetch {
    name        = "attica-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-attica-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "168958edae2e6c441eac339380a87185a08f5d5cfd5f41dccfd2c893402772f0";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "avrdude" = fetch {
    name        = "avrdude";
    version     = "6.3";
    filename    = "mingw-w64-x86_64-avrdude-6.3-2-any.pkg.tar.xz";
    sha256      = "6a811225b2c8883df427639673511f7046b94221a3179bffa2edfa120741c797";
    buildInputs = [ libftdi libusb libusb-compat-git libelf ];
  };

  "aztecgen" = fetch {
    name        = "aztecgen";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-aztecgen-1.0.1-1-any.pkg.tar.xz";
    sha256      = "7eaf041f20904a00d4991e0da1ad02c0b2a68cee819f23418f4da5caa0c8d3c4";
  };

  "babl" = fetch {
    name        = "babl";
    version     = "0.1.60";
    filename    = "mingw-w64-x86_64-babl-0.1.60-1-any.pkg.tar.xz";
    sha256      = "7ee8a7de2e3a3e49d6d85c6e141227331e2870c481f2be62b5f3542324448d33";
    buildInputs = [ gcc-libs ];
  };

  "badvpn" = fetch {
    name        = "badvpn";
    version     = "1.999.130";
    filename    = "mingw-w64-x86_64-badvpn-1.999.130-2-any.pkg.tar.xz";
    sha256      = "2d4e55dc330ba277ec37812372ce2907d78d12bec3e0b0adced493808c47cd05";
    buildInputs = [ glib2 nspr nss openssl ];
  };

  "bcunit" = fetch {
    name        = "bcunit";
    version     = "3.0.2";
    filename    = "mingw-w64-x86_64-bcunit-3.0.2-1-any.pkg.tar.xz";
    sha256      = "ebff34bfc19560feb8cc79064b1636782d8ab10b9b1a471239374bb56cd4dd99";
  };

  "benchmark" = fetch {
    name        = "benchmark";
    version     = "1.4.1";
    filename    = "mingw-w64-x86_64-benchmark-1.4.1-1-any.pkg.tar.xz";
    sha256      = "d29669fd51084c5fa29e23606d54184140ea21057837d8b4746b11ee63e0a0a5";
    buildInputs = [ gcc-libs ];
  };

  "binaryen" = fetch {
    name        = "binaryen";
    version     = "55";
    filename    = "mingw-w64-x86_64-binaryen-55-1-any.pkg.tar.xz";
    sha256      = "62ffab11527000f9dc55ea7cb2312e66944dc9e9fa59b516a750ed37ce5fca05";
  };

  "binutils" = fetch {
    name        = "binutils";
    version     = "2.30";
    filename    = "mingw-w64-x86_64-binutils-2.30-5-any.pkg.tar.xz";
    sha256      = "164134e3d3637416908e4816c0427f328c9bb2f61227347d9dbda839678eb8b5";
    buildInputs = [ libiconv zlib ];
  };

  "blender" = fetch {
    name        = "blender";
    version     = "2.79.b";
    filename    = "mingw-w64-x86_64-blender-2.79.b-6-any.pkg.tar.xz";
    sha256      = "0ea49e778221b94f42579a3865a3fcfaac54d6379373928de3c5c1f73076afd2";
    buildInputs = [ boost llvm eigen3 glew ffmpeg fftw freetype libpng libsndfile libtiff lzo2 openexr openal opencollada-git opencolorio-git openimageio openshadinglanguage pugixml python3 python3-numpy SDL2 wintab-sdk ];
    broken      = true;
  };

  "blosc" = fetch {
    name        = "blosc";
    version     = "1.15.0";
    filename    = "mingw-w64-x86_64-blosc-1.15.0-1-any.pkg.tar.xz";
    sha256      = "244c2d6482780882bfe0bca8ac804b205a962e23c8e8bcb07a40b61eb1b54433";
    buildInputs = [ snappy zstd zlib lz4 ];
  };

  "boost" = fetch {
    name        = "boost";
    version     = "1.69.0";
    filename    = "mingw-w64-x86_64-boost-1.69.0-2-any.pkg.tar.xz";
    sha256      = "fb1b61824d6d57fdda7da800b77af7db625c4dd95574baaec061c61355d5e56f";
    buildInputs = [ gcc-libs bzip2 icu zlib ];
  };

  "bower" = fetch {
    name        = "bower";
    version     = "1.8.4";
    filename    = "mingw-w64-x86_64-bower-1.8.4-1-any.pkg.tar.xz";
    sha256      = "e96e75467f19a0f150d685ab0bd69e5a0e62b88625bbd4d239e5573812c49cbf";
    buildInputs = [ nodejs ];
    broken      = true;
  };

  "box2d" = fetch {
    name        = "box2d";
    version     = "2.3.1";
    filename    = "mingw-w64-x86_64-box2d-2.3.1-2-any.pkg.tar.xz";
    sha256      = "ca84725b891d1cdb86f997ad37c56cab2b9bec93e4e88a516374814f4849bd16";
  };

  "breakpad-git" = fetch {
    name        = "breakpad-git";
    version     = "r1680.70914b2d";
    filename    = "mingw-w64-x86_64-breakpad-git-r1680.70914b2d-1-any.pkg.tar.xz";
    sha256      = "a78ee7b5f75702385ff05f22a5c08be6feffc7c00e32c4060c9e1c91216929fd";
    buildInputs = [ gcc-libs ];
  };

  "breeze-icons-qt5" = fetch {
    name        = "breeze-icons-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-breeze-icons-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "9f8118174b9adc73e43a059dd708c547844a029cc8b03c137d18fec40f7d4c0a";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "brotli" = fetch {
    name        = "brotli";
    version     = "1.0.7";
    filename    = "mingw-w64-x86_64-brotli-1.0.7-1-any.pkg.tar.xz";
    sha256      = "9eb3d7f9977658b7943b557173aebaeaae5df1ca7ab0495f7199e7f832cfb1af";
    buildInputs = [  ];
  };

  "brotli-testdata" = fetch {
    name        = "brotli-testdata";
    version     = "1.0.7";
    filename    = "mingw-w64-x86_64-brotli-testdata-1.0.7-1-any.pkg.tar.xz";
    sha256      = "de86a54893c2737acd1074719784a4bd600f4a6f45147099fbf843ab2246ecc0";
    buildInputs = [ brotli ];
  };

  "bsdfprocessor" = fetch {
    name        = "bsdfprocessor";
    version     = "1.1.6";
    filename    = "mingw-w64-x86_64-bsdfprocessor-1.1.6-1-any.pkg.tar.xz";
    sha256      = "1c940bf75d25e24fa3e2eddd922263feb3c11baa989db636a62a15e2e568ab73";
    buildInputs = [ gcc-libs qt5 OpenSceneGraph ];
    broken      = true;
  };

  "bullet" = fetch {
    name        = "bullet";
    version     = "2.87";
    filename    = "mingw-w64-x86_64-bullet-2.87-1-any.pkg.tar.xz";
    sha256      = "eab78b0bbb06c47369924567302a90c6b341dbdb3eccdafebb069a8a7074ee88";
    buildInputs = [ gcc-libs freeglut openvr ];
  };

  "bullet-debug" = fetch {
    name        = "bullet-debug";
    version     = "2.87";
    filename    = "mingw-w64-x86_64-bullet-debug-2.87-1-any.pkg.tar.xz";
    sha256      = "07ebfd8238db7652cd2e0db80c5f30c19cdb02f03a9eff89a2d34c0c9fd45f4c";
    buildInputs = [ (assert bullet.version=="2.87"; bullet) ];
  };

  "bwidget" = fetch {
    name        = "bwidget";
    version     = "1.9.12";
    filename    = "mingw-w64-x86_64-bwidget-1.9.12-1-any.pkg.tar.xz";
    sha256      = "5eea7d41bc0d0137327e4bf8c692a227432bb121748f4aba4e6d1357826345f5";
    buildInputs = [ tk ];
  };

  "bzip2" = fetch {
    name        = "bzip2";
    version     = "1.0.6";
    filename    = "mingw-w64-x86_64-bzip2-1.0.6-6-any.pkg.tar.xz";
    sha256      = "5f9f7275ecdad5eeee4e30b01e169e8aadf0eb2ba1a60838c2d84c41e004db40";
    buildInputs = [ gcc-libs ];
  };

  "c-ares" = fetch {
    name        = "c-ares";
    version     = "1.15.0";
    filename    = "mingw-w64-x86_64-c-ares-1.15.0-1-any.pkg.tar.xz";
    sha256      = "9dc12147e54135775b511f6a41561b40c7c563f46a92150f86aa86b4e67b379c";
    buildInputs = [  ];
  };

  "c99-to-c89-git" = fetch {
    name        = "c99-to-c89-git";
    version     = "r169.b3d496d";
    filename    = "mingw-w64-x86_64-c99-to-c89-git-r169.b3d496d-1-any.pkg.tar.xz";
    sha256      = "e8ea5924072e9e7c45cbe1bebea342bd6964e5024cceae9c4cfc709133f0fa8b";
    buildInputs = [ clang ];
  };

  "ca-certificates" = fetch {
    name        = "ca-certificates";
    version     = "20180409";
    filename    = "mingw-w64-x86_64-ca-certificates-20180409-1-any.pkg.tar.xz";
    sha256      = "f2a35875ca5d36aa6be084a3f2273d91ac269e018689b8029b52e40cf5e341a6";
    buildInputs = [ p11-kit ];
  };

  "cairo" = fetch {
    name        = "cairo";
    version     = "1.16.0";
    filename    = "mingw-w64-x86_64-cairo-1.16.0-1-any.pkg.tar.xz";
    sha256      = "7c5cfef268b3f1277a75dd35e3c43da0f5b76787b05e6d0854ef2592697515ee";
    buildInputs = [ gcc-libs freetype fontconfig lzo2 pixman zlib ];
  };

  "cairomm" = fetch {
    name        = "cairomm";
    version     = "1.12.2";
    filename    = "mingw-w64-x86_64-cairomm-1.12.2-2-any.pkg.tar.xz";
    sha256      = "3a8cafe51307b2b0b3d4b615db3282a8bc00ad71f3e66394dadf241da4b46694";
    buildInputs = [ self."libsigc++" cairo ];
  };

  "capstone" = fetch {
    name        = "capstone";
    version     = "4.0";
    filename    = "mingw-w64-x86_64-capstone-4.0-1-any.pkg.tar.xz";
    sha256      = "f06a0dfe2afa64ecf0ed165dc3974b7f28ab29245bcf6e5278d01eaf956e8068";
    buildInputs = [ gcc-libs ];
  };

  "catch" = fetch {
    name        = "catch";
    version     = "1.6.0";
    filename    = "mingw-w64-x86_64-catch-1.6.0-1-any.pkg.tar.xz";
    sha256      = "9c4916999802eee31b3e6ba737be34f4a96a658639a1c3e2385b6887a9b03e99";
  };

  "ccache" = fetch {
    name        = "ccache";
    version     = "3.5";
    filename    = "mingw-w64-x86_64-ccache-3.5-1-any.pkg.tar.xz";
    sha256      = "e8b0a32e23459d0170dfc63cb58082cebb4d40c0aa0a32374c04a104d562da3b";
    buildInputs = [ gcc-libs zlib ];
  };

  "cccl" = fetch {
    name        = "cccl";
    version     = "1.0";
    filename    = "mingw-w64-x86_64-cccl-1.0-1-any.pkg.tar.xz";
    sha256      = "c135b9bb9e333efbfe86a6b24d2580207dc8c0b23ff07058b7c9eb83b6386f1b";
  };

  "cego" = fetch {
    name        = "cego";
    version     = "2.42.13";
    filename    = "mingw-w64-x86_64-cego-2.42.13-1-any.pkg.tar.xz";
    sha256      = "8c39e3dd4cc8e262ec6f54f14cdbe1b1e8bf041561beeb158d3039d712b47dde";
    buildInputs = [ readline lfcbase lfcxml ];
  };

  "cegui" = fetch {
    name        = "cegui";
    version     = "0.8.7";
    filename    = "mingw-w64-x86_64-cegui-0.8.7-1-any.pkg.tar.xz";
    sha256      = "f7a9378482ed3bc221310208f76786262af16c5a12101ad210ef71cfb2d9e945";
    buildInputs = [ boost devil expat FreeImage freetype fribidi glew glfw glm irrlicht libepoxy libxml2 libiconv lua51 ogre3d ois-git openexr pcre python2 SDL2 SDL2_image tinyxml xerces-c zlib ];
    broken      = true;
  };

  "celt" = fetch {
    name        = "celt";
    version     = "0.11.3";
    filename    = "mingw-w64-x86_64-celt-0.11.3-4-any.pkg.tar.xz";
    sha256      = "d7f0de323428729be705d1a537acdf49ba649abe7ec52bb5b4f63fe988e8371f";
    buildInputs = [ libogg ];
  };

  "cereal" = fetch {
    name        = "cereal";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-cereal-1.2.2-1-any.pkg.tar.xz";
    sha256      = "9ec478895eef0d5639f36c6e6cb05c2ddca3a537f3c2ea54435ab28ef2afa6a8";
    buildInputs = [ boost ];
  };

  "ceres-solver" = fetch {
    name        = "ceres-solver";
    version     = "1.14.0";
    filename    = "mingw-w64-x86_64-ceres-solver-1.14.0-3-any.pkg.tar.xz";
    sha256      = "b7d810f0760143d3a93ff8f5f22fd3b97a61fdb55b88ea48935b871dc3d5e0e3";
    buildInputs = [ eigen3 glog suitesparse ];
  };

  "cfitsio" = fetch {
    name        = "cfitsio";
    version     = "3.450";
    filename    = "mingw-w64-x86_64-cfitsio-3.450-1-any.pkg.tar.xz";
    sha256      = "d929607f6468c954c4a3ae9a72d704a24f2012fbda9078a72e51aaf768b11de0";
    buildInputs = [ gcc-libs zlib ];
  };

  "cgal" = fetch {
    name        = "cgal";
    version     = "4.13";
    filename    = "mingw-w64-x86_64-cgal-4.13-1-any.pkg.tar.xz";
    sha256      = "7d6cf4bae366d47d95afae6e7106fa8228528c3b990b115e698765db92c25d92";
    buildInputs = [ gcc-libs boost gmp mpfr ];
  };

  "cgns" = fetch {
    name        = "cgns";
    version     = "3.3.1";
    filename    = "mingw-w64-x86_64-cgns-3.3.1-1-any.pkg.tar.xz";
    sha256      = "715f76b11b5cd92efae8e30a9f39f079e27c7375c1764fdd63a17d0a4aef4fc1";
    buildInputs = [ hdf5 ];
  };

  "check" = fetch {
    name        = "check";
    version     = "0.12.0";
    filename    = "mingw-w64-x86_64-check-0.12.0-1-any.pkg.tar.xz";
    sha256      = "6b7ab27550e4daf544baefbbe571c1cffc96ceafbbb4c902044440d69deffcda";
    buildInputs = [ gcc-libs ];
  };

  "chipmunk" = fetch {
    name        = "chipmunk";
    version     = "7.0.2";
    filename    = "mingw-w64-x86_64-chipmunk-7.0.2-1-any.pkg.tar.xz";
    sha256      = "91d74bfa0af12a8bcd81fd66242864801380cd4bb55a7bb04ac120ddefa54777";
  };

  "chromaprint" = fetch {
    name        = "chromaprint";
    version     = "1.4.3";
    filename    = "mingw-w64-x86_64-chromaprint-1.4.3-1-any.pkg.tar.xz";
    sha256      = "e91e7b234507783f26545654362338b3964cda7f1f1d200313adeec6ced7d783";
  };

  "clang" = fetch {
    name        = "clang";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-clang-7.0.1-1-any.pkg.tar.xz";
    sha256      = "d6c89ed7fd198796e7d006102510089b0175a2b291c943999bc7038516506be2";
    buildInputs = [ (assert llvm.version=="7.0.1"; llvm) gcc z3 ];
  };

  "clang-analyzer" = fetch {
    name        = "clang-analyzer";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-clang-analyzer-7.0.1-1-any.pkg.tar.xz";
    sha256      = "791d925c9597abe17dcf4b303f72894c21e303137b0bcb06a86aae66acbc48f0";
    buildInputs = [ (assert clang.version=="7.0.1"; clang) python2 ];
  };

  "clang-tools-extra" = fetch {
    name        = "clang-tools-extra";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-clang-tools-extra-7.0.1-1-any.pkg.tar.xz";
    sha256      = "ab2e5a1bdc9739614d978bd11ff64a28a758ba35524232628f3247d6d627fe81";
    buildInputs = [ gcc ];
  };

  "clucene" = fetch {
    name        = "clucene";
    version     = "2.3.3.4";
    filename    = "mingw-w64-x86_64-clucene-2.3.3.4-1-any.pkg.tar.xz";
    sha256      = "9a194f9f9d8e73546223bfd07ece7871462174206b42198b7d4702fd374399dd";
    buildInputs = [ boost zlib ];
  };

  "clutter" = fetch {
    name        = "clutter";
    version     = "1.26.2";
    filename    = "mingw-w64-x86_64-clutter-1.26.2-1-any.pkg.tar.xz";
    sha256      = "824995eda36e7527095e0a2cb682d32dd52a43326addb5bb2399ef122bd49864";
    buildInputs = [ atk cogl json-glib gobject-introspection-runtime gtk3 ];
    broken      = true;
  };

  "clutter-gst" = fetch {
    name        = "clutter-gst";
    version     = "3.0.26";
    filename    = "mingw-w64-x86_64-clutter-gst-3.0.26-1-any.pkg.tar.xz";
    sha256      = "6556c22416c2e0cc9ac9f6be2c65e3b0179e4953cb9b5c391a0d59edeefa85d7";
    buildInputs = [ gobject-introspection clutter gstreamer gst-plugins-base ];
    broken      = true;
  };

  "clutter-gtk" = fetch {
    name        = "clutter-gtk";
    version     = "1.8.4";
    filename    = "mingw-w64-x86_64-clutter-gtk-1.8.4-1-any.pkg.tar.xz";
    sha256      = "903a33368034e8f5870d3d145aeecdb8faaca94f4547a73890eeba2611a80a75";
    buildInputs = [ gtk3 clutter ];
    broken      = true;
  };

  "cmake" = fetch {
    name        = "cmake";
    version     = "3.12.4";
    filename    = "mingw-w64-x86_64-cmake-3.12.4-1-any.pkg.tar.xz";
    sha256      = "316565321a36677eaa28843ddc1876768ea9ac57f8e53188492444ec49ed1fe3";
    buildInputs = [ gcc-libs curl expat jsoncpp libarchive libuv rhash zlib ];
  };

  "cmake-doc-qt" = fetch {
    name        = "cmake-doc-qt";
    version     = "3.12.4";
    filename    = "mingw-w64-x86_64-cmake-doc-qt-3.12.4-1-any.pkg.tar.xz";
    sha256      = "7ebcb85edf7902228fcb63298814591d4462b2a9ad3bc524c25a050354425be5";
  };

  "cmark" = fetch {
    name        = "cmark";
    version     = "0.28.3";
    filename    = "mingw-w64-x86_64-cmark-0.28.3-1-any.pkg.tar.xz";
    sha256      = "cd058b748c33d81c45af7f563f2907877bdd56d4afa054d96bbca0b40de21499";
  };

  "cmocka" = fetch {
    name        = "cmocka";
    version     = "1.1.3";
    filename    = "mingw-w64-x86_64-cmocka-1.1.3-2-any.pkg.tar.xz";
    sha256      = "9ed067b59b1913c17c3af3293170aa4aa4a2660b378dad46fde822e558bebb7b";
  };

  "codelite-git" = fetch {
    name        = "codelite-git";
    version     = "12.0.656.g3349d0f7d";
    filename    = "mingw-w64-x86_64-codelite-git-12.0.656.g3349d0f7d-1-any.pkg.tar.xz";
    sha256      = "b5ec048983cc32babe80ffaae5971bb07d9f34d1a12b66037cb3fd6f6303bbf3";
    buildInputs = [ gcc-libs hunspell libssh drmingw clang wxWidgets sqlite3 ];
  };

  "cogl" = fetch {
    name        = "cogl";
    version     = "1.22.2";
    filename    = "mingw-w64-x86_64-cogl-1.22.2-1-any.pkg.tar.xz";
    sha256      = "1a338b805e31fb1430608215490ee9de076d0e1af98be1616d7314b2b228f7cb";
    buildInputs = [ pango gdk-pixbuf2 gstreamer gst-plugins-base ];
    broken      = true;
  };

  "coin3d-hg" = fetch {
    name        = "coin3d-hg";
    version     = "r11819+.c0999df53040+";
    filename    = "mingw-w64-x86_64-coin3d-hg-r11819+.c0999df53040+-1-any.pkg.tar.xz";
    sha256      = "dfd695862cd9b55b1f90cb45fe8e0bcf09155d01ed507451aa4e8159840beb69";
    buildInputs = [ simage bzip2 expat openal superglu freetype fontconfig zlib ];
    broken      = true;
  };

  "collada-dom-svn" = fetch {
    name        = "collada-dom-svn";
    version     = "2.4.1.r889";
    filename    = "mingw-w64-x86_64-collada-dom-svn-2.4.1.r889-7-any.pkg.tar.xz";
    sha256      = "c87fa347a41f57160a86a9ed1bda6a2c291e0a69b502a871333d7b68e28b5444";
    buildInputs = [ bzip2 boost libxml2 pcre zlib ];
  };

  "compiler-rt" = fetch {
    name        = "compiler-rt";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-compiler-rt-7.0.1-1-any.pkg.tar.xz";
    sha256      = "85a75bad40851ffbc6609505d451fdf4b304bf176ebec6c5795992303fc177ac";
    buildInputs = [ (assert llvm.version=="7.0.1"; llvm) ];
  };

  "confuse" = fetch {
    name        = "confuse";
    version     = "3.2.2";
    filename    = "mingw-w64-x86_64-confuse-3.2.2-1-any.pkg.tar.xz";
    sha256      = "38eeffe3dcc1487c5d8a894f306fbb1b1db0df907e9cc892a8cf55f52c045a4f";
    buildInputs = [ gettext ];
  };

  "connect" = fetch {
    name        = "connect";
    version     = "1.105";
    filename    = "mingw-w64-x86_64-connect-1.105-1-any.pkg.tar.xz";
    sha256      = "f312a6f4678a66c8df69c7f12efe1d9d11b84a4b7c06cf5d19cd73f23f54a2f0";
  };

  "cotire" = fetch {
    name        = "cotire";
    version     = "1.8.0_3.12";
    filename    = "mingw-w64-x86_64-cotire-1.8.0_3.12-2-any.pkg.tar.xz";
    sha256      = "113d3b17b154b570b30f7c621f96357e5bd48a209b25faae75580275bec24e74";
  };

  "cppcheck" = fetch {
    name        = "cppcheck";
    version     = "1.86";
    filename    = "mingw-w64-x86_64-cppcheck-1.86-1-any.pkg.tar.xz";
    sha256      = "262c872bdadbc4eedd53be748dcf9caa75c5a3b2c91c0603819b3ffdc974ccc1";
    buildInputs = [ pcre ];
  };

  "cppreference-qt" = fetch {
    name        = "cppreference-qt";
    version     = "20181028";
    filename    = "mingw-w64-x86_64-cppreference-qt-20181028-1-any.pkg.tar.xz";
    sha256      = "fcde2f414f92a8e87d611ee217e05f0c7eba9122d7cbfc5ab435d41daa2ca740";
  };

  "cpptest" = fetch {
    name        = "cpptest";
    version     = "1.1.2";
    filename    = "mingw-w64-x86_64-cpptest-1.1.2-2-any.pkg.tar.xz";
    sha256      = "f728b0a1ec93bcbc87aa83e30b027c08643c95a6cea53cca6cb390b4fcc5ab82";
  };

  "cppunit" = fetch {
    name        = "cppunit";
    version     = "1.14.0";
    filename    = "mingw-w64-x86_64-cppunit-1.14.0-1-any.pkg.tar.xz";
    sha256      = "bfb1c218677acffcef41a932434a044de9ad996dec70c0f8ac88ce205460984c";
    buildInputs = [ gcc-libs ];
  };

  "creduce" = fetch {
    name        = "creduce";
    version     = "2.8.0";
    filename    = "mingw-w64-x86_64-creduce-2.8.0-1-any.pkg.tar.xz";
    sha256      = "3cb1f42c7873e7129fdede863d27de715302cf4bfb703254a028e49bbf4e05b7";
    buildInputs = [ perl-Benchmark-Timer perl-Exporter-Lite perl-File-Which perl-Getopt-Tabular perl-Regexp-Common perl-Sys-CPU astyle indent clang ];
    broken      = true;
  };

  "crt-git" = fetch {
    name        = "crt-git";
    version     = "7.0.0.5285.7b2baaf8";
    filename    = "mingw-w64-x86_64-crt-git-7.0.0.5285.7b2baaf8-1-any.pkg.tar.xz";
    sha256      = "6648f736c14326ef0b3cadcc0b936eff2c409e199477c4975567900f7aba95f4";
    buildInputs = [ headers-git ];
  };

  "crypto++" = fetch {
    name        = "crypto++";
    version     = "7.0.0";
    filename    = "mingw-w64-x86_64-crypto++-7.0.0-1-any.pkg.tar.xz";
    sha256      = "8e4bdd4ee06925551df4d1aa24000fd1674da983c7220c4a1a262f352004b949";
    buildInputs = [ gcc-libs ];
  };

  "csfml" = fetch {
    name        = "csfml";
    version     = "2.5";
    filename    = "mingw-w64-x86_64-csfml-2.5-1-any.pkg.tar.xz";
    sha256      = "a72a9ee750e3483f016a9bc23bb7295e3c94306764f78205dbad047c5fe5a148";
    buildInputs = [ sfml ];
  };

  "ctags" = fetch {
    name        = "ctags";
    version     = "5.8";
    filename    = "mingw-w64-x86_64-ctags-5.8-5-any.pkg.tar.xz";
    sha256      = "62398f24a2965cc1d836ca3a6b19d0f2adb2760091d68cc4d2b9983e21cbdb5a";
    buildInputs = [ gcc-libs ];
  };

  "ctpl-git" = fetch {
    name        = "ctpl-git";
    version     = "0.3.3.391.6dd5c14";
    filename    = "mingw-w64-x86_64-ctpl-git-0.3.3.391.6dd5c14-1-any.pkg.tar.xz";
    sha256      = "a04f4d646761b0b8e98e7c2f6eb2a99384d5eacf39b3298a743c36a8353b979b";
    buildInputs = [ glib2 ];
  };

  "cunit" = fetch {
    name        = "cunit";
    version     = "2.1.3";
    filename    = "mingw-w64-x86_64-cunit-2.1.3-3-any.pkg.tar.xz";
    sha256      = "86cc9f4dac8ac274fba44cfd16ae364fd6b26f273eb644a8e5ec34f08e842099";
  };

  "curl" = fetch {
    name        = "curl";
    version     = "7.63.0";
    filename    = "mingw-w64-x86_64-curl-7.63.0-1-any.pkg.tar.xz";
    sha256      = "98474250b52e7ad2b2701e3f606e1f42d7945f97c79f881943f4bc645c326d74";
    buildInputs = [ gcc-libs c-ares brotli libidn2 libmetalink libpsl libssh2 zlib ca-certificates openssl nghttp2 ];
  };

  "cvode" = fetch {
    name        = "cvode";
    version     = "3.2.1";
    filename    = "mingw-w64-x86_64-cvode-3.2.1-1-any.pkg.tar.xz";
    sha256      = "146ba4ae7f63b00a14c633107e0f38fc76c504fe9cfa25249e04a3ceb332757b";
  };

  "cyrus-sasl" = fetch {
    name        = "cyrus-sasl";
    version     = "2.1.27.rc8";
    filename    = "mingw-w64-x86_64-cyrus-sasl-2.1.27.rc8-1-any.pkg.tar.xz";
    sha256      = "8a28f21b4aab4b4057eb00807c3ff2dc8c4e295058e331c5ddb3c1272fa96c1f";
    buildInputs = [ gdbm openssl sqlite3 ];
  };

  "cython" = fetch {
    name        = "cython";
    version     = "0.29.2";
    filename    = "mingw-w64-x86_64-cython-0.29.2-1-any.pkg.tar.xz";
    sha256      = "186b43e2ee1f2c1d89f9e9fa7603641fb34f6d24a5a7f44c48e4642e99da51d8";
    buildInputs = [ python3-setuptools ];
  };

  "cython2" = fetch {
    name        = "cython2";
    version     = "0.29.2";
    filename    = "mingw-w64-x86_64-cython2-0.29.2-1-any.pkg.tar.xz";
    sha256      = "92538f98affcba07daefbae513b9277303d92540dcfd6cc0ea2af7377854cb8f";
    buildInputs = [ python2-setuptools ];
  };

  "d-feet" = fetch {
    name        = "d-feet";
    version     = "0.3.14";
    filename    = "mingw-w64-x86_64-d-feet-0.3.14-1-any.pkg.tar.xz";
    sha256      = "603a3e53bd34417132344f235566c2ac60f54169a9513550fcfeed2a83b30ac0";
    buildInputs = [ gtk3 python3-gobject hicolor-icon-theme ];
  };

  "daala-git" = fetch {
    name        = "daala-git";
    version     = "r1505.52bbd43";
    filename    = "mingw-w64-x86_64-daala-git-r1505.52bbd43-1-any.pkg.tar.xz";
    sha256      = "26386065ab9e175700f734dc084bbbd0d960b0b5dba8978272163f57dab102a6";
    buildInputs = [ libogg libpng libjpeg-turbo SDL2 ];
    broken      = true;
  };

  "darktable" = fetch {
    name        = "darktable";
    version     = "2.4.4";
    filename    = "mingw-w64-x86_64-darktable-2.4.4-2-any.pkg.tar.xz";
    sha256      = "f987a8922d4419fe0f89eb82b934eb62d3b8c50e728b952df521ad126c224091";
    buildInputs = [ dbus-glib drmingw exiv2 flickcurl graphicsmagick gtk3 lcms2 lensfun libexif libgphoto2 libsecret libsoup libwebp libxslt lua openexr openjpeg2 osm-gps-map pugixml sqlite3 iso-codes zlib ];
    broken      = true;
  };

  "db" = fetch {
    name        = "db";
    version     = "6.0.19";
    filename    = "mingw-w64-x86_64-db-6.0.19-3-any.pkg.tar.xz";
    sha256      = "89ff33ecd5849aaaa915b06c0d6d223220cbe78e95d03ad74e703682f215c552";
    buildInputs = [ gcc-libs ];
  };

  "dbus" = fetch {
    name        = "dbus";
    version     = "1.12.12";
    filename    = "mingw-w64-x86_64-dbus-1.12.12-1-any.pkg.tar.xz";
    sha256      = "219b70d2ee3c0890d0b02c70eadb10bb7e8d4e72fc1ee33fd78e625f6994f7be";
    buildInputs = [ glib2 expat ];
  };

  "dbus-c++" = fetch {
    name        = "dbus-c++";
    version     = "0.9.0";
    filename    = "mingw-w64-x86_64-dbus-c++-0.9.0-1-any.pkg.tar.xz";
    sha256      = "d7b3b0436646fc665554ae19b90f6c04b33791c4d5616fc261504d4d63fc3b26";
    buildInputs = [ dbus ];
  };

  "dbus-glib" = fetch {
    name        = "dbus-glib";
    version     = "0.110";
    filename    = "mingw-w64-x86_64-dbus-glib-0.110-1-any.pkg.tar.xz";
    sha256      = "a95cab0e82342a157dbcbcdc9608cb6a467acc7f799b57db16892a2fd29b7c3a";
    buildInputs = [ glib2 dbus expat ];
  };

  "dcadec" = fetch {
    name        = "dcadec";
    version     = "0.2.0";
    filename    = "mingw-w64-x86_64-dcadec-0.2.0-2-any.pkg.tar.xz";
    sha256      = "1b4f2c6cde60d873587ede50aab828ca92751d45c31de5c6e55164d4e39fddf0";
    buildInputs = [ gcc-libs ];
  };

  "desktop-file-utils" = fetch {
    name        = "desktop-file-utils";
    version     = "0.23";
    filename    = "mingw-w64-x86_64-desktop-file-utils-0.23-1-any.pkg.tar.xz";
    sha256      = "71427103f4913058a3eb42c9bb884733ec384044e40c2edc9155df36d4800637";
    buildInputs = [ glib2 gtk3 libxml2 ];
  };

  "devcon-git" = fetch {
    name        = "devcon-git";
    version     = "r233.8b17cf3";
    filename    = "mingw-w64-x86_64-devcon-git-r233.8b17cf3-1-any.pkg.tar.xz";
    sha256      = "46f674979a203b19a016970002adf5fc4f9a40d87f3881cc7b37fb1a308fdd06";
  };

  "devhelp" = fetch {
    name        = "devhelp";
    version     = "3.8.2";
    filename    = "mingw-w64-x86_64-devhelp-3.8.2-2-any.pkg.tar.xz";
    sha256      = "5d9d003f4aabbc891568e8cb2777fdba072da240678fd1cacfdd9721bcc327c3";
    buildInputs = [ gtk3 gsettings-desktop-schemas adwaita-icon-theme webkitgtk3 png2ico python2 ];
    broken      = true;
  };

  "devil" = fetch {
    name        = "devil";
    version     = "1.8.0";
    filename    = "mingw-w64-x86_64-devil-1.8.0-4-any.pkg.tar.xz";
    sha256      = "e814225d56348590e44577973afa3fd7be4c4c38a53a5404b5eed12d0a1f3ebf";
    buildInputs = [ freeglut jasper lcms2 libmng libpng libsquish libtiff openexr zlib ];
  };

  "diffutils" = fetch {
    name        = "diffutils";
    version     = "3.6";
    filename    = "mingw-w64-x86_64-diffutils-3.6-2-any.pkg.tar.xz";
    sha256      = "7571813b2e0baa0b355aedbb8dc823ab0a56a7a9c72c8e58eb0764fff0428562";
    buildInputs = [ libsigsegv libwinpthread-git gettext ];
  };

  "discount" = fetch {
    name        = "discount";
    version     = "2.2.4";
    filename    = "mingw-w64-x86_64-discount-2.2.4-1-any.pkg.tar.xz";
    sha256      = "b15663fd76a5d26ca5db979f2f21b082dd4520ad15d1355e63a9ee37b5d96645";
  };

  "distorm" = fetch {
    name        = "distorm";
    version     = "3.3.8";
    filename    = "mingw-w64-x86_64-distorm-3.3.8-1-any.pkg.tar.xz";
    sha256      = "7ab31ed38e930940e450e297fe7409a60a4ec1cd3bb97606af8299d5a1e474b0";
  };

  "djview" = fetch {
    name        = "djview";
    version     = "4.10.6";
    filename    = "mingw-w64-x86_64-djview-4.10.6-1-any.pkg.tar.xz";
    sha256      = "6688cccc4fdf2c25eabbd8735cb54dd1931403a523e2beba775a857c8379e168";
    buildInputs = [ djvulibre gcc-libs qt5 libtiff ];
    broken      = true;
  };

  "djvulibre" = fetch {
    name        = "djvulibre";
    version     = "3.5.27";
    filename    = "mingw-w64-x86_64-djvulibre-3.5.27-3-any.pkg.tar.xz";
    sha256      = "56abceed9ed295ef27959272d696703a03dc08f4485c41e6b29e66742d9b6f39";
    buildInputs = [ gcc-libs libjpeg libiconv libtiff zlib ];
  };

  "dlfcn" = fetch {
    name        = "dlfcn";
    version     = "1.1.2";
    filename    = "mingw-w64-x86_64-dlfcn-1.1.2-1-any.pkg.tar.xz";
    sha256      = "12cd90e1c7eb312f65b832f710bb6f74ababddbb010ff6efc1278b2da8e3bec1";
    buildInputs = [ gcc-libs ];
  };

  "dlib" = fetch {
    name        = "dlib";
    version     = "19.16";
    filename    = "mingw-w64-x86_64-dlib-19.16-2-any.pkg.tar.xz";
    sha256      = "506845c78c7977052f130201e7669ce9b75100f24a32ec1a8cd4db692ad8faa8";
    buildInputs = [ lapack giflib libpng libjpeg-turbo openblas lapack fftw sqlite3 ];
  };

  "dmake" = fetch {
    name        = "dmake";
    version     = "4.12.2.2";
    filename    = "mingw-w64-x86_64-dmake-4.12.2.2-1-any.pkg.tar.xz";
    sha256      = "27b2beff57911faddacc300509c7a9cbedc029294a9779674cc8c3c06fb0b8b9";
  };

  "dnscrypt-proxy" = fetch {
    name        = "dnscrypt-proxy";
    version     = "1.6.0";
    filename    = "mingw-w64-x86_64-dnscrypt-proxy-1.6.0-2-any.pkg.tar.xz";
    sha256      = "cec0ec5fa25f27aa87284b30d627e6a37541fcdcb4241a99224fbfe48b5a62ff";
    buildInputs = [ libsodium ldns ];
  };

  "docbook-dsssl" = fetch {
    name        = "docbook-dsssl";
    version     = "1.79";
    filename    = "mingw-w64-x86_64-docbook-dsssl-1.79-1-any.pkg.tar.xz";
    sha256      = "f5f40c476a9f1170c40e5b63216cc0fc79fb94b0966edef69c9540c0333f6f59";
    buildInputs = [ sgml-common perl ];
  };

  "docbook-mathml" = fetch {
    name        = "docbook-mathml";
    version     = "1.1CR1";
    filename    = "mingw-w64-x86_64-docbook-mathml-1.1CR1-1-any.pkg.tar.xz";
    sha256      = "e33276babf97185960999b6a9fffa49041ca5cccf740446d76c95f5273151369";
    buildInputs = [ libxml2 ];
  };

  "docbook-sgml" = fetch {
    name        = "docbook-sgml";
    version     = "4.5";
    filename    = "mingw-w64-x86_64-docbook-sgml-4.5-1-any.pkg.tar.xz";
    sha256      = "d6929fbd14ddce62682a589ecf0ca38c0ed3a37c36bfda467f2d940c79b627a6";
    buildInputs = [ sgml-common ];
  };

  "docbook-sgml31" = fetch {
    name        = "docbook-sgml31";
    version     = "3.1";
    filename    = "mingw-w64-x86_64-docbook-sgml31-3.1-1-any.pkg.tar.xz";
    sha256      = "36355dfbf02f1af40ac93ba402b579fe66a5d1a1601b5ec450c6107897b81df1";
    buildInputs = [ sgml-common ];
  };

  "docbook-xml" = fetch {
    name        = "docbook-xml";
    version     = "5.0";
    filename    = "mingw-w64-x86_64-docbook-xml-5.0-1-any.pkg.tar.xz";
    sha256      = "da5cea7fe9e98f17f05bea5410f12d34f04c01428997b0cb1dd5c573e79a1275";
    buildInputs = [ libxml2 ];
  };

  "docbook-xsl" = fetch {
    name        = "docbook-xsl";
    version     = "1.79.2";
    filename    = "mingw-w64-x86_64-docbook-xsl-1.79.2-3-any.pkg.tar.xz";
    sha256      = "dccfabf09da877aee54167ba2780e565c985b7aafca02634ce7f4f0b3a8046c5";
    buildInputs = [ libxml2 libxslt docbook-xml ];
  };

  "double-conversion" = fetch {
    name        = "double-conversion";
    version     = "3.1.1";
    filename    = "mingw-w64-x86_64-double-conversion-3.1.1-1-any.pkg.tar.xz";
    sha256      = "676a3d46f74d6db3c68797b66a349603b6ede326ddd36aa6dffa7095909050fe";
    buildInputs = [ gcc-libs ];
  };

  "doxygen" = fetch {
    name        = "doxygen";
    version     = "1.8.14";
    filename    = "mingw-w64-x86_64-doxygen-1.8.14-3-any.pkg.tar.xz";
    sha256      = "59497d7d920cdaa8abb9c389b3952db6acc3ebaef23524dc4964448ef3757f5c";
    buildInputs = [ clang gcc-libs libiconv sqlite3 xapian-core ];
  };

  "drmingw" = fetch {
    name        = "drmingw";
    version     = "0.8.2";
    filename    = "mingw-w64-x86_64-drmingw-0.8.2-1-any.pkg.tar.xz";
    sha256      = "0f7853f3275a8aff4505ad34754ee43bfcba56df8a6f1e9001c6c96fb1e0f815";
    buildInputs = [ gcc-libs ];
  };

  "dsdp" = fetch {
    name        = "dsdp";
    version     = "5.8";
    filename    = "mingw-w64-x86_64-dsdp-5.8-1-any.pkg.tar.xz";
    sha256      = "90f8ca228aa4af4e1121313a193057cd8f147d26de97c3520448f5b24dd2bbb9";
    buildInputs = [ openblas ];
  };

  "dumb" = fetch {
    name        = "dumb";
    version     = "2.0.3";
    filename    = "mingw-w64-x86_64-dumb-2.0.3-1-any.pkg.tar.xz";
    sha256      = "7e323314d712d4051929a7153f385a1d078d54479b043e221273aa6d18a8456d";
  };

  "editorconfig-core-c" = fetch {
    name        = "editorconfig-core-c";
    version     = "0.12.3";
    filename    = "mingw-w64-x86_64-editorconfig-core-c-0.12.3-1-any.pkg.tar.xz";
    sha256      = "ed0cb2387e8b7021ec74c3ff90681df44acfbda797b223695aabe1324410344d";
    buildInputs = [ pcre ];
  };

  "editrights" = fetch {
    name        = "editrights";
    version     = "1.03";
    filename    = "mingw-w64-x86_64-editrights-1.03-3-any.pkg.tar.xz";
    sha256      = "625b265dba8eb96f2550d3b0e59b78414244fecd1331a23e12ff081c94e81c9c";
  };

  "eigen3" = fetch {
    name        = "eigen3";
    version     = "3.3.7";
    filename    = "mingw-w64-x86_64-eigen3-3.3.7-1-any.pkg.tar.xz";
    sha256      = "9cec85ae9a1ccdab3eb2b23ada59e0ba5a20f85ac8f188efe0b7ebb2049cb60b";
    buildInputs = [  ];
  };

  "emacs" = fetch {
    name        = "emacs";
    version     = "26.1";
    filename    = "mingw-w64-x86_64-emacs-26.1-1-any.pkg.tar.xz";
    sha256      = "3305bea45ceb9375d38868cf60e423c191ddd5d1d46e18d8171fd9f5cf756b35";
    buildInputs = [ ctags zlib xpm-nox dbus gnutls imagemagick libwinpthread-git ];
    broken      = true;
  };

  "enca" = fetch {
    name        = "enca";
    version     = "1.19";
    filename    = "mingw-w64-x86_64-enca-1.19-1-any.pkg.tar.xz";
    sha256      = "c1779aedefbdb1f4f2db554dce3bd1a6221f579e3aa2de6f1f95de76537d61ab";
    buildInputs = [ recode ];
  };

  "enchant" = fetch {
    name        = "enchant";
    version     = "2.2.3";
    filename    = "mingw-w64-x86_64-enchant-2.2.3-3-any.pkg.tar.xz";
    sha256      = "8d4fd60e8b5b7568f4738d0335e953dade4c701caaccd4cda33d0e553f695596";
    buildInputs = [ gcc-libs glib2 aspell hunspell libvoikko ];
  };

  "enet" = fetch {
    name        = "enet";
    version     = "1.3.13";
    filename    = "mingw-w64-x86_64-enet-1.3.13-2-any.pkg.tar.xz";
    sha256      = "134de1da58b387ea4a5b88a7834f4b41a75407cefcacd595222370acbe89acad";
  };

  "eog" = fetch {
    name        = "eog";
    version     = "3.16.3";
    filename    = "mingw-w64-x86_64-eog-3.16.3-1-any.pkg.tar.xz";
    sha256      = "a2022f67385323dbe7dadc03eba5d689254f3f1c13fa48255cb01027d8cf6840";
    buildInputs = [ adwaita-icon-theme gettext gtk3 gdk-pixbuf2 gobject-introspection-runtime gsettings-desktop-schemas zlib libexif libjpeg-turbo libpeas librsvg libxml2 shared-mime-info ];
  };

  "eog-plugins" = fetch {
    name        = "eog-plugins";
    version     = "3.16.3";
    filename    = "mingw-w64-x86_64-eog-plugins-3.16.3-1-any.pkg.tar.xz";
    sha256      = "bdaa36597c7753475fffd150384ad15d31422fc32330797fa16df319ba8c233e";
    buildInputs = [ eog libchamplain libexif libgdata postr python2 ];
    broken      = true;
  };

  "evince" = fetch {
    name        = "evince";
    version     = "3.28.2";
    filename    = "mingw-w64-x86_64-evince-3.28.2-3-any.pkg.tar.xz";
    sha256      = "cce4c29a18847aad7784174afeb0788bc7e2950c02fd07311be0e1c6d09e4982";
    buildInputs = [ glib2 cairo djvulibre gsettings-desktop-schemas gtk3 libgxps libspectre libtiff poppler gst-plugins-base nss ];
    broken      = true;
  };

  "exiv2" = fetch {
    name        = "exiv2";
    version     = "0.26";
    filename    = "mingw-w64-x86_64-exiv2-0.26-3-any.pkg.tar.xz";
    sha256      = "d02648cee3cdcc8f465fafceb6defbfa33cac99fa999d6b5c4c6bb5181769309";
    buildInputs = [ expat gettext curl libssh2 zlib ];
  };

  "expat" = fetch {
    name        = "expat";
    version     = "2.2.6";
    filename    = "mingw-w64-x86_64-expat-2.2.6-1-any.pkg.tar.xz";
    sha256      = "cd9c239903d0e6d950d3b7c9a6bff190491cf6423ec9896cda2072a980ddc85d";
    buildInputs = [  ];
  };

  "extra-cmake-modules" = fetch {
    name        = "extra-cmake-modules";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-extra-cmake-modules-5.50.0-1-any.pkg.tar.xz";
    sha256      = "f011b4739780892da1e45a578c0e36fe8efd3e4475fffa8cc3a2038f05ae1d20";
    buildInputs = [ cmake png2ico ];
  };

  "f2c" = fetch {
    name        = "f2c";
    version     = "1.0";
    filename    = "mingw-w64-x86_64-f2c-1.0-1-any.pkg.tar.xz";
    sha256      = "9bab9ca1f964c2dfd63c75ee1e91ff455946e502ac11d0e0d89b53d0931b61e5";
  };

  "faac" = fetch {
    name        = "faac";
    version     = "1.29.9.2";
    filename    = "mingw-w64-x86_64-faac-1.29.9.2-1-any.pkg.tar.xz";
    sha256      = "26d465aa71ea4e1c292482ad9b96627e463196ee70683e9961a938776125a339";
  };

  "faad2" = fetch {
    name        = "faad2";
    version     = "2.8.8";
    filename    = "mingw-w64-x86_64-faad2-2.8.8-1-any.pkg.tar.xz";
    sha256      = "439331f2836b76b5ec7184f8c9bab1573d5a8b244675b582ec83d85ed577328d";
    buildInputs = [ gcc-libs ];
  };

  "fann" = fetch {
    name        = "fann";
    version     = "2.2.0";
    filename    = "mingw-w64-x86_64-fann-2.2.0-2-any.pkg.tar.xz";
    sha256      = "67b9fad842bbcfea0fcf22616da4bc076b5dfd5d10810b784a0780b5ff511ccb";
  };

  "farstream" = fetch {
    name        = "farstream";
    version     = "0.2.8";
    filename    = "mingw-w64-x86_64-farstream-0.2.8-2-any.pkg.tar.xz";
    sha256      = "d662099b748d64ef337acf2b8b5afc419730ae095baed137950e6b9b480da61d";
    buildInputs = [ gst-plugins-base libnice ];
    broken      = true;
  };

  "fastjar" = fetch {
    name        = "fastjar";
    version     = "0.98";
    filename    = "mingw-w64-x86_64-fastjar-0.98-1-any.pkg.tar.xz";
    sha256      = "9fd9397961fd40ff2275648fa620194d3387ae0e5a08dae380a0ab6789860f02";
    buildInputs = [ gcc-libs zlib ];
  };

  "fcrackzip" = fetch {
    name        = "fcrackzip";
    version     = "1.0";
    filename    = "mingw-w64-x86_64-fcrackzip-1.0-1-any.pkg.tar.xz";
    sha256      = "7a37115dad04fcd21334999e675797ad2b037256629df444ae78ab00f0c9e84a";
  };

  "fdk-aac" = fetch {
    name        = "fdk-aac";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-fdk-aac-2.0.0-1-any.pkg.tar.xz";
    sha256      = "37a11714c6dfba12f0b6cb06fc4804eb3bf3464b75ecb1cefc8236d7007fc4e7";
  };

  "ffcall" = fetch {
    name        = "ffcall";
    version     = "2.1";
    filename    = "mingw-w64-x86_64-ffcall-2.1-1-any.pkg.tar.xz";
    sha256      = "bd85a1d6b335647d9092401009bdf85ec7d4e4b6709054bc967edde59dc13a2d";
  };

  "ffmpeg" = fetch {
    name        = "ffmpeg";
    version     = "4.1";
    filename    = "mingw-w64-x86_64-ffmpeg-4.1-1-any.pkg.tar.xz";
    sha256      = "f30aebdb2f51ca202a7c31553481f36fa3a3066d687cef3eff3074a07c2a1104";
    buildInputs = [ bzip2 celt fontconfig gnutls gsm lame libass libbluray libcaca libmodplug libtheora libvorbis libvpx libwebp openal opencore-amr openjpeg2 opus rtmpdump-git SDL2 speex wavpack x264-git x265 xvidcore zlib ];
    broken      = true;
  };

  "ffms2" = fetch {
    name        = "ffms2";
    version     = "2.23";
    filename    = "mingw-w64-x86_64-ffms2-2.23-1-any.pkg.tar.xz";
    sha256      = "346a62f19b08bfb45f5421db6dba7690681869ab937d8ecf006b411eb3c2cfa9";
    buildInputs = [ ffmpeg ];
    broken      = true;
  };

  "fftw" = fetch {
    name        = "fftw";
    version     = "3.3.8";
    filename    = "mingw-w64-x86_64-fftw-3.3.8-1-any.pkg.tar.xz";
    sha256      = "dbbe689c81b413ac5165603eca6b1bef437638e830a8020cad7490da4728ef59";
    buildInputs = [ gcc-libs ];
  };

  "fgsl" = fetch {
    name        = "fgsl";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-fgsl-1.2.0-2-any.pkg.tar.xz";
    sha256      = "185e1c8c0cac837f6d975eedec07b445c4b21b6abbc8dd8e2a753af9d4935866";
    buildInputs = [ gcc-libs gcc-libgfortran (assert stdenvNoCC.lib.versionAtLeast gsl.version "2.3"; gsl) ];
  };

  "field3d" = fetch {
    name        = "field3d";
    version     = "1.7.2";
    filename    = "mingw-w64-x86_64-field3d-1.7.2-6-any.pkg.tar.xz";
    sha256      = "3af1249f867d9cf643bd1353ecad3244b0a108df4309dd04bcfd2c1d53eb1160";
    buildInputs = [ boost hdf5 openexr ];
  };

  "file" = fetch {
    name        = "file";
    version     = "5.35";
    filename    = "mingw-w64-x86_64-file-5.35-1-any.pkg.tar.xz";
    sha256      = "9e3543f2cc58b1f688967bbcb3be607c2bf2a6d92d9d55e86c475b2b015b619e";
    buildInputs = [ libsystre ];
  };

  "firebird2-git" = fetch {
    name        = "firebird2-git";
    version     = "2.5.9.27107.8f69580de5";
    filename    = "mingw-w64-x86_64-firebird2-git-2.5.9.27107.8f69580de5-1-any.pkg.tar.xz";
    sha256      = "aee91945798823e2765fc9b091db1a540929abf16a39eaaf733f0cd137079f6c";
    buildInputs = [ gcc-libs icu zlib ];
  };

  "flac" = fetch {
    name        = "flac";
    version     = "1.3.2";
    filename    = "mingw-w64-x86_64-flac-1.3.2-1-any.pkg.tar.xz";
    sha256      = "fb4b4352511c47738ca97d09928b28fc49eead290ad8d420ca1ee9ddc8f72b7b";
    buildInputs = [ libogg gcc-libs ];
  };

  "flatbuffers" = fetch {
    name        = "flatbuffers";
    version     = "1.10.0";
    filename    = "mingw-w64-x86_64-flatbuffers-1.10.0-1-any.pkg.tar.xz";
    sha256      = "4e8da118ba8f3fbddd49c428f6587ab6b45d0f0ea4aa624b24aa28c7aea2ff84";
    buildInputs = [ libsystre ];
  };

  "flexdll" = fetch {
    name        = "flexdll";
    version     = "0.34";
    filename    = "mingw-w64-x86_64-flexdll-0.34-2-any.pkg.tar.xz";
    sha256      = "0e18d10991eba90e61c0868b9791f3f5c8c70fde45e19133d886335f44227bfa";
  };

  "flickcurl" = fetch {
    name        = "flickcurl";
    version     = "1.26";
    filename    = "mingw-w64-x86_64-flickcurl-1.26-2-any.pkg.tar.xz";
    sha256      = "a04aed4e194546b48717a6e0f07f8961456affcff38a8bdff276faecf1909617";
    buildInputs = [ curl libxml2 ];
  };

  "flif" = fetch {
    name        = "flif";
    version     = "0.3";
    filename    = "mingw-w64-x86_64-flif-0.3-1-any.pkg.tar.xz";
    sha256      = "0b477f94c3e1dfe3edfba3edb97f4c5c1cfa911509fec5ac025b402d120addb7";
    buildInputs = [ zlib libpng SDL2 ];
    broken      = true;
  };

  "fltk" = fetch {
    name        = "fltk";
    version     = "1.3.4.2";
    filename    = "mingw-w64-x86_64-fltk-1.3.4.2-1-any.pkg.tar.xz";
    sha256      = "258632e1af6c0e0a2574f37e90b1cb2d701056b5e23931cd6c312466397514db";
    buildInputs = [ expat gcc-libs gettext libiconv libpng libjpeg-turbo zlib ];
  };

  "fluidsynth" = fetch {
    name        = "fluidsynth";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-fluidsynth-2.0.0-1-any.pkg.tar.xz";
    sha256      = "281b3dc59d41cfecfb22919cf03c133a21d6665a1c4c1cf742cf9d676749c85a";
    buildInputs = [ gcc-libs glib2 libsndfile portaudio ];
  };

  "fmt" = fetch {
    name        = "fmt";
    version     = "5.2.1";
    filename    = "mingw-w64-x86_64-fmt-5.2.1-1-any.pkg.tar.xz";
    sha256      = "2abcd74bf49c6b8fc4720c5007a1f7a55877ffdad45d8e7c75a80bfb15b8413d";
    buildInputs = [ gcc-libs ];
  };

  "fontconfig" = fetch {
    name        = "fontconfig";
    version     = "2.13.1";
    filename    = "mingw-w64-x86_64-fontconfig-2.13.1-1-any.pkg.tar.xz";
    sha256      = "e2becfc6fd1b0ef3e1b3875abb9adf7a47c06957a82419668436b699318903e4";
    buildInputs = [ gcc-libs (assert stdenvNoCC.lib.versionAtLeast expat.version "2.1.0"; expat) (assert stdenvNoCC.lib.versionAtLeast freetype.version "2.3.11"; freetype) (assert stdenvNoCC.lib.versionAtLeast bzip2.version "1.0.6"; bzip2) libiconv ];
  };

  "fossil" = fetch {
    name        = "fossil";
    version     = "2.6";
    filename    = "mingw-w64-x86_64-fossil-2.6-2-any.pkg.tar.xz";
    sha256      = "01416370bf4cbb0624c3c70fe72eba8fcdc6af55f1569d69e5c39add88276a8c";
    buildInputs = [ openssl readline sqlite3 zlib ];
  };

  "fox" = fetch {
    name        = "fox";
    version     = "1.6.57";
    filename    = "mingw-w64-x86_64-fox-1.6.57-1-any.pkg.tar.xz";
    sha256      = "d0ca1c1c1804c14b51494245d60acf4cd4fcf3752ac6f61d3d7d5013d0c691b3";
    buildInputs = [ gcc-libs libtiff zlib libpng libjpeg-turbo ];
  };

  "freealut" = fetch {
    name        = "freealut";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-freealut-1.1.0-1-any.pkg.tar.xz";
    sha256      = "f9f6458adf037d4b584751e3d75afe106fbc670d10031eb555c4827174f21077";
    buildInputs = [ openal ];
  };

  "freeglut" = fetch {
    name        = "freeglut";
    version     = "3.0.0";
    filename    = "mingw-w64-x86_64-freeglut-3.0.0-4-any.pkg.tar.xz";
    sha256      = "06dfe681cac12cf898ff9d5f2ed9fe1ef657429600e9d22fd8348d5f98389584";
    buildInputs = [  ];
  };

  "freeimage" = fetch {
    name        = "freeimage";
    version     = "3.18.0";
    filename    = "mingw-w64-x86_64-freeimage-3.18.0-2-any.pkg.tar.xz";
    sha256      = "3bb4483827e1fe98d579259d12be3fd581f87b6ca4c6a2161c8ae0ad86c85701";
    buildInputs = [ gcc-libs jxrlib libjpeg-turbo libpng libtiff libraw libwebp openjpeg2 openexr ];
  };

  "freetds" = fetch {
    name        = "freetds";
    version     = "1.00.98";
    filename    = "mingw-w64-x86_64-freetds-1.00.98-1-any.pkg.tar.xz";
    sha256      = "f95ebbee8a220f1c818086d6ac7cdde2e80762e89c117ec76cbb99b7a380f662";
    buildInputs = [ gcc-libs openssl libiconv ];
  };

  "freetype" = fetch {
    name        = "freetype";
    version     = "2.9.1";
    filename    = "mingw-w64-x86_64-freetype-2.9.1-1-any.pkg.tar.xz";
    sha256      = "16aa47d6956e58d64848af624018f7c9efad3e6ed5b486f1c778b1391e139f9e";
    buildInputs = [ gcc-libs bzip2 harfbuzz libpng zlib ];
  };

  "fribidi" = fetch {
    name        = "fribidi";
    version     = "1.0.5";
    filename    = "mingw-w64-x86_64-fribidi-1.0.5-1-any.pkg.tar.xz";
    sha256      = "defbeed05e0c8c86e7bf8829f643089f3d695ebf08ad5d18938a681a1c84015d";
    buildInputs = [  ];
  };

  "ftgl" = fetch {
    name        = "ftgl";
    version     = "2.1.3rc5";
    filename    = "mingw-w64-x86_64-ftgl-2.1.3rc5-2-any.pkg.tar.xz";
    sha256      = "dc5e7f134ee95898df5057af5c295285ddae9a817718fb9911326365301fcc37";
    buildInputs = [ gcc-libs freetype ];
  };

  "gavl" = fetch {
    name        = "gavl";
    version     = "1.4.0";
    filename    = "mingw-w64-x86_64-gavl-1.4.0-1-any.pkg.tar.xz";
    sha256      = "5290ae3d00150d586ee2e1f795bb17b6b60fda90bf51c61306aba42040c7d661";
    buildInputs = [ gcc-libs libpng ];
  };

  "gc" = fetch {
    name        = "gc";
    version     = "7.6.8";
    filename    = "mingw-w64-x86_64-gc-7.6.8-1-any.pkg.tar.xz";
    sha256      = "4cda681a1932e8d9653b8c1e8e695f731dc68d2369a689304a9974e28d2273f4";
    buildInputs = [ gcc-libs libatomic_ops ];
  };

  "gcc" = fetch {
    name        = "gcc";
    version     = "8.2.1+20181214";
    filename    = "mingw-w64-x86_64-gcc-8.2.1+20181214-1-any.pkg.tar.xz";
    sha256      = "8216c94569d833e3f7bd522a7fbd875f0e931bcec3c73fac3327b86dfae7b34f";
    buildInputs = [ binutils crt-git headers-git isl libiconv mpc (assert gcc-libs.version=="8.2.1+20181214"; gcc-libs) windows-default-manifest winpthreads-git zlib ];
  };

  "gcc-ada" = fetch {
    name        = "gcc-ada";
    version     = "8.2.1+20181214";
    filename    = "mingw-w64-x86_64-gcc-ada-8.2.1+20181214-1-any.pkg.tar.xz";
    sha256      = "3585480f007533b7cecd89c58caf224b3efc8bc779464d9e36d02710d3dc3677";
    buildInputs = [ (assert gcc.version=="8.2.1+20181214"; gcc) ];
  };

  "gcc-fortran" = fetch {
    name        = "gcc-fortran";
    version     = "8.2.1+20181214";
    filename    = "mingw-w64-x86_64-gcc-fortran-8.2.1+20181214-1-any.pkg.tar.xz";
    sha256      = "641d0e9a532ec5c2b638a4b54c8d13c376623c2a2f2b336fa1d6e18aea84588a";
    buildInputs = [ (assert gcc.version=="8.2.1+20181214"; gcc) (assert gcc-libgfortran.version=="8.2.1+20181214"; gcc-libgfortran) ];
  };

  "gcc-libgfortran" = fetch {
    name        = "gcc-libgfortran";
    version     = "8.2.1+20181214";
    filename    = "mingw-w64-x86_64-gcc-libgfortran-8.2.1+20181214-1-any.pkg.tar.xz";
    sha256      = "3b0ec99373116e80dde31eaff30fa63bcf3698755f0c8240f84b67d22f899e93";
    buildInputs = [ (assert gcc-libs.version=="8.2.1+20181214"; gcc-libs) ];
  };

  "gcc-libs" = fetch {
    name        = "gcc-libs";
    version     = "8.2.1+20181214";
    filename    = "mingw-w64-x86_64-gcc-libs-8.2.1+20181214-1-any.pkg.tar.xz";
    sha256      = "6e8f4922c9143f6eb36d29c28ce1ac65c85409c1e09a271e746903be789d2828";
    buildInputs = [ gmp mpc mpfr libwinpthread-git ];
  };

  "gcc-objc" = fetch {
    name        = "gcc-objc";
    version     = "8.2.1+20181214";
    filename    = "mingw-w64-x86_64-gcc-objc-8.2.1+20181214-1-any.pkg.tar.xz";
    sha256      = "03642c52451f6061996eae573a89f9882af8640abbf1a29adfa73da3d6855d70";
    buildInputs = [ (assert gcc.version=="8.2.1+20181214"; gcc) ];
  };

  "gd" = fetch {
    name        = "gd";
    version     = "2.2.5";
    filename    = "mingw-w64-x86_64-gd-2.2.5-3-any.pkg.tar.xz";
    sha256      = "790daf52775e8725b787b27fbaef788d713cdabd2c5d8e33cc778618842dddd0";
    buildInputs = [ fontconfig libiconv libjpeg libpng libtiff libvpx xpm-nox ];
  };

  "gdal" = fetch {
    name        = "gdal";
    version     = "2.4.0";
    filename    = "mingw-w64-x86_64-gdal-2.4.0-1-any.pkg.tar.xz";
    sha256      = "8160ff041895c264445fa560e91df9435a8e6aaf9f7a93b60b32767020b2fc97";
    buildInputs = [ cfitsio self."crypto++" curl expat geos giflib hdf5 jasper json-c libfreexl libgeotiff libiconv libjpeg libkml libpng libspatialite libtiff libwebp libxml2 netcdf openjpeg2 pcre poppler postgresql proj qhull-git sqlite3 xerces-c xz ];
    broken      = true;
  };

  "gdb" = fetch {
    name        = "gdb";
    version     = "8.2.1";
    filename    = "mingw-w64-x86_64-gdb-8.2.1-1-any.pkg.tar.xz";
    sha256      = "3ac8f232399769827dfc5b8584688c45201a0ca622bc8e248994027a6a12118f";
    buildInputs = [ expat libiconv python3 readline zlib ];
  };

  "gdbm" = fetch {
    name        = "gdbm";
    version     = "1.18.1";
    filename    = "mingw-w64-x86_64-gdbm-1.18.1-1-any.pkg.tar.xz";
    sha256      = "8b81e76e5af622864f59861c2529bc1d2e951034e52194cfcb4499345412a166";
    buildInputs = [ gcc-libs gettext libiconv ];
  };

  "gdcm" = fetch {
    name        = "gdcm";
    version     = "2.8.8";
    filename    = "mingw-w64-x86_64-gdcm-2.8.8-2-any.pkg.tar.xz";
    sha256      = "57e567237941468d720747f927ac61094644753afe8d1168ae589fa009f3d166";
    buildInputs = [ expat gcc-libs lcms2 libxml2 json-c openssl poppler zlib ];
  };

  "gdk-pixbuf2" = fetch {
    name        = "gdk-pixbuf2";
    version     = "2.38.0";
    filename    = "mingw-w64-x86_64-gdk-pixbuf2-2.38.0-2-any.pkg.tar.xz";
    sha256      = "6a8968e5c89b3626420b8f9573028fd1ae49d4ee5888d03f50048db47e9d1356";
    buildInputs = [ gcc-libs (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.37.2"; glib2) jasper libjpeg-turbo libpng libtiff ];
  };

  "gdl" = fetch {
    name        = "gdl";
    version     = "3.28.0";
    filename    = "mingw-w64-x86_64-gdl-3.28.0-1-any.pkg.tar.xz";
    sha256      = "40f6f90e2eebffee1575fcaac36cddf352088a78a1c7056a7aaf6af062bb6dff";
    buildInputs = [ gtk3 libxml2 ];
  };

  "gdl2" = fetch {
    name        = "gdl2";
    version     = "2.31.2";
    filename    = "mingw-w64-x86_64-gdl2-2.31.2-2-any.pkg.tar.xz";
    sha256      = "758beb1f7f4ae87895fdecd377131380d90cb75d0418f4d7c67fea951ddc8769";
    buildInputs = [ gtk2 libxml2 ];
  };

  "gdlmm2" = fetch {
    name        = "gdlmm2";
    version     = "2.30.0";
    filename    = "mingw-w64-x86_64-gdlmm2-2.30.0-2-any.pkg.tar.xz";
    sha256      = "86cc428c4a46c3a0795f743f31d7ce031662344cbe0faea2c741a033e98b1445";
    buildInputs = [ gtk2 libxml2 ];
  };

  "geany" = fetch {
    name        = "geany";
    version     = "1.34.0";
    filename    = "mingw-w64-x86_64-geany-1.34.0-1-any.pkg.tar.xz";
    sha256      = "c80f8e283e8d5c5460079d8f85cdbfac21af447095960d873bbc92f5f4021c90";
    buildInputs = [ gtk3 adwaita-icon-theme ];
  };

  "geany-plugins" = fetch {
    name        = "geany-plugins";
    version     = "1.34.0";
    filename    = "mingw-w64-x86_64-geany-plugins-1.34.0-1-any.pkg.tar.xz";
    sha256      = "012ad3e95b3f27e397d05e0c08f32bdf2c4df25b328128dccce9517f622d825a";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast geany.version "1.34.0"; geany) discount gtkspell3 webkitgtk3 ctpl-git gpgme lua51 gtk3 hicolor-icon-theme python2 ];
    broken      = true;
  };

  "gedit" = fetch {
    name        = "gedit";
    version     = "3.30.2";
    filename    = "mingw-w64-x86_64-gedit-3.30.2-1-any.pkg.tar.xz";
    sha256      = "fcd4ce35ef478602ee5b16e781b48f4bfe4a6bfc90c3407d837e8f79d6343b15";
    buildInputs = [ adwaita-icon-theme enchant gsettings-desktop-schemas gtksourceview3 iso-codes libpeas python3-gobject gspell ];
  };

  "gedit-plugins" = fetch {
    name        = "gedit-plugins";
    version     = "3.30.1";
    filename    = "mingw-w64-x86_64-gedit-plugins-3.30.1-1-any.pkg.tar.xz";
    sha256      = "7719a1e95391a2f49d637d023de92056d7bce22d84bbfa57840ed967ae7ffbd3";
    buildInputs = [ gedit libgit2-glib ];
  };

  "gegl" = fetch {
    name        = "gegl";
    version     = "0.4.12";
    filename    = "mingw-w64-x86_64-gegl-0.4.12-1-any.pkg.tar.xz";
    sha256      = "8fe819aa79ef87af1cc8b949bc9fcce0a1c5124ad0f387a7f7f1a468c9159e4b";
    buildInputs = [ babl cairo exiv2 gcc-libs gdk-pixbuf2 gettext glib2 gtk2 jasper json-glib libjpeg libpng LibRaw librsvg libspiro libwebp lcms lensfun openexr pango SDL suitesparse ];
    broken      = true;
  };

  "geoclue" = fetch {
    name        = "geoclue";
    version     = "0.12.99";
    filename    = "mingw-w64-x86_64-geoclue-0.12.99-3-any.pkg.tar.xz";
    sha256      = "7fb2de35a8a8955c812173cdf45e78d1cd80cdea4d2a6ba3c83c52bfc61634ea";
    buildInputs = [ glib2 gtk2 libxml2 libxslt dbus-glib ];
  };

  "geocode-glib" = fetch {
    name        = "geocode-glib";
    version     = "3.26.0";
    filename    = "mingw-w64-x86_64-geocode-glib-3.26.0-1-any.pkg.tar.xz";
    sha256      = "d5867b5e347820062d0ae37f63fcef608628f86651a022570eb1d90d9d2d50d5";
    buildInputs = [ glib2 json-glib libsoup ];
  };

  "geoip" = fetch {
    name        = "geoip";
    version     = "1.6.12";
    filename    = "mingw-w64-x86_64-geoip-1.6.12-1-any.pkg.tar.xz";
    sha256      = "5c6e90b89860caef238e340b5795a94986f3aa30943b84a7688f595f1ff06001";
    buildInputs = [ geoip2-database zlib ];
  };

  "geoip2-database" = fetch {
    name        = "geoip2-database";
    version     = "20180522";
    filename    = "mingw-w64-x86_64-geoip2-database-20180522-1-any.pkg.tar.xz";
    sha256      = "4800e31e38dbbcfe96595039632acb6ac82549f7c35d9cf858419648d109efe0";
    buildInputs = [  ];
  };

  "geos" = fetch {
    name        = "geos";
    version     = "3.7.1";
    filename    = "mingw-w64-x86_64-geos-3.7.1-1-any.pkg.tar.xz";
    sha256      = "14a05753e3cbffce9e1b069397052e1a2f14e25d6dbfc950e8aba9adeecbccf5";
    buildInputs = [  ];
  };

  "gettext" = fetch {
    name        = "gettext";
    version     = "0.19.8.1";
    filename    = "mingw-w64-x86_64-gettext-0.19.8.1-7-any.pkg.tar.xz";
    sha256      = "08938cafa7dc9f713fe01624984749ae53372ceb94d7621be57acf46570a711e";
    buildInputs = [ expat gcc-libs libiconv ];
  };

  "gexiv2" = fetch {
    name        = "gexiv2";
    version     = "0.10.9";
    filename    = "mingw-w64-x86_64-gexiv2-0.10.9-1-any.pkg.tar.xz";
    sha256      = "a9c2bb59c3fbde865a17655430face2e827c2c5fa736e32bcbfb2c0b66ff45bc";
    buildInputs = [ glib2 exiv2 python2 ];
  };

  "gflags" = fetch {
    name        = "gflags";
    version     = "2.2.2";
    filename    = "mingw-w64-x86_64-gflags-2.2.2-1-any.pkg.tar.xz";
    sha256      = "a78464b4dfe4d7bf6fab17d17d15548a4c4967ec4e349ce1265849bcf27867f5";
    buildInputs = [  ];
  };

  "ghex" = fetch {
    name        = "ghex";
    version     = "3.18.3";
    filename    = "mingw-w64-x86_64-ghex-3.18.3-1-any.pkg.tar.xz";
    sha256      = "a7ea5e4689150d8379dffd54a45b55c1be4518e7184f76ef04ff12888088cc1b";
    buildInputs = [ gtk3 adwaita-icon-theme ];
  };

  "ghostscript" = fetch {
    name        = "ghostscript";
    version     = "9.26";
    filename    = "mingw-w64-x86_64-ghostscript-9.26-1-any.pkg.tar.xz";
    sha256      = "1e1ffd891baeede81befeae957d45f20f48278b305c504957b41c0c8bd3858ec";
    buildInputs = [ dbus freetype fontconfig gdk-pixbuf2 libiconv libidn libpaper libpng libjpeg libtiff lcms2 openjpeg2 zlib ];
  };

  "giflib" = fetch {
    name        = "giflib";
    version     = "5.1.4";
    filename    = "mingw-w64-x86_64-giflib-5.1.4-2-any.pkg.tar.xz";
    sha256      = "c845e93887496b76cd82c16c6d3dceeadddc9ed87a09f47966f99d8e4f489913";
    buildInputs = [ gcc-libs ];
  };

  "gimp" = fetch {
    name        = "gimp";
    version     = "2.10.8";
    filename    = "mingw-w64-x86_64-gimp-2.10.8-2-any.pkg.tar.xz";
    sha256      = "c163f2924adde7e7d161bcc2ee6900375149604c706669a4b43531a458882b9e";
    buildInputs = [ babl curl dbus-glib drmingw gegl gexiv2 ghostscript hicolor-icon-theme jasper lcms2 libexif libmng libmypaint librsvg libwmf mypaint-brushes openexr poppler python2-pygtk python2-gobject xpm-nox ];
    broken      = true;
  };

  "gimp-ufraw" = fetch {
    name        = "gimp-ufraw";
    version     = "0.22";
    filename    = "mingw-w64-x86_64-gimp-ufraw-0.22-1-any.pkg.tar.xz";
    sha256      = "06ab50d8e25944891a5479efd82e4fcefa48078bdca3104f75dc78ef69aef46a";
    buildInputs = [ bzip2 cfitsio exiv2 gtkimageview lcms lensfun ];
  };

  "git-lfs" = fetch {
    name        = "git-lfs";
    version     = "2.2.1";
    filename    = "mingw-w64-x86_64-git-lfs-2.2.1-1-any.pkg.tar.xz";
    sha256      = "0fc40488ea7cbb86f39315c1c26bb0d92ffb07d19ba76108e72e9980e492fd9e";
    buildInputs = [ git ];
    broken      = true;
  };

  "git-repo" = fetch {
    name        = "git-repo";
    version     = "0.4.20";
    filename    = "mingw-w64-x86_64-git-repo-0.4.20-1-any.pkg.tar.xz";
    sha256      = "5f346855c72bed5cc3cbf0947baa67c07a02c14bab7b1999ed26a575615eb8b8";
    buildInputs = [ python3 ];
  };

  "gitg" = fetch {
    name        = "gitg";
    version     = "3.30.1";
    filename    = "mingw-w64-x86_64-gitg-3.30.1-1-any.pkg.tar.xz";
    sha256      = "0aa20321578fc8f5588dd38f192d552430114fe6a6ae513e7900d8770d9949e0";
    buildInputs = [ adwaita-icon-theme gtksourceview3 libpeas enchant iso-codes python3-gobject gsettings-desktop-schemas libsoup libsecret gtkspell3 libgit2-glib libgee ];
  };

  "gl2ps" = fetch {
    name        = "gl2ps";
    version     = "1.4.0";
    filename    = "mingw-w64-x86_64-gl2ps-1.4.0-1-any.pkg.tar.xz";
    sha256      = "22f0c4cb9621613f8940410d9fac707bfe93d9587c6c857048c7618b9f82e4c2";
    buildInputs = [ libpng ];
  };

  "glade" = fetch {
    name        = "glade";
    version     = "3.22.1";
    filename    = "mingw-w64-x86_64-glade-3.22.1-1-any.pkg.tar.xz";
    sha256      = "2a479b0932a949fa466d118037760721bcc8918aa7e3b9bfc7ec135ae932e08e";
    buildInputs = [ gtk3 libxml2 adwaita-icon-theme ];
  };

  "glade3" = fetch {
    name        = "glade3";
    version     = "3.8.6";
    filename    = "mingw-w64-x86_64-glade3-3.8.6-1-any.pkg.tar.xz";
    sha256      = "0774be49b85b1e6dbb1d923306b62130744ce7bbad0d9fed9bbba43bb108e230";
    buildInputs = [ gtk2 libxml2 ];
  };

  "glbinding" = fetch {
    name        = "glbinding";
    version     = "3.0.2";
    filename    = "mingw-w64-x86_64-glbinding-3.0.2-2-any.pkg.tar.xz";
    sha256      = "764e436d12f18dae870250b3eada2bc29bf5afd988a7f7e7636102c80600cbb9";
    buildInputs = [ gcc-libs ];
  };

  "glew" = fetch {
    name        = "glew";
    version     = "2.1.0";
    filename    = "mingw-w64-x86_64-glew-2.1.0-1-any.pkg.tar.xz";
    sha256      = "827cc4ec752b240e31b05f7804ff857fed6cf0fe6c091c43b80def8c376c5631";
    buildInputs = [  ];
  };

  "glfw" = fetch {
    name        = "glfw";
    version     = "3.2.1";
    filename    = "mingw-w64-x86_64-glfw-3.2.1-2-any.pkg.tar.xz";
    sha256      = "4ffbbc359de9306648da7dd1d527a41b0e3ec57ca5cb8b1256e85c9375e7ae29";
    buildInputs = [ gcc-libs ];
  };

  "glib-networking" = fetch {
    name        = "glib-networking";
    version     = "2.58.0";
    filename    = "mingw-w64-x86_64-glib-networking-2.58.0-1-any.pkg.tar.xz";
    sha256      = "70820975898091e004f5136a670f2c94ea4aa5992c807efbf6e1760c3a3335ca";
    buildInputs = [ gcc-libs gettext glib2 gnutls ];
  };

  "glib-openssl" = fetch {
    name        = "glib-openssl";
    version     = "2.50.8";
    filename    = "mingw-w64-x86_64-glib-openssl-2.50.8-2-any.pkg.tar.xz";
    sha256      = "037d80e51d10b53c827fecf2a48f0730777dc64074d9623d5e61a4899becefe0";
    buildInputs = [ glib2 openssl ];
  };

  "glib2" = fetch {
    name        = "glib2";
    version     = "2.58.2";
    filename    = "mingw-w64-x86_64-glib2-2.58.2-1-any.pkg.tar.xz";
    sha256      = "fd8b4da5424eff671dba047f9650b1aea9933427605463c20baeed20475ea5c0";
    buildInputs = [ gcc-libs gettext pcre libffi zlib python3 ];
  };

  "glibmm" = fetch {
    name        = "glibmm";
    version     = "2.58.0";
    filename    = "mingw-w64-x86_64-glibmm-2.58.0-1-any.pkg.tar.xz";
    sha256      = "757950ac6c1334fa3eef3f6a961b8d382d65eb449249f577faa6b7e3cd6da08d";
    buildInputs = [ self."libsigc++" glib2 ];
  };

  "glm" = fetch {
    name        = "glm";
    version     = "0.9.9.3";
    filename    = "mingw-w64-x86_64-glm-0.9.9.3-2-any.pkg.tar.xz";
    sha256      = "ac2d8bba1c44ffb0a3a3ce37aec6a1c490d1c7d0ff6da6bcada9640d61797c28";
    buildInputs = [ gcc-libs ];
  };

  "global" = fetch {
    name        = "global";
    version     = "6.6.2";
    filename    = "mingw-w64-x86_64-global-6.6.2-2-any.pkg.tar.xz";
    sha256      = "a0c519950d57cf229a713c151f888cc1831924f8908578966e51563fa98797c6";
  };

  "globjects" = fetch {
    name        = "globjects";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-globjects-1.1.0-1-any.pkg.tar.xz";
    sha256      = "8444e7eb64ed1d2645d69efbe8384543728a2dcb7dd16492bd05b99a8f9957c1";
    buildInputs = [ gcc-libs glbinding glm ];
  };

  "glog" = fetch {
    name        = "glog";
    version     = "0.3.5";
    filename    = "mingw-w64-x86_64-glog-0.3.5-1-any.pkg.tar.xz";
    sha256      = "eaf48efcaa655a8f90407692ca72d7210dd7ad5f8b36bde1af1f633f5a4eb5bd";
    buildInputs = [ gflags ];
  };

  "glpk" = fetch {
    name        = "glpk";
    version     = "4.65";
    filename    = "mingw-w64-x86_64-glpk-4.65-1-any.pkg.tar.xz";
    sha256      = "d7f2d6b443f3936a5ef367bf776b5b67124cf7cf9538954cc765029dc557bc9e";
    buildInputs = [ gmp ];
  };

  "glsl-optimizer-git" = fetch {
    name        = "glsl-optimizer-git";
    version     = "r66914.9a2852138d";
    filename    = "mingw-w64-x86_64-glsl-optimizer-git-r66914.9a2852138d-1-any.pkg.tar.xz";
    sha256      = "e61622d0cd8682c30deaa1faf85d889f64c95b8f65591f8824dc7f9f69d4881a";
  };

  "glslang" = fetch {
    name        = "glslang";
    version     = "7.10.2984";
    filename    = "mingw-w64-x86_64-glslang-7.10.2984-1-any.pkg.tar.xz";
    sha256      = "a4dc2728141236e3e3c4c570daa4bfcef9a709e78591a43118753c1bdef03a39";
    buildInputs = [ gcc-libs ];
  };

  "gmime" = fetch {
    name        = "gmime";
    version     = "3.2.2";
    filename    = "mingw-w64-x86_64-gmime-3.2.2-1-any.pkg.tar.xz";
    sha256      = "aa9d02ef0575b8c50fceafe6a6608f4027e90640e5af987aefb26a344cc27640";
    buildInputs = [ glib2 libiconv ];
  };

  "gmp" = fetch {
    name        = "gmp";
    version     = "6.1.2";
    filename    = "mingw-w64-x86_64-gmp-6.1.2-1-any.pkg.tar.xz";
    sha256      = "1774fc58c4156e81b2d47e6affa3ef1d4ef3195ce870db3ef1191c64ea34cf1c";
    buildInputs = [  ];
  };

  "gnome-common" = fetch {
    name        = "gnome-common";
    version     = "3.18.0";
    filename    = "mingw-w64-x86_64-gnome-common-3.18.0-1-any.pkg.tar.xz";
    sha256      = "06885b109036840a681921282255c6442b60d9d4b3dd14144644a8b70d62993d";
  };

  "gnome-latex" = fetch {
    name        = "gnome-latex";
    version     = "3.28.1";
    filename    = "mingw-w64-x86_64-gnome-latex-3.28.1-2-any.pkg.tar.xz";
    sha256      = "b284e705830baa07ea5ff7b966981e6a474245bc1b996041c5d3646dc1459b50";
    buildInputs = [ gsettings-desktop-schemas gtk3 gtksourceview4 gspell tepl4 libgee ];
  };

  "gnu-cobol-svn" = fetch {
    name        = "gnu-cobol-svn";
    version     = "2.0.r1454";
    filename    = "mingw-w64-x86_64-gnu-cobol-svn-2.0.r1454-1-any.pkg.tar.xz";
    sha256      = "f1d2aa9dda8164e74c7e5af32e7db8d610d68f347304cd70053df43cee09deaa";
    buildInputs = [ db gmp ncurses ];
  };

  "gnucobol" = fetch {
    name        = "gnucobol";
    version     = "3.0rc1";
    filename    = "mingw-w64-x86_64-gnucobol-3.0rc1-0-any.pkg.tar.xz";
    sha256      = "4f9f24eb5c3e370a7b702d7664f298edb54141e71b3efc44a4a03637a2dec4bd";
    buildInputs = [ gcc gmp gettext ncurses db ];
  };

  "gnupg" = fetch {
    name        = "gnupg";
    version     = "2.2.12";
    filename    = "mingw-w64-x86_64-gnupg-2.2.12-1-any.pkg.tar.xz";
    sha256      = "a3d4dc69146a18c54a357a7a86a78b24b56eee442bdf33086526ea74fefa40f7";
    buildInputs = [ adns bzip2 curl gnutls libksba libgcrypt libassuan libsystre libusb-compat-git npth readline sqlite3 zlib ];
  };

  "gnuplot" = fetch {
    name        = "gnuplot";
    version     = "5.2.5";
    filename    = "mingw-w64-x86_64-gnuplot-5.2.5-1-any.pkg.tar.xz";
    sha256      = "e0a3999ec489eb51890a77827d154db6f0f218cd34a739b3f31d5d895391a098";
    buildInputs = [ cairo gnutls libcaca libcerf libgd pango readline wxWidgets ];
  };

  "gnutls" = fetch {
    name        = "gnutls";
    version     = "3.6.5";
    filename    = "mingw-w64-x86_64-gnutls-3.6.5-1-any.pkg.tar.xz";
    sha256      = "14b4cd4972e7e38d1ee282340c9a7f4e99469092675bcf26f63fd73640cfc1d5";
    buildInputs = [ gcc-libs gmp libidn2 libsystre libtasn1 (assert stdenvNoCC.lib.versionAtLeast nettle.version "3.1"; nettle) (assert stdenvNoCC.lib.versionAtLeast p11-kit.version "0.23.1"; p11-kit) libunistring zlib ];
  };

  "go" = fetch {
    name        = "go";
    version     = "1.11.4";
    filename    = "mingw-w64-x86_64-go-1.11.4-1-any.pkg.tar.xz";
    sha256      = "48c419c806210d2a50d71552b73c1ea435e2ff684c285b45602c1c09e08ce1dd";
  };

  "gobject-introspection" = fetch {
    name        = "gobject-introspection";
    version     = "1.58.2";
    filename    = "mingw-w64-x86_64-gobject-introspection-1.58.2-1-any.pkg.tar.xz";
    sha256      = "b66d789d918ed21d4e7166378dafbf6ac6a86febf8476797903865866f28bd94";
    buildInputs = [ (assert gobject-introspection-runtime.version=="1.58.2"; gobject-introspection-runtime) pkg-config python3 python3-mako ];
  };

  "gobject-introspection-runtime" = fetch {
    name        = "gobject-introspection-runtime";
    version     = "1.58.2";
    filename    = "mingw-w64-x86_64-gobject-introspection-runtime-1.58.2-1-any.pkg.tar.xz";
    sha256      = "3517f245d3296fbe1ad0cd07cc25e4311ed8133b03143027ef5c2c2c1292192e";
    buildInputs = [ glib2 ];
  };

  "goocanvas" = fetch {
    name        = "goocanvas";
    version     = "2.0.4";
    filename    = "mingw-w64-x86_64-goocanvas-2.0.4-1-any.pkg.tar.xz";
    sha256      = "08e6dad4cfcd1d60603ab4acdfba2e85c51b79e9f6a6e3bc6a2e954e642cda51";
    buildInputs = [ gtk3 ];
  };

  "googletest-git" = fetch {
    name        = "googletest-git";
    version     = "r975.aa148eb";
    filename    = "mingw-w64-x86_64-googletest-git-r975.aa148eb-1-any.pkg.tar.xz";
    sha256      = "b7c4d50b9fd4c4dec74f1cc8f671a741aad68b7e5be63ac3b36749bf51289717";
  };

  "gperf" = fetch {
    name        = "gperf";
    version     = "3.1";
    filename    = "mingw-w64-x86_64-gperf-3.1-1-any.pkg.tar.xz";
    sha256      = "33499f19eb175232448a5296c1046179c4157cf82c541d507a731aaf01208f38";
    buildInputs = [ gcc-libs ];
  };

  "gpgme" = fetch {
    name        = "gpgme";
    version     = "1.12.0";
    filename    = "mingw-w64-x86_64-gpgme-1.12.0-1-any.pkg.tar.xz";
    sha256      = "d02bd93b093b5287c4a9c0e7040b256b213df204d8a66963e813af543cd2c41b";
    buildInputs = [ glib2 gnupg libassuan libgpg-error npth ];
  };

  "gphoto2" = fetch {
    name        = "gphoto2";
    version     = "2.5.20";
    filename    = "mingw-w64-x86_64-gphoto2-2.5.20-1-any.pkg.tar.xz";
    sha256      = "81b5209c0eb6a79017ed138f7b229da0f5ae94e3b77a34da985a5db92b9e23ce";
    buildInputs = [ libgphoto2 popt ];
  };

  "gplugin" = fetch {
    name        = "gplugin";
    version     = "0.27.0";
    filename    = "mingw-w64-x86_64-gplugin-0.27.0-1-any.pkg.tar.xz";
    sha256      = "31757c0f2160820fee3797c5d65ccd8c5e67da376acd675b47b0bb28f8a82576";
    buildInputs = [ gtk3 ];
  };

  "gprbuild-bootstrap-git" = fetch {
    name        = "gprbuild-bootstrap-git";
    version     = "r3206.f95f0c68";
    filename    = "mingw-w64-x86_64-gprbuild-bootstrap-git-r3206.f95f0c68-1-any.pkg.tar.xz";
    sha256      = "76943b93651a13be6b644c4d6d197950a5cbe5d1d396e98061dd4dbdd5a85c84";
    buildInputs = [ gcc-libs ];
  };

  "graphene" = fetch {
    name        = "graphene";
    version     = "1.8.2";
    filename    = "mingw-w64-x86_64-graphene-1.8.2-1-any.pkg.tar.xz";
    sha256      = "a8bb90816ffb8f36312a1d95defc69aeb9478f18e7460ba659252f230201efc9";
    buildInputs = [ glib2 ];
  };

  "graphicsmagick" = fetch {
    name        = "graphicsmagick";
    version     = "1.3.31";
    filename    = "mingw-w64-x86_64-graphicsmagick-1.3.31-1-any.pkg.tar.xz";
    sha256      = "9f6374656d2916b1cba981352cd30e237cc3c639f9b0080aa3bd8075ac28fa54";
    buildInputs = [ bzip2 fontconfig freetype gcc-libs glib2 jbigkit lcms2 libtool libwinpthread-git xz zlib ];
  };

  "graphite2" = fetch {
    name        = "graphite2";
    version     = "1.3.13";
    filename    = "mingw-w64-x86_64-graphite2-1.3.13-1-any.pkg.tar.xz";
    sha256      = "7e042d04f7eb8a823d98fbc014544bf2bc9e6785c4f111e22e4352b9f6869569";
    buildInputs = [ gcc-libs ];
  };

  "graphviz" = fetch {
    name        = "graphviz";
    version     = "2.40.1";
    filename    = "mingw-w64-x86_64-graphviz-2.40.1-5-any.pkg.tar.xz";
    sha256      = "a9812195898ebf3679dbb980931f1b4c31b6051c5af1f83aeef3c152a50dcc24";
    buildInputs = [ cairo devil expat freetype glib2 gtk2 gtkglext fontconfig freeglut libglade libgd libpng libsystre libwebp pango poppler zlib libtool ];
  };

  "grpc" = fetch {
    name        = "grpc";
    version     = "1.17.2";
    filename    = "mingw-w64-x86_64-grpc-1.17.2-1-any.pkg.tar.xz";
    sha256      = "c722f98f2ad455829f53573284115a22677d22ddce05574992cb83f348872ecd";
    buildInputs = [ gcc-libs c-ares gflags openssl (assert stdenvNoCC.lib.versionAtLeast protobuf.version "3.5.0"; protobuf) zlib ];
  };

  "gsasl" = fetch {
    name        = "gsasl";
    version     = "1.8.0";
    filename    = "mingw-w64-x86_64-gsasl-1.8.0-4-any.pkg.tar.xz";
    sha256      = "c80d6e062525b98caad0d6de4c17d6204d6101f200cd6c86a731ab9ba7ebb710";
    buildInputs = [ gss gnutls libidn libgcrypt libntlm readline ];
  };

  "gsettings-desktop-schemas" = fetch {
    name        = "gsettings-desktop-schemas";
    version     = "3.28.1";
    filename    = "mingw-w64-x86_64-gsettings-desktop-schemas-3.28.1-1-any.pkg.tar.xz";
    sha256      = "41092f5a1393110d9cbfe9b72b08b771240167e4c42c0c6f8c6b387280d12042";
    buildInputs = [ glib2 ];
  };

  "gsfonts" = fetch {
    name        = "gsfonts";
    version     = "20180524";
    filename    = "mingw-w64-x86_64-gsfonts-20180524-1-any.pkg.tar.xz";
    sha256      = "069b86a6d37102e59832aee670f53baab07829248df85b6a1212f5264e74b24c";
  };

  "gsl" = fetch {
    name        = "gsl";
    version     = "2.5";
    filename    = "mingw-w64-x86_64-gsl-2.5-1-any.pkg.tar.xz";
    sha256      = "27947b7c64d946d2b2c5e16f600baa07f4f45af6cf7838b450368b7715750d15";
    buildInputs = [  ];
  };

  "gsm" = fetch {
    name        = "gsm";
    version     = "1.0.18";
    filename    = "mingw-w64-x86_64-gsm-1.0.18-1-any.pkg.tar.xz";
    sha256      = "bbf60ecba0e7a45caab0cdd73111c097047452f44d5bdf985bf608e88b47f562";
    buildInputs = [  ];
  };

  "gsoap" = fetch {
    name        = "gsoap";
    version     = "2.8.74";
    filename    = "mingw-w64-x86_64-gsoap-2.8.74-1-any.pkg.tar.xz";
    sha256      = "89492306a131af00097e3b825c56d4ab2871bd67e67825cae629b5347f369526";
  };

  "gspell" = fetch {
    name        = "gspell";
    version     = "1.8.1";
    filename    = "mingw-w64-x86_64-gspell-1.8.1-1-any.pkg.tar.xz";
    sha256      = "6182b16f249305310d983abe208a407e456dd72c1c7b9912534fa3305155ed27";
    buildInputs = [ gsettings-desktop-schemas gtk3 gtksourceview3 iso-codes enchant libxml2 ];
  };

  "gss" = fetch {
    name        = "gss";
    version     = "1.0.3";
    filename    = "mingw-w64-x86_64-gss-1.0.3-1-any.pkg.tar.xz";
    sha256      = "21572f451d3d968c1c24e1c445d544a4bf22bbdf0d08e23ac4286bf1ca2fdd8a";
    buildInputs = [ gcc-libs shishi-git ];
  };

  "gst-editing-services" = fetch {
    name        = "gst-editing-services";
    version     = "1.14.4";
    filename    = "mingw-w64-x86_64-gst-editing-services-1.14.4-1-any.pkg.tar.xz";
    sha256      = "bceb0d12f68c2d3c4f70f80e1216d7763c5a487c40d1c1eb5fbcfe19f21b1d09";
    buildInputs = [ gst-plugins-base ];
    broken      = true;
  };

  "gst-libav" = fetch {
    name        = "gst-libav";
    version     = "1.14.4";
    filename    = "mingw-w64-x86_64-gst-libav-1.14.4-1-any.pkg.tar.xz";
    sha256      = "6691c48fa102cc559b7386824927dcb83f73d295398141edfcd3fa4d3f848b46";
    buildInputs = [ gst-plugins-base ];
    broken      = true;
  };

  "gst-plugins-bad" = fetch {
    name        = "gst-plugins-bad";
    version     = "1.14.4";
    filename    = "mingw-w64-x86_64-gst-plugins-bad-1.14.4-3-any.pkg.tar.xz";
    sha256      = "c19a4e6f9a3ef7d61affb1e69ac781d2ad6e20097bf5f16808fefa27b961edd5";
    buildInputs = [ bzip2 cairo chromaprint curl daala-git faad2 faac fdk-aac fluidsynth gsm gst-plugins-base gtk3 ladspa-sdk lcms2 libass libbs2b libdca libdvdnav libdvdread libexif libgme libjpeg libmodplug libmpeg2-git libnice librsvg libsndfile libsrtp libssh2 libwebp libxml2 nettle openal opencv openexr openh264 openjpeg2 openssl opus orc pango rtmpdump-git soundtouch srt vo-amrwbenc x265 zbar ];
    broken      = true;
  };

  "gst-plugins-base" = fetch {
    name        = "gst-plugins-base";
    version     = "1.14.4";
    filename    = "mingw-w64-x86_64-gst-plugins-base-1.14.4-1-any.pkg.tar.xz";
    sha256      = "e630a5e40ab93d3855821d724c623c2415d82babbf9788f1849232046da1f272";
    buildInputs = [ graphene gstreamer libogg libtheora libvorbis libvorbisidec opus orc pango zlib ];
    broken      = true;
  };

  "gst-plugins-good" = fetch {
    name        = "gst-plugins-good";
    version     = "1.14.4";
    filename    = "mingw-w64-x86_64-gst-plugins-good-1.14.4-1-any.pkg.tar.xz";
    sha256      = "499aa6446f77ecd23b7012a6e6f12d30a6ba094e71912352bae4a4b93e86474e";
    buildInputs = [ bzip2 cairo flac gdk-pixbuf2 gst-plugins-base gtk3 lame libcaca libjpeg libpng libshout libsoup libvpx mpg123 speex taglib twolame wavpack zlib ];
    broken      = true;
  };

  "gst-plugins-ugly" = fetch {
    name        = "gst-plugins-ugly";
    version     = "1.14.4";
    filename    = "mingw-w64-x86_64-gst-plugins-ugly-1.14.4-1-any.pkg.tar.xz";
    sha256      = "d3c3538644233135a6daa807860de23728466fb3ce0ba4a31c1ee08514c2eb70";
    buildInputs = [ a52dec gst-plugins-base libcdio libdvdread libmpeg2-git opencore-amr x264-git ];
    broken      = true;
  };

  "gst-python" = fetch {
    name        = "gst-python";
    version     = "1.14.4";
    filename    = "mingw-w64-x86_64-gst-python-1.14.4-1-any.pkg.tar.xz";
    sha256      = "fa195f463e51bbe256033ecc50e5dce56ce49110ce3cd6c65c503f4d5d869471";
    buildInputs = [ gstreamer python3-gobject ];
  };

  "gst-python2" = fetch {
    name        = "gst-python2";
    version     = "1.14.4";
    filename    = "mingw-w64-x86_64-gst-python2-1.14.4-1-any.pkg.tar.xz";
    sha256      = "d3101bc411b2e78fe8fe6bd0318943e5b507ff6fa61ecb5f9abdf7c04de8fc7e";
    buildInputs = [ gstreamer python2-gobject ];
  };

  "gst-rtsp-server" = fetch {
    name        = "gst-rtsp-server";
    version     = "1.14.4";
    filename    = "mingw-w64-x86_64-gst-rtsp-server-1.14.4-1-any.pkg.tar.xz";
    sha256      = "056d02f3829d43887b8bd5afb3ded270ed667586aad6a8bd73b14c9a70838276";
    buildInputs = [ gcc-libs glib2 gettext gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad ];
    broken      = true;
  };

  "gstreamer" = fetch {
    name        = "gstreamer";
    version     = "1.14.4";
    filename    = "mingw-w64-x86_64-gstreamer-1.14.4-1-any.pkg.tar.xz";
    sha256      = "77c09020343b9ba9a815313d02cb2b5aa06f9e84a6e4081368ccf7955076d340";
    buildInputs = [ gcc-libs libxml2 glib2 gettext gmp gsl ];
  };

  "gtef" = fetch {
    name        = "gtef";
    version     = "2.0.1";
    filename    = "mingw-w64-x86_64-gtef-2.0.1-1-any.pkg.tar.xz";
    sha256      = "56ff09fae4fe729ef276b4ab99273f3589b04a1b47a3633b8cb3b1cf5837075e";
    buildInputs = [ glib2 gtk3 gtksourceview3 uchardet libxml2 ];
  };

  "gtest" = fetch {
    name        = "gtest";
    version     = "1.8.1";
    filename    = "mingw-w64-x86_64-gtest-1.8.1-2-any.pkg.tar.xz";
    sha256      = "e234fafe4a45af5e71c2604ff33287d807e6f55e5f2a8ea4fc64b7ce797142ac";
    buildInputs = [ gcc-libs ];
  };

  "gtk-doc" = fetch {
    name        = "gtk-doc";
    version     = "1.29";
    filename    = "mingw-w64-x86_64-gtk-doc-1.29-1-any.pkg.tar.xz";
    sha256      = "7c55e5474e4f2f0a1220b3d70da757c9e8f9728b6f0d217ed6fba80e2ef9fc5d";
    buildInputs = [ docbook-xsl docbook-xml libxslt python3 ];
  };

  "gtk-engine-murrine" = fetch {
    name        = "gtk-engine-murrine";
    version     = "0.98.2";
    filename    = "mingw-w64-x86_64-gtk-engine-murrine-0.98.2-2-any.pkg.tar.xz";
    sha256      = "ab30d2175557ed246dd247487fd9039922333d769a3d2eb0bfb53a9d5777f4f8";
    buildInputs = [ gtk2 ];
  };

  "gtk-engines" = fetch {
    name        = "gtk-engines";
    version     = "2.21.0";
    filename    = "mingw-w64-x86_64-gtk-engines-2.21.0-2-any.pkg.tar.xz";
    sha256      = "296d8067242d7a533770d0900da4e45c6d63fb010784d977d7e7d529b61fda01";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) ];
  };

  "gtk-vnc" = fetch {
    name        = "gtk-vnc";
    version     = "0.9.0";
    filename    = "mingw-w64-x86_64-gtk-vnc-0.9.0-1-any.pkg.tar.xz";
    sha256      = "98896f125b30a39e31d9358c8721d3908b6df0d0021e0fbd9ebc00921cf9d02b";
    buildInputs = [ cyrus-sasl gnutls gtk3 libgcrypt libgpg-error libview zlib ];
  };

  "gtk2" = fetch {
    name        = "gtk2";
    version     = "2.24.32";
    filename    = "mingw-w64-x86_64-gtk2-2.24.32-3-any.pkg.tar.xz";
    sha256      = "fb2a15d96b2ab10196823775eb300eb04a13f6b42ea37e318a74877f265c399c";
    buildInputs = [ gcc-libs adwaita-icon-theme (assert stdenvNoCC.lib.versionAtLeast atk.version "1.29.2"; atk) (assert stdenvNoCC.lib.versionAtLeast cairo.version "1.6"; cairo) (assert stdenvNoCC.lib.versionAtLeast gdk-pixbuf2.version "2.21.0"; gdk-pixbuf2) (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.28.0"; glib2) (assert stdenvNoCC.lib.versionAtLeast pango.version "1.20"; pango) shared-mime-info ];
  };

  "gtk3" = fetch {
    name        = "gtk3";
    version     = "3.24.2";
    filename    = "mingw-w64-x86_64-gtk3-3.24.2-1-any.pkg.tar.xz";
    sha256      = "addb505e87dcab6b76c77b6902c3ffe9280a94a614b827a08bd8aa5813efee5a";
    buildInputs = [ gcc-libs adwaita-icon-theme atk cairo gdk-pixbuf2 glib2 json-glib libepoxy pango shared-mime-info ];
  };

  "gtkglext" = fetch {
    name        = "gtkglext";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-gtkglext-1.2.0-3-any.pkg.tar.xz";
    sha256      = "371d4f0ead1af7a6624759a8b95d56d5f498ddf0f45c3226521ad045189087d4";
    buildInputs = [ gcc-libs gtk2 gdk-pixbuf2 ];
  };

  "gtkimageview" = fetch {
    name        = "gtkimageview";
    version     = "1.6.4";
    filename    = "mingw-w64-x86_64-gtkimageview-1.6.4-3-any.pkg.tar.xz";
    sha256      = "9f3a225d0735560457107520e5e2d96441a525d242a02db4b926a0ad8cdf0c48";
    buildInputs = [ gtk2 ];
  };

  "gtkmm" = fetch {
    name        = "gtkmm";
    version     = "2.24.5";
    filename    = "mingw-w64-x86_64-gtkmm-2.24.5-2-any.pkg.tar.xz";
    sha256      = "9e3f8aa14d60df3494f62a6208b97761a9d0b8b94922964936344bf2c1c3c1b7";
    buildInputs = [ atkmm pangomm gtk2 ];
  };

  "gtkmm3" = fetch {
    name        = "gtkmm3";
    version     = "3.24.0";
    filename    = "mingw-w64-x86_64-gtkmm3-3.24.0-1-any.pkg.tar.xz";
    sha256      = "b61345d35f5c2a6eb50ed7422e5a0973e2de47a030348962a267039c54366960";
    buildInputs = [ gcc-libs atkmm pangomm gtk3 ];
  };

  "gtksourceview2" = fetch {
    name        = "gtksourceview2";
    version     = "2.10.5";
    filename    = "mingw-w64-x86_64-gtksourceview2-2.10.5-3-any.pkg.tar.xz";
    sha256      = "b4bc77c7101252b89927304b91d45a87dfcbdff103bbefb964c692633bc1ae46";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.7"; libxml2) ];
  };

  "gtksourceview3" = fetch {
    name        = "gtksourceview3";
    version     = "3.24.9";
    filename    = "mingw-w64-x86_64-gtksourceview3-3.24.9-1-any.pkg.tar.xz";
    sha256      = "987bf5169851066453f932b5551d462c51f329bfbb4c8eb07d967b320ee3886e";
    buildInputs = [ gtk3 libxml2 ];
  };

  "gtksourceview4" = fetch {
    name        = "gtksourceview4";
    version     = "4.0.3";
    filename    = "mingw-w64-x86_64-gtksourceview4-4.0.3-1-any.pkg.tar.xz";
    sha256      = "f46080626a1b32409b266923164870330f22420ef87cdf4ec61ca25295c78770";
    buildInputs = [ gtk3 libxml2 ];
  };

  "gtksourceviewmm2" = fetch {
    name        = "gtksourceviewmm2";
    version     = "2.10.3";
    filename    = "mingw-w64-x86_64-gtksourceviewmm2-2.10.3-2-any.pkg.tar.xz";
    sha256      = "2294da508d600ba7b869f358271e578952ebf637300cb43c0b8bf6bbb84c3c23";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.7"; libxml2) ];
  };

  "gtksourceviewmm3" = fetch {
    name        = "gtksourceviewmm3";
    version     = "3.21.3";
    filename    = "mingw-w64-x86_64-gtksourceviewmm3-3.21.3-2-any.pkg.tar.xz";
    sha256      = "ffffd3fff21cf81e859f622ec1e0e9d52f2ae8d3bfec70675e8adbe203a65920";
    buildInputs = [ gtksourceview3 gtkmm3 ];
  };

  "gtkspell" = fetch {
    name        = "gtkspell";
    version     = "2.0.16";
    filename    = "mingw-w64-x86_64-gtkspell-2.0.16-7-any.pkg.tar.xz";
    sha256      = "f9933c69bc0fd2a6fd965e163058c8eecc900337dcbd69b689505e3569677e98";
    buildInputs = [ gtk2 enchant ];
  };

  "gtkspell3" = fetch {
    name        = "gtkspell3";
    version     = "3.0.10";
    filename    = "mingw-w64-x86_64-gtkspell3-3.0.10-1-any.pkg.tar.xz";
    sha256      = "83d11844a66eae3d8b265e4260b1e6272d812be9aa7afbaab99c04064993480c";
    buildInputs = [ gtk3 gtk2 enchant ];
  };

  "gtkwave" = fetch {
    name        = "gtkwave";
    version     = "3.3.79";
    filename    = "mingw-w64-x86_64-gtkwave-3.3.79-1-any.pkg.tar.xz";
    sha256      = "e28872c6887c8b3f222c3bd6e0a97590905453e13709289999d18d5c426cea1a";
    buildInputs = [ gtk2 tk tklib tcl tcllib adwaita-icon-theme ];
  };

  "gts" = fetch {
    name        = "gts";
    version     = "0.7.6";
    filename    = "mingw-w64-x86_64-gts-0.7.6-1-any.pkg.tar.xz";
    sha256      = "0190d8cc648a103cd5827d0a305f63eb7eab49a64d6cb2c553d9c4564eff6b6b";
    buildInputs = [ glib2 ];
  };

  "gumbo-parser" = fetch {
    name        = "gumbo-parser";
    version     = "0.10.1";
    filename    = "mingw-w64-x86_64-gumbo-parser-0.10.1-1-any.pkg.tar.xz";
    sha256      = "2ac489432bc54f2ab10980c8efef425bbfb2ac3766116baeb3c846f2c25bce66";
  };

  "gxml" = fetch {
    name        = "gxml";
    version     = "0.16.3";
    filename    = "mingw-w64-x86_64-gxml-0.16.3-1-any.pkg.tar.xz";
    sha256      = "19c70d017ef5ffe32a5981d46eeb07f08801cfb6f400fed8634677cc4d77c822";
    buildInputs = [ gcc-libs gettext (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.34.0"; glib2) libgee libxml2 xz zlib ];
  };

  "harfbuzz" = fetch {
    name        = "harfbuzz";
    version     = "2.2.0";
    filename    = "mingw-w64-x86_64-harfbuzz-2.2.0-1-any.pkg.tar.xz";
    sha256      = "5d6de76cb2bbb0e4be993254f0d3c3489419a3eee0318d75cd2cab4952824e35";
    buildInputs = [ freetype gcc-libs glib2 graphite2 ];
  };

  "hclient-git" = fetch {
    name        = "hclient-git";
    version     = "233.8b17cf3";
    filename    = "mingw-w64-x86_64-hclient-git-233.8b17cf3-1-any.pkg.tar.xz";
    sha256      = "ae7fee886ee5f47eea2cb770314eb5e5827fa994636184ae91cc6c30da083fc4";
  };

  "hdf4" = fetch {
    name        = "hdf4";
    version     = "4.2.14";
    filename    = "mingw-w64-x86_64-hdf4-4.2.14-1-any.pkg.tar.xz";
    sha256      = "4459ea56226cab1f6cbc8a689c20408b2149ac533de002467a0fecfb8ea6f2fd";
    buildInputs = [ libjpeg-turbo gcc-libgfortran zlib ];
  };

  "hdf5" = fetch {
    name        = "hdf5";
    version     = "1.8.21";
    filename    = "mingw-w64-x86_64-hdf5-1.8.21-1-any.pkg.tar.xz";
    sha256      = "e0a049a640bde45caed291be6193a85114d340656f229dfcdf977066bc5aa51a";
    buildInputs = [ gcc-libs gcc-libgfortran szip zlib ];
  };

  "headers-git" = fetch {
    name        = "headers-git";
    version     = "7.0.0.5285.7b2baaf8";
    filename    = "mingw-w64-x86_64-headers-git-7.0.0.5285.7b2baaf8-1-any.pkg.tar.xz";
    sha256      = "ee31a0a3511035f71e4ffc6c7f85439729069dc3661c948bb78b51e6126007b0";
    buildInputs = [  ];
  };

  "hicolor-icon-theme" = fetch {
    name        = "hicolor-icon-theme";
    version     = "0.17";
    filename    = "mingw-w64-x86_64-hicolor-icon-theme-0.17-1-any.pkg.tar.xz";
    sha256      = "6ea5b44d0fd66cd35922c320bdf4c82b8934febfe7e09df93aece0c92b7a0f5d";
    buildInputs = [  ];
  };

  "hidapi" = fetch {
    name        = "hidapi";
    version     = "0.8.0rc1";
    filename    = "mingw-w64-x86_64-hidapi-0.8.0rc1-4-any.pkg.tar.xz";
    sha256      = "d029b5bea00c5e0f7cba415973270f02e8bbba4a3a6f3408db632a4918a38cf6";
    buildInputs = [ gcc-libs ];
  };

  "hlsl2glsl-git" = fetch {
    name        = "hlsl2glsl-git";
    version     = "r848.957cd20";
    filename    = "mingw-w64-x86_64-hlsl2glsl-git-r848.957cd20-1-any.pkg.tar.xz";
    sha256      = "af91039306d54378062b39e9c97d7fedb3673ac8f236b2614e92eefcb88b74b6";
  };

  "http-parser" = fetch {
    name        = "http-parser";
    version     = "2.8.1";
    filename    = "mingw-w64-x86_64-http-parser-2.8.1-1-any.pkg.tar.xz";
    sha256      = "44b24dd5d7c1d819d18f8fdaf340dfa9299b639ab0cff4eaebf66e3ffa1b7ff9";
    buildInputs = [  ];
  };

  "hunspell" = fetch {
    name        = "hunspell";
    version     = "1.7.0";
    filename    = "mingw-w64-x86_64-hunspell-1.7.0-1-any.pkg.tar.xz";
    sha256      = "69a20672d63da445c46a5469aff98e7bd26af21b3d92152c10935b356f538f39";
    buildInputs = [ gcc-libs gettext ncurses readline ];
  };

  "hunspell-en" = fetch {
    name        = "hunspell-en";
    version     = "2018.04.16";
    filename    = "mingw-w64-x86_64-hunspell-en-2018.04.16-1-any.pkg.tar.xz";
    sha256      = "375721c91567f3295a791d07249d730c646ab11ef0fa3292fdd1d9c423f0f199";
  };

  "hyphen" = fetch {
    name        = "hyphen";
    version     = "2.8.8";
    filename    = "mingw-w64-x86_64-hyphen-2.8.8-1-any.pkg.tar.xz";
    sha256      = "224add451abe1d50a1952558f8e7c9ceebc1d198ec5d2aa4f0cda8af28273b50";
  };

  "hyphen-en" = fetch {
    name        = "hyphen-en";
    version     = "2.8.8";
    filename    = "mingw-w64-x86_64-hyphen-en-2.8.8-1-any.pkg.tar.xz";
    sha256      = "fb307dfdc110fd4527dea8b23a8dd482af4a905e41e6a435ad5266a837f92c87";
  };

  "icon-naming-utils" = fetch {
    name        = "icon-naming-utils";
    version     = "0.8.90";
    filename    = "mingw-w64-x86_64-icon-naming-utils-0.8.90-2-any.pkg.tar.xz";
    sha256      = "d8b8038ae4885bfd7e86f2988d60e1bbf9b7c0505217c30dff80ab4ab558c04c";
    buildInputs = [ perl-XML-Simple ];
    broken      = true;
  };

  "iconv" = fetch {
    name        = "iconv";
    version     = "1.15";
    filename    = "mingw-w64-x86_64-iconv-1.15-3-any.pkg.tar.xz";
    sha256      = "edbbac20bffe44c1d5b6cf4c5527581e3a36200151c30b52a57bcbd511ad0620";
    buildInputs = [ (assert libiconv.version=="1.15"; libiconv) gettext ];
  };

  "icoutils" = fetch {
    name        = "icoutils";
    version     = "0.32.3";
    filename    = "mingw-w64-x86_64-icoutils-0.32.3-1-any.pkg.tar.xz";
    sha256      = "914d1848cd92012fd061f70ada6f58f779b740dabdc8ee3c23c73dd7decead81";
    buildInputs = [ libpng ];
  };

  "icu" = fetch {
    name        = "icu";
    version     = "62.1";
    filename    = "mingw-w64-x86_64-icu-62.1-1-any.pkg.tar.xz";
    sha256      = "3f2b5cb76da608c4fa1039b6a8a26e63956dfa4b28bd81942814dd492a53e9ae";
    buildInputs = [ gcc-libs ];
  };

  "icu-debug-libs" = fetch {
    name        = "icu-debug-libs";
    version     = "62.1";
    filename    = "mingw-w64-x86_64-icu-debug-libs-62.1-1-any.pkg.tar.xz";
    sha256      = "da593c5d38a6c2fd68723de2ec92e1d85f73759cb079b1a2536cee63824cd8c9";
    buildInputs = [ gcc-libs ];
  };

  "id3lib" = fetch {
    name        = "id3lib";
    version     = "3.8.3";
    filename    = "mingw-w64-x86_64-id3lib-3.8.3-2-any.pkg.tar.xz";
    sha256      = "a0a625c404d2084f6cb1112daef828b6487d171e0f5dc0acc4d6e93ef8d8192f";
    buildInputs = [ gcc-libs zlib ];
  };

  "ilmbase" = fetch {
    name        = "ilmbase";
    version     = "2.3.0";
    filename    = "mingw-w64-x86_64-ilmbase-2.3.0-1-any.pkg.tar.xz";
    sha256      = "bd50b73c3efaba06b41b7d43f358702597968e4cb5615000fd84462c1968c307";
    buildInputs = [ gcc-libs ];
  };

  "imagemagick" = fetch {
    name        = "imagemagick";
    version     = "7.0.8.14";
    filename    = "mingw-w64-x86_64-imagemagick-7.0.8.14-1-any.pkg.tar.xz";
    sha256      = "6340bd5ac76ab38a688f092f246d578084ada8bf730515f2c7c2689a20bd6514";
    buildInputs = [ bzip2 djvulibre flif fftw fontconfig freetype glib2 gsfonts jasper jbigkit lcms2 liblqr libpng libraqm libtiff libtool libwebp libxml2 openjpeg2 ttf-dejavu xz zlib ];
    broken      = true;
  };

  "indent" = fetch {
    name        = "indent";
    version     = "2.2.12";
    filename    = "mingw-w64-x86_64-indent-2.2.12-1-any.pkg.tar.xz";
    sha256      = "64ddd55810cac85bf0cd80971a41075bab366d3f3e4bfb557bb78bfb88ccfd21";
  };

  "inkscape" = fetch {
    name        = "inkscape";
    version     = "0.92.3";
    filename    = "mingw-w64-x86_64-inkscape-0.92.3-7-any.pkg.tar.xz";
    sha256      = "f81edb517bfa22e2629b0b742b13ffafe3a3df7d2558580f53c1669a1b591675";
    buildInputs = [ aspell gc ghostscript gsl gtkmm gtkspell hicolor-icon-theme imagemagick lcms2 libcdr libvisio libxml2 libxslt libwpg poppler popt potrace python2 ];
    broken      = true;
  };

  "innoextract" = fetch {
    name        = "innoextract";
    version     = "1.7";
    filename    = "mingw-w64-x86_64-innoextract-1.7-1-any.pkg.tar.xz";
    sha256      = "0aca2ef0a1b40220b7d690f1fcba3d58ed679f5a75d9d1994a4f0898d1501799";
    buildInputs = [ gcc-libs boost bzip2 libiconv xz zlib ];
  };

  "intel-tbb" = fetch {
    name        = "intel-tbb";
    version     = "1~2019_20181003";
    filename    = "mingw-w64-x86_64-intel-tbb-1~2019_20181003-1-any.pkg.tar.xz";
    sha256      = "03e699084fdb58f939fdd8a4bd7aaa93a0df2fb4a591d61fa852cf854a7779cb";
    buildInputs = [ gcc-libs ];
  };

  "irrlicht" = fetch {
    name        = "irrlicht";
    version     = "1.8.4";
    filename    = "mingw-w64-x86_64-irrlicht-1.8.4-1-any.pkg.tar.xz";
    sha256      = "33c88bbde67fec96cb57f86d4ba6f36845335f07b12d2ff781a8ef7f4272aaac";
    buildInputs = [ gcc-libs ];
  };

  "isl" = fetch {
    name        = "isl";
    version     = "0.19";
    filename    = "mingw-w64-x86_64-isl-0.19-1-any.pkg.tar.xz";
    sha256      = "103d68bf6741384abeac815f30d556c189fdf707bba1266b25ad62072d29fdf1";
    buildInputs = [  ];
  };

  "iso-codes" = fetch {
    name        = "iso-codes";
    version     = "4.1";
    filename    = "mingw-w64-x86_64-iso-codes-4.1-1-any.pkg.tar.xz";
    sha256      = "7c54ae6afcd30fe61392168cef6a78ca03d97ba5d59b796567294fe5f69af92c";
    buildInputs = [  ];
  };

  "itk" = fetch {
    name        = "itk";
    version     = "4.13.1";
    filename    = "mingw-w64-x86_64-itk-4.13.1-1-any.pkg.tar.xz";
    sha256      = "ec84a246ee75d7f2a1d12e4b3a073cef38ac32fba117df4294ba9691342569a4";
    buildInputs = [ gcc-libs expat fftw gdcm hdf5 libjpeg libpng libtiff zlib ];
  };

  "jansson" = fetch {
    name        = "jansson";
    version     = "2.12";
    filename    = "mingw-w64-x86_64-jansson-2.12-1-any.pkg.tar.xz";
    sha256      = "8c1dd91d9802bbda2d139d9b7d3c36c7157adcd1948c34c058683c373ca06a8c";
    buildInputs = [  ];
  };

  "jasper" = fetch {
    name        = "jasper";
    version     = "2.0.14";
    filename    = "mingw-w64-x86_64-jasper-2.0.14-1-any.pkg.tar.xz";
    sha256      = "eb61edc9a95e66811b567e5315c84bd1e90eafb5d3d04b869c6a7b7c8876e2e1";
    buildInputs = [ freeglut libjpeg-turbo ];
  };

  "jbigkit" = fetch {
    name        = "jbigkit";
    version     = "2.1";
    filename    = "mingw-w64-x86_64-jbigkit-2.1-4-any.pkg.tar.xz";
    sha256      = "403eb150573e92b784f33c50495b5b962077d8103efae47b252321dbbd113bba";
    buildInputs = [ gcc-libs ];
  };

  "jemalloc" = fetch {
    name        = "jemalloc";
    version     = "5.1.0";
    filename    = "mingw-w64-x86_64-jemalloc-5.1.0-3-any.pkg.tar.xz";
    sha256      = "01ddf2b32ae97f6bae301e3da88f93ade40894c9520c155aeb797d4d06d6c9a3";
    buildInputs = [ gcc-libs ];
  };

  "jpegoptim" = fetch {
    name        = "jpegoptim";
    version     = "1.4.6";
    filename    = "mingw-w64-x86_64-jpegoptim-1.4.6-1-any.pkg.tar.xz";
    sha256      = "646a1c76044af32c6f430e8b9014848c6fd822f03ade312b128391bfc10d7466";
    buildInputs = [ libjpeg-turbo ];
  };

  "jq" = fetch {
    name        = "jq";
    version     = "1.6";
    filename    = "mingw-w64-x86_64-jq-1.6-1-any.pkg.tar.xz";
    sha256      = "85e3c425da4a5f1bea1a683666f4eeee10eaf8ccf9d550009817661d0695c199";
    buildInputs = [ oniguruma ];
  };

  "json-c" = fetch {
    name        = "json-c";
    version     = "0.13.1_20180305";
    filename    = "mingw-w64-x86_64-json-c-0.13.1_20180305-1-any.pkg.tar.xz";
    sha256      = "b82cff19300b4751a9015e68d831c0ed27ece5e5766826e64ceb59246c67bcf6";
    buildInputs = [  ];
  };

  "json-glib" = fetch {
    name        = "json-glib";
    version     = "1.4.4";
    filename    = "mingw-w64-x86_64-json-glib-1.4.4-1-any.pkg.tar.xz";
    sha256      = "d3610c06e2a4fd0c24bf7927d3ec22b1efda6cf005c4cb3eae6dd8639a5e8d7b";
    buildInputs = [ glib2 ];
  };

  "jsoncpp" = fetch {
    name        = "jsoncpp";
    version     = "1.8.4";
    filename    = "mingw-w64-x86_64-jsoncpp-1.8.4-3-any.pkg.tar.xz";
    sha256      = "11b5edcd1fdb41f2a9bd3150ebb5e8b6ebdf6c2b38179a0aee62083b5f1cf643";
    buildInputs = [  ];
  };

  "jsonrpc-glib" = fetch {
    name        = "jsonrpc-glib";
    version     = "3.30.1";
    filename    = "mingw-w64-x86_64-jsonrpc-glib-3.30.1-1-any.pkg.tar.xz";
    sha256      = "8386062f894f9dbae63c04260ffb36d3b04cd5b5952b3b94967989991f9516bb";
    buildInputs = [ glib2 json-glib ];
  };

  "jxrlib" = fetch {
    name        = "jxrlib";
    version     = "1.1";
    filename    = "mingw-w64-x86_64-jxrlib-1.1-3-any.pkg.tar.xz";
    sha256      = "cd041d6aa36e7235e01a6a26a2d228da7c8963c27664dbe55b5bebcfbb1bf03b";
    buildInputs = [ gcc-libs ];
  };

  "kactivities-qt5" = fetch {
    name        = "kactivities-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kactivities-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "9824074cc656ba408ba8a1f756d0ac13ea1cd75a85d1c85bc6c21ff3c29d26b0";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.50.0"; kwindowsystem-qt5) ];
    broken      = true;
  };

  "karchive-qt5" = fetch {
    name        = "karchive-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-karchive-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "d2b77c9e63503d3152728c70ea1cf14082a3a0e64db5433034be2aea6eeddce0";
    buildInputs = [ zlib bzip2 xz qt5 ];
    broken      = true;
  };

  "kate" = fetch {
    name        = "kate";
    version     = "18.08.1";
    filename    = "mingw-w64-x86_64-kate-18.08.1-2-any.pkg.tar.xz";
    sha256      = "fd6f75d4ce20138897743390948131a583223fde9579bdd4b096d12278e5cc45";
    buildInputs = [ knewstuff-qt5 ktexteditor-qt5 threadweaver-qt5 kitemmodels-qt5 kactivities-qt5 plasma-framework-qt5 hicolor-icon-theme ];
    broken      = true;
  };

  "kauth-qt5" = fetch {
    name        = "kauth-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kauth-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "b8f74c9c0253177b9272496c2abc42df1522e5583244251a43388ed3b85b906c";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) ];
    broken      = true;
  };

  "kbookmarks-qt5" = fetch {
    name        = "kbookmarks-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kbookmarks-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "4a39eb2125f55027fecce54bf1c0f699a03e5ccf76d97207ed960d0d4d69c67e";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kxmlgui-qt5.version "5.50.0"; kxmlgui-qt5) ];
    broken      = true;
  };

  "kcmutils-qt5" = fetch {
    name        = "kcmutils-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kcmutils-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "62afbabdd6864f989ddebb16d60046cda2827d937220e3757dc4c6faf6986513";
    buildInputs = [ kdeclarative-qt5 qt5 ];
    broken      = true;
  };

  "kcodecs-qt5" = fetch {
    name        = "kcodecs-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kcodecs-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "5beeceacdfd867a6fc44d2bd62df509e744607744a108e089f2e5cfc20fa10d2";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kcompletion-qt5" = fetch {
    name        = "kcompletion-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kcompletion-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "71f79491898da54ef48595e7b7a6359a720fdfb4c8fbe33bbb24349fb29a8f40";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.50.0"; kwidgetsaddons-qt5) ];
    broken      = true;
  };

  "kconfig-qt5" = fetch {
    name        = "kconfig-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kconfig-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "f6ed87a0088b1ee4ef8532d8b11ae739b5332877546d338f3380e275323c5ad5";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kconfigwidgets-qt5" = fetch {
    name        = "kconfigwidgets-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kconfigwidgets-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "ed4c0c70009e48e308d84610c57abc29d0721f751c038895b87e9fb5bcc1cfd2";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kauth-qt5.version "5.50.0"; kauth-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kcodecs-qt5.version "5.50.0"; kcodecs-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kguiaddons-qt5.version "5.50.0"; kguiaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.50.0"; kwidgetsaddons-qt5) ];
    broken      = true;
  };

  "kcoreaddons-qt5" = fetch {
    name        = "kcoreaddons-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kcoreaddons-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "26c3b3836ad10853245a9a7ef2001c8918961fde0d7c7b36c53b06c6946fd88d";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kcrash-qt5" = fetch {
    name        = "kcrash-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kcrash-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "61da03be82ff2ae3244f82b46d67862ebe16565b612c4f2b9bb3a507c8989930";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.50.0"; kwindowsystem-qt5) ];
    broken      = true;
  };

  "kdbusaddons-qt5" = fetch {
    name        = "kdbusaddons-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kdbusaddons-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "0a948bb5de306e700650a1159e882862d98417c9cd986751051aa8e419a5d044";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kdeclarative-qt5" = fetch {
    name        = "kdeclarative-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kdeclarative-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "86f671132765b71e2e2d6cad19c19dcfa80e564ac9b478b6c3e5d9c621c1949d";
    buildInputs = [ qt5 kio-qt5 kpackage-qt5 libepoxy ];
    broken      = true;
  };

  "kdewebkit-qt5" = fetch {
    name        = "kdewebkit-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kdewebkit-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "afe298f17f858bd0e63bffc3da388dbcbff654c4fbe1b5a032124cafbaa96b4f";
    buildInputs = [ kparts-qt5 qtwebkit ];
    broken      = true;
  };

  "kdnssd-qt5" = fetch {
    name        = "kdnssd-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kdnssd-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "8d37dec27022fd1ed3a298df802965d78f61ca50841368f4709b9e8b1a3a7180";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kdoctools-qt5" = fetch {
    name        = "kdoctools-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kdoctools-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "5bcb289c9a329c85e9f96c76d91f66b31b4f5a135afa4b6dfc00e27b1c4b0324";
    buildInputs = [ qt5 libxslt docbook-xsl (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.50.0"; karchive-qt5) ];
    broken      = true;
  };

  "kfilemetadata-qt5" = fetch {
    name        = "kfilemetadata-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kfilemetadata-qt5-5.50.0-4-any.pkg.tar.xz";
    sha256      = "ce4f49cf9f3c630d8971203cf9e88013e8b8728b7d8cbce3c48851de75bd8fbb";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.50.0"; karchive-qt5) exiv2 poppler taglib ffmpeg ];
    broken      = true;
  };

  "kglobalaccel-qt5" = fetch {
    name        = "kglobalaccel-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kglobalaccel-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "90e3e4d33be2791664253431fcf7fd6b04f100b753ad5ab907b79ccf3086ae25";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcrash-qt5.version "5.50.0"; kcrash-qt5) (assert stdenvNoCC.lib.versionAtLeast kdbusaddons-qt5.version "5.50.0"; kdbusaddons-qt5) ];
    broken      = true;
  };

  "kguiaddons-qt5" = fetch {
    name        = "kguiaddons-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kguiaddons-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "4a250da762388ee06f2c32f13183af138ef2b0dfd4905cad591f06a922887fad";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kholidays-qt5" = fetch {
    name        = "kholidays-qt5";
    version     = "1~5.50.0";
    filename    = "mingw-w64-x86_64-kholidays-qt5-1~5.50.0-1-any.pkg.tar.xz";
    sha256      = "e4e91cf06ca48b435bd5c9c472836a621512453b2ea08a3aa22cacec0067cbd8";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "ki18n-qt5" = fetch {
    name        = "ki18n-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-ki18n-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "4a47e30161a3cb17534bdcce36301752c22e4ff3035fc7ac332bbe16daa63157";
    buildInputs = [ gettext qt5 ];
    broken      = true;
  };

  "kicad" = fetch {
    name        = "kicad";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-5.0.2-1-any.pkg.tar.xz";
    sha256      = "6ec5fdd06095e1cd528ae63408e4edd51bf25f7f9b3c84ba8516d29e368e775f";
    buildInputs = [ boost cairo curl glew ngspice oce openssl wxPython wxWidgets ];
  };

  "kicad-doc-ca" = fetch {
    name        = "kicad-doc-ca";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-ca-5.0.2-1-any.pkg.tar.xz";
    sha256      = "e7cb33de95cf08bb1b0eea5e2d7021e4a574d493df4cacab77942d506373b477";
  };

  "kicad-doc-de" = fetch {
    name        = "kicad-doc-de";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-de-5.0.2-1-any.pkg.tar.xz";
    sha256      = "e924c53bbbd9cc40e0a573a6f598723a63184992b7dce25ea3334d515d7b42a4";
  };

  "kicad-doc-en" = fetch {
    name        = "kicad-doc-en";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-en-5.0.2-1-any.pkg.tar.xz";
    sha256      = "b30b426d3dd6e38a71cd6391ea43f0708f8899b64e067fbb303a0ded5a28ebe4";
  };

  "kicad-doc-es" = fetch {
    name        = "kicad-doc-es";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-es-5.0.2-1-any.pkg.tar.xz";
    sha256      = "d57aa0e8ee51a7df6f39d09340974a9e02ef2d6386d088892be09d964e937704";
  };

  "kicad-doc-fr" = fetch {
    name        = "kicad-doc-fr";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-fr-5.0.2-1-any.pkg.tar.xz";
    sha256      = "2a259da6f5af512d1aa9f9b41082c9626c3a03d7303493f6821052760bcf7b93";
  };

  "kicad-doc-id" = fetch {
    name        = "kicad-doc-id";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-id-5.0.2-1-any.pkg.tar.xz";
    sha256      = "c04b1d49f0b161b8b749bb033dcdeb968920d80e5a04d13ca2c982122bc4ac07";
  };

  "kicad-doc-it" = fetch {
    name        = "kicad-doc-it";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-it-5.0.2-1-any.pkg.tar.xz";
    sha256      = "cf5766b2eecbc2ad10897ecd1b72769158b6011083e0c055a6644e2a504f121f";
  };

  "kicad-doc-ja" = fetch {
    name        = "kicad-doc-ja";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-ja-5.0.2-1-any.pkg.tar.xz";
    sha256      = "fedf15172f9b290592996a525cf86d6dda8a0b1212e458a50150608383160e1a";
  };

  "kicad-doc-nl" = fetch {
    name        = "kicad-doc-nl";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-nl-5.0.2-1-any.pkg.tar.xz";
    sha256      = "6451e8ff72066d26739ee7db2591d33917d48f74b7672ba33c19562908e4bd8e";
  };

  "kicad-doc-pl" = fetch {
    name        = "kicad-doc-pl";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-pl-5.0.2-1-any.pkg.tar.xz";
    sha256      = "cd49c9f33dc692c08297fd048deed11b7e9f3ee79a99847ba35fa3e79bf3c302";
  };

  "kicad-doc-ru" = fetch {
    name        = "kicad-doc-ru";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-ru-5.0.2-1-any.pkg.tar.xz";
    sha256      = "4b2100dc121b7128af6a6b72fd8419f4a34837ebac3ca481f7bc3d37f7b9c694";
  };

  "kicad-doc-zh" = fetch {
    name        = "kicad-doc-zh";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-doc-zh-5.0.2-1-any.pkg.tar.xz";
    sha256      = "cbaf9a6a5d22c3389ed3e3503d9a03b144068f97f240eff7a3a9da6b458cbbc7";
  };

  "kicad-footprints" = fetch {
    name        = "kicad-footprints";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-footprints-5.0.2-1-any.pkg.tar.xz";
    sha256      = "e60f0b8f435b030b72ae03017f8fa7a6d3bd04e23bc8757e958f36f5e196a02d";
  };

  "kicad-meta" = fetch {
    name        = "kicad-meta";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-meta-5.0.2-1-any.pkg.tar.xz";
    sha256      = "96cbc08f60fb6eeef72a8fea43de247463e3e367c0973307ac98b7a236f0c060";
    buildInputs = [ kicad kicad-footprints kicad-symbols kicad-templates kicad-packages3D ];
  };

  "kicad-packages3D" = fetch {
    name        = "kicad-packages3D";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-packages3D-5.0.2-1-any.pkg.tar.xz";
    sha256      = "e5ae957cf40e001c4eac76128ec5781fe43125d2d043e03489b73450a0e7f242";
    buildInputs = [  ];
  };

  "kicad-symbols" = fetch {
    name        = "kicad-symbols";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-symbols-5.0.2-1-any.pkg.tar.xz";
    sha256      = "54c94221512fa7d9f62b630995ef3ac57047862b4e444ebefd48427fa91775f6";
    buildInputs = [  ];
  };

  "kicad-templates" = fetch {
    name        = "kicad-templates";
    version     = "5.0.2";
    filename    = "mingw-w64-x86_64-kicad-templates-5.0.2-1-any.pkg.tar.xz";
    sha256      = "967d8f15e9d6627373fe41d56a060b9281f1142c6bff54ab3d7a29c0cbca834b";
    buildInputs = [  ];
  };

  "kiconthemes-qt5" = fetch {
    name        = "kiconthemes-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kiconthemes-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "e0d07d734e58ddfea4efa23de5dcc252e2348e77b4920d677d366642028ae08e";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfigwidgets-qt5.version "5.50.0"; kconfigwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast kitemviews-qt5.version "5.50.0"; kitemviews-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.50.0"; karchive-qt5) ];
    broken      = true;
  };

  "kidletime-qt5" = fetch {
    name        = "kidletime-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kidletime-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "cf1c24133de2215638238eff074b8e43ffcc60ab0ef58864f3d27e9f565a8f66";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kimageformats-qt5" = fetch {
    name        = "kimageformats-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kimageformats-qt5-5.50.0-3-any.pkg.tar.xz";
    sha256      = "28b0a012e4ef383eb69393e4ea105fc825ed29ceabe116529f4fe07d17e0cc56";
    buildInputs = [ qt5 openexr (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.50.0"; karchive-qt5) ];
    broken      = true;
  };

  "kinit-qt5" = fetch {
    name        = "kinit-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kinit-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "63e56c255240a7392354f459208b94e1a7df237239ad493a9aebc4cc9002c7c6";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.50.0"; kio-qt5) ];
    broken      = true;
  };

  "kio-qt5" = fetch {
    name        = "kio-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kio-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "b9115f1dcc7c5e77d0b2cec0cc3e840192e94a443caa79ed412a62f40b4a4e0b";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast solid-qt5.version "5.50.0"; solid-qt5) (assert stdenvNoCC.lib.versionAtLeast kjobwidgets-qt5.version "5.50.0"; kjobwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast kbookmarks-qt5.version "5.50.0"; kbookmarks-qt5) (assert stdenvNoCC.lib.versionAtLeast kwallet-qt5.version "5.50.0"; kwallet-qt5) libxslt ];
    broken      = true;
  };

  "kirigami2-qt5" = fetch {
    name        = "kirigami2-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kirigami2-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "62f0fb9cebc4983af08446b2f3edb12bf2e6493dea5c451aa54729c4903d42bc";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kiss_fft" = fetch {
    name        = "kiss_fft";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-kiss_fft-1.3.0-2-any.pkg.tar.xz";
    sha256      = "c9dfbc91df9d7e1697e855a028f0827a9270e623a4f3538a2dc997bc2432261b";
  };

  "kitemmodels-qt5" = fetch {
    name        = "kitemmodels-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kitemmodels-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "428fb71507c9de0f42c8260e2ef9efa7ed573ae6554ae17412f32eda542d03a1";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kitemviews-qt5" = fetch {
    name        = "kitemviews-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kitemviews-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "a0c38aaeb0a9953772092634f589f7d4cdc085cd42e4b0d02ac01dd9e05aa7f0";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kjobwidgets-qt5" = fetch {
    name        = "kjobwidgets-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kjobwidgets-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "81ad6883c0f2ee9087406152219be59ba1e7b81b51b61a2a93ef6c01d52ecc5e";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.50.0"; kwidgetsaddons-qt5) ];
    broken      = true;
  };

  "kjs-qt5" = fetch {
    name        = "kjs-qt5";
    version     = "5.42.0";
    filename    = "mingw-w64-x86_64-kjs-qt5-5.42.0-1-any.pkg.tar.xz";
    sha256      = "1e32db6056ce5c8d170c1bb33e06c74bec139d71c42e56cd11d678b7d3924476";
    buildInputs = [ qt5 bzip2 pcre (assert stdenvNoCC.lib.versionAtLeast kdoctools-qt5.version "5.42.0"; kdoctools-qt5) ];
    broken      = true;
  };

  "knewstuff-qt5" = fetch {
    name        = "knewstuff-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-knewstuff-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "eec5da591ec2f0914533141057f6607881da51e4b7b3005b8fa81318580c45e0";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.50.0"; kio-qt5) ];
    broken      = true;
  };

  "knotifications-qt5" = fetch {
    name        = "knotifications-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-knotifications-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "bb7d06ecf43b52143aa82c33c069df981d0584ed0f9c37b76637ca8271a2c396";
    buildInputs = [ qt5 phonon-qt5 (assert stdenvNoCC.lib.versionAtLeast kcodecs-qt5.version "5.50.0"; kcodecs-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.50.0"; kwindowsystem-qt5) ];
    broken      = true;
  };

  "kpackage-qt5" = fetch {
    name        = "kpackage-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kpackage-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "90b5e6e0f8793e02b21e209de25c37dceb87e1a5fb94e3ec0a28403951ec3cb2";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.50.0"; karchive-qt5) (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.50.0"; kcoreaddons-qt5) ];
    broken      = true;
  };

  "kparts-qt5" = fetch {
    name        = "kparts-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kparts-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "452e9d2f5c791eacb31ad5165dfae20e92998e7367ad464206cabccd0da74ebb";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.50.0"; kio-qt5) ];
    broken      = true;
  };

  "kplotting-qt5" = fetch {
    name        = "kplotting-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kplotting-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "56e250cdc06e3d050f4588e33903d239d941b3ee257ba87ef77552f6c20c3455";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kqoauth-qt4" = fetch {
    name        = "kqoauth-qt4";
    version     = "0.98";
    filename    = "mingw-w64-x86_64-kqoauth-qt4-0.98-3-any.pkg.tar.xz";
    sha256      = "ac0f8690535326aaac546651f2794d315704701f3e2b2d44361208a863979e6b";
    buildInputs = [ qt4 ];
  };

  "kservice-qt5" = fetch {
    name        = "kservice-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kservice-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "fdf314d754b0c2f207a4eaa7084f3bfa842a33fe3f5c41f0945323f7bcb96406";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.50.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcrash-qt5.version "5.50.0"; kcrash-qt5) (assert stdenvNoCC.lib.versionAtLeast kdbusaddons-qt5.version "5.50.0"; kdbusaddons-qt5) ];
    broken      = true;
  };

  "ktexteditor-qt5" = fetch {
    name        = "ktexteditor-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-ktexteditor-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "657a4fccd37fd3496664aabc1938b8af692a4b3c122dcc4ff238ca334d66c69b";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kparts-qt5.version "5.50.0"; kparts-qt5) (assert stdenvNoCC.lib.versionAtLeast syntax-highlighting-qt5.version "5.50.0"; syntax-highlighting-qt5) libgit2 editorconfig-core-c ];
    broken      = true;
  };

  "ktextwidgets-qt5" = fetch {
    name        = "ktextwidgets-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-ktextwidgets-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "d03f5b5976f7b9e8039c99e2315a249291fea7660cddb7a4771c822a423d73c8";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcompletion-qt5.version "5.50.0"; kcompletion-qt5) (assert stdenvNoCC.lib.versionAtLeast kservice-qt5.version "5.50.0"; kservice-qt5) (assert stdenvNoCC.lib.versionAtLeast kiconthemes-qt5.version "5.50.0"; kiconthemes-qt5) (assert stdenvNoCC.lib.versionAtLeast sonnet-qt5.version "5.50.0"; sonnet-qt5) ];
    broken      = true;
  };

  "kunitconversion-qt5" = fetch {
    name        = "kunitconversion-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kunitconversion-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "e5ad117027f35a2d285bca5979efd9e750f890f8c4f3fbd540c64044ca737820";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.50.0"; ki18n-qt5) ];
    broken      = true;
  };

  "kvazaar" = fetch {
    name        = "kvazaar";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-kvazaar-1.2.0-1-any.pkg.tar.xz";
    sha256      = "d656407af25011d846e6fc97c3d91bb4c7c8f1de11c15150acf8d07a319c020d";
    buildInputs = [ gcc-libs self."crypto++" ];
  };

  "kwallet-qt5" = fetch {
    name        = "kwallet-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kwallet-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "38752c816cbb8ceb2fdce01151c13412ed68105c69aadbb916345f7ee2a98d9c";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast knotifications-qt5.version "5.50.0"; knotifications-qt5) (assert stdenvNoCC.lib.versionAtLeast kiconthemes-qt5.version "5.50.0"; kiconthemes-qt5) (assert stdenvNoCC.lib.versionAtLeast kservice-qt5.version "5.50.0"; kservice-qt5) gpgme ];
    broken      = true;
  };

  "kwidgetsaddons-qt5" = fetch {
    name        = "kwidgetsaddons-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kwidgetsaddons-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "da97d4eab56b314f0a286295da23159f3d5ee674e07050321891d3f75e6ca1f2";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kwindowsystem-qt5" = fetch {
    name        = "kwindowsystem-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kwindowsystem-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "a4ba21b387e665c6945ee016d4cbca7b0bb23dc2c6e2bbd4d82fd1481aabe0b0";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "kwrite" = fetch {
    name        = "kwrite";
    version     = "18.08.1";
    filename    = "mingw-w64-x86_64-kwrite-18.08.1-1-any.pkg.tar.xz";
    sha256      = "407a8327b16b666b1f2d021a4af38b923bad3ba9226b12b43216a073786ff887";
    buildInputs = [ ktexteditor-qt5 kactivities-qt5 hicolor-icon-theme ];
    broken      = true;
  };

  "kxmlgui-qt5" = fetch {
    name        = "kxmlgui-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-kxmlgui-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "4f26604bce61419a5f62957b5a97bf15f253ca77bef1ad4421b42e5b1c5846c6";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kglobalaccel-qt5.version "5.50.0"; kglobalaccel-qt5) (assert stdenvNoCC.lib.versionAtLeast ktextwidgets-qt5.version "5.50.0"; ktextwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast attica-qt5.version "5.50.0"; attica-qt5) ];
    broken      = true;
  };

  "l-smash" = fetch {
    name        = "l-smash";
    version     = "2.14.5";
    filename    = "mingw-w64-x86_64-l-smash-2.14.5-1-any.pkg.tar.xz";
    sha256      = "517bf61aa9aa5806e021d3a0c93082b53a70600e546c81c4c54b7c0076f19ed3";
  };

  "ladspa-sdk" = fetch {
    name        = "ladspa-sdk";
    version     = "1.13";
    filename    = "mingw-w64-x86_64-ladspa-sdk-1.13-2-any.pkg.tar.xz";
    sha256      = "16ec3d3a5ecfbfcc4b60bd636e5d6e5bceb96f18439de1a4a7944c1853fcc394";
  };

  "lame" = fetch {
    name        = "lame";
    version     = "3.100";
    filename    = "mingw-w64-x86_64-lame-3.100-1-any.pkg.tar.xz";
    sha256      = "57cc1e269e5228715b0f0686b63006b1f92fc80b51f4aba5382e6abf94606fc4";
    buildInputs = [ libiconv ];
  };

  "lapack" = fetch {
    name        = "lapack";
    version     = "3.8.0";
    filename    = "mingw-w64-x86_64-lapack-3.8.0-3-any.pkg.tar.xz";
    sha256      = "afe685866cf37cf1cb37529b0b36ba185bd76a61c35fc1b182d8a83471eeba59";
    buildInputs = [ gcc-libs gcc-libgfortran ];
  };

  "lasem" = fetch {
    name        = "lasem";
    version     = "0.4.3";
    filename    = "mingw-w64-x86_64-lasem-0.4.3-2-any.pkg.tar.xz";
    sha256      = "1726eb629fe93f1ffeb2030cbc5693807d4e6ec95ea0ea966061e8a0813559d2";
  };

  "laszip" = fetch {
    name        = "laszip";
    version     = "3.2.8";
    filename    = "mingw-w64-x86_64-laszip-3.2.8-1-any.pkg.tar.xz";
    sha256      = "3df104b0c3b73bf07a65fbb84ae4499796472db11970b16c943dd8e278a498e7";
  };

  "lcms" = fetch {
    name        = "lcms";
    version     = "1.19";
    filename    = "mingw-w64-x86_64-lcms-1.19-6-any.pkg.tar.xz";
    sha256      = "12b1032b0eec342c71b4f78f3e4dbc62d340324166933975c5f0e427315ba0a6";
    buildInputs = [ libtiff ];
  };

  "lcms2" = fetch {
    name        = "lcms2";
    version     = "2.9";
    filename    = "mingw-w64-x86_64-lcms2-2.9-1-any.pkg.tar.xz";
    sha256      = "e55b24d81eab3aa0200a987fc3d394b2b1645f102121901a094901e4cd9f4c7a";
    buildInputs = [ gcc-libs libtiff ];
  };

  "lcov" = fetch {
    name        = "lcov";
    version     = "1.13";
    filename    = "mingw-w64-x86_64-lcov-1.13-2-any.pkg.tar.xz";
    sha256      = "c586678c755f4f0d7969ed07e67f85c7598fc623ea00a3129760b98b2c336210";
    buildInputs = [ perl ];
  };

  "ldns" = fetch {
    name        = "ldns";
    version     = "1.7.0";
    filename    = "mingw-w64-x86_64-ldns-1.7.0-3-any.pkg.tar.xz";
    sha256      = "215502c105079caec09b802310441aca1e2506087e674567ad4923eeae723470";
    buildInputs = [ openssl ];
  };

  "lensfun" = fetch {
    name        = "lensfun";
    version     = "0.3.95";
    filename    = "mingw-w64-x86_64-lensfun-0.3.95-1-any.pkg.tar.xz";
    sha256      = "1c8445534f86163d2536bf157f3238d88d9f3bcdb8464d87371529c632ad225e";
    buildInputs = [ glib2 libpng zlib ];
  };

  "leptonica" = fetch {
    name        = "leptonica";
    version     = "1.76.0";
    filename    = "mingw-w64-x86_64-leptonica-1.76.0-1-any.pkg.tar.xz";
    sha256      = "0404bc28a0e94412909e03e06e1021b14bf4b45c3c1c62152d1f920b0fc04946";
    buildInputs = [ gcc-libs giflib libtiff libpng libwebp openjpeg2 zlib ];
  };

  "lfcbase" = fetch {
    name        = "lfcbase";
    version     = "1.12.3";
    filename    = "mingw-w64-x86_64-lfcbase-1.12.3-1-any.pkg.tar.xz";
    sha256      = "5b95e0ec9deb5cc4a72ffd5d43de991277ea65ca41caa2fc0250cbe2f0af1632";
    buildInputs = [ gcc-libs ncurses ];
  };

  "lfcxml" = fetch {
    name        = "lfcxml";
    version     = "1.2.9";
    filename    = "mingw-w64-x86_64-lfcxml-1.2.9-1-any.pkg.tar.xz";
    sha256      = "6ebe79ba403edf318c5458d6bac141e9395b6d89b351d63c43cdf2b5d38ef17b";
    buildInputs = [ lfcbase ];
  };

  "libaacs" = fetch {
    name        = "libaacs";
    version     = "0.9.0";
    filename    = "mingw-w64-x86_64-libaacs-0.9.0-1-any.pkg.tar.xz";
    sha256      = "6ef2c4444437efc9501346d6d68203f6b893043b87fa5383e96404186ff8ca87";
    buildInputs = [ libgcrypt ];
  };

  "libao" = fetch {
    name        = "libao";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-libao-1.2.2-1-any.pkg.tar.xz";
    sha256      = "761045339f7a4f0b57dfce74966c93cda8e72cd18b62dbe0fcfcf5136c47982f";
    buildInputs = [ gcc-libs ];
  };

  "libarchive" = fetch {
    name        = "libarchive";
    version     = "3.3.3";
    filename    = "mingw-w64-x86_64-libarchive-3.3.3-2-any.pkg.tar.xz";
    sha256      = "c87532d80b8c4e6458b95b2091e65ba127b36b7ae5d43c940f4594f1a6f2f4d9";
    buildInputs = [ gcc-libs bzip2 expat libiconv lz4 lzo2 libsystre nettle openssl xz zlib zstd ];
  };

  "libart_lgpl" = fetch {
    name        = "libart_lgpl";
    version     = "2.3.21";
    filename    = "mingw-w64-x86_64-libart_lgpl-2.3.21-2-any.pkg.tar.xz";
    sha256      = "89d2572b3c0449608d55dd9e8b85d17df0344bdea72007721463720f8f47f473";
  };

  "libass" = fetch {
    name        = "libass";
    version     = "0.14.0";
    filename    = "mingw-w64-x86_64-libass-0.14.0-1-any.pkg.tar.xz";
    sha256      = "557e6cee5000175829884327999269db7eb55bf4508ebaa8f98b7684cf694b19";
    buildInputs = [ fribidi fontconfig freetype harfbuzz ];
  };

  "libassuan" = fetch {
    name        = "libassuan";
    version     = "2.5.2";
    filename    = "mingw-w64-x86_64-libassuan-2.5.2-1-any.pkg.tar.xz";
    sha256      = "14f606d340c295006844801b61f48bfa44dfaaf3eac88e5f21b9c4032b76a8e3";
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libatomic_ops" = fetch {
    name        = "libatomic_ops";
    version     = "7.6.8";
    filename    = "mingw-w64-x86_64-libatomic_ops-7.6.8-1-any.pkg.tar.xz";
    sha256      = "f114761289d62a3607b8b4fec1c050bd96917f8a0a81120863dd109b07821b6c";
    buildInputs = [  ];
  };

  "libbdplus" = fetch {
    name        = "libbdplus";
    version     = "0.1.2";
    filename    = "mingw-w64-x86_64-libbdplus-0.1.2-1-any.pkg.tar.xz";
    sha256      = "fcdb0b575ec1b3178637b7be94164660338fd7858c83f5592f29d1f5deead22d";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libaacs.version "0.7.0"; libaacs) libgpg-error ];
  };

  "libblocksruntime" = fetch {
    name        = "libblocksruntime";
    version     = "0.4.1";
    filename    = "mingw-w64-x86_64-libblocksruntime-0.4.1-1-any.pkg.tar.xz";
    sha256      = "db4d9894ccba3a1e07d15fd48422f2d6dc7087fcf2680c2b05c20b95bff7190c";
    buildInputs = [ clang ];
  };

  "libbluray" = fetch {
    name        = "libbluray";
    version     = "1.0.2";
    filename    = "mingw-w64-x86_64-libbluray-1.0.2-1-any.pkg.tar.xz";
    sha256      = "ee489c3a490fe07135203159e20cdb77cabcae1d71e9913e0b2b98a7cf7a0cf7";
    buildInputs = [ libxml2 freetype ];
  };

  "libbotan" = fetch {
    name        = "libbotan";
    version     = "2.8.0";
    filename    = "mingw-w64-x86_64-libbotan-2.8.0-1-any.pkg.tar.xz";
    sha256      = "3476e5a6e982a342429de6f9e81e1df2b5783d56a61b66e52145ed3dc400d258";
    buildInputs = [ gcc-libs boost bzip2 sqlite3 zlib xz ];
  };

  "libbs2b" = fetch {
    name        = "libbs2b";
    version     = "3.1.0";
    filename    = "mingw-w64-x86_64-libbs2b-3.1.0-1-any.pkg.tar.xz";
    sha256      = "b7ea141d36bf879bc0b0ede8d4ebd6bb396510a091fe9fdb4b20e606a490da94";
    buildInputs = [ libsndfile ];
  };

  "libbsdf" = fetch {
    name        = "libbsdf";
    version     = "0.9.4";
    filename    = "mingw-w64-x86_64-libbsdf-0.9.4-1-any.pkg.tar.xz";
    sha256      = "dc6da2be2f9a00556fb22a318f42d33972845d1cad2e0c0a2ec145256ab48094";
  };

  "libc++" = fetch {
    name        = "libc++";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-libc++-7.0.1-1-any.pkg.tar.xz";
    sha256      = "433f502b54181baca010bafa8ba17d59c7d1f578a27dfa113dd55eb8eb1552d5";
    buildInputs = [ gcc ];
  };

  "libc++abi" = fetch {
    name        = "libc++abi";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-libc++abi-7.0.1-1-any.pkg.tar.xz";
    sha256      = "2ec62c5054031faa25824760821fe8384b5891b5c941ee2c6a648bccba872091";
    buildInputs = [ gcc ];
  };

  "libcaca" = fetch {
    name        = "libcaca";
    version     = "0.99.beta19";
    filename    = "mingw-w64-x86_64-libcaca-0.99.beta19-4-any.pkg.tar.xz";
    sha256      = "13e2b7b980c8ce6a1a4127a1c3f4d9517fb7024a003e1495b3629c2e7937b17a";
    buildInputs = [ fontconfig freetype zlib ];
  };

  "libcddb" = fetch {
    name        = "libcddb";
    version     = "1.3.2";
    filename    = "mingw-w64-x86_64-libcddb-1.3.2-4-any.pkg.tar.xz";
    sha256      = "1963b2c64653d9e62780c48edf8533648aa1d52bc1f8a644b8102d8212f599f7";
    buildInputs = [ libsystre ];
  };

  "libcdio" = fetch {
    name        = "libcdio";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-libcdio-2.0.0-1-any.pkg.tar.xz";
    sha256      = "222bd6b74c70f807ff64bf6a37cb139c12f22ff880df3c211c1272b50007dd8d";
    buildInputs = [ libiconv libcddb ];
  };

  "libcdio-paranoia" = fetch {
    name        = "libcdio-paranoia";
    version     = "10.2+0.94+2";
    filename    = "mingw-w64-x86_64-libcdio-paranoia-10.2+0.94+2-2-any.pkg.tar.xz";
    sha256      = "70d47c39f53bfdd7ceef177c0f6ab82640aeb03db02343b2c1d8c92277972f30";
    buildInputs = [ libcdio ];
  };

  "libcdr" = fetch {
    name        = "libcdr";
    version     = "0.1.4";
    filename    = "mingw-w64-x86_64-libcdr-0.1.4-3-any.pkg.tar.xz";
    sha256      = "3db08c1ff4f84ec9318afb2a08399ce122e0894268653468732d14dbbb472546";
    buildInputs = [ icu lcms2 librevenge zlib ];
  };

  "libcerf" = fetch {
    name        = "libcerf";
    version     = "1.10";
    filename    = "mingw-w64-x86_64-libcerf-1.10-1-any.pkg.tar.xz";
    sha256      = "4d3e499a628f729de6fdd4e0844ea05ca6a6039fed83d8cef0569281f494c901";
    buildInputs = [  ];
  };

  "libchamplain" = fetch {
    name        = "libchamplain";
    version     = "0.12.16";
    filename    = "mingw-w64-x86_64-libchamplain-0.12.16-1-any.pkg.tar.xz";
    sha256      = "74e5d48302be652beee3c46bbfe61c66fbd1286c85e68575c6558c9d4128676f";
    buildInputs = [ clutter clutter-gtk cairo libsoup memphis sqlite3 ];
    broken      = true;
  };

  "libconfig" = fetch {
    name        = "libconfig";
    version     = "1.7.2";
    filename    = "mingw-w64-x86_64-libconfig-1.7.2-1-any.pkg.tar.xz";
    sha256      = "394fe391f3560233436a9f370c54ba9ecaa0da298d61780d69cc5fa636e68331";
    buildInputs = [ gcc-libs ];
  };

  "libcroco" = fetch {
    name        = "libcroco";
    version     = "0.6.12";
    filename    = "mingw-w64-x86_64-libcroco-0.6.12-1-any.pkg.tar.xz";
    sha256      = "b97956a437bac13659923b70d97abfe64d8291e36f5dce0f8b995b19bef91033";
    buildInputs = [ glib2 libxml2 ];
  };

  "libcue" = fetch {
    name        = "libcue";
    version     = "2.2.1";
    filename    = "mingw-w64-x86_64-libcue-2.2.1-1-any.pkg.tar.xz";
    sha256      = "cf7eb5351b8d4f5a42b5a7d91e33f867c3fbeb4c817a186d7b6ae5ce570f3cd1";
  };

  "libdatrie" = fetch {
    name        = "libdatrie";
    version     = "0.2.12";
    filename    = "mingw-w64-x86_64-libdatrie-0.2.12-1-any.pkg.tar.xz";
    sha256      = "600bc0ba61530fe7a96089d1d2011cf9a4de24a5c52ac61a38536b586a0e7a18";
    buildInputs = [ libiconv ];
  };

  "libdca" = fetch {
    name        = "libdca";
    version     = "0.0.6";
    filename    = "mingw-w64-x86_64-libdca-0.0.6-1-any.pkg.tar.xz";
    sha256      = "fc1b00a2568eccf454e19e73d2898ed9b9d724b036fd73579a7ec21502249eba";
  };

  "libdiscid" = fetch {
    name        = "libdiscid";
    version     = "0.6.2";
    filename    = "mingw-w64-x86_64-libdiscid-0.6.2-1-any.pkg.tar.xz";
    sha256      = "a8d91bf40fa33bb440a3cbd157e2836ea1e0dc176fa37d537c84bb7ff5a558a1";
  };

  "libdsm" = fetch {
    name        = "libdsm";
    version     = "0.3.0";
    filename    = "mingw-w64-x86_64-libdsm-0.3.0-1-any.pkg.tar.xz";
    sha256      = "06e31d4cf2bcaf338c1aaa35c085f0ffd6d17ef7ea31f206d98c06d9abdc6a41";
    buildInputs = [ libtasn1 ];
  };

  "libdvbpsi" = fetch {
    name        = "libdvbpsi";
    version     = "1.3.2";
    filename    = "mingw-w64-x86_64-libdvbpsi-1.3.2-1-any.pkg.tar.xz";
    sha256      = "e26298e6edaf4577b64595b01d854d4f1fa4e465dbf6fc33670328e562e14fa7";
    buildInputs = [ gcc-libs ];
  };

  "libdvdcss" = fetch {
    name        = "libdvdcss";
    version     = "1.4.2";
    filename    = "mingw-w64-x86_64-libdvdcss-1.4.2-1-any.pkg.tar.xz";
    sha256      = "bbffd69722cf9f4305dc71e22b661c8c1653f14f25f43c577119af391ce9078d";
    buildInputs = [ gcc-libs ];
  };

  "libdvdnav" = fetch {
    name        = "libdvdnav";
    version     = "6.0.0";
    filename    = "mingw-w64-x86_64-libdvdnav-6.0.0-1-any.pkg.tar.xz";
    sha256      = "2f412b1e113a7e443ccb0c2a328d2ee92a52b1f2d252107aba15c2f9aeeed640";
    buildInputs = [ libdvdread ];
  };

  "libdvdread" = fetch {
    name        = "libdvdread";
    version     = "6.0.0";
    filename    = "mingw-w64-x86_64-libdvdread-6.0.0-1-any.pkg.tar.xz";
    sha256      = "0501ffd07370c45b8b2a9c5275c33385e2522a3d10863b64ddebc87450453626";
    buildInputs = [ libdvdcss ];
  };

  "libebml" = fetch {
    name        = "libebml";
    version     = "1.3.6";
    filename    = "mingw-w64-x86_64-libebml-1.3.6-1-any.pkg.tar.xz";
    sha256      = "755f9e9311502dc0f7315685d9f5988e3a8dc14dfd7f802fd81a581294997141";
    buildInputs = [ gcc-libs ];
  };

  "libelf" = fetch {
    name        = "libelf";
    version     = "0.8.13";
    filename    = "mingw-w64-x86_64-libelf-0.8.13-4-any.pkg.tar.xz";
    sha256      = "772e6c1e9dee676dbd9d4684045da1dece07cdd4870a3c1e4620d3b39f001062";
    buildInputs = [  ];
  };

  "libepoxy" = fetch {
    name        = "libepoxy";
    version     = "1.5.3";
    filename    = "mingw-w64-x86_64-libepoxy-1.5.3-1-any.pkg.tar.xz";
    sha256      = "a3ab3932b628e0c949dfb5cf0b9170212e81590b0d551715b92fcbda328bcfb0";
    buildInputs = [ gcc-libs ];
  };

  "libevent" = fetch {
    name        = "libevent";
    version     = "2.1.8";
    filename    = "mingw-w64-x86_64-libevent-2.1.8-1-any.pkg.tar.xz";
    sha256      = "14b0166293987b4461ae8917651abefa2ce1ec55290206a26fb0ab94a7843937";
  };

  "libexif" = fetch {
    name        = "libexif";
    version     = "0.6.21";
    filename    = "mingw-w64-x86_64-libexif-0.6.21-4-any.pkg.tar.xz";
    sha256      = "8bb91b432258948df67f36b46ecf4df67c1f8e50d880f4d2ee48d3d728abc20c";
    buildInputs = [ gettext ];
  };

  "libffi" = fetch {
    name        = "libffi";
    version     = "3.2.1";
    filename    = "mingw-w64-x86_64-libffi-3.2.1-4-any.pkg.tar.xz";
    sha256      = "d80826c868e8cb016fe607e8919883e6062162f6813fe8cf138273cf8b136d14";
    buildInputs = [  ];
  };

  "libfilezilla" = fetch {
    name        = "libfilezilla";
    version     = "0.15.1";
    filename    = "mingw-w64-x86_64-libfilezilla-0.15.1-1-any.pkg.tar.xz";
    sha256      = "69cd7de8d2ef74d5181dc2388c8a28b481443dc82f0dff705157c524bf31e893";
    buildInputs = [ gcc-libs nettle ];
  };

  "libfreexl" = fetch {
    name        = "libfreexl";
    version     = "1.0.5";
    filename    = "mingw-w64-x86_64-libfreexl-1.0.5-1-any.pkg.tar.xz";
    sha256      = "31eaf929c949da578fd7bdc2d875039dda65acfcc444871409aa9bc068563be8";
    buildInputs = [  ];
  };

  "libftdi" = fetch {
    name        = "libftdi";
    version     = "1.4";
    filename    = "mingw-w64-x86_64-libftdi-1.4-2-any.pkg.tar.xz";
    sha256      = "812b715a60c721abaeccab4d8c0e8fce948b2539abce9a8e28b602efe5a71ebc";
    buildInputs = [ libusb confuse gettext libiconv ];
  };

  "libgadu" = fetch {
    name        = "libgadu";
    version     = "1.12.2";
    filename    = "mingw-w64-x86_64-libgadu-1.12.2-1-any.pkg.tar.xz";
    sha256      = "f5609fc8c1bcdfbbcb3ccadf73954e80a1da796a79196ae2520fad21ffe171d8";
    buildInputs = [ gnutls protobuf-c ];
  };

  "libgcrypt" = fetch {
    name        = "libgcrypt";
    version     = "1.8.4";
    filename    = "mingw-w64-x86_64-libgcrypt-1.8.4-1-any.pkg.tar.xz";
    sha256      = "7a2f8eba3e64eaec359c88ba1a770dbf129353c615f568020203eae9d3f92d9d";
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libgd" = fetch {
    name        = "libgd";
    version     = "2.2.5";
    filename    = "mingw-w64-x86_64-libgd-2.2.5-1-any.pkg.tar.xz";
    sha256      = "086415290c5ad59d5aaa8cd3290544760e5d8b681dd3ee84caaf2e1c58dab164";
    buildInputs = [ libpng libiconv libjpeg libtiff freetype fontconfig libimagequant libwebp xpm-nox zlib ];
  };

  "libgda" = fetch {
    name        = "libgda";
    version     = "5.2.4";
    filename    = "mingw-w64-x86_64-libgda-5.2.4-1-any.pkg.tar.xz";
    sha256      = "2ad831c2622c542dd5f2c4c8e3334f170d2d4fc30c825001c4f0e40a2c036cef";
    buildInputs = [ gtk3 gtksourceview3 goocanvas iso-codes json-glib libsoup libxml2 libxslt glade ];
  };

  "libgdata" = fetch {
    name        = "libgdata";
    version     = "0.17.9";
    filename    = "mingw-w64-x86_64-libgdata-0.17.9-1-any.pkg.tar.xz";
    sha256      = "cec2c8cc1f25fa2daca76d5ff73efa8362ef862374e86b930901df124e687216";
    buildInputs = [ glib2 gtk3 gdk-pixbuf2 json-glib liboauth libsoup libxml2 uhttpmock ];
  };

  "libgdiplus" = fetch {
    name        = "libgdiplus";
    version     = "5.6";
    filename    = "mingw-w64-x86_64-libgdiplus-5.6-1-any.pkg.tar.xz";
    sha256      = "aeffa0a4e7dce3b09021ba883ceb4c57d1bbd72a65644da9e9b4efc4a8a27a5f";
    buildInputs = [ libtiff cairo fontconfig freetype giflib glib2 libexif libpng zlib ];
  };

  "libgee" = fetch {
    name        = "libgee";
    version     = "0.20.1";
    filename    = "mingw-w64-x86_64-libgee-0.20.1-1-any.pkg.tar.xz";
    sha256      = "fb8ba311adf9db1bbb4f5d066edeb18a43936075431e550c3d8e25c3755c5817";
    buildInputs = [ glib2 ];
  };

  "libgeotiff" = fetch {
    name        = "libgeotiff";
    version     = "1.4.3";
    filename    = "mingw-w64-x86_64-libgeotiff-1.4.3-1-any.pkg.tar.xz";
    sha256      = "904dbb60e067da2b8910f05575dbc1ddd27b881d354d40a73b2594be8ceaf5cc";
    buildInputs = [ gcc-libs libtiff libjpeg proj zlib ];
  };

  "libgit2" = fetch {
    name        = "libgit2";
    version     = "0.27.7";
    filename    = "mingw-w64-x86_64-libgit2-0.27.7-1-any.pkg.tar.xz";
    sha256      = "4e8d8cecbc84f309ec1418cb16ef1a92c18c164c0e77e50fa60c622ae5a8d4da";
    buildInputs = [ curl http-parser libssh2 openssl zlib ];
  };

  "libgit2-glib" = fetch {
    name        = "libgit2-glib";
    version     = "0.27.7";
    filename    = "mingw-w64-x86_64-libgit2-glib-0.27.7-1-any.pkg.tar.xz";
    sha256      = "1aa6c6af9384a9d3cc4a90832dee26b240cddb2f19e8c11840440ba295f62cee";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libgit2.version "0.23"; libgit2) libssh2 glib2 ];
  };

  "libglade" = fetch {
    name        = "libglade";
    version     = "2.6.4";
    filename    = "mingw-w64-x86_64-libglade-2.6.4-5-any.pkg.tar.xz";
    sha256      = "03471470d46b5ea62cd0824cd50c3dd71765690e8d46cfd519a5b36245374515";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.16.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.3"; libxml2) ];
  };

  "libgme" = fetch {
    name        = "libgme";
    version     = "0.6.2";
    filename    = "mingw-w64-x86_64-libgme-0.6.2-1-any.pkg.tar.xz";
    sha256      = "3c893817c0a383d33c9956686530b3e67b27af10480f59828fca3f050641a33d";
    buildInputs = [ gcc-libs ];
  };

  "libgnomecanvas" = fetch {
    name        = "libgnomecanvas";
    version     = "2.30.3";
    filename    = "mingw-w64-x86_64-libgnomecanvas-2.30.3-3-any.pkg.tar.xz";
    sha256      = "83e412ef86d9f12d076461dbf84dbad326318623079f5455458911d725d720de";
    buildInputs = [ gtk2 gettext libart_lgpl libglade ];
  };

  "libgoom2" = fetch {
    name        = "libgoom2";
    version     = "2k4";
    filename    = "mingw-w64-x86_64-libgoom2-2k4-3-any.pkg.tar.xz";
    sha256      = "a6bb14d7a956cd745b93d2b9f44ef576d0fb43bca2c9c2df4957ad6876e76652";
    buildInputs = [ gcc-libs ];
  };

  "libgpg-error" = fetch {
    name        = "libgpg-error";
    version     = "1.33";
    filename    = "mingw-w64-x86_64-libgpg-error-1.33-1-any.pkg.tar.xz";
    sha256      = "d2f048624f81e0e038d290dd9c8f5acc1b0c3cf1fa2da2910a9ce9ebe247ad8e";
    buildInputs = [ gcc-libs gettext ];
  };

  "libgphoto2" = fetch {
    name        = "libgphoto2";
    version     = "2.5.21";
    filename    = "mingw-w64-x86_64-libgphoto2-2.5.21-1-any.pkg.tar.xz";
    sha256      = "247f724d472afa69ad2707a5e1c39f6586d85a4eac63688961af736ddbf8ade4";
    buildInputs = [ libsystre libjpeg libxml2 libgd libexif libusb ];
  };

  "libgsf" = fetch {
    name        = "libgsf";
    version     = "1.14.45";
    filename    = "mingw-w64-x86_64-libgsf-1.14.45-1-any.pkg.tar.xz";
    sha256      = "bd85f4fc5df23918ce97f7788ca146084aae36aefd1b7aaa13fc4eb1cc1d34f4";
    buildInputs = [ glib2 gdk-pixbuf2 libxml2 zlib ];
  };

  "libguess" = fetch {
    name        = "libguess";
    version     = "1.2";
    filename    = "mingw-w64-x86_64-libguess-1.2-3-any.pkg.tar.xz";
    sha256      = "240ee03e504d08e428943f5e7b61a7055331300ddd4c7800008ca43c62774b77";
    buildInputs = [ libmowgli ];
  };

  "libgusb" = fetch {
    name        = "libgusb";
    version     = "0.2.11";
    filename    = "mingw-w64-x86_64-libgusb-0.2.11-1-any.pkg.tar.xz";
    sha256      = "265e7cfe59e18d9b101c2e59ef1773a1a149428cccd005921ce4077bb1dedab5";
    buildInputs = [ libusb glib2 ];
  };

  "libgweather" = fetch {
    name        = "libgweather";
    version     = "3.28.2";
    filename    = "mingw-w64-x86_64-libgweather-3.28.2-1-any.pkg.tar.xz";
    sha256      = "e9116737b0d00d8a5c90d8239e5898b7199682aa1833bbb56836f85560d97925";
    buildInputs = [ gtk3 libsoup libsystre libxml2 geocode-glib ];
  };

  "libgxps" = fetch {
    name        = "libgxps";
    version     = "0.3.0";
    filename    = "mingw-w64-x86_64-libgxps-0.3.0-1-any.pkg.tar.xz";
    sha256      = "6b4a4e47cfb0ef99a65328a394416f81b645ba86ce29bd6c495d389e14133ac1";
    buildInputs = [ glib2 gtk3 cairo lcms2 libarchive libjpeg libxslt libpng ];
  };

  "libharu" = fetch {
    name        = "libharu";
    version     = "2.3.0";
    filename    = "mingw-w64-x86_64-libharu-2.3.0-2-any.pkg.tar.xz";
    sha256      = "9df90f28385d81634129630e8792cb594edf9d899807893caf2fbea3b5d343d1";
    buildInputs = [ libpng ];
  };

  "libical" = fetch {
    name        = "libical";
    version     = "3.0.4";
    filename    = "mingw-w64-x86_64-libical-3.0.4-1-any.pkg.tar.xz";
    sha256      = "d061d8624f6d6883bc30e50c1ca731de1f8afd3c6f1ba12b0601364b5ade7762";
    buildInputs = [ gcc-libs icu glib2 gobject-introspection libxml2 db ];
  };

  "libiconv" = fetch {
    name        = "libiconv";
    version     = "1.15";
    filename    = "mingw-w64-x86_64-libiconv-1.15-3-any.pkg.tar.xz";
    sha256      = "2956e81baba9aae0e77202039d89603fa4fe1ee8dce4c021aecbcef252d9598e";
    buildInputs = [  ];
  };

  "libidl2" = fetch {
    name        = "libidl2";
    version     = "0.8.14";
    filename    = "mingw-w64-x86_64-libidl2-0.8.14-1-any.pkg.tar.xz";
    sha256      = "470c56c36685f4aea48e9bc3d2a437f00cf66c6e77d5dbf99e09d55d2468982e";
    buildInputs = [ glib2 ];
  };

  "libidn" = fetch {
    name        = "libidn";
    version     = "1.35";
    filename    = "mingw-w64-x86_64-libidn-1.35-1-any.pkg.tar.xz";
    sha256      = "b36d259d6f9b34833b8404639bb3a012e043d32ef87f9bf80f3f022a15a1abe1";
    buildInputs = [ gettext ];
  };

  "libidn2" = fetch {
    name        = "libidn2";
    version     = "2.0.5";
    filename    = "mingw-w64-x86_64-libidn2-2.0.5-1-any.pkg.tar.xz";
    sha256      = "916000573ae4fd1b66377b57bdf7697eea825b31d02673bc820b6a36949a3d08";
    buildInputs = [ gettext libunistring ];
  };

  "libilbc" = fetch {
    name        = "libilbc";
    version     = "2.0.2";
    filename    = "mingw-w64-x86_64-libilbc-2.0.2-1-any.pkg.tar.xz";
    sha256      = "8da0f51035ddd18060ee5d99531852004b1cdba339798e9bcc213173d782e3a1";
  };

  "libimagequant" = fetch {
    name        = "libimagequant";
    version     = "2.12.2";
    filename    = "mingw-w64-x86_64-libimagequant-2.12.2-1-any.pkg.tar.xz";
    sha256      = "30748f97c9eae83c83e75c8eb6cca2515227b657c774ae822d321fe1316cbcd7";
    buildInputs = [  ];
  };

  "libimobiledevice" = fetch {
    name        = "libimobiledevice";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-libimobiledevice-1.2.0-1-any.pkg.tar.xz";
    sha256      = "14513f8424c8d4aa18f7263773eef5d437d6078b21c37b20f2140fe4dd6a619d";
    buildInputs = [ libusbmuxd libplist openssl ];
  };

  "libjpeg-turbo" = fetch {
    name        = "libjpeg-turbo";
    version     = "2.0.1";
    filename    = "mingw-w64-x86_64-libjpeg-turbo-2.0.1-1-any.pkg.tar.xz";
    sha256      = "f403338c485529d291478c5d1adb85cc6f5e234a55daddb39f77790d74b579af";
    buildInputs = [ gcc-libs ];
  };

  "libkml" = fetch {
    name        = "libkml";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-libkml-1.3.0-5-any.pkg.tar.xz";
    sha256      = "17ee9e8fffd1be6d25ee53b6a7e932529657591b7bb0bbde47bdb5a96b26b562";
    buildInputs = [ boost minizip uriparser zlib ];
    broken      = true;
  };

  "libksba" = fetch {
    name        = "libksba";
    version     = "1.3.5";
    filename    = "mingw-w64-x86_64-libksba-1.3.5-1-any.pkg.tar.xz";
    sha256      = "d46b087278d897bf35e8bcb4b490de3431d9d8f9a951071748bb06c44a79f453";
    buildInputs = [ libgpg-error ];
  };

  "liblas" = fetch {
    name        = "liblas";
    version     = "1.8.1";
    filename    = "mingw-w64-x86_64-liblas-1.8.1-1-any.pkg.tar.xz";
    sha256      = "7cfa0a44d8f7624b55b6fe322e45090946e81b60980daf465906299bea1fc420";
    buildInputs = [ gdal laszip ];
    broken      = true;
  };

  "liblastfm" = fetch {
    name        = "liblastfm";
    version     = "1.0.9";
    filename    = "mingw-w64-x86_64-liblastfm-1.0.9-2-any.pkg.tar.xz";
    sha256      = "992cf3d9a6fe12e85a013feb87de9ba0e4240eec68171e8333fd97de2209ad07";
    buildInputs = [ qt5 fftw libsamplerate ];
    broken      = true;
  };

  "liblastfm-qt4" = fetch {
    name        = "liblastfm-qt4";
    version     = "1.0.9";
    filename    = "mingw-w64-x86_64-liblastfm-qt4-1.0.9-1-any.pkg.tar.xz";
    sha256      = "3687d7d9713fde544914bf14921266a5c0bee1987cf504dd97720680e9d4c988";
    buildInputs = [ qt4 fftw libsamplerate ];
  };

  "liblqr" = fetch {
    name        = "liblqr";
    version     = "0.4.2";
    filename    = "mingw-w64-x86_64-liblqr-0.4.2-4-any.pkg.tar.xz";
    sha256      = "cfd99e8e0821da2b0a69cd7736e85e42f7c6e88d819617b764ec02094bce4644";
    buildInputs = [ glib2 ];
  };

  "libmad" = fetch {
    name        = "libmad";
    version     = "0.15.1b";
    filename    = "mingw-w64-x86_64-libmad-0.15.1b-4-any.pkg.tar.xz";
    sha256      = "a2665598cb50e68d921d4a593c816b9a7f814d0aa076de4b378c779c09dc647f";
    buildInputs = [  ];
  };

  "libmangle-git" = fetch {
    name        = "libmangle-git";
    version     = "7.0.0.5230.69c8fad6";
    filename    = "mingw-w64-x86_64-libmangle-git-7.0.0.5230.69c8fad6-1-any.pkg.tar.xz";
    sha256      = "9b0fcfb650c29192a029e4489850390f18f05e023e97e78c608eaa6ab86da8a1";
  };

  "libmariadbclient" = fetch {
    name        = "libmariadbclient";
    version     = "2.3.7";
    filename    = "mingw-w64-x86_64-libmariadbclient-2.3.7-1-any.pkg.tar.xz";
    sha256      = "3e1c94164bd915a9bccb46ed0f853f4454dc4c43e490e99a52ada504aceb4cd3";
    buildInputs = [ gcc-libs openssl zlib ];
  };

  "libmatroska" = fetch {
    name        = "libmatroska";
    version     = "1.4.9";
    filename    = "mingw-w64-x86_64-libmatroska-1.4.9-2-any.pkg.tar.xz";
    sha256      = "95aab160d5cdc2135ff196fac7f1112cfc5f39013bd5a1954c9939cadda97ef9";
    buildInputs = [ libebml ];
  };

  "libmaxminddb" = fetch {
    name        = "libmaxminddb";
    version     = "1.3.2";
    filename    = "mingw-w64-x86_64-libmaxminddb-1.3.2-1-any.pkg.tar.xz";
    sha256      = "285079dc6f44198462ef992b0692ba7b2699bd9390e53b86765109b9725751e5";
    buildInputs = [ gcc-libs geoip2-database ];
  };

  "libmetalink" = fetch {
    name        = "libmetalink";
    version     = "0.1.3";
    filename    = "mingw-w64-x86_64-libmetalink-0.1.3-3-any.pkg.tar.xz";
    sha256      = "b2340432e10a0296b1765b743c50b6617cb8cd1bd5f78f693f2bd7ce9edf72db";
    buildInputs = [ gcc-libs expat ];
  };

  "libmfx" = fetch {
    name        = "libmfx";
    version     = "1.25";
    filename    = "mingw-w64-x86_64-libmfx-1.25-1-any.pkg.tar.xz";
    sha256      = "1e07a220c2dc6e4ebf5f5b365c42c3b81661b78996dc834cde039f545c195166";
    buildInputs = [ gcc-libs ];
  };

  "libmicrodns" = fetch {
    name        = "libmicrodns";
    version     = "0.0.10";
    filename    = "mingw-w64-x86_64-libmicrodns-0.0.10-1-any.pkg.tar.xz";
    sha256      = "541110679aeed6af330f6912e0974416f155e2b67b470a1b56dae0eee01c2b11";
    buildInputs = [ libtasn1 ];
  };

  "libmicrohttpd" = fetch {
    name        = "libmicrohttpd";
    version     = "0.9.62";
    filename    = "mingw-w64-x86_64-libmicrohttpd-0.9.62-1-any.pkg.tar.xz";
    sha256      = "b9294d9f33e903747e9bcd617946f153d5cd0e9e3deeb72abda6c46c6e109c0d";
    buildInputs = [ gnutls ];
  };

  "libmicroutils" = fetch {
    name        = "libmicroutils";
    version     = "4.3.0";
    filename    = "mingw-w64-x86_64-libmicroutils-4.3.0-1-any.pkg.tar.xz";
    sha256      = "bbf74a0012a72a9651f43ba5342f502609b68c2cff03d6a50259fd3f6a07e524";
    buildInputs = [ libsystre ];
  };

  "libmikmod" = fetch {
    name        = "libmikmod";
    version     = "3.3.11.1";
    filename    = "mingw-w64-x86_64-libmikmod-3.3.11.1-1-any.pkg.tar.xz";
    sha256      = "52f6f0a92cf07c0f3deb6e7eb42c198ca54b5b1f7009d8cd87a12fd1804d8b3e";
    buildInputs = [ gcc-libs openal ];
  };

  "libmimic" = fetch {
    name        = "libmimic";
    version     = "1.0.4";
    filename    = "mingw-w64-x86_64-libmimic-1.0.4-3-any.pkg.tar.xz";
    sha256      = "288ec145f65d72ae17d1dc990742ed806231acc04c126a76b0ce2e199e35a821";
    buildInputs = [ glib2 ];
  };

  "libmng" = fetch {
    name        = "libmng";
    version     = "2.0.3";
    filename    = "mingw-w64-x86_64-libmng-2.0.3-4-any.pkg.tar.xz";
    sha256      = "db46c7eef283d424b0886c5ef13b462f4671cc666204d45cb0fad4dbfa662950";
    buildInputs = [ libjpeg-turbo lcms2 zlib ];
  };

  "libmodbus-git" = fetch {
    name        = "libmodbus-git";
    version     = "658.0e2f470";
    filename    = "mingw-w64-x86_64-libmodbus-git-658.0e2f470-1-any.pkg.tar.xz";
    sha256      = "2faec3be8e3fef5bcf3212cd075cbce4df88395e53cb7b5808cb29d793ab58bc";
  };

  "libmodplug" = fetch {
    name        = "libmodplug";
    version     = "0.8.9.0";
    filename    = "mingw-w64-x86_64-libmodplug-0.8.9.0-1-any.pkg.tar.xz";
    sha256      = "1b010f32a6cc636aca15f7dca479367f2c9278c073fe76f6991fec06c4df3f0d";
    buildInputs = [ gcc-libs ];
  };

  "libmongoose" = fetch {
    name        = "libmongoose";
    version     = "6.4";
    filename    = "mingw-w64-x86_64-libmongoose-6.4-1-any.pkg.tar.xz";
    sha256      = "42257cbc172533ee97eba239becffa202451a7304c3b6731f04a5747580b95c4";
    buildInputs = [ gcc-libs ];
  };

  "libmongoose-git" = fetch {
    name        = "libmongoose-git";
    version     = "r1793.41b405d";
    filename    = "mingw-w64-x86_64-libmongoose-git-r1793.41b405d-3-any.pkg.tar.xz";
    sha256      = "0ec9483a5892756cc0df5d954c16434175d606a45dab57fcb234bfc01479536b";
    buildInputs = [ gcc-libs ];
  };

  "libmowgli" = fetch {
    name        = "libmowgli";
    version     = "2.1.3";
    filename    = "mingw-w64-x86_64-libmowgli-2.1.3-3-any.pkg.tar.xz";
    sha256      = "4667f48da94738e673d1a82c624b41ab36d493926e6b25811a18c5dd72b0846d";
    buildInputs = [ gcc-libs ];
  };

  "libmpack" = fetch {
    name        = "libmpack";
    version     = "1.0.5";
    filename    = "mingw-w64-x86_64-libmpack-1.0.5-1-any.pkg.tar.xz";
    sha256      = "b68eefbf1a96d51246187489ee91624c6e6a03543a1b21fafa7d9f78bad0e48b";
  };

  "libmpcdec" = fetch {
    name        = "libmpcdec";
    version     = "1.2.6";
    filename    = "mingw-w64-x86_64-libmpcdec-1.2.6-3-any.pkg.tar.xz";
    sha256      = "84b88d42da2bf41dec4dfb2561570eee2226163f221a66070f8f41b32917ba3a";
    buildInputs = [ gcc-libs ];
  };

  "libmpeg2-git" = fetch {
    name        = "libmpeg2-git";
    version     = "r1108.946bf4b";
    filename    = "mingw-w64-x86_64-libmpeg2-git-r1108.946bf4b-1-any.pkg.tar.xz";
    sha256      = "4deffe098a796e0f6e69ad096beabbbcab466c34658cf43d4a9a02a5655e9368";
    buildInputs = [ gcc-libs ];
  };

  "libmypaint" = fetch {
    name        = "libmypaint";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-libmypaint-1.3.0-4-any.pkg.tar.xz";
    sha256      = "d56c13e5d8944ba55e13738ac88817084fd2d12bbe14931d16d1990258ea5897";
    buildInputs = [ gcc-libs glib2 json-c ];
  };

  "libmysofa" = fetch {
    name        = "libmysofa";
    version     = "0.6";
    filename    = "mingw-w64-x86_64-libmysofa-0.6-1-any.pkg.tar.xz";
    sha256      = "89a737635a70e09738d870c00c70d8c082ba21ff85aa66d02bc12fa149113398";
    buildInputs = [ gcc-libs zlib ];
  };

  "libnfs" = fetch {
    name        = "libnfs";
    version     = "3.0.0";
    filename    = "mingw-w64-x86_64-libnfs-3.0.0-1-any.pkg.tar.xz";
    sha256      = "ff235cb045e533bf7bc6b376e1b0252c5c58c3b529e8e62a7e2c64590975e7a2";
    buildInputs = [ gcc-libs ];
  };

  "libnice" = fetch {
    name        = "libnice";
    version     = "0.1.14";
    filename    = "mingw-w64-x86_64-libnice-0.1.14-1-any.pkg.tar.xz";
    sha256      = "2ba868ffd29944296237211c18d0c9beec89425a9cf07b89f6bf60f0632bb68b";
    buildInputs = [ glib2 ];
  };

  "libnotify" = fetch {
    name        = "libnotify";
    version     = "0.7.7";
    filename    = "mingw-w64-x86_64-libnotify-0.7.7-1-any.pkg.tar.xz";
    sha256      = "c23e4f53c1f920db30c4f0154deb6276c7d88250505cf51c25fe5048e17e75ed";
    buildInputs = [ gdk-pixbuf2 ];
  };

  "libnova" = fetch {
    name        = "libnova";
    version     = "0.15.0";
    filename    = "mingw-w64-x86_64-libnova-0.15.0-1-any.pkg.tar.xz";
    sha256      = "8c76c8bea55e88e0cecdc049ecc1ca50fb2302ad97d3096f682a93cf7c595c5b";
  };

  "libntlm" = fetch {
    name        = "libntlm";
    version     = "1.5";
    filename    = "mingw-w64-x86_64-libntlm-1.5-1-any.pkg.tar.xz";
    sha256      = "d1d318f5f279f7d7e1ed53d05424d3d2bb3d6c6dd58ea49ba8f0a25767786a73";
    buildInputs = [ gcc-libs ];
  };

  "libnumbertext" = fetch {
    name        = "libnumbertext";
    version     = "1.0.5";
    filename    = "mingw-w64-x86_64-libnumbertext-1.0.5-1-any.pkg.tar.xz";
    sha256      = "6377155b4d9d8e645504bdd46175f552b34304c18110c4c6ff79247e4be44a71";
    buildInputs = [ gcc-libs ];
  };

  "liboauth" = fetch {
    name        = "liboauth";
    version     = "1.0.3";
    filename    = "mingw-w64-x86_64-liboauth-1.0.3-6-any.pkg.tar.xz";
    sha256      = "3003fd232ac3881b3686f00f748d79f30714ee347f287fe87553d73974e64256";
    buildInputs = [ curl nss ];
  };

  "libodfgen" = fetch {
    name        = "libodfgen";
    version     = "0.1.7";
    filename    = "mingw-w64-x86_64-libodfgen-0.1.7-1-any.pkg.tar.xz";
    sha256      = "71530d58644bb0b656447eb6056f9bedf2a8100d09b77a44c52d264a8480c5d7";
    buildInputs = [ librevenge ];
  };

  "libogg" = fetch {
    name        = "libogg";
    version     = "1.3.3";
    filename    = "mingw-w64-x86_64-libogg-1.3.3-1-any.pkg.tar.xz";
    sha256      = "25c28134ed8edfb21b2dea572ed976ff6d684426244a329fbfe1bdc499e0213b";
    buildInputs = [  ];
  };

  "libopusenc" = fetch {
    name        = "libopusenc";
    version     = "0.2.1";
    filename    = "mingw-w64-x86_64-libopusenc-0.2.1-1-any.pkg.tar.xz";
    sha256      = "fd46e5e1c518e5dc8c08c5c3eb3bf0b7f6254598f362fcd19278f55d44976b2d";
    buildInputs = [ gcc-libs opus ];
  };

  "libosmpbf-git" = fetch {
    name        = "libosmpbf-git";
    version     = "1.3.3.13.g4edb4f0";
    filename    = "mingw-w64-x86_64-libosmpbf-git-1.3.3.13.g4edb4f0-1-any.pkg.tar.xz";
    sha256      = "41c2884d8aa7b9a9fcd558d73c207559ce6f524f1bd517ab5efd815c98ed7016";
    buildInputs = [ protobuf ];
  };

  "libotr" = fetch {
    name        = "libotr";
    version     = "4.1.1";
    filename    = "mingw-w64-x86_64-libotr-4.1.1-2-any.pkg.tar.xz";
    sha256      = "edbe1b14cf18210662165703b06b9f2d433959f1a2b1ac8ac6c9132870f8dc09";
    buildInputs = [ libgcrypt ];
  };

  "libpaper" = fetch {
    name        = "libpaper";
    version     = "1.1.24";
    filename    = "mingw-w64-x86_64-libpaper-1.1.24-2-any.pkg.tar.xz";
    sha256      = "321fc1419b739dd41a2821a1c278329ddf24a1257cecaa3b06e2828b48146bf3";
    buildInputs = [  ];
  };

  "libpeas" = fetch {
    name        = "libpeas";
    version     = "1.22.0";
    filename    = "mingw-w64-x86_64-libpeas-1.22.0-3-any.pkg.tar.xz";
    sha256      = "0da962bb267ad56a6ce81e132ca5f270e85112c13cf6f75c6335378630055929";
    buildInputs = [ gcc-libs gtk3 adwaita-icon-theme ];
  };

  "libplacebo" = fetch {
    name        = "libplacebo";
    version     = "1.7.0";
    filename    = "mingw-w64-x86_64-libplacebo-1.7.0-1-any.pkg.tar.xz";
    sha256      = "799fbb85f3d39683ad3f4d6e24bc420d0e69132a9a3a9b53dc4e32ff2161867c";
    buildInputs = [ vulkan ];
    broken      = true;
  };

  "libplist" = fetch {
    name        = "libplist";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-libplist-2.0.0-3-any.pkg.tar.xz";
    sha256      = "6672a1e753e4508313a54f13c9cffd1a08f73c10cbba973fb21691e67d8f2edc";
    buildInputs = [ libxml2 cython ];
  };

  "libpng" = fetch {
    name        = "libpng";
    version     = "1.6.36";
    filename    = "mingw-w64-x86_64-libpng-1.6.36-1-any.pkg.tar.xz";
    sha256      = "2a0e31df1f309bbbaea02f31d8f475c2b94f6232a9a2e215fff22a5b2ba2c4af";
    buildInputs = [ gcc-libs zlib ];
  };

  "libproxy" = fetch {
    name        = "libproxy";
    version     = "0.4.15";
    filename    = "mingw-w64-x86_64-libproxy-0.4.15-2-any.pkg.tar.xz";
    sha256      = "806f125917174e51a902ec99dbafe3e5fc103b02f4fa8668747cda09117998c6";
    buildInputs = [ gcc-libs ];
  };

  "libpsl" = fetch {
    name        = "libpsl";
    version     = "0.20.2";
    filename    = "mingw-w64-x86_64-libpsl-0.20.2-1-any.pkg.tar.xz";
    sha256      = "f50ce84b007fb23ff9e3f9e4875e26b30ae9a645e865885df094c408cd536c95";
    buildInputs = [ libidn2 libunistring gettext ];
  };

  "libraqm" = fetch {
    name        = "libraqm";
    version     = "0.5.0";
    filename    = "mingw-w64-x86_64-libraqm-0.5.0-1-any.pkg.tar.xz";
    sha256      = "6a1a68c756cc6bd359bf36947043f7f10c40afb29402f0ddc70f6042afb1c80c";
    buildInputs = [ freetype glib2 harfbuzz fribidi ];
  };

  "libraw" = fetch {
    name        = "libraw";
    version     = "0.19.2";
    filename    = "mingw-w64-x86_64-libraw-0.19.2-1-any.pkg.tar.xz";
    sha256      = "6cdf75ce2461dc194cecbb6ab145b127d649391c7c804f9b71fc606ff6cac680";
    buildInputs = [ gcc-libs lcms2 jasper ];
  };

  "librescl" = fetch {
    name        = "librescl";
    version     = "0.3.3";
    filename    = "mingw-w64-x86_64-librescl-0.3.3-1-any.pkg.tar.xz";
    sha256      = "32d83e1c3003cd9b86d733e0713ccf405a6df3fe9e30c2fb89f0078fd45037b7";
    buildInputs = [ gcc-libs gettext (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.34.0"; glib2) gobject-introspection gxml libgee libxml2 vala xz zlib ];
  };

  "libressl" = fetch {
    name        = "libressl";
    version     = "2.8.2";
    filename    = "mingw-w64-x86_64-libressl-2.8.2-1-any.pkg.tar.xz";
    sha256      = "65a43bc8e7658d9cec07d6f4d5ec3f232327eb03e79713a22f67c1bf57d669fb";
    buildInputs = [ gcc-libs ];
  };

  "librest" = fetch {
    name        = "librest";
    version     = "0.8.1";
    filename    = "mingw-w64-x86_64-librest-0.8.1-1-any.pkg.tar.xz";
    sha256      = "1245e3bf2aca2b2b795670a0b74c364cc9496171617919bdaa3ac89c43367cf3";
    buildInputs = [ glib2 libsoup libxml2 ];
  };

  "librevenge" = fetch {
    name        = "librevenge";
    version     = "0.0.4";
    filename    = "mingw-w64-x86_64-librevenge-0.0.4-2-any.pkg.tar.xz";
    sha256      = "f9799b8bd0c4baace317c1549e4c19c80106f8f462b981c486bc08e0c8fb7944";
    buildInputs = [ gcc-libs boost zlib ];
  };

  "librsvg" = fetch {
    name        = "librsvg";
    version     = "2.40.20";
    filename    = "mingw-w64-x86_64-librsvg-2.40.20-1-any.pkg.tar.xz";
    sha256      = "0e533a85770d41f91fc6876da1331143f87ec54db72bb9fc39ef051453cac5e4";
    buildInputs = [ gdk-pixbuf2 pango libcroco ];
  };

  "librsync" = fetch {
    name        = "librsync";
    version     = "2.0.2";
    filename    = "mingw-w64-x86_64-librsync-2.0.2-1-any.pkg.tar.xz";
    sha256      = "117aed48d5e85aa78d3aab8d653e507cd047e39b30f24a9e2b9f53884243d8fc";
    buildInputs = [ gcc-libs popt ];
  };

  "libsamplerate" = fetch {
    name        = "libsamplerate";
    version     = "0.1.9";
    filename    = "mingw-w64-x86_64-libsamplerate-0.1.9-1-any.pkg.tar.xz";
    sha256      = "89964b9e97c8474273cd1b543333f0045abb1fe444cf58e9e1a5a7aa95b42dd3";
    buildInputs = [ libsndfile fftw ];
  };

  "libsass" = fetch {
    name        = "libsass";
    version     = "3.5.5";
    filename    = "mingw-w64-x86_64-libsass-3.5.5-1-any.pkg.tar.xz";
    sha256      = "94ed152d2b0261e441ac54da0f95d6d895df3e97ef20cd63355c154ae45cf05d";
  };

  "libsbml" = fetch {
    name        = "libsbml";
    version     = "5.17.0";
    filename    = "mingw-w64-x86_64-libsbml-5.17.0-1-any.pkg.tar.xz";
    sha256      = "0783253870a06df924fb6883185c4c11ef967613539e11ae9554ce7647e1dfea";
    buildInputs = [ libxml2 ];
  };

  "libsecret" = fetch {
    name        = "libsecret";
    version     = "0.18";
    filename    = "mingw-w64-x86_64-libsecret-0.18-5-any.pkg.tar.xz";
    sha256      = "2cba7a0a504e5b42e6abc8f7e86a8178d8d2e17fe8a734ae8d0e2dc2d6480428";
    buildInputs = [ gcc-libs glib2 libgcrypt ];
  };

  "libshout" = fetch {
    name        = "libshout";
    version     = "2.4.1";
    filename    = "mingw-w64-x86_64-libshout-2.4.1-2-any.pkg.tar.xz";
    sha256      = "3f0cfc87913b88fa25c330f02f8827ac4747a5862874caf1c4dca7e4d0bd6602";
    buildInputs = [ libvorbis libtheora openssl speex ];
  };

  "libsigc++" = fetch {
    name        = "libsigc++";
    version     = "2.10.1";
    filename    = "mingw-w64-x86_64-libsigc++-2.10.1-1-any.pkg.tar.xz";
    sha256      = "a78f4635b89982bc13ba1c8e25dfd6ec9a57a9a146574cfcaec48cb57bc7eca7";
    buildInputs = [ gcc-libs ];
  };

  "libsigc++3" = fetch {
    name        = "libsigc++3";
    version     = "2.99.11";
    filename    = "mingw-w64-x86_64-libsigc++3-2.99.11-1-any.pkg.tar.xz";
    sha256      = "70615efbe835c97c90679d481c0cf49db8379ac2f949e3e14349552ff5b85bd4";
    buildInputs = [ gcc-libs ];
  };

  "libsignal-protocol-c-git" = fetch {
    name        = "libsignal-protocol-c-git";
    version     = "r34.16bfd04";
    filename    = "mingw-w64-x86_64-libsignal-protocol-c-git-r34.16bfd04-1-any.pkg.tar.xz";
    sha256      = "408ec185b8c1efd6ab712b6b4bbb3255e3f4998bbebdc8eb546124353e292653";
  };

  "libsigsegv" = fetch {
    name        = "libsigsegv";
    version     = "2.12";
    filename    = "mingw-w64-x86_64-libsigsegv-2.12-1-any.pkg.tar.xz";
    sha256      = "dfdaf8a429de80c2b42d08e0e905b6a478f20c5e4b27900cc81cfba964739050";
    buildInputs = [  ];
  };

  "libsndfile" = fetch {
    name        = "libsndfile";
    version     = "1.0.28";
    filename    = "mingw-w64-x86_64-libsndfile-1.0.28-1-any.pkg.tar.xz";
    sha256      = "5991875e7533a756d4994968a84847f0cf34f78a7bbf0df1b4698d8cb092ca80";
    buildInputs = [ flac libvorbis speex ];
  };

  "libsodium" = fetch {
    name        = "libsodium";
    version     = "1.0.16";
    filename    = "mingw-w64-x86_64-libsodium-1.0.16-1-any.pkg.tar.xz";
    sha256      = "3453e2ce0ba0e754079a7270dd8e8efcf6ddf1ae9114248d575fc8fa62ec64c4";
    buildInputs = [ gcc-libs ];
  };

  "libsoup" = fetch {
    name        = "libsoup";
    version     = "2.64.2";
    filename    = "mingw-w64-x86_64-libsoup-2.64.2-1-any.pkg.tar.xz";
    sha256      = "1927de4177742f1f1191e88d0b39272f8de5a5f4c6a41d1260d32ed59d1034fd";
    buildInputs = [ gcc-libs glib2 glib-networking libxml2 libpsl sqlite3 ];
  };

  "libsoxr" = fetch {
    name        = "libsoxr";
    version     = "0.1.3";
    filename    = "mingw-w64-x86_64-libsoxr-0.1.3-1-any.pkg.tar.xz";
    sha256      = "d8ae36d8abbb2b7e4a64ff2e5349ea09d2afaf1f8583c1f7a05a2aa9c1436844";
    buildInputs = [ gcc-libs ];
  };

  "libspatialite" = fetch {
    name        = "libspatialite";
    version     = "4.3.0.a";
    filename    = "mingw-w64-x86_64-libspatialite-4.3.0.a-3-any.pkg.tar.xz";
    sha256      = "0b70c425789d5fb1b41026360460bd24193b522c78320ce8154f546e546734b7";
    buildInputs = [ geos libfreexl libxml2 proj sqlite3 libiconv ];
  };

  "libspectre" = fetch {
    name        = "libspectre";
    version     = "0.2.8";
    filename    = "mingw-w64-x86_64-libspectre-0.2.8-2-any.pkg.tar.xz";
    sha256      = "329bc9f2fbf00b797cba2bba120304f9b2b66e8c4a9b2c84b728a7ddede3c362";
    buildInputs = [ ghostscript cairo ];
  };

  "libspiro" = fetch {
    name        = "libspiro";
    version     = "1~0.5.20150702";
    filename    = "mingw-w64-x86_64-libspiro-1~0.5.20150702-2-any.pkg.tar.xz";
    sha256      = "6903ce050183122393c25eadc2552dc8e87810529d1ec419c0a905a33a30a4d4";
  };

  "libsquish" = fetch {
    name        = "libsquish";
    version     = "1.15";
    filename    = "mingw-w64-x86_64-libsquish-1.15-1-any.pkg.tar.xz";
    sha256      = "34a010dfdb6f028837e0168a0fdd9e5ceaa30ee5ad99dc0ff8481c4d4ba45b37";
    buildInputs = [  ];
  };

  "libsrtp" = fetch {
    name        = "libsrtp";
    version     = "2.2.0";
    filename    = "mingw-w64-x86_64-libsrtp-2.2.0-2-any.pkg.tar.xz";
    sha256      = "1054b5c6da6110e1159d2bed402cb1e67ae6350fed54e7ebeefbf99fbaad4197";
    buildInputs = [ openssl ];
  };

  "libssh" = fetch {
    name        = "libssh";
    version     = "0.8.6";
    filename    = "mingw-w64-x86_64-libssh-0.8.6-1-any.pkg.tar.xz";
    sha256      = "61a4553053aeb853b5085e70f153acafecde0d400a8019bf29b4fae0b40c828f";
    buildInputs = [ openssl zlib ];
  };

  "libssh2" = fetch {
    name        = "libssh2";
    version     = "1.8.0";
    filename    = "mingw-w64-x86_64-libssh2-1.8.0-3-any.pkg.tar.xz";
    sha256      = "d2d2e87363104f2fc3e92f304b10af98124f6a1a84055a1bc3685149e3d26a52";
    buildInputs = [ openssl zlib ];
  };

  "libswift" = fetch {
    name        = "libswift";
    version     = "1.0.0";
    filename    = "mingw-w64-x86_64-libswift-1.0.0-2-any.pkg.tar.xz";
    sha256      = "32e77dcabe2f7a39a36d0a4faf7d06b4f080fd948f83096ef659c79e349ee106";
    buildInputs = [ gcc-libs bzip2 libiconv libpng freetype glfw zlib ];
  };

  "libsystre" = fetch {
    name        = "libsystre";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-libsystre-1.0.1-4-any.pkg.tar.xz";
    sha256      = "c1b9ae045e24a91f261dc654d390ac63254d0ca5882d76b52d7722a9d49fef0c";
    buildInputs = [ libtre-git ];
  };

  "libtasn1" = fetch {
    name        = "libtasn1";
    version     = "4.13";
    filename    = "mingw-w64-x86_64-libtasn1-4.13-1-any.pkg.tar.xz";
    sha256      = "46d68fe5ff7e43a8aac9172728094e285df25093cbd20afdc70c0cfc102294d9";
    buildInputs = [ gcc-libs ];
  };

  "libthai" = fetch {
    name        = "libthai";
    version     = "0.1.28";
    filename    = "mingw-w64-x86_64-libthai-0.1.28-2-any.pkg.tar.xz";
    sha256      = "08fccebf976d125581599188d648de4451b252e763a7b1ee973ebf4780a17f27";
    buildInputs = [ libdatrie ];
  };

  "libtheora" = fetch {
    name        = "libtheora";
    version     = "1.1.1";
    filename    = "mingw-w64-x86_64-libtheora-1.1.1-4-any.pkg.tar.xz";
    sha256      = "2925a7af5cdcd21b62b71dfa4cf215a3da822ed61333ae9b5ce7dcfc81d6c34d";
    buildInputs = [ libpng libogg libvorbis ];
  };

  "libtiff" = fetch {
    name        = "libtiff";
    version     = "4.0.10";
    filename    = "mingw-w64-x86_64-libtiff-4.0.10-1-any.pkg.tar.xz";
    sha256      = "19539a881cc140c513036d549645329e7171fee4be2954d81594f5885fd137ac";
    buildInputs = [ gcc-libs libjpeg-turbo xz zlib zstd ];
  };

  "libtimidity" = fetch {
    name        = "libtimidity";
    version     = "0.2.6";
    filename    = "mingw-w64-x86_64-libtimidity-0.2.6-1-any.pkg.tar.xz";
    sha256      = "5c4f3231b9541932a21f484259986b23684a24c33ae96dfe2c1c9e70aa9c709b";
    buildInputs = [ gcc-libs ];
  };

  "libtommath" = fetch {
    name        = "libtommath";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-libtommath-1.0.1-1-any.pkg.tar.xz";
    sha256      = "a5c9b600736e718a47becab9b54f37f33801c47753819094ba1f6026b8ae85a4";
  };

  "libtool" = fetch {
    name        = "libtool";
    version     = "2.4.6";
    filename    = "mingw-w64-x86_64-libtool-2.4.6-13-any.pkg.tar.xz";
    sha256      = "5f907a818c25f2bc24dc7533a380a12bca1a6880fa31eb533af3ca8d6ef0ef62";
    buildInputs = [  ];
  };

  "libtorrent-rasterbar" = fetch {
    name        = "libtorrent-rasterbar";
    version     = "1.1.11";
    filename    = "mingw-w64-x86_64-libtorrent-rasterbar-1.1.11-1-any.pkg.tar.xz";
    sha256      = "a7721a644dee051e8331e141134b1b0ea93083172bf4ed778d7fd0687eec9bf3";
    buildInputs = [ boost openssl ];
  };

  "libtre-git" = fetch {
    name        = "libtre-git";
    version     = "r128.6fb7206";
    filename    = "mingw-w64-x86_64-libtre-git-r128.6fb7206-2-any.pkg.tar.xz";
    sha256      = "fd2c0e426a85c4193d34eea19411166495cb2fde58d0fac4e85422399062e336";
    buildInputs = [ gcc-libs gettext ];
  };

  "libunistring" = fetch {
    name        = "libunistring";
    version     = "0.9.10";
    filename    = "mingw-w64-x86_64-libunistring-0.9.10-1-any.pkg.tar.xz";
    sha256      = "189e135be68ffefa0442ab17a65b5dac417bd80ba487c3812c66af66bdc403e0";
    buildInputs = [ libiconv ];
  };

  "libunwind" = fetch {
    name        = "libunwind";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-libunwind-7.0.1-1-any.pkg.tar.xz";
    sha256      = "2793653fecfdbfbb643c63e21c472789a13b7cb281e9c01d889acdb289134058";
    buildInputs = [ gcc ];
  };

  "libusb" = fetch {
    name        = "libusb";
    version     = "1.0.22";
    filename    = "mingw-w64-x86_64-libusb-1.0.22-1-any.pkg.tar.xz";
    sha256      = "56fb3f418b686ba62acdcf9f180815e0feaaebf70cbee5b37ad595cf459368ab";
    buildInputs = [  ];
  };

  "libusb-compat-git" = fetch {
    name        = "libusb-compat-git";
    version     = "r72.92deb38";
    filename    = "mingw-w64-x86_64-libusb-compat-git-r72.92deb38-1-any.pkg.tar.xz";
    sha256      = "78a5fb92dfe5b85c02baf4409db8d26f0eaac1f43b17ee9913bd23b172f29ba3";
    buildInputs = [ libusb ];
  };

  "libusbmuxd" = fetch {
    name        = "libusbmuxd";
    version     = "1.0.10";
    filename    = "mingw-w64-x86_64-libusbmuxd-1.0.10-3-any.pkg.tar.xz";
    sha256      = "46867e51dad1e1136ba3555099cf55e44612a4acfe786829af726fb9dc846674";
    buildInputs = [ libplist ];
  };

  "libuv" = fetch {
    name        = "libuv";
    version     = "1.24.1";
    filename    = "mingw-w64-x86_64-libuv-1.24.1-1-any.pkg.tar.xz";
    sha256      = "bd856ca4793f1d131c0abd2fdc248c5dd78142cc44e83f7ab58ba64977b24627";
    buildInputs = [ gcc-libs ];
  };

  "libview" = fetch {
    name        = "libview";
    version     = "0.6.6";
    filename    = "mingw-w64-x86_64-libview-0.6.6-4-any.pkg.tar.xz";
    sha256      = "3528154b01afdc47bd4a4296199ddcb29d45196ece546709ab317d94cbb40134";
    buildInputs = [ gtk2 gtkmm ];
  };

  "libvirt" = fetch {
    name        = "libvirt";
    version     = "4.7.0";
    filename    = "mingw-w64-x86_64-libvirt-4.7.0-1-any.pkg.tar.xz";
    sha256      = "9254bb5f630bec80ef1023a4fed9adc19208a7f48b1b4aaf524829aa64764edb";
    buildInputs = [ curl gnutls gettext libgcrypt libgpg-error libxml2 portablexdr python2 ];
  };

  "libvirt-glib" = fetch {
    name        = "libvirt-glib";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-libvirt-glib-2.0.0-1-any.pkg.tar.xz";
    sha256      = "e97868e4870140f2d0f13f552144ed85a5d0bf6adcfd1cb946524a6cf420b667";
    buildInputs = [ glib2 libxml2 libvirt ];
  };

  "libvisio" = fetch {
    name        = "libvisio";
    version     = "0.1.6";
    filename    = "mingw-w64-x86_64-libvisio-0.1.6-3-any.pkg.tar.xz";
    sha256      = "f03d55b7819d15903c497bf5221cb4a9f26f7969954ae9000569e57da703ba79";
    buildInputs = [ icu libxml2 librevenge ];
  };

  "libvmime-git" = fetch {
    name        = "libvmime-git";
    version     = "r1129.a9b8221";
    filename    = "mingw-w64-x86_64-libvmime-git-r1129.a9b8221-1-any.pkg.tar.xz";
    sha256      = "da5bfc698b5221c175728cadd7ceeb3c5d35bcfc1fa36e861785e74cb0b3d66e";
    buildInputs = [ icu gnutls gsasl libiconv ];
  };

  "libvncserver" = fetch {
    name        = "libvncserver";
    version     = "0.9.11";
    filename    = "mingw-w64-x86_64-libvncserver-0.9.11-2-any.pkg.tar.xz";
    sha256      = "a785df417ad796a75b2a8c1d737c4b0119addbc204d98de9a806ccf0b206a9eb";
    buildInputs = [ libpng libjpeg gnutls libgcrypt openssl gcc-libs ];
  };

  "libvoikko" = fetch {
    name        = "libvoikko";
    version     = "4.2";
    filename    = "mingw-w64-x86_64-libvoikko-4.2-1-any.pkg.tar.xz";
    sha256      = "b7461c6b0833bbdbf15314d2958c2e085f26c96ab25c92b38877828f5dc32b25";
    buildInputs = [ gcc-libs ];
  };

  "libvorbis" = fetch {
    name        = "libvorbis";
    version     = "1.3.6";
    filename    = "mingw-w64-x86_64-libvorbis-1.3.6-1-any.pkg.tar.xz";
    sha256      = "468ea007a9f1910d20271691fef1495dc759eabd065a960431883e3b68945c60";
    buildInputs = [ libogg gcc-libs ];
  };

  "libvorbisidec-svn" = fetch {
    name        = "libvorbisidec-svn";
    version     = "r19643";
    filename    = "mingw-w64-x86_64-libvorbisidec-svn-r19643-1-any.pkg.tar.xz";
    sha256      = "eb76fda967692094cd4fbb93a2c6331ea61e56fd44d3b106d7055b3bcf6cc283";
    buildInputs = [ libogg ];
  };

  "libvpx" = fetch {
    name        = "libvpx";
    version     = "1.7.0";
    filename    = "mingw-w64-x86_64-libvpx-1.7.0-1-any.pkg.tar.xz";
    sha256      = "4e14f23a73801fc344125698f26f77c1505e062615d82708e3023547e6f446bf";
    buildInputs = [  ];
  };

  "libwebp" = fetch {
    name        = "libwebp";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-libwebp-1.0.1-1-any.pkg.tar.xz";
    sha256      = "35415748527b57103d2de37f54ce4d58ae2dfb557be7dbd05754c88c243f60e6";
    buildInputs = [ giflib libjpeg-turbo libpng libtiff ];
  };

  "libwebsockets" = fetch {
    name        = "libwebsockets";
    version     = "3.1.0";
    filename    = "mingw-w64-x86_64-libwebsockets-3.1.0-1-any.pkg.tar.xz";
    sha256      = "fcd64e5fdb6c27c4b2630a0d7e12abf2c2e470d623911aa4d1fa1cee380a0dba";
    buildInputs = [ zlib openssl ];
  };

  "libwinpthread-git" = fetch {
    name        = "libwinpthread-git";
    version     = "7.0.0.5273.3e5acf5d";
    filename    = "mingw-w64-x86_64-libwinpthread-git-7.0.0.5273.3e5acf5d-1-any.pkg.tar.xz";
    sha256      = "a7be31196969b1bda2d4ab5f191ec099db974b3db69366450c871df9ebd82207";
    buildInputs = [  ];
  };

  "libwmf" = fetch {
    name        = "libwmf";
    version     = "0.2.10";
    filename    = "mingw-w64-x86_64-libwmf-0.2.10-1-any.pkg.tar.xz";
    sha256      = "2b8fa2d1965ede1ebbf96756091a713930b09a1b031fc930ac13633f2e2bfa37";
    buildInputs = [ gcc-libs freetype gdk-pixbuf2 libjpeg libpng libxml2 zlib ];
  };

  "libwpd" = fetch {
    name        = "libwpd";
    version     = "0.10.2";
    filename    = "mingw-w64-x86_64-libwpd-0.10.2-1-any.pkg.tar.xz";
    sha256      = "fbcad80743200613d4751881e68a92826e81b3e4fcd7e44dad07ea675e83d066";
    buildInputs = [ gcc-libs librevenge xz zlib ];
  };

  "libwpg" = fetch {
    name        = "libwpg";
    version     = "0.3.2";
    filename    = "mingw-w64-x86_64-libwpg-0.3.2-1-any.pkg.tar.xz";
    sha256      = "a424473ad57797924ed2ae065998a65ab6bc50ac7198add2b43e96dbbab69aa0";
    buildInputs = [ gcc-libs librevenge libwpd ];
  };

  "libxlsxwriter" = fetch {
    name        = "libxlsxwriter";
    version     = "0.8.4";
    filename    = "mingw-w64-x86_64-libxlsxwriter-0.8.4-1-any.pkg.tar.xz";
    sha256      = "ad12f7078aa46b06b0b060d6dde8da94a18ba3ec7c0d27ee7b95a63d44a5a52e";
    buildInputs = [ gcc-libs zlib ];
  };

  "libxml++" = fetch {
    name        = "libxml++";
    version     = "3.0.1";
    filename    = "mingw-w64-x86_64-libxml++-3.0.1-1-any.pkg.tar.xz";
    sha256      = "ac6744c4a2d876d33d359d174be3fc9e5064257f52ffff50d160afc94db80dd7";
    buildInputs = [ gcc-libs libxml2 glibmm ];
  };

  "libxml++2.6" = fetch {
    name        = "libxml++2.6";
    version     = "2.40.1";
    filename    = "mingw-w64-x86_64-libxml++2.6-2.40.1-1-any.pkg.tar.xz";
    sha256      = "f1229e14217ec8c7d39836ba714a3b1db49be45d3d83034fdbb4bb2992d6e3c8";
    buildInputs = [ gcc-libs libxml2 glibmm ];
  };

  "libxml2" = fetch {
    name        = "libxml2";
    version     = "2.9.8";
    filename    = "mingw-w64-x86_64-libxml2-2.9.8-1-any.pkg.tar.xz";
    sha256      = "ee1598c0b025081ccf65bd3aaccc8ac29c7354e55553711fcd4fbb51b74cef0e";
    buildInputs = [ gcc-libs gettext xz zlib ];
  };

  "libxslt" = fetch {
    name        = "libxslt";
    version     = "1.1.32";
    filename    = "mingw-w64-x86_64-libxslt-1.1.32-1-any.pkg.tar.xz";
    sha256      = "cf60b2dff0884e2abe7e3144a64e7b366b4a8520ec074b74c0b6763302c0b07d";
    buildInputs = [ gcc-libs libxml2 libgcrypt ];
  };

  "libyaml" = fetch {
    name        = "libyaml";
    version     = "0.2.1";
    filename    = "mingw-w64-x86_64-libyaml-0.2.1-1-any.pkg.tar.xz";
    sha256      = "98ed7cddeefa448c6f3de523005e104dfd8e8a83cfe2885d3f71a716a0a3636d";
    buildInputs = [  ];
  };

  "libzip" = fetch {
    name        = "libzip";
    version     = "1.5.1";
    filename    = "mingw-w64-x86_64-libzip-1.5.1-1-any.pkg.tar.xz";
    sha256      = "e4813f59f71643f877fc666307096e5c2d511989b270fdb0c7388f02afb286e5";
    buildInputs = [ bzip2 gnutls nettle zlib ];
  };

  "live-media" = fetch {
    name        = "live-media";
    version     = "2018.10.17";
    filename    = "mingw-w64-x86_64-live-media-2018.10.17-1-any.pkg.tar.xz";
    sha256      = "a47dcc6152e6477c690b4699ae93770a372a896d930ab465a4963bda16847bca";
    buildInputs = [ gcc ];
  };

  "lld" = fetch {
    name        = "lld";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-lld-7.0.1-1-any.pkg.tar.xz";
    sha256      = "1fd6db942ec1f38226061cbb149c0dc92d779d9075e2cb8b2718d5696ab43764";
    buildInputs = [ gcc ];
  };

  "lldb" = fetch {
    name        = "lldb";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-lldb-7.0.1-1-any.pkg.tar.xz";
    sha256      = "f510f8d4fe61f9e1efbabbcc3ed8d2017b4a4c99e38ff965f644fcbecbc90ddb";
    buildInputs = [ libxml2 llvm python2 readline swig ];
  };

  "llvm" = fetch {
    name        = "llvm";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-llvm-7.0.1-1-any.pkg.tar.xz";
    sha256      = "32663a6978e266bc9d550e6b3baecb70e3db2e44356aa39c050dae9fd060d487";
    buildInputs = [ libffi gcc-libs ];
  };

  "lmdb" = fetch {
    name        = "lmdb";
    version     = "0.9.23";
    filename    = "mingw-w64-x86_64-lmdb-0.9.23-1-any.pkg.tar.xz";
    sha256      = "b0039afdc97a2e2cf11200b251bae5cfd8e82114394c616b0d915245b585ba24";
  };

  "lmdbxx" = fetch {
    name        = "lmdbxx";
    version     = "0.9.14.0";
    filename    = "mingw-w64-x86_64-lmdbxx-0.9.14.0-1-any.pkg.tar.xz";
    sha256      = "14a9986ca3e4c05664c5065dcf3f7b4f75e84a43bd7ff519163f5b64c6f709c8";
    buildInputs = [ lmdb ];
  };

  "lpsolve" = fetch {
    name        = "lpsolve";
    version     = "5.5.2.5";
    filename    = "mingw-w64-x86_64-lpsolve-5.5.2.5-1-any.pkg.tar.xz";
    sha256      = "2a450b66f893dc25c25ed5f2c28d5cf4c81252946b1a460848af21d77bee8b7a";
    buildInputs = [ gcc-libs ];
  };

  "lua" = fetch {
    name        = "lua";
    version     = "5.3.5";
    filename    = "mingw-w64-x86_64-lua-5.3.5-1-any.pkg.tar.xz";
    sha256      = "c3f81a48b8050ea1e2ec9a081f52caaa80db509913f271bdb2e7acf6d3e8746a";
    buildInputs = [ winpty ];
    broken      = true;
  };

  "lua-lpeg" = fetch {
    name        = "lua-lpeg";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-lua-lpeg-1.0.1-1-any.pkg.tar.xz";
    sha256      = "35d595850df8e8b8027168ab063fe5c8a155126c74a6fde19cb54349e733b76f";
    buildInputs = [ lua ];
    broken      = true;
  };

  "lua-mpack" = fetch {
    name        = "lua-mpack";
    version     = "1.0.7";
    filename    = "mingw-w64-x86_64-lua-mpack-1.0.7-1-any.pkg.tar.xz";
    sha256      = "1fae12bef250ff1c7868d7ac94e884e5ef96d171ebe6c0af84cba1687b63e3ba";
    buildInputs = [ lua libmpack ];
    broken      = true;
  };

  "lua51" = fetch {
    name        = "lua51";
    version     = "5.1.5";
    filename    = "mingw-w64-x86_64-lua51-5.1.5-4-any.pkg.tar.xz";
    sha256      = "b1dcf14e61ea42e7f52d396420fd4b6b186d29698aa3dcd74b36f1b63328b4e2";
    buildInputs = [ winpty ];
    broken      = true;
  };

  "lua51-bitop" = fetch {
    name        = "lua51-bitop";
    version     = "1.0.2";
    filename    = "mingw-w64-x86_64-lua51-bitop-1.0.2-1-any.pkg.tar.xz";
    sha256      = "d9f69ab4d523f67cb34045c0397e60b2e318515befadb885bd68645ed496575e";
    buildInputs = [ lua51 ];
    broken      = true;
  };

  "lua51-lgi" = fetch {
    name        = "lua51-lgi";
    version     = "0.9.2";
    filename    = "mingw-w64-x86_64-lua51-lgi-0.9.2-1-any.pkg.tar.xz";
    sha256      = "9a18b49937d2785373dec032d181feb9680cc7679c3eb633252e98280498d30a";
    buildInputs = [ lua51 gtk3 gobject-introspection ];
    broken      = true;
  };

  "lua51-lpeg" = fetch {
    name        = "lua51-lpeg";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-lua51-lpeg-1.0.1-1-any.pkg.tar.xz";
    sha256      = "668a538c58b79068df09033a40b56abc3635adbfdea0313f44a171efef9bae6d";
    buildInputs = [ lua51 ];
    broken      = true;
  };

  "lua51-lsqlite3" = fetch {
    name        = "lua51-lsqlite3";
    version     = "0.9.3";
    filename    = "mingw-w64-x86_64-lua51-lsqlite3-0.9.3-1-any.pkg.tar.xz";
    sha256      = "3eb1e9f05559439cb8367a34d2d6e04e8ad36c8e9604e9c378d73c1752fd7d4b";
    buildInputs = [ lua51 sqlite3 ];
    broken      = true;
  };

  "lua51-luarocks" = fetch {
    name        = "lua51-luarocks";
    version     = "2.4.4";
    filename    = "mingw-w64-x86_64-lua51-luarocks-2.4.4-1-any.pkg.tar.xz";
    sha256      = "dd9431ab938a54ef55a4d1a0aab02d46de08f6d48610f63e5d7a1c762f0fa7cb";
    buildInputs = [ lua51 ];
    broken      = true;
  };

  "lua51-mpack" = fetch {
    name        = "lua51-mpack";
    version     = "1.0.7";
    filename    = "mingw-w64-x86_64-lua51-mpack-1.0.7-1-any.pkg.tar.xz";
    sha256      = "95f58aa8feead58283badd3a8dcc358bab10a5b4e7bcb2269afbdda2731ddcbd";
    buildInputs = [ lua51 libmpack ];
    broken      = true;
  };

  "lua51-winapi" = fetch {
    name        = "lua51-winapi";
    version     = "1.4.2";
    filename    = "mingw-w64-x86_64-lua51-winapi-1.4.2-1-any.pkg.tar.xz";
    sha256      = "b8bfb7af2812f0ccee89f9f8a062dddeccac74841fdf9549ea56349060371886";
    buildInputs = [ lua51 ];
    broken      = true;
  };

  "luabind-git" = fetch {
    name        = "luabind-git";
    version     = "0.9.1.144.ge414c57";
    filename    = "mingw-w64-x86_64-luabind-git-0.9.1.144.ge414c57-1-any.pkg.tar.xz";
    sha256      = "3df039eff4fe41af747e48c03c68ed5e8b19c00dbc3150b6dc0be754417feb80";
    buildInputs = [ boost lua51 ];
    broken      = true;
  };

  "luajit-git" = fetch {
    name        = "luajit-git";
    version     = "2.0.4.49.ga68c411";
    filename    = "mingw-w64-x86_64-luajit-git-2.0.4.49.ga68c411-1-any.pkg.tar.xz";
    sha256      = "d4a92cc968fccd692c4e56ad375cde871880aed3d2c8c74116e10c1f56e5c672";
    buildInputs = [ winpty ];
    broken      = true;
  };

  "lz4" = fetch {
    name        = "lz4";
    version     = "1.8.3";
    filename    = "mingw-w64-x86_64-lz4-1.8.3-1-any.pkg.tar.xz";
    sha256      = "259f0e1d65bb8430def0b73bc9dff2ee0c06b2584aa11f56f4c94a246191d842";
    buildInputs = [ gcc-libs ];
  };

  "lzo2" = fetch {
    name        = "lzo2";
    version     = "2.10";
    filename    = "mingw-w64-x86_64-lzo2-2.10-1-any.pkg.tar.xz";
    sha256      = "277ba86026266f82646e0be3287d8560a0b993d1ec035567b64386dd4f1424d6";
    buildInputs = [  ];
  };

  "make" = fetch {
    name        = "make";
    version     = "4.2.1";
    filename    = "mingw-w64-x86_64-make-4.2.1-2-any.pkg.tar.xz";
    sha256      = "6c41b2feea5b797619d7464f1ccad16ae9631dc6a71432855b4bf8ce0224eee8";
    buildInputs = [ gettext ];
  };

  "mathgl" = fetch {
    name        = "mathgl";
    version     = "2.4.2";
    filename    = "mingw-w64-x86_64-mathgl-2.4.2-1-any.pkg.tar.xz";
    sha256      = "f45ca4e81367d21f494b69651b6247bf9ac548fb72b7db3bd1aaec640b28f5f8";
    buildInputs = [ hdf5 fltk libharu libjpeg-turbo libpng giflib qt5 freeglut wxWidgets ];
    broken      = true;
  };

  "matio" = fetch {
    name        = "matio";
    version     = "1.5.13";
    filename    = "mingw-w64-x86_64-matio-1.5.13-1-any.pkg.tar.xz";
    sha256      = "a69c087b25786dd94aa5ead3da9b9f4e8d982b3f178c7a74ec2007e560b4a13a";
    buildInputs = [ gcc-libs zlib hdf5 ];
  };

  "mbedtls" = fetch {
    name        = "mbedtls";
    version     = "2.14.0";
    filename    = "mingw-w64-x86_64-mbedtls-2.14.0-1-any.pkg.tar.xz";
    sha256      = "d7021356eef6978d042fb4f5ff36ff36e13589b5f08ad5446718568a81558c79";
    buildInputs = [ gcc-libs ];
  };

  "mcpp" = fetch {
    name        = "mcpp";
    version     = "2.7.2";
    filename    = "mingw-w64-x86_64-mcpp-2.7.2-2-any.pkg.tar.xz";
    sha256      = "c66f2470ff981408e254cab854049bcd1c2f3f110ce01b827587642ef8f1aa72";
    buildInputs = [ gcc-libs libiconv ];
  };

  "meanwhile" = fetch {
    name        = "meanwhile";
    version     = "1.0.2";
    filename    = "mingw-w64-x86_64-meanwhile-1.0.2-4-any.pkg.tar.xz";
    sha256      = "f957872cf98c737a8bdf6451169aec642170467dc3128ea48e74abea5a68007f";
    buildInputs = [ glib2 ];
  };

  "meld3" = fetch {
    name        = "meld3";
    version     = "3.19.1";
    filename    = "mingw-w64-x86_64-meld3-3.19.1-1-any.pkg.tar.xz";
    sha256      = "ecd8a21d9655ca4e9032a19c71d7a3c290ee5e44e0594e3581c9d40843658270";
    buildInputs = [ gtk3 gtksourceview3 adwaita-icon-theme gsettings-desktop-schemas python3-gobject ];
  };

  "memphis" = fetch {
    name        = "memphis";
    version     = "0.2.3";
    filename    = "mingw-w64-x86_64-memphis-0.2.3-4-any.pkg.tar.xz";
    sha256      = "cf588ca4c8a4d42eec97979e8f51f86a110133c7b96762d880b9802980d98a3e";
    buildInputs = [ glib2 cairo expat ];
  };

  "mesa" = fetch {
    name        = "mesa";
    version     = "18.3.1";
    filename    = "mingw-w64-x86_64-mesa-18.3.1-1-any.pkg.tar.xz";
    sha256      = "cf30b3e4b314f13b88acd9d9cc591a2066d554a985c91e2baaec22bc043f893f";
  };

  "meson" = fetch {
    name        = "meson";
    version     = "0.49.0";
    filename    = "mingw-w64-x86_64-meson-0.49.0-1-any.pkg.tar.xz";
    sha256      = "fb44a43b1ab2f4ab834579bfc9028e1344d5e219db5b069ce0bdb408e28784c4";
    buildInputs = [ python3 python3-setuptools ninja ];
  };

  "metis" = fetch {
    name        = "metis";
    version     = "5.1.0";
    filename    = "mingw-w64-x86_64-metis-5.1.0-2-any.pkg.tar.xz";
    sha256      = "9f446a9ee1ac42cbde63edf204c85f55abaade70f0f144eabf8cdab1ae1627eb";
    buildInputs = [  ];
  };

  "mhook" = fetch {
    name        = "mhook";
    version     = "r7.a159eed";
    filename    = "mingw-w64-x86_64-mhook-r7.a159eed-1-any.pkg.tar.xz";
    sha256      = "3fd710b8b43d3f56a175579558aae68ebef28c7d519fcfc6587aa4040f53a371";
    buildInputs = [ gcc-libs ];
  };

  "minisign" = fetch {
    name        = "minisign";
    version     = "0.8";
    filename    = "mingw-w64-x86_64-minisign-0.8-1-any.pkg.tar.xz";
    sha256      = "db669abbde70cee8c00e45004ee189e8587e719922d59f25c1b21c48b1b97305";
    buildInputs = [ libsodium ];
  };

  "miniupnpc" = fetch {
    name        = "miniupnpc";
    version     = "2.1";
    filename    = "mingw-w64-x86_64-miniupnpc-2.1-2-any.pkg.tar.xz";
    sha256      = "3af47df4213446f8a8c7fbed6df1f1d3800e873638732b6cfb4f10c341c1573d";
    buildInputs = [ gcc-libs ];
  };

  "minizip2" = fetch {
    name        = "minizip2";
    version     = "2.7.0";
    filename    = "mingw-w64-x86_64-minizip2-2.7.0-1-any.pkg.tar.xz";
    sha256      = "8143c4581306ba48b192917133d923eb965057699614c3fdc4b8b8019bebca92";
    buildInputs = [ bzip2 gcc-libs zlib ];
  };

  "mlpack" = fetch {
    name        = "mlpack";
    version     = "1.0.12";
    filename    = "mingw-w64-x86_64-mlpack-1.0.12-2-any.pkg.tar.xz";
    sha256      = "2d87ebc21c82baf3269796fa8cf8794f9ef77ef77f55b4edc0437ecfc2e3f93b";
    buildInputs = [ gcc-libs armadillo boost libxml2 ];
  };

  "mono" = fetch {
    name        = "mono";
    version     = "5.10.1.47";
    filename    = "mingw-w64-x86_64-mono-5.10.1.47-1-any.pkg.tar.xz";
    sha256      = "a4818603f35491565650d5ec6312b28e3512a059bf8e2429be8b86091a5b5b1a";
    buildInputs = [ zlib gcc-libs winpthreads-git libgdiplus python3 ca-certificates ];
  };

  "mono-basic" = fetch {
    name        = "mono-basic";
    version     = "4.6";
    filename    = "mingw-w64-x86_64-mono-basic-4.6-1-any.pkg.tar.xz";
    sha256      = "380e7dc95a1de8161ad64e9292ebb3d5405f870cbf79bbcf2d210ac143dfb368";
    buildInputs = [ mono ];
  };

  "mpc" = fetch {
    name        = "mpc";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-mpc-1.1.0-1-any.pkg.tar.xz";
    sha256      = "d7c59f4e347a86e1cf1c539277fd3e43096846642b1cdf764cae1a8a4e783374";
    buildInputs = [ mpfr ];
  };

  "mpdecimal" = fetch {
    name        = "mpdecimal";
    version     = "2.4.2";
    filename    = "mingw-w64-x86_64-mpdecimal-2.4.2-1-any.pkg.tar.xz";
    sha256      = "3e40d68e794d0390857e9a3dc808e42e4b48c13d2807081343fd07a07fbf14f9";
    buildInputs = [ gcc-libs ];
  };

  "mpfr" = fetch {
    name        = "mpfr";
    version     = "4.0.1";
    filename    = "mingw-w64-x86_64-mpfr-4.0.1-2-any.pkg.tar.xz";
    sha256      = "ff8633b993ac677a70fe8dec6c9836e0c39e4072804091268e87a71301d82808";
    buildInputs = [ gmp ];
  };

  "mpg123" = fetch {
    name        = "mpg123";
    version     = "1.25.10";
    filename    = "mingw-w64-x86_64-mpg123-1.25.10-1-any.pkg.tar.xz";
    sha256      = "d46daede6a0f3f062b8aea6533587bd9b093d0d89c996a628c97fdd9511fb2b3";
    buildInputs = [ libtool gcc-libs ];
  };

  "mpv" = fetch {
    name        = "mpv";
    version     = "0.29.1";
    filename    = "mingw-w64-x86_64-mpv-0.29.1-1-any.pkg.tar.xz";
    sha256      = "46fd2d20e0ce5fcbb556bd14dca3ea3edfd0ab2505a8fa4e95665c1924a77e57";
    buildInputs = [ angleproject-git ffmpeg lcms2 libarchive libass libbluray libcaca libcdio libcdio-paranoia libdvdnav libdvdread libjpeg-turbo lua51 rubberband uchardet vapoursynth vulkan winpty ];
    broken      = true;
  };

  "mruby" = fetch {
    name        = "mruby";
    version     = "1.4.1";
    filename    = "mingw-w64-x86_64-mruby-1.4.1-1-any.pkg.tar.xz";
    sha256      = "76bbf6df2b631f6f260d71ea23bc609a0df33e69214068aba69ebc1a3eec5e91";
  };

  "mscgen" = fetch {
    name        = "mscgen";
    version     = "0.20";
    filename    = "mingw-w64-x86_64-mscgen-0.20-1-any.pkg.tar.xz";
    sha256      = "5823381d52e5217d49a0ff75b7977d217dd6a9ed91ba8bc726e3bea798a4699f";
    buildInputs = [ libgd ];
  };

  "msgpack-c" = fetch {
    name        = "msgpack-c";
    version     = "3.1.1";
    filename    = "mingw-w64-x86_64-msgpack-c-3.1.1-1-any.pkg.tar.xz";
    sha256      = "5c8d88109288ea4ee29217b274c4525e246617102cf944e27453c3ae48f6af74";
  };

  "msmtp" = fetch {
    name        = "msmtp";
    version     = "1.8.1";
    filename    = "mingw-w64-x86_64-msmtp-1.8.1-1-any.pkg.tar.xz";
    sha256      = "a424c053626e1e1604263002fb4ce1eb265a800f086707d7919d3ac238bf48b8";
    buildInputs = [ gettext gnutls gsasl libffi libidn libwinpthread-git ];
  };

  "mtex2MML" = fetch {
    name        = "mtex2MML";
    version     = "1.3.1";
    filename    = "mingw-w64-x86_64-mtex2MML-1.3.1-1-any.pkg.tar.xz";
    sha256      = "b5043b9c17f8f0582a8f4d0a2f69ba7dd9ee3ace3373ad880be026217b9a8c43";
  };

  "muparser" = fetch {
    name        = "muparser";
    version     = "2.2.6";
    filename    = "mingw-w64-x86_64-muparser-2.2.6-1-any.pkg.tar.xz";
    sha256      = "c8685dbac762c00cf409ce30cb9201d9e26091cb19cbe1117f33b5174a004abc";
  };

  "mypaint" = fetch {
    name        = "mypaint";
    version     = "1.2.1";
    filename    = "mingw-w64-x86_64-mypaint-1.2.1-1-any.pkg.tar.xz";
    sha256      = "11f2742f49cd7dba0d66228b2f72bfb977a031cb11e32c592ba255f76cbce4a1";
    buildInputs = [ gtk3 python2-numpy json-c lcms2 python2-cairo python2-gobject adwaita-icon-theme librsvg gcc-libs gsettings-desktop-schemas hicolor-icon-theme ];
  };

  "mypaint-brushes" = fetch {
    name        = "mypaint-brushes";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-mypaint-brushes-1.3.0-1-any.pkg.tar.xz";
    sha256      = "676c7da5d2fb1fdbb21e49b51efb83603c74602d7fe3223bc8e9975245a611ac";
    buildInputs = [ libmypaint ];
  };

  "mypaint-brushes2" = fetch {
    name        = "mypaint-brushes2";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-mypaint-brushes2-2.0.0-1-any.pkg.tar.xz";
    sha256      = "4b2e4c7f878475e07b93a63065210f0d4c272e9c4dbb7fed89fe356c48d1a051";
  };

  "nanodbc" = fetch {
    name        = "nanodbc";
    version     = "2.12.4";
    filename    = "mingw-w64-x86_64-nanodbc-2.12.4-2-any.pkg.tar.xz";
    sha256      = "7b405aa003df4c38fd29df40a77973dc21ae2cd146e95a4e745cf384114719fa";
  };

  "nanovg-git" = fetch {
    name        = "nanovg-git";
    version     = "r259.6ae0873";
    filename    = "mingw-w64-x86_64-nanovg-git-r259.6ae0873-1-any.pkg.tar.xz";
    sha256      = "fac9b7af510749c8549dc56efb8fa5682f401b01242cd3aaa6d78734ff41cdf7";
  };

  "nasm" = fetch {
    name        = "nasm";
    version     = "2.14.01";
    filename    = "mingw-w64-x86_64-nasm-2.14.01-1-any.pkg.tar.xz";
    sha256      = "6cb99f1dedcb9b951d63c03c81ba324419b38e0a8e333f9f953d643b925a2d62";
  };

  "ncurses" = fetch {
    name        = "ncurses";
    version     = "6.1.20180908";
    filename    = "mingw-w64-x86_64-ncurses-6.1.20180908-1-any.pkg.tar.xz";
    sha256      = "df55f82af15244164e725f568067312ad0c223c2ee39b40381c36193be94b5f4";
    buildInputs = [ libsystre ];
  };

  "netcdf" = fetch {
    name        = "netcdf";
    version     = "4.6.2";
    filename    = "mingw-w64-x86_64-netcdf-4.6.2-1-any.pkg.tar.xz";
    sha256      = "6bdb90e3013538a96b0ddcd1931bb2da58949721a6e9b4d52a23c8db831964f3";
    buildInputs = [ hdf5 ];
  };

  "nettle" = fetch {
    name        = "nettle";
    version     = "3.4.1";
    filename    = "mingw-w64-x86_64-nettle-3.4.1-1-any.pkg.tar.xz";
    sha256      = "c56a06c771599ffeccec5ff79e33dfa862488b4e3c90690589b66abcbac8f02c";
    buildInputs = [ gcc-libs gmp ];
  };

  "nghttp2" = fetch {
    name        = "nghttp2";
    version     = "1.35.1";
    filename    = "mingw-w64-x86_64-nghttp2-1.35.1-1-any.pkg.tar.xz";
    sha256      = "e7d38f51546ce869a6c05481d62281c5bdd3c3509ae9e06b9656bac277793a56";
    buildInputs = [ jansson jemalloc openssl c-ares ];
  };

  "ngraph-gtk" = fetch {
    name        = "ngraph-gtk";
    version     = "6.08.00";
    filename    = "mingw-w64-x86_64-ngraph-gtk-6.08.00-1-any.pkg.tar.xz";
    sha256      = "ef429e300af3579634cf049f984b0c87b266a0152c83cecd146b71a33203b906";
    buildInputs = [ adwaita-icon-theme gsettings-desktop-schemas gtk3 gtksourceview3 readline gsl ruby ];
  };

  "ngspice" = fetch {
    name        = "ngspice";
    version     = "29";
    filename    = "mingw-w64-x86_64-ngspice-29-1-any.pkg.tar.xz";
    sha256      = "7535feec68e17554bdbf5a8dc813f1b98ca4b47ecae006ecafb84f3f23858d87";
    buildInputs = [ gcc-libs ];
  };

  "nim" = fetch {
    name        = "nim";
    version     = "0.19.0";
    filename    = "mingw-w64-x86_64-nim-0.19.0-3-any.pkg.tar.xz";
    sha256      = "87a8f8105c23be2729d35c877653aff985d419bb718002f345c279ea5a4e3ee2";
  };

  "nimble" = fetch {
    name        = "nimble";
    version     = "0.9.0";
    filename    = "mingw-w64-x86_64-nimble-0.9.0-1-any.pkg.tar.xz";
    sha256      = "ad564251edd8b1af4dcb5c5118aec7c0988723c6d754b769f575843099d70eae";
  };

  "ninja" = fetch {
    name        = "ninja";
    version     = "1.8.2";
    filename    = "mingw-w64-x86_64-ninja-1.8.2-3-any.pkg.tar.xz";
    sha256      = "df0abaa202801ecd9d083b9f329cdd69650ef459aa00e90d7536965981688bd2";
    buildInputs = [  ];
  };

  "nlopt" = fetch {
    name        = "nlopt";
    version     = "2.5.0";
    filename    = "mingw-w64-x86_64-nlopt-2.5.0-1-any.pkg.tar.xz";
    sha256      = "6d47904ffaa585b14d676940d14b886e6ae63dec83c3c726691e993edcd820df";
  };

  "nodejs" = fetch {
    name        = "nodejs";
    version     = "8.11.1";
    filename    = "mingw-w64-x86_64-nodejs-8.11.1-5-any.pkg.tar.xz";
    sha256      = "ccac4b7fd8f40946325091297d22c73f2d658633fc6d6063ad2c61e0ad021488";
    buildInputs = [ c-ares http-parser icu libuv openssl zlib winpty ];
    broken      = true;
  };

  "npth" = fetch {
    name        = "npth";
    version     = "1.6";
    filename    = "mingw-w64-x86_64-npth-1.6-1-any.pkg.tar.xz";
    sha256      = "7a765395dedb1294b700c7a96a9e8e0eb314372640382b6fa6cd90c0e223339a";
    buildInputs = [ gcc-libs ];
  };

  "nsis" = fetch {
    name        = "nsis";
    version     = "3.04";
    filename    = "mingw-w64-x86_64-nsis-3.04-1-any.pkg.tar.xz";
    sha256      = "9708652fd3e7910fa4f16ff0262f5cca0498942350f41b99ed8ac5dd4f75dbc4";
    buildInputs = [ zlib gcc-libs libwinpthread-git ];
  };

  "nsis-nsisunz" = fetch {
    name        = "nsis-nsisunz";
    version     = "1.0";
    filename    = "mingw-w64-x86_64-nsis-nsisunz-1.0-1-any.pkg.tar.xz";
    sha256      = "d3cf4ff6ddde3c301b46eb6a0309ef9c008d7b7ebaad920e21754a10ddc0388c";
    buildInputs = [ nsis ];
  };

  "nspr" = fetch {
    name        = "nspr";
    version     = "4.20";
    filename    = "mingw-w64-x86_64-nspr-4.20-1-any.pkg.tar.xz";
    sha256      = "2f72e87ec35d8b2f97cb97f355c61a0d195bef761fca2a0319933ce875c0e01d";
    buildInputs = [ gcc-libs ];
  };

  "nss" = fetch {
    name        = "nss";
    version     = "3.41";
    filename    = "mingw-w64-x86_64-nss-3.41-1-any.pkg.tar.xz";
    sha256      = "ddada632e9711c01b718250481d7c3da99a3a637a89c5afb3e76e791949e9d71";
    buildInputs = [ nspr sqlite3 zlib ];
  };

  "ntldd-git" = fetch {
    name        = "ntldd-git";
    version     = "r15.e7622f6";
    filename    = "mingw-w64-x86_64-ntldd-git-r15.e7622f6-2-any.pkg.tar.xz";
    sha256      = "db3ad7e98022ad89d20f4fd6d43928e5d4cc8795f855dd14901d7c9dda26cd1c";
  };

  "ocaml" = fetch {
    name        = "ocaml";
    version     = "4.04.0";
    filename    = "mingw-w64-x86_64-ocaml-4.04.0-1-any.pkg.tar.xz";
    sha256      = "f94f3a1979c9963b81637a8422f2f8187e7f75fad6334965572e068b5df4825f";
    buildInputs = [ flexdll ];
  };

  "ocaml-findlib" = fetch {
    name        = "ocaml-findlib";
    version     = "1.7.1";
    filename    = "mingw-w64-x86_64-ocaml-findlib-1.7.1-1-any.pkg.tar.xz";
    sha256      = "d03eff18c8f20b8f68e461a7f34a56385c7190ef06df5ba14175a9280059d529";
    buildInputs = [ ocaml msys2-runtime ];
    broken      = true;
  };

  "oce" = fetch {
    name        = "oce";
    version     = "0.18.3";
    filename    = "mingw-w64-x86_64-oce-0.18.3-1-any.pkg.tar.xz";
    sha256      = "136bed35dce6a7ce4b7ab922b78ac3d9da7ca4022c35b3dae7a431688e86b526";
    buildInputs = [ freetype ];
  };

  "octopi-git" = fetch {
    name        = "octopi-git";
    version     = "r941.6df0f8a";
    filename    = "mingw-w64-x86_64-octopi-git-r941.6df0f8a-1-any.pkg.tar.xz";
    sha256      = "24b91b606c133c483425deaa1d6b802fd076d179687909da7f2759d59655e63a";
    buildInputs = [ gcc-libs ];
  };

  "odt2txt" = fetch {
    name        = "odt2txt";
    version     = "0.5";
    filename    = "mingw-w64-x86_64-odt2txt-0.5-2-any.pkg.tar.xz";
    sha256      = "596f6ae3c814deb881f5ccd1b025ae91f3e45d9a814d9e9de804ab1472fc2ff3";
    buildInputs = [ libiconv libzip pcre ];
  };

  "ogitor-git" = fetch {
    name        = "ogitor-git";
    version     = "r816.cf42232";
    filename    = "mingw-w64-x86_64-ogitor-git-r816.cf42232-1-any.pkg.tar.xz";
    sha256      = "fe61c39cab2470d47b78f73f535c36360efe3e21fbe06c577730491b55e4a0c9";
    buildInputs = [ libwinpthread-git ogre3d boost qt5 ];
    broken      = true;
  };

  "ogre3d" = fetch {
    name        = "ogre3d";
    version     = "1.11.1";
    filename    = "mingw-w64-x86_64-ogre3d-1.11.1-1-any.pkg.tar.xz";
    sha256      = "0857aacae013a5c5661630318489e487946021a9c3db74ac88b2c3cb884c1cc3";
    buildInputs = [ boost cppunit FreeImage freetype glsl-optimizer-git hlsl2glsl-git intel-tbb openexr SDL2 python2 tinyxml winpthreads-git zlib zziplib ];
    broken      = true;
  };

  "ois-git" = fetch {
    name        = "ois-git";
    version     = "1.4.0.124.564dd81";
    filename    = "mingw-w64-x86_64-ois-git-1.4.0.124.564dd81-1-any.pkg.tar.xz";
    sha256      = "b8ae160d58e0db9ff3bf401603effa12e5c50b91632f78aeb9ce4cc5c19a35b9";
    buildInputs = [ gcc-libs ];
  };

  "oniguruma" = fetch {
    name        = "oniguruma";
    version     = "6.9.1";
    filename    = "mingw-w64-x86_64-oniguruma-6.9.1-1-any.pkg.tar.xz";
    sha256      = "41dddf345aa8a713b826c4cc011bdf177dbcab7affdf5d2f1b3e28e34006b7fa";
    buildInputs = [  ];
  };

  "openal" = fetch {
    name        = "openal";
    version     = "1.19.1";
    filename    = "mingw-w64-x86_64-openal-1.19.1-1-any.pkg.tar.xz";
    sha256      = "3f19eb8c1c7e687f3c5e903e5ef125253203e7ea7a03a9aaab4a6e8e4957d11e";
    buildInputs = [  ];
  };

  "openblas" = fetch {
    name        = "openblas";
    version     = "0.3.4";
    filename    = "mingw-w64-x86_64-openblas-0.3.4-1-any.pkg.tar.xz";
    sha256      = "0f6488d24248daf44665bccae92f2bfa4d9027cf9dd3b7c5827ec685e2d2b3f8";
    buildInputs = [ gcc-libs gcc-libgfortran libwinpthread-git ];
  };

  "opencl-headers" = fetch {
    name        = "opencl-headers";
    version     = "2~2.2.20170516";
    filename    = "mingw-w64-x86_64-opencl-headers-2~2.2.20170516-1-any.pkg.tar.xz";
    sha256      = "6909c9698e3868da29f6f94aede2e641878792404a87da88566b6acfa63560b4";
  };

  "opencollada-git" = fetch {
    name        = "opencollada-git";
    version     = "r1687.d826fd08";
    filename    = "mingw-w64-x86_64-opencollada-git-r1687.d826fd08-1-any.pkg.tar.xz";
    sha256      = "552a14e56c9dee5f07f0251e1bec5f387129eed1b990c4ef6fd4966c34225b06";
    buildInputs = [ libxml2 pcre ];
  };

  "opencolorio-git" = fetch {
    name        = "opencolorio-git";
    version     = "815.15e96c1f";
    filename    = "mingw-w64-x86_64-opencolorio-git-815.15e96c1f-1-any.pkg.tar.xz";
    sha256      = "26ae0a68aa71ae4668f7f301d214a9b60987774596313666ecf1fd80947016fc";
    buildInputs = [ boost glew lcms2 python3 tinyxml yaml-cpp ];
  };

  "opencore-amr" = fetch {
    name        = "opencore-amr";
    version     = "0.1.5";
    filename    = "mingw-w64-x86_64-opencore-amr-0.1.5-1-any.pkg.tar.xz";
    sha256      = "f154b789eaa5afcacaef50a0b44740643bb4041ae9963a3f2fec5b7889649fa7";
    buildInputs = [  ];
  };

  "opencsg" = fetch {
    name        = "opencsg";
    version     = "1.4.2";
    filename    = "mingw-w64-x86_64-opencsg-1.4.2-1-any.pkg.tar.xz";
    sha256      = "a12410cb16f12e6ff80e3e0b41d1157b81f7ae9cb654a0fb57134fedf1ab8f75";
    buildInputs = [ glew ];
  };

  "opencv" = fetch {
    name        = "opencv";
    version     = "4.0.1";
    filename    = "mingw-w64-x86_64-opencv-4.0.1-1-any.pkg.tar.xz";
    sha256      = "3f22f2ee7432bfb203deeb0c6303b45eea752fe158f2b16ef4350deae6b65f13";
    buildInputs = [ intel-tbb jasper libjpeg libpng libtiff libwebp openblas openexr protobuf zlib ];
  };

  "openexr" = fetch {
    name        = "openexr";
    version     = "2.3.0";
    filename    = "mingw-w64-x86_64-openexr-2.3.0-1-any.pkg.tar.xz";
    sha256      = "d5f1ed60f129d93878c80ece86439b75d714e7ca3bf446fc0a839c05f6e7161d";
    buildInputs = [ (assert ilmbase.version=="2.3.0"; ilmbase) zlib ];
  };

  "openh264" = fetch {
    name        = "openh264";
    version     = "1.8.0";
    filename    = "mingw-w64-x86_64-openh264-1.8.0-1-any.pkg.tar.xz";
    sha256      = "13820484e8cde8e36bff69d0c090998d41aa6c0ba9d53cbcc660d180ab8416e6";
  };

  "openimageio" = fetch {
    name        = "openimageio";
    version     = "1.8.17";
    filename    = "mingw-w64-x86_64-openimageio-1.8.17-1-any.pkg.tar.xz";
    sha256      = "028ccde29d95cd1649cadeed53e08e760d52ce072335ed691fe217342e21329c";
    buildInputs = [ boost field3d freetype jasper giflib glew hdf5 libjpeg libpng LibRaw libwebp libtiff opencolorio-git opencv openexr openjpeg openssl ptex pugixml zlib ];
    broken      = true;
  };

  "openjpeg" = fetch {
    name        = "openjpeg";
    version     = "1.5.2";
    filename    = "mingw-w64-x86_64-openjpeg-1.5.2-7-any.pkg.tar.xz";
    sha256      = "7cedc58a21aa29cf2619394a60a0194b7bba4efbf39a10dcab1b360069cfa1cc";
    buildInputs = [ lcms2 libtiff libpng zlib ];
  };

  "openjpeg2" = fetch {
    name        = "openjpeg2";
    version     = "2.3.0";
    filename    = "mingw-w64-x86_64-openjpeg2-2.3.0-2-any.pkg.tar.xz";
    sha256      = "5672743ea0435e2f2606bad464bec821d9c95e0f69b1a93ed29cec6911d00fd5";
    buildInputs = [ gcc-libs lcms2 libtiff libpng zlib ];
  };

  "openldap" = fetch {
    name        = "openldap";
    version     = "2.4.46";
    filename    = "mingw-w64-x86_64-openldap-2.4.46-1-any.pkg.tar.xz";
    sha256      = "f45fa33ac10366fdd09bc09f3bcbe6601023975fa0f6241c18528d011b300c8f";
    buildInputs = [ cyrus-sasl icu libtool openssl ];
  };

  "openlibm" = fetch {
    name        = "openlibm";
    version     = "0.6.0";
    filename    = "mingw-w64-x86_64-openlibm-0.6.0-1-any.pkg.tar.xz";
    sha256      = "c70708efc45dce34eb4e38a68cb97ca592e881e81ae04bcfdd4798528878c3b3";
  };

  "openocd" = fetch {
    name        = "openocd";
    version     = "0.10.0";
    filename    = "mingw-w64-x86_64-openocd-0.10.0-1-any.pkg.tar.xz";
    sha256      = "eb982e60eb1b39a0a484696b1f26fa9049a2ebbb0c4143beea6c0df4a2905442";
    buildInputs = [ hidapi libusb libusb-compat-git libftdi ];
  };

  "openocd-git" = fetch {
    name        = "openocd-git";
    version     = "0.9.0.r2.g79fdeb3";
    filename    = "mingw-w64-x86_64-openocd-git-0.9.0.r2.g79fdeb3-1-any.pkg.tar.xz";
    sha256      = "b8619e602cc959086875996bcf12163426852bc5ae75ccbe8d3c23aa31b5ccec";
    buildInputs = [ hidapi libusb libusb-compat-git ];
  };

  "openscad" = fetch {
    name        = "openscad";
    version     = "2015.03";
    filename    = "mingw-w64-x86_64-openscad-2015.03-2-any.pkg.tar.xz";
    sha256      = "e445edbbbc90e48b5637c94be10fea39e684fd9c9be9be5844448d779dacbf53";
    buildInputs = [ qt5 boost cgal opencsg qscintilla shared-mime-info ];
    broken      = true;
  };

  "openshadinglanguage" = fetch {
    name        = "openshadinglanguage";
    version     = "1.8.15";
    filename    = "mingw-w64-x86_64-openshadinglanguage-1.8.15-3-any.pkg.tar.xz";
    sha256      = "4e5132baf89c3826693a7ef25e4aa886ba1d7b5618ca0ff03406c45759eb4ce9";
    buildInputs = [ boost clang freetype glew ilmbase intel-tbb libpng libtiff openexr openimageio pugixml ];
    broken      = true;
  };

  "openssl" = fetch {
    name        = "openssl";
    version     = "1.1.1.a";
    filename    = "mingw-w64-x86_64-openssl-1.1.1.a-1-any.pkg.tar.xz";
    sha256      = "c02851c86e87ad7c61303bfc5dccd91c5f40cd37c69d24f63f7e08328f931816";
    buildInputs = [ ca-certificates gcc-libs zlib ];
  };

  "openvr" = fetch {
    name        = "openvr";
    version     = "1.0.16";
    filename    = "mingw-w64-x86_64-openvr-1.0.16-1-any.pkg.tar.xz";
    sha256      = "2aed092ea1d4adff3d462228fdb47206a1302d7ec2ad8b74bde9d29409ccbe2c";
    buildInputs = [ gcc-libs ];
  };

  "optipng" = fetch {
    name        = "optipng";
    version     = "0.7.7";
    filename    = "mingw-w64-x86_64-optipng-0.7.7-1-any.pkg.tar.xz";
    sha256      = "565248dff7b47b3c1f66efd8f4cd3fc272f376e8cc4a1a59fb90fbcacfe38341";
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "opus" = fetch {
    name        = "opus";
    version     = "1.3";
    filename    = "mingw-w64-x86_64-opus-1.3-1-any.pkg.tar.xz";
    sha256      = "4151f9dd2cbab9c8a0efc578558955977226fe2f3d35f26db7d81e71b488d087";
    buildInputs = [  ];
  };

  "opus-tools" = fetch {
    name        = "opus-tools";
    version     = "0.2";
    filename    = "mingw-w64-x86_64-opus-tools-0.2-1-any.pkg.tar.xz";
    sha256      = "9a8850c866e42520c7380e33e1fdbd6128a953a3c1610e2cb915305dde2601af";
    buildInputs = [ gcc-libs flac libogg opus opusfile libopusenc ];
  };

  "opusfile" = fetch {
    name        = "opusfile";
    version     = "0.11";
    filename    = "mingw-w64-x86_64-opusfile-0.11-2-any.pkg.tar.xz";
    sha256      = "b2e6eb486eb6548a365c3ca6a5394da90a6ee9606ed2bd1f021164707965a021";
    buildInputs = [ libogg openssl opus ];
  };

  "orc" = fetch {
    name        = "orc";
    version     = "0.4.28";
    filename    = "mingw-w64-x86_64-orc-0.4.28-1-any.pkg.tar.xz";
    sha256      = "47114013451308fdc407651da49619ea237acc5e192f69d1a5632acaf9d955a4";
  };

  "osgQt" = fetch {
    name        = "osgQt";
    version     = "3.5.7";
    filename    = "mingw-w64-x86_64-osgQt-3.5.7-6-any.pkg.tar.xz";
    sha256      = "186a4c73b6aafaec838c5b30c168051489c704d4628fabbd1c23635a3898cd53";
    buildInputs = [ qt5 OpenSceneGraph ];
    broken      = true;
  };

  "osgQt-debug" = fetch {
    name        = "osgQt-debug";
    version     = "3.5.7";
    filename    = "mingw-w64-x86_64-osgQt-debug-3.5.7-6-any.pkg.tar.xz";
    sha256      = "bd4bfab5eef28445101b96ce8e52a54342375c6370798bc615a347c67ce6d430";
    buildInputs = [ qt5 OpenSceneGraph-debug ];
    broken      = true;
  };

  "osgQtQuick-debug-git" = fetch {
    name        = "osgQtQuick-debug-git";
    version     = "2.0.0.r172";
    filename    = "mingw-w64-x86_64-osgQtQuick-debug-git-2.0.0.r172-4-any.pkg.tar.xz";
    sha256      = "0b01b60a6f8d31f1845a7d55799e2c9a198e5f092ec67bd1996737f5ef15962c";
    buildInputs = [ osgQt-debug qt5 (assert osgQtQuick-git.version=="2.0.0.r172"; osgQtQuick-git) OpenSceneGraph-debug ];
    broken      = true;
  };

  "osgQtQuick-git" = fetch {
    name        = "osgQtQuick-git";
    version     = "2.0.0.r172";
    filename    = "mingw-w64-x86_64-osgQtQuick-git-2.0.0.r172-4-any.pkg.tar.xz";
    sha256      = "3c80a4d9cf10a2e9fa16e034c28464218e9d8962dc76e621adce834c093989db";
    buildInputs = [ osgQt qt5 OpenSceneGraph ];
    broken      = true;
  };

  "osgbullet-debug-git" = fetch {
    name        = "osgbullet-debug-git";
    version     = "3.0.0.265";
    filename    = "mingw-w64-x86_64-osgbullet-debug-git-3.0.0.265-1-any.pkg.tar.xz";
    sha256      = "8c7cfd980edccbcb051b55dcad84e7eee7ad4577845f9668ecee59ac1501a2c5";
    buildInputs = [ (assert osgbullet-git.version=="3.0.0.265"; osgbullet-git) OpenSceneGraph-debug osgworks-debug-git ];
    broken      = true;
  };

  "osgbullet-git" = fetch {
    name        = "osgbullet-git";
    version     = "3.0.0.265";
    filename    = "mingw-w64-x86_64-osgbullet-git-3.0.0.265-1-any.pkg.tar.xz";
    sha256      = "318c52e82dc8988abf9b29546449fb9edba56612e13a60b50c740452c6836bff";
    buildInputs = [ bullet OpenSceneGraph osgworks-git ];
    broken      = true;
  };

  "osgearth" = fetch {
    name        = "osgearth";
    version     = "2.10";
    filename    = "mingw-w64-x86_64-osgearth-2.10-1-any.pkg.tar.xz";
    sha256      = "6ae4bf93a663582622335539b0be885afe7c1ba379f36444a80cf2dd3f856cb2";
    buildInputs = [ OpenSceneGraph OpenSceneGraph-debug osgQt osgQt-debug curl gdal geos poco protobuf rocksdb sqlite3 OpenSceneGraph ];
    broken      = true;
  };

  "osgearth-debug" = fetch {
    name        = "osgearth-debug";
    version     = "2.10";
    filename    = "mingw-w64-x86_64-osgearth-debug-2.10-1-any.pkg.tar.xz";
    sha256      = "47e9504c3c0afbb46943df919fd6353193487375f08355108231ae3badad994d";
    buildInputs = [ OpenSceneGraph OpenSceneGraph-debug osgQt osgQt-debug curl gdal geos poco protobuf rocksdb sqlite3 OpenSceneGraph-debug ];
    broken      = true;
  };

  "osgocean-debug-git" = fetch {
    name        = "osgocean-debug-git";
    version     = "1.0.1.r161";
    filename    = "mingw-w64-x86_64-osgocean-debug-git-1.0.1.r161-1-any.pkg.tar.xz";
    sha256      = "dd8f456d64b9fa72dd5fca17721d98f54f796d11a9a1d6a86750a3f5e4eb9e6d";
    buildInputs = [ (assert osgocean-git.version=="1.0.1.r161"; osgocean-git) OpenSceneGraph-debug ];
    broken      = true;
  };

  "osgocean-git" = fetch {
    name        = "osgocean-git";
    version     = "1.0.1.r161";
    filename    = "mingw-w64-x86_64-osgocean-git-1.0.1.r161-1-any.pkg.tar.xz";
    sha256      = "1312ee56e82566375184fc8d54cc77145dab95eea0caf1a8082c279782380be7";
    buildInputs = [ fftw OpenSceneGraph ];
    broken      = true;
  };

  "osgworks-debug-git" = fetch {
    name        = "osgworks-debug-git";
    version     = "3.1.0.444";
    filename    = "mingw-w64-x86_64-osgworks-debug-git-3.1.0.444-3-any.pkg.tar.xz";
    sha256      = "b454d6b99916774611030ece8f448b430d92b657232e7d8be3341b013f78a366";
    buildInputs = [ (assert osgworks-git.version=="3.1.0.444"; osgworks-git) OpenSceneGraph-debug ];
    broken      = true;
  };

  "osgworks-git" = fetch {
    name        = "osgworks-git";
    version     = "3.1.0.444";
    filename    = "mingw-w64-x86_64-osgworks-git-3.1.0.444-3-any.pkg.tar.xz";
    sha256      = "d4af18dff794dbee82c785f8317c27e81ce6b7604378ea56ed7d977eb30b5f33";
    buildInputs = [ OpenSceneGraph vrpn ];
    broken      = true;
  };

  "osl" = fetch {
    name        = "osl";
    version     = "0.9.2";
    filename    = "mingw-w64-x86_64-osl-0.9.2-1-any.pkg.tar.xz";
    sha256      = "5bd8abb19a88016b31de6b3ace34864b65ba585a9ed1dfdafa0a19fadddc5be3";
    buildInputs = [ gmp ];
  };

  "osm-gps-map" = fetch {
    name        = "osm-gps-map";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-osm-gps-map-1.1.0-2-any.pkg.tar.xz";
    sha256      = "ac64d2db0c3ff741c82b01e92e67d361b9f9cb92e4d8c6521cd7bc7f158edf2d";
    buildInputs = [ libxml2 libsoup python2 gtk3 python2-gobject2 python2-cairo python2-pygtk gobject-introspection ];
  };

  "osmgpsmap-git" = fetch {
    name        = "osmgpsmap-git";
    version     = "r443.c24d08d";
    filename    = "mingw-w64-x86_64-osmgpsmap-git-r443.c24d08d-1-any.pkg.tar.xz";
    sha256      = "bb8ce78ec807780f0785c750b59acd55deb362889dde4f4c8d788cec9f674031";
    buildInputs = [ gtk3 libsoup python2-gobject gobject-introspection ];
  };

  "osslsigncode" = fetch {
    name        = "osslsigncode";
    version     = "1.7.1";
    filename    = "mingw-w64-x86_64-osslsigncode-1.7.1-4-any.pkg.tar.xz";
    sha256      = "1ab785a3870c2aef0691cebf4e9afbe1cdfc0c4acd2a5868f5dc488ac2b28400";
    buildInputs = [ curl libgsf openssl ];
  };

  "p11-kit" = fetch {
    name        = "p11-kit";
    version     = "0.23.14";
    filename    = "mingw-w64-x86_64-p11-kit-0.23.14-1-any.pkg.tar.xz";
    sha256      = "96fdc538bad01f4c21cdb53092b1f22e64092263420f71d89f02362bc7c8c920";
    buildInputs = [ libtasn1 libffi gettext ];
  };

  "paho.mqtt.c" = fetch {
    name        = "paho.mqtt.c";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-paho.mqtt.c-1.1.0-1-any.pkg.tar.xz";
    sha256      = "0e685dae2471ba0885ed54975ffc118093616f5fdfaa63f6d4f1d11ec2afc8b1";
  };

  "pango" = fetch {
    name        = "pango";
    version     = "1.43.0";
    filename    = "mingw-w64-x86_64-pango-1.43.0-1-any.pkg.tar.xz";
    sha256      = "03b5ae8d603030d38110c9c5b085a3fe9fce13eee7ce2125fab9a8a586a2ed9c";
    buildInputs = [ gcc-libs cairo freetype fontconfig glib2 harfbuzz fribidi libthai ];
  };

  "pangomm" = fetch {
    name        = "pangomm";
    version     = "2.42.0";
    filename    = "mingw-w64-x86_64-pangomm-2.42.0-1-any.pkg.tar.xz";
    sha256      = "0216f5a81d9c8cbe5b245a43b5b14b0fc1c79b286ef1f3c10ba0a9692b3dfff9";
    buildInputs = [ cairomm glibmm pango ];
  };

  "pcre" = fetch {
    name        = "pcre";
    version     = "8.42";
    filename    = "mingw-w64-x86_64-pcre-8.42-1-any.pkg.tar.xz";
    sha256      = "884c91261bec60e379b1f8ea29f35285e7e7066483b9ce819c047d0a0aec5ca8";
    buildInputs = [ gcc-libs bzip2 wineditline zlib ];
  };

  "pcre2" = fetch {
    name        = "pcre2";
    version     = "10.32";
    filename    = "mingw-w64-x86_64-pcre2-10.32-1-any.pkg.tar.xz";
    sha256      = "e80b1ee984f19e92f2d9bb020ce94a8859e58a5c812c8d79e232b403a2366f1e";
    buildInputs = [ gcc-libs bzip2 wineditline zlib ];
  };

  "pdcurses" = fetch {
    name        = "pdcurses";
    version     = "3.6";
    filename    = "mingw-w64-x86_64-pdcurses-3.6-2-any.pkg.tar.xz";
    sha256      = "c19545db87238eb6a81336592a3e7ff9f6536acc00b25e8911c8a4e240e81212";
    buildInputs = [ gcc-libs ];
  };

  "pdf2djvu" = fetch {
    name        = "pdf2djvu";
    version     = "0.9.11";
    filename    = "mingw-w64-x86_64-pdf2djvu-0.9.11-1-any.pkg.tar.xz";
    sha256      = "08f025305ec4ff1fcd6eb7e8fd6928fb4460c5c8ddf8e747e5276fd48b5be0b3";
    buildInputs = [ poppler gcc-libs djvulibre exiv2 gettext graphicsmagick libiconv ];
  };

  "pdf2svg" = fetch {
    name        = "pdf2svg";
    version     = "0.2.3";
    filename    = "mingw-w64-x86_64-pdf2svg-0.2.3-6-any.pkg.tar.xz";
    sha256      = "678c52a54d51bc86f3cb4136e82ca0c1a68090cd9ebc7785da4bff0189347da5";
    buildInputs = [ poppler ];
  };

  "pegtl" = fetch {
    name        = "pegtl";
    version     = "2.7.1";
    filename    = "mingw-w64-x86_64-pegtl-2.7.1-1-any.pkg.tar.xz";
    sha256      = "bf3998672aab2f0866e4d375047cf290fa19e37fe2fd9c7bfcbd3d2456f1742c";
    buildInputs = [ gcc-libs ];
  };

  "perl" = fetch {
    name        = "perl";
    version     = "5.28.0";
    filename    = "mingw-w64-x86_64-perl-5.28.0-1-any.pkg.tar.xz";
    sha256      = "7e4d9a2c775d7baa3da394e3f492c407ddaaebb3220cbda97aaf17d71ebce79e";
    buildInputs = [ gcc-libs winpthreads-git make ];
  };

  "perl-doc" = fetch {
    name        = "perl-doc";
    version     = "5.28.0";
    filename    = "mingw-w64-x86_64-perl-doc-5.28.0-1-any.pkg.tar.xz";
    sha256      = "4aaef1ef66d48f3717f4a712f20f9f77d0103c1e4661d19e1ff1ebc734826c72";
  };

  "phodav" = fetch {
    name        = "phodav";
    version     = "2.2";
    filename    = "mingw-w64-x86_64-phodav-2.2-1-any.pkg.tar.xz";
    sha256      = "0401dda04359f637f40ed528cc3e5b6553339067635474416290d69385671653";
    buildInputs = [ libsoup ];
  };

  "phonon-qt5" = fetch {
    name        = "phonon-qt5";
    version     = "4.10.1";
    filename    = "mingw-w64-x86_64-phonon-qt5-4.10.1-1-any.pkg.tar.xz";
    sha256      = "6708df8d732879d4369eb074fd140a17082e03125a31069b60039b41e659e934";
    buildInputs = [ qt5 glib2 ];
    broken      = true;
  };

  "physfs" = fetch {
    name        = "physfs";
    version     = "3.0.1";
    filename    = "mingw-w64-x86_64-physfs-3.0.1-1-any.pkg.tar.xz";
    sha256      = "a25baf664a2df0e52047afbe87c916946c6dac3a7dac21deb8781d6e925f0b55";
    buildInputs = [ zlib ];
  };

  "pidgin++" = fetch {
    name        = "pidgin++";
    version     = "15.1";
    filename    = "mingw-w64-x86_64-pidgin++-15.1-2-any.pkg.tar.xz";
    sha256      = "249090a85c5cf3013152d3adbf299ac4d461e6df9f330b45a90f1a9acc122e97";
    buildInputs = [ adwaita-icon-theme ca-certificates drmingw freetype fontconfig gettext gnutls gsasl gst-plugins-base gst-plugins-good gtk2 gtkspell libgadu libidn meanwhile nss ncurses silc-toolkit winsparkle zlib ];
    broken      = true;
  };

  "pidgin-hg" = fetch {
    name        = "pidgin-hg";
    version     = "r37207.e666f49a3e86";
    filename    = "mingw-w64-x86_64-pidgin-hg-r37207.e666f49a3e86-1-any.pkg.tar.xz";
    sha256      = "7f152128f3187775d2d209533e0a68dfb651dabcdaf5a6ee5b8c50e47ade4b64";
    buildInputs = [ adwaita-icon-theme ca-certificates farstream freetype fontconfig gettext gnutls gplugin gsasl gtk3 gtkspell libgadu libidn nss ncurses webkitgtk3 zlib ];
    broken      = true;
  };

  "pinentry" = fetch {
    name        = "pinentry";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-pinentry-1.1.0-1-any.pkg.tar.xz";
    sha256      = "b463fd9d5556b188247d0954bf244df0ed244d60fbc9e47bf3ba273581a72832";
    buildInputs = [ qt5 libsecret libassuan ];
    broken      = true;
  };

  "pixman" = fetch {
    name        = "pixman";
    version     = "0.36.0";
    filename    = "mingw-w64-x86_64-pixman-0.36.0-1-any.pkg.tar.xz";
    sha256      = "9faa95f60a94041559697a9aa71e06ae4a57e12f092df3ef4307212bf9c79d5b";
    buildInputs = [ gcc-libs ];
  };

  "pkg-config" = fetch {
    name        = "pkg-config";
    version     = "0.29.2";
    filename    = "mingw-w64-x86_64-pkg-config-0.29.2-1-any.pkg.tar.xz";
    sha256      = "f69c6a4f83164db254178821009e69877855a5dfbfc6b7c5a796cb79964ddaf0";
    buildInputs = [ libwinpthread-git ];
  };

  "plasma-framework-qt5" = fetch {
    name        = "plasma-framework-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-plasma-framework-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "643e98e04261146c98bd622116bc5efd4cdc52f84f75b68587c521aa76fc08f7";
    buildInputs = [ qt5 kactivities-qt5 kdeclarative-qt5 kirigami2-qt5 ];
    broken      = true;
  };

  "plplot" = fetch {
    name        = "plplot";
    version     = "5.13.0";
    filename    = "mingw-w64-x86_64-plplot-5.13.0-3-any.pkg.tar.xz";
    sha256      = "b8214dedccd04fc24dff4b80fbda1ff8f8807a61e3ead480ea28acbf307830ef";
    buildInputs = [ cairo gcc-libs gcc-libgfortran freetype libharu lua python2 python2-numpy shapelib tk wxWidgets ];
    broken      = true;
  };

  "png2ico" = fetch {
    name        = "png2ico";
    version     = "2002.12.08";
    filename    = "mingw-w64-x86_64-png2ico-2002.12.08-2-any.pkg.tar.xz";
    sha256      = "43df59b97ac04eb1d71adae150c4343628e1276de51f94a43d0a838c61183489";
    buildInputs = [  ];
  };

  "pngcrush" = fetch {
    name        = "pngcrush";
    version     = "1.8.13";
    filename    = "mingw-w64-x86_64-pngcrush-1.8.13-1-any.pkg.tar.xz";
    sha256      = "0a60bbe9856e6c795f01ca424d350c3fd1585cae3a749eac1f40fbfae410de79";
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "pngnq" = fetch {
    name        = "pngnq";
    version     = "1.1";
    filename    = "mingw-w64-x86_64-pngnq-1.1-2-any.pkg.tar.xz";
    sha256      = "d9efb31d844fe7b99f20805f2da96caf04a3340a4006a456f6a5f87e69dd28c1";
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "poco" = fetch {
    name        = "poco";
    version     = "1.9.0";
    filename    = "mingw-w64-x86_64-poco-1.9.0-1-any.pkg.tar.xz";
    sha256      = "f2920d06cb7fd311601201ab3b127520de9fe9fe02a80fa301706f496ab8993c";
    buildInputs = [ gcc-libs expat libmariadbclient openssl pcre sqlite3 zlib ];
  };

  "podofo" = fetch {
    name        = "podofo";
    version     = "0.9.6";
    filename    = "mingw-w64-x86_64-podofo-0.9.6-1-any.pkg.tar.xz";
    sha256      = "76bc143b5f8fcb669b3c6355f64eb28fde4e86dd97a361cb7361f011601fa1a5";
    buildInputs = [ fontconfig libtiff libidn libjpeg-turbo lua openssl ];
    broken      = true;
  };

  "polipo" = fetch {
    name        = "polipo";
    version     = "1.1.1";
    filename    = "mingw-w64-x86_64-polipo-1.1.1-1-any.pkg.tar.xz";
    sha256      = "ea16166a24c4636385080c5b3f58b1632948e03738ecdee4a04909fe117330db";
  };

  "polly" = fetch {
    name        = "polly";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-polly-7.0.1-1-any.pkg.tar.xz";
    sha256      = "548abc6a2b6cb0c0cdb584da7feeb58717837ae96c24868c583539b0c8ba72bf";
    buildInputs = [ (assert llvm.version=="7.0.1"; llvm) ];
  };

  "poppler" = fetch {
    name        = "poppler";
    version     = "0.72.0";
    filename    = "mingw-w64-x86_64-poppler-0.72.0-1-any.pkg.tar.xz";
    sha256      = "dc39c776c259b5265e21d13963e5dc5936fe1902852b77d20312a18742852f31";
    buildInputs = [ cairo curl freetype icu lcms2 libjpeg libpng libtiff nss openjpeg2 poppler-data zlib ];
  };

  "poppler-data" = fetch {
    name        = "poppler-data";
    version     = "0.4.9";
    filename    = "mingw-w64-x86_64-poppler-data-0.4.9-1-any.pkg.tar.xz";
    sha256      = "8ba4ad9bff84a09b0ad7a539a2c022fdc572ce691012e97467af67ef3495d7db";
    buildInputs = [  ];
  };

  "poppler-qt4" = fetch {
    name        = "poppler-qt4";
    version     = "0.36.0";
    filename    = "mingw-w64-x86_64-poppler-qt4-0.36.0-1-any.pkg.tar.xz";
    sha256      = "69509956d83d0d7da591b7cf4bf350458b8746324062c9cfb2c0fbd7b19ec702";
    buildInputs = [ cairo curl freetype icu libjpeg libpng libtiff openjpeg poppler-data zlib ];
  };

  "popt" = fetch {
    name        = "popt";
    version     = "1.16";
    filename    = "mingw-w64-x86_64-popt-1.16-1-any.pkg.tar.xz";
    sha256      = "307e90e719503bfb6685c765e4f34a239a04e93d473a16d72bf686976819e5a1";
    buildInputs = [ gettext ];
  };

  "port-scanner" = fetch {
    name        = "port-scanner";
    version     = "1.3";
    filename    = "mingw-w64-x86_64-port-scanner-1.3-2-any.pkg.tar.xz";
    sha256      = "b04e6c491a8052ab7356703b3eca110f4322ad6e0df711527b21e98004ae2926";
  };

  "portablexdr" = fetch {
    name        = "portablexdr";
    version     = "4.9.2.r27.94fb83c";
    filename    = "mingw-w64-x86_64-portablexdr-4.9.2.r27.94fb83c-2-any.pkg.tar.xz";
    sha256      = "2e455109504fc2ae8f899e8ea01b47ad325b50f3e858eaf1afbdad11ec8b7785";
    buildInputs = [ gcc-libs ];
  };

  "portaudio" = fetch {
    name        = "portaudio";
    version     = "190600_20161030";
    filename    = "mingw-w64-x86_64-portaudio-190600_20161030-3-any.pkg.tar.xz";
    sha256      = "81ca8af23c5ef8122363b1226af28e369e1608902c8ecf71f4266ab722f43d40";
    buildInputs = [ gcc-libs ];
  };

  "portmidi" = fetch {
    name        = "portmidi";
    version     = "217";
    filename    = "mingw-w64-x86_64-portmidi-217-2-any.pkg.tar.xz";
    sha256      = "5222c6109a597efcfb87b0c4d86076cc08fc0a4b3adfd1977e659c038828e8b9";
    buildInputs = [ gcc-libs ];
  };

  "postgis" = fetch {
    name        = "postgis";
    version     = "2.5.1";
    filename    = "mingw-w64-x86_64-postgis-2.5.1-1-any.pkg.tar.xz";
    sha256      = "a0e82e23fef01e24b62fefc93c30c6c8dfc20b65db198e8752e5047d15e00ba3";
    buildInputs = [ gcc-libs gdal geos gettext json-c libxml2 postgresql proj ];
    broken      = true;
  };

  "postgresql" = fetch {
    name        = "postgresql";
    version     = "11.1";
    filename    = "mingw-w64-x86_64-postgresql-11.1-1-any.pkg.tar.xz";
    sha256      = "a62e14c1a3864fd25cb81fe1f612e24868b5514a568e212ca37addfdbd616c32";
    buildInputs = [ gcc-libs gettext libxml2 libxslt openssl python2 tcl zlib winpty ];
    broken      = true;
  };

  "postr" = fetch {
    name        = "postr";
    version     = "0.13.1";
    filename    = "mingw-w64-x86_64-postr-0.13.1-1-any.pkg.tar.xz";
    sha256      = "643804c3ebcf2549a8c4c85aeeff35f09f0d54f9ed818f4a2e56dc2840896725";
    buildInputs = [ python2-pygtk ];
  };

  "potrace" = fetch {
    name        = "potrace";
    version     = "1.15";
    filename    = "mingw-w64-x86_64-potrace-1.15-2-any.pkg.tar.xz";
    sha256      = "30f385693a153d7a0237d00943414164dc2d6acf01073da1797a236ab3c7eabe";
  };

  "premake" = fetch {
    name        = "premake";
    version     = "4.3";
    filename    = "mingw-w64-x86_64-premake-4.3-2-any.pkg.tar.xz";
    sha256      = "64925f41b0f4a683482513d2206dca4a36f5f7a53c259ff4c4ff42da3e9e1213";
  };

  "proj" = fetch {
    name        = "proj";
    version     = "5.2.0";
    filename    = "mingw-w64-x86_64-proj-5.2.0-1-any.pkg.tar.xz";
    sha256      = "fd579aa68c1ac72669cf0c5f72029191f6a3d1ebf888d5ac57ab6253c9099ac8";
    buildInputs = [ gcc-libs ];
  };

  "protobuf" = fetch {
    name        = "protobuf";
    version     = "3.6.1.3";
    filename    = "mingw-w64-x86_64-protobuf-3.6.1.3-1-any.pkg.tar.xz";
    sha256      = "1c4d4cdad2656154c95fc50e94a9ca3c8459d0569affaf5c13088ee7154d7f90";
    buildInputs = [ gcc-libs zlib ];
  };

  "protobuf-c" = fetch {
    name        = "protobuf-c";
    version     = "1.3.1";
    filename    = "mingw-w64-x86_64-protobuf-c-1.3.1-1-any.pkg.tar.xz";
    sha256      = "5e5a717ebfd0a89d5c77e81ccd3fa6fa982536dd26f3abb9c732780747f65ec5";
    buildInputs = [ protobuf ];
  };

  "ptex" = fetch {
    name        = "ptex";
    version     = "2.3.0";
    filename    = "mingw-w64-x86_64-ptex-2.3.0-1-any.pkg.tar.xz";
    sha256      = "f35a6a133b7f0314e105e4b598d7802816b264c0c68559ae50a2ef63ece62071";
    buildInputs = [ gcc-libs zlib winpthreads-git ];
  };

  "pugixml" = fetch {
    name        = "pugixml";
    version     = "1.9";
    filename    = "mingw-w64-x86_64-pugixml-1.9-1-any.pkg.tar.xz";
    sha256      = "36cdfa9fdf9a8b6acdaad0cda759b066ce2bb8524e91a84842d8d916fbe6bc99";
  };

  "pupnp" = fetch {
    name        = "pupnp";
    version     = "1.6.25";
    filename    = "mingw-w64-x86_64-pupnp-1.6.25-1-any.pkg.tar.xz";
    sha256      = "57f739362789470fe08c9919f203f1fb2279bd1163de1de905da3616093a4c0a";
  };

  "purple-facebook" = fetch {
    name        = "purple-facebook";
    version     = "20160907.66ee773.bf8ed95";
    filename    = "mingw-w64-x86_64-purple-facebook-20160907.66ee773.bf8ed95-1-any.pkg.tar.xz";
    sha256      = "c679b668c80cb30dcb267af17c22d2414bd5c94eccced5fe213e2ab5859addc2";
    buildInputs = [ libpurple json-glib glib2 zlib gettext gcc-libs ];
    broken      = true;
  };

  "purple-hangouts-hg" = fetch {
    name        = "purple-hangouts-hg";
    version     = "r287+.574c112aa35c+";
    filename    = "mingw-w64-x86_64-purple-hangouts-hg-r287+.574c112aa35c+-1-any.pkg.tar.xz";
    sha256      = "a47376783739b76ef87944c0eb86949039ed86b405e3c908f05efc230f854014";
    buildInputs = [ libpurple protobuf-c json-glib glib2 zlib gettext gcc-libs ];
    broken      = true;
  };

  "purple-skypeweb" = fetch {
    name        = "purple-skypeweb";
    version     = "1.1";
    filename    = "mingw-w64-x86_64-purple-skypeweb-1.1-1-any.pkg.tar.xz";
    sha256      = "f5eb02c79080cf07bfb940fbbe23ec57da3a7f1f3ab8ae0c2ef4854b38826951";
    buildInputs = [ libpurple json-glib glib2 zlib gettext gcc-libs ];
    broken      = true;
  };

  "putty" = fetch {
    name        = "putty";
    version     = "0.70";
    filename    = "mingw-w64-x86_64-putty-0.70-1-any.pkg.tar.xz";
    sha256      = "fefe408e7f84bf4c1fb5a00551048c17acf1bc118951c939533ec0cbe6074275";
    buildInputs = [ gcc-libs ];
  };

  "putty-ssh" = fetch {
    name        = "putty-ssh";
    version     = "0.0";
    filename    = "mingw-w64-x86_64-putty-ssh-0.0-3-any.pkg.tar.xz";
    sha256      = "9dccf0f6c151802b7435eed4926d4b66e442e66d51dbb911941346a55a70be4e";
    buildInputs = [ gcc-libs putty ];
  };

  "pybind11" = fetch {
    name        = "pybind11";
    version     = "2.2.4";
    filename    = "mingw-w64-x86_64-pybind11-2.2.4-1-any.pkg.tar.xz";
    sha256      = "6a733fd23f9d2d3a34c98eb7b803849690d6814ba4c10608c4b2739886e5a47a";
  };

  "pygobject-devel" = fetch {
    name        = "pygobject-devel";
    version     = "3.30.4";
    filename    = "mingw-w64-x86_64-pygobject-devel-3.30.4-1-any.pkg.tar.xz";
    sha256      = "0ac65cd37ec8f8349f3111f9159a45cd007a77c9d714b3e963bee6f25d8c16ed";
    buildInputs = [  ];
  };

  "pygobject2-devel" = fetch {
    name        = "pygobject2-devel";
    version     = "2.28.7";
    filename    = "mingw-w64-x86_64-pygobject2-devel-2.28.7-1-any.pkg.tar.xz";
    sha256      = "d505a9bf15aeaf0660716676ec0eafc47ec38a746956d5d401f6609937c6578d";
    buildInputs = [  ];
  };

  "pyilmbase" = fetch {
    name        = "pyilmbase";
    version     = "2.3.0";
    filename    = "mingw-w64-x86_64-pyilmbase-2.3.0-1-any.pkg.tar.xz";
    sha256      = "5c11a88c3ba4f4f73207a6c956b18656cc99a48e09c965c375cb7addb8e7c0f4";
    buildInputs = [ (assert openexr.version=="2.3.0"; openexr) boost python2-numpy ];
  };

  "pyqt4-common" = fetch {
    name        = "pyqt4-common";
    version     = "4.11.4";
    filename    = "mingw-w64-x86_64-pyqt4-common-4.11.4-2-any.pkg.tar.xz";
    sha256      = "a4606749fdb96ad376936f3358573b9624284213a62d4e20cdfe7888c521cae2";
    buildInputs = [ qt4 ];
  };

  "pyqt5-common" = fetch {
    name        = "pyqt5-common";
    version     = "5.11.3";
    filename    = "mingw-w64-x86_64-pyqt5-common-5.11.3-1-any.pkg.tar.xz";
    sha256      = "55e197d3513524e8fce623fc7a0b4db8601fe5863ae730a62ddba9f8973291ba";
    buildInputs = [ qt5 qtwebkit ];
    broken      = true;
  };

  "pyrex" = fetch {
    name        = "pyrex";
    version     = "0.9.9";
    filename    = "mingw-w64-x86_64-pyrex-0.9.9-1-any.pkg.tar.xz";
    sha256      = "a37d22ea97a69c889d3ccdd46e36b66180142d0c28c2ddf64399d9212a3ab2a5";
    buildInputs = [ python2 ];
  };

  "pyside-common-qt4" = fetch {
    name        = "pyside-common-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-pyside-common-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "aee2acbd6acf2f0f012b1262a3a978a99d36ff2f8aa2b72685ef578170abc3a4";
  };

  "pyside-tools-common-qt4" = fetch {
    name        = "pyside-tools-common-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-pyside-tools-common-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "cedee265428db44c146163f2f9ec1ab2bfc7805ecdba6823d65fa8bd76c65e42";
    buildInputs = [ qt4 ];
  };

  "python-lxml-docs" = fetch {
    name        = "python-lxml-docs";
    version     = "4.2.5";
    filename    = "mingw-w64-x86_64-python-lxml-docs-4.2.5-1-any.pkg.tar.xz";
    sha256      = "c2b6d19d9d19dadfb260a0da2179deb8777dffe633fb4d00b2c0a547fade6816";
  };

  "python-qscintilla-common" = fetch {
    name        = "python-qscintilla-common";
    version     = "2.10.8";
    filename    = "mingw-w64-x86_64-python-qscintilla-common-2.10.8-1-any.pkg.tar.xz";
    sha256      = "4664393618c3baa47b401aacb88824bef1e8e24dc77233211bc62711655c5d95";
    buildInputs = [ qscintilla ];
    broken      = true;
  };

  "python2" = fetch {
    name        = "python2";
    version     = "2.7.15";
    filename    = "mingw-w64-x86_64-python2-2.7.15-3-any.pkg.tar.xz";
    sha256      = "2d8f7dc0c97be33a8789a254ab561b3c18a04ab4ff4acd37735717868d1aac7d";
    buildInputs = [ gcc-libs expat bzip2 libffi ncurses openssl readline tcl tk zlib ];
  };

  "python2-PyOpenGL" = fetch {
    name        = "python2-PyOpenGL";
    version     = "3.1.0";
    filename    = "mingw-w64-x86_64-python2-PyOpenGL-3.1.0-1-any.pkg.tar.xz";
    sha256      = "e8471567635f7cfc292abc2a58786e6271bf3bb8f2f8b8dd73bdb6cfcf4412b0";
    buildInputs = [ python2 ];
  };

  "python2-alembic" = fetch {
    name        = "python2-alembic";
    version     = "1.0.5";
    filename    = "mingw-w64-x86_64-python2-alembic-1.0.5-1-any.pkg.tar.xz";
    sha256      = "e32dbef942f1c568e5aa687bd9684fd85e9b3cc278f93e14068b02d40622eab3";
    buildInputs = [ python2 python2-mako python2-sqlalchemy python2-editor python2-dateutil ];
  };

  "python2-apipkg" = fetch {
    name        = "python2-apipkg";
    version     = "1.5";
    filename    = "mingw-w64-x86_64-python2-apipkg-1.5-1-any.pkg.tar.xz";
    sha256      = "5e888c13742a399e63f1e959e5df09e85c55cf91c8a74d3a0d00bdb4d45eb481";
    buildInputs = [ python2 ];
  };

  "python2-appdirs" = fetch {
    name        = "python2-appdirs";
    version     = "1.4.3";
    filename    = "mingw-w64-x86_64-python2-appdirs-1.4.3-3-any.pkg.tar.xz";
    sha256      = "1bf0c75017b5b44b46146b8fe8062c34f07e48ff1f0e04f1936aeaa97235f4bd";
    buildInputs = [ python2 ];
  };

  "python2-argh" = fetch {
    name        = "python2-argh";
    version     = "0.26.2";
    filename    = "mingw-w64-x86_64-python2-argh-0.26.2-1-any.pkg.tar.xz";
    sha256      = "e496bf907f06537baf9efdb52eb62e6474df39d88ff3526fbc3503f4295430b0";
    buildInputs = [ python2 ];
  };

  "python2-asn1crypto" = fetch {
    name        = "python2-asn1crypto";
    version     = "0.24.0";
    filename    = "mingw-w64-x86_64-python2-asn1crypto-0.24.0-2-any.pkg.tar.xz";
    sha256      = "4411276858f55181fd2207ff052510fa011bd5c119a0d9e6c4fd22a77a75bde8";
    buildInputs = [ python2-pycparser ];
  };

  "python2-astroid" = fetch {
    name        = "python2-astroid";
    version     = "1.6.5";
    filename    = "mingw-w64-x86_64-python2-astroid-1.6.5-2-any.pkg.tar.xz";
    sha256      = "844fd9fa76fe120c1ffbc39d6119bd234afa56db5a101cdd167728fe2d268b26";
    buildInputs = [ python2-six python2-lazy-object-proxy python2-wrapt python2-singledispatch python2-enum34 self."python2-backports.functools_lru_cache" ];
  };

  "python2-atomicwrites" = fetch {
    name        = "python2-atomicwrites";
    version     = "1.2.1";
    filename    = "mingw-w64-x86_64-python2-atomicwrites-1.2.1-1-any.pkg.tar.xz";
    sha256      = "575e1cfa31f3f88455365f8ebcc99ad8d8dd362d09770c20a998a20279c90231";
    buildInputs = [ python2 ];
  };

  "python2-attrs" = fetch {
    name        = "python2-attrs";
    version     = "18.2.0";
    filename    = "mingw-w64-x86_64-python2-attrs-18.2.0-1-any.pkg.tar.xz";
    sha256      = "a1e5a24f1dde9ad27a9a4a94dba5ce45bd6590ca7a8d0dec0d0960bde29f52b6";
    buildInputs = [ python2 ];
  };

  "python2-babel" = fetch {
    name        = "python2-babel";
    version     = "2.6.0";
    filename    = "mingw-w64-x86_64-python2-babel-2.6.0-3-any.pkg.tar.xz";
    sha256      = "70936fb0768dedecaf76f4dd6895d7e5c2dbcc01a8773895f9f4cdb600f495c8";
    buildInputs = [ python2-pytz ];
  };

  "python2-backcall" = fetch {
    name        = "python2-backcall";
    version     = "0.1.0";
    filename    = "mingw-w64-x86_64-python2-backcall-0.1.0-2-any.pkg.tar.xz";
    sha256      = "c193ff73c20bddde460a05e42b7c2f93ef8894487ff2c2d7396500fe28030feb";
    buildInputs = [ python2 ];
  };

  "python2-backports" = fetch {
    name        = "python2-backports";
    version     = "1.0";
    filename    = "mingw-w64-x86_64-python2-backports-1.0-1-any.pkg.tar.xz";
    sha256      = "2d7e1733eb645c2e35d0a970f7da486591c29e607cb2d67b05a1f8811a70d9ef";
    buildInputs = [ python2 ];
  };

  "python2-backports-abc" = fetch {
    name        = "python2-backports-abc";
    version     = "0.5";
    filename    = "mingw-w64-x86_64-python2-backports-abc-0.5-1-any.pkg.tar.xz";
    sha256      = "262bb936c19966787b0b953bf510f8bb9eab36ce0d585c835023f6cf2d3f0160";
    buildInputs = [ python2 ];
  };

  "python2-backports.functools_lru_cache" = fetch {
    name        = "python2-backports.functools_lru_cache";
    version     = "1.5";
    filename    = "mingw-w64-x86_64-python2-backports.functools_lru_cache-1.5-1-any.pkg.tar.xz";
    sha256      = "f77fc2b133abec641d14036a7a97456d60f8f118bdd61f5d7c6a1fac44337d04";
    buildInputs = [ python2 ];
  };

  "python2-backports.os" = fetch {
    name        = "python2-backports.os";
    version     = "0.1.1";
    filename    = "mingw-w64-x86_64-python2-backports.os-0.1.1-1-any.pkg.tar.xz";
    sha256      = "7cdf18151ee5859ba97ad8bd5d9dbd6ec745b055ee0966271215fa9f0f510d59";
    buildInputs = [ python2-backports python2-future ];
  };

  "python2-backports.shutil_get_terminal_size" = fetch {
    name        = "python2-backports.shutil_get_terminal_size";
    version     = "1.0.0";
    filename    = "mingw-w64-x86_64-python2-backports.shutil_get_terminal_size-1.0.0-1-any.pkg.tar.xz";
    sha256      = "5c0a5714b4b9806f844dbd080b5870cf0d72e6c2fd036d610ca181d9f73bb42e";
    buildInputs = [ python2-backports ];
  };

  "python2-backports.ssl_match_hostname" = fetch {
    name        = "python2-backports.ssl_match_hostname";
    version     = "3.5.0.1";
    filename    = "mingw-w64-x86_64-python2-backports.ssl_match_hostname-3.5.0.1-1-any.pkg.tar.xz";
    sha256      = "ebf50d425e46ea090cdfc05a548a518c2dd380bce31d5d759bc9e78e0235f614";
    buildInputs = [ python2-backports ];
  };

  "python2-bcrypt" = fetch {
    name        = "python2-bcrypt";
    version     = "3.1.5";
    filename    = "mingw-w64-x86_64-python2-bcrypt-3.1.5-1-any.pkg.tar.xz";
    sha256      = "1ad263a61fd6dea488a0414505df10862bfeb1665188bcebbebe76662b5d3efa";
    buildInputs = [ python2 ];
  };

  "python2-beaker" = fetch {
    name        = "python2-beaker";
    version     = "1.10.0";
    filename    = "mingw-w64-x86_64-python2-beaker-1.10.0-2-any.pkg.tar.xz";
    sha256      = "df9183451e99a3614734e61c1be7b12e158e1d20d5648bab7bc826157a9ebb83";
    buildInputs = [ python2 ];
  };

  "python2-beautifulsoup3" = fetch {
    name        = "python2-beautifulsoup3";
    version     = "3.2.1";
    filename    = "mingw-w64-x86_64-python2-beautifulsoup3-3.2.1-2-any.pkg.tar.xz";
    sha256      = "198328b69d7badb924c195c055ea2c55e6ddb40aa24aa088702a0fba53508f73";
    buildInputs = [ python2 ];
  };

  "python2-beautifulsoup4" = fetch {
    name        = "python2-beautifulsoup4";
    version     = "4.6.3";
    filename    = "mingw-w64-x86_64-python2-beautifulsoup4-4.6.3-1-any.pkg.tar.xz";
    sha256      = "c2b0a4ec12ebfe1e2bef13bb1035f5296a151132faa6b0f8b5a8b5c2e38c612f";
    buildInputs = [ python2 ];
  };

  "python2-biopython" = fetch {
    name        = "python2-biopython";
    version     = "1.73";
    filename    = "mingw-w64-x86_64-python2-biopython-1.73-1-any.pkg.tar.xz";
    sha256      = "fabe1fe4610a749a21b23f2471ab4137232819e99e429ad322a3f2ff259aa60c";
    buildInputs = [ python2-numpy ];
  };

  "python2-bleach" = fetch {
    name        = "python2-bleach";
    version     = "3.0.2";
    filename    = "mingw-w64-x86_64-python2-bleach-3.0.2-1-any.pkg.tar.xz";
    sha256      = "7e771caf0325b96216612a523c17b26e4ad37df9a1ba8915eee7a3b821f2b526";
    buildInputs = [ python2 python2-html5lib ];
  };

  "python2-breathe" = fetch {
    name        = "python2-breathe";
    version     = "4.11.1";
    filename    = "mingw-w64-x86_64-python2-breathe-4.11.1-1-any.pkg.tar.xz";
    sha256      = "ea2b5b28d3ec33bffb6010eb4321752c8ce54b666f33a5434b3fd88fc769c7d1";
    buildInputs = [ python2 ];
  };

  "python2-brotli" = fetch {
    name        = "python2-brotli";
    version     = "1.0.7";
    filename    = "mingw-w64-x86_64-python2-brotli-1.0.7-1-any.pkg.tar.xz";
    sha256      = "1e49685c2eb630aac610b6c4fc7225017bc32711c40a8c8979b880fa9d2c5386";
    buildInputs = [ python2 libwinpthread-git ];
  };

  "python2-bsddb3" = fetch {
    name        = "python2-bsddb3";
    version     = "6.1.0";
    filename    = "mingw-w64-x86_64-python2-bsddb3-6.1.0-3-any.pkg.tar.xz";
    sha256      = "12f5e67d216f579b7373765614f7863f7c4461a739f06a2ce610542d1d62dd4b";
    buildInputs = [ python2 db ];
  };

  "python2-cachecontrol" = fetch {
    name        = "python2-cachecontrol";
    version     = "0.12.5";
    filename    = "mingw-w64-x86_64-python2-cachecontrol-0.12.5-1-any.pkg.tar.xz";
    sha256      = "3aa0796323b95ecf7ce9d7061f8b95a8357340295b8d77e6d7d6bdbbf3cafd62";
    buildInputs = [ python2 python2-msgpack python2-requests ];
  };

  "python2-cairo" = fetch {
    name        = "python2-cairo";
    version     = "1.18.0";
    filename    = "mingw-w64-x86_64-python2-cairo-1.18.0-1-any.pkg.tar.xz";
    sha256      = "5ba9b22399da69dedb648c8b2be98ca062de3e59b3e34d238399577f49cb4b88";
    buildInputs = [ cairo python2 ];
  };

  "python2-can" = fetch {
    name        = "python2-can";
    version     = "3.0.0";
    filename    = "mingw-w64-x86_64-python2-can-3.0.0-1-any.pkg.tar.xz";
    sha256      = "03b732eea9130c86a83d07f769841b60a52ccb387ad5386e33daa4470321f39a";
    buildInputs = [ python2 python2-python_ics python2-pyserial ];
  };

  "python2-capstone" = fetch {
    name        = "python2-capstone";
    version     = "4.0";
    filename    = "mingw-w64-x86_64-python2-capstone-4.0-1-any.pkg.tar.xz";
    sha256      = "d9a9fde0dc02299872857dee8e801749866ebc73bc8c996bb1204db0f93b9849";
    buildInputs = [ capstone python2 ];
  };

  "python2-certifi" = fetch {
    name        = "python2-certifi";
    version     = "2018.11.29";
    filename    = "mingw-w64-x86_64-python2-certifi-2018.11.29-2-any.pkg.tar.xz";
    sha256      = "defaef5aaec2d0773871f270f5d02715c42c010b928d808cf4ea0f06c831f90a";
    buildInputs = [ python2 ];
  };

  "python2-cffi" = fetch {
    name        = "python2-cffi";
    version     = "1.11.5";
    filename    = "mingw-w64-x86_64-python2-cffi-1.11.5-2-any.pkg.tar.xz";
    sha256      = "f749f98a1cba6c4273086e29a376a5e32abf4bdafcc1057dbc2a0b4bc48e8327";
    buildInputs = [ python2-pycparser ];
  };

  "python2-characteristic" = fetch {
    name        = "python2-characteristic";
    version     = "14.3.0";
    filename    = "mingw-w64-x86_64-python2-characteristic-14.3.0-3-any.pkg.tar.xz";
    sha256      = "dae1c302c5ec8a7c15a5a77c664896973ef4dd56a3008c26b654ca5d2a5f6cad";
  };

  "python2-chardet" = fetch {
    name        = "python2-chardet";
    version     = "3.0.4";
    filename    = "mingw-w64-x86_64-python2-chardet-3.0.4-2-any.pkg.tar.xz";
    sha256      = "3481d7e167cbd4956264a0718d50e01d40ecae7d72e9ce1a62b6c85c0073f78a";
    buildInputs = [ python2-setuptools ];
  };

  "python2-cjson" = fetch {
    name        = "python2-cjson";
    version     = "1.2.1";
    filename    = "mingw-w64-x86_64-python2-cjson-1.2.1-1-any.pkg.tar.xz";
    sha256      = "44ae33115b5532f539b6904bc38fe6aa3d55afd4f9b845b50a82282afe09517e";
    buildInputs = [ python2 ];
  };

  "python2-cliff" = fetch {
    name        = "python2-cliff";
    version     = "2.14.0";
    filename    = "mingw-w64-x86_64-python2-cliff-2.14.0-1-any.pkg.tar.xz";
    sha256      = "55ddf13a29efae1aac8be9162966d13345cf151a8367935c1ff34c9c93d7d8fd";
    buildInputs = [ python2 python2-six python2-pbr python2-cmd2 python2-prettytable python2-pyparsing python2-stevedore python2-unicodecsv python2-yaml ];
  };

  "python2-cmd2" = fetch {
    name        = "python2-cmd2";
    version     = "0.8.9";
    filename    = "mingw-w64-x86_64-python2-cmd2-0.8.9-1-any.pkg.tar.xz";
    sha256      = "90557108645f6c7c9717daec49de7aa2b1c5f280254480c4a353170523d1168f";
    buildInputs = [ python2-pyparsing python2-pyperclip python2-colorama python2-contextlib2 python2-enum34 python2-wcwidth python2-subprocess32 ];
  };

  "python2-colorama" = fetch {
    name        = "python2-colorama";
    version     = "0.4.1";
    filename    = "mingw-w64-x86_64-python2-colorama-0.4.1-1-any.pkg.tar.xz";
    sha256      = "f0a38a9e082d42eec9e32b7644a2575baba2ab7da7e2332aae9126f60cefb51f";
    buildInputs = [ python2 ];
  };

  "python2-colorspacious" = fetch {
    name        = "python2-colorspacious";
    version     = "1.1.2";
    filename    = "mingw-w64-x86_64-python2-colorspacious-1.1.2-2-any.pkg.tar.xz";
    sha256      = "cc4806c20ec1916f42f832359eaf324b51abc862de813f3612db3d66580fbad6";
    buildInputs = [ python2 ];
  };

  "python2-colour" = fetch {
    name        = "python2-colour";
    version     = "0.3.11";
    filename    = "mingw-w64-x86_64-python2-colour-0.3.11-1-any.pkg.tar.xz";
    sha256      = "35d2d4f4cea8ef11b39e764ab1f0cd13d51b038e7158c954db38c0adfe05c0e7";
    buildInputs = [ python2 ];
  };

  "python2-comtypes" = fetch {
    name        = "python2-comtypes";
    version     = "1.1.7";
    filename    = "mingw-w64-x86_64-python2-comtypes-1.1.7-1-any.pkg.tar.xz";
    sha256      = "51887ce9ed6283dcf23346463f871038b926fec450366333e34a64a4d6e27ea1";
    buildInputs = [ python2 ];
  };

  "python2-configparser" = fetch {
    name        = "python2-configparser";
    version     = "3.5.0";
    filename    = "mingw-w64-x86_64-python2-configparser-3.5.0-3-any.pkg.tar.xz";
    sha256      = "246131ecf2576b0e337bd21152de16c3f050b944c35551fe32740e29d44ff171";
    buildInputs = [ python2 python2-backports ];
  };

  "python2-contextlib2" = fetch {
    name        = "python2-contextlib2";
    version     = "0.5.5";
    filename    = "mingw-w64-x86_64-python2-contextlib2-0.5.5-1-any.pkg.tar.xz";
    sha256      = "4f69cbeadf8b842e19c2929548190069027c6d25b94518d5536abcfdc0348281";
    buildInputs = [ python2 ];
  };

  "python2-coverage" = fetch {
    name        = "python2-coverage";
    version     = "4.5.2";
    filename    = "mingw-w64-x86_64-python2-coverage-4.5.2-1-any.pkg.tar.xz";
    sha256      = "9e93f9cea6cf500bc72d520104c9b9a3296a3062b768054b64d945853c5e6061";
    buildInputs = [ python2 ];
  };

  "python2-crcmod" = fetch {
    name        = "python2-crcmod";
    version     = "1.7";
    filename    = "mingw-w64-x86_64-python2-crcmod-1.7-2-any.pkg.tar.xz";
    sha256      = "477cf85a7bf35e2ab3a092ee41ded2196c3a45c665a9a25e76232be964b2644e";
    buildInputs = [ python2 ];
  };

  "python2-cryptography" = fetch {
    name        = "python2-cryptography";
    version     = "2.4.2";
    filename    = "mingw-w64-x86_64-python2-cryptography-2.4.2-1-any.pkg.tar.xz";
    sha256      = "30741ec5c050b6f09b68552a52fac45fdaf3134da7d5eaccd85af9d6205bee0b";
    buildInputs = [ python2-cffi python2-pyasn1 python2-idna python2-asn1crypto ];
  };

  "python2-cssselect" = fetch {
    name        = "python2-cssselect";
    version     = "1.0.3";
    filename    = "mingw-w64-x86_64-python2-cssselect-1.0.3-2-any.pkg.tar.xz";
    sha256      = "d34ab700671c4585e0715f049829388ea096341e68203fcf42a9160893ab4eb7";
    buildInputs = [ self."python2>" ];
    broken      = true;
  };

  "python2-cvxopt" = fetch {
    name        = "python2-cvxopt";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-python2-cvxopt-1.2.2-1-any.pkg.tar.xz";
    sha256      = "84f8cb30c22c666ce3ad8281b44b055819be5a608295b4d67027d55729fe3622";
    buildInputs = [ python2 ];
  };

  "python2-cx_Freeze" = fetch {
    name        = "python2-cx_Freeze";
    version     = "5.1.1";
    filename    = "mingw-w64-x86_64-python2-cx_Freeze-5.1.1-3-any.pkg.tar.xz";
    sha256      = "5131c90de4f874eb164c3f7f5cfe3367a45f84c98a5cccd5c399823cecfa0053";
    buildInputs = [ python2 python2-six ];
  };

  "python2-cycler" = fetch {
    name        = "python2-cycler";
    version     = "0.10.0";
    filename    = "mingw-w64-x86_64-python2-cycler-0.10.0-3-any.pkg.tar.xz";
    sha256      = "9cdd6d7d7f75a1180a16f36f84a02c879125f90be40c00d79859e8019312811c";
    buildInputs = [ python2 python2-six ];
  };

  "python2-dateutil" = fetch {
    name        = "python2-dateutil";
    version     = "2.7.5";
    filename    = "mingw-w64-x86_64-python2-dateutil-2.7.5-1-any.pkg.tar.xz";
    sha256      = "3b67608ef81c3576dc01b1e183765f87216df633e6edd66d8733b9a554abd532";
    buildInputs = [ python2-six ];
  };

  "python2-ddt" = fetch {
    name        = "python2-ddt";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-python2-ddt-1.2.0-1-any.pkg.tar.xz";
    sha256      = "2fae72c0d9eafe17f05db97bf16c510b2515e790b3887f98c7c98e122cd9006f";
    buildInputs = [ python2 ];
  };

  "python2-debtcollector" = fetch {
    name        = "python2-debtcollector";
    version     = "1.20.0";
    filename    = "mingw-w64-x86_64-python2-debtcollector-1.20.0-1-any.pkg.tar.xz";
    sha256      = "54aae4bd8c7fb83c8126b9d938de20a6c5dd27175788a979021fd9f24a5da2d3";
    buildInputs = [ python2 python2-six python2-pbr python2-babel python2-wrapt ];
  };

  "python2-decorator" = fetch {
    name        = "python2-decorator";
    version     = "4.3.1";
    filename    = "mingw-w64-x86_64-python2-decorator-4.3.1-1-any.pkg.tar.xz";
    sha256      = "ea4f976e034b29d781819eb5a463d5e07a0a7cab0668010102b7ff3c5f2d160a";
    buildInputs = [ python2 ];
  };

  "python2-defusedxml" = fetch {
    name        = "python2-defusedxml";
    version     = "0.5.0";
    filename    = "mingw-w64-x86_64-python2-defusedxml-0.5.0-1-any.pkg.tar.xz";
    sha256      = "85193f9c5f0d2519017c1ed7cfbc378806c7379c17c41c45ad0ffc47fbbff21f";
    buildInputs = [ python2 ];
  };

  "python2-distlib" = fetch {
    name        = "python2-distlib";
    version     = "0.2.8";
    filename    = "mingw-w64-x86_64-python2-distlib-0.2.8-1-any.pkg.tar.xz";
    sha256      = "38b5f507d8b03832814248f351ec3f67b9c0ed1f26ca687e713768d3feeb4aa3";
    buildInputs = [ python2 ];
  };

  "python2-distutils-extra" = fetch {
    name        = "python2-distutils-extra";
    version     = "2.39";
    filename    = "mingw-w64-x86_64-python2-distutils-extra-2.39-4-any.pkg.tar.xz";
    sha256      = "5d83a7ce5ed5ad85aea6895c367d8196cbc0b94cb8c811ce0b7102e545405583";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2.version "2.7"; python2) intltool ];
    broken      = true;
  };

  "python2-django" = fetch {
    name        = "python2-django";
    version     = "1.11.13";
    filename    = "mingw-w64-x86_64-python2-django-1.11.13-1-any.pkg.tar.xz";
    sha256      = "23391ec706f605ea25d6a30d87302122b201d99f5a886df96bd4fc341a64171a";
    buildInputs = [ python2 python2-pytz ];
  };

  "python2-dnspython" = fetch {
    name        = "python2-dnspython";
    version     = "1.16.0";
    filename    = "mingw-w64-x86_64-python2-dnspython-1.16.0-1-any.pkg.tar.xz";
    sha256      = "ce6a7dd67ce25202d870692a1deaff7441af0a92ad41c132db443f30c79179f2";
    buildInputs = [ python2 ];
  };

  "python2-docutils" = fetch {
    name        = "python2-docutils";
    version     = "0.14";
    filename    = "mingw-w64-x86_64-python2-docutils-0.14-3-any.pkg.tar.xz";
    sha256      = "8f0d94d9c84667dc31bd088530b84841e810d9c311d71d0173acf1ba38e2430b";
    buildInputs = [ python2 ];
  };

  "python2-editor" = fetch {
    name        = "python2-editor";
    version     = "1.0.3";
    filename    = "mingw-w64-x86_64-python2-editor-1.0.3-1-any.pkg.tar.xz";
    sha256      = "09fe26cd423bc38c6f9c404cf2681ddab0b7ada09154c38a421f867e57113ad8";
    buildInputs = [ python2 ];
  };

  "python2-email-validator" = fetch {
    name        = "python2-email-validator";
    version     = "1.0.3";
    filename    = "mingw-w64-x86_64-python2-email-validator-1.0.3-1-any.pkg.tar.xz";
    sha256      = "7e62ccf317989f6130f80161e714cc7c1b8a103af4b64f861490bd95b2d981e4";
    buildInputs = [ python2 python2-dnspython python2-idna ];
  };

  "python2-enum" = fetch {
    name        = "python2-enum";
    version     = "0.4.6";
    filename    = "mingw-w64-x86_64-python2-enum-0.4.6-1-any.pkg.tar.xz";
    sha256      = "8cb32531837f7c63e5f65ee76550749a3cbcd045cb74573ae2fd3a2f60786696";
    buildInputs = [ python2 ];
  };

  "python2-enum34" = fetch {
    name        = "python2-enum34";
    version     = "1.1.6";
    filename    = "mingw-w64-x86_64-python2-enum34-1.1.6-1-any.pkg.tar.xz";
    sha256      = "ef637d60ea07dce5a1ddbd48999e6b289999969c2ba0b6b432e1c9590d8f5a4e";
    buildInputs = [ python2 ];
  };

  "python2-et-xmlfile" = fetch {
    name        = "python2-et-xmlfile";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python2-et-xmlfile-1.0.1-3-any.pkg.tar.xz";
    sha256      = "16304ec8e0e847c68c57d43ff4ad7392578fb6832f0a84586734cc14da0296a8";
    buildInputs = [ python2-lxml ];
  };

  "python2-eventlet" = fetch {
    name        = "python2-eventlet";
    version     = "0.24.1";
    filename    = "mingw-w64-x86_64-python2-eventlet-0.24.1-1-any.pkg.tar.xz";
    sha256      = "06dc8bcc7d9460e86739a7270b293bd8945c791b0a6a4fad96ffd0a012fd7d82";
    buildInputs = [ python2 python2-greenlet python2-monotonic ];
  };

  "python2-execnet" = fetch {
    name        = "python2-execnet";
    version     = "1.5.0";
    filename    = "mingw-w64-x86_64-python2-execnet-1.5.0-1-any.pkg.tar.xz";
    sha256      = "023ce2422b20ec899416981d1887ff5b56e9b71bc324e789837b422aa42b58bc";
    buildInputs = [ python2 python2-apipkg ];
  };

  "python2-extras" = fetch {
    name        = "python2-extras";
    version     = "1.0.0";
    filename    = "mingw-w64-x86_64-python2-extras-1.0.0-1-any.pkg.tar.xz";
    sha256      = "e91c82e7781fe2d674f316d526490c1066e9486edcfea78f7a6f3681fd3892f9";
    buildInputs = [ python2 ];
  };

  "python2-faker" = fetch {
    name        = "python2-faker";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python2-faker-1.0.1-1-any.pkg.tar.xz";
    sha256      = "9788d149cb65c34e3d62034cb6ffbaa46b802ede1c82d76e08c65fae4ba4d3cc";
    buildInputs = [ python2 python2-dateutil python2-ipaddress python2-six python2-text-unidecode ];
  };

  "python2-fasteners" = fetch {
    name        = "python2-fasteners";
    version     = "0.14.1";
    filename    = "mingw-w64-x86_64-python2-fasteners-0.14.1-1-any.pkg.tar.xz";
    sha256      = "af0c7b961dc5aa0bb516b544e47499e6085d4a182e36bb7161323395d949f7fd";
    buildInputs = [ python2 python2-six python2-monotonic ];
  };

  "python2-filelock" = fetch {
    name        = "python2-filelock";
    version     = "3.0.10";
    filename    = "mingw-w64-x86_64-python2-filelock-3.0.10-1-any.pkg.tar.xz";
    sha256      = "40809b1f33b4c640e7038264bca497013619b03d3d82f266ecf3b1b87ef80a40";
    buildInputs = [ python2 ];
  };

  "python2-fixtures" = fetch {
    name        = "python2-fixtures";
    version     = "3.0.0";
    filename    = "mingw-w64-x86_64-python2-fixtures-3.0.0-2-any.pkg.tar.xz";
    sha256      = "7ca088a46efedf1ee57f84ba56512e95bee685be842e7a7a4b4a02c3ff6bdefe";
    buildInputs = [ python2 python2-pbr python2-six ];
  };

  "python2-flake8" = fetch {
    name        = "python2-flake8";
    version     = "3.6.0";
    filename    = "mingw-w64-x86_64-python2-flake8-3.6.0-1-any.pkg.tar.xz";
    sha256      = "9e7dbd5aa0f80ca001d8c7e3a0579042d1c9938fbcdc3ce869423e8c1807b7f3";
    buildInputs = [ python2-pyflakes python2-mccabe python2-pycodestyle python2-enum34 python2-configparser ];
  };

  "python2-flaky" = fetch {
    name        = "python2-flaky";
    version     = "3.4.0";
    filename    = "mingw-w64-x86_64-python2-flaky-3.4.0-2-any.pkg.tar.xz";
    sha256      = "82e2f24332caa7f3b15d58bc5161df91de50f3ea76727d933c8a2b3c1c4720e3";
    buildInputs = [ python2 ];
  };

  "python2-flexmock" = fetch {
    name        = "python2-flexmock";
    version     = "0.10.2";
    filename    = "mingw-w64-x86_64-python2-flexmock-0.10.2-1-any.pkg.tar.xz";
    sha256      = "c20cbeaaaeb53e3c053315f1189a9245f196e4f8f007f5664bbe620ae8b468ca";
    buildInputs = [ python2 ];
  };

  "python2-fonttools" = fetch {
    name        = "python2-fonttools";
    version     = "3.30.0";
    filename    = "mingw-w64-x86_64-python2-fonttools-3.30.0-1-any.pkg.tar.xz";
    sha256      = "fd7b61fda70cc0ce6e6c8f2598aa3e1182622f7af7bf8471146d1d2d126db1ff";
    buildInputs = [ python2 python2-numpy ];
  };

  "python2-freezegun" = fetch {
    name        = "python2-freezegun";
    version     = "0.3.11";
    filename    = "mingw-w64-x86_64-python2-freezegun-0.3.11-1-any.pkg.tar.xz";
    sha256      = "bb4199051cfe139c48016758b7e633ef4d4afde2af25fe2f3bf8d51d21d8b60e";
    buildInputs = [ python2 python2-dateutil ];
  };

  "python2-funcsigs" = fetch {
    name        = "python2-funcsigs";
    version     = "1.0.2";
    filename    = "mingw-w64-x86_64-python2-funcsigs-1.0.2-2-any.pkg.tar.xz";
    sha256      = "7c4f9a6f2219452887e84999ba174f465753858973370df6de5b2132ac8f4223";
    buildInputs = [ python2 ];
  };

  "python2-functools32" = fetch {
    name        = "python2-functools32";
    version     = "3.2.3_2";
    filename    = "mingw-w64-x86_64-python2-functools32-3.2.3_2-1-any.pkg.tar.xz";
    sha256      = "fdbfecdf1871ab4775fe0ce1fce35ec5f6aad753efe0a8b42110f9cedaa00064";
    buildInputs = [ python2 ];
  };

  "python2-future" = fetch {
    name        = "python2-future";
    version     = "0.17.1";
    filename    = "mingw-w64-x86_64-python2-future-0.17.1-1-any.pkg.tar.xz";
    sha256      = "09733cd360355d7bf8d5e46f4d91ba99696ff4e89752a1c8f964b8ac1138b9b5";
    buildInputs = [ python2 ];
  };

  "python2-futures" = fetch {
    name        = "python2-futures";
    version     = "3.2.0";
    filename    = "mingw-w64-x86_64-python2-futures-3.2.0-1-any.pkg.tar.xz";
    sha256      = "b7d3cd83f40065170ce7c4835c0562e12f61e177c49f5ccce8d81adac484c0fe";
    buildInputs = [ python2 ];
  };

  "python2-genty" = fetch {
    name        = "python2-genty";
    version     = "1.3.2";
    filename    = "mingw-w64-x86_64-python2-genty-1.3.2-2-any.pkg.tar.xz";
    sha256      = "a86d8cdaf8ece17a73b5aa5e34b2380ca64706624ffcce7c256988dbecb6b13b";
    buildInputs = [ python2 python2-six ];
  };

  "python2-gmpy2" = fetch {
    name        = "python2-gmpy2";
    version     = "2.1.0a4";
    filename    = "mingw-w64-x86_64-python2-gmpy2-2.1.0a4-1-any.pkg.tar.xz";
    sha256      = "7c1baed0489862f01425456af80cf6d74a3bdf82fb4ec557f022c48b7f2e9654";
    buildInputs = [ python2 mpc ];
  };

  "python2-gobject" = fetch {
    name        = "python2-gobject";
    version     = "3.30.4";
    filename    = "mingw-w64-x86_64-python2-gobject-3.30.4-1-any.pkg.tar.xz";
    sha256      = "6d39eb0b02b9dd48424a9ba0904cd31e8ea59d9c384f56cb587d286eb0f46a70";
    buildInputs = [ glib2 python2-cairo libffi gobject-introspection-runtime (assert pygobject-devel.version=="3.30.4"; pygobject-devel) ];
  };

  "python2-gobject2" = fetch {
    name        = "python2-gobject2";
    version     = "2.28.7";
    filename    = "mingw-w64-x86_64-python2-gobject2-2.28.7-1-any.pkg.tar.xz";
    sha256      = "547b13fd9a57a891c9e6c43d65b23d7b4943ade8ead4064a893e411f0dc9d047";
    buildInputs = [ glib2 libffi gobject-introspection-runtime (assert pygobject2-devel.version=="2.28.7"; pygobject2-devel) ];
  };

  "python2-greenlet" = fetch {
    name        = "python2-greenlet";
    version     = "0.4.15";
    filename    = "mingw-w64-x86_64-python2-greenlet-0.4.15-1-any.pkg.tar.xz";
    sha256      = "e3868cbe9f04a2b433b6e59b2521ae70bc23cddcf7710b6f2c42e310e2137bce";
    buildInputs = [ python2 ];
  };

  "python2-h5py" = fetch {
    name        = "python2-h5py";
    version     = "2.9.0";
    filename    = "mingw-w64-x86_64-python2-h5py-2.9.0-1-any.pkg.tar.xz";
    sha256      = "ddc48dd0117eb7c564ed8240e00d89b4c8a527d44e5b839cb3b0d4e069cff2cc";
    buildInputs = [ python2-numpy python2-six hdf5 ];
  };

  "python2-hacking" = fetch {
    name        = "python2-hacking";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python2-hacking-1.1.0-1-any.pkg.tar.xz";
    sha256      = "e035ecf77472bb0c82ff835b2b661115c5840ad28fcf9df7ce8083aff92507ce";
    buildInputs = [ python2 ];
  };

  "python2-html5lib" = fetch {
    name        = "python2-html5lib";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python2-html5lib-1.0.1-3-any.pkg.tar.xz";
    sha256      = "08fd6feaf3fa846247cdafdaee9929da9576c7fa11937344213f9cc788f3938b";
    buildInputs = [ python2 python2-six python2-webencodings ];
  };

  "python2-httplib2" = fetch {
    name        = "python2-httplib2";
    version     = "0.12.0";
    filename    = "mingw-w64-x86_64-python2-httplib2-0.12.0-1-any.pkg.tar.xz";
    sha256      = "c5314ce5023d95f3bde43918e688389607478bd7441285ea0a607d5bfd875036";
    buildInputs = [ python2 python2-certifi ca-certificates ];
  };

  "python2-hypothesis" = fetch {
    name        = "python2-hypothesis";
    version     = "3.84.4";
    filename    = "mingw-w64-x86_64-python2-hypothesis-3.84.4-1-any.pkg.tar.xz";
    sha256      = "d062702715731e83cd3dc285988093d9d9869efc58a9c723a43aa1ed62a53828";
    buildInputs = [ python2 python2-attrs python2-coverage python2-enum34 ];
  };

  "python2-icu" = fetch {
    name        = "python2-icu";
    version     = "2.2";
    filename    = "mingw-w64-x86_64-python2-icu-2.2-1-any.pkg.tar.xz";
    sha256      = "e750686ef326b5ec1d292f1f7bbe4e17860afa3f288aaa734228ab53ce3854d5";
    buildInputs = [ python2 icu ];
  };

  "python2-idna" = fetch {
    name        = "python2-idna";
    version     = "2.8";
    filename    = "mingw-w64-x86_64-python2-idna-2.8-1-any.pkg.tar.xz";
    sha256      = "833fee2b858ea2cca80cb28f3aa753aa440d665f1dbe49f73d3a3b84f0a43ca0";
    buildInputs = [  ];
  };

  "python2-ifaddr" = fetch {
    name        = "python2-ifaddr";
    version     = "0.1.6";
    filename    = "mingw-w64-x86_64-python2-ifaddr-0.1.6-1-any.pkg.tar.xz";
    sha256      = "03f805863d9a2e468595f9352dc67e289d26266fe473a897e9a483b6736d94c1";
    buildInputs = [ python2 python2-ipaddress ];
  };

  "python2-imagesize" = fetch {
    name        = "python2-imagesize";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python2-imagesize-1.1.0-1-any.pkg.tar.xz";
    sha256      = "6f918724fabf140ea71958ab5966612c1190517703b3ced7d5022f051e1715c3";
    buildInputs = [ python2 ];
  };

  "python2-importlib-metadata" = fetch {
    name        = "python2-importlib-metadata";
    version     = "0.7";
    filename    = "mingw-w64-x86_64-python2-importlib-metadata-0.7-1-any.pkg.tar.xz";
    sha256      = "4b79f203e9e5c29d7e83d9a68f0ec5263b3c4def9f92bc34a8604e41913ddcc0";
    buildInputs = [ python2 python2-contextlib2 python2-pathlib2 ];
  };

  "python2-importlib_resources" = fetch {
    name        = "python2-importlib_resources";
    version     = "1.0.2";
    filename    = "mingw-w64-x86_64-python2-importlib_resources-1.0.2-1-any.pkg.tar.xz";
    sha256      = "750bbaee0d74877148cbf19c0c0b53f947dc2fa4c338c60f956c8ea9af21ba7d";
    buildInputs = [ python2 python2-typing python2-pathlib2 ];
  };

  "python2-iniconfig" = fetch {
    name        = "python2-iniconfig";
    version     = "1.0.0";
    filename    = "mingw-w64-x86_64-python2-iniconfig-1.0.0-2-any.pkg.tar.xz";
    sha256      = "87284b49fe4f4fcd6f39c606b108aedfa40453e69056b1df16b3633b3e2eb9d0";
    buildInputs = [ python2 ];
  };

  "python2-iocapture" = fetch {
    name        = "python2-iocapture";
    version     = "0.1.2";
    filename    = "mingw-w64-x86_64-python2-iocapture-0.1.2-1-any.pkg.tar.xz";
    sha256      = "9cdd50869e727a0e6f9f6a56cbc8f6965ee5781227ed123fbf8aefe01e1dcfb2";
    buildInputs = [ python2 ];
  };

  "python2-ipaddress" = fetch {
    name        = "python2-ipaddress";
    version     = "1.0.22";
    filename    = "mingw-w64-x86_64-python2-ipaddress-1.0.22-1-any.pkg.tar.xz";
    sha256      = "ff81324a7b585bb04294ef444a9f25460c59bba7027ba1e6928d2944824c1cdc";
    buildInputs = [  ];
  };

  "python2-ipykernel" = fetch {
    name        = "python2-ipykernel";
    version     = "4.9.0";
    filename    = "mingw-w64-x86_64-python2-ipykernel-4.9.0-2-any.pkg.tar.xz";
    sha256      = "c316928468749836994b7fd5f2ae377512007438ca3cec73f770094c86cab937";
    buildInputs = [ python2 self."python2-backports.shutil_get_terminal_size" python2-pathlib2 python2-pyzmq python2-ipython ];
    broken      = true;
  };

  "python2-ipython" = fetch {
    name        = "python2-ipython";
    version     = "5.3.0";
    filename    = "mingw-w64-x86_64-python2-ipython-5.3.0-8-any.pkg.tar.xz";
    sha256      = "eb1b9dc8f72599d4240270e9963e7a00e7a080f9b189f364c7991c52af13655c";
    buildInputs = [ winpty sqlite3 python2-traitlets python2-simplegeneric python2-pickleshare python2-prompt_toolkit self."python2-backports.shutil_get_terminal_size" python2-jedi python2-win_unicode_console ];
    broken      = true;
  };

  "python2-ipython_genutils" = fetch {
    name        = "python2-ipython_genutils";
    version     = "0.2.0";
    filename    = "mingw-w64-x86_64-python2-ipython_genutils-0.2.0-2-any.pkg.tar.xz";
    sha256      = "932941e3b7fa2538409fa42b0e782bb9dae49eef7fc0c5ba544200b42d0da007";
    buildInputs = [ python2 ];
  };

  "python2-ipywidgets" = fetch {
    name        = "python2-ipywidgets";
    version     = "7.4.2";
    filename    = "mingw-w64-x86_64-python2-ipywidgets-7.4.2-1-any.pkg.tar.xz";
    sha256      = "c59db906edbc621e792516df0beaee366cd04554bb4fa5633a1a856eecea2bdf";
    buildInputs = [ python2 ];
  };

  "python2-iso8601" = fetch {
    name        = "python2-iso8601";
    version     = "0.1.12";
    filename    = "mingw-w64-x86_64-python2-iso8601-0.1.12-1-any.pkg.tar.xz";
    sha256      = "fb60848af84afe061f2c3ab6b647f840e912e39a9d84f0a0c9943d1884620f4a";
    buildInputs = [ python2 ];
  };

  "python2-isort" = fetch {
    name        = "python2-isort";
    version     = "4.3.4";
    filename    = "mingw-w64-x86_64-python2-isort-4.3.4-1-any.pkg.tar.xz";
    sha256      = "f6f1a8beb59ffe6ba65af6505d4b24a24e8c62469d6178c57fee1aede4e5b034";
    buildInputs = [ python2 python2-futures ];
  };

  "python2-jdcal" = fetch {
    name        = "python2-jdcal";
    version     = "1.4";
    filename    = "mingw-w64-x86_64-python2-jdcal-1.4-2-any.pkg.tar.xz";
    sha256      = "fd8e7daa24ca3afd9a327122e1394857c251534646e92f905485e4863ff1393d";
    buildInputs = [ python2 ];
  };

  "python2-jedi" = fetch {
    name        = "python2-jedi";
    version     = "0.13.1";
    filename    = "mingw-w64-x86_64-python2-jedi-0.13.1-1-any.pkg.tar.xz";
    sha256      = "064cdaedb88e752f0e2d11a2e5e8780df7eae638a7309894b60f7e7e6d44d05c";
    buildInputs = [ python2 python2-parso ];
  };

  "python2-jinja" = fetch {
    name        = "python2-jinja";
    version     = "2.10";
    filename    = "mingw-w64-x86_64-python2-jinja-2.10-2-any.pkg.tar.xz";
    sha256      = "9614f28cb4d664c3b0f83404f49466d3d94af3fbd25450dd5f77873c2de9adc0";
    buildInputs = [ python2-setuptools python2-markupsafe ];
  };

  "python2-json-rpc" = fetch {
    name        = "python2-json-rpc";
    version     = "1.11.1";
    filename    = "mingw-w64-x86_64-python2-json-rpc-1.11.1-1-any.pkg.tar.xz";
    sha256      = "bb6f810d7fe5e3a3f19cba8f70c403834f6713811694044590865653c259cfeb";
    buildInputs = [ python2 ];
  };

  "python2-jsonschema" = fetch {
    name        = "python2-jsonschema";
    version     = "2.6.0";
    filename    = "mingw-w64-x86_64-python2-jsonschema-2.6.0-5-any.pkg.tar.xz";
    sha256      = "278db29f33319ec75a8bd38ec0bdb32f5672e72b823cc588487c9690682595c2";
    buildInputs = [ python2 python2-functools32 ];
  };

  "python2-jupyter_client" = fetch {
    name        = "python2-jupyter_client";
    version     = "5.2.4";
    filename    = "mingw-w64-x86_64-python2-jupyter_client-5.2.4-1-any.pkg.tar.xz";
    sha256      = "cebf79b7fc3ebf64d63be1e3433c90e6a7ae50c359fd3cf7c3cda7a377337058";
    buildInputs = [ python2-ipykernel python2-jupyter_core python2-pyzmq ];
    broken      = true;
  };

  "python2-jupyter_console" = fetch {
    name        = "python2-jupyter_console";
    version     = "5.2.0";
    filename    = "mingw-w64-x86_64-python2-jupyter_console-5.2.0-3-any.pkg.tar.xz";
    sha256      = "f5708d21fde18c0360d865f175df4bc170522ee9ad47bef476e3b07f12d1e8a0";
    buildInputs = [ python2 python2-jupyter_core python2-jupyter_client python2-colorama ];
    broken      = true;
  };

  "python2-jupyter_core" = fetch {
    name        = "python2-jupyter_core";
    version     = "4.4.0";
    filename    = "mingw-w64-x86_64-python2-jupyter_core-4.4.0-3-any.pkg.tar.xz";
    sha256      = "35fe87f90415bb74abee24bcd8dc126516c2bed72affa39524406e9b7621f1c7";
    buildInputs = [ python2 ];
  };

  "python2-kiwisolver" = fetch {
    name        = "python2-kiwisolver";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python2-kiwisolver-1.0.1-2-any.pkg.tar.xz";
    sha256      = "ab4b9b40d68646ded10d8d5099acdaa135697f84257ee110919c4f4fee3d4025";
    buildInputs = [ python2 ];
  };

  "python2-lazy-object-proxy" = fetch {
    name        = "python2-lazy-object-proxy";
    version     = "1.3.1";
    filename    = "mingw-w64-x86_64-python2-lazy-object-proxy-1.3.1-2-any.pkg.tar.xz";
    sha256      = "11ff71717b86e9727ff3e3bfad105cab813b5b8a23d5438b118132a210471910";
    buildInputs = [ python2 ];
  };

  "python2-ldap" = fetch {
    name        = "python2-ldap";
    version     = "3.1.0";
    filename    = "mingw-w64-x86_64-python2-ldap-3.1.0-1-any.pkg.tar.xz";
    sha256      = "3f19a6d80f14158805e136337871f4062ea1c7087172f61b0a3c54a365908dce";
    buildInputs = [ python2 ];
  };

  "python2-ldap3" = fetch {
    name        = "python2-ldap3";
    version     = "2.5.1";
    filename    = "mingw-w64-x86_64-python2-ldap3-2.5.1-1-any.pkg.tar.xz";
    sha256      = "0a97b2d570580365af7c8c8feaefc554356b9c293d1970be19b7ee42005c0c3c";
    buildInputs = [ python2 ];
  };

  "python2-lhafile" = fetch {
    name        = "python2-lhafile";
    version     = "0.2.1";
    filename    = "mingw-w64-x86_64-python2-lhafile-0.2.1-3-any.pkg.tar.xz";
    sha256      = "21f759062257b0481c802cf8ea020ef56f2f9b1a66a42bbbd4e7024f37ec2269";
    buildInputs = [ python2 python2-six ];
  };

  "python2-linecache2" = fetch {
    name        = "python2-linecache2";
    version     = "1.0.0";
    filename    = "mingw-w64-x86_64-python2-linecache2-1.0.0-1-any.pkg.tar.xz";
    sha256      = "9df30757cf6ed991058227d93bc43e3c4f36efae5d67eedc67b7396f1d5ef356";
    buildInputs = [ python2 ];
  };

  "python2-lockfile" = fetch {
    name        = "python2-lockfile";
    version     = "0.12.2";
    filename    = "mingw-w64-x86_64-python2-lockfile-0.12.2-1-any.pkg.tar.xz";
    sha256      = "ace3a0ce68bd41aa94165fbd79c6bb6df30df9d4b98293c5e852cfe7e83f41af";
    buildInputs = [ python2 ];
  };

  "python2-lxml" = fetch {
    name        = "python2-lxml";
    version     = "4.2.5";
    filename    = "mingw-w64-x86_64-python2-lxml-4.2.5-1-any.pkg.tar.xz";
    sha256      = "3e1655dc16a01c8d32387457447f49970d37d66f871eee2004e65c82719d9774";
    buildInputs = [ python2 libxslt ];
  };

  "python2-mako" = fetch {
    name        = "python2-mako";
    version     = "1.0.7";
    filename    = "mingw-w64-x86_64-python2-mako-1.0.7-3-any.pkg.tar.xz";
    sha256      = "6d47bed080238030efd9a2d7e4274808a5d7e3bdebe39b71c0567ad6839c4df0";
    buildInputs = [ python2-markupsafe python2-beaker ];
  };

  "python2-markdown" = fetch {
    name        = "python2-markdown";
    version     = "3.0.1";
    filename    = "mingw-w64-x86_64-python2-markdown-3.0.1-1-any.pkg.tar.xz";
    sha256      = "0855cda731cfc4cf47acdaf14cf12a4d619271248baabf1ee5d87fd341703d00";
    buildInputs = [ python2 ];
  };

  "python2-markupsafe" = fetch {
    name        = "python2-markupsafe";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python2-markupsafe-1.1.0-1-any.pkg.tar.xz";
    sha256      = "593fd31d9f0a2e7c1adb50f23ed12f5fe75f9fc577253ad678fb2b396f5ad418";
    buildInputs = [ python2 ];
  };

  "python2-matplotlib" = fetch {
    name        = "python2-matplotlib";
    version     = "2.2.3";
    filename    = "mingw-w64-x86_64-python2-matplotlib-2.2.3-4-any.pkg.tar.xz";
    sha256      = "430588c8c15b256556ba3a51ebe32f357e80ea70f056e86d99fc48ba51a2c74c";
    buildInputs = [ python2-pytz python2-numpy python2-cairo python2-cycler python2-pyqt5 python2-dateutil python2-pyparsing python2-kiwisolver self."python2-backports.functools_lru_cache" freetype libpng ];
    broken      = true;
  };

  "python2-mccabe" = fetch {
    name        = "python2-mccabe";
    version     = "0.6.1";
    filename    = "mingw-w64-x86_64-python2-mccabe-0.6.1-1-any.pkg.tar.xz";
    sha256      = "8c2667025e973ed80429293aff8b38b27e8c545165e8aa3edccba9be40d3f4da";
    buildInputs = [ python2 ];
  };

  "python2-mimeparse" = fetch {
    name        = "python2-mimeparse";
    version     = "1.6.0";
    filename    = "mingw-w64-x86_64-python2-mimeparse-1.6.0-1-any.pkg.tar.xz";
    sha256      = "c67366bb0a7182b4ec91ffc1ca3ab8925a70b22d18f9a554eb7ba160d097d1d9";
    buildInputs = [ python2 ];
  };

  "python2-mistune" = fetch {
    name        = "python2-mistune";
    version     = "0.8.4";
    filename    = "mingw-w64-x86_64-python2-mistune-0.8.4-1-any.pkg.tar.xz";
    sha256      = "26938d6b05aa2f052b56f09094dd3b82adc8bf603640f0d7721ca09d0270e7b1";
    buildInputs = [ python2 ];
  };

  "python2-mock" = fetch {
    name        = "python2-mock";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-python2-mock-2.0.0-3-any.pkg.tar.xz";
    sha256      = "1fe30e706d4c7560ec52d605d7d45fa784b2a796097703df383f741427357bf9";
    buildInputs = [ python2 python2-six python3-pbr ];
  };

  "python2-monotonic" = fetch {
    name        = "python2-monotonic";
    version     = "1.5";
    filename    = "mingw-w64-x86_64-python2-monotonic-1.5-1-any.pkg.tar.xz";
    sha256      = "2abd95a14d718b6c7a617ded0955c65deae97b38581cfd50342aa914a4af0396";
    buildInputs = [ python2 ];
  };

  "python2-more-itertools" = fetch {
    name        = "python2-more-itertools";
    version     = "4.3.1";
    filename    = "mingw-w64-x86_64-python2-more-itertools-4.3.1-1-any.pkg.tar.xz";
    sha256      = "2ef01f1b9bdbf311f8228ecdca7626bd5ec68bd42ed0480037808e0feb86ce8a";
    buildInputs = [ python2 python2-six ];
  };

  "python2-mox3" = fetch {
    name        = "python2-mox3";
    version     = "0.26.0";
    filename    = "mingw-w64-x86_64-python2-mox3-0.26.0-1-any.pkg.tar.xz";
    sha256      = "930a8eb563f169f8314ec5fc58390a8e6b1b77358cc939d1feda441d52fadf9f";
    buildInputs = [ python2 python2-pbr python2-fixtures ];
  };

  "python2-mpmath" = fetch {
    name        = "python2-mpmath";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python2-mpmath-1.1.0-1-any.pkg.tar.xz";
    sha256      = "eebf233d8a134e027a2fb50ed39c61571eb64e64e3a8bbebcfaa17f5a08e498f";
    buildInputs = [ python2 python2-gmpy2 ];
  };

  "python2-msgpack" = fetch {
    name        = "python2-msgpack";
    version     = "0.5.6";
    filename    = "mingw-w64-x86_64-python2-msgpack-0.5.6-1-any.pkg.tar.xz";
    sha256      = "07dad72b536f718c30b92925f77cc3349377f17db59f1e6a0adb1d4ceb36122a";
    buildInputs = [ python2 ];
  };

  "python2-mysql" = fetch {
    name        = "python2-mysql";
    version     = "1.2.5";
    filename    = "mingw-w64-x86_64-python2-mysql-1.2.5-2-any.pkg.tar.xz";
    sha256      = "d18c1e0975020a7b8cbd07a391bd63729d7ed9d713ab30a91db48991ad410c3d";
    buildInputs = [ python2 libmariadbclient ];
  };

  "python2-ndg-httpsclient" = fetch {
    name        = "python2-ndg-httpsclient";
    version     = "0.5.1";
    filename    = "mingw-w64-x86_64-python2-ndg-httpsclient-0.5.1-1-any.pkg.tar.xz";
    sha256      = "f97aec6cc4bb33953add0f4ec98dc923e34a408fd8b7ec2538f475a98d6630dd";
    buildInputs = [ python2-pyopenssl python2-pyasn1 ];
  };

  "python2-netaddr" = fetch {
    name        = "python2-netaddr";
    version     = "0.7.19";
    filename    = "mingw-w64-x86_64-python2-netaddr-0.7.19-1-any.pkg.tar.xz";
    sha256      = "301b0d0750f9794a64fe958e1e13c2cd36acdedbb55397fcd1f1710fd5370072";
    buildInputs = [ python2 ];
  };

  "python2-netifaces" = fetch {
    name        = "python2-netifaces";
    version     = "0.10.7";
    filename    = "mingw-w64-x86_64-python2-netifaces-0.10.7-1-any.pkg.tar.xz";
    sha256      = "5dfb14cf9bbc5d4ce078c2c44f0652899efbb0e23f4531a5ca60865097c16e17";
    buildInputs = [ python2 ];
  };

  "python2-networkx" = fetch {
    name        = "python2-networkx";
    version     = "2.2";
    filename    = "mingw-w64-x86_64-python2-networkx-2.2-1-any.pkg.tar.xz";
    sha256      = "3fd7e511a713b1a044ca32dbdab2a53f1227aa7d09e0252e0000ebc5fffba065";
    buildInputs = [ python2 python2-decorator ];
  };

  "python2-nose" = fetch {
    name        = "python2-nose";
    version     = "1.3.7";
    filename    = "mingw-w64-x86_64-python2-nose-1.3.7-8-any.pkg.tar.xz";
    sha256      = "24ae9bd3f2b1aee06ec73d0307507480dac0345cff254284e5426dc13a6eda7f";
    buildInputs = [ python2-setuptools ];
  };

  "python2-nuitka" = fetch {
    name        = "python2-nuitka";
    version     = "0.6.0.6";
    filename    = "mingw-w64-x86_64-python2-nuitka-0.6.0.6-1-any.pkg.tar.xz";
    sha256      = "6c48367be69a938575a589e0775d6f7b7355f460d015b059554dea124d6f514c";
    buildInputs = [ python2-setuptools ];
  };

  "python2-numexpr" = fetch {
    name        = "python2-numexpr";
    version     = "2.6.8";
    filename    = "mingw-w64-x86_64-python2-numexpr-2.6.8-1-any.pkg.tar.xz";
    sha256      = "9ae97c0d40c7604d678b8fd94a74cdcfdfed994d6372fea6158e16f46d09d207";
    buildInputs = [ python2-numpy ];
  };

  "python2-numpy" = fetch {
    name        = "python2-numpy";
    version     = "1.15.4";
    filename    = "mingw-w64-x86_64-python2-numpy-1.15.4-1-any.pkg.tar.xz";
    sha256      = "132d7b79da6f0c2db37ceb9662b7ce32d8e07fd2f5b53f34cb83b416100703b6";
    buildInputs = [ openblas python2 ];
  };

  "python2-olefile" = fetch {
    name        = "python2-olefile";
    version     = "0.46";
    filename    = "mingw-w64-x86_64-python2-olefile-0.46-1-any.pkg.tar.xz";
    sha256      = "2d691bc26f471bb7cb256d295da4848fd1d0f9301dec8e9e16ee90e24da656cb";
    buildInputs = [ python2 ];
  };

  "python2-openmdao" = fetch {
    name        = "python2-openmdao";
    version     = "2.5.0";
    filename    = "mingw-w64-x86_64-python2-openmdao-2.5.0-1-any.pkg.tar.xz";
    sha256      = "c834b32d24a089bafe417bc87ad306d599a108bd53a058d75f41ef300cba1b62";
    buildInputs = [ python2-numpy python2-scipy python2-networkx python2-sqlitedict python2-pyparsing python2-six ];
  };

  "python2-openpyxl" = fetch {
    name        = "python2-openpyxl";
    version     = "2.5.9";
    filename    = "mingw-w64-x86_64-python2-openpyxl-2.5.9-1-any.pkg.tar.xz";
    sha256      = "253fd888db26544c89e032c37df3890049454ec76aec9ad05a162ee97ba07575";
    buildInputs = [ python2-jdcal python2-et-xmlfile ];
  };

  "python2-oslo-concurrency" = fetch {
    name        = "python2-oslo-concurrency";
    version     = "3.29.0";
    filename    = "mingw-w64-x86_64-python2-oslo-concurrency-3.29.0-1-any.pkg.tar.xz";
    sha256      = "f839e4310da4cce75588b103f879f8e2a6e57369ca02b6156f2dd73c8fb84b3e";
    buildInputs = [ python2 python2-six python2-pbr python2-oslo-config python2-oslo-i18n python2-oslo-utils python2-fasteners python2-enum34 ];
  };

  "python2-oslo-config" = fetch {
    name        = "python2-oslo-config";
    version     = "6.7.0";
    filename    = "mingw-w64-x86_64-python2-oslo-config-6.7.0-1-any.pkg.tar.xz";
    sha256      = "b5cf059b982c72ca1416f50c4012626f7e7b90746e7917a1366a7f2f327ae0d2";
    buildInputs = [ python2 python2-six python2-netaddr python2-stevedore python2-debtcollector python2-oslo-i18n python2-rfc3986 python2-yaml python2-enum34 ];
  };

  "python2-oslo-context" = fetch {
    name        = "python2-oslo-context";
    version     = "2.22.0";
    filename    = "mingw-w64-x86_64-python2-oslo-context-2.22.0-1-any.pkg.tar.xz";
    sha256      = "3d17329de2bf9c24069ad162997b00cf2a79b0bf38507359e73d95d8ce028be3";
    buildInputs = [ python2 python2-pbr python2-debtcollector ];
  };

  "python2-oslo-db" = fetch {
    name        = "python2-oslo-db";
    version     = "4.42.0";
    filename    = "mingw-w64-x86_64-python2-oslo-db-4.42.0-1-any.pkg.tar.xz";
    sha256      = "3dd510065cafa0bd89e76d7acd093c3a1e2a981f96d1def3ce4345d88849ae82";
    buildInputs = [ python2 python2-six python2-pbr python2-alembic python2-debtcollector python2-oslo-i18n python2-oslo-config python2-oslo-utils python2-sqlalchemy python2-sqlalchemy-migrate python2-stevedore ];
  };

  "python2-oslo-i18n" = fetch {
    name        = "python2-oslo-i18n";
    version     = "3.23.0";
    filename    = "mingw-w64-x86_64-python2-oslo-i18n-3.23.0-1-any.pkg.tar.xz";
    sha256      = "d221694b7c3dcbe4cc84d4962afafcdbdc69058663cdb529ae5a12b07848b6c3";
    buildInputs = [ python2 python2-six python2-pbr python2-babel ];
  };

  "python2-oslo-log" = fetch {
    name        = "python2-oslo-log";
    version     = "3.42.1";
    filename    = "mingw-w64-x86_64-python2-oslo-log-3.42.1-1-any.pkg.tar.xz";
    sha256      = "a20093b5b928be49fe25ff6a2de6bd05f1fab799338dd3569d25525d269bee98";
    buildInputs = [ python2 python2-six python2-pbr python2-oslo-config python2-oslo-context python2-oslo-i18n python2-oslo-utils python2-oslo-serialization python2-debtcollector python2-dateutil python2-monotonic ];
  };

  "python2-oslo-serialization" = fetch {
    name        = "python2-oslo-serialization";
    version     = "2.28.1";
    filename    = "mingw-w64-x86_64-python2-oslo-serialization-2.28.1-1-any.pkg.tar.xz";
    sha256      = "7121ee7283f820640d57e12772fc02e9d05874b411b8af1155da075151689ddb";
    buildInputs = [ python2 python2-six python2-pbr python2-babel python2-msgpack python2-oslo-utils python2-pytz ];
  };

  "python2-oslo-utils" = fetch {
    name        = "python2-oslo-utils";
    version     = "3.39.0";
    filename    = "mingw-w64-x86_64-python2-oslo-utils-3.39.0-1-any.pkg.tar.xz";
    sha256      = "62f95cad7bd408bbb01e03e67af311152bababd3528328f54e642a52a02d09ed";
    buildInputs = [ python2 ];
  };

  "python2-oslosphinx" = fetch {
    name        = "python2-oslosphinx";
    version     = "4.18.0";
    filename    = "mingw-w64-x86_64-python2-oslosphinx-4.18.0-1-any.pkg.tar.xz";
    sha256      = "eee1fcf2822b55b708020788d3e0320aef4f96fa0b962f82af47b2f923682ade";
    buildInputs = [ python2 python2-six python2-requests ];
  };

  "python2-oslotest" = fetch {
    name        = "python2-oslotest";
    version     = "3.7.0";
    filename    = "mingw-w64-x86_64-python2-oslotest-3.7.0-1-any.pkg.tar.xz";
    sha256      = "447c4f067ea89ba453099abb328e1e6ba112ba799f62313c1c07cccd8365e09e";
    buildInputs = [ python2 ];
  };

  "python2-packaging" = fetch {
    name        = "python2-packaging";
    version     = "18.0";
    filename    = "mingw-w64-x86_64-python2-packaging-18.0-1-any.pkg.tar.xz";
    sha256      = "3c6b58e49b919d88636d541dfa8ef44d6971a1684c708ed97c027e8aa4e306a7";
    buildInputs = [ python2 python2-pyparsing python2-six ];
  };

  "python2-pandas" = fetch {
    name        = "python2-pandas";
    version     = "0.23.4";
    filename    = "mingw-w64-x86_64-python2-pandas-0.23.4-1-any.pkg.tar.xz";
    sha256      = "590a92a6adf1f699c13bf6073bd412fa8b6021975219b7a5074e71fba88fb6c7";
    buildInputs = [ python2-numpy python2-pytz python2-dateutil python2-setuptools ];
  };

  "python2-pandocfilters" = fetch {
    name        = "python2-pandocfilters";
    version     = "1.4.2";
    filename    = "mingw-w64-x86_64-python2-pandocfilters-1.4.2-2-any.pkg.tar.xz";
    sha256      = "8fd634f5001b997b2dd683980c9c22307eb0313da25613ddbf274eab216adaa7";
    buildInputs = [ python2 ];
  };

  "python2-paramiko" = fetch {
    name        = "python2-paramiko";
    version     = "2.4.2";
    filename    = "mingw-w64-x86_64-python2-paramiko-2.4.2-1-any.pkg.tar.xz";
    sha256      = "a46649ad051802f6171cb162f3411e8746f3315f168b621b120fdf21fb83aac1";
    buildInputs = [ python2 ];
  };

  "python2-parso" = fetch {
    name        = "python2-parso";
    version     = "0.3.1";
    filename    = "mingw-w64-x86_64-python2-parso-0.3.1-1-any.pkg.tar.xz";
    sha256      = "749e71472c4180973ff4c6ada35552ee045ae40bae99743ae042ef84782c35d3";
    buildInputs = [ python2 ];
  };

  "python2-path" = fetch {
    name        = "python2-path";
    version     = "11.5.0";
    filename    = "mingw-w64-x86_64-python2-path-11.5.0-1-any.pkg.tar.xz";
    sha256      = "abad8fb3d4c2ea861c40e616893b0d099aa561f7c5c7d269632b3d99d5d53034";
    buildInputs = [ python2 python2-importlib-metadata self."python2-backports.os" ];
  };

  "python2-pathlib" = fetch {
    name        = "python2-pathlib";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python2-pathlib-1.0.1-1-any.pkg.tar.xz";
    sha256      = "4bdc6a361d4dce8fd9da515a382201ca1baa6d336d0cd7d3acdffe46852c41bc";
    buildInputs = [ python2 ];
  };

  "python2-pathlib2" = fetch {
    name        = "python2-pathlib2";
    version     = "2.3.3";
    filename    = "mingw-w64-x86_64-python2-pathlib2-2.3.3-1-any.pkg.tar.xz";
    sha256      = "029f13a3433eb79ded0ce8d334e00326791f34d2f7feb4b60592ce70a8f87309";
    buildInputs = [ python2 python2-scandir ];
  };

  "python2-pathtools" = fetch {
    name        = "python2-pathtools";
    version     = "0.1.2";
    filename    = "mingw-w64-x86_64-python2-pathtools-0.1.2-1-any.pkg.tar.xz";
    sha256      = "98303c39132b133b76bb1ae5260b9cb13c3dd16f1395207bc9b33df8b68eebf5";
    buildInputs = [ python2 ];
  };

  "python2-patsy" = fetch {
    name        = "python2-patsy";
    version     = "0.5.0";
    filename    = "mingw-w64-x86_64-python2-patsy-0.5.0-2-any.pkg.tar.xz";
    sha256      = "f83fe7f0e93940ccb339eacd8b41f9b592d4b83ac4804e8ea9720837aeed2c93";
    buildInputs = [ python2-numpy ];
  };

  "python2-pbr" = fetch {
    name        = "python2-pbr";
    version     = "5.1.1";
    filename    = "mingw-w64-x86_64-python2-pbr-5.1.1-2-any.pkg.tar.xz";
    sha256      = "6306c5a82f6098f18dbbf469db278a939cdc8a98a40fe120dd42108016b95783";
    buildInputs = [ python2-setuptools ];
  };

  "python2-pdfrw" = fetch {
    name        = "python2-pdfrw";
    version     = "0.4";
    filename    = "mingw-w64-x86_64-python2-pdfrw-0.4-2-any.pkg.tar.xz";
    sha256      = "a3f2b83e91065d7f58579cdfe16d7cdc410e063ce70f5b2221312eaeaa5004a0";
    buildInputs = [ python2 ];
  };

  "python2-pep517" = fetch {
    name        = "python2-pep517";
    version     = "0.5.0";
    filename    = "mingw-w64-x86_64-python2-pep517-0.5.0-1-any.pkg.tar.xz";
    sha256      = "0f7b599dbb6f98c2cd2929037b931c300d37edde417f03d7d91d19dd22f7f55c";
    buildInputs = [ python2 ];
  };

  "python2-pexpect" = fetch {
    name        = "python2-pexpect";
    version     = "4.6.0";
    filename    = "mingw-w64-x86_64-python2-pexpect-4.6.0-1-any.pkg.tar.xz";
    sha256      = "30ab798c5443fd89fdf1cf4fb8107fb5ec060814a8a3bcbf69744e670b9c5f11";
    buildInputs = [ python2 python2-ptyprocess ];
  };

  "python2-pgen2" = fetch {
    name        = "python2-pgen2";
    version     = "0.1.0";
    filename    = "mingw-w64-x86_64-python2-pgen2-0.1.0-3-any.pkg.tar.xz";
    sha256      = "e828bcfdfa31d2bdeaab7b0ebe597ac0ce5e7473f1f190a6c87d55166a074260";
    buildInputs = [ python2 ];
  };

  "python2-pickleshare" = fetch {
    name        = "python2-pickleshare";
    version     = "0.7.5";
    filename    = "mingw-w64-x86_64-python2-pickleshare-0.7.5-1-any.pkg.tar.xz";
    sha256      = "c4fceca804eaef16ff7237e5040cbcd1a3ee1f1584c49e15967e53b47f0974ec";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2-path.version "8.1"; python2-path) ];
  };

  "python2-pillow" = fetch {
    name        = "python2-pillow";
    version     = "5.3.0";
    filename    = "mingw-w64-x86_64-python2-pillow-5.3.0-1-any.pkg.tar.xz";
    sha256      = "2460bb2da21c126ced958ebeae9b8d1904510a3079e9fecabcfa6e1c63f880db";
    buildInputs = [ freetype lcms2 libjpeg libtiff libwebp openjpeg2 zlib python2 python2-olefile ];
  };

  "python2-pip" = fetch {
    name        = "python2-pip";
    version     = "18.1";
    filename    = "mingw-w64-x86_64-python2-pip-18.1-2-any.pkg.tar.xz";
    sha256      = "06ea0a2d65c16d83d374e6f35bc808c1f552696d332f437ad50a9f3b809a7663";
    buildInputs = [ python2-setuptools python2-appdirs python2-cachecontrol python2-colorama python2-distlib python2-html5lib python2-lockfile python2-msgpack python2-packaging python2-pep517 python2-progress python2-pyparsing python2-pytoml python2-requests python2-retrying python2-six python2-webencodings python2-ipaddress ];
  };

  "python2-pkginfo" = fetch {
    name        = "python2-pkginfo";
    version     = "1.4.2";
    filename    = "mingw-w64-x86_64-python2-pkginfo-1.4.2-1-any.pkg.tar.xz";
    sha256      = "f53c56eb9847443f2417dca1a9550e5be75cc02d67c3584204b687987667e2e6";
    buildInputs = [ python2 ];
  };

  "python2-pluggy" = fetch {
    name        = "python2-pluggy";
    version     = "0.8.0";
    filename    = "mingw-w64-x86_64-python2-pluggy-0.8.0-2-any.pkg.tar.xz";
    sha256      = "078233c25942280f192a3da63f64f063481ab6cae97e9565535331173d3eda3f";
    buildInputs = [ python2 ];
  };

  "python2-ply" = fetch {
    name        = "python2-ply";
    version     = "3.11";
    filename    = "mingw-w64-x86_64-python2-ply-3.11-2-any.pkg.tar.xz";
    sha256      = "28fd879a86a6f1ea49b12fd64bc00900db178af61af926358d6b9acbe43acf3d";
    buildInputs = [ python2 ];
  };

  "python2-pptx" = fetch {
    name        = "python2-pptx";
    version     = "0.6.10";
    filename    = "mingw-w64-x86_64-python2-pptx-0.6.10-1-any.pkg.tar.xz";
    sha256      = "f01e5bad07b6691e81422f20313db7ddbc4455725f15ee647139265b494a2411";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2-lxml.version "3.1.0"; python2-lxml) (assert stdenvNoCC.lib.versionAtLeast python2-pillow.version "2.6.1"; python2-pillow) (assert stdenvNoCC.lib.versionAtLeast python2-xlsxwriter.version "0.5.7"; python2-xlsxwriter) ];
  };

  "python2-pretend" = fetch {
    name        = "python2-pretend";
    version     = "1.0.9";
    filename    = "mingw-w64-x86_64-python2-pretend-1.0.9-2-any.pkg.tar.xz";
    sha256      = "30b0d5d80d99b99cb933ebe9b905c77750838a980010408167219ebda92abc2a";
    buildInputs = [ python2 ];
  };

  "python2-prettytable" = fetch {
    name        = "python2-prettytable";
    version     = "0.7.2";
    filename    = "mingw-w64-x86_64-python2-prettytable-0.7.2-2-any.pkg.tar.xz";
    sha256      = "60ed05349212b01b7db4ec80b6b5d3052c9d010ff2d57f0b7c49d4377018f2bd";
    buildInputs = [ python2 ];
  };

  "python2-progress" = fetch {
    name        = "python2-progress";
    version     = "1.4";
    filename    = "mingw-w64-x86_64-python2-progress-1.4-3-any.pkg.tar.xz";
    sha256      = "7c48c6f5effd65bfc6e0045b34f368bc53b31bacb7f6a6b2391d5434ad433b37";
    buildInputs = [ python2 ];
  };

  "python2-prometheus-client" = fetch {
    name        = "python2-prometheus-client";
    version     = "0.2.0";
    filename    = "mingw-w64-x86_64-python2-prometheus-client-0.2.0-1-any.pkg.tar.xz";
    sha256      = "f027bff67f638f6e3dc0bf0130fac937aeb30aec47e8b661f1cf4ddefa9840d6";
    buildInputs = [ python2 ];
  };

  "python2-prompt_toolkit" = fetch {
    name        = "python2-prompt_toolkit";
    version     = "1.0.15";
    filename    = "mingw-w64-x86_64-python2-prompt_toolkit-1.0.15-2-any.pkg.tar.xz";
    sha256      = "9f06a61e56665863905fa998590777945392108472aefed9167a28d23bcc793d";
    buildInputs = [ python2-pygments python2-six python2-wcwidth ];
  };

  "python2-psutil" = fetch {
    name        = "python2-psutil";
    version     = "5.4.8";
    filename    = "mingw-w64-x86_64-python2-psutil-5.4.8-1-any.pkg.tar.xz";
    sha256      = "b59024adbc49dacd51960cac1bc80097e5d15e60f208f2c232c9373d1ff1627b";
    buildInputs = [ python2 ];
  };

  "python2-psycopg2" = fetch {
    name        = "python2-psycopg2";
    version     = "2.7.6.1";
    filename    = "mingw-w64-x86_64-python2-psycopg2-2.7.6.1-1-any.pkg.tar.xz";
    sha256      = "343a0e1774aa924bbd8290690be22f5d729b3bac4e56f2291bb27c05f85edfb6";
    buildInputs = [ python2 ];
  };

  "python2-ptyprocess" = fetch {
    name        = "python2-ptyprocess";
    version     = "0.6.0";
    filename    = "mingw-w64-x86_64-python2-ptyprocess-0.6.0-1-any.pkg.tar.xz";
    sha256      = "bfb7cc2bd6d490c840163d6bfbb71fd14c8dd45f3fcdac9a014d0dfe376e2a73";
    buildInputs = [ python2 ];
  };

  "python2-py" = fetch {
    name        = "python2-py";
    version     = "1.7.0";
    filename    = "mingw-w64-x86_64-python2-py-1.7.0-1-any.pkg.tar.xz";
    sha256      = "60d690fdf2ec772caad86ad0f5b24672bc6fc090256e3d9af13a55a074af75ff";
    buildInputs = [ python2 ];
  };

  "python2-py-cpuinfo" = fetch {
    name        = "python2-py-cpuinfo";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-python2-py-cpuinfo-4.0.0-1-any.pkg.tar.xz";
    sha256      = "0b479a49d9c6ac91465a4266a8b1c0f7a06570a4d454a6594dbcdaafb8dbf6a0";
    buildInputs = [ python2 ];
  };

  "python2-pyamg" = fetch {
    name        = "python2-pyamg";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-python2-pyamg-4.0.0-1-any.pkg.tar.xz";
    sha256      = "9929daef0daf30cf7fd178102689395113bb843eb4d59af5f206006a60686dfa";
    buildInputs = [ python2 python2-scipy python2-numpy ];
  };

  "python2-pyasn1" = fetch {
    name        = "python2-pyasn1";
    version     = "0.4.4";
    filename    = "mingw-w64-x86_64-python2-pyasn1-0.4.4-1-any.pkg.tar.xz";
    sha256      = "3ba4d13c453a94bf61fb99575a021cab605de9b9865a23443c35c3467609798d";
    buildInputs = [  ];
  };

  "python2-pyasn1-modules" = fetch {
    name        = "python2-pyasn1-modules";
    version     = "0.2.2";
    filename    = "mingw-w64-x86_64-python2-pyasn1-modules-0.2.2-1-any.pkg.tar.xz";
    sha256      = "b7b6ad26e716a384fd6a5f38879c324f9b38c75278405fa463769ca6acc1324f";
  };

  "python2-pycodestyle" = fetch {
    name        = "python2-pycodestyle";
    version     = "2.4.0";
    filename    = "mingw-w64-x86_64-python2-pycodestyle-2.4.0-1-any.pkg.tar.xz";
    sha256      = "999a8c8854ac7ccb7c7e2fecb3f9131fde0305cfbee176252c3c5cb83587ad39";
    buildInputs = [ python2 ];
  };

  "python2-pycparser" = fetch {
    name        = "python2-pycparser";
    version     = "2.19";
    filename    = "mingw-w64-x86_64-python2-pycparser-2.19-1-any.pkg.tar.xz";
    sha256      = "b212bc0b4a950776439fcefef6eb6cc316fe62d7610e6e4191c4584ab35042a6";
    buildInputs = [ python2 python2-ply ];
  };

  "python2-pyflakes" = fetch {
    name        = "python2-pyflakes";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-python2-pyflakes-2.0.0-2-any.pkg.tar.xz";
    sha256      = "6cd783716294ac21f54399f940192dafcf4fa8e52f1fa58e18055b6c3a0c37ad";
    buildInputs = [ python2 ];
  };

  "python2-pyglet" = fetch {
    name        = "python2-pyglet";
    version     = "1.3.2";
    filename    = "mingw-w64-x86_64-python2-pyglet-1.3.2-1-any.pkg.tar.xz";
    sha256      = "a6d47a8e06510f9b54d541b5bb423ae811313fece8fa22940753a0ff1d9a760b";
    buildInputs = [ python2 python2-future ];
  };

  "python2-pygments" = fetch {
    name        = "python2-pygments";
    version     = "2.3.1";
    filename    = "mingw-w64-x86_64-python2-pygments-2.3.1-1-any.pkg.tar.xz";
    sha256      = "2e432ff61007c430eee1f0b522b0e1ad56106cdb346a5a1bc3851a43be767908";
    buildInputs = [ python2-setuptools ];
  };

  "python2-pygtk" = fetch {
    name        = "python2-pygtk";
    version     = "2.24.0";
    filename    = "mingw-w64-x86_64-python2-pygtk-2.24.0-6-any.pkg.tar.xz";
    sha256      = "30efa89d7d2fb2002820224b4de7764712ee50a7b442700e4788f16876901011";
    buildInputs = [ python2-cairo python2-gobject2 libglade ];
  };

  "python2-pylint" = fetch {
    name        = "python2-pylint";
    version     = "1.9.2";
    filename    = "mingw-w64-x86_64-python2-pylint-1.9.2-1-any.pkg.tar.xz";
    sha256      = "9c59dda8cb040d4c6e513507fc16a3791984fa69bd216526dd010384710ec544";
    buildInputs = [ python2-astroid self."python2-backports.functools_lru_cache" python2-colorama python2-configparser python2-isort python2-mccabe python2-setuptools python2-singledispatch python2-six ];
  };

  "python2-pynacl" = fetch {
    name        = "python2-pynacl";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-python2-pynacl-1.3.0-1-any.pkg.tar.xz";
    sha256      = "ec8ea2864225571b41b44e832180d297ab56bb3a5085e329d1f48292608b07cc";
    buildInputs = [ python2 ];
  };

  "python2-pyopenssl" = fetch {
    name        = "python2-pyopenssl";
    version     = "18.0.0";
    filename    = "mingw-w64-x86_64-python2-pyopenssl-18.0.0-3-any.pkg.tar.xz";
    sha256      = "9c39739d1dc46efda9c8961c1dc246d0972e3f7705d073d889a2b72a24dede27";
    buildInputs = [ openssl python2-cryptography python2-six ];
  };

  "python2-pyparsing" = fetch {
    name        = "python2-pyparsing";
    version     = "2.3.0";
    filename    = "mingw-w64-x86_64-python2-pyparsing-2.3.0-1-any.pkg.tar.xz";
    sha256      = "afb567a2c6da2450f8e32c27d759c12443fbd49e3731e93c453a0ca77ce3c3db";
    buildInputs = [ python2 ];
  };

  "python2-pyperclip" = fetch {
    name        = "python2-pyperclip";
    version     = "1.7.0";
    filename    = "mingw-w64-x86_64-python2-pyperclip-1.7.0-1-any.pkg.tar.xz";
    sha256      = "996794b2c168810e2304e4641e1f89c755946d184ec1d99e2b936243f1122d9c";
    buildInputs = [ python2 ];
  };

  "python2-pyqt4" = fetch {
    name        = "python2-pyqt4";
    version     = "4.11.4";
    filename    = "mingw-w64-x86_64-python2-pyqt4-4.11.4-2-any.pkg.tar.xz";
    sha256      = "19fa3056b99eda6a8b343d543188bd4c6b9e6a05a122c85fa77df707b03e9b38";
    buildInputs = [ python2-sip pyqt4-common python2 ];
  };

  "python2-pyqt5" = fetch {
    name        = "python2-pyqt5";
    version     = "5.11.3";
    filename    = "mingw-w64-x86_64-python2-pyqt5-5.11.3-1-any.pkg.tar.xz";
    sha256      = "858b1435f8c8462fc61da6ddf906b2b119e1142311e44fd7767cbfdeea56cb70";
    buildInputs = [ python2-sip pyqt5-common python2 ];
    broken      = true;
  };

  "python2-pyreadline" = fetch {
    name        = "python2-pyreadline";
    version     = "2.1";
    filename    = "mingw-w64-x86_64-python2-pyreadline-2.1-1-any.pkg.tar.xz";
    sha256      = "77c7c2ce87b975e296ab3521f516183684745080d4da6b9f6c72dd022eedc075";
    buildInputs = [ python2 ];
  };

  "python2-pyrsistent" = fetch {
    name        = "python2-pyrsistent";
    version     = "0.14.8";
    filename    = "mingw-w64-x86_64-python2-pyrsistent-0.14.8-1-any.pkg.tar.xz";
    sha256      = "94c74be7ca2c8c6fe770814284693787449a3951af8942c9c6f49a6f83e2da99";
    buildInputs = [ python2 ];
  };

  "python2-pyserial" = fetch {
    name        = "python2-pyserial";
    version     = "3.4";
    filename    = "mingw-w64-x86_64-python2-pyserial-3.4-1-any.pkg.tar.xz";
    sha256      = "99ed8168e76201243386fc1899880223873c4fa4ae822a13ff9ce9966bce7b9b";
    buildInputs = [ python2 ];
  };

  "python2-pyside-qt4" = fetch {
    name        = "python2-pyside-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-python2-pyside-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "affaca075438f4f77fe1b6d0b05f6e1b8ec1b4aa464a9fb2f159e97a5e15fead";
    buildInputs = [ pyside-common-qt4 python2 python2-shiboken-qt4 qt4 ];
  };

  "python2-pyside-tools-qt4" = fetch {
    name        = "python2-pyside-tools-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-python2-pyside-tools-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "5450bb220581dd8f30fc0ae5e721605bb1df6c1d9def898d53a2e57dfe5810e2";
    buildInputs = [ pyside-tools-common-qt4 python2-pyside-qt4 ];
  };

  "python2-pysocks" = fetch {
    name        = "python2-pysocks";
    version     = "1.6.8";
    filename    = "mingw-w64-x86_64-python2-pysocks-1.6.8-1-any.pkg.tar.xz";
    sha256      = "37b22ea37298ad51339621015d5c6fedca8b9cad52509b920dcf79d92b0df36e";
    buildInputs = [ python2 python2-win_inet_pton ];
  };

  "python2-pystemmer" = fetch {
    name        = "python2-pystemmer";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-python2-pystemmer-1.3.0-2-any.pkg.tar.xz";
    sha256      = "9132711e4b57b1bae16903fb299060a2bacb1db0340ce08a1658306391c5a090";
    buildInputs = [ python2 ];
  };

  "python2-pytest" = fetch {
    name        = "python2-pytest";
    version     = "4.0.2";
    filename    = "mingw-w64-x86_64-python2-pytest-4.0.2-1-any.pkg.tar.xz";
    sha256      = "ed7573b19bc3476d1f91d24d01f33c53e357d701eb95e38e6985dcec855e8af0";
    buildInputs = [ python2-py python2-pluggy python2-setuptools python2-colorama python2-funcsigs python2-six python2-atomicwrites python2-more-itertools python2-pathlib2 python2-attrs ];
  };

  "python2-pytest-benchmark" = fetch {
    name        = "python2-pytest-benchmark";
    version     = "3.1.1";
    filename    = "mingw-w64-x86_64-python2-pytest-benchmark-3.1.1-1-any.pkg.tar.xz";
    sha256      = "372587eadedc3b82acb9ac761c18ddd0c196c782a7430b5b8fac3d3fc646d97a";
    buildInputs = [ python2 python2-py-cpuinfo python2-statistics python2-pathlib python2-pytest ];
  };

  "python2-pytest-expect" = fetch {
    name        = "python2-pytest-expect";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python2-pytest-expect-1.1.0-1-any.pkg.tar.xz";
    sha256      = "fe7507f0e84717668ebc77352389f8243a342f8c274a25aedf689d0098d1e994";
    buildInputs = [ python2 python2-pytest python2-u-msgpack ];
  };

  "python2-pytest-forked" = fetch {
    name        = "python2-pytest-forked";
    version     = "0.2";
    filename    = "mingw-w64-x86_64-python2-pytest-forked-0.2-1-any.pkg.tar.xz";
    sha256      = "8796256388c361c829a74c7836ea5d8ca256c81afce222e99cd079de7a2cccd0";
    buildInputs = [ python2 python2-pytest ];
  };

  "python2-pytest-runner" = fetch {
    name        = "python2-pytest-runner";
    version     = "4.2";
    filename    = "mingw-w64-x86_64-python2-pytest-runner-4.2-4-any.pkg.tar.xz";
    sha256      = "15a7168eec76f83196c262e4ee61939145025b8fe4fb02eb8f1576a11c344f1b";
    buildInputs = [ python2 python2-pytest ];
  };

  "python2-pytest-xdist" = fetch {
    name        = "python2-pytest-xdist";
    version     = "1.25.0";
    filename    = "mingw-w64-x86_64-python2-pytest-xdist-1.25.0-1-any.pkg.tar.xz";
    sha256      = "cfb17024d69ae96cb47b087a1f8c7ecb3ad058cfdeb23ba92c153d2631365ace";
    buildInputs = [ python2 python2-pytest-forked python2-execnet ];
  };

  "python2-python_ics" = fetch {
    name        = "python2-python_ics";
    version     = "2.15";
    filename    = "mingw-w64-x86_64-python2-python_ics-2.15-1-any.pkg.tar.xz";
    sha256      = "e508a09537d8823c3a7bacd28fc755a84b297c52faa7b946cdc6ae05245c688a";
    buildInputs = [ python2 ];
  };

  "python2-pytoml" = fetch {
    name        = "python2-pytoml";
    version     = "0.1.20";
    filename    = "mingw-w64-x86_64-python2-pytoml-0.1.20-1-any.pkg.tar.xz";
    sha256      = "d70f269837d9f3b053595f9a63b913dbab052a36787a21e32131b67428afef78";
    buildInputs = [ python2 ];
  };

  "python2-pytz" = fetch {
    name        = "python2-pytz";
    version     = "2018.7";
    filename    = "mingw-w64-x86_64-python2-pytz-2018.7-1-any.pkg.tar.xz";
    sha256      = "16354de992062bb640168ee3c74e56f151983b1574bc4e74a1c61de3c9e069d4";
    buildInputs = [ python2 ];
  };

  "python2-pyu2f" = fetch {
    name        = "python2-pyu2f";
    version     = "0.1.4";
    filename    = "mingw-w64-x86_64-python2-pyu2f-0.1.4-1-any.pkg.tar.xz";
    sha256      = "362ad7f58e79bb974b0daec5b092c732fdbb80cb9b3c0a8abe4d02a7e6d81a7e";
    buildInputs = [ python2 ];
  };

  "python2-pywavelets" = fetch {
    name        = "python2-pywavelets";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python2-pywavelets-1.0.1-1-any.pkg.tar.xz";
    sha256      = "a0aede7f7fa50bf59a3ebd2ed7955732183f314012cd11eca7aaa2b558d4f394";
    buildInputs = [ python2-numpy python2 ];
  };

  "python2-pyzmq" = fetch {
    name        = "python2-pyzmq";
    version     = "17.1.2";
    filename    = "mingw-w64-x86_64-python2-pyzmq-17.1.2-1-any.pkg.tar.xz";
    sha256      = "20888865caf596fa5edaf213e59049dafb66aad56451c699e43824a6bc6edadf";
    buildInputs = [ python2 zeromq ];
  };

  "python2-pyzopfli" = fetch {
    name        = "python2-pyzopfli";
    version     = "0.1.4";
    filename    = "mingw-w64-x86_64-python2-pyzopfli-0.1.4-1-any.pkg.tar.xz";
    sha256      = "4e3e017ec5523236f4682a190a5fc93e01ac4e03d20a678edc01a913dcbfef5f";
    buildInputs = [ python2 ];
  };

  "python2-qscintilla" = fetch {
    name        = "python2-qscintilla";
    version     = "2.10.8";
    filename    = "mingw-w64-x86_64-python2-qscintilla-2.10.8-1-any.pkg.tar.xz";
    sha256      = "35fdc3381f7500d1387bc8d5e0aa03db6609ebffb93ab3f281fc366fa6223ce6";
    buildInputs = [ python-qscintilla-common python2-pyqt5 ];
    broken      = true;
  };

  "python2-qtconsole" = fetch {
    name        = "python2-qtconsole";
    version     = "4.4.1";
    filename    = "mingw-w64-x86_64-python2-qtconsole-4.4.1-1-any.pkg.tar.xz";
    sha256      = "5e0e3deae52f93bd322439f8d8166527e000323f7fa065fb403c61c7871d4324";
    buildInputs = [ python2 python2-jupyter_core python2-jupyter_client python2-pyqt5 ];
    broken      = true;
  };

  "python2-rencode" = fetch {
    name        = "python2-rencode";
    version     = "1.0.6";
    filename    = "mingw-w64-x86_64-python2-rencode-1.0.6-1-any.pkg.tar.xz";
    sha256      = "9dd1e407bdc49fce99b78a5fa07033156bdefbfa2d65f57969657532767072e5";
    buildInputs = [ python2 ];
  };

  "python2-reportlab" = fetch {
    name        = "python2-reportlab";
    version     = "3.5.12";
    filename    = "mingw-w64-x86_64-python2-reportlab-3.5.12-1-any.pkg.tar.xz";
    sha256      = "143112c07a913d82e301c13d55b8b62aed301d9b49f3d36b6de6f361e8bef5ee";
    buildInputs = [ freetype python2-pip python2-Pillow ];
    broken      = true;
  };

  "python2-requests" = fetch {
    name        = "python2-requests";
    version     = "2.21.0";
    filename    = "mingw-w64-x86_64-python2-requests-2.21.0-1-any.pkg.tar.xz";
    sha256      = "9223316e2feb065dfe6e63b782e9e4117e48fa40444fc05a97c9853419660685";
    buildInputs = [ python2-urllib3 python2-chardet python2-idna ];
  };

  "python2-requests-kerberos" = fetch {
    name        = "python2-requests-kerberos";
    version     = "0.12.0";
    filename    = "mingw-w64-x86_64-python2-requests-kerberos-0.12.0-1-any.pkg.tar.xz";
    sha256      = "2637fa923f145b89e8e2e1bd2b309958d35bb77f397b87b173a8eef3bff22ca9";
    buildInputs = [ python2 python2-cryptography python2-winkerberos ];
  };

  "python2-retrying" = fetch {
    name        = "python2-retrying";
    version     = "1.3.3";
    filename    = "mingw-w64-x86_64-python2-retrying-1.3.3-1-any.pkg.tar.xz";
    sha256      = "57ecfbd4ccfc0a48772f7127efb9b0e8e7bafcdc3452b12e3d915e9fa19ee9e0";
    buildInputs = [ python2 ];
  };

  "python2-rfc3986" = fetch {
    name        = "python2-rfc3986";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-python2-rfc3986-1.2.0-1-any.pkg.tar.xz";
    sha256      = "e5b5111b63600ddf727667b064331f652eae71e3f6d4b3e054267a5f3296e5e1";
    buildInputs = [ python2 ];
  };

  "python2-rfc3987" = fetch {
    name        = "python2-rfc3987";
    version     = "1.3.8";
    filename    = "mingw-w64-x86_64-python2-rfc3987-1.3.8-1-any.pkg.tar.xz";
    sha256      = "9de0fd50b0ea46f26e51101ce52a14d74cf134dfecec1216cccdae191439201a";
    buildInputs = [ python2 ];
  };

  "python2-rst2pdf" = fetch {
    name        = "python2-rst2pdf";
    version     = "0.93";
    filename    = "mingw-w64-x86_64-python2-rst2pdf-0.93-4-any.pkg.tar.xz";
    sha256      = "17c19ab03246e91bfb762747a9948c0ed6998c5e0f29e8e23c6b4e0ccfec3013";
    buildInputs = [ python2 python2-docutils python2-pdfrw python2-pygments (assert stdenvNoCC.lib.versionAtLeast python2-reportlab.version "2.4"; python2-reportlab) python2-setuptools ];
    broken      = true;
  };

  "python2-scandir" = fetch {
    name        = "python2-scandir";
    version     = "1.9.0";
    filename    = "mingw-w64-x86_64-python2-scandir-1.9.0-1-any.pkg.tar.xz";
    sha256      = "47e0c9a6fb62e155d8d836fc61d44bae948232f6d73cc62bd05b6731c07489fc";
    buildInputs = [ python2 ];
  };

  "python2-scikit-learn" = fetch {
    name        = "python2-scikit-learn";
    version     = "0.20.0";
    filename    = "mingw-w64-x86_64-python2-scikit-learn-0.20.0-1-any.pkg.tar.xz";
    sha256      = "0ab885a8655f5ca557f6a962d9d7458ea095fa1165863f9f05436ea87036b87d";
    buildInputs = [ python2 python2-scipy ];
  };

  "python2-scipy" = fetch {
    name        = "python2-scipy";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-python2-scipy-1.2.0-1-any.pkg.tar.xz";
    sha256      = "93e1b40518450ae45461d1b5b55a54ecf6ab7758bc699cb03a86188883605738";
    buildInputs = [ gcc-libgfortran openblas python2-numpy ];
  };

  "python2-send2trash" = fetch {
    name        = "python2-send2trash";
    version     = "1.5.0";
    filename    = "mingw-w64-x86_64-python2-send2trash-1.5.0-2-any.pkg.tar.xz";
    sha256      = "7fe0f424d934b4dc17b11e50875da4b47e769add0161fed3f64f70037f787e77";
    buildInputs = [ python2 ];
  };

  "python2-setproctitle" = fetch {
    name        = "python2-setproctitle";
    version     = "1.1.10";
    filename    = "mingw-w64-x86_64-python2-setproctitle-1.1.10-1-any.pkg.tar.xz";
    sha256      = "f6770dd615a1fb4e42e6431d60bae85257cd5f1f688f53fc5af40722b342f842";
    buildInputs = [ python2 ];
  };

  "python2-setuptools" = fetch {
    name        = "python2-setuptools";
    version     = "40.6.3";
    filename    = "mingw-w64-x86_64-python2-setuptools-40.6.3-1-any.pkg.tar.xz";
    sha256      = "f178eb1e7b31932499e98cc1bbbed1b24cc54cb2029e8993dcf9e69d376e9b02";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2.version "2.7"; python2) python2-packaging python2-pyparsing python2-appdirs python2-six ];
  };

  "python2-setuptools-git" = fetch {
    name        = "python2-setuptools-git";
    version     = "1.2";
    filename    = "mingw-w64-x86_64-python2-setuptools-git-1.2-1-any.pkg.tar.xz";
    sha256      = "517ad8bf5a5d25eb04a8465f7fac0ed0061810032b1191bd7502f54d8ed4bcaf";
    buildInputs = [ python2 python2-setuptools git ];
    broken      = true;
  };

  "python2-setuptools-scm" = fetch {
    name        = "python2-setuptools-scm";
    version     = "3.1.0";
    filename    = "mingw-w64-x86_64-python2-setuptools-scm-3.1.0-1-any.pkg.tar.xz";
    sha256      = "ea6a78a403abc36a9c4c6d41abb77391bd28a7535dadfb13ea4b325cab883237";
    buildInputs = [ python2-setuptools ];
  };

  "python2-shiboken-qt4" = fetch {
    name        = "python2-shiboken-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-python2-shiboken-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "7893d3e33f23a5164104a93abfe25fddfc44bc20cc9dab85afc2c9690c4dc0ca";
    buildInputs = [ libxml2 libxslt python2 shiboken-qt4 qt4 ];
  };

  "python2-simplegeneric" = fetch {
    name        = "python2-simplegeneric";
    version     = "0.8.1";
    filename    = "mingw-w64-x86_64-python2-simplegeneric-0.8.1-4-any.pkg.tar.xz";
    sha256      = "2186d106e0de95f78e4a0137d55f2dd48d1914fba560012d2d6cd6ca1a2dd642";
    buildInputs = [ python2 ];
  };

  "python2-singledispatch" = fetch {
    name        = "python2-singledispatch";
    version     = "3.4.0.3";
    filename    = "mingw-w64-x86_64-python2-singledispatch-3.4.0.3-1-any.pkg.tar.xz";
    sha256      = "fc314bff8980cb3dc6ad788e4bbf7dd99311d2f10a9a47736d490bcb683ca7ae";
    buildInputs = [ python2 ];
  };

  "python2-sip" = fetch {
    name        = "python2-sip";
    version     = "4.19.13";
    filename    = "mingw-w64-x86_64-python2-sip-4.19.13-2-any.pkg.tar.xz";
    sha256      = "c2053b546edfb9e41ae6cdb9f70c6798910a0daa5fb10f30b6b405da568d0af4";
    buildInputs = [ sip python2 ];
  };

  "python2-six" = fetch {
    name        = "python2-six";
    version     = "1.12.0";
    filename    = "mingw-w64-x86_64-python2-six-1.12.0-1-any.pkg.tar.xz";
    sha256      = "a9631eb2fbc770b8e2d7c11a66f0e324711ed62d41a50634a1881a9f4237288c";
    buildInputs = [ python2 ];
  };

  "python2-snowballstemmer" = fetch {
    name        = "python2-snowballstemmer";
    version     = "1.2.1";
    filename    = "mingw-w64-x86_64-python2-snowballstemmer-1.2.1-3-any.pkg.tar.xz";
    sha256      = "f2841a2562f770387bc883c276efd9bffd3323c932285b3b2d8b184bb2859a28";
    buildInputs = [ python2 ];
  };

  "python2-sphinx" = fetch {
    name        = "python2-sphinx";
    version     = "1.8.3";
    filename    = "mingw-w64-x86_64-python2-sphinx-1.8.3-1-any.pkg.tar.xz";
    sha256      = "f7d962f0f43f3cdcacc756e717fbd466d8b99575bbbd4661e8059c9e0522e784";
    buildInputs = [ python2-babel python2-certifi python2-colorama python2-chardet python2-docutils python2-idna python2-imagesize python2-jinja python2-packaging python2-pygments python2-requests python2-sphinx_rtd_theme python2-snowballstemmer python2-sphinx-alabaster-theme python2-sphinxcontrib-websupport python2-six python2-sqlalchemy python2-urllib3 python2-whoosh python2-typing ];
  };

  "python2-sphinx-alabaster-theme" = fetch {
    name        = "python2-sphinx-alabaster-theme";
    version     = "0.7.11";
    filename    = "mingw-w64-x86_64-python2-sphinx-alabaster-theme-0.7.11-1-any.pkg.tar.xz";
    sha256      = "114b93359cb9f74e711aed99b6a076414cff30f9d753f5baf485b93bdaa73930";
    buildInputs = [ python2 ];
  };

  "python2-sphinx_rtd_theme" = fetch {
    name        = "python2-sphinx_rtd_theme";
    version     = "0.4.1";
    filename    = "mingw-w64-x86_64-python2-sphinx_rtd_theme-0.4.1-1-any.pkg.tar.xz";
    sha256      = "c595752350e97947e1bb69038fd689e19fb44cdfdd658d984efcd197e2b7f885";
    buildInputs = [ python2 ];
  };

  "python2-sphinxcontrib-websupport" = fetch {
    name        = "python2-sphinxcontrib-websupport";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python2-sphinxcontrib-websupport-1.1.0-2-any.pkg.tar.xz";
    sha256      = "c25bb59aa88984ed3c83b55215e629d9855bda3075fe2003764a252e8f17f6ef";
    buildInputs = [ python2 ];
  };

  "python2-sqlalchemy" = fetch {
    name        = "python2-sqlalchemy";
    version     = "1.2.15";
    filename    = "mingw-w64-x86_64-python2-sqlalchemy-1.2.15-1-any.pkg.tar.xz";
    sha256      = "ab80af527d58b3783b2bb701e27317c0846de151021d157097ed70f523f2fec2";
    buildInputs = [ python2 ];
  };

  "python2-sqlalchemy-migrate" = fetch {
    name        = "python2-sqlalchemy-migrate";
    version     = "0.11.0";
    filename    = "mingw-w64-x86_64-python2-sqlalchemy-migrate-0.11.0-1-any.pkg.tar.xz";
    sha256      = "0a4da36ddd34a6cde2a3589804a5947c6da2714ef16b47f0cc50579da70f859e";
    buildInputs = [ python2 python2-six python2-pbr python2-sqlalchemy python2-decorator python2-sqlparse python2-tempita ];
  };

  "python2-sqlitedict" = fetch {
    name        = "python2-sqlitedict";
    version     = "1.6.0";
    filename    = "mingw-w64-x86_64-python2-sqlitedict-1.6.0-1-any.pkg.tar.xz";
    sha256      = "6ecf14f10334a53809581e3a7f581ff4e1fa712449e70d4016effc001ab7127c";
    buildInputs = [ python2 sqlite3 ];
  };

  "python2-sqlparse" = fetch {
    name        = "python2-sqlparse";
    version     = "0.2.4";
    filename    = "mingw-w64-x86_64-python2-sqlparse-0.2.4-1-any.pkg.tar.xz";
    sha256      = "afb7e0bbd1be8fc1724725a9a289a15f07dbcfda5f00d1bd7257be4b9443ce1b";
    buildInputs = [ python2 ];
  };

  "python2-statistics" = fetch {
    name        = "python2-statistics";
    version     = "1.0.3.5";
    filename    = "mingw-w64-x86_64-python2-statistics-1.0.3.5-1-any.pkg.tar.xz";
    sha256      = "35ab60cda27fe7189a90434571e53e6b7786e88598cb8d039544f069c9d9e838";
    buildInputs = [ python2-docutils ];
  };

  "python2-statsmodels" = fetch {
    name        = "python2-statsmodels";
    version     = "0.9.0";
    filename    = "mingw-w64-x86_64-python2-statsmodels-0.9.0-1-any.pkg.tar.xz";
    sha256      = "cef1fe6fea078db35f1c79395015d01a5a00494c9cc23b76a5e6fce2de5286b1";
    buildInputs = [ python2-scipy python2-pandas python2-patsy ];
  };

  "python2-stestr" = fetch {
    name        = "python2-stestr";
    version     = "2.2.0";
    filename    = "mingw-w64-x86_64-python2-stestr-2.2.0-1-any.pkg.tar.xz";
    sha256      = "88d47f298cf5cdaba8af7168575d7abb538d8f9f395b95f0dc4c4830423f4ef3";
    buildInputs = [ python2 python2-cliff python2-fixtures python2-future python2-pbr python2-six python2-subunit python2-testtools python2-voluptuous python2-yaml ];
  };

  "python2-stevedore" = fetch {
    name        = "python2-stevedore";
    version     = "1.30.0";
    filename    = "mingw-w64-x86_64-python2-stevedore-1.30.0-1-any.pkg.tar.xz";
    sha256      = "ba5593c5a7d6c72c9d84743b96ee82c74a0b4453654f15f7c984c66702afb8bf";
    buildInputs = [ python2 python2-six ];
  };

  "python2-strict-rfc3339" = fetch {
    name        = "python2-strict-rfc3339";
    version     = "0.7";
    filename    = "mingw-w64-x86_64-python2-strict-rfc3339-0.7-1-any.pkg.tar.xz";
    sha256      = "9f2c2bca190e8fae6056094de0b22ac23f536cc69aa8544af13fdafd513ff566";
    buildInputs = [ python2 ];
  };

  "python2-subprocess32" = fetch {
    name        = "python2-subprocess32";
    version     = "3.5.3";
    filename    = "mingw-w64-x86_64-python2-subprocess32-3.5.3-1-any.pkg.tar.xz";
    sha256      = "979b8dab382517e7828d261d6bd45d3ef92c02b12f6aa057641efdd12a43f559";
    buildInputs = [ python2 ];
  };

  "python2-subunit" = fetch {
    name        = "python2-subunit";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-python2-subunit-1.3.0-2-any.pkg.tar.xz";
    sha256      = "62899b90c1a3f7e21c36b7cb5832c6d02fc305f0e0ace4825645a8d7b9aa421b";
    buildInputs = [ python2 python2-extras python2-testtools ];
  };

  "python2-sympy" = fetch {
    name        = "python2-sympy";
    version     = "1.3";
    filename    = "mingw-w64-x86_64-python2-sympy-1.3-1-any.pkg.tar.xz";
    sha256      = "282e831b463931913ff47fea7e60fb0c323bba3d555ef1008f9ca22db2990a1f";
    buildInputs = [ python2 python2-mpmath ];
  };

  "python2-tempita" = fetch {
    name        = "python2-tempita";
    version     = "0.5.3dev20170202";
    filename    = "mingw-w64-x86_64-python2-tempita-0.5.3dev20170202-1-any.pkg.tar.xz";
    sha256      = "1fcee05c441c267fb022c4c524c66819b3836ee83d6051a45dd0bf8184a170b4";
    buildInputs = [ python2 ];
  };

  "python2-terminado" = fetch {
    name        = "python2-terminado";
    version     = "0.8.1";
    filename    = "mingw-w64-x86_64-python2-terminado-0.8.1-2-any.pkg.tar.xz";
    sha256      = "fb7c72eef023688a2874c18b3887008d30e3bff81dee2185177e120629fd6019";
    buildInputs = [ python2 python2-tornado python2-ptyprocess ];
  };

  "python2-testrepository" = fetch {
    name        = "python2-testrepository";
    version     = "0.0.20";
    filename    = "mingw-w64-x86_64-python2-testrepository-0.0.20-1-any.pkg.tar.xz";
    sha256      = "684ac36fb371fe36a881fcea20cf893ac1063ce65ff85e8bdae4cc11eeba5aea";
    buildInputs = [ python2 ];
  };

  "python2-testresources" = fetch {
    name        = "python2-testresources";
    version     = "2.0.1";
    filename    = "mingw-w64-x86_64-python2-testresources-2.0.1-1-any.pkg.tar.xz";
    sha256      = "dc516ed650aaf72fd72bfc1a41cf6809f3fc37dd63c499e1b4afb60bf9f80baa";
    buildInputs = [ python2 ];
  };

  "python2-testscenarios" = fetch {
    name        = "python2-testscenarios";
    version     = "0.5.0";
    filename    = "mingw-w64-x86_64-python2-testscenarios-0.5.0-1-any.pkg.tar.xz";
    sha256      = "1ba143a11d85940c5069272ceef51c64dcbc4dada35a0b87cbdcdd0033c91b4d";
    buildInputs = [ python2 ];
  };

  "python2-testtools" = fetch {
    name        = "python2-testtools";
    version     = "2.3.0";
    filename    = "mingw-w64-x86_64-python2-testtools-2.3.0-1-any.pkg.tar.xz";
    sha256      = "ee88bbcab27077a3fba0a9666822b7d0b3f239a7298194d15be0c5aa771547b0";
    buildInputs = [ python2 python2-pbr python2-extras python2-fixtures python2-pyrsistent python2-mimeparse python2-unittest2 python2-traceback2 ];
  };

  "python2-text-unidecode" = fetch {
    name        = "python2-text-unidecode";
    version     = "1.2";
    filename    = "mingw-w64-x86_64-python2-text-unidecode-1.2-1-any.pkg.tar.xz";
    sha256      = "c067efe8efefe31c4ed5ad761cad5b68d31425ff6caf5682f2c3f0b752e5c01b";
    buildInputs = [ python2 ];
  };

  "python2-toml" = fetch {
    name        = "python2-toml";
    version     = "0.10.0";
    filename    = "mingw-w64-x86_64-python2-toml-0.10.0-1-any.pkg.tar.xz";
    sha256      = "07539a9e0989ae7c0bb9f268e2d5cf01a6d829a24fff327fa38945c205fc6f74";
    buildInputs = [ python2 ];
  };

  "python2-tornado" = fetch {
    name        = "python2-tornado";
    version     = "5.1.1";
    filename    = "mingw-w64-x86_64-python2-tornado-5.1.1-2-any.pkg.tar.xz";
    sha256      = "472fbad210af137295de78936735e21dd5caae39421f77c2ac54ea5b7dea8778";
    buildInputs = [ python2 python2-futures python2-backports-abc python2-setuptools python2-singledispatch ];
  };

  "python2-tox" = fetch {
    name        = "python2-tox";
    version     = "3.6.1";
    filename    = "mingw-w64-x86_64-python2-tox-3.6.1-1-any.pkg.tar.xz";
    sha256      = "91cf0250463fc24fd2954cc2e68c2b4263550976854f1d0ba3c6f8988f69e327";
    buildInputs = [ python2 python2-py python2-six python2-virtualenv python2-setuptools python2-setuptools-scm python2-filelock python2-toml python2-pluggy ];
  };

  "python2-traceback2" = fetch {
    name        = "python2-traceback2";
    version     = "1.4.0";
    filename    = "mingw-w64-x86_64-python2-traceback2-1.4.0-4-any.pkg.tar.xz";
    sha256      = "9753c411b32141d6148852aa747c64843622fc90f365cdbf48325effd3f45414";
    buildInputs = [ python2-linecache2 python2-six ];
  };

  "python2-traitlets" = fetch {
    name        = "python2-traitlets";
    version     = "4.3.2";
    filename    = "mingw-w64-x86_64-python2-traitlets-4.3.2-3-any.pkg.tar.xz";
    sha256      = "f42fbdab36af8810bc87fd97cbb480797e96b6a146e9cf902cd3c565ba502cd7";
    buildInputs = [ python2-ipython_genutils python2-decorator ];
  };

  "python2-typing" = fetch {
    name        = "python2-typing";
    version     = "3.6.6";
    filename    = "mingw-w64-x86_64-python2-typing-3.6.6-1-any.pkg.tar.xz";
    sha256      = "c12419295f9090d964dfb3cc7d957d82c9dc14110e84f0bf01c1b01e8e330859";
    buildInputs = [ python2 ];
  };

  "python2-u-msgpack" = fetch {
    name        = "python2-u-msgpack";
    version     = "2.5.0";
    filename    = "mingw-w64-x86_64-python2-u-msgpack-2.5.0-1-any.pkg.tar.xz";
    sha256      = "56ffb65d47b276e432a16779b4b1f608da8e4a517fe7be9effb2b7adc03b90ab";
    buildInputs = [ python2 ];
  };

  "python2-ukpostcodeparser" = fetch {
    name        = "python2-ukpostcodeparser";
    version     = "1.1.2";
    filename    = "mingw-w64-x86_64-python2-ukpostcodeparser-1.1.2-1-any.pkg.tar.xz";
    sha256      = "dbe7f11874874a9b64efce97dae1e38ad9e9e21628cfb3d3603d9d20743efe3b";
    buildInputs = [ python2 ];
  };

  "python2-unicodecsv" = fetch {
    name        = "python2-unicodecsv";
    version     = "0.14.1";
    filename    = "mingw-w64-x86_64-python2-unicodecsv-0.14.1-3-any.pkg.tar.xz";
    sha256      = "590b80c33784941aded4633192dfc97ccd696ac4cd275936652a0b8200013372";
    buildInputs = [ python2 ];
  };

  "python2-unicodedata2" = fetch {
    name        = "python2-unicodedata2";
    version     = "11.0.0";
    filename    = "mingw-w64-x86_64-python2-unicodedata2-11.0.0-1-any.pkg.tar.xz";
    sha256      = "8c4e186feeffb1ea86d84756e348929802663d8e43acc9998159486a596788c6";
    buildInputs = [ python2 ];
  };

  "python2-unicorn" = fetch {
    name        = "python2-unicorn";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python2-unicorn-1.0.1-3-any.pkg.tar.xz";
    sha256      = "ded76275833cfb4f6d82c8ffd0adbbe2cb1c5a61535ceb050b44c80b203ba25f";
    buildInputs = [ python2 unicorn ];
  };

  "python2-unittest2" = fetch {
    name        = "python2-unittest2";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python2-unittest2-1.1.0-1-any.pkg.tar.xz";
    sha256      = "6781b48976a1a42e48396e0e7ee81c8fb05fc7e029c2dbe1befda84e8bc291e0";
    buildInputs = [ python2-six python2-traceback2 ];
  };

  "python2-urllib3" = fetch {
    name        = "python2-urllib3";
    version     = "1.24.1";
    filename    = "mingw-w64-x86_64-python2-urllib3-1.24.1-1-any.pkg.tar.xz";
    sha256      = "db1a9db05ac433da858ca961cff728abbd3b68d610422155a8b94321ee8359a2";
    buildInputs = [ python2 python2-certifi python2-idna ];
  };

  "python2-virtualenv" = fetch {
    name        = "python2-virtualenv";
    version     = "16.0.0";
    filename    = "mingw-w64-x86_64-python2-virtualenv-16.0.0-1-any.pkg.tar.xz";
    sha256      = "158bce51b216ea490fb776ef303f0c0f5b64a2848f41c5145bbd21b1bc9a5d93";
    buildInputs = [ python2 ];
  };

  "python2-voluptuous" = fetch {
    name        = "python2-voluptuous";
    version     = "0.11.5";
    filename    = "mingw-w64-x86_64-python2-voluptuous-0.11.5-1-any.pkg.tar.xz";
    sha256      = "2028c7b116550d3e994d894c0310c24e86fa20dd5bc65d4a00b82487eed90fc6";
    buildInputs = [ python2 ];
  };

  "python2-watchdog" = fetch {
    name        = "python2-watchdog";
    version     = "0.9.0";
    filename    = "mingw-w64-x86_64-python2-watchdog-0.9.0-1-any.pkg.tar.xz";
    sha256      = "5c83089cb416d8165c3eb3387ac952dfb857153a3e4eaf9b35fb17bcda8b1b98";
    buildInputs = [ python2 ];
  };

  "python2-wcwidth" = fetch {
    name        = "python2-wcwidth";
    version     = "0.1.7";
    filename    = "mingw-w64-x86_64-python2-wcwidth-0.1.7-3-any.pkg.tar.xz";
    sha256      = "4f16fcb5b90e93f763684f7c18aa064f1497891f6bcdd19443a79fc2b2efc9fd";
    buildInputs = [ python2 ];
  };

  "python2-webcolors" = fetch {
    name        = "python2-webcolors";
    version     = "1.8.1";
    filename    = "mingw-w64-x86_64-python2-webcolors-1.8.1-1-any.pkg.tar.xz";
    sha256      = "31811ee58b4b2633eeef06494e17eeecd7ae7f831ea505a02688197810624fda";
    buildInputs = [ python2 ];
  };

  "python2-webencodings" = fetch {
    name        = "python2-webencodings";
    version     = "0.5.1";
    filename    = "mingw-w64-x86_64-python2-webencodings-0.5.1-3-any.pkg.tar.xz";
    sha256      = "4cff5de8ec3b01c4acdc25c94559278fa8cb5e4676215d2dc9dd5165e2cb4e8f";
    buildInputs = [ python2 ];
  };

  "python2-websocket-client" = fetch {
    name        = "python2-websocket-client";
    version     = "0.54.0";
    filename    = "mingw-w64-x86_64-python2-websocket-client-0.54.0-2-any.pkg.tar.xz";
    sha256      = "10939aa00d9226a66f267a9fbe43b2c04925a14a6f6989052e6aceb80507bb9e";
    buildInputs = [ python2 python2-six self."python2-backports.ssl_match_hostname" ];
  };

  "python2-wheel" = fetch {
    name        = "python2-wheel";
    version     = "0.32.3";
    filename    = "mingw-w64-x86_64-python2-wheel-0.32.3-1-any.pkg.tar.xz";
    sha256      = "1294a3b11ac7d5826aab3779adb5e384b85d0d392a760c19958e90d4739c8c08";
    buildInputs = [ python2 ];
  };

  "python2-whoosh" = fetch {
    name        = "python2-whoosh";
    version     = "2.7.4";
    filename    = "mingw-w64-x86_64-python2-whoosh-2.7.4-2-any.pkg.tar.xz";
    sha256      = "2ce8aa63a8335d8294aad7f4036549e17ede87a20a3be3249132c169ac83d8de";
    buildInputs = [ python2 ];
  };

  "python2-win_inet_pton" = fetch {
    name        = "python2-win_inet_pton";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python2-win_inet_pton-1.0.1-1-any.pkg.tar.xz";
    sha256      = "19d3f7b2d0272c29e3931aaf4b6661886f0f19ea8444efbdb02f808f6c955460";
    buildInputs = [ python2 ];
  };

  "python2-win_unicode_console" = fetch {
    name        = "python2-win_unicode_console";
    version     = "0.5";
    filename    = "mingw-w64-x86_64-python2-win_unicode_console-0.5-3-any.pkg.tar.xz";
    sha256      = "90194d42c0cae8deedaf45eabd7e7aa276d6a5d78b8f1d22846f138b3ca9da65";
    buildInputs = [ python2 ];
  };

  "python2-wincertstore" = fetch {
    name        = "python2-wincertstore";
    version     = "0.2";
    filename    = "mingw-w64-x86_64-python2-wincertstore-0.2-1-any.pkg.tar.xz";
    sha256      = "6db835d2056ff8e3241a5ea297f4755d07547971af828acfcd3a795bf77ca5d8";
    buildInputs = [ python2 ];
  };

  "python2-winkerberos" = fetch {
    name        = "python2-winkerberos";
    version     = "0.7.0";
    filename    = "mingw-w64-x86_64-python2-winkerberos-0.7.0-1-any.pkg.tar.xz";
    sha256      = "de47c8634430666531cbabc031c7e91c41d3b31d803cf4af91d383d1f73b62d3";
    buildInputs = [ python2 ];
  };

  "python2-wrapt" = fetch {
    name        = "python2-wrapt";
    version     = "1.10.11";
    filename    = "mingw-w64-x86_64-python2-wrapt-1.10.11-3-any.pkg.tar.xz";
    sha256      = "37149cbefa90ef1f2c04e893b94f403439a0248f691575fbd353aaba4d57dcbb";
    buildInputs = [ python2 ];
  };

  "python2-xdg" = fetch {
    name        = "python2-xdg";
    version     = "0.26";
    filename    = "mingw-w64-x86_64-python2-xdg-0.26-2-any.pkg.tar.xz";
    sha256      = "af78025b1a0ba25c5ad16fe3ee7544223804c873f60465310f2ebe9d711ae62a";
    buildInputs = [ python2 ];
  };

  "python2-xlrd" = fetch {
    name        = "python2-xlrd";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-python2-xlrd-1.2.0-1-any.pkg.tar.xz";
    sha256      = "aa03a36b0e6477214d205c0289fa8fa325f4983aa08094ee989c8d9c2f56f022";
    buildInputs = [ python2 ];
  };

  "python2-xlsxwriter" = fetch {
    name        = "python2-xlsxwriter";
    version     = "1.1.1";
    filename    = "mingw-w64-x86_64-python2-xlsxwriter-1.1.1-1-any.pkg.tar.xz";
    sha256      = "e82554f58aa2066bf1b0e0c643bca5033d8721c0801aea228e7ce20dfbd2623e";
    buildInputs = [ python2 ];
  };

  "python2-xlwt" = fetch {
    name        = "python2-xlwt";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-python2-xlwt-1.3.0-1-any.pkg.tar.xz";
    sha256      = "a8372ea52b5ddb2b5501e6e75048302e899cb988b06b04c9174820378367bea0";
    buildInputs = [ python2 ];
  };

  "python2-yaml" = fetch {
    name        = "python2-yaml";
    version     = "3.13";
    filename    = "mingw-w64-x86_64-python2-yaml-3.13-1-any.pkg.tar.xz";
    sha256      = "0216d0cc8b7999b2301151339c3de066d4b152b1aaf3cd2905f9363d0f7471f5";
    buildInputs = [ python2 libyaml ];
  };

  "python2-zeroconf" = fetch {
    name        = "python2-zeroconf";
    version     = "0.21.3";
    filename    = "mingw-w64-x86_64-python2-zeroconf-0.21.3-2-any.pkg.tar.xz";
    sha256      = "53d4ae0df2b1adde8e9841ec0436a74c6484b5406b4a5ac59fbddf5606c993a7";
    buildInputs = [ python2 python2-ifaddr python2-typing ];
  };

  "python2-zope.event" = fetch {
    name        = "python2-zope.event";
    version     = "4.4";
    filename    = "mingw-w64-x86_64-python2-zope.event-4.4-1-any.pkg.tar.xz";
    sha256      = "c3ea79963f1af4669948db1c7cdcecc792cf39ab5e67e1d4ffb1ac639cf47ea3";
  };

  "python2-zope.interface" = fetch {
    name        = "python2-zope.interface";
    version     = "4.6.0";
    filename    = "mingw-w64-x86_64-python2-zope.interface-4.6.0-1-any.pkg.tar.xz";
    sha256      = "c715764435e1d269fbb9fe8074b62dae55a54691b18eb19560963f7b3de9beb2";
  };

  "python3" = fetch {
    name        = "python3";
    version     = "3.7.2";
    filename    = "mingw-w64-x86_64-python3-3.7.2-1-any.pkg.tar.xz";
    sha256      = "4b5f9add85b929e97003833ba05a0a1652a2585e0dcdfabd8a03262476ccd24f";
    buildInputs = [ gcc-libs expat bzip2 libffi mpdecimal ncurses openssl tcl tk zlib xz sqlite3 ];
  };

  "python3-PyOpenGL" = fetch {
    name        = "python3-PyOpenGL";
    version     = "3.1.0";
    filename    = "mingw-w64-x86_64-python3-PyOpenGL-3.1.0-1-any.pkg.tar.xz";
    sha256      = "fcd6a5c32a7b8b8ef5d1bedef900a33edf1dab76574a360f20275aafd34d466c";
    buildInputs = [ python3 ];
  };

  "python3-alembic" = fetch {
    name        = "python3-alembic";
    version     = "1.0.5";
    filename    = "mingw-w64-x86_64-python3-alembic-1.0.5-1-any.pkg.tar.xz";
    sha256      = "01f8207047230d484d9b4300f782fcfa5776a59ba82bbec77fc06688e70dc86b";
    buildInputs = [ python3 python3-mako python3-sqlalchemy python3-editor python3-dateutil ];
  };

  "python3-apipkg" = fetch {
    name        = "python3-apipkg";
    version     = "1.5";
    filename    = "mingw-w64-x86_64-python3-apipkg-1.5-1-any.pkg.tar.xz";
    sha256      = "02c5b306f72e38f0ca6e776245ffebe1addd23c6727cdd6812cebd8f865c3121";
    buildInputs = [ python3 ];
  };

  "python3-appdirs" = fetch {
    name        = "python3-appdirs";
    version     = "1.4.3";
    filename    = "mingw-w64-x86_64-python3-appdirs-1.4.3-3-any.pkg.tar.xz";
    sha256      = "5b1f45390ec62e7b679b883aea64f1755ecbce61a2db1bf8e27b6075ffe2a01d";
    buildInputs = [ python3 ];
  };

  "python3-argh" = fetch {
    name        = "python3-argh";
    version     = "0.26.2";
    filename    = "mingw-w64-x86_64-python3-argh-0.26.2-1-any.pkg.tar.xz";
    sha256      = "74026aa0b8fa945bd715f1c62ddc95dc90b513b5aee22c75fc6f551fd414c2e5";
    buildInputs = [ python3 ];
  };

  "python3-asn1crypto" = fetch {
    name        = "python3-asn1crypto";
    version     = "0.24.0";
    filename    = "mingw-w64-x86_64-python3-asn1crypto-0.24.0-2-any.pkg.tar.xz";
    sha256      = "51244bc6a9a4d35a924478dc34297046292656a954ab8e6387b90895eba93608";
    buildInputs = [ python3-pycparser ];
  };

  "python3-astroid" = fetch {
    name        = "python3-astroid";
    version     = "2.1.0";
    filename    = "mingw-w64-x86_64-python3-astroid-2.1.0-1-any.pkg.tar.xz";
    sha256      = "7b09a9471304faf8a9e6d854315e9fb2b9ec35d4be7d21e86fbed703ba74852f";
    buildInputs = [ python3-six python3-lazy-object-proxy python3-wrapt ];
  };

  "python3-atomicwrites" = fetch {
    name        = "python3-atomicwrites";
    version     = "1.2.1";
    filename    = "mingw-w64-x86_64-python3-atomicwrites-1.2.1-1-any.pkg.tar.xz";
    sha256      = "e71ab1797567158464077ec0d085826f9159cbc9df414ef9086ca6dcaab9194a";
    buildInputs = [ python3 ];
  };

  "python3-attrs" = fetch {
    name        = "python3-attrs";
    version     = "18.2.0";
    filename    = "mingw-w64-x86_64-python3-attrs-18.2.0-1-any.pkg.tar.xz";
    sha256      = "d8fe231f332f9499f55be861bf6607ce9993cd92162a06450756f0bbb4bd4e53";
    buildInputs = [ python3 ];
  };

  "python3-babel" = fetch {
    name        = "python3-babel";
    version     = "2.6.0";
    filename    = "mingw-w64-x86_64-python3-babel-2.6.0-3-any.pkg.tar.xz";
    sha256      = "581f7b7ab9fcd67e8d976902482dddcc99a6df4ee21772795e8398f825f66c14";
    buildInputs = [ python3-pytz ];
  };

  "python3-backcall" = fetch {
    name        = "python3-backcall";
    version     = "0.1.0";
    filename    = "mingw-w64-x86_64-python3-backcall-0.1.0-2-any.pkg.tar.xz";
    sha256      = "6a9e3ecb8b857d212e1e1e9bb6f0c0d3098a4a2f64e6bc2ec51f0402b14e9232";
    buildInputs = [ python3 ];
  };

  "python3-bcrypt" = fetch {
    name        = "python3-bcrypt";
    version     = "3.1.5";
    filename    = "mingw-w64-x86_64-python3-bcrypt-3.1.5-1-any.pkg.tar.xz";
    sha256      = "e3345650ee436501c9201d845ee3ef3ac97b36aaa7d0ffe60f21485e42d748f3";
    buildInputs = [ python3 ];
  };

  "python3-beaker" = fetch {
    name        = "python3-beaker";
    version     = "1.10.0";
    filename    = "mingw-w64-x86_64-python3-beaker-1.10.0-2-any.pkg.tar.xz";
    sha256      = "c08cf5da922dec0957acd079c7e2b69654d1480bb3f83b8ba172a4cb4d332d27";
    buildInputs = [ python3 ];
  };

  "python3-beautifulsoup4" = fetch {
    name        = "python3-beautifulsoup4";
    version     = "4.6.3";
    filename    = "mingw-w64-x86_64-python3-beautifulsoup4-4.6.3-1-any.pkg.tar.xz";
    sha256      = "56f474cc6f1153f5aafd559c5abd7f846855cfdc461e169063f747daf2bdf6f6";
    buildInputs = [ python3 ];
  };

  "python3-binwalk" = fetch {
    name        = "python3-binwalk";
    version     = "2.1.1";
    filename    = "mingw-w64-x86_64-python3-binwalk-2.1.1-2-any.pkg.tar.xz";
    sha256      = "03c6628300bef7e5cdcf96ebd4da2206c300d7ba0380a86e21af0a15f7fb2548";
    buildInputs = [ bzip2 libsystre xz zlib ];
  };

  "python3-biopython" = fetch {
    name        = "python3-biopython";
    version     = "1.73";
    filename    = "mingw-w64-x86_64-python3-biopython-1.73-1-any.pkg.tar.xz";
    sha256      = "407710bd9c72f1d08a09fd940d031f498858955dce6c1086d698c801cb48bc55";
    buildInputs = [ python3-numpy ];
  };

  "python3-bleach" = fetch {
    name        = "python3-bleach";
    version     = "3.0.2";
    filename    = "mingw-w64-x86_64-python3-bleach-3.0.2-1-any.pkg.tar.xz";
    sha256      = "eb3514f535141afba907183c89055cb81bfdeb729ecdea1d3a2119287be15229";
    buildInputs = [ python3 python3-html5lib ];
  };

  "python3-breathe" = fetch {
    name        = "python3-breathe";
    version     = "4.11.1";
    filename    = "mingw-w64-x86_64-python3-breathe-4.11.1-1-any.pkg.tar.xz";
    sha256      = "541dc51e94dd367e57d4e89a1a57ce0a7dd15c05315eb13b7f5b453c202fc1c4";
    buildInputs = [ python3 ];
  };

  "python3-brotli" = fetch {
    name        = "python3-brotli";
    version     = "1.0.7";
    filename    = "mingw-w64-x86_64-python3-brotli-1.0.7-1-any.pkg.tar.xz";
    sha256      = "319c435c3017e44cda73167d089a62741cb2e96aa88130df9c0227a94c39a7c8";
    buildInputs = [ python3 libwinpthread-git ];
  };

  "python3-bsddb3" = fetch {
    name        = "python3-bsddb3";
    version     = "6.1.0";
    filename    = "mingw-w64-x86_64-python3-bsddb3-6.1.0-3-any.pkg.tar.xz";
    sha256      = "90ca2fa032f0b9bbc13dd0bbbba0af70493d586a72a50b0d008364a4f27227a2";
    buildInputs = [ python3 db ];
  };

  "python3-cachecontrol" = fetch {
    name        = "python3-cachecontrol";
    version     = "0.12.5";
    filename    = "mingw-w64-x86_64-python3-cachecontrol-0.12.5-1-any.pkg.tar.xz";
    sha256      = "c72c21670045fbd6b55555e2523e825817a589e914547c1775d787c57bd32c5a";
    buildInputs = [ python3 python3-msgpack python3-requests ];
  };

  "python3-cairo" = fetch {
    name        = "python3-cairo";
    version     = "1.18.0";
    filename    = "mingw-w64-x86_64-python3-cairo-1.18.0-1-any.pkg.tar.xz";
    sha256      = "1cab11fd732cbb09e509487757d2015aee40f35d86e005391fedf96f5b6ea9c7";
    buildInputs = [ cairo python3 ];
  };

  "python3-can" = fetch {
    name        = "python3-can";
    version     = "3.0.0";
    filename    = "mingw-w64-x86_64-python3-can-3.0.0-1-any.pkg.tar.xz";
    sha256      = "48ccfd7796fd8e796bddee2365d64af485ef362a11b5a1750858de49358d915b";
    buildInputs = [ python3 python3-python_ics python3-pyserial ];
  };

  "python3-capstone" = fetch {
    name        = "python3-capstone";
    version     = "4.0";
    filename    = "mingw-w64-x86_64-python3-capstone-4.0-1-any.pkg.tar.xz";
    sha256      = "67f49421063906c87f9f7f5463c7f42a20f41c2a2541ff9cef555e32d9a1c901";
    buildInputs = [ capstone python3 ];
  };

  "python3-certifi" = fetch {
    name        = "python3-certifi";
    version     = "2018.11.29";
    filename    = "mingw-w64-x86_64-python3-certifi-2018.11.29-2-any.pkg.tar.xz";
    sha256      = "836d26dcfc47cb44f1ce7784b64fe80f385d3d80c3198040c129e2a81af2e77b";
    buildInputs = [ python3 ];
  };

  "python3-cffi" = fetch {
    name        = "python3-cffi";
    version     = "1.11.5";
    filename    = "mingw-w64-x86_64-python3-cffi-1.11.5-2-any.pkg.tar.xz";
    sha256      = "34bdcc865a30c70c84f57c4b5e03cd972a6fc5c4f288176b312bb06566346c5d";
    buildInputs = [ python3-pycparser ];
  };

  "python3-characteristic" = fetch {
    name        = "python3-characteristic";
    version     = "14.3.0";
    filename    = "mingw-w64-x86_64-python3-characteristic-14.3.0-3-any.pkg.tar.xz";
    sha256      = "81d54d47bed47f0a9457c10d6768b8be197ca5efec5f8dc391153d4afdf29a09";
  };

  "python3-chardet" = fetch {
    name        = "python3-chardet";
    version     = "3.0.4";
    filename    = "mingw-w64-x86_64-python3-chardet-3.0.4-2-any.pkg.tar.xz";
    sha256      = "3c05d824af05f3e0ba9aa0e4f818c9c0a11d7b182030e76c8aeaf4174617b9b1";
    buildInputs = [ python3-setuptools ];
  };

  "python3-cliff" = fetch {
    name        = "python3-cliff";
    version     = "2.14.0";
    filename    = "mingw-w64-x86_64-python3-cliff-2.14.0-1-any.pkg.tar.xz";
    sha256      = "502100cf2e026261603681bbd472146be86cf914019a526461958bc37f7f8328";
    buildInputs = [ python3-six python3-pbr python3-cmd2 python3-prettytable python3-pyparsing python3-stevedore python3-yaml ];
  };

  "python3-cmd2" = fetch {
    name        = "python3-cmd2";
    version     = "0.9.6";
    filename    = "mingw-w64-x86_64-python3-cmd2-0.9.6-1-any.pkg.tar.xz";
    sha256      = "11d9591a5d773a85a285a0b9195409aba429d8a0ff03ffacc04fbdddc4daab61";
    buildInputs = [ python3-attrs python3-pyparsing python3-pyperclip python3-pyreadline python3-colorama python3-wcwidth ];
  };

  "python3-colorama" = fetch {
    name        = "python3-colorama";
    version     = "0.4.1";
    filename    = "mingw-w64-x86_64-python3-colorama-0.4.1-1-any.pkg.tar.xz";
    sha256      = "34f374f1a71d7b3416f41628500cc85c3d5425c594d4f999e3420ec89df4c049";
    buildInputs = [ python3 ];
  };

  "python3-colorspacious" = fetch {
    name        = "python3-colorspacious";
    version     = "1.1.2";
    filename    = "mingw-w64-x86_64-python3-colorspacious-1.1.2-2-any.pkg.tar.xz";
    sha256      = "111624f7833633e9b48faa85e587d59a25f7f755cde090b154e6c3eb0e140a5d";
    buildInputs = [ python3 ];
  };

  "python3-colour" = fetch {
    name        = "python3-colour";
    version     = "0.3.11";
    filename    = "mingw-w64-x86_64-python3-colour-0.3.11-1-any.pkg.tar.xz";
    sha256      = "b5454538dfd540767fb4ef6b5801265d16fc31e2f69bbd384a61c8b42807a167";
    buildInputs = [ python3 ];
  };

  "python3-comtypes" = fetch {
    name        = "python3-comtypes";
    version     = "1.1.7";
    filename    = "mingw-w64-x86_64-python3-comtypes-1.1.7-1-any.pkg.tar.xz";
    sha256      = "acd6e69407d98ae9d36233f816a127262c44efe31fca4e64a45bafda815911ba";
    buildInputs = [ python3 ];
  };

  "python3-coverage" = fetch {
    name        = "python3-coverage";
    version     = "4.5.2";
    filename    = "mingw-w64-x86_64-python3-coverage-4.5.2-1-any.pkg.tar.xz";
    sha256      = "1e313be99efd2952b018de399a286697e7eef45031c69b724e73e263b2774b0d";
    buildInputs = [ python3 ];
  };

  "python3-crcmod" = fetch {
    name        = "python3-crcmod";
    version     = "1.7";
    filename    = "mingw-w64-x86_64-python3-crcmod-1.7-2-any.pkg.tar.xz";
    sha256      = "163bbfdf33df2907cb1f50ec851221e5ca0439a1e87dd100d2b6b312436f000f";
    buildInputs = [ python3 ];
  };

  "python3-cryptography" = fetch {
    name        = "python3-cryptography";
    version     = "2.4.2";
    filename    = "mingw-w64-x86_64-python3-cryptography-2.4.2-1-any.pkg.tar.xz";
    sha256      = "66eb70930fbd82b9649a1d23fafbb413abb74f766e7bf247c4aaa2ae6b1d3304";
    buildInputs = [ python3-cffi python3-pyasn1 python3-idna python3-asn1crypto ];
  };

  "python3-cssselect" = fetch {
    name        = "python3-cssselect";
    version     = "1.0.3";
    filename    = "mingw-w64-x86_64-python3-cssselect-1.0.3-2-any.pkg.tar.xz";
    sha256      = "6aaf0b530e18ec71a5939c37779462a35c5b09526b9f3d4ff274a1dd400bf235";
    buildInputs = [ python3 ];
  };

  "python3-cvxopt" = fetch {
    name        = "python3-cvxopt";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-python3-cvxopt-1.2.2-1-any.pkg.tar.xz";
    sha256      = "d768058225fa3c9f611af9099f42537b04b3ae4cfc2e265c1c3ed97a38030f36";
    buildInputs = [ python3 ];
  };

  "python3-cx_Freeze" = fetch {
    name        = "python3-cx_Freeze";
    version     = "5.1.1";
    filename    = "mingw-w64-x86_64-python3-cx_Freeze-5.1.1-3-any.pkg.tar.xz";
    sha256      = "c8b6f7e47a2dbda93225bc26218aaed00e223c5c8c0955fa8a81d48cabbf67a4";
    buildInputs = [ python3 python3-six ];
  };

  "python3-cycler" = fetch {
    name        = "python3-cycler";
    version     = "0.10.0";
    filename    = "mingw-w64-x86_64-python3-cycler-0.10.0-3-any.pkg.tar.xz";
    sha256      = "fc80eaf6b2f195469f3d10a5fc03f2654ad0e1e68c7a81491f2ebc33e06555b8";
    buildInputs = [ python3 python3-six ];
  };

  "python3-dateutil" = fetch {
    name        = "python3-dateutil";
    version     = "2.7.5";
    filename    = "mingw-w64-x86_64-python3-dateutil-2.7.5-1-any.pkg.tar.xz";
    sha256      = "5936df37cb089f83cc5392ce8fa8d4b2ad2116edd6fcdfbee7543062fd178f1f";
    buildInputs = [ python3-six ];
  };

  "python3-ddt" = fetch {
    name        = "python3-ddt";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-python3-ddt-1.2.0-1-any.pkg.tar.xz";
    sha256      = "b2ef8e8c15d8dd88ef901ae1633a28cdc4b3a7e8951584b8a2d842e11b6bc3cb";
    buildInputs = [ python3 ];
  };

  "python3-debtcollector" = fetch {
    name        = "python3-debtcollector";
    version     = "1.20.0";
    filename    = "mingw-w64-x86_64-python3-debtcollector-1.20.0-1-any.pkg.tar.xz";
    sha256      = "8a70921bc323a0a86c30bcbe34034b33d84ec47ca66ad777b77fb6b20c6009bf";
    buildInputs = [ python3 python3-six python3-pbr python3-babel python3-wrapt ];
  };

  "python3-decorator" = fetch {
    name        = "python3-decorator";
    version     = "4.3.1";
    filename    = "mingw-w64-x86_64-python3-decorator-4.3.1-1-any.pkg.tar.xz";
    sha256      = "5399cf32f569c4aaa602146d5e3241fb5166d4fe5b0845ccbe2fcc14dcae4890";
    buildInputs = [ python3 ];
  };

  "python3-defusedxml" = fetch {
    name        = "python3-defusedxml";
    version     = "0.5.0";
    filename    = "mingw-w64-x86_64-python3-defusedxml-0.5.0-1-any.pkg.tar.xz";
    sha256      = "fc17bcdeb2a346e872b59fd38c9744f35681afef4aff4a234237dcfa442b8d8f";
    buildInputs = [ python3 ];
  };

  "python3-distlib" = fetch {
    name        = "python3-distlib";
    version     = "0.2.8";
    filename    = "mingw-w64-x86_64-python3-distlib-0.2.8-1-any.pkg.tar.xz";
    sha256      = "580b7bd40b16f73ba63e84766922b5bf8727912df2ad5f0adbf83debf698256a";
    buildInputs = [ python3 ];
  };

  "python3-distutils-extra" = fetch {
    name        = "python3-distutils-extra";
    version     = "2.39";
    filename    = "mingw-w64-x86_64-python3-distutils-extra-2.39-4-any.pkg.tar.xz";
    sha256      = "b3eb2b1d6b7f1c3a35579eb798351f5068eea046f19c24aa4745ba272f5cf346";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python3.version "3.3"; python3) intltool ];
    broken      = true;
  };

  "python3-django" = fetch {
    name        = "python3-django";
    version     = "2.1.4";
    filename    = "mingw-w64-x86_64-python3-django-2.1.4-1-any.pkg.tar.xz";
    sha256      = "8ac3d4e2fcf2577e47508e2acec9a2612e932762e214d8641327fb03fac734b7";
    buildInputs = [ python3 python3-pytz ];
  };

  "python3-dnspython" = fetch {
    name        = "python3-dnspython";
    version     = "1.16.0";
    filename    = "mingw-w64-x86_64-python3-dnspython-1.16.0-1-any.pkg.tar.xz";
    sha256      = "20956fe147e3d94350b5a17a45e19677a7a5cd2cbe923fbfe5de2cb256f6290c";
    buildInputs = [ python3 ];
  };

  "python3-docutils" = fetch {
    name        = "python3-docutils";
    version     = "0.14";
    filename    = "mingw-w64-x86_64-python3-docutils-0.14-3-any.pkg.tar.xz";
    sha256      = "66f3f3185a226d67a25a0308cfd6986601ae5102d179612e3f18cf94649f4040";
    buildInputs = [ python3 ];
  };

  "python3-editor" = fetch {
    name        = "python3-editor";
    version     = "1.0.3";
    filename    = "mingw-w64-x86_64-python3-editor-1.0.3-1-any.pkg.tar.xz";
    sha256      = "13e797e52e54fb936bb7dd7284992c7e49df5ded17d8fb0dca6e11a8a6cd404b";
    buildInputs = [ python3 ];
  };

  "python3-email-validator" = fetch {
    name        = "python3-email-validator";
    version     = "1.0.3";
    filename    = "mingw-w64-x86_64-python3-email-validator-1.0.3-1-any.pkg.tar.xz";
    sha256      = "d5fb41027df3005787c1e8f954559661813fae85711f544ced275eb5eaf5dd93";
    buildInputs = [ python3 python2-dnspython python2-idna ];
  };

  "python3-entrypoints" = fetch {
    name        = "python3-entrypoints";
    version     = "0.2.3";
    filename    = "mingw-w64-x86_64-python3-entrypoints-0.2.3-4-any.pkg.tar.xz";
    sha256      = "bfb98a4ee17d2e8756baec8a79a7ecd6cf715182d67ea7503f7a4ddc76baa99e";
  };

  "python3-et-xmlfile" = fetch {
    name        = "python3-et-xmlfile";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python3-et-xmlfile-1.0.1-3-any.pkg.tar.xz";
    sha256      = "d6b35546a86854068768a32be6725d893bd192db6d307c15395fc5f721738843";
    buildInputs = [ python3-lxml ];
  };

  "python3-eventlet" = fetch {
    name        = "python3-eventlet";
    version     = "0.24.1";
    filename    = "mingw-w64-x86_64-python3-eventlet-0.24.1-1-any.pkg.tar.xz";
    sha256      = "d761641970bb29966405d5073ba44d27fef87a18c7ae7f352f65756ff2e2cf9a";
    buildInputs = [ python3 python3-greenlet python3-monotonic ];
  };

  "python3-execnet" = fetch {
    name        = "python3-execnet";
    version     = "1.5.0";
    filename    = "mingw-w64-x86_64-python3-execnet-1.5.0-1-any.pkg.tar.xz";
    sha256      = "14d7630abd60eab210b85b654710973f880d3942d50236078e6ec15fb943546d";
    buildInputs = [ python3 python3-apipkg ];
  };

  "python3-extras" = fetch {
    name        = "python3-extras";
    version     = "1.0.0";
    filename    = "mingw-w64-x86_64-python3-extras-1.0.0-1-any.pkg.tar.xz";
    sha256      = "45755647350a2ca030fae78dd1d04ce407a7e04a5c6bd999fccaa75d74d81571";
    buildInputs = [ python3 ];
  };

  "python3-faker" = fetch {
    name        = "python3-faker";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python3-faker-1.0.1-1-any.pkg.tar.xz";
    sha256      = "70832ca897b540de6029adccf22c3bbd8d32dd68293d7d3ae078edbcdc6bc8a3";
    buildInputs = [ python3 python3-dateutil python3-six python3-text-unidecode ];
  };

  "python3-fasteners" = fetch {
    name        = "python3-fasteners";
    version     = "0.14.1";
    filename    = "mingw-w64-x86_64-python3-fasteners-0.14.1-1-any.pkg.tar.xz";
    sha256      = "9d3a3a2f4110e90f5f6ee71c8175b1117d201ce91f670b3966684254f8fc2557";
    buildInputs = [ python3 python3-six python3-monotonic ];
  };

  "python3-filelock" = fetch {
    name        = "python3-filelock";
    version     = "3.0.10";
    filename    = "mingw-w64-x86_64-python3-filelock-3.0.10-1-any.pkg.tar.xz";
    sha256      = "993d90e691e87de86bb9d617ff222a1ab30cbe971f861337fad75317afed88e9";
    buildInputs = [ python3 ];
  };

  "python3-fixtures" = fetch {
    name        = "python3-fixtures";
    version     = "3.0.0";
    filename    = "mingw-w64-x86_64-python3-fixtures-3.0.0-2-any.pkg.tar.xz";
    sha256      = "46422d17423ea1b4f0e0a637983438faebde554c321c75949bdc07e50878bb52";
    buildInputs = [ python3 python3-pbr python3-six ];
  };

  "python3-flake8" = fetch {
    name        = "python3-flake8";
    version     = "3.6.0";
    filename    = "mingw-w64-x86_64-python3-flake8-3.6.0-1-any.pkg.tar.xz";
    sha256      = "a85aa91d6f6ffc4fd8f1e7f42203231567c78235be0ad6a887a0097b3a39eca6";
    buildInputs = [ python3-pyflakes python3-mccabe python3-pycodestyle ];
  };

  "python3-flaky" = fetch {
    name        = "python3-flaky";
    version     = "3.4.0";
    filename    = "mingw-w64-x86_64-python3-flaky-3.4.0-2-any.pkg.tar.xz";
    sha256      = "b883980840f3bb5b33276ac0fb45e691cd16eeebda4d2d024586ef65eba4802d";
    buildInputs = [ python3 ];
  };

  "python3-flexmock" = fetch {
    name        = "python3-flexmock";
    version     = "0.10.2";
    filename    = "mingw-w64-x86_64-python3-flexmock-0.10.2-1-any.pkg.tar.xz";
    sha256      = "a47ffb65910afce4370c7cf7a3f24d60c8e5cb32c7d4a24b85bb68234bdc71db";
    buildInputs = [ python3 ];
  };

  "python3-fonttools" = fetch {
    name        = "python3-fonttools";
    version     = "3.30.0";
    filename    = "mingw-w64-x86_64-python3-fonttools-3.30.0-1-any.pkg.tar.xz";
    sha256      = "1971faf886d1152e504c4cb2ab419e14e4a843f2178913f2417e726a6cf451b2";
    buildInputs = [ python3 python3-numpy ];
  };

  "python3-freezegun" = fetch {
    name        = "python3-freezegun";
    version     = "0.3.11";
    filename    = "mingw-w64-x86_64-python3-freezegun-0.3.11-1-any.pkg.tar.xz";
    sha256      = "d5ac36fb843caaf7c81d05a251dde43ee75a41be838f093803f3823c89c0c587";
    buildInputs = [ python3 python3-dateutil ];
  };

  "python3-funcsigs" = fetch {
    name        = "python3-funcsigs";
    version     = "1.0.2";
    filename    = "mingw-w64-x86_64-python3-funcsigs-1.0.2-2-any.pkg.tar.xz";
    sha256      = "4e807b2eb7fd3ce0b016595201d66a4c98d2d0b17b9af0b337a1f90ba9020dd0";
    buildInputs = [ python3 ];
  };

  "python3-future" = fetch {
    name        = "python3-future";
    version     = "0.17.1";
    filename    = "mingw-w64-x86_64-python3-future-0.17.1-1-any.pkg.tar.xz";
    sha256      = "da6bb9feaf436f2573f9246208201136b32273e3a8995a44957d56af114bfbc1";
    buildInputs = [ python3 ];
  };

  "python3-genty" = fetch {
    name        = "python3-genty";
    version     = "1.3.2";
    filename    = "mingw-w64-x86_64-python3-genty-1.3.2-2-any.pkg.tar.xz";
    sha256      = "6d7a4be959d015a54277fd320b5323a8f9eeb0e32245a1f85522075bce4fc2af";
    buildInputs = [ python3 python3-six ];
  };

  "python3-gmpy2" = fetch {
    name        = "python3-gmpy2";
    version     = "2.1.0a4";
    filename    = "mingw-w64-x86_64-python3-gmpy2-2.1.0a4-1-any.pkg.tar.xz";
    sha256      = "2f28591e4d7acfdd1b173f861401fb7ffc15090f72c45af780548d6f0c4ceba8";
    buildInputs = [ python3 mpc ];
  };

  "python3-gobject" = fetch {
    name        = "python3-gobject";
    version     = "3.30.4";
    filename    = "mingw-w64-x86_64-python3-gobject-3.30.4-1-any.pkg.tar.xz";
    sha256      = "c23de1416cf993273265b27ce483aa2fd3cae2f8baa6b0465d3d0b33df2de7ab";
    buildInputs = [ glib2 python3-cairo libffi gobject-introspection-runtime (assert pygobject-devel.version=="3.30.4"; pygobject-devel) ];
  };

  "python3-gobject2" = fetch {
    name        = "python3-gobject2";
    version     = "2.28.7";
    filename    = "mingw-w64-x86_64-python3-gobject2-2.28.7-1-any.pkg.tar.xz";
    sha256      = "729ffed2a75a62085dec034d6e5ef1b895f4590ade15c0b3ecf634389d5e27e6";
    buildInputs = [ glib2 libffi gobject-introspection-runtime (assert pygobject2-devel.version=="2.28.7"; pygobject2-devel) ];
  };

  "python3-greenlet" = fetch {
    name        = "python3-greenlet";
    version     = "0.4.15";
    filename    = "mingw-w64-x86_64-python3-greenlet-0.4.15-1-any.pkg.tar.xz";
    sha256      = "4824fff6547850bc8a4d7a06697d21c2f49a5c6bfdc9fa10496dfb01f790055c";
    buildInputs = [ python3 ];
  };

  "python3-h5py" = fetch {
    name        = "python3-h5py";
    version     = "2.9.0";
    filename    = "mingw-w64-x86_64-python3-h5py-2.9.0-1-any.pkg.tar.xz";
    sha256      = "df375847ea4279e52513c5059e068fef01a45cae636ef88d8e7cc7c503ce0ceb";
    buildInputs = [ python3-numpy python3-six hdf5 ];
  };

  "python3-hacking" = fetch {
    name        = "python3-hacking";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python3-hacking-1.1.0-1-any.pkg.tar.xz";
    sha256      = "3843c2daebd05f15616826fce2fb95e27d6cd58bd35863dd877fca671c88c1cc";
    buildInputs = [ python3 ];
  };

  "python3-html5lib" = fetch {
    name        = "python3-html5lib";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python3-html5lib-1.0.1-3-any.pkg.tar.xz";
    sha256      = "04dc25512de3118e308ced02b41560c8b4e9ae57aed8ff9f86f0ad78b36ab8da";
    buildInputs = [ python3 python3-six python3-webencodings ];
  };

  "python3-httplib2" = fetch {
    name        = "python3-httplib2";
    version     = "0.12.0";
    filename    = "mingw-w64-x86_64-python3-httplib2-0.12.0-1-any.pkg.tar.xz";
    sha256      = "3d38fb8b3a9bc5244121374c21b7a458ff85d96a194ee2cc851ef84bc73d1900";
    buildInputs = [ python3 python3-certifi ca-certificates ];
  };

  "python3-hypothesis" = fetch {
    name        = "python3-hypothesis";
    version     = "3.84.4";
    filename    = "mingw-w64-x86_64-python3-hypothesis-3.84.4-1-any.pkg.tar.xz";
    sha256      = "32c284ee306acd5b07d9f08450d85055abbe4b325256af36d32187e6cdb9b259";
    buildInputs = [ python3 python3-attrs python3-coverage ];
  };

  "python3-icu" = fetch {
    name        = "python3-icu";
    version     = "2.2";
    filename    = "mingw-w64-x86_64-python3-icu-2.2-1-any.pkg.tar.xz";
    sha256      = "9da41e33cb5e06d4563e9ebafa6ef113f4ffd76e3340a9e354d2ed6036a7f6cd";
    buildInputs = [ python3 icu ];
  };

  "python3-idna" = fetch {
    name        = "python3-idna";
    version     = "2.8";
    filename    = "mingw-w64-x86_64-python3-idna-2.8-1-any.pkg.tar.xz";
    sha256      = "3a806248460c91300b524018c4175e6176062e5b12b7cc14a93f83a7635b0e19";
    buildInputs = [  ];
  };

  "python3-ifaddr" = fetch {
    name        = "python3-ifaddr";
    version     = "0.1.6";
    filename    = "mingw-w64-x86_64-python3-ifaddr-0.1.6-1-any.pkg.tar.xz";
    sha256      = "6ec1ca1c9fcdfe6814b8b9fac69821beea714c437e017c36b6d1465d1401eb02";
    buildInputs = [ python3 ];
  };

  "python3-imagesize" = fetch {
    name        = "python3-imagesize";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python3-imagesize-1.1.0-1-any.pkg.tar.xz";
    sha256      = "daaf30798afdbf2ccbf18e22dfc805b99d8bfe6f92d824968831f6ffeb112d59";
    buildInputs = [ python3 ];
  };

  "python3-importlib-metadata" = fetch {
    name        = "python3-importlib-metadata";
    version     = "0.7";
    filename    = "mingw-w64-x86_64-python3-importlib-metadata-0.7-1-any.pkg.tar.xz";
    sha256      = "dfaaee7068aab948ab3f2a8d092828300cc68b2d913159da4f174ed115ef6971";
    buildInputs = [ python3 ];
  };

  "python3-iniconfig" = fetch {
    name        = "python3-iniconfig";
    version     = "1.0.0";
    filename    = "mingw-w64-x86_64-python3-iniconfig-1.0.0-2-any.pkg.tar.xz";
    sha256      = "75d4b07a2091042763ef5a83d6679eedcd97e84b1c06a8b8a1c7aaa995e59872";
    buildInputs = [ python3 ];
  };

  "python3-iocapture" = fetch {
    name        = "python3-iocapture";
    version     = "0.1.2";
    filename    = "mingw-w64-x86_64-python3-iocapture-0.1.2-1-any.pkg.tar.xz";
    sha256      = "4b63ffa632116f3a3b61d63e58262f0282d84bf63da8f811d59f2889f767cc66";
    buildInputs = [ python3 ];
  };

  "python3-ipykernel" = fetch {
    name        = "python3-ipykernel";
    version     = "5.1.0";
    filename    = "mingw-w64-x86_64-python3-ipykernel-5.1.0-1-any.pkg.tar.xz";
    sha256      = "cba1943c50d8a7d8f9ae626e4a1f033e637d9f4d47bd565eb0fd7dc0e1ebcda6";
    buildInputs = [ python3 python3-pathlib2 python3-pyzmq python3-ipython ];
    broken      = true;
  };

  "python3-ipython" = fetch {
    name        = "python3-ipython";
    version     = "7.1.1";
    filename    = "mingw-w64-x86_64-python3-ipython-7.1.1-1-any.pkg.tar.xz";
    sha256      = "c9b035e7f81b993bbeaa315cb95e18bbb54ead7a80cda9c45512b7833be2cdd0";
    buildInputs = [ winpty sqlite3 python3-jedi python3-decorator python3-pickleshare python3-simplegeneric python3-traitlets (assert stdenvNoCC.lib.versionAtLeast python3-prompt_toolkit.version "2.0"; python3-prompt_toolkit) python3-pygments python3-simplegeneric python3-backcall python3-pexpect python3-colorama python3-win_unicode_console ];
    broken      = true;
  };

  "python3-ipython_genutils" = fetch {
    name        = "python3-ipython_genutils";
    version     = "0.2.0";
    filename    = "mingw-w64-x86_64-python3-ipython_genutils-0.2.0-2-any.pkg.tar.xz";
    sha256      = "7aabe687bf8767eef669a7f331fbffc373636fcc9cfeb9711f16ddbb8900c1da";
    buildInputs = [ python3 ];
  };

  "python3-ipywidgets" = fetch {
    name        = "python3-ipywidgets";
    version     = "7.4.2";
    filename    = "mingw-w64-x86_64-python3-ipywidgets-7.4.2-1-any.pkg.tar.xz";
    sha256      = "45606bbbff57cb6e4949e4b0ba00f79d406e6ed89ffaa2d23473331d18aa4411";
    buildInputs = [ python3 ];
  };

  "python3-iso8601" = fetch {
    name        = "python3-iso8601";
    version     = "0.1.12";
    filename    = "mingw-w64-x86_64-python3-iso8601-0.1.12-1-any.pkg.tar.xz";
    sha256      = "a90d26bf58b4515456d540bc21d7cb587903b3ec95315eb8500aab6b02df157e";
    buildInputs = [ python3 ];
  };

  "python3-isort" = fetch {
    name        = "python3-isort";
    version     = "4.3.4";
    filename    = "mingw-w64-x86_64-python3-isort-4.3.4-1-any.pkg.tar.xz";
    sha256      = "7a21e33326a8033e69558353699783e3f6a83efd0749285387975638e9813814";
    buildInputs = [ python3 ];
  };

  "python3-jdcal" = fetch {
    name        = "python3-jdcal";
    version     = "1.4";
    filename    = "mingw-w64-x86_64-python3-jdcal-1.4-2-any.pkg.tar.xz";
    sha256      = "e8b9602445e6307c3eb17f468bced20fd6fbe1d2897720ca729a319a935382fc";
    buildInputs = [ python3 ];
  };

  "python3-jedi" = fetch {
    name        = "python3-jedi";
    version     = "0.13.1";
    filename    = "mingw-w64-x86_64-python3-jedi-0.13.1-1-any.pkg.tar.xz";
    sha256      = "0c826ea544514446a4cc207b8eb67ad4b884c168fd0a4a1fb00b696292833fb1";
    buildInputs = [ python3 python3-parso ];
  };

  "python3-jinja" = fetch {
    name        = "python3-jinja";
    version     = "2.10";
    filename    = "mingw-w64-x86_64-python3-jinja-2.10-2-any.pkg.tar.xz";
    sha256      = "b5e960d89e011a289130271b14d8fb601ded6bf90e0b6a5615cc752b00eb9d86";
    buildInputs = [ python3-setuptools python3-markupsafe ];
  };

  "python3-json-rpc" = fetch {
    name        = "python3-json-rpc";
    version     = "1.11.1";
    filename    = "mingw-w64-x86_64-python3-json-rpc-1.11.1-1-any.pkg.tar.xz";
    sha256      = "5698264670e2d4285752806c709da9655fcd29ad6b8d1b03f93bdee81a98afd4";
    buildInputs = [ python3 ];
  };

  "python3-jsonschema" = fetch {
    name        = "python3-jsonschema";
    version     = "2.6.0";
    filename    = "mingw-w64-x86_64-python3-jsonschema-2.6.0-5-any.pkg.tar.xz";
    sha256      = "60ba4b9e7e9a3e9bbbfda248f00d93ad511c82c8c2331f1ec144eb6cf6434f4f";
    buildInputs = [ python3 ];
  };

  "python3-jupyter-nbconvert" = fetch {
    name        = "python3-jupyter-nbconvert";
    version     = "5.4";
    filename    = "mingw-w64-x86_64-python3-jupyter-nbconvert-5.4-2-any.pkg.tar.xz";
    sha256      = "5178307a50f72b1ec7a9324a21cfb212f08b5d5f558eea269b5dfa18fb3d2e61";
    buildInputs = [ python3 python3-defusedxml python3-jupyter_client python3-jupyter-nbformat python3-pygments python3-mistune python3-jinja python3-entrypoints python3-traitlets python3-pandocfilters python3-bleach python3-testpath ];
    broken      = true;
  };

  "python3-jupyter-nbformat" = fetch {
    name        = "python3-jupyter-nbformat";
    version     = "4.4.0";
    filename    = "mingw-w64-x86_64-python3-jupyter-nbformat-4.4.0-2-any.pkg.tar.xz";
    sha256      = "206df443650347cfed7d2fe81b16de54385ff23e6ce29f674fa84d73bb16aa9c";
    buildInputs = [ python3 python3-traitlets python3-jsonschema python3-jupyter_core ];
  };

  "python3-jupyter_client" = fetch {
    name        = "python3-jupyter_client";
    version     = "5.2.4";
    filename    = "mingw-w64-x86_64-python3-jupyter_client-5.2.4-1-any.pkg.tar.xz";
    sha256      = "416b1c6474509e67cfbe3df0c67c73e1404cad45623909247f6c40a92662c944";
    buildInputs = [ python3-ipykernel python3-jupyter_core python3-pyzmq ];
    broken      = true;
  };

  "python3-jupyter_console" = fetch {
    name        = "python3-jupyter_console";
    version     = "6.0.0";
    filename    = "mingw-w64-x86_64-python3-jupyter_console-6.0.0-1-any.pkg.tar.xz";
    sha256      = "e2d8f1129e4607537829d0f0b4ad60f227fa20d35355d492538e2b62cd2695d4";
    buildInputs = [ python3 python3-jupyter_core python3-jupyter_client python3-colorama ];
    broken      = true;
  };

  "python3-jupyter_core" = fetch {
    name        = "python3-jupyter_core";
    version     = "4.4.0";
    filename    = "mingw-w64-x86_64-python3-jupyter_core-4.4.0-3-any.pkg.tar.xz";
    sha256      = "81098ae63130584ae603b5d0910920efd7e7389381fdb95645ba169b5430f076";
    buildInputs = [ python3 ];
  };

  "python3-kiwisolver" = fetch {
    name        = "python3-kiwisolver";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python3-kiwisolver-1.0.1-2-any.pkg.tar.xz";
    sha256      = "3c688525b8131b46c4cbd3a17d53bd45b0c04c7fa8b84a1597da30581d4d05f1";
    buildInputs = [ python3 ];
  };

  "python3-lazy-object-proxy" = fetch {
    name        = "python3-lazy-object-proxy";
    version     = "1.3.1";
    filename    = "mingw-w64-x86_64-python3-lazy-object-proxy-1.3.1-2-any.pkg.tar.xz";
    sha256      = "583017d0e402032736d6b150583875aeaac1b829517d0cb741228326bad8a637";
    buildInputs = [ python3 ];
  };

  "python3-ldap" = fetch {
    name        = "python3-ldap";
    version     = "3.1.0";
    filename    = "mingw-w64-x86_64-python3-ldap-3.1.0-1-any.pkg.tar.xz";
    sha256      = "11a805484e2fb57654d15a0f790909f8495a7fac63d1b447db4e9a21bf023822";
    buildInputs = [ python3 ];
  };

  "python3-ldap3" = fetch {
    name        = "python3-ldap3";
    version     = "2.5.1";
    filename    = "mingw-w64-x86_64-python3-ldap3-2.5.1-1-any.pkg.tar.xz";
    sha256      = "dfd6518a0b2a499375e8f40e80afa1abbe17d2879a41c7b33e467d717cb0e7db";
    buildInputs = [ python3 ];
  };

  "python3-lhafile" = fetch {
    name        = "python3-lhafile";
    version     = "0.2.1";
    filename    = "mingw-w64-x86_64-python3-lhafile-0.2.1-3-any.pkg.tar.xz";
    sha256      = "bb9326105800498c4d5079e1f36e16d3c02b7aeab8763e31725aa9743df4f31d";
    buildInputs = [ python3 python3-six ];
  };

  "python3-lockfile" = fetch {
    name        = "python3-lockfile";
    version     = "0.12.2";
    filename    = "mingw-w64-x86_64-python3-lockfile-0.12.2-1-any.pkg.tar.xz";
    sha256      = "6e85cdcbbe3bbbb1c3443503fd02c7a9099e44fbe1cbe48e27893d1c038e8615";
    buildInputs = [ python3 ];
  };

  "python3-lxml" = fetch {
    name        = "python3-lxml";
    version     = "4.2.5";
    filename    = "mingw-w64-x86_64-python3-lxml-4.2.5-1-any.pkg.tar.xz";
    sha256      = "bcf4e44db0c614daf6b4fe382080971341e1a581aae6b00e190de1beb8c4a9c0";
    buildInputs = [ python3 libxslt ];
  };

  "python3-mako" = fetch {
    name        = "python3-mako";
    version     = "1.0.7";
    filename    = "mingw-w64-x86_64-python3-mako-1.0.7-3-any.pkg.tar.xz";
    sha256      = "0b2c8670291b1ce02ca5dcf34c5812d4d09f43dcdb495ff3504a1664ba0775da";
    buildInputs = [ python3-markupsafe python3-beaker ];
  };

  "python3-markdown" = fetch {
    name        = "python3-markdown";
    version     = "3.0.1";
    filename    = "mingw-w64-x86_64-python3-markdown-3.0.1-1-any.pkg.tar.xz";
    sha256      = "be4e81873d586b84f749bd6e6ac00465395dc46ba04edce6a5de1d6985ac2c29";
    buildInputs = [ python3 ];
  };

  "python3-markupsafe" = fetch {
    name        = "python3-markupsafe";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python3-markupsafe-1.1.0-1-any.pkg.tar.xz";
    sha256      = "54a8baee6312fdb109d12cf6f881c37521c34b3b03885d707e22c9e2a7d17dac";
    buildInputs = [ python3 ];
  };

  "python3-matplotlib" = fetch {
    name        = "python3-matplotlib";
    version     = "3.0.2";
    filename    = "mingw-w64-x86_64-python3-matplotlib-3.0.2-1-any.pkg.tar.xz";
    sha256      = "97815ad1d7221352b47de7a818d67dfc34c872f4476547e2bae5f130f968d565";
    buildInputs = [ python3-pytz python3-numpy python3-cycler python3-dateutil python3-pyparsing python3-kiwisolver freetype libpng ];
  };

  "python3-mccabe" = fetch {
    name        = "python3-mccabe";
    version     = "0.6.1";
    filename    = "mingw-w64-x86_64-python3-mccabe-0.6.1-1-any.pkg.tar.xz";
    sha256      = "b0173e6471bce0785037c69e811fea9fbd66f07721604d360de1b955c71f9ed1";
    buildInputs = [ python3 ];
  };

  "python3-mimeparse" = fetch {
    name        = "python3-mimeparse";
    version     = "1.6.0";
    filename    = "mingw-w64-x86_64-python3-mimeparse-1.6.0-1-any.pkg.tar.xz";
    sha256      = "2829d2411b3f33be16170f8f395bafa7f1273172ff951d5b65081ffb079e7889";
    buildInputs = [ python3 ];
  };

  "python3-mistune" = fetch {
    name        = "python3-mistune";
    version     = "0.8.4";
    filename    = "mingw-w64-x86_64-python3-mistune-0.8.4-1-any.pkg.tar.xz";
    sha256      = "9fe59a7fce9d56b8f0903bf3c76b0399f43dd1486fb5154fe4d262f8b6748d73";
    buildInputs = [ python3 ];
  };

  "python3-mock" = fetch {
    name        = "python3-mock";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-python3-mock-2.0.0-3-any.pkg.tar.xz";
    sha256      = "aed8a288efd22251baa077c3f407806c4609afb5b8d1f795384ac8c989b03e2d";
    buildInputs = [ python3 python3-six python3-pbr ];
  };

  "python3-monotonic" = fetch {
    name        = "python3-monotonic";
    version     = "1.5";
    filename    = "mingw-w64-x86_64-python3-monotonic-1.5-1-any.pkg.tar.xz";
    sha256      = "fe57eaf9c3b2c841bb011adc7ee87fbf59e2f8a7629521022e3f949e8bd93b83";
    buildInputs = [ python3 ];
  };

  "python3-more-itertools" = fetch {
    name        = "python3-more-itertools";
    version     = "4.3.1";
    filename    = "mingw-w64-x86_64-python3-more-itertools-4.3.1-1-any.pkg.tar.xz";
    sha256      = "fb49212e38eabcf5d3d4d273ab7485ca14b514fd7a59a1f1c136a4f3ceae07b0";
    buildInputs = [ python3 python3-six ];
  };

  "python3-mox3" = fetch {
    name        = "python3-mox3";
    version     = "0.26.0";
    filename    = "mingw-w64-x86_64-python3-mox3-0.26.0-1-any.pkg.tar.xz";
    sha256      = "3637c5e2c12db30dd094dc2feca689fe3abb5382e20646bd2c96769e594a7a50";
    buildInputs = [ python3 python3-pbr python3-fixtures ];
  };

  "python3-mpmath" = fetch {
    name        = "python3-mpmath";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python3-mpmath-1.1.0-1-any.pkg.tar.xz";
    sha256      = "d0bb1e91138fd8f213f1b1f1d780cda672bd7f04dc3bd545ab101425001b64bb";
    buildInputs = [ python3 python3-gmpy2 ];
  };

  "python3-msgpack" = fetch {
    name        = "python3-msgpack";
    version     = "0.5.6";
    filename    = "mingw-w64-x86_64-python3-msgpack-0.5.6-1-any.pkg.tar.xz";
    sha256      = "fdcecbc97ddb7a7b8f3ab7d50f8a434444a43caca3ee105af2bff11df91506dd";
    buildInputs = [ python3 ];
  };

  "python3-ndg-httpsclient" = fetch {
    name        = "python3-ndg-httpsclient";
    version     = "0.5.1";
    filename    = "mingw-w64-x86_64-python3-ndg-httpsclient-0.5.1-1-any.pkg.tar.xz";
    sha256      = "2cbfce5b2b7a3ae7eb6dfe946f66e70e99d2fc2f4afaddbd43d526f15155228a";
    buildInputs = [ python3-pyopenssl python3-pyasn1 ];
  };

  "python3-netaddr" = fetch {
    name        = "python3-netaddr";
    version     = "0.7.19";
    filename    = "mingw-w64-x86_64-python3-netaddr-0.7.19-1-any.pkg.tar.xz";
    sha256      = "379de57a37e59635bdb064976016103f8674f5860218c1aa2aae38bfa9e6f0b9";
    buildInputs = [ python3 ];
  };

  "python3-netifaces" = fetch {
    name        = "python3-netifaces";
    version     = "0.10.7";
    filename    = "mingw-w64-x86_64-python3-netifaces-0.10.7-1-any.pkg.tar.xz";
    sha256      = "f688cc3d977751465609310d2e1dce810edd1d18621d1492b80fa7006fb2b99a";
    buildInputs = [ python3 ];
  };

  "python3-networkx" = fetch {
    name        = "python3-networkx";
    version     = "2.2";
    filename    = "mingw-w64-x86_64-python3-networkx-2.2-1-any.pkg.tar.xz";
    sha256      = "6930680327abea057f523ad537c6b9075e4edaf90a50aa51f78565beadf40442";
    buildInputs = [ python3 python3-decorator ];
  };

  "python3-nose" = fetch {
    name        = "python3-nose";
    version     = "1.3.7";
    filename    = "mingw-w64-x86_64-python3-nose-1.3.7-8-any.pkg.tar.xz";
    sha256      = "aba0a32b0988aa84ad3977c0435675062e0090f26bd76f6d065e7de84fd05e9f";
    buildInputs = [ python3-setuptools ];
  };

  "python3-notebook" = fetch {
    name        = "python3-notebook";
    version     = "5.6.0";
    filename    = "mingw-w64-x86_64-python3-notebook-5.6.0-1-any.pkg.tar.xz";
    sha256      = "528cb347fbbf2431986370caa39af2e0209dbc3fe09f0e30824359a4d79bcb11";
    buildInputs = [ python3 python3-jupyter_core python3-jupyter_client python3-jupyter-nbformat python3-jupyter-nbconvert python3-ipywidgets python3-jinja python3-traitlets python3-tornado python3-terminado python3-send2trash python3-prometheus-client ];
    broken      = true;
  };

  "python3-nuitka" = fetch {
    name        = "python3-nuitka";
    version     = "0.6.0.6";
    filename    = "mingw-w64-x86_64-python3-nuitka-0.6.0.6-1-any.pkg.tar.xz";
    sha256      = "7f604e5a910edcbf205a8f43e69b7f4a33388ef2ef44eb727e44aafdf6261954";
    buildInputs = [ python3-setuptools ];
  };

  "python3-numexpr" = fetch {
    name        = "python3-numexpr";
    version     = "2.6.8";
    filename    = "mingw-w64-x86_64-python3-numexpr-2.6.8-1-any.pkg.tar.xz";
    sha256      = "c1c2ee9ec1c517f7d2888d4b11e17bbe84726b3e670fa7d6ba0124fc981c0f56";
    buildInputs = [ python3-numpy ];
  };

  "python3-numpy" = fetch {
    name        = "python3-numpy";
    version     = "1.15.4";
    filename    = "mingw-w64-x86_64-python3-numpy-1.15.4-1-any.pkg.tar.xz";
    sha256      = "33fdbeb7bbdb17de2ba94225ec764b698bca98fb9e55f899b84ecf4d7488fbbf";
    buildInputs = [ openblas python3 ];
  };

  "python3-olefile" = fetch {
    name        = "python3-olefile";
    version     = "0.46";
    filename    = "mingw-w64-x86_64-python3-olefile-0.46-1-any.pkg.tar.xz";
    sha256      = "1dc311d52af60dcdb0211e08238606bd7e56880a9ba44df9b502e3508af04879";
    buildInputs = [ python3 ];
  };

  "python3-openmdao" = fetch {
    name        = "python3-openmdao";
    version     = "2.5.0";
    filename    = "mingw-w64-x86_64-python3-openmdao-2.5.0-1-any.pkg.tar.xz";
    sha256      = "843a8f07933c4fc79e2c1629bc2f235db1e4501bdb9f943ffef98981f4aa460c";
    buildInputs = [ python3-numpy python3-scipy python3-networkx python3-sqlitedict python3-pyparsing python3-six ];
  };

  "python3-openpyxl" = fetch {
    name        = "python3-openpyxl";
    version     = "2.5.9";
    filename    = "mingw-w64-x86_64-python3-openpyxl-2.5.9-1-any.pkg.tar.xz";
    sha256      = "5333521059b28cc2602c6c377c8d2b14d3df8fcd986a55700ece7071fd72bef1";
    buildInputs = [ python3-jdcal python3-et-xmlfile ];
  };

  "python3-oslo-concurrency" = fetch {
    name        = "python3-oslo-concurrency";
    version     = "3.29.0";
    filename    = "mingw-w64-x86_64-python3-oslo-concurrency-3.29.0-1-any.pkg.tar.xz";
    sha256      = "d7e657609c8ef5ba786085390989786248644685d31e802c57dfb2f59c9f25c6";
    buildInputs = [ python3 python3-six python3-pbr python3-oslo-config python3-oslo-i18n python3-oslo-utils python3-fasteners ];
  };

  "python3-oslo-config" = fetch {
    name        = "python3-oslo-config";
    version     = "6.7.0";
    filename    = "mingw-w64-x86_64-python3-oslo-config-6.7.0-1-any.pkg.tar.xz";
    sha256      = "0af937c187129966967b3d52f8cd48da1939c10104bcb35b5afccba17bcbd0bf";
    buildInputs = [ python3 python3-six python3-netaddr python3-stevedore python3-debtcollector python3-oslo-i18n python3-rfc3986 python3-yaml ];
  };

  "python3-oslo-context" = fetch {
    name        = "python3-oslo-context";
    version     = "2.22.0";
    filename    = "mingw-w64-x86_64-python3-oslo-context-2.22.0-1-any.pkg.tar.xz";
    sha256      = "9f950b49e14b19438e05565206ed331233e1f56926ae802784f19c0643b1428d";
    buildInputs = [ python3 python3-pbr python3-debtcollector ];
  };

  "python3-oslo-db" = fetch {
    name        = "python3-oslo-db";
    version     = "4.42.0";
    filename    = "mingw-w64-x86_64-python3-oslo-db-4.42.0-1-any.pkg.tar.xz";
    sha256      = "14cca87b60f82dfee024808521b14d4e9b18d9cbed96aa771dc06a52b9d6d3c7";
    buildInputs = [ python3 python3-six python3-pbr python3-alembic python3-debtcollector python3-oslo-i18n python3-oslo-config python3-oslo-utils python3-sqlalchemy python3-sqlalchemy-migrate python3-stevedore ];
  };

  "python3-oslo-i18n" = fetch {
    name        = "python3-oslo-i18n";
    version     = "3.23.0";
    filename    = "mingw-w64-x86_64-python3-oslo-i18n-3.23.0-1-any.pkg.tar.xz";
    sha256      = "10cd538c3339c477417bf33a68a3da3486e49bd1cc2fa1672b958684f8599bfd";
    buildInputs = [ python3 python3-six python3-pbr python3-babel ];
  };

  "python3-oslo-log" = fetch {
    name        = "python3-oslo-log";
    version     = "3.42.1";
    filename    = "mingw-w64-x86_64-python3-oslo-log-3.42.1-1-any.pkg.tar.xz";
    sha256      = "aef7737001ca5f9e342cbcfe4ee7cc007721b587c39619624863c62a0542b7d2";
    buildInputs = [ python3 python3-six python3-pbr python3-oslo-config python3-oslo-context python3-oslo-i18n python3-oslo-utils python3-oslo-serialization python3-debtcollector python3-dateutil python3-monotonic ];
  };

  "python3-oslo-serialization" = fetch {
    name        = "python3-oslo-serialization";
    version     = "2.28.1";
    filename    = "mingw-w64-x86_64-python3-oslo-serialization-2.28.1-1-any.pkg.tar.xz";
    sha256      = "79f5f1225501ccf72c49fcc3e9f5720d39e4e253e4728bf8856d9ffa3702c4df";
    buildInputs = [ python3 python3-six python3-pbr python3-babel python3-msgpack python3-oslo-utils python3-pytz ];
  };

  "python3-oslo-utils" = fetch {
    name        = "python3-oslo-utils";
    version     = "3.39.0";
    filename    = "mingw-w64-x86_64-python3-oslo-utils-3.39.0-1-any.pkg.tar.xz";
    sha256      = "2b19ed4b5d76152ef4efcb5f5bf64709e5df04195c6058eef730e81ddfdd5130";
    buildInputs = [ python3 ];
  };

  "python3-oslosphinx" = fetch {
    name        = "python3-oslosphinx";
    version     = "4.18.0";
    filename    = "mingw-w64-x86_64-python3-oslosphinx-4.18.0-1-any.pkg.tar.xz";
    sha256      = "0d0936f39b7b92cf90acc67b6f7b28c553eabeff9326e29ff7dfcfccbbff7c77";
    buildInputs = [ python3 python3-six python3-requests ];
  };

  "python3-oslotest" = fetch {
    name        = "python3-oslotest";
    version     = "3.7.0";
    filename    = "mingw-w64-x86_64-python3-oslotest-3.7.0-1-any.pkg.tar.xz";
    sha256      = "e37c5052fa9d90ca412fa4a65dfb445228992511339edd7239024ecd27e7ad37";
    buildInputs = [ python3 ];
  };

  "python3-packaging" = fetch {
    name        = "python3-packaging";
    version     = "18.0";
    filename    = "mingw-w64-x86_64-python3-packaging-18.0-1-any.pkg.tar.xz";
    sha256      = "de7eb39dbbb3181d1693d32e51759d89042c91edf5ead6e49ea06ebfacc60f68";
    buildInputs = [ python3 python3-pyparsing python3-six ];
  };

  "python3-pandas" = fetch {
    name        = "python3-pandas";
    version     = "0.23.4";
    filename    = "mingw-w64-x86_64-python3-pandas-0.23.4-1-any.pkg.tar.xz";
    sha256      = "45015cc7246a2e46561db74cb06f20523a4ab4bf21c611efff76414689d88ddf";
    buildInputs = [ python3-numpy python3-pytz python3-dateutil python3-setuptools ];
  };

  "python3-pandocfilters" = fetch {
    name        = "python3-pandocfilters";
    version     = "1.4.2";
    filename    = "mingw-w64-x86_64-python3-pandocfilters-1.4.2-2-any.pkg.tar.xz";
    sha256      = "71655288544977cb493c15ceb7387502460986ac57b0fd06e93abfc71c36c16e";
    buildInputs = [ python3 ];
  };

  "python3-paramiko" = fetch {
    name        = "python3-paramiko";
    version     = "2.4.2";
    filename    = "mingw-w64-x86_64-python3-paramiko-2.4.2-1-any.pkg.tar.xz";
    sha256      = "45c8c915c79179c37bbeebc2d5edc0110864abe5e037f37a79990769d1c57f46";
    buildInputs = [ python3 ];
  };

  "python3-parso" = fetch {
    name        = "python3-parso";
    version     = "0.3.1";
    filename    = "mingw-w64-x86_64-python3-parso-0.3.1-1-any.pkg.tar.xz";
    sha256      = "06bfd3b64fbdbb46e194926f90595769a6f16d32af3b525d0062262c688048c2";
    buildInputs = [ python3 ];
  };

  "python3-path" = fetch {
    name        = "python3-path";
    version     = "11.5.0";
    filename    = "mingw-w64-x86_64-python3-path-11.5.0-1-any.pkg.tar.xz";
    sha256      = "76a7caffb339551a7320d4c4ab3f6431e91730d4ba585c4ed36d6470f9d19511";
    buildInputs = [ python3-importlib-metadata ];
  };

  "python3-pathlib2" = fetch {
    name        = "python3-pathlib2";
    version     = "2.3.3";
    filename    = "mingw-w64-x86_64-python3-pathlib2-2.3.3-1-any.pkg.tar.xz";
    sha256      = "9efcab145cf35b86fca8fb1abe8a6bef6207fb6ad726bb7353ac510fe0c94cca";
    buildInputs = [ python3 python3-scandir ];
  };

  "python3-pathtools" = fetch {
    name        = "python3-pathtools";
    version     = "0.1.2";
    filename    = "mingw-w64-x86_64-python3-pathtools-0.1.2-1-any.pkg.tar.xz";
    sha256      = "df4ab370ac93333cb6ed2a599d6b96a5b246f64b7e70480ed5f31039d9151425";
    buildInputs = [ python3 ];
  };

  "python3-patsy" = fetch {
    name        = "python3-patsy";
    version     = "0.5.0";
    filename    = "mingw-w64-x86_64-python3-patsy-0.5.0-2-any.pkg.tar.xz";
    sha256      = "c20cecd6d7aa1f14ccc64e46a2c496c1bc81bd7442af09fc34963d617dba3b38";
    buildInputs = [ python3-numpy ];
  };

  "python3-pbr" = fetch {
    name        = "python3-pbr";
    version     = "5.1.1";
    filename    = "mingw-w64-x86_64-python3-pbr-5.1.1-2-any.pkg.tar.xz";
    sha256      = "2306a272711e17c1f98c3c3230ff2778e9f8bf88c4af1972a489f1753a960443";
    buildInputs = [ python3-setuptools ];
  };

  "python3-pdfrw" = fetch {
    name        = "python3-pdfrw";
    version     = "0.4";
    filename    = "mingw-w64-x86_64-python3-pdfrw-0.4-2-any.pkg.tar.xz";
    sha256      = "63da1c0706ea9e16693b6f306ff2b359d2e10b712640fba213d111e1eb5515d7";
    buildInputs = [ python3 ];
  };

  "python3-pep517" = fetch {
    name        = "python3-pep517";
    version     = "0.5.0";
    filename    = "mingw-w64-x86_64-python3-pep517-0.5.0-1-any.pkg.tar.xz";
    sha256      = "a998606fc43fa9b4b05df34207d0347d2b48ef540f4ea6ebf872daaecadf2830";
    buildInputs = [ python3 ];
  };

  "python3-pexpect" = fetch {
    name        = "python3-pexpect";
    version     = "4.6.0";
    filename    = "mingw-w64-x86_64-python3-pexpect-4.6.0-1-any.pkg.tar.xz";
    sha256      = "b39adae1b482ff3ce9549bd043b7f3916d57b6d9e2f6c4779509b2dfacf9f9c5";
    buildInputs = [ python3 python3-ptyprocess ];
  };

  "python3-pgen2" = fetch {
    name        = "python3-pgen2";
    version     = "0.1.0";
    filename    = "mingw-w64-x86_64-python3-pgen2-0.1.0-3-any.pkg.tar.xz";
    sha256      = "e454c463e9ce543baa6db551af312c932313ff88e0d8d24c58b55128197445b3";
    buildInputs = [ python3 ];
  };

  "python3-pickleshare" = fetch {
    name        = "python3-pickleshare";
    version     = "0.7.5";
    filename    = "mingw-w64-x86_64-python3-pickleshare-0.7.5-1-any.pkg.tar.xz";
    sha256      = "69fe098c556a663b204ce316e63c72b2b4bc82d3f1818341a10dd6215535c836";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python3-path.version "8.1"; python3-path) ];
  };

  "python3-pillow" = fetch {
    name        = "python3-pillow";
    version     = "5.3.0";
    filename    = "mingw-w64-x86_64-python3-pillow-5.3.0-1-any.pkg.tar.xz";
    sha256      = "49d737fac08fc75488d50edb40535709704b0d2fe909cd770006b0b5699457c2";
    buildInputs = [ freetype lcms2 libjpeg libtiff libwebp openjpeg2 zlib python3 python3-olefile ];
  };

  "python3-pip" = fetch {
    name        = "python3-pip";
    version     = "18.1";
    filename    = "mingw-w64-x86_64-python3-pip-18.1-2-any.pkg.tar.xz";
    sha256      = "51f7a70f3d81ce0e6693c05fb3d8d1ca4047f6529dd0450dbd64b7406ebe5121";
    buildInputs = [ python3-setuptools python3-appdirs python3-cachecontrol python3-colorama python3-distlib python3-html5lib python3-lockfile python3-msgpack python3-packaging python3-pep517 python3-progress python3-pyparsing python3-pytoml python3-requests python3-retrying python3-six python3-webencodings ];
  };

  "python3-pkginfo" = fetch {
    name        = "python3-pkginfo";
    version     = "1.4.2";
    filename    = "mingw-w64-x86_64-python3-pkginfo-1.4.2-1-any.pkg.tar.xz";
    sha256      = "dbe31bea0fdf07f8485d81330cac5cc61844ff7f9904041b24a3c317b6871837";
    buildInputs = [ python3 ];
  };

  "python3-pluggy" = fetch {
    name        = "python3-pluggy";
    version     = "0.8.0";
    filename    = "mingw-w64-x86_64-python3-pluggy-0.8.0-2-any.pkg.tar.xz";
    sha256      = "152d1dafef805b4c61aaad066da07676d82431a897bd90e67c96a1dd1958e2de";
    buildInputs = [ python3 ];
  };

  "python3-ply" = fetch {
    name        = "python3-ply";
    version     = "3.11";
    filename    = "mingw-w64-x86_64-python3-ply-3.11-2-any.pkg.tar.xz";
    sha256      = "087d265fb4eac981c75b02aee6e87ad376ea021b13eecd6a72291437407ad9c7";
    buildInputs = [ python3 ];
  };

  "python3-pptx" = fetch {
    name        = "python3-pptx";
    version     = "0.6.10";
    filename    = "mingw-w64-x86_64-python3-pptx-0.6.10-1-any.pkg.tar.xz";
    sha256      = "f02fbc79606954546f53656686c5d9bf884b972a334139aae2575d022d457b36";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python3-lxml.version "3.1.0"; python3-lxml) (assert stdenvNoCC.lib.versionAtLeast python3-pillow.version "2.6.1"; python3-pillow) (assert stdenvNoCC.lib.versionAtLeast python3-xlsxwriter.version "0.5.7"; python3-xlsxwriter) ];
  };

  "python3-pretend" = fetch {
    name        = "python3-pretend";
    version     = "1.0.9";
    filename    = "mingw-w64-x86_64-python3-pretend-1.0.9-2-any.pkg.tar.xz";
    sha256      = "98262b7c41df7f0ceb7bcfb231525c05cbaafcc11801b96a5648a8a020e98b90";
    buildInputs = [ python3 ];
  };

  "python3-prettytable" = fetch {
    name        = "python3-prettytable";
    version     = "0.7.2";
    filename    = "mingw-w64-x86_64-python3-prettytable-0.7.2-2-any.pkg.tar.xz";
    sha256      = "42c8989aae729c9295659a4e1d5f2b5fbfa84464287c3f2c258246b9ccde42bd";
    buildInputs = [ python3 ];
  };

  "python3-progress" = fetch {
    name        = "python3-progress";
    version     = "1.4";
    filename    = "mingw-w64-x86_64-python3-progress-1.4-3-any.pkg.tar.xz";
    sha256      = "5f379cd3cd19047a41637ddef3c7d608e3490a05839014b61db7f0f9f95bd4d6";
    buildInputs = [ python3 ];
  };

  "python3-prometheus-client" = fetch {
    name        = "python3-prometheus-client";
    version     = "0.2.0";
    filename    = "mingw-w64-x86_64-python3-prometheus-client-0.2.0-1-any.pkg.tar.xz";
    sha256      = "f3735744d7164ddbf9a1737c0528e9f54c3559b93befe3926b14acef68e2eeb6";
    buildInputs = [ python3 ];
  };

  "python3-prompt_toolkit" = fetch {
    name        = "python3-prompt_toolkit";
    version     = "2.0.7";
    filename    = "mingw-w64-x86_64-python3-prompt_toolkit-2.0.7-1-any.pkg.tar.xz";
    sha256      = "b04946397d1fea235f80cf5cda0696040b4b07b44bd2888e73a5ed2d4ff5eb66";
    buildInputs = [ python3-pygments python3-six python3-wcwidth ];
  };

  "python3-psutil" = fetch {
    name        = "python3-psutil";
    version     = "5.4.8";
    filename    = "mingw-w64-x86_64-python3-psutil-5.4.8-1-any.pkg.tar.xz";
    sha256      = "c665d715f003809930e6f627757bbbb4bbcddae92d00f2875f796345e0fd9301";
    buildInputs = [ python3 ];
  };

  "python3-psycopg2" = fetch {
    name        = "python3-psycopg2";
    version     = "2.7.6.1";
    filename    = "mingw-w64-x86_64-python3-psycopg2-2.7.6.1-1-any.pkg.tar.xz";
    sha256      = "f1b843d7035d68924d91f260e44ffb9bf7974975a7b3a23eaf1723af3cdacf6f";
    buildInputs = [ python3 ];
  };

  "python3-ptyprocess" = fetch {
    name        = "python3-ptyprocess";
    version     = "0.6.0";
    filename    = "mingw-w64-x86_64-python3-ptyprocess-0.6.0-1-any.pkg.tar.xz";
    sha256      = "22285e45686cb9792bdbca13912a6c0e0155466746f97482543b89f93a90d920";
    buildInputs = [ python3 ];
  };

  "python3-py" = fetch {
    name        = "python3-py";
    version     = "1.7.0";
    filename    = "mingw-w64-x86_64-python3-py-1.7.0-1-any.pkg.tar.xz";
    sha256      = "ee16d28927fd1c86bca9d0cbd9d28ab443d8e2e2a33b07e5c4f2516df97f92bc";
    buildInputs = [ python3 ];
  };

  "python3-py-cpuinfo" = fetch {
    name        = "python3-py-cpuinfo";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-python3-py-cpuinfo-4.0.0-1-any.pkg.tar.xz";
    sha256      = "385060b733d5a9079210e99f0db145a34e9411bf298f7e4b799f8b62bdb32579";
    buildInputs = [ python3 ];
  };

  "python3-pyamg" = fetch {
    name        = "python3-pyamg";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-python3-pyamg-4.0.0-1-any.pkg.tar.xz";
    sha256      = "0b765f0fa026434427ea53103fdd0c55420b7bf6358034db1bfa85d396d8a01e";
    buildInputs = [ python3 python3-scipy python3-numpy ];
  };

  "python3-pyasn1" = fetch {
    name        = "python3-pyasn1";
    version     = "0.4.4";
    filename    = "mingw-w64-x86_64-python3-pyasn1-0.4.4-1-any.pkg.tar.xz";
    sha256      = "bd15b7ddca5c23139264b1c6b65b48b5d216b39cf278de6f98ffed38761ef1f7";
    buildInputs = [  ];
  };

  "python3-pyasn1-modules" = fetch {
    name        = "python3-pyasn1-modules";
    version     = "0.2.2";
    filename    = "mingw-w64-x86_64-python3-pyasn1-modules-0.2.2-1-any.pkg.tar.xz";
    sha256      = "2189c9496af49a37b0470e8db893a5b930615d10508a96ad5b2a0f63646c25b4";
  };

  "python3-pycodestyle" = fetch {
    name        = "python3-pycodestyle";
    version     = "2.4.0";
    filename    = "mingw-w64-x86_64-python3-pycodestyle-2.4.0-1-any.pkg.tar.xz";
    sha256      = "2b4f4e7e597ee2bcd02e32ca99cd1bc926dafc2be1397ecf9a832a5da236dfbb";
    buildInputs = [ python3 ];
  };

  "python3-pycparser" = fetch {
    name        = "python3-pycparser";
    version     = "2.19";
    filename    = "mingw-w64-x86_64-python3-pycparser-2.19-1-any.pkg.tar.xz";
    sha256      = "fe724218d0714a37c2d4e6ba38954b49942afaeff6133e23cbc954d896b280de";
    buildInputs = [ python3 python3-ply ];
  };

  "python3-pyflakes" = fetch {
    name        = "python3-pyflakes";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-python3-pyflakes-2.0.0-2-any.pkg.tar.xz";
    sha256      = "0ae9e1bebd0bcabd875ada4fe55f3a2b3d5d1f0f0dc86b204b570c02dd6201f0";
    buildInputs = [ python3 ];
  };

  "python3-pyglet" = fetch {
    name        = "python3-pyglet";
    version     = "1.3.2";
    filename    = "mingw-w64-x86_64-python3-pyglet-1.3.2-1-any.pkg.tar.xz";
    sha256      = "ea28b0e1d387db31fe2147991836c29b023cf24e70e1b8a82259b6577cbdf130";
    buildInputs = [ python3 python3-future ];
  };

  "python3-pygments" = fetch {
    name        = "python3-pygments";
    version     = "2.3.1";
    filename    = "mingw-w64-x86_64-python3-pygments-2.3.1-1-any.pkg.tar.xz";
    sha256      = "e4a68ff85c5a1c3ea5a914dc6fc426410b96e7645b22a509f2a462ab839a2726";
    buildInputs = [ python3-setuptools ];
  };

  "python3-pylint" = fetch {
    name        = "python3-pylint";
    version     = "2.2.2";
    filename    = "mingw-w64-x86_64-python3-pylint-2.2.2-1-any.pkg.tar.xz";
    sha256      = "a593126db13d84eae9d7abae3f85fc6e873ba06ae7c89d9339fd072bc807686e";
    buildInputs = [ python3-astroid python3-colorama python3-mccabe python3-isort ];
  };

  "python3-pynacl" = fetch {
    name        = "python3-pynacl";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-python3-pynacl-1.3.0-1-any.pkg.tar.xz";
    sha256      = "8fdc8c78336d509a577fa1764d5e5e4f780a6f4629ba5c80135a3da49997eba5";
    buildInputs = [ python3 ];
  };

  "python3-pyopenssl" = fetch {
    name        = "python3-pyopenssl";
    version     = "18.0.0";
    filename    = "mingw-w64-x86_64-python3-pyopenssl-18.0.0-3-any.pkg.tar.xz";
    sha256      = "942c54f036acfa390db238d0b239dc5c06a1313b8e5ebd024f7fb67a88357764";
    buildInputs = [ openssl python3-cryptography python3-six ];
  };

  "python3-pyparsing" = fetch {
    name        = "python3-pyparsing";
    version     = "2.3.0";
    filename    = "mingw-w64-x86_64-python3-pyparsing-2.3.0-1-any.pkg.tar.xz";
    sha256      = "de83bc36391e78fbe32345c02da1ce7388e003fa23c30f1754ce5162c63f4158";
    buildInputs = [ python3 ];
  };

  "python3-pyperclip" = fetch {
    name        = "python3-pyperclip";
    version     = "1.7.0";
    filename    = "mingw-w64-x86_64-python3-pyperclip-1.7.0-1-any.pkg.tar.xz";
    sha256      = "ed9184d2f14c0936f97bbe784bb4df8c3698e6265e423016bba3c2bf9acba79f";
    buildInputs = [ python3 ];
  };

  "python3-pyqt4" = fetch {
    name        = "python3-pyqt4";
    version     = "4.11.4";
    filename    = "mingw-w64-x86_64-python3-pyqt4-4.11.4-2-any.pkg.tar.xz";
    sha256      = "815753d0b0b74f0fc4773c9e23744c7b58dba74c92103c4a655e4d86119cda41";
    buildInputs = [ python3-sip pyqt4-common python3 ];
  };

  "python3-pyqt5" = fetch {
    name        = "python3-pyqt5";
    version     = "5.11.3";
    filename    = "mingw-w64-x86_64-python3-pyqt5-5.11.3-1-any.pkg.tar.xz";
    sha256      = "7626b52ae1253ffca22cdeefb6c959e8410fc97df68e7d8932aec07045009bf6";
    buildInputs = [ python3-sip pyqt5-common python3 ];
    broken      = true;
  };

  "python3-pyreadline" = fetch {
    name        = "python3-pyreadline";
    version     = "2.1";
    filename    = "mingw-w64-x86_64-python3-pyreadline-2.1-1-any.pkg.tar.xz";
    sha256      = "ff1c20f2462358607d2b904ddd412c77aee108fcd6e88adc8c032b1d8b8531f1";
    buildInputs = [ python3 ];
  };

  "python3-pyrsistent" = fetch {
    name        = "python3-pyrsistent";
    version     = "0.14.8";
    filename    = "mingw-w64-x86_64-python3-pyrsistent-0.14.8-1-any.pkg.tar.xz";
    sha256      = "6237c02531f96444f2dfede5db80ada8005c46e16de46e173bf08dc35b3c3108";
    buildInputs = [ python3 ];
  };

  "python3-pyserial" = fetch {
    name        = "python3-pyserial";
    version     = "3.4";
    filename    = "mingw-w64-x86_64-python3-pyserial-3.4-1-any.pkg.tar.xz";
    sha256      = "85bc7ebe408468f7f1b683fbaade0f88f92ffac385613e0d14917b201ee26bed";
    buildInputs = [ python3 ];
  };

  "python3-pyside-qt4" = fetch {
    name        = "python3-pyside-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-python3-pyside-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "91c651543c420292180ab3fb3d35ec9491f162819d57361d5e0b4517a6a34e24";
    buildInputs = [ pyside-common-qt4 python3 python3-shiboken-qt4 qt4 ];
  };

  "python3-pyside-tools-qt4" = fetch {
    name        = "python3-pyside-tools-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-python3-pyside-tools-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "b9c36e4bac2ddff43066a021e83aad5755d632c1328c9ab2abf46c724ee942e3";
    buildInputs = [ pyside-tools-common-qt4 python3-pyside-qt4 ];
  };

  "python3-pysocks" = fetch {
    name        = "python3-pysocks";
    version     = "1.6.8";
    filename    = "mingw-w64-x86_64-python3-pysocks-1.6.8-1-any.pkg.tar.xz";
    sha256      = "0aa68de0cf777db55d5ecd83f3814e1d49f9dd68287a4c6e5fabf7d0164dba4e";
    buildInputs = [ python3 python3-win_inet_pton ];
  };

  "python3-pystemmer" = fetch {
    name        = "python3-pystemmer";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-python3-pystemmer-1.3.0-2-any.pkg.tar.xz";
    sha256      = "49e7e2bbc9c5b58c6e29e4fefdfc1e923928c9b5a6d43ebc7a74dc22ac53a939";
    buildInputs = [ python3 ];
  };

  "python3-pytest" = fetch {
    name        = "python3-pytest";
    version     = "4.0.2";
    filename    = "mingw-w64-x86_64-python3-pytest-4.0.2-1-any.pkg.tar.xz";
    sha256      = "c982ae011e9a81d0ac87a3ab896f225ea898a938c8dc5a1e1fe181d1288f3233";
    buildInputs = [ python3-py python3-pluggy python3-setuptools python3-colorama python3-six python3-atomicwrites python3-more-itertools python3-attrs ];
  };

  "python3-pytest-benchmark" = fetch {
    name        = "python3-pytest-benchmark";
    version     = "3.1.1";
    filename    = "mingw-w64-x86_64-python3-pytest-benchmark-3.1.1-1-any.pkg.tar.xz";
    sha256      = "2e76eb0f76fb8549d0ab169cb80a6e443d14fd9b6e9a6ea3fcf4800d42d97a58";
    buildInputs = [ python3 python3-py-cpuinfo python3-pytest ];
  };

  "python3-pytest-expect" = fetch {
    name        = "python3-pytest-expect";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python3-pytest-expect-1.1.0-1-any.pkg.tar.xz";
    sha256      = "8a1e37ff68c0c96f87006da5bdbf0fcf460fe457d64702f65bb442d7ca20634a";
    buildInputs = [ python3 python3-pytest python3-u-msgpack ];
  };

  "python3-pytest-forked" = fetch {
    name        = "python3-pytest-forked";
    version     = "0.2";
    filename    = "mingw-w64-x86_64-python3-pytest-forked-0.2-1-any.pkg.tar.xz";
    sha256      = "7da276de5fbf1b4068521e507ab577c55e7250aae6f807f84955e6cebe067b87";
    buildInputs = [ python3 python3-pytest ];
  };

  "python3-pytest-runner" = fetch {
    name        = "python3-pytest-runner";
    version     = "4.2";
    filename    = "mingw-w64-x86_64-python3-pytest-runner-4.2-4-any.pkg.tar.xz";
    sha256      = "1460a743466678f778aa40f714da51b25a2a9d0a74d5889560b28efcebc8ebd5";
    buildInputs = [ python3 python3-pytest ];
  };

  "python3-pytest-xdist" = fetch {
    name        = "python3-pytest-xdist";
    version     = "1.25.0";
    filename    = "mingw-w64-x86_64-python3-pytest-xdist-1.25.0-1-any.pkg.tar.xz";
    sha256      = "582a9453cf83d8b0dc64c28a50b12d89bc326fa986140e9102e7373acc71a3f6";
    buildInputs = [ python3 python3-pytest-forked python3-execnet ];
  };

  "python3-python_ics" = fetch {
    name        = "python3-python_ics";
    version     = "2.15";
    filename    = "mingw-w64-x86_64-python3-python_ics-2.15-1-any.pkg.tar.xz";
    sha256      = "6e13ca461496dcb30d9689d1a6789e1fe6fda8f066b98c5722474566227e9570";
    buildInputs = [ python3 ];
  };

  "python3-pytoml" = fetch {
    name        = "python3-pytoml";
    version     = "0.1.20";
    filename    = "mingw-w64-x86_64-python3-pytoml-0.1.20-1-any.pkg.tar.xz";
    sha256      = "fc2b8f3ab14d34939317ec512a5e5a13248a4b812bb3f2ed5dc77b0c033078f0";
    buildInputs = [ python3 ];
  };

  "python3-pytz" = fetch {
    name        = "python3-pytz";
    version     = "2018.7";
    filename    = "mingw-w64-x86_64-python3-pytz-2018.7-1-any.pkg.tar.xz";
    sha256      = "6cc7a8f6eea18e0b6aec7ea7c1162af5bc275da74dfc5e7cbb08803e34279e8e";
    buildInputs = [ python3 ];
  };

  "python3-pyu2f" = fetch {
    name        = "python3-pyu2f";
    version     = "0.1.4";
    filename    = "mingw-w64-x86_64-python3-pyu2f-0.1.4-1-any.pkg.tar.xz";
    sha256      = "a0d4298ed8812b02c510bfe8215e3ce5699f376cb46b467af3b6be03549a56cb";
    buildInputs = [ python3 ];
  };

  "python3-pywavelets" = fetch {
    name        = "python3-pywavelets";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python3-pywavelets-1.0.1-1-any.pkg.tar.xz";
    sha256      = "18be928abf4efd1c383361a733db400508b73dc37828cf683b353e5a848e791e";
    buildInputs = [ python3-numpy python3 ];
  };

  "python3-pyzmq" = fetch {
    name        = "python3-pyzmq";
    version     = "17.1.2";
    filename    = "mingw-w64-x86_64-python3-pyzmq-17.1.2-1-any.pkg.tar.xz";
    sha256      = "b75e9cdac32e1a7f738699800031c4511b666d4fc4b4c439de36061bea3ba10c";
    buildInputs = [ python3 zeromq ];
  };

  "python3-pyzopfli" = fetch {
    name        = "python3-pyzopfli";
    version     = "0.1.4";
    filename    = "mingw-w64-x86_64-python3-pyzopfli-0.1.4-1-any.pkg.tar.xz";
    sha256      = "b6ee4c01b12f7bf5b4a0613e253be1b5d102b5c1e7b841785985d21117ba21ce";
    buildInputs = [ python3 ];
  };

  "python3-qscintilla" = fetch {
    name        = "python3-qscintilla";
    version     = "2.10.8";
    filename    = "mingw-w64-x86_64-python3-qscintilla-2.10.8-1-any.pkg.tar.xz";
    sha256      = "0a81a34887c9aabebf56f26c5f347b2d2f2421acb3b356fc8c135f5638853f68";
    buildInputs = [ python-qscintilla-common python3-pyqt5 ];
    broken      = true;
  };

  "python3-qtconsole" = fetch {
    name        = "python3-qtconsole";
    version     = "4.4.1";
    filename    = "mingw-w64-x86_64-python3-qtconsole-4.4.1-1-any.pkg.tar.xz";
    sha256      = "9bef3c480665072317c4639db58d514ab24fc499a97e0d9f3510237ba498cb1b";
    buildInputs = [ python3 python3-jupyter_core python3-jupyter_client python3-pyqt5 ];
    broken      = true;
  };

  "python3-rencode" = fetch {
    name        = "python3-rencode";
    version     = "1.0.6";
    filename    = "mingw-w64-x86_64-python3-rencode-1.0.6-1-any.pkg.tar.xz";
    sha256      = "8861ab5f05150f574c317c0cb449590b25fbf45b5c2b9e2afa16c02dbb88ec25";
    buildInputs = [ python3 ];
  };

  "python3-reportlab" = fetch {
    name        = "python3-reportlab";
    version     = "3.5.12";
    filename    = "mingw-w64-x86_64-python3-reportlab-3.5.12-1-any.pkg.tar.xz";
    sha256      = "9bbc922d278269b491c39ac4f499dfc91d9c510849ed3f6a5b4528fc61951fc0";
    buildInputs = [ freetype python3-pip python3-Pillow ];
    broken      = true;
  };

  "python3-requests" = fetch {
    name        = "python3-requests";
    version     = "2.21.0";
    filename    = "mingw-w64-x86_64-python3-requests-2.21.0-1-any.pkg.tar.xz";
    sha256      = "009c0ff7cceba879b7f2f23e2e8b5a264d70d0c3c45766204bf8d261c25b154a";
    buildInputs = [ python3-urllib3 python3-chardet python3-idna ];
  };

  "python3-requests-kerberos" = fetch {
    name        = "python3-requests-kerberos";
    version     = "0.12.0";
    filename    = "mingw-w64-x86_64-python3-requests-kerberos-0.12.0-1-any.pkg.tar.xz";
    sha256      = "264e09b95af425d07b90d77c06ec4263b596bcdb3cd7ed7669259007a9cead61";
    buildInputs = [ python3 python3-cryptography python3-winkerberos ];
  };

  "python3-retrying" = fetch {
    name        = "python3-retrying";
    version     = "1.3.3";
    filename    = "mingw-w64-x86_64-python3-retrying-1.3.3-1-any.pkg.tar.xz";
    sha256      = "2ae9b10dc78181894b4e25a341aa718448bfe967403c03a8b5e0cb446778aadc";
    buildInputs = [ python3 ];
  };

  "python3-rfc3986" = fetch {
    name        = "python3-rfc3986";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-python3-rfc3986-1.2.0-1-any.pkg.tar.xz";
    sha256      = "6443085750f5e56e75adfb0dbf9b003332353c217ab8b991c014877a078832b0";
    buildInputs = [ python3 ];
  };

  "python3-rfc3987" = fetch {
    name        = "python3-rfc3987";
    version     = "1.3.8";
    filename    = "mingw-w64-x86_64-python3-rfc3987-1.3.8-1-any.pkg.tar.xz";
    sha256      = "3c79a4cc256f0079df2666d0657a2dcdd1810a3bf9634b3cdedc9ecaf3e188d1";
    buildInputs = [ python3 ];
  };

  "python3-rst2pdf" = fetch {
    name        = "python3-rst2pdf";
    version     = "0.93";
    filename    = "mingw-w64-x86_64-python3-rst2pdf-0.93-4-any.pkg.tar.xz";
    sha256      = "991f6e54d35fd8384052fdcf44c35771d1069ee9369e50b2f635c91423bdc16d";
    buildInputs = [ python3 python3-docutils python3-pdfrw python3-pygments (assert stdenvNoCC.lib.versionAtLeast python3-reportlab.version "2.4"; python3-reportlab) python3-setuptools ];
    broken      = true;
  };

  "python3-scandir" = fetch {
    name        = "python3-scandir";
    version     = "1.9.0";
    filename    = "mingw-w64-x86_64-python3-scandir-1.9.0-1-any.pkg.tar.xz";
    sha256      = "2ec6c62e2a5c7b73f0a7e82d5729f68935f323ec073761db58b8c0cb506cea43";
    buildInputs = [ python3 ];
  };

  "python3-scikit-learn" = fetch {
    name        = "python3-scikit-learn";
    version     = "0.20.0";
    filename    = "mingw-w64-x86_64-python3-scikit-learn-0.20.0-1-any.pkg.tar.xz";
    sha256      = "493785f5ff6d5b3b75e1be95ef048a23f71ff3d5c1559f1cf8bf2190a73da227";
    buildInputs = [ python3 python3-scipy ];
  };

  "python3-scipy" = fetch {
    name        = "python3-scipy";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-python3-scipy-1.2.0-1-any.pkg.tar.xz";
    sha256      = "3909b30a5cac96576ebfd9a078f10a9bc3721df5dcc6de31d51a5581888d8ee5";
    buildInputs = [ gcc-libgfortran openblas python3-numpy ];
  };

  "python3-send2trash" = fetch {
    name        = "python3-send2trash";
    version     = "1.5.0";
    filename    = "mingw-w64-x86_64-python3-send2trash-1.5.0-2-any.pkg.tar.xz";
    sha256      = "f75270ef88d4de94622ee866f5336fa70a4993e1fbad35d636ca14e246cb1aac";
    buildInputs = [ python3 ];
  };

  "python3-setproctitle" = fetch {
    name        = "python3-setproctitle";
    version     = "1.1.10";
    filename    = "mingw-w64-x86_64-python3-setproctitle-1.1.10-1-any.pkg.tar.xz";
    sha256      = "09afadbb267721e53576918280b9f385695b25760762888a0379a476f191a270";
    buildInputs = [ python3 ];
  };

  "python3-setuptools" = fetch {
    name        = "python3-setuptools";
    version     = "40.6.3";
    filename    = "mingw-w64-x86_64-python3-setuptools-40.6.3-1-any.pkg.tar.xz";
    sha256      = "0effbfda73ba3e6fe46ce61e5d92a4d2a5fc5bc8b3fff2716d40834d27054383";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python3.version "3.3"; python3) python3-packaging python3-pyparsing python3-appdirs python3-six ];
  };

  "python3-setuptools-git" = fetch {
    name        = "python3-setuptools-git";
    version     = "1.2";
    filename    = "mingw-w64-x86_64-python3-setuptools-git-1.2-1-any.pkg.tar.xz";
    sha256      = "0a0aead7d534b0836cfe15505ae54286550ad08185641e8306de844a815b695c";
    buildInputs = [ python3 python3-setuptools git ];
    broken      = true;
  };

  "python3-setuptools-scm" = fetch {
    name        = "python3-setuptools-scm";
    version     = "3.1.0";
    filename    = "mingw-w64-x86_64-python3-setuptools-scm-3.1.0-1-any.pkg.tar.xz";
    sha256      = "a95552ec29e888c2d012eb083e36aa64c28f40632852929acd2d1ab153f007cf";
    buildInputs = [ python3-setuptools ];
  };

  "python3-shiboken-qt4" = fetch {
    name        = "python3-shiboken-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-python3-shiboken-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "15169bb744f80690c6b92ea00895d81a99d0ebcb5bf0f297942c86302dde8366";
    buildInputs = [ libxml2 libxslt python3 shiboken-qt4 qt4 ];
  };

  "python3-simplegeneric" = fetch {
    name        = "python3-simplegeneric";
    version     = "0.8.1";
    filename    = "mingw-w64-x86_64-python3-simplegeneric-0.8.1-4-any.pkg.tar.xz";
    sha256      = "cd2c76f430d990da7e37329e205af9cb43b2c8cfa4e8d92c53274492ad6e566a";
    buildInputs = [ python3 ];
  };

  "python3-sip" = fetch {
    name        = "python3-sip";
    version     = "4.19.13";
    filename    = "mingw-w64-x86_64-python3-sip-4.19.13-2-any.pkg.tar.xz";
    sha256      = "f30fd97f24d36303bcad7d9569068282cd301d723f15561beaa2c6c2e845ee72";
    buildInputs = [ sip python3 ];
  };

  "python3-six" = fetch {
    name        = "python3-six";
    version     = "1.12.0";
    filename    = "mingw-w64-x86_64-python3-six-1.12.0-1-any.pkg.tar.xz";
    sha256      = "a706c8a42cf07518c7cb3ed859dfd57385c545d7f64f28ef143de5730809d78c";
    buildInputs = [ python3 ];
  };

  "python3-snowballstemmer" = fetch {
    name        = "python3-snowballstemmer";
    version     = "1.2.1";
    filename    = "mingw-w64-x86_64-python3-snowballstemmer-1.2.1-3-any.pkg.tar.xz";
    sha256      = "31cfef006e0009ab9de3330953f47f8d896a5ce24ebf8a79dc31f59730ebc5a4";
    buildInputs = [ python3 ];
  };

  "python3-sphinx" = fetch {
    name        = "python3-sphinx";
    version     = "1.8.3";
    filename    = "mingw-w64-x86_64-python3-sphinx-1.8.3-1-any.pkg.tar.xz";
    sha256      = "ba671d81ed849489f6f082452c6998d03f2aa1f3244e5eb850f5c911374b3003";
    buildInputs = [ python3-babel python3-certifi python3-chardet python3-colorama python3-docutils python3-idna python3-imagesize python3-jinja python3-packaging python3-pygments python3-requests python3-sphinx_rtd_theme python3-snowballstemmer python3-sphinx-alabaster-theme python3-sphinxcontrib-websupport python3-six python3-sqlalchemy python3-urllib3 python3-whoosh ];
  };

  "python3-sphinx-alabaster-theme" = fetch {
    name        = "python3-sphinx-alabaster-theme";
    version     = "0.7.11";
    filename    = "mingw-w64-x86_64-python3-sphinx-alabaster-theme-0.7.11-1-any.pkg.tar.xz";
    sha256      = "5429f3b58d332185cc8222b58f3e3a5c0d34da9c655df6432d555617a2e196e7";
    buildInputs = [ python3 ];
  };

  "python3-sphinx_rtd_theme" = fetch {
    name        = "python3-sphinx_rtd_theme";
    version     = "0.4.1";
    filename    = "mingw-w64-x86_64-python3-sphinx_rtd_theme-0.4.1-1-any.pkg.tar.xz";
    sha256      = "e9abaac9e8c8f2bc8abf58e79fb5113565cc672608061b8463be3b8c096101eb";
    buildInputs = [ python3 ];
  };

  "python3-sphinxcontrib-websupport" = fetch {
    name        = "python3-sphinxcontrib-websupport";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-python3-sphinxcontrib-websupport-1.1.0-2-any.pkg.tar.xz";
    sha256      = "62c1c9ee8e9bf907eecd6a5f55f26cfd93d973046c658345eba7b3efa727545e";
    buildInputs = [ python3 ];
  };

  "python3-sqlalchemy" = fetch {
    name        = "python3-sqlalchemy";
    version     = "1.2.15";
    filename    = "mingw-w64-x86_64-python3-sqlalchemy-1.2.15-1-any.pkg.tar.xz";
    sha256      = "966231e2c4438f7550732b264f5d79309c54e59cd1b5e7624286ef6daf722c5f";
    buildInputs = [ python3 ];
  };

  "python3-sqlalchemy-migrate" = fetch {
    name        = "python3-sqlalchemy-migrate";
    version     = "0.11.0";
    filename    = "mingw-w64-x86_64-python3-sqlalchemy-migrate-0.11.0-1-any.pkg.tar.xz";
    sha256      = "8fa34868f68930baa8145865249d8fd0201fd34f046b1d29fe4d65394de10eab";
    buildInputs = [ python3 python3-six python3-pbr python3-sqlalchemy python3-decorator python3-sqlparse python3-tempita ];
  };

  "python3-sqlitedict" = fetch {
    name        = "python3-sqlitedict";
    version     = "1.6.0";
    filename    = "mingw-w64-x86_64-python3-sqlitedict-1.6.0-1-any.pkg.tar.xz";
    sha256      = "a33629a38df55e59348ac96755bd46826e3235763ca105836f797fb2ad5203db";
    buildInputs = [ python3 sqlite3 ];
  };

  "python3-sqlparse" = fetch {
    name        = "python3-sqlparse";
    version     = "0.2.4";
    filename    = "mingw-w64-x86_64-python3-sqlparse-0.2.4-1-any.pkg.tar.xz";
    sha256      = "0d4c29dc58a9ab83f4939f716bd082e13a548e6de213b29e6b41eb5756b7ed81";
    buildInputs = [ python3 ];
  };

  "python3-statsmodels" = fetch {
    name        = "python3-statsmodels";
    version     = "0.9.0";
    filename    = "mingw-w64-x86_64-python3-statsmodels-0.9.0-1-any.pkg.tar.xz";
    sha256      = "33ac6f8ab7959951d6c95652f13c3a637a43ccfcb824a4d5857f573987e5ab3b";
    buildInputs = [ python3-scipy python3-pandas python3-patsy ];
  };

  "python3-stestr" = fetch {
    name        = "python3-stestr";
    version     = "2.2.0";
    filename    = "mingw-w64-x86_64-python3-stestr-2.2.0-1-any.pkg.tar.xz";
    sha256      = "878facc14decf5afe0cb2f58ded3d0e38f8b183521e9d224e46138ae1ec30fed";
    buildInputs = [ python3 python3-cliff python3-fixtures python3-future python3-pbr python3-six python3-subunit python3-testtools python3-voluptuous python3-yaml ];
  };

  "python3-stevedore" = fetch {
    name        = "python3-stevedore";
    version     = "1.30.0";
    filename    = "mingw-w64-x86_64-python3-stevedore-1.30.0-1-any.pkg.tar.xz";
    sha256      = "c224b3ecb727cb25b2138bee9309d564f506e85afbf3bd3a06ba77fc0e8e2292";
    buildInputs = [ python3 python3-six ];
  };

  "python3-strict-rfc3339" = fetch {
    name        = "python3-strict-rfc3339";
    version     = "0.7";
    filename    = "mingw-w64-x86_64-python3-strict-rfc3339-0.7-1-any.pkg.tar.xz";
    sha256      = "1519563e535a9cccc04fa4eb923cdfefd8a9e524b698b2de4e4ca2efada5ce21";
    buildInputs = [ python3 ];
  };

  "python3-subunit" = fetch {
    name        = "python3-subunit";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-python3-subunit-1.3.0-2-any.pkg.tar.xz";
    sha256      = "602e6a38ef59a9f39e0d253d1857b3dfdfc0f8e7f22b814042da74cf5dfd2157";
    buildInputs = [ python3 python3-extras python3-testtools ];
  };

  "python3-sympy" = fetch {
    name        = "python3-sympy";
    version     = "1.3";
    filename    = "mingw-w64-x86_64-python3-sympy-1.3-1-any.pkg.tar.xz";
    sha256      = "9c3bca1a2408041fc4b7dbe92bf680b33e3d7c050a1c721951641b3a0248e4ea";
    buildInputs = [ python3 python3-mpmath ];
  };

  "python3-tempita" = fetch {
    name        = "python3-tempita";
    version     = "0.5.3dev20170202";
    filename    = "mingw-w64-x86_64-python3-tempita-0.5.3dev20170202-1-any.pkg.tar.xz";
    sha256      = "6c0f168ba8a63e2082c853306a66a0d118d277afba2b9e018510b7ee0a83286c";
    buildInputs = [ python3 ];
  };

  "python3-terminado" = fetch {
    name        = "python3-terminado";
    version     = "0.8.1";
    filename    = "mingw-w64-x86_64-python3-terminado-0.8.1-2-any.pkg.tar.xz";
    sha256      = "780b7d9333c124a6d9cdca840be68458fb96b29961bdf50267f24d165bf55052";
    buildInputs = [ python3 python3-tornado python3-ptyprocess ];
  };

  "python3-testpath" = fetch {
    name        = "python3-testpath";
    version     = "0.4.2";
    filename    = "mingw-w64-x86_64-python3-testpath-0.4.2-1-any.pkg.tar.xz";
    sha256      = "33f9d6993e2dc45c4d14a9be55348e283c2b4b59e7b39c15577728ebfd02b5f1";
    buildInputs = [ python3 ];
  };

  "python3-testrepository" = fetch {
    name        = "python3-testrepository";
    version     = "0.0.20";
    filename    = "mingw-w64-x86_64-python3-testrepository-0.0.20-1-any.pkg.tar.xz";
    sha256      = "e82002c7358c489cbc30efd3ce41b41f6bb633075c360e8bf510dcd778e0d675";
    buildInputs = [ python3 ];
  };

  "python3-testresources" = fetch {
    name        = "python3-testresources";
    version     = "2.0.1";
    filename    = "mingw-w64-x86_64-python3-testresources-2.0.1-1-any.pkg.tar.xz";
    sha256      = "6f6f1faf8e0536b980d4b1f208924acc3fcd7c64323d834a15f5dd321cdc6923";
    buildInputs = [ python3 ];
  };

  "python3-testscenarios" = fetch {
    name        = "python3-testscenarios";
    version     = "0.5.0";
    filename    = "mingw-w64-x86_64-python3-testscenarios-0.5.0-1-any.pkg.tar.xz";
    sha256      = "a1faa06e12479d3f1ceb046777c6d2256e677c491e2b3f0d7cd6d3d04e046658";
    buildInputs = [ python3 ];
  };

  "python3-testtools" = fetch {
    name        = "python3-testtools";
    version     = "2.3.0";
    filename    = "mingw-w64-x86_64-python3-testtools-2.3.0-1-any.pkg.tar.xz";
    sha256      = "2bf9c1200a018ecfd4d1580885b7fde1b4c53d1f7da9f8a9ccbb87e390da5ddc";
    buildInputs = [ python3 python3-pbr python3-extras python3-fixtures python3-pyrsistent python3-mimeparse ];
  };

  "python3-text-unidecode" = fetch {
    name        = "python3-text-unidecode";
    version     = "1.2";
    filename    = "mingw-w64-x86_64-python3-text-unidecode-1.2-1-any.pkg.tar.xz";
    sha256      = "d779056d4b829e63512758e6120f80e168ad6328f793d16c015725fd7496024d";
    buildInputs = [ python3 ];
  };

  "python3-toml" = fetch {
    name        = "python3-toml";
    version     = "0.10.0";
    filename    = "mingw-w64-x86_64-python3-toml-0.10.0-1-any.pkg.tar.xz";
    sha256      = "afdeac781053d32d637162d34b7c26850e32cc3bb28a63317c3d478c1016042b";
    buildInputs = [ python3 ];
  };

  "python3-tornado" = fetch {
    name        = "python3-tornado";
    version     = "5.1.1";
    filename    = "mingw-w64-x86_64-python3-tornado-5.1.1-2-any.pkg.tar.xz";
    sha256      = "b2922f291c45885d8878b2401cc2fc03680693f7fa2776ddcb9fbfd1cb3df7c7";
    buildInputs = [ python3 ];
  };

  "python3-tox" = fetch {
    name        = "python3-tox";
    version     = "3.6.1";
    filename    = "mingw-w64-x86_64-python3-tox-3.6.1-1-any.pkg.tar.xz";
    sha256      = "080b81175fe599662da1539f21f019c0c65f38c472a1032302f2cac8e7f1b644";
    buildInputs = [ python3 python3-py python2-six python3-virtualenv python3-setuptools python3-setuptools-scm python3-filelock python3-toml python3-pluggy ];
  };

  "python3-traitlets" = fetch {
    name        = "python3-traitlets";
    version     = "4.3.2";
    filename    = "mingw-w64-x86_64-python3-traitlets-4.3.2-3-any.pkg.tar.xz";
    sha256      = "d564824eb64c23e2e8e7e2f480751fb4e87b6cfa70d6c9a8481b6392c2cf0691";
    buildInputs = [ python3-ipython_genutils python3-decorator ];
  };

  "python3-u-msgpack" = fetch {
    name        = "python3-u-msgpack";
    version     = "2.5.0";
    filename    = "mingw-w64-x86_64-python3-u-msgpack-2.5.0-1-any.pkg.tar.xz";
    sha256      = "1137f4010cb855935fd70735f83a7dc9f35e05b625bd27ec03377cf747ef26f6";
    buildInputs = [ python3 ];
  };

  "python3-udsoncan" = fetch {
    name        = "python3-udsoncan";
    version     = "1.6";
    filename    = "mingw-w64-x86_64-python3-udsoncan-1.6-1-any.pkg.tar.xz";
    sha256      = "f01f97d7977ebdc6f9ee441264cc93c237d1a736b71efc3f9075ee24d6b83997";
    buildInputs = [ python3 ];
  };

  "python3-ukpostcodeparser" = fetch {
    name        = "python3-ukpostcodeparser";
    version     = "1.1.2";
    filename    = "mingw-w64-x86_64-python3-ukpostcodeparser-1.1.2-1-any.pkg.tar.xz";
    sha256      = "12c941dbfbc4dc3a448e4a050c97981f996b88dabed62ae727347d26015a8954";
    buildInputs = [ python3 ];
  };

  "python3-unicorn" = fetch {
    name        = "python3-unicorn";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python3-unicorn-1.0.1-3-any.pkg.tar.xz";
    sha256      = "26a30f533715d268869e7e507651091f38a1d1980315fe3e0fefe946b95841ef";
    buildInputs = [ python3 unicorn ];
  };

  "python3-urllib3" = fetch {
    name        = "python3-urllib3";
    version     = "1.24.1";
    filename    = "mingw-w64-x86_64-python3-urllib3-1.24.1-1-any.pkg.tar.xz";
    sha256      = "1e5210de180a57017faa42c3bda4a40500a8b44fb94fad3d9f0194b0a7f009b6";
    buildInputs = [ python3 python3-certifi python3-idna ];
  };

  "python3-virtualenv" = fetch {
    name        = "python3-virtualenv";
    version     = "16.0.0";
    filename    = "mingw-w64-x86_64-python3-virtualenv-16.0.0-1-any.pkg.tar.xz";
    sha256      = "371dacd65247176da303ad2532cf9286d25bdb42d32621fa45789138c8574d58";
    buildInputs = [ python3 ];
  };

  "python3-voluptuous" = fetch {
    name        = "python3-voluptuous";
    version     = "0.11.5";
    filename    = "mingw-w64-x86_64-python3-voluptuous-0.11.5-1-any.pkg.tar.xz";
    sha256      = "ee7c443b0bd3ea1d8a6b1d3f2f2b9ac319dc17a13c23775794af25713f708721";
    buildInputs = [ python3 ];
  };

  "python3-watchdog" = fetch {
    name        = "python3-watchdog";
    version     = "0.9.0";
    filename    = "mingw-w64-x86_64-python3-watchdog-0.9.0-1-any.pkg.tar.xz";
    sha256      = "33e7bb3bb1a7fc42b04529a82d266609fef08bcedcfbb35bb8bca4dd9e0ec41c";
    buildInputs = [ python3 ];
  };

  "python3-wcwidth" = fetch {
    name        = "python3-wcwidth";
    version     = "0.1.7";
    filename    = "mingw-w64-x86_64-python3-wcwidth-0.1.7-3-any.pkg.tar.xz";
    sha256      = "779bacace0678be461a3430baea652c6972293949697dbddf2cb5001c6d4085f";
    buildInputs = [ python3 ];
  };

  "python3-webcolors" = fetch {
    name        = "python3-webcolors";
    version     = "1.8.1";
    filename    = "mingw-w64-x86_64-python3-webcolors-1.8.1-1-any.pkg.tar.xz";
    sha256      = "5de13daf67621b0ce4b76241f1fa65e006438e70ac380ba234479908c33a9ad0";
    buildInputs = [ python3 ];
  };

  "python3-webencodings" = fetch {
    name        = "python3-webencodings";
    version     = "0.5.1";
    filename    = "mingw-w64-x86_64-python3-webencodings-0.5.1-3-any.pkg.tar.xz";
    sha256      = "fe3d9720712bf105c14ae63e95a69d161901d9595a04b66d300df76ed0b7bf81";
    buildInputs = [ python3 ];
  };

  "python3-websocket-client" = fetch {
    name        = "python3-websocket-client";
    version     = "0.54.0";
    filename    = "mingw-w64-x86_64-python3-websocket-client-0.54.0-2-any.pkg.tar.xz";
    sha256      = "43f71ffcc184b18b11119a30bdd364904b774fdc1c0ce7b584faeffaf92a01a4";
    buildInputs = [ python3 python3-six ];
  };

  "python3-wheel" = fetch {
    name        = "python3-wheel";
    version     = "0.32.3";
    filename    = "mingw-w64-x86_64-python3-wheel-0.32.3-1-any.pkg.tar.xz";
    sha256      = "80e9698ef47e654049e87d93a0e00cc628a68a3761b4df08ebd50568164e3704";
    buildInputs = [ python3 ];
  };

  "python3-whoosh" = fetch {
    name        = "python3-whoosh";
    version     = "2.7.4";
    filename    = "mingw-w64-x86_64-python3-whoosh-2.7.4-2-any.pkg.tar.xz";
    sha256      = "5b0ec0c9d28cc213d264cacfb421bf17a01a6101d89cff20b7f1c87768afed3e";
    buildInputs = [ python3 ];
  };

  "python3-win_inet_pton" = fetch {
    name        = "python3-win_inet_pton";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-python3-win_inet_pton-1.0.1-1-any.pkg.tar.xz";
    sha256      = "293f670034c9fbe52882dcad5db88bfdf9e1e1ab7d57fa5699adf808664f060b";
    buildInputs = [ python3 ];
  };

  "python3-win_unicode_console" = fetch {
    name        = "python3-win_unicode_console";
    version     = "0.5";
    filename    = "mingw-w64-x86_64-python3-win_unicode_console-0.5-3-any.pkg.tar.xz";
    sha256      = "b32488c889c9f3297771b78f366a17f10d6f34c1acd57ca17ba8988db051a96c";
    buildInputs = [ python3 ];
  };

  "python3-wincertstore" = fetch {
    name        = "python3-wincertstore";
    version     = "0.2";
    filename    = "mingw-w64-x86_64-python3-wincertstore-0.2-1-any.pkg.tar.xz";
    sha256      = "444ca13387b9c0e344ff13b72a2e6b825c74ee7b70c1321e146c188ea7590d92";
    buildInputs = [ python3 ];
  };

  "python3-winkerberos" = fetch {
    name        = "python3-winkerberos";
    version     = "0.7.0";
    filename    = "mingw-w64-x86_64-python3-winkerberos-0.7.0-1-any.pkg.tar.xz";
    sha256      = "19d145403e91e07c4d0c8da34fb407897c3e5d88ab2863d6094fdaf2b3fbc347";
    buildInputs = [ python3 ];
  };

  "python3-wrapt" = fetch {
    name        = "python3-wrapt";
    version     = "1.10.11";
    filename    = "mingw-w64-x86_64-python3-wrapt-1.10.11-3-any.pkg.tar.xz";
    sha256      = "434be59c0601d0e7c7c29479d3b8f0123f89435be935fdedb057cdbd41cff448";
    buildInputs = [ python3 ];
  };

  "python3-xdg" = fetch {
    name        = "python3-xdg";
    version     = "0.26";
    filename    = "mingw-w64-x86_64-python3-xdg-0.26-2-any.pkg.tar.xz";
    sha256      = "3f2f36a3fc3473213dc768e2cf6872093feb0b5f81006cb84c5132ce08edfc16";
    buildInputs = [ python3 ];
  };

  "python3-xlrd" = fetch {
    name        = "python3-xlrd";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-python3-xlrd-1.2.0-1-any.pkg.tar.xz";
    sha256      = "72eb1da5703b8361fa149b0a2c656e22137de51503c624264f5ec17aec4a2fa9";
    buildInputs = [ python3 ];
  };

  "python3-xlsxwriter" = fetch {
    name        = "python3-xlsxwriter";
    version     = "1.1.1";
    filename    = "mingw-w64-x86_64-python3-xlsxwriter-1.1.1-1-any.pkg.tar.xz";
    sha256      = "e1f1c5471563530ea67a85e8162e442ae607bc2af3f35762bfa453efb14cbd97";
    buildInputs = [ python3 ];
  };

  "python3-xlwt" = fetch {
    name        = "python3-xlwt";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-python3-xlwt-1.3.0-1-any.pkg.tar.xz";
    sha256      = "89287a869da5b60303bc3447d697097694d2624f7132337074230c8d5c4cbecd";
    buildInputs = [ python3 ];
  };

  "python3-yaml" = fetch {
    name        = "python3-yaml";
    version     = "3.13";
    filename    = "mingw-w64-x86_64-python3-yaml-3.13-1-any.pkg.tar.xz";
    sha256      = "d60666ff8dd46dd661c95b661a7252ae5157e240c66e463e861f091b43ef7ddb";
    buildInputs = [ python3 libyaml ];
  };

  "python3-zeroconf" = fetch {
    name        = "python3-zeroconf";
    version     = "0.21.3";
    filename    = "mingw-w64-x86_64-python3-zeroconf-0.21.3-2-any.pkg.tar.xz";
    sha256      = "dd1258f7bedf6d0314aa6a21974f1217474bfcf8a6d99807a3eed58a79bfa2e1";
    buildInputs = [ python3 python3-ifaddr ];
  };

  "python3-zope.event" = fetch {
    name        = "python3-zope.event";
    version     = "4.4";
    filename    = "mingw-w64-x86_64-python3-zope.event-4.4-1-any.pkg.tar.xz";
    sha256      = "aac73e3ca336b1d529484a24a6fa668a4672cb81a8b2d7d116a74077c8d212d9";
  };

  "python3-zope.interface" = fetch {
    name        = "python3-zope.interface";
    version     = "4.6.0";
    filename    = "mingw-w64-x86_64-python3-zope.interface-4.6.0-1-any.pkg.tar.xz";
    sha256      = "64c75e23b719d3308178939540de7b31e6084b605855f6325f00a232f73fcc75";
  };

  "qbittorrent" = fetch {
    name        = "qbittorrent";
    version     = "4.1.5";
    filename    = "mingw-w64-x86_64-qbittorrent-4.1.5-1-any.pkg.tar.xz";
    sha256      = "eba47d852070da3ffb2583cb06dc9d0a6f11a2e56fe43459e5f818da14106e18";
    buildInputs = [ boost qt5 libtorrent-rasterbar zlib ];
    broken      = true;
  };

  "qbs" = fetch {
    name        = "qbs";
    version     = "1.12.2";
    filename    = "mingw-w64-x86_64-qbs-1.12.2-1-any.pkg.tar.xz";
    sha256      = "26700a89396140f9db5cebef9dd820de9442925d8b64466e0e183eee45aef076";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "qca-qt4-git" = fetch {
    name        = "qca-qt4-git";
    version     = "2220.66b9754";
    filename    = "mingw-w64-x86_64-qca-qt4-git-2220.66b9754-1-any.pkg.tar.xz";
    sha256      = "64b1950fc7714da1b24bf6d6eed938c36321d9eef32fdd275ca92a396bf3ea9c";
    buildInputs = [ ca-certificates cyrus-sasl doxygen gnupg libgcrypt nss openssl qt4 ];
  };

  "qca-qt5-git" = fetch {
    name        = "qca-qt5-git";
    version     = "2277.98eead0";
    filename    = "mingw-w64-x86_64-qca-qt5-git-2277.98eead0-1-any.pkg.tar.xz";
    sha256      = "592d612866d67f6bc0555d0608b067dfe8f7a6241b3ba660a00415a9cfa948a9";
    buildInputs = [ ca-certificates cyrus-sasl doxygen gnupg libgcrypt nss openssl qt5 ];
    broken      = true;
  };

  "qemu" = fetch {
    name        = "qemu";
    version     = "3.1.0";
    filename    = "mingw-w64-x86_64-qemu-3.1.0-1-any.pkg.tar.xz";
    sha256      = "dbdc094f2c6d7e834c431f92189bc61ff91b83d5e5653906ab6ac004a29bc8b7";
    buildInputs = [ capstone curl cyrus-sasl glib2 gnutls gtk3 libjpeg libpng libssh2 libusb lzo2 pixman snappy SDL2 usbredir ];
    broken      = true;
  };

  "qhttpengine" = fetch {
    name        = "qhttpengine";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-qhttpengine-1.0.1-1-any.pkg.tar.xz";
    sha256      = "85ec8eb589999175786e8bddab1831c61b24ff4864f7da0377e69cba6ea78b83";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast qt5.version "5.4"; qt5) ];
    broken      = true;
  };

  "qhull-git" = fetch {
    name        = "qhull-git";
    version     = "r166.f1f8b42";
    filename    = "mingw-w64-x86_64-qhull-git-r166.f1f8b42-1-any.pkg.tar.xz";
    sha256      = "60e8b543958eb058e6140a8c04e16c871747e6ed01e188b45a7ba49804f9aafd";
    buildInputs = [ gcc-libs ];
  };

  "qjson-qt4" = fetch {
    name        = "qjson-qt4";
    version     = "0.8.1";
    filename    = "mingw-w64-x86_64-qjson-qt4-0.8.1-3-any.pkg.tar.xz";
    sha256      = "64afa6c1f63f50e1a815037f928e6235ae0e324abd0d45fd1dc819f860cd91e5";
    buildInputs = [ qt4 ];
  };

  "qmdnsengine" = fetch {
    name        = "qmdnsengine";
    version     = "0.1.0";
    filename    = "mingw-w64-x86_64-qmdnsengine-0.1.0-1-any.pkg.tar.xz";
    sha256      = "17432b651fb1889cb5f03e96b34932f6f4b236b1589d0f2a44a0d47b7fa46fd6";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast qt5.version "5.4"; qt5) ];
    broken      = true;
  };

  "qpdf" = fetch {
    name        = "qpdf";
    version     = "8.2.1";
    filename    = "mingw-w64-x86_64-qpdf-8.2.1-1-any.pkg.tar.xz";
    sha256      = "e72544b52f06d3305a3240fa73e91c42fd166a914f75d561194c4ad1afc011ad";
    buildInputs = [ gcc-libs libjpeg pcre zlib ];
  };

  "qrencode" = fetch {
    name        = "qrencode";
    version     = "4.0.2";
    filename    = "mingw-w64-x86_64-qrencode-4.0.2-1-any.pkg.tar.xz";
    sha256      = "5f323f9946b8e378963605b951f76a3f70eda438d22492aef6c42a6aa6a2c33e";
    buildInputs = [ libpng ];
  };

  "qrupdate-svn" = fetch {
    name        = "qrupdate-svn";
    version     = "r28";
    filename    = "mingw-w64-x86_64-qrupdate-svn-r28-4-any.pkg.tar.xz";
    sha256      = "48d36076f5948b30c6b44d18d3b4eac62fd3a7bd3790daf79ec99165018d657b";
    buildInputs = [ openblas ];
  };

  "qscintilla" = fetch {
    name        = "qscintilla";
    version     = "2.10.8";
    filename    = "mingw-w64-x86_64-qscintilla-2.10.8-1-any.pkg.tar.xz";
    sha256      = "bbc270a6a0073c744a5ff9b0d97c8ba1ef595ce66f48f60a648cd9160d6a2967";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "qt-creator" = fetch {
    name        = "qt-creator";
    version     = "4.8.0";
    filename    = "mingw-w64-x86_64-qt-creator-4.8.0-1-any.pkg.tar.xz";
    sha256      = "14eb3bf61a3f4cf157a8ac29f8290e9e07fe93ecfc7781004bf32437c3432cd7";
    buildInputs = [ qt5 gcc make qbs ];
    broken      = true;
  };

  "qt-installer-framework-git" = fetch {
    name        = "qt-installer-framework-git";
    version     = "r3068.55c191ed";
    filename    = "mingw-w64-x86_64-qt-installer-framework-git-r3068.55c191ed-1-any.pkg.tar.xz";
    sha256      = "1c82a0dc844530e3c203cedab29828624278cd0165c182a42327b28178a1c613";
  };

  "qt4" = fetch {
    name        = "qt4";
    version     = "4.8.7";
    filename    = "mingw-w64-x86_64-qt4-4.8.7-4-any.pkg.tar.xz";
    sha256      = "6424a5c22d340c8511758cb4f1f2a194daad43f7d8074d060bb2d4cc10563499";
    buildInputs = [ gcc-libs dbus fontconfig freetype libiconv libjpeg libmng libpng libtiff libwebp libxml2 libxslt openssl pcre qtbinpatcher sqlite3 zlib ];
  };

  "qt5" = fetch {
    name        = "qt5";
    version     = "5.12.0";
    filename    = "mingw-w64-x86_64-qt5-5.12.0-1-any.pkg.tar.xz";
    sha256      = "80911cdabf3bd9a2f1fecb3970286d346f42804f0149fe2ae4882b16256204fd";
    buildInputs = [ gcc-libs qtbinpatcher z3 assimp dbus fontconfig freetype harfbuzz jasper libjpeg libmng libpng libtiff libxml2 libxslt libwebp openssl openal pcre2 sqlite3 vulkan xpm-nox zlib icu icu-debug-libs ];
    broken      = true;
  };

  "qt5-static" = fetch {
    name        = "qt5-static";
    version     = "5.12.0";
    filename    = "mingw-w64-x86_64-qt5-static-5.12.0-1-any.pkg.tar.xz";
    sha256      = "c26e5e382782288f9533e9edbe29d9c60016f093aae93d4b9e567f17186d92be";
    buildInputs = [ gcc-libs qtbinpatcher z3 icu icu-debug-libs ];
  };

  "qtbinpatcher" = fetch {
    name        = "qtbinpatcher";
    version     = "2.2.0";
    filename    = "mingw-w64-x86_64-qtbinpatcher-2.2.0-2-any.pkg.tar.xz";
    sha256      = "8928b2f45dc5d7eeef40432c6be0b52201d207376b8cd416c3af3b1cf7ab16a7";
    buildInputs = [  ];
  };

  "qtwebkit" = fetch {
    name        = "qtwebkit";
    version     = "5.212.0alpha2";
    filename    = "mingw-w64-x86_64-qtwebkit-5.212.0alpha2-5-any.pkg.tar.xz";
    sha256      = "79b49063e6fdd0ecdc10a7bc82ddce2e2b5779b459e8a3f0a1e269b3137bbe1e";
    buildInputs = [ icu libxml2 libxslt libwebp fontconfig sqlite3 qt5 ];
    broken      = true;
  };

  "quantlib" = fetch {
    name        = "quantlib";
    version     = "1.14";
    filename    = "mingw-w64-x86_64-quantlib-1.14-1-any.pkg.tar.xz";
    sha256      = "79790f6ae57384677cc509397dba798ff456d6fe06128ec4d37a35cce26ce106";
    buildInputs = [ boost ];
  };

  "quarter-hg" = fetch {
    name        = "quarter-hg";
    version     = "r507+.4040ac7a14cf+";
    filename    = "mingw-w64-x86_64-quarter-hg-r507+.4040ac7a14cf+-1-any.pkg.tar.xz";
    sha256      = "d5e10f2d00572e8e593dc2d739ba8f1587c714ee3e5fb68bf9e22497555f6847";
    buildInputs = [ qt5 coin3d ];
    broken      = true;
  };

  "quassel" = fetch {
    name        = "quassel";
    version     = "0.13.0";
    filename    = "mingw-w64-x86_64-quassel-0.13.0-1-any.pkg.tar.xz";
    sha256      = "d76fb509e751f7b8a78bbb07e6fbdfc3e514e65261096babd7ebec61a219d27a";
    buildInputs = [ qt5 qca-qt5-git Snorenotify ];
    broken      = true;
  };

  "quazip" = fetch {
    name        = "quazip";
    version     = "0.7.6";
    filename    = "mingw-w64-x86_64-quazip-0.7.6-1-any.pkg.tar.xz";
    sha256      = "6c53b02b8295988b662668a98b352e0ec23a9320e8148776e9e930b804e4ab59";
    buildInputs = [ qt5 zlib ];
    broken      = true;
  };

  "qwt-qt4" = fetch {
    name        = "qwt-qt4";
    version     = "6.1.2";
    filename    = "mingw-w64-x86_64-qwt-qt4-6.1.2-2-any.pkg.tar.xz";
    sha256      = "85cb96249d53db4646cd91d737e0af0b58548a13ba667f7eb73c88b8055083b9";
    buildInputs = [ qt4 ];
  };

  "qwt-qt5" = fetch {
    name        = "qwt-qt5";
    version     = "6.1.3";
    filename    = "mingw-w64-x86_64-qwt-qt5-6.1.3-1-any.pkg.tar.xz";
    sha256      = "4b22367506dd5fc874cdab9ab190a64a55e7787d58236375a873db2528119fe5";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "qxmpp" = fetch {
    name        = "qxmpp";
    version     = "0.9.3";
    filename    = "mingw-w64-x86_64-qxmpp-0.9.3-1-any.pkg.tar.xz";
    sha256      = "fa1ffd347d2c9ea60661e90ec91a92ddfaf19e663a9cc2933afaf9e346e1b40e";
    buildInputs = [ libtheora libvpx qt5 speex ];
    broken      = true;
  };

  "qxmpp-qt4" = fetch {
    name        = "qxmpp-qt4";
    version     = "0.8.3";
    filename    = "mingw-w64-x86_64-qxmpp-qt4-0.8.3-2-any.pkg.tar.xz";
    sha256      = "0adce6a3a0df620c4fc1a7b83b8c1e6e64a913b59bd54c3f3193e79060af24b3";
    buildInputs = [ libtheora libvpx qt4 speex ];
  };

  "rabbitmq-c" = fetch {
    name        = "rabbitmq-c";
    version     = "0.9.0";
    filename    = "mingw-w64-x86_64-rabbitmq-c-0.9.0-2-any.pkg.tar.xz";
    sha256      = "b16b6363b862801c0416b11058643f7252d8e11ed9933f9fa3bb5b7a601d67e7";
    buildInputs = [ openssl popt ];
  };

  "ragel" = fetch {
    name        = "ragel";
    version     = "6.10";
    filename    = "mingw-w64-x86_64-ragel-6.10-1-any.pkg.tar.xz";
    sha256      = "cb1b15a4f9641918b43eb7de102783c05fc59f9356d12237e6df5f9ba581d5a4";
    buildInputs = [ gcc-libs ];
  };

  "rapidjson" = fetch {
    name        = "rapidjson";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-rapidjson-1.1.0-1-any.pkg.tar.xz";
    sha256      = "88601accebe5aad409921017906b45671e3117d89a5da9dcb3fade22bdedfdcd";
  };

  "readline" = fetch {
    name        = "readline";
    version     = "7.0.005";
    filename    = "mingw-w64-x86_64-readline-7.0.005-1-any.pkg.tar.xz";
    sha256      = "26b2f1524ab2c4980dfbfc030b7cdc30b2e33f20ada71780ba735f4acdc259cc";
    buildInputs = [ gcc-libs termcap ];
  };

  "readosm" = fetch {
    name        = "readosm";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-readosm-1.1.0-1-any.pkg.tar.xz";
    sha256      = "fac19b5c612b4aeb68d4b8d8252ee5ff1dbd377bd82bdc37fccf67a06ed588e0";
    buildInputs = [ expat zlib ];
  };

  "recode" = fetch {
    name        = "recode";
    version     = "3.7.1";
    filename    = "mingw-w64-x86_64-recode-3.7.1-1-any.pkg.tar.xz";
    sha256      = "5959300d71a01698539204138f82353904552ab4a2e5d004d3d222b7fbfb9e67";
    buildInputs = [ gettext ];
  };

  "rhash" = fetch {
    name        = "rhash";
    version     = "1.3.6";
    filename    = "mingw-w64-x86_64-rhash-1.3.6-2-any.pkg.tar.xz";
    sha256      = "566620fdb3e3f9212c1ad0c146c6fb3faca8f7199b7ec65d46fc76f23cc71d3f";
    buildInputs = [ gettext ];
  };

  "rocksdb" = fetch {
    name        = "rocksdb";
    version     = "5.17.2";
    filename    = "mingw-w64-x86_64-rocksdb-5.17.2-1-any.pkg.tar.xz";
    sha256      = "14ab6e4cce8fbb890f70abb9ddc7223ec713a32b1f2d732d40268fbd84826676";
    buildInputs = [ bzip2 intel-tbb lz4 snappy zlib ];
  };

  "rtmpdump-git" = fetch {
    name        = "rtmpdump-git";
    version     = "r512.fa8646d";
    filename    = "mingw-w64-x86_64-rtmpdump-git-r512.fa8646d-3-any.pkg.tar.xz";
    sha256      = "e274737342ff62089cd13d05b8f31e57e2bf2e7a1784945af26e206b3b10156d";
    buildInputs = [ gcc-libs gmp gnutls nettle zlib ];
  };

  "rubberband" = fetch {
    name        = "rubberband";
    version     = "1.8.2";
    filename    = "mingw-w64-x86_64-rubberband-1.8.2-1-any.pkg.tar.xz";
    sha256      = "7fedf082c309663468c4ea01c4872aa70bdb288409763d08d24151e3f510104e";
    buildInputs = [ gcc-libs fftw libsamplerate libsndfile ladspa-sdk vamp-plugin-sdk ];
  };

  "ruby" = fetch {
    name        = "ruby";
    version     = "2.6.0";
    filename    = "mingw-w64-x86_64-ruby-2.6.0-1-any.pkg.tar.xz";
    sha256      = "71e45e48ffd878ff951357c0dcdf4d32c90711c535502942f07c6bc14872ae93";
    buildInputs = [ gcc-libs gdbm libyaml libffi ncurses openssl tk ];
  };

  "ruby-cairo" = fetch {
    name        = "ruby-cairo";
    version     = "1.16.2";
    filename    = "mingw-w64-x86_64-ruby-cairo-1.16.2-1-any.pkg.tar.xz";
    sha256      = "c911094a1c1529960f4bbc876029ff838d7a94fd0766de3a9a49b8a4928e08f4";
    buildInputs = [ ruby cairo ruby-pkg-config ];
  };

  "ruby-dbus" = fetch {
    name        = "ruby-dbus";
    version     = "0.15.0";
    filename    = "mingw-w64-x86_64-ruby-dbus-0.15.0-1-any.pkg.tar.xz";
    sha256      = "c92df9778ce73380f4ba675a25396abda1721e34c90f2d7a931fd4841411cbe9";
    buildInputs = [ ruby ];
  };

  "ruby-native-package-installer" = fetch {
    name        = "ruby-native-package-installer";
    version     = "1.0.6";
    filename    = "mingw-w64-x86_64-ruby-native-package-installer-1.0.6-1-any.pkg.tar.xz";
    sha256      = "cfdd22271834296c11c72d9122854ac729b062da6d8961c47a6455ffd46c1028";
    buildInputs = [ ruby ];
  };

  "ruby-pkg-config" = fetch {
    name        = "ruby-pkg-config";
    version     = "1.3.1";
    filename    = "mingw-w64-x86_64-ruby-pkg-config-1.3.1-1-any.pkg.tar.xz";
    sha256      = "1833042ec571d8c9e8aadbe293e509bb14c8c7b0263aad3ec3f4f8720980c8ee";
    buildInputs = [ ruby ];
  };

  "rust" = fetch {
    name        = "rust";
    version     = "1.29.2";
    filename    = "mingw-w64-x86_64-rust-1.29.2-1-any.pkg.tar.xz";
    sha256      = "df7dbe0568810a7486244be94a74010ba95fd8e0626b5791b18ae18608be6f99";
    buildInputs = [ gcc ];
  };

  "rxspencer" = fetch {
    name        = "rxspencer";
    version     = "alpha3.8.g7";
    filename    = "mingw-w64-x86_64-rxspencer-alpha3.8.g7-1-any.pkg.tar.xz";
    sha256      = "675891521f3c3b45be7cc0278b336000566bb22c5d099b09d9f1df39475bf565";
  };

  "sassc" = fetch {
    name        = "sassc";
    version     = "3.5.0";
    filename    = "mingw-w64-x86_64-sassc-3.5.0-1-any.pkg.tar.xz";
    sha256      = "7691ba90d6505387116f1eaba3ad32a4cca65e8c9d2dd38cb8994de536871440";
    buildInputs = [ libsass ];
  };

  "schroedinger" = fetch {
    name        = "schroedinger";
    version     = "1.0.11";
    filename    = "mingw-w64-x86_64-schroedinger-1.0.11-4-any.pkg.tar.xz";
    sha256      = "36c9ec335ec5f1d7152722d5ec3992928c4e83d218e4f269fee048cb868bd14b";
    buildInputs = [ orc ];
  };

  "scite" = fetch {
    name        = "scite";
    version     = "4.1.2";
    filename    = "mingw-w64-x86_64-scite-4.1.2-1-any.pkg.tar.xz";
    sha256      = "e025ef25f3ed8273c8fa6ec6597b0f56bd69fde7c54ed50fb4329dd7fa008189";
    buildInputs = [ glib2 gtk3 ];
  };

  "scite-defaults" = fetch {
    name        = "scite-defaults";
    version     = "4.1.2";
    filename    = "mingw-w64-x86_64-scite-defaults-4.1.2-1-any.pkg.tar.xz";
    sha256      = "82afbbd2459f97358b89be3e19bcbe6f78bca3ffc5fd1c0e393a10287cca7c41";
    buildInputs = [ (assert scite.version=="4.1.2"; scite) ];
  };

  "scummvm" = fetch {
    name        = "scummvm";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-scummvm-2.0.0-1-any.pkg.tar.xz";
    sha256      = "fb1c75a74ff7d045acebee1045831727c286afb9d50922c6a68b3ab3ca941b4a";
    buildInputs = [ faad2 freetype flac fluidsynth libjpeg-turbo libogg libvorbis libmad libmpeg2-git libtheora libpng nasm readline SDL2 zlib ];
    broken      = true;
  };

  "seexpr" = fetch {
    name        = "seexpr";
    version     = "2.11";
    filename    = "mingw-w64-x86_64-seexpr-2.11-1-any.pkg.tar.xz";
    sha256      = "da188b1e37aefb980076413037fb9a2764a96982379325b7ae8364e6aba10d96";
    buildInputs = [ gcc-libs ];
  };

  "sfml" = fetch {
    name        = "sfml";
    version     = "2.5.1";
    filename    = "mingw-w64-x86_64-sfml-2.5.1-2-any.pkg.tar.xz";
    sha256      = "9b9f6567907d819df307d4f38ec8f3be9011f6523481061462d630af38b651ee";
    buildInputs = [ flac freetype libjpeg libvorbis openal ];
  };

  "sgml-common" = fetch {
    name        = "sgml-common";
    version     = "0.6.3";
    filename    = "mingw-w64-x86_64-sgml-common-0.6.3-1-any.pkg.tar.xz";
    sha256      = "40cfc54553a753e4ea0ed002d0193a94b337f38c13de19629b3fdc179ab44fdc";
    buildInputs = [ sh ];
  };

  "shapelib" = fetch {
    name        = "shapelib";
    version     = "1.4.1";
    filename    = "mingw-w64-x86_64-shapelib-1.4.1-1-any.pkg.tar.xz";
    sha256      = "e02d5bd049e9fd7e4b0ac655bb2c92ee3d1864c417125b64bf13c4f1d1f6b099";
    buildInputs = [ gcc-libs proj ];
  };

  "shared-mime-info" = fetch {
    name        = "shared-mime-info";
    version     = "1.10";
    filename    = "mingw-w64-x86_64-shared-mime-info-1.10-1-any.pkg.tar.xz";
    sha256      = "1a175ebc4488795774eee6b067e8972863b9f3e7bda02a95628e789bbbcc9e94";
    buildInputs = [ libxml2 glib2 ];
  };

  "shiboken-qt4" = fetch {
    name        = "shiboken-qt4";
    version     = "1.2.2";
    filename    = "mingw-w64-x86_64-shiboken-qt4-1.2.2-3-any.pkg.tar.xz";
    sha256      = "8361ca72bf6d93d3d6f1ab240215d0448d162017fe9f4ce6d9ec789ab3f5949e";
    buildInputs = [  ];
  };

  "shine" = fetch {
    name        = "shine";
    version     = "3.1.1";
    filename    = "mingw-w64-x86_64-shine-3.1.1-1-any.pkg.tar.xz";
    sha256      = "ee4fbc2f467bd7b022d24af6e9c33267b9a929e9613fe2b0cc6d9b37d9578450";
  };

  "shishi-git" = fetch {
    name        = "shishi-git";
    version     = "r3586.07f8ed3d";
    filename    = "mingw-w64-x86_64-shishi-git-r3586.07f8ed3d-1-any.pkg.tar.xz";
    sha256      = "ed99e9adc9403e968b5d9bfca557f9836bd1fa74b9be8ff5b478f8464fd3ba14";
    buildInputs = [ gnutls libidn libgcrypt libgpg-error libtasn1 ];
  };

  "silc-toolkit" = fetch {
    name        = "silc-toolkit";
    version     = "1.1.12";
    filename    = "mingw-w64-x86_64-silc-toolkit-1.1.12-3-any.pkg.tar.xz";
    sha256      = "f67c238e7c0b8c842d9130f1683e281da154b419304d92a04fe5c2ab3b49a884";
    buildInputs = [ libsystre ];
  };

  "simage-hg" = fetch {
    name        = "simage-hg";
    version     = "r748+.194ff9c6293e+";
    filename    = "mingw-w64-x86_64-simage-hg-r748+.194ff9c6293e+-1-any.pkg.tar.xz";
    sha256      = "21302c21fe906b2eadce97fbdb24ead67cbcb7cbedfa65fe5ddcbef2cd50da5f";
    buildInputs = [ giflib jasper libjpeg-turbo libpng libsndfile libtiff libvorbis qt5 zlib ];
    broken      = true;
  };

  "sip" = fetch {
    name        = "sip";
    version     = "4.19.13";
    filename    = "mingw-w64-x86_64-sip-4.19.13-2-any.pkg.tar.xz";
    sha256      = "0bc96e8a15481b2f3d81c3fa55047d05b13cfab696d1196daf2f19130a3e836f";
    buildInputs = [ gcc-libs ];
  };

  "smpeg" = fetch {
    name        = "smpeg";
    version     = "0.4.5";
    filename    = "mingw-w64-x86_64-smpeg-0.4.5-2-any.pkg.tar.xz";
    sha256      = "35a6400d6cba68466d1160d857176c54a279de74b8d228c561097118808c4db1";
    buildInputs = [ gcc-libs SDL ];
  };

  "smpeg2" = fetch {
    name        = "smpeg2";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-smpeg2-2.0.0-5-any.pkg.tar.xz";
    sha256      = "35f4c47d798239183e65716cc180d1d284462e7604481dc0a4b79a7a484a0dc5";
    buildInputs = [ gcc-libs SDL2 ];
    broken      = true;
  };

  "snappy" = fetch {
    name        = "snappy";
    version     = "1.1.7";
    filename    = "mingw-w64-x86_64-snappy-1.1.7-1-any.pkg.tar.xz";
    sha256      = "bff3d7c4d739327d9f091dd29a8a8376920e6ea9773b8e73a27f015729d5cea3";
    buildInputs = [ gcc-libs ];
  };

  "snoregrowl" = fetch {
    name        = "snoregrowl";
    version     = "0.5.0";
    filename    = "mingw-w64-x86_64-snoregrowl-0.5.0-1-any.pkg.tar.xz";
    sha256      = "3593720b9766119642638304f700698246ecbb9cea1529d1807fa5ecd2f39872";
  };

  "snorenotify" = fetch {
    name        = "snorenotify";
    version     = "0.7.0";
    filename    = "mingw-w64-x86_64-snorenotify-0.7.0-2-any.pkg.tar.xz";
    sha256      = "ade7590fbafae84f89d420650b7ce6dd0fa192f67e13892344c558a0981cbe78";
    buildInputs = [ qt5 snoregrowl ];
    broken      = true;
  };

  "soci" = fetch {
    name        = "soci";
    version     = "3.2.3";
    filename    = "mingw-w64-x86_64-soci-3.2.3-1-any.pkg.tar.xz";
    sha256      = "7bf58fd32d369008f86e8805073f382f74939cbf205643aa0bfa73060add95c3";
    buildInputs = [ boost ];
  };

  "solid-qt5" = fetch {
    name        = "solid-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-solid-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "d7edcfda2e1a07b39c0d6b431586d742771e1a5a794c6286b434ec6bc73b23f8";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "sonnet-qt5" = fetch {
    name        = "sonnet-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-sonnet-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "b142351b514e4c72f89c1228ff918867d1e3e5c5a912df8c11f7b7af4abf7af4";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "soqt-hg" = fetch {
    name        = "soqt-hg";
    version     = "r1962+.6719cfeef271+";
    filename    = "mingw-w64-x86_64-soqt-hg-r1962+.6719cfeef271+-1-any.pkg.tar.xz";
    sha256      = "2b4da0bf8006b8d9321ec9055e923dd5c7138a66437d94b7519f9b171382cbda";
    buildInputs = [ coin3d qt5 ];
    broken      = true;
  };

  "soundtouch" = fetch {
    name        = "soundtouch";
    version     = "2.1.2";
    filename    = "mingw-w64-x86_64-soundtouch-2.1.2-1-any.pkg.tar.xz";
    sha256      = "7c3ea97a184f62b0b87c7730d82eac4831a6bfb6ca1e39a1aa94153b697988ce";
    buildInputs = [ gcc-libs ];
  };

  "source-highlight" = fetch {
    name        = "source-highlight";
    version     = "3.1.8";
    filename    = "mingw-w64-x86_64-source-highlight-3.1.8-1-any.pkg.tar.xz";
    sha256      = "90be2c6ac3f9c21c95250acd6cf6ebb727de003750c9ce8a386a73e177297c0e";
    buildInputs = [ bash boost ];
    broken      = true;
  };

  "sparsehash" = fetch {
    name        = "sparsehash";
    version     = "2.0.3";
    filename    = "mingw-w64-x86_64-sparsehash-2.0.3-1-any.pkg.tar.xz";
    sha256      = "15eadd6bd9b735cdea8ca20b958362617366034a651ff28c659977805483781d";
  };

  "spatialite-tools" = fetch {
    name        = "spatialite-tools";
    version     = "4.3.0";
    filename    = "mingw-w64-x86_64-spatialite-tools-4.3.0-2-any.pkg.tar.xz";
    sha256      = "f7ddd7ace65c9f62c19c16ff45185a7c8dfa572795c8145ca498e33a7c0eea43";
    buildInputs = [ libspatialite readosm libiconv ];
  };

  "spdylay" = fetch {
    name        = "spdylay";
    version     = "1.4.0";
    filename    = "mingw-w64-x86_64-spdylay-1.4.0-1-any.pkg.tar.xz";
    sha256      = "549dfbecb06dd6f8294f28577c0c5d3cbed147242892662e08d66a2d953a8fa0";
  };

  "speex" = fetch {
    name        = "speex";
    version     = "1.2.0";
    filename    = "mingw-w64-x86_64-speex-1.2.0-1-any.pkg.tar.xz";
    sha256      = "51d8869f9cb04cdcfb89d3220562411fdb0ddd4ec0c583a174a1dede183933b9";
    buildInputs = [ libogg speexdsp ];
  };

  "speexdsp" = fetch {
    name        = "speexdsp";
    version     = "1.2rc3";
    filename    = "mingw-w64-x86_64-speexdsp-1.2rc3-3-any.pkg.tar.xz";
    sha256      = "9c7966adf8a4eb86973a9df27201cf4423e04269e2f7a141fcec205ba7fa3080";
    buildInputs = [ gcc-libs ];
  };

  "spice-gtk" = fetch {
    name        = "spice-gtk";
    version     = "0.35";
    filename    = "mingw-w64-x86_64-spice-gtk-0.35-3-any.pkg.tar.xz";
    sha256      = "0886d66c751d9dd822ce4b7f51d50cca269c07c2a46e03a2b6769aa59568e922";
    buildInputs = [ cyrus-sasl dbus-glib gobject-introspection gstreamer gst-plugins-base gtk3 libjpeg-turbo lz4 openssl phodav pixman spice-protocol usbredir vala ];
    broken      = true;
  };

  "spice-protocol" = fetch {
    name        = "spice-protocol";
    version     = "0.12.14";
    filename    = "mingw-w64-x86_64-spice-protocol-0.12.14-1-any.pkg.tar.xz";
    sha256      = "2147bf2dd5241952f02b6c315c135f30056922f5b21237f692e97c8959675f3f";
  };

  "spirv-tools" = fetch {
    name        = "spirv-tools";
    version     = "2018.6";
    filename    = "mingw-w64-x86_64-spirv-tools-2018.6-1-any.pkg.tar.xz";
    sha256      = "93899aeb9a2eec53ae1c2c90da0d533beb4ae715a6903c3d2551c4a4b039381a";
    buildInputs = [ gcc-libs ];
  };

  "sqlcipher" = fetch {
    name        = "sqlcipher";
    version     = "4.0.1";
    filename    = "mingw-w64-x86_64-sqlcipher-4.0.1-1-any.pkg.tar.xz";
    sha256      = "cf47e6ae6be35f6f6bfea237dd7fa1b5ee87ae1fb427ed5b930760ee3ab27825";
    buildInputs = [ gcc-libs openssl readline ];
  };

  "sqlheavy" = fetch {
    name        = "sqlheavy";
    version     = "0.1.1";
    filename    = "mingw-w64-x86_64-sqlheavy-0.1.1-2-any.pkg.tar.xz";
    sha256      = "8a1f6f62fdd1bf0183ac236d9ad52c63cb538393c519a65885f45aa269996978";
    buildInputs = [ gtk2 sqlite3 vala libxml2 ];
  };

  "sqlite-analyzer" = fetch {
    name        = "sqlite-analyzer";
    version     = "3.16.1";
    filename    = "mingw-w64-x86_64-sqlite-analyzer-3.16.1-1-any.pkg.tar.xz";
    sha256      = "d6bee735cfddacef35cdbec3185ae72bb75fcc66762dedebf0a5b163eea64a91";
    buildInputs = [ gcc-libs tcl ];
  };

  "sqlite3" = fetch {
    name        = "sqlite3";
    version     = "3.26.0";
    filename    = "mingw-w64-x86_64-sqlite3-3.26.0-1-any.pkg.tar.xz";
    sha256      = "50ff87ca01a4e0ddcfa08b23fe02a0c78972bb3f96642894f76570bccbd6c349";
    buildInputs = [ gcc-libs ncurses readline ];
  };

  "srt" = fetch {
    name        = "srt";
    version     = "1.3.1";
    filename    = "mingw-w64-x86_64-srt-1.3.1-3-any.pkg.tar.xz";
    sha256      = "0710d9ff56d5fe8532bbc7c6a2b830d2fe42dd59deebb1dafa7f4242234cc885";
    buildInputs = [ gcc-libs libwinpthread-git openssl ];
  };

  "stxxl-git" = fetch {
    name        = "stxxl-git";
    version     = "1.4.1.343.gf7389c7";
    filename    = "mingw-w64-x86_64-stxxl-git-1.4.1.343.gf7389c7-2-any.pkg.tar.xz";
    sha256      = "0ede048be6684e63f90effa497a6f7930e8aa703fb2b0e414ac71ee3b05f6eeb";
  };

  "styrene" = fetch {
    name        = "styrene";
    version     = "0.3.0";
    filename    = "mingw-w64-x86_64-styrene-0.3.0-2-any.pkg.tar.xz";
    sha256      = "ad398257449d2ae0fc0772ae27ef826562e0e037c6b478afc371a129970a5fc0";
    buildInputs = [ zip python3 gcc binutils nsis ];
    broken      = true;
  };

  "suitesparse" = fetch {
    name        = "suitesparse";
    version     = "6.0.0";
    filename    = "mingw-w64-x86_64-suitesparse-6.0.0-2-any.pkg.tar.xz";
    sha256      = "5ce53fa3ad53469c8e52c164378dfc09b3f6d210d3a6c12ea8222fca1af5732b";
    buildInputs = [ openblas metis ];
  };

  "superglu-hg" = fetch {
    name        = "superglu-hg";
    version     = "r79.16efd99583f2";
    filename    = "mingw-w64-x86_64-superglu-hg-r79.16efd99583f2-1-any.pkg.tar.xz";
    sha256      = "05502dee647b5e31f88c847adb62bd912fff59cbaf7d1d1bb90ce74c27f98787";
    buildInputs = [ gcc-libs ];
  };

  "swig" = fetch {
    name        = "swig";
    version     = "3.0.12";
    filename    = "mingw-w64-x86_64-swig-3.0.12-1-any.pkg.tar.xz";
    sha256      = "440226a525b30b8299639c4fc1f29e89f15bcb2bbfc1999d8cb327de13a189c7";
    buildInputs = [ gcc-libs pcre ];
  };

  "syndication-qt5" = fetch {
    name        = "syndication-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-syndication-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "bb262bb4b2a7aa8c037acc31980a93dc564c1549220af82434384b0ef4cdd4ad";
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcodecs-qt5.version "5.50.0"; kcodecs-qt5) ];
    broken      = true;
  };

  "syntax-highlighting-qt5" = fetch {
    name        = "syntax-highlighting-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-syntax-highlighting-qt5-5.50.0-2-any.pkg.tar.xz";
    sha256      = "df253cc699184f90c6b400bb26fb1538958f60a70194c29aa84fecd70a9eea2c";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "szip" = fetch {
    name        = "szip";
    version     = "2.1.1";
    filename    = "mingw-w64-x86_64-szip-2.1.1-2-any.pkg.tar.xz";
    sha256      = "ec8fe26370b0673c4b91f5ccf3404907dc7c24cb9d75c7b8830aa93a7c13ace7";
    buildInputs = [  ];
  };

  "taglib" = fetch {
    name        = "taglib";
    version     = "1.11.1";
    filename    = "mingw-w64-x86_64-taglib-1.11.1-1-any.pkg.tar.xz";
    sha256      = "add3f00da1ba820f7b68b8eb6398c704d503fb96318d9ad86aaa322ff1066cde";
    buildInputs = [ gcc-libs zlib ];
  };

  "tcl" = fetch {
    name        = "tcl";
    version     = "8.6.9";
    filename    = "mingw-w64-x86_64-tcl-8.6.9-2-any.pkg.tar.xz";
    sha256      = "0c3d6604fb6f3d5e6d169a0e7c8b0fd1d05fbcf4f390e927e3f3ac65111be9c3";
    buildInputs = [ gcc-libs zlib ];
  };

  "tcl-nsf" = fetch {
    name        = "tcl-nsf";
    version     = "2.1.0";
    filename    = "mingw-w64-x86_64-tcl-nsf-2.1.0-1-any.pkg.tar.xz";
    sha256      = "85f5ca59adbc24222063e1b7b048452283510b7422aaf465c5cfecf8946503cf";
    buildInputs = [ tcl ];
  };

  "tcllib" = fetch {
    name        = "tcllib";
    version     = "1.19";
    filename    = "mingw-w64-x86_64-tcllib-1.19-1-any.pkg.tar.xz";
    sha256      = "bc1729bc870d7867f38c4f29b906b8366f48777bf320574a81af5ab861a306d9";
    buildInputs = [ tcl ];
  };

  "tclvfs-cvs" = fetch {
    name        = "tclvfs-cvs";
    version     = "20130425";
    filename    = "mingw-w64-x86_64-tclvfs-cvs-20130425-3-any.pkg.tar.xz";
    sha256      = "a9ac4e479faaf88af960ae9af50e62f9f1e7ec8f2698f238e3095b43682477f8";
    buildInputs = [ tcl ];
  };

  "tclx" = fetch {
    name        = "tclx";
    version     = "8.4.1";
    filename    = "mingw-w64-x86_64-tclx-8.4.1-3-any.pkg.tar.xz";
    sha256      = "d54b86febf6a296ddfd3809b2e75a8663dec9aaf7eb03f2ae1807a6379e8befa";
    buildInputs = [ tcl ];
  };

  "template-glib" = fetch {
    name        = "template-glib";
    version     = "3.30.0";
    filename    = "mingw-w64-x86_64-template-glib-3.30.0-1-any.pkg.tar.xz";
    sha256      = "67d94792c6ad1c641c53539dea836d75a1838941ea21d5d83b9d0bf6dbaafb3e";
    buildInputs = [ glib2 gobject-introspection ];
  };

  "tepl4" = fetch {
    name        = "tepl4";
    version     = "4.2.0";
    filename    = "mingw-w64-x86_64-tepl4-4.2.0-1-any.pkg.tar.xz";
    sha256      = "2a151fa3a085f3b7c17d9c2ad74f83344ebafeafceea36cff94a84e9b74fba39";
    buildInputs = [ amtk gtksourceview4 uchardet ];
  };

  "termcap" = fetch {
    name        = "termcap";
    version     = "1.3.1";
    filename    = "mingw-w64-x86_64-termcap-1.3.1-3-any.pkg.tar.xz";
    sha256      = "43ca8430119a27aa7638afd130d60e1386b262405d88e81b70af5e0cb5418d52";
    buildInputs = [ gcc-libs ];
  };

  "tesseract-data-afr" = fetch {
    name        = "tesseract-data-afr";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-afr-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f366d285440d4a07a54af0e7458f75a773dec30b5382f49edb86d46f05b80066";
  };

  "tesseract-data-amh" = fetch {
    name        = "tesseract-data-amh";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-amh-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ae3acc16f248086c8d09c23c5a57d166e78065d9741a4a7e86c47811e34ccb4a";
  };

  "tesseract-data-ara" = fetch {
    name        = "tesseract-data-ara";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ara-4.0.0-1-any.pkg.tar.xz";
    sha256      = "39bd52d2206ac59f304afdb1be0c5739d4a1046883578559d93fed62d1ccbaec";
  };

  "tesseract-data-asm" = fetch {
    name        = "tesseract-data-asm";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-asm-4.0.0-1-any.pkg.tar.xz";
    sha256      = "0874ed9d63563b95bb707cd29aceab7a24f212d3d4c8ca7bda5c78fcbeaec608";
  };

  "tesseract-data-aze" = fetch {
    name        = "tesseract-data-aze";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-aze-4.0.0-1-any.pkg.tar.xz";
    sha256      = "a2321440942ed557e10b0410b3963587f74848e099b121cd58d180a4a7c83e4d";
  };

  "tesseract-data-aze_cyrl" = fetch {
    name        = "tesseract-data-aze_cyrl";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-aze_cyrl-4.0.0-1-any.pkg.tar.xz";
    sha256      = "cfb72dfd61bc214984cfeb4503d2b3d2559356d0e0a3cb5a81b6c9dd0f78e952";
  };

  "tesseract-data-bel" = fetch {
    name        = "tesseract-data-bel";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-bel-4.0.0-1-any.pkg.tar.xz";
    sha256      = "6ab605db8bd90aad7685c4411c63a4474e0745368040e4215aedc4027ddf6137";
  };

  "tesseract-data-ben" = fetch {
    name        = "tesseract-data-ben";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ben-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f329c1fb894afe163d609caabd22588c9484971cf73cc1863bdc721e9e7a417f";
  };

  "tesseract-data-bod" = fetch {
    name        = "tesseract-data-bod";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-bod-4.0.0-1-any.pkg.tar.xz";
    sha256      = "03ee0f00a05ce05ab5ef400ca0a09abf674fec137012707f7c4c6295845e181d";
  };

  "tesseract-data-bos" = fetch {
    name        = "tesseract-data-bos";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-bos-4.0.0-1-any.pkg.tar.xz";
    sha256      = "dd4c1b9e4bd1c0e1cee355870d8ba63ae623af7c4215a615e7986492873861cc";
  };

  "tesseract-data-bul" = fetch {
    name        = "tesseract-data-bul";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-bul-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f000540c5391bedfe72caab378a2fa979739e7178a50155a3eccd50e02619d4d";
  };

  "tesseract-data-cat" = fetch {
    name        = "tesseract-data-cat";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-cat-4.0.0-1-any.pkg.tar.xz";
    sha256      = "74add7e28d49e32f028f03752d3b268c701d7f58e4e64842f1f408f9caec2716";
  };

  "tesseract-data-ceb" = fetch {
    name        = "tesseract-data-ceb";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ceb-4.0.0-1-any.pkg.tar.xz";
    sha256      = "4e6469e7444a3cd723a2313faab4c3536b731ae45b720a31a8ca2bd02e676f43";
  };

  "tesseract-data-ces" = fetch {
    name        = "tesseract-data-ces";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ces-4.0.0-1-any.pkg.tar.xz";
    sha256      = "8a094251077ba979e2b853c59c8ed49f0981aa847dae47b7d9bf678cfca796ab";
  };

  "tesseract-data-chi_sim" = fetch {
    name        = "tesseract-data-chi_sim";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-chi_sim-4.0.0-1-any.pkg.tar.xz";
    sha256      = "11856ea7cbb98fcff58e83a2d51a9b1059d7b5e525f33321601a51ccf0720c2e";
  };

  "tesseract-data-chi_tra" = fetch {
    name        = "tesseract-data-chi_tra";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-chi_tra-4.0.0-1-any.pkg.tar.xz";
    sha256      = "8781fbb8700d9d7c7871e44cb8a3365a4b71c4e3eb6cb2a831766947bb6a75ac";
  };

  "tesseract-data-chr" = fetch {
    name        = "tesseract-data-chr";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-chr-4.0.0-1-any.pkg.tar.xz";
    sha256      = "6b8e4ced7121c8efdac4e61bf8e3801b7539602b76939e757ab4b414caf9f018";
  };

  "tesseract-data-cym" = fetch {
    name        = "tesseract-data-cym";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-cym-4.0.0-1-any.pkg.tar.xz";
    sha256      = "88c61487568a64551514fdbd44030d37503fa6463e2cbfde6f77fb30373ee671";
  };

  "tesseract-data-dan" = fetch {
    name        = "tesseract-data-dan";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-dan-4.0.0-1-any.pkg.tar.xz";
    sha256      = "4042478af692eca750c595e162e28f00ad3a9191876f55ceb9744693cb21fc88";
  };

  "tesseract-data-dan_frak" = fetch {
    name        = "tesseract-data-dan_frak";
    version     = "3.04.00";
    filename    = "mingw-w64-x86_64-tesseract-data-dan_frak-3.04.00-1-any.pkg.tar.xz";
    sha256      = "b9d7bfdafb11c92c8915911bd8334969ef68d4eb273a423f4642cb1b15250adb";
  };

  "tesseract-data-deu" = fetch {
    name        = "tesseract-data-deu";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-deu-4.0.0-1-any.pkg.tar.xz";
    sha256      = "30ae20c519793f39c04408db39324a5a33f0b2e76af376cd1fb67c92e91a6da9";
  };

  "tesseract-data-deu_frak" = fetch {
    name        = "tesseract-data-deu_frak";
    version     = "3.04.00";
    filename    = "mingw-w64-x86_64-tesseract-data-deu_frak-3.04.00-1-any.pkg.tar.xz";
    sha256      = "ea06acc4a73ffe4a49cb23c04f1520b074057011f81eaad418778e2800409cdb";
  };

  "tesseract-data-dzo" = fetch {
    name        = "tesseract-data-dzo";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-dzo-4.0.0-1-any.pkg.tar.xz";
    sha256      = "523c5f71a91b0f68e90add362e0732a08b46caff702d39b2b3809dbe03f4559a";
  };

  "tesseract-data-ell" = fetch {
    name        = "tesseract-data-ell";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ell-4.0.0-1-any.pkg.tar.xz";
    sha256      = "35f96824e2c2890c1c1a2a175697d4ecdd02bac4a06f2c5dafb1525272996857";
  };

  "tesseract-data-eng" = fetch {
    name        = "tesseract-data-eng";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-eng-4.0.0-1-any.pkg.tar.xz";
    sha256      = "7c9259aed1cf678507e530e7ff7845e0c7138d6e3dc856d1526ed596dfa24a00";
  };

  "tesseract-data-enm" = fetch {
    name        = "tesseract-data-enm";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-enm-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ccd133f051d90b77dabc31c56b76d3b9c51a3b803853182fabff1be94ece2218";
  };

  "tesseract-data-epo" = fetch {
    name        = "tesseract-data-epo";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-epo-4.0.0-1-any.pkg.tar.xz";
    sha256      = "c0efa9033bc121439de909f4a60636dcf0112ffd0b1abbe2413a6bf2965fbc90";
  };

  "tesseract-data-equ" = fetch {
    name        = "tesseract-data-equ";
    version     = "3.04.00";
    filename    = "mingw-w64-x86_64-tesseract-data-equ-3.04.00-1-any.pkg.tar.xz";
    sha256      = "2b80737e4849d35a6edb515474a31ca953620252aec91f14a72c3631ba2767b9";
  };

  "tesseract-data-est" = fetch {
    name        = "tesseract-data-est";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-est-4.0.0-1-any.pkg.tar.xz";
    sha256      = "4852e8884faa88e8dd95be63e77a85c742be113db65ffaf9b95d06591b299e06";
  };

  "tesseract-data-eus" = fetch {
    name        = "tesseract-data-eus";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-eus-4.0.0-1-any.pkg.tar.xz";
    sha256      = "cc60ee8c3b7ed005c6eb1b018d4698cc9544ed25eea3c0e867bb438c208e2748";
  };

  "tesseract-data-fas" = fetch {
    name        = "tesseract-data-fas";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-fas-4.0.0-1-any.pkg.tar.xz";
    sha256      = "d12e3932d8fe7e4f42a40b75b47e149c7af6bb010ec6635b5ec7961e9aa72a6e";
  };

  "tesseract-data-fin" = fetch {
    name        = "tesseract-data-fin";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-fin-4.0.0-1-any.pkg.tar.xz";
    sha256      = "7cc3614ceccc1b804ccbe61a204fc13947a6fb42ec3e109454af01f893dc10eb";
  };

  "tesseract-data-fra" = fetch {
    name        = "tesseract-data-fra";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-fra-4.0.0-1-any.pkg.tar.xz";
    sha256      = "4afeb360b60ead7770991e1cdaae324b3af13858051fa8a9d0b6bb1b76d20a65";
  };

  "tesseract-data-frk" = fetch {
    name        = "tesseract-data-frk";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-frk-4.0.0-1-any.pkg.tar.xz";
    sha256      = "773cd6c9b27f7ce1447a01b18aeef5d9bd5596e3308fcccb443ecf6db1980f5d";
  };

  "tesseract-data-frm" = fetch {
    name        = "tesseract-data-frm";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-frm-4.0.0-1-any.pkg.tar.xz";
    sha256      = "a543fc165f8881818b953649f3ebb66f7e49dc41b675b6991cce5e7a162899ef";
  };

  "tesseract-data-gle" = fetch {
    name        = "tesseract-data-gle";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-gle-4.0.0-1-any.pkg.tar.xz";
    sha256      = "3ae3c8c3f63bc32e74ecfca7c801ca7c77b74ba85c4fb9557feb1effb5328403";
  };

  "tesseract-data-glg" = fetch {
    name        = "tesseract-data-glg";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-glg-4.0.0-1-any.pkg.tar.xz";
    sha256      = "c9838515b2afde55c0b990c33b67e0e47afc53377b2049dcd49a89fe60b101e1";
  };

  "tesseract-data-grc" = fetch {
    name        = "tesseract-data-grc";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-grc-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ee7b72c293a8077acf31ee88d52b66a29e4c7a2c0e580ffeee3c479319d6337f";
  };

  "tesseract-data-guj" = fetch {
    name        = "tesseract-data-guj";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-guj-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f0e3ccc217f4e1b63a27dd21917ccc8a785e298e9a55807761a7cab7b521ca44";
  };

  "tesseract-data-hat" = fetch {
    name        = "tesseract-data-hat";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-hat-4.0.0-1-any.pkg.tar.xz";
    sha256      = "08f241102fc3653d27a700f9e6e3477b189d1f7820309c801f3084e6980357c4";
  };

  "tesseract-data-heb" = fetch {
    name        = "tesseract-data-heb";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-heb-4.0.0-1-any.pkg.tar.xz";
    sha256      = "b0f639aa8568f8a0d06801ce874a784c9ee522c91c8caa0c0d98e599a1f92dd5";
  };

  "tesseract-data-hin" = fetch {
    name        = "tesseract-data-hin";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-hin-4.0.0-1-any.pkg.tar.xz";
    sha256      = "86b6fa10ab0315662e59ec3b82e8a805d3d937f7166ef451dd87a48ecd3b953f";
  };

  "tesseract-data-hrv" = fetch {
    name        = "tesseract-data-hrv";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-hrv-4.0.0-1-any.pkg.tar.xz";
    sha256      = "a1b3fbab1d6522ad39e4eb889dd8451adac87209747d5369fff4636fc82e5fb7";
  };

  "tesseract-data-hun" = fetch {
    name        = "tesseract-data-hun";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-hun-4.0.0-1-any.pkg.tar.xz";
    sha256      = "8a8794f3eb4bb789212d512e315748920bfe779bd3bbd034c1025bfa5ebd6708";
  };

  "tesseract-data-iku" = fetch {
    name        = "tesseract-data-iku";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-iku-4.0.0-1-any.pkg.tar.xz";
    sha256      = "df25bc613828d50ea8f5bb4e3924a03117bbf7837e118d098a5defec173a3f4e";
  };

  "tesseract-data-ind" = fetch {
    name        = "tesseract-data-ind";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ind-4.0.0-1-any.pkg.tar.xz";
    sha256      = "0daa4e4b42586fd9f1d919fd94dac227f9ab9bc529515adf40f3a454b1e435fd";
  };

  "tesseract-data-isl" = fetch {
    name        = "tesseract-data-isl";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-isl-4.0.0-1-any.pkg.tar.xz";
    sha256      = "3619962a8555acc33f6e6c54dcd012ca04a9514d6a1cdef6cb0fd23e3973eb1b";
  };

  "tesseract-data-ita" = fetch {
    name        = "tesseract-data-ita";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ita-4.0.0-1-any.pkg.tar.xz";
    sha256      = "829eb121d96bea62d7ac6b53b1344029b65998513e14e471953f5ad81c7d07ec";
  };

  "tesseract-data-ita_old" = fetch {
    name        = "tesseract-data-ita_old";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ita_old-4.0.0-1-any.pkg.tar.xz";
    sha256      = "66aa78957e8d9e41f6cc68cda3885bffe5387420af490c5e9f5670e8a055cc98";
  };

  "tesseract-data-jav" = fetch {
    name        = "tesseract-data-jav";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-jav-4.0.0-1-any.pkg.tar.xz";
    sha256      = "b2daed2d663e0f05a99ba45c67e857d173383fdbac85bc55eb4ee934fbc1c234";
  };

  "tesseract-data-jpn" = fetch {
    name        = "tesseract-data-jpn";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-jpn-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f9c7d4230af653690014810eba0ed374cba47bb614783bd2a9f822605987838a";
  };

  "tesseract-data-kan" = fetch {
    name        = "tesseract-data-kan";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-kan-4.0.0-1-any.pkg.tar.xz";
    sha256      = "78d2ddbba2f11a417d2c9f38112f8cb82a4197c5f83a1b67819fb10fb1b8a999";
  };

  "tesseract-data-kat" = fetch {
    name        = "tesseract-data-kat";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-kat-4.0.0-1-any.pkg.tar.xz";
    sha256      = "2c2f98dbc18a259718f53a6b48b17acdf1e0d09e7f6ed30935aa1092955353d0";
  };

  "tesseract-data-kat_old" = fetch {
    name        = "tesseract-data-kat_old";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-kat_old-4.0.0-1-any.pkg.tar.xz";
    sha256      = "d2481e91798f70ef2c693e88b742a4adfed9a2b0ab421084c4058123cdc6f2e2";
  };

  "tesseract-data-kaz" = fetch {
    name        = "tesseract-data-kaz";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-kaz-4.0.0-1-any.pkg.tar.xz";
    sha256      = "4add50ca1f4e67f726d7b728b0c47677da29b55395234c623c5b7969aca3995f";
  };

  "tesseract-data-khm" = fetch {
    name        = "tesseract-data-khm";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-khm-4.0.0-1-any.pkg.tar.xz";
    sha256      = "153a6a8d21d5901e29370894049f4052a520846352d00d883a9c73e375917b65";
  };

  "tesseract-data-kir" = fetch {
    name        = "tesseract-data-kir";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-kir-4.0.0-1-any.pkg.tar.xz";
    sha256      = "f54662067deef20ecc7f2268e637ae40e02ed64edbdd42f6e8127bb2191b0d17";
  };

  "tesseract-data-kor" = fetch {
    name        = "tesseract-data-kor";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-kor-4.0.0-1-any.pkg.tar.xz";
    sha256      = "31f57b7046e180e31ea361bb06291a42cf1e2a92adb5098d8fb067591865a2a3";
  };

  "tesseract-data-kur" = fetch {
    name        = "tesseract-data-kur";
    version     = "3.04.00";
    filename    = "mingw-w64-x86_64-tesseract-data-kur-3.04.00-1-any.pkg.tar.xz";
    sha256      = "9afc8460e371497f006da059e283f27c3453d1f4d9dec073f30998774911853b";
  };

  "tesseract-data-lao" = fetch {
    name        = "tesseract-data-lao";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-lao-4.0.0-1-any.pkg.tar.xz";
    sha256      = "7f56dd574d45272704f2a16d7edbf629366693628c3184b73fa85a834c8c7af7";
  };

  "tesseract-data-lat" = fetch {
    name        = "tesseract-data-lat";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-lat-4.0.0-1-any.pkg.tar.xz";
    sha256      = "be6bd4b53df13e4fa8e95ccff6b9ea35d75f3364a86032a51c34919c5d562201";
  };

  "tesseract-data-lav" = fetch {
    name        = "tesseract-data-lav";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-lav-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ef761602720a649471389131932478b26901fe947fc2b5eda3ec57c5a87ea694";
  };

  "tesseract-data-lit" = fetch {
    name        = "tesseract-data-lit";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-lit-4.0.0-1-any.pkg.tar.xz";
    sha256      = "855bd376e7ed946cdc015af40023ea7b9512674b22bccf76f9296f8a5f7203e4";
  };

  "tesseract-data-mal" = fetch {
    name        = "tesseract-data-mal";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-mal-4.0.0-1-any.pkg.tar.xz";
    sha256      = "821d0f1852c2dfa01ca3126e1029ebc088e416da4fcb75a9a92fbef75f9fa3ae";
  };

  "tesseract-data-mar" = fetch {
    name        = "tesseract-data-mar";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-mar-4.0.0-1-any.pkg.tar.xz";
    sha256      = "2ae0e8ab59a07e4224bc3cccb11ce221cfd84809168b5dadaa982d0b00e54e10";
  };

  "tesseract-data-mkd" = fetch {
    name        = "tesseract-data-mkd";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-mkd-4.0.0-1-any.pkg.tar.xz";
    sha256      = "c311b48cb4d6aa3b4e5222d0b34d40fba940f7e269522fad9fa291c950901be1";
  };

  "tesseract-data-mlt" = fetch {
    name        = "tesseract-data-mlt";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-mlt-4.0.0-1-any.pkg.tar.xz";
    sha256      = "fe1fcb7777265d2797829139248135903b9983c106b609434ee8a78d7e8885a9";
  };

  "tesseract-data-msa" = fetch {
    name        = "tesseract-data-msa";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-msa-4.0.0-1-any.pkg.tar.xz";
    sha256      = "5ad3beb2571f90fde9e349c07a102b0e953777d2ff9037766471716574a018a7";
  };

  "tesseract-data-mya" = fetch {
    name        = "tesseract-data-mya";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-mya-4.0.0-1-any.pkg.tar.xz";
    sha256      = "6564bcaad66e38fb4f8866a15fe82202f89e60e9b8f3a00d9a7167610a75dc3e";
  };

  "tesseract-data-nep" = fetch {
    name        = "tesseract-data-nep";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-nep-4.0.0-1-any.pkg.tar.xz";
    sha256      = "1d58242af3649a5097259b7a4151bc1ad60649b688fd02064ec86702e5d277bd";
  };

  "tesseract-data-nld" = fetch {
    name        = "tesseract-data-nld";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-nld-4.0.0-1-any.pkg.tar.xz";
    sha256      = "6fdac05ec0e15c3930a65f59e04d19723b603a748da6ee1479e1adc79c1f6464";
  };

  "tesseract-data-nor" = fetch {
    name        = "tesseract-data-nor";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-nor-4.0.0-1-any.pkg.tar.xz";
    sha256      = "22537955ac697f4334216d4711a3424dbb0e874458f906614625a059a8cf2fbc";
  };

  "tesseract-data-ori" = fetch {
    name        = "tesseract-data-ori";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ori-4.0.0-1-any.pkg.tar.xz";
    sha256      = "e2321e83d6a43345f418ad4ef7ceb24cef567ccf7fc618f7a25e7101a6c169e8";
  };

  "tesseract-data-pan" = fetch {
    name        = "tesseract-data-pan";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-pan-4.0.0-1-any.pkg.tar.xz";
    sha256      = "76cba403a8c2ec25f9ffd9314c89fe13caa50244d98cb0245c54292029156e3a";
  };

  "tesseract-data-pol" = fetch {
    name        = "tesseract-data-pol";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-pol-4.0.0-1-any.pkg.tar.xz";
    sha256      = "1f516438c78c624f5a37f83fe911889305ed8c4df7020797b57068411315af64";
  };

  "tesseract-data-por" = fetch {
    name        = "tesseract-data-por";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-por-4.0.0-1-any.pkg.tar.xz";
    sha256      = "0656b655d0ad11c5262380b7a799436527fdcb789e1661a62e45455f57414703";
  };

  "tesseract-data-pus" = fetch {
    name        = "tesseract-data-pus";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-pus-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ea19ff3d815ff043d0940ebcc76142f16c911c8e82e6f15a476343fa308f727c";
  };

  "tesseract-data-ron" = fetch {
    name        = "tesseract-data-ron";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ron-4.0.0-1-any.pkg.tar.xz";
    sha256      = "8a531749de37c707acb875ade93c0be51436972d9c325ebd1def223946cf08fc";
  };

  "tesseract-data-rus" = fetch {
    name        = "tesseract-data-rus";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-rus-4.0.0-1-any.pkg.tar.xz";
    sha256      = "a5820eaa9fc666b27c0c30a0b2980bd053f1ea9c923f8af4022dd4baac21afdd";
  };

  "tesseract-data-san" = fetch {
    name        = "tesseract-data-san";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-san-4.0.0-1-any.pkg.tar.xz";
    sha256      = "9d23a02053ddc476eb5018b78249c2c06a062f11cb7e25a7fd2a51c44975c596";
  };

  "tesseract-data-sin" = fetch {
    name        = "tesseract-data-sin";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-sin-4.0.0-1-any.pkg.tar.xz";
    sha256      = "92c0b77367924fe70da02d613d012be64746bf71af4ef2d61ad31133b617bf9c";
  };

  "tesseract-data-slk" = fetch {
    name        = "tesseract-data-slk";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-slk-4.0.0-1-any.pkg.tar.xz";
    sha256      = "5ddbf0c901eb119f99926e6daeefa9704572683e729bdd083bf5169f934dcbdd";
  };

  "tesseract-data-slk_frak" = fetch {
    name        = "tesseract-data-slk_frak";
    version     = "3.04.00";
    filename    = "mingw-w64-x86_64-tesseract-data-slk_frak-3.04.00-1-any.pkg.tar.xz";
    sha256      = "90e34e850daab7325da4fad69c0cfbb94594b405034d5c5193e3d291908906aa";
  };

  "tesseract-data-slv" = fetch {
    name        = "tesseract-data-slv";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-slv-4.0.0-1-any.pkg.tar.xz";
    sha256      = "28888a3a46a025b34f6e1c7c39c19cd1434b94d3253325f257bafeb1ad7d81e3";
  };

  "tesseract-data-spa" = fetch {
    name        = "tesseract-data-spa";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-spa-4.0.0-1-any.pkg.tar.xz";
    sha256      = "5369750b41ba29ede8b7f17fc3d98e5dc0431a62badb03d5eb1015e16f983f56";
  };

  "tesseract-data-spa_old" = fetch {
    name        = "tesseract-data-spa_old";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-spa_old-4.0.0-1-any.pkg.tar.xz";
    sha256      = "a6264c67d37fe279b26b027d3556f17a5659ecff614a10b0714c6f0318300439";
  };

  "tesseract-data-sqi" = fetch {
    name        = "tesseract-data-sqi";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-sqi-4.0.0-1-any.pkg.tar.xz";
    sha256      = "fcf355b01500b11b3a9b7696bf624ff2a7309953fd5709378abcd793d2c0850b";
  };

  "tesseract-data-srp" = fetch {
    name        = "tesseract-data-srp";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-srp-4.0.0-1-any.pkg.tar.xz";
    sha256      = "818d3081c0f922ddd04cf3dccaa82d28406f854bcd53d91c87465cdea003424a";
  };

  "tesseract-data-srp_latn" = fetch {
    name        = "tesseract-data-srp_latn";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-srp_latn-4.0.0-1-any.pkg.tar.xz";
    sha256      = "6bab5f73791dae6b3e280db80cf47aae074b6e34fb00d897d70a3e04a43b9694";
  };

  "tesseract-data-swa" = fetch {
    name        = "tesseract-data-swa";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-swa-4.0.0-1-any.pkg.tar.xz";
    sha256      = "ef6afa01eb89c6a114ef329fc0faaddcce4f835c48f6f78a6382807dc268d001";
  };

  "tesseract-data-swe" = fetch {
    name        = "tesseract-data-swe";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-swe-4.0.0-1-any.pkg.tar.xz";
    sha256      = "57a71492f4950a43c6de64e95c135086de29bf1a06f711ae3d13a00a871d057c";
  };

  "tesseract-data-syr" = fetch {
    name        = "tesseract-data-syr";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-syr-4.0.0-1-any.pkg.tar.xz";
    sha256      = "9da7cf41d5dca5764ef3c42d524cdc9c517d58d9c97ba107db51e53cd1360062";
  };

  "tesseract-data-tam" = fetch {
    name        = "tesseract-data-tam";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-tam-4.0.0-1-any.pkg.tar.xz";
    sha256      = "142008a014ceaf0ace1bfbf7284cee4b4730483a1b2ec10dd2965adbb93555e7";
  };

  "tesseract-data-tel" = fetch {
    name        = "tesseract-data-tel";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-tel-4.0.0-1-any.pkg.tar.xz";
    sha256      = "c54d84a1164b9663070dc445955111087d5271d2ebb0ba05b8a8d180052d99c8";
  };

  "tesseract-data-tgk" = fetch {
    name        = "tesseract-data-tgk";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-tgk-4.0.0-1-any.pkg.tar.xz";
    sha256      = "3c21d3d672e13dc8cfad8e3f82ce7356bb94d3ad609fdfb64cffc6527e49c5ac";
  };

  "tesseract-data-tgl" = fetch {
    name        = "tesseract-data-tgl";
    version     = "3.04.00";
    filename    = "mingw-w64-x86_64-tesseract-data-tgl-3.04.00-1-any.pkg.tar.xz";
    sha256      = "80c1d7d73460393ebe3449bcd480f0802c98cf7b0a377cbdbb5ad9adf264038f";
  };

  "tesseract-data-tha" = fetch {
    name        = "tesseract-data-tha";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-tha-4.0.0-1-any.pkg.tar.xz";
    sha256      = "6c69aae3c2cd0b7e05328079783be309520c0c860a3b7233bb13f0cec444b7a4";
  };

  "tesseract-data-tir" = fetch {
    name        = "tesseract-data-tir";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-tir-4.0.0-1-any.pkg.tar.xz";
    sha256      = "e1d94615d882513227f944e6e911928791b6e97937b79262d7d9509f6f3f24ce";
  };

  "tesseract-data-tur" = fetch {
    name        = "tesseract-data-tur";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-tur-4.0.0-1-any.pkg.tar.xz";
    sha256      = "108c482cec20f4b97aaf7d5bab140efc2bae614c501a6c2edcb10d74aa33cee1";
  };

  "tesseract-data-uig" = fetch {
    name        = "tesseract-data-uig";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-uig-4.0.0-1-any.pkg.tar.xz";
    sha256      = "78ec61bef799f1a2f7cfc2fc831881026c7acc71d23733bd2266551346ce1ecc";
  };

  "tesseract-data-ukr" = fetch {
    name        = "tesseract-data-ukr";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-ukr-4.0.0-1-any.pkg.tar.xz";
    sha256      = "e1d970a6a3f54347f2536f001472230271136d23933ada34a029fe4c74be2fc3";
  };

  "tesseract-data-urd" = fetch {
    name        = "tesseract-data-urd";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-urd-4.0.0-1-any.pkg.tar.xz";
    sha256      = "c20207bfa55bd08d04588f98b5a4ea01e712889d18d8704a45d09406f99b53c9";
  };

  "tesseract-data-uzb" = fetch {
    name        = "tesseract-data-uzb";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-uzb-4.0.0-1-any.pkg.tar.xz";
    sha256      = "dd8b855c1fb6ee1fe931ebed2fb5a7d25a6580485a16e5fd531dd840d9b0542b";
  };

  "tesseract-data-uzb_cyrl" = fetch {
    name        = "tesseract-data-uzb_cyrl";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-uzb_cyrl-4.0.0-1-any.pkg.tar.xz";
    sha256      = "40e2609da3ea0d7eb5ddeabeeb0c9cf07dfdb0f64f241f63ce10b2c0b7516cdd";
  };

  "tesseract-data-vie" = fetch {
    name        = "tesseract-data-vie";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-vie-4.0.0-1-any.pkg.tar.xz";
    sha256      = "8e16649536bb517d5be65f715fc8ac6d92f117f55282a17f2da577a7c7af32a7";
  };

  "tesseract-data-yid" = fetch {
    name        = "tesseract-data-yid";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-data-yid-4.0.0-1-any.pkg.tar.xz";
    sha256      = "4b73f5db85cc873ad6b8125253531a242f1b389f887f009c03a41fbe6a0a4699";
  };

  "tesseract-ocr" = fetch {
    name        = "tesseract-ocr";
    version     = "4.0.0";
    filename    = "mingw-w64-x86_64-tesseract-ocr-4.0.0-1-any.pkg.tar.xz";
    sha256      = "93ecb7698967dcab0751dae422d69fed54f379c5e48baa754abfec18fe145538";
    buildInputs = [ cairo gcc-libs icu leptonica pango zlib ];
  };

  "threadweaver-qt5" = fetch {
    name        = "threadweaver-qt5";
    version     = "5.50.0";
    filename    = "mingw-w64-x86_64-threadweaver-qt5-5.50.0-1-any.pkg.tar.xz";
    sha256      = "e034bf1a23a75164f65deeeee856744cee83124a1081d6174c46f2e0a3c7b00f";
    buildInputs = [ qt5 ];
    broken      = true;
  };

  "thrift-git" = fetch {
    name        = "thrift-git";
    version     = "1.0.r5327.a92358054";
    filename    = "mingw-w64-x86_64-thrift-git-1.0.r5327.a92358054-1-any.pkg.tar.xz";
    sha256      = "5f74afd23720c79197c6952f49d35e9be25ac0f8352b4ec11389b085824a3d1d";
    buildInputs = [ gcc-libs boost openssl zlib ];
  };

  "tidy" = fetch {
    name        = "tidy";
    version     = "5.7.16";
    filename    = "mingw-w64-x86_64-tidy-5.7.16-1-any.pkg.tar.xz";
    sha256      = "19171b1b978ed95361041d7dd753b447b78c0c74e9268d4ed8e5313d57a6b239";
    buildInputs = [ gcc-libs ];
  };

  "tiny-dnn" = fetch {
    name        = "tiny-dnn";
    version     = "1.0.0a3";
    filename    = "mingw-w64-x86_64-tiny-dnn-1.0.0a3-2-any.pkg.tar.xz";
    sha256      = "4de585a653ebf9e8524ecc804ef07108e356d229a156874f25873d9517389164";
    buildInputs = [ intel-tbb protobuf ];
  };

  "tinyformat" = fetch {
    name        = "tinyformat";
    version     = "2.1.0";
    filename    = "mingw-w64-x86_64-tinyformat-2.1.0-1-any.pkg.tar.xz";
    sha256      = "c5606255abe68c96e3c071538787388b188916da77546b44f434bf0ff13c0025";
  };

  "tinyxml" = fetch {
    name        = "tinyxml";
    version     = "2.6.2";
    filename    = "mingw-w64-x86_64-tinyxml-2.6.2-4-any.pkg.tar.xz";
    sha256      = "9cccdcc54fcb4fc30e61e745c3b15c1b5696a2b80f3ffbc4d05a31a6020e9787";
    buildInputs = [ gcc-libs ];
  };

  "tinyxml2" = fetch {
    name        = "tinyxml2";
    version     = "7.0.1";
    filename    = "mingw-w64-x86_64-tinyxml2-7.0.1-1-any.pkg.tar.xz";
    sha256      = "a963cd4640860e59e77696c3bfb56cf4ec538a5e817eb839cc6c7408ca3ca28a";
    buildInputs = [ gcc-libs ];
  };

  "tk" = fetch {
    name        = "tk";
    version     = "8.6.9.1";
    filename    = "mingw-w64-x86_64-tk-8.6.9.1-1-any.pkg.tar.xz";
    sha256      = "8305bb8c363e5b44c9538a788811aef9f71ec2442209401be9d37f47343db209";
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast tcl.version "8.6.9"; tcl) ];
  };

  "tkimg" = fetch {
    name        = "tkimg";
    version     = "1.4.7";
    filename    = "mingw-w64-x86_64-tkimg-1.4.7-1-any.pkg.tar.xz";
    sha256      = "37b913985b9297d4012343ab65ebe09c331b2ded6570a1edc250e42692651210";
    buildInputs = [ libjpeg libpng libtiff tk zlib ];
  };

  "tklib" = fetch {
    name        = "tklib";
    version     = "0.6";
    filename    = "mingw-w64-x86_64-tklib-0.6-5-any.pkg.tar.xz";
    sha256      = "b37caf2dcff16c8b38821fee2218bbec3ed0dcc7469f8c934ec21cbb2d11922a";
    buildInputs = [ tk tcllib ];
  };

  "tktable" = fetch {
    name        = "tktable";
    version     = "2.10";
    filename    = "mingw-w64-x86_64-tktable-2.10-4-any.pkg.tar.xz";
    sha256      = "260f9646bb8c140fa39c420ffe4c3be4eab969bd7c2911d8dbfafe6472b3a690";
    buildInputs = [ tk ];
  };

  "tolua" = fetch {
    name        = "tolua";
    version     = "5.2.4";
    filename    = "mingw-w64-x86_64-tolua-5.2.4-3-any.pkg.tar.xz";
    sha256      = "92fa34ff0ce7c5a6245052368b688668558b50bfc796cd175161671b16ea46e6";
    buildInputs = [ lua ];
    broken      = true;
  };

  "tools-git" = fetch {
    name        = "tools-git";
    version     = "7.0.0.5272.d66350ea";
    filename    = "mingw-w64-x86_64-tools-git-7.0.0.5272.d66350ea-1-any.pkg.tar.xz";
    sha256      = "21c102c33f269602c6066e159da07ee37f7dc09ce22df55702b9fb90d6432074";
    buildInputs = [ gcc-libs ];
  };

  "tor" = fetch {
    name        = "tor";
    version     = "0.3.3.6";
    filename    = "mingw-w64-x86_64-tor-0.3.3.6-1-any.pkg.tar.xz";
    sha256      = "62da60fdda2e7df8623ce6ab82ca770c2ce4b82c01c2eb4a0757714673708451";
    buildInputs = [ libevent openssl zlib ];
  };

  "totem-pl-parser" = fetch {
    name        = "totem-pl-parser";
    version     = "3.26.1";
    filename    = "mingw-w64-x86_64-totem-pl-parser-3.26.1-1-any.pkg.tar.xz";
    sha256      = "8f0c6b0238c8729362044ebcd8aca2b8d7a66f059c3dbe3ac3698d357c143918";
    buildInputs = [ glib2 gmime libsoup libarchive libgcrypt ];
  };

  "transmission" = fetch {
    name        = "transmission";
    version     = "2.94";
    filename    = "mingw-w64-x86_64-transmission-2.94-2-any.pkg.tar.xz";
    sha256      = "a79d05edb25a61033871b0ae8472e27a50b00c4c8c0e4d10fddc2f8b823b49fe";
    buildInputs = [ openssl libevent gtk3 curl zlib miniupnpc ];
  };

  "trompeloeil" = fetch {
    name        = "trompeloeil";
    version     = "31";
    filename    = "mingw-w64-x86_64-trompeloeil-31-1-any.pkg.tar.xz";
    sha256      = "15a3b4b9a83868a712d47a071f32dac44857d4cc14eb7405a26573701941dadb";
  };

  "ttf-dejavu" = fetch {
    name        = "ttf-dejavu";
    version     = "2.37";
    filename    = "mingw-w64-x86_64-ttf-dejavu-2.37-1-any.pkg.tar.xz";
    sha256      = "ef41a8ca8e36f00457b3469b386116251095f77bc70ad1a2f63748fc4e29d0d8";
    buildInputs = [ fontconfig ];
  };

  "tulip" = fetch {
    name        = "tulip";
    version     = "5.2.1";
    filename    = "mingw-w64-x86_64-tulip-5.2.1-1-any.pkg.tar.xz";
    sha256      = "d027fb7feca5a43aa9082b1cae2cea1e54692b799896f953cc546635431e961a";
    buildInputs = [ freetype glew libpng libjpeg python3 qhull-git qt5 qtwebkit quazip yajl ];
    broken      = true;
  };

  "twolame" = fetch {
    name        = "twolame";
    version     = "0.3.13";
    filename    = "mingw-w64-x86_64-twolame-0.3.13-3-any.pkg.tar.xz";
    sha256      = "b7a51f3b791c3a1d825291f548a110d3c5d16e02629347eedd81e582a2afe8e1";
    buildInputs = [ libsndfile ];
  };

  "uchardet" = fetch {
    name        = "uchardet";
    version     = "0.0.6";
    filename    = "mingw-w64-x86_64-uchardet-0.0.6-1-any.pkg.tar.xz";
    sha256      = "5d96fd920c5ea191cd91e0cd3d06964255058d9d63bc624371689dda1c76dc89";
    buildInputs = [ gcc-libs ];
  };

  "ucl" = fetch {
    name        = "ucl";
    version     = "1.03";
    filename    = "mingw-w64-x86_64-ucl-1.03-1-any.pkg.tar.xz";
    sha256      = "cc3d1b6a9586d9d4455cb806c0218fa5b81c215842b5f73dafffe6cddb6bad6b";
  };

  "udis86" = fetch {
    name        = "udis86";
    version     = "1.7.2";
    filename    = "mingw-w64-x86_64-udis86-1.7.2-1-any.pkg.tar.xz";
    sha256      = "4112b9169176183ae03cb4a4a2d214a01d7d5a8f3d0e3c50bcdb60d99ebbac53";
    buildInputs = [ python2 ];
  };

  "uhttpmock" = fetch {
    name        = "uhttpmock";
    version     = "0.5.1";
    filename    = "mingw-w64-x86_64-uhttpmock-0.5.1-1-any.pkg.tar.xz";
    sha256      = "166ab4030ed57cabbceece4f0ee7d328d4c74e739ba18356fa753f3fddb30efc";
    buildInputs = [ glib2 libsoup ];
  };

  "unbound" = fetch {
    name        = "unbound";
    version     = "1.8.3";
    filename    = "mingw-w64-x86_64-unbound-1.8.3-1-any.pkg.tar.xz";
    sha256      = "ecbc710ae9fc01724235138c2d74e2d9c48226bc6f3f0235f876d07a90c7cb5e";
    buildInputs = [ openssl expat ldns ];
  };

  "unibilium" = fetch {
    name        = "unibilium";
    version     = "2.0.0";
    filename    = "mingw-w64-x86_64-unibilium-2.0.0-1-any.pkg.tar.xz";
    sha256      = "d00d6819f0bb191e0f6dd3d9a2dd20beb8af284d0546c63084c8a8d8f10a4ff5";
  };

  "unicorn" = fetch {
    name        = "unicorn";
    version     = "1.0.1";
    filename    = "mingw-w64-x86_64-unicorn-1.0.1-3-any.pkg.tar.xz";
    sha256      = "b3b5d3fb6ffcb25f13ca698a6dc1cf599fa1e54b84e6bad5f94323b2a2d93a2f";
    buildInputs = [ gcc-libs ];
  };

  "universal-ctags-git" = fetch {
    name        = "universal-ctags-git";
    version     = "r6369.5728abe4";
    filename    = "mingw-w64-x86_64-universal-ctags-git-r6369.5728abe4-1-any.pkg.tar.xz";
    sha256      = "b4a374f99301b6a5ea460de8f8bb4adfb855aa6bce5b99a0fc61f199b3beacc2";
    buildInputs = [ gcc-libs jansson libiconv libxml2 libyaml ];
  };

  "unixodbc" = fetch {
    name        = "unixodbc";
    version     = "2.3.7";
    filename    = "mingw-w64-x86_64-unixodbc-2.3.7-1-any.pkg.tar.xz";
    sha256      = "ecda33418e572724a2b1c76d22ff467539a9ebd767743ef0b779900e89c8d349";
    buildInputs = [ gcc-libs readline libtool ];
  };

  "uriparser" = fetch {
    name        = "uriparser";
    version     = "0.9.0";
    filename    = "mingw-w64-x86_64-uriparser-0.9.0-1-any.pkg.tar.xz";
    sha256      = "64e63b5d1798a52803125c4cec23d637355d5d38fa57157f824e2d5e7e46386b";
  };

  "usbredir" = fetch {
    name        = "usbredir";
    version     = "0.8.0";
    filename    = "mingw-w64-x86_64-usbredir-0.8.0-1-any.pkg.tar.xz";
    sha256      = "dd23930badbee6f52ed37127aaa7380b3952ac8880db2e876faf94803a65d849";
    buildInputs = [ libusb ];
  };

  "usbview-git" = fetch {
    name        = "usbview-git";
    version     = "42.c4ba9c6";
    filename    = "mingw-w64-x86_64-usbview-git-42.c4ba9c6-1-any.pkg.tar.xz";
    sha256      = "3a2cf1fd62d1ce5d722e90dc1e7a9bb9bd45df5c903d41aba5fead52ca384485";
  };

  "usql" = fetch {
    name        = "usql";
    version     = "0.8.1";
    filename    = "mingw-w64-x86_64-usql-0.8.1-1-any.pkg.tar.xz";
    sha256      = "3c391d007de340ae16d34104465ce79348f5ccf9c3c953bdc8402b88f1acce71";
    buildInputs = [ antlr3 ];
  };

  "usrsctp" = fetch {
    name        = "usrsctp";
    version     = "0.9.3.0";
    filename    = "mingw-w64-x86_64-usrsctp-0.9.3.0-1-any.pkg.tar.xz";
    sha256      = "202ea32ecefa0de97b13a50d2c7a20aa8f1dca6c5da410c759ec615087572bae";
  };

  "vala" = fetch {
    name        = "vala";
    version     = "0.42.4";
    filename    = "mingw-w64-x86_64-vala-0.42.4-1-any.pkg.tar.xz";
    sha256      = "088ee0c1ee7c80db683e5dfc8fc6d80bf586077ded7e9304b400edd1b50a0422";
    buildInputs = [ glib2 graphviz ];
  };

  "vamp-plugin-sdk" = fetch {
    name        = "vamp-plugin-sdk";
    version     = "2.7.1";
    filename    = "mingw-w64-x86_64-vamp-plugin-sdk-2.7.1-1-any.pkg.tar.xz";
    sha256      = "f66b91d124f788de8276ceffb5a4721d24936d6218da73d5e5ecc50cce773d85";
    buildInputs = [ gcc-libs libsndfile ];
  };

  "vapoursynth" = fetch {
    name        = "vapoursynth";
    version     = "45.1";
    filename    = "mingw-w64-x86_64-vapoursynth-45.1-1-any.pkg.tar.xz";
    sha256      = "66c8671de9c3109307377e6b517aa5b056244f5e688e79b1477dcb453d228ce0";
    buildInputs = [ gcc-libs cython ffmpeg imagemagick libass libxml2 python3 tesseract-ocr zimg ];
    broken      = true;
  };

  "vcdimager" = fetch {
    name        = "vcdimager";
    version     = "2.0.1";
    filename    = "mingw-w64-x86_64-vcdimager-2.0.1-1-any.pkg.tar.xz";
    sha256      = "e5f34fc3581da4562a83450e46e70166c8e029f374b9bdd0623d381a7736e38c";
    buildInputs = [ libcdio libxml2 popt ];
  };

  "verilator" = fetch {
    name        = "verilator";
    version     = "4.004";
    filename    = "mingw-w64-x86_64-verilator-4.004-1-any.pkg.tar.xz";
    sha256      = "cb3975a7f63eebbf92c8eb2c9ea93b1e346e04e1ca79fd0aa6c52aa27c32818d";
    buildInputs = [ gcc-libs ];
  };

  "vid.stab" = fetch {
    name        = "vid.stab";
    version     = "1.1";
    filename    = "mingw-w64-x86_64-vid.stab-1.1-1-any.pkg.tar.xz";
    sha256      = "1e40a20eb9455a1a57609e8554ce1c662a6523fd715471744f2396c179a7e6d2";
  };

  "vigra" = fetch {
    name        = "vigra";
    version     = "1.11.1";
    filename    = "mingw-w64-x86_64-vigra-1.11.1-2-any.pkg.tar.xz";
    sha256      = "929a2b5eacf7076c8a36e350057fc9f5ca5ee178b428f4529f88684b28ee2162";
    buildInputs = [ gcc-libs boost fftw hdf5 libjpeg-turbo libpng libtiff openexr python2-numpy zlib ];
  };

  "virt-viewer" = fetch {
    name        = "virt-viewer";
    version     = "7.0";
    filename    = "mingw-w64-x86_64-virt-viewer-7.0-1-any.pkg.tar.xz";
    sha256      = "0f32c96ddd25b40b232d9c78054c07289cec9f3f883095221469f706bff4bed7";
    buildInputs = [ spice-gtk gtk-vnc libxml2 opus ];
    broken      = true;
  };

  "vlc" = fetch {
    name        = "vlc";
    version     = "3.0.5";
    filename    = "mingw-w64-x86_64-vlc-3.0.5-1-any.pkg.tar.xz";
    sha256      = "8b3ae7717d0a6ec85e3d2fad2ae48a3aba1b9a9dde261fc4e1751df249487ed2";
    buildInputs = [ a52dec aribb24 chromaprint faad2 ffmpeg flac fluidsynth fribidi gnutls gsm libass libbluray libcaca libcddb libcdio libdca libdsm libdvdcss libdvdnav libdvbpsi libgme libgoom2 libmad libmatroska libmicrodns libmpcdec libmpeg2-git libmysofa libnfs libplacebo libproxy librsvg libsamplerate libshout libssh2 libtheora libvpx libxml2 lua51 opencv opus portaudio protobuf pupnp schroedinger speex srt taglib twolame vcdimager x264-git x265 xpm-nox qt5 ];
    broken      = true;
  };

  "vlfeat" = fetch {
    name        = "vlfeat";
    version     = "0.9.21";
    filename    = "mingw-w64-x86_64-vlfeat-0.9.21-1-any.pkg.tar.xz";
    sha256      = "8792f5b924afdfa47051d0ec78fc94d93edface234b9dc1abb810b6c94de5c92";
    buildInputs = [ gcc-libs ];
  };

  "vo-amrwbenc" = fetch {
    name        = "vo-amrwbenc";
    version     = "0.1.3";
    filename    = "mingw-w64-x86_64-vo-amrwbenc-0.1.3-1-any.pkg.tar.xz";
    sha256      = "0612bd794776995c03a9d8a52b672ab0839919beb718f79272376c64db11b0a1";
  };

  "vrpn" = fetch {
    name        = "vrpn";
    version     = "7.34";
    filename    = "mingw-w64-x86_64-vrpn-7.34-3-any.pkg.tar.xz";
    sha256      = "d6d7aeae5d4172dd6bbabe8a36f6abb4ff8b59e2b30da967d4b559655ff4262b";
    buildInputs = [ hidapi jsoncpp libusb python3 swig ];
  };

  "vtk" = fetch {
    name        = "vtk";
    version     = "8.1.2";
    filename    = "mingw-w64-x86_64-vtk-8.1.2-1-any.pkg.tar.xz";
    sha256      = "ec1be0888c0e75c9b28bc5a9d24128715a5f93a27c9ec25dfe014a1d7fa1e8ab";
    buildInputs = [ gcc-libs expat ffmpeg fontconfig freetype hdf5 intel-tbb jsoncpp libjpeg libharu libpng libogg libtheora libtiff libxml2 lz4 qt5 zlib ];
    broken      = true;
  };

  "vulkan-headers" = fetch {
    name        = "vulkan-headers";
    version     = "1.1.92";
    filename    = "mingw-w64-x86_64-vulkan-headers-1.1.92-1-any.pkg.tar.xz";
    sha256      = "a7e280bd21c30772f22e49379e319de8a978d88c3da542817e50daf6ce46840a";
    buildInputs = [ gcc-libs ];
  };

  "vulkan-loader" = fetch {
    name        = "vulkan-loader";
    version     = "1.1.92";
    filename    = "mingw-w64-x86_64-vulkan-loader-1.1.92-1-any.pkg.tar.xz";
    sha256      = "90a64b7b3cec08a2dfaf678173885cebcd6d4294ad42ee5dff083e069983c6b5";
    buildInputs = [ vulkan-headers ];
  };

  "waf" = fetch {
    name        = "waf";
    version     = "2.0.12";
    filename    = "mingw-w64-x86_64-waf-2.0.12-1-any.pkg.tar.xz";
    sha256      = "f7d13a96d693f7c31fafa341ee43b36a84034f386b0e57bb0f1c31881fdc3135";
    buildInputs = [ python3 ];
  };

  "wavpack" = fetch {
    name        = "wavpack";
    version     = "5.1.0";
    filename    = "mingw-w64-x86_64-wavpack-5.1.0-1-any.pkg.tar.xz";
    sha256      = "02af35819da06de73d35b6cd035504b59e517c94cd648dbe282297cfd6f2e735";
    buildInputs = [ gcc-libs ];
  };

  "webkitgtk2" = fetch {
    name        = "webkitgtk2";
    version     = "2.4.11";
    filename    = "mingw-w64-x86_64-webkitgtk2-2.4.11-6-any.pkg.tar.xz";
    sha256      = "e3ac3b06775a5a9fd1c880c45b293c8a7f111d2cb2ae44922752233108cd67c8";
    buildInputs = [ angleproject-git cairo enchant fontconfig freetype glib2 gst-plugins-base gstreamer geoclue harfbuzz icu libidn libjpeg libpng libsoup libxml2 libxslt libwebp pango sqlite3 xz gtk2 ];
    broken      = true;
  };

  "webkitgtk3" = fetch {
    name        = "webkitgtk3";
    version     = "2.4.11";
    filename    = "mingw-w64-x86_64-webkitgtk3-2.4.11-6-any.pkg.tar.xz";
    sha256      = "c2fbcb8b99068b3452112f64523d6fab4b841005176524b9bd910ec6c967c26c";
    buildInputs = [ angleproject-git cairo enchant fontconfig freetype glib2 gst-plugins-base gstreamer geoclue harfbuzz icu libidn libjpeg libpng libsoup libxml2 libxslt libwebp pango sqlite3 xz gtk3 ];
    broken      = true;
  };

  "wget" = fetch {
    name        = "wget";
    version     = "1.20";
    filename    = "mingw-w64-x86_64-wget-1.20-1-any.pkg.tar.xz";
    sha256      = "3bd5bab944698cb2e8710be36d7babf7516f885209968770a6112f5d9990bbf4";
    buildInputs = [ pcre libidn2 openssl c-ares gpgme ];
  };

  "win7appid" = fetch {
    name        = "win7appid";
    version     = "1.1";
    filename    = "mingw-w64-x86_64-win7appid-1.1-3-any.pkg.tar.xz";
    sha256      = "fefb963985cd14313a0a10738e9aef24a41886d3163317a89c0104ba2a920d67";
  };

  "windows-default-manifest" = fetch {
    name        = "windows-default-manifest";
    version     = "6.4";
    filename    = "mingw-w64-x86_64-windows-default-manifest-6.4-3-any.pkg.tar.xz";
    sha256      = "6c0ea4adcef503dc8174e9d4d70a10aee8295d620db4494f78fa512df0589dcf";
    buildInputs = [  ];
  };

  "wined3d" = fetch {
    name        = "wined3d";
    version     = "3.8";
    filename    = "mingw-w64-x86_64-wined3d-3.8-1-any.pkg.tar.xz";
    sha256      = "60957b41661bafadcc969fb44646330c779d97be1a9ca008e6a8bd4b8fedeb15";
  };

  "wineditline" = fetch {
    name        = "wineditline";
    version     = "2.205";
    filename    = "mingw-w64-x86_64-wineditline-2.205-1-any.pkg.tar.xz";
    sha256      = "73394b306d6a52dfc7c139837fd51adab3fc60af01fcb7a57e36b5cbfbfdddb2";
    buildInputs = [  ];
  };

  "winico" = fetch {
    name        = "winico";
    version     = "0.6";
    filename    = "mingw-w64-x86_64-winico-0.6-2-any.pkg.tar.xz";
    sha256      = "15e535d926200768ee8d0854e1775de0404beb4167434394bc7cb1e2b89e32bf";
    buildInputs = [ tk ];
  };

  "winpthreads-git" = fetch {
    name        = "winpthreads-git";
    version     = "7.0.0.5273.3e5acf5d";
    filename    = "mingw-w64-x86_64-winpthreads-git-7.0.0.5273.3e5acf5d-1-any.pkg.tar.xz";
    sha256      = "959d67b96742be6986d4da833c150d66b8375d80997e7c6fd1f80b2c25672f4b";
    buildInputs = [ crt-git (assert libwinpthread-git.version=="7.0.0.5273.3e5acf5d"; libwinpthread-git) ];
  };

  "winsparkle" = fetch {
    name        = "winsparkle";
    version     = "0.5.2";
    filename    = "mingw-w64-x86_64-winsparkle-0.5.2-1-any.pkg.tar.xz";
    sha256      = "add1a23cdd67649f4a3296f6f014b9f01f54884ff1c2bef901185919f8ea5d89";
    buildInputs = [ expat wxWidgets ];
  };

  "winstorecompat-git" = fetch {
    name        = "winstorecompat-git";
    version     = "7.0.0.5230.69c8fad6";
    filename    = "mingw-w64-x86_64-winstorecompat-git-7.0.0.5230.69c8fad6-1-any.pkg.tar.xz";
    sha256      = "2e09b2b1d0339f4079c41e6aa09046ea96651046da02591c91c34ebecfba07e4";
  };

  "wintab-sdk" = fetch {
    name        = "wintab-sdk";
    version     = "1.4";
    filename    = "mingw-w64-x86_64-wintab-sdk-1.4-2-any.pkg.tar.xz";
    sha256      = "50aa58fbfad39f678eda44414147b2b2b62c2bb472147aae52ce3a5a7bec9662";
  };

  "wkhtmltopdf-git" = fetch {
    name        = "wkhtmltopdf-git";
    version     = "0.13.r1049.51f9658";
    filename    = "mingw-w64-x86_64-wkhtmltopdf-git-0.13.r1049.51f9658-1-any.pkg.tar.xz";
    sha256      = "fb77d9494d5776ad15c8c008a305fa999c582030a99203acfc6b4e7059cf3ffb";
    buildInputs = [ qt5 qtwebkit ];
    broken      = true;
  };

  "woff2" = fetch {
    name        = "woff2";
    version     = "1.0.2";
    filename    = "mingw-w64-x86_64-woff2-1.0.2-1-any.pkg.tar.xz";
    sha256      = "ac07fff5b348dd968a10aa5e0ec685b827f32645acf668a2382bcd2464aad182";
    buildInputs = [ gcc-libs brotli ];
  };

  "wslay" = fetch {
    name        = "wslay";
    version     = "1.1.0";
    filename    = "mingw-w64-x86_64-wslay-1.1.0-1-any.pkg.tar.xz";
    sha256      = "2dfd24a8bdc2ce30deee46b89423f6b543483dde5657275ae1686db7f79e8be6";
    buildInputs = [ gcc-libs ];
  };

  "wxPython" = fetch {
    name        = "wxPython";
    version     = "3.0.2.0";
    filename    = "mingw-w64-x86_64-wxPython-3.0.2.0-8-any.pkg.tar.xz";
    sha256      = "3a5d6b1bee4dde1683a52ca14d4208cd1378682afff46d0ae57b736eccb2199c";
    buildInputs = [ python2 wxWidgets ];
  };

  "wxWidgets" = fetch {
    name        = "wxWidgets";
    version     = "3.0.4";
    filename    = "mingw-w64-x86_64-wxWidgets-3.0.4-2-any.pkg.tar.xz";
    sha256      = "2c12299074d25e475de7bbd26110fece6e6cf583513076fc199e0e272b257bba";
    buildInputs = [ gcc-libs expat libjpeg-turbo libpng libtiff xz zlib ];
  };

  "x264-git" = fetch {
    name        = "x264-git";
    version     = "r2901.7d0ff22e";
    filename    = "mingw-w64-x86_64-x264-git-r2901.7d0ff22e-1-any.pkg.tar.xz";
    sha256      = "7b97a81e515fe4baa21d99188f42288dc3eced804f30fe743b3ca34276a48416";
    buildInputs = [ libwinpthread-git l-smash ];
  };

  "x265" = fetch {
    name        = "x265";
    version     = "2.9";
    filename    = "mingw-w64-x86_64-x265-2.9-1-any.pkg.tar.xz";
    sha256      = "482db1c3e7a8ec12d1bfbd79cfe77eeff0eed1585e7116b0ee2fb84bac2116a1";
    buildInputs = [ gcc-libs ];
  };

  "xalan-c" = fetch {
    name        = "xalan-c";
    version     = "1.11";
    filename    = "mingw-w64-x86_64-xalan-c-1.11-7-any.pkg.tar.xz";
    sha256      = "41370fc9f81f9f692cc70e3f203e2fe6737f315ff0990e64fc6b77e61f6bf359";
    buildInputs = [ gcc-libs xerces-c ];
  };

  "xapian-core" = fetch {
    name        = "xapian-core";
    version     = "1~1.4.9";
    filename    = "mingw-w64-x86_64-xapian-core-1~1.4.9-1-any.pkg.tar.xz";
    sha256      = "b94836ff525c7210c52105d8dfd6d6fa81bcd44d796af14db8488bfc617a61e7";
    buildInputs = [ gcc-libs zlib ];
  };

  "xavs" = fetch {
    name        = "xavs";
    version     = "0.1.55";
    filename    = "mingw-w64-x86_64-xavs-0.1.55-1-any.pkg.tar.xz";
    sha256      = "90eaf1ce843fb1c93f04e0ac90ef8a5e4dc7f9f5106ae19941245884d3055624";
    buildInputs = [ gcc-libs ];
  };

  "xerces-c" = fetch {
    name        = "xerces-c";
    version     = "3.2.2";
    filename    = "mingw-w64-x86_64-xerces-c-3.2.2-1-any.pkg.tar.xz";
    sha256      = "8f47bc2894d603d5b55dad1382d18affa2f5efcd6e250ecfe19d91f88fa703b8";
    buildInputs = [ gcc-libs icu ];
  };

  "xlnt" = fetch {
    name        = "xlnt";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-xlnt-1.3.0-1-any.pkg.tar.xz";
    sha256      = "37a2c1e40e8a1a8bd4ad7ecb76cb0d20dfdec01245e5c45c9ee728231a812f47";
    buildInputs = [ gcc-libs ];
  };

  "xmlsec" = fetch {
    name        = "xmlsec";
    version     = "1.2.27";
    filename    = "mingw-w64-x86_64-xmlsec-1.2.27-1-any.pkg.tar.xz";
    sha256      = "a3cc57477fe65f2244110548e69a862b50c59da2146bfca8313b0a250995f9a5";
    buildInputs = [ libxml2 libxslt openssl gnutls ];
  };

  "xmlstarlet-git" = fetch {
    name        = "xmlstarlet-git";
    version     = "r678.9a470e3";
    filename    = "mingw-w64-x86_64-xmlstarlet-git-r678.9a470e3-2-any.pkg.tar.xz";
    sha256      = "8dac059344173fd5a5d5564b699ebb013ea504501f997d570dacbfc01dd2575c";
    buildInputs = [ libxml2 libxslt ];
  };

  "xpdf" = fetch {
    name        = "xpdf";
    version     = "4.00";
    filename    = "mingw-w64-x86_64-xpdf-4.00-1-any.pkg.tar.xz";
    sha256      = "cca5204acd6cace8ec837e428844ea5fe7547c43243c387f269530dd8a21770b";
    buildInputs = [ freetype libjpeg-turbo libpaper libpng libtiff qt5 zlib ];
    broken      = true;
  };

  "xpm-nox" = fetch {
    name        = "xpm-nox";
    version     = "4.2.0";
    filename    = "mingw-w64-x86_64-xpm-nox-4.2.0-5-any.pkg.tar.xz";
    sha256      = "d8044ceaa86de8039b04308544ce2746221a952ceedcad16f923206939e574a6";
    buildInputs = [ gcc-libs ];
  };

  "xvidcore" = fetch {
    name        = "xvidcore";
    version     = "1.3.5";
    filename    = "mingw-w64-x86_64-xvidcore-1.3.5-1-any.pkg.tar.xz";
    sha256      = "18897c44b875168e55592ecb2e9729910604a4e8ec2d63d606ac2832922798ec";
  };

  "xxhash" = fetch {
    name        = "xxhash";
    version     = "0.6.5";
    filename    = "mingw-w64-x86_64-xxhash-0.6.5-1-any.pkg.tar.xz";
    sha256      = "cf191164a70f1361e491474579a841310168c40e9cd77bf65d5cca92a150ad78";
  };

  "xz" = fetch {
    name        = "xz";
    version     = "5.2.4";
    filename    = "mingw-w64-x86_64-xz-5.2.4-1-any.pkg.tar.xz";
    sha256      = "bc087fd8356cf9d3e67e076cc0e148c6ca73c907711472c9d4f13ecd5b9f78a3";
    buildInputs = [ gcc-libs gettext ];
  };

  "yajl" = fetch {
    name        = "yajl";
    version     = "2.1.0";
    filename    = "mingw-w64-x86_64-yajl-2.1.0-1-any.pkg.tar.xz";
    sha256      = "81a71d89fd7c31b0949adfeb173f37144350874a2b48e25a2b99b6158e364109";
  };

  "yaml-cpp" = fetch {
    name        = "yaml-cpp";
    version     = "0.6.2";
    filename    = "mingw-w64-x86_64-yaml-cpp-0.6.2-1-any.pkg.tar.xz";
    sha256      = "6f8fed470fe3d1d90a084101dc9d4904b750bace9802479f1c5e9a3adc3459f1";
    buildInputs = [  ];
  };

  "yaml-cpp0.3" = fetch {
    name        = "yaml-cpp0.3";
    version     = "0.3.0";
    filename    = "mingw-w64-x86_64-yaml-cpp0.3-0.3.0-2-any.pkg.tar.xz";
    sha256      = "334266e7861d5745cc3e637bee82c57555668a6ddc0d8292d108e165ddc581cb";
  };

  "yarn" = fetch {
    name        = "yarn";
    version     = "1.12.3";
    filename    = "mingw-w64-x86_64-yarn-1.12.3-1-any.pkg.tar.xz";
    sha256      = "ff713ed262e868e5ae211f91a0b62c603f63d92fd10f728a03d2aaa4ec9297f9";
    buildInputs = [ nodejs ];
    broken      = true;
  };

  "yasm" = fetch {
    name        = "yasm";
    version     = "1.3.0";
    filename    = "mingw-w64-x86_64-yasm-1.3.0-3-any.pkg.tar.xz";
    sha256      = "e2ed91d732df86d43a92760c0c611bc2aca5f4533b8ccde75499f2425035d4cf";
    buildInputs = [ gettext ];
  };

  "z3" = fetch {
    name        = "z3";
    version     = "4.8.4";
    filename    = "mingw-w64-x86_64-z3-4.8.4-1-any.pkg.tar.xz";
    sha256      = "5735fbe009b8ae81f4ca15247b27514d2a2bbba1895dd2f85da2eff9b2b6bc25";
    buildInputs = [  ];
  };

  "zbar" = fetch {
    name        = "zbar";
    version     = "0.20";
    filename    = "mingw-w64-x86_64-zbar-0.20-1-any.pkg.tar.xz";
    sha256      = "e3d8f306ed6e0272afb43d7b8b7e3dcb27f5cbd4fccea5a46786c6af9c94f482";
    buildInputs = [ imagemagick ];
    broken      = true;
  };

  "zeromq" = fetch {
    name        = "zeromq";
    version     = "4.3.0";
    filename    = "mingw-w64-x86_64-zeromq-4.3.0-1-any.pkg.tar.xz";
    sha256      = "2adcdf34b1632690b2a8be0923c6041063df8bc234ffc62322bf8dce738d8a41";
    buildInputs = [ libsodium ];
  };

  "zimg" = fetch {
    name        = "zimg";
    version     = "2.8";
    filename    = "mingw-w64-x86_64-zimg-2.8-2-any.pkg.tar.xz";
    sha256      = "157cec16db86a47c332a3ea3e6a739403094868dedda9ad5f7b8cec58d1e7096";
    buildInputs = [ gcc-libs winpthreads-git ];
  };

  "zlib" = fetch {
    name        = "zlib";
    version     = "1.2.11";
    filename    = "mingw-w64-x86_64-zlib-1.2.11-5-any.pkg.tar.xz";
    sha256      = "8c7088c5c0a1fa1f3ba2935da1c4728daf65c699b0fb688be03926ce9f763201";
    buildInputs = [ bzip2 ];
  };

  "zopfli" = fetch {
    name        = "zopfli";
    version     = "1.0.2";
    filename    = "mingw-w64-x86_64-zopfli-1.0.2-2-any.pkg.tar.xz";
    sha256      = "5564297f7626284ad7f9479c1bc8781652926537b0029ca8d93474e70e8a7411";
    buildInputs = [ gcc-libs ];
  };

  "zstd" = fetch {
    name        = "zstd";
    version     = "1.3.8";
    filename    = "mingw-w64-x86_64-zstd-1.3.8-1-any.pkg.tar.xz";
    sha256      = "caa96256afae5fcca8f20a185874d4c73db3f75d3dc612a2b3079ba3b100b144";
    buildInputs = [  ];
  };

  "zziplib" = fetch {
    name        = "zziplib";
    version     = "0.13.69";
    filename    = "mingw-w64-x86_64-zziplib-0.13.69-1-any.pkg.tar.xz";
    sha256      = "3840a76fa0ff025cf5f1846849d81e5f7fa32654010d1be60b4c47c5326ed576";
    buildInputs = [ zlib ];
  };

}; in self
