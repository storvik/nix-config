{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.c.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        ccls
        clang-tools
        cmake
        gdb
        protobuf
        ninja
        meson
      ];
    };

}
