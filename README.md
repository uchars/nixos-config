# Full Install

1. Install NixOS
2. Clone this repo
3. Inside the folder run
   ```bash
   sudo nixos-rebuild switch --flake .#SYSTEM_NAME
   ```
4. Continue with [User Install](#user-install)

# User Install

User install can be used on any system which can install the nix package manager.
I.e.: ubuntu, fedora, etc.

1. ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
   ```
2. ```bash
   nix-channel --update
   ```
3. ```bash
   nix-shell '<home-manager>' -A install
   ```
4. ```bash
   home-manager switch --flake .
   ```
