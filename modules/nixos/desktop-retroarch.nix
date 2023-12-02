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

  config = lib.mkIf (cfg.desktop == "retroarch") {

    storvik.sound = lib.mkDefault true;

    # Enable network manager
    networking.networkmanager.enable = true;

    services = {

      xserver = {

        # Enable the X11 windowing system.
        enable = true;
        layout = "us";
        xkbModel = "pc105";
        xkbVariant = "altgr-intl";
        xkbOptions = "ctrl:nocaps";

        # Enable touchpad support.
        libinput.enable = true;

        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = true;

      };

    };

    services.xserver.displayManager.autoLogin = lib.mkIf (cfg.autoLoginUser) {
      enable = true;
      user = cfg.autoLoginUser;
    };

    services.xserver.desktopManager.retroarch = {
      enable = true;
      package = custom-retroarch;
    };

  };

}
