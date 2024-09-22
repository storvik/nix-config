{ config, pkgs, ... }:

{

  storvik = {
    desktop = "none";
    disableEmail = true;
    gitSigningKey = "0x3B7A1B8284072C5A!";
    waylandTools = true;
    devtools.enable = true;
    texlive = false;
    cad = false;
    ai.enable = true;
  };

}
