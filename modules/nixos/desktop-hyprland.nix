{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.desktop == "hyprland") {

    storvik.sound = lib.mkDefault true;

    # Enable network manager
    networking.networkmanager.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Fix gtklock
    security.pam.services.gtklock = { };

    # Login handled by greetd and tuigreet
    services.greetd = {
      enable = (!cfg.disableLoginManager);
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
      cinnamon.nemo
      pinentry-qt # needed to use from scripts
      wl-clipboard # needed for copy paste in swappy etc
      wofi # must be installed in order to reach it from scripts or clipman
    ];


  };

}
