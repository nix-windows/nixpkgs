require "$ENV{stdenv}/setup.pm";

# here $ENV{PERL5LIB} has "/lib"-directories of the deps set by perl's setupHook
$ENV{PERL5LIB} = ($ENV{PERL5LIB} ? "$ENV{PERL5LIB};" : "") . "$ENV{out}/lib";

$ENV{perlFlags} = join(' ', map { "-I$_" } split(/;/, $ENV{PERL5LIB}));

my $oldPreConfigure = $ENV{preConfigure} || '';

sub newPreConfigure {
    if ($oldPreConfigure) {
        eval "$oldPreConfigure";
        if ($@) { print "$@" ; die; }
    }

    print("In newPreConfigure: PERL5LIB='$ENV{PERL5LIB}'\n");

#   find . | while read fn; do
#       if test -f "$fn"; then
#           first=$(dd if="$fn" count=2 bs=1 2> /dev/null)
#           if test "$first" = "#!"; then
#               echo "patching $fn..."
#               sed -i "$fn" -e "s|^#\!\(.*[ /]perl.*\)$|#\!\1$perlFlags|"
#           fi
#       fi
#   done

    #for cross: PERL=$(type -P perl.exe) FULLPERL=\"$ENV{perl}/bin/perl.exe\"
    system("perl Makefile.PL PREFIX=$ENV{out} INSTALLDIRS=site $ENV{makeMakerFlags}") == 0 or die;
}
$ENV{preConfigure} = "newPreConfigure";


#postFixup() {
#    # If a user installs a Perl package, she probably also wants its
#    # dependencies in the user environment (since Perl modules don't
#    # have something like an RPATH, so the only way to find the
#    # dependencies is to have them in the PERL5LIB variable).
#    if test -e $out/nix-support/propagated-build-inputs; then
#        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
#    fi
#}

if (exists($ENV{perlPreHook})) {
    eval "$ENV{perlPreHook}";
    if ($@) { print "$@" ; die; }
}

genericBuild();

if (exists($ENV{perlPostHook})) {
    eval "$ENV{perlPostHook}";
    if ($@) { print "$@" ; die; }
}
