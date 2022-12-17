{ config, pkgs, lib, inputs, ... }:

with lib;

{

  config = mkIf config.storvik.wsl.enable {

    home.sessionVariables = {
      WSL = "1";
    };

  };

}
