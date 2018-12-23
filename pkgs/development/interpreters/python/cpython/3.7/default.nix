{ stdenv, fetchurl, fetchpatch
, bzip2
, expat
, libffi
, gdbm
, lzma
, ncurses
, openssl
, readline
, sqlite
, tcl ? null, tk ? null, tix ? null, libX11 ? null, xproto ? null, x11Support ? false
, zlib
, callPackage
, self
, CF, configd
#, git
, runCommand
, python-setup-hook
# For the Python package set
, packageOverrides ? (self: super: {})
}:

let
  majorVersion = "3.7";
  minorVersion = "1";
  minorVersionSuffix = "";
  version = "${majorVersion}.${minorVersion}${minorVersionSuffix}";
  src = fetchurl {
    url = "https://www.python.org/ftp/python/${majorVersion}.${minorVersion}/Python-${version}.tar.xz";
    sha256 = "0v9x4h22rh5cwpsq1mwpdi3c9lc9820lzp2nmn9g20llij72nzps";
  };
in

if stdenv.hostPlatform.isMicrosoft then

let
  nuget-bin = fetchurl {
    url = "https://dist.nuget.org/win-x86-commandline/v4.8.1/nuget.exe";
    sha256 = "0zy3fygyakrm8jix0i4q3rzr3lhbj9g5p4jxxc1yn8k0g64av0d6";
  };
  # TODO: fetchnuget
  python-bin = runCommand "python3-bin-${version}" {
    preferLocalBuild = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0gwfisipw6c0qq36fhbpgnlpc1d6hgxgvkpqqjh9pxbz9a1g1ccf";
  } ''
    system("${nuget-bin} install pythonx86 -Version ${version} -NoCache -Verbosity detailed -ExcludeVersion -OutputDirectory .") == 0 or die $!;
    move('pythonx86', $ENV{out}) or die $!;
  '';

  #  todo: use pkgs.
  dep-bzip2 = fetchurl {
    url = https://github.com/python/cpython-source-deps/archive/bzip2-1.0.6.zip;
    sha256 = "13cqvdmrmgwxsm32kjaxdm59q1c5fjxj7i2blxjbjrr6591x2by4";
  };
  dep-sqlite = fetchurl {
    url = https://github.com/python/cpython-source-deps/archive/sqlite-3.21.0.0.zip;
    sha256 = "084c78hq5bqpgfk85bf8nz7lwwg54vgf6h4k4d8qpdpfdbbz594m";
  };
  dep-xz = fetchurl {
    url = https://github.com/python/cpython-source-deps/archive/xz-5.2.2.zip;
    sha256 = "0gzvqcmbin1csbi8cbfkygshk7865scj9lzhw7kl169nw3qxddh2";
  };
  dep-zlib = fetchurl {
    url = https://github.com/python/cpython-source-deps/archive/zlib-1.2.11.zip;
    sha256 = "0fm6ymbf37qbnwvlj90z2y1jqmqvcj8bw2m42xcc59jzji91kfyy";
  };
  dep-openssl-bin = fetchurl {
    url = https://github.com/python/cpython-bin-deps/archive/openssl-bin-1.1.0i.zip;
    sha256 = "19s69851a8h2dizj1skzsqm5zdip5m4q3if6p9wp6c6ns9qmxnvi";
  };
  dep-tcltk = fetchurl {
    url = https://github.com/python/cpython-bin-deps/archive/tcltk-8.6.8.0.zip;
    sha256 = "1ndc01jkgfiv0dp07n2h2j8jxhm8zjkzv4q5jylmqzyl2a8qv8k3";
  };

