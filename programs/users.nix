{ config, ... }: {
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  users.users.sterz_n = {
    isNormalUser = true;
    description = "Nils Sterz";
    extraGroups = [ "networkmanager" "wheel" "video" "users" ];
    hashedPasswordFile = config.age.secrets.initialUserPassword.path;
    #group = "nils";
    uid = 1000;
  };
  users.groups.nils.gid = 1000;
}
