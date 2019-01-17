# bashism; todo: pass lambda
$ENV{addPerlLibPath} = q[
    my ($path) = @_;
    addToSearchPath('PERL5LIB', "$path/lib");
];

addEnvHooks($hostOffset, 'addPerlLibPath');
