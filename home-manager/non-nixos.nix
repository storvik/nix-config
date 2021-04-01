# Helpers for non-nixos stuff
{ config, pkgs, lib, ... }:
let

  nixgl = import (fetchTarball https://github.com/guibou/nixGL/archive/master.tar.gz) { };

in
{

  home.packages = with nixgl; [
    nixGLDefault # auto-detect nvidia, use intel if not found
    # nixGLIntel # mesa intel
    # NixGLNvidia # nvidia
  ];

}
