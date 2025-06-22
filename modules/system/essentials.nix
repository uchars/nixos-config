{ pkgs, ... }:
{
  services.udev.enable = true;
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
    libheif
    wget
    ripgrep
    pciutils
    go-mtpfs
    neofetch
    libwacom
    xournalpp
    xclip
  ];

  services.upower.enable = true;

  programs = {
    fuse.userAllowOther = true;
  };

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
