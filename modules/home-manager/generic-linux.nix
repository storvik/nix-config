{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.genericLinux.enable {

    # This makes home-manager work better with other distros than nixos
    # Also used to differentiate between nixos and non nixos systems
    targets.genericLinux.enable = true;

    home.packages = [
      pkgs.nixGL.auto.nixGLDefault # auto-detects nvidia, use intel if not found
    ];

  };

}
