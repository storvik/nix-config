{ self, inputs, nixosSystem }:

let

  inherit (inputs) home-manager nixpkgs hyprland sops-nix;

in

{

  mkHome = { username, hostname, pkgs ? nixpkgs, system ? "x86_64-linux", extraModules ? [ ], ... }@args:

    let
      hostConfig = import "${self}/hosts/${hostname}/";
    in

    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        # Hyprland modules
        hyprland.homeManagerModules.default
        # My additional modules must be imported
        ("${self}/modules")
        ("${self}/modules/home-manager")
        # Inline module with some basic hm setup and my custom host setup
        {
          home = {
            username = "${username}";
            homeDirectory = "/home/${username}";
          };
          "${username}" = hostConfig;
        }
      ] ++ extraModules ++ nixpkgs.lib.optional (builtins.pathExists "${self}/hosts/${hostname}/home.nix") ("${self}/hosts/${hostname}/home.nix");

      extraSpecialArgs = {
        inherit inputs;
      };

    };

  mkSystem = { username, hostname, machine, pkgs ? nixpkgs, system ? "x86_64-linux", extraModules ? [ ], ... }@args:

    let
      hostConfig = import "${self}/hosts/${hostname}/";
      # TODO: Is this really the best way to add host specific nixos config??
      nixosConfig = import "${self}/hosts/${hostname}/nixos.nix" {
        inherit pkgs;
      };
    in

    nixosSystem {
      inherit system pkgs;

      modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${username}" = { config, pkgs, ... }: {
            imports = [
              # Hyprland modules
              (hyprland.homeManagerModules.default)
              ("${self}/modules")
              ("${self}/modules/home-manager")
            ] ++ nixpkgs.lib.optional (builtins.pathExists "${self}/hosts/${hostname}/home.nix") ("${self}/hosts/${hostname}/home.nix");
            "${username}" = hostConfig;
          };
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
        ({ config, pkgs, ... }: {
          imports = [
            (sops-nix.nixosModules.sops)
            ("${self}/machines/${machine}")
            ("${self}/modules")
            ("${self}/modules/nixos")
          ] ++ extraModules ++ nixpkgs.lib.optional (builtins.pathExists "${self}/hosts/${hostname}/nixos.nix") ("${self}/hosts/${hostname}/nixos.nix");
          "${username}" = hostConfig;
          networking.hostName = hostname;
          networking.firewall.enable = false;
        })
      ];

      specialArgs = {
        inherit inputs pkgs;
      };
    };


}
