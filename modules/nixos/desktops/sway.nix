{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.sway.enable {

    assertions = [
      {
        assertion = config.storvik.gnome.enable == false;
        message = "Sway should not be enabled at the same time as Gnome.";
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        };
      };
    };

    programs.sway = {
      enable = true;
      extraPackages = with pkgs; [
        gtklock
        swayidle
        waybar
        wl-clipboard
        wofi
        sway-contrib.grimshot
        swappy
        wev
        brightnessctl
        pamixer
        avizo
        networkmanager_dmenu
        pinentry-qt
        imv
        wf-recorder
      ];
    };
  };

}
