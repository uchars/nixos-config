{ lib, config, pkgs, desktop, displayManager, ... }: {
  imports = [ ./hardware-configuration.nix ./disks.nix ./vfio.nix ];

  boot.supportedFilesystems = [ "ntfs" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.fstrim.enable = lib.mkDefault true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.${displayManager}.enable = true;
  services.xserver.desktopManager.${desktop}.enable = true;

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
    print-manager
  ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nils = {
    isNormalUser = true;
    description = "Nils Sterz";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.udev.packages = with pkgs; [ via vial ];

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    virt-manager
    sct
    tmux
    git
    wget
    pciutils
    wezterm
    neofetch
  ];

  programs.dconf.enable = true;

  system.stateVersion = "23.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
