{ config, lib, pkgs, ... }:
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
      ewwCmd = pkgs.writeScriptBin "launch-eww" ''
                ## Files and cwd
                FILE="${config.home.homeDirectory}/.cache/eww_launch.dashboard"
                CFG="${config.xdg.configHome}/eww"

                ## Run eww daemon if not running already
                if [[ ! `pidof eww` ]]; then
                	${pkgs.eww-wayland}/bin/eww daemon
                  sleep 1
                fi

                ## Open widgets
                run_eww() {
        	        ${pkgs.eww-wayland}/bin/eww --config "$CFG" open-many \
                  		   bg clock leftdash sysbars network power-buttons
                }

                ## Launch or close widgets accordingly
                if [[ ! -f "$FILE" ]]; then
                	touch "$FILE"
                 	run_eww
                else
                	${pkgs.eww-wayland}/bin/eww --config "$CFG" close \
        					       bg clock leftdash sysbars network power-buttons
                  rm "$FILE"
                fi
      '';
    in
    lib.mkIf (cfg.desktop == "hyprland") {

      storvik.waylandTools = lib.mkDefault true;

      wayland.windowManager.hyprland = {
        enable = true;
        systemdIntegration = true;
        recommendedEnvironment = true;
        extraConfig = ''
          $mod = SUPER

          bind = $mod, RETURN, exec, foot
          bind = $mod SHIFT, RETURN, exec, emacsclient -c -a emacs
          bind = $mod, D, exec, ${fuzzel}
          bind = $mod, L, exec, ${lockCmd}
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

          exec-once=${pkgs.eww-wayland}/bin/eww daemon
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
        package = pkgs.eww-wayland;
        configDir = ./eww;
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
          { timeout = 600; command = "${ewwCmd}/bin/launch-eww"; }
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

      xdg = {
        enable = true;

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
