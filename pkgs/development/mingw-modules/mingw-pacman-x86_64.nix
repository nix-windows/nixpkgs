 # GENERATED FILE
{stdenvNoCC, fetchurl, mingwPacman, msysPacman}:

let
  fetch = { pname, version, srcs, buildInputs ? [], broken ? false }:
    if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
      stdenvNoCC.mkDerivation {
        inherit version buildInputs;
        name = "mingw64-${pname}-${version}";
        srcs = map ({filename, sha256}:
                    fetchurl {
                      url = "http://repo.msys2.org/mingw/x86_64/${filename}";
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
                    url = "http://repo.msys2.org/mingw/x86_64/${filename}";
                    inherit sha256;
                  }) srcs;
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
             stdenvNoCC.lib.optionalString (!(builtins.elem "mingw/${pname}" ["msys/msys2-runtime" "msys/bash" "msys/coreutils" "msys/gmp" "msys/libiconv" "msys/gcc-libs" "msys/libintl"])) ''
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
                 for my $file (glob("$ENV{out}/mingw64/bin/*")) {
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
    srcs        = [{ filename = "mingw-w64-x86_64-3proxy-0.8.13-1-any.pkg.tar.xz"; sha256 = "3cd2a1f3cde206e95b1f0a84199761a3dec27e97b1b2655f4297c67e55e2009c"; }];
  };

  "4th" = fetch {
    pname       = "4th";
    version     = "3.62.5";
    srcs        = [{ filename = "mingw-w64-x86_64-4th-3.62.5-1-any.pkg.tar.xz"; sha256 = "af283a192321ec5c7cc7feabe85fb9c80dbd20b2b384bb78c25563bc39ed1499"; }];
  };

  "FAudio" = fetch {
    pname       = "FAudio";
    version     = "20.09";
    srcs        = [{ filename = "mingw-w64-x86_64-FAudio-20.09-1-any.pkg.tar.zst"; sha256 = "6399fe09344b73348ba282a2ea0c1a684c2f526790c91413a0060162b10a0bd8"; }];
    buildInputs = [ SDL2 glib2 gstreamer gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "MinHook" = fetch {
    pname       = "MinHook";
    version     = "1.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-MinHook-1.3.3-1-any.pkg.tar.xz"; sha256 = "a282497981bbefa4c14758bd6e88ba4e3886372b97fda0cb5224cfa5d378c747"; }];
  };

  "OpenSceneGraph" = fetch {
    pname       = "OpenSceneGraph";
    version     = "3.6.5";
    srcs        = [{ filename = "mingw-w64-x86_64-OpenSceneGraph-3.6.5-5-any.pkg.tar.zst"; sha256 = "c34a782bad41c87b3ae801b9b1420c4ef144bb288f0dfa1b8a6a075aee0c2e35"; }];
    buildInputs = [ boost collada-dom-svn curl ffmpeg fltk freetype gcc-libs gdal giflib gstreamer gtk2 gtkglext jasper libjpeg libpng libtiff libvncserver libxml2 lua SDL SDL2 poppler python wxWidgets zlib ];
  };

  "OpenSceneGraph-debug" = fetch {
    pname       = "OpenSceneGraph-debug";
    version     = "3.6.5";
    srcs        = [{ filename = "mingw-w64-x86_64-OpenSceneGraph-debug-3.6.5-5-any.pkg.tar.zst"; sha256 = "0d21f6053c2bc1727130feeedc942ce0c2bd09e1fda162d33c6235336284d32e"; }];
    buildInputs = [ (assert OpenSceneGraph.version=="3.6.5"; OpenSceneGraph) ];
  };

  "SDL" = fetch {
    pname       = "SDL";
    version     = "1.2.15";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL-1.2.15-8-any.pkg.tar.xz"; sha256 = "5c085fdc62dfeb2b8afa53764008b3dcfb7b1ad96a974be9447c05a9ffe57e68"; }];
    buildInputs = [ gcc-libs libiconv ];
  };

  "SDL2" = fetch {
    pname       = "SDL2";
    version     = "2.0.12";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL2-2.0.12-5-any.pkg.tar.zst"; sha256 = "b80166f84ed006c4aaacf4895fcc7efe99d0b777dc22db22ea1f40d6838c109a"; }];
    buildInputs = [ gcc-libs libiconv vulkan ];
  };

  "SDL2_gfx" = fetch {
    pname       = "SDL2_gfx";
    version     = "1.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL2_gfx-1.0.4-1-any.pkg.tar.xz"; sha256 = "d006ee1dfaa82cefbc48795f2de78bf2f2b3f2bcdb2816f4e9656523f71e332e"; }];
    buildInputs = [ SDL2 ];
  };

  "SDL2_image" = fetch {
    pname       = "SDL2_image";
    version     = "2.0.5";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL2_image-2.0.5-1-any.pkg.tar.xz"; sha256 = "fd5510e7daf25afb103247e36d07557ac69414810fc060ccdde453a2d51d8bae"; }];
    buildInputs = [ SDL2 libpng libtiff libjpeg-turbo libwebp ];
  };

  "SDL2_mixer" = fetch {
    pname       = "SDL2_mixer";
    version     = "2.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL2_mixer-2.0.4-2-any.pkg.tar.xz"; sha256 = "fdc3cf7adf1de4299e1e95627a60b9f6915d28a9344fa6af333a2bffdd5bf8c7"; }];
    buildInputs = [ gcc-libs SDL2 flac fluidsynth libvorbis libmodplug mpg123 opusfile ];
  };

  "SDL2_net" = fetch {
    pname       = "SDL2_net";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL2_net-2.0.1-1-any.pkg.tar.xz"; sha256 = "d2e7a04a8ce51071807c9a0b33d8241dd50ae8f6b75c7b2afcf1cca05b3c62be"; }];
    buildInputs = [ gcc-libs SDL2 ];
  };

  "SDL2_ttf" = fetch {
    pname       = "SDL2_ttf";
    version     = "2.0.15";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL2_ttf-2.0.15-1-any.pkg.tar.xz"; sha256 = "55c179a9708cc2d52bb0eea8d9b64de3476e84a623912645a7b8566f6063089a"; }];
    buildInputs = [ SDL2 freetype ];
  };

  "SDL_gfx" = fetch {
    pname       = "SDL_gfx";
    version     = "2.0.26";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL_gfx-2.0.26-1-any.pkg.tar.xz"; sha256 = "74e6ebcdbab8e2ff0fa20315dba397c55c35ba0dcdb04ebe557a7c7a89256a78"; }];
    buildInputs = [ SDL ];
  };

  "SDL_image" = fetch {
    pname       = "SDL_image";
    version     = "1.2.12";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL_image-1.2.12-6-any.pkg.tar.xz"; sha256 = "3c142e60d30d05b1c41b0d317418ecc6786529d0750fd5b0c6a4176f4765271b"; }];
    buildInputs = [ SDL libjpeg-turbo libpng libtiff libwebp zlib ];
  };

  "SDL_mixer" = fetch {
    pname       = "SDL_mixer";
    version     = "1.2.12";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL_mixer-1.2.12-6-any.pkg.tar.xz"; sha256 = "478d1fc3b8a103d026cce4f4a81537a6d39ac4a59a94ed501fd9332f35d8ec7b"; }];
    buildInputs = [ SDL libvorbis libmikmod libmad flac ];
  };

  "SDL_net" = fetch {
    pname       = "SDL_net";
    version     = "1.2.8";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL_net-1.2.8-2-any.pkg.tar.xz"; sha256 = "89dda2cc596e14442b9338bb9982fcfc65d9bcf25b1a9f0290a506d62185c78a"; }];
    buildInputs = [ SDL ];
  };

  "SDL_ttf" = fetch {
    pname       = "SDL_ttf";
    version     = "2.0.11";
    srcs        = [{ filename = "mingw-w64-x86_64-SDL_ttf-2.0.11-5-any.pkg.tar.xz"; sha256 = "33548e3113c015aee1473c471fa5654ff1238ea3a5d690dfa3a0af64fbbfd6d4"; }];
    buildInputs = [ SDL freetype ];
  };

  "a52dec" = fetch {
    pname       = "a52dec";
    version     = "0.7.4";
    srcs        = [{ filename = "mingw-w64-x86_64-a52dec-0.7.4-4-any.pkg.tar.xz"; sha256 = "ed79a259507f655a08dd7385b2285116e6826d25d41e168e4dddd66039c4f486"; }];
  };

  "adns" = fetch {
    pname       = "adns";
    version     = "1.4.g10.7";
    srcs        = [{ filename = "mingw-w64-x86_64-adns-1.4.g10.7-1-any.pkg.tar.xz"; sha256 = "c1c673566c5f770804b53b1913a0fe45d0f5b823527542c4e81456fde37259c2"; }];
    buildInputs = [ gcc-libs ];
  };

  "adobe-source-code-pro-fonts" = fetch {
    pname       = "adobe-source-code-pro-fonts";
    version     = "2.030ro+1.050it";
    srcs        = [{ filename = "mingw-w64-x86_64-adobe-source-code-pro-fonts-2.030ro+1.050it-1-any.pkg.tar.xz"; sha256 = "f80da0eb58fa881ab77b3627600b3e3bd806c6a060a43c906e6d8498cac11d40"; }];
  };

  "adwaita-icon-theme" = fetch {
    pname       = "adwaita-icon-theme";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-adwaita-icon-theme-3.38.0-1-any.pkg.tar.zst"; sha256 = "500095a0acfcc334758754dc4f45330aaaa0735672309e2f6731c0a4cbe28704"; }];
    buildInputs = [ hicolor-icon-theme librsvg ];
  };

  "ag" = fetch {
    pname       = "ag";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-ag-2.2.0-2-any.pkg.tar.zst"; sha256 = "3e4534537c7c09714b5996b0ffb4adfa7f8cc75089ec4093d341c32b95c32067"; }];
    buildInputs = [ pcre xz zlib ];
  };

  "alembic" = fetch {
    pname       = "alembic";
    version     = "1.7.14";
    srcs        = [{ filename = "mingw-w64-x86_64-alembic-1.7.14-1-any.pkg.tar.zst"; sha256 = "9d10c675421ff40e19b9861a1f4ff89646656f9415a42cc7ca55b827b2e5e704"; }];
    buildInputs = [ openexr boost hdf5 zlib ];
  };

  "allegro" = fetch {
    pname       = "allegro";
    version     = "5.2.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-allegro-5.2.6.0-1-any.pkg.tar.xz"; sha256 = "3aad8364886ebfe92da0a9366656f8fa0a64397eb87cc07251d77337bfce8966"; }];
    buildInputs = [ gcc-libs ];
  };

  "alure" = fetch {
    pname       = "alure";
    version     = "1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-alure-1.2-1-any.pkg.tar.xz"; sha256 = "42367756a0ab46fdc8d5b7d8acf3105e06817f4b79c38574e7b6f2366c3d5b61"; }];
    buildInputs = [ openal ];
  };

  "amqp-cpp" = fetch {
    pname       = "amqp-cpp";
    version     = "4.1.6";
    srcs        = [{ filename = "mingw-w64-x86_64-amqp-cpp-4.1.6-2-any.pkg.tar.zst"; sha256 = "f31a02f0562fdc7c4762ec83296994ea8a243d0ae59d02c70f422aa731acb18f"; }];
  };

  "amtk" = fetch {
    pname       = "amtk";
    version     = "5.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-amtk-5.2.0-2-any.pkg.tar.zst"; sha256 = "5ff84e496996c8d269912d7407aafac8bf740e334abfdb0c2e8f3ff32a294fcc"; }];
    buildInputs = [ gtk3 ];
  };

  "ansicon-git" = fetch {
    pname       = "ansicon-git";
    version     = "1.70.r65.3acc7a9";
    srcs        = [{ filename = "mingw-w64-x86_64-ansicon-git-1.70.r65.3acc7a9-2-any.pkg.tar.xz"; sha256 = "3615e8f60acb74525979129c53fcdbeab819ccf6be2d6128f655a4dbacac24c7"; }];
  };

  "antiword" = fetch {
    pname       = "antiword";
    version     = "0.37";
    srcs        = [{ filename = "mingw-w64-x86_64-antiword-0.37-2-any.pkg.tar.xz"; sha256 = "cae3a53a31a9abcc17f125d6b5ce3530b193070428e05e7b7546664a270e5c56"; }];
  };

  "antlr3" = fetch {
    pname       = "antlr3";
    version     = "3.5.2";
    srcs        = [{ filename = "mingw-w64-x86_64-antlr3-3.5.2-1-any.pkg.tar.xz"; sha256 = "f9d7aa7b08fe4777d0685df59784644cc6656367000968e67af849edbc642289"; }];
  };

  "antlr4-runtime-cpp" = fetch {
    pname       = "antlr4-runtime-cpp";
    version     = "4.8";
    srcs        = [{ filename = "mingw-w64-x86_64-antlr4-runtime-cpp-4.8-1-any.pkg.tar.xz"; sha256 = "81bbddaa3f08f5c6a589ab16af0d06705b1c21658ef08cb15db3222d6aaf029f"; }];
  };

  "aom" = fetch {
    pname       = "aom";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-aom-2.0.0-3-any.pkg.tar.zst"; sha256 = "b4187039ea4bbe643e512d992a7398701b998c35fbd1e2a03ea0cab6e04b97a9"; }];
    buildInputs = [ gcc-libs ];
  };

  "appstream-glib" = fetch {
    pname       = "appstream-glib";
    version     = "0.7.17";
    srcs        = [{ filename = "mingw-w64-x86_64-appstream-glib-0.7.17-3-any.pkg.tar.zst"; sha256 = "0a64e309e3f4f105fce1f01195ac3136ee122dc4ef19cabaf74eb5e7158f3630"; }];
    buildInputs = [ gdk-pixbuf2 glib2 gtk3 json-glib libyaml libsoup libarchive ];
  };

  "apr" = fetch {
    pname       = "apr";
    version     = "1.6.5";
    srcs        = [{ filename = "mingw-w64-x86_64-apr-1.6.5-3-any.pkg.tar.zst"; sha256 = "062560463c0f7e5d174814f58a4837d01f783987d8ab3ca8bfbc72e23da8727d"; }];
  };

  "apr-util" = fetch {
    pname       = "apr-util";
    version     = "1.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-apr-util-1.6.1-2-any.pkg.tar.zst"; sha256 = "3716b2381613339046b2298eccc3ede42fe684fd952da268a84a17ebffe61977"; }];
    buildInputs = [ apr expat libmariadbclient sqlite3 unixodbc postgresql openldap nss gdbm openssl ];
  };

  "argon2" = fetch {
    pname       = "argon2";
    version     = "20190702";
    srcs        = [{ filename = "mingw-w64-x86_64-argon2-20190702-1-any.pkg.tar.xz"; sha256 = "23ccdb605430a091da26235ab86197d57e755359c1ee15a63c4f92eced603bf8"; }];
  };

  "aria2" = fetch {
    pname       = "aria2";
    version     = "1.35.0";
    srcs        = [{ filename = "mingw-w64-x86_64-aria2-1.35.0-2-any.pkg.tar.xz"; sha256 = "259c9f18af2d306c61db477b8b4c1249e4243e3f1de4c72b4618ee572c0c63ae"; }];
    buildInputs = [ gcc-libs gettext c-ares cppunit libiconv libssh2 libuv libxml2 openssl sqlite3 zlib ];
  };

  "aribb24" = fetch {
    pname       = "aribb24";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-aribb24-1.0.3-3-any.pkg.tar.xz"; sha256 = "e50af2f5de17f0638d969924aaaa16766f8b8386b077247622d73e4075101b3f"; }];
    buildInputs = [ libpng ];
  };

  "arm-none-eabi-binutils" = fetch {
    pname       = "arm-none-eabi-binutils";
    version     = "2.35";
    srcs        = [{ filename = "mingw-w64-x86_64-arm-none-eabi-binutils-2.35-1-any.pkg.tar.zst"; sha256 = "8388833fb4429fe22e1016ef0ca91c4b000a3466adec3ea883593b22db0b8f2a"; }];
  };

  "arm-none-eabi-gcc" = fetch {
    pname       = "arm-none-eabi-gcc";
    version     = "8.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-arm-none-eabi-gcc-8.4.0-3-any.pkg.tar.zst"; sha256 = "399d64366510d1f4caf96a13a835e7c5c8290c9cfedfe94128cbc916ac65adbc"; }];
    buildInputs = [ arm-none-eabi-binutils arm-none-eabi-newlib isl mpc zlib ];
  };

  "arm-none-eabi-gdb" = fetch {
    pname       = "arm-none-eabi-gdb";
    version     = "9.2";
    srcs        = [{ filename = "mingw-w64-x86_64-arm-none-eabi-gdb-9.2-2-any.pkg.tar.zst"; sha256 = "bd9588683bbf36eaf45d40a0408594983c6d1cd9b418811a23bae240a4707318"; }];
    buildInputs = [ expat libiconv ncurses python readline xxhash zlib ];
  };

  "arm-none-eabi-newlib" = fetch {
    pname       = "arm-none-eabi-newlib";
    version     = "3.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-arm-none-eabi-newlib-3.3.0-1-any.pkg.tar.zst"; sha256 = "9d566a915fd8abe84b4db904e4cfe32ca074f81319069fbaf41284c3dcb976fd"; }];
    buildInputs = [ arm-none-eabi-binutils ];
  };

  "armadillo" = fetch {
    pname       = "armadillo";
    version     = "9.900.1";
    srcs        = [{ filename = "mingw-w64-x86_64-armadillo-9.900.1-2-any.pkg.tar.zst"; sha256 = "c8ed662c4afaaca815e2b35d90265962a706e7810b4293786ae2cd045f5a954c"; }];
    buildInputs = [ gcc-libs arpack hdf5 openblas ];
  };

  "arpack" = fetch {
    pname       = "arpack";
    version     = "3.7.0";
    srcs        = [{ filename = "mingw-w64-x86_64-arpack-3.7.0-2-any.pkg.tar.xz"; sha256 = "a0f6bafa74f9f447c1e62ec67629402d6e1ca216fb424a900e547185b60f72d7"; }];
    buildInputs = [ gcc-libgfortran openblas ];
  };

  "arrow" = fetch {
    pname       = "arrow";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-arrow-1.0.1-1-any.pkg.tar.zst"; sha256 = "fb01b2b82eac54046959a5304af85e90bb284fdab9e950aa1399085ff4ba581d"; }];
    buildInputs = [ boost brotli bzip2 double-conversion flatbuffers gflags gobject-introspection grpc libutf8proc lz4 openssl protobuf python3-numpy rapidjson re2 snappy thrift uriparser zlib zstd ];
    broken      = true; # broken dependency arrow -> python3-numpy
  };

  "asciidoc" = fetch {
    pname       = "asciidoc";
    version     = "9.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-asciidoc-9.0.1-1-any.pkg.tar.zst"; sha256 = "dc54e58681eda22838da52ec82e76b2396e2429690efb8406c0f3611fa3ab58f"; }];
    buildInputs = [ python libxslt docbook-xsl ];
  };

  "asciidoctor" = fetch {
    pname       = "asciidoctor";
    version     = "2.0.10";
    srcs        = [{ filename = "mingw-w64-x86_64-asciidoctor-2.0.10-2-any.pkg.tar.xz"; sha256 = "01d25a5410497f0aec961b921330226fff8aff1de04701b355947d541acdd96a"; }];
    buildInputs = [ ruby ];
  };

  "asio" = fetch {
    pname       = "asio";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-asio-1.18.0-1-any.pkg.tar.zst"; sha256 = "04f1a4896ad9f83d9ca7775b9b6bc0b881722dcdca25205bd4afe84bc35bad54"; }];
  };

  "aspell" = fetch {
    pname       = "aspell";
    version     = "0.60.7";
    srcs        = [{ filename = "mingw-w64-x86_64-aspell-0.60.7-1-any.pkg.tar.xz"; sha256 = "1287d71c105f4289c04aebd3bb997e63ff6c754517563c055ac3c109a935b1e4"; }];
    buildInputs = [ gcc-libs libiconv gettext ];
  };

  "aspell-de" = fetch {
    pname       = "aspell-de";
    version     = "20161207";
    srcs        = [{ filename = "mingw-w64-x86_64-aspell-de-20161207-2-any.pkg.tar.xz"; sha256 = "9b523f516f52a0a923b6146c846737477f0b0cfb796fa4599a3d687c2462c504"; }];
    buildInputs = [ aspell ];
  };

  "aspell-en" = fetch {
    pname       = "aspell-en";
    version     = "2019.10.06";
    srcs        = [{ filename = "mingw-w64-x86_64-aspell-en-2019.10.06-1-any.pkg.tar.xz"; sha256 = "47b101231bff75c8a867561cd0dbb1bdbf6f11812733d0a24bc1d7202adc9b7f"; }];
    buildInputs = [ aspell ];
  };

  "aspell-es" = fetch {
    pname       = "aspell-es";
    version     = "1.11.2";
    srcs        = [{ filename = "mingw-w64-x86_64-aspell-es-1.11.2-1-any.pkg.tar.xz"; sha256 = "9b50cd391fc86f97167314b1b1c4c854f82112f6c355494535c04f4be20bfb26"; }];
    buildInputs = [ aspell ];
  };

  "aspell-fr" = fetch {
    pname       = "aspell-fr";
    version     = "0.50.3";
    srcs        = [{ filename = "mingw-w64-x86_64-aspell-fr-0.50.3-1-any.pkg.tar.xz"; sha256 = "6f53eee2ea24f06ca473c106083cc2b8d19280bb64566cab7f17b6970fc03498"; }];
    buildInputs = [ aspell ];
  };

  "aspell-ru" = fetch {
    pname       = "aspell-ru";
    version     = "0.99f7.1";
    srcs        = [{ filename = "mingw-w64-x86_64-aspell-ru-0.99f7.1-1-any.pkg.tar.xz"; sha256 = "9865e6efc725b8556a07081c2c5b36be098db51d58f13cae2829050ca955e2bf"; }];
    buildInputs = [ aspell ];
  };

  "assimp" = fetch {
    pname       = "assimp";
    version     = "5.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-assimp-5.0.1-3-any.pkg.tar.zst"; sha256 = "a461b93185dac7d80e3f07340a4d30f9b3bc1ec552eb21b38f2112b1a099241b"; }];
    buildInputs = [ minizip-git zziplib zlib ];
  };

  "astyle" = fetch {
    pname       = "astyle";
    version     = "3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-astyle-3.1-1-any.pkg.tar.xz"; sha256 = "9bb2b976627d48694774d90165b79b7b4fa48f7a68676da57dbe2dfaa2478f88"; }];
    buildInputs = [ gcc-libs ];
  };

  "atk" = fetch {
    pname       = "atk";
    version     = "2.36.0";
    srcs        = [{ filename = "mingw-w64-x86_64-atk-2.36.0-1-any.pkg.tar.xz"; sha256 = "22342ac56494b63095ec55ed737719236bab2ffd877bed3f77fad8e0b65c69a1"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.46.0"; glib2) ];
  };

  "atkmm" = fetch {
    pname       = "atkmm";
    version     = "2.28.0";
    srcs        = [{ filename = "mingw-w64-x86_64-atkmm-2.28.0-1-any.pkg.tar.xz"; sha256 = "067f074d2652cb883994ddf93357e460d56ed620382bcd7f6757456b67b25b95"; }];
    buildInputs = [ atk gcc-libs glibmm self."libsigc++" ];
  };

  "attica-qt5" = fetch {
    pname       = "attica-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-attica-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "d5ecec15ff153966a53144918d142bc325711841005f253acb5ecf40650714d1"; }];
    buildInputs = [ qt5 ];
  };

  "audaspace" = fetch {
    pname       = "audaspace";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-audaspace-1.3.0-2-any.pkg.tar.xz"; sha256 = "d1229b192898085704d58594285427ebcb76adf386266e2b4d3ba49689511d45"; }];
    buildInputs = [ ffmpeg fftw libsndfile openal python3 python3-numpy SDL2 ];
    broken      = true; # broken dependency audaspace -> python3-numpy
  };

  "avr-binutils" = fetch {
    pname       = "avr-binutils";
    version     = "2.35";
    srcs        = [{ filename = "mingw-w64-x86_64-avr-binutils-2.35-3-any.pkg.tar.zst"; sha256 = "69c81338845100effa0d98fba48f88f00fcacef1c943be57b4481c0d097d0158"; }];
  };

  "avr-gcc" = fetch {
    pname       = "avr-gcc";
    version     = "8.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-avr-gcc-8.4.0-4-any.pkg.tar.zst"; sha256 = "41851679825b9e94cbbecfd1e6132d035b34790ee05c283a22b26d7ebcbee665"; }];
    buildInputs = [ avr-binutils gmp isl mpc mpfr ];
  };

  "avr-gdb" = fetch {
    pname       = "avr-gdb";
    version     = "9.2";
    srcs        = [{ filename = "mingw-w64-x86_64-avr-gdb-9.2-3-any.pkg.tar.zst"; sha256 = "99933ecb2f0f1eb959231a9b21747b83bbf6757cf1f1349f95c3aeafe177d98a"; }];
  };

  "avr-libc" = fetch {
    pname       = "avr-libc";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-avr-libc-2.0.0-3-any.pkg.tar.zst"; sha256 = "1baf918ef490559e21acba5754db623cc3e84ca3bef30d2db7f88a0f62232f44"; }];
    buildInputs = [ avr-gcc ];
  };

  "avrdude" = fetch {
    pname       = "avrdude";
    version     = "6.3";
    srcs        = [{ filename = "mingw-w64-x86_64-avrdude-6.3-2-any.pkg.tar.xz"; sha256 = "6a811225b2c8883df427639673511f7046b94221a3179bffa2edfa120741c797"; }];
    buildInputs = [ libftdi libusb libusb-compat-git libelf ];
  };

  "aws-sdk-cpp" = fetch {
    pname       = "aws-sdk-cpp";
    version     = "1.7.365";
    srcs        = [{ filename = "mingw-w64-x86_64-aws-sdk-cpp-1.7.365-2-any.pkg.tar.zst"; sha256 = "b9283c2ab90e2958a5c45b0256159bb04a12520452764df3355d07eb5dad0f20"; }];
  };

  "aztecgen" = fetch {
    pname       = "aztecgen";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-aztecgen-1.0.1-1-any.pkg.tar.xz"; sha256 = "7eaf041f20904a00d4991e0da1ad02c0b2a68cee819f23418f4da5caa0c8d3c4"; }];
  };

  "babl" = fetch {
    pname       = "babl";
    version     = "0.1.82";
    srcs        = [{ filename = "mingw-w64-x86_64-babl-0.1.82-1-any.pkg.tar.zst"; sha256 = "2763c9abe9c7daee1de4d4b827ff171bc041099402dd9bffd9c8182dbec4b7f0"; }];
    buildInputs = [ gcc-libs ];
  };

  "badvpn" = fetch {
    pname       = "badvpn";
    version     = "1.999.130";
    srcs        = [{ filename = "mingw-w64-x86_64-badvpn-1.999.130-2-any.pkg.tar.xz"; sha256 = "2d4e55dc330ba277ec37812372ce2907d78d12bec3e0b0adced493808c47cd05"; }];
    buildInputs = [ glib2 nspr nss openssl ];
  };

  "baobab" = fetch {
    pname       = "baobab";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-baobab-3.38.0-1-any.pkg.tar.zst"; sha256 = "2e33479505ee41a307e61008b90b0a6db1c3144e77734fe0598dbab679b8d062"; }];
    buildInputs = [ gsettings-desktop-schemas gobject-introspection-runtime librsvg ];
  };

  "bc" = fetch {
    pname       = "bc";
    version     = "1.06";
    srcs        = [{ filename = "mingw-w64-x86_64-bc-1.06-2-any.pkg.tar.zst"; sha256 = "de9bb7c0078330891c9fd3d2d1577ce78d010b816ac211ed4de968a2de0df41c"; }];
  };

  "bcunit" = fetch {
    pname       = "bcunit";
    version     = "3.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-bcunit-3.0.2-1-any.pkg.tar.xz"; sha256 = "ebff34bfc19560feb8cc79064b1636782d8ab10b9b1a471239374bb56cd4dd99"; }];
  };

  "benchmark" = fetch {
    pname       = "benchmark";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-benchmark-1.5.0-1-any.pkg.tar.xz"; sha256 = "92de511d53f18142ae84291c5e9d4e0d2e085bc7953ae90bab79cdde4b030e07"; }];
    buildInputs = [ gcc-libs ];
  };

  "binaryen" = fetch {
    pname       = "binaryen";
    version     = "97";
    srcs        = [{ filename = "mingw-w64-x86_64-binaryen-97-1-any.pkg.tar.zst"; sha256 = "5508cfd6035ffc18e0e6c05a0c66b8e5072759ab2beab6613a68334b09bd1469"; }];
  };

  "binutils" = fetch {
    pname       = "binutils";
    version     = "2.35.1";
    srcs        = [{ filename = "mingw-w64-x86_64-binutils-2.35.1-2-any.pkg.tar.zst"; sha256 = "8ed7e547f3e997d8d89fe3f5a4f8db8e757a57621fc857b2a3c306db2bd6e60e"; }];
    buildInputs = [ libiconv zlib ];
  };

  "blender" = fetch {
    pname       = "blender";
    version     = "2.90.1";
    srcs        = [{ filename = "mingw-w64-x86_64-blender-2.90.1-1-any.pkg.tar.zst"; sha256 = "6736162a50f2d9c7dca029084ba536e33a13c97c26b46fb27ba84e1b85459499"; }];
    buildInputs = [ alembic audaspace boost llvm eigen3 embree glew ffmpeg fftw freetype hdf5 intel-tbb libpng libsndfile libtiff lzo2 openal opencollada opencolorio openexr openjpeg2 openimagedenoise openimageio openshadinglanguage openxr-sdk pcre pugixml python python-numpy SDL2 wintab-sdk zlib ];
    broken      = true; # broken dependency audaspace -> python3-numpy
  };

  "blosc" = fetch {
    pname       = "blosc";
    version     = "1.18.1";
    srcs        = [{ filename = "mingw-w64-x86_64-blosc-1.18.1-1-any.pkg.tar.xz"; sha256 = "84480ad885ba4f22e9b89f6c8c8a482181495969b244f671eb8d91c2f434d413"; }];
    buildInputs = [ snappy zstd zlib lz4 ];
  };

  "bmake" = fetch {
    pname       = "bmake";
    version     = "20181221";
    srcs        = [{ filename = "mingw-w64-x86_64-bmake-20181221-6-any.pkg.tar.zst"; sha256 = "9d2ace6cde14ae0635239218714b5b41f73f013fa8edf27d2536f1b05b56c7ae"; }];
    buildInputs = [ binutils python libiconv ];
  };

  "boost" = fetch {
    pname       = "boost";
    version     = "1.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-boost-1.74.0-1-any.pkg.tar.zst"; sha256 = "97231e1e3be07822c8367031073eddcc43089a5fc35533619d0fdfb4d6b32e38"; }];
    buildInputs = [ gcc-libs bzip2 icu zlib ];
  };

  "bootloadhid" = fetch {
    pname       = "bootloadhid";
    version     = "20121208";
    srcs        = [{ filename = "mingw-w64-x86_64-bootloadhid-20121208-1-any.pkg.tar.xz"; sha256 = "940b9cd5ab4be76512976ab092488be28d8f57addf0bd05712d6aed31cb530a8"; }];
  };

  "box2d" = fetch {
    pname       = "box2d";
    version     = "2.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-box2d-2.3.1-2-any.pkg.tar.xz"; sha256 = "ca84725b891d1cdb86f997ad37c56cab2b9bec93e4e88a516374814f4849bd16"; }];
  };

  "breakpad-git" = fetch {
    pname       = "breakpad-git";
    version     = "r1680.70914b2d";
    srcs        = [{ filename = "mingw-w64-x86_64-breakpad-git-r1680.70914b2d-1-any.pkg.tar.xz"; sha256 = "a78ee7b5f75702385ff05f22a5c08be6feffc7c00e32c4060c9e1c91216929fd"; }];
    buildInputs = [ gcc-libs ];
  };

  "breeze-icons-qt5" = fetch {
    pname       = "breeze-icons-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-breeze-icons-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "2545256d3beccd93ca3a84bef013f894e13dc6fb5e7eea773b42e85fb90a0ff2"; }];
    buildInputs = [ qt5 ];
  };

  "brotli" = fetch {
    pname       = "brotli";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-x86_64-brotli-1.0.9-1-any.pkg.tar.zst"; sha256 = "6753f4f355f1a445e0847c9750843042f81392353136b82c50fb3990efd2f076"; }];
    buildInputs = [  ];
  };

  "brotli-testdata" = fetch {
    pname       = "brotli-testdata";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-x86_64-brotli-testdata-1.0.9-1-any.pkg.tar.zst"; sha256 = "0ef7cd5364fa82184ed61b9e1702833e30560e6ced2bdda180e5318146d5d932"; }];
    buildInputs = [ brotli ];
  };

  "bsdfprocessor" = fetch {
    pname       = "bsdfprocessor";
    version     = "1.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-bsdfprocessor-1.2.1-1-any.pkg.tar.xz"; sha256 = "6a4ab49a1e24150ad4be34b8f018134d6f93952fccad930652337d13fc311178"; }];
    buildInputs = [ gcc-libs qt5 OpenSceneGraph ];
  };

  "btyacc" = fetch {
    pname       = "btyacc";
    version     = "3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-btyacc-3.0-1-any.pkg.tar.zst"; sha256 = "48f5cc57d638d2d177f18d935d12c473edf9c155628e76dcdc20ce350f403292"; }];
  };

  "bullet" = fetch {
    pname       = "bullet";
    version     = "2.87";
    srcs        = [{ filename = "mingw-w64-x86_64-bullet-2.87-2-any.pkg.tar.xz"; sha256 = "041518f1ac360c3898424cb415d917cba4cb730dafae95a58fdb0febf189a8bb"; }];
    buildInputs = [ gcc-libs freeglut openvr ];
  };

  "bullet-debug" = fetch {
    pname       = "bullet-debug";
    version     = "2.87";
    srcs        = [{ filename = "mingw-w64-x86_64-bullet-debug-2.87-2-any.pkg.tar.xz"; sha256 = "56163c1830ba9bdb6b6eebd60c35fffb5abe154b64f863c84a7d2c983da067f3"; }];
    buildInputs = [ (assert bullet.version=="2.87"; bullet) ];
  };

  "butler" = fetch {
    pname       = "butler";
    version     = "15.20";
    srcs        = [{ filename = "mingw-w64-x86_64-butler-15.20-1-any.pkg.tar.zst"; sha256 = "d9e3ff48d73a182547e25407aba966f9602fb4db4b76b499d2634162a0f6b24e"; }];
  };

  "bwidget" = fetch {
    pname       = "bwidget";
    version     = "1.9.14";
    srcs        = [{ filename = "mingw-w64-x86_64-bwidget-1.9.14-1-any.pkg.tar.xz"; sha256 = "4a140a3c54316c35bb560420e60fd770f63a1739635d5a476abb1a528fe63449"; }];
    buildInputs = [ tk ];
  };

  "bzip2" = fetch {
    pname       = "bzip2";
    version     = "1.0.8";
    srcs        = [{ filename = "mingw-w64-x86_64-bzip2-1.0.8-1-any.pkg.tar.xz"; sha256 = "cedb53a160aa2aa57e2e231e34e626241db0bf72116d06ed77d0a447c36bf6c6"; }];
    buildInputs = [ gcc-libs ];
  };

  "c-ares" = fetch {
    pname       = "c-ares";
    version     = "1.16.1";
    srcs        = [{ filename = "mingw-w64-x86_64-c-ares-1.16.1-1-any.pkg.tar.zst"; sha256 = "56a5cdd897b6f77baa40e220fd2d2e9bed8d05b82bdee409df4366a219d84e8f"; }];
    buildInputs = [  ];
  };

  "c99-to-c89-git" = fetch {
    pname       = "c99-to-c89-git";
    version     = "r169.b3d496d";
    srcs        = [{ filename = "mingw-w64-x86_64-c99-to-c89-git-r169.b3d496d-1-any.pkg.tar.xz"; sha256 = "e8ea5924072e9e7c45cbe1bebea342bd6964e5024cceae9c4cfc709133f0fa8b"; }];
    buildInputs = [ clang ];
  };

  "ca-certificates" = fetch {
    pname       = "ca-certificates";
    version     = "20200601";
    srcs        = [{ filename = "mingw-w64-x86_64-ca-certificates-20200601-1-any.pkg.tar.zst"; sha256 = "a99b9b1ebc2f52066118d5e1e612e52b004e2294580eb86cd966030d27a6e8aa"; }];
    buildInputs = [ p11-kit ];
  };

  "cairo" = fetch {
    pname       = "cairo";
    version     = "1.17.2";
    srcs        = [{ filename = "mingw-w64-x86_64-cairo-1.17.2-2-any.pkg.tar.zst"; sha256 = "ab2538ff786d4848b7132c426fdf6c4e59745146939e05449fc63742eedaf1c3"; }];
    buildInputs = [ gcc-libs freetype fontconfig lzo2 pixman libpng zlib ];
  };

  "cairomm" = fetch {
    pname       = "cairomm";
    version     = "1.12.2";
    srcs        = [{ filename = "mingw-w64-x86_64-cairomm-1.12.2-2-any.pkg.tar.xz"; sha256 = "3a8cafe51307b2b0b3d4b615db3282a8bc00ad71f3e66394dadf241da4b46694"; }];
    buildInputs = [ self."libsigc++" cairo ];
  };

  "cantarell-fonts" = fetch {
    pname       = "cantarell-fonts";
    version     = "0.201";
    srcs        = [{ filename = "mingw-w64-x86_64-cantarell-fonts-0.201-1-any.pkg.tar.xz"; sha256 = "7a073c9cbd8430c0973a55dd171ef689c9c023281874c252ae4bb278d06098b3"; }];
    buildInputs = [  ];
  };

  "capnproto" = fetch {
    pname       = "capnproto";
    version     = "0.8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-capnproto-0.8.0-3-any.pkg.tar.zst"; sha256 = "5951f3203bc24ae299812e06c72713123072d136b9cc3b01124032d194d6c6b7"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "capstone" = fetch {
    pname       = "capstone";
    version     = "4.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-capstone-4.0.2-1-any.pkg.tar.zst"; sha256 = "300e41794d258c2112e7e953a9aa05e92823650599dd88c1dbed147f20301478"; }];
    buildInputs = [ gcc-libs ];
  };

  "cargo-c" = fetch {
    pname       = "cargo-c";
    version     = "0.6.10";
    srcs        = [{ filename = "mingw-w64-x86_64-cargo-c-0.6.10-1-any.pkg.tar.zst"; sha256 = "2f65be24d1af3193d39c29ca0384b0bf4c90152d55e755fe5b2fb67ad67940b2"; }];
    buildInputs = [ curl openssl libgit2 zlib ];
  };

  "catch" = fetch {
    pname       = "catch";
    version     = "2.13.1";
    srcs        = [{ filename = "mingw-w64-x86_64-catch-2.13.1-1-any.pkg.tar.zst"; sha256 = "4db5c2c7d75fbe00b44b461bae4ef5d3ac9a2e66e26d4e05579509ea92329c5b"; }];
  };

  "ccache" = fetch {
    pname       = "ccache";
    version     = "3.7.9";
    srcs        = [{ filename = "mingw-w64-x86_64-ccache-3.7.9-1-any.pkg.tar.xz"; sha256 = "9e80558ff32fe4fdc7ef458d6fedf02dd505742e20f5fdd45b862b5c98134357"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "cccl" = fetch {
    pname       = "cccl";
    version     = "1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-cccl-1.0-1-any.pkg.tar.xz"; sha256 = "c135b9bb9e333efbfe86a6b24d2580207dc8c0b23ff07058b7c9eb83b6386f1b"; }];
  };

  "cego" = fetch {
    pname       = "cego";
    version     = "2.45.27";
    srcs        = [{ filename = "mingw-w64-x86_64-cego-2.45.27-1-any.pkg.tar.zst"; sha256 = "f21556c037e97551f492e76756d44ca835620432e5b755d46f98bd8a4206a69f"; }];
    buildInputs = [ readline lfcbase lfcxml ];
  };

  "cegui" = fetch {
    pname       = "cegui";
    version     = "0.8.7";
    srcs        = [{ filename = "mingw-w64-x86_64-cegui-0.8.7-1-any.pkg.tar.xz"; sha256 = "f7a9378482ed3bc221310208f76786262af16c5a12101ad210ef71cfb2d9e945"; }];
    buildInputs = [ boost devil expat FreeImage freetype fribidi glew glfw glm irrlicht libepoxy libxml2 libiconv lua51 ogre3d ois openexr pcre python2 SDL2 SDL2_image tinyxml xerces-c zlib ];
    broken      = true; # broken dependency cegui -> FreeImage
  };

  "celt" = fetch {
    pname       = "celt";
    version     = "0.11.3";
    srcs        = [{ filename = "mingw-w64-x86_64-celt-0.11.3-4-any.pkg.tar.xz"; sha256 = "d7f0de323428729be705d1a537acdf49ba649abe7ec52bb5b4f63fe988e8371f"; }];
    buildInputs = [ libogg ];
  };

  "cereal" = fetch {
    pname       = "cereal";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-cereal-1.2.2-1-any.pkg.tar.xz"; sha256 = "9ec478895eef0d5639f36c6e6cb05c2ddca3a537f3c2ea54435ab28ef2afa6a8"; }];
    buildInputs = [ boost ];
  };

  "ceres-solver" = fetch {
    pname       = "ceres-solver";
    version     = "1.14.0";
    srcs        = [{ filename = "mingw-w64-x86_64-ceres-solver-1.14.0-4-any.pkg.tar.xz"; sha256 = "153cae064198de4b5dbf94588ca179508383515ba6905b4d75d84a4dae01ce0e"; }];
    buildInputs = [ eigen3 glog suitesparse ];
  };

  "cfitsio" = fetch {
    pname       = "cfitsio";
    version     = "3.450";
    srcs        = [{ filename = "mingw-w64-x86_64-cfitsio-3.450-2-any.pkg.tar.zst"; sha256 = "0b87549dbd1ab767f51a78a2342f0cb41925fd6b8a4a1f22e7f98435062e2523"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "cgal" = fetch {
    pname       = "cgal";
    version     = "5.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-cgal-5.0.2-2-any.pkg.tar.zst"; sha256 = "f5bcc29df453f7bcefa7190052c8a7c2a57f2601bc391105a4dc882e0352c5cd"; }];
    buildInputs = [ gcc-libs boost gmp mpfr ];
  };

  "cglm" = fetch {
    pname       = "cglm";
    version     = "0.7.8";
    srcs        = [{ filename = "mingw-w64-x86_64-cglm-0.7.8-1-any.pkg.tar.zst"; sha256 = "9900a5486ac5af590fdaa2f414a99b3bb110021bfeff5729712c845381ce7e60"; }];
  };

  "cgns" = fetch {
    pname       = "cgns";
    version     = "4.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-cgns-4.1.1-1-any.pkg.tar.xz"; sha256 = "ea3e6a8e66355fa2cc2a216989781ad98b48bfc5e1a9a79c7d0dbe8ec8848172"; }];
    buildInputs = [ hdf5 ];
  };

  "check" = fetch {
    pname       = "check";
    version     = "0.15.0";
    srcs        = [{ filename = "mingw-w64-x86_64-check-0.15.0-1-any.pkg.tar.zst"; sha256 = "4750ff393edc4cc7a6d11dcaba9692f4bccf7d4e9c52135f010016158872397c"; }];
    buildInputs = [ gcc-libs ];
  };

  "chicken" = fetch {
    pname       = "chicken";
    version     = "4.12.0";
    srcs        = [{ filename = "mingw-w64-x86_64-chicken-4.12.0-1-any.pkg.tar.zst"; sha256 = "11b2ad5703ca6846ddcaaf3738f9ee55b21f3625ee34048df94c05f13ae25813"; }];
  };

  "chipmunk" = fetch {
    pname       = "chipmunk";
    version     = "7.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-chipmunk-7.0.3-1-any.pkg.tar.xz"; sha256 = "a4f93abcf15c6929450d5c0f0f180c591e7680a645479d208c6979f05735a3bc"; }];
  };

  "chromaprint" = fetch {
    pname       = "chromaprint";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-chromaprint-1.5.0-1-any.pkg.tar.zst"; sha256 = "5c3924a334d319d7d312b4f0430fcf4471a48a7e23666a8d6b09774fbae2764a"; }];
  };

  "clang" = fetch {
    pname       = "clang";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-clang-10.0.1-1-any.pkg.tar.zst"; sha256 = "31e85662235df960395bc61c00bfaff11b13f58f65d0b99781a770e5df38f282"; }];
    buildInputs = [ (assert llvm.version=="10.0.1"; llvm) gcc z3 ];
  };

  "clang-analyzer" = fetch {
    pname       = "clang-analyzer";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-clang-analyzer-10.0.1-1-any.pkg.tar.zst"; sha256 = "f11400409392dd06b34cb8eb18b63c9037cbcdb47a75b786cc3839695dd4a641"; }];
    buildInputs = [ (assert clang.version=="10.0.1"; clang) python ];
  };

  "clang-tools-extra" = fetch {
    pname       = "clang-tools-extra";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-clang-tools-extra-10.0.1-1-any.pkg.tar.zst"; sha256 = "98f612e502edd26a37ccc2346c8df0e71870bac1d49aeb4e50d0c450640f62ab"; }];
    buildInputs = [ gcc ];
  };

  "clblast" = fetch {
    pname       = "clblast";
    version     = "1.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-clblast-1.5.1-1-any.pkg.tar.xz"; sha256 = "84159c56be9886e8e0aff5db89feb7a61e4b2d5fd5fa4b256a6c611202c7e992"; }];
  };

  "clucene" = fetch {
    pname       = "clucene";
    version     = "2.3.3.4";
    srcs        = [{ filename = "mingw-w64-x86_64-clucene-2.3.3.4-1-any.pkg.tar.xz"; sha256 = "9a194f9f9d8e73546223bfd07ece7871462174206b42198b7d4702fd374399dd"; }];
    buildInputs = [ boost zlib ];
  };

  "clutter" = fetch {
    pname       = "clutter";
    version     = "1.26.4";
    srcs        = [{ filename = "mingw-w64-x86_64-clutter-1.26.4-1-any.pkg.tar.xz"; sha256 = "a429988fda57206bf2d7373a75c71267f70cbbfb601d6cba1b6e03d3c30d6db7"; }];
    buildInputs = [ atk cogl json-glib gobject-introspection-runtime gtk3 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "clutter-gst" = fetch {
    pname       = "clutter-gst";
    version     = "3.0.27";
    srcs        = [{ filename = "mingw-w64-x86_64-clutter-gst-3.0.27-1-any.pkg.tar.xz"; sha256 = "e7f89fda1dd570bec4ac9e794760a92dfd89222c5ff088b5fb622ee8c827bfbe"; }];
    buildInputs = [ gobject-introspection clutter gstreamer gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "clutter-gtk" = fetch {
    pname       = "clutter-gtk";
    version     = "1.8.4";
    srcs        = [{ filename = "mingw-w64-x86_64-clutter-gtk-1.8.4-1-any.pkg.tar.xz"; sha256 = "903a33368034e8f5870d3d145aeecdb8faaca94f4547a73890eeba2611a80a75"; }];
    buildInputs = [ gtk3 clutter ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "cmake" = fetch {
    pname       = "cmake";
    version     = "3.18.4";
    srcs        = [{ filename = "mingw-w64-x86_64-cmake-3.18.4-1-any.pkg.tar.zst"; sha256 = "f3800b6554cb3dc6ef9876adf5cbc6893aa65ae03d809247637ed3348b74483c"; }];
    buildInputs = [ gcc-libs pkg-config curl expat jsoncpp libarchive libuv rhash zlib ];
  };

  "cmake-doc-qt" = fetch {
    pname       = "cmake-doc-qt";
    version     = "3.18.4";
    srcs        = [{ filename = "mingw-w64-x86_64-cmake-doc-qt-3.18.4-1-any.pkg.tar.zst"; sha256 = "433c7e08e4f8bbd8a86502a1b66b2dac45732b001fb2afb38a3f418b0aaf2190"; }];
  };

  "cmark" = fetch {
    pname       = "cmark";
    version     = "0.29.0";
    srcs        = [{ filename = "mingw-w64-x86_64-cmark-0.29.0-1-any.pkg.tar.xz"; sha256 = "0165df3aea17b57eba6618891958be0502ba507fd16b5d0b4c7fda248ea040ad"; }];
  };

  "cmocka" = fetch {
    pname       = "cmocka";
    version     = "1.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-cmocka-1.1.5-1-any.pkg.tar.xz"; sha256 = "b72e9f9ff05e6381fb394c3392b82e3eaf346d0a76f501902ba6b2f1da8375bb"; }];
  };

  "cninja" = fetch {
    pname       = "cninja";
    version     = "3.7.4";
    srcs        = [{ filename = "mingw-w64-x86_64-cninja-3.7.4-1-any.pkg.tar.zst"; sha256 = "c053df25e3b7b0beda87a03175a17cf572a4d050d4bd47cef8f987382b74e4e4"; }];
    buildInputs = [ cmake clang lld ninja self."libc++" ];
  };

  "codelite" = fetch {
    pname       = "codelite";
    version     = "14.0";
    srcs        = [{ filename = "mingw-w64-x86_64-codelite-14.0-2-any.pkg.tar.zst"; sha256 = "d80364e15ba3fee4139fccbc2a6d77ddbfd7197e3439801abd1dfc6b5f6e2926"; }];
    buildInputs = [ gcc-libs hunspell libssh drmingw clang uchardet wxWidgets sqlite3 ];
  };

  "cogl" = fetch {
    pname       = "cogl";
    version     = "1.22.8";
    srcs        = [{ filename = "mingw-w64-x86_64-cogl-1.22.8-1-any.pkg.tar.zst"; sha256 = "bf396767290abebf82e569f3e973757c513a4c1e3b345d0317ab3c3c68ca82bc"; }];
    buildInputs = [ pango gdk-pixbuf2 gstreamer gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "coin" = fetch {
    pname       = "coin";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-coin-4.0.0-1-any.pkg.tar.zst"; sha256 = "0a8f40eaf855b311d778976bfcf774b2641ec15996f00752298676a9b69dbf2d"; }];
    buildInputs = [ gcc-libs expat fontconfig freetype bzip2 zlib openal ];
  };

  "collada-dom-svn" = fetch {
    pname       = "collada-dom-svn";
    version     = "2.4.1.r889";
    srcs        = [{ filename = "mingw-w64-x86_64-collada-dom-svn-2.4.1.r889-7-any.pkg.tar.xz"; sha256 = "c87fa347a41f57160a86a9ed1bda6a2c291e0a69b502a871333d7b68e28b5444"; }];
    buildInputs = [ bzip2 boost libxml2 pcre zlib ];
  };

  "compiler-rt" = fetch {
    pname       = "compiler-rt";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-compiler-rt-10.0.1-1-any.pkg.tar.zst"; sha256 = "f1799e1bb57167b15cdfa791b83722d60bca22e2ae4fed3e9e7756a4c523ec0e"; }];
    buildInputs = [ (assert llvm.version=="10.0.1"; llvm) ];
  };

  "confuse" = fetch {
    pname       = "confuse";
    version     = "3.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-confuse-3.2.2-1-any.pkg.tar.xz"; sha256 = "38eeffe3dcc1487c5d8a894f306fbb1b1db0df907e9cc892a8cf55f52c045a4f"; }];
    buildInputs = [ gettext ];
  };

  "connect" = fetch {
    pname       = "connect";
    version     = "1.105";
    srcs        = [{ filename = "mingw-w64-x86_64-connect-1.105-1-any.pkg.tar.xz"; sha256 = "f312a6f4678a66c8df69c7f12efe1d9d11b84a4b7c06cf5d19cd73f23f54a2f0"; }];
  };

  "corrade" = fetch {
    pname       = "corrade";
    version     = "2020.06";
    srcs        = [{ filename = "mingw-w64-x86_64-corrade-2020.06-1-any.pkg.tar.zst"; sha256 = "67e16b05b697b266c54948f9359b584798636363c41fa7ce1b6627e54a0ff617"; }];
  };

  "cotire" = fetch {
    pname       = "cotire";
    version     = "1.8.1_3.18";
    srcs        = [{ filename = "mingw-w64-x86_64-cotire-1.8.1_3.18-1-any.pkg.tar.zst"; sha256 = "2ee82faa0034f323b29358bb21f5ea9222dccf9ceb383d98bbbc10153d59b04e"; }];
  };

  "cppcheck" = fetch {
    pname       = "cppcheck";
    version     = "2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-cppcheck-2.2-1-any.pkg.tar.zst"; sha256 = "c1f23492e110f5704715fc3d34ebcc141496630b62f34e7dcb71b4ed43baa095"; }];
    buildInputs = [ pcre ];
  };

  "cppreference-qt" = fetch {
    pname       = "cppreference-qt";
    version     = "20190607";
    srcs        = [{ filename = "mingw-w64-x86_64-cppreference-qt-20190607-1-any.pkg.tar.xz"; sha256 = "674f19faff0ec0e9ede998c1da91808aecd0523062dd9a4c1057501ea4fcf438"; }];
  };

  "cpptest" = fetch {
    pname       = "cpptest";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-cpptest-2.0.0-1-any.pkg.tar.xz"; sha256 = "7cca5cd68b3a7c07d71049cb0e41d3030a22ed215352ba4b6585d9968c9bb339"; }];
  };

  "cppunit" = fetch {
    pname       = "cppunit";
    version     = "1.15.1";
    srcs        = [{ filename = "mingw-w64-x86_64-cppunit-1.15.1-1-any.pkg.tar.xz"; sha256 = "4df5d942b953a2a4177a50c49a228a3f9e4c8053da8ed20e4ed239cb3a60b514"; }];
    buildInputs = [ gcc-libs ];
  };

  "cpputest" = fetch {
    pname       = "cpputest";
    version     = "4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-cpputest-4.0-1-any.pkg.tar.zst"; sha256 = "7c189beebba2f4c1a6aeff62e3edb31032e14a0496017c7985158591510a36ea"; }];
  };

  "creduce" = fetch {
    pname       = "creduce";
    version     = "2.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-creduce-2.10.0-1-any.pkg.tar.xz"; sha256 = "4a86de7684531de66f410175cc4991bd086cf4c96447d50f1e92c10a872c6df4"; }];
    buildInputs = [ perl-Benchmark-Timer perl-Exporter-Lite perl-File-Which perl-Getopt-Tabular perl-Regexp-Common perl-Sys-CPU astyle indent clang ];
    broken      = true; # broken dependency creduce -> perl-Benchmark-Timer
  };

  "crt-git" = fetch {
    pname       = "crt-git";
    version     = "9.0.0.6029.ecb4ff54";
    srcs        = [{ filename = "mingw-w64-x86_64-crt-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "d1b82ac54eb51f0744f0d664bf11c8d87e23fcdf037fa2070beb66720dd01427"; }];
    buildInputs = [ headers-git ];
  };

  "crypto++" = fetch {
    pname       = "crypto++";
    version     = "8.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-crypto++-8.2.0-2-any.pkg.tar.xz"; sha256 = "1074fd701ba84b502655e6ee5daea1e66ddba00dd9c56f4cb96a07713b7de708"; }];
    buildInputs = [ gcc-libs ];
  };

  "csfml" = fetch {
    pname       = "csfml";
    version     = "2.5";
    srcs        = [{ filename = "mingw-w64-x86_64-csfml-2.5-1-any.pkg.tar.xz"; sha256 = "a72a9ee750e3483f016a9bc23bb7295e3c94306764f78205dbad047c5fe5a148"; }];
    buildInputs = [ sfml ];
  };

  "ctags" = fetch {
    pname       = "ctags";
    version     = "5.8";
    srcs        = [{ filename = "mingw-w64-x86_64-ctags-5.8-5-any.pkg.tar.xz"; sha256 = "62398f24a2965cc1d836ca3a6b19d0f2adb2760091d68cc4d2b9983e21cbdb5a"; }];
    buildInputs = [ gcc-libs ];
  };

  "ctpl-git" = fetch {
    pname       = "ctpl-git";
    version     = "0.3.3.391.6dd5c14";
    srcs        = [{ filename = "mingw-w64-x86_64-ctpl-git-0.3.3.391.6dd5c14-1-any.pkg.tar.xz"; sha256 = "a04f4d646761b0b8e98e7c2f6eb2a99384d5eacf39b3298a743c36a8353b979b"; }];
    buildInputs = [ glib2 ];
  };

  "cunit" = fetch {
    pname       = "cunit";
    version     = "2.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-cunit-2.1.3-3-any.pkg.tar.xz"; sha256 = "86cc9f4dac8ac274fba44cfd16ae364fd6b26f273eb644a8e5ec34f08e842099"; }];
  };

  "curl" = fetch {
    pname       = "curl";
    version     = "7.73.0";
    srcs        = [{ filename = "mingw-w64-x86_64-curl-7.73.0-1-any.pkg.tar.zst"; sha256 = "9d1e2af09fba4caf6e2589b6bfd3ec5012cfac2e501012ce40d18d996b538957"; }];
    buildInputs = [ gcc-libs c-ares brotli libidn2 libmetalink libpsl libssh2 zlib ca-certificates openssl nghttp2 ];
  };

  "cvode" = fetch {
    pname       = "cvode";
    version     = "5.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-cvode-5.1.0-1-any.pkg.tar.xz"; sha256 = "20984abc088faf198fc34e4f387554a4b02cc6186ccb3b56a6713eb6616c5015"; }];
  };

  "cxxopts" = fetch {
    pname       = "cxxopts";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-cxxopts-2.2.0-1-any.pkg.tar.zst"; sha256 = "d110a9991be36dc4c84f92ede3ce9e82602c9081ec1350eb1828ed543d99d7a7"; }];
  };

  "cyrus-sasl" = fetch {
    pname       = "cyrus-sasl";
    version     = "2.1.27";
    srcs        = [{ filename = "mingw-w64-x86_64-cyrus-sasl-2.1.27-1-any.pkg.tar.xz"; sha256 = "daeb632df29569f5592317eb8b2ba367db129baf7394a36f61ee489784ea72f6"; }];
    buildInputs = [ gdbm openssl sqlite3 ];
  };

  "cython" = fetch {
    pname       = "cython";
    version     = "0.29.21";
    srcs        = [{ filename = "mingw-w64-x86_64-cython-0.29.21-1-any.pkg.tar.zst"; sha256 = "ec01fbd6aaa23f5d7040ef4c9c21b67db3e8a20aff8f3f171b88e74b6a8d551d"; }];
    buildInputs = [ python-setuptools ];
  };

  "d-feet" = fetch {
    pname       = "d-feet";
    version     = "0.3.15";
    srcs        = [{ filename = "mingw-w64-x86_64-d-feet-0.3.15-2-any.pkg.tar.xz"; sha256 = "b1e06aea1b5b41874757d489c7e77261826286e7af08938ebf5cfd194f33a484"; }];
    buildInputs = [ gtk3 python3-gobject hicolor-icon-theme ];
    broken      = true; # broken dependency d-feet -> python3-gobject
  };

  "daala-git" = fetch {
    pname       = "daala-git";
    version     = "r1505.52bbd43";
    srcs        = [{ filename = "mingw-w64-x86_64-daala-git-r1505.52bbd43-1-any.pkg.tar.xz"; sha256 = "26386065ab9e175700f734dc084bbbd0d960b0b5dba8978272163f57dab102a6"; }];
    buildInputs = [ libogg libpng libjpeg-turbo SDL2 ];
  };

  "darktable" = fetch {
    pname       = "darktable";
    version     = "3.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-darktable-3.0.1-1-any.pkg.tar.xz"; sha256 = "68afd90e5dc3fd8e6af7ee86cb34881870507dedbbfc9fdaf5d970a1ff9155fa"; }];
    buildInputs = [ dbus-glib drmingw exiv2 flickcurl graphicsmagick gtk3 gmic iso-codes lcms2 lensfun libexif libgphoto2 libsecret libsoup libwebp libxslt lua openexr openjpeg2 osm-gps-map pugixml sqlite3 zlib ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "dav1d" = fetch {
    pname       = "dav1d";
    version     = "0.7.1";
    srcs        = [{ filename = "mingw-w64-x86_64-dav1d-0.7.1-1-any.pkg.tar.zst"; sha256 = "482790275d3ad97766f63d37df0178faf0f33a8e73902fd246f7c381bd882e74"; }];
    buildInputs = [ gcc-libs ];
  };

  "db" = fetch {
    pname       = "db";
    version     = "6.0.19";
    srcs        = [{ filename = "mingw-w64-x86_64-db-6.0.19-4-any.pkg.tar.zst"; sha256 = "b47ec8d046afc532fb42734e243ed916674b1c4a47eab25cb5ee558219ee7131"; }];
    buildInputs = [ gcc-libs ];
  };

  "dbus" = fetch {
    pname       = "dbus";
    version     = "1.12.18";
    srcs        = [{ filename = "mingw-w64-x86_64-dbus-1.12.18-1-any.pkg.tar.zst"; sha256 = "ad49ba195e0199b2a858e6492a1cdb288558da650e41e62c7a7f695be02bbf10"; }];
    buildInputs = [ glib2 expat ];
  };

  "dbus-c++" = fetch {
    pname       = "dbus-c++";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-dbus-c++-0.9.0-1-any.pkg.tar.xz"; sha256 = "d7b3b0436646fc665554ae19b90f6c04b33791c4d5616fc261504d4d63fc3b26"; }];
    buildInputs = [ dbus ];
  };

  "dbus-glib" = fetch {
    pname       = "dbus-glib";
    version     = "0.110";
    srcs        = [{ filename = "mingw-w64-x86_64-dbus-glib-0.110-1-any.pkg.tar.xz"; sha256 = "a95cab0e82342a157dbcbcdc9608cb6a467acc7f799b57db16892a2fd29b7c3a"; }];
    buildInputs = [ glib2 dbus expat ];
  };

  "dcadec" = fetch {
    pname       = "dcadec";
    version     = "0.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-dcadec-0.2.0-2-any.pkg.tar.xz"; sha256 = "1b4f2c6cde60d873587ede50aab828ca92751d45c31de5c6e55164d4e39fddf0"; }];
    buildInputs = [ gcc-libs ];
  };

  "dcraw" = fetch {
    pname       = "dcraw";
    version     = "9.28";
    srcs        = [{ filename = "mingw-w64-x86_64-dcraw-9.28-1-any.pkg.tar.xz"; sha256 = "7619bc1a17d13e35e77f4020aacb54983b5ae96288f6f98bd034b2035230be62"; }];
    buildInputs = [ lcms2 jasper libjpeg-turbo ];
  };

  "desktop-file-utils" = fetch {
    pname       = "desktop-file-utils";
    version     = "0.26";
    srcs        = [{ filename = "mingw-w64-x86_64-desktop-file-utils-0.26-1-any.pkg.tar.zst"; sha256 = "4dbaae31c5f4289240d6f5d914429f7af38061e9987d01e3fc76709350b2bdf1"; }];
    buildInputs = [ glib2 gtk3 libxml2 ];
  };

  "devcon-git" = fetch {
    pname       = "devcon-git";
    version     = "r233.8b17cf3";
    srcs        = [{ filename = "mingw-w64-x86_64-devcon-git-r233.8b17cf3-1-any.pkg.tar.xz"; sha256 = "46f674979a203b19a016970002adf5fc4f9a40d87f3881cc7b37fb1a308fdd06"; }];
  };

  "devil" = fetch {
    pname       = "devil";
    version     = "1.8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-devil-1.8.0-6-any.pkg.tar.zst"; sha256 = "dd841d0436baf828cb750aceb56d47dd62591665379b654c0e13973b346f0b55"; }];
    buildInputs = [ freeglut jasper lcms2 libmng libpng libsquish libtiff openexr zlib ];
  };

  "dfu-programmer" = fetch {
    pname       = "dfu-programmer";
    version     = "0.7.2";
    srcs        = [{ filename = "mingw-w64-x86_64-dfu-programmer-0.7.2-2-any.pkg.tar.zst"; sha256 = "eacaef11732ef7d8bc99d4eeb79e5ca2ece018c46fbea5825b70182de628dc2d"; }];
    buildInputs = [ libusb-win32 ];
  };

  "dfu-util" = fetch {
    pname       = "dfu-util";
    version     = "0.9";
    srcs        = [{ filename = "mingw-w64-x86_64-dfu-util-0.9-1-any.pkg.tar.zst"; sha256 = "6cb3c9d2f015761e7b2e5a053209c845816625e898c210fc6e8587374775e880"; }];
    buildInputs = [ libusb ];
  };

  "diffutils" = fetch {
    pname       = "diffutils";
    version     = "3.6";
    srcs        = [{ filename = "mingw-w64-x86_64-diffutils-3.6-2-any.pkg.tar.xz"; sha256 = "7571813b2e0baa0b355aedbb8dc823ab0a56a7a9c72c8e58eb0764fff0428562"; }];
    buildInputs = [ libsigsegv libwinpthread-git gettext ];
  };

  "discount" = fetch {
    pname       = "discount";
    version     = "2.2.6";
    srcs        = [{ filename = "mingw-w64-x86_64-discount-2.2.6-1-any.pkg.tar.xz"; sha256 = "2a6fd8739dcaf5601d177037ea4219f48cb32e5fb5389cb1a06e6d9471926b37"; }];
  };

  "distorm" = fetch {
    pname       = "distorm";
    version     = "3.4.1";
    srcs        = [{ filename = "mingw-w64-x86_64-distorm-3.4.1-3-any.pkg.tar.xz"; sha256 = "c17d6dac7bbb806cf11828af84f9e9d5bb15f9f206f6e6b9f25861cece3d3849"; }];
  };

  "djview" = fetch {
    pname       = "djview";
    version     = "4.10.6";
    srcs        = [{ filename = "mingw-w64-x86_64-djview-4.10.6-1-any.pkg.tar.xz"; sha256 = "6688cccc4fdf2c25eabbd8735cb54dd1931403a523e2beba775a857c8379e168"; }];
    buildInputs = [ djvulibre gcc-libs qt5 libtiff ];
  };

  "djvulibre" = fetch {
    pname       = "djvulibre";
    version     = "3.5.27";
    srcs        = [{ filename = "mingw-w64-x86_64-djvulibre-3.5.27-4-any.pkg.tar.xz"; sha256 = "e31532f2063bc28fbf8f06d298db76d633d0d83b28486ab8c51586651c675c62"; }];
    buildInputs = [ gcc-libs libjpeg libiconv libtiff zlib ];
  };

  "dlfcn" = fetch {
    pname       = "dlfcn";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-dlfcn-1.2.0-1-any.pkg.tar.xz"; sha256 = "d77e3cf574d4862bd080ae0fb772f0c0295c9dfc74b75de377f6b470297766f0"; }];
    buildInputs = [ gcc-libs ];
  };

  "dlib" = fetch {
    pname       = "dlib";
    version     = "19.20";
    srcs        = [{ filename = "mingw-w64-x86_64-dlib-19.20-1-any.pkg.tar.zst"; sha256 = "c98b793a262df967efdfb04d79512b4dec34b29bc9833d74ff97f03e5088eb70"; }];
    buildInputs = [ lapack giflib libpng libjpeg-turbo openblas lapack fftw sqlite3 ];
  };

  "dmake" = fetch {
    pname       = "dmake";
    version     = "4.12.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-dmake-4.12.2.2-1-any.pkg.tar.xz"; sha256 = "27b2beff57911faddacc300509c7a9cbedc029294a9779674cc8c3c06fb0b8b9"; }];
  };

  "dnscrypt-proxy" = fetch {
    pname       = "dnscrypt-proxy";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-dnscrypt-proxy-1.6.0-2-any.pkg.tar.xz"; sha256 = "cec0ec5fa25f27aa87284b30d627e6a37541fcdcb4241a99224fbfe48b5a62ff"; }];
    buildInputs = [ libsodium ldns ];
  };

  "dnssec-anchors" = fetch {
    pname       = "dnssec-anchors";
    version     = "20130320";
    srcs        = [{ filename = "mingw-w64-x86_64-dnssec-anchors-20130320-1-any.pkg.tar.zst"; sha256 = "11d1871d37aca1f2288fe27420457250be6280ef3c70a0efa618fc61515e786b"; }];
  };

  "docbook-dsssl" = fetch {
    pname       = "docbook-dsssl";
    version     = "1.79";
    srcs        = [{ filename = "mingw-w64-x86_64-docbook-dsssl-1.79-1-any.pkg.tar.xz"; sha256 = "f5f40c476a9f1170c40e5b63216cc0fc79fb94b0966edef69c9540c0333f6f59"; }];
    buildInputs = [ sgml-common perl ];
  };

  "docbook-mathml" = fetch {
    pname       = "docbook-mathml";
    version     = "1.1CR1";
    srcs        = [{ filename = "mingw-w64-x86_64-docbook-mathml-1.1CR1-2-any.pkg.tar.xz"; sha256 = "015b172627dcc94cae8fa01e23dc9906f35256d64c5b7d58726bacfe7a70df44"; }];
    buildInputs = [ libxml2 ];
  };

  "docbook-sgml" = fetch {
    pname       = "docbook-sgml";
    version     = "4.5";
    srcs        = [{ filename = "mingw-w64-x86_64-docbook-sgml-4.5-1-any.pkg.tar.xz"; sha256 = "d6929fbd14ddce62682a589ecf0ca38c0ed3a37c36bfda467f2d940c79b627a6"; }];
    buildInputs = [ sgml-common ];
  };

  "docbook-sgml31" = fetch {
    pname       = "docbook-sgml31";
    version     = "3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-docbook-sgml31-3.1-1-any.pkg.tar.xz"; sha256 = "36355dfbf02f1af40ac93ba402b579fe66a5d1a1601b5ec450c6107897b81df1"; }];
    buildInputs = [ sgml-common ];
  };

  "docbook-xml" = fetch {
    pname       = "docbook-xml";
    version     = "1~4.5";
    srcs        = [{ filename = "mingw-w64-x86_64-docbook-xml-1~4.5-1-any.pkg.tar.xz"; sha256 = "79912ee906c7a17946d2d4e679f9dd60f393e359983df5a95c6df214dc99d7ac"; }];
    buildInputs = [ libxml2 ];
  };

  "docbook-xsl" = fetch {
    pname       = "docbook-xsl";
    version     = "1.79.2";
    srcs        = [{ filename = "mingw-w64-x86_64-docbook-xsl-1.79.2-6-any.pkg.tar.xz"; sha256 = "eccc5ab04537605a935b18eaa31674acf2d191ba05ef6f972bddb43c9da3702b"; }];
    buildInputs = [ libxml2 libxslt docbook-xml ];
  };

  "docbook5-xml" = fetch {
    pname       = "docbook5-xml";
    version     = "5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-docbook5-xml-5.1-1-any.pkg.tar.xz"; sha256 = "89166d9ff1ef7d3806ad3cdf14ea5ae0456101699fe07631c528862a2bacd6bc"; }];
    buildInputs = [ libxml2 ];
  };

  "double-conversion" = fetch {
    pname       = "double-conversion";
    version     = "3.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-double-conversion-3.1.5-1-any.pkg.tar.xz"; sha256 = "9ed0839109d9fa9e343c8f79b7853703a9e212d5e9d6cfc1476637ce0cbbf7d4"; }];
    buildInputs = [ gcc-libs ];
  };

  "doxygen" = fetch {
    pname       = "doxygen";
    version     = "1.8.18";
    srcs        = [{ filename = "mingw-w64-x86_64-doxygen-1.8.18-1-any.pkg.tar.zst"; sha256 = "d03d618891f07e77ffb763955f5ef1c148ac59cce7fdef205c7618e0f177de5d"; }];
    buildInputs = [ gcc-libs libiconv sqlite3 xapian-core ];
  };

  "dragon" = fetch {
    pname       = "dragon";
    version     = "1.5.2";
    srcs        = [{ filename = "mingw-w64-x86_64-dragon-1.5.2-1-any.pkg.tar.xz"; sha256 = "7f470a05fbf8010e88d92fb701887b457ec2e2367f78ed2b584c135b0e7ed0b2"; }];
    buildInputs = [ lfcbase ];
  };

  "drmingw" = fetch {
    pname       = "drmingw";
    version     = "0.9.2";
    srcs        = [{ filename = "mingw-w64-x86_64-drmingw-0.9.2-1-any.pkg.tar.xz"; sha256 = "038af7acd15551fa252db4359275e50a5d07c3a35dd6bc0a9b3ba3fffc1d04a4"; }];
    buildInputs = [ gcc-libs ];
  };

  "dsdp" = fetch {
    pname       = "dsdp";
    version     = "5.8";
    srcs        = [{ filename = "mingw-w64-x86_64-dsdp-5.8-1-any.pkg.tar.xz"; sha256 = "90f8ca228aa4af4e1121313a193057cd8f147d26de97c3520448f5b24dd2bbb9"; }];
    buildInputs = [ openblas ];
  };

  "ducible" = fetch {
    pname       = "ducible";
    version     = "1.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-ducible-1.2.1-1-any.pkg.tar.xz"; sha256 = "29e4ca06b55305719125764342b8bcfc7b1482607a92ff74991a3eaac3d74863"; }];
    buildInputs = [ gcc-libs ];
  };

  "dumb" = fetch {
    pname       = "dumb";
    version     = "2.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-dumb-2.0.3-1-any.pkg.tar.xz"; sha256 = "7e323314d712d4051929a7153f385a1d078d54479b043e221273aa6d18a8456d"; }];
  };

  "dwarfstack" = fetch {
    pname       = "dwarfstack";
    version     = "2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-dwarfstack-2.1-1-any.pkg.tar.xz"; sha256 = "efe007d41615abeb862860a2d0401161709dff07b232034099f1fbe88cd9aff8"; }];
  };

  "editorconfig-core-c" = fetch {
    pname       = "editorconfig-core-c";
    version     = "0.12.3";
    srcs        = [{ filename = "mingw-w64-x86_64-editorconfig-core-c-0.12.3-2-any.pkg.tar.xz"; sha256 = "13959a270e9e30a50de6d8d67969c02048b43788caff1c74cd78904d19e85a7c"; }];
    buildInputs = [ pcre2 ];
  };

  "editrights" = fetch {
    pname       = "editrights";
    version     = "1.03";
    srcs        = [{ filename = "mingw-w64-x86_64-editrights-1.03-3-any.pkg.tar.xz"; sha256 = "625b265dba8eb96f2550d3b0e59b78414244fecd1331a23e12ff081c94e81c9c"; }];
  };

  "eigen3" = fetch {
    pname       = "eigen3";
    version     = "3.3.7";
    srcs        = [{ filename = "mingw-w64-x86_64-eigen3-3.3.7-2-any.pkg.tar.zst"; sha256 = "86f49b7568102cbeebe911a9996da93b6b0096bcbf64ec3c21d76d963968ea20"; }];
    buildInputs = [  ];
  };

  "emacs" = fetch {
    pname       = "emacs";
    version     = "27.1";
    srcs        = [{ filename = "mingw-w64-x86_64-emacs-27.1-1-any.pkg.tar.zst"; sha256 = "6ab8d11797770ee0744e6b4f255b242f5b5888c36d6bb7096378ee41254aaebc"; }];
    buildInputs = [ universal-ctags-git zlib xpm-nox harfbuzz gnutls libwinpthread-git ];
  };

  "embree" = fetch {
    pname       = "embree";
    version     = "3.12.1";
    srcs        = [{ filename = "mingw-w64-x86_64-embree-3.12.1-1-any.pkg.tar.zst"; sha256 = "085306dd30031fe7ae12830f9b24f2f38f8f774590f4bfcd0c1b9bfb8cc012fc"; }];
    buildInputs = [ intel-tbb glfw ];
  };

  "enca" = fetch {
    pname       = "enca";
    version     = "1.19";
    srcs        = [{ filename = "mingw-w64-x86_64-enca-1.19-1-any.pkg.tar.xz"; sha256 = "c1779aedefbdb1f4f2db554dce3bd1a6221f579e3aa2de6f1f95de76537d61ab"; }];
    buildInputs = [ recode ];
  };

  "enchant" = fetch {
    pname       = "enchant";
    version     = "2.2.11";
    srcs        = [{ filename = "mingw-w64-x86_64-enchant-2.2.11-1-any.pkg.tar.zst"; sha256 = "bbda12bb6a73e3b599745675fc7072da9a49cbc871657689c63edfab72d11d3a"; }];
    buildInputs = [ aspell hunspell gcc-libs glib2 libvoikko ];
  };

  "enet" = fetch {
    pname       = "enet";
    version     = "1.3.15";
    srcs        = [{ filename = "mingw-w64-x86_64-enet-1.3.15-1-any.pkg.tar.xz"; sha256 = "d3843b945b34d4e3ba23f80c6bc48e71ce87a1aa02cafb7f1fc06f3892c7a7c8"; }];
  };

  "ensmallen" = fetch {
    pname       = "ensmallen";
    version     = "2.12.1";
    srcs        = [{ filename = "mingw-w64-x86_64-ensmallen-2.12.1-1-any.pkg.tar.zst"; sha256 = "7e5a98984ae60001b3734633d8d088473670dbd8cdbd094a2401e6582cb5f82c"; }];
    buildInputs = [ gcc-libs armadillo openblas ];
  };

  "eog" = fetch {
    pname       = "eog";
    version     = "3.36.2";
    srcs        = [{ filename = "mingw-w64-x86_64-eog-3.36.2-2-any.pkg.tar.zst"; sha256 = "5a15d25c330556ec49c660e9809d8d7a3ebaab2b30660d4e7def6546cbace688"; }];
    buildInputs = [ adwaita-icon-theme gettext gtk3 gdk-pixbuf2 gobject-introspection-runtime gsettings-desktop-schemas zlib libexif libjpeg-turbo libpeas librsvg libxml2 shared-mime-info ];
  };

  "eog-plugins" = fetch {
    pname       = "eog-plugins";
    version     = "3.26.5";
    srcs        = [{ filename = "mingw-w64-x86_64-eog-plugins-3.26.5-1-any.pkg.tar.xz"; sha256 = "791e7a88fecd579ca253b168e2a885e98beccc9edcd05f71da8efda94589f1e9"; }];
    buildInputs = [ eog libchamplain libexif libgdata python ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "evince" = fetch {
    pname       = "evince";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-evince-3.38.0-1-any.pkg.tar.zst"; sha256 = "41734e80c5b3f235774b0771b781f6ec0b46d480f8c5a7bf190d2638779e09ed"; }];
    buildInputs = [ glib2 cairo djvulibre gsettings-desktop-schemas appstream-glib gspell gst-plugins-base gtk3 hicolor-icon-theme libarchive libgxps libspectre libtiff nss poppler zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "exiv2" = fetch {
    pname       = "exiv2";
    version     = "0.27.3";
    srcs        = [{ filename = "mingw-w64-x86_64-exiv2-0.27.3-1-any.pkg.tar.zst"; sha256 = "e7d08f359bd9e03899b053a2924fdbfd0999193c8110def40911653cc34b51d1"; }];
    buildInputs = [ expat curl libiconv zlib ];
  };

  "expat" = fetch {
    pname       = "expat";
    version     = "2.2.10";
    srcs        = [{ filename = "mingw-w64-x86_64-expat-2.2.10-1-any.pkg.tar.zst"; sha256 = "50cd229f8aed5ed4b0a066715a17d028f2898571975b24ac08dda70e8ad1d0bb"; }];
    buildInputs = [  ];
  };

  "extra-cmake-modules" = fetch {
    pname       = "extra-cmake-modules";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-extra-cmake-modules-5.74.0-1-any.pkg.tar.zst"; sha256 = "fd603515b7481f74f13acd45cbe7f6bb3bef57af79d7613c7ca9226cb0a4441d"; }];
    buildInputs = [ cmake png2ico ];
  };

  "f2c" = fetch {
    pname       = "f2c";
    version     = "20200425";
    srcs        = [{ filename = "mingw-w64-x86_64-f2c-20200425-1-any.pkg.tar.zst"; sha256 = "9813a3e252c6da21c0d1b6c03279e40bd42e62a149ff6a366f98fb88d0499db7"; }];
  };

  "faac" = fetch {
    pname       = "faac";
    version     = "1.30";
    srcs        = [{ filename = "mingw-w64-x86_64-faac-1.30-1-any.pkg.tar.xz"; sha256 = "f9f84016aba0f822e710ae1d0e4b6f56dc495000b1e40979f3d9436ab5909004"; }];
  };

  "faad2" = fetch {
    pname       = "faad2";
    version     = "2.9.2";
    srcs        = [{ filename = "mingw-w64-x86_64-faad2-2.9.2-1-any.pkg.tar.zst"; sha256 = "8c99b6cfbcc4d7219906af24769554d179fc068584f92dc403bfef65d885c0e3"; }];
    buildInputs = [ gcc-libs ];
  };

  "fann" = fetch {
    pname       = "fann";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-fann-2.2.0-2-any.pkg.tar.xz"; sha256 = "67b9fad842bbcfea0fcf22616da4bc076b5dfd5d10810b784a0780b5ff511ccb"; }];
  };

  "farstream" = fetch {
    pname       = "farstream";
    version     = "0.2.8";
    srcs        = [{ filename = "mingw-w64-x86_64-farstream-0.2.8-2-any.pkg.tar.xz"; sha256 = "d662099b748d64ef337acf2b8b5afc419730ae095baed137950e6b9b480da61d"; }];
    buildInputs = [ gst-plugins-base libnice ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "fastjar" = fetch {
    pname       = "fastjar";
    version     = "0.98";
    srcs        = [{ filename = "mingw-w64-x86_64-fastjar-0.98-1-any.pkg.tar.xz"; sha256 = "9fd9397961fd40ff2275648fa620194d3387ae0e5a08dae380a0ab6789860f02"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "fcrackzip" = fetch {
    pname       = "fcrackzip";
    version     = "1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-fcrackzip-1.0-1-any.pkg.tar.xz"; sha256 = "7a37115dad04fcd21334999e675797ad2b037256629df444ae78ab00f0c9e84a"; }];
  };

  "fdk-aac" = fetch {
    pname       = "fdk-aac";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-fdk-aac-2.0.1-1-any.pkg.tar.xz"; sha256 = "ff5945dc313c0c2957dd023034029091c1b0b26d99d288a99820b14271b54e61"; }];
  };

  "ffcall" = fetch {
    pname       = "ffcall";
    version     = "2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-ffcall-2.2-1-any.pkg.tar.xz"; sha256 = "a49280a5b342d7660b7b727d2bda3ca395219ede3eb149608cb32bf7205672bc"; }];
  };

  "ffmpeg" = fetch {
    pname       = "ffmpeg";
    version     = "4.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-ffmpeg-4.3.1-1-any.pkg.tar.zst"; sha256 = "eb9f349f72febb305d7d221d0faf8ebd46b1550c15f72f6fee6da142824dc749"; }];
    buildInputs = [ aom bzip2 celt fontconfig dav1d gnutls gsm lame libass libbluray libcaca libmfx libmodplug libtheora libvorbis libvpx libwebp libxml2 openal opencore-amr openjpeg2 opus rtmpdump-git SDL2 speex srt vulkan wavpack x264-git x265 xvidcore zlib ];
  };

  "ffms2" = fetch {
    pname       = "ffms2";
    version     = "2.23.1";
    srcs        = [{ filename = "mingw-w64-x86_64-ffms2-2.23.1-1-any.pkg.tar.xz"; sha256 = "2654d150dd4dc4952da97b6e48cc896e5cec3f68856ef502a1b9ae30099c73e3"; }];
    buildInputs = [ ffmpeg ];
  };

  "fftw" = fetch {
    pname       = "fftw";
    version     = "3.3.8";
    srcs        = [{ filename = "mingw-w64-x86_64-fftw-3.3.8-2-any.pkg.tar.zst"; sha256 = "36384da215968ab3b60f4e22adab45974cc3417b9b83f70a7c703a729acedb4b"; }];
    buildInputs = [ gcc-libs ];
  };

  "fgsl" = fetch {
    pname       = "fgsl";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-fgsl-1.3.0-1-any.pkg.tar.zst"; sha256 = "c3412bf3bb94164ba6dedf70eea72c49e582b04e7bd945621fd2690988cb7a2e"; }];
    buildInputs = [ gcc-libs gcc-libgfortran (assert stdenvNoCC.lib.versionAtLeast gsl.version "2.4"; gsl) ];
  };

  "field3d" = fetch {
    pname       = "field3d";
    version     = "1.7.3";
    srcs        = [{ filename = "mingw-w64-x86_64-field3d-1.7.3-2-any.pkg.tar.zst"; sha256 = "801be8f164d653172a6db24217a84c3bc362776c8de28d5138cd972fa1917229"; }];
    buildInputs = [ boost hdf5 openexr ];
  };

  "file" = fetch {
    pname       = "file";
    version     = "5.39";
    srcs        = [{ filename = "mingw-w64-x86_64-file-5.39-1-any.pkg.tar.zst"; sha256 = "1ad4c4af69828d521836bd422c07443e5d5a6a97b00805a5c09d33ced722b990"; }];
    buildInputs = [ bzip2 libsystre xz zlib ];
  };

  "firebird2-git" = fetch {
    pname       = "firebird2-git";
    version     = "2.5.9.27149.9f6840e90c";
    srcs        = [{ filename = "mingw-w64-x86_64-firebird2-git-2.5.9.27149.9f6840e90c-3-any.pkg.tar.zst"; sha256 = "38c65dae8f5aafcb3f865bd8ae1de44e6527407d8bff013ed662fcac7296a671"; }];
    buildInputs = [ gcc-libs icu zlib ];
  };

  "flac" = fetch {
    pname       = "flac";
    version     = "1.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-flac-1.3.3-1-any.pkg.tar.xz"; sha256 = "2faca3082bccd30335ba1fafd0bf30922db65b44b732d600eeebe9e87afc56f9"; }];
    buildInputs = [ libogg gcc-libs ];
  };

  "flatbuffers" = fetch {
    pname       = "flatbuffers";
    version     = "1.12.0";
    srcs        = [{ filename = "mingw-w64-x86_64-flatbuffers-1.12.0-1-any.pkg.tar.xz"; sha256 = "8ca228b47a5fd0543fb95fb5a3334999890879652c7a8b7f443e501056883bef"; }];
    buildInputs = [ libsystre ];
  };

  "flexdll" = fetch {
    pname       = "flexdll";
    version     = "0.34";
    srcs        = [{ filename = "mingw-w64-x86_64-flexdll-0.34-2-any.pkg.tar.xz"; sha256 = "0e18d10991eba90e61c0868b9791f3f5c8c70fde45e19133d886335f44227bfa"; }];
  };

  "flickcurl" = fetch {
    pname       = "flickcurl";
    version     = "1.26";
    srcs        = [{ filename = "mingw-w64-x86_64-flickcurl-1.26-2-any.pkg.tar.xz"; sha256 = "a04aed4e194546b48717a6e0f07f8961456affcff38a8bdff276faecf1909617"; }];
    buildInputs = [ curl libxml2 ];
  };

  "flif" = fetch {
    pname       = "flif";
    version     = "0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-flif-0.3-1-any.pkg.tar.xz"; sha256 = "0b477f94c3e1dfe3edfba3edb97f4c5c1cfa911509fec5ac025b402d120addb7"; }];
    buildInputs = [ zlib libpng SDL2 ];
  };

  "fltk" = fetch {
    pname       = "fltk";
    version     = "1.3.5";
    srcs        = [{ filename = "mingw-w64-x86_64-fltk-1.3.5-1-any.pkg.tar.xz"; sha256 = "d99d4ba13597f8962f476411a66033b4252e2354f60e1ca99bcf664732f82e00"; }];
    buildInputs = [ expat gcc-libs gettext libiconv libpng libjpeg-turbo zlib ];
  };

  "fluidsynth" = fetch {
    pname       = "fluidsynth";
    version     = "2.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-fluidsynth-2.1.5-1-any.pkg.tar.zst"; sha256 = "21f837480f9f78469b8191e385e1977c97783da7f79b7a30ba8057aea0310fd3"; }];
    buildInputs = [ gcc-libs glib2 libsndfile portaudio readline ];
  };

  "fmt" = fetch {
    pname       = "fmt";
    version     = "7.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-fmt-7.0.3-1-any.pkg.tar.zst"; sha256 = "420ef29a08490afe1435655cc81dc5a0a602d980b849185e096f7c72e3c72e08"; }];
    buildInputs = [ gcc-libs ];
  };

  "fontconfig" = fetch {
    pname       = "fontconfig";
    version     = "2.13.92";
    srcs        = [{ filename = "mingw-w64-x86_64-fontconfig-2.13.92-2-any.pkg.tar.zst"; sha256 = "b7f1ff7cc3ca57f6559f0299c735df501341c085869a0c053e98fcb4a7394f41"; }];
    buildInputs = [ gcc-libs (assert stdenvNoCC.lib.versionAtLeast expat.version "2.1.0"; expat) (assert stdenvNoCC.lib.versionAtLeast freetype.version "2.3.11"; freetype) (assert stdenvNoCC.lib.versionAtLeast bzip2.version "1.0.6"; bzip2) libiconv ];
  };

  "fossil" = fetch {
    pname       = "fossil";
    version     = "2.10";
    srcs        = [{ filename = "mingw-w64-x86_64-fossil-2.10-2-any.pkg.tar.xz"; sha256 = "799b189b0a9da0156b7c1ea10aa39881127d3aa33da0701ce05fdeb2f87131e8"; }];
    buildInputs = [ openssl readline sqlite3 zlib ];
  };

  "fox" = fetch {
    pname       = "fox";
    version     = "1.6.57";
    srcs        = [{ filename = "mingw-w64-x86_64-fox-1.6.57-1-any.pkg.tar.xz"; sha256 = "d0ca1c1c1804c14b51494245d60acf4cd4fcf3752ac6f61d3d7d5013d0c691b3"; }];
    buildInputs = [ gcc-libs libtiff zlib libpng libjpeg-turbo ];
  };

  "freealut" = fetch {
    pname       = "freealut";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-freealut-1.1.0-1-any.pkg.tar.xz"; sha256 = "f9f6458adf037d4b584751e3d75afe106fbc670d10031eb555c4827174f21077"; }];
    buildInputs = [ openal ];
  };

  "freeglut" = fetch {
    pname       = "freeglut";
    version     = "3.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-freeglut-3.2.1-1-any.pkg.tar.xz"; sha256 = "856aa45e82cc1ba5ec6a82f1fe19ea65265ea375bcbc2165740be5b420244f39"; }];
    buildInputs = [  ];
  };

  "freeimage" = fetch {
    pname       = "freeimage";
    version     = "3.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-freeimage-3.18.0-5-any.pkg.tar.zst"; sha256 = "072a78b5623bd03d6511f2aec164dc506816190086282e09aeb3088c9a995954"; }];
    buildInputs = [ gcc-libs jxrlib libjpeg-turbo libpng libtiff libraw libwebp openjpeg2 openexr ];
  };

  "freetds" = fetch {
    pname       = "freetds";
    version     = "1.2.5";
    srcs        = [{ filename = "mingw-w64-x86_64-freetds-1.2.5-1-any.pkg.tar.zst"; sha256 = "4ea12c39ebecba84955729b82173b06f913fe1abb41a3ac16913c055b9b669d2"; }];
    buildInputs = [ gcc-libs openssl libiconv ];
  };
  freetype = freetype-and-harfbuzz;

  "fribidi" = fetch {
    pname       = "fribidi";
    version     = "1.0.10";
    srcs        = [{ filename = "mingw-w64-x86_64-fribidi-1.0.10-1-any.pkg.tar.zst"; sha256 = "bd557c1298a0a96927bccdc270db757a0a4c8f39beddeba31598f5763aa1a1d7"; }];
    buildInputs = [  ];
  };

  "ftgl" = fetch {
    pname       = "ftgl";
    version     = "2.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-ftgl-2.4.0-1-any.pkg.tar.xz"; sha256 = "49103aeca84b986a36988d57bed41738d6326d8b215d6ddc7a6f2d1271b2cf9b"; }];
    buildInputs = [ gcc-libs freetype ];
  };

  "gavl" = fetch {
    pname       = "gavl";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gavl-1.4.0-1-any.pkg.tar.xz"; sha256 = "5290ae3d00150d586ee2e1f795bb17b6b60fda90bf51c61306aba42040c7d661"; }];
    buildInputs = [ gcc-libs libpng ];
  };

  "gc" = fetch {
    pname       = "gc";
    version     = "8.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-gc-8.0.4-1-any.pkg.tar.xz"; sha256 = "119ede8734602c07380830722f90f52dbfb6f7ce9d71bcfce82d903c8fbf9d68"; }];
    buildInputs = [ gcc-libs libatomic_ops ];
  };

  "gcc" = fetch {
    pname       = "gcc";
    version     = "10.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gcc-10.2.0-4-any.pkg.tar.zst"; sha256 = "1bc13d094cc5097249e6921b153b06684431c444272a91c6ee40a495bab57e71"; }];
    buildInputs = [ binutils crt-git headers-git isl libiconv mpc (assert gcc-libs.version=="10.2.0"; gcc-libs) windows-default-manifest winpthreads-git zlib zstd ];
  };

  "gcc-ada" = fetch {
    pname       = "gcc-ada";
    version     = "10.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gcc-ada-10.2.0-4-any.pkg.tar.zst"; sha256 = "df42b7b96187185158cea4e1cdf3cd7fc64a6917c857d8e98cff6a59ca8e9dc0"; }];
    buildInputs = [ (assert gcc.version=="10.2.0"; gcc) ];
  };

  "gcc-fortran" = fetch {
    pname       = "gcc-fortran";
    version     = "10.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gcc-fortran-10.2.0-4-any.pkg.tar.zst"; sha256 = "556f689834935a64b5a5776e4d28fd13cfcfba50e5498c217ef0b15a447e9d01"; }];
    buildInputs = [ (assert gcc.version=="10.2.0"; gcc) (assert gcc-libgfortran.version=="10.2.0"; gcc-libgfortran) ];
  };

  "gcc-libgfortran" = fetch {
    pname       = "gcc-libgfortran";
    version     = "10.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gcc-libgfortran-10.2.0-4-any.pkg.tar.zst"; sha256 = "dc2a82820fcca2776c0c9e06cd985f8da1e88524b6d5455001831320442938af"; }];
    buildInputs = [ (assert gcc-libs.version=="10.2.0"; gcc-libs) ];
  };

  "gcc-libs" = fetch {
    pname       = "gcc-libs";
    version     = "10.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gcc-libs-10.2.0-4-any.pkg.tar.zst"; sha256 = "64b9e8cd79cd0f29337f699e8eb27bb85d4dbfdbe6a3d881d4afe1f6dd29dafd"; }];
    buildInputs = [ gmp mpc mpfr libwinpthread-git ];
  };

  "gcc-objc" = fetch {
    pname       = "gcc-objc";
    version     = "10.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gcc-objc-10.2.0-4-any.pkg.tar.zst"; sha256 = "47b7e8ba6df23863f79b8b4001f8eea67b700b192542c78b6d250abf40cb9509"; }];
    buildInputs = [ (assert gcc.version=="10.2.0"; gcc) ];
  };

  "gdal" = fetch {
    pname       = "gdal";
    version     = "3.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-gdal-3.1.3-1-any.pkg.tar.zst"; sha256 = "d760108624aeb384aab087026716ce8cf7d443fb9ad52f8cda78ed5617644df5"; }];
    buildInputs = [ cfitsio self."crypto++" curl expat geos giflib hdf5 jasper json-c libfreexl libgeotiff libiconv libjpeg libkml libpng libspatialite libtiff libwebp libxml2 netcdf openjpeg2 pcre poppler postgresql proj qhull-git sqlite3 xerces-c xz ];
  };

  "gdb" = fetch {
    pname       = "gdb";
    version     = "9.2";
    srcs        = [{ filename = "mingw-w64-x86_64-gdb-9.2-3-any.pkg.tar.zst"; sha256 = "ad586fb663e79a2b6aa90f9074f6bfbdd9ab8d1efb19c968953fa471513be129"; }];
    buildInputs = [ expat libiconv ncurses python readline xxhash zlib ];
  };

  "gdbm" = fetch {
    pname       = "gdbm";
    version     = "1.18.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gdbm-1.18.1-2-any.pkg.tar.xz"; sha256 = "5c3d62c979bb87c6ff2b348bc38ab9069483963677fd70e77fabcda4938fdd01"; }];
    buildInputs = [ gcc-libs gettext libiconv ];
  };

  "gdcm" = fetch {
    pname       = "gdcm";
    version     = "3.0.8";
    srcs        = [{ filename = "mingw-w64-x86_64-gdcm-3.0.8-1-any.pkg.tar.zst"; sha256 = "ee58e755bfcf5b889fc95a161d2223d5c952ad65b6c999ccc545bfd5f052e575"; }];
    buildInputs = [ expat gcc-libs lcms2 libxml2 libxslt json-c openssl poppler zlib ];
  };

  "gdk-pixbuf2" = fetch {
    pname       = "gdk-pixbuf2";
    version     = "2.40.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gdk-pixbuf2-2.40.0-1-any.pkg.tar.xz"; sha256 = "5535af0849ac4d966dd7a91f664e5067040d8ae013f5a7898db8ebb024f82154"; }];
    buildInputs = [ gcc-libs (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.37.2"; glib2) jasper libjpeg-turbo libpng libtiff ];
  };

  "gdl" = fetch {
    pname       = "gdl";
    version     = "3.34.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gdl-3.34.0-1-any.pkg.tar.xz"; sha256 = "6a414bb111504c8e1d3197b3f48a8dc5f4d25e2b123e6025fe8e1b5b81357f99"; }];
    buildInputs = [ gtk3 libxml2 ];
  };

  "gdl2" = fetch {
    pname       = "gdl2";
    version     = "2.31.2";
    srcs        = [{ filename = "mingw-w64-x86_64-gdl2-2.31.2-2-any.pkg.tar.xz"; sha256 = "758beb1f7f4ae87895fdecd377131380d90cb75d0418f4d7c67fea951ddc8769"; }];
    buildInputs = [ gtk2 libxml2 ];
  };

  "gdlmm2" = fetch {
    pname       = "gdlmm2";
    version     = "2.30.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gdlmm2-2.30.0-2-any.pkg.tar.xz"; sha256 = "86cc428c4a46c3a0795f743f31d7ce031662344cbe0faea2c741a033e98b1445"; }];
    buildInputs = [ gtk2 libxml2 ];
  };

  "geany" = fetch {
    pname       = "geany";
    version     = "1.36.0";
    srcs        = [{ filename = "mingw-w64-x86_64-geany-1.36.0-2-any.pkg.tar.xz"; sha256 = "f821d4c8b90d939bda164ce34ff89ef0e2adbf7d21ef71908eee90708f3b1516"; }];
    buildInputs = [ gtk3 adwaita-icon-theme python3 ];
  };

  "geany-plugins" = fetch {
    pname       = "geany-plugins";
    version     = "1.36.0";
    srcs        = [{ filename = "mingw-w64-x86_64-geany-plugins-1.36.0-1-any.pkg.tar.xz"; sha256 = "caf3f5516b9e25d08c7ac5b807875ce5ebeeb4cb293be26f2a19c97f984ca8e5"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast geany.version "1.36.0"; geany) discount gtkspell3 ctpl-git gpgme lua51 gtk3 libgit2 hicolor-icon-theme ];
  };

  "gedit" = fetch {
    pname       = "gedit";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gedit-3.38.0-1-any.pkg.tar.zst"; sha256 = "33b73c4aae6c3672c58e20b9191f8964a45a1da86a4ab4f8357cd439d3d8fea5"; }];
    buildInputs = [ adwaita-icon-theme appstream-glib gsettings-desktop-schemas gtksourceview4 gtk3 libpeas python-gobject gspell gobject-introspection-runtime tepl5 ];
  };

  "gedit-plugins" = fetch {
    pname       = "gedit-plugins";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gedit-plugins-3.38.0-1-any.pkg.tar.zst"; sha256 = "1bfde66e4f18899cbddb357fb92813cc153988e145c48dcb13268d30936cfbdf"; }];
    buildInputs = [ gedit libgit2-glib libpeas ];
  };

  "gegl" = fetch {
    pname       = "gegl";
    version     = "0.4.26";
    srcs        = [{ filename = "mingw-w64-x86_64-gegl-0.4.26-1-any.pkg.tar.zst"; sha256 = "75f59d051c5f19c59adb86d31ccf041371cd36adc21ed3304ebbc7623866e04d"; }];
    buildInputs = [ babl cairo exiv2 gexiv2 gcc-libs gdk-pixbuf2 gettext glib2 jasper json-glib libjpeg libpng libraw librsvg libspiro libwebp lcms lensfun openexr pango SDL2 suitesparse ];
  };

  "geocode-glib" = fetch {
    pname       = "geocode-glib";
    version     = "3.26.2";
    srcs        = [{ filename = "mingw-w64-x86_64-geocode-glib-3.26.2-1-any.pkg.tar.xz"; sha256 = "05b356284c0f881aa245bbfba0d15b9755d2c769addf9901309bce5e630a0095"; }];
    buildInputs = [ glib2 json-glib libsoup ];
  };

  "geoip" = fetch {
    pname       = "geoip";
    version     = "1.6.12";
    srcs        = [{ filename = "mingw-w64-x86_64-geoip-1.6.12-1-any.pkg.tar.xz"; sha256 = "5c6e90b89860caef238e340b5795a94986f3aa30943b84a7688f595f1ff06001"; }];
    buildInputs = [ geoip2-database zlib ];
  };

  "geoip2-database" = fetch {
    pname       = "geoip2-database";
    version     = "20190624";
    srcs        = [{ filename = "mingw-w64-x86_64-geoip2-database-20190624-1-any.pkg.tar.xz"; sha256 = "94ade1e14d200a793fc832a3a5f1e21eeaccdf343a145988ff8aa3292c45bba6"; }];
    buildInputs = [  ];
  };

  "geos" = fetch {
    pname       = "geos";
    version     = "3.8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-geos-3.8.0-1-any.pkg.tar.xz"; sha256 = "8a6bd3c76b80f29abacc71364490545283949f236908c182f42914a521e852d5"; }];
    buildInputs = [  ];
  };

  "gettext" = fetch {
    pname       = "gettext";
    version     = "0.19.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gettext-0.19.8.1-9-any.pkg.tar.zst"; sha256 = "84c4a02a3477536c0d57714c6b326facda561d66958904ebf879ed69f7dc44a9"; }];
    buildInputs = [ expat gcc-libs libiconv ];
  };

  "gexiv2" = fetch {
    pname       = "gexiv2";
    version     = "0.12.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gexiv2-0.12.1-1-any.pkg.tar.zst"; sha256 = "cc7c46895450c4e6fb9cd150b27597eb48678cbd1d35217fd8b2b68662985008"; }];
    buildInputs = [ glib2 exiv2 ];
  };

  "gflags" = fetch {
    pname       = "gflags";
    version     = "2.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-gflags-2.2.2-2-any.pkg.tar.xz"; sha256 = "5388f3ce376f030273a44f92573e446d8a2cc4c900da9a6b98d3f73ec5145ab7"; }];
    buildInputs = [  ];
  };

  "ghex" = fetch {
    pname       = "ghex";
    version     = "3.18.4";
    srcs        = [{ filename = "mingw-w64-x86_64-ghex-3.18.4-2-any.pkg.tar.zst"; sha256 = "c1a224595ebf209bfba74debe9bc66b9981e86c284499535b8248a5ba9dfa1e9"; }];
    buildInputs = [ gtk3 ];
  };

  "ghostscript" = fetch {
    pname       = "ghostscript";
    version     = "9.50";
    srcs        = [{ filename = "mingw-w64-x86_64-ghostscript-9.50-1-any.pkg.tar.xz"; sha256 = "c0f197f6d8ce25bcf94372eb92ad8714732a439e36012073719683fd058f267f"; }];
    buildInputs = [ dbus expat freetype fontconfig gdk-pixbuf2 jbig2dec libiconv libidn libpaper libpng libjpeg libtiff openjpeg2 zlib ];
  };

  "giflib" = fetch {
    pname       = "giflib";
    version     = "5.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-giflib-5.2.1-1-any.pkg.tar.xz"; sha256 = "1a32e364f3fde775536ea6f1b683c1d1a167c29d867b499a4c05121415573f66"; }];
    buildInputs = [ gcc-libs ];
  };

  "gimp" = fetch {
    pname       = "gimp";
    version     = "2.10.22";
    srcs        = [{ filename = "mingw-w64-x86_64-gimp-2.10.22-1-any.pkg.tar.zst"; sha256 = "fe1a1395bcc16b32a2e1a4d19b0c7f7eee10ec8a2944f7c5622c4831f2fe85c2"; }];
    buildInputs = [ babl curl dbus-glib drmingw gegl gexiv2 ghostscript glib-networking hicolor-icon-theme iso-codes jasper lcms2 libexif libheif libmng libmypaint librsvg libwmf mypaint-brushes openexr openjpeg2 poppler python2-pygtk python2-gobject2 xpm-nox ];
  };

  "gimp-ufraw" = fetch {
    pname       = "gimp-ufraw";
    version     = "0.22";
    srcs        = [{ filename = "mingw-w64-x86_64-gimp-ufraw-0.22-2-any.pkg.tar.xz"; sha256 = "438ee6d513cefa541e9c72fd6cd880b6331eacc5260c8a0ae73d6ea4d2c0eb1c"; }];
    buildInputs = [ bzip2 cfitsio exiv2 gtkimageview lcms lensfun ];
  };

  "git-lfs" = fetch {
    pname       = "git-lfs";
    version     = "2.11.0";
    srcs        = [{ filename = "mingw-w64-x86_64-git-lfs-2.11.0-1-any.pkg.tar.zst"; sha256 = "2385a8f3bca1c7f6e04a162854522730767ec666472113c99934bb7282271cf9"; }];
    buildInputs = [ git ];
    broken      = true; # broken dependency git-lfs -> git
  };

  "git-repo" = fetch {
    pname       = "git-repo";
    version     = "0.4.20";
    srcs        = [{ filename = "mingw-w64-x86_64-git-repo-0.4.20-1-any.pkg.tar.xz"; sha256 = "5f346855c72bed5cc3cbf0947baa67c07a02c14bab7b1999ed26a575615eb8b8"; }];
    buildInputs = [ python3 ];
  };

  "gitg" = fetch {
    pname       = "gitg";
    version     = "3.32.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gitg-3.32.1-2-any.pkg.tar.xz"; sha256 = "ee3012397298fbabd67dc3a3dc0e2e1210d2defcc453db782681c02795c0d4dc"; }];
    buildInputs = [ adwaita-icon-theme gtksourceview3 libpeas enchant iso-codes python3-gobject gsettings-desktop-schemas libsoup libsecret gtkspell3 libgit2-glib libdazzle libgee ];
    broken      = true; # broken dependency gitg -> python3-gobject
  };

  "gl2ps" = fetch {
    pname       = "gl2ps";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-x86_64-gl2ps-1.4.2-1-any.pkg.tar.zst"; sha256 = "b700a4127e082cea37ff4c0e8ec30f3710a3eeb282bad7e1154c0ae0db02bc80"; }];
    buildInputs = [ libpng ];
  };

  "glade" = fetch {
    pname       = "glade";
    version     = "3.38.1";
    srcs        = [{ filename = "mingw-w64-x86_64-glade-3.38.1-1-any.pkg.tar.zst"; sha256 = "fe0ee976cb8ce1626c18c16dc0dd4593db400b337ee51ca9fc30fed10d86239f"; }];
    buildInputs = [ gtk3 libxml2 adwaita-icon-theme ];
  };

  "glade-gtk2" = fetch {
    pname       = "glade-gtk2";
    version     = "3.8.6";
    srcs        = [{ filename = "mingw-w64-x86_64-glade-gtk2-3.8.6-3-any.pkg.tar.zst"; sha256 = "5a930452d41e382d546eccde5fbeac6675884f8901d045bc23317a255bee0bb4"; }];
    buildInputs = [ gtk2 libxml2 ];
  };

  "glbinding" = fetch {
    pname       = "glbinding";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-glbinding-3.1.0-2-any.pkg.tar.xz"; sha256 = "f6ae93b5154fc497cf49a11a3886be2e89fac082c46d005213ae2f3aff5571d5"; }];
    buildInputs = [ gcc-libs ];
  };

  "glew" = fetch {
    pname       = "glew";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-glew-2.2.0-2-any.pkg.tar.zst"; sha256 = "9be5a12083609168906b34f122bf15135a442bbaf69949b9b2b02774b20971ab"; }];
  };

  "glfw" = fetch {
    pname       = "glfw";
    version     = "3.3.2";
    srcs        = [{ filename = "mingw-w64-x86_64-glfw-3.3.2-1-any.pkg.tar.xz"; sha256 = "eb815af2446bb4486a04f282fc875fec990420d95b04d1f61cde8bc58000f46b"; }];
    buildInputs = [ gcc-libs ];
  };

  "glib-networking" = fetch {
    pname       = "glib-networking";
    version     = "2.66.0";
    srcs        = [{ filename = "mingw-w64-x86_64-glib-networking-2.66.0-1-any.pkg.tar.zst"; sha256 = "f7a1c352b9f245adb5e647c51e019ee7714fe59aa8560d3b9d1143db219a03e4"; }];
    buildInputs = [ gcc-libs gettext glib2 gnutls libproxy openssl gsettings-desktop-schemas ];
  };

  "glib2" = fetch {
    pname       = "glib2";
    version     = "2.66.1";
    srcs        = [{ filename = "mingw-w64-x86_64-glib2-2.66.1-2-any.pkg.tar.zst"; sha256 = "595eea39d9352c025f9d34b19f60eec9f4b4100dcf2c02204f4d91027e985927"; }];
    buildInputs = [ gcc-libs gettext pcre libffi zlib python ];
  };

  "glibmm" = fetch {
    pname       = "glibmm";
    version     = "2.64.2";
    srcs        = [{ filename = "mingw-w64-x86_64-glibmm-2.64.2-1-any.pkg.tar.xz"; sha256 = "93106a81ede79aed6684454ed95e4c3b3beceffa2c412011a7a882df53255783"; }];
    buildInputs = [ self."libsigc++" glib2 ];
  };

  "glm" = fetch {
    pname       = "glm";
    version     = "0.9.9.8";
    srcs        = [{ filename = "mingw-w64-x86_64-glm-0.9.9.8-1-any.pkg.tar.xz"; sha256 = "ee48dee1e51be7f9b65d2f35f7743fa2aa739c3925d7c60c3ae148c62e82d87a"; }];
    buildInputs = [ gcc-libs ];
  };

  "global" = fetch {
    pname       = "global";
    version     = "6.6.4";
    srcs        = [{ filename = "mingw-w64-x86_64-global-6.6.4-1-any.pkg.tar.xz"; sha256 = "d705896df5a7be4a4628553a406cd9217b783ee30b7676d9de22584ee2a99a46"; }];
  };

  "globjects" = fetch {
    pname       = "globjects";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-globjects-1.1.0-1-any.pkg.tar.xz"; sha256 = "8444e7eb64ed1d2645d69efbe8384543728a2dcb7dd16492bd05b99a8f9957c1"; }];
    buildInputs = [ gcc-libs glbinding glm ];
  };

  "glog" = fetch {
    pname       = "glog";
    version     = "0.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-glog-0.4.0-2-any.pkg.tar.xz"; sha256 = "4f2af0adb897adc9cbc1bd1de52058c89ac27fbfc73c844bc229eb7fe35d24ab"; }];
    buildInputs = [ gflags libunwind ];
  };

  "glpk" = fetch {
    pname       = "glpk";
    version     = "4.65";
    srcs        = [{ filename = "mingw-w64-x86_64-glpk-4.65-2-any.pkg.tar.zst"; sha256 = "cbb9dcffc8cb3f40c0f6a7e1a7bd02a731466edb6d0622d6a11d2f66d4c12881"; }];
    buildInputs = [ gmp ];
  };

  "glsl-optimizer-git" = fetch {
    pname       = "glsl-optimizer-git";
    version     = "r66914.9a2852138d";
    srcs        = [{ filename = "mingw-w64-x86_64-glsl-optimizer-git-r66914.9a2852138d-1-any.pkg.tar.xz"; sha256 = "e61622d0cd8682c30deaa1faf85d889f64c95b8f65591f8824dc7f9f69d4881a"; }];
  };

  "glslang" = fetch {
    pname       = "glslang";
    version     = "8.13.3743";
    srcs        = [{ filename = "mingw-w64-x86_64-glslang-8.13.3743-2-any.pkg.tar.zst"; sha256 = "247634e972b881e90ec28a2833168e13edc211f76f7bf0f131f946129d2be448"; }];
    buildInputs = [ gcc-libs ];
  };

  "gmic" = fetch {
    pname       = "gmic";
    version     = "2.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gmic-2.9.0-3-any.pkg.tar.zst"; sha256 = "505d70fc9ec55f708a2029d4fd7ad5d21baad3451a4464ffb88907f11c793e7d"; }];
    buildInputs = [ fftw graphicsmagick libpng libjpeg libtiff curl openexr opencv ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "gmime" = fetch {
    pname       = "gmime";
    version     = "3.2.7";
    srcs        = [{ filename = "mingw-w64-x86_64-gmime-3.2.7-1-any.pkg.tar.xz"; sha256 = "a66cfdb7f7f223f3b96651b26c34e9cb29e666a13999e78dcf1fe1eaa407853d"; }];
    buildInputs = [ glib2 gpgme libiconv ];
  };

  "gmp" = fetch {
    pname       = "gmp";
    version     = "6.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gmp-6.2.0-3-any.pkg.tar.zst"; sha256 = "47c0699d13c662096d645201418c164713a16e051b249a75320c9b4fa9a6ce96"; }];
    buildInputs = [  ];
  };

  "gnome-calculator" = fetch {
    pname       = "gnome-calculator";
    version     = "3.38.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gnome-calculator-3.38.1-1-any.pkg.tar.zst"; sha256 = "bdafc79c520573e5721b336a47ad6bda484ef669a7140aa0cdc2675fac774f7e"; }];
    buildInputs = [ glib2 gtk3 gtksourceview4 gsettings-desktop-schemas libsoup mpfr ];
  };

  "gnome-common" = fetch {
    pname       = "gnome-common";
    version     = "3.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gnome-common-3.18.0-1-any.pkg.tar.xz"; sha256 = "06885b109036840a681921282255c6442b60d9d4b3dd14144644a8b70d62993d"; }];
  };

  "gnome-latex" = fetch {
    pname       = "gnome-latex";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gnome-latex-3.38.0-1-any.pkg.tar.zst"; sha256 = "0c4ebf78781550d4ee4468db065c0bad4dac97c0c6d43ca5c519d94c067b5b58"; }];
    buildInputs = [ gsettings-desktop-schemas gtk3 gtksourceview4 gspell tepl5 libgee ];
  };

  "gnucobol" = fetch {
    pname       = "gnucobol";
    version     = "3.1rc1";
    srcs        = [{ filename = "mingw-w64-x86_64-gnucobol-3.1rc1-2-any.pkg.tar.zst"; sha256 = "95d522f81e27f16f6ffbe8ff71567b5e24adf4dad775b3f820b5c586a0b095cc"; }];
    buildInputs = [ gcc gmp gettext ncurses db ];
  };

  "gnupg" = fetch {
    pname       = "gnupg";
    version     = "2.2.23";
    srcs        = [{ filename = "mingw-w64-x86_64-gnupg-2.2.23-1-any.pkg.tar.zst"; sha256 = "aabe8a29e8c9901db96efae527c56bdcf0be3d570404fb04f6516f30372667d3"; }];
    buildInputs = [ adns bzip2 curl gnutls libksba libgcrypt libassuan libsystre libusb-compat-git npth readline sqlite3 zlib ];
  };

  "gnuplot" = fetch {
    pname       = "gnuplot";
    version     = "5.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gnuplot-5.4.0-2-any.pkg.tar.zst"; sha256 = "634da43d4bb370edd7093a31b3acc63341726da3fb2866b11f52df05474e64c0"; }];
    buildInputs = [ cairo gnutls libcaca libcerf libgd pango readline wxWidgets ];
  };

  "gnutls" = fetch {
    pname       = "gnutls";
    version     = "3.6.15";
    srcs        = [{ filename = "mingw-w64-x86_64-gnutls-3.6.15-2-any.pkg.tar.zst"; sha256 = "e5da40faa56aa6be8b35fded31a718f6388512b4ea465b3c39920b5bbe3195bf"; }];
    buildInputs = [ gcc-libs gmp libidn2 libsystre libtasn1 (assert stdenvNoCC.lib.versionAtLeast nettle.version "3.6"; nettle) (assert stdenvNoCC.lib.versionAtLeast p11-kit.version "0.23.1"; p11-kit) libunistring zlib ];
  };

  "go" = fetch {
    pname       = "go";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-x86_64-go-1.14.4-1-any.pkg.tar.zst"; sha256 = "9e78753e7d7232f0796b2ac2406f9da09924f06ed0396e20ee0459a51f24ebad"; }];
  };

  "gobject-introspection" = fetch {
    pname       = "gobject-introspection";
    version     = "1.66.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gobject-introspection-1.66.1-1-any.pkg.tar.zst"; sha256 = "158d9f840f5f2435f4982b41e80d642bfee3f2f88dbd1fc44ccb2d65d544b250"; }];
    buildInputs = [ (assert gobject-introspection-runtime.version=="1.66.1"; gobject-introspection-runtime) pkg-config python python-mako ];
  };

  "gobject-introspection-runtime" = fetch {
    pname       = "gobject-introspection-runtime";
    version     = "1.66.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gobject-introspection-runtime-1.66.1-1-any.pkg.tar.zst"; sha256 = "f8b0bcb86c342b016ff223cea4b489da21467210601ae14e64842319b9cf7ad2"; }];
    buildInputs = [ glib2 libffi ];
  };

  "goocanvas" = fetch {
    pname       = "goocanvas";
    version     = "2.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-goocanvas-2.0.4-4-any.pkg.tar.xz"; sha256 = "64a35cc885cf8f4c1b373ee5eb78b186a65e34204c8ebfdb79d36970a070afdb"; }];
    buildInputs = [ gtk3 ];
  };

  "gperf" = fetch {
    pname       = "gperf";
    version     = "3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gperf-3.1-1-any.pkg.tar.xz"; sha256 = "33499f19eb175232448a5296c1046179c4157cf82c541d507a731aaf01208f38"; }];
    buildInputs = [ gcc-libs ];
  };

  "gpgme" = fetch {
    pname       = "gpgme";
    version     = "1.14.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gpgme-1.14.0-1-any.pkg.tar.zst"; sha256 = "090a2b3b02736391fcb1969b703bdee93855228f39ad1cd0703e8dc69492a47b"; }];
    buildInputs = [ glib2 gnupg libassuan libgpg-error npth ];
  };

  "gphoto2" = fetch {
    pname       = "gphoto2";
    version     = "2.5.23";
    srcs        = [{ filename = "mingw-w64-x86_64-gphoto2-2.5.23-2-any.pkg.tar.zst"; sha256 = "228dc0371222c40f9966e6cfcf04ae25f676e4732b3af17cb1a45573181b6ee1"; }];
    buildInputs = [ libgphoto2 readline popt ];
  };

  "gplugin" = fetch {
    pname       = "gplugin";
    version     = "0.29.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gplugin-0.29.0-1-any.pkg.tar.xz"; sha256 = "2c8086aa2b8932ca007628d6eaef2df64c5b06d324e16d30db5816b8b8ae41c1"; }];
    buildInputs = [ gtk3 ];
  };

  "gprbuild" = fetch {
    pname       = "gprbuild";
    version     = "2021.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gprbuild-2021.0.0-1-any.pkg.tar.zst"; sha256 = "6d1e60fd8437d795d1af00e5d1651752d68e651434c8dea1764c0c4ce395b6d6"; }];
    buildInputs = [ gcc-ada xmlada ];
  };

  "gprbuild-bootstrap-git" = fetch {
    pname       = "gprbuild-bootstrap-git";
    version     = "2021.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gprbuild-bootstrap-git-2021.0.0-1-any.pkg.tar.zst"; sha256 = "52342552aff41e819bb48242c4e2372b21e00a674d54214aa74559a1b71330cb"; }];
    buildInputs = [ gcc-libs ];
  };

  "gr" = fetch {
    pname       = "gr";
    version     = "0.52.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gr-0.52.0-1-any.pkg.tar.zst"; sha256 = "55e3a9d677d059a79eb63e05717fc67fd5de8912dd755d94b5bb486c2d92bc9a"; }];
    buildInputs = [ bzip2 cairo ffmpeg freetype glfw libjpeg libpng libtiff qhull-git qt5 zlib ];
  };

  "grantlee" = fetch {
    pname       = "grantlee";
    version     = "5.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-grantlee-5.2.0-1-any.pkg.tar.xz"; sha256 = "2b5d999856c42f84e5a2af586dc6e4056df4ca9b9a5b86c0c595b8940b06012a"; }];
  };

  "graphene" = fetch {
    pname       = "graphene";
    version     = "1.10.2";
    srcs        = [{ filename = "mingw-w64-x86_64-graphene-1.10.2-1-any.pkg.tar.zst"; sha256 = "7c53ffc890e86da0cf6244131a2e56c4bf4b9e67e7aeffafb84930cab1218db6"; }];
    buildInputs = [ glib2 ];
  };

  "graphicsmagick" = fetch {
    pname       = "graphicsmagick";
    version     = "1.3.35";
    srcs        = [{ filename = "mingw-w64-x86_64-graphicsmagick-1.3.35-1-any.pkg.tar.xz"; sha256 = "7007959324bd1ea3b4c24c2a312101bdbf7f1063494bcfd7f1d803d9f06555d8"; }];
    buildInputs = [ bzip2 fontconfig freetype gcc-libs glib2 jasper jbigkit lcms2 libxml2 libpng libtiff libwebp libwmf libtool libwinpthread-git xz zlib zstd ];
  };

  "graphite2" = fetch {
    pname       = "graphite2";
    version     = "1.3.14";
    srcs        = [{ filename = "mingw-w64-x86_64-graphite2-1.3.14-2-any.pkg.tar.zst"; sha256 = "4f966997d444387cd89df22b444b21eadfd158c702cc347b45423d6f7266e952"; }];
    buildInputs = [ gcc-libs ];
  };

  "graphviz" = fetch {
    pname       = "graphviz";
    version     = "2.40.1";
    srcs        = [{ filename = "mingw-w64-x86_64-graphviz-2.40.1-13-any.pkg.tar.zst"; sha256 = "807d775fb03834ce3a5117f42893bf31f3ae4b023b45fd690825509ea391d1bc"; }];
    buildInputs = [ cairo devil expat freetype glib2 gtk2 gtkglext fontconfig freeglut libglade libgd libpng libsystre libwebp gts pango poppler zlib libtool ];
  };

  "grep" = fetch {
    pname       = "grep";
    version     = "3.4";
    srcs        = [{ filename = "mingw-w64-x86_64-grep-3.4-1-any.pkg.tar.zst"; sha256 = "51f145a0e5b143e729dae72f5d718707f67d4a0cb75c68d2bc9a55834ed78a32"; }];
    buildInputs = [ pcre ];
  };

  "groonga" = fetch {
    pname       = "groonga";
    version     = "10.0.7";
    srcs        = [{ filename = "mingw-w64-x86_64-groonga-10.0.7-1-any.pkg.tar.zst"; sha256 = "c0d34e76991d20dd0940dc8921ce296ad9dbd990c85e18f1821ae317183c31df"; }];
    buildInputs = [ arrow luajit lz4 msgpack-c onigmo openssl pcre rapidjson mecab mecab-naist-jdic zeromq zlib zstd ];
    broken      = true; # broken dependency arrow -> python3-numpy
  };

  "grpc" = fetch {
    pname       = "grpc";
    version     = "1.29.1";
    srcs        = [{ filename = "mingw-w64-x86_64-grpc-1.29.1-1-any.pkg.tar.zst"; sha256 = "46195ed0e62eb9a42a6c48a972ff2c20b217b3b74b3f5861ec877cc7de748ee4"; }];
    buildInputs = [ gcc-libs c-ares gflags openssl (assert stdenvNoCC.lib.versionAtLeast protobuf.version "3.5.0"; protobuf) zlib ];
  };

  "gsasl" = fetch {
    pname       = "gsasl";
    version     = "1.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gsasl-1.8.1-1-any.pkg.tar.xz"; sha256 = "b3e3cafbcb7800b855e0fbe58df1102b4ab479d132d02c0aef233b32b220a190"; }];
    buildInputs = [ gss gnutls libidn libgcrypt libntlm readline ];
  };

  "gsettings-desktop-schemas" = fetch {
    pname       = "gsettings-desktop-schemas";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gsettings-desktop-schemas-3.38.0-1-any.pkg.tar.zst"; sha256 = "80c9080170568232d7a3210caec3032f85b272ae0df625e430116d242e22b81c"; }];
    buildInputs = [ glib2 adobe-source-code-pro-fonts cantarell-fonts ];
  };

  "gsfonts" = fetch {
    pname       = "gsfonts";
    version     = "20180524";
    srcs        = [{ filename = "mingw-w64-x86_64-gsfonts-20180524-2-any.pkg.tar.xz"; sha256 = "f7f045ded25e649af91cb6a2e0140f49fa64b46a6c0014c1c096e3c476919115"; }];
  };

  "gsl" = fetch {
    pname       = "gsl";
    version     = "2.6";
    srcs        = [{ filename = "mingw-w64-x86_64-gsl-2.6-1-any.pkg.tar.xz"; sha256 = "a527fb7e4b4b1e3634417579fe4533d92ec468377375d73a70a54ef95fd54612"; }];
    buildInputs = [  ];
  };

  "gsm" = fetch {
    pname       = "gsm";
    version     = "1.0.19";
    srcs        = [{ filename = "mingw-w64-x86_64-gsm-1.0.19-1-any.pkg.tar.xz"; sha256 = "cfe8da9aed33e2a6f4edb1afe6dd3b881a549b6c198251708d1722cccef5ace4"; }];
    buildInputs = [  ];
  };

  "gsoap" = fetch {
    pname       = "gsoap";
    version     = "2.8.101";
    srcs        = [{ filename = "mingw-w64-x86_64-gsoap-2.8.101-1-any.pkg.tar.xz"; sha256 = "9763396ac7c96e871edf394c13fa2aa14f9ac40cfe71fa755f9da1ba2bc6e333"; }];
  };

  "gspell" = fetch {
    pname       = "gspell";
    version     = "1.8.4";
    srcs        = [{ filename = "mingw-w64-x86_64-gspell-1.8.4-1-any.pkg.tar.zst"; sha256 = "a13a256cbeaca43f7443fe288e5c49d4110ab7f82522ace5d6597a1a8c533e3a"; }];
    buildInputs = [ gtk3 iso-codes enchant ];
  };

  "gss" = fetch {
    pname       = "gss";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-gss-1.0.3-1-any.pkg.tar.xz"; sha256 = "21572f451d3d968c1c24e1c445d544a4bf22bbdf0d08e23ac4286bf1ca2fdd8a"; }];
    buildInputs = [ gcc-libs shishi-git ];
  };

  "gst-devtools" = fetch {
    pname       = "gst-devtools";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gst-devtools-1.18.0-1-any.pkg.tar.zst"; sha256 = "603f4145a34ccb2a78838fa01a3376e69930b2a643e499be83f6e23b6c072e23"; }];
    buildInputs = [ gstreamer gst-plugins-base json-glib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-editing-services" = fetch {
    pname       = "gst-editing-services";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gst-editing-services-1.18.0-1-any.pkg.tar.zst"; sha256 = "5069aa4d51d0f9f6d1fff8da5a9fc4ff8f7943ebc51e6eeb56c9e4d9fb62b071"; }];
    buildInputs = [ gst-plugins-base ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-libav" = fetch {
    pname       = "gst-libav";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gst-libav-1.18.0-1-any.pkg.tar.zst"; sha256 = "9ebcd0577879d47b5d7425f9d1735148cb2b932cc2410946632e3d1615b8c26d"; }];
    buildInputs = [ gst-plugins-base ffmpeg ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-bad" = fetch {
    pname       = "gst-plugins-bad";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gst-plugins-bad-1.18.0-2-any.pkg.tar.zst"; sha256 = "a5af8ee382387fc094e6a4c5b7c558a8d1cb61eac8e771ce6df08e78386a3fbe"; }];
    buildInputs = [ aom bzip2 cairo chromaprint curl faad2 faac fdk-aac fluidsynth gsm gst-plugins-base gtk3 lcms2 libass libbs2b libdca libdvdnav libdvdread libexif libgme libjpeg libmodplug libmpeg2-git libnice librsvg libsndfile libsrtp libssh2 libwebp libxml2 libmicrodns nettle openal opencv openexr openh264 openjpeg2 openssl opus orc pango rtmpdump-git soundtouch srt vo-amrwbenc vulkan-validation-layers x265 zbar ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-base" = fetch {
    pname       = "gst-plugins-base";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gst-plugins-base-1.18.0-1-any.pkg.tar.zst"; sha256 = "ba2e21315f950e19760c13d13e1aa82986ebc76f5c4c07c7b5a3d80c48f01529"; }];
    buildInputs = [ graphene gstreamer libogg libtheora libvorbis libvorbisidec libpng libjpeg opus orc pango iso-codes zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-good" = fetch {
    pname       = "gst-plugins-good";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gst-plugins-good-1.18.0-1-any.pkg.tar.zst"; sha256 = "59c1893901278367eb5d3a832e0a487acc732f5c29bd06664318050fa647c667"; }];
    buildInputs = [ bzip2 cairo flac gdk-pixbuf2 gst-plugins-base gtk3 lame libcaca libjpeg libpng libshout libsoup libvpx mpg123 speex taglib twolame wavpack zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-plugins-ugly" = fetch {
    pname       = "gst-plugins-ugly";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gst-plugins-ugly-1.18.0-1-any.pkg.tar.zst"; sha256 = "efc9c59a93a40a9b030753b7c3d50de85522b5e20eb30541d85ffb771720f3a7"; }];
    buildInputs = [ a52dec gst-plugins-base libcdio libdvdread libmpeg2-git opencore-amr x264-git ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-python" = fetch {
    pname       = "gst-python";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gst-python-1.18.0-2-any.pkg.tar.zst"; sha256 = "e2ef1711020b84539f1da43bd93921b65b55d3c9b646c2779876f9f6221b201e"; }];
    buildInputs = [ gstreamer gst-plugins-base python-gobject ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gst-rtsp-server" = fetch {
    pname       = "gst-rtsp-server";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gst-rtsp-server-1.18.0-1-any.pkg.tar.zst"; sha256 = "960c448374452ea9474b5fcc18b096d0be4834597684e1ab4d66806147bb241d"; }];
    buildInputs = [ gcc-libs glib2 gettext gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gstreamer" = fetch {
    pname       = "gstreamer";
    version     = "1.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gstreamer-1.18.0-2-any.pkg.tar.zst"; sha256 = "cdba3258b8e39d6b514cc44aa0eb33a43ae0528550624589fb813fcedf4b3f9e"; }];
    buildInputs = [ gcc-libs libxml2 glib2 gettext gmp gsl ];
  };

  "gtest" = fetch {
    pname       = "gtest";
    version     = "1.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gtest-1.10.0-1-any.pkg.tar.xz"; sha256 = "fefa964768240f3e5d239f79f01d30404166ab1d8bcfb1803bfc3e72030b14d7"; }];
    buildInputs = [ python gcc-libs ];
  };

  "gtk-doc" = fetch {
    pname       = "gtk-doc";
    version     = "1.33.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gtk-doc-1.33.0-2-any.pkg.tar.zst"; sha256 = "9c39cc0173fe5dd68374e8c36f242e78cf9f155922bb4f40227fd02274166429"; }];
    buildInputs = [ docbook-xsl docbook-xml libxslt python3 python3-pygments ];
    broken      = true; # broken dependency gtk-doc -> python3-pygments
  };

  "gtk-engine-murrine" = fetch {
    pname       = "gtk-engine-murrine";
    version     = "0.98.2";
    srcs        = [{ filename = "mingw-w64-x86_64-gtk-engine-murrine-0.98.2-3-any.pkg.tar.xz"; sha256 = "a1f5356b7a95c0cf03c16571e2d90ae4523d3e13078cf51f5a8c561d1c1f6417"; }];
    buildInputs = [ gtk2 ];
  };

  "gtk-engines" = fetch {
    pname       = "gtk-engines";
    version     = "2.21.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gtk-engines-2.21.0-3-any.pkg.tar.xz"; sha256 = "40d6a877e4e00645555c891d67670b7e0b70baef3150bb3f6b7f4713178fa372"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) ];
  };

  "gtk-vnc" = fetch {
    pname       = "gtk-vnc";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gtk-vnc-1.0.0-1-any.pkg.tar.xz"; sha256 = "6152e9ed89a727cff2364e97eeedd45a91d02be1b98f2a983b9b432428ca5bf8"; }];
    buildInputs = [ cyrus-sasl gnutls gtk3 libgcrypt libgpg-error libview zlib ];
  };

  "gtk2" = fetch {
    pname       = "gtk2";
    version     = "2.24.32";
    srcs        = [{ filename = "mingw-w64-x86_64-gtk2-2.24.32-5-any.pkg.tar.zst"; sha256 = "7f51b59806dee76ff10d80ed49bc42fab231954a0576b36e60b2fe50a0a2f8e4"; }];
    buildInputs = [ gcc-libs adwaita-icon-theme (assert stdenvNoCC.lib.versionAtLeast atk.version "1.29.2"; atk) (assert stdenvNoCC.lib.versionAtLeast cairo.version "1.6"; cairo) (assert stdenvNoCC.lib.versionAtLeast gdk-pixbuf2.version "2.21.0"; gdk-pixbuf2) (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.28.0"; glib2) (assert stdenvNoCC.lib.versionAtLeast pango.version "1.20"; pango) shared-mime-info ];
  };

  "gtk3" = fetch {
    pname       = "gtk3";
    version     = "3.24.23";
    srcs        = [{ filename = "mingw-w64-x86_64-gtk3-3.24.23-1-any.pkg.tar.zst"; sha256 = "cc241e2a267f8e98e2f9dac0bd99348ff9e27ea2ad29789190ecb2f0dd31f0a1"; }];
    buildInputs = [ gcc-libs adwaita-icon-theme atk cairo gdk-pixbuf2 glib2 json-glib libepoxy pango shared-mime-info ];
  };

  "gtk4" = fetch {
    pname       = "gtk4";
    version     = "3.99.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gtk4-3.99.1-1-any.pkg.tar.zst"; sha256 = "d2892d1b226942280c3feaeab8f14aec0b50535be98a06e3aa300116bf1aca07"; }];
    buildInputs = [ gcc-libs adwaita-icon-theme atk cairo gdk-pixbuf2 glib2 graphene json-glib libepoxy pango gst-plugins-bad shared-mime-info ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "gtkglext" = fetch {
    pname       = "gtkglext";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gtkglext-1.2.0-3-any.pkg.tar.xz"; sha256 = "371d4f0ead1af7a6624759a8b95d56d5f498ddf0f45c3226521ad045189087d4"; }];
    buildInputs = [ gcc-libs gtk2 gdk-pixbuf2 ];
  };

  "gtkimageview" = fetch {
    pname       = "gtkimageview";
    version     = "1.6.4";
    srcs        = [{ filename = "mingw-w64-x86_64-gtkimageview-1.6.4-4-any.pkg.tar.xz"; sha256 = "a03260b62e63340257e07f6b0c99f32104aa614d54a225513bc37e8e0a64cf8f"; }];
    buildInputs = [ gtk2 ];
  };

  "gtkmm" = fetch {
    pname       = "gtkmm";
    version     = "2.24.5";
    srcs        = [{ filename = "mingw-w64-x86_64-gtkmm-2.24.5-2-any.pkg.tar.xz"; sha256 = "9e3f8aa14d60df3494f62a6208b97761a9d0b8b94922964936344bf2c1c3c1b7"; }];
    buildInputs = [ atkmm pangomm gtk2 ];
  };

  "gtkmm3" = fetch {
    pname       = "gtkmm3";
    version     = "3.24.2";
    srcs        = [{ filename = "mingw-w64-x86_64-gtkmm3-3.24.2-1-any.pkg.tar.xz"; sha256 = "ac5c65c4b8c0752222993c1c6965abf2bd56dc455ded35fbb331e7c3dfeaa706"; }];
    buildInputs = [ gcc-libs atkmm pangomm gtk3 ];
  };

  "gtksourceview2" = fetch {
    pname       = "gtksourceview2";
    version     = "2.10.5";
    srcs        = [{ filename = "mingw-w64-x86_64-gtksourceview2-2.10.5-3-any.pkg.tar.zst"; sha256 = "2de13ccb8f8d9825ac807142d4b07f6ae10314730f6bac2cda938f6c36229549"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.7"; libxml2) ];
  };

  "gtksourceview3" = fetch {
    pname       = "gtksourceview3";
    version     = "3.24.11";
    srcs        = [{ filename = "mingw-w64-x86_64-gtksourceview3-3.24.11-1-any.pkg.tar.xz"; sha256 = "5c52576716ce48f88ecb8f5bc8c013a5f3e7c67e3a3c0dcdc022bacc28322116"; }];
    buildInputs = [ gtk3 libxml2 ];
  };

  "gtksourceview4" = fetch {
    pname       = "gtksourceview4";
    version     = "4.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-gtksourceview4-4.6.0-1-any.pkg.tar.xz"; sha256 = "28bbc7fdb886fd4f16156caeeee3e9baa4ca01226540645f8a88f43af410cafe"; }];
    buildInputs = [ gtk3 libxml2 ];
  };

  "gtksourceviewmm2" = fetch {
    pname       = "gtksourceviewmm2";
    version     = "2.10.3";
    srcs        = [{ filename = "mingw-w64-x86_64-gtksourceviewmm2-2.10.3-2-any.pkg.tar.xz"; sha256 = "2294da508d600ba7b869f358271e578952ebf637300cb43c0b8bf6bbb84c3c23"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.22.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.7"; libxml2) ];
  };

  "gtksourceviewmm3" = fetch {
    pname       = "gtksourceviewmm3";
    version     = "3.21.3";
    srcs        = [{ filename = "mingw-w64-x86_64-gtksourceviewmm3-3.21.3-2-any.pkg.tar.xz"; sha256 = "ffffd3fff21cf81e859f622ec1e0e9d52f2ae8d3bfec70675e8adbe203a65920"; }];
    buildInputs = [ gtksourceview3 gtkmm3 ];
  };

  "gtkspell" = fetch {
    pname       = "gtkspell";
    version     = "2.0.16";
    srcs        = [{ filename = "mingw-w64-x86_64-gtkspell-2.0.16-7-any.pkg.tar.xz"; sha256 = "f9933c69bc0fd2a6fd965e163058c8eecc900337dcbd69b689505e3569677e98"; }];
    buildInputs = [ gtk2 enchant ];
  };

  "gtkspell3" = fetch {
    pname       = "gtkspell3";
    version     = "3.0.10";
    srcs        = [{ filename = "mingw-w64-x86_64-gtkspell3-3.0.10-1-any.pkg.tar.xz"; sha256 = "83d11844a66eae3d8b265e4260b1e6272d812be9aa7afbaab99c04064993480c"; }];
    buildInputs = [ gtk3 gtk2 enchant ];
  };

  "gtkwave" = fetch {
    pname       = "gtkwave";
    version     = "3.3.106";
    srcs        = [{ filename = "mingw-w64-x86_64-gtkwave-3.3.106-1-any.pkg.tar.zst"; sha256 = "a85aa77cef67a1d2bd00d30326e7e2acd6a0d961275c900f4b1d0638098945a7"; }];
    buildInputs = [ gtk2 tk tklib-git tcl tcllib adwaita-icon-theme ];
  };

  "gts" = fetch {
    pname       = "gts";
    version     = "0.7.6";
    srcs        = [{ filename = "mingw-w64-x86_64-gts-0.7.6-1-any.pkg.tar.xz"; sha256 = "0190d8cc648a103cd5827d0a305f63eb7eab49a64d6cb2c553d9c4564eff6b6b"; }];
    buildInputs = [ glib2 ];
  };

  "gumbo-parser" = fetch {
    pname       = "gumbo-parser";
    version     = "0.10.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gumbo-parser-0.10.1-1-any.pkg.tar.xz"; sha256 = "2ac489432bc54f2ab10980c8efef425bbfb2ac3766116baeb3c846f2c25bce66"; }];
  };

  "gxml" = fetch {
    pname       = "gxml";
    version     = "0.18.1";
    srcs        = [{ filename = "mingw-w64-x86_64-gxml-0.18.1-1-any.pkg.tar.zst"; sha256 = "48c1407653d5cddd179cf6350c4637f61251c864118025c2d59ed54c4f77b4c3"; }];
    buildInputs = [ gcc-libs gettext (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.34.0"; glib2) libgee libxml2 xz zlib ];
  };
  harfbuzz = freetype-and-harfbuzz;

  "hclient-git" = fetch {
    pname       = "hclient-git";
    version     = "233.8b17cf3";
    srcs        = [{ filename = "mingw-w64-x86_64-hclient-git-233.8b17cf3-1-any.pkg.tar.xz"; sha256 = "ae7fee886ee5f47eea2cb770314eb5e5827fa994636184ae91cc6c30da083fc4"; }];
  };

  "hdf4" = fetch {
    pname       = "hdf4";
    version     = "4.2.15";
    srcs        = [{ filename = "mingw-w64-x86_64-hdf4-4.2.15-2-any.pkg.tar.zst"; sha256 = "94a12df3c853f978b170d2f14906dd36ed9115e8396a20e3315d6ccd6ed00c00"; }];
    buildInputs = [ libjpeg-turbo gcc-libgfortran zlib ];
  };

  "hdf5" = fetch {
    pname       = "hdf5";
    version     = "1.12.0";
    srcs        = [{ filename = "mingw-w64-x86_64-hdf5-1.12.0-2-any.pkg.tar.zst"; sha256 = "549462ad99a079ff725ac4bd1f662d3594515320ea324a7263a647578b258d86"; }];
    buildInputs = [ gcc-libs gcc-libgfortran szip zlib ];
  };

  "headers-git" = fetch {
    pname       = "headers-git";
    version     = "9.0.0.6029.ecb4ff54";
    srcs        = [{ filename = "mingw-w64-x86_64-headers-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "2c2ef0681944c3742c2af28ac95e7ea7de148dcaa22b0a7bc3b92497930861ca"; }];
    buildInputs = [  ];
  };

  "helics" = fetch {
    pname       = "helics";
    version     = "2.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-helics-2.6.0-1-any.pkg.tar.zst"; sha256 = "5dc3bb26f650fcbeb1d02628791c34882a5eae92e3e488b6d7797524a9027fa2"; }];
    buildInputs = [ zeromq ];
  };

  "hicolor-icon-theme" = fetch {
    pname       = "hicolor-icon-theme";
    version     = "0.17";
    srcs        = [{ filename = "mingw-w64-x86_64-hicolor-icon-theme-0.17-1-any.pkg.tar.xz"; sha256 = "6ea5b44d0fd66cd35922c320bdf4c82b8934febfe7e09df93aece0c92b7a0f5d"; }];
    buildInputs = [  ];
  };

  "hidapi" = fetch {
    pname       = "hidapi";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-hidapi-0.9.0-1-any.pkg.tar.xz"; sha256 = "9f22b303fdd2fd27d77110a7895681e87da7bbc154882b469969eb911f7afe2e"; }];
    buildInputs = [ gcc-libs ];
  };

  "hlsl2glsl-git" = fetch {
    pname       = "hlsl2glsl-git";
    version     = "r848.957cd20";
    srcs        = [{ filename = "mingw-w64-x86_64-hlsl2glsl-git-r848.957cd20-1-any.pkg.tar.xz"; sha256 = "af91039306d54378062b39e9c97d7fedb3673ac8f236b2614e92eefcb88b74b6"; }];
  };

  "http-parser" = fetch {
    pname       = "http-parser";
    version     = "2.9.4";
    srcs        = [{ filename = "mingw-w64-x86_64-http-parser-2.9.4-1-any.pkg.tar.xz"; sha256 = "b65efce0f22d2ff79be060eb438024b2420c011b92a6201683281fb63a50d652"; }];
    buildInputs = [  ];
  };

  "hub" = fetch {
    pname       = "hub";
    version     = "2.14.2";
    srcs        = [{ filename = "mingw-w64-x86_64-hub-2.14.2-1-any.pkg.tar.zst"; sha256 = "8bbcc96c1d651058b0ea0968c6bca40ddb5aab3117a4c4771fcc017578569c42"; }];
    buildInputs = [ git ];
    broken      = true; # broken dependency hub -> git
  };

  "hunspell" = fetch {
    pname       = "hunspell";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-x86_64-hunspell-1.7.0-5-any.pkg.tar.xz"; sha256 = "8330aaaa05fe3f10bef7221310e060ec506d18663d4aa9f96dfb32948b205294"; }];
    buildInputs = [ gcc-libs gettext ncurses readline ];
  };

  "hunspell-en" = fetch {
    pname       = "hunspell-en";
    version     = "2019.10.06";
    srcs        = [{ filename = "mingw-w64-x86_64-hunspell-en-2019.10.06-1-any.pkg.tar.xz"; sha256 = "c41dff978121da7033b66044243b604edef7058b800d2cf90ca1ffc00830173f"; }];
  };

  "hwloc" = fetch {
    pname       = "hwloc";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-hwloc-2.3.0-1-any.pkg.tar.zst"; sha256 = "db00a4415aa6a5d49589e83abc4b0c7584a44fc49bb484a31b1fbe34f1c95d7f"; }];
    buildInputs = [ libtool ];
  };

  "hyphen" = fetch {
    pname       = "hyphen";
    version     = "2.8.8";
    srcs        = [{ filename = "mingw-w64-x86_64-hyphen-2.8.8-1-any.pkg.tar.xz"; sha256 = "224add451abe1d50a1952558f8e7c9ceebc1d198ec5d2aa4f0cda8af28273b50"; }];
  };

  "hyphen-en" = fetch {
    pname       = "hyphen-en";
    version     = "2.8.8";
    srcs        = [{ filename = "mingw-w64-x86_64-hyphen-en-2.8.8-1-any.pkg.tar.xz"; sha256 = "fb307dfdc110fd4527dea8b23a8dd482af4a905e41e6a435ad5266a837f92c87"; }];
  };

  "icon-naming-utils" = fetch {
    pname       = "icon-naming-utils";
    version     = "0.8.90";
    srcs        = [{ filename = "mingw-w64-x86_64-icon-naming-utils-0.8.90-2-any.pkg.tar.xz"; sha256 = "d8b8038ae4885bfd7e86f2988d60e1bbf9b7c0505217c30dff80ab4ab558c04c"; }];
    buildInputs = [ perl-XML-Simple ];
    broken      = true; # broken dependency icon-naming-utils -> perl-XML-Simple
  };

  "iconv" = fetch {
    pname       = "iconv";
    version     = "1.16";
    srcs        = [{ filename = "mingw-w64-x86_64-iconv-1.16-1-any.pkg.tar.xz"; sha256 = "5bd381423fe589b562127ca15ffbd8654a726892b70000f842c1b11608699660"; }];
    buildInputs = [ (assert libiconv.version=="1.16"; libiconv) gettext ];
  };

  "icoutils" = fetch {
    pname       = "icoutils";
    version     = "0.32.3";
    srcs        = [{ filename = "mingw-w64-x86_64-icoutils-0.32.3-1-any.pkg.tar.xz"; sha256 = "914d1848cd92012fd061f70ada6f58f779b740dabdc8ee3c23c73dd7decead81"; }];
    buildInputs = [ libpng ];
  };

  "icu" = fetch {
    pname       = "icu";
    version     = "67.1";
    srcs        = [{ filename = "mingw-w64-x86_64-icu-67.1-1-any.pkg.tar.zst"; sha256 = "bb080e3e590e348d4e64123cf2d6e5dc586cf6640a45245b4045b250b922641e"; }];
    buildInputs = [ gcc-libs ];
  };

  "icu-debug-libs" = fetch {
    pname       = "icu-debug-libs";
    version     = "67.1";
    srcs        = [{ filename = "mingw-w64-x86_64-icu-debug-libs-67.1-1-any.pkg.tar.zst"; sha256 = "452fee0f1a62843dc4ee93148cdf8eca88b85fae06d2b987d958e3606003a3a4"; }];
    buildInputs = [ gcc-libs ];
  };

  "id3lib" = fetch {
    pname       = "id3lib";
    version     = "3.8.3";
    srcs        = [{ filename = "mingw-w64-x86_64-id3lib-3.8.3-2-any.pkg.tar.xz"; sha256 = "a0a625c404d2084f6cb1112daef828b6487d171e0f5dc0acc4d6e93ef8d8192f"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "igraph" = fetch {
    pname       = "igraph";
    version     = "0.8.3";
    srcs        = [{ filename = "mingw-w64-x86_64-igraph-0.8.3-1-any.pkg.tar.zst"; sha256 = "af1827f6d8a1bd32d1b5331ddf93b177f62f7a90c503aff8eb46c806de68b7b2"; }];
    buildInputs = [ glpk gmp zlib libxml2 ];
  };

  "ilmbase" = fetch {
    pname       = "ilmbase";
    version     = "2.5.2";
    srcs        = [{ filename = "mingw-w64-x86_64-ilmbase-2.5.2-1-any.pkg.tar.zst"; sha256 = "ed21a1b3d59f2ea5f3821135ac005ac7806008a6b4645663e7e9bd3a8b632c60"; }];
    buildInputs = [ gcc-libs ];
  };

  "imagemagick" = fetch {
    pname       = "imagemagick";
    version     = "7.0.10.11";
    srcs        = [{ filename = "mingw-w64-x86_64-imagemagick-7.0.10.11-3-any.pkg.tar.zst"; sha256 = "b58c5e3001d2561a9875381684c44ae2d91caf771936e8765ea0c86ec8d6e36b"; }];
    buildInputs = [ bzip2 djvulibre flif fftw fontconfig freetype glib2 gsfonts jasper jbigkit lcms2 libheif liblqr libpng libraqm libraw libtiff libtool libwebp libwmf libxml2 openjpeg2 ttf-dejavu xz zlib zstd ];
  };

  "indent" = fetch {
    pname       = "indent";
    version     = "2.2.12";
    srcs        = [{ filename = "mingw-w64-x86_64-indent-2.2.12-2-any.pkg.tar.zst"; sha256 = "25da8bfb04726f48fe078d7fd0f24572814d936c5664e0dcf0abca4f9995dd55"; }];
    buildInputs = [ gettext ];
  };

  "inkscape" = fetch {
    pname       = "inkscape";
    version     = "0.92.5";
    srcs        = [{ filename = "mingw-w64-x86_64-inkscape-0.92.5-3-any.pkg.tar.zst"; sha256 = "09369bf5892cf125d5812548a534e8633a1116d9fed80562a275ea9e8f8bd5f3"; }];
    buildInputs = [ aspell gc ghostscript gsl gtkmm gtkspell hicolor-icon-theme imagemagick lcms2 libcdr libvisio libxml2 libxslt libwpg poppler popt potrace python ];
  };

  "innoextract" = fetch {
    pname       = "innoextract";
    version     = "1.9";
    srcs        = [{ filename = "mingw-w64-x86_64-innoextract-1.9-1-any.pkg.tar.zst"; sha256 = "470db2c9bf8754100f53aa8ddeb0c5051d613d00c6e50dca5cf30cba9699b36f"; }];
    buildInputs = [ gcc-libs boost bzip2 libiconv xz zlib ];
  };

  "intel-tbb" = fetch {
    pname       = "intel-tbb";
    version     = "1~2020.2";
    srcs        = [{ filename = "mingw-w64-x86_64-intel-tbb-1~2020.2-2-any.pkg.tar.zst"; sha256 = "826b08efa9b50a714e42b997adb98b6da2a52095b6de6019858371455815bba3"; }];
    buildInputs = [ gcc-libs ];
  };

  "irrlicht" = fetch {
    pname       = "irrlicht";
    version     = "1.8.4";
    srcs        = [{ filename = "mingw-w64-x86_64-irrlicht-1.8.4-1-any.pkg.tar.xz"; sha256 = "33c88bbde67fec96cb57f86d4ba6f36845335f07b12d2ff781a8ef7f4272aaac"; }];
    buildInputs = [ gcc-libs ];
  };

  "isl" = fetch {
    pname       = "isl";
    version     = "0.22.1";
    srcs        = [{ filename = "mingw-w64-x86_64-isl-0.22.1-2-any.pkg.tar.zst"; sha256 = "24d4e4e8fa15465b353f2aa60df1c00cd3644f11f9620df0fa2df706c8fa79d1"; }];
    buildInputs = [  ];
  };

  "iso-codes" = fetch {
    pname       = "iso-codes";
    version     = "4.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-iso-codes-4.5.0-1-any.pkg.tar.zst"; sha256 = "e1f4dd2b027a548126dfadf1e652d9e471642a2f3f0fef1dd70b9c1902178707"; }];
    buildInputs = [  ];
  };

  "itk" = fetch {
    pname       = "itk";
    version     = "5.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-itk-5.1.0-2-any.pkg.tar.zst"; sha256 = "eeeb16dfb1c9b8d7cd14597f77a8cf3e1563f32245d8a490c04c08bd95c0e1e1"; }];
    buildInputs = [ gcc-libs expat fftw gdcm hdf5 libjpeg libpng libtiff zlib ];
  };

  "itstool" = fetch {
    pname       = "itstool";
    version     = "2.0.6";
    srcs        = [{ filename = "mingw-w64-x86_64-itstool-2.0.6-3-any.pkg.tar.xz"; sha256 = "b5bac36fe3ad86448df1d9fe7486c9b5f5929fa14d9d17af6dece5f0f7b3016b"; }];
    buildInputs = [ python3 libxml2 ];
  };

  "jansson" = fetch {
    pname       = "jansson";
    version     = "2.12";
    srcs        = [{ filename = "mingw-w64-x86_64-jansson-2.12-1-any.pkg.tar.xz"; sha256 = "8c1dd91d9802bbda2d139d9b7d3c36c7157adcd1948c34c058683c373ca06a8c"; }];
    buildInputs = [  ];
  };

  "jasper" = fetch {
    pname       = "jasper";
    version     = "2.0.16";
    srcs        = [{ filename = "mingw-w64-x86_64-jasper-2.0.16-1-any.pkg.tar.xz"; sha256 = "f24d4313c2206a427c22728ec935adf111f4f6aab6b741f02ac582807d1d272e"; }];
    buildInputs = [ freeglut libjpeg-turbo ];
  };

  "jbig2dec" = fetch {
    pname       = "jbig2dec";
    version     = "0.17";
    srcs        = [{ filename = "mingw-w64-x86_64-jbig2dec-0.17-1-any.pkg.tar.xz"; sha256 = "ad7556c886ada49715e9c15bafac7cb2a6c30ef6b5930e92feb09e36d9290c1c"; }];
    buildInputs = [ libpng ];
  };

  "jbigkit" = fetch {
    pname       = "jbigkit";
    version     = "2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-jbigkit-2.1-4-any.pkg.tar.xz"; sha256 = "403eb150573e92b784f33c50495b5b962077d8103efae47b252321dbbd113bba"; }];
    buildInputs = [ gcc-libs ];
  };

  "jemalloc" = fetch {
    pname       = "jemalloc";
    version     = "5.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-jemalloc-5.2.1-1-any.pkg.tar.xz"; sha256 = "b431a62a6a746da2078e2a28a429cc6c6e48d8712bb35ddc7a67744d39a815f0"; }];
    buildInputs = [ gcc-libs ];
  };

  "jpegoptim" = fetch {
    pname       = "jpegoptim";
    version     = "1.4.6";
    srcs        = [{ filename = "mingw-w64-x86_64-jpegoptim-1.4.6-1-any.pkg.tar.xz"; sha256 = "646a1c76044af32c6f430e8b9014848c6fd822f03ade312b128391bfc10d7466"; }];
    buildInputs = [ libjpeg-turbo ];
  };

  "jq" = fetch {
    pname       = "jq";
    version     = "1.6";
    srcs        = [{ filename = "mingw-w64-x86_64-jq-1.6-3-any.pkg.tar.zst"; sha256 = "2144f7e0190f82d74311852d7701b3b6963f8d705706a08a0d999e1ce800477c"; }];
    buildInputs = [ oniguruma libwinpthread-git ];
  };

  "json-c" = fetch {
    pname       = "json-c";
    version     = "0.15";
    srcs        = [{ filename = "mingw-w64-x86_64-json-c-0.15-1-any.pkg.tar.zst"; sha256 = "a680fb145c4ffcd326328e5456fc97b54979a4613069054b5419d89475b4db72"; }];
    buildInputs = [ gcc-libs ];
  };

  "json-glib" = fetch {
    pname       = "json-glib";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-json-glib-1.6.0-1-any.pkg.tar.zst"; sha256 = "c30ccaa0376f25d771a611ab588f4fc6b0579568625ffde0f006dbc21f13b1b4"; }];
    buildInputs = [ glib2 ];
  };

  "jsoncpp" = fetch {
    pname       = "jsoncpp";
    version     = "1.9.4";
    srcs        = [{ filename = "mingw-w64-x86_64-jsoncpp-1.9.4-1-any.pkg.tar.zst"; sha256 = "c0c99039b6c2a78c5ca07951437d6c594c5d65a65501491b19e50f4aedcfaa5e"; }];
    buildInputs = [  ];
  };

  "jsonrpc-glib" = fetch {
    pname       = "jsonrpc-glib";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-jsonrpc-glib-3.38.0-1-any.pkg.tar.zst"; sha256 = "4fef4f95f641b66c51dfe36ccbef92324df139684914201460e9261c24ee538e"; }];
    buildInputs = [ glib2 json-glib ];
  };

  "jxrlib" = fetch {
    pname       = "jxrlib";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-jxrlib-1.1-3-any.pkg.tar.xz"; sha256 = "cd041d6aa36e7235e01a6a26a2d228da7c8963c27664dbe55b5bebcfbb1bf03b"; }];
    buildInputs = [ gcc-libs ];
  };

  "kactivities-qt5" = fetch {
    pname       = "kactivities-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kactivities-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "ff4701f227f224c4c3d8cbd8530808c3c1e2d34fda29dc02583d054d4da876e4"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.74.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.74.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.74.0"; kwindowsystem-qt5) ];
  };

  "karchive-qt5" = fetch {
    pname       = "karchive-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-karchive-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "34318ed929a56bec2bfd5b7f244125f1b258090d1f022fc63961b832e7d39d27"; }];
    buildInputs = [ zlib bzip2 xz qt5 ];
  };

  "kate" = fetch {
    pname       = "kate";
    version     = "19.12.3";
    srcs        = [{ filename = "mingw-w64-x86_64-kate-19.12.3-1-any.pkg.tar.xz"; sha256 = "94465cfca5efbf28f0a923ed4101aae354b219bfdfb957566bf02e4d56e1dc2a"; }];
    buildInputs = [ knewstuff-qt5 ktexteditor-qt5 threadweaver-qt5 kitemmodels-qt5 kactivities-qt5 plasma-framework-qt5 hicolor-icon-theme ];
  };

  "kauth-qt5" = fetch {
    pname       = "kauth-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kauth-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "f892e73e80a911bb95fbce8cfffab3d0ccc6a01ff1ee4648b356a4d364a5c8da"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.74.0"; kcoreaddons-qt5) ];
  };

  "kbookmarks-qt5" = fetch {
    pname       = "kbookmarks-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kbookmarks-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "9924baef8f05acbab061693ad521f6b46407fae7f2c8963dc60e209f72038baf"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kxmlgui-qt5.version "5.68.0"; kxmlgui-qt5) ];
  };

  "kcmutils-qt5" = fetch {
    pname       = "kcmutils-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kcmutils-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "6c3c09c038bc0556a4e91cb5d409080d1fefddc33825e0e7d29dd50b642e8775"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast kconfigwidgets-qt5.version "5.68.0"; kconfigwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast kdeclarative-qt5.version "5.68.0"; kdeclarative-qt5) qt5 ];
  };

  "kcodecs-qt5" = fetch {
    pname       = "kcodecs-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kcodecs-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "bf4cfbeb718537bccdca27787dd9943ac78f54d9dde2d8f63892161fd8e6c9b4"; }];
    buildInputs = [ qt5 ];
  };

  "kcompletion-qt5" = fetch {
    pname       = "kcompletion-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kcompletion-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "85ef89c49954e50ed840d3a4a3169598ebc7d380d70f6f228c6149d1c28240e5"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.74.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.74.0"; kwidgetsaddons-qt5) ];
  };

  "kconfig-qt5" = fetch {
    pname       = "kconfig-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kconfig-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "54b2053cde55ded8b3ca123d78216ba72b230d8677bfade2c67096aaea969056"; }];
    buildInputs = [ qt5 ];
  };

  "kconfigwidgets-qt5" = fetch {
    pname       = "kconfigwidgets-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kconfigwidgets-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "ec5e9d55a618a23e67a9d9cfc080eff1c047462f48db81ed948c68e1067c52d4"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kauth-qt5.version "5.68.0"; kauth-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.68.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kcodecs-qt5.version "5.68.0"; kcodecs-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.68.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kguiaddons-qt5.version "5.68.0"; kguiaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.68.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.68.0"; kwidgetsaddons-qt5) ];
  };

  "kcoreaddons-qt5" = fetch {
    pname       = "kcoreaddons-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kcoreaddons-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "07c543e4cf034a6b99b6329658769cfa3da3804b5dc422d6ef7eca603c53e92e"; }];
    buildInputs = [ qt5 ];
  };

  "kcrash-qt5" = fetch {
    pname       = "kcrash-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kcrash-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "347952dd4fda0f17785ec8554e802085048633e09137ed41b476eda195956965"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.74.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.74.0"; kwindowsystem-qt5) ];
  };

  "kdbusaddons-qt5" = fetch {
    pname       = "kdbusaddons-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kdbusaddons-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "99e91825ca8d81530c34015ae876eb4ae29561f243b2c68bd6c2878427581084"; }];
    buildInputs = [ qt5 ];
  };

  "kdeclarative-qt5" = fetch {
    pname       = "kdeclarative-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kdeclarative-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "96ce4afd93c9bbb1c76575fb0ba2c49f32e1cfad3288bccb74768498c2fcdc38"; }];
    buildInputs = [ qt5 kio-qt5 kpackage-qt5 libepoxy ];
  };

  "kdewebkit-qt5" = fetch {
    pname       = "kdewebkit-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kdewebkit-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "41b986ac11a984a325075b20c0e5bf58e1b5f2248001f68ae97ea2ddf7855d32"; }];
    buildInputs = [ kio-qt5 kparts-qt5 qtwebkit ];
  };

  "kdnssd-qt5" = fetch {
    pname       = "kdnssd-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kdnssd-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "c52564f215a9cdfb66e889cbf736266e7c7f344825ebc774fbaf46c0e451bbe0"; }];
    buildInputs = [ qt5 ];
  };

  "kdoctools-qt5" = fetch {
    pname       = "kdoctools-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kdoctools-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "46b0641077beaf5471252020e44877c508a995ff078bc6d59e51e816a7c07fd8"; }];
    buildInputs = [ qt5 libxslt docbook-xsl (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.74.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.74.0"; karchive-qt5) ];
  };

  "kfilemetadata-qt5" = fetch {
    pname       = "kfilemetadata-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kfilemetadata-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "60aa6baa7fbf3cbbbf35f71587682f9b54d462dcbd8930fc183f8b4b68c217c7"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.74.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.74.0"; karchive-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.74.0"; kcoreaddons-qt5) exiv2 poppler taglib ffmpeg ];
  };

  "kglobalaccel-qt5" = fetch {
    pname       = "kglobalaccel-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kglobalaccel-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "dd64bc5b905ba3870d36b8a59557dba83d6913feb35e82fce8a1925a108d461d"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.68.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.68.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kcrash-qt5.version "5.68.0"; kcrash-qt5) (assert stdenvNoCC.lib.versionAtLeast kdbusaddons-qt5.version "5.68.0"; kdbusaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.68.0"; kwindowsystem-qt5) ];
  };

  "kguiaddons-qt5" = fetch {
    pname       = "kguiaddons-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kguiaddons-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "9d3d8c53326cca583bb27042d1b5caec66dc6d19c8ededf1d8e126a3b1984141"; }];
    buildInputs = [ qt5 ];
  };

  "kholidays-qt5" = fetch {
    pname       = "kholidays-qt5";
    version     = "1~5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kholidays-qt5-1~5.74.0-1-any.pkg.tar.zst"; sha256 = "ca970ac84ef755ad2dd33e952a2f7062fe3677cf05001e14d62fa7c0888f3d89"; }];
    buildInputs = [ qt5 ];
  };

  "ki18n-qt5" = fetch {
    pname       = "ki18n-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-ki18n-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "3ae43f61efaf63620297aa6a10cc55d032242aabf9ec961a58dc9e3dead3f0f5"; }];
    buildInputs = [ gettext qt5 ];
  };

  "kicad" = fetch {
    pname       = "kicad";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-5.1.5-1-any.pkg.tar.xz"; sha256 = "dc7f2fc4cddac3ffede073f89d661f95364f60660e04e54659aecef267678c34"; }];
    buildInputs = [ boost curl glew glm ngspice python2 wxPython wxWidgets openssl freeglut zlib ];
  };

  "kicad-doc-ca" = fetch {
    pname       = "kicad-doc-ca";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-ca-5.1.5-1-any.pkg.tar.xz"; sha256 = "ef432e0551ea0db97cf9e076b56b5fd508ead25e0744a11e3ad1daecfd3f57c8"; }];
  };

  "kicad-doc-de" = fetch {
    pname       = "kicad-doc-de";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-de-5.1.5-1-any.pkg.tar.xz"; sha256 = "d56aa301e5c63816909305932d1673d67daa78d61a89a10d34f67ef2c8494319"; }];
  };

  "kicad-doc-en" = fetch {
    pname       = "kicad-doc-en";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-en-5.1.5-1-any.pkg.tar.xz"; sha256 = "f1181871dddb341df9579132b8c77757f9e0447b40d61d2c3d5155a89e91cc85"; }];
  };

  "kicad-doc-es" = fetch {
    pname       = "kicad-doc-es";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-es-5.1.5-1-any.pkg.tar.xz"; sha256 = "a6c610c01d737cfe9544fc535363410d614c19a50647e1606cc6c994b11cecb0"; }];
  };

  "kicad-doc-fr" = fetch {
    pname       = "kicad-doc-fr";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-fr-5.1.5-1-any.pkg.tar.xz"; sha256 = "a63a830043ae1b3f2a06e201234704fe7efa9f63cf8c35ba62a9172b5a7dd938"; }];
  };

  "kicad-doc-id" = fetch {
    pname       = "kicad-doc-id";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-id-5.1.5-1-any.pkg.tar.xz"; sha256 = "806e1041d3ecbec23ebcb379b55b845302f362a8b593b10618164cbe287c6ae0"; }];
  };

  "kicad-doc-it" = fetch {
    pname       = "kicad-doc-it";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-it-5.1.5-1-any.pkg.tar.xz"; sha256 = "d9500807fa057bf78d2c6d564c969ca7cbe96c47c2756ca0be17dec0dfa4e08a"; }];
  };

  "kicad-doc-ja" = fetch {
    pname       = "kicad-doc-ja";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-ja-5.1.5-1-any.pkg.tar.xz"; sha256 = "046992d83772eea9a89f02fd13ae7de47eb332118d418791e006312c866c8d2d"; }];
  };

  "kicad-doc-pl" = fetch {
    pname       = "kicad-doc-pl";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-pl-5.1.5-1-any.pkg.tar.xz"; sha256 = "2e1d57f99e541363f1f60c42d563b5c6e3aab8640f5ad9cdbc1ad39c3a54a31d"; }];
  };

  "kicad-doc-ru" = fetch {
    pname       = "kicad-doc-ru";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-ru-5.1.5-1-any.pkg.tar.xz"; sha256 = "cf8678feec345eb04d91654fe3ff03fd8b470393f4efacdbe58c87d64d108e0c"; }];
  };

  "kicad-doc-zh" = fetch {
    pname       = "kicad-doc-zh";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-doc-zh-5.1.5-1-any.pkg.tar.xz"; sha256 = "7f5318aa808de5863ebb431ec9107b338bdb58a3e47eeba143f27a4ee1673054"; }];
  };

  "kicad-footprints" = fetch {
    pname       = "kicad-footprints";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-footprints-5.1.5-1-any.pkg.tar.xz"; sha256 = "7220721a658527c579d99b14e34884a196934f322aa42a35818d0b30987fde45"; }];
    buildInputs = [ boost curl glew glm ngspice python2 wxPython wxWidgets openssl freeglut zlib ];
  };

  "kicad-meta" = fetch {
    pname       = "kicad-meta";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-meta-5.1.5-1-any.pkg.tar.xz"; sha256 = "55797329624ef0ad9996c5fa9d59145279033fd02ce277762320fefe79269f2b"; }];
    buildInputs = [ kicad kicad-footprints kicad-symbols kicad-templates kicad-packages3D ];
  };

  "kicad-packages3D" = fetch {
    pname       = "kicad-packages3D";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-packages3D-5.1.5-1-any.pkg.tar.xz"; sha256 = "5c23624e7bcc15660a2de093fed0ff02e5881588930e63a633048cc6cc954802"; }];
    buildInputs = [ boost curl glew glm ngspice python2 wxPython wxWidgets openssl freeglut zlib ];
  };

  "kicad-symbols" = fetch {
    pname       = "kicad-symbols";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-symbols-5.1.5-1-any.pkg.tar.xz"; sha256 = "88a53345e932c16547bdfbeaeecfd559e9bf0c1fd695749e3ae0ca9e679e12b1"; }];
    buildInputs = [ boost curl glew glm ngspice python2 wxPython wxWidgets openssl freeglut zlib ];
  };

  "kicad-templates" = fetch {
    pname       = "kicad-templates";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-kicad-templates-5.1.5-1-any.pkg.tar.xz"; sha256 = "7b6091de254e6535afe0a9beee7374401c65c033812372512d37096128145c80"; }];
    buildInputs = [ boost curl glew glm ngspice python2 wxPython wxWidgets openssl freeglut zlib ];
  };

  "kiconthemes-qt5" = fetch {
    pname       = "kiconthemes-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kiconthemes-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "c72b140843310ba7632663e7df9e061cfd9c5f773f288e7c804e879446ffdbaa"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kconfigwidgets-qt5.version "5.68.0"; kconfigwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast kitemviews-qt5.version "5.68.0"; kitemviews-qt5) (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.68.0"; karchive-qt5) ];
  };

  "kidletime-qt5" = fetch {
    pname       = "kidletime-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kidletime-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "5ad712ec5109e2ccfcc6d8fca14e254de61a4545945653e89788c58210ebdca9"; }];
    buildInputs = [ qt5 ];
  };

  "kimageformats-qt5" = fetch {
    pname       = "kimageformats-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kimageformats-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "4e5e3d6f2c1f4cc85f2671d377175def74d64713d88c0ab9270ee0edec30e6e8"; }];
    buildInputs = [ qt5 openexr (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.74.0"; karchive-qt5) ];
  };

  "kinit-qt5" = fetch {
    pname       = "kinit-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kinit-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "f6c07111e60e71f3c0dc8560788a1100aee9de400d12bab4abf634dbe00598aa"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.68.0"; kio-qt5) ];
  };

  "kio-qt5" = fetch {
    pname       = "kio-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kio-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "6bff56234f31217575cf6444ca91ab1926812ea84cb7471714337c70db19e03c"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast solid-qt5.version "5.68.0"; solid-qt5) (assert stdenvNoCC.lib.versionAtLeast kjobwidgets-qt5.version "5.68.0"; kjobwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast kbookmarks-qt5.version "5.68.0"; kbookmarks-qt5) (assert stdenvNoCC.lib.versionAtLeast kwallet-qt5.version "5.68.0"; kwallet-qt5) libxslt ];
  };

  "kirigami2-qt5" = fetch {
    pname       = "kirigami2-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kirigami2-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "7b5b6a3f6b4aeb170b9e06c723f59f9c3dcdd48bb363285321751835fe04ae35"; }];
    buildInputs = [ qt5 ];
  };

  "kiss_fft" = fetch {
    pname       = "kiss_fft";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-kiss_fft-1.3.1-1-any.pkg.tar.xz"; sha256 = "92540fda36a51d08d661162bfc85069eb78bb0b0d8701e745b25256faa2f4165"; }];
  };

  "kitemmodels-qt5" = fetch {
    pname       = "kitemmodels-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kitemmodels-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "e8ae1f06cdc4a5b44da3105842c9aef52d5e1cbbd1805d9bda7d9ee2e1135f3c"; }];
    buildInputs = [ qt5 ];
  };

  "kitemviews-qt5" = fetch {
    pname       = "kitemviews-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kitemviews-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "3810196d879e96d4e0a2f05950ef0644649bc2e5eb26f502cfc06add506744a3"; }];
    buildInputs = [ qt5 ];
  };

  "kjobwidgets-qt5" = fetch {
    pname       = "kjobwidgets-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kjobwidgets-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "758ee09f54fcae45871b2319a5bbf607b5894612e08913eee763438ffd628bc9"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.74.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwidgetsaddons-qt5.version "5.74.0"; kwidgetsaddons-qt5) ];
  };

  "kjs-qt5" = fetch {
    pname       = "kjs-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kjs-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "353ac20674925fbafd842fb510f6a77aa10d89f25ca3c30895b53525af2f033f"; }];
    buildInputs = [ qt5 bzip2 pcre (assert stdenvNoCC.lib.versionAtLeast kdoctools-qt5.version "5.68.0"; kdoctools-qt5) ];
  };

  "knewstuff-qt5" = fetch {
    pname       = "knewstuff-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-knewstuff-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "8666809c0486780f5b6a898c1935644b031ba6223b05f308fa760324bf731870"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.68.0"; kio-qt5) ];
  };

  "knotifications-qt5" = fetch {
    pname       = "knotifications-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-knotifications-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "d10bef014818054100f8764acccea1bcacb2ce34e730d26f99035712ce6dab59"; }];
    buildInputs = [ qt5 phonon-qt5 (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.74.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.74.0"; kcoreaddons-qt5) (assert stdenvNoCC.lib.versionAtLeast kwindowsystem-qt5.version "5.74.0"; kwindowsystem-qt5) ];
  };

  "kpackage-qt5" = fetch {
    pname       = "kpackage-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kpackage-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "5cd11bf20cf3bba1c932a1c3dacda492370c5e726fd907dd1dc88eac24a10d60"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast karchive-qt5.version "5.74.0"; karchive-qt5) (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.74.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kcoreaddons-qt5.version "5.74.0"; kcoreaddons-qt5) ];
  };

  "kparts-qt5" = fetch {
    pname       = "kparts-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kparts-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "bb0dbe68f53b51c257f9a5f3e472cf232699eee7059ff3361e84a4505ffc0785"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kio-qt5.version "5.68.0"; kio-qt5) ];
  };

  "kplotting-qt5" = fetch {
    pname       = "kplotting-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kplotting-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "879a3d3c93205d6b02118ec897ab0e8321342d7a70894cce80bb88bc6b53b38a"; }];
    buildInputs = [ qt5 ];
  };

  "kservice-qt5" = fetch {
    pname       = "kservice-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kservice-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "15b7340444c7bfaac54cd57dc6f484bcb9c79f9b4823bbdbf13b3bc49493cf5f"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.68.0"; ki18n-qt5) (assert stdenvNoCC.lib.versionAtLeast kconfig-qt5.version "5.68.0"; kconfig-qt5) (assert stdenvNoCC.lib.versionAtLeast kcrash-qt5.version "5.68.0"; kcrash-qt5) (assert stdenvNoCC.lib.versionAtLeast kdbusaddons-qt5.version "5.68.0"; kdbusaddons-qt5) ];
  };

  "ktexteditor-qt5" = fetch {
    pname       = "ktexteditor-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-ktexteditor-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "ad9bd7bdc21fb754f28340f440015ab031746d42d5592e418d8b8546b4932297"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kparts-qt5.version "5.68.0"; kparts-qt5) (assert stdenvNoCC.lib.versionAtLeast syntax-highlighting-qt5.version "5.68.0"; syntax-highlighting-qt5) libgit2 editorconfig-core-c ];
  };

  "ktextwidgets-qt5" = fetch {
    pname       = "ktextwidgets-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-ktextwidgets-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "39ae7aefdda17f5fbd5a42724f9ec55c0b6b09dc68de03185877c11b862e81f1"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcompletion-qt5.version "5.68.0"; kcompletion-qt5) (assert stdenvNoCC.lib.versionAtLeast kservice-qt5.version "5.68.0"; kservice-qt5) (assert stdenvNoCC.lib.versionAtLeast kiconthemes-qt5.version "5.68.0"; kiconthemes-qt5) (assert stdenvNoCC.lib.versionAtLeast sonnet-qt5.version "5.68.0"; sonnet-qt5) ];
  };

  "kunitconversion-qt5" = fetch {
    pname       = "kunitconversion-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kunitconversion-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "7184b760e6b548082a8a15047f575da8d4ec4dbd775867ba5a8b5d8fd6d34031"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast ki18n-qt5.version "5.74.0"; ki18n-qt5) ];
  };

  "kvazaar" = fetch {
    pname       = "kvazaar";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kvazaar-2.0.0-1-any.pkg.tar.xz"; sha256 = "2e4f5efb509b6cded76e87d625383b8bb6fd1bda9707ca125993ae604a28a129"; }];
    buildInputs = [ gcc-libs self."crypto++" ];
  };

  "kwallet-qt5" = fetch {
    pname       = "kwallet-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kwallet-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "3124a3689781466dd7a6805fb69d3a8e851b41fbe8b46d32f548f1e6175b4da4"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast knotifications-qt5.version "5.68.0"; knotifications-qt5) (assert stdenvNoCC.lib.versionAtLeast kiconthemes-qt5.version "5.68.0"; kiconthemes-qt5) (assert stdenvNoCC.lib.versionAtLeast kservice-qt5.version "5.68.0"; kservice-qt5) gpgme ];
  };

  "kwidgetsaddons-qt5" = fetch {
    pname       = "kwidgetsaddons-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kwidgetsaddons-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "70444c9d0ffa21645b63c0d878fd71f0541537fb3f65da7b40785e49d46c7f84"; }];
    buildInputs = [ qt5 ];
  };

  "kwindowsystem-qt5" = fetch {
    pname       = "kwindowsystem-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kwindowsystem-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "a675382d42be85a31caa6ab20bde49fd0d025ea539a3212628e1323d8f9fa2a8"; }];
    buildInputs = [ qt5 ];
  };

  "kxmlgui-qt5" = fetch {
    pname       = "kxmlgui-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-kxmlgui-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "87c3bc55b46b64c97b358864d0a0464d9a4d231cca94413afc872031578a109a"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kglobalaccel-qt5.version "5.68.0"; kglobalaccel-qt5) (assert stdenvNoCC.lib.versionAtLeast ktextwidgets-qt5.version "5.68.0"; ktextwidgets-qt5) (assert stdenvNoCC.lib.versionAtLeast attica-qt5.version "5.68.0"; attica-qt5) ];
  };

  "l-smash" = fetch {
    pname       = "l-smash";
    version     = "2.14.5";
    srcs        = [{ filename = "mingw-w64-x86_64-l-smash-2.14.5-1-any.pkg.tar.xz"; sha256 = "517bf61aa9aa5806e021d3a0c93082b53a70600e546c81c4c54b7c0076f19ed3"; }];
    buildInputs = [  ];
  };

  "ladspa-sdk" = fetch {
    pname       = "ladspa-sdk";
    version     = "1.15";
    srcs        = [{ filename = "mingw-w64-x86_64-ladspa-sdk-1.15-1-any.pkg.tar.xz"; sha256 = "8d000676d57cae737ef3595661146460794bfc00c27b57f8eb2d1dc5b207d512"; }];
  };

  "lame" = fetch {
    pname       = "lame";
    version     = "3.100";
    srcs        = [{ filename = "mingw-w64-x86_64-lame-3.100-1-any.pkg.tar.xz"; sha256 = "57cc1e269e5228715b0f0686b63006b1f92fc80b51f4aba5382e6abf94606fc4"; }];
    buildInputs = [ libiconv ];
  };

  "lapack" = fetch {
    pname       = "lapack";
    version     = "3.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-lapack-3.9.0-2-any.pkg.tar.zst"; sha256 = "ac45a1956abf68f75183640236a97661f137d46f508cc84c3199403d855b8599"; }];
    buildInputs = [ gcc-libs gcc-libgfortran ];
  };

  "lasem" = fetch {
    pname       = "lasem";
    version     = "0.4.4";
    srcs        = [{ filename = "mingw-w64-x86_64-lasem-0.4.4-1-any.pkg.tar.xz"; sha256 = "1eeb5d87c26272b2dbae405838e6378fbe1a025e32e7904160c747c7bfb1aae9"; }];
  };

  "laszip" = fetch {
    pname       = "laszip";
    version     = "3.4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-laszip-3.4.3-1-any.pkg.tar.xz"; sha256 = "24e7750634bd4400d83f53de562c14f4498925a0dd45378d6c62109cd34bac14"; }];
  };

  "lcms" = fetch {
    pname       = "lcms";
    version     = "1.19";
    srcs        = [{ filename = "mingw-w64-x86_64-lcms-1.19-6-any.pkg.tar.xz"; sha256 = "12b1032b0eec342c71b4f78f3e4dbc62d340324166933975c5f0e427315ba0a6"; }];
    buildInputs = [ libtiff ];
  };

  "lcms2" = fetch {
    pname       = "lcms2";
    version     = "2.11";
    srcs        = [{ filename = "mingw-w64-x86_64-lcms2-2.11-1-any.pkg.tar.zst"; sha256 = "64ffffee72953138fcc72104603f6359e72f1a0054f045b1e745f85c217ec3ec"; }];
    buildInputs = [ gcc-libs libtiff ];
  };

  "ldns" = fetch {
    pname       = "ldns";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-x86_64-ldns-1.7.0-3-any.pkg.tar.xz"; sha256 = "215502c105079caec09b802310441aca1e2506087e674567ad4923eeae723470"; }];
    buildInputs = [ openssl ];
  };

  "lensfun" = fetch {
    pname       = "lensfun";
    version     = "0.3.2";
    srcs        = [{ filename = "mingw-w64-x86_64-lensfun-0.3.2-7-any.pkg.tar.zst"; sha256 = "a023c06a911d6b81ef4c4000d460f182809f873f7be9f5de9db46231c573a1d9"; }];
    buildInputs = [ glib2 libpng zlib ];
  };

  "leptonica" = fetch {
    pname       = "leptonica";
    version     = "1.80.0";
    srcs        = [{ filename = "mingw-w64-x86_64-leptonica-1.80.0-1-any.pkg.tar.zst"; sha256 = "cdb01349264f02fb93821cceb50d163bbd4e6cfa243c99e0e5fb994d08bc1237"; }];
    buildInputs = [ gcc-libs giflib libtiff libpng libwebp openjpeg2 zlib ];
  };

  "leveldb" = fetch {
    pname       = "leveldb";
    version     = "1.22";
    srcs        = [{ filename = "mingw-w64-x86_64-leveldb-1.22-1-any.pkg.tar.xz"; sha256 = "700ffa1152a17f4de306c1512ce13a461d381b41441ac481d82470e29e8f1387"; }];
  };

  "lfcbase" = fetch {
    pname       = "lfcbase";
    version     = "1.14.4";
    srcs        = [{ filename = "mingw-w64-x86_64-lfcbase-1.14.4-1-any.pkg.tar.zst"; sha256 = "f1ff7a9112e672bca5887801054f28b361c196317720f9805128926e965d613b"; }];
    buildInputs = [ gcc-libs ncurses ];
  };

  "lfcxml" = fetch {
    pname       = "lfcxml";
    version     = "1.2.11";
    srcs        = [{ filename = "mingw-w64-x86_64-lfcxml-1.2.11-1-any.pkg.tar.zst"; sha256 = "57c3c4d8bf485fa43d20b25f7e288d9ea75e397267f31674a0e8ca538b46a193"; }];
    buildInputs = [ lfcbase ];
  };

  "lib3mf" = fetch {
    pname       = "lib3mf";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-lib3mf-2.0.0-1-any.pkg.tar.xz"; sha256 = "fa9390e8ba122d804a9303a42c6a9629eb02416fb8af52fdf32e2749ef62ae71"; }];
  };

  "libaacs" = fetch {
    pname       = "libaacs";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libaacs-0.10.0-1-any.pkg.tar.zst"; sha256 = "9aefa2fa068933295d7ef50e16826a837651d6bc4244029ec6945b3f40b9b5f1"; }];
    buildInputs = [ libgcrypt ];
  };

  "libaec" = fetch {
    pname       = "libaec";
    version     = "1.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-libaec-1.0.4-1-any.pkg.tar.zst"; sha256 = "8fb6b891bea1f7500f8a7a246419bd67b5b37501a83f79feab0d75c199a2ab21"; }];
    buildInputs = [ crt-git ];
  };

  "libao" = fetch {
    pname       = "libao";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libao-1.2.2-1-any.pkg.tar.xz"; sha256 = "761045339f7a4f0b57dfce74966c93cda8e72cd18b62dbe0fcfcf5136c47982f"; }];
    buildInputs = [ gcc-libs ];
  };

  "libarchive" = fetch {
    pname       = "libarchive";
    version     = "3.4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libarchive-3.4.3-1-any.pkg.tar.zst"; sha256 = "8eba6154da91057ea0923c69c01c7b83e7876f60bf6181f6f6a1c21093ea3cb1"; }];
    buildInputs = [ gcc-libs bzip2 expat libiconv lz4 libsystre nettle openssl xz zlib zstd ];
  };

  "libart_lgpl" = fetch {
    pname       = "libart_lgpl";
    version     = "2.3.21";
    srcs        = [{ filename = "mingw-w64-x86_64-libart_lgpl-2.3.21-2-any.pkg.tar.xz"; sha256 = "89d2572b3c0449608d55dd9e8b85d17df0344bdea72007721463720f8f47f473"; }];
  };

  "libass" = fetch {
    pname       = "libass";
    version     = "0.14.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libass-0.14.0-1-any.pkg.tar.xz"; sha256 = "557e6cee5000175829884327999269db7eb55bf4508ebaa8f98b7684cf694b19"; }];
    buildInputs = [ fribidi fontconfig freetype harfbuzz ];
  };

  "libassuan" = fetch {
    pname       = "libassuan";
    version     = "2.5.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libassuan-2.5.3-1-any.pkg.tar.xz"; sha256 = "b2024ade671cfe5d00592f5c8d6346fafc39f47659ac9267820744cdfa00be06"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libatomic_ops" = fetch {
    pname       = "libatomic_ops";
    version     = "7.6.10";
    srcs        = [{ filename = "mingw-w64-x86_64-libatomic_ops-7.6.10-1-any.pkg.tar.xz"; sha256 = "d83a6b8b0ef986bac25feced66974e36f6eeadf540fd2317a83da5437ca4a903"; }];
    buildInputs = [  ];
  };

  "libavif" = fetch {
    pname       = "libavif";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libavif-0.8.1-1-any.pkg.tar.zst"; sha256 = "f7c93ca64bc0a80384fe26b1f97a51be97be72fd875b9c33dab0b88f8b010f54"; }];
    buildInputs = [ aom dav1d rav1e libjpeg-turbo libpng zlib ];
  };

  "libbdplus" = fetch {
    pname       = "libbdplus";
    version     = "0.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libbdplus-0.1.2-1-any.pkg.tar.xz"; sha256 = "fcdb0b575ec1b3178637b7be94164660338fd7858c83f5592f29d1f5deead22d"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libaacs.version "0.7.0"; libaacs) libgpg-error ];
  };

  "libblocksruntime" = fetch {
    pname       = "libblocksruntime";
    version     = "0.4.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libblocksruntime-0.4.1-1-any.pkg.tar.xz"; sha256 = "db4d9894ccba3a1e07d15fd48422f2d6dc7087fcf2680c2b05c20b95bff7190c"; }];
    buildInputs = [ clang ];
  };

  "libbluray" = fetch {
    pname       = "libbluray";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libbluray-1.2.0-1-any.pkg.tar.xz"; sha256 = "d9da5f96c0d16c813dfd6b8a1862dc9ef7fba5987779e4022a9854184c2795cb"; }];
    buildInputs = [ libxml2 freetype ];
  };

  "libbotan" = fetch {
    pname       = "libbotan";
    version     = "2.14.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libbotan-2.14.0-1-any.pkg.tar.xz"; sha256 = "964452185782d07522cbf95284bc97a76f68f04159e5df3636233d9759f1b806"; }];
    buildInputs = [ gcc-libs boost bzip2 sqlite3 zlib xz ];
  };

  "libbs2b" = fetch {
    pname       = "libbs2b";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libbs2b-3.1.0-1-any.pkg.tar.xz"; sha256 = "b7ea141d36bf879bc0b0ede8d4ebd6bb396510a091fe9fdb4b20e606a490da94"; }];
    buildInputs = [ libsndfile ];
  };

  "libbsdf" = fetch {
    pname       = "libbsdf";
    version     = "0.9.11";
    srcs        = [{ filename = "mingw-w64-x86_64-libbsdf-0.9.11-1-any.pkg.tar.xz"; sha256 = "9e13ce44fcd1dacba3be2d849b7761aa70d18011119f07261824ce2c5a56e2b5"; }];
  };

  "libc++" = fetch {
    pname       = "libc++";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libc++-10.0.1-1-any.pkg.tar.zst"; sha256 = "bdf77ac863cbaf3dc20724df0a8aa36fd25aaf56e4c2540e233ac871c260d66e"; }];
    buildInputs = [ libunwind ];
  };

  "libc++abi" = fetch {
    pname       = "libc++abi";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libc++abi-10.0.1-1-any.pkg.tar.zst"; sha256 = "8c93d93f2d5c2cd0a731d4a55d5e66910b7a9cc47130385405c97c318c35147b"; }];
    buildInputs = [ libunwind ];
  };

  "libcaca" = fetch {
    pname       = "libcaca";
    version     = "0.99.beta19";
    srcs        = [{ filename = "mingw-w64-x86_64-libcaca-0.99.beta19-5-any.pkg.tar.xz"; sha256 = "78347b5e3caa2595e3fbee59e421b53355767d1042a78dc8bebebff960ec787e"; }];
    buildInputs = [ fontconfig freetype zlib ];
  };

  "libcddb" = fetch {
    pname       = "libcddb";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libcddb-1.3.2-5-any.pkg.tar.xz"; sha256 = "9d3c06b71adbb42f30b6fb0fa21fc4bbf5b09f75da495fc166ab34c70c346b9e"; }];
    buildInputs = [ libsystre ];
  };

  "libcdio" = fetch {
    pname       = "libcdio";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libcdio-2.1.0-3-any.pkg.tar.xz"; sha256 = "58cd02cf8271386ce02e347cb7ef3f26e7593095fad9e2e03fee0154c1db206e"; }];
    buildInputs = [ libiconv libcddb ];
  };

  "libcdio-paranoia" = fetch {
    pname       = "libcdio-paranoia";
    version     = "10.2+2.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libcdio-paranoia-10.2+2.0.0-1-any.pkg.tar.xz"; sha256 = "2fdb9fe7915b085ccf53eddc9a61b769b7f42306e8ddf0a6fc597ab3243176db"; }];
    buildInputs = [ libcdio ];
  };

  "libcdr" = fetch {
    pname       = "libcdr";
    version     = "0.1.6";
    srcs        = [{ filename = "mingw-w64-x86_64-libcdr-0.1.6-3-any.pkg.tar.zst"; sha256 = "dd86d60a5197354fa7853973a67ea2eb90a746f693669252d5d001c021119233"; }];
    buildInputs = [ icu lcms2 librevenge zlib ];
  };

  "libcello-git" = fetch {
    pname       = "libcello-git";
    version     = "2.1.0.301.da28eef";
    srcs        = [{ filename = "mingw-w64-x86_64-libcello-git-2.1.0.301.da28eef-1-any.pkg.tar.xz"; sha256 = "0eb9400dabdeff26d53e6cfdbf83c1af5cb0edc9514e54333440707c6c5374e6"; }];
  };

  "libcerf" = fetch {
    pname       = "libcerf";
    version     = "2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libcerf-2.0-1-any.pkg.tar.zst"; sha256 = "1a4f43fcde0f6b4cc79d7c046abb29f4b0b8393e820aacbbdd82da6927f1a01f"; }];
    buildInputs = [  ];
  };

  "libchamplain" = fetch {
    pname       = "libchamplain";
    version     = "0.12.20";
    srcs        = [{ filename = "mingw-w64-x86_64-libchamplain-0.12.20-1-any.pkg.tar.xz"; sha256 = "7f64dd73c3953064535a10b6cb1c02ec2aedd4109c3170200d21a1620d223782"; }];
    buildInputs = [ clutter clutter-gtk cairo libsoup memphis sqlite3 ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "libconfig" = fetch {
    pname       = "libconfig";
    version     = "1.7.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libconfig-1.7.2-1-any.pkg.tar.xz"; sha256 = "394fe391f3560233436a9f370c54ba9ecaa0da298d61780d69cc5fa636e68331"; }];
    buildInputs = [ gcc-libs ];
  };

  "libconfini" = fetch {
    pname       = "libconfini";
    version     = "1.15.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libconfini-1.15.0-1-any.pkg.tar.zst"; sha256 = "d419a1445b948c3ae52f73a2ba4c1d08d207a878c80f0453eea417b9fc5f5237"; }];
  };

  "libcue" = fetch {
    pname       = "libcue";
    version     = "2.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libcue-2.2.1-1-any.pkg.tar.xz"; sha256 = "cf7eb5351b8d4f5a42b5a7d91e33f867c3fbeb4c817a186d7b6ae5ce570f3cd1"; }];
  };

  "libdatrie" = fetch {
    pname       = "libdatrie";
    version     = "0.2.12";
    srcs        = [{ filename = "mingw-w64-x86_64-libdatrie-0.2.12-1-any.pkg.tar.xz"; sha256 = "600bc0ba61530fe7a96089d1d2011cf9a4de24a5c52ac61a38536b586a0e7a18"; }];
    buildInputs = [ libiconv ];
  };

  "libdazzle" = fetch {
    pname       = "libdazzle";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libdazzle-3.38.0-1-any.pkg.tar.zst"; sha256 = "224e41d6dd1d64a4bda2852a6fe8efae7466a291dc8ec92b743db44cfad735df"; }];
    buildInputs = [ glib2 ];
  };

  "libdca" = fetch {
    pname       = "libdca";
    version     = "0.0.7";
    srcs        = [{ filename = "mingw-w64-x86_64-libdca-0.0.7-1-any.pkg.tar.xz"; sha256 = "f5ab5f16c1fbcc2851f2caac28659a848fd4e776cc736a36d995bb52f14f0529"; }];
  };

  "libde265" = fetch {
    pname       = "libde265";
    version     = "1.0.7";
    srcs        = [{ filename = "mingw-w64-x86_64-libde265-1.0.7-1-any.pkg.tar.zst"; sha256 = "0414bdcb027be0e479c57a9a58eb90564f4d1f11b7e7a1152ae17067fdba0d43"; }];
    buildInputs = [ gcc-libs ];
  };

  "libdiscid" = fetch {
    pname       = "libdiscid";
    version     = "0.6.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libdiscid-0.6.2-1-any.pkg.tar.xz"; sha256 = "a8d91bf40fa33bb440a3cbd157e2836ea1e0dc176fa37d537c84bb7ff5a558a1"; }];
  };

  "libdsm" = fetch {
    pname       = "libdsm";
    version     = "0.3.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libdsm-0.3.2-1-any.pkg.tar.xz"; sha256 = "4bc93b637436885d296a600d611197dcb8faedf756c7549d8f44fd28a66f5b2d"; }];
    buildInputs = [ libtasn1 ];
  };

  "libdvbpsi" = fetch {
    pname       = "libdvbpsi";
    version     = "1.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libdvbpsi-1.3.3-1-any.pkg.tar.xz"; sha256 = "20798f6829f8ce83087a62e192e4190095f3511cc9f858e21ec8ce16e409cf11"; }];
    buildInputs = [ gcc-libs ];
  };

  "libdvdcss" = fetch {
    pname       = "libdvdcss";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libdvdcss-1.4.2-1-any.pkg.tar.xz"; sha256 = "bbffd69722cf9f4305dc71e22b661c8c1653f14f25f43c577119af391ce9078d"; }];
    buildInputs = [ gcc-libs ];
  };

  "libdvdnav" = fetch {
    pname       = "libdvdnav";
    version     = "6.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libdvdnav-6.1.0-2-any.pkg.tar.xz"; sha256 = "b9c76ce7579b5af3f2e36e88e97fa86ea73dccd9df9b1679e598964f113744ed"; }];
    buildInputs = [ libdvdread ];
  };

  "libdvdread" = fetch {
    pname       = "libdvdread";
    version     = "6.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libdvdread-6.1.1-1-any.pkg.tar.xz"; sha256 = "ab6e43b1a19c72f3691b8cb8f225eb5f664ce2dfefe8593e4278808af9229ff2"; }];
    buildInputs = [ libdvdcss ];
  };

  "libebml" = fetch {
    pname       = "libebml";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libebml-1.4.0-1-any.pkg.tar.zst"; sha256 = "6f2edd4381659bbfa15d80070c2e2ce7f4a9f218baae95ae8e6511a23d00f4cb"; }];
    buildInputs = [ gcc-libs ];
  };

  "libelf" = fetch {
    pname       = "libelf";
    version     = "0.8.13";
    srcs        = [{ filename = "mingw-w64-x86_64-libelf-0.8.13-4-any.pkg.tar.xz"; sha256 = "772e6c1e9dee676dbd9d4684045da1dece07cdd4870a3c1e4620d3b39f001062"; }];
    buildInputs = [  ];
  };

  "libepoxy" = fetch {
    pname       = "libepoxy";
    version     = "1.5.4";
    srcs        = [{ filename = "mingw-w64-x86_64-libepoxy-1.5.4-1-any.pkg.tar.xz"; sha256 = "204fb1633860adbb593278c3f5f845c46e25eedc3b2bbe2bed9ec7b13295dd01"; }];
    buildInputs = [ gcc-libs ];
  };

  "liberime" = fetch {
    pname       = "liberime";
    version     = "0.0.5";
    srcs        = [{ filename = "mingw-w64-x86_64-liberime-0.0.5-2-any.pkg.tar.xz"; sha256 = "c5d3b219218432fd95bd3c49c96828cc221a63a1e90608383782712dd344bb56"; }];
    buildInputs = [ librime ];
  };

  "libevent" = fetch {
    pname       = "libevent";
    version     = "2.1.12";
    srcs        = [{ filename = "mingw-w64-x86_64-libevent-2.1.12-1-any.pkg.tar.zst"; sha256 = "da7f7cae68cab3afae41ec733d46fe5eac3aed5df5239c81c0e988f8efc6ba02"; }];
  };

  "libexif" = fetch {
    pname       = "libexif";
    version     = "0.6.22";
    srcs        = [{ filename = "mingw-w64-x86_64-libexif-0.6.22-1-any.pkg.tar.zst"; sha256 = "82ed542fc344109acbd27cf45a70bbd24654bc8a3d1c7d882e8914d9b519933a"; }];
    buildInputs = [ gettext ];
  };

  "libffi" = fetch {
    pname       = "libffi";
    version     = "3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libffi-3.3-1-any.pkg.tar.xz"; sha256 = "ad933888ccf421e341fa6de179c66ba40ea509f8c4f9c4e55d2b9c9039445017"; }];
    buildInputs = [  ];
  };

  "libfilezilla" = fetch {
    pname       = "libfilezilla";
    version     = "0.21.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libfilezilla-0.21.0-1-any.pkg.tar.zst"; sha256 = "440c8de68e6b1e33d6d952342fff4ed8de6759ee01abfd360b2fe4d6620bc8c0"; }];
    buildInputs = [ gcc-libs nettle gnutls ];
  };

  "libfreexl" = fetch {
    pname       = "libfreexl";
    version     = "1.0.6";
    srcs        = [{ filename = "mingw-w64-x86_64-libfreexl-1.0.6-1-any.pkg.tar.zst"; sha256 = "314b7e6c8327aa74c2c036fcc4a4c469e187f6bb7f28c064d72275aa3aee37f7"; }];
    buildInputs = [  ];
  };

  "libftdi" = fetch {
    pname       = "libftdi";
    version     = "1.4";
    srcs        = [{ filename = "mingw-w64-x86_64-libftdi-1.4-3-any.pkg.tar.xz"; sha256 = "696185e5d35ba29bbdc2b9d7f6f38fb3add228820494220b214560753605a3ba"; }];
    buildInputs = [ libusb confuse gettext libiconv ];
  };

  "libgadu" = fetch {
    pname       = "libgadu";
    version     = "1.12.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libgadu-1.12.2-1-any.pkg.tar.xz"; sha256 = "f5609fc8c1bcdfbbcb3ccadf73954e80a1da796a79196ae2520fad21ffe171d8"; }];
    buildInputs = [ gnutls protobuf-c ];
  };

  "libgcrypt" = fetch {
    pname       = "libgcrypt";
    version     = "1.8.6";
    srcs        = [{ filename = "mingw-w64-x86_64-libgcrypt-1.8.6-1-any.pkg.tar.zst"; sha256 = "6528ccf06e5c7a97a766f17e69abd96cefa5cdd21f3eb50c7294c9b12d2e31fe"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libgd" = fetch {
    pname       = "libgd";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libgd-2.3.0-3-any.pkg.tar.zst"; sha256 = "f889eeded27a2d47de6cc9c5f3377702c35d541b3e452764fee7f2b12aeac16d"; }];
    buildInputs = [ libpng libiconv libjpeg libtiff freetype fontconfig libimagequant libwebp xpm-nox zlib ];
  };

  "libgda" = fetch {
    pname       = "libgda";
    version     = "5.2.9";
    srcs        = [{ filename = "mingw-w64-x86_64-libgda-5.2.9-1-any.pkg.tar.xz"; sha256 = "d07e8d6a2cb5a6a3cc1be3121fe88db1669644fda5c84e226b7862091aae542e"; }];
    buildInputs = [ gtk3 gtksourceview3 goocanvas iso-codes json-glib libsoup libxml2 libxslt glade ];
  };

  "libgdata" = fetch {
    pname       = "libgdata";
    version     = "0.17.12";
    srcs        = [{ filename = "mingw-w64-x86_64-libgdata-0.17.12-1-any.pkg.tar.xz"; sha256 = "bc257366ab362e8d737fa9d1bfe3346fc220a69ff82cdc7962d5cac8ec6aeaed"; }];
    buildInputs = [ glib2 gtk3 json-glib liboauth libsoup libxml2 ];
  };

  "libgdiplus" = fetch {
    pname       = "libgdiplus";
    version     = "5.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libgdiplus-5.6.1-1-any.pkg.tar.xz"; sha256 = "973dec9e9178b3a27fb925ea4a9c86cafa991e888cacce5f36ba5f78d0b2c701"; }];
    buildInputs = [ libtiff cairo fontconfig freetype giflib glib2 libexif libpng zlib ];
  };

  "libgee" = fetch {
    pname       = "libgee";
    version     = "0.20.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libgee-0.20.3-1-any.pkg.tar.xz"; sha256 = "2484c36526a9b0b71229f665628cf91d4ebd9e070c2c34aafb4bce550c161ac1"; }];
    buildInputs = [ glib2 ];
  };

  "libgeotiff" = fetch {
    pname       = "libgeotiff";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libgeotiff-1.6.0-1-any.pkg.tar.zst"; sha256 = "280967576f919e1ee516e277ae11b95e2894b28ae4f6eb5f04191f485b5af532"; }];
    buildInputs = [ gcc-libs libtiff libjpeg proj zlib ];
  };

  "libgit2" = fetch {
    pname       = "libgit2";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libgit2-1.1.0-1-any.pkg.tar.zst"; sha256 = "233436c8639fdb980644dcea52bfcf522aab8be39f57f9518fa926b8d60c6668"; }];
    buildInputs = [ curl http-parser libssh2 openssl zlib ];
  };

  "libgit2-glib" = fetch {
    pname       = "libgit2-glib";
    version     = "0.99.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libgit2-glib-0.99.0.1-1-any.pkg.tar.xz"; sha256 = "3bff01279c052c601a9eae55691cbc478baaf888b10a04bebcb83f77946133d6"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libgit2.version "0.99"; libgit2) libssh2 glib2 ];
  };

  "libglade" = fetch {
    pname       = "libglade";
    version     = "2.6.4";
    srcs        = [{ filename = "mingw-w64-x86_64-libglade-2.6.4-5-any.pkg.tar.xz"; sha256 = "03471470d46b5ea62cd0824cd50c3dd71765690e8d46cfd519a5b36245374515"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gtk2.version "2.16.0"; gtk2) (assert stdenvNoCC.lib.versionAtLeast libxml2.version "2.7.3"; libxml2) ];
  };

  "libgme" = fetch {
    pname       = "libgme";
    version     = "0.6.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libgme-0.6.3-1-any.pkg.tar.zst"; sha256 = "80a17679a78e6b4ace5b72d88bba9ea6a279ebeef99e6186e0e3a4b8779b08bb"; }];
    buildInputs = [ gcc-libs ];
  };

  "libgnomecanvas" = fetch {
    pname       = "libgnomecanvas";
    version     = "2.30.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libgnomecanvas-2.30.3-3-any.pkg.tar.xz"; sha256 = "83e412ef86d9f12d076461dbf84dbad326318623079f5455458911d725d720de"; }];
    buildInputs = [ gtk2 gettext libart_lgpl libglade ];
  };

  "libgnurx" = fetch {
    pname       = "libgnurx";
    version     = "2.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libgnurx-2.5.1-2-any.pkg.tar.zst"; sha256 = "df3b845769d8068f96eef87e9977591c760a47d5bd3f5c47a88e52018a29cc64"; }];
  };

  "libgoom2" = fetch {
    pname       = "libgoom2";
    version     = "2k4";
    srcs        = [{ filename = "mingw-w64-x86_64-libgoom2-2k4-3-any.pkg.tar.xz"; sha256 = "a6bb14d7a956cd745b93d2b9f44ef576d0fb43bca2c9c2df4957ad6876e76652"; }];
    buildInputs = [ gcc-libs ];
  };

  "libgpg-error" = fetch {
    pname       = "libgpg-error";
    version     = "1.39";
    srcs        = [{ filename = "mingw-w64-x86_64-libgpg-error-1.39-1-any.pkg.tar.zst"; sha256 = "9df9be7a283d3c5ffc6d45274d9108ab252f4bb065c0d1bf2d2caaad8bec9e67"; }];
    buildInputs = [ gcc-libs gettext ];
  };

  "libgphoto2" = fetch {
    pname       = "libgphoto2";
    version     = "2.5.23";
    srcs        = [{ filename = "mingw-w64-x86_64-libgphoto2-2.5.23-2-any.pkg.tar.zst"; sha256 = "53d9fe211eee67153758fa97a6d216ae2972bc7a091bc0ccff6abf0b38b0c116"; }];
    buildInputs = [ libsystre libjpeg libxml2 libgd libexif libusb libtool ];
  };

  "libgsf" = fetch {
    pname       = "libgsf";
    version     = "1.14.47";
    srcs        = [{ filename = "mingw-w64-x86_64-libgsf-1.14.47-1-any.pkg.tar.zst"; sha256 = "853b445ac508558ad8cfe36c64ee988cabc7b62dd24e6027f966fb421f8d8356"; }];
    buildInputs = [ glib2 gdk-pixbuf2 libxml2 zlib ];
  };

  "libguess" = fetch {
    pname       = "libguess";
    version     = "1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libguess-1.2-3-any.pkg.tar.xz"; sha256 = "240ee03e504d08e428943f5e7b61a7055331300ddd4c7800008ca43c62774b77"; }];
    buildInputs = [ libmowgli ];
  };

  "libgusb" = fetch {
    pname       = "libgusb";
    version     = "0.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libgusb-0.3.3-1-any.pkg.tar.xz"; sha256 = "8e0a763621b23fe37fe9402adaf22e67a4c31cbdcf9293917284848b70f36d13"; }];
    buildInputs = [ libusb glib2 ];
  };

  "libgweather" = fetch {
    pname       = "libgweather";
    version     = "3.36.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libgweather-3.36.1-1-any.pkg.tar.zst"; sha256 = "e9bb19dffe266b6aedc453d0d4f5a2641673ab47b8b8a0f2a9265e7a1ac86880"; }];
    buildInputs = [ gtk3 libsoup libsystre libxml2 geocode-glib ];
  };

  "libgxps" = fetch {
    pname       = "libgxps";
    version     = "0.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libgxps-0.3.1-1-any.pkg.tar.xz"; sha256 = "4e0a8cc5b03a855bb5f40ca62d6f8adc6ae6047ae1349ea65ca738280cab0751"; }];
    buildInputs = [ glib2 gtk3 cairo lcms2 libarchive libjpeg libxslt libpng ];
  };

  "libhandy" = fetch {
    pname       = "libhandy";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libhandy-1.0.0-1-any.pkg.tar.zst"; sha256 = "d465572387b68efb66ac42a2d4a4fa10000cdb875fa1803098bbe5f520bf61d4"; }];
    buildInputs = [ glib2 gtk3 ];
  };

  "libharu" = fetch {
    pname       = "libharu";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libharu-2.3.0-2-any.pkg.tar.xz"; sha256 = "9df90f28385d81634129630e8792cb594edf9d899807893caf2fbea3b5d343d1"; }];
    buildInputs = [ libpng ];
  };

  "libheif" = fetch {
    pname       = "libheif";
    version     = "1.9.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libheif-1.9.1-1-any.pkg.tar.zst"; sha256 = "b3d6c356f255c6a91de828cfa323cef0fc2908a7159275528ce23789b003368e"; }];
    buildInputs = [ gcc-libs libde265 libjpeg-turbo libpng aom libwinpthread-git x265 ];
  };

  "libical" = fetch {
    pname       = "libical";
    version     = "3.0.8";
    srcs        = [{ filename = "mingw-w64-x86_64-libical-3.0.8-3-any.pkg.tar.zst"; sha256 = "2c57a4e940b1aa1b83a003c51755a222fdb486e5adb6b9ffa396bdb3ff3daa1a"; }];
    buildInputs = [ gcc-libs icu glib2 gobject-introspection libxml2 db ];
  };

  "libiconv" = fetch {
    pname       = "libiconv";
    version     = "1.16";
    srcs        = [{ filename = "mingw-w64-x86_64-libiconv-1.16-1-any.pkg.tar.xz"; sha256 = "b37b013727b16a90095deb90cecdc073c5bb8dde26886448e2cbf357b29c1271"; }];
    buildInputs = [  ];
  };

  "libicsneo" = fetch {
    pname       = "libicsneo";
    version     = "0.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libicsneo-0.1.2-2-any.pkg.tar.zst"; sha256 = "cc0c7401a0a9b3167cb767caa8035ed943cd32d70a85dcd28cab871882d37a51"; }];
    buildInputs = [ gcc-libs ];
  };

  "libid3tag" = fetch {
    pname       = "libid3tag";
    version     = "0.15.1b";
    srcs        = [{ filename = "mingw-w64-x86_64-libid3tag-0.15.1b-2-any.pkg.tar.zst"; sha256 = "3f384bf1ebdf391932606e0c63533a01ba7c906c7d804e27cb30eae264e2fcb3"; }];
    buildInputs = [ gcc-libs ];
  };

  "libidl2" = fetch {
    pname       = "libidl2";
    version     = "0.8.14";
    srcs        = [{ filename = "mingw-w64-x86_64-libidl2-0.8.14-1-any.pkg.tar.xz"; sha256 = "470c56c36685f4aea48e9bc3d2a437f00cf66c6e77d5dbf99e09d55d2468982e"; }];
    buildInputs = [ glib2 ];
  };

  "libidn" = fetch {
    pname       = "libidn";
    version     = "1.36";
    srcs        = [{ filename = "mingw-w64-x86_64-libidn-1.36-1-any.pkg.tar.zst"; sha256 = "32c58c1175e8ef20976f153bc70efee126227fb7ee4d5283d33e209fa513be72"; }];
    buildInputs = [ gettext ];
  };

  "libidn2" = fetch {
    pname       = "libidn2";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libidn2-2.3.0-1-any.pkg.tar.xz"; sha256 = "52623813f26d02da371f9e8ab3c64761933526bf2138f3e301b80d5c701ba218"; }];
    buildInputs = [ gettext libunistring ];
  };

  "libilbc" = fetch {
    pname       = "libilbc";
    version     = "2.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libilbc-2.0.2-1-any.pkg.tar.xz"; sha256 = "8da0f51035ddd18060ee5d99531852004b1cdba339798e9bcc213173d782e3a1"; }];
  };

  "libimagequant" = fetch {
    pname       = "libimagequant";
    version     = "2.12.6";
    srcs        = [{ filename = "mingw-w64-x86_64-libimagequant-2.12.6-1-any.pkg.tar.xz"; sha256 = "c54f9e431a86d322252821296f965479047aca841471d2a0442abafc21afcff6"; }];
    buildInputs = [  ];
  };

  "libimobiledevice" = fetch {
    pname       = "libimobiledevice";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libimobiledevice-1.2.0-2-any.pkg.tar.zst"; sha256 = "a958946ab14595cf3cdf11a0d6ad4cb263609442c9395a624fa8d06d0353aa3d"; }];
    buildInputs = [ libusbmuxd libplist openssl ];
  };

  "libjaylink-git" = fetch {
    pname       = "libjaylink-git";
    version     = "r175.cfccbc9";
    srcs        = [{ filename = "mingw-w64-x86_64-libjaylink-git-r175.cfccbc9-1-any.pkg.tar.xz"; sha256 = "e0ad84f5f0cd334ed24c29e851eebfe5466cab0807f7f10602c0affb1d4e7bb9"; }];
    buildInputs = [ libusb ];
  };

  "libjpeg-turbo" = fetch {
    pname       = "libjpeg-turbo";
    version     = "2.0.5";
    srcs        = [{ filename = "mingw-w64-x86_64-libjpeg-turbo-2.0.5-1-any.pkg.tar.zst"; sha256 = "33e473fa12e0a4433b62e2fda634a3bc4910a5eb75435feab9cc10fefe73ecb5"; }];
    buildInputs = [ gcc-libs ];
  };

  "libkml" = fetch {
    pname       = "libkml";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libkml-1.3.0-8-any.pkg.tar.xz"; sha256 = "863be7c469b3511525bda0d9c23db38c661dcc99d896d988a84046a6c0500d6b"; }];
    buildInputs = [ boost minizip-git uriparser zlib ];
  };

  "libksba" = fetch {
    pname       = "libksba";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libksba-1.4.0-1-any.pkg.tar.zst"; sha256 = "efa6cbfa7ba13fc6ce591917f8f49f2ab7c43fa000837ae91f7797e048fadd03"; }];
    buildInputs = [ libgpg-error ];
  };

  "liblas" = fetch {
    pname       = "liblas";
    version     = "1.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-liblas-1.8.1-2-any.pkg.tar.zst"; sha256 = "ef52c687efc6fd7492c301e073f77437340132fb19c6b656e53f298a0af52d30"; }];
    buildInputs = [ gdal laszip ];
  };

  "liblastfm" = fetch {
    pname       = "liblastfm";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-x86_64-liblastfm-1.0.9-2-any.pkg.tar.xz"; sha256 = "992cf3d9a6fe12e85a013feb87de9ba0e4240eec68171e8333fd97de2209ad07"; }];
    buildInputs = [ qt5 fftw libsamplerate ];
  };

  "liblqr" = fetch {
    pname       = "liblqr";
    version     = "0.4.2";
    srcs        = [{ filename = "mingw-w64-x86_64-liblqr-0.4.2-4-any.pkg.tar.xz"; sha256 = "cfd99e8e0821da2b0a69cd7736e85e42f7c6e88d819617b764ec02094bce4644"; }];
    buildInputs = [ glib2 ];
  };

  "libmad" = fetch {
    pname       = "libmad";
    version     = "0.15.1b";
    srcs        = [{ filename = "mingw-w64-x86_64-libmad-0.15.1b-4-any.pkg.tar.xz"; sha256 = "a2665598cb50e68d921d4a593c816b9a7f814d0aa076de4b378c779c09dc647f"; }];
    buildInputs = [  ];
  };

  "libmangle-git" = fetch {
    pname       = "libmangle-git";
    version     = "9.0.0.6029.ecb4ff54";
    srcs        = [{ filename = "mingw-w64-x86_64-libmangle-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "433ad4b0b806c1295f455a8b961e6bea0d1b38b1857498d24763d3e9aa1fbd52"; }];
  };

  "libmariadbclient" = fetch {
    pname       = "libmariadbclient";
    version     = "3.1.7";
    srcs        = [{ filename = "mingw-w64-x86_64-libmariadbclient-3.1.7-2-any.pkg.tar.zst"; sha256 = "a86162e4799cc4bb8885b3511731c126c919a40d728b7632fa853ea59a4dad05"; }];
    buildInputs = [ gcc-libs curl zlib ];
  };

  "libmatroska" = fetch {
    pname       = "libmatroska";
    version     = "1.6.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libmatroska-1.6.2-1-any.pkg.tar.zst"; sha256 = "c4777bf324dcc607d4e966e375a1a5ab7ff4c51c448911fa010d9af47b115284"; }];
    buildInputs = [ libebml ];
  };

  "libmaxminddb" = fetch {
    pname       = "libmaxminddb";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libmaxminddb-1.3.2-1-any.pkg.tar.xz"; sha256 = "285079dc6f44198462ef992b0692ba7b2699bd9390e53b86765109b9725751e5"; }];
    buildInputs = [ gcc-libs geoip2-database ];
  };

  "libmetalink" = fetch {
    pname       = "libmetalink";
    version     = "0.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libmetalink-0.1.3-3-any.pkg.tar.xz"; sha256 = "b2340432e10a0296b1765b743c50b6617cb8cd1bd5f78f693f2bd7ce9edf72db"; }];
    buildInputs = [ gcc-libs expat ];
  };

  "libmfx" = fetch {
    pname       = "libmfx";
    version     = "1.25";
    srcs        = [{ filename = "mingw-w64-x86_64-libmfx-1.25-1-any.pkg.tar.xz"; sha256 = "1e07a220c2dc6e4ebf5f5b365c42c3b81661b78996dc834cde039f545c195166"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmicrodns" = fetch {
    pname       = "libmicrodns";
    version     = "0.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libmicrodns-0.2.0-1-any.pkg.tar.zst"; sha256 = "bd7720035a6f6b6d480320f73902f7175bc3a31a470fe55b5652e77cef3919a8"; }];
    buildInputs = [ libtasn1 ];
  };

  "libmicrohttpd" = fetch {
    pname       = "libmicrohttpd";
    version     = "0.9.71";
    srcs        = [{ filename = "mingw-w64-x86_64-libmicrohttpd-0.9.71-1-any.pkg.tar.zst"; sha256 = "4833f355a5c173a418db7921a3ef4bfb0aebad2d696fa9571a94803c258d1eef"; }];
    buildInputs = [ gnutls ];
  };

  "libmicroutils" = fetch {
    pname       = "libmicroutils";
    version     = "4.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libmicroutils-4.3.0-1-any.pkg.tar.xz"; sha256 = "bbf74a0012a72a9651f43ba5342f502609b68c2cff03d6a50259fd3f6a07e524"; }];
    buildInputs = [ libsystre ];
  };

  "libmikmod" = fetch {
    pname       = "libmikmod";
    version     = "3.3.11.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libmikmod-3.3.11.1-1-any.pkg.tar.xz"; sha256 = "52f6f0a92cf07c0f3deb6e7eb42c198ca54b5b1f7009d8cd87a12fd1804d8b3e"; }];
    buildInputs = [ gcc-libs openal ];
  };

  "libmimic" = fetch {
    pname       = "libmimic";
    version     = "1.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-libmimic-1.0.4-3-any.pkg.tar.xz"; sha256 = "288ec145f65d72ae17d1dc990742ed806231acc04c126a76b0ce2e199e35a821"; }];
    buildInputs = [ glib2 ];
  };

  "libmng" = fetch {
    pname       = "libmng";
    version     = "2.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libmng-2.0.3-4-any.pkg.tar.xz"; sha256 = "db46c7eef283d424b0886c5ef13b462f4671cc666204d45cb0fad4dbfa662950"; }];
    buildInputs = [ libjpeg-turbo lcms2 zlib ];
  };

  "libmodbus-git" = fetch {
    pname       = "libmodbus-git";
    version     = "658.0e2f470";
    srcs        = [{ filename = "mingw-w64-x86_64-libmodbus-git-658.0e2f470-1-any.pkg.tar.xz"; sha256 = "2faec3be8e3fef5bcf3212cd075cbce4df88395e53cb7b5808cb29d793ab58bc"; }];
  };

  "libmodplug" = fetch {
    pname       = "libmodplug";
    version     = "0.8.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libmodplug-0.8.9.0-1-any.pkg.tar.xz"; sha256 = "1b010f32a6cc636aca15f7dca479367f2c9278c073fe76f6991fec06c4df3f0d"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmongoose" = fetch {
    pname       = "libmongoose";
    version     = "6.14";
    srcs        = [{ filename = "mingw-w64-x86_64-libmongoose-6.14-1-any.pkg.tar.xz"; sha256 = "57e3729ab542dac9c596e96ea4bbb6b0ce470ec949a09dbd0ecdde849a5365bc"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmowgli" = fetch {
    pname       = "libmowgli";
    version     = "2.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libmowgli-2.1.3-3-any.pkg.tar.xz"; sha256 = "4667f48da94738e673d1a82c624b41ab36d493926e6b25811a18c5dd72b0846d"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmpack" = fetch {
    pname       = "libmpack";
    version     = "1.0.5";
    srcs        = [{ filename = "mingw-w64-x86_64-libmpack-1.0.5-1-any.pkg.tar.xz"; sha256 = "b68eefbf1a96d51246187489ee91624c6e6a03543a1b21fafa7d9f78bad0e48b"; }];
  };

  "libmpcdec" = fetch {
    pname       = "libmpcdec";
    version     = "1.2.6";
    srcs        = [{ filename = "mingw-w64-x86_64-libmpcdec-1.2.6-3-any.pkg.tar.xz"; sha256 = "84b88d42da2bf41dec4dfb2561570eee2226163f221a66070f8f41b32917ba3a"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmpeg2-git" = fetch {
    pname       = "libmpeg2-git";
    version     = "r1108.946bf4b";
    srcs        = [{ filename = "mingw-w64-x86_64-libmpeg2-git-r1108.946bf4b-1-any.pkg.tar.xz"; sha256 = "4deffe098a796e0f6e69ad096beabbbcab466c34658cf43d4a9a02a5655e9368"; }];
    buildInputs = [ gcc-libs ];
  };

  "libmypaint" = fetch {
    pname       = "libmypaint";
    version     = "1.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libmypaint-1.5.1-2-any.pkg.tar.zst"; sha256 = "68118d32962e2433feb09e167a781834acfa416acd49fd09c4b4b757cd959a36"; }];
    buildInputs = [ gcc-libs glib2 json-c ];
  };

  "libmysofa" = fetch {
    pname       = "libmysofa";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libmysofa-1.1-1-any.pkg.tar.zst"; sha256 = "1b0ad3a461d992c370978f4a821e758619f30e44b1d5fe5d2fea30ba49a3bcdd"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "libnfs" = fetch {
    pname       = "libnfs";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libnfs-4.0.0-1-any.pkg.tar.xz"; sha256 = "0c16914d12d6e2cb5c8c22b34c7b01a3883ab6df149b5be58a0146ee4933db5b"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnice" = fetch {
    pname       = "libnice";
    version     = "0.1.17";
    srcs        = [{ filename = "mingw-w64-x86_64-libnice-0.1.17-1-any.pkg.tar.zst"; sha256 = "fcba6ab4409d1ade1811f3083601bc0b9a085e21d6f24adfb01bffec5b587921"; }];
    buildInputs = [ glib2 gnutls ];
  };

  "libnotify" = fetch {
    pname       = "libnotify";
    version     = "0.7.8";
    srcs        = [{ filename = "mingw-w64-x86_64-libnotify-0.7.8-2-any.pkg.tar.xz"; sha256 = "fbba3db83f384839435ea9ae4aebfb9e5aaa0958dce8d7cdd5da8c8a77e9af36"; }];
    buildInputs = [ gdk-pixbuf2 glib2 ];
  };

  "libnova" = fetch {
    pname       = "libnova";
    version     = "0.15.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libnova-0.15.0-1-any.pkg.tar.xz"; sha256 = "8c76c8bea55e88e0cecdc049ecc1ca50fb2302ad97d3096f682a93cf7c595c5b"; }];
  };

  "libntlm" = fetch {
    pname       = "libntlm";
    version     = "1.6";
    srcs        = [{ filename = "mingw-w64-x86_64-libntlm-1.6-1-any.pkg.tar.zst"; sha256 = "96330278c3332c8801c3b902b2bdaa6f245a179c0fb94fa151ac27ea1c30c139"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnumbertext" = fetch {
    pname       = "libnumbertext";
    version     = "1.0.6";
    srcs        = [{ filename = "mingw-w64-x86_64-libnumbertext-1.0.6-1-any.pkg.tar.zst"; sha256 = "bd88b036865ba50c2f55cce6640899c6beb8a31f78076a313e9bff1494a5c08d"; }];
    buildInputs = [ gcc-libs ];
  };

  "liboauth" = fetch {
    pname       = "liboauth";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-liboauth-1.0.3-6-any.pkg.tar.xz"; sha256 = "3003fd232ac3881b3686f00f748d79f30714ee347f287fe87553d73974e64256"; }];
    buildInputs = [ curl nss ];
  };

  "libodfgen" = fetch {
    pname       = "libodfgen";
    version     = "0.1.7";
    srcs        = [{ filename = "mingw-w64-x86_64-libodfgen-0.1.7-1-any.pkg.tar.xz"; sha256 = "71530d58644bb0b656447eb6056f9bedf2a8100d09b77a44c52d264a8480c5d7"; }];
    buildInputs = [ librevenge ];
  };

  "libogg" = fetch {
    pname       = "libogg";
    version     = "1.3.4";
    srcs        = [{ filename = "mingw-w64-x86_64-libogg-1.3.4-3-any.pkg.tar.xz"; sha256 = "5a56b02f6645cfd2a44b3885762866cfbc3c362af2141b4a1c907b26a451e64d"; }];
    buildInputs = [  ];
  };

  "libopusenc" = fetch {
    pname       = "libopusenc";
    version     = "0.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libopusenc-0.2.1-1-any.pkg.tar.xz"; sha256 = "fd46e5e1c518e5dc8c08c5c3eb3bf0b7f6254598f362fcd19278f55d44976b2d"; }];
    buildInputs = [ gcc-libs opus ];
  };

  "libosmpbf-git" = fetch {
    pname       = "libosmpbf-git";
    version     = "1.3.3.13.g4edb4f0";
    srcs        = [{ filename = "mingw-w64-x86_64-libosmpbf-git-1.3.3.13.g4edb4f0-1-any.pkg.tar.xz"; sha256 = "41c2884d8aa7b9a9fcd558d73c207559ce6f524f1bd517ab5efd815c98ed7016"; }];
    buildInputs = [ protobuf ];
  };

  "libosmscout" = fetch {
    pname       = "libosmscout";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libosmscout-1.0.1-1-any.pkg.tar.zst"; sha256 = "b2f5a3702ce7f884fdd9beb78930440233d3e1a989ba5960cdaf55717f739211"; }];
    buildInputs = [ protobuf qt5 ];
  };

  "libotr" = fetch {
    pname       = "libotr";
    version     = "4.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libotr-4.1.1-2-any.pkg.tar.xz"; sha256 = "edbe1b14cf18210662165703b06b9f2d433959f1a2b1ac8ac6c9132870f8dc09"; }];
    buildInputs = [ libgcrypt ];
  };

  "libpaper" = fetch {
    pname       = "libpaper";
    version     = "1.1.28";
    srcs        = [{ filename = "mingw-w64-x86_64-libpaper-1.1.28-1-any.pkg.tar.xz"; sha256 = "59146a02479d3119240f6cc65ebde3109267d095a14d9166e0f6a1788dc612a9"; }];
    buildInputs = [  ];
  };

  "libpeas" = fetch {
    pname       = "libpeas";
    version     = "1.28.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libpeas-1.28.0-1-any.pkg.tar.zst"; sha256 = "72984d7794049cdb263c917878eed2b6ca372d157b957ef1c19aae5ed1bed237"; }];
    buildInputs = [ gcc-libs gtk3 adwaita-icon-theme ];
  };

  "libplacebo" = fetch {
    pname       = "libplacebo";
    version     = "1.29.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libplacebo-1.29.1-1-any.pkg.tar.xz"; sha256 = "bf8bd1c62adf6359c5d560bf91e789c95782f82c86de6276d13e69a95d4fdc4c"; }];
    buildInputs = [ vulkan spirv-tools ];
  };

  "libplist" = fetch {
    pname       = "libplist";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libplist-2.2.0-1-any.pkg.tar.zst"; sha256 = "7c9261285f6916bc4ace671e4696728d35727035b43c350fd3891ed29606af36"; }];
    buildInputs = [ libxml2 cython ];
  };

  "libpng" = fetch {
    pname       = "libpng";
    version     = "1.6.37";
    srcs        = [{ filename = "mingw-w64-x86_64-libpng-1.6.37-3-any.pkg.tar.xz"; sha256 = "3cc662d7b2d739220b4631fddbb3660aaaec6d1985ee147de311e7fcddf84b22"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "libproxy" = fetch {
    pname       = "libproxy";
    version     = "0.4.15";
    srcs        = [{ filename = "mingw-w64-x86_64-libproxy-0.4.15-4-any.pkg.tar.zst"; sha256 = "63a6fc0de6f990112117bfbdaf2da79266e38394141e342dd7875b432ca4eadf"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpsl" = fetch {
    pname       = "libpsl";
    version     = "0.21.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libpsl-0.21.1-1-any.pkg.tar.zst"; sha256 = "43443336b70a89b4aca6e89cd7df185b47c78b0ebeb1eff704553e3d01bbb932"; }];
    buildInputs = [ libiconv libidn2 libunistring gettext ];
  };

  "libraqm" = fetch {
    pname       = "libraqm";
    version     = "0.7.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libraqm-0.7.0-1-any.pkg.tar.xz"; sha256 = "9d32d189c7ca56f78c7914ed8144411a095f8f2da6b231fc2acc976158585b34"; }];
    buildInputs = [ freetype glib2 harfbuzz fribidi ];
  };

  "libraw" = fetch {
    pname       = "libraw";
    version     = "0.20.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libraw-0.20.2-1-any.pkg.tar.zst"; sha256 = "e81d9bff6b27bbc553ee888642f0f01802135cba6ce7d384c80f8429e1e6df5c"; }];
    buildInputs = [ gcc-libs jasper lcms2 libjpeg zlib ];
  };

  "librdkafka" = fetch {
    pname       = "librdkafka";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-librdkafka-1.5.0-1-any.pkg.tar.zst"; sha256 = "ee0453c993af6dfbfe26b9782e23144ac2b3faef95f637a6eb921dbffb581180"; }];
    buildInputs = [ cyrus-sasl dlfcn lz4 openssl zlib zstd ];
  };

  "librescl" = fetch {
    pname       = "librescl";
    version     = "0.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-librescl-0.3.3-1-any.pkg.tar.xz"; sha256 = "32d83e1c3003cd9b86d733e0713ccf405a6df3fe9e30c2fb89f0078fd45037b7"; }];
    buildInputs = [ gcc-libs gettext (assert stdenvNoCC.lib.versionAtLeast glib2.version "2.34.0"; glib2) gobject-introspection gxml libgee libxml2 vala xz zlib ];
  };

  "libressl" = fetch {
    pname       = "libressl";
    version     = "3.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libressl-3.1.1-1-any.pkg.tar.zst"; sha256 = "9ce9c48fa7ca6f736d628874ea656ca58be599b74cf8401e15062b56f575aeb3"; }];
    buildInputs = [ gcc-libs ];
  };

  "librest" = fetch {
    pname       = "librest";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-librest-0.8.1-1-any.pkg.tar.xz"; sha256 = "1245e3bf2aca2b2b795670a0b74c364cc9496171617919bdaa3ac89c43367cf3"; }];
    buildInputs = [ glib2 libsoup libxml2 ];
  };

  "librevenge" = fetch {
    pname       = "librevenge";
    version     = "0.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-librevenge-0.0.4-2-any.pkg.tar.xz"; sha256 = "f9799b8bd0c4baace317c1549e4c19c80106f8f462b981c486bc08e0c8fb7944"; }];
    buildInputs = [ gcc-libs boost zlib ];
  };

  "librime" = fetch {
    pname       = "librime";
    version     = "1.5.3";
    srcs        = [{ filename = "mingw-w64-x86_64-librime-1.5.3-2-any.pkg.tar.xz"; sha256 = "4811dd1c6ea9932540070448bece3a5968252ec33dfe9890cc5abf1921b5573a"; }];
    buildInputs = [ boost leveldb marisa opencc yaml-cpp glog ];
  };

  "librime-data" = fetch {
    pname       = "librime-data";
    version     = "0.0.0.20190122";
    srcs        = [{ filename = "mingw-w64-x86_64-librime-data-0.0.0.20190122-1-any.pkg.tar.xz"; sha256 = "829dab3014ea6eb754f736a539f8f02feb39f1f5657ab443ef3e05a540ca8815"; }];
    buildInputs = [ rime-bopomofo rime-cangjie rime-essay rime-luna-pinyin rime-prelude rime-stroke rime-terra-pinyin ];
  };

  "librsvg" = fetch {
    pname       = "librsvg";
    version     = "2.48.8";
    srcs        = [{ filename = "mingw-w64-x86_64-librsvg-2.48.8-1-any.pkg.tar.zst"; sha256 = "308e2f5007946c44e0694b420c4812be2efcfa6e69bfc153a2007323e985b5eb"; }];
    buildInputs = [ gdk-pixbuf2 pango cairo libxml2 ];
  };

  "librsync" = fetch {
    pname       = "librsync";
    version     = "2.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-librsync-2.3.1-1-any.pkg.tar.zst"; sha256 = "663fb4d86bebe94660aac2d399f8cae9dfb05146b2d58b502fbdf5dfa8172eef"; }];
    buildInputs = [ gcc-libs popt ];
  };

  "libsamplerate" = fetch {
    pname       = "libsamplerate";
    version     = "0.1.9";
    srcs        = [{ filename = "mingw-w64-x86_64-libsamplerate-0.1.9-1-any.pkg.tar.xz"; sha256 = "89964b9e97c8474273cd1b543333f0045abb1fe444cf58e9e1a5a7aa95b42dd3"; }];
    buildInputs = [ libsndfile fftw ];
  };

  "libsass" = fetch {
    pname       = "libsass";
    version     = "3.6.4";
    srcs        = [{ filename = "mingw-w64-x86_64-libsass-3.6.4-1-any.pkg.tar.zst"; sha256 = "a62ffcccd34dcf9e6a36b4126c5c7127dd202968a5fd8c38b4c984c84ab48676"; }];
  };

  "libsbml" = fetch {
    pname       = "libsbml";
    version     = "5.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libsbml-5.18.0-1-any.pkg.tar.xz"; sha256 = "5ba33ec479e578854b7d81fdb5b308bdc5fcc85252018bc6509138627c196a08"; }];
    buildInputs = [ libxml2 ];
  };

  "libsecret" = fetch {
    pname       = "libsecret";
    version     = "0.20.4";
    srcs        = [{ filename = "mingw-w64-x86_64-libsecret-0.20.4-1-any.pkg.tar.zst"; sha256 = "ca86b9c18724b0854ad1967e5f2502094c062852d29cae6bdcc9dbff88c262c9"; }];
    buildInputs = [ glib2 libgcrypt ];
  };

  "libshout" = fetch {
    pname       = "libshout";
    version     = "2.4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libshout-2.4.3-1-any.pkg.tar.xz"; sha256 = "6521e94f1d9a6f3c5e2f46e265c7a3456f4d6548aab83f4cf30c736ae1ccc42c"; }];
    buildInputs = [ libvorbis libtheora openssl speex ];
  };

  "libsigc++" = fetch {
    pname       = "libsigc++";
    version     = "2.10.4";
    srcs        = [{ filename = "mingw-w64-x86_64-libsigc++-2.10.4-1-any.pkg.tar.zst"; sha256 = "43eb10936a386f8eeebad327d5c389a92df06c94c74bc075adc0e9bf9bb0bdaf"; }];
    buildInputs = [ gcc-libs ];
  };

  "libsigc++3" = fetch {
    pname       = "libsigc++3";
    version     = "3.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libsigc++3-3.0.3-1-any.pkg.tar.xz"; sha256 = "6317f0944904cb13ef3092c83b6d3f013c7b82cdf09e3a884ce4be56ead3d9ac"; }];
    buildInputs = [ gcc-libs ];
  };

  "libsignal-protocol-c-git" = fetch {
    pname       = "libsignal-protocol-c-git";
    version     = "r34.16bfd04";
    srcs        = [{ filename = "mingw-w64-x86_64-libsignal-protocol-c-git-r34.16bfd04-1-any.pkg.tar.xz"; sha256 = "408ec185b8c1efd6ab712b6b4bbb3255e3f4998bbebdc8eb546124353e292653"; }];
  };

  "libsigsegv" = fetch {
    pname       = "libsigsegv";
    version     = "2.12";
    srcs        = [{ filename = "mingw-w64-x86_64-libsigsegv-2.12-1-any.pkg.tar.xz"; sha256 = "dfdaf8a429de80c2b42d08e0e905b6a478f20c5e4b27900cc81cfba964739050"; }];
    buildInputs = [  ];
  };

  "libslirp" = fetch {
    pname       = "libslirp";
    version     = "4.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libslirp-4.3.1-1-any.pkg.tar.zst"; sha256 = "a1343347eea5dfedb2107cdd1cf2c0ecd44f5c301e4e5aab9b5b86196c45a62c"; }];
    buildInputs = [ glib2 ];
  };

  "libsndfile" = fetch {
    pname       = "libsndfile";
    version     = "1.0.30";
    srcs        = [{ filename = "mingw-w64-x86_64-libsndfile-1.0.30-1-any.pkg.tar.zst"; sha256 = "21e6e2be3192c8cf340d423740f1980ad0c79f12a5f5fe103c93c22a395a94d6"; }];
    buildInputs = [ flac libogg libvorbis opus ];
  };

  "libsodium" = fetch {
    pname       = "libsodium";
    version     = "1.0.18";
    srcs        = [{ filename = "mingw-w64-x86_64-libsodium-1.0.18-1-any.pkg.tar.xz"; sha256 = "afeb251a7de0ba4cd4c72a1e6de1a33c26e908cf88e38747a936975818274aac"; }];
    buildInputs = [ gcc-libs ];
  };

  "libsoup" = fetch {
    pname       = "libsoup";
    version     = "2.70.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libsoup-2.70.0-1-any.pkg.tar.xz"; sha256 = "93e8f7fd8a23d021da3662b5f0316c43b67510029942e68be2ef194e685d387c"; }];
    buildInputs = [ gcc-libs glib2 glib-networking libxml2 libpsl brotli sqlite3 ];
  };

  "libsoxr" = fetch {
    pname       = "libsoxr";
    version     = "0.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libsoxr-0.1.3-2-any.pkg.tar.zst"; sha256 = "05e64fbe98b55b4a8abd299459e56d949d699e2b8f5d094806150031b4f17b22"; }];
    buildInputs = [ gcc-libs ];
  };

  "libspatialite" = fetch {
    pname       = "libspatialite";
    version     = "4.3.0.a";
    srcs        = [{ filename = "mingw-w64-x86_64-libspatialite-4.3.0.a-4-any.pkg.tar.xz"; sha256 = "0638e188e0d985342279c6745c8b4c8a6efc0865efbe9ca00b99917fe2bfa984"; }];
    buildInputs = [ geos libfreexl libxml2 proj sqlite3 libiconv ];
  };

  "libspectre" = fetch {
    pname       = "libspectre";
    version     = "0.2.8";
    srcs        = [{ filename = "mingw-w64-x86_64-libspectre-0.2.8-2-any.pkg.tar.xz"; sha256 = "329bc9f2fbf00b797cba2bba120304f9b2b66e8c4a9b2c84b728a7ddede3c362"; }];
    buildInputs = [ ghostscript cairo ];
  };

  "libspiro" = fetch {
    pname       = "libspiro";
    version     = "1~20200505";
    srcs        = [{ filename = "mingw-w64-x86_64-libspiro-1~20200505-1-any.pkg.tar.zst"; sha256 = "f9b80dd7d243bb123b11cbcec7981d300110f2eb1d4150439c24769bd5ae8267"; }];
    buildInputs = [  ];
  };

  "libsquish" = fetch {
    pname       = "libsquish";
    version     = "1.15";
    srcs        = [{ filename = "mingw-w64-x86_64-libsquish-1.15-1-any.pkg.tar.xz"; sha256 = "34a010dfdb6f028837e0168a0fdd9e5ceaa30ee5ad99dc0ff8481c4d4ba45b37"; }];
    buildInputs = [  ];
  };

  "libsrtp" = fetch {
    pname       = "libsrtp";
    version     = "2.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libsrtp-2.3.0-1-any.pkg.tar.xz"; sha256 = "efe3d42bba94f4859068e37187c0dcd5b7ec77680ba04cadac35ea6047993005"; }];
    buildInputs = [ openssl ];
  };

  "libssh" = fetch {
    pname       = "libssh";
    version     = "0.9.5";
    srcs        = [{ filename = "mingw-w64-x86_64-libssh-0.9.5-1-any.pkg.tar.zst"; sha256 = "dbd866221b7c76e513c25c0f965dbc971ad7662ac08c3af463f2a45357f24ea8"; }];
    buildInputs = [ openssl zlib ];
  };

  "libssh2" = fetch {
    pname       = "libssh2";
    version     = "1.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libssh2-1.9.0-2-any.pkg.tar.zst"; sha256 = "ad1294063f1e36b3895a8d655303e250df86885babb6f0f995b588678c68adba"; }];
    buildInputs = [ openssl zlib ];
  };

  "libswift" = fetch {
    pname       = "libswift";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libswift-1.0.0-2-any.pkg.tar.xz"; sha256 = "32e77dcabe2f7a39a36d0a4faf7d06b4f080fd948f83096ef659c79e349ee106"; }];
    buildInputs = [ gcc-libs bzip2 libiconv libpng freetype glfw zlib ];
  };

  "libsystre" = fetch {
    pname       = "libsystre";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libsystre-1.0.1-4-any.pkg.tar.xz"; sha256 = "c1b9ae045e24a91f261dc654d390ac63254d0ca5882d76b52d7722a9d49fef0c"; }];
    buildInputs = [ libtre-git ];
  };

  "libtasn1" = fetch {
    pname       = "libtasn1";
    version     = "4.16.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libtasn1-4.16.0-1-any.pkg.tar.xz"; sha256 = "d0bb869cc2e8ef3b2696e3a2288e286503749d23b4a1789e2027d123c2f3f12b"; }];
    buildInputs = [ gcc-libs ];
  };

  "libthai" = fetch {
    pname       = "libthai";
    version     = "0.1.28";
    srcs        = [{ filename = "mingw-w64-x86_64-libthai-0.1.28-2-any.pkg.tar.xz"; sha256 = "08fccebf976d125581599188d648de4451b252e763a7b1ee973ebf4780a17f27"; }];
    buildInputs = [ libdatrie ];
  };

  "libtheora" = fetch {
    pname       = "libtheora";
    version     = "1.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libtheora-1.1.1-4-any.pkg.tar.xz"; sha256 = "2925a7af5cdcd21b62b71dfa4cf215a3da822ed61333ae9b5ce7dcfc81d6c34d"; }];
    buildInputs = [ libpng libogg libvorbis ];
  };

  "libtiff" = fetch {
    pname       = "libtiff";
    version     = "4.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libtiff-4.1.0-1-any.pkg.tar.xz"; sha256 = "cb714585bd811a74974a4524119d60572f6510c529d57df7054e1e8ebeaf4fc9"; }];
    buildInputs = [ gcc-libs libjpeg-turbo xz zlib zstd ];
  };

  "libtimidity" = fetch {
    pname       = "libtimidity";
    version     = "0.2.6";
    srcs        = [{ filename = "mingw-w64-x86_64-libtimidity-0.2.6-1-any.pkg.tar.xz"; sha256 = "5c4f3231b9541932a21f484259986b23684a24c33ae96dfe2c1c9e70aa9c709b"; }];
    buildInputs = [ gcc-libs ];
  };

  "libtommath" = fetch {
    pname       = "libtommath";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libtommath-1.2.0-1-any.pkg.tar.xz"; sha256 = "446a6de060e3960b642a306e84254a356092c8288ed1b8830c816b5f7c8b676c"; }];
  };

  "libtool" = fetch {
    pname       = "libtool";
    version     = "2.4.6";
    srcs        = [{ filename = "mingw-w64-x86_64-libtool-2.4.6-18-any.pkg.tar.zst"; sha256 = "9047a4e8b1bba6aa9a4da88d5998202e5d7fcf9e37f0c243ebbbcae44c7b2946"; }];
    buildInputs = [  ];
  };

  "libtorrent-rasterbar" = fetch {
    pname       = "libtorrent-rasterbar";
    version     = "1.2.10";
    srcs        = [{ filename = "mingw-w64-x86_64-libtorrent-rasterbar-1.2.10-1-any.pkg.tar.zst"; sha256 = "7d1191839d5e9cb77a9296601554b5857e1658acd37fa016f4987fb427dda1cd"; }];
    buildInputs = [ boost openssl ];
  };

  "libtre-git" = fetch {
    pname       = "libtre-git";
    version     = "r128.6fb7206";
    srcs        = [{ filename = "mingw-w64-x86_64-libtre-git-r128.6fb7206-2-any.pkg.tar.xz"; sha256 = "fd2c0e426a85c4193d34eea19411166495cb2fde58d0fac4e85422399062e336"; }];
    buildInputs = [ gcc-libs gettext ];
  };

  "libuninameslist" = fetch {
    pname       = "libuninameslist";
    version     = "20200413";
    srcs        = [{ filename = "mingw-w64-x86_64-libuninameslist-20200413-1-any.pkg.tar.zst"; sha256 = "423618eb9e80d3951b7673fd8e5cc48fe8af635fdbab9c9ff421fafe21de29f8"; }];
  };

  "libunistring" = fetch {
    pname       = "libunistring";
    version     = "0.9.10";
    srcs        = [{ filename = "mingw-w64-x86_64-libunistring-0.9.10-2-any.pkg.tar.zst"; sha256 = "bb0a51ba9f394a1d049ca6a21d42a5de49c83b9f2eb331abb009bdb9828c9028"; }];
    buildInputs = [ libiconv ];
  };

  "libunwind" = fetch {
    pname       = "libunwind";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libunwind-10.0.1-1-any.pkg.tar.zst"; sha256 = "7bfccf603368a1930c5cd92cb011174d807a75c5f534ed8e5dc4983391dc9b0a"; }];
    buildInputs = [ gcc ];
  };

  "libusb" = fetch {
    pname       = "libusb";
    version     = "1.0.23";
    srcs        = [{ filename = "mingw-w64-x86_64-libusb-1.0.23-1-any.pkg.tar.xz"; sha256 = "8d248ed33432e9ef20786960345f8e1c966997f12ba2549d0a3d37424a85f82b"; }];
    buildInputs = [  ];
  };

  "libusb-compat-git" = fetch {
    pname       = "libusb-compat-git";
    version     = "r76.b5db9d0";
    srcs        = [{ filename = "mingw-w64-x86_64-libusb-compat-git-r76.b5db9d0-1-any.pkg.tar.xz"; sha256 = "54974438dcd1ea093ced124ef4a31dac6048aeffdab05cd59e9da772bfc1b5ab"; }];
    buildInputs = [ libusb ];
  };

  "libusb-win32" = fetch {
    pname       = "libusb-win32";
    version     = "1.2.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libusb-win32-1.2.6.0-1-any.pkg.tar.zst"; sha256 = "a82e7a0540d2923acce32d528280f07bf8c5de566c22d5b8a3bf152f0a263fab"; }];
    buildInputs = [  ];
  };

  "libusbmuxd" = fetch {
    pname       = "libusbmuxd";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-libusbmuxd-2.0.1-1-any.pkg.tar.xz"; sha256 = "41ca1226faeb60d87897a978afc7204f633ede816814aafe31641b721633f8fa"; }];
    buildInputs = [ libplist ];
  };

  "libutf8proc" = fetch {
    pname       = "libutf8proc";
    version     = "2.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libutf8proc-2.5.0-1-any.pkg.tar.zst"; sha256 = "8b97d2e001d8cfb096de011c6933fc1eaf3fa414b88d464ee9b3f523af98cdb3"; }];
    buildInputs = [  ];
  };

  "libuv" = fetch {
    pname       = "libuv";
    version     = "1.40.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libuv-1.40.0-1-any.pkg.tar.zst"; sha256 = "1557ebc52e2792e714a8e6cee53b44d0e2ed7cd0858ace0b29d0ce9af80255c6"; }];
    buildInputs = [ gcc-libs ];
  };

  "libview" = fetch {
    pname       = "libview";
    version     = "0.6.6";
    srcs        = [{ filename = "mingw-w64-x86_64-libview-0.6.6-4-any.pkg.tar.xz"; sha256 = "3528154b01afdc47bd4a4296199ddcb29d45196ece546709ab317d94cbb40134"; }];
    buildInputs = [ gtk2 gtkmm ];
  };

  "libvips" = fetch {
    pname       = "libvips";
    version     = "8.10.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libvips-8.10.2-1-any.pkg.tar.zst"; sha256 = "008337f849f8ed9fd25500d81fb6f006774daccd979e8afcbe2ac1ed8567c45a"; }];
    buildInputs = [ cairo cfitsio fftw giflib glib2 gobject-introspection-runtime imagemagick lcms2 libexif libgsf libimagequant libpng librsvg libtiff libwebp matio opencl-icd-git openexr orc pango poppler ];
  };

  "libvirt" = fetch {
    pname       = "libvirt";
    version     = "5.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libvirt-5.9.0-1-any.pkg.tar.xz"; sha256 = "3688bab916079bb9e5b719eca6b124804cfa77a9edd6236a9579b013adb9a9a5"; }];
    buildInputs = [ curl gnutls gettext libgcrypt libgpg-error libxml2 portablexdr ];
  };

  "libvirt-glib" = fetch {
    pname       = "libvirt-glib";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libvirt-glib-3.0.0-1-any.pkg.tar.xz"; sha256 = "2d93737a081caf34fb843e9b68d2d588852dce5e2ed20ea0c8fe2dd53d599bfc"; }];
    buildInputs = [ glib2 libxml2 libvirt ];
  };

  "libvisio" = fetch {
    pname       = "libvisio";
    version     = "0.1.7";
    srcs        = [{ filename = "mingw-w64-x86_64-libvisio-0.1.7-4-any.pkg.tar.zst"; sha256 = "57aa7cf96e1f3ed314acaed9693e0c86e972852a5e578ff63ebde59b1bb84a9c"; }];
    buildInputs = [ icu libxml2 librevenge ];
  };

  "libvmime-git" = fetch {
    pname       = "libvmime-git";
    version     = "r1183.fe5492ce";
    srcs        = [{ filename = "mingw-w64-x86_64-libvmime-git-r1183.fe5492ce-2-any.pkg.tar.zst"; sha256 = "b7e217b89345e66de30f59afd74b890ef0ba37fbb304e95a39c0570d6944819c"; }];
    buildInputs = [ icu gnutls gsasl libiconv ];
  };

  "libvncserver" = fetch {
    pname       = "libvncserver";
    version     = "0.9.12";
    srcs        = [{ filename = "mingw-w64-x86_64-libvncserver-0.9.12-1-any.pkg.tar.xz"; sha256 = "eeca07d6983b7bf5aea298dc9eda646fc1f4d190f7f4dc908ac0aba3be34f683"; }];
    buildInputs = [ gcc-libs gnutls libpng libjpeg libgcrypt openssl ];
  };

  "libvoikko" = fetch {
    pname       = "libvoikko";
    version     = "4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libvoikko-4.3-1-any.pkg.tar.xz"; sha256 = "cbbd5ff7773af11cb8828e1d03db1d01b0702528c505d9ea2d0d89189340795e"; }];
    buildInputs = [ gcc-libs ];
  };

  "libvorbis" = fetch {
    pname       = "libvorbis";
    version     = "1.3.7";
    srcs        = [{ filename = "mingw-w64-x86_64-libvorbis-1.3.7-1-any.pkg.tar.zst"; sha256 = "81529429ebb58c5e5ba973729fe4c848f655f53bc01010efba26d768336ba1a6"; }];
    buildInputs = [ libogg gcc-libs ];
  };

  "libvorbisidec-svn" = fetch {
    pname       = "libvorbisidec-svn";
    version     = "r19643";
    srcs        = [{ filename = "mingw-w64-x86_64-libvorbisidec-svn-r19643-1-any.pkg.tar.xz"; sha256 = "eb76fda967692094cd4fbb93a2c6331ea61e56fd44d3b106d7055b3bcf6cc283"; }];
    buildInputs = [ libogg ];
  };

  "libvpx" = fetch {
    pname       = "libvpx";
    version     = "1.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libvpx-1.9.0-1-any.pkg.tar.zst"; sha256 = "04e7d42fee2276d35ede144fbe175f370df99c9a420e79aacf9e38f7ff28ea58"; }];
    buildInputs = [  ];
  };

  "libwebp" = fetch {
    pname       = "libwebp";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libwebp-1.1.0-1-any.pkg.tar.xz"; sha256 = "c11e0c7ed661fe284d5ddeb648020d11717575929f35e20050303f79f7386286"; }];
    buildInputs = [ giflib libjpeg-turbo libpng libtiff ];
  };

  "libwebsockets" = fetch {
    pname       = "libwebsockets";
    version     = "4.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libwebsockets-4.1.3-1-any.pkg.tar.zst"; sha256 = "3665c727798471210b62f02bd735c99f6a7bf1f6b7ab25275e3a3f71b4e3d271"; }];
    buildInputs = [ zlib openssl ];
  };

  "libwinpthread-git" = fetch {
    pname       = "libwinpthread-git";
    version     = "9.0.0.6029.ecb4ff54";
    srcs        = [{ filename = "mingw-w64-x86_64-libwinpthread-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "109fce785d5e4a8dd4c19cf0ca9bc95b82155d5379862dc97fe5bc611f7d96c0"; }];
    buildInputs = [  ];
  };

  "libwmf" = fetch {
    pname       = "libwmf";
    version     = "0.2.12";
    srcs        = [{ filename = "mingw-w64-x86_64-libwmf-0.2.12-2-any.pkg.tar.zst"; sha256 = "8449265758cb0cbf90b95ab658de1b8c734cf27c4d183085f059a9afc76a071f"; }];
    buildInputs = [ gcc-libs freetype gdk-pixbuf2 libjpeg libpng libxml2 zlib ];
  };

  "libwpd" = fetch {
    pname       = "libwpd";
    version     = "0.10.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libwpd-0.10.3-1-any.pkg.tar.xz"; sha256 = "ef5d8776ea3923d24774c19fa63380bf4ccf4f304bd88d60eedfa5980ab91bb1"; }];
    buildInputs = [ gcc-libs librevenge xz zlib ];
  };

  "libwpg" = fetch {
    pname       = "libwpg";
    version     = "0.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libwpg-0.3.3-1-any.pkg.tar.xz"; sha256 = "d45c9bf627cab8378b1e6dca0647ab3857326dd5a559bcd4f024dc24914915b6"; }];
    buildInputs = [ gcc-libs librevenge libwpd ];
  };

  "libxlsxwriter" = fetch {
    pname       = "libxlsxwriter";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libxlsxwriter-1.0.0-1-any.pkg.tar.zst"; sha256 = "be7a5e512e41efe26f2e97b375915311efc3d2249eb7ca628ab599ad1e70fe4f"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "libxml++" = fetch {
    pname       = "libxml++";
    version     = "3.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-libxml++-3.2.2-1-any.pkg.tar.zst"; sha256 = "24d605c614d3e1d37fb5dae3103489f217416eb8f592ad4dc279682f5e44c22a"; }];
    buildInputs = [ gcc-libs libxml2 glibmm ];
  };

  "libxml++2.6" = fetch {
    pname       = "libxml++2.6";
    version     = "2.42.0";
    srcs        = [{ filename = "mingw-w64-x86_64-libxml++2.6-2.42.0-1-any.pkg.tar.zst"; sha256 = "4acd95f1f3015a018967e13bb48848136733f9793ebad02119d7e2191e08a57a"; }];
    buildInputs = [ gcc-libs libxml2 glibmm ];
  };

  "libxml2" = fetch {
    pname       = "libxml2";
    version     = "2.9.10";
    srcs        = [{ filename = "mingw-w64-x86_64-libxml2-2.9.10-4-any.pkg.tar.zst"; sha256 = "03e3145c0f2cc4ba5c3eff45e8d10215db515316644651efa8fe7170ca8d1a2c"; }];
    buildInputs = [ gcc-libs gettext xz zlib ];
  };

  "libxslt" = fetch {
    pname       = "libxslt";
    version     = "1.1.34";
    srcs        = [{ filename = "mingw-w64-x86_64-libxslt-1.1.34-2-any.pkg.tar.xz"; sha256 = "04498373bb468bb5e04bdc773a1dded2f6e01ebaec60e0c9938a836f8cc08f81"; }];
    buildInputs = [ gcc-libs libxml2 libgcrypt ];
  };

  "libyaml" = fetch {
    pname       = "libyaml";
    version     = "0.2.5";
    srcs        = [{ filename = "mingw-w64-x86_64-libyaml-0.2.5-1-any.pkg.tar.zst"; sha256 = "6989105959dfd91c03ba98dac99e72e9ba4a422f9a8c50539196779a510c6f06"; }];
    buildInputs = [  ];
  };

  "libyuv-git" = fetch {
    pname       = "libyuv-git";
    version     = "1724.r7ce50764";
    srcs        = [{ filename = "mingw-w64-x86_64-libyuv-git-1724.r7ce50764-1-any.pkg.tar.xz"; sha256 = "3b514b1b7291516d905ce710f6a98198c13c42ae68f63c48f21be69e642e685d"; }];
  };

  "libzip" = fetch {
    pname       = "libzip";
    version     = "1.7.3";
    srcs        = [{ filename = "mingw-w64-x86_64-libzip-1.7.3-1-any.pkg.tar.zst"; sha256 = "35376f8c46a9e789183e2399e740cfeff276354a668a57a778e43a93119b36fd"; }];
    buildInputs = [ bzip2 gnutls nettle xz zlib ];
  };

  "live-chart-gtk3" = fetch {
    pname       = "live-chart-gtk3";
    version     = "1.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-live-chart-gtk3-1.6.1-1-any.pkg.tar.zst"; sha256 = "80b620d46b623108fc131c7178610acdf2fbf2847ee7ae8a12a8ca0b26c09fa0"; }];
    buildInputs = [ glib2 gtk3 libgee ];
  };

  "live-media" = fetch {
    pname       = "live-media";
    version     = "2019.11.06";
    srcs        = [{ filename = "mingw-w64-x86_64-live-media-2019.11.06-1-any.pkg.tar.xz"; sha256 = "74927e56bbf9f9730982e45e265a9dc75978275a6b4eeaa0139f9253d9660749"; }];
    buildInputs = [ gcc ];
  };

  "lld" = fetch {
    pname       = "lld";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-lld-10.0.1-1-any.pkg.tar.zst"; sha256 = "2ddefc6b0c92d34fb59bc40551fa9a090cd5fbc22baf0f3e3f9da68a4729b8d8"; }];
    buildInputs = [ gcc ];
  };

  "lldb" = fetch {
    pname       = "lldb";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-lldb-10.0.1-1-any.pkg.tar.zst"; sha256 = "2fbddceaac73a55fbb4eae2043d83b5d7a501ea0ec2025a96f9ffcc11fac07d1"; }];
    buildInputs = [ libxml2 llvm lua python readline swig ];
  };

  "llvm" = fetch {
    pname       = "llvm";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-llvm-10.0.1-1-any.pkg.tar.zst"; sha256 = "7e0f07722d239c33d0a70bc0558ffc9ee79e616be5512393ab5e94e1059ede8c"; }];
    buildInputs = [ libffi z3 gcc-libs ];
  };

  "lmdb" = fetch {
    pname       = "lmdb";
    version     = "0.9.25";
    srcs        = [{ filename = "mingw-w64-x86_64-lmdb-0.9.25-1-any.pkg.tar.zst"; sha256 = "5e7d10d6b7b13670a311420a9dfc32b922a437a5b9d4c30367fcffc5232c5c5b"; }];
  };

  "lmdbxx" = fetch {
    pname       = "lmdbxx";
    version     = "0.9.14.0";
    srcs        = [{ filename = "mingw-w64-x86_64-lmdbxx-0.9.14.0-1-any.pkg.tar.xz"; sha256 = "14a9986ca3e4c05664c5065dcf3f7b4f75e84a43bd7ff519163f5b64c6f709c8"; }];
    buildInputs = [ lmdb ];
  };

  "lpsolve" = fetch {
    pname       = "lpsolve";
    version     = "5.5.2.5";
    srcs        = [{ filename = "mingw-w64-x86_64-lpsolve-5.5.2.5-2-any.pkg.tar.xz"; sha256 = "c0d339e0c32eb59bdf983f007013c4173347f436988ff1cdf28c26fb2553d1cd"; }];
    buildInputs = [ gcc-libs ];
  };

  "lua" = fetch {
    pname       = "lua";
    version     = "5.3.5";
    srcs        = [{ filename = "mingw-w64-x86_64-lua-5.3.5-1-any.pkg.tar.xz"; sha256 = "c3f81a48b8050ea1e2ec9a081f52caaa80db509913f271bdb2e7acf6d3e8746a"; }];
    buildInputs = [ winpty ];
  };

  "lua-lpeg" = fetch {
    pname       = "lua-lpeg";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-lua-lpeg-1.0.2-1-any.pkg.tar.xz"; sha256 = "bd066125153583b1c66372952922634831ca543682ed9f96e6d4327d838c8f24"; }];
    buildInputs = [ lua ];
  };

  "lua-mpack" = fetch {
    pname       = "lua-mpack";
    version     = "1.0.8";
    srcs        = [{ filename = "mingw-w64-x86_64-lua-mpack-1.0.8-1-any.pkg.tar.xz"; sha256 = "4270383d932c9c048facecaaafbac04e69316d53ee6f5957f6dabaacd952d874"; }];
    buildInputs = [ lua libmpack ];
  };

  "lua51" = fetch {
    pname       = "lua51";
    version     = "5.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-lua51-5.1.5-4-any.pkg.tar.xz"; sha256 = "b1dcf14e61ea42e7f52d396420fd4b6b186d29698aa3dcd74b36f1b63328b4e2"; }];
    buildInputs = [ winpty ];
  };

  "lua51-bitop" = fetch {
    pname       = "lua51-bitop";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-lua51-bitop-1.0.2-1-any.pkg.tar.zst"; sha256 = "38abcba72e7b6b020a2173757e276ded5163b2b6040a4c26371eaa7076026b1b"; }];
    buildInputs = [ lua51 ];
  };

  "lua51-lgi" = fetch {
    pname       = "lua51-lgi";
    version     = "0.9.2";
    srcs        = [{ filename = "mingw-w64-x86_64-lua51-lgi-0.9.2-1-any.pkg.tar.xz"; sha256 = "9a18b49937d2785373dec032d181feb9680cc7679c3eb633252e98280498d30a"; }];
    buildInputs = [ lua51 gtk3 gobject-introspection ];
  };

  "lua51-lpeg" = fetch {
    pname       = "lua51-lpeg";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-lua51-lpeg-1.0.2-1-any.pkg.tar.xz"; sha256 = "0285aa3cda65c3b75b0a4eeff64a3518bce216f48f4b726ed02258360d244587"; }];
    buildInputs = [ lua51 ];
  };

  "lua51-lsqlite3" = fetch {
    pname       = "lua51-lsqlite3";
    version     = "0.9.3";
    srcs        = [{ filename = "mingw-w64-x86_64-lua51-lsqlite3-0.9.3-1-any.pkg.tar.xz"; sha256 = "3eb1e9f05559439cb8367a34d2d6e04e8ad36c8e9604e9c378d73c1752fd7d4b"; }];
    buildInputs = [ lua51 sqlite3 ];
  };

  "lua51-luarocks" = fetch {
    pname       = "lua51-luarocks";
    version     = "2.4.4";
    srcs        = [{ filename = "mingw-w64-x86_64-lua51-luarocks-2.4.4-2-any.pkg.tar.zst"; sha256 = "4626cb8d3a977294fa38bcf82b0ff491cc032a641d6d13418781832c4e78c602"; }];
    buildInputs = [ lua51 ];
  };

  "lua51-mpack" = fetch {
    pname       = "lua51-mpack";
    version     = "1.0.8";
    srcs        = [{ filename = "mingw-w64-x86_64-lua51-mpack-1.0.8-1-any.pkg.tar.xz"; sha256 = "93d276613e6cd5a4a55ffb72ac36f2fd72e2f32a272593015240f9abd12fedc2"; }];
    buildInputs = [ lua51 libmpack ];
  };

  "lua51-winapi" = fetch {
    pname       = "lua51-winapi";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-x86_64-lua51-winapi-1.4.2-1-any.pkg.tar.xz"; sha256 = "b8bfb7af2812f0ccee89f9f8a062dddeccac74841fdf9549ea56349060371886"; }];
    buildInputs = [ lua51 ];
  };

  "luabind-git" = fetch {
    pname       = "luabind-git";
    version     = "0.9.1.144.ge414c57";
    srcs        = [{ filename = "mingw-w64-x86_64-luabind-git-0.9.1.144.ge414c57-1-any.pkg.tar.xz"; sha256 = "3df039eff4fe41af747e48c03c68ed5e8b19c00dbc3150b6dc0be754417feb80"; }];
    buildInputs = [ boost lua51 ];
  };

  "luajit" = fetch {
    pname       = "luajit";
    version     = "2.1.0_beta3";
    srcs        = [{ filename = "mingw-w64-x86_64-luajit-2.1.0_beta3-1-any.pkg.tar.zst"; sha256 = "0d2c1d4f74bf4bff902419b89e6db2d767378c980a93ca9e9b10f64891b31df5"; }];
    buildInputs = [ winpty ];
  };

  "lz4" = fetch {
    pname       = "lz4";
    version     = "1.9.2";
    srcs        = [{ filename = "mingw-w64-x86_64-lz4-1.9.2-1-any.pkg.tar.xz"; sha256 = "91f6203326727f5b52ebd975d110c6add17f2179f6d3b40e392dc62f9da9f918"; }];
    buildInputs = [ gcc-libs ];
  };

  "lzo2" = fetch {
    pname       = "lzo2";
    version     = "2.10";
    srcs        = [{ filename = "mingw-w64-x86_64-lzo2-2.10-1-any.pkg.tar.xz"; sha256 = "277ba86026266f82646e0be3287d8560a0b993d1ec035567b64386dd4f1424d6"; }];
    buildInputs = [  ];
  };

  "m2r" = fetch {
    pname       = "m2r";
    version     = "0.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-m2r-0.2.1-1-any.pkg.tar.zst"; sha256 = "11f2476e584b581a2859779b122c07f00114b34a6d117285f16518275442afb9"; }];
    buildInputs = [ python-docutils python-mistune ];
  };

  "magnum" = fetch {
    pname       = "magnum";
    version     = "2020.06";
    srcs        = [{ filename = "mingw-w64-x86_64-magnum-2020.06-1-any.pkg.tar.zst"; sha256 = "02a8c3dbe71722fd6583a3331b81f024b7df33dc4e021d6e634dc35848f3624f"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast corrade.version "2020.06"; corrade) openal SDL2 glfw vulkan-loader ];
  };

  "magnum-integration" = fetch {
    pname       = "magnum-integration";
    version     = "2020.06";
    srcs        = [{ filename = "mingw-w64-x86_64-magnum-integration-2020.06-1-any.pkg.tar.zst"; sha256 = "e686b21dc7f9479bfd6425242cfb8e1f1f1971d943a441ad5e473c5116da056d"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast magnum.version "2020.06"; magnum) bullet eigen3 glm ];
  };

  "magnum-plugins" = fetch {
    pname       = "magnum-plugins";
    version     = "2020.06";
    srcs        = [{ filename = "mingw-w64-x86_64-magnum-plugins-2020.06-1-any.pkg.tar.zst"; sha256 = "86935a9a3f881df3939104233cad206aeba44f4395ccc703bb0eb59251c3fb88"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast magnum.version "2020.06"; magnum) assimp devil faad2 freetype harfbuzz libjpeg-turbo libpng ];
  };

  "make" = fetch {
    pname       = "make";
    version     = "4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-make-4.3-1-any.pkg.tar.xz"; sha256 = "7863472b0763a1a6ca70bdcc6e98df3b2016b221c9da5fe264b28d1c6e1c236c"; }];
    buildInputs = [ gettext ];
  };

  "marisa" = fetch {
    pname       = "marisa";
    version     = "0.2.6";
    srcs        = [{ filename = "mingw-w64-x86_64-marisa-0.2.6-1-any.pkg.tar.zst"; sha256 = "2e9f31b37307261d864da4c5ad2fed4d4ad28d481e94c9d979a26644162a5ae7"; }];
    buildInputs = [  ];
  };

  "mathgl" = fetch {
    pname       = "mathgl";
    version     = "2.4.4";
    srcs        = [{ filename = "mingw-w64-x86_64-mathgl-2.4.4-1-any.pkg.tar.xz"; sha256 = "da39486da261d91e279054554809d6222f5d9dedc24b47e47495eb9d250cdae6"; }];
    buildInputs = [ hdf5 fltk libharu libjpeg-turbo libpng giflib qt5 freeglut wxWidgets ];
  };

  "matio" = fetch {
    pname       = "matio";
    version     = "1.5.17";
    srcs        = [{ filename = "mingw-w64-x86_64-matio-1.5.17-2-any.pkg.tar.zst"; sha256 = "0e3d20680d206411e694151f6fae63f8fd3c94355d7af3c996c09774cc9889cb"; }];
    buildInputs = [ gcc-libs zlib hdf5 ];
  };

  "mbedtls" = fetch {
    pname       = "mbedtls";
    version     = "2.16.5";
    srcs        = [{ filename = "mingw-w64-x86_64-mbedtls-2.16.5-1-any.pkg.tar.xz"; sha256 = "4016c5651637d58d1d910f5cf05f2812d0fd2ad45cbbab90dba075aa1d79d25b"; }];
    buildInputs = [ gcc-libs ];
  };

  "mcpp" = fetch {
    pname       = "mcpp";
    version     = "2.7.2";
    srcs        = [{ filename = "mingw-w64-x86_64-mcpp-2.7.2-2-any.pkg.tar.xz"; sha256 = "c66f2470ff981408e254cab854049bcd1c2f3f110ce01b827587642ef8f1aa72"; }];
    buildInputs = [ gcc-libs libiconv ];
  };

  "mdloader" = fetch {
    pname       = "mdloader";
    version     = "1.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-mdloader-1.0.4-1-any.pkg.tar.zst"; sha256 = "018663fa8bc880af25b3f8b9541918044cbba264fce0369d87f30dbfd7f7dee5"; }];
  };

  "meanwhile" = fetch {
    pname       = "meanwhile";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-meanwhile-1.0.2-4-any.pkg.tar.xz"; sha256 = "f957872cf98c737a8bdf6451169aec642170467dc3128ea48e74abea5a68007f"; }];
    buildInputs = [ glib2 ];
  };

  "mecab" = fetch {
    pname       = "mecab";
    version     = "0.996";
    srcs        = [{ filename = "mingw-w64-x86_64-mecab-0.996-2-any.pkg.tar.xz"; sha256 = "d6bd7d23e702c93a6db8d000f111d562a137f50151dd8a404342e157bce3f03d"; }];
    buildInputs = [ libiconv ];
  };

  "mecab-naist-jdic" = fetch {
    pname       = "mecab-naist-jdic";
    version     = "0.6.3b_20111013";
    srcs        = [{ filename = "mingw-w64-x86_64-mecab-naist-jdic-0.6.3b_20111013-1-any.pkg.tar.xz"; sha256 = "3ffa45d0da26ccbbf72d07ad93710c5bd30681693cb32203b29747bf8dffd2e9"; }];
    buildInputs = [ mecab ];
  };

  "meld3" = fetch {
    pname       = "meld3";
    version     = "3.21.0";
    srcs        = [{ filename = "mingw-w64-x86_64-meld3-3.21.0-2-any.pkg.tar.xz"; sha256 = "4bdf81a06d75052d51fc9fc4a3ccc64fc5eaedb51ed625ac042900d9690020d5"; }];
    buildInputs = [ gtk3 gtksourceview4 adwaita-icon-theme gsettings-desktop-schemas python-gobject ];
  };

  "memphis" = fetch {
    pname       = "memphis";
    version     = "0.2.3";
    srcs        = [{ filename = "mingw-w64-x86_64-memphis-0.2.3-4-any.pkg.tar.xz"; sha256 = "cf588ca4c8a4d42eec97979e8f51f86a110133c7b96762d880b9802980d98a3e"; }];
    buildInputs = [ glib2 cairo expat ];
  };

  "mesa" = fetch {
    pname       = "mesa";
    version     = "20.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-mesa-20.2.0-1-any.pkg.tar.zst"; sha256 = "abc3f2577dcab91c7a421a469c0ed741b2d1e0fca41d22a13587c8e9c1abd2c9"; }];
    buildInputs = [ zlib ];
  };

  "meson" = fetch {
    pname       = "meson";
    version     = "0.55.3";
    srcs        = [{ filename = "mingw-w64-x86_64-meson-0.55.3-1-any.pkg.tar.zst"; sha256 = "6de540485e170c0a15b9a700378884feb2ca3d9fb113b14cd37719ee400e65e7"; }];
    buildInputs = [ python python-setuptools ninja ];
  };

  "metis" = fetch {
    pname       = "metis";
    version     = "5.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-metis-5.1.0-3-any.pkg.tar.xz"; sha256 = "94c9e39ae311644c80ca84d1804c99d342055238fa71e7e71eb20378a2e01f7c"; }];
    buildInputs = [  ];
  };

  "mhook" = fetch {
    pname       = "mhook";
    version     = "r7.a159eed";
    srcs        = [{ filename = "mingw-w64-x86_64-mhook-r7.a159eed-1-any.pkg.tar.xz"; sha256 = "3fd710b8b43d3f56a175579558aae68ebef28c7d519fcfc6587aa4040f53a371"; }];
    buildInputs = [ gcc-libs ];
  };

  "minisign" = fetch {
    pname       = "minisign";
    version     = "0.9";
    srcs        = [{ filename = "mingw-w64-x86_64-minisign-0.9-1-any.pkg.tar.zst"; sha256 = "cb04367ec53a03e444087c2d3ace92e53d548107fd5adee2a1765b30086216fe"; }];
    buildInputs = [ libsodium ];
  };

  "miniupnpc" = fetch {
    pname       = "miniupnpc";
    version     = "2.1.20190824";
    srcs        = [{ filename = "mingw-w64-x86_64-miniupnpc-2.1.20190824-2-any.pkg.tar.xz"; sha256 = "07ec5545d08ce20f5d289b0fd6a05dae0ede915ed20f81ff424faddac2639c16"; }];
    buildInputs = [ gcc-libs ];
  };

  "minizip-git" = fetch {
    pname       = "minizip-git";
    version     = "1.2.445.e67b996";
    srcs        = [{ filename = "mingw-w64-x86_64-minizip-git-1.2.445.e67b996-1-any.pkg.tar.xz"; sha256 = "eb1f614d16c9823e7f7a403fd8e79ca4b2e554756680a78af19c9f582ffa794a"; }];
    buildInputs = [ bzip2 zlib ];
  };

  "minizip2" = fetch {
    pname       = "minizip2";
    version     = "2.7.0";
    srcs        = [{ filename = "mingw-w64-x86_64-minizip2-2.7.0-1-any.pkg.tar.xz"; sha256 = "8143c4581306ba48b192917133d923eb965057699614c3fdc4b8b8019bebca92"; }];
    buildInputs = [ bzip2 gcc-libs zlib ];
  };

  "mlpack" = fetch {
    pname       = "mlpack";
    version     = "1.0.12";
    srcs        = [{ filename = "mingw-w64-x86_64-mlpack-1.0.12-2-any.pkg.tar.xz"; sha256 = "2d87ebc21c82baf3269796fa8cf8794f9ef77ef77f55b4edc0437ecfc2e3f93b"; }];
    buildInputs = [ gcc-libs armadillo boost libxml2 ];
  };

  "mlt" = fetch {
    pname       = "mlt";
    version     = "6.22.1";
    srcs        = [{ filename = "mingw-w64-x86_64-mlt-6.22.1-1-any.pkg.tar.zst"; sha256 = "ca4ded4c90078965239fa628164f7e867d7324522c44adbd28ad648cb38b77dd"; }];
    buildInputs = [ SDL2 fftw ffmpeg gdk-pixbuf2 ];
  };

  "mono" = fetch {
    pname       = "mono";
    version     = "6.4.0.198";
    srcs        = [{ filename = "mingw-w64-x86_64-mono-6.4.0.198-1-any.pkg.tar.xz"; sha256 = "b284fbb451bd3f367a2a4863808f8fc267dee31fa26622a6ee7a3cb021962880"; }];
    buildInputs = [ zlib gcc-libs winpthreads-git libgdiplus python3 ca-certificates ];
  };

  "mono-basic" = fetch {
    pname       = "mono-basic";
    version     = "4.8";
    srcs        = [{ filename = "mingw-w64-x86_64-mono-basic-4.8-1-any.pkg.tar.xz"; sha256 = "ba417c9dc598f8b694015f1cfb316acd94a4686270801131f239028f1c4f41c6"; }];
    buildInputs = [ mono ];
  };

  "mpc" = fetch {
    pname       = "mpc";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-mpc-1.2.0-2-any.pkg.tar.zst"; sha256 = "c4aa8c9ac05238c423e28382285e0c890d1036856f4bfe1989eaf4f35f4a330d"; }];
    buildInputs = [ mpfr ];
  };

  "mpdecimal" = fetch {
    pname       = "mpdecimal";
    version     = "2.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-mpdecimal-2.5.0-1-any.pkg.tar.zst"; sha256 = "393217f25dc49dbe6aba974eac24c41db46aca1fb6f56666e78b5431b8abaf82"; }];
    buildInputs = [ gcc-libs ];
  };

  "mpfr" = fetch {
    pname       = "mpfr";
    version     = "4.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-mpfr-4.1.0-3-any.pkg.tar.zst"; sha256 = "f93f25b3bea88a51cd3806f6654b11e675b926c6fe99e55a8ce2348e7a156ad1"; }];
    buildInputs = [ gmp ];
  };

  "mpg123" = fetch {
    pname       = "mpg123";
    version     = "1.26.3";
    srcs        = [{ filename = "mingw-w64-x86_64-mpg123-1.26.3-1-any.pkg.tar.zst"; sha256 = "af33657c64ec5cbdf6deca75a13b23ce584fbadf1f6f49a6fb0c4d680be05786"; }];
    buildInputs = [ libtool gcc-libs ];
  };

  "mpv" = fetch {
    pname       = "mpv";
    version     = "0.32.0";
    srcs        = [{ filename = "mingw-w64-x86_64-mpv-0.32.0-3-any.pkg.tar.zst"; sha256 = "a1067d5584f3fa829c4c3c01b2b38de8369d0f40a44c0f6cf207181baec6283e"; }];
    buildInputs = [ ffmpeg lcms2 libarchive libass libbluray libcaca libcdio libcdio-paranoia libdvdnav libdvdread libjpeg-turbo libplacebo lua51 pkg-config rubberband uchardet vapoursynth vulkan winpty ];
  };

  "mruby" = fetch {
    pname       = "mruby";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-mruby-2.1.0-1-any.pkg.tar.xz"; sha256 = "095eadcfda0183408d23a1e0438b280601a5d37c6a13ee89f10b36d607d409c4"; }];
  };

  "mscgen" = fetch {
    pname       = "mscgen";
    version     = "0.20";
    srcs        = [{ filename = "mingw-w64-x86_64-mscgen-0.20-1-any.pkg.tar.xz"; sha256 = "5823381d52e5217d49a0ff75b7977d217dd6a9ed91ba8bc726e3bea798a4699f"; }];
    buildInputs = [ libgd ];
  };

  "msgpack-c" = fetch {
    pname       = "msgpack-c";
    version     = "3.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-msgpack-c-3.3.0-1-any.pkg.tar.zst"; sha256 = "584664fa4a77b31263be02d18a7b8f5735629a598f7f59c1bfea32659e09c7f9"; }];
  };

  "msmpi" = fetch {
    pname       = "msmpi";
    version     = "10.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-msmpi-10.1.1-2-any.pkg.tar.zst"; sha256 = "141e67a1b7d5169339418fd9d3577306a0f2f9d7cb75e087b752ce43e4fd3d05"; }];
    buildInputs = [ gcc gcc-fortran ];
  };

  "msmtp" = fetch {
    pname       = "msmtp";
    version     = "1.8.11";
    srcs        = [{ filename = "mingw-w64-x86_64-msmtp-1.8.11-1-any.pkg.tar.zst"; sha256 = "31a8a5b67fc1cb09120554687068df84651b62fa5e6302c42f2082064f446a2c"; }];
    buildInputs = [ gettext gnutls gsasl libffi libidn libwinpthread-git ];
  };

  "mtex2MML" = fetch {
    pname       = "mtex2MML";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-mtex2MML-1.3.1-2-any.pkg.tar.xz"; sha256 = "7da9c2c7907e698e135b924b1bad9a243843abe2c6ceb08250d72d202791d895"; }];
  };

  "mumps" = fetch {
    pname       = "mumps";
    version     = "5.3.4";
    srcs        = [{ filename = "mingw-w64-x86_64-mumps-5.3.4-1-any.pkg.tar.zst"; sha256 = "71aab4ea57eeee92b457ecb684b079fd575e15afd8f134db2ab557c3f79f1822"; }];
    buildInputs = [ gcc-libs gcc-libgfortran openblas metis parmetis scotch scalapack msmpi ];
  };

  "muparser" = fetch {
    pname       = "muparser";
    version     = "2.3.2";
    srcs        = [{ filename = "mingw-w64-x86_64-muparser-2.3.2-1-any.pkg.tar.zst"; sha256 = "5e23b5b1b641c27b5de9b6e53e79d082f18871c5bb8a69f74481819032067815"; }];
  };

  "mypaint" = fetch {
    pname       = "mypaint";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-mypaint-2.0.0-2-any.pkg.tar.zst"; sha256 = "7221672b3ec3b04740aab01433494756dcd630fd06392014561ce281ff3b70e9"; }];
    buildInputs = [ adwaita-icon-theme gcc-libs gsettings-desktop-schemas gtk3 hicolor-icon-theme json-c lcms2 libmypaint librsvg mypaint-brushes2 python-cairo python-gobject python-numpy ];
  };

  "mypaint-brushes" = fetch {
    pname       = "mypaint-brushes";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-mypaint-brushes-1.3.1-1-any.pkg.tar.xz"; sha256 = "61125cff94c494f3e0cce4d1c117fb7f4acff2a03cf4d2ce431cd96c55d72468"; }];
    buildInputs = [ libmypaint ];
  };

  "mypaint-brushes2" = fetch {
    pname       = "mypaint-brushes2";
    version     = "2.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-mypaint-brushes2-2.0.2-1-any.pkg.tar.xz"; sha256 = "59dfab25f610e0925f60f1ea50830142b8be1bab216665c8564cd3cb1adb98e9"; }];
    buildInputs = [  ];
  };

  "nana" = fetch {
    pname       = "nana";
    version     = "1.7.4";
    srcs        = [{ filename = "mingw-w64-x86_64-nana-1.7.4-1-any.pkg.tar.zst"; sha256 = "a4e329003fabf5ffb2aaabf89b0a39e4cc5982f28f5ef0e6772148cf61d133b0"; }];
    buildInputs = [ libpng libjpeg-turbo ];
  };

  "nanodbc" = fetch {
    pname       = "nanodbc";
    version     = "2.12.4";
    srcs        = [{ filename = "mingw-w64-x86_64-nanodbc-2.12.4-2-any.pkg.tar.xz"; sha256 = "7b405aa003df4c38fd29df40a77973dc21ae2cd146e95a4e745cf384114719fa"; }];
  };

  "nanovg-git" = fetch {
    pname       = "nanovg-git";
    version     = "r259.6ae0873";
    srcs        = [{ filename = "mingw-w64-x86_64-nanovg-git-r259.6ae0873-1-any.pkg.tar.xz"; sha256 = "fac9b7af510749c8549dc56efb8fa5682f401b01242cd3aaa6d78734ff41cdf7"; }];
  };

  "nasm" = fetch {
    pname       = "nasm";
    version     = "2.15.05";
    srcs        = [{ filename = "mingw-w64-x86_64-nasm-2.15.05-1-any.pkg.tar.zst"; sha256 = "9ed595d645fdd3bec42c97a99adfb69503580a1dc1ad7d36b15eff381bbf2ef2"; }];
  };

  "ncurses" = fetch {
    pname       = "ncurses";
    version     = "6.2";
    srcs        = [{ filename = "mingw-w64-x86_64-ncurses-6.2-2-any.pkg.tar.zst"; sha256 = "3dac72f026ab3223b46e4965845c8730b5c2309ddd1887fda892c4384318eaf6"; }];
    buildInputs = [ libsystre ];
  };

  "neon" = fetch {
    pname       = "neon";
    version     = "0.31.2";
    srcs        = [{ filename = "mingw-w64-x86_64-neon-0.31.2-1-any.pkg.tar.zst"; sha256 = "5c97ffe98d9e88c27fc2839896fbd15bfcfdfef7d91c6c79e970971359e00ba7"; }];
    buildInputs = [ expat openssl ca-certificates ];
  };

  "netcdf" = fetch {
    pname       = "netcdf";
    version     = "4.7.4";
    srcs        = [{ filename = "mingw-w64-x86_64-netcdf-4.7.4-1-any.pkg.tar.zst"; sha256 = "d02ce7c3797ecefbf7704670312d4b56683fb632991ff81d9fba6101afe339f6"; }];
    buildInputs = [ curl hdf5 ];
  };

  "nettle" = fetch {
    pname       = "nettle";
    version     = "3.6";
    srcs        = [{ filename = "mingw-w64-x86_64-nettle-3.6-2-any.pkg.tar.zst"; sha256 = "46b7cfa39b626e91a330d14a165234d096b8015680e1d9472031eb6812e62013"; }];
    buildInputs = [ gcc-libs gmp ];
  };

  "nghttp2" = fetch {
    pname       = "nghttp2";
    version     = "1.41.0";
    srcs        = [{ filename = "mingw-w64-x86_64-nghttp2-1.41.0-1-any.pkg.tar.zst"; sha256 = "11ffa4c710c8c41be163c9194b3b9265f83f75acab2af5c66c42c0236043e380"; }];
    buildInputs = [ jansson jemalloc openssl c-ares ];
  };

  "ngraph-gtk" = fetch {
    pname       = "ngraph-gtk";
    version     = "6.08.07";
    srcs        = [{ filename = "mingw-w64-x86_64-ngraph-gtk-6.08.07-1-any.pkg.tar.zst"; sha256 = "f06d7dd85c0e9a62bbb95dc377b7af7376cd1710d161527de22253685386ed29"; }];
    buildInputs = [ adwaita-icon-theme gsettings-desktop-schemas gtk3 gtksourceview4 readline gsl ruby ];
  };

  "ngspice" = fetch {
    pname       = "ngspice";
    version     = "32";
    srcs        = [{ filename = "mingw-w64-x86_64-ngspice-32-2-any.pkg.tar.zst"; sha256 = "c3620fc9e0d4e344a6d787c06e274ba3652e667139fdb0feee33e7503015f107"; }];
    buildInputs = [ gcc-libs ];
  };

  "nim" = fetch {
    pname       = "nim";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-nim-1.2.0-1-any.pkg.tar.zst"; sha256 = "0e9f91c5c66a42b4e5c40c2f8d563cbef5b1aff03beacb62f305ba1fdcb73ce5"; }];
  };

  "nimble" = fetch {
    pname       = "nimble";
    version     = "0.11.0";
    srcs        = [{ filename = "mingw-w64-x86_64-nimble-0.11.0-1-any.pkg.tar.xz"; sha256 = "89bc48b08a271f0f327ac1ef0ef78fa145d54facb8980359f669384b22de9c4f"; }];
  };

  "ninja" = fetch {
    pname       = "ninja";
    version     = "1.10.1";
    srcs        = [{ filename = "mingw-w64-x86_64-ninja-1.10.1-1-any.pkg.tar.zst"; sha256 = "0f115e5620fea3e1c7c5d38a5b15e1e4859fbad7035f7fd2fc8ea273c6ffb67b"; }];
    buildInputs = [  ];
  };

  "nlohmann-json" = fetch {
    pname       = "nlohmann-json";
    version     = "3.9.1";
    srcs        = [{ filename = "mingw-w64-x86_64-nlohmann-json-3.9.1-1-any.pkg.tar.zst"; sha256 = "eb1548ceff827560269ad0fc080574c991bd5e2fd6c4160429d0f6a5d4e56401"; }];
  };

  "nlopt" = fetch {
    pname       = "nlopt";
    version     = "2.6.2";
    srcs        = [{ filename = "mingw-w64-x86_64-nlopt-2.6.2-1-any.pkg.tar.xz"; sha256 = "c007d9db16b1c02a13922892110f5a10ee7363fdc736d1a5d520b3a6da203699"; }];
  };

  "npth" = fetch {
    pname       = "npth";
    version     = "1.6";
    srcs        = [{ filename = "mingw-w64-x86_64-npth-1.6-1-any.pkg.tar.xz"; sha256 = "7a765395dedb1294b700c7a96a9e8e0eb314372640382b6fa6cd90c0e223339a"; }];
    buildInputs = [ gcc-libs ];
  };

  "nsis" = fetch {
    pname       = "nsis";
    version     = "3.05";
    srcs        = [{ filename = "mingw-w64-x86_64-nsis-3.05-1-any.pkg.tar.xz"; sha256 = "6fe455b85fe5ae9ecbb74bf4e7128b46bfe12582061a934bd4c79d6737835eae"; }];
    buildInputs = [ zlib gcc-libs libwinpthread-git ];
  };

  "nsis-nsisunz" = fetch {
    pname       = "nsis-nsisunz";
    version     = "1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-nsis-nsisunz-1.0-1-any.pkg.tar.xz"; sha256 = "d3cf4ff6ddde3c301b46eb6a0309ef9c008d7b7ebaad920e21754a10ddc0388c"; }];
    buildInputs = [ nsis ];
  };

  "nspr" = fetch {
    pname       = "nspr";
    version     = "4.25";
    srcs        = [{ filename = "mingw-w64-x86_64-nspr-4.25-1-any.pkg.tar.xz"; sha256 = "f274fae733af3392e59f1a1d7968e7003f726437c4d1f42c6312cb4a9bde7043"; }];
    buildInputs = [ gcc-libs ];
  };

  "nss" = fetch {
    pname       = "nss";
    version     = "3.52.1";
    srcs        = [{ filename = "mingw-w64-x86_64-nss-3.52.1-1-any.pkg.tar.zst"; sha256 = "653dc931452facec1e066a8928de99eaf6ad60c73191916c463c309a970b380e"; }];
    buildInputs = [ nspr sqlite3 zlib ];
  };

  "nsync" = fetch {
    pname       = "nsync";
    version     = "1.22.0";
    srcs        = [{ filename = "mingw-w64-x86_64-nsync-1.22.0-1-any.pkg.tar.xz"; sha256 = "5668fd85ae9053f9eaeb4f3a2ea21bc935522ced5739d3542ffbb5e1b1ebf96a"; }];
    buildInputs = [ gcc-libs ];
  };

  "ntldd-git" = fetch {
    pname       = "ntldd-git";
    version     = "r15.e7622f6";
    srcs        = [{ filename = "mingw-w64-x86_64-ntldd-git-r15.e7622f6-2-any.pkg.tar.xz"; sha256 = "db3ad7e98022ad89d20f4fd6d43928e5d4cc8795f855dd14901d7c9dda26cd1c"; }];
  };

  "nuspell" = fetch {
    pname       = "nuspell";
    version     = "3.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-nuspell-3.1.1-2-any.pkg.tar.zst"; sha256 = "bf72d1d10d4f92533f6cf64abfe492d54cbcbd1406052c2f3ba1beccfa6c6673"; }];
    buildInputs = [ icu boost ];
  };

  "nvidia-cg-toolkit" = fetch {
    pname       = "nvidia-cg-toolkit";
    version     = "3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-nvidia-cg-toolkit-3.1-1-any.pkg.tar.zst"; sha256 = "0ab27d029b050981ac8b9a1eb6d78332baa50d965eafbccfadbec2d1d239c9ff"; }];
    buildInputs = [ crt-git ];
  };

  "oce" = fetch {
    pname       = "oce";
    version     = "0.18.3";
    srcs        = [{ filename = "mingw-w64-x86_64-oce-0.18.3-3-any.pkg.tar.xz"; sha256 = "6a2fae91bf9bb56cee60a6180292e6456e4ff9388e6b0db7f0678f6816db859d"; }];
    buildInputs = [ freetype ];
  };

  "octopi-git" = fetch {
    pname       = "octopi-git";
    version     = "r941.6df0f8a";
    srcs        = [{ filename = "mingw-w64-x86_64-octopi-git-r941.6df0f8a-1-any.pkg.tar.xz"; sha256 = "24b91b606c133c483425deaa1d6b802fd076d179687909da7f2759d59655e63a"; }];
    buildInputs = [ gcc-libs ];
  };

  "odt2txt" = fetch {
    pname       = "odt2txt";
    version     = "0.5";
    srcs        = [{ filename = "mingw-w64-x86_64-odt2txt-0.5-2-any.pkg.tar.xz"; sha256 = "596f6ae3c814deb881f5ccd1b025ae91f3e45d9a814d9e9de804ab1472fc2ff3"; }];
    buildInputs = [ libiconv libzip pcre ];
  };

  "ogitor-git" = fetch {
    pname       = "ogitor-git";
    version     = "r816.cf42232";
    srcs        = [{ filename = "mingw-w64-x86_64-ogitor-git-r816.cf42232-1-any.pkg.tar.xz"; sha256 = "fe61c39cab2470d47b78f73f535c36360efe3e21fbe06c577730491b55e4a0c9"; }];
    buildInputs = [ libwinpthread-git ogre3d boost qt5 ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "ogre3d" = fetch {
    pname       = "ogre3d";
    version     = "1.12.6";
    srcs        = [{ filename = "mingw-w64-x86_64-ogre3d-1.12.6-1-any.pkg.tar.zst"; sha256 = "04aa80442098dd40dee41c47d30400064829aec71b2ed9a2c69fdd4ce704ddc7"; }];
    buildInputs = [ boost cppunit FreeImage freetype glsl-optimizer-git hlsl2glsl-git intel-tbb openexr SDL2 python pugixml tinyxml winpthreads-git zlib zziplib ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "ois" = fetch {
    pname       = "ois";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-ois-1.5-1-any.pkg.tar.zst"; sha256 = "c231f6857c173d2777c83c48d82483d2a3cc27f3d8aec525d22faa7679ebd19f"; }];
    buildInputs = [ gcc-libs ];
  };

  "onigmo" = fetch {
    pname       = "onigmo";
    version     = "6.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-onigmo-6.2.0-1-any.pkg.tar.xz"; sha256 = "2b24b3172958d9fc19e57b11a54b681a9142b6b32b89a3366bd01562d6d1dcce"; }];
  };

  "oniguruma" = fetch {
    pname       = "oniguruma";
    version     = "6.9.5";
    srcs        = [{ filename = "mingw-w64-x86_64-oniguruma-6.9.5-1-any.pkg.tar.xz"; sha256 = "91ca8fb55267fbc11c45255df5e8b8a905b9d5b3695b768787988eaffafc582a"; }];
    buildInputs = [  ];
  };

  "openal" = fetch {
    pname       = "openal";
    version     = "1.20.1";
    srcs        = [{ filename = "mingw-w64-x86_64-openal-1.20.1-2-any.pkg.tar.zst"; sha256 = "5997e94295caf0bfedf9e90af060c53f0ea5741bbd18867a77178646543b772a"; }];
    buildInputs = [ libmysofa ];
  };

  "openblas" = fetch {
    pname       = "openblas";
    version     = "0.3.10";
    srcs        = [{ filename = "mingw-w64-x86_64-openblas-0.3.10-2-any.pkg.tar.zst"; sha256 = "d43b2f0f5b8106a86e1ed08f4aba89f0acdbfef8db6b759308b91d6bcb76bbf3"; }];
    buildInputs = [ gcc-libs gcc-libgfortran libwinpthread-git ];
  };

  "opencc" = fetch {
    pname       = "opencc";
    version     = "1.0.6";
    srcs        = [{ filename = "mingw-w64-x86_64-opencc-1.0.6-1-any.pkg.tar.zst"; sha256 = "5837698d6f18111e5d1becbf08eda23d39718230f0ab6343d4accec40d96aedc"; }];
    buildInputs = [  ];
  };

  "opencl-headers" = fetch {
    pname       = "opencl-headers";
    version     = "2~2.2.20200327";
    srcs        = [{ filename = "mingw-w64-x86_64-opencl-headers-2~2.2.20200327-1-any.pkg.tar.xz"; sha256 = "a7186cdb8b74fd59001edda024e0ee9f59dcf0a7f983da8335bbe6fbf2d931cd"; }];
    buildInputs = [  ];
  };

  "opencl-icd-git" = fetch {
    pname       = "opencl-icd-git";
    version     = "47.c7fda8b";
    srcs        = [{ filename = "mingw-w64-x86_64-opencl-icd-git-47.c7fda8b-1-any.pkg.tar.xz"; sha256 = "00a74d6c560f90a4c9cdaee1afefbda1bf3dc52bd64ff4d8c205ab5cf0fe72ef"; }];
    buildInputs = [ opencl-headers ];
  };

  "opencollada" = fetch {
    pname       = "opencollada";
    version     = "1.6.68";
    srcs        = [{ filename = "mingw-w64-x86_64-opencollada-1.6.68-2-any.pkg.tar.zst"; sha256 = "17e2e95dbc161c2863e3d3c5037d1006b9b15ddf4ad09d174fcb63e061449463"; }];
    buildInputs = [ libxml2 pcre ];
  };

  "opencolorio" = fetch {
    pname       = "opencolorio";
    version     = "1.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-opencolorio-1.1.1-9-any.pkg.tar.zst"; sha256 = "aec4dfa75533797a6da46219d354b62e5c542f5875296764d49593e2a3a150df"; }];
    buildInputs = [ boost expat glew lcms2 openexr ptex python tinyxml yaml-cpp ];
  };

  "opencore-amr" = fetch {
    pname       = "opencore-amr";
    version     = "0.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-opencore-amr-0.1.5-1-any.pkg.tar.xz"; sha256 = "f154b789eaa5afcacaef50a0b44740643bb4041ae9963a3f2fec5b7889649fa7"; }];
    buildInputs = [  ];
  };

  "opencsg" = fetch {
    pname       = "opencsg";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-x86_64-opencsg-1.4.2-1-any.pkg.tar.xz"; sha256 = "a12410cb16f12e6ff80e3e0b41d1157b81f7ae9cb654a0fb57134fedf1ab8f75"; }];
    buildInputs = [ glew ];
  };

  "opencv" = fetch {
    pname       = "opencv";
    version     = "4.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-opencv-4.5.0-1-any.pkg.tar.zst"; sha256 = "b5c879ecba105b7b1e8acceb87eba498c55fab1a0c850249524edcca140b8550"; }];
    buildInputs = [ ceres-solver intel-tbb jasper freetype gflags glog harfbuzz hdf5 libjpeg libpng libtiff libwebp ogre3d openblas openjpeg2 openexr protobuf tesseract-ocr zlib ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "openexr" = fetch {
    pname       = "openexr";
    version     = "2.5.2";
    srcs        = [{ filename = "mingw-w64-x86_64-openexr-2.5.2-1-any.pkg.tar.zst"; sha256 = "951ab0cafda782ef8da4ac36258c683f4d21989f39aedd515d52b829d313e257"; }];
    buildInputs = [ (assert ilmbase.version=="2.5.2"; ilmbase) zlib ];
  };

  "opengl-man-pages" = fetch {
    pname       = "opengl-man-pages";
    version     = "20191114";
    srcs        = [{ filename = "mingw-w64-x86_64-opengl-man-pages-20191114-1-any.pkg.tar.xz"; sha256 = "6f7c6a7ffaecaaa57ad637a0666ff8387c72971fe2a237734d6bfbd8c1e6a3eb"; }];
  };

  "openh264" = fetch {
    pname       = "openh264";
    version     = "2.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-openh264-2.1.1-1-any.pkg.tar.zst"; sha256 = "38aa2bc6e22b9224c1e2b6cbc83b2f7eda778eebcafd194283b3b9bd4323d66d"; }];
  };

  "openimagedenoise" = fetch {
    pname       = "openimagedenoise";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-openimagedenoise-1.1.0-1-any.pkg.tar.xz"; sha256 = "effb17895d22226ffe06747ebebaf8723d1f118341e8a346d590c7fe44d7efd0"; }];
    buildInputs = [ intel-tbb ];
  };

  "openimageio" = fetch {
    pname       = "openimageio";
    version     = "2.2.7.0";
    srcs        = [{ filename = "mingw-w64-x86_64-openimageio-2.2.7.0-1-any.pkg.tar.zst"; sha256 = "d367effedb36d89e63bd9517e2c5956d15a631003ebc84915812d4732c01b778"; }];
    buildInputs = [ boost field3d freetype fmt jasper giflib glew hdf5 libheif libjpeg libpng libraw libsquish ffmpeg libtiff libwebp opencolorio opencv openexr openjpeg openssl ptex pugixml zlib ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "openjpeg" = fetch {
    pname       = "openjpeg";
    version     = "1.5.2";
    srcs        = [{ filename = "mingw-w64-x86_64-openjpeg-1.5.2-7-any.pkg.tar.xz"; sha256 = "7cedc58a21aa29cf2619394a60a0194b7bba4efbf39a10dcab1b360069cfa1cc"; }];
    buildInputs = [ lcms2 libtiff libpng zlib ];
  };

  "openjpeg2" = fetch {
    pname       = "openjpeg2";
    version     = "2.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-openjpeg2-2.3.1-1-any.pkg.tar.xz"; sha256 = "fdad4a40ae4d5308a99f8ffd8ffafc3f4908deacde76d3d34654c04681cdc9fc"; }];
    buildInputs = [ gcc-libs lcms2 libtiff libpng zlib ];
  };

  "openldap" = fetch {
    pname       = "openldap";
    version     = "2.4.50";
    srcs        = [{ filename = "mingw-w64-x86_64-openldap-2.4.50-1-any.pkg.tar.zst"; sha256 = "0dfc524f65fb60e6fe3c38c42b845f326bb45a34dec62f27e2057edf07381ad6"; }];
    buildInputs = [ cyrus-sasl libtool openssl ];
  };

  "openlibm" = fetch {
    pname       = "openlibm";
    version     = "0.7.1";
    srcs        = [{ filename = "mingw-w64-x86_64-openlibm-0.7.1-1-any.pkg.tar.zst"; sha256 = "7f5f802c96f79323a86d9d3a8c1e26a61651317adceb4da79d63bcc00b0275b3"; }];
  };

  "openmp" = fetch {
    pname       = "openmp";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-openmp-10.0.1-1-any.pkg.tar.zst"; sha256 = "aac12ca48d9e42e8546941d02cd5973477341aa3608f3edd135ba17c915160bb"; }];
    buildInputs = [ gcc ];
  };

  "openocd" = fetch {
    pname       = "openocd";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-openocd-0.10.0-2-any.pkg.tar.xz"; sha256 = "2ae949e8da9ab14d4c40dc73f2fceb7fbfc327ea366dbd35b6cb8db19bffa8c5"; }];
    buildInputs = [ hidapi libusb libusb-compat-git libftdi libjaylink-git ];
  };

  "openscad" = fetch {
    pname       = "openscad";
    version     = "2019.05";
    srcs        = [{ filename = "mingw-w64-x86_64-openscad-2019.05-2-any.pkg.tar.xz"; sha256 = "96f0f1b9088d7175396d7c73db0d2251f2a62fe468a5df8e4b873597293fa483"; }];
    buildInputs = [ qt5 boost cgal double-conversion fontconfig freetype glew glib2 harfbuzz libxml2 libzip opencsg qscintilla shared-mime-info ];
  };

  "openshadinglanguage" = fetch {
    pname       = "openshadinglanguage";
    version     = "1.11.8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-openshadinglanguage-1.11.8.0-1-any.pkg.tar.zst"; sha256 = "4620914010a6e8c10d5f96f11c2d66fd3d6b173dd69c868d7f3d441d9633d173"; }];
    buildInputs = [ boost clang freetype glew ilmbase intel-tbb libpng libtiff openexr openimageio partio pugixml ];
    broken      = true; # broken dependency ogre3d -> FreeImage
  };

  "openssl" = fetch {
    pname       = "openssl";
    version     = "1.1.1.h";
    srcs        = [{ filename = "mingw-w64-x86_64-openssl-1.1.1.h-1-any.pkg.tar.zst"; sha256 = "fe4503249b8dbc74c912574e4c638e1d2610bcc082b7f09f9503b4803f26c714"; }];
    buildInputs = [ ca-certificates gcc-libs zlib ];
  };

  "openvdb" = fetch {
    pname       = "openvdb";
    version     = "7.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-openvdb-7.0.0-3-any.pkg.tar.zst"; sha256 = "d20bdddd4fa70f911cd983de53716caaa5a5f2fe9b4c0d1004b61300350c8981"; }];
    buildInputs = [ blosc boost intel-tbb openexr zlib ];
  };

  "openvr" = fetch {
    pname       = "openvr";
    version     = "1.14.15";
    srcs        = [{ filename = "mingw-w64-x86_64-openvr-1.14.15-1-any.pkg.tar.zst"; sha256 = "6a6be5c3085068a27559aeea183cbd2bf2db6d299a21e111274f6b692679c3e1"; }];
    buildInputs = [ gcc-libs ];
  };

  "openxr-sdk" = fetch {
    pname       = "openxr-sdk";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-x86_64-openxr-sdk-1.0.9-4-any.pkg.tar.zst"; sha256 = "95355b83ec8fb3df75ebbd4679e19c6abc9f4b7d4f0351db81e599c33f35e373"; }];
    buildInputs = [ jsoncpp vulkan-loader ];
  };

  "optipng" = fetch {
    pname       = "optipng";
    version     = "0.7.7";
    srcs        = [{ filename = "mingw-w64-x86_64-optipng-0.7.7-1-any.pkg.tar.xz"; sha256 = "565248dff7b47b3c1f66efd8f4cd3fc272f376e8cc4a1a59fb90fbcacfe38341"; }];
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "opus" = fetch {
    pname       = "opus";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-opus-1.3.1-1-any.pkg.tar.xz"; sha256 = "53234a8cdaa9e51cc06364118031c1186d38dcf83f755c0f2432b5f535b072eb"; }];
    buildInputs = [  ];
  };

  "opus-tools" = fetch {
    pname       = "opus-tools";
    version     = "0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-opus-tools-0.2-1-any.pkg.tar.xz"; sha256 = "9a8850c866e42520c7380e33e1fdbd6128a953a3c1610e2cb915305dde2601af"; }];
    buildInputs = [ gcc-libs flac libogg opus opusfile libopusenc ];
  };

  "opusfile" = fetch {
    pname       = "opusfile";
    version     = "0.12";
    srcs        = [{ filename = "mingw-w64-x86_64-opusfile-0.12-1-any.pkg.tar.zst"; sha256 = "dcf42f2e2b1e7723f395b0402c6e2f077463efcfe4a055ee1c70994cc4fd8d4d"; }];
    buildInputs = [ libogg openssl opus ];
  };

  "orc" = fetch {
    pname       = "orc";
    version     = "0.4.31";
    srcs        = [{ filename = "mingw-w64-x86_64-orc-0.4.31-1-any.pkg.tar.xz"; sha256 = "07eba61c00f9f6b7d18130678a1c396564dd7d8c4a4197d4f4b2b5c26958dfef"; }];
    buildInputs = [  ];
  };

  "osgQt" = fetch {
    pname       = "osgQt";
    version     = "3.5.7";
    srcs        = [{ filename = "mingw-w64-x86_64-osgQt-3.5.7-7-any.pkg.tar.xz"; sha256 = "1e39e59755418f7582308f12b7bb12e95f61c97f78b954ea76fb4481b83749c8"; }];
    buildInputs = [ qt5 OpenSceneGraph ];
  };

  "osgQt-debug" = fetch {
    pname       = "osgQt-debug";
    version     = "3.5.7";
    srcs        = [{ filename = "mingw-w64-x86_64-osgQt-debug-3.5.7-7-any.pkg.tar.xz"; sha256 = "465167d1e0b9e0d11489a8fa03e876a49091b8cb5a306c05c255430a498be0ed"; }];
    buildInputs = [ qt5 OpenSceneGraph-debug ];
  };

  "osgQtQuick-debug-git" = fetch {
    pname       = "osgQtQuick-debug-git";
    version     = "2.0.0.r172";
    srcs        = [{ filename = "mingw-w64-x86_64-osgQtQuick-debug-git-2.0.0.r172-4-any.pkg.tar.xz"; sha256 = "0b01b60a6f8d31f1845a7d55799e2c9a198e5f092ec67bd1996737f5ef15962c"; }];
    buildInputs = [ osgQt-debug qt5 (assert osgQtQuick-git.version=="2.0.0.r172"; osgQtQuick-git) OpenSceneGraph-debug ];
  };

  "osgQtQuick-git" = fetch {
    pname       = "osgQtQuick-git";
    version     = "2.0.0.r172";
    srcs        = [{ filename = "mingw-w64-x86_64-osgQtQuick-git-2.0.0.r172-4-any.pkg.tar.xz"; sha256 = "3c80a4d9cf10a2e9fa16e034c28464218e9d8962dc76e621adce834c093989db"; }];
    buildInputs = [ osgQt qt5 OpenSceneGraph ];
  };

  "osgbullet-debug-git" = fetch {
    pname       = "osgbullet-debug-git";
    version     = "3.0.0.265";
    srcs        = [{ filename = "mingw-w64-x86_64-osgbullet-debug-git-3.0.0.265-1-any.pkg.tar.xz"; sha256 = "8c7cfd980edccbcb051b55dcad84e7eee7ad4577845f9668ecee59ac1501a2c5"; }];
    buildInputs = [ (assert osgbullet-git.version=="3.0.0.265"; osgbullet-git) OpenSceneGraph-debug osgworks-debug-git ];
  };

  "osgbullet-git" = fetch {
    pname       = "osgbullet-git";
    version     = "3.0.0.265";
    srcs        = [{ filename = "mingw-w64-x86_64-osgbullet-git-3.0.0.265-1-any.pkg.tar.xz"; sha256 = "318c52e82dc8988abf9b29546449fb9edba56612e13a60b50c740452c6836bff"; }];
    buildInputs = [ bullet OpenSceneGraph osgworks-git ];
  };

  "osgearth" = fetch {
    pname       = "osgearth";
    version     = "2.10.1";
    srcs        = [{ filename = "mingw-w64-x86_64-osgearth-2.10.1-1-any.pkg.tar.xz"; sha256 = "ed4f4f7086c1b722519d0618bad850eb090d2d7b7c63b9781a2aa9a036df81c3"; }];
    buildInputs = [ OpenSceneGraph OpenSceneGraph-debug osgQt osgQt-debug curl gdal geos poco protobuf rocksdb sqlite3 OpenSceneGraph ];
  };

  "osgearth-debug" = fetch {
    pname       = "osgearth-debug";
    version     = "2.10.1";
    srcs        = [{ filename = "mingw-w64-x86_64-osgearth-debug-2.10.1-1-any.pkg.tar.xz"; sha256 = "4ae7ab8a98990ad8b33322f639d7707449c027dd2caa4aec7d2f12a0e6309405"; }];
    buildInputs = [ OpenSceneGraph OpenSceneGraph-debug osgQt osgQt-debug curl gdal geos poco protobuf rocksdb sqlite3 OpenSceneGraph-debug ];
  };

  "osgocean-debug-git" = fetch {
    pname       = "osgocean-debug-git";
    version     = "1.0.1.r161";
    srcs        = [{ filename = "mingw-w64-x86_64-osgocean-debug-git-1.0.1.r161-1-any.pkg.tar.xz"; sha256 = "dd8f456d64b9fa72dd5fca17721d98f54f796d11a9a1d6a86750a3f5e4eb9e6d"; }];
    buildInputs = [ (assert osgocean-git.version=="1.0.1.r161"; osgocean-git) OpenSceneGraph-debug ];
  };

  "osgocean-git" = fetch {
    pname       = "osgocean-git";
    version     = "1.0.1.r161";
    srcs        = [{ filename = "mingw-w64-x86_64-osgocean-git-1.0.1.r161-1-any.pkg.tar.xz"; sha256 = "1312ee56e82566375184fc8d54cc77145dab95eea0caf1a8082c279782380be7"; }];
    buildInputs = [ fftw OpenSceneGraph ];
  };

  "osgworks-debug-git" = fetch {
    pname       = "osgworks-debug-git";
    version     = "3.1.0.444";
    srcs        = [{ filename = "mingw-w64-x86_64-osgworks-debug-git-3.1.0.444-3-any.pkg.tar.xz"; sha256 = "b454d6b99916774611030ece8f448b430d92b657232e7d8be3341b013f78a366"; }];
    buildInputs = [ (assert osgworks-git.version=="3.1.0.444"; osgworks-git) OpenSceneGraph-debug ];
  };

  "osgworks-git" = fetch {
    pname       = "osgworks-git";
    version     = "3.1.0.444";
    srcs        = [{ filename = "mingw-w64-x86_64-osgworks-git-3.1.0.444-3-any.pkg.tar.xz"; sha256 = "d4af18dff794dbee82c785f8317c27e81ce6b7604378ea56ed7d977eb30b5f33"; }];
    buildInputs = [ OpenSceneGraph vrpn ];
  };

  "osl" = fetch {
    pname       = "osl";
    version     = "0.9.2";
    srcs        = [{ filename = "mingw-w64-x86_64-osl-0.9.2-2-any.pkg.tar.zst"; sha256 = "7cc20c0a5f60fd7f966cd96ad515781b43bde155745ba6210ac77578e3810ecd"; }];
    buildInputs = [ gmp ];
  };

  "osm-gps-map" = fetch {
    pname       = "osm-gps-map";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-osm-gps-map-1.1.0-3-any.pkg.tar.xz"; sha256 = "ba29b7a2224f187ea61c4a6f6644aade85d0b2ab5987c87845278fb571e8bc01"; }];
    buildInputs = [ libsoup gtk3 gobject-introspection ];
  };

  "osslsigncode" = fetch {
    pname       = "osslsigncode";
    version     = "2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-osslsigncode-2.0-1-any.pkg.tar.xz"; sha256 = "38ab1eadc72c67b40f8fee0fd4f966ad4d3401f56b7ee21910b2193db6b28ce3"; }];
    buildInputs = [ curl libgsf openssl ];
  };

  "p11-kit" = fetch {
    pname       = "p11-kit";
    version     = "0.23.20";
    srcs        = [{ filename = "mingw-w64-x86_64-p11-kit-0.23.20-2-any.pkg.tar.xz"; sha256 = "aaa8535da572d29227c5299bc2c2168a3802a4dcaaa9ea40cb6425b00c99c309"; }];
    buildInputs = [ libtasn1 libffi gettext ];
  };

  "paho.mqtt.c" = fetch {
    pname       = "paho.mqtt.c";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-paho.mqtt.c-1.3.0-1-any.pkg.tar.xz"; sha256 = "24e49da87a878d95509041c665b4b6d7ca8c7888e33a3ae362607f2d1093317f"; }];
  };

  "pango" = fetch {
    pname       = "pango";
    version     = "1.46.2";
    srcs        = [{ filename = "mingw-w64-x86_64-pango-1.46.2-1-any.pkg.tar.zst"; sha256 = "914686ba438a944a46f392f5826a86b47b569c4bbf4ed2caf0c8e4c92b367197"; }];
    buildInputs = [ gcc-libs cairo freetype fontconfig glib2 harfbuzz fribidi libthai ];
  };

  "pangomm" = fetch {
    pname       = "pangomm";
    version     = "2.42.1";
    srcs        = [{ filename = "mingw-w64-x86_64-pangomm-2.42.1-1-any.pkg.tar.xz"; sha256 = "0ae552f704ebe87b393efde153e553022243f968d982e1c2a8bc3d70c875b16f"; }];
    buildInputs = [ cairomm glibmm pango ];
  };

  "parmetis" = fetch {
    pname       = "parmetis";
    version     = "4.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-parmetis-4.0.3-1-any.pkg.tar.xz"; sha256 = "e383693ebeebadcef2880df05f4e5759199762925e13033fd0787f59fd88e611"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast metis.version "5.1.0"; metis) msmpi ];
  };

  "partio" = fetch {
    pname       = "partio";
    version     = "1.10.1";
    srcs        = [{ filename = "mingw-w64-x86_64-partio-1.10.1-2-any.pkg.tar.xz"; sha256 = "47903cbb009a97303fb1c8ed54908c56019e8ef8de96b1e146ef063c19c86747"; }];
    buildInputs = [ freeglut zlib ];
  };

  "pcre" = fetch {
    pname       = "pcre";
    version     = "8.44";
    srcs        = [{ filename = "mingw-w64-x86_64-pcre-8.44-1-any.pkg.tar.xz"; sha256 = "99988f03cf6eb8652a9a29586607be27b096c998e882eef6d3c567951fb0163f"; }];
    buildInputs = [ gcc-libs bzip2 wineditline zlib ];
  };

  "pcre2" = fetch {
    pname       = "pcre2";
    version     = "10.35";
    srcs        = [{ filename = "mingw-w64-x86_64-pcre2-10.35-1-any.pkg.tar.zst"; sha256 = "09c87be1a034854d56ad0c1f98cc0a0fb0dbfad1dede1a0d9727dffdb4f8ef10"; }];
    buildInputs = [ gcc-libs bzip2 wineditline zlib ];
  };

  "pdcurses" = fetch {
    pname       = "pdcurses";
    version     = "4.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-pdcurses-4.1.0-3-any.pkg.tar.xz"; sha256 = "116d542091791973ec47ee24372d9ae352cff9735c42b163570f95e02791fa49"; }];
    buildInputs = [ gcc-libs ];
  };

  "pdf2djvu" = fetch {
    pname       = "pdf2djvu";
    version     = "0.9.17.1";
    srcs        = [{ filename = "mingw-w64-x86_64-pdf2djvu-0.9.17.1-1-any.pkg.tar.zst"; sha256 = "853e3d13fb49498f0f0aeb98770454457af7832d7552d3174f281ef5fe08aef9"; }];
    buildInputs = [ poppler gcc-libs djvulibre exiv2 gettext graphicsmagick libiconv ];
  };

  "pdf2svg" = fetch {
    pname       = "pdf2svg";
    version     = "0.2.3";
    srcs        = [{ filename = "mingw-w64-x86_64-pdf2svg-0.2.3-17-any.pkg.tar.zst"; sha256 = "f4d377d98cea2ba928bfaa3fb6cdc161a14ca226693530327bc6fcb121660812"; }];
    buildInputs = [ poppler ];
  };

  "pegtl" = fetch {
    pname       = "pegtl";
    version     = "2.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-pegtl-2.8.1-1-any.pkg.tar.xz"; sha256 = "2bf7127d4cf949d396b55c99f16f298f9c1a1be9df3cab3da75e3b55aa106530"; }];
    buildInputs = [ gcc-libs ];
  };

  "pelican" = fetch {
    pname       = "pelican";
    version     = "4.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-pelican-4.2.0-1-any.pkg.tar.zst"; sha256 = "1f102e801a1907ccf8ccf5d34d3a372fdf8ecff766a64c5c2ffb178f9dce51bd"; }];
    buildInputs = [ python python-jinja python-pygments python-feedgenerator python-pytz python-docutils python-blinker python-unidecode python-six python-dateutil ];
  };

  "perl" = fetch {
    pname       = "perl";
    version     = "5.28.0";
    srcs        = [{ filename = "mingw-w64-x86_64-perl-5.28.0-1-any.pkg.tar.xz"; sha256 = "7e4d9a2c775d7baa3da394e3f492c407ddaaebb3220cbda97aaf17d71ebce79e"; }];
    buildInputs = [ gcc-libs winpthreads-git make ];
  };

  "perl-doc" = fetch {
    pname       = "perl-doc";
    version     = "5.28.0";
    srcs        = [{ filename = "mingw-w64-x86_64-perl-doc-5.28.0-1-any.pkg.tar.xz"; sha256 = "4aaef1ef66d48f3717f4a712f20f9f77d0103c1e4661d19e1ff1ebc734826c72"; }];
  };

  "phodav" = fetch {
    pname       = "phodav";
    version     = "2.4";
    srcs        = [{ filename = "mingw-w64-x86_64-phodav-2.4-1-any.pkg.tar.xz"; sha256 = "42bc6247913357fbf14fa7619208bde6193b0d6182aa4d596238bc37fc51fd7d"; }];
    buildInputs = [ glib2 libsoup libxml2 ];
  };

  "phonon-qt5" = fetch {
    pname       = "phonon-qt5";
    version     = "4.11.1";
    srcs        = [{ filename = "mingw-w64-x86_64-phonon-qt5-4.11.1-1-any.pkg.tar.xz"; sha256 = "555c3f185d8d283a1b461ad7182d6edc944df32b37c7c5ea22263f852a0db482"; }];
    buildInputs = [ qt5 glib2 ];
  };

  "physfs" = fetch {
    pname       = "physfs";
    version     = "3.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-physfs-3.0.2-1-any.pkg.tar.xz"; sha256 = "9685328e8853b73daad64fc60c5625b00ea8aaf533ad1495db6b1d898a036336"; }];
    buildInputs = [ zlib ];
  };

  "pidgin" = fetch {
    pname       = "pidgin";
    version     = "2.11.0";
    srcs        = [{ filename = "mingw-w64-x86_64-pidgin-2.11.0-1-any.pkg.tar.zst"; sha256 = "9faebad9721cc22d7fca41c6f7a5e7c3013f495474e0f72184f7790438a8baa8"; }];
    buildInputs = [ adwaita-icon-theme ca-certificates farstream freetype fontconfig gettext gnutls gsasl gst-plugins-base gst-plugins-good gtk2 gtkspell libgadu libidn meanwhile nss ncurses silc-toolkit zlib ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "pinentry" = fetch {
    pname       = "pinentry";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-pinentry-1.1.0-2-any.pkg.tar.xz"; sha256 = "a50f4ee3684ec6984e12d9b0584fcf601dff358d101bc153b978d0e413db10fb"; }];
    buildInputs = [ qt5 libsecret libassuan ];
  };

  "pixman" = fetch {
    pname       = "pixman";
    version     = "0.40.0";
    srcs        = [{ filename = "mingw-w64-x86_64-pixman-0.40.0-1-any.pkg.tar.xz"; sha256 = "6e8ccea6714d954ebd09c4ce2a0aed8ec0ab352af1453dd7a1ae2d841961a64c"; }];
    buildInputs = [ gcc-libs ];
  };

  "pkg-config" = fetch {
    pname       = "pkg-config";
    version     = "0.29.2";
    srcs        = [{ filename = "mingw-w64-x86_64-pkg-config-0.29.2-2-any.pkg.tar.zst"; sha256 = "8d04f27407df86ba014c2582bd15f79d2148160e43ac6046bbbb57fae00e9082"; }];
    buildInputs = [ libwinpthread-git ];
  };

  "pkgconf" = fetch {
    pname       = "pkgconf";
    version     = "1.3.8";
    srcs        = [{ filename = "mingw-w64-x86_64-pkgconf-1.3.8-1-any.pkg.tar.zst"; sha256 = "ba211ee4dcfc0119298ff8d5c858f66c206e02a6142848b6253fb82607ca68ba"; }];
  };

  "plasma-framework-qt5" = fetch {
    pname       = "plasma-framework-qt5";
    version     = "5.68.0";
    srcs        = [{ filename = "mingw-w64-x86_64-plasma-framework-qt5-5.68.0-1-any.pkg.tar.xz"; sha256 = "2b8c3899564f97cfce5ee56723aae4ea661bd0982c539b27d64e96277d72f2f8"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kactivities-qt5.version "5.68.0"; kactivities-qt5) (assert stdenvNoCC.lib.versionAtLeast kdeclarative-qt5.version "5.68.0"; kdeclarative-qt5) (assert stdenvNoCC.lib.versionAtLeast kirigami2-qt5.version "5.68.0"; kirigami2-qt5) ];
  };

  "plplot" = fetch {
    pname       = "plplot";
    version     = "5.15.0";
    srcs        = [{ filename = "mingw-w64-x86_64-plplot-5.15.0-3-any.pkg.tar.xz"; sha256 = "a52092c3aa70d34194ace7bdce11d96d6ecd7d2026f8d5672cf8ac33e4516b56"; }];
    buildInputs = [ cairo gcc-libs gcc-libgfortran freetype libharu lua python3 python3-numpy shapelib tk wxWidgets qhull-git ];
    broken      = true; # broken dependency plplot -> python3-numpy
  };

  "png2ico" = fetch {
    pname       = "png2ico";
    version     = "2002.12.08";
    srcs        = [{ filename = "mingw-w64-x86_64-png2ico-2002.12.08-2-any.pkg.tar.xz"; sha256 = "43df59b97ac04eb1d71adae150c4343628e1276de51f94a43d0a838c61183489"; }];
    buildInputs = [  ];
  };

  "pngcrush" = fetch {
    pname       = "pngcrush";
    version     = "1.8.13";
    srcs        = [{ filename = "mingw-w64-x86_64-pngcrush-1.8.13-1-any.pkg.tar.xz"; sha256 = "0a60bbe9856e6c795f01ca424d350c3fd1585cae3a749eac1f40fbfae410de79"; }];
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "pngnq" = fetch {
    pname       = "pngnq";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-pngnq-1.1-2-any.pkg.tar.xz"; sha256 = "d9efb31d844fe7b99f20805f2da96caf04a3340a4006a456f6a5f87e69dd28c1"; }];
    buildInputs = [ gcc-libs libpng zlib ];
  };

  "pngquant" = fetch {
    pname       = "pngquant";
    version     = "2.12.6";
    srcs        = [{ filename = "mingw-w64-x86_64-pngquant-2.12.6-1-any.pkg.tar.xz"; sha256 = "47098ecd827807363a347804cfdf4a0f348b746d8f6fb51f3ec9e6be7f79be86"; }];
    buildInputs = [ libpng lcms2 libimagequant ];
  };

  "poco" = fetch {
    pname       = "poco";
    version     = "1.10.1";
    srcs        = [{ filename = "mingw-w64-x86_64-poco-1.10.1-2-any.pkg.tar.xz"; sha256 = "6b9411c956e37ddf663e5f41814bfee43fabba3457e9aa41cf6c87d247a8ff29"; }];
    buildInputs = [ gcc-libs expat libmariadbclient openssl pcre sqlite3 zlib ];
  };

  "podofo" = fetch {
    pname       = "podofo";
    version     = "0.9.6";
    srcs        = [{ filename = "mingw-w64-x86_64-podofo-0.9.6-1-any.pkg.tar.xz"; sha256 = "76bc143b5f8fcb669b3c6355f64eb28fde4e86dd97a361cb7361f011601fa1a5"; }];
    buildInputs = [ fontconfig libtiff libidn libjpeg-turbo lua openssl ];
  };

  "polipo" = fetch {
    pname       = "polipo";
    version     = "1.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-polipo-1.1.1-1-any.pkg.tar.xz"; sha256 = "ea16166a24c4636385080c5b3f58b1632948e03738ecdee4a04909fe117330db"; }];
  };

  "polly" = fetch {
    pname       = "polly";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-polly-10.0.1-1-any.pkg.tar.zst"; sha256 = "4cd4ada60a94c73d7a376d397decf87d6bd8dbe8477c5d9d5ff9865acd70d1b6"; }];
    buildInputs = [ (assert llvm.version=="10.0.1"; llvm) ];
  };

  "poppler" = fetch {
    pname       = "poppler";
    version     = "20.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-poppler-20.10.0-1-any.pkg.tar.zst"; sha256 = "b334a8d50da2c3b568c0e201d6b565865b0504da973e0526f27346cb9ba8bc6d"; }];
    buildInputs = [ cairo curl freetype icu lcms2 libjpeg libpng libtiff nss openjpeg2 poppler-data zlib ];
  };

  "poppler-data" = fetch {
    pname       = "poppler-data";
    version     = "0.4.9";
    srcs        = [{ filename = "mingw-w64-x86_64-poppler-data-0.4.9-1-any.pkg.tar.xz"; sha256 = "8ba4ad9bff84a09b0ad7a539a2c022fdc572ce691012e97467af67ef3495d7db"; }];
    buildInputs = [  ];
  };

  "popt" = fetch {
    pname       = "popt";
    version     = "1.16";
    srcs        = [{ filename = "mingw-w64-x86_64-popt-1.16-1-any.pkg.tar.xz"; sha256 = "307e90e719503bfb6685c765e4f34a239a04e93d473a16d72bf686976819e5a1"; }];
    buildInputs = [ gettext ];
  };

  "port-scanner" = fetch {
    pname       = "port-scanner";
    version     = "1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-port-scanner-1.3-3-any.pkg.tar.xz"; sha256 = "c9f499ec4ffece98cc32ceba294a7519d45948328b83bdbc4364e7b1ff904791"; }];
  };

  "portablexdr" = fetch {
    pname       = "portablexdr";
    version     = "4.9.2.r27.94fb83c";
    srcs        = [{ filename = "mingw-w64-x86_64-portablexdr-4.9.2.r27.94fb83c-3-any.pkg.tar.xz"; sha256 = "557708d5f69d1824810a1306ba688268b92d119b4f7dd736d11c11edf7c31064"; }];
    buildInputs = [ gcc-libs ];
  };

  "portaudio" = fetch {
    pname       = "portaudio";
    version     = "190600_20161030";
    srcs        = [{ filename = "mingw-w64-x86_64-portaudio-190600_20161030-3-any.pkg.tar.xz"; sha256 = "81ca8af23c5ef8122363b1226af28e369e1608902c8ecf71f4266ab722f43d40"; }];
    buildInputs = [ gcc-libs ];
  };

  "portmidi" = fetch {
    pname       = "portmidi";
    version     = "217";
    srcs        = [{ filename = "mingw-w64-x86_64-portmidi-217-2-any.pkg.tar.xz"; sha256 = "5222c6109a597efcfb87b0c4d86076cc08fc0a4b3adfd1977e659c038828e8b9"; }];
    buildInputs = [ gcc-libs ];
  };

  "postgis" = fetch {
    pname       = "postgis";
    version     = "3.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-postgis-3.0.1-2-any.pkg.tar.zst"; sha256 = "e4f9bfda4836eaa1d1e4364c1bfba4d37e8b6bebbdaf5cc270b710b97a36bf7a"; }];
    buildInputs = [ gcc-libs gdal geos gettext json-c libxml2 postgresql proj ];
  };

  "postgresql" = fetch {
    pname       = "postgresql";
    version     = "12.3";
    srcs        = [{ filename = "mingw-w64-x86_64-postgresql-12.3-1-any.pkg.tar.zst"; sha256 = "9ff900c4af104a78483d38551b9b66f18271ce3608768b2837033d0cc6715883"; }];
    buildInputs = [ gcc-libs gettext libxml2 libxslt openssl python tcl zlib winpty ];
  };

  "potrace" = fetch {
    pname       = "potrace";
    version     = "1.16";
    srcs        = [{ filename = "mingw-w64-x86_64-potrace-1.16-1-any.pkg.tar.xz"; sha256 = "917ee90e8a2d18c1d90ff58db15b14b0d7edd3da47cd1fb9c92f55a16a31f45a"; }];
    buildInputs = [  ];
  };

  "premake" = fetch {
    pname       = "premake";
    version     = "4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-premake-4.3-2-any.pkg.tar.xz"; sha256 = "64925f41b0f4a683482513d2206dca4a36f5f7a53c259ff4c4ff42da3e9e1213"; }];
  };

  "proj" = fetch {
    pname       = "proj";
    version     = "6.3.2";
    srcs        = [{ filename = "mingw-w64-x86_64-proj-6.3.2-1-any.pkg.tar.zst"; sha256 = "afe35adc9d9900f645f518131c809aa6138b1a5a3fc9dd45b5cdc8058daeabe8"; }];
    buildInputs = [ gcc-libs sqlite3 ];
  };

  "protobuf" = fetch {
    pname       = "protobuf";
    version     = "3.12.3";
    srcs        = [{ filename = "mingw-w64-x86_64-protobuf-3.12.3-1-any.pkg.tar.zst"; sha256 = "cbaeded275e49137f836df7338dec376e02d095b2a4ab37a4f36a587a6430b0a"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "protobuf-c" = fetch {
    pname       = "protobuf-c";
    version     = "1.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-protobuf-c-1.3.3-1-any.pkg.tar.xz"; sha256 = "f8c656150dd33ae5bca2a6e55423a69dee0ea4977488a7e1553d0353c43a5519"; }];
    buildInputs = [ protobuf ];
  };

  "ptex" = fetch {
    pname       = "ptex";
    version     = "2.3.2";
    srcs        = [{ filename = "mingw-w64-x86_64-ptex-2.3.2-2-any.pkg.tar.zst"; sha256 = "7af86afa962cd96521f074452f11e5a32456334cb09ccc0ecd3330e82da1be7c"; }];
    buildInputs = [ gcc-libs zlib winpthreads-git ];
  };

  "pugixml" = fetch {
    pname       = "pugixml";
    version     = "1.10";
    srcs        = [{ filename = "mingw-w64-x86_64-pugixml-1.10-1-any.pkg.tar.xz"; sha256 = "d83f5993145b84e73b516cb344b80345460a8cd2ad1b3b9993c5311a8d249781"; }];
  };

  "pupnp" = fetch {
    pname       = "pupnp";
    version     = "1.12.1";
    srcs        = [{ filename = "mingw-w64-x86_64-pupnp-1.12.1-1-any.pkg.tar.zst"; sha256 = "30fe65e511d5ffb575286643a255e282c8458ccca2c79f93c733061e62f0b479"; }];
  };

  "purple-skypeweb" = fetch {
    pname       = "purple-skypeweb";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-purple-skypeweb-1.1-1-any.pkg.tar.zst"; sha256 = "8efffdaefe3b818c694ee60f6db602b8fdf80bafdaa8645e1f50f4c9f0c09643"; }];
    buildInputs = [ libpurple json-glib glib2 zlib gettext gcc-libs ];
    broken      = true; # broken dependency purple-skypeweb -> libpurple
  };

  "putty" = fetch {
    pname       = "putty";
    version     = "0.73";
    srcs        = [{ filename = "mingw-w64-x86_64-putty-0.73-1-any.pkg.tar.xz"; sha256 = "12c9ad13cf957422c39f48cf1c6ccc30fdbff5dd1dc5f9f9baa21ff207913a32"; }];
    buildInputs = [ gcc-libs ];
  };

  "putty-ssh" = fetch {
    pname       = "putty-ssh";
    version     = "0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-putty-ssh-0.0-3-any.pkg.tar.xz"; sha256 = "9dccf0f6c151802b7435eed4926d4b66e442e66d51dbb911941346a55a70be4e"; }];
    buildInputs = [ gcc-libs putty ];
  };

  "pybind11" = fetch {
    pname       = "pybind11";
    version     = "2.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-pybind11-2.5.0-1-any.pkg.tar.xz"; sha256 = "22410a83140478e1cfb519e8bff5b773841154526a809b74d7df5ab1cf9a03c5"; }];
  };

  "pygobject2-devel" = fetch {
    pname       = "pygobject2-devel";
    version     = "2.28.7";
    srcs        = [{ filename = "mingw-w64-x86_64-pygobject2-devel-2.28.7-3-any.pkg.tar.xz"; sha256 = "5eb3c75e9f563bf0f7a365fe3d678f316a53bdff654275f042522e51b1b77932"; }];
    buildInputs = [  ];
  };

  "pyilmbase" = fetch {
    pname       = "pyilmbase";
    version     = "2.5.2";
    srcs        = [{ filename = "mingw-w64-x86_64-pyilmbase-2.5.2-1-any.pkg.tar.zst"; sha256 = "cdf4f87925709062cdcce8e0722221578792ad22175e8460a85c553776b637a6"; }];
    buildInputs = [ (assert openexr.version=="2.5.2"; openexr) boost python-numpy ];
  };

  "pyqt-builder" = fetch {
    pname       = "pyqt-builder";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-pyqt-builder-1.4.0-2-any.pkg.tar.zst"; sha256 = "6b26c9e96bead539b3102d59205f80ddbf65a192f54cb5a676661f5fdfaf1d17"; }];
  };

  "pyqt5-sip" = fetch {
    pname       = "pyqt5-sip";
    version     = "12.8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-pyqt5-sip-12.8.0-1-any.pkg.tar.zst"; sha256 = "9c36afdb8f1e3761be830c31068a31e7b261b7c08f0f081c419a12f98ba92895"; }];
    buildInputs = [ python ];
  };

  "pystring" = fetch {
    pname       = "pystring";
    version     = "1.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-pystring-1.1.3-1-any.pkg.tar.xz"; sha256 = "c3726d7f50f9ba839bb3387dd857a63f95c828f411db30b1fe07180ee1675046"; }];
    buildInputs = [ gcc-libs ];
  };

  "python" = fetch {
    pname       = "python";
    version     = "3.8.6";
    srcs        = [{ filename = "mingw-w64-x86_64-python-3.8.6-3-any.pkg.tar.zst"; sha256 = "ded8ce7f5f1bb36aaad88de9e9e02d98a501a1ce98cf97056a464d7230f8358a"; }];
    buildInputs = [ gcc-libs expat bzip2 libffi mpdecimal ncurses openssl sqlite3 tcl tk zlib xz ];
  };

  "python-absl-py" = fetch {
    pname       = "python-absl-py";
    version     = "0.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-absl-py-0.9.0-1-any.pkg.tar.xz"; sha256 = "76534f5951c33947888e90181c0cb37b6145a69d659192e92a37523c456a032d"; }];
    buildInputs = [ python python-six ];
  };

  "python-aiohttp" = fetch {
    pname       = "python-aiohttp";
    version     = "3.6.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-aiohttp-3.6.2-1-any.pkg.tar.zst"; sha256 = "8a704831bda17d577a051f5514aa2d0fc20ab034f3165474d325e8d55e70fd3c"; }];
    buildInputs = [ python-async-timeout python-attrs python-chardet python-yarl ];
  };

  "python-alembic" = fetch {
    pname       = "python-alembic";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-alembic-1.4.2-1-any.pkg.tar.zst"; sha256 = "dfe08d479f04caf74908b7da30969d4f488eecf9dcacee479cc664c4092ccf0b"; }];
    buildInputs = [ python python-mako python-sqlalchemy python-editor python-dateutil ];
  };

  "python-apipkg" = fetch {
    pname       = "python-apipkg";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-apipkg-1.5-1-any.pkg.tar.xz"; sha256 = "6fc979cbd0863b34bf934e7d6613e172472795e0c4c27cd4c17fb4e0bd1e3352"; }];
    buildInputs = [ python ];
  };

  "python-appdirs" = fetch {
    pname       = "python-appdirs";
    version     = "1.4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-appdirs-1.4.3-1-any.pkg.tar.xz"; sha256 = "846f1ca5361cc5dc06487fb2d64b060bc5fa2885355e2c65b81ab459d5c11492"; }];
    buildInputs = [ python ];
  };

  "python-argh" = fetch {
    pname       = "python-argh";
    version     = "0.26.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-argh-0.26.2-1-any.pkg.tar.xz"; sha256 = "0e1e55dc21578b4ce7760e4698489e18bdb7f2a0e66375f36e3979600dc04c23"; }];
    buildInputs = [ python ];
  };

  "python-argon2_cffi" = fetch {
    pname       = "python-argon2_cffi";
    version     = "19.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-argon2_cffi-19.2.0-2-any.pkg.tar.xz"; sha256 = "73d0a0b1c22a84e4b56512ccc69fa81bcf68f2f9dc007ca80f68c4350492d20c"; }];
    buildInputs = [ python python-cffi python-setuptools python-six ];
  };

  "python-asgiref" = fetch {
    pname       = "python-asgiref";
    version     = "3.2.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-asgiref-3.2.5-1-any.pkg.tar.xz"; sha256 = "a9ad03c0048c6ea9558b82171103438ab4c3fe2b03d8c2bbc58f1be1315aa540"; }];
    buildInputs = [ python ];
  };

  "python-asn1crypto" = fetch {
    pname       = "python-asn1crypto";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-asn1crypto-1.3.0-1-any.pkg.tar.xz"; sha256 = "7ee027094bac8c68590ab94413da71b826a56d9cd18c90311226d9bd1125dc61"; }];
    buildInputs = [ python-pycparser ];
  };

  "python-astor" = fetch {
    pname       = "python-astor";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-astor-0.8.1-1-any.pkg.tar.zst"; sha256 = "d9fee22bf3c3a12f06de9bce2af43e1f9d6877146359a936e0be09f4a8598bfe"; }];
    buildInputs = [ python ];
  };

  "python-astroid" = fetch {
    pname       = "python-astroid";
    version     = "2.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-astroid-2.3.3-1-any.pkg.tar.xz"; sha256 = "9709a2edc287ef3a3a76dbe73d5b6db4e5681c4365033c3e9d9738521584357e"; }];
    buildInputs = [ python-six python-lazy-object-proxy python-wrapt python-typed_ast ];
  };

  "python-astunparse" = fetch {
    pname       = "python-astunparse";
    version     = "1.6.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-astunparse-1.6.3-1-any.pkg.tar.zst"; sha256 = "6bb0a06b3d32d5e6e118abee993f7ed40d6dfd8417f7a110cf0421237179a0cc"; }];
    buildInputs = [ python-six ];
  };

  "python-async-timeout" = fetch {
    pname       = "python-async-timeout";
    version     = "3.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-async-timeout-3.0.1-1-any.pkg.tar.zst"; sha256 = "3c3bce725c60ec73d725622b783b1031ba3769c854911bee331593fe1fa5aaad"; }];
    buildInputs = [ python ];
  };

  "python-atomicwrites" = fetch {
    pname       = "python-atomicwrites";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-atomicwrites-1.4.0-1-any.pkg.tar.zst"; sha256 = "e866989f704a9d69c0c41c850a5a11f26dc9fcbf7bbdb85aea6424b2a4d48396"; }];
    buildInputs = [ python ];
  };

  "python-attrs" = fetch {
    pname       = "python-attrs";
    version     = "19.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-attrs-19.3.0-1-any.pkg.tar.xz"; sha256 = "a8ea372a2e7c9edef1484f78c0dbd778c700520a5f3a6091d6849386e23c4ba1"; }];
    buildInputs = [ python ];
  };

  "python-audioread" = fetch {
    pname       = "python-audioread";
    version     = "2.1.8";
    srcs        = [{ filename = "mingw-w64-x86_64-python-audioread-2.1.8-1-any.pkg.tar.zst"; sha256 = "bd775c6d126257bb9eae9f5e000249aa01f67b89c69b92f7d75e95097dbeceae"; }];
    buildInputs = [ python ];
  };

  "python-babel" = fetch {
    pname       = "python-babel";
    version     = "2.8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-babel-2.8.0-1-any.pkg.tar.xz"; sha256 = "aabb8bcab7e35e891f206c525c6b0aceac3a19791f341ecf6be6590416f7951d"; }];
    buildInputs = [ python-pytz ];
  };

  "python-backcall" = fetch {
    pname       = "python-backcall";
    version     = "0.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-backcall-0.1.0-1-any.pkg.tar.xz"; sha256 = "cfca1867b0bffeb6dfa7502d49634f88c09e95a47465f8f90110ddb4ff2166ef"; }];
    buildInputs = [ python ];
  };

  "python-bcrypt" = fetch {
    pname       = "python-bcrypt";
    version     = "3.1.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-bcrypt-3.1.7-1-any.pkg.tar.xz"; sha256 = "1ccecde7a788fd133f33d2d68b86bc91203f067241231676a6be46c20ae660ad"; }];
    buildInputs = [ python python-cffi python-six ];
  };

  "python-beaker" = fetch {
    pname       = "python-beaker";
    version     = "1.11.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-beaker-1.11.0-1-any.pkg.tar.xz"; sha256 = "94cb90d141320256548f963cc15b3013f7def5a58ffeba38c6ee407e924cedfe"; }];
    buildInputs = [ python ];
  };

  "python-beautifulsoup4" = fetch {
    pname       = "python-beautifulsoup4";
    version     = "4.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-beautifulsoup4-4.9.0-1-any.pkg.tar.xz"; sha256 = "2e4bf47709ad94cbe8069af571f8d558c0fa3731fc56612014c5b84c31a7d6c8"; }];
    buildInputs = [ python python-soupsieve ];
  };

  "python-binwalk" = fetch {
    pname       = "python-binwalk";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-binwalk-2.2.0-1-any.pkg.tar.xz"; sha256 = "139613373565be259a813875de0d0d2a3d70aadf2d306ba1866a3c67fafaba6d"; }];
    buildInputs = [ bzip2 libsystre python xz zlib ];
  };

  "python-biopython" = fetch {
    pname       = "python-biopython";
    version     = "1.76";
    srcs        = [{ filename = "mingw-w64-x86_64-python-biopython-1.76-1-any.pkg.tar.xz"; sha256 = "0b5f0fdec3bf500353517ce67a9c9b6d237eba801affd1c7a936160dab8353a0"; }];
    buildInputs = [ python python-numpy ];
  };

  "python-biscuits" = fetch {
    pname       = "python-biscuits";
    version     = "0.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-biscuits-0.3.0-1-any.pkg.tar.zst"; sha256 = "c7210ad0d677c0c5b34f005a79e39b03e02dca769c273359dcadfe9af7a44b77"; }];
    buildInputs = [ python ];
  };

  "python-bleach" = fetch {
    pname       = "python-bleach";
    version     = "3.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-bleach-3.1.3-1-any.pkg.tar.xz"; sha256 = "b271c3e1e15ff78ca6b2b8c8ee9ad8e1729393f992a3eed7f807fb12f5430040"; }];
    buildInputs = [ python python-html5lib ];
  };

  "python-blinker" = fetch {
    pname       = "python-blinker";
    version     = "1.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-blinker-1.4-1-any.pkg.tar.zst"; sha256 = "c11f4f93b34102d0e8c69b1958e71cafd861be6b89dd8389810959d3441ae95f"; }];
    buildInputs = [ python ];
  };

  "python-breathe" = fetch {
    pname       = "python-breathe";
    version     = "4.15.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-breathe-4.15.0-1-any.pkg.tar.xz"; sha256 = "64954f6286e6bfbbcd5e858dc46e5cdbc81b2bea27bcf381b9a301d367828d11"; }];
    buildInputs = [ python python-sphinx ];
  };

  "python-brotli" = fetch {
    pname       = "python-brotli";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-x86_64-python-brotli-1.0.9-1-any.pkg.tar.zst"; sha256 = "9d0a8f11d6ed55eb111e8aa7543cb41d25e2ed815a3465c29ac12416316591a8"; }];
    buildInputs = [ python libwinpthread-git ];
  };

  "python-bsddb3" = fetch {
    pname       = "python-bsddb3";
    version     = "6.2.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-bsddb3-6.2.7-1-any.pkg.tar.xz"; sha256 = "53d663f7ebd1396a6185b9a49e929dd00ce33fb794da04b3a88f3cd71dcd1050"; }];
    buildInputs = [ python db ];
  };

  "python-cachecontrol" = fetch {
    pname       = "python-cachecontrol";
    version     = "0.12.6";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cachecontrol-0.12.6-1-any.pkg.tar.xz"; sha256 = "680dd99cdd98dfa220efd26f6ae86479d57a2dea3e18a0f8fc50cdf26e1f2f3c"; }];
    buildInputs = [ python python-msgpack python-requests ];
  };

  "python-cachetools" = fetch {
    pname       = "python-cachetools";
    version     = "4.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cachetools-4.1.1-1-any.pkg.tar.zst"; sha256 = "3b8f7c9b8dfa298d81ea99851f975dc00aa98e745840c67f51bd61c1786bd5f2"; }];
    buildInputs = [ python ];
  };

  "python-cairo" = fetch {
    pname       = "python-cairo";
    version     = "1.19.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cairo-1.19.1-1-any.pkg.tar.xz"; sha256 = "04e3c8f3297c27a6772713cfab4347ea006e3014d06b1af6c876f81497707dab"; }];
    buildInputs = [ cairo python ];
  };

  "python-can" = fetch {
    pname       = "python-can";
    version     = "3.3.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-can-3.3.2-1-any.pkg.tar.xz"; sha256 = "72e0e95201def0be41536258fa17cfedab8f596d0607f1c3c1ad31a7ea7da0dc"; }];
    buildInputs = [ python python-python_ics python-pyserial ];
  };

  "python-capstone" = fetch {
    pname       = "python-capstone";
    version     = "4.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-capstone-4.0.2-1-any.pkg.tar.zst"; sha256 = "978256e187d930e89fad6668821ccd16e3139233ede4b633285b3e0bc79fc693"; }];
    buildInputs = [ capstone python ];
  };

  "python-certifi" = fetch {
    pname       = "python-certifi";
    version     = "2019.11.28";
    srcs        = [{ filename = "mingw-w64-x86_64-python-certifi-2019.11.28-1-any.pkg.tar.xz"; sha256 = "7eddcef475c3d5e7f4b90779da86e5081ac700fe9194635fdd5ac7caff3c15de"; }];
    buildInputs = [ python ];
  };

  "python-cffi" = fetch {
    pname       = "python-cffi";
    version     = "1.14.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cffi-1.14.0-2-any.pkg.tar.xz"; sha256 = "6bf41df464a6160d001401095fef9f84dfa6b871b6f173eac34dd11786afc48b"; }];
    buildInputs = [ libffi python-pycparser ];
  };

  "python-characteristic" = fetch {
    pname       = "python-characteristic";
    version     = "14.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-characteristic-14.3.0-1-any.pkg.tar.xz"; sha256 = "6dc247014a9ad92a752179615b41149b318b611be68b58968042837bf4bd1171"; }];
    buildInputs = [ python ];
  };

  "python-chardet" = fetch {
    pname       = "python-chardet";
    version     = "3.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-chardet-3.0.4-1-any.pkg.tar.xz"; sha256 = "81dc7e38ab99cddf7b616158d40727e5edfd4a7b6df198b75c61768baf5df861"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-click" = fetch {
    pname       = "python-click";
    version     = "7.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-click-7.1.2-1-any.pkg.tar.zst"; sha256 = "18ca17f9782ceb3362073cab708d2ade9578c0fef47792e2cdd720d14e5c72b0"; }];
    buildInputs = [ python ];
  };

  "python-cliff" = fetch {
    pname       = "python-cliff";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cliff-3.1.0-1-any.pkg.tar.xz"; sha256 = "68ed6b922a7e89c09239d60a4758e1048ac117824210f946c5b8cc3d0167a4e6"; }];
    buildInputs = [ python-six python-pbr python-cmd2 python-prettytable python-pyparsing python-stevedore python-yaml ];
  };

  "python-cmd2" = fetch {
    pname       = "python-cmd2";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cmd2-1.0.2-1-any.pkg.tar.zst"; sha256 = "e52d71b272fce5417a6965262a8d568a6328409b3f33319e079b9b50cbfd1b9d"; }];
    buildInputs = [ python-attrs python-pyparsing python-pyperclip python-pyreadline python-colorama python-wcwidth ];
  };

  "python-colorama" = fetch {
    pname       = "python-colorama";
    version     = "0.4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-colorama-0.4.3-1-any.pkg.tar.xz"; sha256 = "47909db51eefb95844b70b92a7038c7eea26bcebc0710bf4e86c0e2ecc2dc20a"; }];
    buildInputs = [ python ];
  };

  "python-colorspacious" = fetch {
    pname       = "python-colorspacious";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-colorspacious-1.1.2-1-any.pkg.tar.xz"; sha256 = "9c28ed40ac8fc0e8bcadbcd7be5e78658ff2006ae38589cd15a3c062e082b1df"; }];
    buildInputs = [ python python-numpy ];
  };

  "python-colour" = fetch {
    pname       = "python-colour";
    version     = "0.3.13";
    srcs        = [{ filename = "mingw-w64-x86_64-python-colour-0.3.13-1-any.pkg.tar.xz"; sha256 = "551a534a985ab821b06789fef37055dd820163e06023013f44ebac543a807a5a"; }];
    buildInputs = [ python python-scipy python-six ];
  };

  "python-comtypes" = fetch {
    pname       = "python-comtypes";
    version     = "1.1.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-comtypes-1.1.7-2-any.pkg.tar.xz"; sha256 = "4ae0a07a3efa02f4551ae616c28be17392f65097490e3f694e5fa8aecc5eda21"; }];
    buildInputs = [ python ];
  };

  "python-contextlib2" = fetch {
    pname       = "python-contextlib2";
    version     = "0.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-contextlib2-0.6.0-1-any.pkg.tar.xz"; sha256 = "a47a416952ebe287acce79ed0e3037461c544b58233c6ab3caec2602d7c78bcc"; }];
    buildInputs = [ python ];
  };

  "python-coverage" = fetch {
    pname       = "python-coverage";
    version     = "5.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-coverage-5.2.1-1-any.pkg.tar.zst"; sha256 = "7ada12308c07c1c4d165e05c6ac367998238aa44bc2fff5b655c21da8b2d582b"; }];
    buildInputs = [ python ];
  };

  "python-crcmod" = fetch {
    pname       = "python-crcmod";
    version     = "1.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-crcmod-1.7-1-any.pkg.tar.xz"; sha256 = "62058b2fcd439d9689afa466b4265efbd5700a81f0ede8bb5996f3ffb5b4b9e8"; }];
    buildInputs = [ python ];
  };

  "python-cryptography" = fetch {
    pname       = "python-cryptography";
    version     = "2.9.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cryptography-2.9.2-1-any.pkg.tar.zst"; sha256 = "454344c3420f07d269c313bacb94f088129d637868c86e9156d27dc0666712d0"; }];
    buildInputs = [ python-cffi python-pyasn1 python-idna python-asn1crypto ];
  };

  "python-cssselect" = fetch {
    pname       = "python-cssselect";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cssselect-1.1.0-1-any.pkg.tar.xz"; sha256 = "f3c3738a738839b96adec5a57e53ae4eaa4ace47980326a5e48d0d6d618672ae"; }];
    buildInputs = [ python ];
  };

  "python-cvxopt" = fetch {
    pname       = "python-cvxopt";
    version     = "1.2.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cvxopt-1.2.5-1-any.pkg.tar.zst"; sha256 = "8d8ebe6fff081aae1725580bfc15bde59ac60fd46e83ca748c12eb98a29f0ed2"; }];
    buildInputs = [ python openblas suitesparse gsl fftw dsdp glpk ];
  };

  "python-cx_Freeze" = fetch {
    pname       = "python-cx_Freeze";
    version     = "6.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cx_Freeze-6.2-1-any.pkg.tar.zst"; sha256 = "ca1be8caf57a48a61ef9c2866af3282418184d3a3ca49217780dc2bb7058ea05"; }];
    buildInputs = [ python ];
  };

  "python-cycler" = fetch {
    pname       = "python-cycler";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-cycler-0.10.0-1-any.pkg.tar.xz"; sha256 = "374a4c30ff84d6aa2322b47373d424e362fb13ff752b6ac9613b76614b573173"; }];
    buildInputs = [ python python-six ];
  };

  "python-dateutil" = fetch {
    pname       = "python-dateutil";
    version     = "2.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-dateutil-2.8.1-1-any.pkg.tar.xz"; sha256 = "61b8d6da7c86123eed2616056bf404bfc889df6ad5c51e328e431040cae0c7d9"; }];
    buildInputs = [ python-six ];
  };

  "python-ddt" = fetch {
    pname       = "python-ddt";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ddt-1.3.1-1-any.pkg.tar.xz"; sha256 = "1b1c267d507141cec138d326899b56e5dbf8468aa8d03b6e16b6632d7e279db1"; }];
    buildInputs = [ python ];
  };

  "python-debtcollector" = fetch {
    pname       = "python-debtcollector";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-debtcollector-2.0.1-1-any.pkg.tar.xz"; sha256 = "3929d0f479c6ab32e71cd3be8ba7386a9c20dcb1db07f9f66209db64573d0303"; }];
    buildInputs = [ python python-six python-pbr python-babel python-wrapt ];
  };

  "python-decorator" = fetch {
    pname       = "python-decorator";
    version     = "4.4.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-decorator-4.4.2-1-any.pkg.tar.xz"; sha256 = "e99779cf33f2ecdbb5e575edfdfeb0192b1ee5438362d237952d94a8631c9d08"; }];
    buildInputs = [ python ];
  };

  "python-defusedxml" = fetch {
    pname       = "python-defusedxml";
    version     = "0.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-defusedxml-0.6.0-1-any.pkg.tar.xz"; sha256 = "316dffa51b34400c552f74596a9cc6f812e7b8ea4d063138009ba8bac9783311"; }];
    buildInputs = [ python ];
  };

  "python-distlib" = fetch {
    pname       = "python-distlib";
    version     = "0.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-distlib-0.3.1-1-any.pkg.tar.zst"; sha256 = "c418fe24f9f8c5bbaa3fd68673b7cad1d63f0eb6cd70b09e0c57b77949dd4ffc"; }];
    buildInputs = [ python ];
  };

  "python-distutils-extra" = fetch {
    pname       = "python-distutils-extra";
    version     = "2.39";
    srcs        = [{ filename = "mingw-w64-x86_64-python-distutils-extra-2.39-1-any.pkg.tar.xz"; sha256 = "dd0a5816a018ffd77112f4fcef39865ebe099ae3b61f7dd09c1e433ea12a662a"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python.version "3.3"; python) intltool ];
    broken      = true; # broken dependency python-distutils-extra -> intltool
  };

  "python-django" = fetch {
    pname       = "python-django";
    version     = "3.0.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-django-3.0.5-1-any.pkg.tar.zst"; sha256 = "bbbea3516ea80c4ee777f92d41bc3b83e6d83d5c899a16a3549e4a83f7a5047b"; }];
    buildInputs = [ python python-asgiref python-pytz python-sqlparse ];
  };

  "python-dlib" = fetch {
    pname       = "python-dlib";
    version     = "19.20";
    srcs        = [{ filename = "mingw-w64-x86_64-python-dlib-19.20-1-any.pkg.tar.zst"; sha256 = "4f87800bd4b3c202cbf1c15128dff3469af4f66f112486969ff6e9fab81847cf"; }];
    buildInputs = [ dlib python ];
  };

  "python-dnspython" = fetch {
    pname       = "python-dnspython";
    version     = "1.16.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-dnspython-1.16.0-1-any.pkg.tar.xz"; sha256 = "24ed2904fc02299dbb598dcd6459cd320ca07c0fac5776c62fb9b8f5f3c0b9bd"; }];
    buildInputs = [ python ];
  };

  "python-docutils" = fetch {
    pname       = "python-docutils";
    version     = "0.16";
    srcs        = [{ filename = "mingw-w64-x86_64-python-docutils-0.16-1-any.pkg.tar.xz"; sha256 = "0dd5942fda10ea29afa83336b4cc0659a3189ca90c9b668ca32dda0550b7598f"; }];
    buildInputs = [ python ];
  };

  "python-editor" = fetch {
    pname       = "python-editor";
    version     = "1.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-editor-1.0.4-1-any.pkg.tar.xz"; sha256 = "5d24872aec463795a0e268b164e246e874cdf7700f612c9e7a518d69d651be6b"; }];
    buildInputs = [ python ];
  };

  "python-email-validator" = fetch {
    pname       = "python-email-validator";
    version     = "1.0.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-email-validator-1.0.5-1-any.pkg.tar.xz"; sha256 = "f0bf37318a7b1cf157917a92ae4056ec873591756609e025c91a4ef6e193df22"; }];
    buildInputs = [ python python-dnspython python-idna ];
  };

  "python-entrypoints" = fetch {
    pname       = "python-entrypoints";
    version     = "0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-entrypoints-0.3-1-any.pkg.tar.xz"; sha256 = "72768b2020ca613d9e9a955a785a338ea954fb3aebb2e415b5d0f0df288ed4cc"; }];
  };

  "python-et-xmlfile" = fetch {
    pname       = "python-et-xmlfile";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-et-xmlfile-1.0.1-1-any.pkg.tar.xz"; sha256 = "83cc12d67ad0a2ee276ba91fafa281552e4bfef6707342ea04c2b5d631c3ee0e"; }];
    buildInputs = [ python-lxml ];
  };

  "python-eventlet" = fetch {
    pname       = "python-eventlet";
    version     = "0.25.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-eventlet-0.25.1-1-any.pkg.tar.xz"; sha256 = "56319d96e9bfe19d2b6a9c65326d6e77486f6ac487662a53461c403ee51f468f"; }];
    buildInputs = [ python python-greenlet python-monotonic ];
  };

  "python-execnet" = fetch {
    pname       = "python-execnet";
    version     = "1.7.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-execnet-1.7.1-1-any.pkg.tar.xz"; sha256 = "9377344dde67d2511fbcd3c1088c8ccb154ecff7eefc5b4eb24b390260c4756b"; }];
    buildInputs = [ python python-apipkg ];
  };

  "python-extras" = fetch {
    pname       = "python-extras";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-extras-1.0.0-1-any.pkg.tar.xz"; sha256 = "67c55e414061a00dcf5535c03be90f26f1c7a336ab35898f7d13d5c1d171b267"; }];
    buildInputs = [ python ];
  };

  "python-faker" = fetch {
    pname       = "python-faker";
    version     = "4.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-faker-4.0.3-1-any.pkg.tar.zst"; sha256 = "71f4c9fbe96d570ddec9e2e915f79eca0d2752130e9eb3a23630edea492e8c8f"; }];
    buildInputs = [ python python-dateutil python-six python-text-unidecode ];
  };

  "python-fasteners" = fetch {
    pname       = "python-fasteners";
    version     = "0.15";
    srcs        = [{ filename = "mingw-w64-x86_64-python-fasteners-0.15-1-any.pkg.tar.xz"; sha256 = "58b8ece524f101657f4a85edf86a94187d5f50719cfe58b233ed4969c433a6e0"; }];
    buildInputs = [ python python-six python-monotonic ];
  };

  "python-feedgenerator" = fetch {
    pname       = "python-feedgenerator";
    version     = "1.9.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-feedgenerator-1.9.1-1-any.pkg.tar.zst"; sha256 = "2982c521efc87f2c64f308947747602e3aad8dc257852849ac88339a4d00e2d4"; }];
    buildInputs = [ python python-pytz python-six ];
  };

  "python-ffmpeg-python" = fetch {
    pname       = "python-ffmpeg-python";
    version     = "0.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ffmpeg-python-0.2.0-1-any.pkg.tar.zst"; sha256 = "f7164cf45c7e9793cc1a08793173866f59f707c90a2b0d590f6525706129cdd8"; }];
    buildInputs = [ python-future ffmpeg ];
  };

  "python-filelock" = fetch {
    pname       = "python-filelock";
    version     = "3.0.12";
    srcs        = [{ filename = "mingw-w64-x86_64-python-filelock-3.0.12-1-any.pkg.tar.xz"; sha256 = "3fdb4181ab323c520477558bcd24b9fa6eb3e2bcb6b6ab7d2676f44ced6c1438"; }];
    buildInputs = [ python ];
  };

  "python-fire" = fetch {
    pname       = "python-fire";
    version     = "0.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-fire-0.3.1-1-any.pkg.tar.zst"; sha256 = "b694639a2b736541928623e5873b27c7c08399058964539549ae048452ae8b01"; }];
    buildInputs = [ python-termcolor ];
  };

  "python-fixtures" = fetch {
    pname       = "python-fixtures";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-fixtures-3.0.0-1-any.pkg.tar.xz"; sha256 = "415194704f31d9dbc884c6dd3f07e6c2814aba86caf9f14ebae85eb5caccb3ba"; }];
    buildInputs = [ python python-pbr python-six ];
  };

  "python-flake8" = fetch {
    pname       = "python-flake8";
    version     = "3.7.9";
    srcs        = [{ filename = "mingw-w64-x86_64-python-flake8-3.7.9-2-any.pkg.tar.xz"; sha256 = "caea9ecaccc52d210091dbf05ab4160c4f201d4b33df29f286cfbb7de87c17df"; }];
    buildInputs = [ python-pyflakes python-mccabe python-entrypoints python-pycodestyle ];
  };

  "python-flaky" = fetch {
    pname       = "python-flaky";
    version     = "3.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-flaky-3.6.1-1-any.pkg.tar.xz"; sha256 = "8d0efb6a6f5d8340b5ccabcff7216548e76df48c946b6a318cbf8469baa6834a"; }];
    buildInputs = [ python ];
  };

  "python-flask" = fetch {
    pname       = "python-flask";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-flask-1.1.2-1-any.pkg.tar.zst"; sha256 = "f576331dbcb71c406c6d3804b27dc3c5fd1e467a65edbc9ec2f038bcf329641e"; }];
    buildInputs = [ python-click python-itsdangerous python-jinja python-werkzeug ];
  };

  "python-flexmock" = fetch {
    pname       = "python-flexmock";
    version     = "0.10.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-flexmock-0.10.4-1-any.pkg.tar.xz"; sha256 = "175ca0a2d2309a67342e47ee2f95fe8f393690750bea7f3d80ac528aa4cb620e"; }];
    buildInputs = [ python ];
  };

  "python-fonttools" = fetch {
    pname       = "python-fonttools";
    version     = "4.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-fonttools-4.8.1-1-any.pkg.tar.zst"; sha256 = "e8aafb4313a0dcbd272340d15e74b0c473ad271a0e3cdfe19d222370af2c33f2"; }];
    buildInputs = [ python python-numpy ];
  };

  "python-freezegun" = fetch {
    pname       = "python-freezegun";
    version     = "0.3.15";
    srcs        = [{ filename = "mingw-w64-x86_64-python-freezegun-0.3.15-1-any.pkg.tar.xz"; sha256 = "5aaa10cfdf87d054308361ba3d7578055991aa5ec235af5fba1c5e6e1667fb33"; }];
    buildInputs = [ python python-dateutil ];
  };

  "python-funcsigs" = fetch {
    pname       = "python-funcsigs";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-funcsigs-1.0.2-1-any.pkg.tar.xz"; sha256 = "34b8d7239ca138aaa69473270158d3a4ed7ed25dfb440999fc53be5087fdb123"; }];
  };

  "python-future" = fetch {
    pname       = "python-future";
    version     = "0.18.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-future-0.18.2-1-any.pkg.tar.xz"; sha256 = "b805a9e64a3bbb1338db0233dbd16c0c4aa34d73fa928aa2f9ed76bef566c59f"; }];
    buildInputs = [ python ];
  };

  "python-gast" = fetch {
    pname       = "python-gast";
    version     = "0.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-gast-0.4.0-1-any.pkg.tar.zst"; sha256 = "746c376df0cbf612e4ff424f99f6bafe6a3f229b7add85098e5c4b54d4101694"; }];
    buildInputs = [ python ];
  };

  "python-genty" = fetch {
    pname       = "python-genty";
    version     = "1.3.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-genty-1.3.2-1-any.pkg.tar.xz"; sha256 = "98c03e6bd6ed6587622a0cc1e6294927c55a88aa0ecf24ed3a7f20a2d5ec6cf2"; }];
    buildInputs = [ python python-six ];
  };

  "python-gmpy2" = fetch {
    pname       = "python-gmpy2";
    version     = "2.1.0b4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-gmpy2-2.1.0b4-3-any.pkg.tar.zst"; sha256 = "35fde6f3670f00c39e984676a29b9b30c4b73b0337f0727f3c40966a1f790087"; }];
    buildInputs = [ python mpc ];
  };

  "python-gobject" = fetch {
    pname       = "python-gobject";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-gobject-3.38.0-1-any.pkg.tar.zst"; sha256 = "83036e6ec0a163590856a4772131d6dc3478dd123ef0f734874f1f1a9747913d"; }];
    buildInputs = [ glib2 python-cairo libffi gobject-introspection-runtime ];
  };

  "python-google-auth" = fetch {
    pname       = "python-google-auth";
    version     = "1.22.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-google-auth-1.22.1-1-any.pkg.tar.zst"; sha256 = "664660e7b9c7f7c95460b75952e4756c4f150f836d83f2dcf49310843af3f0a2"; }];
    buildInputs = [ ca-certificates python-cachetools python-pyasn1-modules python-rsa ];
  };

  "python-google-resumable-media" = fetch {
    pname       = "python-google-resumable-media";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-google-resumable-media-1.0.0-1-any.pkg.tar.zst"; sha256 = "37d8da6ed3b38539e0622d67c2e074430dfe12a0c8c4f8b4345e543186339f9d"; }];
    buildInputs = [ python-six ];
  };

  "python-googleapis-common-protos" = fetch {
    pname       = "python-googleapis-common-protos";
    version     = "1.52.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-googleapis-common-protos-1.52.0-1-any.pkg.tar.zst"; sha256 = "f7d2bd05ddef8c93554a8070b271b2dcdd43121b285025ac6ff69e03bfba60a7"; }];
    buildInputs = [ python-protobuf ];
  };

  "python-greenlet" = fetch {
    pname       = "python-greenlet";
    version     = "0.4.15";
    srcs        = [{ filename = "mingw-w64-x86_64-python-greenlet-0.4.15-1-any.pkg.tar.xz"; sha256 = "1dee8549b40c23bcba960b6c41f4ff553ffb56ffd9bd9633b0910a37430bed75"; }];
    buildInputs = [ python ];
  };

  "python-gssapi" = fetch {
    pname       = "python-gssapi";
    version     = "1.6.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-gssapi-1.6.5-1-any.pkg.tar.zst"; sha256 = "1e269583336ef2955dd0b1a6d728fa17025664a6cf21ed9696e8a2f3a77806ac"; }];
    buildInputs = [ python python-decorator python-six gss cython ];
  };

  "python-gsutil" = fetch {
    pname       = "python-gsutil";
    version     = "4.53";
    srcs        = [{ filename = "mingw-w64-x86_64-python-gsutil-4.53-1-any.pkg.tar.zst"; sha256 = "1a20ac32288cf783bfd09f53d49d2b417a40ccf54dc04110beac756a0a7723d4"; }];
    buildInputs = [ python ];
  };

  "python-h5py" = fetch {
    pname       = "python-h5py";
    version     = "2.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-h5py-2.10.0-1-any.pkg.tar.xz"; sha256 = "d45e4252123dd3118bd0187e0d1a4688ec33b3084ceb2ba6dbd0c9f4ef9a2d6b"; }];
    buildInputs = [ python-numpy python-six hdf5 ];
  };

  "python-hacking" = fetch {
    pname       = "python-hacking";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-hacking-3.0.0-1-any.pkg.tar.zst"; sha256 = "a9a28a47338669d41d2e32539545856e09fe0c102b4dd6e300fc312117c02ebf"; }];
    buildInputs = [ python ];
  };

  "python-html5lib" = fetch {
    pname       = "python-html5lib";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-html5lib-1.0.1-1-any.pkg.tar.xz"; sha256 = "e4855145bc0916aeb63475759e42889f9a8774123aa0f02e5a9f2516e5939a21"; }];
    buildInputs = [ python python-six python-webencodings ];
  };

  "python-httplib2" = fetch {
    pname       = "python-httplib2";
    version     = "0.17.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-httplib2-0.17.3-1-any.pkg.tar.zst"; sha256 = "b309a3df2351afcb8382ec8fe7b69578d61affaf2e463bac7a689a6ec081bac6"; }];
    buildInputs = [ python python-certifi ca-certificates ];
  };

  "python-hunter" = fetch {
    pname       = "python-hunter";
    version     = "3.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-hunter-3.1.3-1-any.pkg.tar.zst"; sha256 = "d58a6c542c93ddc5e0fb59d995bf49afdbcc0a1f8eb3b166d7da4f641dfb38f6"; }];
    buildInputs = [ python-colorama python-manhole ];
  };

  "python-hypothesis" = fetch {
    pname       = "python-hypothesis";
    version     = "5.8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-hypothesis-5.8.0-1-any.pkg.tar.xz"; sha256 = "6d2c575bc7019cc4df9337c1c84e641316473d6eba2b6dbd37eb263aa8db4079"; }];
    buildInputs = [ python python-attrs python-coverage python-sortedcontainers ];
  };

  "python-icu" = fetch {
    pname       = "python-icu";
    version     = "2.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-icu-2.5-1-any.pkg.tar.zst"; sha256 = "aa989e0ad671b67a1ec073523057e5377397a4f07b8731fb7f3c1fbeed492f58"; }];
    buildInputs = [ python icu ];
  };

  "python-idna" = fetch {
    pname       = "python-idna";
    version     = "2.9";
    srcs        = [{ filename = "mingw-w64-x86_64-python-idna-2.9-1-any.pkg.tar.xz"; sha256 = "57b9ce3854460a469ee4fc1be616e970af52b4d059a56f81e45865721e320bcb"; }];
    buildInputs = [ python ];
  };

  "python-ifaddr" = fetch {
    pname       = "python-ifaddr";
    version     = "0.1.6";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ifaddr-0.1.6-1-any.pkg.tar.xz"; sha256 = "873691de411a84decea33444320080b7edee00417567cd64b00c72f7a2956ee0"; }];
    buildInputs = [ python ];
  };

  "python-imagecodecs" = fetch {
    pname       = "python-imagecodecs";
    version     = "2020.5.30";
    srcs        = [{ filename = "mingw-w64-x86_64-python-imagecodecs-2020.5.30-1-any.pkg.tar.zst"; sha256 = "c0be6a5dc0f0b9debb152f262e00dea1f69d3c3c5a2871a1379becfa0f21cc45"; }];
    buildInputs = [ blosc brotli jxrlib lcms2 libaec libjpeg libmng libpng libtiff libwebp openjpeg2 python-numpy snappy zopfli ];
  };

  "python-imageio" = fetch {
    pname       = "python-imageio";
    version     = "2.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-imageio-2.9.0-2-any.pkg.tar.zst"; sha256 = "e084753eacb8872af7eed961b8f4a53ecd795bc6e950e09e8844158a8dcbd863"; }];
    buildInputs = [ python-numpy python-pillow ];
  };

  "python-imagesize" = fetch {
    pname       = "python-imagesize";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-imagesize-1.2.0-1-any.pkg.tar.xz"; sha256 = "f7d40c423690213e00cad9cbd092be86867f04a0a2aac0b1b124ac9a48d6647f"; }];
    buildInputs = [ python ];
  };

  "python-imbalanced-learn" = fetch {
    pname       = "python-imbalanced-learn";
    version     = "0.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-imbalanced-learn-0.6.1-1-any.pkg.tar.xz"; sha256 = "0b01124ec22cc5f7dee2954d04912607afb8b39d18570d2d4261b3983d59f032"; }];
    buildInputs = [ python python-joblib python-numpy python-scikit-learn python-scipy ];
  };

  "python-imgviz" = fetch {
    pname       = "python-imgviz";
    version     = "1.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-imgviz-1.2.2-1-any.pkg.tar.zst"; sha256 = "dc8ae43cf643cdc164012d525130f7dbfda5218cca6d2494f93d463e6aebf945"; }];
    buildInputs = [ python-pillow python-numpy python-matplotlib python-yaml ];
  };

  "python-importlib-metadata" = fetch {
    pname       = "python-importlib-metadata";
    version     = "1.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-importlib-metadata-1.5.1-1-any.pkg.tar.zst"; sha256 = "e6bf7877041860135faa996a07a5e92a9888b2c27cc3ec9b742939d262d7139c"; }];
    buildInputs = [ python python-zipp ];
  };

  "python-iniconfig" = fetch {
    pname       = "python-iniconfig";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-iniconfig-1.0.0-1-any.pkg.tar.xz"; sha256 = "f6a41e49c492dcccd527282e4dd3fc539b8ade0f15e189292f6d1559e39e0cae"; }];
    buildInputs = [ python ];
  };

  "python-iocapture" = fetch {
    pname       = "python-iocapture";
    version     = "0.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-iocapture-0.1.2-1-any.pkg.tar.xz"; sha256 = "bc2f7385456295c6f0998baee9aa46ce3db9126657b693e4789fa744ab7ad371"; }];
    buildInputs = [ python ];
  };

  "python-ipykernel" = fetch {
    pname       = "python-ipykernel";
    version     = "5.1.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ipykernel-5.1.4-1-any.pkg.tar.xz"; sha256 = "26040cb0c4b6320bfdb8a1e1df6df512c89d5f223457651950848a8e4b9e4a54"; }];
    buildInputs = [ python-ipython python-ipython_genutils python-pathlib2 python-pyzmq python-tornado python-traitlets python-jupyter_client ];
  };

  "python-ipython" = fetch {
    pname       = "python-ipython";
    version     = "7.13.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ipython-7.13.0-1-any.pkg.tar.xz"; sha256 = "e5956dbcc892adcfec398a8a424a3fa11382603341d124f86fb8235118b971ae"; }];
    buildInputs = [ winpty sqlite3 python-jedi python-decorator python-pickleshare python-simplegeneric python-traitlets (assert stdenvNoCC.lib.versionAtLeast python-prompt_toolkit.version "2.0"; python-prompt_toolkit) python-pygments python-backcall python-pexpect python-colorama python-win_unicode_console ];
  };

  "python-ipython_genutils" = fetch {
    pname       = "python-ipython_genutils";
    version     = "0.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ipython_genutils-0.2.0-1-any.pkg.tar.xz"; sha256 = "c2aa0e3d1ff4dfa7ba0d4e9c1b744b09727812e436a7b3985273c1c0ce9a7286"; }];
    buildInputs = [ python ];
  };

  "python-ipywidgets" = fetch {
    pname       = "python-ipywidgets";
    version     = "7.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ipywidgets-7.5.1-1-any.pkg.tar.xz"; sha256 = "0f0401ded50a2a1c01dbb7f69753be64fa7a60b9dfeb9ff7f667b2158d171d88"; }];
    buildInputs = [ python ];
  };

  "python-iso8601" = fetch {
    pname       = "python-iso8601";
    version     = "0.1.12";
    srcs        = [{ filename = "mingw-w64-x86_64-python-iso8601-0.1.12-1-any.pkg.tar.xz"; sha256 = "5742521c508a38de75052756688b70f33e93fba659e4c8d79ea9fb56c47ff463"; }];
    buildInputs = [ python ];
  };

  "python-isort" = fetch {
    pname       = "python-isort";
    version     = "4.3.21.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-isort-4.3.21.2-2-any.pkg.tar.xz"; sha256 = "79215a8da7626d28d48c2d875f4f5b7629d26a9e0e4b137918cd24acabc26cf0"; }];
    buildInputs = [ python ];
  };

  "python-itsdangerous" = fetch {
    pname       = "python-itsdangerous";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-itsdangerous-1.1.0-1-any.pkg.tar.zst"; sha256 = "22c4895ae716deda1f2aa1055d73d6d82dab28a30df7d8f5d19234b5b7dccf5a"; }];
    buildInputs = [ python ];
  };

  "python-jdcal" = fetch {
    pname       = "python-jdcal";
    version     = "1.4.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-jdcal-1.4.1-1-any.pkg.tar.xz"; sha256 = "cff32ea39a3b57dabf9bf8f7ffee20bae242083ce341bb7ae18e8ffc1a7f8467"; }];
    buildInputs = [ python ];
  };

  "python-jedi" = fetch {
    pname       = "python-jedi";
    version     = "0.16.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-jedi-0.16.0-1-any.pkg.tar.xz"; sha256 = "1938357483af31e62f83b08904f9d31d239282e4a91ed5780d360df45d9a2d30"; }];
    buildInputs = [ python python-parso ];
  };

  "python-jinja" = fetch {
    pname       = "python-jinja";
    version     = "2.11.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-jinja-2.11.2-1-any.pkg.tar.zst"; sha256 = "421443a42b46446eb78ba97d2dc48888ab86822cb6ccd31065a3012b98fba525"; }];
    buildInputs = [ python-setuptools python-markupsafe ];
  };

  "python-joblib" = fetch {
    pname       = "python-joblib";
    version     = "0.14.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-joblib-0.14.1-1-any.pkg.tar.xz"; sha256 = "1d967578485b0a4e784d505a2efd1d9cbe460389fb3f46129019ab3dd20c80fb"; }];
    buildInputs = [ python ];
  };

  "python-json-rpc" = fetch {
    pname       = "python-json-rpc";
    version     = "1.12.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-json-rpc-1.12.2-1-any.pkg.tar.xz"; sha256 = "4127cdbc8327555ad2b2f6f91bc3f4f5499f75f4c362549b41fcf20524de1e7f"; }];
    buildInputs = [ python ];
  };

  "python-jsonschema" = fetch {
    pname       = "python-jsonschema";
    version     = "3.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-jsonschema-3.2.0-1-any.pkg.tar.xz"; sha256 = "80205ea9625edb09e6d610f295e4ee3798651d494ef2c9a80e0f9d65bc320f7e"; }];
    buildInputs = [ python python-setuptools python-attrs python-pyrsistent python-importlib-metadata ];
  };

  "python-jupyter-nbconvert" = fetch {
    pname       = "python-jupyter-nbconvert";
    version     = "5.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-jupyter-nbconvert-5.6.1-1-any.pkg.tar.xz"; sha256 = "530486d487b191fcea339071f8a6756f498b38e1efbee480ea288d0d9dfc3496"; }];
    buildInputs = [ python python-defusedxml python-jupyter_client python-jupyter-nbformat python-pygments python-mistune python-jinja python-entrypoints python-traitlets python-pandocfilters python-bleach python-testpath ];
  };

  "python-jupyter-nbformat" = fetch {
    pname       = "python-jupyter-nbformat";
    version     = "4.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-jupyter-nbformat-4.4.0-1-any.pkg.tar.xz"; sha256 = "f34210e1cb51e8230a029f56b1a9213c3d7d72a51fd34d2bc4306abbed2ce2e6"; }];
    buildInputs = [ python python-traitlets python-jsonschema python-jupyter_core ];
  };

  "python-jupyter_client" = fetch {
    pname       = "python-jupyter_client";
    version     = "6.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-jupyter_client-6.0.0-1-any.pkg.tar.xz"; sha256 = "48b1ef146294c9e8459f40c0c4838165ed69050e90176c36c80b3c437f469784"; }];
    buildInputs = [ python python-dateutil python-entrypoints python-jupyter_core python-pyzmq python-tornado python-traitlets ];
  };

  "python-jupyter_console" = fetch {
    pname       = "python-jupyter_console";
    version     = "6.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-jupyter_console-6.1.0-1-any.pkg.tar.xz"; sha256 = "9a5a6d322c78c5134b1dfa7036b5d46610ed56610ba09df4e1bfdd87b92525bc"; }];
    buildInputs = [ python python-jupyter_core python-jupyter_client python-colorama ];
  };

  "python-jupyter_core" = fetch {
    pname       = "python-jupyter_core";
    version     = "4.6.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-jupyter_core-4.6.3-1-any.pkg.tar.xz"; sha256 = "612f0ea9f463223049d350c53b1be66afef625c59060517191950d66ba11d4f5"; }];
    buildInputs = [ python ];
  };

  "python-keras" = fetch {
    pname       = "python-keras";
    version     = "2.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-keras-2.3.1-1-any.pkg.tar.xz"; sha256 = "7fe03ab62c1a656961922cde60e3f1b76418f52b99325ce438514b0799de0fb3"; }];
    buildInputs = [ python python-numpy python-scipy python-six python-yaml python-h5py python-keras_applications python-keras_preprocessing python-theano ];
  };

  "python-keras_applications" = fetch {
    pname       = "python-keras_applications";
    version     = "1.0.8";
    srcs        = [{ filename = "mingw-w64-x86_64-python-keras_applications-1.0.8-1-any.pkg.tar.xz"; sha256 = "b30b82f02ea9cf7a5407c6a03339e0109e51e71f1b0b9776fbd38d4ba0446a72"; }];
    buildInputs = [ python python-numpy python-h5py ];
  };

  "python-keras_preprocessing" = fetch {
    pname       = "python-keras_preprocessing";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-keras_preprocessing-1.1.0-1-any.pkg.tar.xz"; sha256 = "f73c588a58ec6da4cbfcf7c60cfd073697157a7ac6777eabef42656b4e15fb43"; }];
    buildInputs = [ python python-numpy python-six ];
  };

  "python-kiwisolver" = fetch {
    pname       = "python-kiwisolver";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-kiwisolver-1.1.0-1-any.pkg.tar.xz"; sha256 = "5dadabf0959b8bb11083a0f5d5f8ad25e503eb9565557c4207a202c9b484d683"; }];
    buildInputs = [ python ];
  };

  "python-labelme" = fetch {
    pname       = "python-labelme";
    version     = "4.5.6";
    srcs        = [{ filename = "mingw-w64-x86_64-python-labelme-4.5.6-1-any.pkg.tar.zst"; sha256 = "2465b3dc0641bf02387480a416194ce9612132cfa5eeb5d8b219f338a3d7a566"; }];
    buildInputs = [ python-imgviz python-termcolor python-qtpy ];
  };

  "python-lazy-object-proxy" = fetch {
    pname       = "python-lazy-object-proxy";
    version     = "1.4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-lazy-object-proxy-1.4.3-1-any.pkg.tar.xz"; sha256 = "8241f45482bf22536b37f733766c8ff108b322a2da5ce15a1f6817e9bb6402f0"; }];
    buildInputs = [ python ];
  };

  "python-ldap" = fetch {
    pname       = "python-ldap";
    version     = "3.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ldap-3.2.0-1-any.pkg.tar.xz"; sha256 = "fe1296f905a3a850f4fe55a13fc7cc8d7bff548aa1780ac9af82af0ac1dec73d"; }];
    buildInputs = [ python ];
  };

  "python-ldap3" = fetch {
    pname       = "python-ldap3";
    version     = "2.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ldap3-2.7-1-any.pkg.tar.xz"; sha256 = "a5cc6a9e056684967100e9e7129acd090af80f9e29d1549523d03b8f38f0cfdf"; }];
    buildInputs = [ python ];
  };

  "python-lhafile" = fetch {
    pname       = "python-lhafile";
    version     = "0.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-lhafile-0.2.2-1-any.pkg.tar.xz"; sha256 = "63ff272298090979da75a815aec989d53be959569580cc171ca7987ca9cfc9a1"; }];
    buildInputs = [ python python-six ];
  };

  "python-llvmlite" = fetch {
    pname       = "python-llvmlite";
    version     = "0.34.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-llvmlite-0.34.0-4-any.pkg.tar.zst"; sha256 = "73322d7803f9ce8ead0e6a64ec556892af7a40ba3f40ec6c55c4fab24e74f1cc"; }];
    buildInputs = [ python (assert stdenvNoCC.lib.versionAtLeast polly.version "10.0.1"; polly) ];
  };

  "python-lockfile" = fetch {
    pname       = "python-lockfile";
    version     = "0.12.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-lockfile-0.12.2-1-any.pkg.tar.xz"; sha256 = "467ecc87ee9b1f1af8f56458dc910567c13cdf0dc85bc6bf5845454328aea6c1"; }];
    buildInputs = [ python ];
  };

  "python-lxml" = fetch {
    pname       = "python-lxml";
    version     = "4.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-lxml-4.5.0-1-any.pkg.tar.xz"; sha256 = "16b45580b6e4f2d76f04ec7275531f170de18b2bffc544555ed3f29c14018953"; }];
    buildInputs = [ libxml2 libxslt python ];
  };

  "python-lz4" = fetch {
    pname       = "python-lz4";
    version     = "2.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-lz4-2.2.1-2-any.pkg.tar.xz"; sha256 = "dc50d40d609fd4a3300fde187d3890f0f95e0908f9227a31cb5b32215a3f38e1"; }];
    buildInputs = [ python ];
  };

  "python-lzo" = fetch {
    pname       = "python-lzo";
    version     = "1.12";
    srcs        = [{ filename = "mingw-w64-x86_64-python-lzo-1.12-1-any.pkg.tar.zst"; sha256 = "525870168b993f7105d09ae816ef15db6c6c920de65f47d82687f247199179dd"; }];
    buildInputs = [ python lzo2 ];
  };

  "python-mako" = fetch {
    pname       = "python-mako";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-mako-1.1.2-1-any.pkg.tar.xz"; sha256 = "e0cee1a009e5079e99df41d4c7d815c568ddceb04b037133d9dc53e1bd08f1df"; }];
    buildInputs = [ python-markupsafe python-beaker ];
  };

  "python-mallard-ducktype" = fetch {
    pname       = "python-mallard-ducktype";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-mallard-ducktype-1.0.2-1-any.pkg.tar.xz"; sha256 = "39a064af551154934940beeffecb48c1d4200c7023ed9373c8a564514476857d"; }];
    buildInputs = [ python ];
  };

  "python-manhole" = fetch {
    pname       = "python-manhole";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-manhole-1.6.0-1-any.pkg.tar.zst"; sha256 = "460a4b1579e510c638c9e2a26a45fd5c8174166ecca7ac0652ce00a7fc8a2aa1"; }];
    buildInputs = [ python ];
  };

  "python-markdown" = fetch {
    pname       = "python-markdown";
    version     = "3.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-markdown-3.1.1-1-any.pkg.tar.xz"; sha256 = "5103706994e8bf1f381afd9f6b615917316a26ee5b59efced3d97e36997f2949"; }];
    buildInputs = [ python ];
  };

  "python-markdown-math" = fetch {
    pname       = "python-markdown-math";
    version     = "0.6";
    srcs        = [{ filename = "mingw-w64-x86_64-python-markdown-math-0.6-1-any.pkg.tar.xz"; sha256 = "c06390e3f156da7d1f5e9d3781f4e78592ba01cc0a7f26150d1986e3f74d8636"; }];
    buildInputs = [ python python-markdown ];
  };

  "python-markups" = fetch {
    pname       = "python-markups";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-markups-3.0.0-1-any.pkg.tar.xz"; sha256 = "fb73d1876fdd6a16f1b283f2bef1c293b65c8ee701af0b19f1bb694ac2ddfbf2"; }];
    buildInputs = [ python python-markdown-math python-setuptools ];
  };

  "python-markupsafe" = fetch {
    pname       = "python-markupsafe";
    version     = "1.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-markupsafe-1.1.1-1-any.pkg.tar.xz"; sha256 = "3ec9e037792ebce2f2b9aa4c5a1cd1dc200e6f7b11dbec69b457916412a47e6c"; }];
    buildInputs = [ python ];
  };

  "python-matplotlib" = fetch {
    pname       = "python-matplotlib";
    version     = "3.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-matplotlib-3.2.2-1-any.pkg.tar.zst"; sha256 = "cfa441882457daee8567960aef1edd0bd7559648fb80e26b15027d1ec1a6401e"; }];
    buildInputs = [ python-pytz python-numpy python-cycler python-dateutil python-pyparsing python-kiwisolver freetype libpng ];
  };

  "python-mccabe" = fetch {
    pname       = "python-mccabe";
    version     = "0.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-mccabe-0.6.1-1-any.pkg.tar.xz"; sha256 = "29859d73b48e498f0aba72cca08fb1e54878b56f8d85729affeba00d3eac6eea"; }];
    buildInputs = [ python ];
  };

  "python-mimeparse" = fetch {
    pname       = "python-mimeparse";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-mimeparse-1.6.0-1-any.pkg.tar.xz"; sha256 = "7c26db5a558c17d8538ab7c3ee9d1139b38acb3a3752dec9de10162339aea5d8"; }];
    buildInputs = [ python ];
  };

  "python-mistune" = fetch {
    pname       = "python-mistune";
    version     = "0.8.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-mistune-0.8.4-1-any.pkg.tar.xz"; sha256 = "0ecbf0007ddccc94124366adb5915fead65d712f08c5a7ae4bf25fce003daae1"; }];
    buildInputs = [  ];
  };

  "python-mock" = fetch {
    pname       = "python-mock";
    version     = "4.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-mock-4.0.1-1-any.pkg.tar.xz"; sha256 = "bb82c87ed8d0399907add3efedbd35e820039bfb8203f567308d6535c4c8521e"; }];
    buildInputs = [ python python-six python-pbr ];
  };

  "python-monotonic" = fetch {
    pname       = "python-monotonic";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-monotonic-1.5-1-any.pkg.tar.xz"; sha256 = "e2b2e3bdcafa509a1ea4f51a28187b8a5b2015bc406b55ebdd69edc33fa5d2f0"; }];
    buildInputs = [ python ];
  };

  "python-more-itertools" = fetch {
    pname       = "python-more-itertools";
    version     = "8.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-more-itertools-8.2.0-1-any.pkg.tar.xz"; sha256 = "952861e2545eb9aed4a4fcb338c8babc1643e6c0a6cd6470e2395b8f50f22f12"; }];
    buildInputs = [ python ];
  };

  "python-mox3" = fetch {
    pname       = "python-mox3";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-mox3-1.0.0-1-any.pkg.tar.xz"; sha256 = "ff8fa6e8029e0d5fec879b3cf1c40042b5038b26567f80528389c910537c3514"; }];
    buildInputs = [ python python-pbr python-fixtures ];
  };

  "python-mpmath" = fetch {
    pname       = "python-mpmath";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-mpmath-1.1.0-1-any.pkg.tar.xz"; sha256 = "1cb9bcaf1b42197592f34e4fea06c4bdac80e8701b5e44a82acbd171dd906697"; }];
    buildInputs = [ python python-gmpy2 ];
  };

  "python-msgpack" = fetch {
    pname       = "python-msgpack";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-msgpack-1.0.0-1-any.pkg.tar.xz"; sha256 = "2518915af8fea92af55d425c2aa54c77c92aea324d75824b8ccb7f5bb35752c0"; }];
    buildInputs = [ python ];
  };

  "python-multidict" = fetch {
    pname       = "python-multidict";
    version     = "4.7.6";
    srcs        = [{ filename = "mingw-w64-x86_64-python-multidict-4.7.6-1-any.pkg.tar.zst"; sha256 = "c1d7624fe1dde940d7821e528080aca45b967876d942ffa33d022ab4a4b314df"; }];
    buildInputs = [ python-numpy ];
  };

  "python-ndg-httpsclient" = fetch {
    pname       = "python-ndg-httpsclient";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ndg-httpsclient-0.5.1-1-any.pkg.tar.xz"; sha256 = "bd60fc6d15aeb161227e4d72349c897a0a31a0d8c7f13ecb75cc50eebc30e97d"; }];
    buildInputs = [ python-pyopenssl python-pyasn1 ];
  };

  "python-netaddr" = fetch {
    pname       = "python-netaddr";
    version     = "0.7.19";
    srcs        = [{ filename = "mingw-w64-x86_64-python-netaddr-0.7.19-1-any.pkg.tar.xz"; sha256 = "82a4e08789f134fe447c2c997fc8097a8fa9b9038e8a3b6ab2c7df4333e83d47"; }];
    buildInputs = [ python ];
  };

  "python-netifaces" = fetch {
    pname       = "python-netifaces";
    version     = "0.10.9";
    srcs        = [{ filename = "mingw-w64-x86_64-python-netifaces-0.10.9-1-any.pkg.tar.xz"; sha256 = "6920960ada63c060fd0e029704d6d43484506db7fc6bcd9b2e094f8f29b0478a"; }];
    buildInputs = [ python ];
  };

  "python-networkx" = fetch {
    pname       = "python-networkx";
    version     = "2.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-networkx-2.4-1-any.pkg.tar.xz"; sha256 = "42e6168d79aea27b056604c016506d9d08614df655dc55908e8f6e73bc999243"; }];
    buildInputs = [ python python-decorator ];
  };

  "python-nose" = fetch {
    pname       = "python-nose";
    version     = "1.3.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-nose-1.3.7-1-any.pkg.tar.xz"; sha256 = "98abc9392b366d5d45382672c79576d972d1a2d1f7b5b65b780f58abf737b57d"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-nuitka" = fetch {
    pname       = "python-nuitka";
    version     = "0.6.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-nuitka-0.6.7-1-any.pkg.tar.xz"; sha256 = "b1aa9d83cf2d8ac6af0b231a63e370b8fe7143af0008d1791c1afbba7d0efb64"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-numba" = fetch {
    pname       = "python-numba";
    version     = "0.51.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-numba-0.51.2-1-any.pkg.tar.zst"; sha256 = "abc0b13f999195123f4468e7fe52eaaade2580014aaf1a95d3b1f0aa730ca810"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python-llvmlite.version "0.34.0"; python-llvmlite) (assert stdenvNoCC.lib.versionAtLeast python-numpy.version "1.15"; python-numpy) ];
  };

  "python-numexpr" = fetch {
    pname       = "python-numexpr";
    version     = "2.7.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-numexpr-2.7.1-1-any.pkg.tar.xz"; sha256 = "14abf1fbe05a307b406ab644dbd29cacda19e394fe05e63a8da840c1c1cad005"; }];
    buildInputs = [ python-numpy ];
  };

  "python-numpy" = fetch {
    pname       = "python-numpy";
    version     = "1.19.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-numpy-1.19.2-1-any.pkg.tar.zst"; sha256 = "af3ee4a7eb5d6eb113fc6cce53044c7d866589468c4c23a0993342cb68d03d12"; }];
    buildInputs = [ openblas python ];
  };

  "python-nvidia-ml" = fetch {
    pname       = "python-nvidia-ml";
    version     = "7.352.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-nvidia-ml-7.352.0-1-any.pkg.tar.xz"; sha256 = "259189709048b886857476bc2827f69f645926b9ba59d9cd63510c2a2550f779"; }];
    buildInputs = [ python ];
  };

  "python-oauth2client" = fetch {
    pname       = "python-oauth2client";
    version     = "4.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oauth2client-4.1.3-1-any.pkg.tar.zst"; sha256 = "bfe952b2c3e3c836560e68ba05e1a65acd6b68cceb6e4da4d26db8086cb64788"; }];
    buildInputs = [ python-httplib2 python-pyasn1 python-pyasn1-modules python-rsa python-six ];
  };

  "python-olefile" = fetch {
    pname       = "python-olefile";
    version     = "0.46";
    srcs        = [{ filename = "mingw-w64-x86_64-python-olefile-0.46-1-any.pkg.tar.xz"; sha256 = "08a955a1785b35eb19a0764a2cddd625d238db922a8b7a65af8609dc06b66e6a"; }];
    buildInputs = [ python ];
  };

  "python-openmdao" = fetch {
    pname       = "python-openmdao";
    version     = "3.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-openmdao-3.0.0-1-any.pkg.tar.xz"; sha256 = "0a648514230e9f631e499c7eb4fcc412029365465bceca6ce6d47b71fc0d2543"; }];
    buildInputs = [ python-numpy python-scipy python-networkx python-sqlitedict python-pyparsing python-six ];
  };

  "python-openpyxl" = fetch {
    pname       = "python-openpyxl";
    version     = "3.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-openpyxl-3.0.3-1-any.pkg.tar.xz"; sha256 = "b132157e5fa487b6dc0546741f0d0321cf085730ca31a81191ba613afb5bb719"; }];
    buildInputs = [ python-jdcal python-et-xmlfile python-defusedxml python-pandas python-pillow ];
  };

  "python-opt_einsum" = fetch {
    pname       = "python-opt_einsum";
    version     = "3.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-opt_einsum-3.3.0-1-any.pkg.tar.zst"; sha256 = "b4d6b3b6ac2153744ffd4c0b5e1ce9c76045da7db45a67ad4205875046863396"; }];
    buildInputs = [ python ];
  };

  "python-ordered-set" = fetch {
    pname       = "python-ordered-set";
    version     = "3.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ordered-set-3.1.1-1-any.pkg.tar.xz"; sha256 = "9c7e70fd5b4a8f5b9e44ee999e5a0b4e3ef048f67206d2e9ff3d460b6a60eae4"; }];
    buildInputs = [ python ];
  };

  "python-oslo-concurrency" = fetch {
    pname       = "python-oslo-concurrency";
    version     = "4.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oslo-concurrency-4.0.2-1-any.pkg.tar.zst"; sha256 = "6204a9925100f260a286680f6a7344187440bdf357ccb030f675a679f1568897"; }];
    buildInputs = [ python python-six python-pbr python-oslo-config python-oslo-i18n python-oslo-utils python-fasteners ];
  };

  "python-oslo-config" = fetch {
    pname       = "python-oslo-config";
    version     = "8.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oslo-config-8.0.2-1-any.pkg.tar.zst"; sha256 = "106e3ec5ff0e5ff3b23483646d9a09cce09722052e5fb25a1af30b4ae9223ba4"; }];
    buildInputs = [ python python-six python-netaddr python-stevedore python-debtcollector python-oslo-i18n python-rfc3986 python-yaml ];
  };

  "python-oslo-context" = fetch {
    pname       = "python-oslo-context";
    version     = "3.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oslo-context-3.0.2-1-any.pkg.tar.zst"; sha256 = "c27d1ae49a6717693d41408af20ed1392c8a8ab0302815bb995b5ea92fa85213"; }];
    buildInputs = [ python python-pbr python-debtcollector ];
  };

  "python-oslo-db" = fetch {
    pname       = "python-oslo-db";
    version     = "8.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oslo-db-8.1.0-1-any.pkg.tar.zst"; sha256 = "3ea17c9099c346cba5b33d458bef81f735a64a3e75b271ad024df2adbce3da56"; }];
    buildInputs = [ python python-six python-pbr python-alembic python-debtcollector python-oslo-i18n python-oslo-config python-oslo-utils python-sqlalchemy python-sqlalchemy-migrate python-stevedore ];
  };

  "python-oslo-i18n" = fetch {
    pname       = "python-oslo-i18n";
    version     = "4.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oslo-i18n-4.0.1-1-any.pkg.tar.zst"; sha256 = "78f8f6d94bea2336469f8c873ae06e06d2ae85c64e8c9d8c3a416d932b3ae9fe"; }];
    buildInputs = [ python python-six python-pbr python-babel ];
  };

  "python-oslo-log" = fetch {
    pname       = "python-oslo-log";
    version     = "4.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oslo-log-4.1.1-1-any.pkg.tar.zst"; sha256 = "d5affd395538d3f50446d50cdec271f68cfcd2f11cf1d2a685bf6f5f9a1671d0"; }];
    buildInputs = [ python python-six python-pbr python-oslo-config python-oslo-context python-oslo-i18n python-oslo-utils python-oslo-serialization python-debtcollector python-dateutil python-monotonic ];
  };

  "python-oslo-serialization" = fetch {
    pname       = "python-oslo-serialization";
    version     = "3.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oslo-serialization-3.1.1-1-any.pkg.tar.zst"; sha256 = "4a573cf654c91c91beb7fc5832e28a8c192287733c00f9832902a9e36280add8"; }];
    buildInputs = [ python python-six python-pbr python-babel python-msgpack python-oslo-utils python-pytz ];
  };

  "python-oslo-utils" = fetch {
    pname       = "python-oslo-utils";
    version     = "4.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oslo-utils-4.1.1-1-any.pkg.tar.zst"; sha256 = "34f9f5f50626f6d6ca7ee0fb9a44a5b73087ce1da4e9a8785e1af9d1c61e6e47"; }];
    buildInputs = [ python ];
  };

  "python-oslosphinx" = fetch {
    pname       = "python-oslosphinx";
    version     = "4.18.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oslosphinx-4.18.0-1-any.pkg.tar.xz"; sha256 = "0e84ea4a5013222411f0c2aa3bc770e5c55d3bf6e1d5df981ac7f33a960cb853"; }];
    buildInputs = [ python python-six python-requests ];
  };

  "python-oslotest" = fetch {
    pname       = "python-oslotest";
    version     = "4.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-oslotest-4.2.0-1-any.pkg.tar.xz"; sha256 = "4ef8d43c4bb1b00952c2130d4ab2684735d71b9079d3fd7d37a4ae399a89219a"; }];
    buildInputs = [ python ];
  };

  "python-packaging" = fetch {
    pname       = "python-packaging";
    version     = "20.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-packaging-20.3-1-any.pkg.tar.xz"; sha256 = "3e73bb2c3e7800c229c10649f71374d6c5194bc34ff5e10fc92bc85f7d00ca31"; }];
    buildInputs = [ python python-pyparsing python-six python-attrs ];
  };

  "python-pandas" = fetch {
    pname       = "python-pandas";
    version     = "1.0.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pandas-1.0.5-1-any.pkg.tar.zst"; sha256 = "2056eaac49ffcacb429139fd1e94e24b0d56d2b8317b93b9a047ee916865eb8a"; }];
    buildInputs = [ python-numpy python-pytz python-dateutil ];
  };

  "python-pandocfilters" = fetch {
    pname       = "python-pandocfilters";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pandocfilters-1.4.2-1-any.pkg.tar.xz"; sha256 = "72e14b4a5482ffa99093a3bb79c8b86f91b27d455574fbda71176805dd763ec5"; }];
    buildInputs = [ python ];
  };

  "python-parameterized" = fetch {
    pname       = "python-parameterized";
    version     = "0.7.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-parameterized-0.7.4-1-any.pkg.tar.zst"; sha256 = "53b57494feb7d113d86bab26bc70eb400cb90d3e40ef939713783c47f2406693"; }];
    buildInputs = [ python ];
  };

  "python-paramiko" = fetch {
    pname       = "python-paramiko";
    version     = "2.7.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-paramiko-2.7.1-1-any.pkg.tar.xz"; sha256 = "86f02588233b6a95d42e67a73678f3b2f982bf07e4fea5e765fd6d7990d88b7f"; }];
    buildInputs = [ python ];
  };

  "python-parso" = fetch {
    pname       = "python-parso";
    version     = "0.6.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-parso-0.6.2-1-any.pkg.tar.xz"; sha256 = "58f33ccd257e9df8324932c16e64aa5c42f0430659d25cb238a110d49edfbb3a"; }];
    buildInputs = [ python ];
  };

  "python-path" = fetch {
    pname       = "python-path";
    version     = "13.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-path-13.2.0-1-any.pkg.tar.xz"; sha256 = "02c80285bccabcc9205228563c0fcd08875db34e58126e7a71cde1f46e42c8f1"; }];
    buildInputs = [ python python-importlib-metadata ];
  };

  "python-pathlib2" = fetch {
    pname       = "python-pathlib2";
    version     = "2.3.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pathlib2-2.3.5-1-any.pkg.tar.xz"; sha256 = "28a5894ba888d40b7002c2b6b1cf3b5ee2beb6d6f27e2ca8de6c5af43e3ac289"; }];
    buildInputs = [ python python-scandir ];
  };

  "python-pathtools" = fetch {
    pname       = "python-pathtools";
    version     = "0.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pathtools-0.1.2-1-any.pkg.tar.xz"; sha256 = "dc701a19022b3cb6cb378a1b62f0750610c015d1adcfe176554b85d452ebdb81"; }];
    buildInputs = [ python ];
  };

  "python-patsy" = fetch {
    pname       = "python-patsy";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-patsy-0.5.1-1-any.pkg.tar.xz"; sha256 = "dfc0adcabb2e5215f70bb827522ed4b6be60ac7f02d8ed4e3ef78538ccd0e569"; }];
    buildInputs = [ python-numpy ];
  };

  "python-pbr" = fetch {
    pname       = "python-pbr";
    version     = "5.4.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pbr-5.4.4-1-any.pkg.tar.xz"; sha256 = "7b6a74ec813f1cbb29ab930890d1e00d1d0ae350b95a99162cdf616fe97b3e01"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-pdfrw" = fetch {
    pname       = "python-pdfrw";
    version     = "0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pdfrw-0.4-1-any.pkg.tar.xz"; sha256 = "e6e00365748a09715fd61ce7fcaa2eb7cc1de28a0f2d7190ba0243bb3cdcba80"; }];
    buildInputs = [ python ];
  };

  "python-pep517" = fetch {
    pname       = "python-pep517";
    version     = "0.8.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pep517-0.8.2-1-any.pkg.tar.zst"; sha256 = "0f7655bcad5966a672a07bf4a86a1601199e0557c83e063f016774b91e93d3c5"; }];
    buildInputs = [ python ];
  };

  "python-pexpect" = fetch {
    pname       = "python-pexpect";
    version     = "4.8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pexpect-4.8.0-1-any.pkg.tar.xz"; sha256 = "2452c0931f0ffc51832c369f43c89b7b2ed16ae9e2fc3267bf3d44527e8d2cb0"; }];
    buildInputs = [ python python-ptyprocess ];
  };

  "python-pgen2" = fetch {
    pname       = "python-pgen2";
    version     = "0.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pgen2-0.1.0-1-any.pkg.tar.xz"; sha256 = "1c1d85fe050d26724aaa273593700aa05cac3dbd418b7673dec80e64d38d4952"; }];
    buildInputs = [ python ];
  };

  "python-pickleshare" = fetch {
    pname       = "python-pickleshare";
    version     = "0.7.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pickleshare-0.7.5-1-any.pkg.tar.xz"; sha256 = "9f534120afd746cf310da30f81cee3f345168b5699bbf5fccdfcd0035264815e"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python-path.version "8.1"; python-path) ];
  };

  "python-pillow" = fetch {
    pname       = "python-pillow";
    version     = "6.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pillow-6.2.1-2-any.pkg.tar.xz"; sha256 = "6264cd514e8e07d366b9640a7788216011c0b23d85c377cc6f8ed0c8f0a354af"; }];
    buildInputs = [ freetype lcms2 libjpeg libtiff libwebp libimagequant openjpeg2 python python-olefile zlib ];
  };

  "python-pip" = fetch {
    pname       = "python-pip";
    version     = "20.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pip-20.0.2-1-any.pkg.tar.xz"; sha256 = "c314c4b0c2d0fcd4abd113fac65e9fcf2b7141a480a0a61b9defcfd45a8a0740"; }];
    buildInputs = [ python-appdirs python-cachecontrol python-colorama python-contextlib2 python-distlib python-html5lib python-lockfile python-msgpack python-packaging python-pep517 python-progress python-pyparsing python-pytoml python-requests python-retrying python-six python-webencodings ];
  };

  "python-pkgconfig" = fetch {
    pname       = "python-pkgconfig";
    version     = "1.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pkgconfig-1.5.1-1-any.pkg.tar.xz"; sha256 = "bf493d6b55d4017cc12225dfbbfeaf49c269c2316fe35cf3f5e31bfef4fec2c3"; }];
    buildInputs = [ python ];
  };

  "python-pkginfo" = fetch {
    pname       = "python-pkginfo";
    version     = "1.5.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pkginfo-1.5.0.1-1-any.pkg.tar.xz"; sha256 = "7884a5258d21173a4bfaadd809f20373d430e303880409c64b18c6129031f35d"; }];
    buildInputs = [ python ];
  };

  "python-pluggy" = fetch {
    pname       = "python-pluggy";
    version     = "0.13.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pluggy-0.13.1-1-any.pkg.tar.xz"; sha256 = "1fba22b1b27b7048f8db6754029cf7db114a0adedbdf931836422edcd77df005"; }];
    buildInputs = [ python ];
  };

  "python-ply" = fetch {
    pname       = "python-ply";
    version     = "3.11";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ply-3.11-1-any.pkg.tar.xz"; sha256 = "05b1f25378d8138c06f65052bfbfd08408229a04e44c466090cbf9aa5413c7aa"; }];
    buildInputs = [ python ];
  };

  "python-pptx" = fetch {
    pname       = "python-pptx";
    version     = "0.6.18";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pptx-0.6.18-1-any.pkg.tar.xz"; sha256 = "ddba80680514d6b8d12df61b21f8dd738664af3e66f9dd66c80834774d1dc888"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python-lxml.version "3.1.0"; python-lxml) (assert stdenvNoCC.lib.versionAtLeast python-pillow.version "2.6.1"; python-pillow) (assert stdenvNoCC.lib.versionAtLeast python-xlsxwriter.version "0.5.7"; python-xlsxwriter) ];
  };

  "python-pretend" = fetch {
    pname       = "python-pretend";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pretend-1.0.9-1-any.pkg.tar.xz"; sha256 = "333e72acafabf17975d6cb19d526b805f5929f5428bf9e1ea4fb3b30d9a1d3ae"; }];
    buildInputs = [ python ];
  };

  "python-prettytable" = fetch {
    pname       = "python-prettytable";
    version     = "0.7.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-prettytable-0.7.2-1-any.pkg.tar.xz"; sha256 = "d13bf3a065cc0629ed294e5b3de87e9ae15e324d0303f61dda4e7fde89e0c015"; }];
    buildInputs = [ python ];
  };

  "python-profanityfilter" = fetch {
    pname       = "python-profanityfilter";
    version     = "2.0.6";
    srcs        = [{ filename = "mingw-w64-x86_64-python-profanityfilter-2.0.6-1-any.pkg.tar.zst"; sha256 = "c19c896b7d4e1c89d2bc27893ae21e4f93b7bb16d7dd7d011ce452df70bb9a49"; }];
    buildInputs = [ python ];
  };

  "python-progress" = fetch {
    pname       = "python-progress";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-progress-1.5-1-any.pkg.tar.xz"; sha256 = "72d46dba330bf18258ac5c8e798bcef40ebd8c276f7bcdc144fffedd022f325d"; }];
    buildInputs = [ python ];
  };

  "python-prometheus-client" = fetch {
    pname       = "python-prometheus-client";
    version     = "0.7.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-prometheus-client-0.7.1-1-any.pkg.tar.xz"; sha256 = "2574c566e1225851768e8d62fdda22e9e9da5d8bd99b0fa96277c2079af36a88"; }];
    buildInputs = [ python ];
  };

  "python-prompt_toolkit" = fetch {
    pname       = "python-prompt_toolkit";
    version     = "3.0.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-prompt_toolkit-3.0.5-1-any.pkg.tar.zst"; sha256 = "570c8e87808bd9a02037cb6401f11e1e73db39ed444b77e33647efcc52d33335"; }];
    buildInputs = [ python-pygments python-six python-wcwidth ];
  };

  "python-protobuf" = fetch {
    pname       = "python-protobuf";
    version     = "3.11.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-protobuf-3.11.4-1-any.pkg.tar.xz"; sha256 = "09f867e2d1e7920d043548435c9c0e0166f8ae234065da72f6c840f04b47eb65"; }];
    buildInputs = [ python python-six python-setuptools ];
  };

  "python-psutil" = fetch {
    pname       = "python-psutil";
    version     = "5.6.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-psutil-5.6.7-1-any.pkg.tar.xz"; sha256 = "7ed57ace7c4e58b6cdd8e6ed3527e06f8500d487ba837ba4c82bb8fd895170b7"; }];
    buildInputs = [ python ];
  };

  "python-psycopg2" = fetch {
    pname       = "python-psycopg2";
    version     = "2.8.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-psycopg2-2.8.5-1-any.pkg.tar.xz"; sha256 = "21b58179c873f55e17608c47c1e9917fc5882b260de0860d8bc22af231a596d8"; }];
    buildInputs = [ python (assert stdenvNoCC.lib.versionAtLeast postgresql.version "8.4.1"; postgresql) ];
  };

  "python-ptyprocess" = fetch {
    pname       = "python-ptyprocess";
    version     = "0.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ptyprocess-0.6.0-1-any.pkg.tar.xz"; sha256 = "d7f62b2a2e1dc9ea334b0d2df59ca62ceb432caab92e40a59c56d1c01cdb558c"; }];
    buildInputs = [ python ];
  };

  "python-py" = fetch {
    pname       = "python-py";
    version     = "1.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-py-1.8.1-1-any.pkg.tar.xz"; sha256 = "7bf3452e7e6d7e1067472e30246da932d4e8341f5a2526a2136613a630d4bb3f"; }];
    buildInputs = [ python python-iniconfig python-apipkg ];
  };

  "python-py-cpuinfo" = fetch {
    pname       = "python-py-cpuinfo";
    version     = "5.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-py-cpuinfo-5.0.0-1-any.pkg.tar.xz"; sha256 = "fff9f423e728bcf4ec05f66a9251ec477d951edf52c437df8fd294a2664832a0"; }];
    buildInputs = [ python ];
  };

  "python-pyamg" = fetch {
    pname       = "python-pyamg";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyamg-4.0.0-1-any.pkg.tar.xz"; sha256 = "cd1c56f6d92c38a7d09cd74ac28b07753c698b7b7daedb4ba7de2eaa2bf0700d"; }];
    buildInputs = [ python python-scipy python-numpy ];
  };

  "python-pyasn1" = fetch {
    pname       = "python-pyasn1";
    version     = "0.4.8";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyasn1-0.4.8-1-any.pkg.tar.xz"; sha256 = "ca4be083736c6692a2ed2b9c223b80ac1c9ba221eb0e0a57de3bbae7d07fc20b"; }];
    buildInputs = [ python ];
  };

  "python-pyasn1-modules" = fetch {
    pname       = "python-pyasn1-modules";
    version     = "0.2.8";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyasn1-modules-0.2.8-1-any.pkg.tar.xz"; sha256 = "7fe97a52c82fd01479076473cea86a9b0a9bcc9f49f0e4ec3c11aff3a6802458"; }];
    buildInputs = [ python-pyasn1 ];
  };

  "python-pycodestyle" = fetch {
    pname       = "python-pycodestyle";
    version     = "2.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pycodestyle-2.5.0-1-any.pkg.tar.xz"; sha256 = "fa35ea3eddaadea7b9a5f9dea22026111f0c1ecf750698909c7f01a130f8ace7"; }];
    buildInputs = [ python ];
  };

  "python-pycparser" = fetch {
    pname       = "python-pycparser";
    version     = "2.20";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pycparser-2.20-1-any.pkg.tar.xz"; sha256 = "1a7ca9104285ab8bdcfd39ca220cc390839a9ef02cf289369ea7a89c89b57e7f"; }];
    buildInputs = [ python python-ply ];
  };

  "python-pyfilesystem2" = fetch {
    pname       = "python-pyfilesystem2";
    version     = "2.4.11";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyfilesystem2-2.4.11-1-any.pkg.tar.xz"; sha256 = "ad57585c78b1df90e81c767b764903c72f9db3a1046418c5cd7787131eff2d61"; }];
    buildInputs = [ python python-appdirs python-pytz python-six ];
  };

  "python-pyflakes" = fetch {
    pname       = "python-pyflakes";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyflakes-2.2.0-1-any.pkg.tar.zst"; sha256 = "37080b23bad2bdce35eb9690962a7f7aed8fb0b5e03fe91e8d35c0799152f049"; }];
    buildInputs = [ python ];
  };

  "python-pyglet" = fetch {
    pname       = "python-pyglet";
    version     = "1.5.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyglet-1.5.4-1-any.pkg.tar.zst"; sha256 = "738d162f589e8992809411af9438c287d6e803c07954d271591413d9e9f79213"; }];
    buildInputs = [ python python-future ];
  };

  "python-pygments" = fetch {
    pname       = "python-pygments";
    version     = "2.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pygments-2.6.1-1-any.pkg.tar.xz"; sha256 = "16acb174088e92f433878d27ecfdc5186458af7248992ea84b81ce64b4a96b20"; }];
    buildInputs = [  ];
  };

  "python-pylint" = fetch {
    pname       = "python-pylint";
    version     = "2.5.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pylint-2.5.2-1-any.pkg.tar.zst"; sha256 = "e40ec7d0a1e609864cec6d91bc03092ea37d098092ead52e05f8dd36ec41b11d"; }];
    buildInputs = [ python-astroid python-colorama python-mccabe python-isort ];
  };

  "python-pynacl" = fetch {
    pname       = "python-pynacl";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pynacl-1.3.0-1-any.pkg.tar.xz"; sha256 = "49bc48a89fd055e567c1a6002f2811738e9a6090e305cf3ef08843cd4ac49238"; }];
    buildInputs = [ python ];
  };

  "python-pyopengl" = fetch {
    pname       = "python-pyopengl";
    version     = "3.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyopengl-3.1.5-1-any.pkg.tar.xz"; sha256 = "00ed66a7e2df4818174669e2941fd8706751d13366a49064713c54a463fcd27c"; }];
    buildInputs = [ python ];
  };

  "python-pyopenssl" = fetch {
    pname       = "python-pyopenssl";
    version     = "19.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyopenssl-19.1.0-1-any.pkg.tar.xz"; sha256 = "b5a6d8460ceea24b4bf1d2e91571f7a735d11d2f2ad57f99066a338d7949a74e"; }];
    buildInputs = [ openssl python-cryptography python-six ];
  };

  "python-pyparsing" = fetch {
    pname       = "python-pyparsing";
    version     = "2.4.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyparsing-2.4.7-1-any.pkg.tar.zst"; sha256 = "ad00d7337e35677e0f229bb836f129105ddce9fd037bf3b0819488df50015324"; }];
    buildInputs = [ python ];
  };

  "python-pyperclip" = fetch {
    pname       = "python-pyperclip";
    version     = "1.8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyperclip-1.8.0-1-any.pkg.tar.zst"; sha256 = "00841567b93bb0e7a2307e8aae6c4e5b0e9767ea45dff8b7f4e6bac171c1fb86"; }];
    buildInputs = [ python ];
  };

  "python-pyqt5" = fetch {
    pname       = "python-pyqt5";
    version     = "5.15.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyqt5-5.15.0-2-any.pkg.tar.zst"; sha256 = "71230e60bb69026c39bf69ecfcf034b1dbe5d9793cd4a96d79f9f78944034ae4"; }];
    buildInputs = [ python-pyopengl python pyqt5-sip qt5 qtwebkit ];
  };

  "python-pyreadline" = fetch {
    pname       = "python-pyreadline";
    version     = "2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyreadline-2.1-1-any.pkg.tar.xz"; sha256 = "ff8c4d3e412d0adc9ec8e84817c574197c29ec5f81d7873938f45474aca2622c"; }];
    buildInputs = [ python ];
  };

  "python-pyrsistent" = fetch {
    pname       = "python-pyrsistent";
    version     = "0.16.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyrsistent-0.16.0-1-any.pkg.tar.xz"; sha256 = "ab4b3ea7b36e3df74f0edfd1c7e05e027c1d09806b6d0746063665a40730fc7b"; }];
    buildInputs = [ python python-six ];
  };

  "python-pyserial" = fetch {
    pname       = "python-pyserial";
    version     = "3.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyserial-3.4-3-any.pkg.tar.xz"; sha256 = "c390a39b4641aeea20266e5dca257aeb3232a1344b78ac41f157e6e8c082a9b5"; }];
    buildInputs = [ python ];
  };

  "python-pysocks" = fetch {
    pname       = "python-pysocks";
    version     = "1.7.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pysocks-1.7.0-1-any.pkg.tar.xz"; sha256 = "145f68c68c6c6160fdd3bb833ad809f2cabc534069efa9098a5266356357bdcf"; }];
    buildInputs = [ python python-win_inet_pton ];
  };

  "python-pystemmer" = fetch {
    pname       = "python-pystemmer";
    version     = "2.0.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pystemmer-2.0.0.1-1-any.pkg.tar.xz"; sha256 = "541ab08c34c3afbf425618e0617140d86d9d699ecc15816d1e7df70a248da9be"; }];
    buildInputs = [ python ];
  };

  "python-pytest" = fetch {
    pname       = "python-pytest";
    version     = "5.4.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytest-5.4.1-1-any.pkg.tar.xz"; sha256 = "66ab563c3d05e016da0c1553c9de40ac4dff881fbabf2c0ff7f0d5b155cc45b4"; }];
    buildInputs = [ python (assert stdenvNoCC.lib.versionAtLeast python-atomicwrites.version "1.0"; python-atomicwrites) (assert stdenvNoCC.lib.versionAtLeast python-attrs.version "17.4.0"; python-attrs) (assert stdenvNoCC.lib.versionAtLeast python-more-itertools.version "4.0.0"; python-more-itertools) (assert stdenvNoCC.lib.versionAtLeast python-pluggy.version "0.7"; python-pluggy) (assert stdenvNoCC.lib.versionAtLeast python-py.version "1.5.0"; python-py) python-setuptools python-six python-colorama python-wcwidth ];
  };

  "python-pytest-benchmark" = fetch {
    pname       = "python-pytest-benchmark";
    version     = "3.2.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytest-benchmark-3.2.3-1-any.pkg.tar.xz"; sha256 = "6e75b37e53cf926cccb6bf7630bbb7a8710a7fa89c2b053037d2cf2fb8f100cf"; }];
    buildInputs = [ python python-py-cpuinfo python-pytest ];
  };

  "python-pytest-cov" = fetch {
    pname       = "python-pytest-cov";
    version     = "2.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytest-cov-2.8.1-1-any.pkg.tar.xz"; sha256 = "cbc73186cfcd5ca9489e652784c2f87a741a7cf98f3b8f1e6210a3f003476391"; }];
    buildInputs = [ python python-coverage python-pytest ];
  };

  "python-pytest-expect" = fetch {
    pname       = "python-pytest-expect";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytest-expect-1.1.0-1-any.pkg.tar.xz"; sha256 = "784b0dec3f16c6e96bc477fa7260721701a7949b30307669f2de623bbbfa569a"; }];
    buildInputs = [ python python-pytest python-u-msgpack ];
  };

  "python-pytest-forked" = fetch {
    pname       = "python-pytest-forked";
    version     = "1.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytest-forked-1.1.3-1-any.pkg.tar.xz"; sha256 = "a5bc9a5f02d2dccead54fa3b38fbaa86d7a844fb0ddc05c1f09bbd10d516cb77"; }];
    buildInputs = [ python python-pytest ];
  };

  "python-pytest-localserver" = fetch {
    pname       = "python-pytest-localserver";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytest-localserver-0.5.0-1-any.pkg.tar.zst"; sha256 = "5c2824d5c7e68c37b0528f52f03d1b3c3aa173389fdaf63278d716a404a6816a"; }];
    buildInputs = [ python-pytest python-werkzeug ];
  };

  "python-pytest-mock" = fetch {
    pname       = "python-pytest-mock";
    version     = "3.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytest-mock-3.3.1-1-any.pkg.tar.zst"; sha256 = "a78808262882286ef54ecf9f105706525eba87e14932a56a217f8de029395fa7"; }];
    buildInputs = [ python-pytest ];
  };

  "python-pytest-runner" = fetch {
    pname       = "python-pytest-runner";
    version     = "5.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytest-runner-5.2-1-any.pkg.tar.xz"; sha256 = "534e1a6599304918f0745b9e6c29ca8eeb6eb2aefa1a576f5aa838bb9c2b7d9f"; }];
    buildInputs = [ python python-pytest ];
  };

  "python-pytest-timeout" = fetch {
    pname       = "python-pytest-timeout";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytest-timeout-1.4.2-1-any.pkg.tar.zst"; sha256 = "f645e9ba88599bf70e5260b46a4b49d01dd1d6fe034fd8dcc84b732902c5d01c"; }];
    buildInputs = [ python-pytest ];
  };

  "python-pytest-xdist" = fetch {
    pname       = "python-pytest-xdist";
    version     = "1.31.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytest-xdist-1.31.0-1-any.pkg.tar.xz"; sha256 = "0d07f2316948caf1a272701b7c0b5cb3fa140cd4fc5f64a27ba03c2e4ee00071"; }];
    buildInputs = [ python python-pytest-forked python-execnet ];
  };

  "python-python_ics" = fetch {
    pname       = "python-python_ics";
    version     = "4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-python_ics-4.3-2-any.pkg.tar.zst"; sha256 = "7ff4c49c10821ce3c3e6203e8c37628b682142723fec4b1669dfa9a0996a6030"; }];
    buildInputs = [ python ];
  };

  "python-pytoml" = fetch {
    pname       = "python-pytoml";
    version     = "0.1.21";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytoml-0.1.21-1-any.pkg.tar.xz"; sha256 = "eaa772f1a6ee0d86c65736a3d8dd21fdc6b87b1290e09616ac464c3b2bcd4c2e"; }];
    buildInputs = [ python ];
  };

  "python-pytz" = fetch {
    pname       = "python-pytz";
    version     = "2019.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pytz-2019.3-1-any.pkg.tar.xz"; sha256 = "977a0c4e1ff6e2ebcc3ecd34527ddba36722b74e30d4c45f47fab870791bc72e"; }];
    buildInputs = [ python ];
  };

  "python-pyu2f" = fetch {
    pname       = "python-pyu2f";
    version     = "0.1.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyu2f-0.1.4-1-any.pkg.tar.xz"; sha256 = "12d6a21d682527eae816cd44a7aaa2f2166c774c224ce7fe4e06ba55daccb7f2"; }];
    buildInputs = [ python ];
  };

  "python-pywavelets" = fetch {
    pname       = "python-pywavelets";
    version     = "1.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pywavelets-1.1.1-1-any.pkg.tar.xz"; sha256 = "5fd7dbe747a02c85c6f8bb86970998d987ceebc2deac37aa6d8555267948aa2a"; }];
    buildInputs = [ python-numpy python ];
  };

  "python-pyzmq" = fetch {
    pname       = "python-pyzmq";
    version     = "19.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyzmq-19.0.2-1-any.pkg.tar.zst"; sha256 = "519dec77d5f19b714d1394b633094227b8c20a2c6d5d1e24f87cb4817a6a061c"; }];
    buildInputs = [ python zeromq ];
  };

  "python-pyzopfli" = fetch {
    pname       = "python-pyzopfli";
    version     = "0.1.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-pyzopfli-0.1.7-1-any.pkg.tar.xz"; sha256 = "87d2d7177a23c02f8eaedb53202c1e86dc7f890a24fe0e47b1ab780afad73a3b"; }];
    buildInputs = [ python ];
  };

  "python-qscintilla" = fetch {
    pname       = "python-qscintilla";
    version     = "2.11.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-qscintilla-2.11.5-1-any.pkg.tar.zst"; sha256 = "3c6b2e68c2fda7af5898163b87c1945dcc7d80ecd609dcf3e2d3e597cd6bce68"; }];
    buildInputs = [ qscintilla python-pyqt5 ];
  };

  "python-qtconsole" = fetch {
    pname       = "python-qtconsole";
    version     = "4.7.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-qtconsole-4.7.3-1-any.pkg.tar.zst"; sha256 = "3fb73458746fda3bb6b4bed43c0d5b24087cfb47cdae39d0d1f3beeb0e3600cd"; }];
    buildInputs = [ python python-jupyter_core python-jupyter_client python-pyqt5 ];
  };

  "python-qtpy" = fetch {
    pname       = "python-qtpy";
    version     = "1.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-qtpy-1.9.0-1-any.pkg.tar.zst"; sha256 = "79a781541b5d228a8a14eb10806ad37f9200aff6b2a818c1ca8a05e22e834212"; }];
    buildInputs = [ python ];
  };

  "python-regex" = fetch {
    pname       = "python-regex";
    version     = "2020.4.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-regex-2020.4.4-1-any.pkg.tar.zst"; sha256 = "1d9211cbeb29346ad3aba2b1929ee5a3e4671098b64e780652d665bbab4b4396"; }];
    buildInputs = [ python ];
  };

  "python-rencode" = fetch {
    pname       = "python-rencode";
    version     = "1.0.6";
    srcs        = [{ filename = "mingw-w64-x86_64-python-rencode-1.0.6-1-any.pkg.tar.xz"; sha256 = "3f41f6561b30bad39c8c3dad7dd5bb0c879e8bbb62b8627244ead666c7c6091f"; }];
    buildInputs = [ python ];
  };

  "python-reportlab" = fetch {
    pname       = "python-reportlab";
    version     = "3.5.42";
    srcs        = [{ filename = "mingw-w64-x86_64-python-reportlab-3.5.42-1-any.pkg.tar.xz"; sha256 = "351cf32ee2a22b016d9be6e5db0234022a0463da52468a403cac0fb49c64f6f0"; }];
    buildInputs = [ freetype python-pip python-pillow ];
  };

  "python-requests" = fetch {
    pname       = "python-requests";
    version     = "2.23.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-requests-2.23.0-1-any.pkg.tar.xz"; sha256 = "ee3d073ecef930846415d794f554697145657fa40bec46ee5219d5311035192d"; }];
    buildInputs = [ python-urllib3 python-chardet python-idna ];
  };

  "python-requests-kerberos" = fetch {
    pname       = "python-requests-kerberos";
    version     = "0.12.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-requests-kerberos-0.12.0-1-any.pkg.tar.xz"; sha256 = "08248d2d1d67ec63a964e9af2d987df883efc2dd8b640f09b8d5d149f52b4e3f"; }];
    buildInputs = [ python python-cryptography python-winkerberos ];
  };

  "python-resampy" = fetch {
    pname       = "python-resampy";
    version     = "0.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-resampy-0.2.2-1-any.pkg.tar.zst"; sha256 = "408f25cd2091a220c86553a6019066b308f637c5e6a867ccb024430e87afe7ae"; }];
    buildInputs = [ python-numba python-scipy python-six ];
  };

  "python-responses" = fetch {
    pname       = "python-responses";
    version     = "0.12.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-responses-0.12.0-1-any.pkg.tar.zst"; sha256 = "6a729ed3c6cbc5723e7e1f45dc4e64ef7a92864290965c536c55d4ab4ccd5ce3"; }];
    buildInputs = [ python-biscuits python-requests python-six ];
  };

  "python-retrying" = fetch {
    pname       = "python-retrying";
    version     = "1.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-retrying-1.3.3-1-any.pkg.tar.xz"; sha256 = "83e4089a4a5b32fdc82aa02bda85d0bdc7bf24d328f4b68a9eef821c2e158ce3"; }];
    buildInputs = [ python ];
  };

  "python-rfc3986" = fetch {
    pname       = "python-rfc3986";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-rfc3986-1.4.0-1-any.pkg.tar.zst"; sha256 = "370a21cac99baaf78eee0e73a1f781cc5f7c5b627a101b28f4e9dd0a4ad7836b"; }];
    buildInputs = [ python ];
  };

  "python-rfc3987" = fetch {
    pname       = "python-rfc3987";
    version     = "1.3.8";
    srcs        = [{ filename = "mingw-w64-x86_64-python-rfc3987-1.3.8-1-any.pkg.tar.xz"; sha256 = "25ee6e64d5e2c4fb7e66b658d6b6b4247121e53f9235955db3763814eeee480e"; }];
    buildInputs = [ python ];
  };

  "python-rsa" = fetch {
    pname       = "python-rsa";
    version     = "4.6";
    srcs        = [{ filename = "mingw-w64-x86_64-python-rsa-4.6-1-any.pkg.tar.zst"; sha256 = "d5e9b9d100e0121525febed307f9a5c4eae5618c00d6e28fb49f74bdb772d584"; }];
    buildInputs = [ python-pyasn1 ];
  };

  "python-rst2pdf" = fetch {
    pname       = "python-rst2pdf";
    version     = "0.96";
    srcs        = [{ filename = "mingw-w64-x86_64-python-rst2pdf-0.96-2-any.pkg.tar.xz"; sha256 = "7b8c191529becbc8b926eeff1a32d298dda95bcf1226cfc9261a5a014539668c"; }];
    buildInputs = [ python python-docutils python-jinja python-pdfrw python-pygments (assert stdenvNoCC.lib.versionAtLeast python-reportlab.version "2.4"; python-reportlab) python-setuptools python-six python-smartypants ];
  };

  "python-scandir" = fetch {
    pname       = "python-scandir";
    version     = "1.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-scandir-1.10.0-1-any.pkg.tar.xz"; sha256 = "304ee907c2386eb28ca2d47dfc28f55412a3405e53df73e7e3a72f38facb801c"; }];
    buildInputs = [ python ];
  };

  "python-scikit-image" = fetch {
    pname       = "python-scikit-image";
    version     = "0.17.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-scikit-image-0.17.2-1-any.pkg.tar.zst"; sha256 = "d55e6e703b4e93dd1a68728819a42bd0466025822c372e3d43c2afe53c901af0"; }];
    buildInputs = [ python-matplotlib python-scipy python-pywavelets python-numpy python-networkx python-imageio python-tifffile python-pillow ];
  };

  "python-scikit-learn" = fetch {
    pname       = "python-scikit-learn";
    version     = "0.22.2.post1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-scikit-learn-0.22.2.post1-1-any.pkg.tar.xz"; sha256 = "d0a409d71f45a2f9c78ca6d4e7eed14deebb1ee57dfaa0deab9ca8f02172c6a5"; }];
    buildInputs = [ python python-scipy python-joblib ];
  };

  "python-scipy" = fetch {
    pname       = "python-scipy";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-scipy-1.5.0-1-any.pkg.tar.zst"; sha256 = "374ba511959ab20eecece367e570a253116c91d9dc7becea8e675fad428cf169"; }];
    buildInputs = [ gcc-libgfortran openblas python-numpy ];
  };

  "python-seaborn" = fetch {
    pname       = "python-seaborn";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-seaborn-0.10.0-1-any.pkg.tar.xz"; sha256 = "904ac5e13b31b911c26d6c6be2c1e28df34250f63b3ba4f227ae1393a98962b5"; }];
    buildInputs = [ python python-pandas python-matplotlib ];
  };

  "python-send2trash" = fetch {
    pname       = "python-send2trash";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-send2trash-1.5.0-1-any.pkg.tar.xz"; sha256 = "87b50a09627776770eea3ec087f3f698f79f71b7a9d8906288a555b03260f771"; }];
    buildInputs = [ python ];
  };

  "python-setproctitle" = fetch {
    pname       = "python-setproctitle";
    version     = "1.1.10";
    srcs        = [{ filename = "mingw-w64-x86_64-python-setproctitle-1.1.10-1-any.pkg.tar.xz"; sha256 = "5deb21db1ebf53bc2b9a655d0612bd3be9dd4fcad9a8b3716f76422b5bf4ddb3"; }];
    buildInputs = [ python ];
  };

  "python-setuptools" = fetch {
    pname       = "python-setuptools";
    version     = "47.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-setuptools-47.1.1-1-any.pkg.tar.zst"; sha256 = "8b0cd957c6f43f3d2d8ddfbb395f07fb1d6b9d66ab6209d10ab6737f737d042c"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python.version "3.3"; python) python-packaging python-pyparsing python-ordered-set python-appdirs python-six ];
  };

  "python-setuptools-scm" = fetch {
    pname       = "python-setuptools-scm";
    version     = "4.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-setuptools-scm-4.1.2-1-any.pkg.tar.zst"; sha256 = "4c41cd8337dddef48b8af539b5194bf87f97a307ac088da40abfcd131d023d6c"; }];
    buildInputs = [ python python-setuptools ];
  };

  "python-simplegeneric" = fetch {
    pname       = "python-simplegeneric";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-simplegeneric-0.8.1-1-any.pkg.tar.xz"; sha256 = "7540c995946b261957ff18d14e63d3f1ef1871f02b19aa900b0ec6e549d40d52"; }];
    buildInputs = [ python ];
  };

  "python-sip" = fetch {
    pname       = "python-sip";
    version     = "4.19.22";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sip-4.19.22-1-any.pkg.tar.xz"; sha256 = "c65b2cbed5f5f9b0996f5fbac121a65d1667ec2db8431e09ddb29f99a3a53930"; }];
    buildInputs = [ sip python ];
  };

  "python-six" = fetch {
    pname       = "python-six";
    version     = "1.15.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-six-1.15.0-1-any.pkg.tar.zst"; sha256 = "28a5dca06d050ce985b715a9f7619146c552f075ed70850cd4f3557ec141b86f"; }];
    buildInputs = [ python ];
  };

  "python-smartypants" = fetch {
    pname       = "python-smartypants";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-smartypants-2.0.1-1-any.pkg.tar.xz"; sha256 = "acb301ddd10e4a111b34912a3789e16671e73b45bd7a0cac044899adc997509a"; }];
    buildInputs = [ python ];
  };

  "python-snowballstemmer" = fetch {
    pname       = "python-snowballstemmer";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-snowballstemmer-2.0.0-1-any.pkg.tar.xz"; sha256 = "4a6a17e177d8a59ac714a1465cf150b0b867480faff37e68b8d3a34f0acfd51d"; }];
    buildInputs = [ python ];
  };

  "python-sortedcontainers" = fetch {
    pname       = "python-sortedcontainers";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sortedcontainers-2.1.0-1-any.pkg.tar.xz"; sha256 = "8c1947cab75af81e540cd19aa6bda870027e3208455dc3ef27caee335e19797a"; }];
    buildInputs = [ python ];
  };

  "python-soundfile" = fetch {
    pname       = "python-soundfile";
    version     = "0.10.3.post1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-soundfile-0.10.3.post1-1-any.pkg.tar.zst"; sha256 = "7c44b13588bc505d337d006d4726e886fb2a7aee6b2aef9ce4af0f120b8f9164"; }];
    buildInputs = [ python-cffi python-numpy libsndfile ];
  };

  "python-soupsieve" = fetch {
    pname       = "python-soupsieve";
    version     = "1.9.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-soupsieve-1.9.5-1-any.pkg.tar.xz"; sha256 = "5cd836ca3e21dd0f6adff7e311a5fa754f892ad50804e4954f34aa0294d44350"; }];
    buildInputs = [ python ];
  };

  "python-sphinx" = fetch {
    pname       = "python-sphinx";
    version     = "3.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sphinx-3.0.2-1-any.pkg.tar.zst"; sha256 = "ad76f06cc067d57bdeb9b78bb0dd83c3b77a0ab8cc46d05f91b94e87d282d65c"; }];
    buildInputs = [ python-babel python-colorama python-docutils python-imagesize python-jinja python-pygments python-requests python-setuptools python-snowballstemmer python-sphinx-alabaster-theme python-sphinxcontrib-applehelp python-sphinxcontrib-devhelp python-sphinxcontrib-htmlhelp python-sphinxcontrib-jsmath python-sphinxcontrib-serializinghtml python-sphinxcontrib-qthelp ];
  };

  "python-sphinx-alabaster-theme" = fetch {
    pname       = "python-sphinx-alabaster-theme";
    version     = "0.7.12";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sphinx-alabaster-theme-0.7.12-1-any.pkg.tar.xz"; sha256 = "2e481ca2a67904886f3f8ed156475d752d53104702e773e24a81da89c2d8294f"; }];
    buildInputs = [ python ];
  };

  "python-sphinx_rtd_theme" = fetch {
    pname       = "python-sphinx_rtd_theme";
    version     = "0.4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sphinx_rtd_theme-0.4.3-1-any.pkg.tar.xz"; sha256 = "f31bfa64e5a712669f84b385b1c4d9bd6ac0c3ce7f5fe42b7e7bd74bc3dec978"; }];
    buildInputs = [ python ];
  };

  "python-sphinxcontrib-applehelp" = fetch {
    pname       = "python-sphinxcontrib-applehelp";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sphinxcontrib-applehelp-1.0.2-1-any.pkg.tar.xz"; sha256 = "64ef1a32d19fd609481cd872e5e41cfca8f7637f64de1b238a858a3e65e93a6a"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-devhelp" = fetch {
    pname       = "python-sphinxcontrib-devhelp";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sphinxcontrib-devhelp-1.0.2-1-any.pkg.tar.xz"; sha256 = "53acc81850e03d78410902ff29237baa4ddffb64e928a09d00075bc13400c340"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-htmlhelp" = fetch {
    pname       = "python-sphinxcontrib-htmlhelp";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sphinxcontrib-htmlhelp-1.0.3-1-any.pkg.tar.xz"; sha256 = "52a2a1094d2eb8739af28b567299b71419a71454c958a7ba1989af01e2822c51"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-jsmath" = fetch {
    pname       = "python-sphinxcontrib-jsmath";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sphinxcontrib-jsmath-1.0.1-1-any.pkg.tar.xz"; sha256 = "14aafc6a26796289479033a9a18cf13db27039c0a0eac50668698e65eab75f9d"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-qthelp" = fetch {
    pname       = "python-sphinxcontrib-qthelp";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sphinxcontrib-qthelp-1.0.3-1-any.pkg.tar.xz"; sha256 = "e17d4411f0ac67b2e6b320edb5e8d98c4c0fd86fc0723005620280fea54254a5"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-serializinghtml" = fetch {
    pname       = "python-sphinxcontrib-serializinghtml";
    version     = "1.1.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sphinxcontrib-serializinghtml-1.1.4-1-any.pkg.tar.xz"; sha256 = "3ddf734309007f01723e7d3b2970de753191396a30e66dad05b33ef8ba031e48"; }];
    buildInputs = [  ];
  };

  "python-sphinxcontrib-websupport" = fetch {
    pname       = "python-sphinxcontrib-websupport";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sphinxcontrib-websupport-1.1.2-1-any.pkg.tar.xz"; sha256 = "128e48649aafeed748ec84ae65eee5817cff51c2b2dfc2e8ca5ac722aaee1620"; }];
    buildInputs = [ python ];
  };

  "python-sqlalchemy" = fetch {
    pname       = "python-sqlalchemy";
    version     = "1.3.16";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sqlalchemy-1.3.16-1-any.pkg.tar.zst"; sha256 = "444c91ca89e1676ab644c4e9baf17cbb245000863cab6c1758f2009889aecc41"; }];
    buildInputs = [ python ];
  };

  "python-sqlalchemy-migrate" = fetch {
    pname       = "python-sqlalchemy-migrate";
    version     = "0.13.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sqlalchemy-migrate-0.13.0-1-any.pkg.tar.xz"; sha256 = "a550e2c51857ce9426bac738cb641b569ab64b14ee4df7bd2c0ea891d47d5828"; }];
    buildInputs = [ python python-six python-pbr python-sqlalchemy python-decorator python-sqlparse python-tempita ];
  };

  "python-sqlitedict" = fetch {
    pname       = "python-sqlitedict";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sqlitedict-1.6.0-1-any.pkg.tar.xz"; sha256 = "4d5372f94b0f3c8d7601d6d0424c6e6f008cea1698bde72e58216c2ff2dd8d10"; }];
    buildInputs = [ python sqlite3 ];
  };

  "python-sqlparse" = fetch {
    pname       = "python-sqlparse";
    version     = "0.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sqlparse-0.3.1-1-any.pkg.tar.xz"; sha256 = "962e2680ae8d061dd7ea6e6fe625c549955cc79bdd090eb5cee737f59d87aa84"; }];
    buildInputs = [ python ];
  };

  "python-statsmodels" = fetch {
    pname       = "python-statsmodels";
    version     = "0.11.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-statsmodels-0.11.1-1-any.pkg.tar.xz"; sha256 = "50a7747957cf67e77f05916203cd1f668bc995817c2e2dbcc0c61219baf61aee"; }];
    buildInputs = [ python-scipy python-pandas python-patsy ];
  };

  "python-stestr" = fetch {
    pname       = "python-stestr";
    version     = "3.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-stestr-3.0.1-1-any.pkg.tar.zst"; sha256 = "4e192ea9026b23aaa85f8c98e3deda72e49c9e79aee24779e3cbd525a8183835"; }];
    buildInputs = [ python python-cliff python-fixtures python-future python-pbr python-six python-subunit python-testtools python-voluptuous python-yaml ];
  };

  "python-stevedore" = fetch {
    pname       = "python-stevedore";
    version     = "1.32.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-stevedore-1.32.0-1-any.pkg.tar.xz"; sha256 = "272dd0eb6b83762ebb637d756c68212923a63be8ddc6123471d71b8bb31094ec"; }];
    buildInputs = [ python python-six ];
  };

  "python-strict-rfc3339" = fetch {
    pname       = "python-strict-rfc3339";
    version     = "0.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-strict-rfc3339-0.7-1-any.pkg.tar.xz"; sha256 = "37bac6e1995be69eaf129d27883179d428dc02b67ac412f29b36a8c26ea060e1"; }];
    buildInputs = [ python ];
  };

  "python-subunit" = fetch {
    pname       = "python-subunit";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-subunit-1.4.0-1-any.pkg.tar.xz"; sha256 = "717a02bfd8adfb71951f07cee4b9d630099725580fd3e6cb9478165ec613ef16"; }];
    buildInputs = [ python python-extras python-testtools ];
  };

  "python-sympy" = fetch {
    pname       = "python-sympy";
    version     = "1.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-sympy-1.5.1-1-any.pkg.tar.xz"; sha256 = "b42356dea8d502763f942e6de7cab23fcd00e6122f3ef541d834fa0b659ab252"; }];
    buildInputs = [ python python-mpmath ];
  };

  "python-tempita" = fetch {
    pname       = "python-tempita";
    version     = "0.5.3dev20170202";
    srcs        = [{ filename = "mingw-w64-x86_64-python-tempita-0.5.3dev20170202-1-any.pkg.tar.xz"; sha256 = "f804e9b71ff50d1a65f9cd14a8e0fe700320aa4ad69c80f60e68ac21c69e3c2b"; }];
    buildInputs = [ python ];
  };

  "python-termcolor" = fetch {
    pname       = "python-termcolor";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-termcolor-1.1.0-1-any.pkg.tar.zst"; sha256 = "e1e9a387784fc8485a8aac336f3b2fe6f422e0c528b3c7beb3231f71b1b0a4a8"; }];
    buildInputs = [ python ];
  };

  "python-terminado" = fetch {
    pname       = "python-terminado";
    version     = "0.8.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-terminado-0.8.3-1-any.pkg.tar.xz"; sha256 = "4c9e04b15e9a029f419012e0ce7b43f1e7a605ffa4dc80377de522c0c8a01014"; }];
    buildInputs = [ python python-tornado python-ptyprocess ];
  };

  "python-testpath" = fetch {
    pname       = "python-testpath";
    version     = "0.4.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-testpath-0.4.4-1-any.pkg.tar.xz"; sha256 = "f493bd42cee6a06a415849d7484f9407dc71ab9f3365931726c609645cecc9be"; }];
    buildInputs = [ python ];
  };

  "python-testrepository" = fetch {
    pname       = "python-testrepository";
    version     = "0.0.20";
    srcs        = [{ filename = "mingw-w64-x86_64-python-testrepository-0.0.20-1-any.pkg.tar.xz"; sha256 = "6570875ff123d18ec1524896bf1f269535d08a6996f24c120726bb04d966606f"; }];
    buildInputs = [ python ];
  };

  "python-testresources" = fetch {
    pname       = "python-testresources";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-testresources-2.0.1-1-any.pkg.tar.xz"; sha256 = "e72b3f9b4674b825b6d84e6662294c3663a760abb3009dd8213fcedeec482a12"; }];
    buildInputs = [ python ];
  };

  "python-testscenarios" = fetch {
    pname       = "python-testscenarios";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-testscenarios-0.5.0-1-any.pkg.tar.xz"; sha256 = "54635401370d02caf232df727f354e711de23804903c4f8297548f23c9febb34"; }];
    buildInputs = [ python ];
  };

  "python-testtools" = fetch {
    pname       = "python-testtools";
    version     = "2.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-testtools-2.4.0-1-any.pkg.tar.xz"; sha256 = "68a79b7f888f9b82413b9ead252f8f126331916421bb4d002e736c9a9305f537"; }];
    buildInputs = [ python python-pbr python-extras python-fixtures python-pyrsistent python-mimeparse ];
  };

  "python-text-unidecode" = fetch {
    pname       = "python-text-unidecode";
    version     = "1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-text-unidecode-1.3-1-any.pkg.tar.xz"; sha256 = "b5de45009ead05325792e27057ead127601b56ab145fc0405650e82df6af6db0"; }];
    buildInputs = [ python ];
  };

  "python-theano" = fetch {
    pname       = "python-theano";
    version     = "1.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-theano-1.0.4-1-any.pkg.tar.xz"; sha256 = "8302e7b14da78bab4e34d0da3388c6e7a0503582c358750bc8defa0323fc7678"; }];
    buildInputs = [ python python-numpy python-scipy python-six ];
  };

  "python-tifffile" = fetch {
    pname       = "python-tifffile";
    version     = "2020.10.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-tifffile-2020.10.1-1-any.pkg.tar.zst"; sha256 = "a1d7704581a12e5b9e4e5dc0667f26c3e0e0d63eacd0e035e429a3c90afbfce0"; }];
    buildInputs = [ python-numpy ];
  };

  "python-toml" = fetch {
    pname       = "python-toml";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-toml-0.10.0-1-any.pkg.tar.xz"; sha256 = "e8a9b65d8a55fb0214df29a35a05777b803e9fdaab3d34f9430a8e777e5731bb"; }];
    buildInputs = [ python ];
  };

  "python-toposort" = fetch {
    pname       = "python-toposort";
    version     = "1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-toposort-1.5-2-any.pkg.tar.zst"; sha256 = "2b94470e73d8ff744cd8ed4218f1390f3a0d726c29d8d965ed1a83ffbc1f6fe1"; }];
    buildInputs = [ python ];
  };

  "python-tornado" = fetch {
    pname       = "python-tornado";
    version     = "6.0.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-tornado-6.0.4-1-any.pkg.tar.xz"; sha256 = "5a77dbb1382be13da84144698f603204e24b6ba9b3fe089eaa677a4a2795fefa"; }];
    buildInputs = [ python ];
  };

  "python-tox" = fetch {
    pname       = "python-tox";
    version     = "3.20.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-tox-3.20.0-1-any.pkg.tar.zst"; sha256 = "088d3cfecec8658b89de7a62ed6f9b81a0d7f0967d46c6ed1c7049fc336318cb"; }];
    buildInputs = [ python python-py python-six python-setuptools python-setuptools-scm python-filelock python-toml python-pluggy ];
  };

  "python-tqdm" = fetch {
    pname       = "python-tqdm";
    version     = "4.50.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-tqdm-4.50.0-1-any.pkg.tar.zst"; sha256 = "e22224a6ff08f5605a68c032aee548923261f4cfebbff0fee60d9623b46ddbc1"; }];
    buildInputs = [ python ];
  };

  "python-tracery" = fetch {
    pname       = "python-tracery";
    version     = "0.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-tracery-0.1.1-1-any.pkg.tar.zst"; sha256 = "ddd2e0b01d8d00feff541f3bb71a242aca1d2bfe9109b2cecacebcc0a45d45a6"; }];
    buildInputs = [ python ];
  };

  "python-traitlets" = fetch {
    pname       = "python-traitlets";
    version     = "4.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-traitlets-4.3.3-1-any.pkg.tar.xz"; sha256 = "860c540a2a6cd825aabbf22983bf8defe2254bbcaf1ea07f0b24916676f3844e"; }];
    buildInputs = [ python-ipython_genutils python-decorator ];
  };

  "python-trimesh" = fetch {
    pname       = "python-trimesh";
    version     = "3.8.10";
    srcs        = [{ filename = "mingw-w64-x86_64-python-trimesh-3.8.10-1-any.pkg.tar.zst"; sha256 = "c42cf13816c9e41aeb4466e7c2fa4564811c49fd0f20f666e50fd45033a3ef7c"; }];
    buildInputs = [ python-numpy ];
  };

  "python-typed_ast" = fetch {
    pname       = "python-typed_ast";
    version     = "1.4.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-typed_ast-1.4.1-1-any.pkg.tar.xz"; sha256 = "aa79f35fd4e8fc787552676c0f73b4359515e741299f996b399d93fe0103866f"; }];
    buildInputs = [ python ];
  };

  "python-typing_extensions" = fetch {
    pname       = "python-typing_extensions";
    version     = "3.7.4.3";
    srcs        = [{ filename = "mingw-w64-x86_64-python-typing_extensions-3.7.4.3-1-any.pkg.tar.zst"; sha256 = "b49f92664ee43e9234c4099518d60e6657ff837fa5fbf0acd430d38e8928cf45"; }];
    buildInputs = [ python ];
  };

  "python-u-msgpack" = fetch {
    pname       = "python-u-msgpack";
    version     = "2.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-u-msgpack-2.6.0-1-any.pkg.tar.zst"; sha256 = "2d0fd34ebfe829e9561a42822c991352715ac8aa28c7a030312eb285cb551d2d"; }];
    buildInputs = [ python ];
  };

  "python-udsoncan" = fetch {
    pname       = "python-udsoncan";
    version     = "1.9";
    srcs        = [{ filename = "mingw-w64-x86_64-python-udsoncan-1.9-1-any.pkg.tar.xz"; sha256 = "d97dda27af52499fbd969632e81dea109edace8165b2af9e2284518fdc468699"; }];
    buildInputs = [ python ];
  };

  "python-ukpostcodeparser" = fetch {
    pname       = "python-ukpostcodeparser";
    version     = "1.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-ukpostcodeparser-1.1.2-1-any.pkg.tar.xz"; sha256 = "b69c7e4f7890f41468c3fc12ea141d58b7c731df629f765c97d08eb7e1048b64"; }];
    buildInputs = [ python ];
  };

  "python-unicorn" = fetch {
    pname       = "python-unicorn";
    version     = "1.0.2rc1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-unicorn-1.0.2rc1-1-any.pkg.tar.xz"; sha256 = "b62ec57b5d08fe86b4bf1b2ddbfbf6f021f54107060272bb6111b848aa0de0aa"; }];
    buildInputs = [ python unicorn ];
  };

  "python-unidecode" = fetch {
    pname       = "python-unidecode";
    version     = "1.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-unidecode-1.1.1-1-any.pkg.tar.zst"; sha256 = "8106c0e79b845788593722b4ca03ae9c27cd56d8c15e9c6a13e0b44bf2dceb9b"; }];
    buildInputs = [ python ];
  };

  "python-urllib3" = fetch {
    pname       = "python-urllib3";
    version     = "1.25.9";
    srcs        = [{ filename = "mingw-w64-x86_64-python-urllib3-1.25.9-1-any.pkg.tar.zst"; sha256 = "df57852339211260f73f034c62e31aed5e1e22e9176d386a2542658a79fadea6"; }];
    buildInputs = [ python python-certifi python-idna ];
  };

  "python-voluptuous" = fetch {
    pname       = "python-voluptuous";
    version     = "0.11.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python-voluptuous-0.11.7-1-any.pkg.tar.xz"; sha256 = "5fbd8d2f9fd7091c3ca3c39bcdbee0c7dd9e0fb9cfd30b01d42cee3fec3067eb"; }];
    buildInputs = [ python ];
  };

  "python-watchdog" = fetch {
    pname       = "python-watchdog";
    version     = "0.10.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-watchdog-0.10.2-1-any.pkg.tar.xz"; sha256 = "2f5b553d97b90b9f5d4fefe0de93416c47ac1826b66ebb6497294fca93cdd5be"; }];
    buildInputs = [ python python-argh python-pathtools python-yaml ];
  };

  "python-wcwidth" = fetch {
    pname       = "python-wcwidth";
    version     = "0.1.9";
    srcs        = [{ filename = "mingw-w64-x86_64-python-wcwidth-0.1.9-1-any.pkg.tar.zst"; sha256 = "66358e93c2274ca8a01bb9908a8d61c6cd11a47a0a87db8498bc85f49a2c7ed7"; }];
    buildInputs = [ python ];
  };

  "python-webcolors" = fetch {
    pname       = "python-webcolors";
    version     = "1.11.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-webcolors-1.11.1-1-any.pkg.tar.xz"; sha256 = "3610389483b60272fc92f8ae01155e84e5a0489ef0338a532f8bce0933ccfdbe"; }];
    buildInputs = [ python ];
  };

  "python-webencodings" = fetch {
    pname       = "python-webencodings";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-webencodings-0.5.1-1-any.pkg.tar.xz"; sha256 = "bf23753e79f2a53f50041b8e86921446d3470746c1264f81467c798145b512b4"; }];
    buildInputs = [ python ];
  };

  "python-websocket-client" = fetch {
    pname       = "python-websocket-client";
    version     = "0.57.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-websocket-client-0.57.0-1-any.pkg.tar.xz"; sha256 = "bc7fd3f3c54a49a324411c149811930ffcf907fc942820d3c43a6f223f48e3d5"; }];
    buildInputs = [ python python-six ];
  };

  "python-werkzeug" = fetch {
    pname       = "python-werkzeug";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-werkzeug-1.0.1-1-any.pkg.tar.zst"; sha256 = "59f598c41dd8e226ac5dc4ff2abe509cf0e9607a3e02bfb94b3c603a02e37754"; }];
    buildInputs = [ python ];
  };

  "python-wheel" = fetch {
    pname       = "python-wheel";
    version     = "0.34.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-wheel-0.34.2-1-any.pkg.tar.xz"; sha256 = "8744105e8fd3886a763c156df463b09242b56d2985af39cfe69b2cac8b20aaa3"; }];
    buildInputs = [ python ];
  };

  "python-whoosh" = fetch {
    pname       = "python-whoosh";
    version     = "2.7.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-whoosh-2.7.4-1-any.pkg.tar.xz"; sha256 = "066f8ddc247e17179184a81374ee889c2f3009914c90c7cd5deae88e193e9d9a"; }];
    buildInputs = [ python ];
  };

  "python-win_inet_pton" = fetch {
    pname       = "python-win_inet_pton";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-win_inet_pton-1.1.0-1-any.pkg.tar.xz"; sha256 = "cc570a0ee871da0a9bae2c0e65e36504a19e0c0d54e1688e942100b0dd7b4775"; }];
    buildInputs = [ python ];
  };

  "python-win_unicode_console" = fetch {
    pname       = "python-win_unicode_console";
    version     = "0.5";
    srcs        = [{ filename = "mingw-w64-x86_64-python-win_unicode_console-0.5-1-any.pkg.tar.xz"; sha256 = "bac08ada55fb80a8d2c0906bb4d36152bd924192c577ad0a693776065248a707"; }];
    buildInputs = [ python ];
  };

  "python-wincertstore" = fetch {
    pname       = "python-wincertstore";
    version     = "0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python-wincertstore-0.2-1-any.pkg.tar.xz"; sha256 = "7a06eff124961cd1e56947fe238e33a936e49312f26115e2c8f12190404a6ec1"; }];
    buildInputs = [ python ];
  };

  "python-winkerberos" = fetch {
    pname       = "python-winkerberos";
    version     = "0.7.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-winkerberos-0.7.0-1-any.pkg.tar.xz"; sha256 = "c1d474bf64e6d446fe88b2fa8deddec28a6599b62c07eb54819c71fd42145b7e"; }];
    buildInputs = [ python ];
  };

  "python-wrapt" = fetch {
    pname       = "python-wrapt";
    version     = "1.12.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-wrapt-1.12.1-1-any.pkg.tar.xz"; sha256 = "e3c19e17349982eaa6b9ca0a6f0ad07e452e2b6968f2e95b45c289f0600a059b"; }];
    buildInputs = [ python ];
  };

  "python-xdg" = fetch {
    pname       = "python-xdg";
    version     = "0.26";
    srcs        = [{ filename = "mingw-w64-x86_64-python-xdg-0.26-1-any.pkg.tar.xz"; sha256 = "cd89137a1179b6c41a5c58456b66264d7602d03a3ce66953313c2110c18d38fb"; }];
    buildInputs = [ python ];
  };

  "python-xlrd" = fetch {
    pname       = "python-xlrd";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-xlrd-1.2.0-1-any.pkg.tar.xz"; sha256 = "86929e00745715ef43319caeb6c48038d4b87e44213cab571bb31f4a106ad8d0"; }];
    buildInputs = [ python ];
  };

  "python-xlsxwriter" = fetch {
    pname       = "python-xlsxwriter";
    version     = "1.2.8";
    srcs        = [{ filename = "mingw-w64-x86_64-python-xlsxwriter-1.2.8-1-any.pkg.tar.xz"; sha256 = "ebb2f6e93d94c3e5ac31f82e99b7a3301d6587bd972d8f82b9ff95802da5fab1"; }];
    buildInputs = [ python ];
  };

  "python-xlwt" = fetch {
    pname       = "python-xlwt";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-xlwt-1.3.0-1-any.pkg.tar.xz"; sha256 = "98bf6c6fb58da8432415e7f81e62607dbc73027e56de4ae7804c5c3519ee1cf8"; }];
    buildInputs = [ python ];
  };

  "python-xpra" = fetch {
    pname       = "python-xpra";
    version     = "4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-xpra-4.0-1-any.pkg.tar.zst"; sha256 = "109798e4c40c46f6230bd761eab378790f5199271416e78e1632232d1f94a011"; }];
    buildInputs = [ ffmpeg gtk3 libyuv-git libvpx x264-git libwebp libjpeg-turbo python python-lz4 python-rencode python-pillow python-pyopengl python-comtypes python-setproctitle ];
  };

  "python-yaml" = fetch {
    pname       = "python-yaml";
    version     = "5.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-yaml-5.3.1-1-any.pkg.tar.xz"; sha256 = "cdeede1bacd1075c82a168e93ee12939e8f4efe8f0ded131b2619e6069341fcd"; }];
    buildInputs = [ python libyaml ];
  };

  "python-yarl" = fetch {
    pname       = "python-yarl";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-yarl-1.6.0-1-any.pkg.tar.zst"; sha256 = "334e7da189a77783e82e4b5df85b21848ef5dcc7eb35a59658fe3ddae9b649f2"; }];
    buildInputs = [ python-idna python-multidict python-typing_extensions ];
  };

  "python-zeroconf" = fetch {
    pname       = "python-zeroconf";
    version     = "0.25.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python-zeroconf-0.25.1-1-any.pkg.tar.zst"; sha256 = "5e25cb77a4cf6852059e93f6e92fa17b0de3378adcaafdecbc1e23157b2ab764"; }];
    buildInputs = [ python python-ifaddr python-netifaces python-six ];
  };

  "python-zipp" = fetch {
    pname       = "python-zipp";
    version     = "3.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-zipp-3.1.0-1-any.pkg.tar.xz"; sha256 = "c4e8dbe8ce0d0a69001af6492367e07fb4052fa811e3fca486dfb0a78588bd69"; }];
    buildInputs = [ python python-more-itertools ];
  };

  "python-zope.event" = fetch {
    pname       = "python-zope.event";
    version     = "4.4";
    srcs        = [{ filename = "mingw-w64-x86_64-python-zope.event-4.4-1-any.pkg.tar.xz"; sha256 = "1bbd4685f3450111dafdde18994e6911c604befc03c7d956827d378dfa1f0694"; }];
    buildInputs = [ python ];
  };

  "python-zope.interface" = fetch {
    pname       = "python-zope.interface";
    version     = "5.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python-zope.interface-5.1.0-1-any.pkg.tar.xz"; sha256 = "a65569bde66521eb93a1270cc26d44245d7678eb4ca89191e65f2374825c7314"; }];
    buildInputs = [ python ];
  };

  "python2" = fetch {
    pname       = "python2";
    version     = "2.7.18";
    srcs        = [{ filename = "mingw-w64-x86_64-python2-2.7.18-1-any.pkg.tar.xz"; sha256 = "3954b7786b0a4a74fc1a9ab19a3c08eb05e523c92efc4f249a4af964c4f77bc1"; }];
    buildInputs = [ gcc-libs expat bzip2 libffi ncurses openssl sqlite3 tcl tk zlib ];
  };

  "python2-cairo" = fetch {
    pname       = "python2-cairo";
    version     = "1.18.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python2-cairo-1.18.2-3-any.pkg.tar.xz"; sha256 = "4af2693d6aaa7dee3765b950c71d85eb70700b62877641ea67a00db41177e398"; }];
    buildInputs = [ cairo python2 ];
  };

  "python2-gobject2" = fetch {
    pname       = "python2-gobject2";
    version     = "2.28.7";
    srcs        = [{ filename = "mingw-w64-x86_64-python2-gobject2-2.28.7-3-any.pkg.tar.xz"; sha256 = "5289e98b9da9d2cafa9563b54481afd47b02aa159829de49c0d583053d4a3353"; }];
    buildInputs = [ glib2 libffi gobject-introspection-runtime (assert pygobject2-devel.version=="2.28.7"; pygobject2-devel) ];
  };

  "python2-pip" = fetch {
    pname       = "python2-pip";
    version     = "20.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-python2-pip-20.0.2-1-any.pkg.tar.xz"; sha256 = "5668a695bf646b3023f4324b417a7b7ac441579c71b8e3573fae3b78f4d196a0"; }];
    buildInputs = [ python2 python2-setuptools ];
  };

  "python2-pygtk" = fetch {
    pname       = "python2-pygtk";
    version     = "2.24.0";
    srcs        = [{ filename = "mingw-w64-x86_64-python2-pygtk-2.24.0-7-any.pkg.tar.xz"; sha256 = "7ece6e7e079468f9124a3cfce966e129e24687b740626e26b7acbcebac552442"; }];
    buildInputs = [ python2-cairo python2-gobject2 atk pango gtk2 libglade ];
  };

  "python2-setuptools" = fetch {
    pname       = "python2-setuptools";
    version     = "44.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-python2-setuptools-44.1.1-1-any.pkg.tar.zst"; sha256 = "9fbe0e46cf046d8bacafccf80e6acbdea11360ee948647af3772411a1458f565"; }];
    buildInputs = [ python2 ];
  };

  "qbittorrent" = fetch {
    pname       = "qbittorrent";
    version     = "4.2.5";
    srcs        = [{ filename = "mingw-w64-x86_64-qbittorrent-4.2.5-1-any.pkg.tar.zst"; sha256 = "a5230b5f05e5a2ff6f6796894383b2919de1810ce0783638797d28f306885e3b"; }];
    buildInputs = [ boost qt5 libtorrent-rasterbar zlib ];
  };

  "qbs" = fetch {
    pname       = "qbs";
    version     = "1.17.0";
    srcs        = [{ filename = "mingw-w64-x86_64-qbs-1.17.0-1-any.pkg.tar.zst"; sha256 = "9c18f73b005106d24dbdf39ce9b9c1b2f4e586987b072d5563638499fad8877e"; }];
    buildInputs = [ qt5 ];
  };

  "qca-qt5" = fetch {
    pname       = "qca-qt5";
    version     = "2.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-qca-qt5-2.3.1-1-any.pkg.tar.zst"; sha256 = "4b15521c07f66dce03e5566db08309ad9902886a6981408d1ae099e5c25dc5a8"; }];
    buildInputs = [ ca-certificates cyrus-sasl gnupg libgcrypt nss openssl qt5 ];
  };

  "qemu" = fetch {
    pname       = "qemu";
    version     = "5.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-qemu-5.1.0-1-any.pkg.tar.zst"; sha256 = "b0b58be974e9e2013c716fd3e67de87d2068a3b24a9b683867dfb37680deadf9"; }];
    buildInputs = [ capstone curl cyrus-sasl glib2 gnutls gtk3 libjpeg libpng libssh libtasn1 libusb libxml2 lzo2 nettle pixman snappy SDL2 SDL2_image libslirp usbredir zstd ];
  };

  "qhttpengine" = fetch {
    pname       = "qhttpengine";
    version     = "1.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-qhttpengine-1.0.1-1-any.pkg.tar.xz"; sha256 = "85ec8eb589999175786e8bddab1831c61b24ff4864f7da0377e69cba6ea78b83"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast qt5.version "5.4"; qt5) ];
  };

  "qhull-git" = fetch {
    pname       = "qhull-git";
    version     = "r166.f1f8b42";
    srcs        = [{ filename = "mingw-w64-x86_64-qhull-git-r166.f1f8b42-1-any.pkg.tar.xz"; sha256 = "60e8b543958eb058e6140a8c04e16c871747e6ed01e188b45a7ba49804f9aafd"; }];
    buildInputs = [ gcc-libs ];
  };

  "qmdnsengine" = fetch {
    pname       = "qmdnsengine";
    version     = "0.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-qmdnsengine-0.2.0-1-any.pkg.tar.xz"; sha256 = "b452d2efbf681bc9e3e027fba6b92049f7cba16db39a060d5e79349e2a078052"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast qt5.version "5.4"; qt5) ];
  };

  "qpdf" = fetch {
    pname       = "qpdf";
    version     = "10.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-qpdf-10.0.1-1-any.pkg.tar.xz"; sha256 = "72973a383b47352e0e22dfcfb0dd04d5919a894537ed76bba236237c436a82e7"; }];
    buildInputs = [ gcc-libs gnutls libjpeg pcre zlib ];
  };

  "qrencode" = fetch {
    pname       = "qrencode";
    version     = "4.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-qrencode-4.1.1-1-any.pkg.tar.zst"; sha256 = "8bc0ef4298c9ea45baa02fd162cb157cfef93da1cd32d4bdb8b716aee774c344"; }];
    buildInputs = [ libpng ];
  };

  "qrupdate-svn" = fetch {
    pname       = "qrupdate-svn";
    version     = "r28";
    srcs        = [{ filename = "mingw-w64-x86_64-qrupdate-svn-r28-4-any.pkg.tar.xz"; sha256 = "48d36076f5948b30c6b44d18d3b4eac62fd3a7bd3790daf79ec99165018d657b"; }];
    buildInputs = [ openblas ];
  };

  "qscintilla" = fetch {
    pname       = "qscintilla";
    version     = "2.11.5";
    srcs        = [{ filename = "mingw-w64-x86_64-qscintilla-2.11.5-1-any.pkg.tar.zst"; sha256 = "6b35d1aca1e44d57e9046debe6731ae2a9a1e9383f4f8879051c405c15acf2a3"; }];
    buildInputs = [ qt5 ];
  };

  "qt-creator" = fetch {
    pname       = "qt-creator";
    version     = "4.13.2";
    srcs        = [{ filename = "mingw-w64-x86_64-qt-creator-4.13.2-1-any.pkg.tar.zst"; sha256 = "44154f38b5f626e1a5eb5331c9de6fbf07425d9467a0812faecc1a4ec3227e58"; }];
    buildInputs = [ qt5 gcc make qbs ];
  };

  "qt-installer-framework" = fetch {
    pname       = "qt-installer-framework";
    version     = "3.2.3";
    srcs        = [{ filename = "mingw-w64-x86_64-qt-installer-framework-3.2.3-1-any.pkg.tar.zst"; sha256 = "c7deb655f27037e4593e7a9b7f45c3acacc54f87e24014e811b56736baf303cd"; }];
  };

  "qt5" = fetch {
    pname       = "qt5";
    version     = "5.15.1";
    srcs        = [{ filename = "mingw-w64-x86_64-qt5-5.15.1-1-any.pkg.tar.zst"; sha256 = "d73423943d45c132acdb011428f4ca33777eada86beb637705d11cc0a75afd68"; }];
    buildInputs = [ gcc-libs qtbinpatcher z3 assimp double-conversion dbus fontconfig freetype harfbuzz jasper libjpeg libmng libpng libtiff libxml2 libxslt libwebp openssl openal pcre2 sqlite3 vulkan xpm-nox zlib icu icu-debug-libs ];
  };

  "qt5-debug" = fetch {
    pname       = "qt5-debug";
    version     = "5.15.1";
    srcs        = [{ filename = "mingw-w64-x86_64-qt5-debug-5.15.1-1-any.pkg.tar.zst"; sha256 = "f594a7d687964e3bda77adf4a878563b1f0b19cd8b3e46b93ddcd23f88596631"; }];
    buildInputs = [ gcc-libs qtbinpatcher z3 assimp double-conversion dbus fontconfig freetype harfbuzz jasper libjpeg libmng libpng libtiff libxml2 libxslt libwebp openssl openal pcre2 sqlite3 vulkan xpm-nox zlib icu icu-debug-libs ];
  };

  "qt5-static" = fetch {
    pname       = "qt5-static";
    version     = "5.15.1";
    srcs        = [{ filename = "mingw-w64-x86_64-qt5-static-5.15.1-1-any.pkg.tar.zst"; sha256 = "9b7056162699df3b9a270c705cb1dd00b7f098488d349d16a37bf3f3d64df4f6"; }];
    buildInputs = [ gcc-libs qtbinpatcher z3 ];
  };

  "qtbinpatcher" = fetch {
    pname       = "qtbinpatcher";
    version     = "2.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-qtbinpatcher-2.2.0-4-any.pkg.tar.xz"; sha256 = "509078b7a7512fe9b284fef29ac107b242b1d38ac61c6b7ddee76b3e353d3920"; }];
    buildInputs = [  ];
  };

  "qtwebkit" = fetch {
    pname       = "qtwebkit";
    version     = "5.212.0alpha4";
    srcs        = [{ filename = "mingw-w64-x86_64-qtwebkit-5.212.0alpha4-5-any.pkg.tar.zst"; sha256 = "7e846de281500ea1990bba726daba830669adee11eb1b87d2bad4186a69fc838"; }];
    buildInputs = [ icu libxml2 libxslt libwebp fontconfig sqlite3 (assert qt5.version=="5.15.1"; qt5) woff2 ];
  };

  "quantlib" = fetch {
    pname       = "quantlib";
    version     = "1.18";
    srcs        = [{ filename = "mingw-w64-x86_64-quantlib-1.18-1-any.pkg.tar.xz"; sha256 = "0ccf5a06a3f94350e68bb66954d55a97d3724b6c843dfcb3cbb2710bb166c4a1"; }];
    buildInputs = [ boost ];
  };

  "quassel" = fetch {
    pname       = "quassel";
    version     = "0.13.1";
    srcs        = [{ filename = "mingw-w64-x86_64-quassel-0.13.1-2-any.pkg.tar.xz"; sha256 = "ac653499c73a48ff9db49c1c00f4a470c34425ba4cc790986d692d75125acf27"; }];
    buildInputs = [ qt5 qca-qt5 Snorenotify sonnet-qt5 ];
    broken      = true; # broken dependency quassel -> Snorenotify
  };

  "quazip" = fetch {
    pname       = "quazip";
    version     = "0.9.1";
    srcs        = [{ filename = "mingw-w64-x86_64-quazip-0.9.1-1-any.pkg.tar.zst"; sha256 = "8a844fb1e5221d2e5c1b641aa1a1aca65ce76d90036ea4ba039365591816af3a"; }];
    buildInputs = [ qt5 zlib ];
  };

  "qwt" = fetch {
    pname       = "qwt";
    version     = "6.1.5";
    srcs        = [{ filename = "mingw-w64-x86_64-qwt-6.1.5-1-any.pkg.tar.zst"; sha256 = "d3fe0d4a722c3e1ba01611e83b8ee72f32a92ab94d5974b670f25e771e549608"; }];
    buildInputs = [ qt5 ];
  };

  "qxmpp" = fetch {
    pname       = "qxmpp";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-qxmpp-1.3.1-1-any.pkg.tar.zst"; sha256 = "b3bd1ac195ea116e46e45668a7cdb4ec3595ca22d0efe0db3219cdee8433e643"; }];
    buildInputs = [ libtheora libvpx opus qt5 speex ];
  };

  "rabbitmq-c" = fetch {
    pname       = "rabbitmq-c";
    version     = "0.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-rabbitmq-c-0.10.0-1-any.pkg.tar.xz"; sha256 = "d8c07bb76b8d7a80ada21740f71279896232170fff104102daf80765c7aadb0e"; }];
    buildInputs = [ openssl popt ];
  };

  "ragel" = fetch {
    pname       = "ragel";
    version     = "6.10";
    srcs        = [{ filename = "mingw-w64-x86_64-ragel-6.10-1-any.pkg.tar.xz"; sha256 = "cb1b15a4f9641918b43eb7de102783c05fc59f9356d12237e6df5f9ba581d5a4"; }];
    buildInputs = [ gcc-libs ];
  };

  "rapidjson" = fetch {
    pname       = "rapidjson";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-rapidjson-1.1.0-1-any.pkg.tar.xz"; sha256 = "88601accebe5aad409921017906b45671e3117d89a5da9dcb3fade22bdedfdcd"; }];
  };

  "rav1e" = fetch {
    pname       = "rav1e";
    version     = "0.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-rav1e-0.3.3-3-any.pkg.tar.zst"; sha256 = "616c8ba222c4618ef5136549ebf0379abb3466cc304b59fe9f5ada12e8555532"; }];
    buildInputs = [ gcc-libs ];
  };

  "re2" = fetch {
    pname       = "re2";
    version     = "20200801";
    srcs        = [{ filename = "mingw-w64-x86_64-re2-20200801-1-any.pkg.tar.zst"; sha256 = "e7eb4e00ff18bb21c20aad545546c696fd5ed97d70b4abb0d77eb9a034db8157"; }];
    buildInputs = [ gcc-libs ];
  };

  "readline" = fetch {
    pname       = "readline";
    version     = "8.0.004";
    srcs        = [{ filename = "mingw-w64-x86_64-readline-8.0.004-1-any.pkg.tar.xz"; sha256 = "cbad5350c3f92ad3092e4a178d7f2b522e4f033e62c35ee6ccf10633a6e4f80b"; }];
    buildInputs = [ gcc-libs termcap ];
  };

  "readosm" = fetch {
    pname       = "readosm";
    version     = "1.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-readosm-1.1.0-1-any.pkg.tar.xz"; sha256 = "fac19b5c612b4aeb68d4b8d8252ee5ff1dbd377bd82bdc37fccf67a06ed588e0"; }];
    buildInputs = [ expat zlib ];
  };

  "recode" = fetch {
    pname       = "recode";
    version     = "3.7.6";
    srcs        = [{ filename = "mingw-w64-x86_64-recode-3.7.6-2-any.pkg.tar.xz"; sha256 = "8ce42de2633bafcebc45db752bbd595809618bed313035f30513f4737b2e6d32"; }];
    buildInputs = [ gettext ];
  };

  "rhash" = fetch {
    pname       = "rhash";
    version     = "1.3.9";
    srcs        = [{ filename = "mingw-w64-x86_64-rhash-1.3.9-1-any.pkg.tar.xz"; sha256 = "2a50a6754d0ec2f7a5ee6e247926e2ea9cc15935840bce241ab62d49370faba8"; }];
    buildInputs = [ gettext ];
  };

  "rime-bopomofo" = fetch {
    pname       = "rime-bopomofo";
    version     = "0.0.0.20190120";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-bopomofo-0.0.0.20190120-1-any.pkg.tar.xz"; sha256 = "d496744655dfc1b4d6abbd3b29664a4774583f0b2dd1e7244c40131a0f9bbbe0"; }];
    buildInputs = [ rime-cangjie rime-terra-pinyin ];
  };

  "rime-cangjie" = fetch {
    pname       = "rime-cangjie";
    version     = "0.0.0.20190120";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-cangjie-0.0.0.20190120-1-any.pkg.tar.xz"; sha256 = "679382fc52364bfc24dfb8a770fc27ead363f67c21971d43f595403b851fa0e1"; }];
    buildInputs = [ rime-luna-pinyin ];
  };

  "rime-double-pinyin" = fetch {
    pname       = "rime-double-pinyin";
    version     = "0.0.0.20190120";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-double-pinyin-0.0.0.20190120-1-any.pkg.tar.xz"; sha256 = "45f54729b932607042450b363f7973c706b87a92edc92058a6690516ebcb89bc"; }];
    buildInputs = [ rime-luna-pinyin rime-stroke ];
  };

  "rime-emoji" = fetch {
    pname       = "rime-emoji";
    version     = "0.0.0.20191102";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-emoji-0.0.0.20191102-1-any.pkg.tar.xz"; sha256 = "004a8ef28a8f7f0e07733cec80130e8c4de820f47254bf4261cc36abc28f07b0"; }];
  };

  "rime-essay" = fetch {
    pname       = "rime-essay";
    version     = "0.0.0.20200207";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-essay-0.0.0.20200207-1-any.pkg.tar.xz"; sha256 = "00212d07ddeaea2082834ad1f6e931f6d8f3b9f48b0ce217713aebb846051f61"; }];
    buildInputs = [  ];
  };

  "rime-luna-pinyin" = fetch {
    pname       = "rime-luna-pinyin";
    version     = "0.0.0.20200410";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-luna-pinyin-0.0.0.20200410-1-any.pkg.tar.xz"; sha256 = "42d846bb00474e55306455157484d595f0ceea0f66903cfd12db560095614b93"; }];
    buildInputs = [  ];
  };

  "rime-pinyin-simp" = fetch {
    pname       = "rime-pinyin-simp";
    version     = "0.0.0.20190120";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-pinyin-simp-0.0.0.20190120-1-any.pkg.tar.xz"; sha256 = "46a5e1d110dc41e48eefc823736e4c2301f8c3c6cda41a19518e4a475fe0a1ea"; }];
    buildInputs = [ rime-stroke ];
  };

  "rime-prelude" = fetch {
    pname       = "rime-prelude";
    version     = "0.0.0.20190122";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-prelude-0.0.0.20190122-1-any.pkg.tar.xz"; sha256 = "2cb0cd61b477242ed2ef416f6140c4686231e90e1f5f4fb3b58bc7ab1306325f"; }];
    buildInputs = [  ];
  };

  "rime-stroke" = fetch {
    pname       = "rime-stroke";
    version     = "0.0.0.20191221";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-stroke-0.0.0.20191221-1-any.pkg.tar.xz"; sha256 = "e8fcda6eee7ab95436c3b1f9f8c691b6970eac071eac4c32d831a790b32bfd4a"; }];
    buildInputs = [ rime-luna-pinyin ];
  };

  "rime-terra-pinyin" = fetch {
    pname       = "rime-terra-pinyin";
    version     = "0.0.0.20200207";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-terra-pinyin-0.0.0.20200207-1-any.pkg.tar.xz"; sha256 = "6a825cf97d1831eb6c17109d8291a7bf33e4d1ce5888ce282fdefcb1b17268a4"; }];
    buildInputs = [ rime-stroke ];
  };

  "rime-wubi" = fetch {
    pname       = "rime-wubi";
    version     = "0.0.0.20190120";
    srcs        = [{ filename = "mingw-w64-x86_64-rime-wubi-0.0.0.20190120-1-any.pkg.tar.zst"; sha256 = "94353d0b2fdbe5fefbc94366ab3415722a92f185cfb0ab9cd5bf101c9b07021f"; }];
    buildInputs = [ rime-pinyin-simp ];
  };

  "riscv64-unknown-elf-binutils" = fetch {
    pname       = "riscv64-unknown-elf-binutils";
    version     = "2.35";
    srcs        = [{ filename = "mingw-w64-x86_64-riscv64-unknown-elf-binutils-2.35-1-any.pkg.tar.zst"; sha256 = "b34a574472996c6c22a09bb14a856b7fb2a3fd4ad30f06fac73f733797485f98"; }];
  };

  "riscv64-unknown-elf-newlib" = fetch {
    pname       = "riscv64-unknown-elf-newlib";
    version     = "3.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-riscv64-unknown-elf-newlib-3.3.0-1-any.pkg.tar.zst"; sha256 = "cadf43e2c4279e1d38d3441201fb5f3955b0aae935190b2e5957ac4ffd814743"; }];
    buildInputs = [ riscv64-unknown-elf-binutils ];
  };

  "rocksdb" = fetch {
    pname       = "rocksdb";
    version     = "6.7.3";
    srcs        = [{ filename = "mingw-w64-x86_64-rocksdb-6.7.3-1-any.pkg.tar.xz"; sha256 = "65db77d38f40034de2b2ab857f925454f6890d594cc43252188ceda17407e43d"; }];
    buildInputs = [ bzip2 intel-tbb lz4 snappy zlib zstd ];
  };

  "rtmpdump-git" = fetch {
    pname       = "rtmpdump-git";
    version     = "r514.c5f04a5";
    srcs        = [{ filename = "mingw-w64-x86_64-rtmpdump-git-r514.c5f04a5-3-any.pkg.tar.zst"; sha256 = "646692c1f76f43c47de3c2d266530b178033d93b12a9c991db0c485182078caf"; }];
    buildInputs = [ gcc-libs gmp gnutls nettle zlib ];
  };

  "rubberband" = fetch {
    pname       = "rubberband";
    version     = "1.8.2";
    srcs        = [{ filename = "mingw-w64-x86_64-rubberband-1.8.2-1-any.pkg.tar.xz"; sha256 = "7fedf082c309663468c4ea01c4872aa70bdb288409763d08d24151e3f510104e"; }];
    buildInputs = [ gcc-libs fftw libsamplerate libsndfile ladspa-sdk vamp-plugin-sdk ];
  };

  "ruby" = fetch {
    pname       = "ruby";
    version     = "2.7.1";
    srcs        = [{ filename = "mingw-w64-x86_64-ruby-2.7.1-2-any.pkg.tar.xz"; sha256 = "926e87154011852b99c8e3a653ae0eb314c3592fdf90cea1a7063947d1046c8a"; }];
    buildInputs = [ gcc-libs gdbm libyaml libffi pdcurses openssl tk ];
  };

  "ruby-cairo" = fetch {
    pname       = "ruby-cairo";
    version     = "1.16.5";
    srcs        = [{ filename = "mingw-w64-x86_64-ruby-cairo-1.16.5-1-any.pkg.tar.xz"; sha256 = "0b617d505d432648910e2c4332c35499ec3fb8d6066e75f86c690bbf595d232c"; }];
    buildInputs = [ ruby cairo ruby-pkg-config ];
  };

  "ruby-dbus" = fetch {
    pname       = "ruby-dbus";
    version     = "0.16.0";
    srcs        = [{ filename = "mingw-w64-x86_64-ruby-dbus-0.16.0-1-any.pkg.tar.xz"; sha256 = "f0a6f2cff02cf2f32eaced736156f3b290213d6ef918c24b3a954b2c21be4db0"; }];
    buildInputs = [ ruby ];
  };

  "ruby-hpricot" = fetch {
    pname       = "ruby-hpricot";
    version     = "0.8.6";
    srcs        = [{ filename = "mingw-w64-x86_64-ruby-hpricot-0.8.6-2-any.pkg.tar.xz"; sha256 = "67dd95ed24f99cb9bb4de505bab71d578a9bac56ff27cb34859b81e9fe5da50c"; }];
    buildInputs = [ ruby ];
  };

  "ruby-mustache" = fetch {
    pname       = "ruby-mustache";
    version     = "1.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-ruby-mustache-1.1.1-1-any.pkg.tar.xz"; sha256 = "2a14cea899b017f527160d341d631d24b22f42b6b99f61d4f71ade1898727f9e"; }];
    buildInputs = [ ruby ];
  };

  "ruby-native-package-installer" = fetch {
    pname       = "ruby-native-package-installer";
    version     = "1.0.9";
    srcs        = [{ filename = "mingw-w64-x86_64-ruby-native-package-installer-1.0.9-1-any.pkg.tar.xz"; sha256 = "ef7fd4160c3744b07903aec1643457ffca27edaa611bee3ff8cfa9c3d7d1ea56"; }];
    buildInputs = [ ruby ];
  };

  "ruby-pkg-config" = fetch {
    pname       = "ruby-pkg-config";
    version     = "1.3.7";
    srcs        = [{ filename = "mingw-w64-x86_64-ruby-pkg-config-1.3.7-1-any.pkg.tar.xz"; sha256 = "301bd51b5665fa4802b5ba91792a4ac6634c68555666545e23926eb15501589b"; }];
    buildInputs = [ ruby ];
  };

  "ruby-rake-compiler" = fetch {
    pname       = "ruby-rake-compiler";
    version     = "1.0.7";
    srcs        = [{ filename = "mingw-w64-x86_64-ruby-rake-compiler-1.0.7-1-any.pkg.tar.zst"; sha256 = "1c278b4e7f35ddc084f1919f0b39ce7403d42ad8810fb3e61169a6cb068a68f9"; }];
    buildInputs = [ ruby ];
  };

  "ruby-rdiscount" = fetch {
    pname       = "ruby-rdiscount";
    version     = "2.2.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-ruby-rdiscount-2.2.0.1-2-any.pkg.tar.xz"; sha256 = "23c566ae592551bbab1f2f8c5b4547023126428db5c51452cc5033827b8ce243"; }];
    buildInputs = [ ruby ];
  };

  "ruby-ronn" = fetch {
    pname       = "ruby-ronn";
    version     = "0.7.3";
    srcs        = [{ filename = "mingw-w64-x86_64-ruby-ronn-0.7.3-2-any.pkg.tar.xz"; sha256 = "41df953b6aacfca66c6c6c7167a8f312f72dcd8dd3c7b1b508a406275992a4c4"; }];
    buildInputs = [ ruby ruby-hpricot ruby-mustache ruby-rdiscount ];
  };

  "rust" = fetch {
    pname       = "rust";
    version     = "1.43.0";
    srcs        = [{ filename = "mingw-w64-x86_64-rust-1.43.0-1-any.pkg.tar.zst"; sha256 = "0023996b7725be1e35049a26b19c50fd2f0fdd885df02e54e770f70c01be244c"; }];
    buildInputs = [ gcc ];
  };

  "rxspencer" = fetch {
    pname       = "rxspencer";
    version     = "alpha3.8.g7";
    srcs        = [{ filename = "mingw-w64-x86_64-rxspencer-alpha3.8.g7-1-any.pkg.tar.xz"; sha256 = "675891521f3c3b45be7cc0278b336000566bb22c5d099b09d9f1df39475bf565"; }];
  };

  "sassc" = fetch {
    pname       = "sassc";
    version     = "3.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-sassc-3.6.1-1-any.pkg.tar.xz"; sha256 = "e84dce8a146d099b5f05e42aa9882f37cb644b281f3f5ef90c7d1ae05431b141"; }];
    buildInputs = [ libsass ];
  };

  "scalapack" = fetch {
    pname       = "scalapack";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-scalapack-2.1.0-3-any.pkg.tar.zst"; sha256 = "b27da1d572fabfb85702f41966af835ddc8a82a22f1ce88bb45e387ab83f3776"; }];
    buildInputs = [ gcc-libs gcc-libgfortran openblas msmpi ];
  };

  "schroedinger" = fetch {
    pname       = "schroedinger";
    version     = "1.0.11";
    srcs        = [{ filename = "mingw-w64-x86_64-schroedinger-1.0.11-4-any.pkg.tar.xz"; sha256 = "36c9ec335ec5f1d7152722d5ec3992928c4e83d218e4f269fee048cb868bd14b"; }];
    buildInputs = [ orc ];
  };

  "scintilla-gtk3" = fetch {
    pname       = "scintilla-gtk3";
    version     = "4.4.4";
    srcs        = [{ filename = "mingw-w64-x86_64-scintilla-gtk3-4.4.4-2-any.pkg.tar.zst"; sha256 = "e4871ae313eaa1dfe51e2f5c743abfbe0b1012d10b13e2798a832c7b56a2b570"; }];
    buildInputs = [ gtk3 ];
  };

  "scite" = fetch {
    pname       = "scite";
    version     = "4.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-scite-4.3.3-1-any.pkg.tar.zst"; sha256 = "e90030ef53d5ac9a7713cc0dd7e9f47ecec7408ad7b585c0af81d114201774fe"; }];
    buildInputs = [ glib2 gtk3 ];
  };

  "scite-defaults" = fetch {
    pname       = "scite-defaults";
    version     = "4.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-scite-defaults-4.3.3-1-any.pkg.tar.zst"; sha256 = "ad6702d71701301e7acfce72b9860fe8b699df19eb80e09557cb7937f4ce44d8"; }];
    buildInputs = [ (assert scite.version=="4.3.3"; scite) ];
  };

  "scotch" = fetch {
    pname       = "scotch";
    version     = "6.0.9";
    srcs        = [{ filename = "mingw-w64-x86_64-scotch-6.0.9-2-any.pkg.tar.zst"; sha256 = "9574b2882355223d4a3ec4d60f82ec546f6dccd68c449204c2275a558839c361"; }];
    buildInputs = [ gcc-libs msmpi ];
  };

  "scour" = fetch {
    pname       = "scour";
    version     = "0.38.1";
    srcs        = [{ filename = "mingw-w64-x86_64-scour-0.38.1-1-any.pkg.tar.zst"; sha256 = "c0b16a965617ca4192af288ba2e9e30db31d7c3633f2ab5acf2bed6836991c69"; }];
    buildInputs = [ python python-setuptools python-six ];
  };

  "scummvm" = fetch {
    pname       = "scummvm";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-scummvm-2.0.0-2-any.pkg.tar.xz"; sha256 = "ac61dadc56c667841eaac3cbbbab23dc49a860858b2cb02a6d88ca19af26e990"; }];
    buildInputs = [ faad2 freetype flac fluidsynth libjpeg-turbo libogg libvorbis libmad libmpeg2-git libtheora libpng nasm readline SDL2 zlib ];
  };

  "sed" = fetch {
    pname       = "sed";
    version     = "4.2.2";
    srcs        = [{ filename = "mingw-w64-x86_64-sed-4.2.2-2-any.pkg.tar.zst"; sha256 = "217205cc16456f2093a432b614cb5f1f296383b5983e86a7a0aec25fa0a22a21"; }];
  };

  "seexpr" = fetch {
    pname       = "seexpr";
    version     = "2.11";
    srcs        = [{ filename = "mingw-w64-x86_64-seexpr-2.11-1-any.pkg.tar.xz"; sha256 = "da188b1e37aefb980076413037fb9a2764a96982379325b7ae8364e6aba10d96"; }];
    buildInputs = [ gcc-libs ];
  };

  "sfml" = fetch {
    pname       = "sfml";
    version     = "2.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-sfml-2.5.1-2-any.pkg.tar.xz"; sha256 = "9b9f6567907d819df307d4f38ec8f3be9011f6523481061462d630af38b651ee"; }];
    buildInputs = [ flac freetype libjpeg libvorbis openal ];
  };

  "sgml-common" = fetch {
    pname       = "sgml-common";
    version     = "0.6.3";
    srcs        = [{ filename = "mingw-w64-x86_64-sgml-common-0.6.3-1-any.pkg.tar.xz"; sha256 = "40cfc54553a753e4ea0ed002d0193a94b337f38c13de19629b3fdc179ab44fdc"; }];
    buildInputs = [ sh ];
  };

  "shaderc" = fetch {
    pname       = "shaderc";
    version     = "2020.0";
    srcs        = [{ filename = "mingw-w64-x86_64-shaderc-2020.0-1-any.pkg.tar.zst"; sha256 = "5864e4ca7e8e3a99a26315ef48a067e488488c4df77c4fb39dae386c68ed09cb"; }];
    buildInputs = [ gcc-libs glslang spirv-tools ];
  };

  "shapelib" = fetch {
    pname       = "shapelib";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-shapelib-1.5.0-1-any.pkg.tar.xz"; sha256 = "756859450969b8ac1a0177619ac412d5b60fddc459d7bb363b688bee63a9b10d"; }];
    buildInputs = [ gcc-libs proj ];
  };

  "shared-mime-info" = fetch {
    pname       = "shared-mime-info";
    version     = "2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-shared-mime-info-2.0-1-any.pkg.tar.zst"; sha256 = "420cf529fc7e0fd1662f2d45ec62687b6ac56506ca6ae2c18a890676411ba57a"; }];
    buildInputs = [ libxml2 glib2 ];
  };

  "shiboken2-qt5" = fetch {
    pname       = "shiboken2-qt5";
    version     = "5.14.2";
    srcs        = [{ filename = "mingw-w64-x86_64-shiboken2-qt5-5.14.2-1-any.pkg.tar.zst"; sha256 = "1f1c09adeee387532e9bd5a4e1a2f926df4168df432efe9cc10fe67c937d7128"; }];
    buildInputs = [ python qt5 ];
  };

  "shine" = fetch {
    pname       = "shine";
    version     = "3.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-shine-3.1.1-1-any.pkg.tar.xz"; sha256 = "ee4fbc2f467bd7b022d24af6e9c33267b9a929e9613fe2b0cc6d9b37d9578450"; }];
  };

  "shishi-git" = fetch {
    pname       = "shishi-git";
    version     = "r3586.07f8ed3d";
    srcs        = [{ filename = "mingw-w64-x86_64-shishi-git-r3586.07f8ed3d-1-any.pkg.tar.xz"; sha256 = "ed99e9adc9403e968b5d9bfca557f9836bd1fa74b9be8ff5b478f8464fd3ba14"; }];
    buildInputs = [ gnutls libidn libgcrypt libgpg-error libtasn1 ];
  };

  "silc-toolkit" = fetch {
    pname       = "silc-toolkit";
    version     = "1.1.12";
    srcs        = [{ filename = "mingw-w64-x86_64-silc-toolkit-1.1.12-3-any.pkg.tar.xz"; sha256 = "f67c238e7c0b8c842d9130f1683e281da154b419304d92a04fe5c2ab3b49a884"; }];
    buildInputs = [ libsystre ];
  };

  "simdjson" = fetch {
    pname       = "simdjson";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-simdjson-0.5.0-1-any.pkg.tar.zst"; sha256 = "ec87a88f4d18db8acb4d2b705cc209e9548718e2c05e29d55c768ab0a75448ac"; }];
    buildInputs = [ gcc-libs ];
  };

  "sip" = fetch {
    pname       = "sip";
    version     = "4.19.22";
    srcs        = [{ filename = "mingw-w64-x86_64-sip-4.19.22-1-any.pkg.tar.xz"; sha256 = "f20ad5eafd00c179a2e08a562d6eedc573ff58e1bc36e8ab4857cfb3406b3c57"; }];
    buildInputs = [ gcc-libs ];
  };

  "sip5" = fetch {
    pname       = "sip5";
    version     = "5.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-sip5-5.4.0-1-any.pkg.tar.zst"; sha256 = "9698e0e43dabd3596d7d0bee2abf2381d5d5dcacddf3511684f822a0e94ba413"; }];
    buildInputs = [ python-setuptools python-toml python ];
  };

  "smpeg" = fetch {
    pname       = "smpeg";
    version     = "0.4.5";
    srcs        = [{ filename = "mingw-w64-x86_64-smpeg-0.4.5-2-any.pkg.tar.xz"; sha256 = "35a6400d6cba68466d1160d857176c54a279de74b8d228c561097118808c4db1"; }];
    buildInputs = [ gcc-libs SDL ];
  };

  "smpeg2" = fetch {
    pname       = "smpeg2";
    version     = "2.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-smpeg2-2.0.0-5-any.pkg.tar.xz"; sha256 = "35f4c47d798239183e65716cc180d1d284462e7604481dc0a4b79a7a484a0dc5"; }];
    buildInputs = [ gcc-libs SDL2 ];
  };

  "snappy" = fetch {
    pname       = "snappy";
    version     = "1.1.8";
    srcs        = [{ filename = "mingw-w64-x86_64-snappy-1.1.8-1-any.pkg.tar.xz"; sha256 = "dc60c6d02f8a1784408375d4ab6fff38075e3c0abd46f22137e81263218d2f06"; }];
    buildInputs = [ gcc-libs ];
  };

  "snoregrowl" = fetch {
    pname       = "snoregrowl";
    version     = "0.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-snoregrowl-0.5.0-1-any.pkg.tar.xz"; sha256 = "3593720b9766119642638304f700698246ecbb9cea1529d1807fa5ecd2f39872"; }];
  };

  "snorenotify" = fetch {
    pname       = "snorenotify";
    version     = "0.7.0";
    srcs        = [{ filename = "mingw-w64-x86_64-snorenotify-0.7.0-3-any.pkg.tar.xz"; sha256 = "904b5b582fdf4f7b5a05c13ed455d18576bf49d4ccaf668e7706404657946f81"; }];
    buildInputs = [ qt5 snoregrowl ];
  };

  "soci" = fetch {
    pname       = "soci";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-soci-4.0.0-1-any.pkg.tar.xz"; sha256 = "396bc4b73460ae2ee46cde65137e6a966e597e4698e759ddaa2c2d6b0564c6a3"; }];
    buildInputs = [ boost ];
  };

  "soil" = fetch {
    pname       = "soil";
    version     = "1.16.0";
    srcs        = [{ filename = "mingw-w64-x86_64-soil-1.16.0-1-any.pkg.tar.zst"; sha256 = "0feec1a5beaef45a42ca2d5878a497017f5d1e28b3420524ad39b49c274a1d3a"; }];
    buildInputs = [ gcc-libs ];
  };

  "solid-qt5" = fetch {
    pname       = "solid-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-solid-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "b01df0667d7f9029d28bc9092b351474424bcc5a23e5ac3bcff729820f7c0bf0"; }];
    buildInputs = [ qt5 ];
  };

  "sonnet-qt5" = fetch {
    pname       = "sonnet-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-sonnet-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "94fde0f236a7b97502ca19da51d5506d9475b0c6e4f5e9f8668db3de77352dbd"; }];
    buildInputs = [ qt5 ];
  };

  "soqt" = fetch {
    pname       = "soqt";
    version     = "1.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-soqt-1.6.0-1-any.pkg.tar.zst"; sha256 = "9f924f1de3f6b3bbe870d323584f6341a277c48103cf8c6a5943b52edf3bc34c"; }];
    buildInputs = [ gcc-libs coin qt5 ];
  };

  "soundtouch" = fetch {
    pname       = "soundtouch";
    version     = "2.1.2";
    srcs        = [{ filename = "mingw-w64-x86_64-soundtouch-2.1.2-1-any.pkg.tar.xz"; sha256 = "7c3ea97a184f62b0b87c7730d82eac4831a6bfb6ca1e39a1aa94153b697988ce"; }];
    buildInputs = [ gcc-libs ];
  };

  "source-highlight" = fetch {
    pname       = "source-highlight";
    version     = "3.1.9";
    srcs        = [{ filename = "mingw-w64-x86_64-source-highlight-3.1.9-2-any.pkg.tar.zst"; sha256 = "89861da2cce90870c3b3341c2fdca74d6e582689488fbfe99cb54a35dee659ef"; }];
    buildInputs = [ bash boost ];
  };

  "sox" = fetch {
    pname       = "sox";
    version     = "14.4.2.r3203.07de8a77";
    srcs        = [{ filename = "mingw-w64-x86_64-sox-14.4.2.r3203.07de8a77-3-any.pkg.tar.zst"; sha256 = "fe57894bb6f31bb0066ed0aad707399302d12718a5fd23cde0e0a1a5b8d098e4"; }];
    buildInputs = [ gcc-libs flac gsm id3lib lame libao libid3tag libmad libpng libsndfile libtool libvorbis opencore-amr opusfile twolame vo-amrwbenc wavpack ];
  };

  "sparsehash" = fetch {
    pname       = "sparsehash";
    version     = "2.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-sparsehash-2.0.3-1-any.pkg.tar.xz"; sha256 = "15eadd6bd9b735cdea8ca20b958362617366034a651ff28c659977805483781d"; }];
  };

  "spatialite-tools" = fetch {
    pname       = "spatialite-tools";
    version     = "4.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-spatialite-tools-4.3.0-3-any.pkg.tar.xz"; sha256 = "862f78fdf880228b7f48f89a0a3ddbc916915a878373bfd64486e2d46a6f086f"; }];
    buildInputs = [ libiconv libspatialite readline readosm ];
  };

  "spdlog" = fetch {
    pname       = "spdlog";
    version     = "1.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-spdlog-1.8.1-1-any.pkg.tar.zst"; sha256 = "e8c759db4b0ab24613c198dfe7dc24110256f89a3d84edb6745d00be4e7c1e0d"; }];
    buildInputs = [ fmt ];
  };

  "spdylay" = fetch {
    pname       = "spdylay";
    version     = "1.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-spdylay-1.4.0-1-any.pkg.tar.xz"; sha256 = "549dfbecb06dd6f8294f28577c0c5d3cbed147242892662e08d66a2d953a8fa0"; }];
  };

  "speex" = fetch {
    pname       = "speex";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-speex-1.2.0-1-any.pkg.tar.xz"; sha256 = "51d8869f9cb04cdcfb89d3220562411fdb0ddd4ec0c583a174a1dede183933b9"; }];
    buildInputs = [ libogg speexdsp ];
  };

  "speexdsp" = fetch {
    pname       = "speexdsp";
    version     = "1.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-speexdsp-1.2.0-1-any.pkg.tar.xz"; sha256 = "26bcec48b205c01781ddd08ee014922d344971c12a0ccd65028d407445acbc23"; }];
    buildInputs = [ gcc-libs ];
  };

  "spice-gtk" = fetch {
    pname       = "spice-gtk";
    version     = "0.38";
    srcs        = [{ filename = "mingw-w64-x86_64-spice-gtk-0.38-1-any.pkg.tar.zst"; sha256 = "5514f0fc19c715753fd78da67f3b2be4089eb7a47e4ad42fc07898f2247e8edf"; }];
    buildInputs = [ cyrus-sasl dbus-glib gobject-introspection gstreamer gst-plugins-base gtk3 libjpeg-turbo lz4 openssl phodav pixman spice-protocol usbredir vala ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "spice-protocol" = fetch {
    pname       = "spice-protocol";
    version     = "0.14.1";
    srcs        = [{ filename = "mingw-w64-x86_64-spice-protocol-0.14.1-1-any.pkg.tar.xz"; sha256 = "f524a560f47877bf887a02c67d5e5523a24ca169917bbae909cae4d07bc9b742"; }];
  };

  "spirv-headers" = fetch {
    pname       = "spirv-headers";
    version     = "1.5.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-spirv-headers-1.5.3.1-1-any.pkg.tar.zst"; sha256 = "d64b95810eeaf26cdf933d8b4e4a4567dd8c370acdede81625b6bb56d1623060"; }];
  };

  "spirv-tools" = fetch {
    pname       = "spirv-tools";
    version     = "2020.4";
    srcs        = [{ filename = "mingw-w64-x86_64-spirv-tools-2020.4-1-any.pkg.tar.zst"; sha256 = "9f398f1554b6abc3983ee6644cd1122068150ecce851ce908b8e31863afe5cdc"; }];
    buildInputs = [ gcc-libs ];
  };

  "sqlcipher" = fetch {
    pname       = "sqlcipher";
    version     = "4.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-sqlcipher-4.4.0-1-any.pkg.tar.zst"; sha256 = "a69f467aa882aec2aba8649ebee373d1af5281bac2a2fe08c2f7743134c3248b"; }];
    buildInputs = [ gcc-libs openssl readline ];
  };

  "sqlheavy" = fetch {
    pname       = "sqlheavy";
    version     = "0.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-sqlheavy-0.1.1-2-any.pkg.tar.xz"; sha256 = "8a1f6f62fdd1bf0183ac236d9ad52c63cb538393c519a65885f45aa269996978"; }];
    buildInputs = [ gtk2 sqlite3 vala libxml2 ];
  };

  "sqlite3" = fetch {
    pname       = "sqlite3";
    version     = "3.33.0";
    srcs        = [{ filename = "mingw-w64-x86_64-sqlite3-3.33.0-1-any.pkg.tar.zst"; sha256 = "7b49c34d9d5cca60ef6f2b800a3a04c61739b922052f53a95f65302136901d93"; }];
    buildInputs = [ gcc-libs readline tcl ];
  };

  "squirrel" = fetch {
    pname       = "squirrel";
    version     = "3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-squirrel-3.1-2-any.pkg.tar.xz"; sha256 = "cf8561fcee0c105eb32fc95ebf547c742a2fb40256e3248420ac873148c35863"; }];
  };

  "srecord" = fetch {
    pname       = "srecord";
    version     = "1.64";
    srcs        = [{ filename = "mingw-w64-x86_64-srecord-1.64-1-any.pkg.tar.xz"; sha256 = "5f8a062259fbcb343c90df4aac3d2c3d8e3421b346f826e0e9cb61a00412cdf7"; }];
    buildInputs = [ gcc-libs libgpg-error libgcrypt ];
  };

  "srt" = fetch {
    pname       = "srt";
    version     = "1.4.2";
    srcs        = [{ filename = "mingw-w64-x86_64-srt-1.4.2-1-any.pkg.tar.zst"; sha256 = "c4bdec135ff9d3b41ecb55eee3276fd82f891c5fa7cbb3964fa7bad591467af1"; }];
    buildInputs = [ gcc-libs libwinpthread-git openssl ];
  };

  "stlink" = fetch {
    pname       = "stlink";
    version     = "1.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-stlink-1.6.1-1-any.pkg.tar.zst"; sha256 = "16c20d56ddc0cf1a8d6ef965510e6dc0dfa66e2d5504f75990e4af2cd51783ab"; }];
    buildInputs = [ libusb ];
  };

  "stxxl-git" = fetch {
    pname       = "stxxl-git";
    version     = "1.4.1.343.gf7389c7";
    srcs        = [{ filename = "mingw-w64-x86_64-stxxl-git-1.4.1.343.gf7389c7-2-any.pkg.tar.xz"; sha256 = "0ede048be6684e63f90effa497a6f7930e8aa703fb2b0e414ac71ee3b05f6eeb"; }];
  };

  "styrene" = fetch {
    pname       = "styrene";
    version     = "0.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-styrene-0.3.0-3-any.pkg.tar.xz"; sha256 = "691c9533514786fbb869e7ed213deb2aac31a9dac6c5a9802957352d2380dd4f"; }];
    buildInputs = [ zip python3 gcc binutils nsis ];
    broken      = true; # broken dependency styrene -> zip
  };

  "suitesparse" = fetch {
    pname       = "suitesparse";
    version     = "5.7.2";
    srcs        = [{ filename = "mingw-w64-x86_64-suitesparse-5.7.2-1-any.pkg.tar.xz"; sha256 = "ecc1a6d696c7f11b9b55e1a37ea17e8155a23bc41e5f965f6d1a8ffeea7f1f52"; }];
    buildInputs = [ openblas metis ];
  };

  "swig" = fetch {
    pname       = "swig";
    version     = "4.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-swig-4.0.2-1-any.pkg.tar.zst"; sha256 = "9f77552237dfd9858cfdebc0d92062c584f351fb56054404659ccd499eacb619"; }];
    buildInputs = [ gcc-libs pcre ];
  };

  "syndication-qt5" = fetch {
    pname       = "syndication-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-syndication-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "3aaebbe54af082570b20ea26419ff502dee037321d14fed4871b46abbf8d67ff"; }];
    buildInputs = [ qt5 (assert stdenvNoCC.lib.versionAtLeast kcodecs-qt5.version "5.74.0"; kcodecs-qt5) ];
  };

  "syntax-highlighting-qt5" = fetch {
    pname       = "syntax-highlighting-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-syntax-highlighting-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "783b5a0287f15bf72cf679294be0c64f66aaef1db6ec6c3a89b33e63554db63b"; }];
    buildInputs = [ qt5 ];
  };

  "szip" = fetch {
    pname       = "szip";
    version     = "2.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-szip-2.1.1-2-any.pkg.tar.xz"; sha256 = "ec8fe26370b0673c4b91f5ccf3404907dc7c24cb9d75c7b8830aa93a7c13ace7"; }];
    buildInputs = [  ];
  };

  "t1utils" = fetch {
    pname       = "t1utils";
    version     = "1.41";
    srcs        = [{ filename = "mingw-w64-x86_64-t1utils-1.41-1-any.pkg.tar.xz"; sha256 = "d788e68c2e0ca2bd834b7e49f301eeab97aac9c0b23c8d6897f84445fa08aca6"; }];
  };

  "taglib" = fetch {
    pname       = "taglib";
    version     = "1.11.1";
    srcs        = [{ filename = "mingw-w64-x86_64-taglib-1.11.1-1-any.pkg.tar.xz"; sha256 = "add3f00da1ba820f7b68b8eb6398c704d503fb96318d9ad86aaa322ff1066cde"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "tcl" = fetch {
    pname       = "tcl";
    version     = "8.6.10";
    srcs        = [{ filename = "mingw-w64-x86_64-tcl-8.6.10-1-any.pkg.tar.xz"; sha256 = "db48f5916134c5342cb1f137c48386f69e1458dbfae24e7a4b0626e44e56072d"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "tcl-nsf" = fetch {
    pname       = "tcl-nsf";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tcl-nsf-2.1.0-1-any.pkg.tar.xz"; sha256 = "85f5ca59adbc24222063e1b7b048452283510b7422aaf465c5cfecf8946503cf"; }];
    buildInputs = [ tcl ];
  };

  "tcllib" = fetch {
    pname       = "tcllib";
    version     = "1.20";
    srcs        = [{ filename = "mingw-w64-x86_64-tcllib-1.20-1-any.pkg.tar.xz"; sha256 = "977b7b4cf82a59d2c668cb0c7dabfd30c1286ca1ce57b7fc7069961ea8c2126b"; }];
    buildInputs = [ tcl ];
  };

  "tclvfs-cvs" = fetch {
    pname       = "tclvfs-cvs";
    version     = "20130425";
    srcs        = [{ filename = "mingw-w64-x86_64-tclvfs-cvs-20130425-3-any.pkg.tar.zst"; sha256 = "7c940d3be7c4a419d00614071d3f877de7ee93c99e19f51676ea6e8b2e7d664f"; }];
    buildInputs = [ tcl ];
  };

  "tclx" = fetch {
    pname       = "tclx";
    version     = "8.4.4";
    srcs        = [{ filename = "mingw-w64-x86_64-tclx-8.4.4-1-any.pkg.tar.xz"; sha256 = "da1f96f18d43a1c3696b8b18e69fe405669fda9c80216093c33ba2b0f35edca9"; }];
    buildInputs = [ tcl ];
  };

  "teensy-loader-cli" = fetch {
    pname       = "teensy-loader-cli";
    version     = "2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-teensy-loader-cli-2.1-1-any.pkg.tar.zst"; sha256 = "59556943bf85dddf1e055b583701c23819cb32691dfcb87ee8f0a9fa292a7c21"; }];
    buildInputs = [ libusb-compat-git ];
  };

  "template-glib" = fetch {
    pname       = "template-glib";
    version     = "3.34.0";
    srcs        = [{ filename = "mingw-w64-x86_64-template-glib-3.34.0-1-any.pkg.tar.xz"; sha256 = "20f9af600d7c7434398579a79ea7fbc561fe895d15eba8d26dc01fc437d04f9e"; }];
    buildInputs = [ glib2 gobject-introspection ];
  };

  "tepl5" = fetch {
    pname       = "tepl5";
    version     = "5.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tepl5-5.0.0-1-any.pkg.tar.zst"; sha256 = "960f035a40f0034a7bd5f3e38c9f69dfda879c6c56d5e26fc42c924fe0d7823f"; }];
    buildInputs = [ amtk gtksourceview4 icu ];
  };

  "termcap" = fetch {
    pname       = "termcap";
    version     = "1.3.1";
    srcs        = [{ filename = "mingw-w64-x86_64-termcap-1.3.1-6-any.pkg.tar.zst"; sha256 = "782fc19a7ddf10b6f7abc60b9d4227bac622cb3056c91747dd61d73d8afcebf1"; }];
    buildInputs = [ gcc-libs ];
  };

  "tesseract-data-afr" = fetch {
    pname       = "tesseract-data-afr";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-afr-4.0.0-1-any.pkg.tar.xz"; sha256 = "f366d285440d4a07a54af0e7458f75a773dec30b5382f49edb86d46f05b80066"; }];
  };

  "tesseract-data-amh" = fetch {
    pname       = "tesseract-data-amh";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-amh-4.0.0-1-any.pkg.tar.xz"; sha256 = "ae3acc16f248086c8d09c23c5a57d166e78065d9741a4a7e86c47811e34ccb4a"; }];
  };

  "tesseract-data-ara" = fetch {
    pname       = "tesseract-data-ara";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ara-4.0.0-1-any.pkg.tar.xz"; sha256 = "39bd52d2206ac59f304afdb1be0c5739d4a1046883578559d93fed62d1ccbaec"; }];
  };

  "tesseract-data-asm" = fetch {
    pname       = "tesseract-data-asm";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-asm-4.0.0-1-any.pkg.tar.xz"; sha256 = "0874ed9d63563b95bb707cd29aceab7a24f212d3d4c8ca7bda5c78fcbeaec608"; }];
  };

  "tesseract-data-aze" = fetch {
    pname       = "tesseract-data-aze";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-aze-4.0.0-1-any.pkg.tar.xz"; sha256 = "a2321440942ed557e10b0410b3963587f74848e099b121cd58d180a4a7c83e4d"; }];
  };

  "tesseract-data-aze_cyrl" = fetch {
    pname       = "tesseract-data-aze_cyrl";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-aze_cyrl-4.0.0-1-any.pkg.tar.xz"; sha256 = "cfb72dfd61bc214984cfeb4503d2b3d2559356d0e0a3cb5a81b6c9dd0f78e952"; }];
  };

  "tesseract-data-bel" = fetch {
    pname       = "tesseract-data-bel";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-bel-4.0.0-1-any.pkg.tar.xz"; sha256 = "6ab605db8bd90aad7685c4411c63a4474e0745368040e4215aedc4027ddf6137"; }];
  };

  "tesseract-data-ben" = fetch {
    pname       = "tesseract-data-ben";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ben-4.0.0-1-any.pkg.tar.xz"; sha256 = "f329c1fb894afe163d609caabd22588c9484971cf73cc1863bdc721e9e7a417f"; }];
  };

  "tesseract-data-bod" = fetch {
    pname       = "tesseract-data-bod";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-bod-4.0.0-1-any.pkg.tar.xz"; sha256 = "03ee0f00a05ce05ab5ef400ca0a09abf674fec137012707f7c4c6295845e181d"; }];
  };

  "tesseract-data-bos" = fetch {
    pname       = "tesseract-data-bos";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-bos-4.0.0-1-any.pkg.tar.xz"; sha256 = "dd4c1b9e4bd1c0e1cee355870d8ba63ae623af7c4215a615e7986492873861cc"; }];
  };

  "tesseract-data-bul" = fetch {
    pname       = "tesseract-data-bul";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-bul-4.0.0-1-any.pkg.tar.xz"; sha256 = "f000540c5391bedfe72caab378a2fa979739e7178a50155a3eccd50e02619d4d"; }];
  };

  "tesseract-data-cat" = fetch {
    pname       = "tesseract-data-cat";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-cat-4.0.0-1-any.pkg.tar.xz"; sha256 = "74add7e28d49e32f028f03752d3b268c701d7f58e4e64842f1f408f9caec2716"; }];
  };

  "tesseract-data-ceb" = fetch {
    pname       = "tesseract-data-ceb";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ceb-4.0.0-1-any.pkg.tar.xz"; sha256 = "4e6469e7444a3cd723a2313faab4c3536b731ae45b720a31a8ca2bd02e676f43"; }];
  };

  "tesseract-data-ces" = fetch {
    pname       = "tesseract-data-ces";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ces-4.0.0-1-any.pkg.tar.xz"; sha256 = "8a094251077ba979e2b853c59c8ed49f0981aa847dae47b7d9bf678cfca796ab"; }];
  };

  "tesseract-data-chi_sim" = fetch {
    pname       = "tesseract-data-chi_sim";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-chi_sim-4.0.0-1-any.pkg.tar.xz"; sha256 = "11856ea7cbb98fcff58e83a2d51a9b1059d7b5e525f33321601a51ccf0720c2e"; }];
  };

  "tesseract-data-chi_tra" = fetch {
    pname       = "tesseract-data-chi_tra";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-chi_tra-4.0.0-1-any.pkg.tar.xz"; sha256 = "8781fbb8700d9d7c7871e44cb8a3365a4b71c4e3eb6cb2a831766947bb6a75ac"; }];
  };

  "tesseract-data-chr" = fetch {
    pname       = "tesseract-data-chr";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-chr-4.0.0-1-any.pkg.tar.xz"; sha256 = "6b8e4ced7121c8efdac4e61bf8e3801b7539602b76939e757ab4b414caf9f018"; }];
  };

  "tesseract-data-cym" = fetch {
    pname       = "tesseract-data-cym";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-cym-4.0.0-1-any.pkg.tar.xz"; sha256 = "88c61487568a64551514fdbd44030d37503fa6463e2cbfde6f77fb30373ee671"; }];
  };

  "tesseract-data-dan" = fetch {
    pname       = "tesseract-data-dan";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-dan-4.0.0-1-any.pkg.tar.xz"; sha256 = "4042478af692eca750c595e162e28f00ad3a9191876f55ceb9744693cb21fc88"; }];
  };

  "tesseract-data-deu" = fetch {
    pname       = "tesseract-data-deu";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-deu-4.0.0-1-any.pkg.tar.xz"; sha256 = "30ae20c519793f39c04408db39324a5a33f0b2e76af376cd1fb67c92e91a6da9"; }];
  };

  "tesseract-data-dzo" = fetch {
    pname       = "tesseract-data-dzo";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-dzo-4.0.0-1-any.pkg.tar.xz"; sha256 = "523c5f71a91b0f68e90add362e0732a08b46caff702d39b2b3809dbe03f4559a"; }];
  };

  "tesseract-data-ell" = fetch {
    pname       = "tesseract-data-ell";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ell-4.0.0-1-any.pkg.tar.xz"; sha256 = "35f96824e2c2890c1c1a2a175697d4ecdd02bac4a06f2c5dafb1525272996857"; }];
  };

  "tesseract-data-eng" = fetch {
    pname       = "tesseract-data-eng";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-eng-4.0.0-1-any.pkg.tar.xz"; sha256 = "7c9259aed1cf678507e530e7ff7845e0c7138d6e3dc856d1526ed596dfa24a00"; }];
  };

  "tesseract-data-enm" = fetch {
    pname       = "tesseract-data-enm";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-enm-4.0.0-1-any.pkg.tar.xz"; sha256 = "ccd133f051d90b77dabc31c56b76d3b9c51a3b803853182fabff1be94ece2218"; }];
  };

  "tesseract-data-epo" = fetch {
    pname       = "tesseract-data-epo";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-epo-4.0.0-1-any.pkg.tar.xz"; sha256 = "c0efa9033bc121439de909f4a60636dcf0112ffd0b1abbe2413a6bf2965fbc90"; }];
  };

  "tesseract-data-est" = fetch {
    pname       = "tesseract-data-est";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-est-4.0.0-1-any.pkg.tar.xz"; sha256 = "4852e8884faa88e8dd95be63e77a85c742be113db65ffaf9b95d06591b299e06"; }];
  };

  "tesseract-data-eus" = fetch {
    pname       = "tesseract-data-eus";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-eus-4.0.0-1-any.pkg.tar.xz"; sha256 = "cc60ee8c3b7ed005c6eb1b018d4698cc9544ed25eea3c0e867bb438c208e2748"; }];
  };

  "tesseract-data-fas" = fetch {
    pname       = "tesseract-data-fas";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-fas-4.0.0-1-any.pkg.tar.xz"; sha256 = "d12e3932d8fe7e4f42a40b75b47e149c7af6bb010ec6635b5ec7961e9aa72a6e"; }];
  };

  "tesseract-data-fin" = fetch {
    pname       = "tesseract-data-fin";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-fin-4.0.0-1-any.pkg.tar.xz"; sha256 = "7cc3614ceccc1b804ccbe61a204fc13947a6fb42ec3e109454af01f893dc10eb"; }];
  };

  "tesseract-data-fra" = fetch {
    pname       = "tesseract-data-fra";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-fra-4.0.0-1-any.pkg.tar.xz"; sha256 = "4afeb360b60ead7770991e1cdaae324b3af13858051fa8a9d0b6bb1b76d20a65"; }];
  };

  "tesseract-data-frk" = fetch {
    pname       = "tesseract-data-frk";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-frk-4.0.0-1-any.pkg.tar.xz"; sha256 = "773cd6c9b27f7ce1447a01b18aeef5d9bd5596e3308fcccb443ecf6db1980f5d"; }];
  };

  "tesseract-data-frm" = fetch {
    pname       = "tesseract-data-frm";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-frm-4.0.0-1-any.pkg.tar.xz"; sha256 = "a543fc165f8881818b953649f3ebb66f7e49dc41b675b6991cce5e7a162899ef"; }];
  };

  "tesseract-data-gle" = fetch {
    pname       = "tesseract-data-gle";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-gle-4.0.0-1-any.pkg.tar.xz"; sha256 = "3ae3c8c3f63bc32e74ecfca7c801ca7c77b74ba85c4fb9557feb1effb5328403"; }];
  };

  "tesseract-data-glg" = fetch {
    pname       = "tesseract-data-glg";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-glg-4.0.0-1-any.pkg.tar.xz"; sha256 = "c9838515b2afde55c0b990c33b67e0e47afc53377b2049dcd49a89fe60b101e1"; }];
  };

  "tesseract-data-grc" = fetch {
    pname       = "tesseract-data-grc";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-grc-4.0.0-1-any.pkg.tar.xz"; sha256 = "ee7b72c293a8077acf31ee88d52b66a29e4c7a2c0e580ffeee3c479319d6337f"; }];
  };

  "tesseract-data-guj" = fetch {
    pname       = "tesseract-data-guj";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-guj-4.0.0-1-any.pkg.tar.xz"; sha256 = "f0e3ccc217f4e1b63a27dd21917ccc8a785e298e9a55807761a7cab7b521ca44"; }];
  };

  "tesseract-data-hat" = fetch {
    pname       = "tesseract-data-hat";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-hat-4.0.0-1-any.pkg.tar.xz"; sha256 = "08f241102fc3653d27a700f9e6e3477b189d1f7820309c801f3084e6980357c4"; }];
  };

  "tesseract-data-heb" = fetch {
    pname       = "tesseract-data-heb";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-heb-4.0.0-1-any.pkg.tar.xz"; sha256 = "b0f639aa8568f8a0d06801ce874a784c9ee522c91c8caa0c0d98e599a1f92dd5"; }];
  };

  "tesseract-data-hin" = fetch {
    pname       = "tesseract-data-hin";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-hin-4.0.0-1-any.pkg.tar.xz"; sha256 = "86b6fa10ab0315662e59ec3b82e8a805d3d937f7166ef451dd87a48ecd3b953f"; }];
  };

  "tesseract-data-hrv" = fetch {
    pname       = "tesseract-data-hrv";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-hrv-4.0.0-1-any.pkg.tar.xz"; sha256 = "a1b3fbab1d6522ad39e4eb889dd8451adac87209747d5369fff4636fc82e5fb7"; }];
  };

  "tesseract-data-hun" = fetch {
    pname       = "tesseract-data-hun";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-hun-4.0.0-1-any.pkg.tar.xz"; sha256 = "8a8794f3eb4bb789212d512e315748920bfe779bd3bbd034c1025bfa5ebd6708"; }];
  };

  "tesseract-data-iku" = fetch {
    pname       = "tesseract-data-iku";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-iku-4.0.0-1-any.pkg.tar.xz"; sha256 = "df25bc613828d50ea8f5bb4e3924a03117bbf7837e118d098a5defec173a3f4e"; }];
  };

  "tesseract-data-ind" = fetch {
    pname       = "tesseract-data-ind";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ind-4.0.0-1-any.pkg.tar.xz"; sha256 = "0daa4e4b42586fd9f1d919fd94dac227f9ab9bc529515adf40f3a454b1e435fd"; }];
  };

  "tesseract-data-isl" = fetch {
    pname       = "tesseract-data-isl";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-isl-4.0.0-1-any.pkg.tar.xz"; sha256 = "3619962a8555acc33f6e6c54dcd012ca04a9514d6a1cdef6cb0fd23e3973eb1b"; }];
  };

  "tesseract-data-ita" = fetch {
    pname       = "tesseract-data-ita";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ita-4.0.0-1-any.pkg.tar.xz"; sha256 = "829eb121d96bea62d7ac6b53b1344029b65998513e14e471953f5ad81c7d07ec"; }];
  };

  "tesseract-data-ita_old" = fetch {
    pname       = "tesseract-data-ita_old";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ita_old-4.0.0-1-any.pkg.tar.xz"; sha256 = "66aa78957e8d9e41f6cc68cda3885bffe5387420af490c5e9f5670e8a055cc98"; }];
  };

  "tesseract-data-jav" = fetch {
    pname       = "tesseract-data-jav";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-jav-4.0.0-1-any.pkg.tar.xz"; sha256 = "b2daed2d663e0f05a99ba45c67e857d173383fdbac85bc55eb4ee934fbc1c234"; }];
  };

  "tesseract-data-jpn" = fetch {
    pname       = "tesseract-data-jpn";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-jpn-4.0.0-1-any.pkg.tar.xz"; sha256 = "f9c7d4230af653690014810eba0ed374cba47bb614783bd2a9f822605987838a"; }];
  };

  "tesseract-data-kan" = fetch {
    pname       = "tesseract-data-kan";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-kan-4.0.0-1-any.pkg.tar.xz"; sha256 = "78d2ddbba2f11a417d2c9f38112f8cb82a4197c5f83a1b67819fb10fb1b8a999"; }];
  };

  "tesseract-data-kat" = fetch {
    pname       = "tesseract-data-kat";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-kat-4.0.0-1-any.pkg.tar.xz"; sha256 = "2c2f98dbc18a259718f53a6b48b17acdf1e0d09e7f6ed30935aa1092955353d0"; }];
  };

  "tesseract-data-kat_old" = fetch {
    pname       = "tesseract-data-kat_old";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-kat_old-4.0.0-1-any.pkg.tar.xz"; sha256 = "d2481e91798f70ef2c693e88b742a4adfed9a2b0ab421084c4058123cdc6f2e2"; }];
  };

  "tesseract-data-kaz" = fetch {
    pname       = "tesseract-data-kaz";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-kaz-4.0.0-1-any.pkg.tar.xz"; sha256 = "4add50ca1f4e67f726d7b728b0c47677da29b55395234c623c5b7969aca3995f"; }];
  };

  "tesseract-data-khm" = fetch {
    pname       = "tesseract-data-khm";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-khm-4.0.0-1-any.pkg.tar.xz"; sha256 = "153a6a8d21d5901e29370894049f4052a520846352d00d883a9c73e375917b65"; }];
  };

  "tesseract-data-kir" = fetch {
    pname       = "tesseract-data-kir";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-kir-4.0.0-1-any.pkg.tar.xz"; sha256 = "f54662067deef20ecc7f2268e637ae40e02ed64edbdd42f6e8127bb2191b0d17"; }];
  };

  "tesseract-data-kor" = fetch {
    pname       = "tesseract-data-kor";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-kor-4.0.0-1-any.pkg.tar.xz"; sha256 = "31f57b7046e180e31ea361bb06291a42cf1e2a92adb5098d8fb067591865a2a3"; }];
  };

  "tesseract-data-lao" = fetch {
    pname       = "tesseract-data-lao";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-lao-4.0.0-1-any.pkg.tar.xz"; sha256 = "7f56dd574d45272704f2a16d7edbf629366693628c3184b73fa85a834c8c7af7"; }];
  };

  "tesseract-data-lat" = fetch {
    pname       = "tesseract-data-lat";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-lat-4.0.0-1-any.pkg.tar.xz"; sha256 = "be6bd4b53df13e4fa8e95ccff6b9ea35d75f3364a86032a51c34919c5d562201"; }];
  };

  "tesseract-data-lav" = fetch {
    pname       = "tesseract-data-lav";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-lav-4.0.0-1-any.pkg.tar.xz"; sha256 = "ef761602720a649471389131932478b26901fe947fc2b5eda3ec57c5a87ea694"; }];
  };

  "tesseract-data-lit" = fetch {
    pname       = "tesseract-data-lit";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-lit-4.0.0-1-any.pkg.tar.xz"; sha256 = "855bd376e7ed946cdc015af40023ea7b9512674b22bccf76f9296f8a5f7203e4"; }];
  };

  "tesseract-data-mal" = fetch {
    pname       = "tesseract-data-mal";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-mal-4.0.0-1-any.pkg.tar.xz"; sha256 = "821d0f1852c2dfa01ca3126e1029ebc088e416da4fcb75a9a92fbef75f9fa3ae"; }];
  };

  "tesseract-data-mar" = fetch {
    pname       = "tesseract-data-mar";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-mar-4.0.0-1-any.pkg.tar.xz"; sha256 = "2ae0e8ab59a07e4224bc3cccb11ce221cfd84809168b5dadaa982d0b00e54e10"; }];
  };

  "tesseract-data-mkd" = fetch {
    pname       = "tesseract-data-mkd";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-mkd-4.0.0-1-any.pkg.tar.xz"; sha256 = "c311b48cb4d6aa3b4e5222d0b34d40fba940f7e269522fad9fa291c950901be1"; }];
  };

  "tesseract-data-mlt" = fetch {
    pname       = "tesseract-data-mlt";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-mlt-4.0.0-1-any.pkg.tar.xz"; sha256 = "fe1fcb7777265d2797829139248135903b9983c106b609434ee8a78d7e8885a9"; }];
  };

  "tesseract-data-msa" = fetch {
    pname       = "tesseract-data-msa";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-msa-4.0.0-1-any.pkg.tar.xz"; sha256 = "5ad3beb2571f90fde9e349c07a102b0e953777d2ff9037766471716574a018a7"; }];
  };

  "tesseract-data-mya" = fetch {
    pname       = "tesseract-data-mya";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-mya-4.0.0-1-any.pkg.tar.xz"; sha256 = "6564bcaad66e38fb4f8866a15fe82202f89e60e9b8f3a00d9a7167610a75dc3e"; }];
  };

  "tesseract-data-nep" = fetch {
    pname       = "tesseract-data-nep";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-nep-4.0.0-1-any.pkg.tar.xz"; sha256 = "1d58242af3649a5097259b7a4151bc1ad60649b688fd02064ec86702e5d277bd"; }];
  };

  "tesseract-data-nld" = fetch {
    pname       = "tesseract-data-nld";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-nld-4.0.0-1-any.pkg.tar.xz"; sha256 = "6fdac05ec0e15c3930a65f59e04d19723b603a748da6ee1479e1adc79c1f6464"; }];
  };

  "tesseract-data-nor" = fetch {
    pname       = "tesseract-data-nor";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-nor-4.0.0-1-any.pkg.tar.xz"; sha256 = "22537955ac697f4334216d4711a3424dbb0e874458f906614625a059a8cf2fbc"; }];
  };

  "tesseract-data-ori" = fetch {
    pname       = "tesseract-data-ori";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ori-4.0.0-1-any.pkg.tar.xz"; sha256 = "e2321e83d6a43345f418ad4ef7ceb24cef567ccf7fc618f7a25e7101a6c169e8"; }];
  };

  "tesseract-data-pan" = fetch {
    pname       = "tesseract-data-pan";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-pan-4.0.0-1-any.pkg.tar.xz"; sha256 = "76cba403a8c2ec25f9ffd9314c89fe13caa50244d98cb0245c54292029156e3a"; }];
  };

  "tesseract-data-pol" = fetch {
    pname       = "tesseract-data-pol";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-pol-4.0.0-1-any.pkg.tar.xz"; sha256 = "1f516438c78c624f5a37f83fe911889305ed8c4df7020797b57068411315af64"; }];
  };

  "tesseract-data-por" = fetch {
    pname       = "tesseract-data-por";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-por-4.0.0-1-any.pkg.tar.xz"; sha256 = "0656b655d0ad11c5262380b7a799436527fdcb789e1661a62e45455f57414703"; }];
  };

  "tesseract-data-pus" = fetch {
    pname       = "tesseract-data-pus";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-pus-4.0.0-1-any.pkg.tar.xz"; sha256 = "ea19ff3d815ff043d0940ebcc76142f16c911c8e82e6f15a476343fa308f727c"; }];
  };

  "tesseract-data-ron" = fetch {
    pname       = "tesseract-data-ron";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ron-4.0.0-1-any.pkg.tar.xz"; sha256 = "8a531749de37c707acb875ade93c0be51436972d9c325ebd1def223946cf08fc"; }];
  };

  "tesseract-data-rus" = fetch {
    pname       = "tesseract-data-rus";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-rus-4.0.0-1-any.pkg.tar.xz"; sha256 = "a5820eaa9fc666b27c0c30a0b2980bd053f1ea9c923f8af4022dd4baac21afdd"; }];
  };

  "tesseract-data-san" = fetch {
    pname       = "tesseract-data-san";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-san-4.0.0-1-any.pkg.tar.xz"; sha256 = "9d23a02053ddc476eb5018b78249c2c06a062f11cb7e25a7fd2a51c44975c596"; }];
  };

  "tesseract-data-sin" = fetch {
    pname       = "tesseract-data-sin";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-sin-4.0.0-1-any.pkg.tar.xz"; sha256 = "92c0b77367924fe70da02d613d012be64746bf71af4ef2d61ad31133b617bf9c"; }];
  };

  "tesseract-data-slk" = fetch {
    pname       = "tesseract-data-slk";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-slk-4.0.0-1-any.pkg.tar.xz"; sha256 = "5ddbf0c901eb119f99926e6daeefa9704572683e729bdd083bf5169f934dcbdd"; }];
  };

  "tesseract-data-slv" = fetch {
    pname       = "tesseract-data-slv";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-slv-4.0.0-1-any.pkg.tar.xz"; sha256 = "28888a3a46a025b34f6e1c7c39c19cd1434b94d3253325f257bafeb1ad7d81e3"; }];
  };

  "tesseract-data-spa" = fetch {
    pname       = "tesseract-data-spa";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-spa-4.0.0-1-any.pkg.tar.xz"; sha256 = "5369750b41ba29ede8b7f17fc3d98e5dc0431a62badb03d5eb1015e16f983f56"; }];
  };

  "tesseract-data-spa_old" = fetch {
    pname       = "tesseract-data-spa_old";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-spa_old-4.0.0-1-any.pkg.tar.xz"; sha256 = "a6264c67d37fe279b26b027d3556f17a5659ecff614a10b0714c6f0318300439"; }];
  };

  "tesseract-data-sqi" = fetch {
    pname       = "tesseract-data-sqi";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-sqi-4.0.0-1-any.pkg.tar.xz"; sha256 = "fcf355b01500b11b3a9b7696bf624ff2a7309953fd5709378abcd793d2c0850b"; }];
  };

  "tesseract-data-srp" = fetch {
    pname       = "tesseract-data-srp";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-srp-4.0.0-1-any.pkg.tar.xz"; sha256 = "818d3081c0f922ddd04cf3dccaa82d28406f854bcd53d91c87465cdea003424a"; }];
  };

  "tesseract-data-srp_latn" = fetch {
    pname       = "tesseract-data-srp_latn";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-srp_latn-4.0.0-1-any.pkg.tar.xz"; sha256 = "6bab5f73791dae6b3e280db80cf47aae074b6e34fb00d897d70a3e04a43b9694"; }];
  };

  "tesseract-data-swa" = fetch {
    pname       = "tesseract-data-swa";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-swa-4.0.0-1-any.pkg.tar.xz"; sha256 = "ef6afa01eb89c6a114ef329fc0faaddcce4f835c48f6f78a6382807dc268d001"; }];
  };

  "tesseract-data-swe" = fetch {
    pname       = "tesseract-data-swe";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-swe-4.0.0-1-any.pkg.tar.xz"; sha256 = "57a71492f4950a43c6de64e95c135086de29bf1a06f711ae3d13a00a871d057c"; }];
  };

  "tesseract-data-syr" = fetch {
    pname       = "tesseract-data-syr";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-syr-4.0.0-1-any.pkg.tar.xz"; sha256 = "9da7cf41d5dca5764ef3c42d524cdc9c517d58d9c97ba107db51e53cd1360062"; }];
  };

  "tesseract-data-tam" = fetch {
    pname       = "tesseract-data-tam";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-tam-4.0.0-1-any.pkg.tar.xz"; sha256 = "142008a014ceaf0ace1bfbf7284cee4b4730483a1b2ec10dd2965adbb93555e7"; }];
  };

  "tesseract-data-tel" = fetch {
    pname       = "tesseract-data-tel";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-tel-4.0.0-1-any.pkg.tar.xz"; sha256 = "c54d84a1164b9663070dc445955111087d5271d2ebb0ba05b8a8d180052d99c8"; }];
  };

  "tesseract-data-tgk" = fetch {
    pname       = "tesseract-data-tgk";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-tgk-4.0.0-1-any.pkg.tar.xz"; sha256 = "3c21d3d672e13dc8cfad8e3f82ce7356bb94d3ad609fdfb64cffc6527e49c5ac"; }];
  };

  "tesseract-data-tha" = fetch {
    pname       = "tesseract-data-tha";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-tha-4.0.0-1-any.pkg.tar.xz"; sha256 = "6c69aae3c2cd0b7e05328079783be309520c0c860a3b7233bb13f0cec444b7a4"; }];
  };

  "tesseract-data-tir" = fetch {
    pname       = "tesseract-data-tir";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-tir-4.0.0-1-any.pkg.tar.xz"; sha256 = "e1d94615d882513227f944e6e911928791b6e97937b79262d7d9509f6f3f24ce"; }];
  };

  "tesseract-data-tur" = fetch {
    pname       = "tesseract-data-tur";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-tur-4.0.0-1-any.pkg.tar.xz"; sha256 = "108c482cec20f4b97aaf7d5bab140efc2bae614c501a6c2edcb10d74aa33cee1"; }];
  };

  "tesseract-data-uig" = fetch {
    pname       = "tesseract-data-uig";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-uig-4.0.0-1-any.pkg.tar.xz"; sha256 = "78ec61bef799f1a2f7cfc2fc831881026c7acc71d23733bd2266551346ce1ecc"; }];
  };

  "tesseract-data-ukr" = fetch {
    pname       = "tesseract-data-ukr";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-ukr-4.0.0-1-any.pkg.tar.xz"; sha256 = "e1d970a6a3f54347f2536f001472230271136d23933ada34a029fe4c74be2fc3"; }];
  };

  "tesseract-data-urd" = fetch {
    pname       = "tesseract-data-urd";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-urd-4.0.0-1-any.pkg.tar.xz"; sha256 = "c20207bfa55bd08d04588f98b5a4ea01e712889d18d8704a45d09406f99b53c9"; }];
  };

  "tesseract-data-uzb" = fetch {
    pname       = "tesseract-data-uzb";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-uzb-4.0.0-1-any.pkg.tar.xz"; sha256 = "dd8b855c1fb6ee1fe931ebed2fb5a7d25a6580485a16e5fd531dd840d9b0542b"; }];
  };

  "tesseract-data-uzb_cyrl" = fetch {
    pname       = "tesseract-data-uzb_cyrl";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-uzb_cyrl-4.0.0-1-any.pkg.tar.xz"; sha256 = "40e2609da3ea0d7eb5ddeabeeb0c9cf07dfdb0f64f241f63ce10b2c0b7516cdd"; }];
  };

  "tesseract-data-vie" = fetch {
    pname       = "tesseract-data-vie";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-vie-4.0.0-1-any.pkg.tar.xz"; sha256 = "8e16649536bb517d5be65f715fc8ac6d92f117f55282a17f2da577a7c7af32a7"; }];
  };

  "tesseract-data-yid" = fetch {
    pname       = "tesseract-data-yid";
    version     = "4.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-data-yid-4.0.0-1-any.pkg.tar.xz"; sha256 = "4b73f5db85cc873ad6b8125253531a242f1b389f887f009c03a41fbe6a0a4699"; }];
  };

  "tesseract-ocr" = fetch {
    pname       = "tesseract-ocr";
    version     = "4.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-tesseract-ocr-4.1.1-4-any.pkg.tar.zst"; sha256 = "6ceae73224c5df2864088517465d905ff92bcbd39a7d21290a457eca035068c2"; }];
    buildInputs = [ cairo curl gcc-libs icu leptonica libarchive pango zlib ];
  };

  "threadweaver-qt5" = fetch {
    pname       = "threadweaver-qt5";
    version     = "5.74.0";
    srcs        = [{ filename = "mingw-w64-x86_64-threadweaver-qt5-5.74.0-1-any.pkg.tar.zst"; sha256 = "ce3620b59401a958cbe97b81dd2fe99bbc5cf72e14e4f0907fd163f377bcf3c3"; }];
    buildInputs = [ qt5 ];
  };

  "thrift" = fetch {
    pname       = "thrift";
    version     = "0.13.0";
    srcs        = [{ filename = "mingw-w64-x86_64-thrift-0.13.0-2-any.pkg.tar.zst"; sha256 = "e56ba35e4dd0cd5036311b587b93152b83874653299d0a5a02cf9839ecd4e0ea"; }];
    buildInputs = [ gcc-libs boost openssl zlib ];
  };

  "tidy" = fetch {
    pname       = "tidy";
    version     = "5.7.16";
    srcs        = [{ filename = "mingw-w64-x86_64-tidy-5.7.16-1-any.pkg.tar.xz"; sha256 = "19171b1b978ed95361041d7dd753b447b78c0c74e9268d4ed8e5313d57a6b239"; }];
    buildInputs = [ gcc-libs ];
  };

  "tiny-dnn" = fetch {
    pname       = "tiny-dnn";
    version     = "1.0.0a3";
    srcs        = [{ filename = "mingw-w64-x86_64-tiny-dnn-1.0.0a3-2-any.pkg.tar.xz"; sha256 = "4de585a653ebf9e8524ecc804ef07108e356d229a156874f25873d9517389164"; }];
    buildInputs = [ intel-tbb protobuf ];
  };

  "tinyformat" = fetch {
    pname       = "tinyformat";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tinyformat-2.1.0-1-any.pkg.tar.xz"; sha256 = "c5606255abe68c96e3c071538787388b188916da77546b44f434bf0ff13c0025"; }];
  };

  "tinyxml" = fetch {
    pname       = "tinyxml";
    version     = "2.6.2";
    srcs        = [{ filename = "mingw-w64-x86_64-tinyxml-2.6.2-4-any.pkg.tar.xz"; sha256 = "9cccdcc54fcb4fc30e61e745c3b15c1b5696a2b80f3ffbc4d05a31a6020e9787"; }];
    buildInputs = [ gcc-libs ];
  };

  "tinyxml2" = fetch {
    pname       = "tinyxml2";
    version     = "7.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tinyxml2-7.1.0-1-any.pkg.tar.xz"; sha256 = "df4c7316f3d75dabc94f6a8c9b9408cbb993fcc8377c11a12e470ace7a766c08"; }];
    buildInputs = [ gcc-libs ];
  };

  "tk" = fetch {
    pname       = "tk";
    version     = "8.6.10";
    srcs        = [{ filename = "mingw-w64-x86_64-tk-8.6.10-2-any.pkg.tar.zst"; sha256 = "45bd458ed71f5f3c3cc5210d833b89a4d9f6b965385871239b441a3534f2ea43"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast tcl.version "8.6.10"; tcl) ];
  };

  "tkimg" = fetch {
    pname       = "tkimg";
    version     = "1.4.11";
    srcs        = [{ filename = "mingw-w64-x86_64-tkimg-1.4.11-1-any.pkg.tar.zst"; sha256 = "e02bbc012ed255ac11de1daa76f1328259d0c20630824de1d288e20ab25f06ac"; }];
    buildInputs = [ libjpeg libpng libtiff tk zlib ];
  };

  "tklib-git" = fetch {
    pname       = "tklib-git";
    version     = "r1737.65490b01";
    srcs        = [{ filename = "mingw-w64-x86_64-tklib-git-r1737.65490b01-1-any.pkg.tar.xz"; sha256 = "1b6ed52808ecf970c2d8bfdf3935a2a258ed8f322a42bfecc48f7118aee77bff"; }];
    buildInputs = [ tk tcllib ];
  };

  "tktable" = fetch {
    pname       = "tktable";
    version     = "2.10";
    srcs        = [{ filename = "mingw-w64-x86_64-tktable-2.10-4-any.pkg.tar.xz"; sha256 = "260f9646bb8c140fa39c420ffe4c3be4eab969bd7c2911d8dbfafe6472b3a690"; }];
    buildInputs = [ tk ];
  };

  "tl-expected" = fetch {
    pname       = "tl-expected";
    version     = "1.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-tl-expected-1.0.0-2-any.pkg.tar.zst"; sha256 = "b113b2613cc472e15204f50080c9a1f9891727c7e3f26f7cc67d0106b7b0ee49"; }];
  };

  "tolua" = fetch {
    pname       = "tolua";
    version     = "5.2.4";
    srcs        = [{ filename = "mingw-w64-x86_64-tolua-5.2.4-3-any.pkg.tar.xz"; sha256 = "92fa34ff0ce7c5a6245052368b688668558b50bfc796cd175161671b16ea46e6"; }];
    buildInputs = [ lua ];
  };

  "tools-git" = fetch {
    pname       = "tools-git";
    version     = "9.0.0.6029.ecb4ff54";
    srcs        = [{ filename = "mingw-w64-x86_64-tools-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "b348eb64df6097f8b7264803d1aa5d596f3d7f8555bb96e68618c29548ab8948"; }];
    buildInputs = [ gcc-libs ];
  };

  "tor" = fetch {
    pname       = "tor";
    version     = "0.4.2.7";
    srcs        = [{ filename = "mingw-w64-x86_64-tor-0.4.2.7-1-any.pkg.tar.xz"; sha256 = "42c3e3e21962bfca518edd9ae94452f72dcd922527fc90c385637ec482d6e695"; }];
    buildInputs = [ libevent openssl xz zlib zstd ];
  };

  "totem-pl-parser" = fetch {
    pname       = "totem-pl-parser";
    version     = "3.26.3";
    srcs        = [{ filename = "mingw-w64-x86_64-totem-pl-parser-3.26.3-1-any.pkg.tar.xz"; sha256 = "8f5e67fccb625abfafad6d4ef1800266bcdd92e36e0ab905aa98f2135e12e455"; }];
    buildInputs = [ glib2 gmime libsoup libarchive libgcrypt ];
  };

  "transmission" = fetch {
    pname       = "transmission";
    version     = "2.94";
    srcs        = [{ filename = "mingw-w64-x86_64-transmission-2.94-2-any.pkg.tar.xz"; sha256 = "a79d05edb25a61033871b0ae8472e27a50b00c4c8c0e4d10fddc2f8b823b49fe"; }];
    buildInputs = [ openssl libevent gtk3 curl zlib miniupnpc ];
  };

  "trompeloeil" = fetch {
    pname       = "trompeloeil";
    version     = "37";
    srcs        = [{ filename = "mingw-w64-x86_64-trompeloeil-37-1-any.pkg.tar.xz"; sha256 = "02e6e5ebaafff3f794dfe28fde86ead7fbc765a187fb4d5899018fedc9caffb5"; }];
  };

  "ttf-dejavu" = fetch {
    pname       = "ttf-dejavu";
    version     = "2.37";
    srcs        = [{ filename = "mingw-w64-x86_64-ttf-dejavu-2.37-2-any.pkg.tar.xz"; sha256 = "eec740c48985e7682a0d6f72ad294bfdb9823f246ca24ef54439150931a2953d"; }];
    buildInputs = [ fontconfig ];
  };

  "ttfautohint" = fetch {
    pname       = "ttfautohint";
    version     = "1.8.3";
    srcs        = [{ filename = "mingw-w64-x86_64-ttfautohint-1.8.3-2-any.pkg.tar.xz"; sha256 = "9769c8d653de4ddfa9d732f53caa67fe29dc64c8512b8d3b87f4c3fb96c08dc1"; }];
    buildInputs = [ freetype harfbuzz qt5 ];
  };

  "tulip" = fetch {
    pname       = "tulip";
    version     = "5.2.1";
    srcs        = [{ filename = "mingw-w64-x86_64-tulip-5.2.1-1-any.pkg.tar.xz"; sha256 = "d027fb7feca5a43aa9082b1cae2cea1e54692b799896f953cc546635431e961a"; }];
    buildInputs = [ freetype glew libpng libjpeg python3 qhull-git qt5 qtwebkit quazip yajl ];
  };

  "twolame" = fetch {
    pname       = "twolame";
    version     = "0.4.0";
    srcs        = [{ filename = "mingw-w64-x86_64-twolame-0.4.0-2-any.pkg.tar.xz"; sha256 = "8fa58cae51d6659ecf874365099ecb91d84b02bc13f728fc488a277762ce2f41"; }];
    buildInputs = [ libsndfile ];
  };

  "uasm" = fetch {
    pname       = "uasm";
    version     = "v2.50";
    srcs        = [{ filename = "mingw-w64-x86_64-uasm-v2.50-1-any.pkg.tar.xz"; sha256 = "bce3d90f3fbda129df39398d0c3100b26d22532041b509eb36261a401b25de95"; }];
    buildInputs = [ gcc ];
  };

  "uchardet" = fetch {
    pname       = "uchardet";
    version     = "0.0.7";
    srcs        = [{ filename = "mingw-w64-x86_64-uchardet-0.0.7-1-any.pkg.tar.xz"; sha256 = "86a8f0897965ff5989b6a6afd334b032becb17e4198e33d6bf9bc6996194dd3f"; }];
    buildInputs = [ gcc-libs ];
  };

  "ucl" = fetch {
    pname       = "ucl";
    version     = "1.03";
    srcs        = [{ filename = "mingw-w64-x86_64-ucl-1.03-1-any.pkg.tar.xz"; sha256 = "cc3d1b6a9586d9d4455cb806c0218fa5b81c215842b5f73dafffe6cddb6bad6b"; }];
  };

  "udis86" = fetch {
    pname       = "udis86";
    version     = "1.7.3rc1";
    srcs        = [{ filename = "mingw-w64-x86_64-udis86-1.7.3rc1-1-any.pkg.tar.xz"; sha256 = "3dc515a52c11f6158207ce221e4b87daad4e391a194502e47f98560c23de3a35"; }];
    buildInputs = [ python ];
  };

  "udunits" = fetch {
    pname       = "udunits";
    version     = "2.2.27.6";
    srcs        = [{ filename = "mingw-w64-x86_64-udunits-2.2.27.6-1-any.pkg.tar.zst"; sha256 = "3b7d245b19ec1fad3ab5bcf60737af9d8fd3992ee814e96733e6d6eadad92b69"; }];
    buildInputs = [ expat ];
  };

  "uhttpmock" = fetch {
    pname       = "uhttpmock";
    version     = "0.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-uhttpmock-0.5.1-1-any.pkg.tar.xz"; sha256 = "166ab4030ed57cabbceece4f0ee7d328d4c74e739ba18356fa753f3fddb30efc"; }];
    buildInputs = [ glib2 libsoup ];
  };

  "unbound" = fetch {
    pname       = "unbound";
    version     = "1.10.0";
    srcs        = [{ filename = "mingw-w64-x86_64-unbound-1.10.0-1-any.pkg.tar.xz"; sha256 = "7caf6893cad4264552f68512c73e8df2df8d64f263cfcdd1637e61925a9717e2"; }];
    buildInputs = [ openssl expat ldns ];
  };

  "uncrustify" = fetch {
    pname       = "uncrustify";
    version     = "0.71.0";
    srcs        = [{ filename = "mingw-w64-x86_64-uncrustify-0.71.0-1-any.pkg.tar.zst"; sha256 = "9a61ba6165fc0e051f6eec3f9b25268a43c9360f3a700a509a5c9d278f5572d8"; }];
    buildInputs = [ gcc-libs ];
  };

  "unibilium" = fetch {
    pname       = "unibilium";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-unibilium-2.1.0-1-any.pkg.tar.xz"; sha256 = "625577413c45b624579e84870895c4672ef39041c94c26c0a6e16568dc02b538"; }];
  };

  "unicode-character-database" = fetch {
    pname       = "unicode-character-database";
    version     = "13.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-unicode-character-database-13.0.0-1-any.pkg.tar.zst"; sha256 = "a1ec68b76208a11ad0c6e5a4760ad4a8ce915162dc8771199495b3f509bb19ae"; }];
  };

  "unicorn" = fetch {
    pname       = "unicorn";
    version     = "1.0.2rc1";
    srcs        = [{ filename = "mingw-w64-x86_64-unicorn-1.0.2rc1-1-any.pkg.tar.xz"; sha256 = "650d968803360f55efaef0d0d1e3f117eaa9bf4479bc5e6342a95b673c77de3d"; }];
    buildInputs = [ gcc-libs ];
  };

  "universal-ctags-git" = fetch {
    pname       = "universal-ctags-git";
    version     = "r7253.7492b90e";
    srcs        = [{ filename = "mingw-w64-x86_64-universal-ctags-git-r7253.7492b90e-1-any.pkg.tar.xz"; sha256 = "f012977c03c6cfcc881bc339310eb18bf517645d5e20ad28dc0dd92a96a97f07"; }];
    buildInputs = [ gcc-libs jansson libiconv libxml2 libyaml ];
  };

  "unixodbc" = fetch {
    pname       = "unixodbc";
    version     = "2.3.7";
    srcs        = [{ filename = "mingw-w64-x86_64-unixodbc-2.3.7-2-any.pkg.tar.xz"; sha256 = "7fd268dae01f58bda0968bf5a2bae684387b8d106550ca327cff3e472f90842a"; }];
    buildInputs = [ gcc-libs readline libtool ];
  };

  "uriparser" = fetch {
    pname       = "uriparser";
    version     = "0.9.4";
    srcs        = [{ filename = "mingw-w64-x86_64-uriparser-0.9.4-1-any.pkg.tar.zst"; sha256 = "17a4bba2804a31351aa6e201b06b8c9d87ff5f036645e0ba0b9ad9e26a19a822"; }];
    buildInputs = [  ];
  };

  "usbredir" = fetch {
    pname       = "usbredir";
    version     = "0.8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-usbredir-0.8.0-1-any.pkg.tar.xz"; sha256 = "dd23930badbee6f52ed37127aaa7380b3952ac8880db2e876faf94803a65d849"; }];
    buildInputs = [ libusb ];
  };

  "usbview-git" = fetch {
    pname       = "usbview-git";
    version     = "42.c4ba9c6";
    srcs        = [{ filename = "mingw-w64-x86_64-usbview-git-42.c4ba9c6-1-any.pkg.tar.xz"; sha256 = "3a2cf1fd62d1ce5d722e90dc1e7a9bb9bd45df5c903d41aba5fead52ca384485"; }];
  };

  "usql" = fetch {
    pname       = "usql";
    version     = "0.8.1";
    srcs        = [{ filename = "mingw-w64-x86_64-usql-0.8.1-1-any.pkg.tar.xz"; sha256 = "3c391d007de340ae16d34104465ce79348f5ccf9c3c953bdc8402b88f1acce71"; }];
    buildInputs = [ antlr3 ];
  };

  "usrsctp" = fetch {
    pname       = "usrsctp";
    version     = "0.9.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-usrsctp-0.9.3.0-1-any.pkg.tar.xz"; sha256 = "202ea32ecefa0de97b13a50d2c7a20aa8f1dca6c5da410c759ec615087572bae"; }];
  };

  "v8" = fetch {
    pname       = "v8";
    version     = "8.5.210.20";
    srcs        = [{ filename = "mingw-w64-x86_64-v8-8.5.210.20-3-any.pkg.tar.zst"; sha256 = "a7cd9a16a9beefdea83a47738d93f05d40691b318b6b695af04a052deef2fdec"; }];
    buildInputs = [ zlib icu ];
  };

  "vala" = fetch {
    pname       = "vala";
    version     = "0.50.1";
    srcs        = [{ filename = "mingw-w64-x86_64-vala-0.50.1-1-any.pkg.tar.zst"; sha256 = "81a53026d4c48b5924066a967df1b75e23bea1c5b4a8322c7d079d3d21f44494"; }];
    buildInputs = [ glib2 graphviz ];
  };

  "vamp-plugin-sdk" = fetch {
    pname       = "vamp-plugin-sdk";
    version     = "2.9.0";
    srcs        = [{ filename = "mingw-w64-x86_64-vamp-plugin-sdk-2.9.0-1-any.pkg.tar.xz"; sha256 = "b91aa5145930df40e1892ae3c9f4684fbe59ef3a30534d6aaafadc93992adbee"; }];
    buildInputs = [ gcc-libs libsndfile ];
  };

  "vapoursynth" = fetch {
    pname       = "vapoursynth";
    version     = "49";
    srcs        = [{ filename = "mingw-w64-x86_64-vapoursynth-49-1-any.pkg.tar.xz"; sha256 = "e7bf23fa92a41a3deabb08ddf689e47df53546b46a67b60a4b7644582f915414"; }];
    buildInputs = [ gcc-libs cython ffmpeg imagemagick libass libxml2 python tesseract-ocr zimg ];
  };

  "vcdimager" = fetch {
    pname       = "vcdimager";
    version     = "2.0.1";
    srcs        = [{ filename = "mingw-w64-x86_64-vcdimager-2.0.1-2-any.pkg.tar.zst"; sha256 = "ca2276772b62d6a7c40c1876874256e5420329f4981964d1705a5de5c9dc92d6"; }];
    buildInputs = [ libcdio libxml2 popt ];
  };

  "vera++" = fetch {
    pname       = "vera++";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-vera++-1.3.0-2-any.pkg.tar.xz"; sha256 = "0bd04394b8ee78b3017b6105d43730fb0435b57b76461c5973a9f72c51bf4fd5"; }];
    buildInputs = [ tcl boost python2 ];
  };

  "verilator" = fetch {
    pname       = "verilator";
    version     = "4.032";
    srcs        = [{ filename = "mingw-w64-x86_64-verilator-4.032-1-any.pkg.tar.xz"; sha256 = "7e54a22e7dba9500a1317d6938367b8a91e0bb9d107ef230a1d6ac77bd175140"; }];
    buildInputs = [ gcc-libs ];
  };

  "vid.stab" = fetch {
    pname       = "vid.stab";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-vid.stab-1.1-1-any.pkg.tar.xz"; sha256 = "1e40a20eb9455a1a57609e8554ce1c662a6523fd715471744f2396c179a7e6d2"; }];
  };

  "vigra" = fetch {
    pname       = "vigra";
    version     = "1.11.1";
    srcs        = [{ filename = "mingw-w64-x86_64-vigra-1.11.1-4-any.pkg.tar.zst"; sha256 = "39b5d26369bec0d7a31c8ce149b3d63395e5d1c04e186bf870e9a5b9a3828d74"; }];
    buildInputs = [ gcc-libs boost fftw hdf5 libjpeg-turbo libpng libtiff openexr python-numpy zlib ];
  };

  "virt-viewer" = fetch {
    pname       = "virt-viewer";
    version     = "8.0";
    srcs        = [{ filename = "mingw-w64-x86_64-virt-viewer-8.0-1-any.pkg.tar.xz"; sha256 = "ea15418ea1d012fc6cde1ecfa969b5632686f5268ae1e64ef2b3a66e000d076b"; }];
    buildInputs = [ spice-gtk gtk-vnc libvirt libxml2 opus ];
    broken      = true; # broken dependency gst-plugins-base -> libvorbisidec
  };

  "vlc" = fetch {
    pname       = "vlc";
    version     = "3.0.10";
    srcs        = [{ filename = "mingw-w64-x86_64-vlc-3.0.10-1-any.pkg.tar.zst"; sha256 = "47e9b4bd2715eb5db55a32928a0b319dcd77242ae4521a6c00bfb3cf1f0a09df"; }];
    buildInputs = [ a52dec aom aribb24 chromaprint dav1d faad2 freetype ffmpeg flac fluidsynth fontconfig fribidi gnutls gsm harfbuzz libarchive libass libbluray libcaca libcddb libcdio libdca libdsm libdvdcss libdvdnav libdvbpsi libgcrypt libgme libgoom2 libidn libmad libmatroska libmfx libmicrodns libmodplug libmpcdec libmpeg2-git libmysofa libogg libnfs libpng libnotify libplacebo libproxy librsvg libsamplerate libsecret libshout libsoxr libssh2 libtheora libvncserver libvorbis libvpx libxml2 lua51 minizip-git opus portaudio protobuf pupnp schroedinger speex srt taglib twolame vcdimager x264-git x265 xpm-nox qt5 SDL_image zlib ];
  };

  "vlfeat" = fetch {
    pname       = "vlfeat";
    version     = "0.9.21";
    srcs        = [{ filename = "mingw-w64-x86_64-vlfeat-0.9.21-1-any.pkg.tar.xz"; sha256 = "8792f5b924afdfa47051d0ec78fc94d93edface234b9dc1abb810b6c94de5c92"; }];
    buildInputs = [ gcc-libs ];
  };

  "vo-amrwbenc" = fetch {
    pname       = "vo-amrwbenc";
    version     = "0.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-vo-amrwbenc-0.1.3-1-any.pkg.tar.xz"; sha256 = "0612bd794776995c03a9d8a52b672ab0839919beb718f79272376c64db11b0a1"; }];
    buildInputs = [  ];
  };

  "vrpn" = fetch {
    pname       = "vrpn";
    version     = "7.34";
    srcs        = [{ filename = "mingw-w64-x86_64-vrpn-7.34-5-any.pkg.tar.xz"; sha256 = "daf45e1ba916b7cc03603d49c1550707ad6396f5e197391968c3061a1d7efa94"; }];
    buildInputs = [ hidapi jsoncpp libusb python swig ];
  };

  "vtk" = fetch {
    pname       = "vtk";
    version     = "8.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-vtk-8.2.0-4-any.pkg.tar.zst"; sha256 = "3c8769c90cd7dc808425ca3163f09074cdd75e726ebadaca665fe6efee44325e"; }];
    buildInputs = [ gcc-libs double-conversion expat ffmpeg fontconfig freetype gdal hdf5 intel-tbb jsoncpp libjpeg libharu libpng libogg libtheora libtiff libxml2 lz4 pugixml qt5 zlib ];
  };

  "vulkan-headers" = fetch {
    pname       = "vulkan-headers";
    version     = "1.2.148";
    srcs        = [{ filename = "mingw-w64-x86_64-vulkan-headers-1.2.148-1-any.pkg.tar.zst"; sha256 = "7fe76556a04e821e2e6bdac07b2a75d1e49735fd5f14e8546dbc0689d6bfbe87"; }];
    buildInputs = [ gcc-libs ];
  };

  "vulkan-loader" = fetch {
    pname       = "vulkan-loader";
    version     = "1.2.148";
    srcs        = [{ filename = "mingw-w64-x86_64-vulkan-loader-1.2.148-1-any.pkg.tar.zst"; sha256 = "1145bb55f40d82bb49895ab5b92fcd8d4e4cdc2bdc2868b3c46cd62cf27b4d86"; }];
    buildInputs = [ vulkan-headers ];
  };

  "vulkan-validation-layers" = fetch {
    pname       = "vulkan-validation-layers";
    version     = "1.2.148";
    srcs        = [{ filename = "mingw-w64-x86_64-vulkan-validation-layers-1.2.148-2-any.pkg.tar.zst"; sha256 = "1c7d06b74e5f076528b464729371b810b17a4aa9bcd798df7501241f15084888"; }];
    buildInputs = [ gcc-libs vulkan-loader ];
  };

  "w3c-mathml2" = fetch {
    pname       = "w3c-mathml2";
    version     = "2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-w3c-mathml2-2.0-1-any.pkg.tar.xz"; sha256 = "4c0e2594d11aa3ed34832a4b35cb0267401acec053129c617c1cea8cb960df09"; }];
    buildInputs = [ libxml2 ];
  };

  "waf" = fetch {
    pname       = "waf";
    version     = "2.0.20";
    srcs        = [{ filename = "mingw-w64-x86_64-waf-2.0.20-1-any.pkg.tar.xz"; sha256 = "b068dceeb3d8918a220b9f36f868903020a606ce9e8922e911f26d1485ce0bbc"; }];
    buildInputs = [ python ];
  };

  "wavpack" = fetch {
    pname       = "wavpack";
    version     = "5.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-wavpack-5.3.0-1-any.pkg.tar.zst"; sha256 = "de82aa291a20b309391e4d2fea0e9615137e6087bbb95ddeaabb5c082bf810b4"; }];
    buildInputs = [ gcc-libs ];
  };

  "wget" = fetch {
    pname       = "wget";
    version     = "1.20.3";
    srcs        = [{ filename = "mingw-w64-x86_64-wget-1.20.3-2-any.pkg.tar.xz"; sha256 = "940a47f05a570e52ed4c2ae772fc712e65c54b225a71742bdc8927b46b53af66"; }];
    buildInputs = [ pcre2 libidn2 openssl c-ares gpgme ];
  };

  "win7appid" = fetch {
    pname       = "win7appid";
    version     = "1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-win7appid-1.1-3-any.pkg.tar.xz"; sha256 = "fefb963985cd14313a0a10738e9aef24a41886d3163317a89c0104ba2a920d67"; }];
  };

  "windows-default-manifest" = fetch {
    pname       = "windows-default-manifest";
    version     = "6.4";
    srcs        = [{ filename = "mingw-w64-x86_64-windows-default-manifest-6.4-3-any.pkg.tar.xz"; sha256 = "6c0ea4adcef503dc8174e9d4d70a10aee8295d620db4494f78fa512df0589dcf"; }];
    buildInputs = [  ];
  };

  "wined3d" = fetch {
    pname       = "wined3d";
    version     = "3.8";
    srcs        = [{ filename = "mingw-w64-x86_64-wined3d-3.8-1-any.pkg.tar.xz"; sha256 = "60957b41661bafadcc969fb44646330c779d97be1a9ca008e6a8bd4b8fedeb15"; }];
  };

  "wineditline" = fetch {
    pname       = "wineditline";
    version     = "2.205";
    srcs        = [{ filename = "mingw-w64-x86_64-wineditline-2.205-3-any.pkg.tar.xz"; sha256 = "b541842fbd89a0a852b1c6758842a2255dd709458df02d5d7552a6d58dc33ee2"; }];
    buildInputs = [  ];
  };

  "winico" = fetch {
    pname       = "winico";
    version     = "0.6";
    srcs        = [{ filename = "mingw-w64-x86_64-winico-0.6-2-any.pkg.tar.xz"; sha256 = "15e535d926200768ee8d0854e1775de0404beb4167434394bc7cb1e2b89e32bf"; }];
    buildInputs = [ tk ];
  };

  "winpthreads-git" = fetch {
    pname       = "winpthreads-git";
    version     = "9.0.0.6029.ecb4ff54";
    srcs        = [{ filename = "mingw-w64-x86_64-winpthreads-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "d49182f10e0a91635a1f1f516a301df659f85159cb46da259db1d5c1dda60d6a"; }];
    buildInputs = [ crt-git (assert libwinpthread-git.version=="9.0.0.6029.ecb4ff54"; libwinpthread-git) ];
  };

  "winsparkle" = fetch {
    pname       = "winsparkle";
    version     = "0.6.0";
    srcs        = [{ filename = "mingw-w64-x86_64-winsparkle-0.6.0-1-any.pkg.tar.xz"; sha256 = "753000e6048f0423530a5b4ad9e2f955235ac9bd4382a65045de1321e1ed9e53"; }];
    buildInputs = [ expat openssl wxWidgets ];
  };

  "winstorecompat-git" = fetch {
    pname       = "winstorecompat-git";
    version     = "9.0.0.6029.ecb4ff54";
    srcs        = [{ filename = "mingw-w64-x86_64-winstorecompat-git-9.0.0.6029.ecb4ff54-1-any.pkg.tar.zst"; sha256 = "d0b8f4116f982f842e1a6666b6377e10c42170cb42881e4056855994d1367484"; }];
  };

  "wintab-sdk" = fetch {
    pname       = "wintab-sdk";
    version     = "1.4";
    srcs        = [{ filename = "mingw-w64-x86_64-wintab-sdk-1.4-2-any.pkg.tar.xz"; sha256 = "50aa58fbfad39f678eda44414147b2b2b62c2bb472147aae52ce3a5a7bec9662"; }];
  };

  "wkhtmltopdf-git" = fetch {
    pname       = "wkhtmltopdf-git";
    version     = "0.13.r1049.51f9658";
    srcs        = [{ filename = "mingw-w64-x86_64-wkhtmltopdf-git-0.13.r1049.51f9658-1-any.pkg.tar.xz"; sha256 = "fb77d9494d5776ad15c8c008a305fa999c582030a99203acfc6b4e7059cf3ffb"; }];
    buildInputs = [ qt5 qtwebkit ];
  };

  "woff2" = fetch {
    pname       = "woff2";
    version     = "1.0.2";
    srcs        = [{ filename = "mingw-w64-x86_64-woff2-1.0.2-2-any.pkg.tar.xz"; sha256 = "84cafdefcb9220f13cf3118b1cd4a21cfd1d06dcbfd0524edc43ce6deba93255"; }];
    buildInputs = [ gcc-libs brotli ];
  };

  "wslay" = fetch {
    pname       = "wslay";
    version     = "1.1.1";
    srcs        = [{ filename = "mingw-w64-x86_64-wslay-1.1.1-1-any.pkg.tar.zst"; sha256 = "27b658e521f1b20c01de9dca4653dadd255626089453d4503282840d870c2885"; }];
    buildInputs = [ gcc-libs ];
  };

  "wxPython" = fetch {
    pname       = "wxPython";
    version     = "3.0.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-wxPython-3.0.2.0-10-any.pkg.tar.zst"; sha256 = "ff6611554d8c5830922f211ec43c7d2af30d4481e71acb1fff656816b4b90237"; }];
    buildInputs = [ python2 wxWidgets ];
  };

  "wxWidgets" = fetch {
    pname       = "wxWidgets";
    version     = "3.0.5.1";
    srcs        = [{ filename = "mingw-w64-x86_64-wxWidgets-3.0.5.1-1-any.pkg.tar.zst"; sha256 = "630766f05bd67729a9886ffddfc36967d097d610f4832fc44ccca2a3443924a2"; }];
    buildInputs = [ gcc-libs expat libjpeg-turbo libpng libtiff xz zlib ];
  };

  "wxmsw3.1" = fetch {
    pname       = "wxmsw3.1";
    version     = "3.1.3";
    srcs        = [{ filename = "mingw-w64-x86_64-wxmsw3.1-3.1.3-1-any.pkg.tar.zst"; sha256 = "8ce1d0558aa273ea38e4996a61502260ca5bf80355d78235e7cf343563c82077"; }];
    buildInputs = [ gcc-libs expat libjpeg-turbo libpng libtiff xz zlib ];
  };

  "wxsvg" = fetch {
    pname       = "wxsvg";
    version     = "1.5.22";
    srcs        = [{ filename = "mingw-w64-x86_64-wxsvg-1.5.22-1-any.pkg.tar.xz"; sha256 = "9269d4aeccd9ceac8b4ae24fec96d49f700b15746652132f42021eeafd292bcc"; }];
    buildInputs = [ wxWidgets cairo pango expat libexif ffmpeg ];
  };

  "x264-git" = fetch {
    pname       = "x264-git";
    version     = "r2991.1771b556";
    srcs        = [{ filename = "mingw-w64-x86_64-x264-git-r2991.1771b556-1-any.pkg.tar.xz"; sha256 = "3208af63a3ccdda9f6ea980a834e5908875593b727f001d261a70aff6dd58287"; }];
    buildInputs = [ libwinpthread-git l-smash ffms2 ];
  };

  "x265" = fetch {
    pname       = "x265";
    version     = "3.4";
    srcs        = [{ filename = "mingw-w64-x86_64-x265-3.4-1-any.pkg.tar.zst"; sha256 = "a6e156bcbb211715893871fb7612577d62291404bb27bf51b5ccb87cb5abe663"; }];
    buildInputs = [ gcc-libs ];
  };

  "xalan-c" = fetch {
    pname       = "xalan-c";
    version     = "1.11";
    srcs        = [{ filename = "mingw-w64-x86_64-xalan-c-1.11-7-any.pkg.tar.xz"; sha256 = "41370fc9f81f9f692cc70e3f203e2fe6737f315ff0990e64fc6b77e61f6bf359"; }];
    buildInputs = [ gcc-libs xerces-c ];
  };

  "xapian-core" = fetch {
    pname       = "xapian-core";
    version     = "1~1.4.16";
    srcs        = [{ filename = "mingw-w64-x86_64-xapian-core-1~1.4.16-1-any.pkg.tar.zst"; sha256 = "e1fc1b715ab5fd309740188b2e28a08ff6508ad9c8279b3f7abdc236d35aeb62"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "xavs" = fetch {
    pname       = "xavs";
    version     = "0.1.55";
    srcs        = [{ filename = "mingw-w64-x86_64-xavs-0.1.55-1-any.pkg.tar.xz"; sha256 = "90eaf1ce843fb1c93f04e0ac90ef8a5e4dc7f9f5106ae19941245884d3055624"; }];
    buildInputs = [ gcc-libs ];
  };

  "xerces-c" = fetch {
    pname       = "xerces-c";
    version     = "3.2.3";
    srcs        = [{ filename = "mingw-w64-x86_64-xerces-c-3.2.3-2-any.pkg.tar.zst"; sha256 = "9ac6d136136f4ae3958b3bf5062fc72e2ef7b4f100bfb613e3f92d4f3dd5c86e"; }];
    buildInputs = [ gcc-libs icu ];
  };

  "xlnt" = fetch {
    pname       = "xlnt";
    version     = "1.5.0";
    srcs        = [{ filename = "mingw-w64-x86_64-xlnt-1.5.0-1-any.pkg.tar.xz"; sha256 = "589c5875d5f8d97477aaee07c52ff14ac4eb0331c739e4a18bc5305c8ed8aa77"; }];
    buildInputs = [ gcc-libs ];
  };

  "xmake" = fetch {
    pname       = "xmake";
    version     = "2.3.8";
    srcs        = [{ filename = "mingw-w64-x86_64-xmake-2.3.8-1-any.pkg.tar.zst"; sha256 = "9413110b7319258b5f7214f9d76d41f4c42161123615a8cca4b5da390777f000"; }];
    buildInputs = [ ncurses readline ];
  };

  "xmlada" = fetch {
    pname       = "xmlada";
    version     = "2021.0.0";
    srcs        = [{ filename = "mingw-w64-x86_64-xmlada-2021.0.0-1-any.pkg.tar.zst"; sha256 = "afb07f2ac395d4e7d30cf319d0e82636db1380752f10b86fbe43c158b9807bae"; }];
    buildInputs = [  ];
  };

  "xmlsec" = fetch {
    pname       = "xmlsec";
    version     = "1.2.30";
    srcs        = [{ filename = "mingw-w64-x86_64-xmlsec-1.2.30-1-any.pkg.tar.xz"; sha256 = "5ff2fc6dbdd750ac81150f2f53e969ea27ff7e4750ea456b1b1941897b5df881"; }];
    buildInputs = [ libxml2 libxslt openssl gnutls nss libtool ];
  };

  "xmlstarlet-git" = fetch {
    pname       = "xmlstarlet-git";
    version     = "r678.9a470e3";
    srcs        = [{ filename = "mingw-w64-x86_64-xmlstarlet-git-r678.9a470e3-2-any.pkg.tar.xz"; sha256 = "8dac059344173fd5a5d5564b699ebb013ea504501f997d570dacbfc01dd2575c"; }];
    buildInputs = [ libxml2 libxslt ];
  };

  "xpdf" = fetch {
    pname       = "xpdf";
    version     = "4.02";
    srcs        = [{ filename = "mingw-w64-x86_64-xpdf-4.02-1-any.pkg.tar.xz"; sha256 = "c200b0fe07cb1f02e260f32809816577e68e0654c9421326c0527ee73480b12f"; }];
    buildInputs = [ freetype libjpeg-turbo libpaper libpng libtiff qt5 zlib ];
  };

  "xpm-nox" = fetch {
    pname       = "xpm-nox";
    version     = "4.2.0";
    srcs        = [{ filename = "mingw-w64-x86_64-xpm-nox-4.2.0-5-any.pkg.tar.xz"; sha256 = "d8044ceaa86de8039b04308544ce2746221a952ceedcad16f923206939e574a6"; }];
    buildInputs = [ gcc-libs ];
  };

  "xvidcore" = fetch {
    pname       = "xvidcore";
    version     = "1.3.7";
    srcs        = [{ filename = "mingw-w64-x86_64-xvidcore-1.3.7-1-any.pkg.tar.xz"; sha256 = "3dce87e6c45a0635951f8ae0cfcbe2f5be3ba01a3c8d960ef3554efc2326fb07"; }];
    buildInputs = [  ];
  };

  "xxhash" = fetch {
    pname       = "xxhash";
    version     = "0.7.4";
    srcs        = [{ filename = "mingw-w64-x86_64-xxhash-0.7.4-1-any.pkg.tar.zst"; sha256 = "084df1c46b2aa308e019a0f4d06299d7a525cdbb794d7ec46b7f0fc459c65bc3"; }];
    buildInputs = [  ];
  };

  "xz" = fetch {
    pname       = "xz";
    version     = "5.2.5";
    srcs        = [{ filename = "mingw-w64-x86_64-xz-5.2.5-1-any.pkg.tar.xz"; sha256 = "4f9e3dba11c56cf3f3406117c792c6899013984c330ce8d21f33678bfcc50726"; }];
    buildInputs = [ gcc-libs gettext ];
  };

  "yajl" = fetch {
    pname       = "yajl";
    version     = "2.1.0";
    srcs        = [{ filename = "mingw-w64-x86_64-yajl-2.1.0-1-any.pkg.tar.xz"; sha256 = "81a71d89fd7c31b0949adfeb173f37144350874a2b48e25a2b99b6158e364109"; }];
    buildInputs = [  ];
  };

  "yaml-cpp" = fetch {
    pname       = "yaml-cpp";
    version     = "0.6.3";
    srcs        = [{ filename = "mingw-w64-x86_64-yaml-cpp-0.6.3-3-any.pkg.tar.xz"; sha256 = "0bc34368ba76568300623a0f5bc929eb40a3a5da5ccd20c036319d6bf8ca09b4"; }];
    buildInputs = [  ];
  };

  "yaml-cpp0.3" = fetch {
    pname       = "yaml-cpp0.3";
    version     = "0.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-yaml-cpp0.3-0.3.0-2-any.pkg.tar.xz"; sha256 = "334266e7861d5745cc3e637bee82c57555668a6ddc0d8292d108e165ddc581cb"; }];
  };

  "yasm" = fetch {
    pname       = "yasm";
    version     = "1.3.0";
    srcs        = [{ filename = "mingw-w64-x86_64-yasm-1.3.0-4-any.pkg.tar.xz"; sha256 = "fa90ba7ae157b0e8e8057fae38e557ca2de6f4b001deda49957d3e1a054bbd87"; }];
    buildInputs = [ gettext ];
  };

  "yelp-tools" = fetch {
    pname       = "yelp-tools";
    version     = "3.38.0";
    srcs        = [{ filename = "mingw-w64-x86_64-yelp-tools-3.38.0-1-any.pkg.tar.zst"; sha256 = "35bef14c53d5a7b1c455ca16de51739be66108948a9e1d653e8c44e006ee1f47"; }];
    buildInputs = [ intltool libxml2 libxslt itstool python3-mallard-ducktype yelp-xsl ];
    broken      = true; # broken dependency yelp-tools -> intltool
  };

  "yelp-xsl" = fetch {
    pname       = "yelp-xsl";
    version     = "3.38.1";
    srcs        = [{ filename = "mingw-w64-x86_64-yelp-xsl-3.38.1-1-any.pkg.tar.zst"; sha256 = "64d302bb0bbfaa78f6e113c7f7495091c9c9b2e82a1232e22f5272a57a047a73"; }];
  };

  "yices" = fetch {
    pname       = "yices";
    version     = "2.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-yices-2.6.1-1-any.pkg.tar.zst"; sha256 = "a8f4115a8d1e180345419f0e266e2bce30624b1b76c6624d7b1c1ba4afe5589d"; }];
    buildInputs = [ gmp ];
  };

  "z3" = fetch {
    pname       = "z3";
    version     = "4.8.9";
    srcs        = [{ filename = "mingw-w64-x86_64-z3-4.8.9-1-any.pkg.tar.zst"; sha256 = "09105092e5862eef34f1f0baac731c94f6c630f79795cab736c2faec6a9ec890"; }];
    buildInputs = [  ];
  };

  "zbar" = fetch {
    pname       = "zbar";
    version     = "0.23.1";
    srcs        = [{ filename = "mingw-w64-x86_64-zbar-0.23.1-2-any.pkg.tar.zst"; sha256 = "2a57c6b9d2444a8a0b2d92a0b9912904198a20ff7dc294cf56af2f4636821416"; }];
    buildInputs = [ imagemagick ];
  };

  "zeal" = fetch {
    pname       = "zeal";
    version     = "0.6.1";
    srcs        = [{ filename = "mingw-w64-x86_64-zeal-0.6.1-2-any.pkg.tar.zst"; sha256 = "a11b8ac36bd128f8e4760a840a21c59e9f7a99c497854ace184f2b99c0284492"; }];
    buildInputs = [ libarchive qt5 qtwebkit ];
  };

  "zeromq" = fetch {
    pname       = "zeromq";
    version     = "4.3.3";
    srcs        = [{ filename = "mingw-w64-x86_64-zeromq-4.3.3-1-any.pkg.tar.zst"; sha256 = "77830b01dd71096dc64867dd94d1febdc0c8c21bc8ba97f7bae1f01c4607242b"; }];
    buildInputs = [ libsodium ];
  };

  "zimg" = fetch {
    pname       = "zimg";
    version     = "2.9.3";
    srcs        = [{ filename = "mingw-w64-x86_64-zimg-2.9.3-1-any.pkg.tar.xz"; sha256 = "e0a94c28646a42410bbb26147a5dab3dc0af53e7ec02aab89f5d546dd11c24cb"; }];
    buildInputs = [ gcc-libs winpthreads-git ];
  };

  "zlib" = fetch {
    pname       = "zlib";
    version     = "1.2.11";
    srcs        = [{ filename = "mingw-w64-x86_64-zlib-1.2.11-7-any.pkg.tar.xz"; sha256 = "1decf05b8ae6ab10ddc9035929014837c18dd76da825329023da835aec53cec2"; }];
    buildInputs = [  ];
  };

  "zopfli" = fetch {
    pname       = "zopfli";
    version     = "1.0.3";
    srcs        = [{ filename = "mingw-w64-x86_64-zopfli-1.0.3-1-any.pkg.tar.xz"; sha256 = "704c61780d295f25c725f204aceecde2594a5674ad3989ed15ebb4d5a277b0f6"; }];
    buildInputs = [ gcc-libs ];
  };

  "zstd" = fetch {
    pname       = "zstd";
    version     = "1.4.5";
    srcs        = [{ filename = "mingw-w64-x86_64-zstd-1.4.5-1-any.pkg.tar.zst"; sha256 = "d0bb48e9d3d1eac09fc9afceec278a0ef4c67f43fa840d58b88aee55a5faddc9"; }];
    buildInputs = [  ];
  };

  "zziplib" = fetch {
    pname       = "zziplib";
    version     = "0.13.71";
    srcs        = [{ filename = "mingw-w64-x86_64-zziplib-0.13.71-1-any.pkg.tar.zst"; sha256 = "e331726b41e388c5eb083788fde2207755303ccd5a789734d5105a5d3483934d"; }];
    buildInputs = [ zlib ];
  };

  "freetype-and-harfbuzz" = fetch {
    pname       = "freetype-and-harfbuzz";
    version     = "2.10.3-1+2.7.2-1";
    srcs        = [{ filename = "mingw-w64-x86_64-freetype-2.10.3-1-any.pkg.tar.zst"; sha256 = "c3b510bc914a4b043b255010bbee6da86a917b28cb9590f1b337b2c8d25a62e3"; }
                   { filename = "mingw-w64-x86_64-harfbuzz-2.7.2-1-any.pkg.tar.zst"; sha256 = "452add4c0589857463796fd664f870df979d9e5b9f7cae6ee227fabeb404f107"; }];
    buildInputs = [ gcc-libs brotli bzip2 libpng zlib gcc-libs glib2 graphite2 ];
  };

}; in self
