inputs: { ... }:

{

  imports = [
    ./nixos/options.nix
    (import ./nixos/common.nix inputs)
    ./nixos/kanata.nix
    ./nixos/desktop-hyprland.nix
    ./nixos/desktop-gnome.nix
    ./nixos/sound.nix
    ./nixos/wsl.nix
    ./nixos/backup.nix
    ./nixos/remote.nix
    ./nixos/games.nix
  ];

}
