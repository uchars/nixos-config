{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        #device = "%DATA_DISK_0%";
        device = "/dev/disk/by-id/ata-ST2000DM008-2UB102_ZFL6LYYY";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/esp";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "bpool";
              };
            };
          };
        };
      };
      sdb = {
        type = "disk";
        #device = "%DATA_DISK_1%";
        device = "/dev/disk/by-id/ata-ST2000DM008-2UB102_ZFL6LZBE";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
      sdc = {
        type = "disk";
        #device = "%DATA_DISK_2%";
        device = "/dev/disk/by-id/ata-ST2000DM008-2UB102_ZFL6MPWR";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
      sdd = {
        type = "disk";
        #device = "%DATA_DISK_2%";
        device = "/dev/disk/by-id/ata-ST2000DM008-2UB102_ZK20GN1K";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };
    zpool = {
      bpool = {
        type = "zpool";
        options = {
          ashift = "12";
          autotrim = "on";
          compatibility = "grub2";
        };
        rootFsOptions = {
          acltype = "posixacl";
          canmount = "off";
          compression = "lz4";
          devices = "off";
          normalization = "formD";
          relatime = "on";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/boot";
        datasets = {
          nixos = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "nixos/root" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/boot";
          };
        };
      };
      rpool = {
        type = "zpool";
        mode = "raidz2";
        options = {
          autotrim = "on";
          ashift = "12";
        };
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };

        datasets = {
          nixos = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "nixos/var" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "nixos/empty" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = "zfs snapshot rpool/nixos/empty@start";
          };
          "nixos/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
          };
          "nixos/var/log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options.mountpoint = "legacy";
          };
          "nixos/var/lib" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
          };
          "nixos/config" = {
            type = "zfs_fs";
            mountpoint = "/etc/nixos";
            options.mountpoint = "legacy";
          };
          "nixos/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
          };
          "nixos/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
          docker = {
            type = "zfs_volume";
            size = "50G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var/lib/containers";
            };
          };
        };
      };
    };
  };
}
