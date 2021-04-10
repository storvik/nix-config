{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.genericLinux.enable != true) {

    programs.firefox = {
      enable = lib.mkDefault false;
    };

  };

}
