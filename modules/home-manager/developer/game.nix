{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.game.enable || config.storvik.developer.enable)
    {

      home.packages = with pkgs; [
        godot
        godot-export-templates
      ];

    };

}
