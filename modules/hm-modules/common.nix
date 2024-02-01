inputs: { config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = {

    assertions = [
      {
        assertion = builtins.elem cfg.desktop [ "none" "gnome" "hyprland" ];
        message = "storvik.desktop got invalid value.";
      }
    ];

    home.stateVersion = lib.mkDefault "22.11";

    # Change NIX_PATH in order to pin nixpkgs to current version. This way
    # `nix shell` etc uses the same nixpkgs version as system configuration.
    home.sessionVariables = {
      NIX_PATH = "nixpkgs=${inputs.nixpkgs}\${NIX_PATH:+:}$NIX_PATH";
    };


    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Get all documentations too
    # home.extraOutputsToInstall = [ "man" ];

    # Custom fonts
    fonts.fontconfig.enable = (cfg.desktop != "none" || cfg.enableWSL);

    # SSH config
    programs.ssh = {
      enable = true;
      # forwardAgent = true; # security wise it's probably smart to don't enable this, but use it per connection
      includes = [ "~/.ssh/config.d/*" ];
    };

    services.ssh-agent.enable = true;

    # Fish shell
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

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };


    # Git settings
    programs.git = {
      enable = true;
      userEmail = "petterstorvik@gmail.com";
      userName = "storvik";
      extraConfig = {
        pull.ff = "only";
      };
      ignores = [
        ".ccls*"
        "npm-debug.log"
        ".DS_Store"
        "Thumbs.db"
        ".dir-locals.el"
        "compile_commands.json"
        ".envrc"
        ".direnv"
        "result"
      ];
      signing = lib.mkIf (cfg.gitSigningKey != null) {
        key = cfg.gitSigningKey;
        signByDefault = true;
      };
    };

    programs.gpg = {
      enable = (!cfg.disableGPG);
      settings = {
        pinentry-mode = "loopback"; # This is needed in order to allow emacs to act as pinentry
      };
    };

    services.gpg-agent = {
      enable = (!cfg.disableGPG);
      enableBashIntegration = true;
      enableFishIntegration = true;
      pinentryFlavor = "qt";
      extraConfig = "allow-loopback-pinentry";
    };

    programs.foot = {
      enable = (cfg.desktop != "none");
      settings = {
        main = {
          shell = "${pkgs.fish}/bin/fish";
          term = "xterm-256color";

          font = "${if cfg.disableNerdfonts then "Iosevka" else "Iosevka Nerd Font"}:size=8";
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

    programs.firefox = {
      enable = (!cfg.enableWSL && (cfg.desktop != "none"));
      package = pkgs.firefox-wayland;
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
    };

    services.emacs = {
      enable = (!cfg.disableEmacsDaemon);
      defaultEditor = true;
      client = {
        enable = true;
        arguments = [
          "-c"
          "-a emacs"
        ];
      };
    };

    home.packages =
      with pkgs; let
        ent = writeScriptBin "github-ent" ''
          #!${pkgs.bash}/bin/bash
          git config user.name "petter-storvik_goodtech"
          git config user.email "petter.storvik@goodtech.no"
        '';
        priv = writeScriptBin "github-priv" ''
          #!${pkgs.bash}/bin/bash
          git config user.name "storvik"
          git config user.email "petterstorvik@gmail.com"
        '';
      in
      [
        ent
        priv
        (aspellWithDicts (dicts: with dicts; [ en en-computers en-science nb ]))
        graphviz
        ripgrep
        dtach
        ltunify
        pdftk
        rclone
        tree
        unixtools.netstat
        unixtools.route
        whois
      ] ++ lib.optionals (cfg.desktop != "none" || cfg.enableWSL) [
        fira-code
        fira-code-symbols
        iosevka
      ] ++ lib.optionals (!cfg.disableNerdfonts) [
        nerdfonts
      ];

  };

}
