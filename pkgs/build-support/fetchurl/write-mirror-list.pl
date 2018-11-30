require "$ENV{stdenv}/setup.pm";

open(my $fh, ">$ENV{out}");
# !!! this is kinda hacky.
print $fh "%mirrors = {};\n";
for my $k (sort (keys %ENV)) {
  print $fh '$mirrors{'.lc($k).'} = ['.(join ', ', (map { "'" . $_ . "'" } (split / /, $ENV{$k})))."];\n" if $ENV{$k} =~ /:\/\//;
}
close($fh);
