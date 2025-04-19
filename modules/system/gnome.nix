{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.elira.gnome = with lib; {
    enable = mkEnableOption "Use Gnome";
  };

  config =
    let
      cfg = config.elira.gnome;
    in
    lib.mkIf cfg.enable {
      services.xserver.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
      services.xserver.displayManager.gdm.enable = true;
    };
}
