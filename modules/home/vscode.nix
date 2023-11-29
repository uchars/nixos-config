{ pkgs, lib, config, ... }: {
  options.elira.vscode = with lib; {
    enable = mkEnableOption "Install Visual Studio Code";
  };

  config = let cfg = config.elira.vscode;
  in lib.mkIf cfg.enable { home.packages = with pkgs; [ vscode ]; };
}
