{ config, pkgs, ... }:

{

  storvik = {
    desktop = "hyprland";
    waylandTools = true;
    disableEmacsDaemon = true;
    devtools.enable = true;
    disableEmail = true;
    forensics.enable = true;
  };

}
