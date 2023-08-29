{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.storvik;

  storvik-backup = pkgs.writeShellScriptBin "storvik-backup" ''
    ${lib.strings.concatMapStrings
      (x: (if x.synctype == "rsync"
           then "${pkgs.rsync}/bin/rsync -aiz " + (if x.delete then "--delete " else "")
           else "${pkgs.rclone}/bin/rclone -P " + (if x.delete then "sync " else "copy ")) +
          x.source + " "
          + x.dest + "\n")
      config.storvik.backup.folders}
  '';
in

{

  config = lib.mkIf config.storvik.backup.enable {

    systemd.services."storvik-backup" = {
      enable = true;
      description = ''
        Backup service
      '';
      serviceConfig = {
        Type = "simple";
        ExecStart = "${storvik-backup}/bin/storvik-backup";
        User = "storvik";
        Group = "users";
      };
    };

    systemd.timers."storvik-backup" = {
      description = "Storvik backup timer.";
      timerConfig = {
        Unit = "storvik-backup.service";
        OnCalendar = "*-*-* 1:30:00";
      };
      wantedBy = [ "timers.target" ];
    };

    environment.systemPackages = with pkgs; [
      rclone
      storvik-backup
    ];

  };

}
