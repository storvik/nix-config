{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.browser.enable {

    home.packages = [
      pkgs.firefox-wayland
    ];

    # programs.firefox = {
    #   enable = true;
    #   package = pkgs.firefox-wayland;
    # };

  };

}
