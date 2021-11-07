{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.social.enable {

    home.packages = with pkgs; [
      signal-desktop
    ];

  };

}
