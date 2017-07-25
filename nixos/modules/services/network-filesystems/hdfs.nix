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

  mkConfigDir = extra: pkgs.buildEnv {
    name = "hdfs-config-dir";
    paths = mapAttrsToList pkgs.writeTextDir ({
      "core-site.xml"              = configurationToXml cfg.coreSite;
      "hdfs-site.xml"              = configurationToXml cfg.hdfsSite;
      "hadoop-metrics2.properties" = cfg.metrics;
    } // extra);
  };

  defaultLog4j = ''
    log4j.rootLogger                                = INFO,CONSOLE
    log4j.appender.CONSOLE                          = org.apache.log4j.ConsoleAppender
    log4j.appender.CONSOLE.layout                   = org.apache.log4j.PatternLayout
    log4j.appender.CONSOLE.layout.ConversionPattern = [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n
  '';

  hadoop-cli = pkgs.stdenv.mkDerivation {
    name = "${cfg.package.name}-cli";
    buildInputs = [ pkgs.makeWrapper ];
    buildCommand = ''
      mkdir -p $out/bin
      for n in ${cfg.package}/bin/*; do
        makeWrapper $n $out/bin/$(basename $n) \
          --set HADOOP_CONF_DIR  "${mkConfigDir { "log4j.properties" = defaultLog4j; }}" \
          ${ concatStrings (mapAttrsToList (k: v: " --set ${escapeShellArg k} ${escapeShellArg v}") cfg.env) }
      done
    '';
  };

in {

  options.services.hdfs = {
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

    metrics = mkOption {
      description = "metrics configuration";
      type = types.lines;
      default = ''
        *.sink.file.class=org.apache.hadoop.metrics2.sink.FileSink
        *.period=10
      '';
    };

    cli = {
      enable = mkEnableOption "hadoop cli";
    };

    datanode = {
      enable = mkEnableOption "datanode daemon";
      logging = mkOption {
        description = "logging configuration";
        type = types.lines;
        default = defaultLog4j;
      };
    };

    namenode = {
      enable = mkEnableOption "namenode daemon";
      logging = mkOption {
        description = "logging configuration";
        type = types.lines;
        default = defaultLog4j;
      };
    };

    journalnode = {
      enable = mkEnableOption "journalnode daemon";
      logging = mkOption {
        description = "logging configuration";
        type = types.lines;
        default = defaultLog4j;
      };
    };

    balancer = {
      enable = mkEnableOption "balancer daemon";
      logging = mkOption {
        description = "logging configuration";
        type = types.lines;
        default = defaultLog4j;
      };
    };

    env = mkOption {
      description = "settings in environment vars, mainly per-daemon command line options";
      type = types.attrsOf types.str;
      default = {
        HADOOP_CLIENT_OPTS      = "-Xmx512m";
        HADOOP_NAMENODE_OPTS    = "-Xmx1024m";
        HADOOP_DATANODE_OPTS    = "-Xmx1024m";
        HADOOP_JOURNALNODE_OPTS = "-Xmx512m";
        HADOOP_BALANCER_OPTS    = "-Xmx512m";
      };
    };
  };


  config = mkMerge [
    (mkIf cfg.cli.enable {
      # Configured Hadoop CLI utilities on $PATH
      environment.systemPackages = [ hadoop-cli ];
    })

    (mkIf (cfg.namenode.enable || cfg.datanode.enable || cfg.balancer.enable || cfg.journalnode.enable) {
      services.hdfs.cli.enable = true;
      users.extraUsers.hadoop = {
        name = "hadoop";
        group = "hadoop";
        uid = config.ids.uids.hadoop;
        description = "Hadoop server user";
      };
      users.extraGroups.hadoop.gid = config.ids.gids.hadoop;
    })

    (mkIf cfg.namenode.enable {
      systemd.services.hdfs-namenode = {
        description = "HDFS name node";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        restartIfChanged = false; # do not restart on "nixos-rebuild switch". It is not quick to start (minutes) and its downtime disrupts other services
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/hdfs namenode";
          Restart = "always";
          RestartSec = "5";
          User = "hadoop";
          Group = "hadoop";
          PermissionsStartOnly = true;
        };
        environment = {
          HADOOP_CONF_DIR = mkConfigDir { "log4j.properties" = cfg.namenode.logging; };
        } // cfg.env;
        preStart = ''
          if [ ! -d '${cfg.hdfsSite."dfs.name.dir"}' ]; then
            mkdir -m 0700 -p '${cfg.hdfsSite."dfs.name.dir"}'
            chown hadoop:hadoop '${cfg.hdfsSite."dfs.name.dir"}'
          fi
          # it may require few failed starts before successfull bootstrap
          if [ ! -d '${cfg.hdfsSite."dfs.name.dir"}/current' ]; then
            ${if cfg.hdfsSite?"dfs.nameservices" then
                "${pkgs.sudo}/bin/sudo -u hadoop ${hadoop-cli}/bin/hdfs namenode -bootstrapStandby" # the namenode is part of HA
              else
                "${pkgs.sudo}/bin/sudo -u hadoop ${hadoop-cli}/bin/hdfs namenode -format"           # the namenode is standalone
             }
          fi
        '';
      };
    })

    (mkIf cfg.datanode.enable {
      systemd.services.hdfs-datanode = {
        description = "HDFS data node";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        restartIfChanged = false; # do not restart on "nixos-rebuild switch". It is not quick to start (minutes) and its downtime disrupts other services
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/hdfs datanode";
          Restart = "always";
          RestartSec = "5";
          User = "hadoop";
          Group = "hadoop";
          PermissionsStartOnly = true;
        };
        environment = {
          HADOOP_CONF_DIR = mkConfigDir { "log4j.properties" = cfg.datanode.logging; };
        } // cfg.env;
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

    (mkIf cfg.journalnode.enable {
      systemd.services.hdfs-journalnode = {
        description = "HDFS journal node";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/hdfs journalnode";
          Restart = "always";
          RestartSec = "5";
          User = "hadoop";
          Group = "hadoop";
          PermissionsStartOnly = true;
        };
        environment = {
          HADOOP_CONF_DIR = mkConfigDir { "log4j.properties" = cfg.journalnode.logging; };
        } // cfg.env;
        preStart = ''
          if [ ! -d '${cfg.hdfsSite."dfs.journalnode.edits.dir"}' ]; then
            mkdir -m 0700 -p '${cfg.hdfsSite."dfs.journalnode.edits.dir"}'
            chown hadoop:hadoop '${cfg.hdfsSite."dfs.journalnode.edits.dir"}'
          fi
        '';
      };
    })

    (mkIf cfg.balancer.enable {
      systemd.services.hdfs-balancer = {
        description = "HDFS Balancer";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/hdfs balancer";
          Restart = "always";
          RestartSec = "600"; # it exits when there is no work to do; no need to restart it quickly
          User = "hadoop";
          Group = "hadoop";
        };
        environment = {
          HADOOP_CONF_DIR = mkConfigDir { "log4j.properties" = cfg.balancer.logging; };
        } // cfg.env;
      };
    })
  ];

}
