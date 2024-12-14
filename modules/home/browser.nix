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
programs.firefox = {
enable = true;
languagePacks = [ "de" "en-US" ];
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
	install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden_password_manager/latest.xpi";
            installation_mode = "force_installed";
};
	  "addon@darkreader.org" = {
		  install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
};
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
	  };
};
};
};
      home.packages =
        with pkgs;
        (if cfg.chromium then [ chromium ] else [ ])
        ++ (if cfg.google-chrome then [ google-chrome ] else [ ])
        ++ (if cfg.brave then [ brave ] else [ ])
        ++ (if cfg.tor then [ tor-browser-bundle-bin ] else [ ]);
    };
}
