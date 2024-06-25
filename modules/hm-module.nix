inputs: { ... }:

{

  imports = [
    ./hm-modules/options.nix
    (import ./hm-modules/common.nix inputs)
    ./hm-modules/email.nix
    ./hm-modules/desktop-hyprland.nix
    ./hm-modules/desktop-tools.nix
    ./hm-modules/devtools.nix
    ./hm-modules/wsl.nix
    ./hm-modules/designer.nix
    ./hm-modules/cad.nix
    ./hm-modules/ai.nix
    ./hm-modules/social.nix
    ./hm-modules/media.nix
    ./hm-modules/texlive.nix
    ./hm-modules/forensics.nix
  ];

}
