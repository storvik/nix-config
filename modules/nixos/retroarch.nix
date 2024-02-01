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

  config = lib.mkIf (cfg.retroarch) {

    environment.systemPackages = with pkgs; [
      custom-retroarch
    ];

  };

}
