{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.emacs.enable = mkOption {
    default = true;
    description = "Enable the all mighty emacs";
    type = lib.types.bool;
  };

  options.storvik.emacs.nativeComp = mkEnableOption "Enable Emacs native compile";

  options.storvik.shell.enable = mkOption {
    default = true;
    description = "Enable shell setup and shell tools";
    type = lib.types.bool;
  };

  ##
  # User specific options
  ##

  options.storvik.user.storvik.enable = mkEnableOption "Enable storvik user";

  options.storvik.email.enable = mkEnableOption "Email settings for storvik user";

  ##
  # OS dependant
  ##

  options.storvik.genericLinux.enable = mkEnableOption "Enable if generic linux with nix, not nixos, is used";

  ##
  # Developer tools
  ##

  options.storvik.developer.enable = mkEnableOption "Enable all developer tools";

  options.storvik.developer.android.enable = mkEnableOption "Enable android developer tools";

  options.storvik.developer.c.enable = mkEnableOption "Enable C / C++ developer tools";

  options.storvik.developer.go.enable = mkEnableOption "Enable Go developer tools";

  options.storvik.developer.lisp.enable = mkEnableOption "Enable Lisp developer tools";

  options.storvik.developer.nix.enable = mkEnableOption "Enable Nix developer tools";

  options.storvik.developer.powershell.enable = mkEnableOption "Enable Powershell developer tools";

  options.storvik.developer.python.enable = mkEnableOption "Enable Python developer tools";

  options.storvik.developer.shell.enable = mkEnableOption "Enable Shell developer tools";

  options.storvik.developer.web.enable = mkEnableOption "Enabel web developer tools";

  ##
  # Desktop related settings
  ##

  options.storvik.gnome.enable = mkEnableOption "GNOME";

  options.storvik.sway.enable = mkEnableOption "Sway";

  options.storvik.kde.enable = mkEnableOption "KDE";

  ##
  # Software collections
  ##

  options.storvik.graphics.enable = mkEnableOption "Graphics tools";

  options.storvik.media.enable = mkEnableOption "Media";

  options.storvik.texlive.enable = mkEnableOption "Install texlive";

  options.storvik.virtualization.enable = mkOption {
    default = true;
    description = "Enable virtualization tools and set some useful aliases";
    type = lib.types.bool;
  };

  options.storvik.work.enable = mkEnableOption "Work stuff";

}
