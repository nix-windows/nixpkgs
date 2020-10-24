{ stdenv, fetchFromGitHub, fetchzip
, isBinaryDistribution ? false
}:

let
  version = "3.18.4";
  cmake-bin = fetchzip {
    url = "https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}-win64-x64.zip";
    sha256 = "0jz9nq2h4pddjhbhcmq708salxm3gn0nk2yvkqg35clfgwizxx3g";
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
        sha256 = "1bqqz64bv1vy295rbpmi9hvlx4vgl6q36sajga7y8yxs9v74azdn";
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
