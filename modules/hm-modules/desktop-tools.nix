{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf cfg.waylandTools {
    # imv image viewer
    programs.imv = {
      enable = true;
      settings =
        let
          # ${notify} "$1 deleted"
          imv-delete = pkgs.writeScriptBin "delete" ''
            rm $1
            ${pkgs.imv}/bin/imv-msg $2 next
          '';
          # ${notify} "Path $1 copied to clipboard"
          imv-copypath = pkgs.writeScriptBin "copypath" ''
            ${pkgs.wl-clipboard}/bin/wl-copy $1
          '';
          # ${notify} "Image $1 copied to clipboard"
          imv-copyimage = pkgs.writeScriptBin "copyimage" ''
            ${pkgs.wl-clipboard}/bin/wl-copy < $1
          '';
        in
        {
          options = {
            background = "263238";
            overlay_font = "${if cfg.disableNerdfonts then "Iosevka" else "Iosevka Nerd Font"}:12";
          };
          binds = {
            p = "prev";
            n = "next";
            "<Shift+D>" = "exec ${imv-delete}/bin/delete $imv_current_file $imv_pid";
            "<Shift+I>" = "exec ${imv-copyimage}/bin/copyimage $imv_current_file";
            "<Shift+P>" = "exec ${imv-copypath}/bin/copypath $imv_current_file";
          };
        };
    };

    programs.sioyek.enable = true;

  };

}
