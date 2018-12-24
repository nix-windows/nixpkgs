# This function provides generic bits to install a Python wheel.

{ python
, bootstrapped-pip
}:

{ buildInputs ? []
# Additional flags to pass to "pip install".
, installFlags ? []
, ... } @ attrs:

attrs // {
  buildInputs = buildInputs ++ [ bootstrapped-pip ];

  configurePhase = attrs.configurePhase or (if python.stdenv.hostPlatform.isMicrosoft then ''
    runHook 'preConfigure';
    runHook 'postConfigure';
  '' else ''
    runHook preConfigure
    runHook postConfigure
  '');

  installPhase = attrs.installPhase or (if python.stdenv.hostPlatform.isMicrosoft then ''
    runHook 'preInstall';

    make_path "$ENV{out}/${python.sitePackages}";
    $ENV{PYTHONPATH} = "$ENV{out}/${python.sitePackages}:$ENV{PYTHONPATH}";

    my $oldwd = getcwd();
    chdir('dist');
    system("${bootstrapped-pip}/Scripts/pip.exe install *.whl --no-index --prefix=$ENV{out} --no-cache ${toString installFlags} --build tmpbuild") == 0 or die;
    chdir($oldwd);

    runHook 'postInstall';
  '' else ''
    runHook preInstall

    mkdir -p "$out/${python.sitePackages}"
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    pushd dist
    ${bootstrapped-pip}/bin/pip install *.whl --no-index --prefix=$out --no-cache ${toString installFlags} --build tmpbuild
    popd

    runHook postInstall
  '');
}
