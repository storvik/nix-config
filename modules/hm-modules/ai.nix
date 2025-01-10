{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;
in
{

  config = lib.mkIf (cfg.ai.enable) {
    home.packages = with pkgs; [
      aider-chat
      ollama
    ];

    systemd.user.services.ollama = lib.mkIf (cfg.ai.enableOllama) {
      Unit = {
        Description = "Ollama server";
      };
      Service = {
        ExecStart = "${pkgs.ollama}/bin/ollama serve";
        Restart = "always";
        RestartSec = "3";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

  };

}
