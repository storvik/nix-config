{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  # TODO: As this one grows it should be split in several files?
  config = lib.mkIf (cfg.forensics.enable) {
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
      imhex
    ] ++ lib.optionals (!builtins.elem "recon" cfg.forensics.disabledModules) [
      mitmproxy
      mqttx
      nmap
      opcua-client-gui
      wireshark
    ] ++ lib.optionals (!builtins.elem "exploit" cfg.forensics.disabledModules) [
      metasploit
      burpsuite
      john
      chntpw
    ] ++ lib.optionals (!builtins.elem "nfc" cfg.forensics.disabledModules) [
      libnfc
      imhex
      mfcuk
      mfoc
      mfoc-hardnested
    ];
  };

}
