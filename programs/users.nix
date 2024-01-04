{ ... }: {
  users.users.nils = {
    isNormalUser = true;
    description = "Nils Sterz";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
