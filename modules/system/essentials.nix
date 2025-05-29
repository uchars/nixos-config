{ pkgs, ... }:
{
  services.udev.packages = with pkgs; [ via
    vial
  ];

  environment.systemPackages = with pkgs; [
    sct
    vim
    neovim
    lm_sensors
    libnotify
    tmux
    git
    age
    wget
    ripgrep
    pciutils
    neofetch
    libwacom
  ];

  services.upower.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  hardware.graphics = {
    enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
