{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.settings.browser = with lib; {
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
      cfg = config.settings.browser;
    in
    lib.mkIf cfg.enable {
      programs.firefox = {
        enable = true;
        languagePacks = [
          "de"
          "en-US"
        ];
        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = false;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          ExtensionSettings = {
            #"*".installation_mode = "blocked";
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4467426/bitwarden_password_manager-2025.3.2.xpi";
              installation_mode = "force_installed";
            };
            "addon@darkreader.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
              installation_mode = "force_installed";
            };
            "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4371820/return_youtube_dislikes-3.0.0.18.xpi";
              installation_mode = "force_installed";
            };
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
          };
        };
      };
      xdg.mimeApps.defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "text/xml" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
      };
      home.packages =
        with pkgs;
        (if cfg.chromium then [ chromium ] else [ ])
        ++ (if cfg.google-chrome then [ google-chrome ] else [ ])
        ++ (if cfg.brave then [ brave ] else [ ])
        ++ (if cfg.tor then [ tor-browser-bundle-bin ] else [ ]);
    };
}
