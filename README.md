# nix config

My nix config.

# Structure and options

```
├── configs/                                 - configurations combining machine, role, user and profiles
|   |
|   └── storvik-gnome-ubuntu-matebook.nix    - my Ubuntu based laptop for work
|
├── modules/                                 - all config modules
|   |
|   ├── desktops/                            - desktop configs, gnome, kde, etc
|   |
|   ├── developer/                           - developer tools
|   |
|   └── users/                               - different user settings
│
├── machines/                                - different configs for different physical machines, hardware dependant
|   |
|   ├── intel-nuc                            - Intel NUC
|   |
|   └── matebook                             - Huawei Matebook Pro
|
├── overlays/                                - overlays
|
└── pkgs/                                    - custom packages
```

For an example config file, see `storvik-gnome-ubuntu-matebook.nix`.
Here is a list of useful settings which should be used when configuring the system.

| Option                              | Default | Description                                                            |
|-------------------------------------|---------|------------------------------------------------------------------------|
| storvik.developer.enable            | false   | If true every developer tool are installed                             |
| storvik.developer.android.enable    | false   | Install android tools, apktool, scrcpy                                 |
| storvik.developer.c.enable          | false   | Install C tools, astyle, ccls, cmake, ninja, etc                       |
| storvik.developer.go.enable         | false   | Install Go tools and set up environment, gopls, gotools, etc           |
| storvik.developer.lisp.enable       | false   | Install clpm and SBCL                                                  |
| storvik.developer.nix.enable        | false   | Install nix dev tools, nixpkgs-fmt, nix-prefetch-git                   |
| storvik.developer.powershell.enable | false   | Install powershell                                                     |
| storvik.developer.python.enable     | false   | Install python and pyright language server                             |
| storvik.developer.shell.enable      | false   | Install shfmt                                                          |
| storvik.developer.webdev.enable     | false   | Install node, yarn and prettier formatter                              |
| storvik.emacs.enable                | true    | Install emacs                                                          |
| storvik.email.enable                | false   | Install mu and offlineimap, setting configs                            |
| storvik.genericLinux.enable         | false   | Adds some stuff that is nice to have when using non-nixos, nixGL, etc  |
| storvik.graphics.enable             | false   | Graphics tools, gimp, inkscape, freecad                                |
| storvik.media.enable                | false   | Media, vlc, spotify                                                    |
| storvik.shell.enable                | true    | Install shell tools, setup shell (fish and bash) and install Alacritty |
| storvik.texlive.enable              | false   | Install texlive stuff                                                  |
| storvik.virtualization.enable       | true    | Install docker if running nixos, setup aliases                         |
| storvik.gnome.enable                | false   | Use GNOME                                                              |
| storvik.kde.enabel                  | false   | Use KDE                                                                |
| storvik.users.storvik.enable        | false   | Enable user storvik, setting up git, etc                               |
| storvik.work.enable                 | false   | Work related tools and such, slack, teamviewer, teams                  |

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

## Getting applications installed by nix to application menu

Read more about it [here](https://discourse.nixos.org/t/home-manager-installed-apps-dont-show-up-in-applications-launcher/8523/7).
In short, not possible, these are possible workarounds:
- Copy all .desktop files to $HOME/.local/share/applications
- Follow instructions in the link above
