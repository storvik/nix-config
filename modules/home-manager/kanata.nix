{ config, pkgs, lib, ... }:

with lib;

let

  storvik-kanata = pkgs.writeShellScriptBin "storvik-kanata" ''
    ${pkgs.libnotify}/bin/notify-send "kanata is starting, don't touch keyboard for a couple of seconds..."
    ${pkgs.kanata}/bin/kanata --cfg .config/kanata/config.kbd
  '';

in

{

  config = mkIf config.storvik.kanata.enable {

    systemd.user.services.kanata = {
      Unit = {
        Description = "kanata service";
      };
      Service = {
        Type = "simple";
        ExecStart = "${storvik-kanata}/bin/storvik-kanata";
      };
    };



    xdg.configFile."kanata/config.kbd" = {
      onChange = "systemctl --user restart kanata.service";
      source = ./dotfiles/kanataconfig.kbd;
    };

  };

}
