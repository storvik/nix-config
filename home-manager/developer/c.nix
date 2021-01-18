{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    astyle
    ccls
    cmake
    gdb
    meson
    ninja
    protobuf
  ];

}
