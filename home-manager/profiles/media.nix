{ config, pkgs, lib, ... }:

let

  pkgsUnstable = import <nixpkgs-unstable> { config.allowUnfree = true; };

in

{
  
  home.packages = with pkgsUnstable; [
    spotify
    libsForQt5.vlc
  ];
    
}
