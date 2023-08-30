{ config, lib, ... }:

let

  backupSyncs = {
    options = {
      synctype = lib.mkOption {
        type = lib.types.str;
        example = "rclone";
        description = ''
          Should rclone or rsync be used.
        '';
      };

      source = lib.mkOption {
        type = lib.types.str;
        example = "/home/user/folder/";
        description = ''
          Source directory to be synced.
        '';
      };

      dest = lib.mkOption {
        type = lib.types.str;
        example = "pcloud:folder/";
        description = ''
          Destination directory to be synced into.
        '';
      };

      delete = lib.mkOption {
        default = true;
        description = "If true, delete files in destination";
        type = lib.types.bool;
      };
    };
  };

in

{

  options.storvik = {
    desktop = lib.mkOption {
      type = lib.types.enum [
        "none"
        "gnome"
        "hyprland"
      ];
      default = "none";
      description = lib.mdDoc ''
        Which desktop to use, if any.
      '';
    };
    disableLoginManager =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Disable login manager.
        '';
      };
    kanata =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable kanata, a software keyboard remapper.
          https://github.com/jtroo/kanata
        '';
      };
    sound =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable sound using pipewire.
        '';
      };
    enableWSL =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable WSL specific config.
        '';
      };
    remoteLogon =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable SSH.
        '';
      };
    backup = {
      enable = lib.mkEnableOption "Enable nightly backup";
      folders = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule backupSyncs);
        description = lib.mdDoc ''
          Attribute sets that describes directories that should be
          backed up. Every string should match the string expected by
          rclone or rsync command.
        '';
      };
    };
  };

}
