inputs: { ... }:

{

  imports = [
    ./darwin-modules/options.nix
    ./darwin-modules/aerospace.nix
    (import ./darwin-modules/common.nix inputs)
    ./darwin-modules/yabai.nix
    ./darwin-modules/virtualization.nix
  ];

}
