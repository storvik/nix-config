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
            "P" = [ "^C27F390.*1*$" "^HP.*2*$" ];
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
              run = [ "move-node-to-workspace 3" ];
            }
          ];
          mode.main.binding = {

            ctrl-enter = "exec-and-forget open -na alacritty";
            shift-ctrl-enter = "exec-and-forget ${pkgs.storvik-emacs-withPackages}/bin/emacsclient -c";

            ctrl-m = "focus left";
            ctrl-n = "focus down";
            ctrl-e = "focus up";
            ctrl-i = "focus right";

            ctrl-shift-m = "move left";
            ctrl-shift-n = "move down";
            ctrl-shift-e = "move up";
            ctrl-shift-i = "move right";

            ctrl-slash = "layout tiles horizontal vertical";
            ctrl-comma = "layout accordion horizontal vertical";

            ctrl-f = "fullscreen";
            ctrl-shift-f = "layout floating tiling";

            # alt-shift-minus = "resize smart -50";
            # alt-shift-equal = "resize smart +50";

            ctrl-a = "workspace 5";
            ctrl-r = "workspace 4";
            ctrl-s = "workspace 3";
            ctrl-t = "workspace 2";
            ctrl-g = "workspace 1";
            ctrl-b = "workspace B";
            ctrl-p = "workspace P";

            ctrl-shift-a = "move-node-to-workspace 5";
            ctrl-shift-r = "move-node-to-workspace 4";
            ctrl-shift-s = "move-node-to-workspace 3";
            ctrl-shift-t = "move-node-to-workspace 2";
            ctrl-shift-g = "move-node-to-workspace 1";
            ctrl-shift-b = "move-node-to-workspace B";
            ctrl-shift-p = "move-node-to-workspace P";

            ctrl-tab = "workspace-back-and-forth";
            ctrl-shift-tab = "move-workspace-to-monitor --wrap-around next";

            ctrl-shift-semicolon = "mode service";
          };
          mode.service.binding = {
            esc = [ "reload-config" "mode main" ];
            r = [ "flatten-workspace-tree" "mode main" ]; # reset layout
            f = [ "layout floating tiling" "mode main" ]; # Toggle between floating and tiling layout
            # s [= "layout sticky tiling" "mode main"]; # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
            backspace = [ "close-all-windows-but-current" "mode main" ];

            ctrl-shift-m = [ "join-with left" "mode main" ];
            ctrl-shift-n = [ "join-with down" "mode main" ];
            ctrl-shift-e = [ "join-with up" "mode main" ];
            ctrl-shift-i = [ "join-with right" "mode main" ];
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
