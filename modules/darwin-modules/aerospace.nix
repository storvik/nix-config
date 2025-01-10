{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.enableAerospace) {

    services = {
      aerospace = {
        enable = true;
        settings = {
          gaps = {
            inner.horizontal = 15;
            inner.vertical = 15;
            outer.left = 10;
            outer.bottom = 10;
            outer.top = 10;
            outer.right = 10;
          };
          after-startup-command = [ ];
          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;
          accordion-padding = 30;
          default-root-container-layout = "tiles";
          default-root-container-orientation = "auto";
          on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
          on-focus-changed = [ "move-mouse window-lazy-center" ];
          workspace-to-monitor-force-assignment = {
            "P" = [ "^C27F390.*1*$" ];
            "B" = [ "^built-in retina display$" ];
          };
          on-window-detected = [
            {
              check-further-callbacks = false;
              "if" = {
                app-id = "com.tinyspeck.slackmacgap";
                app-name-regex-substring = "Slack";
                during-aerospace-startup = true;
                # window-title-regex-substring = "Title";
                # workspace = "cool-workspace";
              };
              run = [ "move-node-to-workspace 7" ];
            }
          ];
          mode.main.binding = {

            alt-enter = "exec-and-forget open -na alacritty";
            shift-alt-enter = "exec-and-forget ${pkgs.storvik-emacs-withPackages}/bin/emacsclient -c";

            alt-m = "focus left";
            alt-n = "focus down";
            alt-e = "focus up";
            alt-i = "focus right";

            alt-shift-m = "move left";
            alt-shift-n = "move down";
            alt-shift-e = "move up";
            alt-shift-i = "move right";

            alt-slash = "layout tiles horizontal vertical";
            alt-comma = "layout accordion horizontal vertical";

            alt-f = "fullscreen";
            alt-shift-f = "layout floating tiling";

            alt-shift-minus = "resize smart -50";
            alt-shift-equal = "resize smart +50";

            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";
            alt-b = "workspace B";
            alt-p = "workspace P";

            alt-shift-1 = "move-node-to-workspace 1";
            alt-shift-2 = "move-node-to-workspace 2";
            alt-shift-3 = "move-node-to-workspace 3";
            alt-shift-4 = "move-node-to-workspace 4";
            alt-shift-5 = "move-node-to-workspace 5";
            alt-shift-6 = "move-node-to-workspace 6";
            alt-shift-7 = "move-node-to-workspace 7";
            alt-shift-8 = "move-node-to-workspace 8";
            alt-shift-9 = "move-node-to-workspace 9";
            alt-shift-b = "move-node-to-workspace B";
            alt-shift-p = "move-node-to-workspace P";

            alt-period = "focus-monitor main";
            alt-tab = "workspace-back-and-forth";
            alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

            alt-shift-semicolon = "mode service";
          };
          mode.service.binding = {
            esc = [ "reload-config" "mode main" ];
            r = [ "flatten-workspace-tree" "mode main" ]; # reset layout
            f = [ "layout floating tiling" "mode main" ]; # Toggle between floating and tiling layout
            # s [= "layout sticky tiling" "mode main"]; # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
            backspace = [ "close-all-windows-but-current" "mode main" ];

            alt-shift-m = [ "join-with left" "mode main" ];
            alt-shift-n = [ "join-with down" "mode main" ];
            alt-shift-e = [ "join-with up" "mode main" ];
            alt-shift-i = [ "join-with right" "mode main" ];
          };
        };
      };
      jankyborders = {
        enable = true;
        active_color = "0xFFE1E3E4";
        inactive_color = "0xFF494D64";
        width = 5.0;
      };
    };

  };

}
