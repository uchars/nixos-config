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

    "org/gnome/shell/extensions/dash-to-panel" = {
      multi-monitors = true;
      intellihide = false;
      panel-lengths = 100;
    };
  };
}
