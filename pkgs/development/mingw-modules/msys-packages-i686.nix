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
                      url = "http://repo.msys2.org/msys/i686/${filename}";
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
                    url = "http://repo.msys2.org/msys/i686/${filename}";
                    inherit sha256;
                  }) srcs;
      sourceRoot = ".";
      buildPhase = if stdenvNoCC.isShellPerl /* on native windows */ then
        ''
          dircopy('.', $ENV{out}) or die "dircopy(., $ENV{out}): $!";
          ${ stdenvNoCC.lib.concatMapStringsSep "\n" (dep:
                ''symtree_link($ENV{out}, '${dep}', $ENV{out});''
              ) buildInputs }
          chdir($ENV{out});
          ${ stdenvNoCC.lib.optionalString (!(true && builtins.elem pname ["msys2-runtime" "bash" "coreutils" "gmp" "libiconv" "gcc-libs" "libintl"])) ''
                if (-f ".INSTALL") {
                  $ENV{PATH} = '${msysPackages.bash}/usr/bin;${msysPackages.coreutils}/usr/bin';
                  system("bash -c \"ls -l ; . .INSTALL ; post_install\"") == 0 or die;
                }
              '' }
          unlinkL ".BUILDINFO";
          unlinkL ".INSTALL";
          unlinkL ".MTREE";
          unlinkL ".PKGINFO";

          # make symlinks in /bin, mingw does not need it, it is only for nixpkgs convenience, to have the executables in $derivation/bin
          symtree_reify($ENV{out}, "bin/_");
          for my $file (glob("$ENV{out}/mingw32/bin/*.exe"),
                         glob("$ENV{out}/mingw32/bin/*.dll"),
                         glob("$ENV{out}/usr/bin/*.exe"),
                         glob("$ENV{out}/usr/bin/*.dll")) {
            if (!testL('l', $file)) { # symlinks are likely already in bin/ after symtree_link()
              symlinkL($file => "$ENV{out}/bin/".basename($file)) or die $!;
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
  sh = bash;
  awk = gawk;
  python3 = mingwPackages.python3;

  "apr" = fetch {
    pname       = "apr";
    version     = "1.6.5";
    srcs        = [{ filename = "apr-1.6.5-1-i686.pkg.tar.xz"; sha256 = "831074598480e8c74fac442c84603978caa8f51f89966cee1989ee7a5488d79e"; }];
    buildInputs = [ libcrypt libuuid ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "apr-devel" = fetch {
    pname       = "apr-devel";
    version     = "1.6.5";
    srcs        = [{ filename = "apr-devel-1.6.5-1-i686.pkg.tar.xz"; sha256 = "cbb952dd74ec455318bd8319c74f5c464cc20cf096bd1a139c8fe36301e94c7a"; }];
    buildInputs = [ (assert apr.version=="1.6.5"; apr) libcrypt-devel libuuid-devel ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "apr-util" = fetch {
    pname       = "apr-util";
    version     = "1.6.1";
    srcs        = [{ filename = "apr-util-1.6.1-1-i686.pkg.tar.xz"; sha256 = "ae99ef5e974c770e216f4929ab1dc43ea5e0a91a63e89b210ec18cb88fe8a2be"; }];
    buildInputs = [ apr expat libsqlite ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "apr-util-devel" = fetch {
    pname       = "apr-util-devel";
    version     = "1.6.1";
    srcs        = [{ filename = "apr-util-devel-1.6.1-1-i686.pkg.tar.xz"; sha256 = "aed824044641ddd9c104ecec93f7d58881de0665a8227b1ecf9f33f59e99eefe"; }];
    buildInputs = [ (assert apr-util.version=="1.6.1"; apr-util) apr-devel libexpat-devel libsqlite-devel ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "asciidoc" = fetch {
    pname       = "asciidoc";
    version     = "8.6.10";
    srcs        = [{ filename = "asciidoc-8.6.10-1-any.pkg.tar.xz"; sha256 = "b7a90fdf5315c8376e8c09496d0805bd06ce00357d99a1cb27ba872496f4f3cc"; }];
    buildInputs = [ python2 libxslt docbook-xsl ];
  };

  "aspell" = fetch {
    pname       = "aspell";
    version     = "0.60.6.1";
    srcs        = [{ filename = "aspell-0.60.6.1-1-i686.pkg.tar.xz"; sha256 = "6e73f357394924cd3cd84813195840c7fd79fc0855fbbbced64be8a52ce0ea3b"; }];
    buildInputs = [ gcc-libs gettext libiconv ncurses ];
  };

  "aspell-devel" = fetch {
    pname       = "aspell-devel";
    version     = "0.60.6.1";
    srcs        = [{ filename = "aspell-devel-0.60.6.1-1-i686.pkg.tar.xz"; sha256 = "4fe0b9ab51bd3618911a2e6199c82e825af3020687fdd8386ca8e2909e15dd60"; }];
    buildInputs = [ (assert aspell.version=="0.60.6.1"; aspell) gettext-devel libiconv-devel ncurses-devel ];
  };

  "aspell6-en" = fetch {
    pname       = "aspell6-en";
    version     = "2018.04.16";
    srcs        = [{ filename = "aspell6-en-2018.04.16-1-i686.pkg.tar.xz"; sha256 = "8ab867f5acc9581e9f58c280e66657b519c0ef06a02de6af13324ae0b43e67c0"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast aspell.version "0.60"; aspell) ];
  };

  "atool" = fetch {
    pname       = "atool";
    version     = "0.39.0";
    srcs        = [{ filename = "atool-0.39.0-1-any.pkg.tar.xz"; sha256 = "59788529a1a0bfe65ad8b43d1e024c94b2039747009283b497d58dde27f5f934"; }];
    buildInputs = [ file perl ];
  };

  "autoconf" = fetch {
    pname       = "autoconf";
    version     = "2.69";
    srcs        = [{ filename = "autoconf-2.69-5-any.pkg.tar.xz"; sha256 = "7133c1d8ad6decf3f9e3ffb1535e5099d65315d6101c6d592622e0bcfe145d7d"; }];
    buildInputs = [ awk m4 diffutils bash perl ];
  };

  "autoconf-archive" = fetch {
    pname       = "autoconf-archive";
    version     = "2019.01.06";
    srcs        = [{ filename = "autoconf-archive-2019.01.06-1-any.pkg.tar.xz"; sha256 = "a11af2a66cf2a739d4bf6092360cd763b3b4a95f5f12c924d4cb20f50f369bb6"; }];
  };

  "autoconf2.13" = fetch {
    pname       = "autoconf2.13";
    version     = "2.13";
    srcs        = [{ filename = "autoconf2.13-2.13-2-any.pkg.tar.xz"; sha256 = "027e49c0c3e84194bb1fc7386906db173b466cfd67e36667e01e286776eadfb2"; }];
  };

  "autogen" = fetch {
    pname       = "autogen";
    version     = "5.18.16";
    srcs        = [{ filename = "autogen-5.18.16-1-i686.pkg.tar.xz"; sha256 = "e449d00820096d2ec1f3d1a30da28cc7892e635b62513bf033bb91f4be94299d"; }];
    buildInputs = [ gcc-libs gmp libcrypt libffi libgc libguile libxml2 ];
  };

  "automake-wrapper" = fetch {
    pname       = "automake-wrapper";
    version     = "11";
    srcs        = [{ filename = "automake-wrapper-11-1-any.pkg.tar.xz"; sha256 = "a2900e2a050398f0451b730f4780cee1e780feda7f8296f5dcad438825f5d473"; }];
    buildInputs = [ bash gawk self."automake1.6" self."automake1.7" self."automake1.7" self."automake1.8" self."automake1.9" self."automake1.10" self."automake1.11" self."automake1.12" self."automake1.13" self."automake1.14" self."automake1.15" self."automake1.16" ];
  };

  "automake1.10" = fetch {
    pname       = "automake1.10";
    version     = "1.10.3";
    srcs        = [{ filename = "automake1.10-1.10.3-3-any.pkg.tar.xz"; sha256 = "52574485d444637a3e42952651b72b39cafbd67e03db9d18e09481d2025cbb54"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.11" = fetch {
    pname       = "automake1.11";
    version     = "1.11.6";
    srcs        = [{ filename = "automake1.11-1.11.6-3-any.pkg.tar.xz"; sha256 = "84e34886dff00202aa4f95eb48d0bea242c0d020fc2eb23eb423c1356b3d4e26"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.12" = fetch {
    pname       = "automake1.12";
    version     = "1.12.6";
    srcs        = [{ filename = "automake1.12-1.12.6-3-any.pkg.tar.xz"; sha256 = "58c8eb8b94206e587ba069b2299c00207bb506cbde4276373b09f11e2688c202"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.13" = fetch {
    pname       = "automake1.13";
    version     = "1.13.4";
    srcs        = [{ filename = "automake1.13-1.13.4-4-any.pkg.tar.xz"; sha256 = "8fd30d7d5f289f3d53f8566c6bc43baa7667ec038bcf4dfb97dce5a2c6c6d019"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.14" = fetch {
    pname       = "automake1.14";
    version     = "1.14.1";
    srcs        = [{ filename = "automake1.14-1.14.1-3-any.pkg.tar.xz"; sha256 = "dce6e48025e3e5364d0453c2bfcfd975178c976eaa0067b29214b89879235b05"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.15" = fetch {
    pname       = "automake1.15";
    version     = "1.15.1";
    srcs        = [{ filename = "automake1.15-1.15.1-1-any.pkg.tar.xz"; sha256 = "87fd02dadf5f8707aa9c9583273bb4cdd0a3a20a12183414e594d3995591b605"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.16" = fetch {
    pname       = "automake1.16";
    version     = "1.16.1";
    srcs        = [{ filename = "automake1.16-1.16.1-1-any.pkg.tar.xz"; sha256 = "c93f9ef0619ae1e1ff360fa05bfee5189fba1378c3b4abe204d5b50f6c5aadee"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.6" = fetch {
    pname       = "automake1.6";
    version     = "1.6.3";
    srcs        = [{ filename = "automake1.6-1.6.3-2-any.pkg.tar.xz"; sha256 = "3b5c6f6493a84c588bf61b88d8fdd5a964347ec09b3181c4c664a547f7213442"; }];
    buildInputs = [  ];
  };

  "automake1.7" = fetch {
    pname       = "automake1.7";
    version     = "1.7.9";
    srcs        = [{ filename = "automake1.7-1.7.9-2-any.pkg.tar.xz"; sha256 = "9a65a7573e6afcde67c5b58a0cfdceba23032323d082de0cdc81f4e81f3645c6"; }];
    buildInputs = [  ];
  };

  "automake1.8" = fetch {
    pname       = "automake1.8";
    version     = "1.8.5";
    srcs        = [{ filename = "automake1.8-1.8.5-3-any.pkg.tar.xz"; sha256 = "c4e6c13c3b08b450c931a487e6ef2b25de30685e4b5975e1bd37f5a9e84de9a5"; }];
    buildInputs = [  ];
  };

  "automake1.9" = fetch {
    pname       = "automake1.9";
    version     = "1.9.6";
    srcs        = [{ filename = "automake1.9-1.9.6-2-any.pkg.tar.xz"; sha256 = "0a098ef652f9499d31305cdc58142493f25ae4ba43169455e9a31d02fec2a7ee"; }];
    buildInputs = [  ];
  };

  "axel" = fetch {
    pname       = "axel";
    version     = "2.16.1";
    srcs        = [{ filename = "axel-2.16.1-2-i686.pkg.tar.xz"; sha256 = "88786e33f373b301f284dcfe62c95b421e711958bcde2cbf4722047117d0fe33"; }];
    buildInputs = [ openssl gettext ];
  };

  "bash" = fetch {
    pname       = "bash";
    version     = "4.4.023";
    srcs        = [{ filename = "bash-4.4.023-1-i686.pkg.tar.xz"; sha256 = "77be522f8d4e080d8ad67a37b152d9d4829b77ec952c0b078494ae9dd5884969"; }];
    buildInputs = [ msys2-runtime ];
  };

  "bash-completion" = fetch {
    pname       = "bash-completion";
    version     = "2.8";
    srcs        = [{ filename = "bash-completion-2.8-2-any.pkg.tar.xz"; sha256 = "862d222c573fed057a47cbb32914009b913b250e8dca7bafe55b350f40c873ca"; }];
    buildInputs = [ bash ];
  };

  "bash-devel" = fetch {
    pname       = "bash-devel";
    version     = "4.4.023";
    srcs        = [{ filename = "bash-devel-4.4.023-1-i686.pkg.tar.xz"; sha256 = "050bc4fc1ea15046681bf0e284a39dae4ecd203f0ed50256028267ca470501f2"; }];
  };

  "bc" = fetch {
    pname       = "bc";
    version     = "1.07.1";
    srcs        = [{ filename = "bc-1.07.1-1-i686.pkg.tar.xz"; sha256 = "dd854707b4606b450b8fa49e1d51c509b04582f836258e976e0b8ab5c33806b1"; }];
    buildInputs = [ libreadline ncurses ];
  };

  "binutils" = fetch {
    pname       = "binutils";
    version     = "2.30";
    srcs        = [{ filename = "binutils-2.30-1-i686.pkg.tar.xz"; sha256 = "bc6d132b82e1544c186c780f028f62543ac9f1d2d8908341de41c3a63475d696"; }];
    buildInputs = [ libiconv libintl zlib ];
  };

  "bison" = fetch {
    pname       = "bison";
    version     = "3.2.4";
    srcs        = [{ filename = "bison-3.2.4-1-i686.pkg.tar.xz"; sha256 = "371b7f4601527a778a0ac316b4633e524d9d50de6fa52f95cbc626be43b17a9a"; }];
    buildInputs = [ m4 sh ];
  };

  "bisonc++" = fetch {
    pname       = "bisonc++";
    version     = "6.02.01";
    srcs        = [{ filename = "bisonc++-6.02.01-1-i686.pkg.tar.xz"; sha256 = "67ff260348c5d0905058611933edd8af00d405b7329432493e19cb70f32dc176"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libbobcat.version "4.02.00"; libbobcat) ];
  };

  "brotli" = fetch {
    pname       = "brotli";
    version     = "1.0.7";
    srcs        = [{ filename = "brotli-1.0.7-1-i686.pkg.tar.xz"; sha256 = "a064e5f1fe00685bb1f99550e7e7043599b2decdcb497d33c3fc356beadb249d"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "brotli-devel" = fetch {
    pname       = "brotli-devel";
    version     = "1.0.7";
    srcs        = [{ filename = "brotli-devel-1.0.7-1-i686.pkg.tar.xz"; sha256 = "dde6f73401d1d62250e7089265c0fbdc5e5615dc0690a6cafbb68cc25db80f12"; }];
    buildInputs = [ brotli ];
  };

  "brotli-testdata" = fetch {
    pname       = "brotli-testdata";
    version     = "1.0.7";
    srcs        = [{ filename = "brotli-testdata-1.0.7-1-i686.pkg.tar.xz"; sha256 = "948f9297485b76772b3b6ab88a6231465095786a635c7413aedcdf31f2c791b8"; }];
  };

  "bsdcpio" = fetch {
    pname       = "bsdcpio";
    version     = "3.3.3";
    srcs        = [{ filename = "bsdcpio-3.3.3-3-i686.pkg.tar.xz"; sha256 = "60bf8c2731e21ae574e5bc7e41392961feb95c9f3fb117bf88aca550c1554f71"; }];
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 liblzo2 libnettle libxml2 zlib ];
  };

  "bsdtar" = fetch {
    pname       = "bsdtar";
    version     = "3.3.3";
    srcs        = [{ filename = "bsdtar-3.3.3-3-i686.pkg.tar.xz"; sha256 = "c7566e21f9f4dbf90b005aa10c6ab34fcb41f30f86d0bdab3b76bd138b669ef0"; }];
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 liblzo2 libnettle libxml2 zlib ];
  };

  "busybox" = fetch {
    pname       = "busybox";
    version     = "1.23.2";
    srcs        = [{ filename = "busybox-1.23.2-1-i686.pkg.tar.xz"; sha256 = "8c43509cba0b5f6d1b59b170033b53dce3319cac5bd44cbfec3e05442d91f8cc"; }];
    buildInputs = [ msys2-runtime ];
  };

  "bzip2" = fetch {
    pname       = "bzip2";
    version     = "1.0.6";
    srcs        = [{ filename = "bzip2-1.0.6-2-i686.pkg.tar.xz"; sha256 = "3abb1895c249f868bc5299fbbc0a604034488d010f048c7a9851236aca913773"; }];
  };

  "bzr" = fetch {
    pname       = "bzr";
    version     = "2.7.0";
    srcs        = [{ filename = "bzr-2.7.0-2-i686.pkg.tar.xz"; sha256 = "d09cd3f8e2b2dd5e6614e18d86e238123c2b896fc311364f580c1f995c08565c"; }];
    buildInputs = [ python2 ];
  };

  "bzr-fastimport" = fetch {
    pname       = "bzr-fastimport";
    version     = "0.13.0";
    srcs        = [{ filename = "bzr-fastimport-0.13.0-1-any.pkg.tar.xz"; sha256 = "91dac74a9cc2908e9eea577454cea2089752f52405952eec2147b095ba6b78e3"; }];
  };

  "ca-certificates" = fetch {
    pname       = "ca-certificates";
    version     = "20180409";
    srcs        = [{ filename = "ca-certificates-20180409-1-any.pkg.tar.xz"; sha256 = "c34142da29a1c4abb00c834c6bb144c2d5bd8625261f81a45cf0567d29662916"; }];
    buildInputs = [ bash openssl findutils coreutils sed p11-kit ];
  };

  "ccache" = fetch {
    pname       = "ccache";
    version     = "3.5";
    srcs        = [{ filename = "ccache-3.5-1-i686.pkg.tar.xz"; sha256 = "578be14982f38f6b05e53d7e56a00c28dd504f91f8b07699f862a8d028329818"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "cdecl" = fetch {
    pname       = "cdecl";
    version     = "2.5";
    srcs        = [{ filename = "cdecl-2.5-1-i686.pkg.tar.xz"; sha256 = "9cb2a78c49c19bde87f1d56d7377abf0eb399ea83c470549c73b0d7d8a7adb29"; }];
  };

  "cgdb" = fetch {
    pname       = "cgdb";
    version     = "0.7.0";
    srcs        = [{ filename = "cgdb-0.7.0-1-i686.pkg.tar.xz"; sha256 = "8da51b2e72a32df315eec29dc6fcfdf9d5291b930e7d948e572c77c57871a497"; }];
    buildInputs = [ libreadline ncurses gdb ];
  };

  "clang-svn" = fetch {
    pname       = "clang-svn";
    version     = "60105.a5d3092";
    srcs        = [{ filename = "clang-svn-60105.a5d3092-1-i686.pkg.tar.xz"; sha256 = "6f77123f052cf425b864d5c44140e0dfc29c92cc985e592289a7cd5012e51e4e"; }];
    buildInputs = [ llvm-svn ];
  };

  "cloc" = fetch {
    pname       = "cloc";
    version     = "1.80";
    srcs        = [{ filename = "cloc-1.80-1-any.pkg.tar.xz"; sha256 = "e3962a168799e4a4987ac79aa8a43de0d9f5fc25395153abff8a40cdcbcdcfcb"; }];
    buildInputs = [ perl perl-Algorithm-Diff perl-Regexp-Common perl-Parallel-ForkManager ];
  };

  "cloog" = fetch {
    pname       = "cloog";
    version     = "0.19.0";
    srcs        = [{ filename = "cloog-0.19.0-2-i686.pkg.tar.xz"; sha256 = "b051c791753bf7bc0d45ee9103d66bfd6e0205d0047d67d67ae099cef13a3ed5"; }];
    buildInputs = [ isl ];
  };

  "cloog-devel" = fetch {
    pname       = "cloog-devel";
    version     = "0.19.0";
    srcs        = [{ filename = "cloog-devel-0.19.0-2-i686.pkg.tar.xz"; sha256 = "af1a899f4ae9118053f994ab0ae632dd8f4a9a0219f5e59124c02f4f4b516159"; }];
    buildInputs = [ (assert cloog.version=="0.19.0"; cloog) isl-devel ];
  };

  "cmake" = fetch {
    pname       = "cmake";
    version     = "3.13.2";
    srcs        = [{ filename = "cmake-3.13.2-1-i686.pkg.tar.xz"; sha256 = "44acaf6bce09430af63dc87e7d19b52b001bd068d2b52978231f4901a91243a5"; }];
    buildInputs = [ gcc-libs jsoncpp libcurl libexpat libarchive librhash libutil-linux libuv ncurses pkg-config zlib ];
  };

  "cocom" = fetch {
    pname       = "cocom";
    version     = "0.996";
    srcs        = [{ filename = "cocom-0.996-2-i686.pkg.tar.xz"; sha256 = "a9a987dfc7aad99a74bdb2bd07b83eb2663f0bf5cfa6cc6e85f8b052b9241b29"; }];
  };

  "colordiff" = fetch {
    pname       = "colordiff";
    version     = "1.0.18";
    srcs        = [{ filename = "colordiff-1.0.18-1-any.pkg.tar.xz"; sha256 = "a561ae456b417fd46e1fca3145de96ce98cbc9cedea4544c6dd55cb37e63baac"; }];
    buildInputs = [ diffutils perl ];
  };

  "colormake-git" = fetch {
    pname       = "colormake-git";
    version     = "r8.9c1d2e6";
    srcs        = [{ filename = "colormake-git-r8.9c1d2e6-1-any.pkg.tar.xz"; sha256 = "7c3cd908173f819f761dbdcfda9a0211096594d02046d626817da22a0c38d658"; }];
    buildInputs = [ make ];
  };

  "conemu-git" = fetch {
    pname       = "conemu-git";
    version     = "r3330.34a88ed";
    srcs        = [{ filename = "conemu-git-r3330.34a88ed-1-i686.pkg.tar.xz"; sha256 = "cb529c6119830c0e53a1cfde42307a167dfb236dabab95e960220a101acb3dad"; }];
  };

  "coreutils" = fetch {
    pname       = "coreutils";
    version     = "8.30";
    srcs        = [{ filename = "coreutils-8.30-1-i686.pkg.tar.xz"; sha256 = "c286492b3c20084f0c35a74f0e7c5c3e606bbfee8c495342e7e7ab433163058b"; }];
    buildInputs = [ gmp libiconv libintl ];
  };

  "cpio" = fetch {
    pname       = "cpio";
    version     = "2.12";
    srcs        = [{ filename = "cpio-2.12-1-i686.pkg.tar.xz"; sha256 = "5cbbe6ca4ed28bd2e04fd0b988492c86f7ce3ed765b9d4ecc6fe6f865ee65d10"; }];
    buildInputs = [ libintl ];
  };

  "crosstool-ng" = fetch {
    pname       = "crosstool-ng";
    version     = "1.23.0";
    srcs        = [{ filename = "crosstool-ng-1.23.0-2-i686.pkg.tar.xz"; sha256 = "5eda75404a0c0f03d711f0c315501fde8dd9ab14a89ca13d62ec38e0dd11f5aa"; }];
    buildInputs = [ ncurses libintl ];
  };

  "crosstool-ng-git" = fetch {
    pname       = "crosstool-ng-git";
    version     = "1.19.314.a483cd9";
    srcs        = [{ filename = "crosstool-ng-git-1.19.314.a483cd9-1-i686.pkg.tar.xz"; sha256 = "7c7d61671cfb6ba5e3871e5ea019989894500e6dffabb0c22d0ee77a78c0908c"; }];
  };

  "cscope" = fetch {
    pname       = "cscope";
    version     = "15.9";
    srcs        = [{ filename = "cscope-15.9-1-i686.pkg.tar.xz"; sha256 = "009e6ee6d9bfbc80d5e76e445c59eeb385b2c13ba4214fa749b557fe16c0a9de"; }];
  };

  "ctags" = fetch {
    pname       = "ctags";
    version     = "5.8";
    srcs        = [{ filename = "ctags-5.8-2-i686.pkg.tar.xz"; sha256 = "2df51a35d6b00cf9449fd6ecb1ecbe14dd4769d37feac6e5b98247c19757efd4"; }];
  };

  "curl" = fetch {
    pname       = "curl";
    version     = "7.63.0";
    srcs        = [{ filename = "curl-7.63.0-2-i686.pkg.tar.xz"; sha256 = "73f93fec5864d88588288b841d197e19f6707bdb22bb7e2ec64a199ceb0d35aa"; }];
    buildInputs = [ ca-certificates libcurl libcrypt libmetalink libnghttp2 libpsl openssl zlib ];
  };

  "cvs" = fetch {
    pname       = "cvs";
    version     = "1.11.23";
    srcs        = [{ filename = "cvs-1.11.23-3-i686.pkg.tar.xz"; sha256 = "f045b43b83f7222d3f0fc2f70210564995d5deca72a46d9015217a5d3a61978a"; }];
    buildInputs = [ heimdal zlib libcrypt libopenssl ];
  };

  "cygrunsrv" = fetch {
    pname       = "cygrunsrv";
    version     = "1.62";
    srcs        = [{ filename = "cygrunsrv-1.62-1-i686.pkg.tar.xz"; sha256 = "0e62b62fe9c0720def68d9df5a9437d61dcaba97f7456874810576cbcc621382"; }];
    buildInputs = [ python2 ];
  };

  "cyrus-sasl" = fetch {
    pname       = "cyrus-sasl";
    version     = "2.1.27";
    srcs        = [{ filename = "cyrus-sasl-2.1.27-1-i686.pkg.tar.xz"; sha256 = "570e083de8b03b10696f303f43b733d27a927fc619fc05e881e913106c27dc68"; }];
    buildInputs = [ (assert libsasl.version=="2.1.27"; libsasl) ];
  };

  "dash" = fetch {
    pname       = "dash";
    version     = "0.5.10.2";
    srcs        = [{ filename = "dash-0.5.10.2-1-i686.pkg.tar.xz"; sha256 = "c8210f77daf247742e348cd736478a206bcc3a82dcf338bdd233b1060452226e"; }];
    buildInputs = [ msys2-base msys2-runtime grep sed ];
    broken      = true; # broken dependency dash -> msys2-base
  };

  "db" = fetch {
    pname       = "db";
    version     = "5.3.28";
    srcs        = [{ filename = "db-5.3.28-2-i686.pkg.tar.xz"; sha256 = "31d2e7443fc0fbd4ba6f22eb256b08e26ef8f9765715bf46cff29686a31a3e46"; }];
    buildInputs = [  ];
  };

  "db-docs" = fetch {
    pname       = "db-docs";
    version     = "5.3.28";
    srcs        = [{ filename = "db-docs-5.3.28-2-i686.pkg.tar.xz"; sha256 = "66104573d37ba2923680a25d0c95b9c30a942e949aae8886bec0b3ca0ebb6e89"; }];
  };

  "dejagnu" = fetch {
    pname       = "dejagnu";
    version     = "1.6.2";
    srcs        = [{ filename = "dejagnu-1.6.2-1-any.pkg.tar.xz"; sha256 = "3048588a1540ae52ce92d7b832387c7d87dce3ef6896b6de2d629d88790352f8"; }];
    buildInputs = [ expect ];
  };

  "delta" = fetch {
    pname       = "delta";
    version     = "20060803";
    srcs        = [{ filename = "delta-20060803-1-i686.pkg.tar.xz"; sha256 = "279f051333961ac5e331f3ca3fdf654379cf200b96f9a156712b29ba2fca3882"; }];
  };

  "depot-tools-git" = fetch {
    pname       = "depot-tools-git";
    version     = "r2542.77b74b5";
    srcs        = [{ filename = "depot-tools-git-r2542.77b74b5-1-any.pkg.tar.xz"; sha256 = "077396c31615b6c143dd45a61b6a82d078845f0f10b7b8b8baf1829057594000"; }];
  };

  "dialog" = fetch {
    pname       = "dialog";
    version     = "1.3_20181107";
    srcs        = [{ filename = "dialog-1.3_20181107-1-i686.pkg.tar.xz"; sha256 = "aefaaf0ec6969cd326b883c4ad4d68db07334eca5b4e522d6765f0cb733ae924"; }];
    buildInputs = [ ncurses ];
  };

  "diffstat" = fetch {
    pname       = "diffstat";
    version     = "1.61";
    srcs        = [{ filename = "diffstat-1.61-1-i686.pkg.tar.xz"; sha256 = "5c844b580710837d7c13a7a50327c16bb363f550394a05216091161976950796"; }];
    buildInputs = [ msys2-runtime ];
  };

  "diffutils" = fetch {
    pname       = "diffutils";
    version     = "3.6";
    srcs        = [{ filename = "diffutils-3.6-1-i686.pkg.tar.xz"; sha256 = "1e5c9d668654dc8d4b455b9956172aab0ef41aa5e3362fe0e152e72097618fc5"; }];
    buildInputs = [ msys2-runtime sh ];
  };

  "docbook-dsssl" = fetch {
    pname       = "docbook-dsssl";
    version     = "1.79";
    srcs        = [{ filename = "docbook-dsssl-1.79-1-any.pkg.tar.xz"; sha256 = "1273ed10dd37228a45216cc78c2575560ffc935a10dc22ac5048b0b452ca955c"; }];
    buildInputs = [ sgml-common perl ];
  };

  "docbook-mathml" = fetch {
    pname       = "docbook-mathml";
    version     = "1.1CR1";
    srcs        = [{ filename = "docbook-mathml-1.1CR1-1-any.pkg.tar.xz"; sha256 = "087c59e703a4694e17a5926a6e82fa7a2238d7e9e5d147ad1a91841ca1dadca0"; }];
    buildInputs = [ libxml2 ];
  };

  "docbook-sgml" = fetch {
    pname       = "docbook-sgml";
    version     = "4.5";
    srcs        = [{ filename = "docbook-sgml-4.5-1-any.pkg.tar.xz"; sha256 = "1c8a2e1ad161deb3ebc44511ba054d201b4512ab74cd957dcadab487b136574b"; }];
    buildInputs = [ sgml-common ];
  };

  "docbook-sgml31" = fetch {
    pname       = "docbook-sgml31";
    version     = "3.1";
    srcs        = [{ filename = "docbook-sgml31-3.1-1-any.pkg.tar.xz"; sha256 = "ecaaceef13bf6cbd80ca01ac1f3ba4abdd41925810165a2ca4747bd0494961c3"; }];
    buildInputs = [ sgml-common ];
  };

  "docbook-xml" = fetch {
    pname       = "docbook-xml";
    version     = "4.5";
    srcs        = [{ filename = "docbook-xml-4.5-2-any.pkg.tar.xz"; sha256 = "9641cde3ecb1ed7d78e94d80b85aecec48a88bde662b48bec1547fa2a8132cae"; }];
    buildInputs = [  ];
  };

  "docbook-xsl" = fetch {
    pname       = "docbook-xsl";
    version     = "1.79.2";
    srcs        = [{ filename = "docbook-xsl-1.79.2-1-any.pkg.tar.xz"; sha256 = "5fc6bf02cfaa46b9e769014f71573b9d9fe2d36ef7fefb5ecc29afd35bea46a8"; }];
    buildInputs = [ libxml2 libxslt docbook-xml ];
  };

  "docx2txt" = fetch {
    pname       = "docx2txt";
    version     = "1.4";
    srcs        = [{ filename = "docx2txt-1.4-1-i686.pkg.tar.xz"; sha256 = "4a0dc62d99b5440da45024e7b0fc6b7012925f3275a3025b340e22726e331ca6"; }];
    buildInputs = [ perl unzip ];
  };

  "dos2unix" = fetch {
    pname       = "dos2unix";
    version     = "7.4.0";
    srcs        = [{ filename = "dos2unix-7.4.0-1-i686.pkg.tar.xz"; sha256 = "99cdbadf6e1422fb4830bd334ea99b0aded77a8a498eb38309452bccce98a264"; }];
    buildInputs = [ libintl ];
  };

  "doxygen" = fetch {
    pname       = "doxygen";
    version     = "1.8.14";
    srcs        = [{ filename = "doxygen-1.8.14-1-i686.pkg.tar.xz"; sha256 = "9f86f5aee90057f4ddd3b0d5941a91eec7bc9fd50c3be5cb5adeb47ded55d93e"; }];
    buildInputs = [ gcc-libs libsqlite libiconv ];
  };

  "dtc" = fetch {
    pname       = "dtc";
    version     = "1.4.7";
    srcs        = [{ filename = "dtc-1.4.7-1-i686.pkg.tar.xz"; sha256 = "055453cc97830b36ece19d9b8c21b3c8d75653dd9e0cbf4ae720e56e3fc5ed86"; }];
  };

  "easyoptions-git" = fetch {
    pname       = "easyoptions-git";
    version     = "r37.c481763";
    srcs        = [{ filename = "easyoptions-git-r37.c481763-1-any.pkg.tar.xz"; sha256 = "68204fd1ad1ccec9048a130c824e5ae4bb563d88442111ec153b254d47143eb7"; }];
    buildInputs = [ ruby bash ];
  };

  "ed" = fetch {
    pname       = "ed";
    version     = "1.14.2";
    srcs        = [{ filename = "ed-1.14.2-1-i686.pkg.tar.xz"; sha256 = "6d1d4409a5b50de8ca0513786c2b2cb6459b1bed15e02e0a23ece6faef0221e1"; }];
    buildInputs = [ sh ];
  };

  "elinks-git" = fetch {
    pname       = "elinks-git";
    version     = "0.13.4008.f86be659";
    srcs        = [{ filename = "elinks-git-0.13.4008.f86be659-2-i686.pkg.tar.xz"; sha256 = "82b50ddb1c75c423439509026186126228cc4d1c86334fcb17683320b206b40d"; }];
    buildInputs = [ doxygen gettext libbz2 libcrypt libexpat libffi libgc libgcrypt libgnutls libhogweed libiconv libidn liblzma libnettle libp11-kit libtasn1 libtre-git libunistring perl python2 xmlto zlib ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "emacs" = fetch {
    pname       = "emacs";
    version     = "26.1";
    srcs        = [{ filename = "emacs-26.1-1-i686.pkg.tar.xz"; sha256 = "6f28ed431f89edc6847ccf5c99d09e566cbbd006e8ef1445fde40391e4de6cee"; }];
    buildInputs = [ ncurses zlib libxml2 libiconv libcrypt libgnutls glib2 libhogweed ];
  };

  "expat" = fetch {
    pname       = "expat";
    version     = "2.2.6";
    srcs        = [{ filename = "expat-2.2.6-1-i686.pkg.tar.xz"; sha256 = "af0fd0bda5ad135714d0213c97c9fade73b4ab4e30be5ecd1a4166706f12c725"; }];
    buildInputs = [  ];
  };

  "expect" = fetch {
    pname       = "expect";
    version     = "5.45.4";
    srcs        = [{ filename = "expect-5.45.4-2-i686.pkg.tar.xz"; sha256 = "d5cf2989d0a7b5106fcf6c9ea98f5468dfdce19fa7697aaadb67a84cc2a85ae1"; }];
    buildInputs = [ tcl ];
  };

  "fcode-utils" = fetch {
    pname       = "fcode-utils";
    version     = "1.0.2";
    srcs        = [{ filename = "fcode-utils-1.0.2-1-i686.pkg.tar.xz"; sha256 = "8949cc0031a0dc955acae26dad7ae72136a42bbb834e997406b55773d9798bb8"; }];
  };

  "file" = fetch {
    pname       = "file";
    version     = "5.35";
    srcs        = [{ filename = "file-5.35-1-i686.pkg.tar.xz"; sha256 = "e1c9429e5129b7903c833058fcbdefa623815b7776402615a91222dcfa1edc2c"; }];
    buildInputs = [ gcc-libs msys2-runtime zlib ];
  };

  "filesystem" = fetch {
    pname       = "filesystem";
    version     = "2018.12";
    srcs        = [{ filename = "filesystem-2018.12-1-i686.pkg.tar.xz"; sha256 = "0a15ddcd5dc61bed3599ca9bb734590c6ed1deb424c82d24f3e7c033694c0665"; }];
  };

  "findutils" = fetch {
    pname       = "findutils";
    version     = "4.6.0";
    srcs        = [{ filename = "findutils-4.6.0-1-i686.pkg.tar.xz"; sha256 = "6dfaa3f2c6f6988df3654cc02c787051603a4c71496134da60b2d5e74e4da5f3"; }];
    buildInputs = [ libiconv libintl ];
  };

  "fish" = fetch {
    pname       = "fish";
    version     = "3.0.0";
    srcs        = [{ filename = "fish-3.0.0-1-i686.pkg.tar.xz"; sha256 = "f076cb9519e4bbab1ea9d9cd2afc2420b479687350e25adbcf79266df10e7551"; }];
    buildInputs = [ gcc-libs ncurses gettext libiconv man-db bc ];
  };

  "flex" = fetch {
    pname       = "flex";
    version     = "2.6.4";
    srcs        = [{ filename = "flex-2.6.4-1-i686.pkg.tar.xz"; sha256 = "75bd4fa73628f74d769c8e8ef979b6258184e10a2aa7a0dd57f9f74630bd7cab"; }];
    buildInputs = [ m4 sh libiconv libintl ];
  };

  "flexc++" = fetch {
    pname       = "flexc++";
    version     = "2.07.02";
    srcs        = [{ filename = "flexc++-2.07.02-1-i686.pkg.tar.xz"; sha256 = "99a5ed72fc9b2b5bfe25d01c82be6624e2ec1d1c20d6028b11438afc7074a485"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libbobcat.version "4.01.00"; libbobcat) ];
  };

  "fzy" = fetch {
    pname       = "fzy";
    version     = "1.0";
    srcs        = [{ filename = "fzy-1.0-1-i686.pkg.tar.xz"; sha256 = "464e90b8a18d1af24fb7de1faf7ef9d637bc55e6da92ef0261a53d45c778e1d0"; }];
  };

  "gamin" = fetch {
    pname       = "gamin";
    version     = "0.1.10";
    srcs        = [{ filename = "gamin-0.1.10-3-i686.pkg.tar.xz"; sha256 = "8e3cd9b6324fd2bd4cf0301232c92e318aada83e3c277fe6ec8bd28708ce894a"; }];
  };

  "gamin-devel" = fetch {
    pname       = "gamin-devel";
    version     = "0.1.10";
    srcs        = [{ filename = "gamin-devel-0.1.10-3-i686.pkg.tar.xz"; sha256 = "bf2a617e024b6edb41d303ce28362f10cab65727d029ad0f85896cd4557fa9d2"; }];
    buildInputs = [ (assert gamin.version=="0.1.10"; gamin) ];
  };

  "gamin-python" = fetch {
    pname       = "gamin-python";
    version     = "0.1.10";
    srcs        = [{ filename = "gamin-python-0.1.10-3-i686.pkg.tar.xz"; sha256 = "57ef4655a7df27efae6b6c929f1d59e2c0ca73aea93b7ad17c1748fba8b704d3"; }];
    buildInputs = [ (assert gamin.version=="0.1.10"; gamin) python2 ];
  };

  "gawk" = fetch {
    pname       = "gawk";
    version     = "4.2.1";
    srcs        = [{ filename = "gawk-4.2.1-2-i686.pkg.tar.xz"; sha256 = "bbbbb1a497143a530261c86ab0817e6fc6a9776e636e909db3af058592af2ce9"; }];
    buildInputs = [ sh mpfr libintl libreadline ];
  };

  "gcc" = fetch {
    pname       = "gcc";
    version     = "7.4.0";
    srcs        = [{ filename = "gcc-7.4.0-1-i686.pkg.tar.xz"; sha256 = "3fc33597de1ba18382c33a2516759c84e7a66caa5026154222b20c718efd33e5"; }];
    buildInputs = [ (assert gcc-libs.version=="7.4.0"; gcc-libs) binutils gmp isl mpc mpfr msys2-runtime-devel msys2-w32api-headers msys2-w32api-runtime windows-default-manifest ];
  };

  "gcc-fortran" = fetch {
    pname       = "gcc-fortran";
    version     = "7.4.0";
    srcs        = [{ filename = "gcc-fortran-7.4.0-1-i686.pkg.tar.xz"; sha256 = "18365958c5f2816a3ec9370fe28c6f0d30a4ff5aac6be2d544162dbbbc5a5668"; }];
    buildInputs = [ (assert gcc.version=="7.4.0"; gcc) ];
  };

  "gcc-libs" = fetch {
    pname       = "gcc-libs";
    version     = "7.4.0";
    srcs        = [{ filename = "gcc-libs-7.4.0-1-i686.pkg.tar.xz"; sha256 = "eecb0d148f23942bcb71bce32d4dd8e3273d72c3c3b3a6d1c638c26436cd7e08"; }];
    buildInputs = [ msys2-runtime ];
  };

  "gdb" = fetch {
    pname       = "gdb";
    version     = "7.12.1";
    srcs        = [{ filename = "gdb-7.12.1-1-i686.pkg.tar.xz"; sha256 = "0a1a17ceb634f7c40f39b17e650b57735c621afcf1c7457905f3a805dd3261c1"; }];
    buildInputs = [ libiconv zlib expat python2 libexpat libreadline ];
  };

  "gdbm" = fetch {
    pname       = "gdbm";
    version     = "1.18.1";
    srcs        = [{ filename = "gdbm-1.18.1-1-i686.pkg.tar.xz"; sha256 = "b5df3642848c70a3022af59f5d4590dd85156715a7447cfee3b4791b7d16ee67"; }];
    buildInputs = [ (assert libgdbm.version=="1.18.1"; libgdbm) ];
  };

  "gengetopt" = fetch {
    pname       = "gengetopt";
    version     = "2.22.6";
    srcs        = [{ filename = "gengetopt-2.22.6-3-i686.pkg.tar.xz"; sha256 = "7a71a226df67612124cfd34456a2a76d45ee00692cfbd8175798d85441ab1386"; }];
  };

  "getent" = fetch {
    pname       = "getent";
    version     = "2.18.90";
    srcs        = [{ filename = "getent-2.18.90-2-i686.pkg.tar.xz"; sha256 = "2eb4751e5269a5c88a41ca7a1856191a6d323c9743dfde50e1f15c63206af148"; }];
    buildInputs = [ libargp ];
  };

  "getopt" = fetch {
    pname       = "getopt";
    version     = "1.1.6";
    srcs        = [{ filename = "getopt-1.1.6-1-i686.pkg.tar.xz"; sha256 = "2447141d5f11fc1bd731549c2b59efa2a2875b63b66e23b03e369623dce93a4e"; }];
    buildInputs = [ msys2-runtime sh ];
  };

  "gettext" = fetch {
    pname       = "gettext";
    version     = "0.19.8.1";
    srcs        = [{ filename = "gettext-0.19.8.1-1-i686.pkg.tar.xz"; sha256 = "d7a0441a56b14009183f054d04d9b69232a87fca77dbddbeeb2212d4d40478b6"; }];
    buildInputs = [ libintl libgettextpo libasprintf ];
  };

  "gettext-devel" = fetch {
    pname       = "gettext-devel";
    version     = "0.19.8.1";
    srcs        = [{ filename = "gettext-devel-0.19.8.1-1-i686.pkg.tar.xz"; sha256 = "670b3420ea02e4f212ebfe9f12424d8ab47365b9b01c7f09908cb6fe4e0eadb0"; }];
    buildInputs = [ (assert gettext.version=="0.19.8.1"; gettext) libiconv-devel ];
  };

  "git" = fetch {
    pname       = "git";
    version     = "2.20.1";
    srcs        = [{ filename = "git-2.20.1-1-i686.pkg.tar.xz"; sha256 = "c3b395eff33f1a423dbee8c4f0c12c4c30d4f6f4a3f3d39ba24ab0f0865db1a2"; }];
    buildInputs = [ curl (assert stdenvNoCC.lib.versionAtLeast expat.version "2.0"; expat) libpcre2_8 vim openssh openssl perl-Error (assert stdenvNoCC.lib.versionAtLeast perl.version "5.14.0"; perl) perl-Authen-SASL perl-libwww perl-MIME-tools perl-Net-SMTP-SSL perl-TermReadKey ];
  };

  "git-bzr-ng-git" = fetch {
    pname       = "git-bzr-ng-git";
    version     = "r61.9878a30";
    srcs        = [{ filename = "git-bzr-ng-git-r61.9878a30-1-any.pkg.tar.xz"; sha256 = "e2d3a7da14ede5589a1b4c186bb4119180675a9d624b0dbe133a65dbb1ba9de9"; }];
    buildInputs = [ python2 git bzr bzr-fastimport ];
  };

  "git-extras-git" = fetch {
    pname       = "git-extras-git";
    version     = "4.3.0";
    srcs        = [{ filename = "git-extras-git-4.3.0-1-any.pkg.tar.xz"; sha256 = "d2c7373356c9682ddd3048273a2cc039e3eb645418697caa28acae99abf2cb02"; }];
    buildInputs = [ git ];
  };

  "git-flow" = fetch {
    pname       = "git-flow";
    version     = "1.11.0";
    srcs        = [{ filename = "git-flow-1.11.0-1-i686.pkg.tar.xz"; sha256 = "a99b6ecf9607287cf6bac67e8d1e148fd849867d6f9428f91b675be1cdb03028"; }];
    buildInputs = [ git util-linux ];
  };

  "glib2" = fetch {
    pname       = "glib2";
    version     = "2.54.3";
    srcs        = [{ filename = "glib2-2.54.3-1-i686.pkg.tar.xz"; sha256 = "fccbeabedf34485277e3141c8c09b0e09fd54236719c8a9e3846333c1bcbc35e"; }];
    buildInputs = [ libxslt libpcre libffi libiconv zlib ];
  };

  "glib2-devel" = fetch {
    pname       = "glib2-devel";
    version     = "2.54.3";
    srcs        = [{ filename = "glib2-devel-2.54.3-1-i686.pkg.tar.xz"; sha256 = "0d53289239b2d39927151cbba2a9509c92fca2d23bbbb193b5d879fb6b696481"; }];
    buildInputs = [ (assert glib2.version=="2.54.3"; glib2) pcre-devel libffi-devel libiconv-devel zlib-devel ];
  };

  "glib2-docs" = fetch {
    pname       = "glib2-docs";
    version     = "2.54.3";
    srcs        = [{ filename = "glib2-docs-2.54.3-1-i686.pkg.tar.xz"; sha256 = "1ec965679220d7d844b301635e7f4f98ad8beaf86bec64eb98c68204bf357eec"; }];
  };

  "global" = fetch {
    pname       = "global";
    version     = "6.6.3";
    srcs        = [{ filename = "global-6.6.3-1-i686.pkg.tar.xz"; sha256 = "106fac09e35389d2f3870ede8ae7bac269be9a717dcafcd9d1f042285031046f"; }];
    buildInputs = [ libltdl ];
  };

  "gmp" = fetch {
    pname       = "gmp";
    version     = "6.1.2";
    srcs        = [{ filename = "gmp-6.1.2-1-i686.pkg.tar.xz"; sha256 = "59037ecaa53dd9b2f93d5884b1f8bcbb85755d7273072906af1674d93c36bb9e"; }];
    buildInputs = [  ];
  };

  "gmp-devel" = fetch {
    pname       = "gmp-devel";
    version     = "6.1.2";
    srcs        = [{ filename = "gmp-devel-6.1.2-1-i686.pkg.tar.xz"; sha256 = "1f6fae1ba5507eb8baeac09aecfd4f50445c817f47b2bf7a95672349e635155e"; }];
    buildInputs = [ (assert gmp.version=="6.1.2"; gmp) ];
  };

  "gnome-doc-utils" = fetch {
    pname       = "gnome-doc-utils";
    version     = "0.20.10";
    srcs        = [{ filename = "gnome-doc-utils-0.20.10-1-any.pkg.tar.xz"; sha256 = "8b10102db3d1eb13e41e77c9035094556a95a2517afc2ae01c1d07c396d38850"; }];
  };

  "gnu-netcat" = fetch {
    pname       = "gnu-netcat";
    version     = "0.7.1";
    srcs        = [{ filename = "gnu-netcat-0.7.1-1-i686.pkg.tar.xz"; sha256 = "f2386da17f68ce935326b575673fd2abbddc706ad82f07bb9fe9c026cdc4adc9"; }];
  };

  "gnupg" = fetch {
    pname       = "gnupg";
    version     = "2.2.12";
    srcs        = [{ filename = "gnupg-2.2.12-1-i686.pkg.tar.xz"; sha256 = "ac0d2bc5cf2f0a21a3bdc0dd1b10ca47a6181e0fdee52e9440fe8bc04e25b3da"; }];
    buildInputs = [ bzip2 libassuan libbz2 libcurl libgcrypt libgpg-error libgnutls libiconv libintl libksba libnpth libreadline libsqlite nettle pinentry zlib ];
  };

  "gnutls" = fetch {
    pname       = "gnutls";
    version     = "3.6.5";
    srcs        = [{ filename = "gnutls-3.6.5-2-i686.pkg.tar.xz"; sha256 = "6f3e2cc3b0bba90e45fdf0599b7704137efae6282bd68da3cbcb7070f495622e"; }];
    buildInputs = [ (assert libgnutls.version=="3.6.5"; libgnutls) ];
  };

  "gperf" = fetch {
    pname       = "gperf";
    version     = "3.1";
    srcs        = [{ filename = "gperf-3.1-1-i686.pkg.tar.xz"; sha256 = "7a0be8741d63de5d5c1ee792bb2624ec1cbace95769e9405f720d75a498986f2"; }];
    buildInputs = [ gcc-libs info ];
  };

  "gradle" = fetch {
    pname       = "gradle";
    version     = "5.1";
    srcs        = [{ filename = "gradle-5.1-1-any.pkg.tar.xz"; sha256 = "26fa75757baa3f73dd0cc13204499bffc6c519ed3fce80c94dbc8c39abf9dd52"; }];
  };

  "gradle-doc" = fetch {
    pname       = "gradle-doc";
    version     = "5.1";
    srcs        = [{ filename = "gradle-doc-5.1-1-any.pkg.tar.xz"; sha256 = "3670d9f070fa3c5e0ca93fd921cea7f41182f8c85c5816d503c54a4242def112"; }];
  };

  "grep" = fetch {
    pname       = "grep";
    version     = "3.0";
    srcs        = [{ filename = "grep-3.0-2-i686.pkg.tar.xz"; sha256 = "074f9fbe20e06ed1ea6aadb32c799abaa47f65f474582028e3ef1f6042b8d5ae"; }];
    buildInputs = [ libiconv libintl libpcre sh ];
  };

  "grml-zsh-config" = fetch {
    pname       = "grml-zsh-config";
    version     = "0.15.2";
    srcs        = [{ filename = "grml-zsh-config-0.15.2-1-any.pkg.tar.xz"; sha256 = "37a014c9974d08b29b700fae5881d456efedf64a6468e0c1414891e3f1f1b181"; }];
    buildInputs = [ zsh coreutils inetutils grep sed procps ];
  };

  "groff" = fetch {
    pname       = "groff";
    version     = "1.22.3";
    srcs        = [{ filename = "groff-1.22.3-1-i686.pkg.tar.xz"; sha256 = "c4a7f20dc0bc5150edc6f6bba67ee8b8d29696ac1680bbbce75449f9ab0f741d"; }];
    buildInputs = [  ];
  };

  "gtk-doc" = fetch {
    pname       = "gtk-doc";
    version     = "1.29";
    srcs        = [{ filename = "gtk-doc-1.29-1-i686.pkg.tar.xz"; sha256 = "fdc508b1f97efbf5151df715514c4335fbd21e0d0322445f6f3f03a7a8be5fd7"; }];
    buildInputs = [ docbook-xsl glib2 gnome-doc-utils libxml2-python python3 vim yelp-tools python2-six ];
  };

  "guile" = fetch {
    pname       = "guile";
    version     = "2.2.4";
    srcs        = [{ filename = "guile-2.2.4-2-i686.pkg.tar.xz"; sha256 = "ca0f6c49b507c556f2b598809d66eb3c81772a4024676cc8e7dc6c5b1dc89b7b"; }];
    buildInputs = [ (assert libguile.version=="2.2.4"; libguile) info ];
  };

  "gyp-git" = fetch {
    pname       = "gyp-git";
    version     = "r2114.a2738d85";
    srcs        = [{ filename = "gyp-git-r2114.a2738d85-1-i686.pkg.tar.xz"; sha256 = "467d7bb89910760c6609d700add15aa7ce5847e90d4f76a5fae75ba0ea5e4734"; }];
    buildInputs = [ python2 python2-setuptools ];
  };

  "gzip" = fetch {
    pname       = "gzip";
    version     = "1.9";
    srcs        = [{ filename = "gzip-1.9-1-i686.pkg.tar.xz"; sha256 = "fad9ed385ceb02d277574fb26dd67e38592d1f9eac69e423f1c21dfc0e3750dc"; }];
    buildInputs = [ msys2-runtime bash less ];
  };

  "heimdal" = fetch {
    pname       = "heimdal";
    version     = "7.5.0";
    srcs        = [{ filename = "heimdal-7.5.0-3-i686.pkg.tar.xz"; sha256 = "5944697e3ac86dbda373e848daa974f5205281cc6018967942ee620ac7f62152"; }];
    buildInputs = [ heimdal-libs ];
  };

  "heimdal-devel" = fetch {
    pname       = "heimdal-devel";
    version     = "7.5.0";
    srcs        = [{ filename = "heimdal-devel-7.5.0-3-i686.pkg.tar.xz"; sha256 = "a4f695b06e6e2de7e8e95d41e0df6215b29dac3b08e434957be6e514b4c44b59"; }];
    buildInputs = [ heimdal-libs libcrypt-devel libedit-devel libdb-devel libsqlite-devel ];
  };

  "heimdal-libs" = fetch {
    pname       = "heimdal-libs";
    version     = "7.5.0";
    srcs        = [{ filename = "heimdal-libs-7.5.0-3-i686.pkg.tar.xz"; sha256 = "5f47e80b7fa6e04f05accd809e984b0dc333b73e9e813576bf4f79ae1c680ec2"; }];
    buildInputs = [ libdb libcrypt libedit libsqlite libopenssl ];
  };

  "help2man" = fetch {
    pname       = "help2man";
    version     = "1.47.8";
    srcs        = [{ filename = "help2man-1.47.8-1-i686.pkg.tar.xz"; sha256 = "7b8543741626268bb6cf4e9efca008be01fcf35a62fe1b62c741c7dd4dafb4ab"; }];
    buildInputs = [ perl-Locale-Gettext libintl ];
  };

  "hexcurse" = fetch {
    pname       = "hexcurse";
    version     = "1.60.0";
    srcs        = [{ filename = "hexcurse-1.60.0-1-i686.pkg.tar.xz"; sha256 = "a3f15555976be679d915c1503cce6111edf2408a2d7324d52be6666cade0b1c6"; }];
    buildInputs = [ ncurses ];
  };

  "icmake" = fetch {
    pname       = "icmake";
    version     = "9.02.08";
    srcs        = [{ filename = "icmake-9.02.08-1-i686.pkg.tar.xz"; sha256 = "3a64508ee7ec5cfb51551cd322df957804cc69333ab5c001a907330eebc9ab66"; }];
  };

  "icon-naming-utils" = fetch {
    pname       = "icon-naming-utils";
    version     = "0.8.90";
    srcs        = [{ filename = "icon-naming-utils-0.8.90-1-i686.pkg.tar.xz"; sha256 = "ed3ee21eb08d9eb6066e1a4516912972b4e84a41c4fac53b1bbb2afdb3de00db"; }];
    buildInputs = [ perl-XML-Simple ];
  };

  "icu" = fetch {
    pname       = "icu";
    version     = "62.1";
    srcs        = [{ filename = "icu-62.1-1-i686.pkg.tar.xz"; sha256 = "e83f82ce80e763afb28eb88765846b17fdc10eda7c16855727dceb00091f9b2d"; }];
    buildInputs = [ gcc-libs ];
  };

  "icu-devel" = fetch {
    pname       = "icu-devel";
    version     = "62.1";
    srcs        = [{ filename = "icu-devel-62.1-1-i686.pkg.tar.xz"; sha256 = "b5d4d7dc956357f730a048ed1ba211b0145d0131a8452ce75deee7b8b8f2203a"; }];
    buildInputs = [ (assert icu.version=="62.1"; icu) ];
  };

  "idutils" = fetch {
    pname       = "idutils";
    version     = "4.6";
    srcs        = [{ filename = "idutils-4.6-2-i686.pkg.tar.xz"; sha256 = "759674c9122f7474595e494ef4f59ae5c031299e04597b4531d26fe4761caf02"; }];
  };

  "inetutils" = fetch {
    pname       = "inetutils";
    version     = "1.9.4";
    srcs        = [{ filename = "inetutils-1.9.4-1-i686.pkg.tar.xz"; sha256 = "e0e643ea9ec76e6b855919df82337afb2da72962648662e0fa86e69e023dc710"; }];
    buildInputs = [ gcc-libs libintl libcrypt libreadline ncurses tftp-hpa ];
  };

  "info" = fetch {
    pname       = "info";
    version     = "6.5";
    srcs        = [{ filename = "info-6.5-2-i686.pkg.tar.xz"; sha256 = "b6bee412a2fc3e677f5c53b9e95617ed4e17330c5b71d2a407ae418227443ccb"; }];
    buildInputs = [ gzip libcrypt libintl ncurses ];
  };

  "intltool" = fetch {
    pname       = "intltool";
    version     = "0.51.0";
    srcs        = [{ filename = "intltool-0.51.0-2-i686.pkg.tar.xz"; sha256 = "1986c9b7cb339de70563d2f9456765525edb7e0a6ea831efec0b93d2c5928d26"; }];
    buildInputs = [ perl-XML-Parser ];
  };

  "iperf" = fetch {
    pname       = "iperf";
    version     = "2.0.12";
    srcs        = [{ filename = "iperf-2.0.12-1-i686.pkg.tar.xz"; sha256 = "cb95079f558e2d5bf71471a0f8885c95eb84aeccfaab894fb80e40c276bdbaba"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "iperf3" = fetch {
    pname       = "iperf3";
    version     = "3.6";
    srcs        = [{ filename = "iperf3-3.6-3-i686.pkg.tar.xz"; sha256 = "1971477e24cac5465c2ea215b8e8b1d4642835c4d7e2b293bb3e29bde4bdbe44"; }];
    buildInputs = [ msys2-runtime gcc-libs openssl ];
  };

  "irssi" = fetch {
    pname       = "irssi";
    version     = "1.1.2";
    srcs        = [{ filename = "irssi-1.1.2-1-i686.pkg.tar.xz"; sha256 = "0016de8415d49e90e8d6ed8aafafc52eeeae5a5c18c1ad956d156e98a1743f03"; }];
    buildInputs = [ openssl gettext perl ncurses glib2 ];
  };

  "isl" = fetch {
    pname       = "isl";
    version     = "0.19";
    srcs        = [{ filename = "isl-0.19-1-i686.pkg.tar.xz"; sha256 = "41526853f1f6e5733e3211083911b99962de4a473b4b7aec27c4c921f9a4d63f"; }];
    buildInputs = [ gmp ];
  };

  "isl-devel" = fetch {
    pname       = "isl-devel";
    version     = "0.19";
    srcs        = [{ filename = "isl-devel-0.19-1-i686.pkg.tar.xz"; sha256 = "dc49e3ada874c8560b58837a501da07a6e7ed10703c40870cfd85c25d58c987f"; }];
    buildInputs = [ (assert isl.version=="0.19"; isl) gmp-devel ];
  };

  "itstool" = fetch {
    pname       = "itstool";
    version     = "2.0.4";
    srcs        = [{ filename = "itstool-2.0.4-2-i686.pkg.tar.xz"; sha256 = "05437fd7fa4d41991e89fc789531551fae217b32571c77bb3cfb7dde9ad4c9c5"; }];
    buildInputs = [ python2 libxml2 libxml2-python ];
  };

  "jansson" = fetch {
    pname       = "jansson";
    version     = "2.12";
    srcs        = [{ filename = "jansson-2.12-1-i686.pkg.tar.xz"; sha256 = "2f6dd1a3a55751c26fa01e797338769f153f19b887622e10dcc785d7df3d5101"; }];
  };

  "jansson-devel" = fetch {
    pname       = "jansson-devel";
    version     = "2.12";
    srcs        = [{ filename = "jansson-devel-2.12-1-i686.pkg.tar.xz"; sha256 = "5021f3fd53d8bf20a534b0dea0b6aeaaa0f043d943916c25e93c3ef2bb510eb4"; }];
    buildInputs = [ (assert jansson.version=="2.12"; jansson) ];
  };

  "jhbuild-git" = fetch {
    pname       = "jhbuild-git";
    version     = "9425.76669ac0";
    srcs        = [{ filename = "jhbuild-git-9425.76669ac0-1-i686.pkg.tar.xz"; sha256 = "f07a934ff7b9e63fd74f3ad5d6cd11bfc917f324f89762bd5c873b8344023de6"; }];
    buildInputs = [ python2 ];
  };

  "jsoncpp" = fetch {
    pname       = "jsoncpp";
    version     = "1.8.4";
    srcs        = [{ filename = "jsoncpp-1.8.4-1-any.pkg.tar.xz"; sha256 = "ae30421720ee993e09cded25f656b7ada808d07248bc7b2ff2229ce78c9a9902"; }];
    buildInputs = [ gcc-libs ];
  };

  "jsoncpp-devel" = fetch {
    pname       = "jsoncpp-devel";
    version     = "1.8.4";
    srcs        = [{ filename = "jsoncpp-devel-1.8.4-1-any.pkg.tar.xz"; sha256 = "eb9a3976da776d946229c36533d56bed5330e975e5b171b9a1e0cf904f8a320e"; }];
    buildInputs = [ (assert jsoncpp.version=="1.8.4"; jsoncpp) ];
  };

  "lemon" = fetch {
    pname       = "lemon";
    version     = "3.21.0";
    srcs        = [{ filename = "lemon-3.21.0-1-i686.pkg.tar.xz"; sha256 = "4821a886ead7f1b36b1bc153b0e01029fd89c0445df8461f9be06c2e9955354a"; }];
    buildInputs = [ gcc-libs ];
  };

  "less" = fetch {
    pname       = "less";
    version     = "530";
    srcs        = [{ filename = "less-530-1-i686.pkg.tar.xz"; sha256 = "8f2236c940cc438bb0572f68616785c42584dce7b850fdfcb0c1acc149aa0586"; }];
    buildInputs = [ ncurses libpcre ];
  };

  "lftp" = fetch {
    pname       = "lftp";
    version     = "4.8.4";
    srcs        = [{ filename = "lftp-4.8.4-2-i686.pkg.tar.xz"; sha256 = "5f90adb4f6fd966fc3642f9357c75b58d4a9b785cb0fe800ea686c5e5a7d4dc4"; }];
    buildInputs = [ gcc-libs ca-certificates expat gettext libexpat libgnutls libiconv libidn2 libintl libreadline libunistring openssh zlib ];
  };

  "libarchive" = fetch {
    pname       = "libarchive";
    version     = "3.3.3";
    srcs        = [{ filename = "libarchive-3.3.3-3-i686.pkg.tar.xz"; sha256 = "42b5a3d861f5742f89563c322edc3d738fe0513351eee186e5c7003c1333e035"; }];
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 liblzo2 libnettle libxml2 zlib ];
  };

  "libarchive-devel" = fetch {
    pname       = "libarchive-devel";
    version     = "3.3.3";
    srcs        = [{ filename = "libarchive-devel-3.3.3-3-i686.pkg.tar.xz"; sha256 = "1de03f3709c7cec83d91a51dd2e1e1d7cfaf4479f6d029451783de5a5ce6eb33"; }];
    buildInputs = [ (assert libarchive.version=="3.3.3"; libarchive) libbz2-devel libiconv-devel liblzma-devel liblz4-devel liblzo2-devel libnettle-devel libxml2-devel zlib-devel ];
  };

  "libargp" = fetch {
    pname       = "libargp";
    version     = "20110921";
    srcs        = [{ filename = "libargp-20110921-2-i686.pkg.tar.xz"; sha256 = "2466483565efa723583e798f538289204ca6a688dda0c09c4bd1f136299ed89e"; }];
    buildInputs = [  ];
  };

  "libargp-devel" = fetch {
    pname       = "libargp-devel";
    version     = "20110921";
    srcs        = [{ filename = "libargp-devel-20110921-2-i686.pkg.tar.xz"; sha256 = "e72b795c5741cf37cb92a688f05ef3924d7e53da2db31ed3e440c19ee662c042"; }];
    buildInputs = [ (assert libargp.version=="20110921"; libargp) ];
  };

  "libasprintf" = fetch {
    pname       = "libasprintf";
    version     = "0.19.8.1";
    srcs        = [{ filename = "libasprintf-0.19.8.1-1-i686.pkg.tar.xz"; sha256 = "6415b6e7015e0c11c46056e8651d6cde1fe61164bbe91730ad7f3c376db978ed"; }];
    buildInputs = [ gcc-libs ];
  };

  "libassuan" = fetch {
    pname       = "libassuan";
    version     = "2.5.2";
    srcs        = [{ filename = "libassuan-2.5.2-1-i686.pkg.tar.xz"; sha256 = "72063810cc3bfc84501b3f191c0886391b459c1356b55b51921f212ee1c646d8"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libassuan-devel" = fetch {
    pname       = "libassuan-devel";
    version     = "2.5.2";
    srcs        = [{ filename = "libassuan-devel-2.5.2-1-i686.pkg.tar.xz"; sha256 = "31058707b1e1854eee4d54ab6eea52f56bb2a9da98329ffd87d2ad1c7e6edcb6"; }];
    buildInputs = [ (assert libassuan.version=="2.5.2"; libassuan) libgpg-error-devel ];
  };

  "libatomic_ops" = fetch {
    pname       = "libatomic_ops";
    version     = "7.6.8";
    srcs        = [{ filename = "libatomic_ops-7.6.8-1-any.pkg.tar.xz"; sha256 = "e2255d141befbd2111d3b8301ba9016514cd950e29ea673f5e92f681e97cd291"; }];
    buildInputs = [  ];
  };

  "libatomic_ops-devel" = fetch {
    pname       = "libatomic_ops-devel";
    version     = "7.6.8";
    srcs        = [{ filename = "libatomic_ops-devel-7.6.8-1-any.pkg.tar.xz"; sha256 = "53e58950d244568c7c7746e2d9b5f271b5d76b81ae4f08692981f66b8e25a8cf"; }];
    buildInputs = [ (assert libatomic_ops.version=="7.6.8"; libatomic_ops) ];
  };

  "libbobcat" = fetch {
    pname       = "libbobcat";
    version     = "4.08.03";
    srcs        = [{ filename = "libbobcat-4.08.03-1-i686.pkg.tar.xz"; sha256 = "789aa3ebe93d5ba8b0be7a93560efe6e0ff33e2eeba7ed7e0079075a0ba0922d"; }];
    buildInputs = [ gcc-libs ];
  };

  "libbobcat-devel" = fetch {
    pname       = "libbobcat-devel";
    version     = "4.08.03";
    srcs        = [{ filename = "libbobcat-devel-4.08.03-1-i686.pkg.tar.xz"; sha256 = "8d62e4336bc57b796064d52d2c4853dd073c0eedd5bf12883e9967f33c776236"; }];
    buildInputs = [ (assert libbobcat.version=="4.08.03"; libbobcat) ];
  };

  "libbz2" = fetch {
    pname       = "libbz2";
    version     = "1.0.6";
    srcs        = [{ filename = "libbz2-1.0.6-2-i686.pkg.tar.xz"; sha256 = "5f1932b0990488782d81fec264fd45af81ea25fcb71a2fa0455de1d37b10923e"; }];
    buildInputs = [  ];
  };

  "libbz2-devel" = fetch {
    pname       = "libbz2-devel";
    version     = "1.0.6";
    srcs        = [{ filename = "libbz2-devel-1.0.6-2-i686.pkg.tar.xz"; sha256 = "a4ffdbeed08881930c01cb473ce64f28dcbffb7413f43021574599339a7433d0"; }];
    buildInputs = [  ];
  };

  "libcares" = fetch {
    pname       = "libcares";
    version     = "1.15.0";
    srcs        = [{ filename = "libcares-1.15.0-1-i686.pkg.tar.xz"; sha256 = "98c0d55cde688026ddb16534a666c14b25979dce16584d3d5a03669d96a32026"; }];
    buildInputs = [ gcc-libs ];
  };

  "libcares-devel" = fetch {
    pname       = "libcares-devel";
    version     = "1.15.0";
    srcs        = [{ filename = "libcares-devel-1.15.0-1-i686.pkg.tar.xz"; sha256 = "5d194f882241a45d1c3d5ceb5f162a9449d0d7b97344e69aea0ad2f5951bab2d"; }];
    buildInputs = [ (assert libcares.version=="1.15.0"; libcares) ];
  };

  "libcrypt" = fetch {
    pname       = "libcrypt";
    version     = "2.1";
    srcs        = [{ filename = "libcrypt-2.1-2-i686.pkg.tar.xz"; sha256 = "8a074756effd06ad4372baba03e2f5bb36e1df747959499d945549531a335b92"; }];
    buildInputs = [ gcc-libs ];
  };

  "libcrypt-devel" = fetch {
    pname       = "libcrypt-devel";
    version     = "2.1";
    srcs        = [{ filename = "libcrypt-devel-2.1-2-i686.pkg.tar.xz"; sha256 = "0539b5237f84c00348f3a629b9dd9e0db37d314cfabde45557005e62818f5913"; }];
    buildInputs = [ (assert libcrypt.version=="2.1"; libcrypt) ];
  };

  "libcurl" = fetch {
    pname       = "libcurl";
    version     = "7.63.0";
    srcs        = [{ filename = "libcurl-7.63.0-2-i686.pkg.tar.xz"; sha256 = "d02ecea4ed6b1a501d5b82588c136b4d344b1855a5d103f3b4d904d0431930e8"; }];
    buildInputs = [ brotli ca-certificates heimdal-libs libcrypt libidn2 libmetalink libnghttp2 libpsl libssh2 openssl zlib ];
  };

  "libcurl-devel" = fetch {
    pname       = "libcurl-devel";
    version     = "7.63.0";
    srcs        = [{ filename = "libcurl-devel-7.63.0-2-i686.pkg.tar.xz"; sha256 = "ab2c4beedc0570eb275ff6f947a87ea4a2355454069540f41c6295c5cc7b3de5"; }];
    buildInputs = [ (assert libcurl.version=="7.63.0"; libcurl) brotli-devel heimdal-devel libcrypt-devel libidn2-devel libmetalink-devel libnghttp2-devel libpsl-devel libssh2-devel openssl-devel zlib-devel ];
  };

  "libdb" = fetch {
    pname       = "libdb";
    version     = "5.3.28";
    srcs        = [{ filename = "libdb-5.3.28-2-i686.pkg.tar.xz"; sha256 = "ce44b92db586c04c28c4f362cd59782d6fd65bb86f93b8b798b120be49b8a8f8"; }];
    buildInputs = [  ];
  };

  "libdb-devel" = fetch {
    pname       = "libdb-devel";
    version     = "5.3.28";
    srcs        = [{ filename = "libdb-devel-5.3.28-2-i686.pkg.tar.xz"; sha256 = "0aeb37d5e708d8ecdfcd925737e9c83fd495c62539ac5a92a3998ebd37613ba3"; }];
    buildInputs = [  ];
  };

  "libedit" = fetch {
    pname       = "libedit";
    version     = "3.1";
    srcs        = [{ filename = "libedit-3.1-20170329-i686.pkg.tar.xz"; sha256 = "e0fe51e1f2fe1fcad9542dab9a8b214b8f0d9b9481f75e56d453e3e87961003a"; }];
    buildInputs = [ msys2-runtime ncurses sh ];
  };

  "libedit-devel" = fetch {
    pname       = "libedit-devel";
    version     = "3.1";
    srcs        = [{ filename = "libedit-devel-3.1-20170329-i686.pkg.tar.xz"; sha256 = "6d2cd8c3bf2967897f2b663f6f390f15186b34c7baa209e5ae230082d47b6350"; }];
    buildInputs = [ (assert libedit.version=="3.1"; libedit) ncurses-devel ];
  };

  "libelf" = fetch {
    pname       = "libelf";
    version     = "0.8.13";
    srcs        = [{ filename = "libelf-0.8.13-2-i686.pkg.tar.xz"; sha256 = "7522e2fef1a7831d3b969706ce0aa91f34577e8f9bf3ecba7ccbb5cbd22ac6bb"; }];
    buildInputs = [ gcc-libs ];
  };

  "libelf-devel" = fetch {
    pname       = "libelf-devel";
    version     = "0.8.13";
    srcs        = [{ filename = "libelf-devel-0.8.13-2-i686.pkg.tar.xz"; sha256 = "8e7f1f443a84fc3b2143fc313a8f7b4b3d7ee27701f3d998b64af6295ad7f9ea"; }];
    buildInputs = [ (assert libelf.version=="0.8.13"; libelf) ];
  };

  "libevent" = fetch {
    pname       = "libevent";
    version     = "2.1.8";
    srcs        = [{ filename = "libevent-2.1.8-2-i686.pkg.tar.xz"; sha256 = "eeb341083f8cec5019c75ce1f0f40c1bfc8739f035f1c651cf4669323322bdd0"; }];
    buildInputs = [ openssl ];
  };

  "libevent-devel" = fetch {
    pname       = "libevent-devel";
    version     = "2.1.8";
    srcs        = [{ filename = "libevent-devel-2.1.8-2-i686.pkg.tar.xz"; sha256 = "4993281cea7910053e2812a0b64ac6d608d5b69ac1a345906bdfd1440feb1d62"; }];
    buildInputs = [ (assert libevent.version=="2.1.8"; libevent) openssl-devel ];
  };

  "libexpat" = fetch {
    pname       = "libexpat";
    version     = "2.2.6";
    srcs        = [{ filename = "libexpat-2.2.6-1-i686.pkg.tar.xz"; sha256 = "dca6b2097c5c10e27a1ec2df93a628bec0ed1c154c2ad8a01209610ec3d018b5"; }];
    buildInputs = [ gcc-libs ];
  };

  "libexpat-devel" = fetch {
    pname       = "libexpat-devel";
    version     = "2.2.6";
    srcs        = [{ filename = "libexpat-devel-2.2.6-1-i686.pkg.tar.xz"; sha256 = "8e377328c4eaa53faddb34c4f5efaf5c596e9bed6b5c3e3847f0c67ccf2b1bf5"; }];
    buildInputs = [ (assert libexpat.version=="2.2.6"; libexpat) ];
  };

  "libffi" = fetch {
    pname       = "libffi";
    version     = "3.2.1";
    srcs        = [{ filename = "libffi-3.2.1-3-i686.pkg.tar.xz"; sha256 = "e695d8d4ad4d6aab58f3dc20633be2c01bced08f85938a2a7e39dddf6ff671ea"; }];
    buildInputs = [  ];
  };

  "libffi-devel" = fetch {
    pname       = "libffi-devel";
    version     = "3.2.1";
    srcs        = [{ filename = "libffi-devel-3.2.1-3-i686.pkg.tar.xz"; sha256 = "1a59dfdd61cd42835c563489257239731b314d992855414b51fff42d381f28b4"; }];
    buildInputs = [ (assert libffi.version=="3.2.1"; libffi) ];
  };

  "libgc" = fetch {
    pname       = "libgc";
    version     = "7.6.8";
    srcs        = [{ filename = "libgc-7.6.8-1-i686.pkg.tar.xz"; sha256 = "1cd5959f7f45516826fbef53e17f8f2e22d6ef7160fce2637e88cb25b5e32d8a"; }];
    buildInputs = [ libatomic_ops gcc-libs ];
  };

  "libgc-devel" = fetch {
    pname       = "libgc-devel";
    version     = "7.6.8";
    srcs        = [{ filename = "libgc-devel-7.6.8-1-i686.pkg.tar.xz"; sha256 = "c7c6f9984ac19c44d6a9588e0aa6326b0bd9b5699282534e0a3dfd693e7a2f9d"; }];
    buildInputs = [ (assert libgc.version=="7.6.8"; libgc) libatomic_ops-devel ];
  };

  "libgcrypt" = fetch {
    pname       = "libgcrypt";
    version     = "1.8.4";
    srcs        = [{ filename = "libgcrypt-1.8.4-1-i686.pkg.tar.xz"; sha256 = "04345b0bbb8fc83e873793e298f431e02027177321222ff0e7c723bb120abb60"; }];
    buildInputs = [ libgpg-error ];
  };

  "libgcrypt-devel" = fetch {
    pname       = "libgcrypt-devel";
    version     = "1.8.4";
    srcs        = [{ filename = "libgcrypt-devel-1.8.4-1-i686.pkg.tar.xz"; sha256 = "4d68efc47342c94e1314cb4fc9e180cbb8b7abea1fd08045a919cbd23cebf351"; }];
    buildInputs = [ (assert libgcrypt.version=="1.8.4"; libgcrypt) libgpg-error-devel ];
  };

  "libgdbm" = fetch {
    pname       = "libgdbm";
    version     = "1.18.1";
    srcs        = [{ filename = "libgdbm-1.18.1-1-i686.pkg.tar.xz"; sha256 = "8a40fba3568b4fdd3351422323550b5b65efdae846391c1694f659730ce56b99"; }];
    buildInputs = [ gcc-libs libreadline ];
  };

  "libgdbm-devel" = fetch {
    pname       = "libgdbm-devel";
    version     = "1.18.1";
    srcs        = [{ filename = "libgdbm-devel-1.18.1-1-i686.pkg.tar.xz"; sha256 = "5cbc03d5759087a3f24d504ae5d86d876b2d798f2e889d7be2e36348e58b93f4"; }];
    buildInputs = [ (assert libgdbm.version=="1.18.1"; libgdbm) libreadline-devel ];
  };

  "libgettextpo" = fetch {
    pname       = "libgettextpo";
    version     = "0.19.8.1";
    srcs        = [{ filename = "libgettextpo-0.19.8.1-1-i686.pkg.tar.xz"; sha256 = "fb141d421dfdfdef6f7a49504c2574d23cf59409a9f9d69da80572f8c442c0ed"; }];
    buildInputs = [ gcc-libs ];
  };

  "libgnutls" = fetch {
    pname       = "libgnutls";
    version     = "3.6.5";
    srcs        = [{ filename = "libgnutls-3.6.5-2-i686.pkg.tar.xz"; sha256 = "9ed4ae729411cbd403ede30eefcb7264fc9583f4adb215d71ec560d15d5e926e"; }];
    buildInputs = [ gcc-libs libidn2 libiconv libintl gmp libnettle libp11-kit libtasn1 zlib ];
  };

  "libgnutls-devel" = fetch {
    pname       = "libgnutls-devel";
    version     = "3.6.5";
    srcs        = [{ filename = "libgnutls-devel-3.6.5-2-i686.pkg.tar.xz"; sha256 = "ec3baea9ade1ffc3f2581ce14534a992d0bb2ed9a601c884562ec826180b35b9"; }];
    buildInputs = [ (assert libgnutls.version=="3.6.5"; libgnutls) ];
  };

  "libgpg-error" = fetch {
    pname       = "libgpg-error";
    version     = "1.32";
    srcs        = [{ filename = "libgpg-error-1.32-1-i686.pkg.tar.xz"; sha256 = "ebc439e1c94429035f2c8b23439b31c6603b64037790f6cb7535227da4b1f2d2"; }];
    buildInputs = [ msys2-runtime sh libiconv libintl ];
  };

  "libgpg-error-devel" = fetch {
    pname       = "libgpg-error-devel";
    version     = "1.32";
    srcs        = [{ filename = "libgpg-error-devel-1.32-1-i686.pkg.tar.xz"; sha256 = "31c21a206939e815b0fa8ac84762dd5f5df6b4385023cead998f8f6092cb1dd5"; }];
    buildInputs = [ libiconv-devel gettext-devel ];
  };

  "libgpgme" = fetch {
    pname       = "libgpgme";
    version     = "1.12.0";
    srcs        = [{ filename = "libgpgme-1.12.0-1-i686.pkg.tar.xz"; sha256 = "e13737e40010948a15b740e95dce13e14608967b6961df517545ddfe94edcbd9"; }];
    buildInputs = [ libassuan libgpg-error gnupg ];
  };

  "libgpgme-devel" = fetch {
    pname       = "libgpgme-devel";
    version     = "1.12.0";
    srcs        = [{ filename = "libgpgme-devel-1.12.0-1-i686.pkg.tar.xz"; sha256 = "02282a7e6d194e3cb70ca7e77b0ee1d44369f9b690b75d915ad623fe59d72b99"; }];
    buildInputs = [ (assert libgpgme.version=="1.12.0"; libgpgme) libassuan-devel libgpg-error-devel ];
  };

  "libgpgme-python2" = fetch {
    pname       = "libgpgme-python2";
    version     = "1.12.0";
    srcs        = [{ filename = "libgpgme-python2-1.12.0-1-i686.pkg.tar.xz"; sha256 = "1e27cdb0a1989dc16b3a8901e9b0c68a13ecb75b40ef7f2af73b8f5873fc9230"; }];
    buildInputs = [ (assert libgpgme.version=="1.12.0"; libgpgme) python2 ];
  };

  "libgpgme-python3" = fetch {
    pname       = "libgpgme-python3";
    version     = "1.12.0";
    srcs        = [{ filename = "libgpgme-python3-1.12.0-1-i686.pkg.tar.xz"; sha256 = "a13d78e86542d5caa014fddf19d37d0bea2df24e1c332207a2a1c153fb98d65e"; }];
    buildInputs = [ (assert libgpgme.version=="1.12.0"; libgpgme) python3 ];
  };

  "libguile" = fetch {
    pname       = "libguile";
    version     = "2.2.4";
    srcs        = [{ filename = "libguile-2.2.4-2-i686.pkg.tar.xz"; sha256 = "692da94b61c6f5c1ea54f152dcd26cf1180a7be39821d1bccf075e6d146025e2"; }];
    buildInputs = [ gmp libltdl ncurses libunistring libgc libffi ];
  };

  "libguile-devel" = fetch {
    pname       = "libguile-devel";
    version     = "2.2.4";
    srcs        = [{ filename = "libguile-devel-2.2.4-2-i686.pkg.tar.xz"; sha256 = "519cc3ed1e7c1537d3f53cb2a6f5be2a5746385fab932f513b57327a8dce2746"; }];
    buildInputs = [ (assert libguile.version=="2.2.4"; libguile) ];
  };

  "libhogweed" = fetch {
    pname       = "libhogweed";
    version     = "3.4.1";
    srcs        = [{ filename = "libhogweed-3.4.1-1-i686.pkg.tar.xz"; sha256 = "b69afc3c09b8da0af21f9a9c9e8a0886f0e4fe1b4ef3010cd3008d8bf7c53f31"; }];
    buildInputs = [ gmp ];
  };

  "libiconv" = fetch {
    pname       = "libiconv";
    version     = "1.15";
    srcs        = [{ filename = "libiconv-1.15-1-i686.pkg.tar.xz"; sha256 = "ca5b806b11c804d4465d4b0670ddb1cf1a43b82d84c38d3f8374d36124bb0544"; }];
    buildInputs = [ gcc-libs ];
  };

  "libiconv-devel" = fetch {
    pname       = "libiconv-devel";
    version     = "1.15";
    srcs        = [{ filename = "libiconv-devel-1.15-1-i686.pkg.tar.xz"; sha256 = "5c0ad23939fb9aa7a6b68c742a985c7d37a86310e29de2db09db53bc45bd96df"; }];
    buildInputs = [ (assert libiconv.version=="1.15"; libiconv) ];
  };

  "libidn" = fetch {
    pname       = "libidn";
    version     = "1.35";
    srcs        = [{ filename = "libidn-1.35-1-i686.pkg.tar.xz"; sha256 = "bafa444043bfa8e6dba79db878a4dcf16bca32ed35a29ebf965504c3bcb369ab"; }];
    buildInputs = [ info ];
  };

  "libidn-devel" = fetch {
    pname       = "libidn-devel";
    version     = "1.35";
    srcs        = [{ filename = "libidn-devel-1.35-1-i686.pkg.tar.xz"; sha256 = "2a802810e0b8bc5548d51e4a0897baf4785d6cd8b4500006e005d207ada45455"; }];
    buildInputs = [ (assert libidn.version=="1.35"; libidn) ];
  };

  "libidn2" = fetch {
    pname       = "libidn2";
    version     = "2.1.0";
    srcs        = [{ filename = "libidn2-2.1.0-1-i686.pkg.tar.xz"; sha256 = "4698256bf6f0cbbe4a6ff73c69dc0cb54eb2aeb9d66107f938981a70ff29feaa"; }];
    buildInputs = [ info libunistring ];
  };

  "libidn2-devel" = fetch {
    pname       = "libidn2-devel";
    version     = "2.1.0";
    srcs        = [{ filename = "libidn2-devel-2.1.0-1-i686.pkg.tar.xz"; sha256 = "f20beff7548ca4cbbabfd2abf89286b76ca636e9464e70c5bed4c7a0e80d7408"; }];
    buildInputs = [ (assert libidn2.version=="2.1.0"; libidn2) ];
  };

  "libintl" = fetch {
    pname       = "libintl";
    version     = "0.19.8.1";
    srcs        = [{ filename = "libintl-0.19.8.1-1-i686.pkg.tar.xz"; sha256 = "fa38ff013d43e995d97b6d21825d9059ec38d812b621bbf8c338574498b7d3e8"; }];
    buildInputs = [ gcc-libs libiconv ];
  };

  "libksba" = fetch {
    pname       = "libksba";
    version     = "1.3.5";
    srcs        = [{ filename = "libksba-1.3.5-1-i686.pkg.tar.xz"; sha256 = "2b644c3658b542333ccaa5346e6ccb2d1379099043cde67c5134a77fdb53f2ad"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libksba-devel" = fetch {
    pname       = "libksba-devel";
    version     = "1.3.5";
    srcs        = [{ filename = "libksba-devel-1.3.5-1-i686.pkg.tar.xz"; sha256 = "1d7238d475138f3c445987ba5e54105e754957816e63fc090fa00ea150f93fbc"; }];
    buildInputs = [ (assert libksba.version=="1.3.5"; libksba) libgpg-error-devel ];
  };

  "libltdl" = fetch {
    pname       = "libltdl";
    version     = "2.4.6";
    srcs        = [{ filename = "libltdl-2.4.6-6-i686.pkg.tar.xz"; sha256 = "b8179e9cf8025456e19f2c30b8254d84c80507ce032415da8b0f7c80158c7485"; }];
    buildInputs = [  ];
  };

  "liblz4" = fetch {
    pname       = "liblz4";
    version     = "1.8.3";
    srcs        = [{ filename = "liblz4-1.8.3-1-i686.pkg.tar.xz"; sha256 = "bd1ed4058d876ff2c4cf750b4a2ec4b70645365d19b28be2592c66cec677cf83"; }];
    buildInputs = [ gcc-libs ];
  };

  "liblz4-devel" = fetch {
    pname       = "liblz4-devel";
    version     = "1.8.3";
    srcs        = [{ filename = "liblz4-devel-1.8.3-1-i686.pkg.tar.xz"; sha256 = "768fe28022195a425452d9c9b90cd42beacc91531ae148a5e303054ef86833cf"; }];
    buildInputs = [ (assert liblz4.version=="1.8.3"; liblz4) ];
  };

  "liblzma" = fetch {
    pname       = "liblzma";
    version     = "5.2.4";
    srcs        = [{ filename = "liblzma-5.2.4-1-i686.pkg.tar.xz"; sha256 = "32e0b31531f9795feb9956d0cb37e72491bc230202cb53d93fcc66944f74612b"; }];
    buildInputs = [ sh libiconv gettext ];
  };

  "liblzma-devel" = fetch {
    pname       = "liblzma-devel";
    version     = "5.2.4";
    srcs        = [{ filename = "liblzma-devel-5.2.4-1-i686.pkg.tar.xz"; sha256 = "bfcca2e9d1536968314a78adb8b881ad710384703550f6d2b17c8204f5ddbf76"; }];
    buildInputs = [ (assert liblzma.version=="5.2.4"; liblzma) libiconv-devel gettext-devel ];
  };

  "liblzo2" = fetch {
    pname       = "liblzo2";
    version     = "2.10";
    srcs        = [{ filename = "liblzo2-2.10-2-i686.pkg.tar.xz"; sha256 = "6c0549cb56d3aa7c4f1bab2c2097926d664a83a2ec0a0e9003aa7d7b9d434996"; }];
    buildInputs = [ gcc-libs ];
  };

  "liblzo2-devel" = fetch {
    pname       = "liblzo2-devel";
    version     = "2.10";
    srcs        = [{ filename = "liblzo2-devel-2.10-2-i686.pkg.tar.xz"; sha256 = "a79c0a3cd01ac7442565bde4f835cd21feb9f78a268d7f678cf51da4503a2e58"; }];
    buildInputs = [ (assert liblzo2.version=="2.10"; liblzo2) ];
  };

  "libmetalink" = fetch {
    pname       = "libmetalink";
    version     = "0.1.3";
    srcs        = [{ filename = "libmetalink-0.1.3-2-i686.pkg.tar.xz"; sha256 = "6ebd587068096a2ec2683bf32f8d860a333a7c5da7423426bb42b2a651dea9ba"; }];
    buildInputs = [ msys2-runtime libexpat sh libxml2 ];
  };

  "libmetalink-devel" = fetch {
    pname       = "libmetalink-devel";
    version     = "0.1.3";
    srcs        = [{ filename = "libmetalink-devel-0.1.3-2-i686.pkg.tar.xz"; sha256 = "f400ea1dc2007d200bdbc09db18a69af92ef69d0c5407d7e9f0f6cdf4242b15f"; }];
    buildInputs = [ (assert libmetalink.version=="0.1.3"; libmetalink) libexpat-devel ];
  };

  "libneon" = fetch {
    pname       = "libneon";
    version     = "0.30.2";
    srcs        = [{ filename = "libneon-0.30.2-2-i686.pkg.tar.xz"; sha256 = "bffe187f48d8cf102def98fd0142304554158104e248b06c86d477287730473f"; }];
    buildInputs = [ libexpat openssl ca-certificates ];
  };

  "libneon-devel" = fetch {
    pname       = "libneon-devel";
    version     = "0.30.2";
    srcs        = [{ filename = "libneon-devel-0.30.2-2-i686.pkg.tar.xz"; sha256 = "a839b977727683d2ace1cb6ca36b51cdf8099b55f8d37802ce2265563c0f1b82"; }];
    buildInputs = [ (assert libneon.version=="0.30.2"; libneon) libexpat-devel openssl-devel ];
  };

  "libnettle" = fetch {
    pname       = "libnettle";
    version     = "3.4.1";
    srcs        = [{ filename = "libnettle-3.4.1-1-i686.pkg.tar.xz"; sha256 = "9baba1199c145c566914d44dfdd97304dfc6a71cee7496901813aa2f73581665"; }];
    buildInputs = [ libhogweed ];
  };

  "libnettle-devel" = fetch {
    pname       = "libnettle-devel";
    version     = "3.4.1";
    srcs        = [{ filename = "libnettle-devel-3.4.1-1-i686.pkg.tar.xz"; sha256 = "85e8bd9599d79cd84f9ba7b390228d152c946abdde1cc72157f3db538109f234"; }];
    buildInputs = [ (assert libnettle.version=="3.4.1"; libnettle) (assert libhogweed.version=="3.4.1"; libhogweed) gmp-devel ];
  };

  "libnghttp2" = fetch {
    pname       = "libnghttp2";
    version     = "1.35.1";
    srcs        = [{ filename = "libnghttp2-1.35.1-1-i686.pkg.tar.xz"; sha256 = "c0822cbab5cb055d5ae37c481d0e54d9fce2547144dde4a47d20975bcace65b4"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnghttp2-devel" = fetch {
    pname       = "libnghttp2-devel";
    version     = "1.35.1";
    srcs        = [{ filename = "libnghttp2-devel-1.35.1-1-i686.pkg.tar.xz"; sha256 = "9a89d28b2cd0f1d24781e8a2d6f6f1691e42267db4c5326822849a084985edec"; }];
    buildInputs = [ (assert libnghttp2.version=="1.35.1"; libnghttp2) jansson-devel libevent-devel openssl-devel libcares-devel ];
  };

  "libnpth" = fetch {
    pname       = "libnpth";
    version     = "1.6";
    srcs        = [{ filename = "libnpth-1.6-1-i686.pkg.tar.xz"; sha256 = "d59aa0320f78cf66c9626bea717cba5bb8b4ec89998d43c11852dd965332ca49"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnpth-devel" = fetch {
    pname       = "libnpth-devel";
    version     = "1.6";
    srcs        = [{ filename = "libnpth-devel-1.6-1-i686.pkg.tar.xz"; sha256 = "91ccbbe63bc797e1fcc89711a0ed6b620d1b5f4fe2736f11dc1b315ec0d7283c"; }];
    buildInputs = [ (assert libnpth.version=="1.6"; libnpth) ];
  };

  "libopenssl" = fetch {
    pname       = "libopenssl";
    version     = "1.1.1.a";
    srcs        = [{ filename = "libopenssl-1.1.1.a-1-i686.pkg.tar.xz"; sha256 = "dfb0a82171f1ca8ee24b464a21ddd318c15a2bb5d879c82cc0cc7881c8f92ab4"; }];
    buildInputs = [ zlib ];
  };

  "libp11-kit" = fetch {
    pname       = "libp11-kit";
    version     = "0.23.14";
    srcs        = [{ filename = "libp11-kit-0.23.14-1-i686.pkg.tar.xz"; sha256 = "9d2caf991614565ee9c52befd0a983dacd0859789d888e3028f0b8412028a3a4"; }];
    buildInputs = [ libffi libintl libtasn1 glib2 ];
  };

  "libp11-kit-devel" = fetch {
    pname       = "libp11-kit-devel";
    version     = "0.23.14";
    srcs        = [{ filename = "libp11-kit-devel-0.23.14-1-i686.pkg.tar.xz"; sha256 = "9df1a551f80a8c6afae247c75bcc1fab55c22414719d6977591791d193f22d66"; }];
    buildInputs = [ (assert libp11-kit.version=="0.23.14"; libp11-kit) ];
  };

  "libpcre" = fetch {
    pname       = "libpcre";
    version     = "8.42";
    srcs        = [{ filename = "libpcre-8.42-1-i686.pkg.tar.xz"; sha256 = "49b2d7cdb941963d915962d12f5d2fec3203070db7c1ec3ecfec916fe067f9a6"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre16" = fetch {
    pname       = "libpcre16";
    version     = "8.42";
    srcs        = [{ filename = "libpcre16-8.42-1-i686.pkg.tar.xz"; sha256 = "7096db1268ce18ad2f13892d200cb49a5f9a9fec1eaa295e2f0b2c41d76babc8"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_16" = fetch {
    pname       = "libpcre2_16";
    version     = "10.32";
    srcs        = [{ filename = "libpcre2_16-10.32-1-i686.pkg.tar.xz"; sha256 = "066846cbd0f7419503ace3baeb0c423e2ddf6cee5f7f9cd7a36e4c5d9b1d5e48"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_32" = fetch {
    pname       = "libpcre2_32";
    version     = "10.32";
    srcs        = [{ filename = "libpcre2_32-10.32-1-i686.pkg.tar.xz"; sha256 = "a98e29cc227bc3c31edf128a0f35c6faeefa6e82a3f4aedfc60af947ca705c34"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_8" = fetch {
    pname       = "libpcre2_8";
    version     = "10.32";
    srcs        = [{ filename = "libpcre2_8-10.32-1-i686.pkg.tar.xz"; sha256 = "1cf1b7bd8cb4aa33be82773cfccc453b181c9ebf0880b1b2300b91e270b2b6c9"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2posix" = fetch {
    pname       = "libpcre2posix";
    version     = "10.32";
    srcs        = [{ filename = "libpcre2posix-10.32-1-i686.pkg.tar.xz"; sha256 = "b6a11f1b343ec29df3c42339df236b7653ebd076ca679405980adee9595cbfd0"; }];
    buildInputs = [ (assert libpcre2_8.version=="10.32"; libpcre2_8) ];
  };

  "libpcre32" = fetch {
    pname       = "libpcre32";
    version     = "8.42";
    srcs        = [{ filename = "libpcre32-8.42-1-i686.pkg.tar.xz"; sha256 = "104a8821ce2ed854ebf3851d7753ca352ee40c666f21da428ab0621181b2d406"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcrecpp" = fetch {
    pname       = "libpcrecpp";
    version     = "8.42";
    srcs        = [{ filename = "libpcrecpp-8.42-1-i686.pkg.tar.xz"; sha256 = "f5d1fc7f97ad63d9797e27c84fc9289704a4a1d99f07569454cffaff4cc08337"; }];
    buildInputs = [ libpcre gcc-libs ];
  };

  "libpcreposix" = fetch {
    pname       = "libpcreposix";
    version     = "8.42";
    srcs        = [{ filename = "libpcreposix-8.42-1-i686.pkg.tar.xz"; sha256 = "36e568a742efb8e9ec550323c3e02e3571c4c3a15c1beff742dbd956c5163465"; }];
    buildInputs = [ libpcre ];
  };

  "libpipeline" = fetch {
    pname       = "libpipeline";
    version     = "1.5.0";
    srcs        = [{ filename = "libpipeline-1.5.0-1-i686.pkg.tar.xz"; sha256 = "71e426c60cfda287abcecfaa7a28b9993755613c6c6e2ba717395de9e0c6a900"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpipeline-devel" = fetch {
    pname       = "libpipeline-devel";
    version     = "1.5.0";
    srcs        = [{ filename = "libpipeline-devel-1.5.0-1-i686.pkg.tar.xz"; sha256 = "a0f7d54f1a38a5979974f8d4c658c8d56e8da2f3d30ab9823391c031ba49eb11"; }];
    buildInputs = [ (assert libpipeline.version=="1.5.0"; libpipeline) ];
  };

  "libpsl" = fetch {
    pname       = "libpsl";
    version     = "0.20.2";
    srcs        = [{ filename = "libpsl-0.20.2-2-i686.pkg.tar.xz"; sha256 = "9edcfa3a20cf1937699ad97f8de7d617034fbf710a0c8bf7f7793fb79c5cf56b"; }];
    buildInputs = [ libxslt libidn2 libunistring ];
  };

  "libpsl-devel" = fetch {
    pname       = "libpsl-devel";
    version     = "0.20.2";
    srcs        = [{ filename = "libpsl-devel-0.20.2-2-i686.pkg.tar.xz"; sha256 = "e793e1b168c086d5564cbf38d4041ddb043288ae809d3d2769a568cf90b61684"; }];
    buildInputs = [ (assert libpsl.version=="0.20.2"; libpsl) libxslt libidn2-devel libunistring ];
  };

  "libqrencode-git" = fetch {
    pname       = "libqrencode-git";
    version     = "v3.4.3.r243.g1ef82bd";
    srcs        = [{ filename = "libqrencode-git-v3.4.3.r243.g1ef82bd-1-i686.pkg.tar.xz"; sha256 = "021461cb13fd89c5bc255bb0168739be2e5e69dc50e93ce00d29907020a9229a"; }];
  };

  "libreadline" = fetch {
    pname       = "libreadline";
    version     = "7.0.005";
    srcs        = [{ filename = "libreadline-7.0.005-1-i686.pkg.tar.xz"; sha256 = "43914c6e752810b53504f7fe24bbcef7c1dc540e1103b9cf8fe4d55580c3481c"; }];
    buildInputs = [ ncurses ];
  };

  "libreadline-devel" = fetch {
    pname       = "libreadline-devel";
    version     = "7.0.005";
    srcs        = [{ filename = "libreadline-devel-7.0.005-1-i686.pkg.tar.xz"; sha256 = "18624860ecfe04f82038849320a9af460105bf68f149ff725a310a8c4ab27f0f"; }];
    buildInputs = [ (assert libreadline.version=="7.0.005"; libreadline) ncurses-devel ];
  };

  "librhash" = fetch {
    pname       = "librhash";
    version     = "1.3.6";
    srcs        = [{ filename = "librhash-1.3.6-2-i686.pkg.tar.xz"; sha256 = "a1e94a1a36658a8dc20e3913da899b9a7d8cc84aca21c77b583c11ed2856219e"; }];
    buildInputs = [ libopenssl gcc-libs ];
  };

  "librhash-devel" = fetch {
    pname       = "librhash-devel";
    version     = "1.3.6";
    srcs        = [{ filename = "librhash-devel-1.3.6-2-i686.pkg.tar.xz"; sha256 = "f843e7d515c5ce78fd2bb32585479eb649cf296c60d69b4fee5c9ac2864f668a"; }];
    buildInputs = [ (assert librhash.version=="1.3.6"; librhash) ];
  };

  "libsasl" = fetch {
    pname       = "libsasl";
    version     = "2.1.27";
    srcs        = [{ filename = "libsasl-2.1.27-1-i686.pkg.tar.xz"; sha256 = "54018b1ce1e9e8ea1be6a3a99a3bd92b380bbf7e51ee098685182ca01b489540"; }];
    buildInputs = [ libcrypt libopenssl heimdal-libs libsqlite ];
  };

  "libsasl-devel" = fetch {
    pname       = "libsasl-devel";
    version     = "2.1.27";
    srcs        = [{ filename = "libsasl-devel-2.1.27-1-i686.pkg.tar.xz"; sha256 = "e7cf60ff779ce6a8e5b7148c7821dd9dca0153be8e32db15f2dd75517fc5220c"; }];
    buildInputs = [ (assert libsasl.version=="2.1.27"; libsasl) heimdal-devel openssl-devel libsqlite-devel libcrypt-devel ];
  };

  "libserf" = fetch {
    pname       = "libserf";
    version     = "1.3.9";
    srcs        = [{ filename = "libserf-1.3.9-3-i686.pkg.tar.xz"; sha256 = "7af3b958ea017d98e7357092b65b7d714e2bcb98f646940621734355fb41a608"; }];
    buildInputs = [ apr-util libopenssl zlib ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "libserf-devel" = fetch {
    pname       = "libserf-devel";
    version     = "1.3.9";
    srcs        = [{ filename = "libserf-devel-1.3.9-3-i686.pkg.tar.xz"; sha256 = "02af48c55b8bf3efbfb0d7ef7bdc05b21a95e0000c0fef1070cc7c2f4ec7a31d"; }];
    buildInputs = [ (assert libserf.version=="1.3.9"; libserf) apr-util-devel openssl-devel zlib-devel ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "libsqlite" = fetch {
    pname       = "libsqlite";
    version     = "3.21.0";
    srcs        = [{ filename = "libsqlite-3.21.0-4-i686.pkg.tar.xz"; sha256 = "457c603bee41c85b7831fbf22a9cf9bbfa4249da8b6e45098932919b93ff0bb2"; }];
    buildInputs = [ libreadline (assert stdenvNoCC.lib.versionAtLeast icu.version "59.1"; icu) zlib ];
  };

  "libsqlite-devel" = fetch {
    pname       = "libsqlite-devel";
    version     = "3.21.0";
    srcs        = [{ filename = "libsqlite-devel-3.21.0-4-i686.pkg.tar.xz"; sha256 = "8c200f0c54967733135d7bb8c60e5bb06ec81be13cf9bd7a5aedb75aeaecb453"; }];
    buildInputs = [ (assert libsqlite.version=="3.21.0"; libsqlite) ];
  };

  "libssh2" = fetch {
    pname       = "libssh2";
    version     = "1.8.0";
    srcs        = [{ filename = "libssh2-1.8.0-2-i686.pkg.tar.xz"; sha256 = "7443e2cff400e1bf0e24c8a9fa2bb7d8b960a9e854887d32fdeb3753cd8361c2"; }];
    buildInputs = [ ca-certificates openssl zlib ];
  };

  "libssh2-devel" = fetch {
    pname       = "libssh2-devel";
    version     = "1.8.0";
    srcs        = [{ filename = "libssh2-devel-1.8.0-2-i686.pkg.tar.xz"; sha256 = "7b1f3a52a03b69eda4c1929072fde7626a2d662fc1e1c9f79dd16756bff7cb28"; }];
    buildInputs = [ (assert libssh2.version=="1.8.0"; libssh2) openssl-devel zlib-devel ];
  };

  "libtasn1" = fetch {
    pname       = "libtasn1";
    version     = "4.13";
    srcs        = [{ filename = "libtasn1-4.13-1-i686.pkg.tar.xz"; sha256 = "61154febb0d5d3698f9d4aa6902b360e1e60ac4d7004ae044845ab98967f5d16"; }];
    buildInputs = [ info ];
  };

  "libtasn1-devel" = fetch {
    pname       = "libtasn1-devel";
    version     = "4.13";
    srcs        = [{ filename = "libtasn1-devel-4.13-1-i686.pkg.tar.xz"; sha256 = "225a6acd4ed7c6bef8f6b745ea3813d77f2cb42dd3bece6dc4b62ed4352aac05"; }];
    buildInputs = [ (assert libtasn1.version=="4.13"; libtasn1) ];
  };

  "libtirpc" = fetch {
    pname       = "libtirpc";
    version     = "1.1.4";
    srcs        = [{ filename = "libtirpc-1.1.4-1-i686.pkg.tar.xz"; sha256 = "e39430a2680d43e8facd30aa3c55365883ec0441c2147071a5347678c5f3cb52"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "libtirpc-devel" = fetch {
    pname       = "libtirpc-devel";
    version     = "1.1.4";
    srcs        = [{ filename = "libtirpc-devel-1.1.4-1-i686.pkg.tar.xz"; sha256 = "d236bf3379bbf6eb162c2d3fabd47ed0c65795f5754717b386f3aee84d6a3937"; }];
    buildInputs = [ (assert libtirpc.version=="1.1.4"; libtirpc) ];
  };

  "libtool" = fetch {
    pname       = "libtool";
    version     = "2.4.6";
    srcs        = [{ filename = "libtool-2.4.6-6-i686.pkg.tar.xz"; sha256 = "ccf5d5241b84c55698a42635008ae46c94ed89388ed2d099aac4ff0a5473b4ec"; }];
    buildInputs = [ sh (assert libltdl.version=="2.4.6"; libltdl) tar ];
  };

  "libtre-devel-git" = fetch {
    pname       = "libtre-devel-git";
    version     = "0.8.0.128.6fb7206";
    srcs        = [{ filename = "libtre-devel-git-0.8.0.128.6fb7206-1-i686.pkg.tar.xz"; sha256 = "7e4f18965f5de807a93f5963da5fffbf41217d8137349b622d7b48dfd5c36267"; }];
    buildInputs = [ (assert libtre-git.version=="0.8.0.128.6fb7206"; libtre-git) gettext-devel libiconv-devel ];
  };

  "libtre-git" = fetch {
    pname       = "libtre-git";
    version     = "0.8.0.128.6fb7206";
    srcs        = [{ filename = "libtre-git-0.8.0.128.6fb7206-1-i686.pkg.tar.xz"; sha256 = "e23d0dfb5ad557105891419855d7586b660b15b3c6e9ce69e8f246d7229b8d8e"; }];
    buildInputs = [ gettext libiconv libintl ];
  };

  "libunistring" = fetch {
    pname       = "libunistring";
    version     = "0.9.10";
    srcs        = [{ filename = "libunistring-0.9.10-1-i686.pkg.tar.xz"; sha256 = "63bc3857f4144c77c8b844067b49ca2a7b344b346ce3d8d982a92527efdd8403"; }];
    buildInputs = [ msys2-runtime libiconv ];
  };

  "libunistring-devel" = fetch {
    pname       = "libunistring-devel";
    version     = "0.9.10";
    srcs        = [{ filename = "libunistring-devel-0.9.10-1-i686.pkg.tar.xz"; sha256 = "506c698ec4f4f08d9c1f02f83fb23dc241920f79bc347e7ad5b2db69bc10937f"; }];
    buildInputs = [ (assert libunistring.version=="0.9.10"; libunistring) libiconv-devel ];
  };

  "libunrar" = fetch {
    pname       = "libunrar";
    version     = "5.6.8";
    srcs        = [{ filename = "libunrar-5.6.8-1-i686.pkg.tar.xz"; sha256 = "caafa43ff116c1af027be7b7ec1c8ab118e76c91a508930ca8402ff2901c0fe0"; }];
    buildInputs = [ gcc-libs ];
  };

  "libunrar-devel" = fetch {
    pname       = "libunrar-devel";
    version     = "5.6.8";
    srcs        = [{ filename = "libunrar-devel-5.6.8-1-i686.pkg.tar.xz"; sha256 = "6279fd8b5881e210e36ef05a8bf07476cb264d9ffc723290f487c4c547f98d40"; }];
    buildInputs = [ libunrar ];
  };

  "libutil-linux" = fetch {
    pname       = "libutil-linux";
    version     = "2.32.1";
    srcs        = [{ filename = "libutil-linux-2.32.1-1-i686.pkg.tar.xz"; sha256 = "45ecaab105598582b34b43a91f7e617ecbb523dbcd6ffad62c51706c51c56a08"; }];
    buildInputs = [ gcc-libs libintl msys2-runtime ];
  };

  "libutil-linux-devel" = fetch {
    pname       = "libutil-linux-devel";
    version     = "2.32.1";
    srcs        = [{ filename = "libutil-linux-devel-2.32.1-1-i686.pkg.tar.xz"; sha256 = "57244d6aecd9a8f8ffc2f595b0de0aa759a2ba7918cd3fd9432410541bc324f4"; }];
    buildInputs = [ libutil-linux ];
  };

  "libuv" = fetch {
    pname       = "libuv";
    version     = "1.24.1";
    srcs        = [{ filename = "libuv-1.24.1-1-i686.pkg.tar.xz"; sha256 = "c9f38c79b7f0e062917ad592e70c96640798d41068c2de804a8988d8d344ebf0"; }];
    buildInputs = [ gcc-libs ];
  };

  "libuv-devel" = fetch {
    pname       = "libuv-devel";
    version     = "1.24.1";
    srcs        = [{ filename = "libuv-devel-1.24.1-1-i686.pkg.tar.xz"; sha256 = "3ff1814a2c3303880de1726212556d3d1bceaed99bfc4a43fa76ed9caca7f5b3"; }];
    buildInputs = [ (assert libuv.version=="1.24.1"; libuv) ];
  };

  "libxml2" = fetch {
    pname       = "libxml2";
    version     = "2.9.8";
    srcs        = [{ filename = "libxml2-2.9.8-1-i686.pkg.tar.xz"; sha256 = "6d1f61e40a1263248e95ab3078ab2135028170fe0bdeecaa00b508e14b9055a3"; }];
    buildInputs = [ coreutils (assert stdenvNoCC.lib.versionAtLeast icu.version "59.1"; icu) liblzma libreadline ncurses zlib ];
  };

  "libxml2-devel" = fetch {
    pname       = "libxml2-devel";
    version     = "2.9.8";
    srcs        = [{ filename = "libxml2-devel-2.9.8-1-i686.pkg.tar.xz"; sha256 = "c7610c2b26c4965ee0d3b936ab5b22ac31d77a55ef5dcd558ea3981da5c3c9de"; }];
    buildInputs = [ (assert libxml2.version=="2.9.8"; libxml2) (assert stdenvNoCC.lib.versionAtLeast icu-devel.version "59.1"; icu-devel) libreadline-devel ncurses-devel liblzma-devel zlib-devel ];
  };

  "libxml2-python" = fetch {
    pname       = "libxml2-python";
    version     = "2.9.8";
    srcs        = [{ filename = "libxml2-python-2.9.8-1-i686.pkg.tar.xz"; sha256 = "0153e5d63628adbdd31a4aa670f2cfaa74da0225db0ab1bf2b979866ba33e9e2"; }];
    buildInputs = [ libxml2 ];
  };

  "libxslt" = fetch {
    pname       = "libxslt";
    version     = "1.1.32";
    srcs        = [{ filename = "libxslt-1.1.32-1-i686.pkg.tar.xz"; sha256 = "9478655234cdce9ec816a479f7452e59ea7a697f60b4fd2d8259b5efe4ffaea9"; }];
    buildInputs = [ libxml2 libgcrypt ];
  };

  "libxslt-devel" = fetch {
    pname       = "libxslt-devel";
    version     = "1.1.32";
    srcs        = [{ filename = "libxslt-devel-1.1.32-1-i686.pkg.tar.xz"; sha256 = "45c48842cd60faf857b563a9193c77298ecd64cfb68b1ac93eb1bb1b18ee1de7"; }];
    buildInputs = [ (assert libxslt.version=="1.1.32"; libxslt) libxml2-devel libgcrypt-devel ];
  };

  "libxslt-python" = fetch {
    pname       = "libxslt-python";
    version     = "1.1.32";
    srcs        = [{ filename = "libxslt-python-1.1.32-1-i686.pkg.tar.xz"; sha256 = "6d85436af8874a038fdf3625c901a3f0551a1f6e9ad9003f70f07d331ec40f76"; }];
    buildInputs = [ (assert libxslt.version=="1.1.32"; libxslt) python2 ];
  };

  "libyaml" = fetch {
    pname       = "libyaml";
    version     = "0.2.1";
    srcs        = [{ filename = "libyaml-0.2.1-1-i686.pkg.tar.xz"; sha256 = "bfb5d36b1f65b4ce034f53063cd4d67e2fca9d2c429e7acb415cde6d311c0f52"; }];
    buildInputs = [  ];
  };

  "libyaml-devel" = fetch {
    pname       = "libyaml-devel";
    version     = "0.2.1";
    srcs        = [{ filename = "libyaml-devel-0.2.1-1-i686.pkg.tar.xz"; sha256 = "467cc997cb95f6bc77594a22cf18cb954e5399ce03f54fa895310e9e4c285791"; }];
    buildInputs = [ (assert libyaml.version=="0.2.1"; libyaml) ];
  };

  "lld-svn" = fetch {
    pname       = "lld-svn";
    version     = "4595.9883dc1";
    srcs        = [{ filename = "lld-svn-4595.9883dc1-1-i686.pkg.tar.xz"; sha256 = "92522536e74e2a0639a997c8ac4612da2de91087972ed7d8cf13f1f3d0cc5e24"; }];
    buildInputs = [ llvm-svn ];
  };

  "llvm-svn" = fetch {
    pname       = "llvm-svn";
    version     = "124592.aef50ac";
    srcs        = [{ filename = "llvm-svn-124592.aef50ac-1-i686.pkg.tar.xz"; sha256 = "9f8cf8613da4604ae9baf6d27b0164aec8b638a569a466c132ab05cd72d72e9e"; }];
    buildInputs = [ gcc libffi libxml2 ];
  };

  "lndir" = fetch {
    pname       = "lndir";
    version     = "1.0.3";
    srcs        = [{ filename = "lndir-1.0.3-1-i686.pkg.tar.xz"; sha256 = "16b61c8365b09c91965fbd28507e4ca4d9c18fcc762c0a51d79ac558081b1682"; }];
  };

  "lz4" = fetch {
    pname       = "lz4";
    version     = "1.8.3";
    srcs        = [{ filename = "lz4-1.8.3-1-i686.pkg.tar.xz"; sha256 = "7d50114b5da912f2161d0793f736c624186df8f71089c76d6c99864ab53703ed"; }];
    buildInputs = [ gcc-libs (assert lz4.version=="1.8.3"; lz4) ];
  };

  "lzip" = fetch {
    pname       = "lzip";
    version     = "1.20";
    srcs        = [{ filename = "lzip-1.20-1-i686.pkg.tar.xz"; sha256 = "2353105043d06136495e9cdea703b870517efd297ad1c905ab090b27eb9b6054"; }];
    buildInputs = [ gcc-libs ];
  };

  "m4" = fetch {
    pname       = "m4";
    version     = "1.4.18";
    srcs        = [{ filename = "m4-1.4.18-2-i686.pkg.tar.xz"; sha256 = "92cd3f1dbea2053a22cc971c080e9431d8e1c3d54804e4cf7a5caa41090ac0db"; }];
    buildInputs = [ bash gcc-libs msys2-runtime ];
  };

  "make" = fetch {
    pname       = "make";
    version     = "4.2.1";
    srcs        = [{ filename = "make-4.2.1-1-i686.pkg.tar.xz"; sha256 = "205e59f4d521d866a75bdf6486ac6aae61401a86f77a2a9b31c53f9b6ef3c7ef"; }];
    buildInputs = [ msys2-runtime libintl sh ];
  };

  "make-git" = fetch {
    pname       = "make-git";
    version     = "4.1.8.g292da6f";
    srcs        = [{ filename = "make-git-4.1.8.g292da6f-1-i686.pkg.tar.xz"; sha256 = "23f26536aa65875fb650005f603bc53d957c1df94863df43ad4005e80f61ca85"; }];
  };

  "man-db" = fetch {
    pname       = "man-db";
    version     = "2.8.4";
    srcs        = [{ filename = "man-db-2.8.4-1-i686.pkg.tar.xz"; sha256 = "5413fb79eb8c19fe077ddcc0c07e7e1c641f35f7372cdc63705ebc601041bbf7"; }];
    buildInputs = [ bash gdbm zlib groff libpipeline less ];
  };

  "man-pages-posix" = fetch {
    pname       = "man-pages-posix";
    version     = "2013_a";
    srcs        = [{ filename = "man-pages-posix-2013_a-1-any.pkg.tar.xz"; sha256 = "3ee3c731d02d4771ee0d63cbc308fac506bc6a9568678fa8644e07372b07c36e"; }];
  };

  "markdown" = fetch {
    pname       = "markdown";
    version     = "1.0.1";
    srcs        = [{ filename = "markdown-1.0.1-1-i686.pkg.tar.xz"; sha256 = "3223ec3ed8880c31191b8f62ba69457629191368abdbb2e9437be1cac49b6eb4"; }];
  };

  "mc" = fetch {
    pname       = "mc";
    version     = "4.8.21";
    srcs        = [{ filename = "mc-4.8.21-1-i686.pkg.tar.xz"; sha256 = "4b2371cd32274ccf7b7f1d3c2a99e69af18739b567b9eb0cf6f38579f36bdf87"; }];
    buildInputs = [ glib2 libssh2 ];
  };

  "mercurial" = fetch {
    pname       = "mercurial";
    version     = "4.8.1";
    srcs        = [{ filename = "mercurial-4.8.1-1-i686.pkg.tar.xz"; sha256 = "73210376e063cb9ace82773701aed88ce1a019b74ffe51985089970db65dc0d6"; }];
    buildInputs = [ python2 ];
  };

  "meson" = fetch {
    pname       = "meson";
    version     = "0.49.0";
    srcs        = [{ filename = "meson-0.49.0-1-any.pkg.tar.xz"; sha256 = "9e1a6ae03fb3f9fe22b88467e53594e94a71dd3b9088020688bb92e1e953a940"; }];
    buildInputs = [ python3 python3-setuptools ninja ];
  };

  "mingw-w64-cross-binutils" = fetch {
    pname       = "mingw-w64-cross-binutils";
    version     = "2.30";
    srcs        = [{ filename = "mingw-w64-cross-binutils-2.30-1-i686.pkg.tar.xz"; sha256 = "9cb8e76b75f361c6fef64a30aa5f7c81bbd47368a60195b3daa7350c0c4004ff"; }];
    buildInputs = [ libiconv zlib ];
  };

  "mingw-w64-cross-crt-git" = fetch {
    pname       = "mingw-w64-cross-crt-git";
    version     = "6.0.0.5223.7f9d8753";
    srcs        = [{ filename = "mingw-w64-cross-crt-git-6.0.0.5223.7f9d8753-1-i686.pkg.tar.xz"; sha256 = "c7548927ac95baf042ece9748720c7ce92b0d1226462533504bedac76760ef85"; }];
    buildInputs = [ mingw-w64-cross-headers-git ];
  };

  "mingw-w64-cross-gcc" = fetch {
    pname       = "mingw-w64-cross-gcc";
    version     = "7.3.0";
    srcs        = [{ filename = "mingw-w64-cross-gcc-7.3.0-2-i686.pkg.tar.xz"; sha256 = "f3848d1b4e47bf4d886eac026013bcfe612cdff9a0a2514af1c83fc5d14761e4"; }];
    buildInputs = [ zlib mpc isl mingw-w64-cross-binutils mingw-w64-cross-crt-git mingw-w64-cross-headers-git mingw-w64-cross-winpthreads-git mingw-w64-cross-windows-default-manifest ];
  };

  "mingw-w64-cross-headers-git" = fetch {
    pname       = "mingw-w64-cross-headers-git";
    version     = "6.0.0.5223.7f9d8753";
    srcs        = [{ filename = "mingw-w64-cross-headers-git-6.0.0.5223.7f9d8753-1-i686.pkg.tar.xz"; sha256 = "0ea93319e955f21f8143c09abd396e78a82f54ec5bb12eca7c894a00b5ebeee9"; }];
    buildInputs = [  ];
  };

  "mingw-w64-cross-tools-git" = fetch {
    pname       = "mingw-w64-cross-tools-git";
    version     = "6.0.0.5141.696b37c3";
    srcs        = [{ filename = "mingw-w64-cross-tools-git-6.0.0.5141.696b37c3-1-i686.pkg.tar.xz"; sha256 = "27635fa2bf06b1131cf720969162e100d8b6445ad122b48a05c6cc8cb45f8f1c"; }];
  };

  "mingw-w64-cross-windows-default-manifest" = fetch {
    pname       = "mingw-w64-cross-windows-default-manifest";
    version     = "6.4";
    srcs        = [{ filename = "mingw-w64-cross-windows-default-manifest-6.4-2-i686.pkg.tar.xz"; sha256 = "eeaaba8c5159416bf04e3bca2d256a3c1d80db138260feb8496a186b93d65786"; }];
    buildInputs = [  ];
  };

  "mingw-w64-cross-winpthreads-git" = fetch {
    pname       = "mingw-w64-cross-winpthreads-git";
    version     = "6.0.0.5142.ffa70293";
    srcs        = [{ filename = "mingw-w64-cross-winpthreads-git-6.0.0.5142.ffa70293-1-i686.pkg.tar.xz"; sha256 = "8705318c9d266f1f4480dea6fb7e676d36d03fa082579c9f99494f5929fcac5d"; }];
    buildInputs = [ mingw-w64-cross-crt-git ];
  };

  "mingw-w64-cross-winstorecompat-git" = fetch {
    pname       = "mingw-w64-cross-winstorecompat-git";
    version     = "6.0.0.5099.5e5f06f6";
    srcs        = [{ filename = "mingw-w64-cross-winstorecompat-git-6.0.0.5099.5e5f06f6-1-i686.pkg.tar.xz"; sha256 = "8821ede5e0b582f3ad66e1be368bc39a471f5a1b24f933f7ad87bf924088f15d"; }];
    buildInputs = [ mingw-w64-cross-crt-git ];
  };

  "mingw-w64-cross-zlib" = fetch {
    pname       = "mingw-w64-cross-zlib";
    version     = "1.2.11";
    srcs        = [{ filename = "mingw-w64-cross-zlib-1.2.11-1-i686.pkg.tar.xz"; sha256 = "b3acae5cd274f47b8196ca33b4ce593e5728f3806b2b97a2e2687a3ed851f319"; }];
  };

  "mintty" = fetch {
    pname       = "mintty";
    version     = "1~2.9.5";
    srcs        = [{ filename = "mintty-1~2.9.5-1-i686.pkg.tar.xz"; sha256 = "7e5ad044877a2046b1c805a5834bc755cb22c7b246d52a0be25a79bc7f139948"; }];
    buildInputs = [ sh ];
  };

  "mksh" = fetch {
    pname       = "mksh";
    version     = "56.c";
    srcs        = [{ filename = "mksh-56.c-1-i686.pkg.tar.xz"; sha256 = "c17a5537bce0d654cd11f01b25866f00fb20c7f917231a4a60eef8f24c42418a"; }];
    buildInputs = [ gcc-libs ];
  };

  "moreutils" = fetch {
    pname       = "moreutils";
    version     = "0.62";
    srcs        = [{ filename = "moreutils-0.62-1-i686.pkg.tar.xz"; sha256 = "f12a411990c0a928d0c0c3f48d718b7d041e908713336833da0c793d3f94afb0"; }];
  };

  "mosh" = fetch {
    pname       = "mosh";
    version     = "1.3.2";
    srcs        = [{ filename = "mosh-1.3.2-3-i686.pkg.tar.xz"; sha256 = "fb759acf0a9254c88e7e49c94fb29996f1b6328372f1a2dfff50ecf2a9509cf6"; }];
    buildInputs = [ protobuf ncurses zlib libopenssl openssh perl ];
  };

  "mpc" = fetch {
    pname       = "mpc";
    version     = "1.1.0";
    srcs        = [{ filename = "mpc-1.1.0-1-i686.pkg.tar.xz"; sha256 = "065f5525d770509a0b0534d74ffb8c9ccb8cea7ca95455c9d5acb7e1941afcc4"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gmp.version "5.0"; gmp) mpfr ];
  };

  "mpc-devel" = fetch {
    pname       = "mpc-devel";
    version     = "1.1.0";
    srcs        = [{ filename = "mpc-devel-1.1.0-1-i686.pkg.tar.xz"; sha256 = "d085e3ec6b653026745d6ab53151db8251d9ae8505ff0302d0394850998a7e92"; }];
    buildInputs = [ (assert mpc.version=="1.1.0"; mpc) gmp-devel mpfr-devel ];
  };

  "mpdecimal" = fetch {
    pname       = "mpdecimal";
    version     = "2.4.2";
    srcs        = [{ filename = "mpdecimal-2.4.2-2-i686.pkg.tar.xz"; sha256 = "5390550cde724034c6d79875457e76c22816ca9b98d899b2592260000e46b766"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "mpdecimal-devel" = fetch {
    pname       = "mpdecimal-devel";
    version     = "2.4.2";
    srcs        = [{ filename = "mpdecimal-devel-2.4.2-2-i686.pkg.tar.xz"; sha256 = "a247f76468470be41f9f5699054971fba0383aa17efd879e5094afa50dfb21b8"; }];
    buildInputs = [ (assert mpdecimal.version=="2.4.2"; mpdecimal) ];
  };

  "mpfr" = fetch {
    pname       = "mpfr";
    version     = "4.0.1";
    srcs        = [{ filename = "mpfr-4.0.1-1-i686.pkg.tar.xz"; sha256 = "9cae88c2b83a37e6bba8d8b5b06c8ad1084192c73bad48943cb86efd319b815f"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gmp.version "5.0"; gmp) ];
  };

  "mpfr-devel" = fetch {
    pname       = "mpfr-devel";
    version     = "4.0.1";
    srcs        = [{ filename = "mpfr-devel-4.0.1-1-i686.pkg.tar.xz"; sha256 = "b5502a9d02fa3572125053cfb6b89b9c2f2bbaafd192d000969d65abdbc76b2f"; }];
    buildInputs = [ (assert mpfr.version=="4.0.1"; mpfr) gmp-devel ];
  };

  "msys2-keyring" = fetch {
    pname       = "msys2-keyring";
    version     = "r9.397a52e";
    srcs        = [{ filename = "msys2-keyring-r9.397a52e-1-any.pkg.tar.xz"; sha256 = "9c485984f172055d40a63024b0b622125ed3741bb72288699e537415b7c35a56"; }];
  };

  "msys2-launcher-git" = fetch {
    pname       = "msys2-launcher-git";
    version     = "0.3.32.56c2ba7";
    srcs        = [{ filename = "msys2-launcher-git-0.3.32.56c2ba7-2-i686.pkg.tar.xz"; sha256 = "87c4c2339030dc81e3e87a278cf39f13b07ca4c667a2e1a4e3a3f737744b3e01"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mintty.version "1~2.2.1"; mintty) ];
  };

  "msys2-runtime" = fetch {
    pname       = "msys2-runtime";
    version     = "2.11.2";
    srcs        = [{ filename = "msys2-runtime-2.11.2-1-i686.pkg.tar.xz"; sha256 = "78546dc247d7ac6bf8d00257a81a752683a5606e4bd9de39d3fa6c1ba9709b2a"; }];
    buildInputs = [  ];
  };

  "msys2-runtime-devel" = fetch {
    pname       = "msys2-runtime-devel";
    version     = "2.11.2";
    srcs        = [{ filename = "msys2-runtime-devel-2.11.2-1-i686.pkg.tar.xz"; sha256 = "0a55e911eadb35e8a0cb76ade6afd8e11776632d452e82b47d1b5df794005f4e"; }];
    buildInputs = [ (assert msys2-runtime.version=="2.11.2"; msys2-runtime) ];
  };

  "msys2-w32api-headers" = fetch {
    pname       = "msys2-w32api-headers";
    version     = "6.0.0.5223.7f9d8753";
    srcs        = [{ filename = "msys2-w32api-headers-6.0.0.5223.7f9d8753-1-i686.pkg.tar.xz"; sha256 = "7cb6a24a3c0a2ca47baea56d639da1152c6ef028084fcf9555b2ddddb22b3adc"; }];
    buildInputs = [  ];
  };

  "msys2-w32api-runtime" = fetch {
    pname       = "msys2-w32api-runtime";
    version     = "6.0.0.5223.7f9d8753";
    srcs        = [{ filename = "msys2-w32api-runtime-6.0.0.5223.7f9d8753-1-i686.pkg.tar.xz"; sha256 = "4cab6f2d9140ea1026aee73ad35393de763e2d23827319fa57db6ab554efa7c7"; }];
    buildInputs = [ msys2-w32api-headers ];
  };

  "mutt" = fetch {
    pname       = "mutt";
    version     = "1.11.2";
    srcs        = [{ filename = "mutt-1.11.2-1-i686.pkg.tar.xz"; sha256 = "5c1a840595a89812087bba95780bb403ea5f48f21bfbd3cdeee11730e8d8a811"; }];
    buildInputs = [ libgpgme libsasl libgdbm ncurses libgnutls libidn2 ];
  };

  "nano" = fetch {
    pname       = "nano";
    version     = "3.2";
    srcs        = [{ filename = "nano-3.2-1-i686.pkg.tar.xz"; sha256 = "eb86033e297820313ce7327041b661bf72360256bf27269a56f8a66310b5c1eb"; }];
    buildInputs = [ file libintl ncurses sh ];
  };

  "nano-syntax-highlighting-git" = fetch {
    pname       = "nano-syntax-highlighting-git";
    version     = "299.5e776df";
    srcs        = [{ filename = "nano-syntax-highlighting-git-299.5e776df-1-any.pkg.tar.xz"; sha256 = "a40cdf568363b9e1138fe6a539fe1a2e3890c068be3d15a7180d875d5f4690f5"; }];
    buildInputs = [ nano ];
  };

  "nasm" = fetch {
    pname       = "nasm";
    version     = "2.14.01";
    srcs        = [{ filename = "nasm-2.14.01-1-i686.pkg.tar.xz"; sha256 = "372e8dfce01024b4a020885939c11af6c60b0ca960ddc480911d2df90491002b"; }];
    buildInputs = [ msys2-runtime ];
  };

  "ncurses" = fetch {
    pname       = "ncurses";
    version     = "6.1.20180908";
    srcs        = [{ filename = "ncurses-6.1.20180908-1-i686.pkg.tar.xz"; sha256 = "a9e187816a9088b4c1ce39399928a70cf70475121b2af713d863268479e2d2ee"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "ncurses-devel" = fetch {
    pname       = "ncurses-devel";
    version     = "6.1.20180908";
    srcs        = [{ filename = "ncurses-devel-6.1.20180908-1-i686.pkg.tar.xz"; sha256 = "793f46f0a3d9d9326e181d5ebf8b4a8a4896f741f5d077355d651d8cd8b98f0c"; }];
    buildInputs = [ (assert ncurses.version=="6.1.20180908"; ncurses) ];
  };

  "nettle" = fetch {
    pname       = "nettle";
    version     = "3.4.1";
    srcs        = [{ filename = "nettle-3.4.1-1-i686.pkg.tar.xz"; sha256 = "5294ed18c48e681376cbf7f0ef6e68a6d5d225fd8b3e7ead87284338076f75a1"; }];
    buildInputs = [ libnettle ];
  };

  "nghttp2" = fetch {
    pname       = "nghttp2";
    version     = "1.35.1";
    srcs        = [{ filename = "nghttp2-1.35.1-1-i686.pkg.tar.xz"; sha256 = "9d48bf11562a3ee710653d8350ffd0350a4733b236018833dd79d7d65f3fb166"; }];
    buildInputs = [ gcc-libs jansson (assert libnghttp2.version=="1.35.1"; libnghttp2) ];
  };

  "ninja" = fetch {
    pname       = "ninja";
    version     = "1.8.2";
    srcs        = [{ filename = "ninja-1.8.2-1-any.pkg.tar.xz"; sha256 = "a1251f81ac5dcd3e601453726046d942520d43a12cd95d02111707ed95936182"; }];
    buildInputs = [  ];
  };

  "openbsd-netcat" = fetch {
    pname       = "openbsd-netcat";
    version     = "1.195";
    srcs        = [{ filename = "openbsd-netcat-1.195-1-i686.pkg.tar.xz"; sha256 = "d35de046d5fbe19cd517e4846aff6e52a4536c05db138e65a13eb13ef775a805"; }];
  };

  "openssh" = fetch {
    pname       = "openssh";
    version     = "7.9p1";
    srcs        = [{ filename = "openssh-7.9p1-2-i686.pkg.tar.xz"; sha256 = "b1281634043a04d338ac8852f98062ec391580182da9d689fefe925a0d45022e"; }];
    buildInputs = [ heimdal libedit libcrypt openssl ];
  };

  "openssl" = fetch {
    pname       = "openssl";
    version     = "1.1.1.a";
    srcs        = [{ filename = "openssl-1.1.1.a-1-i686.pkg.tar.xz"; sha256 = "04135720be63d5ff059ca98bded9539c4b2f8cb3b09012c379568bb8318c372b"; }];
    buildInputs = [ libopenssl zlib ];
  };

  "openssl-devel" = fetch {
    pname       = "openssl-devel";
    version     = "1.1.1.a";
    srcs        = [{ filename = "openssl-devel-1.1.1.a-1-i686.pkg.tar.xz"; sha256 = "319cc1c6b77788a66cb98a1596b3cca2f991b310bb5dde31b2845b8ef06457d7"; }];
    buildInputs = [ (assert libopenssl.version=="1.1.1.a"; libopenssl) zlib-devel ];
  };

  "p11-kit" = fetch {
    pname       = "p11-kit";
    version     = "0.23.14";
    srcs        = [{ filename = "p11-kit-0.23.14-1-i686.pkg.tar.xz"; sha256 = "3ddca41e990d80f3bdaf1a91185f7f3f9320ed00d7f4398e7312f5517aa0b101"; }];
    buildInputs = [ (assert libp11-kit.version=="0.23.14"; libp11-kit) ];
  };

  "p7zip" = fetch {
    pname       = "p7zip";
    version     = "16.02";
    srcs        = [{ filename = "p7zip-16.02-1-i686.pkg.tar.xz"; sha256 = "e04caae8053ae6950f04359f3cb7aea93d673b74b7ef220f3a7a2606d73f009a"; }];
    buildInputs = [ gcc-libs bash ];
  };

  "pacman" = fetch {
    pname       = "pacman";
    version     = "5.1.2";
    srcs        = [{ filename = "pacman-5.1.2-2-i686.pkg.tar.xz"; sha256 = "d4645aa9cdd0d710e26fb0385dcc06d4a87a9aa1a7a5eb87e0da37afb0e3c317"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast bash.version "4.2.045"; bash) gettext gnupg msys2-runtime curl pacman-mirrors msys2-keyring which bzip2 xz ];
  };

  "pacman-mirrors" = fetch {
    pname       = "pacman-mirrors";
    version     = "20180604";
    srcs        = [{ filename = "pacman-mirrors-20180604-2-any.pkg.tar.xz"; sha256 = "4ec250211d95a752f642a12ecaf28cd6a50a000bda7a8c2b9ac22767124e2775"; }];
    buildInputs = [  ];
  };

  "pactoys-git" = fetch {
    pname       = "pactoys-git";
    version     = "r2.07ca37f";
    srcs        = [{ filename = "pactoys-git-r2.07ca37f-1-i686.pkg.tar.xz"; sha256 = "46903d1e02fbf9a70944362a8138d88de96758531e5534dcda98e883e8994347"; }];
    buildInputs = [ pacman pkgfile wget ];
    broken      = true; # broken dependency wget -> libuuid
  };

  "parallel" = fetch {
    pname       = "parallel";
    version     = "20180922";
    srcs        = [{ filename = "parallel-20180922-1-any.pkg.tar.xz"; sha256 = "a872ea5b4ea0d5a17add52d0474f5bf49e5b8e357cd126736bf27d65cdc449d5"; }];
    buildInputs = [ perl ];
  };

  "pass" = fetch {
    pname       = "pass";
    version     = "1.7.3";
    srcs        = [{ filename = "pass-1.7.3-1-any.pkg.tar.xz"; sha256 = "7ceca069bc3e42ed0c1f8b98e4a1fb12f1793c93e778ce6da4756b3c58ab2211"; }];
    buildInputs = [ bash gnupg tree ];
  };

  "patch" = fetch {
    pname       = "patch";
    version     = "2.7.6";
    srcs        = [{ filename = "patch-2.7.6-1-i686.pkg.tar.xz"; sha256 = "ab09df9a438856d1dd8991ef4fede80f7d028b4b5231186da1af07e131570478"; }];
    buildInputs = [ msys2-runtime ];
  };

  "patchutils" = fetch {
    pname       = "patchutils";
    version     = "0.3.4";
    srcs        = [{ filename = "patchutils-0.3.4-1-i686.pkg.tar.xz"; sha256 = "710b1136a2a23c66773a2243ab581c8100590c8fee5d771c95ab8c8ab35cd0cb"; }];
    buildInputs = [ msys2-runtime ];
  };

  "pax-git" = fetch {
    pname       = "pax-git";
    version     = "20161104.2";
    srcs        = [{ filename = "pax-git-20161104.2-1-i686.pkg.tar.xz"; sha256 = "479daa8328d7171dfacf7818939f1b136b4d7e14c71a563ce1dcfbf390773f37"; }];
    buildInputs = [ msys2-runtime ];
  };

  "pcre" = fetch {
    pname       = "pcre";
    version     = "8.42";
    srcs        = [{ filename = "pcre-8.42-1-i686.pkg.tar.xz"; sha256 = "ee620693e8f78a973e014ce14fcd4f42571e1198910d50e9664a5d09473a25d4"; }];
    buildInputs = [ libreadline libbz2 zlib libpcre libpcre16 libpcre32 libpcrecpp libpcreposix ];
  };

  "pcre-devel" = fetch {
    pname       = "pcre-devel";
    version     = "8.42";
    srcs        = [{ filename = "pcre-devel-8.42-1-i686.pkg.tar.xz"; sha256 = "fac34c68ffc2415beee6b4fc9d6a07c8440ef14b6e1d4913cd662e3f6d5a7ad1"; }];
    buildInputs = [ (assert libpcre.version=="8.42"; libpcre) (assert libpcre16.version=="8.42"; libpcre16) (assert libpcre32.version=="8.42"; libpcre32) (assert libpcreposix.version=="8.42"; libpcreposix) (assert libpcrecpp.version=="8.42"; libpcrecpp) ];
  };

  "pcre2" = fetch {
    pname       = "pcre2";
    version     = "10.32";
    srcs        = [{ filename = "pcre2-10.32-1-i686.pkg.tar.xz"; sha256 = "6eb8202c5f24d8f827446c4c9e73861688a3076a708432bc323dfcad8a423869"; }];
    buildInputs = [ libreadline libbz2 zlib (assert libpcre2_8.version=="10.32"; libpcre2_8) (assert libpcre2_16.version=="10.32"; libpcre2_16) (assert libpcre2_32.version=="10.32"; libpcre2_32) (assert libpcre2posix.version=="10.32"; libpcre2posix) ];
  };

  "pcre2-devel" = fetch {
    pname       = "pcre2-devel";
    version     = "10.32";
    srcs        = [{ filename = "pcre2-devel-10.32-1-i686.pkg.tar.xz"; sha256 = "09a3e4c0bd3138aa5a1593f48b9cd5fcc64bb5147b89faf13c0144293210a4d8"; }];
    buildInputs = [ (assert libpcre2_8.version=="10.32"; libpcre2_8) (assert libpcre2_16.version=="10.32"; libpcre2_16) (assert libpcre2_32.version=="10.32"; libpcre2_32) (assert libpcre2posix.version=="10.32"; libpcre2posix) ];
  };

  "perl" = fetch {
    pname       = "perl";
    version     = "5.28.1";
    srcs        = [{ filename = "perl-5.28.1-1-i686.pkg.tar.xz"; sha256 = "937ea5190d135039e333fa131f99a31e4238e251e0e3df3d640fbe717765f9b5"; }];
    buildInputs = [ db gdbm libcrypt coreutils msys2-runtime sh ];
  };

  "perl-Algorithm-Diff" = fetch {
    pname       = "perl-Algorithm-Diff";
    version     = "1.1903";
    srcs        = [{ filename = "perl-Algorithm-Diff-1.1903-1-any.pkg.tar.xz"; sha256 = "34ddd74521dc66e384499db5e798ef57f326301e26befc918f3dc4bd4c7f22db"; }];
    buildInputs = [ perl ];
  };

  "perl-Archive-Zip" = fetch {
    pname       = "perl-Archive-Zip";
    version     = "1.64";
    srcs        = [{ filename = "perl-Archive-Zip-1.64-1-any.pkg.tar.xz"; sha256 = "b60bcc42d4f127561f09209db577a38a0cfe68d79073226c71bb97b4d53a6572"; }];
    buildInputs = [ perl ];
  };

  "perl-Authen-SASL" = fetch {
    pname       = "perl-Authen-SASL";
    version     = "2.16";
    srcs        = [{ filename = "perl-Authen-SASL-2.16-2-any.pkg.tar.xz"; sha256 = "0fd9b7d7b2f36cc0005178149d4da6a0366506d3f5de2b3a7f005f811979d2f3"; }];
    buildInputs = [  ];
  };

  "perl-Benchmark-Timer" = fetch {
    pname       = "perl-Benchmark-Timer";
    version     = "0.7107";
    srcs        = [{ filename = "perl-Benchmark-Timer-0.7107-1-any.pkg.tar.xz"; sha256 = "d2b0bba90319302435573b8cc47bb63994cc21debb5eebf769e11cd7a0e315c0"; }];
    buildInputs = [ perl ];
  };

  "perl-Capture-Tiny" = fetch {
    pname       = "perl-Capture-Tiny";
    version     = "0.48";
    srcs        = [{ filename = "perl-Capture-Tiny-0.48-1-any.pkg.tar.xz"; sha256 = "02d1c1b4e2bfb9cbdc6af8f3f35094e0020930ac84236a739d584e77143fd8f8"; }];
    buildInputs = [ perl ];
  };

  "perl-Carp-Clan" = fetch {
    pname       = "perl-Carp-Clan";
    version     = "6.06";
    srcs        = [{ filename = "perl-Carp-Clan-6.06-1-any.pkg.tar.xz"; sha256 = "577226ee422deb5c55e22ab714e4edf11d757f3cc0bcc53edc300427cf1e2a03"; }];
    buildInputs = [ perl ];
  };

  "perl-Compress-Bzip2" = fetch {
    pname       = "perl-Compress-Bzip2";
    version     = "2.26";
    srcs        = [{ filename = "perl-Compress-Bzip2-2.26-2-i686.pkg.tar.xz"; sha256 = "05c14a1b412d8b7f6541118ccde197ae6203fb29a6a6d00bc2e65a5059708d3b"; }];
    buildInputs = [ perl libbz2 ];
  };

  "perl-Convert-BinHex" = fetch {
    pname       = "perl-Convert-BinHex";
    version     = "1.125";
    srcs        = [{ filename = "perl-Convert-BinHex-1.125-1-any.pkg.tar.xz"; sha256 = "07153d947c97415fb69318595de25402cf5d23591a2f848bce903cb0878fae4a"; }];
    buildInputs = [ perl ];
  };

  "perl-Crypt-SSLeay" = fetch {
    pname       = "perl-Crypt-SSLeay";
    version     = "0.73_06";
    srcs        = [{ filename = "perl-Crypt-SSLeay-0.73_06-2-i686.pkg.tar.xz"; sha256 = "f96d30af4a65dc20a11adf601a7bba699904b4f915266f20ee136e5b5909a06d"; }];
    buildInputs = [ perl-LWP-Protocol-https perl-Try-Tiny perl-Path-Class ];
  };

  "perl-DBI" = fetch {
    pname       = "perl-DBI";
    version     = "1.642";
    srcs        = [{ filename = "perl-DBI-1.642-1-i686.pkg.tar.xz"; sha256 = "56427508e5d0c41512a983fb762e27f0d538596eb9d65671a47e1c14e2028524"; }];
    buildInputs = [ perl ];
  };

  "perl-Date-Calc" = fetch {
    pname       = "perl-Date-Calc";
    version     = "6.4";
    srcs        = [{ filename = "perl-Date-Calc-6.4-1-any.pkg.tar.xz"; sha256 = "e528b1cdf792a722dc4aab52b704e23e3a020f80fc2bce03d4d63e1beb88a4ef"; }];
    buildInputs = [ perl ];
  };

  "perl-Digest-HMAC" = fetch {
    pname       = "perl-Digest-HMAC";
    version     = "1.03";
    srcs        = [{ filename = "perl-Digest-HMAC-1.03-2-any.pkg.tar.xz"; sha256 = "433015360607c7d3bbf9fdb63ccf2956a04a570f79d641e52b546bba67d43d1d"; }];
  };

  "perl-Digest-MD4" = fetch {
    pname       = "perl-Digest-MD4";
    version     = "1.9";
    srcs        = [{ filename = "perl-Digest-MD4-1.9-3-any.pkg.tar.xz"; sha256 = "a023dc2c073b6a64edfe2a27371d4fe27294b1c488e83da957e0bc31dd20c620"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) libcrypt ];
  };

  "perl-Encode-Locale" = fetch {
    pname       = "perl-Encode-Locale";
    version     = "1.05";
    srcs        = [{ filename = "perl-Encode-Locale-1.05-1-any.pkg.tar.xz"; sha256 = "47a3959403c5ef97678ad2a9a947157382d442b40325d744f4c80ee4eafa4e7a"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.008"; perl) ];
  };

  "perl-Encode-compat" = fetch {
    pname       = "perl-Encode-compat";
    version     = "0.07";
    srcs        = [{ filename = "perl-Encode-compat-0.07-1-any.pkg.tar.xz"; sha256 = "bca473b35c72994343bdef6082c76595b1a9fa01145589a07b20c0cd82c5cd7c"; }];
    buildInputs = [ perl ];
  };

  "perl-Error" = fetch {
    pname       = "perl-Error";
    version     = "0.17027";
    srcs        = [{ filename = "perl-Error-0.17027-1-any.pkg.tar.xz"; sha256 = "caa905bcc09594d0e0a0b80a696af8a508d32bf3e024ca6c70ce9a592b5cd6d1"; }];
    buildInputs = [ perl ];
  };

  "perl-Exporter-Lite" = fetch {
    pname       = "perl-Exporter-Lite";
    version     = "0.08";
    srcs        = [{ filename = "perl-Exporter-Lite-0.08-1-any.pkg.tar.xz"; sha256 = "a66c095e020dbb5db129a6228be8f2fa99bde2d6e86ec9cb2f6b44448d177f72"; }];
    buildInputs = [ perl ];
  };

  "perl-Exporter-Tiny" = fetch {
    pname       = "perl-Exporter-Tiny";
    version     = "1.002001";
    srcs        = [{ filename = "perl-Exporter-Tiny-1.002001-1-any.pkg.tar.xz"; sha256 = "3f40368f8a08289e206a114dd387316cad04eb4ab6e8584c673b8bf9604bf73d"; }];
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-Depends" = fetch {
    pname       = "perl-ExtUtils-Depends";
    version     = "0.405";
    srcs        = [{ filename = "perl-ExtUtils-Depends-0.405-1-any.pkg.tar.xz"; sha256 = "812ca4bddd8cf6d47099df97234be6dd3ea374d20e0967a12ba16bebf3fc8f23"; }];
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-MakeMaker" = fetch {
    pname       = "perl-ExtUtils-MakeMaker";
    version     = "7.34";
    srcs        = [{ filename = "perl-ExtUtils-MakeMaker-7.34-1-any.pkg.tar.xz"; sha256 = "1da8909e4eb2deca6920670ca93c67ad20f183ff7c64142f59e35191b93f682e"; }];
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-PkgConfig" = fetch {
    pname       = "perl-ExtUtils-PkgConfig";
    version     = "1.16";
    srcs        = [{ filename = "perl-ExtUtils-PkgConfig-1.16-1-any.pkg.tar.xz"; sha256 = "4be961398d17249630d6d96d7be4b6eee50fede4fee70bf70cf4fd14865ee4c8"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-File-Copy-Recursive" = fetch {
    pname       = "perl-File-Copy-Recursive";
    version     = "0.44";
    srcs        = [{ filename = "perl-File-Copy-Recursive-0.44-1-any.pkg.tar.xz"; sha256 = "9fbe0c8d0413d8e3b7df5abd0342f56865cb2388e4d47c366a704649b11a7781"; }];
    buildInputs = [ perl ];
  };

  "perl-File-Listing" = fetch {
    pname       = "perl-File-Listing";
    version     = "6.04";
    srcs        = [{ filename = "perl-File-Listing-6.04-2-any.pkg.tar.xz"; sha256 = "8ad4482a6ce6ebfe4c60049e7c79821a73a29b6046f81a861e507143f952e4f1"; }];
    buildInputs = [  ];
  };

  "perl-File-Next" = fetch {
    pname       = "perl-File-Next";
    version     = "1.16";
    srcs        = [{ filename = "perl-File-Next-1.16-1-any.pkg.tar.xz"; sha256 = "f80f3d9619c99b3e1dc6464a737d4ad366f2fde423ca3db7a9e68a5f4f9af167"; }];
    buildInputs = [ perl ];
  };

  "perl-File-Which" = fetch {
    pname       = "perl-File-Which";
    version     = "1.22";
    srcs        = [{ filename = "perl-File-Which-1.22-1-any.pkg.tar.xz"; sha256 = "5d520de2fee0e5d15506e181efc87a6be4e8b76dcb198a504397ea0737fba9b2"; }];
    buildInputs = [ perl (assert stdenvNoCC.lib.versionAtLeast perl-Test-Script.version "1.05"; perl-Test-Script) ];
  };

  "perl-Font-TTF" = fetch {
    pname       = "perl-Font-TTF";
    version     = "1.06";
    srcs        = [{ filename = "perl-Font-TTF-1.06-1-any.pkg.tar.xz"; sha256 = "845c2eaea5576158c39f24ef088d0a1282392aa92ae0f9c27e02424324e5634a"; }];
    buildInputs = [ perl-IO-String ];
  };

  "perl-Getopt-ArgvFile" = fetch {
    pname       = "perl-Getopt-ArgvFile";
    version     = "1.11";
    srcs        = [{ filename = "perl-Getopt-ArgvFile-1.11-1-any.pkg.tar.xz"; sha256 = "c0add48b90d18cf6302b7ecc7b464cd64cc4641c09143240ba95e8dfc7528bde"; }];
    buildInputs = [ perl ];
  };

  "perl-Getopt-Tabular" = fetch {
    pname       = "perl-Getopt-Tabular";
    version     = "0.3";
    srcs        = [{ filename = "perl-Getopt-Tabular-0.3-1-any.pkg.tar.xz"; sha256 = "05c32fe6bd8bb72ca0b24b417151c5c0734f08f34caf127b02738fe016e3a050"; }];
  };

  "perl-HTML-Parser" = fetch {
    pname       = "perl-HTML-Parser";
    version     = "3.72";
    srcs        = [{ filename = "perl-HTML-Parser-3.72-3-i686.pkg.tar.xz"; sha256 = "3b141c600aa55dd9c730271cbd7cd0b3e8c4e4460f165428a3d76b20caf1c104"; }];
    buildInputs = [ perl-HTML-Tagset perl ];
  };

  "perl-HTML-Tagset" = fetch {
    pname       = "perl-HTML-Tagset";
    version     = "3.20";
    srcs        = [{ filename = "perl-HTML-Tagset-3.20-2-any.pkg.tar.xz"; sha256 = "e3719b59cd2c68819094d6ce6bcdee5e3f65b05fbf035778fa9e85e8c91f9938"; }];
    buildInputs = [  ];
  };

  "perl-HTTP-Cookies" = fetch {
    pname       = "perl-HTTP-Cookies";
    version     = "6.04";
    srcs        = [{ filename = "perl-HTTP-Cookies-6.04-1-any.pkg.tar.xz"; sha256 = "c0a69945dd1300ba4cccfabd19cb1876f45d9bfffbd9063d83a99d490d1c444c"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.8"; perl) (assert stdenvNoCC.lib.versionAtLeast perl-HTTP-Date.version "6"; perl-HTTP-Date) perl-HTTP-Message ];
  };

  "perl-HTTP-Daemon" = fetch {
    pname       = "perl-HTTP-Daemon";
    version     = "6.01";
    srcs        = [{ filename = "perl-HTTP-Daemon-6.01-2-any.pkg.tar.xz"; sha256 = "f356301ec706a2becb2325b77d45dfcac8e2c60f91a6132ae7eb381adf173a4f"; }];
    buildInputs = [  ];
  };

  "perl-HTTP-Date" = fetch {
    pname       = "perl-HTTP-Date";
    version     = "6.02";
    srcs        = [{ filename = "perl-HTTP-Date-6.02-2-any.pkg.tar.xz"; sha256 = "ddc50725d27a80eea4cb302fc78fbeb7e4751d97d0716fbaf365cca480fcebe6"; }];
    buildInputs = [  ];
  };

  "perl-HTTP-Message" = fetch {
    pname       = "perl-HTTP-Message";
    version     = "6.18";
    srcs        = [{ filename = "perl-HTTP-Message-6.18-1-any.pkg.tar.xz"; sha256 = "255cec0ae4878394b91e13d5d8dc8dac14fa3560f2999e23412695e7a0af4c00"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.8"; perl) (assert stdenvNoCC.lib.versionAtLeast perl-Encode-Locale.version "1"; perl-Encode-Locale) (assert stdenvNoCC.lib.versionAtLeast perl-HTML-Parser.version "3.33"; perl-HTML-Parser) (assert stdenvNoCC.lib.versionAtLeast perl-HTTP-Date.version "6"; perl-HTTP-Date) (assert stdenvNoCC.lib.versionAtLeast perl-LWP-MediaTypes.version "6"; perl-LWP-MediaTypes) (assert stdenvNoCC.lib.versionAtLeast perl-URI.version "1.10"; perl-URI) ];
  };

  "perl-HTTP-Negotiate" = fetch {
    pname       = "perl-HTTP-Negotiate";
    version     = "6.01";
    srcs        = [{ filename = "perl-HTTP-Negotiate-6.01-2-any.pkg.tar.xz"; sha256 = "fe58fe261b63e1206d0f5278b2f094735acc979bf68930ebc5b0968d05a75f44"; }];
    buildInputs = [  ];
  };

  "perl-IO-HTML" = fetch {
    pname       = "perl-IO-HTML";
    version     = "1.001";
    srcs        = [{ filename = "perl-IO-HTML-1.001-1-any.pkg.tar.xz"; sha256 = "8a7e886c8f6261a5b85ab9a0b2b3114f1daa2a157f15cb7b3e4e5fe3f52c6f1b"; }];
  };

  "perl-IO-Socket-INET6" = fetch {
    pname       = "perl-IO-Socket-INET6";
    version     = "2.72";
    srcs        = [{ filename = "perl-IO-Socket-INET6-2.72-4-any.pkg.tar.xz"; sha256 = "9dac1ea12f70fd0c097b11989b1b626d733bbef07779f4cbc9859a427f0cbfe5"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl-Socket6.version "0.12"; perl-Socket6) ];
  };

  "perl-IO-Socket-SSL" = fetch {
    pname       = "perl-IO-Socket-SSL";
    version     = "2.060";
    srcs        = [{ filename = "perl-IO-Socket-SSL-2.060-1-any.pkg.tar.xz"; sha256 = "10f39ff6959b40e08a288c5505c995bd67112ae9af4cdef7e5ac6a9110d1e2cd"; }];
    buildInputs = [ perl-Net-SSLeay perl perl-URI ];
  };

  "perl-IO-String" = fetch {
    pname       = "perl-IO-String";
    version     = "1.08";
    srcs        = [{ filename = "perl-IO-String-1.08-9-i686.pkg.tar.xz"; sha256 = "4d6c26debc1b5f638989d3a42990d937322c5220a9805ebcb093dd3d25fb1929"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-IO-stringy" = fetch {
    pname       = "perl-IO-stringy";
    version     = "2.111";
    srcs        = [{ filename = "perl-IO-stringy-2.111-1-any.pkg.tar.xz"; sha256 = "3878303821780221ede36d90f4980fb8869fbf143a0998e80ba3a096177ad10f"; }];
    buildInputs = [ perl ];
  };

  "perl-IPC-Run3" = fetch {
    pname       = "perl-IPC-Run3";
    version     = "0.048";
    srcs        = [{ filename = "perl-IPC-Run3-0.048-1-any.pkg.tar.xz"; sha256 = "ef3c423721d0ab452c08d4db20945d2ce562bb853e52edefb26b65125838892e"; }];
    buildInputs = [  ];
  };

  "perl-JSON" = fetch {
    pname       = "perl-JSON";
    version     = "2.97001";
    srcs        = [{ filename = "perl-JSON-2.97001-1-any.pkg.tar.xz"; sha256 = "f561543d9a5e2fa4bf031dfbf4eb5fc6b8cd2a16bae7bec53d4678a55199c91a"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-LWP-MediaTypes" = fetch {
    pname       = "perl-LWP-MediaTypes";
    version     = "6.02";
    srcs        = [{ filename = "perl-LWP-MediaTypes-6.02-2-any.pkg.tar.xz"; sha256 = "691557a038554775968fee8716fabfa787ae66e55e4fa784d29ea2908bcbccc6"; }];
    buildInputs = [  ];
  };

  "perl-LWP-Protocol-https" = fetch {
    pname       = "perl-LWP-Protocol-https";
    version     = "6.07";
    srcs        = [{ filename = "perl-LWP-Protocol-https-6.07-1-any.pkg.tar.xz"; sha256 = "fe33d4f38781614b72eb36070e611b8c589d580b4d9fd613fe4252e13ca3015d"; }];
    buildInputs = [ perl perl-IO-Socket-SSL perl-Mozilla-CA perl-Net-HTTP perl-libwww ];
  };

  "perl-List-MoreUtils" = fetch {
    pname       = "perl-List-MoreUtils";
    version     = "0.428";
    srcs        = [{ filename = "perl-List-MoreUtils-0.428-1-any.pkg.tar.xz"; sha256 = "9424f9eec5d8a5f710a7220d9fd0106ca1a12b00194c8e5c9e4e6f5831ce836f"; }];
    buildInputs = [ perl perl-Exporter-Tiny perl-List-MoreUtils-XS ];
  };

  "perl-List-MoreUtils-XS" = fetch {
    pname       = "perl-List-MoreUtils-XS";
    version     = "0.428";
    srcs        = [{ filename = "perl-List-MoreUtils-XS-0.428-2-i686.pkg.tar.xz"; sha256 = "444a9bcc13ba2135427fa1d8e1560e40de28fd51ab59e94889efa7bc76ca6b3b"; }];
    buildInputs = [ perl ];
  };

  "perl-Locale-Gettext" = fetch {
    pname       = "perl-Locale-Gettext";
    version     = "1.07";
    srcs        = [{ filename = "perl-Locale-Gettext-1.07-3-i686.pkg.tar.xz"; sha256 = "092c50f855fbd27efe237f98e151681ac37da8ae5150f31a4f118156964d9026"; }];
    buildInputs = [ gettext perl ];
  };

  "perl-MIME-Charset" = fetch {
    pname       = "perl-MIME-Charset";
    version     = "1.012.2";
    srcs        = [{ filename = "perl-MIME-Charset-1.012.2-1-any.pkg.tar.xz"; sha256 = "a7caeed7aa11728236b18844247c62efd68f6747989b17366bf1009ab28a4042"; }];
    buildInputs = [ perl ];
  };

  "perl-MIME-tools" = fetch {
    pname       = "perl-MIME-tools";
    version     = "5.509";
    srcs        = [{ filename = "perl-MIME-tools-5.509-1-any.pkg.tar.xz"; sha256 = "318aa182d2418ef3ea713893f3807732d42d7d62b9cd847ec56440f1c685b76e"; }];
    buildInputs = [ perl-MailTools perl-IO-stringy perl-Convert-BinHex ];
  };

  "perl-MailTools" = fetch {
    pname       = "perl-MailTools";
    version     = "2.20";
    srcs        = [{ filename = "perl-MailTools-2.20-1-any.pkg.tar.xz"; sha256 = "382f85bdc556256b8c07ebfb90caa65c4bb7c7698a1eeeebb9fac3f43335d2df"; }];
    buildInputs = [ perl-TimeDate ];
  };

  "perl-Math-Int64" = fetch {
    pname       = "perl-Math-Int64";
    version     = "0.54";
    srcs        = [{ filename = "perl-Math-Int64-0.54-2-any.pkg.tar.xz"; sha256 = "2f1bd17101badb09d6e45285c5564335af335e0fdee6c8f86aba1ef7d4cef40d"; }];
    buildInputs = [ perl ];
  };

  "perl-Module-Build" = fetch {
    pname       = "perl-Module-Build";
    version     = "0.4224";
    srcs        = [{ filename = "perl-Module-Build-0.4224-1-any.pkg.tar.xz"; sha256 = "c4d02971a36e31e097a14168b7e235042d6e50a92586ea854345b46245b0dfb6"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.0"; perl) (assert stdenvNoCC.lib.versionAtLeast perl-CPAN-Meta.version "2.142060"; perl-CPAN-Meta) perl-inc-latest ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "perl-Mozilla-CA" = fetch {
    pname       = "perl-Mozilla-CA";
    version     = "20180117";
    srcs        = [{ filename = "perl-Mozilla-CA-20180117-1-any.pkg.tar.xz"; sha256 = "fc9383996748eeda9ae9b2b15156c0023c314181dd5ca65046161aa6714f4d91"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.006"; perl) ];
  };

  "perl-Net-DNS" = fetch {
    pname       = "perl-Net-DNS";
    version     = "1.19";
    srcs        = [{ filename = "perl-Net-DNS-1.19-1-i686.pkg.tar.xz"; sha256 = "fa5faa225b0a0c7347d1cbd416c5d59d4a52b0346836eca9a442868ae32daa91"; }];
    buildInputs = [ perl-Digest-HMAC perl-Net-IP perl ];
  };

  "perl-Net-HTTP" = fetch {
    pname       = "perl-Net-HTTP";
    version     = "6.18";
    srcs        = [{ filename = "perl-Net-HTTP-6.18-1-any.pkg.tar.xz"; sha256 = "470543395931b0ee7523805ea6a62cb30e90f4b8cee00581bdb2427296b8585c"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.6.2"; perl) ];
  };

  "perl-Net-IP" = fetch {
    pname       = "perl-Net-IP";
    version     = "1.26";
    srcs        = [{ filename = "perl-Net-IP-1.26-2-any.pkg.tar.xz"; sha256 = "391be40c301db29b97c77f812bcbe543c8ad696835fbdbf4c8c1e96d6093c35e"; }];
    buildInputs = [  ];
  };

  "perl-Net-SMTP-SSL" = fetch {
    pname       = "perl-Net-SMTP-SSL";
    version     = "1.04";
    srcs        = [{ filename = "perl-Net-SMTP-SSL-1.04-1-any.pkg.tar.xz"; sha256 = "30b733db6322e25e26036a3b19d876ccbd20ed5df07bd0d7abafce2caa0dd54d"; }];
    buildInputs = [ perl-IO-Socket-SSL ];
  };

  "perl-Net-SSLeay" = fetch {
    pname       = "perl-Net-SSLeay";
    version     = "1.85";
    srcs        = [{ filename = "perl-Net-SSLeay-1.85-2-i686.pkg.tar.xz"; sha256 = "22017c3037b684c1486eef645a420266b8d13aaf23490da9eb390611e6b7a1c0"; }];
    buildInputs = [ openssl ];
  };

  "perl-Parallel-ForkManager" = fetch {
    pname       = "perl-Parallel-ForkManager";
    version     = "1.20";
    srcs        = [{ filename = "perl-Parallel-ForkManager-1.20-1-any.pkg.tar.xz"; sha256 = "802f356dae648c0538b7cce007d2704f14a26ba5dd311944943a1c2310b210c1"; }];
    buildInputs = [ perl ];
  };

  "perl-Path-Class" = fetch {
    pname       = "perl-Path-Class";
    version     = "0.37";
    srcs        = [{ filename = "perl-Path-Class-0.37-1-any.pkg.tar.xz"; sha256 = "4db5b9c61f2c8409e23476c76e6f41b821327f178ba0672db5594094e4d2557e"; }];
    buildInputs = [ perl ];
  };

  "perl-Probe-Perl" = fetch {
    pname       = "perl-Probe-Perl";
    version     = "0.03";
    srcs        = [{ filename = "perl-Probe-Perl-0.03-2-any.pkg.tar.xz"; sha256 = "4b98d9c3b939aaf9fa5ae27dcf1e93977673349d5c39a286ab53942187486917"; }];
    buildInputs = [  ];
  };

  "perl-Regexp-Common" = fetch {
    pname       = "perl-Regexp-Common";
    version     = "2017060201";
    srcs        = [{ filename = "perl-Regexp-Common-2017060201-1-any.pkg.tar.xz"; sha256 = "8fc41d18b667e0dc7ff823b3be8ef283a9c54bb697622641b635910b0f3a27e1"; }];
    buildInputs = [ perl ];
  };

  "perl-Socket6" = fetch {
    pname       = "perl-Socket6";
    version     = "0.29";
    srcs        = [{ filename = "perl-Socket6-0.29-1-i686.pkg.tar.xz"; sha256 = "37fd376c6e07a54bc8009a99926842caa8f37b1a54e8cba2a213e9f9fc392987"; }];
    buildInputs = [ perl ];
  };

  "perl-Sort-Versions" = fetch {
    pname       = "perl-Sort-Versions";
    version     = "1.62";
    srcs        = [{ filename = "perl-Sort-Versions-1.62-1-any.pkg.tar.xz"; sha256 = "5790684d6146d0e204efe70fd13b8c1fdc444a46593cebb591ec1e0f4e0083cf"; }];
    buildInputs = [ perl ];
  };

  "perl-Spiffy" = fetch {
    pname       = "perl-Spiffy";
    version     = "0.46";
    srcs        = [{ filename = "perl-Spiffy-0.46-1-any.pkg.tar.xz"; sha256 = "1cf1d573a8a3eeace93eb69c3b3107c9d8e32cb3ac31a0a73067fc488d32978e"; }];
    buildInputs = [ perl ];
  };

  "perl-Sys-CPU" = fetch {
    pname       = "perl-Sys-CPU";
    version     = "0.61";
    srcs        = [{ filename = "perl-Sys-CPU-0.61-5-i686.pkg.tar.xz"; sha256 = "e1ea75d925e1e9f9f4ff2284bc439ba2a34d8ef46c8f28df58a16b1bfcceb737"; }];
    buildInputs = [ perl libcrypt-devel ];
  };

  "perl-TAP-Harness-Archive" = fetch {
    pname       = "perl-TAP-Harness-Archive";
    version     = "0.18";
    srcs        = [{ filename = "perl-TAP-Harness-Archive-0.18-1-any.pkg.tar.xz"; sha256 = "d2ab8e8a945fc366f7b675081263b636e1949ada9ab53d6ae613d04ab5183516"; }];
    buildInputs = [ perl-YAML-Tiny perl ];
  };

  "perl-TermReadKey" = fetch {
    pname       = "perl-TermReadKey";
    version     = "2.37";
    srcs        = [{ filename = "perl-TermReadKey-2.37-3-i686.pkg.tar.xz"; sha256 = "36fb82321bf7a2e06089aada434dcb3a4c2626cb68f27add75a9a0fbdd194409"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Base" = fetch {
    pname       = "perl-Test-Base";
    version     = "0.89";
    srcs        = [{ filename = "perl-Test-Base-0.89-1-any.pkg.tar.xz"; sha256 = "26df6980abc63f62ce64fa6e878ce14fc8f79099db509efe4960754d03c2506d"; }];
    buildInputs = [ perl perl-Spiffy perl-Text-Diff ];
    broken      = true; # broken dependency perl-Text-Diff -> perl-Exporter
  };

  "perl-Test-Deep" = fetch {
    pname       = "perl-Test-Deep";
    version     = "1.128";
    srcs        = [{ filename = "perl-Test-Deep-1.128-1-any.pkg.tar.xz"; sha256 = "06a8f385a0ed22828d719dc985ad93edb9e802ad2c9eb33be25bee0f0c860321"; }];
    buildInputs = [ perl perl-Test-Simple perl-Test-NoWarnings ];
  };

  "perl-Test-Fatal" = fetch {
    pname       = "perl-Test-Fatal";
    version     = "0.014";
    srcs        = [{ filename = "perl-Test-Fatal-0.014-1-any.pkg.tar.xz"; sha256 = "d77a60cb0457257376ee9a358e2c32e0291714922c975031763cf58f97ee8b73"; }];
    buildInputs = [ perl perl-Try-Tiny ];
  };

  "perl-Test-Harness" = fetch {
    pname       = "perl-Test-Harness";
    version     = "3.39";
    srcs        = [{ filename = "perl-Test-Harness-3.39-1-any.pkg.tar.xz"; sha256 = "891406bb7c0825ffa8d7edfa0a66e043094462d4d40a054e145ebd2da64e17ed"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Needs" = fetch {
    pname       = "perl-Test-Needs";
    version     = "0.002005";
    srcs        = [{ filename = "perl-Test-Needs-0.002005-1-any.pkg.tar.xz"; sha256 = "e28e82381a593161d331a13845eb6d58b3b1e3e3d0996c21de4d7ea48adab018"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-NoWarnings" = fetch {
    pname       = "perl-Test-NoWarnings";
    version     = "1.04";
    srcs        = [{ filename = "perl-Test-NoWarnings-1.04-1-any.pkg.tar.xz"; sha256 = "a339d3324fd98779219d23e804e5fc82bc06d1d9e45a4b3fd34dcae52ad09f21"; }];
    buildInputs = [ perl perl-Test-Simple ];
  };

  "perl-Test-Pod" = fetch {
    pname       = "perl-Test-Pod";
    version     = "1.52";
    srcs        = [{ filename = "perl-Test-Pod-1.52-1-any.pkg.tar.xz"; sha256 = "de1e3aa194d3e7d4ac1347ca6890c6db349d62398d749d58ca0b3622f0c6e2f6"; }];
    buildInputs = [ perl perl-Module-Build ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "perl-Test-Requiresinternet" = fetch {
    pname       = "perl-Test-Requiresinternet";
    version     = "0.05";
    srcs        = [{ filename = "perl-Test-Requiresinternet-0.05-1-any.pkg.tar.xz"; sha256 = "1503e79d20ae21e6d60f84b5654763eb88f8ce313b7f5469e4035b55067246a0"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Script" = fetch {
    pname       = "perl-Test-Script";
    version     = "1.23";
    srcs        = [{ filename = "perl-Test-Script-1.23-1-any.pkg.tar.xz"; sha256 = "70aa11256d49428df5521588cd21d54c6d7958809fc32f0d4f8bf6b0b26fa8ec"; }];
    buildInputs = [ perl perl-IPC-Run3 perl-Probe-Perl perl-Test-Simple ];
  };

  "perl-Test-Simple" = fetch {
    pname       = "perl-Test-Simple";
    version     = "1.302122";
    srcs        = [{ filename = "perl-Test-Simple-1.302122-1-any.pkg.tar.xz"; sha256 = "46424444c70a710311790480e4365fef2e44ff67fc379c83a944c341f8efe54e"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-YAML" = fetch {
    pname       = "perl-Test-YAML";
    version     = "1.07";
    srcs        = [{ filename = "perl-Test-YAML-1.07-1-any.pkg.tar.xz"; sha256 = "aac3244bf46937cb7bcb4fadb2633115dfb372b2b36b6e5368ec8429693d2527"; }];
    buildInputs = [ perl perl-Test-Base ];
    broken      = true; # broken dependency perl-Text-Diff -> perl-Exporter
  };

  "perl-Text-CharWidth" = fetch {
    pname       = "perl-Text-CharWidth";
    version     = "0.04";
    srcs        = [{ filename = "perl-Text-CharWidth-0.04-3-any.pkg.tar.xz"; sha256 = "42594dd190c2dab1fc934f3d86611ac52de384be6903b94a6597b64d12527ec2"; }];
    buildInputs = [ perl libcrypt ];
  };

  "perl-Text-Diff" = fetch {
    pname       = "perl-Text-Diff";
    version     = "1.45";
    srcs        = [{ filename = "perl-Text-Diff-1.45-1-any.pkg.tar.xz"; sha256 = "8a45e8c0b058b06620e59bc54a14074efa3395411772af5637094ced84e41439"; }];
    buildInputs = [ perl perl-Algorithm-Diff perl-Exporter ];
    broken      = true; # broken dependency perl-Text-Diff -> perl-Exporter
  };

  "perl-Text-WrapI18N" = fetch {
    pname       = "perl-Text-WrapI18N";
    version     = "0.06";
    srcs        = [{ filename = "perl-Text-WrapI18N-0.06-1-any.pkg.tar.xz"; sha256 = "02f63706498658bc9f9f4a71e5c2370bef176fa617ad70593c3ae12251c6d3c5"; }];
    buildInputs = [ perl perl-Text-CharWidth ];
  };

  "perl-TimeDate" = fetch {
    pname       = "perl-TimeDate";
    version     = "2.30";
    srcs        = [{ filename = "perl-TimeDate-2.30-2-any.pkg.tar.xz"; sha256 = "65237c3abb8e8ecfc5b7f8144a6f8878db659d2e71b7e6ba1d6c3220de13f925"; }];
    buildInputs = [  ];
  };

  "perl-Try-Tiny" = fetch {
    pname       = "perl-Try-Tiny";
    version     = "0.30";
    srcs        = [{ filename = "perl-Try-Tiny-0.30-1-any.pkg.tar.xz"; sha256 = "9fcc6917277396441822688a3bc5e0fe79e8478da401f8691c197678b5e7c2c5"; }];
    buildInputs = [ perl ];
  };

  "perl-URI" = fetch {
    pname       = "perl-URI";
    version     = "1.74";
    srcs        = [{ filename = "perl-URI-1.74-1-any.pkg.tar.xz"; sha256 = "57eea2e841e40fa501213a8787fd00d0d4a48e31d50331cd16d518ebe075be90"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-Unicode-GCString" = fetch {
    pname       = "perl-Unicode-GCString";
    version     = "2018.003";
    srcs        = [{ filename = "perl-Unicode-GCString-2018.003-1-any.pkg.tar.xz"; sha256 = "0c745ceb60522a6bc44204ad72ebfccfa18820528d3a227a87bda8def089905a"; }];
    buildInputs = [ perl perl-MIME-Charset libcrypt ];
  };

  "perl-WWW-RobotRules" = fetch {
    pname       = "perl-WWW-RobotRules";
    version     = "6.02";
    srcs        = [{ filename = "perl-WWW-RobotRules-6.02-2-any.pkg.tar.xz"; sha256 = "8910fe81b168ca63c5479822a6420c3b2b335050fae4cf26c98fb90e5ab3c90e"; }];
    buildInputs = [  ];
  };

  "perl-XML-LibXML" = fetch {
    pname       = "perl-XML-LibXML";
    version     = "2.0132";
    srcs        = [{ filename = "perl-XML-LibXML-2.0132-2-i686.pkg.tar.xz"; sha256 = "24952b48eb6d069a1b49a53e623f406314c7f900cf5cda5711ab63b140725263"; }];
    buildInputs = [ perl libxml2 perl-XML-SAX ];
  };

  "perl-XML-NamespaceSupport" = fetch {
    pname       = "perl-XML-NamespaceSupport";
    version     = "1.12";
    srcs        = [{ filename = "perl-XML-NamespaceSupport-1.12-1-any.pkg.tar.xz"; sha256 = "876402b8e974d19d2e823c7ffa762bd87fbb1ec2d9b5d4a44f6b27dff1c67e5c"; }];
    buildInputs = [ perl ];
  };

  "perl-XML-Parser" = fetch {
    pname       = "perl-XML-Parser";
    version     = "2.44";
    srcs        = [{ filename = "perl-XML-Parser-2.44-4-i686.pkg.tar.xz"; sha256 = "7dfa04f2737c31ae5254aec44a269afc47eb2301cf1c17b9207b1eafc290f042"; }];
    buildInputs = [ perl libexpat libcrypt ];
  };

  "perl-XML-SAX" = fetch {
    pname       = "perl-XML-SAX";
    version     = "1.00";
    srcs        = [{ filename = "perl-XML-SAX-1.00-1-any.pkg.tar.xz"; sha256 = "80ad77ee23ec4001442603648d341a68c8e0c1052d48813e8f691606e2977645"; }];
    buildInputs = [ perl perl-XML-SAX-Base perl-XML-NamespaceSupport ];
  };

  "perl-XML-SAX-Base" = fetch {
    pname       = "perl-XML-SAX-Base";
    version     = "1.09";
    srcs        = [{ filename = "perl-XML-SAX-Base-1.09-1-any.pkg.tar.xz"; sha256 = "e2ed2d6348168b60530de6216b034b938d66868a03ae60e15ca81bb8e9700d95"; }];
    buildInputs = [ perl ];
  };

  "perl-XML-Simple" = fetch {
    pname       = "perl-XML-Simple";
    version     = "2.25";
    srcs        = [{ filename = "perl-XML-Simple-2.25-1-any.pkg.tar.xz"; sha256 = "456d8e0d4a0d7c6f639119567e4b41eb7a786b3a884f762b04b69118526ea4f9"; }];
    buildInputs = [ perl-XML-Parser perl ];
  };

  "perl-YAML" = fetch {
    pname       = "perl-YAML";
    version     = "1.27";
    srcs        = [{ filename = "perl-YAML-1.27-1-any.pkg.tar.xz"; sha256 = "1bcbf11f779e2a6508f071baa7f76eef33b0e9d7a35644bfbfc53445e9d22e12"; }];
    buildInputs = [ perl ];
  };

  "perl-YAML-Syck" = fetch {
    pname       = "perl-YAML-Syck";
    version     = "1.31";
    srcs        = [{ filename = "perl-YAML-Syck-1.31-1-i686.pkg.tar.xz"; sha256 = "675fe79ca3da4de92fd7c3359a3cc8c116ce4c1e7b7987c559a3739ccc7432e1"; }];
    buildInputs = [ perl ];
  };

  "perl-YAML-Tiny" = fetch {
    pname       = "perl-YAML-Tiny";
    version     = "1.73";
    srcs        = [{ filename = "perl-YAML-Tiny-1.73-1-any.pkg.tar.xz"; sha256 = "b2f1573af8b8d8c5ebdd2e45afee4b3774f3b0b74b60ce1cab5488808668b50a"; }];
    buildInputs = [ perl ];
  };

  "perl-ack" = fetch {
    pname       = "perl-ack";
    version     = "2.24";
    srcs        = [{ filename = "perl-ack-2.24-1-any.pkg.tar.xz"; sha256 = "92f7048e865d8e628a05aebe313024abdc89e583cf58432007e2caffe34414f3"; }];
    buildInputs = [ perl-File-Next ];
  };

  "perl-common-sense" = fetch {
    pname       = "perl-common-sense";
    version     = "3.74";
    srcs        = [{ filename = "perl-common-sense-3.74-1-any.pkg.tar.xz"; sha256 = "f262e934e4163cf6c6234fbd69d8f0641d4df0335f527cf8e8f681a8aaa2cb81"; }];
    buildInputs = [ perl ];
  };

  "perl-inc-latest" = fetch {
    pname       = "perl-inc-latest";
    version     = "0.500";
    srcs        = [{ filename = "perl-inc-latest-0.500-1-any.pkg.tar.xz"; sha256 = "ee2a0d229342a0c814ea66613a5e0f532ec18da0fe7d182162a3e62974844154"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.8"; perl) ];
  };

  "perl-libwww" = fetch {
    pname       = "perl-libwww";
    version     = "6.36";
    srcs        = [{ filename = "perl-libwww-6.36-1-any.pkg.tar.xz"; sha256 = "29b6a64cbed13dd0adec4ad6a4bde3025ac7b62a7cbd6dbb55eded8c4526e31a"; }];
    buildInputs = [ perl perl-Encode-Locale perl-File-Listing perl-HTML-Parser perl-HTTP-Cookies perl-HTTP-Daemon perl-HTTP-Date perl-HTTP-Negotiate perl-LWP-MediaTypes perl-Net-HTTP perl-URI perl-WWW-RobotRules perl-HTTP-Message perl-Try-Tiny ];
  };

  "perl-sgmls" = fetch {
    pname       = "perl-sgmls";
    version     = "1.03ii";
    srcs        = [{ filename = "perl-sgmls-1.03ii-1-any.pkg.tar.xz"; sha256 = "fbf3fc6d7a904fe6e495835b955fee6bed61fbd5d6d7614cc27de70c23cd89f0"; }];
    buildInputs = [ perl ];
  };

  "pinentry" = fetch {
    pname       = "pinentry";
    version     = "1.1.0";
    srcs        = [{ filename = "pinentry-1.1.0-2-i686.pkg.tar.xz"; sha256 = "7a69f3eff0daf3c454ae9c254c6ccf1d68793b5cd747fc918704b57008c3c93c"; }];
    buildInputs = [ ncurses libassuan libgpg-error ];
  };

  "pkg-config" = fetch {
    pname       = "pkg-config";
    version     = "0.29.2";
    srcs        = [{ filename = "pkg-config-0.29.2-1-i686.pkg.tar.xz"; sha256 = "b6780987137fc68a6ae066727dc43b47ba627f84cb8bb65fbe582417dd00d4c2"; }];
    buildInputs = [ glib2 ];
  };

  "pkgfile" = fetch {
    pname       = "pkgfile";
    version     = "19";
    srcs        = [{ filename = "pkgfile-19-1-i686.pkg.tar.xz"; sha256 = "f075b4579938045f35f54dfaf724dfd571859950703086b592fa6a53caf09bdf"; }];
    buildInputs = [ libarchive curl pcre pacman ];
  };

  "po4a" = fetch {
    pname       = "po4a";
    version     = "0.55";
    srcs        = [{ filename = "po4a-0.55-1-any.pkg.tar.xz"; sha256 = "16ae3e829d54b697f21535f6e2c1f4155904418b25cedcd8e92b32c0ddf5590b"; }];
    buildInputs = [ perl gettext perl-Text-WrapI18N perl-Locale-Gettext perl-TermReadKey perl-sgmls perl-Unicode-GCString ];
  };

  "procps" = fetch {
    pname       = "procps";
    version     = "3.2.8";
    srcs        = [{ filename = "procps-3.2.8-2-i686.pkg.tar.xz"; sha256 = "7c57c0cb33a5c094027f7901bbbe8bb96e75b84a975ddc25f433a037f4a17e7a"; }];
    buildInputs = [  ];
  };

  "procps-ng" = fetch {
    pname       = "procps-ng";
    version     = "3.3.12";
    srcs        = [{ filename = "procps-ng-3.3.12-1-i686.pkg.tar.xz"; sha256 = "c98072903743f999e69fcd486000d9e4f7dd92925914ef50869b8a050360edab"; }];
    buildInputs = [ msys2-runtime ncurses ];
  };

  "protobuf" = fetch {
    pname       = "protobuf";
    version     = "3.6.1";
    srcs        = [{ filename = "protobuf-3.6.1-1-i686.pkg.tar.xz"; sha256 = "ed3bac9c2a7eb0887c10ed114d48f500388a958b44e8be2499f1e4a80ea3760b"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "protobuf-devel" = fetch {
    pname       = "protobuf-devel";
    version     = "3.6.1";
    srcs        = [{ filename = "protobuf-devel-3.6.1-1-i686.pkg.tar.xz"; sha256 = "9aa1fd54d0bcc80b6c99dbbb4f640d7686634b67764c60ebe892f5d8f415997e"; }];
    buildInputs = [ (assert protobuf.version=="3.6.1"; protobuf) ];
  };

  "psmisc" = fetch {
    pname       = "psmisc";
    version     = "23.2";
    srcs        = [{ filename = "psmisc-23.2-1-i686.pkg.tar.xz"; sha256 = "638033ecf845a755d6a4062d174f77006d463a57646867afdc22431ad9e6c722"; }];
    buildInputs = [ msys2-runtime gcc-libs ncurses libiconv libintl ];
  };

  "publicsuffix-list" = fetch {
    pname       = "publicsuffix-list";
    version     = "20181101.726.7f2ae66";
    srcs        = [{ filename = "publicsuffix-list-20181101.726.7f2ae66-1-any.pkg.tar.xz"; sha256 = "672c5ed037a7d8cf9e8591f5ad14880a092a65886c1b6d692ab215be58ec146f"; }];
  };

  "pv" = fetch {
    pname       = "pv";
    version     = "1.6.6";
    srcs        = [{ filename = "pv-1.6.6-1-i686.pkg.tar.xz"; sha256 = "d845cb685517ad682c4c0e78e0ab69579cdd7ba0ba8bb9bf23411cb407d6810d"; }];
  };

  "pwgen" = fetch {
    pname       = "pwgen";
    version     = "2.08";
    srcs        = [{ filename = "pwgen-2.08-1-i686.pkg.tar.xz"; sha256 = "52f8cd849895c8006ea9f0b130be38966902658bdeab555ddfc2908c5b75b65d"; }];
    buildInputs = [ msys2-runtime ];
  };

  "python" = fetch {
    pname       = "python";
    version     = "3.7.2";
    srcs        = [{ filename = "python-3.7.2-1-i686.pkg.tar.xz"; sha256 = "e14ae50d791ffd7232fc9e2688052515f7812ec098b5442fbb53cd03d0b15dc4"; }];
    buildInputs = [ libbz2 libexpat libffi liblzma ncurses libopenssl libreadline mpdecimal libsqlite zlib ];
  };

  "python-brotli" = fetch {
    pname       = "python-brotli";
    version     = "1.0.7";
    srcs        = [{ filename = "python-brotli-1.0.7-1-i686.pkg.tar.xz"; sha256 = "c4f4174ef106e33fefe800e3dff50ab02b52ae01f91447f752522aa1b00a788b"; }];
    buildInputs = [ python ];
  };

  "python2" = fetch {
    pname       = "python2";
    version     = "2.7.15";
    srcs        = [{ filename = "python2-2.7.15-3-i686.pkg.tar.xz"; sha256 = "fe17a28b2410a7e7f99f3ed8da28edb0432cb33f3b33816c0b42177c205bf717"; }];
    buildInputs = [ gdbm libbz2 libopenssl zlib libexpat libsqlite libffi ncurses libreadline ];
  };

  "python2-appdirs" = fetch {
    pname       = "python2-appdirs";
    version     = "1.4.3";
    srcs        = [{ filename = "python2-appdirs-1.4.3-3-any.pkg.tar.xz"; sha256 = "c0877ce4004788a0598e06b492914e239e84791837550f2471ed43ac958daca9"; }];
    buildInputs = [ python2 ];
  };

  "python2-atomicwrites" = fetch {
    pname       = "python2-atomicwrites";
    version     = "1.2.1";
    srcs        = [{ filename = "python2-atomicwrites-1.2.1-1-any.pkg.tar.xz"; sha256 = "9b33396fe21422ef0176f7ca725a831b3a11edbec472bff6ca9e8bdae846c19e"; }];
    buildInputs = [ python2 ];
  };

  "python2-attrs" = fetch {
    pname       = "python2-attrs";
    version     = "18.2.0";
    srcs        = [{ filename = "python2-attrs-18.2.0-1-any.pkg.tar.xz"; sha256 = "a3b070de6edd5b5eaaebc104591585d309cde3ecfc985e7efc24f73c3e68e648"; }];
    buildInputs = [ python2 ];
  };

  "python2-beaker" = fetch {
    pname       = "python2-beaker";
    version     = "1.10.0";
    srcs        = [{ filename = "python2-beaker-1.10.0-3-i686.pkg.tar.xz"; sha256 = "4d2f889333ef9ec9304687e9ad7029c240e0e77f3cb49a7c63789da92b138b85"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2.version "2.7"; python2) python2-funcsigs ];
  };

  "python2-brotli" = fetch {
    pname       = "python2-brotli";
    version     = "1.0.7";
    srcs        = [{ filename = "python2-brotli-1.0.7-1-i686.pkg.tar.xz"; sha256 = "eb3c61eded012b98ce1a9f40dd4332eb41523c2c28348f93be1b0ee39ad75dc5"; }];
    buildInputs = [ python2 ];
  };

  "python2-colorama" = fetch {
    pname       = "python2-colorama";
    version     = "0.4.1";
    srcs        = [{ filename = "python2-colorama-0.4.1-1-any.pkg.tar.xz"; sha256 = "6c9444d4ec000455a06c6d57d8c58bc1c7c3984a1bee8e4cacfbeeef2bf59d4c"; }];
    buildInputs = [ python2 ];
  };

  "python2-distutils-extra" = fetch {
    pname       = "python2-distutils-extra";
    version     = "2.39";
    srcs        = [{ filename = "python2-distutils-extra-2.39-2-any.pkg.tar.xz"; sha256 = "78b32060a5a8a82af3c9a5bb92833d624d307bd0f58b804c11b10870386fe5fb"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2.version "2.7"; python2) intltool ];
  };

  "python2-fastimport" = fetch {
    pname       = "python2-fastimport";
    version     = "0.9.8";
    srcs        = [{ filename = "python2-fastimport-0.9.8-1-any.pkg.tar.xz"; sha256 = "7786ac03a21b04871a8a7f1e3b79363b51a0a7fdf9163b4f099dc66f2bae3bda"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python2.version "2.7"; python2) ];
  };

  "python2-funcsigs" = fetch {
    pname       = "python2-funcsigs";
    version     = "1.0.2";
    srcs        = [{ filename = "python2-funcsigs-1.0.2-1-any.pkg.tar.xz"; sha256 = "5aa3de079c17e3c4e015c12bc5dd3c4a7fd60d18eb4a30970f936861a7dc05c7"; }];
    buildInputs = [ python2 ];
  };

  "python2-linecache2" = fetch {
    pname       = "python2-linecache2";
    version     = "1.0.0";
    srcs        = [{ filename = "python2-linecache2-1.0.0-1-any.pkg.tar.xz"; sha256 = "fc515b17ff8d5eba89dbbee3db766bd86c0001722384f7a93c6519a339a05ef4"; }];
    buildInputs = [ python2 ];
  };

  "python2-mako" = fetch {
    pname       = "python2-mako";
    version     = "1.0.7";
    srcs        = [{ filename = "python2-mako-1.0.7-3-i686.pkg.tar.xz"; sha256 = "e2f28a997e95f88c419267e4a8f438979ea24661237bdf8854e1c94a3ce2c105"; }];
    buildInputs = [ python2-markupsafe python2-beaker ];
  };

  "python2-markupsafe" = fetch {
    pname       = "python2-markupsafe";
    version     = "1.1.0";
    srcs        = [{ filename = "python2-markupsafe-1.1.0-1-i686.pkg.tar.xz"; sha256 = "f98e87d3f8982610e456afe9b9020d6f15e1f03fd2792b5a8828b5ae0ae9b149"; }];
    buildInputs = [ python2 ];
  };

  "python2-mock" = fetch {
    pname       = "python2-mock";
    version     = "2.0.0";
    srcs        = [{ filename = "python2-mock-2.0.0-1-any.pkg.tar.xz"; sha256 = "f80677404b0bc6522a9f70ebd118d35526cbc2a95721af8bf3d44fbc52e84108"; }];
    buildInputs = [ python2 ];
  };

  "python2-more-itertools" = fetch {
    pname       = "python2-more-itertools";
    version     = "4.3.0";
    srcs        = [{ filename = "python2-more-itertools-4.3.0-1-any.pkg.tar.xz"; sha256 = "f5c6124c5469b50f1019a7960db9ea463e6e5f1dcaeffd6cac5993ed4304b548"; }];
    buildInputs = [ python2 python2-six ];
  };

  "python2-nose" = fetch {
    pname       = "python2-nose";
    version     = "1.3.7";
    srcs        = [{ filename = "python2-nose-1.3.7-4-i686.pkg.tar.xz"; sha256 = "2c73222b83f112f368eeeb83a1de0a4065e5ff2f7d0d830a070e10c63acfc4f7"; }];
    buildInputs = [ python2-setuptools ];
  };

  "python2-packaging" = fetch {
    pname       = "python2-packaging";
    version     = "18.0";
    srcs        = [{ filename = "python2-packaging-18.0-1-any.pkg.tar.xz"; sha256 = "98552ca169a8a5fe1a6c4baa44946c11c72432003c3805d85b5c7e91940a5872"; }];
    buildInputs = [ python2-pyparsing python2-six ];
  };

  "python2-pathlib2" = fetch {
    pname       = "python2-pathlib2";
    version     = "2.3.3";
    srcs        = [{ filename = "python2-pathlib2-2.3.3-1-any.pkg.tar.xz"; sha256 = "ddcf9a1f245bbac33ff40fc5ba6ccf8989cc17330ab0a6daebe2a55600026ab0"; }];
    buildInputs = [ python2-six python2-scandir ];
  };

  "python2-pbr" = fetch {
    pname       = "python2-pbr";
    version     = "5.1.1";
    srcs        = [{ filename = "python2-pbr-5.1.1-1-any.pkg.tar.xz"; sha256 = "35713d6c34cf7bee630be3a1742db0ad53cca76849706353241a949ec8e2f766"; }];
    buildInputs = [ python2-setuptools ];
  };

  "python2-pip" = fetch {
    pname       = "python2-pip";
    version     = "18.1";
    srcs        = [{ filename = "python2-pip-18.1-1-any.pkg.tar.xz"; sha256 = "4306a28ca0808f05316233fb4bef0bcbfa7a93586853db1435463af4624d2910"; }];
    buildInputs = [ python2 python2-setuptools ];
  };

  "python2-pluggy" = fetch {
    pname       = "python2-pluggy";
    version     = "0.8.0";
    srcs        = [{ filename = "python2-pluggy-0.8.0-1-any.pkg.tar.xz"; sha256 = "d244b2a289b2f05fe9deee77ca95340519ea025e3a978420d1cab6d3553aadde"; }];
    buildInputs = [ python2 ];
  };

  "python2-py" = fetch {
    pname       = "python2-py";
    version     = "1.7.0";
    srcs        = [{ filename = "python2-py-1.7.0-1-any.pkg.tar.xz"; sha256 = "e3581fe52a080abbb0bc95fc184d8a08478082be572a00c33aa02f5cabe0ea04"; }];
    buildInputs = [ python2 ];
  };

  "python2-pyalpm" = fetch {
    pname       = "python2-pyalpm";
    version     = "0.8.4";
    srcs        = [{ filename = "python2-pyalpm-0.8.4-1-i686.pkg.tar.xz"; sha256 = "cd342c9de32ae6b01efc05a0dc2e6c6a975a4aea1e473cc2357ab99c96f07930"; }];
    buildInputs = [ python2 ];
  };

  "python2-pygments" = fetch {
    pname       = "python2-pygments";
    version     = "2.3.1";
    srcs        = [{ filename = "python2-pygments-2.3.1-1-i686.pkg.tar.xz"; sha256 = "54046f050638fca0d23b3360303f97a3ab3dada8e9091ff01175bec0d136fb89"; }];
    buildInputs = [ python2 ];
  };

  "python2-pyparsing" = fetch {
    pname       = "python2-pyparsing";
    version     = "2.3.0";
    srcs        = [{ filename = "python2-pyparsing-2.3.0-1-any.pkg.tar.xz"; sha256 = "e121f8079eef674c11e0e2003df3a92d4135bbfe38e73ca958f8392daaf12afc"; }];
    buildInputs = [ python2 ];
  };

  "python2-pytest" = fetch {
    pname       = "python2-pytest";
    version     = "3.9.3";
    srcs        = [{ filename = "python2-pytest-3.9.3-1-any.pkg.tar.xz"; sha256 = "963490ee58b5e236897df5bf974f0efe1be878b23d0de1c536fa1512317b6d9f"; }];
    buildInputs = [ python2 python2-py python2-setuptools ];
  };

  "python2-pytest-runner" = fetch {
    pname       = "python2-pytest-runner";
    version     = "4.2";
    srcs        = [{ filename = "python2-pytest-runner-4.2-2-any.pkg.tar.xz"; sha256 = "157b3c4062d86ec83d2ee46b94178e1493656e2d01bd3a6d42c73cc5b3a8a5b9"; }];
    buildInputs = [ python2-pytest ];
  };

  "python2-scandir" = fetch {
    pname       = "python2-scandir";
    version     = "1.9.0";
    srcs        = [{ filename = "python2-scandir-1.9.0-1-i686.pkg.tar.xz"; sha256 = "9bfb9164d46af251e044f6c0b8d8b3c0fff3c4d630ef729ec038f694d347a4f3"; }];
    buildInputs = [ python2 ];
  };

  "python2-setuptools" = fetch {
    pname       = "python2-setuptools";
    version     = "40.5.0";
    srcs        = [{ filename = "python2-setuptools-40.5.0-1-any.pkg.tar.xz"; sha256 = "91c236f393952cbd8acede7e947bf3a6ed9106baed0d53de50d115c58cb03557"; }];
    buildInputs = [ python2-packaging python2-appdirs ];
  };

  "python2-setuptools-scm" = fetch {
    pname       = "python2-setuptools-scm";
    version     = "3.1.0";
    srcs        = [{ filename = "python2-setuptools-scm-3.1.0-1-any.pkg.tar.xz"; sha256 = "c2e88c3e6e412a8a99d6004419e33bfd446e64271afe08610ffe808897d77717"; }];
    buildInputs = [ python2 ];
  };

  "python2-six" = fetch {
    pname       = "python2-six";
    version     = "1.12.0";
    srcs        = [{ filename = "python2-six-1.12.0-1-any.pkg.tar.xz"; sha256 = "2a2107a6a1642fe9644f35aac745a3c876ba819104c48abb50a0105dd007fd9d"; }];
    buildInputs = [ python2 ];
  };

  "python2-traceback2" = fetch {
    pname       = "python2-traceback2";
    version     = "1.4.0";
    srcs        = [{ filename = "python2-traceback2-1.4.0-1-any.pkg.tar.xz"; sha256 = "aebf44a83c63f1235048f7aad99be68f3b1dcd3330e9b438802a71fdc07d976f"; }];
    buildInputs = [ python2-linecache2 python2-six ];
  };

  "python2-unittest2" = fetch {
    pname       = "python2-unittest2";
    version     = "1.1.0";
    srcs        = [{ filename = "python2-unittest2-1.1.0-5-any.pkg.tar.xz"; sha256 = "ace9947f784bfc52198cc30a33e369611f5436efdaaf1bdf50ad39e8e46336de"; }];
    buildInputs = [ python2-six python2-traceback2 ];
  };

  "python3-appdirs" = fetch {
    pname       = "python3-appdirs";
    version     = "1.4.3";
    srcs        = [{ filename = "python3-appdirs-1.4.3-3-any.pkg.tar.xz"; sha256 = "672be3425a2a2807bc94eb4c685a4c78bdf43a4b170b493e800cb7eef89dc016"; }];
    buildInputs = [ python3 ];
  };

  "python3-atomicwrites" = fetch {
    pname       = "python3-atomicwrites";
    version     = "1.2.1";
    srcs        = [{ filename = "python3-atomicwrites-1.2.1-1-any.pkg.tar.xz"; sha256 = "d59cb565793692292faee25f30b2365fe314f740c189ade6effbcc36a6604831"; }];
    buildInputs = [ python3 ];
  };

  "python3-attrs" = fetch {
    pname       = "python3-attrs";
    version     = "18.2.0";
    srcs        = [{ filename = "python3-attrs-18.2.0-1-any.pkg.tar.xz"; sha256 = "6c47a09fb2ce1ac4287bddf323640bd733896f45c8ee594175e393d87e4d5396"; }];
    buildInputs = [ python3 ];
  };

  "python3-beaker" = fetch {
    pname       = "python3-beaker";
    version     = "1.10.0";
    srcs        = [{ filename = "python3-beaker-1.10.0-3-i686.pkg.tar.xz"; sha256 = "1d623266bbda7bf34c2b041718f28be4152305a47ff5db2e3e98af350ec40c21"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python.version "3.3"; python) ];
  };

  "python3-colorama" = fetch {
    pname       = "python3-colorama";
    version     = "0.4.1";
    srcs        = [{ filename = "python3-colorama-0.4.1-1-any.pkg.tar.xz"; sha256 = "d0d87d6936d54e4a6300f772f7b665ab68b54b0e8725f0af7069fc822773947c"; }];
    buildInputs = [ python3 ];
  };

  "python3-distutils-extra" = fetch {
    pname       = "python3-distutils-extra";
    version     = "2.39";
    srcs        = [{ filename = "python3-distutils-extra-2.39-2-any.pkg.tar.xz"; sha256 = "4686e03b6d02264b3f41b679d6a79da2762c29fd0d24dd73676d31b7e2e592b4"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast python.version "3.3"; python) intltool ];
  };

  "python3-mako" = fetch {
    pname       = "python3-mako";
    version     = "1.0.7";
    srcs        = [{ filename = "python3-mako-1.0.7-3-i686.pkg.tar.xz"; sha256 = "e17c4483362dc74a8a7c1ec208133dc86921a681313c8ed81e6c0a9b6110b5f0"; }];
    buildInputs = [ python3-markupsafe python3-beaker ];
  };

  "python3-markupsafe" = fetch {
    pname       = "python3-markupsafe";
    version     = "1.1.0";
    srcs        = [{ filename = "python3-markupsafe-1.1.0-1-i686.pkg.tar.xz"; sha256 = "dd793677efba822777f246d09bdcba45d0562e0d4722b366a9a88587d14432ef"; }];
    buildInputs = [ python3 ];
  };

  "python3-mock" = fetch {
    pname       = "python3-mock";
    version     = "2.0.0";
    srcs        = [{ filename = "python3-mock-2.0.0-1-any.pkg.tar.xz"; sha256 = "9497937f3494ffa15f15b4e2ecfb65714d2d23dc0379bb5580ffd05004b21843"; }];
    buildInputs = [ python3 ];
  };

  "python3-more-itertools" = fetch {
    pname       = "python3-more-itertools";
    version     = "4.3.0";
    srcs        = [{ filename = "python3-more-itertools-4.3.0-1-any.pkg.tar.xz"; sha256 = "5d356ae4142a313e47d1de29e406e074bdb08f82060a4294c677830f874648e7"; }];
    buildInputs = [ python3 python3-six ];
  };

  "python3-nose" = fetch {
    pname       = "python3-nose";
    version     = "1.3.7";
    srcs        = [{ filename = "python3-nose-1.3.7-4-i686.pkg.tar.xz"; sha256 = "be2dfae1c8d23eb8ddee8f12c84004951d4267512fb8b5a4e34ebd87f3d469a3"; }];
    buildInputs = [ python3-setuptools ];
  };

  "python3-packaging" = fetch {
    pname       = "python3-packaging";
    version     = "18.0";
    srcs        = [{ filename = "python3-packaging-18.0-1-any.pkg.tar.xz"; sha256 = "2e45bf38073c4b5e55e0c9f3b7c8ac79ea3f4973f371fc2f4caa0bc1707b11f1"; }];
    buildInputs = [ python3-pyparsing python3-six ];
  };

  "python3-pbr" = fetch {
    pname       = "python3-pbr";
    version     = "5.1.1";
    srcs        = [{ filename = "python3-pbr-5.1.1-1-any.pkg.tar.xz"; sha256 = "4f8c4f2e87c26069887fb8d6214f7a40c009f8dbaedaf97a5d760638e2cce7b5"; }];
    buildInputs = [ python3-setuptools ];
  };

  "python3-pip" = fetch {
    pname       = "python3-pip";
    version     = "18.1";
    srcs        = [{ filename = "python3-pip-18.1-1-any.pkg.tar.xz"; sha256 = "c8342f768a6985bc98705f3165510fd2abaf6b32612f19e519e218a3005df9c8"; }];
    buildInputs = [ python3 python3-setuptools ];
  };

  "python3-pluggy" = fetch {
    pname       = "python3-pluggy";
    version     = "0.8.0";
    srcs        = [{ filename = "python3-pluggy-0.8.0-1-any.pkg.tar.xz"; sha256 = "a335797c01a3ca3b6119a3888be139550539906e45ea54defd4b83c14c9c4d70"; }];
    buildInputs = [ python3 ];
  };

  "python3-py" = fetch {
    pname       = "python3-py";
    version     = "1.7.0";
    srcs        = [{ filename = "python3-py-1.7.0-1-any.pkg.tar.xz"; sha256 = "800bf1e26dc702b5aa896e540073c4e393572ba8e727adafc4edb52c2a5069da"; }];
    buildInputs = [ python3 ];
  };

  "python3-pyalpm" = fetch {
    pname       = "python3-pyalpm";
    version     = "0.8.4";
    srcs        = [{ filename = "python3-pyalpm-0.8.4-1-i686.pkg.tar.xz"; sha256 = "7fb53963fd1c43873d9c3ed4b1ec44dd510640730ef32fa3bd70d77a02decaa4"; }];
    buildInputs = [ python3 ];
  };

  "python3-pygments" = fetch {
    pname       = "python3-pygments";
    version     = "2.3.1";
    srcs        = [{ filename = "python3-pygments-2.3.1-1-i686.pkg.tar.xz"; sha256 = "9e9e1d40934203a3bff1dae5cbde33054b3b20ce8daa13d32406cbc751ac708b"; }];
    buildInputs = [ python3 ];
  };

  "python3-pyparsing" = fetch {
    pname       = "python3-pyparsing";
    version     = "2.3.0";
    srcs        = [{ filename = "python3-pyparsing-2.3.0-1-any.pkg.tar.xz"; sha256 = "f9acbc827a70721ae6ab58c10e45c277338e64faa518fa4f899269ca9b7b8441"; }];
    buildInputs = [ python3 ];
  };

  "python3-pytest" = fetch {
    pname       = "python3-pytest";
    version     = "3.9.3";
    srcs        = [{ filename = "python3-pytest-3.9.3-1-any.pkg.tar.xz"; sha256 = "c44b9254e256af640beadb69639cb89a76eafc2e52551fc0ebc485d04525365c"; }];
    buildInputs = [ python3 python3-py python3-setuptools ];
  };

  "python3-pytest-runner" = fetch {
    pname       = "python3-pytest-runner";
    version     = "4.2";
    srcs        = [{ filename = "python3-pytest-runner-4.2-2-any.pkg.tar.xz"; sha256 = "a321997679ce36dad4cd6aa99751cea4d440179e99a34912807637c5ae7340ac"; }];
    buildInputs = [ python3-pytest ];
  };

  "python3-setuptools" = fetch {
    pname       = "python3-setuptools";
    version     = "40.5.0";
    srcs        = [{ filename = "python3-setuptools-40.5.0-1-any.pkg.tar.xz"; sha256 = "034ba488262e8c4498f7042221a86b3b2c01fab2444f741c6dd8459a4e9b1e5e"; }];
    buildInputs = [ python3-packaging python3-appdirs ];
  };

  "python3-setuptools-scm" = fetch {
    pname       = "python3-setuptools-scm";
    version     = "3.1.0";
    srcs        = [{ filename = "python3-setuptools-scm-3.1.0-1-any.pkg.tar.xz"; sha256 = "d18a8e934a77718f47b6f2e0debfee2bde513e9b4ae0dffe018b0cd39a31b466"; }];
    buildInputs = [ python3 ];
  };

  "python3-six" = fetch {
    pname       = "python3-six";
    version     = "1.12.0";
    srcs        = [{ filename = "python3-six-1.12.0-1-any.pkg.tar.xz"; sha256 = "5d3b4c5aeb3e5cb1e3dfefe199ae9df2042b286c17ab1c125811f8077c586eae"; }];
    buildInputs = [ python3 ];
  };

  "quilt" = fetch {
    pname       = "quilt";
    version     = "0.65";
    srcs        = [{ filename = "quilt-0.65-2-any.pkg.tar.xz"; sha256 = "1f22c9ff0298b7d890b8f20548c001e1815c7cabb33d62a8f28b4639a72cb6f9"; }];
    buildInputs = [ bash bzip2 diffstat diffutils findutils gawk gettext gzip patch perl ];
  };

  "rarian" = fetch {
    pname       = "rarian";
    version     = "0.8.1";
    srcs        = [{ filename = "rarian-0.8.1-1-i686.pkg.tar.xz"; sha256 = "5406474b1b731e67f58e0a4cc40543e016761cc95a2500ccf6ba54747284d922"; }];
  };

  "rcs" = fetch {
    pname       = "rcs";
    version     = "5.9.4";
    srcs        = [{ filename = "rcs-5.9.4-2-i686.pkg.tar.xz"; sha256 = "697272548cbbff1afe2e14aa9166b29aa49eae6e2d8c1712100d4226d4a3e8e5"; }];
  };

  "re2c" = fetch {
    pname       = "re2c";
    version     = "1.1.1";
    srcs        = [{ filename = "re2c-1.1.1-1-i686.pkg.tar.xz"; sha256 = "3357f45d47ebe39c684cb793ac85a9bd44d4c4845d5433047b35d5dd3ca2ce98"; }];
    buildInputs = [ gcc-libs ];
  };

  "rebase" = fetch {
    pname       = "rebase";
    version     = "4.4.4";
    srcs        = [{ filename = "rebase-4.4.4-1-i686.pkg.tar.xz"; sha256 = "5cf438a984b1db820d753d597224222aacb35cc14fd565f7053635b3e6c16c8b"; }];
    buildInputs = [ msys2-runtime dash ];
    broken      = true; # broken dependency dash -> msys2-base
  };

  "remake-git" = fetch {
    pname       = "remake-git";
    version     = "4.1.2957.e3e34dd9";
    srcs        = [{ filename = "remake-git-4.1.2957.e3e34dd9-1-i686.pkg.tar.xz"; sha256 = "77264d36b7414e2089737f6f4e1e2be5bb4c432e0f6a5359fbdc3d744486541b"; }];
    buildInputs = [ guile libreadline ];
  };

  "rhash" = fetch {
    pname       = "rhash";
    version     = "1.3.6";
    srcs        = [{ filename = "rhash-1.3.6-2-i686.pkg.tar.xz"; sha256 = "2ad856b075dc2872cd0f81ee31b7b0ba73f372437382b180f29516cc81d27afd"; }];
    buildInputs = [ (assert librhash.version=="1.3.6"; librhash) ];
  };

  "rsync" = fetch {
    pname       = "rsync";
    version     = "3.1.3";
    srcs        = [{ filename = "rsync-3.1.3-1-i686.pkg.tar.xz"; sha256 = "e7a7e21a8c894eba97365265beb0e90a42d31109514f74a0a28d22299c856cbf"; }];
    buildInputs = [ perl ];
  };

  "rsync2" = fetch {
    pname       = "rsync2";
    version     = "3.1.3dev_msys2.7.0_r3";
    srcs        = [{ filename = "rsync2-3.1.3dev_msys2.7.0_r3-0-i686.pkg.tar.xz"; sha256 = "f6eb5906aed02c7b461453d15f03fd57476d8699fd5076ea6149b7f24d3d51d7"; }];
    buildInputs = [ libiconv ];
  };

  "ruby" = fetch {
    pname       = "ruby";
    version     = "2.6.0";
    srcs        = [{ filename = "ruby-2.6.0-1-i686.pkg.tar.xz"; sha256 = "4b2caf0aa1e76df84fd69d8aeca5420ad1f05d356607a74da4420e0370bb59d3"; }];
    buildInputs = [ gcc-libs libopenssl libffi libcrypt gmp libyaml libgdbm libiconv libreadline zlib ];
  };

  "ruby-docs" = fetch {
    pname       = "ruby-docs";
    version     = "2.6.0";
    srcs        = [{ filename = "ruby-docs-2.6.0-1-i686.pkg.tar.xz"; sha256 = "fc6d7a2f66e16ae9f5f1f9f727702b71dee7c20fb5fe058520262822d654b555"; }];
  };

  "scons" = fetch {
    pname       = "scons";
    version     = "3.0.1";
    srcs        = [{ filename = "scons-3.0.1-1-any.pkg.tar.xz"; sha256 = "ff1f2e63f95ffc502976509590619dddf77c042c1de89aa97fa27caf5b479d7c"; }];
    buildInputs = [ python2 ];
  };

  "screenfetch" = fetch {
    pname       = "screenfetch";
    version     = "3.8.0";
    srcs        = [{ filename = "screenfetch-3.8.0-1-any.pkg.tar.xz"; sha256 = "e772b6081cc348fc843f9eb7726287e70b943e7efdaa8eafdea3a98270572f31"; }];
    buildInputs = [ bash ];
  };

  "sed" = fetch {
    pname       = "sed";
    version     = "4.7";
    srcs        = [{ filename = "sed-4.7-1-i686.pkg.tar.xz"; sha256 = "7dd09f6c38a4cee2ff9cf9248ebb3152709e8d5ed57ce167b447d5174c73f420"; }];
    buildInputs = [ libintl sh ];
  };

  "setconf" = fetch {
    pname       = "setconf";
    version     = "0.7.5";
    srcs        = [{ filename = "setconf-0.7.5-1-any.pkg.tar.xz"; sha256 = "e572950c5a1ffb098701349c2909650ab593a859c3208a04ccaae71188ab8f0f"; }];
    buildInputs = [ python2 ];
  };

  "sgml-common" = fetch {
    pname       = "sgml-common";
    version     = "0.6.3";
    srcs        = [{ filename = "sgml-common-0.6.3-1-any.pkg.tar.xz"; sha256 = "b9d707dc2528d52cd0ce5c29e55eaf3d5eeee8490a8384a0d5759cf7078d5923"; }];
    buildInputs = [ sh ];
  };

  "sharutils" = fetch {
    pname       = "sharutils";
    version     = "4.15.2";
    srcs        = [{ filename = "sharutils-4.15.2-1-i686.pkg.tar.xz"; sha256 = "ab8301806a968edb45288f4d25420fc3f21125235a63d4d0525f3e8da4adf682"; }];
    buildInputs = [ perl gettext texinfo ];
  };

  "socat" = fetch {
    pname       = "socat";
    version     = "1.7.3.2";
    srcs        = [{ filename = "socat-1.7.3.2-2-i686.pkg.tar.xz"; sha256 = "31e04d1dd7d28e916acef1906f28f263aba85a1d31582af10a30735468c8662f"; }];
    buildInputs = [ libreadline openssl ];
  };

  "sqlite" = fetch {
    pname       = "sqlite";
    version     = "3.21.0";
    srcs        = [{ filename = "sqlite-3.21.0-4-i686.pkg.tar.xz"; sha256 = "97a78c4944b197695aa9805251645b1e4ebbcd01ae9198d08cd65e707418cbdc"; }];
    buildInputs = [ libreadline libsqlite ];
  };

  "sqlite-doc" = fetch {
    pname       = "sqlite-doc";
    version     = "3.21.0";
    srcs        = [{ filename = "sqlite-doc-3.21.0-4-i686.pkg.tar.xz"; sha256 = "572f3bc10d1596ccd62f431a168afdd604378dfba6bc79e28676d3a2bca95da1"; }];
    buildInputs = [ (assert sqlite.version=="3.21.0"; sqlite) ];
  };

  "ssh-pageant-git" = fetch {
    pname       = "ssh-pageant-git";
    version     = "1.4.12.g6f47092";
    srcs        = [{ filename = "ssh-pageant-git-1.4.12.g6f47092-1-i686.pkg.tar.xz"; sha256 = "49138abc2d569f06279552b7298ee9247727f17acbb0355d6805b3464674bec5"; }];
  };

  "sshpass" = fetch {
    pname       = "sshpass";
    version     = "1.06";
    srcs        = [{ filename = "sshpass-1.06-1-i686.pkg.tar.xz"; sha256 = "a4a593ef930a961432190855310626406a36a45de022dfe0fa828012e07c3d9c"; }];
    buildInputs = [ openssh ];
  };

  "subversion" = fetch {
    pname       = "subversion";
    version     = "1.11.1";
    srcs        = [{ filename = "subversion-1.11.1-1-i686.pkg.tar.xz"; sha256 = "e1867cac0df7a718d7f81da852a76871eb02325a21e7e288e7f89ee3be4243fd"; }];
    buildInputs = [ libsqlite file liblz4 libserf libsasl ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "swig" = fetch {
    pname       = "swig";
    version     = "3.0.12";
    srcs        = [{ filename = "swig-3.0.12-1-i686.pkg.tar.xz"; sha256 = "fd6e7f12d4f1149026ef8baa0569fcb7a24c2a3bcd5d5a74d4753fffd68a6b3a"; }];
    buildInputs = [ zlib libpcre ];
  };

  "tar" = fetch {
    pname       = "tar";
    version     = "1.30";
    srcs        = [{ filename = "tar-1.30-1-i686.pkg.tar.xz"; sha256 = "7588c129b38659395a1d35e79a274f59b44f48d0400205ec8328ab5613244e42"; }];
    buildInputs = [ msys2-runtime libiconv libintl sh ];
  };

  "task" = fetch {
    pname       = "task";
    version     = "2.5.1";
    srcs        = [{ filename = "task-2.5.1-2-i686.pkg.tar.xz"; sha256 = "17146fa351ae17f1a6fb46d9707d30ec7677956f8c58693789da4f6eea87c126"; }];
    buildInputs = [ gcc-libs libgnutls libutil-linux libhogweed ];
  };

  "tcl" = fetch {
    pname       = "tcl";
    version     = "8.6.8";
    srcs        = [{ filename = "tcl-8.6.8-1-i686.pkg.tar.xz"; sha256 = "b54d298524a67a76106a3d2a01040e4082f00130594d9119297b2fe852b1fcf8"; }];
    buildInputs = [ zlib ];
  };

  "tcsh" = fetch {
    pname       = "tcsh";
    version     = "6.20.00";
    srcs        = [{ filename = "tcsh-6.20.00-2-i686.pkg.tar.xz"; sha256 = "793f148c14650fcd7eb5b2e23ff28174939a1aeacc9fbb6ad1259309e3ce4e73"; }];
    buildInputs = [ gcc-libs libcrypt libiconv ncurses ];
  };

  "termbox" = fetch {
    pname       = "termbox";
    version     = "1.1.0";
    srcs        = [{ filename = "termbox-1.1.0-2-i686.pkg.tar.xz"; sha256 = "3751de1d4c1ba21a72af7e934ecac530d944d0fdb8cd74f96142cf6b32cf7630"; }];
  };

  "texinfo" = fetch {
    pname       = "texinfo";
    version     = "6.5";
    srcs        = [{ filename = "texinfo-6.5-2-i686.pkg.tar.xz"; sha256 = "a08220da2dfa9253bb9f37cd4e8d49d677af545a84d9d4a9cfdcd2d9e32851da"; }];
    buildInputs = [ info perl sh ];
  };

  "texinfo-tex" = fetch {
    pname       = "texinfo-tex";
    version     = "6.5";
    srcs        = [{ filename = "texinfo-tex-6.5-2-i686.pkg.tar.xz"; sha256 = "a86cae133e0e69917e4ccc9ae285afa7014dbb78f0c2043bc9562a63fc058ab8"; }];
    buildInputs = [ gawk perl sh ];
  };

  "tftp-hpa" = fetch {
    pname       = "tftp-hpa";
    version     = "5.2";
    srcs        = [{ filename = "tftp-hpa-5.2-2-i686.pkg.tar.xz"; sha256 = "38066b515f0e931325ff66952ee9aaf5af850cfa8b6edba3ee46d2e3aac6a68c"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libreadline.version "6.0.00"; libreadline) ];
  };

  "tig" = fetch {
    pname       = "tig";
    version     = "2.4.1";
    srcs        = [{ filename = "tig-2.4.1-1-i686.pkg.tar.xz"; sha256 = "4ea0f559990924d80d76a615fd26d87f192fcf071126da2d2f44a139775f87ec"; }];
    buildInputs = [ git libreadline ncurses ];
  };

  "time" = fetch {
    pname       = "time";
    version     = "1.9";
    srcs        = [{ filename = "time-1.9-1-i686.pkg.tar.xz"; sha256 = "3acd167f44b7fae55e18e30ce1f22357ef958891e853e9aa284549a7342fba2b"; }];
    buildInputs = [ msys2-runtime ];
  };

  "tio" = fetch {
    pname       = "tio";
    version     = "1.32";
    srcs        = [{ filename = "tio-1.32-1-i686.pkg.tar.xz"; sha256 = "cad1aa1df8629a54c9b75edafafcdda388b5db6a5a66510e25d9ecf0c1c91a16"; }];
  };

  "tmux" = fetch {
    pname       = "tmux";
    version     = "2.8";
    srcs        = [{ filename = "tmux-2.8-1-i686.pkg.tar.xz"; sha256 = "735c3d542695de89cf2ae7e45401cd792d314c3f0150e8b8671d8e41903196cd"; }];
    buildInputs = [ ncurses libevent ];
  };

  "tree" = fetch {
    pname       = "tree";
    version     = "1.8.0";
    srcs        = [{ filename = "tree-1.8.0-1-i686.pkg.tar.xz"; sha256 = "1b44ccdcfeac2feeddbba712db4e5c7219aa87ad36ef21ebb52aa23b056814c1"; }];
    buildInputs = [ msys2-runtime ];
  };

  "ttyrec" = fetch {
    pname       = "ttyrec";
    version     = "1.0.8";
    srcs        = [{ filename = "ttyrec-1.0.8-2-i686.pkg.tar.xz"; sha256 = "a77b824652c507fee1f2f2d24d27296b0dd5e144c2dd82699967f207ca87dce5"; }];
    buildInputs = [ sh ];
  };

  "txt2html" = fetch {
    pname       = "txt2html";
    version     = "2.5201";
    srcs        = [{ filename = "txt2html-2.5201-1-i686.pkg.tar.xz"; sha256 = "ad31077787135d5b2e327bfe14e2f2313931befb0abe5db0f8a08334e045edc5"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) perl-Getopt-ArgvFile ];
  };

  "txt2tags" = fetch {
    pname       = "txt2tags";
    version     = "2.6";
    srcs        = [{ filename = "txt2tags-2.6-5-any.pkg.tar.xz"; sha256 = "222125c2dbdb434d7acc9980657e91994cf342eef5e4812622d25d96b570b4e5"; }];
    buildInputs = [ python2 ];
  };

  "tzcode" = fetch {
    pname       = "tzcode";
    version     = "2018.c";
    srcs        = [{ filename = "tzcode-2018.c-1-i686.pkg.tar.xz"; sha256 = "6e81770c3e2db9c0143254c429e35d41df3b2d337117cc014083e289de806078"; }];
    buildInputs = [ coreutils gawk sed ];
  };

  "ucl" = fetch {
    pname       = "ucl";
    version     = "1.03";
    srcs        = [{ filename = "ucl-1.03-2-i686.pkg.tar.xz"; sha256 = "5594beb9c103e86dd23f79e81fa80e14bedf0194fbb31113732a37f9cb409b95"; }];
  };

  "ucl-devel" = fetch {
    pname       = "ucl-devel";
    version     = "1.03";
    srcs        = [{ filename = "ucl-devel-1.03-2-i686.pkg.tar.xz"; sha256 = "ff542fe4e366870c11bc5b00cb90d9e85426da6bd60a0bfe8ee9d33c9369acb2"; }];
    buildInputs = [ (assert ucl.version=="1.03"; ucl) ];
  };

  "unrar" = fetch {
    pname       = "unrar";
    version     = "5.6.8";
    srcs        = [{ filename = "unrar-5.6.8-1-i686.pkg.tar.xz"; sha256 = "d18411c1209af97887dfc64654db4d7426782e1ad609df47d54d3f444319150d"; }];
    buildInputs = [ gcc-libs ];
  };

  "unzip" = fetch {
    pname       = "unzip";
    version     = "6.0";
    srcs        = [{ filename = "unzip-6.0-2-i686.pkg.tar.xz"; sha256 = "0807f1f228049ad3b87f229eb60a8fd767313d4c50949d8490622777537e05e3"; }];
    buildInputs = [  ];
  };

  "upx" = fetch {
    pname       = "upx";
    version     = "3.95";
    srcs        = [{ filename = "upx-3.95-2-i686.pkg.tar.xz"; sha256 = "49d67fdcd620bf3ac6cdc026191613d5d8dfdd2d0d68260ffc43838a84e696f4"; }];
    buildInputs = [ ucl zlib ];
  };

  "util-linux" = fetch {
    pname       = "util-linux";
    version     = "2.32.1";
    srcs        = [{ filename = "util-linux-2.32.1-1-i686.pkg.tar.xz"; sha256 = "573f7a1b8a06d37d76f7e31e14129c65466864d15d046358548a9d96969de329"; }];
    buildInputs = [ coreutils libutil-linux libiconv ];
  };

  "util-macros" = fetch {
    pname       = "util-macros";
    version     = "1.19.2";
    srcs        = [{ filename = "util-macros-1.19.2-1-any.pkg.tar.xz"; sha256 = "36b254ee51d554ae45e6e9fe015839b6c0c0f13976f993384727b66ecf35a36f"; }];
  };

  "vifm" = fetch {
    pname       = "vifm";
    version     = "0.10";
    srcs        = [{ filename = "vifm-0.10-1-i686.pkg.tar.xz"; sha256 = "e3d61420107fc4f2d634abf9f3ec5d879be72b843c04f0ff14ac3125ab703f63"; }];
    buildInputs = [ ncurses ];
  };

  "vim" = fetch {
    pname       = "vim";
    version     = "8.1.0500";
    srcs        = [{ filename = "vim-8.1.0500-1-i686.pkg.tar.xz"; sha256 = "07097cb409c7fb193499935cd508a9dddd83898248f17fbee7e2fe5c4cc92654"; }];
    buildInputs = [ ncurses ];
  };

  "vimpager" = fetch {
    pname       = "vimpager";
    version     = "2.06";
    srcs        = [{ filename = "vimpager-2.06-1-any.pkg.tar.xz"; sha256 = "215ef58b537988b3fd57889ec29fecf63cfe99e749679ff319738b8d04dc1c97"; }];
    buildInputs = [ vim sharutils ];
  };

  "vimpager-git" = fetch {
    pname       = "vimpager-git";
    version     = "r279.bc5548d";
    srcs        = [{ filename = "vimpager-git-r279.bc5548d-1-any.pkg.tar.xz"; sha256 = "12ea17012240f0118ce1eed19bee53b66c4a55b8cc272da42ea06bb1a783345e"; }];
    buildInputs = [ vim sharutils ];
  };

  "w3m" = fetch {
    pname       = "w3m";
    version     = "0.5.3+20180125";
    srcs        = [{ filename = "w3m-0.5.3+20180125-1-i686.pkg.tar.xz"; sha256 = "e3f414b0584236ee06cf1882a47fddd4590cfc6e6471c9231ba706504f7a5c0d"; }];
    buildInputs = [ libgc libiconv libintl openssl zlib ncurses ];
  };

  "wcd" = fetch {
    pname       = "wcd";
    version     = "6.0.2";
    srcs        = [{ filename = "wcd-6.0.2-1-i686.pkg.tar.xz"; sha256 = "013b26ea3030c81f86815766f2edc10824bed047532233b83e0813fc7ce3a5ba"; }];
    buildInputs = [ libintl libunistring ncurses ];
  };

  "wget" = fetch {
    pname       = "wget";
    version     = "1.20.1";
    srcs        = [{ filename = "wget-1.20.1-1-i686.pkg.tar.xz"; sha256 = "0d1feb9d400515d3735fbec5c87a2042d6ce7fb05d2fd4be8e4dc42e75026b6e"; }];
    buildInputs = [ gcc-libs libiconv libidn2 libintl libgpgme libmetalink libpcre2_8 libpsl libuuid openssl zlib ];
    broken      = true; # broken dependency wget -> libuuid
  };

  "which" = fetch {
    pname       = "which";
    version     = "2.21";
    srcs        = [{ filename = "which-2.21-2-i686.pkg.tar.xz"; sha256 = "552fe6c98ff66d1e25625d973ea9cb2de651b714337cf3de8d2bb72d5fe9a6ad"; }];
    buildInputs = [ msys2-runtime sh ];
  };

  "whois" = fetch {
    pname       = "whois";
    version     = "5.4.0";
    srcs        = [{ filename = "whois-5.4.0-2-i686.pkg.tar.xz"; sha256 = "4f907acac1eb23a53c7cc67cf3cdfad0286c3deadcd1a87437517e8206a2158d"; }];
    buildInputs = [ libcrypt libidn2 libiconv ];
  };

  "windows-default-manifest" = fetch {
    pname       = "windows-default-manifest";
    version     = "6.4";
    srcs        = [{ filename = "windows-default-manifest-6.4-1-i686.pkg.tar.xz"; sha256 = "68874f99258092310a85ba67bda5f8cb4ad9426d21a1f91b311474a18b0644fc"; }];
    buildInputs = [  ];
  };

  "winln" = fetch {
    pname       = "winln";
    version     = "1.1";
    srcs        = [{ filename = "winln-1.1-1-i686.pkg.tar.xz"; sha256 = "168aa32c121165f3a74d0d8b694d4b2ea54f9ada190bd3590ffe15d969d5523c"; }];
  };

  "winpty" = fetch {
    pname       = "winpty";
    version     = "0.4.3";
    srcs        = [{ filename = "winpty-0.4.3-1-i686.pkg.tar.xz"; sha256 = "76a8cbdbad9072b093da8b1aa22f10cb24d1820983696324aceaf3c826a69ff2"; }];
  };

  "xdelta3" = fetch {
    pname       = "xdelta3";
    version     = "3.1.0";
    srcs        = [{ filename = "xdelta3-3.1.0-1-i686.pkg.tar.xz"; sha256 = "6cebaf88ea2b899cddc4918d7aa9b374ee9025bcaee326c498c568afcede89f5"; }];
    buildInputs = [ xz liblzma ];
  };

  "xmlto" = fetch {
    pname       = "xmlto";
    version     = "0.0.28";
    srcs        = [{ filename = "xmlto-0.0.28-2-i686.pkg.tar.xz"; sha256 = "a67bfaf48fea6c854d4a4ac397c04f6136c220051d2698973974598b89189450"; }];
    buildInputs = [ libxslt perl-YAML-Syck perl-Test-Pod ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "xorriso" = fetch {
    pname       = "xorriso";
    version     = "1.4.8";
    srcs        = [{ filename = "xorriso-1.4.8-1-i686.pkg.tar.xz"; sha256 = "6492b5b74890d5bcbd5d17e27270e80f7e4a10452beafaa6d3d04f19a6b26e4b"; }];
    buildInputs = [ libbz2 libreadline zlib ];
  };

  "xproto" = fetch {
    pname       = "xproto";
    version     = "7.0.26";
    srcs        = [{ filename = "xproto-7.0.26-1-any.pkg.tar.xz"; sha256 = "2bf0c8e239bf25ca15f92bd7a515318be669c2cb9041b37c0f17752887a23d90"; }];
  };

  "xz" = fetch {
    pname       = "xz";
    version     = "5.2.4";
    srcs        = [{ filename = "xz-5.2.4-1-i686.pkg.tar.xz"; sha256 = "faac8f3c59c1181868e012168c4bcd591512014d584181253b79c6fc9fba9b9c"; }];
    buildInputs = [ (assert liblzma.version=="5.2.4"; liblzma) libiconv libintl ];
  };

  "yasm" = fetch {
    pname       = "yasm";
    version     = "1.3.0";
    srcs        = [{ filename = "yasm-1.3.0-2-i686.pkg.tar.xz"; sha256 = "927e6f647aef3501bc3980fa8d078731e3c96babf222e875b3d096e1a6ad6373"; }];
  };

  "yasm-devel" = fetch {
    pname       = "yasm-devel";
    version     = "1.3.0";
    srcs        = [{ filename = "yasm-devel-1.3.0-2-i686.pkg.tar.xz"; sha256 = "eb68fa1c1fba95ad4fbbc0215ad21016a4c2d04865b16b27055d0e6c8badacb5"; }];
  };

  "yelp-tools" = fetch {
    pname       = "yelp-tools";
    version     = "3.28.0";
    srcs        = [{ filename = "yelp-tools-3.28.0-1-any.pkg.tar.xz"; sha256 = "ede637ffacbbf51242cf2f7d70ef86ab4a255d14c3d574198da9d759204de85a"; }];
    buildInputs = [ yelp-xsl itstool libxslt-python libxml2-python ];
  };

  "yelp-xsl" = fetch {
    pname       = "yelp-xsl";
    version     = "3.30.1";
    srcs        = [{ filename = "yelp-xsl-3.30.1-1-any.pkg.tar.xz"; sha256 = "e7c157f69e445d5b61442be663783ec714c9e4d50c85f619aede70347be1d3e8"; }];
    buildInputs = [  ];
  };

  "yodl" = fetch {
    pname       = "yodl";
    version     = "4.01.00";
    srcs        = [{ filename = "yodl-4.01.00-1-i686.pkg.tar.xz"; sha256 = "b6a8539a52e440b361172c8c0d9ea9239393cb3dcd2ed3d8f7813a896f5b7ae4"; }];
    buildInputs = [ bash ];
  };

  "zip" = fetch {
    pname       = "zip";
    version     = "3.0";
    srcs        = [{ filename = "zip-3.0-3-i686.pkg.tar.xz"; sha256 = "e5ec80aa4921ec3da6e229b6573c7bc8aae0bf4e0a60885de89e05936fe0ee80"; }];
    buildInputs = [ libbz2 ];
  };

  "zlib" = fetch {
    pname       = "zlib";
    version     = "1.2.11";
    srcs        = [{ filename = "zlib-1.2.11-1-i686.pkg.tar.xz"; sha256 = "8055bc4832aff838882ccbbc5526e5c26942d69959e66f6fe4b3a979b1d284d6"; }];
    buildInputs = [ gcc-libs ];
  };

  "zlib-devel" = fetch {
    pname       = "zlib-devel";
    version     = "1.2.11";
    srcs        = [{ filename = "zlib-devel-1.2.11-1-i686.pkg.tar.xz"; sha256 = "8a6af75fc94774e6ff4f6cd20d1030ab2915766c9a4c82ecbf99a4386fd9355c"; }];
    buildInputs = [ (assert zlib.version=="1.2.11"; zlib) ];
  };

  "znc-git" = fetch {
    pname       = "znc-git";
    version     = "r5021.72c5f57b";
    srcs        = [{ filename = "znc-git-r5021.72c5f57b-1-i686.pkg.tar.xz"; sha256 = "fef1d23f96aa4901731e3c2eb7bbd0adea17a7e86060d2aeefbf7055d0fadc70"; }];
    buildInputs = [ openssl ];
  };

  "zsh" = fetch {
    pname       = "zsh";
    version     = "5.6.2";
    srcs        = [{ filename = "zsh-5.6.2-1-i686.pkg.tar.xz"; sha256 = "8d7e74354280725797e7b1bea6791be101e7d1dc6011d0bdc320cd4d6c8cdc32"; }];
    buildInputs = [ ncurses pcre libiconv gdbm ];
  };

  "zsh-doc" = fetch {
    pname       = "zsh-doc";
    version     = "5.6.2";
    srcs        = [{ filename = "zsh-doc-5.6.2-1-i686.pkg.tar.xz"; sha256 = "63d5687e706df34c72e36726409ad55c61b3c9779757770ba88d84e3d33e892c"; }];
  };

}; in self
