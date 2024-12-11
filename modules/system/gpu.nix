{ lib, config, ... }:
{
  options.elira.nvidia = with lib; {
    enable = mkEnableOption "Configure a NVIDIA GPU";
  };

  config =
    let
      cfg = config.elira.nvidia;
    in
    lib.mkIf cfg.enable {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };
}
