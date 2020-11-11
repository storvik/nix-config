{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Must allow unfree licence for android studio
  nixpkgs.config.allowUnfree = true;

  # Allow broken packages, used with care
  nixpkgs.config.allowBroken = true;

  # This makes home-manager work better with other distros than nixos
  # Also used to differentiate between nixos and non nixos systems
  targets.genericLinux.enable = true;

  # Include overlays
  nixpkgs.overlays = [
    (import ../overlays)
  ];


  # How to allow broken for master?
  # nixpkgs.config.master.config.allowBroken = true;

  # Import other stuff
  imports = [
    ../users/storvik/storvik-base.nix
    ../users/storvik/storvik-developer.nix
    ../users/storvik/storvik-email.nix
    ../desktops/gnome-ubuntu/default.nix

    ../home-manager/profiles/tools-shell.nix
  ];

  # Empty home.packages, useful when testing stuff
  home.packages = with pkgs; [
    # Add something here
  ];

}
