{ pkgs, ... }:
let
  shAliases = {
    ll = "ls -l";
    ".." = "cd ..";
    l = "ls";
  };
in {
  programs.home-manager.enable = true;
  imports = [ ./gnome.nix ];
  nixpkgs.config.allowUnfree = true;
  home.username = "nils";
  home.homeDirectory = "/home/nils";

  home.stateVersion = "23.05";

  home.packages = with pkgs;
    [
      syncthing
      dconf
      transmission-qt
      spotify
      wezterm
      gimp
      vlc
      unzip
      ethtool
      youtube-dl
    ] ++ [
      # Gnome extensions
      pkgs.gnome3.gnome-tweaks
      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.blur-my-shell
      pkgs.gnomeExtensions.removable-drive-menu
      pkgs.gnomeExtensions.dash-to-panel
      pkgs.gnomeExtensions.tiling-assistant
      pkgs.gnomeExtensions.tray-icons-reloaded
      pkgs.gnomeExtensions.bluetooth-quick-connect
    ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
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

      config.window_background_opacity = .8
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

  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    secureSocket = false;
    plugins = with pkgs; [ tmuxPlugins.catppuccin ];
    extraConfig = ''
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      set -g mouse on
      set-option -g renumber-windows on

      bind h previous-window
      bind l next-window
      bind-key -n C-S-Left swap-window -t -1
      bind-key -n C-S-Right swap-window -t +1
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = shAliases;
  };

  home.sessionVariables = { EDITOR = "nvim"; };

  elira.java = {
    enable = true;
    jdkVersions = [ pkgs.jdk19 ];
  };

  elira.vscode = { enable = true; };

  elira.rust = { enable = true; };

  elira.keyboard = { enable = true; };

  elira.gaming = {
    enable = true;
    emulation = true;
  };

  elira.browser = {
    enable = true;
    firefox = true;
    chromium = true;
    tor = true;
  };
}
