{ config, pkgs, lib, ... }:

with lib;

{

  options.storvik.developer.enable = mkEnableOption "All developer tools";

}
