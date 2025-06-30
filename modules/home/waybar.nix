{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.settings.waybar = with lib; {
    enable = mkEnableOption "Configure waybar";
    monitors = mkOption {
      type = types.nullOr (types.either types.str (types.listOf types.str));
      default = null;
      example = literalExpression ''
        ["DP-4" "eDP-1"]
      '';
    };
    systemd = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config =
    let
      cfg = config.settings.waybar;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        light
        nerd-fonts.hack
        pavucontrol
      ];
      programs.waybar = {
        enable = false;
        systemd.enable = true;
        settings = {
          mainBar = {
            layer = "bottom";
            position = "bottom";
            height = 20;
            output = cfg.monitors;
            modules-left = [
              "hyprland/window"
            ];
            modules-center = [
              "hyprland/workspaces"
            ];
            modules-right = [
              "cpu"
              "memory"
              "pulseaudio"
              "network"
              "backlight"
              "battery"
              "clock"
              "tray"
            ];

            "hyprland/workspaces" = {
              active-only = false;
              all-outputs = true;
              format = "{id}";
            };

            "backlight" = {
              "format" = "󰃠 {}%";
              "actions" = {
                "on-scroll-up" = "light -A 5";
                "on-scroll-down" = "light -U 5";
                "on-click-left" = "light -S 50";
              };
              "tooltip" = false;
              "states" = [ 50 ];
              "format-icons" = [
                ""
                ""
              ];
            };

            "clock" = {
              "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              "format" = "{:%F %T}";
              "format-alt" = "{:%F %T}";
              "interval" = 1;
            };

            "hyprland/window" = {
              icon = true;
              icon-size = 16;
            };

            "sway/language" = {
              "format" = "{short} {variant}";
              "on-click" = "swaymsg input type:keyboard xkb_switch_layout next";
            };

            "temperature" = {
              "critical-threshold" = 80;
              "format" = "{temperatureC}°C ";
            };

            "battery" = {
              "format" = "{capacity}% {icon}";
              "format-icons" = [
                ""
                ""
                ""
                ""
                ""
              ];
            };

            "cpu" = {
              "format" = "{usage}% ";
            };

            "network" = {
              "format-wifi" = "{essid} ({signalStrength}%) ";
              "format-ethernet" = "{ifname}: {ipaddr}/{cidr} ";
              "format-disconnected" = "Disconnected ⚠";
              "interval" = 7;
            };

            "memory" = {
              "format" = "{}% ";
            };

            "idle_inhibitor" = {
              "format" = "{icon}";
              "format-icons" = {
                "activated" = "";
                "deactivated" = "";
              };
            };

            "pulseaudio" = {
              "format" = "{icon}   {volume}%";
              "on-click" = "amixer -D pipewire set Master toggle";
              "on-click-right" = "pavucontrol";
              "format-muted" = "";
              "format-icons" = {
                "headphones" = "";
                "handsfree" = "";
                "headset" = "";
                "phone" = "";
                "portable" = "";
                "car" = "";
                "default" = [
                  ""
                  ""
                ];
              };
            };
          };
        };
      };
    };
}
