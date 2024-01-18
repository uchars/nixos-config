{ lib, pkgs, config, ... }: {
  options.elira.emacs = with lib; {
    enable = mkEnableOption "Install emacs";
    config_dir = mkOption {
      description = "Configuration directory root for emacs";
      type = types.str;
    };
  };

  config =
    let cfg = config.elira.emacs;
    in lib.mkIf cfg.enable {
      home.packages = with pkgs; [
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
      ];

      programs.emacs = {
        enable = true;
        package = pkgs.emacsWithPackagesFromUsePackage {
          config = "${cfg.config_dir}/init.el";
          package = pkgs.emacs29;
        };
      };
      services.emacs.enable = true;

      home.file.".emacs.d" = {
        source = cfg.config_dir;
        recursive = true;
      };
    };
}
