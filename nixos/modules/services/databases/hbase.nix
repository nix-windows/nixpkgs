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

  configDir = pkgs.buildEnv {
    name = "hbase-conf-dir";
    paths = [
      (pkgs.writeTextDir "hbase-site.xml"   (configurationToXml cfg.hbaseSite))
      (pkgs.writeTextDir "core-site.xml"    (configurationToXml cfg.coreSite))
      (pkgs.writeTextDir "hdfs-site.xml"    (configurationToXml cfg.hdfsSite))
      (pkgs.writeTextDir "log4j.properties" cfg.logging)
    ];
  };

  hbase-configured = pkgs.stdenv.mkDerivation {
    name = "${cfg.package.name}-configured";
    buildInputs = [ pkgs.makeWrapper ];
    buildCommand = ''
      mkdir -p $out/bin
      for n in ${cfg.package}/bin/*; do
        [[ $n = *hbase-config.sh ]] || [[ $n = *hbase-common.sh ]] || makeWrapper $n $out/bin/$(basename $n) \
          --set HADOOP_CONF_DIR    "${configDir}" \
          --set HBASE_CONF_DIR     "${configDir}" \
          ${ concatStrings (mapAttrsToList (k: v: " --set '${k}' '${v}'") cfg.env) }
      done
    '';
  };

in {

  ###### interface

  options = {

    services.hbase = {

      enable = mkOption {
        description = "enable configured HBase";
        type = types.bool;
        default = cfg.enable-masterserver || cfg.enable-regionserver;
      };
      enable-masterserver = mkEnableOption "enable master server daemon";
      enable-regionserver = mkEnableOption "enable region server daemon";

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

      logging = mkOption {
        description = "log4j properties";
        type = types.lines;
        default = ''
          zookeeper.root.logger=INFO, CONSOLE
          log4j.rootLogger=INFO, CONSOLE
          log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
          log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
          log4j.appender.CONSOLE.layout.ConversionPattern=[myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n
        '';
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
    (mkIf cfg.enable {
      # Hbase CLI utilities with the config on $PATH
      environment.systemPackages = [ hbase-configured ];
    })

    (mkIf (cfg.enable-masterserver || cfg.enable-regionserver) {
      users.extraUsers.hbase = {
        name = "hbase";
        group = "hbase";
        uid = config.ids.uids.hbase;
        description = "HBase server user";
      };
      users.extraGroups.hbase.gid = config.ids.gids.hbase;
    })

    (mkIf cfg.enable-masterserver {
      systemd.services.hbase-masterserver = {
        description = "HBase master server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${hbase-configured}/bin/hbase master start";
          Restart = "always";
          RestartSec = "5";
          User = "hbase";
          Group = "hbase";
          PermissionsStartOnly = true;
        };
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

    (mkIf cfg.enable-regionserver {
      systemd.services.hbase-regionserver = assert !standalone; {
        description = "HBase region server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${hbase-configured}/bin/hbase regionserver start";
          Restart = "always";
          RestartSec = "5";
          User = "hbase";
          Group = "hbase";
          PermissionsStartOnly = true;
        };
        preStart = ''
          mkdir -p '${cfg.env.HBASE_LOG_DIR}'
          chown hbase:hbase '${cfg.env.HBASE_LOG_DIR}'
        '';
      };
    })
  ];

}
