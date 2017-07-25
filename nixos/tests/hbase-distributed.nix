import ./make-test.nix ({ pkgs, ...} : {
  name = "hdfs";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ volth ];
  };
  nodes =
    let
      coreSite = {
        "fs.defaultFS"                                         = "hdfs://node1:8020";
        "hadoop.native.lib"                                    = "true";
      };
      hdfsSite = {
        "dfs.replication"                                      = "1";
        "dfs.permissions"                                      = "false";
        "dfs.namenode.datanode.registration.ip-hostname-check" = "false";
        "dfs.namenode.fs-limits.max-component-length"          = "512";
        "dfs.name.dir"                                         = "/var/lib/namenode";
        "dfs.datanode.synconclose"                             = "true";
        "dfs.datanode.data.dir"                                = "/var/lib/datanode";
      };
      hbaseSite = {
        "hbase.tmp.dir"                                        = "/var/tmp/hbase";
        "hbase.cluster.distributed"                            = "true";
        "hbase.zookeeper.quorum"                               = "node1:2181";
        "zookeeper.znode.parent"                               = "/hbase";
        "hbase.rootdir"                                        = "hdfs://node1:8020/hbase";
      };
    in rec {
      node1 = { lib, pkgs, ... }: {
        virtualisation.memorySize = 1000;
        imports = [ ./common/x11.nix ./common/user-account.nix ];
        networking.firewall.enable = false;
        environment.systemPackages = [ pkgs.firefox ];
        services = {
          xserver.displayManager.auto.user = "alice";
          zookeeper.enable = true;
          hdfs = {
            namenode.enable = true;
            datanode.enable = true;
            inherit coreSite hdfsSite;
          };
          hbase = {
            masterserver.enable = true;
            regionserver.enable = true;
            inherit coreSite hdfsSite hbaseSite;
          };
        };
      };
      node2 = { lib, pkgs, ... }: {
        virtualisation.memorySize = 500;
        networking.firewall.enable = false;
        services = {
          hdfs = {
            datanode.enable = true;
            inherit coreSite hdfsSite;
          };
          hbase = {
            regionserver.enable = true;
            inherit coreSite hdfsSite hbaseSite;
          };
        };
      };
      node3 = node2;
    };

  testScript = { nodes, ... }: ''
    startAll;

    $node1->waitForX;
    $node1->waitForFile("/home/alice/.Xauthority");
    $node1->succeed("xauth merge ~alice/.Xauthority");
    $node1->sleep(5);

    $node1->execute("xterm &");
    $node1->sleep(10);
    $node1->sendKeys("alt-ret");
    $node1->sleep(120);

    $node1->sendChars("firefox");
    $node1->sendChars(" --setDefaultBrowser"); # supress the modal dialog
    $node1->sendChars(" http://node1:16010 http://node1:16030 http://node1:50070");
    $node1->sendChars(" http://node1:50075 http://node2:50075 http://node3:50075\n");
    $node1->sleep(30);

    $node1->screenshot("screenshot");
  '';
})
