{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.gnome.enable {

    dconf.settings = {
      "org.gnome.desktop.input-sources" = {
        xkb-options = [ "caps:ctrl_modifier" ];
      };
    };

  };

}
