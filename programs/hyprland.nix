{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
    dunst
    networkmanagerapplet
    libnotify
    kitty
    blueman
    font-awesome
    rofi-wayland
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware = {
    opengl.enable = true;
  };
}
