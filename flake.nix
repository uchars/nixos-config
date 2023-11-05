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
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let 
    lib = nixpkgs.lib;
    system = "x86_64-linux";

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
        modules = [ ./configuration.nix ];
      };
    };
    homeConfigurations = {
      nils = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules =  [ ./home.nix ];
      };
    };
  };
}
