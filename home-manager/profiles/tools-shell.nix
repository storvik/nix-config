{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    lastpass-cli
    nmap
    ripgrep
    unixtools.netstat
    unixtools.route
    whois
  ];

}
