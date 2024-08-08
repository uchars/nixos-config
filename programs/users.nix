{ config, ... }: {
  age.identityPaths = [ "/home/nils/.ssh/id_ed25519" ];

  users.users.nils = {
    isNormalUser = true;
    description = "Nils Sterz";
    extraGroups = [ "networkmanager" "wheel" "video" "users" ];
    hashedPasswordFile = config.age.secrets.initialUserPassword.path;
    group = "nils";
    uid = 1000;
  };
  users.groups.nils.gid = 1000;

}
