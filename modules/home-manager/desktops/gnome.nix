{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.gnome.enable {
    home.packages = with pkgs; [
      gnome.dconf-editor
    ];

    dconf.settings = {
      # Caps lock for ctrl
      "org/gnome/desktop/input-sources" = {
        "current" = "uint32 0";
        "xkb-options" = [ "caps:ctrl_modifier" ];
      };
      # Disable screensaver and idle
      "org.gnome.desktop.session" = {
        "idle-delay" = "uint32 0";
      };
      # Disable automatic suspend on battery and ac
      "org/gnome/settings-daemon/plugins/power" = {
        "sleep-inactive-ac-type" = "nothing";
      };
      "org/gnome/settings-daemon/plugins/power" = {
        "sleep-inactive-battery-type" = "nothing";
      };
    };

  };

}
