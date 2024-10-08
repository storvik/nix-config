inputs: { ... }:

{

  imports = [
    ./darwin-modules/options.nix
    ./darwin-modules/common.nix
    ./darwin-modules/yabai.nix
    ./darwin-modules/virtualization.nix
  ];

}
