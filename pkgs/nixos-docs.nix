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

runCommand "options.md" { } ''sed -e 's|file\(.*\)source|https://github.com/storvik/nix-config|' ${nixosDoc.optionsCommonMark} | sed -e 's|/nix/store/\(.*\)source|https://github.com/storvik/nix-config|' >> $out''
