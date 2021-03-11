{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science nb ]))
    bitwarden-cli
    bfg-repo-cleaner
    ltunify
    nmap
    rclone
    ripgrep
    unixtools.netstat
    unixtools.route
    whois
  ];

}
