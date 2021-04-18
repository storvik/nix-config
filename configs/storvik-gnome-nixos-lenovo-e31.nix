{ config, pkgs, lib, ... }:

let

  cfg = {

    # Enable storvik user
    user.storvik.enable = true;

    # Use gnome desktop
    gnome.enable = true;

    # Enable some developer tools
    developer.c.enable = true;
    developer.go.enable = true;
    developer.nix.enable = true;

    # Texlive
    texlive.enable = false;

    # Graphics tools
    graphics.enable = false;

    # Media
    media.enable = false;

    # Virtualization
    virtualization.enable = true;

  };

in

{
  imports = [
    <home-manager/nixos>
    ../machines/lenovo-e31
    ../modules
    ../modules/nixos
  ];

  networking.hostName = "storvik-nixos-lenovo";

  # Must allow unfree licence for android studio
  nixpkgs.config.allowUnfree = true;

  # Allow broken packages, used with care
  nixpkgs.config.allowBroken = true;

  # Include overlays
  nixpkgs.overlays = [
    (import ../overlays)
  ];

  storvik = cfg;
  home-manager.users.storvik = { config, pkgs, ... }: {
    imports = [
      ../modules
      ../modules/home-manager
    ];
    storvik = cfg;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
