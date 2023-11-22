{ ... }: {
  dconf.settings = {

    "org/gnome/shell".disabled-extensions = [ ];

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

    "org/gnome/shell" = {
      enabled-extensions = [
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"
        "dash-to-panel@jderose9.github.com"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "tiling-assistant@leleat-on-github"
        "blur-my-shell@aunetx"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.wezfurlong.wezterm.desktop"
        "firefox.desktop"
        "discord.desktop"
        "steam.desktop"
      ];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/tweaks" = { show-extensions-notice = false; };

    "org/gnome/shell/extensions/dash-to-panel" = {
      multi-monitors = true;
      intellihide = false;
      panel-lengths = 100;
      trans-use-custom-bg = false;
      trans-use-custom-opacity = true;
      trans-use-dynamic-opacity = true;
      trans-panel-opacity = 0.0;
    };
  };
}
