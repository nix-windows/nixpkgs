{ lib, stdenv, perl }:

{ nativeBuildInputs ? [], name, ... } @ attrs:

stdenv.mkDerivation (
  (
    lib.recursiveUpdate
      ({
          outputs = [ "out" "devdoc" ];

          doCheck = true;

          checkTarget = "test";

          # Prevent CPAN downloads.
          PERL_AUTOINSTALL = "--skipdeps";

          # Avoid creating perllocal.pod, which contains a timestamp
          installTargets = "pure_install";

          # From http://wiki.cpantesters.org/wiki/CPANAuthorNotes: "allows
          # authors to skip certain tests (or include certain tests) when
          # the results are not being monitored by a human being."
          AUTOMATED_TESTING = true;

          # current directory (".") is removed from @INC in Perl 5.26 but many old libs rely on it
          # https://metacpan.org/pod/release/XSAWYERX/perl-5.26.0/pod/perldelta.pod#Removal-of-the-current-directory-%28%22.%22%29-from-@INC
          PERL_USE_UNSAFE_INC = "1";

          meta.homepage = "https://metacpan.org/release/${(builtins.parseDrvName name).name}";
        }
        // (lib.optionalAttrs stdenv.hostPlatform.isMicrosoft {
              outputs = [ "out" ];
              # there are no hooks in stdenv/windows yet; makemaker needs at least LIB to locate kernel32.lib
            # INCLUDE = stdenv.cc.INCLUDE;
              LIB     = stdenv.cc.LIB;
            # LIBPATH = stdenv.cc.LIBPATH;
              # there are no default buildPhase, checkPhase, installPhase in stdenv/windows yet
              buildPhase   = ''system('nmake.exe'        ) == 0 or die;'';
              checkPhase   = ''system('nmake.exe test'   ) == 0 or die;'';
              installPhase = ''system('nmake.exe install') == 0 or die;''; #  remove_treeL("$ENV{out}/lib/perllocal.pod");
            })
      )
      attrs
  )
  //
  {
    name = "perl${perl.version}-${name}";
    builder = if stdenv.isShellPerl then ./builder.pl else ./builder.sh;
    nativeBuildInputs = nativeBuildInputs ++ [ (perl.dev or perl) ];
    inherit perl;
  }
)
