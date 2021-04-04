{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.developer.go.enable = mkEnableOption "Go developer tools";

  config = mkIf (config.storvik.developer.go.enable || config.storvik.developer.enable)
    {

      programs.go = {
        enable = true;
        goPath = "developer/gopath";
        goBin = "developer/gopath/bin";
        goPrivate = [ "git.avantieng.no/*" ];
      };

      home.packages = with pkgs; [
        gopls
        gotools
      ];

    };

}
