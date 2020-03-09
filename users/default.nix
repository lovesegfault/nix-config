with builtins;
let
  lib = import ../nix/lib.nix;
  userDirs = attrNames (lib.filterAttrs (_: v: v == "directory") (readDir ./.));
  mkUserPath = u: (./. + "/${u}");
  userAttrs = lib.genAttrs userDirs mkUserPath;
in
{
  ops = with userAttrs; [ bemeurer ];
  dev = with userAttrs; [ bemeurer ];
} // userAttrs
