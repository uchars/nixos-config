{ config, lib, vars, pkgs, ... }: {
  boot.kernelModules = [ "coretemp" "jc42" "lm78" ];
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  boot.zfs.forceImportRoot = true;
  zfs-root = {
    boot = {
      devNodes = "/dev/disk/by-id/";
      bootDevices = [ "ata-ST2000DM008-2FR102_WK30A95M" ];
      immutable = false;
      availableKernelModules =
        [ "uhci_hcd" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
      removableEfi = true;

      kernelParams =
        [ "pcie_aspm=force" "consoleblank=60" "acpi_enforce_resources=lax" ];
      sshUnlock = {
        enable = false;
        authorizedKeys = [ ];
      };
    };
  };

  imports = [ ./filesystems ./shares ];

  powerManagement.powertop.enable = true;

  services.hddfancontrol = {
    enable = true;
    disks = [
      "/dev/disk/by-label/Data1"
      "/dev/disk/by-label/Data2"
      "/dev/disk/by-label/Data3"
      "/dev/disk/by-label/Parity1"
    ];
    pwmPaths = [
      "/sys/class/hwmon/hwmon1/device/pwm2"
    ];
    extraArgs = [
      "--pwm-start-value=100"
      "--pwm-stop-value=50"
      "--smartctl"
      "-i 30"
      "--spin-down-time=900"
    ];
  };

  virtualisation.docker.storageDriver = "overlay2";

  system.autoUpgrade.enable = true;

  mover = {
    cacheArray = vars.cacheArray;
    backingArray = vars.slowArray;
    percentageFree = 60;
    excludedPaths = [
      "YoutubeCurrent"
      "Downloads.tmp"
      "Media/Kiwix"
      "Documents"
      "TimeMachine"
      ".DS_Store"
      ".cache"
    ];
  };

  environment.systemPackages = with pkgs; [
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

  networking.hostId = "8425e349";
  networking.firewall.enable = false;
  time.timeZone = "Europe/Berlin";
  networking.hostName = "juniper";


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  elira.wol = {
    enable = true;
    interface = "eno1";
  };

  services.openssh = {
    enable = true;
    settings = { PasswordAuthentication = true; };
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults env_keep += "EDITOR=nano"
    '';
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
