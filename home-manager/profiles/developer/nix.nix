{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    nixpkgs-fmt
    nix-prefetch-git
    nix-prefetch-github
  ];

}
