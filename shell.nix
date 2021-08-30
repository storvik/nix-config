{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "nixbuildshell";
  nativeBuildInputs = with pkgs; [
    git
    nixUnstable
  ];

  shellHook = ''
    PATH=${pkgs.writeShellScriptBin "nix" ''
      ${pkgs.nixUnstable}/bin/nix --option experimental-features "nix-command flakes" "$@"
    ''}/bin:$PATH
  '';
}
