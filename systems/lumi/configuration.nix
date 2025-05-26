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
    # consoleLogLevel = 3;
    initrd.verbose = false;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
      #timeout = 0;
    };

    kernelParams = [
      "video=3440x1440"
      "quiet"
      "splash"
      #  "boot.shell_on_fail"
      "udev.log_priority=0"
      "rd.systemd.show_status=auto"
    ];
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  elira.networking = {
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;

  system.stateVersion = "24.11";

  elira.vfio = {
    enable = false;
    iommu = "amd_iommu";
    pci-ids = [
      "10de:1c82" # Graphics
      "10de:0fb9" # Audio
    ];
  };

  elira.bluetooth.enable = true;
  elira.audio.enable = true;
  elira.nvidia = {
    enable = true;
  };

  elira.vm = {
    enable = true;
    user = "sterz_n";
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.bash}/bin/bash /etc/scripts/dwmstatus.sh &
    blueman-applet&
  '';

  programs.hyprland.enable = false;
  elira.dwm = {
    enable = true;
    dwmUrl = "https://github.com/uchars/dwm.git";
    rev = "91b078f9a3d3c7eca9f67929577f12cb8cef3b73";
  };

  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
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
