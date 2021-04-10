{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.nix.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        nixpkgs-fmt
        nix-prefetch-git
        nix-prefetch-github
      ];
    };

}
