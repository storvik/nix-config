{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.go.enable || config.storvik.developer.enable)
    {

      programs.go = {
        enable = true;
        goPath = "developer/gopath";
        goBin = "developer/gopath/bin";
        goPrivate = [ "git.avantieng.no/*" "github.com/Goodtech-AS" ];
      };

      home.packages = with pkgs; [
        delve
        gopls
        gotools
      ];

    };

}
