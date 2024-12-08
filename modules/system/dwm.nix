{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.elira.dwm = with lib; {
    enable = mkEnableOption "Use DWM";
    dwmUrl = mkOption {
      type = types.str;
      default = "";
    };
    rev = mkOption {
      type = types.str;
      default = "";
    };
    conf = mkOption {
      type = types.path;
    };
  };

  config =
    let
      cfg = config.elira.dwm;
    in
    lib.mkIf cfg.enable {
      environment.etc = {
        "scripts/kbdswitch.sh".text = ''
          KEYBOARD_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')
          if [ "$KEYBOARD_LAYOUT" = "us" ]; then
            setxkbmap de
          else
            setxkbmap us
          fi
        '';
        "scripts/kbdswitch.sh".mode = "0755";
      };

      system.activationScripts.makeScriptExecutable = lib.mkAfter ''
        chmod +x /etc/scripts/kbdswitch.sh
      '';

      environment.variables = {
        PATH = "/etc/scripts/:$PATH";
      };

      services.xserver.enable = true;
      environment.systemPackages = with pkgs; [
        dmenu
        blueman
        betterlockscreen
        rofi
        st
      ];
      services.xserver.windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs (oldAttrs: {
          src = builtins.fetchGit {
            url = cfg.dwmUrl;
            rev = cfg.rev;
          };
        });
      };
    };
}
