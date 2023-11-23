{
  description = "Flutter Web Development Environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        flutter = pkgs.flutter;
        dart = pkgs.dart;
        chrome = pkgs.google-chrome;
      in {
        devShell = pkgs.mkShell {
          buildInputs = [ flutter dart chrome ];
          shellHook = ''
            export CHROME_EXECUTABLE=${chrome}/bin/google-chrome-stable
          '';
        };
      });
}
