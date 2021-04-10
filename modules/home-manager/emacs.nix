{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.emacs.enable {

    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))
    ];

    home.packages = with pkgs; [
      emacsUnstable
      #emacsGcc # emacs native compile
    ];

    home.sessionVariables = {
      EDITOR = "emacs";
    };

  };

}
