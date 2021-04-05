{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.texlive.enable = mkEnableOption "Install texlive";

  config = mkIf config.storvik.texlive.enable {

    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

  };

}
