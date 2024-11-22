{
  pkgs,
  nextcloudUrl,
  nextcloudAdmin,
  acmeMail,
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
      allowedTCPPorts = [
        5432
        443
      ];
      allowedUDPPorts = [
        5432
        443
      ];
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
    git
    ripgrep
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

  services.nginx.virtualHosts = {
    "${nextcloudUrl}" = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000" always;
        client_body_buffer_size 512k;
      '';
    };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      "${nextcloudUrl}" = {
        email = "${acmeMail}";
      };
    };
  };

  services.nextcloud = {
    enable = true;
    hostName = "${nextcloudUrl}";
    package = pkgs.nextcloud30;
    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";
    https = true;
    home = "/raid/crypt/appdata/nextcloud";
    settings = {
      overwriteprotocol = "https";
    };
    config = {
      adminuser = "${nextcloudAdmin}";
      adminpassFile = "/tmp/pass.txt";
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
