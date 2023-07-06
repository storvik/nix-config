{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.emacs.enable {

    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
    };

    home.sessionVariables = {
      EDITOR = "emacs";
    };

    services.emacs.enable = config.storvik.emacs.daemon;

    home.packages = with pkgs; [
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science nb ]))
      graphviz
      multimarkdown
      plantuml
      ripgrep
    ];

  };

}
