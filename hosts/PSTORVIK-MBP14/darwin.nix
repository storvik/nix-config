{ config, pkgs, ... }:

{

  environment.systemPackages = [ ];

  services.emacs = {
    enable = false;
    # package = pkgs.emacs-pgtk;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

}
