{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf
    (config.storvik.developer.enable ||
      config.storvik.developer.android.enable ||
      config.storvik.developer.c.enable ||
      config.storvik.developer.go.enable ||
      config.storvik.developer.lisp.enable ||
      config.storvik.developer.nix.enable ||
      config.storvik.developer.python.enable ||
      config.storvik.developer.shell.enable ||
      config.storvik.developer.web.enable)
    {
      home.packages = with pkgs; [
        tree-sitter
      ];
    };

}
