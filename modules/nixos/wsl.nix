{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf cfg.enableWSL {
    wsl = {
      enable = true;
      wslConf.automount.root = "/mnt";
      defaultUser = "storvik";
      startMenuLaunchers = true;
      nativeSystemd = true;
      useWindowsDriver = true;
    };
  };

}
