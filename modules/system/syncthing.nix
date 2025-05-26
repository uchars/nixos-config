{ lib, config, ... }:
{
  options.settings.syncthing = with lib; {
    enable = mkEnableOption "Enable Syncthing";
    user = mkOption {
      type = types.str;
      description = "Syncthing User";
    };
    dir = mkOption {
      type = types.str;
      description = "Syncthing Directory";
    };
    sharedFolders = mkOption {
      type = types.attrs;
      description = "Folders to share";
      default = { };
    };
    deviceConfig = mkOption {
      type = types.attrs;
      description = "Syncthing Device Configuration";
      default = { };
    };
  };

  config =
    let
      cfg = config.settings.syncthing;
    in
    lib.mkIf cfg.enable {
      services.syncthing = {
        enable = true;
        user = "${cfg.user}";
        dataDir = "${cfg.dir}/sync";
        configDir = "${cfg.dir}/sync/.config/syncthing";
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          devices = cfg.deviceConfig;
          folders = cfg.sharedFolders;
        };
      };
    };
}
