{
  pkgs,
  desktop,
  displayManager,
  ...
}:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  environment.systemPackages = with pkgs; [
    dmenu
    st
  ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.${displayManager}.enable = true;
  services.xserver.windowManager.${desktop}.enable = true;

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
    print-manager
  ];

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
}
