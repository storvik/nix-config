{ config, pkgs, lib, ... }:

let

  pkgsUnstable = import <nixpkgs-unstable> { config.allowUnfree = true; };

in

{

  fonts.fontconfig.enable = true;
 
  home.packages = with pkgsUnstable; [
    fira-code
    fira-code-symbols
  ];
    
}
