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

    nixpkgs.config = {
      allowBroken = true;
      allowUnfree = true;
    };

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true; # default shell on catalina
    programs.fish.enable = true;

    fonts.packages = [
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.iosevka
      pkgs.nerdfonts
    ];

  };

}
