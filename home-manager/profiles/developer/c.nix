{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    astyle
    ccls
    cmake
    #opencv
    pcl
    protobuf
  ];

}
