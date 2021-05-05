{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.sway.enable {

    # Enable network manager
    networking.networkmanager.enable = true;

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "no";
    };

    # Set your time zone.
    time.timeZone = "Europe/Oslo";

  };

}
