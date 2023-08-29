{ config, pkgs, ... }:

{

  storvik = {
    desktop = "hyprland";
    kanata = true;
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
        "nuc" = { id = "2WKOIHN-4NIGV6L-SODARH5-XWA4EVV-PCFZ4YC-ADU7DBU-EBKNP6J-QJKKMAB"; };
        "lenovo" = { id = "UPXX42G-U3JIKZG-IR7BJON-EASWQ4C-TC7KOLZ-NG7MPGK-EG3GU55-F36QNQB"; };
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

  networking.wg-quick.interfaces.mull = {
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

  networking.wg-quick.interfaces.mullblock = {
    address = [ "10.67.191.187/32" "fc00:bbbb:bbbb:bb01::4:bfba/128" ];
    privateKeyFile = config.sops.secrets.mullvad_privateKey.path;
    autostart = false;
    dns = [ "100.64.0.7" ];
    peers = [
      {
        allowedIPs = [ "0.0.0.0/0" "::0/0" ];
        endpoint = "185.65.135.67:3065";
        publicKey = "veGD6/aEY6sMfN3Ls7YWPmNgu3AheO7nQqsFT47YSws=";
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
