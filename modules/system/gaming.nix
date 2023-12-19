{ pkgs, lib, config, ... }: {
  options.elira.gaming = with lib; {
    enable = mkEnableOption "General Software for Gaming";
  };

  config = let cfg = config.elira.gaming;
  in lib.mkIf cfg.enable {
    home.packages = with pkgs; [ steam discord obs-studio ];
  };
}
