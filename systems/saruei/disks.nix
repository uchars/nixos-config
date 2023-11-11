{ ... }: {
  fileSystems."/mnt/adisk" = {
    device = "/dev/disk/by-uuid/0179b11a-3fe5-4922-bd73-0db4c05475f3";
    fsType = "ext4";
  };

  fileSystems."/mnt/bdisk" = {
    device = "/dev/disk/by-uuid/0a294042-a6d1-4f94-8a04-9b8f4d9d0920";
    fsType = "ext4";
  };
}
