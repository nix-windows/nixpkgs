{ fetchurl, stdenv, buildPackages
, curl, openssl, zlib, expat, perl, python, gettext, cpio
, writeTextFile
, gnugrep, gnused, gawk, coreutils # needed at runtime by git-filter-branch etc
, openssh, pcre2
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_45
, libxslt, tcl, tk, makeWrapper, libiconv
, svnSupport, subversionClient, perlLibs, smtpPerlLibs
, perlSupport ? true
, guiSupport
, withManual ? true
, pythonSupport ? true
, withpcre2 ? true
, sendEmailSupport
, darwin
, withLibsecret ? false
, pkgconfig, glib, libsecret
}:

assert sendEmailSupport -> perlSupport;
assert svnSupport -> perlSupport;

let
  version = "2.19.1";
  name = "git-${version}";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/scm/git/git-${version}.tar.xz";
    sha256 = "1dfv43lmdnxz42504jc89sihbv1d4d6kgqcz3c5ji140kfm5cl1l";
  };

  svn = subversionClient.override { perlBindings = perlSupport; };
in

if stdenv.hostPlatform.isMicrosoft then

#let
#  gnumake = fetchurl/*Boot*/ {
#    url = https://raw.githubusercontent.com/mbuilov/gnumake-windows/master/gnumake-4.2.1-x64.exe;
#    sha256 = "0fly79df9330im0r4xr25d5yi46kr23p5s9mybjfz28v930n2zx5";
#  };
#in
stdenv.mkDerivation {
  inherit name version src;

# src = ../../../../../../t/git-2.19.1;

  nativeBuildInputs = [ perl ];

  dontConfigure = true;

  buildPhase = ''
    my %defines = (
      'WIN32'                       => "",
      'NO_MBSUPPORT'                => "",
      'NO_NSEC'                     => "",
      'NO_SYS_POLL_H'               => "",
      'NO_POLL'                     => "",
      'NO_ICONV'                    => "",
      'USE_WIN32_MMAP'              => "",
      'NO_GETTEXT'                  => "",
      'NO_LIBGEN_H'                 => "",
      'GAWK'                        => "",
      'MAX_PATH'                    => '260',
      'O_ACCMODE'                   => '(O_RDONLY|O_WRONLY|O_RDWR)',
      'sigset_t'                    => 'int',
      'bool'                        => 'int',
      'false'                       => '0',
      'true'                        => '1',
      'ftello'                      => 'ftell',
      'PROTECT_NTFS_DEFAULT'        => '1',
      'OBJECT_CREATION_MODE'        => '1',
      'NO_POSIX_GOODIES'            => "",
      'NO_ST_BLOCKS_IN_STRUCT_STAT' => "",
      'NO_PREAD'                    => "",
      'NO_STRLCPY'                  => "",
      'NO_MEMMEM'                   => "",
      'NO_MKDTEMP'                  => "",
      'NO_SETENV'                   => "",
      'NO_STRCASESTR'               => "",
      'NO_STRTOUMAX'                => "",
      'NOGDI'                       => "",
      'UNRELIABLE_FSTAT'            => "",
      'RUNTIME_PREFIX'              => "",
      'SHA1_BLK'                    => "",
      'HAVE_ALLOCA_H'               => "",
      'HAVE_STRING_H'               => "",
      'HAVE_WPGMPTR'                => "",
      'SNPRINTF_RETURNS_BOGUS'      => "",
      'NATIVE_CRLF'                 => "",
      'BINDIR'                      => '"bin"',
      'GIT_EXEC_PATH'               => '"$ENV{out}/bin"',
     #'GIT_EXEC_PATH'               => '"$ENV{out}/libexec/git-core"',
      'FALLBACK_RUNTIME_PREFIX'     => '"C:/git"',
      'PAGER_ENV'                   => '"LESS=FRX"',
      'GIT_HOST_CPU'                => '"x86_64"',
      'STRIP_EXTENSION'             => '".exe"',
      'ETC_GITCONFIG'               => '"$ENV{out}/etc/gitconfig"',
      'ETC_GITATTRIBUTES'           => '"$ENV{out}/etc/gitattributes"',
      'GIT_HTML_PATH'               => '"$ENV{out}/share/doc/git-doc"',
      'GIT_INFO_PATH'               => '"$ENV{out}/share/info"',
      'GIT_MAN_PATH'                => '"$ENV{out}/share/man"',
      'GIT_VERSION'                 => '"2.19.1.MSVC"',
      'GIT_USER_AGENT'              => '"git/2.19.1.MSVC"',
      'GIT_BUILT_FROM_COMMIT'       => '"-"',
      'NTDDI_VERSION'               => '0');

      $ENV{INCLUDE}=".;compat;compat/poll;compat/regex;compat/vcbuild;compat/vcbuild/include;compat/win32;${openssl}/include;${zlib}/include;${curl}/include";
      my @libgit_srcs = (
        "block-sha1/sha1.c",
        "compat/basename.c",
        "compat/inet_ntop.c",
        "compat/inet_pton.c",
        "compat/memmem.c",
        "compat/mkdtemp.c",
        "compat/msvc.c",
        "compat/obstack.c",
        "compat/poll/poll.c",
        "compat/pread.c",
        "compat/qsort_s.c",
        "compat/regex/regex.c",
        "compat/setenv.c",
        "compat/snprintf.c",
        "compat/strcasestr.c",
        "compat/strlcpy.c",
        "compat/strtoimax.c",
        "compat/strtoumax.c",
        "compat/terminal.c",
        "compat/win32mmap.c",
        "compat/win32/dirent.c",
        "compat/win32/pthread.c",
        "compat/win32/syslog.c",
        "compat/winansi.c",
        glob("ewah/*.c"),
        glob("negotiator/*.c"),
        glob("refs/*.c"),
        grep { $_ !~ /(imap-send|credential-cache--daemon|check-racy|shell|credential-store|http-push|sh-i18n--envsubst|fast-import|common-main|sha1dc_git|http-walker|http|daemon|unix-socket|credential-cache|http-fetch|http-backend|remote-curl|remote-testsvn|git)\.c/ } glob('*.c'));
      my @xdiff_srcs = glob("xdiff/*.c");
      my @git_srcs = (glob("builtin/*.c"), "common-main.c", "git.c");
      my @git_remote_http_srcs = ("common-main.c", "http-walker.c", "http.c", "remote-curl.c");

      # `./command-list.h` needs `bash` to generate (todo: do it once `stdenvMinGW` will work)
      copy('${./command-list-2.19.1.h}', './command-list.h') or die;

      # fetch-pack does `close(1)` so the receiving party gets unexpected EOF
      # TODO: use .patch
      copy('${./fetch-pack.c}', './builtin/fetch-pack.c') or die;

      # VS2017's msvcrt.lib has no __wgetmainargs
      open(my $fh, ">>compat/mingw.c");
      print $fh 'int __wgetmainargs(int *argc, wchar_t ***argv, wchar_t ***env, int glob, _startupinfo *si) {';
      print $fh '  /* this is unrelated to __wgetmainargs, just an early startup code to fix zero _wpgmptr; needless with GIT_EXEC_PATH? */';
      print $fh '  if (_wpgmptr == NULL) {';
      print $fh '    static wchar_t wpgmptrbuf[0x400];';
      print $fh '    assert(GetModuleFileNameW(NULL, wpgmptrbuf, 0x400) < 0x400);';
      print $fh '    _wpgmptr = wpgmptrbuf;';
      print $fh '  }';
      print $fh '  int (*pfn)(int *, wchar_t ***, wchar_t ***, int, _startupinfo *);';
      print $fh '  pfn = GetProcAddress(LoadLibrary("msvcrt"), "__wgetmainargs");';
      print $fh '  assert(pfn);';
      print $fh '  return pfn(argc, argv, env, glob, si);';
      print $fh '}';
      close($fh);

      mkdir('xdiffobjs') or die $!;
      my @cmd = ("cl.exe", '-c', '-MD', '-Zi', '-GL', '-Fo:xdiffobjs/',  (map { '"' . ("-D$_=$defines{$_}" =~ s/"/"""/gr) . '"' } keys %defines), @xdiff_srcs);
      print(join(' ', @cmd), "\n");
      system(@cmd);
      system("lib.exe",  "/out:xdiff.lib",  '/LTCG', glob('xdiffobjs/*.obj'));

      mkdir('libgitobjs') or die $!;
      my @cmd = ("cl.exe", '-c', '-MD', '-Zi', '-GL', '-Fo:libgitobjs/', (map { '"' . ("-D$_=$defines{$_}" =~ s/"/"""/gr) . '"' } keys %defines), @libgit_srcs);
      print(join(' ', @cmd), "\n");
      system(@cmd);
      system("lib.exe",  "/out:libgit.lib", '/LTCG', glob('libgitobjs/*.obj'));

      mkdir('gitobjs') or die $!;
      my @cmd = ("cl.exe", '-c', '-MD', '-Zi', '-GL', '-Fo:gitobjs/',    (map { '"' . ("-D$_=$defines{$_}" =~ s/"/"""/gr) . '"' } keys %defines), @git_srcs);
      print(join(' ', @cmd), "\n");
      system(@cmd);
      system("link.exe", "/out:git.exe",              '/DEBUG', '/LTCG', '/SUBSYSTEM:CONSOLE', glob('gitobjs/*.obj'),   "libgit.lib", "xdiff.lib", 'advapi32.lib', 'ws2_32.lib', 'user32.lib', "${zlib}/lib/zlib.lib");

      mkdir('gitrhobjs') or die $!;
      my @cmd = ("cl.exe", '-c', '-MD', '-Zi', '-GL', '-Fo:gitrhobjs/',  (map { '"' . ("-D$_=$defines{$_}" =~ s/"/"""/gr) . '"' } keys %defines), @git_remote_http_srcs);
      print(join(' ', @cmd), "\n");
      system(@cmd);
      system("link.exe", "/out:git-remote-http.exe",  '/DEBUG', '/LTCG', '/SUBSYSTEM:CONSOLE', glob('gitrhobjs/*.obj'), "libgit.lib", "xdiff.lib", 'advapi32.lib', 'ws2_32.lib', 'user32.lib', "${zlib}/lib/zlib.lib", "${curl}/lib/libcurl.lib");
      system("link.exe", "/out:git-remote-https.exe", '/DEBUG', '/LTCG', '/SUBSYSTEM:CONSOLE', glob('gitrhobjs/*.obj'), "libgit.lib", "xdiff.lib", 'advapi32.lib', 'ws2_32.lib', 'user32.lib', "${zlib}/lib/zlib.lib", "${curl}/lib/libcurl.lib");
  '';
  installPhase = ''
    mkdir($ENV{out})                                   or die "mkdir $ENV{out}: $!";
    mkdir("$ENV{out}/bin")                             or die "mkdir $ENV{out}/bin: $!";
    copy("git.exe",                  "$ENV{out}/bin/") or die "copy git.exe: $!";
    copy("git.pdb",                  "$ENV{out}/bin/") or die "copy git.pdb: $!";
    copy("git-remote-http.exe",      "$ENV{out}/bin/") or die "copy git-remote-http.exe: $!";
    copy("git-remote-https.exe",     "$ENV{out}/bin/") or die "copy git-remote-https.exe: $!";
    copy('${curl}/bin/libcurl.dll',  "$ENV{out}/bin/") or die "copy libcurl.dll: $!";
    copy('${curl}/bin/LIBEAY32.dll', "$ENV{out}/bin/") or die "copy LIBEAY32.dll: $!";
    copy('${curl}/bin/SSLEAY32.dll', "$ENV{out}/bin/") or die "copy SSLEAY32.dll: $!";
    copy('${curl}/bin/zlib1.dll',    "$ENV{out}/bin/") or die "copy zlib1.dll: $!";
  '';
}

