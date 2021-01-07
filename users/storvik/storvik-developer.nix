{ config, pkgs, lib, ... }:

{
  imports = [
    ../../home-manager/developer.nix # all developer packages
    ../../home-manager/virtualization.nix # virtualization and container stuff
  ];

}
