{ lib, ... }:
lib.mapAttrs'
  (basename: _: lib.nameValuePair
    (lib.removeSuffix ".nix" basename)
    (import (./. + "/${basename}"))
  )
  (lib.filterAttrs
    (n: _: n != "default.nix")
    (builtins.readDir ./.)
  )
