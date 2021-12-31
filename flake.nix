{
  description = "Storviks Nix configuration";

  nixConfig.bash-prompt = "❄ nix-develop > ";

  inputs = {

    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    # TODO: Check if it's possible to wrap packages when generic linux is used
    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, nixGL, ... }@inputs:
    let
      system = "x86_64-linux";

      nixgl-overlay =
        (final: prev: { nixGL = import nixGL { pkgs = final; }; });

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
        };
        overlays = [
          (import ./overlays)
          emacs-overlay.outputs.overlay
          nixgl-overlay
        ];
      };

      inherit (nixpkgs) lib;
    in
    {
      homeManagerConfigurations = {
        storvik = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "storvik";
          homeDirectory = "/home/storvik";
          stateVersion = "21.03";
          configuration = { config, pkgs, ... }:
            {
              #nixpkgs.overlays = [ emacs-overlay.outputs.overlay nixgl-overlay ];
              storvik = {
                user.storvik.enable = true;
                genericLinux.enable = true;
                email.enable = true;
                developer.enable = true;
                emacs = {
                  nativeComp = true;
                  daemon = true;
                };
                texlive.enable = true;
                graphics.enable = true;
                media.enable = true;
                social.enable = true;
                work.enable = true;
                rclonesync.enable = true;
                rclonesync.syncdirs = [
                  {
                    remote = "pcloud";
                    source = "/home/storvik/developer/svartisenfestivalen/";
                    dest = "svartisenfestivalen/";
                  }
                  {
                    remote = "pcloud";
                    source = "/home/storvik/developer/org/";
                    dest = "org/";
                  }
                ];
              };
            };

          extraModules = [
            ./modules
            ./modules/home-manager
          ];

        };
      };
      nixosConfigurations = {
        storvik-nixos-lenovo =
          let
            cfg = {
              user.storvik.enable = true;
              gnome.enable = true;
              emacs.daemon = true;
              developer.nix.enable = true;
              graphics.enable = false;
              media.enable = true;
              virtualization.enable = true;
            };
          in
          lib.nixosSystem {
            inherit system pkgs;

            modules = [
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.storvik = { config, pkgs, ... }: {
                  imports = [
                    ./modules
                    ./modules/home-manager
                  ];
                  storvik = cfg;
                };
              }
              ({ config, pkgs, ... }: {
                imports = [
                  ./machines/lenovo-e31
                  ./modules
                  ./modules/nixos
                ];
                storvik = cfg;
                networking.hostName = "storvik-nixos-lenovo";
                services.openssh.enable = true;
                networking.firewall.enable = false;
                system.stateVersion = "21.11";
              })
            ];
          };
        storvik-nixos-nuc =
          let
            cfg = {
              user.storvik.enable = true;
              gnome.enable = true;
              emacs = {
                nativeComp = false;
                daemon = true;
              };
              media.enable = true;
              developer.nix.enable = true;
              virtualization.enable = true;
            };
          in
          lib.nixosSystem {
            inherit system pkgs;

            modules = [
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.storvik = { config, pkgs, ... }: {
                  imports = [
                    ./modules
                    ./modules/home-manager
                  ];
                  storvik = cfg;
                };
              }
              ({ config, pkgs, ... }: {
                imports = [
                  ./machines/intel-nuc
                  ./modules
                  ./modules/nixos
                ];
                storvik = cfg;
                networking.hostName = "storvik-nixos-nuc";
                services.openssh.enable = true;
                networking.firewall.enable = false;
                system.stateVersion = "21.11";
              })
            ];
          };
        live-iso =
          let
            cfg = {
              gnome.enable = true;
            };
          in
          lib.nixosSystem {
            inherit system pkgs;

            modules = [
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
              ({ config, pkgs, ... }: {
                imports = [
                  ./modules
                  ./modules/nixos
                ];
                storvik = cfg;
                networking.hostName = "storvik-nixos-live";
              })
            ];
          };
      };

      # For convenience when running nix build
      storvik-ubuntu = self.homeManagerConfigurations.storvik.activationPackage;
    };
}
