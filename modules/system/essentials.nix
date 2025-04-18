{ pkgs, ... }:
{
  services.udev.packages = with pkgs; [
    via
    vial
  ];

  environment.systemPackages = with pkgs; [
    sct
    vim
    neovim
    tmux
    git
    age
    wget
    ripgrep
    pciutils
    neofetch
    libwacom
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  hardware.graphics = {
    enable = true;
  };
}
