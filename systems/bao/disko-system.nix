{
	disko.devices = {
		disk = {
			main = {
				device = "/dev/disk/by-id/nvme-eui.001b444a46055c0b";
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
							end = "-16G";
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
		};
	};
}
