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

  # Import other stuff
  imports = [
    ../users/storvik/storvik-base.nix
    ../users/storvik/storvik-developer.nix
    ../desktops/gnome-ubuntu/default.nix

    ../home-manager/profiles/tools-shell.nix
  ];

  # Test cloudcompare overlay, not working
  home.packages = with pkgs; [
    #cloudcompare
    #ecl
  ];

}
