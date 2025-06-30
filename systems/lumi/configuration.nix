{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  services.fstrim.enable = lib.mkDefault true;

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot = {
    plymouth = {
      enable = true;
      theme = "spinner";
    };
    initrd.systemd.enable = true;
    supportedFilesystems = [ "ntfs" ];
    # consoleLogLevel = 3;
    initrd.verbose = false;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "auto";
      efi.canTouchEfiVariables = true;
      #timeout = 0;
    };

    kernelParams = [
      "quiet"
      # "splash"
      #  "boot.shell_on_fail"
      # "udev.log_priority=0"
      # "rd.systemd.show_status=auto"
    ];
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  settings.networking = {
    enable = true;
    hostName = "lumi";
    wol = true;
    interface = "enp42s0";
    openconnectVpn = true;
    ssh = false;
    timeZone = "Europe/Berlin";
  };

  environment.systemPackages = with pkgs; [
    mangohud
    pandoc
  ];

  programs.gamemode.enable = true;

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

  programs.dconf.enable = true;

  system.stateVersion = "25.05";

  settings.vfio = {
    enable = false;
    iommu = "amd_iommu";
    pci-ids = [
      "10de:1c82" # Graphics
      "10de:0fb9" # Audio
    ];
  };

  settings.bluetooth.enable = true;
  settings.audio.enable = true;
  settings.nvidia = {
    enable = true;
  };

  settings.vm = {
    enable = true;
    user = "sterz_n";
  };

  services.xserver.displayManager.lightdm = {
    enable = true;
    background = ../../profiles/nils/wallpaper.png;
    greeters = {
      mini = {
        enable = true;
        user = "sterz_n";
      };
      enso = {
        enable = false;
        blur = true;
        iconTheme = {
          package = pkgs.pop-icon-theme;
          name = "Pop";
        };
        theme = {
          package = pkgs.pop-gtk-theme;
          name = "Poppy-dark-solid";
        };
        extraConfig = ''
          hide-user-image=true
        '';
      };
    };
  };
  services.displayManager.defaultSession = "none+dwm";

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  programs.ssh.startAgent = true;

  settings.dwm = {
    enable = true;
    dwmUrl = "https://github.com/uchars/dwm.git";
    rev = "3d1e52c1b2f0a2e6dabe31381ea3e271e2704c7c";
    nvidia = true;
  };

  users.users.sterz_n = {
    isNormalUser = true;
    description = "Nils Sterz";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "users"
      "fuse"
      "udev"
    ];
    uid = 1000;
  };
}
