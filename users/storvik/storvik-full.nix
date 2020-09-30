{ config, pkgs, lib, ... }:

{

  imports = [
    ./storvik-base.nix
    ./storvik-developer.nix
    ./storvik-email.nix
    ./storvik-gui.nix

    ../../home-manager/profiles/avanti.nix
    ../../home-manager/profiles/tools-shell.nix
  ];

  # Get all documentations too
  home.extraOutputsToInstall = [ "doc" ];

}
