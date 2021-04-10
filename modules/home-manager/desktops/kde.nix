{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.kde.enable { };

}
