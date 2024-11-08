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
  };

  config =
    let
      cfg = config.elira.dwm;
    in
    lib.mkIf cfg.enable {
      services.xserver.enable = true;
      environment.systemPackages = with pkgs; [
        dmenu
        st
      ];
      services.xserver.windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs {
          src = builtins.fetchGit {
            url = cfg.dwmUrl;
            rev = cfg.rev;
          };
        };
      };
    };
}
