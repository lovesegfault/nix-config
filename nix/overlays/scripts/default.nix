self: super:
let
  inherit (super.lib) attrNames foldr remove;

  scripts = remove "default.nix" (attrNames (builtins.readDir ./.));
  scriptDrvs = map (s: import (./. + "/${s}") self super) scripts;
  joinAttrs = foldr (a: b: a // b) { };
in
joinAttrs scriptDrvs
