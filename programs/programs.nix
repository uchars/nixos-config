{ pkgs, ... }: {
  services.syncthing = {
    enable = true;
    user = "nils";
    dataDir = "/mnt/bdisk/sync";
    configDir = "/mnt/bdisk/sync/.config/syncthing";
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
        path = "/home/nils/Documents";
        devices = [ "laptop" "iPhoneNils" ];
      };
      "Wallpapers" = {
        path = "/home/nils/Pictures/wallpapers";
        devices = [ "laptop" ];
      };
    };
  };
}
