{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.c.enable || config.storvik.developer.enable)
    {
      home.packages = [
        pkgs.astyle
        pkgs.ccls
        pkgs.cmake
        pkgs.cmake-format
        pkgs.gdb
        pkgs.protobuf
        pkgs.ninja
        pkgs.meson
      ];
    };

}
