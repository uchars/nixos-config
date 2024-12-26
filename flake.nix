{
  description = "Flake of Nils";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
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
      sops-nix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      emacs_dots = ./emacs;

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
            ./modules/system/essentials.nix
            ./modules/system
            sops-nix.nixosModules.sops
          ];
          specialArgs = {
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
            sops-nix.nixosModules.sops
          ];
          specialArgs = {
            inherit
              system
              inputs
              ;
            domain = "TODO.xyz";
            nextcloudSubdomain = "TODO";
            nextcloudAdmin = "TODO";
            vaultwardenSubdomain = "TODO";
            vaultwardenPort = "TODO";
            dashboardPort = "TODO";
            pasteSubdomain = "TODO";
            sopsFile = ./vault/vault.yaml;
            sopsKeyFile = "/home/sterz_n/.config/sops/age/keys.txt";
          };
        };
      };
      homeConfigurations = {
        sterz_n = home-manager.lib.homeManagerConfiguration {
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
            username = "sterz_n";
          };
        };
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
            username = "nils";
          };
        };
      };
    };
}
