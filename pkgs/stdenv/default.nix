# This file chooses a sane default stdenv given the system, platform, etc.
#
# Rather than returning a stdenv, this returns a list of functions---one per
# each bootstrapping stage. See `./booter.nix` for exactly what this list should
# contain.

{ # Args just for stdenvs' usage
  lib
  # Args to pass on to the pkgset builder, too
, localSystem, crossSystem, config, overlays
} @ args:

let
  # The native (i.e., impure) build environment.  This one uses the
  # tools installed on the system outside of the Nix environment,
  # i.e., the stuff in /bin, /usr/bin, etc.  This environment should
  # be used with care, since many Nix packages will not build properly
  # with it (e.g., because they require GNU Make).
  stagesNative = import ./native args;

  # The Nix build environment.
  stagesNix = import ./nix (args // { bootStages = stagesNative; });

  stagesFreeBSD = import ./freebsd args;

  # On Linux systems, the standard build environment consists of Nix-built
  # instances glibc and the `standard' Unix tools, i.e., the Posix utilities,
  # the GNU C compiler, and so on.
  stagesLinux = import ./linux args;

  inherit (import ./darwin args) stagesDarwin;

  stagesCross = import ./cross args;

  stagesWindowsMSVC2005 = import ./windows/msvc2005.nix args; # <-- can compile openssl, zlib, curl, but no p7zip
# stagesWindowsMSVC2008 = import ./windows/msvc2008.nix args;
  stagesWindowsMSVC2017 = import ./windows/msvc2017.nix args;
  stagesWindowsMSVC2019 = import ./windows/msvc2019.nix args;
  stagesWindowsMinGW    = import ./windows/mingw.nix    args;
# stagesMinGW = import ./mingw args;

  stagesCustom = import ./custom args;

  # Select the appropriate stages for the platform `system'.
in
/*  if localSystem.isMicrosoft then stagesWindows
  else if localSystem.isMinGW then stagesMinGW
  else*/ if crossSystem != null then stagesCross
  else if config ? replaceStdenv then stagesCustom
  else { # switch
    "i686-linux" = stagesLinux;
    "x86_64-linux" = stagesLinux;
    "armv5tel-linux" = stagesLinux;
    "armv6l-linux" = stagesLinux;
    "armv7l-linux" = stagesLinux;
    "aarch64-linux" = stagesLinux;
    "mipsel-linux" = stagesLinux;
    "powerpc-linux" = /* stagesLinux */ stagesNative;
    "powerpc64le-linux" = stagesLinux;
    "x86_64-darwin" = stagesDarwin;
    "x86_64-solaris" = stagesNix;
    "i686-cygwin" = stagesNative;
    "x86_64-cygwin" = stagesNative;
    "x86_64-freebsd" = stagesFreeBSD;
    "x86_64-windows" = stagesWindowsMSVC2019; # stagesWindowsMSVC2019 | stagesWindowsMSVC2017                                                 | stagesWindowsMinGW
    "i686-windows" = stagesWindowsMinGW;      # stagesWindowsMSVC2019 | stagesWindowsMSVC2017 | stagesWindowsMSVC2008 | stagesWindowsMSVC2005 | stagesWindowsMinGW
  }.${localSystem.system} or stagesNative
