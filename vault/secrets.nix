let
  juniperSsh =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtnEN6D2bB10YnLqIpIXoVI6H7e6/atvLkLDW9j4ja+ root@nixos";
in {
  "initialUserPassword.age".publicKeys = [ juniperSsh ];
}
