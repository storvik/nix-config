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

    # PAM hyprlock module
    security.pam.services.hyprlock = { };

    # Login handled by greetd and tuigreet
    services.greetd = {
      enable = (!cfg.disableLoginManager);
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
        };
      };
    };

    programs.hyprland = {
      enable = true;
    };

    services.udisks2.enable = true;

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    environment.systemPackages = with pkgs; [
      pamixer
      brightnessctl
      pinentry-qt # needed to use from scripts
      wl-clipboard # needed for copy paste in swappy etc
    ];


  };

}
