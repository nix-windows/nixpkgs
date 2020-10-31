{ stdenv, fetchurl, zlib
, staticRuntime ? false # false for /MD, true for /MT
, interactive ? false, readline ? null, ncurses ? null }:

assert interactive -> readline != null && ncurses != null;

with stdenv.lib;

let
  archiveVersion = import ./archive-version.nix stdenv.lib;

  name = "sqlite-${version}";
  version = "3.33.0";

  # NB! Make sure to update analyzer.nix src (in the same directory).
  src = fetchurl {
    url = "https://sqlite.org/2020/sqlite-autoconf-${archiveVersion version}.tar.gz";
    sha256 = "05dvdfaxd552gj5p7k0i72sfam7lykaw1g2pfn52jnppqx42qshh";
  };
in

if stdenv.hostPlatform.isWindows then

let
  platform = if stdenv.is64bit then "x64" else "x86";
in
stdenv.mkDerivation rec {
  name = "sqlite-${if staticRuntime then "mt" else "md"}-${version}";
  inherit version src;
  # TODO: add enablers from NIX_CFLAGS_COMPILE
  buildPhase = ''
    system("nmake /f Makefile.msc core DYNAMIC_SHELL=1 PLATFORM=${platform} USE_CRT_DLL=${if staticRuntime then "0" else "1"}") == 0 or die $!;
  '';
  installPhase = ''
    make_pathL("$ENV{out}/bin", "$ENV{out}/lib", "$ENV{out}/include");
    copyL 'sqlite3.exe',  "$ENV{out}/bin/sqlite3.exe";
    copyL 'sqlite3.dll',  "$ENV{out}/bin/sqlite3.dll";
    copyL 'sqlite3.lib',  "$ENV{out}/lib/sqlite3.lib";
    copyL 'sqlite3.h',    "$ENV{out}/include/sqlite3.h";
    copyL 'sqlite3ext.h', "$ENV{out}/include/sqlite3ext.h";
  '';
  passthru.staticRuntime = staticRuntime;
}
else
stdenv.mkDerivation rec {
  inherit name version src;

  outputs = [ "bin" "dev" "out" ];
  separateDebugInfo = stdenv.isLinux;

  buildInputs = [ zlib ] ++ optionals interactive [ readline ncurses ];

  configureFlags = [ "--enable-threadsafe" ] ++ optional interactive "--enable-readline";

  NIX_CFLAGS_COMPILE = [
    "-DSQLITE_ENABLE_COLUMN_METADATA"
    "-DSQLITE_ENABLE_DBSTAT_VTAB"
    "-DSQLITE_ENABLE_JSON1"
    "-DSQLITE_ENABLE_FTS3"
    "-DSQLITE_ENABLE_FTS3_PARENTHESIS"
    "-DSQLITE_ENABLE_FTS3_TOKENIZER"
    "-DSQLITE_ENABLE_FTS4"
    "-DSQLITE_ENABLE_FTS5"
    "-DSQLITE_ENABLE_RTREE"
    "-DSQLITE_ENABLE_STMT_SCANSTATUS"
    "-DSQLITE_ENABLE_UNLOCK_NOTIFY"
    "-DSQLITE_SOUNDEX"
    "-DSQLITE_SECURE_DELETE"
    "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    "-DSQLITE_MAX_EXPR_DEPTH=10000"
  ];

  # Test for features which may not be available at compile time
  preBuild = ''
    # Use pread(), pread64(), pwrite(), pwrite64() functions for better performance if they are available.
    if cc -Werror=implicit-function-declaration -x c - -o "$TMPDIR/pread_pwrite_test" <<< \
      ''$'#include <unistd.h>\nint main()\n{\n  pread(0, NULL, 0, 0);\n  pwrite(0, NULL, 0, 0);\n  return 0;\n}'; then
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DUSE_PREAD"
    fi
    if cc -Werror=implicit-function-declaration -x c - -o "$TMPDIR/pread64_pwrite64_test" <<< \
      ''$'#include <unistd.h>\nint main()\n{\n  pread64(0, NULL, 0, 0);\n  pwrite64(0, NULL, 0, 0);\n  return 0;\n}'; then
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DUSE_PREAD64"
    elif cc -D_LARGEFILE64_SOURCE -Werror=implicit-function-declaration -x c - -o "$TMPDIR/pread64_pwrite64_test" <<< \
      ''$'#include <unistd.h>\nint main()\n{\n  pread64(0, NULL, 0, 0);\n  pwrite64(0, NULL, 0, 0);\n  return 0;\n}'; then
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DUSE_PREAD64 -D_LARGEFILE64_SOURCE"
    fi

    # Necessary for FTS5 on Linux
    export NIX_LDFLAGS="$NIX_LDFLAGS -lm"

    echo ""
    echo "NIX_CFLAGS_COMPILE = $NIX_CFLAGS_COMPILE"
    echo ""
  '';

  postInstall = ''
    # Do not contaminate dependent libtool-based projects with sqlite dependencies.
    sed -i $out/lib/libsqlite3.la -e "s/dependency_libs=.*/dependency_libs='''/"
  '';

  doCheck = false; # fails to link against tcl

  meta = {
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
    downloadPage = http://sqlite.org/download.html;
    homepage = http://www.sqlite.org/;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ eelco np ];
    platforms = platforms.unix ++ platforms.windows;
  };
}
