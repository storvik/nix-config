{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.gnome.enable {

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

    services = {

      xserver = {

        # Enable the X11 windowing system.
        enable = true;
        layout = "no";
        xkbOptions = "eurosign:e";

        # Enable touchpad support.
        libinput.enable = true;

        # Enable GNOME Desktop Environment
        displayManager.gdm.enable = true;
        desktopManager.gnome3.enable = true;

      };

    };

    # Install additional packages
    environment.systemPackages = with pkgs; [
      gnome3.adwaita-icon-theme
      gnome3.gnome-tweaks
    ];

  };

}
