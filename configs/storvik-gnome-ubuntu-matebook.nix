# Nix config for Ubuntu

{ config, pkgs, ... }:

{

  # Must allow unfree licence for android studio
  nixpkgs.config.allowUnfree = true;

  # Allow broken packages, used with care
  nixpkgs.config.allowBroken = true;

  # Include overlays
  nixpkgs.overlays = [
    (import ../overlays)
  ];

  # Import modules
  imports = [
    ../modules
  ];

  # Enable storvik user
  storvik.user.storvik.enable = true;

  # Generic linux if running on non nixos
  storvik.genericLinux.enable = true;

  # Enable email
  storvik.email.enable = true;

  # Enable all developer tools
  storvik.developer.enable = true;

  # Texlive
  storvik.texlive.enable = true;

  # Graphics tools
  storvik.graphics.enable = true;

  # Empty home.packages, useful when testing stuff
  home.packages = with pkgs; [
    # Add something here
  ];

  home.stateVersion = "21.03";

}
