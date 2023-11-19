let
  nils =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACWdIFpaIMKbWZoxHIvFxuUu6zaDhU/FAeylX+bNhy1";
  users = [ nils ];

  saruei =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACWdIFpaIMKbWZoxHIvFxuUu6zaDhU/FAeylX+bNhy1";
  systems = [ saruei ];

  allKeys = users ++ systems;
in {
  "syncthing.deviceid.laptop.age".publicKeys = allKeys;
  "syncthing.deviceid.iphoneNils.age".publicKeys = allKeys;
}
