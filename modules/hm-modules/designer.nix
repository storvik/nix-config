{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.designer) {
    home.packages = with pkgs; [
      gimp
      inkscape
    ];
  };

}
