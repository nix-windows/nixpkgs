{ stdenv, fetchurl, fetchzip, withFX ? false }:

assert withFX -> stdenv.is64bit;
let
  jce-policies = fetchzip {
    # Ugh, unversioned URLs... I hope this doesn't change often enough to cause pain before we move to a Darwin source build of OpenJDK!
    url    = "http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    sha256 = "0303095zy8gklil1i85ch33b0nvj7wi40ymflz197jwccghkvpvg";
  };

  jdk = stdenv.mkDerivation {
    inherit ({
      name = if withFX then "zulu1.8.0_192-8.33.0.1-fx" else "zulu1.8.0_201-8.34.0.1";
      src = if stdenv.is64bit then
        if withFX then
          fetchurl {
            url = "https://cdn.azul.com/zulu/bin/zulu8.33.0.1-ca-fx-jdk8.0.192-win_x64.zip";
            sha256 = "1v4vmkinf2mc4lrd320f20a6fjnj9x6svspsw61wyz6vgx2mn0d8";
          }
        else
          fetchurl {
            url = "https://cdn.azul.com/zulu/bin/zulu8.34.0.1-ca-jdk8.0.201-win_x64.zip";
            sha256 = "1fx3p7l9lh5ir6v8jpv2arg5i6y9r84z329y5ky8zjydy3iqb786";
          }
      else
        fetchurl {
          url = "https://cdn.azul.com/zulu/bin/zulu8.34.0.1-ca-jdk8.0.201-win_i686.zip";
          sha256 = "14m21n3n5a899yws3b0y583hljc9jnqnq1vz58dq132d279v9iw2";
        };
    }) name src;

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
