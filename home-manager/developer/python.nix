{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    python38
    python38Packages.pip
    nodePackages.pyright
  ];

}
