{ pkgs, ... }:
let
  shAliases = {
    ll = "ls -l";
    ".." = "cd ..";
    l = "ls";
  };
in {
  programs.home-manager.enable = true;
  imports = [ ../../programs/neovim/nvim.nix ./gnome.nix ];
  nixpkgs.config.allowUnfree = true;
  home.username = "nils";
  home.homeDirectory = "/home/nils";

  home.stateVersion = "23.05";

  home.packages = with pkgs;
    [
      syncthing
      via
      vial
      dconf
      firefox
      chromium
      cmake
      obs-studio
      gcc
      go
      discord
      steam
      transmission-qt
      spotify
      wezterm
      barrier
      gimp
      vlc
      nodejs
      python3
      python3.pkgs.pip
      glibc
      gnumake
      ripgrep
      virtualenv
      unzip
      cargo
      rustc
      ethtool
      rpi-imager
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
    ] ++ [
      # Language Servers
      pkgs.nil
      pkgs.gopls
      pkgs.rust-analyzer
      pkgs.nodePackages.typescript-language-server
      pkgs.clang-tools
      pkgs.pyright
      pkgs.marksman
      pkgs.cmake-language-server
      pkgs.nodePackages.bash-language-server
      pkgs.lua-language-server
      pkgs.nodePackages.vscode-html-languageserver-bin
    ] ++ [
      # Formatters
      pkgs.stylua
      pkgs.nixfmt
      pkgs.nodePackages.prettier
      pkgs.nodePackages.fixjson
      pkgs.nodePackages.markdownlint-cli
      pkgs.python310Packages.autopep8
    ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    # home.file."./.config/nvim/" = {
    #   recursive = true;
    #   source = fetchGit {
    #     url = "https://github.com/uchars/nvim.git";
    #     rev = "0986d8b09508b50913dc3bb4fca04834733d2f82";
    #   };
    # };
  };

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

  home.sessionVariables = { EDITOR = "nvim"; };

  elira.java = {
    enable = true;
    jdkVersions = [ pkgs.jdk19 ];
  };

  elira.vscode = { enable = true; };
}
