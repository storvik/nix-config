{ config, pkgs, ... }:
{
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
        "nuc" = { id = "2WKOIHN-4NIGV6L-SODARH5-XWA4EVV-PCFZ4YC-ADU7DBU-EBKNP6J-QJKKMAB"; };
        "lenovo" = { id = "KQB7T6Z-3QGGI4H-65YEUO4-I2OL3NG-EKG2UXA-3RWSEB2-R3RDTCZ-GFRW4AO"; };
        "samsung" = { id = "OJXWZ6F-XM2BW2J-RB5TBXI-IWBSIJ6-RNSWWBH-BZU6NZC-LNNVJYW-UMXILAR"; };
      };
      folders = {
        "org" = {
          path = "/home/storvik/developer/org/";
          devices = [ "lenovo" "samsung" "nuc" ];
        };
        "svartisenfestivalen" = {
          path = "/home/storvik/developer/svartisenfestivalen/";
          devices = [ "lenovo" "nuc" "samsung" ];
        };
      };
    };
  };

  sops.gnupg.home = "/home/storvik/.gnupg";
  sops.defaultSopsFile = ./secrets.yaml;

  sops.secrets.mullvad_privateKey = { };
  sops.secrets.swg_privateKey = { };

  networking.wg-quick.interfaces.mullvad = {
    address = [ "10.67.191.187/32" "fc00:bbbb:bbbb:bb01::4:bfba/128" ];
    privateKeyFile = config.sops.secrets.mullvad_privateKey.path;
    autostart = false;
    dns = [ "10.64.0.1" ];
    peers = [
      {
        allowedIPs = [ "0.0.0.0/0" "::0/0" ];
        endpoint = "185.213.154.68:3556";
        publicKey = "qZbwfoY4LHhDPzUROFbG+LqOjB0+Odwjg/Nv3kGolWc=";
      }
    ];
  };

  networking.wg-quick.interfaces.swg = {
    address = [ "10.0.10.4/32" ];
    privateKeyFile = config.sops.secrets.swg_privateKey.path;
    autostart = false;
    dns = [ "1.1.1.1" "10.0.10.1" ];
    peers = [
      {
        allowedIPs = [ "0.0.0.0/0" "::0/0" ];
        endpoint = "wg.storvik.dev:51820";
        publicKey = "dlocQXIsZmwtVd8ogaYFoI2Jsjn32Lzj4Qb7xGJXmUM=";
      }
    ];
  };


}
