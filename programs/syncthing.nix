{ syncthingDir, syncthingUser, ... }: {
  services.syncthing = {
    enable = true;
    user = "${syncthingUser}";
    dataDir = "${syncthingDir}/sync";
    configDir = "${syncthingDir}/sync/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    devices = {
      "laptop" = {
        id = "I4GZSU2-RCVRCDJ-NCBJKXN-3U6CNW4-APT4YJZ-B4BEQ5R-QMZULXI-O66IIAF";
      };
      "iPhoneNils" = {
        id = "NBQRQT6-72YWCPW-7ZN6KBE-CSSNQWV-EUH4M6W-VGHSG6Z-ZZX556R-JMEZQQH";
      };
    };
    folders = {
      "Documents" = {
        path = "/home/${syncthingUser}/Documents";
        devices = [ "laptop" "iPhoneNils" ];
      };
      "Wallpapers" = {
        path = "/home/${syncthingUser}/Pictures/wallpapers";
        devices = [ "laptop" ];
      };
    };
  };
}
