{ config, pkgs, lib, ... }:
{

  home.packages = with pkgs; [
    android-studio
    flutterPackages.stable
    scrcpy
  ];

}
