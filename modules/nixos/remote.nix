{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf cfg.remoteLogon {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      # settings.PermitRootLogin = "yes";
    };

    users.users.storvik = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/cetz89/SRWucBZPsARH8pnHwXCW9MGrHmNJyhHMCC petterstorvik@gmail.com" # matebook
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7BiFWuBc2PTpQ/wSrL76nDw0+TDuyjaNR0hlToZgoq petter.storvik@tive.com " # macbook
      ];
    };

    # TODO: Make this possible to toggle
    # TODO: Figure out how to use this, see
    # https://github.com/NixOS/nixpkgs/issues/31611
    security.pam.sshAgentAuth.enable = true;
    security.pam.services.sudo.sshAgentAuth = true;
    security.pam.services.su.requireWheel = true;

  };

}
