{
  lib,
  config,
  ...
}:
{
  options.elira.kde = with lib; {
    enable = mkEnableOption "Use KDE";
  };

  config =
    let
      cfg = config.elira.kde;
    in
    lib.mkIf cfg.enable {
      services.xserver.enable = true;
      services.xserver.desktopManager.plasma6.enable = true;
      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };
      services.displayManager.defaultSession = "plasma";
    };
}
