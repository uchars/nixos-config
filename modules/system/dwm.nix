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
      services.xserver.enable = true;
      environment.systemPackages = with pkgs; [
        dmenu
        betterlockscreen
        rofi
        st
      ];
      services.xserver.windowManager.dwm.package = pkgs.dwm.override {
        conf = cfg.conf;
        # patches = [
        #   (super.fetchpatch {
        #     url = "https://dwm.suckless.org/patches/steam/dwm-steam-6.2.diff";
        #     sha256 = "sha256-f3lffBjz7+0Khyn9c9orzReoLTqBb/9gVGshYARGdVc=";
        #   })
        # ];
      };
      services.xserver.windowManager.dwm.enable = true;
      # services.xserver.windowManager.dwm = {
      #   enable = true;
      #   package = pkgs.dwm.overrideAttrs {
      #     src = builtins.fetchGit {
      #       url = cfg.dwmUrl;
      #       rev = cfg.rev;
      #     };
      #   };
      # };
    };
}
