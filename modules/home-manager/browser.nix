{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.browser.enable {

    home.packages = [
      pkgs.nyxt
    ];

    programs.firefox = mkIf (config.storvik.wsl.enable == false) {
      enable = true;
      package = pkgs.firefox-wayland;
    };

  };

}
