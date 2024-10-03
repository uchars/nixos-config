{
  disko.devices = {
    disk = {
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
	};
	mountpoint = "/raid";
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
	    mountpoint = "/raid/crypt/misc";
	  };
	  "crypt/misc/iso" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/misc/iso";
	  };
	  "crypt/appdata" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/appdata";
	    options."com.sun:auto-snapshot" = "false";
	  };
	  "crypt/appdata/paperless" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/appdata/paperless";
	    options."com.sun:auto-snapshot" = "true";
	  };
	  "crypt/appdata/jellyfin" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/appdata/jellyfin";
	    options."com.sun:auto-snapshot" = "true";
	  };
	  "crypt/appdata/immich" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/appdata/immich";
	    options."com.sun:auto-snapshot" = "true";
	  };
	  "crypt/appdata/vaultwarden" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/appdata/vaultwarden";
	    options."com.sun:auto-snapshot" = "true";
	  };
	  "crypt/appdata/netboot" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/appdata/netboot";
	    options."com.sun:auto-snapshot" = "true";
	  };
	  "crypt/media" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/media";
	    options."com.sun:auto-snapshot" = "false";
	  };
	  "crypt/media/vods" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/media/vods";
	    options."com.sun:auto-snapshot" = "true";
	  };
	  "crypt/media/movies" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/media/movies";
	    options."com.sun:auto-snapshot" = "true";
	  };
	  "crypt/media/pictures" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/media/pictures";
	    options."com.sun:auto-snapshot" = "true";
	  };
	  "crypt/media/wallpapers" = {
	    type = "zfs_fs";
	    mountpoint = "/raid/crypt/media/wallpapers";
	    options."com.sun:auto-snapshot" = "true";
	  };
	};
      };
    };
  };
}
