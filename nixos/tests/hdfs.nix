import ./make-test.nix ({ pkgs, ...} : {
  name = "hdfs";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ volth ];
  };
  nodes =
    let
      common = { config, pkgs, lib, ... }: {
        config = {
          networking.firewall.enable = false;
          services.hdfs = {
            package = pkgs.hadoop_2_7;

            # global/client
            coreSite."fs.defaultFS"                                         = "hdfs://mycluster";
            coreSite."hadoop.native.lib"                                    = "true";
            hdfsSite."dfs.client.failover.proxy.provider.mycluster"         = "org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider";
            hdfsSite."dfs.nameservices"                                     = "mycluster";
            hdfsSite."dfs.ha.namenodes.mycluster"                           = "nn1,nn2";
            hdfsSite."dfs.namenode.rpc-address.mycluster.nn1"               = "node1:8020";
            hdfsSite."dfs.namenode.http-address.mycluster.nn1"              = "node1:50070";
            hdfsSite."dfs.namenode.rpc-address.mycluster.nn2"               = "node2:8020";
            hdfsSite."dfs.namenode.http-address.mycluster.nn2"              = "node2:50070";
            hdfsSite."dfs.namenode.shared.edits.dir"                        = "qjournal://node1:8485;node2:8485;node3:8485/mycluster";
            coreSite."dfs.ha.fencing.methods"                               = "shell(/run/current-system/sw/bin/true)";

            hdfsSite."dfs.replication"                                      = "3";
            hdfsSite."dfs.permissions"                                      = "false";
            # namenode
            hdfsSite."dfs.name.dir"                                         = "/var/lib/namenode";
            hdfsSite."dfs.namenode.datanode.registration.ip-hostname-check" = "false";
            hdfsSite."dfs.namenode.fs-limits.max-component-length"          = "512";
            # datanode
            hdfsSite."dfs.datanode.data.dir"                                = "/var/lib/datanode";
            hdfsSite."dfs.datanode.synconclose"                             = "true";
            hdfsSite."dfs.datanode.handler.count"                           = "10";
            hdfsSite."dfs.datanode.max.xcievers"                            = "10000";
            hdfsSite."dfs.datanode.fsdataset.volume.choosing.policy"        = "org.apache.hadoop.hdfs.server.datanode.fsdataset.AvailableSpaceVolumeChoosingPolicy";
            hdfsSite."dfs.datanode.hostname"                                = "${config.networking.hostName}";
            hdfsSite."dfs.datanode.address"                                 = "${config.networking.hostName}:50010";
            hdfsSite."dfs.datanode.ipc.address"                             = "${config.networking.hostName}:50020";
            hdfsSite."dfs.datanode.http.address"                            = "${config.networking.hostName}:50075";
            hdfsSite."dfs.datanode.https.address"                           = "${config.networking.hostName}:50475";
            # journalnode
            hdfsSite."dfs.journalnode.edits.dir"                            = "/var/lib/journalnode";
            hdfsSite."dfs.journalnode.rpc-address"                          = "${config.networking.hostName}:8485";
            hdfsSite."dfs.journalnode.http-address"                         = "${config.networking.hostName}:8480";
            hdfsSite."dfs.journalnode.https-address"                        = "${config.networking.hostName}:8481";
          };
        };
      };
    in {
      node1 = { lib, pkgs, ... }: {
        virtualisation.memorySize = 1500;
        imports = [ ./common/x11.nix ./common/user-account.nix common ];
        services.xserver.displayManager.auto.user = "alice";
        environment.systemPackages = [ pkgs.firefox ];
        services.hdfs.namenode.enable = true;
        services.hdfs.datanode.enable = true;
        services.hdfs.journalnode.enable = true;
      };
      node2 = { lib, pkgs, ... }: {
        virtualisation.memorySize = 1500;
        imports = [ common ];
        services.hdfs.namenode.enable = true;
        services.hdfs.datanode.enable = true;
        services.hdfs.journalnode.enable = true;
      };
      node3 = { lib, pkgs, ... }: {
        virtualisation.memorySize = 1500;
        imports = [ common ];
        services.hdfs.datanode.enable = true;
        services.hdfs.journalnode.enable = true;
      };
    };

  testScript = { nodes, ... }: ''
    startAll;

    $node1->waitForX;
    $node1->waitForFile("/home/alice/.Xauthority");
    $node1->succeed("xauth merge ~alice/.Xauthority");

    $node1->sleep(5);

    $node1->execute("xterm &");
    $node1->sleep(5);
    # at least one namenode must be initially formatted, another will bootstrap
    $node1->sendChars("sudo -u hadoop hdfs namenode -format\n");

    $node1->sleep(60);
    #  wait for the second namenode to bootstrap
    $node1->sendChars("while ! sudo -u hadoop hdfs haadmin -transitionToActive nn1; do sleep 5; done\n");
    #  ...or became active forcely
    #$node1->sendChars("sudo -u hadoop hdfs haadmin -failover --forceactive nn2 nn1\n");
    $node1->sleep(10);

    $node1->sendChars("hdfs dfs -copyFromLocal /bin/sh /xxx\n");
    $node1->sleep(10);
    $node1->sendChars("hdfs dfs -ls /\n");
    $node1->sleep(10);

    $node1->sendChars("firefox");
    $node1->sendChars(" --setDefaultBrowser"); # supress the modal dialog
    $node1->sendChars(" http://node1:50070 http://node2:50070");
    $node1->sendChars(" http://node1:50075 http://node2:50075 http://node3:50075");
    $node1->sendChars(" http://node1:8480  http://node2:8480  http://node3:8480\n");
    $node1->sleep(60);

    $node1->screenshot("screenshot");
  '';
})
