{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.shell.enable {
    programs.fish.enable = true;
  };

}
