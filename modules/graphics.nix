{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.graphics.enable = mkEnableOption "Graphics tools";

  config = mkIf config.storvik.graphics.enable {

    home.packages = with pkgs; [
      freecad
      gimp
      inkscape
    ];

  };

}
