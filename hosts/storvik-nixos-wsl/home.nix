{ config, pkgs, ... }:

{

  storvik = {
    desktop = "none";
    enableWSL = true;
    gitSigningKey = "0x9DE06C73577F75A5!";
    waylandTools = true;
    devtools.enable = true;
    texlive = true;
  };

}
