{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.user.storvik.enable = mkEnableOption "Enable storvik user";

  config = mkIf config.storvik.user.storvik.enable {

    # Set username and user home dir
    home.username = "storvik";
    home.homeDirectory = "/home/storvik";

    # Git
    programs.git = {
      enable = true;
      userEmail = "petterstorvik@gmail.com";
      userName = "storvik";
      extraConfig = {
        pull.ff = "only";
      };
      ignores = [
        ".ccls*"
        "npm-debug.log"
        ".DS_Store"
        "Thumbs.db"
        ".dir-locals.el"
        "compile_commands.json"
        ".envrc"
        ".direnv"
      ];
    };

  };

}


# users.users.storvik = {
#   isNormalUser = true;
#   extraGroups = [
#     "wheel" # Enable ‘sudo’ for the user.
#     "networkmanager"
#     "audio"
#     "video"
#   ];
# };
