inputs: { config, lib, pkgs, ... }:
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

    # This line is a prerequisite
    nix.settings.trusted-users = [ "@admin" ];

    # Nifty linux builder
    nix.linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 6;
        };
      };
    };

    nixpkgs.config = {
      allowBroken = true;
      allowUnfree = true;
    };

    # Use nixpkgs from this flake in nix-shell etc
    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    nix.channel.enable = false;

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true; # default shell on catalina
    programs.bash.enable = true;
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
        CreateDesktop = false;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        ShowPathbar = true;
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
    security.pam.enableSudoTouchIdAuth = true;
    ];

  };

}
