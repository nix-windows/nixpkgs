rem set OLDNIX=C:\nix2
set NIX=C:\nix-windows
set NIX_STORE_DIR=C:\nix\store
set NIX_PATH=nixpkgs=..\..\..\..\..

for /f %%i in ('%NIX%\bin\nix-build.exe --no-out-link -E "(import <nixpkgs> { }).git"'                                     ) do set GIT=%%i
for /f %%i in ('%NIX%\bin\nix-build.exe --no-out-link -E "(import <nixpkgs> { }).stdenv.cc.perl-for-stdenv-shell"'         ) do set PERL=%%i
for /f %%i in ('%NIX%\bin\nix-build.exe --no-out-link -E "(import <nixpkgs> { }).python27.withPackages (p: [ p.pywin32 ])"') do set PYTHON2=%%i
echo NIX=%NIX%
echo GIT=%GIT%
echo PERL=%PERL%
echo PYTHON2=%PYTHON2%

%PERL%\bin\perl.exe update-git.pl 73.0.3668.0
