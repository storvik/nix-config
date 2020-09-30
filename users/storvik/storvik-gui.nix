{ config, pkgs, lib, ... }:

{

  imports = [
    ../../home-manager/profiles/browser.nix
    ../../home-manager/profiles/fonts.nix
    ../../home-manager/profiles/graphics.nix
    ../../home-manager/profiles/media.nix
    ../../home-manager/profiles/tools-ui.nix
  ];

  # Only enable firefox on non nixos systems
  programs.firefox = lib.mkIf (config.targets.genericLinux.enable != true) {
    enable = true;
  };

}
