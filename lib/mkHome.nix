{ self
, home-manager
, username
, hostname
, pkgs
, inputs
, system
, ...
}@args:

let
  hostConfig = import "${self}/hosts/${hostname}.nix";
in

home-manager.lib.homeManagerConfiguration {

  inherit system pkgs;
  username = "${username}";
  homeDirectory = "/home/${username}";
  configuration = { config, pkgs, ... }:
    {
      "${username}" = hostConfig;
    };

  extraModules = [
    ("${self}/modules")
    ("${self}/modules/home-manager")
  ];

  extraSpecialArgs = {
    inherit inputs;
  };

}
