{ lib, stdenv, fetchurlBoot
}:

with lib;

let
  meta = {
    homepage = https://www.perl.org/;
    description = "The standard implementation of the Perl 5 programmming language";
    license = licenses.artistic1;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };

  common = { version, sha256 }:
    let
      name = "perl-${version}";
      src = fetchurlBoot {
        url = "mirror://cpan/src/5.0/${name}.tar.gz";
        inherit sha256;
      };
    in if stdenv.hostPlatform.isMicrosoft && stdenv.cc.isMSVC then
      stdenv.mkDerivation rec {
        inherit name version src meta;
        disallowedReferences = [ stdenv.cc /*stdenv.cc.msvc*/ ]; # <- FIXME, the must not me reference to huge stdenv.cc.msvc (they are mostly in .pdb and .lib files)
        dontConfigure = true;
        # PROCESSOR_ARCHITECTURE needs for cross-compilation; should it be buildPlatform's or hostPlatform's ?
        buildPhase = ''
          chdir('win32');
          system("nmake install INST_TOP=$ENV{out} CCTYPE=${if lib.versionAtLeast stdenv.cc.msvc.version "8" && lib.versionOlder stdenv.cc.msvc.version "9" then
                                                              "MSVC80"
                                                            else if lib.versionAtLeast stdenv.cc.msvc.version "14.10" && lib.versionOlder stdenv.cc.msvc.version "14.20" then
                                                              "MSVC141"
                                                            else if lib.versionAtLeast stdenv.cc.msvc.version "14.20" && lib.versionOlder stdenv.cc.msvc.version "14.30" then
                                                              "MSVC142"
                                                            else
                                                              throw "???"} ${if stdenv.is64bit then "WIN64=define PROCESSOR_ARCHITECTURE=AMD64" else "WIN64=undef PROCESSOR_ARCHITECTURE=X86"} BUILD_STATIC=define");
        '';
        # todo: common hook looking for missing dlls and copying/hardlinking them into %out%/bin/
        fixupPhase = lib.optionalString (lib.versionAtLeast stdenv.cc.msvc.version "14.10" && lib.versionOlder stdenv.cc.msvc.version "14.20") ''
          copyL('${stdenv.cc.redist}/${if stdenv.is64bit then "x64" else "x86"}/Microsoft.VC141.CRT/vcruntime140.dll'   => "$ENV{out}/bin/vcruntime140.dll"  );
        '' + lib.optionalString (lib.versionAtLeast stdenv.cc.msvc.version "14.20" && lib.versionOlder stdenv.cc.msvc.version "14.30") ''
          copyL('${stdenv.cc.redist}/${if stdenv.is64bit then "x64" else "x86"}/Microsoft.VC142.CRT/vcruntime140.dll'   => "$ENV{out}/bin/vcruntime140.dll"  );
          copyL('${stdenv.cc.redist}/${if stdenv.is64bit then "x64" else "x86"}/Microsoft.VC142.CRT/vcruntime140_1.dll' => "$ENV{out}/bin/vcruntime140_1.dll");
        '';
        setupHook = ./setup-hook.pl;
        passthru.libPrefix = "lib";
#       doCheck = false; # some tests fail, expensive
      }
    else if stdenv.hostPlatform.isMicrosoft && stdenv.cc.isGNU then
      stdenv.mkDerivation rec {
        inherit name version src meta;
        disallowedReferences = [ stdenv.cc stdenv.cc.cc ];
        dontConfigure = true;
        patches = [ ../../../stdenv/windows/perl-on-gcc10.patch ];
        buildPhase = ''
          chdir('win32');
          system("make.exe -j$ENV{NIX_BUILD_CORES} -f GNUmakefile install PLMAKE=make.exe INST_TOP=$ENV{out} CCTYPE=GCC ${if stdenv.is64bit then "WIN64=define GCCTARGET=x86_64-w64-mingw32" else "WIN64=undef GCCTARGET=i686-w64-mingw32"}");
        '';
        # todo: common hook looking for missing dlls and copying/hardlinking them into %out%/bin/
        fixupPhase = ''
          copyL("${stdenv.cc.redist}/mingw${if stdenv.is64bit then "64" else "32"}/bin/libgcc_s_dw2-1.dll"  => "$ENV{out}/bin/libgcc_s_dw2-1.dll" ); # TODO: hardlink
          copyL("${stdenv.cc.redist}/mingw${if stdenv.is64bit then "64" else "32"}/bin/libstdc++-6.dll"     => "$ENV{out}/bin/libstdc++-6.dll"    ); # TODO: hardlink
          copyL("${stdenv.cc.redist}/mingw${if stdenv.is64bit then "64" else "32"}/bin/libwinpthread-1.dll" => "$ENV{out}/bin/libwinpthread-1.dll"); # TODO: hardlink
        '';
        setupHook = ./setup-hook.pl;
        passthru.libPrefix = "lib";
      }
    else
      throw "???";

in rec {

  # the latest Maint version
  perl532 = common {
    version = "5.32.0";
    sha256 = "1d6001cjnpxfv79000bx00vmv2nvdz7wrnyas451j908y7hirszg";
  };

  # the latest Devel version
  perldevel = common {
    version = "5.33.3";
    sha256 = "1k9pyy8d3wx8cpp5ss7hjwf9sxgga5gd0x2nq3vnqblkxfna0jsg";
  };
}
