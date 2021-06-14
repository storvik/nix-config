{ config, pkgs, lib, ... }:

with lib;

let

  android = pkgs.androidenv.composeAndroidPackages { };

in

{

  config = mkIf (config.storvik.developer.android.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        android.platform-tools
        apktool
        scrcpy
      ];
    };

}
