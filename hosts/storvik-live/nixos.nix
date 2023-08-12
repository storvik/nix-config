{ config, pkgs, ... }:

{

  # Enable SSH in the boot process
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce
    [ "multi-user.target" ];

  # Set ssh key and password
  users.users.storvik = {
    hashedPassword = "$6$wtWA533xiHeKp7bz$75X0IrqYqrpDB2vUOxm3KsCEDEEGTtu60Ovcc7TIfU68.CA.G77ayIFiLZPNLCzjuZ/CqqyRvYKEDitQMRJty1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/cetz89/SRWucBZPsARH8pnHwXCW9MGrHmNJyhHMCC petterstorvik@gmail.com" # matebook
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoFq88oaivkC4bqCUINV6DRwg6Qfkd+a8gC6Mc68EKB petter.storvik@goodtech.no" # lenovo
    ];
  };

}
