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
    fonts.fontconfig = lib.mkIf pkgs.stdenv.isLinux {
      enable = (cfg.desktop != "none" || cfg.enableWSL);
    };

    # SSH config
    programs.ssh = {
      enable = true;
      # forwardAgent = true; # security wise it's probably smart to don't enable this, but use it per connection
      includes = [ "~/.ssh/config.d/*" ];
    };

    services.ssh-agent.enable = pkgs.stdenv.isLinux;

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

    programs.nix-index.enable = true;

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      # enableFishIntegration = true; # read-only
      nix-direnv.enable = true;
    };

    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
    };

    programs.lsd = {
      enable = true;
      enableAliases = true;
      settings = {
        icons.separator = "  ";
        ignore-globs = [
          ".git"
          ".hg"
        ];
      };
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        search_mode = "prefix";
      };
    };

    programs.broot = {
      enable = true;
    };

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

    services.gpg-agent = lib.mkIf pkgs.stdenv.isLinux {
      enable = (!cfg.disableGPG);
      enableBashIntegration = true;
      enableFishIntegration = true;
      pinentryPackage = pkgs.pinentry-qt;
      extraConfig = "allow-loopback-pinentry";
    };


    programs.alacritty = {
      enable = true;
      settings = {
        terminal.shell = {
          program = "${pkgs.fish}/bin/fish";
        };
        scrolling = {
          multiplier = 3;
        };
        window = {
          decorations = "buttonless";
        };
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
          };
          footer_bar = {
            background = "#434c5e";
            foreground = "#d8dee9";
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
          size = 13;
        };
      };
    };

    programs.firefox = {
      enable = (!cfg.enableWSL && (cfg.desktop != "none"));
      package = pkgs.firefox-wayland;
    };

    programs.emacs = {
      enable = (!cfg.disableEmacs);
      package = pkgs.storvik-emacs-withPackages;
    };

    services.emacs = lib.mkIf pkgs.stdenv.isLinux {
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

    home.packages = with pkgs; [
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science nb ]))
      (hunspellWithDicts (with hunspellDicts; [ en-us-large nb-no ]))
      # have to install dictionaries separately in order for enchant (used by emacs jinx) to find them
      hunspellDicts.en-us-large
      hunspellDicts.nb-no
      nuspell
      enchant
      graphviz
      ripgrep
      dtach
      localsend
      pdftk
      rclone
      simple-http-server
      tree
      unixtools.netstat
      unixtools.route
      whois
    ] ++ lib.optionals (cfg.desktop != "none" || cfg.enableWSL) [
      fira-code
      fira-code-symbols
      iosevka
    ] ++ lib.optionals (!cfg.disableNerdfonts) [
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.symbols-only
    ];

  };

}
