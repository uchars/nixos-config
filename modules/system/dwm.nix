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
    wallpaper = mkOption {
      type = types.path;
    };
  };

  config =
    let
      cfg = config.elira.dwm;
    in
    lib.mkIf cfg.enable {
      environment.etc."scripts/dwmstatus.sh" = {
        text = ''
          get_ram_usage() {
              total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
              available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
              used=$((total - available))
              total_mb=$((total / 1024))
              used_mb=$((used / 1024))
              echo "|  $used_mb/$total_mb MB"
          }

          battery() {
              if [ -e "/sys/class/power_supply/BAT1/capacity" ]; then
                BAT_CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)
                BAT_STATUS=$(cat /sys/class/power_supply/BAT1/status)
                echo "| 󰂁 $BAT_CAPACITY% ($BAT_STATUS)"
              else
                echo ""
              fi
          }

          layout() {
              KEYBOARD_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')
              echo "|  $KEYBOARD_LAYOUT"
          }

          volume() {
              SOUND_VOLUME=$(amixer get Master | grep -oP '\d+%' | head -n 1)
              SOUND_MUTED=$(amixer get Master | grep -oP '\[.*\]' | head -n 1)
              if [[ "$SOUND_MUTED" == *"[off]"* ]]; then
                  echo " $SOUND_VOLUME"
              else
                  echo "󰕾 $SOUND_VOLUME"
              fi
          }

          while true; do
              SPOTIFY_STR=""
              SERVICE="org.mpris.MediaPlayer2.spotify"
              if dbus-send --print-reply --type=method_call --dest=$SERVICE /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2 string:Identity >/dev/null 2>/dev/null; then
                  SPOTIFY_STATE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep -oE '(Playing|Paused)')
                  SPOTIFY_TITLE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d \" -f 2)
                  SPOTIFY_STR="($SPOTIFY_STATE) $SPOTIFY_TITLE |"
              fi
              xsetroot -name "$SPOTIFY_STR $(volume) $(layout) $(get_ram_usage) $(battery) | $(date)"
              sleep 1
          done
        '';
        mode = "0755";
      };

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

      home.file.".xinitrc".text = ''
        if ! [[ $(/bin/pgrep -f "dwmstatus.sh") ]]; then
        	if [ -x "$(command -v dwmstatus.sh)" ]; then
        		dwmstatus.sh &
        	fi
        fi
      '';

      environment.variables = {
        PATH = "/etc/scripts/:$PATH";
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
