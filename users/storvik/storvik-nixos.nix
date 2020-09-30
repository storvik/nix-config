{ config, pkgs, lib, ... }:

{

  # Set up nixos user
  users.users.storvik = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "audio"
      "video"
    ];
  };
  
}
