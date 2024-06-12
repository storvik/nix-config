inputs: { config, lib, pkgs, ... }:

let

  cfg = config.storvik;

in

{

  config =
    let
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      notify = "${pkgs.libnotify}/bin/notify-send";
      lockCmd = "${pkgs.gtklock}/bin/gtklock --daemonize -s ${config.xdg.configHome}/gtklock/style.css";
      fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
      grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
      swappy = "${pkgs.swappy}/bin/swappy";
    in
    lib.mkIf (cfg.desktop == "hyprland") {

      storvik.waylandTools = lib.mkDefault true;

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        extraConfig = ''
          $mod = SUPER

          bind = $mod, RETURN, exec, foot
          bind = $mod SHIFT, RETURN, exec, emacsclient -c -a emacs
          bind = $mod, D, exec, ${fuzzel}
          bind = $mod, L, exec, ${lockCmd}
          bind = $mod, K, exec, ${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu
          bind = $mod, V, exec,  clipman pick --tool=CUSTOM --tool-args="${fuzzel} -d"
          bind = , Print, exec, ${grimshot} --notify save screen - | ${swappy} -f -
          bind = SHIFT, Print, exec, ${grimshot} --notify save area - | ${swappy} -f -

          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          ${builtins.concatStringsSep "\n" (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in ''
                bind = $mod, ${ws}, workspace, ${toString (x + 1)}
                bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
              ''
            )
            10)}

          # compositor cmds
          bind = $mod, Q, killactive,
          bind = $mod SHIFT, M, exit,
          bind = $mod, F, fullscreen,
          bind = $mod, G, togglesplit,
          bind = $mod SHIFT, F, togglefloating,
          bind = $mod SHIFT, G, togglegroup,
          # bind = $mod SHIFT, G, exec, $notifycmd 'Toggled Group Mode'
          bind = $mod SHIFT, N, changegroupactive, f
          bind = $mod SHIFT, P, changegroupactive, b

          # move/resize windows
          bindm = $mod, mouse:272, movewindow
          bindm = $mod SHIFT, mouse:272, resizewindow

          # move focus
          bind = $mod, M, movefocus, l
          bind = $mod, I, movefocus, r
          bind = $mod, E, movefocus, u
          bind = $mod, N, movefocus, d

          # window resize
          bind = $mod, R, submap, resize
          submap = resize
          binde = , M, resizeactive, -10 0
          binde = , I, resizeactive, 10 0
          binde = , E, resizeactive, 0 -10
          binde = , N, resizeactive, 0 10
          bind = , escape, submap, reset
          submap = reset

          bind = CONTROL_ALT, left, workspace, -1
          bind = CONTROL_ALT, right, workspace, +1

          # Audio
          bind = , XF86AudioMute, exec, ${pkgs.avizo}/bin/volumectl toggle-mute
          bind = , XF86AudioRaiseVolume, exec, ${pkgs.avizo}/bin/volumectl -u up
          bind = , XF86AudioLowerVolume, exec, ${pkgs.avizo}/bin/volumectl -u down
          bind = , XF86AudioMicMute, exec, ${pkgs.avizo}/bin/volumectl -m toggle-mute

          # Brightness
          bind = , XF86MonBrightnessUp, exec, ${pkgs.avizo}/bin/lightctl up
          bind = , XF86MonBrightnessDown, exec, ${pkgs.avizo}/bin/lightctl down

          exec-once=systemctl --user start avizo.service

          general {
            gaps_in = 5
            gaps_out = 5
          }

          input {
            kb_layout = us
            kb_model = pc105
            kb_variant = altgr-intl
            kb_options =
            kb_rules =
            follow_mouse = 2
            touchpad {
              natural_scroll = true
              scroll_factor = 0.2
            }
          }

          gestures {
            workspace_swipe = true
            workspace_swipe_fingers = 3
          }
        '';
      };

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "${pkgs.foot}/bin/foot";
            layer = "overlay";
            font = if cfg.disableNerdfonts then "Iosevka:size=12" else "Iosevka Nerd Font:size=12";
            width = 55;
          };
          colors.background = "d8dee9ff";
        };
      };

      # Volume and brightness indicator
      services.avizo.enable = true;

      programs.ironbar = {
        enable = true;
        systemd = true;
        # package = inputs.ironbar;
        config = {
          anchor_to_edges = true;
          position = "top";
          height = 22;
          start = [
            {
              type = "workspaces";
              all_monitors = false;
              # name_map:
              # '1': 
              # '2': 
              # '3': 
            }
          ];
          center = [
            {
              type = "focused";
            }
          ];
          end = [
            # {
            #   type = "upower";
            #   format = "{icon} {percentage}%";
            # }
            {
              type = "volume";
              format = "{icon} {percentage}%";
              max_volume = 100;
              icons = {
                volume_high = "󰕾";
                volume_medium = "󰖀";
                volume_low = "󰕿";
                muted = "󰝟";
              };
            }
            {
              type = "clock";
            }
          ];

        };
        style = ''
           @define-color color_bg #2d2d2d;
          @define-color color_bg_dark #1c1c1c;
          @define-color color_border #424242;
          @define-color color_border_active #6699cc;
          @define-color color_text #ffffff;
          @define-color color_urgent #8f0a0a;

          /* -- base styles -- */

          * {
              font-family: Noto Sans Nerd Font, sans-serif;
              font-size: 12px;
              border: none;
              border-radius: 0;
          }

          box, menubar, button {
              background-color: @color_bg;
              background-image: none;
              box-shadow: none;
          }

          button, label {
              color: @color_text;
          }

          button:hover {
              background-color: @color_bg_dark;
          }

          scale trough {
              min-width: 1px;
              min-height: 2px;
          }

          #bar {
              border-top: 1px solid @color_border;
          }

          .popup {
              border: 1px solid @color_border;
              padding: 1em;
          }

          /* -- clock -- */

          .clock {
              font-weight: bold;
              margin-left: 5px;
          }

          .popup-clock .calendar-clock {
              color: @color_text;
              font-size: 2.5em;
              padding-bottom: 0.1em;
          }

          .popup-clock .calendar {
              background-color: @color_bg;
              color: @color_text;
          }

          .popup-clock .calendar .header {
              padding-top: 1em;
              border-top: 1px solid @color_border;
              font-size: 1.5em;
          }

          .popup-clock .calendar:selected {
              background-color: @color_border_active;
          }

          /* -- volume -- */

          .popup-volume .device-box {
              border-right: 1px solid @color_border;
          }

          /* -- workspaces -- */

          .workspaces .item.focused {
              box-shadow: inset 0 -3px;
              background-color: @color_bg_dark;
          }

          .workspaces .item:hover {
              box-shadow: inset 0 -3px;
          }
        '';
      };

      # Swayidle locks device, turns off screen and suspends machine
      services.swayidle = {
        enable = true;
        extraArgs = [ "-w" ];
        systemdTarget = "hyprland-session.target";
        events = [
          { event = "before-sleep"; command = lockCmd; }
          { event = "lock"; command = lockCmd; }
        ];
        timeouts = [
          { timeout = 900; command = lockCmd; }
          { timeout = 1800; command = "${hyprctl} dispatch dpms off"; resumeCommand = "${hyprctl} dispatch dpms on"; }
          { timeout = 1860; command = "systemctl suspend"; } # TODO: Check if this is a good way to suspend machine after screen turns off
        ];
      };

      # Mako notification service
      services.mako = {
        enable = true;
        anchor = "top-center";
        defaultTimeout = 5000;
        font = if cfg.disableNerdfonts then "Iosevka" else "Iosevka Nerd Font";
      };

      services.hyprpaper = {
        enable = true;
        settings = {
          ipc = "on";
          splash = true;
          splash_offset = 2.0;

          preload = [ "~/.config/hypr/hyprpaper.png" ];

          wallpaper = [
            ",~/.config/hypr/hyprpaper.png"
          ];
        };
      };

      xdg = {
        enable = true;

        configFile."hypr/hyprpaper.png" = {
          source = ../../assets/kalinix.png;
          recursive = true;
        };

        configFile."swappy/config".text = ''
          [Default]
          save_dir=$HOME/Pictures/Screenshots
          save_filename_format=%Y%m%d-%H%M%S.png
          show_panel=false
          line_size=5
          text_size=20
          text_font=Iosevka
          paint_mode=brush
          early_exit=true
          fill_shape=false
        '';

        configFile."networkmanager-dmenu/config.ini".text = ''
          [dmenu]
          dmenu_command = ${fuzzel} -d
          wifi_chars = ▂▄▆█
          pinentry = pinentry-qt

          [editor]
          terminal = ${pkgs.foot}/bin/foot
          gui_if_available = true
        '';

        configFile."gtklock/style.css".text = ''
          @define-color bg rgb(59, 66, 82);
          @define-color text1 #fff;
          @define-color text2 #b48ead;

          * {
            color: @text1;
          }

          entry#input-field {
            color: @text2;
          }

          window {
            background-color: @bg;
          }
        '';


      };

      services.blueman-applet.enable = true;

      # Fix for small cursor issue
      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = 24;
        x11 = {
          enable = true;
          defaultCursor = "Adwaita";
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Materia-dark";
          package = pkgs.materia-theme;
        };
        iconTheme = {
          name = "Vimix-Black";
          package = pkgs.vimix-icon-theme;
        };
      };

      services.clipman = {
        enable = true;
        systemdTarget = "hyprland-session.target";
      };

      services.udiskie = {
        enable = true;
        tray = "never";
      };

    };

}
