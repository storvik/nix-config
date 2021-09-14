{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.browser.enable {

    programs.firefox = {
      enable = true;
    };

    home.packages = with pkgs; [
      vivaldi
      vivaldi-ffmpeg-codecs
    ];

  };

}
