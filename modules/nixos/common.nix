{ pkgs, inputs, ... }:

{

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  console.keyMap = "us";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  environment.systemPackages = with pkgs; [
    debootstrap
    gparted
    ventoy-full
  ];

}
