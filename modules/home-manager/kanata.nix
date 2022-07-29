{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.kanata.enable {

    home.packages = with pkgs; [
    ];

    systemd.user.services.kanata = {
      Unit = {
        Description = "kanata service";
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.kanata}/bin/kanata --cfg .kanataconfig.kbd";
      };
    };



    home.file.".kanataconfig.kbd".text = ''
      (defcfg
        linux-dev /dev/input/by-path/platform-i8042-serio-0-event-kbd
        danger-enable-cmd yes           ;; enable run cmd
      )

      ;; Define aliases for the keys needed for home row mods
      (defalias
        met_a (tap-hold 200 160 a lmet)
        alt_s (tap-hold 200 160 s lalt)
        ctl_d (tap-hold 200 160 d lctl)
        sft_f (tap-hold 200 160 f lsft)
        sft_j (tap-hold 200 160 j rsft)
        ctl_k (tap-hold 200 160 k rctl)
        alt_l (tap-hold 200 160 l lalt) ;; send lalt instead of ralt, as ralt is Alt Gr (alt + ctl)
        met_; (tap-hold 200 160 ; lmet)
      )

      (defalias
        td (tap-dance 1000 (lalt (layer-toggle navigation)))
      )

      ;; Removed lctl and ralt in order to use Alt Gr in xserver applications
      (defsrc
        esc     f1      f2      f3      f4      f5      f6      f7      f8      f9      f10     f11     f12             ssrq    slck    ;;pause
        grv     1       2       3       4       5       6       7       8       9       0       -       =       bspc    ins     home    pgup    nlck    kp/     kp*     kp-
        tab     q       w       e       r       t       y       u       i       o       p       [       ]       ret     del     end     pgdn    kp7     kp8     kp9     kp+
        caps    a       s       d       f       g       h       j       k       l       ;       '       \                                       kp4     kp5     kp6
        lsft    102d    z       x       c       v       b       n       m       ,       .       /       rsft                    up              kp1     kp2     kp3     ;;kprt
                lmet    lalt                            spc                             rmet    rctl            left    down    rght    kp0     kp.
      )

      ;; Default layer with home row mods
      (deflayer default
        esc     f1      f2      f3      f4      f5      f6      f7      f8      f9      f10     f11     f12             ssrq    slck    ;;pause
        grv     1       2       3       4       5       6       7       8       9       0       -       =       bspc    ins     home    pgup    nlck    kp/     kp*     kp-
        tab     q       w       e       r       t       y       u       i       o       p       [       ]       ret     del     end     pgdn    kp7     kp8     kp9     kp+
        caps    @met_a  @alt_s  @ctl_d  @sft_f  g       h       @sft_j  @ctl_k  @alt_l  @met_;  '       \                                       kp4     kp5     kp6
        lsft    102d    z       x       c       v       b       n       m       ,       .       /       rsft                    up              kp1     kp2     kp3     ;;kprt
                lmet    @td                             spc                             rmet    rctl            left    down    rght    kp0     kp.
      )

      (defalias
        nextd C-A-rght   ;; Next desktop in windows
        prevd C-A-lft    ;; Previous desktop in windows
      )

      (deflayer navigation
        _       _       _       _       _       _       _       _       _       _       _       _       _                _      _
        _       _       _       _       _       _       _       _       _       _       _       _       _       _        _      _       _       _       _       _       _
        _       _       _       _       _       _       _       _       _       _       _       _       _       _        _      _       _       _       _       _       _
        _       _       _       _       _       _       @prevd  _       _       @nextd  _       _       _                                       _       _       _
        _       _       _       _       @cry    _       _       _       _       _       _       _       _                       _               _       _       _
                _       _                       _                                       _       _       _                _      _       _       _
      )

      ;; Symbol aliases
      (defalias
        smile (unicode 😄)
        grin (unicode 😁)
        cry (unicode 😢)
        laugh (unicode 😆)
      )

      (deflayer symbols
        _       _       _       _       _       _       _       _       _       _       _       _       _                _      _
        _       _       _       _       _       _       _       _       _       _       _       _       _       _        _      _       _       _       _       _       _
        _       _       _       _       _       _       _       _       _       _       _       _       _       _        _      _       _       _       _       _       _
        _       _       @smile  _       _       @grin   _       _       _       @laugh  _       _       _                                       _       _       _
        _       _       _       _       @cry    _       _       _       _       _       _       _       _                       _               _       _       _
                _       _                       _                                       _       _       _                _      _       _       _
      )

    '';

  };

}
