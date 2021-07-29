{ config, pkgs, lib, ... }:

with lib;

let

  # bash script that syncs dirs to pcloud
  storvik-pcloudsync = pkgs.writeScriptBin "storvik-pcloudsync" ''
    #!${pkgs.bash}/bin/bash

    ${lib.strings.concatMapStrings (x: "rclone sync " + x.source + " pcloud:" + x.dest + "\n") config.storvik.pcloudsync.syncdirs}
  '';

in

{

  config = mkIf config.storvik.pcloudsync.enable {

    # systemd service
    systemd.user.services.pcloudsync = {
      Unit = {
        Description = "Sync dirs to pcloud";
      };
      Service = {
        Type = "simple";
        ExecStart = "${storvik-pcloudsync}/bin/storvik-pcloudsync";
      };
    };

    systemd.user.timers.pcloudsync = {
      Unit = {
        Description = "Timer for syncing dirs to pcloud";
      };
      Timer = {
        Unit = "pcloudsync.service";
        # Run 15 minutes after boot, since the timer must run at least once
        # before OnUnitInactiveSec will trigger
        OnBootSec = "15m";
        # Run 15 minutes after rclone.service last finished
        OnUnitInactiveSec = "15m";
        # Run once when the timer is first started
        OnActiveSec = "1s";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    home.packages = with pkgs; [
      storvik-pcloudsync
      rclone
    ];

  };

}
