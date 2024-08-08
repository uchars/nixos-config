{ config, lib, ... }: {
  options.nils.networking = with lib; {
    enable = mkOption "Configuring network settings.";
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
    dhcp = mkOption {
      type = types.bool;
      description = "Using DHCP";
      default = true;
    };
    ssh = mkOption {
      type = types.bool;
      description = "Using DHCP";
      default = true;
    };
    hostId = mkOption {
      type = types.str;
      description = "Host ID (for zfs)";
    };
  };
  config = let cfg = config.nils.networking;
  in lib.mkIf cfg.enable {
    networking.interfaces."${cfg.interface}" = {
      wakeOnLan = { enable = cfg.wol; };
    };
    time.timeZone = cfg.timeZone;
    networking = {
      firewall.enable = cfg.firewall;
      hostId = cfg.hostId;
      hostName = cfg.hostName;
      useDHCP = cfg.dhcp;
    };
    services.openssh = {
      enable = cfg.ssh;
      passwordAuthentication = true;
    };
  };
}
