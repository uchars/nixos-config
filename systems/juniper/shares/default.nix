{ config, ... }: {
  services.samba-wsdd.enable = true;

  users = {
    groups.share = { gid = 993; };
    users.share = {
      uid = 994;
      isSystemUser = true;
      group = "share";
    };
  };

  environment.systemPackages = [ config.services.samba.package ];

  users.users.nils.extraGroups = [ "share" ];

  systemd.tmpfiles.rules = [
    "d /mnt/user/pictures 0775 share share - -"
    "d /mnt/user/documents 0775 share share - -"
  ];

  system.activationScripts.samba_user_create = ''
    smb_password=$(cat ${config.age.secrets.smbPassword.path})
    echo -e "$smb_password\n$smb_password\n" | /run/current-system/sw/bin/smbpasswd -a -s share
  '';

  services.samba = {
    enable = true;
    openFirewall = true;
    # invalidUsers = [ "root" ];
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = juniper
      netbios name = juniper
      security = user
      hosts allow = 10.42.42.0/24 localhost
      guest account = nobody
      map to guest = bad user
      passdb backend = tdbsam
    '';
    shares = {
      pictures = {
        path = "/mnt/user/pictures";
        public = "yes";
        browseable = "yes";
        "guest ok" = "no";
        writable = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nils";
        "force group" = "share";
      };
      documents = {
        path = "/mnt/user/documents";
        public = "yes";
        browseable = "yes";
        "guest ok" = "no";
        writable = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nils";
        "force group" = "share";
      };
    };
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
        <name replace-wildcards="yes">%h</name>
        <service>
        <type>_smb._tcp</type>
        <port>445</port>
        </service>
        </service-group>
      '';
    };
  };
}
