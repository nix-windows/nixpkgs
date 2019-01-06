{ stdenv, fetchurl, perl, curl, openssl, zlib }:

# known bugs:
#  1. it does not handle submodules (git submodule is written in bash)
#  2. it does handle symlinks
stdenv.mkDerivation rec {
  version = "2.19.1";
  name = "git-${version}";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/scm/git/git-${version}.tar.xz";
    sha256 = "1dfv43lmdnxz42504jc89sihbv1d4d6kgqcz3c5ji140kfm5cl1l";
  };

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
      copyL('${./command-list-2.19.1.h}', './command-list.h') or die;

      # fetch-pack does `close(1)` so the receiving party gets unexpected EOF
      # TODO: use .patch
      copyL('${./fetch-pack.c}', './builtin/fetch-pack.c') or die;

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
      my @cmd = ("cl.exe", '-c', '-MD', '-Zi', '-GL', '-Fo:xdiffobjs/',  (map { escapeWindowsArg("-D$_=$defines{$_}") } keys %defines), @xdiff_srcs);
      print(join(' ', @cmd), "\n");
      system(@cmd);
      system("lib.exe",  "/out:xdiff.lib",  '/LTCG', glob('xdiffobjs/*.obj'));

      mkdir('libgitobjs') or die $!;
      my @cmd = ("cl.exe", '-c', '-MD', '-Zi', '-GL', '-Fo:libgitobjs/', (map { escapeWindowsArg("-D$_=$defines{$_}") } keys %defines), @libgit_srcs);
      print(join(' ', @cmd), "\n");
      system(@cmd);
      system("lib.exe",  "/out:libgit.lib", '/LTCG', glob('libgitobjs/*.obj'));

      mkdir('gitobjs') or die $!;
      my @cmd = ("cl.exe", '-c', '-MD', '-Zi', '-GL', '-Fo:gitobjs/',    (map { escapeWindowsArg("-D$_=$defines{$_}") } keys %defines), @git_srcs);
      print(join(' ', @cmd), "\n");
      system(@cmd);
      system("link.exe", "/out:git.exe",              '/DEBUG', '/LTCG', '/SUBSYSTEM:CONSOLE', glob('gitobjs/*.obj'),   "libgit.lib", "xdiff.lib", 'advapi32.lib', 'ws2_32.lib', 'user32.lib', "${zlib}/lib/zdll.lib");

      mkdir('gitrhobjs') or die $!;
      my @cmd = ("cl.exe", '-c', '-MD', '-Zi', '-GL', '-Fo:gitrhobjs/',  (map { escapeWindowsArg("-D$_=$defines{$_}") } keys %defines), @git_remote_http_srcs);
      print(join(' ', @cmd), "\n");
      system(@cmd);
      system("link.exe", "/out:git-remote-http.exe",  '/DEBUG', '/LTCG', '/SUBSYSTEM:CONSOLE', glob('gitrhobjs/*.obj'), "libgit.lib", "xdiff.lib", 'advapi32.lib', 'ws2_32.lib', 'user32.lib', "${zlib}/lib/zdll.lib", "${curl}/lib/libcurl.lib");
      system("link.exe", "/out:git-remote-https.exe", '/DEBUG', '/LTCG', '/SUBSYSTEM:CONSOLE', glob('gitrhobjs/*.obj'), "libgit.lib", "xdiff.lib", 'advapi32.lib', 'ws2_32.lib', 'user32.lib', "${zlib}/lib/zdll.lib", "${curl}/lib/libcurl.lib");
  '';
  installPhase = ''
    make_pathL("$ENV{out}/bin")                                             or die "make_pathL $ENV{out}/bin: $!";
    copyL("git.exe",                  "$ENV{out}/bin/git.exe"             ) or die "copyL git.exe: $!";
    copyL("git.pdb",                  "$ENV{out}/bin/git.pdb"             ) or die "copyL git.pdb: $!";
    copyL("git-remote-http.exe",      "$ENV{out}/bin/git-remote-http.exe" ) or die "copyL git-remote-http.exe: $!";
    copyL("git-remote-https.exe",     "$ENV{out}/bin/git-remote-https.exe") or die "copyL git-remote-https.exe: $!";
    copyL('${curl}/bin/libcurl.dll',  "$ENV{out}/bin/libcurl.dll"         ) or die "copyL libcurl.dll: $!";
    copyL('${curl}/bin/LIBEAY32.dll', "$ENV{out}/bin/LIBEAY32.dll"        ) or die "copyL LIBEAY32.dll: $!";
    copyL('${curl}/bin/SSLEAY32.dll', "$ENV{out}/bin/SSLEAY32.dll"        ) or die "copyL SSLEAY32.dll: $!";
    copyL('${curl}/bin/zlib1.dll',    "$ENV{out}/bin/zlib1.dll"           ) or die "copyL zlib1.dll: $!";
  '';
}
