{ lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  services.fstrim.enable = lib.mkDefault true;

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot = {
    plymouth = {
      enable = true;
      theme = "spinner";
    };
    initrd.systemd.enable = true;
    supportedFilesystems = [ "ntfs" ];
    consoleLogLevel = 3;
    initrd.verbose = false;

    kernelParams = [
      "video=3440x1440"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=0"
      "rd.systemd.show_status=auto"
    ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  networking.hostName = "lumi";

  environment.systemPackages = with pkgs; [
    mangohud
    texliveFull
    pandoc
  ];

  programs.gamemode.enable = true;

  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.dragAndDrop = true;
  #users.extraGroups.vboxusers.members = [ "sterz_n" ];

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
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };
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
    rev = "91b078f9a3d3c7eca9f67929577f12cb8cef3b73";
    wallpaper = ./wallpaper.png;
  };

  elira.displayManager = {
    enable = true;
    name = "gdm";
  };

  elira.syncthing = {
    enable = true;
    user = "sterz_n";
    dir = "/home/sterz_n/Documents";
    sharedFolders = {
      "Uni_Documents" = {
        path = "/home/sterz_n/Nextcloud/Documents/Uni";
        devices = [ "boox" ];
      };
    };
    deviceConfig = {
      boox = {
        id = "VHC5QDC-IDELDHV-OZ4I5LO-LPX7JVY-D554HCL-NUAFXAU-NKVCPDO-533ZEAV";
      };
    };
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
