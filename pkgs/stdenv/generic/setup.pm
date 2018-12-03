# make these function available in builder code without explicit `use`
use Cwd qw(getcwd);
use File::Basename qw(dirname basename);
use File::Copy qw(copy move);
use File::Copy::Recursive qw(dircopy);

# set -eu
# set -o pipefail
#
# if (( "${NIX_DEBUG:-0}" >= 6 )); then
#     set -x
# fi
#
# : ${outputs:=out}
#
#
sub readFile {
    open(my $fh, shift) or die $!;
    binmode $fh;
    local $/ = undef;
    my $content = <$fh>;
    close $fh;
    return $content;
}

######################################################################
# Hook handling.
my %builtinHooks = (
 '_defaultUnpack' => \&_defaultUnpack,
);


# Run all hooks with the specified name in the order in which they
# were added, stopping if any fails (returns a non-zero exit
# code). The hooks for <hookName> are the shell function or variable
# <hookName>, and the values of the shell array ‘<hookName>Hooks’.
sub runHook {
#     local oldOpts="$(shopt -po nounset)"
#     set -u # May be called from elsewhere, so do `set -u`.
#
    my ($hookName, @rest) = @_;
    my @hooksSlice = split / +/, ($ENV{$hookName."Hooks"} =~ s/^\s+|\s+$//r);
    print("runHook hookName=$hookName hooksSlice=@hooksSlice\n");
#   die "TODO" if scalar(@hooksSlice) > 0;
#     shift
#     local hooksSlice="${hookName%Hook}Hooks[@]"
#
#     local hook
#     # Hack around old bash being bad and thinking empty arrays are
#     # undefined.
#     for hook in "_callImplicitHook 0 $hookName" ${!hooksSlice+"${!hooksSlice}"}; do
#         _eval "$hook" "$@"
#         set -u # To balance `_eval`
#     done
#
#     eval "${oldOpts}"
    for my $hook ($hookName, @hooksSlice) {
        #my $f = eval "\\\$$hook";
        #print("f=$f\n");
        #if ($@) {
        #    print("eval of hook failed $@\n");
        #} else {
        if (exists($builtinHooks{$hook})) {
            print("BUILTIN hook=$hook\n");
            &{$builtinHooks{$hook}}(@rest);
        } elsif (exists($ENV{$hook})) {
            scalar(@rest) == 0 or die "how to eval with args?";
            if (-f $ENV{$hook}) {
                print("FILE hook=$hook $ENV{$hook}\n");
                eval readFile($ENV{$hook});
            } else {
                print("ENV hook=$hook $ENV{$hook}\n");
                eval "$ENV{$hook}";
            }
        } else {
            print("IGNORE hook=$hook ref(hook)=[".ref($hook)."]\n");
        }
        #}
    }

    return 0;
}
#
#
# # Run all hooks with the specified name, until one succeeds (returns a
# # zero exit code). If none succeed, return a non-zero exit code.
sub runOneHook {
#     local oldOpts="$(shopt -po nounset)"
#     set -u # May be called from elsewhere, so do `set -u`.

    my ($hookName, @rest) = @_;
    my @hooksSlice = split / +/, ($ENV{$hookName."Hooks"} =~ s/^\s+|\s+$//r);
    print("runOneHook hookName=$hookName hooksSlice=@hooksSlice\n");

    my $ret = 1;
    for my $hook ($hookName, @hooksSlice) {
        #my $f = eval "\\\$$hook";
        #print("f=$f\n");
        #if ($@) {
        #    print("eval of hook failed $@\n");
        #} else {
        if (exists($builtinHooks{$hook})) {
            print("BUILTIN hook=$hook\n");
            if (&{$builtinHooks{$hook}}(@rest) == 0) { # todo check hook type
                $ret = 0;
                break;
            }
        } else {
            print("IGNORE hook=$hook ref(hook)=[".ref($hook)."]\n");
        }
    }
    print("runOneHook: $ret\n");
    return $ret;
}
#
#
# # Run the named hook, either by calling the function with that name or
# # by evaluating the variable with that name. This allows convenient
# # setting of hooks both from Nix expressions (as attributes /
# # environment variables) and from shell scripts (as functions). If you
# # want to allow multiple hooks, use runHook instead.
sub _callImplicitHook {
#     set -u
    my ($def, $hookName) = $_;
#     case "$(type -t "$hookName")" in
#         (function|alias|builtin)
#             set +u
#             "$hookName";;
#         (file)
#             set +u
#             source "$hookName";;
#         (keyword) :;;
#         (*) if [ -z "${!hookName:-}" ]; then
#                 return "$def";
#             else
#                 set +u
#                 eval "${!hookName}"
#             fi;;
#     esac
#     # `_eval` expects hook to need nounset disable and leave it
#     # disabled anyways, so Ok to to delegate. The alternative of a
#     # return trap is no good because it would affect nested returns.
}
#
#
# # A function wrapper around ‘eval’ that ensures that ‘return’ inside
# # hooks exits the hook, not the caller. Also will only pass args if
# # command can take them
# _eval() {
#     if [ "$(type -t "$1")" = function ]; then
#         set +u
#         "$@" # including args
#     else
#         set +u
#         eval "$1"
#     fi
#     # `run*Hook` reenables `set -u`
# }
#
#
# ######################################################################
# # Logging.
#
# # Obsolete.
# stopNest() { true; }
# header() { echo "$1"; }
# closeNest() { true; }
#
# # Prints a command such that all word splits are unambiguous. We need
# # to split the command in three parts because the middle format string
# # will be, and must be, repeated for each argument. The first argument
# # goes before the ':' and is just for convenience.
# echoCmd() {
#     printf "%s:" "$1"
#     shift
#     printf ' %q' "$@"
#     echo
# }
#
#
# ######################################################################
# # Error handling.
#
# exitHandler() {
#     exitCode="$?"
#     set +e
#
#     if [ -n "${showBuildStats:-}" ]; then
#         times > "$NIX_BUILD_TOP/.times"
#         local -a times=($(cat "$NIX_BUILD_TOP/.times"))
#         # Print the following statistics:
#         # - user time for the shell
#         # - system time for the shell
#         # - user time for all child processes
#         # - system time for all child processes
#         echo "build time elapsed: " "${times[@]}"
#     fi
#
#     if (( "$exitCode" != 0 )); then
#         runHook failureHook
#
#         # If the builder had a non-zero exit code and
#         # $succeedOnFailure is set, create the file
#         # ‘$out/nix-support/failed’ to signal failure, and exit
#         # normally.  Otherwise, return the original exit code.
#         if [ -n "${succeedOnFailure:-}" ]; then
#             echo "build failed with exit code $exitCode (ignored)"
#             mkdir -p "$out/nix-support"
#             printf "%s" "$exitCode" > "$out/nix-support/failed"
#             exit 0
#         fi
#
#     else
#         runHook exitHook
#     fi
#
#     exit "$exitCode"
# }
#
# trap "exitHandler" EXIT


######################################################################
# Helper functions.


sub addToSearchPathWithCustomDelimiter {
    my ($delimiter, $varName, $dir) = @_;
#   print("addToSearchPathWithCustomDelimiter($delimiter, $varName, $dir)\n");
    if (-d $dir) {
        if (exists($ENV{$varName}) && $ENV{$varName} ne '') {
            $ENV{$varName} = "$ENV{$varName}$delimiter$dir";
        } else {
            $ENV{$varName} = $dir;
        }
    }
}

my $PATH_DELIMITER = $^O eq 'MSWin32' ? ';' : ':';

sub addToSearchPath {
    addToSearchPathWithCustomDelimiter($PATH_DELIMITER, @_);
}

# # Add $1/lib* into rpaths.
# # The function is used in multiple-outputs.sh hook,
# # so it is defined here but tried after the hook.
# _addRpathPrefix() {
#     if [ "${NIX_NO_SELF_RPATH:-0}" != 1 ]; then
#         export NIX_LDFLAGS="-rpath $1/lib $NIX_LDFLAGS"
#         if [ -n "${NIX_LIB64_IN_SELF_RPATH:-}" ]; then
#             export NIX_LDFLAGS="-rpath $1/lib64 $NIX_LDFLAGS"
#         fi
#         if [ -n "${NIX_LIB32_IN_SELF_RPATH:-}" ]; then
#             export NIX_LDFLAGS="-rpath $1/lib32 $NIX_LDFLAGS"
#         fi
#     fi
# }
#
# # Return success if the specified file is an ELF object.
# isELF() {
#     local fn="$1"
#     local fd
#     local magic
#     exec {fd}< "$fn"
#     read -r -n 4 -u "$fd" magic
#     exec {fd}<&-
#     if [ "$magic" = $'\177ELF' ]; then return 0; else return 1; fi
# }
#
# # Return success if the specified file is a script (i.e. starts with
# # "#!").
# isScript() {
#     local fn="$1"
#     local fd
#     local magic
#     exec {fd}< "$fn"
#     read -r -n 2 -u "$fd" magic
#     exec {fd}<&-
#     if [[ "$magic" =~ \#! ]]; then return 0; else return 1; fi
# }
#
# # printf unfortunately will print a trailing newline regardless
# printLines() {
#     (( "$#" > 0 )) || return 0
#     printf '%s\n' "$@"
# }
#
# printWords() {
#     (( "$#" > 0 )) || return 0
#     printf '%s ' "$@"
# }

######################################################################
# Initialisation.


# Set a fallback default value for SOURCE_DATE_EPOCH, used by some
# build tools to provide a deterministic substitute for the "current"
# time. Note that 1 = 1970-01-01 00:00:01. We don't use 0 because it
# confuses some applications.
$ENV{SOURCE_DATE_EPOCH} ||= '1';


# # Wildcard expansions that don't match should expand to an empty list.
# # This ensures that, for instance, "for i in *; do ...; done" does the
# # right thing.
# shopt -s nullglob
#
#
# Set up the initial path.
#$ENV{PATH} = ''; # TODO: do not erase C:\Windows\System32
$ENV{HOST_PATH} = '';
for my $i (split / /, $ENV{initialPath}) {
#   if [ "$i" = / ]; then i=; fi
    addToSearchPath('PATH', "$i/bin");

    # For backward compatibility, we add initial path to HOST_PATH so
    # it can be used in auto patch-shebangs. Unfortunately this will
    # not work with cross compilation.
    addToSearchPath('HOST_PATH', "$i/bin") unless $ENV{strictDeps};
}

print ("initial path: '$ENV{PATH}'\n"); # if (( "${NIX_DEBUG:-0}" >= 1 ))



# # Check that the pre-hook initialised SHELL.
# if [ -z "${SHELL:-}" ]; then echo "SHELL not set"; exit 1; fi
# BASH="$SHELL"
# export CONFIG_SHELL="$SHELL"
#
# # Dummy implementation of the paxmark function. On Linux, this is
# # overwritten by paxctl's setup hook.
# paxmark() { true; }


# Execute the pre-hook.
# if [ -z "${shell:-}" ]; then export shell="$SHELL"; fi
runHook 'preHook';


# Allow the caller to augment buildInputs (it's not always possible to
# do this before the call to setup.sh, since the PATH is empty at that
# point; here we have a basic Unix environment).
runHook 'addInputsHook';


# Package accumulators
my $pkgsBuildBuild   = [];
my $pkgsBuildHost    = [];
my $pkgsBuildTarget  = [];
my $pkgsHostHost     = [];
my $pkgsHostTarget   = [];
my $pkgsTargetTarget = [];
my %pkgAccumVarVars = ( -1 => [\$pkgsBuildBuild, \$pkgsBuildHost, \$pkgsBuildTarget],
                         0 => [\$pkgsHostHost, \$pkgsHostTarget                    ],
                         1 => [\$pkgsTargetTarget                                  ]
                      );


# Hooks
my $envBuildBuildHooks   = [];
my $envBuildHostHooks    = [];
my $envBuildTargetHooks  = [];
my $envHostHostHooks     = [];
my $envHostTargetHooks   = [];
my $envTargetTargetHooks = [];
my %pkgHookVarVars  = ( -1 => [\$envBuildBuildHooks, \$envBuildHostHooks, \$envBuildTargetHooks],
                         0 => [\$envHostHostHooks, \$envHostTargetHooks                        ],
                         1 => [\$envTargetTargetHooks                                          ]
                      );


# Add env hooks for all sorts of deps with the specified host offset.
sub addEnvHooks {
    my ($depHostOffset, @rest) = @_;
    print("TODO: addEnvHooks($depHostOffset, @rest)\n");

    for my $pkgHookVar (@{$pkgHookVarVars{$depHostOffset}}) {
        push(@$$pkgHookVar, @rest);
    }
}


# Propagated dep files

my @propagatedBuildDepFiles = (
    'propagated-build-build-deps',
    'propagated-native-build-inputs', # Legacy name for back-compat
    'propagated-build-target-deps'
);
my @propagatedHostDepFiles = (
    'propagated-host-host-deps',
    'propagated-build-inputs' # Legacy name for back-compat
);
my @propagatedTargetDepFiles = (
    'propagated-target-target-deps'
);
my %propagatedDepFilesVars = ( -1 => [ @propagatedBuildDepFiles  ],
                                0 => [ @propagatedHostDepFiles   ],
                                1 => [ @propagatedTargetDepFiles ]
                             );

# Platform offsets: build = -1, host = 0, target = 1
my @allPlatOffsets = (-1, 0, 1); # = keys %pkgAccumVarVars


# Mutually-recursively find all build inputs. See the dependency section of the
# stdenv chapter of the Nixpkgs manual for the specification this algorithm
# implements.
sub findInputs {
    my ($pkg, $hostOffset, $targetOffset) = @_;

    # Sanity check
    die unless $hostOffset <= $targetOffset;

    my $varRef = ${$pkgAccumVarVars{$hostOffset}->[$targetOffset - $hostOffset]}; # ref to one of the arrays (pkgsBuildBuild, ..)
    print("pkg=$pkg\n");
    print("varRef=(".(join '_', @$varRef).")\n");

    # TODO(@Ericson2314): Restore using associative array once Darwin
    # nix-shell doesn't use impure bash. This should replace the O(n)
    # case with an O(1) hash map lookup, assuming bash is implemented
    # well :D.
    return 0 if grep { $_ eq $pkg } @$varRef;

    push(@$varRef, $pkg);

    die "build input $pkg does not exist" unless -e $pkg;

    # The current package's host and target offset together
    # provide a <=-preserving homomorphism from the relative
    # offsets to current offset
    sub mapOffset {
        my $inputOffset = shift;
#       print("inputOffset=$inputOffset hostOffset=$hostOffset targetOffset=$targetOffset\n");
        if ($inputOffset <= 0) {
            return $inputOffset + $hostOffset;
        } else {
            return $inputOffset - 1 + $targetOffset;
        }
    }

    # Host offset relative to that of the package whose immediate
    # dependencies we are currently exploring.
    for my $relHostOffset (@allPlatOffsets) {
        my $files = $propagatedDepFilesVars{$relHostOffset};

        # Host offset relative to the package currently being
        # built---as absolute an offset as will be used.
        my $hostOffsetNext = mapOffset($relHostOffset);

        # Ensure we're in bounds relative to the package currently
        # being built.
        next unless grep { $_ == $hostOffsetNext } @allPlatOffsets;

        # Target offset relative to the *host* offset of the package
        # whose immediate dependencies we are currently exploring.
        for my $relTargetOffset (@allPlatOffsets) {
            next unless $relHostOffset <= $relTargetOffset;
            my $file = $files->[$relTargetOffset - $relHostOffset];
            # Target offset relative to the package currently being
            # built.
            my $targetOffsetNext = mapOffset(relTargetOffset);
#           print("targetOffsetNext=$targetOffsetNext\n");
            # Once again, ensure we're in bounds relative to the
            # package currently being built.
            next unless grep { $_ == $targetOffsetNext } @allPlatOffsets;

            next unless -f "$pkg/nix-support/$file";

            open(my $fh, "$pkg/nix-support/$file") or die $!;
            for my $pkgNext (split / +/, <$fh>) {
                findInputs($pkgNext, $hostOffsetNext, $targetOffsetNext) if $pkgNext ne '';
            }
            close($fh);
        }
    }
}

# Make sure all are at least defined as empty
$ENV{depsBuildBuild}              ||= '';
$ENV{depsBuildBuildPropagated}    ||= '';
$ENV{nativeBuildInputs}           ||= '';
$ENV{propagatedNativeBuildInputs} ||= '';
$ENV{defaultNativeBuildInputs}    ||= '';
$ENV{depsBuildTarget}             ||= '';
$ENV{depsBuildTargetPropagated}   ||= '';
$ENV{depsHostHost}                ||= '';
$ENV{depsHostHostPropagated}      ||= '';
$ENV{buildInputs}                 ||= '';
$ENV{propagatedBuildInputs}       ||= '';
$ENV{defaultBuildInputs}          ||= '';
$ENV{depsTargetTarget}            ||= '';
$ENV{depsTargetTargetPropagated}  ||= '';

for my $pkg (split / +/, "$ENV{depsBuildBuild} $ENV{depsBuildBuildPropagated}") {
    findInputs($pkg, -1, -1) if $pkg ne '';
}
for my $pkg (split / +/, "$ENV{nativeBuildInputs} $ENV{propagatedNativeBuildInputs}") {
    findInputs($pkg, -1, 0) if $pkg ne '';
}
for my $pkg (split / +/, "$ENV{depsBuildTarget} $ENV{depsBuildTargetPropagated}") {
    findInputs($pkg, -1, 1) if $pkg ne '';
}
for my $pkg (split / +/, "$ENV{depsHostHost} $ENV{depsHostHostPropagated}") {
    findInputs($pkg, 0, 0) if $pkg ne '';
}
for my $pkg (split / +/, "$ENV{buildInputs} $ENV{propagatedBuildInputs}") {
    findInputs($pkg, 0, 1) if $pkg ne '';
}
for my $pkg (split / +/, "$ENV{depsTargetTarget} $ENV{depsTargetTargetPropagated}") {
    findInputs($pkg, 1, 1) if $pkg ne '';
}
# Default inputs must be processed last
for my $pkg (split / +/, $ENV{defaultNativeBuildInputs}) {
    findInputs($pkg, -1, 0) if $pkg ne '';
}
for my $pkg (split / +/, $ENV{defaultBuildInputs}) {
    findInputs($pkg, 0, 1) if $pkg ne '';
}

print("pkgsBuildBuild   = $pkgsBuildBuild   @{$pkgsBuildBuild}  \n");
print("pkgsBuildHost    = $pkgsBuildHost    @{$pkgsBuildHost}   \n");
print("pkgsBuildTarget  = $pkgsBuildTarget  @{$pkgsBuildTarget} \n");
print("pkgsHostHost     = $pkgsHostHost     @{$pkgsHostHost}    \n");
print("pkgsHostTarget   = $pkgsHostTarget   @{$pkgsHostTarget}  \n");
print("pkgsTargetTarget = $pkgsTargetTarget @{$pkgsTargetTarget}\n");


# Add package to the future PATH and run setup hooks
sub activatePackage {
    my ($pkg, $hostOffset, $targetOffset) = @_;

    print("activatePackage($pkg, $hostOffset, $targetOffset) ".(-f $pkg)." ".(-d $pkg)." ".(-d "$pkg/bin")."\n");

    # Sanity check
    die unless $hostOffset <= $targetOffset;

    if (-f $pkg) {
        print("TODO: source pkg=$pkg\n");
        exit(1);
#         local oldOpts="$(shopt -po nounset)"
#         set +u
#         source "$pkg"
#         eval "$oldOpts"
    }

    # Only dependencies whose host platform is guaranteed to match the
    # build platform are included here. That would be `depsBuild*`,
    # and legacy `nativeBuildInputs`, in general. If we aren't cross
    # compiling, however, everything can be put on the PATH. To ease
    # the transition, we do include everything in thatcase.
    #
    # TODO(@Ericson2314): Don't special-case native compilation
    addToSearchPath('_PATH',     "$pkg/bin") if (!$ENV{strictDeps} || $hostOffset <= -1) && -d "$pkg/bin";

    addToSearchPath('HOST_PATH', "$pkg/bin") if                       $hostOffset == 0   && -d "$pkg/bin";

    if (-f "$pkg/nix-support/setup-hook") {
        print("TODO: source '$pkg/nix-support/setup-hook'\n");
        exit(1);
#       local oldOpts="$(shopt -po nounset)"
#       set +u
#       source "$pkg/nix-support/setup-hook"
#       eval "$oldOpts"
    }
}

sub _activatePkgs() {
    for my $hostOffset (@allPlatOffsets) {
        my $pkgsVar = $pkgAccumVarVars{$hostOffset};
        for my $targetOffset (@allPlatOffsets) {
            next unless $hostOffset <= $targetOffset;
            my $pkgsSlice = ${$pkgsVar->[$targetOffset - $hostOffset]};
            for my $pkg (@$pkgsSlice) {
                activatePackage($pkg, $hostOffset, $targetOffset);
            }
        }
    }
}

# Run the package setup hooks and build _PATH
_activatePkgs();

# Set the relevant environment variables to point to the build inputs
# found above.
#
# These `depOffset`s, beyond indexing the arrays, also tell the env
# hook what sort of dependency (ignoring propagatedness) is being
# passed to the env hook. In a real language, we'd append a closure
# with this information to the relevant env hook array, but bash
# doesn't have closures, so it's easier to just pass this in.
sub _addToEnv() {
    for my $depHostOffset (@allPlatOffsets) {
        my $hookVar = $pkgHookVarVars{$depHostOffset};
        my $pkgsVar = $pkgAccumVarVars{$depHostOffset};
        for my $depTargetOffset (@allPlatOffsets) {
            next unless $depHostOffset <= $depTargetOffset;
            my $hookRef = ${$hookVar->[$depTargetOffset - $depHostOffset]}; # ???
            print("TODO _addToEnv: hookRef=$hookRef\n");

            if (!$ENV{strictDeps}) {
                # Apply environment hooks to all packages during native
                # compilation to ease the transition.
                #
                # TODO(@Ericson2314): Don't special-case native compilation
                for my $pkg (@{$pkgsBuildBuild}, @{$pkgsBuildHost}, @{$pkgsBuildTarget}, @{$pkgsHostHost}, @{$pkgsHostTarget}, @{$pkgsTargetTarget}) {
#                     runHook "${!hookRef}" "$pkg"
                }
            } else {
                my $pkgsSlice = ${$pkgsVar->[$depTargetOffset - $depHostOffset]};
                for my $pkg (@$pkgsSlice) {
#                    runHook "${!hookRef}" "$pkg"
               }
            }
        }
    }
}

# Run the package-specific hooks set by the setup-hook scripts.
_addToEnv();

print("envBuildBuildHooks   = $envBuildBuildHooks   @{$envBuildBuildHooks}  \n");
print("envBuildHostHooks    = $envBuildHostHooks    @{$envBuildHostHooks}   \n");
print("envBuildTargetHooks  = $envBuildTargetHooks  @{$envBuildTargetHooks} \n");
print("envHostHostHooks     = $envHostHostHooks     @{$envHostHostHooks}    \n");
print("envHostTargetHooks   = $envHostTargetHooks   @{$envHostTargetHooks}  \n");
print("envTargetTargetHooks = $envTargetTargetHooks @{$envTargetTargetHooks}\n");
#print("_PATH = '".($ENV{'_PATH'})."'\n");



# _addRpathPrefix "$out"
#
#
# # Set the TZ (timezone) environment variable, otherwise commands like
# # `date' will complain (e.g., `Tue Mar 9 10:01:47 Local time zone must
# # be set--see zic manual page 2004').
# export TZ=UTC
#
#
# # Set the prefix.  This is generally $out, but it can be overriden,
# # for instance if we just want to perform a test build/install to a
# # temporary location and write a build report to $out.
# if [ -z "${prefix:-}" ]; then
#     prefix="$out";
# fi
#
# if [ "${useTempPrefix:-}" = 1 ]; then
#     prefix="$NIX_BUILD_TOP/tmp_prefix";
# fi

$ENV{PATH} = "$ENV{_PATH}$PATH_DELIMITER$ENV{PATH}" if $ENV{_PATH} &&  $ENV{PATH};
$ENV{PATH} =  $ENV{_PATH}                           if $ENV{_PATH} && !$ENV{PATH};

print("final path: '$ENV{PATH}'\n"); # if (( "${NIX_DEBUG:-0}" >= 1 ))


# # Make GNU Make produce nested output.
# export NIX_INDENT_MAKE=1
#
#
# # Normalize the NIX_BUILD_CORES variable. The value might be 0, which
# # means that we're supposed to try and auto-detect the number of
# # available CPU cores at run-time.
#
# if [ -z "${NIX_BUILD_CORES:-}" ]; then
#   NIX_BUILD_CORES="1"
# elif [ "$NIX_BUILD_CORES" -le 0 ]; then
#   NIX_BUILD_CORES=$(nproc 2>/dev/null || true)
#   if expr >/dev/null 2>&1 "$NIX_BUILD_CORES" : "^[0-9][0-9]*$"; then
#     :
#   else
#     NIX_BUILD_CORES="1"
#   fi
# fi
# export NIX_BUILD_CORES
#
#
# # Prevent OpenSSL-based applications from using certificates in
# # /etc/ssl.
# # Leave it in shells for convenience.
# if [ -z "${SSL_CERT_FILE:-}" ] && [ -z "${IN_NIX_SHELL:-}" ]; then
#   export SSL_CERT_FILE=/no-cert-file.crt
# fi
#
#
# ######################################################################
# # Textual substitution functions.
#
#
# substituteStream() {
#     local var=$1
#     shift
#
#     while (( "$#" )); do
#         case "$1" in
#             --replace)
#                 pattern="$2"
#                 replacement="$3"
#                 shift 3
#                 ;;
#
#             --subst-var)
#                 local varName="$2"
#                 shift 2
#                 # check if the used nix attribute name is a valid bash name
#                 if ! [[ "$varName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
#                     echo "substituteStream(): ERROR: substitution variables must be valid Bash names, \"$varName\" isn't." >&2
#                     return 1
#                 fi
#                 if [ -z ${!varName+x} ]; then
#                     echo "substituteStream(): ERROR: variable \$$varName is unset" >&2
#                     return 1
#                 fi
#                 pattern="@$varName@"
#                 replacement="${!varName}"
#                 ;;
#
#             --subst-var-by)
#                 pattern="@$2@"
#                 replacement="$3"
#                 shift 3
#                 ;;
#
#             *)
#                 echo "substituteStream(): ERROR: Invalid command line argument: $1" >&2
#                 return 1
#                 ;;
#         esac
#
#         eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
#     done
#
#     printf "%s" "${!var}"
# }
#
# consumeEntire() {
#     # read returns non-0 on EOF, so we want read to fail
#     if IFS='' read -r -N 0 $1; then
#         echo "consumeEntire(): ERROR: Input null bytes, won't process" >&2
#         return 1
#     fi
# }
#
# substitute() {
#     local input="$1"
#     local output="$2"
#     shift 2
#
#     if [ ! -f "$input" ]; then
#         echo "substitute(): ERROR: file '$input' does not exist" >&2
#         return 1
#     fi
#
#     local content
#     consumeEntire content < "$input"
#
#     if [ -e "$output" ]; then chmod +w "$output"; fi
#     substituteStream content "$@" > "$output"
# }
#
# substituteInPlace() {
#     local fileName="$1"
#     shift
#     substitute "$fileName" "$fileName" "$@"
# }
#
# _allFlags() {
#     for varName in $(awk 'BEGIN { for (v in ENVIRON) if (v ~ /^[a-z][a-zA-Z0-9_]*$/) print v }'); do
#         if (( "${NIX_DEBUG:-0}" >= 1 )); then
#             printf "@%s@ -> %q\n" "${varName}" "${!varName}"
#         fi
#         args+=("--subst-var" "$varName")
#     done
# }
#
# substituteAllStream() {
#     local -a args=()
#     _allFlags
#
#     substituteStream "$1" "${args[@]}"
# }
#
# # Substitute all environment variables that start with a lowercase character and
# # are valid Bash names.
# substituteAll() {
#     local input="$1"
#     local output="$2"
#
#     local -a args=()
#     _allFlags
#
#     substitute "$input" "$output" "${args[@]}"
# }
#
#
# substituteAllInPlace() {
#     local fileName="$1"
#     shift
#     substituteAll "$fileName" "$fileName" "$@"
# }
#
#
# ######################################################################
# # What follows is the generic builder.
#
#
# # This function is useful for debugging broken Nix builds.  It dumps
# # all environment variables to a file `env-vars' in the build
# # directory.  If the build fails and the `-K' option is used, you can
# # then go to the build directory and source in `env-vars' to reproduce
# # the environment used for building.
# dumpVars() {
#     if [ "${noDumpEnvVars:-0}" != 1 ]; then
#         export > "$NIX_BUILD_TOP/env-vars" || true
#     fi
# }


# Utility function: echo the base name of the given path, with the
# prefix `HASH-' removed, if present.
sub stripHash {
    return basename(shift) =~ s/^[a-z0-9]{32}-//r;
}



$ENV{unpackCmdHooks} = ($ENV{unpackCmdHooks} || "") . " _defaultUnpack";
sub _defaultUnpack {
    my $fn = shift;
    print("_defaultUnpack($fn)\n");

    if (-d $fn) {

        # We can't preserve hardlinks because they may have been
        # introduced by store optimization, which might break things
        # in the build.
        #cp -pr --reflink=auto -- "$fn" "$(stripHash "$fn")"
        dircopy($fn, stripHash($fn)) or die "$!";
        return 0;
    } else {
        # Win10 has native C:\Windows\System32\curl.exe and C:\Windows\System32\tar.exe, but not bzip2
        # so let's use 7z (TODO include to stdenv)
        if ($fn =~ /\.tar\.|\.tgz$|\.tbz$|\.tbz2|\.txz$/) {
            my $exitcode = system("\"C:/Program Files/7-Zip/7z.exe\" x \"$fn\" -so | \"C:/Program Files/7-Zip/7z.exe\" x -aoa -si -ttar");
            print("exitcode=$exitcode\n");
            return $exitcode;
        } else {
            my $exitcode = system("\"C:/Program Files/7-Zip/7z.exe\" x \"$fn\"");
            print("exitcode=$exitcode\n");
            return $exitcode;
        }
        #return system('C:/Program Files/7-Zip/7z.exe', 'x', $fn);
        #return 1;
    }
}

#
#
sub unpackFile {
    my $curSrc = shift;
    print("unpacking source archive $curSrc\n");
    die "do not know how to unpack source archive $curSrc" if runOneHook('unpackCmd', $curSrc) != 0;
}


sub unpackPhase() {
    runHook 'preUnpack';

    die 'variable $src or $srcs should point to the source' unless $ENV{src} || $ENV{srcs};
    $ENV{srcs} = $ENV{src} unless $ENV{srcs};

    # To determine the source directory created by unpacking the
    # source archives, we record the contents of the current
    # directory, then look below which directory got added.  Yeah,
    # it's rather hacky.
    my %dirsBefore = map { $_ => 1 } grep { -d $_ } glob("*");

    # Unpack all source archives.
    for $i (split / /, $ENV{srcs}) {
        unpackFile($i);
    }

    # Find the source directory.

    # set to empty if unset
    my $sourceRoot = $ENV{sourceRoot} || '';

    if ($ENV{setSourceRoot}) {
        runOneHook('setSourceRoot');
    } elsif (!$ENV{sourceRoot}) {
        for $i (glob('*')) {
            next unless -d $i;
            next if exists($dirsBefore{$i});
            die "unpacker produced multiple directories" if $ENV{sourceRoot};
            $ENV{sourceRoot} = $i;
        }
    }

    die "unpacker appears to have produced no directories" unless $ENV{sourceRoot};

    print("source root is $ENV{sourceRoot}\n");

    # By default, add write permission to the sources.  This is often
    # necessary when sources have been copied from other store
    # locations.
    if ($ENV{dontMakeSourcesWritable} ne '1') {
#       chmod -R u+w -- "$sourceRoot"
        use File::Find qw(find);
        sub process { chmod 0777, $_; };
        find({ wanted => \&process, no_chdir => 1}, $ENV{sourceRoot});
    }

    runHook 'postUnpack';
}
#
#
sub patchPhase() {
    runHook 'prePatch';
#
    for $i (split / +/, $ENV{patches}) {
        print("applying patch $i\n");

        # TODO: native Windows utils ?
        my $uncompress = 'C:\Git\usr\bin\cat.exe';
        $uncompress = 'C:\Git\usr\bin\gzip.exe -d'  if $i =~ /\.gz$/;
        $uncompress = 'C:\Git\usr\bin\bzip2.exe -d' if $i =~ /\.bz2$/;
        die "todo"                                  if $i =~ /\.xz$/;    # $uncompress = 'xz -d'
        die "todo"                                  if $i =~ /\.lzma$/;  # $uncompress = 'lzma -d'

        system("$uncompress < \"$i\" 2>&1 | C:\\Git\\usr\\bin\\patch.exe " . ($ENV{patchFlags} || '-p1')) == 0 or die "patch failed: $!";
#         # "2>&1" is a hack to make patch fail if the decompressor fails (nonexistent patch, etc.)
#         # shellcheck disable=SC2086
#         $uncompress < "$i" 2>&1 | patch ${patchFlags:--p1}
    }
#
    runHook 'postPatch';
}
#
#
# fixLibtool() {
#     sed -i -e 's^eval sys_lib_.*search_path=.*^^' "$1"
# }
#
#
sub configurePhase() {
    runHook 'preConfigure';
#
#     # set to empty if unset
#     : ${configureScript=}
#     : ${configureFlags=}
#
#     if [[ -z "$configureScript" && -x ./configure ]]; then
#         configureScript=./configure
#     fi
#
#     if [ -z "${dontFixLibtool:-}" ]; then
#         local i
#         find . -iname "ltmain.sh" -print0 | while IFS='' read -r -d '' i; do
#             echo "fixing libtool script $i"
#             fixLibtool "$i"
#         done
#     fi
#
#     if [[ -z "${dontAddPrefix:-}" && -n "$prefix" ]]; then
#         configureFlags="${prefixKey:---prefix=}$prefix $configureFlags"
#     fi
#
#     # Add --disable-dependency-tracking to speed up some builds.
#     if [ -z "${dontAddDisableDepTrack:-}" ]; then
#         if [ -f "$configureScript" ] && grep -q dependency-tracking "$configureScript"; then
#             configureFlags="--disable-dependency-tracking $configureFlags"
#         fi
#     fi
#
#     # By default, disable static builds.
#     if [ -z "${dontDisableStatic:-}" ]; then
#         if [ -f "$configureScript" ] && grep -q enable-static "$configureScript"; then
#             configureFlags="--disable-static $configureFlags"
#         fi
#     fi
#
#     if [ -n "$configureScript" ]; then
#         # Old bash empty array hack
#         # shellcheck disable=SC2086
#         local flagsArray=(
#             $configureFlags ${configureFlagsArray+"${configureFlagsArray[@]}"}
#         )
#         echoCmd 'configure flags' "${flagsArray[@]}"
#         # shellcheck disable=SC2086
#         $configureScript "${flagsArray[@]}"
#         unset flagsArray
#     else
#         echo "no configure script, doing nothing"
#     fi
#
    runHook 'postConfigure';
}
#
#
sub buildPhase() {
    runHook 'preBuild';
#
#     # set to empty if unset
#     : ${makeFlags=}
#
#     if [[ -z "$makeFlags" && -z "${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ]]; then
#         echo "no Makefile, doing nothing"
#     else
#         foundMakefile=1
#
#         # See https://github.com/NixOS/nixpkgs/pull/1354#issuecomment-31260409
#         makeFlags="SHELL=$SHELL $makeFlags"
#
#         # Old bash empty array hack
#         # shellcheck disable=SC2086
#         local flagsArray=(
#             ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}}
#             $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
#             $buildFlags ${buildFlagsArray+"${buildFlagsArray[@]}"}
#         )
#
#         echoCmd 'build flags' "${flagsArray[@]}"
#         make ${makefile:+-f $makefile} "${flagsArray[@]}"
#         unset flagsArray
#     fi
#
    runHook 'postBuild';
}
#
#
sub checkPhase() {
    runHook 'preCheck';
#
#     if [[ -z "${foundMakefile:-}" ]]; then
#         echo "no Makefile or custom buildPhase, doing nothing"
#         runHook postCheck
#         return
#     fi
#
#     if [[ -z "${checkTarget:-}" ]]; then
#         #TODO(@oxij): should flagsArray influence make -n?
#         if make -n ${makefile:+-f $makefile} check >/dev/null 2>&1; then
#             checkTarget=check
#         elif make -n ${makefile:+-f $makefile} test >/dev/null 2>&1; then
#             checkTarget=test
#         fi
#     fi
#
#     if [[ -z "${checkTarget:-}" ]]; then
#         echo "no check/test target in ${makefile:-Makefile}, doing nothing"
#     else
#         # Old bash empty array hack
#         # shellcheck disable=SC2086
#         local flagsArray=(
#             ${enableParallelChecking:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}}
#             $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
#             ${checkFlags:-VERBOSE=y} ${checkFlagsArray+"${checkFlagsArray[@]}"}
#             ${checkTarget}
#         )
#
#         echoCmd 'check flags' "${flagsArray[@]}"
#         make ${makefile:+-f $makefile} "${flagsArray[@]}"
#
#         unset flagsArray
#     fi
#
    runHook 'postCheck';
}
#
#
sub installPhase() {
    runHook 'preInstall';
#
#     if [ -n "$prefix" ]; then
#         mkdir -p "$prefix"
#     fi
#
#     # Old bash empty array hack
#     # shellcheck disable=SC2086
#     local flagsArray=(
#         $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
#         $installFlags ${installFlagsArray+"${installFlagsArray[@]}"}
#         ${installTargets:-install}
#     )
#
#     echoCmd 'install flags' "${flagsArray[@]}"
#     make ${makefile:+-f $makefile} "${flagsArray[@]}"
#     unset flagsArray
#
    runHook 'postInstall';
}
#
#
# # The fixup phase performs generic, package-independent stuff, like
# # stripping binaries, running patchelf and setting
# # propagated-build-inputs.
sub fixupPhase() {
#     # Make sure everything is writable so "strip" et al. work.
#     local output
#     for output in $outputs; do
#         if [ -e "${!output}" ]; then chmod -R u+w "${!output}"; fi
#     done
#
    runHook 'preFixup';
#
#     # Apply fixup to each output.
#     local output
#     for output in $outputs; do
#         prefix="${!output}" runHook fixupOutput
#     done
#
#
#     # Propagate dependencies & setup hook into the development output.
#     declare -ra flatVars=(
#         # Build
#         depsBuildBuildPropagated
#         propagatedNativeBuildInputs
#         depsBuildTargetPropagated
#         # Host
#         depsHostHostPropagated
#         propagatedBuildInputs
#         # Target
#         depsTargetTargetPropagated
#     )
#     declare -ra flatFiles=(
#         "${propagatedBuildDepFiles[@]}"
#         "${propagatedHostDepFiles[@]}"
#         "${propagatedTargetDepFiles[@]}"
#     )
#
#     local propagatedInputsIndex
#     for propagatedInputsIndex in "${!flatVars[@]}"; do
#         local propagatedInputsSlice="${flatVars[$propagatedInputsIndex]}[@]"
#         local propagatedInputsFile="${flatFiles[$propagatedInputsIndex]}"
#
#         [[ "${!propagatedInputsSlice}" ]] || continue
#
#         mkdir -p "${!outputDev}/nix-support"
#         # shellcheck disable=SC2086
#         printWords ${!propagatedInputsSlice} > "${!outputDev}/nix-support/$propagatedInputsFile"
#     done
#
#
#     if [ -n "${setupHook:-}" ]; then
#         mkdir -p "${!outputDev}/nix-support"
#         substituteAll "$setupHook" "${!outputDev}/nix-support/setup-hook"
#     fi
#
#     # TODO(@Ericson2314): Remove after https://github.com/NixOS/nixpkgs/pull/31414
#     if [ -n "${setupHooks:-}" ]; then
#         mkdir -p "${!outputDev}/nix-support"
#         local hook
#         for hook in $setupHooks; do
#             local content
#             consumeEntire content < "$hook"
#             substituteAllStream content >> "${!outputDev}/nix-support/setup-hook"
#             unset -v content
#         done
#         unset -v hook
#     fi
#
#     # Propagate user-env packages into the output with binaries, TODO?
#
#     if [ -n "${propagatedUserEnvPkgs:-}" ]; then
#         mkdir -p "${!outputBin}/nix-support"
#         # shellcheck disable=SC2086
#         printWords $propagatedUserEnvPkgs > "${!outputBin}/nix-support/propagated-user-env-packages"
#     fi
#
    runHook 'postFixup';
}
#
#
sub installCheckPhase() {
    runHook 'preInstallCheck';
#
#     if [[ -z "${foundMakefile:-}" ]]; then
#         echo "no Makefile or custom buildPhase, doing nothing"
#     #TODO(@oxij): should flagsArray influence make -n?
#     elif [[ -z "${installCheckTarget:-}" ]] \
#        && ! make -n ${makefile:+-f $makefile} ${installCheckTarget:-installcheck} >/dev/null 2>&1; then
#         echo "no installcheck target in ${makefile:-Makefile}, doing nothing"
#     else
#         # Old bash empty array hack
#         # shellcheck disable=SC2086
#         local flagsArray=(
#             ${enableParallelChecking:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}}
#             $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
#             $installCheckFlags ${installCheckFlagsArray+"${installCheckFlagsArray[@]}"}
#             ${installCheckTarget:-installcheck}
#         )
#
#         echoCmd 'installcheck flags' "${flagsArray[@]}"
#         make ${makefile:+-f $makefile} "${flagsArray[@]}"
#         unset flagsArray
#     fi
#
    runHook 'postInstallCheck';
}
#
#
sub distPhase() {
    runHook 'preDist';
#
#     # Old bash empty array hack
#     # shellcheck disable=SC2086
#     local flagsArray=(
#         $distFlags ${distFlagsArray+"${distFlagsArray[@]}"} ${distTarget:-dist}
#     )
#
#     echo 'dist flags: %q' "${flagsArray[@]}"
#     make ${makefile:+-f $makefile} "${flagsArray[@]}"
#
#     if [ "${dontCopyDist:-0}" != 1 ]; then
#         mkdir -p "$out/tarballs"
#
#         # Note: don't quote $tarballs, since we explicitly permit
#         # wildcards in there.
#         # shellcheck disable=SC2086
#         cp -pvd ${tarballs:-*.tar.gz} "$out/tarballs"
#     fi
#
    runHook 'postDist';
}
#
#
sub showPhaseHeader {
    my $phase = shift;
       if ($phase eq 'unpackPhase')       { print("unpacking sources\n"); }
    elsif ($phase eq 'patchPhase')        { print("patching sources\n"); }
    elsif ($phase eq 'configurePhase')    { print("configuring\n"); }
    elsif ($phase eq 'buildPhase')        { print("building\n"); }
    elsif ($phase eq 'checkPhase')        { print("running tests\n"); }
    elsif ($phase eq 'installPhase')      { print("installing\n"); }
    elsif ($phase eq 'fixupPhase')        { print("post-installation fixup\n"); }
    elsif ($phase eq 'installCheckPhase') { print("running install tests\n"); }
    else                                  { print("$phase\n"); }
}
#
#
my $phases;
sub genericBuild() {
    for $k (sort (keys %ENV)) {
      print("genericBuild env: $k=$ENV{$k};\n");
    }

    if (defined $ENV{buildCommandPath}) {
        #require($ENV{buildCommandPath}) or die $!;
        eval readFile($ENV{buildCommandPath});
        if ($@) { print "$@" ; die; }
        return;
    }

    if (defined $ENV{buildCommand}) {
        print("eval '$ENV{buildCommand}'\n");
        eval "$ENV{buildCommand}";
        if ($@) { print "$@" ; die; }
        return;
    }

    if ($ENV{phases}) {
        $phases = $ENV{phases};
    } else {
        $phases = "$ENV{prePhases} unpackPhase patchPhase $ENV{preConfigurePhases} configurePhase $ENV{preBuildPhases} buildPhase checkPhase $ENV{preInstallPhases} installPhase $ENV{preFixupPhases} fixupPhase installCheckPhase $ENV{preDistPhases} distPhase $ENV{postPhases}";
    }
    $phases =~ s/^\s+|\s+$//;
    print("phases=$phases\n");

    for $curPhase (split / +/, $phases) {
        print("curPhase1=$curPhase\n");
        next if $curPhase eq "buildPhase"           && $ENV{dontBuild};
        next if $curPhase eq "checkPhase"           && !$ENV{doCheck};
        next if $curPhase eq "installPhase"         && $ENV{dontInstall};
        next if $curPhase eq "fixupPhase"           && $ENV{dontFixup};
        next if $curPhase eq "installCheckPhase"    && !$ENV{doInstallCheck};
        next if $curPhase eq "distPhase"            && !$ENV{doDist};
        print("curPhase2=$curPhase\n");

#         if [[ -n $NIX_LOG_FD ]]; then
#             echo "@nix { \"action\": \"setPhase\", \"phase\": \"$curPhase\" }" >&$NIX_LOG_FD
#         fi

        showPhaseHeader($curPhase);
#         dumpVars
#
#         # Evaluate the variable named $curPhase if it exists, otherwise the
#         # function named $curPhase.
#         local oldOpts="$(shopt -po nounset)"
#         set +u
        if (defined $ENV{$curPhase}) {
            print("eval '$ENV{$curPhase}'\n");
            eval "$ENV{$curPhase}";
            if ($@) { print "$@" ; die; }
        } else {
            print("eval '$curPhase'\n");
            eval "$curPhase()";
            if ($@) { print "$@" ; die; }
            print("evaled '$curPhase'\n");
        }
#         eval "${!curPhase:-$curPhase}"
#         eval "$oldOpts"
#
        chdir $ENV{sourceRoot} if $curPhase eq "unpackPhase" && $ENV{sourceRoot};
    }
}


# Execute the post-hooks.
runHook 'postHook';


# Execute the global user hook (defined through the Nixpkgs
# configuration option ‘stdenv.userHook’).  This can be used to set
# global compiler optimisation flags, for instance.
runHook 'userHook';


# dumpVars
#
# # Disable nounset for nix-shell.
# set +u
#
1;
