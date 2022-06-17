{ config, pkgs, lib, inputs, ... }:

with lib;

let

  gwslSessionVariables = {
    DISPLAY = "\$(cat /etc/resolv.conf | grep nameserver | awk '{print \$2; exit;}'):0.0";
    PULSE_SERVER = "tcp:\$(cat /etc/resolv.conf | grep nameserver | awk '{print \$2; exit;}')";
    LIBGL_ALWAYS_INDIRECT = 1;
  };

in

{

  config = mkIf config.storvik.wsl.enable {

    home.sessionVariables = {
      WSL = "1";
    } // (if config.storvik.wsl.gwsl then gwslSessionVariables else { });

  };

}
