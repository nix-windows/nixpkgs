#print("TODO: fetchgit/builder.pl");
#exit(1);
require "$ENV{stdenv}/setup.pm";

print("exporting $ENV{url} (rev $ENV{rev}) into $ENV{out}\n");

system($ENV{shell}, $ENV{fetcher}, '--builder',
       '--url', "\"$ENV{url}\"",
       '--out', "\"$ENV{out}\"",
       '--rev', "\"$ENV{rev}\"",
       $ENV{leaveDotGit}     ? ('--leave-dotGit'                       ) : (),
       $ENV{deepClone}       ? ('--deepClone'                          ) : (),
       $ENV{fetchSubmodules} ? ('--fetch-submodules'                   ) : (),
       $ENV{branchName}      ? ('--branch-name', "\"$ENV{branchName}\"") : ());

runHook('postFetch');
#stopNest();
