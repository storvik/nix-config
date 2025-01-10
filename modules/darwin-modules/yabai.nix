{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.enableYabai) {

    services.yabai =
      let
        yabai-emacs-handle = pkgs.writeShellScript "yabai-emacs-handle" ''
          data=$(yabai -m query --windows --window $YABAI_WINDOW_ID)

          title=$(echo $data | jq .title)
          display=$(echo $data | jq .display)

          if [[ $title =~ "capture-popup" && $display == 1 ]]; then
              yabai -m window $YABAI_WINDOW_ID --toggle float --move abs:430:230
              yabai -m window $YABAI_WINDOW_ID --resize abs:655:300
              yabai -m window $YABAI_WINDOW_ID --focus
          elif [[ $title =~ "minimal-popup" && $display == 1 ]]; then
              yabai -m window $YABAI_WINDOW_ID --toggle float --move abs:430:230
              yabai -m window $YABAI_WINDOW_ID --resize abs:655:200
              yabai -m window $YABAI_WINDOW_ID --focus
          elif [[ $title =~ "large-popup" && $display == 1 ]]; then
              yabai -m window $YABAI_WINDOW_ID --toggle float --move abs:350:130
              yabai -m window $YABAI_WINDOW_ID --resize abs:730:600
              yabai -m window $YABAI_WINDOW_ID --focus
          else
              false
          fi
        '';
      in
      {
        enable = true;
        # enableScriptingAddition = true; # should probably turn this on, but requires SIP to be disabled.
        config = {
          layout = "bsp";
          window_placement = "second_child"; # New window spawns to the right if vertical split, or bottom if horizontal split
          top_padding = 12;
          bottom_padding = 12;
          left_padding = 12;
          right_padding = 12;
          window_gap = 12;
          mouse_follows_focus = "on"; # center mouse on window with focus
          mouse_modifier = "alt"; # modifier for clicking and dragging with mouse
          mouse_action1 = "move"; # set modifier + left-click drag to move window
          mouse_action2 = "resize"; # set modifier + right-click drag to resize window
          mouse_drop_action = "swap"; # when window is dropped in center of another window, swap them (on edges it will split it)

        };
        extraConfig = ''
          yabai -m rule --add app="^System Settings$" manage=off
          yabai -m rule --add app="^Calculator$" manage=off
          yabai -m rule --add app="^Karabiner-Elements$" manage=off
          yabai -m signal --add event=window_created app="Emacs" action="${yabai-emacs-handle}"
        '';
      };

    services.jankyborders = {
      enable = true;
      active_color = "0xFFE1E3E4";
      inactive_color = "0xFF494D64";
      width = 4.0;
    };

    services.skhd = {
      enable = true;
      skhdConfig = ''
        alt - return : alacritty
        shift + alt - return : emacsclient -c

        alt - q : yabai -m window --close

        # change window focus within space
        alt - n : yabai -m window --focus south
        alt - e : yabai -m window --focus north
        alt - m : yabai -m window --focus west
        alt - i : yabai -m window --focus east

        # swap windows
        shift + alt - n : yabai -m window --swap south
        shift + alt - e : yabai -m window --swap north
        shift + alt - m : yabai -m window --swap west
        shift + alt - i : yabai -m window --swap east

        # balance out tree of windows (resize to occupy same area)
        shift + alt - b : yabai -m space --balance

        # move window and split
        # ctrl + alt - n : yabai -m window --warp south
        # ctrl + alt - e : yabai -m window --warp north
        # ctrl + alt - m : yabai -m window --warp west
        # ctrl + alt - i : yabai -m window --warp east

        # focus monitor
        ctrl + alt - x : yabai -m display --focus next
        ctrl + alt - z : yabai -m display --focus prev
        ctrl + alt - 1 : yabai -m display --focus 1
        ctrl + alt - 2 : yabai -m display --focus 2
        ctrl + alt - 3 : yabai -m display --focus 3
        ctrl + alt - 4 : yabai -m display --focus 4

        # rotate layout clockwise
        # shift + alt - r : yabai -m space --rotate 270

        # flip along y-axis
        shift + alt - y : yabai -m space --mirror y-axis

        # flip along x-axis
        shift + alt - x : yabai -m space --mirror x-axis

        # maximize a window
        alt - f : yabai -m window --toggle zoom-fullscreen

        # toggle window float
        shift + alt - f : yabai -m window --toggle float --grid 4:4:1:1:2:2

        # toggle window split type
        alt - l : yabai -m window --toggle split

        # increase window size
        shift + alt - m : yabai -m window --resize left:-20:0
        shift + alt - i : yabai -m window --resize right:-20:0
        shift + alt - e : yabai -m window --resize top:0:-20
        shift + alt - n : yabai -m window --resize bottom:0:20

        # decrease window size
        shift + cmd - n : yabai -m window --resize bottom:0:-20
        shift + cmd - e : yabai -m window --resize top:0:20
        shift + cmd - m : yabai -m window --resize left:20:0
        shift + cmd - i : yabai -m window --resize right:20:0

        # move window to display left and right
        # shift + alt - s : yabai -m window --display west; yabai -m display --focus west;
        # shift + alt - g : yabai -m window --display east; yabai -m display --focus east;

        # move window to prev and next space
        shift + alt - l : yabai -m window --space prev;
        shift + alt - r : yabai -m window --space next;

        # move to space, requireres that sip is turned off
        alt - 1 : yabai -m space --focus 1;
        alt - 2 : yabai -m space --focus 2;
        alt - 3 : yabai -m space --focus 3;
        alt - 4 : yabai -m space --focus 4;
        alt - 5 : yabai -m space --focus 5;
        alt - 6 : yabai -m space --focus 6;
        alt - 7 : yabai -m space --focus 7;

        # move window to space
        shift + alt - 1 : yabai -m window --space 1;
        shift + alt - 2 : yabai -m window --space 2;
        shift + alt - 3 : yabai -m window --space 3;
        shift + alt - 4 : yabai -m window --space 4;
        shift + alt - 5 : yabai -m window --space 5;
        shift + alt - 6 : yabai -m window --space 6;
        shift + alt - 7 : yabai -m window --space 7;

        # stop/start/restart yabai
        ctrl + alt - q : yabai --stop-service
        ctrl + alt - s : yabai --start-service
        ctrl + alt - r : yabai --restart-service

        # some handy emacs commands
        cmd + ctrl - c : emacsclient -e '(popup-frame-org-capture)' || yabai -m window --focus recent
        cmd + ctrl - x : emacsclient -e '(popup-frame-calc)' || yabai -m window --focus recent
      '';
    };

  };

}
