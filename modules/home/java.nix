{ pkgs, lib, config, ... }: {
  options.elira.java = with lib; {
    enable = mkEnableOption "Enable Java Development";

    jdkVersions = mkOption { description = "Jdk versions to install."; };
  };

  config = let cfg = config.elira.java;
  in lib.mkIf cfg.enable {
    home.packages = with pkgs; [ jetbrains.idea-ultimate ] ++ cfg.jdkVersions;
  };
}
