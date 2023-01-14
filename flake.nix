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
          extraModules = [
            # TODO: Should figure out a better way to do this.
            # Mabe add a homeConfig and sysConfig to mkHome and mkSystem.
            ({ config, pkgs, ... }: {
              services.xserver.displayManager.autoLogin = {
                enable = true;
                user = "storvik";
              };
              # Moung network drive, more info here https://nixos.wiki/wiki/Samba
              environment.systemPackages = [ pkgs.cifs-utils ];
              fileSystems."/run/mnt/storvik-backup" = {
                device = "//192.168.0.96/StorvikBackup";
                fsType = "cifs";
                options =
                  let
                    # this line prevents hanging on network split
                    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

                  in
                  [ "credentials=/etc/nixos/smb-secrets,credentials=/etc/nixos/smb-secrets,vers=1.0,rw,nounix,uid=1000,gid=100" ];
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
