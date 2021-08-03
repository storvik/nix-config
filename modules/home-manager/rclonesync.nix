{ config, pkgs, lib, ... }:

with lib;

let

  # bash script that syncs dirs to cloud using rclone
  storvik-rclonesync = pkgs.writeScriptBin "storvik-rclonesync" ''
    #!${pkgs.bash}/bin/bash

    ${lib.strings.concatMapStrings (x: "rclone sync " + x.source + " " + x.remote + ":" + x.dest + "\n") config.storvik.rclonesync.syncdirs}
  '';

in

{

  config = mkIf config.storvik.rclonesync.enable {

    # systemd service
    systemd.user.services.rclonesync = {
      Unit = {
        Description = "Sync dirs to cloud using rclone";
      };
      Service = {
        Type = "simple";
        ExecStart = "${storvik-rclonesync}/bin/storvik-rclonesync";
      };
    };

    systemd.user.timers.rclonesync = {
      Unit = {
        Description = "Timer for syncing dirs to cloud using rclone";
      };
      Timer = {
        Unit = "rclonesync.service";
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
      storvik-rclonesync
      rclone
    ];

  };

}
