{ config, pkgs, lib, ... }:

with lib;

let

  storvik-backup = pkgs.writeScriptBin "storvik-backup" ''
    #!${pkgs.bash}/bin/bash

    ts=$(date +%Y%m%d-%H%M%S)
    hostname=$(hostname)

    echo "Going to home dir"
    pushd /home/$USER

    echo "Creating backup dir in home"
    mkdir -p backup

    echo "Backing up files"
    tar -cJvf backup/$ts.tar.xz \
        .ssh

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
      enableFishIntegration = true;
      enableNixDirenvIntegration = true;
    };

    # fzf overrides C-r history search
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
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
        # Colors (Doom One)
        # https://github.com/eendroroy/alacritty-theme/blob/master/themes/doom_one.yml
        colors = {
          primary = {
            background = "0x282c34";
            foreground = "0xbbc2cf";
          };
          normal = {
            black = "0x282c34";
            red = "0xff6c6b";
            green = "0x98be65";
            yellow = "0xecbe7b";
            blue = "0x51afef";
            magenta = "0xc678dd";
            cyan = "0x46d9ff";
            white = "0xbbc2cf";
          };
        };
        font = {
          normal = {
            family = "Fira Code";
          };
          bold = {
            family = "Fira Code";
          };
          italic = {
            family = "Fira Code";
          };
          size = 11;
        };
      };
    };

    home.packages = with pkgs; [
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science nb ]))
      bitwarden-cli
      bfg-repo-cleaner
      ltunify
      nmap
      pdftk
      rclone
      ripgrep
      storvik-backup
      unixtools.netstat
      unixtools.route
      whois
    ];

  };

}
