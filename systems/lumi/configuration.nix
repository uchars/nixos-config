{ lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  services.fstrim.enable = lib.mkDefault true;

  boot = {
    initrd.systemd.enable = true;
    supportedFilesystems = [ "ntfs" ];

    kernelParams = [
      "video=3440x1440"
    ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  programs.steam.enable = true;
  networking.hostName = "lumi";

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

  elira.vfio = {
    enable = false;
    iommu = "amd_iommu";
    pci-ids = [
      "10de:1c82" # Graphics
      "10de:0fb9" # Audio
    ];
  };

  elira.nvidia = {
    enable = true;
  };

  elira.wol = {
    enable = true;
    interface = "enp42s0";
  };

  elira.vm = {
    enable = true;
    user = "sterz_n";
  };

  elira.dwm = {
    enable = true;
    dwmUrl = "https://github.com/uchars/dwm.git";
    rev = "3e8882b9c25c13e295d60b0c042b0f02dd264792";
    wallpaper = ./wallpaper.png;
  };

  elira.displayManager = {
    enable = true;
    name = "gdm";
  };

  users.users.sterz_n = {
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