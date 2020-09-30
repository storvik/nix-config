{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    android-studio
    dart_dev
    #flutter
    flutterPackages.dev
    scrcpy
  ];

}
