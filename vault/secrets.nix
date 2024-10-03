let
  juniperSsh =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhi82VXcNEdJocGs1/zr9hGgtrqmUmBuIqAyGnU0aTG root@juniper";
in {
  "initialUserPassword.age".publicKeys = [ juniperSsh ];
  "initialUserPassword2.age".publicKeys = [ juniperSsh ];
}
