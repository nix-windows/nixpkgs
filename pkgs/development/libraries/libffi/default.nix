{ stdenv, fetchFromGitHub, fetchurl, fetchpatch, buildEnv, msysPacman, mingwPacman
, autoreconfHook

# libffi is used in darwin stdenv
# we cannot run checks within it
, doCheck ? !stdenv.isDarwin, dejagnu
}:

if stdenv.hostPlatform.isMicrosoft then

# TODO? stdenvMsys.mkDerivation
let
# msysenv = buildEnv {
#   name = "msysenv";
#   paths = [ mingwPacman.binutils ] ++ (with msysPacman; [ automake-wrapper autoconf libtool make coreutils grep sed texinfo ]);
# };
  msysenv = stdenv.mkDerivation rec {
    name         = "msysenv";
    buildInputs  = [ mingwPacman.binutils ] ++ (with msysPacman; [ automake-wrapper autoconf libtool make coreutils grep sed texinfo ]);
    phases       = ["installPhase"];
    installPhase = stdenv.lib.concatMapStrings (x: ''symtree_link($ENV{out}, '${x}', '.');'') buildInputs;
  };
in stdenv.mkDerivation rec {
  version = "3.3";  # 3.2.1 hits https://github.com/libffi/libffi/issues/149
  name = "libffi-${version}";

  src = fetchFromGitHub {
    owner = "libffi";
    repo = "libffi";
    rev = "v${version}";
    sha256 = "0x23s932b9dywjnl2iyckmh2klj98q5nqhalfa0h6fic7jjbkga1";
  };

  buildPhase = ''
    # make a copy of MSYS FHS with writable /tmp
    my $msysroot = "$ENV{NIX_BUILD_TOP}/msysroot";
    symtree_link($msysroot, '${msysenv}', '.');
    symtree_reify($msysroot, 'tmp/_');
    $ENV{PATH} = "$msysroot/mingw64/bin;$msysroot/usr/bin;$ENV{PATH}";

    changeFile { s/-nologo -W3/-nologo -W3 -DFFI_BUILDING_DLL/gr; } 'msvcc.sh';

    system('bash.exe -c ./autogen.sh') == 0 or die;
    system('bash.exe -c "./configure --build=${if stdenv.buildPlatform.is64bit then "x86_64-pc-mingw64" else "i686-pc-mingw32"}'.
                                   ' --host=${if stdenv.is64bit then "x86_64-pc-mingw64" else "i686-pc-mingw32"}'.
                                   ' CC=\"$(pwd)/msvcc.sh -m${if stdenv.is64bit then "64" else "32"}\"'.
                                   ' CXX=\"$(pwd)/msvcc.sh -m${if stdenv.is64bit then "64" else "32"}\"'.
                                   ' LD=link.exe CPP=\"cl -nologo -EP\" CXXCPP=\"cl -nologo -EP\""') == 0 or die;
    system('bash.exe -c make') == 0 or die;
  '';

  installPhase = ''
    make_pathL("$ENV{out}/bin", "$ENV{out}/include", "$ENV{out}/lib");
    copyL '${if stdenv.is64bit then "x86_64-pc-mingw64" else "i686-pc-mingw32"}/include/ffi.h',                 "$ENV{out}/include/ffi.h";
    copyL '${if stdenv.is64bit then "x86_64-pc-mingw64" else "i686-pc-mingw32"}/include/ffitarget.h',           "$ENV{out}/include/ffitarget.h";
    copyL '${if stdenv.is64bit then "x86_64-pc-mingw64" else "i686-pc-mingw32"}/.libs/libffi-7.dll',            "$ENV{out}/bin/libffi-7.dll";
    copyL '${if stdenv.is64bit then "x86_64-pc-mingw64" else "i686-pc-mingw32"}/.libs/libffi-7.lib',            "$ENV{out}/lib/libffi-7.lib";
    copyL '${if stdenv.is64bit then "x86_64-pc-mingw64" else "i686-pc-mingw32"}/.libs/libffi_convenience.lib',  "$ENV{out}/lib/libffi_convenience.lib";
    copyL '${if stdenv.is64bit then "x86_64-pc-mingw64" else "i686-pc-mingw32"}/.libs/libffi-7.lib',            "$ENV{out}/lib/ffi.lib";  # when building llvm, cmake is unable to find libffi-7.lib, only ffi.lib
  '';

  passthru.msysenv = msysenv;
}

