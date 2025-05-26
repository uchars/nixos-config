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
      environment.etc."scripts/kbdswitch.sh" = {
        text = ''
          KEYBOARD_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')
          if [ "$KEYBOARD_LAYOUT" = "us" ]; then
            setxkbmap de
          else
            setxkbmap us
          fi
        '';
        mode = "0755";
      };

      system.activationScripts.makeScriptExecutable = lib.mkAfter ''
        chmod +x /etc/scripts/kbdswitch.sh
      '';

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
