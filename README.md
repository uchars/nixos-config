# Server Install

## First steps

Install NixOS minimal from https://nixos.org/download/#nixos-iso.
Old releases can be downloaded from https://releases.nixos.org/?prefix=nixos/24.05-small/

After you booted into the OS you can set a password for the `nixos` user, in case you are using ssh.

```sh
passwd nixos
```

Then you can clone this repo using

```sh
nix-shell -p git
```

```sh
git clone https://github.com/uchars/nixos-config.git /tmp/nixos && cd /tmp/nixos
```

Optional: Add a github token to avoid the rate limit error

Settings -> Developer Settings -> Fine-grained tokens (https://github.com/settings/tokens?type=beta)

Only need the public access token.

Create the file `~/.config/nix/nix.conf`

```sh
access-tokens = github.com=<ACCESS-TOKEN>
```

## Creating the RAID

⚠️ This only needs to be done once, it will wipe all data from the selected disks ⚠️.

The raid is set up using [disko](https://github.com/nix-community/disko).

First you should identify the disks you want to use for the RAID.

> It is assumed, that you are using a different disk for the OS installation.

```sh
ls -l /dev/disk/by-id
```

Replace / Add / Remove disks from `/tmp/nixos/systems/juniper/disko-raidz2.nix` to fit your setup.

Once you're finished run

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko systems/juniper/disko-raidz2.nix
```

## Using existing or creating new secrets

> [!WARNING]
> It is recommended to change the password to more complex ones after setting up your services.

### Using existing secrets

0. Update the `sopsKeyFile` location in `flake.nix`
1. Locate your private key `keys.txt`
2. Copy the `keys.txt` to the location defined in `flake.nix`

### Creating new secrets

```bash
nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt
```

Copy the following output after the `&primary` in `.sops.yaml`
```bash
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```

You can use the following template.
```bash
cp vault/vault.example.yaml vault/vault.yaml
```

```bash
EDITOR=vim nix shell nixpkgs#sops -c sops vault/vault.yaml
```

## Setting up the System

If you renamed the pool name you have to change

```nix
boot.zfs.extraPools = [ "BUG" ];
```

To your pool name(s).

Create a `hardware-configuration.nix` for your system using.

```sh
sudo nixos-generate-config --root /mnt
```

```sh
cp /mnt/etc/nixos/hardware-configuration.nix /tmp/nixos/systems/juniper/.
```

Optional: Replace the `/dev/disk/by-uuid` with the `/dev/disk/by-id`.

```
sudo nixos-install --flake .#juniper
```

reboot

If the pool is not imported run the following command

```
zpool import POOL_NAME -f
```

reboot

# User Install

User install can be used on any system which can install the nix package manager.
I.e.: ubuntu, fedora, etc.

1. ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
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
