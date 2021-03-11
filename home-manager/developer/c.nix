{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    astyle
    ccls
    cmake
    cmake-format
    gdb
    meson
    ninja
    protobuf
  ];

}
