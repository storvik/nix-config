{ config, lib, ... }:

{

  options.storvik = {

    enableAerospace =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable Aerospace tiling window manager for MacOs.
        '';
      };


    enableYabai =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable Yabai tiling window manager for MacOs.
        '';
      };

    virtualization =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable virtualization tools for MacOs.

          Currently only UTM is installed when this is enabled.
        '';
      };

  };

}
