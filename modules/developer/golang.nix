{ config, pkgs, lib, ... }:

with lib;

let

  homedir = builtins.getEnv "HOME";

in

{

  options.storvik.developer.go.enable = mkEnableOption "Go developer tools";

  config = mkIf (config.storvik.developer.go.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        go
        gopls
        gotools
        protobuf
      ];

      home.sessionVariables = {
        GOPATH = "${homedir}/developer/gopath";
        GOBIN = "${homedir}/developer/gopath/bin";
      };

      home.sessionPath = [
        "${config.home.sessionVariables.GOBIN}"
      ];
    };

}
