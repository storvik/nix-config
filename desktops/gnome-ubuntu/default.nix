{ config, pkgs, lib, ... }:

let

  pkgsUnstable = import <nixpkgs-unstable> { config.allowUnfree = true; };

in

{

  dconf.settings = {
    "org.gnome.desktop.input-sources" = {
      xkb-options = [ "caps:ctrl_modifier" ];
    };
  };

  #home.packages = with pkgsUnstable; [
  #gnomeExtensions.gsconnect
  #gnomeExtensions.
  #];

  
}
