{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.media.enable {

    home.packages = with pkgs; [
      spotify
      libsForQt5.vlc
    ];

  };

}
