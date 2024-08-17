{ config, lib, pkgs, ... }:

let

  cfg = config.storvik;

in

{

  config =
    let
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      notify = "${pkgs.libnotify}/bin/notify-send";
      fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
      grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
      swappy = "${pkgs.swappy}/bin/swappy";
      ewwCmd = pkgs.writeScriptBin "launch-eww" ''
                ## Files and cwd
                FILE="${config.home.homeDirectory}/.cache/eww_launch.dashboard"
                CFG="${config.xdg.configHome}/eww"
                ## uncomment this line when doing eww widget development
                CFG="/home/storvik/developer/nix/nix-config/modules/hm-modules/eww"
                ## Run eww daemon if not running already
                if [[ ! `pidof eww` ]]; then
                	${pkgs.eww}/bin/eww daemon
                  sleep 1
                fi
                ## Open widgets
                run_eww() {
        	        ${pkgs.eww}/bin/eww --config "$CFG" close storbar
        	        ${pkgs.eww}/bin/eww --config "$CFG" open-many \
                  		   bg profile datetime sysbars network systray
                }
                ## Launch or close widgets accordingly
                if [[ ! -f "$FILE" ]]; then
                	touch "$FILE"
                 	run_eww
                else
                	${pkgs.eww}/bin/eww --config "$CFG" close \
                  		   bg profile datetime sysbars network systray
        	        ${pkgs.eww}/bin/eww --config "$CFG" open storbar
                  rm "$FILE"
                fi
      '';
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
          bind = $mod, L, exec, hyprlock
          bind = $mod, H, exec, ${ewwCmd}/bin/launch-eww
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
          exec-once=${pkgs.eww}/bin/eww daemon
          exec-once=${pkgs.eww}/bin/eww open storbar

          general {
            gaps_in = 15
            gaps_out = 15
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

      programs.eww = {
        enable = true;
        package = pkgs.eww;
        configDir = ./eww;
      };

      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 60;
            hide_cursor = true;
            no_fade_in = false;
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          label = {
            monitor = "";
            text = "cmd[update:1000] date +'%H:%M:%S'";
            color = "rgb(202, 211, 245)";
            font_size = 120;
            position = "0, 0";
            halign = "center";
            valign = "center";
          };

          input-field = [
            {
              size = "800, 100";
              position = "0, -200";
              halign = "center";
              valign = "center";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              outline_thickness = 5;
              shadow_passes = 2;
            }
          ];
        };
      };

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 600;
              on-timeout = "${ewwCmd}/bin/launch-eww";
            }
            {
              timeout = 900;
              on-timeout = "${ewwCmd}/bin/launch-eww ; hyprlock";
            }
            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

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

      services.kdeconnect = {
        enable = true;
        package = pkgs.kdePackages.kdeconnect-kde;
        indicator = true;
      };

    };

}
