# nix config

My config for both NixOS and generic linux machines, now using flakes.

## Structure and options

```
|
├── flake.nix                                - flake file
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
