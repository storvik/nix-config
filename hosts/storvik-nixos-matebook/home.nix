{ config, pkgs, ... }:

{

  storvik = {
    desktop = "hyprland";
    gitSigningKey = "0xBD58BBDAE6A7AACC!";
    waylandTools = true;
    devtools.enable = true;
    designer = true;
    social = true;
    media = true;
    texlive = true;
    disableEmail = false;
  };

  sops = {
    # gnupg.home = "/home/storvik/.gnupg"; # Using gpg didn't work, sops-nix service didn't start
    age.sshKeyPaths = [ "/home/storvik/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets.yaml;

    secrets.petter_storvik_dev = {
      path = "${config.xdg.configHome}/secrets/petter_storvik_dev";
    };
    secrets.petter_svartisenfestivalen_no = {
      path = "${config.xdg.configHome}/secrets/petter_svartisenfestivalen_no";
    };
  };


}
