{ config, pkgs, ... }:

{

  storvik = {
    remoteLogon = true;
    desktop = "gnome";
    autoLoginUser = "retro";
  };

  sops = {
    age.sshKeyPaths = [ "/home/storvik/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets.yaml;
    secrets.retro_user_password = {
      neededForUsers = true;
    };
    secrets.storvik_user_password = {
      neededForUsers = true;
    };
  };

  users.mutableUsers = false;

  users.users.storvik.hashedPasswordFile = config.sops.secrets.storvik_user_password.path;

  users.users.retro = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.retro_user_password.path;
    extraGroups = [
      "networkmanager"
      "audio"
    ];
  };

}
