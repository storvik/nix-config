{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.work.enable {

    home.packages = with pkgs; [
      slack
      teams
      teamviewer
    ];

  };

}
