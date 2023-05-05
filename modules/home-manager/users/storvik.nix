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
    };

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

  };

}
