{ config, pkgs, lib, ... }:

{

  imports = [
    ../../home-manager/profiles/emacs.nix # emacs
  ];

  home.username = "kali";
  home.homeDirectory = "/home/kali";

  programs.git = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = { };
    shellInit = ''
      # Supress greeting
      set fish_greeting

      # Custom title
      function fish_title
          basename (pwd)
      end
    '';
  };

  home.sessionVariables = {
    EDITOR = "emacs";
  };

}
