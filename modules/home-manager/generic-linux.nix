{ config, pkgs, lib, inputs, ... }:

with lib;

{

  config = mkIf config.storvik.genericLinux.enable {

    # This makes home-manager work better with other distros than nixos
    # Also used to differentiate between nixos and non nixos systems
    targets.genericLinux.enable = true;

    home.packages = [
      pkgs.nixGL.auto.nixGLDefault # auto-detects nvidia, use intel if not found
    ];

    # Change NIX_PATH in order to pin nixpkgs to current version. This way
    # `nix shell` etc uses the same nixpkgs version as system configuration.
    home.sessionVariables = {
      NIX_PATH = "nixpkgs=${inputs.nixpkgs}\${NIX_PATH:+:}$NIX_PATH";
    };

  };

}
