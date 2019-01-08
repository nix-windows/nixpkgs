{ stdenv, lib, fetchurl, pkgconfig, perl
, http2Support ? true, nghttp2
, idnSupport ? false, libidn ? null
, ldapSupport ? false, openldap ? null
, zlibSupport ? true, zlib ? null
, sslSupport ? zlibSupport, openssl ? null
, gnutlsSupport ? false, gnutls ? null
, scpSupport ? zlibSupport && !stdenv.isSunOS && !stdenv.isCygwin, libssh2 ? null
, gssSupport ? !stdenv.hostPlatform.isWindows, libkrb5 ? null
, c-aresSupport ? false, c-ares ? null
, brotliSupport ? false, brotli ? null
}:

assert http2Support -> nghttp2 != null;
assert idnSupport -> libidn != null;
assert ldapSupport -> openldap != null;
assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert !(gnutlsSupport && sslSupport);
assert gnutlsSupport -> gnutls != null;
assert scpSupport -> libssh2 != null;
assert c-aresSupport -> c-ares != null;
assert brotliSupport -> brotli != null;
assert gssSupport -> libkrb5 != null;

let
  name = "curl-7.59.0";

  src = fetchurl {
    urls = [
      "https://github.com/curl/curl/releases/download/${lib.replaceStrings ["."] ["_"] name}/${name}.tar.bz2"
      "https://curl.haxx.se/download/${name}.tar.bz2"
    ];
    sha256 = "185mazhi4bc5mc6rvhrmnc67j8l3sg7f0w2hp5gmi5ccdbyhz4mm";
  };

in if stdenv.hostPlatform.isMicrosoft then
stdenv.mkDerivation rec {
  inherit name src;

  buildPhase = ''
    chdirL("winbuild");
    # TODO? buildenv
    make_pathL("devel/include", "devel/lib");
    dircopy('${zlib}/lib/*',        'devel/lib/'    );
    dircopy('${zlib}/include/*',    'devel/include/');
    dircopy('${openssl}/lib/*',     'devel/lib/'    );
    dircopy('${openssl}/include/*', 'devel/include/');
    system("nmake /f Makefile.vc mode=dll VC=15 USE_SSL=true USE_SSPI=false WITH_SSL=dll WITH_ZLIB=dll WITH_DEVEL=./devel") == 0 or die;
  '';
  installPhase = ''
    for my $dir (glob('../builds/*')) {
      dircopy($dir, $ENV{out}) or die "dircopy($dir, $ENV{out}): $!" if -f "$dir/bin/curl.exe";
    }
    copyL('${openssl}/bin/libeay32.dll', "$ENV{out}/bin/LIBEAY32.dll") or die $!;
    copyL('${openssl}/bin/ssleay32.dll', "$ENV{out}/bin/SSLEAY32.dll") or die $!;
    copyL('${zlib}/bin/zlib1.dll',       "$ENV{out}/bin/zlib1.dll"   ) or die $!;
  '';
}
else
stdenv.mkDerivation rec {
  inherit name src;

  outputs = [ "bin" "dev" "out" "man" "devdoc" ];
  separateDebugInfo = stdenv.isLinux;

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig perl ];

  # Zlib and OpenSSL must be propagated because `libcurl.la' contains
  # "-lz -lssl", which aren't necessary direct build inputs of
  # applications that use Curl.
  propagatedBuildInputs = with stdenv.lib;
    optional http2Support nghttp2 ++
    optional idnSupport libidn ++
    optional ldapSupport openldap ++
    optional zlibSupport zlib ++
    optional gssSupport libkrb5 ++
    optional c-aresSupport c-ares ++
    optional sslSupport openssl ++
    optional gnutlsSupport gnutls ++
    optional scpSupport libssh2 ++
    optional brotliSupport brotli;

  # for the second line see https://curl.haxx.se/mail/tracker-2014-03/0087.html
  preConfigure = ''
    sed -e 's|/usr/bin|/no-such-path|g' -i.bak configure
    rm src/tool_hugehelp.c
  '';

  configureFlags = [
      "--with-ca-fallback"
      "--disable-manual"
      ( if sslSupport then "--with-ssl=${openssl.dev}" else "--without-ssl" )
      ( if gnutlsSupport then "--with-gnutls=${gnutls.dev}" else "--without-gnutls" )
      ( if scpSupport then "--with-libssh2=${libssh2.dev}" else "--without-libssh2" )
      ( if ldapSupport then "--enable-ldap" else "--disable-ldap" )
      ( if ldapSupport then "--enable-ldaps" else "--disable-ldaps" )
      ( if idnSupport then "--with-libidn=${libidn.dev}" else "--without-libidn" )
      ( if brotliSupport then "--with-brotli" else "--without-brotli" )
    ]
    ++ stdenv.lib.optional c-aresSupport "--enable-ares=${c-ares}"
    ++ stdenv.lib.optional gssSupport "--with-gssapi=${libkrb5.dev}"
       # For the 'urandom', maybe it should be a cross-system option
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
       "--with-random=/dev/urandom"
    ++ stdenv.lib.optionals stdenv.hostPlatform.isWindows [
      "--disable-shared"
      "--enable-static"
    ];

  CXX = "${stdenv.cc.targetPrefix}c++";
  CXXCPP = "${stdenv.cc.targetPrefix}c++ -E";

  doCheck = false; # expensive, fails

  postInstall = ''
    moveToOutput bin/curl-config "$dev"
    sed '/^dependency_libs/s|${libssh2.dev}|${libssh2.out}|' -i "$out"/lib/*.la
  '' + stdenv.lib.optionalString gnutlsSupport ''
    ln $out/lib/libcurl.so $out/lib/libcurl-gnutls.so
    ln $out/lib/libcurl.so $out/lib/libcurl-gnutls.so.4
    ln $out/lib/libcurl.so $out/lib/libcurl-gnutls.so.4.4.0
  '';

  passthru = {
    inherit sslSupport openssl;
  };

  meta = with stdenv.lib; {
    description = "A command line tool for transferring files with URL syntax";
    homepage    = https://curl.haxx.se/;
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.curl;
    platforms   = platforms.all;
  };
}
