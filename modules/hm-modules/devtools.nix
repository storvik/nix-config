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
      codeium
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
      pyright
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

    programs.ruff = {
      enable = (!builtins.elem "python" cfg.devtools.disabledModules);
      settings = {
        # Exclude a variety of commonly ignored directories.
        exclude = [
          ".bzr"
          ".direnv"
          ".eggs"
          ".git"
          ".git-rewrite"
          ".hg"
          ".ipynb_checkpoints"
          ".mypy_cache"
          ".nox"
          ".pants.d"
          ".pyenv"
          ".pytest_cache"
          ".pytype"
          ".ruff_cache"
          ".svn"
          ".tox"
          ".venv"
          ".vscode"
          "__pypackages__"
          "_build"
          "buck-out"
          "build"
          "dist"
          "node_modules"
          "site-packages"
          "venv"
        ];

        # Same as Black.
        line-length = 88;
        indent-width = 4;

        # Assume Python 3.8
        target-version = "py38";

        lint = {
          # Enable Pyflakes (`F`) and a subset of the pycodestyle (`E`)  codes by default.
          select = [ "E4" "E7" "E9" "F" ];
          ignore = [ ];

          # Allow fix for all enabled rules (when `--fix`) is provided.
          fixable = [ "ALL" ];
          unfixable = [ ];

          # Allow unused variables when underscore-prefixed.
          dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$";
        };

        format = {
          # Like Black, use double quotes for strings.
          quote-style = "double";

          # Like Black, indent with spaces, rather than tabs.
          indent-style = "space";

          # Like Black, respect magic trailing commas.
          skip-magic-trailing-comma = false;

          # Like Black, automatically detect the appropriate line ending.
          line-ending = "auto";
        };
      };
    };

  };

}
