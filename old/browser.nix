{ config, pkgs, lib, ... }:

{
  # Only enable firefox on non nixos systems
  programs.firefox = lib.mkIf (config.targets.genericLinux.enable != true) {
    enable = true;
  };

  programs.firefox = {
    enable = lib.mkDefault false;
  };

}
