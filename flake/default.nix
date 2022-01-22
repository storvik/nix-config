{ self, inputs, nixosSystem }:

let

  inherit (inputs) home-manager nixpkgs;

in

{

  mkHome = { username, hostname, pkgs ? nixpkgs, system, ... }@args:

    let
      hostConfig = import "${self}/hosts/${hostname}.nix";
    in

    home-manager.lib.homeManagerConfiguration {

      inherit system pkgs;
      username = "${username}";
      homeDirectory = "/home/${username}";
      configuration = { config, pkgs, ... }:
        {
          "${username}" = hostConfig;
        };

      extraModules = [
        ("${self}/modules")
        ("${self}/modules/home-manager")
      ];

      extraSpecialArgs = {
        inherit inputs;
      };

    };

  mkSystem = { username, hostname, machine, pkgs ? nixpkgs, system, extraModules ? [ ], ... }@args:

    let
      hostConfig = import "${self}/hosts/${hostname}.nix";
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
              ("${self}/modules")
              ("${self}/modules/home-manager")
            ];
            "${username}" = hostConfig;
          };
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
        ({ config, pkgs, ... }: {
          imports = [
            ("${self}/machines/${machine}")
            ("${self}/modules")
            ("${self}/modules/nixos")
          ] ++ extraModules;
          "${username}" = hostConfig;
          networking.hostName = hostname;
          networking.firewall.enable = false;
        })
      ];

      specialArgs = {
        inherit inputs;
      };
    };


}
