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
        xwayland = true;

        config = rec {

          # Use windows key as modifier
          modifier = "Mod4";

          left = "h";
          down = "j";
          up = "k";
          right = "l";

          terminal = "${pkgs.alacritty}/bin/alacritty";

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
            { command = "avizo-service"; always = true; }
          ];

          gaps = {
            inner = 5;
            outer = 5;
            smartGaps = true;
            smartBorders = "on";
          };

          modes = {
            resize = {
              h = "resize shrink width 10 px";
              j = "resize grow height 10 px";
              k = "resize shrink height 10 px";
              l = "resize grow width 10 px";
              Escape = "mode default";
              Return = "mode default";
            };
            system = {
              r = "reload, mode \"default\"";
              q = "exec swaymsg exit, mode \"default\"";
              s = "exec systemctl suspend, mode \"default\"";
              Exclam = "exec ${lockCmd}, mode \"default\"";
              Escape = "mode \"default\"";
            };
          };

          keybindings = lib.mkOptionDefault {
            # Systems
            "${modifier}+p" = "mode system";

            # Networkmanager
            "${modifier}+n" = "exec networkmanager_dmenu";

            # Screenshot
            "Print" = "exec grimshot --notify copy active";
            "Shift+Print" = "exec grimshot --notify copy area";
            "Control+Print" = "exec grimshot --notify copy window";
            "Mod4+Print" = "exec grimshot --notify save active";
            "Mod4+Shift+Print" = "exec grimshot --notify save area";
            "Mod4+Control+Print" = "exec grimshot --notify save window";

            # Adio
            "XF86AudioMute" = "exec volumectl toggle-mute";
            "XF86AudioRaiseVolume" = "exec volumectl -u up";
            "XF86AudioLowerVolume" = "exec volumectl -u down";
            "XF86AudioMicMute" = "exec volumectl -m toggle-mute";

            # Brightness
            "XF86MonBrightnessUp" = "exec lightctl up";
            "XF86MonBrightnessDown" = "exec lightctl down";
          };


        };
      };

      programs.mako = {
        enable = true;
        anchor = "top-center";
        defaultTimeout = 5000;
        font = "Iosevka Nerd Font";
      };

      systemd.user.services.mako = {
        Service = { ExecStart = "${pkgs.mako}/bin/mako"; };
        Install = {
          After = [ "sway-session.target" ];
          WantedBy = [ "sway-session.target" ];
        };
      };

      xdg = {
        enable = true;

        configFile."networkmanager-dmenu/config.ini".text = ''
          [dmenu]
          dmenu_command = ${pkgs.wofi}/bin/wofi -d -I -G
          wifi_chars = ▂▄▆█
          pinentry = pinentry-qt

          [editor]
          terminal = ${pkgs.alacritty}/bin/alacritty
          gui_if_available = true
        '';

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
