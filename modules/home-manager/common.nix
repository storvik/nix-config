{ config, pkgs, lib, ... }:

with lib;

{

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Get all documentations too
  home.extraOutputsToInstall = [ "doc" "man" ];

  home.stateVersion = "22.11";

  # Custom fonts
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    fira-code
    fira-code-symbols
    iosevka
  ];
}
