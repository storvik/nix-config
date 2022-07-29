{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.user.storvik.enable {

    users.users.storvik = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "audio"
        "video"
      ] ++ (if config.storvik.kanata.enable then [ "input" "uinput" ] else [ ]);
    };

  };

}