else

stdenv.mkDerivation rec {
  name = "libffi-3.2.1";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/libffi/${name}.tar.gz";
    sha256 = "0dya49bnhianl0r65m65xndz6ls2jn1xngyn72gd28ls3n7bnvnh";
  };

  patches = stdenv.lib.optional stdenv.isCygwin ./3.2.1-cygwin.patch
    ++ stdenv.lib.optional stdenv.isAarch64 (fetchpatch {
      url = https://src.fedoraproject.org/rpms/libffi/raw/ccffc1700abfadb0969495a6e51b964117fc03f6/f/libffi-aarch64-rhbz1174037.patch;
      sha256 = "1vpirrgny43hp0885rswgv3xski8hg7791vskpbg3wdjdpb20wbc";
    })
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "gnu-linux-define.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/libffi/gnu-linux-define.patch?id=bb024fd8ec6f27a76d88396c9f7c5c4b5800d580";
      sha256 = "11pvy3xkhyvnjfyy293v51f1xjy3x0azrahv1nw9y9mw8bifa2j2";
    })
    ++ stdenv.lib.optional stdenv.hostPlatform.isRiscV (fetchpatch {
      name = "riscv-support.patch";
      url = https://github.com/sorear/libffi-riscv/commit/e46492e8bb1695a19bc1053ed869e6c2bab02ff2.patch;
      sha256 = "1vl1vbvdkigs617kckxvj8j4m2cwg62kxm1clav1w5rnw9afxg0y";
    })
    ++ stdenv.lib.optionals stdenv.isMips [
      (fetchpatch {
        name = "0001-mips-Use-compiler-internal-define-for-linux.patch";
        url = "http://cgit.openembedded.org/openembedded-core/plain/meta/recipes-support/libffi/libffi/0001-mips-Use-compiler-internal-define-for-linux.patch?id=318e33a708378652edcf61ce7d9d7f3a07743000";
        sha256 = "1gc53lw90p6hc0cmhj3csrwincfz7va5ss995ksw5gm0yrr9mrvb";
      })
      (fetchpatch {
        name = "0001-mips-fix-MIPS-softfloat-build-issue.patch";
        url = "http://cgit.openembedded.org/openembedded-core/plain/meta/recipes-support/libffi/libffi/0001-mips-fix-MIPS-softfloat-build-issue.patch?id=318e33a708378652edcf61ce7d9d7f3a07743000";
        sha256 = "0l8xgdciqalg4z9rcwyk87h8fdxpfv4hfqxwsy2agpnpszl5jjdq";
      })
    ];

  outputs = [ "out" "dev" "man" "info" ];

  nativeBuildInputs = stdenv.lib.optional stdenv.hostPlatform.isRiscV autoreconfHook;

  configureFlags = [
    "--with-gcc-arch=generic" # no detection of -march= or -mtune=
    "--enable-pax_emutramp"
  ];

  preCheck = ''
    # The tests use -O0 which is not compatible with -D_FORTIFY_SOURCE.
    NIX_HARDENING_ENABLE=''${NIX_HARDENING_ENABLE/fortify/}
  '';

  checkInputs = [ dejagnu ];

  inherit doCheck;

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform; # Don't run the native `strip' when cross-compiling.

  # Install headers and libs in the right places.
  postFixup = ''
    mkdir -p "$dev/"
    mv "$out/lib/${name}/include" "$dev/include"
    rmdir "$out/lib/${name}"
    substituteInPlace "$dev/lib/pkgconfig/libffi.pc" \
      --replace 'includedir=''${libdir}/libffi-3.2.1' "includedir=$dev"
  '';

  meta = with stdenv.lib; {
    description = "A foreign function call interface library";
    longDescription = ''
      The libffi library provides a portable, high level programming
      interface to various calling conventions.  This allows a
      programmer to call any function specified by a call interface
      description at run-time.

      FFI stands for Foreign Function Interface.  A foreign function
      interface is the popular name for the interface that allows code
      written in one language to call code written in another
      language.  The libffi library really only provides the lowest,
      machine dependent layer of a fully featured foreign function
      interface.  A layer must exist above libffi that handles type
      conversions for values passed between the two languages.
    '';
    homepage = http://sourceware.org/libffi/;
    # See http://github.com/atgreen/libffi/blob/master/LICENSE .
    license = licenses.free;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
