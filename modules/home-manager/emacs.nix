{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.emacs.enable {

    programs.emacs = {
      enable = true;
      package = if config.storvik.wsl.enable then pkgs.emacsNativeComp else pkgs.emacsPgtkNativeComp;
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