else

stdenv.mkDerivation {
  inherit name version src;
  outputs = [ "out" ] ++ stdenv.lib.optional perlSupport "gitweb";

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  ## Patch

  patches = [
    ./docbook2texi.patch
    ./git-sh-i18n.patch
    ./ssh-path.patch
    ./git-send-email-honor-PATH.patch
    ./installCheck-path.patch
  ];

  postPatch = ''
    for x in connect.c git-gui/lib/remote_add.tcl ; do
      substituteInPlace "$x" \
        --subst-var-by ssh "${openssh}/bin/ssh"
    done

    # Fix references to gettext introduced by ./git-sh-i18n.patch
    substituteInPlace git-sh-i18n.sh \
        --subst-var-by gettext ${gettext}
  '';

  nativeBuildInputs = [ gettext perl ]
    ++ stdenv.lib.optionals withManual [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_45 libxslt ];
  buildInputs = [curl openssl zlib expat cpio makeWrapper libiconv]
    ++ stdenv.lib.optionals perlSupport [ perl ]
    ++ stdenv.lib.optionals guiSupport [tcl tk]
    ++ stdenv.lib.optionals withpcre2 [ pcre2 ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.Security ]
    ++ stdenv.lib.optionals withLibsecret [ pkgconfig glib libsecret ];

  # required to support pthread_cancel()
  NIX_LDFLAGS = stdenv.lib.optionalString (!stdenv.cc.isClang) "-lgcc_s"
              + stdenv.lib.optionalString (stdenv.isFreeBSD) "-lthr";

  configureFlags = stdenv.lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_fread_reads_directories=yes"
    "ac_cv_snprintf_returns_bogus=no"
  ];

  preBuild = ''
    makeFlagsArray+=( perllibdir=$out/$(perl -MConfig -wle 'print substr $Config{installsitelib}, 1 + length $Config{siteprefixexp}') )
  '';

  makeFlags = [
    "prefix=\${out}"
    "SHELL_PATH=${stdenv.shell}"
  ]
  ++ (if perlSupport then ["PERL_PATH=${perl}/bin/perl"] else ["NO_PERL=1"])
  ++ (if pythonSupport then ["PYTHON_PATH=${python}/bin/python"] else ["NO_PYTHON=1"])
  ++ stdenv.lib.optionals stdenv.isSunOS ["INSTALL=install" "NO_INET_NTOP=" "NO_INET_PTON="]
  ++ (if stdenv.isDarwin then ["NO_APPLE_COMMON_CRYPTO=1"] else ["sysconfdir=/etc/"])
  ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl ["NO_SYS_POLL_H=1" "NO_GETTEXT=YesPlease"]
  ++ stdenv.lib.optional withpcre2 "USE_LIBPCRE2=1";


  postBuild = ''
    make -C contrib/subtree
  '' + (stdenv.lib.optionalString stdenv.isDarwin ''
    make -C contrib/credential/osxkeychain
  '') + (stdenv.lib.optionalString withLibsecret ''
    make -C contrib/credential/libsecret
  '');


  ## Install

  # WARNING: Do not `rm` or `mv` files from the source tree; use `cp` instead.
  #          We need many of these files during the installCheckPhase.

  installFlags = "NO_INSTALL_HARDLINKS=1";

  preInstall = (stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/bin
    ln -s $out/share/git/contrib/credential/osxkeychain/git-credential-osxkeychain $out/bin/
    rm -f $PWD/contrib/credential/osxkeychain/git-credential-osxkeychain.o
  '') + (stdenv.lib.optionalString withLibsecret ''
    mkdir -p $out/bin
    ln -s $out/share/git/contrib/credential/libsecret/git-credential-libsecret $out/bin/
    rm -f $PWD/contrib/credential/libsecret/git-credential-libsecret.o
  '');

  postInstall =
    ''
      notSupported() {
        unlink $1 || true
      }

      # Install git-subtree.
      make -C contrib/subtree install ${stdenv.lib.optionalString withManual "install-doc"}
      rm -rf contrib/subtree

      # Install contrib stuff.
      mkdir -p $out/share/git
      cp -a contrib $out/share/git/
      ln -s "$out/share/git/contrib/credential/netrc/git-credential-netrc" $out/bin/
      mkdir -p $out/share/emacs/site-lisp
      ln -s "$out/share/git/contrib/emacs/"*.el $out/share/emacs/site-lisp/
      mkdir -p $out/etc/bash_completion.d
      ln -s $out/share/git/contrib/completion/git-completion.bash $out/etc/bash_completion.d/
      ln -s $out/share/git/contrib/completion/git-prompt.sh $out/etc/bash_completion.d/

      # grep is a runtime dependency, need to patch so that it's found
      substituteInPlace $out/libexec/git-core/git-sh-setup \
          --replace ' grep' ' ${gnugrep}/bin/grep' \
          --replace ' egrep' ' ${gnugrep}/bin/egrep'

      # Fix references to the perl, sed, awk and various coreutil binaries used by
      # shell scripts that git calls (e.g. filter-branch)
      SCRIPT="$(cat <<'EOS'
        BEGIN{
          @a=(
            '${gnugrep}/bin/grep', '${gnused}/bin/sed', '${gawk}/bin/awk',
            '${coreutils}/bin/cut', '${coreutils}/bin/basename', '${coreutils}/bin/dirname',
            '${coreutils}/bin/wc', '${coreutils}/bin/tr'
            ${stdenv.lib.optionalString perlSupport ", '${perl}/bin/perl'"}
          );
        }
        foreach $c (@a) {
          $n=(split("/", $c))[-1];
          s|(?<=[^#][^/.-])\b''${n}(?=\s)|''${c}|g
        }
      EOS
      )"
      perl -0777 -i -pe "$SCRIPT" \
        $out/libexec/git-core/git-{sh-setup,filter-branch,merge-octopus,mergetool,quiltimport,request-pull,stash,submodule,subtree,web--browse}


      # Also put git-http-backend into $PATH, so that we can use smart
      # HTTP(s) transports for pushing
      ln -s $out/libexec/git-core/git-http-backend $out/bin/git-http-backend
    '' + stdenv.lib.optionalString perlSupport ''
      # put in separate package for simpler maintenance
      mv $out/share/gitweb $gitweb/

      # wrap perl commands
      gitperllib=$out/lib/perl5/site_perl
      for i in ${builtins.toString perlLibs}; do
        gitperllib=$gitperllib:$i/lib/perl5/site_perl
      done
      wrapProgram $out/libexec/git-core/git-cvsimport \
                  --set GITPERLLIB "$gitperllib"
      wrapProgram $out/libexec/git-core/git-add--interactive \
                  --set GITPERLLIB "$gitperllib"
      wrapProgram $out/libexec/git-core/git-archimport \
                  --set GITPERLLIB "$gitperllib"
      wrapProgram $out/libexec/git-core/git-instaweb \
                  --set GITPERLLIB "$gitperllib"
      wrapProgram $out/libexec/git-core/git-cvsexportcommit \
                  --set GITPERLLIB "$gitperllib"
    ''

   + (if svnSupport then

      ''# wrap git-svn
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString perlLibs} ${svn.out}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
        wrapProgram $out/libexec/git-core/git-svn     \
                     --set GITPERLLIB "$gitperllib"   \
                     --prefix PATH : "${svn.out}/bin" ''
       else '' # replace git-svn by notification script
        notSupported $out/libexec/git-core/git-svn
       '')

   + (if sendEmailSupport then
      ''# wrap git-send-email
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString smtpPerlLibs}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
        wrapProgram $out/libexec/git-core/git-send-email \
                     --set GITPERLLIB "$gitperllib" ''
       else '' # replace git-send-email by notification script
        notSupported $out/libexec/git-core/git-send-email
       '')

   + stdenv.lib.optionalString withManual ''# Install man pages and Info manual
       make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES PERL_PATH="${buildPackages.perl}/bin/perl" cmd-list.made install install-info \
         -C Documentation ''

   + (if guiSupport then ''
       # Wrap Tcl/Tk programs
       for prog in bin/gitk libexec/git-core/{git-gui,git-citool,git-gui--askpass}; do
         sed -i -e "s|exec 'wish'|exec '${tk}/bin/wish'|g" \
                -e "s|exec wish|exec '${tk}/bin/wish'|g" \
                "$out/$prog"
       done
     '' else ''
       # Don't wrap Tcl/Tk, replace them by notification scripts
       for prog in bin/gitk libexec/git-core/git-gui; do
         notSupported "$out/$prog"
       done
     '')
   + stdenv.lib.optionalString stdenv.isDarwin ''
    # enable git-credential-osxkeychain by default if darwin
    cat > $out/etc/gitconfig << EOF
