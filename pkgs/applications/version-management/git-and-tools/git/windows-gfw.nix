{ stdenv, fetchzip, perl, curl, openssl, zlib }:

let
  version = "2.29.1";
in
fetchzip {
  name = "git-${version}";
  url = "https://github.com/git-for-windows/git/releases/download/v${version}.windows.1/PortableGit-${version}-64-bit.7z.exe";
  stripRoot = false;
  extraPostFetch = ''
    changeFile {
      s/symlinks = false/symlinks = true/g;
      s/autocrlf = true/autocrlf = false/g;
      $_
    } "$ENV{out}/etc/gitconfig";
  '';
  sha256 = "1nlz452gk7gi2yyn1rx44nlyqwqpz7ynffqlcq6h5z1vhcf5k5vx";
}
