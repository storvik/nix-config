# This is a modified version of nixos/modules/profiles/installation-device.nix
# from nixpkg. root and live users are removed, and the original file is
# disabled using disabledModules.
{ config, pkgs, lib, ... }:

{

  # disable installation-device.nix
  disabledModules = [
    "profiles/installation-device.nix"
  ];

  system.nixos.variant_id = pkgs.lib.mkDefault "installer";

  # Enable in installer, even if the minimal profile disables it.
  documentation.enable = pkgs.lib.mkImageMediaOverride true;

  # Show the manual.
  documentation.nixos.enable = pkgs.lib.mkImageMediaOverride true;

  services.openssh = {
    enable = true;
  };

  # Tell the Nix evaluator to garbage collect more aggressively.
  # This is desirable in memory-constrained environments that don't
  # (yet) have swap set up.
  environment.variables.GC_INITIAL_HEAP_SIZE = "1M";

  # Make the installer more likely to succeed in low memory
  # environments.  The kernel's overcommit heustistics bite us
  # fairly often, preventing processes such as nix-worker or
  # download-using-manifests.pl from forking even if there is
  # plenty of free memory.
  boot.kernel.sysctl."vm.overcommit_memory" = "1";

  # To speed up installation a little bit, include the complete
  # stdenv in the Nix store on the CD.
  system.extraDependencies = with pkgs;
    [
      stdenv
      stdenvNoCC # for runCommand
      busybox
      jq # for closureInfo
      # For boot.initrd.systemd
      makeInitrdNGTool
      systemdStage1
      systemdStage1Network
    ];

  boot.swraid.enable = true;

  # Show all debug messages from the kernel but don't log refused packets
  # because we have the firewall enabled. This makes installs from the
  # console less cumbersome if the machine has a public IP.
  networking.firewall.logRefusedConnections = pkgs.lib.mkDefault false;

  # Prevent installation media from evacuating persistent storage, as their
  # var directory is not persistent and it would thus result in deletion of
  # those entries.
  environment.etc."systemd/pstore.conf".text = ''
    [PStore]
    Unlink=no
  '';

  # allow nix-copy to live system
  nix.settings.trusted-users = [ "root" "nixos" ];

}
