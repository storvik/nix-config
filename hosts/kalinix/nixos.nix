{ config, pkgs, ... }:

{

  storvik = {
    desktop = "hyprland";
    kanata = {
      enable = true;
      devices = [
        "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
      ];
    };
    remoteLogon = true;
  };

}
