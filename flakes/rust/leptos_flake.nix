{
  description = "A basic Rust devshell for NixOS users developing Leptos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
      in with pkgs; {
        devShells.default = mkShell {
          buildInputs = [
            openssl
            pkg-config
            cacert
            cargo-make
            trunk
            tailwindcss
            (rust-bin.selectLatestNightlyWith (toolchain:
              toolchain.default.override {
                extensions = [ "rust-src" "rust-analyzer" ];
                targets = [ "wasm32-unknown-unknown" ];
              }))
          ];

          shellHook = "";
        };
      });
}
