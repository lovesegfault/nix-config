final: prev:
with prev.lib;
with builtins;
composeManyExtensions
  (map
    (f: import (./. + "/${f}"))
    (remove "default.nix" (attrNames (readDir ./.)))
  )
  final
  prev
