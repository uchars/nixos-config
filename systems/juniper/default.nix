{ lib, vars, pkgs, ... }: {
  boot.kernelModules = [ "coretemp" "jc42" "lm78" ];
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  boot.zfs.forceImportRoot = true;
  zfs-root = {
    boot = {
      devNodes = "/dev/disk/by-id/";
      bootDevices = [ "ata-ST2000DM008-2UB102_ZFL6LYYY" ];
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

  # nils.networking = {
  #   enable = true;
  #   interface = "eno1";
  #   wol = true;
  #   hostname = "juniper";
  #   timezone = "Europe/Berlin";
  #   firewall = true;
  # };

  imports = [ ./filesystems ];

  powerManagement.powertop.enable = true;

  virtualisation.docker.storageDriver = "overlay2";

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
}
