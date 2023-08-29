{ config, pkgs, ... }:

{

  storvik = {
    desktop = "none";
    enableWSL = true;
  };

  services.syncthing = {
    enable = true;
    dataDir = "/home/storvik";
    overrideDevices = true;
    overrideFolders = true;
    user = "storvik";
    group = "users";
    guiAddress = "0.0.0.0:8384";
    settings = {
      devices = {
        "matebook" = { id = "R2M4YYS-PR7GNS2-JZ3ACYP-VWTMPLK-WQMI3YJ-AB2HV2W-AO6QG45-KAESNQR"; };
        "nuc" = { id = "2WKOIHN-4NIGV6L-SODARH5-XWA4EVV-PCFZ4YC-ADU7DBU-EBKNP6J-QJKKMAB"; };
        "samsung" = { id = "OJXWZ6F-XM2BW2J-RB5TBXI-IWBSIJ6-RNSWWBH-BZU6NZC-LNNVJYW-UMXILAR"; };
      };
      folders = {
        "org" = {
          path = "/home/storvik/developer/org/";
          devices = [ "matebook" "samsung" "nuc" ];
        };
        "svartisenfestivalen" = {
          path = "/home/storvik/developer/svartisenfestivalen/";
          devices = [ "matebook" "nuc" "samsung" ];
        };
      };
    };
  };

}
