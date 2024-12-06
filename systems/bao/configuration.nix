{ pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.supportedFilesystems = [ "ntfs" ];

  services.fstrim.enable = lib.mkDefault true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;

  system.stateVersion = "24.05";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.steam.enable = true;
  elira.dwm = {
    enable = true;
    dwmUrl = "https://github.com/uchars/dwm.git";
    rev = "b26ed0c94ee4ebed9d0f1f3185e555d74cb7f187";
  };

  elira.displayManager = {
    enable = true;
    name = "gdm";
  };

  environment.systemPackages = with pkgs; [
    python312Packages.dbus-python
    pandoc
    openconnect
  ];

  elira.syncthing = {
    enable = true;
    user = "nils";
    dir = "/home/nils/Documents";
    sharedFolders = {
      "Uni_Documents" = {
        path = "/home/nils/Nextcloud/Documents/Uni";
        devices = [ "boox" ];
      };
    };
    deviceConfig = {
      boox = {
        id = "VHC5QDC-IDELDHV-OZ4I5LO-LPX7JVY-D554HCL-NUAFXAU-NKVCPDO-533ZEAV";
      };
    };
  };

  fonts.packages = with pkgs; [
    lato
  ];

  users.users.nils = {
    isNormalUser = true;
    description = "Nils Sterz";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "users"
    ];
    uid = 1000;
  };
}
