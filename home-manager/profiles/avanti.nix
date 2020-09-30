{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    slack
    teams
    teamviewer
  ];

}
