{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.forensics) {
    home.packages = with pkgs; [
    ] ++ lib.optionals (!builtins.elem "reverse" cfg.forensics.disabledModules) [
      binutils
      elfutils
      ghidra-bin
      patchelf
      radare2
      retdec
      volatility3
      netcat-openbsd
    ] ++ lib.optionals (!builtins.elem "recon" cfg.forensics.disabledModules) [
      nmap
      wireshark
    ] ++ lib.optionals (!builtins.elem "exploit" cfg.forensics.disabledModules) [
      metasploit
      burpsuite
      john
      chntpw
    ];
  };

}
