{ config, pkgs, lib, ... }:

with lib;

let

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

  config = mkIf config.storvik.backup.enable {

    systemd.user.services."storvik-backup" = {
      Unit = {
        Description = ''
          Backup service
        '';
      };
      Service = {
        Type = "simple";
        ExecStart = "${storvik-backup}/bin/storvik-backup";
      };
    };

    systemd.user.timers."storvik-backup" = {
      Unit = {
        Description = "Storvik backup timer.";
      };
      Timer = {
        Unit = "storvik-backup.service";
        OnCalendar = "*-*-* 1:30:00";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    home.packages = with pkgs; [
      rclone
      storvik-backup
    ];

  };

}
