{ stdenv, fetchurlBoot, nss, python, python3
, blacklist ? []
, includeEmail ? false
}:

with stdenv.lib;

let

  certdata2pem = fetchurlBoot {
    name = "certdata2pem.py";
    url = "https://salsa.debian.org/debian/ca-certificates/raw/debian/20170717/mozilla/certdata2pem.py";
    sha256 = "1d4q27j1gss0186a5m8bs5dk786w07ccyq0qi6xmd2zr1a8q16wy";
  };

in

if stdenv.hostPlatform.isMicrosoft then

stdenv.mkDerivation rec {
  name = "nss-cacert-${nss.version}";

  src = nss.src;

  nativeBuildInputs = [ python3 ];

    #   ln -s nss/lib/ckfw/builtins/certdata.txt
    #
    #   cat << EOF > blacklist.txt
    #   ${concatStringsSep "\n" (map (c: ''"${c}"'') blacklist)}
    #   EOF
    #
  configurePhase = ''
    copy('nss/lib/ckfw/builtins/certdata.txt', 'certdata.txt');
    copy('${certdata2pem}', 'certdata2pem.py');
  '';
    #   patch -p1 < ${./fix-unicode-ca-names.patch}
    #   ${optionalString includeEmail ''
    #     # Disable CAs used for mail signing
    #     substituteInPlace certdata2pem.py --replace \[\'CKA_TRUST_EMAIL_PROTECTION\'\] '''
    #   ''}

  buildPhase = ''
    system('python certdata2pem.py') == 0 or die;

    open(my $bundle, '>ca-bundle') or die $!;
    binmode $bundle;
    for my $filename (glob('*.crt')) {
      local $/ = undef;
      open (my $cert, $filename) or die $!;
      my $content = <$cert>;
      close($cert);
      print $bundle ($filename =~ s/^([^.]+)\.crt$/\1/r =~ s/_/ /rg)."\n";
      print $bundle $content;
      print $bundle "\n";
    }
  '';

  installPhase = ''
    make_path("$ENV{out}/etc/ssl/certs");
    copy('ca-bundle', "$ENV{out}/etc/ssl/certs/ca-bundle.crt");
  '';
    #   # install individual certs in unbundled output
    #   mkdir -pv $unbundled/etc/ssl/certs
    #   cp -v *.crt $unbundled/etc/ssl/certs
    #   rm -f $unbundled/etc/ssl/certs/ca-bundle.crt  # not wanted in unbundled

  #setupHook = ./setup-hook.sh;
}


else

stdenv.mkDerivation rec {
  name = "nss-cacert-${nss.version}";

  src = nss.src;

  outputs = [ "out" "unbundled" ];

  nativeBuildInputs = [ python ];

  configurePhase = ''
    ln -s nss/lib/ckfw/builtins/certdata.txt

    cat << EOF > blacklist.txt
    ${concatStringsSep "\n" (map (c: ''"${c}"'') blacklist)}
    EOF

    cat ${certdata2pem} > certdata2pem.py
    patch -p1 < ${./fix-unicode-ca-names.patch}
    ${optionalString includeEmail ''
      # Disable CAs used for mail signing
      substituteInPlace certdata2pem.py --replace \[\'CKA_TRUST_EMAIL_PROTECTION\'\] '''
    ''}
  '';

  buildPhase = ''
    python certdata2pem.py | grep -vE '^(!|UNTRUSTED)'

    for cert in *.crt; do
      echo $cert | cut -d. -f1 | sed -e 's,_, ,g' >> ca-bundle.crt
      cat $cert >> ca-bundle.crt
      echo >> ca-bundle.crt
    done
  '';

  installPhase = ''
    mkdir -pv $out/etc/ssl/certs
    cp -v ca-bundle.crt $out/etc/ssl/certs
    # install individual certs in unbundled output
    mkdir -pv $unbundled/etc/ssl/certs
    cp -v *.crt $unbundled/etc/ssl/certs
    rm -f $unbundled/etc/ssl/certs/ca-bundle.crt  # not wanted in unbundled
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = https://curl.haxx.se/docs/caextract.html;
    description = "A bundle of X.509 certificates of public Certificate Authorities (CA)";
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
