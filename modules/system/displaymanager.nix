{
  lib,
  config,
  ...
}:
{
  options.settings.displayManager = with lib; {
    enable = mkEnableOption "Using display manager";
    name = mkOption {
      type = types.str;
      default = "gdm";
    };
  };

  config =
    let
      cfg = config.settings.displayManager;
    in
    lib.mkIf cfg.enable {
      services.xserver.enable = true;

      services.xserver.displayManager.${cfg.name}.enable = true;

      services.xserver = {
        xkb = {
          layout = "us";
        };
      };
    };
}
