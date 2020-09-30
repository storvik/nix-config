{ config, pkgs, lib, ... }:

{

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  home.packages = with pkgs; [
    emacsUnstable
  ];

}
