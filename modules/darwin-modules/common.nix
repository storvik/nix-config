{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = {

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;
    # nix.package = pkgs.nix;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Rosetta gives us x86_64-darwin
    nix.extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    nixpkgs.config = {
      allowBroken = true;
      allowUnfree = true;
    };

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true; # default shell on catalina
    programs.fish.enable = true;

    system.defaults = {
      dock = {
        autohide = true;
        orientation = "left";
        show-process-indicators = false;
        show-recents = false;
        static-only = true;
        mru-spaces = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
      };
      screensaver.askForPasswordDelay = 10;
      # Disable animation when switching screens or opening apps
      # universalaccess.reduceMotion = true;

      # Apple menu > System Preferences > Mission Control
      # Displays have separate Spaces (note a logout is required before this setting will take effect).
      # spaces.spans-displays = true;
    };

    fonts.packages = [
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.iosevka
      pkgs.nerdfonts
    ];

  };

}
