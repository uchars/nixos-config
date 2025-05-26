{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.settings.kde = with lib; {
    enable = mkEnableOption "Use KDE";
  };

  config =
    let
      cfg = config.settings.kde;
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
      environment.systemPackages = with pkgs; [
        maliit-keyboard
        libsForQt5.qt5.qtvirtualkeyboard
        maliit-framework
      ];
    };
}
