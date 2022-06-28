{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.kmonad.enable {

    # Create uinput group
    users.groups = { uinput = { }; };

    # Extra udev rules
    services.udev.extraRules =
      ''
        # KMonad user access to /dev/uinput
        KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
      '';

  };

}
