# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/d2d12dc1-7bb6-4123-8ca9-0c1292ab6412";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/4255-8FFD";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/64c23914-22c0-433d-a7c9-f698f7ae8bb8"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
