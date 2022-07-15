{ config, pkgs, lib, ... }:

with lib;

let

  storvik-kmonad = pkgs.writeScriptBin "storvik-kmonad" ''
    #!${pkgs.bash}/bin/bash

    declare -A keyboards=(
        [genericusb]=/dev/input/by-path/pci-0000:00:14.0-usb-0:1.3:1.0-event-kbd
        [huawei]=/dev/input/by-path/platform-i8042-serio-0-event-kbd
        [logimxkeys]=/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse
    )

    # order when searching for keyboards
    order=(
        "logimxkeys"
        "genericusb"
        "huawei"
    )

    for k in "''${order[@]}"
    do
        if [ -L "''${keyboards[$k]}" ]; then
            cfgfile=".keymaps/$k.kbd"
            break
        fi
    done

    if [ -z ''${cfgfile+x} ]; then
        echo "Could not detect keyboard, exiting"
        exit 1
    fi

    echo "Using config: $cfgfile"

    # Start kmonad with given config file
    ${pkgs.kmonad}/bin/kmonad $cfgfile
  '';

in

{

  config = mkIf config.storvik.kmonad.enable {

    home.packages = with pkgs; [
      kmonad
      storvik-kmonad
    ];

    systemd.user.services.kmonad = {
      Unit = {
        Description = "kmonad service";
      };
      Service = {
        Type = "simple";
        ExecStart = "${storvik-kmonad}/bin/storvik-kmonad";
      };
    };


    home.file.".keymaps/logimxkeys.kbd".text = ''
      (defcfg
        input  (device-file "/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse")
        output (uinput-sink "KMonad kbd")
        fallthrough true
      )

      ;; Define aliases for the keys needed for home row mods
      (defalias
        met_a (tap-hold-next-release 250 a lmet)
        alt_s (tap-hold-next-release 250 s lalt)
        ctl_d (tap-hold-next-release 250 d lctl)
        sft_f (tap-hold-next-release 250 f lsft)

        sft_j (tap-hold-next-release 250 j rsft)
        ctl_k (tap-hold-next-release 250 k rctl)
        alt_l (tap-hold-next-release 250 l lalt)
        met_; (tap-hold-next-release 250 ; rmet)
      )

      ;;  This defines home row mods without the win key
      (defsrc
        s    d    f    g    h    j    k    l
      )
      (deflayer homerowmods
        @alt_s   @ctl_d   @sft_f   g   h   @sft_j   @ctl_k   @alt_l
      )
    '';

    home.file.".keymaps/genericusb.kbd".text = ''
      (defcfg
        input (device-file "/dev/input/by-path/pci-0000:00:14.0-usb-0:1.3:1.0-event-kbd")
        output (uinput-sink "KMonad kbd")
        fallthrough true
      )

      ;; Define aliases for the keys needed for home row mods
      (defalias
        met_a (tap-hold-next-release 250 a lmet)
        alt_s (tap-hold-next-release 250 s lalt)
        ctl_d (tap-hold-next-release 250 d lctl)
        sft_f (tap-hold-next-release 250 f lsft)

        sft_j (tap-hold-next-release 250 j rsft)
        ctl_k (tap-hold-next-release 250 k rctl)
        alt_l (tap-hold-next-release 250 l lalt)
        met_; (tap-hold-next-release 250 ; rmet)
      )

      ;;  This defines home row mods without the win key
      (defsrc
        s    d    f    g    h    j    k    l
      )
      (deflayer homerowmods
        @alt_s   @ctl_d   @sft_f   g   h   @sft_j   @ctl_k   @alt_l
      )
    '';

    home.file.".keymaps/huawei.kbd".text = ''
      (defcfg
        input  (device-file "/dev/input/by-path/platform-i8042-serio-0-event-kbd")
        output (uinput-sink "KMonad kbd")
        fallthrough true
      )

      ;; Define aliases for the keys needed for home row mods
      (defalias
        met_a (tap-hold-next-release 250 a lmet)
        alt_s (tap-hold-next-release 250 s lalt)
        ctl_d (tap-hold-next-release 250 d lctl)
        sft_f (tap-hold-next-release 250 f lsft)

        sft_j (tap-hold-next-release 250 j rsft)
        ctl_k (tap-hold-next-release 250 k rctl)
        alt_l (tap-hold-next-release 250 l lalt)
        met_; (tap-hold-next-release 250 ; rmet)
      )

      ;;  This defines home row mods without the win key
      (defsrc
        s    d    f    g    h    j    k    l
      )
      (deflayer homerowmods
        @alt_s   @ctl_d   @sft_f   g   h   @sft_j   @ctl_k   @alt_l
      )
    '';

  };

}
