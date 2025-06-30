{
  lib,
  config,
  ...
}:
{
  options.settings.audio = with lib; {
    enable = mkEnableOption "Enable audio and useful options";
  };

  config =
    let
      cfg = config.settings.audio;
    in
    lib.mkIf cfg.enable {
      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
}
