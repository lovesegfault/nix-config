{ lib, pkgs, ... }: with builtins;
let
  userDirs = attrNames (lib.filterAttrs (_: v: v == "directory") (readDir ./.));
  mkUser = u:
    let
      mod = import (./. + "/${u}") { inherit lib pkgs; };
    in {
      "users.users.${u}" = mod.system;
      "home-manager.users.${u}" = mod.home;
    };
  users = (lib.genAttrs userDirs mkUser);
in
users
