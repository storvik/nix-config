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

  home.sessionPath = [
    "${config.home.sessionVariables.GOBIN}"
  ];

  #programs.fish.interactiveShellInit = ''
  #  set PATH $PATH ${config.home.sessionVariables.GOBIN}
  #'';

  #programs.bash.initExtra = ''
  #  PATH=$PATH:${config.home.sessionVariables.GOBIN}
  #'';

}
