{
  description = "Flake of Nils";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
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

      nixpkgs-patched = (import nixpkgs { inherit system; }).applyPatches {
        name = "nixpkgs-patched";
        src = nixpkgs;
      };

      pkgs = import nixpkgs-patched {
        inherit system;
        config = { allowUnfree = true; };
      };

    in {
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
            plasma-manager.homeManagerModules.plasma-manager
          ];
        };
      };
    };
}
