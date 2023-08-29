{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf cfg.kanata {

    services.kanata = {
      enable = true;
      package = pkgs.kanata-with-cmd;
      keyboards.default = {
        devices = [
          # TODO: This will only work on my matebook, should be set somewhere
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];
        # extraArgs = [ "--debug" ];
        extraDefCfg = "danger-enable-cmd yes";
        config =
          let
            sway = "${pkgs.sway}/bin/sway";
            swaymsg = "${pkgs.sway}/bin/swaymsg -s `${sway} --get-socketpath`";
          in
          ''
            (defalias
              a (tap-hold 200 200 a lmet)
              r (tap-hold 200 200 r lalt)
              s (tap-hold 200 200 s lctl)
              t (tap-hold 200 200 t lsft)
              n (tap-hold 200 200 n rsft)
              e (tap-hold 200 200 e rctl)
              i (tap-hold 200 200 i lalt) ;; send lalt instead of ralt, as ralt is Alt Gr (alt + ctl)
              o (tap-hold 200 200 o lmet)
              m (tap-hold 200 200 m (layer-toggle colemak-dh-extend))
              # S-3

              empty (layer-switch empty)

              caps (tap-hold 200 200 esc lctl)
              spc (tap-hold 200 500 spc (layer-toggle navigation))

              å (multi ralt w)
              ø (multi ralt l)
              æ (multi ralt z)
            )

            ;; As kanata acts on the physical keys, that is before keyboard layout is applied.
            ;; See issue https://github.com/jtroo/kanata/issues/152
            ;; This is the reason for not using colemak in defsrc. Important that keyboard layout is set to
            ;; xkb_layout = "us"; xkb_model = "pc105"; xkb_variant = "altgr-intl";
            (defsrc
              grv         1       2       3       4       5       6       7       8       9       0       -       =       bspc
              tab         q       w       e       r       t       y       u       i       o       p       [       ]       ret
              caps        a       s       d       f       g       h       j       k       l       ;       '       \
              lsft    102d    z       x       c       v       b       n       m       ,       .       /       rsft
                 lmet    lalt                        spc                                 rmet     rctl
            )

            (deflayer colemak-dh
              grv         1       2       3       4       5       6       7       8       9       0       -       =       bspc
              tab         q       w       f       p       b       j       l       u       y       ;       [       ]       ret
              @caps       @a      @r      @s      @t      g       @m      @n      @e      @i      @o      '       \
              lsft    z       x       c       d       v       \       k       h       ,       .       /       rsft
                 lmet    lalt                        @spc                                rmet    rctl
            )

            (deflayer colemak-dh-extend
              _           _       _       _       _       _       _       _       _       _       _       _       _       _
              _           @ø      @å      @æ      _       _       _       _       _       _       _       _       _       _
              _           _       _       _       _       _       _       _       _       _       _       _       _
              _       _       _       _       _       _       _       _       _       _       _       _       _
                 _       _                           _                                   _       _
            )

            (deflayer empty
              _           _       _       _       _       _       _       _       _       _       _       _       _       _
              _           _       _       _       _       _       _       _       _       _       _       _       _       _
              _           _       _       _       _       _       _       _       _       _       _       _       _
              _       _       _       _       _       _       _       _       _       _       _       _       _
                 _       _                           _                                   _       _
            )

            (deflayer qwerty
              grv         1       2       3       4       5       6       7       8       9       0       -       =       bspc
              tab         q       w       e       r       t       y       u       i       o       p       [       ]       ret
              @caps       a       s       d       f       g       h       j       k       l       ;       '       @#
              lsft    \       z       x       c       v       b       n       m       ,       .       /       rsft
                 lmet    lalt                        @spc                                rmet    rctl
            )

            (defalias
              n_d (macro M-(d))              ;; Run menu
              n_h (macro A-(C-(left)))       ;; Previous desktop
              n_j (macro M-(left))           ;; Move window to prev zone
              n_k (macro M-(rght))           ;; Move window to next zone
              n_l (macro A-(C-(rght)))       ;; Next desktop
              n_q (macro M-(S-(q)))          ;; Quit program
              n_ret (macro M-(ret))          ;; New terminal
              n_p (macro M-(p))              ;; Powermenu

              qwr (layer-switch qwerty)      ;; Change to layer qwerty
              cmk (layer-switch colemak-dh)  ;; Change to layer colemak-dh
              mdl (layer-switch modal)       ;; Change to layer modal

              ml (multi lsft down)
              mw (multi lctl lsft rght)
            )

            (deflayer navigation
              _           @cmk    @qwr    _       _       _       _       _       _       _       _       _       _       _
              _           @n_q    _       _       _       _       _       _       _       _       _       _       _       @n_ret
              @mdl        _       _       @n_d    _       _       @n_h    @n_j    @n_k    @n_l    _       _       _
              _       _       _       _       _       _       _       _       _       _       _       _       _
                 _       _                           _                                   _       _
            )

            (deflayer modal
              _           _       _       _       _       _       _       _       _       _       _       _       _       _
              _           _       @mw     _       _       _       _       @ml     _       _       _       _       _       _
              @cmk        _       _       _       _       _       left    down    up      rght    _       _       _
              _       _       _       _       _       _       _       _       _       _       _       _       _
                 _       _                           _                                   _       _
            )
          '';
      };
    };

  };

}
