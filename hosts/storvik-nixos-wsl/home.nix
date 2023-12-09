{ config, pkgs, ... }:

{

  storvik = {
    desktop = "none";
    enableWSL = true;
    disableEmacsDaemon = true;
    gitSigningKey = "0x9DE06C73577F75A5!";
    waylandTools = true;
    devtools.enable = true;
    texlive = true;
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
