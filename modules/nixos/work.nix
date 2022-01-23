{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.work.enable {

    environment.systemPackages = with pkgs; [
      globalprotect-openconnect
      teamviewer
    ];

  };

}
