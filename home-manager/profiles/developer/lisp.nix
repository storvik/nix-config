{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    sbcl
    ecl
  ];

}
