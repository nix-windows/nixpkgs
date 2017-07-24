{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.accumulo;

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
    name = "accumulo-conf-dir";
    paths = [
      (pkgs.writeTextDir "accumulo-env.sh"            "") # unused while we set the env by makeWrapper but must exist
      (pkgs.writeTextDir "accumulo-site.xml"          (configurationToXml cfg.accumuloSite))
      (pkgs.writeTextDir "core-site.xml"              (configurationToXml cfg.coreSite))
      (pkgs.writeTextDir "hdfs-site.xml"              (configurationToXml cfg.hdfsSite))
      (pkgs.writeTextDir "log4j.properties"           cfg.logging)
      (pkgs.writeTextDir "generic_logger.properties"  "${cfg.logging}\n${cfg.genericLogger}")
    ];
  };

  accumulo-configured = pkgs.stdenv.mkDerivation {
    name = "${cfg.package.name}-configured";
    buildInputs = [ pkgs.makeWrapper ];
    buildCommand = ''
      mkdir -p $out/bin
      for n in ${cfg.package}/bin/*; do
        [[ $n = *config* ]] || makeWrapper $n $out/bin/$(basename $n) \
          --prefix LD_LIBRARY_PATH : "${with pkgs; stdenv.lib.makeLibraryPath [ openssl snappy zlib bzip2 ] /* libhadoop.so loads them by dlopen() */ }" \
          --set ZOOKEEPER_HOME     "${pkgs.zookeeper}" \
          --set HADOOP_PREFIX      "${cfg.hadoop-package}" \
          --set HADOOP_CONF_DIR    "${configDir}" \
          --set ACCUMULO_CONF_DIR  "${configDir}" \
          ${ concatStrings (mapAttrsToList (k: v: " --set '${k}' '${v}'") cfg.env) }
      done
    '';
  };

in {

  options.services.accumulo = {
    enable        = mkEnableOption "configured accumulo";
    enableMaster  = mkEnableOption "master daemon";
    enableTserver = mkEnableOption "tablet server daemon";
    enableGc      = mkEnableOption "garbage collect daemon";
    enableMonitor = mkEnableOption "monitor daemon";

    package = mkOption {
      description = "The accumulo package to use";
      type = types.package;
      default = pkgs.accumulo;
    };

    hadoop-package = mkOption {
      description = "The hadoop package to use";
      type = types.package;
      default = pkgs.hadoop;
    };

    coreSite = mkOption {
      description = "HDFS client settings (core-site.xml)";
      type = types.attrsOf types.str;
      default = {
        "fs.defaultFS"      = "hdfs://127.0.0.1:8020";
      };
    };

    hdfsSite = mkOption {
      description = "HDFS client settings (hdfs-site.xml)";
      type = types.attrsOf types.str;
      default = {};
    };

    accumuloSite = mkOption {
      description = "Accumulo settings (accumulo-site.xml)";
      type = types.attrsOf types.str;
      default = {
        "instance.zookeeper.host"            = "127.0.0.1"; # comma-separated list of zookeeper servers
        "instance.dfs.dir"                   = "/accumulo"; # path on HDFS (address is in coreSite."fs.defaultFS")
        "tserver.memory.maps.native.enabled" = "true";
        "tserver.wal.sync.method"            = "hflush";
      };
    };

    logging = mkOption {
      description = "Content of log4j.properties";
      type = types.lines;
      default = ''
        log4j.rootLogger                                = INFO,CONSOLE
        log4j.appender.CONSOLE                          = org.apache.log4j.ConsoleAppender
        log4j.appender.CONSOLE.layout                   = org.apache.log4j.PatternLayout
        log4j.appender.CONSOLE.layout.ConversionPattern = [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n
      '';
    };

    genericLogger = mkOption {
      description = "Content of generic_logger.properties";
      type = types.lines;
      default = ''
        log4j.appender.ASYNC             = org.apache.accumulo.core.util.AsyncSocketAppender
        log4j.appender.ASYNC.RemoteHost  = ''${org.apache.accumulo.core.host.log}
        log4j.appender.ASYNC.Port        = ''${org.apache.accumulo.core.host.log.port}
        log4j.appender.ASYNC.Application = ''${org.apache.accumulo.core.application}:''${org.apache.accumulo.core.ip.localhost.hostname}
        log4j.appender.ASYNC.Threshold   = WARN
      '';
    };

    listenAddress = mkOption {
      description = "Explicit IP or hostname to listen and to advertise";
      type = types.str;
      default = null;
    };

    env = mkOption {
      description = "settings in envirinment vars, mainly per-daemon command line options";
      type = types.attrsOf types.str;
      default = {
        ACCUMULO_GENERAL_OPTS = "-XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -Djava.net.preferIPv4Stack=true -XX:+CMSClassUnloadingEnabled";
        ACCUMULO_TSERVER_OPTS = "-Xmx128m -Xms128m";
        ACCUMULO_MASTER_OPTS  = "-Xmx128m -Xms128m";
        ACCUMULO_MONITOR_OPTS = "-Xmx64m -Xms64m";
        ACCUMULO_GC_OPTS      = "-Xmx64m -Xms64m";
        ACCUMULO_SHELL_OPTS   = "-Xmx128m -Xms64m";
        ACCUMULO_OTHER_OPTS   = "-Xmx128m -Xms64m";
       #ACCUMULO_LOG_DIR      = "/var/log/accumulo";
      };
    };
  };


  config = mkMerge [
    (mkIf cfg.enable {
      # Accumulo CLI utilities with the config on $PATH
      environment.systemPackages = [ accumulo-configured ];
    })

    (mkIf (cfg.enableMaster || cfg.enableTserver || cfg.enableGc || cfg.enableMonitor) {
      services.accumulo.enable = true;
      users.extraUsers.accumulo = {
        name = "accumulo";
        group = "accumulo";
        description = "Accumulo server user";
      };
      users.extraGroups.accumulo = {};
    })

    (mkIf cfg.enableMaster {
      systemd.services.accumulo-master = {
        description = "Accumulo master";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${accumulo-configured}/bin/accumulo master" + (optionalString (cfg.listenAddress!=null) " -a ${cfg.listenAddress}");
          Restart = "always";
          RestartSec = "5";
          User = "accumulo";
          Group = "accumulo";
        };
      };
    })

    (mkIf cfg.enableTserver {
      systemd.services.accumulo-tserver = {
        description = "Accumulo tablet server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        restartIfChanged = false; # shutdown it gracefully: "accumulo admin stop $address"
        serviceConfig = {
          ExecStart = "${accumulo-configured}/bin/accumulo tserver" + (optionalString (cfg.listenAddress!=null) " -a ${cfg.listenAddress}");
          Restart = "always";
          RestartSec = "5";
          User = "accumulo";
          Group = "accumulo";
        };
      };
    })

    (mkIf cfg.enableGc {
      systemd.services.accumulo-gc = {
        description = "Accumulo garbage collector";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${accumulo-configured}/bin/accumulo monitor" + (optionalString (cfg.listenAddress!=null) " -a ${cfg.listenAddress}");
          Restart = "always";
          RestartSec = "5";
          User = "accumulo";
          Group = "accumulo";
        };
      };
    })

    (mkIf cfg.enableMonitor {
      systemd.services.accumulo-monitor = {
        description = "Accumulo monitor";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${accumulo-configured}/bin/accumulo monitor" + (optionalString (cfg.listenAddress!=null) " -a ${cfg.listenAddress}");
          Restart = "always";
          RestartSec = "5";
          User = "accumulo";
          Group = "accumulo";
        };
      };
    })
  ];

}
