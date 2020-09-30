{ config, pkgs, lib, ... }:

{

  programs.firefox = {
    enable = lib.mkDefault false;
  };
    
}
