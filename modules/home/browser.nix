{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.elira.browser = with lib; {
    enable = mkEnableOption "Install Browsers";
    brave = mkOption {
      description = "Install Brave browser";
      default = false;
      type = types.bool;
    };
    firefox = mkOption {
      description = "Install firefox browser";
      default = false;
      type = types.bool;
    };
    google-chrome = mkOption {
      description = "Install Google Chrome browser";
      default = false;
      type = types.bool;
    };
    chromium = mkOption {
      description = "Install chromium browser";
      default = false;
      type = types.bool;
    };
    tor = mkOption {
      description = "Install tor browser";
      default = false;
      type = types.bool;
    };
  };

  config =
    let
      cfg = config.elira.browser;
    in
    lib.mkIf cfg.enable {
      home.packages =
        with pkgs;
        (if cfg.firefox then [ firefox ] else [ ])
        ++ (if cfg.chromium then [ chromium ] else [ ])
        ++ (if cfg.google-chrome then [ google-chrome ] else [ ])
        ++ (if cfg.brave then [ brave ] else [ ])
        ++ (if cfg.tor then [ tor-browser-bundle-bin ] else [ ]);
    };
}
