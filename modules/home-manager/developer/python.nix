{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.python.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        python38
        python38Packages.pip
        nodePackages.pyright
      ];
    };

}
