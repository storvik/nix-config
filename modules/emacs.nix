{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.emacs.enable = mkOption {
    default = true;
    description = "Enable emacs, enabled by default";
    type = lib.types.bool;
  };

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
