{ config, pkgs, lib, ... }:

with lib;

let

  storvik-rclonesyncs = lib.attrsets.mapAttrs'
    (name: value:
      lib.attrsets.nameValuePair ("storvik-rclonesync-" + name)
        (pkgs.writeShellScriptBin ("storvik-rclonesync-" + name) ''
          ${lib.strings.concatMapStrings (x: "${pkgs.rclone}/bin/rclone sync " + x.source + " " + x.dest + "\n") value.syncdirs}
        '')
    )
    config.storvik.rclone.syncs;


  storvik-rclonesync-services = lib.attrsets.mapAttrs'
    (name: value:
      lib.attrsets.nameValuePair ("storvik-rclonesync-" + name)
        {
          Unit = {
            Description = ''
              ${name} rclone sync service.
            '';
          };
          Service = {
            Type = "simple";
            ExecStart = "${storvik-rclonesyncs."storvik-rclonesync-${name}"}/bin/storvik-rclonesync-${name}";
          };
        })
    config.storvik.rclone.syncs;

  storvik-rclonesync-timers = lib.attrsets.mapAttrs'
    (name: value:
      lib.attrsets.nameValuePair ("storvik-rclonesync-" + name)
        {
          Unit = {
            Description = "${name} rclone sync service timer.";
          };
          Timer = {
            Unit = "storvik-rclonesync-${name}.service";
            OnBootSec = value.afterboot;
            OnUnitInactiveSec = value.interval;
            OnActiveSec = "1s";
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
        })
    config.storvik.rclone.syncs;

in

{

  config = mkIf config.storvik.rclone.enable {

    systemd.user.services = storvik-rclonesync-services;
    systemd.user.timers = storvik-rclonesync-timers;

    home.packages = with pkgs; [
      rclone
    ] ++ lib.attrsets.attrValues storvik-rclonesyncs;

  };

}
