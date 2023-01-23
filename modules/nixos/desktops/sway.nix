{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.sway.enable {

    # Enable network manager
    networking.networkmanager.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Fix gtklock
    security.pam.services.gtklock = { };

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
      ];
    };
  };

}
