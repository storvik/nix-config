{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf cfg.enableWSL {
    home.sessionVariables = {
      WSL = "1";
    };
  };

}
