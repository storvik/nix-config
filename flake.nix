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

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Check if it's possible to wrap packages when generic linux is used
    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, kmonad, nixGL, ... }@inputs:
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
          kmonad.overlays.default
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
        };
      };
      nixosConfigurations = {
        storvik-nixos-lenovo = mkSystem {
          inherit pkgs system;
          username = "storvik";
          hostname = "storvik-nixos-lenovo";
          machine = "lenovo-e31";
        };
        storvik-nixos-nuc = mkSystem {
          inherit pkgs system;
          username = "storvik";
          hostname = "storvik-nixos-nuc";
          machine = "intel-nuc";
          extraModules = [
            # TODO: Should figure out a better way to do this.
            # Mabe add a homeConfig and sysConfig to mkHome and mkSystem.
            ({ config, pkgs, ... }: {
              services.xserver.displayManager.autoLogin = {
                enable = true;
                user = "storvik";
              };
            })
          ];
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
