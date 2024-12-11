{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.elira.editors = with lib; {
    enable = mkEnableOption "Install Visual Studio Code";

    emacs = {
      config_dir = mkOption {
        type = types.str;
      };
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };

    vscode = mkOption {
      description = "VSCode Editor";
      default = false;
      type = types.bool;
    };
  };

  config =
    let
      cfg = config.elira.editors;
    in
    lib.mkIf cfg.enable {
      home.packages =
        with pkgs;
        (if cfg.vscode then [ vscode ] else [ ])
        ++ (
          if true then
            [
              ripgrep
              imagemagick
              libgccjit
              nodePackages.typescript
              nodePackages.typescript-language-server
              nodePackages.prettier
              clang-tools
              cmake
              nil
              nixpkgs-fmt
              go
              gopls
              godef
              cmake-language-server
              graphviz
            ]
          else
            [ ]
        );

      programs.emacs = {
        enable = cfg.emacs.enable;
        package = pkgs.emacsWithPackagesFromUsePackage {
          config = "${cfg.emacs.config_dir}/init.el";
          package = pkgs.emacs29;
        };
      };
      services.emacs.enable = true;

      home.file.".emacs.d" = {
        source = cfg.emacs.config_dir;
        recursive = true;
      };
    };
}
