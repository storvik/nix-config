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

      nixgl-overlay = (final: prev: { nixGL = import nixGL { pkgs = final; }; });

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

      mkHome = import ./lib/mkHome.nix;
      mkSystem = import ./lib/mkSystem.nix;
    in
    {
      homeConfigurations = {
        storvik = mkHome {
          inherit self home-manager pkgs system inputs;
          username = "storvik";
          hostname = "storvik-ubuntu";
        };
      };
      nixosConfigurations = {
        storvik-nixos-lenovo = mkSystem {
          inherit self home-manager pkgs system inputs;
          inherit (nixpkgs.lib) nixosSystem;
          username = "storvik";
          hostname = "storvik-nixos-lenovo";
          machine = "lenovo-e31";
        };
        storvik-nixos-nuc = mkSystem {
          inherit self home-manager pkgs system inputs;
          inherit (nixpkgs.lib) nixosSystem;
          username = "storvik";
          hostname = "storvik-nixos-nuc";
          machine = "intel-nuc";
        };
        live-iso = mkSystem {
          inherit self home-manager pkgs system inputs;
          inherit (nixpkgs.lib) nixosSystem;
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
      live-iso = self.nixosConfigurations.live-iso.config.system.build.isoImage;
    };
}
