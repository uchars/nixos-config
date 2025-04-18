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
            rustup
            cargo-generate
            ]
          else
            [ ]
        )
        ++ ( [
            clang
            zls
            lua-language-server
            jdt-language-server
            clang-tools
            trunk
            sass
            marksman
            nixfmt-rfc-style
            stylua
            prettierd
            google-java-format
            openssl
            pkg-config
            openssl
            cacert
            cargo-make
            pkg-config
            asm-lsp
            python312Packages.python-lsp-server
        ] )
        ++ (if cfg.android then [ android-studio ] else [ ])
        ++ (
          if cfg.latex then
            [
              pandoc
              texinfo
              texlab
              texliveFull
              texlivePackages.moreverb
            ]
          else
            [ ]
        )
        ++ (if cfg.java then [ jetbrains.idea-community jdt-language-server ] ++ cfg.jdkVersions else [ ]);
    };
}
