{ pkgs, ... }:
{
  services.udev.packages = with pkgs; [
    via
    vial
  ];

  environment.systemPackages = with pkgs; [
    sct
    vim
    tmux
    git
    wget
    ripgrep
    pciutils
    neofetch
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  hardware.graphics = {
    enable = true;
  };
}
