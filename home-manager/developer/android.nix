{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    android-studio
    apktool
    flutterPackages.stable
    scrcpy
  ];

}
