{ nixpkgs, lib, pkgs, runCommand, mdbook, nixosOptionsDoc }:

let
  hmDoc = nixosOptionsDoc {
    inherit ((lib.evalModules {
      modules = [
        ../modules/hm-modules/options.nix
        { _module.args.pkgs = pkgs; }
      ];
    })) options;
  };

in
runCommand "hm-options.md" { } ''cat ${hmDoc.optionsCommonMark} >> $out''
