 # GENERATED FILE
{stdenvNoCC, fetchurl, mingwPacman, msysPacman}:

let
  fetch = { pname, version, srcs, buildInputs ? [], broken ? false }:
    if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
      stdenvNoCC.mkDerivation {
        inherit version buildInputs;
        name = "msys32-${pname}-${version}";
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
          ${ stdenvNoCC.lib.concatMapStringsSep "\n" (dep: ''
                for my $path (glob('${dep}/*')) {
                  symtree_link($ENV{out}, $path, basename($path)) if basename($path) ne 'bin';
                }
              '') buildInputs }
          chdir($ENV{out});
          ${ # avoid infinite recursion by skipping `bash' and `coreutils' and their deps (TODO: make a fake env to run post_install)
             stdenvNoCC.lib.optionalString (!(builtins.elem "msys/${pname}" ["msys/msys2-runtime" "msys/bash" "msys/coreutils" "msys/gmp" "msys/libiconv" "msys/gcc-libs" "msys/libintl"])) ''
                if (-f ".INSTALL") {
                  $ENV{PATH} = '${msysPacman.bash}/usr/bin;${msysPacman.coreutils}/usr/bin';
                  system("bash -c \"ls -la ; . .INSTALL ; post_install || (echo 'post_install failed'; true)\"") == 0 or die;
                }
              '' }
          unlinkL ".BUILDINFO";
          unlinkL ".INSTALL";
          unlinkL ".MTREE";
          unlinkL ".PKGINFO";
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
  python3 = mingwPacman.python3;

  "apr" = fetch {
    pname       = "apr";
    version     = "1.7.0";
    srcs        = [{ filename = "apr-1.7.0-1-i686.pkg.tar.xz"; sha256 = "66050c16941b36b946d4eacec5c0a2508bf49d48e7ec6659316847d3ee0f7a56"; }];
    buildInputs = [ libcrypt libuuid ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "apr-devel" = fetch {
    pname       = "apr-devel";
    version     = "1.7.0";
    srcs        = [{ filename = "apr-devel-1.7.0-1-i686.pkg.tar.xz"; sha256 = "23318963ec46270c2b6bd70aed54ed3a3bbc9e7f6cd3b992ed18365cc298816b"; }];
    buildInputs = [ (assert apr.version=="1.7.0"; apr) libcrypt-devel libuuid-devel ];
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
    version     = "9.0.0rc2";
    srcs        = [{ filename = "asciidoc-9.0.0rc2-1-any.pkg.tar.xz"; sha256 = "652ba680a144baf0c7cc6df179f00aa994ddbab1b1b7d6e0a8435746e8552119"; }];
    buildInputs = [ python libxslt docbook-xsl ];
  };

  "aspell" = fetch {
    pname       = "aspell";
    version     = "0.60.8";
    srcs        = [{ filename = "aspell-0.60.8-1-i686.pkg.tar.xz"; sha256 = "2c6f70e56f6ac3733b2d2a54e339136fb46bf001f696e0a028b33683d7ee95b1"; }];
    buildInputs = [ gcc-libs gettext libiconv ncurses ];
  };

  "aspell-devel" = fetch {
    pname       = "aspell-devel";
    version     = "0.60.8";
    srcs        = [{ filename = "aspell-devel-0.60.8-1-i686.pkg.tar.xz"; sha256 = "5ee7c055ad9a89ba1903a9ef352b86fa6cde60eacb47365b35644a082a464d3b"; }];
    buildInputs = [ (assert aspell.version=="0.60.8"; aspell) gettext-devel libiconv-devel ncurses-devel ];
  };

  "aspell6-en" = fetch {
    pname       = "aspell6-en";
    version     = "2019.10.06";
    srcs        = [{ filename = "aspell6-en-2019.10.06-1-i686.pkg.tar.xz"; sha256 = "c3f2d79fa6186becbf1d3a7223a101d9938decce18ac659b3c66f9d7bc38f6d7"; }];
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
    version     = "2.17.8";
    srcs        = [{ filename = "axel-2.17.8-1-i686.pkg.tar.xz"; sha256 = "c58f4289f20e70c8edb6c28a959fc56982fd62c5e7d29ec924a90fc9dee04a07"; }];
    buildInputs = [ openssl gettext ];
  };

  "bash" = fetch {
    pname       = "bash";
    version     = "4.4.023";
    srcs        = [{ filename = "bash-4.4.023-2-i686.pkg.tar.xz"; sha256 = "a012de11a36094bdf602e7dbc5d697b9f8cb30f834fcf0a41d7426e1bf855324"; }];
    buildInputs = [ msys2-runtime ];
  };

  "bash-completion" = fetch {
    pname       = "bash-completion";
    version     = "2.10";
    srcs        = [{ filename = "bash-completion-2.10-1-any.pkg.tar.xz"; sha256 = "f5db0d36caa71d4277631c8703a895b7f1d98a2bfb25e7ed1251479c0f201eca"; }];
    buildInputs = [ bash ];
  };

  "bash-devel" = fetch {
    pname       = "bash-devel";
    version     = "4.4.023";
    srcs        = [{ filename = "bash-devel-4.4.023-2-i686.pkg.tar.xz"; sha256 = "2138e3631763074d6ec17d5449683d7a457f4906805dde844f27d7dcd192db47"; }];
  };

  "bc" = fetch {
    pname       = "bc";
    version     = "1.07.1";
    srcs        = [{ filename = "bc-1.07.1-2-i686.pkg.tar.xz"; sha256 = "e63752cecdd646522281fabd67758b7ca5ed873e219bb0f9f29ab9d512a115f5"; }];
    buildInputs = [ libreadline ncurses ];
  };

  "binutils" = fetch {
    pname       = "binutils";
    version     = "2.34";
    srcs        = [{ filename = "binutils-2.34-2-i686.pkg.tar.xz"; sha256 = "b11eb6a3b4408aa462d8943ab29b950434ec08c2d8e25d6de2806fd1c20f3027"; }];
    buildInputs = [ libiconv libintl zlib ];
  };

  "bison" = fetch {
    pname       = "bison";
    version     = "3.6.2";
    srcs        = [{ filename = "bison-3.6.2-1-i686.pkg.tar.zst"; sha256 = "43d9d290854f1b9873c3a09cce1a660e4fc53556e7cd4b2fb8e50066c3d13e53"; }];
    buildInputs = [ m4 sh ];
  };

  "bisonc++" = fetch {
    pname       = "bisonc++";
    version     = "6.04.00";
    srcs        = [{ filename = "bisonc++-6.04.00-1-i686.pkg.tar.xz"; sha256 = "cd3941a9f3aacbd9733a07b9a459399569791f4fbd7fc030db79757966c7717a"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libbobcat.version "4.02.00"; libbobcat) ];
  };

  "breezy" = fetch {
    pname       = "breezy";
    version     = "3.0.2.5";
    srcs        = [{ filename = "breezy-3.0.2.5-1-i686.pkg.tar.xz"; sha256 = "69f010c48bbee2e7593fd4ea82a2e2ae06d238e77f0185427edd8abd9d6916c7"; }];
    buildInputs = [ python-configobj python-fastimport python-dulwich python-patiencediff python-six ];
  };

  "brotli" = fetch {
    pname       = "brotli";
    version     = "1.0.7";
    srcs        = [{ filename = "brotli-1.0.7-3-i686.pkg.tar.xz"; sha256 = "2177c0c01f310b5cd5337cdf3a570ffe36ae33922c0741233b45a3af0f0ec2b9"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "brotli-devel" = fetch {
    pname       = "brotli-devel";
    version     = "1.0.7";
    srcs        = [{ filename = "brotli-devel-1.0.7-3-i686.pkg.tar.xz"; sha256 = "8767b3c9a9f4f2bbfa412c6e1d4837fc18687111dacf625632f41d7700f40664"; }];
    buildInputs = [ brotli ];
  };

  "brotli-testdata" = fetch {
    pname       = "brotli-testdata";
    version     = "1.0.7";
    srcs        = [{ filename = "brotli-testdata-1.0.7-3-i686.pkg.tar.xz"; sha256 = "fdab46d86ced482dee645142c6a46bc52eb7a4650552e2b806410980cddf8176"; }];
  };

  "bsdcpio" = fetch {
    pname       = "bsdcpio";
    version     = "3.4.2";
    srcs        = [{ filename = "bsdcpio-3.4.2-2-i686.pkg.tar.xz"; sha256 = "aa9d2dee2e6a42624d287e11f088fe09b99cc62852ceccbd9cc6d08310840728"; }];
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 libnettle libxml2 libzstd zlib ];
  };

  "bsdtar" = fetch {
    pname       = "bsdtar";
    version     = "3.4.2";
    srcs        = [{ filename = "bsdtar-3.4.2-2-i686.pkg.tar.xz"; sha256 = "d4d3236b77d0404fa5d9a66ba51f0756899ffd94459c8850d3a28b33bed359a8"; }];
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 libnettle libxml2 libzstd zlib ];
  };

  "btyacc" = fetch {
    pname       = "btyacc";
    version     = "20200330";
    srcs        = [{ filename = "btyacc-20200330-1-i686.pkg.tar.zst"; sha256 = "81f0e0cdb0412d647f210e051db563769ae528b47a45b4ec85330bee05b13616"; }];
  };

  "busybox" = fetch {
    pname       = "busybox";
    version     = "1.31.1";
    srcs        = [{ filename = "busybox-1.31.1-1-i686.pkg.tar.zst"; sha256 = "728f01c240f44c7f5327f29d8a91cb485643f209d603688a5442aec62479a103"; }];
    buildInputs = [ msys2-runtime ];
  };

  "bzip2" = fetch {
    pname       = "bzip2";
    version     = "1.0.8";
    srcs        = [{ filename = "bzip2-1.0.8-2-i686.pkg.tar.xz"; sha256 = "a84b1a337b1691b4a5cd97e513be7516386392041fc5a1df2d44ed0a023cba65"; }];
    buildInputs = [ libbz2 ];
  };

  "ca-certificates" = fetch {
    pname       = "ca-certificates";
    version     = "20190110";
    srcs        = [{ filename = "ca-certificates-20190110-1-any.pkg.tar.xz"; sha256 = "d86e8fe7e89528efcc05b2abdff19bde9198dd5e38cf2347644892c337fb1f78"; }];
    buildInputs = [ bash openssl findutils coreutils sed p11-kit ];
  };

  "ccache" = fetch {
    pname       = "ccache";
    version     = "3.7.9";
    srcs        = [{ filename = "ccache-3.7.9-1-i686.pkg.tar.xz"; sha256 = "3ee405a7f66c9acc1d5a52eb1463938c8fa08352844aaf57c11f1e8966057966"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "cdecl" = fetch {
    pname       = "cdecl";
    version     = "2.5";
    srcs        = [{ filename = "cdecl-2.5-1-i686.pkg.tar.xz"; sha256 = "9cb2a78c49c19bde87f1d56d7377abf0eb399ea83c470549c73b0d7d8a7adb29"; }];
  };

  "cgdb" = fetch {
    pname       = "cgdb";
    version     = "0.7.1";
    srcs        = [{ filename = "cgdb-0.7.1-3-i686.pkg.tar.xz"; sha256 = "10eeac7262e89f69ccc03554893449b3657a5a40d2578df32d60190a8da073a7"; }];
    buildInputs = [ libreadline ncurses gdb ];
  };

  "cloc" = fetch {
    pname       = "cloc";
    version     = "1.84";
    srcs        = [{ filename = "cloc-1.84-1-any.pkg.tar.xz"; sha256 = "1eb05bfc8219d14e013bbe1a5f98c03d8074520d8e36a34fc869db631dd9c2e2"; }];
    buildInputs = [ perl perl-Algorithm-Diff perl-Regexp-Common perl-Parallel-ForkManager ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "cloog" = fetch {
    pname       = "cloog";
    version     = "0.20.0";
    srcs        = [{ filename = "cloog-0.20.0-1-i686.pkg.tar.xz"; sha256 = "74050f3fb0455a0c5eee098c50bae90215057dfd16db20a0ac72c8f8625db0c7"; }];
    buildInputs = [ isl ];
  };

  "cloog-devel" = fetch {
    pname       = "cloog-devel";
    version     = "0.20.0";
    srcs        = [{ filename = "cloog-devel-0.20.0-1-i686.pkg.tar.xz"; sha256 = "8b66e391b81c50723da4d793bbdd8186ce17590d608ef77c9bd911e19641891f"; }];
    buildInputs = [ (assert cloog.version=="0.20.0"; cloog) isl-devel ];
  };

  "cmake" = fetch {
    pname       = "cmake";
    version     = "3.17.2";
    srcs        = [{ filename = "cmake-3.17.2-1-i686.pkg.tar.zst"; sha256 = "9f5c48e367817b57b36d91d5740e30b46b4714f88fa72c7914d7b82b2d9c205e"; }];
    buildInputs = [ gcc-libs jsoncpp libcurl libexpat libarchive librhash libutil-linux libuv ncurses pkg-config zlib ];
  };

  "cmake-emacs" = fetch {
    pname       = "cmake-emacs";
    version     = "3.17.2";
    srcs        = [{ filename = "cmake-emacs-3.17.2-1-i686.pkg.tar.zst"; sha256 = "38cad55964dc0fcbf4f0494bb2a9f1f9ec97dd6d2c4fe33886bc62991fca2c8e"; }];
    buildInputs = [ (assert cmake.version=="3.17.2"; cmake) emacs ];
  };

  "cmake-vim" = fetch {
    pname       = "cmake-vim";
    version     = "3.17.2";
    srcs        = [{ filename = "cmake-vim-3.17.2-1-i686.pkg.tar.zst"; sha256 = "0ba549575e0e96390f6f3c032f920a89b590658605f4584ea1a44e989bbd1737"; }];
    buildInputs = [ (assert cmake.version=="3.17.2"; cmake) vim ];
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
    version     = "8.32";
    srcs        = [{ filename = "coreutils-8.32-1-i686.pkg.tar.xz"; sha256 = "3ad732271494ba1ff7c78f4d6af822fa3782b53d80404eeb32dce16043f1ea1c"; }];
    buildInputs = [ gmp libiconv libintl ];
  };

  "cpio" = fetch {
    pname       = "cpio";
    version     = "2.13";
    srcs        = [{ filename = "cpio-2.13-1-i686.pkg.tar.xz"; sha256 = "285f77a6950c75bcfa55603adbfea424b4b26ac9102b6d290a1add52f3eaaac1"; }];
    buildInputs = [ libintl ];
  };

  "crosstool-ng" = fetch {
    pname       = "crosstool-ng";
    version     = "1.24.0";
    srcs        = [{ filename = "crosstool-ng-1.24.0-1-i686.pkg.tar.xz"; sha256 = "0d806ba8ad5de1e1c40c9d52c77cc5b26d4d91eed4ddb0ab3aebb2fd913c22ce"; }];
    buildInputs = [ ncurses libintl ];
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
    version     = "7.70.0";
    srcs        = [{ filename = "curl-7.70.0-1-i686.pkg.tar.zst"; sha256 = "f43a7b6ecb078895643b588bc6bd44fcb8ad2f4147e182bbab3c2154c2d8a6e6"; }];
    buildInputs = [ ca-certificates libcurl libcrypt libmetalink libunistring libnghttp2 libpsl openssl zlib ];
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
    srcs        = [{ filename = "cygrunsrv-1.62-2-i686.pkg.tar.xz"; sha256 = "464dd4d871bfa2a3d07a3eb60f16973e8ec4687b1d4c6ba346363f056f341f64"; }];
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

  "dialog" = fetch {
    pname       = "dialog";
    version     = "1.3_20200228";
    srcs        = [{ filename = "dialog-1.3_20200228-1-i686.pkg.tar.xz"; sha256 = "d74e5c5bb5b016df7be7c313963744f0f19099e702d2e6fb3199c6e66ea1d9e7"; }];
    buildInputs = [ ncurses ];
  };

  "diffstat" = fetch {
    pname       = "diffstat";
    version     = "1.63";
    srcs        = [{ filename = "diffstat-1.63-1-i686.pkg.tar.xz"; sha256 = "ced79c63e65b8fa6a52a80cdcb200e013e6340969d0f31534790d840ad50262b"; }];
    buildInputs = [ msys2-runtime ];
  };

  "diffutils" = fetch {
    pname       = "diffutils";
    version     = "3.7";
    srcs        = [{ filename = "diffutils-3.7-1-i686.pkg.tar.xz"; sha256 = "d6dd47ec699ee3d0bf82dbbee310056dd59218337a743a2ecd540da0b1ac7369"; }];
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
    version     = "7.4.1";
    srcs        = [{ filename = "dos2unix-7.4.1-1-i686.pkg.tar.xz"; sha256 = "040b76a5ad78c5be1e42e17f3d4eeef8153abb404f96e6b668bccd4e89028610"; }];
    buildInputs = [ libintl ];
  };

  "dosfstools" = fetch {
    pname       = "dosfstools";
    version     = "4.1";
    srcs        = [{ filename = "dosfstools-4.1-1-i686.pkg.tar.xz"; sha256 = "519a26c700083bb93fde67dab864880978fac33e7dbd3c65188a9ff2ac115fd3"; }];
    buildInputs = [ libiconv libiconv-devel ];
  };

  "doxygen" = fetch {
    pname       = "doxygen";
    version     = "1.8.18";
    srcs        = [{ filename = "doxygen-1.8.18-1-i686.pkg.tar.zst"; sha256 = "4569d0571b2e77b2e3b5924f7210514b12c54b5c81dc7e9f5d0cd2c481c9a851"; }];
    buildInputs = [ gcc-libs libsqlite libiconv ];
  };

  "dtc" = fetch {
    pname       = "dtc";
    version     = "1.6.0";
    srcs        = [{ filename = "dtc-1.6.0-2-i686.pkg.tar.xz"; sha256 = "412e64aa35be31c3a9aa7dc1ff940770d9a3f1b8f936f184d26b66189715b5ab"; }];
    buildInputs = [ libyaml ];
  };

  "easyoptions-git" = fetch {
    pname       = "easyoptions-git";
    version     = "r37.c481763";
    srcs        = [{ filename = "easyoptions-git-r37.c481763-1-any.pkg.tar.xz"; sha256 = "68204fd1ad1ccec9048a130c824e5ae4bb563d88442111ec153b254d47143eb7"; }];
    buildInputs = [ ruby bash ];
  };

  "ed" = fetch {
    pname       = "ed";
    version     = "1.16";
    srcs        = [{ filename = "ed-1.16-1-i686.pkg.tar.xz"; sha256 = "02880db24c868958b53ef0aad53b7891d9c6f0a73bece8af871c93e23e3372ba"; }];
    buildInputs = [ sh ];
  };

  "editorconfig-vim" = fetch {
    pname       = "editorconfig-vim";
    version     = "1.0.0_beta";
    srcs        = [{ filename = "editorconfig-vim-1.0.0_beta-1-i686.pkg.tar.xz"; sha256 = "de4da25f7ac8e7b9c6869fb5a90daa15ed21db778942c45cbb3223bed94d7494"; }];
    buildInputs = [ vim ];
  };

  "elinks-git" = fetch {
    pname       = "elinks-git";
    version     = "0.13.4008.f86be659";
    srcs        = [{ filename = "elinks-git-0.13.4008.f86be659-5-i686.pkg.tar.xz"; sha256 = "da145d4b84420e8eee93d2e16390b447301c811cda96112da2ce1f9197c604d1"; }];
    buildInputs = [ doxygen gettext libbz2 libcrypt libexpat libffi libgc libgcrypt libgnutls libhogweed libiconv libidn liblzma libnettle libp11-kit libtasn1 libtre-git libunistring perl python3 xmlto zlib ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "emacs" = fetch {
    pname       = "emacs";
    version     = "26.3";
    srcs        = [{ filename = "emacs-26.3-1-i686.pkg.tar.xz"; sha256 = "133959f31fff200b91f1fa4b218bc1041c052a8888210904f3510a97bf1742c2"; }];
    buildInputs = [ ncurses zlib libxml2 libiconv libcrypt libgnutls glib2 libhogweed ];
  };

  "expat" = fetch {
    pname       = "expat";
    version     = "2.2.9";
    srcs        = [{ filename = "expat-2.2.9-1-i686.pkg.tar.xz"; sha256 = "cb1db413c466a64a613dc0acc0217be66dc4194fc66d6887b2a3e27139296c46"; }];
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
    version     = "5.38";
    srcs        = [{ filename = "file-5.38-3-i686.pkg.tar.xz"; sha256 = "744e36ad8fa0d657a0b45061e47a32a8e27348b00f7df385245a490f03da633d"; }];
    buildInputs = [ gcc-libs msys2-runtime zlib ];
  };

  "filesystem" = fetch {
    pname       = "filesystem";
    version     = "2020.02";
    srcs        = [{ filename = "filesystem-2020.02-2-i686.pkg.tar.xz"; sha256 = "e582e0d7e8b3ba689cddcc95dc6d9de5a17c725bd2cc6e0633e6c0d3e0188899"; }];
  };

  "findutils" = fetch {
    pname       = "findutils";
    version     = "4.7.0";
    srcs        = [{ filename = "findutils-4.7.0-1-i686.pkg.tar.xz"; sha256 = "713baa3c9a8e8a6f7caf90ef97c808877803dc79f69559b7d5c2998a41d4033d"; }];
    buildInputs = [ libiconv libintl ];
  };

  "fish" = fetch {
    pname       = "fish";
    version     = "3.1.2";
    srcs        = [{ filename = "fish-3.1.2-1-i686.pkg.tar.zst"; sha256 = "e3bcd364eb22ee270e0a87d3348babe3a80b5cc2db4e6a69b3ee7aa607c8142f"; }];
    buildInputs = [ bc gcc-libs gettext libiconv libpcre2_16 man-db ncurses ];
  };

  "flex" = fetch {
    pname       = "flex";
    version     = "2.6.4";
    srcs        = [{ filename = "flex-2.6.4-1-i686.pkg.tar.xz"; sha256 = "75bd4fa73628f74d769c8e8ef979b6258184e10a2aa7a0dd57f9f74630bd7cab"; }];
    buildInputs = [ m4 sh libiconv libintl ];
  };

  "flexc++" = fetch {
    pname       = "flexc++";
    version     = "2.07.09";
    srcs        = [{ filename = "flexc++-2.07.09-1-i686.pkg.tar.xz"; sha256 = "6c0fb4fd72944af0f28ba8285cce854474b5a675e54045d8a620f5f5a9f0f015"; }];
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
    version     = "5.1.0";
    srcs        = [{ filename = "gawk-5.1.0-1-i686.pkg.tar.xz"; sha256 = "ce8b66e4e7643017f46259fc55552a34d4a32637ae9a24b164acad0b61ce2100"; }];
    buildInputs = [ sh mpfr libintl libreadline ];
  };

  "gcc" = fetch {
    pname       = "gcc";
    version     = "9.3.0";
    srcs        = [{ filename = "gcc-9.3.0-1-i686.pkg.tar.xz"; sha256 = "17ef59d8707fb3083ba410998f1e83a5bd3e8f82e21f638b903b4a5f5161663b"; }];
    buildInputs = [ (assert gcc-libs.version=="9.3.0"; gcc-libs) binutils gmp isl mpc mpfr msys2-runtime-devel msys2-w32api-headers msys2-w32api-runtime windows-default-manifest ];
  };

  "gcc-fortran" = fetch {
    pname       = "gcc-fortran";
    version     = "9.3.0";
    srcs        = [{ filename = "gcc-fortran-9.3.0-1-i686.pkg.tar.xz"; sha256 = "a2a34eb0902388a3e11294337febcb4d276cece1f7f2c7a4c5f3901381830e5e"; }];
    buildInputs = [ (assert gcc.version=="9.3.0"; gcc) ];
  };

  "gcc-libs" = fetch {
    pname       = "gcc-libs";
    version     = "9.3.0";
    srcs        = [{ filename = "gcc-libs-9.3.0-1-i686.pkg.tar.xz"; sha256 = "54f03c84eb192c35298c5a7fc4ff258107207b7ba75f0fdf17e701ba6a174372"; }];
    buildInputs = [ msys2-runtime ];
  };

  "gdb" = fetch {
    pname       = "gdb";
    version     = "9.1";
    srcs        = [{ filename = "gdb-9.1-1-i686.pkg.tar.xz"; sha256 = "87c1c8c984eb4b4402777698a8c07fccd88045f2cf9c55c3d6b694e09c3e754b"; }];
    buildInputs = [ libiconv zlib expat python libexpat libreadline mpfr ];
  };

  "gdbm" = fetch {
    pname       = "gdbm";
    version     = "1.18.1";
    srcs        = [{ filename = "gdbm-1.18.1-3-i686.pkg.tar.zst"; sha256 = "adfc31914b13875c94d8bfa903e9f8610ed3e21ab49bf6c67d4ec4a8c79abfad"; }];
    buildInputs = [ (assert libgdbm.version=="1.18.1"; libgdbm) ];
  };

  "gengetopt" = fetch {
    pname       = "gengetopt";
    version     = "2.23";
    srcs        = [{ filename = "gengetopt-2.23-1-i686.pkg.tar.xz"; sha256 = "9edc41fc558f06635f021fe21c918cb1e0dc78e9bea3a730c916271885100f69"; }];
  };

  "getent" = fetch {
    pname       = "getent";
    version     = "2.18.90";
    srcs        = [{ filename = "getent-2.18.90-2-i686.pkg.tar.xz"; sha256 = "2eb4751e5269a5c88a41ca7a1856191a6d323c9743dfde50e1f15c63206af148"; }];
    buildInputs = [ libargp ];
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
    version     = "2.26.2";
    srcs        = [{ filename = "git-2.26.2-1-i686.pkg.tar.xz"; sha256 = "da6599919d416650bb327723215812b9e3bea17ada0c24df160087e20c90aa0a"; }];
    buildInputs = [ curl (assert stdenvNoCC.lib.versionAtLeast expat.version "2.0"; expat) libpcre2_8 vim openssh openssl perl-Error (assert stdenvNoCC.lib.versionAtLeast perl.version "5.14.0"; perl) perl-Authen-SASL perl-libwww perl-MIME-tools perl-Net-SMTP-SSL perl-TermReadKey ];
  };

  "git-crypt" = fetch {
    pname       = "git-crypt";
    version     = "0.6.0";
    srcs        = [{ filename = "git-crypt-0.6.0-1-i686.pkg.tar.xz"; sha256 = "96e54ca87f23e9eff7cfca5214785c753802af6a9ac896a7331a55efab6ecc5d"; }];
    buildInputs = [ gnupg git ];
  };

  "git-extras" = fetch {
    pname       = "git-extras";
    version     = "5.1.0";
    srcs        = [{ filename = "git-extras-5.1.0-1-any.pkg.tar.xz"; sha256 = "8b45c47d29baabfab9f2dbbe34f3a1ddf366ccba38a4f53a3dd14b07f020650a"; }];
    buildInputs = [ git ];
  };

  "git-flow" = fetch {
    pname       = "git-flow";
    version     = "1.12.3";
    srcs        = [{ filename = "git-flow-1.12.3-1-i686.pkg.tar.xz"; sha256 = "4d77d78425e1809969eab6f7c590808f44bb313285bb86a239724fb075243714"; }];
    buildInputs = [ git util-linux ];
  };

  "glib2" = fetch {
    pname       = "glib2";
    version     = "2.54.3";
    srcs        = [{ filename = "glib2-2.54.3-3-i686.pkg.tar.xz"; sha256 = "b1573fd616cc599a49076f101b01dfca14a971315b4dd7bbfc63053a506abb43"; }];
    buildInputs = [ libxslt libpcre libffi libiconv zlib ];
  };

  "glib2-devel" = fetch {
    pname       = "glib2-devel";
    version     = "2.54.3";
    srcs        = [{ filename = "glib2-devel-2.54.3-3-i686.pkg.tar.xz"; sha256 = "924bc04929735b2c3a235682b257afa4747d4eabcd8c18b087c0b7d3c22f9a85"; }];
    buildInputs = [ (assert glib2.version=="2.54.3"; glib2) pcre-devel libffi-devel libiconv-devel zlib-devel ];
  };

  "glib2-docs" = fetch {
    pname       = "glib2-docs";
    version     = "2.54.3";
    srcs        = [{ filename = "glib2-docs-2.54.3-3-i686.pkg.tar.xz"; sha256 = "04b89598976709f09c3b9d3e212a87c2928c1abebeeb2a3048a253b8fd1ff5e7"; }];
  };

  "global" = fetch {
    pname       = "global";
    version     = "6.6.4";
    srcs        = [{ filename = "global-6.6.4-1-i686.pkg.tar.xz"; sha256 = "e3ea932b794ff94eba3580464337d05f970d5877842ea1b4e1ee6a78d60ecaa5"; }];
    buildInputs = [ libltdl ];
  };

  "gmp" = fetch {
    pname       = "gmp";
    version     = "6.2.0";
    srcs        = [{ filename = "gmp-6.2.0-1-i686.pkg.tar.xz"; sha256 = "1ac55816be4464b8dfc9fcb4ef9536f7511c5383eebd33b9fef9ffc60efc8e43"; }];
    buildInputs = [  ];
  };

  "gmp-devel" = fetch {
    pname       = "gmp-devel";
    version     = "6.2.0";
    srcs        = [{ filename = "gmp-devel-6.2.0-1-i686.pkg.tar.xz"; sha256 = "9fd5f358c29db7449eea0aa5664bf9924bf5ea893fa429ffa17f25818e5ddac8"; }];
    buildInputs = [ (assert gmp.version=="6.2.0"; gmp) ];
  };

  "gnome-doc-utils" = fetch {
    pname       = "gnome-doc-utils";
    version     = "0.20.10";
    srcs        = [{ filename = "gnome-doc-utils-0.20.10-2-any.pkg.tar.zst"; sha256 = "92ea1236ad884e25cb27c05092e5c770a9b5c7678ead03e233dc702f37cda144"; }];
    buildInputs = [ libxslt python docbook-xml rarian ];
  };

  "gnu-netcat" = fetch {
    pname       = "gnu-netcat";
    version     = "0.7.1";
    srcs        = [{ filename = "gnu-netcat-0.7.1-1-i686.pkg.tar.xz"; sha256 = "f2386da17f68ce935326b575673fd2abbddc706ad82f07bb9fe9c026cdc4adc9"; }];
  };

  "gnupg" = fetch {
    pname       = "gnupg";
    version     = "2.2.23";
    srcs        = [{ filename = "gnupg-2.2.23-1-i686.pkg.tar.zst"; sha256 = "f8dae1773bb0129e6bbfe07c95720e3a7b432de05e40af4187aabf6cd20c58a2"; }];
    buildInputs = [ bzip2 libassuan libbz2 libcurl libgcrypt libgpg-error libgnutls libiconv libintl libksba libnpth libreadline libsqlite nettle pinentry zlib ];
  };

  "gnutls" = fetch {
    pname       = "gnutls";
    version     = "3.6.13";
    srcs        = [{ filename = "gnutls-3.6.13-1-i686.pkg.tar.xz"; sha256 = "dfe2d6a4befc7d580ad16ebe9b2ad9bbd8322096f86728e3b5b7d9d7194fc447"; }];
    buildInputs = [ (assert libgnutls.version=="3.6.13"; libgnutls) ];
  };

  "gperf" = fetch {
    pname       = "gperf";
    version     = "3.1";
    srcs        = [{ filename = "gperf-3.1-1-i686.pkg.tar.xz"; sha256 = "7a0be8741d63de5d5c1ee792bb2624ec1cbace95769e9405f720d75a498986f2"; }];
    buildInputs = [ gcc-libs info ];
  };

  "gradle" = fetch {
    pname       = "gradle";
    version     = "6.4.1";
    srcs        = [{ filename = "gradle-6.4.1-1-any.pkg.tar.zst"; sha256 = "770106440ae1241e1ee8bcacf9c1db391409ed07c3b7f4e156e65ce75b961227"; }];
  };

  "gradle-doc" = fetch {
    pname       = "gradle-doc";
    version     = "6.4.1";
    srcs        = [{ filename = "gradle-doc-6.4.1-1-any.pkg.tar.zst"; sha256 = "a2a30dbc8fc316c9ec8ac4e110b925543af4a7e556fc45b15398ef5fa8e57775"; }];
  };

  "grep" = fetch {
    pname       = "grep";
    version     = "3.0";
    srcs        = [{ filename = "grep-3.0-2-i686.pkg.tar.xz"; sha256 = "074f9fbe20e06ed1ea6aadb32c799abaa47f65f474582028e3ef1f6042b8d5ae"; }];
    buildInputs = [ libiconv libintl libpcre sh ];
  };

  "grml-zsh-config" = fetch {
    pname       = "grml-zsh-config";
    version     = "0.16.1";
    srcs        = [{ filename = "grml-zsh-config-0.16.1-1-any.pkg.tar.xz"; sha256 = "3b473ab0e5d4c7e91b8dc2e847b4c31b0cb34a69bc9f988f2c8cd90549b4df3d"; }];
    buildInputs = [ zsh coreutils inetutils grep sed procps ];
  };

  "groff" = fetch {
    pname       = "groff";
    version     = "1.22.4";
    srcs        = [{ filename = "groff-1.22.4-1-i686.pkg.tar.xz"; sha256 = "0591bf0a81a53edf40e5a94d2739e442c8be5dec382ef4a5f1e0b9d633160a5e"; }];
    buildInputs = [ perl gcc-libs ];
  };

  "gtk-doc" = fetch {
    pname       = "gtk-doc";
    version     = "1.32";
    srcs        = [{ filename = "gtk-doc-1.32-2-i686.pkg.tar.xz"; sha256 = "e491bd28756dcef0c4f26f904d3e9a972b751119436763d406fdbe085e123407"; }];
    buildInputs = [ docbook-xsl glib2 gnome-doc-utils libxml2-python python python-pygments vim yelp-tools ];
  };

  "guile" = fetch {
    pname       = "guile";
    version     = "2.2.7";
    srcs        = [{ filename = "guile-2.2.7-1-i686.pkg.tar.xz"; sha256 = "16922d36934ea20b72321e46207e5348c3a80f0f875d160f3a803a4558a1ab3a"; }];
    buildInputs = [ (assert libguile.version=="2.2.7"; libguile) info ];
  };

  "gyp-git" = fetch {
    pname       = "gyp-git";
    version     = "r2162.28b55023";
    srcs        = [{ filename = "gyp-git-r2162.28b55023-2-i686.pkg.tar.xz"; sha256 = "64e9d667eb8ee813a24e1bbe6953e7760d94cf8e48ebe87e325845d3db99c343"; }];
    buildInputs = [ python python-setuptools ];
  };

  "gzip" = fetch {
    pname       = "gzip";
    version     = "1.10";
    srcs        = [{ filename = "gzip-1.10-1-i686.pkg.tar.xz"; sha256 = "97e6cecffe2ecd606a839e0320ffae398872cf2ed26d0820629293818ae5e080"; }];
    buildInputs = [ msys2-runtime bash less ];
  };

  "heimdal" = fetch {
    pname       = "heimdal";
    version     = "7.7.0";
    srcs        = [{ filename = "heimdal-7.7.0-1-i686.pkg.tar.xz"; sha256 = "733423ad3383f8b8b1c959371579008278bf74377d26bce9855d8421752ce159"; }];
    buildInputs = [ heimdal-libs ];
  };

  "heimdal-devel" = fetch {
    pname       = "heimdal-devel";
    version     = "7.7.0";
    srcs        = [{ filename = "heimdal-devel-7.7.0-1-i686.pkg.tar.xz"; sha256 = "3b2b48b3581627e7a7aed67259597a52eaca03b69c44ec651c40797515a3f408"; }];
    buildInputs = [ heimdal-libs libcrypt-devel libedit-devel libdb-devel libsqlite-devel ];
  };

  "heimdal-libs" = fetch {
    pname       = "heimdal-libs";
    version     = "7.7.0";
    srcs        = [{ filename = "heimdal-libs-7.7.0-1-i686.pkg.tar.xz"; sha256 = "4b8232d7621fd49e6d73e6fa800d1e89186ab18ce35a5bc9879d75c70f27bca8"; }];
    buildInputs = [ libdb libcrypt libedit libsqlite libopenssl ];
  };

  "help2man" = fetch {
    pname       = "help2man";
    version     = "1.47.13";
    srcs        = [{ filename = "help2man-1.47.13-1-i686.pkg.tar.xz"; sha256 = "5bc34dc473429afef6fb4566273b913af71283de84c818f397df6bf93dea528d"; }];
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
    version     = "9.03.01";
    srcs        = [{ filename = "icmake-9.03.01-1-i686.pkg.tar.xz"; sha256 = "63f2f61b4709185ef38cd21bb9b36e849b1c32448adacabefec849d65121b5b6"; }];
  };

  "icon-naming-utils" = fetch {
    pname       = "icon-naming-utils";
    version     = "0.8.90";
    srcs        = [{ filename = "icon-naming-utils-0.8.90-1-i686.pkg.tar.xz"; sha256 = "ed3ee21eb08d9eb6066e1a4516912972b4e84a41c4fac53b1bbb2afdb3de00db"; }];
    buildInputs = [ perl-XML-Simple ];
  };

  "icu" = fetch {
    pname       = "icu";
    version     = "65.1";
    srcs        = [{ filename = "icu-65.1-1-i686.pkg.tar.xz"; sha256 = "5f2143cbde227e89d29c06f3d0e406dc718d76d99f74864181c1d211d794fca9"; }];
    buildInputs = [ gcc-libs ];
  };

  "icu-devel" = fetch {
    pname       = "icu-devel";
    version     = "65.1";
    srcs        = [{ filename = "icu-devel-65.1-1-i686.pkg.tar.xz"; sha256 = "6e1ded6b968c5592835f029cbb4dcd1f37d8d8a8df38ebc12f0ed3ef32622985"; }];
    buildInputs = [ (assert icu.version=="65.1"; icu) ];
  };

  "idutils" = fetch {
    pname       = "idutils";
    version     = "4.6";
    srcs        = [{ filename = "idutils-4.6-2-i686.pkg.tar.xz"; sha256 = "759674c9122f7474595e494ef4f59ae5c031299e04597b4531d26fe4761caf02"; }];
  };

  "inetutils" = fetch {
    pname       = "inetutils";
    version     = "1.9.4";
    srcs        = [{ filename = "inetutils-1.9.4-2-i686.pkg.tar.xz"; sha256 = "055d78cd158aa4b9720c0a3434275fe2a2aa18491294fa1aa5e62c41fcef990b"; }];
    buildInputs = [ gcc-libs libintl libcrypt libreadline ncurses tftp-hpa ];
  };

  "info" = fetch {
    pname       = "info";
    version     = "6.7";
    srcs        = [{ filename = "info-6.7-1-i686.pkg.tar.xz"; sha256 = "4afcfbc5ae72411ceaeb914d1d5e553be6f2bafa6dcab043dce7de07378642d2"; }];
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
    version     = "2.0.13";
    srcs        = [{ filename = "iperf-2.0.13-1-i686.pkg.tar.xz"; sha256 = "57f5b8a1a6dee88720656fd557279af0fb97abbcfdfb27063f3fd65ced1c62c7"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "iperf3" = fetch {
    pname       = "iperf3";
    version     = "3.7";
    srcs        = [{ filename = "iperf3-3.7-1-i686.pkg.tar.xz"; sha256 = "82f07de67b314a3334c6833729e7795295d21b7b20ffe896173869f8db907a02"; }];
    buildInputs = [ msys2-runtime gcc-libs openssl ];
  };

  "irssi" = fetch {
    pname       = "irssi";
    version     = "1.2.2";
    srcs        = [{ filename = "irssi-1.2.2-1-i686.pkg.tar.xz"; sha256 = "b476efe2f50a460f4903648edf5a7aa8ccea5def8c329b3eb70ef2cb0cafb39d"; }];
    buildInputs = [ openssl gettext perl ncurses glib2 ];
  };

  "isl" = fetch {
    pname       = "isl";
    version     = "0.22.1";
    srcs        = [{ filename = "isl-0.22.1-1-i686.pkg.tar.xz"; sha256 = "64d0c2d7c4fd6f0f8591c70376a9dadcd09b52c131d492bff9deb49710213204"; }];
    buildInputs = [ gmp ];
  };

  "isl-devel" = fetch {
    pname       = "isl-devel";
    version     = "0.22.1";
    srcs        = [{ filename = "isl-devel-0.22.1-1-i686.pkg.tar.xz"; sha256 = "6c047b41881d823e8a8cfbd82b968d863f8b9954790cb2f49cfc7fb4dd5cb463"; }];
    buildInputs = [ (assert isl.version=="0.22.1"; isl) gmp-devel ];
  };

  "itstool" = fetch {
    pname       = "itstool";
    version     = "2.0.6";
    srcs        = [{ filename = "itstool-2.0.6-2-i686.pkg.tar.xz"; sha256 = "330f426431401d71e3359876e7f7920673c3b05c123bcf081b165a1ff3f4b266"; }];
    buildInputs = [ python libxml2 libxml2-python ];
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

  "jsoncpp" = fetch {
    pname       = "jsoncpp";
    version     = "1.9.1";
    srcs        = [{ filename = "jsoncpp-1.9.1-2-any.pkg.tar.xz"; sha256 = "0ff9ca7777e0ed195cfd57e29b76feb8ef2ce04946ad5a2c24ad6ee17b87865e"; }];
    buildInputs = [ gcc-libs ];
  };

  "jsoncpp-devel" = fetch {
    pname       = "jsoncpp-devel";
    version     = "1.9.1";
    srcs        = [{ filename = "jsoncpp-devel-1.9.1-2-any.pkg.tar.xz"; sha256 = "7eb6908cd612763f910ad525a5b5b2e1fdb9be85aed4dd74426c8d91881d7611"; }];
    buildInputs = [ (assert jsoncpp.version=="1.9.1"; jsoncpp) ];
  };

  "lemon" = fetch {
    pname       = "lemon";
    version     = "3.31.1";
    srcs        = [{ filename = "lemon-3.31.1-1-i686.pkg.tar.xz"; sha256 = "8e011890d552e16fb786340e05c5aef86a7c46cf28e4d6d0252c6dbee0b1ae9a"; }];
    buildInputs = [ gcc-libs ];
  };

  "less" = fetch {
    pname       = "less";
    version     = "551";
    srcs        = [{ filename = "less-551-1-i686.pkg.tar.xz"; sha256 = "278315e1aa9c8773ea73c4efaba03ac744b0ae0a204ca601ef574da91886e997"; }];
    buildInputs = [ ncurses libpcre ];
  };

  "lftp" = fetch {
    pname       = "lftp";
    version     = "4.9.1";
    srcs        = [{ filename = "lftp-4.9.1-1-i686.pkg.tar.xz"; sha256 = "7751bbb657c58f3c4527ac898bfd99ccf335637fc7ba80140ef1c118e4d1825f"; }];
    buildInputs = [ gcc-libs ca-certificates expat gettext libexpat libgnutls libiconv libidn2 libintl libreadline libunistring openssh zlib ];
  };

  "libarchive" = fetch {
    pname       = "libarchive";
    version     = "3.4.2";
    srcs        = [{ filename = "libarchive-3.4.2-2-i686.pkg.tar.xz"; sha256 = "75c1e1ea56265152a9c5b04b51e0f1cbb85c2b0f6f5619dd16ecab7e175f67c7"; }];
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 libnettle libxml2 libzstd zlib ];
  };

  "libarchive-devel" = fetch {
    pname       = "libarchive-devel";
    version     = "3.4.2";
    srcs        = [{ filename = "libarchive-devel-3.4.2-2-i686.pkg.tar.xz"; sha256 = "dffa98b3df80801878a6f0080a424585eacaf812ce48086caf053d4b7d83b3f9"; }];
    buildInputs = [ (assert libarchive.version=="3.4.2"; libarchive) libbz2-devel libiconv-devel liblzma-devel liblz4-devel libnettle-devel libxml2-devel libzstd-devel zlib-devel ];
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
    version     = "2.5.3";
    srcs        = [{ filename = "libassuan-2.5.3-1-i686.pkg.tar.xz"; sha256 = "b5ba941756753d0d2e74a9c898b9a04f255cb30304e3f04cae1e6d993a2fadbc"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libassuan-devel" = fetch {
    pname       = "libassuan-devel";
    version     = "2.5.3";
    srcs        = [{ filename = "libassuan-devel-2.5.3-1-i686.pkg.tar.xz"; sha256 = "ebaec6e3a7f541ad5d9f73741f22d6bdc0f1e504aecd43312924f9aa6877bb13"; }];
    buildInputs = [ (assert libassuan.version=="2.5.3"; libassuan) libgpg-error-devel ];
  };

  "libatomic_ops" = fetch {
    pname       = "libatomic_ops";
    version     = "7.6.10";
    srcs        = [{ filename = "libatomic_ops-7.6.10-1-any.pkg.tar.xz"; sha256 = "b0fa2b64ac1dbf94858a096665475575eae53a5f7acb2674037d5d33e858d570"; }];
    buildInputs = [  ];
  };

  "libatomic_ops-devel" = fetch {
    pname       = "libatomic_ops-devel";
    version     = "7.6.10";
    srcs        = [{ filename = "libatomic_ops-devel-7.6.10-1-any.pkg.tar.xz"; sha256 = "0af491a59d8c78f76da4fb75c076c66e06fe1b5597a4dc89214cce213ccb2a3a"; }];
    buildInputs = [ (assert libatomic_ops.version=="7.6.10"; libatomic_ops) ];
  };

  "libbobcat" = fetch {
    pname       = "libbobcat";
    version     = "5.04.01";
    srcs        = [{ filename = "libbobcat-5.04.01-1-i686.pkg.tar.xz"; sha256 = "af5e98a3652529d28d1b98147a5edb8b4720031c7278e3e6b8e7ecde48b60c3d"; }];
    buildInputs = [ gcc-libs ];
  };

  "libbobcat-devel" = fetch {
    pname       = "libbobcat-devel";
    version     = "5.04.01";
    srcs        = [{ filename = "libbobcat-devel-5.04.01-1-i686.pkg.tar.xz"; sha256 = "4f2894134fa53f289eb55a84351a122e13ac8067963e607e2315978c3df03d13"; }];
    buildInputs = [ (assert libbobcat.version=="5.04.01"; libbobcat) ];
  };

  "libbz2" = fetch {
    pname       = "libbz2";
    version     = "1.0.8";
    srcs        = [{ filename = "libbz2-1.0.8-2-i686.pkg.tar.xz"; sha256 = "9dbf88aa9e75f2fe8f71f02ec0a1cc55175ca3a1c88e800efd48c6f8e2217ad5"; }];
    buildInputs = [ gcc-libs ];
  };

  "libbz2-devel" = fetch {
    pname       = "libbz2-devel";
    version     = "1.0.8";
    srcs        = [{ filename = "libbz2-devel-1.0.8-2-i686.pkg.tar.xz"; sha256 = "172cf3ade299e9f567fa439d532529e759c9e4bc822eccf3c0711bf8f04765e7"; }];
    buildInputs = [ (assert libbz2.version=="1.0.8"; libbz2) ];
  };

  "libcares" = fetch {
    pname       = "libcares";
    version     = "1.16.0";
    srcs        = [{ filename = "libcares-1.16.0-1-i686.pkg.tar.xz"; sha256 = "fd9e8fee89cc43acc4075ad9828dda5657459e92c5edc81517ed5bc54877a44a"; }];
    buildInputs = [ gcc-libs ];
  };

  "libcares-devel" = fetch {
    pname       = "libcares-devel";
    version     = "1.16.0";
    srcs        = [{ filename = "libcares-devel-1.16.0-1-i686.pkg.tar.xz"; sha256 = "b9af7cd6218f02a276378011cca63a96a688c26631df6fd4c31e5a4fa3b22a6c"; }];
    buildInputs = [ (assert libcares.version=="1.16.0"; libcares) ];
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
    version     = "7.70.0";
    srcs        = [{ filename = "libcurl-7.70.0-1-i686.pkg.tar.zst"; sha256 = "c1f78e081cc60c768eb3f3c5ac6860edad67eec3ed982158f113b49ac3be37e0"; }];
    buildInputs = [ brotli ca-certificates heimdal-libs libcrypt libidn2 libmetalink libunistring libnghttp2 libpsl libssh2 openssl zlib ];
  };

  "libcurl-devel" = fetch {
    pname       = "libcurl-devel";
    version     = "7.70.0";
    srcs        = [{ filename = "libcurl-devel-7.70.0-1-i686.pkg.tar.zst"; sha256 = "db47a1cb7649790f7e0c9ed68a9abc0e7c6f48cdbf327287a83300bb945ac6f4"; }];
    buildInputs = [ (assert libcurl.version=="7.70.0"; libcurl) brotli-devel heimdal-devel libcrypt-devel libidn2-devel libmetalink-devel libunistring-devel libnghttp2-devel libpsl-devel libssh2-devel openssl-devel zlib-devel ];
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
    version     = "20191231_3.1";
    srcs        = [{ filename = "libedit-20191231_3.1-1-i686.pkg.tar.xz"; sha256 = "cb6b63da137298f68d8c1e0f25cb6ec8a294e1ea55652ff0be6031840300a048"; }];
    buildInputs = [ msys2-runtime ncurses sh ];
  };

  "libedit-devel" = fetch {
    pname       = "libedit-devel";
    version     = "20191231_3.1";
    srcs        = [{ filename = "libedit-devel-20191231_3.1-1-i686.pkg.tar.xz"; sha256 = "74c926b56c7c09e014f1fa643a2048995a1830de66324eaf154c09a620e182e9"; }];
    buildInputs = [ (assert libedit.version=="20191231_3.1"; libedit) ncurses-devel ];
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
    version     = "2.1.11";
    srcs        = [{ filename = "libevent-2.1.11-2-i686.pkg.tar.xz"; sha256 = "91e21b06cbc59f19e1b36a0ddc26eab9b04e36d03e4b83096e3c913df1595201"; }];
    buildInputs = [ openssl ];
  };

  "libevent-devel" = fetch {
    pname       = "libevent-devel";
    version     = "2.1.11";
    srcs        = [{ filename = "libevent-devel-2.1.11-2-i686.pkg.tar.xz"; sha256 = "959d440ac88d59d145dd3683682912e6a0d35a4938c64c3793503dce2b7e3d4a"; }];
    buildInputs = [ (assert libevent.version=="2.1.11"; libevent) openssl-devel ];
  };

  "libexpat" = fetch {
    pname       = "libexpat";
    version     = "2.2.9";
    srcs        = [{ filename = "libexpat-2.2.9-1-i686.pkg.tar.xz"; sha256 = "14d9079c985a7fa68a6e42617f7e865a7e35974c9403119d1d0e66c9d2e901a8"; }];
    buildInputs = [ gcc-libs ];
  };

  "libexpat-devel" = fetch {
    pname       = "libexpat-devel";
    version     = "2.2.9";
    srcs        = [{ filename = "libexpat-devel-2.2.9-1-i686.pkg.tar.xz"; sha256 = "8734de7ae8358152d444ddd15cfd7a98c10e25f4c4cd7b7ccb554bd4bf4156b8"; }];
    buildInputs = [ (assert libexpat.version=="2.2.9"; libexpat) ];
  };

  "libffi" = fetch {
    pname       = "libffi";
    version     = "3.3";
    srcs        = [{ filename = "libffi-3.3-1-i686.pkg.tar.xz"; sha256 = "80c25a0b775ec8d0ec483b96dd1f60dd7d405e87bb7be6804dce7a8aa06add2c"; }];
    buildInputs = [  ];
  };

  "libffi-devel" = fetch {
    pname       = "libffi-devel";
    version     = "3.3";
    srcs        = [{ filename = "libffi-devel-3.3-1-i686.pkg.tar.xz"; sha256 = "c75bc1d5a29e60506725870b2334800faca79fb8ad473c32ef61d61f2767fc45"; }];
    buildInputs = [ (assert libffi.version=="3.3"; libffi) ];
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
    version     = "1.8.6";
    srcs        = [{ filename = "libgcrypt-1.8.6-1-i686.pkg.tar.zst"; sha256 = "d5b26516b7a74b1c5eb7b126d2fe6bdbb9ada130985f9d352d690d4fb7bf27a1"; }];
    buildInputs = [ libgpg-error ];
  };

  "libgcrypt-devel" = fetch {
    pname       = "libgcrypt-devel";
    version     = "1.8.6";
    srcs        = [{ filename = "libgcrypt-devel-1.8.6-1-i686.pkg.tar.zst"; sha256 = "9f4d83bd0d9ad1a0fbee7447eff07921f4662736847fe5c268e6d22bcc096b59"; }];
    buildInputs = [ (assert libgcrypt.version=="1.8.6"; libgcrypt) libgpg-error-devel ];
  };

  "libgdbm" = fetch {
    pname       = "libgdbm";
    version     = "1.18.1";
    srcs        = [{ filename = "libgdbm-1.18.1-3-i686.pkg.tar.zst"; sha256 = "3b770b6b91b3bd1ff1bf7928ec7ae640ebc8e72c1cd8ded347e8d4cb6c5dd864"; }];
    buildInputs = [ gcc-libs libreadline ];
  };

  "libgdbm-devel" = fetch {
    pname       = "libgdbm-devel";
    version     = "1.18.1";
    srcs        = [{ filename = "libgdbm-devel-1.18.1-3-i686.pkg.tar.zst"; sha256 = "a340bc4c46f65a96eff055f220ff2cf86a8c40ed0c78292e388fbf7a55928573"; }];
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
    version     = "3.6.13";
    srcs        = [{ filename = "libgnutls-3.6.13-1-i686.pkg.tar.xz"; sha256 = "f1cd540647b2d0c8051df7a3e392f6407ad6d0182676648fd270985798129e95"; }];
    buildInputs = [ gcc-libs libidn2 libiconv libintl gmp libnettle libp11-kit libtasn1 zlib ];
  };

  "libgnutls-devel" = fetch {
    pname       = "libgnutls-devel";
    version     = "3.6.13";
    srcs        = [{ filename = "libgnutls-devel-3.6.13-1-i686.pkg.tar.xz"; sha256 = "c2b1054447e01b271e6a75051486abb5ced1292cc1e3c7ad1d94b6d365e7177f"; }];
    buildInputs = [ (assert libgnutls.version=="3.6.13"; libgnutls) ];
  };

  "libgpg-error" = fetch {
    pname       = "libgpg-error";
    version     = "1.38";
    srcs        = [{ filename = "libgpg-error-1.38-1-i686.pkg.tar.zst"; sha256 = "5fc9b76474e79a16fb6ecb5b24283d3d032a533fdc4bd986f34582350c34667b"; }];
    buildInputs = [ sh libiconv libintl ];
  };

  "libgpg-error-devel" = fetch {
    pname       = "libgpg-error-devel";
    version     = "1.38";
    srcs        = [{ filename = "libgpg-error-devel-1.38-1-i686.pkg.tar.zst"; sha256 = "5dffcf9573020ce40ec3d82dece5c38f082639219df1919c32f7b9c7bcd24469"; }];
    buildInputs = [ libiconv-devel gettext-devel ];
  };

  "libgpgme" = fetch {
    pname       = "libgpgme";
    version     = "1.13.1";
    srcs        = [{ filename = "libgpgme-1.13.1-4-i686.pkg.tar.zst"; sha256 = "6d1651258cd5afde0ab1afffaf0e9396ef4d17b737c5d60d90fe26652acb55f5"; }];
    buildInputs = [ libassuan libgpg-error gnupg ];
  };

  "libgpgme-devel" = fetch {
    pname       = "libgpgme-devel";
    version     = "1.13.1";
    srcs        = [{ filename = "libgpgme-devel-1.13.1-4-i686.pkg.tar.zst"; sha256 = "c9961f4a8c52d4f8d2bade4c298ff8cf0deee4d610f4a918539e2baf0cc05bac"; }];
    buildInputs = [ (assert libgpgme.version=="1.13.1"; libgpgme) libassuan-devel libgpg-error-devel ];
  };

  "libgpgme-python" = fetch {
    pname       = "libgpgme-python";
    version     = "1.13.1";
    srcs        = [{ filename = "libgpgme-python-1.13.1-4-i686.pkg.tar.zst"; sha256 = "f0345731404a2a81dff739d3276f7a141837424fc15a3e861c8735679381f7d9"; }];
    buildInputs = [ (assert libgpgme.version=="1.13.1"; libgpgme) python ];
  };

  "libguile" = fetch {
    pname       = "libguile";
    version     = "2.2.7";
    srcs        = [{ filename = "libguile-2.2.7-1-i686.pkg.tar.xz"; sha256 = "92cbdebecbff392007d69933bd8b74c5df1cc5a0496e1e66921af314b18ed289"; }];
    buildInputs = [ gmp libltdl ncurses libunistring libgc libffi ];
  };

  "libguile-devel" = fetch {
    pname       = "libguile-devel";
    version     = "2.2.7";
    srcs        = [{ filename = "libguile-devel-2.2.7-1-i686.pkg.tar.xz"; sha256 = "d6ea44a96ad6ac6ea1313dfedee6b214f692472183ac33a7bda00f69a1fcce25"; }];
    buildInputs = [ (assert libguile.version=="2.2.7"; libguile) ];
  };

  "libhogweed" = fetch {
    pname       = "libhogweed";
    version     = "3.6";
    srcs        = [{ filename = "libhogweed-3.6-1-i686.pkg.tar.zst"; sha256 = "4087a3b1a44e4cde96be5f9364241b450a0f0721136e2c880c2186f9a57bd32c"; }];
    buildInputs = [ gmp ];
  };

  "libiconv" = fetch {
    pname       = "libiconv";
    version     = "1.16";
    srcs        = [{ filename = "libiconv-1.16-2-i686.pkg.tar.zst"; sha256 = "8474386392575a430b33ca0c342b9dbdb54a83ad30fe7bb30cdd8120202477eb"; }];
    buildInputs = [ gcc-libs libintl ];
  };

  "libiconv-devel" = fetch {
    pname       = "libiconv-devel";
    version     = "1.16";
    srcs        = [{ filename = "libiconv-devel-1.16-2-i686.pkg.tar.zst"; sha256 = "b7fb7a73e0e8de42ecc74f02180ea8d03e1ae63ac8147dc1fea91b066d4c536c"; }];
    buildInputs = [ (assert libiconv.version=="1.16"; libiconv) ];
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
    version     = "2.3.0";
    srcs        = [{ filename = "libidn2-2.3.0-1-i686.pkg.tar.xz"; sha256 = "e1b4c40a2c672fe8ac12ad2f7067cf0d538a9aa504af99e78890232f03ed2941"; }];
    buildInputs = [ info libunistring ];
  };

  "libidn2-devel" = fetch {
    pname       = "libidn2-devel";
    version     = "2.3.0";
    srcs        = [{ filename = "libidn2-devel-2.3.0-1-i686.pkg.tar.xz"; sha256 = "5d95729f48ce1b2660040677e6edff725a285fd8e286988711f9301090d4b42c"; }];
    buildInputs = [ (assert libidn2.version=="2.3.0"; libidn2) ];
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
    srcs        = [{ filename = "libltdl-2.4.6-9-i686.pkg.tar.xz"; sha256 = "712b3969d952a61465625d32bdf57e76fa3a3c63e146dac5cb27d4838eda541d"; }];
    buildInputs = [  ];
  };

  "liblz4" = fetch {
    pname       = "liblz4";
    version     = "1.9.2";
    srcs        = [{ filename = "liblz4-1.9.2-1-i686.pkg.tar.xz"; sha256 = "8390c984a886c5ddd8fa3aec552e17488bf12a191a1f7df51f8cb8aa30607581"; }];
    buildInputs = [ gcc-libs ];
  };

  "liblz4-devel" = fetch {
    pname       = "liblz4-devel";
    version     = "1.9.2";
    srcs        = [{ filename = "liblz4-devel-1.9.2-1-i686.pkg.tar.xz"; sha256 = "f17f42d91a93000f44191ba15925c4dad373648f6b6a2855157ee85c75be0960"; }];
    buildInputs = [ (assert liblz4.version=="1.9.2"; liblz4) ];
  };

  "liblzma" = fetch {
    pname       = "liblzma";
    version     = "5.2.5";
    srcs        = [{ filename = "liblzma-5.2.5-1-i686.pkg.tar.xz"; sha256 = "2d0686abf0c8d9e81f9a89914cec78ba5f42074ffed90b96d7a11daadae1386a"; }];
    buildInputs = [ sh libiconv gettext ];
  };

  "liblzma-devel" = fetch {
    pname       = "liblzma-devel";
    version     = "5.2.5";
    srcs        = [{ filename = "liblzma-devel-5.2.5-1-i686.pkg.tar.xz"; sha256 = "5aedbb18dbb390e6c58a8784ee3dba085fcc168e97385ee362c8837fdcce3d06"; }];
    buildInputs = [ (assert liblzma.version=="5.2.5"; liblzma) libiconv-devel gettext-devel ];
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
    version     = "0.31.1";
    srcs        = [{ filename = "libneon-0.31.1-1-i686.pkg.tar.zst"; sha256 = "c03a801b1ac6c2a1cc98ec4c2a90e7766871b9d137eb5baa760a2140af259fda"; }];
    buildInputs = [ libexpat openssl ca-certificates ];
  };

  "libneon-devel" = fetch {
    pname       = "libneon-devel";
    version     = "0.31.1";
    srcs        = [{ filename = "libneon-devel-0.31.1-1-i686.pkg.tar.zst"; sha256 = "38ff5fe5cd36411f15be72b619f3a60d9a2437d050bf03222c23ba07e88bc4d7"; }];
    buildInputs = [ (assert libneon.version=="0.31.1"; libneon) libexpat-devel openssl-devel ];
  };

  "libnettle" = fetch {
    pname       = "libnettle";
    version     = "3.6";
    srcs        = [{ filename = "libnettle-3.6-1-i686.pkg.tar.zst"; sha256 = "d13c12cc7dd2a505e9a54c6476fc2ce6ac4bf6565d2b7901a0193bcdc0eacf99"; }];
    buildInputs = [ libhogweed ];
  };

  "libnettle-devel" = fetch {
    pname       = "libnettle-devel";
    version     = "3.6";
    srcs        = [{ filename = "libnettle-devel-3.6-1-i686.pkg.tar.zst"; sha256 = "1a007f1a86b2c37e30f8ff171faf98f298aa63fda215c1e51196cb73a1a90478"; }];
    buildInputs = [ (assert libnettle.version=="3.6"; libnettle) (assert libhogweed.version=="3.6"; libhogweed) gmp-devel ];
  };

  "libnghttp2" = fetch {
    pname       = "libnghttp2";
    version     = "1.40.0";
    srcs        = [{ filename = "libnghttp2-1.40.0-1-i686.pkg.tar.xz"; sha256 = "485802db6c1cc2548e9514c78331b85a18cf58320be08fc0ac8f1abb1d87a297"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnghttp2-devel" = fetch {
    pname       = "libnghttp2-devel";
    version     = "1.40.0";
    srcs        = [{ filename = "libnghttp2-devel-1.40.0-1-i686.pkg.tar.xz"; sha256 = "28875276f44d56441feb3a2bfda97fb3414bbbe5dba92d93d956b2576136c5ef"; }];
    buildInputs = [ (assert libnghttp2.version=="1.40.0"; libnghttp2) jansson-devel libevent-devel openssl-devel libcares-devel ];
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
    version     = "1.1.1.g";
    srcs        = [{ filename = "libopenssl-1.1.1.g-1-i686.pkg.tar.xz"; sha256 = "a70cca0a3975190274ef3bba5bd49ca77de1e55aaa6001fe6812c5b43aa5e738"; }];
    buildInputs = [ zlib ];
  };

  "libp11-kit" = fetch {
    pname       = "libp11-kit";
    version     = "0.23.20";
    srcs        = [{ filename = "libp11-kit-0.23.20-2-i686.pkg.tar.xz"; sha256 = "56c7a8402cca21657c940e4d27ff8e8c7254f99933ca0760c7ab672f41338d61"; }];
    buildInputs = [ libffi libintl libtasn1 glib2 ];
  };

  "libp11-kit-devel" = fetch {
    pname       = "libp11-kit-devel";
    version     = "0.23.20";
    srcs        = [{ filename = "libp11-kit-devel-0.23.20-2-i686.pkg.tar.xz"; sha256 = "18988f82a210b01609126c6b0e31c920cca81fd5f5be704cbabe1aa733c9bff7"; }];
    buildInputs = [ (assert libp11-kit.version=="0.23.20"; libp11-kit) ];
  };

  "libpcre" = fetch {
    pname       = "libpcre";
    version     = "8.44";
    srcs        = [{ filename = "libpcre-8.44-1-i686.pkg.tar.xz"; sha256 = "029c254dfe636d3442d5938099ee2c19d6e7e9b3cd7e367c7efbe4f6153b413c"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre16" = fetch {
    pname       = "libpcre16";
    version     = "8.44";
    srcs        = [{ filename = "libpcre16-8.44-1-i686.pkg.tar.xz"; sha256 = "82f7ec29c8e88a47a4193ae9551a6e0ad3cfc3dc48fc79a9d256c5abaa76c6ff"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_16" = fetch {
    pname       = "libpcre2_16";
    version     = "10.34";
    srcs        = [{ filename = "libpcre2_16-10.34-1-i686.pkg.tar.xz"; sha256 = "8d8bd0c7ce60a11c65c6c994490100fa0aaf1a1e9ab9ebfaac7d238f439ae19e"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_32" = fetch {
    pname       = "libpcre2_32";
    version     = "10.34";
    srcs        = [{ filename = "libpcre2_32-10.34-1-i686.pkg.tar.xz"; sha256 = "d035b1c764504a86f350272d7f864f302bb204a0c2ec0e47d644854c10132188"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_8" = fetch {
    pname       = "libpcre2_8";
    version     = "10.34";
    srcs        = [{ filename = "libpcre2_8-10.34-1-i686.pkg.tar.xz"; sha256 = "d2eabcd7503bb2901d1d042b5153215f289adb7477184eaa564a600bfce61b35"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2posix" = fetch {
    pname       = "libpcre2posix";
    version     = "10.34";
    srcs        = [{ filename = "libpcre2posix-10.34-1-i686.pkg.tar.xz"; sha256 = "7f40c249237228bd3e58c90d2b8fc12f19ee4803e95496e20fac769bb56a5841"; }];
    buildInputs = [ (assert libpcre2_8.version=="10.34"; libpcre2_8) ];
  };

  "libpcre32" = fetch {
    pname       = "libpcre32";
    version     = "8.44";
    srcs        = [{ filename = "libpcre32-8.44-1-i686.pkg.tar.xz"; sha256 = "8aa408a01ad2d19791a4cd57b71cb8b9f50317d9dedd7797f74afd48897b52b4"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcrecpp" = fetch {
    pname       = "libpcrecpp";
    version     = "8.44";
    srcs        = [{ filename = "libpcrecpp-8.44-1-i686.pkg.tar.xz"; sha256 = "6c8c85ae1959da0325ce5deeb2ffc2e49e1932a72686f6ec80652d3142774ff5"; }];
    buildInputs = [ libpcre gcc-libs ];
  };

  "libpcreposix" = fetch {
    pname       = "libpcreposix";
    version     = "8.44";
    srcs        = [{ filename = "libpcreposix-8.44-1-i686.pkg.tar.xz"; sha256 = "3740aca58ff5388db4e07323c6ba9a1a52a55ee1c15ab5654c6ba1d45925411b"; }];
    buildInputs = [ libpcre ];
  };

  "libpipeline" = fetch {
    pname       = "libpipeline";
    version     = "1.5.2";
    srcs        = [{ filename = "libpipeline-1.5.2-1-i686.pkg.tar.xz"; sha256 = "49d08d007301875515c1d0481d99125f5d1500abe6d7b8b7ce8701c4d33d9a9f"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpipeline-devel" = fetch {
    pname       = "libpipeline-devel";
    version     = "1.5.2";
    srcs        = [{ filename = "libpipeline-devel-1.5.2-1-i686.pkg.tar.xz"; sha256 = "ab6b238e3b92a2784b82c816e9a4311dcde5b0411c82360332957c9ec1232c28"; }];
    buildInputs = [ (assert libpipeline.version=="1.5.2"; libpipeline) ];
  };

  "libpsl" = fetch {
    pname       = "libpsl";
    version     = "0.21.0";
    srcs        = [{ filename = "libpsl-0.21.0-1-i686.pkg.tar.xz"; sha256 = "f723fa050a07899f4f120f1ed8bbba5bc52bee4371027846b983deaa15625480"; }];
    buildInputs = [ libxslt libidn2 libunistring ];
  };

  "libpsl-devel" = fetch {
    pname       = "libpsl-devel";
    version     = "0.21.0";
    srcs        = [{ filename = "libpsl-devel-0.21.0-1-i686.pkg.tar.xz"; sha256 = "abf9549b12502213c60b9cc4085ea438c3688d920bb6818942e903d85d7ef48b"; }];
    buildInputs = [ (assert libpsl.version=="0.21.0"; libpsl) libxslt libidn2-devel libunistring ];
  };

  "libqrencode" = fetch {
    pname       = "libqrencode";
    version     = "4.0.2";
    srcs        = [{ filename = "libqrencode-4.0.2-1-i686.pkg.tar.xz"; sha256 = "3eb6555877dd16282226918c5cbd670bdda37c457a8ef865b262cd1a5fe14805"; }];
  };

  "libqrencode-devel" = fetch {
    pname       = "libqrencode-devel";
    version     = "4.0.2";
    srcs        = [{ filename = "libqrencode-devel-4.0.2-1-i686.pkg.tar.xz"; sha256 = "13f7c558527466be73c2fb59ea70b9b3349ab78df838fec20a0fc2e3b606c724"; }];
    buildInputs = [ (assert libqrencode.version=="4.0.2"; libqrencode) ];
  };

  "libreadline" = fetch {
    pname       = "libreadline";
    version     = "8.0.004";
    srcs        = [{ filename = "libreadline-8.0.004-1-i686.pkg.tar.xz"; sha256 = "9a30f5155265b3fb2a79676391161819829100ca8ece0033e682dbc1109f40ce"; }];
    buildInputs = [ ncurses ];
  };

  "libreadline-devel" = fetch {
    pname       = "libreadline-devel";
    version     = "8.0.004";
    srcs        = [{ filename = "libreadline-devel-8.0.004-1-i686.pkg.tar.xz"; sha256 = "b8c34e700ac69026c8287b4fae071161af595b2a04ad4a2f321d302f03dfff93"; }];
    buildInputs = [ (assert libreadline.version=="8.0.004"; libreadline) ncurses-devel ];
  };

  "librhash" = fetch {
    pname       = "librhash";
    version     = "1.3.9";
    srcs        = [{ filename = "librhash-1.3.9-1-i686.pkg.tar.xz"; sha256 = "7c27d102e30ee27156e00377defcb50e90b56a26a060786f40c89b3bfd0ddeae"; }];
    buildInputs = [ libopenssl gcc-libs ];
  };

  "librhash-devel" = fetch {
    pname       = "librhash-devel";
    version     = "1.3.9";
    srcs        = [{ filename = "librhash-devel-1.3.9-1-i686.pkg.tar.xz"; sha256 = "0eb9943a6bb5c70c924805f792fc7f3846ecc2e7a803abafa9da2fe108b56d06"; }];
    buildInputs = [ (assert librhash.version=="1.3.9"; librhash) ];
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
    srcs        = [{ filename = "libserf-1.3.9-5-i686.pkg.tar.xz"; sha256 = "32d920b09f17748c9f30f6fbab81c511afc8fcba3677968db06774859a0e904f"; }];
    buildInputs = [ apr-util libopenssl zlib ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "libserf-devel" = fetch {
    pname       = "libserf-devel";
    version     = "1.3.9";
    srcs        = [{ filename = "libserf-devel-1.3.9-5-i686.pkg.tar.xz"; sha256 = "4b3b3436f9d1df1747dd47c56bcbe3ce9d5265363f903dd77786104b08657eee"; }];
    buildInputs = [ (assert libserf.version=="1.3.9"; libserf) apr-util-devel openssl-devel zlib-devel ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "libsqlite" = fetch {
    pname       = "libsqlite";
    version     = "3.30.0";
    srcs        = [{ filename = "libsqlite-3.30.0-1-i686.pkg.tar.xz"; sha256 = "458dc622f04185a02bccdab4bceee7be9b8f4925841c87f61c84d05180f5ea70"; }];
    buildInputs = [  ];
  };

  "libsqlite-devel" = fetch {
    pname       = "libsqlite-devel";
    version     = "3.30.0";
    srcs        = [{ filename = "libsqlite-devel-3.30.0-1-i686.pkg.tar.xz"; sha256 = "61319be66a2382ea6f775ade8fc335975b532c7c2244c0df80a7a0ee52abd255"; }];
    buildInputs = [ (assert libsqlite.version=="3.30.0"; libsqlite) ];
  };

  "libssh2" = fetch {
    pname       = "libssh2";
    version     = "1.9.0";
    srcs        = [{ filename = "libssh2-1.9.0-1-i686.pkg.tar.xz"; sha256 = "4c0decc6c369c3de72d1a9af6b86b8efe9a46549d2da4e644171af522b86e352"; }];
    buildInputs = [ ca-certificates openssl zlib ];
  };

  "libssh2-devel" = fetch {
    pname       = "libssh2-devel";
    version     = "1.9.0";
    srcs        = [{ filename = "libssh2-devel-1.9.0-1-i686.pkg.tar.xz"; sha256 = "43a5f7b1082767b251dfd1c4cb17b34794f859b89330fec68392a33f2a00f772"; }];
    buildInputs = [ (assert libssh2.version=="1.9.0"; libssh2) openssl-devel zlib-devel ];
  };

  "libtasn1" = fetch {
    pname       = "libtasn1";
    version     = "4.16.0";
    srcs        = [{ filename = "libtasn1-4.16.0-1-i686.pkg.tar.xz"; sha256 = "8735aa6525e47829d35019e151cc8f6db8b51f4444d35d41280203a93bfa3630"; }];
    buildInputs = [ info ];
  };

  "libtasn1-devel" = fetch {
    pname       = "libtasn1-devel";
    version     = "4.16.0";
    srcs        = [{ filename = "libtasn1-devel-4.16.0-1-i686.pkg.tar.xz"; sha256 = "d75a28e9b7ccfa96965916cd858ecd8ee75b3b41ce7a426af691c9fdd6a7e0e0"; }];
    buildInputs = [ (assert libtasn1.version=="4.16.0"; libtasn1) ];
  };

  "libtirpc" = fetch {
    pname       = "libtirpc";
    version     = "1.2.6";
    srcs        = [{ filename = "libtirpc-1.2.6-1-i686.pkg.tar.xz"; sha256 = "8a6d405396f9fbf9dc34a00a54efe4a62d99b099296ea59a0714c5767b3e9946"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "libtirpc-devel" = fetch {
    pname       = "libtirpc-devel";
    version     = "1.2.6";
    srcs        = [{ filename = "libtirpc-devel-1.2.6-1-i686.pkg.tar.xz"; sha256 = "8ffad7d5092645adeac6ac5e3685bcc68716b6bec90f297dda8a84f901662ef2"; }];
    buildInputs = [ (assert libtirpc.version=="1.2.6"; libtirpc) ];
  };

  "libtool" = fetch {
    pname       = "libtool";
    version     = "2.4.6";
    srcs        = [{ filename = "libtool-2.4.6-9-i686.pkg.tar.xz"; sha256 = "fc73f18023c4ab62094af3dee8eb3540737848ff92c96c4e0a35904593a74332"; }];
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
    version     = "5.9.2";
    srcs        = [{ filename = "libunrar-5.9.2-1-i686.pkg.tar.xz"; sha256 = "8c3969db49a3325d3d248c1170dc6c980532d66572e82c57c636d17f0abb03be"; }];
    buildInputs = [ gcc-libs ];
  };

  "libunrar-devel" = fetch {
    pname       = "libunrar-devel";
    version     = "5.9.2";
    srcs        = [{ filename = "libunrar-devel-5.9.2-1-i686.pkg.tar.xz"; sha256 = "73cec73f6115c7e7669a90b963d9c201ecf7aa98aa3622fabe1551df9799e592"; }];
    buildInputs = [ libunrar ];
  };

  "libutil-linux" = fetch {
    pname       = "libutil-linux";
    version     = "2.35.1";
    srcs        = [{ filename = "libutil-linux-2.35.1-1-i686.pkg.tar.xz"; sha256 = "03d613a45e81f70683a57cffc5adbbb8743597e2330317b5ed661fdb183d2a67"; }];
    buildInputs = [ gcc-libs libintl msys2-runtime ];
  };

  "libutil-linux-devel" = fetch {
    pname       = "libutil-linux-devel";
    version     = "2.35.1";
    srcs        = [{ filename = "libutil-linux-devel-2.35.1-1-i686.pkg.tar.xz"; sha256 = "6e4cf3009a92f7b59f8f93d15f4831821c0acaf3de9a3d0311223ce7d4100758"; }];
    buildInputs = [ libutil-linux ];
  };

  "libuv" = fetch {
    pname       = "libuv";
    version     = "1.37.0";
    srcs        = [{ filename = "libuv-1.37.0-1-i686.pkg.tar.xz"; sha256 = "4e705681bf263ffe829617862c5dc4a32e1f29ceca131b24fdd2d60aed10f09b"; }];
    buildInputs = [ gcc-libs ];
  };

  "libuv-devel" = fetch {
    pname       = "libuv-devel";
    version     = "1.37.0";
    srcs        = [{ filename = "libuv-devel-1.37.0-1-i686.pkg.tar.xz"; sha256 = "c804359137936c6f4a55af98a66239f99a32a5a0f33eb82bf6786e4e417623a1"; }];
    buildInputs = [ (assert libuv.version=="1.37.0"; libuv) ];
  };

  "libxml2" = fetch {
    pname       = "libxml2";
    version     = "2.9.10";
    srcs        = [{ filename = "libxml2-2.9.10-4-i686.pkg.tar.xz"; sha256 = "5d011819f87b7c531e1612114a04c13e312dabf188b8fa2e2ef064953c72a247"; }];
    buildInputs = [ coreutils (assert stdenvNoCC.lib.versionAtLeast icu.version "59.1"; icu) liblzma libreadline ncurses zlib ];
  };

  "libxml2-devel" = fetch {
    pname       = "libxml2-devel";
    version     = "2.9.10";
    srcs        = [{ filename = "libxml2-devel-2.9.10-4-i686.pkg.tar.xz"; sha256 = "c0388dbf0b932662b4fae144d33169e6be85202d7d3a321111927a316924465c"; }];
    buildInputs = [ (assert libxml2.version=="2.9.10"; libxml2) (assert stdenvNoCC.lib.versionAtLeast icu-devel.version "59.1"; icu-devel) libreadline-devel ncurses-devel liblzma-devel zlib-devel ];
  };

  "libxml2-python" = fetch {
    pname       = "libxml2-python";
    version     = "2.9.10";
    srcs        = [{ filename = "libxml2-python-2.9.10-4-i686.pkg.tar.xz"; sha256 = "cde337998b5fa1b08e3f2b0ca6f17eccd0d9d92a970706bfbcc357738d54aec3"; }];
    buildInputs = [ libxml2 ];
  };

  "libxslt" = fetch {
    pname       = "libxslt";
    version     = "1.1.34";
    srcs        = [{ filename = "libxslt-1.1.34-3-i686.pkg.tar.xz"; sha256 = "b0402fb078e8bba72a368b79c5dec240dcf3dc6fb9d2adf980eb2fe48a9e59af"; }];
    buildInputs = [ libxml2 libgcrypt ];
  };

  "libxslt-devel" = fetch {
    pname       = "libxslt-devel";
    version     = "1.1.34";
    srcs        = [{ filename = "libxslt-devel-1.1.34-3-i686.pkg.tar.xz"; sha256 = "316be1368c4755e3becfbe637bcf6b2eae182ecd51626a689bace272c09dfde4"; }];
    buildInputs = [ (assert libxslt.version=="1.1.34"; libxslt) libxml2-devel libgcrypt-devel ];
  };

  "libyaml" = fetch {
    pname       = "libyaml";
    version     = "0.2.4";
    srcs        = [{ filename = "libyaml-0.2.4-1-i686.pkg.tar.xz"; sha256 = "37bc03328b561512ebf86d25e26701ccdb70f0bdbf8c8dfd7eda4a70004566a6"; }];
    buildInputs = [  ];
  };

  "libyaml-devel" = fetch {
    pname       = "libyaml-devel";
    version     = "0.2.4";
    srcs        = [{ filename = "libyaml-devel-0.2.4-1-i686.pkg.tar.xz"; sha256 = "0b97c9e08474013e912743f05582567125249afde2f18ac4d7a07ad2b8eadaa4"; }];
    buildInputs = [ (assert libyaml.version=="0.2.4"; libyaml) ];
  };

  "libzstd" = fetch {
    pname       = "libzstd";
    version     = "1.4.4";
    srcs        = [{ filename = "libzstd-1.4.4-2-i686.pkg.tar.xz"; sha256 = "62cf68fd531dfc6f9a44ba77de0081f4a852071da8fd6222f143b08faf4799e4"; }];
    buildInputs = [ gcc-libs ];
  };

  "libzstd-devel" = fetch {
    pname       = "libzstd-devel";
    version     = "1.4.4";
    srcs        = [{ filename = "libzstd-devel-1.4.4-2-i686.pkg.tar.xz"; sha256 = "317f08cc83fe97414218cc104dfd88c6a1085f35c47a2d26bc0f333228776473"; }];
    buildInputs = [ (assert libzstd.version=="1.4.4"; libzstd) ];
  };

  "lndir" = fetch {
    pname       = "lndir";
    version     = "1.0.3";
    srcs        = [{ filename = "lndir-1.0.3-1-i686.pkg.tar.xz"; sha256 = "16b61c8365b09c91965fbd28507e4ca4d9c18fcc762c0a51d79ac558081b1682"; }];
  };

  "luit" = fetch {
    pname       = "luit";
    version     = "20190106";
    srcs        = [{ filename = "luit-20190106-1-i686.pkg.tar.xz"; sha256 = "b9c6de56a5db43642a7036051adec6fe020aae6cc339ed6f831fb1c123d45d96"; }];
    buildInputs = [ gcc-libs libiconv zlib ];
  };

  "lz4" = fetch {
    pname       = "lz4";
    version     = "1.9.2";
    srcs        = [{ filename = "lz4-1.9.2-1-i686.pkg.tar.xz"; sha256 = "a67016e55166c1b64774dfbcc9ada04fab877f7da1f9ee8a1df3f742de2e6b53"; }];
    buildInputs = [ gcc-libs (assert lz4.version=="1.9.2"; lz4) ];
  };

  "lzip" = fetch {
    pname       = "lzip";
    version     = "1.21";
    srcs        = [{ filename = "lzip-1.21-1-i686.pkg.tar.xz"; sha256 = "9b9742688fdbb9782ffe40df2330e040b378d8c39c4e80b51e773cb4f097330a"; }];
    buildInputs = [ gcc-libs ];
  };

  "lzop" = fetch {
    pname       = "lzop";
    version     = "1.04";
    srcs        = [{ filename = "lzop-1.04-1-i686.pkg.tar.xz"; sha256 = "9aef532b01e2cd91bb3116491ff026db423a501ec73f09dff3b7aa2df1d8d6e2"; }];
    buildInputs = [ liblzo2 ];
  };

  "m4" = fetch {
    pname       = "m4";
    version     = "1.4.18";
    srcs        = [{ filename = "m4-1.4.18-2-i686.pkg.tar.xz"; sha256 = "92cd3f1dbea2053a22cc971c080e9431d8e1c3d54804e4cf7a5caa41090ac0db"; }];
    buildInputs = [ bash gcc-libs msys2-runtime ];
  };

  "make" = fetch {
    pname       = "make";
    version     = "4.3";
    srcs        = [{ filename = "make-4.3-1-i686.pkg.tar.xz"; sha256 = "ece650290fffe4cea911fb506c63928bfadf7d770a9db0b7e3d3938e09d257d7"; }];
    buildInputs = [ msys2-runtime libintl sh ];
  };

  "man-db" = fetch {
    pname       = "man-db";
    version     = "2.9.1";
    srcs        = [{ filename = "man-db-2.9.1-1-i686.pkg.tar.xz"; sha256 = "84186f265e3be1278da0a0d74fb85ed7cfdae281817fe25ea96dca7327c861fc"; }];
    buildInputs = [ bash gdbm zlib groff libpipeline less ];
  };

  "man-pages-posix" = fetch {
    pname       = "man-pages-posix";
    version     = "2013_a";
    srcs        = [{ filename = "man-pages-posix-2013_a-1-any.pkg.tar.xz"; sha256 = "3ee3c731d02d4771ee0d63cbc308fac506bc6a9568678fa8644e07372b07c36e"; }];
  };

  "man2html" = fetch {
    pname       = "man2html";
    version     = "3.0.1";
    srcs        = [{ filename = "man2html-3.0.1-1-any.pkg.tar.xz"; sha256 = "6c318f2f3222a78532d08df3a9605b1675e14ebf17958399d46214d58805b6ac"; }];
    buildInputs = [ man-db perl ];
  };

  "markdown" = fetch {
    pname       = "markdown";
    version     = "1.0.1";
    srcs        = [{ filename = "markdown-1.0.1-1-i686.pkg.tar.xz"; sha256 = "3223ec3ed8880c31191b8f62ba69457629191368abdbb2e9437be1cac49b6eb4"; }];
  };

  "mc" = fetch {
    pname       = "mc";
    version     = "4.8.24";
    srcs        = [{ filename = "mc-4.8.24-1-i686.pkg.tar.xz"; sha256 = "71ff87ab805d0f98aa984aed0d08eaa4f03368e7621a7750e217de59d7269ba0"; }];
    buildInputs = [ glib2 libssh2 ];
  };

  "mercurial" = fetch {
    pname       = "mercurial";
    version     = "5.4";
    srcs        = [{ filename = "mercurial-5.4-1-i686.pkg.tar.zst"; sha256 = "1fcb6548757fee27af21acc5881a03edc860922999e106dd0d51a95efe3e37d2"; }];
    buildInputs = [ python3 ];
  };

  "meson" = fetch {
    pname       = "meson";
    version     = "0.55.1";
    srcs        = [{ filename = "meson-0.55.1-1-any.pkg.tar.zst"; sha256 = "c8b07dc2bae744a5ce03c896567f105ed0851ddeecfc7ea7d55d55f21b621127"; }];
    buildInputs = [ python python-setuptools ninja ];
  };

  "mingw-w64-cross-binutils" = fetch {
    pname       = "mingw-w64-cross-binutils";
    version     = "2.34";
    srcs        = [{ filename = "mingw-w64-cross-binutils-2.34-1-i686.pkg.tar.xz"; sha256 = "3d5f1435cc4c44799e312c54f860f21c8c56310618a3a3bfc7713090ca0c2e58"; }];
    buildInputs = [ libiconv zlib ];
  };

  "mingw-w64-cross-crt-git" = fetch {
    pname       = "mingw-w64-cross-crt-git";
    version     = "8.0.0.5687.c8e562e9";
    srcs        = [{ filename = "mingw-w64-cross-crt-git-8.0.0.5687.c8e562e9-1-i686.pkg.tar.xz"; sha256 = "63613e1ef9bdeb9e0522506438a42f23c3b7b5b5eb606aa34fbac86b666a44af"; }];
    buildInputs = [ mingw-w64-cross-headers-git ];
  };

  "mingw-w64-cross-gcc" = fetch {
    pname       = "mingw-w64-cross-gcc";
    version     = "9.3.0";
    srcs        = [{ filename = "mingw-w64-cross-gcc-9.3.0-1-i686.pkg.tar.xz"; sha256 = "c5fcae333eba97b3474f37156c804403b624df37adca2355e0203872ec4660c1"; }];
    buildInputs = [ zlib mpc isl mingw-w64-cross-binutils mingw-w64-cross-crt-git mingw-w64-cross-headers-git mingw-w64-cross-winpthreads-git mingw-w64-cross-windows-default-manifest ];
  };

  "mingw-w64-cross-headers-git" = fetch {
    pname       = "mingw-w64-cross-headers-git";
    version     = "8.0.0.5687.c8e562e9";
    srcs        = [{ filename = "mingw-w64-cross-headers-git-8.0.0.5687.c8e562e9-1-i686.pkg.tar.xz"; sha256 = "c862ee5214acfe47326dce6a4e3e3b9fd9bc2abd7b9cbbd608af8fc86a7d702b"; }];
    buildInputs = [  ];
  };

  "mingw-w64-cross-tools-git" = fetch {
    pname       = "mingw-w64-cross-tools-git";
    version     = "8.0.0.5687.c8e562e9";
    srcs        = [{ filename = "mingw-w64-cross-tools-git-8.0.0.5687.c8e562e9-1-i686.pkg.tar.xz"; sha256 = "5f1d301be4ae4453f7c8b6dcf81b51e2f71cfd18323cb60b954047efd5c3325d"; }];
  };

  "mingw-w64-cross-windows-default-manifest" = fetch {
    pname       = "mingw-w64-cross-windows-default-manifest";
    version     = "6.4";
    srcs        = [{ filename = "mingw-w64-cross-windows-default-manifest-6.4-2-i686.pkg.tar.xz"; sha256 = "eeaaba8c5159416bf04e3bca2d256a3c1d80db138260feb8496a186b93d65786"; }];
    buildInputs = [  ];
  };

  "mingw-w64-cross-winpthreads-git" = fetch {
    pname       = "mingw-w64-cross-winpthreads-git";
    version     = "8.0.0.5688.b44bc315";
    srcs        = [{ filename = "mingw-w64-cross-winpthreads-git-8.0.0.5688.b44bc315-1-i686.pkg.tar.xz"; sha256 = "7551c7145bff17fc4cd5e57b201ae9cb08e914ba84daf6c0fa4896414472d960"; }];
    buildInputs = [ mingw-w64-cross-crt-git ];
  };

  "mingw-w64-cross-winstorecompat-git" = fetch {
    pname       = "mingw-w64-cross-winstorecompat-git";
    version     = "8.0.0.5687.c8e562e9";
    srcs        = [{ filename = "mingw-w64-cross-winstorecompat-git-8.0.0.5687.c8e562e9-1-i686.pkg.tar.xz"; sha256 = "77a3775a69bc2da8e3c2b20d27c48e5a79963374c2d517f9a900637bc7e369b7"; }];
    buildInputs = [ mingw-w64-cross-crt-git ];
  };

  "mingw-w64-cross-zlib" = fetch {
    pname       = "mingw-w64-cross-zlib";
    version     = "1.2.11";
    srcs        = [{ filename = "mingw-w64-cross-zlib-1.2.11-1-i686.pkg.tar.xz"; sha256 = "b3acae5cd274f47b8196ca33b4ce593e5728f3806b2b97a2e2687a3ed851f319"; }];
  };

  "mintty" = fetch {
    pname       = "mintty";
    version     = "1~3.4.0";
    srcs        = [{ filename = "mintty-1~3.4.0-1-i686.pkg.tar.xz"; sha256 = "001002a40ad7669fdb17cf84e053c68eca566ac7f6c0522d86da5bffe0683b15"; }];
    buildInputs = [ sh ];
  };

  "mksh" = fetch {
    pname       = "mksh";
    version     = "57";
    srcs        = [{ filename = "mksh-57-1-i686.pkg.tar.xz"; sha256 = "b3dd2f36f7dbb1d90c61cda309b57737aee944110885a8a24ec45f1b32fa414d"; }];
    buildInputs = [ gcc-libs ];
  };

  "moreutils" = fetch {
    pname       = "moreutils";
    version     = "0.63";
    srcs        = [{ filename = "moreutils-0.63-1-i686.pkg.tar.xz"; sha256 = "be89330823110eda33fbae72be603fd276841ea343de58d488fda171c4e11f5c"; }];
  };

  "mosh" = fetch {
    pname       = "mosh";
    version     = "1.3.2";
    srcs        = [{ filename = "mosh-1.3.2-6-i686.pkg.tar.xz"; sha256 = "9c44c1d08d2f946d0d0431191ff23f08fa049758759fe1a457aa6055cfd922f9"; }];
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
    version     = "4.0.2";
    srcs        = [{ filename = "mpfr-4.0.2-1-i686.pkg.tar.xz"; sha256 = "3b48a2fc22f9244268b8b8dd8c69ca7636ab5f8921c5fea7326edb3dc6faa5eb"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gmp.version "5.0"; gmp) ];
  };

  "mpfr-devel" = fetch {
    pname       = "mpfr-devel";
    version     = "4.0.2";
    srcs        = [{ filename = "mpfr-devel-4.0.2-1-i686.pkg.tar.xz"; sha256 = "342b09be630de299e806fadb808ccb1fd36c5815cd2b8db4225a60e7b6d950ec"; }];
    buildInputs = [ (assert mpfr.version=="4.0.2"; mpfr) gmp-devel ];
  };

  "msys2-keyring" = fetch {
    pname       = "msys2-keyring";
    version     = "r21.b39fb11";
    srcs        = [{ filename = "msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz"; sha256 = "f1cc152902fd6018868b64d015cab9bf547ff9789d8bd7c0d798fb2b22367b2b"; }];
  };

  "msys2-launcher-git" = fetch {
    pname       = "msys2-launcher-git";
    version     = "0.3.32.56c2ba7";
    srcs        = [{ filename = "msys2-launcher-git-0.3.32.56c2ba7-2-i686.pkg.tar.xz"; sha256 = "87c4c2339030dc81e3e87a278cf39f13b07ca4c667a2e1a4e3a3f737744b3e01"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mintty.version "1~2.2.1"; mintty) ];
  };

  "msys2-runtime" = fetch {
    pname       = "msys2-runtime";
    version     = "3.1.7";
    srcs        = [{ filename = "msys2-runtime-3.1.7-2-i686.pkg.tar.xz"; sha256 = "f0e3fbf4e5332e06b624559b47b19d12c094acdb8f201837ccf3014f27f186e4"; }];
    buildInputs = [  ];
  };

  "msys2-runtime-devel" = fetch {
    pname       = "msys2-runtime-devel";
    version     = "3.1.7";
    srcs        = [{ filename = "msys2-runtime-devel-3.1.7-2-i686.pkg.tar.xz"; sha256 = "c9872e9531261af8d82e0ff7143c73d0381453b0d5fe3fc163aa6652151de085"; }];
    buildInputs = [ (assert msys2-runtime.version=="3.1.7"; msys2-runtime) ];
  };

  "msys2-w32api-headers" = fetch {
    pname       = "msys2-w32api-headers";
    version     = "8.0.0.5683.629fd2b1";
    srcs        = [{ filename = "msys2-w32api-headers-8.0.0.5683.629fd2b1-1-i686.pkg.tar.xz"; sha256 = "df10d4f55efc0958f31cd0708a575dfe07e0fa8203e01acc1961102e2dcd82f6"; }];
    buildInputs = [  ];
  };

  "msys2-w32api-runtime" = fetch {
    pname       = "msys2-w32api-runtime";
    version     = "8.0.0.5683.629fd2b1";
    srcs        = [{ filename = "msys2-w32api-runtime-8.0.0.5683.629fd2b1-1-i686.pkg.tar.xz"; sha256 = "53105d540e72911c7fc935a0c3fd5695051859eca5a7078df70f34a017cb9eb6"; }];
    buildInputs = [ msys2-w32api-headers ];
  };

  "mutt" = fetch {
    pname       = "mutt";
    version     = "1.13.5";
    srcs        = [{ filename = "mutt-1.13.5-1-i686.pkg.tar.xz"; sha256 = "ebb072d6377b197d7f64effd46c30f54dace771f0bc8fb7fb75eb57d9e58b29f"; }];
    buildInputs = [ libgpgme libsasl libgdbm ncurses libgnutls libidn2 ];
  };

  "nano" = fetch {
    pname       = "nano";
    version     = "4.9.2";
    srcs        = [{ filename = "nano-4.9.2-1-i686.pkg.tar.xz"; sha256 = "989bf9358ca6c5489a0a0e72d27d8528daf49ccf258b053919f1bed9cec0dd16"; }];
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
    version     = "2.14.02";
    srcs        = [{ filename = "nasm-2.14.02-1-i686.pkg.tar.xz"; sha256 = "e60ff5518fd89c21499c6a32ebeedf40bc9e47afa5ed207f63371038b75d3db2"; }];
    buildInputs = [ msys2-runtime ];
  };

  "nawk" = fetch {
    pname       = "nawk";
    version     = "20180827";
    srcs        = [{ filename = "nawk-20180827-1-i686.pkg.tar.xz"; sha256 = "1d38cee84b79841ca65c4c03a38b58a78699e286df7e7d95b85a284dfbd82f88"; }];
    buildInputs = [ msys2-runtime ];
  };

  "ncurses" = fetch {
    pname       = "ncurses";
    version     = "6.2";
    srcs        = [{ filename = "ncurses-6.2-1-i686.pkg.tar.xz"; sha256 = "7865873811436d0d4655e49601ad89f90e3457b399184185a9145d22e1df40cc"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "ncurses-devel" = fetch {
    pname       = "ncurses-devel";
    version     = "6.2";
    srcs        = [{ filename = "ncurses-devel-6.2-1-i686.pkg.tar.xz"; sha256 = "a7fa910402f180993e8f53b8331d261312d451783b2235b496c1ec66b104efa1"; }];
    buildInputs = [ (assert ncurses.version=="6.2"; ncurses) ];
  };

  "nettle" = fetch {
    pname       = "nettle";
    version     = "3.6";
    srcs        = [{ filename = "nettle-3.6-1-i686.pkg.tar.zst"; sha256 = "767aa7195079cb301145b0699d600fc203bc297931863ca17aa7c32165c2a97e"; }];
    buildInputs = [ libnettle ];
  };

  "nghttp2" = fetch {
    pname       = "nghttp2";
    version     = "1.40.0";
    srcs        = [{ filename = "nghttp2-1.40.0-1-i686.pkg.tar.xz"; sha256 = "00fabe0ae0fece0ee0c6905239e26287d319b29c485ed4d97f48467a7c20e0a4"; }];
    buildInputs = [ gcc-libs jansson (assert libnghttp2.version=="1.40.0"; libnghttp2) ];
  };

  "ninja" = fetch {
    pname       = "ninja";
    version     = "1.10.0";
    srcs        = [{ filename = "ninja-1.10.0-1-i686.pkg.tar.xz"; sha256 = "3c5acf6612a481de4a93f6f4dd7cf99addad164febf44457be5e576d71e8ee60"; }];
    buildInputs = [  ];
  };

  "ninja-emacs" = fetch {
    pname       = "ninja-emacs";
    version     = "1.10.0";
    srcs        = [{ filename = "ninja-emacs-1.10.0-1-i686.pkg.tar.xz"; sha256 = "8dabf49ea6ee2e5f0180428cfbf4189df11a24959d6da84532c9be84e034cd98"; }];
    buildInputs = [ (assert ninja.version=="1.10.0"; ninja) emacs ];
  };

  "ninja-vim" = fetch {
    pname       = "ninja-vim";
    version     = "1.10.0";
    srcs        = [{ filename = "ninja-vim-1.10.0-1-i686.pkg.tar.xz"; sha256 = "8251851ae193a889b20926a4b5adeb629b1a68aa81784f5fc3d7bca613f66675"; }];
    buildInputs = [ (assert ninja.version=="1.10.0"; ninja) vim ];
  };

  "openbsd-netcat" = fetch {
    pname       = "openbsd-netcat";
    version     = "1.206_1";
    srcs        = [{ filename = "openbsd-netcat-1.206_1-1-i686.pkg.tar.xz"; sha256 = "c42e98ab23a481b7c11c24336c882f9693dd8253d61cf341e3047b749aaac65b"; }];
  };

  "openssh" = fetch {
    pname       = "openssh";
    version     = "8.2p1";
    srcs        = [{ filename = "openssh-8.2p1-1-i686.pkg.tar.xz"; sha256 = "f315d6001ff91f3942bb0d6c53ef04a9c64d1dda761fc07ba17e37632f460aa1"; }];
    buildInputs = [ heimdal libedit libcrypt openssl ];
  };

  "openssl" = fetch {
    pname       = "openssl";
    version     = "1.1.1.g";
    srcs        = [{ filename = "openssl-1.1.1.g-1-i686.pkg.tar.xz"; sha256 = "922c9a5b2e9af50344dbc526e6f797d4144b3e236d0ac86be286a1a85b982c4a"; }];
    buildInputs = [ libopenssl zlib ];
  };

  "openssl-devel" = fetch {
    pname       = "openssl-devel";
    version     = "1.1.1.g";
    srcs        = [{ filename = "openssl-devel-1.1.1.g-1-i686.pkg.tar.xz"; sha256 = "d47c49ba0e71516f4fe86cb7f90973ab7a3f589578c76c9ed7f103143eda1dc6"; }];
    buildInputs = [ (assert libopenssl.version=="1.1.1.g"; libopenssl) zlib-devel ];
  };

  "p11-kit" = fetch {
    pname       = "p11-kit";
    version     = "0.23.20";
    srcs        = [{ filename = "p11-kit-0.23.20-2-i686.pkg.tar.xz"; sha256 = "cc1ce1ed868467f91e7ca824d29f40d5af796edb13ee34243ca5c1018ea480b2"; }];
    buildInputs = [ (assert libp11-kit.version=="0.23.20"; libp11-kit) ];
  };

  "p7zip" = fetch {
    pname       = "p7zip";
    version     = "16.02";
    srcs        = [{ filename = "p7zip-16.02-1-i686.pkg.tar.xz"; sha256 = "e04caae8053ae6950f04359f3cb7aea93d673b74b7ef220f3a7a2606d73f009a"; }];
    buildInputs = [ gcc-libs bash ];
  };

  "pacman" = fetch {
    pname       = "pacman";
    version     = "5.2.2";
    srcs        = [{ filename = "pacman-5.2.2-4-i686.pkg.tar.xz"; sha256 = "e2a8200aa142d6f6aaa7bf4e627adfd5537a06a42f34c85785f009dc2c439555"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast bash.version "4.2.045"; bash) gettext gnupg curl pacman-mirrors msys2-keyring which bzip2 xz zstd ];
  };

  "pacman-contrib" = fetch {
    pname       = "pacman-contrib";
    version     = "1.3.0";
    srcs        = [{ filename = "pacman-contrib-1.3.0-1-i686.pkg.tar.zst"; sha256 = "21e08073d2b328e9e253693316e9da29b1b90e2de8b4ddc13c18bb83981c3141"; }];
    buildInputs = [ perl pacman bash ];
  };

  "pacman-mirrors" = fetch {
    pname       = "pacman-mirrors";
    version     = "20200329";
    srcs        = [{ filename = "pacman-mirrors-20200329-1-any.pkg.tar.xz"; sha256 = "a2bd71635899c722421b5b2fcda4402d3d7de341b0b10cda801f05b8131d11b1"; }];
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
    version     = "20200322";
    srcs        = [{ filename = "parallel-20200322-1-any.pkg.tar.xz"; sha256 = "af6a62e8320c2fb78cb27e895857c5847dd80c40b6188a8d3c387c3c008f62ad"; }];
    buildInputs = [ perl ];
  };

  "pass" = fetch {
    pname       = "pass";
    version     = "1.7.3";
    srcs        = [{ filename = "pass-1.7.3-2-any.pkg.tar.xz"; sha256 = "84e02050adee6c63c1ae01daabf41af4ac16fd4214050b50fad8fde7b2e9d083"; }];
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
    version     = "8.44";
    srcs        = [{ filename = "pcre-8.44-1-i686.pkg.tar.xz"; sha256 = "186ee04205b88a2883f5e699fbf6b4dba528b6540b1bd166a0d0b576b6df3ea7"; }];
    buildInputs = [ libreadline libbz2 zlib libpcre libpcre16 libpcre32 libpcrecpp libpcreposix ];
  };

  "pcre-devel" = fetch {
    pname       = "pcre-devel";
    version     = "8.44";
    srcs        = [{ filename = "pcre-devel-8.44-1-i686.pkg.tar.xz"; sha256 = "19096d744b6fd6284e84caa7628c97dd79f4eda3d2af6e2d094dbd0181a85082"; }];
    buildInputs = [ (assert libpcre.version=="8.44"; libpcre) (assert libpcre16.version=="8.44"; libpcre16) (assert libpcre32.version=="8.44"; libpcre32) (assert libpcreposix.version=="8.44"; libpcreposix) (assert libpcrecpp.version=="8.44"; libpcrecpp) ];
  };

  "pcre2" = fetch {
    pname       = "pcre2";
    version     = "10.34";
    srcs        = [{ filename = "pcre2-10.34-1-i686.pkg.tar.xz"; sha256 = "d23a487c2d32663456f45785a71a7d5ec8c47272970370705eda332dc1840d9c"; }];
    buildInputs = [ libreadline libbz2 zlib (assert libpcre2_8.version=="10.34"; libpcre2_8) (assert libpcre2_16.version=="10.34"; libpcre2_16) (assert libpcre2_32.version=="10.34"; libpcre2_32) (assert libpcre2posix.version=="10.34"; libpcre2posix) ];
  };

  "pcre2-devel" = fetch {
    pname       = "pcre2-devel";
    version     = "10.34";
    srcs        = [{ filename = "pcre2-devel-10.34-1-i686.pkg.tar.xz"; sha256 = "cbbfb9cb9522dffc6fab6d1652026c41617af751c6f7b198f27a092bbd86ae79"; }];
    buildInputs = [ (assert libpcre2_8.version=="10.34"; libpcre2_8) (assert libpcre2_16.version=="10.34"; libpcre2_16) (assert libpcre2_32.version=="10.34"; libpcre2_32) (assert libpcre2posix.version=="10.34"; libpcre2posix) ];
  };

  "perl" = fetch {
    pname       = "perl";
    version     = "5.30.2";
    srcs        = [{ filename = "perl-5.30.2-1-i686.pkg.tar.xz"; sha256 = "e6d12fc41aa9661498b1a6cbb55c7cf933483653ab8c1372abde97d69af89ba7"; }];
    buildInputs = [ db gdbm libcrypt coreutils msys2-runtime sh ];
  };

  "perl-Algorithm-Diff" = fetch {
    pname       = "perl-Algorithm-Diff";
    version     = "1.1903";
    srcs        = [{ filename = "perl-Algorithm-Diff-1.1903-1-any.pkg.tar.xz"; sha256 = "34ddd74521dc66e384499db5e798ef57f326301e26befc918f3dc4bd4c7f22db"; }];
    buildInputs = [ perl ];
  };

  "perl-Alien-Build" = fetch {
    pname       = "perl-Alien-Build";
    version     = "2.21";
    srcs        = [{ filename = "perl-Alien-Build-2.21-1-any.pkg.tar.xz"; sha256 = "61abb752ddb4dfb61795d966be34af416b21721444849bd7c551dcd13641b23f"; }];
    buildInputs = [ perl-Capture-Tiny perl-FFI-CheckLib perl-File-chdir perl-File-Which ];
  };

  "perl-Alien-Libxml2" = fetch {
    pname       = "perl-Alien-Libxml2";
    version     = "0.16";
    srcs        = [{ filename = "perl-Alien-Libxml2-0.16-1-any.pkg.tar.zst"; sha256 = "f5f7094d7a444b5022b33219f065bfdd5001529f36414186626bfb3913454752"; }];
    buildInputs = [ libxml2 perl-Alien-Build ];
  };

  "perl-Archive-Zip" = fetch {
    pname       = "perl-Archive-Zip";
    version     = "1.68";
    srcs        = [{ filename = "perl-Archive-Zip-1.68-1-any.pkg.tar.xz"; sha256 = "b52effb35121c16f362c2ec0c9804bcf94793abeeff40c7dd78e5fbd00ceda7f"; }];
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
    version     = "6.08";
    srcs        = [{ filename = "perl-Carp-Clan-6.08-1-any.pkg.tar.xz"; sha256 = "0b23eb1e8128aaecd704642bb046f07f9b161d18f90f6bdd1f06eb9461fc34cf"; }];
    buildInputs = [ perl ];
  };

  "perl-Class-Method-Modifiers" = fetch {
    pname       = "perl-Class-Method-Modifiers";
    version     = "2.12";
    srcs        = [{ filename = "perl-Class-Method-Modifiers-2.12-1-any.pkg.tar.xz"; sha256 = "90390bd2909fc54b1afa7f6bd1c88ec11aa66eaf078b190d1490a008f982f7d6"; }];
    buildInputs = [ perl-Test-Fatal perl-Test-Requires ];
  };

  "perl-Compress-Bzip2" = fetch {
    pname       = "perl-Compress-Bzip2";
    version     = "2.26";
    srcs        = [{ filename = "perl-Compress-Bzip2-2.26-3-i686.pkg.tar.xz"; sha256 = "e8a1467def76966ffab7b7a82b64405ef5ab53df995e41f421cf6df341e5de86"; }];
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
    srcs        = [{ filename = "perl-Crypt-SSLeay-0.73_06-3-i686.pkg.tar.xz"; sha256 = "1aa72520e06b29a0438408340d2450a691e7b22af1ad6f1723d830f713ad35b8"; }];
    buildInputs = [ perl-LWP-Protocol-https perl-Try-Tiny perl-Path-Class ];
  };

  "perl-DBI" = fetch {
    pname       = "perl-DBI";
    version     = "1.643";
    srcs        = [{ filename = "perl-DBI-1.643-1-i686.pkg.tar.xz"; sha256 = "58406321b2e96867d128753e873b448d18b2a89f561ed71b9f58c810fa06ed00"; }];
    buildInputs = [ perl ];
  };

  "perl-Data-Munge" = fetch {
    pname       = "perl-Data-Munge";
    version     = "0.097";
    srcs        = [{ filename = "perl-Data-Munge-0.097-1-any.pkg.tar.xz"; sha256 = "6480673c701a07ef28b8bec91916c498ce68490c8e40072015bdeb02df7ea4e9"; }];
    buildInputs = [ perl ];
  };

  "perl-Data-OptList" = fetch {
    pname       = "perl-Data-OptList";
    version     = "0.110";
    srcs        = [{ filename = "perl-Data-OptList-0.110-1-any.pkg.tar.xz"; sha256 = "6decbb651b109876cb2420600c15fc0a4669114dc3fee0c5a497364c84cce21c"; }];
    buildInputs = [ perl-Params-Util perl-Scalar-List-Utils perl-Sub-Install ];
  };

  "perl-Date-Calc" = fetch {
    pname       = "perl-Date-Calc";
    version     = "6.4";
    srcs        = [{ filename = "perl-Date-Calc-6.4-1-any.pkg.tar.xz"; sha256 = "e528b1cdf792a722dc4aab52b704e23e3a020f80fc2bce03d4d63e1beb88a4ef"; }];
    buildInputs = [ perl ];
  };

  "perl-Devel-GlobalDestruction" = fetch {
    pname       = "perl-Devel-GlobalDestruction";
    version     = "0.14";
    srcs        = [{ filename = "perl-Devel-GlobalDestruction-0.14-1-any.pkg.tar.xz"; sha256 = "ee9a89ac8ca77d347949c08163aa459939e0448ef4dd322cd669e253aa416fb7"; }];
    buildInputs = [ perl perl-Sub-Exporter perl-Sub-Exporter-Progressive ];
  };

  "perl-Digest-HMAC" = fetch {
    pname       = "perl-Digest-HMAC";
    version     = "1.03";
    srcs        = [{ filename = "perl-Digest-HMAC-1.03-2-any.pkg.tar.xz"; sha256 = "433015360607c7d3bbf9fdb63ccf2956a04a570f79d641e52b546bba67d43d1d"; }];
  };

  "perl-Digest-MD4" = fetch {
    pname       = "perl-Digest-MD4";
    version     = "1.9";
    srcs        = [{ filename = "perl-Digest-MD4-1.9-4-any.pkg.tar.xz"; sha256 = "8e2d33aab29db5155d19bb8332d761bff74259c5d653b7d5b784244e1cc9f603"; }];
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
    version     = "0.17029";
    srcs        = [{ filename = "perl-Error-0.17029-1-any.pkg.tar.xz"; sha256 = "2a29bebf874ee1dcab4d01b47fad59cf8000e8e9677df9d0c916b3489ee3cda3"; }];
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
    version     = "1.002002";
    srcs        = [{ filename = "perl-Exporter-Tiny-1.002002-1-any.pkg.tar.zst"; sha256 = "3cca492ffcf68fb9577a2286c204ab3847aacfb12bbdd47f04d0e61f8358ad2b"; }];
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-Depends" = fetch {
    pname       = "perl-ExtUtils-Depends";
    version     = "0.8000";
    srcs        = [{ filename = "perl-ExtUtils-Depends-0.8000-1-any.pkg.tar.xz"; sha256 = "8ac6b2eb922f9af662ad6794cd7172e7ecd4ac15b62cc928c2859fa17d4720ca"; }];
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

  "perl-FFI-CheckLib" = fetch {
    pname       = "perl-FFI-CheckLib";
    version     = "0.26";
    srcs        = [{ filename = "perl-FFI-CheckLib-0.26-1-any.pkg.tar.xz"; sha256 = "8dfc839fd7a99dd170b1e1c8af17ff7cd5bdfbd1f540975536a85d3fa0e2f5a7"; }];
    buildInputs = [ perl ];
  };

  "perl-File-Copy-Recursive" = fetch {
    pname       = "perl-File-Copy-Recursive";
    version     = "0.45";
    srcs        = [{ filename = "perl-File-Copy-Recursive-0.45-1-any.pkg.tar.xz"; sha256 = "3188ecc4a9632639dce381321e03a0a6507f46d5a716c147460ec845c05ffda2"; }];
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
    version     = "1.18";
    srcs        = [{ filename = "perl-File-Next-1.18-1-any.pkg.tar.xz"; sha256 = "d7548b59b751a7a2a3dc861e1c3f62ae8e0cddcf9d778fedf1e30c2bdd0f1a0d"; }];
    buildInputs = [ perl ];
  };

  "perl-File-Which" = fetch {
    pname       = "perl-File-Which";
    version     = "1.23";
    srcs        = [{ filename = "perl-File-Which-1.23-1-any.pkg.tar.xz"; sha256 = "e7b921a957ce7e70e27f30cade377739adc441a54fbbe2508da2c042944492ca"; }];
    buildInputs = [ perl (assert stdenvNoCC.lib.versionAtLeast perl-Test-Script.version "1.05"; perl-Test-Script) ];
  };

  "perl-File-chdir" = fetch {
    pname       = "perl-File-chdir";
    version     = "0.1011";
    srcs        = [{ filename = "perl-File-chdir-0.1011-1-any.pkg.tar.xz"; sha256 = "94e24d19b1de23eab4b58a28c1074db9036c65b6b53df152cd6ea07886009954"; }];
    buildInputs = [ perl ];
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
    srcs        = [{ filename = "perl-HTML-Parser-3.72-4-i686.pkg.tar.xz"; sha256 = "b4d4b70060b8456f68aefd7dbe227b68f9214d249a649b2ec9d30e64cd4a1de9"; }];
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
    version     = "6.08";
    srcs        = [{ filename = "perl-HTTP-Cookies-6.08-1-any.pkg.tar.xz"; sha256 = "196a24d5d30b27492ba85832f6d674233ca12dcba21853e90a6c49eceb641a01"; }];
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
    version     = "6.05";
    srcs        = [{ filename = "perl-HTTP-Date-6.05-1-any.pkg.tar.xz"; sha256 = "8cb622a2cda929cfbfc3c4b7b9768dce69b3c317d23fd20bbf7643a76cb70e9a"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.8"; perl) ];
  };

  "perl-HTTP-Message" = fetch {
    pname       = "perl-HTTP-Message";
    version     = "6.22";
    srcs        = [{ filename = "perl-HTTP-Message-6.22-1-any.pkg.tar.xz"; sha256 = "e31814f4f5ef569fca498fd368f91c92b0c8e031beabf457644c4e29f2e383be"; }];
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
    version     = "2.066";
    srcs        = [{ filename = "perl-IO-Socket-SSL-2.066-1-any.pkg.tar.xz"; sha256 = "00d98d5c53bd018ab687707c7ccae9f07212fcb36d769f68f0a830e21fcb9eb9"; }];
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

  "perl-Import-Into" = fetch {
    pname       = "perl-Import-Into";
    version     = "1.002005";
    srcs        = [{ filename = "perl-Import-Into-1.002005-1-any.pkg.tar.xz"; sha256 = "78667109131ec7d8df9aaba76ad92380406cf3ace3865703a5a50caec161f6e4"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl-Module-Runtime.version "0"; perl-Module-Runtime) (assert stdenvNoCC.lib.versionAtLeast perl.version "5.006"; perl) ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "perl-Importer" = fetch {
    pname       = "perl-Importer";
    version     = "0.025";
    srcs        = [{ filename = "perl-Importer-0.025-1-any.pkg.tar.xz"; sha256 = "f549c625778c856be1f368ce8217f2d413ed0475da234b1442f9265ba5ce7d57"; }];
    buildInputs = [ perl ];
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
    srcs        = [{ filename = "perl-List-MoreUtils-XS-0.428-3-i686.pkg.tar.xz"; sha256 = "db46a251b8c14485a6322766e135ee1dee3ff218228057f3bb28bc6e3b0b4e3f"; }];
    buildInputs = [ perl ];
  };

  "perl-Locale-Gettext" = fetch {
    pname       = "perl-Locale-Gettext";
    version     = "1.07";
    srcs        = [{ filename = "perl-Locale-Gettext-1.07-4-i686.pkg.tar.xz"; sha256 = "4ca634fac4dc5dcd7af6e53ef0b8f4a425e40cbd1de69e253c881dd25be9aec2"; }];
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
    version     = "2.21";
    srcs        = [{ filename = "perl-MailTools-2.21-1-any.pkg.tar.xz"; sha256 = "8f01c6db585a3897d1e7e011d1fe50e831043f19045546dc471e0ac23b7ac3e8"; }];
    buildInputs = [ perl-TimeDate ];
  };

  "perl-Math-Int64" = fetch {
    pname       = "perl-Math-Int64";
    version     = "0.54";
    srcs        = [{ filename = "perl-Math-Int64-0.54-3-any.pkg.tar.xz"; sha256 = "d98cbde693c143b2cc4fd1c2c71541b0293efcd49abcb5abccc2a49dc17b425a"; }];
    buildInputs = [ perl ];
  };

  "perl-Module-Build" = fetch {
    pname       = "perl-Module-Build";
    version     = "0.4231";
    srcs        = [{ filename = "perl-Module-Build-0.4231-1-any.pkg.tar.xz"; sha256 = "bc3c10e33fc4caf85316ec2a32536ade782cc9c89008100d2da7522dc948abef"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.0"; perl) (assert stdenvNoCC.lib.versionAtLeast perl-CPAN-Meta.version "2.142060"; perl-CPAN-Meta) perl-inc-latest ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "perl-Module-Pluggable" = fetch {
    pname       = "perl-Module-Pluggable";
    version     = "5.2";
    srcs        = [{ filename = "perl-Module-Pluggable-5.2-1-any.pkg.tar.xz"; sha256 = "235d31514f79aac03046f3c4319fdfc99035de498f6c95ff9a12b6b735467e00"; }];
    buildInputs = [ perl ];
  };

  "perl-Module-Runtime" = fetch {
    pname       = "perl-Module-Runtime";
    version     = "0.016";
    srcs        = [{ filename = "perl-Module-Runtime-0.016-1-any.pkg.tar.xz"; sha256 = "6824721307d3d1e74e30613a8a8804840925664395d94de82003f821dd08feca"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.0"; perl) perl-Module-Build ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "perl-Moo" = fetch {
    pname       = "perl-Moo";
    version     = "2.003006";
    srcs        = [{ filename = "perl-Moo-2.003006-1-any.pkg.tar.xz"; sha256 = "13012662b98adadbb0533006d9d8d390b628b83871106df098417304712e05c8"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl-Class-Method-Modifiers.version "1.1"; perl-Class-Method-Modifiers) (assert stdenvNoCC.lib.versionAtLeast perl-Devel-GlobalDestruction.version "0.11"; perl-Devel-GlobalDestruction) (assert stdenvNoCC.lib.versionAtLeast perl-Import-Into.version "1.002"; perl-Import-Into) (assert stdenvNoCC.lib.versionAtLeast perl-Module-Runtime.version "0.014"; perl-Module-Runtime) (assert stdenvNoCC.lib.versionAtLeast perl-Role-Tiny.version "2"; perl-Role-Tiny) perl-Sub-Quote ];
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
    version     = "1.23";
    srcs        = [{ filename = "perl-Net-DNS-1.23-1-i686.pkg.tar.xz"; sha256 = "315426ceec9668f6f11d8b41cebc6173afa5a96d4a67d0e87088703d964c62fe"; }];
    buildInputs = [ perl-Digest-HMAC perl-Net-IP perl ];
  };

  "perl-Net-HTTP" = fetch {
    pname       = "perl-Net-HTTP";
    version     = "6.19";
    srcs        = [{ filename = "perl-Net-HTTP-6.19-1-any.pkg.tar.xz"; sha256 = "dd6f538463c1bf6c720585cd22f0812f1014f26bd0891a5e0d85a88feb42bb23"; }];
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
    version     = "1.88";
    srcs        = [{ filename = "perl-Net-SSLeay-1.88-1-i686.pkg.tar.xz"; sha256 = "7f3618181cc78f354077ef02d8596d7569a029ae54913c30f483dad5f4a6bd98"; }];
    buildInputs = [ openssl ];
  };

  "perl-Parallel-ForkManager" = fetch {
    pname       = "perl-Parallel-ForkManager";
    version     = "2.02";
    srcs        = [{ filename = "perl-Parallel-ForkManager-2.02-2-any.pkg.tar.xz"; sha256 = "3f0acd4ba2e9935b4e7765b98f9b1ba1f477873a543b2c4851aead20403ed5e5"; }];
    buildInputs = [ perl perl-Moo ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "perl-Params-Util" = fetch {
    pname       = "perl-Params-Util";
    version     = "1.07";
    srcs        = [{ filename = "perl-Params-Util-1.07-1-i686.pkg.tar.xz"; sha256 = "222dcd66573f2e51a8e31747fe108846a3a2a307b134b1c9d2bf63eeaa078f9f"; }];
    buildInputs = [ perl ];
  };

  "perl-Path-Class" = fetch {
    pname       = "perl-Path-Class";
    version     = "0.37";
    srcs        = [{ filename = "perl-Path-Class-0.37-1-any.pkg.tar.xz"; sha256 = "4db5b9c61f2c8409e23476c76e6f41b821327f178ba0672db5594094e4d2557e"; }];
    buildInputs = [ perl ];
  };

  "perl-Path-Tiny" = fetch {
    pname       = "perl-Path-Tiny";
    version     = "0.112";
    srcs        = [{ filename = "perl-Path-Tiny-0.112-1-any.pkg.tar.xz"; sha256 = "b3d9ff94d344026ea44b17869acd8958c31c8630c0788de4463615351bdb17bc"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.1"; perl) ];
  };

  "perl-PerlIO-gzip" = fetch {
    pname       = "perl-PerlIO-gzip";
    version     = "0.20";
    srcs        = [{ filename = "perl-PerlIO-gzip-0.20-1-any.pkg.tar.xz"; sha256 = "099936bd49972689d50469557acab0811604fadd6ef8477efe71f84086010ee8"; }];
    buildInputs = [ perl zlib ];
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

  "perl-Return-MultiLevel" = fetch {
    pname       = "perl-Return-MultiLevel";
    version     = "0.05";
    srcs        = [{ filename = "perl-Return-MultiLevel-0.05-1-any.pkg.tar.xz"; sha256 = "1a109144f6ffb668a3265ea81011136e7ca0e42327a71ab4e4821a6f2fbdfc0b"; }];
    buildInputs = [ perl-Data-Munge ];
  };

  "perl-Role-Tiny" = fetch {
    pname       = "perl-Role-Tiny";
    version     = "2.001004";
    srcs        = [{ filename = "perl-Role-Tiny-2.001004-1-any.pkg.tar.xz"; sha256 = "fb4af5eb06f8a3f60353e5463ea73341df7212c5f671514f380f7c0cfe986368"; }];
    buildInputs = [ perl ];
  };

  "perl-Scalar-List-Utils" = fetch {
    pname       = "perl-Scalar-List-Utils";
    version     = "1.54";
    srcs        = [{ filename = "perl-Scalar-List-Utils-1.54-1-i686.pkg.tar.xz"; sha256 = "337dd611a42504a9b490c86181fc0298b838e91fb68a46a656a61a111f3462da"; }];
    buildInputs = [ perl ];
  };

  "perl-Scope-Guard" = fetch {
    pname       = "perl-Scope-Guard";
    version     = "0.21";
    srcs        = [{ filename = "perl-Scope-Guard-0.21-1-any.pkg.tar.xz"; sha256 = "d2cae878aee50d7416b05cb26b90720e7dbc8a9fea905ef113853544854f2947"; }];
    buildInputs = [ perl ];
  };

  "perl-Socket6" = fetch {
    pname       = "perl-Socket6";
    version     = "0.29";
    srcs        = [{ filename = "perl-Socket6-0.29-2-i686.pkg.tar.xz"; sha256 = "2a3c3a3071ca5ba1c8446d0b45c3e88cef31990903c933ba225356bd18d8d295"; }];
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

  "perl-Sub-Exporter" = fetch {
    pname       = "perl-Sub-Exporter";
    version     = "0.987";
    srcs        = [{ filename = "perl-Sub-Exporter-0.987-1-any.pkg.tar.xz"; sha256 = "e22fe9803a51b7e805712d8cbdf77f602a9ea942c48d0f6c273a6ddd8d70860d"; }];
    buildInputs = [ perl perl-Data-OptList perl-Params-Util perl-Sub-Install ];
  };

  "perl-Sub-Exporter-Progressive" = fetch {
    pname       = "perl-Sub-Exporter-Progressive";
    version     = "0.001013";
    srcs        = [{ filename = "perl-Sub-Exporter-Progressive-0.001013-1-any.pkg.tar.xz"; sha256 = "ef5d2264fc7b195c720441a7c975dbff1965fd480577f664608fc79d4f426536"; }];
    buildInputs = [ perl ];
  };

  "perl-Sub-Info" = fetch {
    pname       = "perl-Sub-Info";
    version     = "0.002";
    srcs        = [{ filename = "perl-Sub-Info-0.002-1-any.pkg.tar.xz"; sha256 = "c673f272b21c9552f73d32eb66cfcc6f5365c0e689842041ac32ae709c0938a3"; }];
    buildInputs = [ perl-Importer ];
  };

  "perl-Sub-Install" = fetch {
    pname       = "perl-Sub-Install";
    version     = "0.928";
    srcs        = [{ filename = "perl-Sub-Install-0.928-1-any.pkg.tar.xz"; sha256 = "c8aa3499b5795828b7bb9fb2e909fef92d84dfae726819210d1bb51b32f23153"; }];
    buildInputs = [ perl ];
  };

  "perl-Sub-Quote" = fetch {
    pname       = "perl-Sub-Quote";
    version     = "2.006003";
    srcs        = [{ filename = "perl-Sub-Quote-2.006003-1-any.pkg.tar.xz"; sha256 = "164ac6979d4dd2343aab4e71fbaab167549d5874e6c1bf2d889a08360d3d1171"; }];
    buildInputs = [ perl ];
  };

  "perl-Sys-CPU" = fetch {
    pname       = "perl-Sys-CPU";
    version     = "0.61";
    srcs        = [{ filename = "perl-Sys-CPU-0.61-6-i686.pkg.tar.xz"; sha256 = "40c993d48bc20a6bc2ae5c4a2257c8b4b773b4921687615d00bc5462b3834b6c"; }];
    buildInputs = [ perl libcrypt-devel ];
  };

  "perl-TAP-Harness-Archive" = fetch {
    pname       = "perl-TAP-Harness-Archive";
    version     = "0.18";
    srcs        = [{ filename = "perl-TAP-Harness-Archive-0.18-1-any.pkg.tar.xz"; sha256 = "d2ab8e8a945fc366f7b675081263b636e1949ada9ab53d6ae613d04ab5183516"; }];
    buildInputs = [ perl-YAML-Tiny perl ];
  };

  "perl-Term-Table" = fetch {
    pname       = "perl-Term-Table";
    version     = "0.015";
    srcs        = [{ filename = "perl-Term-Table-0.015-1-any.pkg.tar.xz"; sha256 = "594a40fdf06ba823a8db4f71368d75e3b57fbdd73e5b2ca65a35bd26ec85e290"; }];
    buildInputs = [ perl-Importer ];
  };

  "perl-TermReadKey" = fetch {
    pname       = "perl-TermReadKey";
    version     = "2.38";
    srcs        = [{ filename = "perl-TermReadKey-2.38-1-i686.pkg.tar.xz"; sha256 = "890d7dda647ccf74267d15120518db9693f2dfcaf80233f984389d01d52967c0"; }];
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
    version     = "1.130";
    srcs        = [{ filename = "perl-Test-Deep-1.130-1-any.pkg.tar.xz"; sha256 = "7ee6d3f09bd439799feb214210588f237f561a848c862f951abf1ee5f69b12c6"; }];
    buildInputs = [ perl perl-Test-Simple perl-Test-NoWarnings ];
  };

  "perl-Test-Exit" = fetch {
    pname       = "perl-Test-Exit";
    version     = "0.11";
    srcs        = [{ filename = "perl-Test-Exit-0.11-1-any.pkg.tar.xz"; sha256 = "bbc2ea184be836f34ad740ebb5bfbffea087f2344c585833b940629f9d25d02b"; }];
    buildInputs = [ perl-Return-MultiLevel ];
  };

  "perl-Test-Fatal" = fetch {
    pname       = "perl-Test-Fatal";
    version     = "0.014";
    srcs        = [{ filename = "perl-Test-Fatal-0.014-1-any.pkg.tar.xz"; sha256 = "d77a60cb0457257376ee9a358e2c32e0291714922c975031763cf58f97ee8b73"; }];
    buildInputs = [ perl perl-Try-Tiny ];
  };

  "perl-Test-Harness" = fetch {
    pname       = "perl-Test-Harness";
    version     = "3.42";
    srcs        = [{ filename = "perl-Test-Harness-3.42-1-any.pkg.tar.xz"; sha256 = "d2217b84d7af39aae9fdfe4b6db4a3b58e4346d6bf3b3e652f5996c827a89691"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Needs" = fetch {
    pname       = "perl-Test-Needs";
    version     = "0.002006";
    srcs        = [{ filename = "perl-Test-Needs-0.002006-1-any.pkg.tar.xz"; sha256 = "906dc4d83d2298eac25ffe1b373ad019821a7347e1abda7468cf5eb5cf81bbaf"; }];
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

  "perl-Test-Requires" = fetch {
    pname       = "perl-Test-Requires";
    version     = "0.10";
    srcs        = [{ filename = "perl-Test-Requires-0.10-1-any.pkg.tar.xz"; sha256 = "7cc7155258e4235ce8c99d09f309412d7b54405dd69b16ac29bfd94737d70270"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Requiresinternet" = fetch {
    pname       = "perl-Test-Requiresinternet";
    version     = "0.05";
    srcs        = [{ filename = "perl-Test-Requiresinternet-0.05-1-any.pkg.tar.xz"; sha256 = "1503e79d20ae21e6d60f84b5654763eb88f8ce313b7f5469e4035b55067246a0"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Script" = fetch {
    pname       = "perl-Test-Script";
    version     = "1.26";
    srcs        = [{ filename = "perl-Test-Script-1.26-1-any.pkg.tar.xz"; sha256 = "4e4320169c2266c261e9a3ae785963fb450138776215562b23c70bdaecd6b8c2"; }];
    buildInputs = [ perl perl-IPC-Run3 perl-Probe-Perl perl-Test-Simple ];
  };

  "perl-Test-Simple" = fetch {
    pname       = "perl-Test-Simple";
    version     = "1.302175";
    srcs        = [{ filename = "perl-Test-Simple-1.302175-1-any.pkg.tar.xz"; sha256 = "f5057d0db2e8c8a52584aefbe98353a84935e9f1e81cee19068409fb07a75278"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Warnings" = fetch {
    pname       = "perl-Test-Warnings";
    version     = "0.029";
    srcs        = [{ filename = "perl-Test-Warnings-0.029-1-any.pkg.tar.xz"; sha256 = "ec716d39d82e2076778be3716543d1729afb7742a9194426edcce06e8414ed21"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-YAML" = fetch {
    pname       = "perl-Test-YAML";
    version     = "1.07";
    srcs        = [{ filename = "perl-Test-YAML-1.07-1-any.pkg.tar.xz"; sha256 = "aac3244bf46937cb7bcb4fadb2633115dfb372b2b36b6e5368ec8429693d2527"; }];
    buildInputs = [ perl perl-Test-Base ];
    broken      = true; # broken dependency perl-Text-Diff -> perl-Exporter
  };

  "perl-Test2-Suite" = fetch {
    pname       = "perl-Test2-Suite";
    version     = "0.000129";
    srcs        = [{ filename = "perl-Test2-Suite-0.000129-1-any.pkg.tar.xz"; sha256 = "e88c0bcd63d94437230371f4a29538ad1ef060ff05f2478285cb0887100d28b6"; }];
    buildInputs = [ perl-Module-Pluggable perl-Importer perl-Scope-Guard perl-Sub-Info perl-Term-Table (assert stdenvNoCC.lib.versionAtLeast perl-Test-Simple.version "1.302158"; perl-Test-Simple) ];
  };

  "perl-Text-CharWidth" = fetch {
    pname       = "perl-Text-CharWidth";
    version     = "0.04";
    srcs        = [{ filename = "perl-Text-CharWidth-0.04-4-any.pkg.tar.xz"; sha256 = "da9b7048670421e0e874ead1f0f37dd016b1627b0aa61635352799cef6ee7167"; }];
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
    version     = "2.32";
    srcs        = [{ filename = "perl-TimeDate-2.32-1-any.pkg.tar.xz"; sha256 = "a598ea51dd26d6f1e89bbcd20c5779850de839ec0505ecc034348ca889b94a06"; }];
    buildInputs = [ perl ];
  };

  "perl-Try-Tiny" = fetch {
    pname       = "perl-Try-Tiny";
    version     = "0.30";
    srcs        = [{ filename = "perl-Try-Tiny-0.30-1-any.pkg.tar.xz"; sha256 = "9fcc6917277396441822688a3bc5e0fe79e8478da401f8691c197678b5e7c2c5"; }];
    buildInputs = [ perl ];
  };

  "perl-URI" = fetch {
    pname       = "perl-URI";
    version     = "1.76";
    srcs        = [{ filename = "perl-URI-1.76-1-any.pkg.tar.xz"; sha256 = "a55c6837534fbbd43e7941d6a07af51538a96fc3973b9e1824a065bc68e6bb39"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-Unicode-GCString" = fetch {
    pname       = "perl-Unicode-GCString";
    version     = "2019.001";
    srcs        = [{ filename = "perl-Unicode-GCString-2019.001-1-any.pkg.tar.xz"; sha256 = "a76510c403cf51b02a215a44c04982bc35ec0f18b51dacabfb91918da4e44667"; }];
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
    version     = "2.0204";
    srcs        = [{ filename = "perl-XML-LibXML-2.0204-1-i686.pkg.tar.xz"; sha256 = "47c30cbc5c35a20a62127551a952c94af2be7415fd4e07db944e42da41e305bc"; }];
    buildInputs = [ perl perl-Alien-Libxml2 perl-XML-SAX perl-XML-NamespaceSupport ];
  };

  "perl-XML-NamespaceSupport" = fetch {
    pname       = "perl-XML-NamespaceSupport";
    version     = "1.12";
    srcs        = [{ filename = "perl-XML-NamespaceSupport-1.12-1-any.pkg.tar.xz"; sha256 = "876402b8e974d19d2e823c7ffa762bd87fbb1ec2d9b5d4a44f6b27dff1c67e5c"; }];
    buildInputs = [ perl ];
  };

  "perl-XML-Parser" = fetch {
    pname       = "perl-XML-Parser";
    version     = "2.46";
    srcs        = [{ filename = "perl-XML-Parser-2.46-1-i686.pkg.tar.xz"; sha256 = "4bedd757348ffb2e005d1e3ea29b660bbe6f6db8cccb1c0dec6954b533131054"; }];
    buildInputs = [ perl libexpat libcrypt ];
  };

  "perl-XML-SAX" = fetch {
    pname       = "perl-XML-SAX";
    version     = "1.02";
    srcs        = [{ filename = "perl-XML-SAX-1.02-1-any.pkg.tar.xz"; sha256 = "a49624ed980aa911340121ecbe49f3c044fdd816674ee3336527c349acf3e46c"; }];
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
    version     = "1.30";
    srcs        = [{ filename = "perl-YAML-1.30-1-any.pkg.tar.xz"; sha256 = "07030595cc524e5c0c620645b7d868a533c104812b68f7c1abae8aac0cf3f24f"; }];
    buildInputs = [ perl ];
  };

  "perl-YAML-Syck" = fetch {
    pname       = "perl-YAML-Syck";
    version     = "1.32";
    srcs        = [{ filename = "perl-YAML-Syck-1.32-1-i686.pkg.tar.xz"; sha256 = "a6efedb573ada1b521f9f5add4a861ed4c30ba5e7932f57f037235692cc0b614"; }];
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
    version     = "3.3.1";
    srcs        = [{ filename = "perl-ack-3.3.1-1-any.pkg.tar.xz"; sha256 = "db3664c734affb9dc3f3ec3c7ff02444e96dc55eafd4072975bfe771bdce90bd"; }];
    buildInputs = [ perl-File-Next ];
  };

  "perl-common-sense" = fetch {
    pname       = "perl-common-sense";
    version     = "3.75";
    srcs        = [{ filename = "perl-common-sense-3.75-1-any.pkg.tar.xz"; sha256 = "71b3ff0650ebf90eb46eff051117b2e0afeb97c85d93cc6e4b822207a98cac44"; }];
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
    version     = "6.44";
    srcs        = [{ filename = "perl-libwww-6.44-1-any.pkg.tar.xz"; sha256 = "e283e26a1401319581530feeeae62c97937c8d7ad26a9eef0d68cefaf15a91f6"; }];
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
    version     = "21";
    srcs        = [{ filename = "pkgfile-21-1-i686.pkg.tar.xz"; sha256 = "a36b44660d2fb9127444a9064a5a634a3c3dd5b43ee33bbb3e0da860378af34e"; }];
    buildInputs = [ libarchive curl pcre pacman ];
  };

  "po4a" = fetch {
    pname       = "po4a";
    version     = "0.57";
    srcs        = [{ filename = "po4a-0.57-1-any.pkg.tar.xz"; sha256 = "8ae2d078abe25152f18bcdd6ed96a679f8094f5dc67ff9fa70e734aadb1cb03e"; }];
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
    version     = "3.3.15";
    srcs        = [{ filename = "procps-ng-3.3.15-1-i686.pkg.tar.xz"; sha256 = "ac1c299dbfb83add8646adb048228edf834950b48e3ef5854c96e78b7014d65f"; }];
    buildInputs = [ msys2-runtime ncurses ];
  };

  "protobuf" = fetch {
    pname       = "protobuf";
    version     = "3.11.4";
    srcs        = [{ filename = "protobuf-3.11.4-1-i686.pkg.tar.xz"; sha256 = "29f8278a6c9e78eab33c2d545e40329205446b00be2368028cbfd335b41a4184"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "protobuf-devel" = fetch {
    pname       = "protobuf-devel";
    version     = "3.11.4";
    srcs        = [{ filename = "protobuf-devel-3.11.4-1-i686.pkg.tar.xz"; sha256 = "820d25e691536d5f8ced099df7f7f172117a779eb43450ca97e0c512499d6afd"; }];
    buildInputs = [ (assert protobuf.version=="3.11.4"; protobuf) ];
  };

  "psmisc" = fetch {
    pname       = "psmisc";
    version     = "23.3";
    srcs        = [{ filename = "psmisc-23.3-1-i686.pkg.tar.xz"; sha256 = "0d098eedd5ac42d86be7ed6904540381ebe0b371716d2ee2f167230c70435292"; }];
    buildInputs = [ msys2-runtime gcc-libs ncurses libiconv libintl ];
  };

  "publicsuffix-list" = fetch {
    pname       = "publicsuffix-list";
    version     = "20200206.883.bf3f6df";
    srcs        = [{ filename = "publicsuffix-list-20200206.883.bf3f6df-1-any.pkg.tar.xz"; sha256 = "83c08788d260b935ef4c76e234c02ea30aa42799a471fab9f8d90625fde3c51d"; }];
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
    version     = "3.8.2";
    srcs        = [{ filename = "python-3.8.2-1-i686.pkg.tar.xz"; sha256 = "9812d07a48db6e549d66882787efb6f033edfea0dd663a9bb2900680687ee1f8"; }];
    buildInputs = [ libbz2 libexpat libffi liblzma ncurses libopenssl libreadline mpdecimal libsqlite zlib ];
  };

  "python-appdirs" = fetch {
    pname       = "python-appdirs";
    version     = "1.4.3";
    srcs        = [{ filename = "python-appdirs-1.4.3-5-any.pkg.tar.xz"; sha256 = "bb4cbedc9345baec89362c69cf91f6d6fa0b48f1b2f71f72548a713012a4554a"; }];
    buildInputs = [ python ];
  };

  "python-atomicwrites" = fetch {
    pname       = "python-atomicwrites";
    version     = "1.4.0";
    srcs        = [{ filename = "python-atomicwrites-1.4.0-1-any.pkg.tar.zst"; sha256 = "3795c1d1421ccda4e1380864539fa08ee9790aa93cd04a3c65db66c8963c0c81"; }];
    buildInputs = [ python ];
  };

  "python-attrs" = fetch {
    pname       = "python-attrs";
    version     = "19.3.0";
    srcs        = [{ filename = "python-attrs-19.3.0-3-any.pkg.tar.xz"; sha256 = "9d0fa2fec506cb4fb26390c935132160eb7f9d18baa91f5900f5847214a866fe"; }];
    buildInputs = [ python ];
  };

  "python-beaker" = fetch {
    pname       = "python-beaker";
    version     = "1.11.0";
    srcs        = [{ filename = "python-beaker-1.11.0-4-i686.pkg.tar.xz"; sha256 = "b58b1ae1c3b9ee81b85c0ee0fa3131d28556d774f145dae0ca86609ad446ed6a"; }];
    buildInputs = [ python python-setuptools ];
  };

  "python-brotli" = fetch {
    pname       = "python-brotli";
    version     = "1.0.7";
    srcs        = [{ filename = "python-brotli-1.0.7-3-i686.pkg.tar.xz"; sha256 = "2a9b4e74c1b352cd7abc1bfefd5c60f4c954da8b31060c21a8f115579f85d760"; }];
    buildInputs = [ python ];
  };

  "python-colorama" = fetch {
    pname       = "python-colorama";
    version     = "0.4.3";
    srcs        = [{ filename = "python-colorama-0.4.3-2-any.pkg.tar.xz"; sha256 = "98686a32a2363021150aab522dcfab5ff974a9764de92f5be6ae086827330faa"; }];
    buildInputs = [ python ];
  };

  "python-configobj" = fetch {
    pname       = "python-configobj";
    version     = "5.0.6";
    srcs        = [{ filename = "python-configobj-5.0.6-2-any.pkg.tar.xz"; sha256 = "b79fb1d504d3e03c21502b23099c8c487c4bcd6529407e98d775e96be7abf50c"; }];
    buildInputs = [ python ];
  };

  "python-dulwich" = fetch {
    pname       = "python-dulwich";
    version     = "0.19.16";
    srcs        = [{ filename = "python-dulwich-0.19.16-1-i686.pkg.tar.xz"; sha256 = "5ead6d97aa877056c7c8d4c1ab2a0c8c5ab9c5ce00f44da6fffa7be002c02c06"; }];
    buildInputs = [ python ];
  };

  "python-fastimport" = fetch {
    pname       = "python-fastimport";
    version     = "0.9.8";
    srcs        = [{ filename = "python-fastimport-0.9.8-2-any.pkg.tar.xz"; sha256 = "a39659cb16b067656596efe5e13a4aa2b99534f2d66539bad4a911a6e12c0743"; }];
    buildInputs = [ python ];
  };

  "python-mako" = fetch {
    pname       = "python-mako";
    version     = "1.1.2";
    srcs        = [{ filename = "python-mako-1.1.2-2-i686.pkg.tar.xz"; sha256 = "3f5aab4fce4cd6251f0a4d2e224b28262684e399399e8816555a2ac3c0f8d2b0"; }];
    buildInputs = [ python-markupsafe python-beaker ];
  };

  "python-markupsafe" = fetch {
    pname       = "python-markupsafe";
    version     = "1.1.1";
    srcs        = [{ filename = "python-markupsafe-1.1.1-3-i686.pkg.tar.xz"; sha256 = "f571ed72b7b68ef8353dc3c81a873c09d14931055e3d386f5e4c08002652af25"; }];
    buildInputs = [ python ];
  };

  "python-mock" = fetch {
    pname       = "python-mock";
    version     = "4.0.2";
    srcs        = [{ filename = "python-mock-4.0.2-1-any.pkg.tar.xz"; sha256 = "5d26d5ae9ecd6ea5208efc521b6a384086cfeb8e0e94f6f3498bc8e06e0da4ab"; }];
    buildInputs = [ python ];
  };

  "python-more-itertools" = fetch {
    pname       = "python-more-itertools";
    version     = "8.2.0";
    srcs        = [{ filename = "python-more-itertools-8.2.0-2-any.pkg.tar.xz"; sha256 = "5a742375437affa667ed6926145c4b2005ad7c1b38ba1e3f76edc2ded7a64085"; }];
    buildInputs = [ python ];
  };

  "python-nose" = fetch {
    pname       = "python-nose";
    version     = "1.3.7";
    srcs        = [{ filename = "python-nose-1.3.7-7-i686.pkg.tar.xz"; sha256 = "39007cc453741eb87cb78d1fce6e10b14ee6494a4b9d64cc8180808e9d3ca010"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-packaging" = fetch {
    pname       = "python-packaging";
    version     = "20.3";
    srcs        = [{ filename = "python-packaging-20.3-2-any.pkg.tar.xz"; sha256 = "4a514c18c7b953204ccde9d51eaae7cf76edab9f6687be614f6511174ba009b8"; }];
    buildInputs = [ python-attrs python-pyparsing python-six ];
  };

  "python-patiencediff" = fetch {
    pname       = "python-patiencediff";
    version     = "0.1.0";
    srcs        = [{ filename = "python-patiencediff-0.1.0-2-i686.pkg.tar.xz"; sha256 = "065f816a4afc587fb542a8abc346b430a50e3810ca5f3bd55247d0323b172184"; }];
    buildInputs = [ python ];
  };

  "python-pbr" = fetch {
    pname       = "python-pbr";
    version     = "5.4.5";
    srcs        = [{ filename = "python-pbr-5.4.5-1-any.pkg.tar.xz"; sha256 = "9861e5d8d9ecc14735030b47f557ebfeb4ca8a8a5f6aa8a470fa1643b1181198"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-pip" = fetch {
    pname       = "python-pip";
    version     = "20.0.2";
    srcs        = [{ filename = "python-pip-20.0.2-2-any.pkg.tar.xz"; sha256 = "b2b52a4ba61714d32e9d67c33bf796ad2d723763157180328caa93e2c4a88067"; }];
    buildInputs = [ python python3-setuptools ];
    broken      = true; # broken dependency python-pip -> python3-setuptools
  };

  "python-pluggy" = fetch {
    pname       = "python-pluggy";
    version     = "0.13.1";
    srcs        = [{ filename = "python-pluggy-0.13.1-2-any.pkg.tar.xz"; sha256 = "9141a6ca8d7a27882bd512db53ca721407d129de2e85ca01d290dfd33e93513e"; }];
    buildInputs = [ python ];
  };

  "python-py" = fetch {
    pname       = "python-py";
    version     = "1.8.1";
    srcs        = [{ filename = "python-py-1.8.1-2-any.pkg.tar.xz"; sha256 = "30f73a1672eeff7dcbd02fcd124c2b8c5d45e2a38e78738a26ab85b14acd7f8c"; }];
    buildInputs = [ python ];
  };

  "python-pyalpm" = fetch {
    pname       = "python-pyalpm";
    version     = "0.9.1";
    srcs        = [{ filename = "python-pyalpm-0.9.1-2-i686.pkg.tar.xz"; sha256 = "a5189b3081da619202f8356f4274be7730cfa6122a60dd47e5af4b4e53b25a38"; }];
    buildInputs = [ python libarchive-devel ];
  };

  "python-pygments" = fetch {
    pname       = "python-pygments";
    version     = "2.6.1";
    srcs        = [{ filename = "python-pygments-2.6.1-2-i686.pkg.tar.xz"; sha256 = "271dab8d51a16db3ec70d5fd33931da14abf6706f92958293c755f4a2fc5112f"; }];
    buildInputs = [ python ];
  };

  "python-pyparsing" = fetch {
    pname       = "python-pyparsing";
    version     = "2.4.7";
    srcs        = [{ filename = "python-pyparsing-2.4.7-1-any.pkg.tar.xz"; sha256 = "04987734af643daf28173b77ed5704b853ce075060d6e5a87f644f82f7765dc8"; }];
    buildInputs = [ python ];
  };

  "python-pytest" = fetch {
    pname       = "python-pytest";
    version     = "5.4.1";
    srcs        = [{ filename = "python-pytest-5.4.1-2-any.pkg.tar.xz"; sha256 = "91dd189fd58e44fc133881e2ee3b29c1b0a908f471b464f1c046e1822f66921b"; }];
    buildInputs = [ python python-atomicwrites python-attrs python-more-itertools python-pluggy python-py python-setuptools python-six ];
  };

  "python-pytest-runner" = fetch {
    pname       = "python-pytest-runner";
    version     = "5.2";
    srcs        = [{ filename = "python-pytest-runner-5.2-2-any.pkg.tar.xz"; sha256 = "0eec3f0b12c15fb282440e55172b499bfb0e377069e802c70ba6b2647f954886"; }];
    buildInputs = [ python-pytest ];
  };

  "python-setuptools" = fetch {
    pname       = "python-setuptools";
    version     = "46.1.3";
    srcs        = [{ filename = "python-setuptools-46.1.3-1-any.pkg.tar.xz"; sha256 = "8db0f8cf1f4020806db6d7ccc9c1b10da82b7e8d64ec5803e43e29678b92539e"; }];
    buildInputs = [ python ];
  };

  "python-setuptools-scm" = fetch {
    pname       = "python-setuptools-scm";
    version     = "3.5.0";
    srcs        = [{ filename = "python-setuptools-scm-3.5.0-2-any.pkg.tar.xz"; sha256 = "cc9abeb6c98df6b0d8b029d9a03dbf7adc5a3340423bc4e5b838f49b309d330b"; }];
    buildInputs = [ python ];
  };

  "python-six" = fetch {
    pname       = "python-six";
    version     = "1.14.0";
    srcs        = [{ filename = "python-six-1.14.0-2-any.pkg.tar.xz"; sha256 = "3ec75f2eb6ec59f8ac51b5ce300afff1723fa435ef2ec93eefa773c9affa4fda"; }];
    buildInputs = [ python ];
  };

  "python2" = fetch {
    pname       = "python2";
    version     = "2.7.18";
    srcs        = [{ filename = "python2-2.7.18-1-i686.pkg.tar.xz"; sha256 = "aea35a9c3c49963c8ac3ef6b584cbb9869ef6c331f95bae897830fb125cd9500"; }];
    buildInputs = [ gdbm libbz2 libopenssl zlib libexpat libsqlite libffi ncurses libreadline ];
  };

  "python2-pip" = fetch {
    pname       = "python2-pip";
    version     = "20.0.2";
    srcs        = [{ filename = "python2-pip-20.0.2-1-any.pkg.tar.xz"; sha256 = "b9c85d61dff96984c850032afe551db7d4b68eda868c04283e13f0afdf65ad14"; }];
    buildInputs = [ python2 python2-setuptools ];
  };

  "python2-setuptools" = fetch {
    pname       = "python2-setuptools";
    version     = "44.1.0";
    srcs        = [{ filename = "python2-setuptools-44.1.0-1-any.pkg.tar.xz"; sha256 = "fe15fca0d868c3c8cb348a8b3e0cfcac6c62f1a069d46a073d10e5c2bc91f696"; }];
    buildInputs = [ python2 ];
  };

  "quilt" = fetch {
    pname       = "quilt";
    version     = "0.66";
    srcs        = [{ filename = "quilt-0.66-2-any.pkg.tar.xz"; sha256 = "8699a7ec2960a51c0005863dc85b5937d1d48153a8958c22430d6e4f46c1fee1"; }];
    buildInputs = [ bash bzip2 diffstat diffutils findutils gawk gettext gzip patch perl ];
  };

  "rarian" = fetch {
    pname       = "rarian";
    version     = "0.8.1";
    srcs        = [{ filename = "rarian-0.8.1-2-i686.pkg.tar.xz"; sha256 = "11912e59b917a45c24109630d0fe19a0f7404ce1d4a9443fc61e219a599ac9ba"; }];
    buildInputs = [ gcc-libs ];
  };

  "rcs" = fetch {
    pname       = "rcs";
    version     = "5.9.4";
    srcs        = [{ filename = "rcs-5.9.4-2-i686.pkg.tar.xz"; sha256 = "697272548cbbff1afe2e14aa9166b29aa49eae6e2d8c1712100d4226d4a3e8e5"; }];
  };

  "re2c" = fetch {
    pname       = "re2c";
    version     = "1.3";
    srcs        = [{ filename = "re2c-1.3-1-i686.pkg.tar.xz"; sha256 = "401bc57efb521bca7c6da84c14f1b93f3686bb747223faa14abdae69e51debce"; }];
    buildInputs = [ gcc-libs ];
  };

  "rebase" = fetch {
    pname       = "rebase";
    version     = "4.4.4";
    srcs        = [{ filename = "rebase-4.4.4-1-i686.pkg.tar.xz"; sha256 = "5cf438a984b1db820d753d597224222aacb35cc14fd565f7053635b3e6c16c8b"; }];
    buildInputs = [ msys2-runtime dash ];
    broken      = true; # broken dependency dash -> msys2-base
  };

  "reflex" = fetch {
    pname       = "reflex";
    version     = "20191123";
    srcs        = [{ filename = "reflex-20191123-1-i686.pkg.tar.xz"; sha256 = "12c03cf3fbabecda9a360bea91f04212c585e7c1f9b30f7739894340addbad24"; }];
  };

  "remake-git" = fetch {
    pname       = "remake-git";
    version     = "4.1.2957.e3e34dd9";
    srcs        = [{ filename = "remake-git-4.1.2957.e3e34dd9-1-i686.pkg.tar.xz"; sha256 = "77264d36b7414e2089737f6f4e1e2be5bb4c432e0f6a5359fbdc3d744486541b"; }];
    buildInputs = [ guile libreadline ];
  };

  "rhash" = fetch {
    pname       = "rhash";
    version     = "1.3.9";
    srcs        = [{ filename = "rhash-1.3.9-1-i686.pkg.tar.xz"; sha256 = "23cf077ec1aea536aca9c6e9454d098601d1026fcf4c437a8fd2e172175ed98b"; }];
    buildInputs = [ (assert librhash.version=="1.3.9"; librhash) ];
  };

  "rlwrap" = fetch {
    pname       = "rlwrap";
    version     = "0.43";
    srcs        = [{ filename = "rlwrap-0.43-0-i686.pkg.tar.xz"; sha256 = "016ca0ddd5293c2f7b5c59203d1fe55beeb92356ee7f6675d3c93651cb11e569"; }];
    buildInputs = [ libreadline ];
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
    version     = "2.7.1";
    srcs        = [{ filename = "ruby-2.7.1-1-i686.pkg.tar.xz"; sha256 = "51139628d3079f277a58a829acb291655ca57fcc6db5d1bafe2a12ee29e99366"; }];
    buildInputs = [ gcc-libs libopenssl libffi libcrypt gmp libyaml libgdbm libiconv libreadline zlib ];
  };

  "ruby-docs" = fetch {
    pname       = "ruby-docs";
    version     = "2.7.1";
    srcs        = [{ filename = "ruby-docs-2.7.1-1-i686.pkg.tar.xz"; sha256 = "998d39373e1f9ae52fab1c41209833979c743fa9c5a0802d6c347ee187e0dee4"; }];
  };

  "scons" = fetch {
    pname       = "scons";
    version     = "3.1.2";
    srcs        = [{ filename = "scons-3.1.2-4-any.pkg.tar.xz"; sha256 = "83e23284cda787f38ff8ef7975397dd28d5ccd51cb745f014508174e58c48673"; }];
    buildInputs = [ python ];
  };

  "screenfetch" = fetch {
    pname       = "screenfetch";
    version     = "3.9.1";
    srcs        = [{ filename = "screenfetch-3.9.1-1-any.pkg.tar.xz"; sha256 = "6ef8e555b2d4fb252e2c63fb06f40e157f3802fc1ae907bcc3faddb5244bfe6b"; }];
    buildInputs = [ bash ];
  };

  "sed" = fetch {
    pname       = "sed";
    version     = "4.8";
    srcs        = [{ filename = "sed-4.8-1-i686.pkg.tar.xz"; sha256 = "08ca10d6ad4e9dadd930d2dd78685d418d81f4623cb97fe5229f3873135fe3fe"; }];
    buildInputs = [ libintl sh ];
  };

  "setconf" = fetch {
    pname       = "setconf";
    version     = "0.7.6";
    srcs        = [{ filename = "setconf-0.7.6-2-any.pkg.tar.xz"; sha256 = "dac49b6e46e90794a1b242ecfab592d224460dfd26f4960352b7376d7480a0c1"; }];
    buildInputs = [ python3 ];
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
    version     = "1.7.3.4";
    srcs        = [{ filename = "socat-1.7.3.4-1-i686.pkg.tar.xz"; sha256 = "84fb5886dcb276e7fffd4ac74b41224e909a3d6f5cddeb719fcd9644a08db58f"; }];
    buildInputs = [ libreadline openssl ];
  };

  "sqlite" = fetch {
    pname       = "sqlite";
    version     = "3.30.0";
    srcs        = [{ filename = "sqlite-3.30.0-1-i686.pkg.tar.xz"; sha256 = "a8f022a98724b89ff9382ea28dc53166bf828e12e3a0435cbf99e2d075a5a934"; }];
    buildInputs = [ libreadline libsqlite ];
  };

  "sqlite-compress" = fetch {
    pname       = "sqlite-compress";
    version     = "3.30.0";
    srcs        = [{ filename = "sqlite-compress-3.30.0-1-i686.pkg.tar.xz"; sha256 = "6508980b181b5f1ee3e205b75d3b7e55332a54fb94a4e6eb4d0fed9ef6767f4c"; }];
    buildInputs = [ (assert libsqlite.version=="3.30.0"; libsqlite) zlib ];
  };

  "sqlite-doc" = fetch {
    pname       = "sqlite-doc";
    version     = "3.30.0";
    srcs        = [{ filename = "sqlite-doc-3.30.0-1-i686.pkg.tar.xz"; sha256 = "f1d586d7a55a6dfbd9e451d5321aa5343f00888c18c1d93be366b69546c5334c"; }];
    buildInputs = [ (assert sqlite.version=="3.30.0"; sqlite) ];
  };

  "sqlite-extensions" = fetch {
    pname       = "sqlite-extensions";
    version     = "3.30.0";
    srcs        = [{ filename = "sqlite-extensions-3.30.0-1-i686.pkg.tar.xz"; sha256 = "011f6e128695a98f6fcc863a73636a42fe6e2a8903aae3634e7eb51dddfb8c0f"; }];
    buildInputs = [ (assert libsqlite.version=="3.30.0"; libsqlite) ];
  };

  "sqlite-icu" = fetch {
    pname       = "sqlite-icu";
    version     = "3.30.0";
    srcs        = [{ filename = "sqlite-icu-3.30.0-1-i686.pkg.tar.xz"; sha256 = "cacdd23ac9995a763e0b68ecf32ad9cc23171518b3a3b2aeadc76e04197775e3"; }];
    buildInputs = [ (assert libsqlite.version=="3.30.0"; libsqlite) icu ];
  };

  "sqlite-rbu" = fetch {
    pname       = "sqlite-rbu";
    version     = "3.30.0";
    srcs        = [{ filename = "sqlite-rbu-3.30.0-1-i686.pkg.tar.xz"; sha256 = "7b8ca0f96af723ee295b5c4b0c033bf371e4fd50bff8816273b3c42f47950be9"; }];
    buildInputs = [ (assert libsqlite.version=="3.30.0"; libsqlite) ];
  };

  "sqlite-vfslog" = fetch {
    pname       = "sqlite-vfslog";
    version     = "3.30.0";
    srcs        = [{ filename = "sqlite-vfslog-3.30.0-1-i686.pkg.tar.xz"; sha256 = "0033835c8fd966e4ba39ec843cc29262fb2ac9b524aa713cfcfde0b51fe3d687"; }];
    buildInputs = [ (assert libsqlite.version=="3.30.0"; libsqlite) ];
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
    version     = "1.12.2";
    srcs        = [{ filename = "subversion-1.12.2-1-i686.pkg.tar.xz"; sha256 = "aab45909fcfeeda2db62eb8adb4167e762979789367a6cd48a23ee3032a2498f"; }];
    buildInputs = [ libsqlite file liblz4 libserf libsasl ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "swig" = fetch {
    pname       = "swig";
    version     = "4.0.1";
    srcs        = [{ filename = "swig-4.0.1-1-i686.pkg.tar.xz"; sha256 = "a4ff0bc41eb54448f3fc29f8182c152bb0743a12af6ea8c0a2960f2309c2e65e"; }];
    buildInputs = [ zlib libpcre ];
  };

  "tar" = fetch {
    pname       = "tar";
    version     = "1.32";
    srcs        = [{ filename = "tar-1.32-1-i686.pkg.tar.xz"; sha256 = "174debb47ac872c0c68fa43dba541a84924bb3ac2e4013d43d8d1faf9b6c9098"; }];
    buildInputs = [ msys2-runtime libiconv libintl sh ];
  };

  "task" = fetch {
    pname       = "task";
    version     = "2.5.1";
    srcs        = [{ filename = "task-2.5.1-3-i686.pkg.tar.xz"; sha256 = "d4616e57f4920979365ed7ac8ce3fb1af66d7d1ee9c402514d536da73941cba4"; }];
    buildInputs = [ gcc-libs libgnutls libutil-linux libhogweed ];
  };

  "tcl" = fetch {
    pname       = "tcl";
    version     = "8.6.10";
    srcs        = [{ filename = "tcl-8.6.10-1-i686.pkg.tar.xz"; sha256 = "15a90f8789501111808f2cae34b2bb063b330e794391c38539c660b17ea20284"; }];
    buildInputs = [ zlib ];
  };

  "tcl-sqlite" = fetch {
    pname       = "tcl-sqlite";
    version     = "3.30.0";
    srcs        = [{ filename = "tcl-sqlite-3.30.0-1-i686.pkg.tar.xz"; sha256 = "2d26bca0c3270e500c2cfee267fb80aad528b9e44deed5df223e425a1ee5b38a"; }];
    buildInputs = [ (assert libsqlite.version=="3.30.0"; libsqlite) tcl ];
  };

  "tcsh" = fetch {
    pname       = "tcsh";
    version     = "6.22.02";
    srcs        = [{ filename = "tcsh-6.22.02-1-i686.pkg.tar.xz"; sha256 = "cfa8af00b3ae78933f154a225b5185dd3fd25d9aeb8e8831979537769358dc64"; }];
    buildInputs = [ gcc-libs libcrypt libiconv ncurses ];
  };

  "termbox" = fetch {
    pname       = "termbox";
    version     = "1.1.0";
    srcs        = [{ filename = "termbox-1.1.0-2-i686.pkg.tar.xz"; sha256 = "3751de1d4c1ba21a72af7e934ecac530d944d0fdb8cd74f96142cf6b32cf7630"; }];
  };

  "texinfo" = fetch {
    pname       = "texinfo";
    version     = "6.7";
    srcs        = [{ filename = "texinfo-6.7-1-i686.pkg.tar.xz"; sha256 = "cc771867aa32f50ededf2921e02acf15c06f5730f4e752e69543abd9c25e10be"; }];
    buildInputs = [ info perl sh ];
  };

  "texinfo-tex" = fetch {
    pname       = "texinfo-tex";
    version     = "6.7";
    srcs        = [{ filename = "texinfo-tex-6.7-1-i686.pkg.tar.xz"; sha256 = "637fc578b2c4a2d70f2ff8cd72346dbea2518b201d8cba47820a9ac7d14af58f"; }];
    buildInputs = [ gawk perl sh ];
  };

  "tftp-hpa" = fetch {
    pname       = "tftp-hpa";
    version     = "5.2";
    srcs        = [{ filename = "tftp-hpa-5.2-3-i686.pkg.tar.xz"; sha256 = "8d4ad883823551d6789d3ed2140a0b21574e490b45dc11f91679d29dfeec27e6"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libreadline.version "6.0.00"; libreadline) ];
  };

  "tig" = fetch {
    pname       = "tig";
    version     = "2.5.1";
    srcs        = [{ filename = "tig-2.5.1-1-i686.pkg.tar.xz"; sha256 = "793284c049d86f374e6d414ebc5edd34869d514a03e27ef0feb81c5650806344"; }];
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
    version     = "3.1";
    srcs        = [{ filename = "tmux-3.1-1-i686.pkg.tar.zst"; sha256 = "d476f7ffc219c5765a0a3cabccc75570d6ea750447d12b48b8a6b7d573d0d8f0"; }];
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
    version     = "3.7";
    srcs        = [{ filename = "txt2tags-3.7-1-any.pkg.tar.xz"; sha256 = "c1551329ec3237c168d9fad422b32373526d715558dd032a2f9d175776f2ecd0"; }];
    buildInputs = [ python ];
  };

  "tzcode" = fetch {
    pname       = "tzcode";
    version     = "2020a";
    srcs        = [{ filename = "tzcode-2020a-1-i686.pkg.tar.zst"; sha256 = "bbc363b6c66054860edacc9b0807a6e9e554255fee43be9077bcd6aa1998af35"; }];
    buildInputs = [ coreutils gawk sed ];
  };

  "u-boot-tools" = fetch {
    pname       = "u-boot-tools";
    version     = "2020.04";
    srcs        = [{ filename = "u-boot-tools-2020.04-2-i686.pkg.tar.zst"; sha256 = "5a4ea9d30ff5a6d7572742a12430e227e53f67a0faae96d8e41ec5a0b38e1efa"; }];
    buildInputs = [ dtc openssl ];
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
    version     = "5.9.2";
    srcs        = [{ filename = "unrar-5.9.2-1-i686.pkg.tar.xz"; sha256 = "6629ac803c25e1eb23ad12f2a62ab15ab91ed22a641bc6cfcda55523e09e7e67"; }];
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
    version     = "3.96";
    srcs        = [{ filename = "upx-3.96-1-i686.pkg.tar.xz"; sha256 = "1166d29aadd05694b8824f692b17d27380657b7e82aff9141d48ff26ce48df27"; }];
    buildInputs = [ ucl zlib ];
  };

  "util-linux" = fetch {
    pname       = "util-linux";
    version     = "2.35.1";
    srcs        = [{ filename = "util-linux-2.35.1-1-i686.pkg.tar.xz"; sha256 = "6ca2268b55254d30877e2fc6514fb1a65c49a4de8124aa9f58a021edfa7dbb85"; }];
    buildInputs = [ coreutils libutil-linux libiconv ];
  };

  "util-macros" = fetch {
    pname       = "util-macros";
    version     = "1.19.2";
    srcs        = [{ filename = "util-macros-1.19.2-1-any.pkg.tar.xz"; sha256 = "36b254ee51d554ae45e6e9fe015839b6c0c0f13976f993384727b66ecf35a36f"; }];
  };

  "vifm" = fetch {
    pname       = "vifm";
    version     = "0.10.1";
    srcs        = [{ filename = "vifm-0.10.1-1-i686.pkg.tar.xz"; sha256 = "2e16d9d76060fada6c875d76f47bf0369b2bb72a31c7ed0512bc0b2097b0b7f5"; }];
    buildInputs = [ ncurses ];
  };

  "vim" = fetch {
    pname       = "vim";
    version     = "8.2.0592";
    srcs        = [{ filename = "vim-8.2.0592-1-i686.pkg.tar.xz"; sha256 = "d81cc4c73160ff5cd87f395f9590a55190399f7d27cbdf62f47489d404db5255"; }];
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
    version     = "6.0.3";
    srcs        = [{ filename = "wcd-6.0.3-1-i686.pkg.tar.xz"; sha256 = "ae4b47fc7090f82d49450108ceee0fb8ffa5540a95a6ad167595ec023039f3d2"; }];
    buildInputs = [ libintl libunistring ncurses ];
  };

  "wget" = fetch {
    pname       = "wget";
    version     = "1.20.3";
    srcs        = [{ filename = "wget-1.20.3-1-i686.pkg.tar.xz"; sha256 = "da86b76e9207b14a07bc27dabb31e99cdc0a014c9c3cc27c384d27eb4e2d8aef"; }];
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
    version     = "5.5.6";
    srcs        = [{ filename = "whois-5.5.6-1-i686.pkg.tar.xz"; sha256 = "0d8df411ba5d63bcf82969ddf57696149c653671715b936317fad6b4d1f94317"; }];
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
    version     = "1.5.0";
    srcs        = [{ filename = "xorriso-1.5.0-1-i686.pkg.tar.xz"; sha256 = "d4a1bc01827c69487040386b2f68215e468ce4d49457f15bfed915dad47f7e0b"; }];
    buildInputs = [ libbz2 libreadline zlib ];
  };

  "xproto" = fetch {
    pname       = "xproto";
    version     = "7.0.26";
    srcs        = [{ filename = "xproto-7.0.26-1-any.pkg.tar.xz"; sha256 = "2bf0c8e239bf25ca15f92bd7a515318be669c2cb9041b37c0f17752887a23d90"; }];
  };

  "xz" = fetch {
    pname       = "xz";
    version     = "5.2.5";
    srcs        = [{ filename = "xz-5.2.5-1-i686.pkg.tar.xz"; sha256 = "e34fb735ca95f58aca31265130ed7d2b4ee394050ff00cbb906f63b7089c8ef6"; }];
    buildInputs = [ (assert liblzma.version=="5.2.5"; liblzma) libiconv libintl ];
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
    version     = "3.32.2";
    srcs        = [{ filename = "yelp-tools-3.32.2-2-any.pkg.tar.xz"; sha256 = "c5193579fe62a5974b6e271e228112d9bf902f93183d50d4a843b93be7611165"; }];
    buildInputs = [ yelp-xsl itstool libxml2-python ];
  };

  "yelp-xsl" = fetch {
    pname       = "yelp-xsl";
    version     = "3.36.0";
    srcs        = [{ filename = "yelp-xsl-3.36.0-2-any.pkg.tar.xz"; sha256 = "37a26099e231319f2654e6b12321359300c98a045c0df599e6cbf8a9c08749f6"; }];
    buildInputs = [  ];
  };

  "yodl" = fetch {
    pname       = "yodl";
    version     = "4.02.02";
    srcs        = [{ filename = "yodl-4.02.02-1-i686.pkg.tar.xz"; sha256 = "719d4f1fd2337f57a82394a4f7fe8ba1347749b44c2745cce953b05c041923c4"; }];
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
    version     = "r5233.efe64008";
    srcs        = [{ filename = "znc-git-r5233.efe64008-1-i686.pkg.tar.zst"; sha256 = "e8852386242856fbd5058d857e4e1dbbb9e9609af43005a5ebaed60fbe83b328"; }];
    buildInputs = [ openssl icu ];
  };

  "zsh" = fetch {
    pname       = "zsh";
    version     = "5.8";
    srcs        = [{ filename = "zsh-5.8-3-i686.pkg.tar.xz"; sha256 = "eeec9d5d5f2787d327d6cabe5bf3e37e074de967119a913ca5d61449302071b5"; }];
    buildInputs = [ ncurses pcre libiconv gdbm ];
  };

  "zsh-doc" = fetch {
    pname       = "zsh-doc";
    version     = "5.8";
    srcs        = [{ filename = "zsh-doc-5.8-3-i686.pkg.tar.xz"; sha256 = "c4935495041e8d0d2cffb681edef1fdf6131d2d151a896b18bf08e27024deced"; }];
  };

  "zstd" = fetch {
    pname       = "zstd";
    version     = "1.4.4";
    srcs        = [{ filename = "zstd-1.4.4-2-i686.pkg.tar.xz"; sha256 = "fe55332a4614802ed8570c36c7c4a7bb357ae9c578e770113d3ccef12d87ff7a"; }];
    buildInputs = [ gcc-libs libzstd ];
  };

}; in self
