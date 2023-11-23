{ pkgs, agenix, ... }: {

  services.udev.packages = with pkgs; [ via vial ];

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs;
    [
      virt-manager
      sct
      tmux
      git
      wget
      pciutils
      neofetch
    ] ++ [ agenix.packages."${system}".default ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
