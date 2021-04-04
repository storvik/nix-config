{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.work.enable = mkEnableOption "Work stuff";

  config = mkIf config.storvik.work.enable {

    home.packages = with pkgs; [
      slack
      teams
      teamviewer
    ];

  };

}
