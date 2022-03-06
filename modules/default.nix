{ config, pkgs, lib, ... }:

with lib;

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

    rclonesync.enable = mkEnableOption "pCloud sync";

    rclonesync.syncdirs = mkOption {
      default = [ ];
      description = ''
        Should be a list of attribute sets with source and dests. Example:
        [
          {
            remote = "pcloud";
            source = "/home/storvik/developer/svartisenfestivalen/";
            dest = "svartisenfestivalen/";
          }
          {
            remote = "pcloud";
            source = "/home/storvik/developer/org/";
            dest = "org/";
          }
        ];
      '';
    };

  };

}
