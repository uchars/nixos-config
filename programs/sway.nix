{
  config,
  pkgs,
  lib,
  ...
}:
{

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    sway
  ];

  programs.light.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.plasma5.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = pkgs.sway;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      wf-recorder
      mako
      grim
      slurp
      dmenu
    ];
    config = rec {
      modifier = "Mod4";
      terminal = "wezterm";
      startup = [
        { command = "firefox"; }
      ];
    };
  };
}
