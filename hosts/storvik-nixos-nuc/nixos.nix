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
      "matebook" = { id = "R2M4YYS-PR7GNS2-JZ3ACYP-VWTMPLK-WQMI3YJ-AB2HV2W-AO6QG45-KAESNQR"; };
      "lenovo" = { id = "UPXX42G-U3JIKZG-IR7BJON-EASWQ4C-TC7KOLZ-NG7MPGK-EG3GU55-F36QNQB"; };
      "samsung" = { id = "OJXWZ6F-XM2BW2J-RB5TBXI-IWBSIJ6-RNSWWBH-BZU6NZC-LNNVJYW-UMXILAR"; };
    };
    folders = {
      "org" = {
        path = "/home/storvik/syncthing/org/";
        devices = [ "lenovo" "samsung" "matebook" ];
      };
      "svartisenfestivalen" = {
        path = "/home/storvik/syncthing/svartisenfestivalen/";
        devices = [ "lenovo" "matebook" ];
      };
    };
  };
  fileSystems."/run/mnt/wd-external" = {
    device = "/dev/disk/by-label/BACKUP";
    options = [ "nofail" "rw" "uid=1000" "gid=100" "x-systemd.automount" ];
  };
  # Mount network drive, more info here https://nixos.wiki/wiki/Samba
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/run/mnt/mybook-storvik-backup" = {
    device = "//192.168.0.96/StorvikBackup";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in
      [ "credentials=/etc/nixos/smb-secrets,credentials=/etc/nixos/smb-secrets,vers=1.0,rw,nounix,uid=1000,gid=100" ];
  };
}
