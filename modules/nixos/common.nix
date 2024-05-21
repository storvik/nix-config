inputs: { config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = {

    assertions = [
      {
        assertion = builtins.elem cfg.desktop [ "none" "gnome" "hyprland" ];
        message = "storvik.desktop got invalid value.";
      }
    ];

    system.stateVersion = lib.mkDefault "22.05";

    nix = {
      package = pkgs.nixVersions.git;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      registry.nixpkgs.flake = inputs.nixpkgs;
      settings = {
        trusted-users = [ "@wheel" ]; # allow users with sudo access run nix commands without sudo
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

    console.keyMap = "us";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # Set your time zone.
    time.timeZone = "Europe/Oslo";

    networking.firewall.enable = false;

    users.users.storvik = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "audio"
        "video"
        "adbusers"
      ];
    };

    environment.systemPackages = with pkgs; [
      debootstrap
    ] ++ lib.optionals (cfg.desktop != "none") [
      gparted
      ventoy-full
    ];

    programs.fish.enable = true;

    programs.adb.enable = true;

  };

}
