{ config, pkgs, lib, ... }:

{
  
  home.packages = with pkgsUnstable; [
    mu
  ];


  accounts.email = {
    maildirBasePath = builtins.toPath (homedir + "/Maildir");
    accounts = {
      "gmail" = {
        address = "petterstorvik@gmail.com";
        aliases = [ "petter@svartisenfestivalen.no" ];
        userName = "petterstorvik@gmail.com";
        realName = "Petter S. Storvik";
        primary = true;
        flavor = "gmail.com";
        offlineimap = {
          enable = true;
          extraConfig.local = {
            nametrans = "nametrans_gmail_remote_inverse";
          };
          extraConfig.remote = {
            remotepasseval = "get_pass('mbsync-gmail')";
            nametrans = "nametrans_gmail_remote";
            folderfilter = "lambda foldername: foldername not in ['Sakriheia.no', 'Emix', 'ArticAquaTrans', '[Gmail].Important', '[Gmail].Drafts']";
            maxconnections = 5;
          };
        };
      };
      "avantieng" = {
        address = "petter.storvik@avantieng.no";
        userName = "petter.storvik@avantieng.no";
        realName = "Petter S. Storvik";
        imap = {
          host = "outlook.office365.com";
          tls.enable = true;
        };
        offlineimap = {
          enable = true;
          extraConfig.local = {
            nametrans = "nametrans_avantieng_remote_inv";
          };
          extraConfig.remote = {
            remotepasseval = "get_pass('mbsync-avantieng')";
            nametrans = "nametrans_avantieng_remote";
            folderfilter = "lambda foldername: foldername in ['INBOX', 'Arkiv', 'Sendte elementer', 'Slettede elementer']";
          };
        };
      };
    };
  };

  programs.offlineimap = {
    enable = true;
    extraConfig.general = {
      accounts = "gmail,avantieng";
      maxsyncaccounts = 1;
    };
    pythonFile = ''
#! /usr/bin/env python2
import re
from subprocess import check_output

def get_pass(account):
    return check_output("lpass show --password " + account, shell=True).strip("\n")

def nametrans_gmail_remote(foldername):
    return re.sub ('^\[Gmail\].', ${"''"},
                   re.sub ('All\ Mail', 'All',
                           re.sub ('Sent\ Mail', 'Sent',
                                   re.sub ('INBOX', 'Inbox', foldername))))

def nametrans_gmail_remote_inverse(foldername):
    if foldername in ['All', 'Sent']:
        foldername = foldername + ' Mail'
    if foldername in ['All Mail',
                      'Drafts',
                      'Important',
                      'Sent Mail',
                      'Spam',
                      'Starred',
                      'Trash']:
        foldername = '[Gmail].' + foldername
    else:
        if foldername == 'Inbox':
            foldername = 'INBOX'
    return foldername
    

gmail_test_array = ['[Gmail].All Mail',
                    '[Gmail].Drafts',
                    '[Gmail].Important',
                    '[Gmail].Sent Mail',
                    '[Gmail].Spam',
                    '[Gmail].Starred',
                    '[Gmail].Trash',
                    'INBOX',
                    'Svartisenfestivalen',
                    'Emix',
                    'Sakriheia.no']

def nametrans_gmail_remote_test(): 
    for el in gmail_test_array:
        el_trans = nametrans_gmail_remote(el)
        el_trans_inv = nametrans_gmail_remote_inverse(el_trans)
        if el == el_trans_inv:
            test_ok = "[SUCCESS] "
        else:
            test_ok = "[!ERROR!] "
        print(test_ok + el + " --> " + el_trans + " --> " + el_trans_inv)

#nametrans_gmail_remote_test()

def nametrans_avantieng_remote(foldername):
    return {
        'INBOX': 'Inbox',
        'Arkiv': 'Archive',
        'Sendte elementer': 'Sent',
        'Slettede elementer': 'Trash',
    }.get(foldername, foldername)

def nametrans_avantieng_remote_inv(foldername):
    return {
        'Inbox': 'INBOX',
        'Archive': 'Arkiv',
        'Sent': 'Sendte elementer',
        'Trash': 'Slettede elementer',
    }.get(foldername, foldername)

avantieng_test_array = ['INBOX', 'Arkiv', 'Sendte elementer', 'Slettede elementer', 'Kalender']

def nametrans_avantieng_remote_test(): 
    for el in avantieng_test_array:
        el_trans = nametrans_avantieng_remote(el)
        el_trans_inv = nametrans_avantieng_remote_inv(el_trans)
        if el == el_trans_inv:
            test_ok = "[SUCCESS] "
        else:
            test_ok = "[!ERROR!] "
        print(test_ok + el + " --> " + el_trans + " --> " + el_trans_inv)

#nametrans_avantieng_remote_test()

    '';
  };

}
