{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.settings.networking = with lib; {
    enable = mkEnableOption "Configuring network settings.";
    interface = mkOption {
      type = types.str;
      description = "Network interface";
    };
    wol = mkOption {
      type = types.bool;
      description = "Enable wake-on-lan for the interface.";
      default = true;
    };
    timeZone = mkOption {
      type = types.str;
      description = "Timezone of the interface.";
      default = "Etc/UTC";
    };
    hostName = mkOption {
      type = types.str;
      description = "Name of the host";
      default = "placeholder";
    };
    firewall = mkOption {
      type = types.bool;
      description = "Enable firewall";
      default = true;
    };
    ssh = mkOption {
      type = types.bool;
      description = "Enable SSH";
      default = true;
    };
    hostId = mkOption {
      type = types.nullOr types.str;
      description = "Host ID (for zfs)";
      default = null;
    };
    openconnectVpn = mkOption {
      type = types.bool;
      description = "Install OpenConnectVPN";
      default = false;
    };
  };
  config =
    let
      cfg = config.settings.networking;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; (if cfg.openconnectVpn then [ openconnect ] else [ ]);
      time.timeZone = cfg.timeZone;
      networking = {
        firewall.enable = cfg.firewall;
        hostName = cfg.hostName;
        networkmanager.enable = true;
        interfaces."${cfg.interface}".wakeOnLan =
          {
            enable = cfg.wol;
          }
          // lib.optionalAttrs (cfg.hostId != null) {
            # Only add hostId if specified
            hostId = cfg.hostId;
          };
      };
      services.openssh = {
        enable = cfg.ssh;
        settings.PasswordAuthentication = true;
      };
    };
}
