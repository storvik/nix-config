{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.user.storvik.enable {

    # Git
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
      hooks =
        let
          pre-commit-hook = pkgs.writeShellScriptBin "git-pre-commit-check-gpg" ''
            (git remote -v | grep -Eq  github) || exit 0  # If not in a github repo, gpg is not used
            git config user.signingkey > /dev/null 2>&1
          '';
        in
        {
          pre-commit = "${pre-commit-hook}/bin/git-pre-commit-check-gpg";
        };
      signing = {
        key = null;
        signByDefault = true;
      };
    };

    programs.git-cliff = {
      enable = true;
      settings = {
        header = "Changelog";
        trim = true;
      };
    };

    home.packages =
      let
        ent = pkgs.writeScriptBin "github-ent" ''
          #!${pkgs.bash}/bin/bash
          git config user.name "petter-storvik_goodtech"
          git config user.email "petter.storvik@goodtech.no"
        '';
        priv = pkgs.writeScriptBin "github-priv" ''
          #!${pkgs.bash}/bin/bash
          git config user.name "storvik"
          git config user.email "petterstorvik@gmail.com"
        '';
      in
      [
        ent
        priv
      ];

    # mu init --maildir=~/developer/maildir --my-address=petter@svartisenfestivalen.no --my-address=petter@storvik.dev
    accounts.email = mkIf config.storvik.user.storvik.email.enable {
      maildirBasePath = "./developer/maildir";
      accounts = {
        "svartisenfestivalen" = {
          address = "petter@svartisenfestivalen.no";
          userName = "svartisenfestiv3";
          realName = "Petter S. Storvik";
          passwordCommand = "${pkgs.coreutils}/bin/cat ~/developer/.secrets/petter@svartisenfestivalen.no.pass";
          primary = true;
          signature = {
            text = ''
              Med vennlig hilsen / Kind regards
              Petter Sakrihei Storvik

              Svartisenfestivalen
              Booking / Sponsorkontakt
              Web: svartisenfestivalen.no
              Phone: +47 958 83 676
              E-mail: petter@svartisenfestivalen.no
            '';
            showSignature = "append";
          };
          imap.host = "imap.domeneshop.no";
          smtp.host = "smtp.domeneshop.no";
          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
          };
          msmtp.enable = true;
        };
        "storvikdev" = {
          address = "petter@storvik.dev";
          userName = "storvikdev1";
          realName = "Petter S. Storvik";
          passwordCommand = "${pkgs.coreutils}/bin/cat ~/developer/.secrets/petter@storvik.dev.pass";
          signature = {
            text = ''
              Med vennlig hilsen / Kind regards
              Petter Sakrihei Storvik
            '';
            showSignature = "append";
          };
          imap.host = "imap.domeneshop.no";
          smtp.host = "smtp.domeneshop.no";
          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
          };
          msmtp = {
            enable = true;
            extraConfig = {
              port = "587";
              tls = "on";
              tls_starttls = "on";
              auth = "on";
            };
          };
        };
      };
    };

    programs.msmtp.enable = config.storvik.user.storvik.email.enable;

    services.mbsync = mkIf config.storvik.user.storvik.email.enable {
      enable = true;
      frequency = "*:0/5";
      # postExec = "${pkgs.mu}/bin/mu index";
    };

    # https://github.com/nix-community/home-manager/issues/642
    programs.mbsync.enable = config.storvik.user.storvik.email.enable;

    programs.mu = mkIf config.storvik.user.storvik.email.enable {
      enable = true;
    };

    programs.gpg = {
      enable = true;
      settings = {
        pinentry-mode = "loopback"; # This is needed in order to allow emacs to act as pinentry
      };
    };


    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      pinentryFlavor = if config.storvik.wsl.enable then null else "qt"; # When set to null it does not set pinentry-program in conf
      extraConfig = if config.storvik.wsl.enable then "pinentry-program /mnt/c/Users/petter.storvik/scoop/apps/gpg4win/current/Gpg4win/bin/pinentry.exe" else "allow-loopback-pinentry";
    };

  };

}
