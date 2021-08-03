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
    ../modules/home-manager
  ];

  # Enable storvik user
  storvik.user.storvik.enable = true;

  # Generic linux if running on non nixos
  storvik.genericLinux.enable = true;

  # Enable email
  storvik.email.enable = true;

  # Enable all developer tools
  storvik.developer.enable = true;

  # Use Emacs with the native compile
  storvik.emacs.nativeComp = true;

  # Enable Emacs daemon
  storvik.emacs.daemon = true;

  # Texlive
  storvik.texlive.enable = true;

  # Graphics tools
  storvik.graphics.enable = true;

  # pCloud sync script using rclone
  storvik.rclonesync.enable = true;

  # Set folders to sync
  storvik.rclonesync.syncdirs = [
    {
      remote = "pcloud";
      source = "/home/storvik/svartisenfestivalen/";
      dest = "svartisenfestivalen/";
    }
    {
      remote = "pcloud";
      source = "/home/storvik/developer/org/";
      dest = "org/";
    }
  ];

  # Empty home.packages, useful when testing stuff
  home.packages = with pkgs; [
    # Add something here
  ];

  home.stateVersion = "21.03";

}
