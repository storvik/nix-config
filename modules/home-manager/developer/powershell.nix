{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.powershell.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        powershell
      ];
    };

}
