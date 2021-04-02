{ config, pkgs, lib, ... }:

with lib;

{
  options.storvik.developer.c.enable = mkEnableOption "C tools";

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
