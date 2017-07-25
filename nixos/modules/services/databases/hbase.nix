{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hbase;
  standalone = lib.hasPrefix "file://" cfg.hbaseSite."hbase.rootdir";

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
    name = "hbase-conf-dir";
    paths = mapAttrsToList pkgs.writeTextDir ({
      "hbase-site.xml"    = configurationToXml cfg.hbaseSite;
      "core-site.xml"     = configurationToXml cfg.coreSite;
      "hdfs-site.xml"     = configurationToXml cfg.hdfsSite;
    } // extra);
  };

  defaultLog4j = ''
    zookeeper.root.logger=INFO, CONSOLE
    log4j.rootLogger=INFO, CONSOLE
    log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
    log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
    log4j.appender.CONSOLE.layout.ConversionPattern=[myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n
  '';

  hbase-cli = pkgs.stdenv.mkDerivation {
    name = "${cfg.package.name}-cli";
    buildInputs = [ pkgs.makeWrapper ];
    buildCommand = let
      configDir = mkConfigDir { "log4j.properties" = defaultLog4j; };
    in ''
      mkdir -p $out/bin
      for n in ${cfg.package}/bin/*; do
        [[ $n = *hbase-config.sh ]] || [[ $n = *hbase-common.sh ]] || makeWrapper $n $out/bin/$(basename $n) \
          --set HADOOP_CONF_DIR    "${configDir}" \
          --set HBASE_CONF_DIR     "${configDir}" \
          ${ concatStrings (mapAttrsToList (k: v: " --set ${escapeShellArg k} ${escapeShellArg v}") cfg.env) }
      done
    '';
  };

in {

  ###### interface

  options = {

    services.hbase = {
      package = mkOption {
        description = "The HBase package to use";
        type = types.package;
        default = pkgs.hbase;
      };

      coreSite = mkOption {
        description = "HDFS client settings (core-site.xml)";
        type = types.attrsOf types.str;
        default = {};
        example = literalExample "config.services.hdfs.coreSite";
      };

      hdfsSite = mkOption {
        description = "HDFS client settings (hdfs-site.xml)";
        type = types.attrsOf types.str;
        default = {};
        example = literalExample "config.services.hdfs.coreSite";
      };

      hbaseSite = mkOption {
        description = "HBase settings (hbase-site.xml)";
        type = types.attrsOf types.str;
        default = {
          "hbase.rootdir"             = "file:///var/db/hbase";
        };
        example = {
          "hbase.tmp.dir"             = "/var/tmp/hbase";
          "hbase.cluster.distributed" = "true";
          "hbase.zookeeper.quorum"    = "127.0.0.1:2181";
          "zookeeper.znode.parent"    = "/hbase";
          "hbase.rootdir"             = "hdfs://127.0.0.1:8020/hbase";
        };
      };

      cli = {
        enable = mkEnableOption "configured HBase CLI";
      };

      masterserver = {
        enable = mkEnableOption "master server daemon";
        logging = mkOption {
          description = "log4j properties";
          type = types.lines;
          default = defaultLog4j;
        };
      };

      regionserver = {
        enable = mkEnableOption "region server daemon";
        logging = mkOption {
          description = "log4j properties";
          type = types.lines;
          default = defaultLog4j;
        };
      };

      env = mkOption {
        description = "settings in environment vars, mainly per-daemon command line options";
        type = types.attrsOf types.str;
        default = {
          HBASE_LOG_DIR           = "/var/log/hbase";
          HBASE_MASTER_OPTS       = "-Xmx128m -Xms128m";
          HBASE_REGIONSERVER_OPTS = "-Xmx128m -Xms128m";
          HBASE_OPTS              = "-Djava.net.preferIPv4Stack=true";
          SERVER_GC_OPTS          = "-XX:+UseConcMarkSweepGC";
        };
      };

    };

  };

  ###### implementation

  config = mkMerge [
    (mkIf cfg.cli.enable {
      # Hbase CLI utilities with the config on $PATH
      environment.systemPackages = [ hbase-cli ];
    })

    (mkIf (cfg.masterserver.enable || cfg.regionserver.enable) {
      services.hbase.cli.enable = true;
      users.extraUsers.hbase = {
        name = "hbase";
        group = "hbase";
        uid = config.ids.uids.hbase;
        description = "HBase server user";
      };
      users.extraGroups.hbase.gid = config.ids.gids.hbase;
    })

    (mkIf cfg.masterserver.enable {
      systemd.services.hbase-masterserver = {
        description = "HBase master server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/hbase master start";
          Restart = "always";
          RestartSec = "5";
          User = "hbase";
          Group = "hbase";
          PermissionsStartOnly = true;
        };
        environment = let
          configDir = mkConfigDir { "log4j.properties" = cfg.masterserver.logging; };
        in {
          HADOOP_CONF_DIR = configDir;
          HBASE_CONF_DIR  = configDir;
        } // cfg.env;
        preStart = ''
          mkdir -p '${cfg.env.HBASE_LOG_DIR}'
          chown hbase:hbase '${cfg.env.HBASE_LOG_DIR}'
          ${ lib.optionalString standalone
               (let
                  localRootDir = lib.removePrefix "file://" cfg.hbaseSite."hbase.rootdir";
                in ''
                  mkdir -p '${localRootDir}'
                  chown hbase:hbase '${localRootDir}'
                '') }
        '';
      };
    })

    (mkIf cfg.regionserver.enable {
      systemd.services.hbase-regionserver = assert !standalone; {
        description = "HBase region server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/hbase regionserver start";
          Restart = "always";
          RestartSec = "5";
          User = "hbase";
          Group = "hbase";
          PermissionsStartOnly = true;
        };
        environment = let
          configDir = mkConfigDir { "log4j.properties" = cfg.regionserver.logging; };
        in {
          HADOOP_CONF_DIR = configDir;
          HBASE_CONF_DIR  = configDir;
        } // cfg.env;
        preStart = ''
          mkdir -p '${cfg.env.HBASE_LOG_DIR}'
          chown hbase:hbase '${cfg.env.HBASE_LOG_DIR}'
        '';
      };
    })
  ];

}
