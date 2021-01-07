{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    clpm
    ecl
    sbcl
  ];

}
