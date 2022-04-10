{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.media.enable {

    home.packages = with pkgs; [
      calibre
      geeqie
      spotify
      vlc
    ];

  };

}
