{ stdenv, lib, fetchgit
, callPackage
#, llvmPackages, makeWrapper, makeDesktopItem, ed
#, glib, gtk3, gnome3, gsettings-desktop-schemas
, gn
, ninja
# package customization
#, channel ? "stable"
#, enableNaCl ? false
#, gnomeSupport ? false, gnome ? null
#, gnomeKeyringSupport ? false
#, proprietaryCodecs ? true
#, enablePepperFlash ? false
#, enableWideVine ? false
#, cupsSupport ? true
#, pulseSupport ? false
#, commandLineArgs ? ""
}:


#assert stdenv.cc.isClang -> (stdenv == llvmPackages.stdenv);
let
#  callPackage = newScope chromium;
#
#  chromium = {
#    inherit stdenv llvmPackages;
#
#    upstream-info = (callPackage ./update.nix {}).getChannel channel;
#
#    mkChromiumDerivation = callPackage ./common.nix {
#      inherit enableNaCl gnomeSupport gnome
#              gnomeKeyringSupport proprietaryCodecs cupsSupport pulseSupport
#              enableWideVine;
#    };
#
#    browser = callPackage ./browser.nix { inherit channel; };

#   plugins = callPackage ./plugins.nix {
#     inherit enablePepperFlash enableWideVine;
#   };
#  };

# suffix = if channel != "stable" then "-" + channel else "";

  mkGnFlags =
    let
      # Serialize Nix types into GN types according to this document:
      # https://chromium.googlesource.com/chromium/src/+/master/tools/gn/docs/language.md
      mkGnString = value: "\"${lib.escape ["\"" "$" "\\"] value}\"";
      sanitize = value:
        if value == true then "true"
        else if value == false then "false"
        else if lib.isList value then "[${lib.concatMapStringsSep ", " sanitize value}]"
        else if lib.isInt value then toString value
        else if lib.isString value then mkGnString value
        else throw "Unsupported type for GN value `${value}'.";
      toFlag = key: value: "${key}=${sanitize value}";
    in attrs: lib.concatStringsSep " " (lib.attrValues (lib.mapAttrs toFlag attrs));


  gnFlags = mkGnFlags ({
#   linux_use_bundled_binutils = false;
#   use_lld = false;
#   use_gold = true;
#   gold_path = "${stdenv.cc}/bin";
    is_debug = false;
    # at least 2X compilation speedup
    use_jumbo_build = true;

    proprietary_codecs = false;
#   use_sysroot = false;
#   use_gnome_keyring = gnomeKeyringSupport;
#   use_gio = gnomeSupport;
#   enable_nacl = enableNaCl;
#   enable_widevine = enableWideVine;
#   use_cups = cupsSupport;

#   treat_warnings_as_errors = false;
#   is_clang = stdenv.cc.isClang;
#   clang_use_chrome_plugins = false;
#   remove_webcore_debug_symbols = true;
#   enable_swiftshader = false;
#   fieldtrial_testing_like_official_build = true;

    # Google API keys, see:
    #   http://www.chromium.org/developers/how-tos/api-keys
    # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
    # please get your own set of keys.
    google_api_key = "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI";
    google_default_client_id = "404761575300.apps.googleusercontent.com";
    google_default_client_secret = "9rIFQjfnkykEmqb6FfjJQD1D";
# } // optionalAttrs proprietaryCodecs {
#   # enable support for the H.264 codec
#   proprietary_codecs = true;
#   enable_hangout_services_extension = true;
#   ffmpeg_branding = "Chrome";
# } // optionalAttrs pulseSupport {
#   use_pulseaudio = true;
#   link_pulseaudio = true;
  } #// (extraAttrs.gnFlags or {})
  );

# sandboxExecutableName = chromium.browser.passthru.sandboxExecutableName;

