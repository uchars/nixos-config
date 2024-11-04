{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.elira.fonts = with lib; {
    enable = mkEnableOption "Enable fonts Development";
  };

  config =
    let
      cfg = config.elira.fonts;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        nerdfonts
      ];
    };
}
