{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    lastpass-cli
    ltunify
    nmap
    ripgrep
    unixtools.netstat
    unixtools.route
    whois
  ];

}
