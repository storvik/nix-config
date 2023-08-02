{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.user.storvik.enable {
    programs.adb.enable = true;

    users.users.storvik = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "audio"
        "video"
        "adbusers"
      ];
    };

  };

}
