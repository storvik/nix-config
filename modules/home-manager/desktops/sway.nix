{ config, lib, pkgs, ... }:

with lib;

{

  config =
    let
      lockCmd = "${pkgs.swaylock}/bin/swaylock -f -e -c 2E3440";
    in
    mkIf config.storvik.sway.enable {

      wayland.windowManager.sway = {
        enable = true;
        systemdIntegration = true;
        wrapperFeatures = {
          base = true;
          gtk = true;
        };
        xwayland = false; # should use only wayland apps

        config = rec {

          # Use windows key as modifier
          modifier = "Mod4";

          left = "h";
          down = "j";
          up = "k";
          right = "l";

          terminal = "${pkgs.alacritty}/bin/alacritty";

          # Use lib.mkOptionDefault function to extend or override default
          # keybindings instead of specifying all of them from scratch.
          # keybindings = { };

          input = {
            "type:touchpad" = {
              tap = "enabled";
              dwt = "enabled";
              scroll_method = "two_finger";
              middle_emulation = "enabled";
              natural_scroll = "enabled";
            };
            "type:pointer" = {
              natural_scroll = "enabled";
            };
            "type:keyboard" = {
              xkb_layout = "no";
              xkb_variant = "winkeys";
              xkb_options = "ctrl:nocaps";
            };
          };

          output = {
            "*".bg = "~/.config/nix-config/assets/nixos-wallpaper.png fill";
            "*".scale = "2";
          };

          #menu = "${pkgs.rofi-wayland}/bin/rofi -show combi -modes combi -combi-modes \"window,drun,run\"";
          menu = "${pkgs.wofi}/bin/wofi --show drun -I -G";

          fonts = {
            names = [ "Iosevka Nerd Font" ];
            size = 10.5;
          };

          focus = {
            followMouse = "always";
          };

          bars = [ ]; # empty list disables bars

          startup = [
            { command = "systemctl --user restart kmonad.service"; always = true; }
          ];

          gaps = {
            inner = 5;
            outer = 5;
            smartGaps = true;
            smartBorders = "on";
          };

        };
      };

      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "sway-session.target";
        };
      };

      services.swayidle = {
        enable = true;
        extraArgs = [ "-w" ];
        events = [
          { event = "before-sleep"; command = lockCmd; }
          { event = "lock"; command = lockCmd; }
        ];
        timeouts = [
          { timeout = 600; command = lockCmd; }
          { timeout = 1200; command = "swaymsg \"output * dpms off\""; resumeCommand = "swaymsg \"output * dpms on\""; }
          { timeout = 1260; command = "systemctl suspend"; } # TODO: Check if this is a good way to suspend machine after screen turns off
        ];
      };

    };

}
