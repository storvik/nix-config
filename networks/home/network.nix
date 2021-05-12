{
  network = {
    description = "My home network";
  };

  # Target intel nuc
  "intel-nuc" = { config, pkgs, lib, ... }: {

    imports = [ ../../configs/storvik-gnome-nixos-nuc.nix ];

    deployment.targetUser = "root";
    deployment.targetHost = "192.168.0.121";
  };
}
