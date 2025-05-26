{ pkgs, lib, config, ... }: {
  options.settings.keyboard = with lib; {
    enable = mkEnableOption "Keyboard development tools";
  };

  config = let cfg = config.settings.keyboard;
  in lib.mkIf cfg.enable { home.packages = with pkgs; [ via vial ]; };
}
