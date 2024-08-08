# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, vars, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    "${
      builtins.fetchTarball {
        url =
          "https://github.com/nix-community/disko/archive/refs/tags/v1.6.1.tar.gz";
        sha256 = "1p9vsml07bm3riw703dv83ihlmgyc11qv882qa6bqzqdgn86y8z4";
      }
    }/module.nix"
    ./disko-config.nix
    ./shares
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    extraPackages = [ pkgs.zfs ];
    defaultNetwork.settings = { dns_enabled = true; };
  };
  virtualisation.oci-containers = { backend = "podman"; };

  fileSystems."/" = lib.mkForce {
    device = "zroot/nixos/empty";
    fsType = "zfs";
  };

  boot.initrd.systemd.services.rollback = {
    description = "Rollback ZFS datasets to a pristine state";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-zroot.service" ];
    before = [ "sysroot.mount" ];
    path = with pkgs; [ zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r zroot/nixos/empty@start
    '';
  };

  fileSystems."/nix" = {
    device = "zroot/nixos/nix";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/etc/nixos" = {
    device = "zroot/nixos/config";
    fsType = "zfs";
    neededForBoot = true;
  };

  # fileSystems."/boot" = {
  #   device = "zroot/nixos/root";
  #   fsType = "zfs";
  # };

  fileSystems."/home" = {
    device = "zroot/nixos/home";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/persist" = {
    device = "zroot/nixos/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "zroot/nixos/var/log";
    fsType = "zfs";
  };

  fileSystems."/var/lib/containers" = {
    device = "/dev/zvol/zroot/docker";
    fsType = "ext4";
  };

  networking.hostId = "8425e349";
  networking.firewall.enable = false;
  time.timeZone = "Europe/Berlin";
  networking.hostName = "juniper";

  virtualisation.docker.storageDriver = "overlay2";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
