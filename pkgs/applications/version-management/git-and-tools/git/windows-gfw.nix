{ stdenv, fetchzip, perl, curl, openssl, zlib }:

let
  version = "2.20.1";
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
    } "$ENV{out}/mingw64/etc/gitconfig";
  '';
  sha256 = "0rbilp0rj1qr6m84piimkprwhgnd2fjxmqw33k8fymifa41lrvw0";
}
