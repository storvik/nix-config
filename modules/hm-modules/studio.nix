{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.studio) {
    home.packages = with pkgs; [
      audacity
      shotcut
    ];
  };

}
