{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.texlive.enable {

    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

  };

}
