{ config, pkgs, lib, ... }:

with lib;

let

  nixpkgsEmacs = import <nixpkgs>
    {
      overlays = [
        (import (builtins.fetchTarball {
          url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
        }))
      ];
    };

in

{

  config = mkIf config.storvik.emacs.enable {

    home.packages =
      if config.storvik.emacs.nativeComp then [
        nixpkgsEmacs.emacsGcc
      ] else [
        pkgs.emacs
      ];

    home.sessionVariables = {
      EDITOR = "emacs";
    };

    services.emacs.enable = config.storvik.emacs.daemon;

  };

}
