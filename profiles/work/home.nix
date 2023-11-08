{ config, pkgs, ... }:
let
  shAliases = {
    ll = "ls -l";
    ".." = "cd ..";
    l = "ls";
    # "nvim" = "steam-run nvim";
  };
in
{
  programs.home-manager.enable = true;
  imports = [
    ../../programs/nvim.nix
  ];
  nixpkgs.config.allowUnfree = true;
  home.username = "nils";
  home.homeDirectory = "/home/nils";

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    dconf
    firefox
    obs-studio
    # neovim
    gcc
    go
    gopls
    openblas
    discord
    steam
    transmission-qt
    spotify
    wezterm
    nodejs
    python3
    python3.pkgs.pip
    glibc
    gnumake
    ripgrep
    virtualenv
    rustup
    unzip
    ethtool
    rpi-imager
    youtube-dl
    steam-run
  ] ++ [
    pkgs.gnome3.gnome-tweaks
    pkgs.gnomeExtensions.appindicator
    # pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.removable-drive-menu
    pkgs.gnomeExtensions.dash-to-panel
    pkgs.gnomeExtensions.tiling-assistant
    pkgs.gnomeExtensions.tray-icons-reloaded
    pkgs.gnomeExtensions.bluetooth-quick-connect
  ];

  dconf.settings = {
    "org/gnome/shell".disabled-extensions = [];

    # Configure blur-my-shell
    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.60;
      dash-opacity = 0.25;
      sigma = 60; # Sigma means blur amount
      static-blur = true;
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

  # home.file."./.config/nvim/" = {
  #   recursive = true;
  #   source = fetchGit {
  #     url = "https://github.com/uchars/nvim.git";
  #     rev = "0986d8b09508b50913dc3bb4fca04834733d2f82";
  #   };
  # };

  home.file."./.config/tmux/" = {
    recursive = true;
    source = fetchGit {
      url = "https://github.com/uchars/tmux.git";
      rev = "a0eefc23d4b3c402daf38ac0f4c241b5b8b27127";
    };
  };

  home.file."./.config/wezterm/wezterm.lua" = {
    recursive = true;
    text = ''
      local wezterm = require 'wezterm'

      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.window_background_opacity = .6
      config.use_fancy_tab_bar = false
      config.window_decorations = "NONE"
      config.hide_tab_bar_if_only_one_tab = true
      config.warn_about_missing_glyphs = false

      config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
      }

      return config
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = shAliases;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
