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

    programs.foot = {
      enable = true;
      settings = {
        main = {
          shell = "${pkgs.fish}/bin/fish";
          term = "xterm-256color";

          font = "Iosevka:size=8";
          dpi-aware = "yes";
        };
        colors = {
          foreground = "ECEFF1";
          background = "263238";
          regular0 = "546E7A"; # black
          regular1 = "FF5252"; # red
          regular2 = "5CF19E"; # green
          regular3 = "FFD740"; # yellow
          regular4 = "40C4FF"; # blue
          regular5 = "FF4081"; # magenta
          regular6 = "64FCDA"; # cyan
          regular7 = "FFFFFF"; # white
          bright0 = "B0BEC5"; # bright black
          bright1 = "FF8A80"; # bright red
          bright2 = "B9F6CA"; # bright green
          bright3 = "FFE57F"; # bright yellow
          bright4 = "80D8FF"; # bright blue
          bright5 = "FF80AB"; # bright magenta
          bright6 = "A7FDEB"; # bright cyan
          bright7 = "FFFFFF"; # bright white
        };
      };
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
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
