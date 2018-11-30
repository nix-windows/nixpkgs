#export PATH=
#for i in $initialPath; do
#    if [ "$i" = / ]; then i=; fi
#    PATH=$PATH${PATH:+:}$i/bin
#done
#
print("mkdir $ENV{out}\n");
mkdir $ENV{out} or die "$!";
#
# 
open(my $fh, ">:encoding(UTF-8)", "$ENV{out}/setup.pm") or die "$!";
print $fh "\$ENV{SHELL}='$ENV{shell}';\n";
print $fh "\$ENV{initialPath}='$ENV{initialPath}';\n";
print $fh "\$ENV{defaultNativeBuildInputs}='$ENV{defaultNativeBuildInputs}';\n";
print $fh "\$ENV{defaultBuildInputs}='$ENV{defaultBuildInputs}';\n";

print $fh "# preHook\n";
print $fh "$ENV{preHook}\n";
print $fh "# /preHook\n";

print $fh "# setup\n";
open(my $in, "<:encoding(UTF-8)", "$ENV{setup}") or die "$!";
while (my $row = <$in>) {
  chomp $row;
  print $fh "$row\n";
}
close($in);
print $fh "# /setup\n";

close($fh);

#cat "$setup" >> $out/setup
#
## Allow the user to install stdenv using nix-env and get the packages
## in stdenv.
#mkdir $out/nix-support
#if [ "$propagatedUserEnvPkgs" ]; then
#    printf '%s ' $propagatedUserEnvPkgs > $out/nix-support/propagated-user-env-packages
#fi
#