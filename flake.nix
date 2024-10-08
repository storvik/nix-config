{
  description = "Storviks Nix configuration";

  nixConfig.bash-prompt = "❄ nix-develop > ";

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    deploy-rs.url = "github:serokell/deploy-rs";

    # https://github.com/NixOS/nixpkgs/pull/67576
    pr67576.url = "github:jtojnar/nixpkgs/gimp-meson";

  };

  outputs = { self, nixpkgs, nixos-wsl, nix-darwin, sops-nix, deploy-rs, pr67576, ... }@inputs:
    let

      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;

      flakeLib = import ./flake {
        inherit self inputs;
      };

      inherit (flakeLib) mkSystem mkDarwin;

    in
    {

      nixosModules.default = import ./modules/module.nix inputs { };
      homeManagerModules.default = import ./modules/hm-module.nix inputs { };
      darwinModules.default = import ./modules/darwin-module.nix inputs { };

      packages = {
        hm-docs = nixpkgs.callPackage ./pkgs/hm-docs.nix { inherit nixpkgs; };
        nixos-docs = nixpkgs.callPackage ./pkgs/nixos-docs.nix { inherit nixpkgs; };
        # TODO: Add darwin docs
      };

      nixosConfigurations = {
        kalinix = mkSystem {
          username = "storvik";
          hostname = "kalinix";
          machine = "lenovo-e31";
        };
        storvik-nixos-matebook = mkSystem {
          username = "storvik";
          hostname = "storvik-nixos-matebook";
          machine = "matebook";
        };
        home-server = mkSystem {
          username = "storvik";
          hostname = "home-server";
          machine = "intel-nuc";
        };
        retronix = mkSystem {
          username = "storvik";
          hostname = "retronix";
          machine = "samsung-rc720";
        };
        storvik-nixos-wsl = mkSystem {
          hostname = "storvik-nixos-wsl";
          machine = "wsl";
        };
        live-iso = mkSystem {
          username = "storvik";
          hostname = "storvik-live";
          machine = "live";
          extraModules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ({ config, pkgs, ... }: {
              # less compression to save time when building image
              isoImage.squashfsCompression = "gzip -Xcompression-level 1";
            })
          ];
        };
      };

      darwinConfigurations = {
        PSTORVIK-MBP14 = mkDarwin {
          username = "petter.storvik";
          hostname = "PSTORVIK-MBP14";
        };
      };

      # For convenience when running nix build
      live-iso = self.nixosConfigurations.live-iso.config.system.build.isoImage;
      darwinPackages = self.darwinConfigurations."PSTORVIK-MBP14".pkgs;

      deploy.nodes = {
        home-server = {
          sshUser = "storvik";
          sshOpts = [ "-A" ];
          hostname = "192.168.1.14";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.home-server;
          };
        };
        retronix = {
          sshUser = "storvik";
          sshOpts = [ "-A" ];
          hostname = "192.168.1.181";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.retronix;
          };
        };
        kalinix = {
          sshUser = "storvik";
          sshOpts = [ "-A" ];
          hostname = "192.168.0.187";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.kalinix;
          };
        };
      };

      # This is highly advised, and will prevent many possible mistakes, taken from deploy-rs docs
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in {
          default = pkgs.mkShell {
            buildInputs = [
              deploy-rs.defaultPackage."${system}"
              pkgs.sops
            ];
          };
        });
    };
}
