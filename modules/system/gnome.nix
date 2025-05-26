{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.settings.gnome = with lib; {
    enable = mkEnableOption "Use Gnome";
  };

  config =
    let
      cfg = config.settings.gnome;
    in
    lib.mkIf cfg.enable {
      services.xserver.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
      services.xserver.displayManager.gdm.enable = true;
    };
}
