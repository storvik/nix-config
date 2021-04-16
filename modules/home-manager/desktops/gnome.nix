{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.gnome.enable {

    dconf.settings = {
      # Caps lock for ctrl
      "org.gnome.desktop.input-sources" = {
        xkb-options = [ "caps:ctrl_modifier" ];
      };
      # Disable screensaver and idle
      "org.gnome.desktop.session" = {
        idle-delay = 0;
      };
      "org.gnome.desktop.screensaver" = {
        lock-delay = 0;
      };
      # Disable automatic suspend on battery and ac
      "org.gnome.settings-daemon.plugins.power" = {
        sleep-inactive-ac-type = "nothing";
      };
      "org.gnome.settings-daemon.plugins.power" = {
        sleep-inactive-battery-type = "nothing";
      };
    };

  };

}
