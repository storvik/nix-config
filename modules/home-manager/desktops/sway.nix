{ config, lib, pkgs, ... }:

with lib;

{

  config =
    let
      storvik-lock = pkgs.writeShellScriptBin "storvik-lock" ''
        ${pkgs.swaylock-effects}/bin/swaylock -f -e -c 3b4252 \
                                                   --clock \
                                                   --datestr %a,\ %d.%m.%Y \
                                                   --indicator \
                                                   --indicator-radius 150 \
                                                   --indicator-thickness 7 \
                                                   --fade-in 1 \
                                                   --inside-color 2e3440 \
                                                   --ring-color ebcb8b \
                                                   --key-hl-color b48ead \
                                                   --inside-ver-color d08770 \
                                                   --ring-ver-color d08770 \
                                                   --inside-ver-color d08770 \
                                                   --ring-ver-color d08770 \
                                                   --inside-wrong-color bf616a \
                                                   --ring-wrong-color d08770
      '';
      menuCmd = "${pkgs.wofi}/bin/wofi --show drun -I -G";
      alt = "Mod1";
      super = "Mod4";
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

          modifier = super;

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

          menu = menuCmd;

          fonts = {
            names = [ "Iosevka Nerd Font" ];
            size = 10.5;
          };

          focus = {
            followMouse = "always";
          };

          bars = [ ]; # empty list disables bars

          assigns = {
            "1: web" = [{ app_id = "firefox"; }];
            "2: emacs" = [{ app_id = "emacs"; }];
            "6: graphics" = [
              { app_id = "gimp"; }
              { app_id = "inkscape"; }
            ];
          };

          floating.criteria = [
            { app_id = "pinentry-qt"; }
          ];

          startup = [
            { command = "systemctl --user restart kanata.service"; always = true; }
            { command = "systemctl --user restart fusuma.service"; always = true; }
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
              Exclam = "exec ${storvik-lock}/bin/storvik-lock, mode \"default\"";
              Escape = "mode \"default\"";
            };
          };

          keybindings = lib.mkOptionDefault {
            "${alt}+Control+Left" = "exec swaymsg -t command workspace prev_on_output";
            "${alt}+Control+Right" = "exec swaymsg -t command workspace next_on_output";

            "${super}+Shift+t" = "exec systemctl --user restart kanata.service";

            # Systems
            "${super}+p" = "mode system";

            # Networkmanager
            "${super}+n" = "exec networkmanager_dmenu";

            # Screenshot
            "Print" = "exec grimshot --notify copy screen";
            "Shift+Print" = "exec grimshot --notify copy area";
            "Control+Print" = "exec grimshot --notify copy window";
            "${super}+Print" = "exec grimshot --notify save screen";
            "${super}+Shift+Print" = "exec grimshot --notify save area";
            "${super}+Control+Print" = "exec grimshot --notify save window";
            "${alt}+Print" = "exec grimshot save screen - | swappy -f -";
            "${alt}+Shift+Print" = "exec grimshot save area - | swappy -f -";
            "${alt}+Control+Print" = "exec grimshot save window - | swappy -f -";

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

        configFile."swappy/config".text = ''
          [Default]
          save_dir=$HOME/Pictures/Screenshots
          save_filename_format=%Y%m%d-%H%M%S_swappy.png
          show_panel=false
          line_size=5
          text_size=20
          text_font=Iosevka Nerd Font
          paint_mode=brush
        '';

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
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            spacing = 4;

            modules-left = [ "sway/workspaces" "sway/mode" ];
            modules-center = [ "sway/window" ];
            modules-right = [ "pulseaudio" "network" "battery" "clock" "tray" ];

            "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
            };

            "tray" = {
              icon-size = 21;
              spacing = 10;
            };

            "clock" = {
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{:%Y-%m-%d}";
            };

            "network" = {
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ipaddr}/{cidr} ";
              tooltip-format = "{ifname} via {gwaddr} ";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
            };

            "pulseaudio" = {
              format = "{volume}% {icon} {format_source}";
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = " {icon} {format_source}";
              format-muted = " {format_source}";
              format-source = "{volume}% ";
              format-source-muted = "";
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = [ "" "" "" ];
              };
              on-click = "pavucontrol";
            };

            "battery" = {
              states = {
                good = 95;
                warning = 30;
                critical = 15;
              };
              format = "{capacity}% {icon}";
              format-charging = "{capacity}% ";
              format-plugged = "{capacity}% ";
              format-alt = "{time} {icon}";
              format-icons = [ "" "" "" "" "" ];
            };
            "battery#bat2" = {
              bat = "BAT2";
            };

          };
        };
        style = ''
          * {
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: FontAwesome, Iosevka Nerd Font;
            font-size: 13px;
          }

          window#waybar {
            background-color: transparent;
            border-bottom: 3px solid rgba(100, 114, 125, 0.5);
            color: #ffffff;
            transition-property: background-color;
            transition-duration: .5s;
          }

          window#waybar.hidden {
            opacity: 0.2;
          }

          #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #ffffff;
            /* Use box-shadow instead of border so the text isn't offset */
            box-shadow: inset 0 -3px transparent;
            /* Avoid rounded borders under each workspace name */
            border: none;
            border-radius: 0;
          }

          #workspaces button:hover {
            background: rgba(0, 0, 0, 0.2);
            box-shadow: inset 0 -3px #ffffff;
          }

          #workspaces button.focused {
            background-color: #64727D;
            box-shadow: inset 0 -3px #ffffff;
          }

          #workspaces button.urgent {
            background-color: #eb4d4b;
          }

          #mode {
            background-color: #64727D;
            border-bottom: 3px solid #ffffff;
          }

          #clock,
          #battery,
          #network,
          #pulseaudio,
          #tray,
          #mode {
            padding: 0 10px;
            color: #ffffff;
          }

          #window,
          #workspaces {
            margin: 0 4px;
          }

          /* If workspaces is the leftmost module, omit left margin */
          .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
          }

          /* If workspaces is the rightmost module, omit right margin */
          .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
          }

          #battery.critical:not(.charging) {
            background-color: #f53c3c;
            color: #ffffff;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

        '';
      };

      services.swayidle = {
        enable = true;
        extraArgs = [ "-w" ];
        events = [
          { event = "before-sleep"; command = "${storvik-lock}/bin/storvik-lock"; }
          { event = "lock"; command = "${storvik-lock}/bin/storvik-lock"; }
        ];
        timeouts = [
          { timeout = 600; command = "${storvik-lock}/bin/storvik-lock"; }
          { timeout = 1200; command = "swaymsg \"output * dpms off\""; resumeCommand = "swaymsg \"output * dpms on\""; }
          { timeout = 1260; command = "systemctl suspend"; } # TODO: Check if this is a good way to suspend machine after screen turns off
        ];
      };

      services.fusuma =
        let
          swaymsg = "${pkgs.sway}/bin/swaymsg";
        in
        {
          enable = true;
          settings = {
            threshold = {
              swipe = 0.1;
            };
            interval = {
              swipe = 0.7;
            };
            swipe = {
              "3" = {
                left = {
                  command = "${swaymsg} -t command workspace next_on_output";
                };
                right = {
                  command = "${swaymsg} -t command workspace prev_on_output";
                };
                up = {
                  command = menuCmd;
                };
              };
            };
          };
        };

    };

}
