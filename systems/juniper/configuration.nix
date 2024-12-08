{
  pkgs,
  nextcloudSubdomain,
  domain,
  vaultwardenSubdomain,
  vaultwardenEnv,
  vaultwardenPort,
  nextcloudAdmin,
  pasteSubdomain,
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
        443
      ];
      allowedUDPPorts = [
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
    ddns-go
    dashy-ui
    vim
    wget
    git
    ripgrep
  ];

  systemd.services.ddns-go = {
    description = "DDNS-Go Dynamic DNS Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ddns-go}/bin/ddns-go -l :9876";
      Restart = "always";
      RestartSec = 5;
      User = "ddns-go";
      Group = "ddns-go";
      WorkingDirectory = "/var/lib/ddns-go";
    };
  };

  users.groups.ddns-go = { };

  users.users.ddns-go = {
    isSystemUser = true;
    home = "/var/lib/ddns-go";
    group = "ddns-go";
  };

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
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  services.nextcloud = {
    enable = true;
    hostName = "${nextcloudSubdomain}.${domain}";
    package = pkgs.nextcloud30;
    configureRedis = true;
    maxUploadSize = "16G";
    https = true;
    home = "/raid/crypt/appdata/nextcloud/";
    settings = {
      overwriteprotocol = "https";
    };
    config = {
      adminuser = "${nextcloudAdmin}";
      adminpassFile = "/tmp/pass.txt";
      dbtype = "pgsql";
      dbhost = "/run/postgresql";
    };
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/raid/crypt/appdata/vaultwarden";
    config = {
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = vaultwardenPort;
      ADMIN_TOKEN = "";
    };
    environmentFile = vaultwardenEnv;
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
                    url = "https://${nextcloudSubdomain}.${domain}";
                    icon = "si:vaultwarden";
                  }
                  {
                    title = "PrivateBin";
                    url = "https://${pasteSubdomain}.${domain}";
                    icon = "si:pastebin";
                  }
                  {
                    title = "Homeassistant";
                    url = "https://nilsimusmaximus.duckdns.org:8321";
                    icon = "si:homeassistant";
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
