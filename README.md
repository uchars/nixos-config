# Full Install

1. Install NixOS-minimal
2. nix-shell -p git
3. git clone https://github.com/uchars/nixos-config.git /tmp/nixos
4. cd /tmp/nixos
5. sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko systems/juniper/disko-config.nix
6. sudo nixos-generate-config --root /mnt
   cp the hardware-configuration.nix into systems/juniper/hardware-configuration.nix
   update the /dev/device/by-uuid to the /dev/device/by-id 
7. sudo nixos-install --flake .#juniper
8. reboot

If the pool is not imported run the following command 
```
zpool import POOL_NAME -f
```
reboot 

# User Install

User install can be used on any system which can install the nix package manager.
I.e.: ubuntu, fedora, etc.

1. ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
   ```
2. ```bash
   nix-channel --update
   ```
   > Might have to log out before the next step
3. ```bash
   nix-shell '<home-manager>' -A install
   ```
4. ```bash
   home-manager switch --flake .
   ```
