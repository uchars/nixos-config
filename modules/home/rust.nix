{ pkgs, lib, config, ... }: {
  options.elira.rust = with lib; {
    enable = mkEnableOption "Enable Rust Development";
  };

  config = let cfg = config.elira.rust;
  in lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rustup
      cargo-generate
      trunk
      sass
      rust-anayzer
      openssl
      pkgconfig
    ];
  };
}
