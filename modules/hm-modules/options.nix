{ config, lib, ... }:

{

  options.storvik = {
    desktop = lib.mkOption {
      type = lib.types.enum [
        "none"
        "gnome"
        "hyprland"
      ];
      default = "none";
      description = lib.mdDoc ''
        Which desktop environment to use, if any.
      '';
    };
    disableEmacsDaemon =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Disable Emacs daemon.
        '';
      };
    disableNerdfonts =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Disable nerdfonts, useful when system is supposed to be deployed with deploy-rs.
        '';
      };
    disableGPG =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Disable GPG, can be useful on server or live host.
        '';
      };
    gitSigningKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = lib.mdDoc ''
        Git signing key, can be omitted using null value.

        > If using subkey, remember to append `!` to key ID.
      '';
    };
    waylandTools =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable collection of useful wayland tools.

          Wayland tools includes:
          - imv (image viewer)
          - sioyek (pdf viewer)
        '';
      };
    devtools = {
      enable =
        lib.mkEnableOption null
        // {
          default = false;
          description = lib.mdDoc ''
            Enable developer tooling.
          '';
        };
      disabledModules = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = lib.mdDoc ''
          List of strings that describes developer modules to disable.

          Possible values:
          [ "android" "c" "go" "nix" "web" ]
        '';
      };
    };
    forensics = {
      enable =
        lib.mkEnableOption null
        // {
          default = false;
          description = lib.mdDoc ''
            Enable forensic tools.
          '';
        };
      disabledModules = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          List of strings that describes forensic modules to disable.

          Possible values:
          [ "reverse" "recon" "exploit" ]
        '';
      };
    };
    gnomeAutostartPkgs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        '';
    };
    disableEmail =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Disable email config
        '';
      };
    enableWSL =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable WSL specific config.
        '';
      };
    texlive =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable texlive, installing texlive-full.
        '';
      };
    designer =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable graphics designer tools.
        '';
      };
    cad =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable cad tools.
        '';
      };
    studio =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable programs that can be used to edit audio and video.
        '';
      };
    media =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable programs that can be used to multimedia content, audio and video.
        '';
      };
    social =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable social programs, such as signal.
        '';
      };
    ai = {
      enable =
        lib.mkEnableOption null
        // {
          default = false;
          description = lib.mdDoc ''
            Enable ai tools.
          '';
        };
      enableOllama =
        lib.mkEnableOption null
        // {
          default = true;
          description = lib.mdDoc ''
            Enable ollama service.
          '';
        };
    };

  };

}
