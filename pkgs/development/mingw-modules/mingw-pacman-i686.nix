 # GENERATED FILE
{stdenvNoCC, fetchurl, mingwPacman, msysPacman}:

let
  fetch = { pname, version, sources, buildInputs ? [], broken ? false }:
    if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
      stdenvNoCC.mkDerivation rec {
        inherit version buildInputs;
        name = "mingw32-${pname}-${version}";
        srcs = map ({filename, sha256}:
                    fetchurl {
                      url = "http://repo.msys2.org/mingw/i686/${filename}";
                      inherit sha256;
                    }) sources;
        PATH = stdenvNoCC.lib.concatMapStringsSep ";" (x: "${x}\\bin") stdenvNoCC.initialPath; # it adds 7z.exe to PATH
        builder = stdenvNoCC.lib.concatStringsSep " & " ( [ ''echo PATH=%PATH%'' ]
                                                       ++ map (src: ''7z x ${src} -so  |  7z x -aoa -si -ttar -o%out%'') srcs
                                                       ++ [ ''pushd %out%''
                                                            ''del .BUILDINFO .INSTALL .MTREE .PKGINFO'' ]
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
                    }) sources;
        sourceRoot = ".";
        buildPhase = if stdenvNoCC.isShellPerl /* on native windows */ then
          ''
            dircopy('.', $ENV{out}) or die "dircopy(., $ENV{out}): $!";
            ${ stdenvNoCC.lib.concatMapStringsSep "\n" (dep: ''
                  for my $path (glob('${dep}/*')) {
                    symtree_link($ENV{out}, $path, basename($path)) if basename($path) ne 'bin';
                  }
                '') buildInputs }
            chdir($ENV{out});
            ${ # avoid infinite recursion by skipping `bash' and `coreutils' and their deps (TODO: make a fake env to run post_install)
               stdenvNoCC.lib.optionalString (!(builtins.elem "mingw/${pname}" ["msys/msys2-runtime" "msys/bash" "msys/coreutils" "msys/gmp" "msys/gcc-libs" "msys/libiconv" "msys/libintl" "msys/libiconv+libintl"])) ''
                  if (-f ".INSTALL") {
                    $ENV{PATH} = '${msysPacman.bash}/usr/bin;${msysPacman.coreutils}/usr/bin';
                    system("bash -c \"ls -la ; . .INSTALL ; post_install || (echo 'post_install failed'; true)\"") == 0 or die;
                  }
                '' }
            unlinkL ".BUILDINFO";
            unlinkL ".INSTALL";
            unlinkL ".MTREE";
            unlinkL ".PKGINFO";
                   # make symlinks in /bin, mingw does not need it, it is only for nixpkgs convenience, to have the executables in $derivation/bin
                   # do not do it for msys, /bin/sh symlinked to /usr/bin/sh does not works as expected, it tries to assume the FHS root is at $0/../..
                   symtree_reify($ENV{out}, "bin/_");
                   for my $file (glob("$ENV{out}/mingw32/bin/*")) {
                     if (-f $file) {
                       uncsymlink($file => "$ENV{out}/bin/".basename($file)) or die "uncsymlink($file => $ENV{out}/bin/".basename($file)."): $!";
                     }
                   }
          ''
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
  bash = msysPacman.bash;
  winpty = msysPacman.winpty;
  python3 = mingwPacman.python3;

  "3proxy" = fetch {
    pname       = "3proxy";
    version     = "0.8.13";
    sources     = [{ filename = "mingw-w64-i686-3proxy-0.8.13-1-any.pkg.tar.xz"; sha256 = "741750728bb451b8722edba6ef35b92a35d0805cc6f870a687c18b16a16682d7"; }];
  };

  "4th" = fetch {
    pname       = "4th";
    version     = "3.62.5";
    sources     = [{ filename = "mingw-w64-i686-4th-3.62.5-1-any.pkg.tar.xz"; sha256 = "ca5f028d55ba7b17df2aa8578c5fde29111f2f6484860467733ebe57e895ceda"; }];
  };

  "FAudio" = fetch {
    pname       = "FAudio";
    version     = "20.09";
    sources     = [{ filename = "mingw-w64-i686-FAudio-20.09-1-any.pkg.tar.zst"; sha256 = "dd4627f9c512ca650a808627386b6c6fb2abf22801fe9696cb91f0bdc1e9f7bf"; }];
    buildInputs = [ SDL2 glib2 gstreamer gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "MinHook" = fetch {
    pname       = "MinHook";
    version     = "1.3.3";
    sources     = [{ filename = "mingw-w64-i686-MinHook-1.3.3-1-any.pkg.tar.xz"; sha256 = "1d3bdd393ca9a6e7ad1d777dd6b665110ad28fe134f3ca43c4f10de5afc4a844"; }];
  };

  "OpenSceneGraph" = fetch {
    pname       = "OpenSceneGraph";
    version     = "3.6.5";
    sources     = [{ filename = "mingw-w64-i686-OpenSceneGraph-3.6.5-5-any.pkg.tar.zst"; sha256 = "7cd2d3bc3761f113963c75adbbad44143461dba3db22d0a68998a7544c19e5d4"; }];
    buildInputs = [ boost collada-dom-svn curl ffmpeg fltk freetype gcc-libs gdal giflib gstreamer gtk2 gtkglext jasper libjpeg libpng libtiff libvncserver libxml2 lua SDL SDL2 poppler python wxWidgets zlib ];
  };

  "OpenSceneGraph-debug" = fetch {
    pname       = "OpenSceneGraph-debug";
    version     = "3.6.5";
    sources     = [{ filename = "mingw-w64-i686-OpenSceneGraph-debug-3.6.5-5-any.pkg.tar.zst"; sha256 = "b9251680b9a39bf5e2f5cfbda6bf44a03ba3116f03138ac60eeb6f17b7a2b0ee"; }];
    buildInputs = [ (assert OpenSceneGraph.version=="3.6.5"; OpenSceneGraph) ];
  };

  "SDL" = fetch {
    pname       = "SDL";
    version     = "1.2.15";
    sources     = [{ filename = "mingw-w64-i686-SDL-1.2.15-8-any.pkg.tar.xz"; sha256 = "8ad9ec75014a2fe529f639b67e5bcc5277b0fd6adc4946b3965f7cc5be3f6470"; }];
    buildInputs = [ gcc-libs libiconv ];
  };

  "SDL2" = fetch {
    pname       = "SDL2";
    version     = "2.0.12";
    sources     = [{ filename = "mingw-w64-i686-SDL2-2.0.12-5-any.pkg.tar.zst"; sha256 = "21deb4696ee41462d8e78a1ee169dfc0308fffc0dee87447b756425b2453afb3"; }];
    buildInputs = [ gcc-libs libiconv vulkan ];
  };

  "SDL2_gfx" = fetch {
    pname       = "SDL2_gfx";
    version     = "1.0.4";
    sources     = [{ filename = "mingw-w64-i686-SDL2_gfx-1.0.4-1-any.pkg.tar.xz"; sha256 = "41aa14e123af35c87ccf95e6ea8337233da4995fe89bd53851e6a863a188259a"; }];
    buildInputs = [ SDL2 ];
  };

  "SDL2_image" = fetch {
    pname       = "SDL2_image";
    version     = "2.0.5";
    sources     = [{ filename = "mingw-w64-i686-SDL2_image-2.0.5-1-any.pkg.tar.xz"; sha256 = "76dbaf96fb57c950b56731338e32256cc8e332c24400274690557c1d3bd20c51"; }];
    buildInputs = [ SDL2 libpng libtiff libjpeg-turbo libwebp ];
  };

  "SDL2_mixer" = fetch {
    pname       = "SDL2_mixer";
    version     = "2.0.4";
    sources     = [{ filename = "mingw-w64-i686-SDL2_mixer-2.0.4-2-any.pkg.tar.xz"; sha256 = "96a8534ba114e2ef17a17179e2c1d91ccc893e450e911f88e67191bf6c1d3939"; }];
    buildInputs = [ gcc-libs SDL2 flac fluidsynth libvorbis libmodplug mpg123 opusfile ];
  };

  "SDL2_net" = fetch {
    pname       = "SDL2_net";
    version     = "2.0.1";
    sources     = [{ filename = "mingw-w64-i686-SDL2_net-2.0.1-1-any.pkg.tar.xz"; sha256 = "4dc37d68ddaf1a1fb33da8613e226df2adb5aef207c2bf4f7a2e89038aaddc4b"; }];
    buildInputs = [ gcc-libs SDL2 ];
  };

  "SDL2_ttf" = fetch {
    pname       = "SDL2_ttf";
    version     = "2.0.15";
    sources     = [{ filename = "mingw-w64-i686-SDL2_ttf-2.0.15-1-any.pkg.tar.xz"; sha256 = "e5138f58838912409475d18c022adac108818a005ab0cdd9cb2b84b23654c887"; }];
    buildInputs = [ SDL2 freetype ];
  };

  "SDL_gfx" = fetch {
    pname       = "SDL_gfx";
    version     = "2.0.26";
    sources     = [{ filename = "mingw-w64-i686-SDL_gfx-2.0.26-1-any.pkg.tar.xz"; sha256 = "84048cd1d619843f24a7006a6663cfaef8d7c136eea02b68ddf81ad8d099df14"; }];
    buildInputs = [ SDL ];
  };

  "SDL_image" = fetch {
    pname       = "SDL_image";
    version     = "1.2.12";
    sources     = [{ filename = "mingw-w64-i686-SDL_image-1.2.12-6-any.pkg.tar.xz"; sha256 = "c6a5a6bd56cea1cfeb81c101fdc057626a38a0af577f7eaf09fe6577cf0fd39e"; }];
    buildInputs = [ SDL libjpeg-turbo libpng libtiff libwebp zlib ];
  };

  "SDL_mixer" = fetch {
    pname       = "SDL_mixer";
    version     = "1.2.12";
    sources     = [{ filename = "mingw-w64-i686-SDL_mixer-1.2.12-6-any.pkg.tar.xz"; sha256 = "713a32a690bb5bdd5215bc4b9e59706849d46264e9b8220278da3d3019f1229a"; }];
    buildInputs = [ SDL libvorbis libmikmod libmad flac ];
  };

  "SDL_net" = fetch {
    pname       = "SDL_net";
    version     = "1.2.8";
    sources     = [{ filename = "mingw-w64-i686-SDL_net-1.2.8-2-any.pkg.tar.xz"; sha256 = "3968125e2bd1882b30027280ec56c1eae7c3e2c93535e4afc48f98ef9b45a4fc"; }];
    buildInputs = [ SDL ];
  };

  "SDL_ttf" = fetch {
    pname       = "SDL_ttf";
    version     = "2.0.11";
    sources     = [{ filename = "mingw-w64-i686-SDL_ttf-2.0.11-5-any.pkg.tar.xz"; sha256 = "9a2b1c5d12107f9786a44c7a2ad26355d661f9c42c2969e1b05437ac286c3361"; }];
    buildInputs = [ SDL freetype ];
  };

  "a52dec" = fetch {
    pname       = "a52dec";
    version     = "0.7.4";
    sources     = [{ filename = "mingw-w64-i686-a52dec-0.7.4-4-any.pkg.tar.xz"; sha256 = "d73c4eb92801c9069c2a40ebbe48464042dde401cd71c4788fec914937c742d0"; }];
  };

  "adns" = fetch {
    pname       = "adns";
    version     = "1.4.g10.7";
    sources     = [{ filename = "mingw-w64-i686-adns-1.4.g10.7-1-any.pkg.tar.xz"; sha256 = "a16b45a41c850cf6ada155b7bdaa795438b3da60b15f65a3777712b816c8a8d0"; }];
    buildInputs = [ gcc-libs ];
  };

  "adobe-source-code-pro-fonts" = fetch {
    pname       = "adobe-source-code-pro-fonts";
    version     = "2.030ro+1.050it";
    sources     = [{ filename = "mingw-w64-i686-adobe-source-code-pro-fonts-2.030ro+1.050it-1-any.pkg.tar.xz"; sha256 = "70cfd68426dfc67a44215b8a5a5f252297a8fe018bc87d151f9a4d17b563d798"; }];
  };

  "adwaita-icon-theme" = fetch {
    pname       = "adwaita-icon-theme";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-adwaita-icon-theme-3.38.0-1-any.pkg.tar.zst"; sha256 = "5585566b96d9f23e621754b9f0559e1ae4a4b4a5321ee90e76f8356f6844c99f"; }];
    buildInputs = [ hicolor-icon-theme librsvg ];
  };

  "ag" = fetch {
    pname       = "ag";
    version     = "2.2.0";
    sources     = [{ filename = "mingw-w64-i686-ag-2.2.0-2-any.pkg.tar.zst"; sha256 = "e2a7741d18a4f9a90a3f7e2d524ea4f4bbaa49c6d30b3dbb4575815c73ffe4ec"; }];
    buildInputs = [ pcre xz zlib ];
  };

  "alembic" = fetch {
    pname       = "alembic";
    version     = "1.7.14";
    sources     = [{ filename = "mingw-w64-i686-alembic-1.7.14-1-any.pkg.tar.zst"; sha256 = "41d7e8e556b3b3a2c3f416fef3af17c4b15599a73a92bd1e19f6060b44744873"; }];
    buildInputs = [ openexr boost hdf5 zlib ];
  };

  "allegro" = fetch {
    pname       = "allegro";
    version     = "5.2.6.0";
    sources     = [{ filename = "mingw-w64-i686-allegro-5.2.6.0-1-any.pkg.tar.xz"; sha256 = "5ee9c8f291d57af2b07cfd8f0a20213f78e3a206def2d345105ce7dbfe2c5ff3"; }];
    buildInputs = [ gcc-libs ];
  };

  "alure" = fetch {
    pname       = "alure";
    version     = "1.2";
    sources     = [{ filename = "mingw-w64-i686-alure-1.2-1-any.pkg.tar.xz"; sha256 = "16899b9c9642c51fd8c745695a843adee88f1c3024b71f95be8fe10b5266283b"; }];
    buildInputs = [ openal ];
  };

  "amqp-cpp" = fetch {
    pname       = "amqp-cpp";
    version     = "4.1.6";
    sources     = [{ filename = "mingw-w64-i686-amqp-cpp-4.1.6-2-any.pkg.tar.zst"; sha256 = "2b3b25b1237054f64723e114bbb12d1508b347d13d535fdce41a9c001db21f95"; }];
  };

  "amtk" = fetch {
    pname       = "amtk";
    version     = "5.2.0";
    sources     = [{ filename = "mingw-w64-i686-amtk-5.2.0-2-any.pkg.tar.zst"; sha256 = "dce0495293d9ee20767d2e63ea737db4f5cef7a3597c98d711d3a145f3cb42ec"; }];
    buildInputs = [ gtk3 ];
  };

  "ansicon-git" = fetch {
    pname       = "ansicon-git";
    version     = "1.70.r65.3acc7a9";
    sources     = [{ filename = "mingw-w64-i686-ansicon-git-1.70.r65.3acc7a9-2-any.pkg.tar.xz"; sha256 = "9de19536afa7968807150b96dc3c7104e7315db0938a695034288ee3cfe82bfb"; }];
  };

  "antiword" = fetch {
    pname       = "antiword";
    version     = "0.37";
    sources     = [{ filename = "mingw-w64-i686-antiword-0.37-2-any.pkg.tar.xz"; sha256 = "b8dfcf3dde2a65d62941dacaad3cdc49c6f9ca4080144118c9d46207022d39b1"; }];
  };

  "antlr3" = fetch {
    pname       = "antlr3";
    version     = "3.5.2";
    sources     = [{ filename = "mingw-w64-i686-antlr3-3.5.2-1-any.pkg.tar.xz"; sha256 = "6ba14d0882f7e2f241fe02945126545103ec53eea452c73226bc600afbef618e"; }];
  };

  "antlr4-runtime-cpp" = fetch {
    pname       = "antlr4-runtime-cpp";
    version     = "4.8";
    sources     = [{ filename = "mingw-w64-i686-antlr4-runtime-cpp-4.8-1-any.pkg.tar.xz"; sha256 = "52592a5c6d342de530dd6eb31b62e9e2078e72e0c3619bfb3da4044d94b8b7c6"; }];
  };

  "aom" = fetch {
    pname       = "aom";
    version     = "2.0.0";
    sources     = [{ filename = "mingw-w64-i686-aom-2.0.0-3-any.pkg.tar.zst"; sha256 = "055813777ec99a6105c89d17d47e9c3383db64b222ce5247c35ca999234b0428"; }];
    buildInputs = [ gcc-libs ];
  };

  "appstream-glib" = fetch {
    pname       = "appstream-glib";
    version     = "0.7.18";
    sources     = [{ filename = "mingw-w64-i686-appstream-glib-0.7.18-1-any.pkg.tar.zst"; sha256 = "4a09ba1edbba702c8eb65a31bca3b1fbca84f0fac19ed069d51f4328f9841fc0"; }];
    buildInputs = [ gdk-pixbuf2 glib2 gtk3 json-glib libyaml libsoup libarchive ];
  };

  "apr" = fetch {
    pname       = "apr";
    version     = "1.6.5";
    sources     = [{ filename = "mingw-w64-i686-apr-1.6.5-3-any.pkg.tar.zst"; sha256 = "349636ccec36ee59d9915802eef917e44dee5da72242667091714dadc82befdb"; }];
  };

  "apr-util" = fetch {
    pname       = "apr-util";
    version     = "1.6.1";
    sources     = [{ filename = "mingw-w64-i686-apr-util-1.6.1-2-any.pkg.tar.zst"; sha256 = "3be1d67e44a0af93655dd503b7d3edc7e04bb658674077609c0db0402b088592"; }];
    buildInputs = [ apr expat libmariadbclient sqlite3 unixodbc postgresql openldap nss gdbm openssl ];
  };

  "argon2" = fetch {
    pname       = "argon2";
    version     = "20190702";
    sources     = [{ filename = "mingw-w64-i686-argon2-20190702-1-any.pkg.tar.xz"; sha256 = "c2cf8fccdbb5fd6248b6904d096f0b9c28b4cd14543f8379d2e3a0264e372ddc"; }];
  };

  "argtable" = fetch {
    pname       = "argtable";
    version     = "2.13";
    sources     = [{ filename = "mingw-w64-i686-argtable-2.13-1-any.pkg.tar.zst"; sha256 = "ce59816d8054ce2b8a59c5121f8cfd8a31bb8c9c6604ee1541488a75477db57f"; }];
  };

  "aria2" = fetch {
    pname       = "aria2";
    version     = "1.35.0";
    sources     = [{ filename = "mingw-w64-i686-aria2-1.35.0-2-any.pkg.tar.xz"; sha256 = "5a527637e4f867914200da5ea38968b4d9bf6afb9e659e89e76b49748f2430b8"; }];
    buildInputs = [ gcc-libs gettext c-ares cppunit libiconv libssh2 libuv libxml2 openssl sqlite3 zlib ];
  };

  "aribb24" = fetch {
    pname       = "aribb24";
    version     = "1.0.3";
    sources     = [{ filename = "mingw-w64-i686-aribb24-1.0.3-3-any.pkg.tar.xz"; sha256 = "aeb49b3ff7aeb13193344f2ba6966e9b0c295a1f8337063c3616e9d5dee7d14f"; }];
    buildInputs = [ libpng ];
  };

  "arm-none-eabi-binutils" = fetch {
    pname       = "arm-none-eabi-binutils";
    version     = "2.35";
    sources     = [{ filename = "mingw-w64-i686-arm-none-eabi-binutils-2.35-1-any.pkg.tar.zst"; sha256 = "577f1304cad32c29e9c2b2e6f9540942bba06188aeefa8b1fd053caaac8d07e9"; }];
  };

  "arm-none-eabi-gcc" = fetch {
    pname       = "arm-none-eabi-gcc";
    version     = "8.4.0";
    sources     = [{ filename = "mingw-w64-i686-arm-none-eabi-gcc-8.4.0-3-any.pkg.tar.zst"; sha256 = "47c60fa3b30acd163e98757c8b91085abe940a550456a24be57a86a270170eb3"; }];
    buildInputs = [ arm-none-eabi-binutils arm-none-eabi-newlib isl mpc zlib ];
  };

  "arm-none-eabi-gdb" = fetch {
    pname       = "arm-none-eabi-gdb";
    version     = "9.2";
    sources     = [{ filename = "mingw-w64-i686-arm-none-eabi-gdb-9.2-2-any.pkg.tar.zst"; sha256 = "189c8582382a2c31bdda351c40df03a2b89b5e588ed45dcfa3708a7af6cd2bce"; }];
    buildInputs = [ expat libiconv ncurses python readline xxhash zlib ];
  };

  "arm-none-eabi-newlib" = fetch {
    pname       = "arm-none-eabi-newlib";
    version     = "3.3.0";
    sources     = [{ filename = "mingw-w64-i686-arm-none-eabi-newlib-3.3.0-1-any.pkg.tar.zst"; sha256 = "a6d558a9829b129d47b5e88ceb1677909379d2c2274954439134d06eece3b92d"; }];
    buildInputs = [ arm-none-eabi-binutils ];
  };

  "armadillo" = fetch {
    pname       = "armadillo";
    version     = "9.900.1";
    sources     = [{ filename = "mingw-w64-i686-armadillo-9.900.1-2-any.pkg.tar.zst"; sha256 = "197f101a226eff5c9ad3603084bba11f60676304ba2a0859d1ebb356f739eede"; }];
    buildInputs = [ gcc-libs arpack hdf5 openblas ];
  };

  "arpack" = fetch {
    pname       = "arpack";
    version     = "3.7.0";
    sources     = [{ filename = "mingw-w64-i686-arpack-3.7.0-2-any.pkg.tar.xz"; sha256 = "45e09c25907994a85ea7d29494ebf783e7fde2284288915d1b53526df0fb7f40"; }];
    buildInputs = [ gcc-libgfortran openblas ];
  };

  "arrow" = fetch {
    pname       = "arrow";
    version     = "1.0.1";
    sources     = [{ filename = "mingw-w64-i686-arrow-1.0.1-1-any.pkg.tar.zst"; sha256 = "bdedd793430c2972dcdcadd19319dd0fa63e5981b73845b022d10ef0deb5a08f"; }];
    buildInputs = [ boost brotli bzip2 double-conversion flatbuffers gflags gobject-introspection grpc libutf8proc lz4 openssl protobuf python3-numpy rapidjson re2 snappy thrift uriparser zlib zstd ];
    broken      = true; # broken dependency arrow -> python3-numpy
  };

  "asciidoc" = fetch {
    pname       = "asciidoc";
    version     = "9.0.3";
    sources     = [{ filename = "mingw-w64-i686-asciidoc-9.0.3-1-any.pkg.tar.zst"; sha256 = "500f0fd4397dd06c9d37dffae87300b84823318dee68911e7ad7fec6ba8eea7c"; }];
    buildInputs = [ python libxslt docbook-xsl ];
  };

  "asciidoctor" = fetch {
    pname       = "asciidoctor";
    version     = "2.0.10";
    sources     = [{ filename = "mingw-w64-i686-asciidoctor-2.0.10-2-any.pkg.tar.xz"; sha256 = "0891a9f72f60ed319198cbbcbdd88a3f9f5eefc6d2b835b4e0344244a7f9c546"; }];
    buildInputs = [ ruby ];
  };

  "asio" = fetch {
    pname       = "asio";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-asio-1.18.0-1-any.pkg.tar.zst"; sha256 = "b4df959c120c92686bcd72a9ca8f0f31c8c0e46fa304c043fbdcddf9396292c7"; }];
  };

  "aspell" = fetch {
    pname       = "aspell";
    version     = "0.60.7";
    sources     = [{ filename = "mingw-w64-i686-aspell-0.60.7-1-any.pkg.tar.xz"; sha256 = "1dca22a717ed9ecd2fc7b53abfbb2cfcac3c81776443ab39414c2595ac4ecdda"; }];
    buildInputs = [ gcc-libs libiconv gettext ];
  };

  "aspell-de" = fetch {
    pname       = "aspell-de";
    version     = "20161207";
    sources     = [{ filename = "mingw-w64-i686-aspell-de-20161207-2-any.pkg.tar.xz"; sha256 = "8940fa4147d42c0f83a83884c5121e5893b6c7664d6a663972ec14bdd895f0d5"; }];
    buildInputs = [ aspell ];
  };

  "aspell-en" = fetch {
    pname       = "aspell-en";
    version     = "2019.10.06";
    sources     = [{ filename = "mingw-w64-i686-aspell-en-2019.10.06-1-any.pkg.tar.xz"; sha256 = "6d4ce18e7d0076adb5ea9009d5807a87c7b92bdbae538fdc05d560f060783e83"; }];
    buildInputs = [ aspell ];
  };

  "aspell-es" = fetch {
    pname       = "aspell-es";
    version     = "1.11.2";
    sources     = [{ filename = "mingw-w64-i686-aspell-es-1.11.2-1-any.pkg.tar.xz"; sha256 = "1ec62c48a35657fff3a54795a4b5b2d1d6b9e52e0ee30c0894ef49b1a524d724"; }];
    buildInputs = [ aspell ];
  };

  "aspell-fr" = fetch {
    pname       = "aspell-fr";
    version     = "0.50.3";
    sources     = [{ filename = "mingw-w64-i686-aspell-fr-0.50.3-1-any.pkg.tar.xz"; sha256 = "73bd4b0a651f153ae5877d5455c5d08755b4c467f052c756e4c17a18b4300b1a"; }];
    buildInputs = [ aspell ];
  };

  "aspell-ru" = fetch {
    pname       = "aspell-ru";
    version     = "0.99f7.1";
    sources     = [{ filename = "mingw-w64-i686-aspell-ru-0.99f7.1-1-any.pkg.tar.xz"; sha256 = "b847731c943babba48f940448198a46fbeb830d13d4dd4a31d1ed4c4458dca79"; }];
    buildInputs = [ aspell ];
  };

  "assimp" = fetch {
    pname       = "assimp";
    version     = "5.0.1";
    sources     = [{ filename = "mingw-w64-i686-assimp-5.0.1-3-any.pkg.tar.zst"; sha256 = "b01e328cb6155533fe9b28ba4f9f1d9e5441682bf0fef8ec9867501b66a031a8"; }];
    buildInputs = [ minizip-git zziplib zlib ];
  };

  "astyle" = fetch {
    pname       = "astyle";
    version     = "3.1";
    sources     = [{ filename = "mingw-w64-i686-astyle-3.1-1-any.pkg.tar.xz"; sha256 = "83639f9828d919c89148ff88bb12b29a57ba3815b3e74202e1096186898f357a"; }];
    buildInputs = [ gcc-libs ];
  };

  "atk" = fetch {
    pname       = "atk";
    version     = "2.36.0";
    sources     = [{ filename = "mingw-w64-i686-atk-2.36.0-1-any.pkg.tar.xz"; sha256 = "9c604c3d8ee623f845029e4ac09c9db89934c5d58598ef447cbbd0620c250e42"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.46.0"; glib2) ];
  };

  "atkmm" = fetch {
    pname       = "atkmm";
    version     = "2.28.0";
    sources     = [{ filename = "mingw-w64-i686-atkmm-2.28.0-1-any.pkg.tar.xz"; sha256 = "d9bf262b7541261b75f04575c15c5ce46ae6a27fbc879504d67798a4a209e2b3"; }];
    buildInputs = [ atk gcc-libs glibmm self."libsigc++" ];
  };

  "attica-qt5" = fetch {
    pname       = "attica-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-attica-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "1ae18c5f1ad6cf48060ceca562cfbe2c6455fe478f8581211cfeb71d2a65c4ad"; }];
    buildInputs = [ qt5 ];
  };

  "audaspace" = fetch {
    pname       = "audaspace";
    version     = "1.3.0";
    sources     = [{ filename = "mingw-w64-i686-audaspace-1.3.0-2-any.pkg.tar.xz"; sha256 = "83bdd5f99018c7a06e013ad4fc89b76827ef27b08f68fe90092c000360a119f9"; }];
    buildInputs = [ ffmpeg fftw libsndfile openal python3 python3-numpy SDL2 ];
    broken      = true; # broken dependency audaspace -> python3-numpy
  };

  "avr-binutils" = fetch {
    pname       = "avr-binutils";
    version     = "2.35";
    sources     = [{ filename = "mingw-w64-i686-avr-binutils-2.35-3-any.pkg.tar.zst"; sha256 = "bee03655f4c1b3be10b4fc019d7b7f6fbf3d24591013a233026667986aeb9bb3"; }];
  };

  "avr-gcc" = fetch {
    pname       = "avr-gcc";
    version     = "8.4.0";
    sources     = [{ filename = "mingw-w64-i686-avr-gcc-8.4.0-4-any.pkg.tar.zst"; sha256 = "2070f33c35ec7f8e27f3ebffc40be92032a7c98cb58a0af674fa982eb3aa6042"; }];
    buildInputs = [ avr-binutils gmp isl mpc mpfr ];
  };

  "avr-gdb" = fetch {
    pname       = "avr-gdb";
    version     = "9.2";
    sources     = [{ filename = "mingw-w64-i686-avr-gdb-9.2-3-any.pkg.tar.zst"; sha256 = "327fba790ed28906ed21794cf1c1668432fabd10d728deffac1a5a7abf350403"; }];
  };

  "avr-libc" = fetch {
    pname       = "avr-libc";
    version     = "2.0.0";
    sources     = [{ filename = "mingw-w64-i686-avr-libc-2.0.0-3-any.pkg.tar.zst"; sha256 = "6b4591fe6635876dce5f169696f5ca835a63edb520b6b6c80963c5b31bbc3cc3"; }];
    buildInputs = [ avr-gcc ];
  };

  "avrdude" = fetch {
    pname       = "avrdude";
    version     = "6.3";
    sources     = [{ filename = "mingw-w64-i686-avrdude-6.3-2-any.pkg.tar.xz"; sha256 = "67d63a0fc6e4434ffc413b2c07fdcc289501ee77c4d33c7525b603c5c3e8db6b"; }];
    buildInputs = [ libftdi libusb libusb-compat-git libelf ];
  };

  "aws-sdk-cpp" = fetch {
    pname       = "aws-sdk-cpp";
    version     = "1.7.365";
    sources     = [{ filename = "mingw-w64-i686-aws-sdk-cpp-1.7.365-2-any.pkg.tar.zst"; sha256 = "bf727972be67e50bb5382fb45ddc43fd6a1160dcc7d26f2c6d1ce3283f7001ed"; }];
  };

  "aztecgen" = fetch {
    pname       = "aztecgen";
    version     = "1.0.1";
    sources     = [{ filename = "mingw-w64-i686-aztecgen-1.0.1-1-any.pkg.tar.xz"; sha256 = "6eab6ec81927b8efe391727de9fef738b22eb102c222d91e7d91179cf7677acc"; }];
  };

  "babl" = fetch {
    pname       = "babl";
    version     = "0.1.82";
    sources     = [{ filename = "mingw-w64-i686-babl-0.1.82-1-any.pkg.tar.zst"; sha256 = "65381fd3f61590155a7666f62dc48d4b55942288e8a461fef7127e3bf43e14f8"; }];
    buildInputs = [ gcc-libs ];
  };

  "badvpn" = fetch {
    pname       = "badvpn";
    version     = "1.999.130";
    sources     = [{ filename = "mingw-w64-i686-badvpn-1.999.130-2-any.pkg.tar.xz"; sha256 = "d65842dbf8483d1e4db63ec697b940bd7bf027801d5b482f328dfa087c8ec658"; }];
    buildInputs = [ glib2 nspr nss openssl ];
  };

  "baobab" = fetch {
    pname       = "baobab";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-baobab-3.38.0-1-any.pkg.tar.zst"; sha256 = "d1b428bdb6a6599924457d16908ba16ae5b309af32b3dc500040223eae9e7094"; }];
    buildInputs = [ gsettings-desktop-schemas gobject-introspection-runtime librsvg ];
  };

  "bc" = fetch {
    pname       = "bc";
    version     = "1.06";
    sources     = [{ filename = "mingw-w64-i686-bc-1.06-2-any.pkg.tar.zst"; sha256 = "36ae93ee97248eb273ad18b3cc34037854614599a52dceba8bffb3f5f38a4ac9"; }];
  };

  "bcunit" = fetch {
    pname       = "bcunit";
    version     = "3.0.2";
    sources     = [{ filename = "mingw-w64-i686-bcunit-3.0.2-1-any.pkg.tar.xz"; sha256 = "a3271a76a26f9485d34c6dd280da3cf977948a243ff699671ac7157c66d3d21c"; }];
  };

  "benchmark" = fetch {
    pname       = "benchmark";
    version     = "1.5.0";
    sources     = [{ filename = "mingw-w64-i686-benchmark-1.5.0-1-any.pkg.tar.xz"; sha256 = "eb47eb78f821dfbe9e981de10f190f51266e38158ffa0bf4951c5ae2e72fb9e1"; }];
    buildInputs = [ gcc-libs ];
  };

  "binaryen" = fetch {
    pname       = "binaryen";
    version     = "98";
    sources     = [{ filename = "mingw-w64-i686-binaryen-98-1-any.pkg.tar.zst"; sha256 = "dde0ae01a8a73a7f6d88f690ced8860fd28afe328970794998fe9f77f5ad1fe0"; }];
  };

  "binutils" = fetch {
    pname       = "binutils";
    version     = "2.35.1";
    sources     = [{ filename = "mingw-w64-i686-binutils-2.35.1-2-any.pkg.tar.zst"; sha256 = "5815efacf8082dee1f7fe532f301730fa30c92e25c89508421ace0ebbdeaba7b"; }];
    buildInputs = [ libiconv zlib ];
  };

  "blender" = fetch {
    pname       = "blender";
    version     = "2.82.a";
    sources     = [{ filename = "mingw-w64-i686-blender-2.82.a-1-any.pkg.tar.xz"; sha256 = "93b86f80eaac979aa05787dc9bc167fec33f021fda0bd7f39b1bfc492688eae0"; }];
    buildInputs = [ alembic audaspace boost llvm eigen3 glew ffmpeg fftw freetype hdf5 intel-tbb libpng libsndfile libtiff lzo2 openal opencollada opencolorio openexr openjpeg2 openimageio openshadinglanguage pcre pugixml python3 python3-numpy SDL2 wintab-sdk zlib ];
    broken      = true; # broken dependency audaspace -> python3-numpy
  };

  "blosc" = fetch {
    pname       = "blosc";
    version     = "1.20.1";
    sources     = [{ filename = "mingw-w64-i686-blosc-1.20.1-1-any.pkg.tar.zst"; sha256 = "fca9d24c9fe0402d0d999d832fddfc9ad8a32ad9ac5e79a6a044b0f77fb83c7a"; }];
    buildInputs = [ snappy zstd zlib lz4 ];
  };

  "bmake" = fetch {
    pname       = "bmake";
    version     = "20181221";
    sources     = [{ filename = "mingw-w64-i686-bmake-20181221-6-any.pkg.tar.zst"; sha256 = "99e18932ba396d664a1e8d132c1c13375a5cd3f8fca4803eaebf0d01f8eddc0f"; }];
    buildInputs = [ binutils python libiconv ];
  };

  "boost" = fetch {
    pname       = "boost";
    version     = "1.74.0";
    sources     = [{ filename = "mingw-w64-i686-boost-1.74.0-1-any.pkg.tar.zst"; sha256 = "97c36cdd9ac5b3d3bdebbc7d7780a649e478f3000c2732946d7ba6fe1e101044"; }];
    buildInputs = [ gcc-libs bzip2 icu zlib ];
  };

  "bootloadhid" = fetch {
    pname       = "bootloadhid";
    version     = "20121208";
    sources     = [{ filename = "mingw-w64-i686-bootloadhid-20121208-1-any.pkg.tar.xz"; sha256 = "a8acc0b7cab92f983ba1ff806aa6d3e7a91bcbaee99967fbc04ab020b83ee598"; }];
  };

  "box2d" = fetch {
    pname       = "box2d";
    version     = "2.3.1";
    sources     = [{ filename = "mingw-w64-i686-box2d-2.3.1-2-any.pkg.tar.xz"; sha256 = "f2e11ecf0d9438121c880d83b2dd21a4a7d5538081befabf4ccb58a2fe06ed13"; }];
  };

  "breakpad-git" = fetch {
    pname       = "breakpad-git";
    version     = "r1680.70914b2d";
    sources     = [{ filename = "mingw-w64-i686-breakpad-git-r1680.70914b2d-1-any.pkg.tar.xz"; sha256 = "d0e1988e2268bfa036a56164d57e496b5a30660b69b7deca9dac25861d5c9be3"; }];
    buildInputs = [ gcc-libs ];
  };

  "breeze-icons-qt5" = fetch {
    pname       = "breeze-icons-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-breeze-icons-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "61f844a440ab20696eee11306f02aa3b2ef6de1a4d04a8ee83be6c33103d1146"; }];
    buildInputs = [ qt5 ];
  };

  "brotli" = fetch {
    pname       = "brotli";
    version     = "1.0.9";
    sources     = [{ filename = "mingw-w64-i686-brotli-1.0.9-1-any.pkg.tar.zst"; sha256 = "5e269d9a67653eee1f7d5b4089588f99130d4f1e073f479f49c51bb428a851fd"; }];
    buildInputs = [  ];
  };

  "brotli-testdata" = fetch {
    pname       = "brotli-testdata";
    version     = "1.0.9";
    sources     = [{ filename = "mingw-w64-i686-brotli-testdata-1.0.9-1-any.pkg.tar.zst"; sha256 = "31263cd53a2697b597a44dc7bbd3ad73a4660d82c9498a03736d1e100aeb8190"; }];
    buildInputs = [ brotli ];
  };

  "bsdfprocessor" = fetch {
    pname       = "bsdfprocessor";
    version     = "1.2.1";
    sources     = [{ filename = "mingw-w64-i686-bsdfprocessor-1.2.1-1-any.pkg.tar.xz"; sha256 = "db577d7affb7389c2ccf316cdec17aedfab4845e69de2d459e18d1ee0003ab6a"; }];
    buildInputs = [ gcc-libs qt5 OpenSceneGraph ];
  };

  "btyacc" = fetch {
    pname       = "btyacc";
    version     = "3.0";
    sources     = [{ filename = "mingw-w64-i686-btyacc-3.0-1-any.pkg.tar.zst"; sha256 = "5a31b3f76dac798fd3c03b82fce5497859306c1d48faae5cba65e4d94efff169"; }];
  };

  "bullet" = fetch {
    pname       = "bullet";
    version     = "2.87";
    sources     = [{ filename = "mingw-w64-i686-bullet-2.87-2-any.pkg.tar.xz"; sha256 = "9d2e0d0a1a4bbf07f71f0cf733f42b187cf94985b5a7ba9aa2257d36ee5603eb"; }];
    buildInputs = [ gcc-libs freeglut openvr ];
  };

  "bullet-debug" = fetch {
    pname       = "bullet-debug";
    version     = "2.87";
    sources     = [{ filename = "mingw-w64-i686-bullet-debug-2.87-2-any.pkg.tar.xz"; sha256 = "c30e352d97e7449f1c93e6aa1cdf064fd120b70d6ccbd6fef76ec52fb2467312"; }];
    buildInputs = [ (assert bullet.version=="2.87"; bullet) ];
  };

  "butler" = fetch {
    pname       = "butler";
    version     = "15.20";
    sources     = [{ filename = "mingw-w64-i686-butler-15.20-1-any.pkg.tar.zst"; sha256 = "9ce546a29338dc4b88eece9efc7c553be22dc8a206fe9dbcda2d90fdf70f2101"; }];
  };

  "bwidget" = fetch {
    pname       = "bwidget";
    version     = "1.9.14";
    sources     = [{ filename = "mingw-w64-i686-bwidget-1.9.14-1-any.pkg.tar.xz"; sha256 = "86906713db454894608e1f7bebe2ddf8ff4375c6d202d4779f7f0f329a0ece04"; }];
    buildInputs = [ tk ];
  };

  "bzip2" = fetch {
    pname       = "bzip2";
    version     = "1.0.8";
    sources     = [{ filename = "mingw-w64-i686-bzip2-1.0.8-1-any.pkg.tar.xz"; sha256 = "598bbaba996ed920a0d210c8182edbdf73a9df33b0c80b20fad1fb4a06a3fed0"; }];
    buildInputs = [ gcc-libs ];
  };

  "c-ares" = fetch {
    pname       = "c-ares";
    version     = "1.16.1";
    sources     = [{ filename = "mingw-w64-i686-c-ares-1.16.1-1-any.pkg.tar.zst"; sha256 = "597209ae2bdd1a4f1528e89650e3a501c40cbedb7e80f561a79fcbf351ae2182"; }];
    buildInputs = [  ];
  };

  "c99-to-c89-git" = fetch {
    pname       = "c99-to-c89-git";
    version     = "r169.b3d496d";
    sources     = [{ filename = "mingw-w64-i686-c99-to-c89-git-r169.b3d496d-1-any.pkg.tar.xz"; sha256 = "bb951699836d5e4ccf70d95e1ee159e62756ab65ed381fae1d3242f1a4375b6a"; }];
    buildInputs = [ clang ];
  };

  "ca-certificates" = fetch {
    pname       = "ca-certificates";
    version     = "20200601";
    sources     = [{ filename = "mingw-w64-i686-ca-certificates-20200601-1-any.pkg.tar.zst"; sha256 = "be250f7fcc1bef81dfff40856bb791019b03d6ae799a8201f64c915a766de0ad"; }];
    buildInputs = [ p11-kit ];
  };

  "cairo" = fetch {
    pname       = "cairo";
    version     = "1.17.2";
    sources     = [{ filename = "mingw-w64-i686-cairo-1.17.2-2-any.pkg.tar.zst"; sha256 = "d6743ebeec5cba0962384c6503a2392a4cf7fe5754522ef5b56ae03242c0a61d"; }];
    buildInputs = [ gcc-libs freetype fontconfig lzo2 pixman libpng zlib ];
  };

  "cairomm" = fetch {
    pname       = "cairomm";
    version     = "1.12.2";
    sources     = [{ filename = "mingw-w64-i686-cairomm-1.12.2-2-any.pkg.tar.xz"; sha256 = "86b66ec2e620d172f10db3416ddfbba80a414972dbf29d354ac59cc0ab96fd06"; }];
    buildInputs = [ self."libsigc++" cairo ];
  };

  "cantarell-fonts" = fetch {
    pname       = "cantarell-fonts";
    version     = "0.201";
    sources     = [{ filename = "mingw-w64-i686-cantarell-fonts-0.201-1-any.pkg.tar.xz"; sha256 = "6af0da240cc0c27099add03660e021f09a024bf0cfd1512deb8d0206222f5b31"; }];
    buildInputs = [  ];
  };

  "capnproto" = fetch {
    pname       = "capnproto";
    version     = "0.8.0";
    sources     = [{ filename = "mingw-w64-i686-capnproto-0.8.0-3-any.pkg.tar.zst"; sha256 = "4feb3c85b7d66cd841a9002b61e6b6997abf35af116f675f646ab0f5c6a57a3a"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "capstone" = fetch {
    pname       = "capstone";
    version     = "4.0.2";
    sources     = [{ filename = "mingw-w64-i686-capstone-4.0.2-1-any.pkg.tar.zst"; sha256 = "80e6d5cf587b3376dad5de750ac16db3b2a409bc1e7e23b832f319ed88d57c10"; }];
    buildInputs = [ gcc-libs ];
  };

  "cargo-c" = fetch {
    pname       = "cargo-c";
    version     = "0.6.10";
    sources     = [{ filename = "mingw-w64-i686-cargo-c-0.6.10-1-any.pkg.tar.zst"; sha256 = "1fdb3424702c261f02a1ca17d7bf47b757c49bc85c98b7d45148585b685b8773"; }];
    buildInputs = [ curl openssl libgit2 zlib ];
  };

  "catch" = fetch {
    pname       = "catch";
    version     = "2.13.1";
    sources     = [{ filename = "mingw-w64-i686-catch-2.13.1-1-any.pkg.tar.zst"; sha256 = "a2ad311dc702eca35b137bec31f90f1b27e74bd19035fdf6ce20e8505a8bf214"; }];
  };

  "ccache" = fetch {
    pname       = "ccache";
    version     = "3.7.9";
    sources     = [{ filename = "mingw-w64-i686-ccache-3.7.9-1-any.pkg.tar.xz"; sha256 = "929400c5861982905353023cf40ffd158fbb1e925df657c71f78cb6eec3811db"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "cccl" = fetch {
    pname       = "cccl";
    version     = "1.0";
    sources     = [{ filename = "mingw-w64-i686-cccl-1.0-1-any.pkg.tar.xz"; sha256 = "4821c594f85d151695684e932e6d82cd2835fc08c16d1be4e43c3e4559934cde"; }];
  };

  "cego" = fetch {
    pname       = "cego";
    version     = "2.45.28";
    sources     = [{ filename = "mingw-w64-i686-cego-2.45.28-1-any.pkg.tar.zst"; sha256 = "6386be55b62c1770b06ecc883a3d47103bead31d34529c810214e6fabf285172"; }];
    buildInputs = [ readline lfcbase lfcxml ];
  };

  "cegui" = fetch {
    pname       = "cegui";
    version     = "0.8.7";
    sources     = [{ filename = "mingw-w64-i686-cegui-0.8.7-1-any.pkg.tar.xz"; sha256 = "782946ca7dd546dfa0c2e79af477ef51e61caf364f0b6fb7ae83cc2a680b6265"; }];
    buildInputs = [ boost devil expat FreeImage freetype fribidi glew glfw glm irrlicht libepoxy libxml2 libiconv lua51 ogre3d ois openexr pcre python2 SDL2 SDL2_image tinyxml xerces-c zlib ];
    broken      = true; # broken dependency cegui -> FreeImage
  };

  "celt" = fetch {
    pname       = "celt";
    version     = "0.11.3";
    sources     = [{ filename = "mingw-w64-i686-celt-0.11.3-4-any.pkg.tar.xz"; sha256 = "0e62b1c678e1faa178b5a6731abd3bc790de26b189bd8322951144934d61f825"; }];
    buildInputs = [ libogg ];
  };

  "cereal" = fetch {
    pname       = "cereal";
    version     = "1.3.0";
    sources     = [{ filename = "mingw-w64-i686-cereal-1.3.0-1-any.pkg.tar.zst"; sha256 = "cc7215cd8924acf145d786fcd438ada4600793500a78ad42e76487169b1c0523"; }];
    buildInputs = [ boost ];
  };

  "ceres-solver" = fetch {
    pname       = "ceres-solver";
    version     = "1.14.0";
    sources     = [{ filename = "mingw-w64-i686-ceres-solver-1.14.0-4-any.pkg.tar.xz"; sha256 = "cc13103d36035675919b2c963d8e0e151532ae6397daf8e97dcea9e654b9b1ac"; }];
    buildInputs = [ eigen3 glog suitesparse ];
  };

  "cfitsio" = fetch {
    pname       = "cfitsio";
    version     = "3.450";
    sources     = [{ filename = "mingw-w64-i686-cfitsio-3.450-2-any.pkg.tar.zst"; sha256 = "00c303b462a67be54118a27e8c571829939ffae6dc88a8ef5489ff7ef170402d"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "cgal" = fetch {
    pname       = "cgal";
    version     = "5.0.2";
    sources     = [{ filename = "mingw-w64-i686-cgal-5.0.2-2-any.pkg.tar.zst"; sha256 = "b844a804dfbc8a6279f27d513dc3194f0efc01b9d29f8a62d66296c9bb8b1ea5"; }];
    buildInputs = [ gcc-libs boost gmp mpfr ];
  };

  "cglm" = fetch {
    pname       = "cglm";
    version     = "0.7.8";
    sources     = [{ filename = "mingw-w64-i686-cglm-0.7.8-1-any.pkg.tar.zst"; sha256 = "4b1815771d6d4df1a552166b9d3852e1b6869679b2a43a49b31ec4632f3e8093"; }];
  };

  "cgns" = fetch {
    pname       = "cgns";
    version     = "4.1.1";
    sources     = [{ filename = "mingw-w64-i686-cgns-4.1.1-1-any.pkg.tar.xz"; sha256 = "344cd48e5733e6d35dd4ff802286989055fa83c16471a21683ad35b87db4c9f9"; }];
    buildInputs = [ hdf5 ];
  };

  "check" = fetch {
    pname       = "check";
    version     = "0.15.2";
    sources     = [{ filename = "mingw-w64-i686-check-0.15.2-1-any.pkg.tar.zst"; sha256 = "8056b89de2a6a5135e47add685d7905ca2f15ea30660698372beddf066e85c61"; }];
    buildInputs = [ gcc-libs ];
  };

  "chicken" = fetch {
    pname       = "chicken";
    version     = "4.12.0";
    sources     = [{ filename = "mingw-w64-i686-chicken-4.12.0-1-any.pkg.tar.zst"; sha256 = "dee9dd7de4dc59d13491c5d61b200d95adf9ced0abb5e33eb545ecb6ab104b37"; }];
  };

  "chipmunk" = fetch {
    pname       = "chipmunk";
    version     = "7.0.3";
    sources     = [{ filename = "mingw-w64-i686-chipmunk-7.0.3-1-any.pkg.tar.xz"; sha256 = "aa7b2bbe7b5c7444f1f0f0e6bad8a58d15f2b9cb40285e18ee968c2d04fea2b7"; }];
  };

  "chromaprint" = fetch {
    pname       = "chromaprint";
    version     = "1.5.0";
    sources     = [{ filename = "mingw-w64-i686-chromaprint-1.5.0-1-any.pkg.tar.zst"; sha256 = "39b34e828f55bf2ac6b33cb85acdbccfe9dee93790ce385ffe486de492d51679"; }];
  };

  "cjson" = fetch {
    pname       = "cjson";
    version     = "1.7.12";
    sources     = [{ filename = "mingw-w64-i686-cjson-1.7.12-2-any.pkg.tar.zst"; sha256 = "5e4efe78646701fd8601c6e9b11bf3611723ba0ea945ce69cd9b4e939c9d3393"; }];
    buildInputs = [ gcc-libs ];
  };

  "clang" = fetch {
    pname       = "clang";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-clang-10.0.1-1-any.pkg.tar.zst"; sha256 = "f1959e3dc6e2190e1a085d3d593894e15c17848780b912d57af276715fd09170"; }];
    buildInputs = [ (assert llvm.version=="10.0.1"; llvm) gcc z3 ];
  };

  "clang-analyzer" = fetch {
    pname       = "clang-analyzer";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-clang-analyzer-10.0.1-1-any.pkg.tar.zst"; sha256 = "fb8400adebb4a53cf264a754a3e00ec81fc17335329075d11e6f6116865eaafa"; }];
    buildInputs = [ (assert clang.version=="10.0.1"; clang) python ];
  };

  "clang-tools-extra" = fetch {
    pname       = "clang-tools-extra";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-clang-tools-extra-10.0.1-1-any.pkg.tar.zst"; sha256 = "9691347c447c2b4dec2d2b5b9b277844ff9f1a8666bd7fc1ccbf998749ec2950"; }];
    buildInputs = [ gcc ];
  };

  "clblast" = fetch {
    pname       = "clblast";
    version     = "1.5.1";
    sources     = [{ filename = "mingw-w64-i686-clblast-1.5.1-1-any.pkg.tar.xz"; sha256 = "f23a8816b1f84cd22be8f6cd5d9f228dc09a0f7d399997db904ae23a4a1c3150"; }];
  };

  "clucene" = fetch {
    pname       = "clucene";
    version     = "2.3.3.4";
    sources     = [{ filename = "mingw-w64-i686-clucene-2.3.3.4-1-any.pkg.tar.xz"; sha256 = "716ab5f7d550885f5f85a50b8747ae6dcaa92ca090c14058ff6270fba2ad224c"; }];
    buildInputs = [ boost zlib ];
  };

  "clustal-omega" = fetch {
    pname       = "clustal-omega";
    version     = "1.2.4";
    sources     = [{ filename = "mingw-w64-i686-clustal-omega-1.2.4-1-any.pkg.tar.zst"; sha256 = "2f4309aca42f63911d2837436d3ac3fe88423dce4a3eb2d9fe5397733c316b4b"; }];
    buildInputs = [ argtable ];
  };

  "clutter" = fetch {
    pname       = "clutter";
    version     = "1.26.4";
    sources     = [{ filename = "mingw-w64-i686-clutter-1.26.4-1-any.pkg.tar.xz"; sha256 = "136693b263e2f691b928d82fe378a77bfaffd3ebe8c0e1db008803873c8c2c3c"; }];
    buildInputs = [ atk cogl json-glib gobject-introspection-runtime gtk3 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "clutter-gst" = fetch {
    pname       = "clutter-gst";
    version     = "3.0.27";
    sources     = [{ filename = "mingw-w64-i686-clutter-gst-3.0.27-1-any.pkg.tar.xz"; sha256 = "ebfeec638f93fe1fb46cc8b2b5a013b3898e6a1ce6f21b858a21d764ed8f7833"; }];
    buildInputs = [ gobject-introspection clutter gstreamer gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "clutter-gtk" = fetch {
    pname       = "clutter-gtk";
    version     = "1.8.4";
    sources     = [{ filename = "mingw-w64-i686-clutter-gtk-1.8.4-1-any.pkg.tar.xz"; sha256 = "82ac78fd5ac0e56087e661d327c9544ff3913d1db5a658e3d09fa007925f105f"; }];
    buildInputs = [ gtk3 clutter ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "cmake" = fetch {
    pname       = "cmake";
    version     = "3.18.4";
    sources     = [{ filename = "mingw-w64-i686-cmake-3.18.4-1-any.pkg.tar.zst"; sha256 = "a9078a44ff213747fde1d1b367cf76b485817f54814f107fd1bfd0be58f0e4c2"; }];
    buildInputs = [ gcc-libs pkg-config curl expat jsoncpp libarchive libuv rhash zlib ];
  };

  "cmake-doc-qt" = fetch {
    pname       = "cmake-doc-qt";
    version     = "3.18.4";
    sources     = [{ filename = "mingw-w64-i686-cmake-doc-qt-3.18.4-1-any.pkg.tar.zst"; sha256 = "c01f38db64677cff750a4a4cfcbbe93580bcf37b13093902932c387c03413c4d"; }];
  };

  "cmark" = fetch {
    pname       = "cmark";
    version     = "0.29.0";
    sources     = [{ filename = "mingw-w64-i686-cmark-0.29.0-1-any.pkg.tar.xz"; sha256 = "df99f915dc46fd718545f3c0b89f68b16c3d4786d5d09d3500e5fa93bb79778b"; }];
  };

  "cmocka" = fetch {
    pname       = "cmocka";
    version     = "1.1.5";
    sources     = [{ filename = "mingw-w64-i686-cmocka-1.1.5-1-any.pkg.tar.xz"; sha256 = "b28abb4c4e863da678ee3c1c29e4fc2bfd2f7a7135200d582d7b8a86bf71dd5e"; }];
  };

  "cninja" = fetch {
    pname       = "cninja";
    version     = "3.7.4";
    sources     = [{ filename = "mingw-w64-i686-cninja-3.7.4-1-any.pkg.tar.zst"; sha256 = "11fc46ce79516da07bcd37cf7f487c24dd2c3d644ef5944299daf1fadcf10f7e"; }];
    buildInputs = [ cmake clang lld ninja self."libc++" ];
  };

  "codelite" = fetch {
    pname       = "codelite";
    version     = "14.0";
    sources     = [{ filename = "mingw-w64-i686-codelite-14.0-2-any.pkg.tar.zst"; sha256 = "342ce48e3c0e39ccc04c497698de398e6db2105fe72a750bf167b5ebcdf91762"; }];
    buildInputs = [ gcc-libs hunspell libssh drmingw clang uchardet wxWidgets sqlite3 ];
  };

  "cogl" = fetch {
    pname       = "cogl";
    version     = "1.22.8";
    sources     = [{ filename = "mingw-w64-i686-cogl-1.22.8-1-any.pkg.tar.zst"; sha256 = "fd22556f1c5b9dc3c86c37c49a55ef8b9ab3c8223ae1e61195c379794ced80ad"; }];
    buildInputs = [ pango gdk-pixbuf2 gstreamer gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "coin" = fetch {
    pname       = "coin";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-coin-4.0.0-1-any.pkg.tar.zst"; sha256 = "4e1e190392c9c5c9a006942ce6e59552b109e29b45ece81937f1b5713eab730e"; }];
    buildInputs = [ gcc-libs expat fontconfig freetype bzip2 zlib openal ];
  };

  "collada-dom-svn" = fetch {
    pname       = "collada-dom-svn";
    version     = "2.4.1.r889";
    sources     = [{ filename = "mingw-w64-i686-collada-dom-svn-2.4.1.r889-7-any.pkg.tar.xz"; sha256 = "41f453341f70c352a79c322ce7400af1405b8cf8999e0be9a5e79ca51ae9d139"; }];
    buildInputs = [ bzip2 boost libxml2 pcre zlib ];
  };

  "compiler-rt" = fetch {
    pname       = "compiler-rt";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-compiler-rt-10.0.1-1-any.pkg.tar.zst"; sha256 = "0137464eb28e06d1c0afcddde85b9be2771322422da2d7016afcce886852767e"; }];
    buildInputs = [ (assert llvm.version=="10.0.1"; llvm) ];
  };

  "confuse" = fetch {
    pname       = "confuse";
    version     = "3.3";
    sources     = [{ filename = "mingw-w64-i686-confuse-3.3-1-any.pkg.tar.zst"; sha256 = "9ff3aba3b58c708c1f1de36a63eb75e59f2cdcb0eb248024508842c70cf63b05"; }];
    buildInputs = [ gettext ];
  };

  "connect" = fetch {
    pname       = "connect";
    version     = "1.105";
    sources     = [{ filename = "mingw-w64-i686-connect-1.105-1-any.pkg.tar.xz"; sha256 = "ef92b2908b0fce9a1429b30597210f16cbf7c3bfd7e6dfe63922471151d264b0"; }];
  };

  "corrade" = fetch {
    pname       = "corrade";
    version     = "2020.06";
    sources     = [{ filename = "mingw-w64-i686-corrade-2020.06-1-any.pkg.tar.zst"; sha256 = "628eb36c95edd2af40d0a7d2b4f90c1b05b61b5babae1a0631f4fd1669d5a8b8"; }];
  };

  "cotire" = fetch {
    pname       = "cotire";
    version     = "1.8.1_3.18";
    sources     = [{ filename = "mingw-w64-i686-cotire-1.8.1_3.18-1-any.pkg.tar.zst"; sha256 = "73f7250f813c92a9d0e04ba2802c9fafec8fdac956b397788c4a1115e8f64710"; }];
  };

  "cppcheck" = fetch {
    pname       = "cppcheck";
    version     = "2.2";
    sources     = [{ filename = "mingw-w64-i686-cppcheck-2.2-1-any.pkg.tar.zst"; sha256 = "3c8d1c5ea6b16c4b0a57261b7037de92e94709cc08297bcf0ca2cbb2ffea62e6"; }];
    buildInputs = [ pcre ];
  };

  "cppreference-qt" = fetch {
    pname       = "cppreference-qt";
    version     = "20190607";
    sources     = [{ filename = "mingw-w64-i686-cppreference-qt-20190607-1-any.pkg.tar.xz"; sha256 = "591cfe69c37f35611ce6bbdd6b827fdbbd8c0929eebf087950e26fa7fdf637b8"; }];
  };

  "cpptest" = fetch {
    pname       = "cpptest";
    version     = "2.0.0";
    sources     = [{ filename = "mingw-w64-i686-cpptest-2.0.0-1-any.pkg.tar.xz"; sha256 = "7efd08717426e1cc4b5769b3fc310fba18589af64fe55e56f9bd2d313a16baf2"; }];
  };

  "cppunit" = fetch {
    pname       = "cppunit";
    version     = "1.15.1";
    sources     = [{ filename = "mingw-w64-i686-cppunit-1.15.1-1-any.pkg.tar.xz"; sha256 = "f34e80f0619c8c261114baa08d616e1c67ce6fec3daf2580ca06c84ddd58428f"; }];
    buildInputs = [ gcc-libs ];
  };

  "cpputest" = fetch {
    pname       = "cpputest";
    version     = "4.0";
    sources     = [{ filename = "mingw-w64-i686-cpputest-4.0-1-any.pkg.tar.zst"; sha256 = "f2032cc725d8318739a5aca2c9e57489b4979acb7e1eb51888a845fb68aa8ff0"; }];
  };

  "creduce" = fetch {
    pname       = "creduce";
    version     = "2.10.0";
    sources     = [{ filename = "mingw-w64-i686-creduce-2.10.0-1-any.pkg.tar.xz"; sha256 = "69d1d34b099cfe751f7b6aeeee93f9636b8e3faa41a7b534a1768b22db70288d"; }];
    buildInputs = [ perl-Benchmark-Timer perl-Exporter-Lite perl-File-Which perl-Getopt-Tabular perl-Regexp-Common perl-Sys-CPU astyle indent clang ];
    broken      = true; # broken dependency creduce -> perl-Benchmark-Timer
  };

  "crt-git" = fetch {
    pname       = "crt-git";
    version     = "9.0.0.6029.ecb4ff54";
    sources     = [{ filename = "mingw-w64-i686-crt-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "f37e0e5c2a242b21b9b97791e771c95eedb1ff04c4428eb22be3b2335513dc32"; }];
    buildInputs = [ headers-git ];
  };

  "crypto++" = fetch {
    pname       = "crypto++";
    version     = "8.2.0";
    sources     = [{ filename = "mingw-w64-i686-crypto++-8.2.0-2-any.pkg.tar.xz"; sha256 = "8b8dc380669ec66b0baa31384cc0ed81560c2fadbbfa0684d46fd521ed110ff7"; }];
    buildInputs = [ gcc-libs ];
  };

  "csfml" = fetch {
    pname       = "csfml";
    version     = "2.5";
    sources     = [{ filename = "mingw-w64-i686-csfml-2.5-1-any.pkg.tar.xz"; sha256 = "e9ae0abde77aa6c05f705e059d68f75465de28978ace6becba84aa41cb077857"; }];
    buildInputs = [ sfml ];
  };

  "ctags" = fetch {
    pname       = "ctags";
    version     = "5.8";
    sources     = [{ filename = "mingw-w64-i686-ctags-5.8-5-any.pkg.tar.xz"; sha256 = "15c74d48ad9a33a13ae5a088dea004ed710f3e8f0e11590a53606f8853629523"; }];
    buildInputs = [ gcc-libs ];
  };

  "ctpl-git" = fetch {
    pname       = "ctpl-git";
    version     = "0.3.3.391.6dd5c14";
    sources     = [{ filename = "mingw-w64-i686-ctpl-git-0.3.3.391.6dd5c14-1-any.pkg.tar.xz"; sha256 = "12139f316f696e6ae7a18b9b8e22cadc24e132e473ecd44205bf0706eda78af5"; }];
    buildInputs = [ glib2 ];
  };

  "cunit" = fetch {
    pname       = "cunit";
    version     = "2.1.3";
    sources     = [{ filename = "mingw-w64-i686-cunit-2.1.3-3-any.pkg.tar.xz"; sha256 = "742db796b52e0b80854262e1c661b4dda26e2f18a1e624eb2ae591747a581395"; }];
  };

  "curl" = fetch {
    pname       = "curl";
    version     = "7.73.0";
    sources     = [{ filename = "mingw-w64-i686-curl-7.73.0-1-any.pkg.tar.zst"; sha256 = "6b425038767907cc0abaaa048b9398599e9d6de889af676d0fbaf06b9f524b69"; }];
    buildInputs = [ gcc-libs c-ares brotli libidn2 libmetalink libpsl libssh2 zlib ca-certificates openssl nghttp2 ];
  };

  "cvode" = fetch {
    pname       = "cvode";
    version     = "5.1.0";
    sources     = [{ filename = "mingw-w64-i686-cvode-5.1.0-1-any.pkg.tar.xz"; sha256 = "e9ec230811df4405436abb7b40b37fa5c1f0a1912697571a6582c656cb39ec94"; }];
  };

  "cxxopts" = fetch {
    pname       = "cxxopts";
    version     = "2.2.1";
    sources     = [{ filename = "mingw-w64-i686-cxxopts-2.2.1-1-any.pkg.tar.zst"; sha256 = "aa39a623de98df051d23bab85cd864f0bf2d91d36bef0293ca2ed9609c3fe569"; }];
  };

  "cyrus-sasl" = fetch {
    pname       = "cyrus-sasl";
    version     = "2.1.27";
    sources     = [{ filename = "mingw-w64-i686-cyrus-sasl-2.1.27-1-any.pkg.tar.xz"; sha256 = "111b84dac2079db4a27de019d868b0272b7688448ce67d88d8f3cec2eedccbb3"; }];
    buildInputs = [ gdbm openssl sqlite3 ];
  };

  "cython" = fetch {
    pname       = "cython";
    version     = "0.29.21";
    sources     = [{ filename = "mingw-w64-i686-cython-0.29.21-1-any.pkg.tar.zst"; sha256 = "93130b876666f9c6ec90433de1c2a6a5bfbf09012fc22c1953e27f54871bc644"; }];
    buildInputs = [ python-setuptools ];
  };

  "d-feet" = fetch {
    pname       = "d-feet";
    version     = "0.3.15";
    sources     = [{ filename = "mingw-w64-i686-d-feet-0.3.15-2-any.pkg.tar.xz"; sha256 = "307704ed84b371b24d5ad2dc6dc9c15bb796372495a14ed8f909e532e7e4d993"; }];
    buildInputs = [ gtk3 python3-gobject hicolor-icon-theme ];
    broken      = true; # broken dependency d-feet -> python3-gobject
  };

  "daala-git" = fetch {
    pname       = "daala-git";
    version     = "r1505.52bbd43";
    sources     = [{ filename = "mingw-w64-i686-daala-git-r1505.52bbd43-1-any.pkg.tar.xz"; sha256 = "bf621212534ff31f9c2118d0a26d0296e755401f96f23d1c3693275011e88e07"; }];
    buildInputs = [ libogg libpng libjpeg-turbo SDL2 ];
  };

  "dav1d" = fetch {
    pname       = "dav1d";
    version     = "0.7.1";
    sources     = [{ filename = "mingw-w64-i686-dav1d-0.7.1-1-any.pkg.tar.zst"; sha256 = "7b3fae9c02e1ffa3f021e9018b7da5e8161cf72dbfe48043a35041dbcee7b35f"; }];
    buildInputs = [ gcc-libs ];
  };

  "db" = fetch {
    pname       = "db";
    version     = "6.0.19";
    sources     = [{ filename = "mingw-w64-i686-db-6.0.19-4-any.pkg.tar.zst"; sha256 = "c14039d8696f5f5e524df82af2e0bceea674b4254cb9b75e71ae1a856365c19e"; }];
    buildInputs = [ gcc-libs ];
  };

  "dbus" = fetch {
    pname       = "dbus";
    version     = "1.12.20";
    sources     = [{ filename = "mingw-w64-i686-dbus-1.12.20-1-any.pkg.tar.zst"; sha256 = "b32e73af5a4073f8b74c05788099021ae771ded0225161bc6b20abb49bd18447"; }];
    buildInputs = [ glib2 expat ];
  };

  "dbus-c++" = fetch {
    pname       = "dbus-c++";
    version     = "0.9.0";
    sources     = [{ filename = "mingw-w64-i686-dbus-c++-0.9.0-1-any.pkg.tar.xz"; sha256 = "8347bdbb0730468a70fc9834b927f1c1b1706a7afe6256fb057acb782aed9359"; }];
    buildInputs = [ dbus ];
  };

  "dbus-glib" = fetch {
    pname       = "dbus-glib";
    version     = "0.110";
    sources     = [{ filename = "mingw-w64-i686-dbus-glib-0.110-1-any.pkg.tar.xz"; sha256 = "8a1382afd27e39bab76d705c77370705ac04539f989bc15872162776232202b0"; }];
    buildInputs = [ glib2 dbus expat ];
  };

  "dcadec" = fetch {
    pname       = "dcadec";
    version     = "0.2.0";
    sources     = [{ filename = "mingw-w64-i686-dcadec-0.2.0-2-any.pkg.tar.xz"; sha256 = "db8c66b5b508acd0456927a4067d172a45dc77c4b54bc68ec15d8b96003d7c38"; }];
    buildInputs = [ gcc-libs ];
  };

  "dcraw" = fetch {
    pname       = "dcraw";
    version     = "9.28";
    sources     = [{ filename = "mingw-w64-i686-dcraw-9.28-1-any.pkg.tar.xz"; sha256 = "efbb772b30024b71fcff0a3cabbd0bd31bd7bcfb9519edc1786560e8f4e6f7f1"; }];
    buildInputs = [ lcms2 jasper libjpeg-turbo ];
  };

  "desktop-file-utils" = fetch {
    pname       = "desktop-file-utils";
    version     = "0.26";
    sources     = [{ filename = "mingw-w64-i686-desktop-file-utils-0.26-1-any.pkg.tar.zst"; sha256 = "87b136af729b0ae9ec4f83ee4f13b713c67978e7b4f295a3dd58b48b6117475b"; }];
    buildInputs = [ glib2 gtk3 libxml2 ];
  };

  "devcon-git" = fetch {
    pname       = "devcon-git";
    version     = "r233.8b17cf3";
    sources     = [{ filename = "mingw-w64-i686-devcon-git-r233.8b17cf3-1-any.pkg.tar.xz"; sha256 = "74c514ee965c361ab0b2eba285910678a4e084f329d453746e44a550788b12cc"; }];
  };

  "devil" = fetch {
    pname       = "devil";
    version     = "1.8.0";
    sources     = [{ filename = "mingw-w64-i686-devil-1.8.0-6-any.pkg.tar.zst"; sha256 = "71225b6bb86ba0b7a4182bda65981982b276512eb9c8fab00c149df3a9aed316"; }];
    buildInputs = [ freeglut jasper lcms2 libmng libpng libsquish libtiff openexr zlib ];
  };

  "dfu-programmer" = fetch {
    pname       = "dfu-programmer";
    version     = "0.7.2";
    sources     = [{ filename = "mingw-w64-i686-dfu-programmer-0.7.2-2-any.pkg.tar.zst"; sha256 = "4f496893a73471640000be8ca5bd1d716832de58ab9071d1516ffb902d046e57"; }];
    buildInputs = [ libusb-win32 ];
  };

  "dfu-util" = fetch {
    pname       = "dfu-util";
    version     = "0.9";
    sources     = [{ filename = "mingw-w64-i686-dfu-util-0.9-1-any.pkg.tar.zst"; sha256 = "421ad23dde39d82cede9d6a7d5182892bb9dc92c7043c4f87adbe815934f6144"; }];
    buildInputs = [ libusb ];
  };

  "diffutils" = fetch {
    pname       = "diffutils";
    version     = "3.6";
    sources     = [{ filename = "mingw-w64-i686-diffutils-3.6-2-any.pkg.tar.xz"; sha256 = "fdd544ed90b4923e63913304b0be68db2c4e377ba5bca3692dc011eceec9bad3"; }];
    buildInputs = [ libsigsegv libwinpthread-git gettext ];
  };

  "discount" = fetch {
    pname       = "discount";
    version     = "2.2.6";
    sources     = [{ filename = "mingw-w64-i686-discount-2.2.6-1-any.pkg.tar.xz"; sha256 = "462ab82e18271b965dc524e77e54128cbb3240ca2ffdff8935b925f103f63113"; }];
  };

  "distorm" = fetch {
    pname       = "distorm";
    version     = "3.5";
    sources     = [{ filename = "mingw-w64-i686-distorm-3.5-1-any.pkg.tar.zst"; sha256 = "5aa18f0051f4cee77bb3bd38d5ba767e53955c7beb8144e3d43575c0f059f11e"; }];
  };

  "djview" = fetch {
    pname       = "djview";
    version     = "4.10.6";
    sources     = [{ filename = "mingw-w64-i686-djview-4.10.6-1-any.pkg.tar.xz"; sha256 = "7f09112afffcdb81e4db9cb4387270dbb5a20447ecd28f7d5dd6a7bcd2896538"; }];
    buildInputs = [ djvulibre gcc-libs qt5 libtiff ];
  };

  "djvulibre" = fetch {
    pname       = "djvulibre";
    version     = "3.5.27";
    sources     = [{ filename = "mingw-w64-i686-djvulibre-3.5.27-4-any.pkg.tar.xz"; sha256 = "134856f0b5f1020898dd185abb03c9d6779e16593660713efc52cb979cdf62f2"; }];
    buildInputs = [ gcc-libs libjpeg libiconv libtiff zlib ];
  };

  "dlfcn" = fetch {
    pname       = "dlfcn";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-dlfcn-1.2.0-1-any.pkg.tar.xz"; sha256 = "7ae0ed510bc345655d52636c0f95f3b227851d9101f20ce4b8c601490d2f383c"; }];
    buildInputs = [ gcc-libs ];
  };

  "dlib" = fetch {
    pname       = "dlib";
    version     = "19.20";
    sources     = [{ filename = "mingw-w64-i686-dlib-19.20-1-any.pkg.tar.zst"; sha256 = "4b87676613ed697c226d24739636779779dd07cc4d40f51e984b0564ec647c3b"; }];
    buildInputs = [ lapack giflib libpng libjpeg-turbo openblas lapack fftw sqlite3 ];
  };

  "dmake" = fetch {
    pname       = "dmake";
    version     = "4.12.2.2";
    sources     = [{ filename = "mingw-w64-i686-dmake-4.12.2.2-1-any.pkg.tar.xz"; sha256 = "82296f7f3e1b452590f664363d3e22f69cfa5ac194fb4ad3719dd20e080d6df6"; }];
  };

  "dnscrypt-proxy" = fetch {
    pname       = "dnscrypt-proxy";
    version     = "1.6.0";
    sources     = [{ filename = "mingw-w64-i686-dnscrypt-proxy-1.6.0-2-any.pkg.tar.xz"; sha256 = "69087e524315044a10ac33edda723b97dfb5aa0f4640c059c0244bd0f50ba742"; }];
    buildInputs = [ libsodium ldns ];
  };

  "dnssec-anchors" = fetch {
    pname       = "dnssec-anchors";
    version     = "20130320";
    sources     = [{ filename = "mingw-w64-i686-dnssec-anchors-20130320-1-any.pkg.tar.zst"; sha256 = "4da866166eb58a9799f79621713ad45a92fefc1a8de6a13b5e9698e5d1f908ff"; }];
  };

  "docbook-dsssl" = fetch {
    pname       = "docbook-dsssl";
    version     = "1.79";
    sources     = [{ filename = "mingw-w64-i686-docbook-dsssl-1.79-1-any.pkg.tar.xz"; sha256 = "5ae88a8e71dbefe7b6fd568a480b0a81b19f8121ccfdd649b3967e00a4e2ae37"; }];
    buildInputs = [ sgml-common perl ];
  };

  "docbook-mathml" = fetch {
    pname       = "docbook-mathml";
    version     = "1.1CR1";
    sources     = [{ filename = "mingw-w64-i686-docbook-mathml-1.1CR1-2-any.pkg.tar.xz"; sha256 = "913a068c24b772368b2a14265882fc06f7e3f8890e1e368903efbe53b25bf3b8"; }];
    buildInputs = [ libxml2 ];
  };

  "docbook-sgml" = fetch {
    pname       = "docbook-sgml";
    version     = "4.5";
    sources     = [{ filename = "mingw-w64-i686-docbook-sgml-4.5-1-any.pkg.tar.xz"; sha256 = "773869f96d499a8b8d4f751fe93f0b48299cefb41dcae4b15f807b89f6e64900"; }];
    buildInputs = [ sgml-common ];
  };

  "docbook-sgml31" = fetch {
    pname       = "docbook-sgml31";
    version     = "3.1";
    sources     = [{ filename = "mingw-w64-i686-docbook-sgml31-3.1-1-any.pkg.tar.xz"; sha256 = "9d1d61b1ede7831eed75271d32c90a06107964bf6884f2ed13f70890c267c0f4"; }];
    buildInputs = [ sgml-common ];
  };

  "docbook-xml" = fetch {
    pname       = "docbook-xml";
    version     = "1~4.5";
    sources     = [{ filename = "mingw-w64-i686-docbook-xml-1~4.5-1-any.pkg.tar.xz"; sha256 = "2910b3f431c196b28511cd2fcc35981920c9f608d1f05805c2390ce5f8d506da"; }];
    buildInputs = [ libxml2 ];
  };

  "docbook-xsl" = fetch {
    pname       = "docbook-xsl";
    version     = "1.79.2";
    sources     = [{ filename = "mingw-w64-i686-docbook-xsl-1.79.2-6-any.pkg.tar.xz"; sha256 = "45ab5738bf61bccb4b15859dd65795ad1228c4ccc12f5a013f008f0227857996"; }];
    buildInputs = [ libxml2 libxslt docbook-xml ];
  };

  "docbook5-xml" = fetch {
    pname       = "docbook5-xml";
    version     = "5.1";
    sources     = [{ filename = "mingw-w64-i686-docbook5-xml-5.1-1-any.pkg.tar.xz"; sha256 = "6350aa504696bd88d19b8e403a079d167c71ec0896a105dae1eb34f9a6fd2070"; }];
    buildInputs = [ libxml2 ];
  };

  "double-conversion" = fetch {
    pname       = "double-conversion";
    version     = "3.1.5";
    sources     = [{ filename = "mingw-w64-i686-double-conversion-3.1.5-1-any.pkg.tar.xz"; sha256 = "e1bafa55f51113713c4a277cc1ce6093ff8679068bcf732d9b18d5a2cf39e002"; }];
    buildInputs = [ gcc-libs ];
  };

  "doxygen" = fetch {
    pname       = "doxygen";
    version     = "1.8.20";
    sources     = [{ filename = "mingw-w64-i686-doxygen-1.8.20-1-any.pkg.tar.zst"; sha256 = "58e866ed3b530a994589aaa62a9026d3b1354991e66e41899c5bf31345bacbe0"; }];
    buildInputs = [ gcc-libs libiconv sqlite3 xapian-core ];
  };

  "dragon" = fetch {
    pname       = "dragon";
    version     = "1.5.2";
    sources     = [{ filename = "mingw-w64-i686-dragon-1.5.2-1-any.pkg.tar.xz"; sha256 = "41df20c5fffc47de45acc3c66d009eed923e6a03c39d83abdcd3069d866d7555"; }];
    buildInputs = [ lfcbase ];
  };

  "drmingw" = fetch {
    pname       = "drmingw";
    version     = "0.9.2";
    sources     = [{ filename = "mingw-w64-i686-drmingw-0.9.2-1-any.pkg.tar.xz"; sha256 = "b123a6e1bb5a14b2e7c42f381a014e169fb7b9758a0f198fe4256f1961e2bd26"; }];
    buildInputs = [ gcc-libs ];
  };

  "dsdp" = fetch {
    pname       = "dsdp";
    version     = "5.8";
    sources     = [{ filename = "mingw-w64-i686-dsdp-5.8-1-any.pkg.tar.xz"; sha256 = "285528b2812432838dfeb48860737b73cb215d88857bf6ea95dde10ab8ba632d"; }];
    buildInputs = [ openblas ];
  };

  "ducible" = fetch {
    pname       = "ducible";
    version     = "1.2.1";
    sources     = [{ filename = "mingw-w64-i686-ducible-1.2.1-1-any.pkg.tar.xz"; sha256 = "2e20f6ddcad737e639efe1cb47d9592f8bd0d3e72dcf2063b284ad8441f96ed6"; }];
    buildInputs = [ gcc-libs ];
  };

  "dumb" = fetch {
    pname       = "dumb";
    version     = "2.0.3";
    sources     = [{ filename = "mingw-w64-i686-dumb-2.0.3-1-any.pkg.tar.xz"; sha256 = "2b81c4dbb58c8b0e46c875c67ba82289af1169e3812810209a362c0c68004bd7"; }];
  };

  "dwarfstack" = fetch {
    pname       = "dwarfstack";
    version     = "2.1";
    sources     = [{ filename = "mingw-w64-i686-dwarfstack-2.1-1-any.pkg.tar.xz"; sha256 = "bca6ed426620b67707854bc8a741e77bf55f28b46afe89255c85ade114a69c9c"; }];
  };

  "editorconfig-core-c" = fetch {
    pname       = "editorconfig-core-c";
    version     = "0.12.3";
    sources     = [{ filename = "mingw-w64-i686-editorconfig-core-c-0.12.3-2-any.pkg.tar.xz"; sha256 = "ecf36c5b42ec0b9049e42965f9e3a66c6673a5ef69e07b91340e48ef061a64f7"; }];
    buildInputs = [ pcre2 ];
  };

  "editrights" = fetch {
    pname       = "editrights";
    version     = "1.03";
    sources     = [{ filename = "mingw-w64-i686-editrights-1.03-3-any.pkg.tar.xz"; sha256 = "326c611b22b77a624229c93a67e7294256fbe225c9aaf185c7e1139c5bed10cf"; }];
  };

  "eigen3" = fetch {
    pname       = "eigen3";
    version     = "3.3.7";
    sources     = [{ filename = "mingw-w64-i686-eigen3-3.3.7-2-any.pkg.tar.zst"; sha256 = "4b63acca8a9cd7b399eb76d5913ab494a9ce46318f338464da0153f7aa89a576"; }];
    buildInputs = [  ];
  };

  "emacs" = fetch {
    pname       = "emacs";
    version     = "27.1";
    sources     = [{ filename = "mingw-w64-i686-emacs-27.1-1-any.pkg.tar.zst"; sha256 = "5897196c0d1a2576579eb57e359f71096dc87e75c9945ab9b2b63d673faeca40"; }];
    buildInputs = [ universal-ctags-git zlib xpm-nox harfbuzz gnutls libwinpthread-git ];
  };

  "embree" = fetch {
    pname       = "embree";
    version     = "3.12.1";
    sources     = [{ filename = "mingw-w64-i686-embree-3.12.1-1-any.pkg.tar.zst"; sha256 = "393fd35f3ea62c323a98d101c2a158a08c5c0d6f47c788c04f02c8a338c9adf2"; }];
    buildInputs = [ intel-tbb glfw ];
  };

  "enca" = fetch {
    pname       = "enca";
    version     = "1.19";
    sources     = [{ filename = "mingw-w64-i686-enca-1.19-1-any.pkg.tar.xz"; sha256 = "e7002fb62441bfbf9fa9e84e62c86b0e687204c7808f105cd99f49fa4a9ebb1d"; }];
    buildInputs = [ recode ];
  };

  "enchant" = fetch {
    pname       = "enchant";
    version     = "2.2.11";
    sources     = [{ filename = "mingw-w64-i686-enchant-2.2.11-1-any.pkg.tar.zst"; sha256 = "af3418338db477b7c8ea634f2e6e520a800c5a4dc6b39e76ddaf7246f5f5c4f8"; }];
    buildInputs = [ aspell hunspell gcc-libs glib2 libvoikko ];
  };

  "enet" = fetch {
    pname       = "enet";
    version     = "1.3.16";
    sources     = [{ filename = "mingw-w64-i686-enet-1.3.16-1-any.pkg.tar.zst"; sha256 = "9343a01683fe35115ae4098cda29ebf18ad6f15ea791be36039e9abc8fd7f0de"; }];
  };

  "ensmallen" = fetch {
    pname       = "ensmallen";
    version     = "2.12.1";
    sources     = [{ filename = "mingw-w64-i686-ensmallen-2.12.1-1-any.pkg.tar.zst"; sha256 = "48e6228399ea5bb81a48bcf66649bdb2fa07bbc63fb4c53922fea3f677219ffd"; }];
    buildInputs = [ gcc-libs armadillo openblas ];
  };

  "eog" = fetch {
    pname       = "eog";
    version     = "3.36.2";
    sources     = [{ filename = "mingw-w64-i686-eog-3.36.2-2-any.pkg.tar.zst"; sha256 = "51ceca76c434910071145a57ce5ed270581744edad9b30e8e6af51b7b33d625d"; }];
    buildInputs = [ adwaita-icon-theme gettext gtk3 gdk-pixbuf2 gobject-introspection-runtime gsettings-desktop-schemas zlib libexif libjpeg-turbo libpeas librsvg libxml2 shared-mime-info ];
  };

  "eog-plugins" = fetch {
    pname       = "eog-plugins";
    version     = "3.26.5";
    sources     = [{ filename = "mingw-w64-i686-eog-plugins-3.26.5-1-any.pkg.tar.xz"; sha256 = "f645950c26766efa781c606d5629df03c1a2bd3e2260c31e0438ca6f95a70797"; }];
    buildInputs = [ eog libchamplain libexif libgdata python ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "evince" = fetch {
    pname       = "evince";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-evince-3.38.0-1-any.pkg.tar.zst"; sha256 = "9e04e564f9d418b0e0543cd30b0b7d0b6ef4152be6266008479272b05418977c"; }];
    buildInputs = [ glib2 cairo djvulibre gsettings-desktop-schemas appstream-glib gspell gst-plugins-base gtk3 hicolor-icon-theme libarchive libgxps libspectre libtiff nss poppler zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "exiv2" = fetch {
    pname       = "exiv2";
    version     = "0.27.3";
    sources     = [{ filename = "mingw-w64-i686-exiv2-0.27.3-1-any.pkg.tar.zst"; sha256 = "4a34acde257187d939b94adff2053a8462d6286441118f221a89fa6e53bc2e4c"; }];
    buildInputs = [ expat curl libiconv zlib ];
  };

  "expat" = fetch {
    pname       = "expat";
    version     = "2.2.10";
    sources     = [{ filename = "mingw-w64-i686-expat-2.2.10-1-any.pkg.tar.zst"; sha256 = "114d682ea469004e67b4979685aa62e10a922581b41fee8988a2639cd0e47d51"; }];
    buildInputs = [  ];
  };

  "extra-cmake-modules" = fetch {
    pname       = "extra-cmake-modules";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-extra-cmake-modules-5.75.0-1-any.pkg.tar.zst"; sha256 = "c9a9eed5f3f8a27412d0e46a6fe9c4fc471884562ca81393cd6724be3fb003b1"; }];
    buildInputs = [ cmake png2ico ];
  };

  "f2c" = fetch {
    pname       = "f2c";
    version     = "20200425";
    sources     = [{ filename = "mingw-w64-i686-f2c-20200425-1-any.pkg.tar.zst"; sha256 = "76e6a431b13ef4b4a342162c2a3626061dcbf3ed4d118dfa7e79f9abc8fec1ea"; }];
  };

  "faac" = fetch {
    pname       = "faac";
    version     = "1.30";
    sources     = [{ filename = "mingw-w64-i686-faac-1.30-1-any.pkg.tar.xz"; sha256 = "6061561bd542437342b0027232ea7e58b8d4284e4c20a0312c358475f1daf889"; }];
  };

  "faad2" = fetch {
    pname       = "faad2";
    version     = "2.10.0";
    sources     = [{ filename = "mingw-w64-i686-faad2-2.10.0-1-any.pkg.tar.zst"; sha256 = "a0b07c3b5c505ab7672e27c8884e3e8a7c55862567a763a35ec329c037083873"; }];
    buildInputs = [ gcc-libs ];
  };

  "fann" = fetch {
    pname       = "fann";
    version     = "2.2.0";
    sources     = [{ filename = "mingw-w64-i686-fann-2.2.0-2-any.pkg.tar.xz"; sha256 = "67eadf7fab8f599db8ff27c254d6eae2355ab4103b9d27cb50338d6a928d78f3"; }];
  };

  "farstream" = fetch {
    pname       = "farstream";
    version     = "0.2.8";
    sources     = [{ filename = "mingw-w64-i686-farstream-0.2.8-2-any.pkg.tar.xz"; sha256 = "dc3718ed0b144a28cd8be575ce08238f8bcb32362aca667db896248db323e33b"; }];
    buildInputs = [ gst-plugins-base libnice ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "fastjar" = fetch {
    pname       = "fastjar";
    version     = "0.98";
    sources     = [{ filename = "mingw-w64-i686-fastjar-0.98-1-any.pkg.tar.xz"; sha256 = "42992b23107e40f6f959cd5120313641eee29af65c34cdc916544bd0f5ccae9e"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "fcrackzip" = fetch {
    pname       = "fcrackzip";
    version     = "1.0";
    sources     = [{ filename = "mingw-w64-i686-fcrackzip-1.0-1-any.pkg.tar.xz"; sha256 = "4fee468f8a10c72a11017684705fae76a70ff8765633532baf762123c72a356d"; }];
  };

  "fdk-aac" = fetch {
    pname       = "fdk-aac";
    version     = "2.0.1";
    sources     = [{ filename = "mingw-w64-i686-fdk-aac-2.0.1-1-any.pkg.tar.xz"; sha256 = "19aeae28263a621197ed8f6819e860c10c2f3dc36a464733d3c5c04bdaf323e1"; }];
  };

  "ffcall" = fetch {
    pname       = "ffcall";
    version     = "2.2";
    sources     = [{ filename = "mingw-w64-i686-ffcall-2.2-1-any.pkg.tar.xz"; sha256 = "1b865e56cc961bfd3d84235c6a66f86b78ae4cd308164af6a8e20dc52cb26a21"; }];
  };

  "ffmpeg" = fetch {
    pname       = "ffmpeg";
    version     = "4.3.1";
    sources     = [{ filename = "mingw-w64-i686-ffmpeg-4.3.1-1-any.pkg.tar.zst"; sha256 = "5bb21a61a9d24c59e3184b20288088efc092d7c19a5b42e6c36cce9be5c31512"; }];
    buildInputs = [ aom bzip2 celt fontconfig dav1d gnutls gsm lame libass libbluray libcaca libmfx libmodplug libtheora libvorbis libvpx libwebp libxml2 openal opencore-amr openjpeg2 opus rtmpdump-git SDL2 speex srt vulkan wavpack x264-git x265 xvidcore zlib ];
  };

  "ffms2" = fetch {
    pname       = "ffms2";
    version     = "2.23.1";
    sources     = [{ filename = "mingw-w64-i686-ffms2-2.23.1-1-any.pkg.tar.xz"; sha256 = "312d4e6e4f8d75d89112aa9b3f1acb4931539764f38e84f428652e735cb1573f"; }];
    buildInputs = [ ffmpeg ];
  };

  "fftw" = fetch {
    pname       = "fftw";
    version     = "3.3.8";
    sources     = [{ filename = "mingw-w64-i686-fftw-3.3.8-2-any.pkg.tar.zst"; sha256 = "ef4b0b5e191b1a41b9f03173ff0b27c19b92e15de63d3b2961f6e76283435123"; }];
    buildInputs = [ gcc-libs ];
  };

  "fgsl" = fetch {
    pname       = "fgsl";
    version     = "1.3.0";
    sources     = [{ filename = "mingw-w64-i686-fgsl-1.3.0-1-any.pkg.tar.zst"; sha256 = "e711b65938da7ef4fe632d006c3b88bf8c08be802b0d7a4aaa608c5e000912e5"; }];
    buildInputs = [ gcc-libs gcc-libgfortran (assert stdenvNoCC.lib.versionAtLeast gsl.version "2.4"; gsl) ];
  };

  "field3d" = fetch {
    pname       = "field3d";
    version     = "1.7.3";
    sources     = [{ filename = "mingw-w64-i686-field3d-1.7.3-2-any.pkg.tar.zst"; sha256 = "96873e8a8fc27584700a0a608bf658c7a9a236f3788410365fa77fc4115dbb90"; }];
    buildInputs = [ boost hdf5 openexr ];
  };

  "file" = fetch {
    pname       = "file";
    version     = "5.39";
    sources     = [{ filename = "mingw-w64-i686-file-5.39-1-any.pkg.tar.zst"; sha256 = "356a57b1edf0a5795d9e817be057e61e4b3f63443bebffcf33d937445b789771"; }];
    buildInputs = [ bzip2 libsystre xz zlib ];
  };

  "firebird2-git" = fetch {
    pname       = "firebird2-git";
    version     = "2.5.9.27149.9f6840e90c";
    sources     = [{ filename = "mingw-w64-i686-firebird2-git-2.5.9.27149.9f6840e90c-3-any.pkg.tar.zst"; sha256 = "59ae9cdddd9713d0ab9ae650e4a3b24c50be948ecf9b0f7eb3aba72771e8d5c0"; }];
    buildInputs = [ gcc-libs icu zlib ];
  };

  "flac" = fetch {
    pname       = "flac";
    version     = "1.3.3";
    sources     = [{ filename = "mingw-w64-i686-flac-1.3.3-1-any.pkg.tar.xz"; sha256 = "3cfbcae7301d498155b62fb212bdd5996620d42013238dfebf1a18d36f1577d2"; }];
    buildInputs = [ libogg gcc-libs ];
  };

  "flatbuffers" = fetch {
    pname       = "flatbuffers";
    version     = "1.12.0";
    sources     = [{ filename = "mingw-w64-i686-flatbuffers-1.12.0-1-any.pkg.tar.xz"; sha256 = "3f8c305200c68086859feb8e31213be411e4f5badcafc4c7b1e12a627a6c5cc1"; }];
    buildInputs = [ libsystre ];
  };

  "flexdll" = fetch {
    pname       = "flexdll";
    version     = "0.34";
    sources     = [{ filename = "mingw-w64-i686-flexdll-0.34-2-any.pkg.tar.xz"; sha256 = "9e91bdabf874ad728827acd408d18454aef05b77a6e88e261fa8a5e30934fdaf"; }];
  };

  "flickcurl" = fetch {
    pname       = "flickcurl";
    version     = "1.26";
    sources     = [{ filename = "mingw-w64-i686-flickcurl-1.26-2-any.pkg.tar.xz"; sha256 = "9b3c40cfdb75f7940a92301236194d640046721834cbfa8e16febd76f32628cb"; }];
    buildInputs = [ curl libxml2 ];
  };

  "flif" = fetch {
    pname       = "flif";
    version     = "0.3";
    sources     = [{ filename = "mingw-w64-i686-flif-0.3-1-any.pkg.tar.xz"; sha256 = "739981420fcb3d61ed4c7574967d3d1dc77398add07b4d1820847eeceb6c7567"; }];
    buildInputs = [ zlib libpng SDL2 ];
  };

  "fltk" = fetch {
    pname       = "fltk";
    version     = "1.3.5";
    sources     = [{ filename = "mingw-w64-i686-fltk-1.3.5-1-any.pkg.tar.xz"; sha256 = "fefc8c2b08183dfcb0fbaff8f4abc4a53dab2d0a1d530a6d2248be2f0701aac3"; }];
    buildInputs = [ expat gcc-libs gettext libiconv libpng libjpeg-turbo zlib ];
  };

  "fluidsynth" = fetch {
    pname       = "fluidsynth";
    version     = "2.1.5";
    sources     = [{ filename = "mingw-w64-i686-fluidsynth-2.1.5-1-any.pkg.tar.zst"; sha256 = "a72b60c069c8fd673e3882f634f8fe4c70c28c509cb051eefad5d191b81f96de"; }];
    buildInputs = [ gcc-libs glib2 libsndfile portaudio readline ];
  };

  "fmt" = fetch {
    pname       = "fmt";
    version     = "7.0.3";
    sources     = [{ filename = "mingw-w64-i686-fmt-7.0.3-1-any.pkg.tar.zst"; sha256 = "cb682d0a7e2e85d4806e777f4a09484cdb1c97b75b3c4c2923af66bccd249819"; }];
    buildInputs = [ gcc-libs ];
  };

  "fontconfig" = fetch {
    pname       = "fontconfig";
    version     = "2.13.92";
    sources     = [{ filename = "mingw-w64-i686-fontconfig-2.13.92-2-any.pkg.tar.zst"; sha256 = "43d0c01780c836fa18843406ff0dee5b5189b29bc9701168332418e283b8a464"; }];
    buildInputs = [ gcc-libs (assert stdenvNoCC.lib.versionAtLeast expat.version "2.1.0"; expat) (assert stdenvNoCC.lib.versionAtLeast freetype.version "2.3.11"; freetype) (assert stdenvNoCC.lib.versionAtLeast bzip2.version "1.0.6"; bzip2) libiconv ];
  };

  "fossil" = fetch {
    pname       = "fossil";
    version     = "2.12.1";
    sources     = [{ filename = "mingw-w64-i686-fossil-2.12.1-1-any.pkg.tar.zst"; sha256 = "33c133b6ba58301d002f2dfc534fa3b5227e37cd12439573ea372a9289873ba5"; }];
    buildInputs = [ openssl readline sqlite3 zlib ];
  };

  "fox" = fetch {
    pname       = "fox";
    version     = "1.6.57";
    sources     = [{ filename = "mingw-w64-i686-fox-1.6.57-1-any.pkg.tar.xz"; sha256 = "f7a5f444a726b4b23387065c92e97b0481a60f6721cada5af88267c8736dbe5d"; }];
    buildInputs = [ gcc-libs libtiff zlib libpng libjpeg-turbo ];
  };

  "freealut" = fetch {
    pname       = "freealut";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-freealut-1.1.0-1-any.pkg.tar.xz"; sha256 = "7c9d4e1d40ece6c505b391833b70bcdf1647469a8799366efe677299b333ce89"; }];
    buildInputs = [ openal ];
  };

  "freeglut" = fetch {
    pname       = "freeglut";
    version     = "3.2.1";
    sources     = [{ filename = "mingw-w64-i686-freeglut-3.2.1-1-any.pkg.tar.xz"; sha256 = "d02d5a46e6dd17df07a3e446cef59d8c007cdc631d4c06d10dc66e603d510710"; }];
    buildInputs = [  ];
  };

  "freeimage" = fetch {
    pname       = "freeimage";
    version     = "3.18.0";
    sources     = [{ filename = "mingw-w64-i686-freeimage-3.18.0-5-any.pkg.tar.zst"; sha256 = "d8bb750595ce4c62f1d54ae057c865a84705ca79895e2dd6a06dd5b9fe2f3177"; }];
    buildInputs = [ gcc-libs jxrlib libjpeg-turbo libpng libtiff libraw libwebp openjpeg2 openexr ];
  };

  "freetds" = fetch {
    pname       = "freetds";
    version     = "1.2.5";
    sources     = [{ filename = "mingw-w64-i686-freetds-1.2.5-1-any.pkg.tar.zst"; sha256 = "5e5269b6a38ec51b7588960d7c36e78ecd8ca2482574b1fc413c5c0437147743"; }];
    buildInputs = [ gcc-libs openssl libiconv ];
  };
  freetype = self."freetype+harfbuzz";

  "fribidi" = fetch {
    pname       = "fribidi";
    version     = "1.0.10";
    sources     = [{ filename = "mingw-w64-i686-fribidi-1.0.10-1-any.pkg.tar.zst"; sha256 = "058b29231ccbe0dfcfa8d35a0079d28254bb12b1fed3fc87e3eaa75910b7d918"; }];
    buildInputs = [  ];
  };

  "ftgl" = fetch {
    pname       = "ftgl";
    version     = "2.4.0";
    sources     = [{ filename = "mingw-w64-i686-ftgl-2.4.0-1-any.pkg.tar.xz"; sha256 = "81e6fb848a1b99a8804e259b4e667d962e61c95853218d9c1183aa8bf486ba71"; }];
    buildInputs = [ gcc-libs freetype ];
  };

  "gavl" = fetch {
    pname       = "gavl";
    version     = "1.4.0";
    sources     = [{ filename = "mingw-w64-i686-gavl-1.4.0-1-any.pkg.tar.xz"; sha256 = "7e0890c13a63ff0a4da7757705506e177bf7d467a188864f2d832335b937f423"; }];
    buildInputs = [ gcc-libs libpng ];
  };

  "gc" = fetch {
    pname       = "gc";
    version     = "8.0.4";
    sources     = [{ filename = "mingw-w64-i686-gc-8.0.4-1-any.pkg.tar.xz"; sha256 = "8bdc168b32f45a1533e73636b969f14774f6c6c8c3ff4fe4e6ddcb401db254f0"; }];
    buildInputs = [ gcc-libs libatomic_ops ];
  };

  "gcc" = fetch {
    pname       = "gcc";
    version     = "10.2.0";
    sources     = [{ filename = "mingw-w64-i686-gcc-10.2.0-4-any.pkg.tar.zst"; sha256 = "840e42dddfaf11f13bef0970dc03a668dd8b2fec49f96ef228e9270d3b18246d"; }];
    buildInputs = [ binutils crt-git headers-git isl libiconv mpc (assert gcc-libs.version=="10.2.0"; gcc-libs) windows-default-manifest winpthreads-git zlib zstd ];
  };

  "gcc-ada" = fetch {
    pname       = "gcc-ada";
    version     = "10.2.0";
    sources     = [{ filename = "mingw-w64-i686-gcc-ada-10.2.0-4-any.pkg.tar.zst"; sha256 = "40a7d517c39deb6b1d4925cd458308f9f05b72352ce2e235d06156db142280dd"; }];
    buildInputs = [ (assert gcc.version=="10.2.0"; gcc) ];
  };

  "gcc-fortran" = fetch {
    pname       = "gcc-fortran";
    version     = "10.2.0";
    sources     = [{ filename = "mingw-w64-i686-gcc-fortran-10.2.0-4-any.pkg.tar.zst"; sha256 = "af82c33bb72b773fe4c461cee1dda3aa2f23da9206f32cc9889f03a8ed2e2dec"; }];
    buildInputs = [ (assert gcc.version=="10.2.0"; gcc) (assert gcc-libgfortran.version=="10.2.0"; gcc-libgfortran) ];
  };

  "gcc-libgfortran" = fetch {
    pname       = "gcc-libgfortran";
    version     = "10.2.0";
    sources     = [{ filename = "mingw-w64-i686-gcc-libgfortran-10.2.0-4-any.pkg.tar.zst"; sha256 = "1e0345703a57e25279e713f01768aeeb1a5caac648c5221400f6fbd59538714e"; }];
    buildInputs = [ (assert gcc-libs.version=="10.2.0"; gcc-libs) ];
  };

  "gcc-libs" = fetch {
    pname       = "gcc-libs";
    version     = "10.2.0";
    sources     = [{ filename = "mingw-w64-i686-gcc-libs-10.2.0-4-any.pkg.tar.zst"; sha256 = "87f56e91be52f06e3567998e8ef16b3fbc456cd33f06f056cddb82642831b719"; }];
    buildInputs = [ gmp mpc mpfr libwinpthread-git ];
  };

  "gcc-objc" = fetch {
    pname       = "gcc-objc";
    version     = "10.2.0";
    sources     = [{ filename = "mingw-w64-i686-gcc-objc-10.2.0-4-any.pkg.tar.zst"; sha256 = "7d37633b18f716a91907de34692126f8e2a294c62a5e55577bd17d74015c78bd"; }];
    buildInputs = [ (assert gcc.version=="10.2.0"; gcc) ];
  };

  "gdal" = fetch {
    pname       = "gdal";
    version     = "3.1.3";
    sources     = [{ filename = "mingw-w64-i686-gdal-3.1.3-1-any.pkg.tar.zst"; sha256 = "0e154469ad01891c7fe1dbf52a25649dccae1a5e0ef727860bdb5a27b5369125"; }];
    buildInputs = [ cfitsio self."crypto++" curl expat geos giflib hdf5 jasper json-c libfreexl libgeotiff libiconv libjpeg libkml libpng libspatialite libtiff libwebp libxml2 netcdf openjpeg2 pcre poppler postgresql proj qhull-git sqlite3 xerces-c xz ];
  };

  "gdb" = fetch {
    pname       = "gdb";
    version     = "9.2";
    sources     = [{ filename = "mingw-w64-i686-gdb-9.2-4-any.pkg.tar.zst"; sha256 = "22a826a66335d42569e58da2a6b007f336f982b76d5ca8399e103ce840b75e92"; }];
    buildInputs = [ expat libiconv ncurses python readline xxhash zlib ];
  };

  "gdb-multiarch" = fetch {
    pname       = "gdb-multiarch";
    version     = "9.2";
    sources     = [{ filename = "mingw-w64-i686-gdb-multiarch-9.2-4-any.pkg.tar.zst"; sha256 = "dad8bc67ca08d5571fc47b59be36cc5ddc1fda46d589f0e4186f3399cc98b080"; }];
    buildInputs = [ gdb ];
  };

  "gdbm" = fetch {
    pname       = "gdbm";
    version     = "1.18.1";
    sources     = [{ filename = "mingw-w64-i686-gdbm-1.18.1-2-any.pkg.tar.xz"; sha256 = "9c6c2ea34ca52396ec1c417e79c1c4999fd4b769ac975db8a2e887009efe6d46"; }];
    buildInputs = [ gcc-libs gettext libiconv ];
  };

  "gdcm" = fetch {
    pname       = "gdcm";
    version     = "3.0.8";
    sources     = [{ filename = "mingw-w64-i686-gdcm-3.0.8-1-any.pkg.tar.zst"; sha256 = "29ec4ab797420c27434839be2dca9835f4fee2f3366edfba4a2ecb6043f89b9d"; }];
    buildInputs = [ expat gcc-libs lcms2 libxml2 libxslt json-c openssl poppler zlib ];
  };

  "gdk-pixbuf2" = fetch {
    pname       = "gdk-pixbuf2";
    version     = "2.40.0";
    sources     = [{ filename = "mingw-w64-i686-gdk-pixbuf2-2.40.0-1-any.pkg.tar.xz"; sha256 = "bdd57b791d9b810e4487cb5885c059bc3d556d4eee1aee8c10b91900715bf1fc"; }];
    buildInputs = [ gcc-libs (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.37.2"; glib2) jasper libjpeg-turbo libpng libtiff ];
  };

  "gdl" = fetch {
    pname       = "gdl";
    version     = "3.34.0";
    sources     = [{ filename = "mingw-w64-i686-gdl-3.34.0-1-any.pkg.tar.xz"; sha256 = "32a2d972f0b421b77668810bd88428f2a50586526abc44948b06a87163f57ddc"; }];
    buildInputs = [ gtk3 libxml2 ];
  };

  "gdl2" = fetch {
    pname       = "gdl2";
    version     = "2.31.2";
    sources     = [{ filename = "mingw-w64-i686-gdl2-2.31.2-2-any.pkg.tar.xz"; sha256 = "eed4c980a0b5f311c3c207835b47feafbcf136c81a50baf3dc08e665b9eb7098"; }];
    buildInputs = [ gtk2 libxml2 ];
  };

  "gdlmm2" = fetch {
    pname       = "gdlmm2";
    version     = "2.30.0";
    sources     = [{ filename = "mingw-w64-i686-gdlmm2-2.30.0-2-any.pkg.tar.xz"; sha256 = "83a9e715ad71f611265e05db0eb514c7825d589ce2a9564deddb1cdb226df678"; }];
    buildInputs = [ gtk2 libxml2 ];
  };

  "geany" = fetch {
    pname       = "geany";
    version     = "1.36.0";
    sources     = [{ filename = "mingw-w64-i686-geany-1.36.0-2-any.pkg.tar.xz"; sha256 = "61863dddbc585e2abd78583585d239eaf215512be8234cfdc5aab407b527da4a"; }];
    buildInputs = [ gtk3 adwaita-icon-theme python3 ];
  };

  "geany-plugins" = fetch {
    pname       = "geany-plugins";
    version     = "1.36.0";
    sources     = [{ filename = "mingw-w64-i686-geany-plugins-1.36.0-1-any.pkg.tar.xz"; sha256 = "e7df14d4bd66abfdd2c2d8acc23bb342425969ce649b37819d21077fd3d58a2c"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast geany.version "1.36.0"; geany) discount gtkspell3 ctpl-git gpgme lua51 gtk3 libgit2 hicolor-icon-theme ];
  };

  "gedit" = fetch {
    pname       = "gedit";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-gedit-3.38.0-1-any.pkg.tar.zst"; sha256 = "30030d06da58a6508f041b33203c76b2b15ac56f6be1e5de87c6633c2022e3b9"; }];
    buildInputs = [ adwaita-icon-theme appstream-glib gsettings-desktop-schemas gtksourceview4 gtk3 libpeas python-gobject gspell gobject-introspection-runtime tepl5 ];
  };

  "gedit-plugins" = fetch {
    pname       = "gedit-plugins";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-gedit-plugins-3.38.0-1-any.pkg.tar.zst"; sha256 = "60ab3cc3885f7a256d88917cd1f0aa40a2a32ffcf02f6b86293ee69b8f6a8af3"; }];
    buildInputs = [ gedit libgit2-glib libpeas ];
  };

  "gegl" = fetch {
    pname       = "gegl";
    version     = "0.4.26";
    sources     = [{ filename = "mingw-w64-i686-gegl-0.4.26-1-any.pkg.tar.zst"; sha256 = "7e748ee8a1eccb8a01101d2f2076ddd2bfed23be64d2b933016b50f2568955ae"; }];
    buildInputs = [ babl cairo exiv2 gexiv2 gcc-libs gdk-pixbuf2 gettext glib2 jasper json-glib libjpeg libpng libraw librsvg libspiro libwebp lcms lensfun openexr pango SDL2 suitesparse ];
  };

  "geocode-glib" = fetch {
    pname       = "geocode-glib";
    version     = "3.26.2";
    sources     = [{ filename = "mingw-w64-i686-geocode-glib-3.26.2-1-any.pkg.tar.xz"; sha256 = "2205baaec9ce833169fd740117577c255db8064affe48f9928ee4b2a1c4e4ec7"; }];
    buildInputs = [ glib2 json-glib libsoup ];
  };

  "geoip" = fetch {
    pname       = "geoip";
    version     = "1.6.12";
    sources     = [{ filename = "mingw-w64-i686-geoip-1.6.12-1-any.pkg.tar.xz"; sha256 = "28ecc2751578272468cd2c5fa99946e99f3d7f2cd51e8269b1dcbd3862f17a25"; }];
    buildInputs = [ geoip2-database zlib ];
  };

  "geoip2-database" = fetch {
    pname       = "geoip2-database";
    version     = "20190624";
    sources     = [{ filename = "mingw-w64-i686-geoip2-database-20190624-1-any.pkg.tar.xz"; sha256 = "68558c01302cba4f8bc2ea02af6aabeb64b40ff28a5e3cc8e838a26ecb3b4bf4"; }];
    buildInputs = [  ];
  };

  "geos" = fetch {
    pname       = "geos";
    version     = "3.8.0";
    sources     = [{ filename = "mingw-w64-i686-geos-3.8.0-1-any.pkg.tar.xz"; sha256 = "12057f11f40064fcbf377e84a2330685896b8914d4341daf955d3c9f4d410c0f"; }];
    buildInputs = [  ];
  };

  "gettext" = fetch {
    pname       = "gettext";
    version     = "0.19.8.1";
    sources     = [{ filename = "mingw-w64-i686-gettext-0.19.8.1-9-any.pkg.tar.zst"; sha256 = "0a39fbf759d28d711c67578c3261033f430c194807daeb7adf4e840bb5bed7b5"; }];
    buildInputs = [ expat gcc-libs libiconv ];
  };

  "gexiv2" = fetch {
    pname       = "gexiv2";
    version     = "0.12.1";
    sources     = [{ filename = "mingw-w64-i686-gexiv2-0.12.1-1-any.pkg.tar.zst"; sha256 = "d83de39700477ec8002e55c8e058ea9ba105d3ef5f8415bd3c92cbf19a13b0d1"; }];
    buildInputs = [ glib2 exiv2 ];
  };

  "gflags" = fetch {
    pname       = "gflags";
    version     = "2.2.2";
    sources     = [{ filename = "mingw-w64-i686-gflags-2.2.2-2-any.pkg.tar.xz"; sha256 = "a9a1211424a0a692641620c115a784efc6653b43745b9ed06df7e1e5d3dd7218"; }];
    buildInputs = [  ];
  };

  "ghex" = fetch {
    pname       = "ghex";
    version     = "3.18.4";
    sources     = [{ filename = "mingw-w64-i686-ghex-3.18.4-2-any.pkg.tar.zst"; sha256 = "5de75b81ae52d63d47b1aab7ad0b0734f38ab568a94d979cf892322f08bfe9fc"; }];
    buildInputs = [ gtk3 ];
  };

  "ghostscript" = fetch {
    pname       = "ghostscript";
    version     = "9.50";
    sources     = [{ filename = "mingw-w64-i686-ghostscript-9.50-1-any.pkg.tar.xz"; sha256 = "340614cd115c23a74e136f52b85afb36917db59e208e19aa6599c63793cbf2a3"; }];
    buildInputs = [ dbus expat freetype fontconfig gdk-pixbuf2 jbig2dec libiconv libidn libpaper libpng libjpeg libtiff openjpeg2 zlib ];
  };

  "giflib" = fetch {
    pname       = "giflib";
    version     = "5.2.1";
    sources     = [{ filename = "mingw-w64-i686-giflib-5.2.1-1-any.pkg.tar.xz"; sha256 = "041e52e31fb54a18e0eb7e7c619a49b5424e8290dcbb9ee150513e3b2f4da358"; }];
    buildInputs = [ gcc-libs ];
  };

  "gimp" = fetch {
    pname       = "gimp";
    version     = "2.10.22";
    sources     = [{ filename = "mingw-w64-i686-gimp-2.10.22-1-any.pkg.tar.zst"; sha256 = "fe92401a2225a045cee67653b41c65d9d4b37f63b51b47b821ec0189f9f3e677"; }];
    buildInputs = [ babl curl dbus-glib drmingw gegl gexiv2 ghostscript glib-networking hicolor-icon-theme iso-codes jasper lcms2 libexif libheif libmng libmypaint librsvg libwmf mypaint-brushes openexr openjpeg2 poppler python2-pygtk python2-gobject2 xpm-nox ];
  };

  "gimp-ufraw" = fetch {
    pname       = "gimp-ufraw";
    version     = "0.22";
    sources     = [{ filename = "mingw-w64-i686-gimp-ufraw-0.22-2-any.pkg.tar.xz"; sha256 = "fb66970b08a564c8744c1c39212d8de1dd5f34bf4ef4a9ecdea3e5981789e1cf"; }];
    buildInputs = [ bzip2 cfitsio exiv2 gtkimageview lcms lensfun ];
  };

  "git-lfs" = fetch {
    pname       = "git-lfs";
    version     = "2.11.0";
    sources     = [{ filename = "mingw-w64-i686-git-lfs-2.11.0-1-any.pkg.tar.zst"; sha256 = "e9f8102bfa4f0a302ae78e16d01ff7651efc60a420f27418d9a876ebde842738"; }];
    buildInputs = [ git ];
    broken      = true; # broken dependency git-lfs -> git
  };

  "git-repo" = fetch {
    pname       = "git-repo";
    version     = "0.4.20";
    sources     = [{ filename = "mingw-w64-i686-git-repo-0.4.20-1-any.pkg.tar.xz"; sha256 = "16f53560007670c53539d12a16e88c5922fe0e8471cd5e1e6cc448e92a19ba25"; }];
    buildInputs = [ python3 ];
  };

  "gitg" = fetch {
    pname       = "gitg";
    version     = "3.32.1";
    sources     = [{ filename = "mingw-w64-i686-gitg-3.32.1-2-any.pkg.tar.xz"; sha256 = "446e636e8e6ed2880dbff6edf3841160f79bbea8dd77563590c2889a2f49e0a0"; }];
    buildInputs = [ adwaita-icon-theme gtksourceview3 libpeas enchant iso-codes python3-gobject gsettings-desktop-schemas libsoup libsecret gtkspell3 libgit2-glib libdazzle libgee ];
    broken      = true; # broken dependency gitg -> python3-gobject
  };

  "gl2ps" = fetch {
    pname       = "gl2ps";
    version     = "1.4.2";
    sources     = [{ filename = "mingw-w64-i686-gl2ps-1.4.2-1-any.pkg.tar.zst"; sha256 = "1f03f0a3b641426ff4c4a593d591b60f19e28e7ec4d84573cda56696c18fd038"; }];
    buildInputs = [ libpng ];
  };

  "glade" = fetch {
    pname       = "glade";
    version     = "3.38.1";
    sources     = [{ filename = "mingw-w64-i686-glade-3.38.1-1-any.pkg.tar.zst"; sha256 = "53bc228b780f3a8668ad9b3ddb1143f9648b80b717235836c1b50888902a4f43"; }];
    buildInputs = [ gtk3 libxml2 adwaita-icon-theme ];
  };

  "glade-gtk2" = fetch {
    pname       = "glade-gtk2";
    version     = "3.8.6";
    sources     = [{ filename = "mingw-w64-i686-glade-gtk2-3.8.6-3-any.pkg.tar.zst"; sha256 = "213449414cecaefa18fec9d40aab07bac7ad3236cfe435d056aea54574520c48"; }];
    buildInputs = [ gtk2 libxml2 ];
  };

  "glbinding" = fetch {
    pname       = "glbinding";
    version     = "3.1.0";
    sources     = [{ filename = "mingw-w64-i686-glbinding-3.1.0-2-any.pkg.tar.xz"; sha256 = "4cb39a6bc63d5850798f4fe8bd8fdee4eba9b4a4f81923a49367c68051666eed"; }];
    buildInputs = [ gcc-libs ];
  };

  "glew" = fetch {
    pname       = "glew";
    version     = "2.2.0";
    sources     = [{ filename = "mingw-w64-i686-glew-2.2.0-2-any.pkg.tar.zst"; sha256 = "aeff253c423c50a1515b9dbe3e52deebbefbcd2def0201ee256c3b3aef783696"; }];
  };

  "glfw" = fetch {
    pname       = "glfw";
    version     = "3.3.2";
    sources     = [{ filename = "mingw-w64-i686-glfw-3.3.2-1-any.pkg.tar.xz"; sha256 = "eb49eae643cf9f81b6cb334092fc4ca8ebd85ba6b22264823693362dc24afa49"; }];
    buildInputs = [ gcc-libs ];
  };

  "glib-networking" = fetch {
    pname       = "glib-networking";
    version     = "2.66.0";
    sources     = [{ filename = "mingw-w64-i686-glib-networking-2.66.0-1-any.pkg.tar.zst"; sha256 = "2465cc5a7861d5013ed796df85b50896daa39c4e60b88b25a0720cce7a317f4a"; }];
    buildInputs = [ gcc-libs gettext glib2 gnutls libproxy openssl gsettings-desktop-schemas ];
  };

  "glib2" = fetch {
    pname       = "glib2";
    version     = "2.66.2";
    sources     = [{ filename = "mingw-w64-i686-glib2-2.66.2-1-any.pkg.tar.zst"; sha256 = "f53a26a81a7f25ecf8fe07790f07689ad3d318b93ebb3423505bdc5575e15d43"; }];
    buildInputs = [ gcc-libs gettext pcre libffi zlib python ];
  };

  "glibmm" = fetch {
    pname       = "glibmm";
    version     = "2.64.2";
    sources     = [{ filename = "mingw-w64-i686-glibmm-2.64.2-1-any.pkg.tar.xz"; sha256 = "7fd76ccadfe4c730e1fa1c154912368c5309728f78ee2624d1fe5c5127d8c762"; }];
    buildInputs = [ self."libsigc++" glib2 ];
  };

  "glm" = fetch {
    pname       = "glm";
    version     = "0.9.9.8";
    sources     = [{ filename = "mingw-w64-i686-glm-0.9.9.8-1-any.pkg.tar.xz"; sha256 = "7a4d5c4b791f7b82a5a3eb3b691808c9b41493147d9eda7bb4c34c5320edf0a9"; }];
    buildInputs = [ gcc-libs ];
  };

  "global" = fetch {
    pname       = "global";
    version     = "6.6.5";
    sources     = [{ filename = "mingw-w64-i686-global-6.6.5-1-any.pkg.tar.zst"; sha256 = "a48e8eb6e92d0b0701497cc590a966d40999b942f66b4226719473f1ec5ccfb4"; }];
  };

  "globjects" = fetch {
    pname       = "globjects";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-globjects-1.1.0-1-any.pkg.tar.xz"; sha256 = "41a71b45b0ca7427356fa142461b088790f207dfbd39899974a796efefefc525"; }];
    buildInputs = [ gcc-libs glbinding glm ];
  };

  "glog" = fetch {
    pname       = "glog";
    version     = "0.4.0";
    sources     = [{ filename = "mingw-w64-i686-glog-0.4.0-2-any.pkg.tar.xz"; sha256 = "403345c922696e2af84bf513ad5e2c838dd924299b3b0d28b4ea7ea33e842fe8"; }];
    buildInputs = [ gflags libunwind ];
  };

  "glpk" = fetch {
    pname       = "glpk";
    version     = "4.65";
    sources     = [{ filename = "mingw-w64-i686-glpk-4.65-2-any.pkg.tar.zst"; sha256 = "8e577e057f792a0b546121ec1a37f8e7d73820fa924d8dcad45035273ed23b28"; }];
    buildInputs = [ gmp ];
  };

  "glsl-optimizer-git" = fetch {
    pname       = "glsl-optimizer-git";
    version     = "r66914.9a2852138d";
    sources     = [{ filename = "mingw-w64-i686-glsl-optimizer-git-r66914.9a2852138d-1-any.pkg.tar.xz"; sha256 = "bab09eca3f1bf427158ec8d3961982fa36520676efbfb8a6fb38c699ae9aa12c"; }];
  };

  "glslang" = fetch {
    pname       = "glslang";
    version     = "8.13.3743";
    sources     = [{ filename = "mingw-w64-i686-glslang-8.13.3743-2-any.pkg.tar.zst"; sha256 = "bc4e38693e6a87abe8d6706574b3531b2b73b73f4097b8e876c38b8cdc8804bd"; }];
    buildInputs = [ gcc-libs ];
  };

  "gmic" = fetch {
    pname       = "gmic";
    version     = "2.9.0";
    sources     = [{ filename = "mingw-w64-i686-gmic-2.9.0-3-any.pkg.tar.zst"; sha256 = "612fe185adc73a13111d29d8709da571267d5077863315a4a3c6860b1cea9e2a"; }];
    buildInputs = [ fftw graphicsmagick libpng libjpeg libtiff curl openexr opencv ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "gmime" = fetch {
    pname       = "gmime";
    version     = "3.2.7";
    sources     = [{ filename = "mingw-w64-i686-gmime-3.2.7-1-any.pkg.tar.xz"; sha256 = "edd3af8d1645352e11814aa6442c625cf1599f50c07a6e7f0edf83a63d9a3e45"; }];
    buildInputs = [ glib2 gpgme libiconv ];
  };

  "gmp" = fetch {
    pname       = "gmp";
    version     = "6.2.0";
    sources     = [{ filename = "mingw-w64-i686-gmp-6.2.0-3-any.pkg.tar.zst"; sha256 = "557ca836a4100c2df1327cccd8d441d901226e837b092b66856fbaca06444164"; }];
    buildInputs = [  ];
  };

  "gnome-calculator" = fetch {
    pname       = "gnome-calculator";
    version     = "3.38.1";
    sources     = [{ filename = "mingw-w64-i686-gnome-calculator-3.38.1-1-any.pkg.tar.zst"; sha256 = "ca89fdd8e8b0d4866705c117d46b247f0cc4b31d063c44511632783a50636627"; }];
    buildInputs = [ glib2 gtk3 gtksourceview4 gsettings-desktop-schemas libsoup mpfr ];
  };

  "gnome-common" = fetch {
    pname       = "gnome-common";
    version     = "3.18.0";
    sources     = [{ filename = "mingw-w64-i686-gnome-common-3.18.0-1-any.pkg.tar.xz"; sha256 = "e782a790331591237a2364daf903ab4a92d374c24c456156b5ccd1ba7930b1c2"; }];
  };

  "gnome-latex" = fetch {
    pname       = "gnome-latex";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-gnome-latex-3.38.0-1-any.pkg.tar.zst"; sha256 = "ab10ba7e5b845cd4b545b0cefc33b52dd880585f07f422b9c86338fe90188003"; }];
    buildInputs = [ gsettings-desktop-schemas gtk3 gtksourceview4 gspell tepl5 libgee ];
  };

  "gnucobol" = fetch {
    pname       = "gnucobol";
    version     = "3.1rc1";
    sources     = [{ filename = "mingw-w64-i686-gnucobol-3.1rc1-2-any.pkg.tar.zst"; sha256 = "3aa967c0582a1d2e382e36369f2f90ce476fcf6019ad10e92e3b3e018a188f30"; }];
    buildInputs = [ gcc gmp gettext ncurses db ];
  };

  "gnupg" = fetch {
    pname       = "gnupg";
    version     = "2.2.23";
    sources     = [{ filename = "mingw-w64-i686-gnupg-2.2.23-1-any.pkg.tar.zst"; sha256 = "4a08c7e0cce9ec84d5defbea8c6b67425714aa3409c9fc9333d0985821bbd160"; }];
    buildInputs = [ adns bzip2 curl gnutls libksba libgcrypt libassuan libsystre libusb-compat-git npth readline sqlite3 zlib ];
  };

  "gnuplot" = fetch {
    pname       = "gnuplot";
    version     = "5.4.0";
    sources     = [{ filename = "mingw-w64-i686-gnuplot-5.4.0-2-any.pkg.tar.zst"; sha256 = "6fb0424c1c6e2f71360930717e188c91ca3e92c3594d90f608bbd42bf22bf736"; }];
    buildInputs = [ cairo gnutls libcaca libcerf libgd pango readline wxWidgets ];
  };

  "gnutls" = fetch {
    pname       = "gnutls";
    version     = "3.6.15";
    sources     = [{ filename = "mingw-w64-i686-gnutls-3.6.15-2-any.pkg.tar.zst"; sha256 = "94d1490a27e37824288d3e0f879b5b6d421ecf949943c1525471b790e06a2dc6"; }];
    buildInputs = [ gcc-libs gmp libidn2 libsystre libtasn1 (assert stdenvNoCC.lib.versionAtLeast nettle.version "3.6"; nettle) (assert stdenvNoCC.lib.versionAtLeast p11-kit.version "0.23.1"; p11-kit) libunistring zlib ];
  };

  "go" = fetch {
    pname       = "go";
    version     = "1.14.4";
    sources     = [{ filename = "mingw-w64-i686-go-1.14.4-1-any.pkg.tar.zst"; sha256 = "536722b50afdf6600ce8040588661a0889ff0c19b0a12ca7c170f8eddd26292f"; }];
  };

  "gobject-introspection" = fetch {
    pname       = "gobject-introspection";
    version     = "1.66.1";
    sources     = [{ filename = "mingw-w64-i686-gobject-introspection-1.66.1-1-any.pkg.tar.zst"; sha256 = "15d76f899066a5d9297622a0f53980dbd1757263602252d1987faa0d4362418f"; }];
    buildInputs = [ (assert gobject-introspection-runtime.version=="1.66.1"; gobject-introspection-runtime) pkg-config python python-mako ];
  };

  "gobject-introspection-runtime" = fetch {
    pname       = "gobject-introspection-runtime";
    version     = "1.66.1";
    sources     = [{ filename = "mingw-w64-i686-gobject-introspection-runtime-1.66.1-1-any.pkg.tar.zst"; sha256 = "dd60c40abf3bd8b242b18be3e2a619aeca1cd997d3f69356edf7515de935a1e9"; }];
    buildInputs = [ glib2 libffi ];
  };

  "goocanvas" = fetch {
    pname       = "goocanvas";
    version     = "2.0.4";
    sources     = [{ filename = "mingw-w64-i686-goocanvas-2.0.4-4-any.pkg.tar.xz"; sha256 = "ece403f85006b5a8ff7abe20acbb29da6b6e0248914d5632c89df97d76e1c2e0"; }];
    buildInputs = [ gtk3 ];
  };

  "gperf" = fetch {
    pname       = "gperf";
    version     = "3.1";
    sources     = [{ filename = "mingw-w64-i686-gperf-3.1-1-any.pkg.tar.xz"; sha256 = "24d7ad4995528201c35c6ec68a431f6963bc45d79149ad8f92d33cc2653b7971"; }];
    buildInputs = [ gcc-libs ];
  };

  "gpgme" = fetch {
    pname       = "gpgme";
    version     = "1.14.0";
    sources     = [{ filename = "mingw-w64-i686-gpgme-1.14.0-1-any.pkg.tar.zst"; sha256 = "a43ec0697cf63979a1a2a1dabd019688d09f20d448c208eefc8fdca3092619c7"; }];
    buildInputs = [ glib2 gnupg libassuan libgpg-error npth ];
  };

  "gphoto2" = fetch {
    pname       = "gphoto2";
    version     = "2.5.23";
    sources     = [{ filename = "mingw-w64-i686-gphoto2-2.5.23-2-any.pkg.tar.zst"; sha256 = "ca3d5c3bfb6c8910ee374d62787d9ae0749613029dd4fac8ebbfc0d19c5b15ab"; }];
    buildInputs = [ libgphoto2 readline popt ];
  };

  "gplugin" = fetch {
    pname       = "gplugin";
    version     = "0.29.0";
    sources     = [{ filename = "mingw-w64-i686-gplugin-0.29.0-1-any.pkg.tar.xz"; sha256 = "0de1743d8e4c50ff7f75cc865e45b6e26c5a734e18a4efc49c3495507e0ab11a"; }];
    buildInputs = [ gtk3 ];
  };

  "gprbuild" = fetch {
    pname       = "gprbuild";
    version     = "2021.0.0";
    sources     = [{ filename = "mingw-w64-i686-gprbuild-2021.0.0-1-any.pkg.tar.zst"; sha256 = "9346b100a95e8a8156b8eef06b67475ebba6f1aff60d08adecb51cd22a76bab6"; }];
    buildInputs = [ gcc-ada xmlada ];
  };

  "gprbuild-bootstrap-git" = fetch {
    pname       = "gprbuild-bootstrap-git";
    version     = "2021.0.0";
    sources     = [{ filename = "mingw-w64-i686-gprbuild-bootstrap-git-2021.0.0-1-any.pkg.tar.zst"; sha256 = "6af94c6c35225c6d30f814dcdcee182527dacab2b0dd48d3749dbc42eb9458e3"; }];
    buildInputs = [ gcc-libs ];
  };

  "gr" = fetch {
    pname       = "gr";
    version     = "0.52.0";
    sources     = [{ filename = "mingw-w64-i686-gr-0.52.0-1-any.pkg.tar.zst"; sha256 = "5f5992a3e31ac7994dbc734e93db8c2aa9bd0c0ae779cb664942c8ddbe5e85c0"; }];
    buildInputs = [ bzip2 cairo ffmpeg freetype glfw libjpeg libpng libtiff qhull-git qt5 zlib ];
  };

  "grantlee" = fetch {
    pname       = "grantlee";
    version     = "5.2.0";
    sources     = [{ filename = "mingw-w64-i686-grantlee-5.2.0-1-any.pkg.tar.xz"; sha256 = "d8fcc7de069beff1738aabc4b77d9377c31fc98fc8617157f0b7355ec2268c46"; }];
  };

  "graphene" = fetch {
    pname       = "graphene";
    version     = "1.10.2";
    sources     = [{ filename = "mingw-w64-i686-graphene-1.10.2-1-any.pkg.tar.zst"; sha256 = "5ec7f4d5e2c457972fc7a36c9646249805be27aca2b49ca75bf24a84584c1b21"; }];
    buildInputs = [ glib2 ];
  };

  "graphicsmagick" = fetch {
    pname       = "graphicsmagick";
    version     = "1.3.35";
    sources     = [{ filename = "mingw-w64-i686-graphicsmagick-1.3.35-1-any.pkg.tar.xz"; sha256 = "5fe83d190bff9d1bed24571882f57eb62117adb6f2ea71737a7065aae0c677ac"; }];
    buildInputs = [ bzip2 fontconfig freetype gcc-libs glib2 jasper jbigkit lcms2 libxml2 libpng libtiff libwebp libwmf libtool libwinpthread-git xz zlib zstd ];
  };

  "graphite2" = fetch {
    pname       = "graphite2";
    version     = "1.3.14";
    sources     = [{ filename = "mingw-w64-i686-graphite2-1.3.14-2-any.pkg.tar.zst"; sha256 = "61c12dbc917d26be982a1a1d270ec015a78c0451635c46e429dc47c051ccdf2d"; }];
    buildInputs = [ gcc-libs ];
  };

  "graphviz" = fetch {
    pname       = "graphviz";
    version     = "2.40.1";
    sources     = [{ filename = "mingw-w64-i686-graphviz-2.40.1-13-any.pkg.tar.zst"; sha256 = "2690ae769df2e187aec0dab0370c16832bf644608c15963b58f43b33eac36474"; }];
    buildInputs = [ cairo devil expat freetype glib2 gtk2 gtkglext fontconfig freeglut libglade libgd libpng libsystre libwebp gts pango poppler zlib libtool ];
  };

  "grep" = fetch {
    pname       = "grep";
    version     = "3.4";
    sources     = [{ filename = "mingw-w64-i686-grep-3.4-1-any.pkg.tar.zst"; sha256 = "1cf3b371f7cef99027a959c8fb6b3763f7fc3ebe5aa81e17241784d31aec4dc7"; }];
    buildInputs = [ pcre ];
  };

  "groonga" = fetch {
    pname       = "groonga";
    version     = "10.0.7";
    sources     = [{ filename = "mingw-w64-i686-groonga-10.0.7-1-any.pkg.tar.zst"; sha256 = "a3aca49679e6cb17755f8d4d6b92bbdbd1eb750811146fe4803c5c1267d3af72"; }];
    buildInputs = [ arrow luajit lz4 msgpack-c onigmo openssl pcre rapidjson mecab mecab-naist-jdic zeromq zlib zstd ];
    broken      = true; # broken dependency arrow -> python3-numpy
  };

  "grpc" = fetch {
    pname       = "grpc";
    version     = "1.29.1";
    sources     = [{ filename = "mingw-w64-i686-grpc-1.29.1-1-any.pkg.tar.zst"; sha256 = "5f60ff83313a392c142b41f095d39319b7af5a194f17c61356629c6fedb5f585"; }];
    buildInputs = [ gcc-libs c-ares gflags openssl (assert stdenvNoCC.lib.versionAtLeast protobuf.version "3.5.0"; protobuf) zlib ];
  };

  "gsasl" = fetch {
    pname       = "gsasl";
    version     = "1.8.1";
    sources     = [{ filename = "mingw-w64-i686-gsasl-1.8.1-1-any.pkg.tar.xz"; sha256 = "d25fe0703df09c304b5dc29a0b3e06235b1dca03700a79a3c4f9405dd37122ff"; }];
    buildInputs = [ gss gnutls libidn libgcrypt libntlm readline ];
  };

  "gsettings-desktop-schemas" = fetch {
    pname       = "gsettings-desktop-schemas";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-gsettings-desktop-schemas-3.38.0-1-any.pkg.tar.zst"; sha256 = "d76eb06a99548c17c5983efded48c7f302e0644f811eb8bb81c4c51595fbe846"; }];
    buildInputs = [ glib2 adobe-source-code-pro-fonts cantarell-fonts ];
  };

  "gsfonts" = fetch {
    pname       = "gsfonts";
    version     = "20200910";
    sources     = [{ filename = "mingw-w64-i686-gsfonts-20200910-1-any.pkg.tar.zst"; sha256 = "b2d8410010ea67b47d7e8aad520497c87ffbc101b2c789e1a27d7805e8131db7"; }];
  };

  "gsl" = fetch {
    pname       = "gsl";
    version     = "2.6";
    sources     = [{ filename = "mingw-w64-i686-gsl-2.6-1-any.pkg.tar.xz"; sha256 = "286864f38c368f638a86973ae33b143d72a0fd68469eab3c1bc9d0c6b4c829b4"; }];
    buildInputs = [  ];
  };

  "gsm" = fetch {
    pname       = "gsm";
    version     = "1.0.19";
    sources     = [{ filename = "mingw-w64-i686-gsm-1.0.19-1-any.pkg.tar.xz"; sha256 = "c4404b511e94ed1ebe4d4f6063ec839a22965df998c7d03767dde258292c4a1f"; }];
    buildInputs = [  ];
  };

  "gsoap" = fetch {
    pname       = "gsoap";
    version     = "2.8.101";
    sources     = [{ filename = "mingw-w64-i686-gsoap-2.8.101-1-any.pkg.tar.xz"; sha256 = "1d3c5cdef15f2403a0410eb1d69b4a9ed86acb62a19a667f32642caa168c320f"; }];
  };

  "gspell" = fetch {
    pname       = "gspell";
    version     = "1.8.4";
    sources     = [{ filename = "mingw-w64-i686-gspell-1.8.4-1-any.pkg.tar.zst"; sha256 = "f61009e1d7f34cf7d771e6af700cada200d21e483760430806ecb22ebcbffc34"; }];
    buildInputs = [ gtk3 iso-codes enchant ];
  };

  "gss" = fetch {
    pname       = "gss";
    version     = "1.0.3";
    sources     = [{ filename = "mingw-w64-i686-gss-1.0.3-1-any.pkg.tar.xz"; sha256 = "abaef426e612be0388cc31ba8164a9a2998dcf44534cf3d158992f658bb1a7c8"; }];
    buildInputs = [ gcc-libs shishi-git ];
  };

  "gst-devtools" = fetch {
    pname       = "gst-devtools";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-gst-devtools-1.18.0-1-any.pkg.tar.zst"; sha256 = "2a3074111c2c2cec48242c41fd07b0fb3438ae520fe0a3eb0d4109cf60ff1fca"; }];
    buildInputs = [ gstreamer gst-plugins-base json-glib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-editing-services" = fetch {
    pname       = "gst-editing-services";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-gst-editing-services-1.18.0-1-any.pkg.tar.zst"; sha256 = "d4378eea085c4794e94737113a0d802ad77979ae24d0d913473d863cd22c05a1"; }];
    buildInputs = [ gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-libav" = fetch {
    pname       = "gst-libav";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-gst-libav-1.18.0-1-any.pkg.tar.zst"; sha256 = "904f91a31bb53542c5c8ce31c8f27110a9bfc185aaa2f628165b95a54a0a9aa6"; }];
    buildInputs = [ gst-plugins-base ffmpeg ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-bad" = fetch {
    pname       = "gst-plugins-bad";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-gst-plugins-bad-1.18.0-2-any.pkg.tar.zst"; sha256 = "11a122864204fe63c0cfe7262afa884750b395a0bd5ca4b8a2e0218691c0dcd6"; }];
    buildInputs = [ aom bzip2 cairo chromaprint curl faad2 faac fdk-aac fluidsynth gsm gst-plugins-base gtk3 lcms2 libass libbs2b libdca libdvdnav libdvdread libexif libgme libjpeg libmodplug libmpeg2-git libnice librsvg libsndfile libsrtp libssh2 libwebp libxml2 libmicrodns nettle openal opencv openexr openh264 openjpeg2 openssl opus orc pango rtmpdump-git soundtouch srt vo-amrwbenc vulkan-validation-layers x265 zbar ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-base" = fetch {
    pname       = "gst-plugins-base";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-gst-plugins-base-1.18.0-1-any.pkg.tar.zst"; sha256 = "039c2838640e47e1ce1b3ead0424583cfa5662ef4475df8cc0d6e95371927af9"; }];
    buildInputs = [ graphene gstreamer libogg libtheora libvorbis libvorbisidec libpng libjpeg opus orc pango iso-codes zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-good" = fetch {
    pname       = "gst-plugins-good";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-gst-plugins-good-1.18.0-1-any.pkg.tar.zst"; sha256 = "ad47b0dad9b2adf80ca835d0b361a9bfdd2e0bbe8a0ebfe376066b6f2c2af4ba"; }];
    buildInputs = [ bzip2 cairo flac gdk-pixbuf2 gst-plugins-base gtk3 lame libcaca libjpeg libpng libshout libsoup libvpx mpg123 speex taglib twolame wavpack zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-ugly" = fetch {
    pname       = "gst-plugins-ugly";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-gst-plugins-ugly-1.18.0-1-any.pkg.tar.zst"; sha256 = "42a8d289520b2ad77736a3f1ad2427c8aa291c50e6b7695a3ce836a6b4ed6b9f"; }];
    buildInputs = [ a52dec gst-plugins-base libcdio libdvdread libmpeg2-git opencore-amr x264-git ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-python" = fetch {
    pname       = "gst-python";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-gst-python-1.18.0-2-any.pkg.tar.zst"; sha256 = "2aa095e53a26ea40a0a611bece00feb48f89a0d768df1ee616cad1f1a08e0f13"; }];
    buildInputs = [ gstreamer gst-plugins-base python-gobject ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-rtsp-server" = fetch {
    pname       = "gst-rtsp-server";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-gst-rtsp-server-1.18.0-1-any.pkg.tar.zst"; sha256 = "6b3b7091f2c08c6615a3b48473eca255a0a7264a6e5361767fe2ad74e116df32"; }];
    buildInputs = [ gcc-libs glib2 gettext gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gstreamer" = fetch {
    pname       = "gstreamer";
    version     = "1.18.0";
    sources     = [{ filename = "mingw-w64-i686-gstreamer-1.18.0-2-any.pkg.tar.zst"; sha256 = "d195489e7935fc19105a9c8f3fd8bcbb2faf3afbc8f5d61396735bb47152e243"; }];
    buildInputs = [ gcc-libs libxml2 glib2 gettext gmp gsl ];
  };

  "gtest" = fetch {
    pname       = "gtest";
    version     = "1.10.0";
    sources     = [{ filename = "mingw-w64-i686-gtest-1.10.0-1-any.pkg.tar.xz"; sha256 = "8dc983327cbcffafcd39edb35fe15e180e7d3ca362ce0ad4381103d7fe35e628"; }];
    buildInputs = [ python gcc-libs ];
  };

  "gtk-doc" = fetch {
    pname       = "gtk-doc";
    version     = "1.33.0";
    sources     = [{ filename = "mingw-w64-i686-gtk-doc-1.33.0-2-any.pkg.tar.zst"; sha256 = "b94861642f64287cc3e7f29a3f554d38c061e5dcb692adb7b41f0a7faa84f94e"; }];
    buildInputs = [ docbook-xsl docbook-xml libxslt python3 python3-pygments ];
    broken      = true; # broken dependency gtk-doc -> python3-pygments
  };

  "gtk-engine-murrine" = fetch {
    pname       = "gtk-engine-murrine";
    version     = "0.98.2";
    sources     = [{ filename = "mingw-w64-i686-gtk-engine-murrine-0.98.2-3-any.pkg.tar.xz"; sha256 = "f0563397f2892fc955fb5c941741e311e4c39e02a477eb621fddb0bb2e8df0c3"; }];
    buildInputs = [ gtk2 ];
  };

  "gtk-engines" = fetch {
    pname       = "gtk-engines";
    version     = "2.21.0";
    sources     = [{ filename = "mingw-w64-i686-gtk-engines-2.21.0-3-any.pkg.tar.xz"; sha256 = "b1673d478d335c71ccea0c5e8623bb270ccba565eb6294f449b5244431d40f76"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) ];
  };

  "gtk-vnc" = fetch {
    pname       = "gtk-vnc";
    version     = "1.0.0";
    sources     = [{ filename = "mingw-w64-i686-gtk-vnc-1.0.0-1-any.pkg.tar.xz"; sha256 = "104fa4974d5e671a4211ef085e99e47a69309e22a9b5d21b160edfab02357702"; }];
    buildInputs = [ cyrus-sasl gnutls gtk3 libgcrypt libgpg-error libview zlib ];
  };

  "gtk2" = fetch {
    pname       = "gtk2";
    version     = "2.24.32";
    sources     = [{ filename = "mingw-w64-i686-gtk2-2.24.32-5-any.pkg.tar.zst"; sha256 = "2dfd3e3ba36117ec26c076407b5861e16c7a019df1ea6331cbec621bf3ff5f74"; }];
    buildInputs = [ gcc-libs adwaita-icon-theme (assert stdenvNoCC.lib.versionAtLeast atk.version "1.29.2"; atk) (assert stdenvNoCC.lib.versionAtLeast cairo.version "1.6"; cairo) (assert stdenvNoCC.lib.versionAtLeast gdk-pixbuf2.version "2.21.0"; gdk-pixbuf2) (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.28.0"; glib2) (assert stdenvNoCC.lib.versionAtLeast pango.version "1.20"; pango) shared-mime-info ];
  };

  "gtk3" = fetch {
    pname       = "gtk3";
    version     = "3.24.23";
    sources     = [{ filename = "mingw-w64-i686-gtk3-3.24.23-1-any.pkg.tar.zst"; sha256 = "f231889d44c2bfe0c6dee6674cf5ad463f290f8b5b5a0153bb811e52cd168c4e"; }];
    buildInputs = [ gcc-libs adwaita-icon-theme atk cairo gdk-pixbuf2 glib2 json-glib libepoxy pango shared-mime-info ];
  };

  "gtk4" = fetch {
    pname       = "gtk4";
    version     = "3.99.1";
    sources     = [{ filename = "mingw-w64-i686-gtk4-3.99.1-1-any.pkg.tar.zst"; sha256 = "3fd0f562a7eba4d73e32d6121f5975494264ab93bb98ab830bf796c82f4865ed"; }];
    buildInputs = [ gcc-libs adwaita-icon-theme atk cairo gdk-pixbuf2 glib2 graphene json-glib libepoxy pango gst-plugins-bad shared-mime-info ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gtkglext" = fetch {
    pname       = "gtkglext";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-gtkglext-1.2.0-3-any.pkg.tar.xz"; sha256 = "00683a439a025da4ceb27c91f7232aca39573d680726fb406b0c3c46ba2204d6"; }];
    buildInputs = [ gcc-libs gtk2 gdk-pixbuf2 ];
  };

  "gtkimageview" = fetch {
    pname       = "gtkimageview";
    version     = "1.6.4";
    sources     = [{ filename = "mingw-w64-i686-gtkimageview-1.6.4-4-any.pkg.tar.xz"; sha256 = "7af52c5e4e8be004a4ecbec952fb769e9d352b7a0ae6b1340164894b237c875d"; }];
    buildInputs = [ gtk2 ];
  };

  "gtkmm" = fetch {
    pname       = "gtkmm";
    version     = "2.24.5";
    sources     = [{ filename = "mingw-w64-i686-gtkmm-2.24.5-2-any.pkg.tar.xz"; sha256 = "25e1dc076835c7dd6220ab0cacd8b10ea52e2f75fc28d89063d9696624b3ad47"; }];
    buildInputs = [ atkmm pangomm gtk2 ];
  };

  "gtkmm3" = fetch {
    pname       = "gtkmm3";
    version     = "3.24.2";
    sources     = [{ filename = "mingw-w64-i686-gtkmm3-3.24.2-1-any.pkg.tar.xz"; sha256 = "2e4687e8d9c883e047da0be3f28901fc8b090b0d9a4405bc0f3447cd9d3e983b"; }];
    buildInputs = [ gcc-libs atkmm pangomm gtk3 ];
  };

  "gtksourceview2" = fetch {
    pname       = "gtksourceview2";
    version     = "2.10.5";
    sources     = [{ filename = "mingw-w64-i686-gtksourceview2-2.10.5-3-any.pkg.tar.zst"; sha256 = "2792070e82d0816e698ada025cf510a59157edb7f7407c99e93df604548801e5"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.7"; libxml2) ];
  };

  "gtksourceview3" = fetch {
    pname       = "gtksourceview3";
    version     = "3.24.11";
    sources     = [{ filename = "mingw-w64-i686-gtksourceview3-3.24.11-1-any.pkg.tar.xz"; sha256 = "bb82b34af37cc524506fe2d8a33b0d9438f9931915cb8fd83d9877f856ff0017"; }];
    buildInputs = [ gtk3 libxml2 ];
  };

  "gtksourceview4" = fetch {
    pname       = "gtksourceview4";
    version     = "4.6.0";
    sources     = [{ filename = "mingw-w64-i686-gtksourceview4-4.6.0-1-any.pkg.tar.xz"; sha256 = "55614d9385b8d6d2a265b1acebb44cbeefabc705320f8580f3e4db863ded6e7e"; }];
    buildInputs = [ gtk3 libxml2 ];
  };

  "gtksourceviewmm2" = fetch {
    pname       = "gtksourceviewmm2";
    version     = "2.10.3";
    sources     = [{ filename = "mingw-w64-i686-gtksourceviewmm2-2.10.3-2-any.pkg.tar.xz"; sha256 = "36c224e5d09e771689aaeeb80aa236d877849fa74b8b8e6c51aee6be88cb6c7d"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.7"; libxml2) ];
  };

  "gtksourceviewmm3" = fetch {
    pname       = "gtksourceviewmm3";
    version     = "3.21.3";
    sources     = [{ filename = "mingw-w64-i686-gtksourceviewmm3-3.21.3-2-any.pkg.tar.xz"; sha256 = "3379233b9a0026d86b36f4c5bfc1bcd4353e34291897f943381283d10152a8ba"; }];
    buildInputs = [ gtksourceview3 gtkmm3 ];
  };

  "gtkspell" = fetch {
    pname       = "gtkspell";
    version     = "2.0.16";
    sources     = [{ filename = "mingw-w64-i686-gtkspell-2.0.16-7-any.pkg.tar.xz"; sha256 = "52778f82a4a6a5eb1b912c17f915cbb0ab620ce6667585202d65566901a4f80a"; }];
    buildInputs = [ gtk2 enchant ];
  };

  "gtkspell3" = fetch {
    pname       = "gtkspell3";
    version     = "3.0.10";
    sources     = [{ filename = "mingw-w64-i686-gtkspell3-3.0.10-1-any.pkg.tar.xz"; sha256 = "729085b2984ff00cbc1d3079ec3856cf9bd731dc6c4c0d8a54a03eb7f93df68f"; }];
    buildInputs = [ gtk3 gtk2 enchant ];
  };

  "gtkwave" = fetch {
    pname       = "gtkwave";
    version     = "3.3.106";
    sources     = [{ filename = "mingw-w64-i686-gtkwave-3.3.106-1-any.pkg.tar.zst"; sha256 = "03c0e8281b56bcc403222fb13c5ced526211a6ca49a2df3ff2c2359e6b5e94c8"; }];
    buildInputs = [ gtk2 tk tklib-git tcl tcllib adwaita-icon-theme ];
  };

  "gts" = fetch {
    pname       = "gts";
    version     = "0.7.6";
    sources     = [{ filename = "mingw-w64-i686-gts-0.7.6-1-any.pkg.tar.xz"; sha256 = "f039fd0a555b6b0fc3dd2dd6d1213c0fd943a531cf1c3c562f1beb9840a0531d"; }];
    buildInputs = [ glib2 ];
  };

  "gumbo-parser" = fetch {
    pname       = "gumbo-parser";
    version     = "0.10.1";
    sources     = [{ filename = "mingw-w64-i686-gumbo-parser-0.10.1-1-any.pkg.tar.xz"; sha256 = "c79f466543b66009e9378ebb7c9362e32f78c0e0463c9cb1858ffb7220d51d95"; }];
  };

  "gxml" = fetch {
    pname       = "gxml";
    version     = "0.18.2";
    sources     = [{ filename = "mingw-w64-i686-gxml-0.18.2-1-any.pkg.tar.zst"; sha256 = "5d3da75dbb08a462b887ac3b8f249682719dac8f19ee9da218fe0a5aac47f610"; }];
    buildInputs = [ gcc-libs gettext (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.34.0"; glib2) libgee libxml2 xz zlib ];
  };
  harfbuzz = self."freetype+harfbuzz";

  "hclient-git" = fetch {
    pname       = "hclient-git";
    version     = "233.8b17cf3";
    sources     = [{ filename = "mingw-w64-i686-hclient-git-233.8b17cf3-1-any.pkg.tar.xz"; sha256 = "1d2f63b7fb505786ea97006a13fc251016582d9932c2f87930a9fc7f916715f9"; }];
  };

  "hdf4" = fetch {
    pname       = "hdf4";
    version     = "4.2.15";
    sources     = [{ filename = "mingw-w64-i686-hdf4-4.2.15-2-any.pkg.tar.zst"; sha256 = "c49a1da7d586642d1b14bb3ffc56fecdede8584602dcfe3d6120e2d288213662"; }];
    buildInputs = [ libjpeg-turbo gcc-libgfortran zlib ];
  };

  "hdf5" = fetch {
    pname       = "hdf5";
    version     = "1.12.0";
    sources     = [{ filename = "mingw-w64-i686-hdf5-1.12.0-2-any.pkg.tar.zst"; sha256 = "d9ade0d0fddfdeca3ea9de00b066e330e1573c547609a12b81c6a080b2c19f3e"; }];
    buildInputs = [ gcc-libs gcc-libgfortran szip zlib ];
  };

  "headers-git" = fetch {
    pname       = "headers-git";
    version     = "9.0.0.6029.ecb4ff54";
    sources     = [{ filename = "mingw-w64-i686-headers-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "50f087cbb1ef4f3b5ace47cf2b7bee46bd118346e7b5e7068be61a8edea1c402"; }];
    buildInputs = [  ];
  };

  "helics" = fetch {
    pname       = "helics";
    version     = "2.6.0";
    sources     = [{ filename = "mingw-w64-i686-helics-2.6.0-1-any.pkg.tar.zst"; sha256 = "a4139a6d6d0ef5cca6e838c7046f8fd863c209a581c52bf41638962dedd07a27"; }];
    buildInputs = [ zeromq ];
  };

  "hexyl" = fetch {
    pname       = "hexyl";
    version     = "0.3.1";
    sources     = [{ filename = "mingw-w64-i686-hexyl-0.3.1-1-any.pkg.tar.zst"; sha256 = "98f7c1fbb90592a4950827082ba060aee404a87df53c8b37525aa98a453cb06f"; }];
  };

  "hicolor-icon-theme" = fetch {
    pname       = "hicolor-icon-theme";
    version     = "0.17";
    sources     = [{ filename = "mingw-w64-i686-hicolor-icon-theme-0.17-1-any.pkg.tar.xz"; sha256 = "bcf0068c88eb771339f01238319657cbafb179805db382f588e2e6e7e8601ef3"; }];
    buildInputs = [  ];
  };

  "hidapi" = fetch {
    pname       = "hidapi";
    version     = "0.9.0";
    sources     = [{ filename = "mingw-w64-i686-hidapi-0.9.0-1-any.pkg.tar.xz"; sha256 = "b11bed370a61440d87c8b71b1be1cce9a42dcb98685d07d28bdfbcdb5206473f"; }];
    buildInputs = [ gcc-libs ];
  };

  "hlsl2glsl-git" = fetch {
    pname       = "hlsl2glsl-git";
    version     = "r848.957cd20";
    sources     = [{ filename = "mingw-w64-i686-hlsl2glsl-git-r848.957cd20-1-any.pkg.tar.xz"; sha256 = "2b254cb4f84e6271a35dd9b10570519910b7862197f02dc2b97a87d17c7518cc"; }];
  };

  "http-parser" = fetch {
    pname       = "http-parser";
    version     = "2.9.4";
    sources     = [{ filename = "mingw-w64-i686-http-parser-2.9.4-1-any.pkg.tar.xz"; sha256 = "32bf6b69664d1c1152da7d4dff3eb9435a5a99ef106acf29595cf92822c7c2a5"; }];
    buildInputs = [  ];
  };

  "hub" = fetch {
    pname       = "hub";
    version     = "2.14.2";
    sources     = [{ filename = "mingw-w64-i686-hub-2.14.2-1-any.pkg.tar.zst"; sha256 = "ff287a33a3667261a1c47284987403020ecfd1ca82bf9d89848894fb13261d4a"; }];
    buildInputs = [ git ];
    broken      = true; # broken dependency hub -> git
  };

  "hunspell" = fetch {
    pname       = "hunspell";
    version     = "1.7.0";
    sources     = [{ filename = "mingw-w64-i686-hunspell-1.7.0-5-any.pkg.tar.xz"; sha256 = "307e580f5184a596bc1c469a3d68f94e56fe9a4d09f6b5f11fd2a0fe53ff7b1f"; }];
    buildInputs = [ gcc-libs gettext ncurses readline ];
  };

  "hunspell-en" = fetch {
    pname       = "hunspell-en";
    version     = "2019.10.06";
    sources     = [{ filename = "mingw-w64-i686-hunspell-en-2019.10.06-1-any.pkg.tar.xz"; sha256 = "b497b64fbabe71a0da31e5ed46b8482728d7cc562d1ab7c381f317a63d81e6cc"; }];
  };

  "hwloc" = fetch {
    pname       = "hwloc";
    version     = "2.3.0";
    sources     = [{ filename = "mingw-w64-i686-hwloc-2.3.0-1-any.pkg.tar.zst"; sha256 = "697552439bb986548ef3d703e8635176b05c3f01c4bdf79d3bec32bc3920c00e"; }];
    buildInputs = [ libtool ];
  };

  "hyphen" = fetch {
    pname       = "hyphen";
    version     = "2.8.8";
    sources     = [{ filename = "mingw-w64-i686-hyphen-2.8.8-1-any.pkg.tar.xz"; sha256 = "2ecebe0cda7b9f9a79d22dbaae7d3d1c725498a71f456ac4a164f20950d04b38"; }];
  };

  "hyphen-en" = fetch {
    pname       = "hyphen-en";
    version     = "2.8.8";
    sources     = [{ filename = "mingw-w64-i686-hyphen-en-2.8.8-1-any.pkg.tar.xz"; sha256 = "8e772b67ed127f1d357df1855f4c1aaadc07d6bf88f4f3228f85f687eaa2e2bd"; }];
  };

  "icon-naming-utils" = fetch {
    pname       = "icon-naming-utils";
    version     = "0.8.90";
    sources     = [{ filename = "mingw-w64-i686-icon-naming-utils-0.8.90-2-any.pkg.tar.xz"; sha256 = "aa6f8457b12201bcc647cb1f676dac2aa8c6d4a75d23263d912afaf74d8c23ac"; }];
    buildInputs = [ perl-XML-Simple ];
    broken      = true; # broken dependency icon-naming-utils -> perl-XML-Simple
  };

  "iconv" = fetch {
    pname       = "iconv";
    version     = "1.16";
    sources     = [{ filename = "mingw-w64-i686-iconv-1.16-1-any.pkg.tar.xz"; sha256 = "49838e3107d74fcbc75b663dda68b131919ee69c4f26655185fcc28bdda8b1b5"; }];
    buildInputs = [ (assert libiconv.version=="1.16"; libiconv) gettext ];
  };

  "icoutils" = fetch {
    pname       = "icoutils";
    version     = "0.32.3";
    sources     = [{ filename = "mingw-w64-i686-icoutils-0.32.3-1-any.pkg.tar.xz"; sha256 = "4d931c4db117f1cf5c0ccc4352a96dc1508cbb966d477b7d5a0d5d28258e4c78"; }];
    buildInputs = [ libpng ];
  };

  "icu" = fetch {
    pname       = "icu";
    version     = "67.1";
    sources     = [{ filename = "mingw-w64-i686-icu-67.1-1-any.pkg.tar.zst"; sha256 = "f51c919f60624aa3fad97e142c778e475dbbcae760140eb0a115be0096a7349a"; }];
    buildInputs = [ gcc-libs ];
  };

  "icu-debug-libs" = fetch {
    pname       = "icu-debug-libs";
    version     = "67.1";
    sources     = [{ filename = "mingw-w64-i686-icu-debug-libs-67.1-1-any.pkg.tar.zst"; sha256 = "729cbc741eb3d196e0fbe4f7705e43e7e3a903bddcd205f038b13611fb593a9c"; }];
    buildInputs = [ gcc-libs ];
  };

  "id3lib" = fetch {
    pname       = "id3lib";
    version     = "3.8.3";
    sources     = [{ filename = "mingw-w64-i686-id3lib-3.8.3-2-any.pkg.tar.xz"; sha256 = "223729f02fe92fc9e0a9f374365ad7c3290615d828a94764ab72865fc85832c1"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "igraph" = fetch {
    pname       = "igraph";
    version     = "0.8.3";
    sources     = [{ filename = "mingw-w64-i686-igraph-0.8.3-1-any.pkg.tar.zst"; sha256 = "de51b7a97ff6176b714e54ba46760ed1369d168f09326fac6e5727150992b289"; }];
    buildInputs = [ glpk gmp zlib libxml2 ];
  };

  "ilmbase" = fetch {
    pname       = "ilmbase";
    version     = "2.5.3";
    sources     = [{ filename = "mingw-w64-i686-ilmbase-2.5.3-1-any.pkg.tar.zst"; sha256 = "caf5ac36014e1cdaeedd1817e66758782fe2377223655937866dbff865dfb240"; }];
    buildInputs = [ gcc-libs ];
  };

  "imagemagick" = fetch {
    pname       = "imagemagick";
    version     = "7.0.10.11";
    sources     = [{ filename = "mingw-w64-i686-imagemagick-7.0.10.11-3-any.pkg.tar.zst"; sha256 = "7bb046f8c4b6305dbb3397f5f3b7160d8035b7e11c8a6b1f099be58ca5d02935"; }];
    buildInputs = [ bzip2 djvulibre flif fftw fontconfig freetype glib2 gsfonts jasper jbigkit lcms2 libheif liblqr libpng libraqm libraw libtiff libtool libwebp libwmf libxml2 openjpeg2 ttf-dejavu xz zlib zstd ];
  };

  "indent" = fetch {
    pname       = "indent";
    version     = "2.2.12";
    sources     = [{ filename = "mingw-w64-i686-indent-2.2.12-2-any.pkg.tar.zst"; sha256 = "1136a500b648ac85a2911971f8d8598df5c7181fc3e78207b040bcf18398ac28"; }];
    buildInputs = [ gettext ];
  };

  "inkscape" = fetch {
    pname       = "inkscape";
    version     = "0.92.5";
    sources     = [{ filename = "mingw-w64-i686-inkscape-0.92.5-3-any.pkg.tar.zst"; sha256 = "ee22304a8c7004f4a9336032831ca6bb9e30581b0f911b1254a7e1519c6048c1"; }];
    buildInputs = [ aspell gc ghostscript gsl gtkmm gtkspell hicolor-icon-theme imagemagick lcms2 libcdr libvisio libxml2 libxslt libwpg poppler popt potrace python ];
  };

  "innoextract" = fetch {
    pname       = "innoextract";
    version     = "1.9";
    sources     = [{ filename = "mingw-w64-i686-innoextract-1.9-1-any.pkg.tar.zst"; sha256 = "f161327b5151f58204a01f966ee4f36fce52cb00032bc977a28d842bf6f673f0"; }];
    buildInputs = [ gcc-libs boost bzip2 libiconv xz zlib ];
  };

  "intel-tbb" = fetch {
    pname       = "intel-tbb";
    version     = "1~2020.2";
    sources     = [{ filename = "mingw-w64-i686-intel-tbb-1~2020.2-2-any.pkg.tar.zst"; sha256 = "ce2d5fae4b82d0e9c2cc33d8c2e03895bdf88f66daf0c24fb766f3931fa149ca"; }];
    buildInputs = [ gcc-libs ];
  };

  "irrlicht" = fetch {
    pname       = "irrlicht";
    version     = "1.8.4";
    sources     = [{ filename = "mingw-w64-i686-irrlicht-1.8.4-1-any.pkg.tar.xz"; sha256 = "adfd44870e46aa18226e4f2b72c4f3cd5bffe4c43f4bde433db93b99fc62e856"; }];
    buildInputs = [ gcc-libs ];
  };

  "isl" = fetch {
    pname       = "isl";
    version     = "0.22.1";
    sources     = [{ filename = "mingw-w64-i686-isl-0.22.1-2-any.pkg.tar.zst"; sha256 = "474b99624eee340570fd3c9244a198ed9576a77dde006724eac450db0494bf5c"; }];
    buildInputs = [  ];
  };

  "iso-codes" = fetch {
    pname       = "iso-codes";
    version     = "4.5.0";
    sources     = [{ filename = "mingw-w64-i686-iso-codes-4.5.0-1-any.pkg.tar.zst"; sha256 = "237d9d936331368a5030662ca964cabff65f233566499f9feaf42dd8992be507"; }];
    buildInputs = [  ];
  };

  "itk" = fetch {
    pname       = "itk";
    version     = "5.1.0";
    sources     = [{ filename = "mingw-w64-i686-itk-5.1.0-2-any.pkg.tar.zst"; sha256 = "99a14207f3681b5ac22318805da399e0bf156d0958b8eac0063ffec70069406e"; }];
    buildInputs = [ gcc-libs expat fftw gdcm hdf5 libjpeg libpng libtiff zlib ];
  };

  "itstool" = fetch {
    pname       = "itstool";
    version     = "2.0.6";
    sources     = [{ filename = "mingw-w64-i686-itstool-2.0.6-3-any.pkg.tar.xz"; sha256 = "7432784d6058338ed9387cf85ee2e0a68fe0cd0e14a9dbafe718cecd13e80cbc"; }];
    buildInputs = [ python3 libxml2 ];
  };

  "jansson" = fetch {
    pname       = "jansson";
    version     = "2.13.1";
    sources     = [{ filename = "mingw-w64-i686-jansson-2.13.1-1-any.pkg.tar.zst"; sha256 = "dcf6cd5843b75c77ff8419a7b73beacb40b78469d63475dba188e2c3e1a6b1ab"; }];
    buildInputs = [  ];
  };

  "jasper" = fetch {
    pname       = "jasper";
    version     = "2.0.22";
    sources     = [{ filename = "mingw-w64-i686-jasper-2.0.22-1-any.pkg.tar.zst"; sha256 = "2e51ea027b26a79781e0356b3482dec8df856353ab341a36ade7908eee31454c"; }];
    buildInputs = [ freeglut libjpeg-turbo ];
  };

  "jbig2dec" = fetch {
    pname       = "jbig2dec";
    version     = "0.17";
    sources     = [{ filename = "mingw-w64-i686-jbig2dec-0.17-1-any.pkg.tar.xz"; sha256 = "b50499f229786d2af326b7a32b15f5ae570c38c51b4e689e5f639ba2d4358e36"; }];
    buildInputs = [ libpng ];
  };

  "jbigkit" = fetch {
    pname       = "jbigkit";
    version     = "2.1";
    sources     = [{ filename = "mingw-w64-i686-jbigkit-2.1-4-any.pkg.tar.xz"; sha256 = "a68955c6c7fa8907a0605bb6b7a90ae598b6131afd0243a4fdb953bcb7a53f61"; }];
    buildInputs = [ gcc-libs ];
  };

  "jemalloc" = fetch {
    pname       = "jemalloc";
    version     = "5.2.1";
    sources     = [{ filename = "mingw-w64-i686-jemalloc-5.2.1-1-any.pkg.tar.xz"; sha256 = "58bcb905343fb6b831cdf2d39a2249e488cd219fe7cc41196d3062a4eb5ee03f"; }];
    buildInputs = [ gcc-libs ];
  };

  "jpegoptim" = fetch {
    pname       = "jpegoptim";
    version     = "1.4.6";
    sources     = [{ filename = "mingw-w64-i686-jpegoptim-1.4.6-1-any.pkg.tar.xz"; sha256 = "3b56b3432769077eb4cd38bbfa41368bead3a2c1e2393b0adbf4fec061e6e516"; }];
    buildInputs = [ libjpeg-turbo ];
  };

  "jq" = fetch {
    pname       = "jq";
    version     = "1.6";
    sources     = [{ filename = "mingw-w64-i686-jq-1.6-3-any.pkg.tar.zst"; sha256 = "a76c5c17ad201b8085c216937496786014f61058ed58c5470ee17bf3f2d5b424"; }];
    buildInputs = [ oniguruma libwinpthread-git ];
  };

  "json-c" = fetch {
    pname       = "json-c";
    version     = "0.15";
    sources     = [{ filename = "mingw-w64-i686-json-c-0.15-1-any.pkg.tar.zst"; sha256 = "44a8ba2203e1dcf67c78f3256ba264266949f2a2c967f8dda8a436764ea0d09b"; }];
    buildInputs = [ gcc-libs ];
  };

  "json-glib" = fetch {
    pname       = "json-glib";
    version     = "1.6.0";
    sources     = [{ filename = "mingw-w64-i686-json-glib-1.6.0-1-any.pkg.tar.zst"; sha256 = "c0f1a154ee96f2eed07f0038b05e07cc1c918bf2b4c93fdb2d254a6f79e64623"; }];
    buildInputs = [ glib2 ];
  };

  "jsoncpp" = fetch {
    pname       = "jsoncpp";
    version     = "1.9.4";
    sources     = [{ filename = "mingw-w64-i686-jsoncpp-1.9.4-1-any.pkg.tar.zst"; sha256 = "9406fea90c149b8bdc4dc0fa0dcde8dc15af78b71c5319e481ae853a35404714"; }];
    buildInputs = [  ];
  };

  "jsonrpc-glib" = fetch {
    pname       = "jsonrpc-glib";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-jsonrpc-glib-3.38.0-1-any.pkg.tar.zst"; sha256 = "ff55f701f2ae224db6ec6207eecd37a8406cd9ea470c75e8c12dfd5a54edad7b"; }];
    buildInputs = [ glib2 json-glib ];
  };

  "jxrlib" = fetch {
    pname       = "jxrlib";
    version     = "1.1";
    sources     = [{ filename = "mingw-w64-i686-jxrlib-1.1-3-any.pkg.tar.xz"; sha256 = "a7f3f113f62e01f2d7e0cb51b226070448d40c7cb8731e24ff773b3c6da03802"; }];
    buildInputs = [ gcc-libs ];
  };

  "kactivities-qt5" = fetch {
    pname       = "kactivities-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kactivities-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "9767bf241e71ab0ef7fa401c94f175e2f85bb163aa1fc356722a22f0bf1af240"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.75.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.75.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.75.0"; kwindowsystem-qt5) ];
  };

  "karchive-qt5" = fetch {
    pname       = "karchive-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-karchive-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "aa8e2982d0f7160ac76a7da502e274ed701d70bc65aab67ebc789401e93eb49b"; }];
    buildInputs = [ zlib bzip2 xz qt5 ];
  };

  "kate" = fetch {
    pname       = "kate";
    version     = "20.08.2";
    sources     = [{ filename = "mingw-w64-i686-kate-20.08.2-1-any.pkg.tar.zst"; sha256 = "333c2ca11716020fcbee3a640fd48df69d0398f0088c0e78cc42eb195df7d96e"; }];
    buildInputs = [ knewstuff-qt5 ktexteditor-qt5 threadweaver-qt5 kitemmodels-qt5 kactivities-qt5 plasma-framework-qt5 hicolor-icon-theme ];
  };

  "kauth-qt5" = fetch {
    pname       = "kauth-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kauth-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "aa7a6a3849e67d0e023dba4ee030fa2216905010bdb7f671a80ce7ca4a298f81"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.75.0"; kcoreaddons-qt5) ];
  };

  "kbookmarks-qt5" = fetch {
    pname       = "kbookmarks-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kbookmarks-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "410cbb3cee0b546c1660620b10b024831a28d60ac16924451e4ebbcd22bc382d"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kxmlgui-qt5.version "5.75.0"; kxmlgui-qt5) ];
  };

  "kcmutils-qt5" = fetch {
    pname       = "kcmutils-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kcmutils-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "1ba07acc77256f042e087718f15464e642ab235408dad6c22ebaf436ff9f25dc"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast kconfigwidgets-qt5.version "5.75.0"; kconfigwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast kdeclarative-qt5.version "5.75.0"; kdeclarative-qt5) qt5 ];
  };

  "kcodecs-qt5" = fetch {
    pname       = "kcodecs-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kcodecs-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "50c0c86d7622adf80720dc1763e9c89db885926f8c4a20744d00185f6183ed28"; }];
    buildInputs = [ qt5 ];
  };

  "kcompletion-qt5" = fetch {
    pname       = "kcompletion-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kcompletion-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "609c9044d99046c2d6d403842abbc03c44486d56ddfd6279c8cec95ec4164650"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.75.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.75.0"; kwidgetsaddons-qt5) ];
  };

  "kconfig-qt5" = fetch {
    pname       = "kconfig-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kconfig-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "f5b71186714c7041a7799f65f7240f765340a58e8a708592c11869ef0b65137e"; }];
    buildInputs = [ qt5 ];
  };

  "kconfigwidgets-qt5" = fetch {
    pname       = "kconfigwidgets-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kconfigwidgets-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "cbebc2cb9cf21b25d8b3fd407f98f036cd4b9c6faaeb4f48298912c1e7deb3db"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kauth-qt5.version "5.75.0"; kauth-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.75.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kcodecs-qt5.version "5.75.0"; kcodecs-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.75.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kguiaddons-qt5.version "5.75.0"; kguiaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.75.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.75.0"; kwidgetsaddons-qt5) ];
  };

  "kcoreaddons-qt5" = fetch {
    pname       = "kcoreaddons-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kcoreaddons-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "1a8b38bbd73b89ccff6cf983d208f4c76b29f0cbdc49ec13548249ae935094ec"; }];
    buildInputs = [ qt5 ];
  };

  "kcrash-qt5" = fetch {
    pname       = "kcrash-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kcrash-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "f73ffaea66d894fc30521e3e5cf534660de1a8b34c2f067bba6a76d9b51667de"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.75.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.75.0"; kwindowsystem-qt5) ];
  };

  "kdbusaddons-qt5" = fetch {
    pname       = "kdbusaddons-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kdbusaddons-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "a254c870e3e6babc062109284cadd69f8554ae78b5ad161ee512bebf03507692"; }];
    buildInputs = [ qt5 ];
  };

  "kdeclarative-qt5" = fetch {
    pname       = "kdeclarative-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kdeclarative-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "0e9aefb3972f1369017fd986226ea52478fe261be5eb43b18adbb786a90bfdf0"; }];
    buildInputs = [ qt5 kio-qt5 kpackage-qt5 libepoxy ];
  };

  "kdewebkit-qt5" = fetch {
    pname       = "kdewebkit-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kdewebkit-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "e7db484cf8813edf6160b670d745ec6fd19f307cf46875db9d29874e01b07666"; }];
    buildInputs = [ kio-qt5 kparts-qt5 qtwebkit ];
  };

  "kdnssd-qt5" = fetch {
    pname       = "kdnssd-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kdnssd-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "ef11d6fe49a77cdeac1c9342779af0b8096503c3c8aceec159334b79c7887a93"; }];
    buildInputs = [ qt5 ];
  };

  "kdoctools-qt5" = fetch {
    pname       = "kdoctools-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kdoctools-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "10e173488a5f4eeb477bd613a0047dda2bd6f46cc59ce9d13d1d6ed3327b834e"; }];
    buildInputs = [ qt5 libxslt docbook-xsl (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.75.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.75.0"; karchive-qt5) ];
  };

  "kfilemetadata-qt5" = fetch {
    pname       = "kfilemetadata-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kfilemetadata-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "3eaf4df1dcd3d201fb0e9deec6e32dcec7f6903ad3884993443d1c7581e9932c"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.75.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.75.0"; karchive-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.75.0"; kcoreaddons-qt5) exiv2 poppler taglib ffmpeg ];
  };

  "kglobalaccel-qt5" = fetch {
    pname       = "kglobalaccel-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kglobalaccel-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "f7d340a290ac58cb4884c6a25c330d4273850713910a0663e0a87eab58e3235b"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.75.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.75.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kcrash-qt5.version "5.75.0"; kcrash-qt5) (assert stdenvNoCC.lib.versionAtLeast kdbusaddons-qt5.version "5.75.0"; kdbusaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.75.0"; kwindowsystem-qt5) ];
  };

  "kguiaddons-qt5" = fetch {
    pname       = "kguiaddons-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kguiaddons-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "3cde7c63b6ef49d0d844ce5f8aee2e4ad4351418222f02172d2a10eea956eb49"; }];
    buildInputs = [ qt5 ];
  };

  "kholidays-qt5" = fetch {
    pname       = "kholidays-qt5";
    version     = "1~5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kholidays-qt5-1~5.75.0-1-any.pkg.tar.zst"; sha256 = "00fd1453311e4a7b1b5dae2e6525c3064a0df02486625f02c63f0f2264ddf0a9"; }];
    buildInputs = [ qt5 ];
  };

  "ki18n-qt5" = fetch {
    pname       = "ki18n-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-ki18n-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "08cac840db29e176fb3bbd4c615181c99bc4d83da6f41aae16771821909458e8"; }];
    buildInputs = [ gettext qt5 ];
  };

  "kicad" = fetch {
    pname       = "kicad";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-5.1.5-1-any.pkg.tar.xz"; sha256 = "56d7c41b77da5bb0dc3ec4a688222e986ddfb80734238b384d3428b382a9edd6"; }];
    buildInputs = [ boost curl glew glm ngspice python2 wxPython wxWidgets openssl freeglut zlib ];
  };

  "kicad-doc-ca" = fetch {
    pname       = "kicad-doc-ca";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-ca-5.1.5-1-any.pkg.tar.xz"; sha256 = "ad362bc07d68b398fefa65baa0d5ba5c089746b91fd646333335d2be1556f684"; }];
  };

  "kicad-doc-de" = fetch {
    pname       = "kicad-doc-de";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-de-5.1.5-1-any.pkg.tar.xz"; sha256 = "8a75e249b69cb9d14116e79d51efcc320b0d86f8867077ca906576acb8cda5fd"; }];
  };

  "kicad-doc-en" = fetch {
    pname       = "kicad-doc-en";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-en-5.1.5-1-any.pkg.tar.xz"; sha256 = "379de20887045d35694169e48a48fe009f3a345dba53edbc93b0cc9e1dc999aa"; }];
  };

  "kicad-doc-es" = fetch {
    pname       = "kicad-doc-es";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-es-5.1.5-1-any.pkg.tar.xz"; sha256 = "6cb4440a2b52e202b4d1055886a6151af51842fc04e7587e526811be1b6f4e01"; }];
  };

  "kicad-doc-fr" = fetch {
    pname       = "kicad-doc-fr";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-fr-5.1.5-1-any.pkg.tar.xz"; sha256 = "256177eccd8c118926552dbb709ed10b09d936f4e3809f666980ee3de2529dff"; }];
  };

  "kicad-doc-id" = fetch {
    pname       = "kicad-doc-id";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-id-5.1.5-1-any.pkg.tar.xz"; sha256 = "0cb322b0af7027f5a6f60d735757acd0a41be9c9d01993e9439c31becaee8396"; }];
  };

  "kicad-doc-it" = fetch {
    pname       = "kicad-doc-it";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-it-5.1.5-1-any.pkg.tar.xz"; sha256 = "4ad776fe96667f1351e2c81c93aa4391ded8490cfe3d19e893389634f72f6a80"; }];
  };

  "kicad-doc-ja" = fetch {
    pname       = "kicad-doc-ja";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-ja-5.1.5-1-any.pkg.tar.xz"; sha256 = "c0dcfbd74c9d604d756a0c8a6ae241c4fe83271b0050e62d3fd260a7257c5626"; }];
  };

  "kicad-doc-pl" = fetch {
    pname       = "kicad-doc-pl";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-pl-5.1.5-1-any.pkg.tar.xz"; sha256 = "c636054832d3483f6df22253cbb8104df8fed8bae3335920b3f111b122090e3d"; }];
  };

  "kicad-doc-ru" = fetch {
    pname       = "kicad-doc-ru";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-ru-5.1.5-1-any.pkg.tar.xz"; sha256 = "18979260a81573fdb791d23d7d76e60ab7967a287845fa21e5f660ab4d10ba72"; }];
  };

  "kicad-doc-zh" = fetch {
    pname       = "kicad-doc-zh";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-doc-zh-5.1.5-1-any.pkg.tar.xz"; sha256 = "817569ef7900e5e70d873e349baffe897e0e0278f90c5d9c52781cae7f015419"; }];
  };

  "kicad-footprints" = fetch {
    pname       = "kicad-footprints";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-footprints-5.1.5-1-any.pkg.tar.xz"; sha256 = "9a9e67d8ee5d63414fae7765bd0e5d2d4cba7328f352625157d09e1d8c297477"; }];
    buildInputs = [ boost curl glew glm ngspice python2 wxPython wxWidgets openssl freeglut zlib ];
  };

  "kicad-meta" = fetch {
    pname       = "kicad-meta";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-meta-5.1.5-1-any.pkg.tar.xz"; sha256 = "9dd9a805b8716bd196da573eecdacdca262c52adf0e942baaedbbd4a66bf3056"; }];
    buildInputs = [ kicad kicad-footprints kicad-symbols kicad-templates kicad-packages3D ];
  };

  "kicad-packages3D" = fetch {
    pname       = "kicad-packages3D";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-packages3D-5.1.5-1-any.pkg.tar.xz"; sha256 = "896c5c46b5a241cba1310b34c9a0208337113e65e38e999883ce3fcefe9afd21"; }];
    buildInputs = [ boost curl glew glm ngspice python2 wxPython wxWidgets openssl freeglut zlib ];
  };

  "kicad-symbols" = fetch {
    pname       = "kicad-symbols";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-symbols-5.1.5-1-any.pkg.tar.xz"; sha256 = "2736332f3849b8d21628180adcc4c5978569e850a3f85fc949e67764873189ae"; }];
    buildInputs = [ boost curl glew glm ngspice python2 wxPython wxWidgets openssl freeglut zlib ];
  };

  "kicad-templates" = fetch {
    pname       = "kicad-templates";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-kicad-templates-5.1.5-1-any.pkg.tar.xz"; sha256 = "c8f10bbb0089ce47396bd7c0cbc9e52039a37535f7d90b0fd83618d9ebcdb0f8"; }];
    buildInputs = [ boost curl glew glm ngspice python2 wxPython wxWidgets openssl freeglut zlib ];
  };

  "kiconthemes-qt5" = fetch {
    pname       = "kiconthemes-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kiconthemes-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "6e9ba45904f5bece885a70147d8b61cf20b314d9ad01dfbcf399034574eb9a5c"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfigwidgets-qt5.version "5.75.0"; kconfigwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast kitemviews-qt5.version "5.75.0"; kitemviews-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.75.0"; karchive-qt5) ];
  };

  "kidletime-qt5" = fetch {
    pname       = "kidletime-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kidletime-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "94c40436f8cfe5cc8d847b9541bb1351b4a3df12ba7e7a34a150ccde365f091c"; }];
    buildInputs = [ qt5 ];
  };

  "kimageformats-qt5" = fetch {
    pname       = "kimageformats-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kimageformats-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "28eedd1ffe9d3c75e87cfdaefa42fbc9920e9b35277fe1b1c1adab1aeb70cf04"; }];
    buildInputs = [ qt5 openexr (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.75.0"; karchive-qt5) ];
  };

  "kinit-qt5" = fetch {
    pname       = "kinit-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kinit-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "5d501418b138f2f62a3b4e7148c91ba676852e1c952e21681ced5d1f3062b605"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.75.0"; kio-qt5) ];
  };

  "kio-qt5" = fetch {
    pname       = "kio-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kio-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "1b8ad0a8a5c3c07abb52257d0486104f514f375a731a248c40cfd9e6864805bb"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast solid-qt5.version "5.75.0"; solid-qt5) (assert stdenvNoCC.lib.versionAtLeast kjobwidgets-qt5.version "5.75.0"; kjobwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast kbookmarks-qt5.version "5.75.0"; kbookmarks-qt5) (assert stdenvNoCC.lib.versionAtLeast kwallet-qt5.version "5.75.0"; kwallet-qt5) libxslt ];
  };

  "kirigami2-qt5" = fetch {
    pname       = "kirigami2-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kirigami2-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "b68c8d858eb7554838c87ab26435fc08f5074f0ff4b93bfa4d2f0a8d151c9f56"; }];
    buildInputs = [ qt5 ];
  };

  "kiss_fft" = fetch {
    pname       = "kiss_fft";
    version     = "1.3.1";
    sources     = [{ filename = "mingw-w64-i686-kiss_fft-1.3.1-1-any.pkg.tar.xz"; sha256 = "1d4ea060abd568e20d9b80da8fb1f02077be8257f696b0345eee6849e30a514b"; }];
  };

  "kitemmodels-qt5" = fetch {
    pname       = "kitemmodels-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kitemmodels-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "c4ddd6e9fa51606688c51eaa5b81ade5403970b38bad6d9028a3e0bbfaa4861b"; }];
    buildInputs = [ qt5 ];
  };

  "kitemviews-qt5" = fetch {
    pname       = "kitemviews-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kitemviews-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "e8b0eaba5fba783b4cd619b538b07c1b033403303426c04b6325f3b695c93e96"; }];
    buildInputs = [ qt5 ];
  };

  "kjobwidgets-qt5" = fetch {
    pname       = "kjobwidgets-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kjobwidgets-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "ef66029cba4cf9defd3eb64844bf97f3be3b535294d4b57e0d830f531695f21b"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.75.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.75.0"; kwidgetsaddons-qt5) ];
  };

  "kjs-qt5" = fetch {
    pname       = "kjs-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kjs-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "bf5dbad1aec72523b3a47cdfd11b178e875eb0357a1880851dbb2bd1dda26a50"; }];
    buildInputs = [ qt5 bzip2 pcre (assert stdenvNoCC.lib.versionAtLeast kdoctools-qt5.version "5.75.0"; kdoctools-qt5) ];
  };

  "knewstuff-qt5" = fetch {
    pname       = "knewstuff-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-knewstuff-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "1754f52c76ce80b04b8f6574a6f6cca06b9fc88368f9c5ad487ccdbc43162b8f"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.75.0"; kio-qt5) ];
  };

  "knotifications-qt5" = fetch {
    pname       = "knotifications-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-knotifications-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "9a70fadb8b920ca37bfcf9a1c6a82428768cd703b2abf4b0fd6553d6f6c0653f"; }];
    buildInputs = [ qt5 phonon-qt5 (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.75.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.75.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.75.0"; kwindowsystem-qt5) ];
  };

  "kpackage-qt5" = fetch {
    pname       = "kpackage-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kpackage-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "24e76015cb5b41dd08fd7c467336a73d0c5981a038bde9359c87f07f483c78a9"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.75.0"; karchive-qt5) (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.75.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.75.0"; kcoreaddons-qt5) ];
  };

  "kparts-qt5" = fetch {
    pname       = "kparts-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kparts-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "6e439a8f6698ccb77dbe6be0598daf4e68b410f76ab93936448e1f83c721f706"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.75.0"; kio-qt5) ];
  };

  "kplotting-qt5" = fetch {
    pname       = "kplotting-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kplotting-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "ee83f3a88c4502b6a3667ffbe42920ca25cd7172fc8e579a9efe81dcc5a97d8c"; }];
    buildInputs = [ qt5 ];
  };

  "kservice-qt5" = fetch {
    pname       = "kservice-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kservice-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "83031c2c507e119d460345b6906c76da285396c3420ebd5b9e103f66c6ddc395"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.75.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.75.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcrash-qt5.version "5.75.0"; kcrash-qt5) (assert stdenvNoCC.lib.versionAtLeast kdbusaddons-qt5.version "5.75.0"; kdbusaddons-qt5) ];
  };

  "ktexteditor-qt5" = fetch {
    pname       = "ktexteditor-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-ktexteditor-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "23b9f9a82775641751713b989ca27fe2b4e334842687efee7632e5ca96a04151"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kparts-qt5.version "5.75.0"; kparts-qt5) (assert stdenvNoCC.lib.versionAtLeast syntax-highlighting-qt5.version "5.75.0"; syntax-highlighting-qt5) libgit2 editorconfig-core-c ];
  };

  "ktextwidgets-qt5" = fetch {
    pname       = "ktextwidgets-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-ktextwidgets-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "89a7026ac9d89e381f2a312bc988022ab7ed9d2d3f924a2b29baafe040b8df71"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcompletion-qt5.version "5.75.0"; kcompletion-qt5) (assert stdenvNoCC.lib.versionAtLeast kservice-qt5.version "5.75.0"; kservice-qt5) (assert stdenvNoCC.lib.versionAtLeast kiconthemes-qt5.version "5.75.0"; kiconthemes-qt5) (assert stdenvNoCC.lib.versionAtLeast sonnet-qt5.version "5.75.0"; sonnet-qt5) ];
  };

  "kunitconversion-qt5" = fetch {
    pname       = "kunitconversion-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kunitconversion-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "9462ccae54faeea537585b704a21896de2899400ad2d79af61b4999b931095f5"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.75.0"; ki18n-qt5) ];
  };

  "kvazaar" = fetch {
    pname       = "kvazaar";
    version     = "2.0.0";
    sources     = [{ filename = "mingw-w64-i686-kvazaar-2.0.0-1-any.pkg.tar.xz"; sha256 = "4b3539a687e0d5aa826035bd3944a9bd1db89298253fed52a2246f6d8cc9e63f"; }];
    buildInputs = [ gcc-libs self."crypto++" ];
  };

  "kwallet-qt5" = fetch {
    pname       = "kwallet-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kwallet-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "666fbe98e039302e7f41c8b0fe0b71c76e405283caa286ff74093b383e0b697d"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast knotifications-qt5.version "5.75.0"; knotifications-qt5) (assert stdenvNoCC.lib.versionAtLeast kiconthemes-qt5.version "5.75.0"; kiconthemes-qt5) (assert stdenvNoCC.lib.versionAtLeast kservice-qt5.version "5.75.0"; kservice-qt5) gpgme ];
  };

  "kwidgetsaddons-qt5" = fetch {
    pname       = "kwidgetsaddons-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kwidgetsaddons-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "7dacef9f380f6d71a84343db1ab7e5d0d545577e173dbe6b22069a2b428ce388"; }];
    buildInputs = [ qt5 ];
  };

  "kwindowsystem-qt5" = fetch {
    pname       = "kwindowsystem-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kwindowsystem-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "6f26079899611ec2ce871d6ddacd78ccf335bfa344efcd1812e653a8cad07ce9"; }];
    buildInputs = [ qt5 ];
  };

  "kxmlgui-qt5" = fetch {
    pname       = "kxmlgui-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-kxmlgui-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "0fb958a76e7270e02a5f87ea9b1fe0f1c2353c82f75dc0de05f32aae8023f2ab"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kglobalaccel-qt5.version "5.75.0"; kglobalaccel-qt5) (assert stdenvNoCC.lib.versionAtLeast ktextwidgets-qt5.version "5.75.0"; ktextwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast attica-qt5.version "5.75.0"; attica-qt5) ];
  };

  "l-smash" = fetch {
    pname       = "l-smash";
    version     = "2.14.5";
    sources     = [{ filename = "mingw-w64-i686-l-smash-2.14.5-1-any.pkg.tar.xz"; sha256 = "bd339007ad2ac6d9bfd58c88de34e6e7e91bd97c9680b144fee3bf7a930f39ca"; }];
    buildInputs = [  ];
  };

  "ladspa-sdk" = fetch {
    pname       = "ladspa-sdk";
    version     = "1.15";
    sources     = [{ filename = "mingw-w64-i686-ladspa-sdk-1.15-1-any.pkg.tar.xz"; sha256 = "a28eb6b3a06821a9e20961b1173f2f620ac258758135c02533c45effc99503c5"; }];
  };

  "lame" = fetch {
    pname       = "lame";
    version     = "3.100";
    sources     = [{ filename = "mingw-w64-i686-lame-3.100-1-any.pkg.tar.xz"; sha256 = "c1045d291d3ab739c487600323b3e2d1de2d32f778a3e5ae65f489bfc39cbfd9"; }];
    buildInputs = [ libiconv ];
  };

  "lapack" = fetch {
    pname       = "lapack";
    version     = "3.9.0";
    sources     = [{ filename = "mingw-w64-i686-lapack-3.9.0-2-any.pkg.tar.zst"; sha256 = "1e60f43ab969c056fde4b5718fbfd14226a041461ea19318ead9268fbf7ebec4"; }];
    buildInputs = [ gcc-libs gcc-libgfortran ];
  };

  "lasem" = fetch {
    pname       = "lasem";
    version     = "0.4.4";
    sources     = [{ filename = "mingw-w64-i686-lasem-0.4.4-1-any.pkg.tar.xz"; sha256 = "03df05f135483cac851a4b9284d83d739f71ab01de1881dcf1c8c59dcc5df4c6"; }];
  };

  "laszip" = fetch {
    pname       = "laszip";
    version     = "3.4.3";
    sources     = [{ filename = "mingw-w64-i686-laszip-3.4.3-1-any.pkg.tar.xz"; sha256 = "6d9a4e0562bd008932ed802b7ecf93f79035175c7402efe905af854269538d00"; }];
  };

  "lcms" = fetch {
    pname       = "lcms";
    version     = "1.19";
    sources     = [{ filename = "mingw-w64-i686-lcms-1.19-6-any.pkg.tar.xz"; sha256 = "84a9d8ed48a4b6b3b1f0b4844bf23e6cfff91f82f7258b0ccb24a87f3a31bf57"; }];
    buildInputs = [ libtiff ];
  };

  "lcms2" = fetch {
    pname       = "lcms2";
    version     = "2.11";
    sources     = [{ filename = "mingw-w64-i686-lcms2-2.11-1-any.pkg.tar.zst"; sha256 = "7ad8be986e03723762b35a6b56f9823af73b66782f37f2e0a5171bf43c231f28"; }];
    buildInputs = [ gcc-libs libtiff ];
  };

  "ldns" = fetch {
    pname       = "ldns";
    version     = "1.7.0";
    sources     = [{ filename = "mingw-w64-i686-ldns-1.7.0-3-any.pkg.tar.xz"; sha256 = "29c7286a3dfed97d5532b2c290a95c53e0bd654bb25b89edb5139cb11e0b899e"; }];
    buildInputs = [ openssl ];
  };

  "lensfun" = fetch {
    pname       = "lensfun";
    version     = "0.3.2";
    sources     = [{ filename = "mingw-w64-i686-lensfun-0.3.2-7-any.pkg.tar.zst"; sha256 = "847aa86a9110f26ce20779145933b81161320a9096b2465a751b28449601b60f"; }];
    buildInputs = [ glib2 libpng zlib ];
  };

  "leptonica" = fetch {
    pname       = "leptonica";
    version     = "1.80.0";
    sources     = [{ filename = "mingw-w64-i686-leptonica-1.80.0-1-any.pkg.tar.zst"; sha256 = "570f7655353c350cab51bf27318e615c385a71c8feaa0abc197cde95cbc7ab9a"; }];
    buildInputs = [ gcc-libs giflib libtiff libpng libwebp openjpeg2 zlib ];
  };

  "leveldb" = fetch {
    pname       = "leveldb";
    version     = "1.22";
    sources     = [{ filename = "mingw-w64-i686-leveldb-1.22-1-any.pkg.tar.xz"; sha256 = "1a82d58bb8045adff13ee2dc0a399e338eaf095f1bc70422b9f8e2271ca738b0"; }];
  };

  "lfcbase" = fetch {
    pname       = "lfcbase";
    version     = "1.14.4";
    sources     = [{ filename = "mingw-w64-i686-lfcbase-1.14.4-1-any.pkg.tar.zst"; sha256 = "02c5f6b7ba4dc7e34bbee3fd5f756b701fd97bbbb573db36513c25319c24ad6d"; }];
    buildInputs = [ gcc-libs ncurses ];
  };

  "lfcxml" = fetch {
    pname       = "lfcxml";
    version     = "1.2.11";
    sources     = [{ filename = "mingw-w64-i686-lfcxml-1.2.11-1-any.pkg.tar.zst"; sha256 = "70d2b82fdd77d036652010aba6d572bb6509ba9413f65811f73f4670dda6a6aa"; }];
    buildInputs = [ lfcbase ];
  };

  "lib3mf" = fetch {
    pname       = "lib3mf";
    version     = "2.0.0";
    sources     = [{ filename = "mingw-w64-i686-lib3mf-2.0.0-1-any.pkg.tar.xz"; sha256 = "94913aacd6929f2531763b089f681f511070845dcb766772166b3af8725afb14"; }];
  };

  "libaacs" = fetch {
    pname       = "libaacs";
    version     = "0.11.0";
    sources     = [{ filename = "mingw-w64-i686-libaacs-0.11.0-1-any.pkg.tar.zst"; sha256 = "61ff26b2e9d9c70809583d596aebc7ff1bd01d8902e8c2ada2e15ed56fc0b8f3"; }];
    buildInputs = [ libgcrypt ];
  };

  "libaec" = fetch {
    pname       = "libaec";
    version     = "1.0.4";
    sources     = [{ filename = "mingw-w64-i686-libaec-1.0.4-1-any.pkg.tar.zst"; sha256 = "e1195f1aed9c6456d9d6b949b665348ab182070ad734c9693b5ce91ec9d779eb"; }];
    buildInputs = [ crt-git ];
  };

  "libao" = fetch {
    pname       = "libao";
    version     = "1.2.2";
    sources     = [{ filename = "mingw-w64-i686-libao-1.2.2-1-any.pkg.tar.xz"; sha256 = "93d17e663b7eb80ac58788592df98c8b287e1404eb5e7e10542c9c0427315fd7"; }];
    buildInputs = [ gcc-libs ];
  };

  "libarchive" = fetch {
    pname       = "libarchive";
    version     = "3.4.3";
    sources     = [{ filename = "mingw-w64-i686-libarchive-3.4.3-1-any.pkg.tar.zst"; sha256 = "fecf04147c8d45d107e79637df6fc444d63d65aebcf8adcf486c61ac4c985e93"; }];
    buildInputs = [ gcc-libs bzip2 expat libiconv lz4 libsystre nettle openssl xz zlib zstd ];
  };

  "libart_lgpl" = fetch {
    pname       = "libart_lgpl";
    version     = "2.3.21";
    sources     = [{ filename = "mingw-w64-i686-libart_lgpl-2.3.21-2-any.pkg.tar.xz"; sha256 = "75977ad77c2be5118371d2adca18580e4e35c5fb4dbeaed9f5be7264ec0ae118"; }];
  };

  "libass" = fetch {
    pname       = "libass";
    version     = "0.14.0";
    sources     = [{ filename = "mingw-w64-i686-libass-0.14.0-1-any.pkg.tar.xz"; sha256 = "d0d9d9a7eb4a976b659ada4a49cd2ffe9ee2974a6579c3bdc1d3dcb985b8e398"; }];
    buildInputs = [ fribidi fontconfig freetype harfbuzz ];
  };

  "libassuan" = fetch {
    pname       = "libassuan";
    version     = "2.5.3";
    sources     = [{ filename = "mingw-w64-i686-libassuan-2.5.3-1-any.pkg.tar.xz"; sha256 = "5890a1caf1020c7a9c9ea0292db902c260857ef0b2ead502e50a251f596b69d2"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libatomic_ops" = fetch {
    pname       = "libatomic_ops";
    version     = "7.6.10";
    sources     = [{ filename = "mingw-w64-i686-libatomic_ops-7.6.10-1-any.pkg.tar.xz"; sha256 = "716cdc5d7e69e80b6ead576e4da8e3e6aad43b7cbf7cc74d62d3cbb7f7216224"; }];
    buildInputs = [  ];
  };

  "libavif" = fetch {
    pname       = "libavif";
    version     = "0.8.1";
    sources     = [{ filename = "mingw-w64-i686-libavif-0.8.1-1-any.pkg.tar.zst"; sha256 = "f72465b263fc82b7bdb9b5b00ebf36dc1618f24f83e834800332c88144e6f55e"; }];
    buildInputs = [ aom dav1d rav1e libjpeg-turbo libpng zlib ];
  };

  "libavro" = fetch {
    pname       = "libavro";
    version     = "1.10.0";
    sources     = [{ filename = "mingw-w64-i686-libavro-1.10.0-1-any.pkg.tar.zst"; sha256 = "55b1513aae08fe0d9c3fefae66bf3dbc39bd17dc8b05ca172e23e4da1d021ff6"; }];
    buildInputs = [ boost jansson snappy xz zlib ];
  };

  "libbdplus" = fetch {
    pname       = "libbdplus";
    version     = "0.1.2";
    sources     = [{ filename = "mingw-w64-i686-libbdplus-0.1.2-1-any.pkg.tar.xz"; sha256 = "64fc5d0c4ece6410c88fc671a55a562d430a818caf0971ddf86b3b669f8d1e6f"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libaacs.version "0.7.0"; libaacs) libgpg-error ];
  };

  "libblocksruntime" = fetch {
    pname       = "libblocksruntime";
    version     = "0.4.1";
    sources     = [{ filename = "mingw-w64-i686-libblocksruntime-0.4.1-1-any.pkg.tar.xz"; sha256 = "d7ef7df6320bce13fe011183cc950b999024ba5c7b27a91508fa9f089b5bdd61"; }];
    buildInputs = [ clang ];
  };

  "libbluray" = fetch {
    pname       = "libbluray";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-libbluray-1.2.0-1-any.pkg.tar.xz"; sha256 = "691d733731687520a4e4810fae69d12c6df56d183a31ef8ca79fbd9409e02d40"; }];
    buildInputs = [ libxml2 freetype ];
  };

  "libbotan" = fetch {
    pname       = "libbotan";
    version     = "2.14.0";
    sources     = [{ filename = "mingw-w64-i686-libbotan-2.14.0-1-any.pkg.tar.xz"; sha256 = "dbe50008f4597233604f7079c5a209f14696a879287655c60dc98ef231c357b0"; }];
    buildInputs = [ gcc-libs boost bzip2 sqlite3 zlib xz ];
  };

  "libbs2b" = fetch {
    pname       = "libbs2b";
    version     = "3.1.0";
    sources     = [{ filename = "mingw-w64-i686-libbs2b-3.1.0-1-any.pkg.tar.xz"; sha256 = "1a974aa46bd3de2515f47911804938afaac8a4d7bc9b657b8627510aef44875a"; }];
    buildInputs = [ libsndfile ];
  };

  "libbsdf" = fetch {
    pname       = "libbsdf";
    version     = "0.9.11";
    sources     = [{ filename = "mingw-w64-i686-libbsdf-0.9.11-1-any.pkg.tar.xz"; sha256 = "a4bfc7463995b749a9d0438e6b83825688b52376dc233c413096fc615352edf4"; }];
  };

  "libc++" = fetch {
    pname       = "libc++";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-libc++-10.0.1-1-any.pkg.tar.zst"; sha256 = "d4ac24dac28fe47a9af605ce4e76c7206bb1e25329c2495c5dbfad160b044605"; }];
    buildInputs = [ libunwind ];
  };

  "libc++abi" = fetch {
    pname       = "libc++abi";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-libc++abi-10.0.1-1-any.pkg.tar.zst"; sha256 = "1cb790a932e2318acd276faf74a39c722893698bb0e4286ed375a1942a650fac"; }];
    buildInputs = [ libunwind ];
  };

  "libcaca" = fetch {
    pname       = "libcaca";
    version     = "0.99.beta19";
    sources     = [{ filename = "mingw-w64-i686-libcaca-0.99.beta19-5-any.pkg.tar.xz"; sha256 = "a0e444b2c3042c1e33cc290d8a80abfa00a0c78ad650e0be956b6559cc71043c"; }];
    buildInputs = [ fontconfig freetype zlib ];
  };

  "libcddb" = fetch {
    pname       = "libcddb";
    version     = "1.3.2";
    sources     = [{ filename = "mingw-w64-i686-libcddb-1.3.2-5-any.pkg.tar.xz"; sha256 = "144f665c5e781b8ee8e2a701c150fb750955fe652c1a9e686faff0975ebdd634"; }];
    buildInputs = [ libsystre ];
  };

  "libcdio" = fetch {
    pname       = "libcdio";
    version     = "2.1.0";
    sources     = [{ filename = "mingw-w64-i686-libcdio-2.1.0-3-any.pkg.tar.xz"; sha256 = "a8e707d902aafb689307de9528b4acc85adb01f8dcb795aa1f06349fba185f3d"; }];
    buildInputs = [ libiconv libcddb ];
  };

  "libcdio-paranoia" = fetch {
    pname       = "libcdio-paranoia";
    version     = "10.2+2.0.0";
    sources     = [{ filename = "mingw-w64-i686-libcdio-paranoia-10.2+2.0.0-1-any.pkg.tar.xz"; sha256 = "69b62b1d32c314c75c13999cf13fde6d80de79471aa0026ee8627ceed761510c"; }];
    buildInputs = [ libcdio ];
  };

  "libcdr" = fetch {
    pname       = "libcdr";
    version     = "0.1.6";
    sources     = [{ filename = "mingw-w64-i686-libcdr-0.1.6-3-any.pkg.tar.zst"; sha256 = "9dd4ace80649e82ee8a9d34a204824669b7839c382f667a5a04e384017038bda"; }];
    buildInputs = [ icu lcms2 librevenge zlib ];
  };

  "libcello-git" = fetch {
    pname       = "libcello-git";
    version     = "2.1.0.301.da28eef";
    sources     = [{ filename = "mingw-w64-i686-libcello-git-2.1.0.301.da28eef-1-any.pkg.tar.xz"; sha256 = "85a66aecb8556c00837f40b1fc0d1684610d7ab3b45fe4e62fa58fb60d768365"; }];
  };

  "libcerf" = fetch {
    pname       = "libcerf";
    version     = "2.0";
    sources     = [{ filename = "mingw-w64-i686-libcerf-2.0-1-any.pkg.tar.zst"; sha256 = "9600fc35ecddd2373ab72e5c60a86feeec8d21656fafee8242fd6ff0e02e07f1"; }];
    buildInputs = [  ];
  };

  "libchamplain" = fetch {
    pname       = "libchamplain";
    version     = "0.12.20";
    sources     = [{ filename = "mingw-w64-i686-libchamplain-0.12.20-1-any.pkg.tar.xz"; sha256 = "c7a9f533da1b6a9e2149c24357e7fbc95cca05fdd86d197dd8228269c5efaabe"; }];
    buildInputs = [ clutter clutter-gtk cairo libsoup memphis sqlite3 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "libconfig" = fetch {
    pname       = "libconfig";
    version     = "1.7.2";
    sources     = [{ filename = "mingw-w64-i686-libconfig-1.7.2-1-any.pkg.tar.xz"; sha256 = "53ba95caf85272e6e40fd946c34386c3b88cb93816e8b4056e9490402d48dc23"; }];
    buildInputs = [ gcc-libs ];
  };

  "libconfini" = fetch {
    pname       = "libconfini";
    version     = "1.15.0";
    sources     = [{ filename = "mingw-w64-i686-libconfini-1.15.0-1-any.pkg.tar.zst"; sha256 = "9062e9f02052d9f23ffa471942f6dcac03404d23048307cb1a4aae177e34b6ea"; }];
  };

  "libcue" = fetch {
    pname       = "libcue";
    version     = "2.2.1";
    sources     = [{ filename = "mingw-w64-i686-libcue-2.2.1-1-any.pkg.tar.xz"; sha256 = "9a7c0aacf7c12c84ab7cd2bfa3ea5e6df30602d01bc80895ec5204f4746432a0"; }];
  };

  "libdatrie" = fetch {
    pname       = "libdatrie";
    version     = "0.2.12";
    sources     = [{ filename = "mingw-w64-i686-libdatrie-0.2.12-1-any.pkg.tar.xz"; sha256 = "059e047a9b9a9f6023bf5723edbe3efe5ba2994515cb4c91af89e10002ef8ad1"; }];
    buildInputs = [ libiconv ];
  };

  "libdazzle" = fetch {
    pname       = "libdazzle";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-libdazzle-3.38.0-1-any.pkg.tar.zst"; sha256 = "fb166584de761672e08fb888d8969d4d696dc82fbd354ed4b685b94592dcc36d"; }];
    buildInputs = [ glib2 ];
  };

  "libdca" = fetch {
    pname       = "libdca";
    version     = "0.0.7";
    sources     = [{ filename = "mingw-w64-i686-libdca-0.0.7-1-any.pkg.tar.xz"; sha256 = "8c44702a8f406e9711c71d31da3a0ed4065463554230bcf9442f71c0bc871771"; }];
  };

  "libde265" = fetch {
    pname       = "libde265";
    version     = "1.0.7";
    sources     = [{ filename = "mingw-w64-i686-libde265-1.0.7-1-any.pkg.tar.zst"; sha256 = "1e5f83288c7e3f3e563d61040aa2d15dd15a4b8610fe7e3b3e707b8064f078a7"; }];
    buildInputs = [ gcc-libs ];
  };

  "libdeflate" = fetch {
    pname       = "libdeflate";
    version     = "1.6";
    sources     = [{ filename = "mingw-w64-i686-libdeflate-1.6-1-any.pkg.tar.zst"; sha256 = "a464c0d0009b2f99e8bac4b873fbc3c47f220061787de2784bfa837bbc4a4770"; }];
  };

  "libdiscid" = fetch {
    pname       = "libdiscid";
    version     = "0.6.2";
    sources     = [{ filename = "mingw-w64-i686-libdiscid-0.6.2-1-any.pkg.tar.xz"; sha256 = "7572a06a524c9adbcd2df668cdda6d191013dc3f22b55b1cfdf786e167bf0fd0"; }];
  };

  "libdsm" = fetch {
    pname       = "libdsm";
    version     = "0.3.2";
    sources     = [{ filename = "mingw-w64-i686-libdsm-0.3.2-1-any.pkg.tar.xz"; sha256 = "d3327827de0f4120c229597d51af85c2e43ce5cf240f5edcc872ea17bc668aa4"; }];
    buildInputs = [ libtasn1 ];
  };

  "libdvbpsi" = fetch {
    pname       = "libdvbpsi";
    version     = "1.3.3";
    sources     = [{ filename = "mingw-w64-i686-libdvbpsi-1.3.3-1-any.pkg.tar.xz"; sha256 = "5ed18f2f1625f590d11c707045b399385e5dbe8f16edfbff490c8f6dc85962e2"; }];
    buildInputs = [ gcc-libs ];
  };

  "libdvdcss" = fetch {
    pname       = "libdvdcss";
    version     = "1.4.2";
    sources     = [{ filename = "mingw-w64-i686-libdvdcss-1.4.2-1-any.pkg.tar.xz"; sha256 = "aaa6459a08267e925da9b521f90c2c6f35c328a30a71b42e152b0d90e3e4690b"; }];
    buildInputs = [ gcc-libs ];
  };

  "libdvdnav" = fetch {
    pname       = "libdvdnav";
    version     = "6.1.0";
    sources     = [{ filename = "mingw-w64-i686-libdvdnav-6.1.0-2-any.pkg.tar.xz"; sha256 = "596903891faaec07d5cc69cba230f8c98978b89a5dd80c172c7af50071d883db"; }];
    buildInputs = [ libdvdread ];
  };

  "libdvdread" = fetch {
    pname       = "libdvdread";
    version     = "6.1.1";
    sources     = [{ filename = "mingw-w64-i686-libdvdread-6.1.1-1-any.pkg.tar.xz"; sha256 = "12d1930492c5f3c9e46d3c375e139b16e7546c8579fee3e38ad9eab670bf36fc"; }];
    buildInputs = [ libdvdcss ];
  };

  "libebml" = fetch {
    pname       = "libebml";
    version     = "1.4.0";
    sources     = [{ filename = "mingw-w64-i686-libebml-1.4.0-1-any.pkg.tar.zst"; sha256 = "51edb05b33575e6647cb5b09a47fe65f52fca842216f868af505d2fdd5a0cf97"; }];
    buildInputs = [ gcc-libs ];
  };

  "libelf" = fetch {
    pname       = "libelf";
    version     = "0.8.13";
    sources     = [{ filename = "mingw-w64-i686-libelf-0.8.13-4-any.pkg.tar.xz"; sha256 = "a7bdd1876f445d6fa22e44d1402b7247c42c254525c01336f0ce683f5c8ad610"; }];
    buildInputs = [  ];
  };

  "libepoxy" = fetch {
    pname       = "libepoxy";
    version     = "1.5.4";
    sources     = [{ filename = "mingw-w64-i686-libepoxy-1.5.4-1-any.pkg.tar.xz"; sha256 = "72d8099beb74659dd46bbd5c8adae97b3ba613c8727573910a3d2d55554d00a4"; }];
    buildInputs = [ gcc-libs ];
  };

  "liberime" = fetch {
    pname       = "liberime";
    version     = "0.0.5";
    sources     = [{ filename = "mingw-w64-i686-liberime-0.0.5-2-any.pkg.tar.xz"; sha256 = "0f24ac999c5dd7643fa34bcfef00f9c2a652754c8a68ae7e06c099e759eb4d2b"; }];
    buildInputs = [ librime ];
  };

  "libevent" = fetch {
    pname       = "libevent";
    version     = "2.1.12";
    sources     = [{ filename = "mingw-w64-i686-libevent-2.1.12-1-any.pkg.tar.zst"; sha256 = "7fe48dc95f563e28cf0b662a720cbeb64c79188fdc055a35db7d1d33bf404d78"; }];
  };

  "libexif" = fetch {
    pname       = "libexif";
    version     = "0.6.22";
    sources     = [{ filename = "mingw-w64-i686-libexif-0.6.22-1-any.pkg.tar.zst"; sha256 = "43551ebf328cd9d6dc9233456e2c451e64681b331927d41368f5f3ca6c2bde03"; }];
    buildInputs = [ gettext ];
  };

  "libexodus" = fetch {
    pname       = "libexodus";
    version     = "8.07";
    sources     = [{ filename = "mingw-w64-i686-libexodus-8.07-1-any.pkg.tar.zst"; sha256 = "706bfbfc57f8ae0ef5ffe967e1afbe287c89f2ebf0a2e2288f2d3929a49723b8"; }];
    buildInputs = [ crt-git ];
  };

  "libffi" = fetch {
    pname       = "libffi";
    version     = "3.3";
    sources     = [{ filename = "mingw-w64-i686-libffi-3.3-1-any.pkg.tar.xz"; sha256 = "5bc5811941e88522cdd5fc255b724b0f444feb6c59ccf9f10ad35a0ed62124b0"; }];
    buildInputs = [  ];
  };

  "libfilezilla" = fetch {
    pname       = "libfilezilla";
    version     = "0.21.0";
    sources     = [{ filename = "mingw-w64-i686-libfilezilla-0.21.0-1-any.pkg.tar.zst"; sha256 = "28c8bb1431125653d1f58efe4588280dc5cd55aff7318ef6dd732b51960bbeb0"; }];
    buildInputs = [ gcc-libs nettle gnutls ];
  };

  "libfreexl" = fetch {
    pname       = "libfreexl";
    version     = "1.0.6";
    sources     = [{ filename = "mingw-w64-i686-libfreexl-1.0.6-1-any.pkg.tar.zst"; sha256 = "efd63911a97e199c23237910abcf00c4c651fc790a28307b8fcb263f2a28678b"; }];
    buildInputs = [  ];
  };

  "libftdi" = fetch {
    pname       = "libftdi";
    version     = "1.4";
    sources     = [{ filename = "mingw-w64-i686-libftdi-1.4-3-any.pkg.tar.xz"; sha256 = "5cd4ee2839f777d4e998e2083b11c658a48d8cd464a08928e23921d712485179"; }];
    buildInputs = [ libusb confuse gettext libiconv ];
  };

  "libgadu" = fetch {
    pname       = "libgadu";
    version     = "1.12.2";
    sources     = [{ filename = "mingw-w64-i686-libgadu-1.12.2-1-any.pkg.tar.xz"; sha256 = "23c30c8b842054a721057907f2cbcaee4bc02986e244b8ed977cac9d82a666bc"; }];
    buildInputs = [ gnutls protobuf-c ];
  };

  "libgcrypt" = fetch {
    pname       = "libgcrypt";
    version     = "1.8.6";
    sources     = [{ filename = "mingw-w64-i686-libgcrypt-1.8.6-1-any.pkg.tar.zst"; sha256 = "c8f0ebc853051520e6117a9a8dcab9eb7db8032eff1e1b23813006bdfdf10e48"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libgd" = fetch {
    pname       = "libgd";
    version     = "2.3.0";
    sources     = [{ filename = "mingw-w64-i686-libgd-2.3.0-3-any.pkg.tar.zst"; sha256 = "49c2d1c7f1428e6767314a98936ddfd55e1cde755af7dc8a954907c4c4eb5ffb"; }];
    buildInputs = [ libpng libiconv libjpeg libtiff freetype fontconfig libimagequant libwebp xpm-nox zlib ];
  };

  "libgda" = fetch {
    pname       = "libgda";
    version     = "5.2.9";
    sources     = [{ filename = "mingw-w64-i686-libgda-5.2.9-1-any.pkg.tar.xz"; sha256 = "b243e12203d58bb594e34311d347770792636884191e757f046d3673a9729ccf"; }];
    buildInputs = [ gtk3 gtksourceview3 goocanvas iso-codes json-glib libsoup libxml2 libxslt glade ];
  };

  "libgdata" = fetch {
    pname       = "libgdata";
    version     = "0.17.13";
    sources     = [{ filename = "mingw-w64-i686-libgdata-0.17.13-1-any.pkg.tar.zst"; sha256 = "db17df0884d4f42d9813794b67ddf4568a2cba316b3b32acc5fc3257498b6bcd"; }];
    buildInputs = [ glib2 gtk3 json-glib liboauth libsoup libxml2 ];
  };

  "libgdiplus" = fetch {
    pname       = "libgdiplus";
    version     = "5.6.1";
    sources     = [{ filename = "mingw-w64-i686-libgdiplus-5.6.1-1-any.pkg.tar.xz"; sha256 = "86f0e1970d7f432c119e291b764ace9f98dc813fe5fbc42224c76bf91d966c17"; }];
    buildInputs = [ libtiff cairo fontconfig freetype giflib glib2 libexif libpng zlib ];
  };

  "libgee" = fetch {
    pname       = "libgee";
    version     = "0.20.3";
    sources     = [{ filename = "mingw-w64-i686-libgee-0.20.3-1-any.pkg.tar.xz"; sha256 = "6d513a7fc46a14f0468e82d1697f78a4cc3a4e55e97d35d15b265121f5ec435a"; }];
    buildInputs = [ glib2 ];
  };

  "libgeotiff" = fetch {
    pname       = "libgeotiff";
    version     = "1.6.0";
    sources     = [{ filename = "mingw-w64-i686-libgeotiff-1.6.0-1-any.pkg.tar.zst"; sha256 = "91bd81bf007b0ac42f1ad7f7b9f8f6c2ee82a0e31f041e99cf288173ad968281"; }];
    buildInputs = [ gcc-libs libtiff libjpeg proj zlib ];
  };

  "libgit2" = fetch {
    pname       = "libgit2";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-libgit2-1.1.0-1-any.pkg.tar.zst"; sha256 = "c1cd56f1c94c71c6825ab67881fe9fa1ef6c2cc30a0fa7bf782591d175df6ef6"; }];
    buildInputs = [ curl http-parser libssh2 openssl zlib ];
  };

  "libgit2-glib" = fetch {
    pname       = "libgit2-glib";
    version     = "0.99.0.1";
    sources     = [{ filename = "mingw-w64-i686-libgit2-glib-0.99.0.1-1-any.pkg.tar.xz"; sha256 = "67750bb75cba81edcf65657788c34417af07205dd6e75dc5df286788e82012a3"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libgit2.version "0.99"; libgit2) libssh2 glib2 ];
  };

  "libglade" = fetch {
    pname       = "libglade";
    version     = "2.6.4";
    sources     = [{ filename = "mingw-w64-i686-libglade-2.6.4-5-any.pkg.tar.xz"; sha256 = "0bc64775c9da63a5778724fdd80e78aa0efabc6b9d5dfe42ecfe9de7c566869f"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.16.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.3"; libxml2) ];
  };

  "libgme" = fetch {
    pname       = "libgme";
    version     = "0.6.3";
    sources     = [{ filename = "mingw-w64-i686-libgme-0.6.3-1-any.pkg.tar.zst"; sha256 = "2a4b7acd4d317e8baaa63de7498c87732aa2b719ff13e06054763ebeaf5b99e6"; }];
    buildInputs = [ gcc-libs ];
  };

  "libgnomecanvas" = fetch {
    pname       = "libgnomecanvas";
    version     = "2.30.3";
    sources     = [{ filename = "mingw-w64-i686-libgnomecanvas-2.30.3-3-any.pkg.tar.xz"; sha256 = "f9627cc3e435f113575932afa27a784dc99d1e370dfd3be68bb1d682ce3efced"; }];
    buildInputs = [ gtk2 gettext libart_lgpl libglade ];
  };

  "libgnurx" = fetch {
    pname       = "libgnurx";
    version     = "2.5.1";
    sources     = [{ filename = "mingw-w64-i686-libgnurx-2.5.1-2-any.pkg.tar.zst"; sha256 = "a3fd2f0959305c81c3e8fe71977aa0c2f8be3c058714f724c7b220347cb870a8"; }];
  };

  "libgoom2" = fetch {
    pname       = "libgoom2";
    version     = "2k4";
    sources     = [{ filename = "mingw-w64-i686-libgoom2-2k4-3-any.pkg.tar.xz"; sha256 = "6a2aa8cbf1ee5f1f195bca8fa788e85482bc467b1f49a1195f7f71b931a39299"; }];
    buildInputs = [ gcc-libs ];
  };

  "libgpg-error" = fetch {
    pname       = "libgpg-error";
    version     = "1.39";
    sources     = [{ filename = "mingw-w64-i686-libgpg-error-1.39-1-any.pkg.tar.zst"; sha256 = "c7700ae54a95e07c31d231f41343446fd34666c9e40e9640090ce5e1a6739a30"; }];
    buildInputs = [ gcc-libs gettext ];
  };

  "libgphoto2" = fetch {
    pname       = "libgphoto2";
    version     = "2.5.23";
    sources     = [{ filename = "mingw-w64-i686-libgphoto2-2.5.23-2-any.pkg.tar.zst"; sha256 = "c7bc2b751ffc1f7c1b9e747fdc3f63e247ceeadf04af6c54e95c0c83a8d580bb"; }];
    buildInputs = [ libsystre libjpeg libxml2 libgd libexif libusb libtool ];
  };

  "libgsf" = fetch {
    pname       = "libgsf";
    version     = "1.14.47";
    sources     = [{ filename = "mingw-w64-i686-libgsf-1.14.47-1-any.pkg.tar.zst"; sha256 = "2ef945eb1ba36dc7f79774b2ce28e046a4b59fdf244c38af3fc6f7ea44e71e26"; }];
    buildInputs = [ glib2 gdk-pixbuf2 libxml2 zlib ];
  };

  "libguess" = fetch {
    pname       = "libguess";
    version     = "1.2";
    sources     = [{ filename = "mingw-w64-i686-libguess-1.2-3-any.pkg.tar.xz"; sha256 = "a289467fa311deba5f363a26a20a615101884eb88d2442dd7ac0fc490a45f22b"; }];
    buildInputs = [ libmowgli ];
  };

  "libgusb" = fetch {
    pname       = "libgusb";
    version     = "0.3.5";
    sources     = [{ filename = "mingw-w64-i686-libgusb-0.3.5-1-any.pkg.tar.zst"; sha256 = "53ac69afa0a170afb53395036fc9977f18f041d7fe1c313045d16177afbd9dca"; }];
    buildInputs = [ libusb glib2 ];
  };

  "libgweather" = fetch {
    pname       = "libgweather";
    version     = "3.36.1";
    sources     = [{ filename = "mingw-w64-i686-libgweather-3.36.1-1-any.pkg.tar.zst"; sha256 = "7db763a8962946d6b5a79920c65da6f51585bb056ac1f86be0960e4da677ac26"; }];
    buildInputs = [ gtk3 libsoup libsystre libxml2 geocode-glib ];
  };

  "libgxps" = fetch {
    pname       = "libgxps";
    version     = "0.3.1";
    sources     = [{ filename = "mingw-w64-i686-libgxps-0.3.1-1-any.pkg.tar.xz"; sha256 = "ad733c0627719cb63c290651d03dbc722885be5591ae49053715725076c4dead"; }];
    buildInputs = [ glib2 gtk3 cairo lcms2 libarchive libjpeg libxslt libpng ];
  };

  "libhandy" = fetch {
    pname       = "libhandy";
    version     = "1.0.0";
    sources     = [{ filename = "mingw-w64-i686-libhandy-1.0.0-1-any.pkg.tar.zst"; sha256 = "c871f0ddce75cdd7ab61d028ce81805539977ada681c9f3efdc379b287dbed10"; }];
    buildInputs = [ glib2 gtk3 ];
  };

  "libharu" = fetch {
    pname       = "libharu";
    version     = "2.3.0";
    sources     = [{ filename = "mingw-w64-i686-libharu-2.3.0-2-any.pkg.tar.xz"; sha256 = "ae6a4182e460f663a205440136699370197ef4556cee33523ee511bf95b5d734"; }];
    buildInputs = [ libpng ];
  };

  "libheif" = fetch {
    pname       = "libheif";
    version     = "1.9.1";
    sources     = [{ filename = "mingw-w64-i686-libheif-1.9.1-1-any.pkg.tar.zst"; sha256 = "3d1524f4257ffcc9361b33977952e7d6cff6ee56dbb165a9a93355ca4e01771e"; }];
    buildInputs = [ gcc-libs libde265 libjpeg-turbo libpng aom libwinpthread-git x265 ];
  };

  "libical" = fetch {
    pname       = "libical";
    version     = "3.0.8";
    sources     = [{ filename = "mingw-w64-i686-libical-3.0.8-3-any.pkg.tar.zst"; sha256 = "c8c199c7029f8f6b1d37b2dc0d6b663fd84ba37b258fc9febc974aaf6571a17e"; }];
    buildInputs = [ gcc-libs icu glib2 gobject-introspection libxml2 db ];
  };

  "libiconv" = fetch {
    pname       = "libiconv";
    version     = "1.16";
    sources     = [{ filename = "mingw-w64-i686-libiconv-1.16-1-any.pkg.tar.xz"; sha256 = "bbd79d5059f116e8f4b8dd26ca661f384eee1082b265389dbfa364d316eea334"; }];
    buildInputs = [  ];
  };

  "libicsneo" = fetch {
    pname       = "libicsneo";
    version     = "0.1.2";
    sources     = [{ filename = "mingw-w64-i686-libicsneo-0.1.2-2-any.pkg.tar.zst"; sha256 = "a89adfcf0c36e15689742f49c218772e25ace47e7d93be8b74e009e9b7e260cd"; }];
    buildInputs = [ gcc-libs ];
  };

  "libid3tag" = fetch {
    pname       = "libid3tag";
    version     = "0.15.1b";
    sources     = [{ filename = "mingw-w64-i686-libid3tag-0.15.1b-2-any.pkg.tar.zst"; sha256 = "19a7964238e75d38614e23cef952c035b085bb04446bafedb0adb69bd0762a19"; }];
    buildInputs = [ gcc-libs ];
  };

  "libidl2" = fetch {
    pname       = "libidl2";
    version     = "0.8.14";
    sources     = [{ filename = "mingw-w64-i686-libidl2-0.8.14-1-any.pkg.tar.xz"; sha256 = "fcb98c60fe41d202a98e4dfb3ea725edb4ae49d20d1422781e9548f0c4105e31"; }];
    buildInputs = [ glib2 ];
  };

  "libidn" = fetch {
    pname       = "libidn";
    version     = "1.36";
    sources     = [{ filename = "mingw-w64-i686-libidn-1.36-1-any.pkg.tar.zst"; sha256 = "a153f2557a651af0091dfab5780f7f913391c921648a6adb576128c4a0e5b9c3"; }];
    buildInputs = [ gettext ];
  };

  "libidn2" = fetch {
    pname       = "libidn2";
    version     = "2.3.0";
    sources     = [{ filename = "mingw-w64-i686-libidn2-2.3.0-1-any.pkg.tar.xz"; sha256 = "08a0cf34e9f9496ea585bd0d5404222c8eb76bcb07dfe4ff16f3fcebefcf920e"; }];
    buildInputs = [ gettext libunistring ];
  };

  "libilbc" = fetch {
    pname       = "libilbc";
    version     = "2.0.2";
    sources     = [{ filename = "mingw-w64-i686-libilbc-2.0.2-1-any.pkg.tar.xz"; sha256 = "9c448f259edf1cae1db449efbbf2a9ed90b4161300341c57cc327bca30cc991b"; }];
  };

  "libimagequant" = fetch {
    pname       = "libimagequant";
    version     = "2.13.0";
    sources     = [{ filename = "mingw-w64-i686-libimagequant-2.13.0-1-any.pkg.tar.zst"; sha256 = "d6138c50353abcbc374a363b041a16f70c3ed9079e624e67040c10927cb780b6"; }];
    buildInputs = [  ];
  };

  "libimobiledevice" = fetch {
    pname       = "libimobiledevice";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-libimobiledevice-1.2.0-2-any.pkg.tar.zst"; sha256 = "2de646311669632c4bff5b4d71386f373a9280a1fc32f25de50a2446950c3576"; }];
    buildInputs = [ libusbmuxd libplist openssl ];
  };

  "libjaylink-git" = fetch {
    pname       = "libjaylink-git";
    version     = "r175.cfccbc9";
    sources     = [{ filename = "mingw-w64-i686-libjaylink-git-r175.cfccbc9-1-any.pkg.tar.xz"; sha256 = "437e533a89d9b94191de29874ff1ba6f8c2ecd21d0b04fa042f919ff540fa25d"; }];
    buildInputs = [ libusb ];
  };

  "libjpeg-turbo" = fetch {
    pname       = "libjpeg-turbo";
    version     = "2.0.5";
    sources     = [{ filename = "mingw-w64-i686-libjpeg-turbo-2.0.5-1-any.pkg.tar.zst"; sha256 = "52714a90e0205b7e90ba023ef7ef99104347abc6105d9275c93d4fce3e40abe2"; }];
    buildInputs = [ gcc-libs ];
  };

  "libkml" = fetch {
    pname       = "libkml";
    version     = "1.3.0";
    sources     = [{ filename = "mingw-w64-i686-libkml-1.3.0-8-any.pkg.tar.xz"; sha256 = "8f66fb1d3ad5afc9fbbf7a0bd4e0d3b4f91d45185748004c1fb5ee67a1bdc4b6"; }];
    buildInputs = [ boost minizip-git uriparser zlib ];
  };

  "libksba" = fetch {
    pname       = "libksba";
    version     = "1.4.0";
    sources     = [{ filename = "mingw-w64-i686-libksba-1.4.0-1-any.pkg.tar.zst"; sha256 = "2d2adf6ea217b87fd488ceda0c3f4a652fa20acdf7084c2946d15defee14cccc"; }];
    buildInputs = [ libgpg-error ];
  };

  "liblas" = fetch {
    pname       = "liblas";
    version     = "1.8.1";
    sources     = [{ filename = "mingw-w64-i686-liblas-1.8.1-2-any.pkg.tar.zst"; sha256 = "5f5f172e5399e6ed6a798306c1cc8655747179396724eaf8eb2743e9f58e6952"; }];
    buildInputs = [ gdal laszip ];
  };

  "liblastfm" = fetch {
    pname       = "liblastfm";
    version     = "1.0.9";
    sources     = [{ filename = "mingw-w64-i686-liblastfm-1.0.9-2-any.pkg.tar.xz"; sha256 = "08cefaa608316ac7f77301114be950e7fdbfed91f07d9e78326838553fae8cd3"; }];
    buildInputs = [ qt5 fftw libsamplerate ];
  };

  "liblqr" = fetch {
    pname       = "liblqr";
    version     = "0.4.2";
    sources     = [{ filename = "mingw-w64-i686-liblqr-0.4.2-4-any.pkg.tar.xz"; sha256 = "080a3650b88e743430baab0548f267ed3738986e7b5a455212f59c79599279ce"; }];
    buildInputs = [ glib2 ];
  };

  "libmad" = fetch {
    pname       = "libmad";
    version     = "0.15.1b";
    sources     = [{ filename = "mingw-w64-i686-libmad-0.15.1b-4-any.pkg.tar.xz"; sha256 = "172c51cabb87e762454f0b1573984bbf743eee659e8e37d6e73b5f57081fdda8"; }];
    buildInputs = [  ];
  };

  "libmangle-git" = fetch {
    pname       = "libmangle-git";
    version     = "9.0.0.6029.ecb4ff54";
    sources     = [{ filename = "mingw-w64-i686-libmangle-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "7efdad6ce683c4b29bb2436a33ba7d35d945bf943670d616cf7f23cfdf5628bc"; }];
  };

  "libmariadbclient" = fetch {
    pname       = "libmariadbclient";
    version     = "3.1.7";
    sources     = [{ filename = "mingw-w64-i686-libmariadbclient-3.1.7-2-any.pkg.tar.zst"; sha256 = "2b03e671823faa2ca8e80a17e8527443f3955c0ba3c5c885e043bf979b9cdd7a"; }];
    buildInputs = [ gcc-libs curl zlib ];
  };

  "libmatroska" = fetch {
    pname       = "libmatroska";
    version     = "1.6.2";
    sources     = [{ filename = "mingw-w64-i686-libmatroska-1.6.2-1-any.pkg.tar.zst"; sha256 = "0b8efa99e970d50b5339be75fc315583dea776819e14c8f167f225cecd94f82f"; }];
    buildInputs = [ libebml ];
  };

  "libmaxminddb" = fetch {
    pname       = "libmaxminddb";
    version     = "1.3.2";
    sources     = [{ filename = "mingw-w64-i686-libmaxminddb-1.3.2-1-any.pkg.tar.xz"; sha256 = "7db4133f04d2cf286b66c33e9fd776d6f44b0e1251d4970497246a387e6eb35a"; }];
    buildInputs = [ gcc-libs geoip2-database ];
  };

  "libmetalink" = fetch {
    pname       = "libmetalink";
    version     = "0.1.3";
    sources     = [{ filename = "mingw-w64-i686-libmetalink-0.1.3-3-any.pkg.tar.xz"; sha256 = "6abbb39400f04f8c90cbd6b366a15df7228ddda7c9430314968e2d9118bd14ba"; }];
    buildInputs = [ gcc-libs expat ];
  };

  "libmfx" = fetch {
    pname       = "libmfx";
    version     = "1.25";
    sources     = [{ filename = "mingw-w64-i686-libmfx-1.25-1-any.pkg.tar.xz"; sha256 = "6c1727331b72c4dd778401d47e854ab12966dd18c39ad938fbdd8692ad079b52"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmicrodns" = fetch {
    pname       = "libmicrodns";
    version     = "0.2.0";
    sources     = [{ filename = "mingw-w64-i686-libmicrodns-0.2.0-1-any.pkg.tar.zst"; sha256 = "38423fce5be7d3c0846bebef6168cba66d0238789a14c0806284933bf464d141"; }];
    buildInputs = [ libtasn1 ];
  };

  "libmicrohttpd" = fetch {
    pname       = "libmicrohttpd";
    version     = "0.9.71";
    sources     = [{ filename = "mingw-w64-i686-libmicrohttpd-0.9.71-1-any.pkg.tar.zst"; sha256 = "eff2067d7c36a386d42dd1ade82e0a612d7a2afa3426f662d22cbd176272f342"; }];
    buildInputs = [ gnutls ];
  };

  "libmicroutils" = fetch {
    pname       = "libmicroutils";
    version     = "4.3.0";
    sources     = [{ filename = "mingw-w64-i686-libmicroutils-4.3.0-1-any.pkg.tar.xz"; sha256 = "fa146f157b4cf85164bcfc8ca9ae1695562f51cd47d6d17746bbd8e7aef49800"; }];
    buildInputs = [ libsystre ];
  };

  "libmikmod" = fetch {
    pname       = "libmikmod";
    version     = "3.3.11.1";
    sources     = [{ filename = "mingw-w64-i686-libmikmod-3.3.11.1-1-any.pkg.tar.xz"; sha256 = "19ea219ca201cea5c51bb64dba37080b0f88ce4853a1830d7c6fdce20c4f6ffa"; }];
    buildInputs = [ gcc-libs openal ];
  };

  "libmimic" = fetch {
    pname       = "libmimic";
    version     = "1.0.4";
    sources     = [{ filename = "mingw-w64-i686-libmimic-1.0.4-3-any.pkg.tar.xz"; sha256 = "c9605e2b87bf834264bf71073ea684c288d77e967a6b6c031dac5c24928d1c96"; }];
    buildInputs = [ glib2 ];
  };

  "libmng" = fetch {
    pname       = "libmng";
    version     = "2.0.3";
    sources     = [{ filename = "mingw-w64-i686-libmng-2.0.3-4-any.pkg.tar.xz"; sha256 = "77056da7beeae784c46d92f0425da9bbef3a12fe9333c58d567e78696cb1817b"; }];
    buildInputs = [ libjpeg-turbo lcms2 zlib ];
  };

  "libmodbus-git" = fetch {
    pname       = "libmodbus-git";
    version     = "658.0e2f470";
    sources     = [{ filename = "mingw-w64-i686-libmodbus-git-658.0e2f470-1-any.pkg.tar.xz"; sha256 = "3977f5f5817950ada9341adb2ceb4d214978370bda19155cbe5b362601324051"; }];
  };

  "libmodplug" = fetch {
    pname       = "libmodplug";
    version     = "0.8.9.0";
    sources     = [{ filename = "mingw-w64-i686-libmodplug-0.8.9.0-1-any.pkg.tar.xz"; sha256 = "0d9f118056139340c2b1dbc9ba44ac95631172608cc92dd3360a90741bc0aaf4"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmongoose" = fetch {
    pname       = "libmongoose";
    version     = "6.14";
    sources     = [{ filename = "mingw-w64-i686-libmongoose-6.14-1-any.pkg.tar.xz"; sha256 = "44b9ae85c740165a9bfd451692be078bfc7252186f7f7542f78610aa63f7f69e"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmowgli" = fetch {
    pname       = "libmowgli";
    version     = "2.1.3";
    sources     = [{ filename = "mingw-w64-i686-libmowgli-2.1.3-3-any.pkg.tar.xz"; sha256 = "93b089caca7782c639c67e061a25c2614923cbb3abd4f25c3564a92781f6dd57"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmpack" = fetch {
    pname       = "libmpack";
    version     = "1.0.5";
    sources     = [{ filename = "mingw-w64-i686-libmpack-1.0.5-1-any.pkg.tar.xz"; sha256 = "f7fabbe9a67f9133290084d279576c85d3de9e9be8e77047cc37a2b246d83738"; }];
  };

  "libmpcdec" = fetch {
    pname       = "libmpcdec";
    version     = "1.2.6";
    sources     = [{ filename = "mingw-w64-i686-libmpcdec-1.2.6-3-any.pkg.tar.xz"; sha256 = "8032ff97fd278deaa5cb712b7f5d1e7b265848ab78438e7792bd59caac377db3"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmpeg2-git" = fetch {
    pname       = "libmpeg2-git";
    version     = "r1108.946bf4b";
    sources     = [{ filename = "mingw-w64-i686-libmpeg2-git-r1108.946bf4b-1-any.pkg.tar.xz"; sha256 = "b57c4cd284f316ce691335d21551c7900a2e1139029ce402ef452c03facbbcd2"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmypaint" = fetch {
    pname       = "libmypaint";
    version     = "1.5.1";
    sources     = [{ filename = "mingw-w64-i686-libmypaint-1.5.1-2-any.pkg.tar.zst"; sha256 = "88729cccb42478e038994fa397bf4e74f6b67e1c4712f409babb6bb7d936459c"; }];
    buildInputs = [ gcc-libs glib2 json-c ];
  };

  "libmysofa" = fetch {
    pname       = "libmysofa";
    version     = "1.1";
    sources     = [{ filename = "mingw-w64-i686-libmysofa-1.1-1-any.pkg.tar.zst"; sha256 = "585f77b9e98eb2a8803bfa207cc2e297f52af25c0c47be3c3f384b27eab256a8"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "libnfs" = fetch {
    pname       = "libnfs";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-libnfs-4.0.0-1-any.pkg.tar.xz"; sha256 = "6240f321ad984294bfce07424d2cb07a525681d9f239f7d3c18fcc6f5af2df4e"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnice" = fetch {
    pname       = "libnice";
    version     = "0.1.18";
    sources     = [{ filename = "mingw-w64-i686-libnice-0.1.18-1-any.pkg.tar.zst"; sha256 = "f3a00a7e2684c96499647272c6a0043778449295fb85d8f8bd633c544d55d78b"; }];
    buildInputs = [ glib2 gnutls ];
  };

  "libnotify" = fetch {
    pname       = "libnotify";
    version     = "0.7.8";
    sources     = [{ filename = "mingw-w64-i686-libnotify-0.7.8-2-any.pkg.tar.xz"; sha256 = "150c7bd4a10cdf23e270ed67f3c25988194855a0268c39f129c9f8e77329ecad"; }];
    buildInputs = [ gdk-pixbuf2 glib2 ];
  };

  "libnova" = fetch {
    pname       = "libnova";
    version     = "0.15.0";
    sources     = [{ filename = "mingw-w64-i686-libnova-0.15.0-1-any.pkg.tar.xz"; sha256 = "4c46157bad4cffbfee94f7cc173f31bc40364df49571d99b8738ae2d21a4f392"; }];
  };

  "libntlm" = fetch {
    pname       = "libntlm";
    version     = "1.6";
    sources     = [{ filename = "mingw-w64-i686-libntlm-1.6-1-any.pkg.tar.zst"; sha256 = "aa03085dfbb7e11064dc314341ac31e1acfc1d7e3e67163c7b06d7f6053555db"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnumbertext" = fetch {
    pname       = "libnumbertext";
    version     = "1.0.6";
    sources     = [{ filename = "mingw-w64-i686-libnumbertext-1.0.6-1-any.pkg.tar.zst"; sha256 = "53a189935333dbd656d9923cf4bd7757cf83e90ec12e8cb99283c5b64bc040cb"; }];
    buildInputs = [ gcc-libs ];
  };

  "liboauth" = fetch {
    pname       = "liboauth";
    version     = "1.0.3";
    sources     = [{ filename = "mingw-w64-i686-liboauth-1.0.3-6-any.pkg.tar.xz"; sha256 = "6f1ca63318b18e286a6cbf3d71ebbe739abca3a8ebe17ac2aca52f21bd41c9ce"; }];
    buildInputs = [ curl nss ];
  };

  "libodfgen" = fetch {
    pname       = "libodfgen";
    version     = "0.1.7";
    sources     = [{ filename = "mingw-w64-i686-libodfgen-0.1.7-1-any.pkg.tar.xz"; sha256 = "6d07baedcaec60648ba27a98c7dcee928f9577d013e9c4f5fd47ded804cfad2d"; }];
    buildInputs = [ librevenge ];
  };

  "libogg" = fetch {
    pname       = "libogg";
    version     = "1.3.4";
    sources     = [{ filename = "mingw-w64-i686-libogg-1.3.4-3-any.pkg.tar.xz"; sha256 = "f131ddc10a81f85ddfd1ac92977205d3679e22635f6e7a36acb94cdf70bdda6f"; }];
    buildInputs = [  ];
  };

  "libopusenc" = fetch {
    pname       = "libopusenc";
    version     = "0.2.1";
    sources     = [{ filename = "mingw-w64-i686-libopusenc-0.2.1-1-any.pkg.tar.xz"; sha256 = "00cade8b795e547e9a4abd2c922023416286acf2ec7f73788cbc8e2c5d7f360b"; }];
    buildInputs = [ gcc-libs opus ];
  };

  "libosmpbf-git" = fetch {
    pname       = "libosmpbf-git";
    version     = "1.3.3.13.g4edb4f0";
    sources     = [{ filename = "mingw-w64-i686-libosmpbf-git-1.3.3.13.g4edb4f0-1-any.pkg.tar.xz"; sha256 = "e309fa2f2875a95da870ab3284f0cbf4b82f29df2b6c1f3fcbd43f13e5d9671c"; }];
    buildInputs = [ protobuf ];
  };

  "libosmscout" = fetch {
    pname       = "libosmscout";
    version     = "1.0.1";
    sources     = [{ filename = "mingw-w64-i686-libosmscout-1.0.1-1-any.pkg.tar.zst"; sha256 = "2fab56bf3d12b1484923ed3d5e9056c6770efd40c134062682b1c6fbfd1c838e"; }];
    buildInputs = [ protobuf qt5 ];
  };

  "libotr" = fetch {
    pname       = "libotr";
    version     = "4.1.1";
    sources     = [{ filename = "mingw-w64-i686-libotr-4.1.1-2-any.pkg.tar.xz"; sha256 = "a0a1e844eb74c80eaedd280c97c76ac24e3b4ad9795e3c96e6f78dfd4ac1f281"; }];
    buildInputs = [ libgcrypt ];
  };

  "libpaper" = fetch {
    pname       = "libpaper";
    version     = "1.1.28";
    sources     = [{ filename = "mingw-w64-i686-libpaper-1.1.28-1-any.pkg.tar.xz"; sha256 = "06d065cdc4066d2e4deae4ca634eb7f43ba4197354dfda75719be5b046c9cc5c"; }];
    buildInputs = [  ];
  };

  "libpeas" = fetch {
    pname       = "libpeas";
    version     = "1.28.0";
    sources     = [{ filename = "mingw-w64-i686-libpeas-1.28.0-1-any.pkg.tar.zst"; sha256 = "899c02469b616274298ec54bbabc313b090f8994adbf3f1cc9f5d1d9e61195cb"; }];
    buildInputs = [ gcc-libs gtk3 adwaita-icon-theme ];
  };

  "libplacebo" = fetch {
    pname       = "libplacebo";
    version     = "1.29.1";
    sources     = [{ filename = "mingw-w64-i686-libplacebo-1.29.1-1-any.pkg.tar.xz"; sha256 = "784d0d4ef9691b149b84191637d63717e714c9ec278229a9bd15bfd7e2eb308e"; }];
    buildInputs = [ vulkan spirv-tools ];
  };

  "libplist" = fetch {
    pname       = "libplist";
    version     = "2.2.0";
    sources     = [{ filename = "mingw-w64-i686-libplist-2.2.0-1-any.pkg.tar.zst"; sha256 = "2cfcc8e9b05068995b6377b293aac5ed2e721f4268837b55202f4e4202d276c9"; }];
    buildInputs = [ libxml2 cython ];
  };

  "libpng" = fetch {
    pname       = "libpng";
    version     = "1.6.37";
    sources     = [{ filename = "mingw-w64-i686-libpng-1.6.37-3-any.pkg.tar.xz"; sha256 = "e5a33d63a92e8ff80295d2bf7620c8d8587e8309f3d6f9cf2c5bd54d09e94b28"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "libproxy" = fetch {
    pname       = "libproxy";
    version     = "0.4.15";
    sources     = [{ filename = "mingw-w64-i686-libproxy-0.4.15-4-any.pkg.tar.zst"; sha256 = "11ea54d619a02817302e4d7f09d767ef98a2fa7b65615a3ba0638079938a84de"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpsl" = fetch {
    pname       = "libpsl";
    version     = "0.21.1";
    sources     = [{ filename = "mingw-w64-i686-libpsl-0.21.1-1-any.pkg.tar.zst"; sha256 = "fa595bf2b93633b2f05baba796dd1b5f0ff328a7d5639386f58a69b84bf565f7"; }];
    buildInputs = [ libiconv libidn2 libunistring gettext ];
  };

  "libraqm" = fetch {
    pname       = "libraqm";
    version     = "0.7.0";
    sources     = [{ filename = "mingw-w64-i686-libraqm-0.7.0-1-any.pkg.tar.xz"; sha256 = "34f31a4cfa8f1ca1d5cc6f9b2b56a4a34459553bae2b3c05d8b390d8ddd08830"; }];
    buildInputs = [ freetype glib2 harfbuzz fribidi ];
  };

  "libraw" = fetch {
    pname       = "libraw";
    version     = "0.20.2";
    sources     = [{ filename = "mingw-w64-i686-libraw-0.20.2-1-any.pkg.tar.zst"; sha256 = "6c30c9d6c8f384ad1292d0e778ff78b9ede2fbcefe4520bf29487982ef4cc141"; }];
    buildInputs = [ gcc-libs jasper lcms2 libjpeg zlib ];
  };

  "librdkafka" = fetch {
    pname       = "librdkafka";
    version     = "1.5.2";
    sources     = [{ filename = "mingw-w64-i686-librdkafka-1.5.2-1-any.pkg.tar.zst"; sha256 = "a096bd3c1cec2d30779465fe749222ad29c251c6656a0fd4624fd7b0c0177658"; }];
    buildInputs = [ cyrus-sasl lz4 openssl zlib zstd ];
  };

  "librescl" = fetch {
    pname       = "librescl";
    version     = "0.3.3";
    sources     = [{ filename = "mingw-w64-i686-librescl-0.3.3-1-any.pkg.tar.xz"; sha256 = "347c5cfd4d5dd1183e68495999804bd62e7170bc39287684ca26522aebad107c"; }];
    buildInputs = [ gcc-libs gettext (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.34.0"; glib2) gobject-introspection gxml libgee libxml2 vala xz zlib ];
  };

  "libressl" = fetch {
    pname       = "libressl";
    version     = "3.1.1";
    sources     = [{ filename = "mingw-w64-i686-libressl-3.1.1-1-any.pkg.tar.zst"; sha256 = "4a00313965392a46d81112a7323b627e516ad99a4a59585a31ba9564ad4eadef"; }];
    buildInputs = [ gcc-libs ];
  };

  "librest" = fetch {
    pname       = "librest";
    version     = "0.8.1";
    sources     = [{ filename = "mingw-w64-i686-librest-0.8.1-1-any.pkg.tar.xz"; sha256 = "d33bdb734d52d267433c772efba166c7b23a6d94406889f65108d3ebf930bf3c"; }];
    buildInputs = [ glib2 libsoup libxml2 ];
  };

  "librevenge" = fetch {
    pname       = "librevenge";
    version     = "0.0.4";
    sources     = [{ filename = "mingw-w64-i686-librevenge-0.0.4-2-any.pkg.tar.xz"; sha256 = "3508a3f5c6bd53476983fd66075e2b859da4cfb93020c67f7f8eae037eada5dd"; }];
    buildInputs = [ gcc-libs boost zlib ];
  };

  "librime" = fetch {
    pname       = "librime";
    version     = "1.5.3";
    sources     = [{ filename = "mingw-w64-i686-librime-1.5.3-2-any.pkg.tar.xz"; sha256 = "a4816fdb90d65d39bb7419805f782d0764e124d6385a71ff6e398c11c8037236"; }];
    buildInputs = [ boost leveldb marisa opencc yaml-cpp glog ];
  };

  "librime-data" = fetch {
    pname       = "librime-data";
    version     = "0.0.0.20190122";
    sources     = [{ filename = "mingw-w64-i686-librime-data-0.0.0.20190122-1-any.pkg.tar.xz"; sha256 = "91b74f8a332bedbf563a00b38f4f120959e5643bc033bb814c357ff271d9cc0d"; }];
    buildInputs = [ rime-bopomofo rime-cangjie rime-essay rime-luna-pinyin rime-prelude rime-stroke rime-terra-pinyin ];
  };

  "librsvg" = fetch {
    pname       = "librsvg";
    version     = "2.48.8";
    sources     = [{ filename = "mingw-w64-i686-librsvg-2.48.8-1-any.pkg.tar.zst"; sha256 = "020e6ef07e8342f69bd01d5ad162026a017d1e7da3c70a3f02bfb255d9758156"; }];
    buildInputs = [ gdk-pixbuf2 pango cairo libxml2 ];
  };

  "librsync" = fetch {
    pname       = "librsync";
    version     = "2.3.1";
    sources     = [{ filename = "mingw-w64-i686-librsync-2.3.1-1-any.pkg.tar.zst"; sha256 = "de538259ebb0bfd2d0f510f8038aed42202fa4232007d5d2cb2aa5f3760ffcbc"; }];
    buildInputs = [ gcc-libs popt ];
  };

  "libsamplerate" = fetch {
    pname       = "libsamplerate";
    version     = "0.1.9";
    sources     = [{ filename = "mingw-w64-i686-libsamplerate-0.1.9-1-any.pkg.tar.xz"; sha256 = "173b951f1ebed1ab5b99500d33913e2f43819a164d386cc894a00b2b43152137"; }];
    buildInputs = [ libsndfile fftw ];
  };

  "libsass" = fetch {
    pname       = "libsass";
    version     = "3.6.4";
    sources     = [{ filename = "mingw-w64-i686-libsass-3.6.4-1-any.pkg.tar.zst"; sha256 = "64aa19b82e124f3b21d13a433ef01203b852af9fe8b9e7c3e27c3c9ab3005c49"; }];
  };

  "libsbml" = fetch {
    pname       = "libsbml";
    version     = "5.18.0";
    sources     = [{ filename = "mingw-w64-i686-libsbml-5.18.0-1-any.pkg.tar.xz"; sha256 = "b61f97fd5036181b43c510fe057afa043639f5ea213bc666cba62423adb4ac90"; }];
    buildInputs = [ libxml2 ];
  };

  "libsecret" = fetch {
    pname       = "libsecret";
    version     = "0.20.4";
    sources     = [{ filename = "mingw-w64-i686-libsecret-0.20.4-1-any.pkg.tar.zst"; sha256 = "34e21d83d86743678935497045d675cf735c885fb43924d8e41c78a80972641b"; }];
    buildInputs = [ glib2 libgcrypt ];
  };

  "libshout" = fetch {
    pname       = "libshout";
    version     = "2.4.3";
    sources     = [{ filename = "mingw-w64-i686-libshout-2.4.3-1-any.pkg.tar.xz"; sha256 = "d17dc0da8953b7b1b9022dc155d52cda68aa4296fd9690752798bd3b0726b52d"; }];
    buildInputs = [ libvorbis libtheora openssl speex ];
  };

  "libsigc++" = fetch {
    pname       = "libsigc++";
    version     = "2.10.4";
    sources     = [{ filename = "mingw-w64-i686-libsigc++-2.10.4-1-any.pkg.tar.zst"; sha256 = "bb5e07e591e3cbaf5a377e536a05f087bcbff242f1254d1d7762175e3380a557"; }];
    buildInputs = [ gcc-libs ];
  };

  "libsigc++3" = fetch {
    pname       = "libsigc++3";
    version     = "3.0.3";
    sources     = [{ filename = "mingw-w64-i686-libsigc++3-3.0.3-1-any.pkg.tar.xz"; sha256 = "8529c951fed85557719f6dcf3a2a012df8092a85a4b5d1ec4c15d5cdb60982d7"; }];
    buildInputs = [ gcc-libs ];
  };

  "libsignal-protocol-c" = fetch {
    pname       = "libsignal-protocol-c";
    version     = "2.3.3";
    sources     = [{ filename = "mingw-w64-i686-libsignal-protocol-c-2.3.3-1-any.pkg.tar.zst"; sha256 = "ea44515401f8dc63cc80dc58afa44d386e91cf3189a72d34021fc4dc3f69ec75"; }];
  };

  "libsignal-protocol-c-git" = fetch {
    pname       = "libsignal-protocol-c-git";
    version     = "r34.16bfd04";
    sources     = [{ filename = "mingw-w64-i686-libsignal-protocol-c-git-r34.16bfd04-1-any.pkg.tar.xz"; sha256 = "fa17aa734fdc03e4b9a6fa89c2b76da55fb4a46728a99ca90f1ac9ecc5083702"; }];
  };

  "libsigsegv" = fetch {
    pname       = "libsigsegv";
    version     = "2.12";
    sources     = [{ filename = "mingw-w64-i686-libsigsegv-2.12-1-any.pkg.tar.xz"; sha256 = "d84885c2020d7a4ac66be912196cb2a244e7e27c1b48b9258954d5fbd29a03b7"; }];
    buildInputs = [  ];
  };

  "libslirp" = fetch {
    pname       = "libslirp";
    version     = "4.3.1";
    sources     = [{ filename = "mingw-w64-i686-libslirp-4.3.1-1-any.pkg.tar.zst"; sha256 = "368d1703c84aa8f10778a70bb9e9afd90bcc53c0caf9930b513ce62269ccc0a8"; }];
    buildInputs = [ glib2 ];
  };

  "libsndfile" = fetch {
    pname       = "libsndfile";
    version     = "1.0.30";
    sources     = [{ filename = "mingw-w64-i686-libsndfile-1.0.30-1-any.pkg.tar.zst"; sha256 = "b855cded1ac9538630ca57aab24841397e91364edc473000680830590ce6a979"; }];
    buildInputs = [ flac libogg libvorbis opus ];
  };

  "libsodium" = fetch {
    pname       = "libsodium";
    version     = "1.0.18";
    sources     = [{ filename = "mingw-w64-i686-libsodium-1.0.18-1-any.pkg.tar.xz"; sha256 = "9e4e3486497c4e511e71ddba73f0e19cbd61f5227b3bff3b0e7fb4dc3beb512e"; }];
    buildInputs = [ gcc-libs ];
  };

  "libsoup" = fetch {
    pname       = "libsoup";
    version     = "2.72.0";
    sources     = [{ filename = "mingw-w64-i686-libsoup-2.72.0-1-any.pkg.tar.zst"; sha256 = "2a4908e52a5c644e01778ba3b9a2148f45a7e4bbf61214b89095d8ee42c8de2f"; }];
    buildInputs = [ gcc-libs glib2 glib-networking libxml2 libpsl brotli sqlite3 ];
  };

  "libsoxr" = fetch {
    pname       = "libsoxr";
    version     = "0.1.3";
    sources     = [{ filename = "mingw-w64-i686-libsoxr-0.1.3-2-any.pkg.tar.zst"; sha256 = "6f3e09ed2a69415c6b2741cd9feb021164c4415b5ee343c7ff6f218570339d93"; }];
    buildInputs = [ gcc-libs ];
  };

  "libspatialite" = fetch {
    pname       = "libspatialite";
    version     = "4.3.0.a";
    sources     = [{ filename = "mingw-w64-i686-libspatialite-4.3.0.a-4-any.pkg.tar.xz"; sha256 = "033d5ffba77d4c5bda01c1c556485936ae937143ae53c8ac357d35bc7095f8ed"; }];
    buildInputs = [ geos libfreexl libxml2 proj sqlite3 libiconv ];
  };

  "libspectre" = fetch {
    pname       = "libspectre";
    version     = "0.2.8";
    sources     = [{ filename = "mingw-w64-i686-libspectre-0.2.8-2-any.pkg.tar.xz"; sha256 = "a0f0ad5bbce7198e7433582f806ffa1d293095f17927680a1952a222df40846f"; }];
    buildInputs = [ ghostscript cairo ];
  };

  "libspiro" = fetch {
    pname       = "libspiro";
    version     = "1~20200505";
    sources     = [{ filename = "mingw-w64-i686-libspiro-1~20200505-1-any.pkg.tar.zst"; sha256 = "6c8dbedc37d916c2695e4c5c91bfdd110e5609479fa23d39015b3cd90f5ad98e"; }];
    buildInputs = [  ];
  };

  "libsquish" = fetch {
    pname       = "libsquish";
    version     = "1.15";
    sources     = [{ filename = "mingw-w64-i686-libsquish-1.15-1-any.pkg.tar.xz"; sha256 = "36232d849895fa9c5cb04d5ddc2bf7ce422ae33f4fc542b1c99d8fed8d2ae27c"; }];
    buildInputs = [  ];
  };

  "libsrtp" = fetch {
    pname       = "libsrtp";
    version     = "2.3.0";
    sources     = [{ filename = "mingw-w64-i686-libsrtp-2.3.0-1-any.pkg.tar.xz"; sha256 = "f5e30cd465015cec191d219faa5fa883cfc5c58891d3fa9cd5db080a1b19397a"; }];
    buildInputs = [ openssl ];
  };

  "libssh" = fetch {
    pname       = "libssh";
    version     = "0.9.5";
    sources     = [{ filename = "mingw-w64-i686-libssh-0.9.5-1-any.pkg.tar.zst"; sha256 = "aa667fbc8649108d6e30d2d8d4774d6bbbe42e28d1d9efb4d9d48a0c99583caf"; }];
    buildInputs = [ openssl zlib ];
  };

  "libssh2" = fetch {
    pname       = "libssh2";
    version     = "1.9.0";
    sources     = [{ filename = "mingw-w64-i686-libssh2-1.9.0-2-any.pkg.tar.zst"; sha256 = "61db8a43bb314ebb110e7ff8c2ca2535cc9514d99e464f1585df05caef0ceae1"; }];
    buildInputs = [ openssl zlib ];
  };

  "libswift" = fetch {
    pname       = "libswift";
    version     = "1.0.0";
    sources     = [{ filename = "mingw-w64-i686-libswift-1.0.0-2-any.pkg.tar.xz"; sha256 = "0aa6a4d19fc4a674c948d17e19f57e96d37611dc5621c7971fc51f37ab7a185b"; }];
    buildInputs = [ gcc-libs bzip2 libiconv libpng freetype glfw zlib ];
  };

  "libsystre" = fetch {
    pname       = "libsystre";
    version     = "1.0.1";
    sources     = [{ filename = "mingw-w64-i686-libsystre-1.0.1-4-any.pkg.tar.xz"; sha256 = "3a400210f7f366c63d000d910203257643b4de1409d09d12da86e76acb4dd407"; }];
    buildInputs = [ libtre-git ];
  };

  "libtasn1" = fetch {
    pname       = "libtasn1";
    version     = "4.16.0";
    sources     = [{ filename = "mingw-w64-i686-libtasn1-4.16.0-1-any.pkg.tar.xz"; sha256 = "62ff113c03ff10b93763818cd603bfca50ad6f32b1ce3b1b0ccd1a51009b6384"; }];
    buildInputs = [ gcc-libs ];
  };

  "libthai" = fetch {
    pname       = "libthai";
    version     = "0.1.28";
    sources     = [{ filename = "mingw-w64-i686-libthai-0.1.28-2-any.pkg.tar.xz"; sha256 = "9ca5ce1b9eed1be47273623df8da6e7cb27eb321d328b27e32b5962c8c3ec285"; }];
    buildInputs = [ libdatrie ];
  };

  "libtheora" = fetch {
    pname       = "libtheora";
    version     = "1.1.1";
    sources     = [{ filename = "mingw-w64-i686-libtheora-1.1.1-4-any.pkg.tar.xz"; sha256 = "17fd504e293820cbb44e7553d53603fc5e3519e235f00505831b1a090ab984f4"; }];
    buildInputs = [ libpng libogg libvorbis ];
  };

  "libtiff" = fetch {
    pname       = "libtiff";
    version     = "4.1.0";
    sources     = [{ filename = "mingw-w64-i686-libtiff-4.1.0-1-any.pkg.tar.xz"; sha256 = "413afc0e82e103659a93558871ff59aa09b28b50ae72a413576b42a64e5ec01e"; }];
    buildInputs = [ gcc-libs libjpeg-turbo xz zlib zstd ];
  };

  "libtimidity" = fetch {
    pname       = "libtimidity";
    version     = "0.2.6";
    sources     = [{ filename = "mingw-w64-i686-libtimidity-0.2.6-1-any.pkg.tar.xz"; sha256 = "ce6de1d406715e26310ce342a60b946158dd73e6377e84ac30110111050402f0"; }];
    buildInputs = [ gcc-libs ];
  };

  "libtommath" = fetch {
    pname       = "libtommath";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-libtommath-1.2.0-1-any.pkg.tar.xz"; sha256 = "86fb5699cf0cd148f367a320e5e49d778d8239d6b00479410fcdf1b8a21b8439"; }];
  };

  "libtool" = fetch {
    pname       = "libtool";
    version     = "2.4.6";
    sources     = [{ filename = "mingw-w64-i686-libtool-2.4.6-18-any.pkg.tar.zst"; sha256 = "aec58f0c00b57d9d1316b743a36e67b4028712079feb75953c4636e4d36627ad"; }];
    buildInputs = [  ];
  };

  "libtorrent-rasterbar" = fetch {
    pname       = "libtorrent-rasterbar";
    version     = "1.2.10";
    sources     = [{ filename = "mingw-w64-i686-libtorrent-rasterbar-1.2.10-1-any.pkg.tar.zst"; sha256 = "535c2272c9172b4460f4344d7bcf4d1f2f7a9a8220abcbdba46171b1b8fad69d"; }];
    buildInputs = [ boost openssl ];
  };

  "libtre-git" = fetch {
    pname       = "libtre-git";
    version     = "r128.6fb7206";
    sources     = [{ filename = "mingw-w64-i686-libtre-git-r128.6fb7206-2-any.pkg.tar.xz"; sha256 = "cc8ec470688c20d7b6da4ccc5dbaa275edb20242a058041b3b62a1b795ab8048"; }];
    buildInputs = [ gcc-libs gettext ];
  };

  "libuninameslist" = fetch {
    pname       = "libuninameslist";
    version     = "20200413";
    sources     = [{ filename = "mingw-w64-i686-libuninameslist-20200413-1-any.pkg.tar.zst"; sha256 = "6899d6b6c4cc6aa00bae43dc6b2822c732d33712bbea72252a9c62a6f7ec666b"; }];
  };

  "libunistring" = fetch {
    pname       = "libunistring";
    version     = "0.9.10";
    sources     = [{ filename = "mingw-w64-i686-libunistring-0.9.10-2-any.pkg.tar.zst"; sha256 = "6131e6ae297f41fa443efb7ed1fb50c95b01b31602c2810c92b7b4187be6c51b"; }];
    buildInputs = [ libiconv ];
  };

  "libunwind" = fetch {
    pname       = "libunwind";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-libunwind-10.0.1-1-any.pkg.tar.zst"; sha256 = "1632ba88cee8e46d43532b37af7df4ebd1f346c371a422c39921a068c5901a95"; }];
    buildInputs = [ gcc ];
  };

  "libusb" = fetch {
    pname       = "libusb";
    version     = "1.0.23";
    sources     = [{ filename = "mingw-w64-i686-libusb-1.0.23-1-any.pkg.tar.xz"; sha256 = "b9b049c7b791bef7a74a921ae6eaa9eea0fadd31f2a3fcbc8a129091eb09eef1"; }];
    buildInputs = [  ];
  };

  "libusb-compat-git" = fetch {
    pname       = "libusb-compat-git";
    version     = "r76.b5db9d0";
    sources     = [{ filename = "mingw-w64-i686-libusb-compat-git-r76.b5db9d0-1-any.pkg.tar.xz"; sha256 = "8c1cc1fbdd89f2a5bee8a90571e49165d962416f59a5885df5050e326de23f4e"; }];
    buildInputs = [ libusb ];
  };

  "libusb-win32" = fetch {
    pname       = "libusb-win32";
    version     = "1.2.6.0";
    sources     = [{ filename = "mingw-w64-i686-libusb-win32-1.2.6.0-1-any.pkg.tar.zst"; sha256 = "a61a4cb25be75fb453a8adf67bcd979573b5f1a399f8895d33bea2d4f3cce1a5"; }];
    buildInputs = [  ];
  };

  "libusbmuxd" = fetch {
    pname       = "libusbmuxd";
    version     = "2.0.1";
    sources     = [{ filename = "mingw-w64-i686-libusbmuxd-2.0.1-1-any.pkg.tar.xz"; sha256 = "c2c8107f994d42c5e2d9c5a8e8cdf8dd77b9d2fd72f9531864bed3dd1171ab77"; }];
    buildInputs = [ libplist ];
  };

  "libutf8proc" = fetch {
    pname       = "libutf8proc";
    version     = "2.5.0";
    sources     = [{ filename = "mingw-w64-i686-libutf8proc-2.5.0-1-any.pkg.tar.zst"; sha256 = "408119f36dc10eb94b2beebc15f217abe35bc6ab039f7a5f18030f28cc6ac94d"; }];
    buildInputs = [  ];
  };

  "libuv" = fetch {
    pname       = "libuv";
    version     = "1.40.0";
    sources     = [{ filename = "mingw-w64-i686-libuv-1.40.0-1-any.pkg.tar.zst"; sha256 = "ed6c65bb89d88f870326cb99538fc71aaf90056f2d20e2b392ef9920c7ebee5f"; }];
    buildInputs = [ gcc-libs ];
  };

  "libview" = fetch {
    pname       = "libview";
    version     = "0.6.6";
    sources     = [{ filename = "mingw-w64-i686-libview-0.6.6-4-any.pkg.tar.xz"; sha256 = "0de7b3f1b77bf2ef42ef6790fa59299ef0753f1582f08896a54afbd72e2792ce"; }];
    buildInputs = [ gtk2 gtkmm ];
  };

  "libvips" = fetch {
    pname       = "libvips";
    version     = "8.10.2";
    sources     = [{ filename = "mingw-w64-i686-libvips-8.10.2-1-any.pkg.tar.zst"; sha256 = "0de016bfba34f7cf517ef0a7589ffa95e75e48b257af257acd162247b474056b"; }];
    buildInputs = [ cairo cfitsio fftw giflib glib2 gobject-introspection-runtime imagemagick lcms2 libexif libgsf libimagequant libpng librsvg libtiff libwebp matio opencl-icd-git openexr orc pango poppler ];
  };

  "libvirt" = fetch {
    pname       = "libvirt";
    version     = "5.9.0";
    sources     = [{ filename = "mingw-w64-i686-libvirt-5.9.0-1-any.pkg.tar.xz"; sha256 = "aa59abe884e40c7260f962a67d9978c1fe6b00c02b196b88c9e3fcca54b60574"; }];
    buildInputs = [ curl gnutls gettext libgcrypt libgpg-error libxml2 portablexdr ];
  };

  "libvirt-glib" = fetch {
    pname       = "libvirt-glib";
    version     = "3.0.0";
    sources     = [{ filename = "mingw-w64-i686-libvirt-glib-3.0.0-1-any.pkg.tar.xz"; sha256 = "a102c7e071f4cc69ccfd2bc364e3b1c339e0f2c132b439fbc8999717334d37d0"; }];
    buildInputs = [ glib2 libxml2 libvirt ];
  };

  "libvisio" = fetch {
    pname       = "libvisio";
    version     = "0.1.7";
    sources     = [{ filename = "mingw-w64-i686-libvisio-0.1.7-4-any.pkg.tar.zst"; sha256 = "61586354be1c192f9d347b5f4a22c446606998bed444e1a25d0f5fecada04ea4"; }];
    buildInputs = [ icu libxml2 librevenge ];
  };

  "libvmime-git" = fetch {
    pname       = "libvmime-git";
    version     = "r1183.fe5492ce";
    sources     = [{ filename = "mingw-w64-i686-libvmime-git-r1183.fe5492ce-2-any.pkg.tar.zst"; sha256 = "2bb521ba0e8407cf387bda8fb50ae5b688774121ee93b76fcdaf9dc809527ddb"; }];
    buildInputs = [ icu gnutls gsasl libiconv ];
  };

  "libvncserver" = fetch {
    pname       = "libvncserver";
    version     = "0.9.12";
    sources     = [{ filename = "mingw-w64-i686-libvncserver-0.9.12-1-any.pkg.tar.xz"; sha256 = "8aa40c68070982a4e55c8623850e64a8c0b931285cc0be5cb00af0b1e4c39031"; }];
    buildInputs = [ gcc-libs gnutls libpng libjpeg libgcrypt openssl ];
  };

  "libvoikko" = fetch {
    pname       = "libvoikko";
    version     = "4.3";
    sources     = [{ filename = "mingw-w64-i686-libvoikko-4.3-1-any.pkg.tar.xz"; sha256 = "12868a92d9ea95cffcda1ceefccf48b9523cef6484664e2d4dec68f6c7e758bc"; }];
    buildInputs = [ gcc-libs ];
  };

  "libvorbis" = fetch {
    pname       = "libvorbis";
    version     = "1.3.7";
    sources     = [{ filename = "mingw-w64-i686-libvorbis-1.3.7-1-any.pkg.tar.zst"; sha256 = "0c3b4ea265383469a60d1f4861ce31d8959c87b4397cc90c060329da698ea61f"; }];
    buildInputs = [ libogg gcc-libs ];
  };

  "libvorbisidec-svn" = fetch {
    pname       = "libvorbisidec-svn";
    version     = "r19643";
    sources     = [{ filename = "mingw-w64-i686-libvorbisidec-svn-r19643-1-any.pkg.tar.xz"; sha256 = "b53d7cbe5f94ae2588441156e6fbe9b974df484cb0f63d6653cd46e0b3be600f"; }];
    buildInputs = [ libogg ];
  };

  "libvpx" = fetch {
    pname       = "libvpx";
    version     = "1.9.0";
    sources     = [{ filename = "mingw-w64-i686-libvpx-1.9.0-1-any.pkg.tar.zst"; sha256 = "e27526b3f29e2345cc564661d3b9bf87594f726a2ae5be2b62092335f17f343d"; }];
    buildInputs = [  ];
  };

  "libwebp" = fetch {
    pname       = "libwebp";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-libwebp-1.1.0-1-any.pkg.tar.xz"; sha256 = "1047b9cf76f5ba7ddb4dcab043ba87acf9f748dec3af14e93fd3586013b5fed9"; }];
    buildInputs = [ giflib libjpeg-turbo libpng libtiff ];
  };

  "libwebsockets" = fetch {
    pname       = "libwebsockets";
    version     = "4.1.3";
    sources     = [{ filename = "mingw-w64-i686-libwebsockets-4.1.3-1-any.pkg.tar.zst"; sha256 = "9222ba60607b21659a60848830c07757065b5c35181b3979f20ed77e09f03456"; }];
    buildInputs = [ zlib openssl ];
  };

  "libwinpthread-git" = fetch {
    pname       = "libwinpthread-git";
    version     = "9.0.0.6029.ecb4ff54";
    sources     = [{ filename = "mingw-w64-i686-libwinpthread-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "a188c97095adb0307ffa43ce9e480b28a1fb3fb60452b422224b2a2dd9ad9818"; }];
    buildInputs = [  ];
  };

  "libwmf" = fetch {
    pname       = "libwmf";
    version     = "0.2.12";
    sources     = [{ filename = "mingw-w64-i686-libwmf-0.2.12-2-any.pkg.tar.zst"; sha256 = "039da6b07eb0c744ee0a6473ee5e9b2b9fcfbc89aa6e32509ddf2a3025fc69b4"; }];
    buildInputs = [ gcc-libs freetype gdk-pixbuf2 libjpeg libpng libxml2 zlib ];
  };

  "libwpd" = fetch {
    pname       = "libwpd";
    version     = "0.10.3";
    sources     = [{ filename = "mingw-w64-i686-libwpd-0.10.3-1-any.pkg.tar.xz"; sha256 = "cdb8c9bae3bd6b94268f78b402f3f3475f7029cddc747444b54aa5f8aeb31328"; }];
    buildInputs = [ gcc-libs librevenge xz zlib ];
  };

  "libwpg" = fetch {
    pname       = "libwpg";
    version     = "0.3.3";
    sources     = [{ filename = "mingw-w64-i686-libwpg-0.3.3-1-any.pkg.tar.xz"; sha256 = "025fc1d9f19a8f0f2ba2ff8490804a3d95d0e5a256a081271673494586915998"; }];
    buildInputs = [ gcc-libs librevenge libwpd ];
  };

  "libxlsxwriter" = fetch {
    pname       = "libxlsxwriter";
    version     = "1.0.0";
    sources     = [{ filename = "mingw-w64-i686-libxlsxwriter-1.0.0-1-any.pkg.tar.zst"; sha256 = "33ad35716a3aa451ea91764097adeb1b1fe5fc6bc49f4d85f0c9ff7959580da7"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "libxml++" = fetch {
    pname       = "libxml++";
    version     = "3.2.2";
    sources     = [{ filename = "mingw-w64-i686-libxml++-3.2.2-1-any.pkg.tar.zst"; sha256 = "dea8fe204ac2a21c35a75c9698e4ce2c73549c804965d5217a11eb582dc611ee"; }];
    buildInputs = [ gcc-libs libxml2 glibmm ];
  };

  "libxml++2.6" = fetch {
    pname       = "libxml++2.6";
    version     = "2.42.0";
    sources     = [{ filename = "mingw-w64-i686-libxml++2.6-2.42.0-1-any.pkg.tar.zst"; sha256 = "981e0b3ae3a1a735d0f1ea38c52a8e3c42dcfbe6c719df0fe10404072aaed5a0"; }];
    buildInputs = [ gcc-libs libxml2 glibmm ];
  };

  "libxml2" = fetch {
    pname       = "libxml2";
    version     = "2.9.10";
    sources     = [{ filename = "mingw-w64-i686-libxml2-2.9.10-4-any.pkg.tar.zst"; sha256 = "e2fe9510494756fb84d4fa1969d6daeb6fdcc4bd4331c80fd2b81c665c4bbd27"; }];
    buildInputs = [ gcc-libs gettext xz zlib ];
  };

  "libxslt" = fetch {
    pname       = "libxslt";
    version     = "1.1.34";
    sources     = [{ filename = "mingw-w64-i686-libxslt-1.1.34-2-any.pkg.tar.xz"; sha256 = "bc281621e0a73787eadf5ea528742c260d1d6feb74b8cf45a0e13d61a295d27d"; }];
    buildInputs = [ gcc-libs libxml2 libgcrypt ];
  };

  "libyaml" = fetch {
    pname       = "libyaml";
    version     = "0.2.5";
    sources     = [{ filename = "mingw-w64-i686-libyaml-0.2.5-1-any.pkg.tar.zst"; sha256 = "022a9716e5ca7962df9c03151f2ae5595a526ba69f8b4651b1445107ca9876a3"; }];
    buildInputs = [  ];
  };

  "libyuv-git" = fetch {
    pname       = "libyuv-git";
    version     = "1724.r7ce50764";
    sources     = [{ filename = "mingw-w64-i686-libyuv-git-1724.r7ce50764-1-any.pkg.tar.xz"; sha256 = "c7424a850550bcf9e2da21dee96bef9339c2118cf84f82c79bdab8d1817ebdcb"; }];
  };

  "libzip" = fetch {
    pname       = "libzip";
    version     = "1.7.3";
    sources     = [{ filename = "mingw-w64-i686-libzip-1.7.3-1-any.pkg.tar.zst"; sha256 = "52a4c81537577a05bd6ec61d7b17ab84aa8acfa6209421b4815f8d06e44ba07e"; }];
    buildInputs = [ bzip2 gnutls nettle xz zlib ];
  };

  "live-chart-gtk3" = fetch {
    pname       = "live-chart-gtk3";
    version     = "1.6.1";
    sources     = [{ filename = "mingw-w64-i686-live-chart-gtk3-1.6.1-1-any.pkg.tar.zst"; sha256 = "5246a5379a5288d0152e3d5ee0cebd1567bd5eda2ef2c39cc1d220cc82de47ec"; }];
    buildInputs = [ glib2 gtk3 libgee ];
  };

  "live-media" = fetch {
    pname       = "live-media";
    version     = "2019.11.06";
    sources     = [{ filename = "mingw-w64-i686-live-media-2019.11.06-1-any.pkg.tar.xz"; sha256 = "64d48a3b2fd1134f3ae93211d1c1bed4b70ed346579153afe181fee94edea4b7"; }];
    buildInputs = [ gcc ];
  };

  "lld" = fetch {
    pname       = "lld";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-lld-10.0.1-1-any.pkg.tar.zst"; sha256 = "b8087d40de37489f1e3bbebb16de9fd3486742c3be8281de1e5fae261bffb94f"; }];
    buildInputs = [ gcc ];
  };

  "lldb" = fetch {
    pname       = "lldb";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-lldb-10.0.1-1-any.pkg.tar.zst"; sha256 = "8e8895892d11a530c5e357495c1362e92ff32dfdbc05ee1719acf4fc94ef7756"; }];
    buildInputs = [ libxml2 llvm lua python readline swig ];
  };

  "llvm" = fetch {
    pname       = "llvm";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-llvm-10.0.1-1-any.pkg.tar.zst"; sha256 = "5d91fbd7132caddbcc2e0b3994e23773494b08d3ae33f0115dfd5b8c20fa6940"; }];
    buildInputs = [ libffi z3 gcc-libs ];
  };

  "lmdb" = fetch {
    pname       = "lmdb";
    version     = "0.9.26";
    sources     = [{ filename = "mingw-w64-i686-lmdb-0.9.26-1-any.pkg.tar.zst"; sha256 = "286022e6f4e7db2b507ca72fa33c5e2d3c65fa4cee8c6ceb0b1094c9aca09447"; }];
  };

  "lmdbxx" = fetch {
    pname       = "lmdbxx";
    version     = "0.9.14.0";
    sources     = [{ filename = "mingw-w64-i686-lmdbxx-0.9.14.0-1-any.pkg.tar.xz"; sha256 = "0512366ec19fb39cee7c2c10b86329e7f2f8a2af7e7c0f31404a6a228d35f5e0"; }];
    buildInputs = [ lmdb ];
  };

  "lpsolve" = fetch {
    pname       = "lpsolve";
    version     = "5.5.2.5";
    sources     = [{ filename = "mingw-w64-i686-lpsolve-5.5.2.5-2-any.pkg.tar.xz"; sha256 = "21d6bcdc0f69f33b023822ff4581f797d9a5e02b21ba58475f5db2145cec9275"; }];
    buildInputs = [ gcc-libs ];
  };

  "lua" = fetch {
    pname       = "lua";
    version     = "5.3.5";
    sources     = [{ filename = "mingw-w64-i686-lua-5.3.5-1-any.pkg.tar.xz"; sha256 = "82d788d66635151fb64a695daae79b536c99c51a7e37cf96d5bf332dd5d18016"; }];
    buildInputs = [ winpty ];
  };

  "lua-lpeg" = fetch {
    pname       = "lua-lpeg";
    version     = "1.0.2";
    sources     = [{ filename = "mingw-w64-i686-lua-lpeg-1.0.2-1-any.pkg.tar.xz"; sha256 = "2ad967482c40705e55baa6e4fec33c1b3563c034d2f1b7efcd9385bc4b66a909"; }];
    buildInputs = [ lua ];
  };

  "lua-mpack" = fetch {
    pname       = "lua-mpack";
    version     = "1.0.8";
    sources     = [{ filename = "mingw-w64-i686-lua-mpack-1.0.8-1-any.pkg.tar.xz"; sha256 = "6f835d025a647906c67e7c30b925046f118d2a72ad0043baa52692426b1d7b31"; }];
    buildInputs = [ lua libmpack ];
  };

  "lua51" = fetch {
    pname       = "lua51";
    version     = "5.1.5";
    sources     = [{ filename = "mingw-w64-i686-lua51-5.1.5-4-any.pkg.tar.xz"; sha256 = "40ff1207db193d5d987c40ea95a354296c9fd30bc03690b0419dbf1f52533fde"; }];
    buildInputs = [ winpty ];
  };

  "lua51-bitop" = fetch {
    pname       = "lua51-bitop";
    version     = "1.0.2";
    sources     = [{ filename = "mingw-w64-i686-lua51-bitop-1.0.2-1-any.pkg.tar.zst"; sha256 = "aac7f2a764feb35bc59856e624999b5b31bffabff8db7654f7e4ae3e09cf1822"; }];
    buildInputs = [ lua51 ];
  };

  "lua51-lgi" = fetch {
    pname       = "lua51-lgi";
    version     = "0.9.2";
    sources     = [{ filename = "mingw-w64-i686-lua51-lgi-0.9.2-1-any.pkg.tar.xz"; sha256 = "9b2f481dda6aa3b44f07313bf9b040620d7f0893254ada1d6976a26496f3cee8"; }];
    buildInputs = [ lua51 gtk3 gobject-introspection ];
  };

  "lua51-lpeg" = fetch {
    pname       = "lua51-lpeg";
    version     = "1.0.2";
    sources     = [{ filename = "mingw-w64-i686-lua51-lpeg-1.0.2-1-any.pkg.tar.xz"; sha256 = "009d89ce7bbd1b54adae4932cf5da622325413014a97390c8a72bd3f4089dd8d"; }];
    buildInputs = [ lua51 ];
  };

  "lua51-lsqlite3" = fetch {
    pname       = "lua51-lsqlite3";
    version     = "0.9.3";
    sources     = [{ filename = "mingw-w64-i686-lua51-lsqlite3-0.9.3-1-any.pkg.tar.xz"; sha256 = "e73afc881b036ef2dbe305c5071c5a9b3766af6bcc615287bfe40a287cc7f725"; }];
    buildInputs = [ lua51 sqlite3 ];
  };

  "lua51-luarocks" = fetch {
    pname       = "lua51-luarocks";
    version     = "2.4.4";
    sources     = [{ filename = "mingw-w64-i686-lua51-luarocks-2.4.4-2-any.pkg.tar.zst"; sha256 = "967e3987539e74bcbef83a6430272fff90c81b283ce4397c1e1efa0c29f6d66d"; }];
    buildInputs = [ lua51 ];
  };

  "lua51-mpack" = fetch {
    pname       = "lua51-mpack";
    version     = "1.0.8";
    sources     = [{ filename = "mingw-w64-i686-lua51-mpack-1.0.8-1-any.pkg.tar.xz"; sha256 = "60ca624ade03d0b6bd13314212fe1912547c5fdfdb0d950e459cd75ba0bdb5f2"; }];
    buildInputs = [ lua51 libmpack ];
  };

  "lua51-winapi" = fetch {
    pname       = "lua51-winapi";
    version     = "1.4.2";
    sources     = [{ filename = "mingw-w64-i686-lua51-winapi-1.4.2-1-any.pkg.tar.xz"; sha256 = "9dfd4e98949ad4bd834b7d0891ef12f0e5292bcf0e28b1998c9f0dade046d772"; }];
    buildInputs = [ lua51 ];
  };

  "luabind-git" = fetch {
    pname       = "luabind-git";
    version     = "0.9.1.144.ge414c57";
    sources     = [{ filename = "mingw-w64-i686-luabind-git-0.9.1.144.ge414c57-1-any.pkg.tar.xz"; sha256 = "f7462af4008040fc686d5b8e4a1f81ac0fd15e5608b02bf157eb23ac02d7883b"; }];
    buildInputs = [ boost lua51 ];
  };

  "luajit" = fetch {
    pname       = "luajit";
    version     = "2.1.0_beta3";
    sources     = [{ filename = "mingw-w64-i686-luajit-2.1.0_beta3-1-any.pkg.tar.zst"; sha256 = "a7c679a7ed19f8b84bdf20a57fa4c89afa8524d5aeb4211b824c55746a7c8b07"; }];
    buildInputs = [ winpty ];
  };

  "lz4" = fetch {
    pname       = "lz4";
    version     = "1.9.2";
    sources     = [{ filename = "mingw-w64-i686-lz4-1.9.2-1-any.pkg.tar.xz"; sha256 = "6f8375356388aa6833530fd97b63d39cf54c92e0ea38d7729244bd06588dd3a8"; }];
    buildInputs = [ gcc-libs ];
  };

  "lzo2" = fetch {
    pname       = "lzo2";
    version     = "2.10";
    sources     = [{ filename = "mingw-w64-i686-lzo2-2.10-1-any.pkg.tar.xz"; sha256 = "767a867762fd70c47d60fe8b97bdc17b65b77b05efd7ef66747f496b04694498"; }];
    buildInputs = [  ];
  };

  "m2r" = fetch {
    pname       = "m2r";
    version     = "0.2.1";
    sources     = [{ filename = "mingw-w64-i686-m2r-0.2.1-1-any.pkg.tar.zst"; sha256 = "299636e1695d9ab587af5085b3089ecf5174f0dba0f03699b47da7cd75f4d468"; }];
    buildInputs = [ python-docutils python-mistune ];
  };

  "magnum" = fetch {
    pname       = "magnum";
    version     = "2020.06";
    sources     = [{ filename = "mingw-w64-i686-magnum-2020.06-1-any.pkg.tar.zst"; sha256 = "8f5dd63ae7e0e68a4c6ec5d7112bb99077763f5d1e022bd071b8c5b329bc2a11"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast corrade.version "2020.06"; corrade) openal SDL2 glfw vulkan-loader ];
  };

  "magnum-integration" = fetch {
    pname       = "magnum-integration";
    version     = "2020.06";
    sources     = [{ filename = "mingw-w64-i686-magnum-integration-2020.06-1-any.pkg.tar.zst"; sha256 = "725a7a27bde7aab944c2abea0fe0d5397dc34891c38ccbeeace9575c76bc6f64"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast magnum.version "2020.06"; magnum) bullet eigen3 glm ];
  };

  "magnum-plugins" = fetch {
    pname       = "magnum-plugins";
    version     = "2020.06";
    sources     = [{ filename = "mingw-w64-i686-magnum-plugins-2020.06-1-any.pkg.tar.zst"; sha256 = "fac9d547a12e7a2563a09e8675dc3a32673921005852ffc13f782eb1511c161c"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast magnum.version "2020.06"; magnum) assimp devil faad2 freetype harfbuzz libjpeg-turbo libpng ];
  };

  "make" = fetch {
    pname       = "make";
    version     = "4.3";
    sources     = [{ filename = "mingw-w64-i686-make-4.3-1-any.pkg.tar.xz"; sha256 = "49a9bd81fe265fd969618f9ffee9926a92193cc86d409cb1988f35a4dad3fe79"; }];
    buildInputs = [ gettext ];
  };

  "marisa" = fetch {
    pname       = "marisa";
    version     = "0.2.6";
    sources     = [{ filename = "mingw-w64-i686-marisa-0.2.6-1-any.pkg.tar.zst"; sha256 = "ef5bd4b4a84ba9d4be01a4aa11155cf175aa19f49d20c30c1800cbab6cb57ffb"; }];
    buildInputs = [  ];
  };

  "mathgl" = fetch {
    pname       = "mathgl";
    version     = "2.4.4";
    sources     = [{ filename = "mingw-w64-i686-mathgl-2.4.4-1-any.pkg.tar.xz"; sha256 = "a774baa0e7a9218e278eb0f57a6960a37d9b1131c7eda01b1e4c44d021a4ee8a"; }];
    buildInputs = [ hdf5 fltk libharu libjpeg-turbo libpng giflib qt5 freeglut wxWidgets ];
  };

  "matio" = fetch {
    pname       = "matio";
    version     = "1.5.17";
    sources     = [{ filename = "mingw-w64-i686-matio-1.5.17-2-any.pkg.tar.zst"; sha256 = "488cf1ada3966c74a68d199f2f1607bca3eecc9524261db01c44003485ec854a"; }];
    buildInputs = [ gcc-libs zlib hdf5 ];
  };

  "mbedtls" = fetch {
    pname       = "mbedtls";
    version     = "2.16.5";
    sources     = [{ filename = "mingw-w64-i686-mbedtls-2.16.5-1-any.pkg.tar.xz"; sha256 = "61e6828f4f8bc4404f4f82636505190a47fd728aa210b1a7940cd74d19ebc221"; }];
    buildInputs = [ gcc-libs ];
  };

  "mcpp" = fetch {
    pname       = "mcpp";
    version     = "2.7.2";
    sources     = [{ filename = "mingw-w64-i686-mcpp-2.7.2-2-any.pkg.tar.xz"; sha256 = "9392590dcd5db6dc6831aca47735d0acacb901f6a65c9a7f4fe5dfee2131b3b3"; }];
    buildInputs = [ gcc-libs libiconv ];
  };

  "md4c" = fetch {
    pname       = "md4c";
    version     = "0.3.4";
    sources     = [{ filename = "mingw-w64-i686-md4c-0.3.4-2-any.pkg.tar.zst"; sha256 = "ee0155e715b3f4c2a7b0f0f3e9da63fbc016dc1659e09cdac19b7918faaffddb"; }];
  };

  "mdloader" = fetch {
    pname       = "mdloader";
    version     = "1.0.4";
    sources     = [{ filename = "mingw-w64-i686-mdloader-1.0.4-1-any.pkg.tar.zst"; sha256 = "aff40650915902074f1ba79e27f7b909d369f54ad6467fe7d4e2b2c36f772557"; }];
  };

  "meanwhile" = fetch {
    pname       = "meanwhile";
    version     = "1.0.2";
    sources     = [{ filename = "mingw-w64-i686-meanwhile-1.0.2-4-any.pkg.tar.xz"; sha256 = "49dda3e64b2f584ae60a4a1b29e4214704e8791243bf2223aae1497377d78eb9"; }];
    buildInputs = [ glib2 ];
  };

  "mecab" = fetch {
    pname       = "mecab";
    version     = "0.996";
    sources     = [{ filename = "mingw-w64-i686-mecab-0.996-2-any.pkg.tar.xz"; sha256 = "ec31dbe714e9d797628e8fc828e36b46f363aa616b627230a37e6191e059cc6b"; }];
    buildInputs = [ libiconv ];
  };

  "mecab-naist-jdic" = fetch {
    pname       = "mecab-naist-jdic";
    version     = "0.6.3b_20111013";
    sources     = [{ filename = "mingw-w64-i686-mecab-naist-jdic-0.6.3b_20111013-1-any.pkg.tar.xz"; sha256 = "69e7fc75e91d2fd558e6a9d81f19e66dab469a99b03c97356314ab9104bbb471"; }];
    buildInputs = [ mecab ];
  };

  "meld3" = fetch {
    pname       = "meld3";
    version     = "3.21.0";
    sources     = [{ filename = "mingw-w64-i686-meld3-3.21.0-2-any.pkg.tar.xz"; sha256 = "4a888cd814a460a9413730bb22ce7b3314710ab316a8df4eaea87255674cb440"; }];
    buildInputs = [ gtk3 gtksourceview4 adwaita-icon-theme gsettings-desktop-schemas python-gobject ];
  };

  "memphis" = fetch {
    pname       = "memphis";
    version     = "0.2.3";
    sources     = [{ filename = "mingw-w64-i686-memphis-0.2.3-4-any.pkg.tar.xz"; sha256 = "5ad740e1d854774989d79a9333c3d3b85e0ceed1b643d40c815690e18dd56339"; }];
    buildInputs = [ glib2 cairo expat ];
  };

  "mesa" = fetch {
    pname       = "mesa";
    version     = "20.2.0";
    sources     = [{ filename = "mingw-w64-i686-mesa-20.2.0-1-any.pkg.tar.zst"; sha256 = "5a8318d730f28a113ce8d7ae50714284545bec11f3920cb99a40ada831e3d1fa"; }];
    buildInputs = [ zlib ];
  };

  "meson" = fetch {
    pname       = "meson";
    version     = "0.55.3";
    sources     = [{ filename = "mingw-w64-i686-meson-0.55.3-1-any.pkg.tar.zst"; sha256 = "d4e9cc022f772d5a4d050392ede406ebc55562883916fd3f0dbbfd7580833387"; }];
    buildInputs = [ python python-setuptools ninja ];
  };

  "metis" = fetch {
    pname       = "metis";
    version     = "5.1.0";
    sources     = [{ filename = "mingw-w64-i686-metis-5.1.0-3-any.pkg.tar.xz"; sha256 = "ee942780dcac7c09de78d30441ddc5c72607a148d37d3b2b434b107f9b4421b0"; }];
    buildInputs = [  ];
  };

  "mhook" = fetch {
    pname       = "mhook";
    version     = "r7.a159eed";
    sources     = [{ filename = "mingw-w64-i686-mhook-r7.a159eed-1-any.pkg.tar.xz"; sha256 = "860147a8a8e216ff3fee1f9afe6f285334164e8db8770bb2c95235042fdc79e9"; }];
    buildInputs = [ gcc-libs ];
  };

  "minisign" = fetch {
    pname       = "minisign";
    version     = "0.9";
    sources     = [{ filename = "mingw-w64-i686-minisign-0.9-1-any.pkg.tar.zst"; sha256 = "8d0ef0038c22058bc6ea7ea32f82ec8f0e7b3e122c518ad78ea89cf664e09b7c"; }];
    buildInputs = [ libsodium ];
  };

  "miniupnpc" = fetch {
    pname       = "miniupnpc";
    version     = "2.1.20201016";
    sources     = [{ filename = "mingw-w64-i686-miniupnpc-2.1.20201016-1-any.pkg.tar.zst"; sha256 = "241e73762e6978486fd8d0f72cef90b3500b36f1cd0ce45b834472ce73d0a345"; }];
    buildInputs = [ gcc-libs ];
  };

  "minizip-git" = fetch {
    pname       = "minizip-git";
    version     = "1.2.445.e67b996";
    sources     = [{ filename = "mingw-w64-i686-minizip-git-1.2.445.e67b996-1-any.pkg.tar.xz"; sha256 = "ecbd9f2e61397c1e8162bb8d1c1921f6d50f7c85f268ae5c778c6213ae186028"; }];
    buildInputs = [ bzip2 zlib ];
  };

  "minizip2" = fetch {
    pname       = "minizip2";
    version     = "2.7.0";
    sources     = [{ filename = "mingw-w64-i686-minizip2-2.7.0-1-any.pkg.tar.xz"; sha256 = "0fa32c42b7672dd1f58f43215382854e5fc813d0175ad3135dd42066bbe09144"; }];
    buildInputs = [ bzip2 gcc-libs zlib ];
  };

  "mlpack" = fetch {
    pname       = "mlpack";
    version     = "1.0.12";
    sources     = [{ filename = "mingw-w64-i686-mlpack-1.0.12-2-any.pkg.tar.xz"; sha256 = "782615ac87eb0280b5d6bf4b0aed79d69112e68d86e027897f40b5ec7763aa59"; }];
    buildInputs = [ gcc-libs armadillo boost libxml2 ];
  };

  "mlt" = fetch {
    pname       = "mlt";
    version     = "6.22.1";
    sources     = [{ filename = "mingw-w64-i686-mlt-6.22.1-1-any.pkg.tar.zst"; sha256 = "f1427577eeec40ac56e627bf22e33059f2cf005ea18e0a6604b7d5c1b54eb17e"; }];
    buildInputs = [ SDL2 fftw ffmpeg gdk-pixbuf2 ];
  };

  "mono" = fetch {
    pname       = "mono";
    version     = "6.4.0.198";
    sources     = [{ filename = "mingw-w64-i686-mono-6.4.0.198-1-any.pkg.tar.xz"; sha256 = "1785d28d61d155bd82c522739edbb1bc5ee588b22fd5c0834143e727ba1f69a8"; }];
    buildInputs = [ zlib gcc-libs winpthreads-git libgdiplus python3 ca-certificates ];
  };

  "mono-basic" = fetch {
    pname       = "mono-basic";
    version     = "4.8";
    sources     = [{ filename = "mingw-w64-i686-mono-basic-4.8-1-any.pkg.tar.xz"; sha256 = "e296963ae79d29409eff2f664ca4febf8c2ab8d2befb489787055e5759c858ae"; }];
    buildInputs = [ mono ];
  };

  "mpc" = fetch {
    pname       = "mpc";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-mpc-1.2.0-2-any.pkg.tar.zst"; sha256 = "ec89c758738f16b2c4714312fa7526d4d976c2d6cfb9d1c1409aeeaf9716787d"; }];
    buildInputs = [ mpfr ];
  };

  "mpdecimal" = fetch {
    pname       = "mpdecimal";
    version     = "2.5.0";
    sources     = [{ filename = "mingw-w64-i686-mpdecimal-2.5.0-1-any.pkg.tar.zst"; sha256 = "c5cedc37b27610b787fe6d04792bfe1a59848cb6e5118aea263535f7ba11f134"; }];
    buildInputs = [ gcc-libs ];
  };

  "mpfr" = fetch {
    pname       = "mpfr";
    version     = "4.1.0";
    sources     = [{ filename = "mingw-w64-i686-mpfr-4.1.0-3-any.pkg.tar.zst"; sha256 = "2033edc7cf042e24b01bb88f31df5b0bdb96f3d539037e5b4e7a196f55ee4c25"; }];
    buildInputs = [ gmp ];
  };

  "mpg123" = fetch {
    pname       = "mpg123";
    version     = "1.26.3";
    sources     = [{ filename = "mingw-w64-i686-mpg123-1.26.3-1-any.pkg.tar.zst"; sha256 = "3750f4342d7e1a5f283ca90292b6cfbb097ed1535067bc756578a834c94b0329"; }];
    buildInputs = [ libtool gcc-libs ];
  };

  "mpv" = fetch {
    pname       = "mpv";
    version     = "0.32.0";
    sources     = [{ filename = "mingw-w64-i686-mpv-0.32.0-3-any.pkg.tar.zst"; sha256 = "f87a916c881adc003a37a2277525b0096df612052370edb2069151ac65cc6493"; }];
    buildInputs = [ ffmpeg lcms2 libarchive libass libbluray libcaca libcdio libcdio-paranoia libdvdnav libdvdread libjpeg-turbo libplacebo lua51 pkg-config rubberband uchardet vapoursynth vulkan winpty ];
  };

  "mruby" = fetch {
    pname       = "mruby";
    version     = "2.1.0";
    sources     = [{ filename = "mingw-w64-i686-mruby-2.1.0-1-any.pkg.tar.xz"; sha256 = "60fb48b9b967ceac6fa56f5a4585445f0f03bb8d041225cdb4a5d4c5c3f5b02b"; }];
  };

  "mscgen" = fetch {
    pname       = "mscgen";
    version     = "0.20";
    sources     = [{ filename = "mingw-w64-i686-mscgen-0.20-1-any.pkg.tar.xz"; sha256 = "b87275ec63764e103fe61d808f7a71338b51bdda4c77039cee2c6739ee9f3ed0"; }];
    buildInputs = [ libgd ];
  };

  "msgpack-c" = fetch {
    pname       = "msgpack-c";
    version     = "3.3.0";
    sources     = [{ filename = "mingw-w64-i686-msgpack-c-3.3.0-1-any.pkg.tar.zst"; sha256 = "91651178c23a77295dd2d140961f3fa7406806e46873ff04672f24a892a05c6c"; }];
  };

  "msmpi" = fetch {
    pname       = "msmpi";
    version     = "10.1.1";
    sources     = [{ filename = "mingw-w64-i686-msmpi-10.1.1-2-any.pkg.tar.zst"; sha256 = "ced28102ad8a7d31d2e6891d96681eb2a2e7663c82e39fe3535329ea2623ace3"; }];
    buildInputs = [ gcc gcc-fortran ];
  };

  "msmtp" = fetch {
    pname       = "msmtp";
    version     = "1.8.11";
    sources     = [{ filename = "mingw-w64-i686-msmtp-1.8.11-1-any.pkg.tar.zst"; sha256 = "cfbd24888b7d9b1d7936dba23f56c6b2c962a5f932198fd77ea50ee0a4f014ad"; }];
    buildInputs = [ gettext gnutls gsasl libffi libidn libwinpthread-git ];
  };

  "mtex2MML" = fetch {
    pname       = "mtex2MML";
    version     = "1.3.1";
    sources     = [{ filename = "mingw-w64-i686-mtex2MML-1.3.1-2-any.pkg.tar.xz"; sha256 = "f778a8f6b69e9f7abf66785bfc7e15dfc34ed8dc6e800c80125abf967184b18a"; }];
  };

  "mumps" = fetch {
    pname       = "mumps";
    version     = "5.3.4";
    sources     = [{ filename = "mingw-w64-i686-mumps-5.3.4-1-any.pkg.tar.zst"; sha256 = "162efeba6040e1b7292ab0eeed940fdd2686f7e9191a19c342eceac4dc0cad88"; }];
    buildInputs = [ gcc-libs gcc-libgfortran openblas metis parmetis scotch scalapack msmpi ];
  };

  "muparser" = fetch {
    pname       = "muparser";
    version     = "2.3.2";
    sources     = [{ filename = "mingw-w64-i686-muparser-2.3.2-1-any.pkg.tar.zst"; sha256 = "f284205cad2687bb279df25e7481e448bf969ece0115b2e6b16b6c3574e1b735"; }];
  };

  "mypaint" = fetch {
    pname       = "mypaint";
    version     = "2.0.0";
    sources     = [{ filename = "mingw-w64-i686-mypaint-2.0.0-2-any.pkg.tar.zst"; sha256 = "edc38abb4d0db3241195164f162b680dd17e692f57a0d224e441aef1a14daa1e"; }];
    buildInputs = [ adwaita-icon-theme gcc-libs gsettings-desktop-schemas gtk3 hicolor-icon-theme json-c lcms2 libmypaint librsvg mypaint-brushes2 python-cairo python-gobject python-numpy ];
  };

  "mypaint-brushes" = fetch {
    pname       = "mypaint-brushes";
    version     = "1.3.1";
    sources     = [{ filename = "mingw-w64-i686-mypaint-brushes-1.3.1-1-any.pkg.tar.xz"; sha256 = "7192a415e966a8ac2a08da6ea6b208875524562749eeb142deefa275b2a2887d"; }];
    buildInputs = [ libmypaint ];
  };

  "mypaint-brushes2" = fetch {
    pname       = "mypaint-brushes2";
    version     = "2.0.2";
    sources     = [{ filename = "mingw-w64-i686-mypaint-brushes2-2.0.2-1-any.pkg.tar.xz"; sha256 = "e0dcc263072251586e52b283be1e9da3a5fd5f86b650064625cc3870470f8ec9"; }];
    buildInputs = [  ];
  };

  "nana" = fetch {
    pname       = "nana";
    version     = "1.7.4";
    sources     = [{ filename = "mingw-w64-i686-nana-1.7.4-1-any.pkg.tar.zst"; sha256 = "15319e8ff1795f43e2691d1d5844e04f78c12f9b85fe862e248a9f4b3c5dcd59"; }];
    buildInputs = [ libpng libjpeg-turbo ];
  };

  "nanodbc" = fetch {
    pname       = "nanodbc";
    version     = "2.12.4";
    sources     = [{ filename = "mingw-w64-i686-nanodbc-2.12.4-2-any.pkg.tar.xz"; sha256 = "5046e4b99438d4fea34b7f2aeb7d57083ec83bd55e8a9575198eec9e1da0bea3"; }];
  };

  "nanovg-git" = fetch {
    pname       = "nanovg-git";
    version     = "r259.6ae0873";
    sources     = [{ filename = "mingw-w64-i686-nanovg-git-r259.6ae0873-1-any.pkg.tar.xz"; sha256 = "3e3a9c1bb742531cb17f36a0ae76d0eb657af0eef2b4811894c632c92f83ea7f"; }];
  };

  "nasm" = fetch {
    pname       = "nasm";
    version     = "2.15.05";
    sources     = [{ filename = "mingw-w64-i686-nasm-2.15.05-1-any.pkg.tar.zst"; sha256 = "384ab264b7863c15c0cf20bb93d6cd50f459d6cc3799d504cb5014e654b44ed9"; }];
  };

  "ncurses" = fetch {
    pname       = "ncurses";
    version     = "6.2";
    sources     = [{ filename = "mingw-w64-i686-ncurses-6.2-2-any.pkg.tar.zst"; sha256 = "4b20ceb9b93597154180c5fdfc429a2b10f8facb58cf4c6b76a7b94188177220"; }];
    buildInputs = [ libsystre ];
  };

  "neon" = fetch {
    pname       = "neon";
    version     = "0.31.2";
    sources     = [{ filename = "mingw-w64-i686-neon-0.31.2-1-any.pkg.tar.zst"; sha256 = "4fde4d838f2911e76837cf71d8ae3a173b059decfc0598253b63e1ce72a2f3f7"; }];
    buildInputs = [ expat openssl ca-certificates ];
  };

  "netcdf" = fetch {
    pname       = "netcdf";
    version     = "4.7.4";
    sources     = [{ filename = "mingw-w64-i686-netcdf-4.7.4-1-any.pkg.tar.zst"; sha256 = "34425bfac5e67a3b9dd9e96cda176eddd2de33d06de649fae81e16fa60956c6c"; }];
    buildInputs = [ curl hdf5 ];
  };

  "nettle" = fetch {
    pname       = "nettle";
    version     = "3.6";
    sources     = [{ filename = "mingw-w64-i686-nettle-3.6-2-any.pkg.tar.zst"; sha256 = "a089b48fe544675b26d40a199cffbf584dcb04f30eb6e7f0c3ecb3abe68e5ed1"; }];
    buildInputs = [ gcc-libs gmp ];
  };

  "nghttp2" = fetch {
    pname       = "nghttp2";
    version     = "1.41.0";
    sources     = [{ filename = "mingw-w64-i686-nghttp2-1.41.0-1-any.pkg.tar.zst"; sha256 = "aacd50048097490dfde03cb2213283a788d125ddef6b76d507dd541d99c5ac0a"; }];
    buildInputs = [ jansson jemalloc openssl c-ares ];
  };

  "ngraph-gtk" = fetch {
    pname       = "ngraph-gtk";
    version     = "6.08.07";
    sources     = [{ filename = "mingw-w64-i686-ngraph-gtk-6.08.07-1-any.pkg.tar.zst"; sha256 = "f1b158c5054d3a4c0dad39ab1a33c922892adca824e0ae9b36bbf4e7c58a5751"; }];
    buildInputs = [ adwaita-icon-theme gsettings-desktop-schemas gtk3 gtksourceview4 readline gsl ruby ];
  };

  "ngspice" = fetch {
    pname       = "ngspice";
    version     = "32";
    sources     = [{ filename = "mingw-w64-i686-ngspice-32-2-any.pkg.tar.zst"; sha256 = "3ca0e8be7ccb27c784f804b82f070df7edc1a9b6dda41fc9f40b7d1953284980"; }];
    buildInputs = [ gcc-libs ];
  };

  "nim" = fetch {
    pname       = "nim";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-nim-1.2.0-1-any.pkg.tar.zst"; sha256 = "2c116e25acac6ab2dc67a43bd384076afee98e98edac5610b898b5bf42e742ae"; }];
  };

  "nimble" = fetch {
    pname       = "nimble";
    version     = "0.11.0";
    sources     = [{ filename = "mingw-w64-i686-nimble-0.11.0-1-any.pkg.tar.xz"; sha256 = "122ad57d4eb84a59303e1fcd188a46f0d4e9641ace7b49235766132d75e66306"; }];
  };

  "ninja" = fetch {
    pname       = "ninja";
    version     = "1.10.1";
    sources     = [{ filename = "mingw-w64-i686-ninja-1.10.1-1-any.pkg.tar.zst"; sha256 = "2e7349bfc3e6f99bcd952545265bc329c6385ab34182f73c80088e7ec0932c95"; }];
    buildInputs = [  ];
  };

  "nlohmann-json" = fetch {
    pname       = "nlohmann-json";
    version     = "3.9.1";
    sources     = [{ filename = "mingw-w64-i686-nlohmann-json-3.9.1-1-any.pkg.tar.zst"; sha256 = "08eecbbe8877a727342714b8708b419922a62cb667c6e47df15e8161e20e24ab"; }];
  };

  "nlopt" = fetch {
    pname       = "nlopt";
    version     = "2.6.2";
    sources     = [{ filename = "mingw-w64-i686-nlopt-2.6.2-1-any.pkg.tar.xz"; sha256 = "faab92191b67a075c2899d6fbfb2b25aeff6620f81d422d89eeeebe81fe4beee"; }];
  };

  "npth" = fetch {
    pname       = "npth";
    version     = "1.6";
    sources     = [{ filename = "mingw-w64-i686-npth-1.6-1-any.pkg.tar.xz"; sha256 = "123a2ac722ad936e066220bd12e165960feb3ab0a267e62aab88687b6a7c6f0c"; }];
    buildInputs = [ gcc-libs ];
  };

  "nsis" = fetch {
    pname       = "nsis";
    version     = "3.05";
    sources     = [{ filename = "mingw-w64-i686-nsis-3.05-1-any.pkg.tar.xz"; sha256 = "5427f43d7365198fc8dcf4bd22c47505e439054a8597f4437efd65a1ac29aa83"; }];
    buildInputs = [ zlib gcc-libs libwinpthread-git ];
  };

  "nsis-nsisunz" = fetch {
    pname       = "nsis-nsisunz";
    version     = "1.0";
    sources     = [{ filename = "mingw-w64-i686-nsis-nsisunz-1.0-1-any.pkg.tar.xz"; sha256 = "6ab117e6379a41d56301912f9da96a64a6e735b26913f179e41c510eff6e56d2"; }];
    buildInputs = [ nsis ];
  };

  "nspr" = fetch {
    pname       = "nspr";
    version     = "4.25";
    sources     = [{ filename = "mingw-w64-i686-nspr-4.25-1-any.pkg.tar.xz"; sha256 = "58183d2363e30a54410fae5bb4716ed7ba5dd799275b4ef1272b95022fec0abd"; }];
    buildInputs = [ gcc-libs ];
  };

  "nss" = fetch {
    pname       = "nss";
    version     = "3.52.1";
    sources     = [{ filename = "mingw-w64-i686-nss-3.52.1-1-any.pkg.tar.zst"; sha256 = "0ebad96894da1ef04871411a9deeaba5effd21db2a52175aceb591ca3dc307ba"; }];
    buildInputs = [ nspr sqlite3 zlib ];
  };

  "nsync" = fetch {
    pname       = "nsync";
    version     = "1.24.0";
    sources     = [{ filename = "mingw-w64-i686-nsync-1.24.0-1-any.pkg.tar.zst"; sha256 = "ac5cbdb31abae3eb6a7dcbc3be729ac737c059b421205672ad01981efb1dc5ee"; }];
    buildInputs = [ gcc-libs ];
  };

  "ntldd-git" = fetch {
    pname       = "ntldd-git";
    version     = "r15.e7622f6";
    sources     = [{ filename = "mingw-w64-i686-ntldd-git-r15.e7622f6-2-any.pkg.tar.xz"; sha256 = "361d19deeaaa9be4f8a32bd40bebed4e4965c6f0ec7c2f4529c5930e986a1c22"; }];
  };

  "nuspell" = fetch {
    pname       = "nuspell";
    version     = "3.1.2";
    sources     = [{ filename = "mingw-w64-i686-nuspell-3.1.2-1-any.pkg.tar.zst"; sha256 = "fecf39be9fddf6244dbf7587374d807a1fe331f91b06c014a76729661d9c17c3"; }];
    buildInputs = [ icu boost ];
  };

  "nvidia-cg-toolkit" = fetch {
    pname       = "nvidia-cg-toolkit";
    version     = "3.1";
    sources     = [{ filename = "mingw-w64-i686-nvidia-cg-toolkit-3.1-1-any.pkg.tar.zst"; sha256 = "08068ee4dab822addb70c9bafb483b53e36c78a78b59b835709217f811f114a8"; }];
    buildInputs = [ crt-git ];
  };

  "oce" = fetch {
    pname       = "oce";
    version     = "0.18.3";
    sources     = [{ filename = "mingw-w64-i686-oce-0.18.3-3-any.pkg.tar.xz"; sha256 = "f49c485d2c52b111d70523175982ea88e01d1fb59e48a394f9a0c9479ef75986"; }];
    buildInputs = [ freetype ];
  };

  "octopi-git" = fetch {
    pname       = "octopi-git";
    version     = "r941.6df0f8a";
    sources     = [{ filename = "mingw-w64-i686-octopi-git-r941.6df0f8a-1-any.pkg.tar.xz"; sha256 = "9258b5333beb815ae5b95a7771ad1ca2aabc07cfe0d485dd89d825c69abb9291"; }];
    buildInputs = [ gcc-libs ];
  };

  "odt2txt" = fetch {
    pname       = "odt2txt";
    version     = "0.5";
    sources     = [{ filename = "mingw-w64-i686-odt2txt-0.5-2-any.pkg.tar.xz"; sha256 = "133a5ad172cef84fc5c796301ec4d6ebdfd9848bd96f5ad3c0610653bac141b5"; }];
    buildInputs = [ libiconv libzip pcre ];
  };

  "ogitor-git" = fetch {
    pname       = "ogitor-git";
    version     = "r816.cf42232";
    sources     = [{ filename = "mingw-w64-i686-ogitor-git-r816.cf42232-1-any.pkg.tar.xz"; sha256 = "c67e032729a028625f8ef484303f1c94e7408e77fdfc28bc1928624c0ed27d53"; }];
    buildInputs = [ libwinpthread-git ogre3d boost qt5 ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "ogre3d" = fetch {
    pname       = "ogre3d";
    version     = "1.12.6";
    sources     = [{ filename = "mingw-w64-i686-ogre3d-1.12.6-1-any.pkg.tar.zst"; sha256 = "931a4d95c9fd5d6c59249434aaf2d4732c95299cd7b70ce0216f94e5e72b87a8"; }];
    buildInputs = [ boost cppunit FreeImage freetype glsl-optimizer-git hlsl2glsl-git intel-tbb openexr SDL2 python pugixml tinyxml winpthreads-git zlib zziplib ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "ois" = fetch {
    pname       = "ois";
    version     = "1.5";
    sources     = [{ filename = "mingw-w64-i686-ois-1.5-1-any.pkg.tar.zst"; sha256 = "f894aa0423639664ba154c4f3024f4b1cacf5a33e9e1e8ea3259e76a05292b3a"; }];
    buildInputs = [ gcc-libs ];
  };

  "onigmo" = fetch {
    pname       = "onigmo";
    version     = "6.2.0";
    sources     = [{ filename = "mingw-w64-i686-onigmo-6.2.0-1-any.pkg.tar.xz"; sha256 = "47aac597aa207cebe713874fdd081a406f49dcbb1babf06f29f3d45c74a00a54"; }];
  };

  "oniguruma" = fetch {
    pname       = "oniguruma";
    version     = "6.9.5";
    sources     = [{ filename = "mingw-w64-i686-oniguruma-6.9.5-1-any.pkg.tar.xz"; sha256 = "9697048e49a62539e3cff49e2cae2d0de6b90824d0c10839544a7ef6132fddc7"; }];
    buildInputs = [  ];
  };

  "openal" = fetch {
    pname       = "openal";
    version     = "1.20.1";
    sources     = [{ filename = "mingw-w64-i686-openal-1.20.1-2-any.pkg.tar.zst"; sha256 = "406472dc6a616c0b965444efa221499fc66ad7db47097d5e370c99bd0a05d6bf"; }];
    buildInputs = [ libmysofa ];
  };

  "openblas" = fetch {
    pname       = "openblas";
    version     = "0.3.10";
    sources     = [{ filename = "mingw-w64-i686-openblas-0.3.10-2-any.pkg.tar.zst"; sha256 = "2dce696afa0157e5ce6fbdb8c82d6cefa17a265749906097f9da9c3fa7931bda"; }];
    buildInputs = [ gcc-libs gcc-libgfortran libwinpthread-git ];
  };

  "opencascade" = fetch {
    pname       = "opencascade";
    version     = "7.4.0p1";
    sources     = [{ filename = "mingw-w64-i686-opencascade-7.4.0p1-1-any.pkg.tar.zst"; sha256 = "e4f3ca9bd7b1f33663afb20eb0fbe96696161760fcd52727e1e563c4b3d31548"; }];
    buildInputs = [ tk tcl freetype ];
  };

  "opencc" = fetch {
    pname       = "opencc";
    version     = "1.0.6";
    sources     = [{ filename = "mingw-w64-i686-opencc-1.0.6-1-any.pkg.tar.zst"; sha256 = "a8b92e9402c1bb1b6fbfb276286f07567d4a212f7a15726ca75c2839591f38ee"; }];
    buildInputs = [  ];
  };

  "opencl-headers" = fetch {
    pname       = "opencl-headers";
    version     = "2~2.2.20200327";
    sources     = [{ filename = "mingw-w64-i686-opencl-headers-2~2.2.20200327-1-any.pkg.tar.xz"; sha256 = "9082531779e2ed366f9b3b95468f269aac2532bf0cd228568eae417b78d32528"; }];
    buildInputs = [  ];
  };

  "opencl-icd-git" = fetch {
    pname       = "opencl-icd-git";
    version     = "47.c7fda8b";
    sources     = [{ filename = "mingw-w64-i686-opencl-icd-git-47.c7fda8b-1-any.pkg.tar.xz"; sha256 = "76e94a9528fce907c54d65a4c8cee648a25aea731346fe02862b592a84f85638"; }];
    buildInputs = [ opencl-headers ];
  };

  "opencollada" = fetch {
    pname       = "opencollada";
    version     = "1.6.68";
    sources     = [{ filename = "mingw-w64-i686-opencollada-1.6.68-2-any.pkg.tar.zst"; sha256 = "dba10f81aa6f714085d88b76f966b4e91fc00cbb0adb13af3ab24d5566e65cf8"; }];
    buildInputs = [ libxml2 pcre ];
  };

  "opencolorio" = fetch {
    pname       = "opencolorio";
    version     = "1.1.1";
    sources     = [{ filename = "mingw-w64-i686-opencolorio-1.1.1-9-any.pkg.tar.zst"; sha256 = "a73490513ef3df121a2f1e031485888455470736892a68635ae40649436f0943"; }];
    buildInputs = [ boost expat glew lcms2 openexr ptex python tinyxml yaml-cpp ];
  };

  "opencore-amr" = fetch {
    pname       = "opencore-amr";
    version     = "0.1.5";
    sources     = [{ filename = "mingw-w64-i686-opencore-amr-0.1.5-1-any.pkg.tar.xz"; sha256 = "33ac0d1b31850ce14795b1ef091d61487fe2980085790414cd443478c1cbf045"; }];
    buildInputs = [  ];
  };

  "opencsg" = fetch {
    pname       = "opencsg";
    version     = "1.4.2";
    sources     = [{ filename = "mingw-w64-i686-opencsg-1.4.2-1-any.pkg.tar.xz"; sha256 = "79397bf6d1315882c425d229e385159f332e88c14f7306a8a7f4dbbe81c22416"; }];
    buildInputs = [ glew ];
  };

  "opencv" = fetch {
    pname       = "opencv";
    version     = "4.5.0";
    sources     = [{ filename = "mingw-w64-i686-opencv-4.5.0-1-any.pkg.tar.zst"; sha256 = "fdbd5c3515003c5d452d00bfa9486153fdc08e52ead7f19c07e0c5bb6ca42841"; }];
    buildInputs = [ ceres-solver intel-tbb jasper freetype gflags glog harfbuzz hdf5 libjpeg libpng libtiff libwebp ogre3d openblas openjpeg2 openexr protobuf tesseract-ocr zlib ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "openexr" = fetch {
    pname       = "openexr";
    version     = "2.5.3";
    sources     = [{ filename = "mingw-w64-i686-openexr-2.5.3-1-any.pkg.tar.zst"; sha256 = "e3fba0f8a807009ca53a8eadb41c38f15b54d46f7abda7bbf2f8fc8a0175c291"; }];
    buildInputs = [ (assert ilmbase.version=="2.5.3"; ilmbase) zlib ];
  };

  "opengl-man-pages" = fetch {
    pname       = "opengl-man-pages";
    version     = "20191114";
    sources     = [{ filename = "mingw-w64-i686-opengl-man-pages-20191114-1-any.pkg.tar.xz"; sha256 = "5f470582c82a584b679ce42f0296e454e763aef8d620c5bbd7c86ddf465e5230"; }];
  };

  "openh264" = fetch {
    pname       = "openh264";
    version     = "2.1.1";
    sources     = [{ filename = "mingw-w64-i686-openh264-2.1.1-1-any.pkg.tar.zst"; sha256 = "d5642c2124a040193bb7fbcbbbf629ef500cdc6d19c74b90f9deabdb5f1c5562"; }];
  };

  "openimageio" = fetch {
    pname       = "openimageio";
    version     = "2.2.7.0";
    sources     = [{ filename = "mingw-w64-i686-openimageio-2.2.7.0-1-any.pkg.tar.zst"; sha256 = "a8a3aa3f98042316fab98f132cb5815c75db64f585c7dd815c1851bd43f08fcf"; }];
    buildInputs = [ boost field3d freetype fmt jasper giflib glew hdf5 libheif libjpeg libpng libraw libsquish ffmpeg libtiff libwebp opencolorio opencv openexr openjpeg openssl ptex pugixml zlib ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "openjpeg" = fetch {
    pname       = "openjpeg";
    version     = "1.5.2";
    sources     = [{ filename = "mingw-w64-i686-openjpeg-1.5.2-7-any.pkg.tar.xz"; sha256 = "1435b1222bc1e93ae1e8e82e00930e5ef7df8af36b2cc7690285c46f4cf7252a"; }];
    buildInputs = [ lcms2 libtiff libpng zlib ];
  };

  "openjpeg2" = fetch {
    pname       = "openjpeg2";
    version     = "2.3.1";
    sources     = [{ filename = "mingw-w64-i686-openjpeg2-2.3.1-1-any.pkg.tar.xz"; sha256 = "104d2bb99d3c3d88161f972b022008e416fc7bb5bd3a7734fbbbc1e1dd753f32"; }];
    buildInputs = [ gcc-libs lcms2 libtiff libpng zlib ];
  };

  "openldap" = fetch {
    pname       = "openldap";
    version     = "2.4.50";
    sources     = [{ filename = "mingw-w64-i686-openldap-2.4.50-1-any.pkg.tar.zst"; sha256 = "55fc7675c8af43303ac0095210bdd8e635f0bf59b3092fbdfed4d07e2fbf8dc0"; }];
    buildInputs = [ cyrus-sasl libtool openssl ];
  };

  "openlibm" = fetch {
    pname       = "openlibm";
    version     = "0.7.2";
    sources     = [{ filename = "mingw-w64-i686-openlibm-0.7.2-1-any.pkg.tar.zst"; sha256 = "4dcadd5182abcc6757dd92453cca14e385eb99ea7d2821171c2b2011a1378b06"; }];
  };

  "openmp" = fetch {
    pname       = "openmp";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-openmp-10.0.1-1-any.pkg.tar.zst"; sha256 = "7c5a42f00e799fea4c39224976b94511c582ba7b074044387d80caec31dd1caa"; }];
    buildInputs = [ gcc ];
  };

  "openocd" = fetch {
    pname       = "openocd";
    version     = "0.10.0";
    sources     = [{ filename = "mingw-w64-i686-openocd-0.10.0-2-any.pkg.tar.xz"; sha256 = "aaddcdaf183ac9e434af9620e39476f75a57e8d2702d688418abf776034d76e3"; }];
    buildInputs = [ hidapi libusb libusb-compat-git libftdi libjaylink-git ];
  };

  "openscad" = fetch {
    pname       = "openscad";
    version     = "2019.05";
    sources     = [{ filename = "mingw-w64-i686-openscad-2019.05-2-any.pkg.tar.xz"; sha256 = "6e710d8be8ed5c64036fa7e683453040a55f73873631b84d72ad74511b469417"; }];
    buildInputs = [ qt5 boost cgal double-conversion fontconfig freetype glew glib2 harfbuzz libxml2 libzip opencsg qscintilla shared-mime-info ];
  };

  "openshadinglanguage" = fetch {
    pname       = "openshadinglanguage";
    version     = "1.11.8.0";
    sources     = [{ filename = "mingw-w64-i686-openshadinglanguage-1.11.8.0-1-any.pkg.tar.zst"; sha256 = "847c4d07cf5c9ebb071b80a91bc7b9400b49bbe496cf9aa887c6473f0bc835a1"; }];
    buildInputs = [ boost clang freetype glew ilmbase intel-tbb libpng libtiff openexr openimageio partio pugixml ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "openssl" = fetch {
    pname       = "openssl";
    version     = "1.1.1.h";
    sources     = [{ filename = "mingw-w64-i686-openssl-1.1.1.h-1-any.pkg.tar.zst"; sha256 = "82ff211ee53508c129539dd2401a835eba1151b83237ec5cb94fa918ff372267"; }];
    buildInputs = [ ca-certificates gcc-libs zlib ];
  };

  "openvdb" = fetch {
    pname       = "openvdb";
    version     = "7.0.0";
    sources     = [{ filename = "mingw-w64-i686-openvdb-7.0.0-3-any.pkg.tar.zst"; sha256 = "ad0e75e6c0518317fc34cf17345b9588974556969d1926c2acb0da5dd6dedf2f"; }];
    buildInputs = [ blosc boost intel-tbb openexr zlib ];
  };

  "openvr" = fetch {
    pname       = "openvr";
    version     = "1.14.15";
    sources     = [{ filename = "mingw-w64-i686-openvr-1.14.15-1-any.pkg.tar.zst"; sha256 = "e6435ab4e9b6b8464ce9d8f2886c5fdfcf116e5c8da408fb75c907bc17d8d699"; }];
    buildInputs = [ gcc-libs ];
  };

  "openxr-sdk" = fetch {
    pname       = "openxr-sdk";
    version     = "1.0.9";
    sources     = [{ filename = "mingw-w64-i686-openxr-sdk-1.0.9-4-any.pkg.tar.zst"; sha256 = "2d838631d4f8f467c50f883431e81ebbfe54ac77a5558d1aef5b1a4015364916"; }];
    buildInputs = [ jsoncpp vulkan-loader ];
  };

  "optipng" = fetch {
    pname       = "optipng";
    version     = "0.7.7";
    sources     = [{ filename = "mingw-w64-i686-optipng-0.7.7-1-any.pkg.tar.xz"; sha256 = "b63b560c30465c09a44cbdda762b3d5b5467923175b46655ae6ccb4d982a0697"; }];
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "opus" = fetch {
    pname       = "opus";
    version     = "1.3.1";
    sources     = [{ filename = "mingw-w64-i686-opus-1.3.1-1-any.pkg.tar.xz"; sha256 = "639e25dd60d8e32403bbe95866e7b8c5679cd51757808094019c6293a18c680d"; }];
    buildInputs = [  ];
  };

  "opus-tools" = fetch {
    pname       = "opus-tools";
    version     = "0.2";
    sources     = [{ filename = "mingw-w64-i686-opus-tools-0.2-1-any.pkg.tar.xz"; sha256 = "bae2a5cd38fc54698f9f7012dfff2ecadd2cc586af589d12bb1fdc58f6a7d817"; }];
    buildInputs = [ gcc-libs flac libogg opus opusfile libopusenc ];
  };

  "opusfile" = fetch {
    pname       = "opusfile";
    version     = "0.12";
    sources     = [{ filename = "mingw-w64-i686-opusfile-0.12-1-any.pkg.tar.zst"; sha256 = "2f12218ae66a0b21a3f79f674502e9ad5a606f9558d2c9c6f2f2809029d7f192"; }];
    buildInputs = [ libogg openssl opus ];
  };

  "orc" = fetch {
    pname       = "orc";
    version     = "0.4.31";
    sources     = [{ filename = "mingw-w64-i686-orc-0.4.31-1-any.pkg.tar.xz"; sha256 = "4577f521c0ada81f771580fe506c5ef075895023ebb49587ff082d273d5d3d9f"; }];
    buildInputs = [  ];
  };

  "osgQt" = fetch {
    pname       = "osgQt";
    version     = "3.5.7";
    sources     = [{ filename = "mingw-w64-i686-osgQt-3.5.7-7-any.pkg.tar.xz"; sha256 = "e450001e0101ffb0b7b4d3be0b36d2c06ba01bac243435a3c517ff98aea6e96b"; }];
    buildInputs = [ qt5 OpenSceneGraph ];
  };

  "osgQt-debug" = fetch {
    pname       = "osgQt-debug";
    version     = "3.5.7";
    sources     = [{ filename = "mingw-w64-i686-osgQt-debug-3.5.7-7-any.pkg.tar.xz"; sha256 = "eaee7136c8288e12ec050afb306ae1cc8c7e3803a1c42819a237c4dda9bff0c4"; }];
    buildInputs = [ qt5 OpenSceneGraph-debug ];
  };

  "osgQtQuick-debug-git" = fetch {
    pname       = "osgQtQuick-debug-git";
    version     = "2.0.0.r172";
    sources     = [{ filename = "mingw-w64-i686-osgQtQuick-debug-git-2.0.0.r172-4-any.pkg.tar.xz"; sha256 = "9a6e5b4d693f84a34c42a5266744a92d367c6ed9a62db22f65b50022ee3e9adf"; }];
    buildInputs = [ osgQt-debug qt5 (assert osgQtQuick-git.version=="2.0.0.r172"; osgQtQuick-git) OpenSceneGraph-debug ];
  };

  "osgQtQuick-git" = fetch {
    pname       = "osgQtQuick-git";
    version     = "2.0.0.r172";
    sources     = [{ filename = "mingw-w64-i686-osgQtQuick-git-2.0.0.r172-4-any.pkg.tar.xz"; sha256 = "7edd3ab4cf457d35ea841cd8bc49a230286d0409c4ca1d5b5e3cf80ae6ebaaaf"; }];
    buildInputs = [ osgQt qt5 OpenSceneGraph ];
  };

  "osgbullet-debug-git" = fetch {
    pname       = "osgbullet-debug-git";
    version     = "3.0.0.265";
    sources     = [{ filename = "mingw-w64-i686-osgbullet-debug-git-3.0.0.265-1-any.pkg.tar.xz"; sha256 = "301bdabd3bb71f45fc7763f69b3f5e8bb493ffc19fe01778f8e5349f015253fb"; }];
    buildInputs = [ (assert osgbullet-git.version=="3.0.0.265"; osgbullet-git) OpenSceneGraph-debug osgworks-debug-git ];
  };

  "osgbullet-git" = fetch {
    pname       = "osgbullet-git";
    version     = "3.0.0.265";
    sources     = [{ filename = "mingw-w64-i686-osgbullet-git-3.0.0.265-1-any.pkg.tar.xz"; sha256 = "4014f581540b544384403d278d74d4a140dec7bf41fa7ecf9f5e046888ce3184"; }];
    buildInputs = [ bullet OpenSceneGraph osgworks-git ];
  };

  "osgearth" = fetch {
    pname       = "osgearth";
    version     = "2.10.1";
    sources     = [{ filename = "mingw-w64-i686-osgearth-2.10.1-1-any.pkg.tar.xz"; sha256 = "7b1652d2e0fcdda4291dad7f08727abc9bef54afce2c66add4de1a756c283768"; }];
    buildInputs = [ OpenSceneGraph OpenSceneGraph-debug osgQt osgQt-debug curl gdal geos poco protobuf rocksdb sqlite3 OpenSceneGraph ];
  };

  "osgearth-debug" = fetch {
    pname       = "osgearth-debug";
    version     = "2.10.1";
    sources     = [{ filename = "mingw-w64-i686-osgearth-debug-2.10.1-1-any.pkg.tar.xz"; sha256 = "34d2d6f42a2f3fffb2366365d7a6f69aebbbda1146a2fecac6fbd368856efdfc"; }];
    buildInputs = [ OpenSceneGraph OpenSceneGraph-debug osgQt osgQt-debug curl gdal geos poco protobuf rocksdb sqlite3 OpenSceneGraph-debug ];
  };

  "osgocean-debug-git" = fetch {
    pname       = "osgocean-debug-git";
    version     = "1.0.1.r161";
    sources     = [{ filename = "mingw-w64-i686-osgocean-debug-git-1.0.1.r161-1-any.pkg.tar.xz"; sha256 = "d9b69b4771cfc217b378931f7b8cb150dda5668994ae1c1727d717de79f8da3a"; }];
    buildInputs = [ (assert osgocean-git.version=="1.0.1.r161"; osgocean-git) OpenSceneGraph-debug ];
  };

  "osgocean-git" = fetch {
    pname       = "osgocean-git";
    version     = "1.0.1.r161";
    sources     = [{ filename = "mingw-w64-i686-osgocean-git-1.0.1.r161-1-any.pkg.tar.xz"; sha256 = "c63067cd62e703a8a5f0ad64750bfef93bfb76608c4cfd039092cd1848020b78"; }];
    buildInputs = [ fftw OpenSceneGraph ];
  };

  "osgworks-debug-git" = fetch {
    pname       = "osgworks-debug-git";
    version     = "3.1.0.444";
    sources     = [{ filename = "mingw-w64-i686-osgworks-debug-git-3.1.0.444-3-any.pkg.tar.xz"; sha256 = "f5b7e1150de904f70f54e7b7d25aecb3f523f3cdb9bfa9fbebc5ac336f58246e"; }];
    buildInputs = [ (assert osgworks-git.version=="3.1.0.444"; osgworks-git) OpenSceneGraph-debug ];
  };

  "osgworks-git" = fetch {
    pname       = "osgworks-git";
    version     = "3.1.0.444";
    sources     = [{ filename = "mingw-w64-i686-osgworks-git-3.1.0.444-3-any.pkg.tar.xz"; sha256 = "c90d3ed1c2505888e1600415811974d0eed104435fe891b5cd36b6ab35b8b8c2"; }];
    buildInputs = [ OpenSceneGraph vrpn ];
  };

  "osl" = fetch {
    pname       = "osl";
    version     = "0.9.2";
    sources     = [{ filename = "mingw-w64-i686-osl-0.9.2-2-any.pkg.tar.zst"; sha256 = "7e343b56630d412cdd11a1d29cac333ff1cf3ed68968d1d6ace0cd2343ea9697"; }];
    buildInputs = [ gmp ];
  };

  "osm-gps-map" = fetch {
    pname       = "osm-gps-map";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-osm-gps-map-1.1.0-3-any.pkg.tar.xz"; sha256 = "7a21de811d231daf9f8a1ab64b610eda4c0cb9a93d3ef09a7537097130c136ac"; }];
    buildInputs = [ libsoup gtk3 gobject-introspection ];
  };

  "osslsigncode" = fetch {
    pname       = "osslsigncode";
    version     = "2.0";
    sources     = [{ filename = "mingw-w64-i686-osslsigncode-2.0-1-any.pkg.tar.xz"; sha256 = "b8183d0d0bad8df5bd4355120db51a413c8edd1b8f3470f1b58027ff4da2400a"; }];
    buildInputs = [ curl libgsf openssl ];
  };

  "p11-kit" = fetch {
    pname       = "p11-kit";
    version     = "0.23.21";
    sources     = [{ filename = "mingw-w64-i686-p11-kit-0.23.21-3-any.pkg.tar.zst"; sha256 = "0f347a4b0f955f1e7ffbefa839e5b264f1f7534f3920eeb9ed0244b3973de05c"; }];
    buildInputs = [ libtasn1 libffi gettext ];
  };

  "paho.mqtt.c" = fetch {
    pname       = "paho.mqtt.c";
    version     = "1.3.0";
    sources     = [{ filename = "mingw-w64-i686-paho.mqtt.c-1.3.0-1-any.pkg.tar.xz"; sha256 = "92dcea356ee85710e0a79bc920da9e4bd0c720a3489e7cad722af1cc824904e4"; }];
  };

  "pango" = fetch {
    pname       = "pango";
    version     = "1.46.2";
    sources     = [{ filename = "mingw-w64-i686-pango-1.46.2-1-any.pkg.tar.zst"; sha256 = "6a6f7db36a90ed50224250fdacf6a4bed2cebd535098931edf8745b2f250590a"; }];
    buildInputs = [ gcc-libs cairo freetype fontconfig glib2 harfbuzz fribidi libthai ];
  };

  "pangomm" = fetch {
    pname       = "pangomm";
    version     = "2.42.1";
    sources     = [{ filename = "mingw-w64-i686-pangomm-2.42.1-1-any.pkg.tar.xz"; sha256 = "f2864e219b8300cecebcf4208018724a976f17b560d2d90719bd72af961328cd"; }];
    buildInputs = [ cairomm glibmm pango ];
  };

  "parmetis" = fetch {
    pname       = "parmetis";
    version     = "4.0.3";
    sources     = [{ filename = "mingw-w64-i686-parmetis-4.0.3-1-any.pkg.tar.xz"; sha256 = "da70cbc6b7171cb199b9b795abb504d257dd03ace8f0e7d8d24351fde6ffc419"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast metis.version "5.1.0"; metis) msmpi ];
  };

  "partio" = fetch {
    pname       = "partio";
    version     = "1.10.1";
    sources     = [{ filename = "mingw-w64-i686-partio-1.10.1-2-any.pkg.tar.xz"; sha256 = "6317520ae928c3db84f08969ff30245c1e4fba876c07b3d1ae0fa64327b937b3"; }];
    buildInputs = [ freeglut zlib ];
  };

  "pcre" = fetch {
    pname       = "pcre";
    version     = "8.44";
    sources     = [{ filename = "mingw-w64-i686-pcre-8.44-1-any.pkg.tar.xz"; sha256 = "dd432237cfb530472ed9d6acbaa8ed75b8df88acb155c24ab4ca29c4c278fd66"; }];
    buildInputs = [ gcc-libs bzip2 wineditline zlib ];
  };

  "pcre2" = fetch {
    pname       = "pcre2";
    version     = "10.35";
    sources     = [{ filename = "mingw-w64-i686-pcre2-10.35-1-any.pkg.tar.zst"; sha256 = "ae67d4ac885d2112001c63b05c016824bef131e619bdd9749c34b7df51ab7fd9"; }];
    buildInputs = [ gcc-libs bzip2 wineditline zlib ];
  };

  "pdcurses" = fetch {
    pname       = "pdcurses";
    version     = "4.1.0";
    sources     = [{ filename = "mingw-w64-i686-pdcurses-4.1.0-3-any.pkg.tar.xz"; sha256 = "db677ae9814ce0a3ebe77165d0ca9b48cd9167a1a285510cc1d9fd437b0c00e6"; }];
    buildInputs = [ gcc-libs ];
  };

  "pdf2djvu" = fetch {
    pname       = "pdf2djvu";
    version     = "0.9.17.1";
    sources     = [{ filename = "mingw-w64-i686-pdf2djvu-0.9.17.1-1-any.pkg.tar.zst"; sha256 = "6fbe4d7452d90f342ea7bde4b3e22d7a24771166932e0fcf765dab49438615f6"; }];
    buildInputs = [ poppler gcc-libs djvulibre exiv2 gettext graphicsmagick libiconv ];
  };

  "pdf2svg" = fetch {
    pname       = "pdf2svg";
    version     = "0.2.3";
    sources     = [{ filename = "mingw-w64-i686-pdf2svg-0.2.3-17-any.pkg.tar.zst"; sha256 = "5dcc24a682ce078ae4ab151e8db81423150737e44a69484d781472e5629d95d8"; }];
    buildInputs = [ poppler ];
  };

  "pegtl" = fetch {
    pname       = "pegtl";
    version     = "2.8.1";
    sources     = [{ filename = "mingw-w64-i686-pegtl-2.8.1-1-any.pkg.tar.xz"; sha256 = "5f278cc67ec2aad367263d7124f729fc2e1865837a85a9c69e055d059737cf37"; }];
    buildInputs = [ gcc-libs ];
  };

  "pelican" = fetch {
    pname       = "pelican";
    version     = "4.2.0";
    sources     = [{ filename = "mingw-w64-i686-pelican-4.2.0-1-any.pkg.tar.zst"; sha256 = "0b1c7e7cc64e5cbb40076a8523512226c052d314a653a4172d788a2c0f65343e"; }];
    buildInputs = [ python python-jinja python-pygments python-feedgenerator python-pytz python-docutils python-blinker python-unidecode python-six python-dateutil ];
  };

  "perl" = fetch {
    pname       = "perl";
    version     = "5.28.0";
    sources     = [{ filename = "mingw-w64-i686-perl-5.28.0-1-any.pkg.tar.xz"; sha256 = "6186059a3533d3634b445247785f608c1e5d6fe9fc075d63f2088203d6a1b42c"; }];
    buildInputs = [ gcc-libs winpthreads-git make ];
  };

  "perl-doc" = fetch {
    pname       = "perl-doc";
    version     = "5.28.0";
    sources     = [{ filename = "mingw-w64-i686-perl-doc-5.28.0-1-any.pkg.tar.xz"; sha256 = "905f5f93267984a039afe0b070c954e5c3b2c8f8732dc4cecb04947f74f9fe95"; }];
  };

  "phodav" = fetch {
    pname       = "phodav";
    version     = "2.4";
    sources     = [{ filename = "mingw-w64-i686-phodav-2.4-1-any.pkg.tar.xz"; sha256 = "76328a52195b68fa6cac8afb1fdf25e78bf006f344c389a22f1d7f92f2e07267"; }];
    buildInputs = [ glib2 libsoup libxml2 ];
  };

  "phonon-qt5" = fetch {
    pname       = "phonon-qt5";
    version     = "4.11.1";
    sources     = [{ filename = "mingw-w64-i686-phonon-qt5-4.11.1-1-any.pkg.tar.xz"; sha256 = "0fb3a3ef814bcd475ee9af4fcbb93cd44b87206d941068d2ad85a9186da628c8"; }];
    buildInputs = [ qt5 glib2 ];
  };

  "physfs" = fetch {
    pname       = "physfs";
    version     = "3.0.2";
    sources     = [{ filename = "mingw-w64-i686-physfs-3.0.2-1-any.pkg.tar.xz"; sha256 = "0964dbacd447af0cfdee7ef5018f1df5bf2305bb6545a4be15cfcd0c781b3de0"; }];
    buildInputs = [ zlib ];
  };

  "pidgin" = fetch {
    pname       = "pidgin";
    version     = "2.11.0";
    sources     = [{ filename = "mingw-w64-i686-pidgin-2.11.0-1-any.pkg.tar.zst"; sha256 = "20674c250dd71b242bbb570d2c9ace5352471d10ca1418bdbacd4b5e1d371db0"; }];
    buildInputs = [ adwaita-icon-theme ca-certificates farstream freetype fontconfig gettext gnutls gsasl gst-plugins-base gst-plugins-good gtk2 gtkspell libgadu libidn meanwhile nss ncurses silc-toolkit zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "pinentry" = fetch {
    pname       = "pinentry";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-pinentry-1.1.0-2-any.pkg.tar.xz"; sha256 = "533b6ce644d73f61dccb984b885a36d28187da0f490976e899099aa7f18ff152"; }];
    buildInputs = [ qt5 libsecret libassuan ];
  };

  "pixman" = fetch {
    pname       = "pixman";
    version     = "0.40.0";
    sources     = [{ filename = "mingw-w64-i686-pixman-0.40.0-1-any.pkg.tar.xz"; sha256 = "ca8fd96d27d3fa197be29e1e15dcef8a840d8638bc92028cc992f6e35705c6f0"; }];
    buildInputs = [ gcc-libs ];
  };

  "pkg-config" = fetch {
    pname       = "pkg-config";
    version     = "0.29.2";
    sources     = [{ filename = "mingw-w64-i686-pkg-config-0.29.2-2-any.pkg.tar.zst"; sha256 = "998ccdab9beb8020a3f5fc9c49af2898b4e571f50af734ab319da6de9126ecae"; }];
    buildInputs = [ libwinpthread-git ];
  };

  "pkgconf" = fetch {
    pname       = "pkgconf";
    version     = "1.7.3";
    sources     = [{ filename = "mingw-w64-i686-pkgconf-1.7.3-1-any.pkg.tar.zst"; sha256 = "35d9552d469fa43b2c73afebaa7f53764bef53100681a74c36536a308fe3269e"; }];
  };

  "plasma-framework-qt5" = fetch {
    pname       = "plasma-framework-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-plasma-framework-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "03194e2bab336f6244adcca3a1b20d2a410c9c6fa8494f2d615b7c77cd55e70c"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kactivities-qt5.version "5.75.0"; kactivities-qt5) (assert stdenvNoCC.lib.versionAtLeast kdeclarative-qt5.version "5.75.0"; kdeclarative-qt5) (assert stdenvNoCC.lib.versionAtLeast kirigami2-qt5.version "5.75.0"; kirigami2-qt5) ];
  };

  "plplot" = fetch {
    pname       = "plplot";
    version     = "5.15.0";
    sources     = [{ filename = "mingw-w64-i686-plplot-5.15.0-3-any.pkg.tar.xz"; sha256 = "82b4a01aafaca0ae4b240330ffdbb68d20a835db8dfcd27c1b5ea2e07a536016"; }];
    buildInputs = [ cairo gcc-libs gcc-libgfortran freetype libharu lua python3 python3-numpy shapelib tk wxWidgets qhull-git ];
    broken      = true; # broken dependency plplot -> python3-numpy
  };

  "png2ico" = fetch {
    pname       = "png2ico";
    version     = "2002.12.08";
    sources     = [{ filename = "mingw-w64-i686-png2ico-2002.12.08-2-any.pkg.tar.xz"; sha256 = "30b38ada9bd1bb5141e956d0ba0306f2a60ed2746b4ac54c56c0a8874b65ee2a"; }];
    buildInputs = [  ];
  };

  "pngcrush" = fetch {
    pname       = "pngcrush";
    version     = "1.8.13";
    sources     = [{ filename = "mingw-w64-i686-pngcrush-1.8.13-1-any.pkg.tar.xz"; sha256 = "27062b33489149b0fc5a17a3fe4e7526ddbf9e1cf68c57847ac511012b3ca22a"; }];
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "pngnq" = fetch {
    pname       = "pngnq";
    version     = "1.1";
    sources     = [{ filename = "mingw-w64-i686-pngnq-1.1-2-any.pkg.tar.xz"; sha256 = "d27d2c69fcf0a5151384cdb2a5b97be7cf17f5d47d5cf95742b0e9a6a192cab2"; }];
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "pngquant" = fetch {
    pname       = "pngquant";
    version     = "2.13.0";
    sources     = [{ filename = "mingw-w64-i686-pngquant-2.13.0-1-any.pkg.tar.zst"; sha256 = "66a9df0beec2d9a07d319eb5ae0148154e7f202b463c64bc120bf172fbb18635"; }];
    buildInputs = [ libpng lcms2 libimagequant ];
  };

  "poco" = fetch {
    pname       = "poco";
    version     = "1.10.1";
    sources     = [{ filename = "mingw-w64-i686-poco-1.10.1-2-any.pkg.tar.xz"; sha256 = "77f072257ebdbf32d8e5c24410b1b2402edd6e6b6a8f5990732160d0618e2138"; }];
    buildInputs = [ gcc-libs expat libmariadbclient openssl pcre sqlite3 zlib ];
  };

  "podofo" = fetch {
    pname       = "podofo";
    version     = "0.9.6";
    sources     = [{ filename = "mingw-w64-i686-podofo-0.9.6-1-any.pkg.tar.xz"; sha256 = "de7607d5a1264b5af1d12a573aefa56cdaa85b301baae6e61216da8a44269d91"; }];
    buildInputs = [ fontconfig libtiff libidn libjpeg-turbo lua openssl ];
  };

  "polipo" = fetch {
    pname       = "polipo";
    version     = "1.1.1";
    sources     = [{ filename = "mingw-w64-i686-polipo-1.1.1-1-any.pkg.tar.xz"; sha256 = "90445206dbc4b497720efdb02606f7056d00d280b0c6f8e32b8a7ebc65a7387d"; }];
  };

  "polly" = fetch {
    pname       = "polly";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-polly-10.0.1-1-any.pkg.tar.zst"; sha256 = "5ca58de0b43da1c13e0b0f46ca6979a592622de7cf5c1f5b26f48120e4c8034b"; }];
    buildInputs = [ (assert llvm.version=="10.0.1"; llvm) ];
  };

  "poppler" = fetch {
    pname       = "poppler";
    version     = "20.10.0";
    sources     = [{ filename = "mingw-w64-i686-poppler-20.10.0-1-any.pkg.tar.zst"; sha256 = "db2a30b6cd76697452ccca52c0eabeb04ce2cb7f897ff951223dd04470ab8ec5"; }];
    buildInputs = [ cairo curl freetype icu lcms2 libjpeg libpng libtiff nss openjpeg2 poppler-data zlib ];
  };

  "poppler-data" = fetch {
    pname       = "poppler-data";
    version     = "0.4.9";
    sources     = [{ filename = "mingw-w64-i686-poppler-data-0.4.9-1-any.pkg.tar.xz"; sha256 = "6b1d212660be9466eb760cf7db9542056e48e6063636ff053b464f9045aab753"; }];
    buildInputs = [  ];
  };

  "popt" = fetch {
    pname       = "popt";
    version     = "1.16";
    sources     = [{ filename = "mingw-w64-i686-popt-1.16-1-any.pkg.tar.xz"; sha256 = "5560dbe8508eac9e20a5e5254373cfcd3934c8fcb07e5d4c2a48eb009aaad76f"; }];
    buildInputs = [ gettext ];
  };

  "port-scanner" = fetch {
    pname       = "port-scanner";
    version     = "1.3";
    sources     = [{ filename = "mingw-w64-i686-port-scanner-1.3-3-any.pkg.tar.xz"; sha256 = "34bba387accbe053a799aebaa07a521e9fa1aa17ab92dbad33e2ec62f1b791de"; }];
  };

  "portablexdr" = fetch {
    pname       = "portablexdr";
    version     = "4.9.2.r27.94fb83c";
    sources     = [{ filename = "mingw-w64-i686-portablexdr-4.9.2.r27.94fb83c-3-any.pkg.tar.xz"; sha256 = "da6ec4941e998fc33a13df36c27748af92e9a3f151c3a82243b60e9f7ad97ce8"; }];
    buildInputs = [ gcc-libs ];
  };

  "portaudio" = fetch {
    pname       = "portaudio";
    version     = "190600_20161030";
    sources     = [{ filename = "mingw-w64-i686-portaudio-190600_20161030-3-any.pkg.tar.xz"; sha256 = "ec13d7af871a27228c17a8a6b0b583cdf49d130440c224be515e313e44a06064"; }];
    buildInputs = [ gcc-libs ];
  };

  "portmidi" = fetch {
    pname       = "portmidi";
    version     = "217";
    sources     = [{ filename = "mingw-w64-i686-portmidi-217-2-any.pkg.tar.xz"; sha256 = "d8b490c771b8c80d459e8ae4ba3634351b32715aff05d3819d731a728cf60b01"; }];
    buildInputs = [ gcc-libs ];
  };

  "postgis" = fetch {
    pname       = "postgis";
    version     = "3.0.2";
    sources     = [{ filename = "mingw-w64-i686-postgis-3.0.2-1-any.pkg.tar.zst"; sha256 = "25ef83e4a4072276dee77e82b76e02a64a4e37a43cda76354dd7a4c33c82d65f"; }];
    buildInputs = [ gcc-libs gdal geos gettext json-c libxml2 postgresql proj ];
  };

  "postgresql" = fetch {
    pname       = "postgresql";
    version     = "12.4";
    sources     = [{ filename = "mingw-w64-i686-postgresql-12.4-1-any.pkg.tar.zst"; sha256 = "7e4e3f27e86eb150556decfedf6024c4e8d36f6ad5834a1dc9353b5b992c8183"; }];
    buildInputs = [ gcc-libs gettext libxml2 libxslt openssl python tcl zlib winpty ];
  };

  "potrace" = fetch {
    pname       = "potrace";
    version     = "1.16";
    sources     = [{ filename = "mingw-w64-i686-potrace-1.16-1-any.pkg.tar.xz"; sha256 = "1979e1a79c6eb94d80497eef480fe19f9dfd314fca53f494752afc63d1faed7e"; }];
    buildInputs = [  ];
  };

  "precice" = fetch {
    pname       = "precice";
    version     = "2.1.1";
    sources     = [{ filename = "mingw-w64-i686-precice-2.1.1-1-any.pkg.tar.zst"; sha256 = "2e08e88d4016c7b7f23a1276991766e61fc8311ee90dcb8568c5f1eeb1fbef90"; }];
    buildInputs = [ boost libxml2 eigen3 ];
  };

  "premake" = fetch {
    pname       = "premake";
    version     = "4.3";
    sources     = [{ filename = "mingw-w64-i686-premake-4.3-2-any.pkg.tar.xz"; sha256 = "3c9da70d22bf010300aea91b10033a0106cdbf43e348d0f45e352e784b16f8f7"; }];
  };

  "proj" = fetch {
    pname       = "proj";
    version     = "6.3.2";
    sources     = [{ filename = "mingw-w64-i686-proj-6.3.2-1-any.pkg.tar.zst"; sha256 = "cc4d29cdf875087956f0ce43d7c3507ce79e34711b32a31f155cad54fd2a4280"; }];
    buildInputs = [ gcc-libs sqlite3 ];
  };

  "protobuf" = fetch {
    pname       = "protobuf";
    version     = "3.12.4";
    sources     = [{ filename = "mingw-w64-i686-protobuf-3.12.4-1-any.pkg.tar.zst"; sha256 = "10a84debd06b83bbdd3ba85b9fcf23f0142808a5e7955f99b3d43a8eabd3803d"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "protobuf-c" = fetch {
    pname       = "protobuf-c";
    version     = "1.3.3";
    sources     = [{ filename = "mingw-w64-i686-protobuf-c-1.3.3-1-any.pkg.tar.xz"; sha256 = "d4f60780fc57e6e8e5ccc55715b08c743ed8572a21af31dff0120aa2b7e21d7c"; }];
    buildInputs = [ protobuf ];
  };

  "ptex" = fetch {
    pname       = "ptex";
    version     = "2.3.2";
    sources     = [{ filename = "mingw-w64-i686-ptex-2.3.2-2-any.pkg.tar.zst"; sha256 = "59a3d3f9bd95598f831922ba2edd82a5b697724e3095cae5efe62d7125e883b8"; }];
    buildInputs = [ gcc-libs zlib winpthreads-git ];
  };

  "pugixml" = fetch {
    pname       = "pugixml";
    version     = "1.10";
    sources     = [{ filename = "mingw-w64-i686-pugixml-1.10-1-any.pkg.tar.xz"; sha256 = "af27b4c1a77b256798f18ad30dd115746fe62b5698cd12ff0b15dd19016d5585"; }];
  };

  "pupnp" = fetch {
    pname       = "pupnp";
    version     = "1.12.1";
    sources     = [{ filename = "mingw-w64-i686-pupnp-1.12.1-1-any.pkg.tar.zst"; sha256 = "e40e8764d0f6cb5c8b9d714f94d7b00373115c7a4601a2cea218f9ee701017ca"; }];
  };

  "purple-skypeweb" = fetch {
    pname       = "purple-skypeweb";
    version     = "1.1";
    sources     = [{ filename = "mingw-w64-i686-purple-skypeweb-1.1-1-any.pkg.tar.zst"; sha256 = "3b5fbf84d7276365b413860d4a495bc729d47ac2b68bc506c5224e853a6b7897"; }];
    buildInputs = [ libpurple json-glib glib2 zlib gettext gcc-libs ];
    broken      = true; # broken dependency purple-skypeweb -> libpurple
  };

  "putty" = fetch {
    pname       = "putty";
    version     = "0.73";
    sources     = [{ filename = "mingw-w64-i686-putty-0.73-1-any.pkg.tar.xz"; sha256 = "be80cfa71974d48864313486ff150c6ab4b04d1b49df59346b3d17d703efa3a4"; }];
    buildInputs = [ gcc-libs ];
  };

  "putty-ssh" = fetch {
    pname       = "putty-ssh";
    version     = "0.0";
    sources     = [{ filename = "mingw-w64-i686-putty-ssh-0.0-3-any.pkg.tar.xz"; sha256 = "86176423007f5314f3981c9dc86a343ec6af95ee34c89b68816ce2d46da432ec"; }];
    buildInputs = [ gcc-libs putty ];
  };

  "pybind11" = fetch {
    pname       = "pybind11";
    version     = "2.5.0";
    sources     = [{ filename = "mingw-w64-i686-pybind11-2.5.0-1-any.pkg.tar.xz"; sha256 = "5908dc750a83cdf219e63d0fbf2ce619c0e033361cff71253d78244df402206f"; }];
  };

  "pygobject2-devel" = fetch {
    pname       = "pygobject2-devel";
    version     = "2.28.7";
    sources     = [{ filename = "mingw-w64-i686-pygobject2-devel-2.28.7-3-any.pkg.tar.xz"; sha256 = "c5bccd16b024b833468e44198626a4d844c20334b4440b718302d978ce08dd0f"; }];
    buildInputs = [  ];
  };

  "pyilmbase" = fetch {
    pname       = "pyilmbase";
    version     = "2.5.3";
    sources     = [{ filename = "mingw-w64-i686-pyilmbase-2.5.3-1-any.pkg.tar.zst"; sha256 = "9f78c554b70adc923f4550b791871832cce991132d8c8490a5230a2f2c6744e0"; }];
    buildInputs = [ (assert openexr.version=="2.5.3"; openexr) boost python-numpy ];
  };

  "pyqt-builder" = fetch {
    pname       = "pyqt-builder";
    version     = "1.5.0";
    sources     = [{ filename = "mingw-w64-i686-pyqt-builder-1.5.0-1-any.pkg.tar.zst"; sha256 = "fd82032c9d100bfda2ef8f1a8dd3dc8923694c8eb0962b38a35317af928ed861"; }];
  };

  "pyqt5-sip" = fetch {
    pname       = "pyqt5-sip";
    version     = "12.8.1";
    sources     = [{ filename = "mingw-w64-i686-pyqt5-sip-12.8.1-1-any.pkg.tar.zst"; sha256 = "7280d33bb875120b5e2b60068de8762988dff6fb80095d3024449283b9146ab6"; }];
    buildInputs = [ python ];
  };

  "pyside2-qt5" = fetch {
    pname       = "pyside2-qt5";
    version     = "5.15.1";
    sources     = [{ filename = "mingw-w64-i686-pyside2-qt5-5.15.1-1-any.pkg.tar.zst"; sha256 = "068ab4b1952ba63ca559a28c8fa15c579347a92245fd047a45f3353ce5885480"; }];
    buildInputs = [ python shiboken2-qt5 qt5 ];
  };

  "pyside2-tools-qt5" = fetch {
    pname       = "pyside2-tools-qt5";
    version     = "5.15.1";
    sources     = [{ filename = "mingw-w64-i686-pyside2-tools-qt5-5.15.1-1-any.pkg.tar.zst"; sha256 = "387af3450d6b8e905aaa586dbe68053268aaba56b06bae935946dd5397c07405"; }];
    buildInputs = [ qt5 ];
  };

  "pystring" = fetch {
    pname       = "pystring";
    version     = "1.1.3";
    sources     = [{ filename = "mingw-w64-i686-pystring-1.1.3-1-any.pkg.tar.xz"; sha256 = "a75448874e0f66c3228b5986732f39409bf9c71350eb8f3a0d1b4c5394b5ca90"; }];
    buildInputs = [ gcc-libs ];
  };

  "python" = fetch {
    pname       = "python";
    version     = "3.8.6";
    sources     = [{ filename = "mingw-w64-i686-python-3.8.6-3-any.pkg.tar.zst"; sha256 = "af13b10c628b7c01e6f4d8fad716aeb5ed352738ba90ae305a40f41adb482f39"; }];
    buildInputs = [ gcc-libs expat bzip2 libffi mpdecimal ncurses openssl sqlite3 tcl tk zlib xz ];
  };

  "python-absl-py" = fetch {
    pname       = "python-absl-py";
    version     = "0.9.0";
    sources     = [{ filename = "mingw-w64-i686-python-absl-py-0.9.0-1-any.pkg.tar.xz"; sha256 = "8bb06fe552e18c32ee58e65c0b85eb3874fa194ef3e118a777d994733c505112"; }];
    buildInputs = [ python python-six ];
  };

  "python-aiohttp" = fetch {
    pname       = "python-aiohttp";
    version     = "3.6.2";
    sources     = [{ filename = "mingw-w64-i686-python-aiohttp-3.6.2-1-any.pkg.tar.zst"; sha256 = "ee8f21f73e7282cdef8865f1ebd7484b4c0ab8abb60cc1cf2d405e705cfbef37"; }];
    buildInputs = [ python-async-timeout python-attrs python-chardet python-yarl ];
  };

  "python-alembic" = fetch {
    pname       = "python-alembic";
    version     = "1.4.2";
    sources     = [{ filename = "mingw-w64-i686-python-alembic-1.4.2-1-any.pkg.tar.zst"; sha256 = "f9f0dc00a37f8d3d713e6f0daa44ee1ac58bd3c7e9984deaac36639675037271"; }];
    buildInputs = [ python python-mako python-sqlalchemy python-editor python-dateutil ];
  };

  "python-apipkg" = fetch {
    pname       = "python-apipkg";
    version     = "1.5";
    sources     = [{ filename = "mingw-w64-i686-python-apipkg-1.5-1-any.pkg.tar.xz"; sha256 = "325d782f91a3e008b1d005c2a224b34acf55045b0d82e6d119958d3e48071b65"; }];
    buildInputs = [ python ];
  };

  "python-appdirs" = fetch {
    pname       = "python-appdirs";
    version     = "1.4.3";
    sources     = [{ filename = "mingw-w64-i686-python-appdirs-1.4.3-1-any.pkg.tar.xz"; sha256 = "3797628ddb0c23dabaf467cc6453264e96c49747f6d70c9d0828ef90d4cfdc43"; }];
    buildInputs = [ python ];
  };

  "python-argh" = fetch {
    pname       = "python-argh";
    version     = "0.26.2";
    sources     = [{ filename = "mingw-w64-i686-python-argh-0.26.2-1-any.pkg.tar.xz"; sha256 = "0012174d58976853bf267586a846b4badfa013ab28dfd5f66b685946cdd5313a"; }];
    buildInputs = [ python ];
  };

  "python-argon2_cffi" = fetch {
    pname       = "python-argon2_cffi";
    version     = "19.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-argon2_cffi-19.2.0-2-any.pkg.tar.xz"; sha256 = "c4a98692a9787fa056a31006a8beadd67f8f9430e7b850dc6c98e33cefecb482"; }];
    buildInputs = [ python python-cffi python-setuptools python-six ];
  };

  "python-asgiref" = fetch {
    pname       = "python-asgiref";
    version     = "3.2.5";
    sources     = [{ filename = "mingw-w64-i686-python-asgiref-3.2.5-1-any.pkg.tar.xz"; sha256 = "e6ad2832d977c5b59092cf69c26e3227b05485e8280d4bb8043f65e3b5546bc7"; }];
    buildInputs = [ python ];
  };

  "python-asn1crypto" = fetch {
    pname       = "python-asn1crypto";
    version     = "1.3.0";
    sources     = [{ filename = "mingw-w64-i686-python-asn1crypto-1.3.0-1-any.pkg.tar.xz"; sha256 = "d14f8820e921b35d0c530aa8b4527982ce83b6aa8c4e3704d96f0631648609c9"; }];
    buildInputs = [ python-pycparser ];
  };

  "python-astor" = fetch {
    pname       = "python-astor";
    version     = "0.8.1";
    sources     = [{ filename = "mingw-w64-i686-python-astor-0.8.1-1-any.pkg.tar.zst"; sha256 = "9493469837dcf2563064a8d84cfab21f18a35a593059447aa4ef456832d4a248"; }];
    buildInputs = [ python ];
  };

  "python-astroid" = fetch {
    pname       = "python-astroid";
    version     = "2.3.3";
    sources     = [{ filename = "mingw-w64-i686-python-astroid-2.3.3-1-any.pkg.tar.xz"; sha256 = "f2ee92295bc0795acdf28db46d51f4917c10b71fefd61ee2691e0f688ef5ae4e"; }];
    buildInputs = [ python-six python-lazy-object-proxy python-wrapt python-typed_ast ];
  };

  "python-astunparse" = fetch {
    pname       = "python-astunparse";
    version     = "1.6.3";
    sources     = [{ filename = "mingw-w64-i686-python-astunparse-1.6.3-1-any.pkg.tar.zst"; sha256 = "a69234c163ab0bcac647590e8833266fe34a8d9527ead65f42b277a616210b5a"; }];
    buildInputs = [ python-six ];
  };

  "python-async-timeout" = fetch {
    pname       = "python-async-timeout";
    version     = "3.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-async-timeout-3.0.1-1-any.pkg.tar.zst"; sha256 = "a2716938e2ad89ab971a61d7f9aca0afabaa44da103dd017e2730fd7c7419974"; }];
    buildInputs = [ python ];
  };

  "python-atomicwrites" = fetch {
    pname       = "python-atomicwrites";
    version     = "1.4.0";
    sources     = [{ filename = "mingw-w64-i686-python-atomicwrites-1.4.0-1-any.pkg.tar.zst"; sha256 = "eeacc600c329284d0e61b1afc8add4ccaaff633ecd799bcc2e420bd2fce6d866"; }];
    buildInputs = [ python ];
  };

  "python-attrs" = fetch {
    pname       = "python-attrs";
    version     = "19.3.0";
    sources     = [{ filename = "mingw-w64-i686-python-attrs-19.3.0-1-any.pkg.tar.xz"; sha256 = "80b176e78771fc3603ea14d7543d60409fceeb70c3046d4a61aef53b93f3b0ff"; }];
    buildInputs = [ python ];
  };

  "python-audioread" = fetch {
    pname       = "python-audioread";
    version     = "2.1.8";
    sources     = [{ filename = "mingw-w64-i686-python-audioread-2.1.8-1-any.pkg.tar.zst"; sha256 = "57eca9949e28879e5011b1c91f7d21f3517cad773aebc970cd6ae035262dc668"; }];
    buildInputs = [ python ];
  };

  "python-babel" = fetch {
    pname       = "python-babel";
    version     = "2.8.0";
    sources     = [{ filename = "mingw-w64-i686-python-babel-2.8.0-1-any.pkg.tar.xz"; sha256 = "4a302dde6735e6285ff3dfd7856535d579c75a6c985c79c18009a539cf2f0d27"; }];
    buildInputs = [ python-pytz ];
  };

  "python-backcall" = fetch {
    pname       = "python-backcall";
    version     = "0.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-backcall-0.1.0-1-any.pkg.tar.xz"; sha256 = "4f5e1b3fba65b0c93dafb585df1882b2ee4ff28dd98057ae898c17a9485308d3"; }];
    buildInputs = [ python ];
  };

  "python-bcrypt" = fetch {
    pname       = "python-bcrypt";
    version     = "3.1.7";
    sources     = [{ filename = "mingw-w64-i686-python-bcrypt-3.1.7-1-any.pkg.tar.xz"; sha256 = "f1a4fbaf2d3fd380fc3739201bbaf1e2f60ae28644c0207af55d9633b04c5c09"; }];
    buildInputs = [ python python-cffi python-six ];
  };

  "python-beaker" = fetch {
    pname       = "python-beaker";
    version     = "1.11.0";
    sources     = [{ filename = "mingw-w64-i686-python-beaker-1.11.0-1-any.pkg.tar.xz"; sha256 = "f6e8c5951fe27c631176da98c98e65270a09473ea6e240ff5dbe65fe86a3faed"; }];
    buildInputs = [ python ];
  };

  "python-beautifulsoup4" = fetch {
    pname       = "python-beautifulsoup4";
    version     = "4.9.3";
    sources     = [{ filename = "mingw-w64-i686-python-beautifulsoup4-4.9.3-1-any.pkg.tar.zst"; sha256 = "fe61d3923d8e6cfaee66f163f29635723b4acc79b7f4cd7dd6930fa320004a9a"; }];
    buildInputs = [ python python-soupsieve ];
  };

  "python-binwalk" = fetch {
    pname       = "python-binwalk";
    version     = "2.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-binwalk-2.2.0-1-any.pkg.tar.xz"; sha256 = "fb14802f66a4e633b1bebca9ba02eb0489ce106b593a5fcc1ac0705e8988f9d1"; }];
    buildInputs = [ bzip2 libsystre python xz zlib ];
  };

  "python-biopython" = fetch {
    pname       = "python-biopython";
    version     = "1.78";
    sources     = [{ filename = "mingw-w64-i686-python-biopython-1.78-1-any.pkg.tar.zst"; sha256 = "0d6a7e0d9cc36c02df5df56c804670762493c29df9ec0ba562480902dff5937b"; }];
    buildInputs = [ python python-numpy ];
  };

  "python-biscuits" = fetch {
    pname       = "python-biscuits";
    version     = "0.3.0";
    sources     = [{ filename = "mingw-w64-i686-python-biscuits-0.3.0-1-any.pkg.tar.zst"; sha256 = "16558ec05a3b28d221a613c34c73e570a6e7061de3223a3dce813037bd86facb"; }];
    buildInputs = [ python ];
  };

  "python-bleach" = fetch {
    pname       = "python-bleach";
    version     = "3.1.3";
    sources     = [{ filename = "mingw-w64-i686-python-bleach-3.1.3-1-any.pkg.tar.xz"; sha256 = "d3528ed9601c04a21154159809758d1521da874f7f21014dc31cdb031fb83074"; }];
    buildInputs = [ python python-html5lib ];
  };

  "python-blinker" = fetch {
    pname       = "python-blinker";
    version     = "1.4";
    sources     = [{ filename = "mingw-w64-i686-python-blinker-1.4-1-any.pkg.tar.zst"; sha256 = "f784ef482bb4c58bde9a20a3907da19cb4343723ef98bd26c39d0d5e580fc290"; }];
    buildInputs = [ python ];
  };

  "python-breathe" = fetch {
    pname       = "python-breathe";
    version     = "4.15.0";
    sources     = [{ filename = "mingw-w64-i686-python-breathe-4.15.0-1-any.pkg.tar.xz"; sha256 = "f435f888fb1cbc256186fc865b4016e1137580831df7a62f855cc4ab8ba7affb"; }];
    buildInputs = [ python python-sphinx ];
  };

  "python-brotli" = fetch {
    pname       = "python-brotli";
    version     = "1.0.9";
    sources     = [{ filename = "mingw-w64-i686-python-brotli-1.0.9-1-any.pkg.tar.zst"; sha256 = "c2b666d8380863b57e18e90d35dcd72e6165bceb19e06345013d844e1f63a533"; }];
    buildInputs = [ python libwinpthread-git ];
  };

  "python-bsddb3" = fetch {
    pname       = "python-bsddb3";
    version     = "6.2.7";
    sources     = [{ filename = "mingw-w64-i686-python-bsddb3-6.2.7-1-any.pkg.tar.xz"; sha256 = "33d427439068755bba95122db1fb5f2eaea031046445ecc6f85393e232eb6ea8"; }];
    buildInputs = [ python db ];
  };

  "python-cachecontrol" = fetch {
    pname       = "python-cachecontrol";
    version     = "0.12.6";
    sources     = [{ filename = "mingw-w64-i686-python-cachecontrol-0.12.6-1-any.pkg.tar.xz"; sha256 = "9567892137316cd256ed05a286f71f82deddfbf8cf880f9c190718b8104fc418"; }];
    buildInputs = [ python python-msgpack python-requests ];
  };

  "python-cachetools" = fetch {
    pname       = "python-cachetools";
    version     = "4.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-cachetools-4.1.1-1-any.pkg.tar.zst"; sha256 = "0dbfdedb2418d39104f336f160aa790b7c81e62ae59c58df9745b20d1b585032"; }];
    buildInputs = [ python ];
  };

  "python-cairo" = fetch {
    pname       = "python-cairo";
    version     = "1.20.0";
    sources     = [{ filename = "mingw-w64-i686-python-cairo-1.20.0-1-any.pkg.tar.zst"; sha256 = "9344b07e65d172d91182c062c247faf61032d890022bd8982b8a8b498c14fd7a"; }];
    buildInputs = [ cairo python ];
  };

  "python-can" = fetch {
    pname       = "python-can";
    version     = "3.3.2";
    sources     = [{ filename = "mingw-w64-i686-python-can-3.3.2-1-any.pkg.tar.xz"; sha256 = "c03de279ee59c74fc8f4bfda0a9ec874c43aaafa295d83586146ec957895225f"; }];
    buildInputs = [ python python-python_ics python-pyserial ];
  };

  "python-capstone" = fetch {
    pname       = "python-capstone";
    version     = "4.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-capstone-4.0.2-1-any.pkg.tar.zst"; sha256 = "16a24c9c6158dfc8bd9cb18a6d9b424424f39e5d553314232a3c4ece3802c94e"; }];
    buildInputs = [ capstone python ];
  };

  "python-certifi" = fetch {
    pname       = "python-certifi";
    version     = "2019.11.28";
    sources     = [{ filename = "mingw-w64-i686-python-certifi-2019.11.28-1-any.pkg.tar.xz"; sha256 = "14cd1fd4811e465b91f25b527c9fb1da94c37262834db6978263515ed737f782"; }];
    buildInputs = [ python ];
  };

  "python-cffi" = fetch {
    pname       = "python-cffi";
    version     = "1.14.0";
    sources     = [{ filename = "mingw-w64-i686-python-cffi-1.14.0-2-any.pkg.tar.xz"; sha256 = "86c6522be373ba4a5c2c58fc8ffecb446cdeb3c3caa37660845f3905a5643a1c"; }];
    buildInputs = [ libffi python-pycparser ];
  };

  "python-characteristic" = fetch {
    pname       = "python-characteristic";
    version     = "14.3.0";
    sources     = [{ filename = "mingw-w64-i686-python-characteristic-14.3.0-1-any.pkg.tar.xz"; sha256 = "c957f90277a720133cffe0cdd03ad9e84f2a7c2fc369092221b72a786979c6ee"; }];
    buildInputs = [ python ];
  };

  "python-chardet" = fetch {
    pname       = "python-chardet";
    version     = "3.0.4";
    sources     = [{ filename = "mingw-w64-i686-python-chardet-3.0.4-1-any.pkg.tar.xz"; sha256 = "ef886a1e5e0003381d4dadeae13e0361fd34cc344aacd302060dd5974079b48f"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-click" = fetch {
    pname       = "python-click";
    version     = "7.1.2";
    sources     = [{ filename = "mingw-w64-i686-python-click-7.1.2-1-any.pkg.tar.zst"; sha256 = "56219acb580fa1a2d70e00de9c3fdca2398abab52f6550ecf191acb4d44d7944"; }];
    buildInputs = [ python ];
  };

  "python-cliff" = fetch {
    pname       = "python-cliff";
    version     = "3.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-cliff-3.1.0-1-any.pkg.tar.xz"; sha256 = "cf2ebb82efd39c2821dd7c2dfb426b985e7281f31009856611eb95e28112db7b"; }];
    buildInputs = [ python-six python-pbr python-cmd2 python-prettytable python-pyparsing python-stevedore python-yaml ];
  };

  "python-cmd2" = fetch {
    pname       = "python-cmd2";
    version     = "1.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-cmd2-1.0.2-1-any.pkg.tar.zst"; sha256 = "4225c16036261772d0babe1063c0e30b4986c264eebbfdda9d419179f575226d"; }];
    buildInputs = [ python-attrs python-pyparsing python-pyperclip python-pyreadline python-colorama python-wcwidth ];
  };

  "python-colorama" = fetch {
    pname       = "python-colorama";
    version     = "0.4.3";
    sources     = [{ filename = "mingw-w64-i686-python-colorama-0.4.3-1-any.pkg.tar.xz"; sha256 = "b3677d988b6cf973c923cb81cf1d08eac4a89c1cb4fd46c77f97fe9d11e55e37"; }];
    buildInputs = [ python ];
  };

  "python-colorspacious" = fetch {
    pname       = "python-colorspacious";
    version     = "1.1.2";
    sources     = [{ filename = "mingw-w64-i686-python-colorspacious-1.1.2-1-any.pkg.tar.xz"; sha256 = "3c39ded27783e5b37a3b53aed3267ca1f925bf642a92c5e8a4d4bc47363a1bbd"; }];
    buildInputs = [ python python-numpy ];
  };

  "python-colour" = fetch {
    pname       = "python-colour";
    version     = "0.3.13";
    sources     = [{ filename = "mingw-w64-i686-python-colour-0.3.13-1-any.pkg.tar.xz"; sha256 = "ac31f6420c6cb0d5b974f36df554cdfe03e389ee926295a46ae727d8a8aafa79"; }];
    buildInputs = [ python python-scipy python-six ];
  };

  "python-comtypes" = fetch {
    pname       = "python-comtypes";
    version     = "1.1.7";
    sources     = [{ filename = "mingw-w64-i686-python-comtypes-1.1.7-2-any.pkg.tar.xz"; sha256 = "61a208ad8c0f1d4464cdfa6b6634366887febbe2969008960c6195bb68983cff"; }];
    buildInputs = [ python ];
  };

  "python-contextlib2" = fetch {
    pname       = "python-contextlib2";
    version     = "0.6.0";
    sources     = [{ filename = "mingw-w64-i686-python-contextlib2-0.6.0-1-any.pkg.tar.xz"; sha256 = "16808cd7bb225f57f356043d59401be6138e1db7ec0f415d269b605aac381e84"; }];
    buildInputs = [ python ];
  };

  "python-coverage" = fetch {
    pname       = "python-coverage";
    version     = "5.2.1";
    sources     = [{ filename = "mingw-w64-i686-python-coverage-5.2.1-1-any.pkg.tar.zst"; sha256 = "2240cfc96e5e7f4dddfef7b7b207424217465b2e4dbd4156a294514be3d80a8b"; }];
    buildInputs = [ python ];
  };

  "python-crcmod" = fetch {
    pname       = "python-crcmod";
    version     = "1.7";
    sources     = [{ filename = "mingw-w64-i686-python-crcmod-1.7-1-any.pkg.tar.xz"; sha256 = "d864692b2fec4ce5e5b3f3389d56e8312d050508412b32faff3db348e8e7a68a"; }];
    buildInputs = [ python ];
  };

  "python-cryptography" = fetch {
    pname       = "python-cryptography";
    version     = "2.9.2";
    sources     = [{ filename = "mingw-w64-i686-python-cryptography-2.9.2-1-any.pkg.tar.zst"; sha256 = "128f779364bf9427004aac153acabe98fd1878ccd3daaf059220bfe77641b4e2"; }];
    buildInputs = [ python-cffi python-pyasn1 python-idna python-asn1crypto ];
  };

  "python-cssselect" = fetch {
    pname       = "python-cssselect";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-cssselect-1.1.0-1-any.pkg.tar.xz"; sha256 = "71b72f707284f4e72fca2ec06e2ad2a30c6c240b825bd339a8b8c8d42bc8ae6d"; }];
    buildInputs = [ python ];
  };

  "python-cvxopt" = fetch {
    pname       = "python-cvxopt";
    version     = "1.2.5";
    sources     = [{ filename = "mingw-w64-i686-python-cvxopt-1.2.5-1-any.pkg.tar.zst"; sha256 = "482ddd6d0fac4f6256716ccebd42fea17f59b0308dd0587eee46b70931303d68"; }];
    buildInputs = [ python openblas suitesparse gsl fftw dsdp glpk ];
  };

  "python-cx_Freeze" = fetch {
    pname       = "python-cx_Freeze";
    version     = "6.3";
    sources     = [{ filename = "mingw-w64-i686-python-cx_Freeze-6.3-1-any.pkg.tar.zst"; sha256 = "77c2c410cfd3e4cedee37e73c469c81c2786c8dfd21ab99cfc22a3f6b0c1a321"; }];
    buildInputs = [ python ];
  };

  "python-cycler" = fetch {
    pname       = "python-cycler";
    version     = "0.10.0";
    sources     = [{ filename = "mingw-w64-i686-python-cycler-0.10.0-1-any.pkg.tar.xz"; sha256 = "1a3df2a6c5a366ce020d80522b1947c4c9b3d940a1de402168a4a5daab393aef"; }];
    buildInputs = [ python python-six ];
  };

  "python-dateutil" = fetch {
    pname       = "python-dateutil";
    version     = "2.8.1";
    sources     = [{ filename = "mingw-w64-i686-python-dateutil-2.8.1-1-any.pkg.tar.xz"; sha256 = "7e0c371d125df015ab033d38c754949f39144420ab8bda7d4a555254d5cb122e"; }];
    buildInputs = [ python-six ];
  };

  "python-ddt" = fetch {
    pname       = "python-ddt";
    version     = "1.3.1";
    sources     = [{ filename = "mingw-w64-i686-python-ddt-1.3.1-1-any.pkg.tar.xz"; sha256 = "8038cf37633b8c873d85ec38fa8c1a5867db8cc1f22c3a65f56131b0d64c8f03"; }];
    buildInputs = [ python ];
  };

  "python-debtcollector" = fetch {
    pname       = "python-debtcollector";
    version     = "2.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-debtcollector-2.0.1-1-any.pkg.tar.xz"; sha256 = "71725d91163ef65cc4f471afd45f1832d01f1540c11372821ba61e5c97a5649d"; }];
    buildInputs = [ python python-six python-pbr python-babel python-wrapt ];
  };

  "python-decorator" = fetch {
    pname       = "python-decorator";
    version     = "4.4.2";
    sources     = [{ filename = "mingw-w64-i686-python-decorator-4.4.2-1-any.pkg.tar.xz"; sha256 = "932cfaca3464788a2e2f9640473b123b660d69e458fb64eeaa8ea3e486cc27aa"; }];
    buildInputs = [ python ];
  };

  "python-defusedxml" = fetch {
    pname       = "python-defusedxml";
    version     = "0.6.0";
    sources     = [{ filename = "mingw-w64-i686-python-defusedxml-0.6.0-1-any.pkg.tar.xz"; sha256 = "8e608137fc8a89d1bdb14a4e2c7f1af716a95d0763327107df880ff3cd03b26d"; }];
    buildInputs = [ python ];
  };

  "python-distlib" = fetch {
    pname       = "python-distlib";
    version     = "0.3.1";
    sources     = [{ filename = "mingw-w64-i686-python-distlib-0.3.1-1-any.pkg.tar.zst"; sha256 = "bc70345fe0a9a24bab03154b8084c3c19e8583c2c09ecb2445d0c25e4cb1d614"; }];
    buildInputs = [ python ];
  };

  "python-distutils-extra" = fetch {
    pname       = "python-distutils-extra";
    version     = "2.39";
    sources     = [{ filename = "mingw-w64-i686-python-distutils-extra-2.39-1-any.pkg.tar.xz"; sha256 = "94281cfa4530452eac7b80e2e8eea280ce73b80201e2444c469a3c0fa0b7c397"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python.version "3.3"; python) intltool ];
    broken      = true; # broken dependency python-distutils-extra -> intltool
  };

  "python-django" = fetch {
    pname       = "python-django";
    version     = "3.0.5";
    sources     = [{ filename = "mingw-w64-i686-python-django-3.0.5-1-any.pkg.tar.zst"; sha256 = "dd395f80f8b4397f529f6c33a8f4a4fb883c42bb1f3fedc07e1daafc462f985d"; }];
    buildInputs = [ python python-asgiref python-pytz python-sqlparse ];
  };

  "python-dlib" = fetch {
    pname       = "python-dlib";
    version     = "19.20";
    sources     = [{ filename = "mingw-w64-i686-python-dlib-19.20-1-any.pkg.tar.zst"; sha256 = "a01768456d75d17ff5793522f4ff42a9e268fa6b59153f40335a5b69f9dc609b"; }];
    buildInputs = [ dlib python ];
  };

  "python-dnspython" = fetch {
    pname       = "python-dnspython";
    version     = "1.16.0";
    sources     = [{ filename = "mingw-w64-i686-python-dnspython-1.16.0-1-any.pkg.tar.xz"; sha256 = "27f3a7819dace406f93247444305a3116403144fb1c6476ef6700e2bdea357e5"; }];
    buildInputs = [ python ];
  };

  "python-docutils" = fetch {
    pname       = "python-docutils";
    version     = "0.16";
    sources     = [{ filename = "mingw-w64-i686-python-docutils-0.16-1-any.pkg.tar.xz"; sha256 = "333a0a201941934766a5ec75ff02bc9782084f38af5bd4624a39589b11bbde2e"; }];
    buildInputs = [ python ];
  };

  "python-editor" = fetch {
    pname       = "python-editor";
    version     = "1.0.4";
    sources     = [{ filename = "mingw-w64-i686-python-editor-1.0.4-1-any.pkg.tar.xz"; sha256 = "96cbb6454a6a8cdbc3efc63afde3b56459a252ea9e1c09117409e8a5b65c0b21"; }];
    buildInputs = [ python ];
  };

  "python-email-validator" = fetch {
    pname       = "python-email-validator";
    version     = "1.0.5";
    sources     = [{ filename = "mingw-w64-i686-python-email-validator-1.0.5-1-any.pkg.tar.xz"; sha256 = "6ee7bcc16bf5c0b8fa274d37e904ed850bcf6bba4d11d6a29bc31b1b94b0f74e"; }];
    buildInputs = [ python python-dnspython python-idna ];
  };

  "python-entrypoints" = fetch {
    pname       = "python-entrypoints";
    version     = "0.3";
    sources     = [{ filename = "mingw-w64-i686-python-entrypoints-0.3-1-any.pkg.tar.xz"; sha256 = "c2ef07a0ac5f649fbd6f5b6a4aed94c61e375c205c4db8e064777778d61ee282"; }];
  };

  "python-et-xmlfile" = fetch {
    pname       = "python-et-xmlfile";
    version     = "1.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-et-xmlfile-1.0.1-1-any.pkg.tar.xz"; sha256 = "6e5b9f6115f773432306044508788819abf2a3f1364cfa94105a3b50766ed01c"; }];
    buildInputs = [ python-lxml ];
  };

  "python-eventlet" = fetch {
    pname       = "python-eventlet";
    version     = "0.25.1";
    sources     = [{ filename = "mingw-w64-i686-python-eventlet-0.25.1-1-any.pkg.tar.xz"; sha256 = "755c0945807eaaa3d8db1922f52317e52c01f0cb75d15c544b70fa6906044a98"; }];
    buildInputs = [ python python-greenlet python-monotonic ];
  };

  "python-execnet" = fetch {
    pname       = "python-execnet";
    version     = "1.7.1";
    sources     = [{ filename = "mingw-w64-i686-python-execnet-1.7.1-1-any.pkg.tar.xz"; sha256 = "f9906550f488661f38e3ddd797cb94e5b0301e137b13c080ea81a0bb24b1beb3"; }];
    buildInputs = [ python python-apipkg ];
  };

  "python-extras" = fetch {
    pname       = "python-extras";
    version     = "1.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-extras-1.0.0-1-any.pkg.tar.xz"; sha256 = "5c7f5802a4c81df7c33977e46e70307b29aac0f55a054c095ec2d63802e787af"; }];
    buildInputs = [ python ];
  };

  "python-faker" = fetch {
    pname       = "python-faker";
    version     = "4.0.3";
    sources     = [{ filename = "mingw-w64-i686-python-faker-4.0.3-1-any.pkg.tar.zst"; sha256 = "ba3292cfbb408e9e2a47484f127b57abc0ded2a71b69750dd971fa40c295c014"; }];
    buildInputs = [ python python-dateutil python-six python-text-unidecode ];
  };

  "python-fasteners" = fetch {
    pname       = "python-fasteners";
    version     = "0.15";
    sources     = [{ filename = "mingw-w64-i686-python-fasteners-0.15-1-any.pkg.tar.xz"; sha256 = "a93d81848cf405918e2f80e5e144486e3aee97d80c14d7c9c462db0b06b01494"; }];
    buildInputs = [ python python-six python-monotonic ];
  };

  "python-feedgenerator" = fetch {
    pname       = "python-feedgenerator";
    version     = "1.9.1";
    sources     = [{ filename = "mingw-w64-i686-python-feedgenerator-1.9.1-1-any.pkg.tar.zst"; sha256 = "9f8b745dc4b7dba13be9035d3837efef8556861180f869e384041dec1008cb74"; }];
    buildInputs = [ python python-pytz python-six ];
  };

  "python-ffmpeg-python" = fetch {
    pname       = "python-ffmpeg-python";
    version     = "0.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-ffmpeg-python-0.2.0-1-any.pkg.tar.zst"; sha256 = "6c70ddb2ad363077269ab956178086ff34469445987ca2dbc5f28eeba79a542b"; }];
    buildInputs = [ python-future ffmpeg ];
  };

  "python-filelock" = fetch {
    pname       = "python-filelock";
    version     = "3.0.12";
    sources     = [{ filename = "mingw-w64-i686-python-filelock-3.0.12-1-any.pkg.tar.xz"; sha256 = "97d5428204ab115026065784563d5cd427e999275ce16c60b11379a0f3c50191"; }];
    buildInputs = [ python ];
  };

  "python-fire" = fetch {
    pname       = "python-fire";
    version     = "0.3.1";
    sources     = [{ filename = "mingw-w64-i686-python-fire-0.3.1-1-any.pkg.tar.zst"; sha256 = "b2d629d05334a6fe6eeb9a17a4c1d927f09c92b6470a25ff251ead19aa84cb37"; }];
    buildInputs = [ python-termcolor ];
  };

  "python-fixtures" = fetch {
    pname       = "python-fixtures";
    version     = "3.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-fixtures-3.0.0-1-any.pkg.tar.xz"; sha256 = "061fcb2a9dccf204e3352b9c74e7328e32d1f7cf8387d036a8332285245d5453"; }];
    buildInputs = [ python python-pbr python-six ];
  };

  "python-flake8" = fetch {
    pname       = "python-flake8";
    version     = "3.7.9";
    sources     = [{ filename = "mingw-w64-i686-python-flake8-3.7.9-2-any.pkg.tar.xz"; sha256 = "8cfc842341215de6f844ff542be8a083fff10edbff85f371af11ca15c06b72eb"; }];
    buildInputs = [ python-pyflakes python-mccabe python-entrypoints python-pycodestyle ];
  };

  "python-flaky" = fetch {
    pname       = "python-flaky";
    version     = "3.6.1";
    sources     = [{ filename = "mingw-w64-i686-python-flaky-3.6.1-1-any.pkg.tar.xz"; sha256 = "f0a62dd607d50a1f14509873c9f5592fa3f02857bd590cb01680ead908d52eb4"; }];
    buildInputs = [ python ];
  };

  "python-flask" = fetch {
    pname       = "python-flask";
    version     = "1.1.2";
    sources     = [{ filename = "mingw-w64-i686-python-flask-1.1.2-1-any.pkg.tar.zst"; sha256 = "578470777937fef6e6a11f450420eb8b0b8a09484ecc318a26ae86391e1bacf6"; }];
    buildInputs = [ python-click python-itsdangerous python-jinja python-werkzeug ];
  };

  "python-flexmock" = fetch {
    pname       = "python-flexmock";
    version     = "0.10.4";
    sources     = [{ filename = "mingw-w64-i686-python-flexmock-0.10.4-1-any.pkg.tar.xz"; sha256 = "18da812890d83bc90a8cbc215a54aa8f1fc2c50087b4a3f44a24081e70c6af18"; }];
    buildInputs = [ python ];
  };

  "python-fonttools" = fetch {
    pname       = "python-fonttools";
    version     = "4.8.1";
    sources     = [{ filename = "mingw-w64-i686-python-fonttools-4.8.1-1-any.pkg.tar.zst"; sha256 = "34dfea5d9a57aaea8d8731bd2abfe083fc87abe1112fc28474ad5ddd9d138b94"; }];
    buildInputs = [ python python-numpy ];
  };

  "python-freezegun" = fetch {
    pname       = "python-freezegun";
    version     = "0.3.15";
    sources     = [{ filename = "mingw-w64-i686-python-freezegun-0.3.15-1-any.pkg.tar.xz"; sha256 = "3e9f3e80b2df3fbcb1b491b5e3e94306891cbd3bc573b705701b38809e11af60"; }];
    buildInputs = [ python python-dateutil ];
  };

  "python-funcsigs" = fetch {
    pname       = "python-funcsigs";
    version     = "1.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-funcsigs-1.0.2-1-any.pkg.tar.xz"; sha256 = "a78decd091e7c4f668b981ce07608c71f0fe74a1f7aa07d8e40d357cb89f66ac"; }];
  };

  "python-future" = fetch {
    pname       = "python-future";
    version     = "0.18.2";
    sources     = [{ filename = "mingw-w64-i686-python-future-0.18.2-1-any.pkg.tar.xz"; sha256 = "3066582cb5cb8e2787af1ad558e8da778bb76d440c3ebcd3a9882000795e7417"; }];
    buildInputs = [ python ];
  };

  "python-gast" = fetch {
    pname       = "python-gast";
    version     = "0.4.0";
    sources     = [{ filename = "mingw-w64-i686-python-gast-0.4.0-1-any.pkg.tar.zst"; sha256 = "b72153f67c3b70bf5586173858327034a111a83edf60b4f44b87a1bec803ad51"; }];
    buildInputs = [ python ];
  };

  "python-genty" = fetch {
    pname       = "python-genty";
    version     = "1.3.2";
    sources     = [{ filename = "mingw-w64-i686-python-genty-1.3.2-1-any.pkg.tar.xz"; sha256 = "f1fdbaa2360603c519880ee6c6a91c9f3ade72d3cf0cecdc88869e1367961540"; }];
    buildInputs = [ python python-six ];
  };

  "python-gmpy2" = fetch {
    pname       = "python-gmpy2";
    version     = "2.1.0b4";
    sources     = [{ filename = "mingw-w64-i686-python-gmpy2-2.1.0b4-3-any.pkg.tar.zst"; sha256 = "3779e4af250ec784a533487a680c57124cdf41985d2f25c2559e3616b382dd0b"; }];
    buildInputs = [ python mpc ];
  };

  "python-gobject" = fetch {
    pname       = "python-gobject";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-python-gobject-3.38.0-1-any.pkg.tar.zst"; sha256 = "beec6f2d04f258aee60e8b90a094828f2aa68f1ba8432c93465d1621a0942742"; }];
    buildInputs = [ glib2 python-cairo libffi gobject-introspection-runtime ];
  };

  "python-google-auth" = fetch {
    pname       = "python-google-auth";
    version     = "1.22.1";
    sources     = [{ filename = "mingw-w64-i686-python-google-auth-1.22.1-1-any.pkg.tar.zst"; sha256 = "0ce98e1b6d75353dc23ecb89cb787447b8fd00c5417bd76e39403d8f4a1c58a3"; }];
    buildInputs = [ ca-certificates python-cachetools python-pyasn1-modules python-rsa ];
  };

  "python-google-resumable-media" = fetch {
    pname       = "python-google-resumable-media";
    version     = "1.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-google-resumable-media-1.0.0-1-any.pkg.tar.zst"; sha256 = "0ae70306f1efbef976f2e54c43b2785e4c248df6d0181e7fd0586f84705a7814"; }];
    buildInputs = [ python-six ];
  };

  "python-googleapis-common-protos" = fetch {
    pname       = "python-googleapis-common-protos";
    version     = "1.52.0";
    sources     = [{ filename = "mingw-w64-i686-python-googleapis-common-protos-1.52.0-1-any.pkg.tar.zst"; sha256 = "28e95ba757d5d85519c5e4b97c20948352d2d5fb9bc4d1b1de9d85c3021415bf"; }];
    buildInputs = [ python-protobuf ];
  };

  "python-greenlet" = fetch {
    pname       = "python-greenlet";
    version     = "0.4.15";
    sources     = [{ filename = "mingw-w64-i686-python-greenlet-0.4.15-1-any.pkg.tar.xz"; sha256 = "70b57811b063c2f1e9198b5aa710a574bddfc6740a8da46b5b94edc79b34333d"; }];
    buildInputs = [ python ];
  };

  "python-gssapi" = fetch {
    pname       = "python-gssapi";
    version     = "1.6.5";
    sources     = [{ filename = "mingw-w64-i686-python-gssapi-1.6.5-1-any.pkg.tar.zst"; sha256 = "c3697950805f2881653ec0df501bc9efa00694635bcd95294d9480c5f7583c46"; }];
    buildInputs = [ python python-decorator python-six gss cython ];
  };

  "python-gsutil" = fetch {
    pname       = "python-gsutil";
    version     = "4.53";
    sources     = [{ filename = "mingw-w64-i686-python-gsutil-4.53-1-any.pkg.tar.zst"; sha256 = "d0055a8c2b0a4764192140ad0b80c64e11b16fcf460ddbbc12cc696c19051936"; }];
    buildInputs = [ python ];
  };

  "python-h5py" = fetch {
    pname       = "python-h5py";
    version     = "2.10.0";
    sources     = [{ filename = "mingw-w64-i686-python-h5py-2.10.0-1-any.pkg.tar.xz"; sha256 = "1d28e1ef025c4d6da7dd35456595ee0c9d9a45e1dfb40d843b27c8d63df70440"; }];
    buildInputs = [ python-numpy python-six hdf5 ];
  };

  "python-hacking" = fetch {
    pname       = "python-hacking";
    version     = "3.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-hacking-3.0.0-1-any.pkg.tar.zst"; sha256 = "24219c51b49f13f3e674e30f78d2982c909c60f1166973f5752a4d15b74c03c0"; }];
    buildInputs = [ python ];
  };

  "python-html5lib" = fetch {
    pname       = "python-html5lib";
    version     = "1.1";
    sources     = [{ filename = "mingw-w64-i686-python-html5lib-1.1-1-any.pkg.tar.zst"; sha256 = "ff040160b94bfd2db4d2773e7352d107fce248ca4b5a566dd810f26c9b0d84e6"; }];
    buildInputs = [ python python-six python-webencodings ];
  };

  "python-httplib2" = fetch {
    pname       = "python-httplib2";
    version     = "0.17.3";
    sources     = [{ filename = "mingw-w64-i686-python-httplib2-0.17.3-1-any.pkg.tar.zst"; sha256 = "50a033a5158958aecb617c8faf8df3a04990d5d8a712ae54c8fe42dfcc36b355"; }];
    buildInputs = [ python python-certifi ca-certificates ];
  };

  "python-hunter" = fetch {
    pname       = "python-hunter";
    version     = "3.1.3";
    sources     = [{ filename = "mingw-w64-i686-python-hunter-3.1.3-1-any.pkg.tar.zst"; sha256 = "6dc0025c3aeef52289a0748d44ca924e6e795755720cf41e264cf28c83720af2"; }];
    buildInputs = [ python-colorama python-manhole ];
  };

  "python-hypothesis" = fetch {
    pname       = "python-hypothesis";
    version     = "5.8.0";
    sources     = [{ filename = "mingw-w64-i686-python-hypothesis-5.8.0-1-any.pkg.tar.xz"; sha256 = "b3f20a3759d4bf038c5c3c09fddf9edfd8a0d90b25bde66f0c4f8f9c44ba6e47"; }];
    buildInputs = [ python python-attrs python-coverage python-sortedcontainers ];
  };

  "python-icu" = fetch {
    pname       = "python-icu";
    version     = "2.5";
    sources     = [{ filename = "mingw-w64-i686-python-icu-2.5-1-any.pkg.tar.zst"; sha256 = "e768d69aaec2d6ebce286120468fa0be8fedf2d101b5ec3f015ebe48a18597a3"; }];
    buildInputs = [ python icu ];
  };

  "python-idna" = fetch {
    pname       = "python-idna";
    version     = "2.9";
    sources     = [{ filename = "mingw-w64-i686-python-idna-2.9-1-any.pkg.tar.xz"; sha256 = "f4b0b871296a112c39d683286de8ff825f4340e2446870eb297ed1b0af31e56a"; }];
    buildInputs = [ python ];
  };

  "python-ifaddr" = fetch {
    pname       = "python-ifaddr";
    version     = "0.1.6";
    sources     = [{ filename = "mingw-w64-i686-python-ifaddr-0.1.6-1-any.pkg.tar.xz"; sha256 = "f69fbd7fb2b3ceba4689eb02f14ad0deaca0016f36eab40c8aa5b6d408c67527"; }];
    buildInputs = [ python ];
  };

  "python-imagecodecs" = fetch {
    pname       = "python-imagecodecs";
    version     = "2020.5.30";
    sources     = [{ filename = "mingw-w64-i686-python-imagecodecs-2020.5.30-1-any.pkg.tar.zst"; sha256 = "1c3ba685efe4831ffff1e6864a900ac4f5d605856c5bcd65aa898a6a65bb6cad"; }];
    buildInputs = [ blosc brotli jxrlib lcms2 libaec libjpeg libmng libpng libtiff libwebp openjpeg2 python-numpy snappy zopfli ];
  };

  "python-imageio" = fetch {
    pname       = "python-imageio";
    version     = "2.9.0";
    sources     = [{ filename = "mingw-w64-i686-python-imageio-2.9.0-2-any.pkg.tar.zst"; sha256 = "1c1e54ad8be36997287335b5e196a59cf3e237d5a01c892c9913bdd66566acb5"; }];
    buildInputs = [ python-numpy python-pillow ];
  };

  "python-imagesize" = fetch {
    pname       = "python-imagesize";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-imagesize-1.2.0-1-any.pkg.tar.xz"; sha256 = "94c4d19064476388ee04b980040a246e72fd042dc384f3430a7cab3a2bff5665"; }];
    buildInputs = [ python ];
  };

  "python-imbalanced-learn" = fetch {
    pname       = "python-imbalanced-learn";
    version     = "0.6.1";
    sources     = [{ filename = "mingw-w64-i686-python-imbalanced-learn-0.6.1-1-any.pkg.tar.xz"; sha256 = "e82abee6138217024a5ac200fdeff22b97dd621c5c77116c47be5f2fdc314961"; }];
    buildInputs = [ python python-joblib python-numpy python-scikit-learn python-scipy ];
  };

  "python-imgviz" = fetch {
    pname       = "python-imgviz";
    version     = "1.2.2";
    sources     = [{ filename = "mingw-w64-i686-python-imgviz-1.2.2-1-any.pkg.tar.zst"; sha256 = "f6544d0a7bcb4bf2314e8c3f1a3f1d376b89952036c46851fc082c15bf488947"; }];
    buildInputs = [ python-pillow python-numpy python-matplotlib python-yaml ];
  };

  "python-importlib-metadata" = fetch {
    pname       = "python-importlib-metadata";
    version     = "1.5.1";
    sources     = [{ filename = "mingw-w64-i686-python-importlib-metadata-1.5.1-1-any.pkg.tar.zst"; sha256 = "5396fa626456b42a81627d4b6318c1734f4cbedce9033fb550a3445b9c356354"; }];
    buildInputs = [ python python-zipp ];
  };

  "python-iniconfig" = fetch {
    pname       = "python-iniconfig";
    version     = "1.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-iniconfig-1.0.0-1-any.pkg.tar.xz"; sha256 = "9b4cde2806059e72ed21d14aa63e081df2045e136d00ab071d9ef6718f37b2d4"; }];
    buildInputs = [ python ];
  };

  "python-iocapture" = fetch {
    pname       = "python-iocapture";
    version     = "0.1.2";
    sources     = [{ filename = "mingw-w64-i686-python-iocapture-0.1.2-1-any.pkg.tar.xz"; sha256 = "eca82975dcbd630358628112b3fbcb334fa27347713e2e80b9acdecb345f5c1c"; }];
    buildInputs = [ python ];
  };

  "python-ipykernel" = fetch {
    pname       = "python-ipykernel";
    version     = "5.1.4";
    sources     = [{ filename = "mingw-w64-i686-python-ipykernel-5.1.4-1-any.pkg.tar.xz"; sha256 = "f47aef07e9bab57712090c306f4b1cbac848de38843f4f8a675f7272c77d499b"; }];
    buildInputs = [ python-ipython python-ipython_genutils python-pathlib2 python-pyzmq python-tornado python-traitlets python-jupyter_client ];
  };

  "python-ipython" = fetch {
    pname       = "python-ipython";
    version     = "7.13.0";
    sources     = [{ filename = "mingw-w64-i686-python-ipython-7.13.0-1-any.pkg.tar.xz"; sha256 = "778972f2f13f9fbb61964bef0e63bca88b4adc1d8051299a8302ffd576d4bbe4"; }];
    buildInputs = [ winpty sqlite3 python-jedi python-decorator python-pickleshare python-simplegeneric python-traitlets (assert stdenvNoCC.lib.versionAtLeast python-prompt_toolkit.version "2.0"; python-prompt_toolkit) python-pygments python-backcall python-pexpect python-colorama python-win_unicode_console ];
  };

  "python-ipython_genutils" = fetch {
    pname       = "python-ipython_genutils";
    version     = "0.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-ipython_genutils-0.2.0-1-any.pkg.tar.xz"; sha256 = "c9b7ccb9aea0354f5bef39cc8a2709ea39f08f69e19fd246714c4059419cd9f4"; }];
    buildInputs = [ python ];
  };

  "python-ipywidgets" = fetch {
    pname       = "python-ipywidgets";
    version     = "7.5.1";
    sources     = [{ filename = "mingw-w64-i686-python-ipywidgets-7.5.1-1-any.pkg.tar.xz"; sha256 = "0fd15022d17a826f902eb01623d75f109cd80cc6d88500cd104a7d6dcb372477"; }];
    buildInputs = [ python ];
  };

  "python-iso8601" = fetch {
    pname       = "python-iso8601";
    version     = "0.1.12";
    sources     = [{ filename = "mingw-w64-i686-python-iso8601-0.1.12-1-any.pkg.tar.xz"; sha256 = "f4919600436fd42f9d97dfc5f0bffe102f107019b1acf83a737297493a62dfff"; }];
    buildInputs = [ python ];
  };

  "python-isort" = fetch {
    pname       = "python-isort";
    version     = "4.3.21.2";
    sources     = [{ filename = "mingw-w64-i686-python-isort-4.3.21.2-2-any.pkg.tar.xz"; sha256 = "18bd4747d9c5846dc4c2633d8e1d5aa491c95e405c5c76f940e061266846aedc"; }];
    buildInputs = [ python ];
  };

  "python-itsdangerous" = fetch {
    pname       = "python-itsdangerous";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-itsdangerous-1.1.0-1-any.pkg.tar.zst"; sha256 = "5caaeb1b1d7e4662896dfe2333fbd72aed8ea9467873c4c139f08f1defd9dc62"; }];
    buildInputs = [ python ];
  };

  "python-jdcal" = fetch {
    pname       = "python-jdcal";
    version     = "1.4.1";
    sources     = [{ filename = "mingw-w64-i686-python-jdcal-1.4.1-1-any.pkg.tar.xz"; sha256 = "e88b5369a78975150c2822aa6aa51658ff358a70952f717f589ffb7dec242392"; }];
    buildInputs = [ python ];
  };

  "python-jedi" = fetch {
    pname       = "python-jedi";
    version     = "0.16.0";
    sources     = [{ filename = "mingw-w64-i686-python-jedi-0.16.0-1-any.pkg.tar.xz"; sha256 = "aa4a7a5c808030b3e51c06896f529b9f9ccc128349871b70e5cabb9f9d8de262"; }];
    buildInputs = [ python python-parso ];
  };

  "python-jinja" = fetch {
    pname       = "python-jinja";
    version     = "2.11.2";
    sources     = [{ filename = "mingw-w64-i686-python-jinja-2.11.2-1-any.pkg.tar.zst"; sha256 = "738ef55a09e2ebca544fd1e1450b089bacfebfd750cb92ae2eb1bf7eb2dc7ec0"; }];
    buildInputs = [ python-setuptools python-markupsafe ];
  };

  "python-joblib" = fetch {
    pname       = "python-joblib";
    version     = "0.14.1";
    sources     = [{ filename = "mingw-w64-i686-python-joblib-0.14.1-1-any.pkg.tar.xz"; sha256 = "b461d908ed84e90489661ccaa8d13e6e917c6b3dd1b711d3902c300c06b98578"; }];
    buildInputs = [ python ];
  };

  "python-json-rpc" = fetch {
    pname       = "python-json-rpc";
    version     = "1.12.2";
    sources     = [{ filename = "mingw-w64-i686-python-json-rpc-1.12.2-1-any.pkg.tar.xz"; sha256 = "595f0955638fa2f71a7efe307fec6438e4f42bafed18862cf3932c93cda4f43b"; }];
    buildInputs = [ python ];
  };

  "python-jsonschema" = fetch {
    pname       = "python-jsonschema";
    version     = "3.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-jsonschema-3.2.0-1-any.pkg.tar.xz"; sha256 = "4773f8e94f484c9d8900b7eb26fcc1deb619b6c46d8fdfe3f914e7a170777bb4"; }];
    buildInputs = [ python python-setuptools python-attrs python-pyrsistent python-importlib-metadata ];
  };

  "python-jupyter-nbconvert" = fetch {
    pname       = "python-jupyter-nbconvert";
    version     = "5.6.1";
    sources     = [{ filename = "mingw-w64-i686-python-jupyter-nbconvert-5.6.1-1-any.pkg.tar.xz"; sha256 = "c941e1b0ff8e185c10fadb9d0a5acc587f8cec26b787ff8be03a92a903f86d8b"; }];
    buildInputs = [ python python-defusedxml python-jupyter_client python-jupyter-nbformat python-pygments python-mistune python-jinja python-entrypoints python-traitlets python-pandocfilters python-bleach python-testpath ];
  };

  "python-jupyter-nbformat" = fetch {
    pname       = "python-jupyter-nbformat";
    version     = "4.4.0";
    sources     = [{ filename = "mingw-w64-i686-python-jupyter-nbformat-4.4.0-1-any.pkg.tar.xz"; sha256 = "6b378a2d0cc9154b8d200233023ca20807814ba903f5ef00e90d4b6a03e9951b"; }];
    buildInputs = [ python python-traitlets python-jsonschema python-jupyter_core ];
  };

  "python-jupyter_client" = fetch {
    pname       = "python-jupyter_client";
    version     = "6.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-jupyter_client-6.0.0-1-any.pkg.tar.xz"; sha256 = "f8e39af29031eb884950abbd60b245932bf803a64876d3839b72b053063a9ffa"; }];
    buildInputs = [ python python-dateutil python-entrypoints python-jupyter_core python-pyzmq python-tornado python-traitlets ];
  };

  "python-jupyter_console" = fetch {
    pname       = "python-jupyter_console";
    version     = "6.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-jupyter_console-6.1.0-1-any.pkg.tar.xz"; sha256 = "caae2de089b2abea391cb7a31a745a21c0dfb7adacc21bc7a8163a893b090816"; }];
    buildInputs = [ python python-jupyter_core python-jupyter_client python-colorama ];
  };

  "python-jupyter_core" = fetch {
    pname       = "python-jupyter_core";
    version     = "4.6.3";
    sources     = [{ filename = "mingw-w64-i686-python-jupyter_core-4.6.3-1-any.pkg.tar.xz"; sha256 = "6a77d5fbc6a317c2a228e243bc6f80796e05e4137c1f99fe400c59f6bb8ed33c"; }];
    buildInputs = [ python ];
  };

  "python-keras" = fetch {
    pname       = "python-keras";
    version     = "2.3.1";
    sources     = [{ filename = "mingw-w64-i686-python-keras-2.3.1-1-any.pkg.tar.xz"; sha256 = "0b9d646c6957f7e4b020a6ee3ed4863332030ef120c3766aa7e7f0d543bae11e"; }];
    buildInputs = [ python python-numpy python-scipy python-six python-yaml python-h5py python-keras_applications python-keras_preprocessing python-theano ];
  };

  "python-keras_applications" = fetch {
    pname       = "python-keras_applications";
    version     = "1.0.8";
    sources     = [{ filename = "mingw-w64-i686-python-keras_applications-1.0.8-1-any.pkg.tar.xz"; sha256 = "c884b7695d86d807c90303f7df43a935d3a901707a9dc93aa47df3037c062bd8"; }];
    buildInputs = [ python python-numpy python-h5py ];
  };

  "python-keras_preprocessing" = fetch {
    pname       = "python-keras_preprocessing";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-keras_preprocessing-1.1.0-1-any.pkg.tar.xz"; sha256 = "d0305beb25cc96d3ef393e589d22e02b6fd3fdd81a34a5b46b8d7f6f8a3cf96b"; }];
    buildInputs = [ python python-numpy python-six ];
  };

  "python-kiwisolver" = fetch {
    pname       = "python-kiwisolver";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-kiwisolver-1.1.0-1-any.pkg.tar.xz"; sha256 = "0b6031c9d65e9fb82f217c4293989d8e5624fd221e9be5ec3a2118fe86da3f64"; }];
    buildInputs = [ python ];
  };

  "python-labelme" = fetch {
    pname       = "python-labelme";
    version     = "4.5.6";
    sources     = [{ filename = "mingw-w64-i686-python-labelme-4.5.6-1-any.pkg.tar.zst"; sha256 = "ee53670a8a3135f9c54dbe102ffea34dc8674ba900edb29f6e0f13afce0619fb"; }];
    buildInputs = [ python-imgviz python-termcolor python-qtpy ];
  };

  "python-lazy-object-proxy" = fetch {
    pname       = "python-lazy-object-proxy";
    version     = "1.4.3";
    sources     = [{ filename = "mingw-w64-i686-python-lazy-object-proxy-1.4.3-1-any.pkg.tar.xz"; sha256 = "f97999c953d324cfeaad13fcdc16b0d6586a9c95375aefa50c2e5ad742d9a988"; }];
    buildInputs = [ python ];
  };

  "python-ldap" = fetch {
    pname       = "python-ldap";
    version     = "3.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-ldap-3.2.0-1-any.pkg.tar.xz"; sha256 = "258d9cbb18bdb2ebb79d5bf1911e6b2ed6bdd8c69da32bff0dafdc14dc477c8d"; }];
    buildInputs = [ python ];
  };

  "python-ldap3" = fetch {
    pname       = "python-ldap3";
    version     = "2.7";
    sources     = [{ filename = "mingw-w64-i686-python-ldap3-2.7-1-any.pkg.tar.xz"; sha256 = "eb4c1ac840f3ecd366169946cca9bca4c796eb9d7ae51de6a0502932e86293e9"; }];
    buildInputs = [ python ];
  };

  "python-lhafile" = fetch {
    pname       = "python-lhafile";
    version     = "0.2.2";
    sources     = [{ filename = "mingw-w64-i686-python-lhafile-0.2.2-1-any.pkg.tar.xz"; sha256 = "9e9ae9ebad394e559b7f31b479fe656321a833d5b52c8eb633928ebb14ed63fc"; }];
    buildInputs = [ python python-six ];
  };

  "python-llvmlite" = fetch {
    pname       = "python-llvmlite";
    version     = "0.34.0";
    sources     = [{ filename = "mingw-w64-i686-python-llvmlite-0.34.0-4-any.pkg.tar.zst"; sha256 = "6452736bb48069704adc5ddc6e49a2ed5d7bd80d9b3268fa48d8b04aec21490b"; }];
    buildInputs = [ python (assert stdenvNoCC.lib.versionAtLeast polly.version "10.0.1"; polly) ];
  };

  "python-lockfile" = fetch {
    pname       = "python-lockfile";
    version     = "0.12.2";
    sources     = [{ filename = "mingw-w64-i686-python-lockfile-0.12.2-1-any.pkg.tar.xz"; sha256 = "d504e724e292bcffa84fd8a64fc177403b68406cd12d1ecb78ad5998b3fe380a"; }];
    buildInputs = [ python ];
  };

  "python-lxml" = fetch {
    pname       = "python-lxml";
    version     = "4.6.1";
    sources     = [{ filename = "mingw-w64-i686-python-lxml-4.6.1-1-any.pkg.tar.zst"; sha256 = "3ea72069cbdd0344b4badea352093125ca5cfdff9efee86372e3bb766764c1d2"; }];
    buildInputs = [ libxml2 libxslt python ];
  };

  "python-lz4" = fetch {
    pname       = "python-lz4";
    version     = "2.2.1";
    sources     = [{ filename = "mingw-w64-i686-python-lz4-2.2.1-2-any.pkg.tar.xz"; sha256 = "7e0e103d5e91b699acc0ee16f453e88d7d19cedb86969c4706ec27c9803adabe"; }];
    buildInputs = [ python ];
  };

  "python-lzo" = fetch {
    pname       = "python-lzo";
    version     = "1.12";
    sources     = [{ filename = "mingw-w64-i686-python-lzo-1.12-2-any.pkg.tar.zst"; sha256 = "d311ecf6766a47de8cc014055248d6388e27dcc1dc0d7727bc3188d06e7f5376"; }];
    buildInputs = [ python lzo2 ];
  };

  "python-mako" = fetch {
    pname       = "python-mako";
    version     = "1.1.2";
    sources     = [{ filename = "mingw-w64-i686-python-mako-1.1.2-1-any.pkg.tar.xz"; sha256 = "7e178d0f80c91907fb7e9bc93af25f54b87130a3c4685599ef7047c2402ce996"; }];
    buildInputs = [ python-markupsafe python-beaker ];
  };

  "python-mallard-ducktype" = fetch {
    pname       = "python-mallard-ducktype";
    version     = "1.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-mallard-ducktype-1.0.2-1-any.pkg.tar.xz"; sha256 = "ac3efe5dfa0d50387f2b5db0ff9543d372b8a97b8755871b8557719c71bbd51d"; }];
    buildInputs = [ python ];
  };

  "python-manhole" = fetch {
    pname       = "python-manhole";
    version     = "1.6.0";
    sources     = [{ filename = "mingw-w64-i686-python-manhole-1.6.0-1-any.pkg.tar.zst"; sha256 = "975db30c850692c89b4c5b5c3c64c6ffec303d60a652166ca517bfee0d74fc69"; }];
    buildInputs = [ python ];
  };

  "python-markdown" = fetch {
    pname       = "python-markdown";
    version     = "3.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-markdown-3.1.1-1-any.pkg.tar.xz"; sha256 = "eb5552f9a6894d5f897fc4c618e779140f13820c832bed9a6210ddec1d66a573"; }];
    buildInputs = [ python ];
  };

  "python-markdown-math" = fetch {
    pname       = "python-markdown-math";
    version     = "0.6";
    sources     = [{ filename = "mingw-w64-i686-python-markdown-math-0.6-1-any.pkg.tar.xz"; sha256 = "2e79a50ada88a5833da050bc75679ea16788f22d19e3c54f89f34b2b0be2bc48"; }];
    buildInputs = [ python python-markdown ];
  };

  "python-markups" = fetch {
    pname       = "python-markups";
    version     = "3.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-markups-3.0.0-1-any.pkg.tar.xz"; sha256 = "54cabbab9bde8f3a0bae55f4565d352055307d5e761d54d6f8946c180a9c2ddc"; }];
    buildInputs = [ python python-markdown-math python-setuptools ];
  };

  "python-markupsafe" = fetch {
    pname       = "python-markupsafe";
    version     = "1.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-markupsafe-1.1.1-1-any.pkg.tar.xz"; sha256 = "a1e69b4b28f82bf88ff38c443322c6ee94ef0e59b1fd65ad4d7704df69ef8689"; }];
    buildInputs = [ python ];
  };

  "python-matplotlib" = fetch {
    pname       = "python-matplotlib";
    version     = "3.2.2";
    sources     = [{ filename = "mingw-w64-i686-python-matplotlib-3.2.2-1-any.pkg.tar.zst"; sha256 = "5d7cc32981fbbc7be0faa9f3b17745e6b5873093f794e7f65a786ffe564341f8"; }];
    buildInputs = [ python-pytz python-numpy python-cycler python-dateutil python-pyparsing python-kiwisolver freetype libpng ];
  };

  "python-mccabe" = fetch {
    pname       = "python-mccabe";
    version     = "0.6.1";
    sources     = [{ filename = "mingw-w64-i686-python-mccabe-0.6.1-1-any.pkg.tar.xz"; sha256 = "8906aca5132696208054e8ebc16906c010bff823c37f7e5c83d9509c414dabe3"; }];
    buildInputs = [ python ];
  };

  "python-mimeparse" = fetch {
    pname       = "python-mimeparse";
    version     = "1.6.0";
    sources     = [{ filename = "mingw-w64-i686-python-mimeparse-1.6.0-1-any.pkg.tar.xz"; sha256 = "dd8f81b4e7cc87828abdf66dbede197be76c2bceb01b2e99b108efb98b2f5f03"; }];
    buildInputs = [ python ];
  };

  "python-mistune" = fetch {
    pname       = "python-mistune";
    version     = "0.8.4";
    sources     = [{ filename = "mingw-w64-i686-python-mistune-0.8.4-1-any.pkg.tar.xz"; sha256 = "906f690fe5c0f29ea4fb663d12eef767a52239928b348ae2aea79fe1bf1141c9"; }];
    buildInputs = [  ];
  };

  "python-mock" = fetch {
    pname       = "python-mock";
    version     = "4.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-mock-4.0.1-1-any.pkg.tar.xz"; sha256 = "5c665bf21c6b2d300e70ae78bdabf902e60e61fef1910857a66dda159bd47d28"; }];
    buildInputs = [ python python-six python-pbr ];
  };

  "python-monotonic" = fetch {
    pname       = "python-monotonic";
    version     = "1.5";
    sources     = [{ filename = "mingw-w64-i686-python-monotonic-1.5-1-any.pkg.tar.xz"; sha256 = "dfb8324ab608dfb2ec03a56fd5c5934117bbc6698ab17f3f4deb44c3260a1f9f"; }];
    buildInputs = [ python ];
  };

  "python-more-itertools" = fetch {
    pname       = "python-more-itertools";
    version     = "8.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-more-itertools-8.2.0-1-any.pkg.tar.xz"; sha256 = "8aae266703253673ddcfe385e8e3f5b996764581bbcaf485c31f24b6f7dd2d52"; }];
    buildInputs = [ python ];
  };

  "python-mox3" = fetch {
    pname       = "python-mox3";
    version     = "1.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-mox3-1.0.0-1-any.pkg.tar.xz"; sha256 = "c489adcedc6b4eb3b3715a6e384b30facf00ba7cc886c12ba79c1dddf57460b1"; }];
    buildInputs = [ python python-pbr python-fixtures ];
  };

  "python-mpmath" = fetch {
    pname       = "python-mpmath";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-mpmath-1.1.0-1-any.pkg.tar.xz"; sha256 = "ef3731b95bf06c44ca97af5cb3cc0810805ca21c675e46a16b266d78f6875550"; }];
    buildInputs = [ python python-gmpy2 ];
  };

  "python-msgpack" = fetch {
    pname       = "python-msgpack";
    version     = "1.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-msgpack-1.0.0-1-any.pkg.tar.xz"; sha256 = "70f3501ecc7678ceb9e8ccf53ec4be397240405e3b8c2ae5da4d4c8098b8db3b"; }];
    buildInputs = [ python ];
  };

  "python-multidict" = fetch {
    pname       = "python-multidict";
    version     = "4.7.6";
    sources     = [{ filename = "mingw-w64-i686-python-multidict-4.7.6-1-any.pkg.tar.zst"; sha256 = "f18894c04f685f672a2c14b923302bffaf06117648c4484aa7d9e0f671ec15ee"; }];
    buildInputs = [ python-numpy ];
  };

  "python-ndg-httpsclient" = fetch {
    pname       = "python-ndg-httpsclient";
    version     = "0.5.1";
    sources     = [{ filename = "mingw-w64-i686-python-ndg-httpsclient-0.5.1-1-any.pkg.tar.xz"; sha256 = "620e0a7618422ff2a934092e28376cf1116db4a3f7031340d6d15cf4662d7f6b"; }];
    buildInputs = [ python-pyopenssl python-pyasn1 ];
  };

  "python-netaddr" = fetch {
    pname       = "python-netaddr";
    version     = "0.7.19";
    sources     = [{ filename = "mingw-w64-i686-python-netaddr-0.7.19-1-any.pkg.tar.xz"; sha256 = "544ea1d42683b09c798c94b6543c169963c5a3d97cbd51d801876854cd539bfe"; }];
    buildInputs = [ python ];
  };

  "python-netifaces" = fetch {
    pname       = "python-netifaces";
    version     = "0.10.9";
    sources     = [{ filename = "mingw-w64-i686-python-netifaces-0.10.9-1-any.pkg.tar.xz"; sha256 = "4768ae90f3f911f32d251327bb9b24dfa0703efc2ce276751c0e95da2313a4bc"; }];
    buildInputs = [ python ];
  };

  "python-networkx" = fetch {
    pname       = "python-networkx";
    version     = "2.4";
    sources     = [{ filename = "mingw-w64-i686-python-networkx-2.4-1-any.pkg.tar.xz"; sha256 = "9ebd21f9794795c852663cd3d911bf195b52f8b47e3583a1c5443ee7321de74f"; }];
    buildInputs = [ python python-decorator ];
  };

  "python-nose" = fetch {
    pname       = "python-nose";
    version     = "1.3.7";
    sources     = [{ filename = "mingw-w64-i686-python-nose-1.3.7-1-any.pkg.tar.xz"; sha256 = "6ba881a6e40e26def442fa0c70aa17ab2dfb349556f0c971704751c9f5595877"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-nuitka" = fetch {
    pname       = "python-nuitka";
    version     = "0.6.7";
    sources     = [{ filename = "mingw-w64-i686-python-nuitka-0.6.7-1-any.pkg.tar.xz"; sha256 = "7d025106c6b7596cd19362f13ed8c1233db22e8b1c2e83ab7bf6eeca7931c8b0"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-numba" = fetch {
    pname       = "python-numba";
    version     = "0.51.2";
    sources     = [{ filename = "mingw-w64-i686-python-numba-0.51.2-1-any.pkg.tar.zst"; sha256 = "cb105162b8e9e0b3435fae9c3039f1be694f4fa82a8787e86b356bf668e3d5ca"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python-llvmlite.version "0.34.0"; python-llvmlite) (assert stdenvNoCC.lib.versionAtLeast python-numpy.version "1.15"; python-numpy) ];
  };

  "python-numexpr" = fetch {
    pname       = "python-numexpr";
    version     = "2.7.1";
    sources     = [{ filename = "mingw-w64-i686-python-numexpr-2.7.1-1-any.pkg.tar.xz"; sha256 = "c1b08d8ba4c6eb201319cb06b56c123bd904ff3b3cffe5a8bd4c78ebb8787b59"; }];
    buildInputs = [ python-numpy ];
  };

  "python-numpy" = fetch {
    pname       = "python-numpy";
    version     = "1.19.2";
    sources     = [{ filename = "mingw-w64-i686-python-numpy-1.19.2-1-any.pkg.tar.zst"; sha256 = "0f86e229e8892012870445516e83bc2b87bdfa53e4816d473b1e09a6965223e8"; }];
    buildInputs = [ openblas python ];
  };

  "python-nvidia-ml" = fetch {
    pname       = "python-nvidia-ml";
    version     = "7.352.0";
    sources     = [{ filename = "mingw-w64-i686-python-nvidia-ml-7.352.0-1-any.pkg.tar.xz"; sha256 = "48760d1cfccaa7a503cc8f946c2a047ce9907ed45746c1542e96825e37bf2fd4"; }];
    buildInputs = [ python ];
  };

  "python-oauth2client" = fetch {
    pname       = "python-oauth2client";
    version     = "4.1.3";
    sources     = [{ filename = "mingw-w64-i686-python-oauth2client-4.1.3-1-any.pkg.tar.zst"; sha256 = "96f7fff27ed7362bd51712778deb22812825ce091a38af3d79ef923dfc9f29f4"; }];
    buildInputs = [ python-httplib2 python-pyasn1 python-pyasn1-modules python-rsa python-six ];
  };

  "python-olefile" = fetch {
    pname       = "python-olefile";
    version     = "0.46";
    sources     = [{ filename = "mingw-w64-i686-python-olefile-0.46-1-any.pkg.tar.xz"; sha256 = "515ce1285ce01f4f02a4d78ccb4bd170011fbac8539fcfc785d25b802009f249"; }];
    buildInputs = [ python ];
  };

  "python-openmdao" = fetch {
    pname       = "python-openmdao";
    version     = "3.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-openmdao-3.0.0-1-any.pkg.tar.xz"; sha256 = "780da8311442c173b98261781a46c0a657379dbc4184880617edfe03d229b952"; }];
    buildInputs = [ python-numpy python-scipy python-networkx python-sqlitedict python-pyparsing python-six ];
  };

  "python-openpyxl" = fetch {
    pname       = "python-openpyxl";
    version     = "3.0.3";
    sources     = [{ filename = "mingw-w64-i686-python-openpyxl-3.0.3-1-any.pkg.tar.xz"; sha256 = "d9cdb495ea5cd99499b982c5737d26735997c498bfc67b6b34c4662c071b41f2"; }];
    buildInputs = [ python-jdcal python-et-xmlfile python-defusedxml python-pandas python-pillow ];
  };

  "python-opt_einsum" = fetch {
    pname       = "python-opt_einsum";
    version     = "3.3.0";
    sources     = [{ filename = "mingw-w64-i686-python-opt_einsum-3.3.0-1-any.pkg.tar.zst"; sha256 = "e8390c2f271393417e4a9335fe931f203774801d364c62610c98dbe1638b83a3"; }];
    buildInputs = [ python ];
  };

  "python-ordered-set" = fetch {
    pname       = "python-ordered-set";
    version     = "3.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-ordered-set-3.1.1-1-any.pkg.tar.xz"; sha256 = "d6a844fd18ba6c5e76bcf1544b9373c2a2ea415df31e8ea94aa5c83419b6f11e"; }];
    buildInputs = [ python ];
  };

  "python-oslo-concurrency" = fetch {
    pname       = "python-oslo-concurrency";
    version     = "4.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-oslo-concurrency-4.0.2-1-any.pkg.tar.zst"; sha256 = "7f7e186874eea542c28abc0c37e815462a18bc46071b837a56645ddea7e222c8"; }];
    buildInputs = [ python python-six python-pbr python-oslo-config python-oslo-i18n python-oslo-utils python-fasteners ];
  };

  "python-oslo-config" = fetch {
    pname       = "python-oslo-config";
    version     = "8.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-oslo-config-8.0.2-1-any.pkg.tar.zst"; sha256 = "1f4b3dc5bc1c7930d92253f42bb0b45903ab58b158a9795e7985494368a1cd2e"; }];
    buildInputs = [ python python-six python-netaddr python-stevedore python-debtcollector python-oslo-i18n python-rfc3986 python-yaml ];
  };

  "python-oslo-context" = fetch {
    pname       = "python-oslo-context";
    version     = "3.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-oslo-context-3.0.2-1-any.pkg.tar.zst"; sha256 = "1409ac5e046b7348f483b9c6b4af27cabb3853905989a3304d7a892c319138d2"; }];
    buildInputs = [ python python-pbr python-debtcollector ];
  };

  "python-oslo-db" = fetch {
    pname       = "python-oslo-db";
    version     = "8.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-oslo-db-8.1.0-1-any.pkg.tar.zst"; sha256 = "4698cc3ec7d1cd0d8a81553aac07d2254aaa372ab1ed3dfdd4f1a7ef7be3590c"; }];
    buildInputs = [ python python-six python-pbr python-alembic python-debtcollector python-oslo-i18n python-oslo-config python-oslo-utils python-sqlalchemy python-sqlalchemy-migrate python-stevedore ];
  };

  "python-oslo-i18n" = fetch {
    pname       = "python-oslo-i18n";
    version     = "4.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-oslo-i18n-4.0.1-1-any.pkg.tar.zst"; sha256 = "591b85405d67b0c8258563b1f1265d560f3b83d0bb5ca8accfa16a1c63253dc9"; }];
    buildInputs = [ python python-six python-pbr python-babel ];
  };

  "python-oslo-log" = fetch {
    pname       = "python-oslo-log";
    version     = "4.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-oslo-log-4.1.1-1-any.pkg.tar.zst"; sha256 = "273924126a93a9f2f4a572760964acce9849f3e0a23e6e3849e1f7e1c5d2f03f"; }];
    buildInputs = [ python python-six python-pbr python-oslo-config python-oslo-context python-oslo-i18n python-oslo-utils python-oslo-serialization python-debtcollector python-dateutil python-monotonic ];
  };

  "python-oslo-serialization" = fetch {
    pname       = "python-oslo-serialization";
    version     = "3.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-oslo-serialization-3.1.1-1-any.pkg.tar.zst"; sha256 = "a6edb24e40b8f86c157b690e647c6b158b2462a2c7e7f35a452d03b1934a1024"; }];
    buildInputs = [ python python-six python-pbr python-babel python-msgpack python-oslo-utils python-pytz ];
  };

  "python-oslo-utils" = fetch {
    pname       = "python-oslo-utils";
    version     = "4.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-oslo-utils-4.1.1-1-any.pkg.tar.zst"; sha256 = "57505a8e8a0d9542dc703d37f30096d1ede8425d4324b06e172ca48a7398c5e1"; }];
    buildInputs = [ python ];
  };

  "python-oslosphinx" = fetch {
    pname       = "python-oslosphinx";
    version     = "4.18.0";
    sources     = [{ filename = "mingw-w64-i686-python-oslosphinx-4.18.0-1-any.pkg.tar.xz"; sha256 = "823b34cc5ff9d97186316e8256d24413667129fa5374a35d05e62e675d3e0b57"; }];
    buildInputs = [ python python-six python-requests ];
  };

  "python-oslotest" = fetch {
    pname       = "python-oslotest";
    version     = "4.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-oslotest-4.2.0-1-any.pkg.tar.xz"; sha256 = "4100f0d81426ef4dfdd95d1b0c38c85b68599ced57097a673cf31d9c7726d9b0"; }];
    buildInputs = [ python ];
  };

  "python-packaging" = fetch {
    pname       = "python-packaging";
    version     = "20.3";
    sources     = [{ filename = "mingw-w64-i686-python-packaging-20.3-1-any.pkg.tar.xz"; sha256 = "3c49befa7ab8b0563513aee147e3e864ec4c2e9fe5e2d100bf898846caa50209"; }];
    buildInputs = [ python python-pyparsing python-six python-attrs ];
  };

  "python-pandas" = fetch {
    pname       = "python-pandas";
    version     = "1.0.5";
    sources     = [{ filename = "mingw-w64-i686-python-pandas-1.0.5-1-any.pkg.tar.zst"; sha256 = "ec0a5679195616ed77636ff635307068e2adda59e91e09a04717f14da2937e24"; }];
    buildInputs = [ python-numpy python-pytz python-dateutil ];
  };

  "python-pandocfilters" = fetch {
    pname       = "python-pandocfilters";
    version     = "1.4.2";
    sources     = [{ filename = "mingw-w64-i686-python-pandocfilters-1.4.2-1-any.pkg.tar.xz"; sha256 = "19990160da0736834d53fc01e9ac774a45138e305da97d99fd36de623019088e"; }];
    buildInputs = [ python ];
  };

  "python-parameterized" = fetch {
    pname       = "python-parameterized";
    version     = "0.7.4";
    sources     = [{ filename = "mingw-w64-i686-python-parameterized-0.7.4-1-any.pkg.tar.zst"; sha256 = "e349a3097c88d4117c9222b5f6c293783b8e63023b884ce45cf934c55dad26c3"; }];
    buildInputs = [ python ];
  };

  "python-paramiko" = fetch {
    pname       = "python-paramiko";
    version     = "2.7.1";
    sources     = [{ filename = "mingw-w64-i686-python-paramiko-2.7.1-1-any.pkg.tar.xz"; sha256 = "2f65aecc3941b8082b8b6560797ccc6cead256b8f1003d7ae061e82e4b8c4c26"; }];
    buildInputs = [ python ];
  };

  "python-parso" = fetch {
    pname       = "python-parso";
    version     = "0.6.2";
    sources     = [{ filename = "mingw-w64-i686-python-parso-0.6.2-1-any.pkg.tar.xz"; sha256 = "a9473572dbd52e8de16ff8d7ebf8896651b65dbda215a7dc0242175288c067ac"; }];
    buildInputs = [ python ];
  };

  "python-path" = fetch {
    pname       = "python-path";
    version     = "13.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-path-13.2.0-1-any.pkg.tar.xz"; sha256 = "e9fce6dc07b4b50d20a7bdb52398993b28897f2989e1c35fc0edf9e74cb944ff"; }];
    buildInputs = [ python python-importlib-metadata ];
  };

  "python-pathlib2" = fetch {
    pname       = "python-pathlib2";
    version     = "2.3.5";
    sources     = [{ filename = "mingw-w64-i686-python-pathlib2-2.3.5-1-any.pkg.tar.xz"; sha256 = "fb5f59cf0d25ecf2ad9b420cf0fb812f75b20062e3ede457d6f5a54f19ddae16"; }];
    buildInputs = [ python python-scandir ];
  };

  "python-pathtools" = fetch {
    pname       = "python-pathtools";
    version     = "0.1.2";
    sources     = [{ filename = "mingw-w64-i686-python-pathtools-0.1.2-1-any.pkg.tar.xz"; sha256 = "3f176a7bd2ea4b386cf18d701bd415379a4d8f9d2f08d4e5ef6bdeacaf349281"; }];
    buildInputs = [ python ];
  };

  "python-patsy" = fetch {
    pname       = "python-patsy";
    version     = "0.5.1";
    sources     = [{ filename = "mingw-w64-i686-python-patsy-0.5.1-1-any.pkg.tar.xz"; sha256 = "39465f115118a88d4cae61a5e9f0d01e40507a1dddf7362b3b9337b5920ce71a"; }];
    buildInputs = [ python-numpy ];
  };

  "python-pbr" = fetch {
    pname       = "python-pbr";
    version     = "5.4.4";
    sources     = [{ filename = "mingw-w64-i686-python-pbr-5.4.4-1-any.pkg.tar.xz"; sha256 = "fee1dc2b3692a778bf182e3029406faa898733a63e5ed8c64e0e0a5c067424a7"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-pdfrw" = fetch {
    pname       = "python-pdfrw";
    version     = "0.4";
    sources     = [{ filename = "mingw-w64-i686-python-pdfrw-0.4-1-any.pkg.tar.xz"; sha256 = "d99424bea45b9381d8a6c1b9d1062fa453696449dad5d651c2653403c021ef8c"; }];
    buildInputs = [ python ];
  };

  "python-pep517" = fetch {
    pname       = "python-pep517";
    version     = "0.8.2";
    sources     = [{ filename = "mingw-w64-i686-python-pep517-0.8.2-1-any.pkg.tar.zst"; sha256 = "845c41ff9d306b7d8eaabeb7288388e0e1bec91ea9a2f35e28ddf5d697dac4a9"; }];
    buildInputs = [ python ];
  };

  "python-pexpect" = fetch {
    pname       = "python-pexpect";
    version     = "4.8.0";
    sources     = [{ filename = "mingw-w64-i686-python-pexpect-4.8.0-1-any.pkg.tar.xz"; sha256 = "49f5af9957bfb6fb51f9ee322b54a2af6fd2696b87c2b1a2f7e17a67c8a5941e"; }];
    buildInputs = [ python python-ptyprocess ];
  };

  "python-pgen2" = fetch {
    pname       = "python-pgen2";
    version     = "0.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-pgen2-0.1.0-1-any.pkg.tar.xz"; sha256 = "d30c66d16a16b8cbe4c9b49609107f04c7ada4c2064fbeec5a714da1f5f006ed"; }];
    buildInputs = [ python ];
  };

  "python-pickleshare" = fetch {
    pname       = "python-pickleshare";
    version     = "0.7.5";
    sources     = [{ filename = "mingw-w64-i686-python-pickleshare-0.7.5-1-any.pkg.tar.xz"; sha256 = "d0daa34f758d624ada2421765a6b611bd7938be4d46ec655128e9b1b86a0a614"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python-path.version "8.1"; python-path) ];
  };

  "python-pillow" = fetch {
    pname       = "python-pillow";
    version     = "7.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-pillow-7.2.0-1-any.pkg.tar.zst"; sha256 = "8e5758c856738c58c81baecd68c1b3c0f393a23749dfcbfe7ec8bb993e0b620d"; }];
    buildInputs = [ freetype lcms2 libjpeg libtiff libwebp libimagequant openjpeg2 python python-olefile zlib ];
  };

  "python-pip" = fetch {
    pname       = "python-pip";
    version     = "20.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-pip-20.0.2-1-any.pkg.tar.xz"; sha256 = "9444a6185abec335d31945afc519d4a4362c387d46a974a1fe0a09fc1ed6b731"; }];
    buildInputs = [ python-appdirs python-cachecontrol python-colorama python-contextlib2 python-distlib python-html5lib python-lockfile python-msgpack python-packaging python-pep517 python-progress python-pyparsing python-pytoml python-requests python-retrying python-six python-webencodings ];
  };

  "python-pkgconfig" = fetch {
    pname       = "python-pkgconfig";
    version     = "1.5.1";
    sources     = [{ filename = "mingw-w64-i686-python-pkgconfig-1.5.1-1-any.pkg.tar.xz"; sha256 = "5148c86c07fb44a3a41a1146d7e23801676b47c42e4b87302359ea3426e75e02"; }];
    buildInputs = [ python ];
  };

  "python-pkginfo" = fetch {
    pname       = "python-pkginfo";
    version     = "1.5.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-pkginfo-1.5.0.1-1-any.pkg.tar.xz"; sha256 = "525042bf3f7f1fee904ea55ac8f5378e9c7af704fe8502f3da71fee11eebbc66"; }];
    buildInputs = [ python ];
  };

  "python-pluggy" = fetch {
    pname       = "python-pluggy";
    version     = "0.13.1";
    sources     = [{ filename = "mingw-w64-i686-python-pluggy-0.13.1-1-any.pkg.tar.xz"; sha256 = "8789abff77add3dc6bf8b62a11f787da67381684b7a03832e12ed1b43d121b99"; }];
    buildInputs = [ python ];
  };

  "python-ply" = fetch {
    pname       = "python-ply";
    version     = "3.11";
    sources     = [{ filename = "mingw-w64-i686-python-ply-3.11-1-any.pkg.tar.xz"; sha256 = "f85f593a2a7652028c9244fecbdc893f4aa8a6820b8979339be7a74a877bd62b"; }];
    buildInputs = [ python ];
  };

  "python-pptx" = fetch {
    pname       = "python-pptx";
    version     = "0.6.18";
    sources     = [{ filename = "mingw-w64-i686-python-pptx-0.6.18-1-any.pkg.tar.xz"; sha256 = "621b6b3d5bb4c6067d3eb8372a6b81b1804df8a5f819b28890a9697c342035b9"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python-lxml.version "3.1.0"; python-lxml) (assert stdenvNoCC.lib.versionAtLeast python-pillow.version "2.6.1"; python-pillow) (assert stdenvNoCC.lib.versionAtLeast python-xlsxwriter.version "0.5.7"; python-xlsxwriter) ];
  };

  "python-pretend" = fetch {
    pname       = "python-pretend";
    version     = "1.0.9";
    sources     = [{ filename = "mingw-w64-i686-python-pretend-1.0.9-1-any.pkg.tar.xz"; sha256 = "ce184070a3dc6825f87bdf469b56310da251964f7b004262992c746b22b1ab90"; }];
    buildInputs = [ python ];
  };

  "python-prettytable" = fetch {
    pname       = "python-prettytable";
    version     = "0.7.2";
    sources     = [{ filename = "mingw-w64-i686-python-prettytable-0.7.2-1-any.pkg.tar.xz"; sha256 = "735688eca95bd76349b90408dd2ac26b295e6d7843c42069b8e7a5f4d1fd074d"; }];
    buildInputs = [ python ];
  };

  "python-profanityfilter" = fetch {
    pname       = "python-profanityfilter";
    version     = "2.0.6";
    sources     = [{ filename = "mingw-w64-i686-python-profanityfilter-2.0.6-1-any.pkg.tar.zst"; sha256 = "516e988abde060b0bad72965dda5145a641de5cad52a8bce2f1390608dfdbc8a"; }];
    buildInputs = [ python ];
  };

  "python-progress" = fetch {
    pname       = "python-progress";
    version     = "1.5";
    sources     = [{ filename = "mingw-w64-i686-python-progress-1.5-1-any.pkg.tar.xz"; sha256 = "cc441e308e855fb2b9f9976d6726acd32d67e89d362f851fb76eb3a8d072fd79"; }];
    buildInputs = [ python ];
  };

  "python-prometheus-client" = fetch {
    pname       = "python-prometheus-client";
    version     = "0.7.1";
    sources     = [{ filename = "mingw-w64-i686-python-prometheus-client-0.7.1-1-any.pkg.tar.xz"; sha256 = "cb59d7321793494f6791e861d8a0970c61b245efa73bc3999d13dddf30d54175"; }];
    buildInputs = [ python ];
  };

  "python-prompt_toolkit" = fetch {
    pname       = "python-prompt_toolkit";
    version     = "3.0.5";
    sources     = [{ filename = "mingw-w64-i686-python-prompt_toolkit-3.0.5-1-any.pkg.tar.zst"; sha256 = "47745a3377577737c24c45b7f5e171a6877ac31a485f6af1199bbb33ed7d0d39"; }];
    buildInputs = [ python-pygments python-six python-wcwidth ];
  };

  "python-protobuf" = fetch {
    pname       = "python-protobuf";
    version     = "3.12.4";
    sources     = [{ filename = "mingw-w64-i686-python-protobuf-3.12.4-1-any.pkg.tar.zst"; sha256 = "831d64831cec7f55634e58a30a70e8aba18fad89fdfe9247afecf5607f76ade7"; }];
    buildInputs = [ python python-six python-setuptools ];
  };

  "python-psutil" = fetch {
    pname       = "python-psutil";
    version     = "5.6.7";
    sources     = [{ filename = "mingw-w64-i686-python-psutil-5.6.7-1-any.pkg.tar.xz"; sha256 = "6553253892f445d719f9e013d5381969bfeb2835e7c2c05209616ac604046294"; }];
    buildInputs = [ python ];
  };

  "python-psycopg2" = fetch {
    pname       = "python-psycopg2";
    version     = "2.8.5";
    sources     = [{ filename = "mingw-w64-i686-python-psycopg2-2.8.5-1-any.pkg.tar.xz"; sha256 = "48dddb9cb733ba9353201439c219437d0be51cb9f67df9183f0b77731c5fcbdf"; }];
    buildInputs = [ python (assert stdenvNoCC.lib.versionAtLeast postgresql.version "8.4.1"; postgresql) ];
  };

  "python-ptyprocess" = fetch {
    pname       = "python-ptyprocess";
    version     = "0.6.0";
    sources     = [{ filename = "mingw-w64-i686-python-ptyprocess-0.6.0-1-any.pkg.tar.xz"; sha256 = "c76f15f1407c22325f60423bd69c9775105338721045a70a575fe5e3eb9a3492"; }];
    buildInputs = [ python ];
  };

  "python-py" = fetch {
    pname       = "python-py";
    version     = "1.8.1";
    sources     = [{ filename = "mingw-w64-i686-python-py-1.8.1-1-any.pkg.tar.xz"; sha256 = "06f75d55b9735d5ee91bb07d982bfb4eadd8d7a7c4c20f1c375b76474b5375ef"; }];
    buildInputs = [ python python-iniconfig python-apipkg ];
  };

  "python-py-cpuinfo" = fetch {
    pname       = "python-py-cpuinfo";
    version     = "5.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-py-cpuinfo-5.0.0-1-any.pkg.tar.xz"; sha256 = "88093be94baed1d8d64bddd0a3c68a3562bc4025376908712b43416ec2b442d4"; }];
    buildInputs = [ python ];
  };

  "python-pyamg" = fetch {
    pname       = "python-pyamg";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-pyamg-4.0.0-1-any.pkg.tar.xz"; sha256 = "18e708f19160f0ddd3c062c6859a82d1abd3180596026427b5cd5539fedca6fd"; }];
    buildInputs = [ python python-scipy python-numpy ];
  };

  "python-pyasn1" = fetch {
    pname       = "python-pyasn1";
    version     = "0.4.8";
    sources     = [{ filename = "mingw-w64-i686-python-pyasn1-0.4.8-1-any.pkg.tar.xz"; sha256 = "34fb68e817a56465079b35323068866a5058a389bc92249e95a5c0fb614a32b8"; }];
    buildInputs = [ python ];
  };

  "python-pyasn1-modules" = fetch {
    pname       = "python-pyasn1-modules";
    version     = "0.2.8";
    sources     = [{ filename = "mingw-w64-i686-python-pyasn1-modules-0.2.8-1-any.pkg.tar.xz"; sha256 = "087743767f53d486f1c25b7135333e95670fa13a2c0137818350a36d4fcc2421"; }];
    buildInputs = [ python-pyasn1 ];
  };

  "python-pycodestyle" = fetch {
    pname       = "python-pycodestyle";
    version     = "2.5.0";
    sources     = [{ filename = "mingw-w64-i686-python-pycodestyle-2.5.0-1-any.pkg.tar.xz"; sha256 = "fd97e404232a53589eec94dbdf32c1eae5a8aa7eaa92b487c436951b9e69c701"; }];
    buildInputs = [ python ];
  };

  "python-pycparser" = fetch {
    pname       = "python-pycparser";
    version     = "2.20";
    sources     = [{ filename = "mingw-w64-i686-python-pycparser-2.20-1-any.pkg.tar.xz"; sha256 = "056dbaafe9a410d0d7acd00627af4f682eae3ed743fa1e9cf2e475cbe855bd98"; }];
    buildInputs = [ python python-ply ];
  };

  "python-pyfilesystem2" = fetch {
    pname       = "python-pyfilesystem2";
    version     = "2.4.11";
    sources     = [{ filename = "mingw-w64-i686-python-pyfilesystem2-2.4.11-1-any.pkg.tar.xz"; sha256 = "97d628997f8fda58fc4eb766e6b496d9bb7ba935cda3b1e5d61e28e3f406581b"; }];
    buildInputs = [ python python-appdirs python-pytz python-six ];
  };

  "python-pyflakes" = fetch {
    pname       = "python-pyflakes";
    version     = "2.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-pyflakes-2.2.0-1-any.pkg.tar.zst"; sha256 = "6f414b20e25b8a361deba6157099b1100b903fd219fdc55073f06e8beb6a8d4e"; }];
    buildInputs = [ python ];
  };

  "python-pyglet" = fetch {
    pname       = "python-pyglet";
    version     = "1.5.4";
    sources     = [{ filename = "mingw-w64-i686-python-pyglet-1.5.4-1-any.pkg.tar.zst"; sha256 = "5576ec0f254fadd8024a947588c64862b410c681a03c2e2e8e73a989e651c986"; }];
    buildInputs = [ python python-future ];
  };

  "python-pygments" = fetch {
    pname       = "python-pygments";
    version     = "2.6.1";
    sources     = [{ filename = "mingw-w64-i686-python-pygments-2.6.1-1-any.pkg.tar.xz"; sha256 = "3cedebc6f33b6efb30b488b7959703415f8e9b224db50311610da090dcbcae96"; }];
    buildInputs = [  ];
  };

  "python-pylint" = fetch {
    pname       = "python-pylint";
    version     = "2.5.2";
    sources     = [{ filename = "mingw-w64-i686-python-pylint-2.5.2-1-any.pkg.tar.zst"; sha256 = "4115a997950cce10424e6ce82f5bca751b858bbd8fcf02cc27d122f9b11c795b"; }];
    buildInputs = [ python-astroid python-colorama python-mccabe python-isort ];
  };

  "python-pynacl" = fetch {
    pname       = "python-pynacl";
    version     = "1.3.0";
    sources     = [{ filename = "mingw-w64-i686-python-pynacl-1.3.0-1-any.pkg.tar.xz"; sha256 = "4076cc1bae6d344c70b95ee5a505675e3bf1e018ea061c3f749742efa7cc9b82"; }];
    buildInputs = [ python ];
  };

  "python-pyopengl" = fetch {
    pname       = "python-pyopengl";
    version     = "3.1.5";
    sources     = [{ filename = "mingw-w64-i686-python-pyopengl-3.1.5-1-any.pkg.tar.xz"; sha256 = "907bb7ee3401ea5dc13bc114e2a5fba34739d528c1d17d7735f6c7a255615367"; }];
    buildInputs = [ python ];
  };

  "python-pyopenssl" = fetch {
    pname       = "python-pyopenssl";
    version     = "19.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-pyopenssl-19.1.0-1-any.pkg.tar.xz"; sha256 = "1297b769d74bf7549f70f16c8387baac60b70a6ab167e5364fbe0a15716f78c3"; }];
    buildInputs = [ openssl python-cryptography python-six ];
  };

  "python-pyparsing" = fetch {
    pname       = "python-pyparsing";
    version     = "2.4.7";
    sources     = [{ filename = "mingw-w64-i686-python-pyparsing-2.4.7-1-any.pkg.tar.zst"; sha256 = "3b6891adb590c3f4b660179ab125c414116199f406ba60e9aa4404f25a4939bf"; }];
    buildInputs = [ python ];
  };

  "python-pyperclip" = fetch {
    pname       = "python-pyperclip";
    version     = "1.8.0";
    sources     = [{ filename = "mingw-w64-i686-python-pyperclip-1.8.0-1-any.pkg.tar.zst"; sha256 = "8843f25c07379d5c773e94ff9cc290df1dc21086c95951f00050eb454d080f23"; }];
    buildInputs = [ python ];
  };

  "python-pyqt5" = fetch {
    pname       = "python-pyqt5";
    version     = "5.15.0";
    sources     = [{ filename = "mingw-w64-i686-python-pyqt5-5.15.0-2-any.pkg.tar.zst"; sha256 = "a7fda280a7fbffd56d006116f6b53527e51118bd7e5be3626d2c4cb4179660c3"; }];
    buildInputs = [ python-pyopengl python pyqt5-sip qt5 qtwebkit ];
  };

  "python-pyreadline" = fetch {
    pname       = "python-pyreadline";
    version     = "2.1";
    sources     = [{ filename = "mingw-w64-i686-python-pyreadline-2.1-1-any.pkg.tar.xz"; sha256 = "63a647afd9c9cea715e2d61b83c290f5572a5fe9d9f46565359f165232f60be9"; }];
    buildInputs = [ python ];
  };

  "python-pyrsistent" = fetch {
    pname       = "python-pyrsistent";
    version     = "0.16.0";
    sources     = [{ filename = "mingw-w64-i686-python-pyrsistent-0.16.0-1-any.pkg.tar.xz"; sha256 = "6283b12f30f594a647443a36ca4930f7e27fa4ba6085a1e6e834731d06e6144d"; }];
    buildInputs = [ python python-six ];
  };

  "python-pyserial" = fetch {
    pname       = "python-pyserial";
    version     = "3.4";
    sources     = [{ filename = "mingw-w64-i686-python-pyserial-3.4-3-any.pkg.tar.xz"; sha256 = "eaf5432f33c56edde387eaff2b7719b2e8c110b3ab6c480b04651f6aacc13480"; }];
    buildInputs = [ python ];
  };

  "python-pysocks" = fetch {
    pname       = "python-pysocks";
    version     = "1.7.0";
    sources     = [{ filename = "mingw-w64-i686-python-pysocks-1.7.0-1-any.pkg.tar.xz"; sha256 = "376665eaf83b803fbd082f202811af87fe332b862524e011384ffe5cdef4de1c"; }];
    buildInputs = [ python python-win_inet_pton ];
  };

  "python-pystemmer" = fetch {
    pname       = "python-pystemmer";
    version     = "2.0.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-pystemmer-2.0.0.1-1-any.pkg.tar.xz"; sha256 = "228d81788c329f17de163f5aab6ecb7d4e6a43ba8f4737b9e3ed5b107c078d95"; }];
    buildInputs = [ python ];
  };

  "python-pytest" = fetch {
    pname       = "python-pytest";
    version     = "5.4.1";
    sources     = [{ filename = "mingw-w64-i686-python-pytest-5.4.1-1-any.pkg.tar.xz"; sha256 = "6d1e996e40d2f98eaf5306f27d9d169f71f665d569d9e2595490165497d85cae"; }];
    buildInputs = [ python (assert stdenvNoCC.lib.versionAtLeast python-atomicwrites.version "1.0"; python-atomicwrites) (assert stdenvNoCC.lib.versionAtLeast python-attrs.version "17.4.0"; python-attrs) (assert stdenvNoCC.lib.versionAtLeast python-more-itertools.version "4.0.0"; python-more-itertools) (assert stdenvNoCC.lib.versionAtLeast python-pluggy.version "0.7"; python-pluggy) (assert stdenvNoCC.lib.versionAtLeast python-py.version "1.5.0"; python-py) python-setuptools python-six python-colorama python-wcwidth ];
  };

  "python-pytest-benchmark" = fetch {
    pname       = "python-pytest-benchmark";
    version     = "3.2.3";
    sources     = [{ filename = "mingw-w64-i686-python-pytest-benchmark-3.2.3-1-any.pkg.tar.xz"; sha256 = "1e69affe4eee3366e7e496f228ebe2d1a823aa5cbfe5da9f34b20e71de782f9b"; }];
    buildInputs = [ python python-py-cpuinfo python-pytest ];
  };

  "python-pytest-cov" = fetch {
    pname       = "python-pytest-cov";
    version     = "2.8.1";
    sources     = [{ filename = "mingw-w64-i686-python-pytest-cov-2.8.1-1-any.pkg.tar.xz"; sha256 = "d4f00ef965f3570b640339a58f26dc511bb7d6cfd19e706e7ec666d415c2fbcf"; }];
    buildInputs = [ python python-coverage python-pytest ];
  };

  "python-pytest-expect" = fetch {
    pname       = "python-pytest-expect";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-pytest-expect-1.1.0-1-any.pkg.tar.xz"; sha256 = "81af8bc8986982cf3fa9c3786c320a69f5d8b54c5f73694ce9987bbdf829cf65"; }];
    buildInputs = [ python python-pytest python-u-msgpack ];
  };

  "python-pytest-forked" = fetch {
    pname       = "python-pytest-forked";
    version     = "1.1.3";
    sources     = [{ filename = "mingw-w64-i686-python-pytest-forked-1.1.3-1-any.pkg.tar.xz"; sha256 = "79947f18ec2b3c48f85a8bc3e4ef0a61cfbf70263e12408f2e069ce210b7ff01"; }];
    buildInputs = [ python python-pytest ];
  };

  "python-pytest-localserver" = fetch {
    pname       = "python-pytest-localserver";
    version     = "0.5.0";
    sources     = [{ filename = "mingw-w64-i686-python-pytest-localserver-0.5.0-1-any.pkg.tar.zst"; sha256 = "76977c0347d5562823efd804aa0c74412e3ac6f3d083e025873195e131ce7cdb"; }];
    buildInputs = [ python-pytest python-werkzeug ];
  };

  "python-pytest-mock" = fetch {
    pname       = "python-pytest-mock";
    version     = "3.3.1";
    sources     = [{ filename = "mingw-w64-i686-python-pytest-mock-3.3.1-1-any.pkg.tar.zst"; sha256 = "6e332545742afa3e46e97f9bba0d94ccce9f6619da2c52f5c524e5c2f1b1c5cd"; }];
    buildInputs = [ python-pytest ];
  };

  "python-pytest-runner" = fetch {
    pname       = "python-pytest-runner";
    version     = "5.2";
    sources     = [{ filename = "mingw-w64-i686-python-pytest-runner-5.2-1-any.pkg.tar.xz"; sha256 = "7661bf2c8a7e2f7f3d8c551606e97df9b60b04341f220a379ee944f203ab539b"; }];
    buildInputs = [ python python-pytest ];
  };

  "python-pytest-timeout" = fetch {
    pname       = "python-pytest-timeout";
    version     = "1.4.2";
    sources     = [{ filename = "mingw-w64-i686-python-pytest-timeout-1.4.2-1-any.pkg.tar.zst"; sha256 = "2be607ab6ccdd5797aeb5c2212c525bb3fb5df21997f7cd7762f274f4c4ee452"; }];
    buildInputs = [ python-pytest ];
  };

  "python-pytest-xdist" = fetch {
    pname       = "python-pytest-xdist";
    version     = "1.31.0";
    sources     = [{ filename = "mingw-w64-i686-python-pytest-xdist-1.31.0-1-any.pkg.tar.xz"; sha256 = "6bdbb9e670a66b140cca307565227d0d568fdc5a1bf3ab14ed7078a6a3c51dc8"; }];
    buildInputs = [ python python-pytest-forked python-execnet ];
  };

  "python-python_ics" = fetch {
    pname       = "python-python_ics";
    version     = "4.3";
    sources     = [{ filename = "mingw-w64-i686-python-python_ics-4.3-2-any.pkg.tar.zst"; sha256 = "047e6272844a9f82db0496cc0204a3d4f4025c5ad97c8eb1742685f93a64c503"; }];
    buildInputs = [ python ];
  };

  "python-pytoml" = fetch {
    pname       = "python-pytoml";
    version     = "0.1.21";
    sources     = [{ filename = "mingw-w64-i686-python-pytoml-0.1.21-1-any.pkg.tar.xz"; sha256 = "9b149d5bbb0581f1e3aba0cf3c63d802bc9b894967da41dfef53c400b86f9364"; }];
    buildInputs = [ python ];
  };

  "python-pytz" = fetch {
    pname       = "python-pytz";
    version     = "2019.3";
    sources     = [{ filename = "mingw-w64-i686-python-pytz-2019.3-1-any.pkg.tar.xz"; sha256 = "8c27c7351aa69538ac8d3a1ba4144a07f611536b4a5e69a563e537196b2f5463"; }];
    buildInputs = [ python ];
  };

  "python-pyu2f" = fetch {
    pname       = "python-pyu2f";
    version     = "0.1.4";
    sources     = [{ filename = "mingw-w64-i686-python-pyu2f-0.1.4-1-any.pkg.tar.xz"; sha256 = "b8466de7e42a4a930c5e05f9560777a595e5ea84377cfb949c08bdf69fe68597"; }];
    buildInputs = [ python ];
  };

  "python-pywavelets" = fetch {
    pname       = "python-pywavelets";
    version     = "1.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-pywavelets-1.1.1-1-any.pkg.tar.xz"; sha256 = "6b0e62101371b1e9b482dac7f01bbd4c7e0b5cdf2a6b2408fdd6e7f48351a958"; }];
    buildInputs = [ python-numpy python ];
  };

  "python-pyzmq" = fetch {
    pname       = "python-pyzmq";
    version     = "19.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-pyzmq-19.0.2-1-any.pkg.tar.zst"; sha256 = "91b788087894a4410eb25e93ff3d030507180732fe7d23e69170757fdf22e692"; }];
    buildInputs = [ python zeromq ];
  };

  "python-pyzopfli" = fetch {
    pname       = "python-pyzopfli";
    version     = "0.1.7";
    sources     = [{ filename = "mingw-w64-i686-python-pyzopfli-0.1.7-1-any.pkg.tar.xz"; sha256 = "06abf252ca1742a797fb5a3289e7dbd0dbb5e7cb582337743e30b3d6cc1bd1ad"; }];
    buildInputs = [ python ];
  };

  "python-qscintilla" = fetch {
    pname       = "python-qscintilla";
    version     = "2.11.5";
    sources     = [{ filename = "mingw-w64-i686-python-qscintilla-2.11.5-1-any.pkg.tar.zst"; sha256 = "e32bf27fd570b827eb95d3c9e76569163fb5fef8b413fa02547f62b9f7fe5b19"; }];
    buildInputs = [ qscintilla python-pyqt5 ];
  };

  "python-qtconsole" = fetch {
    pname       = "python-qtconsole";
    version     = "4.7.3";
    sources     = [{ filename = "mingw-w64-i686-python-qtconsole-4.7.3-1-any.pkg.tar.zst"; sha256 = "5ca15569c0782e332ab754a94f8a4b2f6f7813db36594f6a527f4aa7846cd39d"; }];
    buildInputs = [ python python-jupyter_core python-jupyter_client python-pyqt5 ];
  };

  "python-qtpy" = fetch {
    pname       = "python-qtpy";
    version     = "1.9.0";
    sources     = [{ filename = "mingw-w64-i686-python-qtpy-1.9.0-1-any.pkg.tar.zst"; sha256 = "20f5f425a233ef557b9590e775e6671589bf9256f2dbefd85c02498565253dbc"; }];
    buildInputs = [ python ];
  };

  "python-regex" = fetch {
    pname       = "python-regex";
    version     = "2020.4.4";
    sources     = [{ filename = "mingw-w64-i686-python-regex-2020.4.4-1-any.pkg.tar.zst"; sha256 = "1632d2d3f6c6639b1ac7e239e18872ca8a7a5fb263fcbe36fa83f29dd23e3a1b"; }];
    buildInputs = [ python ];
  };

  "python-rencode" = fetch {
    pname       = "python-rencode";
    version     = "1.0.6";
    sources     = [{ filename = "mingw-w64-i686-python-rencode-1.0.6-1-any.pkg.tar.xz"; sha256 = "a63cfb7cc4bc24727d7a6c2b967348cba5c31e83fcf0a29fb123699709db57c4"; }];
    buildInputs = [ python ];
  };

  "python-reportlab" = fetch {
    pname       = "python-reportlab";
    version     = "3.5.42";
    sources     = [{ filename = "mingw-w64-i686-python-reportlab-3.5.42-1-any.pkg.tar.xz"; sha256 = "7a235b5709f3acfa7eca0444e34b598c5780a4206d77b25b7dcf1abceb451665"; }];
    buildInputs = [ freetype python-pip python-pillow ];
  };

  "python-requests" = fetch {
    pname       = "python-requests";
    version     = "2.23.0";
    sources     = [{ filename = "mingw-w64-i686-python-requests-2.23.0-1-any.pkg.tar.xz"; sha256 = "4584ed03ee54bf4435ed7cc6d8e373e3cb3710cd2673360644aa8261df1b63b2"; }];
    buildInputs = [ python-urllib3 python-chardet python-idna ];
  };

  "python-requests-kerberos" = fetch {
    pname       = "python-requests-kerberos";
    version     = "0.12.0";
    sources     = [{ filename = "mingw-w64-i686-python-requests-kerberos-0.12.0-1-any.pkg.tar.xz"; sha256 = "18f8a0faa5f442d3b104bac4aaef1205f70316ebc3cfd24ecea0fd6e7aaf8d2d"; }];
    buildInputs = [ python python-cryptography python-winkerberos ];
  };

  "python-resampy" = fetch {
    pname       = "python-resampy";
    version     = "0.2.2";
    sources     = [{ filename = "mingw-w64-i686-python-resampy-0.2.2-1-any.pkg.tar.zst"; sha256 = "0380a35d7433346336630bba23d0fc04e6040e590edc02e0779bb83391bfbde2"; }];
    buildInputs = [ python-numba python-scipy python-six ];
  };

  "python-responses" = fetch {
    pname       = "python-responses";
    version     = "0.12.0";
    sources     = [{ filename = "mingw-w64-i686-python-responses-0.12.0-1-any.pkg.tar.zst"; sha256 = "a3f48b81a0d5c9143132fd3129d2dc1abcf6a42de330fb29ceccbe7c92db44e7"; }];
    buildInputs = [ python-biscuits python-requests python-six ];
  };

  "python-retrying" = fetch {
    pname       = "python-retrying";
    version     = "1.3.3";
    sources     = [{ filename = "mingw-w64-i686-python-retrying-1.3.3-1-any.pkg.tar.xz"; sha256 = "f925339b8e5d71679467c92013b6510e3569cc16e9698fae4986434725956f06"; }];
    buildInputs = [ python ];
  };

  "python-rfc3986" = fetch {
    pname       = "python-rfc3986";
    version     = "1.4.0";
    sources     = [{ filename = "mingw-w64-i686-python-rfc3986-1.4.0-1-any.pkg.tar.zst"; sha256 = "7343700802aa063e9cbd4646afa5021cf4e3e9f575b51641dd9da1794bcec087"; }];
    buildInputs = [ python ];
  };

  "python-rfc3987" = fetch {
    pname       = "python-rfc3987";
    version     = "1.3.8";
    sources     = [{ filename = "mingw-w64-i686-python-rfc3987-1.3.8-1-any.pkg.tar.xz"; sha256 = "1badc00aa7d4665d986bfc91fe7d85c709721113e992406eb3b57d70924ea9e5"; }];
    buildInputs = [ python ];
  };

  "python-rsa" = fetch {
    pname       = "python-rsa";
    version     = "4.6";
    sources     = [{ filename = "mingw-w64-i686-python-rsa-4.6-1-any.pkg.tar.zst"; sha256 = "60a5355293ed05a793343d22ed09234bf099a5bcdfc53763d8f090f387182079"; }];
    buildInputs = [ python-pyasn1 ];
  };

  "python-rst2pdf" = fetch {
    pname       = "python-rst2pdf";
    version     = "0.96";
    sources     = [{ filename = "mingw-w64-i686-python-rst2pdf-0.96-2-any.pkg.tar.xz"; sha256 = "f5df49a7313258f67280a5085b50f95b31bdf0e97a74e0fa20a8e8b38e854760"; }];
    buildInputs = [ python python-docutils python-jinja python-pdfrw python-pygments (assert stdenvNoCC.lib.versionAtLeast python-reportlab.version "2.4"; python-reportlab) python-setuptools python-six python-smartypants ];
  };

  "python-scandir" = fetch {
    pname       = "python-scandir";
    version     = "1.10.0";
    sources     = [{ filename = "mingw-w64-i686-python-scandir-1.10.0-1-any.pkg.tar.xz"; sha256 = "ea4ec7861eceaad10cabcb9147ada281dd9024c448aa8105a434d5b671a7ce5a"; }];
    buildInputs = [ python ];
  };

  "python-scikit-image" = fetch {
    pname       = "python-scikit-image";
    version     = "0.17.2";
    sources     = [{ filename = "mingw-w64-i686-python-scikit-image-0.17.2-1-any.pkg.tar.zst"; sha256 = "ab8e1d378af718c8268bde48f8ad69dee783b06009c48a5b0f627a1f7d353e93"; }];
    buildInputs = [ python-matplotlib python-scipy python-pywavelets python-numpy python-networkx python-imageio python-tifffile python-pillow ];
  };

  "python-scikit-learn" = fetch {
    pname       = "python-scikit-learn";
    version     = "0.22.2.post1";
    sources     = [{ filename = "mingw-w64-i686-python-scikit-learn-0.22.2.post1-1-any.pkg.tar.xz"; sha256 = "c5f727611b42962bf551de69602d39a3ff866f6a745b191b5038425aec21926c"; }];
    buildInputs = [ python python-scipy python-joblib ];
  };

  "python-scipy" = fetch {
    pname       = "python-scipy";
    version     = "1.5.0";
    sources     = [{ filename = "mingw-w64-i686-python-scipy-1.5.0-1-any.pkg.tar.zst"; sha256 = "44945a5802609538e48f40e84a49db2a19120f445bf5c8037bb6b4e2b8acc208"; }];
    buildInputs = [ gcc-libgfortran openblas python-numpy ];
  };

  "python-seaborn" = fetch {
    pname       = "python-seaborn";
    version     = "0.10.0";
    sources     = [{ filename = "mingw-w64-i686-python-seaborn-0.10.0-1-any.pkg.tar.xz"; sha256 = "05e02a0ad6b1883acc393029e51cad3adec8fc4b0a4290bafdf8eb5d09a54d04"; }];
    buildInputs = [ python python-pandas python-matplotlib ];
  };

  "python-send2trash" = fetch {
    pname       = "python-send2trash";
    version     = "1.5.0";
    sources     = [{ filename = "mingw-w64-i686-python-send2trash-1.5.0-1-any.pkg.tar.xz"; sha256 = "9e32af935d49e1806c9c2dfdcbdc465c126ee31c187c6b4e9d9507476b5640ce"; }];
    buildInputs = [ python ];
  };

  "python-setproctitle" = fetch {
    pname       = "python-setproctitle";
    version     = "1.1.10";
    sources     = [{ filename = "mingw-w64-i686-python-setproctitle-1.1.10-1-any.pkg.tar.xz"; sha256 = "f54215a69e18859124379f2bec60645dfe5718ad3c50c27ee2eca121ff1fdb80"; }];
    buildInputs = [ python ];
  };

  "python-setuptools" = fetch {
    pname       = "python-setuptools";
    version     = "47.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-setuptools-47.1.1-1-any.pkg.tar.zst"; sha256 = "f4a66e52533156a773c7e84ec7751afcbd4441ec92a7f81993e6598ef703b393"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python.version "3.3"; python) python-packaging python-pyparsing python-ordered-set python-appdirs python-six ];
  };

  "python-setuptools-scm" = fetch {
    pname       = "python-setuptools-scm";
    version     = "4.1.2";
    sources     = [{ filename = "mingw-w64-i686-python-setuptools-scm-4.1.2-1-any.pkg.tar.zst"; sha256 = "def93d2e373f61f4104a4b8ec0a0a173312d835e76a695ae483397520d391c07"; }];
    buildInputs = [ python python-setuptools ];
  };

  "python-simplegeneric" = fetch {
    pname       = "python-simplegeneric";
    version     = "0.8.1";
    sources     = [{ filename = "mingw-w64-i686-python-simplegeneric-0.8.1-1-any.pkg.tar.xz"; sha256 = "dda2436235b4142c2723302463c48f6805752793ed540388a5bfc324d8474497"; }];
    buildInputs = [ python ];
  };

  "python-sip" = fetch {
    pname       = "python-sip";
    version     = "4.19.22";
    sources     = [{ filename = "mingw-w64-i686-python-sip-4.19.22-1-any.pkg.tar.xz"; sha256 = "1c9982a4ec2da16dd6a41b8431d8c5fc7eab7fbda122bb226af84646d5b02aed"; }];
    buildInputs = [ sip python ];
  };

  "python-six" = fetch {
    pname       = "python-six";
    version     = "1.15.0";
    sources     = [{ filename = "mingw-w64-i686-python-six-1.15.0-1-any.pkg.tar.zst"; sha256 = "b4519ec0dde8808f207db214a4b41486bb4f3dddb07228eb0961aae2555e99cf"; }];
    buildInputs = [ python ];
  };

  "python-smartypants" = fetch {
    pname       = "python-smartypants";
    version     = "2.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-smartypants-2.0.1-1-any.pkg.tar.xz"; sha256 = "d8fb4d7219347f3a4714a8e1e90005523d1fde9c5a1aa3e0a9a2ffe321fda28c"; }];
    buildInputs = [ python ];
  };

  "python-snowballstemmer" = fetch {
    pname       = "python-snowballstemmer";
    version     = "2.0.0";
    sources     = [{ filename = "mingw-w64-i686-python-snowballstemmer-2.0.0-1-any.pkg.tar.xz"; sha256 = "ea520e58149d6cf87b1ed7ba09e75ddbddfdde1d4143be1f4eea9f5598115eb4"; }];
    buildInputs = [ python ];
  };

  "python-sortedcontainers" = fetch {
    pname       = "python-sortedcontainers";
    version     = "2.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-sortedcontainers-2.1.0-1-any.pkg.tar.xz"; sha256 = "b548121994a2af7e4604152ed5691c897344334cb5dd35c88cb18da028d2dc58"; }];
    buildInputs = [ python ];
  };

  "python-soundfile" = fetch {
    pname       = "python-soundfile";
    version     = "0.10.3.post1";
    sources     = [{ filename = "mingw-w64-i686-python-soundfile-0.10.3.post1-1-any.pkg.tar.zst"; sha256 = "ff0b01a7bd9bd043252fbc44d0dbbcff688fe99dd093280e23417f4b5329d428"; }];
    buildInputs = [ python-cffi python-numpy libsndfile ];
  };

  "python-soupsieve" = fetch {
    pname       = "python-soupsieve";
    version     = "1.9.5";
    sources     = [{ filename = "mingw-w64-i686-python-soupsieve-1.9.5-1-any.pkg.tar.xz"; sha256 = "97b8be0d8ca7dc8684ed077ede37e3a0ea3a1e4475b9d7bbcf1f1469eddb6d7e"; }];
    buildInputs = [ python ];
  };

  "python-sphinx" = fetch {
    pname       = "python-sphinx";
    version     = "3.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-sphinx-3.0.2-1-any.pkg.tar.zst"; sha256 = "2f135fe5eb5206c3ff25dcce47eae867cb3cec38e2c5da0a3401eb056e9aff6e"; }];
    buildInputs = [ python-babel python-colorama python-docutils python-imagesize python-jinja python-pygments python-requests python-setuptools python-snowballstemmer python-sphinx-alabaster-theme python-sphinxcontrib-applehelp python-sphinxcontrib-devhelp python-sphinxcontrib-htmlhelp python-sphinxcontrib-jsmath python-sphinxcontrib-serializinghtml python-sphinxcontrib-qthelp ];
  };

  "python-sphinx-alabaster-theme" = fetch {
    pname       = "python-sphinx-alabaster-theme";
    version     = "0.7.12";
    sources     = [{ filename = "mingw-w64-i686-python-sphinx-alabaster-theme-0.7.12-1-any.pkg.tar.xz"; sha256 = "2e73c42e659c6dc9b1167e5827a2bf808d3cad750f9afd458f756659e725f3f7"; }];
    buildInputs = [ python ];
  };

  "python-sphinx_rtd_theme" = fetch {
    pname       = "python-sphinx_rtd_theme";
    version     = "0.4.3";
    sources     = [{ filename = "mingw-w64-i686-python-sphinx_rtd_theme-0.4.3-1-any.pkg.tar.xz"; sha256 = "021bc7b8cb3a443f2a469cdcef770e8925beb3b0d504c7d47003c9d38f40a16d"; }];
    buildInputs = [ python ];
  };

  "python-sphinxcontrib-applehelp" = fetch {
    pname       = "python-sphinxcontrib-applehelp";
    version     = "1.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-sphinxcontrib-applehelp-1.0.2-1-any.pkg.tar.xz"; sha256 = "e218bfd48f6e5a47a1e5290cc02d9784b14c45c32c61389812e9b2b1552f0f9f"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-devhelp" = fetch {
    pname       = "python-sphinxcontrib-devhelp";
    version     = "1.0.2";
    sources     = [{ filename = "mingw-w64-i686-python-sphinxcontrib-devhelp-1.0.2-1-any.pkg.tar.xz"; sha256 = "75ffe2c98929a415666113ed9735cde78890dd77fcbba2f0eef5275db3b9c376"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-htmlhelp" = fetch {
    pname       = "python-sphinxcontrib-htmlhelp";
    version     = "1.0.3";
    sources     = [{ filename = "mingw-w64-i686-python-sphinxcontrib-htmlhelp-1.0.3-1-any.pkg.tar.xz"; sha256 = "ae0af177de6ff6013e681b8bd1604fe895de9ca6f33c8bba776da64c4cf1d152"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-jsmath" = fetch {
    pname       = "python-sphinxcontrib-jsmath";
    version     = "1.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-sphinxcontrib-jsmath-1.0.1-1-any.pkg.tar.xz"; sha256 = "68003fe47e148e0a7914000e3d3a8d01d8225c16893ab1367a71741abfa21f09"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-qthelp" = fetch {
    pname       = "python-sphinxcontrib-qthelp";
    version     = "1.0.3";
    sources     = [{ filename = "mingw-w64-i686-python-sphinxcontrib-qthelp-1.0.3-1-any.pkg.tar.xz"; sha256 = "ffbe6f15835dca1a332ba5e9578e87d7835902f9bbe3910cb5133869f4085a99"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-serializinghtml" = fetch {
    pname       = "python-sphinxcontrib-serializinghtml";
    version     = "1.1.4";
    sources     = [{ filename = "mingw-w64-i686-python-sphinxcontrib-serializinghtml-1.1.4-1-any.pkg.tar.xz"; sha256 = "1c09bb1d45672697be016d862160cf7d5f073ba2453f48fb8c6ee14f6ec25480"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-websupport" = fetch {
    pname       = "python-sphinxcontrib-websupport";
    version     = "1.1.2";
    sources     = [{ filename = "mingw-w64-i686-python-sphinxcontrib-websupport-1.1.2-1-any.pkg.tar.xz"; sha256 = "b3dafe72d40238700506a74cedcc65e14f2cc38657dee42b9320ef34697888f6"; }];
    buildInputs = [ python ];
  };

  "python-sqlalchemy" = fetch {
    pname       = "python-sqlalchemy";
    version     = "1.3.16";
    sources     = [{ filename = "mingw-w64-i686-python-sqlalchemy-1.3.16-1-any.pkg.tar.zst"; sha256 = "3eef9c30a107e462fc22d4b30d1f6c5744b426782b8ee801ccf776f0decea01a"; }];
    buildInputs = [ python ];
  };

  "python-sqlalchemy-migrate" = fetch {
    pname       = "python-sqlalchemy-migrate";
    version     = "0.13.0";
    sources     = [{ filename = "mingw-w64-i686-python-sqlalchemy-migrate-0.13.0-1-any.pkg.tar.xz"; sha256 = "5c01fc1da4c4f2092ed906111499d474efd87590bb350120dde8a8d0b2761efc"; }];
    buildInputs = [ python python-six python-pbr python-sqlalchemy python-decorator python-sqlparse python-tempita ];
  };

  "python-sqlitedict" = fetch {
    pname       = "python-sqlitedict";
    version     = "1.6.0";
    sources     = [{ filename = "mingw-w64-i686-python-sqlitedict-1.6.0-1-any.pkg.tar.xz"; sha256 = "f15f33024010246699c4745a62e16e4968a87ca56912867029b47f204419abce"; }];
    buildInputs = [ python sqlite3 ];
  };

  "python-sqlparse" = fetch {
    pname       = "python-sqlparse";
    version     = "0.3.1";
    sources     = [{ filename = "mingw-w64-i686-python-sqlparse-0.3.1-1-any.pkg.tar.xz"; sha256 = "1708da7403c47307c7cdf2df4e3c8f734c0f24ff38440263a92418c29b6863e5"; }];
    buildInputs = [ python ];
  };

  "python-statsmodels" = fetch {
    pname       = "python-statsmodels";
    version     = "0.11.1";
    sources     = [{ filename = "mingw-w64-i686-python-statsmodels-0.11.1-1-any.pkg.tar.xz"; sha256 = "348eedc23785fda1ebb830555ea36e92537d5708df5663c6d3c9e9d4deb4fd74"; }];
    buildInputs = [ python-scipy python-pandas python-patsy ];
  };

  "python-stestr" = fetch {
    pname       = "python-stestr";
    version     = "3.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-stestr-3.0.1-1-any.pkg.tar.zst"; sha256 = "1a212851483d382251f24a29c778b9d611feffbbf83aa21d0cadb2e80831d871"; }];
    buildInputs = [ python python-cliff python-fixtures python-future python-pbr python-six python-subunit python-testtools python-voluptuous python-yaml ];
  };

  "python-stevedore" = fetch {
    pname       = "python-stevedore";
    version     = "1.32.0";
    sources     = [{ filename = "mingw-w64-i686-python-stevedore-1.32.0-1-any.pkg.tar.xz"; sha256 = "6425f568d849534ddd52221b140d1a9f551373710b751bf4700ae491f3d43fe5"; }];
    buildInputs = [ python python-six ];
  };

  "python-strict-rfc3339" = fetch {
    pname       = "python-strict-rfc3339";
    version     = "0.7";
    sources     = [{ filename = "mingw-w64-i686-python-strict-rfc3339-0.7-1-any.pkg.tar.xz"; sha256 = "65373579ab6ded6184b13eabdb9a84b993345addde999f9ec6663e3b39997c27"; }];
    buildInputs = [ python ];
  };

  "python-subunit" = fetch {
    pname       = "python-subunit";
    version     = "1.4.0";
    sources     = [{ filename = "mingw-w64-i686-python-subunit-1.4.0-1-any.pkg.tar.xz"; sha256 = "207208058195d83e36b0d917622f24b034f82c26766f32d99e65457644275c50"; }];
    buildInputs = [ python python-extras python-testtools ];
  };

  "python-sympy" = fetch {
    pname       = "python-sympy";
    version     = "1.5.1";
    sources     = [{ filename = "mingw-w64-i686-python-sympy-1.5.1-1-any.pkg.tar.xz"; sha256 = "3b75f8b1a7e872c03d5bb771c61361ca79fc265862853c338030716c68d47403"; }];
    buildInputs = [ python python-mpmath ];
  };

  "python-tempita" = fetch {
    pname       = "python-tempita";
    version     = "0.5.3dev20170202";
    sources     = [{ filename = "mingw-w64-i686-python-tempita-0.5.3dev20170202-1-any.pkg.tar.xz"; sha256 = "94c1962b8cd8ae0e5418f3dd496a3c781603312654f99cf6d25719e3fc52868f"; }];
    buildInputs = [ python ];
  };

  "python-termcolor" = fetch {
    pname       = "python-termcolor";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-termcolor-1.1.0-1-any.pkg.tar.zst"; sha256 = "6b2fa7178c7972b963c2f3d1d436dcbf24432719e312c86faceb3e627fa7691c"; }];
    buildInputs = [ python ];
  };

  "python-terminado" = fetch {
    pname       = "python-terminado";
    version     = "0.8.3";
    sources     = [{ filename = "mingw-w64-i686-python-terminado-0.8.3-1-any.pkg.tar.xz"; sha256 = "7e4f6fb0cfc7ce7f21e7eb98db341321d01506e3793eb46ad8e17ebbdce5cbda"; }];
    buildInputs = [ python python-tornado python-ptyprocess ];
  };

  "python-testpath" = fetch {
    pname       = "python-testpath";
    version     = "0.4.4";
    sources     = [{ filename = "mingw-w64-i686-python-testpath-0.4.4-1-any.pkg.tar.xz"; sha256 = "d88632b2b41f8dd67e51e49e2e1e6cda7f694382d54359c7c0289ec76b40efb3"; }];
    buildInputs = [ python ];
  };

  "python-testrepository" = fetch {
    pname       = "python-testrepository";
    version     = "0.0.20";
    sources     = [{ filename = "mingw-w64-i686-python-testrepository-0.0.20-1-any.pkg.tar.xz"; sha256 = "3b02e5b02aab9a9444aff7d6b47e638e8cadc0f4fbdc0ec1c8ae3adb615114f7"; }];
    buildInputs = [ python ];
  };

  "python-testresources" = fetch {
    pname       = "python-testresources";
    version     = "2.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-testresources-2.0.1-1-any.pkg.tar.xz"; sha256 = "75362834c4ce7820f9bc8b9df25ca452b409368eb0a8baec94f85dc32016a33a"; }];
    buildInputs = [ python ];
  };

  "python-testscenarios" = fetch {
    pname       = "python-testscenarios";
    version     = "0.5.0";
    sources     = [{ filename = "mingw-w64-i686-python-testscenarios-0.5.0-1-any.pkg.tar.xz"; sha256 = "b266a0ca32eda93c9a734f97e7804b344f01af346a7cf4045807dadef29230f6"; }];
    buildInputs = [ python ];
  };

  "python-testtools" = fetch {
    pname       = "python-testtools";
    version     = "2.4.0";
    sources     = [{ filename = "mingw-w64-i686-python-testtools-2.4.0-1-any.pkg.tar.xz"; sha256 = "0d4d1d28819dd4fc69b18e22fd71348e793ce32c2cdab1aab2c1c2df7c04e432"; }];
    buildInputs = [ python python-pbr python-extras python-fixtures python-pyrsistent python-mimeparse ];
  };

  "python-text-unidecode" = fetch {
    pname       = "python-text-unidecode";
    version     = "1.3";
    sources     = [{ filename = "mingw-w64-i686-python-text-unidecode-1.3-1-any.pkg.tar.xz"; sha256 = "f4d9ba4dbc0e8138638f7604c6ff47bee1e9f0ce1554c3a134339d92cbd9aad4"; }];
    buildInputs = [ python ];
  };

  "python-theano" = fetch {
    pname       = "python-theano";
    version     = "1.0.5";
    sources     = [{ filename = "mingw-w64-i686-python-theano-1.0.5-1-any.pkg.tar.zst"; sha256 = "3c97b78158033dd0a0d31e4ad1abf289a3d78bf3d66bb771e663e62ea7f0221e"; }];
    buildInputs = [ python python-numpy python-scipy python-six ];
  };

  "python-tifffile" = fetch {
    pname       = "python-tifffile";
    version     = "2020.10.1";
    sources     = [{ filename = "mingw-w64-i686-python-tifffile-2020.10.1-1-any.pkg.tar.zst"; sha256 = "6961839efdd71b1523c5ca4702bc193ceffaf98c19aa3fea01c8d5ec89180232"; }];
    buildInputs = [ python-numpy ];
  };

  "python-toml" = fetch {
    pname       = "python-toml";
    version     = "0.10.0";
    sources     = [{ filename = "mingw-w64-i686-python-toml-0.10.0-1-any.pkg.tar.xz"; sha256 = "9ec5d58b745212e1522bbe7be2ed1f2b4f4a392d213c484ec252a3566ee624b2"; }];
    buildInputs = [ python ];
  };

  "python-toposort" = fetch {
    pname       = "python-toposort";
    version     = "1.5";
    sources     = [{ filename = "mingw-w64-i686-python-toposort-1.5-2-any.pkg.tar.zst"; sha256 = "bf0f604704ed19f5da71756a3db145a9887d6a8bea768b9f1b4f04646ff15549"; }];
    buildInputs = [ python ];
  };

  "python-tornado" = fetch {
    pname       = "python-tornado";
    version     = "6.0.4";
    sources     = [{ filename = "mingw-w64-i686-python-tornado-6.0.4-1-any.pkg.tar.xz"; sha256 = "6aa8c895715cefa787d2b07de11d8d8695775a94b9dc3f64bec34bb0a15fd5d4"; }];
    buildInputs = [ python ];
  };

  "python-tox" = fetch {
    pname       = "python-tox";
    version     = "3.20.0";
    sources     = [{ filename = "mingw-w64-i686-python-tox-3.20.0-1-any.pkg.tar.zst"; sha256 = "d0843d761c0cd6af9a3db04c0ec1b0412b18b9ad446eaea24caa33c619214cf5"; }];
    buildInputs = [ python python-py python-six python-setuptools python-setuptools-scm python-filelock python-toml python-pluggy ];
  };

  "python-tqdm" = fetch {
    pname       = "python-tqdm";
    version     = "4.50.0";
    sources     = [{ filename = "mingw-w64-i686-python-tqdm-4.50.0-1-any.pkg.tar.zst"; sha256 = "7934f090fb8002f25bcaa007dd309bcacc1c180502ab366383fde29e3443893b"; }];
    buildInputs = [ python ];
  };

  "python-tracery" = fetch {
    pname       = "python-tracery";
    version     = "0.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-tracery-0.1.1-1-any.pkg.tar.zst"; sha256 = "5b59e98277044187975e39d26d50d95f0c8508e2a19366eb21d202d3a3b3698a"; }];
    buildInputs = [ python ];
  };

  "python-traitlets" = fetch {
    pname       = "python-traitlets";
    version     = "4.3.3";
    sources     = [{ filename = "mingw-w64-i686-python-traitlets-4.3.3-1-any.pkg.tar.xz"; sha256 = "08739432ad3165ff4badde17cb7e622185e1b50d1ed3b0945cf58bb1ab02debb"; }];
    buildInputs = [ python-ipython_genutils python-decorator ];
  };

  "python-trimesh" = fetch {
    pname       = "python-trimesh";
    version     = "3.8.10";
    sources     = [{ filename = "mingw-w64-i686-python-trimesh-3.8.10-1-any.pkg.tar.zst"; sha256 = "07b97033d42a216eada145eef6524e3e62c1adf206103087b989c4ee4cb2992d"; }];
    buildInputs = [ python-numpy ];
  };

  "python-typed_ast" = fetch {
    pname       = "python-typed_ast";
    version     = "1.4.1";
    sources     = [{ filename = "mingw-w64-i686-python-typed_ast-1.4.1-1-any.pkg.tar.xz"; sha256 = "cc04f3db0554125c5fd765d91351e6cb4d3d4d830be9fdbe4fe9b9779e9c05ff"; }];
    buildInputs = [ python ];
  };

  "python-typing_extensions" = fetch {
    pname       = "python-typing_extensions";
    version     = "3.7.4.3";
    sources     = [{ filename = "mingw-w64-i686-python-typing_extensions-3.7.4.3-1-any.pkg.tar.zst"; sha256 = "f226c3e752c94c6cce2229a59ca798cc37ebf93320090d6f5c242f3092ca104e"; }];
    buildInputs = [ python ];
  };

  "python-u-msgpack" = fetch {
    pname       = "python-u-msgpack";
    version     = "2.6.0";
    sources     = [{ filename = "mingw-w64-i686-python-u-msgpack-2.6.0-1-any.pkg.tar.zst"; sha256 = "ffbad6bb5110734c9f24add8c825ec098fa16adc3c0255515131e0f94adb9fc9"; }];
    buildInputs = [ python ];
  };

  "python-udsoncan" = fetch {
    pname       = "python-udsoncan";
    version     = "1.9";
    sources     = [{ filename = "mingw-w64-i686-python-udsoncan-1.9-1-any.pkg.tar.xz"; sha256 = "1741f4332724b8a04ba175065d1e20585f4ad550c5eb25a249cb44a76a66d8bf"; }];
    buildInputs = [ python ];
  };

  "python-ukpostcodeparser" = fetch {
    pname       = "python-ukpostcodeparser";
    version     = "1.1.2";
    sources     = [{ filename = "mingw-w64-i686-python-ukpostcodeparser-1.1.2-1-any.pkg.tar.xz"; sha256 = "09874e89fdc1b3a3e4516c90884d6af2115c1905cf9a32ffcedfe92c13570961"; }];
    buildInputs = [ python ];
  };

  "python-unicorn" = fetch {
    pname       = "python-unicorn";
    version     = "1.0.2rc1";
    sources     = [{ filename = "mingw-w64-i686-python-unicorn-1.0.2rc1-1-any.pkg.tar.xz"; sha256 = "6c73f05c8427f28a722e9ce96a053573600efcf6cb4c52fb0c42efe7b7af2a95"; }];
    buildInputs = [ python unicorn ];
  };

  "python-unidecode" = fetch {
    pname       = "python-unidecode";
    version     = "1.1.1";
    sources     = [{ filename = "mingw-w64-i686-python-unidecode-1.1.1-1-any.pkg.tar.zst"; sha256 = "8e889e9e3db0ff89edf58f8d92890421cc753ed9e2be567a054bab317830c8d8"; }];
    buildInputs = [ python ];
  };

  "python-urllib3" = fetch {
    pname       = "python-urllib3";
    version     = "1.25.9";
    sources     = [{ filename = "mingw-w64-i686-python-urllib3-1.25.9-1-any.pkg.tar.zst"; sha256 = "54e5f5f6b463d71dcf5234c2c1e492b467beb00a12e16e0fef98d7efdae57956"; }];
    buildInputs = [ python python-certifi python-idna ];
  };

  "python-virtualenv" = fetch {
    pname       = "python-virtualenv";
    version     = "20.0.35";
    sources     = [{ filename = "mingw-w64-i686-python-virtualenv-20.0.35-1-any.pkg.tar.zst"; sha256 = "83203cb788ce10b72dffdf162c4f548fe035cf40f9eebecd785bf85c106da03a"; }];
    buildInputs = [ python-setuptools python-appdirs python-distlib python-filelock python-six ];
  };

  "python-voluptuous" = fetch {
    pname       = "python-voluptuous";
    version     = "0.11.7";
    sources     = [{ filename = "mingw-w64-i686-python-voluptuous-0.11.7-1-any.pkg.tar.xz"; sha256 = "3b14f3c1f23ce581d5467364e05b9016754a709c1f9bbe1d6e84dcd45ceafed6"; }];
    buildInputs = [ python ];
  };

  "python-watchdog" = fetch {
    pname       = "python-watchdog";
    version     = "0.10.2";
    sources     = [{ filename = "mingw-w64-i686-python-watchdog-0.10.2-1-any.pkg.tar.xz"; sha256 = "55222d39c8a4c53f55e7097f70324064f88471e40234e8636fdecb7350eda4a4"; }];
    buildInputs = [ python python-argh python-pathtools python-yaml ];
  };

  "python-wcwidth" = fetch {
    pname       = "python-wcwidth";
    version     = "0.1.9";
    sources     = [{ filename = "mingw-w64-i686-python-wcwidth-0.1.9-1-any.pkg.tar.zst"; sha256 = "aca75ed2ed50416e28b92ec6cce5ea55763ab319bcb75dae455c1943a0137a3b"; }];
    buildInputs = [ python ];
  };

  "python-webcolors" = fetch {
    pname       = "python-webcolors";
    version     = "1.11.1";
    sources     = [{ filename = "mingw-w64-i686-python-webcolors-1.11.1-1-any.pkg.tar.xz"; sha256 = "0384809c14693b1e8bf18723770d13979845bd7bfa9d606080b6730c8606544b"; }];
    buildInputs = [ python ];
  };

  "python-webencodings" = fetch {
    pname       = "python-webencodings";
    version     = "0.5.1";
    sources     = [{ filename = "mingw-w64-i686-python-webencodings-0.5.1-1-any.pkg.tar.xz"; sha256 = "619acfad31bbcb81892d1dda4b93d7ff212627002fdf19bc11c2d236d52dfe36"; }];
    buildInputs = [ python ];
  };

  "python-websocket-client" = fetch {
    pname       = "python-websocket-client";
    version     = "0.57.0";
    sources     = [{ filename = "mingw-w64-i686-python-websocket-client-0.57.0-1-any.pkg.tar.xz"; sha256 = "b174faad9b4fd12628236d5c45991c72d5006a5387a339467a447ab59d69182c"; }];
    buildInputs = [ python python-six ];
  };

  "python-werkzeug" = fetch {
    pname       = "python-werkzeug";
    version     = "1.0.1";
    sources     = [{ filename = "mingw-w64-i686-python-werkzeug-1.0.1-1-any.pkg.tar.zst"; sha256 = "85e4559051a641bd6f9835a3b1c864a7a340dff0c9da177d01087f83c0dc2af3"; }];
    buildInputs = [ python ];
  };

  "python-wheel" = fetch {
    pname       = "python-wheel";
    version     = "0.34.2";
    sources     = [{ filename = "mingw-w64-i686-python-wheel-0.34.2-1-any.pkg.tar.xz"; sha256 = "46ef2282b7b9244607953be6ece59e0d59e1f7fe7089b725785cc0c295f0d41d"; }];
    buildInputs = [ python ];
  };

  "python-whoosh" = fetch {
    pname       = "python-whoosh";
    version     = "2.7.4";
    sources     = [{ filename = "mingw-w64-i686-python-whoosh-2.7.4-1-any.pkg.tar.xz"; sha256 = "201b7a8e2f9ae64427e02a0f7c47ba3f1949225c3aaed0af38ccb0e186f02a3c"; }];
    buildInputs = [ python ];
  };

  "python-win_inet_pton" = fetch {
    pname       = "python-win_inet_pton";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-win_inet_pton-1.1.0-1-any.pkg.tar.xz"; sha256 = "4b68517e0bf51de85692b4815899a90c0bdaf60b58b4246697da306765133ccb"; }];
    buildInputs = [ python ];
  };

  "python-win_unicode_console" = fetch {
    pname       = "python-win_unicode_console";
    version     = "0.5";
    sources     = [{ filename = "mingw-w64-i686-python-win_unicode_console-0.5-1-any.pkg.tar.xz"; sha256 = "da2d718c52375b4f9a6d616c3df7a062d27339dad91b0eeec77eac1fe5aa5a2b"; }];
    buildInputs = [ python ];
  };

  "python-wincertstore" = fetch {
    pname       = "python-wincertstore";
    version     = "0.2";
    sources     = [{ filename = "mingw-w64-i686-python-wincertstore-0.2-1-any.pkg.tar.xz"; sha256 = "8b9c29c54b165037a44828c6d045d113aa1ed5a9251c1a1a5b4b1218c2e64bf1"; }];
    buildInputs = [ python ];
  };

  "python-winkerberos" = fetch {
    pname       = "python-winkerberos";
    version     = "0.7.0";
    sources     = [{ filename = "mingw-w64-i686-python-winkerberos-0.7.0-1-any.pkg.tar.xz"; sha256 = "52eb8e0b61de1074a460cbaafbc3bcbc5f47d32e31c3574ab5405fabf0f29222"; }];
    buildInputs = [ python ];
  };

  "python-wrapt" = fetch {
    pname       = "python-wrapt";
    version     = "1.12.1";
    sources     = [{ filename = "mingw-w64-i686-python-wrapt-1.12.1-1-any.pkg.tar.xz"; sha256 = "4e8ea75c3c2d09a14a46536fe6bb54648befa4af70e125da2646d786636bbbcc"; }];
    buildInputs = [ python ];
  };

  "python-xdg" = fetch {
    pname       = "python-xdg";
    version     = "0.26";
    sources     = [{ filename = "mingw-w64-i686-python-xdg-0.26-1-any.pkg.tar.xz"; sha256 = "2f014a509bfc1c1d1cb25819b8e6d14b28645d6f6e49be6ff9a68ac06b81aec3"; }];
    buildInputs = [ python ];
  };

  "python-xlrd" = fetch {
    pname       = "python-xlrd";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-python-xlrd-1.2.0-1-any.pkg.tar.xz"; sha256 = "1a00e73448cec42df687208b81b78601dbcca9ebf838714f30c3ce74948bf583"; }];
    buildInputs = [ python ];
  };

  "python-xlsxwriter" = fetch {
    pname       = "python-xlsxwriter";
    version     = "1.2.8";
    sources     = [{ filename = "mingw-w64-i686-python-xlsxwriter-1.2.8-1-any.pkg.tar.xz"; sha256 = "5aa131a814a8737484d94dff9ce4fa5813645d464b90f5c4aa997262fe49fa79"; }];
    buildInputs = [ python ];
  };

  "python-xlwt" = fetch {
    pname       = "python-xlwt";
    version     = "1.3.0";
    sources     = [{ filename = "mingw-w64-i686-python-xlwt-1.3.0-1-any.pkg.tar.xz"; sha256 = "93e1a427f214e7adbb883f8e29b8f9339d5ca0abe15c35b96d48e2735a7159e1"; }];
    buildInputs = [ python ];
  };

  "python-xpra" = fetch {
    pname       = "python-xpra";
    version     = "4.0";
    sources     = [{ filename = "mingw-w64-i686-python-xpra-4.0-1-any.pkg.tar.zst"; sha256 = "80831a40d9bfb62920c19bde22f6c7576f31c8a457df907f806298606e8159b7"; }];
    buildInputs = [ ffmpeg gtk3 libyuv-git libvpx x264-git libwebp libjpeg-turbo python python-lz4 python-rencode python-pillow python-pyopengl python-comtypes python-setproctitle ];
  };

  "python-yaml" = fetch {
    pname       = "python-yaml";
    version     = "5.3.1";
    sources     = [{ filename = "mingw-w64-i686-python-yaml-5.3.1-1-any.pkg.tar.xz"; sha256 = "457addb4c6b065e47d5930b75c750c2d497ec4999b21bb3dd9d89e6ddf910392"; }];
    buildInputs = [ python libyaml ];
  };

  "python-yarl" = fetch {
    pname       = "python-yarl";
    version     = "1.6.0";
    sources     = [{ filename = "mingw-w64-i686-python-yarl-1.6.0-1-any.pkg.tar.zst"; sha256 = "2c90fe02506d33e03097a24e6338c33ac87bc4635af7baf1005f8b140fadcb5d"; }];
    buildInputs = [ python-idna python-multidict python-typing_extensions ];
  };

  "python-zeroconf" = fetch {
    pname       = "python-zeroconf";
    version     = "0.25.1";
    sources     = [{ filename = "mingw-w64-i686-python-zeroconf-0.25.1-1-any.pkg.tar.zst"; sha256 = "100342b667cc69e3a97163122165863f51e9e1c37cde2f173432d8c54b8864d3"; }];
    buildInputs = [ python python-ifaddr python-netifaces python-six ];
  };

  "python-zipp" = fetch {
    pname       = "python-zipp";
    version     = "3.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-zipp-3.1.0-1-any.pkg.tar.xz"; sha256 = "1242f02fe5f0c1b6d5578798c4ea3ee731651b2737570a56314596aaebabc014"; }];
    buildInputs = [ python python-more-itertools ];
  };

  "python-zope.event" = fetch {
    pname       = "python-zope.event";
    version     = "4.4";
    sources     = [{ filename = "mingw-w64-i686-python-zope.event-4.4-1-any.pkg.tar.xz"; sha256 = "56011e9a01e30da2e08cbc42edea49d91382d8a12664f02d80421362f339456e"; }];
    buildInputs = [ python ];
  };

  "python-zope.interface" = fetch {
    pname       = "python-zope.interface";
    version     = "5.1.0";
    sources     = [{ filename = "mingw-w64-i686-python-zope.interface-5.1.0-1-any.pkg.tar.xz"; sha256 = "845ea9b38e445da644911b618216db40fa11c23fdde4b3ab6eef1a1d17236030"; }];
    buildInputs = [ python ];
  };

  "python2" = fetch {
    pname       = "python2";
    version     = "2.7.18";
    sources     = [{ filename = "mingw-w64-i686-python2-2.7.18-1-any.pkg.tar.xz"; sha256 = "14ca179bebd0c756d64687a3b24336177eef7c25daf6bd882334479420f93229"; }];
    buildInputs = [ gcc-libs expat bzip2 libffi ncurses openssl sqlite3 tcl tk zlib ];
  };

  "python2-cairo" = fetch {
    pname       = "python2-cairo";
    version     = "1.18.2";
    sources     = [{ filename = "mingw-w64-i686-python2-cairo-1.18.2-3-any.pkg.tar.xz"; sha256 = "f6ca782ed0675c5dc25da35e10339f402cae9c6d3f2fc1a493fe753d0fd58538"; }];
    buildInputs = [ cairo python2 ];
  };

  "python2-gobject2" = fetch {
    pname       = "python2-gobject2";
    version     = "2.28.7";
    sources     = [{ filename = "mingw-w64-i686-python2-gobject2-2.28.7-3-any.pkg.tar.xz"; sha256 = "1f3ae358d55daa1992445f4301c72803f5626d25aefe1c435c224f459f0751f1"; }];
    buildInputs = [ glib2 libffi gobject-introspection-runtime (assert pygobject2-devel.version=="2.28.7"; pygobject2-devel) ];
  };

  "python2-pip" = fetch {
    pname       = "python2-pip";
    version     = "20.0.2";
    sources     = [{ filename = "mingw-w64-i686-python2-pip-20.0.2-1-any.pkg.tar.xz"; sha256 = "b8c4965e8fdcd84a7ca01ab1d4d0d7f260feb276c92509652a250b013554cf5d"; }];
    buildInputs = [ python2 python2-setuptools ];
  };

  "python2-pygtk" = fetch {
    pname       = "python2-pygtk";
    version     = "2.24.0";
    sources     = [{ filename = "mingw-w64-i686-python2-pygtk-2.24.0-7-any.pkg.tar.xz"; sha256 = "eaa74ec30f405bc5f560b63dc7c75978c30b0b904b65b9d5d0fc1bd2da8181ef"; }];
    buildInputs = [ python2-cairo python2-gobject2 atk pango gtk2 libglade ];
  };

  "python2-setuptools" = fetch {
    pname       = "python2-setuptools";
    version     = "44.1.1";
    sources     = [{ filename = "mingw-w64-i686-python2-setuptools-44.1.1-1-any.pkg.tar.zst"; sha256 = "94d2accbdc36f2eae86fcda5463933563b66815496e3e7ade03908778f440a6c"; }];
    buildInputs = [ python2 ];
  };

  "qbittorrent" = fetch {
    pname       = "qbittorrent";
    version     = "4.3.0";
    sources     = [{ filename = "mingw-w64-i686-qbittorrent-4.3.0-1-any.pkg.tar.zst"; sha256 = "54da036306456bbff4b7f81551e6bd6f4418d67454df45667adbaa9e7743f3c5"; }];
    buildInputs = [ boost qt5 libtorrent-rasterbar zlib ];
  };

  "qbs" = fetch {
    pname       = "qbs";
    version     = "1.17.0";
    sources     = [{ filename = "mingw-w64-i686-qbs-1.17.0-1-any.pkg.tar.zst"; sha256 = "4461896503b0f68d4e3ee3dabe5b7fdbd3baeb74221a8ec50e112df6ed5614d6"; }];
    buildInputs = [ qt5 ];
  };

  "qca-qt5" = fetch {
    pname       = "qca-qt5";
    version     = "2.3.1";
    sources     = [{ filename = "mingw-w64-i686-qca-qt5-2.3.1-1-any.pkg.tar.zst"; sha256 = "33b455fb7a83e1b77b73fe75157606fc8ff38676b8da80a7bd82f96914022ec3"; }];
    buildInputs = [ ca-certificates cyrus-sasl gnupg libgcrypt nss openssl qt5 ];
  };

  "qemu" = fetch {
    pname       = "qemu";
    version     = "5.1.0";
    sources     = [{ filename = "mingw-w64-i686-qemu-5.1.0-1-any.pkg.tar.zst"; sha256 = "68d2daffc4aace7d86d207b3c81ef2820a8068756c992b1f44b35af7cfeada08"; }];
    buildInputs = [ capstone curl cyrus-sasl glib2 gnutls gtk3 libjpeg libpng libssh libtasn1 libusb libxml2 lzo2 nettle pixman snappy SDL2 SDL2_image libslirp usbredir zstd ];
  };

  "qhttpengine" = fetch {
    pname       = "qhttpengine";
    version     = "1.0.1";
    sources     = [{ filename = "mingw-w64-i686-qhttpengine-1.0.1-1-any.pkg.tar.xz"; sha256 = "2a41f4fb5e694c8651d58931bad6540fdfb891907fff806bad4a80c3c4f1a8b1"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast qt5.version "5.4"; qt5) ];
  };

  "qhull-git" = fetch {
    pname       = "qhull-git";
    version     = "r166.f1f8b42";
    sources     = [{ filename = "mingw-w64-i686-qhull-git-r166.f1f8b42-1-any.pkg.tar.xz"; sha256 = "879517cfaaf0ee26f910c974a1aead003ba5a8968bdc5100f9580110603ea087"; }];
    buildInputs = [ gcc-libs ];
  };

  "qmdnsengine" = fetch {
    pname       = "qmdnsengine";
    version     = "0.2.0";
    sources     = [{ filename = "mingw-w64-i686-qmdnsengine-0.2.0-1-any.pkg.tar.xz"; sha256 = "1c14af642be10c38ac029a203138a8d8f41da7f51a26d6bd54d3d67f60987251"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast qt5.version "5.4"; qt5) ];
  };

  "qpdf" = fetch {
    pname       = "qpdf";
    version     = "10.0.1";
    sources     = [{ filename = "mingw-w64-i686-qpdf-10.0.1-1-any.pkg.tar.xz"; sha256 = "3d7a1c2cadc8ffa1900b13fcfc499af43eb18cca2622a21c20d6b91f19f7fa27"; }];
    buildInputs = [ gcc-libs gnutls libjpeg pcre zlib ];
  };

  "qrencode" = fetch {
    pname       = "qrencode";
    version     = "4.1.1";
    sources     = [{ filename = "mingw-w64-i686-qrencode-4.1.1-1-any.pkg.tar.zst"; sha256 = "83d5a76db8f51a2ee4b0d10ae0c72046dcf291777c0151e0ce203992f96ad7e0"; }];
    buildInputs = [ libpng ];
  };

  "qrupdate-svn" = fetch {
    pname       = "qrupdate-svn";
    version     = "r28";
    sources     = [{ filename = "mingw-w64-i686-qrupdate-svn-r28-4-any.pkg.tar.xz"; sha256 = "512c6a4f742f8427a1756cdd49e31ecca76785d662efde9fc645cf902065be0d"; }];
    buildInputs = [ openblas ];
  };

  "qscintilla" = fetch {
    pname       = "qscintilla";
    version     = "2.11.5";
    sources     = [{ filename = "mingw-w64-i686-qscintilla-2.11.5-1-any.pkg.tar.zst"; sha256 = "0816d3cb0d3abe07dffd5ce80f004711c78cb6264831056204c4bdaf5fc1362f"; }];
    buildInputs = [ qt5 ];
  };

  "qt-creator" = fetch {
    pname       = "qt-creator";
    version     = "4.13.2";
    sources     = [{ filename = "mingw-w64-i686-qt-creator-4.13.2-1-any.pkg.tar.zst"; sha256 = "6bf647205885c7ac2296378ee9ceb5d1d71a9b72b359246363ffff3ff6e33021"; }];
    buildInputs = [ qt5 gcc make qbs ];
  };

  "qt-installer-framework" = fetch {
    pname       = "qt-installer-framework";
    version     = "3.2.3";
    sources     = [{ filename = "mingw-w64-i686-qt-installer-framework-3.2.3-1-any.pkg.tar.zst"; sha256 = "bcff88e037c9b766c3ab20d7024ef4660b3a25d0abdd8357ebc567e0bd692271"; }];
  };

  "qt5" = fetch {
    pname       = "qt5";
    version     = "5.15.1";
    sources     = [{ filename = "mingw-w64-i686-qt5-5.15.1-1-any.pkg.tar.zst"; sha256 = "c6651421957f9ce44494674aa1776ad53bc41ece45cb42e702848690ad6eb12f"; }];
    buildInputs = [ gcc-libs qtbinpatcher z3 assimp double-conversion dbus fontconfig freetype harfbuzz jasper libjpeg libmng libpng libtiff libxml2 libxslt libwebp openssl openal pcre2 sqlite3 vulkan xpm-nox zlib icu icu-debug-libs ];
  };

  "qt5-debug" = fetch {
    pname       = "qt5-debug";
    version     = "5.15.1";
    sources     = [{ filename = "mingw-w64-i686-qt5-debug-5.15.1-1-any.pkg.tar.zst"; sha256 = "73dc93cce0580bbc5c464cf287f89d7549b732afadac7f9f47508ba1fa19584a"; }];
    buildInputs = [ gcc-libs qtbinpatcher z3 assimp double-conversion dbus fontconfig freetype harfbuzz jasper libjpeg libmng libpng libtiff libxml2 libxslt libwebp openssl openal pcre2 sqlite3 vulkan xpm-nox zlib icu icu-debug-libs ];
  };

  "qt5-static" = fetch {
    pname       = "qt5-static";
    version     = "5.15.1";
    sources     = [{ filename = "mingw-w64-i686-qt5-static-5.15.1-1-any.pkg.tar.zst"; sha256 = "48f38fdfc516273ee14d06422eb821af3ac5186f64cc7d251ff17760d96ac361"; }];
    buildInputs = [ gcc-libs qtbinpatcher z3 ];
  };

  "qtbinpatcher" = fetch {
    pname       = "qtbinpatcher";
    version     = "2.2.0";
    sources     = [{ filename = "mingw-w64-i686-qtbinpatcher-2.2.0-4-any.pkg.tar.xz"; sha256 = "2f0ca89b98631a1b0e0272ca895979f4fcf1c462a4d920f3164e10930a37b311"; }];
    buildInputs = [  ];
  };

  "qtwebkit" = fetch {
    pname       = "qtwebkit";
    version     = "5.212.0alpha4";
    sources     = [{ filename = "mingw-w64-i686-qtwebkit-5.212.0alpha4-5-any.pkg.tar.zst"; sha256 = "d60eeb79678939a34e7dfd4ec65c7c811d2a691e4b9836d7c0255e807bc30396"; }];
    buildInputs = [ icu libxml2 libxslt libwebp fontconfig sqlite3 (assert qt5.version=="5.15.1"; qt5) woff2 ];
  };

  "quantlib" = fetch {
    pname       = "quantlib";
    version     = "1.19";
    sources     = [{ filename = "mingw-w64-i686-quantlib-1.19-1-any.pkg.tar.zst"; sha256 = "0bf26aaf008d282ca9912d8b5d2d733f11e70dfc47c89b98fb148267f29c8092"; }];
    buildInputs = [ boost ];
  };

  "quassel" = fetch {
    pname       = "quassel";
    version     = "0.13.1";
    sources     = [{ filename = "mingw-w64-i686-quassel-0.13.1-2-any.pkg.tar.xz"; sha256 = "599271cfd9ad92bb098a19dd54a21a553e8e832cbd71ff65019ceca74b1705c5"; }];
    buildInputs = [ qt5 qca-qt5 Snorenotify sonnet-qt5 ];
    broken      = true; # broken dependency quassel -> Snorenotify
  };

  "quazip" = fetch {
    pname       = "quazip";
    version     = "0.9.1";
    sources     = [{ filename = "mingw-w64-i686-quazip-0.9.1-1-any.pkg.tar.zst"; sha256 = "4e96b249c3ada5ec45d99e52dd31edbda83adb7d60fe8391a74f03de4324600c"; }];
    buildInputs = [ qt5 zlib ];
  };

  "qwt" = fetch {
    pname       = "qwt";
    version     = "6.1.5";
    sources     = [{ filename = "mingw-w64-i686-qwt-6.1.5-1-any.pkg.tar.zst"; sha256 = "d37d7d8a959ec26b26f6ff35b327ef589447aff7844dde06970fb20747ebf66f"; }];
    buildInputs = [ qt5 ];
  };

  "qxmpp" = fetch {
    pname       = "qxmpp";
    version     = "1.3.1";
    sources     = [{ filename = "mingw-w64-i686-qxmpp-1.3.1-1-any.pkg.tar.zst"; sha256 = "b2e941449b1a7315374a1479e40e08f87542a5f033e40aff947b41d9946fe5ae"; }];
    buildInputs = [ libtheora libvpx opus qt5 speex ];
  };

  "rabbitmq-c" = fetch {
    pname       = "rabbitmq-c";
    version     = "0.10.0";
    sources     = [{ filename = "mingw-w64-i686-rabbitmq-c-0.10.0-1-any.pkg.tar.xz"; sha256 = "f8ee7684ffbd1ee4974f1575de2bb7c022d4be5102f7a6f5d3b7447f2579cfe2"; }];
    buildInputs = [ openssl popt ];
  };

  "ragel" = fetch {
    pname       = "ragel";
    version     = "6.10";
    sources     = [{ filename = "mingw-w64-i686-ragel-6.10-1-any.pkg.tar.xz"; sha256 = "d4639e3a5d3ed9b273d9916523bb980a864742044cb02217f8ac8f217c5c387f"; }];
    buildInputs = [ gcc-libs ];
  };

  "rapidjson" = fetch {
    pname       = "rapidjson";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-rapidjson-1.1.0-1-any.pkg.tar.xz"; sha256 = "5a8530ca5246a8d045e91cdd08b82763c74f8610f30018e9e032f0cd462dab63"; }];
  };

  "rav1e" = fetch {
    pname       = "rav1e";
    version     = "0.3.3";
    sources     = [{ filename = "mingw-w64-i686-rav1e-0.3.3-3-any.pkg.tar.zst"; sha256 = "7c37fa28811b5a1a621c8e8c2d09346b2866e3e4b5e97f5ae094b67952c671d2"; }];
    buildInputs = [ gcc-libs ];
  };

  "re2" = fetch {
    pname       = "re2";
    version     = "20200801";
    sources     = [{ filename = "mingw-w64-i686-re2-20200801-1-any.pkg.tar.zst"; sha256 = "bb6812917d2bcb301f14c02519b40c982b30f0df49e1d84fb7812eaf69b0d707"; }];
    buildInputs = [ gcc-libs ];
  };

  "readline" = fetch {
    pname       = "readline";
    version     = "8.0.004";
    sources     = [{ filename = "mingw-w64-i686-readline-8.0.004-1-any.pkg.tar.xz"; sha256 = "79252f337255054f4ebc34128ca30b2a02bdd1d1018959db4726448d1bdd46e0"; }];
    buildInputs = [ gcc-libs termcap ];
  };

  "readosm" = fetch {
    pname       = "readosm";
    version     = "1.1.0";
    sources     = [{ filename = "mingw-w64-i686-readosm-1.1.0-1-any.pkg.tar.xz"; sha256 = "a0694669eff6082caa770fbe8b19f593457318d6dc5b82d4d0519efbe80a1495"; }];
    buildInputs = [ expat zlib ];
  };

  "recode" = fetch {
    pname       = "recode";
    version     = "3.7.7";
    sources     = [{ filename = "mingw-w64-i686-recode-3.7.7-1-any.pkg.tar.zst"; sha256 = "20fd4e383f71f271fb517d1a7c51373534d7339fc17a49da015e5225b2819eac"; }];
    buildInputs = [ gettext ];
  };

  "rhash" = fetch {
    pname       = "rhash";
    version     = "1.4.0";
    sources     = [{ filename = "mingw-w64-i686-rhash-1.4.0-1-any.pkg.tar.zst"; sha256 = "c87dc9cee98f8fecea924a4278271005c5fffe2aa5c67fdbf869b9baa2218110"; }];
    buildInputs = [ gettext ];
  };

  "rime-bopomofo" = fetch {
    pname       = "rime-bopomofo";
    version     = "0.0.0.20190120";
    sources     = [{ filename = "mingw-w64-i686-rime-bopomofo-0.0.0.20190120-1-any.pkg.tar.xz"; sha256 = "1a352b052b5e2e54edabdaaf1748209805d17ac2578c113220f8d411f66b5ce5"; }];
    buildInputs = [ rime-cangjie rime-terra-pinyin ];
  };

  "rime-cangjie" = fetch {
    pname       = "rime-cangjie";
    version     = "0.0.0.20190120";
    sources     = [{ filename = "mingw-w64-i686-rime-cangjie-0.0.0.20190120-1-any.pkg.tar.xz"; sha256 = "db30c0781063b4ae76ca124f9894e37766681520f5ff11f3ef28814fcaad1f44"; }];
    buildInputs = [ rime-luna-pinyin ];
  };

  "rime-double-pinyin" = fetch {
    pname       = "rime-double-pinyin";
    version     = "0.0.0.20190120";
    sources     = [{ filename = "mingw-w64-i686-rime-double-pinyin-0.0.0.20190120-1-any.pkg.tar.xz"; sha256 = "ce063b7bf60156e26029ab78f5afdfa9a203d8e683257f1f2ef4d64ee5107cfa"; }];
    buildInputs = [ rime-luna-pinyin rime-stroke ];
  };

  "rime-emoji" = fetch {
    pname       = "rime-emoji";
    version     = "0.0.0.20191102";
    sources     = [{ filename = "mingw-w64-i686-rime-emoji-0.0.0.20191102-1-any.pkg.tar.xz"; sha256 = "1efb9b750cc54cebfb05e0ef985436c1b751ade9ef3e263ed4399eddc1812030"; }];
  };

  "rime-essay" = fetch {
    pname       = "rime-essay";
    version     = "0.0.0.20200207";
    sources     = [{ filename = "mingw-w64-i686-rime-essay-0.0.0.20200207-1-any.pkg.tar.xz"; sha256 = "5437aa948463b3e7a778b628316ebf3daa359a6ad65ff6802e18c47b8ea5b333"; }];
    buildInputs = [  ];
  };

  "rime-luna-pinyin" = fetch {
    pname       = "rime-luna-pinyin";
    version     = "0.0.0.20200410";
    sources     = [{ filename = "mingw-w64-i686-rime-luna-pinyin-0.0.0.20200410-1-any.pkg.tar.xz"; sha256 = "f8b0e3dd69f1567a7e19cc1a5f0f9b198ea03999c8d5d042a2d3457eb0a2ebaf"; }];
    buildInputs = [  ];
  };

  "rime-pinyin-simp" = fetch {
    pname       = "rime-pinyin-simp";
    version     = "0.0.0.20190120";
    sources     = [{ filename = "mingw-w64-i686-rime-pinyin-simp-0.0.0.20190120-1-any.pkg.tar.xz"; sha256 = "6e5a2e32632ff513c7c4a94b9d84cd209e734d5cb61326d65fbafca0530eb943"; }];
    buildInputs = [ rime-stroke ];
  };

  "rime-prelude" = fetch {
    pname       = "rime-prelude";
    version     = "0.0.0.20190122";
    sources     = [{ filename = "mingw-w64-i686-rime-prelude-0.0.0.20190122-1-any.pkg.tar.xz"; sha256 = "c50cc4d408357a8a86a05bb5dffd31a145faf5097ba264559c41078dfad76dd7"; }];
    buildInputs = [  ];
  };

  "rime-stroke" = fetch {
    pname       = "rime-stroke";
    version     = "0.0.0.20191221";
    sources     = [{ filename = "mingw-w64-i686-rime-stroke-0.0.0.20191221-1-any.pkg.tar.xz"; sha256 = "a46580b4323c87b407c0d898d859570f5037de793aec8511e5af1fa7dd8f6a2f"; }];
    buildInputs = [ rime-luna-pinyin ];
  };

  "rime-terra-pinyin" = fetch {
    pname       = "rime-terra-pinyin";
    version     = "0.0.0.20200207";
    sources     = [{ filename = "mingw-w64-i686-rime-terra-pinyin-0.0.0.20200207-1-any.pkg.tar.xz"; sha256 = "fbf1e100cc003701a06cecb3ed9b900c701d5836d6b1a65a74b1f27815ec8ea6"; }];
    buildInputs = [ rime-stroke ];
  };

  "rime-wubi" = fetch {
    pname       = "rime-wubi";
    version     = "0.0.0.20190120";
    sources     = [{ filename = "mingw-w64-i686-rime-wubi-0.0.0.20190120-1-any.pkg.tar.zst"; sha256 = "182df878a4036539cc4b3af9b359cadc646e7cda1b207c21454aed2375d178e4"; }];
    buildInputs = [ rime-pinyin-simp ];
  };

  "riscv64-unknown-elf-binutils" = fetch {
    pname       = "riscv64-unknown-elf-binutils";
    version     = "2.35";
    sources     = [{ filename = "mingw-w64-i686-riscv64-unknown-elf-binutils-2.35-1-any.pkg.tar.zst"; sha256 = "eec82f54baeff57ae0f49f924b8333e15552bff3a66cc59772a0b225c7acd1b6"; }];
  };

  "riscv64-unknown-elf-newlib" = fetch {
    pname       = "riscv64-unknown-elf-newlib";
    version     = "3.3.0";
    sources     = [{ filename = "mingw-w64-i686-riscv64-unknown-elf-newlib-3.3.0-1-any.pkg.tar.zst"; sha256 = "70e402ab76bc67d26e6875600e40b7b988319e2d494e2085c3677941b4a9b319"; }];
    buildInputs = [ riscv64-unknown-elf-binutils ];
  };

  "rocksdb" = fetch {
    pname       = "rocksdb";
    version     = "6.12.7";
    sources     = [{ filename = "mingw-w64-i686-rocksdb-6.12.7-1-any.pkg.tar.zst"; sha256 = "404fb7659c4496711f3da48fd12a4889a1c664b44561473037de0c3cd2d23b57"; }];
    buildInputs = [ bzip2 intel-tbb lz4 snappy zlib zstd ];
  };

  "rtmpdump-git" = fetch {
    pname       = "rtmpdump-git";
    version     = "r514.c5f04a5";
    sources     = [{ filename = "mingw-w64-i686-rtmpdump-git-r514.c5f04a5-3-any.pkg.tar.zst"; sha256 = "4960060f0ec50ae65f4051205ecf6a76cc9701f85b7b4210e1e46d83d9159a7b"; }];
    buildInputs = [ gcc-libs gmp gnutls nettle zlib ];
  };

  "rubberband" = fetch {
    pname       = "rubberband";
    version     = "1.9.0";
    sources     = [{ filename = "mingw-w64-i686-rubberband-1.9.0-1-any.pkg.tar.zst"; sha256 = "9824ee159aa821a8d773f2ac55176fd64aa06cafbfb8522ecd93c55e53a656a0"; }];
    buildInputs = [ gcc-libs fftw libsamplerate libsndfile ladspa-sdk vamp-plugin-sdk ];
  };

  "ruby" = fetch {
    pname       = "ruby";
    version     = "2.7.1";
    sources     = [{ filename = "mingw-w64-i686-ruby-2.7.1-2-any.pkg.tar.xz"; sha256 = "fb17b199a03914f0010214274ba8d2d5a3121ac7714139174fef59ec8972ae88"; }];
    buildInputs = [ gcc-libs gdbm libyaml libffi pdcurses openssl tk ];
  };

  "ruby-cairo" = fetch {
    pname       = "ruby-cairo";
    version     = "1.16.5";
    sources     = [{ filename = "mingw-w64-i686-ruby-cairo-1.16.5-1-any.pkg.tar.xz"; sha256 = "3a179c8de8eb783ee5e8ea7acb99d916e5912a208624e0e0d69b35d83edfb443"; }];
    buildInputs = [ ruby cairo ruby-pkg-config ];
  };

  "ruby-dbus" = fetch {
    pname       = "ruby-dbus";
    version     = "0.16.0";
    sources     = [{ filename = "mingw-w64-i686-ruby-dbus-0.16.0-1-any.pkg.tar.xz"; sha256 = "5054abc50247523758b094eea64c8009a1fee0b7c5afe689f54b2e146b011942"; }];
    buildInputs = [ ruby ];
  };

  "ruby-hpricot" = fetch {
    pname       = "ruby-hpricot";
    version     = "0.8.6";
    sources     = [{ filename = "mingw-w64-i686-ruby-hpricot-0.8.6-2-any.pkg.tar.xz"; sha256 = "43a4cdc255e79e54f06774b331092617098c10bd29d2a2326bcfb4f058d21114"; }];
    buildInputs = [ ruby ];
  };

  "ruby-mustache" = fetch {
    pname       = "ruby-mustache";
    version     = "1.1.1";
    sources     = [{ filename = "mingw-w64-i686-ruby-mustache-1.1.1-1-any.pkg.tar.xz"; sha256 = "f239d84cd41fcc7624de52ae78405ac2d93fd0437517bfae73ea12b73bb1469c"; }];
    buildInputs = [ ruby ];
  };

  "ruby-native-package-installer" = fetch {
    pname       = "ruby-native-package-installer";
    version     = "1.0.9";
    sources     = [{ filename = "mingw-w64-i686-ruby-native-package-installer-1.0.9-1-any.pkg.tar.xz"; sha256 = "e346e11857cc302979a4c425a671940901b5e3e38811ebea89ea3a9d43de3299"; }];
    buildInputs = [ ruby ];
  };

  "ruby-pkg-config" = fetch {
    pname       = "ruby-pkg-config";
    version     = "1.3.7";
    sources     = [{ filename = "mingw-w64-i686-ruby-pkg-config-1.3.7-1-any.pkg.tar.xz"; sha256 = "f8f555bde96d07d134e0f0104f2bfdf8513f61d45107e07ec1f63779946bbc7b"; }];
    buildInputs = [ ruby ];
  };

  "ruby-rake-compiler" = fetch {
    pname       = "ruby-rake-compiler";
    version     = "1.0.7";
    sources     = [{ filename = "mingw-w64-i686-ruby-rake-compiler-1.0.7-1-any.pkg.tar.zst"; sha256 = "2792efc722df1c081d7c8d83f813498062a33133277de295a484fb5042bf59e2"; }];
    buildInputs = [ ruby ];
  };

  "ruby-rdiscount" = fetch {
    pname       = "ruby-rdiscount";
    version     = "2.2.0.1";
    sources     = [{ filename = "mingw-w64-i686-ruby-rdiscount-2.2.0.1-2-any.pkg.tar.xz"; sha256 = "d75c235a1c0eabd3a8d243edfe13b847e9c9043ac5a70bcf628b2e070021bc11"; }];
    buildInputs = [ ruby ];
  };

  "ruby-ronn" = fetch {
    pname       = "ruby-ronn";
    version     = "0.7.3";
    sources     = [{ filename = "mingw-w64-i686-ruby-ronn-0.7.3-2-any.pkg.tar.xz"; sha256 = "623df17f931fceb77cf13434798c5b1aeacbfa28dff093cca2b31f8b8925ef43"; }];
    buildInputs = [ ruby ruby-hpricot ruby-mustache ruby-rdiscount ];
  };

  "rust" = fetch {
    pname       = "rust";
    version     = "1.43.0";
    sources     = [{ filename = "mingw-w64-i686-rust-1.43.0-1-any.pkg.tar.zst"; sha256 = "0a577ef1175441644c2ed28834881c293f032ac7ad54ec32e6c4f53d8ddc9856"; }];
    buildInputs = [ gcc ];
  };

  "rxspencer" = fetch {
    pname       = "rxspencer";
    version     = "alpha3.8.g7";
    sources     = [{ filename = "mingw-w64-i686-rxspencer-alpha3.8.g7-1-any.pkg.tar.xz"; sha256 = "398a876c46165bf5044c2272858bc1f163d535adb0ae33aeb4f68d69c7a57e3d"; }];
  };

  "sassc" = fetch {
    pname       = "sassc";
    version     = "3.6.1";
    sources     = [{ filename = "mingw-w64-i686-sassc-3.6.1-1-any.pkg.tar.xz"; sha256 = "09bd84eefb29036efb8ed0ead4a8d58c013c98fbf820a9e544dd6699be6d9518"; }];
    buildInputs = [ libsass ];
  };

  "scalapack" = fetch {
    pname       = "scalapack";
    version     = "2.1.0";
    sources     = [{ filename = "mingw-w64-i686-scalapack-2.1.0-3-any.pkg.tar.zst"; sha256 = "bf37f2b9e1df5afdcd27abeb1d3f7e4f6902bce1a2993cd171e379c5e9cfc294"; }];
    buildInputs = [ gcc-libs gcc-libgfortran openblas msmpi ];
  };

  "schroedinger" = fetch {
    pname       = "schroedinger";
    version     = "1.0.11";
    sources     = [{ filename = "mingw-w64-i686-schroedinger-1.0.11-4-any.pkg.tar.xz"; sha256 = "392e0cd947c84e3ff1e94c4b17a85be316707d63072fbc94897cc0e85d7d86f9"; }];
    buildInputs = [ orc ];
  };

  "scintilla-gtk3" = fetch {
    pname       = "scintilla-gtk3";
    version     = "4.4.4";
    sources     = [{ filename = "mingw-w64-i686-scintilla-gtk3-4.4.4-2-any.pkg.tar.zst"; sha256 = "07b8f86510a6706f2138ad896607ee4beffb5661497506efb81452d10843286d"; }];
    buildInputs = [ gtk3 ];
  };

  "scite" = fetch {
    pname       = "scite";
    version     = "4.4.5";
    sources     = [{ filename = "mingw-w64-i686-scite-4.4.5-1-any.pkg.tar.zst"; sha256 = "13bb3deed0b8093f15e69c058739ec64875962d5a9e5037cbd8a89bfa6423410"; }];
    buildInputs = [ glib2 gtk3 ];
  };

  "scite-defaults" = fetch {
    pname       = "scite-defaults";
    version     = "4.4.5";
    sources     = [{ filename = "mingw-w64-i686-scite-defaults-4.4.5-1-any.pkg.tar.zst"; sha256 = "615f28a4bfef60f20f09b6f512b40529bda6ddd199c0789a7f23cea89458b151"; }];
    buildInputs = [ (assert scite.version=="4.4.5"; scite) ];
  };

  "scotch" = fetch {
    pname       = "scotch";
    version     = "6.0.9";
    sources     = [{ filename = "mingw-w64-i686-scotch-6.0.9-2-any.pkg.tar.zst"; sha256 = "9c60cf84840918ba590b388a917b075c11a1868ee2f7ba63a8c09784e50c3b04"; }];
    buildInputs = [ gcc-libs msmpi ];
  };

  "scour" = fetch {
    pname       = "scour";
    version     = "0.38.1";
    sources     = [{ filename = "mingw-w64-i686-scour-0.38.1-1-any.pkg.tar.zst"; sha256 = "5283f2c7a8c55093f54d48c7e3af5b84ceb35cf55f12286f41049a22c7646a8d"; }];
    buildInputs = [ python python-setuptools python-six ];
  };

  "scummvm" = fetch {
    pname       = "scummvm";
    version     = "2.0.0";
    sources     = [{ filename = "mingw-w64-i686-scummvm-2.0.0-2-any.pkg.tar.xz"; sha256 = "c175d9265205ca68f119da47bc31b1aef4de2237f3322b897eadcd748d5fa469"; }];
    buildInputs = [ faad2 freetype flac fluidsynth libjpeg-turbo libogg libvorbis libmad libmpeg2-git libtheora libpng nasm readline SDL2 zlib ];
  };

  "sed" = fetch {
    pname       = "sed";
    version     = "4.2.2";
    sources     = [{ filename = "mingw-w64-i686-sed-4.2.2-2-any.pkg.tar.zst"; sha256 = "a9f15a737cddbb88894942a4359eb929993941e29b41ebd0ca5a8a973bffe79b"; }];
  };

  "seexpr" = fetch {
    pname       = "seexpr";
    version     = "2.11";
    sources     = [{ filename = "mingw-w64-i686-seexpr-2.11-1-any.pkg.tar.xz"; sha256 = "5b61f4f425432cb84bbf760f1dca8e7598bb14f89270947642c61ec02b9d5da7"; }];
    buildInputs = [ gcc-libs ];
  };

  "sfml" = fetch {
    pname       = "sfml";
    version     = "2.5.1";
    sources     = [{ filename = "mingw-w64-i686-sfml-2.5.1-2-any.pkg.tar.xz"; sha256 = "4398b8908b3ccf9fe968a0793ccb091d7bac8f2eb83ec68f49b3ff060a32ae93"; }];
    buildInputs = [ flac freetype libjpeg libvorbis openal ];
  };

  "sgml-common" = fetch {
    pname       = "sgml-common";
    version     = "0.6.3";
    sources     = [{ filename = "mingw-w64-i686-sgml-common-0.6.3-1-any.pkg.tar.xz"; sha256 = "815ba9b4ec1991a7185216ac33cda72d1f515bd8894c40131c6d240ecfe0d670"; }];
    buildInputs = [ sh ];
  };

  "shaderc" = fetch {
    pname       = "shaderc";
    version     = "2020.0";
    sources     = [{ filename = "mingw-w64-i686-shaderc-2020.0-1-any.pkg.tar.zst"; sha256 = "116b0e43f0697c2b308305c2f9d370ef3d2672b70c8ad5941bfe30f92ec747ef"; }];
    buildInputs = [ gcc-libs glslang spirv-tools ];
  };

  "shapelib" = fetch {
    pname       = "shapelib";
    version     = "1.5.0";
    sources     = [{ filename = "mingw-w64-i686-shapelib-1.5.0-1-any.pkg.tar.xz"; sha256 = "1fd6ef2b91ee0661b14e28f45eaade7c6e4811a27a7d48ca304b8c51152df1d3"; }];
    buildInputs = [ gcc-libs proj ];
  };

  "shared-mime-info" = fetch {
    pname       = "shared-mime-info";
    version     = "2.0";
    sources     = [{ filename = "mingw-w64-i686-shared-mime-info-2.0-1-any.pkg.tar.zst"; sha256 = "642e7bc13be3432280edfdbecdcd33f692281da449e5fa11c5b1bcc414769ae5"; }];
    buildInputs = [ libxml2 glib2 ];
  };

  "shiboken2-qt5" = fetch {
    pname       = "shiboken2-qt5";
    version     = "5.15.1";
    sources     = [{ filename = "mingw-w64-i686-shiboken2-qt5-5.15.1-1-any.pkg.tar.zst"; sha256 = "b8bf180fdd71287f1a8996f24a7bb5c77c4a9f88beddc978861a5cb908b1a6d4"; }];
    buildInputs = [ python qt5 ];
  };

  "shine" = fetch {
    pname       = "shine";
    version     = "3.1.1";
    sources     = [{ filename = "mingw-w64-i686-shine-3.1.1-1-any.pkg.tar.xz"; sha256 = "329e17389305952eda173001faf11be5cf89c7fc90fc8f434e52967422fd234f"; }];
  };

  "shishi-git" = fetch {
    pname       = "shishi-git";
    version     = "r3586.6fa08895";
    sources     = [{ filename = "mingw-w64-i686-shishi-git-r3586.6fa08895-1-any.pkg.tar.xz"; sha256 = "040967be22fdc45704fd398792e810bbaa1e117a083ecff03357e701996fff75"; }];
    buildInputs = [ gnutls libidn libgcrypt libgpg-error libtasn1 ];
  };

  "silc-toolkit" = fetch {
    pname       = "silc-toolkit";
    version     = "1.1.12";
    sources     = [{ filename = "mingw-w64-i686-silc-toolkit-1.1.12-3-any.pkg.tar.xz"; sha256 = "eb33ee3a81690192576221ad647341fbe2cf19235b922c45e9bf578a8a61ad81"; }];
    buildInputs = [ libsystre ];
  };

  "simdjson" = fetch {
    pname       = "simdjson";
    version     = "0.5.0";
    sources     = [{ filename = "mingw-w64-i686-simdjson-0.5.0-1-any.pkg.tar.zst"; sha256 = "6948e34db011cdb332610b4a574f606a35631b280264000d227a765f1b9c2e78"; }];
    buildInputs = [ gcc-libs ];
  };

  "sip" = fetch {
    pname       = "sip";
    version     = "4.19.22";
    sources     = [{ filename = "mingw-w64-i686-sip-4.19.22-1-any.pkg.tar.xz"; sha256 = "37a32ce7e5ecd78720c1f2ff372b606bef76320ceab8f8104301d74a73c46b13"; }];
    buildInputs = [ gcc-libs ];
  };

  "sip5" = fetch {
    pname       = "sip5";
    version     = "5.4.0";
    sources     = [{ filename = "mingw-w64-i686-sip5-5.4.0-1-any.pkg.tar.zst"; sha256 = "3f1d816af1f1c67712693ba7c8823a1be4de83a24a294c8b16dfeb531657a899"; }];
    buildInputs = [ python-setuptools python-toml python ];
  };

  "skyr-url" = fetch {
    pname       = "skyr-url";
    version     = "1.7.5";
    sources     = [{ filename = "mingw-w64-i686-skyr-url-1.7.5-1-any.pkg.tar.zst"; sha256 = "daa3075aa36a845f37e59030aef7574a7c2f9bdc061d1ad151e0c8649122155d"; }];
    buildInputs = [ tl-expected ];
  };

  "smpeg" = fetch {
    pname       = "smpeg";
    version     = "0.4.5";
    sources     = [{ filename = "mingw-w64-i686-smpeg-0.4.5-2-any.pkg.tar.xz"; sha256 = "2dd5fd201939a20dbd3593660b7b220a07bf1b61fdea8fedbe2cef12e270a1db"; }];
    buildInputs = [ gcc-libs SDL ];
  };

  "smpeg2" = fetch {
    pname       = "smpeg2";
    version     = "2.0.0";
    sources     = [{ filename = "mingw-w64-i686-smpeg2-2.0.0-5-any.pkg.tar.xz"; sha256 = "85d4e3d6cfe0d50d9278ee97bdbadcc0ae0b107ce699a147a46dcd844e0759f5"; }];
    buildInputs = [ gcc-libs SDL2 ];
  };

  "snappy" = fetch {
    pname       = "snappy";
    version     = "1.1.8";
    sources     = [{ filename = "mingw-w64-i686-snappy-1.1.8-1-any.pkg.tar.xz"; sha256 = "6a198715dfe07d137b2619fc234c15bcf971b22195831f5ff37ff81c7c2d580f"; }];
    buildInputs = [ gcc-libs ];
  };

  "snoregrowl" = fetch {
    pname       = "snoregrowl";
    version     = "0.5.0";
    sources     = [{ filename = "mingw-w64-i686-snoregrowl-0.5.0-1-any.pkg.tar.xz"; sha256 = "46a6c363d4490ddfeeb2895096c90e2f728e0f93b16772a88551029330316fe4"; }];
  };

  "snorenotify" = fetch {
    pname       = "snorenotify";
    version     = "0.7.0";
    sources     = [{ filename = "mingw-w64-i686-snorenotify-0.7.0-3-any.pkg.tar.xz"; sha256 = "7b65b561618f5933a35930c8d07566f7dc149a3f369cd4295537bb0f3775c417"; }];
    buildInputs = [ qt5 snoregrowl ];
  };

  "soci" = fetch {
    pname       = "soci";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-soci-4.0.0-1-any.pkg.tar.xz"; sha256 = "ac0dbd77511dd52d7c6c893d15b38a5aeb9fa2f770eac295c2b0ba6f095b02fd"; }];
    buildInputs = [ boost ];
  };

  "soil" = fetch {
    pname       = "soil";
    version     = "1.16.0";
    sources     = [{ filename = "mingw-w64-i686-soil-1.16.0-1-any.pkg.tar.zst"; sha256 = "eba0f9872dbdd03b5452ea0c616c668bf10abe905eb7e56d6078ad1eb7f3d296"; }];
    buildInputs = [ gcc-libs ];
  };

  "solid-qt5" = fetch {
    pname       = "solid-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-solid-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "ffbf974f06f2a1066e72bed7345f0b9e8388f395f36c5588337e7db0dcd3a747"; }];
    buildInputs = [ qt5 ];
  };

  "sonnet-qt5" = fetch {
    pname       = "sonnet-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-sonnet-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "5222937a70cd06dae634c5962a9f9365ec28096572bdaea958797838daa8dd3c"; }];
    buildInputs = [ qt5 ];
  };

  "soqt" = fetch {
    pname       = "soqt";
    version     = "1.6.0";
    sources     = [{ filename = "mingw-w64-i686-soqt-1.6.0-1-any.pkg.tar.zst"; sha256 = "c976a068dcde723e33ce32843d4fabfbfb8d4228fb961978bc9618395575ea04"; }];
    buildInputs = [ gcc-libs coin qt5 ];
  };

  "soundtouch" = fetch {
    pname       = "soundtouch";
    version     = "2.2";
    sources     = [{ filename = "mingw-w64-i686-soundtouch-2.2-1-any.pkg.tar.zst"; sha256 = "97ce6349e1b205d0be0a0481451884d0247a383a3a552a76ba5d82797d9167d2"; }];
    buildInputs = [ gcc-libs ];
  };

  "source-highlight" = fetch {
    pname       = "source-highlight";
    version     = "3.1.9";
    sources     = [{ filename = "mingw-w64-i686-source-highlight-3.1.9-2-any.pkg.tar.zst"; sha256 = "0882abc028cf6c39ef14a7646f6108a19e436357e0503b749c5bef3868bce1c4"; }];
    buildInputs = [ bash boost ];
  };

  "sox" = fetch {
    pname       = "sox";
    version     = "14.4.2.r3203.07de8a77";
    sources     = [{ filename = "mingw-w64-i686-sox-14.4.2.r3203.07de8a77-3-any.pkg.tar.zst"; sha256 = "c513fce0949e655ab5f71d44b26ce0e9dbbfef9aa422f975458f537d7cb30cab"; }];
    buildInputs = [ gcc-libs flac gsm id3lib lame libao libid3tag libmad libpng libsndfile libtool libvorbis opencore-amr opusfile twolame vo-amrwbenc wavpack ];
  };

  "sparsehash" = fetch {
    pname       = "sparsehash";
    version     = "2.0.4";
    sources     = [{ filename = "mingw-w64-i686-sparsehash-2.0.4-1-any.pkg.tar.zst"; sha256 = "5cfa466265b11d9821688bcda6b83bddfcca49d70b54853e842b5d9f20786654"; }];
  };

  "spatialite-tools" = fetch {
    pname       = "spatialite-tools";
    version     = "4.3.0";
    sources     = [{ filename = "mingw-w64-i686-spatialite-tools-4.3.0-3-any.pkg.tar.xz"; sha256 = "ceccdf3f136f4e1a2b27858042b5f75e3e92f74a510baf459ac48a2c29d74624"; }];
    buildInputs = [ libiconv libspatialite readline readosm ];
  };

  "spdlog" = fetch {
    pname       = "spdlog";
    version     = "1.8.1";
    sources     = [{ filename = "mingw-w64-i686-spdlog-1.8.1-1-any.pkg.tar.zst"; sha256 = "95bafef1ec02c5585f7c2921957a7e8bebb9c77b57a4ce6b4efe29f1ad0d82b1"; }];
    buildInputs = [ fmt ];
  };

  "spdylay" = fetch {
    pname       = "spdylay";
    version     = "1.4.0";
    sources     = [{ filename = "mingw-w64-i686-spdylay-1.4.0-1-any.pkg.tar.xz"; sha256 = "49dd04ae49f8a2eeab8820e3546c01cdc1a538515606e98e53ec06e814be8001"; }];
  };

  "speex" = fetch {
    pname       = "speex";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-speex-1.2.0-1-any.pkg.tar.xz"; sha256 = "4b8f760db85b18ef84e47fcc4cb1567191d29db3829115c9aabb742c6ffad4cb"; }];
    buildInputs = [ libogg speexdsp ];
  };

  "speexdsp" = fetch {
    pname       = "speexdsp";
    version     = "1.2.0";
    sources     = [{ filename = "mingw-w64-i686-speexdsp-1.2.0-1-any.pkg.tar.xz"; sha256 = "e4e8c40ab7e0f60d6240190b78fa2b9e23f9cb59235607b8e28c7466c9791749"; }];
    buildInputs = [ gcc-libs ];
  };

  "spice-gtk" = fetch {
    pname       = "spice-gtk";
    version     = "0.38";
    sources     = [{ filename = "mingw-w64-i686-spice-gtk-0.38-1-any.pkg.tar.zst"; sha256 = "cb3a6c8ff6830f8efdd4135030a35bb94ffba3974418c6906300b1b823499813"; }];
    buildInputs = [ cyrus-sasl dbus-glib gobject-introspection gstreamer gst-plugins-base gtk3 libjpeg-turbo lz4 openssl phodav pixman spice-protocol usbredir vala ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "spice-protocol" = fetch {
    pname       = "spice-protocol";
    version     = "0.14.3";
    sources     = [{ filename = "mingw-w64-i686-spice-protocol-0.14.3-2-any.pkg.tar.zst"; sha256 = "b9fc3ecaa706580e78f17a7a5d5af7b54eddfeded3bd011c29c6fb31fa37f60f"; }];
  };

  "spirv-headers" = fetch {
    pname       = "spirv-headers";
    version     = "1.5.3.1";
    sources     = [{ filename = "mingw-w64-i686-spirv-headers-1.5.3.1-1-any.pkg.tar.zst"; sha256 = "98b0cdec9af4cce45584e28feecd021299e74a599f300b5c50bfa43fd8508c7f"; }];
  };

  "spirv-tools" = fetch {
    pname       = "spirv-tools";
    version     = "2020.4";
    sources     = [{ filename = "mingw-w64-i686-spirv-tools-2020.4-1-any.pkg.tar.zst"; sha256 = "6a0cfff22d4dcc99412addf755b1ad4cc463f0278202e7598af253c7e7dc88a0"; }];
    buildInputs = [ gcc-libs ];
  };

  "sqlcipher" = fetch {
    pname       = "sqlcipher";
    version     = "4.4.0";
    sources     = [{ filename = "mingw-w64-i686-sqlcipher-4.4.0-1-any.pkg.tar.zst"; sha256 = "84ed7306c6abe37b376c554ab7dd59947f11f02986d1c923177e5f1e26d6b463"; }];
    buildInputs = [ gcc-libs openssl readline ];
  };

  "sqlheavy" = fetch {
    pname       = "sqlheavy";
    version     = "0.1.1";
    sources     = [{ filename = "mingw-w64-i686-sqlheavy-0.1.1-2-any.pkg.tar.xz"; sha256 = "9bf07d1efbdd8f5a012c1ef660b0646a603aa13c3088a1159520cec108aefaee"; }];
    buildInputs = [ gtk2 sqlite3 vala libxml2 ];
  };

  "sqlite3" = fetch {
    pname       = "sqlite3";
    version     = "3.33.0";
    sources     = [{ filename = "mingw-w64-i686-sqlite3-3.33.0-1-any.pkg.tar.zst"; sha256 = "56015125b4458463a893439cac1ebdcb76bb8d286762718612dc28fb40d24ce3"; }];
    buildInputs = [ gcc-libs readline tcl ];
  };

  "squirrel" = fetch {
    pname       = "squirrel";
    version     = "3.1";
    sources     = [{ filename = "mingw-w64-i686-squirrel-3.1-2-any.pkg.tar.xz"; sha256 = "637f87e5b32cc2d9a7b33b2846fc71192efa157de64b575b4ada8da0eed7a93f"; }];
  };

  "srecord" = fetch {
    pname       = "srecord";
    version     = "1.64";
    sources     = [{ filename = "mingw-w64-i686-srecord-1.64-1-any.pkg.tar.xz"; sha256 = "565e3c20474c2caa05af712ef7738630829a4924e25558d5efc2d82ea0ea5bc8"; }];
    buildInputs = [ gcc-libs libgpg-error libgcrypt ];
  };

  "srt" = fetch {
    pname       = "srt";
    version     = "1.4.2";
    sources     = [{ filename = "mingw-w64-i686-srt-1.4.2-1-any.pkg.tar.zst"; sha256 = "6e189edbb1d0c0285c0500194aa8fd8be02ce40a4274fc91a506c2b154b51fed"; }];
    buildInputs = [ gcc-libs libwinpthread-git openssl ];
  };

  "starpu" = fetch {
    pname       = "starpu";
    version     = "1.3.7";
    sources     = [{ filename = "mingw-w64-i686-starpu-1.3.7-1-any.pkg.tar.zst"; sha256 = "bf7aeb4f43d4c1caac540dbecd3c08b6bd55c4a0ddc4192a63586c1567ce382d"; }];
    buildInputs = [ libtool ];
  };

  "stlink" = fetch {
    pname       = "stlink";
    version     = "1.6.1";
    sources     = [{ filename = "mingw-w64-i686-stlink-1.6.1-1-any.pkg.tar.zst"; sha256 = "60c0c8de34e3d45fd1badfcaa2f0bf7a833bf51112cb15b48e395cb522b344fe"; }];
    buildInputs = [ libusb ];
  };

  "stxxl-git" = fetch {
    pname       = "stxxl-git";
    version     = "1.4.1.343.gf7389c7";
    sources     = [{ filename = "mingw-w64-i686-stxxl-git-1.4.1.343.gf7389c7-2-any.pkg.tar.xz"; sha256 = "a4d5a270846f85d00e9cc432a19679166b65887301d56f2b1a472b5e78864b92"; }];
  };

  "styrene" = fetch {
    pname       = "styrene";
    version     = "0.3.0";
    sources     = [{ filename = "mingw-w64-i686-styrene-0.3.0-3-any.pkg.tar.xz"; sha256 = "16daa8ab93518400c9e617ff3fe5a5bc193a4245e4ab9948b96acc77f6997685"; }];
    buildInputs = [ zip python3 gcc binutils nsis ];
    broken      = true; # broken dependency styrene -> zip
  };

  "suitesparse" = fetch {
    pname       = "suitesparse";
    version     = "5.7.2";
    sources     = [{ filename = "mingw-w64-i686-suitesparse-5.7.2-1-any.pkg.tar.xz"; sha256 = "424c65dd3c0bd006b0926d208c99e887127713a3c2b2c318a017d9a6010d4c56"; }];
    buildInputs = [ openblas metis ];
  };

  "swig" = fetch {
    pname       = "swig";
    version     = "4.0.2";
    sources     = [{ filename = "mingw-w64-i686-swig-4.0.2-1-any.pkg.tar.zst"; sha256 = "bd7a4c130b160f1a890016da7ebe623af97439f478a06d3d5787f6b733c226de"; }];
    buildInputs = [ gcc-libs pcre ];
  };

  "syndication-qt5" = fetch {
    pname       = "syndication-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-syndication-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "cfd511be71b957ffbcf5edf6330f107ba85617f16862c024fa064aa03b34b291"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcodecs-qt5.version "5.75.0"; kcodecs-qt5) ];
  };

  "syntax-highlighting-qt5" = fetch {
    pname       = "syntax-highlighting-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-syntax-highlighting-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "aa3ed9d42a5bd9b24b853e331473034d01ec9adbe8e237465535629548f06cbf"; }];
    buildInputs = [ qt5 ];
  };

  "szip" = fetch {
    pname       = "szip";
    version     = "2.1.1";
    sources     = [{ filename = "mingw-w64-i686-szip-2.1.1-2-any.pkg.tar.xz"; sha256 = "58b5efe1420a2bfd6e92cf94112d29b03ec588f54f4a995a1b26034076f0d369"; }];
    buildInputs = [  ];
  };

  "t1utils" = fetch {
    pname       = "t1utils";
    version     = "1.41";
    sources     = [{ filename = "mingw-w64-i686-t1utils-1.41-1-any.pkg.tar.xz"; sha256 = "64bb1b698d092d73306fc036c12a38d855629a0561a3714c494cedc9e66b1bcc"; }];
  };

  "taglib" = fetch {
    pname       = "taglib";
    version     = "1.11.1";
    sources     = [{ filename = "mingw-w64-i686-taglib-1.11.1-1-any.pkg.tar.xz"; sha256 = "a23f5d55663ab060f5988da38864724204990751f3fb3316fb17045aa9dfe68d"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "tcl" = fetch {
    pname       = "tcl";
    version     = "8.6.10";
    sources     = [{ filename = "mingw-w64-i686-tcl-8.6.10-1-any.pkg.tar.xz"; sha256 = "6a3c86d1220e20e3cc452fac38f1b3887f6e79889844740bad9c71b169409cfb"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "tcl-nsf" = fetch {
    pname       = "tcl-nsf";
    version     = "2.1.0";
    sources     = [{ filename = "mingw-w64-i686-tcl-nsf-2.1.0-1-any.pkg.tar.xz"; sha256 = "5cadaaeebb387576af6cedce2ad55ced1d9adef9909ff9f162c901f772734779"; }];
    buildInputs = [ tcl ];
  };

  "tcllib" = fetch {
    pname       = "tcllib";
    version     = "1.20";
    sources     = [{ filename = "mingw-w64-i686-tcllib-1.20-1-any.pkg.tar.xz"; sha256 = "dcd71e8032394d65f6e037770f9223639973df91d1678de4d67175bb1db5500c"; }];
    buildInputs = [ tcl ];
  };

  "tclvfs-cvs" = fetch {
    pname       = "tclvfs-cvs";
    version     = "20130425";
    sources     = [{ filename = "mingw-w64-i686-tclvfs-cvs-20130425-3-any.pkg.tar.zst"; sha256 = "d558b81abcf86d13bb0ec112d6265c9bfab85ec76ecce80bc22e816c83e633c7"; }];
    buildInputs = [ tcl ];
  };

  "tclx" = fetch {
    pname       = "tclx";
    version     = "8.4.4";
    sources     = [{ filename = "mingw-w64-i686-tclx-8.4.4-1-any.pkg.tar.xz"; sha256 = "99c95980f54fa6d2d0e07c19fd1efb071b537bbd0505ff51e0232ab25678dc33"; }];
    buildInputs = [ tcl ];
  };

  "teensy-loader-cli" = fetch {
    pname       = "teensy-loader-cli";
    version     = "2.1";
    sources     = [{ filename = "mingw-w64-i686-teensy-loader-cli-2.1-1-any.pkg.tar.zst"; sha256 = "14a12be0bbf3657f40d8b5c87e085b73f2521fde03df8ad5a73dfddfdfc09dcf"; }];
    buildInputs = [ libusb-compat-git ];
  };

  "template-glib" = fetch {
    pname       = "template-glib";
    version     = "3.34.0";
    sources     = [{ filename = "mingw-w64-i686-template-glib-3.34.0-1-any.pkg.tar.xz"; sha256 = "a563c756abeef05b4c2bb342acccfaa682d850548c691f2c8c78eb468162f996"; }];
    buildInputs = [ glib2 gobject-introspection ];
  };

  "tepl5" = fetch {
    pname       = "tepl5";
    version     = "5.0.0";
    sources     = [{ filename = "mingw-w64-i686-tepl5-5.0.0-1-any.pkg.tar.zst"; sha256 = "25ab640e9c7428edd9c65369968b7f4524a0fe4acc12a06bc315bca56c0b02e2"; }];
    buildInputs = [ amtk gtksourceview4 icu ];
  };

  "termcap" = fetch {
    pname       = "termcap";
    version     = "1.3.1";
    sources     = [{ filename = "mingw-w64-i686-termcap-1.3.1-6-any.pkg.tar.zst"; sha256 = "6d45d5eeb1b7911cd9a7903af8da26589b1b3986a9adcd1b880c569718900e5e"; }];
    buildInputs = [ gcc-libs ];
  };

  "tesseract-data-afr" = fetch {
    pname       = "tesseract-data-afr";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-afr-4.0.0-1-any.pkg.tar.xz"; sha256 = "dbb7129b0cce770a71d670ce38fc84755739c128010341ca251164a20dc3ebc0"; }];
  };

  "tesseract-data-amh" = fetch {
    pname       = "tesseract-data-amh";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-amh-4.0.0-1-any.pkg.tar.xz"; sha256 = "8a8abd15695048c1db917fd7f7e644b083fe8c36bd2b88b05f5d7f19efaa817c"; }];
  };

  "tesseract-data-ara" = fetch {
    pname       = "tesseract-data-ara";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ara-4.0.0-1-any.pkg.tar.xz"; sha256 = "0af1c20c98fe8eac6c2a89e964f3130a886e28511120a064efe43eb2ab5b8257"; }];
  };

  "tesseract-data-asm" = fetch {
    pname       = "tesseract-data-asm";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-asm-4.0.0-1-any.pkg.tar.xz"; sha256 = "b9843341bab2bf890a0826be48e25217dd7cc4f0dd9c273679f5dccf233a214e"; }];
  };

  "tesseract-data-aze" = fetch {
    pname       = "tesseract-data-aze";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-aze-4.0.0-1-any.pkg.tar.xz"; sha256 = "a2abc502bdd03123343fab8ca68a0375c6805203587cde95d3a40663beee4f13"; }];
  };

  "tesseract-data-aze_cyrl" = fetch {
    pname       = "tesseract-data-aze_cyrl";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-aze_cyrl-4.0.0-1-any.pkg.tar.xz"; sha256 = "7e96b46f014d7cabd9428a8c00caf7d7e40077523ea235155ea6e25bcb4e79e9"; }];
  };

  "tesseract-data-bel" = fetch {
    pname       = "tesseract-data-bel";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-bel-4.0.0-1-any.pkg.tar.xz"; sha256 = "8fc72571ff1e1ba0f64b26e4e2be7f9ce9cf64f423176243096700d6a6c694ac"; }];
  };

  "tesseract-data-ben" = fetch {
    pname       = "tesseract-data-ben";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ben-4.0.0-1-any.pkg.tar.xz"; sha256 = "058e09d5f8104fe7644bc8f34b26191eaae147e78205fc4f2d205645f698e0f3"; }];
  };

  "tesseract-data-bod" = fetch {
    pname       = "tesseract-data-bod";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-bod-4.0.0-1-any.pkg.tar.xz"; sha256 = "bc67d88f4a11b956296b08cc5b0ac9b45ee09e23fd488946cc236b42613c05c7"; }];
  };

  "tesseract-data-bos" = fetch {
    pname       = "tesseract-data-bos";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-bos-4.0.0-1-any.pkg.tar.xz"; sha256 = "a44162b788366d38e59a695e4de123e0ee01b594c4c4f86be7569cb172dc3004"; }];
  };

  "tesseract-data-bul" = fetch {
    pname       = "tesseract-data-bul";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-bul-4.0.0-1-any.pkg.tar.xz"; sha256 = "7c290679313a2a84ff5a0005f01de0a0192648c4f8b04f2775b478cbd195cbf0"; }];
  };

  "tesseract-data-cat" = fetch {
    pname       = "tesseract-data-cat";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-cat-4.0.0-1-any.pkg.tar.xz"; sha256 = "ff6f6986fd15952d95db779d1301f6bf8f6ebc094af4ed66bc5fe78cb63966c0"; }];
  };

  "tesseract-data-ceb" = fetch {
    pname       = "tesseract-data-ceb";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ceb-4.0.0-1-any.pkg.tar.xz"; sha256 = "68daf6a512063e86065c9db866d58cea91a0596a18ac0d4b1054e1017b7654ed"; }];
  };

  "tesseract-data-ces" = fetch {
    pname       = "tesseract-data-ces";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ces-4.0.0-1-any.pkg.tar.xz"; sha256 = "e694bcecb8ffd7cb96092ff57e45deaa634946bb95c14d004fe2c8aaf1d71a65"; }];
  };

  "tesseract-data-chi_sim" = fetch {
    pname       = "tesseract-data-chi_sim";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-chi_sim-4.0.0-1-any.pkg.tar.xz"; sha256 = "ed6dbcfc7022e8c2298ce7d7090107176e3fae3521ffd99ed5b5b5d8a490c8cb"; }];
  };

  "tesseract-data-chi_tra" = fetch {
    pname       = "tesseract-data-chi_tra";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-chi_tra-4.0.0-1-any.pkg.tar.xz"; sha256 = "7b492ef2858f368336f0cb06e555d54501fc6a308f59dcf1166b65dbfa12b6d8"; }];
  };

  "tesseract-data-chr" = fetch {
    pname       = "tesseract-data-chr";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-chr-4.0.0-1-any.pkg.tar.xz"; sha256 = "d2e1aa8208d917bd13f125d29b09b5f6662ee6a1301ab3c59e24b02fbc68357c"; }];
  };

  "tesseract-data-cym" = fetch {
    pname       = "tesseract-data-cym";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-cym-4.0.0-1-any.pkg.tar.xz"; sha256 = "c24429b25cdb2ecd1985b518733ab0fac052f4b38cbb5acce8eaebe01cddc351"; }];
  };

  "tesseract-data-dan" = fetch {
    pname       = "tesseract-data-dan";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-dan-4.0.0-1-any.pkg.tar.xz"; sha256 = "a728260c9ee77bddcd9e6bff13b436e4ddb5eea173767ac473af5a7a246c6108"; }];
  };

  "tesseract-data-deu" = fetch {
    pname       = "tesseract-data-deu";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-deu-4.0.0-1-any.pkg.tar.xz"; sha256 = "461d55ec0e0b0975ffc3988187c086f09025711d3bffac1d56759e810cbd39c8"; }];
  };

  "tesseract-data-dzo" = fetch {
    pname       = "tesseract-data-dzo";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-dzo-4.0.0-1-any.pkg.tar.xz"; sha256 = "265c038094b62234f27d16a557c57965750c56012086c7e6a6098f141634ab54"; }];
  };

  "tesseract-data-ell" = fetch {
    pname       = "tesseract-data-ell";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ell-4.0.0-1-any.pkg.tar.xz"; sha256 = "6234757ae06770b05585bbb99dfed3b6f1df44ef1e7e122fef857da95cb06d0d"; }];
  };

  "tesseract-data-eng" = fetch {
    pname       = "tesseract-data-eng";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-eng-4.0.0-1-any.pkg.tar.xz"; sha256 = "1e7d9af728776ca0d322651d37d463686aa869adb9edbb1d3d3a153a2b46c771"; }];
  };

  "tesseract-data-enm" = fetch {
    pname       = "tesseract-data-enm";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-enm-4.0.0-1-any.pkg.tar.xz"; sha256 = "2fff4dd170b10fd9e536ae1986a0f62325a048a2452deb9a86a99b6768615902"; }];
  };

  "tesseract-data-epo" = fetch {
    pname       = "tesseract-data-epo";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-epo-4.0.0-1-any.pkg.tar.xz"; sha256 = "ef7a39654edba77737d4bbca8b82bf0c05b7b3e935fe23bf8b58cc74989e90ef"; }];
  };

  "tesseract-data-est" = fetch {
    pname       = "tesseract-data-est";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-est-4.0.0-1-any.pkg.tar.xz"; sha256 = "13d0cbd7a40fb21bc199f8ed58cb5109b942de803c9ba1a0885e6d1015de3dfe"; }];
  };

  "tesseract-data-eus" = fetch {
    pname       = "tesseract-data-eus";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-eus-4.0.0-1-any.pkg.tar.xz"; sha256 = "2ec5fe4953cc720a3689b32afa01ab96cf877aabffacc1f98d5c44ffda3f5b74"; }];
  };

  "tesseract-data-fas" = fetch {
    pname       = "tesseract-data-fas";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-fas-4.0.0-1-any.pkg.tar.xz"; sha256 = "68c7607b5550c84f3a532cb9dba30dd9fa283448feb9ceda27ed8a047e7398e8"; }];
  };

  "tesseract-data-fin" = fetch {
    pname       = "tesseract-data-fin";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-fin-4.0.0-1-any.pkg.tar.xz"; sha256 = "83a1b179b74524c5b134c203eec9bff87ed138f3a54b605e86d0edc8d6016a2b"; }];
  };

  "tesseract-data-fra" = fetch {
    pname       = "tesseract-data-fra";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-fra-4.0.0-1-any.pkg.tar.xz"; sha256 = "15dab5e9905e72539c2e522e3095e2d4f113ee9959343949fbc10b76fce943de"; }];
  };

  "tesseract-data-frk" = fetch {
    pname       = "tesseract-data-frk";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-frk-4.0.0-1-any.pkg.tar.xz"; sha256 = "5ccf9466ed303cb44d4ee0ab287442a17b84d70fe388c06062ae11efe93e14c9"; }];
  };

  "tesseract-data-frm" = fetch {
    pname       = "tesseract-data-frm";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-frm-4.0.0-1-any.pkg.tar.xz"; sha256 = "c8939570ae2ee3fe2c11962c984de2f490bab9610ef3289ad8741f6676ff1925"; }];
  };

  "tesseract-data-gle" = fetch {
    pname       = "tesseract-data-gle";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-gle-4.0.0-1-any.pkg.tar.xz"; sha256 = "33dd441ed2602e024044e4724baa27e68121988e5aad9725aeb6c7268bf6b75a"; }];
  };

  "tesseract-data-glg" = fetch {
    pname       = "tesseract-data-glg";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-glg-4.0.0-1-any.pkg.tar.xz"; sha256 = "60db3c5048aefeac427a46cf9349eb8ccfdffa5d9d340ca770896b9ffc6fb6e6"; }];
  };

  "tesseract-data-grc" = fetch {
    pname       = "tesseract-data-grc";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-grc-4.0.0-1-any.pkg.tar.xz"; sha256 = "3caf63c105895494c82d8eae12dbf88b3d9caab8e3c27330d01a82f3cc427e54"; }];
  };

  "tesseract-data-guj" = fetch {
    pname       = "tesseract-data-guj";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-guj-4.0.0-1-any.pkg.tar.xz"; sha256 = "73e4a832a734334b38112ce63135033c1c4710414a862e84eb8825283f95da3c"; }];
  };

  "tesseract-data-hat" = fetch {
    pname       = "tesseract-data-hat";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-hat-4.0.0-1-any.pkg.tar.xz"; sha256 = "92dd48d724a2743cfa1e81594dc70329a3bdcbb29dda360255a874c94e4fdef9"; }];
  };

  "tesseract-data-heb" = fetch {
    pname       = "tesseract-data-heb";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-heb-4.0.0-1-any.pkg.tar.xz"; sha256 = "6c272e63daaf192862c031564a195a99a6cb57638e878f66b6e3749abba11f16"; }];
  };

  "tesseract-data-hin" = fetch {
    pname       = "tesseract-data-hin";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-hin-4.0.0-1-any.pkg.tar.xz"; sha256 = "0da128841f62de9f8642215a2fe0d3322eed7d1819637ead4fd4629203cedda4"; }];
  };

  "tesseract-data-hrv" = fetch {
    pname       = "tesseract-data-hrv";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-hrv-4.0.0-1-any.pkg.tar.xz"; sha256 = "101a5ff7ee035ee21de2833bdb1c939d707dd0dff6e671c8cea3b768213dcaec"; }];
  };

  "tesseract-data-hun" = fetch {
    pname       = "tesseract-data-hun";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-hun-4.0.0-1-any.pkg.tar.xz"; sha256 = "b9b8c5aad2e105ff72509d05746f4c8184821fe0c7f6bf60b8b14115ada22bd5"; }];
  };

  "tesseract-data-iku" = fetch {
    pname       = "tesseract-data-iku";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-iku-4.0.0-1-any.pkg.tar.xz"; sha256 = "f5914b822608d7bcdceb1d3491f709d0780fe3939da7f9bcfc6ab11a2702ec7c"; }];
  };

  "tesseract-data-ind" = fetch {
    pname       = "tesseract-data-ind";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ind-4.0.0-1-any.pkg.tar.xz"; sha256 = "1b4aa2d3570452997a40fed903d3665ee7a90a47ccf52d540c2a00384b5b64dd"; }];
  };

  "tesseract-data-isl" = fetch {
    pname       = "tesseract-data-isl";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-isl-4.0.0-1-any.pkg.tar.xz"; sha256 = "f473ab10a11d9f8285fbc53d4aaa1da13d0ff3b5dc03e1599c51d07c7fb7cb85"; }];
  };

  "tesseract-data-ita" = fetch {
    pname       = "tesseract-data-ita";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ita-4.0.0-1-any.pkg.tar.xz"; sha256 = "434678eb10596eafed9e5f815da80a6e325847d61992c85459dd309ec0a4278b"; }];
  };

  "tesseract-data-ita_old" = fetch {
    pname       = "tesseract-data-ita_old";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ita_old-4.0.0-1-any.pkg.tar.xz"; sha256 = "5c07286986a33c58398debff958a0d859f86eb7b1e426797c208993031636847"; }];
  };

  "tesseract-data-jav" = fetch {
    pname       = "tesseract-data-jav";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-jav-4.0.0-1-any.pkg.tar.xz"; sha256 = "3efff2f6f82a17858b7c38422ec47a291bdeb5e0e5b308f5d0bf2c931319910c"; }];
  };

  "tesseract-data-jpn" = fetch {
    pname       = "tesseract-data-jpn";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-jpn-4.0.0-1-any.pkg.tar.xz"; sha256 = "841bc6c0d68cd98159ed6d4c9e1649827d996d577389260c502549858f28ca53"; }];
  };

  "tesseract-data-kan" = fetch {
    pname       = "tesseract-data-kan";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-kan-4.0.0-1-any.pkg.tar.xz"; sha256 = "d813d2153d0390895f66cc9d4de31a4e6a8f82f6e555808285071479b5de785e"; }];
  };

  "tesseract-data-kat" = fetch {
    pname       = "tesseract-data-kat";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-kat-4.0.0-1-any.pkg.tar.xz"; sha256 = "e5ac31c69047cbf88cc1a71598a2046387745623deceb5d2e88f8e87c925c541"; }];
  };

  "tesseract-data-kat_old" = fetch {
    pname       = "tesseract-data-kat_old";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-kat_old-4.0.0-1-any.pkg.tar.xz"; sha256 = "141ab7fb125d6730f45c5b60875c2b5c6bcd82fe702b2b85679216a324edea7d"; }];
  };

  "tesseract-data-kaz" = fetch {
    pname       = "tesseract-data-kaz";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-kaz-4.0.0-1-any.pkg.tar.xz"; sha256 = "aa1dc65871279de4c31867266da610675f4d619236421c567be7d3f5ebfe35a8"; }];
  };

  "tesseract-data-khm" = fetch {
    pname       = "tesseract-data-khm";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-khm-4.0.0-1-any.pkg.tar.xz"; sha256 = "083295ff24219ac85072a8c09711f20dfc911d6a965ca9da28a9353c465cbd4f"; }];
  };

  "tesseract-data-kir" = fetch {
    pname       = "tesseract-data-kir";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-kir-4.0.0-1-any.pkg.tar.xz"; sha256 = "cdffa9d630e7b1c36a902d6d2ad3b43e272fcdcd085cfbcb5c3569b706dd5b03"; }];
  };

  "tesseract-data-kor" = fetch {
    pname       = "tesseract-data-kor";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-kor-4.0.0-1-any.pkg.tar.xz"; sha256 = "2f4cf3791036a006910b335010865df66a30b4fdabd1e1fd66a01aaa84d2671f"; }];
  };

  "tesseract-data-lao" = fetch {
    pname       = "tesseract-data-lao";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-lao-4.0.0-1-any.pkg.tar.xz"; sha256 = "f4eecc3f0e1c9f614e6bdb958a7e39f259be27439e958aab6b8df241ba6dc4a7"; }];
  };

  "tesseract-data-lat" = fetch {
    pname       = "tesseract-data-lat";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-lat-4.0.0-1-any.pkg.tar.xz"; sha256 = "b6020b4d58ecd4e826a443b7e656ded8cd00c71e1775537c17aeafeeeb70c8b1"; }];
  };

  "tesseract-data-lav" = fetch {
    pname       = "tesseract-data-lav";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-lav-4.0.0-1-any.pkg.tar.xz"; sha256 = "57e1cd8abb1979f9cd0ee5053056fc781bfebdae20e31616c507fae7236a73d0"; }];
  };

  "tesseract-data-lit" = fetch {
    pname       = "tesseract-data-lit";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-lit-4.0.0-1-any.pkg.tar.xz"; sha256 = "067c2bdbaf1c5501ab9a8bae7b93fb9f8ab2406d3114a3d0aeea0baa9f0c2637"; }];
  };

  "tesseract-data-mal" = fetch {
    pname       = "tesseract-data-mal";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-mal-4.0.0-1-any.pkg.tar.xz"; sha256 = "e295bea2903eb983dcf5fedd91662662aee3da00ff429b5007e832feaa9ecd5d"; }];
  };

  "tesseract-data-mar" = fetch {
    pname       = "tesseract-data-mar";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-mar-4.0.0-1-any.pkg.tar.xz"; sha256 = "8c8341a639a3fb9bffe3cba2958b3a8bd866a56bdd8271043352f8c2b3198cc9"; }];
  };

  "tesseract-data-mkd" = fetch {
    pname       = "tesseract-data-mkd";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-mkd-4.0.0-1-any.pkg.tar.xz"; sha256 = "be6053a3ae68a7c0d248a930bfdcbcc4bb45ce0586c03e241b91e1b88465e6da"; }];
  };

  "tesseract-data-mlt" = fetch {
    pname       = "tesseract-data-mlt";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-mlt-4.0.0-1-any.pkg.tar.xz"; sha256 = "ff9541625e8e45a7047536d4984085bcbb7938e5902e47919260a04315ba54ec"; }];
  };

  "tesseract-data-msa" = fetch {
    pname       = "tesseract-data-msa";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-msa-4.0.0-1-any.pkg.tar.xz"; sha256 = "f7d273614dd057121f919ea8b056d378aaf9f0945b23f8a3f44a2c1513018665"; }];
  };

  "tesseract-data-mya" = fetch {
    pname       = "tesseract-data-mya";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-mya-4.0.0-1-any.pkg.tar.xz"; sha256 = "d1d7a6a621eb24f4022e3c81804bd86cef266ac724d60f299f47071681207605"; }];
  };

  "tesseract-data-nep" = fetch {
    pname       = "tesseract-data-nep";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-nep-4.0.0-1-any.pkg.tar.xz"; sha256 = "b579a2210e2618abdd8c3c9201fd7b6f32a9be14c76845ecf4f162800021a44d"; }];
  };

  "tesseract-data-nld" = fetch {
    pname       = "tesseract-data-nld";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-nld-4.0.0-1-any.pkg.tar.xz"; sha256 = "78cd737ee98c8e96dab8891a9bcb2dac9a1b7f12677c8fb55e134e4113133906"; }];
  };

  "tesseract-data-nor" = fetch {
    pname       = "tesseract-data-nor";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-nor-4.0.0-1-any.pkg.tar.xz"; sha256 = "525dc0a5b53aaa8170ea35a6cf2d63f4363b9ef2958a044b8e6d003728c3e5b1"; }];
  };

  "tesseract-data-ori" = fetch {
    pname       = "tesseract-data-ori";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ori-4.0.0-1-any.pkg.tar.xz"; sha256 = "4128cdbbd5aac8973097f5162e8abe2bcce2f6bbd191ecfce9d763d39be28504"; }];
  };

  "tesseract-data-pan" = fetch {
    pname       = "tesseract-data-pan";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-pan-4.0.0-1-any.pkg.tar.xz"; sha256 = "222b0d3fab27e6e7a51a3a0ddc5df24d044c330f18d94707223afe3f3be9e237"; }];
  };

  "tesseract-data-pol" = fetch {
    pname       = "tesseract-data-pol";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-pol-4.0.0-1-any.pkg.tar.xz"; sha256 = "601834120f2d927ed115ea413fe0c861d614a9cb17a0c2f074bbb705c840401d"; }];
  };

  "tesseract-data-por" = fetch {
    pname       = "tesseract-data-por";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-por-4.0.0-1-any.pkg.tar.xz"; sha256 = "796e5de9c06fa5d8087289a91fbf4f1429289f7363fc617e9cd7257c2d8f660f"; }];
  };

  "tesseract-data-pus" = fetch {
    pname       = "tesseract-data-pus";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-pus-4.0.0-1-any.pkg.tar.xz"; sha256 = "35a6d04e9448b0134b168726e7fd2ce8a7eb7d2994d6feb60eb036955aa8ed02"; }];
  };

  "tesseract-data-ron" = fetch {
    pname       = "tesseract-data-ron";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ron-4.0.0-1-any.pkg.tar.xz"; sha256 = "c411710e0dd4dfefb749fd108ec0761474e7c3258506bf5b5ba44422896e48ef"; }];
  };

  "tesseract-data-rus" = fetch {
    pname       = "tesseract-data-rus";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-rus-4.0.0-1-any.pkg.tar.xz"; sha256 = "a91186977c9b099e103b2bb3624dc570b3daeb4d12ca892fa931ba299808a333"; }];
  };

  "tesseract-data-san" = fetch {
    pname       = "tesseract-data-san";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-san-4.0.0-1-any.pkg.tar.xz"; sha256 = "12e3eee85f166dcf82b528eee49486f3c1617ca2f6b1f9db67b916e97ab24c13"; }];
  };

  "tesseract-data-sin" = fetch {
    pname       = "tesseract-data-sin";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-sin-4.0.0-1-any.pkg.tar.xz"; sha256 = "f4366c80f93438afac7166691840977fdf1dc6acb98f60d41b038cb6e57d37ad"; }];
  };

  "tesseract-data-slk" = fetch {
    pname       = "tesseract-data-slk";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-slk-4.0.0-1-any.pkg.tar.xz"; sha256 = "0a0e166eb29d1db6fd61ac7e48cb36d32700920150033be1c5c456d21acf8a6a"; }];
  };

  "tesseract-data-slv" = fetch {
    pname       = "tesseract-data-slv";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-slv-4.0.0-1-any.pkg.tar.xz"; sha256 = "6b2e2797898982a2f38d003ba04be84fc0f34e7adc5595eaab4bda6e0bf71af6"; }];
  };

  "tesseract-data-spa" = fetch {
    pname       = "tesseract-data-spa";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-spa-4.0.0-1-any.pkg.tar.xz"; sha256 = "3b8023be3aa933f10f65c72de2b735b320d7f5776e63035857b14ff18accc50d"; }];
  };

  "tesseract-data-spa_old" = fetch {
    pname       = "tesseract-data-spa_old";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-spa_old-4.0.0-1-any.pkg.tar.xz"; sha256 = "9f22e091e4dd86609851ffae3d8831fe87ace9cf25d635816c18a60dad3bcd76"; }];
  };

  "tesseract-data-sqi" = fetch {
    pname       = "tesseract-data-sqi";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-sqi-4.0.0-1-any.pkg.tar.xz"; sha256 = "3534468433e7bda23e4f6f1a0ba56d8304a7cb3d77fb5cbce21d09b3fce9d3c5"; }];
  };

  "tesseract-data-srp" = fetch {
    pname       = "tesseract-data-srp";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-srp-4.0.0-1-any.pkg.tar.xz"; sha256 = "7b8fa67bb7de20373ae344a41f24fc85358ec500efbfe93330e26ddb42213aac"; }];
  };

  "tesseract-data-srp_latn" = fetch {
    pname       = "tesseract-data-srp_latn";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-srp_latn-4.0.0-1-any.pkg.tar.xz"; sha256 = "cec84e2273f2320399b377786f470c7cb7c770d5d75b62990a408d56e13b5c5e"; }];
  };

  "tesseract-data-swa" = fetch {
    pname       = "tesseract-data-swa";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-swa-4.0.0-1-any.pkg.tar.xz"; sha256 = "bca9d9336d09d0f0e086c2c994608a987f209d6d420ecc30f3d32c31f2bff1db"; }];
  };

  "tesseract-data-swe" = fetch {
    pname       = "tesseract-data-swe";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-swe-4.0.0-1-any.pkg.tar.xz"; sha256 = "10e62b2e423769019b304cffc7f10d1d2406ff4cccbd509af38bd09f36d395fe"; }];
  };

  "tesseract-data-syr" = fetch {
    pname       = "tesseract-data-syr";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-syr-4.0.0-1-any.pkg.tar.xz"; sha256 = "39ff4f5671e00804465dccb06506f00b6d079617bd7ac4be8566311ef29dd441"; }];
  };

  "tesseract-data-tam" = fetch {
    pname       = "tesseract-data-tam";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-tam-4.0.0-1-any.pkg.tar.xz"; sha256 = "2218ec2dda184fd92c4c617903000a4d080e85c0807bb5dd6fd83d9cb837dddc"; }];
  };

  "tesseract-data-tel" = fetch {
    pname       = "tesseract-data-tel";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-tel-4.0.0-1-any.pkg.tar.xz"; sha256 = "5822d7cb3459329a4cf8d602dff2343ade7d2203b9ce6cdef26ac9c95707d552"; }];
  };

  "tesseract-data-tgk" = fetch {
    pname       = "tesseract-data-tgk";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-tgk-4.0.0-1-any.pkg.tar.xz"; sha256 = "cd38e308e6572aa53c8df90cfda9503c400b39a899257025f652793f3a4e8a45"; }];
  };

  "tesseract-data-tha" = fetch {
    pname       = "tesseract-data-tha";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-tha-4.0.0-1-any.pkg.tar.xz"; sha256 = "b0877d326d94987fbb3b9cf0f21fbb8c5e76e21f130bcc188fd7cf6b927d6e1a"; }];
  };

  "tesseract-data-tir" = fetch {
    pname       = "tesseract-data-tir";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-tir-4.0.0-1-any.pkg.tar.xz"; sha256 = "ce7c9034ebb87d183eef15238eae1e847d60e6ab244aebd9f70778c3ddc82859"; }];
  };

  "tesseract-data-tur" = fetch {
    pname       = "tesseract-data-tur";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-tur-4.0.0-1-any.pkg.tar.xz"; sha256 = "6900130757f9dd88ad1f8da6110e50405471240def3244606df0b60bbc8b2b09"; }];
  };

  "tesseract-data-uig" = fetch {
    pname       = "tesseract-data-uig";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-uig-4.0.0-1-any.pkg.tar.xz"; sha256 = "5c4931218fb2acfe18a5896d264ec2f592a212935efa6678f6668273b23381e2"; }];
  };

  "tesseract-data-ukr" = fetch {
    pname       = "tesseract-data-ukr";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-ukr-4.0.0-1-any.pkg.tar.xz"; sha256 = "4fec3733fec88da1009e5d9e8b42f3d9d2c513ede0bed0a4da48df7c487c8846"; }];
  };

  "tesseract-data-urd" = fetch {
    pname       = "tesseract-data-urd";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-urd-4.0.0-1-any.pkg.tar.xz"; sha256 = "57af610f98106ae0fab6a9fe675824790240fcd3108777fe3581b8cf2edc86b4"; }];
  };

  "tesseract-data-uzb" = fetch {
    pname       = "tesseract-data-uzb";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-uzb-4.0.0-1-any.pkg.tar.xz"; sha256 = "ad9d2dece6381ea3f79c3d0b33c9b206d674a6bb9f143d6794c7c14a52857683"; }];
  };

  "tesseract-data-uzb_cyrl" = fetch {
    pname       = "tesseract-data-uzb_cyrl";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-uzb_cyrl-4.0.0-1-any.pkg.tar.xz"; sha256 = "0f17d36411edffc83986d743721492d836088bbf0367f9ed7fca8e6ad6208761"; }];
  };

  "tesseract-data-vie" = fetch {
    pname       = "tesseract-data-vie";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-vie-4.0.0-1-any.pkg.tar.xz"; sha256 = "7b3c1a7188a86d497848e453089d032be474d358af86d9012ed22cd008c40fac"; }];
  };

  "tesseract-data-yid" = fetch {
    pname       = "tesseract-data-yid";
    version     = "4.0.0";
    sources     = [{ filename = "mingw-w64-i686-tesseract-data-yid-4.0.0-1-any.pkg.tar.xz"; sha256 = "c50ca093706869a413d889d519acf293f1f579258989c35a32141fe0f246e885"; }];
  };

  "tesseract-ocr" = fetch {
    pname       = "tesseract-ocr";
    version     = "4.1.1";
    sources     = [{ filename = "mingw-w64-i686-tesseract-ocr-4.1.1-4-any.pkg.tar.zst"; sha256 = "7073b38a546c2f746c684e5069eb0e8635d7618f6c4c792045c96864fa24ca06"; }];
    buildInputs = [ cairo curl gcc-libs icu leptonica libarchive pango zlib ];
  };

  "threadweaver-qt5" = fetch {
    pname       = "threadweaver-qt5";
    version     = "5.75.0";
    sources     = [{ filename = "mingw-w64-i686-threadweaver-qt5-5.75.0-1-any.pkg.tar.zst"; sha256 = "0b56b0f002d6518d9a85c0a16326b2d1313bdf7ef203fea3dee16e44bf4e1a3e"; }];
    buildInputs = [ qt5 ];
  };

  "thrift" = fetch {
    pname       = "thrift";
    version     = "0.13.0";
    sources     = [{ filename = "mingw-w64-i686-thrift-0.13.0-2-any.pkg.tar.zst"; sha256 = "2a70d6ff639a6ae55815d34d611d0ba90f8d27042c048976e31864486229e9dd"; }];
    buildInputs = [ gcc-libs boost openssl zlib ];
  };

  "tidy" = fetch {
    pname       = "tidy";
    version     = "5.7.16";
    sources     = [{ filename = "mingw-w64-i686-tidy-5.7.16-1-any.pkg.tar.xz"; sha256 = "2cc9ca62fc5457890dcdcb3e2aa768f19d665e51a9851e1d59d68df7af5f9267"; }];
    buildInputs = [ gcc-libs ];
  };

  "tiny-dnn" = fetch {
    pname       = "tiny-dnn";
    version     = "1.0.0a3";
    sources     = [{ filename = "mingw-w64-i686-tiny-dnn-1.0.0a3-2-any.pkg.tar.xz"; sha256 = "6e88077371f7febc7643d00ace3f8c2c7843bf9f847a9bacf084e644ad88e29d"; }];
    buildInputs = [ intel-tbb protobuf ];
  };

  "tinyformat" = fetch {
    pname       = "tinyformat";
    version     = "2.1.0";
    sources     = [{ filename = "mingw-w64-i686-tinyformat-2.1.0-1-any.pkg.tar.xz"; sha256 = "8ca4f665608fb55152f1377806ae445e43ff09eec3f29e2956896a2e6478b888"; }];
  };

  "tinyxml" = fetch {
    pname       = "tinyxml";
    version     = "2.6.2";
    sources     = [{ filename = "mingw-w64-i686-tinyxml-2.6.2-4-any.pkg.tar.xz"; sha256 = "14f67ae4e9790dcc55bd0fca5e5605d16a246ad8940659cea5fd3ef13d71d5ac"; }];
    buildInputs = [ gcc-libs ];
  };

  "tinyxml2" = fetch {
    pname       = "tinyxml2";
    version     = "7.1.0";
    sources     = [{ filename = "mingw-w64-i686-tinyxml2-7.1.0-1-any.pkg.tar.xz"; sha256 = "417f27158a59a492365bb90a2e2059fd598f110fa3be951fd13d760b5b1ff992"; }];
    buildInputs = [ gcc-libs ];
  };

  "tk" = fetch {
    pname       = "tk";
    version     = "8.6.10";
    sources     = [{ filename = "mingw-w64-i686-tk-8.6.10-2-any.pkg.tar.zst"; sha256 = "bca3ceb295c9daa715637162ecd29e71410279192db77fa614ff6d9e6deada76"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast tcl.version "8.6.10"; tcl) ];
  };

  "tkimg" = fetch {
    pname       = "tkimg";
    version     = "1.4.11";
    sources     = [{ filename = "mingw-w64-i686-tkimg-1.4.11-1-any.pkg.tar.zst"; sha256 = "33cc89f4f5a27392ecbd4549e0027997625c31d8a9aa59f9b64a54045c812132"; }];
    buildInputs = [ libjpeg libpng libtiff tk zlib ];
  };

  "tklib-git" = fetch {
    pname       = "tklib-git";
    version     = "r1737.65490b01";
    sources     = [{ filename = "mingw-w64-i686-tklib-git-r1737.65490b01-1-any.pkg.tar.xz"; sha256 = "a28058709c3fac4e395c68591a1b18beea0021bccf764b21c7759df567241c9c"; }];
    buildInputs = [ tk tcllib ];
  };

  "tktable" = fetch {
    pname       = "tktable";
    version     = "2.10";
    sources     = [{ filename = "mingw-w64-i686-tktable-2.10-4-any.pkg.tar.xz"; sha256 = "79ea5a3c7aad0573fec1d3eaeddec2de26804877f10a13ec24080d97d8235689"; }];
    buildInputs = [ tk ];
  };

  "tl-expected" = fetch {
    pname       = "tl-expected";
    version     = "1.0.0";
    sources     = [{ filename = "mingw-w64-i686-tl-expected-1.0.0-2-any.pkg.tar.zst"; sha256 = "c86497a3ab6be893b57006c3600b37d10919edd1669196ad2d53e3e430ad28be"; }];
    buildInputs = [  ];
  };

  "tolua" = fetch {
    pname       = "tolua";
    version     = "5.2.4";
    sources     = [{ filename = "mingw-w64-i686-tolua-5.2.4-3-any.pkg.tar.xz"; sha256 = "21d88b751613ff353acbbd68bcdae258aa672ced0504487c4046a8131f874b28"; }];
    buildInputs = [ lua ];
  };

  "tools-git" = fetch {
    pname       = "tools-git";
    version     = "9.0.0.6029.ecb4ff54";
    sources     = [{ filename = "mingw-w64-i686-tools-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "54678cfb8393056925580bfbcc4c20424f4d798e56c482b871d6fb10d3a53667"; }];
    buildInputs = [ gcc-libs ];
  };

  "tor" = fetch {
    pname       = "tor";
    version     = "0.4.2.7";
    sources     = [{ filename = "mingw-w64-i686-tor-0.4.2.7-1-any.pkg.tar.xz"; sha256 = "2dc3760bffde167f01895e1ba6d969ed6b6fcb5d2c241aec02b5f2fcf186ab31"; }];
    buildInputs = [ libevent openssl xz zlib zstd ];
  };

  "totem-pl-parser" = fetch {
    pname       = "totem-pl-parser";
    version     = "3.26.3";
    sources     = [{ filename = "mingw-w64-i686-totem-pl-parser-3.26.3-1-any.pkg.tar.xz"; sha256 = "2c2b5b04648c2d8b926460ecb19064b5765b16466ce96622bc058730e64b8ba1"; }];
    buildInputs = [ glib2 gmime libsoup libarchive libgcrypt ];
  };

  "transmission" = fetch {
    pname       = "transmission";
    version     = "2.94";
    sources     = [{ filename = "mingw-w64-i686-transmission-2.94-2-any.pkg.tar.xz"; sha256 = "c0504657594244a4266cde46b24406afe9d42c635266a2d67eee1888f153fa3f"; }];
    buildInputs = [ openssl libevent gtk3 curl zlib miniupnpc ];
  };

  "trompeloeil" = fetch {
    pname       = "trompeloeil";
    version     = "37";
    sources     = [{ filename = "mingw-w64-i686-trompeloeil-37-1-any.pkg.tar.xz"; sha256 = "0c3273bb2170a677527da383f1cb9dd427a34de757ea6693d489f5ecd56c6ca3"; }];
  };

  "tslib" = fetch {
    pname       = "tslib";
    version     = "1.17";
    sources     = [{ filename = "mingw-w64-i686-tslib-1.17-1-any.pkg.tar.zst"; sha256 = "4604d6d5a06492279518a8df408398830f4fad9f0b6a009e0a97458c3d232b4a"; }];
  };

  "ttf-dejavu" = fetch {
    pname       = "ttf-dejavu";
    version     = "2.37";
    sources     = [{ filename = "mingw-w64-i686-ttf-dejavu-2.37-2-any.pkg.tar.xz"; sha256 = "b8181b0dd4424bc47ec5ceb91486b91eaa5ee124ebdc52a05361ec04a04417c1"; }];
    buildInputs = [ fontconfig ];
  };

  "ttfautohint" = fetch {
    pname       = "ttfautohint";
    version     = "1.8.3";
    sources     = [{ filename = "mingw-w64-i686-ttfautohint-1.8.3-2-any.pkg.tar.xz"; sha256 = "d6561feacc7c5b2da8f7017140af0f813aba8dbdc523ea69750100dd49611f69"; }];
    buildInputs = [ freetype harfbuzz qt5 ];
  };

  "tulip" = fetch {
    pname       = "tulip";
    version     = "5.2.1";
    sources     = [{ filename = "mingw-w64-i686-tulip-5.2.1-1-any.pkg.tar.xz"; sha256 = "f17f9433c719d7556acfba6ba0d70959197588f4985712bdc453e98c5e5d658c"; }];
    buildInputs = [ freetype glew libpng libjpeg python3 qhull-git qt5 qtwebkit quazip yajl ];
  };

  "twolame" = fetch {
    pname       = "twolame";
    version     = "0.4.0";
    sources     = [{ filename = "mingw-w64-i686-twolame-0.4.0-2-any.pkg.tar.xz"; sha256 = "6e3a1353cb3a0f93d57875d5561eb09e122186ce828b59c093e8300fb1ee8f07"; }];
    buildInputs = [ libsndfile ];
  };

  "uasm" = fetch {
    pname       = "uasm";
    version     = "v2.50";
    sources     = [{ filename = "mingw-w64-i686-uasm-v2.50-1-any.pkg.tar.xz"; sha256 = "bf7dff31a5068ebb1dc717d1eb7c8c5f91a81c82834c7fe0687fcd9157949b40"; }];
    buildInputs = [ gcc ];
  };

  "uchardet" = fetch {
    pname       = "uchardet";
    version     = "0.0.7";
    sources     = [{ filename = "mingw-w64-i686-uchardet-0.0.7-1-any.pkg.tar.xz"; sha256 = "963437e62c9cb87f90f6c4aa59e8e4c0b017d5275cbe2e718bf21f0fd7a2acb9"; }];
    buildInputs = [ gcc-libs ];
  };

  "ucl" = fetch {
    pname       = "ucl";
    version     = "1.03";
    sources     = [{ filename = "mingw-w64-i686-ucl-1.03-1-any.pkg.tar.xz"; sha256 = "d584dbadcc761eb53712d439d1dde59d0e9a1192bc7f4b3f6486022996e6be6e"; }];
  };

  "udis86" = fetch {
    pname       = "udis86";
    version     = "1.7.3rc1";
    sources     = [{ filename = "mingw-w64-i686-udis86-1.7.3rc1-1-any.pkg.tar.xz"; sha256 = "d07ae5c7c3f66131ab09e78df741c7f16b24778b70faae7de6528a39147b5fc6"; }];
    buildInputs = [ python ];
  };

  "udunits" = fetch {
    pname       = "udunits";
    version     = "2.2.27.6";
    sources     = [{ filename = "mingw-w64-i686-udunits-2.2.27.6-1-any.pkg.tar.zst"; sha256 = "7ccc9352e0bdfedf7d668918540e3b7d103c65af8a2b50d451a687baf83d4a71"; }];
    buildInputs = [ expat ];
  };

  "uhttpmock" = fetch {
    pname       = "uhttpmock";
    version     = "0.5.3";
    sources     = [{ filename = "mingw-w64-i686-uhttpmock-0.5.3-1-any.pkg.tar.zst"; sha256 = "242aa006d61d367ad3bb88aa5e644209f47cd00f088138b3d10e09173f18206c"; }];
    buildInputs = [ glib2 libsoup ];
  };

  "unbound" = fetch {
    pname       = "unbound";
    version     = "1.10.0";
    sources     = [{ filename = "mingw-w64-i686-unbound-1.10.0-1-any.pkg.tar.xz"; sha256 = "e7990de29421b610255f5c82a1c95703596552a2b5db29a87f4abef51c2917f4"; }];
    buildInputs = [ openssl expat ldns ];
  };

  "uncrustify" = fetch {
    pname       = "uncrustify";
    version     = "0.71.0";
    sources     = [{ filename = "mingw-w64-i686-uncrustify-0.71.0-1-any.pkg.tar.zst"; sha256 = "0dd65c01e6ee8ed75361a8812e68094e6b452129bc8c83d9e9b65f66cde7d400"; }];
    buildInputs = [ gcc-libs ];
  };

  "unibilium" = fetch {
    pname       = "unibilium";
    version     = "2.1.0";
    sources     = [{ filename = "mingw-w64-i686-unibilium-2.1.0-1-any.pkg.tar.xz"; sha256 = "105f7ed9983f9b9a22fa7b0292456b08857f5a90096ddfd7e27356470f17f6d5"; }];
  };

  "unicode-character-database" = fetch {
    pname       = "unicode-character-database";
    version     = "13.0.0";
    sources     = [{ filename = "mingw-w64-i686-unicode-character-database-13.0.0-1-any.pkg.tar.zst"; sha256 = "31fa266402b952c79f5670e72c3122e9130bcff355506e00b37a5eb1edb28481"; }];
  };

  "unicorn" = fetch {
    pname       = "unicorn";
    version     = "1.0.2rc1";
    sources     = [{ filename = "mingw-w64-i686-unicorn-1.0.2rc1-1-any.pkg.tar.xz"; sha256 = "aa0b5ff0c96bcfd4cc809d89c73a7bdb7412894891926da989e18047bca7b957"; }];
    buildInputs = [ gcc-libs ];
  };

  "universal-ctags-git" = fetch {
    pname       = "universal-ctags-git";
    version     = "r7253.7492b90e";
    sources     = [{ filename = "mingw-w64-i686-universal-ctags-git-r7253.7492b90e-1-any.pkg.tar.xz"; sha256 = "74b001ed93ba127f8b50e38c7f85bb16baab421e2eea2b8904f0cb49497b7f09"; }];
    buildInputs = [ gcc-libs jansson libiconv libxml2 libyaml ];
  };

  "unixodbc" = fetch {
    pname       = "unixodbc";
    version     = "2.3.7";
    sources     = [{ filename = "mingw-w64-i686-unixodbc-2.3.7-2-any.pkg.tar.xz"; sha256 = "2b565afefb71539a6802afb67898b6854a98b5fa61baba4813fb6e551321fb74"; }];
    buildInputs = [ gcc-libs readline libtool ];
  };

  "uriparser" = fetch {
    pname       = "uriparser";
    version     = "0.9.4";
    sources     = [{ filename = "mingw-w64-i686-uriparser-0.9.4-1-any.pkg.tar.zst"; sha256 = "fde34367d3966ed0ca48f17a07882be4725dfdbc648973a1e50fc57f6aec4fc3"; }];
    buildInputs = [  ];
  };

  "usbredir" = fetch {
    pname       = "usbredir";
    version     = "0.8.0";
    sources     = [{ filename = "mingw-w64-i686-usbredir-0.8.0-1-any.pkg.tar.xz"; sha256 = "66ac7d2b7fc39c6cd9f8e5506839bf320398fcaa40dd70ebce4b5cac99af962f"; }];
    buildInputs = [ libusb ];
  };

  "usbview-git" = fetch {
    pname       = "usbview-git";
    version     = "42.c4ba9c6";
    sources     = [{ filename = "mingw-w64-i686-usbview-git-42.c4ba9c6-1-any.pkg.tar.xz"; sha256 = "160ca679d083ad407f45d672b94a26fd8ffcdf37d30a3d288310f79888d3b79b"; }];
  };

  "usql" = fetch {
    pname       = "usql";
    version     = "0.8.1";
    sources     = [{ filename = "mingw-w64-i686-usql-0.8.1-1-any.pkg.tar.xz"; sha256 = "7ae7a0623d92cdbd1e53984aaf50f9d46e63982c94550de4fc10ae3b7dd85d85"; }];
    buildInputs = [ antlr3 ];
  };

  "usrsctp" = fetch {
    pname       = "usrsctp";
    version     = "0.9.3.0";
    sources     = [{ filename = "mingw-w64-i686-usrsctp-0.9.3.0-1-any.pkg.tar.xz"; sha256 = "50c5634cacc28197f6ff48005921ca4c11facb64559d0c74528796426d5b5247"; }];
  };

  "v8" = fetch {
    pname       = "v8";
    version     = "8.5.210.20";
    sources     = [{ filename = "mingw-w64-i686-v8-8.5.210.20-3-any.pkg.tar.zst"; sha256 = "13d9e393a681c7efa507853ed38c0f241209b992acef9b2f71449ec19828cd01"; }];
    buildInputs = [ zlib icu ];
  };

  "vala" = fetch {
    pname       = "vala";
    version     = "0.50.1";
    sources     = [{ filename = "mingw-w64-i686-vala-0.50.1-1-any.pkg.tar.zst"; sha256 = "cf9c492e83bc17eb7cdc929d74c2b89d76cd8585b0ade4917cb544119a93abdc"; }];
    buildInputs = [ glib2 graphviz ];
  };

  "vamp-plugin-sdk" = fetch {
    pname       = "vamp-plugin-sdk";
    version     = "2.10.0";
    sources     = [{ filename = "mingw-w64-i686-vamp-plugin-sdk-2.10.0-1-any.pkg.tar.zst"; sha256 = "6b812624836a025771b5f142cf0efe1f1a7d860e18e432106b93914cb0a924a7"; }];
    buildInputs = [ gcc-libs libsndfile ];
  };

  "vapoursynth" = fetch {
    pname       = "vapoursynth";
    version     = "49";
    sources     = [{ filename = "mingw-w64-i686-vapoursynth-49-1-any.pkg.tar.xz"; sha256 = "83cd5db80287912292ce170271a1d5221edb58be8cfc6b5bc8cfcd0a3fa935c1"; }];
    buildInputs = [ gcc-libs cython ffmpeg imagemagick libass libxml2 python tesseract-ocr zimg ];
  };

  "vcdimager" = fetch {
    pname       = "vcdimager";
    version     = "2.0.1";
    sources     = [{ filename = "mingw-w64-i686-vcdimager-2.0.1-2-any.pkg.tar.zst"; sha256 = "e6c689d20c1d20f68cbd86f5f0a79eb0d56708aeb3c0309e9bcd849993c4e1d7"; }];
    buildInputs = [ libcdio libxml2 popt ];
  };

  "vera++" = fetch {
    pname       = "vera++";
    version     = "1.3.0";
    sources     = [{ filename = "mingw-w64-i686-vera++-1.3.0-2-any.pkg.tar.xz"; sha256 = "23c2ffe492d06bd8d101a8b352c199d6364a7ac453f7d51faa9f018b559de9a5"; }];
    buildInputs = [ tcl boost python2 ];
  };

  "verilator" = fetch {
    pname       = "verilator";
    version     = "4.032";
    sources     = [{ filename = "mingw-w64-i686-verilator-4.032-1-any.pkg.tar.xz"; sha256 = "78151759eac1f34c4a4c9e29355e5586747c0da83e24019d968d1f876affd8c3"; }];
    buildInputs = [ gcc-libs ];
  };

  "vid.stab" = fetch {
    pname       = "vid.stab";
    version     = "1.1";
    sources     = [{ filename = "mingw-w64-i686-vid.stab-1.1-1-any.pkg.tar.xz"; sha256 = "d81e34cb8bd3cc391e43cf9daed05660dff316827850f30d7f3b9e08850d480b"; }];
  };

  "vigra" = fetch {
    pname       = "vigra";
    version     = "1.11.1";
    sources     = [{ filename = "mingw-w64-i686-vigra-1.11.1-4-any.pkg.tar.zst"; sha256 = "6794f6437d51658b9141e1eee8dfd1c7fc763613bca7314c563fe7d08b1ad3d7"; }];
    buildInputs = [ gcc-libs boost fftw hdf5 libjpeg-turbo libpng libtiff openexr python-numpy zlib ];
  };

  "virt-viewer" = fetch {
    pname       = "virt-viewer";
    version     = "8.0";
    sources     = [{ filename = "mingw-w64-i686-virt-viewer-8.0-1-any.pkg.tar.xz"; sha256 = "eface8bebe9762f1e0958d1da57e3e63ecad90e8afb142008adcd929206e92f0"; }];
    buildInputs = [ spice-gtk gtk-vnc libvirt libxml2 opus ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "vlc" = fetch {
    pname       = "vlc";
    version     = "3.0.10";
    sources     = [{ filename = "mingw-w64-i686-vlc-3.0.10-1-any.pkg.tar.zst"; sha256 = "5483b52b01b1a60553f97f67be614e9554de7ab402276105e811bdc0c4b16866"; }];
    buildInputs = [ a52dec aom aribb24 chromaprint dav1d faad2 freetype ffmpeg flac fluidsynth fontconfig fribidi gnutls gsm harfbuzz libarchive libass libbluray libcaca libcddb libcdio libdca libdsm libdvdcss libdvdnav libdvbpsi libgcrypt libgme libgoom2 libidn libmad libmatroska libmfx libmicrodns libmodplug libmpcdec libmpeg2-git libmysofa libogg libnfs libpng libnotify libplacebo libproxy librsvg libsamplerate libsecret libshout libsoxr libssh2 libtheora libvncserver libvorbis libvpx libxml2 lua51 minizip-git opus portaudio protobuf pupnp schroedinger speex srt taglib twolame vcdimager x264-git x265 xpm-nox qt5 SDL_image zlib ];
  };

  "vlfeat" = fetch {
    pname       = "vlfeat";
    version     = "0.9.21";
    sources     = [{ filename = "mingw-w64-i686-vlfeat-0.9.21-1-any.pkg.tar.xz"; sha256 = "7b5539b8e9b6a9f91ca942ce3c378c2a255c1f2d63d58952dcb8a6b8f5477b22"; }];
    buildInputs = [ gcc-libs ];
  };

  "vo-amrwbenc" = fetch {
    pname       = "vo-amrwbenc";
    version     = "0.1.3";
    sources     = [{ filename = "mingw-w64-i686-vo-amrwbenc-0.1.3-1-any.pkg.tar.xz"; sha256 = "b7eeb05009156701809860e0eb22f4627e5fe4cace45323d1a5efdac3168bf57"; }];
    buildInputs = [  ];
  };

  "vrpn" = fetch {
    pname       = "vrpn";
    version     = "7.34";
    sources     = [{ filename = "mingw-w64-i686-vrpn-7.34-5-any.pkg.tar.xz"; sha256 = "8ceada2d121904502f473a02a984dab9b199f82a4582f5d7221a5169dbb3fd7a"; }];
    buildInputs = [ hidapi jsoncpp libusb python swig ];
  };

  "vtk" = fetch {
    pname       = "vtk";
    version     = "8.2.0";
    sources     = [{ filename = "mingw-w64-i686-vtk-8.2.0-4-any.pkg.tar.zst"; sha256 = "c81d245cac9bd8f7b6e3ccdb9542bd16677638720eed2986879c4a17265a9c8c"; }];
    buildInputs = [ gcc-libs double-conversion expat ffmpeg fontconfig freetype gdal hdf5 intel-tbb jsoncpp libjpeg libharu libpng libogg libtheora libtiff libxml2 lz4 pugixml qt5 zlib ];
  };

  "vulkan-headers" = fetch {
    pname       = "vulkan-headers";
    version     = "1.2.148";
    sources     = [{ filename = "mingw-w64-i686-vulkan-headers-1.2.148-1-any.pkg.tar.zst"; sha256 = "d52fcd40884b70fdba56dbee2cd09e9f55431561a540a235f927196fe71b71d0"; }];
    buildInputs = [ gcc-libs ];
  };

  "vulkan-loader" = fetch {
    pname       = "vulkan-loader";
    version     = "1.2.148";
    sources     = [{ filename = "mingw-w64-i686-vulkan-loader-1.2.148-1-any.pkg.tar.zst"; sha256 = "2d33ede07221f8b62f91ae87211d5fd828fde1eae058261987a7fa9ba1f0cc82"; }];
    buildInputs = [ vulkan-headers ];
  };

  "vulkan-validation-layers" = fetch {
    pname       = "vulkan-validation-layers";
    version     = "1.2.148";
    sources     = [{ filename = "mingw-w64-i686-vulkan-validation-layers-1.2.148-2-any.pkg.tar.zst"; sha256 = "c2d6ad7cd034a8750012f0ef14400a02416ad0dd40b3baa8a2296855002757c9"; }];
    buildInputs = [ gcc-libs vulkan-loader ];
  };

  "w3c-mathml2" = fetch {
    pname       = "w3c-mathml2";
    version     = "2.0";
    sources     = [{ filename = "mingw-w64-i686-w3c-mathml2-2.0-1-any.pkg.tar.xz"; sha256 = "fdfc069b2b559e68be517980589cff73e3815c4beeda4f6850bef9a3ccd3bca9"; }];
    buildInputs = [ libxml2 ];
  };

  "waf" = fetch {
    pname       = "waf";
    version     = "2.0.20";
    sources     = [{ filename = "mingw-w64-i686-waf-2.0.20-1-any.pkg.tar.xz"; sha256 = "c92ab7f8cdf86cfc1c9f8133e98cf0e70c692e0c765f857d689cd1db8da65080"; }];
    buildInputs = [ python ];
  };

  "wavpack" = fetch {
    pname       = "wavpack";
    version     = "5.3.0";
    sources     = [{ filename = "mingw-w64-i686-wavpack-5.3.0-1-any.pkg.tar.zst"; sha256 = "33b1c409e184362b87689475b9def9ea5beb0e8305bd490dd90471d0e560947e"; }];
    buildInputs = [ gcc-libs ];
  };

  "wget" = fetch {
    pname       = "wget";
    version     = "1.20.3";
    sources     = [{ filename = "mingw-w64-i686-wget-1.20.3-2-any.pkg.tar.xz"; sha256 = "959db4e720fc7167856b659433db3d0121df24a7daaf4cfb995da0ba2caa67d8"; }];
    buildInputs = [ pcre2 libidn2 openssl c-ares gpgme ];
  };

  "win7appid" = fetch {
    pname       = "win7appid";
    version     = "1.1";
    sources     = [{ filename = "mingw-w64-i686-win7appid-1.1-3-any.pkg.tar.xz"; sha256 = "f6305255a17f74993e47fca885a950c26f11aa6b864bb772eb755c668dcaf72d"; }];
  };

  "windows-default-manifest" = fetch {
    pname       = "windows-default-manifest";
    version     = "6.4";
    sources     = [{ filename = "mingw-w64-i686-windows-default-manifest-6.4-3-any.pkg.tar.xz"; sha256 = "56323bc39c7de0ff727915c09c4aaa25b8396efc0d7eda0006d5951bb6a6b983"; }];
    buildInputs = [  ];
  };

  "wined3d" = fetch {
    pname       = "wined3d";
    version     = "3.8";
    sources     = [{ filename = "mingw-w64-i686-wined3d-3.8-1-any.pkg.tar.xz"; sha256 = "26be5d3589012a5e71ea97758d83d62918ad2547a4a7a7b10d0fec722df11c9e"; }];
  };

  "wineditline" = fetch {
    pname       = "wineditline";
    version     = "2.205";
    sources     = [{ filename = "mingw-w64-i686-wineditline-2.205-3-any.pkg.tar.xz"; sha256 = "e9886c50a81144e6388bf924ef4f79614fe1fd0387df321e1463f3f4a3587088"; }];
    buildInputs = [  ];
  };

  "winico" = fetch {
    pname       = "winico";
    version     = "0.6";
    sources     = [{ filename = "mingw-w64-i686-winico-0.6-2-any.pkg.tar.xz"; sha256 = "27e2b286fdd9604f923277428beb833a3d7c48cd45abc11a0aa1d9ac7694c49c"; }];
    buildInputs = [ tk ];
  };

  "winpthreads-git" = fetch {
    pname       = "winpthreads-git";
    version     = "9.0.0.6029.ecb4ff54";
    sources     = [{ filename = "mingw-w64-i686-winpthreads-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "38cecd93170771a9c64c6619cf6b02539530f7b6b6e0be9be398aa104f79af28"; }];
    buildInputs = [ crt-git (assert libwinpthread-git.version=="9.0.0.6029.ecb4ff54"; libwinpthread-git) ];
  };

  "winsparkle" = fetch {
    pname       = "winsparkle";
    version     = "0.6.0";
    sources     = [{ filename = "mingw-w64-i686-winsparkle-0.6.0-1-any.pkg.tar.xz"; sha256 = "11a215ff74913f01e6bded1a74149427362c01402efe92289e7945d090c1967c"; }];
    buildInputs = [ expat openssl wxWidgets ];
  };

  "winstorecompat-git" = fetch {
    pname       = "winstorecompat-git";
    version     = "9.0.0.6029.ecb4ff54";
    sources     = [{ filename = "mingw-w64-i686-winstorecompat-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "9bc1850f8ab7f8c9645efc04f33632ed1c4387b186ba3baa7b9b1a87803aee44"; }];
  };

  "wintab-sdk" = fetch {
    pname       = "wintab-sdk";
    version     = "1.4";
    sources     = [{ filename = "mingw-w64-i686-wintab-sdk-1.4-2-any.pkg.tar.xz"; sha256 = "8425c5de8fda04d236bd6b452c495eb1fecd92e3b826123c8dffa7bc3c2830e5"; }];
  };

  "wkhtmltopdf-git" = fetch {
    pname       = "wkhtmltopdf-git";
    version     = "0.13.r1049.51f9658";
    sources     = [{ filename = "mingw-w64-i686-wkhtmltopdf-git-0.13.r1049.51f9658-1-any.pkg.tar.xz"; sha256 = "8742f92ff41dd38be606f7019ca3ef4d1ac4e7d9ead0aaa00d1ac89214f50b42"; }];
    buildInputs = [ qt5 qtwebkit ];
  };

  "woff2" = fetch {
    pname       = "woff2";
    version     = "1.0.2";
    sources     = [{ filename = "mingw-w64-i686-woff2-1.0.2-2-any.pkg.tar.xz"; sha256 = "d8c3d5e6a4996e80505c5a719f7e0d6d05f2c483f1a511ac1e1ff966195e7401"; }];
    buildInputs = [ gcc-libs brotli ];
  };

  "wslay" = fetch {
    pname       = "wslay";
    version     = "1.1.1";
    sources     = [{ filename = "mingw-w64-i686-wslay-1.1.1-1-any.pkg.tar.zst"; sha256 = "3d3e5828d9b7f53334eae6fe965f3702e89b6798030700136dc656bb8c86ae5b"; }];
    buildInputs = [ gcc-libs ];
  };

  "wxPython" = fetch {
    pname       = "wxPython";
    version     = "3.0.2.0";
    sources     = [{ filename = "mingw-w64-i686-wxPython-3.0.2.0-10-any.pkg.tar.zst"; sha256 = "7a156914527262e83a1c757d73722092c72474a55d93c1f8bfbb6bd779b911df"; }];
    buildInputs = [ python2 wxWidgets ];
  };

  "wxWidgets" = fetch {
    pname       = "wxWidgets";
    version     = "3.0.5.1";
    sources     = [{ filename = "mingw-w64-i686-wxWidgets-3.0.5.1-1-any.pkg.tar.zst"; sha256 = "66949f44947c1f0a786049518ddd7a92428de4771637728e8e8e5ed9c90f00ca"; }];
    buildInputs = [ gcc-libs expat libjpeg-turbo libpng libtiff xz zlib ];
  };

  "wxmsw3.1" = fetch {
    pname       = "wxmsw3.1";
    version     = "3.1.3";
    sources     = [{ filename = "mingw-w64-i686-wxmsw3.1-3.1.3-1-any.pkg.tar.zst"; sha256 = "b9b44d701c53c4e0db0667cccfc8102ea4c27da21df2df4e940589f8d78b97b8"; }];
    buildInputs = [ gcc-libs expat libjpeg-turbo libpng libtiff xz zlib ];
  };

  "wxsvg" = fetch {
    pname       = "wxsvg";
    version     = "1.5.22";
    sources     = [{ filename = "mingw-w64-i686-wxsvg-1.5.22-1-any.pkg.tar.xz"; sha256 = "44df06cbc4f67b99df75fc95b66f0f5303f7b06cbc0f50f566a06fd0037fcdcd"; }];
    buildInputs = [ wxWidgets cairo pango expat libexif ffmpeg ];
  };

  "x264-git" = fetch {
    pname       = "x264-git";
    version     = "r2991.1771b556";
    sources     = [{ filename = "mingw-w64-i686-x264-git-r2991.1771b556-1-any.pkg.tar.xz"; sha256 = "02f1d0aa90a2861334793554bd141310e399a8ef2b713320877b0f4829c3568d"; }];
    buildInputs = [ libwinpthread-git l-smash ffms2 ];
  };

  "x265" = fetch {
    pname       = "x265";
    version     = "3.4";
    sources     = [{ filename = "mingw-w64-i686-x265-3.4-1-any.pkg.tar.zst"; sha256 = "996f4543b03a3a8d6ff57b5163c18de09105677cb7eb1c7a702ed7fa6d38b331"; }];
    buildInputs = [ gcc-libs ];
  };

  "xalan-c" = fetch {
    pname       = "xalan-c";
    version     = "1.11";
    sources     = [{ filename = "mingw-w64-i686-xalan-c-1.11-7-any.pkg.tar.xz"; sha256 = "7c5932a5445882e173fc3fd25aded507bddeb92142877b4a3fa83847b18585fb"; }];
    buildInputs = [ gcc-libs xerces-c ];
  };

  "xapian-core" = fetch {
    pname       = "xapian-core";
    version     = "1~1.4.17";
    sources     = [{ filename = "mingw-w64-i686-xapian-core-1~1.4.17-1-any.pkg.tar.zst"; sha256 = "5278b4b21993e3ed75543d76904c0da7c8c97fee8d64f673b1098518819ede85"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "xavs" = fetch {
    pname       = "xavs";
    version     = "0.1.55";
    sources     = [{ filename = "mingw-w64-i686-xavs-0.1.55-1-any.pkg.tar.xz"; sha256 = "f770ddfda505ee16f7cebe2c8adcbd43570cbd948daaffe0bc37407229060d35"; }];
    buildInputs = [ gcc-libs ];
  };

  "xerces-c" = fetch {
    pname       = "xerces-c";
    version     = "3.2.3";
    sources     = [{ filename = "mingw-w64-i686-xerces-c-3.2.3-2-any.pkg.tar.zst"; sha256 = "04acff7dac854d7fd7171d0f213fb1699bd1c66bc894e7fc54a96feaec8cf046"; }];
    buildInputs = [ gcc-libs icu ];
  };

  "xlnt" = fetch {
    pname       = "xlnt";
    version     = "1.5.0";
    sources     = [{ filename = "mingw-w64-i686-xlnt-1.5.0-1-any.pkg.tar.xz"; sha256 = "47e541bc45fb3c7635c2d2ba0b50e95342e6093d3a0c88484b469fa22b6b71e8"; }];
    buildInputs = [ gcc-libs ];
  };

  "xmake" = fetch {
    pname       = "xmake";
    version     = "2.3.8";
    sources     = [{ filename = "mingw-w64-i686-xmake-2.3.8-1-any.pkg.tar.zst"; sha256 = "6535bfea57cef199e75b79b9179d7ec9dc738fdde8c01ea327a1eb9b1ea501f6"; }];
    buildInputs = [ ncurses readline ];
  };

  "xmlada" = fetch {
    pname       = "xmlada";
    version     = "2021.0.0";
    sources     = [{ filename = "mingw-w64-i686-xmlada-2021.0.0-1-any.pkg.tar.zst"; sha256 = "2eb5f3216e6145fea3d334a1919c1c79f4a58e8551b776a225fe84696fba4f30"; }];
    buildInputs = [  ];
  };

  "xmlsec" = fetch {
    pname       = "xmlsec";
    version     = "1.2.30";
    sources     = [{ filename = "mingw-w64-i686-xmlsec-1.2.30-1-any.pkg.tar.xz"; sha256 = "ec308009c747f320278ede227b2bb4102a74cfd06cfe4704a87871816cde71e0"; }];
    buildInputs = [ libxml2 libxslt openssl gnutls nss libtool ];
  };

  "xmlstarlet-git" = fetch {
    pname       = "xmlstarlet-git";
    version     = "r678.9a470e3";
    sources     = [{ filename = "mingw-w64-i686-xmlstarlet-git-r678.9a470e3-2-any.pkg.tar.xz"; sha256 = "988e39273bd2e2ffe46e9e7feb4abe2aa711be77744220e86b4547c4fd42f0a9"; }];
    buildInputs = [ libxml2 libxslt ];
  };

  "xpdf" = fetch {
    pname       = "xpdf";
    version     = "4.02";
    sources     = [{ filename = "mingw-w64-i686-xpdf-4.02-1-any.pkg.tar.xz"; sha256 = "e9d5c53a4d63fa80aafaa29de727cf4b039f6923eb1298551e4bbeaaa6edab98"; }];
    buildInputs = [ freetype libjpeg-turbo libpaper libpng libtiff qt5 zlib ];
  };

  "xpm-nox" = fetch {
    pname       = "xpm-nox";
    version     = "4.2.0";
    sources     = [{ filename = "mingw-w64-i686-xpm-nox-4.2.0-5-any.pkg.tar.xz"; sha256 = "28c5a3b200cbc3db6e3e2ebc3a9c953d43c80ede2a6d8a21ad1db5b7da3a2a01"; }];
    buildInputs = [ gcc-libs ];
  };

  "xvidcore" = fetch {
    pname       = "xvidcore";
    version     = "1.3.7";
    sources     = [{ filename = "mingw-w64-i686-xvidcore-1.3.7-1-any.pkg.tar.xz"; sha256 = "6283712d24f28edd6d41c1b366b7de353424000e3ba7a6689d4e2211a0dc4c1c"; }];
    buildInputs = [  ];
  };

  "xxhash" = fetch {
    pname       = "xxhash";
    version     = "0.8.0";
    sources     = [{ filename = "mingw-w64-i686-xxhash-0.8.0-1-any.pkg.tar.zst"; sha256 = "75986aff24b570c7ce4288dee784474f7eafe57385273462d54a5fd07f5d9695"; }];
    buildInputs = [  ];
  };

  "xz" = fetch {
    pname       = "xz";
    version     = "5.2.5";
    sources     = [{ filename = "mingw-w64-i686-xz-5.2.5-1-any.pkg.tar.xz"; sha256 = "7d8cae7e18c72f2ba83cbc5a98c62a68f016c03980d4f6692ea343c271078d4f"; }];
    buildInputs = [ gcc-libs gettext ];
  };

  "yajl" = fetch {
    pname       = "yajl";
    version     = "2.1.0";
    sources     = [{ filename = "mingw-w64-i686-yajl-2.1.0-1-any.pkg.tar.xz"; sha256 = "4a368dc6bcc3cb8632ae51d2d427f644d03cd9bd1a13f12ebe283ef833191d64"; }];
    buildInputs = [  ];
  };

  "yaml-cpp" = fetch {
    pname       = "yaml-cpp";
    version     = "0.6.3";
    sources     = [{ filename = "mingw-w64-i686-yaml-cpp-0.6.3-3-any.pkg.tar.xz"; sha256 = "1a29cde08b1ecbb09518373db9a18291c656b10441afa7ed0de38bd8b2957dfa"; }];
    buildInputs = [  ];
  };

  "yaml-cpp0.3" = fetch {
    pname       = "yaml-cpp0.3";
    version     = "0.3.0";
    sources     = [{ filename = "mingw-w64-i686-yaml-cpp0.3-0.3.0-2-any.pkg.tar.xz"; sha256 = "778a22a9bdaf40133a50551ff1c9a20f383a954423a5b22e47cdd7d38ca874db"; }];
  };

  "yasm" = fetch {
    pname       = "yasm";
    version     = "1.3.0";
    sources     = [{ filename = "mingw-w64-i686-yasm-1.3.0-4-any.pkg.tar.xz"; sha256 = "df08d4c79896358d9f36088db2a22ab3c39c45c738eb084a41074ab10e520697"; }];
    buildInputs = [ gettext ];
  };

  "yelp-tools" = fetch {
    pname       = "yelp-tools";
    version     = "3.38.0";
    sources     = [{ filename = "mingw-w64-i686-yelp-tools-3.38.0-1-any.pkg.tar.zst"; sha256 = "5557dd42634b306a4ac36a1546df6688295ea36b84745ab21e3b6e3f2fb5d1b1"; }];
    buildInputs = [ intltool libxml2 libxslt itstool python3-mallard-ducktype yelp-xsl ];
    broken      = true; # broken dependency yelp-tools -> intltool
  };

  "yelp-xsl" = fetch {
    pname       = "yelp-xsl";
    version     = "3.38.1";
    sources     = [{ filename = "mingw-w64-i686-yelp-xsl-3.38.1-1-any.pkg.tar.zst"; sha256 = "0814383934418913f8a23589806c1338c73451bcabb716399bf6f0646186e0ff"; }];
  };

  "yices" = fetch {
    pname       = "yices";
    version     = "2.6.1";
    sources     = [{ filename = "mingw-w64-i686-yices-2.6.1-1-any.pkg.tar.zst"; sha256 = "f133f9c2710d9e1aeb2ac7d7a5cb618d50bcb21664b9d293b37f5fb075166c4a"; }];
    buildInputs = [ gmp ];
  };

  "z3" = fetch {
    pname       = "z3";
    version     = "4.8.9";
    sources     = [{ filename = "mingw-w64-i686-z3-4.8.9-1-any.pkg.tar.zst"; sha256 = "4e9a185160efaae7fa0c21aaa7613d751e77341dde3a20760636117e8d583bbc"; }];
    buildInputs = [  ];
  };

  "zbar" = fetch {
    pname       = "zbar";
    version     = "0.23.1";
    sources     = [{ filename = "mingw-w64-i686-zbar-0.23.1-2-any.pkg.tar.zst"; sha256 = "376d9a75577b47277e56749f11c0a53bf79d105b08874b11e9245fee1e1cf83d"; }];
    buildInputs = [ imagemagick ];
  };

  "zeal" = fetch {
    pname       = "zeal";
    version     = "0.6.1";
    sources     = [{ filename = "mingw-w64-i686-zeal-0.6.1-2-any.pkg.tar.zst"; sha256 = "03c734ecf4eeac2524daa99f5a14d9bc47f7f7ecaec14f68aee699de0c94bf0e"; }];
    buildInputs = [ libarchive qt5 qtwebkit ];
  };

  "zeromq" = fetch {
    pname       = "zeromq";
    version     = "4.3.3";
    sources     = [{ filename = "mingw-w64-i686-zeromq-4.3.3-1-any.pkg.tar.zst"; sha256 = "a978a9b4ba5673ed4708b556f7893b3f3bdd15be3baf14e679643dbe6c16ffd6"; }];
    buildInputs = [ libsodium ];
  };

  "zimg" = fetch {
    pname       = "zimg";
    version     = "2.9.3";
    sources     = [{ filename = "mingw-w64-i686-zimg-2.9.3-1-any.pkg.tar.xz"; sha256 = "0283cd00767bc39831d6a5d5a08343acf5df190fbbb1be92e665c15292a0c802"; }];
    buildInputs = [ gcc-libs winpthreads-git ];
  };

  "zlib" = fetch {
    pname       = "zlib";
    version     = "1.2.11";
    sources     = [{ filename = "mingw-w64-i686-zlib-1.2.11-7-any.pkg.tar.xz"; sha256 = "addf6c52134027407640f1cbdf4efc5b64430f3a286cb4e4c4f5dbb44ce55a42"; }];
    buildInputs = [  ];
  };

  "zopfli" = fetch {
    pname       = "zopfli";
    version     = "1.0.3";
    sources     = [{ filename = "mingw-w64-i686-zopfli-1.0.3-1-any.pkg.tar.xz"; sha256 = "9201d87d854f6bd385a61f93c7ab4588734c811a5630ca35aa5d4d73e6b1a677"; }];
    buildInputs = [ gcc-libs ];
  };

  "zstd" = fetch {
    pname       = "zstd";
    version     = "1.4.5";
    sources     = [{ filename = "mingw-w64-i686-zstd-1.4.5-1-any.pkg.tar.zst"; sha256 = "487d6598109391c4aa2b027c7a73a5f038cdc1497a177c4771db3819638a2e94"; }];
    buildInputs = [  ];
  };

  "zziplib" = fetch {
    pname       = "zziplib";
    version     = "0.13.71";
    sources     = [{ filename = "mingw-w64-i686-zziplib-0.13.71-1-any.pkg.tar.zst"; sha256 = "075231ff6cee7c6aeb351f7eef20f155dbf3ef60d4c1076d256d31d39b88609f"; }];
    buildInputs = [ zlib ];
  };

  "freetype+harfbuzz" = fetch {
    pname       = "freetype+harfbuzz";
    version     = "2.10.4-1+2.7.2-1";
    sources     = [{ filename = "mingw-w64-i686-freetype-2.10.4-1-any.pkg.tar.zst"; sha256 = "c6de8f05b1d3997c3dab7c3124d2b6ca1af49412236fa7af543849b56880ab91"; }
                   { filename = "mingw-w64-i686-harfbuzz-2.7.2-1-any.pkg.tar.zst"; sha256 = "619663fa83f10316759c3b44a802f7b3f0c1be493727781bb4413d3564c0e22b"; }];
    buildInputs = [ gcc-libs brotli bzip2 libpng zlib gcc-libs glib2 graphite2 ];
  };

}; in self
