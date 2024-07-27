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
    timeZone = {
      type = types.str;
      description = "Timezone of the interface.";
      default = "Etc/UTC";
    };
    hostName = {
      type = types.str;
      description = "Name of the host";
      default = "placeholder";
    };
    firewall = {
      type = types.bool;
      description = "Enable firewall";
      default = true;
    };
    dhcp = {
      type = types.bool;
      description = "Using DHCP";
      default = true;
    };
  };
  config = let cfg = config.nils.networking;
  in lib.mkIf cfg.enable {
    # networking.interfaces."${cfg.interface}" = {
    #   wakeOnLan = { enable = cfg.wol; };
    # };
    time.timeZone = cfg.timeZone;
    networking = {
      firewall.enable = cfg.firewall;
      hostName = cfg.hostName;
      useDHCP = cfg.dhcp;
    };
  };
}
