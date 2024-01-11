{ pkgs, ... }: {

  services.udev.packages = with pkgs; [ via vial ];

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    sct
    postman
    tmux
    git
    wget
    ripgrep
    pciutils
    neofetch
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
