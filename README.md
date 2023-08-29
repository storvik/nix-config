# nix config

My NixOS configuration using nix flakes.

## Structure

```
│
├── flake.nix                                - flake
│
├── docs/                                    - documentation for modules
│
├── flake/                                   - helper stuff, mkSystem etc
│
├── hosts/                                   - host configurations
│   │
│   ├── storvik-live/                        - custom live usb config
│   │
│   ├── storvik-nixos-matebook/              - main laptop, huawei matebook with nixos
│   │
│   ├── storvik-nixos-nuc/                   - home server, nuc i3
│   │
│   └── storvik-nixos-wsl/                   - work computer running windows with nixos-wsl
│       │
│       ├── home.nix                         - home-manager configurations
│       │
│       └── nixos.nix                        - nixos configurations
│
├── modules/                                 - custom modules which turns on / off settings
│   │
│   ├── hm-module.nix                        - home-manager modules entrypoint
│   │
│   ├── module.nix                           - nixos modules entrypoint
│   │
│   ├── hm-module/                           - home-manager modules
│   │
│   └── nixos/                               - nixos modules
│
├── machines/                                - hardware dependant config for different machines
│   │
│   ├── intel-nuc                            - Intel NUC
│   │
│   ├── live                                 - Live ISO
│   │
│   └── matebook                             - Huawei Matebook Pro
│
├── overlays/                                - overlays
│
└── pkgs/                                    - custom packages
```

Modules are divided into home-manager and nixos modules.
All module options can be seen in `modules/hm-module/options.nix` and `modules/nixos/options.nix`.
Each should contain `home.nix` and / or `nixos.nix`, which should define host configuration.

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
