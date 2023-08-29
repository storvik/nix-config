{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.media) {
    home.packages = with pkgs; [
      calibre
      geeqie
      handbrake
      spotify
      vlc
    ];
  };

}
