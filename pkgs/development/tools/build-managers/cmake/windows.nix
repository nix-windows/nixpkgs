{ stdenv, fetchFromGitHub, fetchzip
, isBinaryDistribution ? false
}:

let
  version = "3.13.2";
  cmake-bin = fetchzip {
    url = "https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}-win64-x64.zip";
    extraPostFetch = ''
      move "$ENV{out}/doc", "$ENV{out}/share/doc" or die $!;
      move "$ENV{out}/man", "$ENV{out}/share/man" or die $!;
    '';
    sha256 = "1krzcf4cf3nc04fklq7a2bncq3lq8qz8yna2z06vs3pna3zn9863";
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
        mkdir("build");                                                                 # -\
        chdir("build");                                                                 #   >- TODO: setup hook should handle this
        system("cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ENV{out} .."); # -/
      '';

      buildPhase = ''
        system("nmake install");
        move "$ENV{out}/doc", "$ENV{out}/share/doc" or die $!;
      '';

      meta = with stdenv.lib; {
        homepage = http://www.cmake.org/;
        description = "Cross-Platform Makefile Generator";
        platforms = platforms.windows;
        maintainers = with maintainers; [ ttuegel lnl7 ];
        license = licenses.bsd3;
      };
    }
