{ config, pkgs, lib, ... }:

with lib;

let

  rcloneSyncDirsOpts = {
    options = {
      remote = mkOption {
        type = types.str;
        example = "pcloud";
        description = ''
          Remote to be synced from / to. Important that this remote
          is set up using `rclone config`. This has to be done manually.
        '';
      };

      source = mkOption {
        type = types.str;
        example = "/home/user/folder/";
        description = ''
          Source directory to be synced.
        '';
      };

      dest = mkOption {
        type = types.str;
        example = "pcloud:folder/";
        description = ''
          Destination directory to be synced into.
        '';
      };
    };
  };

  rcloneSyncOpts = { name, config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        readOnly = true;
        description = "Unique identifier of rclone sync service.";
      };

      enableService = mkEnableOption "Enable systemd sync service.";

      enableTimer = mkEnableOption "Enable systemd timer for sync service.";

      afterboot = mkOption {
        type = types.str;
        default = "15m";
        description = ''
          After boot, when should the first instance of sync service
          be run. Should match OnBootSec in systemd docs.
        '';
      };

      interval = mkOption {
        type = types.str;
        default = "15m";
        description = ''
          Specify interval of when service should run. Should match
          OnUnitInactiveSec in systemd docs.
        '';
      };

      syncdirs = mkOption {
        type = types.listOf (types.submodule rcloneSyncDirsOpts);
        description = ''
          Attribute sets that describes directories that should be
          synced. Every string should match the string expected by
          rclone sync command.
        '';
      };
    };
  };

in

{

  options.storvik = {

    browser.enable = mkOption {
      default = true;
      description = "Enable web browsers";
      type = lib.types.bool;
    };

    emacs.enable = mkOption {
      default = true;
      description = "Enable the all mighty emacs";
      type = lib.types.bool;
    };

    emacs.nativeComp = mkEnableOption "Enable Emacs native compile";

    emacs.daemon = mkEnableOption "Enable Emacs daemon";

    shell.enable = mkOption {
      default = true;
      description = "Enable shell setup and shell tools";
      type = lib.types.bool;
    };

    ##
    # User specific options
    ##

    user.storvik.enable = mkEnableOption "Enable storvik user";

    ##
    # OS dependant
    ##

    genericLinux.enable = mkEnableOption "Enable if generic linux with nix, not nixos, is used";

    wsl = {

      enable = mkEnableOption "Enable wsl support, genericLinux should be enabled if this is true";

      gwsl = mkEnableOption "Enable graphical wsl support, setting display envs";

    };

    remotelogin.enable = mkEnableOption "Enable remote login, ssh / vnc etc";

    ##
    # Developer tools
    ##

    developer.enable = mkEnableOption "Enable all developer tools";

    developer.android.enable = mkEnableOption "Enable android developer tools";

    developer.c.enable = mkEnableOption "Enable C / C++ developer tools";

    developer.game.enable = mkEnableOption "Enable game development with godot";

    developer.go.enable = mkEnableOption "Enable Go developer tools";

    developer.lisp.enable = mkEnableOption "Enable Lisp developer tools";

    developer.nix.enable = mkEnableOption "Enable Nix developer tools";

    developer.python.enable = mkEnableOption "Enable Python developer tools";

    developer.shell.enable = mkEnableOption "Enable Shell developer tools";

    developer.web.enable = mkEnableOption "Enabel web developer tools";

    ##
    # Desktop related settings
    ##

    gnome.enable = mkEnableOption "GNOME";

    sway.enable = mkEnableOption "Sway";

    kde.enable = mkEnableOption "KDE";

    sound.enable = mkEnableOption "Enable sound";

    kanata.enable = mkEnableOption "Enable kanata keyboard management";

    ##
    # Software collections
    ##

    entertainment.enable = mkEnableOption "Games";

    forensics.enable = mkEnableOption "Computer forensics tools";

    forensics.modules = mkOption {
      default = [ ];
      description = ''
        List of strings that describes forensic modules to enable.
        [
          "reverse" # reverse engineering
          "recon"   # reconnaissance
          "exploit" # exploitation
        ];
      '';
      type = lib.types.listOf lib.types.str;
    };

    graphics.enable = mkEnableOption "Graphics tools";

    media.enable = mkEnableOption "Media";

    social.enable = mkEnableOption "Social";

    texlive.enable = mkEnableOption "Install texlive";

    virtualization.enable = mkOption {
      default = true;
      description = "Enable virtualization tools and set some useful aliases";
      type = lib.types.bool;
    };

    work.enable = mkEnableOption "Work stuff";

    rclone = {
      enable = mkEnableOption "Enable rclone sync";
      syncs = mkOption {
        type = lib.types.attrsOf (lib.types.submodule rcloneSyncOpts);
        default = { };
        description = "List of rclone sync services.";
      };

    };

  };

}
