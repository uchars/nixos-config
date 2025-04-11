{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.elira.programming = with lib; {
    enable = mkEnableOption "Programming";
    rust = mkOption {
      description = "Rust development";
      default = false;
      type = types.bool;
    };
    android = mkOption {
      description = "Android development";
      default = false;
      type = types.bool;
    };
    latex = mkOption {
      description = "LaTeX development";
      default = false;
      type = types.bool;
    };
    java = mkOption {
      description = "Java development";
      default = false;
      type = types.bool;
    };
    jdkVersions = mkOption { description = "Jdk versions to install."; };
  };

  config =
    let
      cfg = config.elira.programming;
    in
    lib.mkIf cfg.enable {
      home.packages =
        with pkgs;
        (
          if cfg.rust then
            [
              clang
              rustup
              cargo-generate
              trunk
              sass
              openssl
              pkg-config
            ]
          else
            [ ]
        )
        ++ (if cfg.android then [ android-studio ] else [ ])
        ++ (
          if cfg.latex then
            [
              pandoc
              texinfo
              texliveFull
              texlivePackages.moreverb
            ]
          else
            [ ]
        )
        ++ (if cfg.java then [ jetbrains.idea-community jdt-language-server ] ++ cfg.jdkVersions else [ ]);
    };
}
