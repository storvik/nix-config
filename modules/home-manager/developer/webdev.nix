{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.web.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        clojure-lsp
        html-tidy
        nodejs-16_x
        nodePackages.prettier
        nodePackages.typescript
        nodePackages.typescript-language-server
        yarn
      ];
    };

}
