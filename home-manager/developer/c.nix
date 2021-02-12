{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    astyle
    ccls
    clang
    clang-tools
    cmake
    cmake-format
    gdb
    meson
    ninja
    protobuf
  ];

}
