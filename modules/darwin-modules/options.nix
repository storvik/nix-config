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
  };

}
