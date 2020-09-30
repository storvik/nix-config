{ config, pkgs, lib, ... }:

let

  # Import home-manager, must be done in order to use home-manager.users.<user> with mkMerge
  home-base = import ../users/storvik/storvik-base.nix { inherit pkgs config lib; };
  home-gui = import ../users/storvik/storvik-gui.nix { inherit pkgs config lib; };

in

{

  # Must allow unfree licence for android studio
  nixpkgs.config.allowUnfree = true;

  imports = [
    (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-20.03.tar.gz}/nixos")
    ../users/storvik/storvik-nixos.nix   # NixOS user config
    ../desktops/gnome-nixos/default.nix
    ../machines/lenovo-e31/default.nix
    #../dotfiles/storvik-ubuntu-matebook/default.nix
  ];

  # Merge home-manager configs
  home-manager.users.storvik = lib.mkMerge [ home-base home-gui ];

  # Computer hostname
  networking.hostName = "storvik-nixos";
  
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
  
}
