{ lib, pkgs, ... }: with builtins;
let
  userDirs = attrNames (lib.filterAttrs (_: v: v == "directory") (readDir ./.));
  mkUserPath = u: (./. + "/${u}");
  userAttrs = lib.genAttrs userDirs mkUserPath;
  userSingletons = lib.mapAttrs (_: v: (lib.singleton v)) userAttrs;
in {
  ops = with userAttrs; [ bemeurer ];
  dev = with userAttrs; [ bemeurer ];
} // userSingletons
