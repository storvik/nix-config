{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    astyle
    ccls
    cmake
    gdb
    #opencv
    pcl
    protobuf
  ];

}