[credential]
    helper = osxkeychain
EOF
  '';


  ## InstallCheck

  doCheck = false;
  doInstallCheck = true;

  installCheckTarget = "test";

  # see also installCheckFlagsArray
  installCheckFlags = "DEFAULT_TEST_TARGET=prove";

  preInstallCheck = ''
    installCheckFlagsArray+=(
      GIT_PROVE_OPTS="--jobs $NIX_BUILD_CORES --failures --state=failed,save"
      GIT_TEST_INSTALLED=$out/bin
      ${stdenv.lib.optionalString (!svnSupport) "NO_SVN_TESTS=y"}
    )

    function disable_test {
      local test=$1 pattern=$2
      if [ $# -eq 1 ]; then
        mv t/{,skip-}$test.sh || true
      else
        sed -i t/$test.sh \
          -e "/^ *test_expect_.*$pattern/,/^ *' *\$/{s/^/#/}"
      fi
    }

    # Shared permissions are forbidden in sandbox builds.
    disable_test t0001-init shared
    disable_test t1301-shared-repo

    # Our patched gettext never fallbacks
    disable_test t0201-gettext-fallbacks

    ${stdenv.lib.optionalString (!sendEmailSupport) ''
      # Disable sendmail tests
      disable_test t9001-send-email
    ''}

    # XXX: I failed to understand why this one fails.
    # Could someone try to re-enable it on the next release ?
    # Tested to fail: 2.18.0 and 2.19.0
    disable_test t1700-split-index "null sha1"

    # Tested to fail: 2.18.0
    disable_test t7005-editor "editor with a space"
    disable_test t7005-editor "core.editor with a space"

    # Tested to fail: 2.18.0
    disable_test t9902-completion "sourcing the completion script clears cached --options"

    # As of 2.19.0, t5562 refers to #!/usr/bin/perl
    patchShebangs t/t5562/invoke-with-content-length.pl
  '' + stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    # Test fails (as of 2.17.0, musl 1.1.19)
    disable_test t3900-i18n-commit
    # Fails largely due to assumptions about BOM
    # Tested to fail: 2.18.0
    disable_test t0028-working-tree-encoding
  '';

  stripDebugList = [ "lib" "libexec" "bin" "share/git/contrib/credential/libsecret" ];


  meta = {
    homepage = https://git-scm.com/;
    description = "Distributed version control system";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Git, a popular distributed version control system designed to
      handle very large projects with speed and efficiency.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ peti the-kenny wmertens ];
  };
}
