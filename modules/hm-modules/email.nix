{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (!cfg.disableEmail) {

    # mu init --maildir=~/developer/maildir --my-address=petter@svartisenfestivalen.no --my-address=petter@storvik.dev
    accounts.email = {
      maildirBasePath = "./developer/maildir";
      accounts = {
        "svartisenfestivalen" = {
          address = "petter@svartisenfestivalen.no";
          userName = "svartisenfestiv3";
          realName = "Petter S. Storvik";
          passwordCommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.petter_svartisenfestivalen_no.path}";
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
          passwordCommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.petter_storvik_dev.path}";
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

    programs.msmtp.enable = true;

    services.mbsync = {
      enable = true;
      frequency = "*:0/5";
      # postExec = "${pkgs.mu}/bin/mu index";
    };

    # https://github.com/nix-community/home-manager/issues/642
    programs.mbsync.enable = true;

    # this is needed in order to start mbsync after sops
    systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];

    programs.mu.enable = true;

  };

}
