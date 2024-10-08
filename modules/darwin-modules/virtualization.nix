{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (!cfg.virtualization) {

    environment.systemPackages = [
      pkgs.utm
    ];

  };

}
