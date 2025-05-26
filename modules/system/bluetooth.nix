{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.elira.bluetooth = with lib; {
    enable = mkEnableOption "Enable bluetooth and useful options";
  };

  config =
    let
      cfg = config.elira.bluetooth;
    in
    lib.mkIf cfg.enable {
      hardware.bluetooth.settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };

      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      systemd.user.services.mpris-proxy = {
        description = "Mpris proxy";
        after = [
          "network.target"
          "sound.target"
        ];
        wantedBy = [ "default.target" ];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      };
      services.blueman.enable = true;
    };
}
