{
  description = "Flake of Nils";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      emacs-overlay,
      agenix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      emacs_dots = ./emacs;

      nextcloudUrl = "TODO";
      nextcloudAdmin = "TODO";
      acmeMail = "TODO";

      nixpkgs-patched = (import nixpkgs { inherit system; }).applyPatches {
        name = "nixpkgs-patched";
        src = nixpkgs;
      };

      pkgs = import nixpkgs-patched {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

    in
    {
      nixpkgs.overlays = [ (import self.inputs.emacs-overlay) ];
      nixosConfigurations = {
        lumi = lib.nixosSystem {
          inherit system;
          modules = [
            ./systems/lumi/configuration.nix
            ./programs/opengl.nix
            ./programs/desktop.nix
            ./programs/essentials.nix
            ./modules/system
          ];
          specialArgs = {
            desktop = "gnome";
            displayManager = "gdm";
            inherit system;
          };
        };
        bao = lib.nixosSystem {
          inherit system;
          modules = [
            ./systems/bao/configuration.nix
            ./programs/essentials.nix
            ./modules/system
          ];
          specialArgs = {
            inherit system;
          };
        };
        juniper = lib.nixosSystem {
          inherit system;
          modules = [
            ./modules/system
            ./systems/juniper
            ./vault
            agenix.nixosModules.default
          ];
          specialArgs = {
            inherit
              system
              inputs
              nextcloudUrl
              nextcloudAdmin
              acmeMail
              ;
            vars = import ./systems/vars.nix;
          };
        };
      };
      homeConfigurations = {
        nils = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles/nils/home.nix")
            ./modules/home
            {
              nixpkgs.overlays = [ emacs-overlay.overlays.default ];
            }
            plasma-manager.homeManagerModules.plasma-manager
          ];
          extraSpecialArgs = {
            inherit emacs_dots;
          };
        };
      };
    };
}
