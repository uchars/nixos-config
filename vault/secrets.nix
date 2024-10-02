let
  juniperSsh =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQ3PKo+oPzJjykRVSg8O5PYV3zlmsswKQOV7hF0R9hE 40796807+uchars@users.noreply.github.com";
in {
  "initialUserPassword.age".publicKeys = [ juniperSsh ];
}
