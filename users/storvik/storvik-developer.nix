{ config, pkgs, lib, ... }:

{
  imports = [
    ../../home-manager/profiles/developer.nix # all developer packages
    ../../home-manager/profiles/virtualization.nix # virtualization and container stuff
  ];

}
