{ config, pkgs, lib, ... }:

with lib;

let

  emacsOverlay = import (fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz) { };

in

{

  config = mkIf config.storvik.emacs.enable {

    home.packages =
      if config.storvik.emacs.nativeComp then [
        emacsOverlay.emacsGcc
      ] else [
        pkgs.emacs
      ];

    home.sessionVariables = {
      EDITOR = "emacs";
    };

  };

}
