 # GENERATED FILE
{stdenvNoCC, fetchurl, mingwPacman, msysPacman}:

let
  fetch = { pname, version, sources, buildInputs ? [], broken ? false }:
    if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
      stdenvNoCC.mkDerivation rec {
        inherit version buildInputs;
        name = "msys32-${pname}-${version}";
        srcs = map ({filename, sha256}:
                    fetchurl {
                      url = "http://repo.msys2.org/msys/i686/${filename}";
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
                      url = "http://repo.msys2.org/msys/i686/${filename}";
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
               stdenvNoCC.lib.optionalString (!(builtins.elem "msys/${pname}" ["msys/msys2-runtime" "msys/bash" "msys/coreutils" "msys/gmp" "msys/gcc-libs" "msys/libiconv" "msys/libintl" "msys/libiconv+libintl"])) ''
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

  "ansible" = fetch {
    pname       = "ansible";
    version     = "2.9.11";
    sources     = [{ filename = "ansible-2.9.11-1-x86_64.pkg.tar.zst"; sha256 = "d4cea6bbf1bc433025f8cf1b9b752e4b6c99f37f2b452dfa323711c451aa5d26"; }];
    buildInputs = [ python python-yaml python-jinja ];
  };

  "apr" = fetch {
    pname       = "apr";
    version     = "1.7.0";
    sources     = [{ filename = "apr-1.7.0-1-x86_64.pkg.tar.xz"; sha256 = "df2db34d822e3730ac8366dac01bd513a5f4bbc8739ebd43f48d528c9fa57b3f"; }];
    buildInputs = [ libcrypt libuuid ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "apr-devel" = fetch {
    pname       = "apr-devel";
    version     = "1.7.0";
    sources     = [{ filename = "apr-devel-1.7.0-1-x86_64.pkg.tar.xz"; sha256 = "52c3cbc13aaeb9346f06a5f38e279229e110e026d29ca4cc357ab0a86333b64b"; }];
    buildInputs = [ (assert apr.version=="1.7.0"; apr) libcrypt-devel libuuid-devel ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "apr-util" = fetch {
    pname       = "apr-util";
    version     = "1.6.1";
    sources     = [{ filename = "apr-util-1.6.1-1-x86_64.pkg.tar.xz"; sha256 = "6ffe865abff6d79c954c620a44a5ec570d05131279a05302c5142946220deef2"; }];
    buildInputs = [ apr expat libsqlite ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "apr-util-devel" = fetch {
    pname       = "apr-util-devel";
    version     = "1.6.1";
    sources     = [{ filename = "apr-util-devel-1.6.1-1-x86_64.pkg.tar.xz"; sha256 = "a6bda4a4a8d79d53d79a270dd5dd5f81a837844c3a2fc185664f72a7ffb86964"; }];
    buildInputs = [ (assert apr-util.version=="1.6.1"; apr-util) apr-devel libexpat-devel libsqlite-devel ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "asciidoc" = fetch {
    pname       = "asciidoc";
    version     = "9.0.1";
    sources     = [{ filename = "asciidoc-9.0.1-1-any.pkg.tar.zst"; sha256 = "87bc32d95ef18e400dbb90d406d8a47b49f907937477b1e73ff3943e065f152f"; }];
    buildInputs = [ python libxslt docbook-xsl ];
  };

  "aspell" = fetch {
    pname       = "aspell";
    version     = "0.60.8";
    sources     = [{ filename = "aspell-0.60.8-1-x86_64.pkg.tar.xz"; sha256 = "ce9c6ef554000686b832f93302d6850937afeb62a2c595c74207231f3aad6082"; }];
    buildInputs = [ gcc-libs gettext libiconv ncurses ];
  };

  "aspell-devel" = fetch {
    pname       = "aspell-devel";
    version     = "0.60.8";
    sources     = [{ filename = "aspell-devel-0.60.8-1-x86_64.pkg.tar.xz"; sha256 = "a03562fff76cd865ce6c8fcbc98c7b8200a37078f3e2852a64e008e8e1e67877"; }];
    buildInputs = [ (assert aspell.version=="0.60.8"; aspell) gettext-devel libiconv-devel ncurses-devel ];
  };

  "aspell6-en" = fetch {
    pname       = "aspell6-en";
    version     = "2019.10.06";
    sources     = [{ filename = "aspell6-en-2019.10.06-1-x86_64.pkg.tar.xz"; sha256 = "4cc0a1c67fceaf50af849bc4f1ab68fc55e4bc7d485b37ec1aaa38370a1a63f5"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast aspell.version "0.60"; aspell) ];
  };

  "atool" = fetch {
    pname       = "atool";
    version     = "0.39.0";
    sources     = [{ filename = "atool-0.39.0-1-any.pkg.tar.xz"; sha256 = "1b3a8d8b402d356d9e1690959aa10523944271c660476f6af20e9ccf59c0a5a5"; }];
    buildInputs = [ file perl ];
  };

  "autoconf" = fetch {
    pname       = "autoconf";
    version     = "2.69";
    sources     = [{ filename = "autoconf-2.69-5-any.pkg.tar.xz"; sha256 = "aaf1390524fa573a7f210e12203f0fcdb550028fb33badeb6e67d56ae57abbbb"; }];
    buildInputs = [ awk m4 diffutils bash perl ];
  };

  "autoconf-archive" = fetch {
    pname       = "autoconf-archive";
    version     = "2019.01.06";
    sources     = [{ filename = "autoconf-archive-2019.01.06-1-any.pkg.tar.xz"; sha256 = "70c479a5c3a6dc3406457ba212eb640af0474970458169cfb7c2d89f91a8d141"; }];
  };

  "autoconf2.13" = fetch {
    pname       = "autoconf2.13";
    version     = "2.13";
    sources     = [{ filename = "autoconf2.13-2.13-2-any.pkg.tar.xz"; sha256 = "99abc626148147ceb79ec99e374d9c5c2e7e54df2234043bf6b5b715206a6983"; }];
    buildInputs = [ awk m4 diffutils bash ];
  };

  "autogen" = fetch {
    pname       = "autogen";
    version     = "5.18.16";
    sources     = [{ filename = "autogen-5.18.16-1-x86_64.pkg.tar.xz"; sha256 = "bbef2ab6b6c831bc79a36f5dd571534b62a14c16f29e32c615cc39a237ab085a"; }];
    buildInputs = [ gcc-libs gmp libcrypt libffi libgc libguile libxml2 ];
  };

  "automake-wrapper" = fetch {
    pname       = "automake-wrapper";
    version     = "11";
    sources     = [{ filename = "automake-wrapper-11-1-any.pkg.tar.xz"; sha256 = "fc95a33b5ca011a01209ec6a6e3f58cced6ff074bdf8fa2ac627669ecaaefeb7"; }];
    buildInputs = [ bash gawk self."automake1.6" self."automake1.7" self."automake1.7" self."automake1.8" self."automake1.9" self."automake1.10" self."automake1.11" self."automake1.12" self."automake1.13" self."automake1.14" self."automake1.15" self."automake1.16" ];
  };

  "automake1.10" = fetch {
    pname       = "automake1.10";
    version     = "1.10.3";
    sources     = [{ filename = "automake1.10-1.10.3-4-any.pkg.tar.zst"; sha256 = "d927b9e9fd538f493fcc88a7f970694c55b4dc8e2cf95ba09d740725346eb686"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.11" = fetch {
    pname       = "automake1.11";
    version     = "1.11.6";
    sources     = [{ filename = "automake1.11-1.11.6-4-any.pkg.tar.zst"; sha256 = "a05362be2eb895e7e20290be66b593b1a1bfdf8f40615f0bd8efa21a867dd7d0"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.12" = fetch {
    pname       = "automake1.12";
    version     = "1.12.6";
    sources     = [{ filename = "automake1.12-1.12.6-4-any.pkg.tar.zst"; sha256 = "28a6868b8c775e10208dc651d8b7f72efc3b0291a2f4cfe05c583778bc68e63b"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.13" = fetch {
    pname       = "automake1.13";
    version     = "1.13.4";
    sources     = [{ filename = "automake1.13-1.13.4-5-any.pkg.tar.zst"; sha256 = "816ea174da210a0996d8ad2a70f6380608102c3aca39b3090872e20a515c4cb8"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.14" = fetch {
    pname       = "automake1.14";
    version     = "1.14.1";
    sources     = [{ filename = "automake1.14-1.14.1-4-any.pkg.tar.zst"; sha256 = "56e03a71c30a969d3463cc6eafd4b01c57059d591ff3e80c860479ebedcfee27"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.15" = fetch {
    pname       = "automake1.15";
    version     = "1.15.1";
    sources     = [{ filename = "automake1.15-1.15.1-2-any.pkg.tar.zst"; sha256 = "64b13787f1327c1273a0d55d6b968943c9f2ba09781df9cabd3f450119feefad"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.16" = fetch {
    pname       = "automake1.16";
    version     = "1.16.2";
    sources     = [{ filename = "automake1.16-1.16.2-2-any.pkg.tar.zst"; sha256 = "02d5a99ad43bb1340cada9dffc16774eef05c95187a8d980f1a92ecc53fb0aeb"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.6" = fetch {
    pname       = "automake1.6";
    version     = "1.6.3";
    sources     = [{ filename = "automake1.6-1.6.3-3-any.pkg.tar.zst"; sha256 = "a018c86be71d5776b8e984c700895e375af5f2d526581d13f868e5f9ca966689"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.7" = fetch {
    pname       = "automake1.7";
    version     = "1.7.9";
    sources     = [{ filename = "automake1.7-1.7.9-3-any.pkg.tar.zst"; sha256 = "345993cdcbab02e12c8656fab902347e757d0d29250fa30571e2e0799a19d6cc"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.8" = fetch {
    pname       = "automake1.8";
    version     = "1.8.5";
    sources     = [{ filename = "automake1.8-1.8.5-4-any.pkg.tar.zst"; sha256 = "1dd7f35902e6c0bb3d42588257de301f2a849e0a423de0d2255ac98a5ca20c14"; }];
    buildInputs = [ perl bash ];
  };

  "automake1.9" = fetch {
    pname       = "automake1.9";
    version     = "1.9.6";
    sources     = [{ filename = "automake1.9-1.9.6-3-any.pkg.tar.zst"; sha256 = "ab819478ba057ddc870922660a5c3dd4597366e8d0c7c857d727ca7e912d0b58"; }];
    buildInputs = [ perl bash ];
  };

  "axel" = fetch {
    pname       = "axel";
    version     = "2.17.9";
    sources     = [{ filename = "axel-2.17.9-1-x86_64.pkg.tar.zst"; sha256 = "c01ddc45afe2c1758d3e9e069284e52804f1479592663cbbc8edadc8553149f9"; }];
    buildInputs = [ openssl gettext ];
  };

  "base" = fetch {
    pname       = "base";
    version     = "2020.05";
    sources     = [{ filename = "base-2020.05-2-any.pkg.tar.zst"; sha256 = "aefa48ee2c60f5352bbc4129273af174bacee1dd9a2043cfef03a49cdfecadf0"; }];
    buildInputs = [ bash bash-completion bsdtar bzip2 coreutils curl dash file filesystem findutils gawk getent grep gzip inetutils info less mintty msys2-keyring msys2-launcher msys2-runtime pacman pacman-contrib pacman-mirrors rebase sed time tzcode util-linux wget which zstd ];
    broken      = true; # broken dependency wget -> libuuid
  };

  "bash" = fetch {
    pname       = "bash";
    version     = "4.4.023";
    sources     = [{ filename = "bash-4.4.023-2-x86_64.pkg.tar.xz"; sha256 = "ed17af38e37e0790b467b9887b98bdfb4c711279d067a34b440cdb583ebc12ea"; }];
    buildInputs = [ msys2-runtime ];
  };

  "bash-completion" = fetch {
    pname       = "bash-completion";
    version     = "2.10";
    sources     = [{ filename = "bash-completion-2.10-1-any.pkg.tar.xz"; sha256 = "0f6376adf7ba79a1c444bb4126b88ed5c4cf563299a598d5217fc9dd30f4bcf8"; }];
    buildInputs = [ bash ];
  };

  "bash-devel" = fetch {
    pname       = "bash-devel";
    version     = "4.4.023";
    sources     = [{ filename = "bash-devel-4.4.023-2-x86_64.pkg.tar.xz"; sha256 = "eb9d9365191f0a484f398cd01e4658ef0daf7739a75618a5cb5d703cb4cbd0da"; }];
  };

  "bc" = fetch {
    pname       = "bc";
    version     = "1.07.1";
    sources     = [{ filename = "bc-1.07.1-2-x86_64.pkg.tar.xz"; sha256 = "0d37fa1d71f9725f6c8de8f682443c93c460f1aaaea32f17fbdd5ae3e81c33d7"; }];
    buildInputs = [ libreadline ncurses ];
  };

  "binutils" = fetch {
    pname       = "binutils";
    version     = "2.35";
    sources     = [{ filename = "binutils-2.35-1-x86_64.pkg.tar.zst"; sha256 = "b03d3bdb939e6bac3b0b948b627ec105eeec75fae15407b6ab3acfedb895b1f0"; }];
    buildInputs = [ libiconv libintl zlib ];
  };

  "bison" = fetch {
    pname       = "bison";
    version     = "3.6.4";
    sources     = [{ filename = "bison-3.6.4-1-x86_64.pkg.tar.zst"; sha256 = "c834531da0c808894b0ff4f62ee44fc33c8d47270a7ff3f45416c640c916cdfe"; }];
    buildInputs = [ m4 sh ];
  };

  "bisonc++" = fetch {
    pname       = "bisonc++";
    version     = "6.04.00";
    sources     = [{ filename = "bisonc++-6.04.00-1-x86_64.pkg.tar.xz"; sha256 = "ee34613ff5790d6ca6f2cccf9e0252709662ecaa3fa6c77b1e3f60628938927b"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libbobcat.version "4.02.00"; libbobcat) ];
  };

  "breezy" = fetch {
    pname       = "breezy";
    version     = "3.1.0.4";
    sources     = [{ filename = "breezy-3.1.0.4-2-x86_64.pkg.tar.zst"; sha256 = "5feae75d38c8662c800552533855f91e2b558fb2e6d0f3502b66452fb76c75eb"; }];
    buildInputs = [ python-configobj python-fastimport python-dulwich python-patiencediff python-six ];
  };

  "brotli" = fetch {
    pname       = "brotli";
    version     = "1.0.7";
    sources     = [{ filename = "brotli-1.0.7-4-x86_64.pkg.tar.zst"; sha256 = "68d3f2b6974f4d747cce16ef91b5ba249a2aa089e598b5031deace992274634a"; }];
    buildInputs = [ gcc-libs ];
  };

  "brotli-devel" = fetch {
    pname       = "brotli-devel";
    version     = "1.0.7";
    sources     = [{ filename = "brotli-devel-1.0.7-4-x86_64.pkg.tar.zst"; sha256 = "ddec172034a3f7204c12161de85c96af923e869f5488b1c3987110245f7d1958"; }];
    buildInputs = [ brotli ];
  };

  "brotli-testdata" = fetch {
    pname       = "brotli-testdata";
    version     = "1.0.7";
    sources     = [{ filename = "brotli-testdata-1.0.7-4-x86_64.pkg.tar.zst"; sha256 = "53c2967f4ef8bd3c7de2b397edc0f278e7919df39269f07bf50e8ccd8ef848df"; }];
  };

  "bsdcpio" = fetch {
    pname       = "bsdcpio";
    version     = "3.4.3";
    sources     = [{ filename = "bsdcpio-3.4.3-1-x86_64.pkg.tar.zst"; sha256 = "4022eee8722f863a3b62f9a2ad8eb5fc02c87c99549e8a9ecff16aed41ec6890"; }];
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 libnettle libxml2 libzstd zlib ];
  };

  "bsdtar" = fetch {
    pname       = "bsdtar";
    version     = "3.4.3";
    sources     = [{ filename = "bsdtar-3.4.3-1-x86_64.pkg.tar.zst"; sha256 = "a81ce98866fcd9bba4e12396dd13ff77ba94f8ac0560392fd55b19f7622859e4"; }];
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 libnettle libxml2 libzstd zlib ];
  };

  "btyacc" = fetch {
    pname       = "btyacc";
    version     = "20200330";
    sources     = [{ filename = "btyacc-20200330-1-x86_64.pkg.tar.zst"; sha256 = "6ea55f099ee79d4e2cb24c78dee45373fa2df1c8552ccf12bdd27201b5faab61"; }];
  };

  "busybox" = fetch {
    pname       = "busybox";
    version     = "1.31.1";
    sources     = [{ filename = "busybox-1.31.1-1-x86_64.pkg.tar.zst"; sha256 = "b5474b4c2cb282b0fa6d3aa8c81b35f4e7acfe215a39d5285d70df0c2b476ef2"; }];
    buildInputs = [ msys2-runtime ];
  };

  "bzip2" = fetch {
    pname       = "bzip2";
    version     = "1.0.8";
    sources     = [{ filename = "bzip2-1.0.8-2-x86_64.pkg.tar.xz"; sha256 = "6ece81cc878ce7a4b9a6b4e36c1a9fcd909a4e61341cde17f124da5c6a44b05a"; }];
    buildInputs = [ libbz2 ];
  };

  "ca-certificates" = fetch {
    pname       = "ca-certificates";
    version     = "20190110";
    sources     = [{ filename = "ca-certificates-20190110-1-any.pkg.tar.xz"; sha256 = "cbbd19c192c15258645c9cce3579466711fa551e9e44e1a0121303e132c85fd3"; }];
    buildInputs = [ bash openssl findutils coreutils sed p11-kit ];
  };

  "ccache" = fetch {
    pname       = "ccache";
    version     = "3.7.10";
    sources     = [{ filename = "ccache-3.7.10-1-x86_64.pkg.tar.zst"; sha256 = "c64fa07e6cb72ca53eefca234eb08121834933f8343c1710f7565ac8ee7223e5"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "cdecl" = fetch {
    pname       = "cdecl";
    version     = "2.5";
    sources     = [{ filename = "cdecl-2.5-1-x86_64.pkg.tar.xz"; sha256 = "b49ead1877dcee37018b4b404088d53ee0dfa01cc4d83ad62bf8f4511b89d71b"; }];
    buildInputs = [ libedit ];
  };

  "cgdb" = fetch {
    pname       = "cgdb";
    version     = "0.7.1";
    sources     = [{ filename = "cgdb-0.7.1-3-x86_64.pkg.tar.xz"; sha256 = "06d5f0cd5031e677c0ca9425262ac80cae26b22ce0baeadf15ac57d45a157eb4"; }];
    buildInputs = [ libreadline ncurses gdb ];
  };

  "cloc" = fetch {
    pname       = "cloc";
    version     = "1.86";
    sources     = [{ filename = "cloc-1.86-1-any.pkg.tar.zst"; sha256 = "12a747e61e0126744b120bb397fc669813f1d08ba93ba26dc7740d28fbf262c4"; }];
    buildInputs = [ perl perl-Algorithm-Diff perl-Regexp-Common perl-Parallel-ForkManager ];
    broken      = true; # broken dependency perl-Data-OptList -> perl-Scalar-List-Utils
  };

  "cloog" = fetch {
    pname       = "cloog";
    version     = "0.20.0";
    sources     = [{ filename = "cloog-0.20.0-1-x86_64.pkg.tar.xz"; sha256 = "fc9923cf05039c28d66a9b40c927260fb7f949bc472f60ad032ae12bbd25826e"; }];
    buildInputs = [ isl ];
  };

  "cloog-devel" = fetch {
    pname       = "cloog-devel";
    version     = "0.20.0";
    sources     = [{ filename = "cloog-devel-0.20.0-1-x86_64.pkg.tar.xz"; sha256 = "48f3147de7dcddd6e441948f2f6633e4bac2b36248539d6962d1e43f8cfad811"; }];
    buildInputs = [ (assert cloog.version=="0.20.0"; cloog) isl-devel ];
  };

  "cmake" = fetch {
    pname       = "cmake";
    version     = "3.17.3";
    sources     = [{ filename = "cmake-3.17.3-3-x86_64.pkg.tar.zst"; sha256 = "718eca98698d9ac398632ffce5298675244f22e0bd526781b70cc2db5acd2d26"; }];
    buildInputs = [ gcc-libs jsoncpp libcurl libexpat libarchive librhash libutil-linux libuv ncurses pkg-config zlib ];
  };

  "cmake-emacs" = fetch {
    pname       = "cmake-emacs";
    version     = "3.17.3";
    sources     = [{ filename = "cmake-emacs-3.17.3-3-x86_64.pkg.tar.zst"; sha256 = "ff62fd002863b5a2a958eb5c15d388ca9e029ecf1beaca5a1fe7c06296fb6bfc"; }];
    buildInputs = [ (assert cmake.version=="3.17.3"; cmake) emacs ];
  };

  "cmake-vim" = fetch {
    pname       = "cmake-vim";
    version     = "3.17.3";
    sources     = [{ filename = "cmake-vim-3.17.3-3-x86_64.pkg.tar.zst"; sha256 = "77c732b1e0f3a28bd712394d29398082de16d1fb800b20534e85a1c3ceedac1e"; }];
    buildInputs = [ (assert cmake.version=="3.17.3"; cmake) vim ];
  };

  "cocom" = fetch {
    pname       = "cocom";
    version     = "0.996";
    sources     = [{ filename = "cocom-0.996-2-x86_64.pkg.tar.xz"; sha256 = "39ff7eed6f337034294b805200cc46946413c49ae91a27f2c4f22e6d75aeaf39"; }];
  };

  "colordiff" = fetch {
    pname       = "colordiff";
    version     = "1.0.19";
    sources     = [{ filename = "colordiff-1.0.19-1-any.pkg.tar.zst"; sha256 = "26e5dd890698e1d2ab5e32c142611eea95b086647673992e8896adb1be5160fd"; }];
    buildInputs = [ diffutils perl ];
  };

  "colormake-git" = fetch {
    pname       = "colormake-git";
    version     = "r8.9c1d2e6";
    sources     = [{ filename = "colormake-git-r8.9c1d2e6-1-any.pkg.tar.xz"; sha256 = "835a637b514280a3a24e273faff1b1f0abff65691123d0eb768be2b7bbe20c45"; }];
    buildInputs = [ make ];
  };

  "conemu-git" = fetch {
    pname       = "conemu-git";
    version     = "r3330.34a88ed";
    sources     = [{ filename = "conemu-git-r3330.34a88ed-1-x86_64.pkg.tar.xz"; sha256 = "6915a2f7a203490b67ce7156e9d5e4a6420a3f95ab0cdcbeb76f166e25282419"; }];
  };

  "coreutils" = fetch {
    pname       = "coreutils";
    version     = "8.32";
    sources     = [{ filename = "coreutils-8.32-1-x86_64.pkg.tar.xz"; sha256 = "af291ea74a6bd5055029cdfe2113314000873d656e0834f16931c90899c0f048"; }];
    buildInputs = [ gmp libiconv libintl ];
  };

  "cpio" = fetch {
    pname       = "cpio";
    version     = "2.13";
    sources     = [{ filename = "cpio-2.13-1-x86_64.pkg.tar.xz"; sha256 = "71aba2b36ae2017a16a76970022f473e9dde351cdc25397098d2a603c98eb288"; }];
    buildInputs = [ libintl ];
  };

  "crosstool-ng" = fetch {
    pname       = "crosstool-ng";
    version     = "1.24.0";
    sources     = [{ filename = "crosstool-ng-1.24.0-1-x86_64.pkg.tar.xz"; sha256 = "897285bd7d67db74fa1640a9afdde4e8f91948f1280132bce51e8aaa6f6c9839"; }];
    buildInputs = [ ncurses libintl ];
  };

  "cscope" = fetch {
    pname       = "cscope";
    version     = "15.9";
    sources     = [{ filename = "cscope-15.9-1-x86_64.pkg.tar.xz"; sha256 = "77f626cc0de4203a31b1743ddc1a613d8993f2769e101c369c964a43594d7adb"; }];
  };

  "ctags" = fetch {
    pname       = "ctags";
    version     = "5.8";
    sources     = [{ filename = "ctags-5.8-2-x86_64.pkg.tar.xz"; sha256 = "7b7a5b97ccb64ff9ffd0acc0e962b1304b1d6998113d145090a08a6b4d1e4181"; }];
  };

  "curl" = fetch {
    pname       = "curl";
    version     = "7.71.1";
    sources     = [{ filename = "curl-7.71.1-1-x86_64.pkg.tar.zst"; sha256 = "d8d80e616d4becf2f8ff934e34e6ac5edb3c391a3a22490612eaa17910f109a3"; }];
    buildInputs = [ ca-certificates libcurl libcrypt libmetalink libunistring libnghttp2 libpsl openssl zlib ];
  };

  "cvs" = fetch {
    pname       = "cvs";
    version     = "1.11.23";
    sources     = [{ filename = "cvs-1.11.23-3-x86_64.pkg.tar.xz"; sha256 = "ecbb92c376c0e0ebc365a18772c2219eba48ce4afa7117ce3661c85c1f8af911"; }];
    buildInputs = [ heimdal zlib libcrypt libopenssl ];
  };

  "cygrunsrv" = fetch {
    pname       = "cygrunsrv";
    version     = "1.62";
    sources     = [{ filename = "cygrunsrv-1.62-2-x86_64.pkg.tar.xz"; sha256 = "273f061a4b98391397b24d669bde05b2366a4cf9603a620ad25c2e7eaa274b7e"; }];
  };

  "cyrus-sasl" = fetch {
    pname       = "cyrus-sasl";
    version     = "2.1.27";
    sources     = [{ filename = "cyrus-sasl-2.1.27-1-x86_64.pkg.tar.xz"; sha256 = "903d0255dd4e1bc38577d86e0814235a6f7166e10d9441b78963dd5a3d5fb9aa"; }];
    buildInputs = [ (assert libsasl.version=="2.1.27"; libsasl) ];
  };

  "cython" = fetch {
    pname       = "cython";
    version     = "0.29.21";
    sources     = [{ filename = "cython-0.29.21-2-x86_64.pkg.tar.zst"; sha256 = "d53a30b6fa1975e89f29f32aa2b5b61fb1b01fc12fd92d26b87cd6daadfc1b55"; }];
    buildInputs = [ python-setuptools ];
  };

  "dash" = fetch {
    pname       = "dash";
    version     = "0.5.11.1";
    sources     = [{ filename = "dash-0.5.11.1-2-x86_64.pkg.tar.zst"; sha256 = "b1793f5633375ca8b5a4507c5190f7df9f9a20c05f55cc13f1a726ff2940b6ce"; }];
    buildInputs = [ grep sed filesystem ];
  };

  "db" = fetch {
    pname       = "db";
    version     = "5.3.28";
    sources     = [{ filename = "db-5.3.28-3-x86_64.pkg.tar.zst"; sha256 = "cbd57c5588660d6d7d40d29edb53016e989b5c081b1bd47a0c6ac6f79bd562a6"; }];
    buildInputs = [ (assert libdb.version=="5.3.28"; libdb) ];
  };

  "db-docs" = fetch {
    pname       = "db-docs";
    version     = "5.3.28";
    sources     = [{ filename = "db-docs-5.3.28-3-x86_64.pkg.tar.zst"; sha256 = "54553871bcc461a718d187afc0fa94e67202215c5f9b977b4aed6390f70121ed"; }];
    buildInputs = [ sh ];
  };

  "dejagnu" = fetch {
    pname       = "dejagnu";
    version     = "1.6.2";
    sources     = [{ filename = "dejagnu-1.6.2-1-any.pkg.tar.xz"; sha256 = "a1bcb0b93a526c8a7c6fe5147b8cf076f7df6434a9c31ee9a527f86f603b75bc"; }];
    buildInputs = [ expect ];
  };

  "delta" = fetch {
    pname       = "delta";
    version     = "20060803";
    sources     = [{ filename = "delta-20060803-1-x86_64.pkg.tar.xz"; sha256 = "ae8f70fc1e4ec82a47f4471d622830f751f747db29ac2b09a5b8cb5a1790942f"; }];
    buildInputs = [ perl ];
  };

  "dialog" = fetch {
    pname       = "dialog";
    version     = "1.3_20200327";
    sources     = [{ filename = "dialog-1.3_20200327-1-x86_64.pkg.tar.zst"; sha256 = "3d633056a832552b11f62c31ca111394e0af73005c8fc6232b22f67fdce8477e"; }];
    buildInputs = [ ncurses ];
  };

  "diffstat" = fetch {
    pname       = "diffstat";
    version     = "1.63";
    sources     = [{ filename = "diffstat-1.63-1-x86_64.pkg.tar.xz"; sha256 = "9bf9498581cf750d0a20ecae9047db7a0673bc998e257f13034c0abdacb8c946"; }];
    buildInputs = [ msys2-runtime ];
  };

  "diffutils" = fetch {
    pname       = "diffutils";
    version     = "3.7";
    sources     = [{ filename = "diffutils-3.7-1-x86_64.pkg.tar.xz"; sha256 = "7df9391e234f7d0ba9ae6717aed739d01190aa9ab25c48d53549a15c89ed0d87"; }];
    buildInputs = [ msys2-runtime sh ];
  };

  "docbook-dsssl" = fetch {
    pname       = "docbook-dsssl";
    version     = "1.79";
    sources     = [{ filename = "docbook-dsssl-1.79-1-any.pkg.tar.xz"; sha256 = "03a865131ce845f6f87ebc9d774b5a5383492fc8e633e970517bd75fb5951bf1"; }];
    buildInputs = [ sgml-common perl ];
  };

  "docbook-mathml" = fetch {
    pname       = "docbook-mathml";
    version     = "1.1CR1";
    sources     = [{ filename = "docbook-mathml-1.1CR1-1-any.pkg.tar.xz"; sha256 = "4d3f0567d367b5e21eeee07ef87a35efc8f3ae64134253972e7099e8b013e9cb"; }];
    buildInputs = [ libxml2 ];
  };

  "docbook-sgml" = fetch {
    pname       = "docbook-sgml";
    version     = "4.5";
    sources     = [{ filename = "docbook-sgml-4.5-1-any.pkg.tar.xz"; sha256 = "89cba5e6b4ceb7319c84ad08d6f582ac0933639105a05835c7270cbc297f2bf9"; }];
    buildInputs = [ sgml-common ];
  };

  "docbook-sgml31" = fetch {
    pname       = "docbook-sgml31";
    version     = "3.1";
    sources     = [{ filename = "docbook-sgml31-3.1-1-any.pkg.tar.xz"; sha256 = "7c10e1ad75147cd0c09b1ccae2eb8a34dc44211435e771c5f7a392ea45328717"; }];
    buildInputs = [ sgml-common ];
  };

  "docbook-xml" = fetch {
    pname       = "docbook-xml";
    version     = "4.5";
    sources     = [{ filename = "docbook-xml-4.5-2-any.pkg.tar.xz"; sha256 = "a01f648a7af372b290528430d3e1768ac3d8aee4c0e74bcf750f646fc8e9948f"; }];
    buildInputs = [ libxml2 ];
  };

  "docbook-xsl" = fetch {
    pname       = "docbook-xsl";
    version     = "1.79.2";
    sources     = [{ filename = "docbook-xsl-1.79.2-1-any.pkg.tar.xz"; sha256 = "ede4fbbc97f1dda1d1640926001d70b0ea4af0ad6f8c20a5d6ce84e501d94045"; }];
    buildInputs = [ libxml2 libxslt docbook-xml ];
  };

  "docx2txt" = fetch {
    pname       = "docx2txt";
    version     = "1.4";
    sources     = [{ filename = "docx2txt-1.4-1-x86_64.pkg.tar.xz"; sha256 = "736a37af1c54e1d4746c523e105b33e6eccfacdd4a4ac87b1326499ee56c59f1"; }];
    buildInputs = [ perl unzip ];
  };

  "dos2unix" = fetch {
    pname       = "dos2unix";
    version     = "7.4.2";
    sources     = [{ filename = "dos2unix-7.4.2-1-x86_64.pkg.tar.zst"; sha256 = "5131ef03617d1d3ddd116c00ac583c3875fa031dad79afdf095e9aa222ba6679"; }];
    buildInputs = [ libintl ];
  };

  "dosfstools" = fetch {
    pname       = "dosfstools";
    version     = "4.1";
    sources     = [{ filename = "dosfstools-4.1-1-x86_64.pkg.tar.xz"; sha256 = "0e3310c24726d94ed48285273e9bec64b35bf92d368dc4bd899c798b8768c8d0"; }];
    buildInputs = [ libiconv libiconv-devel ];
  };

  "doxygen" = fetch {
    pname       = "doxygen";
    version     = "1.8.19";
    sources     = [{ filename = "doxygen-1.8.19-1-x86_64.pkg.tar.zst"; sha256 = "a707fafbe9fd7591dbd2326d78230fb867cec25d0d9c8d82cd56e7bf4b2cfb33"; }];
    buildInputs = [ gcc-libs libsqlite libiconv ];
  };

  "dtc" = fetch {
    pname       = "dtc";
    version     = "1.6.0";
    sources     = [{ filename = "dtc-1.6.0-3-x86_64.pkg.tar.zst"; sha256 = "5382a69e04cac81914e4711f23f91ab2afd8e36b614a047a205d16ac5276c30c"; }];
    buildInputs = [ libyaml ];
  };

  "easyoptions-git" = fetch {
    pname       = "easyoptions-git";
    version     = "r37.c481763";
    sources     = [{ filename = "easyoptions-git-r37.c481763-1-any.pkg.tar.xz"; sha256 = "0e9839f287481c33744cc95469fd5bd90d1acb2b768f63829229c241921d9914"; }];
    buildInputs = [ ruby bash ];
  };

  "ed" = fetch {
    pname       = "ed";
    version     = "1.16";
    sources     = [{ filename = "ed-1.16-1-x86_64.pkg.tar.xz"; sha256 = "156578aab5f01c6df3f6f770c495621f76714240ece0985d893df538a1b909eb"; }];
    buildInputs = [ sh ];
  };

  "editorconfig-vim" = fetch {
    pname       = "editorconfig-vim";
    version     = "1.0.0_beta";
    sources     = [{ filename = "editorconfig-vim-1.0.0_beta-1-x86_64.pkg.tar.xz"; sha256 = "bb992b57ff5076a66ea9c25467fdbcffe35a13eba5661a3f0bceaee7c7543c6a"; }];
    buildInputs = [ vim ];
  };

  "elinks-git" = fetch {
    pname       = "elinks-git";
    version     = "0.13.4008.f86be659";
    sources     = [{ filename = "elinks-git-0.13.4008.f86be659-7-x86_64.pkg.tar.zst"; sha256 = "ab6301bcf529f7798a5513ab089d134f27ed44daa0080647e0976786f378d658"; }];
    buildInputs = [ doxygen gettext libbz2 libcrypt libexpat libffi libgc libgcrypt libgnutls libhogweed libiconv libidn liblzma libnettle libp11-kit libtasn1 libtre-git libunistring perl python3 xmlto zlib ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "emacs" = fetch {
    pname       = "emacs";
    version     = "26.3";
    sources     = [{ filename = "emacs-26.3-1-x86_64.pkg.tar.xz"; sha256 = "3a11721ec91bc10b77d44fc3dabc65af397da030b1a162774ae5727b75b360a7"; }];
    buildInputs = [ ncurses zlib libxml2 libiconv libcrypt libgnutls glib2 libhogweed ];
  };

  "expat" = fetch {
    pname       = "expat";
    version     = "2.2.9";
    sources     = [{ filename = "expat-2.2.9-1-x86_64.pkg.tar.xz"; sha256 = "c8765b1abdb7d42ea9ee20f858ac0b4dd3675e252b27b7a8e658adff590cf931"; }];
    buildInputs = [  ];
  };

  "expect" = fetch {
    pname       = "expect";
    version     = "5.45.4";
    sources     = [{ filename = "expect-5.45.4-2-x86_64.pkg.tar.xz"; sha256 = "15782d5f134fac0342144f51edc7feb1c4fc5f050e2393727a1c0534b2ead3ef"; }];
    buildInputs = [ tcl ];
  };

  "fcode-utils" = fetch {
    pname       = "fcode-utils";
    version     = "1.0.2";
    sources     = [{ filename = "fcode-utils-1.0.2-1-x86_64.pkg.tar.xz"; sha256 = "6a819eab4c3cd177434f987a4280945db7c0a5d61dcbe9490e2d59d1edbdee8d"; }];
  };

  "file" = fetch {
    pname       = "file";
    version     = "5.39";
    sources     = [{ filename = "file-5.39-1-x86_64.pkg.tar.zst"; sha256 = "5908bce85f76c3d9843c1e8d65fa0778b345db7e430b0b43245dbd8778a748b8"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "filesystem" = fetch {
    pname       = "filesystem";
    version     = "2020.10";
    sources     = [{ filename = "filesystem-2020.10-1-x86_64.pkg.tar.xz"; sha256 = "d6747f6fea0b5b02507e7aa1d620bd6a594502a1a82a6565a55025bdef702f03"; }];
    buildInputs = [  ];
  };

  "findutils" = fetch {
    pname       = "findutils";
    version     = "4.7.0";
    sources     = [{ filename = "findutils-4.7.0-1-x86_64.pkg.tar.xz"; sha256 = "8b3a80653918349567359d67ceeab1a14040314901103a44b4bb6a8aea8d61db"; }];
    buildInputs = [ libiconv libintl ];
  };

  "fish" = fetch {
    pname       = "fish";
    version     = "3.1.2";
    sources     = [{ filename = "fish-3.1.2-1-x86_64.pkg.tar.zst"; sha256 = "b7b763a276c8878ab9f755870445fe808065144fa5bd72eacbce886942b8f81b"; }];
    buildInputs = [ bc gcc-libs gettext libiconv libpcre2_16 man-db ncurses ];
  };

  "flex" = fetch {
    pname       = "flex";
    version     = "2.6.4";
    sources     = [{ filename = "flex-2.6.4-1-x86_64.pkg.tar.xz"; sha256 = "dca8b51b1f0f0abf32cdb6b718414fafc6a6849e3feb13b1056ebe092b23a784"; }];
    buildInputs = [ m4 sh libiconv libintl ];
  };

  "flexc++" = fetch {
    pname       = "flexc++";
    version     = "2.07.09";
    sources     = [{ filename = "flexc++-2.07.09-1-x86_64.pkg.tar.xz"; sha256 = "9e73e15d5d10e3ba53694f20a94dbc5b43e6846e9587712a9ffdf36dd74212b3"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libbobcat.version "4.01.00"; libbobcat) ];
  };

  "fzy" = fetch {
    pname       = "fzy";
    version     = "1.0";
    sources     = [{ filename = "fzy-1.0-1-x86_64.pkg.tar.xz"; sha256 = "84099bfcc4421d3a9aae5145ff1b2e59384c1271fd37e77a941eca429616b471"; }];
  };

  "gamin" = fetch {
    pname       = "gamin";
    version     = "0.1.10";
    sources     = [{ filename = "gamin-0.1.10-4-x86_64.pkg.tar.zst"; sha256 = "264fbb22713f27fb822b739cb0b09173acf0220b3911c38c34d27852ca40410d"; }];
  };

  "gamin-devel" = fetch {
    pname       = "gamin-devel";
    version     = "0.1.10";
    sources     = [{ filename = "gamin-devel-0.1.10-4-x86_64.pkg.tar.zst"; sha256 = "d4e3c8cf559a0d4c0da90dedcbcbac45f66227cb974026242bd8ee47058a2329"; }];
    buildInputs = [ (assert gamin.version=="0.1.10"; gamin) ];
  };

  "gawk" = fetch {
    pname       = "gawk";
    version     = "5.1.0";
    sources     = [{ filename = "gawk-5.1.0-1-x86_64.pkg.tar.xz"; sha256 = "786fdb4beac0f28fa400f323d4a9f414ac99eee207428fb0aee0ffe2048f43a3"; }];
    buildInputs = [ sh mpfr libintl libreadline ];
  };

  "gcc" = fetch {
    pname       = "gcc";
    version     = "9.3.0";
    sources     = [{ filename = "gcc-9.3.0-1-x86_64.pkg.tar.xz"; sha256 = "567ae18eb3a744d282450a2dcfae87e1d3b146e68609dbc4d12e66725de43dfc"; }];
    buildInputs = [ (assert gcc-libs.version=="9.3.0"; gcc-libs) binutils gmp isl mpc mpfr msys2-runtime-devel msys2-w32api-headers msys2-w32api-runtime windows-default-manifest ];
  };

  "gcc-fortran" = fetch {
    pname       = "gcc-fortran";
    version     = "9.3.0";
    sources     = [{ filename = "gcc-fortran-9.3.0-1-x86_64.pkg.tar.xz"; sha256 = "7de14c58d5756756cabe92900f6764cd80ca82195b8b927a31191960efa74cb3"; }];
    buildInputs = [ (assert gcc.version=="9.3.0"; gcc) ];
  };

  "gcc-libs" = fetch {
    pname       = "gcc-libs";
    version     = "9.3.0";
    sources     = [{ filename = "gcc-libs-9.3.0-1-x86_64.pkg.tar.xz"; sha256 = "79a74bb1ef1d7f4eb12f7437ac24371ec9e41a3d96b653a2ec7f09d1e7aa9c63"; }];
    buildInputs = [ msys2-runtime ];
  };

  "gdb" = fetch {
    pname       = "gdb";
    version     = "9.2";
    sources     = [{ filename = "gdb-9.2-3-x86_64.pkg.tar.zst"; sha256 = "c66b6a88439a0be74363a95500923dbc31346b7913d1ac838d70a2025d126e1f"; }];
    buildInputs = [ libiconv zlib expat python libexpat libreadline mpfr ];
  };

  "gdbm" = fetch {
    pname       = "gdbm";
    version     = "1.18.1";
    sources     = [{ filename = "gdbm-1.18.1-3-x86_64.pkg.tar.zst"; sha256 = "97ee61b1f21174d4aa52e4ab33462ff39d8e3387904d9d8fdddc4ed2438b92de"; }];
    buildInputs = [ (assert libgdbm.version=="1.18.1"; libgdbm) ];
  };

  "gengetopt" = fetch {
    pname       = "gengetopt";
    version     = "2.23";
    sources     = [{ filename = "gengetopt-2.23-1-x86_64.pkg.tar.xz"; sha256 = "fb91a428f80fbfab443b62dea67116cf614edce8efcda7c53ab86854e808c652"; }];
  };

  "getent" = fetch {
    pname       = "getent";
    version     = "2.18.90";
    sources     = [{ filename = "getent-2.18.90-2-x86_64.pkg.tar.xz"; sha256 = "3aea9e63fbb4f194430d22ba0ffc1aeecb243f0aef78afeabda43471ad326895"; }];
    buildInputs = [ libargp ];
  };

  "gettext" = fetch {
    pname       = "gettext";
    version     = "0.19.8.1";
    sources     = [{ filename = "gettext-0.19.8.1-1-x86_64.pkg.tar.xz"; sha256 = "59d400b4e71e489bbf6e1ce664ca1f38ebe28c8f4d7dd21e5190a0ada1ec5ccd"; }];
    buildInputs = [ libintl libgettextpo libasprintf ];
  };

  "gettext-devel" = fetch {
    pname       = "gettext-devel";
    version     = "0.19.8.1";
    sources     = [{ filename = "gettext-devel-0.19.8.1-1-x86_64.pkg.tar.xz"; sha256 = "c484d03b8a4aa48119f2e8796ab7d159a51ce88aa6cd07c444b86ab724b1a48f"; }];
    buildInputs = [ (assert gettext.version=="0.19.8.1"; gettext) libiconv-devel ];
  };

  "git" = fetch {
    pname       = "git";
    version     = "2.28.0";
    sources     = [{ filename = "git-2.28.0-1-x86_64.pkg.tar.zst"; sha256 = "2bb999dbe2f9f53e69e77784acad89f0baacc5b419d670d64de504d8e65ef697"; }];
    buildInputs = [ curl (assert stdenvNoCC.lib.versionAtLeast expat.version "2.0"; expat) libpcre2_8 vim openssh openssl perl-Error (assert stdenvNoCC.lib.versionAtLeast perl.version "5.14.0"; perl) perl-Authen-SASL perl-libwww perl-MIME-tools perl-Net-SMTP-SSL perl-TermReadKey ];
    broken      = true; # broken dependency perl-MIME-tools -> perl-IO-stringy
  };

  "git-crypt" = fetch {
    pname       = "git-crypt";
    version     = "0.6.0";
    sources     = [{ filename = "git-crypt-0.6.0-1-x86_64.pkg.tar.xz"; sha256 = "0a2e7d7f4a0f5152d2730458aaab92d7234a530f22f76b4185e9956e08a55ffb"; }];
    buildInputs = [ gnupg git ];
    broken      = true; # broken dependency perl-MIME-tools -> perl-IO-stringy
  };

  "git-extras" = fetch {
    pname       = "git-extras";
    version     = "6.0.0";
    sources     = [{ filename = "git-extras-6.0.0-1-any.pkg.tar.zst"; sha256 = "738ce2607f79858064228692b1447bafde26daa6d3047ead67868714dd84b2a4"; }];
    buildInputs = [ git ];
    broken      = true; # broken dependency perl-MIME-tools -> perl-IO-stringy
  };

  "git-flow" = fetch {
    pname       = "git-flow";
    version     = "1.12.3";
    sources     = [{ filename = "git-flow-1.12.3-1-x86_64.pkg.tar.xz"; sha256 = "61a80bdb5c406ad44f449027afda9ae8898a8aad7a8d096d314a999772723d1b"; }];
    buildInputs = [ git util-linux ];
    broken      = true; # broken dependency perl-MIME-tools -> perl-IO-stringy
  };

  "glib2" = fetch {
    pname       = "glib2";
    version     = "2.64.6";
    sources     = [{ filename = "glib2-2.64.6-1-x86_64.pkg.tar.zst"; sha256 = "f8b7f7404cc60bfdbe394740b129fb5ffa2683594d5de63a34bc74744cf3bc96"; }];
    buildInputs = [ libxslt libpcre libffi libiconv zlib ];
  };

  "glib2-devel" = fetch {
    pname       = "glib2-devel";
    version     = "2.64.6";
    sources     = [{ filename = "glib2-devel-2.64.6-1-x86_64.pkg.tar.zst"; sha256 = "e18e50db9175c6f7e9a5c523625cb91a4c05238a4cd507a9a661d97e79a2e53b"; }];
    buildInputs = [ (assert glib2.version=="2.64.6"; glib2) pcre-devel libffi-devel libiconv-devel zlib-devel ];
  };

  "glib2-docs" = fetch {
    pname       = "glib2-docs";
    version     = "2.64.6";
    sources     = [{ filename = "glib2-docs-2.64.6-1-x86_64.pkg.tar.zst"; sha256 = "0a3e1ff81699c746adf2aacea0b1774159efb6a6e15aaefbfcab96cf48d2129a"; }];
  };

  "global" = fetch {
    pname       = "global";
    version     = "6.6.4";
    sources     = [{ filename = "global-6.6.4-1-x86_64.pkg.tar.xz"; sha256 = "da01dc91fc41fc0b3c462d7c97a23172eeb89bba142bae13e7c5fe5ea3271f02"; }];
    buildInputs = [ libltdl ];
  };

  "gmp" = fetch {
    pname       = "gmp";
    version     = "6.2.0";
    sources     = [{ filename = "gmp-6.2.0-1-x86_64.pkg.tar.xz"; sha256 = "f3e274c6d25df4b757a4a1114b5bcda2de05a4013426616cf056d6acfc5ef1e3"; }];
    buildInputs = [  ];
  };

  "gmp-devel" = fetch {
    pname       = "gmp-devel";
    version     = "6.2.0";
    sources     = [{ filename = "gmp-devel-6.2.0-1-x86_64.pkg.tar.xz"; sha256 = "1b39dc61e8ffcf753af0894bc826f7089e3d8b2c92e124e36abc2c9939cbd6fc"; }];
    buildInputs = [ (assert gmp.version=="6.2.0"; gmp) ];
  };

  "gnome-doc-utils" = fetch {
    pname       = "gnome-doc-utils";
    version     = "0.20.10";
    sources     = [{ filename = "gnome-doc-utils-0.20.10-2-any.pkg.tar.zst"; sha256 = "fc22b84d071199e9c0923d6bee71d5e41e133a582d61b8760467ae1bae2c72b1"; }];
    buildInputs = [ libxslt python docbook-xml rarian ];
  };

  "gnu-netcat" = fetch {
    pname       = "gnu-netcat";
    version     = "0.7.1";
    sources     = [{ filename = "gnu-netcat-0.7.1-1-x86_64.pkg.tar.xz"; sha256 = "32fa739d26fd49a3f8c22717ae338472d71d4798844cbc0db5e7780131fe69aa"; }];
    buildInputs = [ info ];
  };

  "gnupg" = fetch {
    pname       = "gnupg";
    version     = "2.2.23";
    sources     = [{ filename = "gnupg-2.2.23-1-x86_64.pkg.tar.zst"; sha256 = "d473d9fda7d978d40f5b1cb10d2354266f226467f50ddd5e7340f88794c80e03"; }];
    buildInputs = [ bzip2 libassuan libbz2 libcurl libgcrypt libgpg-error libgnutls libiconv libintl libksba libnpth libreadline libsqlite nettle pinentry zlib ];
  };

  "gnutls" = fetch {
    pname       = "gnutls";
    version     = "3.6.14";
    sources     = [{ filename = "gnutls-3.6.14-1-x86_64.pkg.tar.zst"; sha256 = "f1f121a8f635598af24a52da59a4542cc712707e588a3b8779ed4c884bf77526"; }];
    buildInputs = [ (assert libgnutls.version=="3.6.14"; libgnutls) ];
  };

  "gperf" = fetch {
    pname       = "gperf";
    version     = "3.1";
    sources     = [{ filename = "gperf-3.1-2-x86_64.pkg.tar.zst"; sha256 = "1e33d7de759a162f78cba7e3afcd01bbecf9537162577c48b71cd4c048906b92"; }];
    buildInputs = [ gcc-libs info ];
  };

  "gradle" = fetch {
    pname       = "gradle";
    version     = "6.7";
    sources     = [{ filename = "gradle-6.7-1-any.pkg.tar.zst"; sha256 = "69c128eb4e97c6433efb417d4ed533c998d9bf2927b72eeffce51e07b92d6bcb"; }];
  };

  "gradle-doc" = fetch {
    pname       = "gradle-doc";
    version     = "6.7";
    sources     = [{ filename = "gradle-doc-6.7-1-any.pkg.tar.zst"; sha256 = "849f02fcc44827007c4b4c93d7efa21639c872e3f6bfcfe32441e5d60902d705"; }];
  };

  "grep" = fetch {
    pname       = "grep";
    version     = "3.0";
    sources     = [{ filename = "grep-3.0-2-x86_64.pkg.tar.xz"; sha256 = "21ef642593ca3e8a5bb70c0ccf3856e550ced9e5d2bcdca0c09a3326ed0fa05e"; }];
    buildInputs = [ libiconv libintl libpcre sh ];
  };

  "grml-zsh-config" = fetch {
    pname       = "grml-zsh-config";
    version     = "0.17.4";
    sources     = [{ filename = "grml-zsh-config-0.17.4-1-any.pkg.tar.zst"; sha256 = "5f7bbf4a89d28e9cfb5360afb279419eaf13e0483cf83b1a4f363650eea69ff8"; }];
    buildInputs = [ zsh coreutils inetutils grep sed procps ];
  };

  "groff" = fetch {
    pname       = "groff";
    version     = "1.22.4";
    sources     = [{ filename = "groff-1.22.4-1-x86_64.pkg.tar.xz"; sha256 = "26332c4d52a4096146a7bbca3dcb04663e764e5cd75478605d4e24cd86cabe12"; }];
    buildInputs = [ perl gcc-libs ];
  };

  "gtk-doc" = fetch {
    pname       = "gtk-doc";
    version     = "1.32";
    sources     = [{ filename = "gtk-doc-1.32-2-x86_64.pkg.tar.xz"; sha256 = "15e92db252ebc4b60d7274205d4e44216f186b9fc0b9cb73f8a2349f2536e56b"; }];
    buildInputs = [ docbook-xsl glib2 gnome-doc-utils libxml2-python python python-pygments vim yelp-tools ];
  };

  "guile" = fetch {
    pname       = "guile";
    version     = "2.2.7";
    sources     = [{ filename = "guile-2.2.7-1-x86_64.pkg.tar.xz"; sha256 = "c261524840f5b6eb0127493b2ea17b7d01ed6f5f1ad73233b4adc2d45c5ee8b2"; }];
    buildInputs = [ (assert libguile.version=="2.2.7"; libguile) info ];
  };

  "gyp-git" = fetch {
    pname       = "gyp-git";
    version     = "r2162.28b55023";
    sources     = [{ filename = "gyp-git-r2162.28b55023-2-x86_64.pkg.tar.xz"; sha256 = "f94fd57a8f9cefdbd49b0fbd45299eed862870e2c0c389571af5b46c395b853d"; }];
    buildInputs = [ python python-setuptools ];
  };

  "gzip" = fetch {
    pname       = "gzip";
    version     = "1.10";
    sources     = [{ filename = "gzip-1.10-1-x86_64.pkg.tar.xz"; sha256 = "681678f214873cef17a1411c53cdef0da5ad4ad1ebb25055363f99e73f3f4959"; }];
    buildInputs = [ msys2-runtime bash less ];
  };

  "heimdal" = fetch {
    pname       = "heimdal";
    version     = "7.7.0";
    sources     = [{ filename = "heimdal-7.7.0-2-x86_64.pkg.tar.zst"; sha256 = "e64fcf00ddd4158ac56dc3b282698d616bedeece3466376bc03ff61f09a0c044"; }];
    buildInputs = [ heimdal-libs ];
  };

  "heimdal-devel" = fetch {
    pname       = "heimdal-devel";
    version     = "7.7.0";
    sources     = [{ filename = "heimdal-devel-7.7.0-2-x86_64.pkg.tar.zst"; sha256 = "f60fc46b3bee62a45acfec095c629a434d62b8c98066b3ce93dc6bcf031699ff"; }];
    buildInputs = [ heimdal-libs libcrypt-devel libedit-devel libdb-devel libsqlite-devel ];
  };

  "heimdal-libs" = fetch {
    pname       = "heimdal-libs";
    version     = "7.7.0";
    sources     = [{ filename = "heimdal-libs-7.7.0-2-x86_64.pkg.tar.zst"; sha256 = "eda2132707ef438db009613c011b47217cb00ee4d4a28ad4f6cb10ad1845f74e"; }];
    buildInputs = [ libdb libcrypt libedit libsqlite libopenssl ];
  };

  "help2man" = fetch {
    pname       = "help2man";
    version     = "1.47.15";
    sources     = [{ filename = "help2man-1.47.15-1-x86_64.pkg.tar.zst"; sha256 = "a8aaa6b340bd82615511ba16618d488c9e67f3664c4116f8e859b43f7f6b2c6b"; }];
    buildInputs = [ perl-Locale-Gettext libintl ];
  };

  "hexcurse" = fetch {
    pname       = "hexcurse";
    version     = "1.60.0";
    sources     = [{ filename = "hexcurse-1.60.0-1-x86_64.pkg.tar.xz"; sha256 = "989f2a72d182463f6ebf02901618ac670ba963b02e8a0d0f8e8e762c34cb666e"; }];
    buildInputs = [ ncurses ];
  };

  "icmake" = fetch {
    pname       = "icmake";
    version     = "9.03.01";
    sources     = [{ filename = "icmake-9.03.01-1-x86_64.pkg.tar.xz"; sha256 = "d3ee689eb564a66d04dd807f6945f4d96fdbb938645b25ccc67adc914647c796"; }];
  };

  "icon-naming-utils" = fetch {
    pname       = "icon-naming-utils";
    version     = "0.8.90";
    sources     = [{ filename = "icon-naming-utils-0.8.90-1-x86_64.pkg.tar.xz"; sha256 = "392cd439d442da3d51dd478cafd9c141e8074a53ab28dc3496611bb9985170aa"; }];
    buildInputs = [ perl-XML-Simple ];
  };

  "icu" = fetch {
    pname       = "icu";
    version     = "67.1";
    sources     = [{ filename = "icu-67.1-1-x86_64.pkg.tar.zst"; sha256 = "1306cb00825d798aa83ec100014b2e7f317480084dea0d7adcfc5c24d12a3c3d"; }];
    buildInputs = [ gcc-libs ];
  };

  "icu-devel" = fetch {
    pname       = "icu-devel";
    version     = "67.1";
    sources     = [{ filename = "icu-devel-67.1-1-x86_64.pkg.tar.zst"; sha256 = "f3d4a520b8ef82e428efc4f966886d797d8264387cee8fb814c3a71bc4c65eef"; }];
    buildInputs = [ (assert icu.version=="67.1"; icu) ];
  };

  "idutils" = fetch {
    pname       = "idutils";
    version     = "4.6";
    sources     = [{ filename = "idutils-4.6-2-x86_64.pkg.tar.xz"; sha256 = "dc84aa53e5cd69f98929c5f42129187e1cf5845035d33c148e2f1b512d2549e2"; }];
  };

  "inetutils" = fetch {
    pname       = "inetutils";
    version     = "1.9.4";
    sources     = [{ filename = "inetutils-1.9.4-2-x86_64.pkg.tar.xz"; sha256 = "a155febb11fbfecdad59aea3c4af056b095bf0e3ddfebf7cc4f6694f0235bf53"; }];
    buildInputs = [ gcc-libs libintl libcrypt libreadline ncurses tftp-hpa ];
  };

  "info" = fetch {
    pname       = "info";
    version     = "6.7";
    sources     = [{ filename = "info-6.7-3-x86_64.pkg.tar.zst"; sha256 = "80928b3fdd3fcd39cf78b2b3a5e288f6f4608cf6ed95e5a392960cbb5a5a515a"; }];
    buildInputs = [ gzip libcrypt libintl ncurses ];
  };

  "intltool" = fetch {
    pname       = "intltool";
    version     = "0.51.0";
    sources     = [{ filename = "intltool-0.51.0-2-x86_64.pkg.tar.xz"; sha256 = "1e8e894ab102eede0d703908c0d678a28f95f10a3fcb79fd2e4312392019ecb5"; }];
    buildInputs = [ perl-XML-Parser ];
  };

  "iperf" = fetch {
    pname       = "iperf";
    version     = "2.0.13";
    sources     = [{ filename = "iperf-2.0.13-1-x86_64.pkg.tar.xz"; sha256 = "e39973eb4e61f3cbc1c86b999c872cf449d489fe2adf758579d131a0dcd2bd7d"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "iperf3" = fetch {
    pname       = "iperf3";
    version     = "3.7";
    sources     = [{ filename = "iperf3-3.7-1-x86_64.pkg.tar.xz"; sha256 = "dfc17d909461e5d295bda135e07e54e034dcc3f2babdd508d71340dceff56509"; }];
    buildInputs = [ msys2-runtime gcc-libs openssl ];
  };

  "irssi" = fetch {
    pname       = "irssi";
    version     = "1.2.2";
    sources     = [{ filename = "irssi-1.2.2-2-x86_64.pkg.tar.zst"; sha256 = "4b7fa30179783c716caef9757a1006de33c2fa63c3bf1edcf8b90a28613cfb9e"; }];
    buildInputs = [ openssl gettext perl ncurses glib2 ];
  };

  "isl" = fetch {
    pname       = "isl";
    version     = "0.22.1";
    sources     = [{ filename = "isl-0.22.1-1-x86_64.pkg.tar.xz"; sha256 = "bb75a57d15a7ee3c51c89540b8686a38513bc689422b5c3391c46472f1f6fcec"; }];
    buildInputs = [ gmp ];
  };

  "isl-devel" = fetch {
    pname       = "isl-devel";
    version     = "0.22.1";
    sources     = [{ filename = "isl-devel-0.22.1-1-x86_64.pkg.tar.xz"; sha256 = "e875e1e2d6b6350a3c736745a4cf76917d75fdeca7005178b6e9f91dff0712ba"; }];
    buildInputs = [ (assert isl.version=="0.22.1"; isl) gmp-devel ];
  };

  "itstool" = fetch {
    pname       = "itstool";
    version     = "2.0.6";
    sources     = [{ filename = "itstool-2.0.6-2-x86_64.pkg.tar.zst"; sha256 = "25d65dbbd9cd449012abdf58aa9649d999b8d09d390f7e2d949a491b2849c62e"; }];
    buildInputs = [ python libxml2 libxml2-python ];
  };

  "jansson" = fetch {
    pname       = "jansson";
    version     = "2.13.1";
    sources     = [{ filename = "jansson-2.13.1-1-x86_64.pkg.tar.zst"; sha256 = "b8edf44f052d9fe82a321df44d398a0b610e694d65f2335c67ba03e376f468e0"; }];
  };

  "jansson-devel" = fetch {
    pname       = "jansson-devel";
    version     = "2.13.1";
    sources     = [{ filename = "jansson-devel-2.13.1-1-x86_64.pkg.tar.zst"; sha256 = "312608fd220db21ef56902630672dd28cfe211a47c34612a246cc91569f60555"; }];
    buildInputs = [ (assert jansson.version=="2.13.1"; jansson) ];
  };

  "jsoncpp" = fetch {
    pname       = "jsoncpp";
    version     = "1.9.4";
    sources     = [{ filename = "jsoncpp-1.9.4-1-any.pkg.tar.zst"; sha256 = "3a9aea567d3a3e4dd8b8ca86572cdd98d286ed8b00ca9fd0daec2248b88cb1a5"; }];
    buildInputs = [ gcc-libs ];
  };

  "jsoncpp-devel" = fetch {
    pname       = "jsoncpp-devel";
    version     = "1.9.4";
    sources     = [{ filename = "jsoncpp-devel-1.9.4-1-any.pkg.tar.zst"; sha256 = "c170fe2d6407170d38001d7ce83d8b5293d6bbc8d2e1901919be08d968cf6950"; }];
    buildInputs = [ (assert jsoncpp.version=="1.9.4"; jsoncpp) ];
  };

  "lcov" = fetch {
    pname       = "lcov";
    version     = "1.15";
    sources     = [{ filename = "lcov-1.15-1-any.pkg.tar.zst"; sha256 = "bbffef6615a0acc6cfcf2e7f7aed7acc7cad0976a6a52a60b8066215f9f94285"; }];
    buildInputs = [ perl perl-JSON perl-PerlIO-gzip ];
  };

  "lemon" = fetch {
    pname       = "lemon";
    version     = "3.33.0";
    sources     = [{ filename = "lemon-3.33.0-2-x86_64.pkg.tar.zst"; sha256 = "77ed3c5b3c0cf72f495b90f0d99ec0eca6192eeedc02453e0570692c0ebf108e"; }];
    buildInputs = [ libreadline zlib tcl ];
  };

  "less" = fetch {
    pname       = "less";
    version     = "551";
    sources     = [{ filename = "less-551-1-x86_64.pkg.tar.xz"; sha256 = "490f5fa8caae555836e874593087a2035e30b88c9351ffee6fd252139535e05c"; }];
    buildInputs = [ ncurses libpcre ];
  };

  "lftp" = fetch {
    pname       = "lftp";
    version     = "4.9.1";
    sources     = [{ filename = "lftp-4.9.1-1-x86_64.pkg.tar.xz"; sha256 = "27447ab121b06bb26bec54a79138996cf252f9baf2abb1f3dade1c0587a6a024"; }];
    buildInputs = [ gcc-libs ca-certificates expat gettext libexpat libgnutls libiconv libidn2 libintl libreadline libunistring openssh zlib ];
  };

  "libarchive" = fetch {
    pname       = "libarchive";
    version     = "3.4.3";
    sources     = [{ filename = "libarchive-3.4.3-1-x86_64.pkg.tar.zst"; sha256 = "015fbedde4c5cb4cc4af7390a5cbc4166866da806e5f30e1aa18e7321fbdf196"; }];
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 libnettle libxml2 libzstd zlib ];
  };

  "libarchive-devel" = fetch {
    pname       = "libarchive-devel";
    version     = "3.4.3";
    sources     = [{ filename = "libarchive-devel-3.4.3-1-x86_64.pkg.tar.zst"; sha256 = "78152c8675bd23f24826497e6c63058b39dcbcf6963cdddd54b65decdb693b66"; }];
    buildInputs = [ (assert libarchive.version=="3.4.3"; libarchive) libbz2-devel libiconv-devel liblzma-devel liblz4-devel libnettle-devel libxml2-devel libzstd-devel zlib-devel ];
  };

  "libargp" = fetch {
    pname       = "libargp";
    version     = "20110921";
    sources     = [{ filename = "libargp-20110921-2-x86_64.pkg.tar.xz"; sha256 = "4d0d66c0bcc8c19b5d58245449d0b0d428e96d94db26462bd2662ca9d5bc61b0"; }];
    buildInputs = [  ];
  };

  "libargp-devel" = fetch {
    pname       = "libargp-devel";
    version     = "20110921";
    sources     = [{ filename = "libargp-devel-20110921-2-x86_64.pkg.tar.xz"; sha256 = "160d82b2067a147599bd75a19d58d9818dfbebe8ec938ba5f8f378783d36137c"; }];
    buildInputs = [ (assert libargp.version=="20110921"; libargp) ];
  };

  "libasprintf" = fetch {
    pname       = "libasprintf";
    version     = "0.19.8.1";
    sources     = [{ filename = "libasprintf-0.19.8.1-1-x86_64.pkg.tar.xz"; sha256 = "bcf2d52192741590c5f0fd98fa9192f1c1243f67f06fe838b914cf9bce3ed99f"; }];
    buildInputs = [ gcc-libs ];
  };

  "libassuan" = fetch {
    pname       = "libassuan";
    version     = "2.5.3";
    sources     = [{ filename = "libassuan-2.5.3-1-x86_64.pkg.tar.xz"; sha256 = "358880a2cebd816731eb898cb9cf72b18892cb5fbec2c5310ef2099301268da7"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libassuan-devel" = fetch {
    pname       = "libassuan-devel";
    version     = "2.5.3";
    sources     = [{ filename = "libassuan-devel-2.5.3-1-x86_64.pkg.tar.xz"; sha256 = "9f20edcd49c5905d85177ea57345bb011f0d9201d806c4c1644af2e04f59e622"; }];
    buildInputs = [ (assert libassuan.version=="2.5.3"; libassuan) libgpg-error-devel ];
  };

  "libatomic_ops" = fetch {
    pname       = "libatomic_ops";
    version     = "7.6.10";
    sources     = [{ filename = "libatomic_ops-7.6.10-1-any.pkg.tar.xz"; sha256 = "d0478b9d4f35f74056d875a1b42186e08caf295a1f3c5cf53c4160bf4b1d8843"; }];
    buildInputs = [  ];
  };

  "libatomic_ops-devel" = fetch {
    pname       = "libatomic_ops-devel";
    version     = "7.6.10";
    sources     = [{ filename = "libatomic_ops-devel-7.6.10-1-any.pkg.tar.xz"; sha256 = "8a565bdb7864408f883c214bdfe438d190811ee19c4b9758a311403a3c975a2f"; }];
    buildInputs = [ (assert libatomic_ops.version=="7.6.10"; libatomic_ops) ];
  };

  "libbobcat" = fetch {
    pname       = "libbobcat";
    version     = "5.05.00";
    sources     = [{ filename = "libbobcat-5.05.00-1-x86_64.pkg.tar.zst"; sha256 = "a54f90be1358e5aa08061d5f1927f8ebc5a5ade912fddc3255a96781613c5a50"; }];
    buildInputs = [ gcc-libs ];
  };

  "libbobcat-devel" = fetch {
    pname       = "libbobcat-devel";
    version     = "5.05.00";
    sources     = [{ filename = "libbobcat-devel-5.05.00-1-x86_64.pkg.tar.zst"; sha256 = "6a78aea2010365659539a88c2047ee4e2dbd9720aa8687f1ad839d3f14837503"; }];
    buildInputs = [ (assert libbobcat.version=="5.05.00"; libbobcat) ];
  };

  "libbz2" = fetch {
    pname       = "libbz2";
    version     = "1.0.8";
    sources     = [{ filename = "libbz2-1.0.8-2-x86_64.pkg.tar.xz"; sha256 = "f31f91c0649ff1cd2292fb79ce19d818a43ac40039bb2cfaf94195ad52fed8bc"; }];
    buildInputs = [ gcc-libs ];
  };

  "libbz2-devel" = fetch {
    pname       = "libbz2-devel";
    version     = "1.0.8";
    sources     = [{ filename = "libbz2-devel-1.0.8-2-x86_64.pkg.tar.xz"; sha256 = "1d03c41e0d2c62185ab0029ad84db465fffac2849a6b072a56a9c9636b9ca78d"; }];
    buildInputs = [ (assert libbz2.version=="1.0.8"; libbz2) ];
  };

  "libcares" = fetch {
    pname       = "libcares";
    version     = "1.16.1";
    sources     = [{ filename = "libcares-1.16.1-1-x86_64.pkg.tar.zst"; sha256 = "7440ad543ec5cc9f1ae8e398bae417dbdc84f304ac419ec23c5e5a6bc27c6e95"; }];
    buildInputs = [ gcc-libs ];
  };

  "libcares-devel" = fetch {
    pname       = "libcares-devel";
    version     = "1.16.1";
    sources     = [{ filename = "libcares-devel-1.16.1-1-x86_64.pkg.tar.zst"; sha256 = "70f50f79d31a9f9c051812e5c0660574870fcdb4ab7df35d8b8a838d1999a01a"; }];
    buildInputs = [ (assert libcares.version=="1.16.1"; libcares) ];
  };

  "libcrypt" = fetch {
    pname       = "libcrypt";
    version     = "2.1";
    sources     = [{ filename = "libcrypt-2.1-2-x86_64.pkg.tar.xz"; sha256 = "333b5089ea0d27c167e7bcf786bf0ceb2192d76c18f338379d771adda18bda3e"; }];
    buildInputs = [ gcc-libs ];
  };

  "libcrypt-devel" = fetch {
    pname       = "libcrypt-devel";
    version     = "2.1";
    sources     = [{ filename = "libcrypt-devel-2.1-2-x86_64.pkg.tar.xz"; sha256 = "424348d6ccb542f072598f32321ea48df62481f0a7ee48060694df58dbbcaeda"; }];
    buildInputs = [ (assert libcrypt.version=="2.1"; libcrypt) ];
  };

  "libcurl" = fetch {
    pname       = "libcurl";
    version     = "7.71.1";
    sources     = [{ filename = "libcurl-7.71.1-1-x86_64.pkg.tar.zst"; sha256 = "e52348f2746c0d5e5bcebe84f7aaa14230215f4c5af8bcc49c57769ba937050b"; }];
    buildInputs = [ brotli ca-certificates heimdal-libs libcrypt libidn2 libmetalink libunistring libnghttp2 libpsl libssh2 openssl zlib ];
  };

  "libcurl-devel" = fetch {
    pname       = "libcurl-devel";
    version     = "7.71.1";
    sources     = [{ filename = "libcurl-devel-7.71.1-1-x86_64.pkg.tar.zst"; sha256 = "8ebcad123591736419c8315b41385bc2eb23778c26151f0d2b18727a7d44d2d8"; }];
    buildInputs = [ (assert libcurl.version=="7.71.1"; libcurl) brotli-devel heimdal-devel libcrypt-devel libidn2-devel libmetalink-devel libunistring-devel libnghttp2-devel libpsl-devel libssh2-devel openssl-devel zlib-devel ];
  };

  "libdb" = fetch {
    pname       = "libdb";
    version     = "5.3.28";
    sources     = [{ filename = "libdb-5.3.28-3-x86_64.pkg.tar.zst"; sha256 = "00caef39902d34112fe9f9e5f9aad063cbde3922c212558ce4cec5f8c33534ee"; }];
    buildInputs = [ gcc-libs ];
  };

  "libdb-devel" = fetch {
    pname       = "libdb-devel";
    version     = "5.3.28";
    sources     = [{ filename = "libdb-devel-5.3.28-3-x86_64.pkg.tar.zst"; sha256 = "b89f85cf04fc9244fda2ee7c965d189aeb8254c44754887c7abadd6ba78e6221"; }];
    buildInputs = [ (assert libdb.version=="5.3.28"; libdb) ];
  };

  "libedit" = fetch {
    pname       = "libedit";
    version     = "20191231_3.1";
    sources     = [{ filename = "libedit-20191231_3.1-1-x86_64.pkg.tar.xz"; sha256 = "236bedb6a8a90c0ecb70c1bc9c90ccd347f2f1ae96df11aa9af8e6878a606fe3"; }];
    buildInputs = [ msys2-runtime ncurses sh ];
  };

  "libedit-devel" = fetch {
    pname       = "libedit-devel";
    version     = "20191231_3.1";
    sources     = [{ filename = "libedit-devel-20191231_3.1-1-x86_64.pkg.tar.xz"; sha256 = "050f8240643646de6f13410d1971aab8ab45d73ca96e636d3b0c0c6f99e1cf07"; }];
    buildInputs = [ (assert libedit.version=="20191231_3.1"; libedit) ncurses-devel ];
  };

  "libelf" = fetch {
    pname       = "libelf";
    version     = "0.8.13";
    sources     = [{ filename = "libelf-0.8.13-2-x86_64.pkg.tar.xz"; sha256 = "d9c8369c00ae9b281f37bd3700aed599f3b2f31cfbabe5d83a0c9b44621ab4b9"; }];
    buildInputs = [ gcc-libs ];
  };

  "libelf-devel" = fetch {
    pname       = "libelf-devel";
    version     = "0.8.13";
    sources     = [{ filename = "libelf-devel-0.8.13-2-x86_64.pkg.tar.xz"; sha256 = "3af95efcdf6b13f6265b5a56efd960dae406b092dfd7b1a05df6a4f8992666e3"; }];
    buildInputs = [ (assert libelf.version=="0.8.13"; libelf) ];
  };

  "libevent" = fetch {
    pname       = "libevent";
    version     = "2.1.12";
    sources     = [{ filename = "libevent-2.1.12-1-x86_64.pkg.tar.zst"; sha256 = "d71b72a2c58904e043be0df6ba1a94fd0501a1dad58bd83b3f09f47dfaae1d83"; }];
    buildInputs = [ openssl ];
  };

  "libevent-devel" = fetch {
    pname       = "libevent-devel";
    version     = "2.1.12";
    sources     = [{ filename = "libevent-devel-2.1.12-1-x86_64.pkg.tar.zst"; sha256 = "dea1a9f9e2f451fa69b9b453db7c4078ee04bdcae85b528a2dd280d99ad93c10"; }];
    buildInputs = [ (assert libevent.version=="2.1.12"; libevent) openssl-devel ];
  };

  "libexpat" = fetch {
    pname       = "libexpat";
    version     = "2.2.9";
    sources     = [{ filename = "libexpat-2.2.9-1-x86_64.pkg.tar.xz"; sha256 = "cafa0584d1160e78312d4189cab446d5183184c7e28e3edf89020825d53bc634"; }];
    buildInputs = [ gcc-libs ];
  };

  "libexpat-devel" = fetch {
    pname       = "libexpat-devel";
    version     = "2.2.9";
    sources     = [{ filename = "libexpat-devel-2.2.9-1-x86_64.pkg.tar.xz"; sha256 = "5a73ccb2f770ca0d320910b85c32dda66bcce38d8bd00e1e7e8064ae8f5056c3"; }];
    buildInputs = [ (assert libexpat.version=="2.2.9"; libexpat) ];
  };

  "libffi" = fetch {
    pname       = "libffi";
    version     = "3.3";
    sources     = [{ filename = "libffi-3.3-1-x86_64.pkg.tar.xz"; sha256 = "06e9f64dc7832498caee7d02a3e4877749319b64339268fcc8e3b7c6fb4d8580"; }];
    buildInputs = [  ];
  };

  "libffi-devel" = fetch {
    pname       = "libffi-devel";
    version     = "3.3";
    sources     = [{ filename = "libffi-devel-3.3-1-x86_64.pkg.tar.xz"; sha256 = "20a092917a7648f9ed1de4bb9782a8e9757e0899b59eedbacbfde99557caeed1"; }];
    buildInputs = [ (assert libffi.version=="3.3"; libffi) ];
  };

  "libgc" = fetch {
    pname       = "libgc";
    version     = "8.0.4";
    sources     = [{ filename = "libgc-8.0.4-1-x86_64.pkg.tar.zst"; sha256 = "b8fe0c689efc3c09989af5f668f9d912525d9c946e1c068f2bc6c91aa777ddc4"; }];
    buildInputs = [ libatomic_ops gcc-libs ];
  };

  "libgc-devel" = fetch {
    pname       = "libgc-devel";
    version     = "8.0.4";
    sources     = [{ filename = "libgc-devel-8.0.4-1-x86_64.pkg.tar.zst"; sha256 = "8a7ff71809eb51f08232c53b93a5a3d1f0c3b3c2b58b2bd4ccb068108f3b97ba"; }];
    buildInputs = [ (assert libgc.version=="8.0.4"; libgc) libatomic_ops-devel ];
  };

  "libgcrypt" = fetch {
    pname       = "libgcrypt";
    version     = "1.8.6";
    sources     = [{ filename = "libgcrypt-1.8.6-1-x86_64.pkg.tar.zst"; sha256 = "078c135b52284870a4a5126ca971bbafae76b12b4a0f8c8561833a351d7d572a"; }];
    buildInputs = [ libgpg-error ];
  };

  "libgcrypt-devel" = fetch {
    pname       = "libgcrypt-devel";
    version     = "1.8.6";
    sources     = [{ filename = "libgcrypt-devel-1.8.6-1-x86_64.pkg.tar.zst"; sha256 = "9bbf3685514c170de1e746a483cd3ceda69aabf87cf6bb30f59673a3d133ca28"; }];
    buildInputs = [ (assert libgcrypt.version=="1.8.6"; libgcrypt) libgpg-error-devel ];
  };

  "libgdbm" = fetch {
    pname       = "libgdbm";
    version     = "1.18.1";
    sources     = [{ filename = "libgdbm-1.18.1-3-x86_64.pkg.tar.zst"; sha256 = "a86ed0af2917e548da4e52198b1d96bacef5f4e063e9c1fecb0e570ce4d26ba1"; }];
    buildInputs = [ gcc-libs libreadline ];
  };

  "libgdbm-devel" = fetch {
    pname       = "libgdbm-devel";
    version     = "1.18.1";
    sources     = [{ filename = "libgdbm-devel-1.18.1-3-x86_64.pkg.tar.zst"; sha256 = "f8f88f7dfcffed64dcb911348afa2b82c346403cc98224e23190472f61abb084"; }];
    buildInputs = [ (assert libgdbm.version=="1.18.1"; libgdbm) libreadline-devel ];
  };

  "libgettextpo" = fetch {
    pname       = "libgettextpo";
    version     = "0.19.8.1";
    sources     = [{ filename = "libgettextpo-0.19.8.1-1-x86_64.pkg.tar.xz"; sha256 = "7ce26ed0d71395a1fb1b1813be8e2bbc2e05f06fb45645c59c305841ba0d10e2"; }];
    buildInputs = [ gcc-libs ];
  };

  "libgnutls" = fetch {
    pname       = "libgnutls";
    version     = "3.6.14";
    sources     = [{ filename = "libgnutls-3.6.14-1-x86_64.pkg.tar.zst"; sha256 = "ec3a6adca3b128f3749a96b2b0f37b219fc710527f8f98e062aa1dd5e1b5c01d"; }];
    buildInputs = [ gcc-libs libidn2 libiconv libintl gmp libnettle libp11-kit libtasn1 zlib ];
  };

  "libgnutls-devel" = fetch {
    pname       = "libgnutls-devel";
    version     = "3.6.14";
    sources     = [{ filename = "libgnutls-devel-3.6.14-1-x86_64.pkg.tar.zst"; sha256 = "3ed8b3abbd4969ded1ac7b2ecf3adf54ee9dad4356994cb5a5a85ae8d3ef09fe"; }];
    buildInputs = [ (assert libgnutls.version=="3.6.14"; libgnutls) ];
  };

  "libgpg-error" = fetch {
    pname       = "libgpg-error";
    version     = "1.38";
    sources     = [{ filename = "libgpg-error-1.38-1-x86_64.pkg.tar.zst"; sha256 = "2ba6836425507ceca6ec282be976e7223f17c0477490db07653932aa495f5f98"; }];
    buildInputs = [ msys2-runtime sh libiconv libintl ];
  };

  "libgpg-error-devel" = fetch {
    pname       = "libgpg-error-devel";
    version     = "1.38";
    sources     = [{ filename = "libgpg-error-devel-1.38-1-x86_64.pkg.tar.zst"; sha256 = "32a4c05ce159549b2f6de2f49c3b7a40066748b13142ff2f11bcdea47e65b0cf"; }];
    buildInputs = [ libiconv-devel gettext-devel ];
  };

  "libgpgme" = fetch {
    pname       = "libgpgme";
    version     = "1.14.0";
    sources     = [{ filename = "libgpgme-1.14.0-2-x86_64.pkg.tar.zst"; sha256 = "9fd967fb197ad7a37be8cd8570495d25cab7113bf329a378dcca254997b760bb"; }];
    buildInputs = [ libassuan libgpg-error gnupg ];
  };

  "libgpgme-devel" = fetch {
    pname       = "libgpgme-devel";
    version     = "1.14.0";
    sources     = [{ filename = "libgpgme-devel-1.14.0-2-x86_64.pkg.tar.zst"; sha256 = "6b491dd65e7e87f6240cdec8b36ee0d75250eaf00b1dae6424406d289301f7f2"; }];
    buildInputs = [ (assert libgpgme.version=="1.14.0"; libgpgme) libassuan-devel libgpg-error-devel ];
  };

  "libgpgme-python" = fetch {
    pname       = "libgpgme-python";
    version     = "1.14.0";
    sources     = [{ filename = "libgpgme-python-1.14.0-2-x86_64.pkg.tar.zst"; sha256 = "03cc3f5f8d3c4a4385e9aa3e9f24de227fdc17663561f0c00ca97422951e540d"; }];
    buildInputs = [ (assert libgpgme.version=="1.14.0"; libgpgme) python ];
  };

  "libguile" = fetch {
    pname       = "libguile";
    version     = "2.2.7";
    sources     = [{ filename = "libguile-2.2.7-1-x86_64.pkg.tar.xz"; sha256 = "888c0087bd1ef2893d8d1b132bbd4a9f547df37c401c4e75952bc2172c00fbb4"; }];
    buildInputs = [ gmp libltdl ncurses libunistring libgc libffi ];
  };

  "libguile-devel" = fetch {
    pname       = "libguile-devel";
    version     = "2.2.7";
    sources     = [{ filename = "libguile-devel-2.2.7-1-x86_64.pkg.tar.xz"; sha256 = "375954935e022a28ed53db3945023dc0406a9803ba425be46ee3e5bfff1688bf"; }];
    buildInputs = [ (assert libguile.version=="2.2.7"; libguile) ];
  };

  "libhogweed" = fetch {
    pname       = "libhogweed";
    version     = "3.6";
    sources     = [{ filename = "libhogweed-3.6-1-x86_64.pkg.tar.zst"; sha256 = "82fff1ebb15f64a7186f01191c36e133ae9e67831597b3f978523d8d6816bc1f"; }];
    buildInputs = [ gmp ];
  };

  "libiconv-devel" = fetch {
    pname       = "libiconv-devel";
    version     = "1.16";
    sources     = [{ filename = "libiconv-devel-1.16-2-x86_64.pkg.tar.zst"; sha256 = "7443a3f7c5c7c8fb7d3d4993b37480b454608a32eb56e54e22e93053f66dbe47"; }];
    buildInputs = [ (assert libiconv.version=="1.16"; libiconv) ];
  };

  "libidn" = fetch {
    pname       = "libidn";
    version     = "1.35";
    sources     = [{ filename = "libidn-1.35-1-x86_64.pkg.tar.xz"; sha256 = "f436d30f6ae1f6c8bc74d456dc3a6d54a4c8abbab9649b2acf020681c12f4095"; }];
    buildInputs = [ info ];
  };

  "libidn-devel" = fetch {
    pname       = "libidn-devel";
    version     = "1.35";
    sources     = [{ filename = "libidn-devel-1.35-1-x86_64.pkg.tar.xz"; sha256 = "711c69fb1a62627b1088f1c6b58c705c89f586dabb36cbfce10ec77d790a7019"; }];
    buildInputs = [ (assert libidn.version=="1.35"; libidn) ];
  };

  "libidn2" = fetch {
    pname       = "libidn2";
    version     = "2.3.0";
    sources     = [{ filename = "libidn2-2.3.0-1-x86_64.pkg.tar.xz"; sha256 = "f1320fcb0a745b228ef98fdfc3cf9adc618a2794d2dcd962148046a24dd31b2c"; }];
    buildInputs = [ info libunistring ];
  };

  "libidn2-devel" = fetch {
    pname       = "libidn2-devel";
    version     = "2.3.0";
    sources     = [{ filename = "libidn2-devel-2.3.0-1-x86_64.pkg.tar.xz"; sha256 = "38660a261c522c3c05ed4fa742fcf6bf128ae5d2b1d309169567cad7a74643e8"; }];
    buildInputs = [ (assert libidn2.version=="2.3.0"; libidn2) ];
  };

  "libiconv+libintl" = fetch {
    pname       = "libiconv+libintl";
    version     = "1.16+0.19.8.1";
    sources     = [{ filename = "libiconv-1.16-2-x86_64.pkg.tar.zst";   sha256 = "4d23674f25e9d558295464b4f50689698f8ce240616410da9a4d9420b5130ced"; } 
                   { filename = "libintl-0.19.8.1-1-x86_64.pkg.tar.xz"; sha256 = "5eadc3cc42da78948d65d994f1f8326706afe011f28e2e5bd0872a37612072d2"; }];
    buildInputs = [ gcc-libs ];
  };

  "libiconv" = self."libiconv+libintl";
  "libintl" = self."libiconv+libintl";

  "libksba" = fetch {
    pname       = "libksba";
    version     = "1.4.0";
    sources     = [{ filename = "libksba-1.4.0-1-x86_64.pkg.tar.zst"; sha256 = "baca5c6019ec247dc3cdc65b0e3644fb3adc4475d6df3611b15295894ace50c6"; }];
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libksba-devel" = fetch {
    pname       = "libksba-devel";
    version     = "1.4.0";
    sources     = [{ filename = "libksba-devel-1.4.0-1-x86_64.pkg.tar.zst"; sha256 = "0bd1f7598b46464c165f10e4530c76f91e5c9e092d18dd100c4f4ae38e4e176b"; }];
    buildInputs = [ (assert libksba.version=="1.4.0"; libksba) libgpg-error-devel ];
  };

  "libltdl" = fetch {
    pname       = "libltdl";
    version     = "2.4.6";
    sources     = [{ filename = "libltdl-2.4.6-9-x86_64.pkg.tar.xz"; sha256 = "e2a120ab0682da676c9b6bff3c409ae7f80c57547758b9d38a0d0979e5571d48"; }];
    buildInputs = [  ];
  };

  "liblz4" = fetch {
    pname       = "liblz4";
    version     = "1.9.2";
    sources     = [{ filename = "liblz4-1.9.2-1-x86_64.pkg.tar.xz"; sha256 = "752ffd153eef31f9d65d842726bb6d2dde8facb777f48ef472934c1f74e2fd02"; }];
    buildInputs = [ gcc-libs ];
  };

  "liblz4-devel" = fetch {
    pname       = "liblz4-devel";
    version     = "1.9.2";
    sources     = [{ filename = "liblz4-devel-1.9.2-1-x86_64.pkg.tar.xz"; sha256 = "ba64e6dd62087f0c6babc0644117c88700ae525c20d2a1055741ec8c6f010b7f"; }];
    buildInputs = [ (assert liblz4.version=="1.9.2"; liblz4) ];
  };

  "liblzma" = fetch {
    pname       = "liblzma";
    version     = "5.2.5";
    sources     = [{ filename = "liblzma-5.2.5-1-x86_64.pkg.tar.xz"; sha256 = "c703c81818120c6576bea45316f0ebab09ddef87365eec374fb3481b7d59aec5"; }];
    buildInputs = [ sh libiconv gettext ];
  };

  "liblzma-devel" = fetch {
    pname       = "liblzma-devel";
    version     = "5.2.5";
    sources     = [{ filename = "liblzma-devel-5.2.5-1-x86_64.pkg.tar.xz"; sha256 = "620b6352c5f1b3255b3921ebf2335aa77deccb3176dee05a0721467ff8109282"; }];
    buildInputs = [ (assert liblzma.version=="5.2.5"; liblzma) libiconv-devel gettext-devel ];
  };

  "liblzo2" = fetch {
    pname       = "liblzo2";
    version     = "2.10";
    sources     = [{ filename = "liblzo2-2.10-2-x86_64.pkg.tar.xz"; sha256 = "f85803aaff60e0bc8c618bed642e15fe7ab1a76acd212d90a8e7c23e076d0ff6"; }];
    buildInputs = [ gcc-libs ];
  };

  "liblzo2-devel" = fetch {
    pname       = "liblzo2-devel";
    version     = "2.10";
    sources     = [{ filename = "liblzo2-devel-2.10-2-x86_64.pkg.tar.xz"; sha256 = "6d2ee9f39c51afa04396e3564bee1a08b9d14e8eab2f14c6e9675ef0cf813c57"; }];
    buildInputs = [ (assert liblzo2.version=="2.10"; liblzo2) ];
  };

  "libmetalink" = fetch {
    pname       = "libmetalink";
    version     = "0.1.3";
    sources     = [{ filename = "libmetalink-0.1.3-3-x86_64.pkg.tar.zst"; sha256 = "a2560d945f431f16d04e96384ad34f482772c1f5dd99298b2b25072c0e64d803"; }];
    buildInputs = [ libexpat sh libxml2 ];
  };

  "libmetalink-devel" = fetch {
    pname       = "libmetalink-devel";
    version     = "0.1.3";
    sources     = [{ filename = "libmetalink-devel-0.1.3-3-x86_64.pkg.tar.zst"; sha256 = "b8e09a30814ea98c3cb23afa4e97f0be794030a963fb434056d7e159d0c2887d"; }];
    buildInputs = [ (assert libmetalink.version=="0.1.3"; libmetalink) libexpat-devel ];
  };

  "libneon" = fetch {
    pname       = "libneon";
    version     = "0.31.2";
    sources     = [{ filename = "libneon-0.31.2-1-x86_64.pkg.tar.zst"; sha256 = "eabf7a177a66a081acbb4bd73eab2fdb4cedeb9783780f428dd67cc8bde7f4e7"; }];
    buildInputs = [ libexpat openssl ca-certificates ];
  };

  "libneon-devel" = fetch {
    pname       = "libneon-devel";
    version     = "0.31.2";
    sources     = [{ filename = "libneon-devel-0.31.2-1-x86_64.pkg.tar.zst"; sha256 = "8021c025f6c420ba27790f9567c9af5fed990232328ded190088fa181c742c78"; }];
    buildInputs = [ (assert libneon.version=="0.31.2"; libneon) libexpat-devel openssl-devel ];
  };

  "libnettle" = fetch {
    pname       = "libnettle";
    version     = "3.6";
    sources     = [{ filename = "libnettle-3.6-1-x86_64.pkg.tar.zst"; sha256 = "dceb38be098fcd4dc0a077365e433d593d76f68d75719155439088d829cd7800"; }];
    buildInputs = [ libhogweed ];
  };

  "libnettle-devel" = fetch {
    pname       = "libnettle-devel";
    version     = "3.6";
    sources     = [{ filename = "libnettle-devel-3.6-1-x86_64.pkg.tar.zst"; sha256 = "f3b7a924f92259f075a6d233dc3a29c1d1b7201fc1d1fa542edc49c18e7b3b92"; }];
    buildInputs = [ (assert libnettle.version=="3.6"; libnettle) (assert libhogweed.version=="3.6"; libhogweed) gmp-devel ];
  };

  "libnghttp2" = fetch {
    pname       = "libnghttp2";
    version     = "1.41.0";
    sources     = [{ filename = "libnghttp2-1.41.0-1-x86_64.pkg.tar.zst"; sha256 = "185750dfea1b0c95d99a80aae1ce6228e13309129e1765a0e7cb96c0f391e37e"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnghttp2-devel" = fetch {
    pname       = "libnghttp2-devel";
    version     = "1.41.0";
    sources     = [{ filename = "libnghttp2-devel-1.41.0-1-x86_64.pkg.tar.zst"; sha256 = "d0dd4398c4a218162a5ed768291fa11bfc1b154114994d185c76580904fdc465"; }];
    buildInputs = [ (assert libnghttp2.version=="1.41.0"; libnghttp2) jansson-devel libevent-devel openssl-devel libcares-devel ];
  };

  "libnpth" = fetch {
    pname       = "libnpth";
    version     = "1.6";
    sources     = [{ filename = "libnpth-1.6-1-x86_64.pkg.tar.xz"; sha256 = "fe32612e363976dfe157d3a70f8af7aeca4e347abc5294e95cdd3d9a7aea5e68"; }];
    buildInputs = [ gcc-libs ];
  };

  "libnpth-devel" = fetch {
    pname       = "libnpth-devel";
    version     = "1.6";
    sources     = [{ filename = "libnpth-devel-1.6-1-x86_64.pkg.tar.xz"; sha256 = "8325ecaaa04c7e21c461b141e1c3b1d2ac754892a9f6ca9091efe864446789ee"; }];
    buildInputs = [ (assert libnpth.version=="1.6"; libnpth) ];
  };

  "libopenssl" = fetch {
    pname       = "libopenssl";
    version     = "1.1.1.g";
    sources     = [{ filename = "libopenssl-1.1.1.g-3-x86_64.pkg.tar.zst"; sha256 = "1c33bc8b42ca94cce1c6aae148a9253c516406907d26ef0b12fcde78059e3164"; }];
    buildInputs = [ zlib ];
  };

  "libp11-kit" = fetch {
    pname       = "libp11-kit";
    version     = "0.23.20";
    sources     = [{ filename = "libp11-kit-0.23.20-2-x86_64.pkg.tar.xz"; sha256 = "44425f689f5b0b40873a8605da8608a51c00d4183381bcae99a68b9a64a062fc"; }];
    buildInputs = [ libffi libintl libtasn1 glib2 ];
  };

  "libp11-kit-devel" = fetch {
    pname       = "libp11-kit-devel";
    version     = "0.23.20";
    sources     = [{ filename = "libp11-kit-devel-0.23.20-2-x86_64.pkg.tar.xz"; sha256 = "de0366dc68048fe90435f703fc6965987eb9e2885d727d445fdab48839a0dd72"; }];
    buildInputs = [ (assert libp11-kit.version=="0.23.20"; libp11-kit) ];
  };

  "libpcre" = fetch {
    pname       = "libpcre";
    version     = "8.44";
    sources     = [{ filename = "libpcre-8.44-1-x86_64.pkg.tar.xz"; sha256 = "c4fd9602989bb7b6963a8c5c25c89941eef79d28e10ca91415c7feb3831b1e27"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre16" = fetch {
    pname       = "libpcre16";
    version     = "8.44";
    sources     = [{ filename = "libpcre16-8.44-1-x86_64.pkg.tar.xz"; sha256 = "56c60a49cf8f4df47a83401d22e77d72522675927124bcfba238814b598d8f08"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_16" = fetch {
    pname       = "libpcre2_16";
    version     = "10.35";
    sources     = [{ filename = "libpcre2_16-10.35-1-x86_64.pkg.tar.zst"; sha256 = "c9cffd0fd89088d2d0bfad9909cb047e0aae7ff18dbc7f78db24dbdd3d85bcb6"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_32" = fetch {
    pname       = "libpcre2_32";
    version     = "10.35";
    sources     = [{ filename = "libpcre2_32-10.35-1-x86_64.pkg.tar.zst"; sha256 = "7331de63cef66c315ae8a8e4adc6d1628be44c8e10de69de50adbf0ef52e2922"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_8" = fetch {
    pname       = "libpcre2_8";
    version     = "10.35";
    sources     = [{ filename = "libpcre2_8-10.35-1-x86_64.pkg.tar.zst"; sha256 = "ea6fea983fdaaae278941ccdedaa0cefb62329858e66d7ccabccf596bc5736b8"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcre2posix" = fetch {
    pname       = "libpcre2posix";
    version     = "10.35";
    sources     = [{ filename = "libpcre2posix-10.35-1-x86_64.pkg.tar.zst"; sha256 = "1873d9857d8d52789b4ac0e9e4074a80b030620db249a009a157ae3377ac1f3d"; }];
    buildInputs = [ (assert libpcre2_8.version=="10.35"; libpcre2_8) ];
  };

  "libpcre32" = fetch {
    pname       = "libpcre32";
    version     = "8.44";
    sources     = [{ filename = "libpcre32-8.44-1-x86_64.pkg.tar.xz"; sha256 = "f6d2af2721f717a9935dba1c3706a20ce542b51d9435c650516c042ca790d26d"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpcrecpp" = fetch {
    pname       = "libpcrecpp";
    version     = "8.44";
    sources     = [{ filename = "libpcrecpp-8.44-1-x86_64.pkg.tar.xz"; sha256 = "c5bba615d6f14f69cb4aa59e47f09b7e31ecd94fa31906df1a032d0825075656"; }];
    buildInputs = [ libpcre gcc-libs ];
  };

  "libpcreposix" = fetch {
    pname       = "libpcreposix";
    version     = "8.44";
    sources     = [{ filename = "libpcreposix-8.44-1-x86_64.pkg.tar.xz"; sha256 = "a2a986bd598adae25a8f188151121acf7a7bb7a8beb3022c8e219b0f2b6787bd"; }];
    buildInputs = [ libpcre ];
  };

  "libpipeline" = fetch {
    pname       = "libpipeline";
    version     = "1.5.2";
    sources     = [{ filename = "libpipeline-1.5.2-1-x86_64.pkg.tar.xz"; sha256 = "13879b9fa2df4548539b6fad1085ad06e5a1dfedf6b8e437e96c3f2d57c6b99b"; }];
    buildInputs = [ gcc-libs ];
  };

  "libpipeline-devel" = fetch {
    pname       = "libpipeline-devel";
    version     = "1.5.2";
    sources     = [{ filename = "libpipeline-devel-1.5.2-1-x86_64.pkg.tar.xz"; sha256 = "dee22a598e15f2ed3da9a4bab78f91edd7da7fe2b550ce0b543d399fa7e6f910"; }];
    buildInputs = [ (assert libpipeline.version=="1.5.2"; libpipeline) ];
  };

  "libpsl" = fetch {
    pname       = "libpsl";
    version     = "0.21.0";
    sources     = [{ filename = "libpsl-0.21.0-1-x86_64.pkg.tar.xz"; sha256 = "5111cb61532f392cfa527a46b95b9fd6294e08c0d1e45991f2692c9f25e763fb"; }];
    buildInputs = [ libxslt libidn2 libunistring ];
  };

  "libpsl-devel" = fetch {
    pname       = "libpsl-devel";
    version     = "0.21.0";
    sources     = [{ filename = "libpsl-devel-0.21.0-1-x86_64.pkg.tar.xz"; sha256 = "e242ce727b63091656c839072099f7978db73bf13c94a66ed0e5b29886b43306"; }];
    buildInputs = [ (assert libpsl.version=="0.21.0"; libpsl) libxslt libidn2-devel libunistring ];
  };

  "libqrencode" = fetch {
    pname       = "libqrencode";
    version     = "4.1.1";
    sources     = [{ filename = "libqrencode-4.1.1-1-x86_64.pkg.tar.zst"; sha256 = "7cad32dbf805c2ad9356e3472765282a96c54c260224ecf709a8f2b7bdd0c563"; }];
  };

  "libqrencode-devel" = fetch {
    pname       = "libqrencode-devel";
    version     = "4.1.1";
    sources     = [{ filename = "libqrencode-devel-4.1.1-1-x86_64.pkg.tar.zst"; sha256 = "d0d4ffd474cb0c299618e62ae1961d03329b12a4eb8e04f5b77e26f0a2ca0c60"; }];
    buildInputs = [ (assert libqrencode.version=="4.1.1"; libqrencode) ];
  };

  "libreadline" = fetch {
    pname       = "libreadline";
    version     = "8.0.004";
    sources     = [{ filename = "libreadline-8.0.004-1-x86_64.pkg.tar.xz"; sha256 = "1175428c8f668f987c84c0345c6f8e511e1bc741ba3a7d60886b7ee2e392f784"; }];
    buildInputs = [ ncurses ];
  };

  "libreadline-devel" = fetch {
    pname       = "libreadline-devel";
    version     = "8.0.004";
    sources     = [{ filename = "libreadline-devel-8.0.004-1-x86_64.pkg.tar.xz"; sha256 = "336429664e2c332539d2cb989c91f62060c9eb1134853d910dfb2a1fe75fbe8b"; }];
    buildInputs = [ (assert libreadline.version=="8.0.004"; libreadline) ncurses-devel ];
  };

  "librhash" = fetch {
    pname       = "librhash";
    version     = "1.3.9";
    sources     = [{ filename = "librhash-1.3.9-1-x86_64.pkg.tar.xz"; sha256 = "f93f5a1d6507f6bc73f69cc2a21032cab62cd3b52230a8c57e3fa4043816e85c"; }];
    buildInputs = [ libopenssl gcc-libs ];
  };

  "librhash-devel" = fetch {
    pname       = "librhash-devel";
    version     = "1.3.9";
    sources     = [{ filename = "librhash-devel-1.3.9-1-x86_64.pkg.tar.xz"; sha256 = "6c9804894c5ce8178d09a811462aa8ae6d05faebb8b4a6b72c0d882c2a43b94f"; }];
    buildInputs = [ (assert librhash.version=="1.3.9"; librhash) ];
  };

  "libsasl" = fetch {
    pname       = "libsasl";
    version     = "2.1.27";
    sources     = [{ filename = "libsasl-2.1.27-1-x86_64.pkg.tar.xz"; sha256 = "f9cea8f5dbe2e6e36adc069bcaeba02e33cdabb6b0babe018d8eb82cdca6011f"; }];
    buildInputs = [ libcrypt libopenssl heimdal-libs libsqlite ];
  };

  "libsasl-devel" = fetch {
    pname       = "libsasl-devel";
    version     = "2.1.27";
    sources     = [{ filename = "libsasl-devel-2.1.27-1-x86_64.pkg.tar.xz"; sha256 = "9acd7234fe562a7bc268100453d277cffe05dca25e153445b1d3fd52a1c4ef6f"; }];
    buildInputs = [ (assert libsasl.version=="2.1.27"; libsasl) heimdal-devel openssl-devel libsqlite-devel libcrypt-devel ];
  };

  "libserf" = fetch {
    pname       = "libserf";
    version     = "1.3.9";
    sources     = [{ filename = "libserf-1.3.9-5-x86_64.pkg.tar.xz"; sha256 = "cdf4c89e17e1620c2a9c18da28eae294ec883bbfe67adce26f7eed9462aae2e6"; }];
    buildInputs = [ apr-util libopenssl zlib ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "libserf-devel" = fetch {
    pname       = "libserf-devel";
    version     = "1.3.9";
    sources     = [{ filename = "libserf-devel-1.3.9-5-x86_64.pkg.tar.xz"; sha256 = "a403c3af5d53cbcdae7647ce10da9da8de46767e3d43cb9d9842cb894b82f7df"; }];
    buildInputs = [ (assert libserf.version=="1.3.9"; libserf) apr-util-devel openssl-devel zlib-devel ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "libsqlite" = fetch {
    pname       = "libsqlite";
    version     = "3.33.0";
    sources     = [{ filename = "libsqlite-3.33.0-2-x86_64.pkg.tar.zst"; sha256 = "b797641807b725d1a194884f7e718c6faa2b4272a4fb03a6b05ed5fcd97d6d2a"; }];
    buildInputs = [ libreadline zlib tcl ];
  };

  "libsqlite-devel" = fetch {
    pname       = "libsqlite-devel";
    version     = "3.33.0";
    sources     = [{ filename = "libsqlite-devel-3.33.0-2-x86_64.pkg.tar.zst"; sha256 = "13694700c88941061d009ca401ce0380fdbd8b7eeb11e7e5d8feb241a77dfcea"; }];
    buildInputs = [ (assert libsqlite.version=="3.33.0"; libsqlite) zlib-devel ];
  };

  "libssh2" = fetch {
    pname       = "libssh2";
    version     = "1.9.0";
    sources     = [{ filename = "libssh2-1.9.0-1-x86_64.pkg.tar.xz"; sha256 = "8dd35c81a501259ad3cbfd9c6b6bd58477160c2bd948d08dc15820c4d830a380"; }];
    buildInputs = [ ca-certificates openssl zlib ];
  };

  "libssh2-devel" = fetch {
    pname       = "libssh2-devel";
    version     = "1.9.0";
    sources     = [{ filename = "libssh2-devel-1.9.0-1-x86_64.pkg.tar.xz"; sha256 = "828fb39c276100ec0189996df21c6cb5871aeec1fd2242451c6dd1b0b65aff7f"; }];
    buildInputs = [ (assert libssh2.version=="1.9.0"; libssh2) openssl-devel zlib-devel ];
  };

  "libtasn1" = fetch {
    pname       = "libtasn1";
    version     = "4.16.0";
    sources     = [{ filename = "libtasn1-4.16.0-1-x86_64.pkg.tar.xz"; sha256 = "56cac3f5b8958b5e472f0b438df9befa0a5f0882a8544f4e1bf36acfce82415a"; }];
    buildInputs = [ info ];
  };

  "libtasn1-devel" = fetch {
    pname       = "libtasn1-devel";
    version     = "4.16.0";
    sources     = [{ filename = "libtasn1-devel-4.16.0-1-x86_64.pkg.tar.xz"; sha256 = "08285598ecc0cb9f093555a221103b819bfee5e470cde61c1050a4fddfdcd2d2"; }];
    buildInputs = [ (assert libtasn1.version=="4.16.0"; libtasn1) ];
  };

  "libtirpc" = fetch {
    pname       = "libtirpc";
    version     = "1.2.6";
    sources     = [{ filename = "libtirpc-1.2.6-1-x86_64.pkg.tar.xz"; sha256 = "ab8fdb99d6298baafff293a8a5b8d245f4f9afdf722ddd1ee8c2516eba993b77"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "libtirpc-devel" = fetch {
    pname       = "libtirpc-devel";
    version     = "1.2.6";
    sources     = [{ filename = "libtirpc-devel-1.2.6-1-x86_64.pkg.tar.xz"; sha256 = "1dcd1e27cf2eeef277e2b780c145e364cb9491af6e066567906be1d7e9ebfe20"; }];
    buildInputs = [ (assert libtirpc.version=="1.2.6"; libtirpc) ];
  };

  "libtool" = fetch {
    pname       = "libtool";
    version     = "2.4.6";
    sources     = [{ filename = "libtool-2.4.6-9-x86_64.pkg.tar.xz"; sha256 = "57f8cc26a4a7e00ccdc6f824ea610f15373587dcda7b6b08c12f5798bd9a3657"; }];
    buildInputs = [ sh (assert libltdl.version=="2.4.6"; libltdl) tar ];
  };

  "libtre-devel-git" = fetch {
    pname       = "libtre-devel-git";
    version     = "0.8.0.128.6fb7206";
    sources     = [{ filename = "libtre-devel-git-0.8.0.128.6fb7206-1-x86_64.pkg.tar.xz"; sha256 = "aec1737e3c891711068ea0eda903f6146d3d5cbf7acd2dc742b3767f3934bd81"; }];
    buildInputs = [ (assert libtre-git.version=="0.8.0.128.6fb7206"; libtre-git) gettext-devel libiconv-devel ];
  };

  "libtre-git" = fetch {
    pname       = "libtre-git";
    version     = "0.8.0.128.6fb7206";
    sources     = [{ filename = "libtre-git-0.8.0.128.6fb7206-1-x86_64.pkg.tar.xz"; sha256 = "1e5f76b96e21f8fb582ac766b2d5145438fab6827f5690616f2dc0e8e241d159"; }];
    buildInputs = [ gettext libiconv libintl ];
  };

  "libunistring" = fetch {
    pname       = "libunistring";
    version     = "0.9.10";
    sources     = [{ filename = "libunistring-0.9.10-1-x86_64.pkg.tar.xz"; sha256 = "64ca150cf3a112dbd5876ad0d36b727f28227a3e3e4d3aec9f0cc3224a4ddaf5"; }];
    buildInputs = [ msys2-runtime libiconv ];
  };

  "libunistring-devel" = fetch {
    pname       = "libunistring-devel";
    version     = "0.9.10";
    sources     = [{ filename = "libunistring-devel-0.9.10-1-x86_64.pkg.tar.xz"; sha256 = "c2ec23d683909526090eb19808803b26cbbee9173b121bd95c021b91213fdea5"; }];
    buildInputs = [ (assert libunistring.version=="0.9.10"; libunistring) libiconv-devel ];
  };

  "libunrar" = fetch {
    pname       = "libunrar";
    version     = "5.9.4";
    sources     = [{ filename = "libunrar-5.9.4-1-x86_64.pkg.tar.zst"; sha256 = "3a6bb7de28c05e9234f6a9e95c69dee6e12ce2d93862921658c6463aa317fa14"; }];
    buildInputs = [ gcc-libs ];
  };

  "libunrar-devel" = fetch {
    pname       = "libunrar-devel";
    version     = "5.9.4";
    sources     = [{ filename = "libunrar-devel-5.9.4-1-x86_64.pkg.tar.zst"; sha256 = "d874e285519df12d36424d183f9b4a6c982167fb84b4a008f25bf491ad59e96c"; }];
    buildInputs = [ libunrar ];
  };

  "libutil-linux" = fetch {
    pname       = "libutil-linux";
    version     = "2.35.2";
    sources     = [{ filename = "libutil-linux-2.35.2-1-x86_64.pkg.tar.zst"; sha256 = "cbc277391ff856a2c7eebc7b305e49b4e925df1e65ec077b4bdb8c953e5b61dc"; }];
    buildInputs = [ gcc-libs libintl ];
  };

  "libutil-linux-devel" = fetch {
    pname       = "libutil-linux-devel";
    version     = "2.35.2";
    sources     = [{ filename = "libutil-linux-devel-2.35.2-1-x86_64.pkg.tar.zst"; sha256 = "17b92e91a9c089fd8b454268a1b9446d6bb63c8bd4f1edc632ef4f6d45509291"; }];
    buildInputs = [ libutil-linux ];
  };

  "libuv" = fetch {
    pname       = "libuv";
    version     = "1.38.1";
    sources     = [{ filename = "libuv-1.38.1-1-x86_64.pkg.tar.zst"; sha256 = "5e24d6172641e73354316b0d1e76332c89574071ee32e98d32f5ed185839115b"; }];
    buildInputs = [ gcc-libs ];
  };

  "libuv-devel" = fetch {
    pname       = "libuv-devel";
    version     = "1.38.1";
    sources     = [{ filename = "libuv-devel-1.38.1-1-x86_64.pkg.tar.zst"; sha256 = "8a5fbd7ea6e1b69b1593c18ad59eac9c210258b48fdeb273ebf3e5d5b90e2f34"; }];
    buildInputs = [ (assert libuv.version=="1.38.1"; libuv) ];
  };

  "libxml2" = fetch {
    pname       = "libxml2";
    version     = "2.9.10";
    sources     = [{ filename = "libxml2-2.9.10-6-x86_64.pkg.tar.zst"; sha256 = "00591a9a75b68d94f80a3a45244e07a92c232dda1d18858611fe171de085e478"; }];
    buildInputs = [ coreutils (assert stdenvNoCC.lib.versionAtLeast icu.version "67.1"; icu) liblzma libreadline ncurses zlib ];
  };

  "libxml2-devel" = fetch {
    pname       = "libxml2-devel";
    version     = "2.9.10";
    sources     = [{ filename = "libxml2-devel-2.9.10-6-x86_64.pkg.tar.zst"; sha256 = "202ef0a4cdf704f9c8cf36baf59cdd8e7c3428debae5be9cac595241657034db"; }];
    buildInputs = [ (assert libxml2.version=="2.9.10"; libxml2) (assert stdenvNoCC.lib.versionAtLeast icu-devel.version "59.1"; icu-devel) libreadline-devel ncurses-devel liblzma-devel zlib-devel ];
  };

  "libxml2-python" = fetch {
    pname       = "libxml2-python";
    version     = "2.9.10";
    sources     = [{ filename = "libxml2-python-2.9.10-6-x86_64.pkg.tar.zst"; sha256 = "6e0f285d8ae58e55631612e0c1ea663425847d2f29632a4d03e7cc2c236f50af"; }];
    buildInputs = [ libxml2 ];
  };

  "libxslt" = fetch {
    pname       = "libxslt";
    version     = "1.1.34";
    sources     = [{ filename = "libxslt-1.1.34-3-x86_64.pkg.tar.xz"; sha256 = "2bf82ea15d20a197a62c6119e797a9bbf1b93e99b287122b0c5f0ca573e8bffa"; }];
    buildInputs = [ libxml2 libgcrypt ];
  };

  "libxslt-devel" = fetch {
    pname       = "libxslt-devel";
    version     = "1.1.34";
    sources     = [{ filename = "libxslt-devel-1.1.34-3-x86_64.pkg.tar.xz"; sha256 = "53e9b2741f29d039aef7c9a8c5d46f90ab045272d845b174a5a24709a0f53817"; }];
    buildInputs = [ (assert libxslt.version=="1.1.34"; libxslt) libxml2-devel libgcrypt-devel ];
  };

  "libxxhash" = fetch {
    pname       = "libxxhash";
    version     = "0.8.0";
    sources     = [{ filename = "libxxhash-0.8.0-1-x86_64.pkg.tar.zst"; sha256 = "50a7cf4d8586de9ea4d7ae5ce6ad596657a330a4eb6313f7d01b46a53fb271d0"; }];
  };

  "libxxhash-devel" = fetch {
    pname       = "libxxhash-devel";
    version     = "0.8.0";
    sources     = [{ filename = "libxxhash-devel-0.8.0-1-x86_64.pkg.tar.zst"; sha256 = "0e5e7e6ba74546cb9518c2cce43fa797f7bd1beb468ed447dcffaedb20c43643"; }];
    buildInputs = [ (assert libxxhash.version=="0.8.0"; libxxhash) ];
  };

  "libyaml" = fetch {
    pname       = "libyaml";
    version     = "0.2.5";
    sources     = [{ filename = "libyaml-0.2.5-1-x86_64.pkg.tar.zst"; sha256 = "921c2b783c00b9aaec5d0e1afeba7fe1fa66f77cb9836a42e67cf4dced7fe990"; }];
    buildInputs = [  ];
  };

  "libyaml-devel" = fetch {
    pname       = "libyaml-devel";
    version     = "0.2.5";
    sources     = [{ filename = "libyaml-devel-0.2.5-1-x86_64.pkg.tar.zst"; sha256 = "dbb473fb5277b448192786349141e6a48519859e841323c6927360b56b2c312f"; }];
    buildInputs = [ (assert libyaml.version=="0.2.5"; libyaml) ];
  };

  "libzstd" = fetch {
    pname       = "libzstd";
    version     = "1.4.5";
    sources     = [{ filename = "libzstd-1.4.5-2-x86_64.pkg.tar.xz"; sha256 = "764964137a349d8c68d896c23e6c6cf5cb8b53b8dfe0678b8af3ef0a397de5df"; }];
    buildInputs = [ gcc-libs ];
  };

  "libzstd-devel" = fetch {
    pname       = "libzstd-devel";
    version     = "1.4.5";
    sources     = [{ filename = "libzstd-devel-1.4.5-2-x86_64.pkg.tar.xz"; sha256 = "955d15a43004c6089260f51a860713325d1cd46eca23b9fca437a100d33d0b6d"; }];
    buildInputs = [ (assert libzstd.version=="1.4.5"; libzstd) ];
  };

  "lndir" = fetch {
    pname       = "lndir";
    version     = "1.0.3";
    sources     = [{ filename = "lndir-1.0.3-1-x86_64.pkg.tar.xz"; sha256 = "da36fc9b5889dbb9da146cab4e4fc9fc518d5ee6f4bd8ef8069fc1f312311800"; }];
    buildInputs = [ msys2-runtime ];
  };

  "luit" = fetch {
    pname       = "luit";
    version     = "20190106";
    sources     = [{ filename = "luit-20190106-1-x86_64.pkg.tar.xz"; sha256 = "7af63c98c64b9bcce68e6b738c3681ff14f8f2362856b20a46d923365ecd158a"; }];
    buildInputs = [ gcc-libs libiconv zlib ];
  };

  "lz4" = fetch {
    pname       = "lz4";
    version     = "1.9.2";
    sources     = [{ filename = "lz4-1.9.2-1-x86_64.pkg.tar.xz"; sha256 = "d39f3efb21c894af4d79645a660769d46d46e48f8d6dbeb15c42a440544dbbe6"; }];
    buildInputs = [ gcc-libs (assert lz4.version=="1.9.2"; lz4) ];
  };

  "lzip" = fetch {
    pname       = "lzip";
    version     = "1.21";
    sources     = [{ filename = "lzip-1.21-1-x86_64.pkg.tar.xz"; sha256 = "ae8e4b5e69bf3cac18c439ec3301af7384321489ae42bf3a9ef482e6b2bf8a38"; }];
    buildInputs = [ gcc-libs ];
  };

  "lzop" = fetch {
    pname       = "lzop";
    version     = "1.04";
    sources     = [{ filename = "lzop-1.04-1-x86_64.pkg.tar.xz"; sha256 = "dc426979fdc9398f16bf7e57998bc1eb3f95bd030b9419bcc67269e88b7c3686"; }];
    buildInputs = [ liblzo2 ];
  };

  "m4" = fetch {
    pname       = "m4";
    version     = "1.4.18";
    sources     = [{ filename = "m4-1.4.18-2-x86_64.pkg.tar.xz"; sha256 = "510e5318e830ad6bbd760aeb00a575047060dd2d93475ab1db6376ceb1afa717"; }];
    buildInputs = [ bash gcc-libs msys2-runtime ];
  };

  "make" = fetch {
    pname       = "make";
    version     = "4.3";
    sources     = [{ filename = "make-4.3-1-x86_64.pkg.tar.xz"; sha256 = "02f114b93a96a1c540e5a8cf582345e93f4845bc356ad4583b7d3e53f87baf2e"; }];
    buildInputs = [ msys2-runtime libintl sh ];
  };

  "man-db" = fetch {
    pname       = "man-db";
    version     = "2.9.3";
    sources     = [{ filename = "man-db-2.9.3-1-x86_64.pkg.tar.zst"; sha256 = "f42ea9b665dd8a8522f5cd2a125fd79a6ff4cd7ef0c506be96aa233c15804c0c"; }];
    buildInputs = [ bash gdbm zlib groff libpipeline less ];
  };

  "man-pages-posix" = fetch {
    pname       = "man-pages-posix";
    version     = "2013_a";
    sources     = [{ filename = "man-pages-posix-2013_a-1-any.pkg.tar.xz"; sha256 = "2ebbcc565d0e5c99400425924dff2696130fe998da59f5387b8fa881933adb91"; }];
    buildInputs = [ man ];
    broken      = true; # broken dependency man-pages-posix -> man
  };

  "man2html" = fetch {
    pname       = "man2html";
    version     = "3.0.1";
    sources     = [{ filename = "man2html-3.0.1-1-any.pkg.tar.xz"; sha256 = "f315dcc59357a1d45e772c1980f4292b7278a3d8f31757911f382211a29421f4"; }];
    buildInputs = [ man-db perl ];
  };

  "markdown" = fetch {
    pname       = "markdown";
    version     = "1.0.1";
    sources     = [{ filename = "markdown-1.0.1-1-x86_64.pkg.tar.xz"; sha256 = "9359cd3b48502c9f2bcb1ee09dffe45f5330f66e8d1ce5b8bd222122631fe58c"; }];
    buildInputs = [ perl ];
  };

  "mc" = fetch {
    pname       = "mc";
    version     = "4.8.25";
    sources     = [{ filename = "mc-4.8.25-2-x86_64.pkg.tar.xz"; sha256 = "c89782d2744c6a9e148319340db7757893f1c8e0b80e90a6bdb4eecc151de392"; }];
    buildInputs = [ glib2 libssh2 ];
  };

  "mercurial" = fetch {
    pname       = "mercurial";
    version     = "5.4.2";
    sources     = [{ filename = "mercurial-5.4.2-2-x86_64.pkg.tar.zst"; sha256 = "4e98200fb365995a0b93b824fc4acbf27496c821952b906d78ddb460d74bb883"; }];
    buildInputs = [ python3 ];
  };

  "meson" = fetch {
    pname       = "meson";
    version     = "0.55.3";
    sources     = [{ filename = "meson-0.55.3-2-any.pkg.tar.zst"; sha256 = "5ea8eae48107928ae17b8744691c281c0f93685fcb6fa3210745663771032aa9"; }];
    buildInputs = [ python python-setuptools ninja ];
  };

  "midipix-cross-binutils" = fetch {
    pname       = "midipix-cross-binutils";
    version     = "2.24.51";
    sources     = [{ filename = "midipix-cross-binutils-2.24.51-1-x86_64.pkg.tar.zst"; sha256 = "e2cc09cba3d0464a5a0feabe7fecab6249b1d7fb5de3a44ee38cf261348fc1b9"; }];
    buildInputs = [ libiconv zlib ];
  };

  "mingw-w64-cross-binutils" = fetch {
    pname       = "mingw-w64-cross-binutils";
    version     = "2.35";
    sources     = [{ filename = "mingw-w64-cross-binutils-2.35-1-x86_64.pkg.tar.zst"; sha256 = "5d334c7eec6ae3d9e495677c57b77ee2149a6c460b7e13ae08acb576c92bcfc2"; }];
    buildInputs = [ libiconv zlib ];
  };

  "mingw-w64-cross-crt-git" = fetch {
    pname       = "mingw-w64-cross-crt-git";
    version     = "8.0.0.5687.c8e562e9";
    sources     = [{ filename = "mingw-w64-cross-crt-git-8.0.0.5687.c8e562e9-1-x86_64.pkg.tar.xz"; sha256 = "6768e06fd52141fae285a5e8d98cca7d02c9fe724f4c49d38dad6ba46d5ee7b8"; }];
    buildInputs = [ mingw-w64-cross-headers-git ];
  };

  "mingw-w64-cross-gcc" = fetch {
    pname       = "mingw-w64-cross-gcc";
    version     = "9.3.0";
    sources     = [{ filename = "mingw-w64-cross-gcc-9.3.0-1-x86_64.pkg.tar.xz"; sha256 = "523b741dbfd35b173bf3488c15418542fc51c2b979d7775cd0915c12c5e74430"; }];
    buildInputs = [ zlib mpc isl mingw-w64-cross-binutils mingw-w64-cross-crt-git mingw-w64-cross-headers-git mingw-w64-cross-winpthreads-git mingw-w64-cross-windows-default-manifest ];
  };

  "mingw-w64-cross-headers-git" = fetch {
    pname       = "mingw-w64-cross-headers-git";
    version     = "8.0.0.5687.c8e562e9";
    sources     = [{ filename = "mingw-w64-cross-headers-git-8.0.0.5687.c8e562e9-1-x86_64.pkg.tar.xz"; sha256 = "82147a265d0e7d62e6146b946e0e270107f752190da2af5f6f1d5a19569138c5"; }];
    buildInputs = [  ];
  };

  "mingw-w64-cross-tools-git" = fetch {
    pname       = "mingw-w64-cross-tools-git";
    version     = "8.0.0.5687.c8e562e9";
    sources     = [{ filename = "mingw-w64-cross-tools-git-8.0.0.5687.c8e562e9-1-x86_64.pkg.tar.xz"; sha256 = "12c686fc5889b6a320702c7242bb6ae330cbba7253d410a1565ec88e71de7a42"; }];
  };

  "mingw-w64-cross-windows-default-manifest" = fetch {
    pname       = "mingw-w64-cross-windows-default-manifest";
    version     = "6.4";
    sources     = [{ filename = "mingw-w64-cross-windows-default-manifest-6.4-2-x86_64.pkg.tar.xz"; sha256 = "440ce11c9179fc0f0f3fc933027adbb3e3bda19247964142aa1a40ef0097c258"; }];
    buildInputs = [  ];
  };

  "mingw-w64-cross-winpthreads-git" = fetch {
    pname       = "mingw-w64-cross-winpthreads-git";
    version     = "8.0.0.5688.6ac47dbf";
    sources     = [{ filename = "mingw-w64-cross-winpthreads-git-8.0.0.5688.6ac47dbf-1-x86_64.pkg.tar.xz"; sha256 = "8c0f111e98775bef251d2dcf4ef242e01dfeeb8614533160a47cffb1258a8927"; }];
    buildInputs = [ mingw-w64-cross-crt-git ];
  };

  "mingw-w64-cross-winstorecompat-git" = fetch {
    pname       = "mingw-w64-cross-winstorecompat-git";
    version     = "8.0.0.5687.c8e562e9";
    sources     = [{ filename = "mingw-w64-cross-winstorecompat-git-8.0.0.5687.c8e562e9-1-x86_64.pkg.tar.xz"; sha256 = "5ed792b9971130cec46b1ef8fb4c6b84e8b9daa3e51de09a164c9d193aa7e4ba"; }];
    buildInputs = [ mingw-w64-cross-crt-git ];
  };

  "mingw-w64-cross-zlib" = fetch {
    pname       = "mingw-w64-cross-zlib";
    version     = "1.2.11";
    sources     = [{ filename = "mingw-w64-cross-zlib-1.2.11-1-x86_64.pkg.tar.xz"; sha256 = "27fa35a33c17778cedc33805451ece4993181b63c6cf4d567f186d6c06e542f0"; }];
  };

  "mintty" = fetch {
    pname       = "mintty";
    version     = "1~3.4.0";
    sources     = [{ filename = "mintty-1~3.4.0-1-x86_64.pkg.tar.xz"; sha256 = "789f056b65f8d1e3be5dedb0ef477fb5fb1e85dbfb3cce48e06583e987133539"; }];
    buildInputs = [ sh ];
  };

  "mksh" = fetch {
    pname       = "mksh";
    version     = "57";
    sources     = [{ filename = "mksh-57-1-x86_64.pkg.tar.xz"; sha256 = "52e75a3877fd29f1b3d94f2cc18598192a7e5404983af16c63cf397b7c05da51"; }];
    buildInputs = [ gcc-libs ];
  };

  "moreutils" = fetch {
    pname       = "moreutils";
    version     = "0.63";
    sources     = [{ filename = "moreutils-0.63-1-x86_64.pkg.tar.xz"; sha256 = "95a602167c4dc6ba5b1fd0b372aa1f14187da02f07a5398e7e7d9d81a897ce7f"; }];
  };

  "mosh" = fetch {
    pname       = "mosh";
    version     = "1.3.2";
    sources     = [{ filename = "mosh-1.3.2-7-x86_64.pkg.tar.zst"; sha256 = "58e6c6a5a398b515216c913f0b22b5f21c6fc689fa9ceb203beb4d02b7e9bdb2"; }];
    buildInputs = [ protobuf ncurses zlib libopenssl openssh perl ];
  };

  "mpc" = fetch {
    pname       = "mpc";
    version     = "1.1.0";
    sources     = [{ filename = "mpc-1.1.0-1-x86_64.pkg.tar.xz"; sha256 = "5368f3aeb9cd3b9fea9a8c52dfbcc2709f911bf0d36bb9786999dcfdd0fdd5ae"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gmp.version "5.0"; gmp) mpfr ];
  };

  "mpc-devel" = fetch {
    pname       = "mpc-devel";
    version     = "1.1.0";
    sources     = [{ filename = "mpc-devel-1.1.0-1-x86_64.pkg.tar.xz"; sha256 = "792e03f64060384d8e7130a3cde8a08acad09efdeaa390de65bc8edfdca0771f"; }];
    buildInputs = [ (assert mpc.version=="1.1.0"; mpc) gmp-devel mpfr-devel ];
  };

  "mpdecimal" = fetch {
    pname       = "mpdecimal";
    version     = "2.5.0";
    sources     = [{ filename = "mpdecimal-2.5.0-1-x86_64.pkg.tar.zst"; sha256 = "6d586e40e79706355504fcd50a003ae4f145ce14f159082ebc0f43d41f5483a5"; }];
    buildInputs = [ gcc-libs ];
  };

  "mpdecimal-devel" = fetch {
    pname       = "mpdecimal-devel";
    version     = "2.5.0";
    sources     = [{ filename = "mpdecimal-devel-2.5.0-1-x86_64.pkg.tar.zst"; sha256 = "7e0f7b7a472fac0754082c12391a2af2bea3551fc69d75703ec1821d93ba3142"; }];
    buildInputs = [ (assert mpdecimal.version=="2.5.0"; mpdecimal) ];
  };

  "mpfr" = fetch {
    pname       = "mpfr";
    version     = "4.1.0";
    sources     = [{ filename = "mpfr-4.1.0-1-x86_64.pkg.tar.zst"; sha256 = "78600d4f011a5e070e8439befada0eb1cc566f9b63533e75134f831a0526ec29"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast gmp.version "5.0"; gmp) ];
  };

  "mpfr-devel" = fetch {
    pname       = "mpfr-devel";
    version     = "4.1.0";
    sources     = [{ filename = "mpfr-devel-4.1.0-1-x86_64.pkg.tar.zst"; sha256 = "84789468c02f84941008a758fe8af8e13bb12853b5255bad87aae482c6537ee0"; }];
    buildInputs = [ (assert mpfr.version=="4.1.0"; mpfr) gmp-devel ];
  };

  "msys2-keyring" = fetch {
    pname       = "msys2-keyring";
    version     = "1~20201002";
    sources     = [{ filename = "msys2-keyring-1~20201002-1-any.pkg.tar.xz"; sha256 = "6c29b84d30c1fd33bec66b5de7336463b75fe0fb077bbb13d7b4a9974a9a85db"; }];
    buildInputs = [  ];
  };

  "msys2-launcher" = fetch {
    pname       = "msys2-launcher";
    version     = "1.0";
    sources     = [{ filename = "msys2-launcher-1.0-1-x86_64.pkg.tar.zst"; sha256 = "5cc7555b6bf4bb3909260ad1a3b72a6bef2718c9a6f59cf5fd055579e9dcb7e6"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast mintty.version "1~2.2.1"; mintty) ];
  };

  "msys2-runtime" = fetch {
    pname       = "msys2-runtime";
    version     = "3.1.7";
    sources     = [{ filename = "msys2-runtime-3.1.7-2-x86_64.pkg.tar.xz"; sha256 = "cea16e60334e36a0b8250e1b30c5deddfdeb341e19729fb27c6450cb13d7b628"; }];
    buildInputs = [  ];
  };

  "msys2-runtime-devel" = fetch {
    pname       = "msys2-runtime-devel";
    version     = "3.1.7";
    sources     = [{ filename = "msys2-runtime-devel-3.1.7-2-x86_64.pkg.tar.xz"; sha256 = "50d7dae072875b6c17376062ccb773d45ac274774faf1f1995550807736d0813"; }];
    buildInputs = [ (assert msys2-runtime.version=="3.1.7"; msys2-runtime) ];
  };

  "msys2-w32api-headers" = fetch {
    pname       = "msys2-w32api-headers";
    version     = "8.0.0.5683.629fd2b1";
    sources     = [{ filename = "msys2-w32api-headers-8.0.0.5683.629fd2b1-1-x86_64.pkg.tar.xz"; sha256 = "1629aeef5bfd0d9856c473e256bb051607a5b6341a60a6ab7d7f8eee024c989d"; }];
    buildInputs = [  ];
  };

  "msys2-w32api-runtime" = fetch {
    pname       = "msys2-w32api-runtime";
    version     = "8.0.0.5683.629fd2b1";
    sources     = [{ filename = "msys2-w32api-runtime-8.0.0.5683.629fd2b1-1-x86_64.pkg.tar.xz"; sha256 = "3dcf0a6d11e0de6688ecd379c8e45f188dbb683acdaea4eb7f7a19ed071ccc52"; }];
    buildInputs = [ msys2-w32api-headers ];
  };

  "mutt" = fetch {
    pname       = "mutt";
    version     = "1.14.6";
    sources     = [{ filename = "mutt-1.14.6-1-x86_64.pkg.tar.zst"; sha256 = "a92b883ec57b63815937249f687f33f456219913e2b4c39ce0fd705f23289c39"; }];
    buildInputs = [ libgpgme libsasl libgdbm ncurses libgnutls libidn2 ];
  };

  "namcap" = fetch {
    pname       = "namcap";
    version     = "3.2.10";
    sources     = [{ filename = "namcap-3.2.10-1-any.pkg.tar.zst"; sha256 = "fe467c5e497a455f6eeeac4325bbe9209ef000ff03de450466a6ce8744f33bb4"; }];
    buildInputs = [ python python-pyalpm binutils ];
  };

  "nano" = fetch {
    pname       = "nano";
    version     = "4.9.3";
    sources     = [{ filename = "nano-4.9.3-1-x86_64.pkg.tar.zst"; sha256 = "dc97d7fb79bc5a7228f2aed6e05a6a9370210721a1a4a2bac75d361aec9635a5"; }];
    buildInputs = [ file libintl ncurses sh ];
  };

  "nano-syntax-highlighting-git" = fetch {
    pname       = "nano-syntax-highlighting-git";
    version     = "299.5e776df";
    sources     = [{ filename = "nano-syntax-highlighting-git-299.5e776df-1-any.pkg.tar.xz"; sha256 = "386a1a16a165258287a5c7282e75174b7870bd8dc08876d70932f4e477e1d1dd"; }];
    buildInputs = [ nano ];
  };

  "nasm" = fetch {
    pname       = "nasm";
    version     = "2.15.03";
    sources     = [{ filename = "nasm-2.15.03-2-x86_64.pkg.tar.zst"; sha256 = "02fc3845596f5f7fffcf1b1389599c1ac141c2cb96812b74bcc59e3602bbe65e"; }];
  };

  "nawk" = fetch {
    pname       = "nawk";
    version     = "20180827";
    sources     = [{ filename = "nawk-20180827-1-x86_64.pkg.tar.xz"; sha256 = "f384235d4a8a8914b45a11c0749dfdd5271dfbca363b8b4076729e485adfd455"; }];
    buildInputs = [ msys2-runtime ];
  };

  "ncurses" = fetch {
    pname       = "ncurses";
    version     = "6.2";
    sources     = [{ filename = "ncurses-6.2-1-x86_64.pkg.tar.xz"; sha256 = "0943eb05da94d3ab8efac1a923bfcd515a9ba7251186e29401f06f155ce4d2ba"; }];
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "ncurses-devel" = fetch {
    pname       = "ncurses-devel";
    version     = "6.2";
    sources     = [{ filename = "ncurses-devel-6.2-1-x86_64.pkg.tar.xz"; sha256 = "18b16b5143fc9f4fefb71152fdacd9fc35a995c60a013941466966a06896220e"; }];
    buildInputs = [ (assert ncurses.version=="6.2"; ncurses) ];
  };

  "nettle" = fetch {
    pname       = "nettle";
    version     = "3.6";
    sources     = [{ filename = "nettle-3.6-1-x86_64.pkg.tar.zst"; sha256 = "aa57d0fc69f27d79268aa305d5dc2ba0782f9bd2a7dc48279256f8bd1a589efb"; }];
    buildInputs = [ libnettle ];
  };

  "nghttp2" = fetch {
    pname       = "nghttp2";
    version     = "1.41.0";
    sources     = [{ filename = "nghttp2-1.41.0-1-x86_64.pkg.tar.zst"; sha256 = "5f724a6c038ef362639617c89872b2f98767c28e477d6a6f61e3a319f080a92f"; }];
    buildInputs = [ gcc-libs jansson (assert libnghttp2.version=="1.41.0"; libnghttp2) ];
  };

  "ninja" = fetch {
    pname       = "ninja";
    version     = "1.10.0";
    sources     = [{ filename = "ninja-1.10.0-1-x86_64.pkg.tar.xz"; sha256 = "ef5d38af228480b9eec8420688504f3b29899153b28143abff0a72aceb6af596"; }];
    buildInputs = [  ];
  };

  "ninja-emacs" = fetch {
    pname       = "ninja-emacs";
    version     = "1.10.0";
    sources     = [{ filename = "ninja-emacs-1.10.0-1-x86_64.pkg.tar.xz"; sha256 = "530a8f5ecd4abf58467e9ebfe7fb8929db2fd007d1b4bd76a8ce0584dac484ce"; }];
    buildInputs = [ (assert ninja.version=="1.10.0"; ninja) emacs ];
  };

  "ninja-vim" = fetch {
    pname       = "ninja-vim";
    version     = "1.10.0";
    sources     = [{ filename = "ninja-vim-1.10.0-1-x86_64.pkg.tar.xz"; sha256 = "74ad7503e3f39f458f8f11b339cc140be216b26a5675c2530984de81425bce4d"; }];
    buildInputs = [ (assert ninja.version=="1.10.0"; ninja) vim ];
  };

  "openbsd-netcat" = fetch {
    pname       = "openbsd-netcat";
    version     = "1.206_1";
    sources     = [{ filename = "openbsd-netcat-1.206_1-1-x86_64.pkg.tar.xz"; sha256 = "b81a0abc7ab5a6116c50337ffdd0962862e8531897814705fc7548c02da289b2"; }];
  };

  "openssh" = fetch {
    pname       = "openssh";
    version     = "8.3p1";
    sources     = [{ filename = "openssh-8.3p1-1-x86_64.pkg.tar.zst"; sha256 = "adc6e09db844d3b5b0846804cd397796f8a5c9a472829bc54cb6e6c9e607f7b4"; }];
    buildInputs = [ heimdal libedit libcrypt openssl ];
  };

  "openssl" = fetch {
    pname       = "openssl";
    version     = "1.1.1.g";
    sources     = [{ filename = "openssl-1.1.1.g-3-x86_64.pkg.tar.zst"; sha256 = "776c0a9edbc548d2c53a9bdf732801a38de5bff795741a993fd803890de73b16"; }];
    buildInputs = [ libopenssl zlib ];
  };

  "openssl-devel" = fetch {
    pname       = "openssl-devel";
    version     = "1.1.1.g";
    sources     = [{ filename = "openssl-devel-1.1.1.g-3-x86_64.pkg.tar.zst"; sha256 = "bd777e71596fc811e08db3a1c564d14eb88e4126dc582f27fe1030d9069b413b"; }];
    buildInputs = [ (assert libopenssl.version=="1.1.1.g"; libopenssl) zlib-devel ];
  };

  "openssl-docs" = fetch {
    pname       = "openssl-docs";
    version     = "1.1.1.g";
    sources     = [{ filename = "openssl-docs-1.1.1.g-3-x86_64.pkg.tar.zst"; sha256 = "70658a9af1290fcfaf812c2b4933783f3db5ace9518ac4913fa10928a86c9af7"; }];
    buildInputs = [ zlib ];
  };

  "p11-kit" = fetch {
    pname       = "p11-kit";
    version     = "0.23.20";
    sources     = [{ filename = "p11-kit-0.23.20-2-x86_64.pkg.tar.xz"; sha256 = "43f1b89a7a3145062240487785b0560ee163f42eaa510044bbc1f4232555c0af"; }];
    buildInputs = [ (assert libp11-kit.version=="0.23.20"; libp11-kit) ];
  };

  "p7zip" = fetch {
    pname       = "p7zip";
    version     = "16.02";
    sources     = [{ filename = "p7zip-16.02-1-x86_64.pkg.tar.xz"; sha256 = "f13152aab48d8e4bdc02d48e20d861c9ef05717e89730298ced94bc1ef5e7f02"; }];
    buildInputs = [ gcc-libs bash ];
  };

  "pacman" = fetch {
    pname       = "pacman";
    version     = "5.2.2";
    sources     = [{ filename = "pacman-5.2.2-4-x86_64.pkg.tar.xz"; sha256 = "b040db389f16abac3cd2311329442e03f1ac9e42ac914d83ba85c4bdba939f57"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast bash.version "4.2.045"; bash) gettext gnupg curl pacman-mirrors msys2-keyring which bzip2 xz zstd ];
  };

  "pacman-contrib" = fetch {
    pname       = "pacman-contrib";
    version     = "1.3.0";
    sources     = [{ filename = "pacman-contrib-1.3.0-1-x86_64.pkg.tar.zst"; sha256 = "276d6bdc4cc7da18a5455290e57a2e57ffedec78991126f764ff1f27f39904fe"; }];
    buildInputs = [ perl pacman bash ];
  };

  "pacman-mirrors" = fetch {
    pname       = "pacman-mirrors";
    version     = "20201016";
    sources     = [{ filename = "pacman-mirrors-20201016-1-any.pkg.tar.xz"; sha256 = "827a7803f7800fb65560a9669ac71160a1f325a69cbc51f024f913ea8eff05ce"; }];
    buildInputs = [  ];
  };

  "pactoys-git" = fetch {
    pname       = "pactoys-git";
    version     = "r2.07ca37f";
    sources     = [{ filename = "pactoys-git-r2.07ca37f-1-x86_64.pkg.tar.xz"; sha256 = "47986ea27816fc9c6d04602653718eb5a34dab140766ea0e73b48e999cd80073"; }];
    buildInputs = [ pacman pkgfile wget ];
    broken      = true; # broken dependency wget -> libuuid
  };

  "parallel" = fetch {
    pname       = "parallel";
    version     = "20200322";
    sources     = [{ filename = "parallel-20200322-1-any.pkg.tar.xz"; sha256 = "8ab99a91dad3a49e762f815820de41a8801ddf1db39de6ac854d86b699c6d0bd"; }];
    buildInputs = [ perl ];
  };

  "pass" = fetch {
    pname       = "pass";
    version     = "1.7.3";
    sources     = [{ filename = "pass-1.7.3-2-any.pkg.tar.xz"; sha256 = "87b4b8ab274c75a21b39d3d53740364cdf52603d9b386337c6f889396ed71765"; }];
    buildInputs = [ bash gnupg tree ];
  };

  "patch" = fetch {
    pname       = "patch";
    version     = "2.7.6";
    sources     = [{ filename = "patch-2.7.6-1-x86_64.pkg.tar.xz"; sha256 = "5c18ce8979e9019d24abd2aee7ddcdf8824e31c4c7e162a204d4dc39b3b73776"; }];
    buildInputs = [ msys2-runtime ];
  };

  "patchutils" = fetch {
    pname       = "patchutils";
    version     = "0.4.2";
    sources     = [{ filename = "patchutils-0.4.2-1-x86_64.pkg.tar.zst"; sha256 = "c49ff28304fa2370b9544c13d98cb0f97c9ac691730596a879e57feb4e8bae39"; }];
    buildInputs = [ pcre2 ];
  };

  "pax-git" = fetch {
    pname       = "pax-git";
    version     = "20161104.2";
    sources     = [{ filename = "pax-git-20161104.2-1-x86_64.pkg.tar.xz"; sha256 = "ea4b3c277d3bc38effdd3ec36235dd7d2c6853faed2ee16b5c84379a6a0dfb55"; }];
    buildInputs = [ msys2-runtime ];
  };

  "pcre" = fetch {
    pname       = "pcre";
    version     = "8.44";
    sources     = [{ filename = "pcre-8.44-1-x86_64.pkg.tar.xz"; sha256 = "81058d6852cd3bc6ef8d5e2a090869a34517c3ef7ca7f4b89c78e05f6f8d8273"; }];
    buildInputs = [ libreadline libbz2 zlib libpcre libpcre16 libpcre32 libpcrecpp libpcreposix ];
  };

  "pcre-devel" = fetch {
    pname       = "pcre-devel";
    version     = "8.44";
    sources     = [{ filename = "pcre-devel-8.44-1-x86_64.pkg.tar.xz"; sha256 = "abec57308b95b73dd6937d17e6e8cf28ee8691c6adfbf0fa1da73e53fdccebb2"; }];
    buildInputs = [ (assert libpcre.version=="8.44"; libpcre) (assert libpcre16.version=="8.44"; libpcre16) (assert libpcre32.version=="8.44"; libpcre32) (assert libpcreposix.version=="8.44"; libpcreposix) (assert libpcrecpp.version=="8.44"; libpcrecpp) ];
  };

  "pcre2" = fetch {
    pname       = "pcre2";
    version     = "10.35";
    sources     = [{ filename = "pcre2-10.35-1-x86_64.pkg.tar.zst"; sha256 = "1ed68c181973c967f4608ed46543b59e0d6794b3d26915bc0c9916013e45a77d"; }];
    buildInputs = [ libreadline libbz2 zlib (assert libpcre2_8.version=="10.35"; libpcre2_8) (assert libpcre2_16.version=="10.35"; libpcre2_16) (assert libpcre2_32.version=="10.35"; libpcre2_32) (assert libpcre2posix.version=="10.35"; libpcre2posix) ];
  };

  "pcre2-devel" = fetch {
    pname       = "pcre2-devel";
    version     = "10.35";
    sources     = [{ filename = "pcre2-devel-10.35-1-x86_64.pkg.tar.zst"; sha256 = "8334f35cd16e2b28bd79ad9954d699b88a6a131db3b7d4ca483448a734719030"; }];
    buildInputs = [ (assert libpcre2_8.version=="10.35"; libpcre2_8) (assert libpcre2_16.version=="10.35"; libpcre2_16) (assert libpcre2_32.version=="10.35"; libpcre2_32) (assert libpcre2posix.version=="10.35"; libpcre2posix) ];
  };

  "perl" = fetch {
    pname       = "perl";
    version     = "5.32.0";
    sources     = [{ filename = "perl-5.32.0-2-x86_64.pkg.tar.zst"; sha256 = "4c799634d242bdcf85070e8512110cf71f6df2c079909a46eeb3d927ff088a71"; }];
    buildInputs = [ db gdbm libcrypt coreutils sh ];
  };

  "perl-Algorithm-Diff" = fetch {
    pname       = "perl-Algorithm-Diff";
    version     = "1.1903";
    sources     = [{ filename = "perl-Algorithm-Diff-1.1903-1-any.pkg.tar.xz"; sha256 = "dea50788bd3c45ad6876cb7f8d47d5c05fa406ef424240fd84011a3481f721d4"; }];
    buildInputs = [ perl ];
  };

  "perl-Alien-Build" = fetch {
    pname       = "perl-Alien-Build";
    version     = "2.26";
    sources     = [{ filename = "perl-Alien-Build-2.26-3-any.pkg.tar.zst"; sha256 = "fc670179ba6c6f69346bd99ecf315be3d9ec82eea3cb9160f516bbdb61ba1830"; }];
    buildInputs = [ perl-Capture-Tiny perl-FFI-CheckLib perl-File-chdir perl-File-Which ];
  };

  "perl-Alien-Libxml2" = fetch {
    pname       = "perl-Alien-Libxml2";
    version     = "0.16";
    sources     = [{ filename = "perl-Alien-Libxml2-0.16-1-any.pkg.tar.zst"; sha256 = "2d1a7f757e05abdde6f7cf263c43266c8ba8532deb98a06df48da91a091311c8"; }];
    buildInputs = [ libxml2 perl-Alien-Build ];
  };

  "perl-Archive-Zip" = fetch {
    pname       = "perl-Archive-Zip";
    version     = "1.68";
    sources     = [{ filename = "perl-Archive-Zip-1.68-1-any.pkg.tar.xz"; sha256 = "eddc5fa007ce9301f2b8ae7c581df306eff0258582a8fd118809e463424b6b27"; }];
    buildInputs = [ perl ];
  };

  "perl-Authen-SASL" = fetch {
    pname       = "perl-Authen-SASL";
    version     = "2.16";
    sources     = [{ filename = "perl-Authen-SASL-2.16-2-any.pkg.tar.xz"; sha256 = "6dfadf705bcb7cd3e147044e9da9bc17fb834d6e8a1353f617ba377d778e2a20"; }];
    buildInputs = [ perl ];
  };

  "perl-Benchmark-Timer" = fetch {
    pname       = "perl-Benchmark-Timer";
    version     = "0.7107";
    sources     = [{ filename = "perl-Benchmark-Timer-0.7107-1-any.pkg.tar.xz"; sha256 = "91e4b56350cfb6862da64e71a302db0c71164aab28666e33a33e74f3a9479b81"; }];
    buildInputs = [ perl ];
  };

  "perl-Capture-Tiny" = fetch {
    pname       = "perl-Capture-Tiny";
    version     = "0.48";
    sources     = [{ filename = "perl-Capture-Tiny-0.48-1-any.pkg.tar.xz"; sha256 = "e335d1b48950a5f172079426470ba30975053817b5f5362587641cc90a33a973"; }];
    buildInputs = [ perl ];
  };

  "perl-Carp-Clan" = fetch {
    pname       = "perl-Carp-Clan";
    version     = "6.08";
    sources     = [{ filename = "perl-Carp-Clan-6.08-1-any.pkg.tar.xz"; sha256 = "3fc3919ed0a309b1bacdb65f23aebc5a0b31a04e46e6bb0639ba9ae7ad9539b1"; }];
    buildInputs = [ perl ];
  };

  "perl-Class-Method-Modifiers" = fetch {
    pname       = "perl-Class-Method-Modifiers";
    version     = "2.12";
    sources     = [{ filename = "perl-Class-Method-Modifiers-2.12-1-any.pkg.tar.xz"; sha256 = "1c5223933da605ad0adc82e5598c0dbc01e6a6aa50756fdcf1658d8a1a177765"; }];
    buildInputs = [ perl-Test-Fatal perl-Test-Requires ];
  };

  "perl-Clone" = fetch {
    pname       = "perl-Clone";
    version     = "0.45";
    sources     = [{ filename = "perl-Clone-0.45-2-x86_64.pkg.tar.zst"; sha256 = "5e5a4d9ab8e569ddc11f9da232fb5ad3ceced6a46c5fd1210702de72babbe927"; }];
    buildInputs = [ perl ];
  };

  "perl-Compress-Bzip2" = fetch {
    pname       = "perl-Compress-Bzip2";
    version     = "2.28";
    sources     = [{ filename = "perl-Compress-Bzip2-2.28-3-x86_64.pkg.tar.zst"; sha256 = "cc16542b8f3ff23fac84fcb4013442bc28c416da53e689f47007f97b17c41017"; }];
    buildInputs = [ perl libbz2 ];
  };

  "perl-Convert-BinHex" = fetch {
    pname       = "perl-Convert-BinHex";
    version     = "1.125";
    sources     = [{ filename = "perl-Convert-BinHex-1.125-1-any.pkg.tar.xz"; sha256 = "08146d9182071521e105beb4c27ae7207874fa31d82b9f9dcc3a5a08eabfcd60"; }];
    buildInputs = [ perl ];
  };

  "perl-Crypt-SSLeay" = fetch {
    pname       = "perl-Crypt-SSLeay";
    version     = "0.73_06";
    sources     = [{ filename = "perl-Crypt-SSLeay-0.73_06-6-x86_64.pkg.tar.zst"; sha256 = "707f85cd4ac23cad9bb884457be297ce8ede06177e44c9b1d076fe2e9425fdaa"; }];
    buildInputs = [ perl-LWP-Protocol-https perl-Try-Tiny perl-Path-Class ];
  };

  "perl-DBI" = fetch {
    pname       = "perl-DBI";
    version     = "1.643";
    sources     = [{ filename = "perl-DBI-1.643-4-x86_64.pkg.tar.zst"; sha256 = "5f8a3911c1c5b9195d58e6e0f4cd0756ae4706c8d1667a16a4d3d6e183a0d3e9"; }];
    buildInputs = [ perl ];
  };

  "perl-Data-Munge" = fetch {
    pname       = "perl-Data-Munge";
    version     = "0.097";
    sources     = [{ filename = "perl-Data-Munge-0.097-1-any.pkg.tar.xz"; sha256 = "a909ba30cfa6e15366f2c5be5517dbf8e94474f2ca84b2833d04905c175d1d35"; }];
    buildInputs = [ perl ];
  };

  "perl-Data-OptList" = fetch {
    pname       = "perl-Data-OptList";
    version     = "0.110";
    sources     = [{ filename = "perl-Data-OptList-0.110-1-any.pkg.tar.xz"; sha256 = "c0af80148803f9053688474aac82009257cfcf445413062d019341ad97ef2b15"; }];
    buildInputs = [ perl-Params-Util perl-Scalar-List-Utils perl-Sub-Install ];
    broken      = true; # broken dependency perl-Data-OptList -> perl-Scalar-List-Utils
  };

  "perl-Date-Calc" = fetch {
    pname       = "perl-Date-Calc";
    version     = "6.4";
    sources     = [{ filename = "perl-Date-Calc-6.4-1-any.pkg.tar.xz"; sha256 = "9a5beed884beb9948f7790a868444d0802e6bd6301316e202c54dc41f1cec914"; }];
    buildInputs = [ perl ];
  };

  "perl-Devel-GlobalDestruction" = fetch {
    pname       = "perl-Devel-GlobalDestruction";
    version     = "0.14";
    sources     = [{ filename = "perl-Devel-GlobalDestruction-0.14-1-any.pkg.tar.xz"; sha256 = "3fa692062bd0122ca420ab8cbf6d4ab291578a1aba845c07b69bdb059c5f1c6a"; }];
    buildInputs = [ perl perl-Sub-Exporter perl-Sub-Exporter-Progressive ];
    broken      = true; # broken dependency perl-Data-OptList -> perl-Scalar-List-Utils
  };

  "perl-Digest-HMAC" = fetch {
    pname       = "perl-Digest-HMAC";
    version     = "1.03";
    sources     = [{ filename = "perl-Digest-HMAC-1.03-2-any.pkg.tar.xz"; sha256 = "9611d00bf2607f8a656749dca4968e326681dda5e6ff1d66594668d8eebf1a3c"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-Digest-MD4" = fetch {
    pname       = "perl-Digest-MD4";
    version     = "1.9";
    sources     = [{ filename = "perl-Digest-MD4-1.9-6-x86_64.pkg.tar.zst"; sha256 = "6cc39a0510001225750f10b78a824144b5dc3aa5356e7fa1f7dba1e1ae3b088d"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-Encode-Locale" = fetch {
    pname       = "perl-Encode-Locale";
    version     = "1.05";
    sources     = [{ filename = "perl-Encode-Locale-1.05-1-any.pkg.tar.xz"; sha256 = "56d82c71588c66dbee20e9acc7ed0e9bc09e40654593125b63086b59aeea8002"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.008"; perl) ];
  };

  "perl-Encode-compat" = fetch {
    pname       = "perl-Encode-compat";
    version     = "0.07";
    sources     = [{ filename = "perl-Encode-compat-0.07-1-any.pkg.tar.xz"; sha256 = "b277cf801059356941a7273d76dc67d32c13d136533378d4f2fbee90059c5127"; }];
    buildInputs = [ perl ];
  };

  "perl-Error" = fetch {
    pname       = "perl-Error";
    version     = "0.17029";
    sources     = [{ filename = "perl-Error-0.17029-1-any.pkg.tar.xz"; sha256 = "6cf683ba1453343294bc7eb81c4c4dbcab4061cd05d9f32ccc554395b3b5277c"; }];
    buildInputs = [ perl ];
  };

  "perl-Exporter-Lite" = fetch {
    pname       = "perl-Exporter-Lite";
    version     = "0.08";
    sources     = [{ filename = "perl-Exporter-Lite-0.08-1-any.pkg.tar.xz"; sha256 = "a027f79533e227a39a7e44325d19ada723d855a7679a7cc95b00b9cfce852f58"; }];
    buildInputs = [ perl ];
  };

  "perl-Exporter-Tiny" = fetch {
    pname       = "perl-Exporter-Tiny";
    version     = "1.002002";
    sources     = [{ filename = "perl-Exporter-Tiny-1.002002-1-any.pkg.tar.zst"; sha256 = "c24a62b3ef88d9305df404934ce887d44b6a4147c1791feda53c465a535c4236"; }];
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-Config" = fetch {
    pname       = "perl-ExtUtils-Config";
    version     = "0.008";
    sources     = [{ filename = "perl-ExtUtils-Config-0.008-1-any.pkg.tar.zst"; sha256 = "34f7e7a9dffa1f87587797954327f260b55e8b01403f10291d56b32667b4b8e2"; }];
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-Depends" = fetch {
    pname       = "perl-ExtUtils-Depends";
    version     = "0.8000";
    sources     = [{ filename = "perl-ExtUtils-Depends-0.8000-1-any.pkg.tar.xz"; sha256 = "eb569e2b4d685a1cb5534ed4b240496efe31d4a2dd773d11f4a35f8c91159457"; }];
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-Helpers" = fetch {
    pname       = "perl-ExtUtils-Helpers";
    version     = "0.026";
    sources     = [{ filename = "perl-ExtUtils-Helpers-0.026-1-any.pkg.tar.zst"; sha256 = "42b46572eace4670c8b4061ea5c80fe72a9878a945815ce00ae4f4abd4905ad0"; }];
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-InstallPaths" = fetch {
    pname       = "perl-ExtUtils-InstallPaths";
    version     = "0.012";
    sources     = [{ filename = "perl-ExtUtils-InstallPaths-0.012-1-any.pkg.tar.zst"; sha256 = "4ee99070d4a6bc35749f3c1d6998b562713336cab3605c0827475753f9b2ba1b"; }];
    buildInputs = [ perl perl-ExtUtils-Config ];
  };

  "perl-ExtUtils-MakeMaker" = fetch {
    pname       = "perl-ExtUtils-MakeMaker";
    version     = "7.46";
    sources     = [{ filename = "perl-ExtUtils-MakeMaker-7.46-1-any.pkg.tar.zst"; sha256 = "e1c27660c4fb5c50923ac3e97c335987c5981becac6d8bcd956ffa6635ecb016"; }];
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-PkgConfig" = fetch {
    pname       = "perl-ExtUtils-PkgConfig";
    version     = "1.16";
    sources     = [{ filename = "perl-ExtUtils-PkgConfig-1.16-1-any.pkg.tar.xz"; sha256 = "9b076317052f167d610ba8898de7fffbaedd947b04ae4414c1d342080c82619c"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-FFI-CheckLib" = fetch {
    pname       = "perl-FFI-CheckLib";
    version     = "0.27";
    sources     = [{ filename = "perl-FFI-CheckLib-0.27-1-any.pkg.tar.zst"; sha256 = "3ce31b397e65319aea54072807a1fc2b7897b16cb3a952147a23c432fd898ca6"; }];
    buildInputs = [ perl ];
  };

  "perl-File-Copy-Recursive" = fetch {
    pname       = "perl-File-Copy-Recursive";
    version     = "0.45";
    sources     = [{ filename = "perl-File-Copy-Recursive-0.45-1-any.pkg.tar.xz"; sha256 = "a99f0ad3d46a26891351ae4c46b21979f00063013699f77175cbb5597482eaba"; }];
    buildInputs = [ perl ];
  };

  "perl-File-Listing" = fetch {
    pname       = "perl-File-Listing";
    version     = "6.04";
    sources     = [{ filename = "perl-File-Listing-6.04-2-any.pkg.tar.xz"; sha256 = "4f48fe3bde66ab216ae4a5c9ebf83dd4a490033bcdbc7abea26d59346bbb11bb"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.8"; perl) (assert stdenvNoCC.lib.versionAtLeast perl-HTTP-Date.version "6"; perl-HTTP-Date) ];
  };

  "perl-File-Next" = fetch {
    pname       = "perl-File-Next";
    version     = "1.18";
    sources     = [{ filename = "perl-File-Next-1.18-1-any.pkg.tar.xz"; sha256 = "ecae2b36dfa141147fe43fe8b0c1a5d8f350725c000a3f396ff86fa028a9f6d4"; }];
    buildInputs = [ perl ];
  };

  "perl-File-Which" = fetch {
    pname       = "perl-File-Which";
    version     = "1.23";
    sources     = [{ filename = "perl-File-Which-1.23-1-any.pkg.tar.xz"; sha256 = "6ef52d8f55ced429a8cab3a74883ab5af2d8cee8b125edfafd9c705ab5c56890"; }];
    buildInputs = [ perl (assert stdenvNoCC.lib.versionAtLeast perl-Test-Script.version "1.05"; perl-Test-Script) ];
  };

  "perl-File-chdir" = fetch {
    pname       = "perl-File-chdir";
    version     = "0.1011";
    sources     = [{ filename = "perl-File-chdir-0.1011-1-any.pkg.tar.xz"; sha256 = "62a0908d97de061a5ec95b90ca0e45fcd1e120c8763d1773696eea32d1ecbf05"; }];
    buildInputs = [ perl ];
  };

  "perl-Font-TTF" = fetch {
    pname       = "perl-Font-TTF";
    version     = "1.06";
    sources     = [{ filename = "perl-Font-TTF-1.06-1-any.pkg.tar.xz"; sha256 = "f6a455372ce83e89f03958423199cee7c7950210803a7ca9ea5d957b9306f71b"; }];
    buildInputs = [ perl-IO-String ];
  };

  "perl-Getopt-ArgvFile" = fetch {
    pname       = "perl-Getopt-ArgvFile";
    version     = "1.11";
    sources     = [{ filename = "perl-Getopt-ArgvFile-1.11-1-any.pkg.tar.xz"; sha256 = "c9e436c107c11d15576e03252272e156ce308bec624e949b885177d6a140ce59"; }];
    buildInputs = [ perl ];
  };

  "perl-Getopt-Tabular" = fetch {
    pname       = "perl-Getopt-Tabular";
    version     = "0.3";
    sources     = [{ filename = "perl-Getopt-Tabular-0.3-1-any.pkg.tar.xz"; sha256 = "d803fcfdf1d0bdfa78a90abc2bf65e7bc54c19ecceecc6ff13d5de3df13798fa"; }];
    buildInputs = [ perl ];
  };

  "perl-HTML-Parser" = fetch {
    pname       = "perl-HTML-Parser";
    version     = "3.72";
    sources     = [{ filename = "perl-HTML-Parser-3.72-6-x86_64.pkg.tar.zst"; sha256 = "f3aa2d5661988960dd444ffe4fce7643771e15359fa259169f4c0bf44f6b6e6a"; }];
    buildInputs = [ perl-HTML-Tagset perl ];
  };

  "perl-HTML-Tagset" = fetch {
    pname       = "perl-HTML-Tagset";
    version     = "3.20";
    sources     = [{ filename = "perl-HTML-Tagset-3.20-2-any.pkg.tar.xz"; sha256 = "f3b2b1d3c27b2528449c4b09a1a164bfa0b88a75dfea399ef6402fed0d13a66d"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-HTTP-Cookies" = fetch {
    pname       = "perl-HTTP-Cookies";
    version     = "6.08";
    sources     = [{ filename = "perl-HTTP-Cookies-6.08-1-any.pkg.tar.xz"; sha256 = "14aefa6b3419e276f613aba69f8e5950dd43ee8805796d9fdef5ae6634ea4554"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.8"; perl) (assert stdenvNoCC.lib.versionAtLeast perl-HTTP-Date.version "6"; perl-HTTP-Date) perl-HTTP-Message ];
  };

  "perl-HTTP-Daemon" = fetch {
    pname       = "perl-HTTP-Daemon";
    version     = "6.12";
    sources     = [{ filename = "perl-HTTP-Daemon-6.12-1-any.pkg.tar.zst"; sha256 = "0eacc8019e3a8ac487a530c1bb043c17b46b2c09445aefcd1c8f147751fe7658"; }];
    buildInputs = [ perl perl-HTTP-Date perl-HTTP-Message perl-IO-Socket-IP perl-LWP-MediaTypes ];
  };

  "perl-HTTP-Date" = fetch {
    pname       = "perl-HTTP-Date";
    version     = "6.05";
    sources     = [{ filename = "perl-HTTP-Date-6.05-1-any.pkg.tar.xz"; sha256 = "9516215f1bf023402b56ec7611e5476dce28790cbc65e8a0ce1d6c825cafd461"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.8"; perl) ];
  };

  "perl-HTTP-Message" = fetch {
    pname       = "perl-HTTP-Message";
    version     = "6.25";
    sources     = [{ filename = "perl-HTTP-Message-6.25-2-any.pkg.tar.zst"; sha256 = "d596c6cd6fb36f71261712eff0030774b999564ee012146f2f317b0fe6280f9d"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.8"; perl) perl-Clone (assert stdenvNoCC.lib.versionAtLeast perl-Encode-Locale.version "1"; perl-Encode-Locale) perl-IO-HTML (assert stdenvNoCC.lib.versionAtLeast perl-HTML-Parser.version "3.33"; perl-HTML-Parser) (assert stdenvNoCC.lib.versionAtLeast perl-HTTP-Date.version "6"; perl-HTTP-Date) (assert stdenvNoCC.lib.versionAtLeast perl-LWP-MediaTypes.version "6"; perl-LWP-MediaTypes) (assert stdenvNoCC.lib.versionAtLeast perl-URI.version "1.10"; perl-URI) ];
  };

  "perl-HTTP-Negotiate" = fetch {
    pname       = "perl-HTTP-Negotiate";
    version     = "6.01";
    sources     = [{ filename = "perl-HTTP-Negotiate-6.01-2-any.pkg.tar.xz"; sha256 = "c81c85f2c89d7022d9bc6cd29424b13db94a05dc47c8ca47730cd47d3d8e6be8"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.8"; perl) perl-HTTP-Message ];
  };

  "perl-IO-HTML" = fetch {
    pname       = "perl-IO-HTML";
    version     = "1.001";
    sources     = [{ filename = "perl-IO-HTML-1.001-1-any.pkg.tar.xz"; sha256 = "98b3689bac2cf0ed60c7fe02c2caa441e18e48044b317207a7d502293b291d1b"; }];
    buildInputs = [ perl ];
  };

  "perl-IO-Socket-INET6" = fetch {
    pname       = "perl-IO-Socket-INET6";
    version     = "2.72";
    sources     = [{ filename = "perl-IO-Socket-INET6-2.72-4-any.pkg.tar.xz"; sha256 = "2b325a3819720cadbd4c94d00b0c60bba9b83cb4fa7eea7cfeec5cbd62676d90"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl-Socket6.version "0.12"; perl-Socket6) ];
  };

  "perl-IO-Socket-IP" = fetch {
    pname       = "perl-IO-Socket-IP";
    version     = "0.39";
    sources     = [{ filename = "perl-IO-Socket-IP-0.39-1-any.pkg.tar.zst"; sha256 = "a653d80318aac2bb70f9475a2515b05684fc95f71a50c848cc5ba2dca8f7134a"; }];
    buildInputs = [ perl ];
  };

  "perl-IO-Socket-SSL" = fetch {
    pname       = "perl-IO-Socket-SSL";
    version     = "2.068";
    sources     = [{ filename = "perl-IO-Socket-SSL-2.068-1-any.pkg.tar.zst"; sha256 = "8f7c8b1c63a99638c1b171847bbb7eb4fb3b481c0ee6d4ccd7082ffac16aa191"; }];
    buildInputs = [ perl-Net-SSLeay perl perl-URI ];
  };

  "perl-IO-String" = fetch {
    pname       = "perl-IO-String";
    version     = "1.08";
    sources     = [{ filename = "perl-IO-String-1.08-9-x86_64.pkg.tar.xz"; sha256 = "62e6322c190cfadc6ba8407bdecc6c41c3f304201e5d12cf4525df22893f931a"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-IO-Stringy" = fetch {
    pname       = "perl-IO-Stringy";
    version     = "2.113";
    sources     = [{ filename = "perl-IO-Stringy-2.113-1-any.pkg.tar.zst"; sha256 = "786ec871dfd889ddd3411fafade368d26a1902c1bc51c3a5fe0ea9f36853b449"; }];
    buildInputs = [ perl ];
  };

  "perl-IPC-Run3" = fetch {
    pname       = "perl-IPC-Run3";
    version     = "0.048";
    sources     = [{ filename = "perl-IPC-Run3-0.048-1-any.pkg.tar.xz"; sha256 = "926b1daa99c5d33dcca9a5dae8f05b4586fae5ca10f9e100d488ac49a13ca3d6"; }];
    buildInputs = [ perl ];
  };

  "perl-Import-Into" = fetch {
    pname       = "perl-Import-Into";
    version     = "1.002005";
    sources     = [{ filename = "perl-Import-Into-1.002005-1-any.pkg.tar.xz"; sha256 = "efd5e1ec5e812f30c2186d04a56e06c4ec9a61708baeb0afd76acf42b0261ab9"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl-Module-Runtime.version "0"; perl-Module-Runtime) (assert stdenvNoCC.lib.versionAtLeast perl.version "5.006"; perl) ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "perl-Importer" = fetch {
    pname       = "perl-Importer";
    version     = "0.025";
    sources     = [{ filename = "perl-Importer-0.025-1-any.pkg.tar.xz"; sha256 = "0000ac85effbe151aa3b590f190f03ae64230fb6357fb29316c0d3dc4a358b11"; }];
    buildInputs = [ perl ];
  };

  "perl-JSON" = fetch {
    pname       = "perl-JSON";
    version     = "4.02";
    sources     = [{ filename = "perl-JSON-4.02-1-any.pkg.tar.zst"; sha256 = "a790d9cb63536173917fb7c7e29789a69d208075d3dff9178b2595b2335c2bbd"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-LWP-MediaTypes" = fetch {
    pname       = "perl-LWP-MediaTypes";
    version     = "6.04";
    sources     = [{ filename = "perl-LWP-MediaTypes-6.04-1-any.pkg.tar.zst"; sha256 = "f09a68da0b31b91b553cf47783328d32525b55f5dcfbc01b5166ea6eab5a01a6"; }];
    buildInputs = [ perl ];
  };

  "perl-LWP-Protocol-https" = fetch {
    pname       = "perl-LWP-Protocol-https";
    version     = "6.09";
    sources     = [{ filename = "perl-LWP-Protocol-https-6.09-1-any.pkg.tar.zst"; sha256 = "8173ebb2883d5c5314342dc55b821b22e6d47d0bb5007da3c0c31f158450582b"; }];
    buildInputs = [ perl perl-IO-Socket-SSL perl-Mozilla-CA perl-Net-HTTP perl-libwww ];
  };

  "perl-List-MoreUtils" = fetch {
    pname       = "perl-List-MoreUtils";
    version     = "0.428";
    sources     = [{ filename = "perl-List-MoreUtils-0.428-1-any.pkg.tar.xz"; sha256 = "66f3168737720c973658b748864726044da2fe2e0e0d6732e80fa3bba848e97c"; }];
    buildInputs = [ perl perl-Exporter-Tiny perl-List-MoreUtils-XS ];
  };

  "perl-List-MoreUtils-XS" = fetch {
    pname       = "perl-List-MoreUtils-XS";
    version     = "0.428";
    sources     = [{ filename = "perl-List-MoreUtils-XS-0.428-6-x86_64.pkg.tar.zst"; sha256 = "d4749095b4d19320c04832ab197b61e6f64b8745aae34415fef25f63b9732771"; }];
    buildInputs = [ perl ];
  };

  "perl-Locale-Gettext" = fetch {
    pname       = "perl-Locale-Gettext";
    version     = "1.07";
    sources     = [{ filename = "perl-Locale-Gettext-1.07-7-x86_64.pkg.tar.zst"; sha256 = "55d89a913b8838ebb715257a70d5fc6a58f4a5ffb030c91acd6bdb56dd758420"; }];
    buildInputs = [ gettext perl ];
  };

  "perl-MIME-Charset" = fetch {
    pname       = "perl-MIME-Charset";
    version     = "1.012.2";
    sources     = [{ filename = "perl-MIME-Charset-1.012.2-1-any.pkg.tar.xz"; sha256 = "cf0e9ffa18dc6063322e94f89320c0f546770dafbe4ab9a583ef50eb8e603d98"; }];
    buildInputs = [ perl ];
  };

  "perl-MIME-tools" = fetch {
    pname       = "perl-MIME-tools";
    version     = "5.509";
    sources     = [{ filename = "perl-MIME-tools-5.509-1-any.pkg.tar.xz"; sha256 = "88459205a2a53d5ef2204d3d9fd7d9c992480f352f3301862a10fc85e2c261c2"; }];
    buildInputs = [ perl-MailTools perl-IO-stringy perl-Convert-BinHex ];
    broken      = true; # broken dependency perl-MIME-tools -> perl-IO-stringy
  };

  "perl-MailTools" = fetch {
    pname       = "perl-MailTools";
    version     = "2.21";
    sources     = [{ filename = "perl-MailTools-2.21-1-any.pkg.tar.xz"; sha256 = "f2699b7d3c9d6e3dbc2c1b7372aeb4b0ad11ea0f2b0fbd5b24c78570990999b6"; }];
    buildInputs = [ perl-TimeDate ];
  };

  "perl-Math-Int64" = fetch {
    pname       = "perl-Math-Int64";
    version     = "0.54";
    sources     = [{ filename = "perl-Math-Int64-0.54-6-x86_64.pkg.tar.zst"; sha256 = "1665f37d0c24dcfda885450ffb08c8b073a7ac9877da3cfa79c572d880483191"; }];
    buildInputs = [ perl ];
  };

  "perl-Module-Build" = fetch {
    pname       = "perl-Module-Build";
    version     = "0.4231";
    sources     = [{ filename = "perl-Module-Build-0.4231-1-any.pkg.tar.xz"; sha256 = "f0463b55bccd89249303790138ece884b084f9998819b1608830c630a9b2811e"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.0"; perl) (assert stdenvNoCC.lib.versionAtLeast perl-CPAN-Meta.version "2.142060"; perl-CPAN-Meta) perl-inc-latest ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "perl-Module-Build-Tiny" = fetch {
    pname       = "perl-Module-Build-Tiny";
    version     = "0.039";
    sources     = [{ filename = "perl-Module-Build-Tiny-0.039-1-any.pkg.tar.zst"; sha256 = "10a22d617bbf34771a9830672da29a46bf4703793d518b6052fcba942fb0d49a"; }];
    buildInputs = [ perl perl-ExtUtils-Config perl-ExtUtils-Helpers perl-ExtUtils-InstallPaths ];
  };

  "perl-Module-Pluggable" = fetch {
    pname       = "perl-Module-Pluggable";
    version     = "5.2";
    sources     = [{ filename = "perl-Module-Pluggable-5.2-1-any.pkg.tar.xz"; sha256 = "416b6bed3130bb538eaddf0977fcd5d5e88cffcc2a30ef4911f1df83982f0b05"; }];
    buildInputs = [ perl ];
  };

  "perl-Module-Runtime" = fetch {
    pname       = "perl-Module-Runtime";
    version     = "0.016";
    sources     = [{ filename = "perl-Module-Runtime-0.016-1-any.pkg.tar.xz"; sha256 = "bbb06ad376ae6c2d252f14ef97bebc48dc9ac829764daa9dff51a11bb443e18b"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.0"; perl) perl-Module-Build ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "perl-Moo" = fetch {
    pname       = "perl-Moo";
    version     = "2.003006";
    sources     = [{ filename = "perl-Moo-2.003006-1-any.pkg.tar.xz"; sha256 = "206cb72affbe08be035dc3b07ae530bec205f51e713779f32a175299d7e098c5"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl-Class-Method-Modifiers.version "1.1"; perl-Class-Method-Modifiers) (assert stdenvNoCC.lib.versionAtLeast perl-Devel-GlobalDestruction.version "0.11"; perl-Devel-GlobalDestruction) (assert stdenvNoCC.lib.versionAtLeast perl-Import-Into.version "1.002"; perl-Import-Into) (assert stdenvNoCC.lib.versionAtLeast perl-Module-Runtime.version "0.014"; perl-Module-Runtime) (assert stdenvNoCC.lib.versionAtLeast perl-Role-Tiny.version "2"; perl-Role-Tiny) perl-Sub-Quote ];
    broken      = true; # broken dependency perl-Data-OptList -> perl-Scalar-List-Utils
  };

  "perl-Mozilla-CA" = fetch {
    pname       = "perl-Mozilla-CA";
    version     = "20200520";
    sources     = [{ filename = "perl-Mozilla-CA-20200520-1-any.pkg.tar.zst"; sha256 = "87a463ef44c1df8a7026f311897b3849ad4ac79edf057c7de0b0e3c41fd49374"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.006"; perl) ];
  };

  "perl-Net-DNS" = fetch {
    pname       = "perl-Net-DNS";
    version     = "1.25";
    sources     = [{ filename = "perl-Net-DNS-1.25-1-x86_64.pkg.tar.zst"; sha256 = "a54d08e34967bf5f791f5138753f87cd669c8cdcfcaa941005b0bee3b4b06785"; }];
    buildInputs = [ perl-Digest-HMAC perl-Net-IP perl ];
  };

  "perl-Net-HTTP" = fetch {
    pname       = "perl-Net-HTTP";
    version     = "6.19";
    sources     = [{ filename = "perl-Net-HTTP-6.19-1-any.pkg.tar.xz"; sha256 = "7e549450c9e4c38aa31ae600dcbd867b9ac6ca35a52d38cb913fd97342fef5d8"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.6.2"; perl) ];
  };

  "perl-Net-IP" = fetch {
    pname       = "perl-Net-IP";
    version     = "1.26";
    sources     = [{ filename = "perl-Net-IP-1.26-2-any.pkg.tar.xz"; sha256 = "d78c5b12885a4bb6cf33d17befde8e4bdcb13d999f500b8c2c81b82d8d1d513e"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-Net-SMTP-SSL" = fetch {
    pname       = "perl-Net-SMTP-SSL";
    version     = "1.04";
    sources     = [{ filename = "perl-Net-SMTP-SSL-1.04-1-any.pkg.tar.xz"; sha256 = "2e92cfa091690aa80ae53042f4434c41356ead5bf6722c12b419bedd731dd235"; }];
    buildInputs = [ perl-IO-Socket-SSL ];
  };

  "perl-Net-SSLeay" = fetch {
    pname       = "perl-Net-SSLeay";
    version     = "1.89_01";
    sources     = [{ filename = "perl-Net-SSLeay-1.89_01-3-x86_64.pkg.tar.zst"; sha256 = "8f6116e1b03d06a4f04c2772511e63a57662d61aeab47e68cbc039a7c8261653"; }];
    buildInputs = [ openssl ];
  };

  "perl-Parallel-ForkManager" = fetch {
    pname       = "perl-Parallel-ForkManager";
    version     = "2.02";
    sources     = [{ filename = "perl-Parallel-ForkManager-2.02-2-any.pkg.tar.xz"; sha256 = "201ffdce7b6183ce8338c340108cf368e1e307ec93344695245282b38aab89f2"; }];
    buildInputs = [ perl perl-Moo ];
    broken      = true; # broken dependency perl-Data-OptList -> perl-Scalar-List-Utils
  };

  "perl-Params-Util" = fetch {
    pname       = "perl-Params-Util";
    version     = "1.07";
    sources     = [{ filename = "perl-Params-Util-1.07-1-x86_64.pkg.tar.xz"; sha256 = "0b2513f536563f468e076e014d905a2f779d0dcd14feed79c43b511f7b0d1e2b"; }];
    buildInputs = [ perl ];
  };

  "perl-Path-Class" = fetch {
    pname       = "perl-Path-Class";
    version     = "0.37";
    sources     = [{ filename = "perl-Path-Class-0.37-1-any.pkg.tar.xz"; sha256 = "b3a24528895ca7e977db5c8b614a757f5a42f68fa00e053c165c26defe620e25"; }];
    buildInputs = [ perl ];
  };

  "perl-Path-Tiny" = fetch {
    pname       = "perl-Path-Tiny";
    version     = "0.114";
    sources     = [{ filename = "perl-Path-Tiny-0.114-1-any.pkg.tar.zst"; sha256 = "1d9859246cf8d475b2fb4df18acb067af6d552a53d4bdcc07cddbfa9b2d230b3"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.1"; perl) ];
  };

  "perl-PerlIO-gzip" = fetch {
    pname       = "perl-PerlIO-gzip";
    version     = "0.20";
    sources     = [{ filename = "perl-PerlIO-gzip-0.20-3-x86_64.pkg.tar.zst"; sha256 = "3749b6c540cbdafe1e2ea49b68a4966732e227c3a42e39acc8d993f944702932"; }];
    buildInputs = [ perl zlib ];
  };

  "perl-Pod-Parser" = fetch {
    pname       = "perl-Pod-Parser";
    version     = "1.63";
    sources     = [{ filename = "perl-Pod-Parser-1.63-1-any.pkg.tar.zst"; sha256 = "942a099222f0d2dffab700a73ae772e2f093974b85d680aff82d74d330fdcae6"; }];
    buildInputs = [ perl ];
  };

  "perl-Probe-Perl" = fetch {
    pname       = "perl-Probe-Perl";
    version     = "0.03";
    sources     = [{ filename = "perl-Probe-Perl-0.03-2-any.pkg.tar.xz"; sha256 = "c1c5bc6b216df705a508a2628decc08065d7ae9e006e981d1159ddc8947aa70a"; }];
    buildInputs = [ perl ];
  };

  "perl-Regexp-Common" = fetch {
    pname       = "perl-Regexp-Common";
    version     = "2017060201";
    sources     = [{ filename = "perl-Regexp-Common-2017060201-1-any.pkg.tar.xz"; sha256 = "38b99a97e5374cc1a278ce4b85b54ecc9c444d09ac597a4895a8af7dc97d9734"; }];
    buildInputs = [ perl ];
  };

  "perl-Return-MultiLevel" = fetch {
    pname       = "perl-Return-MultiLevel";
    version     = "0.05";
    sources     = [{ filename = "perl-Return-MultiLevel-0.05-1-any.pkg.tar.xz"; sha256 = "ccee7d2d97ef6b82e6b157943a4cca02506a8e1e7d0fb6db6253246fa067232a"; }];
    buildInputs = [ perl-Data-Munge ];
  };

  "perl-Role-Tiny" = fetch {
    pname       = "perl-Role-Tiny";
    version     = "2.001004";
    sources     = [{ filename = "perl-Role-Tiny-2.001004-1-any.pkg.tar.xz"; sha256 = "1dd2bce68d5ce0eb1e42339c4323503337f7a53bfda2962f7f42fbb5878c0c21"; }];
    buildInputs = [ perl ];
  };

  "perl-Scope-Guard" = fetch {
    pname       = "perl-Scope-Guard";
    version     = "0.21";
    sources     = [{ filename = "perl-Scope-Guard-0.21-1-any.pkg.tar.xz"; sha256 = "08176a6d8781d19f69441a8dbbf8da84b80ddff3a41c2b5ca573568bce218537"; }];
    buildInputs = [ perl ];
  };

  "perl-Socket6" = fetch {
    pname       = "perl-Socket6";
    version     = "0.29";
    sources     = [{ filename = "perl-Socket6-0.29-5-x86_64.pkg.tar.zst"; sha256 = "c5ba111ab1ead79c85866c7d1b06a37d79c33b1411714ca9f1c8b409846289e1"; }];
    buildInputs = [ perl ];
  };

  "perl-Sort-Versions" = fetch {
    pname       = "perl-Sort-Versions";
    version     = "1.62";
    sources     = [{ filename = "perl-Sort-Versions-1.62-1-any.pkg.tar.xz"; sha256 = "dc210b425c8fb5eff83b59470fe77a00fe3820e2000576bcc37e2e7fbcb0ab2e"; }];
    buildInputs = [ perl ];
  };

  "perl-Spiffy" = fetch {
    pname       = "perl-Spiffy";
    version     = "0.46";
    sources     = [{ filename = "perl-Spiffy-0.46-1-any.pkg.tar.xz"; sha256 = "aee7a3e220d1080fac9c92c183164bbd461a5ce796d5102e31df6a8f18e0045e"; }];
    buildInputs = [ perl ];
  };

  "perl-Sub-Exporter" = fetch {
    pname       = "perl-Sub-Exporter";
    version     = "0.987";
    sources     = [{ filename = "perl-Sub-Exporter-0.987-1-any.pkg.tar.xz"; sha256 = "2da1ca4933d51d48c2a5ecf15d0efa24f9b079c48986e955089497fa11df0398"; }];
    buildInputs = [ perl perl-Data-OptList perl-Params-Util perl-Sub-Install ];
    broken      = true; # broken dependency perl-Data-OptList -> perl-Scalar-List-Utils
  };

  "perl-Sub-Exporter-Progressive" = fetch {
    pname       = "perl-Sub-Exporter-Progressive";
    version     = "0.001013";
    sources     = [{ filename = "perl-Sub-Exporter-Progressive-0.001013-1-any.pkg.tar.xz"; sha256 = "f0c81aa3b2a5121dca7b6760c97210ff5535edeb4725472f0884c813aa3b223b"; }];
    buildInputs = [ perl ];
  };

  "perl-Sub-Info" = fetch {
    pname       = "perl-Sub-Info";
    version     = "0.002";
    sources     = [{ filename = "perl-Sub-Info-0.002-1-any.pkg.tar.xz"; sha256 = "fd2959bf49751a7e0627cde9b3fd9d7be153e63829c9722606d738a442d1e385"; }];
    buildInputs = [ perl-Importer ];
  };

  "perl-Sub-Install" = fetch {
    pname       = "perl-Sub-Install";
    version     = "0.928";
    sources     = [{ filename = "perl-Sub-Install-0.928-1-any.pkg.tar.xz"; sha256 = "e7ee0e508ff9a202b683987b32efa966db07ff99e882a7d3bf9ff8ac58260586"; }];
    buildInputs = [ perl ];
  };

  "perl-Sub-Quote" = fetch {
    pname       = "perl-Sub-Quote";
    version     = "2.006006";
    sources     = [{ filename = "perl-Sub-Quote-2.006006-1-any.pkg.tar.zst"; sha256 = "d2899fb716428000d938d860dac530f55615b12e1f1c5ff39c8c64dd713efb9b"; }];
    buildInputs = [ perl ];
  };

  "perl-Sys-CPU" = fetch {
    pname       = "perl-Sys-CPU";
    version     = "0.61";
    sources     = [{ filename = "perl-Sys-CPU-0.61-9-x86_64.pkg.tar.zst"; sha256 = "dfcc1ba60bb82f8d4b671af1fc3183c6b6126170494bda7bc7f0b114ed58219c"; }];
    buildInputs = [ perl ];
  };

  "perl-TAP-Harness-Archive" = fetch {
    pname       = "perl-TAP-Harness-Archive";
    version     = "0.18";
    sources     = [{ filename = "perl-TAP-Harness-Archive-0.18-1-any.pkg.tar.xz"; sha256 = "49966dd01f79fb86600cb91cfc2b82ac76418b604c2963f88499ed93d0e46d34"; }];
    buildInputs = [ perl-YAML-Tiny perl ];
  };

  "perl-Term-Table" = fetch {
    pname       = "perl-Term-Table";
    version     = "0.015";
    sources     = [{ filename = "perl-Term-Table-0.015-1-any.pkg.tar.xz"; sha256 = "91172b8e76929d51574f9df537b3624a1e91ac7f270594d56a97ec76df1c22ec"; }];
    buildInputs = [ perl-Importer ];
  };

  "perl-TermReadKey" = fetch {
    pname       = "perl-TermReadKey";
    version     = "2.38";
    sources     = [{ filename = "perl-TermReadKey-2.38-2-x86_64.pkg.tar.zst"; sha256 = "333eac92f50d7f94f038bcf9030be14b0c1a5e33fac5a81e0e5852ff7d583242"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Base" = fetch {
    pname       = "perl-Test-Base";
    version     = "0.89";
    sources     = [{ filename = "perl-Test-Base-0.89-1-any.pkg.tar.xz"; sha256 = "6732359b469fdc1ad21bf438ca1a785adcfa45c496752a0f9bbfe5a3408bfe2c"; }];
    buildInputs = [ perl perl-Spiffy perl-Text-Diff ];
    broken      = true; # broken dependency perl-Text-Diff -> perl-Exporter
  };

  "perl-Test-Deep" = fetch {
    pname       = "perl-Test-Deep";
    version     = "1.130";
    sources     = [{ filename = "perl-Test-Deep-1.130-1-any.pkg.tar.xz"; sha256 = "bee521831740bbdb3a010b6e10353b7c13c6663ce7a0e2b82e5bd942ac12cb1c"; }];
    buildInputs = [ perl perl-Test-Simple perl-Test-NoWarnings ];
  };

  "perl-Test-Exit" = fetch {
    pname       = "perl-Test-Exit";
    version     = "0.11";
    sources     = [{ filename = "perl-Test-Exit-0.11-1-any.pkg.tar.xz"; sha256 = "4133ee69a0de16186c1a8eef253b1a39e2c0687bc909f065e5c251a7d097869b"; }];
    buildInputs = [ perl-Return-MultiLevel ];
  };

  "perl-Test-Fatal" = fetch {
    pname       = "perl-Test-Fatal";
    version     = "0.014";
    sources     = [{ filename = "perl-Test-Fatal-0.014-1-any.pkg.tar.xz"; sha256 = "df0e0ffaaf16f3b938ae210beb34f06cfb5e05c036e8efeea9cf334f1dc58773"; }];
    buildInputs = [ perl perl-Try-Tiny ];
  };

  "perl-Test-Harness" = fetch {
    pname       = "perl-Test-Harness";
    version     = "3.42";
    sources     = [{ filename = "perl-Test-Harness-3.42-1-any.pkg.tar.xz"; sha256 = "bf7843e83bc8351ab8b3c25943807b8f81a5c1bfb0aaba152db741732337ed86"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Needs" = fetch {
    pname       = "perl-Test-Needs";
    version     = "0.002006";
    sources     = [{ filename = "perl-Test-Needs-0.002006-1-any.pkg.tar.xz"; sha256 = "cb54bf87e407b1391d143c3ff7dda5250552a3c767d2b0d85788df8a636e816a"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-NoWarnings" = fetch {
    pname       = "perl-Test-NoWarnings";
    version     = "1.04";
    sources     = [{ filename = "perl-Test-NoWarnings-1.04-1-any.pkg.tar.xz"; sha256 = "2ae02b5d0cebd00869c1e102ad147d3a97d2b6dab891a5fd09ada9f214757378"; }];
    buildInputs = [ perl perl-Test-Simple ];
  };

  "perl-Test-Pod" = fetch {
    pname       = "perl-Test-Pod";
    version     = "1.52";
    sources     = [{ filename = "perl-Test-Pod-1.52-1-any.pkg.tar.xz"; sha256 = "e63f00957a37c8a797aae80a774d87c2310c38ff0658a6b9714fe2c44211b9fe"; }];
    buildInputs = [ perl perl-Module-Build ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "perl-Test-Requires" = fetch {
    pname       = "perl-Test-Requires";
    version     = "0.11";
    sources     = [{ filename = "perl-Test-Requires-0.11-1-any.pkg.tar.zst"; sha256 = "94eed403dc89258ac87301758476127cbc2675266398ebab1aa938cb26173281"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Requiresinternet" = fetch {
    pname       = "perl-Test-Requiresinternet";
    version     = "0.05";
    sources     = [{ filename = "perl-Test-Requiresinternet-0.05-1-any.pkg.tar.xz"; sha256 = "d3a7f2b885579245c3119361ae70a5260a8a765fd11b380efaa31db4e4143487"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Script" = fetch {
    pname       = "perl-Test-Script";
    version     = "1.26";
    sources     = [{ filename = "perl-Test-Script-1.26-1-any.pkg.tar.xz"; sha256 = "6f03585ca760bfd024995ea8be6c758cfe4e8dcad498e7cb8b7988bcc7705dc2"; }];
    buildInputs = [ perl perl-IPC-Run3 perl-Probe-Perl perl-Test-Simple ];
  };

  "perl-Test-Simple" = fetch {
    pname       = "perl-Test-Simple";
    version     = "1.302175";
    sources     = [{ filename = "perl-Test-Simple-1.302175-1-any.pkg.tar.xz"; sha256 = "0333a47667b2633e8d85859862774ed1077fa02b5d05856f9f6fe48ed659d889"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-Warnings" = fetch {
    pname       = "perl-Test-Warnings";
    version     = "0.030";
    sources     = [{ filename = "perl-Test-Warnings-0.030-1-any.pkg.tar.zst"; sha256 = "cc79fdeeab0c2a0feb7f1691739b7fe3a3a4f5251f56540d64b6574e41cbc19f"; }];
    buildInputs = [ perl ];
  };

  "perl-Test-YAML" = fetch {
    pname       = "perl-Test-YAML";
    version     = "1.07";
    sources     = [{ filename = "perl-Test-YAML-1.07-1-any.pkg.tar.xz"; sha256 = "2f50588f47c264b7559edd35712ca06a90a703feb374eaa8599d47b0e1ed966f"; }];
    buildInputs = [ perl perl-Test-Base ];
    broken      = true; # broken dependency perl-Text-Diff -> perl-Exporter
  };

  "perl-Test2-Suite" = fetch {
    pname       = "perl-Test2-Suite";
    version     = "0.000130";
    sources     = [{ filename = "perl-Test2-Suite-0.000130-1-any.pkg.tar.zst"; sha256 = "c1513f488827c7a665cebd6d1c2c719f40cd4d418e283c845b8e173012814e12"; }];
    buildInputs = [ perl-Module-Pluggable perl-Importer perl-Scope-Guard perl-Sub-Info perl-Term-Table (assert stdenvNoCC.lib.versionAtLeast perl-Test-Simple.version "1.302158"; perl-Test-Simple) ];
  };

  "perl-Text-CharWidth" = fetch {
    pname       = "perl-Text-CharWidth";
    version     = "0.04";
    sources     = [{ filename = "perl-Text-CharWidth-0.04-6-x86_64.pkg.tar.zst"; sha256 = "b0a07a9f5580c06e7aafa06aed094877307876cb6bd20a9c92799a933e4cd18e"; }];
    buildInputs = [ perl libcrypt ];
  };

  "perl-Text-Diff" = fetch {
    pname       = "perl-Text-Diff";
    version     = "1.45";
    sources     = [{ filename = "perl-Text-Diff-1.45-1-any.pkg.tar.xz"; sha256 = "9b4bdfed7375d2edc84ddb35ba8215435b0a077e5f5117c690fef97b649cea4a"; }];
    buildInputs = [ perl perl-Algorithm-Diff perl-Exporter ];
    broken      = true; # broken dependency perl-Text-Diff -> perl-Exporter
  };

  "perl-Text-WrapI18N" = fetch {
    pname       = "perl-Text-WrapI18N";
    version     = "0.06";
    sources     = [{ filename = "perl-Text-WrapI18N-0.06-1-any.pkg.tar.xz"; sha256 = "883e64f5f80446326fdacca0e989aea4e20bb2dafe52eb0347745566a0ce1c36"; }];
    buildInputs = [ perl perl-Text-CharWidth ];
  };

  "perl-TimeDate" = fetch {
    pname       = "perl-TimeDate";
    version     = "2.33";
    sources     = [{ filename = "perl-TimeDate-2.33-1-any.pkg.tar.zst"; sha256 = "ee80c1b3ae1855ff39826fef4ec1dceb6a2aec3425fa0c65b8004ee3332b20a8"; }];
    buildInputs = [ perl ];
  };

  "perl-Try-Tiny" = fetch {
    pname       = "perl-Try-Tiny";
    version     = "0.30";
    sources     = [{ filename = "perl-Try-Tiny-0.30-1-any.pkg.tar.xz"; sha256 = "20ac25b02899e85ebab23f5557b5deaacb8c4f18109e67ecd6128a9ddb944341"; }];
    buildInputs = [ perl ];
  };

  "perl-URI" = fetch {
    pname       = "perl-URI";
    version     = "1.76";
    sources     = [{ filename = "perl-URI-1.76-1-any.pkg.tar.xz"; sha256 = "46f3e369e56f0eadb542ecb694ca62c012755c759cb0a169ba47afc2f7e6981a"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) ];
  };

  "perl-Unicode-GCString" = fetch {
    pname       = "perl-Unicode-GCString";
    version     = "2019.001";
    sources     = [{ filename = "perl-Unicode-GCString-2019.001-3-x86_64.pkg.tar.zst"; sha256 = "44d69d386eadff0ca400ba03f772f20269d76794916350cc230cfe72a70bdc2e"; }];
    buildInputs = [ perl perl-MIME-Charset ];
  };

  "perl-WWW-RobotRules" = fetch {
    pname       = "perl-WWW-RobotRules";
    version     = "6.02";
    sources     = [{ filename = "perl-WWW-RobotRules-6.02-2-any.pkg.tar.xz"; sha256 = "740d79af6618e8cb82bc22f2b913abefa14a40360b4e0e40d35522048146d366"; }];
    buildInputs = [ perl perl-URI ];
  };

  "perl-XML-LibXML" = fetch {
    pname       = "perl-XML-LibXML";
    version     = "2.0205";
    sources     = [{ filename = "perl-XML-LibXML-2.0205-3-x86_64.pkg.tar.zst"; sha256 = "d091ddb75b9092abd74434612589c9f872885ab4ef52daeb411ca8749d80157d"; }];
    buildInputs = [ perl perl-Alien-Libxml2 perl-XML-SAX perl-XML-NamespaceSupport ];
  };

  "perl-XML-NamespaceSupport" = fetch {
    pname       = "perl-XML-NamespaceSupport";
    version     = "1.12";
    sources     = [{ filename = "perl-XML-NamespaceSupport-1.12-1-any.pkg.tar.xz"; sha256 = "8134097cbdcc291218536671977a58a1a39be0ad6b941840574b3fc2db4816a1"; }];
    buildInputs = [ perl ];
  };

  "perl-XML-Parser" = fetch {
    pname       = "perl-XML-Parser";
    version     = "2.46";
    sources     = [{ filename = "perl-XML-Parser-2.46-3-x86_64.pkg.tar.zst"; sha256 = "bb83c80f6801f127d625c6895e0c610848ebc834c6b2002899badd3ecd5052a8"; }];
    buildInputs = [ perl libexpat libcrypt ];
  };

  "perl-XML-SAX" = fetch {
    pname       = "perl-XML-SAX";
    version     = "1.02";
    sources     = [{ filename = "perl-XML-SAX-1.02-1-any.pkg.tar.xz"; sha256 = "5dc1abaa43918dc0de4a66d88ca2ef1230c826235fd3d0f2de5d6103572df0db"; }];
    buildInputs = [ perl perl-XML-SAX-Base perl-XML-NamespaceSupport ];
  };

  "perl-XML-SAX-Base" = fetch {
    pname       = "perl-XML-SAX-Base";
    version     = "1.09";
    sources     = [{ filename = "perl-XML-SAX-Base-1.09-1-any.pkg.tar.xz"; sha256 = "644d2e4427064daf327bb1256b83e88fcd3abc22d16772d10c02b17d14bdff94"; }];
    buildInputs = [ perl ];
  };

  "perl-XML-Simple" = fetch {
    pname       = "perl-XML-Simple";
    version     = "2.25";
    sources     = [{ filename = "perl-XML-Simple-2.25-1-any.pkg.tar.xz"; sha256 = "108ee1a340ff5fdbc5b1c6e864edf766235552ace49829893a17169085579305"; }];
    buildInputs = [ perl-XML-Parser perl ];
  };

  "perl-YAML" = fetch {
    pname       = "perl-YAML";
    version     = "1.30";
    sources     = [{ filename = "perl-YAML-1.30-1-any.pkg.tar.xz"; sha256 = "62fd90aab360b0992380f70f52e7c0527ef9ea2239f19e5689ab5d74e413a899"; }];
    buildInputs = [ perl ];
  };

  "perl-YAML-Syck" = fetch {
    pname       = "perl-YAML-Syck";
    version     = "1.32";
    sources     = [{ filename = "perl-YAML-Syck-1.32-4-x86_64.pkg.tar.zst"; sha256 = "39a79fec3bf6311bf872876cebc482e0027d3d808f8a5a0b8ce3a0db3495d3a6"; }];
    buildInputs = [ perl ];
  };

  "perl-YAML-Tiny" = fetch {
    pname       = "perl-YAML-Tiny";
    version     = "1.73";
    sources     = [{ filename = "perl-YAML-Tiny-1.73-1-any.pkg.tar.xz"; sha256 = "c38a995d3bdbb89c285537a6916c21c4833815a4f744fba6b684c523c29757d7"; }];
    buildInputs = [ perl ];
  };

  "perl-ack" = fetch {
    pname       = "perl-ack";
    version     = "3.4.0";
    sources     = [{ filename = "perl-ack-3.4.0-1-any.pkg.tar.zst"; sha256 = "b2a054c9e2368abcba5c1d8a7bb5be046545e8f267ac3241c03989edb465096c"; }];
    buildInputs = [ perl-File-Next ];
  };

  "perl-common-sense" = fetch {
    pname       = "perl-common-sense";
    version     = "3.75";
    sources     = [{ filename = "perl-common-sense-3.75-1-any.pkg.tar.xz"; sha256 = "6c3ec479c214853cfe8daf5228fb3ddb29615bf5fbdf4a2b071a6db9a3ca0b62"; }];
    buildInputs = [ perl ];
  };

  "perl-devel" = fetch {
    pname       = "perl-devel";
    version     = "5.32.0";
    sources     = [{ filename = "perl-devel-5.32.0-2-x86_64.pkg.tar.zst"; sha256 = "4b287ec64a71a9c1f3bb116ebbd2475813060c82cde867dd3205ca7365283029"; }];
    buildInputs = [ (assert perl.version=="5.32.0"; perl) libcrypt-devel ];
  };

  "perl-inc-latest" = fetch {
    pname       = "perl-inc-latest";
    version     = "0.500";
    sources     = [{ filename = "perl-inc-latest-0.500-1-any.pkg.tar.xz"; sha256 = "2be50e019e7658de5110613701aa853661b4b454ee4e6916268abc079c418974"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.8.8"; perl) ];
  };

  "perl-libwww" = fetch {
    pname       = "perl-libwww";
    version     = "6.46";
    sources     = [{ filename = "perl-libwww-6.46-1-any.pkg.tar.zst"; sha256 = "f68f1e4ea2869ccddb2cb3b18137b7cdabc2ec4af0937cb287105ef8d292d3d2"; }];
    buildInputs = [ perl perl-Encode-Locale perl-File-Listing perl-HTML-Parser perl-HTTP-Cookies perl-HTTP-Daemon perl-HTTP-Date perl-HTTP-Negotiate perl-LWP-MediaTypes perl-Net-HTTP perl-URI perl-WWW-RobotRules perl-HTTP-Message perl-Try-Tiny ];
  };

  "perl-sgmls" = fetch {
    pname       = "perl-sgmls";
    version     = "1.03ii";
    sources     = [{ filename = "perl-sgmls-1.03ii-1-any.pkg.tar.xz"; sha256 = "2ad1865419b86ca43fc7cf2e4f7151e33c0826891965538b06b26605dcc285f4"; }];
    buildInputs = [ perl ];
  };

  "pinentry" = fetch {
    pname       = "pinentry";
    version     = "1.1.0";
    sources     = [{ filename = "pinentry-1.1.0-2-x86_64.pkg.tar.xz"; sha256 = "3509a73aa5a93994b3714dc4003a628c9a2ab0eb4bde3e4c93c2fc741b5adac3"; }];
    buildInputs = [ ncurses libassuan libgpg-error ];
  };

  "pkg-config" = fetch {
    pname       = "pkg-config";
    version     = "0.29.2";
    sources     = [{ filename = "pkg-config-0.29.2-3-x86_64.pkg.tar.zst"; sha256 = "50554dd8625823b11b4dae29549e3c34dff19b98a77a1a7e09ee7e0f0666effa"; }];
    buildInputs = [ libiconv ];
  };

  "pkgconf" = fetch {
    pname       = "pkgconf";
    version     = "1.7.3";
    sources     = [{ filename = "pkgconf-1.7.3-1-x86_64.pkg.tar.zst"; sha256 = "e3be739fc8d6b07fa763f4b1aea20a621cebc6dfe43f680256bc9f0499d07201"; }];
  };

  "pkgfile" = fetch {
    pname       = "pkgfile";
    version     = "21";
    sources     = [{ filename = "pkgfile-21-1-x86_64.pkg.tar.xz"; sha256 = "1c1577a36aacaffbe7263af9ae4c67893b2aa1af153469987de9b870456f8259"; }];
    buildInputs = [ libarchive curl pcre pacman ];
  };

  "po4a" = fetch {
    pname       = "po4a";
    version     = "0.61";
    sources     = [{ filename = "po4a-0.61-2-any.pkg.tar.zst"; sha256 = "eb5b4218924373cf00b93f9a6340c2d9268f02711e05234215b792975819ec14"; }];
    buildInputs = [ perl gettext perl-YAML-Tiny perl-Text-WrapI18N perl-Locale-Gettext perl-TermReadKey perl-sgmls perl-Unicode-GCString perl-Pod-Parser ];
  };

  "procps" = fetch {
    pname       = "procps";
    version     = "3.2.8";
    sources     = [{ filename = "procps-3.2.8-2-x86_64.pkg.tar.xz"; sha256 = "c7e84b2b253e1892499fcb80caed2ffefc58a2bf091831e702a6a21e27081527"; }];
    buildInputs = [ msys2-runtime ];
  };

  "procps-ng" = fetch {
    pname       = "procps-ng";
    version     = "3.3.16";
    sources     = [{ filename = "procps-ng-3.3.16-1-x86_64.pkg.tar.zst"; sha256 = "4d3ffef876c1f037f724843caf3430687a93f8f66bc68aec9d66fe7fe9b6f628"; }];
    buildInputs = [ msys2-runtime ncurses ];
  };

  "protobuf" = fetch {
    pname       = "protobuf";
    version     = "3.12.3";
    sources     = [{ filename = "protobuf-3.12.3-1-x86_64.pkg.tar.zst"; sha256 = "2918679b75fbdb95e01f6e4367c5a118c85dfb97a61e833dafb6504df7f8e96c"; }];
    buildInputs = [ gcc-libs zlib ];
  };

  "protobuf-devel" = fetch {
    pname       = "protobuf-devel";
    version     = "3.12.3";
    sources     = [{ filename = "protobuf-devel-3.12.3-1-x86_64.pkg.tar.zst"; sha256 = "accc35c821ef85522294c6272411b15b0131c9914acfac75b4ef40be0cbb737b"; }];
    buildInputs = [ (assert protobuf.version=="3.12.3"; protobuf) ];
  };

  "psmisc" = fetch {
    pname       = "psmisc";
    version     = "23.3";
    sources     = [{ filename = "psmisc-23.3-1-x86_64.pkg.tar.xz"; sha256 = "d75c96453cc44889c6de3cf87d75a4baa88f125c233a7d4e0416c99ab56715ed"; }];
    buildInputs = [ msys2-runtime gcc-libs ncurses libiconv libintl ];
  };

  "publicsuffix-list" = fetch {
    pname       = "publicsuffix-list";
    version     = "20200530.936.a3268fa";
    sources     = [{ filename = "publicsuffix-list-20200530.936.a3268fa-1-any.pkg.tar.zst"; sha256 = "72e4f9994dfdafb11c45ecf9a6ebd2d5f8ef227d65fc11ed7c090a3dcae1d2ae"; }];
  };

  "pv" = fetch {
    pname       = "pv";
    version     = "1.6.6";
    sources     = [{ filename = "pv-1.6.6-1-x86_64.pkg.tar.xz"; sha256 = "95a1a8e85b1dfcde4ac1d77e4d776c5a22d9f93fbcdd17b19d0eb1871139580c"; }];
  };

  "pwgen" = fetch {
    pname       = "pwgen";
    version     = "2.08";
    sources     = [{ filename = "pwgen-2.08-1-x86_64.pkg.tar.xz"; sha256 = "6901888c9c02eec8f741485a7ee9fdfe367bbb6d704a66c4fc31fe99d574df29"; }];
    buildInputs = [ msys2-runtime ];
  };

  "python" = fetch {
    pname       = "python";
    version     = "3.8.5";
    sources     = [{ filename = "python-3.8.5-6-x86_64.pkg.tar.zst"; sha256 = "d557e1896da25e07040e636056bcf600d6e9439db054862d1d15c90280f4b567"; }];
    buildInputs = [ libbz2 libexpat libffi liblzma ncurses libopenssl libreadline mpdecimal libsqlite zlib ];
  };

  "python-appdirs" = fetch {
    pname       = "python-appdirs";
    version     = "1.4.4";
    sources     = [{ filename = "python-appdirs-1.4.4-1-any.pkg.tar.zst"; sha256 = "c176352a30c7f545a58a32539fcceb368ba32fde29152e9f7a2fd195f3b9e726"; }];
    buildInputs = [ python ];
  };

  "python-atomicwrites" = fetch {
    pname       = "python-atomicwrites";
    version     = "1.4.0";
    sources     = [{ filename = "python-atomicwrites-1.4.0-1-any.pkg.tar.zst"; sha256 = "00fe86bd7e1bd480151fbfd93aa1b6c94ba21cf74c9ac16d33698214259725d3"; }];
    buildInputs = [ python ];
  };

  "python-attrs" = fetch {
    pname       = "python-attrs";
    version     = "19.3.0";
    sources     = [{ filename = "python-attrs-19.3.0-3-any.pkg.tar.xz"; sha256 = "cf36867c06888726f589fe54c4aec318a9d6e15fb08ba0121e422882c839b034"; }];
    buildInputs = [ python ];
  };

  "python-beaker" = fetch {
    pname       = "python-beaker";
    version     = "1.11.0";
    sources     = [{ filename = "python-beaker-1.11.0-4-x86_64.pkg.tar.xz"; sha256 = "3fa90ebdb517a112fd6c9a98cd81c1fe2685f7f978439f6b566c38e0b0c6ebe8"; }];
    buildInputs = [ python python-setuptools ];
  };

  "python-brotli" = fetch {
    pname       = "python-brotli";
    version     = "1.0.7";
    sources     = [{ filename = "python-brotli-1.0.7-4-x86_64.pkg.tar.zst"; sha256 = "2cb62cff982570072425fef915a3b94a3a6dbe88188b4097a3b21bc717c3eb92"; }];
    buildInputs = [ python ];
  };

  "python-colorama" = fetch {
    pname       = "python-colorama";
    version     = "0.4.3";
    sources     = [{ filename = "python-colorama-0.4.3-2-any.pkg.tar.xz"; sha256 = "0c8009b17b5bbfb2e5a17e592277557ac73b09ecf1b1a077264c404c10d108a0"; }];
    buildInputs = [ python ];
  };

  "python-configobj" = fetch {
    pname       = "python-configobj";
    version     = "5.0.6";
    sources     = [{ filename = "python-configobj-5.0.6-2-any.pkg.tar.xz"; sha256 = "a074b04f7c9a5424f414901d7f6f3b0a86ea8a896049af3283af05d3f1a727e8"; }];
    buildInputs = [ python ];
  };

  "python-devel" = fetch {
    pname       = "python-devel";
    version     = "3.8.5";
    sources     = [{ filename = "python-devel-3.8.5-6-x86_64.pkg.tar.zst"; sha256 = "02ca68f55e5509e94d811ac6af618da277263f3fe3f7721b61b494974f6bdd61"; }];
    buildInputs = [ (assert python.version=="3.8.5"; python) libcrypt-devel ];
  };

  "python-dulwich" = fetch {
    pname       = "python-dulwich";
    version     = "0.20.5";
    sources     = [{ filename = "python-dulwich-0.20.5-2-x86_64.pkg.tar.zst"; sha256 = "c533f993fec8e962613109b35ef90462abf1330a0fae60ee71539419873b7c70"; }];
    buildInputs = [ python ];
  };

  "python-fastimport" = fetch {
    pname       = "python-fastimport";
    version     = "0.9.8";
    sources     = [{ filename = "python-fastimport-0.9.8-2-any.pkg.tar.xz"; sha256 = "d177c595201fb8a39c87f6b813fdfecae66d333254d1db075cdca9969ffa1fe7"; }];
    buildInputs = [ python ];
  };

  "python-jinja" = fetch {
    pname       = "python-jinja";
    version     = "2.11.2";
    sources     = [{ filename = "python-jinja-2.11.2-1-x86_64.pkg.tar.zst"; sha256 = "1904deda0ce732677f4c92ef29f461dc3f9237562d94a751771d5820c40c8cc6"; }];
    buildInputs = [ python-setuptools python-markupsafe ];
  };

  "python-mako" = fetch {
    pname       = "python-mako";
    version     = "1.1.3";
    sources     = [{ filename = "python-mako-1.1.3-1-x86_64.pkg.tar.zst"; sha256 = "a5f17726cbac586171d1d5f10f31c67342e26ffbfee90bf1145aaffdacdf8804"; }];
    buildInputs = [ python-markupsafe python-beaker ];
  };

  "python-markupsafe" = fetch {
    pname       = "python-markupsafe";
    version     = "1.1.1";
    sources     = [{ filename = "python-markupsafe-1.1.1-3-x86_64.pkg.tar.xz"; sha256 = "f049ce74e851511f66a59a7f8579fdd9bf65f9570a2ebd585665b3b6e12c9a24"; }];
    buildInputs = [ python ];
  };

  "python-mock" = fetch {
    pname       = "python-mock";
    version     = "4.0.2";
    sources     = [{ filename = "python-mock-4.0.2-1-any.pkg.tar.xz"; sha256 = "fc5aaf2a28402a0c1642a9d48c32a53e8d2c2c22c3239e4fa673a8f7c0bbac9d"; }];
    buildInputs = [ python ];
  };

  "python-more-itertools" = fetch {
    pname       = "python-more-itertools";
    version     = "8.4.0";
    sources     = [{ filename = "python-more-itertools-8.4.0-1-any.pkg.tar.zst"; sha256 = "819fabf6e9e089bf3080b17d95e07f2be9cf6b5baa34bacf88d7c54711951444"; }];
    buildInputs = [ python ];
  };

  "python-nose" = fetch {
    pname       = "python-nose";
    version     = "1.3.7";
    sources     = [{ filename = "python-nose-1.3.7-7-x86_64.pkg.tar.xz"; sha256 = "749cc040c54c7686bfb4195b2636a7f382a89c9af4fd792f31d3cdde439d2b59"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-packaging" = fetch {
    pname       = "python-packaging";
    version     = "20.4";
    sources     = [{ filename = "python-packaging-20.4-1-any.pkg.tar.zst"; sha256 = "572b2fd9eae3084df18fb9455a3f0a5745202920830e6da74e71a1d11f221128"; }];
    buildInputs = [ python-attrs python-pyparsing python-six ];
  };

  "python-patiencediff" = fetch {
    pname       = "python-patiencediff";
    version     = "0.2.0";
    sources     = [{ filename = "python-patiencediff-0.2.0-3-x86_64.pkg.tar.zst"; sha256 = "03b412f52900b248693a5e672ab6262651cb0ce3991a8da209d9e0817054252c"; }];
    buildInputs = [ python ];
  };

  "python-pbr" = fetch {
    pname       = "python-pbr";
    version     = "5.4.5";
    sources     = [{ filename = "python-pbr-5.4.5-1-any.pkg.tar.xz"; sha256 = "233e648fe5ab24504b0b0b41376e80da58035e6ea169638a3140e7288c95313e"; }];
    buildInputs = [ python-setuptools ];
  };

  "python-pip" = fetch {
    pname       = "python-pip";
    version     = "20.1.1";
    sources     = [{ filename = "python-pip-20.1.1-1-any.pkg.tar.zst"; sha256 = "abe75d219e0310f043db0fd13918a821bab3aab30199ab218917d618f4dc4d0a"; }];
    buildInputs = [ python python3-setuptools ];
    broken      = true; # broken dependency python-pip -> python3-setuptools
  };

  "python-pluggy" = fetch {
    pname       = "python-pluggy";
    version     = "0.13.1";
    sources     = [{ filename = "python-pluggy-0.13.1-2-any.pkg.tar.xz"; sha256 = "cd8a632fa873c79b4d3d08abee4903ca03347cfef1105b34916bdf8872dbcb73"; }];
    buildInputs = [ python ];
  };

  "python-py" = fetch {
    pname       = "python-py";
    version     = "1.9.0";
    sources     = [{ filename = "python-py-1.9.0-1-any.pkg.tar.zst"; sha256 = "c75c01466493c22905cded294ddb507e54b2b9c6c558642c11420af3c4fad198"; }];
    buildInputs = [ python ];
  };

  "python-py3c" = fetch {
    pname       = "python-py3c";
    version     = "1.2";
    sources     = [{ filename = "python-py3c-1.2-1-x86_64.pkg.tar.zst"; sha256 = "cf1a17c5c6806c5d381d4140a2ac9efdef33f3a51b65b201aacedc21e3ba7fd5"; }];
    buildInputs = [ python ];
  };

  "python-pyalpm" = fetch {
    pname       = "python-pyalpm";
    version     = "0.9.1";
    sources     = [{ filename = "python-pyalpm-0.9.1-2-x86_64.pkg.tar.xz"; sha256 = "029da49a04d032c091495ba1867000df1cd9b20cf81d7dac0ace8aa88171ca08"; }];
    buildInputs = [ python libarchive-devel ];
  };

  "python-pygments" = fetch {
    pname       = "python-pygments";
    version     = "2.6.1";
    sources     = [{ filename = "python-pygments-2.6.1-2-x86_64.pkg.tar.xz"; sha256 = "8b9bb1f5a021b599fa9063d7cf7de71e605d6c1967e1cbf6ffe58addbf44d956"; }];
    buildInputs = [ python ];
  };

  "python-pyparsing" = fetch {
    pname       = "python-pyparsing";
    version     = "2.4.7";
    sources     = [{ filename = "python-pyparsing-2.4.7-1-any.pkg.tar.xz"; sha256 = "a27f5db947eb221d40886d19baa70b4db86eaee9481a8612b66e27b15a7dab8f"; }];
    buildInputs = [ python ];
  };

  "python-pytest" = fetch {
    pname       = "python-pytest";
    version     = "5.4.3";
    sources     = [{ filename = "python-pytest-5.4.3-1-any.pkg.tar.zst"; sha256 = "53a7ca88aaa3cb8702d7c7546d34d4920aa4ff549907dc9cab2f387cf9f67827"; }];
    buildInputs = [ python python-atomicwrites python-attrs python-more-itertools python-pluggy python-py python-setuptools python-six ];
  };

  "python-pytest-runner" = fetch {
    pname       = "python-pytest-runner";
    version     = "5.2";
    sources     = [{ filename = "python-pytest-runner-5.2-2-any.pkg.tar.xz"; sha256 = "b4ec3f52a723f3aa64ca6168bc8ecbf1cae7d294a4f79e8aec5b20011f8b02ca"; }];
    buildInputs = [ python-pytest ];
  };

  "python-setuptools" = fetch {
    pname       = "python-setuptools";
    version     = "47.1.1";
    sources     = [{ filename = "python-setuptools-47.1.1-1-any.pkg.tar.zst"; sha256 = "d07b138307e2198987b149ce719612d287cc668d398b1d6b3f85455514871e70"; }];
    buildInputs = [ python ];
  };

  "python-setuptools-scm" = fetch {
    pname       = "python-setuptools-scm";
    version     = "4.1.2";
    sources     = [{ filename = "python-setuptools-scm-4.1.2-1-any.pkg.tar.zst"; sha256 = "ca95a0e963857399d8a4d75a1fc5df27f369e7b9f141191f6c6f8f6284dc3e5a"; }];
    buildInputs = [ python ];
  };

  "python-six" = fetch {
    pname       = "python-six";
    version     = "1.15.0";
    sources     = [{ filename = "python-six-1.15.0-2-any.pkg.tar.zst"; sha256 = "86747435ba45e240615ef344df3da0258c8116ca3d8a06427b06162a4e1ba0eb"; }];
    buildInputs = [ python ];
  };

  "python-wcwidth" = fetch {
    pname       = "python-wcwidth";
    version     = "0.2.5";
    sources     = [{ filename = "python-wcwidth-0.2.5-1-x86_64.pkg.tar.zst"; sha256 = "e54302f352afc6fd1ca6f69f66bc3b783410563a08967f395a1ccdeb8f6714c4"; }];
    buildInputs = [ python ];
  };

  "python-yaml" = fetch {
    pname       = "python-yaml";
    version     = "5.3.1";
    sources     = [{ filename = "python-yaml-5.3.1-2-x86_64.pkg.tar.zst"; sha256 = "0399438f8184f561e6b5c5d51b1fdbe60d2ef64bd0d2e93b26e5b00a9872488e"; }];
    buildInputs = [ python libyaml ];
  };

  "quilt" = fetch {
    pname       = "quilt";
    version     = "0.66";
    sources     = [{ filename = "quilt-0.66-2-any.pkg.tar.xz"; sha256 = "3c1f2b181a4dbef5206567d4ae4cb86c82a94fe15bcc61fe6f41040f3c25f837"; }];
    buildInputs = [ bash bzip2 diffstat diffutils findutils gawk gettext gzip patch perl ];
  };

  "rarian" = fetch {
    pname       = "rarian";
    version     = "0.8.1";
    sources     = [{ filename = "rarian-0.8.1-2-x86_64.pkg.tar.xz"; sha256 = "eb4cc60194ba1053df24f1a55e01aa932bc15d6ef0ba7ca0a4a53e84c832bbb2"; }];
    buildInputs = [ gcc-libs ];
  };

  "rcs" = fetch {
    pname       = "rcs";
    version     = "5.9.4";
    sources     = [{ filename = "rcs-5.9.4-2-x86_64.pkg.tar.xz"; sha256 = "37685f2a7a21e27ddd4231b5b71074b972843c4ef5d304fd8e71fe1d036de824"; }];
  };

  "re2c" = fetch {
    pname       = "re2c";
    version     = "2.0.3";
    sources     = [{ filename = "re2c-2.0.3-1-x86_64.pkg.tar.zst"; sha256 = "a2599cbd4d215c9663e5e2cf0c68bc23e7e474f20a1cab6c19c1b378f568ca1b"; }];
    buildInputs = [ gcc-libs ];
  };

  "rebase" = fetch {
    pname       = "rebase";
    version     = "4.4.4";
    sources     = [{ filename = "rebase-4.4.4-2-x86_64.pkg.tar.zst"; sha256 = "bde1e47774f75a43897ed9f9bd336d96b74f34831fceba129ba514f9e2f5e374"; }];
    buildInputs = [ dash ];
  };

  "reflex" = fetch {
    pname       = "reflex";
    version     = "20200715";
    sources     = [{ filename = "reflex-20200715-1-x86_64.pkg.tar.zst"; sha256 = "c6137e87b53179beed23fa6edca29270459a2cadbb4ec09ddcfff560cf209bd3"; }];
  };

  "remake-git" = fetch {
    pname       = "remake-git";
    version     = "4.1.2957.e3e34dd9";
    sources     = [{ filename = "remake-git-4.1.2957.e3e34dd9-1-x86_64.pkg.tar.xz"; sha256 = "1a67934ede349424ce48ce3b5c74c8a69f8655df3f15161e8ba4c8c77518b9da"; }];
    buildInputs = [ guile libreadline ];
  };

  "rhash" = fetch {
    pname       = "rhash";
    version     = "1.3.9";
    sources     = [{ filename = "rhash-1.3.9-1-x86_64.pkg.tar.xz"; sha256 = "3bc16f7f4ab391846a465d5f61ba30e1d954903c6e7387dc8d8868bd17f867fb"; }];
    buildInputs = [ (assert librhash.version=="1.3.9"; librhash) ];
  };

  "rlwrap" = fetch {
    pname       = "rlwrap";
    version     = "0.43";
    sources     = [{ filename = "rlwrap-0.43-0-x86_64.pkg.tar.xz"; sha256 = "a6d129a97e4882d3f642af96b68bc64c4a1726451db11ba5393b5120880e46ec"; }];
    buildInputs = [ libreadline ];
  };

  "rsync" = fetch {
    pname       = "rsync";
    version     = "3.2.2";
    sources     = [{ filename = "rsync-3.2.2-2-x86_64.pkg.tar.zst"; sha256 = "ef1565e7b4a8b2ca05a1541a5256a6e651e53f4a8c8a3d858cddf2a5ed695096"; }];
    buildInputs = [ perl libiconv liblz4 libopenssl libxxhash libzstd ];
  };

  "ruby" = fetch {
    pname       = "ruby";
    version     = "2.7.1";
    sources     = [{ filename = "ruby-2.7.1-1-x86_64.pkg.tar.xz"; sha256 = "9cd378facbbc4f32eaf400090c41739c8de4def5740a3d3c23229ac6abecc7ee"; }];
    buildInputs = [ gcc-libs libopenssl libffi libcrypt gmp libyaml libgdbm libiconv libreadline zlib ];
  };

  "ruby-docs" = fetch {
    pname       = "ruby-docs";
    version     = "2.7.1";
    sources     = [{ filename = "ruby-docs-2.7.1-1-x86_64.pkg.tar.xz"; sha256 = "8b095b86c5d9384ddad43cf077eb9178353ed5725d6ed3e8aba0ec245903c5c2"; }];
  };

  "scons" = fetch {
    pname       = "scons";
    version     = "3.1.2";
    sources     = [{ filename = "scons-3.1.2-4-any.pkg.tar.xz"; sha256 = "15cbf66c1640d79c797bd7e6548a9d5a246cc151e829c6082091632163b72ee9"; }];
    buildInputs = [ python ];
  };

  "screenfetch" = fetch {
    pname       = "screenfetch";
    version     = "3.9.1";
    sources     = [{ filename = "screenfetch-3.9.1-1-any.pkg.tar.xz"; sha256 = "b353be723f3498d4a4933dc313d41df4e37c5337097134cd42082afdab6e41e9"; }];
    buildInputs = [ bash ];
  };

  "sed" = fetch {
    pname       = "sed";
    version     = "4.8";
    sources     = [{ filename = "sed-4.8-1-x86_64.pkg.tar.xz"; sha256 = "3bb6474a3bdac99cda7491c8ea82cba0d54d4ca4d4d729a88bf7ec204988937d"; }];
    buildInputs = [ libintl sh ];
  };

  "setconf" = fetch {
    pname       = "setconf";
    version     = "0.7.7";
    sources     = [{ filename = "setconf-0.7.7-1-any.pkg.tar.zst"; sha256 = "c2bf0b0dcec5cee3242aeea8e08c5fb9465553f5a127a28f428e56beb7e54c1f"; }];
    buildInputs = [ python3 ];
  };

  "sgml-common" = fetch {
    pname       = "sgml-common";
    version     = "0.6.3";
    sources     = [{ filename = "sgml-common-0.6.3-1-any.pkg.tar.xz"; sha256 = "8468f420528ee8cfa54c60cbe844751bfc9a1c783fc9e7e3b99bdb48c4d319a6"; }];
    buildInputs = [ sh ];
  };

  "sharutils" = fetch {
    pname       = "sharutils";
    version     = "4.15.2";
    sources     = [{ filename = "sharutils-4.15.2-1-x86_64.pkg.tar.xz"; sha256 = "6907cb625fe7b200cf03672bf02d15c28d7945a28deb278ac9fe79a530774a6b"; }];
    buildInputs = [ perl gettext texinfo ];
  };

  "socat" = fetch {
    pname       = "socat";
    version     = "1.7.3.4";
    sources     = [{ filename = "socat-1.7.3.4-1-x86_64.pkg.tar.xz"; sha256 = "c50f7e43a921a5ecd0c3ebbb83a15d47631a18146626d56925252c5883437ab8"; }];
    buildInputs = [ libreadline openssl ];
  };

  "sqlite" = fetch {
    pname       = "sqlite";
    version     = "3.33.0";
    sources     = [{ filename = "sqlite-3.33.0-2-x86_64.pkg.tar.zst"; sha256 = "c5198d065ae7eb52c80704aeade1d4bf80a43bf6c43ce8cbc1248e65c88f4bbe"; }];
    buildInputs = [ libreadline zlib tcl ];
  };

  "sqlite-doc" = fetch {
    pname       = "sqlite-doc";
    version     = "3.33.0";
    sources     = [{ filename = "sqlite-doc-3.33.0-2-x86_64.pkg.tar.zst"; sha256 = "9ea5f44306e8dfb607aae5dcf6ff511aa43a7a3e5488bf5b6d9a3b5500016abf"; }];
    buildInputs = [ libreadline zlib tcl ];
  };

  "sqlite-extensions" = fetch {
    pname       = "sqlite-extensions";
    version     = "3.33.0";
    sources     = [{ filename = "sqlite-extensions-3.33.0-2-x86_64.pkg.tar.zst"; sha256 = "430be044cf28797230c88733b473fcfb8bae4a2c57cc558da07754f8dbf75c40"; }];
    buildInputs = [ (assert sqlite.version=="3.33.0"; sqlite) (assert libsqlite.version=="3.33.0"; libsqlite) ];
  };

  "ssh-pageant-git" = fetch {
    pname       = "ssh-pageant-git";
    version     = "1.4.12.g6f47092";
    sources     = [{ filename = "ssh-pageant-git-1.4.12.g6f47092-1-x86_64.pkg.tar.xz"; sha256 = "90b57a383384a69b59251f7be8c5d002f5197c7413ef67d02f5a2a3b482a00cf"; }];
  };

  "sshpass" = fetch {
    pname       = "sshpass";
    version     = "1.06";
    sources     = [{ filename = "sshpass-1.06-1-x86_64.pkg.tar.xz"; sha256 = "f7cf610af7d1f47d44a77f7ba9b2d7a4f44b7bb261889a576da4531c5a3b2076"; }];
    buildInputs = [ openssh ];
  };

  "subversion" = fetch {
    pname       = "subversion";
    version     = "1.14.0";
    sources     = [{ filename = "subversion-1.14.0-2-x86_64.pkg.tar.zst"; sha256 = "0ce09ce22ceb89365f44664f76beb073fde9fee7d68d28468b7f6f9b1b107c3a"; }];
    buildInputs = [ libsqlite file liblz4 libserf libsasl ];
    broken      = true; # broken dependency apr -> libuuid
  };

  "swig" = fetch {
    pname       = "swig";
    version     = "4.0.2";
    sources     = [{ filename = "swig-4.0.2-1-x86_64.pkg.tar.zst"; sha256 = "ffc5b41a7b1ab2faf9f9b5810fc69d2f24b545b56878e271b9312965b9d58360"; }];
    buildInputs = [ zlib libpcre ];
  };

  "tar" = fetch {
    pname       = "tar";
    version     = "1.32";
    sources     = [{ filename = "tar-1.32-1-x86_64.pkg.tar.xz"; sha256 = "45b958f65cf5e61f93d632cfbfb58914c7c3b8c005dcd63aebb1b2f53916df7a"; }];
    buildInputs = [ msys2-runtime libiconv libintl sh ];
  };

  "task" = fetch {
    pname       = "task";
    version     = "2.5.1";
    sources     = [{ filename = "task-2.5.1-3-x86_64.pkg.tar.xz"; sha256 = "b8bd4785323f6a6c672a0dbab26f1206223a4a041076aa803ec2c73820afc218"; }];
    buildInputs = [ gcc-libs libgnutls libutil-linux libhogweed ];
  };

  "tcl" = fetch {
    pname       = "tcl";
    version     = "8.6.10";
    sources     = [{ filename = "tcl-8.6.10-1-x86_64.pkg.tar.xz"; sha256 = "28b3c8e528c6b6c935dbd8f008fd3858ea0e89609f3f5a383fee04aae2e0a918"; }];
    buildInputs = [ zlib ];
  };

  "tcl-sqlite" = fetch {
    pname       = "tcl-sqlite";
    version     = "3.33.0";
    sources     = [{ filename = "tcl-sqlite-3.33.0-2-x86_64.pkg.tar.zst"; sha256 = "127724d10aebe6189beb1f2fa2f8a7ad1da5b48f70409a1e10f1508543e9fe68"; }];
    buildInputs = [ (assert libsqlite.version=="3.33.0"; libsqlite) tcl ];
  };

  "tcsh" = fetch {
    pname       = "tcsh";
    version     = "6.22.02";
    sources     = [{ filename = "tcsh-6.22.02-1-x86_64.pkg.tar.xz"; sha256 = "6375135f94c45fe6607113573ffd5cba5a89ef0e17f8affbcb2323021a14ecc1"; }];
    buildInputs = [ gcc-libs libcrypt libiconv ncurses ];
  };

  "termbox" = fetch {
    pname       = "termbox";
    version     = "1.1.0";
    sources     = [{ filename = "termbox-1.1.0-2-x86_64.pkg.tar.xz"; sha256 = "0ddaa0821f85d335b1b755bc866c7377f77ec43f99e50b2006b314a737327bf1"; }];
  };

  "texinfo" = fetch {
    pname       = "texinfo";
    version     = "6.7";
    sources     = [{ filename = "texinfo-6.7-3-x86_64.pkg.tar.zst"; sha256 = "c68e0bcb56a871323d250b50f2a4f5e3608f1b2885ed8a3db3df732822ab9375"; }];
    buildInputs = [ info perl sh ];
  };

  "texinfo-tex" = fetch {
    pname       = "texinfo-tex";
    version     = "6.7";
    sources     = [{ filename = "texinfo-tex-6.7-3-x86_64.pkg.tar.zst"; sha256 = "76fca8cf3c7435992f3a11490a74e5e8d3388d35c4d2485c21011188efc2d66c"; }];
    buildInputs = [ gawk perl sh ];
  };

  "tftp-hpa" = fetch {
    pname       = "tftp-hpa";
    version     = "5.2";
    sources     = [{ filename = "tftp-hpa-5.2-3-x86_64.pkg.tar.xz"; sha256 = "9c26adb46111e5a41056ac0df71de848ea2d6186d1e6db907dc1f688e4c22089"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast libreadline.version "6.0.00"; libreadline) ];
  };

  "tig" = fetch {
    pname       = "tig";
    version     = "2.5.1";
    sources     = [{ filename = "tig-2.5.1-1-x86_64.pkg.tar.xz"; sha256 = "1b535b4e40c4458dd9ada221b97afea0d024846f82cc88e4de83cc8089aff704"; }];
    buildInputs = [ git libreadline ncurses ];
    broken      = true; # broken dependency perl-MIME-tools -> perl-IO-stringy
  };

  "time" = fetch {
    pname       = "time";
    version     = "1.9";
    sources     = [{ filename = "time-1.9-1-x86_64.pkg.tar.xz"; sha256 = "68ac171e391e3e31c430f7f58b4e812ef1e89b82d548eacbaf3a6205693d7d9c"; }];
    buildInputs = [ msys2-runtime ];
  };

  "tio" = fetch {
    pname       = "tio";
    version     = "1.32";
    sources     = [{ filename = "tio-1.32-1-x86_64.pkg.tar.xz"; sha256 = "e28e790f3c2c83abb303f7c522067250fa27bca474efa6aedeb41739e4a4035c"; }];
  };

  "tmux" = fetch {
    pname       = "tmux";
    version     = "3.1.b";
    sources     = [{ filename = "tmux-3.1.b-1-x86_64.pkg.tar.zst"; sha256 = "5d31626a3597b29a61b1ad49ba980acbbef9d09c511a29b32935ab2643264429"; }];
    buildInputs = [ ncurses libevent ];
  };

  "tree" = fetch {
    pname       = "tree";
    version     = "1.8.0";
    sources     = [{ filename = "tree-1.8.0-1-x86_64.pkg.tar.xz"; sha256 = "e998a5e47fa850dc7c69e746ab2e18850aeedf6bad818893a17dedaaa0ba7cca"; }];
    buildInputs = [ msys2-runtime ];
  };

  "ttyrec" = fetch {
    pname       = "ttyrec";
    version     = "1.0.8";
    sources     = [{ filename = "ttyrec-1.0.8-2-x86_64.pkg.tar.xz"; sha256 = "bd39b20cd48b0735dca56a798ffbd89b63acccfd704c597da6231bf3061c6bec"; }];
    buildInputs = [ sh ];
  };

  "txt2html" = fetch {
    pname       = "txt2html";
    version     = "2.5201";
    sources     = [{ filename = "txt2html-2.5201-1-x86_64.pkg.tar.xz"; sha256 = "7abb65139bf5e4895dc27681948efe0dcb7896913508a49f15bfb2a1d78d24b8"; }];
    buildInputs = [ (assert stdenvNoCC.lib.versionAtLeast perl.version "5.10.0"; perl) perl-Getopt-ArgvFile ];
  };

  "txt2tags" = fetch {
    pname       = "txt2tags";
    version     = "3.7";
    sources     = [{ filename = "txt2tags-3.7-1-any.pkg.tar.xz"; sha256 = "16d63d4362f6be085b21619b930bbfd8695126f8ea143512f7c47d0cf362100d"; }];
    buildInputs = [ python ];
  };

  "tzcode" = fetch {
    pname       = "tzcode";
    version     = "2020a";
    sources     = [{ filename = "tzcode-2020a-1-x86_64.pkg.tar.zst"; sha256 = "c6e5afedb5fe89b4554f1ec77171550f42e1f906fe52887ada7732c5d41034b9"; }];
    buildInputs = [ coreutils gawk sed ];
  };

  "u-boot-tools" = fetch {
    pname       = "u-boot-tools";
    version     = "2020.10";
    sources     = [{ filename = "u-boot-tools-2020.10-1-x86_64.pkg.tar.zst"; sha256 = "2aeb35f3edd906d01eeb060e305de998327cbd6a893108c1baeebe4af758af89"; }];
    buildInputs = [ dtc openssl ];
  };

  "ucl" = fetch {
    pname       = "ucl";
    version     = "1.03";
    sources     = [{ filename = "ucl-1.03-2-x86_64.pkg.tar.xz"; sha256 = "7e065f7a271c1eefa3499beee54bbf0e9b4436c0e2610944682c2d7fc9432a57"; }];
  };

  "ucl-devel" = fetch {
    pname       = "ucl-devel";
    version     = "1.03";
    sources     = [{ filename = "ucl-devel-1.03-2-x86_64.pkg.tar.xz"; sha256 = "d21a85acabbc8c299306cad50a97503fde21f898d236b32d9628b416886dbb53"; }];
    buildInputs = [ (assert ucl.version=="1.03"; ucl) ];
  };

  "unrar" = fetch {
    pname       = "unrar";
    version     = "5.9.4";
    sources     = [{ filename = "unrar-5.9.4-1-x86_64.pkg.tar.zst"; sha256 = "f9ce38ef836c11e70a36aa2a6790ab4642a487e327ae4dd5021f6478b8f3a521"; }];
    buildInputs = [ gcc-libs ];
  };

  "unzip" = fetch {
    pname       = "unzip";
    version     = "6.0";
    sources     = [{ filename = "unzip-6.0-2-x86_64.pkg.tar.xz"; sha256 = "8594ccda17711c5fad21ebb0e09ce37452cdf78803ca0b7ffbab1bdae1aa170c"; }];
    buildInputs = [ libbz2 bash ];
  };

  "upx" = fetch {
    pname       = "upx";
    version     = "3.96";
    sources     = [{ filename = "upx-3.96-1-x86_64.pkg.tar.xz"; sha256 = "ab55c8fac80a9bd10162187bfabe3ca6f7f38c19cbf8a013965c83fb86fea672"; }];
    buildInputs = [ ucl zlib ];
  };

  "util-linux" = fetch {
    pname       = "util-linux";
    version     = "2.35.2";
    sources     = [{ filename = "util-linux-2.35.2-1-x86_64.pkg.tar.zst"; sha256 = "06d014b4dfe0502b5657a1a5f17eb41b896eb9905ba8c05f1235468c07b7cc9f"; }];
    buildInputs = [ coreutils libutil-linux libiconv ];
  };

  "util-macros" = fetch {
    pname       = "util-macros";
    version     = "1.19.2";
    sources     = [{ filename = "util-macros-1.19.2-1-any.pkg.tar.xz"; sha256 = "6c94b332d2054a5f44aad72068e7a24ccbcc04f2d761158aec27db8364a13bc9"; }];
  };

  "vifm" = fetch {
    pname       = "vifm";
    version     = "0.10.1";
    sources     = [{ filename = "vifm-0.10.1-1-x86_64.pkg.tar.xz"; sha256 = "1f066e27915d659accc03fdb3ec98f607c13cf784c31a0de91953f0ec501a0ca"; }];
    buildInputs = [ ncurses ];
  };

  "vim" = fetch {
    pname       = "vim";
    version     = "8.2.1522";
    sources     = [{ filename = "vim-8.2.1522-3-x86_64.pkg.tar.zst"; sha256 = "48ef05fe2a06675337677d5a337307d94c3e7dbc1df77221dd2adb1a793e0707"; }];
    buildInputs = [ ncurses ];
  };

  "vimpager" = fetch {
    pname       = "vimpager";
    version     = "2.06";
    sources     = [{ filename = "vimpager-2.06-1-any.pkg.tar.xz"; sha256 = "5e281ed9ae9fef50be51ba657586c13944ac2043ecad7bff6facbe87291dd381"; }];
    buildInputs = [ vim sharutils ];
  };

  "w3m" = fetch {
    pname       = "w3m";
    version     = "0.5.3+20180125";
    sources     = [{ filename = "w3m-0.5.3+20180125-1-x86_64.pkg.tar.xz"; sha256 = "99fae10891dc7460744abfb27e899d560e21c2d7836f598718f7b47353965d4c"; }];
    buildInputs = [ libgc libiconv libintl openssl zlib ncurses ];
  };

  "wcd" = fetch {
    pname       = "wcd";
    version     = "6.0.3";
    sources     = [{ filename = "wcd-6.0.3-1-x86_64.pkg.tar.xz"; sha256 = "d02697b1d4b39e09b78a3fe93d22f86817fffac4003c8f95bbdd761cdb74757f"; }];
    buildInputs = [ libintl libunistring ncurses ];
  };

  "wget" = fetch {
    pname       = "wget";
    version     = "1.20.3";
    sources     = [{ filename = "wget-1.20.3-1-x86_64.pkg.tar.xz"; sha256 = "339e4126a1ed3d409cb4176d87ee22f19ca322dbaaf8a3f57ca1575a43d44f06"; }];
    buildInputs = [ gcc-libs libiconv libidn2 libintl libgpgme libmetalink libpcre2_8 libpsl libuuid openssl zlib ];
    broken      = true; # broken dependency wget -> libuuid
  };

  "which" = fetch {
    pname       = "which";
    version     = "2.21";
    sources     = [{ filename = "which-2.21-2-x86_64.pkg.tar.xz"; sha256 = "5514e35834316cfc80e6547de7e570930d0198a633c8b94f45935b231547296d"; }];
    buildInputs = [ msys2-runtime sh ];
  };

  "whois" = fetch {
    pname       = "whois";
    version     = "5.5.6";
    sources     = [{ filename = "whois-5.5.6-1-x86_64.pkg.tar.xz"; sha256 = "af3f5c199061fffd213a864ea25fadde610b1f3ecc3c5e5deaa9888bc8821c38"; }];
    buildInputs = [ libcrypt libidn2 libiconv ];
  };

  "windows-default-manifest" = fetch {
    pname       = "windows-default-manifest";
    version     = "6.4";
    sources     = [{ filename = "windows-default-manifest-6.4-1-x86_64.pkg.tar.xz"; sha256 = "e6195b19387ddd8ce05c944e0e270920d9bf483ae40670b11d24c934a546ecb2"; }];
    buildInputs = [  ];
  };

  "winln" = fetch {
    pname       = "winln";
    version     = "1.1";
    sources     = [{ filename = "winln-1.1-1-x86_64.pkg.tar.xz"; sha256 = "11d26dc01d232e101fd4759030624e4710e7033335e372f03c4b0a433204439b"; }];
  };

  "winpty" = fetch {
    pname       = "winpty";
    version     = "0.4.3";
    sources     = [{ filename = "winpty-0.4.3-1-x86_64.pkg.tar.xz"; sha256 = "4a7740ca2200ca585ce9d8747043c19d2d7bfff9bc2c22df9bf975e12abe51db"; }];
  };

  "xdelta3" = fetch {
    pname       = "xdelta3";
    version     = "3.1.0";
    sources     = [{ filename = "xdelta3-3.1.0-1-x86_64.pkg.tar.xz"; sha256 = "a72fb0a11705523b4e67915c15f294afbefa38ee80fe1bddf653e0b472baeb0b"; }];
    buildInputs = [ xz liblzma ];
  };

  "xmlto" = fetch {
    pname       = "xmlto";
    version     = "0.0.28";
    sources     = [{ filename = "xmlto-0.0.28-2-x86_64.pkg.tar.xz"; sha256 = "21a73919fe230f3e499312bdc35f67ec19bf2aa49d808eb446ebd3273a38b233"; }];
    buildInputs = [ libxslt perl-YAML-Syck perl-Test-Pod ];
    broken      = true; # broken dependency perl-Module-Build -> perl-CPAN-Meta
  };

  "xorriso" = fetch {
    pname       = "xorriso";
    version     = "1.5.0";
    sources     = [{ filename = "xorriso-1.5.0-1-x86_64.pkg.tar.xz"; sha256 = "fd16be882a70dcd9ae2d88ef7f78f42f25e9211e8c825f98970bf9ac9728c849"; }];
    buildInputs = [ libbz2 libreadline zlib ];
  };

  "xproto" = fetch {
    pname       = "xproto";
    version     = "7.0.26";
    sources     = [{ filename = "xproto-7.0.26-1-any.pkg.tar.xz"; sha256 = "639d256a2bf14dc127257aad853cd9e3ca30cb89381ce56765db6d75af65e045"; }];
  };

  "xxhash" = fetch {
    pname       = "xxhash";
    version     = "0.8.0";
    sources     = [{ filename = "xxhash-0.8.0-1-x86_64.pkg.tar.zst"; sha256 = "2ead7e4a65e65f47371a7e515b0e83b09cc9ff6cafa167dc0a90fbf268b84e1d"; }];
    buildInputs = [ (assert libxxhash.version=="0.8.0"; libxxhash) ];
  };

  "xz" = fetch {
    pname       = "xz";
    version     = "5.2.5";
    sources     = [{ filename = "xz-5.2.5-1-x86_64.pkg.tar.xz"; sha256 = "3169f2a1662b9441a3d4943d94649334dc488d5dab75c4e10ab2d5a68e81279f"; }];
    buildInputs = [ (assert liblzma.version=="5.2.5"; liblzma) libiconv libintl ];
  };

  "yasm" = fetch {
    pname       = "yasm";
    version     = "1.3.0";
    sources     = [{ filename = "yasm-1.3.0-2-x86_64.pkg.tar.xz"; sha256 = "11dad22c2d13760f3225e929eb2c81f571cc0d26408c66740ecd2b8fc2736c59"; }];
  };

  "yasm-devel" = fetch {
    pname       = "yasm-devel";
    version     = "1.3.0";
    sources     = [{ filename = "yasm-devel-1.3.0-2-x86_64.pkg.tar.xz"; sha256 = "6f1055deabf3ede4c6a6a97d5157c8b23a88b24e71750540d19e653a04246273"; }];
  };

  "yelp-tools" = fetch {
    pname       = "yelp-tools";
    version     = "3.32.2";
    sources     = [{ filename = "yelp-tools-3.32.2-2-any.pkg.tar.xz"; sha256 = "0feb0acad356c5e09b263f41c55e37823b79183b622800014a101cd7962c2153"; }];
    buildInputs = [ yelp-xsl itstool libxml2-python ];
  };

  "yelp-xsl" = fetch {
    pname       = "yelp-xsl";
    version     = "3.36.0";
    sources     = [{ filename = "yelp-xsl-3.36.0-2-any.pkg.tar.xz"; sha256 = "59d9ac72e60c4cbabcc4724d11671471fc90745621f294193e7b8f3c4852ff6a"; }];
    buildInputs = [  ];
  };

  "yodl" = fetch {
    pname       = "yodl";
    version     = "4.02.02";
    sources     = [{ filename = "yodl-4.02.02-1-x86_64.pkg.tar.xz"; sha256 = "62dd5a3b9e923ce05e7b99d23d5efaf7a3cdfe5984f8fedf8cbf54e5cd8ff211"; }];
    buildInputs = [ bash ];
  };

  "zip" = fetch {
    pname       = "zip";
    version     = "3.0";
    sources     = [{ filename = "zip-3.0-3-x86_64.pkg.tar.xz"; sha256 = "0264950ec9122e5b3b92a1d9fffbe6f4240ab9dee4baf4ec129762866a6c1dc6"; }];
    buildInputs = [ libbz2 ];
  };

  "zlib" = fetch {
    pname       = "zlib";
    version     = "1.2.11";
    sources     = [{ filename = "zlib-1.2.11-1-x86_64.pkg.tar.xz"; sha256 = "4af63558e39e7a4941292132b2985cb2650e78168ab21157a082613215e4839a"; }];
    buildInputs = [ gcc-libs ];
  };

  "zlib-devel" = fetch {
    pname       = "zlib-devel";
    version     = "1.2.11";
    sources     = [{ filename = "zlib-devel-1.2.11-1-x86_64.pkg.tar.xz"; sha256 = "ee3951f7aa3df8c9cfd17f0284b778b351cad8c402d9270cac27816241fcb57b"; }];
    buildInputs = [ (assert zlib.version=="1.2.11"; zlib) ];
  };

  "znc-git" = fetch {
    pname       = "znc-git";
    version     = "r5318.1c9cb3f8";
    sources     = [{ filename = "znc-git-r5318.1c9cb3f8-1-x86_64.pkg.tar.zst"; sha256 = "2951c69b1b916834f83d16ecdb30f85b0d6b016ce4975f4066a7795a68ea1b47"; }];
    buildInputs = [ openssl icu ];
  };

  "zsh" = fetch {
    pname       = "zsh";
    version     = "5.8";
    sources     = [{ filename = "zsh-5.8-3-x86_64.pkg.tar.xz"; sha256 = "0b3804dffc84ef7a936a6ddba4c13843e9cea7ec918e2bb874e228bb2c22b39c"; }];
    buildInputs = [ ncurses pcre libiconv gdbm ];
  };

  "zsh-doc" = fetch {
    pname       = "zsh-doc";
    version     = "5.8";
    sources     = [{ filename = "zsh-doc-5.8-3-x86_64.pkg.tar.xz"; sha256 = "4a4afb14b8955347c5fe1d7ab11f18373ada8366863a63135e0eaed96b4f9c65"; }];
  };

  "zstd" = fetch {
    pname       = "zstd";
    version     = "1.4.5";
    sources     = [{ filename = "zstd-1.4.5-2-x86_64.pkg.tar.xz"; sha256 = "4f3a0ccb02ba783f8fbd41f9ae21fbf2059151f927a462352b343b5a6f85bc8d"; }];
    buildInputs = [ gcc-libs libzstd ];
  };

}; in self
