{ stdenv, fetchFromGitHub, fetchzip
, isBinaryDistribution ? false
}:

let
  version = "3.13.2";
  cmake-bin = fetchzip {
    url = "https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}-win64-x64.zip";
    sha256 = "19cjsan1hk0mhamp2fqxzmzqsypwydyk8rhdvjq1n2bvkdsjnl99";
  };
in
  if isBinaryDistribution then
    cmake-bin
  else
    stdenv.mkDerivation {
      name = "cmake-${version}";

      nativeBuildInputs = [ cmake-bin ];

      src = fetchFromGitHub {
        owner = "Kitware";
        repo = "CMake";
        rev = "v${version}";
        sha256 = "0jwl208z9v4gyd4jzpfksvjlgq28kc3h9ajjqzjib7w5b5jhxly3";
      };

      configurePhase = ''
        mkdirL("build");                                                                # -\
        chdir("build");                                                                 #   >- TODO: setup hook should handle this
        system("cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ENV{out} .."); # -/
      '';

      buildPhase = ''
        system("nmake install");
      '';

      meta = with stdenv.lib; {
        homepage = http://www.cmake.org/;
        description = "Cross-Platform Makefile Generator";
        platforms = platforms.windows;
        maintainers = with maintainers; [ ttuegel lnl7 ];
        license = licenses.bsd3;
      };
    }
