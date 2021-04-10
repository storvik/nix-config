{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.web.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        nodejs-14_x
        yarn
        nodePackages.prettier
      ];
    };

}
