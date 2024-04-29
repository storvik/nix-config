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
    ] ++ lib.optionals (!builtins.elem "android" cfg.devtools.disabledModules) [
      android.platform-tools
      android-studio
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
      govulncheck
      golangci-lint
    ] ++ lib.optionals (!builtins.elem "kotlin" cfg.devtools.disabledModules) [
      kotlin-language-server
    ] ++ lib.optionals (!builtins.elem "nix" cfg.devtools.disabledModules) [
      nil
      nixpkgs-fmt
      nixpkgs-review
      nix-prefetch-git
      nix-prefetch-github
    ] ++ lib.optionals (!builtins.elem "python" cfg.devtools.disabledModules) [
      nodePackages.pyright
    ] ++ lib.optionals (!builtins.elem "rust" cfg.devtools.disabledModules) [
      rust-analyzer-unwrapped
      clippy
    ] ++ lib.optionals (!builtins.elem "web" cfg.devtools.disabledModules) [
      cljfmt
      clojure-lsp
      html-tidy
      clojure
      nodejs
      yarn
    ];

    programs.go = {
      enable = (!builtins.elem "go" cfg.devtools.disabledModules);
      goPath = "developer/gopath";
      goBin = "developer/gopath/bin";
    };

  };

}
