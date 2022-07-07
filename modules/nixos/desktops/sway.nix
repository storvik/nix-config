{ config, lib, pkgs, ... }:

with lib;

{

  config = mkIf config.storvik.sway.enable {

    # Enable network manager
    networking.networkmanager.enable = true;

    programs.sway = {
      enable = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        waybar
        wl-clipboard
        mako
        wofi
        brightnessctl
      ];
    };
  };

}
