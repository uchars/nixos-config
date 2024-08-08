let
  juniperSsh =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzJjYL9UMYW2kSOQux73vr0q4JaaDgM+MdOOk0+rjqL 40796807+uchars@users.noreply.github.com";
in {
  "smbPassword.age".publicKeys = [ juniperSsh ];
  "initialUserPassword.age".publicKeys = [ juniperSsh ];

  # age.secrets.smbPassword = {
  #   file = ./smbPassword.age;
  #   path = "/etc/smbPassword";
  # };

  # age.secrets.userPassword = {
  #   file = ./userPassword.age;
  #   path = "/etc/userPassword";
  # };
}