# version = chromium.browser.version;
#git clone https://chromium.googlesource.com/angle/angle @ f2ed299569c0075e83c8f42e44345ffada9231b9 ->  third_party/angle

  deps = import ./sources-73.0.3660.2.nix { inherit fetchgit; };

in stdenv.mkDerivation rec {
  name = "chromium-${version}";
  version = "73.0.3659.1";

  unpackPhase = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (path: src: ''system('xcopy', '/E/H/B/Q/I', '${src}' =~ s|/|\\|gr, '${path}' =~ s|/|\\|gr)'') deps
  );


# depot_tools = fetchgit {
#   url = "https://chromium.googlesource.com/chromium/tools/depot_tools.git";
#   rev = "db0055dc786a71fe81e720bad2b1acb0e133a291";
#   sha256 = "0hsjq4lbylff194bz96dkyxahql7pq59bipbfv1fb32afwfr0vya";
# };
#
# src = fetchgit {
#   url = "https://chromium.googlesource.com/chromium/src.git";
#   rev = version;
#   sha256 = "000000f6pczxxwzn4pkprxw0mydxi2awxzxj9drd2s037y9dr5ka";
# };

#  buildInputs = [
#   makeWrapper ed
#
#   # needed for GSETTINGS_SCHEMAS_PATH
#   gsettings-desktop-schemas glib gtk3
#
#   # needed for XDG_ICON_DIRS
#   gnome3.defaultIconTheme
#  ];

# outputs = ["out" "sandbox"];

  buildCommand = ''
    exit(1);
    print('${gn}/bin/gn.exe gen --args=${lib.escapeWindowsArg gnFlags} out/Release');
  '';

# let
#   browserBinary = "${chromium.browser}/libexec/chromium/chromium";
#   getWrapperFlags = plugin: "$(< \"${plugin}/nix-support/wrapper-flags\")";
# in with stdenv.lib; ''
#   mkdir -p "$out/bin"
#
#   eval makeWrapper "${browserBinary}" "$out/bin/chromium" \
#     --add-flags ${escapeShellArg (escapeShellArg commandLineArgs)} \
#     ${concatMapStringsSep " " getWrapperFlags chromium.plugins.enabled}
#
#   ed -v -s "$out/bin/chromium" << EOF
#   2i
#
#   if [ -x "/run/wrappers/bin/${sandboxExecutableName}" ]
#   then
#     export CHROME_DEVEL_SANDBOX="/run/wrappers/bin/${sandboxExecutableName}"
#   else
#     export CHROME_DEVEL_SANDBOX="$sandbox/bin/${sandboxExecutableName}"
#   fi
#
#   # libredirect causes chromium to deadlock on startup
#   export LD_PRELOAD="\$(echo -n "\$LD_PRELOAD" | tr ':' '\n' | grep -v /lib/libredirect\\\\.so$ | tr '\n' ':')"
#
#   export XDG_DATA_DIRS=$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\''${XDG_DATA_DIRS:+:}\$XDG_DATA_DIRS
#
#   .
#   w
#   EOF
#
#   ln -sv "${chromium.browser.sandbox}" "$sandbox"
#
#   ln -s "$out/bin/chromium" "$out/bin/chromium-browser"
#
#   mkdir -p "$out/share/applications"
#   for f in '${chromium.browser}'/share/*; do # hello emacs */
#     ln -s -t "$out/share/" "$f"
#   done
#   cp -v "${desktopItem}/share/applications/"* "$out/share/applications"
# '';

# inherit (chromium.browser) packageName;
# meta = chromium.browser.meta // {
#   broken = if enableWideVine then
#         builtins.trace "WARNING: WideVine is not functional, please only use for testing"
#            true
#       else false;
# };

  passthru = {
#   inherit (chromium) upstream-info browser;
#   mkDerivation = chromium.mkChromiumDerivation;
#   inherit sandboxExecutableName;
    cmdline = "${gn}/bin/gn.exe gen --args=${lib.escapeWindowsArg gnFlags} out/Release";
  };
}
