{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/ata-OCZ-AGILITY3_OCZ-278M04GIX384TV4N";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              end = "-16G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            plainSwap = {
              size = "100%";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
          };
        };
      };
      zdisk1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST2000DM008-2FR102_WK30A95M";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "BUG";
              };
            };
          };
        };
      };
      zdisk2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST2000DM008-2UB102_ZFL6LYYY";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "BUG";
              };
            };
          };
        };
      };
      zdisk3 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST2000DM008-2UB102_ZFL6LZBE";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "BUG";
              };
            };
          };
        };
      };
      zdisk4 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST2000DM008-2UB102_ZFL6MPWR";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "BUG";
              };
            };
          };
        };
      };
      zdisk5 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST2000DM008-2UB102_ZK20GN1K";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "BUG";
              };
            };
          };
        };
      };
    };
    zpool = {
      BUG = {
        type = "zpool";
        mode = {
          topology = {
            type = "topology";
            vdev = [
              {
                mode = "raidz2";
                members = [
                  "zdisk1"
                  "zdisk2"
                  "zdisk3"
                  "zdisk4"
                  "zdisk5"
                ];
              }
            ];
          };
        };
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          mountpoint = "none";
        };
        datasets = {
          crypt = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
            };
            postCreateHook = ''
              zfs set keylocation="prompt" "BUG/$name";
            '';
          };
          "crypt/misc" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
          };
          "crypt/appdata" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "false";
          };
          "crypt/appdata/jellyfin" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
          "crypt/appdata/vaultwarden" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
          "crypt/appdata/paperless" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
          "crypt/appdata/privatebin" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
          "crypt/appdata/nextcloud" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
          "crypt/appdata/navidrome" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}
