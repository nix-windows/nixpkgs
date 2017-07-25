import ./make-test.nix ({ pkgs, ...} : {
  name = "hdfs";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ volth ];
  };
  nodes =
    let
    in {
      node1 = { lib, pkgs, ... }: {
        virtualisation.memorySize = 1000;
        imports = [ ./common/x11.nix ./common/user-account.nix ];
        networking.firewall.enable = false;
        environment.systemPackages = [ pkgs.firefox ];
        services = {
          xserver.displayManager.auto.user = "alice";
          hbase = {
            masterserver.enable = true;
            hbaseSite = {
              "hbase.tmp.dir" = "/var/tmp/hbase";
              "hbase.rootdir" = "file:///var/db/hbase";
            };
          };
        };
      };
    };

  testScript = { nodes, ... }: ''
    startAll;

    $node1->waitForX;
    $node1->waitForFile("/home/alice/.Xauthority");
    $node1->succeed("xauth merge ~alice/.Xauthority");

    $node1->sleep(5);

    $node1->execute("xterm &");
    $node1->sleep(30);

    $node1->sendChars("firefox --setDefaultBrowser http://node1:16010\n");
    $node1->sendChars(" \n");
    $node1->sleep(30);

    $node1->screenshot("screenshot");
  '';
})
