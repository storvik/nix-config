{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.virtualization.enable = mkOption {
    default = true;
    description = "Enable virtualization tools";
    type = lib.types.bool;
  };

  config = {
    # Docker through home-manager doesn't work on non nixos systems
    home.packages = lib.mkIf (config.targets.genericLinux.enable != true) [
      pkgs.docker
      pkgs.lxc
    ];

    # Useful aliases
    programs.fish = {
      shellAliases = {

        # Docker remove intermediate
        drm-i = "docker rmi -f (docker images -q --filter label=stage=intermediate)";

        # Docker remove dangling
        drm-d = "docker rmi (docker images --quiet --filter 'dangling=true')";

        # Docker remove exited
        drm-e = "docker rm -v (docker ps -a -q -f status=exited)";

      };
    };
  };

}
