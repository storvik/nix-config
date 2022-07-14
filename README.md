# nix config

My config for both NixOS and generic linux machines, now using flakes.

## Structure and options

```
|
├── flake.nix                                - flake file
|
├── lib/                                     - helper stuff
|   |
|   ├── mkHome.nix                           - mkHome, helper that makes home-manager config
|   |
|   └── mkSystem.nix                         - mkSystem, helper thtat makes nixos system
|
├── hosts/                                   - host configurations
|
├── modules/                                 - all config modules
|   |
|   ├── default.nix                          - all module options
|   |
|   ├── home-manager/                        - home manager modules
|   |   |
|   |   ├── desktops/                        - desktop configs, gnome, kde, etc
|   |   |
|   |   ├── developer/                       - developer tools
|   |   |
|   |   └── users/                           - different user settings
|   |
|   └── nixos/                               - nixos modules, same directory structure as home manager
│
├── machines/                                - hardware dependant config for different machines
|   |
|   ├── intel-nuc                            - Intel NUC
|   |
|   ├── lenovo-e31                           - Lenovo E31
|   |
|   ├── live                                 - Live ISO
|   |
|   └── matebook                             - Huawei Matebook Pro
|
├── overlays/                                - overlays
|
└── pkgs/                                    - custom packages
```

Modules are divided into home-manager and nixos modules.
All module options can be seen in `modules/default.nix`.

## Install

### Non NixOS computer ([home-manager](https://github.com/nix-community/home-manager))

1. Install Nix on computer, [nix manual](https://nixos.org/manual/nix/stable/)
2. Add nixpgks unstable channel
3. Install unstable nix, `nix-env -iA nixpkgs.nixUnstable`
4. Add `experimental-features = nix-command flakes` to `~/.config/nix/nix.conf`
5. Build config `nix build --impure .#storvik-ubuntu`
6. Backup conflicting files (`.bashrc`, `.profile`)
7. Activate config with `./result/activate`

### NixOS computer

1. Install NixOS, [nixos manual](https://nixos.org/manual/nixos/stable/)
2. Switch to unstable channel
3. Install nix-flakes by importing `./modules/nixos/nixsettings.nix` in `/etc/nixos/configuration.nix`
4. `sudo nixos-rebuild switch --impure --flake .#storvik-nixos-lenovo`


## Create live USB

Build ISO and copy it to USB:

``` shell
nix build .#live-iso
fdisk -l # to figure out path of USB, lsblk could also be used
dd if=result/iso/nixos-*-linux.iso of=/dev/sdb status=progress
```

After setting up disks etc according to the NixOS manual, the system can be installed.

``` shell
nixos-install --flake .#storvik-nixos-lenovo
```

## Using package from pull request

In order to use package from pull request git revision must be found by running:

``` shell
curl -sL https://github.com/NixOS/nixpkgs/pull/{number}.patch | head -n 1 | grep -o -E -e "[0-9a-f]{40}"
```

Then pull request has to be added as input.

``` nix
pr{number}.url = "github:nixos/nixpkgs?rev={rev-from-above-command}";
```

And pull request pkgs must be setup.

``` nix
pr{number}pkgs = import pr{number} {
  inherit system;
};
```

After that the package that is needed can be added to `packageOverrides` in nixpkgs.
This is typically done with:

``` nix
pkgs = import nixpkgs {
  inherit system;
  config = {
    packageOverrides = pkgs: {
      somepackage = pr{number}pkgs.somepackage;
    };
  };
};
```
