{ stdenv, fetchurl, buildPackages, perl, coreutils
, withCryptodev ? false, cryptodev
, enableSSL2 ? false
, staticRuntime ? false # false for /MD, true for /MT
, static ? false
, mingwPacman
}:

with stdenv.lib;

let
  common = args@{ version, sha256, patches ? [] }: let
    name = "openssl-${if static then "lib" else "dll"}-${if staticRuntime then "mt" else "md"}-${version}";

    src = fetchurl {
      url = "https://www.openssl.org/source/${name}.tar.gz";
      inherit sha256;
    };

    meta = with stdenv.lib; {
      homepage = https://www.openssl.org/;
      description = "A cryptographic library that implements the SSL and TLS protocols";
      license = licenses.openssl;
      platforms = platforms.all;
      maintainers = [ maintainers.peti ];
      priority = 10; # resolves collision with ‘man-pages’
    };

  in if stdenv.hostPlatform.isWindows then stdenv.mkDerivation rec {
    inherit name version src meta;

    patches = args.patches;

    nativeBuildInputs = [ perl ] ++ stdenv.lib.optional (!stdenv.is64bit && versionAtLeast version "1.1.0") mingwPacman.nasm;

    configureFlags = [
      "shared" # "shared" builds both shared and static libraries
      "--libdir=lib"
      "--openssldir=etc/ssl"
    ] ++ stdenv.lib.optionals withCryptodev [
      "-DHAVE_CRYPTODEV"
      "-DUSE_CRYPTODEV_DIGESTS"
    ] ++ stdenv.lib.optional enableSSL2 "enable-ssl2"
      ++ stdenv.lib.optional (versionAtLeast version "1.1.0" && stdenv.hostPlatform.isAarch64) "no-afalgeng";

#   print("PATH=$ENV{PATH}\n");
    configurePhase =
      if (versionOlder version "1.1.0") then
        if stdenv.is64bit then ''
          system("perl Configure VC-WIN64A       --prefix=$ENV{out} $ENV{configureFlags}");
        '' else ''
          system("perl Configure VC-WIN32 no-asm --prefix=$ENV{out} $ENV{configureFlags}");
        ''
      else
        if stdenv.is64bit then ''
          system("perl Configure VC-WIN64A-masm  --prefix=$ENV{out} $ENV{configureFlags}");
        '' else ''
          system("perl Configure VC-WIN32        --prefix=$ENV{out} $ENV{configureFlags}");
        '';

    buildPhase =
      if (versionOlder version "1.1.0") then ''
        system('ms\${if stdenv.is64bit then "do_win64a" else "do_ms"}') == 0 or die "$!";
        ${stdenv.lib.optionalString staticRuntime "changeFile { s|\\bMD\\b|MT|gr; } 'ms/ntdll.mak';"}
        system('nmake -f ms\ntdll.mak') == 0 or die "nmake failed: $!";
      '' else ''
        ${stdenv.lib.optionalString staticRuntime "changeFile { s|\\bMD\\b|MT|gr; } 'makefile';"}
        system('nmake') == 0 or die "nmake failed: $!";
      '';

    doCheck = true;
    checkPhase = if (versionOlder version "1.1.0") then ''
      system('nmake -f ms\ntdll.mak test') == 0 or die "nmake failed: $!";
    '' else ''
      system('nmake test') == 0 or die "nmake failed: $!";
    '';

    installPhase = if (versionOlder version "1.1.0") then ''
      system('nmake -f ms\ntdll.mak install') == 0 or die "nmake failed: $!";
    '' else ''
      system('nmake install') == 0 or die "nmake failed: $!";
    '';

    passthru.static        = static;
    passthru.staticRuntime = staticRuntime;
  }
  else stdenv.mkDerivation rec {
    inherit name version src meta;

    patches =
      (args.patches or [])
      ++ [ ./nix-ssl-cert-file.patch ]
      ++ optional (versionOlder version "1.1.0")
          (if stdenv.hostPlatform.isDarwin then ./use-etc-ssl-certs-darwin.patch else ./use-etc-ssl-certs.patch)
      ++ optional (versionOlder version "1.0.2" && stdenv.hostPlatform.isDarwin)
           ./darwin-arch.patch;

    postPatch = ''
      patchShebangs Configure
    '' + optionalString (versionOlder version "1.1.0") ''
      patchShebangs test/*
      for a in test/t* ; do
        substituteInPlace "$a" \
          --replace /bin/rm rm
      done
    '' + optionalString (versionAtLeast version "1.1.1") ''
      substituteInPlace config --replace '/usr/bin/env' '${coreutils}/bin/env'
    '' + optionalString (versionAtLeast version "1.1.0" && stdenv.hostPlatform.isMusl) ''
      substituteInPlace crypto/async/arch/async_posix.h \
        --replace '!defined(__ANDROID__) && !defined(__OpenBSD__)' \
                  '!defined(__ANDROID__) && !defined(__OpenBSD__) && 0'
    '';

    outputs = [ "bin" "dev" "out" "man" ];
    setOutputFlags = false;
    separateDebugInfo = stdenv.hostPlatform.isLinux;

    nativeBuildInputs = [ perl ];
    buildInputs = stdenv.lib.optional withCryptodev cryptodev;

    # TODO(@Ericson2314): Improve with mass rebuild
    configurePlatforms = [];
    configureScript = {
        "x86_64-darwin"  = "./Configure darwin64-x86_64-cc";
        "x86_64-solaris" = "./Configure solaris64-x86_64-gcc";
        "armv6l-linux" = "./Configure linux-armv4 -march=armv6";
        "armv7l-linux" = "./Configure linux-armv4 -march=armv7-a";
      }.${stdenv.hostPlatform.system} or (
        if stdenv.hostPlatform == stdenv.buildPlatform
          then "./config"
        else if stdenv.hostPlatform.isMinGW
          then "./Configure mingw${optionalString
                                     (stdenv.hostPlatform.parsed.cpu.bits != 32)
                                     (toString stdenv.hostPlatform.parsed.cpu.bits)}"
        else if stdenv.hostPlatform.isLinux
          then "./Configure linux-generic${toString stdenv.hostPlatform.parsed.cpu.bits}"
        else if stdenv.hostPlatform.isiOS
          then "./Configure ios${toString stdenv.hostPlatform.parsed.cpu.bits}-cross"
        else
          throw "Not sure what configuration to use for ${stdenv.hostPlatform.config}"
      );

    configureFlags = [
      "shared" # "shared" builds both shared and static libraries
      "--libdir=lib"
      "--openssldir=etc/ssl"
    ] ++ stdenv.lib.optionals withCryptodev [
      "-DHAVE_CRYPTODEV"
      "-DUSE_CRYPTODEV_DIGESTS"
    ] ++ stdenv.lib.optional enableSSL2 "enable-ssl2"
      ++ stdenv.lib.optional (versionAtLeast version "1.1.0" && stdenv.hostPlatform.isAarch64) "no-afalgeng";

    makeFlags = [ "MANDIR=$(man)/share/man" ];

    enableParallelBuilding = true;

    postInstall =
    stdenv.lib.optionalString (!static) ''
      # If we're building dynamic libraries, then don't install static
      # libraries.
      if [ -n "$(echo $out/lib/*.so $out/lib/*.dylib $out/lib/*.dll)" ]; then
          rm "$out/lib/"*.a
      fi

    '' +
    ''
      mkdir -p $bin
      mv $out/bin $bin/

      mkdir $dev
      mv $out/include $dev/

      # remove dependency on Perl at runtime
      rm -r $out/etc/ssl/misc

      rmdir $out/etc/ssl/{certs,private}
    '';

    postFixup = ''
      # Check to make sure the main output doesn't depend on perl
      if grep -r '${buildPackages.perl}' $out; then
        echo "Found an erroneous dependency on perl ^^^" >&2
        exit 1
      fi
    '';
  };

in {

  openssl_1_0_2 = common {
    version = "1.0.2u";
    sha256 = "05lxcs4hzyfqd5jn0d9p0fvqna62v2s4pc9qgmq0dpcknkzwdl7c";
    patches = [ ./1.0.2/nix-ssl-cert-file.patch ];
  };

  openssl_1_1 = common {
    version = "1.1.1g";
    sha256 = "0ikdcc038i7jk8h7asq5xcn8b1xc2rrbc88yfm4hqbz3y5s4gc6x";
    patches = [ ./1.1/nix-ssl-cert-file.patch ];
  };

}
