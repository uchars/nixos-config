{ config, pkgs, ... }:
let 
  shAliases = {
    ll = "ls -l";
    ".." = "cd ..";
    l = "ls";
  };
in
{
  home.username = "nils";
  home.homeDirectory = "/home/nils";

  home.stateVersion = "23.05"; 

  home.packages = with pkgs; [
      firefox
      discord
      steam
      transmission-qt
      spotify
      wezterm
      pkgs.gnome3.gnome-tweaks
      pkgs.rpi-imager
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.file."./config/wezterm/wezterm.lua".source = ./dotfiles;

  programs.bash = {
    enable = true;
    shellAliases = shAliases;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
