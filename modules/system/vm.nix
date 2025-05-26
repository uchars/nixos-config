{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.settings.vm = with lib; {
    enable = mkEnableOption "Enable Type 1 Hypervisor";
    # TODO: Support adding multiple users to libvirtd group
    user = mkOption {
      type = types.str;
      description = "user to enable vm stuff";
    };
  };

  config =
    let
      cfg = config.settings.vm;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        barrier
        virt-manager
      ];
      virtualisation.libvirtd.enable = true;
      virtualisation.libvirtd.allowedBridges = [
        "virbr0"
        "virbr1"
      ];
      hardware.graphics.enable = true;
      users.users.${cfg.user}.extraGroups = [ "libvirtd" ];
    };
}
