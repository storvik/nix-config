{ config, pkgs, lib, ... }:

{

  imports = [
    ./developer/android.nix
    ./developer/c.nix
    ./developer/golang.nix
    ./developer/lisp.nix
    ./developer/nix.nix
    ./developer/python.nix
    ./developer/powershell.nix
    ./developer/webdev.nix
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

}
