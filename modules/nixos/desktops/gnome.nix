{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.gnome.enable {

    # Enable network manager
    networking.networkmanager.enable = true;

    services = {

      # Fix for dconf
      dbus.packages = [ pkgs.dconf ];
      udev.packages = [ pkgs.gnome.gnome-settings-daemon ];

      xserver = {

        # Enable the X11 windowing system.
        enable = true;
        layout = "no";
        xkbOptions = "eurosign:e";

        # Enable touchpad support.
        libinput.enable = true;

        # Enable GNOME Desktop Environment
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = true;
        desktopManager.gnome.enable = true;

      };

    };

    # Install additional packages
    environment.systemPackages = with pkgs; [
      libnotify
      gnome.adwaita-icon-theme
      gnome.gnome-tweaks
    ];

  };

}
