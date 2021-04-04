{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.media.enable = mkEnableOption "Media ";

  config = mkIf config.storvik.media.enable {

    home.packages = with pkgs; [
      spotify
      libsForQt5.vlc
    ];

  };

}
