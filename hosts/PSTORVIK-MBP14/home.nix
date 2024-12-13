{ config, pkgs, ... }:

{

  storvik = {
    desktop = "none";
    disableEmail = true;
    gitSigningKey = "0x3B7A1B8284072C5A!";
    waylandTools = true;
    devtools.enable = true;
    designer = true;
    texlive = false;
    cad = false;
    ai.enable = true;
  };

  sops = {
    # gnupg.home = "/home/storvik/.gnupg"; # Using gpg didn't work, sops-nix service didn't start
    age.sshKeyPaths = [ "/Users/petter.storvik/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets.yaml;

    secrets.petter_storvik_dev = { };
    secrets.petter_svartisenfestivalen_no = { };
    secrets.petter_storvik_tive_com = { };

    secrets.openai_key = { };
    secrets.anthropic_key = { };
  };


}
