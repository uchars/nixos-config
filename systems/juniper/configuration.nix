{
  config,
  pkgs,
  nextcloudSubdomain,
  domain,
  vaultwardenSubdomain,
  vaultwardenPort,
  nextcloudAdmin,
  pasteSubdomain,
  acmeMail,
  inputs,
  sopsFile,
  sopsKeyFile,
  ...
}:
let
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = sopsFile;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = sopsKeyFile;
  sops.secrets."juniper/userpassword".neededForUsers = true;

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
      enable = true;
      allowPing = true;
      trustedInterfaces = [ "eno1" ];
      allowedTCPPorts = [
        2033
        443
      ];
      allowedUDPPorts = [
        2033
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
    vaultwarden
    ddns-updater
    dashy-ui
    hd-idle
    vim
    wget
    git
    ripgrep
  ];

  sops.secrets."juniper/ddnspassword" = {
    owner = "ddns-updater";
  };
  systemd.services.ddns-updater = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    unitConfig = {
      Description = "DDNS-updater service";
    };
    environment = {
	    DATADIR = "%S/ddns-updater";
    };
    script = ''
export CONFIG="{\"settings\":[ {\"provider\":\"namecheap\",\"host\":\"@,cloud,pass,paste,www\",\"domain\":\"${domain}\",\"password\":\"$(cat ${config.sops.secrets."juniper/ddnspassword".path})\"}]}"
echo $CONFIG
     ${pkgs.ddns-updater}/bin/ddns-updater
    '';
    serviceConfig = {
      TimeoutSec = "5min";
      RestartSec = 30;
      DynamicUser = true;
      StateDirectory = "ddns-updater";
      Restart = "on-failure";
    };
  };
  users.users.ddns-updater = {
    home = "/var/lib/ddns-updater";
    createHome = true;
    isSystemUser = true;
    group = "ddns-updater";
  };
  users.groups.ddns-updater = { };

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

  system.stateVersion = "24.11";

  services.nginx.virtualHosts = {
    "${domain}" = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000" always;
        client_body_buffer_size 512k;
      '';
      locations."/" = {
        proxyPass = "http://localhost:8080";
      };
    };
    "${vaultwardenSubdomain}.${domain}" = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000" always;
        client_body_buffer_size 512k;
      '';
      locations."/" = {
        proxyPass = "http://localhost:${vaultwardenPort}";
      };
    };
    "${pasteSubdomain}.${domain}" = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000" always;
        client_body_buffer_size 512k;
      '';
    };
    "${nextcloudSubdomain}.${domain}" = {
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
      "${domain}" = {
        email = "${acmeMail}";
      };
      "${vaultwardenSubdomain}.${domain}" = {
        email = "${acmeMail}";
      };
      "${pasteSubdomain}.${domain}" = {
        email = "${acmeMail}";
      };
      "${nextcloudSubdomain}.${domain}" = {
        email = "${acmeMail}";
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "nextcloud"
    ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  sops.secrets."juniper/nextcloud/adminPass" = {
    owner = "nextcloud";
  };
  services.nextcloud = {
    enable = true;
    hostName = "${nextcloudSubdomain}.${domain}";
    package = pkgs.nextcloud30;
    configureRedis = true;
    maxUploadSize = "16G";
    https = true;
    home = "/raid/crypt/appdata/nextcloud";
    settings = {
      overwriteprotocol = "https";
    };
    config = {
      adminuser = "${nextcloudAdmin}";
      adminpassFile = config.sops.secrets."juniper/nextcloud/adminPass".path;
      dbtype = "pgsql";
      dbhost = "/run/postgresql";
    };
  };

  sops.secrets."juniper/vaultwarden" = { };
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/raid/crypt/appdata/vaultwarden";
    config = {
      ROCKET_PORT = vaultwardenPort;
    };
    environmentFile = config.sops.secrets."juniper/vaultwarden".path;
  };

  services.glance = {
    enable = true;
    settings.server.port = 8080;
    settings.pages = [
      {
        columns = [
          {
            size = "full";
            widgets = [
              {
                type = "calendar";
              }
              {
                location = "Bremen, Germany";
                type = "weather";
              }
            ];
          }
          {
            size = "full";
            widgets = [
              {
                channels = [
                  "theprimeagen"
                  "teej_dv"
                  "tsoding"
                  "kanekolumi"
                  "meat"
                ];
                type = "twitch-channels";
              }
            ];
          }
        ];
        name = "Home";
      }
      {
        name = "Homelab";
        columns = [
          {
            title = "Services";
            size = "full";
            widgets = [
              {
                # icons from: https://simpleicons.org
                sites = [
                  {
                    title = "Nextcloud";
                    url = "https://${nextcloudSubdomain}.${domain}";
                    icon = "si:nextcloud";
                  }
                  {
                    title = "Vaultwarden";
                    url = "https://${vaultwardenSubdomain}.${domain}";
                    icon = "si:vaultwarden";
                  }
                  {
                    title = "PrivateBin";
                    url = "https://${pasteSubdomain}.${domain}";
                    icon = "si:pastebin";
                  }
                ];
                type = "monitor";
              }
            ];
          }
        ];
      }
    ];
  };

  services.privatebin = {
    enable = true;
    dataDir = "/raid/crypt/appdata/sharry";
    enableNginx = true;
    virtualHost = "${pasteSubdomain}.${domain}";
  };

  sops.secrets."juniper/paperless/adminPass" = { };
  services.paperless = {
    enable = true;
    port = 2033;
    dataDir = "/raid/crypt/appdata/paperless/data";
    mediaDir = "/raid/crypt/appdata/paperless/media";
    passwordFile = config.sops.secrets."juniper/paperless/adminPass".path;
    address = "10.42.42.10";
  };

  systemd.services.hd-idle = {
    description = "Spin down idle disks";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # Type = "forking";
      ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a sda -i 900 -a sdb -i 900 -a sdc -i 900 -a sde -i 900 -a sdh -i 900";
    };
  };

  users.users.sterz_n = {
    isNormalUser = true;
    description = "Nils Sterz";
    createHome = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "users"
    ];
    uid = 1000;
    hashedPasswordFile = config.sops.secrets."juniper/userpassword".path;
  };
}
