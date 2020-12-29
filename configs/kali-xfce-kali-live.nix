{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This makes home-manager work better with other distros than nixos
  # Also used to differentiate between nixos and non nixos systems
  targets.genericLinux.enable = true;

  # Include overlays
  # nixpkgs.overlays = [
  #   (import ../overlays)
  # ];

  # Import other stuff
  imports = [
    ../users/kali/kali-base.nix
  ];

  # Packages to install
  home.packages = with pkgs; [
    emacs
  ];

  home.stateVersion = "21.03";

}
