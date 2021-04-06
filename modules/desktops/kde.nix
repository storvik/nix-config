{ config, lib, pkgs, ... }:

with lib;

{

  options.storvik.kde.enable = mkEnableOption "KDE";

  config = mkIf config.storvik.kde.enable
    (mkMerge [

      # Common
      { }

      # If nixos
      (optionalAttrs (import ../../helpers/if-nixos.nix) {

        # Enable the X11 windowing system.
        services.xserver.enable = true;
        services.xserver.layout = "no";
        services.xserver.xkbOptions = "eurosign:e";

        # Enable touchpad support.
        services.xserver.libinput.enable = true;

        # Enable the KDE Desktop Environment.
        services.xserver.displayManager.sddm.enable = true; # not needed when gdm enabled
        services.xserver.desktopManager.plasma5.enable = true;

      })

    ]);

}
