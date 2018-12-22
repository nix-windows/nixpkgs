{ stdenv, buildPackages, fetchurl
, bzip2
, runCommand
#, gdbm
#, fetchpatch
#, ncurses
#, openssl
#, readline
#, sqlite
#, tcl ? null, tk ? null, tix ? null, xlibsWrapper ? null, libX11 ? null, x11Support ? false
#, zlib
#, callPackage
, self
#, db
#, expat
#, libffi
#, CF, configd, coreutils
#, python-setup-hook
## Some proprietary libs assume UCS2 unicode, especially on darwin :(
#, ucsEncoding ? 4
## For the Python package set
#, packageOverrides ? (self: super: {})
, withExternals ? true
}:


let
  majorVersion = "2.7";
  minorVersion = "15";
  minorVersionSuffix = "";
  version = "${majorVersion}.${minorVersion}${minorVersionSuffix}";
  libPrefix = "python${majorVersion}";
  sitePackages = "lib/${libPrefix}/site-packages";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/${majorVersion}.${minorVersion}/Python-${version}.tar.xz";
    sha256 = "0x2mvz9dp11wj7p5ccvmk9s0hzjk2fa1m462p395l4r6bfnb3n92";
  };


  # the deps are optional
  nuget-bin = fetchurl {
    url = "https://dist.nuget.org/win-x86-commandline/v4.8.1/nuget.exe";
    sha256 = "0zy3fygyakrm8jix0i4q3rzr3lhbj9g5p4jxxc1yn8k0g64av0d6";
  };
  python3-bin = runCommand "python3-bin-3.7.1" {
    preferLocalBuild = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0gwfisipw6c0qq36fhbpgnlpc1d6hgxgvkpqqjh9pxbz9a1g1ccf";
  } ''
    system("${nuget-bin} install pythonx86 -Version 3.7.1 -NoCache -Verbosity detailed -ExcludeVersion -OutputDirectory .") == 0 or die $!;
    move('pythonx86', $ENV{out}) or die $!;
  '';

  #  todo: use pkgs.
  dep-bzip2 = fetchurl {
    url = https://github.com/python/cpython-source-deps/archive/bzip2-1.0.6.zip;
    sha256 = "13cqvdmrmgwxsm32kjaxdm59q1c5fjxj7i2blxjbjrr6591x2by4";
  };
  dep-sqlite = fetchurl {
    url = https://github.com/python/cpython-source-deps/archive/sqlite-3.14.2.0.zip;
    sha256 = "107qybhfmhsxmylmb56sm15sczdfbgm74kg9mfr11p0idk3rizy1";
  };
  dep-bsddb = fetchurl {
    url = https://github.com/python/cpython-source-deps/archive/bsddb-4.7.25.0.zip;
    sha256 = "1g5b4vq34cfvqg4c8pqggf5la4f0bihxn0v1ynf1by5z5ffzgh8b";
  };
  dep-openssl = fetchurl {
    url = https://github.com/python/cpython-source-deps/archive/openssl-1.0.2o.zip;
    sha256 = "159m262wkbsirg0ycprba6dn7kgi7c5825krlhb7xdaly9ga7clx";
  };
  dep-nasm = fetchurl {
    url = https://github.com/python/cpython-bin-deps/archive/nasm-2.11.06.zip;
    sha256 = "1b5hd8k5fwpb25r6r77yka1d6xa163350scfdnc8krw0dar8fg6y";
  };
# dep-tcl = fetchurl {
#   url = https://github.com/python/cpython-source-deps/archive/tcl-8.5.19.0.zip;
#   sha256 = "0j6fk02ih4ixs4mcxzq5d63wdpgx2q5pnjcz2bn711s4vzbaf845";
# };
# dep-tk = fetchurl {
#   url = https://github.com/python/cpython-source-deps/archive/tk-8.5.19.0.zip;
#   sha256 = "1l97h4lc03bi7w1nn5fh7dz755mnck4wcz47laavc0lgrmxsp85m";
# };
# dep-tix = fetchurl {
#   url = https://github.com/python/cpython-source-deps/archive/tix-8.4.3.5.zip;
#   sha256 = "10c2zyk3bjscq4km01smwqda3ndk5156c9jyass3a66cjzgrnxph";
# };
in