in stdenv.mkDerivation rec {
  name = "python3-${version}";
  pythonVersion = majorVersion;
  inherit majorVersion version src;

# nativeBuildInputs = [ p7zip /*git*/ ]; # 7z in part of stdenv

  dontConfigure = true;

  buildPhase = ''
    dircopy('${python-bin}', 'externals/pythonx86') or die $!;

    system('7z x ${dep-bzip2       } -oexternals') == 0 or die $!;
    system('7z x ${dep-sqlite      } -oexternals') == 0 or die $!;
    system('7z x ${dep-xz          } -oexternals') == 0 or die $!;
    system('7z x ${dep-zlib        } -oexternals') == 0 or die $!;
    system('7z x ${dep-openssl-bin } -oexternals') == 0 or die $!;
    system('7z x ${dep-tcltk       } -oexternals') == 0 or die $!;
    for my $f (glob('externals/*')) {
        print("f='$f'\n");
        rename($f, $f =~ s/cpython-(bin|source)-deps-//r) or die $!;
    }

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
    system("build.bat -p ${if stdenv.is64bit then "x64" else "Win32"} -c Release") == 0 or die "build.bat: $!";
  '';
  installPhase = ''
    make_path("$ENV{out}/bin", "$ENV{out}/DLLs", "$ENV{out}/libs");
    for my $name ('python.exe', 'python.pdb', 'pythonw.exe', 'pythonw.pdb', 'python3.dll', 'python3.pdb', 'python37.dll', 'python37.pdb') {
      copy("${if stdenv.is64bit then "amd64" else "win32"}/$name", "$ENV{out}/bin/" ) or die "copy $name: $!";
    }
    for my $name ('libcrypto-1_1${if stdenv.is64bit then "-x64" else ""}.dll',
                  'libssl-1_1${if stdenv.is64bit then "-x64" else ""}.dll',
                  'pyexpat.pyd', 'select.pyd', 'sqlite3.dll', 'unicodedata.pyd', 'winsound.pyd', '_asyncio.pyd',
                  '_bz2.pyd', '_contextvars.pyd', '_ctypes.pyd', '_decimal.pyd', '_distutils_findvs.pyd', '_elementtree.pyd',
                  '_hashlib.pyd', '_lzma.pyd', '_msi.pyd', '_multiprocessing.pyd', '_overlapped.pyd', '_queue.pyd', '_socket.pyd',
                  '_sqlite3.pyd', '_ssl.pyd') {
      copy("${if stdenv.is64bit then "amd64" else "win32"}/$name", "$ENV{out}/DLLs/") or die "copy $name: $!";
    }
    for my $name ('pyexpat.lib', 'python3.lib', 'python37.lib', 'select.lib', 'sqlite3.lib', 'unicodedata.lib', 'winsound.lib',
                  '_asyncio.lib', '_bz2.lib', '_contextvars.lib', '_ctypes.lib', '_decimal.lib',
                 #'_distutils_findvs.lib',
                  '_elementtree.lib', '_hashlib.lib', '_lzma.lib', '_msi.lib', '_multiprocessing.lib', '_overlapped.lib',
                  '_queue.lib', '_socket.lib', '_sqlite3.lib', '_ssl.lib', '_tkinter.lib') {
      copy("${if stdenv.is64bit then "amd64" else "win32"}/$name", "$ENV{out}/libs/") or die "copy $name: $!";
    }
    dircopy('../Include', "$ENV{out}/Include") or die "dircopy Include: $!";
    dircopy('../Lib',     "$ENV{out}/Lib"    ) or die "dircopy Lib: $!";
    dircopy('../Tools',   "$ENV{out}/Tools"  ) or die "dircopy Tools: $!";
  '';
# passthru.nuget = nuget-bin;
# passthru.python-bin = python-bin;
# passthru.dep-bzip2 = dep-bzip2;
}

else

assert x11Support -> tcl != null
                  && tk != null
                  && xproto != null
                  && libX11 != null;
with stdenv.lib;

let
  libPrefix = "python${majorVersion}";
  sitePackages = "lib/${libPrefix}/site-packages";

  buildInputs = filter (p: p != null) [
    zlib bzip2 expat lzma libffi gdbm sqlite readline ncurses openssl ]
    ++ optionals x11Support [ tcl tk libX11 xproto ]
    ++ optionals stdenv.isDarwin [ CF configd ];

  hasDistutilsCxxPatch = !(stdenv.cc.isGNU or false);

in stdenv.mkDerivation {
  name = "python3-${version}";
  pythonVersion = majorVersion;
  inherit majorVersion version src;

  inherit buildInputs;

  NIX_LDFLAGS = optionalString stdenv.isLinux "-lgcc_s";

  # Determinism: We fix the hashes of str, bytes and datetime objects.
  PYTHONHASHSEED=0;

  prePatch = optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace '`/usr/bin/arch`' '"i386"'
    substituteInPlace configure --replace '-Wl,-stack_size,1000000' ' '
  '';

  patches = [
    ./no-ldconfig.patch
    # Fix darwin build https://bugs.python.org/issue34027
    (fetchpatch {
      url = https://bugs.python.org/file47666/darwin-libutil.patch;
      sha256 = "0242gihnw3wfskl4fydp2xanpl8k5q7fj4dp7dbbqf46a4iwdzpa";
    })
  ] ++ optionals hasDistutilsCxxPatch [
    # Fix for http://bugs.python.org/issue1222585
    # Upstream distutils is calling C compiler to compile C++ code, which
    # only works for GCC and Apple Clang. This makes distutils to call C++
    # compiler when needed.
    (fetchpatch {
      url = "https://bugs.python.org/file47669/python-3.8-distutils-C++.patch";
      sha256 = "0s801d7ww9yrk6ys053jvdhl0wicbznx08idy36f1nrrxsghb3ii";
    })
  ];

  postPatch = ''
  '' + optionalString (x11Support && (tix != null)) ''
    substituteInPlace "Lib/tkinter/tix.py" --replace "os.environ.get('TIX_LIBRARY')" "os.environ.get('TIX_LIBRARY') or '${tix}/lib'"
  '';

  CPPFLAGS="${concatStringsSep " " (map (p: "-I${getDev p}/include") buildInputs)}";
  LDFLAGS="${concatStringsSep " " (map (p: "-L${getLib p}/lib") buildInputs)}";
  LIBS="${optionalString (!stdenv.isDarwin) "-lcrypt"} ${optionalString (ncurses != null) "-lncurses"}";

  configureFlags = [
    "--enable-shared"
    "--with-threads"
    "--without-ensurepip"
    "--with-system-expat"
    "--with-system-ffi"
    "--with-openssl=${openssl.dev}"
  ];

  preConfigure = ''
    for i in /usr /sw /opt /pkg; do # improve purity
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
    ${optionalString stdenv.isDarwin ''
       export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -msse2"
       export MACOSX_DEPLOYMENT_TARGET=10.6
     ''}
  '';

  setupHook = python-setup-hook sitePackages;

  postInstall = ''
    # needed for some packages, especially packages that backport functionality
    # to 2.x from 3.x
    for item in $out/lib/python${majorVersion}/test/*; do
      if [[ "$item" != */test_support.py*
         && "$item" != */test/support
         && "$item" != */test/libregrtest
         && "$item" != */test/regrtest.py* ]]; then
        rm -rf "$item"
      else
        echo $item
      fi
    done
    touch $out/lib/python${majorVersion}/test/__init__.py

    ln -s "$out/include/python${majorVersion}m" "$out/include/python${majorVersion}"
    paxmark E $out/bin/python${majorVersion}

    # Python on Nix is not manylinux1 compatible. https://github.com/NixOS/nixpkgs/issues/18484
    echo "manylinux1_compatible=False" >> $out/lib/${libPrefix}/_manylinux.py

    # Determinism: Windows installers were not deterministic.
    # We're also not interested in building Windows installers.
    find "$out" -name 'wininst*.exe' | xargs -r rm -f

    # Use Python3 as default python
    ln -s "$out/bin/idle3" "$out/bin/idle"
    ln -s "$out/bin/pydoc3" "$out/bin/pydoc"
    ln -s "$out/bin/python3" "$out/bin/python"
    ln -s "$out/bin/python3-config" "$out/bin/python-config"
    ln -s "$out/lib/pkgconfig/python3.pc" "$out/lib/pkgconfig/python.pc"

    # Get rid of retained dependencies on -dev packages, and remove
    # some $TMPDIR references to improve binary reproducibility.
    # Note that the .pyc file of _sysconfigdata.py should be regenerated!
    for i in $out/lib/python${majorVersion}/_sysconfigdata*.py $out/lib/python${majorVersion}/config-${majorVersion}m*/Makefile; do
      sed -i $i -e "s|-I/nix/store/[^ ']*||g" -e "s|-L/nix/store/[^ ']*||g" -e "s|$TMPDIR|/no-such-path|g"
    done

    # Determinism: rebuild all bytecode
    # We exclude lib2to3 because that's Python 2 code which fails
    # We rebuild three times, once for each optimization level
    # Python 3.7 implements PEP 552, introducing support for deterministic bytecode.
    # This is automatically used when `SOURCE_DATE_EPOCH` is set.
    find $out -name "*.py" | $out/bin/python     -m compileall -q -f -x "lib2to3" -i -
    find $out -name "*.py" | $out/bin/python -O  -m compileall -q -f -x "lib2to3" -i -
    find $out -name "*.py" | $out/bin/python -OO -m compileall -q -f -x "lib2to3" -i -
  '';

  passthru = let
    pythonPackages = callPackage ../../../../../top-level/python-packages.nix {
      python = self;
      overrides = packageOverrides;
    };
  in rec {
    inherit libPrefix sitePackages x11Support hasDistutilsCxxPatch;
    executable = "${libPrefix}m";
    buildEnv = callPackage ../../wrapper.nix { python = self; inherit (pythonPackages) requiredPythonModules; };
    withPackages = import ../../with-packages.nix { inherit buildEnv pythonPackages;};
    pkgs = pythonPackages;
    isPy3 = true;
    isPy37 = true;
    is_py3k = true;  # deprecated
    interpreter = "${self}/bin/${executable}";
  };

  enableParallelBuilding = true;

  meta = {
    homepage = http://python.org;
    description = "A high-level dynamically-typed programming language";
    longDescription = ''
      Python is a remarkably powerful dynamic programming language that
      is used in a wide variety of application domains. Some of its key
      distinguishing features include: clear, readable syntax; strong
      introspection capabilities; intuitive object orientation; natural
      expression of procedural code; full modularity, supporting
      hierarchical packages; exception-based error handling; and very
      high level dynamic data types.
    '';
    license = licenses.psfl;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ fridh kragniz ];
  };
}
