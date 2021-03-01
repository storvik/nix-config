{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    texlive.combined.scheme-full
  ];

}
