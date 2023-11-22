{ ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nils = {
    isNormalUser = true;
    description = "Nils Sterz";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };
}
