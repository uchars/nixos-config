{ pkgs, ... }: {

  services.udev.packages = with pkgs; [ via vial ];

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    virt-manager
    sct
    postman
    tmux
    git
    wget
    pciutils
    neofetch
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
