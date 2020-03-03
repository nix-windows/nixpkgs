import ./default.nix {
  rustcVersion = "1.37.0";
  rustcSha256 = "1hrqprybhkhs6d9b5pjskfnc5z9v2l2gync7nb39qjb5s0h703hj";
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.36.0";

  # fetch hashes by running `print-hashes.sh 1.36.0`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "9f95c3e96622a792858c8a1c9274fa63e6992370493b27c1ac7299a3bec5156d";
    x86_64-unknown-linux-gnu = "15e592ec52f14a0586dcebc87a957e472c4544e07359314f6354e2b8bd284c55";
    arm-unknown-linux-gnueabihf = "27103d3c334bfe67fa5961612f7ccd7bd0cd6bca3352103bae6a704f0e98fa85";
    armv7-unknown-linux-gnueabihf = "798181a728017068f9eddfa665771805d97846cd87bddcd67e0fe27c8d082ceb";
    aarch64-unknown-linux-gnu = "db78c24d93756f9fe232f081dbc4a46d38f8eec98353a9e78b9b164f9628042d";
    i686-apple-darwin = "3dbc34fdea8bc030badf9c8b2572c09fd3f5369b59ac099fc521064b390b9e60";
    x86_64-apple-darwin = "91f151ec7e24f5b0645948d439fc25172ec4012f0584dd16c3fb1acb709aa325";
  };

  selectRustPackage = pkgs: pkgs.rust_1_37_0;
}
