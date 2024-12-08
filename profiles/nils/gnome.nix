{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnome3.gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.blur-my-shell
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.dash-to-panel
    gnomeExtensions.tiling-assistant
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.bluetooth-quick-connect
    gnomeExtensions.user-themes
    orchis
    nordic
  ];

  gtk = {
    #iconTheme = {
    #  name = "Nordic-green";
    #  package = pkgs.nordic;
    #};

    #theme = {
    #  name = "Nordic-darker";
    #  package = pkgs.nordic;
    #};

    #cursorTheme = {
    #  name = "Nordic-cursors";
    #  package = pkgs.nordic;
    #};
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [ ];
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        #"apps-menu@gnome-shell-extensions.gcampax.github.com"
        #"trayIconsReloaded@selfmade.pl"
        #"dash-to-panel@jderose9.github.com"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        #"tiling-assistant@leleat-on-github"
        #"blur-my-shell@aunetx"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "firefox.desktop"
        "discord.desktop"
        "steam.desktop"
      ];
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Nordic-darker";
    };

    # Configure blur-my-shell
    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.6;
      dash-opacity = 0.25;
      sigma = 60; # Sigma means blur amount
      static-blur = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      whitelist = [ "org.wezfurlong.wezterm" ];
    };

    "org/gnome/shell/extensions/blur-my-shell/panel".blur = true;
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      blur = true;
      style-dialogs = 0;
    };

    "org/gnome/shell/extensions/bluetooth-quick-connect" = {
      keep-menu-on-toggle = true;
      refresh-button-on = true;
      show-batter-icon-on = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      multi-monitors = false;
      intellihide = false;
      panel-lengths = 100;
      trans-use-custom-bg = false;
      # trans-use-custom-opacity = true;
      # trans-use-dynamic-opacity = true;
      # trans-panel-opacity = 0.0;
    };
  };
}
