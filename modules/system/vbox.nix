{
  lib,
  config,
  ...
}:
{
  options.settings.vbox = with lib; {
    enable = mkEnableOption "Enable VirtualBox";
    users = mkOption {
      type = types.listOf string;
      description = "users to use VirtualBox";
    };
  };

  config =
    let
      cfg = config.settings.vbox;
    in
    lib.mkIf cfg.enable {
      virtualisation.virtualbox.host.enable = true;
      virtualisation.virtualbox.host.enableExtensionPack = true;
      virtualisation.virtualbox.guest.enable = true;
      virtualisation.virtualbox.guest.dragAndDrop = true;
      users.extraGroups.vboxusers.members = cfg.users;
    };
}
