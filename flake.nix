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

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    # TODO: Check if it's possible to wrap packages when generic linux is used
    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };

    # https://github.com/NixOS/nixpkgs/pull/67576
    pr67576.url = "github:jtojnar/nixpkgs/gimp-meson";

  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, nixGL, pr67576, ... }@inputs:
    let
      system = "x86_64-linux";

      nixgl-overlay = (final: prev: { nixGL = import nixGL { pkgs = final; }; });

      # gimp devel pgks
      pr67576pkgs = import pr67576 {
        inherit system;
      };

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
          (import ./overlays)
          emacs-overlay.outputs.overlay
          nixgl-overlay
        ];
      };

      flakeLib = import ./flake {
        inherit self inputs;
        inherit (nixpkgs.lib) nixosSystem;
      };

      inherit (flakeLib) mkHome mkSystem;
    in
    {
      homeConfigurations = {
        storvik = mkHome {
          inherit pkgs system;
          username = "storvik";
          hostname = "storvik-ubuntu";
        };
        storvik-wsl = mkHome {
          inherit pkgs system;
          username = "storvik";
          hostname = "storvik-wsl";
          extraModules = [
            ({ config, pkgs, ... }: {
              services.syncthing.enable = true;
            })
          ];
        };
      };
      nixosConfigurations = {
        storvik-nixos-lenovo = mkSystem {
          inherit pkgs system;
          username = "storvik";
          hostname = "storvik-nixos-lenovo";
          machine = "lenovo-e31";
        };
        storvik-nixos-matebook = mkSystem {
          inherit pkgs system;
          username = "storvik";
          hostname = "storvik-nixos-matebook";
          machine = "matebook";
        };
        storvik-nixos-nuc = mkSystem {
          inherit pkgs system;
          username = "storvik";
          hostname = "storvik-nixos-nuc";
          machine = "intel-nuc";
        };
        live-iso = mkSystem {
          inherit pkgs system;
          username = "storvik";
          hostname = "storvik-live";
          machine = "live";
          extraModules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
          ];
        };
      };

      # For convenience when running nix build
      storvik-ubuntu = self.homeConfigurations.storvik.activationPackage;
      storvik-wsl = self.homeConfigurations.storvik-wsl.activationPackage;
      live-iso = self.nixosConfigurations.live-iso.config.system.build.isoImage;
    };
}
