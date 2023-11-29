# Wake On LAN
{ lib, config, ... }: {
  options.elira.wol = with lib; {
    enable = mkEnableOption "Configure Wake On LAN";
    interface = mkOption {
      type = with types; str;
      description = ''
        Network interface to enable wake on lan for.
        I.e.: enp2s0
      '';
    };
  };
  config = let cfg = config.elira.wol;
  in lib.mkIf cfg.enable {
    networking.interfaces."${cfg.interface}".wakeOnLan = { enable = true; };
  };
}
