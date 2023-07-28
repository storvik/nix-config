{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.python.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        python311
        python311Packages.pip
        nodePackages.pyright
      ];
    };

}
