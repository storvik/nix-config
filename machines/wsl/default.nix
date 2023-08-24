{ config, lib, pkgs, ... }:

{

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "storvik";
    startMenuLaunchers = true;
    nativeSystemd = true;
  };

}
