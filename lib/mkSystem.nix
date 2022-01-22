{ self
, home-manager
, nixosSystem
, username
, hostname
, machine
, pkgs
, system
, inputs
, extraModules ? [ ]
, ...
}@args:

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
}
