{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.remotelogin.enable {

    services.openssh.enable = true;

  };

}
