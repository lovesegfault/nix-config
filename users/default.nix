with builtins;
let
  lib = import ../nix/lib.nix;
  userDirs = attrNames (lib.filterAttrs (_: v: v == "directory") (readDir ./.));
  mkUser = u: import (./. + "/${u}");
  users = lib.genAttrs userDirs mkUser;
in
{
  stream = with users; [ bemeurer cloud ekleog ogle ];
} // users
