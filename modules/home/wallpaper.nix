{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.elira.wallpaper = with lib; {
    swww = mkOption {
      type = types.bool;
      default = false;
    };
    hyprpaper = mkOption {
      type = types.bool;
      default = false;
    };
    path = mkOption {
      default = "";
      type = types.str;
    };
  };

  config =
    let
      cfg = config.elira.wallpaper;
    in
    {
      home.packages = with pkgs; (if cfg.swww then [ swww ] else [ ]);
      services.hyprpaper = {
        enable = cfg.hyprpaper;
        settings = {
          # dbb74c50-17dd-478f-a8ac-d10b428a0466_rw_1200.gif
          # c4a05f73-fafd-4ad5-8d6a-d59667b19dc6_rw_1200.gif
          preload = [ cfg.path ];
        };
      };
    };
}
