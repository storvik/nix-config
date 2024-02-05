{ config, lib, pkgs, ... }:
let

  cfg = config.storvik;

  custom-retroarch = with pkgs; (retroarch.override {
    cores = with libretro; [
      beetle-psx-hw
      dolphin
      genesis-plus-gx
      mgba
      mupen64plus
      nestopia
      pcsx2
      pcsx-rearmed
      snes9x
      quicknes
      vba-next
    ];
  });

in
{

  config = lib.mkIf (cfg.games.enable) {

    programs.steam = {
      enable = (!builtins.elem "steam" cfg.games.disabledModules);
    };

    environment.systemPackages = with pkgs; [
    ] ++ lib.optionals (!builtins.elem "retroarch" cfg.games.disabledModules) [
      custom-retroarch
    ];

  };

}
