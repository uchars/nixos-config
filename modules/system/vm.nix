{ lib, pkgs, config, ... }: {
  options.elira.vm = with lib; {
    enable = mkEnableOption "Enable Type 1 Hypervisor";
    # TODO: Support adding multiple users to libvirtd group
    user = mkOption {
      type = with types; listOf str;
      description = "user to enable vm stuff";
    };
  };

  config = let cfg = config.elira.vm;
  in lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ barrier virt-manager ];
    virtualisation.libvirtd.enable = true;
    hardware.opengl.enable = true;
    users.users.${cfg.user}.extraGroups = [ "libvirtd" ];
  };
}
