 # GENERATED FILE
{config, lib, stdenvNoCC, fetchurl}:

let
  fetch = { name, version, filename, sha256, buildInputs ? [], broken ? false }:
    stdenvNoCC.mkDerivation {
      inherit name version buildInputs;
      src = fetchurl {
        url = "http://repo.msys2.org/msys/x86_64/${filename}";
        inherit sha256;
      };
      sourceRoot = ".";
      buildPhase = if stdenvNoCC.isShellPerl /* on native windows */ then
        ''
          move    'mingw64', "$ENV{out}";
          dircopy '.',       "$ENV{out}/";
          unlink "$ENV{out}/.BUILDINFO";
          unlink "$ENV{out}/.INSTALL";
          unlink "$ENV{out}/.MTREE";
          unlink "$ENV{out}/.PKGINFO";
          use File::Find qw(find);
        '' + lib.concatMapStringsSep "\n" (dep: ''
              sub process {
                my $src = $_;
                die "bad src: '$src'" unless $src =~ /\/[0-9a-df-np-sv-z]{32}-[^\/]+(.*)/;
                my $rel = $1;
                my $tgt = "$ENV{out}$rel";
                print("$src -> $tgt\n");
                if (-d $src) {
                  make_path($tgt);
                } else {
                  system('mklink', $tgt =~ s|/|\\|gr, $src =~ s|/|\\|gr);
                }
              };
              find({ wanted => \&process, no_chdir => 1}, '${dep}');
            '') buildInputs
      else if stdenvNoCC.isShellCmdExe /* on mingw bootstrap */ then
        ''
          echo yay
          exit 1
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

  "apr" = fetch {
    name        = "apr";
    version     = "1.6.5";
    filename    = "apr-1.6.5-1-x86_64.pkg.tar.xz";
    sha256      = "ef4335a085d07587f824369c23795e4ea534145ebdf4c26266d57c03d7f3ef47";
    buildInputs = [ libcrypt libuuid ];
    broken      = true;
  };

  "apr-devel" = fetch {
    name        = "apr-devel";
    version     = "1.6.5";
    filename    = "apr-devel-1.6.5-1-x86_64.pkg.tar.xz";
    sha256      = "7bd2bfc9db4dbcf44d8c2c18b3419e300f57b303db8de0ca76bff95dcec07cf2";
    buildInputs = [ (assert apr.version=="1.6.5"; apr) libcrypt-devel libuuid-devel ];
    broken      = true;
  };

  "apr-util" = fetch {
    name        = "apr-util";
    version     = "1.6.1";
    filename    = "apr-util-1.6.1-1-x86_64.pkg.tar.xz";
    sha256      = "6ffe865abff6d79c954c620a44a5ec570d05131279a05302c5142946220deef2";
    buildInputs = [ apr expat libsqlite ];
    broken      = true;
  };

  "apr-util-devel" = fetch {
    name        = "apr-util-devel";
    version     = "1.6.1";
    filename    = "apr-util-devel-1.6.1-1-x86_64.pkg.tar.xz";
    sha256      = "a6bda4a4a8d79d53d79a270dd5dd5f81a837844c3a2fc185664f72a7ffb86964";
    buildInputs = [ (assert apr-util.version=="1.6.1"; apr-util) apr-devel libexpat-devel libsqlite-devel ];
    broken      = true;
  };

  "asciidoc" = fetch {
    name        = "asciidoc";
    version     = "8.6.10";
    filename    = "asciidoc-8.6.10-1-any.pkg.tar.xz";
    sha256      = "e925ea8f5194e542519bd63a92c0efb3c1a871189e6695f54426ea16db2fa2ad";
    buildInputs = [ python2 libxslt docbook-xsl ];
  };

  "aspell" = fetch {
    name        = "aspell";
    version     = "0.60.6.1";
    filename    = "aspell-0.60.6.1-1-x86_64.pkg.tar.xz";
    sha256      = "705c0d5ac74b1a4a00e92fe2a171846893e2952fc3d9f166a3f51cd07284d4e2";
    buildInputs = [ gcc-libs gettext libiconv ncurses ];
  };

  "aspell-devel" = fetch {
    name        = "aspell-devel";
    version     = "0.60.6.1";
    filename    = "aspell-devel-0.60.6.1-1-x86_64.pkg.tar.xz";
    sha256      = "20a2d721e941ed4dcf99c6c19652ba60d8433eaca52544797fd638b64d564892";
    buildInputs = [ (assert aspell.version=="0.60.6.1"; aspell) gettext-devel libiconv-devel ncurses-devel ];
  };

  "aspell6-en" = fetch {
    name        = "aspell6-en";
    version     = "2018.04.16";
    filename    = "aspell6-en-2018.04.16-1-x86_64.pkg.tar.xz";
    sha256      = "903e52d67f00d0c8179c0f489df31405111885256f1e8d3dbf82a3fe4e8d8ccb";
    buildInputs = [ (assert lib.versionAtLeast aspell.version "2018.04.16"; aspell) ];
  };

  "atool" = fetch {
    name        = "atool";
    version     = "0.39.0";
    filename    = "atool-0.39.0-1-any.pkg.tar.xz";
    sha256      = "1b3a8d8b402d356d9e1690959aa10523944271c660476f6af20e9ccf59c0a5a5";
    buildInputs = [ file perl ];
  };

  "autoconf" = fetch {
    name        = "autoconf";
    version     = "2.69";
    filename    = "autoconf-2.69-5-any.pkg.tar.xz";
    sha256      = "aaf1390524fa573a7f210e12203f0fcdb550028fb33badeb6e67d56ae57abbbb";
    buildInputs = [ awk m4 diffutils bash perl ];
  };

  "autoconf-archive" = fetch {
    name        = "autoconf-archive";
    version     = "2018.03.13";
    filename    = "autoconf-archive-2018.03.13-1-any.pkg.tar.xz";
    sha256      = "7f283986a7a5d82331519f1eb00f95152e1df6f9a0351cf652a7c0107b8f21ed";
  };

  "autoconf2.13" = fetch {
    name        = "autoconf2.13";
    version     = "2.13";
    filename    = "autoconf2.13-2.13-2-any.pkg.tar.xz";
    sha256      = "99abc626148147ceb79ec99e374d9c5c2e7e54df2234043bf6b5b715206a6983";
    buildInputs = [ awk m4 diffutils bash ];
  };

  "autogen" = fetch {
    name        = "autogen";
    version     = "5.18.16";
    filename    = "autogen-5.18.16-1-x86_64.pkg.tar.xz";
    sha256      = "bbef2ab6b6c831bc79a36f5dd571534b62a14c16f29e32c615cc39a237ab085a";
    buildInputs = [ gcc-libs gmp libcrypt libffi libgc libguile libxml2 ];
  };

  "automake-wrapper" = fetch {
    name        = "automake-wrapper";
    version     = "11";
    filename    = "automake-wrapper-11-1-any.pkg.tar.xz";
    sha256      = "fc95a33b5ca011a01209ec6a6e3f58cced6ff074bdf8fa2ac627669ecaaefeb7";
    buildInputs = [ bash gawk self."automake1.6" self."automake1.7" self."automake1.7" self."automake1.8" self."automake1.9" self."automake1.10" self."automake1.11" self."automake1.12" self."automake1.13" self."automake1.14" self."automake1.15" self."automake1.16" ];
  };

  "automake1.10" = fetch {
    name        = "automake1.10";
    version     = "1.10.3";
    filename    = "automake1.10-1.10.3-3-any.pkg.tar.xz";
    sha256      = "c1e0465e94f63b60aa7e7377ec50506e76d7d7e76fa1e403afb5065bfaa4465c";
    buildInputs = [ perl bash ];
  };

  "automake1.11" = fetch {
    name        = "automake1.11";
    version     = "1.11.6";
    filename    = "automake1.11-1.11.6-3-any.pkg.tar.xz";
    sha256      = "c014f65044f654d8c18a98bfe81aea347c7ea8a01a8e876acbc94dbdc45653b2";
    buildInputs = [ perl bash ];
  };

  "automake1.12" = fetch {
    name        = "automake1.12";
    version     = "1.12.6";
    filename    = "automake1.12-1.12.6-3-any.pkg.tar.xz";
    sha256      = "fb95e705ac548990b4749d42806adb6016a15d80cae52901df4e4af72c1510b0";
    buildInputs = [ perl bash ];
  };

  "automake1.13" = fetch {
    name        = "automake1.13";
    version     = "1.13.4";
    filename    = "automake1.13-1.13.4-4-any.pkg.tar.xz";
    sha256      = "8da64de7957b2fedf0a6c7ae4588fd969125065a7412107287c362ab20b29f55";
    buildInputs = [ perl bash ];
  };

  "automake1.14" = fetch {
    name        = "automake1.14";
    version     = "1.14.1";
    filename    = "automake1.14-1.14.1-3-any.pkg.tar.xz";
    sha256      = "773e78c17a75dd5d81f42f28e435a018265dd11928e7c0f0f11d5effb5f3f211";
    buildInputs = [ perl bash ];
  };

  "automake1.15" = fetch {
    name        = "automake1.15";
    version     = "1.15.1";
    filename    = "automake1.15-1.15.1-1-any.pkg.tar.xz";
    sha256      = "18398ccee25a92bc3d22cf8bf2da2ebcc7403018b276e342bdf67367d870c102";
    buildInputs = [ perl bash ];
  };

  "automake1.16" = fetch {
    name        = "automake1.16";
    version     = "1.16.1";
    filename    = "automake1.16-1.16.1-1-any.pkg.tar.xz";
    sha256      = "3efda150dbc0d740bc361f0aaa754f84c5b5229300e66291887fd2fcd4cd48b7";
    buildInputs = [ perl bash ];
  };

  "automake1.6" = fetch {
    name        = "automake1.6";
    version     = "1.6.3";
    filename    = "automake1.6-1.6.3-2-any.pkg.tar.xz";
    sha256      = "66e1ee5830053ade6cfd5cb1250a0834b07e92a5b71928e50f4ed41d72e6c445";
    buildInputs = [ perl bash ];
  };

  "automake1.7" = fetch {
    name        = "automake1.7";
    version     = "1.7.9";
    filename    = "automake1.7-1.7.9-2-any.pkg.tar.xz";
    sha256      = "f8c22aa7aeb506ac3a3ff42085defb7429b2dcc693f9511d44b5034666b850d6";
    buildInputs = [ perl bash ];
  };

  "automake1.8" = fetch {
    name        = "automake1.8";
    version     = "1.8.5";
    filename    = "automake1.8-1.8.5-3-any.pkg.tar.xz";
    sha256      = "53e2919b6d285de612357f7b2886f959911369928c7d9a3a7d14684d48fecb10";
    buildInputs = [ perl bash ];
  };

  "automake1.9" = fetch {
    name        = "automake1.9";
    version     = "1.9.6";
    filename    = "automake1.9-1.9.6-2-any.pkg.tar.xz";
    sha256      = "0d160a58595aee6ca86ec883ab884549b8a793b4a88cd223ec86b45c1b6d002e";
    buildInputs = [ perl bash ];
  };

  "axel" = fetch {
    name        = "axel";
    version     = "2.16.1";
    filename    = "axel-2.16.1-2-x86_64.pkg.tar.xz";
    sha256      = "032c4fb5d052ce5e3930e8430210695d4ea2c2945b9e72ac60c9ef968a4e3f62";
    buildInputs = [ openssl gettext ];
  };

  "bash" = fetch {
    name        = "bash";
    version     = "4.4.023";
    filename    = "bash-4.4.023-1-x86_64.pkg.tar.xz";
    sha256      = "949262d49c6521032419c041814063f7313459b016fb65410167c1388486a47e";
    buildInputs = [ msys2-runtime ];
  };

  "bash-completion" = fetch {
    name        = "bash-completion";
    version     = "2.8";
    filename    = "bash-completion-2.8-2-any.pkg.tar.xz";
    sha256      = "0c1b853c5efce2a87700259f72602cb8cfe4862fffa44da37ab862638b574e67";
    buildInputs = [ bash ];
  };

  "bash-devel" = fetch {
    name        = "bash-devel";
    version     = "4.4.023";
    filename    = "bash-devel-4.4.023-1-x86_64.pkg.tar.xz";
    sha256      = "e8904e4d5ed2d34e9a5a2b98f82310dc70a675c8886364626c0bc73e72451e5e";
  };

  "bc" = fetch {
    name        = "bc";
    version     = "1.07.1";
    filename    = "bc-1.07.1-1-x86_64.pkg.tar.xz";
    sha256      = "25c54f9ecd2b15acd18de6b9b5ab11784f2d4fb375ff7168d6594089f1b0477e";
    buildInputs = [ libreadline ncurses ];
  };

  "binutils" = fetch {
    name        = "binutils";
    version     = "2.30";
    filename    = "binutils-2.30-1-x86_64.pkg.tar.xz";
    sha256      = "a7aacf4dbb2ed0e24543acb1378efc9f0c02982625039bd3d71aae8276de8959";
    buildInputs = [ libiconv libintl zlib ];
  };

  "bison" = fetch {
    name        = "bison";
    version     = "3.2.4";
    filename    = "bison-3.2.4-1-x86_64.pkg.tar.xz";
    sha256      = "c76f68eeb6fa9aa00b1bd637a04f0e57b3e119f3d3d05902876a714eb80d4006";
    buildInputs = [ m4 sh ];
  };

  "bisonc++" = fetch {
    name        = "bisonc++";
    version     = "6.02.01";
    filename    = "bisonc++-6.02.01-1-x86_64.pkg.tar.xz";
    sha256      = "0f672e5cc22038dd565bce5663481b2fedca7f0e86ee46d1f1cfc5f310b81e28";
    buildInputs = [ (assert lib.versionAtLeast libbobcat.version "6.02.01"; libbobcat) ];
  };

  "brotli" = fetch {
    name        = "brotli";
    version     = "1.0.7";
    filename    = "brotli-1.0.7-1-x86_64.pkg.tar.xz";
    sha256      = "526d196212467b1b693e41d8c6f7d55cb3647723a89afadbe34bf2227de10740";
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "brotli-devel" = fetch {
    name        = "brotli-devel";
    version     = "1.0.7";
    filename    = "brotli-devel-1.0.7-1-x86_64.pkg.tar.xz";
    sha256      = "2079a873014ef416ad0e9f1967564cf11e662e447a990dbfc4c7aa83b0b0abd0";
    buildInputs = [ brotli ];
  };

  "brotli-testdata" = fetch {
    name        = "brotli-testdata";
    version     = "1.0.7";
    filename    = "brotli-testdata-1.0.7-1-x86_64.pkg.tar.xz";
    sha256      = "4f10ca1268a58a8bca3265c8fc77c1f092012e81fb53b17c4da54ac71a59ccd1";
  };

  "bsdcpio" = fetch {
    name        = "bsdcpio";
    version     = "3.3.3";
    filename    = "bsdcpio-3.3.3-3-x86_64.pkg.tar.xz";
    sha256      = "e2b48e299b41cd7824ae26dbe4f6a8fcaafc360ddf4003b5f8c95bbe80d672b9";
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 liblzo2 libnettle libxml2 zlib ];
  };

  "bsdtar" = fetch {
    name        = "bsdtar";
    version     = "3.3.3";
    filename    = "bsdtar-3.3.3-3-x86_64.pkg.tar.xz";
    sha256      = "0f8e926a306a8eccd307b31cc85e3a132ec010d3588cd49472535b7abaa27fe0";
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 liblzo2 libnettle libxml2 zlib ];
  };

  "busybox" = fetch {
    name        = "busybox";
    version     = "1.23.2";
    filename    = "busybox-1.23.2-1-x86_64.pkg.tar.xz";
    sha256      = "546af3b96662d6787e2415da09d63b223f266c246e2138cbfd0ae39f0c8ea926";
    buildInputs = [ msys2-runtime ];
  };

  "bzip2" = fetch {
    name        = "bzip2";
    version     = "1.0.6";
    filename    = "bzip2-1.0.6-2-x86_64.pkg.tar.xz";
    sha256      = "e266d19f19cfed101c8d7faefcd54f3d818528032f0b69706aa60d4fe96326d7";
    buildInputs = [ libbz2 ];
  };

  "bzr" = fetch {
    name        = "bzr";
    version     = "2.7.0";
    filename    = "bzr-2.7.0-2-x86_64.pkg.tar.xz";
    sha256      = "e41520f7ef35d5c0dd58a6ce2b8e194fd6fcc043f49414b187437435d105f53b";
    buildInputs = [ python2 ];
  };

  "bzr-fastimport" = fetch {
    name        = "bzr-fastimport";
    version     = "0.13.0";
    filename    = "bzr-fastimport-0.13.0-1-any.pkg.tar.xz";
    sha256      = "793eaa49198a8a7fc82054a0195774234c60d2d481b5ed1210d9880a0077023f";
    buildInputs = [ bzr python2-fastimport ];
  };

  "ca-certificates" = fetch {
    name        = "ca-certificates";
    version     = "20180409";
    filename    = "ca-certificates-20180409-1-any.pkg.tar.xz";
    sha256      = "9ffb48ac5d11d6d51c5d817039ec901c5e919072ed775335ca50d1f9e2196821";
    buildInputs = [ bash openssl findutils coreutils sed p11-kit ];
  };

  "ccache" = fetch {
    name        = "ccache";
    version     = "3.5";
    filename    = "ccache-3.5-1-x86_64.pkg.tar.xz";
    sha256      = "54807d76060b285713cb92ae83109d04db891ecd04ad907f525f2f27f2a7765e";
    buildInputs = [ gcc-libs zlib ];
  };

  "cdecl" = fetch {
    name        = "cdecl";
    version     = "2.5";
    filename    = "cdecl-2.5-1-x86_64.pkg.tar.xz";
    sha256      = "b49ead1877dcee37018b4b404088d53ee0dfa01cc4d83ad62bf8f4511b89d71b";
    buildInputs = [ libedit ];
  };

  "cgdb" = fetch {
    name        = "cgdb";
    version     = "0.7.0";
    filename    = "cgdb-0.7.0-1-x86_64.pkg.tar.xz";
    sha256      = "712d2f48660a3b1242547f104f8f2854f92e20db25cdc1aca2e78ae0ba451130";
    buildInputs = [ libreadline ncurses gdb ];
  };

  "clang-svn" = fetch {
    name        = "clang-svn";
    version     = "60106.1d5b05f";
    filename    = "clang-svn-60106.1d5b05f-1-x86_64.pkg.tar.xz";
    sha256      = "a393952ed135e66bab949f28e5a40fba6d2d89f8c4c3cf4221b231358359a82d";
    buildInputs = [ llvm-svn ];
  };

  "cloc" = fetch {
    name        = "cloc";
    version     = "1.80";
    filename    = "cloc-1.80-1-any.pkg.tar.xz";
    sha256      = "7aa63e31e7946ae2c42f03480df5eaf83c76dfc99db892a430bbd74794c81d3f";
    buildInputs = [ perl perl-Algorithm-Diff perl-Regexp-Common perl-Parallel-ForkManager ];
  };

  "cloog" = fetch {
    name        = "cloog";
    version     = "0.19.0";
    filename    = "cloog-0.19.0-2-x86_64.pkg.tar.xz";
    sha256      = "bb56f38e41e2d811d1f5a8170778c45962aa7191e2af29e55c9bf721380f1cb7";
    buildInputs = [ isl ];
  };

  "cloog-devel" = fetch {
    name        = "cloog-devel";
    version     = "0.19.0";
    filename    = "cloog-devel-0.19.0-2-x86_64.pkg.tar.xz";
    sha256      = "bc03ebb0eb91039d3eda1d461c7ca236b86e110d00d106a13b02fb6ca9fa98c2";
    buildInputs = [ (assert cloog.version=="0.19.0"; cloog) isl-devel ];
  };

  "cmake" = fetch {
    name        = "cmake";
    version     = "3.13.2";
    filename    = "cmake-3.13.2-1-x86_64.pkg.tar.xz";
    sha256      = "62796f67360778003bb36aeb6b2f26505f6a807a6d4285aa3a0bada84ab7b034";
    buildInputs = [ gcc-libs jsoncpp libcurl libexpat libarchive librhash libutil-linux libuv ncurses pkg-config zlib ];
  };

  "cocom" = fetch {
    name        = "cocom";
    version     = "0.996";
    filename    = "cocom-0.996-2-x86_64.pkg.tar.xz";
    sha256      = "39ff7eed6f337034294b805200cc46946413c49ae91a27f2c4f22e6d75aeaf39";
  };

  "colordiff" = fetch {
    name        = "colordiff";
    version     = "1.0.18";
    filename    = "colordiff-1.0.18-1-any.pkg.tar.xz";
    sha256      = "8bd451607be21c46d26de5d09a0849d21835bdd02e5eb638ea8b2667bb595ee0";
    buildInputs = [ diffutils perl ];
  };

  "colormake-git" = fetch {
    name        = "colormake-git";
    version     = "r8.9c1d2e6";
    filename    = "colormake-git-r8.9c1d2e6-1-any.pkg.tar.xz";
    sha256      = "835a637b514280a3a24e273faff1b1f0abff65691123d0eb768be2b7bbe20c45";
    buildInputs = [ make ];
  };

  "conemu-git" = fetch {
    name        = "conemu-git";
    version     = "r3330.34a88ed";
    filename    = "conemu-git-r3330.34a88ed-1-x86_64.pkg.tar.xz";
    sha256      = "6915a2f7a203490b67ce7156e9d5e4a6420a3f95ab0cdcbeb76f166e25282419";
  };

  "coreutils" = fetch {
    name        = "coreutils";
    version     = "8.30";
    filename    = "coreutils-8.30-1-x86_64.pkg.tar.xz";
    sha256      = "18e1f0409c9c2d0bc6774172b9f5d5b834027a16a98b0f2f725c4ccf4fa26139";
    buildInputs = [ gmp libiconv libintl ];
  };

  "cpio" = fetch {
    name        = "cpio";
    version     = "2.12";
    filename    = "cpio-2.12-1-x86_64.pkg.tar.xz";
    sha256      = "b0ecdbbb4e2ada2810cb8a802656aa53bdd3831bf248fc3948b93040a8a97387";
    buildInputs = [ libintl ];
  };

  "crosstool-ng" = fetch {
    name        = "crosstool-ng";
    version     = "1.23.0";
    filename    = "crosstool-ng-1.23.0-2-x86_64.pkg.tar.xz";
    sha256      = "1019c3772471ed1e0df3115ad4034644f3b462d6dfea8886146b00aa5ac0ccbf";
    buildInputs = [ ncurses libintl ];
  };

  "crosstool-ng-git" = fetch {
    name        = "crosstool-ng-git";
    version     = "1.19.314.a483cd9";
    filename    = "crosstool-ng-git-1.19.314.a483cd9-1-x86_64.pkg.tar.xz";
    sha256      = "0c78ada82e5fa0d256af176b23601d774bc0007a9617b9f55861e59b09eb461c";
    buildInputs = [ ncurses-devel ];
  };

  "cscope" = fetch {
    name        = "cscope";
    version     = "15.9";
    filename    = "cscope-15.9-1-x86_64.pkg.tar.xz";
    sha256      = "77f626cc0de4203a31b1743ddc1a613d8993f2769e101c369c964a43594d7adb";
  };

  "ctags" = fetch {
    name        = "ctags";
    version     = "5.8";
    filename    = "ctags-5.8-2-x86_64.pkg.tar.xz";
    sha256      = "7b7a5b97ccb64ff9ffd0acc0e962b1304b1d6998113d145090a08a6b4d1e4181";
  };

  "curl" = fetch {
    name        = "curl";
    version     = "7.63.0";
    filename    = "curl-7.63.0-1-x86_64.pkg.tar.xz";
    sha256      = "944f4f426affd2aeac2f692e96a646c3fe739f5340f62612b53af9fa8c40c78f";
    buildInputs = [ ca-certificates libcurl libcrypt libmetalink libnghttp2 libpsl openssl zlib ];
  };

  "cvs" = fetch {
    name        = "cvs";
    version     = "1.11.23";
    filename    = "cvs-1.11.23-3-x86_64.pkg.tar.xz";
    sha256      = "ecbb92c376c0e0ebc365a18772c2219eba48ce4afa7117ce3661c85c1f8af911";
    buildInputs = [ heimdal zlib libcrypt libopenssl ];
  };

  "cygrunsrv" = fetch {
    name        = "cygrunsrv";
    version     = "1.62";
    filename    = "cygrunsrv-1.62-1-x86_64.pkg.tar.xz";
    sha256      = "c7fa1df8288d69d01014365ff6ba13d28dd7605ab9b7e1541e703e46a522dae6";
    buildInputs = [ python2 ];
  };

  "cyrus-sasl" = fetch {
    name        = "cyrus-sasl";
    version     = "2.1.27";
    filename    = "cyrus-sasl-2.1.27-1-x86_64.pkg.tar.xz";
    sha256      = "903d0255dd4e1bc38577d86e0814235a6f7166e10d9441b78963dd5a3d5fb9aa";
    buildInputs = [ (assert libsasl.version=="2.1.27"; libsasl) ];
  };

  "dash" = fetch {
    name        = "dash";
    version     = "0.5.10.2";
    filename    = "dash-0.5.10.2-1-x86_64.pkg.tar.xz";
    sha256      = "adc9d44519e30904d0baec122e7700391d29a2197ae9bb10da8db265d6fe1183";
    buildInputs = [ msys2-base msys2-runtime grep sed ];
    broken      = true;
  };

  "db" = fetch {
    name        = "db";
    version     = "5.3.28";
    filename    = "db-5.3.28-2-x86_64.pkg.tar.xz";
    sha256      = "b3137f111e0332aff99c8ece70e445cbb97efbf02d5facd36f0c2242d5dd369a";
    buildInputs = [ (assert libdb.version=="5.3.28"; libdb) ];
  };

  "db-docs" = fetch {
    name        = "db-docs";
    version     = "5.3.28";
    filename    = "db-docs-5.3.28-2-x86_64.pkg.tar.xz";
    sha256      = "7287b440ae4b4362f6d7c98fbe93d7ce0a3f5057788958a4048f4a5648230955";
    buildInputs = [ sh ];
  };

  "dejagnu" = fetch {
    name        = "dejagnu";
    version     = "1.6.2";
    filename    = "dejagnu-1.6.2-1-any.pkg.tar.xz";
    sha256      = "a1bcb0b93a526c8a7c6fe5147b8cf076f7df6434a9c31ee9a527f86f603b75bc";
    buildInputs = [ expect ];
  };

  "delta" = fetch {
    name        = "delta";
    version     = "20060803";
    filename    = "delta-20060803-1-x86_64.pkg.tar.xz";
    sha256      = "ae8f70fc1e4ec82a47f4471d622830f751f747db29ac2b09a5b8cb5a1790942f";
    buildInputs = [ perl ];
  };

  "depot-tools-git" = fetch {
    name        = "depot-tools-git";
    version     = "r2542.77b74b5";
    filename    = "depot-tools-git-r2542.77b74b5-1-any.pkg.tar.xz";
    sha256      = "c204f5220b0fe1f74c409255a9d360e185d9c6391d66c693dcf876842598ed6e";
    buildInputs = [ python2 python2-colorama ];
  };

  "dialog" = fetch {
    name        = "dialog";
    version     = "1.3_20181107";
    filename    = "dialog-1.3_20181107-1-x86_64.pkg.tar.xz";
    sha256      = "440909b4e5f966d88b6be72a46ac8ee9670aacd506f13f42e7d4c3b4d279eb15";
    buildInputs = [ ncurses ];
  };

  "diffstat" = fetch {
    name        = "diffstat";
    version     = "1.61";
    filename    = "diffstat-1.61-1-x86_64.pkg.tar.xz";
    sha256      = "71b96b65b31a130455730fca78a9700586d33a068e2732b46df7d4e55a8977dc";
    buildInputs = [ msys2-runtime ];
  };

  "diffutils" = fetch {
    name        = "diffutils";
    version     = "3.6";
    filename    = "diffutils-3.6-1-x86_64.pkg.tar.xz";
    sha256      = "fc4629b8a00ee43d4102fbdf3f122828cfd9c7540bc74dd77476b43157bd2baa";
    buildInputs = [ msys2-runtime sh ];
  };

  "docbook-dsssl" = fetch {
    name        = "docbook-dsssl";
    version     = "1.79";
    filename    = "docbook-dsssl-1.79-1-any.pkg.tar.xz";
    sha256      = "03a865131ce845f6f87ebc9d774b5a5383492fc8e633e970517bd75fb5951bf1";
    buildInputs = [ sgml-common perl ];
  };

  "docbook-mathml" = fetch {
    name        = "docbook-mathml";
    version     = "1.1CR1";
    filename    = "docbook-mathml-1.1CR1-1-any.pkg.tar.xz";
    sha256      = "4d3f0567d367b5e21eeee07ef87a35efc8f3ae64134253972e7099e8b013e9cb";
    buildInputs = [ libxml2 ];
  };

  "docbook-sgml" = fetch {
    name        = "docbook-sgml";
    version     = "4.5";
    filename    = "docbook-sgml-4.5-1-any.pkg.tar.xz";
    sha256      = "89cba5e6b4ceb7319c84ad08d6f582ac0933639105a05835c7270cbc297f2bf9";
    buildInputs = [ sgml-common ];
  };

  "docbook-sgml31" = fetch {
    name        = "docbook-sgml31";
    version     = "3.1";
    filename    = "docbook-sgml31-3.1-1-any.pkg.tar.xz";
    sha256      = "7c10e1ad75147cd0c09b1ccae2eb8a34dc44211435e771c5f7a392ea45328717";
    buildInputs = [ sgml-common ];
  };

  "docbook-xml" = fetch {
    name        = "docbook-xml";
    version     = "4.5";
    filename    = "docbook-xml-4.5-2-any.pkg.tar.xz";
    sha256      = "a01f648a7af372b290528430d3e1768ac3d8aee4c0e74bcf750f646fc8e9948f";
    buildInputs = [ libxml2 ];
  };

  "docbook-xsl" = fetch {
    name        = "docbook-xsl";
    version     = "1.79.2";
    filename    = "docbook-xsl-1.79.2-1-any.pkg.tar.xz";
    sha256      = "ede4fbbc97f1dda1d1640926001d70b0ea4af0ad6f8c20a5d6ce84e501d94045";
    buildInputs = [ libxml2 libxslt docbook-xml ];
  };

  "docx2txt" = fetch {
    name        = "docx2txt";
    version     = "1.4";
    filename    = "docx2txt-1.4-1-x86_64.pkg.tar.xz";
    sha256      = "736a37af1c54e1d4746c523e105b33e6eccfacdd4a4ac87b1326499ee56c59f1";
    buildInputs = [ perl unzip ];
  };

  "dos2unix" = fetch {
    name        = "dos2unix";
    version     = "7.4.0";
    filename    = "dos2unix-7.4.0-1-x86_64.pkg.tar.xz";
    sha256      = "4f890f6fe6bc89349157e5764463356bc72a9b8bfebb1316296f973bd30c6dd9";
    buildInputs = [ libintl ];
  };

  "doxygen" = fetch {
    name        = "doxygen";
    version     = "1.8.14";
    filename    = "doxygen-1.8.14-1-x86_64.pkg.tar.xz";
    sha256      = "525148e080ddc72fb77c4354e52583d44239b28bd3aa86b9f70a0ff161783d54";
    buildInputs = [ gcc-libs libsqlite libiconv ];
  };

  "dtc" = fetch {
    name        = "dtc";
    version     = "1.4.7";
    filename    = "dtc-1.4.7-1-x86_64.pkg.tar.xz";
    sha256      = "bab0118087af9e577457a4401bdc78dd94c65973c66d7c48bb4efe77bf8de141";
  };

  "easyoptions-git" = fetch {
    name        = "easyoptions-git";
    version     = "r37.c481763";
    filename    = "easyoptions-git-r37.c481763-1-any.pkg.tar.xz";
    sha256      = "0e9839f287481c33744cc95469fd5bd90d1acb2b768f63829229c241921d9914";
    buildInputs = [ ruby bash ];
  };

  "ed" = fetch {
    name        = "ed";
    version     = "1.14.2";
    filename    = "ed-1.14.2-1-x86_64.pkg.tar.xz";
    sha256      = "769a2073fcdc30810007b2d7d1f22e998246a973a4debf98a1a77a8555dcd1db";
    buildInputs = [ sh ];
  };

  "elinks-git" = fetch {
    name        = "elinks-git";
    version     = "0.13.4008.f86be659";
    filename    = "elinks-git-0.13.4008.f86be659-2-x86_64.pkg.tar.xz";
    sha256      = "4221e52fff123d1343fe1a2940c50071ca15b71f59560f951d612f3df0f7b933";
    buildInputs = [ doxygen gettext libbz2 libcrypt libexpat libffi libgc libgcrypt libgnutls libhogweed libiconv libidn liblzma libnettle libp11-kit libtasn1 libtre-git libunistring perl python2 xmlto zlib ];
    broken      = true;
  };

  "emacs" = fetch {
    name        = "emacs";
    version     = "26.1";
    filename    = "emacs-26.1-1-x86_64.pkg.tar.xz";
    sha256      = "38d01bc18f46056df858b2e027227c12ccfa7a44752ab3e47fe797e6468b5ee9";
    buildInputs = [ ncurses zlib libxml2 libiconv libcrypt libgnutls glib2 libhogweed ];
  };

  "expat" = fetch {
    name        = "expat";
    version     = "2.2.6";
    filename    = "expat-2.2.6-1-x86_64.pkg.tar.xz";
    sha256      = "71a697bb423a695151a06e3ce15bc62e027fbd34aa3def3bfced6c23635c5f20";
    buildInputs = [  ];
  };

  "expect" = fetch {
    name        = "expect";
    version     = "5.45.4";
    filename    = "expect-5.45.4-2-x86_64.pkg.tar.xz";
    sha256      = "15782d5f134fac0342144f51edc7feb1c4fc5f050e2393727a1c0534b2ead3ef";
    buildInputs = [ tcl ];
  };

  "fcode-utils" = fetch {
    name        = "fcode-utils";
    version     = "1.0.2";
    filename    = "fcode-utils-1.0.2-1-x86_64.pkg.tar.xz";
    sha256      = "6a819eab4c3cd177434f987a4280945db7c0a5d61dcbe9490e2d59d1edbdee8d";
  };

  "file" = fetch {
    name        = "file";
    version     = "5.35";
    filename    = "file-5.35-1-x86_64.pkg.tar.xz";
    sha256      = "755fec7a984f96eca393dedbda41d8fbe4dfe2582684cfa2ff409ee24a02114f";
    buildInputs = [ gcc-libs msys2-runtime zlib ];
  };

  "filesystem" = fetch {
    name        = "filesystem";
    version     = "2018.12";
    filename    = "filesystem-2018.12-1-x86_64.pkg.tar.xz";
    sha256      = "5859c7affc435671fa3fc19e88ff284ae5293e173b2dcae2e1388c2e9c93685a";
  };

  "findutils" = fetch {
    name        = "findutils";
    version     = "4.6.0";
    filename    = "findutils-4.6.0-1-x86_64.pkg.tar.xz";
    sha256      = "03cc38c96f67059f5612fd621313cd12b79a29bc45ea98d4c1082fffb38ef3b7";
    buildInputs = [ libiconv libintl ];
  };

  "fish" = fetch {
    name        = "fish";
    version     = "2.7.1";
    filename    = "fish-2.7.1-2-x86_64.pkg.tar.xz";
    sha256      = "c8a3a6c0790ed5a8dfddf907bd1941a9386084e42e64644cc186618134c74f09";
    buildInputs = [ gcc-libs ncurses gettext libiconv man-db bc ];
  };

  "flex" = fetch {
    name        = "flex";
    version     = "2.6.4";
    filename    = "flex-2.6.4-1-x86_64.pkg.tar.xz";
    sha256      = "dca8b51b1f0f0abf32cdb6b718414fafc6a6849e3feb13b1056ebe092b23a784";
    buildInputs = [ m4 sh libiconv libintl ];
  };

  "flexc++" = fetch {
    name        = "flexc++";
    version     = "2.07.02";
    filename    = "flexc++-2.07.02-1-x86_64.pkg.tar.xz";
    sha256      = "39f908aaf265d4761fd95d737ad69759ebd807c4e030a87d0c08d93353d66aca";
    buildInputs = [ (assert lib.versionAtLeast libbobcat.version "2.07.02"; libbobcat) ];
  };

  "fzy" = fetch {
    name        = "fzy";
    version     = "1.0";
    filename    = "fzy-1.0-1-x86_64.pkg.tar.xz";
    sha256      = "84099bfcc4421d3a9aae5145ff1b2e59384c1271fd37e77a941eca429616b471";
  };

  "gamin" = fetch {
    name        = "gamin";
    version     = "0.1.10";
    filename    = "gamin-0.1.10-3-x86_64.pkg.tar.xz";
    sha256      = "d0f9a09b18ff06b985ed391e79ca6757a7e858969d730668f007f70884e63f10";
  };

  "gamin-devel" = fetch {
    name        = "gamin-devel";
    version     = "0.1.10";
    filename    = "gamin-devel-0.1.10-3-x86_64.pkg.tar.xz";
    sha256      = "ed7e4abd8d3447a1494489834e6cd7c4e6622f16972b25403fbc927138335298";
    buildInputs = [ (assert gamin.version=="0.1.10"; gamin) ];
  };

  "gamin-python" = fetch {
    name        = "gamin-python";
    version     = "0.1.10";
    filename    = "gamin-python-0.1.10-3-x86_64.pkg.tar.xz";
    sha256      = "f3b9069aa4c2b46d3dcac6ad74c10a92d0183359e9c7eda108c9bfdff06a3bf8";
    buildInputs = [ (assert gamin.version=="0.1.10"; gamin) python2 ];
  };

  "gawk" = fetch {
    name        = "gawk";
    version     = "4.2.1";
    filename    = "gawk-4.2.1-2-x86_64.pkg.tar.xz";
    sha256      = "8ad327116a180372a5bf79d701527a23d8b106e910e328d5df702f4da38e81aa";
    buildInputs = [ sh mpfr libintl libreadline ];
  };

  "gcc" = fetch {
    name        = "gcc";
    version     = "7.4.0";
    filename    = "gcc-7.4.0-1-x86_64.pkg.tar.xz";
    sha256      = "53baa2129029a8c9f9244eac1eed5e9cecdb1660e0cf536a8dc49605d6e834d1";
    buildInputs = [ (assert gcc-libs.version=="7.4.0"; gcc-libs) binutils gmp isl mpc mpfr msys2-runtime-devel msys2-w32api-headers msys2-w32api-runtime windows-default-manifest ];
  };

  "gcc-fortran" = fetch {
    name        = "gcc-fortran";
    version     = "7.4.0";
    filename    = "gcc-fortran-7.4.0-1-x86_64.pkg.tar.xz";
    sha256      = "d9dc76c6521a19852ccdcf04d5ab90aca3f17f071d0f8c5271183e8caa667f38";
    buildInputs = [ (assert gcc.version=="7.4.0"; gcc) ];
  };

  "gcc-libs" = fetch {
    name        = "gcc-libs";
    version     = "7.4.0";
    filename    = "gcc-libs-7.4.0-1-x86_64.pkg.tar.xz";
    sha256      = "dd86bbe22647a2c8b2556e6ddba54543944f42c1642aa48058e7812aa403a2d5";
    buildInputs = [ msys2-runtime ];
  };

  "gdb" = fetch {
    name        = "gdb";
    version     = "7.12.1";
    filename    = "gdb-7.12.1-1-x86_64.pkg.tar.xz";
    sha256      = "508248d3f4ed45796149b394bf13c9cd0e9feb87273a1a4476f06f5de6bced44";
    buildInputs = [ libiconv zlib expat python2 libexpat libreadline ];
  };

  "gdbm" = fetch {
    name        = "gdbm";
    version     = "1.18.1";
    filename    = "gdbm-1.18.1-1-x86_64.pkg.tar.xz";
    sha256      = "e011d1ccac21a2f602b888fe2076a0978d170f0dac97e033422be08bf2a4d5ba";
    buildInputs = [ (assert libgdbm.version=="1.18.1"; libgdbm) ];
  };

  "gengetopt" = fetch {
    name        = "gengetopt";
    version     = "2.22.6";
    filename    = "gengetopt-2.22.6-3-x86_64.pkg.tar.xz";
    sha256      = "7f9671b23351a2b29012cce1eb93b0ce464d829fa46a6a561410ecca324d0f67";
  };

  "getent" = fetch {
    name        = "getent";
    version     = "2.18.90";
    filename    = "getent-2.18.90-2-x86_64.pkg.tar.xz";
    sha256      = "3aea9e63fbb4f194430d22ba0ffc1aeecb243f0aef78afeabda43471ad326895";
    buildInputs = [ libargp ];
  };

  "getopt" = fetch {
    name        = "getopt";
    version     = "1.1.6";
    filename    = "getopt-1.1.6-1-x86_64.pkg.tar.xz";
    sha256      = "7e1bf432d11f2cd5c6111269efc84c4fd2c5f4dbadd007f87246617878fce121";
    buildInputs = [ msys2-runtime sh ];
  };

  "gettext" = fetch {
    name        = "gettext";
    version     = "0.19.8.1";
    filename    = "gettext-0.19.8.1-1-x86_64.pkg.tar.xz";
    sha256      = "59d400b4e71e489bbf6e1ce664ca1f38ebe28c8f4d7dd21e5190a0ada1ec5ccd";
    buildInputs = [ libintl libgettextpo libasprintf ];
  };

  "gettext-devel" = fetch {
    name        = "gettext-devel";
    version     = "0.19.8.1";
    filename    = "gettext-devel-0.19.8.1-1-x86_64.pkg.tar.xz";
    sha256      = "c484d03b8a4aa48119f2e8796ab7d159a51ce88aa6cd07c444b86ab724b1a48f";
    buildInputs = [ (assert gettext.version=="0.19.8.1"; gettext) libiconv-devel ];
  };

  "git" = fetch {
    name        = "git";
    version     = "2.20.1";
    filename    = "git-2.20.1-1-x86_64.pkg.tar.xz";
    sha256      = "9878bcb483eaf8fa4fac2908f57f7c16ace4d8577d787c99f69c6af96dbe6064";
    buildInputs = [ curl (assert lib.versionAtLeast expat.version "2.20.1"; expat) libpcre2_8 vim openssh openssl perl-Error (assert lib.versionAtLeast perl.version "2.20.1"; perl) perl-Authen-SASL perl-libwww perl-MIME-tools perl-Net-SMTP-SSL perl-TermReadKey ];
  };

  "git-bzr-ng-git" = fetch {
    name        = "git-bzr-ng-git";
    version     = "r61.9878a30";
    filename    = "git-bzr-ng-git-r61.9878a30-1-any.pkg.tar.xz";
    sha256      = "7f7cb60c7daf50a81ee140a42752689c10bc1eb8b2e2300eb1e97aed51270b15";
    buildInputs = [ python2 git bzr bzr-fastimport ];
  };

  "git-extras-git" = fetch {
    name        = "git-extras-git";
    version     = "4.3.0";
    filename    = "git-extras-git-4.3.0-1-any.pkg.tar.xz";
    sha256      = "1b67be86d5d68e0bfcca3851e8b7ab14f1121376d636f73c3b7de28193182829";
    buildInputs = [ git ];
  };

  "git-flow" = fetch {
    name        = "git-flow";
    version     = "1.11.0";
    filename    = "git-flow-1.11.0-1-x86_64.pkg.tar.xz";
    sha256      = "2f66c1c84267b6dfa6222bf26f0cfc055c144db361d30311991da8ebe87f7c35";
    buildInputs = [ git util-linux ];
  };

  "glib2" = fetch {
    name        = "glib2";
    version     = "2.54.3";
    filename    = "glib2-2.54.3-1-x86_64.pkg.tar.xz";
    sha256      = "0107bfbed3ff4ddb6352b6e2c56755267fbd0711148716e8e7fbab848b688e1b";
    buildInputs = [ libxslt libpcre libffi libiconv zlib ];
  };

  "glib2-devel" = fetch {
    name        = "glib2-devel";
    version     = "2.54.3";
    filename    = "glib2-devel-2.54.3-1-x86_64.pkg.tar.xz";
    sha256      = "9f9c9963bb74a815f94679c1116e1487695e1629c7c9c9c5a42fc266d9599a05";
    buildInputs = [ (assert glib2.version=="2.54.3"; glib2) pcre-devel libffi-devel libiconv-devel zlib-devel ];
  };

  "glib2-docs" = fetch {
    name        = "glib2-docs";
    version     = "2.54.3";
    filename    = "glib2-docs-2.54.3-1-x86_64.pkg.tar.xz";
    sha256      = "7d83ed58fdb371f2c687a9c4472fba080ced3a26d2df74984f22bef6da49f7e7";
  };

  "global" = fetch {
    name        = "global";
    version     = "6.6.3";
    filename    = "global-6.6.3-1-x86_64.pkg.tar.xz";
    sha256      = "be8ad4242dd0b56b3568a92a13ed622bf659db75dedf38d44bb5e35f1090a592";
    buildInputs = [ libltdl ];
  };

  "gmp" = fetch {
    name        = "gmp";
    version     = "6.1.2";
    filename    = "gmp-6.1.2-1-x86_64.pkg.tar.xz";
    sha256      = "42582db3cc8c5b8ef564ed64f076922fc67e65c51b7fb583daf117b0aea2c154";
    buildInputs = [  ];
  };

  "gmp-devel" = fetch {
    name        = "gmp-devel";
    version     = "6.1.2";
    filename    = "gmp-devel-6.1.2-1-x86_64.pkg.tar.xz";
    sha256      = "16d030821d7c5bf416efd007e561daf29d06377540ae4f4c19cebf1455b83afd";
    buildInputs = [ (assert gmp.version=="6.1.2"; gmp) ];
  };

  "gnome-doc-utils" = fetch {
    name        = "gnome-doc-utils";
    version     = "0.20.10";
    filename    = "gnome-doc-utils-0.20.10-1-any.pkg.tar.xz";
    sha256      = "155746de7fafa3d12fec3b06ad5cf714ac1036428189fd74fb51e94924ffe856";
    buildInputs = [ libxslt python2 docbook-xml rarian ];
  };

  "gnu-netcat" = fetch {
    name        = "gnu-netcat";
    version     = "0.7.1";
    filename    = "gnu-netcat-0.7.1-1-x86_64.pkg.tar.xz";
    sha256      = "32fa739d26fd49a3f8c22717ae338472d71d4798844cbc0db5e7780131fe69aa";
    buildInputs = [ info ];
  };

  "gnupg" = fetch {
    name        = "gnupg";
    version     = "2.2.12";
    filename    = "gnupg-2.2.12-1-x86_64.pkg.tar.xz";
    sha256      = "0d4714d33a4e8947582386753f8d6354341ff5d03ac00de9d35c6eb82b6c4e94";
    buildInputs = [ bzip2 libassuan libbz2 libcurl libgcrypt libgpg-error libgnutls libiconv libintl libksba libnpth libreadline libsqlite nettle pinentry zlib ];
  };

  "gnutls" = fetch {
    name        = "gnutls";
    version     = "3.6.5";
    filename    = "gnutls-3.6.5-1-x86_64.pkg.tar.xz";
    sha256      = "084748721749d9b682023542fd3200780f0d0a78be90fcc6a084e8a60d17f1bf";
    buildInputs = [ (assert libgnutls.version=="3.6.5"; libgnutls) ];
  };

  "gperf" = fetch {
    name        = "gperf";
    version     = "3.1";
    filename    = "gperf-3.1-1-x86_64.pkg.tar.xz";
    sha256      = "ef1ef9c37f68fec3768e3d58c99cc9f24e70066e6ec111e839f2ca5c1cd2157a";
    buildInputs = [ gcc-libs info ];
  };

  "gradle" = fetch {
    name        = "gradle";
    version     = "5.0";
    filename    = "gradle-5.0-1-any.pkg.tar.xz";
    sha256      = "685df0c9a95d2398d28f2ae5cfff3bd6b1e45394cf884b62043c512dbe616621";
  };

  "gradle-doc" = fetch {
    name        = "gradle-doc";
    version     = "5.0";
    filename    = "gradle-doc-5.0-1-any.pkg.tar.xz";
    sha256      = "2979daba337b84612495daf3aa9e1479493726346022d269adf1f6355bb81a38";
  };

  "grep" = fetch {
    name        = "grep";
    version     = "3.0";
    filename    = "grep-3.0-2-x86_64.pkg.tar.xz";
    sha256      = "21ef642593ca3e8a5bb70c0ccf3856e550ced9e5d2bcdca0c09a3326ed0fa05e";
    buildInputs = [ libiconv libintl libpcre sh ];
  };

  "grml-zsh-config" = fetch {
    name        = "grml-zsh-config";
    version     = "0.15.2";
    filename    = "grml-zsh-config-0.15.2-1-any.pkg.tar.xz";
    sha256      = "234181297d69cf3711fe53173e06a6fb265d0151340398b5eb5767ef897aba2b";
    buildInputs = [ zsh coreutils inetutils grep sed procps ];
  };

  "groff" = fetch {
    name        = "groff";
    version     = "1.22.3";
    filename    = "groff-1.22.3-1-x86_64.pkg.tar.xz";
    sha256      = "7b9d558d1f38d8582d07da46b10bf94b0092919c376f6f059029f413d1eec1be";
    buildInputs = [ perl gcc-libs ];
  };

  "gtk-doc" = fetch {
    name        = "gtk-doc";
    version     = "1.29";
    filename    = "gtk-doc-1.29-1-x86_64.pkg.tar.xz";
    sha256      = "606eabc4a42150910c7701b77e743dc1c2ed0415f28e24f3dac373de991f974a";
    buildInputs = [ docbook-xsl glib2 gnome-doc-utils libxml2-python python3 vim yelp-tools python2-six ];
    broken      = true;
  };

  "guile" = fetch {
    name        = "guile";
    version     = "2.2.4";
    filename    = "guile-2.2.4-2-x86_64.pkg.tar.xz";
    sha256      = "dc1b32b83c6d2434808693bb9227baa92401a8e89cdcf4859e0844c6dce39e4e";
    buildInputs = [ (assert libguile.version=="2.2.4"; libguile) info ];
  };

  "gyp-git" = fetch {
    name        = "gyp-git";
    version     = "r2114.a2738d85";
    filename    = "gyp-git-r2114.a2738d85-1-x86_64.pkg.tar.xz";
    sha256      = "6b40b83aea5d35fe9bcde10bd4310544bb8053756a5888ad171e3738d142e12d";
    buildInputs = [ python2 python2-setuptools ];
  };

  "gzip" = fetch {
    name        = "gzip";
    version     = "1.9";
    filename    = "gzip-1.9-1-x86_64.pkg.tar.xz";
    sha256      = "b466010fd98a45d508bdf3b3c248ba620533b2d24c056263b2ed1b94c7b569e8";
    buildInputs = [ msys2-runtime bash less ];
  };

  "heimdal" = fetch {
    name        = "heimdal";
    version     = "7.5.0";
    filename    = "heimdal-7.5.0-3-x86_64.pkg.tar.xz";
    sha256      = "27a21844796a7272275f327ea9fb8045fbf0226ade9b7725e001facd923b6180";
    buildInputs = [ heimdal-libs ];
  };

  "heimdal-devel" = fetch {
    name        = "heimdal-devel";
    version     = "7.5.0";
    filename    = "heimdal-devel-7.5.0-3-x86_64.pkg.tar.xz";
    sha256      = "916c5ff10126bcabf7c02f8492cd3228f9e110e31c0e25a38ccff277ab5ba1e0";
    buildInputs = [ heimdal-libs libcrypt-devel libedit-devel libdb-devel libsqlite-devel ];
  };

  "heimdal-libs" = fetch {
    name        = "heimdal-libs";
    version     = "7.5.0";
    filename    = "heimdal-libs-7.5.0-3-x86_64.pkg.tar.xz";
    sha256      = "6cb684ab0172b36952a6feb181556c4390f54ee7593f03e5b5e0fe1c75e92f06";
    buildInputs = [ libdb libcrypt libedit libsqlite libopenssl ];
  };

  "help2man" = fetch {
    name        = "help2man";
    version     = "1.47.8";
    filename    = "help2man-1.47.8-1-x86_64.pkg.tar.xz";
    sha256      = "5236c051cd89fcfb372dadc293cbf05e64e5ca65988557d71358e947dc245800";
    buildInputs = [ perl-Locale-Gettext libintl ];
  };

  "hexcurse" = fetch {
    name        = "hexcurse";
    version     = "1.60.0";
    filename    = "hexcurse-1.60.0-1-x86_64.pkg.tar.xz";
    sha256      = "989f2a72d182463f6ebf02901618ac670ba963b02e8a0d0f8e8e762c34cb666e";
    buildInputs = [ ncurses ];
  };

  "icmake" = fetch {
    name        = "icmake";
    version     = "9.02.08";
    filename    = "icmake-9.02.08-1-x86_64.pkg.tar.xz";
    sha256      = "5ba63a859288c91adcdb63fad1f9e9b3ca10ab7e04091f01e7a9f63473edf6f0";
  };

  "icon-naming-utils" = fetch {
    name        = "icon-naming-utils";
    version     = "0.8.90";
    filename    = "icon-naming-utils-0.8.90-1-x86_64.pkg.tar.xz";
    sha256      = "392cd439d442da3d51dd478cafd9c141e8074a53ab28dc3496611bb9985170aa";
    buildInputs = [ perl-XML-Simple ];
  };

  "icu" = fetch {
    name        = "icu";
    version     = "62.1";
    filename    = "icu-62.1-1-x86_64.pkg.tar.xz";
    sha256      = "4fe5909f5327a17569925981f88ed7ab791d40c23e233faf0b145372780f861e";
    buildInputs = [ gcc-libs ];
  };

  "icu-devel" = fetch {
    name        = "icu-devel";
    version     = "62.1";
    filename    = "icu-devel-62.1-1-x86_64.pkg.tar.xz";
    sha256      = "7ef53ffc38cb8346d4bd9a1b265b3cff072a9103e0c16bbaf5c9d8d43d57c0e2";
    buildInputs = [ (assert icu.version=="62.1"; icu) ];
  };

  "idutils" = fetch {
    name        = "idutils";
    version     = "4.6";
    filename    = "idutils-4.6-2-x86_64.pkg.tar.xz";
    sha256      = "dc84aa53e5cd69f98929c5f42129187e1cf5845035d33c148e2f1b512d2549e2";
  };

  "inetutils" = fetch {
    name        = "inetutils";
    version     = "1.9.4";
    filename    = "inetutils-1.9.4-1-x86_64.pkg.tar.xz";
    sha256      = "6a9be44f1ff409d1b52cf1fc60e86623686fb6fd45c8264dd5e84be380e71e14";
    buildInputs = [ gcc-libs libintl libcrypt libreadline ncurses tftp-hpa ];
  };

  "info" = fetch {
    name        = "info";
    version     = "6.5";
    filename    = "info-6.5-2-x86_64.pkg.tar.xz";
    sha256      = "8ad76bbbce5da83c614033123b88174680a1a9248db41cee1340b8f4ca3b5b59";
    buildInputs = [ gzip libcrypt libintl ncurses ];
  };

  "intltool" = fetch {
    name        = "intltool";
    version     = "0.51.0";
    filename    = "intltool-0.51.0-2-x86_64.pkg.tar.xz";
    sha256      = "1e8e894ab102eede0d703908c0d678a28f95f10a3fcb79fd2e4312392019ecb5";
    buildInputs = [ perl-XML-Parser ];
  };

  "iperf" = fetch {
    name        = "iperf";
    version     = "2.0.12";
    filename    = "iperf-2.0.12-1-x86_64.pkg.tar.xz";
    sha256      = "7d136f09042aeb985f3d133f8073fd45e3327cec9acbeaaa9939aff9cba6a3b4";
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "iperf3" = fetch {
    name        = "iperf3";
    version     = "3.6";
    filename    = "iperf3-3.6-3-x86_64.pkg.tar.xz";
    sha256      = "70def9ec9efb8284073d5681b57296cad9b5af588e0f4c5652d8dacf70c1d0a1";
    buildInputs = [ msys2-runtime gcc-libs openssl ];
  };

  "irssi" = fetch {
    name        = "irssi";
    version     = "1.1.1";
    filename    = "irssi-1.1.1-2-x86_64.pkg.tar.xz";
    sha256      = "b2730fc86a51d910dfcbccb78cb749ab93830267a6bc99da455ead4952927d50";
    buildInputs = [ openssl gettext perl ncurses glib2 ];
  };

  "isl" = fetch {
    name        = "isl";
    version     = "0.19";
    filename    = "isl-0.19-1-x86_64.pkg.tar.xz";
    sha256      = "bff7dc5719de9e94a6328585eb20f6331eb8fb63424858ddd424dbb6065bda4b";
    buildInputs = [ gmp ];
  };

  "isl-devel" = fetch {
    name        = "isl-devel";
    version     = "0.19";
    filename    = "isl-devel-0.19-1-x86_64.pkg.tar.xz";
    sha256      = "b1cab205f9b8a759d3b56401aec1af151d7aaa78a5a10220e5629d3bda9ee5f2";
    buildInputs = [ (assert isl.version=="0.19"; isl) gmp-devel ];
  };

  "itstool" = fetch {
    name        = "itstool";
    version     = "2.0.4";
    filename    = "itstool-2.0.4-2-x86_64.pkg.tar.xz";
    sha256      = "cdde4afe6719740dcee32dbe2d060474ca060100e906c9bf0c2f63643978c995";
    buildInputs = [ python2 libxml2 libxml2-python ];
  };

  "jansson" = fetch {
    name        = "jansson";
    version     = "2.12";
    filename    = "jansson-2.12-1-x86_64.pkg.tar.xz";
    sha256      = "a8b171a3af8a5cab39f73d4b259acee6d0d7ba00b336fa752bb1e46a9aa1f645";
  };

  "jansson-devel" = fetch {
    name        = "jansson-devel";
    version     = "2.12";
    filename    = "jansson-devel-2.12-1-x86_64.pkg.tar.xz";
    sha256      = "11dfbfb84c289c94cca83bc5c69ac76ccf6e02b7c58652eba6f8035fa8248cd0";
    buildInputs = [ (assert jansson.version=="2.12"; jansson) ];
  };

  "jhbuild-git" = fetch {
    name        = "jhbuild-git";
    version     = "9425.76669ac0";
    filename    = "jhbuild-git-9425.76669ac0-1-x86_64.pkg.tar.xz";
    sha256      = "1c4893b40610807660c82f82ffc7e5cc12c95c8b55389ab392e84cac67f0ac2e";
    buildInputs = [ python2 ];
  };

  "jsoncpp" = fetch {
    name        = "jsoncpp";
    version     = "1.8.4";
    filename    = "jsoncpp-1.8.4-1-any.pkg.tar.xz";
    sha256      = "b6b5b4706a068f4f0a0139abe462875476fa6acafa966a58a32cb61e5b1df077";
    buildInputs = [ gcc-libs ];
  };

  "jsoncpp-devel" = fetch {
    name        = "jsoncpp-devel";
    version     = "1.8.4";
    filename    = "jsoncpp-devel-1.8.4-1-any.pkg.tar.xz";
    sha256      = "9c6db832da1a86e42daff063129e6e2a30851edd7b40ba29adebdc24ed13dc45";
    buildInputs = [ (assert jsoncpp.version=="1.8.4"; jsoncpp) ];
  };

  "lemon" = fetch {
    name        = "lemon";
    version     = "3.21.0";
    filename    = "lemon-3.21.0-1-x86_64.pkg.tar.xz";
    sha256      = "f450103ad1654a025d970d9c28b76796ac624f6445961e50078bfd54a29d0df3";
    buildInputs = [ gcc-libs ];
  };

  "less" = fetch {
    name        = "less";
    version     = "530";
    filename    = "less-530-1-x86_64.pkg.tar.xz";
    sha256      = "01bed7a3ed32e329f4dce044df38bc6cee6083e8b093c1cb99b7b9aa8bd9081d";
    buildInputs = [ ncurses libpcre ];
  };

  "lftp" = fetch {
    name        = "lftp";
    version     = "4.8.4";
    filename    = "lftp-4.8.4-1-x86_64.pkg.tar.xz";
    sha256      = "78252e445594a0a1719a6cc32d016104895d912192769afb85558eb64b1f7446";
    buildInputs = [ gcc-libs ca-certificates expat gettext libexpat libgnutls libiconv libidn2 libintl libreadline libunistring openssh zlib ];
  };

  "libarchive" = fetch {
    name        = "libarchive";
    version     = "3.3.3";
    filename    = "libarchive-3.3.3-3-x86_64.pkg.tar.xz";
    sha256      = "ea5d7609bd261cf1ece4b0881e5b691f36efc0021b91bef53146e7403eda209e";
    buildInputs = [ gcc-libs libbz2 libiconv libexpat liblzma liblz4 liblzo2 libnettle libxml2 zlib ];
  };

  "libarchive-devel" = fetch {
    name        = "libarchive-devel";
    version     = "3.3.3";
    filename    = "libarchive-devel-3.3.3-3-x86_64.pkg.tar.xz";
    sha256      = "f64ddfb3b85f331b988845c9cde58f12af940867322ac084692d4c98b496acbf";
    buildInputs = [ (assert libarchive.version=="3.3.3"; libarchive) libbz2-devel libiconv-devel liblzma-devel liblz4-devel liblzo2-devel libnettle-devel libxml2-devel zlib-devel ];
  };

  "libargp" = fetch {
    name        = "libargp";
    version     = "20110921";
    filename    = "libargp-20110921-2-x86_64.pkg.tar.xz";
    sha256      = "4d0d66c0bcc8c19b5d58245449d0b0d428e96d94db26462bd2662ca9d5bc61b0";
    buildInputs = [  ];
  };

  "libargp-devel" = fetch {
    name        = "libargp-devel";
    version     = "20110921";
    filename    = "libargp-devel-20110921-2-x86_64.pkg.tar.xz";
    sha256      = "160d82b2067a147599bd75a19d58d9818dfbebe8ec938ba5f8f378783d36137c";
    buildInputs = [ (assert libargp.version=="20110921"; libargp) ];
  };

  "libasprintf" = fetch {
    name        = "libasprintf";
    version     = "0.19.8.1";
    filename    = "libasprintf-0.19.8.1-1-x86_64.pkg.tar.xz";
    sha256      = "bcf2d52192741590c5f0fd98fa9192f1c1243f67f06fe838b914cf9bce3ed99f";
    buildInputs = [ gcc-libs ];
  };

  "libassuan" = fetch {
    name        = "libassuan";
    version     = "2.5.2";
    filename    = "libassuan-2.5.2-1-x86_64.pkg.tar.xz";
    sha256      = "ab03785281b41f923e34aa3c3e1acb49ce5a384e7ec99c45dd758665ba2437df";
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libassuan-devel" = fetch {
    name        = "libassuan-devel";
    version     = "2.5.2";
    filename    = "libassuan-devel-2.5.2-1-x86_64.pkg.tar.xz";
    sha256      = "dff04e98d0f7270babc8f98ef431a398ba191f9836290f0fddcf66a980a7a54e";
    buildInputs = [ (assert libassuan.version=="2.5.2"; libassuan) libgpg-error-devel ];
  };

  "libatomic_ops" = fetch {
    name        = "libatomic_ops";
    version     = "7.6.8";
    filename    = "libatomic_ops-7.6.8-1-any.pkg.tar.xz";
    sha256      = "f6cd8a37401f881799ac749eaad48b296453a81a78a953899b53a99803c40d19";
    buildInputs = [  ];
  };

  "libatomic_ops-devel" = fetch {
    name        = "libatomic_ops-devel";
    version     = "7.6.8";
    filename    = "libatomic_ops-devel-7.6.8-1-any.pkg.tar.xz";
    sha256      = "90b48ad2ef5df6ead549fe98f9e051a0748796453b6db4f7ae7ed2fae910e975";
    buildInputs = [ (assert libatomic_ops.version=="7.6.8"; libatomic_ops) ];
  };

  "libbobcat" = fetch {
    name        = "libbobcat";
    version     = "4.08.03";
    filename    = "libbobcat-4.08.03-1-x86_64.pkg.tar.xz";
    sha256      = "2eecd7a4d3387c2ecde9a3f093b12d0d0b1ed0794737f9491e6be21d6c6d90d9";
    buildInputs = [ gcc-libs ];
  };

  "libbobcat-devel" = fetch {
    name        = "libbobcat-devel";
    version     = "4.08.03";
    filename    = "libbobcat-devel-4.08.03-1-x86_64.pkg.tar.xz";
    sha256      = "72ef455cda101e67f629a623a9e2ab87197afab9c4743279f1416307ef2c1066";
    buildInputs = [ (assert libbobcat.version=="4.08.03"; libbobcat) ];
  };

  "libbz2" = fetch {
    name        = "libbz2";
    version     = "1.0.6";
    filename    = "libbz2-1.0.6-2-x86_64.pkg.tar.xz";
    sha256      = "95c55a03f45f238ff8da8730c7dd296f789c6a00cf967a617a98b6658e2e563e";
    buildInputs = [ gcc-libs ];
  };

  "libbz2-devel" = fetch {
    name        = "libbz2-devel";
    version     = "1.0.6";
    filename    = "libbz2-devel-1.0.6-2-x86_64.pkg.tar.xz";
    sha256      = "4a1cc61531492fd0291ef38eeb570538ce9b649f455110e5c6d142ab6b287911";
    buildInputs = [ (assert libbz2.version=="1.0.6"; libbz2) ];
  };

  "libcares" = fetch {
    name        = "libcares";
    version     = "1.15.0";
    filename    = "libcares-1.15.0-1-x86_64.pkg.tar.xz";
    sha256      = "d4f8273bfec01879a142b16431304400ca5435a2ed7715c5bcb8cf4a5298f2b9";
    buildInputs = [ gcc-libs ];
  };

  "libcares-devel" = fetch {
    name        = "libcares-devel";
    version     = "1.15.0";
    filename    = "libcares-devel-1.15.0-1-x86_64.pkg.tar.xz";
    sha256      = "e7e58e4ea1dc378095bb3c4f342e77547fb05c6258f9fe58732d1beec3b312d9";
    buildInputs = [ (assert libcares.version=="1.15.0"; libcares) ];
  };

  "libcrypt" = fetch {
    name        = "libcrypt";
    version     = "2.1";
    filename    = "libcrypt-2.1-2-x86_64.pkg.tar.xz";
    sha256      = "333b5089ea0d27c167e7bcf786bf0ceb2192d76c18f338379d771adda18bda3e";
    buildInputs = [ gcc-libs ];
  };

  "libcrypt-devel" = fetch {
    name        = "libcrypt-devel";
    version     = "2.1";
    filename    = "libcrypt-devel-2.1-2-x86_64.pkg.tar.xz";
    sha256      = "424348d6ccb542f072598f32321ea48df62481f0a7ee48060694df58dbbcaeda";
    buildInputs = [ (assert libcrypt.version=="2.1"; libcrypt) ];
  };

  "libcurl" = fetch {
    name        = "libcurl";
    version     = "7.63.0";
    filename    = "libcurl-7.63.0-1-x86_64.pkg.tar.xz";
    sha256      = "c2b6b36389551f7dba17203dde24ab3a85a1f56a9a336f289df9c17ec10fbf5a";
    buildInputs = [ brotli ca-certificates heimdal-libs libcrypt libidn2 libmetalink libnghttp2 libpsl libssh2 openssl zlib ];
  };

  "libcurl-devel" = fetch {
    name        = "libcurl-devel";
    version     = "7.63.0";
    filename    = "libcurl-devel-7.63.0-1-x86_64.pkg.tar.xz";
    sha256      = "0ab22842ff4784aac280f333645698ee7af194ac02a2072fe084607311b02800";
    buildInputs = [ (assert libcurl.version=="7.63.0"; libcurl) brotli-devel heimdal-devel libcrypt-devel libidn2-devel libmetalink-devel libnghttp2-devel libpsl-devel libssh2-devel openssl-devel zlib-devel ];
  };

  "libdb" = fetch {
    name        = "libdb";
    version     = "5.3.28";
    filename    = "libdb-5.3.28-2-x86_64.pkg.tar.xz";
    sha256      = "2e96a2883d56a3909938ac160c2922e30cd7edb1fe733b8452bb24fbf7ec09a7";
    buildInputs = [ gcc-libs msys2-runtime ];
  };

  "libdb-devel" = fetch {
    name        = "libdb-devel";
    version     = "5.3.28";
    filename    = "libdb-devel-5.3.28-2-x86_64.pkg.tar.xz";
    sha256      = "c0b993d02983a4f55f4fee73d5e3ea02681c2e3ce95d45253afeca44748a0418";
    buildInputs = [ (assert libdb.version=="5.3.28"; libdb) ];
  };

  "libedit" = fetch {
    name        = "libedit";
    version     = "3.1";
    filename    = "libedit-3.1-20170329-x86_64.pkg.tar.xz";
    sha256      = "609221c599e437d4b7bd49d0b79a9292be74f03ed4f0214cb1fd8062d0af9803";
    buildInputs = [ msys2-runtime ncurses sh ];
  };

  "libedit-devel" = fetch {
    name        = "libedit-devel";
    version     = "3.1";
    filename    = "libedit-devel-3.1-20170329-x86_64.pkg.tar.xz";
    sha256      = "4ed64a24cab940133b0598705dbd203cefa38d64466c493e5ed0135ab0135ca1";
    buildInputs = [ (assert libedit.version=="3.1"; libedit) ncurses-devel ];
  };

  "libelf" = fetch {
    name        = "libelf";
    version     = "0.8.13";
    filename    = "libelf-0.8.13-2-x86_64.pkg.tar.xz";
    sha256      = "d9c8369c00ae9b281f37bd3700aed599f3b2f31cfbabe5d83a0c9b44621ab4b9";
    buildInputs = [ gcc-libs ];
  };

  "libelf-devel" = fetch {
    name        = "libelf-devel";
    version     = "0.8.13";
    filename    = "libelf-devel-0.8.13-2-x86_64.pkg.tar.xz";
    sha256      = "3af95efcdf6b13f6265b5a56efd960dae406b092dfd7b1a05df6a4f8992666e3";
    buildInputs = [ (assert libelf.version=="0.8.13"; libelf) ];
  };

  "libevent" = fetch {
    name        = "libevent";
    version     = "2.1.8";
    filename    = "libevent-2.1.8-2-x86_64.pkg.tar.xz";
    sha256      = "6b1e07d0ad17d5ec29242321276a1abb1654322a1460920ec963872b4024cdd7";
    buildInputs = [ openssl ];
  };

  "libevent-devel" = fetch {
    name        = "libevent-devel";
    version     = "2.1.8";
    filename    = "libevent-devel-2.1.8-2-x86_64.pkg.tar.xz";
    sha256      = "66681f8e60e6643dd4e7d7a136cc4400e8b42dedfa3a03a0f90368f701ae6dc1";
    buildInputs = [ (assert libevent.version=="2.1.8"; libevent) openssl-devel ];
  };

  "libexpat" = fetch {
    name        = "libexpat";
    version     = "2.2.6";
    filename    = "libexpat-2.2.6-1-x86_64.pkg.tar.xz";
    sha256      = "542da3234964825c34113eda3f8b1d79c63ee3b9282b365d2ffd8240a2b97957";
    buildInputs = [ gcc-libs ];
  };

  "libexpat-devel" = fetch {
    name        = "libexpat-devel";
    version     = "2.2.6";
    filename    = "libexpat-devel-2.2.6-1-x86_64.pkg.tar.xz";
    sha256      = "f08c3b32ec9cd79cd8995349a8ac8e9610832914b2e46bcad07b63867786a592";
    buildInputs = [ (assert libexpat.version=="2.2.6"; libexpat) ];
  };

  "libffi" = fetch {
    name        = "libffi";
    version     = "3.2.1";
    filename    = "libffi-3.2.1-3-x86_64.pkg.tar.xz";
    sha256      = "85bb2408a0b3bcdb521d3d41b235224e37a4c88eeaf77ac456475a53b64017b6";
    buildInputs = [  ];
  };

  "libffi-devel" = fetch {
    name        = "libffi-devel";
    version     = "3.2.1";
    filename    = "libffi-devel-3.2.1-3-x86_64.pkg.tar.xz";
    sha256      = "4d9524bde1ecdbfcd66c04dbfb7a4ac13f6379bb8b7cd9ace718406d5a75db39";
    buildInputs = [ (assert libffi.version=="3.2.1"; libffi) ];
  };

  "libgc" = fetch {
    name        = "libgc";
    version     = "7.6.8";
    filename    = "libgc-7.6.8-1-x86_64.pkg.tar.xz";
    sha256      = "4d396dc9aadae2dc268b9ba33234f67230f82938917ea63eaf441c687f947d16";
    buildInputs = [ libatomic_ops gcc-libs ];
  };

  "libgc-devel" = fetch {
    name        = "libgc-devel";
    version     = "7.6.8";
    filename    = "libgc-devel-7.6.8-1-x86_64.pkg.tar.xz";
    sha256      = "e33c8ee6ce7c8308f8d0782b2599a38172dbea5dda831d37053379ad18d564c3";
    buildInputs = [ (assert libgc.version=="7.6.8"; libgc) libatomic_ops-devel ];
  };

  "libgcrypt" = fetch {
    name        = "libgcrypt";
    version     = "1.8.4";
    filename    = "libgcrypt-1.8.4-1-x86_64.pkg.tar.xz";
    sha256      = "23fbe7c52f6d6a3acf11f334925bc71f4b204e566b8f2d2f7e4c5f18194f19a1";
    buildInputs = [ libgpg-error ];
  };

  "libgcrypt-devel" = fetch {
    name        = "libgcrypt-devel";
    version     = "1.8.4";
    filename    = "libgcrypt-devel-1.8.4-1-x86_64.pkg.tar.xz";
    sha256      = "f15dd58e4a1d10c818cfd75f561ff64a8b92a51073713b1fa76a52ebec96b4c1";
    buildInputs = [ (assert libgcrypt.version=="1.8.4"; libgcrypt) libgpg-error-devel ];
  };

  "libgdbm" = fetch {
    name        = "libgdbm";
    version     = "1.18.1";
    filename    = "libgdbm-1.18.1-1-x86_64.pkg.tar.xz";
    sha256      = "e178c5083e7d9f0eb706febf0998b59a03aa2f1b1cb16db3f95bcc8f78568fb9";
    buildInputs = [ gcc-libs libreadline ];
  };

  "libgdbm-devel" = fetch {
    name        = "libgdbm-devel";
    version     = "1.18.1";
    filename    = "libgdbm-devel-1.18.1-1-x86_64.pkg.tar.xz";
    sha256      = "18157dbd1b77c797678535e4ca5e0f5dad2bfc54e83516c92c8b47cd340b02dd";
    buildInputs = [ (assert libgdbm.version=="1.18.1"; libgdbm) libreadline-devel ];
  };

  "libgettextpo" = fetch {
    name        = "libgettextpo";
    version     = "0.19.8.1";
    filename    = "libgettextpo-0.19.8.1-1-x86_64.pkg.tar.xz";
    sha256      = "7ce26ed0d71395a1fb1b1813be8e2bbc2e05f06fb45645c59c305841ba0d10e2";
    buildInputs = [ gcc-libs ];
  };

  "libgnutls" = fetch {
    name        = "libgnutls";
    version     = "3.6.5";
    filename    = "libgnutls-3.6.5-1-x86_64.pkg.tar.xz";
    sha256      = "ed68b56950c0a3e1995156bad89a4478faaf8cbfa4afcace9fb293643c0cecdb";
    buildInputs = [ gcc-libs libidn2 libiconv libintl gmp libnettle libp11-kit libtasn1 zlib ];
  };

  "libgnutls-devel" = fetch {
    name        = "libgnutls-devel";
    version     = "3.6.5";
    filename    = "libgnutls-devel-3.6.5-1-x86_64.pkg.tar.xz";
    sha256      = "e989a06f48c4bfa18e4ced807ce432aeb48a800bdc71fd7c73f12683b395be4a";
    buildInputs = [ (assert libgnutls.version=="3.6.5"; libgnutls) ];
  };

  "libgpg-error" = fetch {
    name        = "libgpg-error";
    version     = "1.33";
    filename    = "libgpg-error-1.33-1-x86_64.pkg.tar.xz";
    sha256      = "0a5995d1370bbc80ddedc9fa67ac238ed201aa65e3fc664ef3ebf0ec18d439bb";
    buildInputs = [ msys2-runtime sh libiconv libintl ];
  };

  "libgpg-error-devel" = fetch {
    name        = "libgpg-error-devel";
    version     = "1.33";
    filename    = "libgpg-error-devel-1.33-1-x86_64.pkg.tar.xz";
    sha256      = "641221285f7b8c9451ba99d91bf7a9672f4a126576999ba57463114049a15cae";
    buildInputs = [ libiconv-devel gettext-devel ];
  };

  "libgpgme" = fetch {
    name        = "libgpgme";
    version     = "1.12.0";
    filename    = "libgpgme-1.12.0-1-x86_64.pkg.tar.xz";
    sha256      = "47933d0a83b5f82c97e36d9f9d5c94a5dd9e6c75d9d3a6197016b56dd0d91447";
    buildInputs = [ libassuan libgpg-error gnupg ];
  };

  "libgpgme-devel" = fetch {
    name        = "libgpgme-devel";
    version     = "1.12.0";
    filename    = "libgpgme-devel-1.12.0-1-x86_64.pkg.tar.xz";
    sha256      = "e9de7ee0f7eab75bc5c648b742a6b3d4c69ed3627d9c74ef4e20d0e88ad894ee";
    buildInputs = [ (assert libgpgme.version=="1.12.0"; libgpgme) libassuan-devel libgpg-error-devel ];
  };

  "libgpgme-python2" = fetch {
    name        = "libgpgme-python2";
    version     = "1.12.0";
    filename    = "libgpgme-python2-1.12.0-1-x86_64.pkg.tar.xz";
    sha256      = "73e388555d73ca74f610b447a932518ff6456436da3fe4a8b946affe09025ef1";
    buildInputs = [ (assert libgpgme.version=="1.12.0"; libgpgme) python2 ];
  };

  "libgpgme-python3" = fetch {
    name        = "libgpgme-python3";
    version     = "1.12.0";
    filename    = "libgpgme-python3-1.12.0-1-x86_64.pkg.tar.xz";
    sha256      = "08ec28110d00c9cf04105709fe6d09ba1b8e457603ff7c89087a91d317fe94a2";
    buildInputs = [ (assert libgpgme.version=="1.12.0"; libgpgme) python3 ];
    broken      = true;
  };

  "libguile" = fetch {
    name        = "libguile";
    version     = "2.2.4";
    filename    = "libguile-2.2.4-2-x86_64.pkg.tar.xz";
    sha256      = "6a010d2ee8c3f030da74353e389c86e87bce1ec667472cac4a4124538a768a38";
    buildInputs = [ gmp libltdl ncurses libunistring libgc libffi ];
  };

  "libguile-devel" = fetch {
    name        = "libguile-devel";
    version     = "2.2.4";
    filename    = "libguile-devel-2.2.4-2-x86_64.pkg.tar.xz";
    sha256      = "f7fb380ce54d18287128b70bc1c49ec93fe3a7242fc3568a0ea3d22383b812ce";
    buildInputs = [ (assert libguile.version=="2.2.4"; libguile) ];
  };

  "libhogweed" = fetch {
    name        = "libhogweed";
    version     = "3.4.1";
    filename    = "libhogweed-3.4.1-1-x86_64.pkg.tar.xz";
    sha256      = "b8878e623627fea9114cc31cbcf3ff0ce3785f29475fd22bcae99f658e58c826";
    buildInputs = [ gmp ];
  };

  "libiconv" = fetch {
    name        = "libiconv";
    version     = "1.15";
    filename    = "libiconv-1.15-1-x86_64.pkg.tar.xz";
    sha256      = "992219dc1476c352cafe9a842835a4a5492e8f896f07e996cc50e5435e0c3c5e";
    buildInputs = [ gcc-libs ];
  };

  "libiconv-devel" = fetch {
    name        = "libiconv-devel";
    version     = "1.15";
    filename    = "libiconv-devel-1.15-1-x86_64.pkg.tar.xz";
    sha256      = "d863a4f988ae3e433a26a33f3ade15aa2268de68f775e8ee8767bb197bc1c2c1";
    buildInputs = [ (assert libiconv.version=="1.15"; libiconv) ];
  };

  "libidn" = fetch {
    name        = "libidn";
    version     = "1.35";
    filename    = "libidn-1.35-1-x86_64.pkg.tar.xz";
    sha256      = "f436d30f6ae1f6c8bc74d456dc3a6d54a4c8abbab9649b2acf020681c12f4095";
    buildInputs = [ info ];
  };

  "libidn-devel" = fetch {
    name        = "libidn-devel";
    version     = "1.35";
    filename    = "libidn-devel-1.35-1-x86_64.pkg.tar.xz";
    sha256      = "711c69fb1a62627b1088f1c6b58c705c89f586dabb36cbfce10ec77d790a7019";
    buildInputs = [ (assert libidn.version=="1.35"; libidn) ];
  };

  "libidn2" = fetch {
    name        = "libidn2";
    version     = "2.0.5";
    filename    = "libidn2-2.0.5-1-x86_64.pkg.tar.xz";
    sha256      = "ab96be8e02d7f4bc39a4e25596f1ae194510aeba8e86b4995addcf4632be82c3";
    buildInputs = [ info libunistring ];
  };

  "libidn2-devel" = fetch {
    name        = "libidn2-devel";
    version     = "2.0.5";
    filename    = "libidn2-devel-2.0.5-1-x86_64.pkg.tar.xz";
    sha256      = "bd74b577f4cd61dd2703465bd62694f68462102c77fddb4a27389ac845c16042";
    buildInputs = [ (assert libidn2.version=="2.0.5"; libidn2) ];
  };

  "libintl" = fetch {
    name        = "libintl";
    version     = "0.19.8.1";
    filename    = "libintl-0.19.8.1-1-x86_64.pkg.tar.xz";
    sha256      = "5eadc3cc42da78948d65d994f1f8326706afe011f28e2e5bd0872a37612072d2";
    buildInputs = [ gcc-libs libiconv ];
  };

  "libksba" = fetch {
    name        = "libksba";
    version     = "1.3.5";
    filename    = "libksba-1.3.5-1-x86_64.pkg.tar.xz";
    sha256      = "67a32872737e5d72408ee7e6d059d920b0551837ac5c7f847fa2404b74639a6b";
    buildInputs = [ gcc-libs libgpg-error ];
  };

  "libksba-devel" = fetch {
    name        = "libksba-devel";
    version     = "1.3.5";
    filename    = "libksba-devel-1.3.5-1-x86_64.pkg.tar.xz";
    sha256      = "493ba30889e56cc2b84209849183faf260652a2799ebe0999ff36c23b32e07c3";
    buildInputs = [ (assert libksba.version=="1.3.5"; libksba) libgpg-error-devel ];
  };

  "libltdl" = fetch {
    name        = "libltdl";
    version     = "2.4.6";
    filename    = "libltdl-2.4.6-6-x86_64.pkg.tar.xz";
    sha256      = "d348ae223bd56ba8dddb66e8e19b40947fa62a3dc4841461337f50db3f84465c";
    buildInputs = [  ];
  };

  "liblz4" = fetch {
    name        = "liblz4";
    version     = "1.8.3";
    filename    = "liblz4-1.8.3-1-x86_64.pkg.tar.xz";
    sha256      = "df3b7acb0b90ac538d33ca2b2040f1fd51ee66afd57f2579fd9bc493c3f703a0";
    buildInputs = [ gcc-libs ];
  };

  "liblz4-devel" = fetch {
    name        = "liblz4-devel";
    version     = "1.8.3";
    filename    = "liblz4-devel-1.8.3-1-x86_64.pkg.tar.xz";
    sha256      = "dff5614fe32e0c2f3308c7110b4f4f1f1f79031e8a120647c5309f206d4e774e";
    buildInputs = [ (assert liblz4.version=="1.8.3"; liblz4) ];
  };

  "liblzma" = fetch {
    name        = "liblzma";
    version     = "5.2.4";
    filename    = "liblzma-5.2.4-1-x86_64.pkg.tar.xz";
    sha256      = "a75ad414305596127924d5b0df38844b5097bfad4f7a56c355bd03b312818dad";
    buildInputs = [ sh libiconv gettext ];
  };

  "liblzma-devel" = fetch {
    name        = "liblzma-devel";
    version     = "5.2.4";
    filename    = "liblzma-devel-5.2.4-1-x86_64.pkg.tar.xz";
    sha256      = "a0e1bb4fc59f89b72885a3713ddea253ff2f397963e2ad108c3fe97909973834";
    buildInputs = [ (assert liblzma.version=="5.2.4"; liblzma) libiconv-devel gettext-devel ];
  };

  "liblzo2" = fetch {
    name        = "liblzo2";
    version     = "2.10";
    filename    = "liblzo2-2.10-2-x86_64.pkg.tar.xz";
    sha256      = "f85803aaff60e0bc8c618bed642e15fe7ab1a76acd212d90a8e7c23e076d0ff6";
    buildInputs = [ gcc-libs ];
  };

  "liblzo2-devel" = fetch {
    name        = "liblzo2-devel";
    version     = "2.10";
    filename    = "liblzo2-devel-2.10-2-x86_64.pkg.tar.xz";
    sha256      = "6d2ee9f39c51afa04396e3564bee1a08b9d14e8eab2f14c6e9675ef0cf813c57";
    buildInputs = [ (assert liblzo2.version=="2.10"; liblzo2) ];
  };

  "libmetalink" = fetch {
    name        = "libmetalink";
    version     = "0.1.3";
    filename    = "libmetalink-0.1.3-2-x86_64.pkg.tar.xz";
    sha256      = "c0be5c635768cf04e0cb1b1f4afdb9552368ef0ea665dc516741ed87082f6b4d";
    buildInputs = [ msys2-runtime libexpat sh libxml2 ];
  };

  "libmetalink-devel" = fetch {
    name        = "libmetalink-devel";
    version     = "0.1.3";
    filename    = "libmetalink-devel-0.1.3-2-x86_64.pkg.tar.xz";
    sha256      = "46593ee1fa92ad506e92108c4de23d4d8299f51f59485e1c6d540fc0e08ddeea";
    buildInputs = [ (assert libmetalink.version=="0.1.3"; libmetalink) libexpat-devel ];
  };

  "libneon" = fetch {
    name        = "libneon";
    version     = "0.30.2";
    filename    = "libneon-0.30.2-2-x86_64.pkg.tar.xz";
    sha256      = "beef751229c5e26098d1374267e8409c6a3cc5549c662a6a8dc376e194e4a060";
    buildInputs = [ libexpat openssl ca-certificates ];
  };

  "libneon-devel" = fetch {
    name        = "libneon-devel";
    version     = "0.30.2";
    filename    = "libneon-devel-0.30.2-2-x86_64.pkg.tar.xz";
    sha256      = "3a926d3da481990ef1e75bd09ad1260d8bab28d6c827e3a0bf592d73988a0c11";
    buildInputs = [ (assert libneon.version=="0.30.2"; libneon) libexpat-devel openssl-devel ];
  };

  "libnettle" = fetch {
    name        = "libnettle";
    version     = "3.4.1";
    filename    = "libnettle-3.4.1-1-x86_64.pkg.tar.xz";
    sha256      = "e109962ab63000b1a3ee84db82ba90bbd9f888fcc6f24317c4f87a1815a0c0bd";
    buildInputs = [ libhogweed ];
  };

  "libnettle-devel" = fetch {
    name        = "libnettle-devel";
    version     = "3.4.1";
    filename    = "libnettle-devel-3.4.1-1-x86_64.pkg.tar.xz";
    sha256      = "f4af705509e0ec2375a3bc44add9b2dc9a640fdb1f947afd41e5bf39168445a0";
    buildInputs = [ (assert libnettle.version=="3.4.1"; libnettle) (assert libhogweed.version=="3.4.1"; libhogweed) gmp-devel ];
  };

  "libnghttp2" = fetch {
    name        = "libnghttp2";
    version     = "1.35.1";
    filename    = "libnghttp2-1.35.1-1-x86_64.pkg.tar.xz";
    sha256      = "ba19e0a0d83d4eb85cec7b3ee7708c0431aaa93d49dcaa377af626022f4e8cf5";
    buildInputs = [ gcc-libs ];
  };

  "libnghttp2-devel" = fetch {
    name        = "libnghttp2-devel";
    version     = "1.35.1";
    filename    = "libnghttp2-devel-1.35.1-1-x86_64.pkg.tar.xz";
    sha256      = "a908e0e8c28ad1d007d9ee9fd7ec6bb201cd50cac64b2c68fe96166cc2fb3f92";
    buildInputs = [ (assert libnghttp2.version=="1.35.1"; libnghttp2) jansson-devel libevent-devel openssl-devel libcares-devel ];
  };

  "libnpth" = fetch {
    name        = "libnpth";
    version     = "1.6";
    filename    = "libnpth-1.6-1-x86_64.pkg.tar.xz";
    sha256      = "fe32612e363976dfe157d3a70f8af7aeca4e347abc5294e95cdd3d9a7aea5e68";
    buildInputs = [ gcc-libs ];
  };

  "libnpth-devel" = fetch {
    name        = "libnpth-devel";
    version     = "1.6";
    filename    = "libnpth-devel-1.6-1-x86_64.pkg.tar.xz";
    sha256      = "8325ecaaa04c7e21c461b141e1c3b1d2ac754892a9f6ca9091efe864446789ee";
    buildInputs = [ (assert libnpth.version=="1.6"; libnpth) ];
  };

  "libopenssl" = fetch {
    name        = "libopenssl";
    version     = "1.1.1.a";
    filename    = "libopenssl-1.1.1.a-1-x86_64.pkg.tar.xz";
    sha256      = "bd74afd44a48264a59450f07c6cb1932d21155bbcf257b62ed9211de631d1051";
    buildInputs = [ zlib ];
  };

  "libp11-kit" = fetch {
    name        = "libp11-kit";
    version     = "0.23.14";
    filename    = "libp11-kit-0.23.14-1-x86_64.pkg.tar.xz";
    sha256      = "162b0ad136df959927e8b13e4fa53a30de1e5d01ddb86091bfd4c6ce6a646d42";
    buildInputs = [ libffi libintl libtasn1 glib2 ];
  };

  "libp11-kit-devel" = fetch {
    name        = "libp11-kit-devel";
    version     = "0.23.14";
    filename    = "libp11-kit-devel-0.23.14-1-x86_64.pkg.tar.xz";
    sha256      = "4a8f8623506c6ce9f101fc8941a200cb84f8a783bac9c1360d3340e70b8fb316";
    buildInputs = [ (assert libp11-kit.version=="0.23.14"; libp11-kit) ];
  };

  "libpcre" = fetch {
    name        = "libpcre";
    version     = "8.42";
    filename    = "libpcre-8.42-1-x86_64.pkg.tar.xz";
    sha256      = "78fd9f9a0266b14b73264dfe8ff6cc2970bc06ccfa8f7dd314efa5103b09f4eb";
    buildInputs = [ gcc-libs ];
  };

  "libpcre16" = fetch {
    name        = "libpcre16";
    version     = "8.42";
    filename    = "libpcre16-8.42-1-x86_64.pkg.tar.xz";
    sha256      = "493c08c34f6b573547ca9c6ad28d499123ff16e34ff7bda1acaaaa5097559f83";
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_16" = fetch {
    name        = "libpcre2_16";
    version     = "10.32";
    filename    = "libpcre2_16-10.32-1-x86_64.pkg.tar.xz";
    sha256      = "a402299bfb703c906cf88a337e462e007bff7f7fa17fabc107a3da42b8526b65";
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_32" = fetch {
    name        = "libpcre2_32";
    version     = "10.32";
    filename    = "libpcre2_32-10.32-1-x86_64.pkg.tar.xz";
    sha256      = "9535e7e413e3960bf72c9d915effac4a9943be4f4d53d1d3d7db1401dbf8d9f2";
    buildInputs = [ gcc-libs ];
  };

  "libpcre2_8" = fetch {
    name        = "libpcre2_8";
    version     = "10.32";
    filename    = "libpcre2_8-10.32-1-x86_64.pkg.tar.xz";
    sha256      = "47b654f42fba26e7e53b41d7ddf124da4a6e1403e19a0c50398ad242e375c81e";
    buildInputs = [ gcc-libs ];
  };

  "libpcre2posix" = fetch {
    name        = "libpcre2posix";
    version     = "10.32";
    filename    = "libpcre2posix-10.32-1-x86_64.pkg.tar.xz";
    sha256      = "d8ac5ca6770518828a61e73124b0778bfbe164dcd2726e65ec1ecc29384b3f40";
    buildInputs = [ (assert libpcre2_8.version=="10.32"; libpcre2_8) ];
  };

  "libpcre32" = fetch {
    name        = "libpcre32";
    version     = "8.42";
    filename    = "libpcre32-8.42-1-x86_64.pkg.tar.xz";
    sha256      = "c096b0a9422ab0488ee9d08c4ef4e7c22db0bd5929b1f722680745fbaa42fff2";
    buildInputs = [ gcc-libs ];
  };

  "libpcrecpp" = fetch {
    name        = "libpcrecpp";
    version     = "8.42";
    filename    = "libpcrecpp-8.42-1-x86_64.pkg.tar.xz";
    sha256      = "57493e0cb8f00cf63a8270f9bcb87f1eacb8046b50cb4ff396b34bbc22054313";
    buildInputs = [ libpcre gcc-libs ];
  };

  "libpcreposix" = fetch {
    name        = "libpcreposix";
    version     = "8.42";
    filename    = "libpcreposix-8.42-1-x86_64.pkg.tar.xz";
    sha256      = "c01e9509b96a6cb89be0523731ff9da23e63442fbb9a8ffb200ff5b5bd563cee";
    buildInputs = [ libpcre ];
  };

  "libpipeline" = fetch {
    name        = "libpipeline";
    version     = "1.5.0";
    filename    = "libpipeline-1.5.0-1-x86_64.pkg.tar.xz";
    sha256      = "e4062445d98ee3dcb8fd0bacc00c8667e1706ed84d82ffa57c35477b63caaa65";
    buildInputs = [ gcc-libs ];
  };

  "libpipeline-devel" = fetch {
    name        = "libpipeline-devel";
    version     = "1.5.0";
    filename    = "libpipeline-devel-1.5.0-1-x86_64.pkg.tar.xz";
    sha256      = "df7abc6a8df0aaa8cc509def1aaac8edee8bc22278b82ae1c8c1ae840f871f6a";
    buildInputs = [ (assert libpipeline.version=="1.5.0"; libpipeline) ];
  };

  "libpsl" = fetch {
    name        = "libpsl";
    version     = "0.20.2";
    filename    = "libpsl-0.20.2-1-x86_64.pkg.tar.xz";
    sha256      = "6fbf560aef9f1c75b1ed62d43879b1409a7f9daeeaa5b8d8253471734c6fd56b";
    buildInputs = [ libxslt libidn2 libunistring ];
  };

  "libpsl-devel" = fetch {
    name        = "libpsl-devel";
    version     = "0.20.2";
    filename    = "libpsl-devel-0.20.2-1-x86_64.pkg.tar.xz";
    sha256      = "2e6ad7077ce90ee6befd84706dc1eefee2bfa6a94c38b20be1a803acb6c4d3c9";
    buildInputs = [ (assert libpsl.version=="0.20.2"; libpsl) libxslt libidn2-devel libunistring ];
  };

  "libqrencode-git" = fetch {
    name        = "libqrencode-git";
    version     = "v3.4.3.r243.g1ef82bd";
    filename    = "libqrencode-git-v3.4.3.r243.g1ef82bd-1-x86_64.pkg.tar.xz";
    sha256      = "5c6a0f5c73fe0c50ebf7f77368752978a50bbfdc029accfaefa4291190a2e134";
  };

  "libreadline" = fetch {
    name        = "libreadline";
    version     = "7.0.005";
    filename    = "libreadline-7.0.005-1-x86_64.pkg.tar.xz";
    sha256      = "9982715480ebce7ce854553f93b03677bf9fde0f2e3b60e97e3e0973871c023f";
    buildInputs = [ ncurses ];
  };

  "libreadline-devel" = fetch {
    name        = "libreadline-devel";
    version     = "7.0.005";
    filename    = "libreadline-devel-7.0.005-1-x86_64.pkg.tar.xz";
    sha256      = "f2c5a601d77f9044b78b27a684761492b97437587645e417921daa97a45acc89";
    buildInputs = [ (assert libreadline.version=="7.0.005"; libreadline) ncurses-devel ];
  };

  "librhash" = fetch {
    name        = "librhash";
    version     = "1.3.6";
    filename    = "librhash-1.3.6-2-x86_64.pkg.tar.xz";
    sha256      = "4d461390c9bc491b0141b854ecbeb08655b2f742aa3951c5615f145a100d5e36";
    buildInputs = [ libopenssl gcc-libs ];
  };

  "librhash-devel" = fetch {
    name        = "librhash-devel";
    version     = "1.3.6";
    filename    = "librhash-devel-1.3.6-2-x86_64.pkg.tar.xz";
    sha256      = "542d549d2e279e190b4e83e5e415365fa38e3913e8348955ad5b467a44ed09f6";
    buildInputs = [ (assert librhash.version=="1.3.6"; librhash) ];
  };

  "libsasl" = fetch {
    name        = "libsasl";
    version     = "2.1.27";
    filename    = "libsasl-2.1.27-1-x86_64.pkg.tar.xz";
    sha256      = "f9cea8f5dbe2e6e36adc069bcaeba02e33cdabb6b0babe018d8eb82cdca6011f";
    buildInputs = [ libcrypt libopenssl heimdal-libs libsqlite ];
  };

  "libsasl-devel" = fetch {
    name        = "libsasl-devel";
    version     = "2.1.27";
    filename    = "libsasl-devel-2.1.27-1-x86_64.pkg.tar.xz";
    sha256      = "9acd7234fe562a7bc268100453d277cffe05dca25e153445b1d3fd52a1c4ef6f";
    buildInputs = [ (assert libsasl.version=="2.1.27"; libsasl) heimdal-devel openssl-devel libsqlite-devel libcrypt-devel ];
  };

  "libserf" = fetch {
    name        = "libserf";
    version     = "1.3.9";
    filename    = "libserf-1.3.9-3-x86_64.pkg.tar.xz";
    sha256      = "11f5ba0c74925cf808f39f77a2c920a24490e1520253632cb0fce1b557fe443a";
    buildInputs = [ apr-util libopenssl zlib ];
    broken      = true;
  };

  "libserf-devel" = fetch {
    name        = "libserf-devel";
    version     = "1.3.9";
    filename    = "libserf-devel-1.3.9-3-x86_64.pkg.tar.xz";
    sha256      = "64be19d58ceaf28522febfb27e78212eac167dbddc611b662061759ba98dcb6b";
    buildInputs = [ (assert libserf.version=="1.3.9"; libserf) apr-util-devel openssl-devel zlib-devel ];
    broken      = true;
  };

  "libsqlite" = fetch {
    name        = "libsqlite";
    version     = "3.21.0";
    filename    = "libsqlite-3.21.0-4-x86_64.pkg.tar.xz";
    sha256      = "b0cbc80d28a491a5034cd52403cd9e3e0fdd9531d9c48ca1c1fa76f6f37ff6c5";
    buildInputs = [ libreadline (assert lib.versionAtLeast icu.version "3.21.0"; icu) zlib ];
  };

  "libsqlite-devel" = fetch {
    name        = "libsqlite-devel";
    version     = "3.21.0";
    filename    = "libsqlite-devel-3.21.0-4-x86_64.pkg.tar.xz";
    sha256      = "590a6e540faf56b8f34fab4c014a9ee98d4996a8f1a1de3499904ee78175eb8b";
    buildInputs = [ (assert libsqlite.version=="3.21.0"; libsqlite) ];
  };

  "libssh2" = fetch {
    name        = "libssh2";
    version     = "1.8.0";
    filename    = "libssh2-1.8.0-2-x86_64.pkg.tar.xz";
    sha256      = "becb5c7b1a587afcff74894bb9672ca96d6c75c08bcef641d750aaaf46c4d68a";
    buildInputs = [ ca-certificates openssl zlib ];
  };

  "libssh2-devel" = fetch {
    name        = "libssh2-devel";
    version     = "1.8.0";
    filename    = "libssh2-devel-1.8.0-2-x86_64.pkg.tar.xz";
    sha256      = "6864e7e367af48d03f40ce8e5f91f8f40a91c27a1c9481cd8fee342671fe3a98";
    buildInputs = [ (assert libssh2.version=="1.8.0"; libssh2) openssl-devel zlib-devel ];
  };

  "libtasn1" = fetch {
    name        = "libtasn1";
    version     = "4.13";
    filename    = "libtasn1-4.13-1-x86_64.pkg.tar.xz";
    sha256      = "682409f43154fab5d9eed663bd45365f4cd338a11a0851888caa440716e58114";
    buildInputs = [ info ];
  };

  "libtasn1-devel" = fetch {
    name        = "libtasn1-devel";
    version     = "4.13";
    filename    = "libtasn1-devel-4.13-1-x86_64.pkg.tar.xz";
    sha256      = "cff94baca3f0838a4e79473b63efb98c8eafc2b8f2f3bcd4e6be1c93427a4def";
    buildInputs = [ (assert libtasn1.version=="4.13"; libtasn1) ];
  };

  "libtirpc" = fetch {
    name        = "libtirpc";
    version     = "1.1.4";
    filename    = "libtirpc-1.1.4-1-x86_64.pkg.tar.xz";
    sha256      = "a449c137c3e1ce24b45be68c0254187c42262f694704466dd7b8856a485b5139";
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "libtirpc-devel" = fetch {
    name        = "libtirpc-devel";
    version     = "1.1.4";
    filename    = "libtirpc-devel-1.1.4-1-x86_64.pkg.tar.xz";
    sha256      = "8633a36b3f1c098934a90b16f6e27b99d451572ba34f45a099417fd49b43a949";
    buildInputs = [ (assert libtirpc.version=="1.1.4"; libtirpc) ];
  };

  "libtool" = fetch {
    name        = "libtool";
    version     = "2.4.6";
    filename    = "libtool-2.4.6-6-x86_64.pkg.tar.xz";
    sha256      = "53b338d00c9ee3c474dce46cc38ecf6aeccf0d46df9e805d0783491a7770b98a";
    buildInputs = [ sh (assert libltdl.version=="2.4.6"; libltdl) tar ];
  };

  "libtre-devel-git" = fetch {
    name        = "libtre-devel-git";
    version     = "0.8.0.128.6fb7206";
    filename    = "libtre-devel-git-0.8.0.128.6fb7206-1-x86_64.pkg.tar.xz";
    sha256      = "aec1737e3c891711068ea0eda903f6146d3d5cbf7acd2dc742b3767f3934bd81";
    buildInputs = [ (assert libtre-git.version=="0.8.0.128.6fb7206"; libtre-git) gettext-devel libiconv-devel ];
  };

  "libtre-git" = fetch {
    name        = "libtre-git";
    version     = "0.8.0.128.6fb7206";
    filename    = "libtre-git-0.8.0.128.6fb7206-1-x86_64.pkg.tar.xz";
    sha256      = "1e5f76b96e21f8fb582ac766b2d5145438fab6827f5690616f2dc0e8e241d159";
    buildInputs = [ gettext libiconv libintl ];
  };

  "libunistring" = fetch {
    name        = "libunistring";
    version     = "0.9.10";
    filename    = "libunistring-0.9.10-1-x86_64.pkg.tar.xz";
    sha256      = "64ca150cf3a112dbd5876ad0d36b727f28227a3e3e4d3aec9f0cc3224a4ddaf5";
    buildInputs = [ msys2-runtime libiconv ];
  };

  "libunistring-devel" = fetch {
    name        = "libunistring-devel";
    version     = "0.9.10";
    filename    = "libunistring-devel-0.9.10-1-x86_64.pkg.tar.xz";
    sha256      = "c2ec23d683909526090eb19808803b26cbbee9173b121bd95c021b91213fdea5";
    buildInputs = [ (assert libunistring.version=="0.9.10"; libunistring) libiconv-devel ];
  };

  "libunrar" = fetch {
    name        = "libunrar";
    version     = "5.6.8";
    filename    = "libunrar-5.6.8-1-x86_64.pkg.tar.xz";
    sha256      = "0d8b9ae630c475c86d585de8ff15b52372f6ef1d36916a41251f0970ce619a79";
    buildInputs = [ gcc-libs ];
  };

  "libunrar-devel" = fetch {
    name        = "libunrar-devel";
    version     = "5.6.8";
    filename    = "libunrar-devel-5.6.8-1-x86_64.pkg.tar.xz";
    sha256      = "41841f0f4b2ad72248103d700915689b7e426e388937f00e96b95eee0430b90c";
    buildInputs = [ libunrar ];
  };

  "libutil-linux" = fetch {
    name        = "libutil-linux";
    version     = "2.32.1";
    filename    = "libutil-linux-2.32.1-1-x86_64.pkg.tar.xz";
    sha256      = "15c6875b2a20fd154ed8c29e3e7d11efccb1186952f3dd404670d9e2da44b350";
    buildInputs = [ gcc-libs libintl msys2-runtime ];
  };

  "libutil-linux-devel" = fetch {
    name        = "libutil-linux-devel";
    version     = "2.32.1";
    filename    = "libutil-linux-devel-2.32.1-1-x86_64.pkg.tar.xz";
    sha256      = "ed7065cddd065b4c7ad5881dbe32f83e1e6f4b8fde114526acbf23c614b53583";
    buildInputs = [ libutil-linux ];
  };

  "libuv" = fetch {
    name        = "libuv";
    version     = "1.24.1";
    filename    = "libuv-1.24.1-1-x86_64.pkg.tar.xz";
    sha256      = "79d7b6c07633e13abac6c6fdebdf30e3c7fe424d0f2238271e73c7eb76041489";
    buildInputs = [ gcc-libs ];
  };

  "libuv-devel" = fetch {
    name        = "libuv-devel";
    version     = "1.24.1";
    filename    = "libuv-devel-1.24.1-1-x86_64.pkg.tar.xz";
    sha256      = "4974c49fafad208dc6123961a4a2a80201182cff0a65b728539772d4fe583b5b";
    buildInputs = [ (assert libuv.version=="1.24.1"; libuv) ];
  };

  "libxml2" = fetch {
    name        = "libxml2";
    version     = "2.9.8";
    filename    = "libxml2-2.9.8-1-x86_64.pkg.tar.xz";
    sha256      = "9c0543200d15b6717664fc6166f547d3d649d541c08058dd991f82644d0086c7";
    buildInputs = [ coreutils (assert lib.versionAtLeast icu.version "2.9.8"; icu) liblzma libreadline ncurses zlib ];
  };

  "libxml2-devel" = fetch {
    name        = "libxml2-devel";
    version     = "2.9.8";
    filename    = "libxml2-devel-2.9.8-1-x86_64.pkg.tar.xz";
    sha256      = "b04ee9b456e3c191eed6ea2e829fb09a2d64fd0a7448d7147b6c9f382e96a91f";
    buildInputs = [ (assert libxml2.version=="2.9.8"; libxml2) (assert lib.versionAtLeast icu-devel.version "2.9.8"; icu-devel) libreadline-devel ncurses-devel liblzma-devel zlib-devel ];
  };

  "libxml2-python" = fetch {
    name        = "libxml2-python";
    version     = "2.9.8";
    filename    = "libxml2-python-2.9.8-1-x86_64.pkg.tar.xz";
    sha256      = "7639ccf977ede93dcf663c4adf9aa7bb75a6e0c063042b24e69d928f029ec798";
    buildInputs = [ libxml2 ];
  };

  "libxslt" = fetch {
    name        = "libxslt";
    version     = "1.1.32";
    filename    = "libxslt-1.1.32-1-x86_64.pkg.tar.xz";
    sha256      = "3e0dd3abc1f8a20ee09197702f95418dad05b912c2b41310df4a3705c6cd802d";
    buildInputs = [ libxml2 libgcrypt ];
  };

  "libxslt-devel" = fetch {
    name        = "libxslt-devel";
    version     = "1.1.32";
    filename    = "libxslt-devel-1.1.32-1-x86_64.pkg.tar.xz";
    sha256      = "9ebab19a8acbbd72c192b78e6aad665e8072b4952ba58c20d9c527362e424619";
    buildInputs = [ (assert libxslt.version=="1.1.32"; libxslt) libxml2-devel libgcrypt-devel ];
  };

  "libxslt-python" = fetch {
    name        = "libxslt-python";
    version     = "1.1.32";
    filename    = "libxslt-python-1.1.32-1-x86_64.pkg.tar.xz";
    sha256      = "49ee76a6afdb0b2024c9a51a2aba0813abe05186b482db4b4f6bcb0d2d8c3843";
    buildInputs = [ (assert libxslt.version=="1.1.32"; libxslt) python2 ];
  };

  "libyaml" = fetch {
    name        = "libyaml";
    version     = "0.2.1";
    filename    = "libyaml-0.2.1-1-x86_64.pkg.tar.xz";
    sha256      = "a8ce4a72f64e8529ea3fc41ee155113aaa55fd4aab923e54f2ce4bcef916a26c";
    buildInputs = [  ];
  };

  "libyaml-devel" = fetch {
    name        = "libyaml-devel";
    version     = "0.2.1";
    filename    = "libyaml-devel-0.2.1-1-x86_64.pkg.tar.xz";
    sha256      = "3761a3a5abd48fd94539feb90961b9753dd357bbaa8397b51b7ccbf9f8b8bbf8";
    buildInputs = [ (assert libyaml.version=="0.2.1"; libyaml) ];
  };

  "lld-svn" = fetch {
    name        = "lld-svn";
    version     = "4595.3511ec1";
    filename    = "lld-svn-4595.3511ec1-1-x86_64.pkg.tar.xz";
    sha256      = "e901775e6428225f2182761fa058a5a2aab25a1bc68d90dcb55746f42e222277";
    buildInputs = [ llvm-svn ];
  };

  "llvm-svn" = fetch {
    name        = "llvm-svn";
    version     = "124592.2aebced";
    filename    = "llvm-svn-124592.2aebced-1-x86_64.pkg.tar.xz";
    sha256      = "1eb2b17fc5453709909cedffddaa1eebcb9ad01b03be17a23d4d67c068a2c8cc";
    buildInputs = [ gcc libffi libxml2 ];
  };

  "lndir" = fetch {
    name        = "lndir";
    version     = "1.0.3";
    filename    = "lndir-1.0.3-1-x86_64.pkg.tar.xz";
    sha256      = "da36fc9b5889dbb9da146cab4e4fc9fc518d5ee6f4bd8ef8069fc1f312311800";
    buildInputs = [ msys2-runtime ];
  };

  "lz4" = fetch {
    name        = "lz4";
    version     = "1.8.3";
    filename    = "lz4-1.8.3-1-x86_64.pkg.tar.xz";
    sha256      = "e70c043600c3168e986d1f5011affbbe1ce785c4a113a9158d78ef8aa90743cb";
    buildInputs = [ gcc-libs (assert lz4.version=="1.8.3"; lz4) ];
  };

  "lzip" = fetch {
    name        = "lzip";
    version     = "1.20";
    filename    = "lzip-1.20-1-x86_64.pkg.tar.xz";
    sha256      = "1462aaba3671df2b3363d22fa0f2a15728bda75a17481ae8e6fd13c0a378a12b";
    buildInputs = [ gcc-libs ];
  };

  "m4" = fetch {
    name        = "m4";
    version     = "1.4.18";
    filename    = "m4-1.4.18-2-x86_64.pkg.tar.xz";
    sha256      = "510e5318e830ad6bbd760aeb00a575047060dd2d93475ab1db6376ceb1afa717";
    buildInputs = [ bash gcc-libs msys2-runtime ];
  };

  "make" = fetch {
    name        = "make";
    version     = "4.2.1";
    filename    = "make-4.2.1-1-x86_64.pkg.tar.xz";
    sha256      = "b9f6574a473480a1de8bd2675b2042a9a4c813e6f093f7468ffac09b09c246a0";
    buildInputs = [ msys2-runtime libintl sh ];
  };

  "make-git" = fetch {
    name        = "make-git";
    version     = "4.1.8.g292da6f";
    filename    = "make-git-4.1.8.g292da6f-1-x86_64.pkg.tar.xz";
    sha256      = "d5a64d4d235ce52531d0170d939579bd3e31e2b2d7afc04c0e46de0e882b4dc9";
    buildInputs = [ msys2-runtime sh guile ];
  };

  "man-db" = fetch {
    name        = "man-db";
    version     = "2.8.4";
    filename    = "man-db-2.8.4-1-x86_64.pkg.tar.xz";
    sha256      = "9f7546b79deda6381d12994083435003dc57defd50f6f87293ac4c27224d0e59";
    buildInputs = [ bash gdbm zlib groff libpipeline less ];
  };

  "man-pages-posix" = fetch {
    name        = "man-pages-posix";
    version     = "2013_a";
    filename    = "man-pages-posix-2013_a-1-any.pkg.tar.xz";
    sha256      = "2ebbcc565d0e5c99400425924dff2696130fe998da59f5387b8fa881933adb91";
    buildInputs = [ man ];
    broken      = true;
  };

  "markdown" = fetch {
    name        = "markdown";
    version     = "1.0.1";
    filename    = "markdown-1.0.1-1-x86_64.pkg.tar.xz";
    sha256      = "9359cd3b48502c9f2bcb1ee09dffe45f5330f66e8d1ce5b8bd222122631fe58c";
    buildInputs = [ perl ];
  };

  "mc" = fetch {
    name        = "mc";
    version     = "4.8.21";
    filename    = "mc-4.8.21-1-x86_64.pkg.tar.xz";
    sha256      = "3c7a870bd325a671a05aeb7fec4c415bc87c71b924812affb8c0b8a6175b2b59";
    buildInputs = [ glib2 libssh2 ];
  };

  "mercurial" = fetch {
    name        = "mercurial";
    version     = "4.8.1";
    filename    = "mercurial-4.8.1-1-x86_64.pkg.tar.xz";
    sha256      = "a0405892ac3c14741ba022281f430543a74b5d58416074626c58e9516df3e875";
    buildInputs = [ python2 ];
  };

  "meson" = fetch {
    name        = "meson";
    version     = "0.49.0";
    filename    = "meson-0.49.0-1-any.pkg.tar.xz";
    sha256      = "35d990e58a4c8c5645ecc66ccd465d38edbdf99c39affd49e9693af3e0e5c440";
    buildInputs = [ python3 python3-setuptools ninja ];
    broken      = true;
  };

  "mingw-w64-cross-binutils" = fetch {
    name        = "mingw-w64-cross-binutils";
    version     = "2.30";
    filename    = "mingw-w64-cross-binutils-2.30-1-x86_64.pkg.tar.xz";
    sha256      = "3641711b16ec66fc34439262e2cafa920ec0176066ce678138c07509d2a4eb04";
    buildInputs = [ libiconv zlib ];
  };

  "mingw-w64-cross-crt-git" = fetch {
    name        = "mingw-w64-cross-crt-git";
    version     = "6.0.0.5223.7f9d8753";
    filename    = "mingw-w64-cross-crt-git-6.0.0.5223.7f9d8753-1-x86_64.pkg.tar.xz";
    sha256      = "159ba75f73651fff5e6707cfd1f4e783adafe11947743c450740f1218103b45b";
    buildInputs = [ mingw-w64-cross-headers-git ];
  };

  "mingw-w64-cross-gcc" = fetch {
    name        = "mingw-w64-cross-gcc";
    version     = "7.3.0";
    filename    = "mingw-w64-cross-gcc-7.3.0-2-x86_64.pkg.tar.xz";
    sha256      = "058be3aa915fd2c7236a46f3b909f8f8ea8a63e393aef080d076b65b9a70aca3";
    buildInputs = [ zlib mpc isl mingw-w64-cross-binutils mingw-w64-cross-crt-git mingw-w64-cross-headers-git mingw-w64-cross-winpthreads-git mingw-w64-cross-windows-default-manifest ];
  };

  "mingw-w64-cross-headers-git" = fetch {
    name        = "mingw-w64-cross-headers-git";
    version     = "6.0.0.5223.7f9d8753";
    filename    = "mingw-w64-cross-headers-git-6.0.0.5223.7f9d8753-1-x86_64.pkg.tar.xz";
    sha256      = "1c7c938ad54167db9dbb3239c3dc372924fe4f0143e452e641ec7980d10fc4bc";
    buildInputs = [  ];
  };

  "mingw-w64-cross-tools-git" = fetch {
    name        = "mingw-w64-cross-tools-git";
    version     = "6.0.0.5141.696b37c3";
    filename    = "mingw-w64-cross-tools-git-6.0.0.5141.696b37c3-1-x86_64.pkg.tar.xz";
    sha256      = "65ad5e8cf467c0e463063747fad42419eb1f571c196e0a30b107e914802d1349";
  };

  "mingw-w64-cross-windows-default-manifest" = fetch {
    name        = "mingw-w64-cross-windows-default-manifest";
    version     = "6.4";
    filename    = "mingw-w64-cross-windows-default-manifest-6.4-2-x86_64.pkg.tar.xz";
    sha256      = "440ce11c9179fc0f0f3fc933027adbb3e3bda19247964142aa1a40ef0097c258";
    buildInputs = [  ];
  };

  "mingw-w64-cross-winpthreads-git" = fetch {
    name        = "mingw-w64-cross-winpthreads-git";
    version     = "6.0.0.5142.0b647fe7";
    filename    = "mingw-w64-cross-winpthreads-git-6.0.0.5142.0b647fe7-1-x86_64.pkg.tar.xz";
    sha256      = "e02d17e626a527bbc9eb461de7baa1e5548f770040aa394137ecd17440599c02";
    buildInputs = [ mingw-w64-cross-crt-git ];
  };

  "mingw-w64-cross-winstorecompat-git" = fetch {
    name        = "mingw-w64-cross-winstorecompat-git";
    version     = "6.0.0.5099.5e5f06f6";
    filename    = "mingw-w64-cross-winstorecompat-git-6.0.0.5099.5e5f06f6-1-x86_64.pkg.tar.xz";
    sha256      = "57f1a17c314cbe2ae9b0eecaf150b1b7cc40349aa875af0ed78b2aec8f4a9693";
    buildInputs = [ mingw-w64-cross-crt-git ];
  };

  "mingw-w64-cross-zlib" = fetch {
    name        = "mingw-w64-cross-zlib";
    version     = "1.2.11";
    filename    = "mingw-w64-cross-zlib-1.2.11-1-x86_64.pkg.tar.xz";
    sha256      = "27fa35a33c17778cedc33805451ece4993181b63c6cf4d567f186d6c06e542f0";
  };

  "mintty" = fetch {
    name        = "mintty";
    version     = "1~2.9.5";
    filename    = "mintty-1~2.9.5-1-x86_64.pkg.tar.xz";
    sha256      = "b446924ca0fa2e3cb404a2ad738ae24aa6631c712c2f5520a2bae4e2f99afcf6";
    buildInputs = [ sh ];
  };

  "mksh" = fetch {
    name        = "mksh";
    version     = "56.c";
    filename    = "mksh-56.c-1-x86_64.pkg.tar.xz";
    sha256      = "15d80c3e219f974a585c643b02847afc1b334e99d682f758ec6f1800f1d2fde1";
    buildInputs = [ gcc-libs ];
  };

  "moreutils" = fetch {
    name        = "moreutils";
    version     = "0.62";
    filename    = "moreutils-0.62-1-x86_64.pkg.tar.xz";
    sha256      = "2bd891ca52e4b1f99ea12e14951fc8ff9d40f5a6bca31bd44a1bb20cc0799887";
  };

  "mosh" = fetch {
    name        = "mosh";
    version     = "1.3.2";
    filename    = "mosh-1.3.2-3-x86_64.pkg.tar.xz";
    sha256      = "6a7ed58f98ae5a0193f40f952f2cbeabcfb323965219ef1f2f7f0f1bef712ff2";
    buildInputs = [ protobuf ncurses zlib libopenssl openssh perl ];
  };

  "mpc" = fetch {
    name        = "mpc";
    version     = "1.1.0";
    filename    = "mpc-1.1.0-1-x86_64.pkg.tar.xz";
    sha256      = "5368f3aeb9cd3b9fea9a8c52dfbcc2709f911bf0d36bb9786999dcfdd0fdd5ae";
    buildInputs = [ (assert lib.versionAtLeast gmp.version "1.1.0"; gmp) mpfr ];
  };

  "mpc-devel" = fetch {
    name        = "mpc-devel";
    version     = "1.1.0";
    filename    = "mpc-devel-1.1.0-1-x86_64.pkg.tar.xz";
    sha256      = "792e03f64060384d8e7130a3cde8a08acad09efdeaa390de65bc8edfdca0771f";
    buildInputs = [ (assert mpc.version=="1.1.0"; mpc) gmp-devel mpfr-devel ];
  };

  "mpdecimal" = fetch {
    name        = "mpdecimal";
    version     = "2.4.2";
    filename    = "mpdecimal-2.4.2-2-x86_64.pkg.tar.xz";
    sha256      = "5b186bc7e80e970e0009ba5073a1b3a42e5460a136389c4849548bb24e77dcc8";
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "mpdecimal-devel" = fetch {
    name        = "mpdecimal-devel";
    version     = "2.4.2";
    filename    = "mpdecimal-devel-2.4.2-2-x86_64.pkg.tar.xz";
    sha256      = "cad3ff07043d934489770e6ce366bc58c120bd566bcf5d7af041f34448ebe2ed";
    buildInputs = [ (assert mpdecimal.version=="2.4.2"; mpdecimal) ];
  };

  "mpfr" = fetch {
    name        = "mpfr";
    version     = "4.0.1";
    filename    = "mpfr-4.0.1-1-x86_64.pkg.tar.xz";
    sha256      = "69e98d0bd26d381f6661c67353c85ae43360213a19c4287ca6ffb2a2cb7d5662";
    buildInputs = [ (assert lib.versionAtLeast gmp.version "4.0.1"; gmp) ];
  };

  "mpfr-devel" = fetch {
    name        = "mpfr-devel";
    version     = "4.0.1";
    filename    = "mpfr-devel-4.0.1-1-x86_64.pkg.tar.xz";
    sha256      = "711eda8012ad1f2512d0f574abfacf1aeac3faf53e1cee72b7fbc71a50e8cf8b";
    buildInputs = [ (assert mpfr.version=="4.0.1"; mpfr) gmp-devel ];
  };

  "msys2-keyring" = fetch {
    name        = "msys2-keyring";
    version     = "r9.397a52e";
    filename    = "msys2-keyring-r9.397a52e-1-any.pkg.tar.xz";
    sha256      = "27ae749bc8cd31a6e521d7b7e67263789aecbcd634f34930878b853c869c5516";
  };

  "msys2-launcher-git" = fetch {
    name        = "msys2-launcher-git";
    version     = "0.3.32.56c2ba7";
    filename    = "msys2-launcher-git-0.3.32.56c2ba7-2-x86_64.pkg.tar.xz";
    sha256      = "6a807bcef61c8f72ddb89b67f54edb4093802a46ffdd2bff209b905e16af3f95";
    buildInputs = [ (assert lib.versionAtLeast mintty.version "0.3.32.56c2ba7"; mintty) ];
  };

  "msys2-runtime" = fetch {
    name        = "msys2-runtime";
    version     = "2.11.2";
    filename    = "msys2-runtime-2.11.2-1-x86_64.pkg.tar.xz";
    sha256      = "04eb93cab1c679b667b9f9ce681663e0862270aac705beaef5be3dda1d661d19";
    buildInputs = [  ];
  };

  "msys2-runtime-devel" = fetch {
    name        = "msys2-runtime-devel";
    version     = "2.11.2";
    filename    = "msys2-runtime-devel-2.11.2-1-x86_64.pkg.tar.xz";
    sha256      = "7085c8fa6953d8811866370ed24fc81bc4cf22b0f926724845b409ff8006c6a4";
    buildInputs = [ (assert msys2-runtime.version=="2.11.2"; msys2-runtime) ];
  };

  "msys2-w32api-headers" = fetch {
    name        = "msys2-w32api-headers";
    version     = "6.0.0.5223.7f9d8753";
    filename    = "msys2-w32api-headers-6.0.0.5223.7f9d8753-1-x86_64.pkg.tar.xz";
    sha256      = "eb4d48053f98dcacecffe18620b75b265f09a05e8525d73776e72a89fbd7b2b3";
    buildInputs = [  ];
  };

  "msys2-w32api-runtime" = fetch {
    name        = "msys2-w32api-runtime";
    version     = "6.0.0.5223.7f9d8753";
    filename    = "msys2-w32api-runtime-6.0.0.5223.7f9d8753-1-x86_64.pkg.tar.xz";
    sha256      = "39f79e53099b370910c580fa38030f89aebefac9008960f85832b663a1c1c526";
    buildInputs = [ msys2-w32api-headers ];
  };

  "mutt" = fetch {
    name        = "mutt";
    version     = "1.11.1";
    filename    = "mutt-1.11.1-1-x86_64.pkg.tar.xz";
    sha256      = "e375103d02324289a0fcd09613816eba887242678829f6ef8b4aa8a20959ccac";
    buildInputs = [ libgpgme libsasl libgdbm ncurses libgnutls libidn2 ];
  };

  "nano" = fetch {
    name        = "nano";
    version     = "3.2";
    filename    = "nano-3.2-1-x86_64.pkg.tar.xz";
    sha256      = "6428a2a993176a218d8c3df61078ed65ddfba706c5388557fb7bd2e59c505b9c";
    buildInputs = [ file libintl ncurses sh ];
  };

  "nano-syntax-highlighting-git" = fetch {
    name        = "nano-syntax-highlighting-git";
    version     = "299.5e776df";
    filename    = "nano-syntax-highlighting-git-299.5e776df-1-any.pkg.tar.xz";
    sha256      = "386a1a16a165258287a5c7282e75174b7870bd8dc08876d70932f4e477e1d1dd";
    buildInputs = [ nano ];
  };

  "nasm" = fetch {
    name        = "nasm";
    version     = "2.14.01";
    filename    = "nasm-2.14.01-1-x86_64.pkg.tar.xz";
    sha256      = "5159f7c5f8e9dc8494916bf2a09494608b2c1827e139e003228a929d55564ed0";
    buildInputs = [ msys2-runtime ];
  };

  "ncurses" = fetch {
    name        = "ncurses";
    version     = "6.1.20180908";
    filename    = "ncurses-6.1.20180908-1-x86_64.pkg.tar.xz";
    sha256      = "d3cd15eb2fa0a9152f73d4e06e5ad8607afd99b32de768070b502b1bfb7cba86";
    buildInputs = [ msys2-runtime gcc-libs ];
  };

  "ncurses-devel" = fetch {
    name        = "ncurses-devel";
    version     = "6.1.20180908";
    filename    = "ncurses-devel-6.1.20180908-1-x86_64.pkg.tar.xz";
    sha256      = "85e001707a4be9e056582022eb4881591586345411c27544627d645e56765b71";
    buildInputs = [ (assert ncurses.version=="6.1.20180908"; ncurses) ];
  };

  "nettle" = fetch {
    name        = "nettle";
    version     = "3.4.1";
    filename    = "nettle-3.4.1-1-x86_64.pkg.tar.xz";
    sha256      = "b6013038e060e4ea4757b2acabaa06c93cb31af139b62d5611a92328e55370d8";
    buildInputs = [ libnettle ];
  };

  "nghttp2" = fetch {
    name        = "nghttp2";
    version     = "1.35.1";
    filename    = "nghttp2-1.35.1-1-x86_64.pkg.tar.xz";
    sha256      = "9f3bed359cca1b74303d256e246108dcbbfa349b163bd7ebcc46ca11069e0deb";
    buildInputs = [ gcc-libs jansson (assert libnghttp2.version=="1.35.1"; libnghttp2) ];
  };

  "ninja" = fetch {
    name        = "ninja";
    version     = "1.8.2";
    filename    = "ninja-1.8.2-1-any.pkg.tar.xz";
    sha256      = "c5f50cb6b043b39279ede49c3a1ee9cce1ad1605945647e11b8f89b1ce6bdc52";
  };

  "openbsd-netcat" = fetch {
    name        = "openbsd-netcat";
    version     = "1.195";
    filename    = "openbsd-netcat-1.195-1-x86_64.pkg.tar.xz";
    sha256      = "e6edcdafe32b48b553f8699d239551a5352e7055fec0e5c6b491bbcaa96e68d5";
  };

  "openssh" = fetch {
    name        = "openssh";
    version     = "7.9p1";
    filename    = "openssh-7.9p1-2-x86_64.pkg.tar.xz";
    sha256      = "9c5d3d4a3824320b3500b73dcc4b7d8e6e7eea4ade42a0d661564864d5b8d61b";
    buildInputs = [ heimdal libedit libcrypt openssl ];
  };

  "openssl" = fetch {
    name        = "openssl";
    version     = "1.1.1.a";
    filename    = "openssl-1.1.1.a-1-x86_64.pkg.tar.xz";
    sha256      = "55bcd16d0073aa6b7db891cd07036529cd647d37ed19160fb162f7bb4a1bb5e5";
    buildInputs = [ libopenssl zlib ];
  };

  "openssl-devel" = fetch {
    name        = "openssl-devel";
    version     = "1.1.1.a";
    filename    = "openssl-devel-1.1.1.a-1-x86_64.pkg.tar.xz";
    sha256      = "651ee55a51097526a3533e166b429e5503c4c1569d9660b47e05cffc30091e0b";
    buildInputs = [ (assert libopenssl.version=="1.1.1.a"; libopenssl) zlib-devel ];
  };

  "p11-kit" = fetch {
    name        = "p11-kit";
    version     = "0.23.14";
    filename    = "p11-kit-0.23.14-1-x86_64.pkg.tar.xz";
    sha256      = "f230b331374dc5390fc97102e1b0898f8701445d44705e73b3b4f94a14ac73ef";
    buildInputs = [ (assert libp11-kit.version=="0.23.14"; libp11-kit) ];
  };

  "p7zip" = fetch {
    name        = "p7zip";
    version     = "16.02";
    filename    = "p7zip-16.02-1-x86_64.pkg.tar.xz";
    sha256      = "f13152aab48d8e4bdc02d48e20d861c9ef05717e89730298ced94bc1ef5e7f02";
    buildInputs = [ gcc-libs bash ];
  };

  "pacman" = fetch {
    name        = "pacman";
    version     = "5.1.2";
    filename    = "pacman-5.1.2-1-x86_64.pkg.tar.xz";
    sha256      = "b15ab8d79e78f0024dc9871375c519f2afdcdc8c710e69efff3ae5c0a5984884";
    buildInputs = [ (assert lib.versionAtLeast bash.version "5.1.2"; bash) gettext gnupg msys2-runtime curl pacman-mirrors msys2-keyring which bzip2 xz ];
  };

  "pacman-mirrors" = fetch {
    name        = "pacman-mirrors";
    version     = "20180604";
    filename    = "pacman-mirrors-20180604-2-any.pkg.tar.xz";
    sha256      = "cdb631a5d7266b21c3c8145cf4c3f581b1c5d4eec90d0ac4d7b8211caea35f25";
    buildInputs = [  ];
  };

  "pactoys-git" = fetch {
    name        = "pactoys-git";
    version     = "r2.07ca37f";
    filename    = "pactoys-git-r2.07ca37f-1-x86_64.pkg.tar.xz";
    sha256      = "47986ea27816fc9c6d04602653718eb5a34dab140766ea0e73b48e999cd80073";
    buildInputs = [ pacman pkgfile wget ];
    broken      = true;
  };

  "parallel" = fetch {
    name        = "parallel";
    version     = "20180922";
    filename    = "parallel-20180922-1-any.pkg.tar.xz";
    sha256      = "4ed01e6add1ac778cd7b7d012de0f169509399fd466d71275189aace98923365";
    buildInputs = [ perl ];
  };

  "pass" = fetch {
    name        = "pass";
    version     = "1.7.3";
    filename    = "pass-1.7.3-1-any.pkg.tar.xz";
    sha256      = "f2a63114b033e04d2d6133866df77b9e1932e08fedbaf11a8fd6211c4393386f";
    buildInputs = [ bash gnupg tree ];
  };

  "patch" = fetch {
    name        = "patch";
    version     = "2.7.6";
    filename    = "patch-2.7.6-1-x86_64.pkg.tar.xz";
    sha256      = "5c18ce8979e9019d24abd2aee7ddcdf8824e31c4c7e162a204d4dc39b3b73776";
    buildInputs = [ msys2-runtime ];
  };

  "patchutils" = fetch {
    name        = "patchutils";
    version     = "0.3.4";
    filename    = "patchutils-0.3.4-1-x86_64.pkg.tar.xz";
    sha256      = "efdfcb4b9b6d9d95ab9e99739166b3e58e3566181aba744f0c8ed914f34038b2";
    buildInputs = [ msys2-runtime ];
  };

  "pax-git" = fetch {
    name        = "pax-git";
    version     = "20161104.2";
    filename    = "pax-git-20161104.2-1-x86_64.pkg.tar.xz";
    sha256      = "ea4b3c277d3bc38effdd3ec36235dd7d2c6853faed2ee16b5c84379a6a0dfb55";
    buildInputs = [ msys2-runtime ];
  };

  "pcre" = fetch {
    name        = "pcre";
    version     = "8.42";
    filename    = "pcre-8.42-1-x86_64.pkg.tar.xz";
    sha256      = "31e3e18780b20362285f222e3e7d613ec53c97d82f1db9badab5b2410e394ab8";
    buildInputs = [ libreadline libbz2 zlib libpcre libpcre16 libpcre32 libpcrecpp libpcreposix ];
  };

  "pcre-devel" = fetch {
    name        = "pcre-devel";
    version     = "8.42";
    filename    = "pcre-devel-8.42-1-x86_64.pkg.tar.xz";
    sha256      = "89a5d242e0d6bb991ad828901b8bd2a85dede773b16f00cb0e8f13175f749db3";
    buildInputs = [ (assert libpcre.version=="8.42"; libpcre) (assert libpcre16.version=="8.42"; libpcre16) (assert libpcre32.version=="8.42"; libpcre32) (assert libpcreposix.version=="8.42"; libpcreposix) (assert libpcrecpp.version=="8.42"; libpcrecpp) ];
  };

  "pcre2" = fetch {
    name        = "pcre2";
    version     = "10.32";
    filename    = "pcre2-10.32-1-x86_64.pkg.tar.xz";
    sha256      = "0b97aba2a9b0161465c2d6e09eb59c06c770cba293258c12f0d2095ecde2460a";
    buildInputs = [ libreadline libbz2 zlib (assert libpcre2_8.version=="10.32"; libpcre2_8) (assert libpcre2_16.version=="10.32"; libpcre2_16) (assert libpcre2_32.version=="10.32"; libpcre2_32) (assert libpcre2posix.version=="10.32"; libpcre2posix) ];
  };

  "pcre2-devel" = fetch {
    name        = "pcre2-devel";
    version     = "10.32";
    filename    = "pcre2-devel-10.32-1-x86_64.pkg.tar.xz";
    sha256      = "12019bb33364501dd5a244e6b98070988d54f485756e34b5382299fa7ca1791e";
    buildInputs = [ (assert libpcre2_8.version=="10.32"; libpcre2_8) (assert libpcre2_16.version=="10.32"; libpcre2_16) (assert libpcre2_32.version=="10.32"; libpcre2_32) (assert libpcre2posix.version=="10.32"; libpcre2posix) ];
  };

  "perl" = fetch {
    name        = "perl";
    version     = "5.28.1";
    filename    = "perl-5.28.1-1-x86_64.pkg.tar.xz";
    sha256      = "3ac7b37fd217464d37a663251b23522a8c7afcd09d8ff29df2d9b4229ad5f902";
    buildInputs = [ db gdbm libcrypt coreutils msys2-runtime sh ];
  };

  "perl-Algorithm-Diff" = fetch {
    name        = "perl-Algorithm-Diff";
    version     = "1.1903";
    filename    = "perl-Algorithm-Diff-1.1903-1-any.pkg.tar.xz";
    sha256      = "dea50788bd3c45ad6876cb7f8d47d5c05fa406ef424240fd84011a3481f721d4";
    buildInputs = [ perl ];
  };

  "perl-Archive-Zip" = fetch {
    name        = "perl-Archive-Zip";
    version     = "1.64";
    filename    = "perl-Archive-Zip-1.64-1-any.pkg.tar.xz";
    sha256      = "1a1c92982851fcc4926ac2e32716dfe92bf3d3ae331327d2856c1997aa60f437";
    buildInputs = [ perl ];
  };

  "perl-Authen-SASL" = fetch {
    name        = "perl-Authen-SASL";
    version     = "2.16";
    filename    = "perl-Authen-SASL-2.16-2-any.pkg.tar.xz";
    sha256      = "6dfadf705bcb7cd3e147044e9da9bc17fb834d6e8a1353f617ba377d778e2a20";
    buildInputs = [ perl ];
  };

  "perl-Benchmark-Timer" = fetch {
    name        = "perl-Benchmark-Timer";
    version     = "0.7107";
    filename    = "perl-Benchmark-Timer-0.7107-1-any.pkg.tar.xz";
    sha256      = "91e4b56350cfb6862da64e71a302db0c71164aab28666e33a33e74f3a9479b81";
    buildInputs = [ perl ];
  };

  "perl-Capture-Tiny" = fetch {
    name        = "perl-Capture-Tiny";
    version     = "0.48";
    filename    = "perl-Capture-Tiny-0.48-1-any.pkg.tar.xz";
    sha256      = "e335d1b48950a5f172079426470ba30975053817b5f5362587641cc90a33a973";
    buildInputs = [ perl ];
  };

  "perl-Carp-Clan" = fetch {
    name        = "perl-Carp-Clan";
    version     = "6.06";
    filename    = "perl-Carp-Clan-6.06-1-any.pkg.tar.xz";
    sha256      = "753836eb3024d57c91bb5f02570c419e79ac67ea35e3ba07d6759b543c8ec2de";
    buildInputs = [ perl ];
  };

  "perl-Compress-Bzip2" = fetch {
    name        = "perl-Compress-Bzip2";
    version     = "2.26";
    filename    = "perl-Compress-Bzip2-2.26-2-x86_64.pkg.tar.xz";
    sha256      = "ba7b49a7d19dfe77868dd4c7e9a25795d0e771905f6fb8451c1cc9a407a8dc8c";
    buildInputs = [ perl libbz2 ];
  };

  "perl-Convert-BinHex" = fetch {
    name        = "perl-Convert-BinHex";
    version     = "1.125";
    filename    = "perl-Convert-BinHex-1.125-1-any.pkg.tar.xz";
    sha256      = "08146d9182071521e105beb4c27ae7207874fa31d82b9f9dcc3a5a08eabfcd60";
    buildInputs = [ perl ];
  };

  "perl-Crypt-SSLeay" = fetch {
    name        = "perl-Crypt-SSLeay";
    version     = "0.73_06";
    filename    = "perl-Crypt-SSLeay-0.73_06-2-x86_64.pkg.tar.xz";
    sha256      = "e4c4d0904c444a0a221e988316a4acd3eb2f6a965764b446e506fc0f07281e22";
    buildInputs = [ perl-LWP-Protocol-https perl-Try-Tiny perl-Path-Class ];
  };

  "perl-DBI" = fetch {
    name        = "perl-DBI";
    version     = "1.642";
    filename    = "perl-DBI-1.642-1-x86_64.pkg.tar.xz";
    sha256      = "12e34a96cae17a8ae4196284eae8b3771332e6fd32a1f3c7fa7c7c2335e3177f";
    buildInputs = [ perl ];
  };

  "perl-Date-Calc" = fetch {
    name        = "perl-Date-Calc";
    version     = "6.4";
    filename    = "perl-Date-Calc-6.4-1-any.pkg.tar.xz";
    sha256      = "9a5beed884beb9948f7790a868444d0802e6bd6301316e202c54dc41f1cec914";
    buildInputs = [ perl ];
  };

  "perl-Digest-HMAC" = fetch {
    name        = "perl-Digest-HMAC";
    version     = "1.03";
    filename    = "perl-Digest-HMAC-1.03-2-any.pkg.tar.xz";
    sha256      = "9611d00bf2607f8a656749dca4968e326681dda5e6ff1d66594668d8eebf1a3c";
    buildInputs = [ (assert lib.versionAtLeast perl.version "1.03"; perl) ];
  };

  "perl-Digest-MD4" = fetch {
    name        = "perl-Digest-MD4";
    version     = "1.9";
    filename    = "perl-Digest-MD4-1.9-3-any.pkg.tar.xz";
    sha256      = "53a6be90008bdbef5c26331faba492d46ebe6583474df5c6210e0ad9062a9ab2";
    buildInputs = [ (assert lib.versionAtLeast perl.version "1.9"; perl) libcrypt ];
  };

  "perl-Encode-Locale" = fetch {
    name        = "perl-Encode-Locale";
    version     = "1.05";
    filename    = "perl-Encode-Locale-1.05-1-any.pkg.tar.xz";
    sha256      = "56d82c71588c66dbee20e9acc7ed0e9bc09e40654593125b63086b59aeea8002";
    buildInputs = [ (assert lib.versionAtLeast perl.version "1.05"; perl) ];
  };

  "perl-Encode-compat" = fetch {
    name        = "perl-Encode-compat";
    version     = "0.07";
    filename    = "perl-Encode-compat-0.07-1-any.pkg.tar.xz";
    sha256      = "b277cf801059356941a7273d76dc67d32c13d136533378d4f2fbee90059c5127";
    buildInputs = [ perl ];
  };

  "perl-Error" = fetch {
    name        = "perl-Error";
    version     = "0.17027";
    filename    = "perl-Error-0.17027-1-any.pkg.tar.xz";
    sha256      = "f685e757ebf821204b883f5c5e95ebbe2104b9df781316c0d17f2183b0e97009";
    buildInputs = [ perl ];
  };

  "perl-Exporter-Lite" = fetch {
    name        = "perl-Exporter-Lite";
    version     = "0.08";
    filename    = "perl-Exporter-Lite-0.08-1-any.pkg.tar.xz";
    sha256      = "a027f79533e227a39a7e44325d19ada723d855a7679a7cc95b00b9cfce852f58";
    buildInputs = [ perl ];
  };

  "perl-Exporter-Tiny" = fetch {
    name        = "perl-Exporter-Tiny";
    version     = "1.002001";
    filename    = "perl-Exporter-Tiny-1.002001-1-any.pkg.tar.xz";
    sha256      = "e69cca9aec8875ac566a51cd9ea4bf220448e8d0323fc8e8517420dbfcbf0db7";
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-Depends" = fetch {
    name        = "perl-ExtUtils-Depends";
    version     = "0.405";
    filename    = "perl-ExtUtils-Depends-0.405-1-any.pkg.tar.xz";
    sha256      = "8d4199dd6cb525e12a41c367f01603aa2a6a608e6ddaf045564ffb0f47df7a02";
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-MakeMaker" = fetch {
    name        = "perl-ExtUtils-MakeMaker";
    version     = "7.34";
    filename    = "perl-ExtUtils-MakeMaker-7.34-1-any.pkg.tar.xz";
    sha256      = "d2ef0c422ebbd38d0df5bc9ba3e2fa39ce55ccf552db8a68282a7e4629be2e23";
    buildInputs = [ perl ];
  };

  "perl-ExtUtils-PkgConfig" = fetch {
    name        = "perl-ExtUtils-PkgConfig";
    version     = "1.16";
    filename    = "perl-ExtUtils-PkgConfig-1.16-1-any.pkg.tar.xz";
    sha256      = "9b076317052f167d610ba8898de7fffbaedd947b04ae4414c1d342080c82619c";
    buildInputs = [ (assert lib.versionAtLeast perl.version "1.16"; perl) ];
  };

  "perl-File-Copy-Recursive" = fetch {
    name        = "perl-File-Copy-Recursive";
    version     = "0.44";
    filename    = "perl-File-Copy-Recursive-0.44-1-any.pkg.tar.xz";
    sha256      = "4c687e23be720db3156cdda3c72b83fb0beb7874a38aa743403998f531823a27";
    buildInputs = [ perl ];
  };

  "perl-File-Listing" = fetch {
    name        = "perl-File-Listing";
    version     = "6.04";
    filename    = "perl-File-Listing-6.04-2-any.pkg.tar.xz";
    sha256      = "4f48fe3bde66ab216ae4a5c9ebf83dd4a490033bcdbc7abea26d59346bbb11bb";
    buildInputs = [ (assert lib.versionAtLeast perl.version "6.04"; perl) (assert lib.versionAtLeast perl-HTTP-Date.version "6.04"; perl-HTTP-Date) ];
  };

  "perl-File-Next" = fetch {
    name        = "perl-File-Next";
    version     = "1.16";
    filename    = "perl-File-Next-1.16-1-any.pkg.tar.xz";
    sha256      = "3f7f5ac5e9f3e29cc3c3ede933dcccb2c6ea5ccc11e4e580e5ebc05d78f19cbe";
    buildInputs = [ perl ];
  };

  "perl-File-Which" = fetch {
    name        = "perl-File-Which";
    version     = "1.22";
    filename    = "perl-File-Which-1.22-1-any.pkg.tar.xz";
    sha256      = "9f4c9131d4ee28e2e72c213f82258378b9e4271f7093ee939a5fedceb8c62e4d";
    buildInputs = [ perl (assert lib.versionAtLeast perl-Test-Script.version "1.22"; perl-Test-Script) ];
  };

  "perl-Font-TTF" = fetch {
    name        = "perl-Font-TTF";
    version     = "1.06";
    filename    = "perl-Font-TTF-1.06-1-any.pkg.tar.xz";
    sha256      = "f6a455372ce83e89f03958423199cee7c7950210803a7ca9ea5d957b9306f71b";
    buildInputs = [ perl-IO-String ];
  };

  "perl-Getopt-ArgvFile" = fetch {
    name        = "perl-Getopt-ArgvFile";
    version     = "1.11";
    filename    = "perl-Getopt-ArgvFile-1.11-1-any.pkg.tar.xz";
    sha256      = "c9e436c107c11d15576e03252272e156ce308bec624e949b885177d6a140ce59";
    buildInputs = [ perl ];
  };

  "perl-Getopt-Tabular" = fetch {
    name        = "perl-Getopt-Tabular";
    version     = "0.3";
    filename    = "perl-Getopt-Tabular-0.3-1-any.pkg.tar.xz";
    sha256      = "d803fcfdf1d0bdfa78a90abc2bf65e7bc54c19ecceecc6ff13d5de3df13798fa";
    buildInputs = [ perl ];
  };

  "perl-HTML-Parser" = fetch {
    name        = "perl-HTML-Parser";
    version     = "3.72";
    filename    = "perl-HTML-Parser-3.72-3-x86_64.pkg.tar.xz";
    sha256      = "40625231d3ef737871f47b8d08fe2e0d37876cce0f61543eb2c8e94c260894ce";
    buildInputs = [ perl-HTML-Tagset perl ];
  };

  "perl-HTML-Tagset" = fetch {
    name        = "perl-HTML-Tagset";
    version     = "3.20";
    filename    = "perl-HTML-Tagset-3.20-2-any.pkg.tar.xz";
    sha256      = "f3b2b1d3c27b2528449c4b09a1a164bfa0b88a75dfea399ef6402fed0d13a66d";
    buildInputs = [ (assert lib.versionAtLeast perl.version "3.20"; perl) ];
  };

  "perl-HTTP-Cookies" = fetch {
    name        = "perl-HTTP-Cookies";
    version     = "6.04";
    filename    = "perl-HTTP-Cookies-6.04-1-any.pkg.tar.xz";
    sha256      = "8e134a1d081e566bc9c1c7279caf8ee26a3cf27117abdcfaf3a5ce8390e9e953";
    buildInputs = [ (assert lib.versionAtLeast perl.version "6.04"; perl) (assert lib.versionAtLeast perl-HTTP-Date.version "6.04"; perl-HTTP-Date) perl-HTTP-Message ];
  };

  "perl-HTTP-Daemon" = fetch {
    name        = "perl-HTTP-Daemon";
    version     = "6.01";
    filename    = "perl-HTTP-Daemon-6.01-2-any.pkg.tar.xz";
    sha256      = "cd4c2f337f6e561d74dc87044c3ac00a597f59872e104522051707deb18ca769";
    buildInputs = [ perl perl-HTTP-Date perl-HTTP-Message perl-LWP-MediaTypes ];
  };

  "perl-HTTP-Date" = fetch {
    name        = "perl-HTTP-Date";
    version     = "6.02";
    filename    = "perl-HTTP-Date-6.02-2-any.pkg.tar.xz";
    sha256      = "ea96e4438838a70b469d75401e9fa733e2200ff90058d0c230bbf3d19345536f";
    buildInputs = [ (assert lib.versionAtLeast perl.version "6.02"; perl) ];
  };

  "perl-HTTP-Message" = fetch {
    name        = "perl-HTTP-Message";
    version     = "6.18";
    filename    = "perl-HTTP-Message-6.18-1-any.pkg.tar.xz";
    sha256      = "42f7bc0f6a0b747c07dad1145d8b06c0354e56232df1144041b8c61792cde5a4";
    buildInputs = [ (assert lib.versionAtLeast perl.version "6.18"; perl) (assert lib.versionAtLeast perl-Encode-Locale.version "6.18"; perl-Encode-Locale) (assert lib.versionAtLeast perl-HTML-Parser.version "6.18"; perl-HTML-Parser) (assert lib.versionAtLeast perl-HTTP-Date.version "6.18"; perl-HTTP-Date) (assert lib.versionAtLeast perl-LWP-MediaTypes.version "6.18"; perl-LWP-MediaTypes) (assert lib.versionAtLeast perl-URI.version "6.18"; perl-URI) ];
  };

  "perl-HTTP-Negotiate" = fetch {
    name        = "perl-HTTP-Negotiate";
    version     = "6.01";
    filename    = "perl-HTTP-Negotiate-6.01-2-any.pkg.tar.xz";
    sha256      = "c81c85f2c89d7022d9bc6cd29424b13db94a05dc47c8ca47730cd47d3d8e6be8";
    buildInputs = [ (assert lib.versionAtLeast perl.version "6.01"; perl) perl-HTTP-Message ];
  };

  "perl-IO-HTML" = fetch {
    name        = "perl-IO-HTML";
    version     = "1.001";
    filename    = "perl-IO-HTML-1.001-1-any.pkg.tar.xz";
    sha256      = "98b3689bac2cf0ed60c7fe02c2caa441e18e48044b317207a7d502293b291d1b";
    buildInputs = [ perl ];
  };

  "perl-IO-Socket-INET6" = fetch {
    name        = "perl-IO-Socket-INET6";
    version     = "2.72";
    filename    = "perl-IO-Socket-INET6-2.72-4-any.pkg.tar.xz";
    sha256      = "2b325a3819720cadbd4c94d00b0c60bba9b83cb4fa7eea7cfeec5cbd62676d90";
    buildInputs = [ (assert lib.versionAtLeast perl-Socket6.version "2.72"; perl-Socket6) ];
  };

  "perl-IO-Socket-SSL" = fetch {
    name        = "perl-IO-Socket-SSL";
    version     = "2.060";
    filename    = "perl-IO-Socket-SSL-2.060-1-any.pkg.tar.xz";
    sha256      = "97ed3f115bfb2ff9679f265ab4835ddf99dfd5eee67d2c2c33f928e58194679a";
    buildInputs = [ perl-Net-SSLeay perl perl-URI ];
  };

  "perl-IO-String" = fetch {
    name        = "perl-IO-String";
    version     = "1.08";
    filename    = "perl-IO-String-1.08-9-x86_64.pkg.tar.xz";
    sha256      = "62e6322c190cfadc6ba8407bdecc6c41c3f304201e5d12cf4525df22893f931a";
    buildInputs = [ (assert lib.versionAtLeast perl.version "1.08"; perl) ];
  };

  "perl-IO-stringy" = fetch {
    name        = "perl-IO-stringy";
    version     = "2.111";
    filename    = "perl-IO-stringy-2.111-1-any.pkg.tar.xz";
    sha256      = "3013c11f3d0f1a52d627a1152efdb35e51d1a8aca7f4a71d950a8f54ea722f89";
    buildInputs = [ perl ];
  };

  "perl-IPC-Run3" = fetch {
    name        = "perl-IPC-Run3";
    version     = "0.048";
    filename    = "perl-IPC-Run3-0.048-1-any.pkg.tar.xz";
    sha256      = "926b1daa99c5d33dcca9a5dae8f05b4586fae5ca10f9e100d488ac49a13ca3d6";
    buildInputs = [ perl ];
  };

  "perl-JSON" = fetch {
    name        = "perl-JSON";
    version     = "2.97001";
    filename    = "perl-JSON-2.97001-1-any.pkg.tar.xz";
    sha256      = "278294943cea537e673ea11e0cf0043f0cd1e41acb6321b3646941a64e81c3d5";
    buildInputs = [ (assert lib.versionAtLeast perl.version "2.97001"; perl) ];
  };

  "perl-LWP-MediaTypes" = fetch {
    name        = "perl-LWP-MediaTypes";
    version     = "6.02";
    filename    = "perl-LWP-MediaTypes-6.02-2-any.pkg.tar.xz";
    sha256      = "25a0d4e69aa844edfd27ab28a16488f47ceab1090188bb95a558472d712005be";
    buildInputs = [ perl ];
  };

  "perl-LWP-Protocol-https" = fetch {
    name        = "perl-LWP-Protocol-https";
    version     = "6.07";
    filename    = "perl-LWP-Protocol-https-6.07-1-any.pkg.tar.xz";
    sha256      = "572cc085e8a6f67c46aa4ba0f8c71d7408b5473ef3484fef789f04414810c2d5";
    buildInputs = [ perl perl-IO-Socket-SSL perl-Mozilla-CA perl-Net-HTTP perl-libwww ];
  };

  "perl-List-MoreUtils" = fetch {
    name        = "perl-List-MoreUtils";
    version     = "0.428";
    filename    = "perl-List-MoreUtils-0.428-1-any.pkg.tar.xz";
    sha256      = "66f3168737720c973658b748864726044da2fe2e0e0d6732e80fa3bba848e97c";
    buildInputs = [ perl perl-Exporter-Tiny perl-List-MoreUtils-XS ];
  };

  "perl-List-MoreUtils-XS" = fetch {
    name        = "perl-List-MoreUtils-XS";
    version     = "0.428";
    filename    = "perl-List-MoreUtils-XS-0.428-2-x86_64.pkg.tar.xz";
    sha256      = "d930f4746ed67eba21a91dc1de86fa3fbbd8461a1cc4b8c39f874fe1ca3b3133";
    buildInputs = [ perl ];
  };

  "perl-Locale-Gettext" = fetch {
    name        = "perl-Locale-Gettext";
    version     = "1.07";
    filename    = "perl-Locale-Gettext-1.07-3-x86_64.pkg.tar.xz";
    sha256      = "2c3913790de70a1d9d66bcf9ddd5922d85516952196e157554833f742a1a0672";
    buildInputs = [ gettext perl ];
  };

  "perl-MIME-Charset" = fetch {
    name        = "perl-MIME-Charset";
    version     = "1.012.2";
    filename    = "perl-MIME-Charset-1.012.2-1-any.pkg.tar.xz";
    sha256      = "cf0e9ffa18dc6063322e94f89320c0f546770dafbe4ab9a583ef50eb8e603d98";
    buildInputs = [ perl ];
  };

  "perl-MIME-tools" = fetch {
    name        = "perl-MIME-tools";
    version     = "5.509";
    filename    = "perl-MIME-tools-5.509-1-any.pkg.tar.xz";
    sha256      = "88459205a2a53d5ef2204d3d9fd7d9c992480f352f3301862a10fc85e2c261c2";
    buildInputs = [ perl-MailTools perl-IO-stringy perl-Convert-BinHex ];
  };

  "perl-MailTools" = fetch {
    name        = "perl-MailTools";
    version     = "2.20";
    filename    = "perl-MailTools-2.20-1-any.pkg.tar.xz";
    sha256      = "9b486e259642d765843f85a64574596002b1ef3b41c2af3a810800d88655ce5b";
    buildInputs = [ perl-TimeDate ];
  };

  "perl-Math-Int64" = fetch {
    name        = "perl-Math-Int64";
    version     = "0.54";
    filename    = "perl-Math-Int64-0.54-2-any.pkg.tar.xz";
    sha256      = "96dcad362f6853fedb266eff9e45f57b8e434d858f8ba726cca41458e0736012";
    buildInputs = [ perl ];
  };

  "perl-Module-Build" = fetch {
    name        = "perl-Module-Build";
    version     = "0.4224";
    filename    = "perl-Module-Build-0.4224-1-any.pkg.tar.xz";
    sha256      = "16479b2820d4554ffbff6f403433a5ac957576c74a2f47988096c21f5131dac3";
    buildInputs = [ (assert lib.versionAtLeast perl.version "0.4224"; perl) (assert lib.versionAtLeast perl-CPAN-Meta.version "0.4224"; perl-CPAN-Meta) perl-inc-latest ];
    broken      = true;
  };

  "perl-Mozilla-CA" = fetch {
    name        = "perl-Mozilla-CA";
    version     = "20180117";
    filename    = "perl-Mozilla-CA-20180117-1-any.pkg.tar.xz";
    sha256      = "1a3c875db1b3d2b2e8082c07a5d918821489ee70d52c20278c7384c788aeb8dc";
    buildInputs = [ (assert lib.versionAtLeast perl.version "20180117"; perl) ];
  };

  "perl-Net-DNS" = fetch {
    name        = "perl-Net-DNS";
    version     = "1.19";
    filename    = "perl-Net-DNS-1.19-1-x86_64.pkg.tar.xz";
    sha256      = "62f22b36fbe6a3dbc79a4f32b3ee443f244749693b2eaa952fcafd39896ede79";
    buildInputs = [ perl-Digest-HMAC perl-Net-IP perl ];
  };

  "perl-Net-HTTP" = fetch {
    name        = "perl-Net-HTTP";
    version     = "6.18";
    filename    = "perl-Net-HTTP-6.18-1-any.pkg.tar.xz";
    sha256      = "325a8c9aa9fde1babdb8e54b9d47211cb6440a3819f64c08d053cfc0eaadbafa";
    buildInputs = [ (assert lib.versionAtLeast perl.version "6.18"; perl) ];
  };

  "perl-Net-IP" = fetch {
    name        = "perl-Net-IP";
    version     = "1.26";
    filename    = "perl-Net-IP-1.26-2-any.pkg.tar.xz";
    sha256      = "d78c5b12885a4bb6cf33d17befde8e4bdcb13d999f500b8c2c81b82d8d1d513e";
    buildInputs = [ (assert lib.versionAtLeast perl.version "1.26"; perl) ];
  };

  "perl-Net-SMTP-SSL" = fetch {
    name        = "perl-Net-SMTP-SSL";
    version     = "1.04";
    filename    = "perl-Net-SMTP-SSL-1.04-1-any.pkg.tar.xz";
    sha256      = "2e92cfa091690aa80ae53042f4434c41356ead5bf6722c12b419bedd731dd235";
    buildInputs = [ perl-IO-Socket-SSL ];
  };

  "perl-Net-SSLeay" = fetch {
    name        = "perl-Net-SSLeay";
    version     = "1.85";
    filename    = "perl-Net-SSLeay-1.85-2-x86_64.pkg.tar.xz";
    sha256      = "9bddab9ce092c4a32d091d6f1e7fdbfeb35f88dcea14688ad4fa3754ccdc8c79";
    buildInputs = [ openssl ];
  };

  "perl-Parallel-ForkManager" = fetch {
    name        = "perl-Parallel-ForkManager";
    version     = "1.20";
    filename    = "perl-Parallel-ForkManager-1.20-1-any.pkg.tar.xz";
    sha256      = "a2d1db0e4c14c85f0089b4875af4adde4602497b0d7495e3eb1a324145b95ee3";
    buildInputs = [ perl ];
  };

  "perl-Path-Class" = fetch {
    name        = "perl-Path-Class";
    version     = "0.37";
    filename    = "perl-Path-Class-0.37-1-any.pkg.tar.xz";
    sha256      = "b3a24528895ca7e977db5c8b614a757f5a42f68fa00e053c165c26defe620e25";
    buildInputs = [ perl ];
  };

  "perl-Probe-Perl" = fetch {
    name        = "perl-Probe-Perl";
    version     = "0.03";
    filename    = "perl-Probe-Perl-0.03-2-any.pkg.tar.xz";
    sha256      = "c1c5bc6b216df705a508a2628decc08065d7ae9e006e981d1159ddc8947aa70a";
    buildInputs = [ perl ];
  };

  "perl-Regexp-Common" = fetch {
    name        = "perl-Regexp-Common";
    version     = "2017060201";
    filename    = "perl-Regexp-Common-2017060201-1-any.pkg.tar.xz";
    sha256      = "38b99a97e5374cc1a278ce4b85b54ecc9c444d09ac597a4895a8af7dc97d9734";
    buildInputs = [ perl ];
  };

  "perl-Socket6" = fetch {
    name        = "perl-Socket6";
    version     = "0.29";
    filename    = "perl-Socket6-0.29-1-x86_64.pkg.tar.xz";
    sha256      = "8cedbf02f3fbdc5004cf2f2c2e639e267c28094e6065960409af1181ebec7efe";
    buildInputs = [ perl ];
  };

  "perl-Sort-Versions" = fetch {
    name        = "perl-Sort-Versions";
    version     = "1.62";
    filename    = "perl-Sort-Versions-1.62-1-any.pkg.tar.xz";
    sha256      = "dc210b425c8fb5eff83b59470fe77a00fe3820e2000576bcc37e2e7fbcb0ab2e";
    buildInputs = [ perl ];
  };

  "perl-Spiffy" = fetch {
    name        = "perl-Spiffy";
    version     = "0.46";
    filename    = "perl-Spiffy-0.46-1-any.pkg.tar.xz";
    sha256      = "aee7a3e220d1080fac9c92c183164bbd461a5ce796d5102e31df6a8f18e0045e";
    buildInputs = [ perl ];
  };

  "perl-Sys-CPU" = fetch {
    name        = "perl-Sys-CPU";
    version     = "0.61";
    filename    = "perl-Sys-CPU-0.61-5-x86_64.pkg.tar.xz";
    sha256      = "00fa464a594bd0145439c45449ebe408e801a30e910bf9c00bc57485e43d24c7";
    buildInputs = [ perl libcrypt-devel ];
  };

  "perl-TAP-Harness-Archive" = fetch {
    name        = "perl-TAP-Harness-Archive";
    version     = "0.18";
    filename    = "perl-TAP-Harness-Archive-0.18-1-any.pkg.tar.xz";
    sha256      = "49966dd01f79fb86600cb91cfc2b82ac76418b604c2963f88499ed93d0e46d34";
    buildInputs = [ perl-YAML-Tiny perl ];
  };

  "perl-TermReadKey" = fetch {
    name        = "perl-TermReadKey";
    version     = "2.37";
    filename    = "perl-TermReadKey-2.37-3-x86_64.pkg.tar.xz";
    sha256      = "0b8ad806893cf6d43d391250be3d42c9deff9583ca319341fd6e8c7cbc473e51";
    buildInputs = [ perl ];
  };

  "perl-Test-Base" = fetch {
    name        = "perl-Test-Base";
    version     = "0.89";
    filename    = "perl-Test-Base-0.89-1-any.pkg.tar.xz";
    sha256      = "6732359b469fdc1ad21bf438ca1a785adcfa45c496752a0f9bbfe5a3408bfe2c";
    buildInputs = [ perl perl-Spiffy perl-Text-Diff ];
    broken      = true;
  };

  "perl-Test-Deep" = fetch {
    name        = "perl-Test-Deep";
    version     = "1.128";
    filename    = "perl-Test-Deep-1.128-1-any.pkg.tar.xz";
    sha256      = "1aac742afb85b1dcd303efe014389ce0fb1065dab793d7cc004b8564535da8bd";
    buildInputs = [ perl perl-Test-Simple perl-Test-NoWarnings ];
  };

  "perl-Test-Fatal" = fetch {
    name        = "perl-Test-Fatal";
    version     = "0.014";
    filename    = "perl-Test-Fatal-0.014-1-any.pkg.tar.xz";
    sha256      = "df0e0ffaaf16f3b938ae210beb34f06cfb5e05c036e8efeea9cf334f1dc58773";
    buildInputs = [ perl perl-Try-Tiny ];
  };

  "perl-Test-Harness" = fetch {
    name        = "perl-Test-Harness";
    version     = "3.39";
    filename    = "perl-Test-Harness-3.39-1-any.pkg.tar.xz";
    sha256      = "0edd9a3dd20abf0544afcd2b111166f5e55b6957e03126947278e7c94f497e94";
    buildInputs = [ perl ];
  };

  "perl-Test-Needs" = fetch {
    name        = "perl-Test-Needs";
    version     = "0.002005";
    filename    = "perl-Test-Needs-0.002005-1-any.pkg.tar.xz";
    sha256      = "7f12f098eceb57739e3db2364c9310c697e964a79afe617d8134dd20ede98142";
    buildInputs = [ perl ];
  };

  "perl-Test-NoWarnings" = fetch {
    name        = "perl-Test-NoWarnings";
    version     = "1.04";
    filename    = "perl-Test-NoWarnings-1.04-1-any.pkg.tar.xz";
    sha256      = "2ae02b5d0cebd00869c1e102ad147d3a97d2b6dab891a5fd09ada9f214757378";
    buildInputs = [ perl perl-Test-Simple ];
  };

  "perl-Test-Pod" = fetch {
    name        = "perl-Test-Pod";
    version     = "1.52";
    filename    = "perl-Test-Pod-1.52-1-any.pkg.tar.xz";
    sha256      = "e63f00957a37c8a797aae80a774d87c2310c38ff0658a6b9714fe2c44211b9fe";
    buildInputs = [ perl perl-Module-Build ];
    broken      = true;
  };

  "perl-Test-Requiresinternet" = fetch {
    name        = "perl-Test-Requiresinternet";
    version     = "0.05";
    filename    = "perl-Test-Requiresinternet-0.05-1-any.pkg.tar.xz";
    sha256      = "d3a7f2b885579245c3119361ae70a5260a8a765fd11b380efaa31db4e4143487";
    buildInputs = [ perl ];
  };

  "perl-Test-Script" = fetch {
    name        = "perl-Test-Script";
    version     = "1.23";
    filename    = "perl-Test-Script-1.23-1-any.pkg.tar.xz";
    sha256      = "1708b159a0ae0aa7f1ea62b4610f70d12dd304e05ad81b6de8b0d2c082c6cf0d";
    buildInputs = [ perl perl-IPC-Run3 perl-Probe-Perl perl-Test-Simple ];
  };

  "perl-Test-Simple" = fetch {
    name        = "perl-Test-Simple";
    version     = "1.302122";
    filename    = "perl-Test-Simple-1.302122-1-any.pkg.tar.xz";
    sha256      = "69f758769938ad919ac32c2a7b92b40d6ed6ee625990b09e0c992ac20faab301";
    buildInputs = [ perl ];
  };

  "perl-Test-YAML" = fetch {
    name        = "perl-Test-YAML";
    version     = "1.07";
    filename    = "perl-Test-YAML-1.07-1-any.pkg.tar.xz";
    sha256      = "2f50588f47c264b7559edd35712ca06a90a703feb374eaa8599d47b0e1ed966f";
    buildInputs = [ perl perl-Test-Base ];
    broken      = true;
  };

  "perl-Text-CharWidth" = fetch {
    name        = "perl-Text-CharWidth";
    version     = "0.04";
    filename    = "perl-Text-CharWidth-0.04-3-any.pkg.tar.xz";
    sha256      = "6ae75963347495e9f901a88e226ec0a1fa0b2135031191d2cba7f0dced32bb27";
    buildInputs = [ perl libcrypt ];
  };

  "perl-Text-Diff" = fetch {
    name        = "perl-Text-Diff";
    version     = "1.45";
    filename    = "perl-Text-Diff-1.45-1-any.pkg.tar.xz";
    sha256      = "9b4bdfed7375d2edc84ddb35ba8215435b0a077e5f5117c690fef97b649cea4a";
    buildInputs = [ perl perl-Algorithm-Diff perl-Exporter ];
    broken      = true;
  };

  "perl-Text-WrapI18N" = fetch {
    name        = "perl-Text-WrapI18N";
    version     = "0.06";
    filename    = "perl-Text-WrapI18N-0.06-1-any.pkg.tar.xz";
    sha256      = "883e64f5f80446326fdacca0e989aea4e20bb2dafe52eb0347745566a0ce1c36";
    buildInputs = [ perl perl-Text-CharWidth ];
  };

  "perl-TimeDate" = fetch {
    name        = "perl-TimeDate";
    version     = "2.30";
    filename    = "perl-TimeDate-2.30-2-any.pkg.tar.xz";
    sha256      = "9611d18e8c79ee9da21cfeb0e028830006c53cbaa7af585801f6b253228b35d4";
    buildInputs = [ perl ];
  };

  "perl-Try-Tiny" = fetch {
    name        = "perl-Try-Tiny";
    version     = "0.30";
    filename    = "perl-Try-Tiny-0.30-1-any.pkg.tar.xz";
    sha256      = "20ac25b02899e85ebab23f5557b5deaacb8c4f18109e67ecd6128a9ddb944341";
    buildInputs = [ perl ];
  };

  "perl-URI" = fetch {
    name        = "perl-URI";
    version     = "1.74";
    filename    = "perl-URI-1.74-1-any.pkg.tar.xz";
    sha256      = "a606c2a30ff1290265281bffd8433d71e8b3e782a2cac2844930f2d7e5b54874";
    buildInputs = [ (assert lib.versionAtLeast perl.version "1.74"; perl) ];
  };

  "perl-Unicode-GCString" = fetch {
    name        = "perl-Unicode-GCString";
    version     = "2018.003";
    filename    = "perl-Unicode-GCString-2018.003-1-any.pkg.tar.xz";
    sha256      = "bfb34cc09cf3739548c6da1492dd0cc5d439e53e4f4498597a43df588ee95148";
    buildInputs = [ perl perl-MIME-Charset libcrypt ];
  };

  "perl-WWW-RobotRules" = fetch {
    name        = "perl-WWW-RobotRules";
    version     = "6.02";
    filename    = "perl-WWW-RobotRules-6.02-2-any.pkg.tar.xz";
    sha256      = "740d79af6618e8cb82bc22f2b913abefa14a40360b4e0e40d35522048146d366";
    buildInputs = [ perl perl-URI ];
  };

  "perl-XML-LibXML" = fetch {
    name        = "perl-XML-LibXML";
    version     = "2.0132";
    filename    = "perl-XML-LibXML-2.0132-2-x86_64.pkg.tar.xz";
    sha256      = "c5811752082b153d6b32c380bb8bd58a9b34bc93489d57359be07ada197c66aa";
    buildInputs = [ perl libxml2 perl-XML-SAX ];
  };

  "perl-XML-NamespaceSupport" = fetch {
    name        = "perl-XML-NamespaceSupport";
    version     = "1.12";
    filename    = "perl-XML-NamespaceSupport-1.12-1-any.pkg.tar.xz";
    sha256      = "8134097cbdcc291218536671977a58a1a39be0ad6b941840574b3fc2db4816a1";
    buildInputs = [ perl ];
  };

  "perl-XML-Parser" = fetch {
    name        = "perl-XML-Parser";
    version     = "2.44";
    filename    = "perl-XML-Parser-2.44-4-x86_64.pkg.tar.xz";
    sha256      = "903f04252d1b2d0c859b7f55fbeb8a0f627ff7741be8968c2404292189cf1f21";
    buildInputs = [ perl libexpat libcrypt ];
  };

  "perl-XML-SAX" = fetch {
    name        = "perl-XML-SAX";
    version     = "1.00";
    filename    = "perl-XML-SAX-1.00-1-any.pkg.tar.xz";
    sha256      = "3e317e16818f5dcf743081ff0f4d23fb1c73ad0a7296d4f17527f060005c103c";
    buildInputs = [ perl perl-XML-SAX-Base perl-XML-NamespaceSupport ];
  };

  "perl-XML-SAX-Base" = fetch {
    name        = "perl-XML-SAX-Base";
    version     = "1.09";
    filename    = "perl-XML-SAX-Base-1.09-1-any.pkg.tar.xz";
    sha256      = "644d2e4427064daf327bb1256b83e88fcd3abc22d16772d10c02b17d14bdff94";
    buildInputs = [ perl ];
  };

  "perl-XML-Simple" = fetch {
    name        = "perl-XML-Simple";
    version     = "2.25";
    filename    = "perl-XML-Simple-2.25-1-any.pkg.tar.xz";
    sha256      = "108ee1a340ff5fdbc5b1c6e864edf766235552ace49829893a17169085579305";
    buildInputs = [ perl-XML-Parser perl ];
  };

  "perl-YAML" = fetch {
    name        = "perl-YAML";
    version     = "1.27";
    filename    = "perl-YAML-1.27-1-any.pkg.tar.xz";
    sha256      = "3178b83fcb0875835d5326081c0ebc3ce7d9754b9c7d1340f21e036c4f89ed72";
    buildInputs = [ perl ];
  };

  "perl-YAML-Syck" = fetch {
    name        = "perl-YAML-Syck";
    version     = "1.31";
    filename    = "perl-YAML-Syck-1.31-1-x86_64.pkg.tar.xz";
    sha256      = "dfb837fec8fce45f38fe83f9f7596e235069144156eeff09695b241b956763d5";
    buildInputs = [ perl ];
  };

  "perl-YAML-Tiny" = fetch {
    name        = "perl-YAML-Tiny";
    version     = "1.73";
    filename    = "perl-YAML-Tiny-1.73-1-any.pkg.tar.xz";
    sha256      = "c38a995d3bdbb89c285537a6916c21c4833815a4f744fba6b684c523c29757d7";
    buildInputs = [ perl ];
  };

  "perl-ack" = fetch {
    name        = "perl-ack";
    version     = "2.24";
    filename    = "perl-ack-2.24-1-any.pkg.tar.xz";
    sha256      = "c2cd6c2fffa392a74ac5d0eb1d404884c334de5fe6ddedc0b33bcad07734e2ff";
    buildInputs = [ perl-File-Next ];
  };

  "perl-common-sense" = fetch {
    name        = "perl-common-sense";
    version     = "3.74";
    filename    = "perl-common-sense-3.74-1-any.pkg.tar.xz";
    sha256      = "b320e3fb2c5fc87a83d7afbc4e6dede23e11ca8ed9212856c678fd166cee2a5c";
    buildInputs = [ perl ];
  };

  "perl-inc-latest" = fetch {
    name        = "perl-inc-latest";
    version     = "0.500";
    filename    = "perl-inc-latest-0.500-1-any.pkg.tar.xz";
    sha256      = "2be50e019e7658de5110613701aa853661b4b454ee4e6916268abc079c418974";
    buildInputs = [ (assert lib.versionAtLeast perl.version "0.500"; perl) ];
  };

  "perl-libwww" = fetch {
    name        = "perl-libwww";
    version     = "6.36";
    filename    = "perl-libwww-6.36-1-any.pkg.tar.xz";
    sha256      = "1e311a22c6e685292364388b478a5b3384f94bedda60c9b9b73ceabee485eb81";
    buildInputs = [ perl perl-Encode-Locale perl-File-Listing perl-HTML-Parser perl-HTTP-Cookies perl-HTTP-Daemon perl-HTTP-Date perl-HTTP-Negotiate perl-LWP-MediaTypes perl-Net-HTTP perl-URI perl-WWW-RobotRules perl-HTTP-Message perl-Try-Tiny ];
  };

  "perl-sgmls" = fetch {
    name        = "perl-sgmls";
    version     = "1.03ii";
    filename    = "perl-sgmls-1.03ii-1-any.pkg.tar.xz";
    sha256      = "2ad1865419b86ca43fc7cf2e4f7151e33c0826891965538b06b26605dcc285f4";
    buildInputs = [ perl ];
  };

  "pinentry" = fetch {
    name        = "pinentry";
    version     = "1.1.0";
    filename    = "pinentry-1.1.0-2-x86_64.pkg.tar.xz";
    sha256      = "3509a73aa5a93994b3714dc4003a628c9a2ab0eb4bde3e4c93c2fc741b5adac3";
    buildInputs = [ ncurses libassuan libgpg-error ];
  };

  "pkg-config" = fetch {
    name        = "pkg-config";
    version     = "0.29.2";
    filename    = "pkg-config-0.29.2-1-x86_64.pkg.tar.xz";
    sha256      = "6b3fd030412e2fe8d31b227f37df95846387f2c48b5f35f0d9b7b76f6109c689";
    buildInputs = [ glib2 ];
  };

  "pkgfile" = fetch {
    name        = "pkgfile";
    version     = "19";
    filename    = "pkgfile-19-1-x86_64.pkg.tar.xz";
    sha256      = "9bf977934a179e5c5105ec0961e9da2ae2037e448f7a698af9bd604b5b24168c";
    buildInputs = [ libarchive curl pcre pacman ];
  };

  "po4a" = fetch {
    name        = "po4a";
    version     = "0.55";
    filename    = "po4a-0.55-1-any.pkg.tar.xz";
    sha256      = "d01cb481ca627903189283e2539441aa52876fc7735213ccddaac960064142cf";
    buildInputs = [ perl gettext perl-Text-WrapI18N perl-Locale-Gettext perl-TermReadKey perl-sgmls perl-Unicode-GCString ];
  };

  "procps" = fetch {
    name        = "procps";
    version     = "3.2.8";
    filename    = "procps-3.2.8-2-x86_64.pkg.tar.xz";
    sha256      = "c7e84b2b253e1892499fcb80caed2ffefc58a2bf091831e702a6a21e27081527";
    buildInputs = [ msys2-runtime ];
  };

  "procps-ng" = fetch {
    name        = "procps-ng";
    version     = "3.3.12";
    filename    = "procps-ng-3.3.12-1-x86_64.pkg.tar.xz";
    sha256      = "980c1aa93f21513c4e91c05ddce1854f63dbf0e4c131a17221cde7516916b4c5";
    buildInputs = [ msys2-runtime ncurses ];
  };

  "protobuf" = fetch {
    name        = "protobuf";
    version     = "3.6.1";
    filename    = "protobuf-3.6.1-1-x86_64.pkg.tar.xz";
    sha256      = "dc4a2d346f9e588690c98475eb5262e169dad0b405883c789d98919e8f092eb8";
    buildInputs = [ gcc-libs zlib ];
  };

  "protobuf-devel" = fetch {
    name        = "protobuf-devel";
    version     = "3.6.1";
    filename    = "protobuf-devel-3.6.1-1-x86_64.pkg.tar.xz";
    sha256      = "dd0a4d5a2ebf8be8031c67e1a6c6740e5be4f033c91289c5ac68bcb72bb0b4f0";
    buildInputs = [ (assert protobuf.version=="3.6.1"; protobuf) ];
  };

  "psmisc" = fetch {
    name        = "psmisc";
    version     = "23.2";
    filename    = "psmisc-23.2-1-x86_64.pkg.tar.xz";
    sha256      = "00da2caad25ed5fd12d2c64cfabfcb1a3a46ec2174c0f8b32629d2e9a9e38ae2";
    buildInputs = [ msys2-runtime gcc-libs ncurses libiconv libintl ];
  };

  "publicsuffix-list" = fetch {
    name        = "publicsuffix-list";
    version     = "20181101.726.7f2ae66";
    filename    = "publicsuffix-list-20181101.726.7f2ae66-1-any.pkg.tar.xz";
    sha256      = "16eed0bdd03ae86b1cae2bf808c4beec6ceb7a6bc86b27d81255de38463953f6";
  };

  "pv" = fetch {
    name        = "pv";
    version     = "1.6.6";
    filename    = "pv-1.6.6-1-x86_64.pkg.tar.xz";
    sha256      = "95a1a8e85b1dfcde4ac1d77e4d776c5a22d9f93fbcdd17b19d0eb1871139580c";
  };

  "pwgen" = fetch {
    name        = "pwgen";
    version     = "2.08";
    filename    = "pwgen-2.08-1-x86_64.pkg.tar.xz";
    sha256      = "6901888c9c02eec8f741485a7ee9fdfe367bbb6d704a66c4fc31fe99d574df29";
    buildInputs = [ msys2-runtime ];
  };

  "python" = fetch {
    name        = "python";
    version     = "3.7.2";
    filename    = "python-3.7.2-1-x86_64.pkg.tar.xz";
    sha256      = "b14ca1bb5beeff82f0643d01ff75b797e75b9f49c06001e76a67fce19a8b7858";
    buildInputs = [ libbz2 libexpat libffi liblzma ncurses libopenssl libreadline mpdecimal libsqlite zlib ];
  };

  "python-brotli" = fetch {
    name        = "python-brotli";
    version     = "1.0.7";
    filename    = "python-brotli-1.0.7-1-x86_64.pkg.tar.xz";
    sha256      = "cc40e187e7da13223e4d97806125c1932a76ecf0b9e98207f2c649084b01d73d";
    buildInputs = [ python ];
  };

  "python2" = fetch {
    name        = "python2";
    version     = "2.7.15";
    filename    = "python2-2.7.15-3-x86_64.pkg.tar.xz";
    sha256      = "68062125e467071cb66e048d4ea0ccb8ed598c6a5d699b597e139b77f801195c";
    buildInputs = [ gdbm libbz2 libopenssl zlib libexpat libsqlite libffi ncurses libreadline ];
  };

  "python2-appdirs" = fetch {
    name        = "python2-appdirs";
    version     = "1.4.3";
    filename    = "python2-appdirs-1.4.3-3-any.pkg.tar.xz";
    sha256      = "b7791c62817c627333b6805d714a8662089e8256bdb86a271d5a506bb33d681c";
    buildInputs = [ python2 ];
  };

  "python2-atomicwrites" = fetch {
    name        = "python2-atomicwrites";
    version     = "1.2.1";
    filename    = "python2-atomicwrites-1.2.1-1-any.pkg.tar.xz";
    sha256      = "0901607d81306c2140c239433f073bcf4b3615d7115d8ccdf2d4bfccf3f03fab";
    buildInputs = [ python2 ];
  };

  "python2-attrs" = fetch {
    name        = "python2-attrs";
    version     = "18.2.0";
    filename    = "python2-attrs-18.2.0-1-any.pkg.tar.xz";
    sha256      = "dac9cd3f21b378c6570c153b21b837eb0053e47bca335893856a63cc10a6ca17";
    buildInputs = [ python2 ];
  };

  "python2-beaker" = fetch {
    name        = "python2-beaker";
    version     = "1.10.0";
    filename    = "python2-beaker-1.10.0-3-x86_64.pkg.tar.xz";
    sha256      = "76d0071bd8e69ee36238e0dacfff082a1841b6e02a02f3fc910712a7f4d645ed";
    buildInputs = [ (assert lib.versionAtLeast python2.version "1.10.0"; python2) python2-funcsigs ];
  };

  "python2-brotli" = fetch {
    name        = "python2-brotli";
    version     = "1.0.7";
    filename    = "python2-brotli-1.0.7-1-x86_64.pkg.tar.xz";
    sha256      = "3f36a1a728a53a4fa6c0ee9ba4ed75b4de10643bee2167861cc63eda8c1011f0";
    buildInputs = [ python2 ];
  };

  "python2-colorama" = fetch {
    name        = "python2-colorama";
    version     = "0.4.1";
    filename    = "python2-colorama-0.4.1-1-any.pkg.tar.xz";
    sha256      = "91a481f8adc2f7fbf85d7d59a8ea3fd3e8d9b7c8d1c9acb62739522f3ab2d5c2";
    buildInputs = [ python2 ];
  };

  "python2-distutils-extra" = fetch {
    name        = "python2-distutils-extra";
    version     = "2.39";
    filename    = "python2-distutils-extra-2.39-2-any.pkg.tar.xz";
    sha256      = "d9f445df36f71975fbd8a0caf390f4d632390041f6c0a28877800f3d03d504ef";
    buildInputs = [ (assert lib.versionAtLeast python2.version "2.39"; python2) intltool ];
  };

  "python2-fastimport" = fetch {
    name        = "python2-fastimport";
    version     = "0.9.8";
    filename    = "python2-fastimport-0.9.8-1-any.pkg.tar.xz";
    sha256      = "10c069e9ca6e81860f5a3383d47825562bd4667b992b9d18a6b008dbcf1f5a31";
    buildInputs = [ (assert lib.versionAtLeast python2.version "0.9.8"; python2) ];
  };

  "python2-funcsigs" = fetch {
    name        = "python2-funcsigs";
    version     = "1.0.2";
    filename    = "python2-funcsigs-1.0.2-1-any.pkg.tar.xz";
    sha256      = "51fc8b1557a613388c5098f5123f05048af03412b9c5d2ada53217aa8a02b2ca";
    buildInputs = [ python2 ];
  };

  "python2-linecache2" = fetch {
    name        = "python2-linecache2";
    version     = "1.0.0";
    filename    = "python2-linecache2-1.0.0-1-any.pkg.tar.xz";
    sha256      = "64e87cfa2e862a1f1fb057b74e635d2a91b60b32bcd4518cec56811ab5d08257";
    buildInputs = [ python2 ];
  };

  "python2-mako" = fetch {
    name        = "python2-mako";
    version     = "1.0.7";
    filename    = "python2-mako-1.0.7-3-x86_64.pkg.tar.xz";
    sha256      = "df87ddbb0ef699d0063f2767f25cf89a98061be15456b6dc817edbd0415f9752";
    buildInputs = [ python2-markupsafe python2-beaker ];
  };

  "python2-markupsafe" = fetch {
    name        = "python2-markupsafe";
    version     = "1.1.0";
    filename    = "python2-markupsafe-1.1.0-1-x86_64.pkg.tar.xz";
    sha256      = "8b0aa59a8d286723bd45400c000b3cc1631a03aa457a072146b39b7a3eb8da8f";
    buildInputs = [ python2 ];
  };

  "python2-mock" = fetch {
    name        = "python2-mock";
    version     = "2.0.0";
    filename    = "python2-mock-2.0.0-1-any.pkg.tar.xz";
    sha256      = "29c0517d10738e4e673855520b82f58b612d4ce769544b3874de0603cf493b30";
    buildInputs = [ python2 ];
  };

  "python2-more-itertools" = fetch {
    name        = "python2-more-itertools";
    version     = "4.3.0";
    filename    = "python2-more-itertools-4.3.0-1-any.pkg.tar.xz";
    sha256      = "b7fbc5776f4b9801a35135762de0e52a78eba42547c5e731be6743068e4891f8";
    buildInputs = [ python2 python2-six ];
  };

  "python2-nose" = fetch {
    name        = "python2-nose";
    version     = "1.3.7";
    filename    = "python2-nose-1.3.7-4-x86_64.pkg.tar.xz";
    sha256      = "5c9fa80ed160acf270937e15a7c84da49e467cdda21cafa114a10ba85c2ca4ae";
    buildInputs = [ python2-setuptools ];
  };

  "python2-packaging" = fetch {
    name        = "python2-packaging";
    version     = "18.0";
    filename    = "python2-packaging-18.0-1-any.pkg.tar.xz";
    sha256      = "4486fd402444915efae809ab69127e48693bdc6920012ab75a109d3e8f08b5ea";
    buildInputs = [ python2-pyparsing python2-six ];
  };

  "python2-pathlib2" = fetch {
    name        = "python2-pathlib2";
    version     = "2.3.3";
    filename    = "python2-pathlib2-2.3.3-1-any.pkg.tar.xz";
    sha256      = "941e032a5253b17b1fd8e15368222a63fa12a76e802901827b2feb37b6b01587";
    buildInputs = [ python2-six python2-scandir ];
  };

  "python2-pbr" = fetch {
    name        = "python2-pbr";
    version     = "5.1.1";
    filename    = "python2-pbr-5.1.1-1-any.pkg.tar.xz";
    sha256      = "9ed05b0a6aaefb92250b4b36df23863da5573512656c28782e87f92f7ad3a021";
    buildInputs = [ python2-setuptools ];
  };

  "python2-pip" = fetch {
    name        = "python2-pip";
    version     = "18.1";
    filename    = "python2-pip-18.1-1-any.pkg.tar.xz";
    sha256      = "e21d49d72745e84ae72f77c76747ee90a8b7f9a306075535082766485af40420";
    buildInputs = [ python2 python2-setuptools ];
  };

  "python2-pluggy" = fetch {
    name        = "python2-pluggy";
    version     = "0.8.0";
    filename    = "python2-pluggy-0.8.0-1-any.pkg.tar.xz";
    sha256      = "28f173e0362f4d4df99027aeedc5cec62edd5de852309900ee864126fffbd409";
    buildInputs = [ python2 ];
  };

  "python2-py" = fetch {
    name        = "python2-py";
    version     = "1.7.0";
    filename    = "python2-py-1.7.0-1-any.pkg.tar.xz";
    sha256      = "cf6f69fda50d332312e8bdb60ae76f40690b27c5faf16323e82c984e870f246b";
    buildInputs = [ python2 ];
  };

  "python2-pyalpm" = fetch {
    name        = "python2-pyalpm";
    version     = "0.8.4";
    filename    = "python2-pyalpm-0.8.4-1-x86_64.pkg.tar.xz";
    sha256      = "adec340658adc9b3b7fa324b8fec42016fb617dfdf1eb7953e1f333799a4cb18";
    buildInputs = [ python2 ];
  };

  "python2-pygments" = fetch {
    name        = "python2-pygments";
    version     = "2.3.1";
    filename    = "python2-pygments-2.3.1-1-x86_64.pkg.tar.xz";
    sha256      = "0288b972c3057ffb1aec702ee35a13eb18aafaf21796932bcafa66ac2f56374a";
    buildInputs = [ python2 ];
  };

  "python2-pyparsing" = fetch {
    name        = "python2-pyparsing";
    version     = "2.3.0";
    filename    = "python2-pyparsing-2.3.0-1-any.pkg.tar.xz";
    sha256      = "bff93dc2becd1586c9f0338241c113e45d3565a457d1d6ead76fae2fce05e0e7";
    buildInputs = [ python2 ];
  };

  "python2-pytest" = fetch {
    name        = "python2-pytest";
    version     = "3.9.3";
    filename    = "python2-pytest-3.9.3-1-any.pkg.tar.xz";
    sha256      = "bcab09bfc46ec110ed60af903b238681049b200c24ca0640fe16dccc184bbd1a";
    buildInputs = [ python2 python2-py python2-setuptools ];
  };

  "python2-pytest-runner" = fetch {
    name        = "python2-pytest-runner";
    version     = "4.2";
    filename    = "python2-pytest-runner-4.2-2-any.pkg.tar.xz";
    sha256      = "e87d0ed9bad0e9d73249162cb248e6bd219a8abe800e603826b5f7c0534aed25";
    buildInputs = [ python2-pytest ];
  };

  "python2-scandir" = fetch {
    name        = "python2-scandir";
    version     = "1.9.0";
    filename    = "python2-scandir-1.9.0-1-x86_64.pkg.tar.xz";
    sha256      = "5a055a870882adc4ad0d33c7c0231cd4ea560e0aeb958e8ab7cdedc3e428379f";
    buildInputs = [ python2 ];
  };

  "python2-setuptools" = fetch {
    name        = "python2-setuptools";
    version     = "40.5.0";
    filename    = "python2-setuptools-40.5.0-1-any.pkg.tar.xz";
    sha256      = "0230b1c92646b774bc6b94012b357e4ff65c905293cc9018ee0c0f46e6b75789";
    buildInputs = [ python2-packaging python2-appdirs ];
  };

  "python2-setuptools-scm" = fetch {
    name        = "python2-setuptools-scm";
    version     = "3.1.0";
    filename    = "python2-setuptools-scm-3.1.0-1-any.pkg.tar.xz";
    sha256      = "333ed2db13d3689fe45497803ec372b438f06fac45a5dd90871aa067f1fbf9e9";
    buildInputs = [ python2 ];
  };

  "python2-six" = fetch {
    name        = "python2-six";
    version     = "1.12.0";
    filename    = "python2-six-1.12.0-1-any.pkg.tar.xz";
    sha256      = "ecb67f0a35dd730131998d2499de50362a3b249b2a222b227579e54a1f915bdf";
    buildInputs = [ python2 ];
  };

  "python2-traceback2" = fetch {
    name        = "python2-traceback2";
    version     = "1.4.0";
    filename    = "python2-traceback2-1.4.0-1-any.pkg.tar.xz";
    sha256      = "7900e6a82400abd0e241c1c0693acbad4a861944f3d95e5ca5724dbadd47fbc7";
    buildInputs = [ python2-linecache2 python2-six ];
  };

  "python2-unittest2" = fetch {
    name        = "python2-unittest2";
    version     = "1.1.0";
    filename    = "python2-unittest2-1.1.0-5-any.pkg.tar.xz";
    sha256      = "cd7caf845a1b6ec975e673a4bdafbc3c7c87b08621f9820e871035ae4af5f0e8";
    buildInputs = [ python2-six python2-traceback2 ];
  };

  "python3-appdirs" = fetch {
    name        = "python3-appdirs";
    version     = "1.4.3";
    filename    = "python3-appdirs-1.4.3-3-any.pkg.tar.xz";
    sha256      = "447ed410a4dc5970f9508ea865bb668ecd6a755b0151f6c16076f15f0e7e1acd";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-atomicwrites" = fetch {
    name        = "python3-atomicwrites";
    version     = "1.2.1";
    filename    = "python3-atomicwrites-1.2.1-1-any.pkg.tar.xz";
    sha256      = "6cbe2929c203b3a86da2da0195134498696777cc8433b27e953f8de9434a42e3";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-attrs" = fetch {
    name        = "python3-attrs";
    version     = "18.2.0";
    filename    = "python3-attrs-18.2.0-1-any.pkg.tar.xz";
    sha256      = "b745a168b6569e213e44f16b8be1e1a547dfdf15693c97b7d0a9d21e6127325a";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-beaker" = fetch {
    name        = "python3-beaker";
    version     = "1.10.0";
    filename    = "python3-beaker-1.10.0-3-x86_64.pkg.tar.xz";
    sha256      = "dbbc8edc917dd5c59be8b79d2f82b480ea694dd470db2cecddb12174726a7395";
    buildInputs = [ (assert lib.versionAtLeast python.version "1.10.0"; python) ];
  };

  "python3-colorama" = fetch {
    name        = "python3-colorama";
    version     = "0.4.1";
    filename    = "python3-colorama-0.4.1-1-any.pkg.tar.xz";
    sha256      = "33b2ea627d2e563baef195bfc22955e03f32797b1e69a27319b4c1f3d9f9e088";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-distutils-extra" = fetch {
    name        = "python3-distutils-extra";
    version     = "2.39";
    filename    = "python3-distutils-extra-2.39-2-any.pkg.tar.xz";
    sha256      = "caf7e417b247513208c86dbfb7e3cd0c4dbb4cf3d13e303b50a2b66ec0a55499";
    buildInputs = [ (assert lib.versionAtLeast python.version "2.39"; python) intltool ];
  };

  "python3-mako" = fetch {
    name        = "python3-mako";
    version     = "1.0.7";
    filename    = "python3-mako-1.0.7-3-x86_64.pkg.tar.xz";
    sha256      = "955322d79438056076cd4d19eafa812e234b7fa1d1551149941eb0ac7d310bf9";
    buildInputs = [ python3-markupsafe python3-beaker ];
    broken      = true;
  };

  "python3-markupsafe" = fetch {
    name        = "python3-markupsafe";
    version     = "1.1.0";
    filename    = "python3-markupsafe-1.1.0-1-x86_64.pkg.tar.xz";
    sha256      = "547475a8d588e528c97f5fe08b531f1695e1129fe73c5e9f9d9988a5c0dbdb4f";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-mock" = fetch {
    name        = "python3-mock";
    version     = "2.0.0";
    filename    = "python3-mock-2.0.0-1-any.pkg.tar.xz";
    sha256      = "d5ecddd5e506603d86154111b52f2ff8265322de43df8eb320a6fde411428ee2";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-more-itertools" = fetch {
    name        = "python3-more-itertools";
    version     = "4.3.0";
    filename    = "python3-more-itertools-4.3.0-1-any.pkg.tar.xz";
    sha256      = "996b4476069ab327ad48126632f2d21e37ccd48bfe02e97f70299d8cf37cab38";
    buildInputs = [ python3 python3-six ];
    broken      = true;
  };

  "python3-nose" = fetch {
    name        = "python3-nose";
    version     = "1.3.7";
    filename    = "python3-nose-1.3.7-4-x86_64.pkg.tar.xz";
    sha256      = "e50722d30e6e7dc070c1e6bd79be084d2f7617ef8f7ed36a45b911f15e2655a3";
    buildInputs = [ python3-setuptools ];
    broken      = true;
  };

  "python3-packaging" = fetch {
    name        = "python3-packaging";
    version     = "18.0";
    filename    = "python3-packaging-18.0-1-any.pkg.tar.xz";
    sha256      = "91755cac76fc4186776d676df47900f8d54d11a7e04a298d3058fc1ce194438a";
    buildInputs = [ python3-pyparsing python3-six ];
    broken      = true;
  };

  "python3-pbr" = fetch {
    name        = "python3-pbr";
    version     = "5.1.1";
    filename    = "python3-pbr-5.1.1-1-any.pkg.tar.xz";
    sha256      = "8f846d733a378c066f33349334a05092e5fc41146b4097041b0cb6c0b80398f8";
    buildInputs = [ python3-setuptools ];
    broken      = true;
  };

  "python3-pip" = fetch {
    name        = "python3-pip";
    version     = "18.1";
    filename    = "python3-pip-18.1-1-any.pkg.tar.xz";
    sha256      = "6555b497a618ae8d1422c367398f6a6e7583961795b8d6629bd4d4058f717267";
    buildInputs = [ python3 python3-setuptools ];
    broken      = true;
  };

  "python3-pluggy" = fetch {
    name        = "python3-pluggy";
    version     = "0.8.0";
    filename    = "python3-pluggy-0.8.0-1-any.pkg.tar.xz";
    sha256      = "737dba7fea01b9ede31e97ec1c55a1e185769618621d73395c77f9f10de029de";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-py" = fetch {
    name        = "python3-py";
    version     = "1.7.0";
    filename    = "python3-py-1.7.0-1-any.pkg.tar.xz";
    sha256      = "2d8116ea6c9c9f710ee34b78e171aa5e97c75152c3c5bc9414ab22f9283893dc";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-pyalpm" = fetch {
    name        = "python3-pyalpm";
    version     = "0.8.4";
    filename    = "python3-pyalpm-0.8.4-1-x86_64.pkg.tar.xz";
    sha256      = "056b47c0ca1878169ef4ac14004078b5944031cd6327286d0a9bc9d98d17c096";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-pygments" = fetch {
    name        = "python3-pygments";
    version     = "2.3.1";
    filename    = "python3-pygments-2.3.1-1-x86_64.pkg.tar.xz";
    sha256      = "e813b20a39cf837de5394ed61d6fb301888c88bbd15db2535fab681d4ac0d56c";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-pyparsing" = fetch {
    name        = "python3-pyparsing";
    version     = "2.3.0";
    filename    = "python3-pyparsing-2.3.0-1-any.pkg.tar.xz";
    sha256      = "35d8409030da4485d5677e88711e50bbed62b21bf93f21575326ec03ce1c3849";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-pytest" = fetch {
    name        = "python3-pytest";
    version     = "3.9.3";
    filename    = "python3-pytest-3.9.3-1-any.pkg.tar.xz";
    sha256      = "5df58ed091eb7fac355ab6cc64e04acd94d0dd605d5f16f53455e541e48b167a";
    buildInputs = [ python3 python3-py python3-setuptools ];
    broken      = true;
  };

  "python3-pytest-runner" = fetch {
    name        = "python3-pytest-runner";
    version     = "4.2";
    filename    = "python3-pytest-runner-4.2-2-any.pkg.tar.xz";
    sha256      = "295b886d38905f7a7dbbdf9185ee10bc3c7391668480d8b930366fd97d5738ca";
    buildInputs = [ python3-pytest ];
    broken      = true;
  };

  "python3-setuptools" = fetch {
    name        = "python3-setuptools";
    version     = "40.5.0";
    filename    = "python3-setuptools-40.5.0-1-any.pkg.tar.xz";
    sha256      = "fb62abd7cd2e21399cfa4e5357506dbbca5b9b4b02aada219461914ce4c19f98";
    buildInputs = [ python3-packaging python3-appdirs ];
    broken      = true;
  };

  "python3-setuptools-scm" = fetch {
    name        = "python3-setuptools-scm";
    version     = "3.1.0";
    filename    = "python3-setuptools-scm-3.1.0-1-any.pkg.tar.xz";
    sha256      = "213775649c134d5b30786d35ea8151789fffd9764edcd4b2711870b7c0b31f44";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "python3-six" = fetch {
    name        = "python3-six";
    version     = "1.12.0";
    filename    = "python3-six-1.12.0-1-any.pkg.tar.xz";
    sha256      = "9deb6e435148d378869736da880d3112b19bfb3ccb026e62369a97fcccb007f3";
    buildInputs = [ python3 ];
    broken      = true;
  };

  "quilt" = fetch {
    name        = "quilt";
    version     = "0.65";
    filename    = "quilt-0.65-2-any.pkg.tar.xz";
    sha256      = "ce99682bd6e141a8c4132ecbc8fe77dcc530ca86207436ad7364bf525793698d";
    buildInputs = [ bash bzip2 diffstat diffutils findutils gawk gettext gzip patch perl ];
  };

  "rarian" = fetch {
    name        = "rarian";
    version     = "0.8.1";
    filename    = "rarian-0.8.1-1-x86_64.pkg.tar.xz";
    sha256      = "4ccf70830f6cf924fe1fe9490a3b17dd96e42a570b69fbebd7721bbf59e14512";
    buildInputs = [ gcc-libs ];
  };

  "rcs" = fetch {
    name        = "rcs";
    version     = "5.9.4";
    filename    = "rcs-5.9.4-2-x86_64.pkg.tar.xz";
    sha256      = "37685f2a7a21e27ddd4231b5b71074b972843c4ef5d304fd8e71fe1d036de824";
  };

  "re2c" = fetch {
    name        = "re2c";
    version     = "1.1.1";
    filename    = "re2c-1.1.1-1-x86_64.pkg.tar.xz";
    sha256      = "27b3370ac775a5fa92b5f5dacc22c61f34a370e28c9947d1034ddc2c87475501";
    buildInputs = [ gcc-libs ];
  };

  "rebase" = fetch {
    name        = "rebase";
    version     = "4.4.4";
    filename    = "rebase-4.4.4-1-x86_64.pkg.tar.xz";
    sha256      = "d111585db47bf2b328702dc150085fc47010b1cc1390fafc426ca8a49057fb47";
    buildInputs = [ msys2-runtime dash ];
    broken      = true;
  };

  "remake-git" = fetch {
    name        = "remake-git";
    version     = "4.1.2957.e3e34dd9";
    filename    = "remake-git-4.1.2957.e3e34dd9-1-x86_64.pkg.tar.xz";
    sha256      = "1a67934ede349424ce48ce3b5c74c8a69f8655df3f15161e8ba4c8c77518b9da";
    buildInputs = [ guile libreadline ];
  };

  "rhash" = fetch {
    name        = "rhash";
    version     = "1.3.6";
    filename    = "rhash-1.3.6-2-x86_64.pkg.tar.xz";
    sha256      = "093663a858d66daaae2101fa8ad1097ca3a84a915637bd00ddd943f9f2fa4ae9";
    buildInputs = [ (assert librhash.version=="1.3.6"; librhash) ];
  };

  "rsync" = fetch {
    name        = "rsync";
    version     = "3.1.3";
    filename    = "rsync-3.1.3-1-x86_64.pkg.tar.xz";
    sha256      = "c397eba60b48227277c8da49f7fabbe9e6af20ee1e68b402e296e672b7a52a6a";
    buildInputs = [ perl ];
  };

  "rsync2" = fetch {
    name        = "rsync2";
    version     = "3.1.3dev_msys2.7.0_r3";
    filename    = "rsync2-3.1.3dev_msys2.7.0_r3-0-x86_64.pkg.tar.xz";
    sha256      = "a7f369bdc4ae983dd8bae1e962a32dcaaf618ca6e9373e9b0b4782969640cf92";
    buildInputs = [ libiconv ];
  };

  "ruby" = fetch {
    name        = "ruby";
    version     = "2.6.0";
    filename    = "ruby-2.6.0-1-x86_64.pkg.tar.xz";
    sha256      = "a700ed69e8ff0ba47a930cbea308b25c65621a6f1f826ec3dec4e710e5cc1a3c";
    buildInputs = [ gcc-libs libopenssl libffi libcrypt gmp libyaml libgdbm libiconv libreadline zlib ];
  };

  "ruby-docs" = fetch {
    name        = "ruby-docs";
    version     = "2.6.0";
    filename    = "ruby-docs-2.6.0-1-x86_64.pkg.tar.xz";
    sha256      = "edf70c0283841766b57fdf626adbf0c4444f260b94158adcaebe2b07540b52b6";
  };

  "scons" = fetch {
    name        = "scons";
    version     = "3.0.1";
    filename    = "scons-3.0.1-1-any.pkg.tar.xz";
    sha256      = "762363cef1fa82f69f30c1c200dd3dc318610e8aa73f2a883e1873aaddbf555a";
    buildInputs = [ python2 ];
  };

  "screenfetch" = fetch {
    name        = "screenfetch";
    version     = "3.8.0";
    filename    = "screenfetch-3.8.0-1-any.pkg.tar.xz";
    sha256      = "1499b4daa0cdf67bdf8815f7ebcac9e2e1cf7472ae21ad04ddfa19a69272a2fa";
    buildInputs = [ bash ];
  };

  "sed" = fetch {
    name        = "sed";
    version     = "4.7";
    filename    = "sed-4.7-1-x86_64.pkg.tar.xz";
    sha256      = "444408d5b93035e7ab7f4baa7fa825fe5bf95e9873e638e8c44a8bd760460b42";
    buildInputs = [ libintl sh ];
  };

  "setconf" = fetch {
    name        = "setconf";
    version     = "0.7.5";
    filename    = "setconf-0.7.5-1-any.pkg.tar.xz";
    sha256      = "49d3ccd2fe47a571d8e48c107d1c64cb563a15d1a10f290dc1866ffabf29b2ef";
    buildInputs = [ python2 ];
  };

  "sgml-common" = fetch {
    name        = "sgml-common";
    version     = "0.6.3";
    filename    = "sgml-common-0.6.3-1-any.pkg.tar.xz";
    sha256      = "8468f420528ee8cfa54c60cbe844751bfc9a1c783fc9e7e3b99bdb48c4d319a6";
    buildInputs = [ sh ];
  };

  "sharutils" = fetch {
    name        = "sharutils";
    version     = "4.15.2";
    filename    = "sharutils-4.15.2-1-x86_64.pkg.tar.xz";
    sha256      = "6907cb625fe7b200cf03672bf02d15c28d7945a28deb278ac9fe79a530774a6b";
    buildInputs = [ perl gettext texinfo ];
  };

  "socat" = fetch {
    name        = "socat";
    version     = "1.7.3.2";
    filename    = "socat-1.7.3.2-2-x86_64.pkg.tar.xz";
    sha256      = "fe924b114bea6beb8948dea970130f5d7db2f3f1ecedd377e322c9dd790d09ad";
    buildInputs = [ libreadline openssl ];
  };

  "sqlite" = fetch {
    name        = "sqlite";
    version     = "3.21.0";
    filename    = "sqlite-3.21.0-4-x86_64.pkg.tar.xz";
    sha256      = "238e6b4929ea8d4a91833c01f1fea33d06d42d1be9085ff953dd763654d32978";
    buildInputs = [ libreadline libsqlite ];
  };

  "sqlite-doc" = fetch {
    name        = "sqlite-doc";
    version     = "3.21.0";
    filename    = "sqlite-doc-3.21.0-4-x86_64.pkg.tar.xz";
    sha256      = "b7c9e29c5299b78c832daf070526c43834153146ca24ecd230c18d559d3efafa";
    buildInputs = [ (assert sqlite.version=="3.21.0"; sqlite) ];
  };

  "ssh-pageant-git" = fetch {
    name        = "ssh-pageant-git";
    version     = "1.4.12.g6f47092";
    filename    = "ssh-pageant-git-1.4.12.g6f47092-1-x86_64.pkg.tar.xz";
    sha256      = "90b57a383384a69b59251f7be8c5d002f5197c7413ef67d02f5a2a3b482a00cf";
  };

  "sshpass" = fetch {
    name        = "sshpass";
    version     = "1.06";
    filename    = "sshpass-1.06-1-x86_64.pkg.tar.xz";
    sha256      = "f7cf610af7d1f47d44a77f7ba9b2d7a4f44b7bb261889a576da4531c5a3b2076";
    buildInputs = [ openssh ];
  };

  "subversion" = fetch {
    name        = "subversion";
    version     = "1.11.0";
    filename    = "subversion-1.11.0-1-x86_64.pkg.tar.xz";
    sha256      = "d95eb64ba92580aa432636e24d4171e06cfb9e12687a9a60d3d30f59a629de7b";
    buildInputs = [ libsqlite file liblz4 libserf libsasl ];
    broken      = true;
  };

  "swig" = fetch {
    name        = "swig";
    version     = "3.0.12";
    filename    = "swig-3.0.12-1-x86_64.pkg.tar.xz";
    sha256      = "b2f0e6f72385eaa597a39b69434d5c87cc3ce55edad2934fedf7fd8d9ee604ab";
    buildInputs = [ zlib libpcre ];
  };

  "tar" = fetch {
    name        = "tar";
    version     = "1.30";
    filename    = "tar-1.30-1-x86_64.pkg.tar.xz";
    sha256      = "9993caeb88577f1b7fb03c659e73d9284ed08e0c9f855fc60e5240618091a0d9";
    buildInputs = [ msys2-runtime libiconv libintl sh ];
  };

  "task" = fetch {
    name        = "task";
    version     = "2.5.1";
    filename    = "task-2.5.1-2-x86_64.pkg.tar.xz";
    sha256      = "b27aedc77b54fbb9a4c989b379cd9ed1d4a18f74bf7384a448b4b535792c6cae";
    buildInputs = [ gcc-libs libgnutls libutil-linux libhogweed ];
  };

  "tcl" = fetch {
    name        = "tcl";
    version     = "8.6.8";
    filename    = "tcl-8.6.8-1-x86_64.pkg.tar.xz";
    sha256      = "e65adc51eb7a885283b44003e4626034b3c89cce19df34cf63f9742fcbb829a8";
    buildInputs = [ zlib ];
  };

  "tcsh" = fetch {
    name        = "tcsh";
    version     = "6.20.00";
    filename    = "tcsh-6.20.00-2-x86_64.pkg.tar.xz";
    sha256      = "9e3624b03f33fd7c4b025aef0c6fd75d0b91558751f331129dc7fb67f67f94dc";
    buildInputs = [ gcc-libs libcrypt libiconv ncurses ];
  };

  "termbox" = fetch {
    name        = "termbox";
    version     = "1.1.0";
    filename    = "termbox-1.1.0-2-x86_64.pkg.tar.xz";
    sha256      = "0ddaa0821f85d335b1b755bc866c7377f77ec43f99e50b2006b314a737327bf1";
  };

  "texinfo" = fetch {
    name        = "texinfo";
    version     = "6.5";
    filename    = "texinfo-6.5-2-x86_64.pkg.tar.xz";
    sha256      = "e8917402144df8f85f9b2ab4ff61c89325c5fbb0e7b658885b8bd02e02691198";
    buildInputs = [ info perl sh ];
  };

  "texinfo-tex" = fetch {
    name        = "texinfo-tex";
    version     = "6.5";
    filename    = "texinfo-tex-6.5-2-x86_64.pkg.tar.xz";
    sha256      = "ceaf9f8fff86befd965f3e19c8a441cd43bfc77015e7d5cbfea25e73cf2aca53";
    buildInputs = [ gawk perl sh ];
  };

  "tftp-hpa" = fetch {
    name        = "tftp-hpa";
    version     = "5.2";
    filename    = "tftp-hpa-5.2-2-x86_64.pkg.tar.xz";
    sha256      = "a765f0ca3ed795f63bc4919cbcfe1d645a26aa78c41290bec3a229b753322528";
    buildInputs = [ (assert lib.versionAtLeast libreadline.version "5.2"; libreadline) ];
  };

  "tig" = fetch {
    name        = "tig";
    version     = "2.4.1";
    filename    = "tig-2.4.1-1-x86_64.pkg.tar.xz";
    sha256      = "e5ac2b69a12dcd98781614b04c7507449f05a1a3c5b1f6401492615f94ba06dc";
    buildInputs = [ git libreadline ncurses ];
  };

  "time" = fetch {
    name        = "time";
    version     = "1.9";
    filename    = "time-1.9-1-x86_64.pkg.tar.xz";
    sha256      = "68ac171e391e3e31c430f7f58b4e812ef1e89b82d548eacbaf3a6205693d7d9c";
    buildInputs = [ msys2-runtime ];
  };

  "tio" = fetch {
    name        = "tio";
    version     = "1.32";
    filename    = "tio-1.32-1-x86_64.pkg.tar.xz";
    sha256      = "e28e790f3c2c83abb303f7c522067250fa27bca474efa6aedeb41739e4a4035c";
  };

  "tmux" = fetch {
    name        = "tmux";
    version     = "2.8";
    filename    = "tmux-2.8-1-x86_64.pkg.tar.xz";
    sha256      = "cc92c2965c04145d3f372f4137bae78a82b4cc979615c3e1a084a466c2416eb0";
    buildInputs = [ ncurses libevent ];
  };

  "tree" = fetch {
    name        = "tree";
    version     = "1.8.0";
    filename    = "tree-1.8.0-1-x86_64.pkg.tar.xz";
    sha256      = "e998a5e47fa850dc7c69e746ab2e18850aeedf6bad818893a17dedaaa0ba7cca";
    buildInputs = [ msys2-runtime ];
  };

  "ttyrec" = fetch {
    name        = "ttyrec";
    version     = "1.0.8";
    filename    = "ttyrec-1.0.8-2-x86_64.pkg.tar.xz";
    sha256      = "bd39b20cd48b0735dca56a798ffbd89b63acccfd704c597da6231bf3061c6bec";
    buildInputs = [ sh ];
  };

  "txt2html" = fetch {
    name        = "txt2html";
    version     = "2.5201";
    filename    = "txt2html-2.5201-1-x86_64.pkg.tar.xz";
    sha256      = "7abb65139bf5e4895dc27681948efe0dcb7896913508a49f15bfb2a1d78d24b8";
    buildInputs = [ (assert lib.versionAtLeast perl.version "2.5201"; perl) perl-Getopt-ArgvFile ];
  };

  "txt2tags" = fetch {
    name        = "txt2tags";
    version     = "2.6";
    filename    = "txt2tags-2.6-5-any.pkg.tar.xz";
    sha256      = "683489294d38ba8de59b155992974842515b3c067a733413a13b53e61575e8d3";
    buildInputs = [ python2 ];
  };

  "tzcode" = fetch {
    name        = "tzcode";
    version     = "2018.c";
    filename    = "tzcode-2018.c-1-x86_64.pkg.tar.xz";
    sha256      = "679264c690f304f355145ebb362712332c778aae5b53b3c9f362ca48a5ad3d6f";
    buildInputs = [ coreutils gawk sed ];
  };

  "ucl" = fetch {
    name        = "ucl";
    version     = "1.03";
    filename    = "ucl-1.03-2-x86_64.pkg.tar.xz";
    sha256      = "7e065f7a271c1eefa3499beee54bbf0e9b4436c0e2610944682c2d7fc9432a57";
  };

  "ucl-devel" = fetch {
    name        = "ucl-devel";
    version     = "1.03";
    filename    = "ucl-devel-1.03-2-x86_64.pkg.tar.xz";
    sha256      = "d21a85acabbc8c299306cad50a97503fde21f898d236b32d9628b416886dbb53";
    buildInputs = [ (assert ucl.version=="1.03"; ucl) ];
  };

  "unrar" = fetch {
    name        = "unrar";
    version     = "5.6.8";
    filename    = "unrar-5.6.8-1-x86_64.pkg.tar.xz";
    sha256      = "caa1011f58628bb15d11758de075796e1408e39322f8bcce74548d520981e22a";
    buildInputs = [ gcc-libs ];
  };

  "unzip" = fetch {
    name        = "unzip";
    version     = "6.0";
    filename    = "unzip-6.0-2-x86_64.pkg.tar.xz";
    sha256      = "8594ccda17711c5fad21ebb0e09ce37452cdf78803ca0b7ffbab1bdae1aa170c";
    buildInputs = [ libbz2 bash ];
  };

  "upx" = fetch {
    name        = "upx";
    version     = "3.95";
    filename    = "upx-3.95-2-x86_64.pkg.tar.xz";
    sha256      = "a7a5cc766f60736d55bde3c5a1af16d55acb3a0f6e2f0bbc689cb8cf50253757";
    buildInputs = [ ucl zlib ];
  };

  "util-linux" = fetch {
    name        = "util-linux";
    version     = "2.32.1";
    filename    = "util-linux-2.32.1-1-x86_64.pkg.tar.xz";
    sha256      = "ce252bedbcf900460713ce906dc4bac683e366c58f79f2f92ea4b43ece368731";
    buildInputs = [ coreutils libutil-linux libiconv ];
  };

  "util-macros" = fetch {
    name        = "util-macros";
    version     = "1.19.2";
    filename    = "util-macros-1.19.2-1-any.pkg.tar.xz";
    sha256      = "6c94b332d2054a5f44aad72068e7a24ccbcc04f2d761158aec27db8364a13bc9";
  };

  "vifm" = fetch {
    name        = "vifm";
    version     = "0.10";
    filename    = "vifm-0.10-1-x86_64.pkg.tar.xz";
    sha256      = "22df7f3aac076c47a2c7330b87348e18fc3cd4653d0f3566e60404ecaaa9b385";
    buildInputs = [ ncurses ];
  };

  "vim" = fetch {
    name        = "vim";
    version     = "8.1.0500";
    filename    = "vim-8.1.0500-1-x86_64.pkg.tar.xz";
    sha256      = "399d5bfb1bfae9587aec60e7327421143a003a92a63ee74d69d753f2d7a67ada";
    buildInputs = [ ncurses ];
  };

  "vimpager" = fetch {
    name        = "vimpager";
    version     = "2.06";
    filename    = "vimpager-2.06-1-any.pkg.tar.xz";
    sha256      = "5e281ed9ae9fef50be51ba657586c13944ac2043ecad7bff6facbe87291dd381";
    buildInputs = [ vim sharutils ];
  };

  "vimpager-git" = fetch {
    name        = "vimpager-git";
    version     = "r279.bc5548d";
    filename    = "vimpager-git-r279.bc5548d-1-any.pkg.tar.xz";
    sha256      = "d42d036d94e271fdaa28470dfe1d44cb5a70de51a50cc100d8e28d0b55dd6c00";
    buildInputs = [ vim sharutils ];
  };

  "w3m" = fetch {
    name        = "w3m";
    version     = "0.5.3+20180125";
    filename    = "w3m-0.5.3+20180125-1-x86_64.pkg.tar.xz";
    sha256      = "99fae10891dc7460744abfb27e899d560e21c2d7836f598718f7b47353965d4c";
    buildInputs = [ libgc libiconv libintl openssl zlib ncurses ];
  };

  "wcd" = fetch {
    name        = "wcd";
    version     = "6.0.2";
    filename    = "wcd-6.0.2-1-x86_64.pkg.tar.xz";
    sha256      = "c5e8cc5cbed4d17d6da7b2e79d7d34951d0873befd16c9689f77fbab77e3e28c";
    buildInputs = [ libintl libunistring ncurses ];
  };

  "wget" = fetch {
    name        = "wget";
    version     = "1.20";
    filename    = "wget-1.20-2-x86_64.pkg.tar.xz";
    sha256      = "b307ce6bd3956d08e5bb0b970b4c209e80f27931c1e04ca027a7eabe51fbd2e6";
    buildInputs = [ gcc-libs libiconv libidn2 libintl libgpgme libmetalink libpcre2_8 libpsl libuuid openssl zlib ];
    broken      = true;
  };

  "which" = fetch {
    name        = "which";
    version     = "2.21";
    filename    = "which-2.21-2-x86_64.pkg.tar.xz";
    sha256      = "5514e35834316cfc80e6547de7e570930d0198a633c8b94f45935b231547296d";
    buildInputs = [ msys2-runtime sh ];
  };

  "whois" = fetch {
    name        = "whois";
    version     = "5.4.0";
    filename    = "whois-5.4.0-1-x86_64.pkg.tar.xz";
    sha256      = "36a7f3820e124b9e23e5d1cd70bb4569f3a162f642efccd187007f507a4e2acf";
    buildInputs = [ libcrypt libidn2 libiconv ];
  };

  "windows-default-manifest" = fetch {
    name        = "windows-default-manifest";
    version     = "6.4";
    filename    = "windows-default-manifest-6.4-1-x86_64.pkg.tar.xz";
    sha256      = "e6195b19387ddd8ce05c944e0e270920d9bf483ae40670b11d24c934a546ecb2";
    buildInputs = [  ];
  };

  "winln" = fetch {
    name        = "winln";
    version     = "1.1";
    filename    = "winln-1.1-1-x86_64.pkg.tar.xz";
    sha256      = "11d26dc01d232e101fd4759030624e4710e7033335e372f03c4b0a433204439b";
  };

  "winpty" = fetch {
    name        = "winpty";
    version     = "0.4.3";
    filename    = "winpty-0.4.3-1-x86_64.pkg.tar.xz";
    sha256      = "4a7740ca2200ca585ce9d8747043c19d2d7bfff9bc2c22df9bf975e12abe51db";
  };

  "xdelta3" = fetch {
    name        = "xdelta3";
    version     = "3.1.0";
    filename    = "xdelta3-3.1.0-1-x86_64.pkg.tar.xz";
    sha256      = "a72fb0a11705523b4e67915c15f294afbefa38ee80fe1bddf653e0b472baeb0b";
    buildInputs = [ xz liblzma ];
  };

  "xmlto" = fetch {
    name        = "xmlto";
    version     = "0.0.28";
    filename    = "xmlto-0.0.28-2-x86_64.pkg.tar.xz";
    sha256      = "21a73919fe230f3e499312bdc35f67ec19bf2aa49d808eb446ebd3273a38b233";
    buildInputs = [ libxslt perl-YAML-Syck perl-Test-Pod ];
    broken      = true;
  };

  "xorriso" = fetch {
    name        = "xorriso";
    version     = "1.4.8";
    filename    = "xorriso-1.4.8-1-x86_64.pkg.tar.xz";
    sha256      = "14af2c6c93d65f6ac774f147bcd3d1afb7894aa222e7647f3eb33247f3158fc6";
    buildInputs = [ libbz2 libreadline zlib ];
  };

  "xproto" = fetch {
    name        = "xproto";
    version     = "7.0.26";
    filename    = "xproto-7.0.26-1-any.pkg.tar.xz";
    sha256      = "639d256a2bf14dc127257aad853cd9e3ca30cb89381ce56765db6d75af65e045";
  };

  "xz" = fetch {
    name        = "xz";
    version     = "5.2.4";
    filename    = "xz-5.2.4-1-x86_64.pkg.tar.xz";
    sha256      = "78f3e5e6d5147bce228865ef22a6ecbdaabe49c94799707ba34561442011f2f3";
    buildInputs = [ (assert liblzma.version=="5.2.4"; liblzma) libiconv libintl ];
  };

  "yasm" = fetch {
    name        = "yasm";
    version     = "1.3.0";
    filename    = "yasm-1.3.0-2-x86_64.pkg.tar.xz";
    sha256      = "c83a31fd0605d65ebf6c02c034e9630144c0fac854245e99e7f8af0e9aba489c";
  };

  "yasm-devel" = fetch {
    name        = "yasm-devel";
    version     = "1.3.0";
    filename    = "yasm-devel-1.3.0-2-x86_64.pkg.tar.xz";
    sha256      = "7d08fb19ef9c81d88c4f47271cfd58e2c498c3e57c739cb6a6e1e7afcc7f2268";
  };

  "yelp-tools" = fetch {
    name        = "yelp-tools";
    version     = "3.28.0";
    filename    = "yelp-tools-3.28.0-1-any.pkg.tar.xz";
    sha256      = "3490678ffeef32336716d2a7668f2a812e5e5ff741be0d9dcf0e4f1fa9273525";
    buildInputs = [ yelp-xsl itstool libxslt-python libxml2-python ];
  };

  "yelp-xsl" = fetch {
    name        = "yelp-xsl";
    version     = "3.30.1";
    filename    = "yelp-xsl-3.30.1-1-any.pkg.tar.xz";
    sha256      = "9fc99180d4560d1c47f5d3bf21040d2a79dc6f8131718d3760090a88fa98533d";
    buildInputs = [  ];
  };

  "yodl" = fetch {
    name        = "yodl";
    version     = "4.01.00";
    filename    = "yodl-4.01.00-1-x86_64.pkg.tar.xz";
    sha256      = "42250c0eb987b04a3ca1aca4bfe8186c11886ba30e48585ae105e61c4a194473";
    buildInputs = [ bash ];
  };

  "zip" = fetch {
    name        = "zip";
    version     = "3.0";
    filename    = "zip-3.0-3-x86_64.pkg.tar.xz";
    sha256      = "0264950ec9122e5b3b92a1d9fffbe6f4240ab9dee4baf4ec129762866a6c1dc6";
    buildInputs = [ libbz2 ];
  };

  "zlib" = fetch {
    name        = "zlib";
    version     = "1.2.11";
    filename    = "zlib-1.2.11-1-x86_64.pkg.tar.xz";
    sha256      = "4af63558e39e7a4941292132b2985cb2650e78168ab21157a082613215e4839a";
    buildInputs = [ gcc-libs ];
  };

  "zlib-devel" = fetch {
    name        = "zlib-devel";
    version     = "1.2.11";
    filename    = "zlib-devel-1.2.11-1-x86_64.pkg.tar.xz";
    sha256      = "ee3951f7aa3df8c9cfd17f0284b778b351cad8c402d9270cac27816241fcb57b";
    buildInputs = [ (assert zlib.version=="1.2.11"; zlib) ];
  };

  "znc-git" = fetch {
    name        = "znc-git";
    version     = "r5021.72c5f57b";
    filename    = "znc-git-r5021.72c5f57b-1-x86_64.pkg.tar.xz";
    sha256      = "823e1c4583dc0baba1d0b89b010c856129c5a0c0a3ec84ed2170869f927810b7";
    buildInputs = [ openssl ];
  };

  "zsh" = fetch {
    name        = "zsh";
    version     = "5.6.2";
    filename    = "zsh-5.6.2-1-x86_64.pkg.tar.xz";
    sha256      = "a78426669080b3f528e66068e8ec7cb34d521181fa6d80f29db0e74b7e38876d";
    buildInputs = [ ncurses pcre libiconv gdbm ];
  };

  "zsh-doc" = fetch {
    name        = "zsh-doc";
    version     = "5.6.2";
    filename    = "zsh-doc-5.6.2-1-x86_64.pkg.tar.xz";
    sha256      = "b676c2fe264889bb731c145e1f8c1dcfbd0f699629d01a756904b28c1fe53288";
  };

}; in self
