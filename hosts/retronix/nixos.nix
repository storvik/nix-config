{ config, pkgs, ... }:

{

  storvik = {
    remoteLogon = true;
    desktop = "gnome";
    kanata = true;
  };

  sops = {
    age.sshKeyPaths = [ "/home/storvik/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets.yaml;
    secrets.retro_user_password = {
      neededForUsers = true;
    };
    secrets.storvik_user_password = {
      neededForUsers = true;
    };
  };

  users.mutableUsers = false;

  users.users.storvik.hashedPasswordFile = config.sops.secrets.storvik_user_password.path;

  users.users.retro = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.retro_user_password.path;
    extraGroups = [
      "networkmanager"
      "audio"
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "retro";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # TODO: Move this into its own module
  environment.systemPackages = with pkgs; [
    (retroarch.override {
      cores = with libretro; [
        beetle-psx-hw
        dolphin
        genesis-plus-gx
        mgba
        mupen64plus
        pcsx2
        pcsx-rearmed
        snes9x
        vba-next
      ];
    })
  ];

}
