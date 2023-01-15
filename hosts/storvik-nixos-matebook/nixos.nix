{ pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    dataDir = "/home/storvik";
    overrideDevices = true;
    overrideFolders = true;
    user = "storvik";
    group = "users";
    guiAddress = "0.0.0.0:8384";
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
        devices = [ "lenovo" "nuc" ];
      };
    };
  };
}
