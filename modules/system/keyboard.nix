{ pkgs, lib, config, ... }: {
  options.elira.keyboard = with lib; {
    enable = mkEnableOption "Keyboard development tools";
  };

  config = let cfg = config.elira.keyboard;
  in lib.mkIf cfg.enable { home.packages = with pkgs; [ via vial ]; };
}
