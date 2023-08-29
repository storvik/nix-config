{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.social) {
    home.packages = with pkgs; [
      signal-desktop
    ];
  };

}
