{ config, pkgs, ... }:

{

  storvik = {
    desktop = "none";
    disableEmacs = true;
    disableEmacsDaemon = true;
    disableEmail = true;
    disableNerdfonts = true;
  };

}
