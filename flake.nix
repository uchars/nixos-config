{
  description = "Flake of Nils";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
  outputs = { self, nixpkgs, home-manager, plasma-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      desktop = "plasma5";
      displayManager = "sddm";
      profile = "work";
      networkInterface = "enp42s0";
      emacs_dots = ./emacs;

      nixpkgs-patched = (import nixpkgs { inherit system; }).applyPatches {
        name = "nixpkgs-patched";
        src = nixpkgs;
      };

      pkgs = import nixpkgs-patched {
        inherit system;
        config = { allowUnfree = true; };
      };

    in {
      nixpkgs.overlays = [ (import self.inputs.emacs-overlay) ];
      nixosConfigurations = {
        saruei = lib.nixosSystem {
          inherit system;
          modules = [
            ./systems/saruei/configuration.nix
            ./programs/opengl.nix
            ./programs/desktop.nix
            ./programs/users.nix
            ./programs/essentials.nix
            ./modules/system
          ];
          specialArgs = {
            inherit desktop;
            inherit displayManager;
            inherit system;
            inherit networkInterface;
          };
        };
        juniper = lib.nixosSystem {
          inherit system;
          modules = [
            ./systems/juniper/configuration.nix
            ./programs/users.nix
            ./programs/opengl.nix
            ./programs/essentials.nix
            ./programs/desktop.nix
          ];
          specialArgs = {
            inherit desktop;
            inherit displayManager;
            inherit system;
          };
        };
      };
      homeConfigurations = {
        nils = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + profile) + "/home.nix")
            ./modules/home
            ({
              nixpkgs.overlays = [
                (import (builtins.fetchTarball {
                  url =
                    "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
                  sha256 =
                    "1mxq3ba0r099i893a72kmac5ski4hq72zh5ly9xzddws107y9wgm";
                }))

              ];
            })
            plasma-manager.homeManagerModules.plasma-manager
          ];
          extraSpecialArgs = { inherit emacs_dots; };
        };
      };
    };
}
