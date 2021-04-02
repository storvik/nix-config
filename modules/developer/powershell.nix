{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.developer.powershell.enable = mkEnableOption "Powershell developer tools";

  config = mkIf (config.storvik.developer.powershell.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        powershell
      ];
    };

}
