{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf cfg.remoteLogon {
    services.sshd.enable = true;
    users.users.storvik = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/cetz89/SRWucBZPsARH8pnHwXCW9MGrHmNJyhHMCC petterstorvik@gmail.com" # matebook
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoFq88oaivkC4bqCUINV6DRwg6Qfkd+a8gC6Mc68EKB petter.storvik@goodtech.no" # lenovo
      ];
    };
  };

}
