{ config, stdenv, lib, callPackage, fetchurl, fetchpatch, nodejs-13_x }:

let
  common = opts: callPackage (import ./common.nix opts) { nodejs = nodejs-13_x; };
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "78.0.1";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "mdO6masIpiZBvYi6kpYUTSnsOda04CUs2CL1LNf1Yad+rfY4ga4aFuLtfKqfgV5IcIIl86XeiC+0grd4irbCYg==";
    };

    patches = [
      ./no-buildconfig-ffx76.patch
    ];

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = with lib.maintainers; [ eelco andir ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
      versionKey = "ffversion";
    };
  };

  firefox-esr-78 = common rec {
    pname = "firefox-esr";
    ffversion = "78.1.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "223v796vjsvgs3yw442c8qbsbh43l1aniial05rl70hx44rh9sg108ripj8q83p5l9m0sp67x6ixd2xvifizv6461a1zra1rvbb1caa";
    };

    patches = [
      ./no-buildconfig-ffx76.patch
    ];

    meta = {
      description = "A web browser built from Firefox Extended Support Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco andir ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-78-unwrapped";
      versionKey = "ffversion";
    };
  };

  firefox-esr-68 = common rec {
    pname = "firefox-esr";
    ffversion = "68.11.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "0zg41jnbnpsa07xaizwfsmfav0cgxdqnh8i4yanxy49a45gigk895zqrx2if7pfsmdnj9zpwj9prj8cpnpsfhv6p62f3g2596aa9kvx";
    };

    patches = [
      ./no-buildconfig-ffx65.patch
    ];

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-68-unwrapped";
      versionSuffix = "esr";
      versionKey = "ffversion";
    };
  };
} // lib.optionalAttrs (config.allowAliases or false) {
  #### ALIASES
  #### remove after 20.03 branchoff

  firefox-esr-52 = throw ''
    firefoxPackages.firefox-esr-52 was removed as it's an unsupported ESR with
    open security issues. If you need it because you need to run some plugins
    not having been ported to WebExtensions API, import it from an older
    nixpkgs checkout still containing it.
  '';
  firefox-esr-60 = throw "firefoxPackages.firefox-esr-60 was removed as it's an unsupported ESR with open security issues.";

  icecat = throw "firefoxPackages.icecat was removed as even its latest upstream version is based on an unsupported ESR release with open security issues.";
  icecat-52 = throw "firefoxPackages.icecat was removed as even its latest upstream version is based on an unsupported ESR release with open security issues.";

  tor-browser-7-5 = throw "firefoxPackages.tor-browser-7-5 was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";
  tor-browser-8-5 = throw "firefoxPackages.tor-browser-8-5 was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";
  tor-browser = throw "firefoxPackages.tor-browser was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";

}
