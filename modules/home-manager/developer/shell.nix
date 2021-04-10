{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.shell.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        shfmt
      ];
    };

}
