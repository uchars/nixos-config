{
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];

  networking.hostName = "juniper";
  networking.hostId = "007f0200";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  networking = {
    useDHCP = true;
    networkmanager.enable = false;
    firewall = {
      allowPing = true;
      trustedInterfaces = [ "eno1" ];
    };
  };

  elira.wol = {
    enable = true;
    interface = "eno1";
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    zfs
    vim
    wget
    pciutils
    glances
    hdparm
    hd-idle
    hddtemp
    smartmontools
    go
    gotools
    gopls
    go-outline
    gopkgs
    gocode-gomod
    godef
    golint
    powertop
    cpufrequtils
    gnumake
    gcc
    intel-gpu-tools
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  environment.sessionVariables = {
    EDITOR = "vim";
  };

  boot.zfs.extraPools = [ "BUG" ];

  services.zfs.autoScrub.enable = true;

  system.stateVersion = "24.05";

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
