{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hdfs;

  configurationToXml = attrs:
    let
      xmlescape = builtins.replaceStrings ["&" "<" ">"] ["&amp;" "&lt;" "&gt;"];
    in ''
      <configuration>
      ${concatStrings (mapAttrsToList (name: value: ''
        <property>
          <name>${xmlescape name}</name>
          <value>${xmlescape value}</value>
        </property>
       '') attrs)}
      </configuration>
    '';

  configDir = pkgs.buildEnv {
    name = "hdfs-config-dir";
    paths = [
      (pkgs.writeTextDir "core-site.xml"              (configurationToXml cfg.coreSite))
      (pkgs.writeTextDir "hdfs-site.xml"              (configurationToXml cfg.hdfsSite))
      (pkgs.writeTextDir "log4j.properties"           cfg.logging)
      (pkgs.writeTextDir "hadoop-metrics2.properties" cfg.metrics)
    ];
  };

  hadoop-configured = pkgs.stdenv.mkDerivation {
    name = "${cfg.package.name}-configured";
    buildInputs = [ pkgs.makeWrapper ];
    buildCommand = ''
      mkdir -p $out/bin
      for n in ${cfg.package}/bin/*; do
        makeWrapper $n $out/bin/$(basename $n) \
          --set HADOOP_CLIENT_OPTS "${concatStringsSep " " cfg.extraCmdLineOptions}" \
          --set HADOOP_CONF_DIR    "${configDir}"
      done
    '';
  };

in {

  options.services.hdfs = {
    enable            = mkEnableOption "configured hadoop";
    enableNamenode    = mkEnableOption "namenode daemon";
    enableDatanode    = mkEnableOption "datanode daemon";
    enableBalancer    = mkEnableOption "balancer daemon";
    enableJournalnode = mkEnableOption "journalnode daemon";

    package = mkOption {
      description = "The hadoop package to use";
      type = types.package;
      default = pkgs.hadoop;
    };

    coreSite = mkOption {
      description = "core-site.xml settings";
      type = types.attrsOf types.str;
      default = {
        "fs.defaultFS"      = "hdfs://127.0.0.1:8020";
        "hadoop.native.lib" = "true";
      };
    };

    hdfsSite = mkOption {
      description = "hdfs-site.xml settings";
      type = types.attrsOf types.str;
      default = {
        # some meaningful defaults for standalone namenode to start
        "dfs.name.dir"                                         = "/var/lib/namenode";
        "dfs.namenode.datanode.registration.ip-hostname-check" = "false";
        "dfs.namenode.fs-limits.max-component-length"          = "512";
        # some meaningful defaults for datanode to start
        "dfs.datanode.data.dir"                                = "/var/lib/datanode";
        "dfs.datanode.synconclose"                             = "true";
        # some meaningful defaults for journalnode to start
        "dfs.journalnode.edits.dir"                            = "/var/lib/journalnode";
      };
    };

    logging = mkOption {
      description = "logging configuration";
      type = types.lines;
      default = ''
        zookeeper.root.logger=INFO, CONSOLE
        log4j.rootLogger=INFO, CONSOLE
        log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
        log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
        log4j.appender.CONSOLE.layout.ConversionPattern=[myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n
      '';
    };

    metrics = mkOption {
      description = "metrics configuration";
      type = types.lines;
      default = ''
        *.sink.file.class=org.apache.hadoop.metrics2.sink.FileSink
        *.period=10
      '';
    };

    extraCmdLineOptions = mkOption {
      description = "Extra command line options";
      default = [ "-Djava.net.preferIPv4Stack=true" "-Xmx2000m" ];
      type = types.listOf types.str;
    };
  };


  config = mkMerge [
    (mkIf cfg.enable {
      # Hadoop CLI utilities with the config on $PATH
      environment.systemPackages = [ hadoop-configured ];
    })

    (mkIf (cfg.enableNamenode || cfg.enableDatanode || cfg.enableBalancer || cfg.enableJournalnode) {
      services.hdfs.enable = true;
      users.extraUsers.hadoop = {
        name = "hadoop";
        group = "hadoop";
        uid = config.ids.uids.hadoop;
        description = "Hadoop server user";
      };
      users.extraGroups.hadoop.gid = config.ids.gids.hadoop;
    })

    (mkIf cfg.enableNamenode {
      systemd.services.hdfs-namenode = {
        description = "HDFS name node";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${hadoop-configured}/bin/hdfs namenode";
          Restart = "always";
          RestartSec = "5";
          User = "hadoop";
          Group = "hadoop";
          PermissionsStartOnly = true;
        };
        preStart = ''
          if [ ! -d '${cfg.hdfsSite."dfs.name.dir"}' ]; then
            mkdir -m 0700 -p '${cfg.hdfsSite."dfs.name.dir"}'
            chown hadoop:hadoop '${cfg.hdfsSite."dfs.name.dir"}'
          fi
          # it may require few failed starts before successfull bootstrap
          if [ ! -d '${cfg.hdfsSite."dfs.name.dir"}/current' ]; then
            ${if cfg.hdfsSite?"dfs.nameservices" then
                "${pkgs.sudo}/bin/sudo -u hadoop ${hadoop-configured}/bin/hdfs namenode -bootstrapStandby" # the namenode is part of HA
              else
                "${pkgs.sudo}/bin/sudo -u hadoop ${hadoop-configured}/bin/hdfs namenode -format"           # the namenode is standalone
             }
          fi
        '';
      };
    })

    (mkIf cfg.enableDatanode {
      systemd.services.hdfs-datanode = {
        description = "HDFS data node";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${hadoop-configured}/bin/hdfs datanode";
          Restart = "always";
          RestartSec = "5";
          User = "hadoop";
          Group = "hadoop";
          PermissionsStartOnly = true;
        };
        preStart = ''
          DATADIRS='${cfg.hdfsSite."dfs.datanode.data.dir"}'
          for f in $(IFS=,; echo $DATADIRS); do
            if [ ! -d $f ]; then
              mkdir -m 0700 -p $f
              chown hadoop:hadoop $f
            fi
          done
        '';
      };
    })

    (mkIf cfg.enableJournalnode {
      systemd.services.hdfs-journalnode = {
        description = "HDFS journal node";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${hadoop-configured}/bin/hdfs journalnode";
          Restart = "always";
          RestartSec = "5";
          User = "hadoop";
          Group = "hadoop";
          PermissionsStartOnly = true;
        };
        preStart = ''
          if [ ! -d '${cfg.hdfsSite."dfs.journalnode.edits.dir"}' ]; then
            mkdir -m 0700 -p '${cfg.hdfsSite."dfs.journalnode.edits.dir"}'
            chown hadoop:hadoop '${cfg.hdfsSite."dfs.journalnode.edits.dir"}'
          fi
        '';
      };
    })

    (mkIf cfg.enableBalancer {
      systemd.services.hdfs-balancer = {
        description = "HDFS Balancer";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${hadoop-configured}/bin/hdfs balancer";
          Restart = "always";
          RestartSec = "60"; # it exits when there is no work to do; no need to restart it quickly
          User = "hadoop";
          Group = "hadoop";
        };
      };
    })
  ];

}
