{ config, pkgs, ... }:

{

  storvik = {
    virtualization = true;
  };

  services.emacs = {
    enable = false;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  homebrew = {
    enable = true;
    casks = [
      "coolterm"
      "signal"
      "slack"
      "syncthing"
    ];
  };

}
