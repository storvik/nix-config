{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf cfg.kanata.enable {

    services.kanata = {
      enable = true;
      package = pkgs.kanata-with-cmd;
      keyboards.default = {
        # extraArgs = [ "--debug" ];
        extraDefCfg = "danger-enable-cmd yes";
        config = (builtins.readFile ./miryoku.kbd);
      };
    };

  };

}
