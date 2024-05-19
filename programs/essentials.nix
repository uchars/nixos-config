{ pkgs, ... }: {

  services.udev.packages = with pkgs; [ via vial ];

  environment.systemPackages = with pkgs; [
    sct
    tmux
    git
    wget
    ripgrep
    pciutils
    neofetch
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
