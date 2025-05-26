{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.settings.fonts = with lib; {
    enable = mkEnableOption "Enable fonts Development";
  };

  config =
    let
      cfg = config.settings.fonts;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        nerdfonts
      ];
    };
}
