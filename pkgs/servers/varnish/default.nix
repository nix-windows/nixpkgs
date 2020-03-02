{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline, libedit
, python2, python3, makeWrapper }:

let
  common = { version, sha256, python, extraNativeBuildInputs ? [] }:
    stdenv.mkDerivation rec {
      pname = "varnish";
      inherit version;

      src = fetchurl {
        url = "https://varnish-cache.org/_downloads/${pname}-${version}.tgz";
        inherit sha256;
      };

      passthru.python = python;

      nativeBuildInputs = with python.pkgs; [ pkgconfig docutils ] ++ extraNativeBuildInputs;
      buildInputs = [
        pcre libxslt groff ncurses readline libedit makeWrapper python
      ];

      buildFlags = [ "localstatedir=/var/spool" ];

      postInstall = ''
        wrapProgram "$out/sbin/varnishd" --prefix PATH : "${stdenv.lib.makeBinPath [ stdenv.cc ]}"
      '';

      # https://github.com/varnishcache/varnish-cache/issues/1875
      NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isi686 "-fexcess-precision=standard";

      outputs = [ "out" "dev" "man" ];

      meta = with stdenv.lib; {
        description = "Web application accelerator also known as a caching HTTP reverse proxy";
        homepage = https://www.varnish-cache.org;
        license = licenses.bsd2;
        maintainers = with maintainers; [ fpletz ];
        platforms = platforms.unix;
      };
    };
in
{
  varnish4 = common {
    version = "4.1.10";
    sha256 = "08kwx0il6cqxsx3897042plh1yxjaanbaqjbspfl0xgvyvxk6j1n";
    python = python2;
  };
  varnish5 = common {
    version = "5.2.1";
    sha256 = "1cqlj12m426c1lak1hr1fx5zcfsjjvka3hfirz47hvy1g2fjqidq";
    python = python2;
  };
  varnish60 = common {
    version = "6.0.5";
    sha256 = "11aw202s7zdp5qp66hii5nhgm2jk0d86pila7gqrnjgc7x8fs8a0";
    python = python3;
    extraNativeBuildInputs = [ python3.pkgs.sphinx ];
  };
  varnish62 = common {
    version = "6.2.2";
    sha256 = "10s3qdvb95pkwp3wxndrigb892h0109yqr8dw4smrhfi0knhnfk5";
    python = python3;
    extraNativeBuildInputs = [ python3.pkgs.sphinx ];
  };
  varnish63 = common {
    version = "6.3.1";
    sha256 = "0xa14pd68zpi5hxcax3arl14rcmh5d1cdwa8gv4l5f23mmynr8ni";
    python = python3;
    extraNativeBuildInputs = [ python3.pkgs.sphinx ];
  };
}
