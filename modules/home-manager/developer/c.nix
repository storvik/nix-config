{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.c.enable || config.storvik.developer.enable)
    {
      home.packages = [
        pkgs.astyle
        pkgs.ccls
        pkgs.clang-tools
        pkgs.cmake
        pkgs.gdb
        pkgs.protobuf
        pkgs.ninja
        pkgs.meson
        pkgs.rr
      ];
    };

}
