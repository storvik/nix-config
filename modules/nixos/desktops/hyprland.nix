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
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };

    programs.hyprland = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      pamixer
      brightnessctl
      gnome.nautilus
    ];

  };

}
