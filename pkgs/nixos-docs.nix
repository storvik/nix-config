{ nixpkgs, lib, pkgs, runCommand, mdbook, nixosOptionsDoc }:

let
  nixosDoc = nixosOptionsDoc {
    inherit ((lib.evalModules {
      modules = [
        ../modules/nixos/options.nix
        { _module.args.pkgs = pkgs; }
      ];
    })) options;
  };

in
runCommand "options.md" { } ''cat ${nixosDoc.optionsCommonMark} >> $out''
