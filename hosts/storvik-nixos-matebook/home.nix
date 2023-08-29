{ config, pkgs, ... }:

{

  storvik = {
    desktop = "hyprland";
    gitSigningKey = "0xBD58BBDAE6A7AACC!";
    waylandTools = true;
    devtools.enable = true;
    designer = true;
    social = true;
    media = true;
    texlive = true;
  };

}
