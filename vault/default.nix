{ ... }: {
  age.secrets.smbPassword = { file = ./smbPassword.age; };

  age.secrets.initialUserPassword = { file = ./initialUserPassword.age; };
}
