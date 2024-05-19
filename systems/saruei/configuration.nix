{ lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.supportedFilesystems = [ "ntfs" ];

  services.fstrim.enable = lib.mkDefault true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-7ddbb096-92e7-43c0-960e-a2927f4e95a8".device =
    "/dev/disk/by-uuid/7ddbb096-92e7-43c0-960e-a2927f4e95a8";

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

  system.stateVersion = "23.11";

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
    enable = false;
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

  elira.vm = {
    enable = true;
    user = "nils";
  };

  elira.syncthing = {
    enable = true;
    user = "nils";
    dir = "/home/nils";
    deviceConfig = {
      "laptop" = {
        id = "I4GZSU2-RCVRCDJ-NCBJKXN-3U6CNW4-APT4YJZ-B4BEQ5R-QMZULXI-O66IIAF";
      };
      "iPhoneNils" = {
        id = "NBQRQT6-72YWCPW-7ZN6KBE-CSSNQWV-EUH4M6W-VGHSG6Z-ZZX556R-JMEZQQH";
      };
      "server" = {
        id = "WMLEXHS-F5L7GWK-EPMLZYQ-3MOLA62-OVXRTDH-J3QAALU-HYEAC67-P52VZQ6";
      };
    };
  };
}
