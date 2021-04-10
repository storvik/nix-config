{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.android.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        apktool
        scrcpy
      ];
    };

}
