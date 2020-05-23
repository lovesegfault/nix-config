{ sources ? import ./nix, lib ? sources.lib, pkgs ? sources.pkgs { } }:
with builtins; with lib;
let
  mkNixOS = configuration:
    let
      nixos = import (pkgs.path + "/nixos") { inherit configuration; };
    in
    nixos.config.system.build;
  mkSystem = name: (mkNixOS name).toplevel;
  mkGceImage = name: (mkNixOS name).googleComputeImage;

  # list of names of all my systems defined in ./systems
  systems = map (n: removeSuffix ".nix" n) (attrNames (readDir ./systems));
  # attrset of form { hostname = systemDrv; ... }
  systemAttrs = genAttrs systems (n: mkSystem (./systems + "/${n}.nix"));
in
systemAttrs // {
  systems = pkgs.linkFarmFromDrvs "systems" (attrValues systemAttrs);
}
