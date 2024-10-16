{ self, inputs }:

let

  inherit (inputs) home-manager nixpkgs emacs-overlay hyprland sops-nix nixos-wsl nix-index-database nix-darwin nix-homebrew homebrew-cask homebrew-core homebrew-bundle mac-app-util pr67576;

in

{

  mkSystem = { hostname, machine, pkgs ? nixpkgs, system ? "x86_64-linux", extraModules ? [ ], ... }@args:
    let

      # gimp devel pgks
      pr67576pkgs = import pr67576 {
        inherit system;
      };

      # TODO: This should be moved to functon / let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
          packageOverrides = pkgs: {
            gimp = pr67576pkgs.gimp;
          };
        };
        overlays = [
          (import "${self}/overlays")
          emacs-overlay.outputs.overlay
        ];
      };

    in
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

  mkDarwin = { hostname, username ? "storvik", system ? "aarch64-darwin", extraModules ? [ ], ... }@args:
    let

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
        };
        overlays = [
          emacs-overlay.outputs.overlay
          (import "${self}/overlays")
        ];
      };

    in
    nix-darwin.lib.darwinSystem {
      inherit system pkgs;

      modules = [
        (self.outputs.darwinModules.default)
        ("${self}/hosts/${hostname}/darwin.nix")
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            users."${username}" = { config, pkgs, ... }: {
              imports = [
                (self.outputs.homeManagerModules.default)
                ("${self}/hosts/${hostname}/home.nix")
                mac-app-util.homeManagerModules.default
                (nix-index-database.hmModules.nix-index)
              ];
            };
            extraSpecialArgs = {
              inherit inputs;
            };
            sharedModules = [
              (sops-nix.homeManagerModules.sops)
            ];
          };
          users.users."${username}".home = "/Users/${username}";

          # Set Git commit hash for darwin-version.]
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = system;
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;

            user = username;

            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };

            mutableTaps = false;
            autoMigrate = true;
          };
        }
      ] ++ extraModules;

      specialArgs = {
        inherit inputs;
      };
    };

}
