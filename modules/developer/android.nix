{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.developer.android.enable = mkEnableOption "Android developer tools";

  config = mkIf (config.storvik.developer.android.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        apktool
        scrcpy
      ];
    };

}
