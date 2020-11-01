{ stdenv, lib, fetchurl, pkgconfig, perl
, staticRuntime ? false # false for /MD, true for /MT
, static ? false
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
, mingwPacman
, winver ? if stdenv.is64bit then "0x0502" else "0x0501"
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
  version = "7.73.0";

  src = fetchurl {
    urls = [
      "https://curl.haxx.se/download/curl-${version}.tar.bz2"
      "https://github.com/curl/curl/releases/download/curl-${lib.replaceStrings ["."] ["_"] version}/${version}.tar.bz2"
    ];
    sha256 = {
      "7.62.0" = "084niy7cin13ba65p8x38w2xcyc54n3fgzbin40fa2shfr0ca0kq";
      "7.73.0" = "0cfi8vhvx948knia9p24w38gcj7m5a5nx6j93b0g205q0w5zwd6g";
    }.${version};
  };
in if stdenv.hostPlatform.isWindows && stdenv.cc.isMSVC then

assert stdenv.hostPlatform == stdenv.buildPlatform; # not yet tested
stdenv.mkDerivation rec {
  name = "curl-${if static then "lib" else "dll"}-${if staticRuntime then "mt" else "md"}-${version}";
  inherit src;

  buildPhase = ''
    chdir("winbuild");
    changeFile { s,/DWIN32,/DWIN32 /D_WIN32_WINNT=${winver} /DWINVER=${winver} /D_USING_V110_SDK71_,gr } 'MakefileBuild.vc';
    system("nmake /f Makefile.vc mode=${if static then "static" else "dll"}".
                               " VC=${if lib.versionAtLeast stdenv.cc.msvc.version "8" && lib.versionOlder stdenv.cc.msvc.version "9" then
                                        "8"
                                      else if lib.versionAtLeast stdenv.cc.msvc.version "14" && lib.versionOlder stdenv.cc.msvc.version "15" then
                                        "14"
                                      else
                                        throw "???"}".
                               " MACHINE=${if stdenv.is64bit then "x64" else "x86"}".
                               " ENABLE_IDN=${if stdenv.is64bit then "yes" else "no" /* IdnToUnicode() requires Windows Vista */}".
                               " ENABLE_IPV6=yes".
                               " ENABLE_SSPI=no".
                               " WITH_SSL=${if openssl.static then "static" else "dll"}".
                               " SSL_PATH=${openssl}".
                               " WITH_ZLIB=${if zlib.static then "static" else "dll"}".
                               " ZLIB_PATH=${zlib}".
                               " RTLIBCFG=${if staticRuntime then "static" else "shared"}");
  '';
  installPhase = ''
    for my $dir (glob('../builds/*')) {
      dircopy($dir, $ENV{out}) or die "dircopy($dir, $ENV{out}): $!" if -f "$dir/bin/curl.exe";
    }
  '';
  fixupPhase = lib.optionalString (!openssl.static) ''
    copyL('${openssl}/bin/libeay32.dll', "$ENV{out}/bin/LIBEAY32.dll") or die $!;  # <- todo: hardlink
    copyL('${openssl}/bin/ssleay32.dll', "$ENV{out}/bin/SSLEAY32.dll") or die $!;  # <- todo: hardlink
  '' + lib.optionalString (!zlib.static) ''
    copyL('${zlib}/bin/zlib1.dll',       "$ENV{out}/bin/zlib1.dll"   ) or die $!;  # <- todo: hardlink
  '';
  passthru.static        = static;
  passthru.staticRuntime = staticRuntime;
}

else if stdenv.hostPlatform.isWindows && stdenv.cc.isGNU then
  mingwPacman.curl
/*
stdenv.mkDerivation rec {
  name = "curl-${if static then "lib" else "dll"}-${if staticRuntime then "mt" else "md"}-${version}";
  inherit src;

  nativeBuildInputs = [ mingwPacman.cmake ]; # mingwPacman.cmake has no magic hook
  buildPhase = ''
    cmake .
  '';
  installPhase = ''
  '';
# buildPhase = ''
#   chdir("winbuild");
#   system("nmake /f Makefile.vc mode=${if static then "static" else "dll"}".
#                              " VC=${if stdenv.is64bit then "15" else "8"}".
#                              " MACHINE=${if stdenv.is64bit then "x64" else "x86"}".
#                              " ENABLE_IDN=${if stdenv.is64bit then "yes" else "no" }".
#                              " ENABLE_IPV6=yes".
#                              " ENABLE_SSPI=no".
#                              " WITH_SSL=${if openssl.static then "static" else "dll"}".
#                              " SSL_PATH=${openssl}".
#                              " WITH_ZLIB=${if zlib.static then "static" else "dll"}".
#                              " ZLIB_PATH=${zlib}".
#                              " RTLIBCFG=${if staticRuntime then "static" else "shared"}");
# '';
# installPhase = ''
#   for my $dir (glob('../builds/*')) {
#     dircopy($dir, $ENV{out}) or die "dircopy($dir, $ENV{out}): $!" if -f "$dir/bin/curl.exe";
#   }
# '';
  passthru.static        = static;
  passthru.staticRuntime = staticRuntime;
}
*/
else
  throw "xxx"
/*
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
      # Disable default CA bundle, use NIX_SSL_CERT_FILE or fallback
      # to nss-cacert from the default profile.
      "--without-ca-bundle"
      "--without-ca-path"
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
    platforms = platforms.all;
  };
}
*/