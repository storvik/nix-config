# Overlay that includes all overlays
self: super:

with super.lib;

(foldl' (flip extends) (_: super)
  (map import (import ./overlays.nix)))
  self
