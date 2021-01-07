{ config, pkgs, lib, ... }:

{

  imports = [
    ./developer/android.nix
    ./developer/c.nix
    ./developer/golang.nix
    ./developer/lisp.nix
    ./developer/nix.nix
    ./developer/python.nix
    ./developer/webdev.nix
  ];

  # Try lorri https://github.com/target/lorri
  # services.lorri.enable = true;
  # Decided to try nix-direnv first https://github.com/nix-community/nix-direnv
  # This mostly due to the lorri daemon

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

}
