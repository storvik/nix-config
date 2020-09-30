{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    nodejs-14_x
    yarn
  ];

}
