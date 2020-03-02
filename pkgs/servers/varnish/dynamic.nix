{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, docutils }:

if stdenv.lib.versionOlder (stdenv.lib.getVersion varnish) "6.0" then

stdenv.mkDerivation rec {
  version = "0.3";
  name = "${varnish.name}-dynamic-${version}";

  src = fetchFromGitHub {
    owner = "nigoroll";
    repo = "libvmod-dynamic";
    rev = "475be183fddbd727c3d2523f0518effa9aa881f8"; # 5.2 branch for Varnish-5.2 https://github.com/nigoroll/libvmod-dynamic/commits/5.2
    sha256 = "12a42lbv0vf6fn3qnvngw893kmbd006f8pgab4ir7irc8855xjgf";
  };

  nativeBuildInputs = [ pkgconfig docutils autoreconfHook varnish.python ];
  buildInputs = [ varnish ];
  postPatch = ''
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';
  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  meta = with stdenv.lib; {
    description = "Dynamic director similar to the DNS director from Varnish 3";
    homepage = https://github.com/nigoroll/libvmod-dynamic;
    inherit (varnish.meta) license platforms maintainers;
  };
}

else

stdenv.mkDerivation rec {
  version = "0.4";
  name = "${varnish.name}-dynamic-${version}";

  src = fetchFromGitHub {
    owner = "nigoroll";
    repo = "libvmod-dynamic";
    rev = "v${version}";
    sha256 = "1n94slrm6vn3hpymfkla03gw9603jajclg84bjhwb8kxsk3rxpmk";
  };

  nativeBuildInputs = [ pkgconfig docutils autoreconfHook varnish.python ];
  buildInputs = [ varnish ];
  postPatch = ''
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';
  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  meta = with stdenv.lib; {
    description = "Dynamic director similar to the DNS director from Varnish 3";
    homepage = https://github.com/nigoroll/libvmod-dynamic;
    inherit (varnish.meta) license platforms maintainers;
  };
}
