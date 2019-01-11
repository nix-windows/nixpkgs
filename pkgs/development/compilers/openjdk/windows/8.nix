{ stdenv, fetchurl, fetchzip }:
let
  jce-policies = fetchzip {
    # Ugh, unversioned URLs... I hope this doesn't change often enough to cause pain before we move to a Darwin source build of OpenJDK!
    url    = "http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    sha256 = "0303095zy8gklil1i85ch33b0nvj7wi40ymflz197jwccghkvpvg";
  };

  jdk = stdenv.mkDerivation {
    name = "zulu1.8.0_192-8.33.0.1";

    src = fetchurl {
      url = "https://cdn.azul.com/zulu/bin/zulu8.33.0.1-jdk8.0.192-win_x64.zip";
      sha256 = "08pn5v6adv2bx6v5mnhhg8yr09167d88dizcxy1jai54v7kk0wq4";
    };

    installPhase = ''
      dircopy('.',                                  $ENV{out}                                        ) or die $!;
      copyL('${jce-policies}/local_policy.jar',     "$ENV{out}/jre/lib/security/local_policy.jar"    ) or die $!;
      copyL('${jce-policies}/US_export_policy.jar', "$ENV{out}/jre/lib/security/US_export_policy.jar") or die $!;
    '';

    passthru = {
      jre = jdk;
      home = jdk;
    };

    meta.platforms = stdenv.lib.platforms.windows;
  };
in jdk
