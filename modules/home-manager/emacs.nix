{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.emacs.enable {

    programs.emacs = {
      enable = true;
      package = if config.storvik.emacs.nativeComp then pkgs.emacsGcc else pkgs.emacs;
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
