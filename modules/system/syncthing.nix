{ lib, config, ... }: {
  options.elira.syncthing = with lib; {
    enable = mkEnableOption "Enable Syncthing";
    user = mkOption {
      type = types.str;
      description = "Syncthing User";
    };
    dir = mkOption {
      type = types.str;
      description = "Syncthing Directory";
    };
    deviceConfig = mkOption {
      type = types.attrs;
      description = "Syncthing Device Configuration";
      default = { };
    };
  };

  config = let cfg = config.elira.syncthing;
  in lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = "${cfg.user}";
      dataDir = "${cfg.dir}/sync";
      configDir = "${cfg.dir}/sync/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      devices = cfg.deviceConfig;
      folders = {
        "Documents" = {
          path = "/home/${cfg.user}/Documents";
          devices = [ "laptop" "iPhoneNils" ];
        };
        "Wallpapers" = {
          path = "/home/${cfg.user}/Pictures/wallpapers";
          devices = [ "laptop" ];
        };
      };
    };
  };
}
