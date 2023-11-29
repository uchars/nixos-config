{ lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.supportedFilesystems = [ "ntfs" ];

  services.fstrim.enable = lib.mkDefault true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.libvirtd.enable = true;

  boot.initrd.luks.devices."luks-5efdaa8c-5be5-4142-8936-d3a24bce4eca".device =
    "/dev/disk/by-uuid/5efdaa8c-5be5-4142-8936-d3a24bce4eca";
  networking.hostName = "saruei";

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

  system.stateVersion = "23.05";

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

  elira.vfio = {
    enable = true;
    iommu = "amd_iommu";
    pci-ids = [
      "10de:1c82" # Graphics
      "10de:0fb9" # Audio
    ];
  };

  elira.nvidia = { enable = true; };

  elira.wol = {
    enable = true;
    interface = "enp42s0";
  };
}
