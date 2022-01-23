{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.work.enable {

    home.packages = with pkgs; [
      cloudcompare
      remmina
      slack
      teams
    ];

  };

}