stdenv.mkDerivation ({
  name = "python-${version}";
  pythonVersion = majorVersion;

  inherit majorVersion version src /*patches buildInputs nativeBuildInputs
          preConfigure configureFlags*/;
/*
    $ENV{GIT} = 'c:/git/bin/git.exe'; # BUGBUG
*/
  patches = [ ./vs2015.patch ];

  buildPhase = stdenv.lib.optionalString withExternals ''
    dircopy('${python3-bin}', 'externals/pythonx86') or die $!;
    system('7z x ${dep-bzip2       } -oexternals') == 0 or die $!;
    system('7z x ${dep-sqlite      } -oexternals') == 0 or die $!;
    system('7z x ${dep-bsddb       } -oexternals') == 0 or die $!;
    system('7z x ${dep-openssl     } -oexternals') == 0 or die $!;
    system('7z x ${dep-nasm        } -oexternals') == 0 or die $!;
    #system('7z x ''${dep-tcl         } -oexternals') == 0 or die $!;
    #system('7z x ''${dep-tk          } -oexternals') == 0 or die $!;
    #system('7z x ''${dep-tix         } -oexternals') == 0 or die $!;
    for my $f (glob('externals/*')) {
        print("f='$f'\n");
        rename($f, $f =~ s/cpython-(bin|source)-deps-//r) or die $!;
    }
  '' + ''
    for my $filename (glob('PCbuild/*.vcxproj')) {
      open(my $in, $filename) or die $!;
      open(my $out, ">$filename.new") or die $!;
      for my $line (<$in>) {
        $line =~ s|(<PropertyGroup Label="Globals">)|\1<WindowsTargetPlatformVersion>${stdenv.cc.sdk-version}</WindowsTargetPlatformVersion>|g;
        $line =~ s|ToolsVersion="4\.0"|ToolsVersion="${stdenv.cc.msbuild-version}"|g;
        print $out $line;
      }
      close($in);
      close($out);
      move("$filename.new", $filename) or die $!;
    }

    chdir('PCbuild');
    system("build.bat${if withExternals then " -e" else ""} --no-tkinter -p ${if stdenv.is64bit then "x64" else "Win32"} -c Release \"/p:PlatformToolset=v141\"") == 0 or die "build.bat: $!";
  '';

  installPhase = ''
    mkdir $ENV{out};
    mkdir "$ENV{out}/bin";
    for my $name ('python.exe', 'python.pdb', 'pythonw.exe', 'pythonw.pdb', 'python27.dll', 'python27.pdb') {
      copy("${if stdenv.is64bit then "amd64" else "win32"}/$name", "$ENV{out}/bin/" ) or die "copy $name: $!";
    }
    mkdir "$ENV{out}/DLLs";
    for my $name ('pyexpat.pyd', 'select.pyd', 'unicodedata.pyd', 'winsound.pyd',
                  '_ctypes.pyd', '_elementtree.pyd', '_msi.pyd', '_multiprocessing.pyd', '_socket.pyd',
                  ${stdenv.lib.optionalString withExternals ", 'sqlite3.dll', '_sqlite3.pyd', '_bsddb.pyd', '_hashlib.pyd', 'bz2.pyd', '_ssl.pyd'"}
                  ) {
      copy("${if stdenv.is64bit then "amd64" else "win32"}/$name", "$ENV{out}/DLLs/") or die "copy $name: $!";
    }
    mkdir "$ENV{out}/libs";
    for my $name ('pyexpat.lib', 'python27.lib', 'select.lib', 'unicodedata.lib', 'winsound.lib',
                  '_ctypes.lib', '_elementtree.lib', '_msi.lib', '_multiprocessing.lib', '_socket.lib',
                  ${stdenv.lib.optionalString withExternals ", 'sqlite3.lib', '_bsddb.lib', '_hashlib.lib', 'bz2.lib', '_ssl.lib'"}
                 ) {
      copy("${if stdenv.is64bit then "amd64" else "win32"}/$name", "$ENV{out}/libs/") or die "copy $name: $!";
    }
    dircopy('../Include', "$ENV{out}/Include") or die "dircopy Include: $!";
    dircopy('../Lib',     "$ENV{out}/Lib"    ) or die "dircopy Lib: $!";
    dircopy('../Tools',   "$ENV{out}/Tools"  ) or die "dircopy Tools: $!";
  '';
})
