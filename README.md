# nix config

My nix config.

# Structure

```
├── configs/                                 - configurations combining machine, role, user and profiles
|   |
|   ├── storvik-ubuntu-matebook.nix          - my Ubuntu based laptop for work
|   |
|   └── storvik-gnome-laptop-matebook.nix    - NOT USED, meant to be matebook with NixOS
|
├── desktops/                                - desktop enviroments(gnome, kde, etc) and settings related to this
|   |
|   ├── gnome-nixos                          - gnome 3 nixos
|   |
|   ├── gnome-ubuntu                         - gnome 3 ubuntu, not NixOS
|   |
|   └── kde-nixos                            - kde nixos
│
├── home-manager/                            - home-manager profiles / config collections
│
├── machines/                                - different configs for different physical machines, hardware dependant
|   |
|   └── matebook                             - Huawei Matebook Pro
|
├── overlays/                                - overlays
|
├── pkgs/                                    - custom packages
|
└── users/                                   - config related to user, git config, home manager, etc
    |
    └── storvik/
        |
        ├── storvik-nixos.nix                - storvik user nixos config
        |
        ├── storvik-base.nix                 - my main user base tools
        |
        └── storvik-full.nix                 - my main user with all tools
```

# Install

## Non NixOS computer

When not on NixOS home-manager is used to install packages user level and store configurations.
Typically a config file combines _machine_, _role_ and _user_.
But when using Nix package manager only the _machine_ and _role_ is usually not needed.
Should also work in WSL2.

*Install nix on computer:*

``` shell
sudo apt install curl
curl -L https://nixos.org/nix/install | sh
```

_Nix unstable channel should be added_

``` shell
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
nix-channel --update
```

*Install [home-manager](https://github.com/nix-community/home-manager):*

``` shell
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

*Symlink config file to be used:*

``` shell
ln -s ~/nix-config/configs/storvik-gnome-ubuntu-matebook.nix ~/.config/nixpkgs/home.nix
```

or source `hm-session-vars.sh` if home-manager shouldn't manage shell.
Add the following to `.profile` / `.zprofile`:

``` shell
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
```

*Backup bash config files if home-manager should manage shell:*

This is done to avoid conflict between home-manager files and already present config files.

``` shell
mkdir old-profile; mv .bashrc .profile old-profile
```

*Make home-manager use current setup:*

``` shell
home-manager switch
```


## NixOS computer

Put this config in /etc/nixos.

``` shell
sudo mv configuration.nix configuration.nix.bak
sudo ln -s /etc/nixos/nix-config/configs/CONFIGNAME /etc/nixos/configuration.nix
```

# Notes

## Using stuff from master branch in nixpkgs

Ensure overlay in `overlays/nixpkgsmaster/` is included and prepend package with `master.`.
For example

``` nix
home.packages = with pkgs; [
  master.packagename
];
```

## Getting applications installed by nix to application menu

Read more about it [here](https://discourse.nixos.org/t/home-manager-installed-apps-dont-show-up-in-applications-launcher/8523/7).
In short, not possible, these are possible workarounds:
- Copy all .desktop files to $HOME/.local/share/applications
- Follow instructions in the link above
