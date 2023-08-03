{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.hyprland.enable {

    assertions = [
      {
        assertion = config.storvik.gnome.enable == false;
        message = "Hyprland should not be enabled at the same time as Gnome.";
      }
    ];

    # Enable network manager
    networking.networkmanager.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Fix gtklock
    security.pam.services.gtklock = { };

    # Login handled by greetd and tuigreet
    services.greetd = {
      enable = config.storvik.hyprland.loginManager;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };

    programs.hyprland = {
      enable = true;
    };

    services.udisks2.enable = true;

    environment.systemPackages = with pkgs; [
      pamixer
      brightnessctl
      gnome.nautilus
      pinentry-qt # needed to use from scripts
      wl-clipboard # needed for copy paste in swappy etc
      wofi # must be installed in order to reach it from scripts or clipman
    ];

  };

}
