{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.settings.windowmaker = with lib; {
    enable = mkEnableOption "Use WindowMaker";
  };

  config =
    let
      cfg = config.settings.dwm;
    in
    lib.mkIf cfg.enable {
      environment.variables = {
        PATH = "/etc/scripts/:$PATH";
      };

      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };

      services.xserver.enable = true;
      environment.systemPackages = with pkgs; [
        blueman
        betterlockscreen
        rofi
        alsa-utils
        st
      ];

      services.xserver.desktopManager.wallpaper = {
        mode = "scale";
        combineScreens = false;
      };

      services.xserver.windowManager.windowmaker = {
        enable = true;
      };
    };
}
