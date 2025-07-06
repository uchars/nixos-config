{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.settings.kde = with lib; {
    enable = mkEnableOption "Use KDE";
  };

  config =
    let
      cfg = config.settings.kde;
    in
    lib.mkIf cfg.enable {
    };
}
