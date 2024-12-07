{
	disko.devices = {
		disk = {
			main = {
				device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4EWNX0W489720D";
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
						luks = {
							end = "-32G";
							content = {
								type = "luks";
								name = "crypted";
								settings.allowDiscards = true;
								content = {
									type = "filesystem";
									format = "ext4";
									mountpoint = "/";
								};
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
			game = {
				device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_250GB_S3YJNB0K409151L";
				type = "disk";
				content = {
					type = "gpt";
					partitions = {
						games = {
							size = "100%";
							content = {
								type = "filesystem";
								format = "ext4";
								mountpoint = "/media/games";
							};
						};
					};
				};
			};
		};
	};
}

