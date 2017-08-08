{ config, lib, ... }:

with lib;
let
  cfg = config.programs.ccache;
in {
  options.programs.ccache = {
    # host configuration
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    cacheDir = mkOption {
      type = types.path;
      description = "CCache directory";
      default = "/var/cache/ccache";
    };
    # target configuration
    packageNames = mkOption {
      type = types.listOf types.str;
      description = "Nix top-level packages to be compiled using CCache";
      default = [];
      example = [ "wxGTK30" "qt48" "ffmpeg_3_3" "libav_all" ];
    };
  };

  config = mkMerge [
    # host configuration
    (mkIf cfg.enable {
      nixpkgs.overlays = [
        (self: super: {
          ccacheWrapper = super.ccacheWrapper.override {
            extraConfig = ''
              export CCACHE_COMPRESS=1
              export CCACHE_DIR=${cfg.cacheDir}
              export CCACHE_UMASK=007
            '';
          };
        })
      ];

      systemd.tmpfiles.rules = [ "d ${cfg.cacheDir} 0770 root nixbld -" ];
    })

    # target configuration
    (mkIf (cfg.packageNames != []) {
      nixpkgs.overlays = [
        (self: super: genAttrs cfg.packageNames (pn: super.${pn}.override { stdenv = builtins.trace "with ccache: ${pn}" self.ccacheStdenv; }))
      ];
    })
  ];
}