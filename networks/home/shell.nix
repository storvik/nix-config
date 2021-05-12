let

  commitRev = "1f1a77bdb748df4615aa303121f5cecf3ca937cc";

  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${commitRev}.tar.gz";
    sha256 = "sha256:0m3l5kmmyzq8q2xdj2jpc8zmlm62z1v07zbpzdz1i5b43m307f42";
  };

  pkgs = import nixpkgs { config = { }; };

in

pkgs.mkShell {

  buildInputs = [ pkgs.morph ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgs}:."
  '';

}
