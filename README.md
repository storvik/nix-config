# nix config

My config for both NixOS and generic linux machines, should work with the unstable branch.

## Structure and options

```
├── configs/                                 - configurations combining machine, role, user and profiles
|   |
|   └── storvik-gnome-ubuntu-matebook.nix    - my Ubuntu based laptop for work
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
|   └── matebook                             - Huawei Matebook Pro
|
├── overlays/                                - overlays
|
└── pkgs/                                    - custom packages
```

Modules are divided into home-manager and nixos modules.
For up to date examples of config for both home-manager and nixos look at `configs/storvik-gnome-ubuntu-matebook.nix` and `config/storvik-gnome-nixos-nuc.nix`.
All module options can be seen in `modules/default.nix`.

## Install

### Non NixOS computer ([home-manager](https://github.com/nix-community/home-manager))

When not on NixOS home-manager is used to install packages user level and store configurations.

1. Install Nix on computer, [nix manual](https://nixos.org/manual/nix/stable/)
2. Add nixpgks unstable channel
3. Install [home-manager](https://github.com/nix-community/home-manager)
4. Symlink `~/.config/nixpkgs/home.nix` to config file.
5. Backup conflicting files (`.bashrc`, `.profile`)
6. Run `home-manager switch`

### NixOS computer

1. Install NixOS, [nixos manual](https://nixos.org/manual/nixos/stable/)
2. Switch to unstable channel
3. Install [home-manager](https://github.com/nix-community/home-manager)
4. Symlink `/etc/nixos/configuration.nix` to config file
5. Run `sudo nixos-rebuild build` followed by `switch` if everything went ok

### Cachix

If using emacs overlay (emacs native compile) cachix may save you for a lot of compile time.
Read more about it [here](https://app.cachix.org/cache/nix-community).
Run the following commands to install and setup cachix:

``` shell
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use nix-community
```
