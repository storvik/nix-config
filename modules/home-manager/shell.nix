{ config, pkgs, lib, ... }:

with lib;

let

  storvik-backup = pkgs.writeScriptBin "storvik-backup-this-computer" ''
    #!${pkgs.bash}/bin/bash

    ts=$(date +%Y%m%d-%H%M%S)
    hostname=$(hostname)

    echo "Going to home dir"
    pushd /home/$USER

    echo "Creating backup dir in home"
    mkdir -p backup

    echo "Backing up files"
    tar -cJvf backup/$ts.tar.xz \
        .ssh \
        .netrc

    echo "Creating remote backup dir"
    rclone mkdir pcloud:backup/$hostname

    echo "Copying archive to remote"
    rclone copy backup/$ts.tar.xz pcloud:backup/$hostname

    notify-send "Backup complete" "Backup script run and backup is uploaded to pCloud"

    popd
  '';

in

{

  config = mkIf config.storvik.shell.enable {
    # I use fish as my shell
    programs.fish = {
      enable = true;
      shellAliases = { };
      shellInit = ''
        # Supress greeting
        set fish_greeting

        # Custom title
        function fish_title
            basename (pwd)
        end
      '';
    };

    # but let home-manager manage bash too
    programs.bash = {
      enable = true;
      historyIgnore = [ "l" "ls" "ll" "cd" "exit" ];
      historyControl = [ "erasedups" ];
      shellAliases = {
        grep = "grep --color=auto";
        ".." = "cd ..";
      };
      initExtra = ''
        # Custom colored bash prompt
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      '';
      profileExtra = ''
        # Include user's private bin if present
        if [ -d "$HOME/.local/bin" ] ; then
            PATH="$HOME/.local/bin:$PATH"
        fi

        # Add nix installation
        if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
      '';

    };

    # direnv
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      # enableFishIntegration = true; # read-only
      nix-direnv.enable = true;
    };

    # fzf overrides C-r history search
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
    };

    # lsd is a modern ls replacement
    programs.lsd = {
      enable = true;
      enableAliases = true;
    };

    # NOT WORKING ON NIXOS
    programs.tmux = {
      enable = true;
      clock24 = true;
      newSession = true;
      shell = "${pkgs.fish}/bin/fish";
      extraConfig = ''
        # Mouse mode to select windows / panes
        set -g mouse on
        # tmux window title
        set-option -g status-interval 2
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{?#{==:#{pane_current_command},fish},#{pane_title},#{pane_current_command}}'
      '';
    };

    # Alacritty terminal emulator
    programs.alacritty = {
      enable = true;
      settings = {
        shell = {
          program = "${pkgs.fish}/bin/fish";
        };
        scrolling = {
          multiplier = 3;
        };
        window = {
          decorations = "None";
        };
        # Project:    Nord Alacritty
        # Version:    0.1.0
        # Repository: https://github.com/arcticicestudio/nord-alacritty
        # License:    MIT
        # References:
        #   https://github.com/alacritty/alacritty
        colors = {
          primary = {
            background = "#2e3440";
            foreground = "#d8dee9";
            dim_foreground = "#a5abb6";
          };
          cursor = {
            text = "#2e3440";
            cursor = "#d8dee9";
          };
          vi_mode_cursor = {
            text = "#2e3440";
            cursor = "#d8dee9";
          };
          selection = {
            text = "CellForeground";
            background = "#4c566a";
          };
          search = {
            matches = {
              foreground = "CellBackground";
              background = "#88c0d0";
            };
            bar = {
              background = "#434c5e";
              foreground = "#d8dee9";
            };
          };
          normal = {
            black = "#3b4252";
            red = "#bf616a";
            green = "#a3be8c";
            yellow = "#ebcb8b";
            blue = "#81a1c1";
            magenta = "#b48ead";
            cyan = "#88c0d0";
            white = "#e5e9f0";
          };
          bright = {
            black = "#4c566a";
            red = "#bf616a";
            green = "#a3be8c";
            yellow = "#ebcb8b";
            blue = "#81a1c1";
            magenta = "#b48ead";
            cyan = "#8fbcbb";
            white = "#eceff4";
          };
          dim = {
            black = "#373e4d";
            red = "#94545d";
            green = "#809575";
            yellow = "#b29e75";
            blue = "#68809a";
            magenta = "#8c738c";
            cyan = "#6d96a5";
            white = "#aeb3bb";
          };
        };
        font = {
          normal = {
            family = "Iosevka Nerd Font";
          };
          bold = {
            family = "Iosevka Nerd Font";
          };
          italic = {
            family = "Iosevka Nerd Font";
          };
          size = 11;
        };
      };
    };

    home.packages = with pkgs; [
      bitwarden-cli
      bfg-repo-cleaner
      dtach
      ltunify
      pdftk
      rclone
      storvik-backup
      tree
      unixtools.netstat
      unixtools.route
      whois
    ];

  };

}
