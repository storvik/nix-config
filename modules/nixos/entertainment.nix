{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.entertainment.enable {

    programs.steam.enable = true;

  };

}
