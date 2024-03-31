{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.cad) {
    home.packages = with pkgs; [
      freecad
      openscad-unstable
      openscad-lsp
    ];
  };

}
