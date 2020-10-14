{ config, pkgs, lib, ... }:

{

  # Not needed as this overlay is present in overlays/overlays.nix
  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #   }))
  # ];

  home.packages = with pkgs; [
    #emacsUnstable
    emacsGcc # emacs native compile
  ];

}
