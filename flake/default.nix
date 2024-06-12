{ self, inputs }:

let

  inherit (inputs) home-manager ironbar nixpkgs hyprland sops-nix nixos-wsl nix-index-database;

in

{

  mkSystem = { hostname, machine, pkgs ? nixpkgs, system ? "x86_64-linux", extraModules ? [ ], ... }@args:

    nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.storvik = { config, pkgs, ... }: {
            imports = [
              (nix-index-database.hmModules.nix-index)
              (hyprland.homeManagerModules.default)
              (ironbar.homeManagerModules.default)
              (self.outputs.homeManagerModules.default)
              ("${self}/hosts/${hostname}/home.nix")
            ];
          };
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
          home-manager.sharedModules = [
            (sops-nix.homeManagerModules.sops)
          ];
        }
        ({ config, pkgs, ... }: {
          imports = [
            # (nix-index-database.nixosModules.nix-index)
            (sops-nix.nixosModules.sops)
            (nixos-wsl.nixosModules.wsl)
            (self.outputs.nixosModules.default)
            ("${self}/machines/${machine}")
            ("${self}/hosts/${hostname}/nixos.nix")
          ] ++ extraModules;
          networking.hostName = hostname;
        })
      ];

      specialArgs = {
        inherit inputs;
      };
    };

}
