{ config, lib, pkgs, ... }:

{
  imports = [
    ./installation-device.nix
  ];

  # Disable wireless as my config enables networking.networkmanager
  networking.wireless.enable = false;
}
