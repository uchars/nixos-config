{ pkgs, displayManager, ... }: {
  services.xserver.enable = true;

  services.xserver.displayManager.${displayManager}.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
}
