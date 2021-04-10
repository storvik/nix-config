{ config, pkgs, lib, ... }:

with lib;

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
    #programs.tmux = {
    #  enable = true;
    #  clock24 = true;
    #  newSession = true;
    #  shell = "${pkgs.fish}/bin/fish";
    #};

    # Alacritty terminal emulator
    programs.alacritty = {
      enable = true;
      settings = {
        shell = {
          program = "${pkgs.fish}/bin/fish";
        };
      };
    };

    home.packages = with pkgs; [
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science nb ]))
      bitwarden-cli
      bfg-repo-cleaner
      ltunify
      nmap
      rclone
      ripgrep
      unixtools.netstat
      unixtools.route
      whois
    ];

  };

}
