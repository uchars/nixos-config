{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.settings.dwm = with lib; {
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
    nvidia = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config =
    let
      cfg = config.settings.dwm;
    in
    lib.mkIf cfg.enable {

      environment.etc."scripts/dwmstatus.sh" = {
        text = ''
          #!${pkgs.bash}/bin/bash
          ram() {
              free --mebi | sed -n '2{p;q}' | awk '{printf ("| 🧠 %2.2fGiB/%2.2fGiB\n", ( $3 / 1024), ($2 / 1024))}'
          }

          cpu() {
              read -r cpu user nice system idle iowait irq softirq steal _ </proc/stat

              total=$((user + nice + system + idle + iowait + irq + softirq + steal))
              idle_total=$((idle + iowait))

              sleep 0.3

              read -r cpu user nice system idle iowait irq softirq steal _ </proc/stat

              total_new=$((user + nice + system + idle + iowait + irq + softirq + steal))
              idle_new=$((idle + iowait))

              total_delta=$((total_new - total))
              idle_delta=$((idle_new - idle_total))
              usage=$((100 * (total_delta - idle_delta) / total_delta))

              printf "| 💻 %3d%%" "$usage"
          }

          gpu() {
              usage=""
              if [[ "${if cfg.nvidia then "true" else "false"}" == true ]]; then
                usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{printf "%3d", $1}')
              else
                usage=$(radeontop -d - -l 1 | grep -oP 'gpu \K\d+')
              fi
              printf "| 🎨 %3d%%" "$usage"
          }

          battery() {
              if [ -e "/sys/class/power_supply/BAT1/capacity" ]; then
                BAT_CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)
                BAT_STATUS=$(cat /sys/class/power_supply/BAT1/status)
                echo "| 🔋 $BAT_CAPACITY% ($BAT_STATUS)"
              else
                echo ""
              fi
          }

          layout() {
              KEYBOARD_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')
              FLAG="🌍"
              echo "| $FLAG $KEYBOARD_LAYOUT"
          }

          volume() {
              SOUND_VOLUME=$(amixer get Master | grep -oP '\d+%' | head -n 1 | tr -d '%')
              SOUND_MUTED=$(amixer get Master | grep -oP '\[.*\]' | head -n 1)
              OUTPUT=$(wpctl status | awk '/Sinks:/{flag=1; next} flag && /*/{sub(/.*\. /,""); sub(/ +\[vol:.*/,""); print; exit}')
              EMOJI="🔇"
              if [[ "$SOUND_MUTED" == *"[off]"* ]]; then
                  EMOJI="🔇"
              else
                  if [ "$SOUND_VOLUME" -gt "75" ]; then
                    EMOJI="🔊"
                  elif [ "$SOUND_VOLUME" -gt "45" ]; then
                    EMOJI="🔉"
                  else
                    EMOJI="🔈"
                  fi
              fi
              echo "$EMOJI $SOUND_VOLUME% ($OUTPUT)"
          }

          while true; do
              SPOTIFY_STR=""
              SERVICE="org.mpris.MediaPlayer2.spotify"
              if dbus-send --print-reply --type=method_call --dest=$SERVICE /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2 string:Identity >/dev/null 2>/dev/null; then
                  SPOTIFY_STATE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep -oE '(Playing|Paused)')
                  SPOTIFY_TITLE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d \" -f 2)
                  SPOTIFY_STR="($SPOTIFY_STATE) $SPOTIFY_TITLE |"
              fi
              xsetroot -name "$SPOTIFY_STR $(volume) $(layout) $(ram) $(cpu) $(gpu) | 📅 $(date) $(battery)"
              sleep 0.5
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
        alsa-utils
        st
        radeontop
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

      services.xserver.displayManager.sessionCommands = ''
        ${pkgs.bash}/bin/bash /etc/scripts/dwmstatus.sh &
        blueman-applet&
        nm-applet&
      '';
    };
}
