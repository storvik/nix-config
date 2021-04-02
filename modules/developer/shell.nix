{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.developer.shell.enable = mkEnableOption "Shell developer tools";

  config = mkIf (config.storvik.developer.shell.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        shfmt
      ];
    };

}
