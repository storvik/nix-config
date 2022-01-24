{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.storvik.forensics.enable {

    home.packages = with pkgs; [ ]
      ++ lib.optionals (builtins.elem "reverse" config.storvik.forensics.modules)
      [
        binutils
        elfutils
        ghidra-bin
        patchelf
        radare2
        retdec
        volatility3
      ]
      ++ lib.optionals (builtins.elem "recon" config.storvik.forensics.modules)
      [
        nmap
        wireshark
      ]
      ++ lib.optionals (builtins.elem "exploit" config.storvik.forensics.modules)
      [
        metasploit
      ];

  };

}
