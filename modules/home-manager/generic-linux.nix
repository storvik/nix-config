{ config, pkgs, lib, ... }:

with lib;

let

  nixgl = import (fetchTarball https://github.com/guibou/nixGL/archive/master.tar.gz) { };

in

{

  config = mkIf config.storvik.genericLinux.enable {

    # This makes home-manager work better with other distros than nixos
    # Also used to differentiate between nixos and non nixos systems
    targets.genericLinux.enable = true;

    home.packages = with nixgl; [
      nixGLDefault # auto-detect nvidia, use intel if not found
      # nixGLIntel # mesa intel
      # NixGLNvidia # nvidia
    ];

  };

}
