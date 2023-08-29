{ config, lib, pkgs, ... }:
let
  cfg = config.storvik;

  android = pkgs.androidenv.composeAndroidPackages { };
in
{

  config = lib.mkIf (cfg.devtools.enable) {

    programs.git-cliff = {
      enable = true;
      settings = {
        header = "Changelog";
        trim = true;
      };
    };

    home.packages = with pkgs; [
      tree-sitter
    ] ++ lib.optionals (!builtins.elem "android" cfg.devtools.disabledModules) [
      android.platform-tools
      apktool
      scrcpy
    ] ++ lib.optionals (!builtins.elem "c" cfg.devtools.disabledModules) [
      clang-tools
      cmake
      gdb
      protobuf
      ninja
      meson
    ] ++ lib.optionals (!builtins.elem "go" cfg.devtools.disabledModules) [
      delve
      gopls
      gotools
    ] ++ lib.optionals (!builtins.elem "nix" cfg.devtools.disabledModules) [
      nixpkgs-fmt
      nixpkgs-review
      nix-prefetch-git
      nix-prefetch-github
    ] ++ lib.optionals (!builtins.elem "web" cfg.devtools.disabledModules) [
      clojure-lsp
      html-tidy
      nodePackages.prettier
      nodePackages.typescript
      nodePackages.typescript-language-server
      yarn
      zprint
    ];

    programs.go = {
      enable = (!builtins.elem "go" cfg.devtools.disabledModules);
      goPath = "developer/gopath";
      goBin = "developer/gopath/bin";
    };

  };

}
