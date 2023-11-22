{
  description = "Flake of Nils";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, agenix, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      desktop = "gnome";
      displayManager = "gdm";
      profile = "work";
      syncthingUser = "nils";
      syncthingDir = "/home/${syncthingUser}";
      networkInterface = "enp42s0";
      # use scripts/iommugroups.sh & look for the graphics card (graphics and audio)
      # NOTE: the card needs to be in its own group (i.e. no other PCI bridges and such)
      #  if this is not the case, plug the card into another PCIE slot.
      gpuIDs = [
        "10de:1c82" # Graphics
        "10de:0fb9" # Audio
      ];
      iommu = "amd_iommu"; # intel_iommu

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
            agenix.nixosModules.default
            ./programs/vfio.nix
            ./programs/syncthing.nix
            ./programs/desktop.nix
            ./programs/nvidia.nix
            ./programs/wake_on_lan.nix
            ./programs/users.nix
            ./programs/essentials.nix
          ];
          specialArgs = {
            inherit desktop;
            inherit displayManager;
            inherit system;
            inherit agenix;
            inherit gpuIDs;
            inherit iommu;
            inherit syncthingUser;
            inherit syncthingDir;
            inherit networkInterface;
          };
        };
        juniper = lib.nixosSystem {
        inherit system;
        modules = [
          ./systems/juniper/configuration.nix
          ./programs/users.nix
          ./programs/essentials.nix
          ./programs/desktop.nix
        ];
        specialArgs = {
          inherit agenix;
          inherit desktop;
          inherit displayManager;
          inherit system;
        };
      };
      };
      homeConfigurations = {
        nils = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ (./. + "/profiles" + ("/" + profile) + "/home.nix") ];
        };
      };
    };
}
