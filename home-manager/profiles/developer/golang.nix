{ config, pkgs, lib, ... }:
let

  homedir = builtins.getEnv "HOME";

in
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

}
