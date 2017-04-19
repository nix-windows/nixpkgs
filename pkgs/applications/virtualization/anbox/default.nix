{ stdenv, fetchurl, fetchFromGitHub, fetchbzr, cmake, pkgconfig, boost, libxml2, dbus, gtest, gmock
, lcov, SDL2, mesa_noglu, protobuf, lxc, glm, xorg, linuxPackages, pythonPackages, bash, coreutils
, kernel ? null, systemd }:

let
  properties-cpp = stdenv.mkDerivation rec {
    name = "properties-cpp-${rev}";
    rev = "0.0.1+14.10.20140730-0ubuntu1";
    src = fetchbzr {
      url = "http://bazaar.launchpad.net/~phablet-team/properties-cpp/trunk";
      inherit rev;
      sha256 = "03lf092r71pnvqypv5rg27qczvfbbblrrc3nz6m9mp7j4yfp012w";
    };
    nativeBuildInputs = [ cmake pkgconfig pythonPackages.gcovr lcov ];
    buildInputs = [ gtest ];
    preConfigure = ''
      substituteInPlace CMakeLists.txt --replace 'include(cmake/PrePush.cmake)' "" # skip making .deb
      # it wants writable dir with gmock sources
      cp -dr --preserve=mode ${gmock.src} ./gmocksrc
      chmod u+w -R ./gmocksrc
      ln -s googlemock ./gmocksrc/gmock
    '';
    cmakeFlags = "-DGMOCK_INSTALL_DIR=../gmocksrc";
  };

  process-cpp = stdenv.mkDerivation rec {
    name = "process-cpp-${rev}";
    rev = "3.0.1+16.10.20160616-0ubuntu1";
    src = fetchbzr {
      url = "http://bazaar.launchpad.net/~phablet-team/process-cpp/trunk";
      inherit rev;
      sha256 = "10529r9nhry80w4m2424il561xbirz7b5fx0s0sw02qcjp362afp";
    };
    nativeBuildInputs = [ cmake pkgconfig ];
    propagatedBuildInputs = [ boost properties-cpp ];
    buildInputs = [ gtest ];
    cmakeFlags = "-DGMOCK_SOURCE_DIR=${gmock.src}";
    postInstall = ''
      rm -rf $out/include/{gmock,gtest} $out/lib/lib{gmock,gtest}{,_main}.a
    '';
  };

  dbus-cpp = stdenv.mkDerivation rec {
    name = "dbus-cpp-${rev}";
    rev = "5.0.0+17.04.20170406-0ubuntu1";
    src = fetchbzr {
      url = "http://bazaar.launchpad.net/~phablet-team/dbus-cpp/trunk";
      inherit rev;
      sha256 = "0mrqh6ynj41fscrhzgagd8m9s45flvrqdacbhk8bi1337vy68m9w";
    };
    nativeBuildInputs = [ cmake pkgconfig ];
    propagatedBuildInputs = [ process-cpp libxml2 dbus ];
    buildInputs = [ gtest ];
    preConfigure = ''
      substituteInPlace CMakeLists.txt --replace 'include(cmake/PrePush.cmake)' "" # skip making .deb
    '';
    cmakeFlags = "-DDBUS_CPP_VERSION_MAJOR=5 -DDBUS_CPP_VERSION_MINOR=0 -DDBUS_CPP_VERSION_PATCH=0 -DGMOCK_SOURCE_DIR=${gmock.src}";
    NIX_CFLAGS_COMPILE = "-Wno-error";
    postInstall = ''
      rm -rf $out/include/{gmock,gtest} $out/lib/lib{gmock,gtest}{,_main}.a $out/libexec
    '';
  };

  rev = "76be0e2";
  version = "0.1.0-${rev}";
  src = fetchFromGitHub {
    owner = "anbox";
    repo = "anbox";
    inherit rev;
    sha256 = "049wyfn147y97sr53filkfmy5v7873671fvzjh98n90snnlw0h7x";
  };
  meta = with stdenv.lib; {
    homepage = "http://anbox.io";
    description = "Container based approach to boot a full Android system";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.volth ];
  };
in {
  ashmem = stdenv.mkDerivation {
    name = "anbox-ashmem-${version}";
    inherit src meta;
    sourceRoot = "anbox-${rev}-src/kernel/ashmem";
    hardeningDisable = [ "pic" ];
    makeFlags = "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build DESTDIR=$(out)";
    postInstall = ''
      mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra/anbox
      mv $out/ashmem_linux.ko $out/lib/modules/${kernel.modDirVersion}/extra/anbox/ashmem.ko
    '';
  };

  binder = stdenv.mkDerivation {
    name = "anbox-binder-${version}";
    inherit src meta;
    sourceRoot = "anbox-${rev}-src/kernel/binder";
    hardeningDisable = [ "pic" ];
    makeFlags = "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build DESTDIR=$(out)";
    postInstall = ''
      mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra/anbox
      mv $out/binder_linux.ko $out/lib/modules/${kernel.modDirVersion}/extra/anbox/binder.ko
    '';
  };

  exe = stdenv.mkDerivation {
    name = "anbox-${version}";
    inherit src meta;

    nativeBuildInputs = [ cmake pkgconfig ];
    buildInputs = [ boost SDL2 mesa_noglu glm protobuf dbus-cpp lxc gtest xorg.libpthreadstubs xorg.libXdmcp ];

    preConfigure = ''
      substituteInPlace CMakeLists.txt --replace 'add_subdirectory(tests)' "" # skip tests, they unable to find libgtest.a
    '';
    cmakeFlags = "-DCMAKE_INSTALL_LIBDIR=lib";

    postInstall = ''
      mkdir -p $out/share/dbus-1/services/
      cat <<END > $out/share/dbus-1/services/org.anbox.service
      [D-BUS Service]
      Name=org.anbox
      Exec=$out/libexec/anbox-session-manager
      END

      mkdir $out/libexec
      cat > $out/libexec/anbox-session-manager <<EOF
      #!${bash}/bin/bash
      exec $out/bin/anbox session-manager
      EOF
      chmod +x $out/libexec/anbox-session-manager

      cat > $out/bin/anbox-application-manager <<EOF
      #!${bash}/bin/bash
      ${systemd}/bin/busctl --user call \
         org.freedesktop.DBus \
         /org/freedesktop/DBus \
         org.freedesktop.DBus \
         StartServiceByName "su" org.anbox 0

      $out/bin/anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
      EOF
      chmod +x $out/bin/anbox-application-manager
    '';
  };

  image = fetchurl {
    url = "http://build.anbox.io/android-images/2017/04/12/android_1_amd64.img";
    sha256 = "1vkbz6gnvjxzxpgfzv6ssxyk877i8dgwrnh53mcg0mr970f8914p";
  };
}
