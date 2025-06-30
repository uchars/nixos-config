{
	disko.devices = {
		disk = {
			main = {
				device = "/dev/disk/by-id/nvme-SAMSUNG_MZALQ512HALU-000L2_S4UKNF1N905271";
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
			data = {
				device = "/dev/disk/by-id/mmc-SD512_0xc601bb3c";
				type = "disk";
				content = {
					type = "gpt";
					partitions = {
						games = {
							size = "100%";
							content = {
								type = "filesystem";
								format = "ext4";
								mountpoint = "/media/data";
							};
						};
					};
				};
			};
		};
	};
}

