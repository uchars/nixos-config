{ pkgs, lib, config, ... }: {
  options.elira.android = with lib; {
    enable = mkEnableOption "Enable Android Development";
  };

  config = let cfg = config.elira.android;
  in lib.mkIf cfg.enable { home.packages = with pkgs; [ android-studio ]; };
}
