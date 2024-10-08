{ config, lib, ... }:

{

  options.storvik = {

    disableYabai =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Disable Yabai tiling window manager for MacOs.
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
