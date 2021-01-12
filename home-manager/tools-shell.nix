{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    lastpass-cli
    ltunify
    nmap
    rclone
    ripgrep
    unixtools.netstat
    unixtools.route
    whois
  ];

  home.sessionVariables = {
    LPASS_AGENT_TIMEOUT = 0;
  };

}
