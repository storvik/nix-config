{ config, pkgs, lib, ... }:

{

  imports = [
    ./storvik-base.nix
    ./storvik-developer.nix
    ./storvik-email.nix
    ./storvik-gui.nix

    ../../home-manager/avanti.nix
    ../../home-manager/tools-shell.nix
  ];

  # Get all documentations too
  home.extraOutputsToInstall = [ "doc" ];

}
