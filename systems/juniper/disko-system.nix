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
							end = "-8G";
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
		};
	};
}
