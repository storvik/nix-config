{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    emacsUnstable
    #emacsGcc # emacs native compile
  ];

}
