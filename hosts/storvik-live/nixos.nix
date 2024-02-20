{ config, pkgs, ... }:

{

  storvik = {
    desktop = "hyprland";
    disableLoginManager = true;
    kanata.enable = true;
    remoteLogon = true;
  };

  system.stateVersion = pkgs.lib.mkForce "22.05";

  isoImage.contents = [
    {
      source = ./live_id_ed25519;
      target = "/live_id_ed25519";
    }
    {
      source = ./live_id_ed25519.pub;
      target = "/live_id_ed25519.pub";
    }
  ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/iso/live_id_ed25519" ];
  sops.gnupg.sshKeyPaths = [ ]; # fix for error /etc/ssh/id_host_rsa not found
  sops.secrets.swg_live_privateKey = { };
  sops.secrets.user_password = { };

  # Enable SSH in the boot process
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce
    [ "multi-user.target" ];

  # Set ssh key and password
  users.users.storvik = {
    hashedPasswordFile = config.sops.secrets.user_password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/cetz89/SRWucBZPsARH8pnHwXCW9MGrHmNJyhHMCC petterstorvik@gmail.com" # matebook
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoFq88oaivkC4bqCUINV6DRwg6Qfkd+a8gC6Mc68EKB petter.storvik@goodtech.no" # lenovo
    ];
  };

  networking.wg-quick.interfaces.swg = {
    address = [ "10.0.10.5/32" ];
    privateKeyFile = config.sops.secrets.swg_live_privateKey.path;
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


}
