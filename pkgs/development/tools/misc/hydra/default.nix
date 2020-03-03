{ stdenv, nix, perlPackages, buildEnv, fetchFromGitHub
, makeWrapper, autoconf, automake, libtool, unzip, pkgconfig, sqlite, libpqxx
, gitAndTools, mercurial, darcs, subversion, bazaar, openssl, bzip2, libxslt
, guile, perl, postgresql, nukeReferences, git, boehmgc, nlohmann_json
, docbook_xsl, openssh, gnused, coreutils, findutils, gzip, lzma, gnutar
, rpm, dpkg, cdrkit, pixz, lib, boost, autoreconfHook
}:

with stdenv;

if lib.versions.major nix.version == "1"
  then throw "This Hydra version doesn't support Nix 1.x"
else

let
  perlDeps = buildEnv {
    name = "hydra-perl-deps";
    paths = with perlPackages; lib.closePropagation
      [ ModulePluggable
        CatalystActionREST
        CatalystAuthenticationStoreDBIxClass
        CatalystDevel
        CatalystDispatchTypeRegex
        CatalystPluginAccessLog
        CatalystPluginAuthorizationRoles
        CatalystPluginCaptcha
        CatalystPluginSessionStateCookie
        CatalystPluginSessionStoreFastMmap
        CatalystPluginStackTrace
        CatalystRuntime
        CatalystTraitForRequestProxyBase
        CatalystViewDownload
        CatalystViewJSON
        CatalystViewTT
        CatalystXScriptServerStarman
        CatalystXRoleApplicator
        CryptRandPasswd
        DBDPg
        DBDSQLite
        DataDump
        DateTime
        DigestSHA1
        EmailMIME
        EmailSender
        FileSlurp
        IOCompress
        IPCRun
        JSON
        JSONAny
        JSONXS
        LWP
        LWPProtocolHttps
        NetAmazonS3
        NetPrometheus
        NetStatsd
        PadWalker
        Readonly
        SQLSplitStatement
        SetScalar
        Starman
        SysHostnameLong
        TermSizeAny
        TextDiff
        TextTable
        XMLSimple
        nix
        nix.perl-bindings
        git
        boehmgc
      ];
  };
in stdenv.mkDerivation rec {
  pname = "hydra";
  version = "2020-02-06";

  inherit stdenv;

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = pname;
    rev = "2b4f14963b16b21ebfcd6b6bfa7832842e9b2afc";
    sha256 = "16q0cffcsfx5pqd91n9k19850c1nbh4vvbd9h8yi64ihn7v8bick";
  };

  buildInputs =
    [ makeWrapper autoconf automake libtool unzip nukeReferences sqlite libpqxx
      gitAndTools.top-git mercurial darcs subversion bazaar openssl bzip2 libxslt
      guile # optional, for Guile + Guix support
      perlDeps perl nix
      postgresql # for running the tests
      nlohmann_json
      boost
    ];

  hydraPath = lib.makeBinPath (
    [ sqlite subversion openssh nix coreutils findutils pixz
      gzip bzip2 lzma gnutar unzip git gitAndTools.top-git mercurial darcs gnused bazaar
    ] ++ lib.optionals stdenv.isLinux [ rpm dpkg cdrkit ] );

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  configureFlags = [ "--with-docbook-xsl=${docbook_xsl}/xml/xsl/docbook" ];

  NIX_CFLAGS_COMPILE = "-pthread";

  shellHook = ''
    PATH=$(pwd)/src/script:$(pwd)/src/hydra-eval-jobs:$(pwd)/src/hydra-queue-runner:$(pwd)/src/hydra-evaluator:$PATH
    PERL5LIB=$(pwd)/src/lib:$PERL5LIB;
  '';

  enableParallelBuilding = true;

  preCheck = ''
    patchShebangs .
    export LOGNAME=''${LOGNAME:-foo}
  '';

  postInstall = ''
    mkdir -p $out/nix-support
    for i in $out/bin/*; do
        read -n 4 chars < $i
        if [[ $chars =~ ELF ]]; then continue; fi
        wrapProgram $i \
            --prefix PERL5LIB ':' $out/libexec/hydra/lib:$PERL5LIB \
            --prefix PATH ':' $out/bin:$hydraPath \
            --set HYDRA_RELEASE ${version} \
            --set HYDRA_HOME $out/libexec/hydra \
            --set NIX_RELEASE ${nix.name or "unknown"}
    done
  ''; # */

  dontStrip = true;

  passthru.perlDeps = perlDeps;

  meta = with stdenv.lib; {
    description = "Nix-based continuous build system";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
