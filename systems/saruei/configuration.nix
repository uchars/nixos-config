{ lib, system, agenix, config, pkgs, desktop, displayManager, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./vfio.nix
    ./audio.nix
    ./graphics.nix
    ./programs.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ];

  services.fstrim.enable = lib.mkDefault true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.libvirtd.enable = true;

  boot.initrd.luks.devices."luks-5efdaa8c-5be5-4142-8936-d3a24bce4eca".device =
    "/dev/disk/by-uuid/5efdaa8c-5be5-4142-8936-d3a24bce4eca";
  networking.hostName = "saruei";
  networking.interfaces.enp42s0.wakeOnLan = { enable = true; };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nils = {
    isNormalUser = true;
    description = "Nils Sterz";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;

  system.stateVersion = "23.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
