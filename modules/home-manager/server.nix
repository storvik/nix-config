{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.server.enable {

    home.packages = with pkgs; [
      nixops
    ];

  };

}
