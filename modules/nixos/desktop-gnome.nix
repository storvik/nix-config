{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.desktop == "gnome") {

    storvik.sound = lib.mkDefault true;

    # Enable network manager
    networking.networkmanager.enable = true;

    services = {

      # Fix for dconf
      dbus.packages = [ pkgs.dconf ];
      udev.packages = [ pkgs.gnome.gnome-settings-daemon ];

      xserver = {

        # Enable the X11 windowing system.
        enable = true;
        layout = "us";
        xkbModel = "pc105";
        xkbVariant = "altgr-intl";
        xkbOptions = "ctrl:nocaps";

        # Enable touchpad support.
        libinput.enable = true;

        # Enable GNOME Desktop Environment
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = true;
        desktopManager.gnome.enable = true;

      };

    };

    services.xserver.displayManager.autoLogin = lib.mkIf (cfg.autoLoginUser != null) {
      enable = true;
      user = cfg.autoLoginUser;
    };

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services = lib.mkIf (cfg.autoLoginUser != null) {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };

    environment.systemPackages = with pkgs; [
      libnotify
      gnome.adwaita-icon-theme
      gnome.gnome-tweaks
    ];

  };

}
