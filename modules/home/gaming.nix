{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.elira.gaming = with lib; {
    enable = mkEnableOption "General Software for Gaming";
    emulation = mkOption {
      description = "Emulation";
      default = false;
      type = types.bool;
    };
  };

  config =
    let
      cfg = config.elira.gaming;
    in
    lib.mkIf cfg.enable {
      home.packages =
        with pkgs;
        [
          discord
          obs-studio
        ]
        ++ (
          if cfg.emulation then
            [
              (retroarch.override {
                cores = with libretro; [
                  genesis-plus-gx
                  snes9x
                  beetle-psx-hw
                  parallel-n64
                ];
              })
            ]
          else
            [ ]
        );
    };
}
