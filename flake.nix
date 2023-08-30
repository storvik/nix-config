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

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    deploy-rs.url = "github:serokell/deploy-rs";

    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };

    # https://github.com/NixOS/nixpkgs/pull/67576
    pr67576.url = "github:jtojnar/nixpkgs/gimp-meson";

  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, nixos-wsl, deploy-rs, nixGL, pr67576, ... }@inputs:
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
      };

      inherit (flakeLib) mkSystem;
    in
    {

      nixosModules.default = import ./modules/module.nix inputs { };
      homeManagerModules.default = import ./modules/hm-module.nix inputs { };

      packages = {
        hm-docs = pkgs.callPackage ./pkgs/hm-docs.nix { inherit nixpkgs; };
        nixos-docs = pkgs.callPackage ./pkgs/nixos-docs.nix { inherit nixpkgs; };
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
        storvik-nixos-wsl = mkSystem {
          inherit pkgs system;
          hostname = "storvik-nixos-wsl";
          machine = "wsl";
        };
        live-iso = mkSystem {
          inherit pkgs system;
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

      # For convenience when running nix build
      live-iso = self.nixosConfigurations.live-iso.config.system.build.isoImage;

      deploy.nodes.storvik-nixos-nuc = {
        sshUser = "storvik";
        hostname = "192.168.0.121";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.storvik-nixos-nuc;
        };
      };

      devShell."${system}" = pkgs.mkShell {
        buildInputs = [
          deploy-rs.defaultPackage."${system}"
        ];
      };

    };
}
