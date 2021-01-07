{ config, pkgs, lib, ... }:

{

  imports = [
    ../../home-manager/browser.nix
    ../../home-manager/fonts.nix
    ../../home-manager/graphics.nix
    ../../home-manager/media.nix
    ../../home-manager/tools-ui.nix
  ];

  # Only enable firefox on non nixos systems
  programs.firefox = lib.mkIf (config.targets.genericLinux.enable != true) {
    enable = true;
  };

}
