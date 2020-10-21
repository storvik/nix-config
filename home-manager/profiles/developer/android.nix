{ config, pkgs, lib, ... }:
let

  flutterPull = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/cadfab01bd7908322036147c995d1146f5d604bc.tar.gz) { config = config.nixpkgs.config; };

in
{

  home.packages = with pkgs; [
    android-studio
    flutterPull.flutterPackages.stable
    scrcpy
  ];

}
