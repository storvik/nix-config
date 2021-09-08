{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.graphics.enable {

    home.packages = with pkgs; [
      freecad
      gimp
      graphviz
      inkscape
      plantuml
    ];

  };

}
