{ config, pkgs, ... }:

{
  storvik = {
    remoteLogon = true;
    kanata.enable = true;
    backup = {
      enable = true;
      folders = [
        {
          synctype = "rclone";
          source = "pcloud:photos/";
          dest = "/run/mnt/wd-external/backup/photos/";
          delete = true;
        }
        {
          synctype = "rclone";
          source = "pcloud:eBooks/";
          dest = "/run/mnt/wd-external/backup/eBooks/";
          delete = true;
        }
        {
          synctype = "rsync";
          source = "/run/mnt/wd-external/backup/";
          dest = "/run/mnt/mybook-storvik-backup/";
          delete = true;
        }
        {
          synctype = "rclone";
          source = "/run/mnt/wd-external/backup/";
          dest = "s3backup:storvik-backup/";
          delete = true;
        }
        {
          synctype = "rclone";
          source = "/home/storvik/syncthing/svartisenfestivalen/";
          dest = "pcloud:svartisenfestivalen/";
          delete = false;
        }
      ];
    };
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
        "lenovo" = { id = "UPXX42G-U3JIKZG-IR7BJON-EASWQ4C-TC7KOLZ-NG7MPGK-EG3GU55-F36QNQB"; };
        "samsung" = { id = "OJXWZ6F-XM2BW2J-RB5TBXI-IWBSIJ6-RNSWWBH-BZU6NZC-LNNVJYW-UMXILAR"; };
      };
      folders = {
        "org" = {
          path = "/home/storvik/syncthing/org/";
          devices = [ "lenovo" "samsung" "matebook" ];
        };
        "rbul" = {
          path = "/home/storvik/syncthing/rbul/";
          devices = [ "lenovo" "matebook" "samsung" ];
        };
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
    device = "//192.168.1.180/StorvikBackup";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in
      [ "credentials=/etc/nixos/smb-secrets,credentials=/etc/nixos/smb-secrets,vers=1.0,rw,nounix,uid=1000,gid=100" ];
  };

  sops = {
    age.sshKeyPaths = [ "/home/storvik/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets.yaml;

    secrets.swg_privateKey = { };
  };

  networking.wg-quick.interfaces.swg = {
    address = [ "10.0.10.6/32" ];
    privateKeyFile = config.sops.secrets.swg_privateKey.path;
    autostart = true;
    dns = [ "1.1.1.1" "10.0.10.1" ];
    peers = [
      {
        allowedIPs = [ "0.0.0.0/0" "::0/0" ];
        endpoint = "wg.storvik.dev:51820";
        publicKey = "dlocQXIsZmwtVd8ogaYFoI2Jsjn32Lzj4Qb7xGJXmUM=";
      }
    ];
  };

  hardware.bluetooth.enable = true;

  virtualisation.oci-containers.containers."homeassistant" = {
    autoStart = true;
    image = "ghcr.io/home-assistant/home-assistant:2024.11.1";
    volumes = [
      "/home/storvik/developer/ha:/config" # persistent config on host
      "/etc/localtime:/etc/localtime:ro" # fixes time
      "/var/run/dbus:/run/dbus:ro" # fixes bluetooth
    ];
    extraOptions = [
      # Disable access to zigbee dongle, using zigbee2mqtt instead
      # "--device=/dev/ttyUSB0" # usb dongle for zigbee
      "--network=host"
      "--privileged"
    ];
  };

  services.mosquitto = {
    enable = true;
    listeners = [{
      acl = [ "pattern readwrite #" ];
      omitPasswordAuth = true;
      settings.allow_anonymous = true;
    }];
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = true;
      permit_join = true;
      serial = {
        # adapter = "ember";
        port = "/dev/ttyUSB0";
        rtscts = true;
      };
      frontend = true;
      mqtt = {
        server = "mqtt://localhost:1883";
      };
    };
  };

}
