{ config, pkgs, lib, ... }:
let

  homedir = builtins.getEnv "HOME";

in
{

  imports = [
    ../../home-manager/profiles/emacs.nix # emacs
  ];

  home.username = "storvik";
  home.homeDirectory = "/home/storvik";

  # Git
  programs.git = {
    enable = true;
    userEmail = "petterstorvik@gmail.com";
    userName = "storvik";
    extraConfig = {
      pull.ff = "only";
      #url = {
      #  "git@github.com:" = {
      #    insteadOf = "https://github.com/";
      #  };
      #};
    };
    ignores = [ ".ccls*" "npm-debug.log" ".DS_Store" "Thumbs.db" ".dir-locals.el" ];
  };

  # If $HOME/emacs.d doesn't exist clone my git config read only
  #home.file.".emacs.d" = lib.mkIf (builtins.pathExists (homedir + "/emacs.d") == false) {
  #  source = builtins.fetchTarball https://github.com/storvik/.emacs.d/archive/master.tar.gz;
  #  recursive = true;
  #};

  #home.activation.linkemacs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #  if [ -d "${builtins.toPath (homedir + "/emacs.d")}" ]; then
  #    echo "${builtins.toPath (homedir + "/emacs.d")} exists, symlinking"
  #    [ -d "${builtins.toPath (homedir + "/.emacs.d")}" ] && $DRY_RUN_CMD rm -rf ${builtins.toPath (homedir + "/.emacs.d")}
  #    $DRY_RUN_CMD ln -s $VERBOSE_ARG \
  #      ${builtins.toPath (homedir + "/emacs.d")} \
  #      ${builtins.toPath (homedir + "/.emacs.d")}
  #  else
  #    echo "${builtins.toPath (homedir + "/emacs.d")} doesn't exist"
  #  fi
  #'';


  # I use fish
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
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      ll = "ls -alF";
      la = "ls -A";
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

  # Environment
  home.sessionVariables = {
    EDITOR = "emacs";
  };

}
