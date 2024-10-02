{
  description = "Flake of Nils";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nixvim.url = "github:uchars/nixvim";
  };
  outputs = { self, nixpkgs, home-manager, plasma-manager, emacs-overlay, nixvim
    , agenix, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      desktop = "gnome";
      displayManager = "gdm";
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
      nixpkgs.overlays =
        [ (import self.inputs.emacs-overlay) nixvim.overlays.default ];
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
            ./modules/system
            ./systems/juniper
            #./vault
            agenix.nixosModules.default
          ];
          specialArgs = {
            inherit system inputs;
            vars = import ./systems/vars.nix;
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
              nixpkgs.overlays =
                [ emacs-overlay.overlays.default nixvim.overlays.default ];
            })
            plasma-manager.homeManagerModules.plasma-manager
          ];
          extraSpecialArgs = { inherit emacs_dots; };
        };
      };
    };
}
