{ stdenv, fetchzip }:

let
  version = "1.11.4";
  go-bin = fetchzip {
    name = "go-${version}";
    url = "https://dl.google.com/go/go${version}.windows-amd64.zip";
    sha256 = "115mcfr2yyxrqh5mwj3gw4zzfkdj8sr93ni90anwz5lc12gksz8j";
  };
in
  go-bin
